Return-Path: <SRS0=XqvZ=B5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50D57C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 15:27:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 354CA208B3
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 15:27:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgHSP1P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Aug 2020 11:27:15 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:38872 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728203AbgHSPZM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Aug 2020 11:25:12 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 60254424BC119C6AF290;
        Wed, 19 Aug 2020 23:24:58 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Wed, 19 Aug 2020 23:24:51 +0800
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
Subject: [PATCH v8 10/18] blk-mq, elevator: Count requests per hctx to improve performance
Date:   Wed, 19 Aug 2020 23:20:28 +0800
Message-ID: <1597850436-116171-11-git-send-email-john.garry@huawei.com>
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

From: Kashyap Desai <kashyap.desai@broadcom.com>

High CPU utilization on "native_queued_spin_lock_slowpath" due to lock
contention is possible for mq-deadline and bfq IO schedulers
when nr_hw_queues is more than one.

It is because kblockd work queue can submit IO from all online CPUs
(through blk_mq_run_hw_queues()) even though only one hctx has pending
commands.

The elevator callback .has_work for mq-deadline and bfq scheduler considers
pending work if there are any IOs on request queue but it does not account
hctx context.

Add a per-hctx 'elevator_queued' count to the hctx to avoid triggering
the elevator even though there are no requests queued.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
[jpg: Relocated atomic_dec() in dd_dispatch_request(), update commit message per Kashyap]
Signed-off-by: John Garry <john.garry@huawei.com>
---
 block/bfq-iosched.c    | 5 +++++
 block/blk-mq.c         | 1 +
 block/mq-deadline.c    | 6 ++++++
 include/linux/blk-mq.h | 4 ++++
 4 files changed, 16 insertions(+)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 88f0dfa545d7..4650012f1e55 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -4640,6 +4640,9 @@ static bool bfq_has_work(struct blk_mq_hw_ctx *hctx)
 {
 	struct bfq_data *bfqd = hctx->queue->elevator->elevator_data;
 
+	if (!atomic_read(&hctx->elevator_queued))
+		return false;
+
 	/*
 	 * Avoiding lock: a race on bfqd->busy_queues should cause at
 	 * most a call to dispatch for nothing
@@ -5554,6 +5557,7 @@ static void bfq_insert_requests(struct blk_mq_hw_ctx *hctx,
 		rq = list_first_entry(list, struct request, queuelist);
 		list_del_init(&rq->queuelist);
 		bfq_insert_request(hctx, rq, at_head);
+		atomic_inc(&hctx->elevator_queued);
 	}
 }
 
@@ -5933,6 +5937,7 @@ static void bfq_finish_requeue_request(struct request *rq)
 
 		bfq_completed_request(bfqq, bfqd);
 		bfq_finish_requeue_request_body(bfqq);
+		atomic_dec(&rq->mq_hctx->elevator_queued);
 
 		spin_unlock_irqrestore(&bfqd->lock, flags);
 	} else {
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 457b43829a4f..361fb9fe1dc5 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2649,6 +2649,7 @@ blk_mq_alloc_hctx(struct request_queue *q, struct blk_mq_tag_set *set,
 		goto free_hctx;
 
 	atomic_set(&hctx->nr_active, 0);
+	atomic_set(&hctx->elevator_queued, 0);
 	if (node == NUMA_NO_NODE)
 		node = set->numa_node;
 	hctx->numa_node = node;
diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index b57470e154c8..800ac902809b 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -386,6 +386,8 @@ static struct request *dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
 	spin_lock(&dd->lock);
 	rq = __dd_dispatch_request(dd);
 	spin_unlock(&dd->lock);
+	if (rq)
+		atomic_dec(&rq->mq_hctx->elevator_queued);
 
 	return rq;
 }
@@ -533,6 +535,7 @@ static void dd_insert_requests(struct blk_mq_hw_ctx *hctx,
 		rq = list_first_entry(list, struct request, queuelist);
 		list_del_init(&rq->queuelist);
 		dd_insert_request(hctx, rq, at_head);
+		atomic_inc(&hctx->elevator_queued);
 	}
 	spin_unlock(&dd->lock);
 }
@@ -579,6 +582,9 @@ static bool dd_has_work(struct blk_mq_hw_ctx *hctx)
 {
 	struct deadline_data *dd = hctx->queue->elevator->elevator_data;
 
+	if (!atomic_read(&hctx->elevator_queued))
+		return false;
+
 	return !list_empty_careful(&dd->dispatch) ||
 		!list_empty_careful(&dd->fifo_list[0]) ||
 		!list_empty_careful(&dd->fifo_list[1]);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index a4b35ec60faf..2f3ba31a1658 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -139,6 +139,10 @@ struct blk_mq_hw_ctx {
 	 * shared across request queues.
 	 */
 	atomic_t		nr_active;
+	/**
+	 * @elevator_queued: Number of queued requests on hctx.
+	 */
+	atomic_t                elevator_queued;
 
 	/** @cpuhp_online: List to store request if CPU is going to die */
 	struct hlist_node	cpuhp_online;
-- 
2.26.2

