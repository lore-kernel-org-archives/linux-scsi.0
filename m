From: "'Dave Olien'" <dmo@osdl.org>
Subject: Re: [PATCH] fix for Incorrect number of segments after building list problem
Date: Thu, 14 Oct 2004 14:55:43 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041014215543.GA32307@osdl.org>
References: <1097790683.1717.47.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:56240 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S267612AbUJNVzq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Oct 2004 17:55:46 -0400
Content-Disposition: inline
In-Reply-To: <1097790683.1717.47.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>


OK, I'll apply it immediately and let you know what happens.

Dave

On Thu, Oct 14, 2004 at 04:51:16PM -0500, James Bottomley wrote:
> This is a rather nasty hack at the momen, but it seems to persuade
> blk_recalc_rq_segments() not to underestimate.
> 
> Could you try it in your setup to see if it fixes the problem?
> 
> Thanks,
> 
> James
> 
> ===== drivers/block/ll_rw_blk.c 1.271 vs edited =====
> --- 1.271/drivers/block/ll_rw_blk.c	2004-09-13 19:23:21 -05:00
> +++ edited/drivers/block/ll_rw_blk.c	2004-10-14 16:24:38 -05:00
> @@ -921,7 +921,8 @@
>  		}
>  new_segment:
>  		if (BIOVEC_VIRT_MERGEABLE(bvprv, bv) &&
> -		    !BIOVEC_VIRT_OVERSIZE(hw_seg_size + bv->bv_len)) {
> +		    !BIOVEC_VIRT_OVERSIZE(hw_seg_size + bv->bv_len) &&
> +		    hw_seg_size + bv->bv_len <= q->max_segment_size) {
>  			hw_seg_size += bv->bv_len;
>  		} else {
>  new_hw_segment:
> @@ -2723,30 +2724,49 @@
>  void blk_recalc_rq_segments(struct request *rq)
>  {
>  	struct bio *bio, *prevbio = NULL;
> -	int nr_phys_segs, nr_hw_segs;
> +	int nr_phys_segs, nr_hw_segs, tot_phys_size = 0, tot_hw_size = 0;
>  
>  	if (!rq->bio)
>  		return;
>  
>  	nr_phys_segs = nr_hw_segs = 0;
>  	rq_for_each_bio(bio, rq) {
> +		int bi_phys_segs, bi_hw_segs;
>  		/* Force bio hw/phys segs to be recalculated. */
>  		bio->bi_flags &= ~(1 << BIO_SEG_VALID);
>  
> -		nr_phys_segs += bio_phys_segments(rq->q, bio);
> -		nr_hw_segs += bio_hw_segments(rq->q, bio);
> +		bi_phys_segs = bio_phys_segments(rq->q, bio);
> +		bi_hw_segs = bio_hw_segments(rq->q, bio);
> +		nr_phys_segs += bi_phys_segs;
> +		nr_hw_segs += bi_hw_segs;
>  		if (prevbio) {
> -			if (blk_phys_contig_segment(rq->q, prevbio, bio))
> +			if (blk_phys_contig_segment(rq->q, prevbio, bio) &&
> +			    bio->bi_size + tot_phys_size < rq->q->max_segment_size)
>  				nr_phys_segs--;
> -			if (blk_hw_contig_segment(rq->q, prevbio, bio))
> +			else
> +				tot_phys_size = 0;
> +			if (blk_hw_contig_segment(rq->q, prevbio, bio) &&
> +			    bio->bi_size + tot_hw_size < rq->q->max_segment_size)
>  				nr_hw_segs--;
> +			else
> +				tot_hw_size = 0;
>  		}
> +		if (bi_phys_segs > 1)
> +			tot_phys_size = bio->bi_size;
> +		else
> +			tot_phys_size += bio->bi_size;
> +		if (bi_hw_segs > 1)
> +			tot_hw_size = bio->bi_size;
> +		else
> +			tot_hw_size += bio->bi_size;
> +
>  		prevbio = bio;
>  	}
>  
>  	rq->nr_phys_segments = nr_phys_segs;
>  	rq->nr_hw_segments = nr_hw_segs;
>  }
> +EXPORT_SYMBOL(blk_recalc_rq_segments);
>  
>  void blk_recalc_rq_sectors(struct request *rq, int nsect)
>  {
