Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 473A0C11F69
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 15:11:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 305D3613F3
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 15:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239731AbhGNPOb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 11:14:31 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3412 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239686AbhGNPOZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 11:14:25 -0400
Received: from fraeml739-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GQ0w14vGsz6D97R;
        Wed, 14 Jul 2021 22:57:05 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml739-chm.china.huawei.com (10.206.15.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Jul 2021 17:11:32 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Jul 2021 16:11:30 +0100
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ming.lei@redhat.com>, <linux-scsi@vger.kernel.org>,
        <kashyap.desai@broadcom.com>, <hare@suse.de>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 9/9] blk-mq: Clear mappings for shared sbitmap sched static rqs
Date:   Wed, 14 Jul 2021 23:06:35 +0800
Message-ID: <1626275195-215652-10-git-send-email-john.garry@huawei.com>
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

To avoid use-after-free in accessing stale requests in the driver tags
rqs[], clear the mappings for the request queue static rqs.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 block/blk-mq-sched.c | 1 +
 block/blk-mq.h       | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index 7b5c46647820..f1cea7f3bc68 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -711,6 +711,7 @@ void blk_mq_sched_free_requests(struct request_queue *q)
 	queue_for_each_hw_ctx(q, hctx, i) {
 		if (hctx->sched_tags) {
 			if (blk_mq_is_sbitmap_shared(q->tag_set->flags)) {
+				blk_mq_clear_rq_mapping(q->tag_set, i, &q->page_list);
 			} else {
 				blk_mq_free_rqs(q->tag_set, hctx->sched_tags, i);
 			}
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 1e0fbb06412b..a5b7aa7a07b9 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -69,6 +69,8 @@ int blk_mq_alloc_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
 int __blk_mq_alloc_rqs(struct blk_mq_tag_set *set, unsigned int hctx_idx,
 		       unsigned int depth, struct list_head *page_list,
 		       struct request **static_rqs);
+void blk_mq_clear_rq_mapping(struct blk_mq_tag_set *set, unsigned int hctx_idx,
+			     struct list_head *page_list);
 
 /*
  * Internal helpers for request insertion into sw queues
-- 
2.26.2

