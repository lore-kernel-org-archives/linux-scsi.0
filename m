Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82FE6C432BE
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 12:07:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70C5E60FE6
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 12:07:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245205AbhH0MIJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 08:08:09 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3705 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245190AbhH0MH7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Aug 2021 08:07:59 -0400
Received: from fraeml736-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Gwz1z16W2z67gYW;
        Fri, 27 Aug 2021 20:05:43 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml736-chm.china.huawei.com (10.206.15.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 27 Aug 2021 14:07:09 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 27 Aug 2021 13:07:06 +0100
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ming.lei@redhat.com>, <linux-scsi@vger.kernel.org>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v3 10/13] blk-mq: Add blk_mq_alloc_map_and_rqs()
Date:   Fri, 27 Aug 2021 20:02:01 +0800
Message-ID: <1630065724-69146-11-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1630065724-69146-1-git-send-email-john.garry@huawei.com>
References: <1630065724-69146-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a function to combine allocating tags and the associated requests,
and factor out common patterns to use this new function.

Some functions only call blk_mq_alloc_map_and_rqs() now, but more
functionality will be added later to those functions.

Also make blk_mq_alloc_rq_map() and blk_mq_alloc_rqs() static since they
are only used in blk-mq.c, and finally rename some functions for
conciseness and consistency with other function names:
- __blk_mq_alloc_map_and_{request -> rqs}()
- blk_mq_alloc_{map_and_requests -> set_map_and_rqs}()

Suggested-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 block/blk-mq-sched.c | 15 +++--------
 block/blk-mq-tag.c   |  9 +------
 block/blk-mq.c       | 62 +++++++++++++++++++++++++-------------------
 block/blk-mq.h       |  9 ++-----
 4 files changed, 42 insertions(+), 53 deletions(-)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index a3b5a5399bc8..17752f39e144 100644
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
index 5f06ad6efc8f..d0b5e52be3c8 100644
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
index d82d477c9c9d..6759914823e3 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2391,11 +2391,11 @@ void blk_mq_free_rq_map(struct blk_mq_tags *tags, unsigned int flags)
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
@@ -2443,8 +2443,9 @@ static int blk_mq_init_request(struct blk_mq_tag_set *set, struct request *rq,
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
@@ -2855,25 +2856,34 @@ static void blk_mq_init_cpu_queues(struct request_queue *q,
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
@@ -2918,7 +2928,7 @@ static void blk_mq_map_swqueue(struct request_queue *q)
 			hctx_idx = set->map[j].mq_map[i];
 			/* unmapped hw queue can be remapped after CPU topo changed */
 			if (!set->tags[hctx_idx] &&
-			    !__blk_mq_alloc_map_and_request(set, hctx_idx)) {
+			    !__blk_mq_alloc_map_and_rqs(set, hctx_idx)) {
 				/*
 				 * If tags initialization fail for some hctx,
 				 * that hctx won't be brought online.  In this
@@ -3351,7 +3361,7 @@ static int __blk_mq_alloc_rq_maps(struct blk_mq_tag_set *set)
 	int i;
 
 	for (i = 0; i < set->nr_hw_queues; i++) {
-		if (!__blk_mq_alloc_map_and_request(set, i))
+		if (!__blk_mq_alloc_map_and_rqs(set, i))
 			goto out_unwind;
 		cond_resched();
 	}
@@ -3370,7 +3380,7 @@ static int __blk_mq_alloc_rq_maps(struct blk_mq_tag_set *set)
  * may reduce the depth asked for, if memory is tight. set->queue_depth
  * will be updated to reflect the allocated depth.
  */
-static int blk_mq_alloc_map_and_requests(struct blk_mq_tag_set *set)
+static int blk_mq_alloc_set_map_and_rqs(struct blk_mq_tag_set *set)
 {
 	unsigned int depth;
 	int err;
@@ -3536,7 +3546,7 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
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

