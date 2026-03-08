IMAGES := $(wildcard *.png *.jpg *.jpeg *.svg)
PANDOC := pandoc
SRC := outline.md

# Lulu interior geometry: 6x9, inner margin slightly wider for binding
GEOMETRY := paperwidth=6in,paperheight=9in,top=0.75in,bottom=0.75in,inner=0.875in,outer=0.625in

all: outline.epub outline.pdf cover.pdf

clean:
	rm -f outline.epub outline.pdf cover.pdf

# epub still uses cover-image from YAML frontmatter
outline.epub: $(SRC) $(IMAGES)
	$(PANDOC) $(SRC) -o $@

# Interior PDF for Lulu — no cover, xelatex for font embedding
outline.pdf: $(SRC) $(IMAGES)
	$(PANDOC) $(SRC) \
	  --pdf-engine=xelatex \
	  --top-level-division=part \
	  --toc \
	  -V documentclass=book \
	  -V fontsize=11pt \
	  -V classoption=openright \
	  -V geometry:"$(GEOMETRY)" \
	  --metadata cover-image= \
	  -o $@

# Separate cover PDF for Lulu upload (they want it as a standalone PDF)
cover.pdf: Cover6x9.png
	convert Cover6x9.png \
	  -density 300 \
	  -units PixelsPerInch \
	  -compress jpeg \
	  cover.pdf
