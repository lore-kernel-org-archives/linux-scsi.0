From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Wed, 16 May 2007 20:13:27 +0200
Message-ID: <20070516181325.GT23798@kernel.dk>
References: <20070508112553C.fujita.tomonori@lab.ntt.co.jp> <4640C724.8030409@panasas.com> <1178654497.3737.81.camel@mulgrave.il.steeleye.com> <46417C5A.1090707@panasas.com> <464B3F91.1010102@panasas.com> <20070516175322.GS23798@kernel.dk> <1179338812.9602.4.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:18612 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760932AbXEPSO7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 May 2007 14:14:59 -0400
Content-Disposition: inline
In-Reply-To: <1179338812.9602.4.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, bhalevy@panasas.com, hch@infradead.org, akpm@linux-foundation.org, michaelc@cs.wisc.edu

On Wed, May 16 2007, James Bottomley wrote:
> On Wed, 2007-05-16 at 19:53 +0200, Jens Axboe wrote:
> > The 1-page thing isn't a restriction as such, it's just an optimization.
> > The scatterlist allocated is purely a kernel entity, so you could do 4
> > contig pages and larger ios that way, if higher order allocations were
> > reliable.
> > 
> > But you are right in that we need to tweak the sg pool size so that it
> > ends up being a nice size, and not something that either spans a little
> > bit into a second page or doesn't fill a page nicely. On my x86-64 here,
> > a 128 segment sg table is exactly one page (looking at slabinfo). It
> > depends on the allocator whether that is just right, or just a little
> > too much due to management information.
> 
> Actually, if you look at the slab allocation algorithm (particularly
> calculate_slab_order()) you'll find it's not as simplistic as you're
> assuming ... what it actually does is try to allocate > 1 item in n
> pages to reduce the leftovers.

I'm not assuming anything, I was just being weary of having elements
that are exactly page sized if that would cause a bit of spill into a
second page. Don't tell me that PAGE_SIZE+10 (or whatever it might be)
would ever be an optimal allocation size.

> Additionally, remember that turning on redzoning, which seems to be
> quite popular nowadays, actually blows out the slab size calculations
> anyway.

Debugging will always throw these things out the window, we can't and
should not optimize for that. That goes for slab, and for lots of other
things.

> The bottom line is that it's better for us just to do exactly what we
> need and let the allocation algorithms figure out how to do it
> efficiently rather than trying to second guess them.

Partly true, it's also silly to just hardcore power-of-2 numbers without
ever bothering to look at what that results in (or even if it fits
normal use patterns).

We can easily be flexible, so it seems silly not to at least do a bit of
background research.

-- 
Jens Axboe

