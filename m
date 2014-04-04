From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] blk-mq: support for shared tags
Date: Fri, 4 Apr 2014 17:19:30 +0200
Message-ID: <20140404151930.GA5012@lst.de>
References: <1396277175-21382-1-git-send-email-hch@lst.de> <533B56D5.5070803@bjorling.me> <20140402074632.GA11359@lst.de> <533CDF24.9030902@bjorling.me> <20140403073631.GA26921@lst.de> <533D9017.4070609@bjorling.me> <20140403180143.GA23473@lst.de> <533DD6EE.8030000@bjorling.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44365 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414AbaDDPTd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Apr 2014 11:19:33 -0400
Content-Disposition: inline
In-Reply-To: <533DD6EE.8030000@bjorling.me>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matias Bjorling <m@bjorling.me>
Cc: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi Matias,

I've pushed out a new version of the shared tag support to the
blk-mq-share-tags.3 branch of

  git://git.infradead.org/users/hch/scsi.git

and I'm fairly happy how it turned out.  The new blk_mq_tag_set
structure is now allocated by the driver and fully replaces the old
_reg structure which most drivers used in a very race way. blk_mq_init_queue
now only takes the tag_set as argument and doesn't take any other paramters
by itself, giving a very simple user interface.

I've attached the actual shared tags patch below, beside the patches
I already sent to Jens the only other remaining one is the unchanged
patch to initialize requests on allocation.

---
From: Christoph Hellwig <hch@lst.de>
Subject: blk-mq: split out tag initialization, support shared tags

Add a new blk_mq_tag_set structure that gets set up before we initialize
the queue.  A single blk_mq_tag_set structure can be shared by multiple
queues.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq-cpumap.c      |    6 +-
 block/blk-mq-tag.c         |   13 ---
 block/blk-mq.c             |  241 ++++++++++++++++++++++++--------------------
 block/blk-mq.h             |   23 ++++-
 drivers/block/null_blk.c   |   92 ++++++++++-------
 drivers/block/virtio_blk.c |   39 ++++---
 include/linux/blk-mq.h     |   34 +++----
 7 files changed, 253 insertions(+), 195 deletions(-)

diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
index 0979213..5d0f93c 100644
--- a/block/blk-mq-cpumap.c
+++ b/block/blk-mq-cpumap.c
@@ -80,17 +80,17 @@ int blk_mq_update_queue_map(unsigned int *map, unsigned int nr_queues)
 	return 0;
 }
 
-unsigned int *blk_mq_make_queue_map(struct blk_mq_reg *reg)
+unsigned int *blk_mq_make_queue_map(struct blk_mq_tag_set *set)
 {
 	unsigned int *map;
 
 	/* If cpus are offline, map them to first hctx */
 	map = kzalloc_node(sizeof(*map) * num_possible_cpus(), GFP_KERNEL,
-				reg->numa_node);
+				set->numa_node);
 	if (!map)
 		return NULL;
 
-	if (!blk_mq_update_queue_map(map, reg->nr_hw_queues))
+	if (!blk_mq_update_queue_map(map, set->nr_hw_queues))
 		return map;
 
 	kfree(map);
diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 83ae96c..108f82b 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -7,19 +7,6 @@
 #include "blk-mq.h"
 #include "blk-mq-tag.h"
 
