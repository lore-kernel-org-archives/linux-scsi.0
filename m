Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A238C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 10:29:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52E9861381
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 10:29:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234131AbhJEKb2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 06:31:28 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3928 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234371AbhJEKbC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 06:31:02 -0400
Received: from fraeml706-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HNtyy6TP5z67b4M;
        Tue,  5 Oct 2021 18:26:02 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml706-chm.china.huawei.com (10.206.15.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Tue, 5 Oct 2021 12:29:10 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 5 Oct 2021 11:29:07 +0100
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ming.lei@redhat.com>, <hare@suse.de>,
        <linux-scsi@vger.kernel.org>, <kashyap.desai@broadcom.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v5 11/14] blk-mq: Refactor and rename blk_mq_free_map_and_{requests->rqs}()
Date:   Tue, 5 Oct 2021 18:23:36 +0800
Message-ID: <1633429419-228500-12-git-send-email-john.garry@huawei.com>
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
index 6d3664acb9f8..7bf56dc3af30 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2880,15 +2880,15 @@ static bool __blk_mq_alloc_map_and_rqs(struct blk_mq_tag_set *set,
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
 
@@ -2969,8 +2969,10 @@ static void blk_mq_map_swqueue(struct request_queue *q)
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
@@ -3266,8 +3268,8 @@ static void blk_mq_realloc_hw_ctxs(struct blk_mq_tag_set *set,
 		struct blk_mq_hw_ctx *hctx = hctxs[j];
 
 		if (hctx) {
-			if (hctx->tags)
-				blk_mq_free_map_and_requests(set, j);
+			blk_mq_free_map_and_rqs(set, set->tags[j], j);
+			set->tags[j] = NULL;
 			blk_mq_exit_hctx(q, set, hctx, j);
 			hctxs[j] = NULL;
 		}
@@ -3363,8 +3365,10 @@ static int __blk_mq_alloc_rq_maps(struct blk_mq_tag_set *set)
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
@@ -3559,8 +3563,10 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
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
@@ -3592,8 +3598,10 @@ void blk_mq_free_tag_set(struct blk_mq_tag_set *set)
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

