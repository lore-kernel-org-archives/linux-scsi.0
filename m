From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 01/15] block: rework flush sequencing for blk-mq
Date: Wed, 05 Feb 2014 04:41:19 -0800
Message-ID: <20140205124152.299135922@bombadil.infradead.org>
References: <20140205124118.332902571@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53225 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaBEMly (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Feb 2014 07:41:54 -0500
Content-Disposition: inline; filename=0001-block-rework-flush-sequencing-for-blk-mq.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org

Switch to using a preallocated flush_rq for blk-mq similar to what's done
with the old request path.  This allows us to set up the request properly
with a tag from the actually allowed range and ->rq_disk as needed by
some drivers.  To make life easier we also switch to dynamic allocation
of ->flush_rq for the old path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c       |   15 ++++++--
 block/blk-flush.c      |   97 +++++++++++++++++-------------------------------
 block/blk-mq.c         |   26 ++++++-------
 block/blk-mq.h         |    1 +
 block/blk-sysfs.c      |    2 +
 include/linux/blk-mq.h |    2 +-
 include/linux/blkdev.h |    9 +----
 7 files changed, 65 insertions(+), 87 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index c00e0bd..d3eb330 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -693,11 +693,20 @@ blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
 	if (!uninit_q)
 		return NULL;
 
+	uninit_q->flush_rq = kzalloc(sizeof(struct request), GFP_KERNEL);
+	if (!uninit_q->flush_rq)
+		goto out_cleanup_queue;
+
 	q = blk_init_allocated_queue(uninit_q, rfn, lock);
 	if (!q)
-		blk_cleanup_queue(uninit_q);
-
+		goto out_free_flush_rq;
 	return q;
+
+out_free_flush_rq:
+	kfree(uninit_q->flush_rq);
+out_cleanup_queue:
+	blk_cleanup_queue(uninit_q);
+	return NULL;
 }
 EXPORT_SYMBOL(blk_init_queue_node);
 
@@ -1127,7 +1136,7 @@ static struct request *blk_old_get_request(struct request_queue *q, int rw,
 struct request *blk_get_request(struct request_queue *q, int rw, gfp_t gfp_mask)
 {
 	if (q->mq_ops)
-		return blk_mq_alloc_request(q, rw, gfp_mask, false);
+		return blk_mq_alloc_request(q, rw, gfp_mask);
 	else
 		return blk_old_get_request(q, rw, gfp_mask);
 }
diff --git a/block/blk-flush.c b/block/blk-flush.c
index 9288aaf..57ef837 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -140,10 +140,16 @@ static void mq_flush_data_run(struct work_struct *work)
 	blk_mq_run_request(rq, true, false);
 }
 
-static void blk_mq_flush_data_insert(struct request *rq)
+static bool blk_flush_queue_rq(struct request *rq)
 {
-	INIT_WORK(&rq->mq_flush_data, mq_flush_data_run);
-	kblockd_schedule_work(rq->q, &rq->mq_flush_data);
+	if (rq->q->mq_ops) {
+		INIT_WORK(&rq->mq_flush_data, mq_flush_data_run);
+		kblockd_schedule_work(rq->q, &rq->mq_flush_data);
+		return false;
+	} else {
+		list_add_tail(&rq->queuelist, &rq->q->queue_head);
+		return true;
+	}
 }
 
 /**
@@ -187,12 +193,7 @@ static bool blk_flush_complete_seq(struct request *rq, unsigned int seq,
 
 	case REQ_FSEQ_DATA:
 		list_move_tail(&rq->flush.list, &q->flush_data_in_flight);
-		if (q->mq_ops)
-			blk_mq_flush_data_insert(rq);
-		else {
-			list_add(&rq->queuelist, &q->queue_head);
-			queued = true;
-		}
+		queued = blk_flush_queue_rq(rq);
 		break;
 
 	case REQ_FSEQ_DONE:
@@ -216,9 +217,6 @@ static bool blk_flush_complete_seq(struct request *rq, unsigned int seq,
 	}
 
 	kicked = blk_kick_flush(q);
-	/* blk_mq_run_flush will run queue */
-	if (q->mq_ops)
-		return queued;
 	return kicked | queued;
 }
 
@@ -230,10 +228,9 @@ static void flush_end_io(struct request *flush_rq, int error)
 	struct request *rq, *n;
 	unsigned long flags = 0;
 
