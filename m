From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] fix for Incorrect number of segments after building list
	problem
Date: 14 Oct 2004 16:51:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1097790683.1717.47.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:49891 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267984AbUJNVvh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Oct 2004 17:51:37 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Dave Olien' <dmo@osdl.org>, Jens Axboe <axboe@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a rather nasty hack at the momen, but it seems to persuade
blk_recalc_rq_segments() not to underestimate.

Could you try it in your setup to see if it fixes the problem?

Thanks,

James

===== drivers/block/ll_rw_blk.c 1.271 vs edited =====
--- 1.271/drivers/block/ll_rw_blk.c	2004-09-13 19:23:21 -05:00
+++ edited/drivers/block/ll_rw_blk.c	2004-10-14 16:24:38 -05:00
@@ -921,7 +921,8 @@
 		}
 new_segment:
 		if (BIOVEC_VIRT_MERGEABLE(bvprv, bv) &&
-		    !BIOVEC_VIRT_OVERSIZE(hw_seg_size + bv->bv_len)) {
+		    !BIOVEC_VIRT_OVERSIZE(hw_seg_size + bv->bv_len) &&
+		    hw_seg_size + bv->bv_len <= q->max_segment_size) {
 			hw_seg_size += bv->bv_len;
 		} else {
 new_hw_segment:
@@ -2723,30 +2724,49 @@
 void blk_recalc_rq_segments(struct request *rq)
 {
 	struct bio *bio, *prevbio = NULL;
-	int nr_phys_segs, nr_hw_segs;
+	int nr_phys_segs, nr_hw_segs, tot_phys_size = 0, tot_hw_size = 0;
 
 	if (!rq->bio)
 		return;
 
 	nr_phys_segs = nr_hw_segs = 0;
 	rq_for_each_bio(bio, rq) {
+		int bi_phys_segs, bi_hw_segs;
 		/* Force bio hw/phys segs to be recalculated. */
 		bio->bi_flags &= ~(1 << BIO_SEG_VALID);
 
-		nr_phys_segs += bio_phys_segments(rq->q, bio);
-		nr_hw_segs += bio_hw_segments(rq->q, bio);
+		bi_phys_segs = bio_phys_segments(rq->q, bio);
+		bi_hw_segs = bio_hw_segments(rq->q, bio);
+		nr_phys_segs += bi_phys_segs;
+		nr_hw_segs += bi_hw_segs;
 		if (prevbio) {
-			if (blk_phys_contig_segment(rq->q, prevbio, bio))
+			if (blk_phys_contig_segment(rq->q, prevbio, bio) &&
+			    bio->bi_size + tot_phys_size < rq->q->max_segment_size)
 				nr_phys_segs--;
-			if (blk_hw_contig_segment(rq->q, prevbio, bio))
+			else
+				tot_phys_size = 0;
+			if (blk_hw_contig_segment(rq->q, prevbio, bio) &&
+			    bio->bi_size + tot_hw_size < rq->q->max_segment_size)
 				nr_hw_segs--;
+			else
+				tot_hw_size = 0;
 		}
+		if (bi_phys_segs > 1)
+			tot_phys_size = bio->bi_size;
+		else
+			tot_phys_size += bio->bi_size;
+		if (bi_hw_segs > 1)
+			tot_hw_size = bio->bi_size;
+		else
+			tot_hw_size += bio->bi_size;
+
 		prevbio = bio;
 	}
 
 	rq->nr_phys_segments = nr_phys_segs;
 	rq->nr_hw_segments = nr_hw_segs;
 }
+EXPORT_SYMBOL(blk_recalc_rq_segments);
 
 void blk_recalc_rq_sectors(struct request *rq, int nsect)
 {