-/*
- * Per tagged queue (tag address space) map
- */
-struct blk_mq_tags {
-	unsigned int nr_tags;
-	unsigned int nr_reserved_tags;
-	unsigned int nr_batch_move;
-	unsigned int nr_max_cache;
-
-	struct percpu_ida free_tags;
-	struct percpu_ida reserved_tags;
-};
-
 void blk_mq_wait_for_tags(struct blk_mq_tags *tags)
 {
 	int tag = blk_mq_get_tag(tags, __GFP_WAIT, false);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index ab8e347..2972855 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -81,7 +81,7 @@ static struct request *__blk_mq_alloc_request(struct blk_mq_hw_ctx *hctx,
 
 	tag = blk_mq_get_tag(hctx->tags, gfp, reserved);
 	if (tag != BLK_MQ_TAG_FAIL) {
-		rq = hctx->rqs[tag];
+		rq = hctx->tags->rqs[tag];
 		blk_rq_init(hctx->queue, rq);
 		rq->tag = tag;
 
@@ -401,6 +401,11 @@ static void blk_mq_requeue_request(struct request *rq)
 		rq->nr_phys_segments--;
 }
 
+struct request *blk_mq_tag_to_rq(struct blk_mq_tags *tags, unsigned int tag)
+{
+	return tags->rqs[tag];
+}
+
 struct blk_mq_timeout_data {
 	struct blk_mq_hw_ctx *hctx;
 	unsigned long *next;
@@ -422,12 +427,13 @@ static void blk_mq_timeout_check(void *__data, unsigned long *free_tags)
 	do {
 		struct request *rq;
 
-		tag = find_next_zero_bit(free_tags, hctx->queue_depth, tag);
-		if (tag >= hctx->queue_depth)
+		tag = find_next_zero_bit(free_tags, hctx->tags->nr_tags, tag);
+		if (tag >= hctx->tags->nr_tags)
 			break;
 
-		rq = hctx->rqs[tag++];
-
+		rq = blk_mq_tag_to_rq(hctx->tags, tag++);
+		if (rq->q != hctx->queue)
+			continue;
 		if (!test_bit(REQ_ATOM_STARTED, &rq->atomic_flags))
 			continue;
 
@@ -947,11 +953,11 @@ struct blk_mq_hw_ctx *blk_mq_map_queue(struct request_queue *q, const int cpu)
 }
 EXPORT_SYMBOL(blk_mq_map_queue);
 
-struct blk_mq_hw_ctx *blk_mq_alloc_single_hw_queue(struct blk_mq_reg *reg,
+struct blk_mq_hw_ctx *blk_mq_alloc_single_hw_queue(struct blk_mq_tag_set *set,
 						   unsigned int hctx_index)
 {
 	return kmalloc_node(sizeof(struct blk_mq_hw_ctx),
-				GFP_KERNEL | __GFP_ZERO, reg->numa_node);
+				GFP_KERNEL | __GFP_ZERO, set->numa_node);
 }
 EXPORT_SYMBOL(blk_mq_alloc_single_hw_queue);
 
@@ -1004,31 +1010,31 @@ static void blk_mq_hctx_notify(void *data, unsigned long action,
 	blk_mq_put_ctx(ctx);
 }
 
-static void blk_mq_free_rq_map(struct blk_mq_hw_ctx *hctx, void *driver_data)
+static void blk_mq_free_rq_map(struct blk_mq_tag_set *set,
+		struct blk_mq_tags *tags, unsigned int hctx_idx)
 {
 	struct page *page;
 
-	if (hctx->rqs && hctx->queue->mq_ops->exit_request) {
+	if (tags->rqs && set->ops->exit_request) {
 		int i;
 
-		for (i = 0; i < hctx->queue_depth; i++) {
-			if (!hctx->rqs[i])
+		for (i = 0; i < tags->nr_tags; i++) {
+			if (!tags->rqs[i])
 				continue;
-			hctx->queue->mq_ops->exit_request(driver_data, hctx,
-							  hctx->rqs[i], i);
+			set->ops->exit_request(set->driver_data, tags->rqs[i],
+						hctx_idx, i);
 		}
 	}
 
-	while (!list_empty(&hctx->page_list)) {
-		page = list_first_entry(&hctx->page_list, struct page, lru);
+	while (!list_empty(&tags->page_list)) {
+		page = list_first_entry(&tags->page_list, struct page, lru);
 		list_del_init(&page->lru);
 		__free_pages(page, page->private);
 	}
 
-	kfree(hctx->rqs);
+	kfree(tags->rqs);
 
-	if (hctx->tags)
-		blk_mq_free_tags(hctx->tags);
+	blk_mq_free_tags(tags);
 }
 
 static size_t order_to_size(unsigned int order)
@@ -1041,30 +1047,36 @@ static size_t order_to_size(unsigned int order)
 	return ret;
 }
 
-static int blk_mq_init_rq_map(struct blk_mq_hw_ctx *hctx,
-		struct blk_mq_reg *reg, void *driver_data, int node)
+static struct blk_mq_tags *blk_mq_init_rq_map(struct blk_mq_tag_set *set,
+		unsigned int hctx_idx)
 {
-	unsigned int reserved_tags = reg->reserved_tags;
+	struct blk_mq_tags *tags;
 	unsigned int i, j, entries_per_page, max_order = 4;
 	size_t rq_size, left;
-	int error;
 
-	INIT_LIST_HEAD(&hctx->page_list);
+	tags = blk_mq_init_tags(set->queue_depth, set->reserved_tags,
+				set->numa_node);
+	if (!tags)
+		return NULL;
 
-	hctx->rqs = kmalloc_node(hctx->queue_depth * sizeof(struct request *),
-					GFP_KERNEL, node);
-	if (!hctx->rqs)
-		return -ENOMEM;
+	INIT_LIST_HEAD(&tags->page_list);
+
+	tags->rqs = kmalloc_node(set->queue_depth * sizeof(struct request *),
+					GFP_KERNEL, set->numa_node);
+	if (!tags->rqs) {
+		blk_mq_free_tags(tags);
+		return NULL;
+	}
 
 	/*
 	 * rq_size is the size of the request plus driver payload, rounded
 	 * to the cacheline size
 	 */
-	rq_size = round_up(sizeof(struct request) + hctx->cmd_size,
+	rq_size = round_up(sizeof(struct request) + set->cmd_size,
 				cache_line_size());
-	left = rq_size * hctx->queue_depth;
+	left = rq_size * set->queue_depth;
 
-	for (i = 0; i < hctx->queue_depth;) {
+	for (i = 0; i < set->queue_depth; ) {
 		int this_order = max_order;
 		struct page *page;
 		int to_do;
@@ -1074,7 +1086,8 @@ static int blk_mq_init_rq_map(struct blk_mq_hw_ctx *hctx,
 			this_order--;
 
 		do {
-			page = alloc_pages_node(node, GFP_KERNEL, this_order);
+			page = alloc_pages_node(set->numa_node, GFP_KERNEL,
+						this_order);
 			if (page)
 				break;
 			if (!this_order--)
@@ -1084,22 +1097,22 @@ static int blk_mq_init_rq_map(struct blk_mq_hw_ctx *hctx,
 		} while (1);
 
 		if (!page)
-			break;
+			goto fail;
 
 		page->private = this_order;
-		list_add_tail(&page->lru, &hctx->page_list);
+		list_add_tail(&page->lru, &tags->page_list);
 
 		p = page_address(page);
 		entries_per_page = order_to_size(this_order) / rq_size;
-		to_do = min(entries_per_page, hctx->queue_depth - i);
+		to_do = min(entries_per_page, set->queue_depth - i);
 		left -= to_do * rq_size;
 		for (j = 0; j < to_do; j++) {
-			hctx->rqs[i] = p;
-			if (reg->ops->init_request) {
-				error = reg->ops->init_request(driver_data,
-						hctx, hctx->rqs[i], i);
-				if (error)
-					goto err_rq_map;
+			tags->rqs[i] = p;
+			if (set->ops->init_request) {
+				if (set->ops->init_request(set->driver_data,
+						tags->rqs[i], hctx_idx, i,
+						set->numa_node))
+					goto fail;
 			}
 
 			p += rq_size;
@@ -1107,30 +1120,16 @@ static int blk_mq_init_rq_map(struct blk_mq_hw_ctx *hctx,
 		}
 	}
 
-	if (i < (reserved_tags + BLK_MQ_TAG_MIN)) {
-		error = -ENOMEM;
-		goto err_rq_map;
-	}
-	if (i != hctx->queue_depth) {
-		hctx->queue_depth = i;
-		pr_warn("%s: queue depth set to %u because of low memory\n",
-					__func__, i);
-	}
+	return tags;
 
-	hctx->tags = blk_mq_init_tags(hctx->queue_depth, reserved_tags, node);
-	if (!hctx->tags) {
-		error = -ENOMEM;
-		goto err_rq_map;
-	}
-
-	return 0;
-err_rq_map:
-	blk_mq_free_rq_map(hctx, driver_data);
-	return error;
+fail:
+	pr_warn("%s: failed to allocate requests\n", __func__);
+	blk_mq_free_rq_map(set, tags, hctx_idx);
+	return NULL;
 }
 
 static int blk_mq_init_hw_queues(struct request_queue *q,
-				 struct blk_mq_reg *reg, void *driver_data)
+		struct blk_mq_tag_set *set)
 {
 	struct blk_mq_hw_ctx *hctx;
 	unsigned int i, j;
@@ -1144,23 +1143,21 @@ static int blk_mq_init_hw_queues(struct request_queue *q,
 
 		node = hctx->numa_node;
 		if (node == NUMA_NO_NODE)
-			node = hctx->numa_node = reg->numa_node;
+			node = hctx->numa_node = set->numa_node;
 
 		INIT_DELAYED_WORK(&hctx->delayed_work, blk_mq_work_fn);
 		spin_lock_init(&hctx->lock);
 		INIT_LIST_HEAD(&hctx->dispatch);
 		hctx->queue = q;
 		hctx->queue_num = i;
-		hctx->flags = reg->flags;
-		hctx->queue_depth = reg->queue_depth;
-		hctx->cmd_size = reg->cmd_size;
+		hctx->flags = set->flags;
+		hctx->cmd_size = set->cmd_size;
 
 		blk_mq_init_cpu_notifier(&hctx->cpu_notifier,
 						blk_mq_hctx_notify, hctx);
 		blk_mq_register_cpu_notifier(&hctx->cpu_notifier);
 
-		if (blk_mq_init_rq_map(hctx, reg, driver_data, node))
-			break;
+		hctx->tags = set->tags[i];
 
 		/*
 		 * Allocate space for all possible cpus to avoid allocation in
@@ -1180,8 +1177,8 @@ static int blk_mq_init_hw_queues(struct request_queue *q,
 		hctx->nr_ctx_map = num_maps;
 		hctx->nr_ctx = 0;
 
-		if (reg->ops->init_hctx &&
-		    reg->ops->init_hctx(hctx, driver_data, i))
+		if (set->ops->init_hctx &&
+		    set->ops->init_hctx(hctx, set->driver_data, i))
 			break;
 	}
 
@@ -1195,11 +1192,10 @@ static int blk_mq_init_hw_queues(struct request_queue *q,
 		if (i == j)
 			break;
 
-		if (reg->ops->exit_hctx)
-			reg->ops->exit_hctx(hctx, j);
+		if (set->ops->exit_hctx)
+			set->ops->exit_hctx(hctx, j);
 
 		blk_mq_unregister_cpu_notifier(&hctx->cpu_notifier);
-		blk_mq_free_rq_map(hctx, driver_data);
 		kfree(hctx->ctxs);
 	}
 
@@ -1258,41 +1254,25 @@ static void blk_mq_map_swqueue(struct request_queue *q)
 	}
 }
 
-struct request_queue *blk_mq_init_queue(struct blk_mq_reg *reg,
-					void *driver_data)
+struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 {
 	struct blk_mq_hw_ctx **hctxs;
 	struct blk_mq_ctx *ctx;
 	struct request_queue *q;
 	int i;
 
-	if (!reg->nr_hw_queues ||
-	    !reg->ops->queue_rq || !reg->ops->map_queue ||
-	    !reg->ops->alloc_hctx || !reg->ops->free_hctx)
-		return ERR_PTR(-EINVAL);
-
-	if (!reg->queue_depth)
-		reg->queue_depth = BLK_MQ_MAX_DEPTH;
-	else if (reg->queue_depth > BLK_MQ_MAX_DEPTH) {
-		pr_err("blk-mq: queuedepth too large (%u)\n", reg->queue_depth);
-		reg->queue_depth = BLK_MQ_MAX_DEPTH;
-	}
-
-	if (reg->queue_depth < (reg->reserved_tags + BLK_MQ_TAG_MIN))
-		return ERR_PTR(-EINVAL);
-
 	ctx = alloc_percpu(struct blk_mq_ctx);
 	if (!ctx)
 		return ERR_PTR(-ENOMEM);
 
-	hctxs = kmalloc_node(reg->nr_hw_queues * sizeof(*hctxs), GFP_KERNEL,
-			reg->numa_node);
+	hctxs = kmalloc_node(set->nr_hw_queues * sizeof(*hctxs), GFP_KERNEL,
+			set->numa_node);
 
 	if (!hctxs)
 		goto err_percpu;
 
-	for (i = 0; i < reg->nr_hw_queues; i++) {
-		hctxs[i] = reg->ops->alloc_hctx(reg, i);
+	for (i = 0; i < set->nr_hw_queues; i++) {
+		hctxs[i] = set->ops->alloc_hctx(set, i);
 		if (!hctxs[i])
 			goto err_hctxs;
 
@@ -1300,11 +1280,11 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_reg *reg,
 		hctxs[i]->queue_num = i;
 	}
 
-	q = blk_alloc_queue_node(GFP_KERNEL, reg->numa_node);
+	q = blk_alloc_queue_node(GFP_KERNEL, set->numa_node);
 	if (!q)
 		goto err_hctxs;
 
-	q->mq_map = blk_mq_make_queue_map(reg);
+	q->mq_map = blk_mq_make_queue_map(set);
 	if (!q->mq_map)
 		goto err_map;
 
@@ -1312,33 +1292,34 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_reg *reg,
 	blk_queue_rq_timeout(q, 30000);
 
 	q->nr_queues = nr_cpu_ids;
-	q->nr_hw_queues = reg->nr_hw_queues;
+	q->nr_hw_queues = set->nr_hw_queues;
 
 	q->queue_ctx = ctx;
 	q->queue_hw_ctx = hctxs;
 
-	q->mq_ops = reg->ops;
+	q->mq_ops = set->ops;
 	q->queue_flags |= QUEUE_FLAG_MQ_DEFAULT;
 
 	q->sg_reserved_size = INT_MAX;
 
 	blk_queue_make_request(q, blk_mq_make_request);
-	blk_queue_rq_timed_out(q, reg->ops->timeout);
-	if (reg->timeout)
-		blk_queue_rq_timeout(q, reg->timeout);
+	blk_queue_rq_timed_out(q, set->ops->timeout);
+	if (set->timeout)
+		blk_queue_rq_timeout(q, set->timeout);
 
-	if (reg->ops->complete)
-		blk_queue_softirq_done(q, reg->ops->complete);
+	if (set->ops->complete)
+		blk_queue_softirq_done(q, set->ops->complete);
 
 	blk_mq_init_flush(q);
-	blk_mq_init_cpu_queues(q, reg->nr_hw_queues);
+	blk_mq_init_cpu_queues(q, set->nr_hw_queues);
 
-	q->flush_rq = kzalloc(round_up(sizeof(struct request) + reg->cmd_size,
-				cache_line_size()), GFP_KERNEL);
+	q->flush_rq = kzalloc(round_up(sizeof(struct request) +
+				set->cmd_size, cache_line_size()),
+				GFP_KERNEL);
 	if (!q->flush_rq)
 		goto err_hw;
 
-	if (blk_mq_init_hw_queues(q, reg, driver_data))
+	if (blk_mq_init_hw_queues(q, set))
 		goto err_flush_rq;
 
 	blk_mq_map_swqueue(q);
@@ -1356,10 +1337,10 @@ err_hw:
 err_map:
 	blk_cleanup_queue(q);
 err_hctxs:
-	for (i = 0; i < reg->nr_hw_queues; i++) {
+	for (i = 0; i < set->nr_hw_queues; i++) {
 		if (!hctxs[i])
 			break;
-		reg->ops->free_hctx(hctxs[i], i);
+		set->ops->free_hctx(hctxs[i], i);
 	}
 	kfree(hctxs);
 err_percpu:
@@ -1376,7 +1357,6 @@ void blk_mq_free_queue(struct request_queue *q)
 	queue_for_each_hw_ctx(q, hctx, i) {
 		kfree(hctx->ctx_map);
 		kfree(hctx->ctxs);
-		blk_mq_free_rq_map(hctx, q->queuedata);
 		blk_mq_unregister_cpu_notifier(&hctx->cpu_notifier);
 		if (q->mq_ops->exit_hctx)
 			q->mq_ops->exit_hctx(hctx, i);
@@ -1436,6 +1416,51 @@ static int blk_mq_queue_reinit_notify(struct notifier_block *nb,
 	return NOTIFY_OK;
 }
 
+int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
+{
+	int i;
+
+	if (!set->nr_hw_queues)
+		return -EINVAL;
+	if (!set->queue_depth || set->queue_depth > BLK_MQ_MAX_DEPTH)
+		return -EINVAL;
+	if (set->queue_depth < set->reserved_tags + BLK_MQ_TAG_MIN)
+		return -EINVAL;
+
+	if (!set->nr_hw_queues ||
+	    !set->ops->queue_rq || !set->ops->map_queue ||
+	    !set->ops->alloc_hctx || !set->ops->free_hctx)
+		return -EINVAL;
+
+
+	set->tags = kmalloc_node(set->nr_hw_queues * sizeof(struct blk_mq_tags),
+				 GFP_KERNEL, set->numa_node);
+	if (!set->tags)
+		goto out;
+
+	for (i = 0; i < set->nr_hw_queues; i++) {
+		set->tags[i] = blk_mq_init_rq_map(set, i);
+		if (!set->tags[i])
+			goto out_unwind;
+	}
+
+	return 0;
+
+out_unwind:
+	while (--i >= 0)
+		blk_mq_free_rq_map(set, set->tags[i], i);
+out:
+	return -ENOMEM;
+}
+
+void blk_mq_free_tag_set(struct blk_mq_tag_set *set)
+{
+	int i;
+
+	for (i = 0; i < set->nr_hw_queues; i++)
+		blk_mq_free_rq_map(set, set->tags[i], i);
+}
+
 void blk_mq_disable_hotplug(void)
 {
 	mutex_lock(&all_q_mutex);
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 7964dad..355366e 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -1,6 +1,26 @@
 #ifndef INT_BLK_MQ_H
 #define INT_BLK_MQ_H
 
+#include <linux/percpu_ida.h>
+
+struct blk_mq_tag_set;
+
+/*
+ * Tag address space map.
+ */
+struct blk_mq_tags {
+	unsigned int nr_tags;
+	unsigned int nr_reserved_tags;
+	unsigned int nr_batch_move;
+	unsigned int nr_max_cache;
+
+	struct percpu_ida free_tags;
+	struct percpu_ida reserved_tags;
+
+	struct request **rqs;
+	struct list_head page_list;
+};
+
 struct blk_mq_ctx {
 	struct {
 		spinlock_t		lock;
@@ -46,8 +66,7 @@ void blk_mq_disable_hotplug(void);
 /*
  * CPU -> queue mappings
  */
-struct blk_mq_reg;
-extern unsigned int *blk_mq_make_queue_map(struct blk_mq_reg *reg);
+extern unsigned int *blk_mq_make_queue_map(struct blk_mq_tag_set *set);
 extern int blk_mq_update_queue_map(unsigned int *map, unsigned int nr_queues);
 
 void blk_mq_add_timer(struct request *rq);
diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index 71df69d..8e7e3a0 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -32,6 +32,7 @@ struct nullb {
 	unsigned int index;
 	struct request_queue *q;
 	struct gendisk *disk;
+	struct blk_mq_tag_set tag_set;
 	struct hrtimer timer;
 	unsigned int queue_depth;
 	spinlock_t lock;
@@ -320,10 +321,11 @@ static int null_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *rq)
 	return BLK_MQ_RQ_QUEUE_OK;
 }
 
-static struct blk_mq_hw_ctx *null_alloc_hctx(struct blk_mq_reg *reg, unsigned int hctx_index)
+static struct blk_mq_hw_ctx *null_alloc_hctx(struct blk_mq_tag_set *set,
+		unsigned int hctx_index)
 {
-	int b_size = DIV_ROUND_UP(reg->nr_hw_queues, nr_online_nodes);
-	int tip = (reg->nr_hw_queues % nr_online_nodes);
+	int b_size = DIV_ROUND_UP(set->nr_hw_queues, nr_online_nodes);
+	int tip = (set->nr_hw_queues % nr_online_nodes);
 	int node = 0, i, n;
 
 	/*
@@ -338,7 +340,7 @@ static struct blk_mq_hw_ctx *null_alloc_hctx(struct blk_mq_reg *reg, unsigned in
 
 			tip--;
 			if (!tip)
-				b_size = reg->nr_hw_queues / nr_online_nodes;
+				b_size = set->nr_hw_queues / nr_online_nodes;
 		}
 	}
 
@@ -387,13 +389,17 @@ static struct blk_mq_ops null_mq_ops = {
 	.map_queue      = blk_mq_map_queue,
 	.init_hctx	= null_init_hctx,
 	.complete	= null_softirq_done_fn,
+	.alloc_hctx	= blk_mq_alloc_single_hw_queue,
+	.free_hctx	= blk_mq_free_single_hw_queue,
 };
 
-static struct blk_mq_reg null_mq_reg = {
-	.ops		= &null_mq_ops,
-	.queue_depth	= 64,
-	.cmd_size	= sizeof(struct nullb_cmd),
-	.flags		= BLK_MQ_F_SHOULD_MERGE,
+static struct blk_mq_ops null_mq_ops_pernode = {
+	.queue_rq       = null_queue_rq,
+	.map_queue      = blk_mq_map_queue,
+	.init_hctx	= null_init_hctx,
+	.complete	= null_softirq_done_fn,
+	.alloc_hctx	= null_alloc_hctx,
+	.free_hctx	= null_free_hctx,
 };
 
 static void null_del_dev(struct nullb *nullb)
@@ -402,6 +408,8 @@ static void null_del_dev(struct nullb *nullb)
 
 	del_gendisk(nullb->disk);
 	blk_cleanup_queue(nullb->q);
+	if (queue_mode == NULL_Q_MQ)
+		blk_mq_free_tag_set(&nullb->tag_set);
 	put_disk(nullb->disk);
 	kfree(nullb);
 }
@@ -506,7 +514,7 @@ static int null_add_dev(void)
 
 	nullb = kzalloc_node(sizeof(*nullb), GFP_KERNEL, home_node);
 	if (!nullb)
-		return -ENOMEM;
+		goto out;
 
 	spin_lock_init(&nullb->lock);
 
@@ -514,49 +522,47 @@ static int null_add_dev(void)
 		submit_queues = nr_online_nodes;
 
 	if (setup_queues(nullb))
-		goto err;
+		goto out_free_nullb;
 
 	if (queue_mode == NULL_Q_MQ) {
-		null_mq_reg.numa_node = home_node;
-		null_mq_reg.queue_depth = hw_queue_depth;
-		null_mq_reg.nr_hw_queues = submit_queues;
-
-		if (use_per_node_hctx) {
-			null_mq_reg.ops->alloc_hctx = null_alloc_hctx;
-			null_mq_reg.ops->free_hctx = null_free_hctx;
-		} else {
-			null_mq_reg.ops->alloc_hctx = blk_mq_alloc_single_hw_queue;
-			null_mq_reg.ops->free_hctx = blk_mq_free_single_hw_queue;
-		}
-
-		nullb->q = blk_mq_init_queue(&null_mq_reg, nullb);
+		if (use_per_node_hctx)
+			nullb->tag_set.ops = &null_mq_ops_pernode;
+		else
+			nullb->tag_set.ops = &null_mq_ops;
+		nullb->tag_set.nr_hw_queues = submit_queues;
+		nullb->tag_set.queue_depth = hw_queue_depth;
+		nullb->tag_set.numa_node = home_node;
+		nullb->tag_set.cmd_size	= sizeof(struct nullb_cmd);
+		nullb->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
+		nullb->tag_set.driver_data = nullb;
+
+		if (blk_mq_alloc_tag_set(&nullb->tag_set))
+			goto out_cleanup_queues;
+
+		nullb->q = blk_mq_init_queue(&nullb->tag_set);
+		if (!nullb->q)
+			goto out_cleanup_tags;
 	} else if (queue_mode == NULL_Q_BIO) {
 		nullb->q = blk_alloc_queue_node(GFP_KERNEL, home_node);
+		if (!nullb->q)
+			goto out_cleanup_queues;
 		blk_queue_make_request(nullb->q, null_queue_bio);
 		init_driver_queues(nullb);
 	} else {
 		nullb->q = blk_init_queue_node(null_request_fn, &nullb->lock, home_node);
+		if (!nullb->q)
+			goto out_cleanup_queues;
 		blk_queue_prep_rq(nullb->q, null_rq_prep_fn);
-		if (nullb->q)
-			blk_queue_softirq_done(nullb->q, null_softirq_done_fn);
+		blk_queue_softirq_done(nullb->q, null_softirq_done_fn);
 		init_driver_queues(nullb);
 	}
 
-	if (!nullb->q)
-		goto queue_fail;
-
 	nullb->q->queuedata = nullb;
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, nullb->q);
 
 	disk = nullb->disk = alloc_disk_node(1, home_node);
-	if (!disk) {
-queue_fail:
-		blk_cleanup_queue(nullb->q);
-		cleanup_queues(nullb);
-err:
-		kfree(nullb);
-		return -ENOMEM;
-	}
+	if (!disk)
+		goto out_cleanup_blk_queue;
 
 	mutex_lock(&lock);
 	list_add_tail(&nullb->list, &nullb_list);
@@ -579,6 +585,18 @@ err:
 	sprintf(disk->disk_name, "nullb%d", nullb->index);
 	add_disk(disk);
 	return 0;
+
+out_cleanup_blk_queue:
+	blk_cleanup_queue(nullb->q);
+out_cleanup_tags:
+	if (queue_mode == NULL_Q_MQ)
+		blk_mq_free_tag_set(&nullb->tag_set);
+out_cleanup_queues:
+	cleanup_queues(nullb);
+out_free_nullb:
+	kfree(nullb);
+out:
+	return -ENOMEM;
 }
 
 static int __init null_init(void)
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 87447c1f..0ee66be 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -30,6 +30,9 @@ struct virtio_blk
 	/* The disk structure for the kernel. */
 	struct gendisk *disk;
 
+	/* Block layer tags. */
+	struct blk_mq_tag_set tag_set;
+
 	/* Process context for config space updates */
 	struct work_struct config_work;
 
@@ -474,8 +477,9 @@ static const struct device_attribute dev_attr_cache_type_rw =
 	__ATTR(cache_type, S_IRUGO|S_IWUSR,
 	       virtblk_cache_type_show, virtblk_cache_type_store);
 
-static int virtblk_init_request(void *data, struct blk_mq_hw_ctx *hctx,
-		struct request *rq, unsigned int nr)
+static int virtblk_init_request(void *data, struct request *rq,
+		unsigned int hctx_idx, unsigned int request_idx,
+		unsigned int numa_node)
 {
 	struct virtio_blk *vblk = data;
 	struct virtblk_req *vbr = blk_mq_rq_to_pdu(rq);
@@ -489,16 +493,8 @@ static struct blk_mq_ops virtio_mq_ops = {
 	.map_queue	= blk_mq_map_queue,
 	.alloc_hctx	= blk_mq_alloc_single_hw_queue,
 	.free_hctx	= blk_mq_free_single_hw_queue,
-	.init_request	= virtblk_init_request,
 	.complete	= virtblk_request_done,
-};
-
-static struct blk_mq_reg virtio_mq_reg = {
-	.ops		= &virtio_mq_ops,
-	.nr_hw_queues	= 1,
-	.queue_depth	= 64,
-	.numa_node	= NUMA_NO_NODE,
-	.flags		= BLK_MQ_F_SHOULD_MERGE,
+	.init_request	= virtblk_init_request,
 };
 
 static int virtblk_probe(struct virtio_device *vdev)
@@ -554,14 +550,25 @@ static int virtblk_probe(struct virtio_device *vdev)
 		goto out_free_vq;
 	}
 
-	virtio_mq_reg.cmd_size =
+	memset(&vblk->tag_set, 0, sizeof(vblk->tag_set));
+	vblk->tag_set.ops = &virtio_mq_ops;
+	vblk->tag_set.nr_hw_queues = 1;
+	vblk->tag_set.queue_depth = 64;
+	vblk->tag_set.numa_node = NUMA_NO_NODE;
+	vblk->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
+	vblk->tag_set.cmd_size =
 		sizeof(struct virtblk_req) +
 		sizeof(struct scatterlist) * sg_elems;
+	vblk->tag_set.driver_data = vblk;
 
-	q = vblk->disk->queue = blk_mq_init_queue(&virtio_mq_reg, vblk);
+	err = blk_mq_alloc_tag_set(&vblk->tag_set);
+	if (err)
+		goto out_put_disk;
+
+	q = vblk->disk->queue = blk_mq_init_queue(&vblk->tag_set);
 	if (!q) {
 		err = -ENOMEM;
-		goto out_put_disk;
+		goto out_free_tags;
 	}
 
 	q->queuedata = vblk;
@@ -664,6 +671,8 @@ static int virtblk_probe(struct virtio_device *vdev)
 out_del_disk:
 	del_gendisk(vblk->disk);
 	blk_cleanup_queue(vblk->disk->queue);
+out_free_tags:
+	blk_mq_free_tag_set(&vblk->tag_set);
 out_put_disk:
 	put_disk(vblk->disk);
 out_free_vq:
@@ -690,6 +699,8 @@ static void virtblk_remove(struct virtio_device *vdev)
 	del_gendisk(vblk->disk);
 	blk_cleanup_queue(vblk->disk->queue);
 
+	blk_mq_free_tag_set(&vblk->tag_set);
+
 	/* Stop all the virtqueues. */
 	vdev->config->reset(vdev);
 
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 897ca1a..e3e1f41 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -32,8 +32,6 @@ struct blk_mq_hw_ctx {
 	unsigned int 		nr_ctx_map;
 	unsigned long		*ctx_map;
 
-	struct request		**rqs;
-	struct list_head	page_list;
 	struct blk_mq_tags	*tags;
 
 	unsigned long		queued;
@@ -41,7 +39,6 @@ struct blk_mq_hw_ctx {
 #define BLK_MQ_MAX_DISPATCH_ORDER	10
 	unsigned long		dispatched[BLK_MQ_MAX_DISPATCH_ORDER];
 
-	unsigned int		queue_depth;
 	unsigned int		numa_node;
 	unsigned int		cmd_size;	/* per-request extra data */
 
@@ -49,7 +46,7 @@ struct blk_mq_hw_ctx {
 	struct kobject		kobj;
 };
 
-struct blk_mq_reg {
+struct blk_mq_tag_set {
 	struct blk_mq_ops	*ops;
 	unsigned int		nr_hw_queues;
 	unsigned int		queue_depth;
@@ -58,18 +55,22 @@ struct blk_mq_reg {
 	int			numa_node;
 	unsigned int		timeout;
 	unsigned int		flags;		/* BLK_MQ_F_* */
+	void			*driver_data;
+
+	struct blk_mq_tags	**tags;
 };
 
 typedef int (queue_rq_fn)(struct blk_mq_hw_ctx *, struct request *);
 typedef struct blk_mq_hw_ctx *(map_queue_fn)(struct request_queue *, const int);
-typedef struct blk_mq_hw_ctx *(alloc_hctx_fn)(struct blk_mq_reg *,unsigned int);
+typedef struct blk_mq_hw_ctx *(alloc_hctx_fn)(struct blk_mq_tag_set *,
+		unsigned int);
 typedef void (free_hctx_fn)(struct blk_mq_hw_ctx *, unsigned int);
 typedef int (init_hctx_fn)(struct blk_mq_hw_ctx *, void *, unsigned int);
 typedef void (exit_hctx_fn)(struct blk_mq_hw_ctx *, unsigned int);
-typedef int (init_request_fn)(void *, struct blk_mq_hw_ctx *,
-		struct request *, unsigned int);
-typedef void (exit_request_fn)(void *, struct blk_mq_hw_ctx *,
-		struct request *, unsigned int);
+typedef int (init_request_fn)(void *, struct request *, unsigned int,
+		unsigned int, unsigned int);
+typedef void (exit_request_fn)(void *, struct request *, unsigned int,
+		unsigned int);
 
 struct blk_mq_ops {
 	/*
@@ -126,10 +127,13 @@ enum {
 	BLK_MQ_MAX_DEPTH	= 2048,
 };
 
-struct request_queue *blk_mq_init_queue(struct blk_mq_reg *, void *);
+struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *);
 int blk_mq_register_disk(struct gendisk *);
 void blk_mq_unregister_disk(struct gendisk *);
 
+int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set);
+void blk_mq_free_tag_set(struct blk_mq_tag_set *set);
+
 void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule);
 
 void blk_mq_insert_request(struct request *, bool, bool, bool);
@@ -138,10 +142,10 @@ void blk_mq_free_request(struct request *rq);
 bool blk_mq_can_queue(struct blk_mq_hw_ctx *);
 struct request *blk_mq_alloc_request(struct request_queue *q, int rw, gfp_t gfp);
 struct request *blk_mq_alloc_reserved_request(struct request_queue *q, int rw, gfp_t gfp);
-struct request *blk_mq_rq_from_tag(struct request_queue *q, unsigned int tag);
+struct request *blk_mq_tag_to_rq(struct blk_mq_tags *tags, unsigned int tag);
 
 struct blk_mq_hw_ctx *blk_mq_map_queue(struct request_queue *, const int ctx_index);
-struct blk_mq_hw_ctx *blk_mq_alloc_single_hw_queue(struct blk_mq_reg *, unsigned int);
+struct blk_mq_hw_ctx *blk_mq_alloc_single_hw_queue(struct blk_mq_tag_set *, unsigned int);
 void blk_mq_free_single_hw_queue(struct blk_mq_hw_ctx *, unsigned int);
 
 bool blk_mq_end_io_partial(struct request *rq, int error,
@@ -172,12 +176,6 @@ static inline void *blk_mq_rq_to_pdu(struct request *rq)
 	return (void *) rq + sizeof(*rq);
 }
 
-static inline struct request *blk_mq_tag_to_rq(struct blk_mq_hw_ctx *hctx,
-					       unsigned int tag)
-{
-	return hctx->rqs[tag];
-}
-
 #define queue_for_each_hw_ctx(q, hctx, i)				\
 	for ((i) = 0; (i) < (q)->nr_hw_queues &&			\
 	     ({ hctx = (q)->queue_hw_ctx[i]; 1; }); (i)++)
-- 
1.7.10.4

