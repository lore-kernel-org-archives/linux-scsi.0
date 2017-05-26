From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 3/6] blk-mq: fix blk_mq_quiesce_queue
Date: Fri, 26 May 2017 11:07:36 +0800
Message-ID: <20170526030740.26959-4-ming.lei@redhat.com>
References: <20170526030740.26959-1-ming.lei@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40080 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934896AbdEZDIT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 25 May 2017 23:08:19 -0400
In-Reply-To: <20170526030740.26959-1-ming.lei@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com

blk_mq_quiesce_queue() can not block dispatch in the following
two cases:

- direct issue or BLK_MQ_S_START_ON_RUN
- in theory, new RCU read-side critical sections may begin while
synchronize_rcu() was waiting, and end after returning of
synchronize_rcu().

so a new flag of QUEUE_FLAG_QUIESCED is introduced and evaluated
inside RCU read-side critical sections for fixing the above issues.

This patch fixes request use-after-free during canceling requets
of NVMe in nvme_dev_disable().

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq.c         | 33 ++++++++++++++++++++++++++++-----
 include/linux/blkdev.h |  2 ++
 2 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index a26fee3fb389..864709453c90 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -170,6 +170,10 @@ void blk_mq_quiesce_queue(struct request_queue *q)
 
 	__blk_mq_stop_hw_queues(q, true);
 
+	spin_lock_irq(q->queue_lock);
+	queue_flag_set(QUEUE_FLAG_QUIESCED, q);
+	spin_unlock_irq(q->queue_lock);
+
 	queue_for_each_hw_ctx(q, hctx, i) {
 		if (hctx->flags & BLK_MQ_F_BLOCKING)
 			synchronize_srcu(&hctx->queue_rq_srcu);
@@ -190,6 +194,10 @@ EXPORT_SYMBOL_GPL(blk_mq_quiesce_queue);
  */
 void blk_mq_unquiesce_queue(struct request_queue *q)
 {
+	spin_lock_irq(q->queue_lock);
+	queue_flag_clear(QUEUE_FLAG_QUIESCED, q);
+	spin_unlock_irq(q->queue_lock);
+
 	blk_mq_start_stopped_hw_queues(q, true);
 }
 EXPORT_SYMBOL_GPL(blk_mq_unquiesce_queue);
@@ -209,6 +217,9 @@ void blk_mq_wake_waiters(struct request_queue *q)
 	 * the queue are notified as well.
 	 */
 	wake_up_all(&q->mq_freeze_wq);
+
+	/* Forcibly unquiesce the queue to avoid having stuck requests */
+	blk_mq_unquiesce_queue(q);
 }
 
 bool blk_mq_can_queue(struct blk_mq_hw_ctx *hctx)
@@ -1108,13 +1119,15 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
 
 	if (!(hctx->flags & BLK_MQ_F_BLOCKING)) {
 		rcu_read_lock();
-		blk_mq_sched_dispatch_requests(hctx);
+		if (!blk_queue_quiesced(hctx->queue))
+			blk_mq_sched_dispatch_requests(hctx);
 		rcu_read_unlock();
 	} else {
 		might_sleep();
 
 		srcu_idx = srcu_read_lock(&hctx->queue_rq_srcu);
-		blk_mq_sched_dispatch_requests(hctx);
+		if (!blk_queue_quiesced(hctx->queue))
+			blk_mq_sched_dispatch_requests(hctx);
 		srcu_read_unlock(&hctx->queue_rq_srcu, srcu_idx);
 	}
 }
@@ -1519,9 +1532,14 @@ static void __blk_mq_try_issue_directly(struct request *rq, blk_qc_t *cookie,
 static void blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
 		struct request *rq, blk_qc_t *cookie)
 {
-	if (!(hctx->flags & BLK_MQ_F_BLOCKING)) {
+	bool blocking = hctx->flags & BLK_MQ_F_BLOCKING;
+	bool quiesced;
+
+	if (!blocking) {
 		rcu_read_lock();
-		__blk_mq_try_issue_directly(rq, cookie, false);
+		quiesced = blk_queue_quiesced(rq->q);
+		if (!quiesced)
+			__blk_mq_try_issue_directly(rq, cookie, false);
 		rcu_read_unlock();
 	} else {
 		unsigned int srcu_idx;
@@ -1529,9 +1547,14 @@ static void blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
 		might_sleep();
 
 		srcu_idx = srcu_read_lock(&hctx->queue_rq_srcu);
-		__blk_mq_try_issue_directly(rq, cookie, true);
+		quiesced = blk_queue_quiesced(rq->q);
+		if (!quiesced)
+			__blk_mq_try_issue_directly(rq, cookie, true);
 		srcu_read_unlock(&hctx->queue_rq_srcu, srcu_idx);
 	}
+
+	if (quiesced)
+		blk_mq_sched_insert_request(rq, false, false, false, blocking);
 }
 
 static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 41291be82ac4..60967797f4f6 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -618,6 +618,7 @@ struct request_queue {
 #define QUEUE_FLAG_STATS       27	/* track rq completion times */
 #define QUEUE_FLAG_POLL_STATS  28	/* collecting stats for hybrid polling */
 #define QUEUE_FLAG_REGISTERED  29	/* queue has been registered to a disk */
+#define QUEUE_FLAG_QUIESCED    30	/* queue has been quiesced */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
@@ -712,6 +713,7 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 #define blk_noretry_request(rq) \
 	((rq)->cmd_flags & (REQ_FAILFAST_DEV|REQ_FAILFAST_TRANSPORT| \
 			     REQ_FAILFAST_DRIVER))
+#define blk_queue_quiesced(q)	test_bit(QUEUE_FLAG_QUIESCED, &(q)->queue_flags)
 
 static inline bool blk_account_rq(struct request *rq)
 {
-- 
2.9.4
