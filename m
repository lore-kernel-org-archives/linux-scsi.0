Return-Path: <SRS0=v3DL=ZS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 902A1C432C0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 13:10:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 565942071E
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 13:10:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbfKZNKe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 08:10:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:36612 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727309AbfKZNK2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Nov 2019 08:10:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2B87BB322;
        Tue, 26 Nov 2019 13:10:25 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/8] blk-mq: Facilitate a shared sbitmap per tagset
Date:   Tue, 26 Nov 2019 14:10:05 +0100
Message-Id: <20191126131009.71726-5-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191126131009.71726-1-hare@suse.de>
References: <20191126131009.71726-1-hare@suse.de>
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
 block/blk-mq-sched.c   |  7 +++---
 block/blk-mq-tag.c     | 51 ++++++++++++++++++++++++++++++--------
 block/blk-mq-tag.h     | 13 +++++++---
 block/blk-mq.c         | 67 ++++++++++++++++++++++++++++++++++++++------------
 block/blk-mq.h         | 10 ++++++--
 include/linux/blk-mq.h |  4 +++
 6 files changed, 118 insertions(+), 34 deletions(-)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index ca22afd47b3d..df6dbbb9578e 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -452,7 +452,7 @@ static void blk_mq_sched_free_tags(struct blk_mq_tag_set *set,
 {
 	if (hctx->sched_tags) {
 		blk_mq_free_rqs(set, hctx->sched_tags, hctx_idx);
-		blk_mq_free_rq_map(hctx->sched_tags);
+		blk_mq_free_rq_map(hctx->sched_tags, false);
 		hctx->sched_tags = NULL;
 	}
 }
@@ -464,8 +464,9 @@ static int blk_mq_sched_alloc_tags(struct request_queue *q,
 	struct blk_mq_tag_set *set = q->tag_set;
 	int ret;
 
+	/* Scheduler tags are never shared */
 	hctx->sched_tags = blk_mq_alloc_rq_map(set, hctx_idx, q->nr_requests,
-					       set->reserved_tags);
+					       set->reserved_tags, false);
 	if (!hctx->sched_tags)
 		return -ENOMEM;
 
@@ -484,7 +485,7 @@ static void blk_mq_sched_tags_teardown(struct request_queue *q)
 
 	queue_for_each_hw_ctx(q, hctx, i) {
 		if (hctx->sched_tags) {
-			blk_mq_free_rq_map(hctx->sched_tags);
+			blk_mq_free_rq_map(hctx->sched_tags, false);
 			hctx->sched_tags = NULL;
 		}
 	}
diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 332d71cd3976..e646fe6b8c3d 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -228,7 +228,7 @@ static bool bt_iter(struct sbitmap *bitmap, unsigned int bitnr, void *data)
 	 * We can hit rq == NULL here, because the tagging functions
 	 * test and set the bit before assigning ->rqs[].
 	 */
-	if (rq && rq->q == hctx->queue)
+	if (rq && rq->q == hctx->queue && rq->mq_hctx == hctx)
 		return iter_data->fn(hctx, rq, iter_data->data, reserved);
 	return true;
 }
