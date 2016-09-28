From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 4/7] blk-mq: Introduce blk_quiesce_queue() and
 blk_resume_queue()
Date: Wed, 28 Sep 2016 16:59:46 -0700
Message-ID: <a9eb4e95-6d77-e527-c42a-fd2e6f104bed@sandisk.com>
References: <f153ee47-e599-c333-92b0-d5da475012f3@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0052.outbound.protection.outlook.com ([104.47.37.52]:57156
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753068AbcI1X76 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Sep 2016 19:59:58 -0400
In-Reply-To: <f153ee47-e599-c333-92b0-d5da475012f3@sandisk.com>
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
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 block/blk-mq.c         | 137 ++++++++++++++++++++++++++++++++++++++++++++-----
 include/linux/blk-mq.h |   2 +
 include/linux/blkdev.h |   5 ++
 3 files changed, 131 insertions(+), 13 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index d8c45de..f5c71ad 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -58,15 +58,23 @@ static void blk_mq_hctx_clear_pending(struct blk_mq_hw_ctx *hctx,
 	sbitmap_clear_bit(&hctx->ctx_map, ctx->index_hw);
 }
 
-void blk_mq_freeze_queue_start(struct request_queue *q)
+static bool __blk_mq_freeze_queue_start(struct request_queue *q,
+					bool kill_percpu_ref)
 {
 	int freeze_depth;
 
 	freeze_depth = atomic_inc_return(&q->mq_freeze_depth);
 	if (freeze_depth == 1) {
-		percpu_ref_kill(&q->q_usage_counter);
+		if (kill_percpu_ref)
+			percpu_ref_kill(&q->q_usage_counter);
 		blk_mq_run_hw_queues(q, false);
 	}
+	return freeze_depth == 1;
+}
+
+void blk_mq_freeze_queue_start(struct request_queue *q)
+{
+	__blk_mq_freeze_queue_start(q, true);
 }
 EXPORT_SYMBOL_GPL(blk_mq_freeze_queue_start);
 
@@ -102,19 +110,90 @@ void blk_mq_freeze_queue(struct request_queue *q)
 }
 EXPORT_SYMBOL_GPL(blk_mq_freeze_queue);
 
-void blk_mq_unfreeze_queue(struct request_queue *q)
+static bool __blk_mq_unfreeze_queue(struct request_queue *q,
+				    bool reinit_percpu_ref)
 {
 	int freeze_depth;
 
 	freeze_depth = atomic_dec_return(&q->mq_freeze_depth);
 	WARN_ON_ONCE(freeze_depth < 0);
 	if (!freeze_depth) {
-		percpu_ref_reinit(&q->q_usage_counter);
+		if (reinit_percpu_ref)
+			percpu_ref_reinit(&q->q_usage_counter);
 		wake_up_all(&q->mq_freeze_wq);
 	}
+	return freeze_depth == 0;
+}
+
+void blk_mq_unfreeze_queue(struct request_queue *q)
+{
+	__blk_mq_unfreeze_queue(q, true);
 }
 EXPORT_SYMBOL_GPL(blk_mq_unfreeze_queue);
 
