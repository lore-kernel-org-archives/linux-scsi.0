From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 7/9] blk-mq: Introduce blk_quiesce_queue() and
 blk_resume_queue()
Date: Mon, 26 Sep 2016 11:28:24 -0700
Message-ID: <517396c6-1392-0b42-cc6c-e48652897cf6@sandisk.com>
References: <7948dbb8-6333-dc62-2673-4da35b4dfdbc@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0042.outbound.protection.outlook.com ([104.47.33.42]:45120
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1162880AbcIZS2g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Sep 2016 14:28:36 -0400
In-Reply-To: <7948dbb8-6333-dc62-2673-4da35b4dfdbc@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>

blk_quiesce_queue() prevents that new queue_rq() invocations
occur and waits until ongoing invocations have finished. This
function does *not* wait until all outstanding requests have
finished (this means invocation of request.end_io()).
blk_resume_queue() resumes normal I/O processing.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 block/blk-core.c       | 66 ++++++++++++++++++++++++++++++++++++++++++++++----
 block/blk-mq.c         | 24 +++++++++++++-----
 block/blk.h            |  2 +-
 include/linux/blkdev.h |  5 ++++
 4 files changed, 85 insertions(+), 12 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 0ff5d57..62cb6ae 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -682,18 +682,20 @@ static void blk_queue_usage_counter_release(struct percpu_ref *ref)
 	wake_up_all(&q->freeze_wq);
 }
 
-void blk_freeze_queue_start(struct request_queue *q)
+bool blk_freeze_queue_start(struct request_queue *q, bool kill_percpu_ref)
 {
 	int freeze_depth;
 
 	freeze_depth = atomic_inc_return(&q->freeze_depth);
 	if (freeze_depth == 1) {
-		percpu_ref_kill(&q->q_usage_counter);
+		if (kill_percpu_ref)
+			percpu_ref_kill(&q->q_usage_counter);
 		if (q->mq_ops)
 			blk_mq_run_hw_queues(q, false);
 		else if (q->request_fn)
 			blk_run_queue(q);
 	}
+	return freeze_depth == 1;
 }
 
 void blk_freeze_queue_wait(struct request_queue *q)
@@ -708,21 +710,75 @@ void blk_freeze_queue_wait(struct request_queue *q)
  */
 void blk_freeze_queue(struct request_queue *q)
 {
-	blk_freeze_queue_start(q);
+	blk_freeze_queue_start(q, true);
 	blk_freeze_queue_wait(q);
 }
 
-void blk_unfreeze_queue(struct request_queue *q)
+static bool __blk_unfreeze_queue(struct request_queue *q,
+				 bool reinit_percpu_ref)
 {
 	int freeze_depth;
 
 	freeze_depth = atomic_dec_return(&q->freeze_depth);
 	WARN_ON_ONCE(freeze_depth < 0);
 	if (!freeze_depth) {
-		percpu_ref_reinit(&q->q_usage_counter);
+		if (reinit_percpu_ref)
+			percpu_ref_reinit(&q->q_usage_counter);
 		wake_up_all(&q->freeze_wq);
 	}
+	return freeze_depth == 0;
+}
+
+void blk_unfreeze_queue(struct request_queue *q)
+{
+	__blk_unfreeze_queue(q, true);
+}
+
+/**
+ * blk_quiesce_queue() - wait until all pending queue_rq calls have finished
+ *
+ * Prevent that new I/O requests are queued and wait until all pending
+ * queue_rq() calls have finished. Must not be called if the queue has already
+ * been frozen. Additionally, freezing the queue after having quiesced the
+ * queue and before resuming the queue is not allowed.
+ *
+ * Note: this function does not prevent that the struct request end_io()
+ * callback function is invoked.
+ */
+void blk_quiesce_queue(struct request_queue *q)
+{
+	spin_lock_irq(q->queue_lock);
+	WARN_ON_ONCE(blk_queue_quiescing(q));
+	queue_flag_set(QUEUE_FLAG_QUIESCING, q);
+	spin_unlock_irq(q->queue_lock);
+
+	WARN_ON_ONCE(!blk_freeze_queue_start(q, false));
+	synchronize_rcu();
+
+	spin_lock_irq(q->queue_lock);
+	WARN_ON_ONCE(!blk_queue_quiescing(q));
+	queue_flag_clear(QUEUE_FLAG_QUIESCING, q);
+	spin_unlock_irq(q->queue_lock);
+}
+EXPORT_SYMBOL_GPL(blk_quiesce_queue);
+
+/**
+ * blk_resume_queue() - resume request processing
+ *
+ * The caller is responsible for serializing blk_quiesce_queue() and
+ * blk_resume_queue().
+ */
+void blk_resume_queue(struct request_queue *q)
+{
+	WARN_ON_ONCE(!__blk_unfreeze_queue(q, false));
+	WARN_ON_ONCE(blk_queue_quiescing(q));
+
+	if (q->mq_ops)
+		blk_mq_run_hw_queues(q, false);
+	else
+		blk_run_queue(q);
 }
