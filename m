Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95D0DC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 07:05:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 803E561002
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 07:05:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbhJYHHx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Oct 2021 03:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbhJYHHw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Oct 2021 03:07:52 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFF5C061764;
        Mon, 25 Oct 2021 00:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=mQ4RV+kl5HFBPPRUuufU/frBPWLaw14/dH5L1z+CoeQ=; b=XOsC6DuJ4kgdptkx24f/lSKTnV
        EitJjBmL419UWtJc9i07/ZuzEkEuklZplMUtwTKiOqLfOX4wEvz0ToCA8J8pq+tS5k4hYTF5usu47
        CHjT0DasW5vW6G9p+k+QswQxo88Q6FrobCWxnuTdY26Gjd7RDsVjk5c5obnl6M1FgixcQ9CWMulLJ
        xZtA7fG0ubuZyBt/MOBznNL7vsz1n+vM5ottIwzuzpdTmwC3U9JfpmN5XD8/zg+twcufyylDahXGJ
        5tGTIP72mSaFWOBZ8lMqbrPu8htnMjhFXI4fFmgB485Xl4xapDWwtJZmzaO3EoeJ8cJPKIlMp0ggK
        2ii3TTVQ==;
Received: from [2001:4bb8:184:6dcb:6093:467a:cccc:351c] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1meu2r-00FUOA-Lu; Mon, 25 Oct 2021 07:05:22 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mtd@lists.infradead.org
Subject: [PATCH 01/12] block: move blk_rq_err_bytes to scsi
Date:   Mon, 25 Oct 2021 09:05:06 +0200
Message-Id: <20211025070517.1548584-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211025070517.1548584-1-hch@lst.de>
References: <20211025070517.1548584-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
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
index 5ffe05b1d17ce..3edc5c5178dd6 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1221,47 +1221,6 @@ blk_status_t blk_insert_cloned_request(struct request_queue *q, struct request *
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
index 9823b65d15368..1f7e68699941f 100644
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
index ebc45cf0450b3..9f9634cd4cfd2 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -949,7 +949,6 @@ struct req_iterator {
  * blk_rq_pos()			: the current sector
  * blk_rq_bytes()		: bytes left in the entire request
  * blk_rq_cur_bytes()		: bytes left in the current segment
- * blk_rq_err_bytes()		: bytes left till the next error boundary
  * blk_rq_sectors()		: sectors left in the entire request
  * blk_rq_cur_sectors()		: sectors left in the current segment
  * blk_rq_stats_sectors()	: sectors of the entire request used for stats
@@ -973,8 +972,6 @@ static inline int blk_rq_cur_bytes(const struct request *rq)
 	return bio_iovec(rq->bio).bv_len;
 }
 
-unsigned int blk_rq_err_bytes(const struct request *rq);
-
 static inline unsigned int blk_rq_sectors(const struct request *rq)
 {
 	return blk_rq_bytes(rq) >> SECTOR_SHIFT;
-- 
2.30.2

