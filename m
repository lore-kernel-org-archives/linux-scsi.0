From: "'Dave Olien'" <dmo@osdl.org>
Subject: Re: [PATCH] fix for Incorrect number of segments after building list problem
Date: Thu, 14 Oct 2004 15:51:31 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041014225131.GA32475@osdl.org>
References: <1097790683.1717.47.camel@mulgrave> <20041014221503.GA32396@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:13021 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S268120AbUJNWvj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Oct 2004 18:51:39 -0400
Content-Disposition: inline
In-Reply-To: <20041014221503.GA32396@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>


James,

I'm running through the dm multipath driver now.  The problems
I was having through dm (which is where this all started) have also been
solved.  So it seems your patch is an effective fix.

I'll let this run overnight, and see if any errors occur during
the night.

By the way, I've only looked briefly at the write barrier
implementation in the block layer and IO schedulers.  So I'm
pretty naive.  Does this requeuing of SCSI requests in scsi_lib.c
potentially defeat the write barrier code?

Thanks,
Dave


On Thu, Oct 14, 2004 at 03:15:03PM -0700, 'Dave Olien' wrote:
> 
> James,
> 
> I'm running your patch right now and watching for errors.
> After 10 minutes, everything looks good.  Usually the
> Incorrect segment count errors show up almost immediately.
> 
> I'd say this patch fixes my problem.
> 
> Now, I'll retry the dm multipath driver, and see if it triggers
> any problems.
> 
> If you come up with a final patch you'd like me to test, just
> send it my way.
> 
> Thanks!
> Dave
> 
> On Thu, Oct 14, 2004 at 04:51:16PM -0500, James Bottomley wrote:
> > This is a rather nasty hack at the momen, but it seems to persuade
> > blk_recalc_rq_segments() not to underestimate.
> > 
> > Could you try it in your setup to see if it fixes the problem?
> > 
> > Thanks,
> > 
> > James
> > 
> > ===== drivers/block/ll_rw_blk.c 1.271 vs edited =====
> > --- 1.271/drivers/block/ll_rw_blk.c	2004-09-13 19:23:21 -05:00
> > +++ edited/drivers/block/ll_rw_blk.c	2004-10-14 16:24:38 -05:00
> > @@ -921,7 +921,8 @@
> >  		}
> >  new_segment:
> >  		if (BIOVEC_VIRT_MERGEABLE(bvprv, bv) &&
> > -		    !BIOVEC_VIRT_OVERSIZE(hw_seg_size + bv->bv_len)) {
> > +		    !BIOVEC_VIRT_OVERSIZE(hw_seg_size + bv->bv_len) &&
> > +		    hw_seg_size + bv->bv_len <= q->max_segment_size) {
> >  			hw_seg_size += bv->bv_len;
> >  		} else {
> >  new_hw_segment:
> > @@ -2723,30 +2724,49 @@
> >  void blk_recalc_rq_segments(struct request *rq)
> >  {
> >  	struct bio *bio, *prevbio = NULL;
> > -	int nr_phys_segs, nr_hw_segs;
> > +	int nr_phys_segs, nr_hw_segs, tot_phys_size = 0, tot_hw_size = 0;
> >  
> >  	if (!rq->bio)
> >  		return;
> >  
> >  	nr_phys_segs = nr_hw_segs = 0;
> >  	rq_for_each_bio(bio, rq) {
> > +		int bi_phys_segs, bi_hw_segs;
> >  		/* Force bio hw/phys segs to be recalculated. */
> >  		bio->bi_flags &= ~(1 << BIO_SEG_VALID);
> >  
> > -		nr_phys_segs += bio_phys_segments(rq->q, bio);
> > -		nr_hw_segs += bio_hw_segments(rq->q, bio);
> > +		bi_phys_segs = bio_phys_segments(rq->q, bio);
> > +		bi_hw_segs = bio_hw_segments(rq->q, bio);
> > +		nr_phys_segs += bi_phys_segs;
> > +		nr_hw_segs += bi_hw_segs;
> >  		if (prevbio) {
> > -			if (blk_phys_contig_segment(rq->q, prevbio, bio))
> > +			if (blk_phys_contig_segment(rq->q, prevbio, bio) &&
> > +			    bio->bi_size + tot_phys_size < rq->q->max_segment_size)
> >  				nr_phys_segs--;
> > -			if (blk_hw_contig_segment(rq->q, prevbio, bio))
> > +			else
> > +				tot_phys_size = 0;
> > +			if (blk_hw_contig_segment(rq->q, prevbio, bio) &&
> > +			    bio->bi_size + tot_hw_size < rq->q->max_segment_size)
> >  				nr_hw_segs--;
> > +			else
> > +				tot_hw_size = 0;
> >  		}
> > +		if (bi_phys_segs > 1)
> > +			tot_phys_size = bio->bi_size;
> > +		else
> > +			tot_phys_size += bio->bi_size;
> > +		if (bi_hw_segs > 1)
> > +			tot_hw_size = bio->bi_size;
> > +		else
> > +			tot_hw_size += bio->bi_size;
> > +
> >  		prevbio = bio;
> >  	}
> >  
> >  	rq->nr_phys_segments = nr_phys_segs;
> >  	rq->nr_hw_segments = nr_hw_segs;
> >  }
> > +EXPORT_SYMBOL(blk_recalc_rq_segments);
> >  
> >  void blk_recalc_rq_sectors(struct request *rq, int nsect)
> >  {
> > 
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
