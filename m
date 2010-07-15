From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 1/1] block: Apply segment size and boundary limits to integrity data
Date: Thu, 15 Jul 2010 17:34:11 +0200
Message-ID: <20100715154547.485829000@de.ibm.com>
References: <20100715153410.774329000@de.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=linux-2.6.34-blk-integrity-fix.diff
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Christof Schmitt <christof.schmitt@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Apply the conditions used in __blk_recalc_rq_segments also to
integrity data: Adhere to the maximum segment size and the segment
boundary set by the driver. Without this change, a driver would
receive integrity data blocks that do not adhere to the limits set for
the request queue.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 block/blk-integrity.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -41,15 +41,22 @@ int blk_rq_count_integrity_sg(struct req
 {
 	struct bio_vec *iv, *ivprv;
 	struct req_iterator iter;
-	unsigned int segments;
+	unsigned int segments, seg_size;
 
 	ivprv = NULL;
 	segments = 0;
+	seg_size = 0;
 
 	rq_for_each_integrity_segment(iv, rq, iter) {
 
-		if (!ivprv || !BIOVEC_PHYS_MERGEABLE(ivprv, iv))
+		if (!ivprv ||
+		    !BIOVEC_PHYS_MERGEABLE(ivprv, iv) ||
+		    seg_size + iv->bv_len > queue_max_segment_size(rq->q) ||
+		    !BIOVEC_SEG_BOUNDARY(rq->q, ivprv, iv)) {
 			segments++;
+			seg_size = iv->bv_len;
+		} else
+			seg_size += iv->bv_len;
 
 		ivprv = iv;
 	}
@@ -81,9 +88,16 @@ int blk_rq_map_integrity_sg(struct reque
 	rq_for_each_integrity_segment(iv, rq, iter) {
 
 		if (ivprv) {
+			if (sg->length + iv->bv_len
+				    > queue_max_segment_size(rq->q))
+				goto new_segment;
+
 			if (!BIOVEC_PHYS_MERGEABLE(ivprv, iv))
 				goto new_segment;
 
+			if (!BIOVEC_SEG_BOUNDARY(rq->q, ivprv, iv))
+				goto new_segment;
+
 			sg->length += iv->bv_len;
 		} else {
 new_segment:
