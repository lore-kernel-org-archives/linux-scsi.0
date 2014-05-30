From: Liu Ping Fan <kernelfans@gmail.com>
Subject: [RFC 5/9] blk: change funcs' prototype to expose the ref of timer
Date: Fri, 30 May 2014 16:20:28 +0800
Message-ID: <1401438028-2561-1-git-send-email-pingfank@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yh0-f52.google.com ([209.85.213.52]:60424 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbaE3IR0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 May 2014 04:17:26 -0400
Received: by mail-yh0-f52.google.com with SMTP id z6so1283814yhz.25
        for <linux-scsi@vger.kernel.org>; Fri, 30 May 2014 01:17:25 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, Jens Axboe <axboe@kernel.dk>, Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Jeff Moyer <jmoyer@redhat.com>

req->special is normally referred by both a timer and request_queue.
This patch focus on the timer's ref. It changes a group of func's
prototype, so the caller can inc/dec ref, in according to add/del a
timer.

Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
---
 block/blk-core.c       | 49 ++++++++++++++++++++++++++++++++++++++++---------
 block/blk-timeout.c    | 10 ++++++++--
 block/blk.h            |  2 +-
 include/linux/blkdev.h |  4 +++-
 4 files changed, 52 insertions(+), 13 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index b0261be..beaca2e 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1205,9 +1205,11 @@ EXPORT_SYMBOL(blk_make_request);
  *    more, when that condition happens we need to put the request back
  *    on the queue. Must be called with queue lock held.
  */
-void blk_requeue_request(struct request_queue *q, struct request *rq)
+bool blk_requeue_request(struct request_queue *q, struct request *rq)
 {
-	blk_delete_timer(rq);
+	bool ref;
+
+	ref = blk_delete_timer(rq);
 	blk_clear_rq_complete(rq);
 	trace_block_rq_requeue(q, rq);
 
@@ -1217,6 +1219,7 @@ void blk_requeue_request(struct request_queue *q, struct request *rq)
 	BUG_ON(blk_queued_rq(rq));
 
 	elv_requeue_request(q, rq);
+	return ref;
 }
 EXPORT_SYMBOL(blk_requeue_request);
 
@@ -2492,8 +2495,10 @@ EXPORT_SYMBOL_GPL(blk_unprep_request);
 /*
  * queue lock must be held
  */
-static void blk_finish_request(struct request *req, int error)
+static void blk_finish_request(struct request *req, int error, int *drop_ref)
 {
+	bool ref;
+
 	if (blk_rq_tagged(req))
 		blk_queue_end_tag(req->q, req);
 
@@ -2502,7 +2507,11 @@ static void blk_finish_request(struct request *req, int error)
 	if (unlikely(laptop_mode) && req->cmd_type == REQ_TYPE_FS)
 		laptop_io_completion(&req->q->backing_dev_info);
 
-	blk_delete_timer(req);
+	ref = blk_delete_timer(req);
+	if (likely(ref && drop_ref))
+		*drop_ref = 1;
+	else if (drop_ref)
+		*drop_ref = 0;
 
 	if (req->cmd_flags & REQ_DONTPREP)
 		blk_unprep_request(req);
@@ -2537,7 +2546,7 @@ static void blk_finish_request(struct request *req, int error)
  *     %true  - still buffers pending for this request
  **/
 static bool blk_end_bidi_request(struct request *rq, int error,
-				 unsigned int nr_bytes, unsigned int bidi_bytes)
+		unsigned int nr_bytes, unsigned int bidi_bytes, int *drop_ref)
 {
 	struct request_queue *q = rq->q;
 	unsigned long flags;
@@ -2546,7 +2555,7 @@ static bool blk_end_bidi_request(struct request *rq, int error,
 		return true;
 
 	spin_lock_irqsave(q->queue_lock, flags);
-	blk_finish_request(rq, error);
+	blk_finish_request(rq, error, drop_ref);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
 	return false;
@@ -2573,7 +2582,7 @@ bool __blk_end_bidi_request(struct request *rq, int error,
 	if (blk_update_bidi_request(rq, error, nr_bytes, bidi_bytes))
 		return true;
 
-	blk_finish_request(rq, error);
+	blk_finish_request(rq, error, NULL);
 
 	return false;
 }
@@ -2594,11 +2603,32 @@ bool __blk_end_bidi_request(struct request *rq, int error,
  **/
 bool blk_end_request(struct request *rq, int error, unsigned int nr_bytes)
 {
-	return blk_end_bidi_request(rq, error, nr_bytes, 0);
+	return blk_end_bidi_request(rq, error, nr_bytes, 0, NULL);
 }
 EXPORT_SYMBOL(blk_end_request);
 
 /**
+ * blk_end_request_ref - Helper function for drivers to complete the request.
+ * @rq:       the request being processed
+ * @error:    %0 for success, < %0 for error
+ * @nr_bytes: number of bytes to complete
+ *
+ * Description:
+ *     Ends I/O on a number of bytes attached to @rq.
+ *     If @rq has leftover, sets it up for the next range of segments.
+ *
+ * Return:
+ *     %false - we are done with this request
+ *     %true  - still buffers pending for this request
+ **/
+bool blk_end_request_ref(struct request *rq, int error, unsigned int nr_bytes,
+	int *drop_ref)
+{
+	return blk_end_bidi_request(rq, error, nr_bytes, 0, drop_ref);
+}
+EXPORT_SYMBOL(blk_end_request_ref);
+
+/**
  * blk_end_request_all - Helper function for drives to finish the request.
  * @rq: the request to finish
  * @error: %0 for success, < %0 for error
@@ -2614,7 +2644,8 @@ void blk_end_request_all(struct request *rq, int error)
 	if (unlikely(blk_bidi_rq(rq)))
 		bidi_bytes = blk_rq_bytes(rq->next_rq);
 
-	pending = blk_end_bidi_request(rq, error, blk_rq_bytes(rq), bidi_bytes);
+	pending = blk_end_bidi_request(rq, error, blk_rq_bytes(rq), bidi_bytes,
+		NULL);
 	BUG_ON(pending);
 }
 EXPORT_SYMBOL(blk_end_request_all);
diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index d3067f0..839962b 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -74,10 +74,16 @@ ssize_t part_timeout_store(struct device *dev, struct device_attribute *attr,
  * blk_delete_timer - Delete/cancel timer for a given function.
  * @req:	request that we are canceling timer for
  *
+ * return: true, timeout_list is not empty
  */
-void blk_delete_timer(struct request *req)
+bool blk_delete_timer(struct request *req)
 {
-	list_del_init(&req->timeout_list);
+	bool ret;
+
+	ret = !list_empty(&req->timeout_list);
+	if (ret)
+		list_del_init(&req->timeout_list);
+	return ret;
 }
 
 static void blk_rq_timed_out(struct request *req)
diff --git a/block/blk.h b/block/blk.h
index a9cad62..9cd70b1 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -37,7 +37,7 @@ void blk_rq_timed_out_timer(unsigned long data);
 void blk_rq_check_expired(struct request *rq, unsigned long *next_timeout,
 			  unsigned int *next_set);
 void __blk_add_timer(struct request *req, struct list_head *timeout_list);
-void blk_delete_timer(struct request *);
+bool blk_delete_timer(struct request *);
 void blk_add_timer(struct request *);
 
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 23deadb..7a2e79f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -775,7 +775,7 @@ extern void __blk_put_request(struct request_queue *, struct request *);
 extern struct request *blk_get_request(struct request_queue *, int, gfp_t);
 extern struct request *blk_make_request(struct request_queue *, struct bio *,
 					gfp_t);
-extern void blk_requeue_request(struct request_queue *, struct request *);
+extern bool blk_requeue_request(struct request_queue *, struct request *);
 extern void blk_add_request_payload(struct request *rq, struct page *page,
 		unsigned int len);
 extern int blk_rq_check_limits(struct request_queue *q, struct request *rq);
@@ -934,6 +934,8 @@ extern struct request *blk_fetch_request(struct request_queue *q);
  */
 extern bool blk_update_request(struct request *rq, int error,
 			       unsigned int nr_bytes);
+extern bool blk_end_request_ref(struct request *rq, int error,
+	unsigned int nr_bytes, int *drop_ref);
 extern bool blk_end_request(struct request *rq, int error,
 			    unsigned int nr_bytes);
 extern void blk_end_request_all(struct request *rq, int error);
-- 
1.8.1.4

