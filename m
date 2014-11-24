From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] blk-mq: handle the single queue case in blk_mq_hctx_next_cpu
Date: Mon, 24 Nov 2014 09:27:23 +0100
Message-ID: <1416817643-17888-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Don't duplicate the code to handle the not cpu bounce case in the
caller, do it inside blk_mq_hctx_next_cpu instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c | 31 ++++++++++---------------------
 1 file changed, 10 insertions(+), 21 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index c234f33..f8e5358 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -798,10 +798,11 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
  */
 static int blk_mq_hctx_next_cpu(struct blk_mq_hw_ctx *hctx)
 {
-	int cpu = hctx->next_cpu;
+	if (hctx->queue->nr_hw_queues == 1)
+		return WORK_CPU_UNBOUND;
 
 	if (--hctx->next_cpu_batch <= 0) {
-		int next_cpu;
+		int cpu = hctx->next_cpu, next_cpu;
 
 		next_cpu = cpumask_next(hctx->next_cpu, hctx->cpumask);
 		if (next_cpu >= nr_cpu_ids)
@@ -809,9 +810,11 @@ static int blk_mq_hctx_next_cpu(struct blk_mq_hw_ctx *hctx)
 
 		hctx->next_cpu = next_cpu;
 		hctx->next_cpu_batch = BLK_MQ_CPU_WORK_BATCH;
+	
+		return cpu;
 	}
 
-	return cpu;
+	return hctx->next_cpu;
 }
 
 void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async)
@@ -830,14 +833,8 @@ void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async)
 		put_cpu();
 	}
 
-	if (hctx->queue->nr_hw_queues == 1)
-		kblockd_schedule_delayed_work(&hctx->run_work, 0);
-	else {
-		unsigned int cpu;
-
-		cpu = blk_mq_hctx_next_cpu(hctx);
-		kblockd_schedule_delayed_work_on(cpu, &hctx->run_work, 0);
-	}
+	kblockd_schedule_delayed_work_on(blk_mq_hctx_next_cpu(hctx),
+			&hctx->run_work, 0);
 }
 
 void blk_mq_run_queues(struct request_queue *q, bool async)
@@ -929,16 +926,8 @@ static void blk_mq_delay_work_fn(struct work_struct *work)
 
 void blk_mq_delay_queue(struct blk_mq_hw_ctx *hctx, unsigned long msecs)
 {
-	unsigned long tmo = msecs_to_jiffies(msecs);
-
-	if (hctx->queue->nr_hw_queues == 1)
-		kblockd_schedule_delayed_work(&hctx->delay_work, tmo);
-	else {
-		unsigned int cpu;
-
-		cpu = blk_mq_hctx_next_cpu(hctx);
-		kblockd_schedule_delayed_work_on(cpu, &hctx->delay_work, tmo);
-	}
+	kblockd_schedule_delayed_work_on(blk_mq_hctx_next_cpu(hctx),
+			&hctx->delay_work, msecs_to_jiffies(msecs));
 }
 EXPORT_SYMBOL(blk_mq_delay_queue);
 
-- 
1.9.1
