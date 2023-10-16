Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EB07CDB483
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Oct 2023 09:24:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232874AbjJPJYx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 05:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232508AbjJPJYt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 05:24:49 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB69E5
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2023 02:24:46 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id ADB1821C48;
        Mon, 16 Oct 2023 09:24:44 +0000 (UTC)
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 191322CB4D;
        Mon, 16 Oct 2023 09:24:44 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id C723951EBDC7; Mon, 16 Oct 2023 11:24:43 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 05/17] a1000u2w: do not rely on the command for inia100_device_reset()
Date:   Mon, 16 Oct 2023 11:24:18 +0200
Message-Id: <20231016092430.55557-6-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231016092430.55557-1-hare@suse.de>
References: <20231016092430.55557-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: +++++++++++
Authentication-Results: smtp-out1.suse.de;
        dkim=none;
        dmarc=none;
        spf=softfail (smtp-out1.suse.de: 149.44.160.134 is neither permitted nor denied by domain of hare@suse.de) smtp.mailfrom=hare@suse.de
X-Rspamd-Server: rspamd2
X-Spamd-Result: default: False [11.49 / 50.00];
         ARC_NA(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         MIME_GOOD(-0.10)[text/plain];
         DMARC_NA(0.20)[suse.de];
         BROKEN_CONTENT_TYPE(1.50)[];
         R_SPF_SOFTFAIL(0.60)[~all:c];
         RCPT_COUNT_FIVE(0.00)[5];
         TO_MATCH_ENVRCPT_SOME(0.00)[];
         VIOLATED_DIRECT_SPF(3.50)[];
         MX_GOOD(-0.01)[];
         NEURAL_SPAM_LONG(3.00)[1.000];
         MID_CONTAINS_FROM(1.00)[];
         RWL_MAILSPIKE_GOOD(0.00)[149.44.160.134:from];
         NEURAL_HAM_SHORT(-1.00)[-1.000];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         R_DKIM_NA(0.20)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         BAYES_HAM(-0.00)[32.07%]
X-Rspamd-Queue-Id: ADB1821C48
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

