From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v5 07/14] blk-mq: Introduce blk_mq_quiesce_queue()
Date: Fri, 28 Oct 2016 17:21:14 -0700
Message-ID: <81a7e98c-51b0-99f0-c143-303425508bff@sandisk.com>
References: <7460e8b2-2cfd-c0d5-7ae7-7f662d89dad3@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7460e8b2-2cfd-c0d5-7ae7-7f662d89dad3-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ming Lei <tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

blk_mq_quiesce_queue() waits until ongoing .queue_rq() invocations
have finished. This function does *not* wait until all outstanding
requests have finished (this means invocation of request.end_io()).
The algorithm used by blk_mq_quiesce_queue() is as follows:
* Hold either an RCU read lock or an SRCU read lock around
  .queue_rq() calls. The former is used if .queue_rq() does not
  block and the latter if .queue_rq() may block.
* blk_mq_quiesce_queue() first calls blk_mq_stop_hw_queues()
  followed by synchronize_srcu() or synchronize_rcu(). The latter
  call waits for .queue_rq() invocations that started before
  blk_mq_quiesce_queue() was called.
* The blk_mq_hctx_stopped() calls that control whether or not
  .queue_rq() will be called are called with the (S)RCU read lock
  held. This is necessary to avoid race conditions against
  blk_mq_quiesce_queue().

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Ming Lei <tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
---
 block/Kconfig          |  1 +
 block/blk-mq.c         | 71 +++++++++++++++++++++++++++++++++++++++++++++-----
 include/linux/blk-mq.h |  3 +++
 include/linux/blkdev.h |  1 +
 4 files changed, 69 insertions(+), 7 deletions(-)

diff --git a/block/Kconfig b/block/Kconfig
index 1d4d624..0562ef9 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -5,6 +5,7 @@ menuconfig BLOCK
        bool "Enable the block layer" if EXPERT
        default y
        select SBITMAP
+       select SRCU
        help
 	 Provide block layer support for the kernel.
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 534128a..96015a9 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -115,6 +115,33 @@ void blk_mq_unfreeze_queue(struct request_queue *q)
 }
 EXPORT_SYMBOL_GPL(blk_mq_unfreeze_queue);
 
