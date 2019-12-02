Return-Path: <SRS0=lopX=ZY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06337C33CBA
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Dec 2019 15:39:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF36C2084F
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Dec 2019 15:39:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727601AbfLBPjd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Dec 2019 10:39:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:44744 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727553AbfLBPja (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Dec 2019 10:39:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6E1F8C1A5;
        Mon,  2 Dec 2019 15:39:25 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/11] blk-mq: Facilitate a shared sbitmap per tagset
Date:   Mon,  2 Dec 2019 16:39:07 +0100
Message-Id: <20191202153914.84722-5-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191202153914.84722-1-hare@suse.de>
References: <20191202153914.84722-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: John Garry <john.garry@huawei.com>

Some SCSI HBAs (such as HPSA, megaraid, mpt3sas, hisi_sas_v3 ..) support
multiple reply queues with single hostwide tags.

In addition, these drivers want to use interrupt assignment in
pci_alloc_irq_vectors(PCI_IRQ_AFFINITY). However, as discussed in [0],
CPU hotplug may cause in-flight IO completion to not be serviced when an
interrupt is shutdown.

To solve that problem, Ming's patchset to drain hctx's should ensure no
IOs are missed in-flight [1].

However, to take advantage of that patchset, we need to map the HBA HW
queues to blk mq hctx's; to do that, we need to expose the HBA HW queues.

In making that transition, the per-SCSI command request tags are no
longer unique per Scsi host - they are just unique per hctx. As such, the
HBA LLDD would have to generate this tag internally, which has a certain
performance overhead.

However another problem is that blk mq assumes the host may accept
(Scsi_host.can_queue * #hw queue) commands. In [2], we removed the Scsi
host busy counter, which would stop the LLDD being sent more than
.can_queue commands; however, we should still ensure that the block layer
does not issue more than .can_queue commands to the Scsi host.

To solve this problem, introduce a shared sbitmap per blk_mq_tag_set,
which may be requested at init time.

New flag BLK_MQ_F_TAG_HCTX_SHARED should be set when requesting the
tagset to indicate whether the shared sbitmap should be used.

Even when BLK_MQ_F_TAG_HCTX_SHARED is set, we still allocate a full set of
tags and requests per hctx; the reason for this is that if we only allocate
tags and requests for a single hctx - like hctx0 - we may break block
drivers which expect a request be associated with a specific hctx, i.e.
not hctx0.

This is based on work originally from Ming Lei in [3] and from Bart's
suggestion in [4].

[0] https://lore.kernel.org/linux-block/alpine.DEB.2.21.1904051331270.1802@nanos.tec.linutronix.de/
[1] https://lore.kernel.org/linux-block/20191014015043.25029-1-ming.lei@redhat.com/
[2] https://lore.kernel.org/linux-scsi/20191025065855.6309-1-ming.lei@redhat.com/
[3] https://lore.kernel.org/linux-block/20190531022801.10003-1-ming.lei@redhat.com/
[4] https://lore.kernel.org/linux-block/ff77beff-5fd9-9f05-12b6-826922bace1f@huawei.com/T/#m3db0a602f095cbcbff27e9c884d6b4ae826144be

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 block/bfq-iosched.c    |   4 +-
 block/blk-mq-debugfs.c |  10 ++---
 block/blk-mq-sched.c   |  14 ++++++
 block/blk-mq-tag.c     | 114 +++++++++++++++++++++++++++++++++++++++----------
 block/blk-mq-tag.h     |  17 ++++++--
 block/blk-mq.c         |  67 ++++++++++++++++++++++++++---
 block/blk-mq.h         |   5 +++
 block/kyber-iosched.c  |   4 +-
 include/linux/blk-mq.h |   9 ++++
 9 files changed, 204 insertions(+), 40 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 0319d6339822..ca89d0c34994 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -6327,8 +6327,8 @@ static void bfq_depth_updated(struct blk_mq_hw_ctx *hctx)
 	struct blk_mq_tags *tags = hctx->sched_tags;
 	unsigned int min_shallow;
 
-	min_shallow = bfq_update_depths(bfqd, &tags->bitmap_tags);
-	sbitmap_queue_min_shallow_depth(&tags->bitmap_tags, min_shallow);
+	min_shallow = bfq_update_depths(bfqd, tags->bitmap_tags);
+	sbitmap_queue_min_shallow_depth(tags->bitmap_tags, min_shallow);
 }
 
 static int bfq_init_hctx(struct blk_mq_hw_ctx *hctx, unsigned int index)
diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 33a40ae1d60f..46f57dbed890 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -449,11 +449,11 @@ static void blk_mq_debugfs_tags_show(struct seq_file *m,
 		   atomic_read(&tags->active_queues));
 
 	seq_puts(m, "\nbitmap_tags:\n");
-	sbitmap_queue_show(&tags->bitmap_tags, m);
+	sbitmap_queue_show(tags->bitmap_tags, m);
 
 	if (tags->nr_reserved_tags) {
 		seq_puts(m, "\nbreserved_tags:\n");
-		sbitmap_queue_show(&tags->breserved_tags, m);
+		sbitmap_queue_show(tags->breserved_tags, m);
 	}
 }
 
@@ -483,8 +483,8 @@ static int hctx_tags_bitmap_show(void *data, struct seq_file *m)
 	res = mutex_lock_interruptible(&q->sysfs_lock);
 	if (res)
 		goto out;
-	if (hctx->tags)
-		sbitmap_bitmap_show(&hctx->tags->bitmap_tags.sb, m);
+	if (hctx->tags) /* We should just iterate the relevant bits for this hctx FIXME */
+		sbitmap_bitmap_show(&hctx->tags->bitmap_tags->sb, m);
 	mutex_unlock(&q->sysfs_lock);
 
 out:
@@ -518,7 +518,7 @@ static int hctx_sched_tags_bitmap_show(void *data, struct seq_file *m)
 	if (res)
 		goto out;
 	if (hctx->sched_tags)
-		sbitmap_bitmap_show(&hctx->sched_tags->bitmap_tags.sb, m);
+		sbitmap_bitmap_show(&hctx->sched_tags->bitmap_tags->sb, m);
 	mutex_unlock(&q->sysfs_lock);
 
 out:
diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index ca22afd47b3d..1855f8f5edd4 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -492,6 +492,7 @@ static void blk_mq_sched_tags_teardown(struct request_queue *q)
 
 int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
 {
+	struct blk_mq_tag_set *tag_set = q->tag_set;
 	struct blk_mq_hw_ctx *hctx;
 	struct elevator_queue *eq;
 	unsigned int i;
@@ -537,6 +538,19 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
 		blk_mq_debugfs_register_sched_hctx(q, hctx);
 	}
 
+	if (blk_mq_is_sbitmap_shared(tag_set)) {
+		if (!blk_mq_init_sched_shared_sbitmap(tag_set, q->nr_requests)) {
+			ret = -ENOMEM;
+			goto err;
+		}
+		queue_for_each_hw_ctx(q, hctx, i) {
+			struct blk_mq_tags *tags = hctx->sched_tags;
+
+			tags->bitmap_tags = &tag_set->__sched_bitmap_tags;
+			tags->breserved_tags = &tag_set->__sched_breserved_tags;
+		}
+	}
+
 	return 0;
 
 err:
diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index f5009587e1b5..2e714123e846 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -20,7 +20,7 @@ bool blk_mq_has_free_tags(struct blk_mq_tags *tags)
 	if (!tags)
 		return true;
 
