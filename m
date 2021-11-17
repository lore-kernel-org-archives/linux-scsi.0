Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CC85C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 06:14:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1093561B66
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 06:14:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbhKQGRU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Nov 2021 01:17:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbhKQGRT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2021 01:17:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89416C061764;
        Tue, 16 Nov 2021 22:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=HhvXg+t7CvF5Dfw/VnDXlrbf8FkqH0fuHrNXW8+Oqr8=; b=FxS3D+VuBXJ/jOvsk0iJE5Cggq
        hkKiK142RJlaFO/l+aubED/UoDKZ2kPpK50OfE/MBdMUVjohYmcQl/FLgv6arNchvlJYlich92nGL
        DQi29H+smSKkz4WVGjnDOrCMpUwFv8bIvih9K8kD0ss+w09bhp5wfVIrcsBzr9DvLcg5DpdN8NW5T
        WuPgmkStUGBbSh8N25NgtYprZf7dwMe411c8dnN9CRXd/uFOZ5SCt7+Tid7NzcghzZ5ZYP+Cwtx8g
        Y0jeZxrwQZyj+SFX2CVshrV8phri0oFthR//YoF0ntBvqKx29EhpqMqSEeuCpgpc00FBWnA45H4S4
        1TW0pTqQ==;
Received: from 213-225-5-109.nat.highway.a1.net ([213.225.5.109] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mnECt-007MEP-8v; Wed, 17 Nov 2021 06:14:08 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mtd@lists.infradead.org
Subject: [PATCH 01/11] block: move blk_rq_err_bytes to scsi
Date:   Wed, 17 Nov 2021 07:13:54 +0100
Message-Id: <20211117061404.331732-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211117061404.331732-1-hch@lst.de>
References: <20211117061404.331732-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

blk_rq_err_bytes is only used by the scsi midlayer, so move it there.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c        | 41 ----------------------------------------
 drivers/scsi/scsi_lib.c | 42 ++++++++++++++++++++++++++++++++++++++++-
 include/linux/blk-mq.h  |  3 ---
 3 files changed, 41 insertions(+), 45 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 9ee32f85d74e1..e27a659973965 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1173,47 +1173,6 @@ blk_status_t blk_insert_cloned_request(struct request_queue *q, struct request *
 }
 EXPORT_SYMBOL_GPL(blk_insert_cloned_request);
 
-/**
- * blk_rq_err_bytes - determine number of bytes till the next failure boundary
- * @rq: request to examine
- *
- * Description:
- *     A request could be merge of IOs which require different failure
- *     handling.  This function determines the number of bytes which
- *     can be failed from the beginning of the request without
- *     crossing into area which need to be retried further.
- *
- * Return:
- *     The number of bytes to fail.
- */
-unsigned int blk_rq_err_bytes(const struct request *rq)
-{
-	unsigned int ff = rq->cmd_flags & REQ_FAILFAST_MASK;
-	unsigned int bytes = 0;
-	struct bio *bio;
-
-	if (!(rq->rq_flags & RQF_MIXED_MERGE))
-		return blk_rq_bytes(rq);
-
-	/*
-	 * Currently the only 'mixing' which can happen is between
-	 * different fastfail types.  We can safely fail portions
-	 * which have all the failfast bits that the first one has -
-	 * the ones which are at least as eager to fail as the first
-	 * one.
-	 */
-	for (bio = rq->bio; bio; bio = bio->bi_next) {
-		if ((bio->bi_opf & ff) != ff)
-			break;
-		bytes += bio->bi_iter.bi_size;
-	}
-
-	/* this could lead to infinite loop */
-	BUG_ON(blk_rq_bytes(rq) && !bytes);
-	return bytes;
-}
-EXPORT_SYMBOL_GPL(blk_rq_err_bytes);
-
 static void update_io_ticks(struct block_device *part, unsigned long now,
 		bool end)
 {
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 621d841d819a3..5e8b5ecb3245a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -617,6 +617,46 @@ static blk_status_t scsi_result_to_blk_status(struct scsi_cmnd *cmd, int result)
 	}
 }
 
+/**
+ * scsi_rq_err_bytes - determine number of bytes till the next failure boundary
+ * @rq: request to examine
+ *
+ * Description:
+ *     A request could be merge of IOs which require different failure
+ *     handling.  This function determines the number of bytes which
+ *     can be failed from the beginning of the request without
+ *     crossing into area which need to be retried further.
+ *
+ * Return:
+ *     The number of bytes to fail.
+ */
+static unsigned int scsi_rq_err_bytes(const struct request *rq)
+{
+	unsigned int ff = rq->cmd_flags & REQ_FAILFAST_MASK;
+	unsigned int bytes = 0;
+	struct bio *bio;
+
+	if (!(rq->rq_flags & RQF_MIXED_MERGE))
+		return blk_rq_bytes(rq);
+
+	/*
+	 * Currently the only 'mixing' which can happen is between
+	 * different fastfail types.  We can safely fail portions
+	 * which have all the failfast bits that the first one has -
+	 * the ones which are at least as eager to fail as the first
+	 * one.
+	 */
+	for (bio = rq->bio; bio; bio = bio->bi_next) {
+		if ((bio->bi_opf & ff) != ff)
+			break;
+		bytes += bio->bi_iter.bi_size;
+	}
+
+	/* this could lead to infinite loop */
+	BUG_ON(blk_rq_bytes(rq) && !bytes);
+	return bytes;
+}
+
 /* Helper for scsi_io_completion() when "reprep" action required. */
 static void scsi_io_completion_reprep(struct scsi_cmnd *cmd,
 				      struct request_queue *q)
@@ -794,7 +834,7 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 				scsi_print_command(cmd);
 			}
 		}
-		if (!scsi_end_request(req, blk_stat, blk_rq_err_bytes(req)))
+		if (!scsi_end_request(req, blk_stat, scsi_rq_err_bytes(req)))
 			return;
 		fallthrough;
 	case ACTION_REPREP:
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 2949d9ac74849..a78d9a0f2a1be 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -947,7 +947,6 @@ struct req_iterator {
  * blk_rq_pos()			: the current sector
  * blk_rq_bytes()		: bytes left in the entire request
  * blk_rq_cur_bytes()		: bytes left in the current segment
- * blk_rq_err_bytes()		: bytes left till the next error boundary
  * blk_rq_sectors()		: sectors left in the entire request
  * blk_rq_cur_sectors()		: sectors left in the current segment
  * blk_rq_stats_sectors()	: sectors of the entire request used for stats
@@ -971,8 +970,6 @@ static inline int blk_rq_cur_bytes(const struct request *rq)
 	return bio_iovec(rq->bio).bv_len;
 }
 
-unsigned int blk_rq_err_bytes(const struct request *rq);
-
 static inline unsigned int blk_rq_sectors(const struct request *rq)
 {
 	return blk_rq_bytes(rq) >> SECTOR_SHIFT;
-- 
2.30.2

