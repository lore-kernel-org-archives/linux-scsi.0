Return-Path: <SRS0=v3DL=ZS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46CEFC43141
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 09:14:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A80F20748
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 09:14:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbfKZJOa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 04:14:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:41666 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727470AbfKZJO1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Nov 2019 04:14:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8EEE5AB9D;
        Tue, 26 Nov 2019 09:14:23 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/8] blk-mq: Use a pointer for sbitmap
Date:   Tue, 26 Nov 2019 10:14:11 +0100
Message-Id: <20191126091416.20052-4-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191126091416.20052-1-hare@suse.de>
References: <20191126091416.20052-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of allocating the tag bitmap in place we should be using a
pointer. This is in preparation for shared host-wide bitmaps.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 block/bfq-iosched.c    |  4 +--
 block/blk-mq-debugfs.c |  8 +++---
 block/blk-mq-tag.c     | 68 +++++++++++++++++++++++++++++++-------------------
 block/blk-mq-tag.h     |  4 +--
 block/blk-mq.c         |  5 ++--
 block/kyber-iosched.c  |  4 +--
 6 files changed, 54 insertions(+), 39 deletions(-)

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
index 33a40ae1d60f..fca87470e267 100644
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
 
@@ -484,7 +484,7 @@ static int hctx_tags_bitmap_show(void *data, struct seq_file *m)
 	if (res)
 		goto out;
 	if (hctx->tags)
-		sbitmap_bitmap_show(&hctx->tags->bitmap_tags.sb, m);
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
diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index d7aa23c82dbf..332d71cd3976 100644
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
@@ -440,24 +440,34 @@ static int bt_alloc(struct sbitmap_queue *bt, unsigned int depth,
 				       node);
 }
 
-static struct blk_mq_tags *blk_mq_init_bitmap_tags(struct blk_mq_tags *tags,
-						   int node, int alloc_policy)
+static int blk_mq_init_bitmap_tags(struct blk_mq_tags *tags,
+				   int node, int alloc_policy)
 {
 	unsigned int depth = tags->nr_tags - tags->nr_reserved_tags;
 	bool round_robin = alloc_policy == BLK_TAG_ALLOC_RR;
 
-	if (bt_alloc(&tags->bitmap_tags, depth, round_robin, node))
+	tags->bitmap_tags = kzalloc(sizeof(struct sbitmap_queue), GFP_KERNEL);
+	if (!tags->bitmap_tags)
+		return -ENOMEM;
+	if (bt_alloc(tags->bitmap_tags, depth, round_robin, node))
 		goto free_tags;
-	if (bt_alloc(&tags->breserved_tags, tags->nr_reserved_tags, round_robin,
-		     node))
+
+	tags->breserved_tags = kzalloc(sizeof(struct sbitmap_queue),
+				       GFP_KERNEL);
+	if (!tags->breserved_tags)
 		goto free_bitmap_tags;
+	if (bt_alloc(tags->breserved_tags, tags->nr_reserved_tags,
+		     round_robin, node))
+		goto free_reserved_tags;
 
-	return tags;
+	return 0;
+free_reserved_tags:
+	kfree(tags->breserved_tags);
 free_bitmap_tags:
-	sbitmap_queue_free(&tags->bitmap_tags);
+	sbitmap_queue_free(tags->bitmap_tags);
 free_tags:
-	kfree(tags);
-	return NULL;
+	kfree(tags->bitmap_tags);
+	return -ENOMEM;
 }
 
 struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
@@ -478,13 +488,19 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
 	tags->nr_tags = total_tags;
 	tags->nr_reserved_tags = reserved_tags;
 
-	return blk_mq_init_bitmap_tags(tags, node, alloc_policy);
+	if (blk_mq_init_bitmap_tags(tags, node, alloc_policy) < 0) {
+		kfree(tags);
+		tags = NULL;
+	}
+	return tags;
 }
 
 void blk_mq_free_tags(struct blk_mq_tags *tags)
 {
-	sbitmap_queue_free(&tags->bitmap_tags);
-	sbitmap_queue_free(&tags->breserved_tags);
+	sbitmap_queue_free(tags->bitmap_tags);
+	kfree(tags->bitmap_tags);
+	sbitmap_queue_free(tags->breserved_tags);
+	kfree(tags->breserved_tags);
 	kfree(tags);
 }
 
@@ -534,7 +550,7 @@ int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
 		 * Don't need (or can't) update reserved tags here, they
 		 * remain static and should never need resizing.
 		 */
-		sbitmap_queue_resize(&tags->bitmap_tags,
+		sbitmap_queue_resize(tags->bitmap_tags,
 				tdepth - tags->nr_reserved_tags);
 	}
 
diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h
index 6c0f7c9ce9f6..10b66fd4664a 100644
--- a/block/blk-mq-tag.h
+++ b/block/blk-mq-tag.h
@@ -13,8 +13,8 @@ struct blk_mq_tags {
 
 	atomic_t active_queues;
 
-	struct sbitmap_queue bitmap_tags;
-	struct sbitmap_queue breserved_tags;
+	struct sbitmap_queue *bitmap_tags;
+	struct sbitmap_queue *breserved_tags;
 
 	struct request **rqs;
 	struct request **static_rqs;
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 6b39cf0efdcd..f0c40fcbd8ae 100644
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
-- 
2.16.4