+EXPORT_SYMBOL_GPL(blk_resume_queue);
 
 static void blk_rq_timed_out_timer(unsigned long data)
 {
diff --git a/block/blk-mq.c b/block/blk-mq.c
index e17a5bf..4df9e4f 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -60,7 +60,7 @@ static void blk_mq_hctx_clear_pending(struct blk_mq_hw_ctx *hctx,
 
 void blk_mq_freeze_queue_start(struct request_queue *q)
 {
-	blk_freeze_queue_start(q);
+	blk_freeze_queue_start(q, true);
 }
 EXPORT_SYMBOL_GPL(blk_mq_freeze_queue_start);
 
@@ -441,6 +441,9 @@ static void blk_mq_requeue_work(struct work_struct *work)
 	struct request *rq, *next;
 	unsigned long flags;
 
+	if (blk_queue_quiescing(q))
+		return;
+
 	spin_lock_irqsave(&q->requeue_lock, flags);
 	list_splice_init(&q->requeue_list, &rq_list);
 	spin_unlock_irqrestore(&q->requeue_lock, flags);
@@ -757,6 +760,8 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
 	 */
 	flush_busy_ctxs(hctx, &rq_list);
 
+	rcu_read_lock();
+
 	/*
 	 * If we have previous entries on our dispatch list, grab them
 	 * and stuff them at the front for more fair dispatch.
@@ -836,8 +841,11 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
 		 *
 		 * blk_mq_run_hw_queue() already checks the STOPPED bit
 		 **/
-		blk_mq_run_hw_queue(hctx, true);
+		if (!blk_queue_quiescing(q))
+			blk_mq_run_hw_queue(hctx, true);
 	}
+
+	rcu_read_unlock();
 }
 
 /*
@@ -1294,7 +1302,7 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 		blk_mq_bio_to_request(rq, bio);
 
 		/*
-		 * We do limited pluging. If the bio can be merged, do that.
+		 * We do limited plugging. If the bio can be merged, do that.
 		 * Otherwise the existing request in the plug list will be
 		 * issued. So the plug list will have one request at most
 		 */
@@ -1314,9 +1322,13 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 		blk_mq_put_ctx(data.ctx);
 		if (!old_rq)
 			goto done;
-		if (!blk_mq_direct_issue_request(old_rq, &cookie))
-			goto done;
-		blk_mq_insert_request(old_rq, false, true, true);
+
+		rcu_read_lock();
+		if (blk_queue_quiescing(q) ||
+		    blk_mq_direct_issue_request(old_rq, &cookie) != 0)
+			blk_mq_insert_request(old_rq, false, true, true);
+		rcu_read_unlock();
+
 		goto done;
 	}
 
diff --git a/block/blk.h b/block/blk.h
index 12f7366..0e934b5 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -71,7 +71,7 @@ void __blk_queue_free_tags(struct request_queue *q);
 bool __blk_end_bidi_request(struct request *rq, int error,
 			    unsigned int nr_bytes, unsigned int bidi_bytes);
 void blk_freeze_queue(struct request_queue *q);
-void blk_freeze_queue_start(struct request_queue *q);
+bool blk_freeze_queue_start(struct request_queue *q, bool kill_percpu_ref);
 void blk_freeze_queue_wait(struct request_queue *q);
 void blk_unfreeze_queue(struct request_queue *q);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f08dc65..06c9b21 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -505,6 +505,7 @@ struct request_queue {
 #define QUEUE_FLAG_FUA	       24	/* device supports FUA writes */
 #define QUEUE_FLAG_FLUSH_NQ    25	/* flush not queueuable */
 #define QUEUE_FLAG_DAX         26	/* device supports DAX */
+#define QUEUE_FLAG_QUIESCING   27
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
@@ -595,6 +596,8 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 #define blk_queue_secure_erase(q) \
 	(test_bit(QUEUE_FLAG_SECERASE, &(q)->queue_flags))
 #define blk_queue_dax(q)	test_bit(QUEUE_FLAG_DAX, &(q)->queue_flags)
+#define blk_queue_quiescing(q)	test_bit(QUEUE_FLAG_QUIESCING,	\
+					 &(q)->queue_flags)
 
 #define blk_noretry_request(rq) \
 	((rq)->cmd_flags & (REQ_FAILFAST_DEV|REQ_FAILFAST_TRANSPORT| \
@@ -824,6 +827,8 @@ extern void __blk_run_queue(struct request_queue *q);
 extern void __blk_run_queue_uncond(struct request_queue *q);
 extern void blk_run_queue(struct request_queue *);
 extern void blk_run_queue_async(struct request_queue *q);
+extern void blk_quiesce_queue(struct request_queue *q);
+extern void blk_resume_queue(struct request_queue *q);
 extern int blk_rq_map_user(struct request_queue *, struct request *,
 			   struct rq_map_data *, void __user *, unsigned long,
 			   gfp_t);
-- 
2.10.0

