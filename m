Return-Path: <SRS0=3mnS=DM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07714C47095
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 08:41:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA25220639
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 08:41:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iDnVfUOx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbgJEIlo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Oct 2020 04:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbgJEIlo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Oct 2020 04:41:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2188AC0613CE
        for <linux-scsi@vger.kernel.org>; Mon,  5 Oct 2020 01:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=HHLPkXMY4viflT0SxFHqtPiJJ1Bz2VRsjqiBDUVadII=; b=iDnVfUOxK0e0p1MFNSRX3I4xk1
        AxuR22FmmO5nrHVSFTxiNRjVrmepvA/SLDiMSurULWEW5ZemSkzHRXcAkFCpKq2aLCzrisd+CKiL1
        l1/wDBAAf4mJqjSQgRm73JYQOyM20PCpaLiww9pwkuztxBzWWotc3lZp7AZp6uH5FI95gKoNyanlD
        To0wjFzj+/5FGV0A/fWF83vuXJnRG7M5/XlhZzb5/beYKppVgJoLMQuYUKXIJYjUDT8otpVbdt8zW
        4FLme32j2xFDZ8uvl5En7nnlRt97VxtwdzMhV8lmnbBetlqfwTz/jWii0bB2V2dm7SBd3t2wXDiE0
        G2Ya69IA==;
Received: from [2001:4bb8:184:92a2:b8a4:f4a0:f053:4f06] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kPM3y-0000mp-9D; Mon, 05 Oct 2020 08:41:42 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
Subject: [PATCH 08/10] scsi: cleanup allocation and freeing of sgtables
Date:   Mon,  5 Oct 2020 10:41:28 +0200
Message-Id: <20201005084130.143273-9-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005084130.143273-1-hch@lst.de>
References: <20201005084130.143273-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rename scsi_init_io to scsi_alloc_sgtables, and ensure callers call
scsi_free_sgtables to cleanup failures close to scsi_init_io instead
of leaking it down the generic I/O submission path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c  | 22 ++++++++--------------
 drivers/scsi/sd.c        | 27 +++++++++++++++------------
 drivers/scsi/sr.c        | 16 ++++++----------
 include/scsi/scsi_cmnd.h |  3 ++-
 4 files changed, 31 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8420e42d618bb0..c65ecb99c6994b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -515,7 +515,7 @@ static void scsi_uninit_cmd(struct scsi_cmnd *cmd)
 	}
 }
 
-static void scsi_free_sgtables(struct scsi_cmnd *cmd)
+void scsi_free_sgtables(struct scsi_cmnd *cmd)
 {
 	if (cmd->sdb.table.nents)
 		sg_free_table_chained(&cmd->sdb.table,
@@ -524,6 +524,7 @@ static void scsi_free_sgtables(struct scsi_cmnd *cmd)
 		sg_free_table_chained(&cmd->prot_sdb->table,
 				SCSI_INLINE_PROT_SG_CNT);
 }
+EXPORT_SYMBOL_GPL(scsi_free_sgtables);
 
 static void scsi_mq_uninit_cmd(struct scsi_cmnd *cmd)
 {
@@ -968,7 +969,7 @@ static inline bool scsi_cmd_needs_dma_drain(struct scsi_device *sdev,
 }
 
 /**
- * scsi_init_io - SCSI I/O initialization function.
+ * scsi_alloc_sgtables - allocate S/G tables for a command
  * @cmd:  command descriptor we wish to initialize
  *
  * Returns:
@@ -976,7 +977,7 @@ static inline bool scsi_cmd_needs_dma_drain(struct scsi_device *sdev,
  * * BLK_STS_RESOURCE - if the failure is retryable
  * * BLK_STS_IOERR    - if the failure is fatal
  */
-blk_status_t scsi_init_io(struct scsi_cmnd *cmd)
+blk_status_t scsi_alloc_sgtables(struct scsi_cmnd *cmd)
 {
 	struct scsi_device *sdev = cmd->device;
 	struct request *rq = cmd->request;
@@ -1068,7 +1069,7 @@ blk_status_t scsi_init_io(struct scsi_cmnd *cmd)
 	scsi_free_sgtables(cmd);
 	return ret;
 }
-EXPORT_SYMBOL(scsi_init_io);
+EXPORT_SYMBOL(scsi_alloc_sgtables);
 
 /**
  * scsi_initialize_rq - initialize struct scsi_cmnd partially
@@ -1156,7 +1157,7 @@ static blk_status_t scsi_setup_scsi_cmnd(struct scsi_device *sdev,
 	 * submit a request without an attached bio.
 	 */
 	if (req->bio) {
-		blk_status_t ret = scsi_init_io(cmd);
+		blk_status_t ret = scsi_alloc_sgtables(cmd);
 		if (unlikely(ret != BLK_STS_OK))
 			return ret;
 	} else {
@@ -1198,19 +1199,12 @@ static blk_status_t scsi_setup_cmnd(struct scsi_device *sdev,
 		struct request *req)
 {
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
-	blk_status_t ret;
 
 	cmd->sc_data_direction = rq_dma_dir(req);
 
 	if (blk_rq_is_scsi(req))
-		ret = scsi_setup_scsi_cmnd(sdev, req);
-	else
-		ret = scsi_setup_fs_cmnd(sdev, req);
-
-	if (ret != BLK_STS_OK)
-		scsi_free_sgtables(cmd);
-
-	return ret;
+		return scsi_setup_scsi_cmnd(sdev, req);
+	return scsi_setup_fs_cmnd(sdev, req);
 }
 
 static blk_status_t
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 95018e650f2d0c..b29f4cbb4ee076 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -866,7 +866,7 @@ static blk_status_t sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
 	cmd->transfersize = data_len;
 	rq->timeout = SD_TIMEOUT;
 
-	return scsi_init_io(cmd);
+	return scsi_alloc_sgtables(cmd);
 }
 
 static blk_status_t sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd,
@@ -897,7 +897,7 @@ static blk_status_t sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd,
 	cmd->transfersize = data_len;
 	rq->timeout = unmap ? SD_TIMEOUT : SD_WRITE_SAME_TIMEOUT;
 
-	return scsi_init_io(cmd);
+	return scsi_alloc_sgtables(cmd);
 }
 
 static blk_status_t sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd,
@@ -928,7 +928,7 @@ static blk_status_t sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd,
 	cmd->transfersize = data_len;
 	rq->timeout = unmap ? SD_TIMEOUT : SD_WRITE_SAME_TIMEOUT;
 
-	return scsi_init_io(cmd);
+	return scsi_alloc_sgtables(cmd);
 }
 
 static blk_status_t sd_setup_write_zeroes_cmnd(struct scsi_cmnd *cmd)
