From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 3/5] block: implement request_queue->dma_drain_needed
Date: Tue,  5 Feb 2008 16:53:03 +0900
Message-ID: <12021979863240-git-send-email-htejun@gmail.com>
References: <12021979851743-git-send-email-htejun@gmail.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <12021979851743-git-send-email-htejun@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, Jens.Axboe@oracle.com
Cc: Tejun Heo <htejun@gmail.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

Draining shouldn't be done for commands where overflow may indicate
data integrity issues.  Add dma_drain_needed callback to
request_queue.  Drain buffer is appened iff this function returns
non-zero.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 block/blk-merge.c      |    2 +-
 block/blk-settings.c   |    7 +++++--
 include/linux/blkdev.h |    7 +++++--
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 480d2bc..d50cfc8 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -220,7 +220,7 @@ new_segment:
 		bvprv = bvec;
 	} /* segments in rq */
 
-	if (q->dma_drain_size) {
+	if (q->dma_drain_size && q->dma_drain_needed(rq)) {
 		sg->page_link &= ~0x02;
 		sg = sg_next(sg);
 		sg_set_page(sg, virt_to_page(q->dma_drain_buffer),
diff --git a/block/blk-settings.c b/block/blk-settings.c
index c8d0c57..0a0b3a4 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -296,6 +296,7 @@ EXPORT_SYMBOL(blk_queue_stack_limits);
  * blk_queue_dma_drain - Set up a drain buffer for excess dma.
  *
  * @q:  the request queue for the device
+ * @dma_drain_needed: fn which returns non-zero if drain is necessary
  * @buf:	physically contiguous buffer
  * @size:	size of the buffer in bytes
  *
@@ -315,14 +316,16 @@ EXPORT_SYMBOL(blk_queue_stack_limits);
  * device can support otherwise there won't be room for the drain
  * buffer.
  */
-int blk_queue_dma_drain(struct request_queue *q, void *buf,
-				unsigned int size)
+extern int blk_queue_dma_drain(struct request_queue *q,
+			       dma_drain_needed_fn *dma_drain_needed,
+			       void *buf, unsigned int size)
 {
 	if (q->max_hw_segments < 2 || q->max_phys_segments < 2)
 		return -EINVAL;
 	/* make room for appending the drain */
 	--q->max_hw_segments;
 	--q->max_phys_segments;
+	q->dma_drain_needed = dma_drain_needed;
 	q->dma_drain_buffer = buf;
 	q->dma_drain_size = size;
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ee0b021..3912c5d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -257,6 +257,7 @@ struct bio_vec;
 typedef int (merge_bvec_fn) (struct request_queue *, struct bio *, struct bio_vec *);
 typedef void (prepare_flush_fn) (struct request_queue *, struct request *);
 typedef void (softirq_done_fn)(struct request *);
+typedef int (dma_drain_needed_fn)(struct request *);
 
 enum blk_queue_state {
 	Queue_down,
@@ -293,6 +294,7 @@ struct request_queue
 	merge_bvec_fn		*merge_bvec_fn;
 	prepare_flush_fn	*prepare_flush_fn;
 	softirq_done_fn		*softirq_done_fn;
+	dma_drain_needed_fn	*dma_drain_needed;
 
 	/*
 	 * Dispatch queue sorting
@@ -697,8 +699,9 @@ extern void blk_queue_max_hw_segments(struct request_queue *, unsigned short);
 extern void blk_queue_max_segment_size(struct request_queue *, unsigned int);
 extern void blk_queue_hardsect_size(struct request_queue *, unsigned short);
 extern void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b);
-extern int blk_queue_dma_drain(struct request_queue *q, void *buf,
-			       unsigned int size);
+extern int blk_queue_dma_drain(struct request_queue *q,
+			       dma_drain_needed_fn *dma_drain_needed,
+			       void *buf, unsigned int size);
 extern void blk_queue_segment_boundary(struct request_queue *, unsigned long);
 extern void blk_queue_prep_rq(struct request_queue *, prep_rq_fn *pfn);
 extern void blk_queue_merge_bvec(struct request_queue *, merge_bvec_fn *);
-- 
1.5.2.4

