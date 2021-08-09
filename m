Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1EE4C25AE6
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 14:38:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96EC661019
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 14:38:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235505AbhHIOiP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 10:38:15 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3612 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234244AbhHIOgR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 10:36:17 -0400
Received: from fraeml715-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Gjz9c6gdbz6CB0L;
        Mon,  9 Aug 2021 22:34:12 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml715-chm.china.huawei.com (10.206.15.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 9 Aug 2021 16:34:42 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 9 Aug 2021 15:34:39 +0100
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <kashyap.desai@broadcom.com>,
        <hare@suse.de>, <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v2 06/11] blk-mq: Pass driver tags to blk_mq_clear_rq_mapping()
Date:   Mon, 9 Aug 2021 22:29:33 +0800
Message-ID: <1628519378-211232-7-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1628519378-211232-1-git-send-email-john.garry@huawei.com>
References: <1628519378-211232-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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
index 42c4b8d1a570..0bb596f4d061 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2310,10 +2310,9 @@ static size_t order_to_size(unsigned int order)
 }
 
 /* called before freeing request pool in @tags */
-static void blk_mq_clear_rq_mapping(struct blk_mq_tag_set *set,
-		struct blk_mq_tags *tags, unsigned int hctx_idx)
+void blk_mq_clear_rq_mapping(struct blk_mq_tags *drv_tags,
+			     struct blk_mq_tags *tags)
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
 
+		drv_tags = set->tags[hctx_idx];
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

