From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v2 2/4] block: Introduce blk_start_wait_if_quiesced() and blk_finish_wait_if_quiesced()
Date: Wed, 10 Jan 2018 10:18:15 -0800
Message-ID: <20180110181817.25166-3-bart.vanassche@wdc.com>
References: <20180110181817.25166-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180110181817.25166-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Martin K . Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Introduce functions that allow block drivers to wait while a request
queue is in the quiesced state (blk-mq) or in the stopped state (legacy
block layer). The next patch will add calls to these functions in the
SCSI core.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Martin K. Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Cc: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Cc: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 block/blk-core.c       |  1 +
 block/blk-mq.c         | 64 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blk-mq.h |  2 ++
 3 files changed, 67 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index c10b4ce95248..06eaea15bae9 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -287,6 +287,7 @@ void blk_start_queue(struct request_queue *q)
 	WARN_ON_ONCE(q->mq_ops);
 
 	queue_flag_clear(QUEUE_FLAG_STOPPED, q);
+	wake_up_all(&q->mq_wq);
 	__blk_run_queue(q);
 }
 EXPORT_SYMBOL(blk_start_queue);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index a05ea7e9b415..87455977ad34 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -247,11 +247,75 @@ void blk_mq_unquiesce_queue(struct request_queue *q)
 	queue_flag_clear(QUEUE_FLAG_QUIESCED, q);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
+	wake_up_all(&q->mq_wq);
+
 	/* dispatch requests which are inserted during quiescing */
 	blk_mq_run_hw_queues(q, true);
 }
 EXPORT_SYMBOL_GPL(blk_mq_unquiesce_queue);
 
+/**
+ * blk_start_wait_if_quiesced() - wait if a queue is quiesced (blk-mq) or stopped (legacy block layer)
+ * @q: Request queue pointer.
+ *
+ * Some block drivers, e.g. the SCSI core, can bypass the block layer core
+ * request submission mechanism. Surround such code with
+ * blk_start_wait_if_quiesced() / blk_finish_wait_if_quiesced() to avoid that
+ * request submission can happen while a queue is quiesced or stopped.
+ *
+ * Returns with the RCU read lock held (blk-mq) or with q->queue_lock held
+ * (legacy block layer).
+ *
+ * Notes:
+ * - Every call of this function must be followed by a call of
+ *   blk_finish_wait_if_quiesced().
+ * - This function does not support block drivers whose .queue_rq()
+ *   implementation can sleep (BLK_MQ_F_BLOCKING).
+ */
+int blk_start_wait_if_quiesced(struct request_queue *q)
+{
+	struct blk_mq_hw_ctx *hctx;
+	unsigned int i;
+
+	might_sleep();
+
+	if (q->mq_ops) {
+		queue_for_each_hw_ctx(q, hctx, i)
+			WARN_ON(hctx->flags & BLK_MQ_F_BLOCKING);
+
+		rcu_read_lock();
+		while (!blk_queue_dying(q) && blk_queue_quiesced(q)) {
+			rcu_read_unlock();
+			wait_event(q->mq_wq, blk_queue_dying(q) ||
+				   !blk_queue_quiesced(q));
+			rcu_read_lock();
+		}
+	} else {
+		spin_lock_irq(q->queue_lock);
+		wait_event_lock_irq(q->mq_wq,
+				    blk_queue_dying(q) || !blk_queue_stopped(q),
+				    *q->queue_lock);
+		q->request_fn_active++;
+	}
+	return blk_queue_dying(q) ? -ENODEV : 0;
+}
+EXPORT_SYMBOL(blk_start_wait_if_quiesced);
+
+/**
+ * blk_finish_wait_if_quiesced() - counterpart of blk_start_wait_if_quiesced()
+ * @q: Request queue pointer.
+ */
+void blk_finish_wait_if_quiesced(struct request_queue *q)
+{
+	if (q->mq_ops) {
+		rcu_read_unlock();
+	} else {
+		q->request_fn_active--;
+		spin_unlock_irq(q->queue_lock);
+	}
+}
+EXPORT_SYMBOL(blk_finish_wait_if_quiesced);
+
 void blk_mq_wake_waiters(struct request_queue *q)
 {
 	struct blk_mq_hw_ctx *hctx;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 8efcf49796a3..15912cd348b5 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -267,6 +267,8 @@ void blk_mq_start_stopped_hw_queue(struct blk_mq_hw_ctx *hctx, bool async);
 void blk_mq_start_stopped_hw_queues(struct request_queue *q, bool async);
 void blk_mq_quiesce_queue(struct request_queue *q);
 void blk_mq_unquiesce_queue(struct request_queue *q);
+int blk_start_wait_if_quiesced(struct request_queue *q);
+void blk_finish_wait_if_quiesced(struct request_queue *q);
 void blk_mq_delay_run_hw_queue(struct blk_mq_hw_ctx *hctx, unsigned long msecs);
 bool blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async);
 void blk_mq_run_hw_queues(struct request_queue *q, bool async);
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
