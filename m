From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] SPARC64: fix iommu sg chaining
Date: Wed, 17 Oct 2007 21:05:35 +0900
Message-ID: <20071017210535K.fujita.tomonori@lab.ntt.co.jp>
References: <20071017203758E.fujita.tomonori@lab.ntt.co.jp>
	<20071017114117.GA5043@kernel.dk>
	<20071017205717Q.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:57715 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820AbXJQMF6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 08:05:58 -0400
In-Reply-To: <20071017205717Q.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp
Cc: jens.axboe@oracle.com, davem@davemloft.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, tomof@acm.org

On Wed, 17 Oct 2007 20:57:17 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Wed, 17 Oct 2007 13:41:17 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Wed, Oct 17 2007, FUJITA Tomonori wrote:
> > > On Wed, 17 Oct 2007 13:01:42 +0200
> > > Jens Axboe <jens.axboe@oracle.com> wrote:
> > > 
> > > > On Wed, Oct 17 2007, Jens Axboe wrote:
> > > > > On Wed, Oct 17 2007, David Miller wrote:
> > > > > > From: Jens Axboe <jens.axboe@oracle.com>
> > > > > > Date: Wed, 17 Oct 2007 11:16:29 +0200
> > > > > > 
> > > > > > > On Wed, Oct 17 2007, David Miller wrote:
> > > > > > > > From: Jens Axboe <jens.axboe@oracle.com>
> > > > > > > > Date: Wed, 17 Oct 2007 10:45:28 +0200
> > > > > > > > 
> > > > > > > > > Righto, it's invalid to call sg_next() on the last entry!
> > > > > > > > 
> > > > > > > > Unfortunately, that's what the sparc64 code wanted to do, this
> > > > > > > > transformation in the sparc64 sg chaining patch is not equilavent:
> > > > > > > > 
> > > > > > > > -	struct scatterlist *sg_end = sg + nelems;
> > > > > > > > +	struct scatterlist *sg_end = sg_last(sg, nelems);
> > > > > > > >  ...
> > > > > > > > -			while (sg < sg_end &&
> > > > > > > > +			while (sg != sg_end &&
> > > > > > > 
> > > > > > > Auch indeed. That'd probably be better as a
> > > > > > > 
> > > > > > >         do {
> > > > > > >                 ...
> > > > > > >         } while (sg != sg_end);
> > > > > > 
> > > > > > Ok, next bug, introduced by this change:
> > > > > > 
> > > > > > commit f565913ef8a8d0cfa46a1faaf8340cc357a46f3a
> > > > > > Author: Jens Axboe <jens.axboe@oracle.com>
> > > > > > Date:   Fri Sep 21 10:44:19 2007 +0200
> > > > > > 
> > > > > >     block: convert to using sg helpers
> > > > > >     
> > > > > >     Convert the main rq mapper (blk_rq_map_sg()) to the sg helper setup.
> > > > > >     
> > > > > >     Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > > > > > 
> > > > > > Specifically this part:
> > > > > > 
> > > > > >  new_segment:
> > > > > > -			memset(&sg[nsegs],0,sizeof(struct scatterlist));
> > > > > > -			sg[nsegs].page = bvec->bv_page;
> > > > > > -			sg[nsegs].length = nbytes;
> > > > > > -			sg[nsegs].offset = bvec->bv_offset;
> > > > > > +			sg = next_sg;
> > > > > > +			next_sg = sg_next(sg);
> > > > > >  
> > > > > > +			sg->page = bvec->bv_page;
> > > > > > +			sg->length = nbytes;
> > > > > > +			sg->offset = bvec->bv_offset;
> > > > > > 
> > > > > > You can't remove that memset(), it's there for a reason.  The IOMMU
> > > > > > layers depended upon the code zero'ing out the whole scatterlist
> > > > > > struct, there might be more to it than page, length and offset :-)
> > > > > 
> > > > > I realize that, and I was pretty worried about this specific change. But
> > > > > there's only been one piece of fallout because if it until now - well
> > > > > two, with the sparc64 stuff.
> > > > > 
> > > > > The problem is that you cannot zero the entire sg entry, because then
> > > > > you'd potentially overwrite the chain pointer.
> > > > > 
> > > > > I'd propose just adding a
> > > > > 
> > > > >         sg_dma_address(sg) = 0;
> > > > >         sg_dma_len(sg) = 0;
> > > > > 
> > > > > there for now, or provide an arch_clear_sg_entry() helper if we need
> > > > > more killed.
> > > > 
> > > > Actually, just clearing AFTER sg_next() would be fine, since we know
> > > > that is not a link entry. Duh...
> > > > 
> > > > diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
> > > > index 9eabac9..1014d34 100644
> > > > --- a/block/ll_rw_blk.c
> > > > +++ b/block/ll_rw_blk.c
> > > > @@ -1352,6 +1352,7 @@ new_segment:
> > > >  			sg = next_sg;
> > > >  			next_sg = sg_next(sg);
> > > >  
> > > > +			memset(sg, 0, sizeof(*sg));
> > > >  			sg->page = bvec->bv_page;
> > > >  			sg->length = nbytes;
> > > >  			sg->offset = bvec->bv_offset;
> > > > 
> > > > -- 
> > > 
> > > So now how about removing zero'ing out sglist in scsi-ml?
> > > 
> > > 
> > > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > > index aac8a02..0c86be7 100644
> > > --- a/drivers/scsi/scsi_lib.c
> > > +++ b/drivers/scsi/scsi_lib.c
> > > @@ -764,8 +764,6 @@ struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
> > >  		if (unlikely(!sgl))
> > >  			goto enomem;
> > >  
> > > -		memset(sgl, 0, sizeof(*sgl) * sgp->size);
> > > -
> > >  		/*
> > >  		 * first loop through, set initial index and return value
> > >  		 */
> > 
> > Sure, that should be quite alright then. I'll add it.
> 
> Thanks, it would be. Before sg chaining, scsi-ml didn't zero out.

Oops, it should be.


> I think that it would be better that IOMMU code handles uninitialized
> sg entries (sg list can be pretty large). Execpt for sparc64, the
> IOMMU code can do, I think.

And I think that with this patch, sparc64 can handle it:

http://marc.info/?l=linux-scsi&m=119261920425120&w=2
