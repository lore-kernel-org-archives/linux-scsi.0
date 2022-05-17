Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A978AC43219
	for <linux-scsi@archiver.kernel.org>; Tue, 17 May 2022 06:50:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiEQGuK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 May 2022 02:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiEQGtq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 May 2022 02:49:46 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41EAC45AC0;
        Mon, 16 May 2022 23:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=SxE/KGWMU/AOceGYHMSH7kVSHaDmfBJq5Hx3GU6lTjM=; b=GJzUPGeMt9Y8Gn0OXX48Gjo/VX
        QOF9A0SOF/u82Gb43xSRhTQc0VRHTzbFlAIqmuzl6l3yRNPmlMjdh3Vus1TBd/ZEv8Uc9rdpSo0FX
        CqIhHni5JtX9JQ+3W3urVRG/IgMB1L9Y8q+/CWFzaNdsVVI/Yj1dp3EeAU8J9AEL/ryG93fOmRGWH
        VlfWX4FcV1E7qgkV8nPs1BVTc1hg2fx/Zi2o7nbbwRz5iHJI+M2snEnidc0TJDU40V2G+src/urfS
        UebbV5FQYLlvnM9N7ecemEZcvs1GArCMXV9cLTZkzJ69HFaIchvb09chRv6o4a8itC8AODGTz592V
        ELlZ6m/g==;
Received: from [2001:4bb8:19a:7bdf:afb1:9e:37ad:b912] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nqr0z-00Bsdb-Ow; Tue, 17 May 2022 06:49:06 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH 1/3] blk-mq: remove __blk_execute_rq_nowait
Date:   Tue, 17 May 2022 08:48:59 +0200
Message-Id: <20220517064901.3059255-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220517064901.3059255-1-hch@lst.de>
References: <20220517064901.3059255-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We don't want to plug for synchronous execution that where we immediately
wait for the request.  Once that is done not a whole lot of code is
shared, so just remove __blk_execute_rq_nowait.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c | 70 ++++++++++++++++++++++----------------------------
 1 file changed, 31 insertions(+), 39 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index ed1869a305c46..aae0c8a325904 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1203,28 +1203,6 @@ static void blk_add_rq_to_plug(struct blk_plug *plug, struct request *rq)
 	plug->rq_count++;
 }
 
-static void __blk_execute_rq_nowait(struct request *rq, bool at_head,
-		rq_end_io_fn *done, bool use_plug)
-{
-	WARN_ON(irqs_disabled());
-	WARN_ON(!blk_rq_is_passthrough(rq));
-
-	rq->end_io = done;
-
-	blk_account_io_start(rq);
-
-	if (use_plug && current->plug) {
-		blk_add_rq_to_plug(current->plug, rq);
-		return;
-	}
-	/*
-	 * don't check dying flag for MQ because the request won't
-	 * be reused after dying flag is set
-	 */
-	blk_mq_sched_insert_request(rq, at_head, true, false);
-}
-
-
 /**
  * blk_execute_rq_nowait - insert a request to I/O scheduler for execution
  * @rq:		request to insert
@@ -1240,8 +1218,16 @@ static void __blk_execute_rq_nowait(struct request *rq, bool at_head,
  */
 void blk_execute_rq_nowait(struct request *rq, bool at_head, rq_end_io_fn *done)
 {
-	__blk_execute_rq_nowait(rq, at_head, done, true);
+	WARN_ON(irqs_disabled());
+	WARN_ON(!blk_rq_is_passthrough(rq));
 
+	rq->end_io = done;
+
+	blk_account_io_start(rq);
+	if (current->plug)
+		blk_add_rq_to_plug(current->plug, rq);
+	else
+		blk_mq_sched_insert_request(rq, at_head, true, false);
 }
 EXPORT_SYMBOL_GPL(blk_execute_rq_nowait);
 
@@ -1277,27 +1263,33 @@ static void blk_rq_poll_completion(struct request *rq, struct completion *wait)
 blk_status_t blk_execute_rq(struct request *rq, bool at_head)
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
-	unsigned long hang_check;
 
-	/*
-	 * iopoll requires request to be submitted to driver, so can't
-	 * use plug
-	 */
+	WARN_ON(irqs_disabled());
+	WARN_ON(!blk_rq_is_passthrough(rq));
+
 	rq->end_io_data = &wait;
-	__blk_execute_rq_nowait(rq, at_head, blk_end_sync_rq,
-			!blk_rq_is_poll(rq));
+	rq->end_io = blk_end_sync_rq;
 
-	/* Prevent hang_check timer from firing at us during very long I/O */
-	hang_check = sysctl_hung_task_timeout_secs;
+	blk_account_io_start(rq);
+	blk_mq_sched_insert_request(rq, at_head, true, false);
 
-	if (blk_rq_is_poll(rq))
+	if (blk_rq_is_poll(rq)) {
 		blk_rq_poll_completion(rq, &wait);
-	else if (hang_check)
-		while (!wait_for_completion_io_timeout(&wait,
-				hang_check * (HZ/2)))
-			;
-	else
-		wait_for_completion_io(&wait);
+	} else {
+		/*
+		 * Prevent hang_check timer from firing at us during very long
+		 * I/O
+		 */
+		unsigned long hang_check = 
+			sysctl_hung_task_timeout_secs;
+
+		if (hang_check)
+			while (!wait_for_completion_io_timeout(&wait,
+					hang_check * (HZ/2)))
+				;
+		else
+			wait_for_completion_io(&wait);
+	}
 
 	return (blk_status_t)(uintptr_t)rq->end_io_data;
 }
-- 
2.30.2

