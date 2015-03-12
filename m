From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 2/7] blk-mq: add blk_mq_init_allocated_queue and export blk_mq_register_disk
Date: Wed, 11 Mar 2015 23:56:37 -0400
Message-ID: <1426132602-34331-3-git-send-email-snitzer@redhat.com>
References: <1426132602-34331-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426132602-34331-1-git-send-email-snitzer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

Add a variant of blk_mq_init_queue that allows a previously allocated
queue to be initialized.  blk_mq_init_allocated_queue models
blk_init_allocated_queue -- which was also created for DM's use.

DM's approach to device creation requires a placeholder request_queue be
allocated for use with alloc_dev() but the decision about what type of
request_queue will be ultimately created is deferred until all component
devices referenced in the DM table are processed to determine the table
type (request-based, blk-mq request-based, or bio-based).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-mq-sysfs.c   |  1 +
 block/blk-mq.c         | 28 +++++++++++++++++++---------
 include/linux/blk-mq.h |  2 ++
 3 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/block/blk-mq-sysfs.c b/block/blk-mq-sysfs.c
index 1630a20..b79685e 100644
--- a/block/blk-mq-sysfs.c
+++ b/block/blk-mq-sysfs.c
@@ -436,6 +436,7 @@ int blk_mq_register_disk(struct gendisk *disk)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(blk_mq_register_disk);
 
 void blk_mq_sysfs_unregister(struct request_queue *q)
 {
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 459840c..d576a78 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1891,9 +1891,25 @@ void blk_mq_release(struct request_queue *q)
 
 struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 {
+	struct request_queue *uninit_q, *q;
+
+	uninit_q = blk_alloc_queue_node(GFP_KERNEL, set->numa_node);
+	if (!uninit_q)
+		return ERR_PTR(-ENOMEM);
+
+	q = blk_mq_init_allocated_queue(set, uninit_q);
+	if (!q)
+		blk_cleanup_queue(uninit_q);
+
+	return q;
+}
+EXPORT_SYMBOL(blk_mq_init_queue);
+
+struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
+						  struct request_queue *q)
+{
 	struct blk_mq_hw_ctx **hctxs;
 	struct blk_mq_ctx __percpu *ctx;
-	struct request_queue *q;
 	unsigned int *map;
 	int i;
 
@@ -1928,10 +1944,6 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 		hctxs[i]->queue_num = i;
 	}
 
-	q = blk_alloc_queue_node(GFP_KERNEL, set->numa_node);
-	if (!q)
-		goto err_hctxs;
-
 	/*
 	 * Init percpu_ref in atomic mode so that it's faster to shutdown.
 	 * See blk_register_queue() for details.
@@ -1981,7 +1993,7 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 	blk_mq_init_cpu_queues(q, set->nr_hw_queues);
 
 	if (blk_mq_init_hw_queues(q, set))
-		goto err_hw;
+		goto err_hctxs;
 
 	mutex_lock(&all_q_mutex);
 	list_add_tail(&q->all_q_node, &all_q_list);
@@ -1993,8 +2005,6 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 
 	return q;
 
-err_hw:
-	blk_cleanup_queue(q);
 err_hctxs:
 	kfree(map);
 	for (i = 0; i < set->nr_hw_queues; i++) {
@@ -2009,7 +2019,7 @@ err_percpu:
 	free_percpu(ctx);
 	return ERR_PTR(-ENOMEM);
 }
-EXPORT_SYMBOL(blk_mq_init_queue);
+EXPORT_SYMBOL(blk_mq_init_allocated_queue);
 
 void blk_mq_free_queue(struct request_queue *q)
 {
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 7aec861..9a75c88 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -164,6 +164,8 @@ enum {
 		<< BLK_MQ_F_ALLOC_POLICY_START_BIT)
 
 struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *);
+struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
+						  struct request_queue *q);
 void blk_mq_finish_init(struct request_queue *q);
 int blk_mq_register_disk(struct gendisk *);
 void blk_mq_unregister_disk(struct gendisk *);
-- 
1.9.5 (Apple Git-50.3)