-	return sbitmap_any_bit_clear(&tags->bitmap_tags.sb);
+	return sbitmap_any_bit_clear(&tags->bitmap_tags->sb);
 }
 
 /*
@@ -43,9 +43,9 @@ bool __blk_mq_tag_busy(struct blk_mq_hw_ctx *hctx)
  */
 void blk_mq_tag_wakeup_all(struct blk_mq_tags *tags, bool include_reserve)
 {
-	sbitmap_queue_wake_all(&tags->bitmap_tags);
+	sbitmap_queue_wake_all(tags->bitmap_tags);
 	if (include_reserve)
-		sbitmap_queue_wake_all(&tags->breserved_tags);
+		sbitmap_queue_wake_all(tags->breserved_tags);
 }
 
 /*
@@ -121,10 +121,10 @@ unsigned int blk_mq_get_tag(struct blk_mq_alloc_data *data)
 			WARN_ON_ONCE(1);
 			return BLK_MQ_TAG_FAIL;
 		}
-		bt = &tags->breserved_tags;
+		bt = tags->breserved_tags;
 		tag_offset = 0;
 	} else {
-		bt = &tags->bitmap_tags;
+		bt = tags->bitmap_tags;
 		tag_offset = tags->nr_reserved_tags;
 	}
 
@@ -170,9 +170,9 @@ unsigned int blk_mq_get_tag(struct blk_mq_alloc_data *data)
 						data->ctx);
 		tags = blk_mq_tags_from_data(data);
 		if (data->flags & BLK_MQ_REQ_RESERVED)
-			bt = &tags->breserved_tags;
+			bt = tags->breserved_tags;
 		else
-			bt = &tags->bitmap_tags;
+			bt = tags->bitmap_tags;
 
 		/*
 		 * If destination hw queue is changed, fake wake up on
@@ -198,10 +198,10 @@ void blk_mq_put_tag(struct blk_mq_tags *tags, struct blk_mq_ctx *ctx,
 		const int real_tag = tag - tags->nr_reserved_tags;
 
 		BUG_ON(real_tag >= tags->nr_tags);
-		sbitmap_queue_clear(&tags->bitmap_tags, real_tag, ctx->cpu);
+		sbitmap_queue_clear(tags->bitmap_tags, real_tag, ctx->cpu);
 	} else {
 		BUG_ON(tag >= tags->nr_reserved_tags);
-		sbitmap_queue_clear(&tags->breserved_tags, tag, ctx->cpu);
+		sbitmap_queue_clear(tags->breserved_tags, tag, ctx->cpu);
 	}
 }
 
@@ -228,7 +228,7 @@ static bool bt_iter(struct sbitmap *bitmap, unsigned int bitnr, void *data)
 	 * We can hit rq == NULL here, because the tagging functions
 	 * test and set the bit before assigning ->rqs[].
 	 */
-	if (rq && rq->q == hctx->queue)
+	if (rq && rq->q == hctx->queue && rq->mq_hctx == hctx)
 		return iter_data->fn(hctx, rq, iter_data->data, reserved);
 	return true;
 }