+/**
+ * blk_mq_quiesce_queue() - wait until all pending queue_rq calls have finished
+ *
+ * Prevent that new I/O requests are queued and wait until all pending
+ * queue_rq() calls have finished. Must not be called if the queue has already
+ * been frozen. Additionally, freezing the queue after having quiesced the
+ * queue and before resuming the queue is not allowed.
+ *
+ * Note: this function does not prevent that the struct request end_io()
+ * callback function is invoked.
+ */
+void blk_mq_quiesce_queue(struct request_queue *q)
+{
+	struct blk_mq_hw_ctx *hctx;
+	unsigned int i;
+	bool res, rcu = false;
+
+	spin_lock_irq(q->queue_lock);
+	WARN_ON_ONCE(blk_queue_quiescing(q));
+	queue_flag_set(QUEUE_FLAG_QUIESCING, q);
+	spin_unlock_irq(q->queue_lock);
+
+	res = __blk_mq_freeze_queue_start(q, false);
+	WARN_ON_ONCE(!res);
+	queue_for_each_hw_ctx(q, hctx, i) {
+		if (hctx->flags & BLK_MQ_F_BLOCKING) {
+			mutex_lock(&hctx->queue_rq_mutex);
+			mutex_unlock(&hctx->queue_rq_mutex);
+		} else {
+			rcu = true;
+		}
+	}
+	if (rcu)
+		synchronize_rcu();
+
+	spin_lock_irq(q->queue_lock);
+	WARN_ON_ONCE(!blk_queue_quiescing(q));
+	queue_flag_clear(QUEUE_FLAG_QUIESCING, q);
+	spin_unlock_irq(q->queue_lock);
+}
+EXPORT_SYMBOL_GPL(blk_mq_quiesce_queue);
+
+/**
+ * blk_mq_resume_queue() - resume request processing
+ *
+ * Resume blk_queue_enter() calls that have been suspended by
+ * blk_mq_quiesce_queue().
+ *
+ * The caller is responsible for serializing blk_mq_quiesce_queue() and
+ * blk_mq_resume_queue().
+ */
+void blk_mq_resume_queue(struct request_queue *q)
+{
+	bool res;
+
+	res = __blk_mq_unfreeze_queue(q, false);
+	WARN_ON_ONCE(!res);
+	WARN_ON_ONCE(blk_queue_quiescing(q));
+
+	blk_mq_run_hw_queues(q, false);
+}
+EXPORT_SYMBOL_GPL(blk_mq_resume_queue);
+
 void blk_mq_wake_waiters(struct request_queue *q)
 {
 	struct blk_mq_hw_ctx *hctx;
@@ -488,6 +567,9 @@ static void blk_mq_requeue_work(struct work_struct *work)
 	struct request *rq, *next;
 	unsigned long flags;
 
+	if (blk_queue_quiescing(q))
+		return;
+
 	spin_lock_irqsave(&q->requeue_lock, flags);
 	list_splice_init(&q->requeue_list, &rq_list);
 	spin_unlock_irqrestore(&q->requeue_lock, flags);
@@ -782,7 +864,7 @@ static inline unsigned int queued_to_index(unsigned int queued)
  * of IO. In particular, we'd like FIFO behaviour on handling existing
  * items on the hctx->dispatch list. Ignore that for now.
  */
-static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
+static void blk_mq_process_rq_list(struct blk_mq_hw_ctx *hctx)
 {
 	struct request_queue *q = hctx->queue;
 	struct request *rq;
@@ -791,9 +873,6 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
 	struct list_head *dptr;
 	int queued;
 
-	if (unlikely(test_bit(BLK_MQ_S_STOPPED, &hctx->state)))
-		return;
-
 	WARN_ON(!cpumask_test_cpu(raw_smp_processor_id(), hctx->cpumask) &&
 		cpu_online(hctx->next_cpu));
 
@@ -883,7 +962,24 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
 		 *
 		 * blk_mq_run_hw_queue() already checks the STOPPED bit
 		 **/
-		blk_mq_run_hw_queue(hctx, true);
+		if (!blk_queue_quiescing(q))
+			blk_mq_run_hw_queue(hctx, true);
+	}
+}
+
+static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
+{
+	if (unlikely(test_bit(BLK_MQ_S_STOPPED, &hctx->state)))
+		return;
+
+	if (hctx->flags & BLK_MQ_F_BLOCKING) {
+		mutex_lock(&hctx->queue_rq_mutex);
+		blk_mq_process_rq_list(hctx);
+		mutex_unlock(&hctx->queue_rq_mutex);
+	} else {
+		rcu_read_lock();
+		blk_mq_process_rq_list(hctx);
+		rcu_read_unlock();
 	}
 }
 
@@ -1341,7 +1437,7 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 		blk_mq_bio_to_request(rq, bio);
 
 		/*
-		 * We do limited pluging. If the bio can be merged, do that.
+		 * We do limited plugging. If the bio can be merged, do that.
 		 * Otherwise the existing request in the plug list will be
 		 * issued. So the plug list will have one request at most
 		 */
@@ -1361,9 +1457,23 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 		blk_mq_put_ctx(data.ctx);
 		if (!old_rq)
 			goto done;
-		if (!blk_mq_direct_issue_request(old_rq, &cookie))
-			goto done;
-		blk_mq_insert_request(old_rq, false, true, true);
+
+		if (data.hctx->flags & BLK_MQ_F_BLOCKING) {
+			mutex_lock(&data.hctx->queue_rq_mutex);
+			if (blk_queue_quiescing(q) ||
+			    blk_mq_direct_issue_request(old_rq, &cookie) != 0)
+				blk_mq_insert_request(old_rq, false, true,
+						      true);
+			mutex_unlock(&data.hctx->queue_rq_mutex);
+		} else {
+			rcu_read_lock();
+			if (blk_queue_quiescing(q) ||
+			    blk_mq_direct_issue_request(old_rq, &cookie) != 0)
+				blk_mq_insert_request(old_rq, false, true,
+						      true);
+			rcu_read_unlock();
+		}
+
 		goto done;
 	}
 
@@ -1702,6 +1812,7 @@ static int blk_mq_init_hctx(struct request_queue *q,
 	INIT_DELAYED_WORK(&hctx->delay_work, blk_mq_delay_work_fn);
 	spin_lock_init(&hctx->lock);
 	INIT_LIST_HEAD(&hctx->dispatch);
+	mutex_init(&hctx->queue_rq_mutex);
 	hctx->queue = q;
 	hctx->queue_num = hctx_idx;
 	hctx->flags = set->flags & ~BLK_MQ_F_TAG_SHARED;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 368c460d..4b970f1 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -41,6 +41,8 @@ struct blk_mq_hw_ctx {
 
 	struct blk_mq_tags	*tags;
 
+	struct mutex		queue_rq_mutex;
+
 	unsigned long		queued;
 	unsigned long		run;
 #define BLK_MQ_MAX_DISPATCH_ORDER	7
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c47c358..d365cdf 100644
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
+extern void blk_mq_quiesce_queue(struct request_queue *q);
+extern void blk_mq_resume_queue(struct request_queue *q);
 extern int blk_rq_map_user(struct request_queue *, struct request *,
 			   struct rq_map_data *, void __user *, unsigned long,
 			   gfp_t);
-- 
2.10.0

