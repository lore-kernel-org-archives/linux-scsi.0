Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9A34C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 08:34:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2BDE610CF
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 08:34:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244894AbhIXIfx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Sep 2021 04:35:53 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3865 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244897AbhIXIf2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Sep 2021 04:35:28 -0400
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HG4xp3TXxz67kg2;
        Fri, 24 Sep 2021 16:31:26 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 24 Sep 2021 10:33:53 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 24 Sep 2021 09:33:51 +0100
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <ming.lei@redhat.com>,
        <hare@suse.de>, "John Garry" <john.garry@huawei.com>
Subject: [PATCH v4 11/13] blk-mq: Refactor and rename blk_mq_free_map_and_{requests->rqs}()
Date:   Fri, 24 Sep 2021 16:28:28 +0800
Message-ID: <1632472110-244938-12-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1632472110-244938-1-git-send-email-john.garry@huawei.com>
References: <1632472110-244938-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Refactor blk_mq_free_map_and_requests() such that it can be used at many
sites at which the tag map and rqs are freed.

Also rename to blk_mq_free_map_and_rqs(), which is shorter and matches the
alloc equivalent.

Suggested-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-mq-tag.c |  3 +--
 block/blk-mq.c     | 40 ++++++++++++++++++++++++----------------
 block/blk-mq.h     |  4 +++-
 3 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index db99f1246795..a0ecc6d88f84 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -607,8 +607,7 @@ int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
 		if (!new)
 			return -ENOMEM;
 
-		blk_mq_free_rqs(set, *tagsptr, hctx->queue_num);
-		blk_mq_free_rq_map(*tagsptr, set->flags);
+		blk_mq_free_map_and_rqs(set, *tagsptr, hctx->queue_num);
 		*tagsptr = new;
 	} else {
 		/*
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 46772773b9c4..464ea20b9bcb 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2878,15 +2878,15 @@ static bool __blk_mq_alloc_map_and_rqs(struct blk_mq_tag_set *set,
 	return set->tags[hctx_idx];
 }
 
-static void blk_mq_free_map_and_requests(struct blk_mq_tag_set *set,
-					 unsigned int hctx_idx)
+void blk_mq_free_map_and_rqs(struct blk_mq_tag_set *set,
+			     struct blk_mq_tags *tags,
+			     unsigned int hctx_idx)
 {
 	unsigned int flags = set->flags;
 
-	if (set->tags && set->tags[hctx_idx]) {
-		blk_mq_free_rqs(set, set->tags[hctx_idx], hctx_idx);
-		blk_mq_free_rq_map(set->tags[hctx_idx], flags);
-		set->tags[hctx_idx] = NULL;
+	if (tags) {
+		blk_mq_free_rqs(set, tags, hctx_idx);
+		blk_mq_free_rq_map(tags, flags);
 	}
 }
 
@@ -2967,8 +2967,10 @@ static void blk_mq_map_swqueue(struct request_queue *q)
 			 * fallback in case of a new remap fails
 			 * allocation
 			 */
-			if (i && set->tags[i])
-				blk_mq_free_map_and_requests(set, i);
+			if (i && set->tags[i]) {
+				blk_mq_free_map_and_rqs(set, set->tags[i], i);
+				set->tags[i] = NULL;
+			}
 
 			hctx->tags = NULL;
 			continue;
@@ -3264,8 +3266,8 @@ static void blk_mq_realloc_hw_ctxs(struct blk_mq_tag_set *set,
 		struct blk_mq_hw_ctx *hctx = hctxs[j];
 
 		if (hctx) {
-			if (hctx->tags)
-				blk_mq_free_map_and_requests(set, j);
+			blk_mq_free_map_and_rqs(set, set->tags[j], j);
+			set->tags[j] = NULL;
 			blk_mq_exit_hctx(q, set, hctx, j);
 			hctxs[j] = NULL;
 		}
@@ -3361,8 +3363,10 @@ static int __blk_mq_alloc_rq_maps(struct blk_mq_tag_set *set)
 	return 0;
 
 out_unwind:
-	while (--i >= 0)
-		blk_mq_free_map_and_requests(set, i);
+	while (--i >= 0) {
+		blk_mq_free_map_and_rqs(set, set->tags[i], i);
+		set->tags[i] = NULL;
+	}
 
 	return -ENOMEM;
 }
@@ -3557,8 +3561,10 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
 	return 0;
 
 out_free_mq_rq_maps:
-	for (i = 0; i < set->nr_hw_queues; i++)
-		blk_mq_free_map_and_requests(set, i);
+	for (i = 0; i < set->nr_hw_queues; i++) {
+		blk_mq_free_map_and_rqs(set, set->tags[i], i);
+		set->tags[i] = NULL;
+	}
 out_free_mq_map:
 	for (i = 0; i < set->nr_maps; i++) {
 		kfree(set->map[i].mq_map);
@@ -3590,8 +3596,10 @@ void blk_mq_free_tag_set(struct blk_mq_tag_set *set)
 {
 	int i, j;
 
-	for (i = 0; i < set->nr_hw_queues; i++)
-		blk_mq_free_map_and_requests(set, i);
+	for (i = 0; i < set->nr_hw_queues; i++) {
+		blk_mq_free_map_and_rqs(set, set->tags[i], i);
+		set->tags[i] = NULL;
+	}
 
 	if (blk_mq_is_sbitmap_shared(set->flags))
 		blk_mq_exit_shared_sbitmap(set);
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 83585a344568..bcb0ca89d37a 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -57,7 +57,9 @@ void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
 void blk_mq_free_rq_map(struct blk_mq_tags *tags, unsigned int flags);
 struct blk_mq_tags *blk_mq_alloc_map_and_rqs(struct blk_mq_tag_set *set,
 				unsigned int hctx_idx, unsigned int depth);
-
+void blk_mq_free_map_and_rqs(struct blk_mq_tag_set *set,
+			     struct blk_mq_tags *tags,
+			     unsigned int hctx_idx);
 /*
  * Internal helpers for request insertion into sw queues
  */
-- 
2.26.2

