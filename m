From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] block: fix nr_phys_segments miscalculation bug
Date: Sat, 11 Oct 2008 15:31:36 +0900
Message-ID: <20081011153048E.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:46509 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbYJKGcX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Oct 2008 02:32:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, knikanth@suse.de

This is against the latest git (b922df7383749a1c0b7ea64c50fa839263d3816b).

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] block: fix nr_phys_segments miscalculation bug

This fixes the bug reported by Nikanth Karthikesan <knikanth@suse.de>:

http://lkml.org/lkml/2008/10/2/203

The root cause of the bug is that blk_phys_contig_segment
miscalculates q->max_segment_size.

blk_phys_contig_segment checks:

req->biotail->bi_size + next_req->bio->bi_size > q->max_segment_size

But blk_recalc_rq_segments might expect that req->biotail and the
previous bio in the req are supposed be merged into one
segment. blk_recalc_rq_segments might also expect that next_req->bio
and the next bio in the next_req are supposed be merged into one
segment. In such case, we merge two requests that can't be merged
here. Later, blk_rq_map_sg gives more segments than it should.

We need to keep track of segment size in blk_recalc_rq_segments and
use it to see if two requests can be merged. This patch implements it
in the similar way that we used to do for hw merging (virtual
merging).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/blk-merge.c   |   20 ++++++++++++++++++--
 include/linux/bio.h |    7 +++++++
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 908d3e1..8681cd6 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -77,12 +77,20 @@ void blk_recalc_rq_segments(struct request *rq)
 			continue;
 		}
 new_segment:
+		if (nr_phys_segs == 1 && seg_size > rq->bio->bi_seg_front_size)
+			rq->bio->bi_seg_front_size = seg_size;
+
 		nr_phys_segs++;
 		bvprv = bv;
 		seg_size = bv->bv_len;
 		highprv = high;
 	}
 
+	if (nr_phys_segs == 1 && seg_size > rq->bio->bi_seg_front_size)
+		rq->bio->bi_seg_front_size = seg_size;
+	if (seg_size > rq->biotail->bi_seg_back_size)
+		rq->biotail->bi_seg_back_size = seg_size;
+
 	rq->nr_phys_segments = nr_phys_segs;
 }
 
@@ -106,7 +114,8 @@ static int blk_phys_contig_segment(struct request_queue *q, struct bio *bio,
 	if (!test_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags))
 		return 0;
 
-	if (bio->bi_size + nxt->bi_size > q->max_segment_size)
+	if (bio->bi_seg_back_size + nxt->bi_seg_front_size >
+	    q->max_segment_size)
 		return 0;
 
 	if (!bio_has_data(bio))
@@ -309,6 +318,8 @@ static int ll_merge_requests_fn(struct request_queue *q, struct request *req,
 				struct request *next)
 {
 	int total_phys_segments;
+	unsigned int seg_size =
+		req->biotail->bi_seg_back_size + next->bio->bi_seg_front_size;
 
 	/*
 	 * First check if the either of the requests are re-queued
@@ -324,8 +335,13 @@ static int ll_merge_requests_fn(struct request_queue *q, struct request *req,
 		return 0;
 
 	total_phys_segments = req->nr_phys_segments + next->nr_phys_segments;
-	if (blk_phys_contig_segment(q, req->biotail, next->bio))
+	if (blk_phys_contig_segment(q, req->biotail, next->bio)) {
+		if (req->nr_phys_segments == 1)
+			req->bio->bi_seg_front_size = seg_size;
+		if (next->nr_phys_segments == 1)
+			next->biotail->bi_seg_back_size = seg_size;
 		total_phys_segments--;
+	}
 
 	if (total_phys_segments > q->max_phys_segments)
 		return 0;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index ff5b4cf..dc3cec3 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -79,6 +79,13 @@ struct bio {
 
 	unsigned int		bi_size;	/* residual I/O count */
 
+	/*
+	 * To keep track of the max segment size, we account for the
+	 * sizes of the first and last mergeable segments in this bio.
+	 */
+	unsigned int		bi_seg_front_size;
+	unsigned int		bi_seg_back_size;
+
 	unsigned int		bi_max_vecs;	/* max bvl_vecs we can hold */
 
 	unsigned int		bi_comp_cpu;	/* completion CPU */
-- 
1.5.5.GIT

