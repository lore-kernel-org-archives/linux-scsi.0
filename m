Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E873C07E9A
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 15:11:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFC22613CB
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 15:11:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239675AbhGNPOW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 11:14:22 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3409 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239620AbhGNPOT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 11:14:19 -0400
Received: from fraeml743-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GQ12l6ZtXz6K604;
        Wed, 14 Jul 2021 23:02:55 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml743-chm.china.huawei.com (10.206.15.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Jul 2021 17:11:25 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Jul 2021 16:11:23 +0100
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ming.lei@redhat.com>, <linux-scsi@vger.kernel.org>,
        <kashyap.desai@broadcom.com>, <hare@suse.de>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH RFC 6/9] blk-mq: Refactor blk_mq_{alloc,free}_rqs
Date:   Wed, 14 Jul 2021 23:06:32 +0800
Message-ID: <1626275195-215652-7-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1626275195-215652-1-git-send-email-john.garry@huawei.com>
References: <1626275195-215652-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It will be required to be able to allocate and free static requests for a
tag set or a request queue (in addition to a struct blk_mq_tags), so break
out the common functionality of blk_mq_{alloc,free}_rqs, passing the
required static rqs ** and page list pointer to the core code.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 block/blk-mq.c | 61 +++++++++++++++++++++++++++++++++-----------------
 block/blk-mq.h |  7 ++++++
 2 files changed, 47 insertions(+), 21 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 3ff5c15ce0eb..801af0993044 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2310,14 +2310,15 @@ static size_t order_to_size(unsigned int order)
 }
 
 /* called before freeing request pool in @tags */
