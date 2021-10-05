Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39ED2C4332F
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 10:29:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1428661251
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 10:29:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234138AbhJEKbQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 06:31:16 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3927 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234230AbhJEKbA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 06:31:00 -0400
Received: from fraeml708-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HNtyY3gZqz67HnK;
        Tue,  5 Oct 2021 18:25:41 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml708-chm.china.huawei.com (10.206.15.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 5 Oct 2021 12:29:07 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 5 Oct 2021 11:29:05 +0100
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ming.lei@redhat.com>, <hare@suse.de>,
        <linux-scsi@vger.kernel.org>, <kashyap.desai@broadcom.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v5 10/14] blk-mq: Add blk_mq_alloc_map_and_rqs()
Date:   Tue, 5 Oct 2021 18:23:35 +0800
Message-ID: <1633429419-228500-11-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1633429419-228500-1-git-send-email-john.garry@huawei.com>
References: <1633429419-228500-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a function to combine allocating tags and the associated requests,
and factor out common patterns to use this new function.

Some function only call blk_mq_alloc_map_and_rqs() now, but more
functionality will be added later.

Also make blk_mq_alloc_rq_map() and blk_mq_alloc_rqs() static since they
are only used in blk-mq.c, and finally rename some functions for
conciseness and consistency with other function names:
- __blk_mq_alloc_map_and_{request -> rqs}()
- blk_mq_alloc_{map_and_requests -> set_map_and_rqs}()

Suggested-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq-sched.c | 15 +++--------
 block/blk-mq-tag.c   |  9 +------
 block/blk-mq.c       | 62 +++++++++++++++++++++++++-------------------
 block/blk-mq.h       |  9 ++-----
 4 files changed, 42 insertions(+), 53 deletions(-)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index 6c15f6e98e2e..d1b56bb9ac64 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -519,21 +519,12 @@ static int blk_mq_sched_alloc_map_and_rqs(struct request_queue *q,
 					  struct blk_mq_hw_ctx *hctx,
 					  unsigned int hctx_idx)
 {
-	struct blk_mq_tag_set *set = q->tag_set;
-	int ret;
+	hctx->sched_tags = blk_mq_alloc_map_and_rqs(q->tag_set, hctx_idx,
+						    q->nr_requests);
 
-	hctx->sched_tags = blk_mq_alloc_rq_map(set, hctx_idx, q->nr_requests,
-					       set->reserved_tags, set->flags);
 	if (!hctx->sched_tags)
 		return -ENOMEM;
-
-	ret = blk_mq_alloc_rqs(set, hctx->sched_tags, hctx_idx, q->nr_requests);
-	if (ret) {
-		blk_mq_free_rq_map(hctx->sched_tags, set->flags);
-		hctx->sched_tags = NULL;
-	}
-
-	return ret;
+	return 0;
 }
 
 /* called in queue's release handler, tagset has gone away */
diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 55b5a226dcc0..db99f1246795 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -592,7 +592,6 @@ int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
 	if (tdepth > tags->nr_tags) {
 		struct blk_mq_tag_set *set = hctx->queue->tag_set;
 		struct blk_mq_tags *new;
-		bool ret;
 
 		if (!can_grow)
 			return -EINVAL;
@@ -604,15 +603,9 @@ int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
 		if (tdepth > MAX_SCHED_RQ)
 			return -EINVAL;
 
-		new = blk_mq_alloc_rq_map(set, hctx->queue_num, tdepth,
-				tags->nr_reserved_tags, set->flags);
+		new = blk_mq_alloc_map_and_rqs(set, hctx->queue_num, tdepth);
 		if (!new)
 			return -ENOMEM;
-		ret = blk_mq_alloc_rqs(set, new, hctx->queue_num, tdepth);
-		if (ret) {
-			blk_mq_free_rq_map(new, set->flags);
-			return -ENOMEM;
-		}
 
 		blk_mq_free_rqs(set, *tagsptr, hctx->queue_num);
 		blk_mq_free_rq_map(*tagsptr, set->flags);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 7e964a1c1bee..6d3664acb9f8 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2385,11 +2385,11 @@ void blk_mq_free_rq_map(struct blk_mq_tags *tags, unsigned int flags)
 	blk_mq_free_tags(tags, flags);
 }
 
-struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
-					unsigned int hctx_idx,
-					unsigned int nr_tags,
-					unsigned int reserved_tags,
-					unsigned int flags)
+static struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
+					       unsigned int hctx_idx,
+					       unsigned int nr_tags,
+					       unsigned int reserved_tags,
+					       unsigned int flags)
 {
 	struct blk_mq_tags *tags;
 	int node;
@@ -2437,8 +2437,9 @@ static int blk_mq_init_request(struct blk_mq_tag_set *set, struct request *rq,
 	return 0;
 }
 
-int blk_mq_alloc_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
-		     unsigned int hctx_idx, unsigned int depth)
+static int blk_mq_alloc_rqs(struct blk_mq_tag_set *set,
+			    struct blk_mq_tags *tags,
+			    unsigned int hctx_idx, unsigned int depth)
 {
 	unsigned int i, j, entries_per_page, max_order = 4;
 	size_t rq_size, left;
@@ -2849,25 +2850,34 @@ static void blk_mq_init_cpu_queues(struct request_queue *q,
 	}
 }
 
