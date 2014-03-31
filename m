From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/4] blk-mq: support shared tag maps
Date: Mon, 31 Mar 2014 16:46:15 +0200
Message-ID: <1396277175-21382-5-git-send-email-hch@lst.de>
References: <1396277175-21382-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1396277175-21382-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Matias Bjorling <m@bjorling.me>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

---
 block/blk-mq-tag.c     |    2 ++
 block/blk-mq.c         |   83 +++++++++++++++++++++++++++++++++++++++++++-----
 block/blk-mq.h         |    2 ++
 include/linux/blk-mq.h |   12 +++++++
 4 files changed, 91 insertions(+), 8 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 108f82b..a7b1888 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -121,6 +121,8 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
 	if (!tags)
 		return NULL;
 
+	kref_init(&tags->ref_count);
+
 	nr_tags = total_tags - reserved_tags;
 	nr_cache = nr_tags / num_possible_cpus();
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index f1b5d52..3d63d71 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1051,8 +1051,10 @@ void blk_mq_free_commands(struct request_queue *q,
 }
 EXPORT_SYMBOL(blk_mq_free_commands);
 
-static void blk_mq_free_rq_map(struct blk_mq_tags *tags)
+static void blk_mq_free_rq_map(struct kref *kref)
 {
+	struct blk_mq_tags *tags =
+		container_of(kref, struct blk_mq_tags, ref_count);
 	struct page *page;
 
 	while (!list_empty(&tags->page_list)) {
@@ -1066,6 +1068,17 @@ static void blk_mq_free_rq_map(struct blk_mq_tags *tags)
 	blk_mq_free_tags(tags);
 }
 
+static void blk_mq_put_rq_map(struct blk_mq_tags *tags)
+{
+	kref_put(&tags->ref_count, blk_mq_free_rq_map);
+}
+
+static struct blk_mq_tags *blk_mq_get_rq_map(struct blk_mq_tags *tags)
+{
+	kref_get(&tags->ref_count);
+	return tags;
+}
+
 static size_t order_to_size(unsigned int order)
 {
 	size_t ret = PAGE_SIZE;
@@ -1144,7 +1157,7 @@ static struct blk_mq_tags *blk_mq_init_rq_map(unsigned int total_tags,
 
 fail:
 	pr_warn("%s: failed to allocate requests\n", __func__);
-	blk_mq_free_rq_map(tags);
+	blk_mq_put_rq_map(tags);
 	return NULL;
 }
 
@@ -1178,10 +1191,14 @@ static int blk_mq_init_hw_queues(struct request_queue *q,
 						blk_mq_hctx_notify, hctx);
 		blk_mq_register_cpu_notifier(&hctx->cpu_notifier);
 
-		hctx->tags = blk_mq_init_rq_map(hctx->queue_depth,
-				reg->reserved_tags, reg->cmd_size, node);
-		if (!hctx->tags)
-			break;
+		if (reg->shared_tags) {
+			hctx->tags = blk_mq_get_rq_map(reg->shared_tags->tags[i]);
+		} else {
+			hctx->tags = blk_mq_init_rq_map(hctx->queue_depth,
+					reg->reserved_tags, reg->cmd_size, node);
+			if (!hctx->tags)
+				break;
+		}
 
 		/*
 		 * Allocate space for all possible cpus to avoid allocation in
@@ -1221,7 +1238,7 @@ static int blk_mq_init_hw_queues(struct request_queue *q,
 
 		blk_mq_unregister_cpu_notifier(&hctx->cpu_notifier);
 		if (hctx->tags)
-			blk_mq_free_rq_map(hctx->tags);
+			blk_mq_put_rq_map(hctx->tags);
 		kfree(hctx->ctxs);
 	}
 
@@ -1399,7 +1416,7 @@ void blk_mq_free_queue(struct request_queue *q)
 		kfree(hctx->ctx_map);
 		kfree(hctx->ctxs);
 		if (hctx->tags)
-			blk_mq_free_rq_map(hctx->tags);
+			blk_mq_put_rq_map(hctx->tags);
 		blk_mq_unregister_cpu_notifier(&hctx->cpu_notifier);
 		if (q->mq_ops->exit_hctx)
 			q->mq_ops->exit_hctx(hctx, i);
@@ -1459,6 +1476,56 @@ static int blk_mq_queue_reinit_notify(struct notifier_block *nb,
 	return NOTIFY_OK;
 }
 
+struct blk_mq_shared_tags *blk_mq_alloc_shared_tags(struct blk_mq_reg *reg,
+		int (*init)(void *, struct request *), void *data)
+{
+	struct blk_mq_shared_tags *shared_tags;
+	int i, j;
+
+	shared_tags = kmalloc_node(sizeof(*shared_tags) +
+				reg->nr_hw_queues * sizeof(struct blk_mq_tags),
+				GFP_KERNEL, reg->numa_node);
+	if (!shared_tags)
+		goto out;
+
+	shared_tags->nr_hw_queues = reg->nr_hw_queues;
+	shared_tags->queue_depth = reg->queue_depth;
+	for (i = 0; i < reg->nr_hw_queues; i++) {
+		shared_tags->tags[i] = blk_mq_init_rq_map(reg->queue_depth,
+				reg->reserved_tags, reg->cmd_size, reg->numa_node);
+		if (!shared_tags->tags[i])
+			goto out_unwind;
+
+		for (j = 0; j < reg->queue_depth; j++) {
+			struct request *rq = shared_tags->tags[i]->rqs[j];
+			int ret;
+
+			ret = init(data, rq);
+			BUG_ON(ret);
+		}
+	}
+
+	return shared_tags;
+
+out_unwind:
+	while (--i >= 0)
+		blk_mq_put_rq_map(shared_tags->tags[i]);
+out:
+	return NULL;
+}
+
+void blk_mq_free_shared_tags(struct blk_mq_shared_tags *shared_tags,
+		void (*exit)(void *, struct request *), void *data)
+{
+	int i, j;
+
+	for (i = 0; i < shared_tags->nr_hw_queues; i++) {
+		for (j = 0; j < shared_tags->queue_depth; j++)
+			exit(data, shared_tags->tags[i]->rqs[j]);
+		blk_mq_put_rq_map(shared_tags->tags[i]);
+	}
+}
+
 void blk_mq_disable_hotplug(void)
 {
 	mutex_lock(&all_q_mutex);
diff --git a/block/blk-mq.h b/block/blk-mq.h
index eca3a47..d7c753b 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -17,6 +17,8 @@ struct blk_mq_tags {
 
 	struct request **rqs;
 	struct list_head page_list;
+
+	struct kref ref_count;
 };
 
 struct blk_mq_ctx {
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 69aa3ad..a564167 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -47,6 +47,12 @@ struct blk_mq_hw_ctx {
 	struct kobject		kobj;
 };
 
+struct blk_mq_shared_tags {
+	unsigned int		nr_hw_queues;
+	unsigned int		queue_depth;
+	struct blk_mq_tags	*tags[];
+};
+
 struct blk_mq_reg {
 	struct blk_mq_ops	*ops;
 	unsigned int		nr_hw_queues;
@@ -56,6 +62,7 @@ struct blk_mq_reg {
 	int			numa_node;
 	unsigned int		timeout;
 	unsigned int		flags;		/* BLK_MQ_F_* */
+	struct blk_mq_shared_tags *shared_tags;
 };
 
 typedef int (queue_rq_fn)(struct blk_mq_hw_ctx *, struct request *);
@@ -118,6 +125,11 @@ void blk_mq_unregister_disk(struct gendisk *);
 int blk_mq_init_commands(struct request_queue *, int (*init)(void *data, struct blk_mq_hw_ctx *, struct request *, unsigned int), void *data);
 void blk_mq_free_commands(struct request_queue *, void (*free)(void *data, struct blk_mq_hw_ctx *, struct request *, unsigned int), void *data);
 
+struct blk_mq_shared_tags *blk_mq_alloc_shared_tags(struct blk_mq_reg *reg,
+		int (*init)(void *, struct request *), void *data);
+void blk_mq_free_shared_tags(struct blk_mq_shared_tags *shared_tags,
+		void (*exit)(void *, struct request *), void *data);
+
 void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule);
 
 void blk_mq_insert_request(struct request *, bool, bool, bool);
-- 
1.7.10.4
