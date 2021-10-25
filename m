Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69C41C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 07:05:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DEE560F6F
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 07:05:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbhJYHIC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Oct 2021 03:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbhJYHH6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Oct 2021 03:07:58 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F0C2C061348;
        Mon, 25 Oct 2021 00:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=920eAB44r4C3P+KgIpEQrpO8dXd4hWTvLyvWctKLoAk=; b=QOyyLWRrBIqFeOMflXGg4f+yCA
        EhBILcRI5Kb7bucq9Xi8D3rZesngwZTleDMEvbb4aHD0afJMHw9XqlTP5osyNDGGwO2k+/No+RTCP
        8HL/E5ZJOjrt6vduJDpJZ8rxin01RnK3/5H0bPdYczMYyiK3iOSPK9wqLsiEmKJJkzEWgaue0vuWH
        c6i7neJA4Kpc2wASyL87v0vQCw61JrezPxKm0i4lI9nuIvQZWePXws6HC8DIit0AiiXcv5X20vA7h
        WLFfIoSinjKwU50S2ZcbqjK6ChgeqD/Iv0AIp2+hZoDHxAzfJdPmCLDDihTIfAvlPSJb4mJhLSNUi
        G9YVYOog==;
Received: from [2001:4bb8:184:6dcb:6093:467a:cccc:351c] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1meu32-00FUSR-6T; Mon, 25 Oct 2021 07:05:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mtd@lists.infradead.org
Subject: [PATCH 05/12] blk-mq: move blk_mq_flush_plug_list
Date:   Mon, 25 Oct 2021 09:05:10 +0200
Message-Id: <20211025070517.1548584-6-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211025070517.1548584-1-hch@lst.de>
References: <20211025070517.1548584-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
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
index d8f17b54e2c73..f46d41a760106 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2277,98 +2277,6 @@ static void blk_mq_commit_rqs(struct blk_mq_hw_ctx *hctx, int *queued,
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
-	if (!plug->multiple_queues && !plug->has_elevator) {
-		blk_mq_plug_issue_direct(plug, from_schedule);
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
@@ -2508,6 +2416,98 @@ blk_status_t blk_mq_request_issue_directly(struct request *rq, bool last)
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
+	if (!plug->multiple_queues && !plug->has_elevator) {
+		blk_mq_plug_issue_direct(plug, from_schedule);
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