@@ -470,9 +470,38 @@ static int blk_mq_init_bitmap_tags(struct blk_mq_tags *tags,
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
+	if (bt_alloc(&tag_set->shared_bitmap_tags, depth, round_robin, node))
+		return false;
+	if (bt_alloc(&tag_set->shared_breserved_tags, tag_set->reserved_tags,
+		     round_robin, node))
+		goto free_bitmap_tags;
+
+	return true;
+free_bitmap_tags:
+	sbitmap_queue_free(&tag_set->shared_bitmap_tags);
+	return false;
+}
+
+void blk_mq_exit_shared_sbitmap(struct blk_mq_tag_set *tag_set)
+{
+	if (blk_mq_is_sbitmap_shared(tag_set)) {
+		sbitmap_queue_free(&tag_set->shared_bitmap_tags);
+		sbitmap_queue_free(&tag_set->shared_breserved_tags);
+	}
+}
+
+struct blk_mq_tags *blk_mq_init_tags(struct blk_mq_tag_set *set,
+				     unsigned int total_tags,
 				     unsigned int reserved_tags,
-				     int node, int alloc_policy)
+				     int node, int alloc_policy,
+				     bool shared_tags)
 {
 	struct blk_mq_tags *tags;
 
@@ -488,9 +517,11 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
 	tags->nr_tags = total_tags;
 	tags->nr_reserved_tags = reserved_tags;
 
-	if (blk_mq_init_bitmap_tags(tags, node, alloc_policy) < 0) {
-		kfree(tags);
-		tags = NULL;
+	if (shared_tags) {
+		if (blk_mq_init_bitmap_tags(tags, node, alloc_policy) < 0) {
+			kfree(tags);
+			tags = NULL;
+		}
 	}
 	return tags;
 }
@@ -506,7 +537,7 @@ void blk_mq_free_tags(struct blk_mq_tags *tags)
 
 int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
 			    struct blk_mq_tags **tagsptr, unsigned int tdepth,
-			    bool can_grow)
+			    bool can_grow, bool shared_tags)
 {
 	struct blk_mq_tags *tags = *tagsptr;
 
@@ -533,17 +564,17 @@ int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
 			return -EINVAL;
 
 		new = blk_mq_alloc_rq_map(set, hctx->queue_num, tdepth,
-				tags->nr_reserved_tags);
+				tags->nr_reserved_tags, shared_tags);
 		if (!new)
 			return -ENOMEM;
 		ret = blk_mq_alloc_rqs(set, new, hctx->queue_num, tdepth);
 		if (ret) {
-			blk_mq_free_rq_map(new);
+			blk_mq_free_rq_map(new, shared_tags);
 			return -ENOMEM;
 		}
 
 		blk_mq_free_rqs(set, *tagsptr, hctx->queue_num);
