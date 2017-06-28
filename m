From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 36/47] a1000u2w: do not rely on the command for inia100_device_reset()
Date: Wed, 28 Jun 2017 10:33:02 +0200
Message-ID: <1498638793-44672-37-git-send-email-hare@suse.de>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53768 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751518AbdF1Ida (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:33:30 -0400
In-Reply-To: <1498638793-44672-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Use the scsi device as argument to orc_device_reset() instead
of relying on the passed in scsi command.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/a100u2w.c | 43 +++++++++++--------------------------------
 1 file changed, 11 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index 1c61d7a..8802d23 100644
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
1.8.5.6
