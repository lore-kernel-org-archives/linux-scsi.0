Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43B50C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 07:38:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239072AbhK3Hll (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 02:41:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25538 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239071AbhK3Hli (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Nov 2021 02:41:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638257899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qO/LILEvME24ar0ge2kp6BrECIWFnm0u0G6v6wboYKI=;
        b=UvRrM4FrpVoAibl7kaTM2RiDaFBfePgb2EuNIKxqLpB22dRfVcjPl9Vc4e/iXknzb/T9qd
        xCSKxdRk3I9/GiLyMT8ngxh+pC4hBGSUhri4e8B7Dgpfh15WSIOcH8Jrj+zG9EXw8T0W2Q
        cq8d5TuS+nHhKa1EjSHq/vZR91L8t1A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-296-SQLNRBG-PM2PmxISjzafAQ-1; Tue, 30 Nov 2021 02:38:16 -0500
X-MC-Unique: SQLNRBG-PM2PmxISjzafAQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8A46180FD64;
        Tue, 30 Nov 2021 07:38:14 +0000 (UTC)
Received: from localhost (ovpn-8-25.pek2.redhat.com [10.72.8.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 735F767842;
        Tue, 30 Nov 2021 07:38:11 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>, Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 1/5] blk-mq: remove hctx_lock and hctx_unlock
Date:   Tue, 30 Nov 2021 15:37:48 +0800
Message-Id: <20211130073752.3005936-2-ming.lei@redhat.com>
In-Reply-To: <20211130073752.3005936-1-ming.lei@redhat.com>
References: <20211130073752.3005936-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove hctx_lock and hctx_unlock, and add one helper of
blk_mq_run_dispatch_ops() to run code block defined in dispatch_ops
with rcu/srcu read held.

Compared with hctx_lock()/hctx_unlock():

1) remove 2 branch to 1, so we just need to check
(hctx->flags & BLK_MQ_F_BLOCKING) once when running one dispatch_ops

2) srcu_idx needn't to be touched in case of non-blocking

3) might_sleep_if() can be moved to the blocking branch

t/io_uring shows that ~4% IOPS boost is observed on null_blk.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq.c | 79 ++++++++++++++++++++------------------------------
 1 file changed, 31 insertions(+), 48 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 2deb99cf185e..c5dc716b8167 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1079,25 +1079,22 @@ void blk_mq_complete_request(struct request *rq)
 }
 EXPORT_SYMBOL(blk_mq_complete_request);
 
-static void hctx_unlock(struct blk_mq_hw_ctx *hctx, int srcu_idx)
-	__releases(hctx->srcu)
-{
-	if (!(hctx->flags & BLK_MQ_F_BLOCKING))
-		rcu_read_unlock();
-	else
-		srcu_read_unlock(hctx->srcu, srcu_idx);
-}
-
-static void hctx_lock(struct blk_mq_hw_ctx *hctx, int *srcu_idx)
-	__acquires(hctx->srcu)
-{
-	if (!(hctx->flags & BLK_MQ_F_BLOCKING)) {
-		/* shut up gcc false positive */
-		*srcu_idx = 0;
-		rcu_read_lock();
-	} else
-		*srcu_idx = srcu_read_lock(hctx->srcu);
-}
+/* run the code block in @dispatch_ops with rcu/srcu read lock held */
+#define blk_mq_run_dispatch_ops(hctx, dispatch_ops)		\
+do {								\
+	if (!(hctx->flags & BLK_MQ_F_BLOCKING)) {		\
+		rcu_read_lock();				\
+		(dispatch_ops);					\
+		rcu_read_unlock();				\
+	} else {						\
+		int srcu_idx;					\
+								\
+		might_sleep();					\
+		srcu_idx = srcu_read_lock(hctx->srcu);		\
+		(dispatch_ops);					\
+		srcu_read_unlock(hctx->srcu, srcu_idx);		\
+	}							\
+} while (0)
 
 /**
  * blk_mq_start_request - Start processing a request
@@ -1960,19 +1957,13 @@ bool blk_mq_dispatch_rq_list(struct blk_mq_hw_ctx *hctx, struct list_head *list,
  */
 static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
 {
-	int srcu_idx;
-
 	/*
 	 * We can't run the queue inline with ints disabled. Ensure that
 	 * we catch bad users of this early.
 	 */
 	WARN_ON_ONCE(in_interrupt());
 
-	might_sleep_if(hctx->flags & BLK_MQ_F_BLOCKING);
-
-	hctx_lock(hctx, &srcu_idx);
-	blk_mq_sched_dispatch_requests(hctx);
-	hctx_unlock(hctx, srcu_idx);
+	blk_mq_run_dispatch_ops(hctx, blk_mq_sched_dispatch_requests(hctx));
 }
 
 static inline int blk_mq_first_mapped_cpu(struct blk_mq_hw_ctx *hctx)
@@ -2084,7 +2075,6 @@ EXPORT_SYMBOL(blk_mq_delay_run_hw_queue);
  */
 void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async)
 {
-	int srcu_idx;
 	bool need_run;
 
 	/*
@@ -2095,10 +2085,9 @@ void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async)
 	 * And queue will be rerun in blk_mq_unquiesce_queue() if it is
 	 * quiesced.
 	 */
-	hctx_lock(hctx, &srcu_idx);
-	need_run = !blk_queue_quiesced(hctx->queue) &&
-		blk_mq_hctx_has_pending(hctx);
-	hctx_unlock(hctx, srcu_idx);
+	blk_mq_run_dispatch_ops(hctx,
+		need_run = !blk_queue_quiesced(hctx->queue) &&
+		blk_mq_hctx_has_pending(hctx));
 
 	if (need_run)
 		__blk_mq_delay_run_hw_queue(hctx, async, 0);
@@ -2502,31 +2491,25 @@ static void blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
 		struct request *rq)
 {
 	blk_status_t ret;
-	int srcu_idx;
-
-	might_sleep_if(hctx->flags & BLK_MQ_F_BLOCKING);
-
-	hctx_lock(hctx, &srcu_idx);
-
-	ret = __blk_mq_try_issue_directly(hctx, rq, false, true);
-	if (ret == BLK_STS_RESOURCE || ret == BLK_STS_DEV_RESOURCE)
-		blk_mq_request_bypass_insert(rq, false, true);
-	else if (ret != BLK_STS_OK)
-		blk_mq_end_request(rq, ret);
 
-	hctx_unlock(hctx, srcu_idx);
+	blk_mq_run_dispatch_ops(hctx,
+		{
+		ret = __blk_mq_try_issue_directly(hctx, rq, false, true);
+		if (ret == BLK_STS_RESOURCE || ret == BLK_STS_DEV_RESOURCE)
+			blk_mq_request_bypass_insert(rq, false, true);
+		else if (ret != BLK_STS_OK)
+			blk_mq_end_request(rq, ret);
+		}
+	);
 }
 
 static blk_status_t blk_mq_request_issue_directly(struct request *rq, bool last)
 {
 	blk_status_t ret;
-	int srcu_idx;
 	struct blk_mq_hw_ctx *hctx = rq->mq_hctx;
 
-	hctx_lock(hctx, &srcu_idx);
-	ret = __blk_mq_try_issue_directly(hctx, rq, true, last);
-	hctx_unlock(hctx, srcu_idx);
-
+	blk_mq_run_dispatch_ops(hctx,
+		ret = __blk_mq_try_issue_directly(hctx, rq, true, last));
 	return ret;
 }
 
-- 
2.31.1

