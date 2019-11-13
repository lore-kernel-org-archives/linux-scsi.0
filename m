Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0E79C43331
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 13:40:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADF0322459
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 13:40:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbfKMNkf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Nov 2019 08:40:35 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:40724 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726186AbfKMNke (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Nov 2019 08:40:34 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 1BE813B0E12517482024;
        Wed, 13 Nov 2019 21:40:24 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Wed, 13 Nov 2019 21:40:14 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <ming.lei@redhat.com>,
        <hare@suse.com>, <bvanassche@acm.org>, <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH RFC 1/5] blk-mq: Remove some unused function arguments
Date:   Wed, 13 Nov 2019 21:36:45 +0800
Message-ID: <1573652209-163505-2-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1573652209-163505-1-git-send-email-john.garry@huawei.com>
References: <1573652209-163505-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The struct blk_mq_hw_ctx * argument in blk_mq_put_tag(),
blk_mq_poll_nsecs(), and blk_mq_poll_hybrid_sleep() is unused, so remove
it.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 block/blk-mq-tag.c |  4 ++--
 block/blk-mq-tag.h |  3 +--
 block/blk-mq.c     | 10 ++++------
 block/blk-mq.h     |  2 +-
 4 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 008388e82b5c..53b4a9414fbd 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -191,8 +191,8 @@ unsigned int blk_mq_get_tag(struct blk_mq_alloc_data *data)
 	return tag + tag_offset;
 }
 
-void blk_mq_put_tag(struct blk_mq_hw_ctx *hctx, struct blk_mq_tags *tags,
-		    struct blk_mq_ctx *ctx, unsigned int tag)
+void blk_mq_put_tag(struct blk_mq_tags *tags, struct blk_mq_ctx *ctx,
+		    unsigned int tag)
 {
 	if (!blk_mq_tag_is_reserved(tags, tag)) {
 		const int real_tag = tag - tags->nr_reserved_tags;
diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h
index 61deab0b5a5a..b16f138e75f8 100644
--- a/block/blk-mq-tag.h
+++ b/block/blk-mq-tag.h
@@ -26,8 +26,7 @@ extern struct blk_mq_tags *blk_mq_init_tags(unsigned int nr_tags, unsigned int r
 extern void blk_mq_free_tags(struct blk_mq_tags *tags);
 
 extern unsigned int blk_mq_get_tag(struct blk_mq_alloc_data *data);
-extern void blk_mq_put_tag(struct blk_mq_hw_ctx *hctx, struct blk_mq_tags *tags,
-			   struct blk_mq_ctx *ctx, unsigned int tag);
+extern void blk_mq_put_tag(struct blk_mq_tags *tags, struct blk_mq_ctx *ctx, unsigned int tag);
 extern bool blk_mq_has_free_tags(struct blk_mq_tags *tags);
 extern int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
 					struct blk_mq_tags **tags,
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 6e3b15f70cd7..16aa20d23b67 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -499,9 +499,9 @@ static void __blk_mq_free_request(struct request *rq)
 	blk_pm_mark_last_busy(rq);
 	rq->mq_hctx = NULL;
 	if (rq->tag != -1)
-		blk_mq_put_tag(hctx, hctx->tags, ctx, rq->tag);
+		blk_mq_put_tag(hctx->tags, ctx, rq->tag);
 	if (sched_tag != -1)
-		blk_mq_put_tag(hctx, hctx->sched_tags, ctx, sched_tag);
+		blk_mq_put_tag(hctx->sched_tags, ctx, sched_tag);
 	blk_mq_sched_restart(hctx);
 	blk_queue_exit(q);
 }
@@ -3354,7 +3354,6 @@ static void blk_mq_poll_stats_fn(struct blk_stat_callback *cb)
 }
 
 static unsigned long blk_mq_poll_nsecs(struct request_queue *q,
-				       struct blk_mq_hw_ctx *hctx,
 				       struct request *rq)
 {
 	unsigned long ret = 0;
@@ -3387,7 +3386,6 @@ static unsigned long blk_mq_poll_nsecs(struct request_queue *q,
 }
 
 static bool blk_mq_poll_hybrid_sleep(struct request_queue *q,
-				     struct blk_mq_hw_ctx *hctx,
 				     struct request *rq)
 {
 	struct hrtimer_sleeper hs;
@@ -3407,7 +3405,7 @@ static bool blk_mq_poll_hybrid_sleep(struct request_queue *q,
 	if (q->poll_nsec > 0)
 		nsecs = q->poll_nsec;
 	else
-		nsecs = blk_mq_poll_nsecs(q, hctx, rq);
+		nsecs = blk_mq_poll_nsecs(q, rq);
 
 	if (!nsecs)
 		return false;
@@ -3462,7 +3460,7 @@ static bool blk_mq_poll_hybrid(struct request_queue *q,
 			return false;
 	}
 
-	return blk_mq_poll_hybrid_sleep(q, hctx, rq);
+	return blk_mq_poll_hybrid_sleep(q, rq);
 }
 
 /**
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 32c62c64e6c2..78d38b5f2793 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -208,7 +208,7 @@ static inline bool blk_mq_get_dispatch_budget(struct blk_mq_hw_ctx *hctx)
 static inline void __blk_mq_put_driver_tag(struct blk_mq_hw_ctx *hctx,
 					   struct request *rq)
 {
-	blk_mq_put_tag(hctx, hctx->tags, rq->mq_ctx, rq->tag);
+	blk_mq_put_tag(hctx->tags, rq->mq_ctx, rq->tag);
 	rq->tag = -1;
 
 	if (rq->rq_flags & RQF_MQ_INFLIGHT) {
-- 
2.17.1

