Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B38C0C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 06:14:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0BA761BFE
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 06:14:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233553AbhKQGR2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Nov 2021 01:17:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233549AbhKQGRZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2021 01:17:25 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02BDC061746;
        Tue, 16 Nov 2021 22:14:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=ZokOpOCOOVArEBa9U6jFCgb/N+Jgswld+TuNUukB1Xw=; b=QkLvdG6MDjp9hn2CJkAmpoKZxc
        ySgsWoUOmSavCwQkV9lJtIHBA2KjQDfy/ODn5dbQeBwPiYnbNQBquPKpTVhSWDqz+OI3zGi1PpQsa
        7qXdXaRVUoDgXW1mxGw2gTU9NjO1ux2LUn6ryYIrWHSJSA5YhXvGTmKgTIXH9d+qRIYoaUuNDRkID
        vtdmvBsn/gFmEeeAE022krvuArHIzCbjmIbQDAhVGkr5nlL8I2TroEwc0aoIZYEaCN5KQSr01PwuC
        wTi7pXxYcyvQl+c6AlmQKlRqPXTwvwu5JVEWwdropRtDgMtnyuOd0KOZSm7sKHxC1+Iop5o7aJ2Jl
        w57hJOkg==;
Received: from 213-225-5-109.nat.highway.a1.net ([213.225.5.109] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mnED7-007MGw-Qg; Wed, 17 Nov 2021 06:14:22 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mtd@lists.infradead.org
Subject: [PATCH 10/11] block: move blk_print_req_error to blk-mq.c
Date:   Wed, 17 Nov 2021 07:14:03 +0100
Message-Id: <20211117061404.331732-11-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211117061404.331732-1-hch@lst.de>
References: <20211117061404.331732-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This function is only used by the request completion path.  Factor out
a blk_status_to_str to keep blk_errors private in blk-core.c.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c | 15 +++------------
 block/blk-mq.c   | 13 +++++++++++++
 block/blk.h      |  2 +-
 3 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 89971630f092f..5722c1d9da09c 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -199,22 +199,13 @@ int blk_status_to_errno(blk_status_t status)
 }
 EXPORT_SYMBOL_GPL(blk_status_to_errno);
 
-void blk_print_req_error(struct request *req, blk_status_t status)
+const char *blk_status_to_str(blk_status_t status)
 {
 	int idx = (__force int)status;
 
 	if (WARN_ON_ONCE(idx >= ARRAY_SIZE(blk_errors)))
-		return;
-
-	printk_ratelimited(KERN_ERR
-		"%s error, dev %s, sector %llu op 0x%x:(%s) flags 0x%x "
-		"phys_seg %u prio class %u\n",
-		blk_errors[idx].name,
-		req->rq_disk ? req->rq_disk->disk_name : "?",
-		blk_rq_pos(req), req_op(req), blk_op_str(req_op(req)),
-		req->cmd_flags & ~REQ_OP_MASK,
-		req->nr_phys_segments,
-		IOPRIO_PRIO_CLASS(req->ioprio));
+		return "<null>";
+	return blk_errors[idx].name;
 }
 
 /**
diff --git a/block/blk-mq.c b/block/blk-mq.c
index f8a39f4fce01e..1feb9ab65f28a 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -717,6 +717,19 @@ static void blk_account_io_completion(struct request *req, unsigned int bytes)
 	}
 }
 
+static void blk_print_req_error(struct request *req, blk_status_t status)
+{
+	printk_ratelimited(KERN_ERR
+		"%s error, dev %s, sector %llu op 0x%x:(%s) flags 0x%x "
+		"phys_seg %u prio class %u\n",
+		blk_status_to_str(status),
+		req->rq_disk ? req->rq_disk->disk_name : "?",
+		blk_rq_pos(req), req_op(req), blk_op_str(req_op(req)),
+		req->cmd_flags & ~REQ_OP_MASK,
+		req->nr_phys_segments,
+		IOPRIO_PRIO_CLASS(req->ioprio));
+}
+
 /**
  * blk_update_request - Complete multiple bytes without completing the request
  * @req:      the request being processed
diff --git a/block/blk.h b/block/blk.h
index a1cbf17d18b98..296e3010f8d65 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -250,7 +250,7 @@ static inline void blk_integrity_del(struct gendisk *disk)
 
 unsigned long blk_rq_timeout(unsigned long timeout);
 void blk_add_timer(struct request *req);
-void blk_print_req_error(struct request *req, blk_status_t status);
+const char *blk_status_to_str(blk_status_t status);
 
 bool blk_attempt_plug_merge(struct request_queue *q, struct bio *bio,
 		unsigned int nr_segs, bool *same_queue_rq);
-- 
2.30.2

