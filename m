From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 03/33] block: convert to using sg helpers
Date: Mon, 16 Jul 2007 21:14:18 +0200
Message-ID: <20070716191417.GK5195@kernel.dk>
References: <11845792671245-git-send-email-jens.axboe@oracle.com> <11845792672399-git-send-email-jens.axboe@oracle.com> <200707162121.32936.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:14327 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761292AbXGPTO6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 15:14:58 -0400
Content-Disposition: inline
In-Reply-To: <200707162121.32936.bzolnier@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Jul 16 2007, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Monday 16 July 2007, Jens Axboe wrote:
> > Convert the main rq mapper (blk_rq_map_sg()) to the sg helper setup.
> > 
> > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > ---
> >  block/ll_rw_blk.c |   19 ++++++++++++-------
> >  1 files changed, 12 insertions(+), 7 deletions(-)
> > 
> > diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
> > index ef42bb2..ab71087 100644
> > --- a/block/ll_rw_blk.c
> > +++ b/block/ll_rw_blk.c
> > @@ -30,6 +30,7 @@
> >  #include <linux/cpu.h>
> >  #include <linux/blktrace_api.h>
> >  #include <linux/fault-inject.h>
> > +#include <linux/scatterlist.h>
> >  
> >  /*
> >   * for max sense size
> > @@ -1307,9 +1308,11 @@ static int blk_hw_contig_segment(request_queue_t *q, struct bio *bio,
> >   * map a request to scatterlist, return number of sg entries setup. Caller
> >   * must make sure sg can hold rq->nr_phys_segments entries
> >   */
> > -int blk_rq_map_sg(request_queue_t *q, struct request *rq, struct scatterlist *sg)
> > +int blk_rq_map_sg(request_queue_t *q, struct request *rq,
> > +		  struct scatterlist *sglist)
> >  {
> >  	struct bio_vec *bvec, *bvprv;
> > +	struct scatterlist *next_sg, *sg;
> >  	struct bio *bio;
> >  	int nsegs, i, cluster;
> >  
> > @@ -1320,6 +1323,7 @@ int blk_rq_map_sg(request_queue_t *q, struct request *rq, struct scatterlist *sg
> >  	 * for each bio in rq
> >  	 */
> >  	bvprv = NULL;
> > +	sg = next_sg = &sglist[0];
> >  	rq_for_each_bio(bio, rq) {
> >  		/*
> >  		 * for each segment in bio
> > @@ -1328,7 +1332,7 @@ int blk_rq_map_sg(request_queue_t *q, struct request *rq, struct scatterlist *sg
> >  			int nbytes = bvec->bv_len;
> >  
> >  			if (bvprv && cluster) {
> > -				if (sg[nsegs - 1].length + nbytes > q->max_segment_size)
> > +				if (sg->length + nbytes > q->max_segment_size)
> >  					goto new_segment;
> >  
> >  				if (!BIOVEC_PHYS_MERGEABLE(bvprv, bvec))
> > @@ -1336,14 +1340,15 @@ int blk_rq_map_sg(request_queue_t *q, struct request *rq, struct scatterlist *sg
> >  				if (!BIOVEC_SEG_BOUNDARY(q, bvprv, bvec))
> >  					goto new_segment;
> >  
> > -				sg[nsegs - 1].length += nbytes;
> > +				sg->length += nbytes;
> >  			} else {
> >  new_segment:
> > -				memset(&sg[nsegs],0,sizeof(struct scatterlist));
> 
> Is this intended?  If so why this is no longer needed?

It is, actually it's even required. All fields input fields should be
set, the mapping/iommu helpers should set all output fields.

But I understand your concerns, it's definitely something that should be
kept an eye on. And I have so far. I even listed it as the primary
concern in an email (off list) to Tomo today.

-- 
Jens Axboe

