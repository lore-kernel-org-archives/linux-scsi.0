Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C228C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 02:19:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3C6D61266
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 02:19:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234033AbhKSCWa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Nov 2021 21:22:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55765 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229879AbhKSCW3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Nov 2021 21:22:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637288368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MW2hk2WD79i5l8JecZ6fNd7+T/zbAnW3HDjJF4jFwb8=;
        b=h8xcgw2bAeInu2HS9u6+PHWXQwcYXx+rCAugwP4clcJTcU7s34TeD8aDDhnfOMuBeX6vfg
        vFxe+ltp+eVftN/tOfswX7p+N4EuP7+BzGCvM5/jIrjID1eYP4jRm3ekSH0rhl8cBuku1j
        dydBGJ9FNXx7M5gQYoc70WLRdfcvHrg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-98-6ie_PxG9N4K-z5EhQ4hQzw-1; Thu, 18 Nov 2021 21:19:23 -0500
X-MC-Unique: 6ie_PxG9N4K-z5EhQ4hQzw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C5871006AA0;
        Fri, 19 Nov 2021 02:19:22 +0000 (UTC)
Received: from localhost (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 13F0B5F4ED;
        Fri, 19 Nov 2021 02:19:14 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>, Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 2/5] blk-mq: rename hctx_lock & hctx_unlock
Date:   Fri, 19 Nov 2021 10:18:46 +0800
Message-Id: <20211119021849.2259254-3-ming.lei@redhat.com>
In-Reply-To: <20211119021849.2259254-1-ming.lei@redhat.com>
References: <20211119021849.2259254-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We have moved srcu from 'struct blk_mq_hw_ctx' into 'struct request_queue',
both hctx_lock and hctx_unlock are run on request queue level, so rename
them as queue_lock and queue_unlock().

And it could be used for supporting Jens's ->queue_rqs(), as suggested
by Keith.

Also it could be extended for driver uses in future.

Cc: Keith Busch <kbusch@kernel.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq.c | 40 +++++++++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 9728a571b009..ba0d0e411b65 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1076,24 +1076,26 @@ void blk_mq_complete_request(struct request *rq)
 }
 EXPORT_SYMBOL(blk_mq_complete_request);
 
-static inline void hctx_unlock(struct blk_mq_hw_ctx *hctx, int srcu_idx)
-	__releases(hctx->srcu)
+static inline void queue_unlock(struct request_queue *q, bool blocking,
+		int srcu_idx)
+	__releases(q->srcu)
 {
-	if (!(hctx->flags & BLK_MQ_F_BLOCKING))
+	if (!blocking)
 		rcu_read_unlock();
 	else
-		srcu_read_unlock(hctx->queue->srcu, srcu_idx);
+		srcu_read_unlock(q->srcu, srcu_idx);
 }
 
-static inline void hctx_lock(struct blk_mq_hw_ctx *hctx, int *srcu_idx)
+static inline void queue_lock(struct request_queue *q, bool blocking,
+		int *srcu_idx)
 	__acquires(hctx->srcu)
 {
-	if (!(hctx->flags & BLK_MQ_F_BLOCKING)) {
+	if (!blocking) {
 		/* shut up gcc false positive */
 		*srcu_idx = 0;
 		rcu_read_lock();
 	} else
-		*srcu_idx = srcu_read_lock(hctx->queue->srcu);
+		*srcu_idx = srcu_read_lock(q->srcu);
 }
 
 /**
@@ -1958,6 +1960,7 @@ bool blk_mq_dispatch_rq_list(struct blk_mq_hw_ctx *hctx, struct list_head *list,
 static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
 {
 	int srcu_idx;
+	bool blocking = hctx->flags & BLK_MQ_F_BLOCKING;
 
 	/*
 	 * We can't run the queue inline with ints disabled. Ensure that
@@ -1965,11 +1968,11 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
 	 */
 	WARN_ON_ONCE(in_interrupt());
 
-	might_sleep_if(hctx->flags & BLK_MQ_F_BLOCKING);
+	might_sleep_if(blocking);
 
-	hctx_lock(hctx, &srcu_idx);
+	queue_lock(hctx->queue, blocking, &srcu_idx);
 	blk_mq_sched_dispatch_requests(hctx);
-	hctx_unlock(hctx, srcu_idx);
+	queue_unlock(hctx->queue, blocking, srcu_idx);
 }
 
 static inline int blk_mq_first_mapped_cpu(struct blk_mq_hw_ctx *hctx)
@@ -2083,6 +2086,7 @@ void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async)
 {
 	int srcu_idx;
 	bool need_run;
+	bool blocking = hctx->flags & BLK_MQ_F_BLOCKING;
 
 	/*
 	 * When queue is quiesced, we may be switching io scheduler, or
@@ -2092,10 +2096,10 @@ void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async)
 	 * And queue will be rerun in blk_mq_unquiesce_queue() if it is
 	 * quiesced.
 	 */
-	hctx_lock(hctx, &srcu_idx);
+	queue_lock(hctx->queue, blocking, &srcu_idx);
 	need_run = !blk_queue_quiesced(hctx->queue) &&
 		blk_mq_hctx_has_pending(hctx);
-	hctx_unlock(hctx, srcu_idx);
+	queue_unlock(hctx->queue, blocking, srcu_idx);
 
 	if (need_run)
 		__blk_mq_delay_run_hw_queue(hctx, async, 0);
@@ -2500,10 +2504,11 @@ static void blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
 {
 	blk_status_t ret;
 	int srcu_idx;
+	bool blocking = hctx->flags & BLK_MQ_F_BLOCKING;
 
-	might_sleep_if(hctx->flags & BLK_MQ_F_BLOCKING);
+	might_sleep_if(blocking);
 
-	hctx_lock(hctx, &srcu_idx);
+	queue_lock(hctx->queue, blocking, &srcu_idx);
 
 	ret = __blk_mq_try_issue_directly(hctx, rq, false, true);
 	if (ret == BLK_STS_RESOURCE || ret == BLK_STS_DEV_RESOURCE)
@@ -2511,7 +2516,7 @@ static void blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
 	else if (ret != BLK_STS_OK)
 		blk_mq_end_request(rq, ret);
 
-	hctx_unlock(hctx, srcu_idx);
+	queue_unlock(hctx->queue, blocking, srcu_idx);
 }
 
 static blk_status_t blk_mq_request_issue_directly(struct request *rq, bool last)
@@ -2519,10 +2524,11 @@ static blk_status_t blk_mq_request_issue_directly(struct request *rq, bool last)
 	blk_status_t ret;
 	int srcu_idx;
 	struct blk_mq_hw_ctx *hctx = rq->mq_hctx;
+	bool blocking = hctx->flags & BLK_MQ_F_BLOCKING;
 
-	hctx_lock(hctx, &srcu_idx);
+	queue_lock(hctx->queue, blocking, &srcu_idx);
 	ret = __blk_mq_try_issue_directly(hctx, rq, true, last);
-	hctx_unlock(hctx, srcu_idx);
+	queue_unlock(hctx->queue, blocking, srcu_idx);
 
 	return ret;
 }
-- 
2.31.1

