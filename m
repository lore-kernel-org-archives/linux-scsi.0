Return-Path: <SRS0=XqvZ=B5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B32C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 15:26:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB126208B3
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 15:26:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbgHSP0D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Aug 2020 11:26:03 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:39924 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728782AbgHSPZb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Aug 2020 11:25:31 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id B0A14375EA32A0D143C2;
        Wed, 19 Aug 2020 23:24:58 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Wed, 19 Aug 2020 23:24:49 +0800
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
Subject: [PATCH v8 07/18] blk-mq: Relocate hctx_may_queue()
Date:   Wed, 19 Aug 2020 23:20:25 +0800
Message-ID: <1597850436-116171-8-git-send-email-john.garry@huawei.com>
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

blk-mq.h and blk-mq-tag.h include on each other, which is less than ideal.

Locate hctx_may_queue() to blk-mq.h, as it is not really tag specific code.

In this way, we can drop the blk-mq-tag.h include of blk-mq.h

Signed-off-by: John Garry <john.garry@huawei.com>
---
 block/blk-mq-tag.h | 33 ---------------------------------
 block/blk-mq.h     | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 33 deletions(-)

diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h
index 8f4cce52ba2d..7d3e6b333a4a 100644
--- a/block/blk-mq-tag.h
+++ b/block/blk-mq-tag.h
@@ -2,8 +2,6 @@
 #ifndef INT_BLK_MQ_TAG_H
 #define INT_BLK_MQ_TAG_H
 
-#include "blk-mq.h"
-
 /*
  * Tag address space map.
  */
@@ -81,37 +79,6 @@ static inline void blk_mq_tag_idle(struct blk_mq_hw_ctx *hctx)
 	__blk_mq_tag_idle(hctx);
 }
 
-/*
- * For shared tag users, we track the number of currently active users
- * and attempt to provide a fair share of the tag depth for each of them.
- */
-static inline bool hctx_may_queue(struct blk_mq_hw_ctx *hctx,
-				  struct sbitmap_queue *bt)
-{
-	unsigned int depth, users;
-
-	if (!hctx || !(hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED))
-		return true;
-	if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
-		return true;
-
-	/*
-	 * Don't try dividing an ant
-	 */
-	if (bt->sb.depth == 1)
-		return true;
-
-	users = atomic_read(&hctx->tags->active_queues);
-	if (!users)
-		return true;
-
-	/*
-	 * Allow at least some tags
-	 */
-	depth = max((bt->sb.depth + users - 1) / users, 4U);
-	return atomic_read(&hctx->nr_active) < depth;
-}
-
 static inline bool blk_mq_tag_is_reserved(struct blk_mq_tags *tags,
 					  unsigned int tag)
 {
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 3acdb56065e1..56dc37c21908 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -259,4 +259,36 @@ static inline struct blk_plug *blk_mq_plug(struct request_queue *q,
 	return NULL;
 }
 
+/*
+ * For shared tag users, we track the number of currently active users
+ * and attempt to provide a fair share of the tag depth for each of them.
+ */
+static inline bool hctx_may_queue(struct blk_mq_hw_ctx *hctx,
+				  struct sbitmap_queue *bt)
+{
+	unsigned int depth, users;
+
+	if (!hctx || !(hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED))
+		return true;
+	if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
+		return true;
+
+	/*
+	 * Don't try dividing an ant
+	 */
+	if (bt->sb.depth == 1)
+		return true;
+
+	users = atomic_read(&hctx->tags->active_queues);
+	if (!users)
+		return true;
+
+	/*
+	 * Allow at least some tags
+	 */
+	depth = max((bt->sb.depth + users - 1) / users, 4U);
+	return atomic_read(&hctx->nr_active) < depth;
+}
+
+
 #endif
-- 
2.26.2