-	if (q->mq_ops) {
-		blk_mq_free_request(flush_rq);
+	if (q->mq_ops)
 		spin_lock_irqsave(&q->mq_flush_lock, flags);
-	}
+
 	running = &q->flush_queue[q->flush_running_idx];
 	BUG_ON(q->flush_pending_idx == q->flush_running_idx);
 
@@ -263,49 +260,14 @@ static void flush_end_io(struct request *flush_rq, int error)
 	 * kblockd.
 	 */
 	if (queued || q->flush_queue_delayed) {
-		if (!q->mq_ops)
-			blk_run_queue_async(q);
-		else
-		/*
-		 * This can be optimized to only run queues with requests
-		 * queued if necessary.
-		 */
-			blk_mq_run_queues(q, true);
+		WARN_ON(q->mq_ops);
+		blk_run_queue_async(q);
 	}
 	q->flush_queue_delayed = 0;
 	if (q->mq_ops)
 		spin_unlock_irqrestore(&q->mq_flush_lock, flags);
 }
 
-static void mq_flush_work(struct work_struct *work)
-{
-	struct request_queue *q;
-	struct request *rq;
-
-	q = container_of(work, struct request_queue, mq_flush_work);
-
-	/* We don't need set REQ_FLUSH_SEQ, it's for consistency */
-	rq = blk_mq_alloc_request(q, WRITE_FLUSH|REQ_FLUSH_SEQ,
-		__GFP_WAIT|GFP_ATOMIC, true);
-	rq->cmd_type = REQ_TYPE_FS;
-	rq->end_io = flush_end_io;
-
-	blk_mq_run_request(rq, true, false);
-}
-
-/*
- * We can't directly use q->flush_rq, because it doesn't have tag and is not in
- * hctx->rqs[]. so we must allocate a new request, since we can't sleep here,
- * so offload the work to workqueue.
- *
- * Note: we assume a flush request finished in any hardware queue will flush
- * the whole disk cache.
- */
-static void mq_run_flush(struct request_queue *q)
-{
-	kblockd_schedule_work(q, &q->mq_flush_work);
-}
-
 /**
  * blk_kick_flush - consider issuing flush request
  * @q: request_queue being kicked
@@ -340,19 +302,31 @@ static bool blk_kick_flush(struct request_queue *q)
 	 * different from running_idx, which means flush is in flight.
 	 */
 	q->flush_pending_idx ^= 1;
+
 	if (q->mq_ops) {
-		mq_run_flush(q);
-		return true;
+		struct blk_mq_ctx *ctx = first_rq->mq_ctx;
+		struct blk_mq_hw_ctx *hctx = q->mq_ops->map_queue(q, ctx->cpu);
+
+		blk_mq_rq_init(hctx, q->flush_rq);
+		q->flush_rq->mq_ctx = ctx;
+
+		/*
+		 * Reuse the tag value from the fist waiting request,
+		 * with blk-mq the tag is generated during request
+		 * allocation and drivers can rely on it being inside
+		 * the range they asked for.
+		 */
+		q->flush_rq->tag = first_rq->tag;
+	} else {
+		blk_rq_init(q, q->flush_rq);
 	}
 
-	blk_rq_init(q, &q->flush_rq);
-	q->flush_rq.cmd_type = REQ_TYPE_FS;
-	q->flush_rq.cmd_flags = WRITE_FLUSH | REQ_FLUSH_SEQ;
-	q->flush_rq.rq_disk = first_rq->rq_disk;
-	q->flush_rq.end_io = flush_end_io;
+	q->flush_rq->cmd_type = REQ_TYPE_FS;
+	q->flush_rq->cmd_flags = WRITE_FLUSH | REQ_FLUSH_SEQ;
+	q->flush_rq->rq_disk = first_rq->rq_disk;
+	q->flush_rq->end_io = flush_end_io;
 
-	list_add_tail(&q->flush_rq.queuelist, &q->queue_head);
-	return true;
+	return blk_flush_queue_rq(q->flush_rq);
 }
 
 static void flush_data_end_io(struct request *rq, int error)
@@ -558,5 +532,4 @@ EXPORT_SYMBOL(blkdev_issue_flush);
 void blk_mq_init_flush(struct request_queue *q)
 {
 	spin_lock_init(&q->mq_flush_lock);
-	INIT_WORK(&q->mq_flush_work, mq_flush_work);
 }
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 57039fc..5c3073f 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -226,15 +226,14 @@ static struct request *blk_mq_alloc_request_pinned(struct request_queue *q,
 	return rq;
 }
 
