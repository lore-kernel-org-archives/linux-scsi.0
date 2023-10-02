Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5523BE743C3
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Oct 2023 15:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238258AbjJBPtn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Oct 2023 11:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238239AbjJBPtg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2023 11:49:36 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A2CE0
        for <linux-scsi@vger.kernel.org>; Mon,  2 Oct 2023 08:49:32 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id C36AF21869;
        Mon,  2 Oct 2023 15:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696261770; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IhxM4nMoUH6zdFVXAFSn4VR69R3vRMEkl/JepLw8wHM=;
        b=NuDHGWi47wklrOnVQI9uYXvNLv7iBI5A+0uw0uz/OO/9nLOookUlNgNc1H+v3gQly3uGRa
        Vd4r+zohqSwDW19MDjruzXjGA18UlNPLLhba5OdYjfmfcXiQkKtp0S6zeoHXKzk7D6wSyO
        555Bw1LgHzA/j+eycxwQdk7kwE78cY0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696261770;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IhxM4nMoUH6zdFVXAFSn4VR69R3vRMEkl/JepLw8wHM=;
        b=UHXe+XEERG69YahoG5rBb1HwyydBmKD5QIH1ndhBoraRa/+tkyz0Ba36ufQSpQp2tqnx8h
        lmGMm/Lt/LG+ITAg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id A3C902C149;
        Mon,  2 Oct 2023 15:49:30 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id BAB3451E7565; Mon,  2 Oct 2023 17:49:30 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/15] a1000u2w: do not rely on the command for inia100_device_reset()
Date:   Mon,  2 Oct 2023 17:49:16 +0200
Message-Id: <20231002154927.68643-5-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231002154927.68643-1-hare@suse.de>
References: <20231002154927.68643-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the scsi device as argument to orc_device_reset() instead
of relying on the passed in scsi command.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/a100u2w.c | 43 +++++++++++-------------------------------
 1 file changed, 11 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index b95147fb18b0..43b119add2b9 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -592,39 +592,20 @@ static int orc_reset_scsi_bus(struct orc_host * host)
  *	commands for target w/o soft reset
  */
 
-static int orc_device_reset(struct orc_host * host, struct scsi_cmnd *cmd, unsigned int target)
+static int orc_device_reset(struct orc_host * host, struct scsi_device *sdev)
 {				/* I need Host Control Block Information */
 	struct orc_scb *scb;
 	struct orc_extended_scb *escb;
-	struct orc_scb *host_scb;
-	u8 i;
 	unsigned long flags;
 
 	spin_lock_irqsave(&(host->allocation_lock), flags);
 	scb = (struct orc_scb *) NULL;
 	escb = (struct orc_extended_scb *) NULL;
 
-	/* setup scatter list address with one buffer */
-	host_scb = host->scb_virt;
-
 	/* FIXME: is this safe if we then fail to issue the reset or race
 	   a completion ? */
 	init_alloc_map(host);
 
-	/* Find the scb corresponding to the command */
-	for (i = 0; i < ORC_MAXQUEUE; i++) {
-		escb = host_scb->escb;
-		if (host_scb->status && escb->srb == cmd)
-			break;
-		host_scb++;
-	}
-
-	if (i == ORC_MAXQUEUE) {
-		printk(KERN_ERR "Unable to Reset - No SCB Found\n");
-		spin_unlock_irqrestore(&(host->allocation_lock), flags);
-		return FAILED;
-	}
-
 	/* Allocate a new SCB for the reset command to the firmware */
 	if ((scb = __orc_alloc_scb(host)) == NULL) {
 		/* Can't happen.. */
@@ -635,7 +616,7 @@ static int orc_device_reset(struct orc_host * host, struct scsi_cmnd *cmd, unsig
 	/* Reset device is handled by the firmware, we fill in an SCB and
 	   fire it at the controller, it does the rest */
 	scb->opcode = ORC_BUSDEVRST;
-	scb->target = target;
+	scb->target = sdev->id;
 	scb->hastat = 0;
 	scb->tastat = 0;
 	scb->status = 0x0;
@@ -645,8 +626,8 @@ static int orc_device_reset(struct orc_host * host, struct scsi_cmnd *cmd, unsig
 	scb->xferlen = cpu_to_le32(0);
 	scb->sg_len = cpu_to_le32(0);
 
+	escb = scb->escb;
 	escb->srb = NULL;
-	escb->srb = cmd;
 	orc_exec_scb(host, scb);	/* Start execute SCB            */
 	spin_unlock_irqrestore(&host->allocation_lock, flags);
 	return SUCCESS;
@@ -971,7 +952,7 @@ static int inia100_device_reset(struct scsi_cmnd * cmd)
 {				/* I need Host Control Block Information */
 	struct orc_host *host;
 	host = (struct orc_host *) cmd->device->host->hostdata;
-	return orc_device_reset(host, cmd, scmd_id(cmd));
+	return orc_device_reset(host, cmd->device);
 
 }
 
@@ -991,11 +972,7 @@ static void inia100_scb_handler(struct orc_host *host, struct orc_scb *scb)
 	struct orc_extended_scb *escb;
 
 	escb = scb->escb;
-	if ((cmd = (struct scsi_cmnd *) escb->srb) == NULL) {
-		printk(KERN_ERR "inia100_scb_handler: SRB pointer is empty\n");
-		orc_release_scb(host, scb);	/* Release SCB for current channel */
-		return;
-	}
+	cmd = (struct scsi_cmnd *)escb->srb;
 	escb->srb = NULL;
 
 	switch (scb->hastat) {
@@ -1033,13 +1010,15 @@ static void inia100_scb_handler(struct orc_host *host, struct orc_scb *scb)
 		break;
 	}
 
-	if (scb->tastat == 2) {	/* Check condition              */
+	if (cmd && scb->tastat == 2) {	/* Check condition              */
 		memcpy((unsigned char *) &cmd->sense_buffer[0],
 		   (unsigned char *) &escb->sglist[0], SENSE_SIZE);
 	}
-	cmd->result = scb->tastat | (scb->hastat << 16);
-	scsi_dma_unmap(cmd);
-	scsi_done(cmd);		/* Notify system DONE           */
+	if (cmd) {
+		cmd->result = scb->tastat | (scb->hastat << 16);
+		scsi_dma_unmap(cmd);
+		scsi_done(cmd);		/* Notify system DONE           */
+	}
 	orc_release_scb(host, scb);	/* Release SCB for current channel */
 }
 
-- 
2.35.3

