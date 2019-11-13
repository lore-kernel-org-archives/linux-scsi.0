Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B3BC43331
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 13:40:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2A6C22459
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 13:40:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbfKMNkd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Nov 2019 08:40:33 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:40682 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726434AbfKMNkc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Nov 2019 08:40:32 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 0CB095643DBEA9C9F29D;
        Wed, 13 Nov 2019 21:40:24 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Wed, 13 Nov 2019 21:40:15 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <ming.lei@redhat.com>,
        <hare@suse.com>, <bvanassche@acm.org>, <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH RFC 2/5] blk-mq: rename BLK_MQ_F_TAG_SHARED as BLK_MQ_F_TAG_QUEUE_SHARED
Date:   Wed, 13 Nov 2019 21:36:46 +0800
Message-ID: <1573652209-163505-3-git-send-email-john.garry@huawei.com>
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

From: Ming Lei <ming.lei@redhat.com>

BLK_MQ_F_TAG_SHARED actually means that tags is shared among request
queues, all of which should belong to LUNs attached to same HBA.

So rename it to make the point explicitly.

Suggested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 block/blk-mq-debugfs.c |  2 +-
 block/blk-mq-tag.c     |  2 +-
 block/blk-mq-tag.h     |  4 ++--
 block/blk-mq.c         | 20 ++++++++++----------
 include/linux/blk-mq.h |  2 +-
 5 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index b3f2ba483992..33a40ae1d60f 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -236,7 +236,7 @@ static const char *const alloc_policy_name[] = {
 #define HCTX_FLAG_NAME(name) [ilog2(BLK_MQ_F_##name)] = #name
 static const char *const hctx_flag_name[] = {
 	HCTX_FLAG_NAME(SHOULD_MERGE),
-	HCTX_FLAG_NAME(TAG_SHARED),
+	HCTX_FLAG_NAME(TAG_QUEUE_SHARED),
 	HCTX_FLAG_NAME(BLOCKING),
 	HCTX_FLAG_NAME(NO_SCHED),
 };
diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 53b4a9414fbd..d7aa23c82dbf 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -73,7 +73,7 @@ static inline bool hctx_may_queue(struct blk_mq_hw_ctx *hctx,
 {
 	unsigned int depth, users;
 
-	if (!hctx || !(hctx->flags & BLK_MQ_F_TAG_SHARED))
+	if (!hctx || !(hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED))
 		return true;
 	if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
 		return true;
diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h
index b16f138e75f8..88b85daa4976 100644
--- a/block/blk-mq-tag.h
+++ b/block/blk-mq-tag.h
@@ -54,7 +54,7 @@ extern void __blk_mq_tag_idle(struct blk_mq_hw_ctx *);
 
 static inline bool blk_mq_tag_busy(struct blk_mq_hw_ctx *hctx)
 {
-	if (!(hctx->flags & BLK_MQ_F_TAG_SHARED))
+	if (!(hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED))
 		return false;
 
 	return __blk_mq_tag_busy(hctx);
@@ -62,7 +62,7 @@ static inline bool blk_mq_tag_busy(struct blk_mq_hw_ctx *hctx)
 
 static inline void blk_mq_tag_idle(struct blk_mq_hw_ctx *hctx)
 {
-	if (!(hctx->flags & BLK_MQ_F_TAG_SHARED))
+	if (!(hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED))
 		return;
 
 	__blk_mq_tag_idle(hctx);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 16aa20d23b67..6b39cf0efdcd 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -302,7 +302,7 @@ static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
 		rq->tag = -1;
 		rq->internal_tag = tag;
 	} else {
-		if (data->hctx->flags & BLK_MQ_F_TAG_SHARED) {
+		if (data->hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED) {
 			rq_flags = RQF_MQ_INFLIGHT;
 			atomic_inc(&data->hctx->nr_active);
 		}
@@ -1118,7 +1118,7 @@ static bool blk_mq_mark_tag_wait(struct blk_mq_hw_ctx *hctx,
 	wait_queue_entry_t *wait;
 	bool ret;
 
-	if (!(hctx->flags & BLK_MQ_F_TAG_SHARED)) {
+	if (!(hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED)) {
 		blk_mq_sched_mark_restart_hctx(hctx);
 
 		/*
@@ -1249,7 +1249,7 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list,
 				 * For non-shared tags, the RESTART check
 				 * will suffice.
 				 */
-				if (hctx->flags & BLK_MQ_F_TAG_SHARED)
+				if (hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED)
 					no_tag = true;
 				break;
 			}
@@ -2358,7 +2358,7 @@ blk_mq_alloc_hctx(struct request_queue *q, struct blk_mq_tag_set *set,
 	spin_lock_init(&hctx->lock);
 	INIT_LIST_HEAD(&hctx->dispatch);
 	hctx->queue = q;
-	hctx->flags = set->flags & ~BLK_MQ_F_TAG_SHARED;
+	hctx->flags = set->flags & ~BLK_MQ_F_TAG_QUEUE_SHARED;
 
 	INIT_LIST_HEAD(&hctx->hctx_list);
 
@@ -2575,9 +2575,9 @@ static void queue_set_hctx_shared(struct request_queue *q, bool shared)
 
 	queue_for_each_hw_ctx(q, hctx, i) {
 		if (shared)
-			hctx->flags |= BLK_MQ_F_TAG_SHARED;
+			hctx->flags |= BLK_MQ_F_TAG_QUEUE_SHARED;
 		else
-			hctx->flags &= ~BLK_MQ_F_TAG_SHARED;
+			hctx->flags &= ~BLK_MQ_F_TAG_QUEUE_SHARED;
 	}
 }
 
@@ -2603,7 +2603,7 @@ static void blk_mq_del_queue_tag_set(struct request_queue *q)
 	list_del_rcu(&q->tag_set_list);
 	if (list_is_singular(&set->tag_list)) {
 		/* just transitioned to unshared */
-		set->flags &= ~BLK_MQ_F_TAG_SHARED;
+		set->flags &= ~BLK_MQ_F_TAG_QUEUE_SHARED;
 		/* update existing queue */
 		blk_mq_update_tag_set_depth(set, false);
 	}
@@ -2620,12 +2620,12 @@ static void blk_mq_add_queue_tag_set(struct blk_mq_tag_set *set,
 	 * Check to see if we're transitioning to shared (from 1 to 2 queues).
 	 */
 	if (!list_empty(&set->tag_list) &&
-	    !(set->flags & BLK_MQ_F_TAG_SHARED)) {
-		set->flags |= BLK_MQ_F_TAG_SHARED;
+	    !(set->flags & BLK_MQ_F_TAG_QUEUE_SHARED)) {
+		set->flags |= BLK_MQ_F_TAG_QUEUE_SHARED;
 		/* update existing queue */
 		blk_mq_update_tag_set_depth(set, true);
 	}
-	if (set->flags & BLK_MQ_F_TAG_SHARED)
+	if (set->flags & BLK_MQ_F_TAG_QUEUE_SHARED)
 		queue_set_hctx_shared(q, true);
 	list_add_tail_rcu(&q->tag_set_list, &set->tag_list);
 
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 0bf056de5cc3..147185394a25 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -225,7 +225,7 @@ struct blk_mq_ops {
 
 enum {
 	BLK_MQ_F_SHOULD_MERGE	= 1 << 0,
-	BLK_MQ_F_TAG_SHARED	= 1 << 1,
+	BLK_MQ_F_TAG_QUEUE_SHARED	= 1 << 1,
 	BLK_MQ_F_BLOCKING	= 1 << 5,
 	BLK_MQ_F_NO_SCHED	= 1 << 6,
 	BLK_MQ_F_ALLOC_POLICY_START_BIT = 8,
-- 
2.17.1