+/**
+ * blk_mq_quiesce_queue() - wait until all ongoing queue_rq calls have finished
+ * @q: request queue.
+ *
+ * Note: this function does not prevent that the struct request end_io()
+ * callback function is invoked. Additionally, it is not prevented that
+ * new queue_rq() calls occur unless the queue has been stopped first.
+ */
+void blk_mq_quiesce_queue(struct request_queue *q)
+{
+	struct blk_mq_hw_ctx *hctx;
+	unsigned int i;
+	bool rcu = false;
+
+	blk_mq_stop_hw_queues(q);
+
+	queue_for_each_hw_ctx(q, hctx, i) {
+		if (hctx->flags & BLK_MQ_F_BLOCKING)
+			synchronize_srcu(&hctx->queue_rq_srcu);
+		else
+			rcu = true;
+	}
+	if (rcu)
+		synchronize_rcu();
+}
+EXPORT_SYMBOL_GPL(blk_mq_quiesce_queue);
+
 void blk_mq_wake_waiters(struct request_queue *q)
 {
 	struct blk_mq_hw_ctx *hctx;
@@ -768,7 +795,7 @@ static inline unsigned int queued_to_index(unsigned int queued)
  * of IO. In particular, we'd like FIFO behaviour on handling existing
  * items on the hctx->dispatch list. Ignore that for now.
  */
-static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
+static void blk_mq_process_rq_list(struct blk_mq_hw_ctx *hctx)
 {
 	struct request_queue *q = hctx->queue;
 	struct request *rq;
@@ -780,9 +807,6 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
 	if (unlikely(blk_mq_hctx_stopped(hctx)))
 		return;
 
-	WARN_ON(!cpumask_test_cpu(raw_smp_processor_id(), hctx->cpumask) &&
-		cpu_online(hctx->next_cpu));
-
 	hctx->run++;
 
 	/*
@@ -873,6 +897,24 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
 	}
 }
 
+static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
+{
+	int srcu_idx;
+
+	WARN_ON(!cpumask_test_cpu(raw_smp_processor_id(), hctx->cpumask) &&
+		cpu_online(hctx->next_cpu));
+
+	if (!(hctx->flags & BLK_MQ_F_BLOCKING)) {
+		rcu_read_lock();
+		blk_mq_process_rq_list(hctx);
+		rcu_read_unlock();
+	} else {
+		srcu_idx = srcu_read_lock(&hctx->queue_rq_srcu);
+		blk_mq_process_rq_list(hctx);
+		srcu_read_unlock(&hctx->queue_rq_srcu, srcu_idx);
+	}
+}
+
 /*
  * It'd be great if the workqueue API had a way to pass
  * in a mask and had some smarts for more clever placement.
@@ -1283,7 +1325,7 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 	const int is_flush_fua = bio->bi_opf & (REQ_PREFLUSH | REQ_FUA);
 	struct blk_map_ctx data;
 	struct request *rq;
-	unsigned int request_count = 0;
+	unsigned int request_count = 0, srcu_idx;
 	struct blk_plug *plug;
 	struct request *same_queue_rq = NULL;
 	blk_qc_t cookie;
@@ -1326,7 +1368,7 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 		blk_mq_bio_to_request(rq, bio);
 
 		/*
-		 * We do limited pluging. If the bio can be merged, do that.
+		 * We do limited plugging. If the bio can be merged, do that.
 		 * Otherwise the existing request in the plug list will be
 		 * issued. So the plug list will have one request at most
 		 */
@@ -1346,7 +1388,16 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 		blk_mq_put_ctx(data.ctx);
 		if (!old_rq)
 			goto done;
-		blk_mq_try_issue_directly(data.hctx, old_rq, &cookie);
+
+		if (!(data.hctx->flags & BLK_MQ_F_BLOCKING)) {
+			rcu_read_lock();
+			blk_mq_try_issue_directly(data.hctx, old_rq, &cookie);
+			rcu_read_unlock();
+		} else {
+			srcu_idx = srcu_read_lock(&data.hctx->queue_rq_srcu);
+			blk_mq_try_issue_directly(data.hctx, old_rq, &cookie);
+			srcu_read_unlock(&data.hctx->queue_rq_srcu, srcu_idx);
+		}
 		goto done;
 	}
 
@@ -1625,6 +1676,9 @@ static void blk_mq_exit_hctx(struct request_queue *q,
 	if (set->ops->exit_hctx)
 		set->ops->exit_hctx(hctx, hctx_idx);
 
+	if (hctx->flags & BLK_MQ_F_BLOCKING)
+		cleanup_srcu_struct(&hctx->queue_rq_srcu);
+
 	blk_mq_remove_cpuhp(hctx);
 	blk_free_flush_queue(hctx->fq);
 	sbitmap_free(&hctx->ctx_map);
@@ -1705,6 +1759,9 @@ static int blk_mq_init_hctx(struct request_queue *q,
 				   flush_start_tag + hctx_idx, node))
 		goto free_fq;
 
+	if (hctx->flags & BLK_MQ_F_BLOCKING)
+		init_srcu_struct(&hctx->queue_rq_srcu);
+
 	return 0;
 
  free_fq:
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index a85a20f..ed20ac7 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -3,6 +3,7 @@
 
 #include <linux/blkdev.h>
 #include <linux/sbitmap.h>
+#include <linux/srcu.h>
 
 struct blk_mq_tags;
 struct blk_flush_queue;
@@ -35,6 +36,8 @@ struct blk_mq_hw_ctx {
 
 	struct blk_mq_tags	*tags;
 
+	struct srcu_struct	queue_rq_srcu;
+
 	unsigned long		queued;
 	unsigned long		run;
 #define BLK_MQ_MAX_DISPATCH_ORDER	7
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c47c358..8259d87 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -824,6 +824,7 @@ extern void __blk_run_queue(struct request_queue *q);
 extern void __blk_run_queue_uncond(struct request_queue *q);
 extern void blk_run_queue(struct request_queue *);
 extern void blk_run_queue_async(struct request_queue *q);
+extern void blk_mq_quiesce_queue(struct request_queue *q);
 extern int blk_rq_map_user(struct request_queue *, struct request *,
 			   struct rq_map_data *, void __user *, unsigned long,
 			   gfp_t);
-- 
2.10.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
