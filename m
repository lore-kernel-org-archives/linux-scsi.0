Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1523AC4320E
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 12:06:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01CF761029
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 12:06:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245108AbhH0MHo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 08:07:44 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3697 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245112AbhH0MHn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Aug 2021 08:07:43 -0400
Received: from fraeml745-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Gwz1q26Rvz67YT1;
        Fri, 27 Aug 2021 20:05:35 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml745-chm.china.huawei.com (10.206.15.226) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 27 Aug 2021 14:06:52 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 27 Aug 2021 13:06:50 +0100
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ming.lei@redhat.com>, <linux-scsi@vger.kernel.org>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v3 02/13] block: Rename BLKDEV_MAX_RQ -> BLKDEV_DEFAULT_RQ
Date:   Fri, 27 Aug 2021 20:01:53 +0800
Message-ID: <1630065724-69146-3-git-send-email-john.garry@huawei.com>
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

It is a bit confusing that there is BLKDEV_MAX_RQ and MAX_SCHED_RQ, as
the name BLKDEV_MAX_RQ would imply the max requests always, which it is
not.

Rename to BLKDEV_MAX_RQ to BLKDEV_DEFAULT_RQ, matching its usage - that being
the default number of requests assigned when allocating a request queue.

Signed-off-by: John Garry <john.garry@huawei.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c       | 2 +-
 block/blk-mq-sched.c   | 2 +-
 block/blk-mq-sched.h   | 2 +-
 drivers/block/rbd.c    | 2 +-
 include/linux/blkdev.h | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 0874bc2fcdb4..93b585593ebd 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -569,7 +569,7 @@ struct request_queue *blk_alloc_queue(int node_id)
 
 	blk_queue_dma_alignment(q, 511);
 	blk_set_default_limits(&q->limits);
-	q->nr_requests = BLKDEV_MAX_RQ;
+	q->nr_requests = BLKDEV_DEFAULT_RQ;
 
 	return q;
 
diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index 0f006cabfd91..2231fb0d4c35 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -606,7 +606,7 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
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
index e65c9d706f6f..bf60aebd0cfb 100644
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
index c9cb12483e12..fc3987eda2c1 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -44,7 +44,7 @@ struct blk_stat_callback;
 struct blk_keyslot_manager;
 
 #define BLKDEV_MIN_RQ	4
-#define BLKDEV_MAX_RQ	128	/* Default maximum */
+#define BLKDEV_DEFAULT_RQ	128
 
 /* Must be consistent with blk_mq_poll_stats_bkt() */
 #define BLK_MQ_POLL_STATS_BKTS 16
-- 
2.26.2

