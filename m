From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 3/5] blk_rq_map_sg_ring as a counterpart to blk_rq_map_sg.
Date: Thu, 20 Dec 2007 16:50:42 +1100
Message-ID: <200712201650.42299.rusty@rustcorp.com.au>
References: <200712201645.19035.rusty@rustcorp.com.au> <200712201648.58480.rusty@rustcorp.com.au> <200712201649.31254.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:52179 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbXLTFuu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Dec 2007 00:50:50 -0500
In-Reply-To: <200712201649.31254.rusty@rustcorp.com.au>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>

Obvious counterpart to blk_rq_map_sg.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -31,6 +31,7 @@
 #include <linux/blktrace_api.h>
 #include <linux/fault-inject.h>
 #include <linux/scatterlist.h>
+#include <linux/sg_ring.h>
 
 /*
  * for max sense size
@@ -1364,6 +1365,68 @@ new_segment:
 
 EXPORT_SYMBOL(blk_rq_map_sg);
 
+/**
+ * blk_rq_map_sg_ring - map a request to a scatterlist ring.
+ * @q: the request queue this request applies to.
+ * @rq: the request to map
+ * @sg: the sg_ring to populate.
+ *
+ * There must be enough elements in the sg_ring(s) to map the request.
+ */
+void blk_rq_map_sg_ring(struct request_queue *q, struct request *rq,
+			struct sg_ring *sg)
+{
+	struct bio_vec *bvec, *bvprv;
+	struct req_iterator iter;
+	int i, cluster;
+	struct sg_ring *head = sg;
+	struct scatterlist *sgprv;
+
+	i = 0;
+	cluster = q->queue_flags & (1 << QUEUE_FLAG_CLUSTER);
+
+	/*
+	 * for each bio in rq
+	 */
+	bvprv = NULL;
+	sgprv = NULL;
+	rq_for_each_segment(bvec, rq, iter) {
+		int nbytes = bvec->bv_len;
+
+		if (bvprv && cluster) {
+			if (sgprv->length + nbytes > q->max_segment_size)
+				goto new_segment;
+
+			if (!BIOVEC_PHYS_MERGEABLE(bvprv, bvec))
+				goto new_segment;
+			if (!BIOVEC_SEG_BOUNDARY(q, bvprv, bvec))
+				goto new_segment;
+
+			sgprv->length += nbytes;
+		} else {
+new_segment:
+			sg_set_page(sg->sg + i, bvec->bv_page, nbytes,
+				    bvec->bv_offset);
+			sgprv = sg->sg + i;
+			if (++i == sg->max) {
+				sg->num = i;
+				sg = sg_ring_next(sg, head);
+				i = 0;
+			}
+		}
+		bvprv = bvec;
+	} /* segments in rq */
+
+	/* If we were still working on an sg_ring, set the number and
+	 * clear any following sg_rings. */
+	if (sg) {
+		sg->num = i;
+		for (sg = sg_ring_next(sg,head); sg; sg = sg_ring_next(sg,head))
+			sg->num = 0;
+	}
+}
+EXPORT_SYMBOL(blk_rq_map_sg_ring);
+
 /*
  * the standard queue merge functions, can be overridden with device
  * specific ones if so desired
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -777,6 +777,8 @@ extern void blk_ordered_complete_seq(str
 extern void blk_ordered_complete_seq(struct request_queue *, unsigned, int);
 
 extern int blk_rq_map_sg(struct request_queue *, struct request *, struct scatterlist *);
+struct sg_ring;
+extern void blk_rq_map_sg_ring(struct request_queue *, struct request *, struct sg_ring *);
 extern void blk_dump_rq_flags(struct request *, char *);
 extern void generic_unplug_device(struct request_queue *);
 extern void __generic_unplug_device(struct request_queue *);