-static void blk_mq_clear_rq_mapping(struct blk_mq_tag_set *set,
-		struct blk_mq_tags *tags, unsigned int hctx_idx)
+void blk_mq_clear_rq_mapping(struct blk_mq_tag_set *set,
+			     unsigned int hctx_idx,
+			     struct list_head *page_list)
 {
 	struct blk_mq_tags *drv_tags = set->tags[hctx_idx];
 	struct page *page;
 	unsigned long flags;
 
-	list_for_each_entry(page, &tags->page_list, lru) {
+	list_for_each_entry(page, page_list, lru) {
 		unsigned long start = (unsigned long)page_address(page);
 		unsigned long end = start + order_to_size(page->private);
 		int i;
@@ -2343,28 +2344,29 @@ static void blk_mq_clear_rq_mapping(struct blk_mq_tag_set *set,
 	spin_unlock_irqrestore(&drv_tags->lock, flags);
 }
 
-void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
-		     unsigned int hctx_idx)
+void __blk_mq_free_rqs(struct blk_mq_tag_set *set, unsigned int hctx_idx,
+		       unsigned int depth, struct list_head *page_list,
+		       struct request **static_rqs)
 {
 	struct page *page;
 
-	if (tags->static_rqs && set->ops->exit_request) {
+	if (static_rqs && set->ops->exit_request) {
 		int i;
 
-		for (i = 0; i < tags->nr_tags; i++) {
-			struct request *rq = tags->static_rqs[i];
+		for (i = 0; i < depth; i++) {
+			struct request *rq = static_rqs[i];
 
 			if (!rq)
 				continue;
 			set->ops->exit_request(set, rq, hctx_idx);
-			tags->static_rqs[i] = NULL;
+			static_rqs[i] = NULL;
 		}
 	}
 
-	blk_mq_clear_rq_mapping(set, tags, hctx_idx);
+	blk_mq_clear_rq_mapping(set, hctx_idx, page_list);
 
-	while (!list_empty(&tags->page_list)) {
-		page = list_first_entry(&tags->page_list, struct page, lru);
+	while (!list_empty(page_list)) {
+		page = list_first_entry(page_list, struct page, lru);
 		list_del_init(&page->lru);
 		/*
 		 * Remove kmemleak object previously allocated in
@@ -2375,6 +2377,13 @@ void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
 	}
 }
 
+void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
+		     unsigned int hctx_idx)
+{
+	__blk_mq_free_rqs(set, hctx_idx, tags->nr_tags, &tags->page_list,
+			  tags->static_rqs);
+}
+
 void blk_mq_free_rq_map(struct blk_mq_tags *tags, unsigned int flags)
 {
 	kfree(tags->rqs);
@@ -2437,8 +2446,10 @@ static int blk_mq_init_request(struct blk_mq_tag_set *set, struct request *rq,
 	return 0;
 }
 
-int blk_mq_alloc_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
-		     unsigned int hctx_idx, unsigned int depth)
+
+int __blk_mq_alloc_rqs(struct blk_mq_tag_set *set, unsigned int hctx_idx,
+		       unsigned int depth, struct list_head *page_list,
+		       struct request **static_rqs)
 {
 	unsigned int i, j, entries_per_page, max_order = 4;
 	size_t rq_size, left;
@@ -2448,7 +2459,7 @@ int blk_mq_alloc_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
 	if (node == NUMA_NO_NODE)
 		node = set->numa_node;
 
-	INIT_LIST_HEAD(&tags->page_list);
+	INIT_LIST_HEAD(page_list);
 
 	/*
 	 * rq_size is the size of the request plus driver payload, rounded
@@ -2483,7 +2494,7 @@ int blk_mq_alloc_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
 			goto fail;
 
 		page->private = this_order;
-		list_add_tail(&page->lru, &tags->page_list);
+		list_add_tail(&page->lru, page_list);
 
 		p = page_address(page);
 		/*
@@ -2497,9 +2508,9 @@ int blk_mq_alloc_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
 		for (j = 0; j < to_do; j++) {
 			struct request *rq = p;
 
-			tags->static_rqs[i] = rq;
+			static_rqs[i] = rq;
 			if (blk_mq_init_request(set, rq, hctx_idx, node)) {
-				tags->static_rqs[i] = NULL;
+				static_rqs[i] = NULL;
 				goto fail;
 			}
 
@@ -2510,10 +2521,17 @@ int blk_mq_alloc_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
 	return 0;
 
 fail:
-	blk_mq_free_rqs(set, tags, hctx_idx);
+	__blk_mq_free_rqs(set, hctx_idx, depth, page_list, static_rqs);
 	return -ENOMEM;
 }
 
+int blk_mq_alloc_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
+		     unsigned int hctx_idx, unsigned int depth)
+{
+	return __blk_mq_alloc_rqs(set, hctx_idx, depth, &tags->page_list,
+				  tags->static_rqs);
+}
+
 struct rq_iter_data {
 	struct blk_mq_hw_ctx *hctx;
 	bool has_rq;
@@ -2856,12 +2874,13 @@ static bool __blk_mq_alloc_map_and_request(struct blk_mq_tag_set *set,
 	int ret = 0;
 
 	set->tags[hctx_idx] = blk_mq_alloc_rq_map(set, hctx_idx,
-					set->queue_depth, set->reserved_tags, flags);
+						  set->queue_depth,
+						  set->reserved_tags, flags);
 	if (!set->tags[hctx_idx])
 		return false;
 
 	ret = blk_mq_alloc_rqs(set, set->tags[hctx_idx], hctx_idx,
-				set->queue_depth);
+			       set->queue_depth);
 	if (!ret)
 		return true;
 
diff --git a/block/blk-mq.h b/block/blk-mq.h
index d08779f77a26..1e0fbb06412b 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -54,6 +54,9 @@ void blk_mq_put_rq_ref(struct request *rq);
  */
 void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
 		     unsigned int hctx_idx);
+void __blk_mq_free_rqs(struct blk_mq_tag_set *set, unsigned int hctx_idx,
+		       unsigned int depth, struct list_head *page_list,
+		       struct request **static_rqs);
 void blk_mq_free_rq_map(struct blk_mq_tags *tags, unsigned int flags);
 struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
 					unsigned int hctx_idx,
@@ -63,6 +66,10 @@ struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
 int blk_mq_alloc_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
 		     unsigned int hctx_idx, unsigned int depth);
 
+int __blk_mq_alloc_rqs(struct blk_mq_tag_set *set, unsigned int hctx_idx,
+		       unsigned int depth, struct list_head *page_list,
+		       struct request **static_rqs);
+
 /*
  * Internal helpers for request insertion into sw queues
  */
-- 
2.26.2

