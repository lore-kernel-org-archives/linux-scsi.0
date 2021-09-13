Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5DF4C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 15:17:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85BAE60FF2
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 15:17:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346008AbhIMPTA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 11:19:00 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3776 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345730AbhIMPSr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Sep 2021 11:18:47 -0400
Received: from fraeml741-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H7VQs33bQz682vm;
        Mon, 13 Sep 2021 23:15:17 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml741-chm.china.huawei.com (10.206.15.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 13 Sep 2021 17:17:29 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 13 Sep 2021 16:17:27 +0100
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>
CC:     <linux-kernel@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <ming.lei@redhat.com>, <linux-scsi@vger.kernel.org>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH RESEND v3 04/13] blk-mq: Invert check in blk_mq_update_nr_requests()
Date:   Mon, 13 Sep 2021 23:12:21 +0800
Message-ID: <1631545950-56586-5-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1631545950-56586-1-git-send-email-john.garry@huawei.com>
References: <1631545950-56586-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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
Reviewed-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 1a4bb2db30e5..47d6ab725bcc 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3613,18 +3613,18 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
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

