From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] SPARC64: fix iommu sg chaining
Date: Wed, 17 Oct 2007 12:58:40 +0200
Message-ID: <20071017105840.GT5043@kernel.dk>
References: <20071017084528.GI5043@kernel.dk> <20071017.021305.74746838.davem@davemloft.net> <20071017091629.GK5043@kernel.dk> <20071017.035441.74746708.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:26505 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758114AbXJQK7J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Oct 2007 06:59:09 -0400
Content-Disposition: inline
In-Reply-To: <20071017.035441.74746708.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Oct 17 2007, David Miller wrote:
> From: Jens Axboe <jens.axboe@oracle.com>
> Date: Wed, 17 Oct 2007 11:16:29 +0200
> 
> > On Wed, Oct 17 2007, David Miller wrote:
> > > From: Jens Axboe <jens.axboe@oracle.com>
> > > Date: Wed, 17 Oct 2007 10:45:28 +0200
> > > 
> > > > Righto, it's invalid to call sg_next() on the last entry!
> > > 
> > > Unfortunately, that's what the sparc64 code wanted to do, this
> > > transformation in the sparc64 sg chaining patch is not equilavent:
> > > 
> > > -	struct scatterlist *sg_end = sg + nelems;
> > > +	struct scatterlist *sg_end = sg_last(sg, nelems);
> > >  ...
> > > -			while (sg < sg_end &&
> > > +			while (sg != sg_end &&
> > 
> > Auch indeed. That'd probably be better as a
> > 
> >         do {
> >                 ...
> >         } while (sg != sg_end);
> 
> Ok, next bug, introduced by this change:
> 
> commit f565913ef8a8d0cfa46a1faaf8340cc357a46f3a
> Author: Jens Axboe <jens.axboe@oracle.com>
> Date:   Fri Sep 21 10:44:19 2007 +0200
> 
>     block: convert to using sg helpers
>     
>     Convert the main rq mapper (blk_rq_map_sg()) to the sg helper setup.
>     
>     Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> 
> Specifically this part:
> 
>  new_segment:
> -			memset(&sg[nsegs],0,sizeof(struct scatterlist));
> -			sg[nsegs].page = bvec->bv_page;
> -			sg[nsegs].length = nbytes;
> -			sg[nsegs].offset = bvec->bv_offset;
> +			sg = next_sg;
> +			next_sg = sg_next(sg);
>  
> +			sg->page = bvec->bv_page;
> +			sg->length = nbytes;
> +			sg->offset = bvec->bv_offset;
> 
> You can't remove that memset(), it's there for a reason.  The IOMMU
> layers depended upon the code zero'ing out the whole scatterlist
> struct, there might be more to it than page, length and offset :-)

I realize that, and I was pretty worried about this specific change. But
there's only been one piece of fallout because if it until now - well
two, with the sparc64 stuff.

The problem is that you cannot zero the entire sg entry, because then
you'd potentially overwrite the chain pointer.

I'd propose just adding a

        sg_dma_address(sg) = 0;
        sg_dma_len(sg) = 0;

there for now, or provide an arch_clear_sg_entry() helper if we need
more killed.

-- 
Jens Axboe

