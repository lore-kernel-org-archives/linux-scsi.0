Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8471CC11F67
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 15:11:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7213B613D7
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 15:11:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239673AbhGNPOX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 11:14:23 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3410 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239653AbhGNPOV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 11:14:21 -0400
Received: from fraeml742-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GQ12n6kyjz6K648;
        Wed, 14 Jul 2021 23:02:57 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml742-chm.china.huawei.com (10.206.15.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Jul 2021 17:11:28 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Jul 2021 16:11:25 +0100
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ming.lei@redhat.com>, <linux-scsi@vger.kernel.org>,
        <kashyap.desai@broadcom.com>, <hare@suse.de>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH RFC 7/9] blk-mq: Allocate per tag set static rqs for shared sbitmap
Date:   Wed, 14 Jul 2021 23:06:33 +0800
Message-ID: <1626275195-215652-8-git-send-email-john.garry@huawei.com>
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

It is wasteful for memory that a full set of static rqs is allocated per
hw queue for shared sbitmap, considering that the total number of requests
usable at any given time across all hctx is limited by the shared sbitmap
depth.

As such, it is considerably more memory efficient in the case of shared
sbitmap to allocate a set of static rqs per tag set, and not per hw queue.

Make this change, and ensure that the hctx_idx argument to
blk_mq_init_request() and __blk_mq_free_rqs() is == 0 for case of
shared sbitmap. If a driver needs to init the static rq with a hctx idx,
then it cannot now use shared sbitmap - only SCSI drivers and null block
use shared sbitmap today, and neither use hctx_idx for static request init
or free.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 block/blk-mq.c         | 66 +++++++++++++++++++++++++++++++++++++-----
 include/linux/blk-mq.h |  4 +++
 2 files changed, 62 insertions(+), 8 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 801af0993044..764c601376c6 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2350,6 +2350,9 @@ void __blk_mq_free_rqs(struct blk_mq_tag_set *set, unsigned int hctx_idx,
 {
 	struct page *page;
 
+	if (WARN_ON((hctx_idx > 0) && blk_mq_is_sbitmap_shared(set->flags)))
+		return;
+
 	if (static_rqs && set->ops->exit_request) {
 		int i;
 
@@ -2455,6 +2458,9 @@ int __blk_mq_alloc_rqs(struct blk_mq_tag_set *set, unsigned int hctx_idx,
 	size_t rq_size, left;
 	int node;
 
+	if (WARN_ON((hctx_idx > 0) && blk_mq_is_sbitmap_shared(set->flags)))
+		return -EINVAL;
+
 	node = blk_mq_hw_queue_to_node(&set->map[HCTX_TYPE_DEFAULT], hctx_idx);
 	if (node == NUMA_NO_NODE)
 		node = set->numa_node;
@@ -2875,15 +2881,30 @@ static bool __blk_mq_alloc_map_and_request(struct blk_mq_tag_set *set,
 
 	set->tags[hctx_idx] = blk_mq_alloc_rq_map(set, hctx_idx,
 						  set->queue_depth,
-						  set->reserved_tags, flags);
+						  set->reserved_tags,
+						  flags);
 	if (!set->tags[hctx_idx])
 		return false;
 
-	ret = blk_mq_alloc_rqs(set, set->tags[hctx_idx], hctx_idx,
-			       set->queue_depth);
+	if (blk_mq_is_sbitmap_shared(flags)) {
+		int i;
+
+		if (!set->static_rqs)
+			goto err_out;
+
+		for (i = 0; i < set->queue_depth; i++)
+			set->tags[hctx_idx]->static_rqs[i] =
+						set->static_rqs[i];
+
+		return true;
+	} else {
+		ret = blk_mq_alloc_rqs(set, set->tags[hctx_idx], hctx_idx,
+				       set->queue_depth);
+	}
 	if (!ret)
 		return true;
 
+err_out:
 	blk_mq_free_rq_map(set->tags[hctx_idx], flags);
 	set->tags[hctx_idx] = NULL;
 	return false;
@@ -2895,7 +2916,8 @@ static void blk_mq_free_map_and_requests(struct blk_mq_tag_set *set,
 	unsigned int flags = set->flags;
 
 	if (set->tags && set->tags[hctx_idx]) {
-		blk_mq_free_rqs(set, set->tags[hctx_idx], hctx_idx);
+		if (!blk_mq_is_sbitmap_shared(set->flags))
+			blk_mq_free_rqs(set, set->tags[hctx_idx], hctx_idx);
 		blk_mq_free_rq_map(set->tags[hctx_idx], flags);
 		set->tags[hctx_idx] = NULL;
 	}
@@ -3363,6 +3385,21 @@ static int __blk_mq_alloc_rq_maps(struct blk_mq_tag_set *set)
 {
 	int i;
 
+	if (blk_mq_is_sbitmap_shared(set->flags)) {
+		gfp_t flags = GFP_NOIO | __GFP_NOWARN | __GFP_NORETRY;
+		int ret;
+
+		set->static_rqs = kcalloc_node(set->queue_depth,
+					       sizeof(struct request *),
+					       flags, set->numa_node);
+		if (!set->static_rqs)
+			return -ENOMEM;
+		ret = __blk_mq_alloc_rqs(set, 0, set->queue_depth,
+					 &set->page_list, set->static_rqs);
+		if (ret < 0)
+			goto out_free_static_rqs;
+	}
+
 	for (i = 0; i < set->nr_hw_queues; i++) {
 		if (!__blk_mq_alloc_map_and_request(set, i))
 			goto out_unwind;
@@ -3374,7 +3411,15 @@ static int __blk_mq_alloc_rq_maps(struct blk_mq_tag_set *set)
 out_unwind:
 	while (--i >= 0)
 		blk_mq_free_map_and_requests(set, i);
-
+	if (blk_mq_is_sbitmap_shared(set->flags)) {
+		__blk_mq_free_rqs(set, 0, set->queue_depth, &set->page_list,
+				  set->static_rqs);
+	}
+out_free_static_rqs:
+	if (blk_mq_is_sbitmap_shared(set->flags)) {
+		kfree(set->static_rqs);
+		set->static_rqs = NULL;
+	}
 	return -ENOMEM;
 }
 
@@ -3601,12 +3646,17 @@ void blk_mq_free_tag_set(struct blk_mq_tag_set *set)
 {
 	int i, j;
 
+	if (blk_mq_is_sbitmap_shared(set->flags)) {
+		blk_mq_exit_shared_sbitmap(set);
+		__blk_mq_free_rqs(set, 0, set->queue_depth, &set->page_list,
+				  set->static_rqs);
+		kfree(set->static_rqs);
+		set->static_rqs = NULL;
+	}
+
 	for (i = 0; i < set->nr_hw_queues; i++)
 		blk_mq_free_map_and_requests(set, i);
 
-	if (blk_mq_is_sbitmap_shared(set->flags))
-		blk_mq_exit_shared_sbitmap(set);
-
 	for (j = 0; j < set->nr_maps; j++) {
 		kfree(set->map[j].mq_map);
 		set->map[j].mq_map = NULL;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 1d18447ebebc..68b648ab5435 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -261,6 +261,10 @@ struct blk_mq_tag_set {
 	struct sbitmap_queue	__breserved_tags;
 	struct blk_mq_tags	**tags;
 
+	/* for shared sbitmap */
+	struct request **static_rqs;
+	struct list_head page_list;
+
 	struct mutex		tag_list_lock;
 	struct list_head	tag_list;
 };
-- 
2.26.2