-		blk_mq_free_rq_map(*tagsptr);
+		blk_mq_free_rq_map(*tagsptr, shared_tags);
 		*tagsptr = new;
 	} else {
 		/*
diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h
index 10b66fd4664a..3b0ece3c594c 100644
--- a/block/blk-mq-tag.h
+++ b/block/blk-mq-tag.h
@@ -22,7 +22,13 @@ struct blk_mq_tags {
 };
 
 
-extern struct blk_mq_tags *blk_mq_init_tags(unsigned int nr_tags, unsigned int reserved_tags, int node, int alloc_policy);
+extern bool blk_mq_init_shared_sbitmap(struct blk_mq_tag_set *tag_set);
+extern void blk_mq_exit_shared_sbitmap(struct blk_mq_tag_set *tag_set);
+extern struct blk_mq_tags *blk_mq_init_tags(struct blk_mq_tag_set *tag_set,
+					    unsigned int nr_tags,
+					    unsigned int reserved_tags,
+					    int node, int alloc_policy,
+					    bool shared_tags);
 extern void blk_mq_free_tags(struct blk_mq_tags *tags);
 
 extern unsigned int blk_mq_get_tag(struct blk_mq_alloc_data *data);
@@ -30,8 +36,9 @@ extern void blk_mq_put_tag(struct blk_mq_tags *tags, struct blk_mq_ctx *ctx,
 				unsigned int tag);
 extern bool blk_mq_has_free_tags(struct blk_mq_tags *tags);
 extern int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
-					struct blk_mq_tags **tags,
-					unsigned int depth, bool can_grow);
+				   struct blk_mq_tags **tags,
+				   unsigned int depth, bool can_grow,
+				   bool shared_tags);
 extern void blk_mq_tag_wakeup_all(struct blk_mq_tags *tags, bool);
 void blk_mq_queue_tag_busy_iter(struct request_queue *q, busy_iter_fn *fn,
 		void *priv);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index f0c40fcbd8ae..3c93a070d3bb 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2075,19 +2075,21 @@ void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
 	}
 }
 
-void blk_mq_free_rq_map(struct blk_mq_tags *tags)
+void blk_mq_free_rq_map(struct blk_mq_tags *tags, bool shared)
 {
 	kfree(tags->rqs);
 	tags->rqs = NULL;
 	kfree(tags->static_rqs);
 	tags->static_rqs = NULL;
-	blk_mq_free_tags(tags);
+	if (!shared)
+		blk_mq_free_tags(tags);
 }
 
 struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
 					unsigned int hctx_idx,
 					unsigned int nr_tags,
-					unsigned int reserved_tags)
+					unsigned int reserved_tags,
+					bool shared_tags)
 {
 	struct blk_mq_tags *tags;
 	int node;
@@ -2096,8 +2098,9 @@ struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
 	if (node == NUMA_NO_NODE)
 		node = set->numa_node;
 
-	tags = blk_mq_init_tags(nr_tags, reserved_tags, node,
-				BLK_MQ_FLAG_TO_ALLOC_POLICY(set->flags));
+	tags = blk_mq_init_tags(set, nr_tags, reserved_tags, node,
+				BLK_MQ_FLAG_TO_ALLOC_POLICY(set->flags),
+				shared_tags);
 	if (!tags)
 		return NULL;
 
@@ -2105,7 +2108,8 @@ struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
 				 GFP_NOIO | __GFP_NOWARN | __GFP_NORETRY,
 				 node);
 	if (!tags->rqs) {
-		blk_mq_free_tags(tags);
+		if (!blk_mq_is_sbitmap_shared(set))
+			blk_mq_free_tags(tags);
 		return NULL;
 	}
 
@@ -2114,7 +2118,8 @@ struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
 					node);
 	if (!tags->static_rqs) {
 		kfree(tags->rqs);
-		blk_mq_free_tags(tags);
+		if (!blk_mq_is_sbitmap_shared(set))
+			blk_mq_free_tags(tags);
 		return NULL;
 	}
 
@@ -2435,9 +2440,10 @@ static void blk_mq_init_cpu_queues(struct request_queue *q,
 static bool __blk_mq_alloc_rq_map(struct blk_mq_tag_set *set, int hctx_idx)
 {
 	int ret = 0;
+	bool shared = blk_mq_is_sbitmap_shared(set);
 
 	set->tags[hctx_idx] = blk_mq_alloc_rq_map(set, hctx_idx,
-					set->queue_depth, set->reserved_tags);
+				set->queue_depth, set->reserved_tags, shared);
 	if (!set->tags[hctx_idx])
 		return false;
 
@@ -2446,7 +2452,7 @@ static bool __blk_mq_alloc_rq_map(struct blk_mq_tag_set *set, int hctx_idx)
 	if (!ret)
 		return true;
 
-	blk_mq_free_rq_map(set->tags[hctx_idx]);
+	blk_mq_free_rq_map(set->tags[hctx_idx], shared);
 	set->tags[hctx_idx] = NULL;
 	return false;
 }
@@ -2456,7 +2462,8 @@ static void blk_mq_free_map_and_requests(struct blk_mq_tag_set *set,
 {
 	if (set->tags && set->tags[hctx_idx]) {
 		blk_mq_free_rqs(set, set->tags[hctx_idx], hctx_idx);
-		blk_mq_free_rq_map(set->tags[hctx_idx]);
+		blk_mq_free_rq_map(set->tags[hctx_idx],
+				   blk_mq_is_sbitmap_shared(set));
 		set->tags[hctx_idx] = NULL;
 	}
 }
@@ -2954,7 +2961,7 @@ static int __blk_mq_alloc_rq_maps(struct blk_mq_tag_set *set)
 
 out_unwind:
 	while (--i >= 0)
-		blk_mq_free_rq_map(set->tags[i]);
+		blk_mq_free_rq_map(set->tags[i], blk_mq_is_sbitmap_shared(set));
 
 	return -ENOMEM;
 }
@@ -3099,11 +3106,28 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
 	if (ret)
 		goto out_free_mq_map;
 
+	if (blk_mq_is_sbitmap_shared(set)) {
+		if (!blk_mq_init_shared_sbitmap(set)) {
+			ret = -ENOMEM;
+			goto out_free_rq_map;
+		}
+
+		for (i = 0; i < set->nr_hw_queues; i++) {
+			struct blk_mq_tags *tags = set->tags[i];
+
+			tags->bitmap_tags = &set->shared_bitmap_tags;
+			tags->breserved_tags = &set->shared_breserved_tags;
+		}
+	}
+
 	mutex_init(&set->tag_list_lock);
 	INIT_LIST_HEAD(&set->tag_list);
 
 	return 0;
 
+out_free_rq_map:
+	for (i = 0; i < nr_hw_queues(set); i++)
+		blk_mq_free_map_and_requests(set, i);
 out_free_mq_map:
 	for (i = 0; i < set->nr_maps; i++) {
 		kfree(set->map[i].mq_map);
@@ -3121,7 +3145,7 @@ void blk_mq_free_tag_set(struct blk_mq_tag_set *set)
 
 	for (i = 0; i < nr_hw_queues(set); i++)
 		blk_mq_free_map_and_requests(set, i);
-
+	blk_mq_exit_shared_sbitmap(set);
 	for (j = 0; j < set->nr_maps; j++) {
 		kfree(set->map[j].mq_map);
 		set->map[j].mq_map = NULL;
@@ -3137,6 +3161,7 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
 	struct blk_mq_tag_set *set = q->tag_set;
 	struct blk_mq_hw_ctx *hctx;
 	int i, ret;
+	bool shared_tags = blk_mq_is_sbitmap_shared(set);
 
 	if (!set)
 		return -EINVAL;
@@ -3156,11 +3181,12 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
 		 * queue depth. This is similar to what the old code would do.
 		 */
 		if (!hctx->sched_tags) {
-			ret = blk_mq_tag_update_depth(hctx, &hctx->tags, nr,
-							false);
+			ret = blk_mq_tag_update_depth(hctx, &hctx->tags,
+						      nr, false, shared_tags);
 		} else {
+			shared_tags = false;
 			ret = blk_mq_tag_update_depth(hctx, &hctx->sched_tags,
-							nr, true);
+						      nr, true, shared_tags);
 		}
 		if (ret)
 			break;
