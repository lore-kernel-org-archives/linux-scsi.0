From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] fix for Incorrect number of segments after building list problem
Date: Wed, 20 Oct 2004 17:07:08 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041020150708.GN10531@suse.de>
References: <1097790683.1717.47.camel@mulgrave> <20041020143940.GK10531@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:37003 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S268166AbUJTPHn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Oct 2004 11:07:43 -0400
Content-Disposition: inline
In-Reply-To: <20041020143940.GK10531@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: 'Dave Olien' <dmo@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Oct 20 2004, Jens Axboe wrote:
> On Thu, Oct 14 2004, James Bottomley wrote:
> > This is a rather nasty hack at the momen, but it seems to persuade
> > blk_recalc_rq_segments() not to underestimate.
> > 
> > Could you try it in your setup to see if it fixes the problem?
> 
> Strange how this survived so long, thanks for debugging this James. The
> patch does look a little hackish, I'll see if I can beat it into
> submission.

Should this be enough to fix it?

===== drivers/block/ll_rw_blk.c 1.273 vs edited =====
--- 1.273/drivers/block/ll_rw_blk.c	2004-10-19 11:40:18 +02:00
+++ edited/drivers/block/ll_rw_blk.c	2004-10-20 17:06:12 +02:00
@@ -922,9 +922,10 @@
 		}
 new_segment:
 		if (BIOVEC_VIRT_MERGEABLE(bvprv, bv) &&
-		    !BIOVEC_VIRT_OVERSIZE(hw_seg_size + bv->bv_len)) {
+		    !BIOVEC_VIRT_OVERSIZE(hw_seg_size + bv->bv_len) &&
+		    hw_seg_size + bv->bv_len <= q->max_segment_size)
 			hw_seg_size += bv->bv_len;
-		} else {
+		else {
 new_hw_segment:
 			if (hw_seg_size > bio->bi_hw_front_size)
 				bio->bi_hw_front_size = hw_seg_size;
@@ -2766,22 +2767,36 @@
 {
 	struct bio *bio, *prevbio = NULL;
 	int nr_phys_segs, nr_hw_segs;
+	unsigned int phys_size, hw_size;
+	request_queue_t *q = rq->q;
 
 	if (!rq->bio)
 		return;
 
-	nr_phys_segs = nr_hw_segs = 0;
+	phys_size = hw_size = nr_phys_segs = nr_hw_segs = 0;
 	rq_for_each_bio(bio, rq) {
 		/* Force bio hw/phys segs to be recalculated. */
 		bio->bi_flags &= ~(1 << BIO_SEG_VALID);
 
-		nr_phys_segs += bio_phys_segments(rq->q, bio);
-		nr_hw_segs += bio_hw_segments(rq->q, bio);
+		nr_phys_segs += bio_phys_segments(q, bio);
+		nr_hw_segs += bio_hw_segments(q, bio);
 		if (prevbio) {
-			if (blk_phys_contig_segment(rq->q, prevbio, bio))
+			int pseg = phys_size + prevbio->bi_size + bio->bi_size;
+			int hseg = hw_size + prevbio->bi_size + bio->bi_size;
+
+			if (blk_phys_contig_segment(q, prevbio, bio) &&
+			    pseg <= q->max_segment_size) {
 				nr_phys_segs--;
-			if (blk_hw_contig_segment(rq->q, prevbio, bio))
+				phys_size += prevbio->bi_size + bio->bi_size;
+			} else
+				phys_size = 0;
+
+			if (blk_hw_contig_segment(q, prevbio, bio) &&
+			    hseg <= q->max_segment_size) {
 				nr_hw_segs--;
+				hw_size += prevbio->bi_size + bio->bi_size;
+			} else
+				hw_size = 0;
 		}
 		prevbio = bio;
 	}

-- 
Jens Axboe

