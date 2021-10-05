Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4269C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 10:28:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDC8361528
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 10:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233817AbhJEKaq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 06:30:46 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3919 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234088AbhJEKal (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 06:30:41 -0400
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HNtyB49zkz67bFG;
        Tue,  5 Oct 2021 18:25:22 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 5 Oct 2021 12:28:49 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 5 Oct 2021 11:28:46 +0100
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ming.lei@redhat.com>, <hare@suse.de>,
        <linux-scsi@vger.kernel.org>, <kashyap.desai@broadcom.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v5 02/14] block: Rename BLKDEV_MAX_RQ -> BLKDEV_DEFAULT_RQ
Date:   Tue, 5 Oct 2021 18:23:27 +0800
Message-ID: <1633429419-228500-3-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1633429419-228500-1-git-send-email-john.garry@huawei.com>
References: <1633429419-228500-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-core.c       | 2 +-
 block/blk-mq-sched.c   | 2 +-
 block/blk-mq-sched.h   | 2 +-
 drivers/block/rbd.c    | 2 +-
 include/linux/blk-mq.h | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 61739f73b964..cf0899a93367 100644
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
index 5181487db792..f6a1ce9e31f3 100644
--- a/block/blk-mq-sched.h
+++ b/block/blk-mq-sched.h
@@ -6,7 +6,7 @@
 #include "blk-mq.h"
 #include "blk-mq-tag.h"
 
-#define MAX_SCHED_RQ (16 * BLKDEV_MAX_RQ)
+#define MAX_SCHED_RQ (16 * BLKDEV_DEFAULT_RQ)
 
 void blk_mq_sched_assign_ioc(struct request *rq);
 
diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 341e5da6d029..953fa134cd3d 100644
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
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index bd4086a6f28e..31cc41dfef6b 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -12,7 +12,7 @@ struct blk_mq_tags;
 struct blk_flush_queue;
 
 #define BLKDEV_MIN_RQ	4
-#define BLKDEV_MAX_RQ	128	/* Default maximum */
+#define BLKDEV_DEFAULT_RQ	128
 
 typedef void (rq_end_io_fn)(struct request *, blk_status_t);
 
-- 
2.26.2

