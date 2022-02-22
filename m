Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC1DEC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 14:05:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbiBVOFW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 09:05:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232621AbiBVOFT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 09:05:19 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80FFD15F0B7;
        Tue, 22 Feb 2022 06:04:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Avrg//JxLSwYTuHSUzz2IyuKEamxIoHran7EmqDFVDU=; b=n6CBsb6ZhOoIBfusKn2rASxkUl
        3DQaiOkXSykHVB7Js3KmAc39/H0EghSFOaP3tuXSssxfJ9PgdePCBpN+YQqUJUA90oCja8UD+MVZf
        Cw09UofdCldIO/tQtnLgSm3LEidD8b37jvOskLv+NyM9gaxekaxf8o7In1qtdKo24XvL3ZoKaWKLA
        XGv7LJtadKXjJFeghv1ZEveFbFwRr0BqwO6+8iFYya8WJRvEL1Fjs0vHqR42OgMjNiFXlRM8UKRkf
        alxVBWrM6Q1nRxWhOcHCY77huPG3l3ctKk5tnJAAcDWv2O/EDGuuBRLih5skyh5ucEtnTBX6+n6op
        JQ6J9DBw==;
Received: from [2001:4bb8:198:f8fc:c22a:ebfc:be8d:63c2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nMVmf-009nQy-Og; Tue, 22 Feb 2022 14:04:54 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH 3/8] scsi: don't memset the entire scsi_cmnd in scsi_init_command
Date:   Tue, 22 Feb 2022 15:04:38 +0100
Message-Id: <20220222140443.589882-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220222140443.589882-1-hch@lst.de>
References: <20220222140443.589882-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace the big fat memset that requires saving and restoring various
fields with just initializing those fields that need initialization.

All the clearing to 0 ismoved to scsi_prepare_cmd as scsi_ioctl_reset
alreadly uses kzalloc to allocate a pre-zeroed command.

This is still conservative and can probably be optimizated further.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c | 61 ++++++++++++++++++++---------------------
 1 file changed, 29 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a1c18ba5e8d38..960795d469d8c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1163,45 +1163,17 @@ static void scsi_cleanup_rq(struct request *rq)
 /* Called before a request is prepared. See also scsi_mq_prep_fn(). */
 void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
 {
-	void *buf = cmd->sense_buffer;
-	void *prot = cmd->prot_sdb;
 	struct request *rq = scsi_cmd_to_rq(cmd);
-	unsigned int flags = cmd->flags & SCMD_PRESERVED_FLAGS;
-	unsigned long jiffies_at_alloc;
-	int retries, to_clear;
-	bool in_flight;
-	int budget_token = cmd->budget_token;
-
-	if (!blk_rq_is_passthrough(rq) && !(flags & SCMD_INITIALIZED)) {
-		flags |= SCMD_INITIALIZED;
+
+	if (!blk_rq_is_passthrough(rq) && !(cmd->flags & SCMD_INITIALIZED)) {
+		cmd->flags |= SCMD_INITIALIZED;
 		scsi_initialize_rq(rq);
 	}
 
-	jiffies_at_alloc = cmd->jiffies_at_alloc;
-	retries = cmd->retries;
-	in_flight = test_bit(SCMD_STATE_INFLIGHT, &cmd->state);
-	/*
-	 * Zero out the cmd, except for the embedded scsi_request. Only clear
-	 * the driver-private command data if the LLD does not supply a
-	 * function to initialize that data.
-	 */
-	to_clear = sizeof(*cmd) - sizeof(cmd->req);
-	if (!dev->host->hostt->init_cmd_priv)
-		to_clear += dev->host->hostt->cmd_size;
-	memset((char *)cmd + sizeof(cmd->req), 0, to_clear);
-
 	cmd->device = dev;
-	cmd->sense_buffer = buf;
-	cmd->prot_sdb = prot;
-	cmd->flags = flags;
+	cmd->flags &= SCMD_PRESERVED_FLAGS;
 	INIT_LIST_HEAD(&cmd->eh_entry);
 	INIT_DELAYED_WORK(&cmd->abort_work, scmd_eh_abort_handler);
-	cmd->jiffies_at_alloc = jiffies_at_alloc;
-	cmd->retries = retries;
-	if (in_flight)
-		__set_bit(SCMD_STATE_INFLIGHT, &cmd->state);
-	cmd->budget_token = budget_token;
-
 }
 
 static blk_status_t scsi_setup_scsi_cmnd(struct scsi_device *sdev,
@@ -1586,10 +1558,35 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
 	struct scsi_device *sdev = req->q->queuedata;
 	struct Scsi_Host *shost = sdev->host;
+	bool in_flight = test_bit(SCMD_STATE_INFLIGHT, &cmd->state);
 	struct scatterlist *sg;
 
 	scsi_init_command(sdev, cmd);
 
+	cmd->eh_eflags = 0;
+	cmd->allowed = 0;
+	cmd->prot_type = 0;
+	cmd->prot_flags = 0;
+	cmd->submitter = 0;
+	cmd->cmd_len = 0;
+	cmd->cmnd = NULL;
+	memset(&cmd->sdb, 0, sizeof(cmd->sdb));
+	cmd->underflow = 0;
+	cmd->transfersize = 0;
+	cmd->host_scribble = NULL;
+	cmd->result = 0;
+	cmd->extra_len = 0;
+	cmd->state = 0;
+	if (in_flight)
+		__set_bit(SCMD_STATE_INFLIGHT, &cmd->state);
+
+	/*
+	 * Only clear the driver-private command data if the LLD does not supply
+	 * a function to initialize that data.
+	 */
+	if (!shost->hostt->init_cmd_priv)
+		memset(cmd + 1, 0, shost->hostt->cmd_size);
+
 	cmd->prot_op = SCSI_PROT_NORMAL;
 	if (blk_rq_bytes(req))
 		cmd->sc_data_direction = rq_dma_dir(req);
-- 
2.30.2

