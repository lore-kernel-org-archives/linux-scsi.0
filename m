Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0E82C4320A
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 12:07:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C85A60FDA
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 12:07:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245169AbhH0MHy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 08:07:54 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3702 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245162AbhH0MHx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Aug 2021 08:07:53 -0400
Received: from fraeml739-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Gwz1t0ZZTz67wp5;
        Fri, 27 Aug 2021 20:05:38 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml739-chm.china.huawei.com (10.206.15.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 27 Aug 2021 14:07:02 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 27 Aug 2021 13:07:00 +0100
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ming.lei@redhat.com>, <linux-scsi@vger.kernel.org>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v3 07/13] blk-mq: Pass driver tags to blk_mq_clear_rq_mapping()
Date:   Fri, 27 Aug 2021 20:01:58 +0800
Message-ID: <1630065724-69146-8-git-send-email-john.garry@huawei.com>
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

Function blk_mq_clear_rq_mapping() will be used for shared sbitmap tags
in future, so pass a driver tags pointer instead of the tagset container
and HW queue index.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 block/blk-mq.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index b51d59ec7d7a..556c203e6b7c 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2310,10 +2310,9 @@ static size_t order_to_size(unsigned int order)
 }
 
 /* called before freeing request pool in @tags */
-static void blk_mq_clear_rq_mapping(struct blk_mq_tag_set *set,
-		struct blk_mq_tags *tags, unsigned int hctx_idx)
+static void blk_mq_clear_rq_mapping(struct blk_mq_tags *drv_tags,
+				    struct blk_mq_tags *tags)
 {
-	struct blk_mq_tags *drv_tags = set->tags[hctx_idx];
 	struct page *page;
 	unsigned long flags;
 
@@ -2322,7 +2321,7 @@ static void blk_mq_clear_rq_mapping(struct blk_mq_tag_set *set,
 		unsigned long end = start + order_to_size(page->private);
 		int i;
 
-		for (i = 0; i < set->queue_depth; i++) {
+		for (i = 0; i < drv_tags->nr_tags; i++) {
 			struct request *rq = drv_tags->rqs[i];
 			unsigned long rq_addr = (unsigned long)rq;
 
@@ -2346,8 +2345,11 @@ static void blk_mq_clear_rq_mapping(struct blk_mq_tag_set *set,
 void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
 		     unsigned int hctx_idx)
 {
+	struct blk_mq_tags *drv_tags;
 	struct page *page;
 
+	drv_tags = set->tags[hctx_idx];
+
 	if (tags->static_rqs && set->ops->exit_request) {
 		int i;
 
@@ -2361,7 +2363,7 @@ void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
 		}
 	}
 
-	blk_mq_clear_rq_mapping(set, tags, hctx_idx);
+	blk_mq_clear_rq_mapping(drv_tags, tags);
 
 	while (!list_empty(&tags->page_list)) {
 		page = list_first_entry(&tags->page_list, struct page, lru);
-- 
2.26.2

