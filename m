Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62A77C4320A
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A7B160F11
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239878AbhHQJSF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 05:18:05 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47558 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239494AbhHQJRU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 05:17:20 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 9F80320028;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629191802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/+r/WKnJufi/m5+khXJxCiCzQ+8r/kLygQfMOzIy9Pk=;
        b=zRPg+2EBAO/J5yu0PSJGrKl0jTPluRyfnWMtf8npAuoIw3xhNNBzw4rB2kxXHVPnKjQUwf
        hY8tIHBCXbQhg1YGitjl119dTG2QvaJiivl2ycgt5nNrm1daoUQ9kRGc1zsKwlUXRK44hc
        aUNq4sXR79JybH70jmIrK5jizCUUCKo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629191802;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/+r/WKnJufi/m5+khXJxCiCzQ+8r/kLygQfMOzIy9Pk=;
        b=sRiCzY0rHemisx1W/30SZd/rg7xpgsQ0O4cjXuXpJU3/AIPLN6hbiMHWdEiLCke1jSe/7S
        XwX6kps32H/pEeAg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 9A657A3B91;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 9774F518CEAD; Tue, 17 Aug 2021 11:16:42 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 39/51] a1000u2w: do not rely on the command for inia100_device_reset()
Date:   Tue, 17 Aug 2021 11:14:44 +0200
Message-Id: <20210817091456.73342-40-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210817091456.73342-1-hare@suse.de>
References: <20210817091456.73342-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the scsi device as argument to orc_device_reset() instead
of relying on the passed in scsi command.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/a100u2w.c | 43 +++++++++++-------------------------------
 1 file changed, 11 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index eee119c06b48..b6373dcfe4ea 100644
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
@@ -974,7 +955,7 @@ static int inia100_device_reset(struct scsi_cmnd * cmd)
 {				/* I need Host Control Block Information */
 	struct orc_host *host;
 	host = (struct orc_host *) cmd->device->host->hostdata;
-	return orc_device_reset(host, cmd, scmd_id(cmd));
+	return orc_device_reset(host, cmd->device);
 
 }
 
@@ -994,11 +975,7 @@ static void inia100_scb_handler(struct orc_host *host, struct orc_scb *scb)
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
@@ -1036,13 +1013,15 @@ static void inia100_scb_handler(struct orc_host *host, struct orc_scb *scb)
 		break;
 	}
 
-	if (scb->tastat == 2) {	/* Check condition              */
+	if (cmd && scb->tastat == 2) {	/* Check condition              */
 		memcpy((unsigned char *) &cmd->sense_buffer[0],
 		   (unsigned char *) &escb->sglist[0], SENSE_SIZE);
 	}
-	cmd->result = scb->tastat | (scb->hastat << 16);
-	scsi_dma_unmap(cmd);
-	cmd->scsi_done(cmd);	/* Notify system DONE           */
+	if (cmd) {
+		cmd->result = scb->tastat | (scb->hastat << 16);
+		scsi_dma_unmap(cmd);
+		cmd->scsi_done(cmd);	/* Notify system DONE           */
+	}
 	orc_release_scb(host, scb);	/* Release SCB for current channel */
 }
 
-- 
2.29.2