@@ -1069,7 +1069,7 @@ static blk_status_t sd_setup_write_same_cmnd(struct scsi_cmnd *cmd)
 	 * knows how much to actually write.
 	 */
 	rq->__data_len = sdp->sector_size;
-	ret = scsi_init_io(cmd);
+	ret = scsi_alloc_sgtables(cmd);
 	rq->__data_len = blk_rq_bytes(rq);
 
 	return ret;
@@ -1187,23 +1187,24 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 	unsigned int dif;
 	bool dix;
 
-	ret = scsi_init_io(cmd);
+	ret = scsi_alloc_sgtables(cmd);
 	if (ret != BLK_STS_OK)
 		return ret;
 
+	ret = BLK_STS_IOERR;
 	if (!scsi_device_online(sdp) || sdp->changed) {
 		scmd_printk(KERN_ERR, cmd, "device offline or changed\n");
-		return BLK_STS_IOERR;
+		goto fail;
 	}
 
 	if (blk_rq_pos(rq) + blk_rq_sectors(rq) > get_capacity(rq->rq_disk)) {
 		scmd_printk(KERN_ERR, cmd, "access beyond end of device\n");
-		return BLK_STS_IOERR;
+		goto fail;
 	}
 
 	if ((blk_rq_pos(rq) & mask) || (blk_rq_sectors(rq) & mask)) {
 		scmd_printk(KERN_ERR, cmd, "request not aligned to the logical block size\n");
-		return BLK_STS_IOERR;
+		goto fail;
 	}
 
 	/*
@@ -1225,7 +1226,7 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 	if (req_op(rq) == REQ_OP_ZONE_APPEND) {
 		ret = sd_zbc_prepare_zone_append(cmd, &lba, nr_blocks);
 		if (ret)
-			return ret;
+			goto fail;
 	}
 
 	fua = rq->cmd_flags & REQ_FUA ? 0x8 : 0;
@@ -1253,7 +1254,7 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 	}
 
 	if (unlikely(ret != BLK_STS_OK))
-		return ret;
+		goto fail;
 
 	/*
 	 * We shouldn't disconnect in the middle of a sector, so with a dumb
@@ -1277,10 +1278,12 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 				     blk_rq_sectors(rq)));
 
 	/*
-	 * This indicates that the command is ready from our end to be
-	 * queued.
+	 * This indicates that the command is ready from our end to be queued.
 	 */
 	return BLK_STS_OK;
+fail:
+	scsi_free_sgtables(cmd);
+	return ret;
 }
 
 static blk_status_t sd_init_command(struct scsi_cmnd *cmd)
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 0c4aa4665a2f9d..b74dfd8dc1165e 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -392,15 +392,11 @@ static blk_status_t sr_init_command(struct scsi_cmnd *SCpnt)
 	struct request *rq = SCpnt->request;
 	blk_status_t ret;
 
-	ret = scsi_init_io(SCpnt);
+	ret = scsi_alloc_sgtables(SCpnt);
 	if (ret != BLK_STS_OK)
-		goto out;
+		return ret;
 	cd = scsi_cd(rq->rq_disk);
 
-	/* from here on until we're complete, any goto out
-	 * is used for a killable error condition */
-	ret = BLK_STS_IOERR;
-
 	SCSI_LOG_HLQUEUE(1, scmd_printk(KERN_INFO, SCpnt,
 		"Doing sr request, block = %d\n", block));
 
@@ -509,12 +505,12 @@ static blk_status_t sr_init_command(struct scsi_cmnd *SCpnt)
 	SCpnt->allowed = MAX_RETRIES;
 
 	/*
-	 * This indicates that the command is ready from our end to be
-	 * queued.
+	 * This indicates that the command is ready from our end to be queued.
 	 */
-	ret = BLK_STS_OK;
+	return BLK_STS_OK;
  out:
-	return ret;
+	scsi_free_sgtables(SCpnt);
+	return BLK_STS_IOERR;
 }
 
 static int sr_block_open(struct block_device *bdev, fmode_t mode)
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index e76bac4d14c51b..69ade4fb71aabf 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -165,7 +165,8 @@ extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
 				 size_t *offset, size_t *len);
 extern void scsi_kunmap_atomic_sg(void *virt);
 
-extern blk_status_t scsi_init_io(struct scsi_cmnd *cmd);
+blk_status_t scsi_alloc_sgtables(struct scsi_cmnd *cmd);
+void scsi_free_sgtables(struct scsi_cmnd *cmd);
 
 #ifdef CONFIG_SCSI_DMA
 extern int scsi_dma_map(struct scsi_cmnd *cmd);
-- 
2.28.0

