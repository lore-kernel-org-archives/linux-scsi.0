From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] tmscsim: 64-bit cleanup
Date: 05 Jun 2004 09:02:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1086444149.1999.13.camel@mulgrave>
References: <Pine.LNX.4.44.0406042357001.5107-200000@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:53390 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261443AbUFEOCi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 Jun 2004 10:02:38 -0400
In-Reply-To: <Pine.LNX.4.44.0406042357001.5107-200000@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On Fri, 2004-06-04 at 17:17, Guennadi Liakhovetski wrote:
> On 21 May 2004, James Bottomley wrote:
> > On Wed, 2004-05-19 at 14:50, Guennadi Liakhovetski wrote:
> > > Ok, here comes the first one. I chose this one because it fixes an actual
> > > bug in the driver. This bug was (partially) introduced by myself when
> > > porting to 2.6. Partly the reason was that I disliked using
> > > function-like macros as lvalues:
> > >
> > > sg_dma_address(x) = ...
> > > sg_dma_len(x) = ...
> > >
> > > [OT] wouldn't it be better to introduce some macros like
> > > set_sg_dma_{address|len}(x, y)?
> >
> > Actually, no.  struct scatterlist is for the OS platform to use to
> > characterise DMA; it's actually a private structure entirely within the
> > gift of the architecture to define.  It usually contains bits of
> > extraneous data that the driver never sees.  The driver should convert
> > struct scatterlist into its own version of the scatterlist that needs
> > feeding to the hardware rather than try and use struct scatterlist.
> 
> Well, I don't quite understand. What about this code in block/ll_rw_blk.c:
> 	sg[nsegs].page = bvec->bv_page;
> 	sg[nsegs].length = nbytes;
> 	sg[nsegs].offset = bvec->bv_offset;
> ? So, looks like all architectures should implement these fields in struct
> scatterlist, and use them in map_sg. So, isn't it safe to use them from
> drivers in a similar way (see patch attached).

No.

struct scatterlist is defined by the platform in two halves: the block
side, which uses the three members you list above, and which, as you
say, all architectures are required to provide and the platform side
which define extra elements but use the macro accessors sg_dma_len() and
sg_dma_address().

However, if you tamper with the block side of this, you'll loose
idempotence (the property that
dma_map_sg()->dma_unmap_sg()->dma_map_sg() works).  Without this none of
the retryable error paths will work.

You should simply treat the scatterlist as an information providing
opaque structure you examine with the provided accessors.  If you try to
alter it, you'll get into trouble with the platform layer, the block
layer or both.

James


