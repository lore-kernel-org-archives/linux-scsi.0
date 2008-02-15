From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [RFC PATCH 2/3] block: move internal request completion to kblockd
Date: Fri, 15 Feb 2008 17:27:59 -0500 (EST)
Message-ID: <20080215.172759.126762735.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756657AbYBOW2k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Feb 2008 17:28:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com

This patch eliminates the use of __blk_end_request() and
end_queued_request() in the block layer.

On the current request stacking design, drivers are not ready
for request stacking if they hold the queue lock when completing
request.
However, some block layer functions are doing that, and the block
layer is not ready for request stacking now.

To complete all requests without the queue lock, this patch uses
kblockd in such cases.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 block/blk-barrier.c    |    8 ++------
 block/blk-core.c       |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 block/blk-settings.c   |    2 ++
 block/blk.h            |    2 ++
 block/elevator.c       |    4 ++--
 include/linux/blkdev.h |   25 +++++++++++++++++++++++++
 6 files changed, 82 insertions(+), 8 deletions(-)

Index: 2.6.25-rc1/include/linux/blkdev.h
===================================================================
--- 2.6.25-rc1.orig/include/linux/blkdev.h
+++ 2.6.25-rc1/include/linux/blkdev.h
@@ -236,6 +236,23 @@ struct request {
 
 	/* for bidi */
 	struct request *next_rq;
+
+	/*
+	 * For calling the request completion interface without the queue lock
+	 * using workqueue.
+	 *
+	 * The work handler needs to know the error code and the completion
+	 * size of the request to complete it.
+	 * We don't need to pass the completion size to the work handler,
+	 * because the workqueue completion method doesn't allow partial
+	 * completion and the work handler can use the whole size of
+	 * the request.
+	 * For the error code, we need to pass it to the work handler because
+	 * no member in the struct request can be used for the purpose.
+	 * (->errors should not be used, because the upper layer may expect
+	 *  that driver-specific error codes is there.)
+	 */
+	int endio_error;
 };
 
 /*
@@ -393,6 +410,13 @@ struct request_queue
 #if defined(CONFIG_BLK_DEV_BSG)
 	struct bsg_class_device bsg_dev;
 #endif
+
+	/*
+	 * For request completion without queue lock.
+	 * The workqueue completion method doesn't allow partial completion.
+	 */
+	struct work_struct	endio_work;
+	struct list_head	endio_list;
 };
 
 #define QUEUE_FLAG_CLUSTER	0	/* cluster several segments into 1 */
@@ -669,6 +693,7 @@ extern int __blk_end_request(struct requ
 				unsigned int nr_bytes);
 extern int blk_end_bidi_request(struct request *rq, int error,
 				unsigned int nr_bytes, unsigned int bidi_bytes);
+extern void blk_async_end_request(struct request *rq, int error);
 extern void end_request(struct request *, int);
 extern void end_queued_request(struct request *, int);
 extern void end_dequeued_request(struct request *, int);
