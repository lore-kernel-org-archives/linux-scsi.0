From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 08/14] blk-mq: separate number of hardware queues from nr_cpu_ids
Date: Mon, 29 Oct 2018 10:37:32 -0600
Message-ID: <20181029163738.10172-9-axboe@kernel.dk>
References: <20181029163738.10172-1-axboe@kernel.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181029163738.10172-1-axboe@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

With multiple maps, nr_cpu_ids is no longer the maximum number of
hardware queues we support on a given devices. The initializer of
the tag_set can have set ->nr_hw_queues larger than the available
number of CPUs, since we can exceed that with multiple queue maps.

Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/blk-mq.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 0fab36372ace..60a951c4934c 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2663,6 +2663,19 @@ static void blk_mq_realloc_hw_ctxs(struct blk_mq_tag_set *set,
 	mutex_unlock(&q->sysfs_lock);
 }
 
+/*
+ * Maximum number of queues we support. For single sets, we'll never have
+ * more than the CPUs (software queues). For multiple sets, the tag_set
+ * user may have set ->nr_hw_queues larger.
+ */
+static unsigned int nr_hw_queues(struct blk_mq_tag_set *set)
+{
+	if (set->nr_maps == 1)
+		return nr_cpu_ids;
+
+	return max(set->nr_hw_queues, nr_cpu_ids);
+}
+
 struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 						  struct request_queue *q)
 {
@@ -2682,7 +2695,8 @@ struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 	/* init q->mq_kobj and sw queues' kobjects */
 	blk_mq_sysfs_init(q);
 
-	q->queue_hw_ctx = kcalloc_node(nr_cpu_ids, sizeof(*(q->queue_hw_ctx)),
+	q->nr_queues = nr_hw_queues(set);
+	q->queue_hw_ctx = kcalloc_node(q->nr_queues, sizeof(*(q->queue_hw_ctx)),
 						GFP_KERNEL, set->numa_node);
 	if (!q->queue_hw_ctx)
 		goto err_percpu;
@@ -2694,7 +2708,6 @@ struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 	INIT_WORK(&q->timeout_work, blk_mq_timeout_work);
 	blk_queue_rq_timeout(q, set->timeout ? set->timeout : 30 * HZ);
 
-	q->nr_queues = nr_cpu_ids;
 	q->tag_set = set;
 
 	q->queue_flags |= QUEUE_FLAG_MQ_DEFAULT;
@@ -2884,12 +2897,13 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
 		set->queue_depth = min(64U, set->queue_depth);
 	}
 	/*
-	 * There is no use for more h/w queues than cpus.
+	 * There is no use for more h/w queues than cpus if we just have
+	 * a single map
 	 */
-	if (set->nr_hw_queues > nr_cpu_ids)
+	if (set->nr_maps == 1 && set->nr_hw_queues > nr_cpu_ids)
 		set->nr_hw_queues = nr_cpu_ids;
 
-	set->tags = kcalloc_node(nr_cpu_ids, sizeof(struct blk_mq_tags *),
+	set->tags = kcalloc_node(nr_hw_queues(set), sizeof(struct blk_mq_tags *),
 				 GFP_KERNEL, set->numa_node);
 	if (!set->tags)
 		return -ENOMEM;
@@ -2932,7 +2946,7 @@ void blk_mq_free_tag_set(struct blk_mq_tag_set *set)
 {
 	int i, j;
 
-	for (i = 0; i < nr_cpu_ids; i++)
+	for (i = 0; i < nr_hw_queues(set); i++)
 		blk_mq_free_map_and_requests(set, i);
 
 	for (j = 0; j < set->nr_maps; j++) {
@@ -3064,7 +3078,7 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
 
 	lockdep_assert_held(&set->tag_list_lock);
 
-	if (nr_hw_queues > nr_cpu_ids)
+	if (set->nr_maps == 1 && nr_hw_queues > nr_cpu_ids)
 		nr_hw_queues = nr_cpu_ids;
 	if (nr_hw_queues < 1 || nr_hw_queues == set->nr_hw_queues)
 		return;
-- 
2.17.1