@@ -3168,8 +3194,17 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
 			q->elevator->type->ops.depth_updated(hctx);
 	}
 
-	if (!ret)
+	if (!ret) {
+		if (shared_tags) {
+			sbitmap_queue_resize(&set->shared_bitmap_tags, nr);
+			sbitmap_queue_resize(&set->shared_breserved_tags, nr);
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
index 78d38b5f2793..2445d5b64e79 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -53,11 +53,12 @@ struct request *blk_mq_dequeue_from_ctx(struct blk_mq_hw_ctx *hctx,
  */
 void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
 		     unsigned int hctx_idx);
-void blk_mq_free_rq_map(struct blk_mq_tags *tags);
+void blk_mq_free_rq_map(struct blk_mq_tags *tags, bool shared);
 struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
 					unsigned int hctx_idx,
 					unsigned int nr_tags,
-					unsigned int reserved_tags);
+					unsigned int reserved_tags,
+					bool shared_tags);
 int blk_mq_alloc_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
 		     unsigned int hctx_idx, unsigned int depth);
 
@@ -166,6 +167,11 @@ struct blk_mq_alloc_data {
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
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 147185394a25..3be5a70d9f6a 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -109,6 +109,9 @@ struct blk_mq_tag_set {
 	unsigned int		flags;		/* BLK_MQ_F_* */
 	void			*driver_data;
 
+	struct sbitmap_queue shared_bitmap_tags;
+	struct sbitmap_queue shared_breserved_tags;
+
 	struct blk_mq_tags	**tags;
 
 	struct mutex		tag_list_lock;
@@ -226,6 +229,7 @@ struct blk_mq_ops {
 enum {
 	BLK_MQ_F_SHOULD_MERGE	= 1 << 0,
 	BLK_MQ_F_TAG_QUEUE_SHARED	= 1 << 1,
+	BLK_MQ_F_TAG_HCTX_SHARED	= 1 << 2,
 	BLK_MQ_F_BLOCKING	= 1 << 5,
 	BLK_MQ_F_NO_SCHED	= 1 << 6,
 	BLK_MQ_F_ALLOC_POLICY_START_BIT = 8,
-- 
2.16.4

