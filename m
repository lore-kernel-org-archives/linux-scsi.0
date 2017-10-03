From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V8 7/8] block: support PREEMPT_ONLY
Date: Tue,  3 Oct 2017 22:04:05 +0800
Message-ID: <20171003140406.26060-8-ming.lei@redhat.com>
References: <20171003140406.26060-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171003140406.26060-1-ming.lei@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Johannes Thumshirn <jthumshirn@suse.de>, Cathy Avery <cavery@redhat.com>, Martin Steigerwald <martin@lichtvoll.de>, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Ming Lei <ming.lei@redhat.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

When queue is in PREEMPT_ONLY mode, only REQ_PREEMPT request
can be allocated and dispatched, other requests won't be allowed
to enter I/O path.

This is useful for supporting safe SCSI quiesce.

Part of this patch is from Bart's '[PATCH v4 4∕7] block: Add the QUEUE_FLAG_PREEMPT_ONLY
request queue flag'.

Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Tested-by: Martin Steigerwald <martin@lichtvoll.de>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c       | 44 +++++++++++++++++++++++++++++++++++++++++---
 include/linux/blkdev.h |  5 +++++
 2 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 1bb566245d37..7849cc1687bc 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -346,6 +346,34 @@ void blk_sync_queue(struct request_queue *q)
 }
 EXPORT_SYMBOL(blk_sync_queue);
 
+void blk_set_preempt_only(struct request_queue *q, bool preempt_only)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	if (preempt_only)
+		queue_flag_set(QUEUE_FLAG_PREEMPT_ONLY, q);
+	else
+		queue_flag_clear(QUEUE_FLAG_PREEMPT_ONLY, q);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	/*
+	 * The synchronize_rcu() implicied in blk_mq_freeze_queue()
+	 * or the explicit one will make sure the above write on
+	 * PREEMPT_ONLY is observed in blk_queue_enter() before
+	 * running blk_mq_unfreeze_queue().
+	 *
+	 * blk_mq_freeze_queue() also drains up any request in queue,
+	 * so blk_queue_enter() will see the above updated value of
+	 * PREEMPT flag before any new allocation.
+	 */
+	if (!blk_mq_freeze_queue(q))
+		synchronize_rcu();
+
+	blk_mq_unfreeze_queue(q);
+}
+EXPORT_SYMBOL(blk_set_preempt_only);
+
 /**
  * __blk_run_queue_uncond - run a queue whether or not it has been stopped
  * @q:	The queue to run
@@ -771,8 +799,16 @@ int blk_queue_enter(struct request_queue *q, unsigned int op)
 	while (true) {
 		int ret;
 
-		if (percpu_ref_tryget_live(&q->q_usage_counter))
-			return 0;
+		rcu_read_lock_sched();
+		if (__percpu_ref_tryget_live(&q->q_usage_counter)) {
+			if (likely((op & REQ_PREEMPT) ||
+						!blk_queue_preempt_only(q))) {
+				rcu_read_unlock_sched();
+				return 0;
+			} else
+				percpu_ref_put(&q->q_usage_counter);
+		}
+		rcu_read_unlock_sched();
 
 		if (op & REQ_NOWAIT)
 			return -EBUSY;
@@ -787,7 +823,9 @@ int blk_queue_enter(struct request_queue *q, unsigned int op)
 		smp_rmb();
 
 		ret = wait_event_interruptible(q->mq_freeze_wq,
-				!atomic_read(&q->mq_freeze_depth) ||
+				(!atomic_read(&q->mq_freeze_depth) &&
+				((op & REQ_PREEMPT) ||
+				 !blk_queue_preempt_only(q))) ||
 				blk_queue_dying(q));
 		if (blk_queue_dying(q))
 			return -ENODEV;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4c688385d866..66d46d9eac29 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -628,6 +628,7 @@ struct request_queue {
 #define QUEUE_FLAG_REGISTERED  26	/* queue has been registered to a disk */
 #define QUEUE_FLAG_SCSI_PASSTHROUGH 27	/* queue supports SCSI commands */
 #define QUEUE_FLAG_QUIESCED    28	/* queue has been quiesced */
+#define QUEUE_FLAG_PREEMPT_ONLY	29	/* only process REQ_PREEMPT requests */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
@@ -732,6 +733,10 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 	((rq)->cmd_flags & (REQ_FAILFAST_DEV|REQ_FAILFAST_TRANSPORT| \
 			     REQ_FAILFAST_DRIVER))
 #define blk_queue_quiesced(q)	test_bit(QUEUE_FLAG_QUIESCED, &(q)->queue_flags)
+#define blk_queue_preempt_only(q)				\
+	test_bit(QUEUE_FLAG_PREEMPT_ONLY, &(q)->queue_flags)
+
+extern void blk_set_preempt_only(struct request_queue *q, bool preempt_only);
 
 static inline bool blk_account_rq(struct request *rq)
 {
-- 
2.9.5