@@ -329,8 +329,8 @@ static void blk_mq_all_tag_busy_iter(struct blk_mq_tags *tags,
 		busy_tag_iter_fn *fn, void *priv)
 {
 	if (tags->nr_reserved_tags)
-		bt_tags_for_each(tags, &tags->breserved_tags, fn, priv, true);
-	bt_tags_for_each(tags, &tags->bitmap_tags, fn, priv, false);
+		bt_tags_for_each(tags, tags->breserved_tags, fn, priv, true);
+	bt_tags_for_each(tags, tags->bitmap_tags, fn, priv, false);
 }
 
 /**
@@ -427,8 +427,8 @@ void blk_mq_queue_tag_busy_iter(struct request_queue *q, busy_iter_fn *fn,
 			continue;
 
 		if (tags->nr_reserved_tags)
-			bt_for_each(hctx, &tags->breserved_tags, fn, priv, true);
-		bt_for_each(hctx, &tags->bitmap_tags, fn, priv, false);
+			bt_for_each(hctx, tags->breserved_tags, fn, priv, true);
+		bt_for_each(hctx, tags->bitmap_tags, fn, priv, false);
 	}
 	blk_queue_exit(q);
 }
@@ -446,19 +446,85 @@ static int blk_mq_init_bitmap_tags(struct blk_mq_tags *tags,
 	unsigned int depth = tags->nr_tags - tags->nr_reserved_tags;
 	bool round_robin = alloc_policy == BLK_TAG_ALLOC_RR;
 
-	if (bt_alloc(&tags->bitmap_tags, depth, round_robin, node))
+	if (bt_alloc(&tags->__bitmap_tags, depth, round_robin, node))
 		return -ENOMEM;
-	if (bt_alloc(&tags->breserved_tags, tags->nr_reserved_tags, round_robin,
-		     node))
+	if (bt_alloc(&tags->__breserved_tags, tags->nr_reserved_tags,
+		     round_robin, node))
 		goto free_bitmap_tags;
 
+	tags->bitmap_tags = &tags->__bitmap_tags;
+	tags->breserved_tags = &tags->__breserved_tags;
+
 	return 0;
 free_bitmap_tags:
-	sbitmap_queue_free(&tags->bitmap_tags);
+	sbitmap_queue_free(&tags->__bitmap_tags);
 	return -ENOMEM;
 }
 
-struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
+bool blk_mq_init_shared_sbitmap(struct blk_mq_tag_set *tag_set)
+{
+	unsigned int depth = tag_set->queue_depth -tag_set->reserved_tags;
+	int alloc_policy = BLK_MQ_FLAG_TO_ALLOC_POLICY(tag_set->flags);
+	bool round_robin = alloc_policy == BLK_TAG_ALLOC_RR;
+	int node = tag_set->numa_node;
+
+	if (tag_set->flags & BLK_MQ_F_TAG_BITMAP_ALLOCATED)
+		return false;
+	if (bt_alloc(&tag_set->__bitmap_tags, depth, round_robin, node))
+		return false;
+	if (bt_alloc(&tag_set->__breserved_tags, tag_set->reserved_tags, round_robin,
+			 node))
+		goto free_bitmap_tags;
+	tag_set->flags |= BLK_MQ_F_TAG_BITMAP_ALLOCATED;
+	return true;
+free_bitmap_tags:
+	sbitmap_queue_free(&tag_set->__bitmap_tags);
+	return false;
+}
+
+void blk_mq_exit_shared_sbitmap(struct blk_mq_tag_set *tag_set)
+{
+	if (tag_set->flags & BLK_MQ_F_TAG_BITMAP_ALLOCATED) {
+		sbitmap_queue_free(&tag_set->__bitmap_tags);
+		sbitmap_queue_free(&tag_set->__breserved_tags);
+		tag_set->flags &= ~BLK_MQ_F_TAG_BITMAP_ALLOCATED;
+	}
+}
+
+bool blk_mq_init_sched_shared_sbitmap(struct blk_mq_tag_set *tag_set,
+				      unsigned long nr_requests)
+{
+	unsigned int depth = nr_requests -tag_set->reserved_tags;
+	int alloc_policy = BLK_MQ_FLAG_TO_ALLOC_POLICY(tag_set->flags);
+	bool round_robin = alloc_policy == BLK_TAG_ALLOC_RR;
+	int node = tag_set->numa_node;
+
+	if (tag_set->flags & BLK_MQ_F_TAG_SCHED_BITMAP_ALLOCATED)
+		return false;
+	if (bt_alloc(&tag_set->__sched_bitmap_tags, depth, round_robin, node))
+		return false;
+	if (bt_alloc(&tag_set->__sched_breserved_tags, tag_set->reserved_tags,
+		     round_robin, node))
+		goto free_bitmap_tags;
+
+	tag_set->flags |= BLK_MQ_F_TAG_SCHED_BITMAP_ALLOCATED;
+	return true;
+free_bitmap_tags:
+	sbitmap_queue_free(&tag_set->__sched_bitmap_tags);
+	return false;
+}
+
+void blk_mq_exit_shared_sched_sbitmap(struct blk_mq_tag_set *tag_set)
+{
+	if (tag_set->flags & BLK_MQ_F_TAG_SCHED_BITMAP_ALLOCATED) {
+		sbitmap_queue_free(&tag_set->__sched_bitmap_tags);
+		sbitmap_queue_free(&tag_set->__sched_breserved_tags);
+		tag_set->flags &= ~BLK_MQ_F_TAG_SCHED_BITMAP_ALLOCATED;
+	}
+}
+
+struct blk_mq_tags *blk_mq_init_tags(struct blk_mq_tag_set *set,
+				     unsigned int total_tags,
 				     unsigned int reserved_tags,
 				     int node, int alloc_policy)
 {
@@ -476,6 +542,8 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
 	tags->nr_tags = total_tags;
 	tags->nr_reserved_tags = reserved_tags;
 
+	if (blk_mq_is_sbitmap_shared(set))
+		return tags;
 	if (blk_mq_init_bitmap_tags(tags, node, alloc_policy) < 0) {
 		kfree(tags);
 		tags = NULL;
@@ -485,8 +553,10 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
 
 void blk_mq_free_tags(struct blk_mq_tags *tags)
 {
-	sbitmap_queue_free(&tags->bitmap_tags);
-	sbitmap_queue_free(&tags->breserved_tags);
+	if (tags->bitmap_tags == &tags->__bitmap_tags)
+		sbitmap_queue_free(&tags->__bitmap_tags);
+	if (tags->breserved_tags == &tags->__breserved_tags)
+		sbitmap_queue_free(&tags->__breserved_tags);
 	kfree(tags);
 }
 
@@ -536,7 +606,7 @@ int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
 		 * Don't need (or can't) update reserved tags here, they
 		 * remain static and should never need resizing.
 		 */
