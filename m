Return-Path: <SRS0=XqvZ=B5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89404C433E5
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 15:26:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A18D20897
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 15:26:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728847AbgHSP0E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Aug 2020 11:26:04 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:39910 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728774AbgHSPZb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Aug 2020 11:25:31 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C8B062969AEDCC96C3A5;
        Wed, 19 Aug 2020 23:24:58 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Wed, 19 Aug 2020 23:24:48 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <don.brace@microsemi.com>,
        <kashyap.desai@broadcom.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <dgilbert@interlog.com>,
        <paolo.valente@linaro.org>, <hare@suse.de>, <hch@lst.de>
CC:     <sumit.saxena@broadcom.com>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <megaraidlinux.pdl@broadcom.com>,
        <chenxiang66@hisilicon.com>, <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v8 04/18] blk-mq: Pass flags for tag init/free
Date:   Wed, 19 Aug 2020 23:20:22 +0800
Message-ID: <1597850436-116171-5-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1597850436-116171-1-git-send-email-john.garry@huawei.com>
References: <1597850436-116171-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Pass hctx/tagset flags argument down to blk_mq_init_tags() and
blk_mq_free_tags() for selective init/free.

For now, make it include the alloc policy flag, which can be evaluated
when needed (in blk_mq_init_tags()).

Signed-off-by: John Garry <john.garry@huawei.com>
---
 block/blk-mq-sched.c | 11 ++++++++---
 block/blk-mq-tag.c   | 12 +++++++-----
 block/blk-mq-tag.h   |  7 ++++---
 block/blk-mq.c       | 23 +++++++++++++----------
 block/blk-mq.h       |  5 +++--
 5 files changed, 35 insertions(+), 23 deletions(-)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index a19cdf159b75..ee970d848e62 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -607,9 +607,11 @@ static void blk_mq_sched_free_tags(struct blk_mq_tag_set *set,
 				   struct blk_mq_hw_ctx *hctx,
 				   unsigned int hctx_idx)
 {
+	unsigned int flags = set->flags;
+
 	if (hctx->sched_tags) {
 		blk_mq_free_rqs(set, hctx->sched_tags, hctx_idx);
-		blk_mq_free_rq_map(hctx->sched_tags);
+		blk_mq_free_rq_map(hctx->sched_tags, flags);
 		hctx->sched_tags = NULL;
 	}
 }
@@ -619,10 +621,11 @@ static int blk_mq_sched_alloc_tags(struct request_queue *q,
 				   unsigned int hctx_idx)
 {
 	struct blk_mq_tag_set *set = q->tag_set;
+	unsigned int flags = set->flags;
 	int ret;
 
 	hctx->sched_tags = blk_mq_alloc_rq_map(set, hctx_idx, q->nr_requests,
-					       set->reserved_tags);
+					       set->reserved_tags, flags);
 	if (!hctx->sched_tags)
 		return -ENOMEM;
 
@@ -640,8 +643,10 @@ static void blk_mq_sched_tags_teardown(struct request_queue *q)
 	int i;
 
 	queue_for_each_hw_ctx(q, hctx, i) {
+		unsigned int flags = hctx->flags;
+
 		if (hctx->sched_tags) {
-			blk_mq_free_rq_map(hctx->sched_tags);
+			blk_mq_free_rq_map(hctx->sched_tags, flags);
 			hctx->sched_tags = NULL;
 		}
 	}
diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index c2c9f369d777..0426f01e06a6 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -449,8 +449,9 @@ static int blk_mq_init_bitmap_tags(struct blk_mq_tags *tags,
 
 struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
 				     unsigned int reserved_tags,
-				     int node, int alloc_policy)
+				     int node, unsigned int flags)
 {
+	int alloc_policy = BLK_MQ_FLAG_TO_ALLOC_POLICY(flags);
 	struct blk_mq_tags *tags;
 
 	if (total_tags > BLK_MQ_TAG_MAX) {
@@ -472,7 +473,7 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
 	return tags;
 }
 
-void blk_mq_free_tags(struct blk_mq_tags *tags)
+void blk_mq_free_tags(struct blk_mq_tags *tags, unsigned int flags)
 {
 	sbitmap_queue_free(&tags->bitmap_tags);
 	sbitmap_queue_free(&tags->breserved_tags);
@@ -494,6 +495,7 @@ int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
 	 */
 	if (tdepth > tags->nr_tags) {
 		struct blk_mq_tag_set *set = hctx->queue->tag_set;
+		unsigned int flags = set->flags;
 		struct blk_mq_tags *new;
 		bool ret;
 
@@ -508,17 +510,17 @@ int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
 			return -EINVAL;
 
 		new = blk_mq_alloc_rq_map(set, hctx->queue_num, tdepth,
-				tags->nr_reserved_tags);
+				tags->nr_reserved_tags, flags);
 		if (!new)
 			return -ENOMEM;
 		ret = blk_mq_alloc_rqs(set, new, hctx->queue_num, tdepth);
 		if (ret) {
-			blk_mq_free_rq_map(new);
+			blk_mq_free_rq_map(new, flags);
 			return -ENOMEM;
 		}
 
 		blk_mq_free_rqs(set, *tagsptr, hctx->queue_num);
-		blk_mq_free_rq_map(*tagsptr);
+		blk_mq_free_rq_map(*tagsptr, flags);
 		*tagsptr = new;
 	} else {
 		/*
diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h
index 918e2cee4f43..391f68d32fa1 100644
--- a/block/blk-mq-tag.h
+++ b/block/blk-mq-tag.h
@@ -21,9 +21,10 @@ struct blk_mq_tags {
 	struct list_head page_list;
 };
 
-
-extern struct blk_mq_tags *blk_mq_init_tags(unsigned int nr_tags, unsigned int reserved_tags, int node, int alloc_policy);
-extern void blk_mq_free_tags(struct blk_mq_tags *tags);
+extern struct blk_mq_tags *blk_mq_init_tags(unsigned int nr_tags,
+					unsigned int reserved_tags,
+					int node, unsigned int flags);
+extern void blk_mq_free_tags(struct blk_mq_tags *tags, unsigned int flags);
 
 extern unsigned int blk_mq_get_tag(struct blk_mq_alloc_data *data);
 extern void blk_mq_put_tag(struct blk_mq_tags *tags, struct blk_mq_ctx *ctx,
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 50de9eb60466..376930061452 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2285,20 +2285,21 @@ void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
 	}
 }
 
-void blk_mq_free_rq_map(struct blk_mq_tags *tags)
+void blk_mq_free_rq_map(struct blk_mq_tags *tags, unsigned int flags)
 {
 	kfree(tags->rqs);
 	tags->rqs = NULL;
 	kfree(tags->static_rqs);
 	tags->static_rqs = NULL;
 
-	blk_mq_free_tags(tags);
+	blk_mq_free_tags(tags, flags);
 }
 
 struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
 					unsigned int hctx_idx,
 					unsigned int nr_tags,
-					unsigned int reserved_tags)
+					unsigned int reserved_tags,
+					unsigned int flags)
 {
 	struct blk_mq_tags *tags;
 	int node;
@@ -2307,8 +2308,7 @@ struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
 	if (node == NUMA_NO_NODE)
 		node = set->numa_node;
 
-	tags = blk_mq_init_tags(nr_tags, reserved_tags, node,
-				BLK_MQ_FLAG_TO_ALLOC_POLICY(set->flags));
+	tags = blk_mq_init_tags(nr_tags, reserved_tags, node, flags);
 	if (!tags)
 		return NULL;
 
@@ -2316,7 +2316,7 @@ struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
 				 GFP_NOIO | __GFP_NOWARN | __GFP_NORETRY,
 				 node);
 	if (!tags->rqs) {
-		blk_mq_free_tags(tags);
+		blk_mq_free_tags(tags, flags);
 		return NULL;
 	}
 
@@ -2325,7 +2325,7 @@ struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
 					node);
 	if (!tags->static_rqs) {
 		kfree(tags->rqs);
-		blk_mq_free_tags(tags);
+		blk_mq_free_tags(tags, flags);
 		return NULL;
 	}
 
@@ -2734,10 +2734,11 @@ static void blk_mq_init_cpu_queues(struct request_queue *q,
 static bool __blk_mq_alloc_map_and_request(struct blk_mq_tag_set *set,
 					int hctx_idx)
 {
+	unsigned int flags = set->flags;
 	int ret = 0;
 
 	set->tags[hctx_idx] = blk_mq_alloc_rq_map(set, hctx_idx,
-					set->queue_depth, set->reserved_tags);
+					set->queue_depth, set->reserved_tags, flags);
 	if (!set->tags[hctx_idx])
 		return false;
 
@@ -2746,7 +2747,7 @@ static bool __blk_mq_alloc_map_and_request(struct blk_mq_tag_set *set,
 	if (!ret)
 		return true;
 
-	blk_mq_free_rq_map(set->tags[hctx_idx]);
+	blk_mq_free_rq_map(set->tags[hctx_idx], flags);
 	set->tags[hctx_idx] = NULL;
 	return false;
 }
@@ -2754,9 +2755,11 @@ static bool __blk_mq_alloc_map_and_request(struct blk_mq_tag_set *set,
 static void blk_mq_free_map_and_requests(struct blk_mq_tag_set *set,
 					 unsigned int hctx_idx)
 {
+	unsigned int flags = set->flags;
+
 	if (set->tags && set->tags[hctx_idx]) {
 		blk_mq_free_rqs(set, set->tags[hctx_idx], hctx_idx);
-		blk_mq_free_rq_map(set->tags[hctx_idx]);
+		blk_mq_free_rq_map(set->tags[hctx_idx], flags);
 		set->tags[hctx_idx] = NULL;
 	}
 }
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 863a2f3346d4..b86e7fe47789 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -53,11 +53,12 @@ struct request *blk_mq_dequeue_from_ctx(struct blk_mq_hw_ctx *hctx,
  */
 void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
 		     unsigned int hctx_idx);
-void blk_mq_free_rq_map(struct blk_mq_tags *tags);
+void blk_mq_free_rq_map(struct blk_mq_tags *tags, unsigned int flags);
 struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
 					unsigned int hctx_idx,
 					unsigned int nr_tags,
-					unsigned int reserved_tags);
+					unsigned int reserved_tags,
+					unsigned int flags);
 int blk_mq_alloc_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
 		     unsigned int hctx_idx, unsigned int depth);
 
-- 
2.26.2

