Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7976C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 24 May 2022 12:15:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237272AbiEXMPl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 May 2022 08:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237265AbiEXMPj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2022 08:15:39 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C24B26F492;
        Tue, 24 May 2022 05:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=yCHyDn6f0zT3UcsDszcvQe5hB0K4/MVhkceMeYt1MdY=; b=qUsDXZRBls6kBzJ3e8hR3KuMz+
        DZ6u3vbkyeL4WUpuxvebUauQgMV90nxnE6Ud/hGA18s3/Dsrn4TNBTAWiQC1X92zD+duSv+tE4AGy
        GRHmXU96FRp+7sN6Sp78+jnUNF0enAyL4UOlYBPd+YA5oS7WtYFJqNIU5SNNCx03Hese0TFBWRaUQ
        nt0/p86ZNjxFTfVAbECv+AVSeoQ/lgvYYvCT0eYxF0rzMZCQKEjLUHTlvwiAq0gPXEk4JW1v0iZz0
        K3LJ/aI92n/lm+PfYLbA18Ew8hqxLOGfLTtxd1NFrenM8aBn2LepWw2QbpbQabfeB2e+M7TUuwxmq
        YqHT2ZdQ==;
Received: from [2001:4bb8:18c:7298:91b6:63de:2998:b8b2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ntTRp-007wb8-7E; Tue, 24 May 2022 12:15:37 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, Keith Busch <kbusch@kernel.org>
Subject: [PATCH 2/3] blk-mq: avoid a mess of casts for blk_end_sync_rq
Date:   Tue, 24 May 2022 14:15:29 +0200
Message-Id: <20220524121530.943123-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220524121530.943123-1-hch@lst.de>
References: <20220524121530.943123-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of trying to cast a __bitwise 32-bit integer to a larger integer
and then a pointer, just allow a struct with the blk_status_t and the
completion on stack and set the end_io_data to that.  Use the
opportunity to move the code to where it belongs and drop rather
confusing comments.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
---
 block/blk-mq.c | 43 ++++++++++++++++++++-----------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 31a89d1004b8f..28b3e6db98499 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1151,24 +1151,6 @@ void blk_mq_start_request(struct request *rq)
 }
 EXPORT_SYMBOL(blk_mq_start_request);
 
-/**
- * blk_end_sync_rq - executes a completion event on a request
- * @rq: request to complete
- * @error: end I/O status of the request
- */
-static void blk_end_sync_rq(struct request *rq, blk_status_t error)
-{
-	struct completion *waiting = rq->end_io_data;
-
-	rq->end_io_data = (void *)(uintptr_t)error;
-
-	/*
-	 * complete last, if this is a stack request the process (and thus
-	 * the rq pointer) could be invalid right after this complete()
-	 */
-	complete(waiting);
-}
-
 /*
  * Allow 2x BLK_MAX_REQUEST_COUNT requests on plug queue for multiple
  * queues. This is important for md arrays to benefit from merging
@@ -1231,6 +1213,19 @@ void blk_execute_rq_nowait(struct request *rq, bool at_head, rq_end_io_fn *done)
 }
 EXPORT_SYMBOL_GPL(blk_execute_rq_nowait);
 
+struct blk_rq_wait {
+	struct completion done;
+	blk_status_t ret;
+};
+
+static void blk_end_sync_rq(struct request *rq, blk_status_t ret)
+{
+	struct blk_rq_wait *wait = rq->end_io_data;
+
+	wait->ret = ret;
+	complete(&wait->done);
+}
+
 static bool blk_rq_is_poll(struct request *rq)
 {
 	if (!rq->mq_hctx)
@@ -1262,7 +1257,9 @@ static void blk_rq_poll_completion(struct request *rq, struct completion *wait)
  */
 blk_status_t blk_execute_rq(struct request *rq, bool at_head)
 {
-	DECLARE_COMPLETION_ONSTACK(wait);
+	struct blk_rq_wait wait = {
+		.done = COMPLETION_INITIALIZER_ONSTACK(wait.done),
+	};
 
 	WARN_ON(irqs_disabled());
 	WARN_ON(!blk_rq_is_passthrough(rq));
@@ -1274,7 +1271,7 @@ blk_status_t blk_execute_rq(struct request *rq, bool at_head)
 	blk_mq_sched_insert_request(rq, at_head, true, false);
 
 	if (blk_rq_is_poll(rq)) {
-		blk_rq_poll_completion(rq, &wait);
+		blk_rq_poll_completion(rq, &wait.done);
 	} else {
 		/*
 		 * Prevent hang_check timer from firing at us during very long
@@ -1283,14 +1280,14 @@ blk_status_t blk_execute_rq(struct request *rq, bool at_head)
 		unsigned long hang_check = sysctl_hung_task_timeout_secs;
 
 		if (hang_check)
-			while (!wait_for_completion_io_timeout(&wait,
+			while (!wait_for_completion_io_timeout(&wait.done,
 					hang_check * (HZ/2)))
 				;
 		else
-			wait_for_completion_io(&wait);
+			wait_for_completion_io(&wait.done);
 	}
 
-	return (blk_status_t)(uintptr_t)rq->end_io_data;
+	return wait.ret;
 }
 EXPORT_SYMBOL(blk_execute_rq);
 
-- 
2.30.2

