From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 3/7] sg_ring: blk_rq_map_sg_ring as a counterpart to blk_rq_map_sg.
Date: Wed, 19 Dec 2007 18:33:46 +1100
Message-ID: <200712191833.46615.rusty@rustcorp.com.au>
References: <200712191731.26512.rusty@rustcorp.com.au> <200712191733.15409.rusty@rustcorp.com.au> <200712191831.07804.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200712191831.07804.rusty@rustcorp.com.au>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

blk_rq_map_sg_ring as a counterpart to blk_rq_map_sg.

Obvious counterpart to blk_rq_map_sg.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 block/ll_rw_blk.c      |   55 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |    1 +
 2 files changed, 56 insertions(+), 0 deletions(-)

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
