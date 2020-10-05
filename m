Return-Path: <SRS0=3mnS=DM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61B25C4363A
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 08:41:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D73220578
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 08:41:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Qr5ttj+S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgJEIlp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Oct 2020 04:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbgJEIlp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Oct 2020 04:41:45 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6105BC0613CE
        for <linux-scsi@vger.kernel.org>; Mon,  5 Oct 2020 01:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=HgrUTuTgW81PAafgziZ3ZRTQBuoILcBlvFrB07Hxu4w=; b=Qr5ttj+Sd9cABgjToA8k2LwD8W
        SNuqRh18u3ftMjeMxEvrZ5cqlj++4Y9btzC3ogkh8H3st+8YkbIu9Xa5F0GB3lvoxm24Qqrgc7BGI
        i1b7WZFvVtfLW2Hot7YHiju//XOO5n4aDqNTp4aM0wLIPhKnTPl/NVM1QBwbC21I1Fy3uChSJy+Bc
        TIzuu/fAb+RLtlrCFcbaSOr5cIEbeSqPKzywd1J1j1ScPty5YT0BGyUb+PjV4SVL+5GqhTkyh0Cb3
        EKYVfGimlnez1+HYiBqllRZHdDPH/sb+/K0XD3b/O1T8VZbPNTm2MljlaKVHw9T8KYZ+1iN7CDVT/
        r+ICViwg==;
Received: from [2001:4bb8:184:92a2:b8a4:f4a0:f053:4f06] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kPM3z-0000n4-OP; Mon, 05 Oct 2020 08:41:44 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
Subject: [PATCH 09/10] scsi: remove scsi_setup_cmnd and scsi_setup_fs_cmnd
Date:   Mon,  5 Oct 2020 10:41:29 +0200
Message-Id: <20201005084130.143273-10-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005084130.143273-1-hch@lst.de>
References: <20201005084130.143273-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move this trivial functionality into scsi_prepare_cmd instead of
splitting it over multiple small functions, and update the comments
to better document passthrough commands as the special case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c | 50 ++++++++++++++---------------------------
 1 file changed, 17 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c65ecb99c6994b..f7b88d8cf975d5 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1175,38 +1175,6 @@ static blk_status_t scsi_setup_scsi_cmnd(struct scsi_device *sdev,
 	return BLK_STS_OK;
 }
 
-/*
- * Setup a normal block command.  These are simple request from filesystems
- * that still need to be translated to SCSI CDBs from the ULD.
- */
-static blk_status_t scsi_setup_fs_cmnd(struct scsi_device *sdev,
-		struct request *req)
-{
-	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
-
-	if (unlikely(sdev->handler && sdev->handler->prep_fn)) {
-		blk_status_t ret = sdev->handler->prep_fn(sdev, req);
-		if (ret != BLK_STS_OK)
-			return ret;
-	}
-
-	cmd->cmnd = scsi_req(req)->cmd = scsi_req(req)->__cmd;
-	memset(cmd->cmnd, 0, BLK_MAX_CDB);
-	return scsi_cmd_to_driver(cmd)->init_command(cmd);
-}
-
-static blk_status_t scsi_setup_cmnd(struct scsi_device *sdev,
-		struct request *req)
-{
-	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
-
-	cmd->sc_data_direction = rq_dma_dir(req);
-
-	if (blk_rq_is_scsi(req))
-		return scsi_setup_scsi_cmnd(sdev, req);
-	return scsi_setup_fs_cmnd(sdev, req);
-}
-
 static blk_status_t
 scsi_device_state_check(struct scsi_device *sdev, struct request *req)
 {
@@ -1568,6 +1536,7 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
 	cmd->request = req;
 	cmd->tag = req->tag;
 	cmd->prot_op = SCSI_PROT_NORMAL;
+	cmd->sc_data_direction = rq_dma_dir(req);
 
 	sg = (void *)cmd + sizeof(struct scsi_cmnd) + shost->hostt->cmd_size;
 	cmd->sdb.table.sgl = sg;
@@ -1581,7 +1550,22 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
 
 	blk_mq_start_request(req);
 
-	return scsi_setup_cmnd(sdev, req);
+	/*
+	 * Special handling for passthrough commands, which don't go to the ULP
+	 * at all:
+	 */
+	if (blk_rq_is_scsi(req))
+		return scsi_setup_scsi_cmnd(sdev, req);
+
+	if (sdev->handler && sdev->handler->prep_fn) {
+		blk_status_t ret = sdev->handler->prep_fn(sdev, req);
+		if (ret != BLK_STS_OK)
+			return ret;
+	}
+
+	cmd->cmnd = scsi_req(req)->cmd = scsi_req(req)->__cmd;
+	memset(cmd->cmnd, 0, BLK_MAX_CDB);
+	return scsi_cmd_to_driver(cmd)->init_command(cmd);
 }
 
 static void scsi_mq_done(struct scsi_cmnd *cmd)
-- 
2.28.0

