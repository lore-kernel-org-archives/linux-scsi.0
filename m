Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA4DBC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 06:14:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4E2861B66
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 06:14:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233561AbhKQGR1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Nov 2021 01:17:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233524AbhKQGRW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2021 01:17:22 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1CDC061746;
        Tue, 16 Nov 2021 22:14:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=YsVADdvySqvor3UK21cvT33w97NZxYXDkS3ex6r86iI=; b=nYaz/QtfTEsCoimgiVeMSnR0a3
        bjCAdWiszNJ8oMHq6AbygQXk6w31+50+LS1945gYguXMa004V4s3rIVlTfEzEHFceh+FCKmw0f5Yi
        U51HtmnUDzX3QWk99YWczAf8dYie0DZ+7xDm1I02g0ADyzgp5NLhCMaq7uimHALZT4/xSqvk3gKP9
        gfEiZJQ8OhSjUh1eZtnFjOrHtTb7hczAsVcdkkTmDk8zy7MPEX9jOl0jg7NMN9HcYCp2ryfKANwtF
        +gxJOKZR6RBJ/P3x6cWi/xFDRGzwxlXT9hGY9R5poco7LObpxki51UWPHUSB/m5MOPxcdx5Nynj+l
        igqlBEfw==;
Received: from 213-225-5-109.nat.highway.a1.net ([213.225.5.109] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mnED4-007MGI-Hw; Wed, 17 Nov 2021 06:14:19 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mtd@lists.infradead.org
Subject: [PATCH 08/11] block: move blk_account_io_{start,done} to blk-mq.c
Date:   Wed, 17 Nov 2021 07:14:01 +0100
Message-Id: <20211117061404.331732-9-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211117061404.331732-1-hch@lst.de>
References: <20211117061404.331732-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These are only used for request based I/O, so move them where they are
used.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c | 27 +--------------------------
 block/blk-mq.c   | 42 ++++++++++++++++++++++++++++++++++++++++++
 block/blk.h      | 21 +--------------------
 3 files changed, 44 insertions(+), 46 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 723a8c84aef12..60cc44418ce79 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1061,8 +1061,7 @@ int iocb_bio_iopoll(struct kiocb *kiocb, struct io_comp_batch *iob,
 }
 EXPORT_SYMBOL_GPL(iocb_bio_iopoll);
 
-static void update_io_ticks(struct block_device *part, unsigned long now,
-		bool end)
+void update_io_ticks(struct block_device *part, unsigned long now, bool end)
 {
 	unsigned long stamp;
 again:
@@ -1077,30 +1076,6 @@ static void update_io_ticks(struct block_device *part, unsigned long now,
 	}
 }
 
-void __blk_account_io_done(struct request *req, u64 now)
-{
-	const int sgrp = op_stat_group(req_op(req));
-
-	part_stat_lock();
-	update_io_ticks(req->part, jiffies, true);
-	part_stat_inc(req->part, ios[sgrp]);
-	part_stat_add(req->part, nsecs[sgrp], now - req->start_time_ns);
-	part_stat_unlock();
-}
-
-void __blk_account_io_start(struct request *rq)
-{
-	/* passthrough requests can hold bios that do not have ->bi_bdev set */
-	if (rq->bio && rq->bio->bi_bdev)
-		rq->part = rq->bio->bi_bdev;
-	else
-		rq->part = rq->rq_disk->part0;
-
-	part_stat_lock();
-	update_io_ticks(rq->part, jiffies, false);
-	part_stat_unlock();
-}
-
 static unsigned long __part_start_io_acct(struct block_device *part,
 					  unsigned int sectors, unsigned int op)
 {
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 300fa393e6445..8b7edfc9623dd 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -809,6 +809,48 @@ bool blk_update_request(struct request *req, blk_status_t error,
 }
 EXPORT_SYMBOL_GPL(blk_update_request);
 
+static void __blk_account_io_done(struct request *req, u64 now)
+{
+	const int sgrp = op_stat_group(req_op(req));
+
+	part_stat_lock();
+	update_io_ticks(req->part, jiffies, true);
+	part_stat_inc(req->part, ios[sgrp]);
+	part_stat_add(req->part, nsecs[sgrp], now - req->start_time_ns);
+	part_stat_unlock();
+}
+
+static inline void blk_account_io_done(struct request *req, u64 now)
+{
+	/*
+	 * Account IO completion.  flush_rq isn't accounted as a
+	 * normal IO on queueing nor completion.  Accounting the
+	 * containing request is enough.
+	 */
+	if (blk_do_io_stat(req) && req->part &&
+	    !(req->rq_flags & RQF_FLUSH_SEQ))
+		__blk_account_io_done(req, now);
+}
+
+static void __blk_account_io_start(struct request *rq)
+{
+	/* passthrough requests can hold bios that do not have ->bi_bdev set */
+	if (rq->bio && rq->bio->bi_bdev)
+		rq->part = rq->bio->bi_bdev;
+	else
+		rq->part = rq->rq_disk->part0;
+
+	part_stat_lock();
+	update_io_ticks(rq->part, jiffies, false);
+	part_stat_unlock();
+}
+
+static inline void blk_account_io_start(struct request *req)
+{
+	if (blk_do_io_stat(req))
+		__blk_account_io_start(req);
+}
+
 static inline void __blk_mq_end_request_acct(struct request *rq, u64 now)
 {
 	if (rq->rq_flags & RQF_STATS) {
diff --git a/block/blk.h b/block/blk.h
index 1bac4063afffb..a1cbf17d18b98 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -257,9 +257,6 @@ bool blk_attempt_plug_merge(struct request_queue *q, struct bio *bio,
 bool blk_bio_list_merge(struct request_queue *q, struct list_head *list,
 			struct bio *bio, unsigned int nr_segs);
 
-void __blk_account_io_start(struct request *req);
-void __blk_account_io_done(struct request *req, u64 now);
-
 /*
  * Plug flush limits
  */
@@ -350,23 +347,7 @@ static inline bool blk_do_io_stat(struct request *rq)
 	return (rq->rq_flags & RQF_IO_STAT) && rq->rq_disk;
 }
 
-static inline void blk_account_io_done(struct request *req, u64 now)
-{
-	/*
-	 * Account IO completion.  flush_rq isn't accounted as a
-	 * normal IO on queueing nor completion.  Accounting the
-	 * containing request is enough.
-	 */
-	if (blk_do_io_stat(req) && req->part &&
-	    !(req->rq_flags & RQF_FLUSH_SEQ))
-		__blk_account_io_done(req, now);
-}
-
-static inline void blk_account_io_start(struct request *req)
-{
-	if (blk_do_io_stat(req))
-		__blk_account_io_start(req);
-}
+void update_io_ticks(struct block_device *part, unsigned long now, bool end);
 
 static inline void req_set_nomerge(struct request_queue *q, struct request *req)
 {
-- 
2.30.2