-		sbitmap_queue_resize(&tags->bitmap_tags,
+		sbitmap_queue_resize(tags->bitmap_tags,
 				tdepth - tags->nr_reserved_tags);
 	}
 
diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h
index 6c0f7c9ce9f6..9463b878462f 100644
--- a/block/blk-mq-tag.h
+++ b/block/blk-mq-tag.h
@@ -13,8 +13,11 @@ struct blk_mq_tags {
 
 	atomic_t active_queues;
 
-	struct sbitmap_queue bitmap_tags;
-	struct sbitmap_queue breserved_tags;
+	struct sbitmap_queue *bitmap_tags;
+	struct sbitmap_queue *breserved_tags;
+
+	struct sbitmap_queue __bitmap_tags;
+	struct sbitmap_queue __breserved_tags;
 
 	struct request **rqs;
 	struct request **static_rqs;
@@ -22,7 +25,15 @@ struct blk_mq_tags {
 };
 
 
-extern struct blk_mq_tags *blk_mq_init_tags(unsigned int nr_tags, unsigned int reserved_tags, int node, int alloc_policy);
+extern bool blk_mq_init_shared_sbitmap(struct blk_mq_tag_set *tag_set);
+extern void blk_mq_exit_shared_sbitmap(struct blk_mq_tag_set *tag_set);
+extern bool blk_mq_init_sched_shared_sbitmap(struct blk_mq_tag_set *tag_set,
+					     unsigned long nr_requests);
+extern void blk_mq_exit_shared_sched_sbitmap(struct blk_mq_tag_set *tag_set);
+extern struct blk_mq_tags *blk_mq_init_tags(struct blk_mq_tag_set *tag_set,
+					    unsigned int nr_tags,
+					    unsigned int reserved_tags,
+					    int node, int alloc_policy);
 extern void blk_mq_free_tags(struct blk_mq_tags *tags);
 
 extern unsigned int blk_mq_get_tag(struct blk_mq_alloc_data *data);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 91950d3e436a..016f8401cfb9 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1095,7 +1095,7 @@ static int blk_mq_dispatch_wake(wait_queue_entry_t *wait, unsigned mode,
 		struct sbitmap_queue *sbq;
 
 		list_del_init(&wait->entry);
-		sbq = &hctx->tags->bitmap_tags;
+		sbq = hctx->tags->bitmap_tags;
 		atomic_dec(&sbq->ws_active);
 	}
 	spin_unlock(&hctx->dispatch_wait_lock);
@@ -1113,7 +1113,7 @@ static int blk_mq_dispatch_wake(wait_queue_entry_t *wait, unsigned mode,
 static bool blk_mq_mark_tag_wait(struct blk_mq_hw_ctx *hctx,
 				 struct request *rq)
 {
-	struct sbitmap_queue *sbq = &hctx->tags->bitmap_tags;
+	struct sbitmap_queue *sbq = hctx->tags->bitmap_tags;
 	struct wait_queue_head *wq;
 	wait_queue_entry_t *wait;
 	bool ret;
@@ -2081,7 +2081,6 @@ void blk_mq_free_rq_map(struct blk_mq_tags *tags)
 	tags->rqs = NULL;
 	kfree(tags->static_rqs);
 	tags->static_rqs = NULL;
-
 	blk_mq_free_tags(tags);
 }
 
@@ -2097,7 +2096,7 @@ struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
 	if (node == NUMA_NO_NODE)
 		node = set->numa_node;
 
-	tags = blk_mq_init_tags(nr_tags, reserved_tags, node,
+	tags = blk_mq_init_tags(set, nr_tags, reserved_tags, node,
 				BLK_MQ_FLAG_TO_ALLOC_POLICY(set->flags));
 	if (!tags)
 		return NULL;
@@ -2954,8 +2953,10 @@ static int __blk_mq_alloc_rq_maps(struct blk_mq_tag_set *set)
 	return 0;
 
 out_unwind:
-	while (--i >= 0)
+	while (--i >= 0) {
 		blk_mq_free_rq_map(set->tags[i]);
+		set->tags[i] = NULL;
+	}
 
 	return -ENOMEM;
 }
@@ -3100,6 +3101,20 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
 	if (ret)
 		goto out_free_mq_map;
 
+	if (blk_mq_is_sbitmap_shared(set)) {
+		if (!blk_mq_init_shared_sbitmap(set)) {
+			ret = -ENOMEM;
+			goto out_free_mq_map;
+		}
+
+		for (i = 0; i < set->nr_hw_queues; i++) {
+			struct blk_mq_tags *tags = set->tags[i];
+
+			tags->bitmap_tags = &set->__bitmap_tags;
+			tags->breserved_tags = &set->__breserved_tags;
+		}
+	}
+
 	mutex_init(&set->tag_list_lock);
 	INIT_LIST_HEAD(&set->tag_list);
 
@@ -3123,6 +3138,9 @@ void blk_mq_free_tag_set(struct blk_mq_tag_set *set)
 	for (i = 0; i < nr_hw_queues(set); i++)
 		blk_mq_free_map_and_requests(set, i);
 
+	blk_mq_exit_shared_sched_sbitmap(set);
+	blk_mq_exit_shared_sbitmap(set);
+
 	for (j = 0; j < set->nr_maps; j++) {
 		kfree(set->map[j].mq_map);
 		set->map[j].mq_map = NULL;
@@ -3137,6 +3155,7 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
 {
 	struct blk_mq_tag_set *set = q->tag_set;
 	struct blk_mq_hw_ctx *hctx;
+	bool sched_tags = false;
 	int i, ret;
 
 	if (!set)
@@ -3160,6 +3179,7 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
 			ret = blk_mq_tag_update_depth(hctx, &hctx->tags, nr,
 							false);
 		} else {
+			sched_tags = true;
 			ret = blk_mq_tag_update_depth(hctx, &hctx->sched_tags,
 							nr, true);
 		}
@@ -3169,8 +3189,43 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
 			q->elevator->type->ops.depth_updated(hctx);
 	}
 
-	if (!ret)
+	/*
+	 * if ret is 0, all queues should have been updated to the same depth
+	 * if not, then maybe some have been updated - yuk, need to handle this for shared sbitmap...
+	 * if some are updated, we should probably roll back the change altogether. FIXME
+	 */
+	if (!ret) {
+		if (blk_mq_is_sbitmap_shared(set)) {
+			if (sched_tags) {
+				blk_mq_exit_shared_sched_sbitmap(set);
+				if (!blk_mq_init_sched_shared_sbitmap(set, nr))
+					return -ENOMEM; /* fixup error handling */
+
+				queue_for_each_hw_ctx(q, hctx, i) {
+					hctx->sched_tags->bitmap_tags =
+						&set->__sched_bitmap_tags;
+					hctx->sched_tags->breserved_tags =
+						&set->__sched_breserved_tags;
+				}
+			} else {
+				blk_mq_exit_shared_sbitmap(set);
+				if (!blk_mq_init_shared_sbitmap(set))
+					return -ENOMEM; /* fixup error handling */
+
+				queue_for_each_hw_ctx(q, hctx, i) {
+					hctx->tags->bitmap_tags =
+						&set->__bitmap_tags;
+					hctx->tags->breserved_tags =
+						&set->__breserved_tags;
+				}
+			}
+		}
 		q->nr_requests = nr;
+	}
+	/*
+	 * if ret != 0, q->nr_requests would not be updated, yet the depth
+	 * for some hctx may have changed - is that right?
+	 */
 
 	blk_mq_unquiesce_queue(q);
 	blk_mq_unfreeze_queue(q);
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 78d38b5f2793..4c1ea206d3f4 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -166,6 +166,11 @@ struct blk_mq_alloc_data {
 	struct blk_mq_hw_ctx *hctx;
 };
 
+static inline bool blk_mq_is_sbitmap_shared(struct blk_mq_tag_set *tag_set)
+{
+	return !!(tag_set->flags & BLK_MQ_F_TAG_HCTX_SHARED);
+}
+
 static inline struct blk_mq_tags *blk_mq_tags_from_data(struct blk_mq_alloc_data *data)
 {
 	if (data->flags & BLK_MQ_REQ_INTERNAL)
diff --git a/block/kyber-iosched.c b/block/kyber-iosched.c
index 34dcea0ef637..a7a537501d70 100644
--- a/block/kyber-iosched.c
+++ b/block/kyber-iosched.c
@@ -359,7 +359,7 @@ static unsigned int kyber_sched_tags_shift(struct request_queue *q)
 	 * All of the hardware queues have the same depth, so we can just grab
 	 * the shift of the first one.
 	 */
-	return q->queue_hw_ctx[0]->sched_tags->bitmap_tags.sb.shift;
+	return q->queue_hw_ctx[0]->sched_tags->bitmap_tags->sb.shift;
 }
 
 static struct kyber_queue_data *kyber_queue_data_alloc(struct request_queue *q)
@@ -502,7 +502,7 @@ static int kyber_init_hctx(struct blk_mq_hw_ctx *hctx, unsigned int hctx_idx)
 	khd->batching = 0;
 
 	hctx->sched_data = khd;
-	sbitmap_queue_min_shallow_depth(&hctx->sched_tags->bitmap_tags,
+	sbitmap_queue_min_shallow_depth(hctx->sched_tags->bitmap_tags,
 					kqd->async_depth);
 
 	return 0;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 147185394a25..10c9ed3dbe80 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -109,6 +109,12 @@ struct blk_mq_tag_set {
 	unsigned int		flags;		/* BLK_MQ_F_* */
 	void			*driver_data;
 
+	struct sbitmap_queue	__bitmap_tags;
+	struct sbitmap_queue	__breserved_tags;
+
+	struct sbitmap_queue	__sched_bitmap_tags;
+	struct sbitmap_queue	__sched_breserved_tags;
+
 	struct blk_mq_tags	**tags;
 
 	struct mutex		tag_list_lock;
@@ -226,6 +232,9 @@ struct blk_mq_ops {
 enum {
 	BLK_MQ_F_SHOULD_MERGE	= 1 << 0,
 	BLK_MQ_F_TAG_QUEUE_SHARED	= 1 << 1,
+	BLK_MQ_F_TAG_HCTX_SHARED	= 1 << 2,
+	BLK_MQ_F_TAG_BITMAP_ALLOCATED	= 1 << 3,
+	BLK_MQ_F_TAG_SCHED_BITMAP_ALLOCATED = 1 << 4,
 	BLK_MQ_F_BLOCKING	= 1 << 5,
 	BLK_MQ_F_NO_SCHED	= 1 << 6,
 	BLK_MQ_F_ALLOC_POLICY_START_BIT = 8,
-- 
2.16.4

