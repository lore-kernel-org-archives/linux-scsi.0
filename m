From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/15] block: simplify blk_init_allocated_queue
Date: Tue, 10 Jan 2017 16:06:08 +0100
Message-ID: <1484060780-15592-4-git-send-email-hch@lst.de>
References: <1484060780-15592-1-git-send-email-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1484060780-15592-1-git-send-email-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

Return an errno value instead of the passed in queue so that the callers
don't have to keep track of two queues, and move the assignment of the
request_fn and lock to the caller as passing them as argument doesn't
simplify anything.  While we're at it also remove two pointless NULL
assignments, given that the request structure is zeroed on allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c       | 38 +++++++++++++++-----------------------
 drivers/md/dm-rq.c     |  3 ++-
 include/linux/blkdev.h |  3 +--
 3 files changed, 18 insertions(+), 26 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 61ba08c..761cee8 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -821,15 +821,19 @@ EXPORT_SYMBOL(blk_init_queue);
 struct request_queue *
 blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
 {
-	struct request_queue *uninit_q, *q;
+	struct request_queue *q;
 
-	uninit_q = blk_alloc_queue_node(GFP_KERNEL, node_id);
-	if (!uninit_q)
+	q = blk_alloc_queue_node(GFP_KERNEL, node_id);
+	if (!q)
 		return NULL;
 
-	q = blk_init_allocated_queue(uninit_q, rfn, lock);
-	if (!q)
-		blk_cleanup_queue(uninit_q);
+	q->request_fn = rfn;
+	if (lock)
+		q->queue_lock = lock;
+	if (blk_init_allocated_queue(q) < 0) {
+		blk_cleanup_queue(q);
+		return NULL;
+	}
 
 	return q;
 }
@@ -837,30 +841,19 @@ EXPORT_SYMBOL(blk_init_queue_node);
 
 static blk_qc_t blk_queue_bio(struct request_queue *q, struct bio *bio);
 
-struct request_queue *
-blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
-			 spinlock_t *lock)
-{
-	if (!q)
-		return NULL;
 
+int blk_init_allocated_queue(struct request_queue *q)
+{
 	q->fq = blk_alloc_flush_queue(q, NUMA_NO_NODE, 0);
 	if (!q->fq)
-		return NULL;
+		return -ENOMEM;
 
 	if (blk_init_rl(&q->root_rl, q, GFP_KERNEL))
 		goto fail;
 
 	INIT_WORK(&q->timeout_work, blk_timeout_work);
-	q->request_fn		= rfn;
-	q->prep_rq_fn		= NULL;
-	q->unprep_rq_fn		= NULL;
 	q->queue_flags		|= QUEUE_FLAG_DEFAULT;
 
-	/* Override internal queue lock with supplied lock pointer */
-	if (lock)
-		q->queue_lock		= lock;
-
 	/*
 	 * This also sets hw/phys segments, boundary and size
 	 */
@@ -878,13 +871,12 @@ blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
 	}
 
 	mutex_unlock(&q->sysfs_lock);
-
-	return q;
+	return 0;
 
 fail:
 	blk_free_flush_queue(q->fq);
 	wbt_exit(q);
-	return NULL;
+	return -ENOMEM;
 }
 EXPORT_SYMBOL(blk_init_allocated_queue);
 
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 9d7275f..93f6e9f 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -823,7 +823,8 @@ static void dm_old_request_fn(struct request_queue *q)
 int dm_old_init_request_queue(struct mapped_device *md)
 {
 	/* Fully initialize the queue */
-	if (!blk_init_allocated_queue(md->queue, dm_old_request_fn, NULL))
+	md->queue->request_fn = dm_old_request_fn;
+	if (blk_init_allocated_queue(md->queue) < 0)
 		return -EINVAL;
 
 	/* disable dm_old_request_fn's merge heuristic by default */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 8369564..9a6f3ab 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1116,8 +1116,7 @@ extern void blk_unprep_request(struct request *);
 extern struct request_queue *blk_init_queue_node(request_fn_proc *rfn,
 					spinlock_t *lock, int node_id);
 extern struct request_queue *blk_init_queue(request_fn_proc *, spinlock_t *);
-extern struct request_queue *blk_init_allocated_queue(struct request_queue *,
-						      request_fn_proc *, spinlock_t *);
+extern int blk_init_allocated_queue(struct request_queue *);
 extern void blk_cleanup_queue(struct request_queue *);
 extern void blk_queue_make_request(struct request_queue *, make_request_fn *);
 extern void blk_queue_bounce_limit(struct request_queue *, u64);
-- 
2.1.4

