Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27021C19F3E
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 14:38:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D7976101D
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 14:38:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235421AbhHIOiL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 10:38:11 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3608 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235255AbhHIOfA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 10:35:00 -0400
Received: from fraeml735-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Gjz9P5Kdzz6CB0T;
        Mon,  9 Aug 2021 22:34:01 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml735-chm.china.huawei.com (10.206.15.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 9 Aug 2021 16:34:30 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 9 Aug 2021 15:34:27 +0100
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <kashyap.desai@broadcom.com>,
        <hare@suse.de>, <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v2 02/11] block: Rename BLKDEV_MAX_RQ -> BLKDEV_DEFAULT_RQ
Date:   Mon, 9 Aug 2021 22:29:29 +0800
Message-ID: <1628519378-211232-3-git-send-email-john.garry@huawei.com>
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

It is a bit confusing that there is BLKDEV_MAX_RQ and MAX_SCHED_RQ, as
the name BLKDEV_MAX_RQ would imply the max requests always, which it is
not.

Rename to BLKDEV_MAX_RQ to BLKDEV_DEFAULT_RQ, matching it's usage - that being
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
index 6d596c2c2cd6..8bae60f6fa75 100644
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
index b5c033cf5f26..56870a43ae4c 100644
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