Index: 2.6.25-rc1/block/elevator.c
===================================================================
--- 2.6.25-rc1.orig/block/elevator.c
+++ 2.6.25-rc1/block/elevator.c
@@ -721,7 +721,7 @@ struct request *elv_next_request(struct 
 		 * not ever see it.
 		 */
 		if (blk_empty_barrier(rq)) {
-			end_queued_request(rq, 1);
+			blk_async_end_request(rq, 0);
 			continue;
 		}
 		if (!(rq->cmd_flags & REQ_STARTED)) {
@@ -788,7 +788,7 @@ struct request *elv_next_request(struct 
 			break;
 		} else if (ret == BLKPREP_KILL) {
 			rq->cmd_flags |= REQ_QUIET;
-			end_queued_request(rq, 0);
+			blk_async_end_request(rq, -EIO);
 		} else {
 			printk(KERN_ERR "%s: bad return=%d\n", __FUNCTION__,
 								ret);
Index: 2.6.25-rc1/block/blk-barrier.c
===================================================================
--- 2.6.25-rc1.orig/block/blk-barrier.c
+++ 2.6.25-rc1/block/blk-barrier.c
@@ -108,8 +108,7 @@ void blk_ordered_complete_seq(struct req
 	q->ordseq = 0;
 	rq = q->orig_bar_rq;
 
-	if (__blk_end_request(rq, q->orderr, blk_rq_bytes(rq)))
-		BUG();
+	blk_async_end_request(rq, q->orderr);
 }
 
 static void pre_flush_end_io(struct request *rq, int error)
@@ -225,10 +224,7 @@ int blk_do_ordered(struct request_queue 
 			 * This can happen when the queue switches to
 			 * ORDERED_NONE while this request is on it.
 			 */
-			blkdev_dequeue_request(rq);
-			if (__blk_end_request(rq, -EOPNOTSUPP,
-					      blk_rq_bytes(rq)))
-				BUG();
+			blk_async_end_request(rq, -EOPNOTSUPP);
 			*rqp = NULL;
 			return 0;
 		}
Index: 2.6.25-rc1/block/blk-core.c
===================================================================
--- 2.6.25-rc1.orig/block/blk-core.c
+++ 2.6.25-rc1/block/blk-core.c
@@ -141,6 +141,7 @@ void rq_init(struct request_queue *q, st
 	rq->complete_io = NULL;
 	rq->end_io_data = NULL;
 	rq->next_rq = NULL;
+	rq->endio_error = 0;
 }
 
 static void req_bio_endio(struct request *rq, struct bio *bio,
@@ -2034,6 +2035,54 @@ int blk_end_request_callback(struct requ
 }
 EXPORT_SYMBOL_GPL(blk_end_request_callback);
 
+/**
+ * blk_async_end_request - Helper function to complete the request.
+ * @rq:    the request being processed
+ * @error: 0 for success, < 0 for error
+ *
+ * Description:
+ *   Ends all I/O on @rq using a kernel thread context.
+ *   It does not handle partial completions.
+ *   When the request completion interface is called in that context,
+ *   the queue lock is not held.
+ *
+ * Note:
+ *   Must be called with the queue lock held.
+ **/
+void blk_async_end_request(struct request *rq, int error)
+{
+	struct request_queue *q = rq->q;
+
+	if (blk_queued_rq(rq))
+		blkdev_dequeue_request(rq);
+
+	rq->endio_error = error;
+	list_add_tail(&rq->donelist, &q->endio_list);
+	kblockd_schedule_work(&q->endio_work);
+}
+
+void blk_endio_work(struct work_struct *work)
+{
+	struct request_queue *q =
+		container_of(work, struct request_queue, endio_work);
+	struct request *rq;
+	struct list_head local_list;
+	unsigned long flags;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	list_replace_init(&q->endio_list, &local_list);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	while (!list_empty(&local_list)) {
+		rq = list_entry(local_list.next, struct request, donelist);
+		list_del_init(&rq->donelist);
+
+		if (unlikely(blk_end_request(rq, rq->endio_error,
+					     blk_rq_bytes(rq))))
+			BUG();
+	}
+}
+
 void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 		     struct bio *bio)
 {
Index: 2.6.25-rc1/block/blk-settings.c
===================================================================
--- 2.6.25-rc1.orig/block/blk-settings.c
+++ 2.6.25-rc1/block/blk-settings.c
@@ -108,6 +108,8 @@ void blk_queue_make_request(struct reque
 		q->unplug_delay = 1;
 
 	INIT_WORK(&q->unplug_work, blk_unplug_work);
+	INIT_WORK(&q->endio_work, blk_endio_work);
+	INIT_LIST_HEAD(&q->endio_list);
 
 	q->unplug_timer.function = blk_unplug_timeout;
 	q->unplug_timer.data = (unsigned long)q;
Index: 2.6.25-rc1/block/blk.h
===================================================================
--- 2.6.25-rc1.orig/block/blk.h
+++ 2.6.25-rc1/block/blk.h
@@ -19,6 +19,8 @@ void __blk_queue_free_tags(struct reques
 void blk_unplug_work(struct work_struct *work);
 void blk_unplug_timeout(unsigned long data);
 
+void blk_endio_work(struct work_struct *work);
+
 struct io_context *current_io_context(gfp_t gfp_flags, int node);
 
 int ll_back_merge_fn(struct request_queue *q, struct request *req,
