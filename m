From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] tmscsim: 64-bit cleanup
Date: Sat, 5 Jun 2004 22:37:24 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0406052041470.1534-100000@poirot.grange>
References: <1086444149.1999.13.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:50325 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S261907AbUFEUiN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Jun 2004 16:38:13 -0400
In-Reply-To: <1086444149.1999.13.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On 5 Jun 2004, James Bottomley wrote:

> On Fri, 2004-06-04 at 17:17, Guennadi Liakhovetski wrote:
> > Well, I don't quite understand. What about this code in block/ll_rw_blk.c:
> > 	sg[nsegs].page = bvec->bv_page;
> > 	sg[nsegs].length = nbytes;
> > 	sg[nsegs].offset = bvec->bv_offset;
> > ? So, looks like all architectures should implement these fields in struct
> > scatterlist, and use them in map_sg. So, isn't it safe to use them from
> > drivers in a similar way (see patch attached).
>
> No.
>
> struct scatterlist is defined by the platform in two halves: the block
> side, which uses the three members you list above, and which, as you
> say, all architectures are required to provide and the platform side
> which define extra elements but use the macro accessors sg_dma_len() and
> sg_dma_address().
>
> However, if you tamper with the block side of this, you'll loose
> idempotence (the property that
> dma_map_sg()->dma_unmap_sg()->dma_map_sg() works).  Without this none of
> the retryable error paths will work.

Thanks for replies and explanations, James! But could you, please, just
explain a bit more - what and how do I break with this patch? I just use a
driver-private scatterlist struct (SRB.Segmentx) to set up a
single-segment sg-list, and call pci_map_sg() on it. If I do it wrong - it
could be fixed. But why it is bad in principle? Advantages - no need to
check if sg is used for this particular command throughout the code.

But no problem. I'll redo the patch without private sg.

Thanks
Guennadi
---
Guennadi Liakhovetski


