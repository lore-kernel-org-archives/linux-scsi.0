From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 2/4] block: Introduce blk_wait_if_quiesced() and blk_finish_wait_if_quiesced()
Date: Mon,  8 Jan 2018 10:50:09 -0800
Message-ID: <20180108185011.30018-3-bart.vanassche@wdc.com>
References: <20180108185011.30018-1-bart.vanassche@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180108185011.30018-1-bart.vanassche@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@mellanox.com>, Doug Ledford <dledford@redhat.com>, linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Introduce functions that allow block drivers to wait while a request
queue is in the quiesced state (blk-mq) or in the stopped state (legacy
block layer). The next patch will add calls to these functions in the
SCSI core.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c       |  1 +
 block/blk-mq.c         | 61 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blk-mq.h |  2 ++
 3 files changed, 64 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 605599a2ab3b..d70ff53e6505 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -285,6 +285,7 @@ void blk_start_queue(struct request_queue *q)
 	WARN_ON_ONCE(q->mq_ops);
 
 	queue_flag_clear(QUEUE_FLAG_STOPPED, q);
+	wake_up_all(&q->mq_wq);
 	__blk_run_queue(q);
 }
 EXPORT_SYMBOL(blk_start_queue);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 8118890fb66f..c79b102680fe 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -248,11 +248,72 @@ void blk_mq_unquiesce_queue(struct request_queue *q)
 	queue_flag_clear(QUEUE_FLAG_QUIESCED, q);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
+	wake_up_all(&q->mq_wq);
+
 	/* dispatch requests which are inserted during quiescing */
 	blk_mq_run_hw_queues(q, true);
 }
 EXPORT_SYMBOL_GPL(blk_mq_unquiesce_queue);
 
+/**
+ * blk_wait_if_quiesced() - wait if a queue is quiesced (blk-mq) or stopped (legacy block layer)
+ * @q: Request queue pointer.
+ *
+ * Some block drivers, e.g. the SCSI core, can bypass the block layer core
+ * request submission mechanism. Surround such code with blk_wait_if_quiesced()
+ * / blk_finish_wait_if_quiesced() to avoid that request submission can happen
+ * while a queue is quiesced or stopped.
+ *
+ * Returns with the RCU read lock held (blk-mq) or with q->queue_lock held
+ * (legacy block layer).
+ *
+ * Note: this function does not support block drivers whose .queue_rq()
+ * implementation can sleep (BLK_MQ_F_BLOCKING).
+ */
+int blk_wait_if_quiesced(struct request_queue *q)
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
+EXPORT_SYMBOL(blk_wait_if_quiesced);
+
+/**
+ * blk_finish_wait_if_quiesced() - counterpart of blk_wait_if_quiesced()
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
index 95c9a5c862e2..f6b787bd244e 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -266,6 +266,8 @@ void blk_mq_start_stopped_hw_queue(struct blk_mq_hw_ctx *hctx, bool async);
 void blk_mq_start_stopped_hw_queues(struct request_queue *q, bool async);
 void blk_mq_quiesce_queue(struct request_queue *q);
 void blk_mq_unquiesce_queue(struct request_queue *q);
+int blk_wait_if_quiesced(struct request_queue *q);
+void blk_finish_wait_if_quiesced(struct request_queue *q);
 void blk_mq_delay_run_hw_queue(struct blk_mq_hw_ctx *hctx, unsigned long msecs);
 bool blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async);
 void blk_mq_run_hw_queues(struct request_queue *q, bool async);
-- 
2.15.1
