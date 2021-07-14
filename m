Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39548C07E9C
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 15:11:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10F21613D3
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 15:11:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbhGNPON (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 11:14:13 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3405 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239585AbhGNPOL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 11:14:11 -0400
Received: from fraeml702-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GQ0vk6sbZz6D97c;
        Wed, 14 Jul 2021 22:56:50 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml702-chm.china.huawei.com (10.206.15.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 14 Jul 2021 17:11:17 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Jul 2021 16:11:15 +0100
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ming.lei@redhat.com>, <linux-scsi@vger.kernel.org>,
        <kashyap.desai@broadcom.com>, <hare@suse.de>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 2/9] block: Rename BLKDEV_MAX_RQ -> BLKDEV_DEFAULT_RQ
Date:   Wed, 14 Jul 2021 23:06:28 +0800
Message-ID: <1626275195-215652-3-git-send-email-john.garry@huawei.com>
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

It is a bit confusing that there is BLKDEV_MAX_RQ and MAX_SCHED_RQ, as
the name BLKDEV_MAX_RQ would imply the max requests always, which it is
not.

Rename to BLKDEV_MAX_RQ to BLKDEV_DEFAULT_RQ, matching its usage - that being
the default number of requests assigned when allocating a request queue.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 block/blk-core.c       | 2 +-
 block/blk-mq-sched.c   | 2 +-
 block/blk-mq-sched.h   | 2 +-
 drivers/block/rbd.c    | 2 +-
 include/linux/blkdev.h | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 04477697ee4b..5d71382b6131 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -579,7 +579,7 @@ struct request_queue *blk_alloc_queue(int node_id)
 
 	blk_queue_dma_alignment(q, 511);
 	blk_set_default_limits(&q->limits);
-	q->nr_requests = BLKDEV_MAX_RQ;
+	q->nr_requests = BLKDEV_DEFAULT_RQ;
 
 	return q;
 
diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index c838d81ac058..f5cb2931c20d 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -615,7 +615,7 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
 	 * Additionally, this is a per-hw queue depth.
 	 */
 	q->nr_requests = 2 * min_t(unsigned int, q->tag_set->queue_depth,
-				   BLKDEV_MAX_RQ);
+				   BLKDEV_DEFAULT_RQ);
 
 	queue_for_each_hw_ctx(q, hctx, i) {
 		ret = blk_mq_sched_alloc_tags(q, hctx, i);
diff --git a/block/blk-mq-sched.h b/block/blk-mq-sched.h
index 5246ae040704..1e46be6c5178 100644
--- a/block/blk-mq-sched.h
+++ b/block/blk-mq-sched.h
@@ -5,7 +5,7 @@
 #include "blk-mq.h"
 #include "blk-mq-tag.h"
 
-#define MAX_SCHED_RQ (16 * BLKDEV_MAX_RQ)
+#define MAX_SCHED_RQ (16 * BLKDEV_DEFAULT_RQ)
 
 void blk_mq_sched_assign_ioc(struct request *rq);
 
diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 531d390902dd..d3f329749173 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -836,7 +836,7 @@ struct rbd_options {
 	u32 alloc_hint_flags;  /* CEPH_OSD_OP_ALLOC_HINT_FLAG_* */
 };
 
-#define RBD_QUEUE_DEPTH_DEFAULT	BLKDEV_MAX_RQ
+#define RBD_QUEUE_DEPTH_DEFAULT	BLKDEV_DEFAULT_RQ
 #define RBD_ALLOC_SIZE_DEFAULT	(64 * 1024)
 #define RBD_LOCK_TIMEOUT_DEFAULT 0  /* no timeout */
 #define RBD_READ_ONLY_DEFAULT	false
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 3177181c4326..6a64ea23f552 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -45,7 +45,7 @@ struct blk_stat_callback;
 struct blk_keyslot_manager;
 
 #define BLKDEV_MIN_RQ	4
-#define BLKDEV_MAX_RQ	128	/* Default maximum */
+#define BLKDEV_DEFAULT_RQ	128
 
 /* Must be consistent with blk_mq_poll_stats_bkt() */
 #define BLK_MQ_POLL_STATS_BKTS 16
-- 
2.26.2

