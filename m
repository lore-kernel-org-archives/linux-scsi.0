From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [RFC][PATCH] Direct I/O for the SCSI tapes
Date: Sun, 28 Jul 2002 14:03:16 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0207281324590.942-100000@kai.makisara.local>
References: <3D437590.8D69B132@torque.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3D437590.8D69B132@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org, ingo.oeser@informatik.tu-chemnitz.de

On Sun, 28 Jul 2002, Douglas Gilbert wrote:

...
> It was interesting to see that your patch used variants of Ingo Oeser's
> sg_map_user_pages() [see Kai's version shown below] **. My interest in
> those functions is that I would like to use them in sg (since kiobufs
> have been removed from lk 2.5). According to Ingo several other char
> drivers that previously used kiobufs are probably looking for
> replacements as well.
>
Kiobufs seem to be going out (although Linus has not yet given his
opinion) and since there is nothing equivalent in the kernel, I had to
code something. I started from Ingo's function and looked at the kiobuf,
bio, dio, and aio code and tried to use the best ideas.

> Since they are general routines of use to char drivers that
> build scatter gather lists (block drivers have bio) perhaps they
> should be placed in some common area.
>
It seems clear that there are many of us who would like to see something
like this in the kernel. I fully agreed with Ingo when he posted his
messages to lkml but no one has followed up the discussion yet.

There have been some indications on lkml that Ben LaHaise's aio and/or
kvecs would be included in 2.6. As far as I know, kvecs are quite near
what I want and st should use kvecs if they are included. We don't want
more functions mapping user buffers than necessary.

If kvecs will not be in 2.6, then we want something else. This is also
needed while waiting because it is useful to have the drivers otherwise
tested as long as possible. Here I see two viable alternatives:

1. We make functions that all the users want and agree on and try to get
these into the kernel. These would be either permanent solutions or
removed if kvecs (or something else) is introduced into the kernel. Linus
has not always been thrilled with temporary solutions.

2. Everybody makes their own temporary solution. Even in this alternative
we can agree on the interface and implementation and then the
eventual cleanup will be easy.

> Doug Gilbert
>
> ** lkml 2002-07-19 22:39:18 Ingo Oeser "Re: [never mind] kiobufs and highmem"
>
>
> Kai's st_map_user_pages() and st_unmap_user_pages() follow:
> vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
>
> static int st_map_user_pages(struct scatterlist *sgl, const unsigned int max_pages,
>                             unsigned long uaddr, size_t count, int rw,
>                             unsigned long max_pfn)

This function does contain some details tailored for st: it checks the
page accessibility and backs out if there is even one non-accessible page.
For general use, it might be better to separate this from the mapping so
that st would use

	if ((nbr_sg = cio_map_user_pages(sgl, max_pages, uaddr, count, rw)) {
		for (i=0; i < nbr_sg; i++) {
			if (page_to_pfn(sgl->page) > max_pfn) {
				cio_unmap_use_pages(sgl, 0);
				nbr_sg = 0;
			}
		}
	}

I don't think this would significantly more cycles than my current
version.

It would probably be best to do possible locking in a separate function.
There it would probably be advantageous to stop early if an unlockable
page is found (or optionally wait until the pages are unlocked). The
locking and unlocking functions can be left undefined until someone tells
what he/she needs.

I would like to see the following minimum properties in the mapping
function:
- it maps all pages or none
- it pins the pages into memory
- it returns the number of pages or error
- it returns the page pointers and page lengths (lengths will be useful if
  large pages will be implemented) and offset in first page
- it does whatever cache flushing is needed

Is the scatter/gather list the correct way to return the results? It is
convenient in many cases. However, if kvecs or something else is used in
future, mapping from those to scatter/gather list is needed. It might be
easier to code that now. The mapping function might be made to return the
results in something that looks exactly like kvecs ;-?

Any opinions?

	Kai


