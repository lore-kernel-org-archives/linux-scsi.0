From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/8] blk-mq: add blk_mq_delay_queue
Date: Wed, 16 Apr 2014 09:44:55 +0200
Message-ID: <1397634299-7466-5-git-send-email-hch@lst.de>
References: <1397634299-7466-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1397634299-7466-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Add a blk-mq equivalent to blk_delay_queue so that the scsi layer can ask
to be kicked again after a delay.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c       |    6 ++++--
 block/blk-mq.c         |   47 +++++++++++++++++++++++++++++++++++++++++------
 include/linux/blk-mq.h |    4 +++-
 3 files changed, 48 insertions(+), 9 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index ae6227f..90b6e63 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -251,8 +251,10 @@ void blk_sync_queue(struct request_queue *q)
 		struct blk_mq_hw_ctx *hctx;
 		int i;
 
-		queue_for_each_hw_ctx(q, hctx, i)
-			cancel_delayed_work_sync(&hctx->delayed_work);
+		queue_for_each_hw_ctx(q, hctx, i) {
+			cancel_delayed_work_sync(&hctx->run_work);
+			cancel_delayed_work_sync(&hctx->delay_work);
+		}
 	} else {
 		cancel_delayed_work_sync(&q->delay_work);
 	}
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 8a080c2..128b5e5 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -638,7 +638,7 @@ void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async)
 	if (!async && cpumask_test_cpu(smp_processor_id(), hctx->cpumask))
 		__blk_mq_run_hw_queue(hctx);
 	else if (hctx->queue->nr_hw_queues == 1)
-		kblockd_schedule_delayed_work(&hctx->delayed_work, 0);
+		kblockd_schedule_delayed_work(&hctx->run_work, 0);
 	else {
 		unsigned int cpu;
 
@@ -649,7 +649,7 @@ void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async)
 		 * just queue on the first CPU.
 		 */
 		cpu = cpumask_first(hctx->cpumask);
-		kblockd_schedule_delayed_work_on(cpu, &hctx->delayed_work, 0);
+		kblockd_schedule_delayed_work_on(cpu, &hctx->run_work, 0);
 	}
 }
 
@@ -673,7 +673,8 @@ EXPORT_SYMBOL(blk_mq_run_queues);
 
 void blk_mq_stop_hw_queue(struct blk_mq_hw_ctx *hctx)
 {
-	cancel_delayed_work(&hctx->delayed_work);
+	cancel_delayed_work(&hctx->run_work);
+	cancel_delayed_work(&hctx->delay_work);
 	set_bit(BLK_MQ_S_STOPPED, &hctx->state);
 }
 EXPORT_SYMBOL(blk_mq_stop_hw_queue);
@@ -715,17 +716,50 @@ void blk_mq_start_stopped_hw_queues(struct request_queue *q, bool async)
 }
 EXPORT_SYMBOL(blk_mq_start_stopped_hw_queues);
 
-static void blk_mq_work_fn(struct work_struct *work)
+static void blk_mq_run_work_fn(struct work_struct *work)
 {
 	struct blk_mq_hw_ctx *hctx;
 
-	hctx = container_of(work, struct blk_mq_hw_ctx, delayed_work.work);
+	hctx = container_of(work, struct blk_mq_hw_ctx, run_work.work);
 
 	preempt_disable();
 	__blk_mq_run_hw_queue(hctx);
 	preempt_enable();
 }
 
+static void blk_mq_delay_work_fn(struct work_struct *work)
+{
+	struct blk_mq_hw_ctx *hctx;
+
+	hctx = container_of(work, struct blk_mq_hw_ctx, delay_work.work);
+
+	preempt_disable();
+	if (test_and_clear_bit(BLK_MQ_S_STOPPED, &hctx->state))
+		__blk_mq_run_hw_queue(hctx);
+	preempt_enable();
+}
+
+void blk_mq_delay_queue(struct blk_mq_hw_ctx *hctx, unsigned long msecs)
+{
+	unsigned long tmo = msecs_to_jiffies(msecs);
+
+	if (hctx->queue->nr_hw_queues == 1) {
+		kblockd_schedule_delayed_work(&hctx->delay_work, tmo);
+	} else {
+		unsigned int cpu;
+
+		/*
+		 * It'd be great if the workqueue API had a way to pass
+		 * in a mask and had some smarts for more clever placement
+		 * than the first CPU. Or we could round-robin here. For now,
+		 * just queue on the first CPU.
+		 */
+		cpu = cpumask_first(hctx->cpumask);
+		kblockd_schedule_delayed_work_on(cpu, &hctx->delay_work, tmo);
+	}
+}
+EXPORT_SYMBOL(blk_mq_delay_queue);
+
 static void __blk_mq_insert_request(struct blk_mq_hw_ctx *hctx,
 				    struct request *rq, bool at_head)
 {
@@ -1179,7 +1213,8 @@ static int blk_mq_init_hw_queues(struct request_queue *q,
 		if (node == NUMA_NO_NODE)
 			node = hctx->numa_node = set->numa_node;
 
-		INIT_DELAYED_WORK(&hctx->delayed_work, blk_mq_work_fn);
+		INIT_DELAYED_WORK(&hctx->run_work, blk_mq_run_work_fn);
+		INIT_DELAYED_WORK(&hctx->delay_work, blk_mq_delay_work_fn);
 		spin_lock_init(&hctx->lock);
 		INIT_LIST_HEAD(&hctx->dispatch);
 		hctx->queue = q;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 9ecfab9..ae868e7 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -18,7 +18,8 @@ struct blk_mq_hw_ctx {
 	} ____cacheline_aligned_in_smp;
 
 	unsigned long		state;		/* BLK_MQ_S_* flags */
-	struct delayed_work	delayed_work;
+	struct delayed_work	run_work;
+	struct delayed_work	delay_work;
 	cpumask_var_t		cpumask;
 
 	unsigned long		flags;		/* BLK_MQ_F_* flags */
@@ -158,6 +159,7 @@ void blk_mq_stop_hw_queue(struct blk_mq_hw_ctx *hctx);
 void blk_mq_start_hw_queue(struct blk_mq_hw_ctx *hctx);
 void blk_mq_stop_hw_queues(struct request_queue *q);
 void blk_mq_start_stopped_hw_queues(struct request_queue *q, bool async);
+void blk_mq_delay_queue(struct blk_mq_hw_ctx *hctx, unsigned long msecs);
 
 /*
  * Driver command data is immediately after the request. So subtract request
-- 
1.7.10.4
