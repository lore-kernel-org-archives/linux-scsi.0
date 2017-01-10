From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/15] block: allow specifying size for extra command data
Date: Tue, 10 Jan 2017 16:06:09 +0100
Message-ID: <1484060780-15592-5-git-send-email-hch@lst.de>
References: <1484060780-15592-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52890 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1765612AbdAJPGh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jan 2017 10:06:37 -0500
In-Reply-To: <1484060780-15592-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com

This mirrors the blk-mq capabilities to allocate extra drivers-specific
data behind struct request by setting a cmd_size field, as well as having
a constructor / destructor for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c       | 59 ++++++++++++++++++++++++++++++++++++++++----------
 block/blk-flush.c      |  5 ++---
 block/blk-sysfs.c      |  7 ++++--
 include/linux/blkdev.h |  7 ++++++
 4 files changed, 61 insertions(+), 17 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 761cee8..7190bc1 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -604,17 +604,41 @@ void blk_cleanup_queue(struct request_queue *q)
 EXPORT_SYMBOL(blk_cleanup_queue);
 
 /* Allocate memory local to the request queue */
-static void *alloc_request_struct(gfp_t gfp_mask, void *data)
+static void *alloc_request_simple(gfp_t gfp_mask, void *data)
 {
-	int nid = (int)(long)data;
-	return kmem_cache_alloc_node(request_cachep, gfp_mask, nid);
+	struct request_queue *q = data;
+
+	return kmem_cache_alloc_node(request_cachep, gfp_mask, q->node);
 }
 
-static void free_request_struct(void *element, void *unused)
+static void free_request_simple(void *element, void *data)
 {
 	kmem_cache_free(request_cachep, element);
 }
 
+static void *alloc_request_size(gfp_t gfp_mask, void *data)
+{
+	struct request_queue *q = data;
+	struct request *rq;
+
+	rq = kmalloc_node(sizeof(struct request) + q->cmd_size, gfp_mask,
+			q->node);
+	if (rq && q->init_rq_fn && q->init_rq_fn(q, rq, gfp_mask) < 0) {
+		kfree(rq);
+		rq = NULL;
+	}
+	return rq;
+}
+
+static void free_request_size(void *element, void *data)
+{
+	struct request_queue *q = data;
+
+	if (q->exit_rq_fn)
+		q->exit_rq_fn(q, element);
+	kfree(element);
+}
+
 int blk_init_rl(struct request_list *rl, struct request_queue *q,
 		gfp_t gfp_mask)
 {
@@ -627,10 +651,15 @@ int blk_init_rl(struct request_list *rl, struct request_queue *q,
 	init_waitqueue_head(&rl->wait[BLK_RW_SYNC]);
 	init_waitqueue_head(&rl->wait[BLK_RW_ASYNC]);
 
-	rl->rq_pool = mempool_create_node(BLKDEV_MIN_RQ, alloc_request_struct,
-					  free_request_struct,
-					  (void *)(long)q->node, gfp_mask,
-					  q->node);
+	if (q->cmd_size) {
+		rl->rq_pool = mempool_create_node(BLKDEV_MIN_RQ,
+				alloc_request_size, free_request_size,
+				q, gfp_mask, q->node);
+	} else {
+		rl->rq_pool = mempool_create_node(BLKDEV_MIN_RQ,
+				alloc_request_simple, free_request_simple,
+				q, gfp_mask, q->node);
+	}
 	if (!rl->rq_pool)
 		return -ENOMEM;
 
@@ -844,12 +873,15 @@ static blk_qc_t blk_queue_bio(struct request_queue *q, struct bio *bio);
 
 int blk_init_allocated_queue(struct request_queue *q)
 {
-	q->fq = blk_alloc_flush_queue(q, NUMA_NO_NODE, 0);
+	q->fq = blk_alloc_flush_queue(q, NUMA_NO_NODE, q->cmd_size);
 	if (!q->fq)
 		return -ENOMEM;
 
+	if (q->init_rq_fn && q->init_rq_fn(q, q->fq->flush_rq, GFP_KERNEL))
+		goto out_free_flush_queue;
+
 	if (blk_init_rl(&q->root_rl, q, GFP_KERNEL))
-		goto fail;
+		goto out_exit_flush_rq;
 
 	INIT_WORK(&q->timeout_work, blk_timeout_work);
 	q->queue_flags		|= QUEUE_FLAG_DEFAULT;
@@ -867,13 +899,16 @@ int blk_init_allocated_queue(struct request_queue *q)
 	/* init elevator */
 	if (elevator_init(q, NULL)) {
 		mutex_unlock(&q->sysfs_lock);
-		goto fail;
+		goto out_exit_flush_rq;
 	}
 
 	mutex_unlock(&q->sysfs_lock);
 	return 0;
 
-fail:
+out_exit_flush_rq:
+	if (q->exit_rq_fn)
+		q->exit_rq_fn(q, q->fq->flush_rq);
+out_free_flush_queue:
 	blk_free_flush_queue(q->fq);
 	wbt_exit(q);
 	return -ENOMEM;
diff --git a/block/blk-flush.c b/block/blk-flush.c
index 20b7c7a..f390aea 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -545,11 +545,10 @@ struct blk_flush_queue *blk_alloc_flush_queue(struct request_queue *q,
 	if (!fq)
 		goto fail;
 
-	if (q->mq_ops) {
+	if (q->mq_ops)
 		spin_lock_init(&fq->mq_flush_lock);
-		rq_sz = round_up(rq_sz + cmd_size, cache_line_size());
-	}
 
+	rq_sz = round_up(rq_sz + cmd_size, cache_line_size());
 	fq->flush_rq = kzalloc_node(rq_sz, GFP_KERNEL, node);
 	if (!fq->flush_rq)
 		goto fail_rq;
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 1dbce05..894f773 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -814,10 +814,13 @@ static void blk_release_queue(struct kobject *kobj)
 	if (q->queue_tags)
 		__blk_queue_free_tags(q);
 
-	if (!q->mq_ops)
+	if (!q->mq_ops) {
+		if (q->exit_rq_fn)
+			q->exit_rq_fn(q, q->fq->flush_rq);
 		blk_free_flush_queue(q->fq);
-	else
+	} else {
 		blk_mq_release(q);
+	}
 
 	blk_trace_shutdown(q);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 9a6f3ab..be23859 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -271,6 +271,8 @@ typedef void (softirq_done_fn)(struct request *);
 typedef int (dma_drain_needed_fn)(struct request *);
 typedef int (lld_busy_fn) (struct request_queue *q);
 typedef int (bsg_job_fn) (struct bsg_job *);
+typedef int (init_rq_fn)(struct request_queue *, struct request *, gfp_t);
+typedef void (exit_rq_fn)(struct request_queue *, struct request *);
 
 enum blk_eh_timer_return {
 	BLK_EH_NOT_HANDLED,
@@ -406,6 +408,8 @@ struct request_queue {
 	rq_timed_out_fn		*rq_timed_out_fn;
 	dma_drain_needed_fn	*dma_drain_needed;
 	lld_busy_fn		*lld_busy_fn;
+	init_rq_fn		*init_rq_fn;
+	exit_rq_fn		*exit_rq_fn;
 
 	struct blk_mq_ops	*mq_ops;
 
@@ -570,6 +574,9 @@ struct request_queue {
 	struct bio_set		*bio_split;
 
 	bool			mq_sysfs_init_done;
+
+	size_t			cmd_size;
+	void			*rq_alloc_data;
 };
 
 #define QUEUE_FLAG_QUEUED	1	/* uses generic tag queueing */
-- 
2.1.4

