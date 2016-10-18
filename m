From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v3 04/11] blk-mq: Introduce blk_mq_quiesce_queue()
Date: Tue, 18 Oct 2016 14:50:25 -0700
Message-ID: <e42a952c-f245-eb39-d0a1-0336035573f9@sandisk.com>
References: <b39eb0e7-1007-eb63-8e7f-9a7f08508379@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <b39eb0e7-1007-eb63-8e7f-9a7f08508379@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, Ming Lin <ming.l@ssi.samsung.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

blk_mq_quiesce_queue() waits until ongoing .queue_rq() invocations
have finished. This function does *not* wait until all outstanding
requests have finished (this means invocation of request.end_io()).

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Ming Lei <tom.leiming@gmail.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 block/blk-mq.c         | 78 ++++++++++++++++++++++++++++++++++++++++++++------
 include/linux/blk-mq.h |  3 ++
 include/linux/blkdev.h |  1 +
 3 files changed, 73 insertions(+), 9 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 4643fa8..d41ed92 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -115,6 +115,30 @@ void blk_mq_unfreeze_queue(struct request_queue *q)
 }
 EXPORT_SYMBOL_GPL(blk_mq_unfreeze_queue);
 
+/**
+ * blk_mq_quiesce_queue() - wait until all ongoing queue_rq calls have finished
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
@@ -778,7 +802,7 @@ static inline unsigned int queued_to_index(unsigned int queued)
  * of IO. In particular, we'd like FIFO behaviour on handling existing
  * items on the hctx->dispatch list. Ignore that for now.
  */
-static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
+static void blk_mq_process_rq_list(struct blk_mq_hw_ctx *hctx)
 {
 	struct request_queue *q = hctx->queue;
 	struct request *rq;
@@ -790,9 +814,6 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
 	if (unlikely(blk_mq_hctx_stopped(hctx)))
 		return;
 
-	WARN_ON(!cpumask_test_cpu(raw_smp_processor_id(), hctx->cpumask) &&
-		cpu_online(hctx->next_cpu));
-
 	hctx->run++;
 
 	/*
@@ -883,6 +904,24 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
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
@@ -1278,6 +1317,14 @@ static int blk_mq_direct_issue_request(struct request *rq, blk_qc_t *cookie)
 	return -1;
 }
 
+static void blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
+				      struct request *rq, blk_qc_t *cookie)
+{
+	if (blk_mq_hctx_stopped(hctx) ||
+	    blk_mq_direct_issue_request(rq, cookie) != 0)
+		blk_mq_insert_request(rq, false, true, true);
+}
+
 /*
  * Multiple hardware queue variant. This will not use per-process plugs,
  * but will attempt to bypass the hctx queueing if we can go straight to
@@ -1289,7 +1336,7 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 	const int is_flush_fua = bio->bi_opf & (REQ_PREFLUSH | REQ_FUA);
 	struct blk_map_ctx data;
 	struct request *rq;
-	unsigned int request_count = 0;
+	unsigned int request_count = 0, srcu_idx;
 	struct blk_plug *plug;
 	struct request *same_queue_rq = NULL;
 	blk_qc_t cookie;
@@ -1332,7 +1379,7 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 		blk_mq_bio_to_request(rq, bio);
 
 		/*
-		 * We do limited pluging. If the bio can be merged, do that.
+		 * We do limited plugging. If the bio can be merged, do that.
 		 * Otherwise the existing request in the plug list will be
 		 * issued. So the plug list will have one request at most
 		 */
@@ -1352,9 +1399,16 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 		blk_mq_put_ctx(data.ctx);
 		if (!old_rq)
 			goto done;
-		if (blk_mq_hctx_stopped(data.hctx) ||
-		    blk_mq_direct_issue_request(old_rq, &cookie) != 0)
-			blk_mq_insert_request(old_rq, false, true, true);
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
 
@@ -1633,6 +1687,9 @@ static void blk_mq_exit_hctx(struct request_queue *q,
 	if (set->ops->exit_hctx)
 		set->ops->exit_hctx(hctx, hctx_idx);
 
+	if (hctx->flags & BLK_MQ_F_BLOCKING)
+		cleanup_srcu_struct(&hctx->queue_rq_srcu);
+
 	blk_mq_remove_cpuhp(hctx);
 	blk_free_flush_queue(hctx->fq);
 	sbitmap_free(&hctx->ctx_map);
@@ -1713,6 +1770,9 @@ static int blk_mq_init_hctx(struct request_queue *q,
 				   flush_start_tag + hctx_idx, node))
 		goto free_fq;
 
+	if (hctx->flags & BLK_MQ_F_BLOCKING)
+		init_srcu_struct(&hctx->queue_rq_srcu);
+
 	return 0;
 
  free_fq:
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 523376a..02c3918 100644
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

