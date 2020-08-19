Return-Path: <SRS0=XqvZ=B5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D05CC433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 15:25:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 457D120897
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 15:25:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbgHSPZn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Aug 2020 11:25:43 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:40096 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728789AbgHSPZm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Aug 2020 11:25:42 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 5579C411A4F08A245081;
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
Subject: [PATCH v8 08/18] blk-mq: Record nr_active_requests per queue for when using shared sbitmap
Date:   Wed, 19 Aug 2020 23:20:26 +0800
Message-ID: <1597850436-116171-9-git-send-email-john.garry@huawei.com>
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

The per-hctx nr_active value can no longer be used to fairly assign a share
of tag depth per request queue for when using a shared sbitmap, as it does
not consider that the tags are shared tags over all hctx's.

For this case, record the nr_active_requests per request_queue, and make
the judgement based on that value.

Tested-by: Don Brace<don.brace@microsemi.com> #SCSI resv cmds patches used
Co-developed-with: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 block/blk-core.c       |  2 ++
 block/blk-mq.c         |  4 ++--
 block/blk-mq.h         | 26 ++++++++++++++++++++++++--
 include/linux/blkdev.h |  2 ++
 4 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index d9d632639bd1..360975255a2a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -542,6 +542,8 @@ struct request_queue *blk_alloc_queue(int node_id)
 	q->backing_dev_info->capabilities = BDI_CAP_CGROUP_WRITEBACK;
 	q->node = node_id;
 
+	atomic_set(&q->nr_active_requests_shared_sbitmap, 0);
+
 	timer_setup(&q->backing_dev_info->laptop_mode_wb_timer,
 		    laptop_mode_timer_fn, 0);
 	timer_setup(&q->timeout, blk_rq_timed_out_timer, 0);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index a500d1dfa1bd..ebb72a59b433 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -519,7 +519,7 @@ void blk_mq_free_request(struct request *rq)
 
 	ctx->rq_completed[rq_is_sync(rq)]++;
 	if (rq->rq_flags & RQF_MQ_INFLIGHT)
-		atomic_dec(&hctx->nr_active);
+		__blk_mq_dec_active_requests(hctx);
 
 	if (unlikely(laptop_mode && !blk_rq_is_passthrough(rq)))
 		laptop_io_completion(q->backing_dev_info);
@@ -1127,7 +1127,7 @@ static bool blk_mq_get_driver_tag(struct request *rq)
 	if ((hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED) &&
 			!(rq->rq_flags & RQF_MQ_INFLIGHT)) {
 		rq->rq_flags |= RQF_MQ_INFLIGHT;
-		atomic_inc(&hctx->nr_active);
+		__blk_mq_inc_active_requests(hctx);
 	}
 	hctx->tags->rqs[rq->tag] = rq;
 	return true;
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 56dc37c21908..25ec73078e95 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -199,6 +199,28 @@ static inline bool blk_mq_get_dispatch_budget(struct request_queue *q)
 	return true;
 }
 
+static inline void __blk_mq_inc_active_requests(struct blk_mq_hw_ctx *hctx)
+{
+	if (blk_mq_is_sbitmap_shared(hctx->flags))
+		atomic_inc(&hctx->queue->nr_active_requests_shared_sbitmap);
+	else
+		atomic_inc(&hctx->nr_active);
+}
+
+static inline void __blk_mq_dec_active_requests(struct blk_mq_hw_ctx *hctx)
+{
+	if (blk_mq_is_sbitmap_shared(hctx->flags))
+		atomic_dec(&hctx->queue->nr_active_requests_shared_sbitmap);
+	else
+		atomic_dec(&hctx->nr_active);
+}
+
+static inline int __blk_mq_active_requests(struct blk_mq_hw_ctx *hctx)
+{
+	if (blk_mq_is_sbitmap_shared(hctx->flags))
+		return atomic_read(&hctx->queue->nr_active_requests_shared_sbitmap);
+	return atomic_read(&hctx->nr_active);
+}
 static inline void __blk_mq_put_driver_tag(struct blk_mq_hw_ctx *hctx,
 					   struct request *rq)
 {
@@ -207,7 +229,7 @@ static inline void __blk_mq_put_driver_tag(struct blk_mq_hw_ctx *hctx,
 
 	if (rq->rq_flags & RQF_MQ_INFLIGHT) {
 		rq->rq_flags &= ~RQF_MQ_INFLIGHT;
-		atomic_dec(&hctx->nr_active);
+		__blk_mq_dec_active_requests(hctx);
 	}
 }
 
@@ -287,7 +309,7 @@ static inline bool hctx_may_queue(struct blk_mq_hw_ctx *hctx,
 	 * Allow at least some tags
 	 */
 	depth = max((bt->sb.depth + users - 1) / users, 4U);
-	return atomic_read(&hctx->nr_active) < depth;
+	return __blk_mq_active_requests(hctx) < depth;
 }
 
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index bb5636cc17b9..1d85235611e1 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -484,6 +484,8 @@ struct request_queue {
 	struct timer_list	timeout;
 	struct work_struct	timeout_work;
 
+	atomic_t		nr_active_requests_shared_sbitmap;
+
 	struct list_head	icq_list;
 #ifdef CONFIG_BLK_CGROUP
 	DECLARE_BITMAP		(blkcg_pols, BLKCG_MAX_POLS);
-- 
2.26.2

