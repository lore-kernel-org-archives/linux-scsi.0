From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH] aha1542: Allocate memory before taking a lock
Date: Tue, 21 Apr 2015 23:27:50 +0200
Message-ID: <1429651670-5466-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:55301 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932871AbbDUV2M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2015 17:28:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: James Bottomley <JBottomley@odin.com>, linux-scsi@vger.kernel.org

The driver currently calls kmalloc with GFP_KERNEL while holding a lock.
Fix it by doing the allocation earlier, before taking the lock.

Tested on AHA-1542B.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/aha1542.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index ec43276..b95d277 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -375,9 +375,10 @@ static int aha1542_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 	u8 lun = cmd->device->lun;
 	unsigned long flags;
 	int bufflen = scsi_bufflen(cmd);
-	int mbo;
+	int mbo, sg_count;
 	struct mailbox *mb = aha1542->mb;
 	struct ccb *ccb = aha1542->ccb;
+	struct chain *cptr;
 
 	if (*cmd->cmnd == REQUEST_SENSE) {
 		/* Don't do the command - we have the sense data already */
@@ -397,6 +398,13 @@ static int aha1542_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 		print_hex_dump_bytes("command: ", DUMP_PREFIX_NONE, cmd->cmnd, cmd->cmd_len);
 	}
 #endif
+	if (bufflen) {	/* allocate memory before taking host_lock */
+		sg_count = scsi_sg_count(cmd);
+		cptr = kmalloc(sizeof(*cptr) * sg_count, GFP_KERNEL | GFP_DMA);
+		if (!cptr)
+			return SCSI_MLQUEUE_HOST_BUSY;
+	}
+
 	/* Use the outgoing mailboxes in a round-robin fashion, because this
 	   is how the host adapter will scan for them */
 
@@ -441,19 +449,10 @@ static int aha1542_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 
 	if (bufflen) {
 		struct scatterlist *sg;
-		struct chain *cptr;
-		int i, sg_count = scsi_sg_count(cmd);
+		int i;
 
 		ccb[mbo].op = 2;	/* SCSI Initiator Command  w/scatter-gather */
-		cmd->host_scribble = kmalloc(sizeof(*cptr)*sg_count,
-		                                         GFP_KERNEL | GFP_DMA);
-		cptr = (struct chain *) cmd->host_scribble;
-		if (cptr == NULL) {
-			/* free the claimed mailbox slot */
-			aha1542->int_cmds[mbo] = NULL;
-			spin_unlock_irqrestore(sh->host_lock, flags);
-			return SCSI_MLQUEUE_HOST_BUSY;
-		}
+		cmd->host_scribble = (void *)cptr;
 		scsi_for_each_sg(cmd, sg, sg_count, i) {
 			any2scsi(cptr[i].dataptr, isa_page_to_bus(sg_page(sg))
 								+ sg->offset);
-- 
Ondrej Zary

