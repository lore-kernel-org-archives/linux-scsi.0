Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C119C11F66
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 15:11:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18843613CF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 15:11:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239635AbhGNPOU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 11:14:20 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3408 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239623AbhGNPOR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 11:14:17 -0400
Received: from fraeml744-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GQ0zf6NGwz6L88Y;
        Wed, 14 Jul 2021 23:00:14 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml744-chm.china.huawei.com (10.206.15.225) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Jul 2021 17:11:23 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Jul 2021 16:11:21 +0100
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ming.lei@redhat.com>, <linux-scsi@vger.kernel.org>,
        <kashyap.desai@broadcom.com>, <hare@suse.de>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 5/9] blk-mq: Invert check in blk_mq_update_nr_requests()
Date:   Wed, 14 Jul 2021 23:06:31 +0800
Message-ID: <1626275195-215652-6-git-send-email-john.garry@huawei.com>
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

It's easier to read:

if (x)
	X;
else
	Y;

over:

if (!x)
	Y;
else
	X;

No functional change intended.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 block/blk-mq.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index b0d4197d36c7..3ff5c15ce0eb 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3621,18 +3621,18 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
 		 * If we're using an MQ scheduler, just update the scheduler
 		 * queue depth. This is similar to what the old code would do.
 		 */
-		if (!hctx->sched_tags) {
-			ret = blk_mq_tag_update_depth(hctx, &hctx->tags, nr,
-							false);
-		} else {
+		if (hctx->sched_tags) {
 			ret = blk_mq_tag_update_depth(hctx, &hctx->sched_tags,
-							nr, true);
+						      nr, true);
 			if (blk_mq_is_sbitmap_shared(set->flags)) {
 				hctx->sched_tags->bitmap_tags =
 					&q->sched_bitmap_tags;
 				hctx->sched_tags->breserved_tags =
 					&q->sched_breserved_tags;
 			}
+		} else {
+			ret = blk_mq_tag_update_depth(hctx, &hctx->tags, nr,
+						      false);
 		}
 		if (ret)
 			break;
-- 
2.26.2

