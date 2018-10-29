From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 01/14] blk-mq: kill q->mq_map
Date: Mon, 29 Oct 2018 10:37:25 -0600
Message-ID: <20181029163738.10172-2-axboe@kernel.dk>
References: <20181029163738.10172-1-axboe@kernel.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181029163738.10172-1-axboe@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

It's just a pointer to set->mq_map, use that instead.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/blk-mq.c         | 13 ++++---------
 block/blk-mq.h         |  4 +++-
 include/linux/blkdev.h |  2 --
 3 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 21e4147c4810..22d5beaab5a0 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2321,7 +2321,7 @@ static void blk_mq_map_swqueue(struct request_queue *q)
 	 * If the cpu isn't present, the cpu is mapped to first hctx.
 	 */
 	for_each_possible_cpu(i) {
-		hctx_idx = q->mq_map[i];
+		hctx_idx = set->mq_map[i];
 		/* unmapped hw queue can be remapped after CPU topo changed */
 		if (!set->tags[hctx_idx] &&
 		    !__blk_mq_alloc_rq_map(set, hctx_idx)) {
@@ -2331,7 +2331,7 @@ static void blk_mq_map_swqueue(struct request_queue *q)
 			 * case, remap the current ctx to hctx[0] which
 			 * is guaranteed to always have tags allocated
 			 */
-			q->mq_map[i] = 0;
+			set->mq_map[i] = 0;
 		}
 
 		ctx = per_cpu_ptr(q->queue_ctx, i);
@@ -2429,8 +2429,6 @@ static void blk_mq_del_queue_tag_set(struct request_queue *q)
 static void blk_mq_add_queue_tag_set(struct blk_mq_tag_set *set,
 				     struct request_queue *q)
 {
-	q->tag_set = set;
-
 	mutex_lock(&set->tag_list_lock);
 
 	/*
@@ -2467,8 +2465,6 @@ void blk_mq_release(struct request_queue *q)
 		kobject_put(&hctx->kobj);
 	}
 
-	q->mq_map = NULL;
-
 	kfree(q->queue_hw_ctx);
 
 	/*
@@ -2588,7 +2584,7 @@ static void blk_mq_realloc_hw_ctxs(struct blk_mq_tag_set *set,
 		int node;
 		struct blk_mq_hw_ctx *hctx;
 
-		node = blk_mq_hw_queue_to_node(q->mq_map, i);
+		node = blk_mq_hw_queue_to_node(set->mq_map, i);
 		/*
 		 * If the hw queue has been mapped to another numa node,
 		 * we need to realloc the hctx. If allocation fails, fallback
@@ -2665,8 +2661,6 @@ struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 	if (!q->queue_hw_ctx)
 		goto err_percpu;
 
-	q->mq_map = set->mq_map;
-
 	blk_mq_realloc_hw_ctxs(set, q);
 	if (!q->nr_hw_queues)
 		goto err_hctxs;
@@ -2675,6 +2669,7 @@ struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 	blk_queue_rq_timeout(q, set->timeout ? set->timeout : 30 * HZ);
 
 	q->nr_queues = nr_cpu_ids;
+	q->tag_set = set;
 
 	q->queue_flags |= QUEUE_FLAG_MQ_DEFAULT;
 
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 9497b47e2526..9536be06d022 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -75,7 +75,9 @@ extern int blk_mq_hw_queue_to_node(unsigned int *map, unsigned int);
 static inline struct blk_mq_hw_ctx *blk_mq_map_queue(struct request_queue *q,
 		int cpu)
 {
-	return q->queue_hw_ctx[q->mq_map[cpu]];
+	struct blk_mq_tag_set *set = q->tag_set;
+
+	return q->queue_hw_ctx[set->mq_map[cpu]];
 }
 
 /*
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c675e2b5af62..4223ae2d2198 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -412,8 +412,6 @@ struct request_queue {
 
 	const struct blk_mq_ops	*mq_ops;
 
-	unsigned int		*mq_map;
-
 	/* sw queues */
 	struct blk_mq_ctx __percpu	*queue_ctx;
 	unsigned int		nr_queues;
-- 
2.17.1
