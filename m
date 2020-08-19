Return-Path: <SRS0=XqvZ=B5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DD1EC433E4
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 15:26:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4381D208A9
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 15:26:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbgHSP0E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Aug 2020 11:26:04 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:39912 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728776AbgHSPZa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Aug 2020 11:25:30 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id BB1DD5363F1B61B21628;
        Wed, 19 Aug 2020 23:24:58 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Wed, 19 Aug 2020 23:24:50 +0800
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
Subject: [PATCH v8 09/18] blk-mq: Record active_queues_shared_sbitmap per tag_set for when using shared sbitmap
Date:   Wed, 19 Aug 2020 23:20:27 +0800
Message-ID: <1597850436-116171-10-git-send-email-john.garry@huawei.com>
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

For when using a shared sbitmap, no longer should the number of active
request queues per hctx be relied on for when judging how to share the tag
bitmap.

Instead maintain the number of active request queues per tag_set, and make
the judgement based on that.

Tested-by: Don Brace<don.brace@microsemi.com> #SCSI resv cmds patches used
Originally-from: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 block/blk-mq-tag.c     | 33 +++++++++++++++++++++++++--------
 block/blk-mq.c         |  2 ++
 block/blk-mq.h         | 16 +++++++++++++---
 include/linux/blk-mq.h |  1 +
 include/linux/blkdev.h |  1 +
 5 files changed, 42 insertions(+), 11 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index c6d7ebc62bdb..c31c4a0478a5 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -23,9 +23,18 @@
  */
 bool __blk_mq_tag_busy(struct blk_mq_hw_ctx *hctx)
 {
-	if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state) &&
-	    !test_and_set_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
-		atomic_inc(&hctx->tags->active_queues);
+	if (blk_mq_is_sbitmap_shared(hctx->flags)) {
+		struct request_queue *q = hctx->queue;
+		struct blk_mq_tag_set *set = q->tag_set;
+
+		if (!test_bit(QUEUE_FLAG_HCTX_ACTIVE, &q->queue_flags) &&
+		    !test_and_set_bit(QUEUE_FLAG_HCTX_ACTIVE, &q->queue_flags))
+			atomic_inc(&set->active_queues_shared_sbitmap);
+	} else {
+		if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state) &&
+		    !test_and_set_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
+			atomic_inc(&hctx->tags->active_queues);
+	}
 
 	return true;
 }
@@ -47,11 +56,19 @@ void blk_mq_tag_wakeup_all(struct blk_mq_tags *tags, bool include_reserve)
 void __blk_mq_tag_idle(struct blk_mq_hw_ctx *hctx)
 {
 	struct blk_mq_tags *tags = hctx->tags;
-
-	if (!test_and_clear_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
-		return;
-
-	atomic_dec(&tags->active_queues);
+	struct request_queue *q = hctx->queue;
+	struct blk_mq_tag_set *set = q->tag_set;
+
+	if (blk_mq_is_sbitmap_shared(hctx->flags)) {
+		if (!test_and_clear_bit(QUEUE_FLAG_HCTX_ACTIVE,
+					&q->queue_flags))
+			return;
+		atomic_dec(&set->active_queues_shared_sbitmap);
+	} else {
+		if (!test_and_clear_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
+			return;
+		atomic_dec(&tags->active_queues);
+	}
 
 	blk_mq_tag_wakeup_all(tags, false);
 }
diff --git a/block/blk-mq.c b/block/blk-mq.c
index ebb72a59b433..457b43829a4f 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3431,6 +3431,8 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
 		goto out_free_mq_map;
 
 	if (blk_mq_is_sbitmap_shared(set->flags)) {
+		atomic_set(&set->active_queues_shared_sbitmap, 0);
+
 		if (blk_mq_init_shared_sbitmap(set, set->flags)) {
 			ret = -ENOMEM;
 			goto out_free_mq_rq_maps;
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 25ec73078e95..a52703c98b77 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -292,8 +292,6 @@ static inline bool hctx_may_queue(struct blk_mq_hw_ctx *hctx,
 
 	if (!hctx || !(hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED))
 		return true;
-	if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
-		return true;
 
 	/*
 	 * Don't try dividing an ant
@@ -301,7 +299,19 @@ static inline bool hctx_may_queue(struct blk_mq_hw_ctx *hctx,
 	if (bt->sb.depth == 1)
 		return true;
 
-	users = atomic_read(&hctx->tags->active_queues);
+	if (blk_mq_is_sbitmap_shared(hctx->flags)) {
+		struct request_queue *q = hctx->queue;
+		struct blk_mq_tag_set *set = q->tag_set;
+
+		if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &q->queue_flags))
+			return true;
+		users = atomic_read(&set->active_queues_shared_sbitmap);
+	} else {
+		if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
+			return true;
+		users = atomic_read(&hctx->tags->active_queues);
+	}
+
 	if (!users)
 		return true;
 
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 03b1f39d5a72..a4b35ec60faf 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -252,6 +252,7 @@ struct blk_mq_tag_set {
 	unsigned int		timeout;
 	unsigned int		flags;
 	void			*driver_data;
+	atomic_t		active_queues_shared_sbitmap;
 
 	struct sbitmap_queue	__bitmap_tags;
 	struct sbitmap_queue	__breserved_tags;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1d85235611e1..67b39596436c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -617,6 +617,7 @@ struct request_queue {
 #define QUEUE_FLAG_PCI_P2PDMA	25	/* device supports PCI p2p requests */
 #define QUEUE_FLAG_ZONE_RESETALL 26	/* supports Zone Reset All */
 #define QUEUE_FLAG_RQ_ALLOC_TIME 27	/* record rq->alloc_time_ns */
+#define QUEUE_FLAG_HCTX_ACTIVE 28	/* at least one blk-mq hctx is active */
 
 #define QUEUE_FLAG_MQ_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_SAME_COMP))
-- 
2.26.2