-struct request *blk_mq_alloc_request(struct request_queue *q, int rw,
-		gfp_t gfp, bool reserved)
+struct request *blk_mq_alloc_request(struct request_queue *q, int rw, gfp_t gfp)
 {
 	struct request *rq;
 
 	if (blk_mq_queue_enter(q))
 		return NULL;
 
-	rq = blk_mq_alloc_request_pinned(q, rw, gfp, reserved);
+	rq = blk_mq_alloc_request_pinned(q, rw, gfp, false);
 	if (rq)
 		blk_mq_put_ctx(rq->mq_ctx);
 	return rq;
@@ -258,7 +257,7 @@ EXPORT_SYMBOL(blk_mq_alloc_reserved_request);
 /*
  * Re-init and set pdu, if we have it
  */
-static void blk_mq_rq_init(struct blk_mq_hw_ctx *hctx, struct request *rq)
+void blk_mq_rq_init(struct blk_mq_hw_ctx *hctx, struct request *rq)
 {
 	blk_rq_init(hctx->queue, rq);
 
@@ -1309,15 +1308,6 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_reg *reg,
 		reg->queue_depth = BLK_MQ_MAX_DEPTH;
 	}
 
-	/*
-	 * Set aside a tag for flush requests.  It will only be used while
-	 * another flush request is in progress but outside the driver.
-	 *
-	 * TODO: only allocate if flushes are supported
-	 */
-	reg->queue_depth++;
-	reg->reserved_tags++;
-
 	if (reg->queue_depth < (reg->reserved_tags + BLK_MQ_TAG_MIN))
 		return ERR_PTR(-EINVAL);
 
@@ -1368,9 +1358,14 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_reg *reg,
 	blk_mq_init_flush(q);
 	blk_mq_init_cpu_queues(q, reg->nr_hw_queues);
 
-	if (blk_mq_init_hw_queues(q, reg, driver_data))
+	q->flush_rq = kzalloc(round_up(sizeof(struct request) + reg->cmd_size,
+				cache_line_size()), GFP_KERNEL);
+	if (!q->flush_rq)
 		goto err_hw;
 
+	if (blk_mq_init_hw_queues(q, reg, driver_data))
+		goto err_flush_rq;
+
 	blk_mq_map_swqueue(q);
 
 	mutex_lock(&all_q_mutex);
@@ -1378,6 +1373,9 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_reg *reg,
 	mutex_unlock(&all_q_mutex);
 
 	return q;
+
+err_flush_rq:
+	kfree(q->flush_rq);
 err_hw:
 	kfree(q->mq_map);
 err_map:
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 5c39179..b771080 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -29,6 +29,7 @@ void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async);
 void blk_mq_init_flush(struct request_queue *q);
 void blk_mq_drain_queue(struct request_queue *q);
 void blk_mq_free_queue(struct request_queue *q);
+void blk_mq_rq_init(struct blk_mq_hw_ctx *hctx, struct request *rq);
 
 /*
  * CPU hotplug helpers
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 8095c4a..7500f87 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -549,6 +549,8 @@ static void blk_release_queue(struct kobject *kobj)
 	if (q->mq_ops)
 		blk_mq_free_queue(q);
 
+	kfree(q->flush_rq);
+
 	blk_trace_shutdown(q);
 
 	bdi_destroy(&q->backing_dev_info);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 161b231..c1684ec 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -123,7 +123,7 @@ void blk_mq_insert_request(struct request_queue *, struct request *, bool);
 void blk_mq_run_queues(struct request_queue *q, bool async);
 void blk_mq_free_request(struct request *rq);
 bool blk_mq_can_queue(struct blk_mq_hw_ctx *);
-struct request *blk_mq_alloc_request(struct request_queue *q, int rw, gfp_t gfp, bool reserved);
+struct request *blk_mq_alloc_request(struct request_queue *q, int rw, gfp_t gfp);
 struct request *blk_mq_alloc_reserved_request(struct request_queue *q, int rw, gfp_t gfp);
 struct request *blk_mq_rq_from_tag(struct request_queue *q, unsigned int tag);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 8678c43..6f02524 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -448,13 +448,8 @@ struct request_queue {
 	unsigned long		flush_pending_since;
 	struct list_head	flush_queue[2];
 	struct list_head	flush_data_in_flight;
-	union {
-		struct request	flush_rq;
-		struct {
-			spinlock_t mq_flush_lock;
-			struct work_struct mq_flush_work;
-		};
-	};
+	struct request		*flush_rq;
+	spinlock_t		mq_flush_lock;
 
 	struct mutex		sysfs_lock;
 
-- 
1.7.10.4