-static bool __blk_mq_alloc_map_and_request(struct blk_mq_tag_set *set,
-					int hctx_idx)
+struct blk_mq_tags *blk_mq_alloc_map_and_rqs(struct blk_mq_tag_set *set,
+					     unsigned int hctx_idx,
+					     unsigned int depth)
 {
-	unsigned int flags = set->flags;
-	int ret = 0;
+	struct blk_mq_tags *tags;
+	int ret;
 
-	set->tags[hctx_idx] = blk_mq_alloc_rq_map(set, hctx_idx,
-					set->queue_depth, set->reserved_tags, flags);
-	if (!set->tags[hctx_idx])
-		return false;
+	tags = blk_mq_alloc_rq_map(set, hctx_idx, depth, set->reserved_tags,
+				   set->flags);
+	if (!tags)
+		return NULL;
 
-	ret = blk_mq_alloc_rqs(set, set->tags[hctx_idx], hctx_idx,
-				set->queue_depth);
-	if (!ret)
-		return true;
+	ret = blk_mq_alloc_rqs(set, tags, hctx_idx, depth);
+	if (ret) {
+		blk_mq_free_rq_map(tags, set->flags);
+		return NULL;
+	}
 
-	blk_mq_free_rq_map(set->tags[hctx_idx], flags);
-	set->tags[hctx_idx] = NULL;
-	return false;
+	return tags;
+}
+
+static bool __blk_mq_alloc_map_and_rqs(struct blk_mq_tag_set *set,
+				       int hctx_idx)
+{
+	set->tags[hctx_idx] = blk_mq_alloc_map_and_rqs(set, hctx_idx,
+						       set->queue_depth);
+
+	return set->tags[hctx_idx];
 }
 
 static void blk_mq_free_map_and_requests(struct blk_mq_tag_set *set,
@@ -2912,7 +2922,7 @@ static void blk_mq_map_swqueue(struct request_queue *q)
 			hctx_idx = set->map[j].mq_map[i];
 			/* unmapped hw queue can be remapped after CPU topo changed */
 			if (!set->tags[hctx_idx] &&
-			    !__blk_mq_alloc_map_and_request(set, hctx_idx)) {
+			    !__blk_mq_alloc_map_and_rqs(set, hctx_idx)) {
 				/*
 				 * If tags initialization fail for some hctx,
 				 * that hctx won't be brought online.  In this
@@ -3345,7 +3355,7 @@ static int __blk_mq_alloc_rq_maps(struct blk_mq_tag_set *set)
 	int i;
 
 	for (i = 0; i < set->nr_hw_queues; i++) {
-		if (!__blk_mq_alloc_map_and_request(set, i))
+		if (!__blk_mq_alloc_map_and_rqs(set, i))
 			goto out_unwind;
 		cond_resched();
 	}
@@ -3364,7 +3374,7 @@ static int __blk_mq_alloc_rq_maps(struct blk_mq_tag_set *set)
  * may reduce the depth asked for, if memory is tight. set->queue_depth
  * will be updated to reflect the allocated depth.
  */
-static int blk_mq_alloc_map_and_requests(struct blk_mq_tag_set *set)
+static int blk_mq_alloc_set_map_and_rqs(struct blk_mq_tag_set *set)
 {
 	unsigned int depth;
 	int err;
@@ -3530,7 +3540,7 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
 	if (ret)
 		goto out_free_mq_map;
 
-	ret = blk_mq_alloc_map_and_requests(set);
+	ret = blk_mq_alloc_set_map_and_rqs(set);
 	if (ret)
 		goto out_free_mq_map;
 
diff --git a/block/blk-mq.h b/block/blk-mq.h
index d08779f77a26..83585a344568 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -55,13 +55,8 @@ void blk_mq_put_rq_ref(struct request *rq);
 void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
 		     unsigned int hctx_idx);
 void blk_mq_free_rq_map(struct blk_mq_tags *tags, unsigned int flags);
-struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
-					unsigned int hctx_idx,
-					unsigned int nr_tags,
-					unsigned int reserved_tags,
-					unsigned int flags);
-int blk_mq_alloc_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
-		     unsigned int hctx_idx, unsigned int depth);
+struct blk_mq_tags *blk_mq_alloc_map_and_rqs(struct blk_mq_tag_set *set,
+				unsigned int hctx_idx, unsigned int depth);
 
 /*
  * Internal helpers for request insertion into sw queues
-- 
2.26.2

