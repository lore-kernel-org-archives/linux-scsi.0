Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFD6CC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 06:14:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB8E662F90
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 06:14:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233523AbhKQGRW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Nov 2021 01:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232300AbhKQGRT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2021 01:17:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F7BC061767;
        Tue, 16 Nov 2021 22:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=B5W4T0FJ3gk7XDJbVOEv8wyaVixGSlICP7LZCQ2Vt60=; b=PpHW+4xxxLkPpXHIkvdTcUdodH
        FR8uxhRsUF0VS4H9e2LnN0wdH2kFZhESvE6U8eWCdWPewlEYA6OGHWjScPQThz5UxThEBhibJukDN
        bt2KOm1DNWJqFHlpbUd8sEOENuJWte281IFte1DHGsT42a8shsKW5I8CQ23nWKjS6Pd/PvQ/8yxbZ
        53XpGAdkhd8YakpmZzpanxl4+R4iz+/pK/1X495uod/s/w1tXwUwg7cS1WoyHKYSTDESs4RmC8gZo
        h86Xp0K/Sry0eai9BRh0CVTrGvIDmYKmxhhIz2p/Sz/1l82UC9zLTO6tkqt5LukzuQN4N1mF+dqdH
        Ot9ZerLw==;
Received: from 213-225-5-109.nat.highway.a1.net ([213.225.5.109] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mnECx-007MEp-TD; Wed, 17 Nov 2021 06:14:12 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mtd@lists.infradead.org
Subject: [PATCH 04/11] blk-mq: move blk_mq_flush_plug_list
Date:   Wed, 17 Nov 2021 07:13:57 +0100
Message-Id: <20211117061404.331732-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211117061404.331732-1-hch@lst.de>
References: <20211117061404.331732-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move blk_mq_flush_plug_list and blk_mq_plug_issue_direct down in blk-mq.c
to prepare for marking blk_mq_request_issue_directly static without the
need of a forward declaration.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c | 184 ++++++++++++++++++++++++-------------------------
 1 file changed, 92 insertions(+), 92 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index c33411f9ce898..d70a470c9c1f1 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2308,98 +2308,6 @@ static void blk_mq_commit_rqs(struct blk_mq_hw_ctx *hctx, int *queued,
 	*queued = 0;
 }
 
-static void blk_mq_plug_issue_direct(struct blk_plug *plug, bool from_schedule)
-{
-	struct blk_mq_hw_ctx *hctx = NULL;
-	struct request *rq;
-	int queued = 0;
-	int errors = 0;
-
-	while ((rq = rq_list_pop(&plug->mq_list))) {
-		bool last = rq_list_empty(plug->mq_list);
-		blk_status_t ret;
-
-		if (hctx != rq->mq_hctx) {
-			if (hctx)
-				blk_mq_commit_rqs(hctx, &queued, from_schedule);
-			hctx = rq->mq_hctx;
-		}
-
-		ret = blk_mq_request_issue_directly(rq, last);
-		switch (ret) {
-		case BLK_STS_OK:
-			queued++;
-			break;
-		case BLK_STS_RESOURCE:
-		case BLK_STS_DEV_RESOURCE:
-			blk_mq_request_bypass_insert(rq, false, last);
-			blk_mq_commit_rqs(hctx, &queued, from_schedule);
-			return;
-		default:
-			blk_mq_end_request(rq, ret);
-			errors++;
-			break;
-		}
-	}
-
-	/*
-	 * If we didn't flush the entire list, we could have told the driver
-	 * there was more coming, but that turned out to be a lie.
-	 */
-	if (errors)
-		blk_mq_commit_rqs(hctx, &queued, from_schedule);
-}
-
-void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
-{
-	struct blk_mq_hw_ctx *this_hctx;
-	struct blk_mq_ctx *this_ctx;
-	unsigned int depth;
-	LIST_HEAD(list);
-
-	if (rq_list_empty(plug->mq_list))
-		return;
-	plug->rq_count = 0;
-
-	if (!plug->multiple_queues && !plug->has_elevator && !from_schedule) {
-		blk_mq_plug_issue_direct(plug, false);
-		if (rq_list_empty(plug->mq_list))
-			return;
-	}
-
-	this_hctx = NULL;
-	this_ctx = NULL;
-	depth = 0;
-	do {
-		struct request *rq;
-
-		rq = rq_list_pop(&plug->mq_list);
-
-		if (!this_hctx) {
-			this_hctx = rq->mq_hctx;
-			this_ctx = rq->mq_ctx;
-		} else if (this_hctx != rq->mq_hctx || this_ctx != rq->mq_ctx) {
-			trace_block_unplug(this_hctx->queue, depth,
-						!from_schedule);
-			blk_mq_sched_insert_requests(this_hctx, this_ctx,
-						&list, from_schedule);
-			depth = 0;
-			this_hctx = rq->mq_hctx;
-			this_ctx = rq->mq_ctx;
-
-		}
-
-		list_add(&rq->queuelist, &list);
-		depth++;
-	} while (!rq_list_empty(plug->mq_list));
-
-	if (!list_empty(&list)) {
-		trace_block_unplug(this_hctx->queue, depth, !from_schedule);
-		blk_mq_sched_insert_requests(this_hctx, this_ctx, &list,
-						from_schedule);
-	}
-}
-
 static void blk_mq_bio_to_request(struct request *rq, struct bio *bio,
 		unsigned int nr_segs)
 {
@@ -2539,6 +2447,98 @@ blk_status_t blk_mq_request_issue_directly(struct request *rq, bool last)
 	return ret;
 }
 
+static void blk_mq_plug_issue_direct(struct blk_plug *plug, bool from_schedule)
+{
+	struct blk_mq_hw_ctx *hctx = NULL;
+	struct request *rq;
+	int queued = 0;
+	int errors = 0;
+
+	while ((rq = rq_list_pop(&plug->mq_list))) {
+		bool last = rq_list_empty(plug->mq_list);
+		blk_status_t ret;
+
+		if (hctx != rq->mq_hctx) {
+			if (hctx)
+				blk_mq_commit_rqs(hctx, &queued, from_schedule);
+			hctx = rq->mq_hctx;
+		}
+
+		ret = blk_mq_request_issue_directly(rq, last);
+		switch (ret) {
+		case BLK_STS_OK:
+			queued++;
+			break;
+		case BLK_STS_RESOURCE:
+		case BLK_STS_DEV_RESOURCE:
+			blk_mq_request_bypass_insert(rq, false, last);
+			blk_mq_commit_rqs(hctx, &queued, from_schedule);
+			return;
+		default:
+			blk_mq_end_request(rq, ret);
+			errors++;
+			break;
+		}
+	}
+
+	/*
+	 * If we didn't flush the entire list, we could have told the driver
+	 * there was more coming, but that turned out to be a lie.
+	 */
+	if (errors)
+		blk_mq_commit_rqs(hctx, &queued, from_schedule);
+}
+
+void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
+{
+	struct blk_mq_hw_ctx *this_hctx;
+	struct blk_mq_ctx *this_ctx;
+	unsigned int depth;
+	LIST_HEAD(list);
+
+	if (rq_list_empty(plug->mq_list))
+		return;
+	plug->rq_count = 0;
+
+	if (!plug->multiple_queues && !plug->has_elevator && !from_schedule) {
+		blk_mq_plug_issue_direct(plug, false);
+		if (rq_list_empty(plug->mq_list))
+			return;
+	}
+
+	this_hctx = NULL;
+	this_ctx = NULL;
+	depth = 0;
+	do {
+		struct request *rq;
+
+		rq = rq_list_pop(&plug->mq_list);
+
+		if (!this_hctx) {
+			this_hctx = rq->mq_hctx;
+			this_ctx = rq->mq_ctx;
+		} else if (this_hctx != rq->mq_hctx || this_ctx != rq->mq_ctx) {
+			trace_block_unplug(this_hctx->queue, depth,
+						!from_schedule);
+			blk_mq_sched_insert_requests(this_hctx, this_ctx,
+						&list, from_schedule);
+			depth = 0;
+			this_hctx = rq->mq_hctx;
+			this_ctx = rq->mq_ctx;
+
+		}
+
+		list_add(&rq->queuelist, &list);
+		depth++;
+	} while (!rq_list_empty(plug->mq_list));
+
+	if (!list_empty(&list)) {
+		trace_block_unplug(this_hctx->queue, depth, !from_schedule);
+		blk_mq_sched_insert_requests(this_hctx, this_ctx, &list,
+						from_schedule);
+	}
+}
+
 void blk_mq_try_issue_list_directly(struct blk_mq_hw_ctx *hctx,
 		struct list_head *list)
 {
-- 
2.30.2

