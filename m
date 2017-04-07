From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v4 4/6] blk-mq: Introduce blk_mq_delay_run_hw_queue()
Date: Fri, 7 Apr 2017 11:16:52 -0700
Message-ID: <20170407181654.27836-5-bart.vanassche@sandisk.com>
References: <20170407181654.27836-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170407181654.27836-1-bart.vanassche@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Long Li <longli@microsoft.com>, "K . Y . Srinivasan" <kys@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

Introduce a function that runs a hardware queue unconditionally
after a delay. Note: there is already a function that stops and
restarts a hardware queue after a delay, namely blk_mq_delay_queue().

This function will be used in the next patch in this series.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Long Li <longli@microsoft.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
---
 block/blk-mq.c         | 32 ++++++++++++++++++++++++++++++--
 include/linux/blk-mq.h |  2 ++
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index aff85d41cea3..836e3a17da54 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1146,7 +1146,8 @@ static int blk_mq_hctx_next_cpu(struct blk_mq_hw_ctx *hctx)
 	return hctx->next_cpu;
 }
 
-void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async)
+static void __blk_mq_delay_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async,
+					unsigned long msecs)
 {
 	if (unlikely(blk_mq_hctx_stopped(hctx) ||
 		     !blk_mq_hw_queue_mapped(hctx)))
@@ -1163,7 +1164,24 @@ void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async)
 		put_cpu();
 	}
 
-	kblockd_schedule_work_on(blk_mq_hctx_next_cpu(hctx), &hctx->run_work);
+	if (msecs == 0)
+		kblockd_schedule_work_on(blk_mq_hctx_next_cpu(hctx),
+					 &hctx->run_work);
+	else
+		kblockd_schedule_delayed_work_on(blk_mq_hctx_next_cpu(hctx),
+						 &hctx->delayed_run_work,
+						 msecs_to_jiffies(msecs));
+}
+
+void blk_mq_delay_run_hw_queue(struct blk_mq_hw_ctx *hctx, unsigned long msecs)
+{
+	__blk_mq_delay_run_hw_queue(hctx, true, msecs);
+}
+EXPORT_SYMBOL(blk_mq_delay_run_hw_queue);
+
+void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async)
+{
+	__blk_mq_delay_run_hw_queue(hctx, async, 0);
 }
 
 void blk_mq_run_hw_queues(struct request_queue *q, bool async)
@@ -1266,6 +1284,15 @@ static void blk_mq_run_work_fn(struct work_struct *work)
 	__blk_mq_run_hw_queue(hctx);
 }
 
+static void blk_mq_delayed_run_work_fn(struct work_struct *work)
+{
+	struct blk_mq_hw_ctx *hctx;
+
+	hctx = container_of(work, struct blk_mq_hw_ctx, delayed_run_work.work);
+
+	__blk_mq_run_hw_queue(hctx);
+}
+
 static void blk_mq_delay_work_fn(struct work_struct *work)
 {
 	struct blk_mq_hw_ctx *hctx;
@@ -1866,6 +1893,7 @@ static int blk_mq_init_hctx(struct request_queue *q,
 		node = hctx->numa_node = set->numa_node;
 
 	INIT_WORK(&hctx->run_work, blk_mq_run_work_fn);
+	INIT_DELAYED_WORK(&hctx->delayed_run_work, blk_mq_delayed_run_work_fn);
 	INIT_DELAYED_WORK(&hctx->delay_work, blk_mq_delay_work_fn);
 	spin_lock_init(&hctx->lock);
 	INIT_LIST_HEAD(&hctx->dispatch);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index bdea90d75274..b90c3d5766cd 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -51,6 +51,7 @@ struct blk_mq_hw_ctx {
 
 	atomic_t		nr_active;
 
+	struct delayed_work	delayed_run_work;
 	struct delayed_work	delay_work;
 
 	struct hlist_node	cpuhp_dead;
@@ -236,6 +237,7 @@ void blk_mq_stop_hw_queues(struct request_queue *q);
 void blk_mq_start_hw_queues(struct request_queue *q);
 void blk_mq_start_stopped_hw_queue(struct blk_mq_hw_ctx *hctx, bool async);
 void blk_mq_start_stopped_hw_queues(struct request_queue *q, bool async);
+void blk_mq_delay_run_hw_queue(struct blk_mq_hw_ctx *hctx, unsigned long msecs);
 void blk_mq_run_hw_queues(struct request_queue *q, bool async);
 void blk_mq_delay_queue(struct blk_mq_hw_ctx *hctx, unsigned long msecs);
 void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
-- 
2.12.0
