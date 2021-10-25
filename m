Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9477EC43219
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 07:05:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82C7261029
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 07:05:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbhJYHIQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Oct 2021 03:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbhJYHIO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Oct 2021 03:08:14 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438AEC061745;
        Mon, 25 Oct 2021 00:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=RKpWrcdhkZNafj/o42ywxkrCiZkvQQDXtzZqKsRXrpQ=; b=XJ+eE0tMalElwGfpOuz0RneYrF
        aMOtXyqMqaeFwvqOiSt6GMDYu1lSxbvwBigyjA4kfEUFi2tPJMmqntVFjvc4dt1gW4LO61zlf+5YF
        71VlJetDv1n52y+gO4RsLmJah1IBMQku+VnRqE4Cg3FklcBZQpQMYYXfNXMalO55w8+SEyDvAVgGH
        GgWTGqOu/yTpGl6ky5+dlXtMCkEInmZHlfvfOi4WZ/YGUgbAF1xkI2KFj4YeJThuE098KHyNw6DVz
        po6S+5UFU9/9J7KANK4ntCwmBmaZBkeT7yAdjGyp+cyB0NkWgtFKmwBUjf/dKkPE1y4kwlag7gwja
        Yff6IigQ==;
Received: from [2001:4bb8:184:6dcb:6093:467a:cccc:351c] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1meu3H-00FUZl-UG; Mon, 25 Oct 2021 07:05:48 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mtd@lists.infradead.org
Subject: [PATCH 11/12] block: move blk_print_req_error to blk-mq.c
Date:   Mon, 25 Oct 2021 09:05:16 +0200
Message-Id: <20211025070517.1548584-12-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211025070517.1548584-1-hch@lst.de>
References: <20211025070517.1548584-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
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
index 9547a75e7a7aa..ebcea0dac973d 100644
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
index 425cd134ac358..3edd4ee2007b0 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -698,6 +698,19 @@ static void blk_account_io_completion(struct request *req, unsigned int bytes)
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
index 8bcca0538faac..573e308851d27 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -215,7 +215,7 @@ static inline void blk_integrity_del(struct gendisk *disk)
 
 unsigned long blk_rq_timeout(unsigned long timeout);
 void blk_add_timer(struct request *req);
-void blk_print_req_error(struct request *req, blk_status_t status);
+const char *blk_status_to_str(blk_status_t status);
 
 bool blk_attempt_plug_merge(struct request_queue *q, struct bio *bio,
 		unsigned int nr_segs, bool *same_queue_rq);
-- 
2.30.2

