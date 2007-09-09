From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 20/22] advansys: Improve reset handler
Date: Sun,  9 Sep 2007 08:56:45 -0600
Message-ID: <11893498073093-git-send-email-matthew@wil.cx>
References: <20070909145358.GG6809@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:45187 "EHLO
	mail-07.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757233AbXIIO4u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Sep 2007 10:56:50 -0400
In-Reply-To: <20070909145358.GG6809@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

 - Don't need to set ASC_HOST_IN_RESET any more
 - Don't need to test scp->device->host for NULL -- if it's NULL, we
   couldn't've been called.
 - Use scmd_printk instead of ASC_PRINT

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |   83 ++++++++++++----------------------------------
 1 files changed, 22 insertions(+), 61 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 3fbeea7..76dfb0c 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -2229,7 +2229,6 @@ do { \
 #define ASC_BOARDP(host) ((asc_board_t *) &((host)->hostdata))
 
 /* asc_board_t flags */
-#define ASC_HOST_IN_RESET       0x01
 #define ASC_IS_WIDE_BOARD       0x04	/* AdvanSys Wide Board */
 #define ASC_SELECT_QUEUE_DEPTHS 0x08
 
@@ -9751,106 +9750,68 @@ static int AscISR(ASC_DVC_VAR *asc_dvc)
  */
 static int advansys_reset(struct scsi_cmnd *scp)
 {
-	struct Scsi_Host *shost;
-	asc_board_t *boardp;
-	ASC_DVC_VAR *asc_dvc_varp;
-	ADV_DVC_VAR *adv_dvc_varp;
-	ulong flags;
+	struct Scsi_Host *shost = scp->device->host;
+	struct asc_board *boardp = ASC_BOARDP(shost);
+	unsigned long flags;
 	int status;
 	int ret = SUCCESS;
 
-	ASC_DBG1(1, "advansys_reset: 0x%lx\n", (ulong)scp);
+	ASC_DBG1(1, "advansys_reset: 0x%p\n", scp);
 
-#ifdef ADVANSYS_STATS
-	if (scp->device->host != NULL) {
-		ASC_STATS(scp->device->host, reset);
-	}
-#endif /* ADVANSYS_STATS */
-
-	if ((shost = scp->device->host) == NULL) {
-		scp->result = HOST_BYTE(DID_ERROR);
-		return FAILED;
-	}
+	ASC_STATS(shost, reset);
 
-	boardp = ASC_BOARDP(shost);
-
-	ASC_PRINT1("advansys_reset: board %d: SCSI bus reset started...\n",
-		   boardp->id);
-	/*
-	 * Check for re-entrancy.
-	 */
-	spin_lock_irqsave(&boardp->lock, flags);
-	if (boardp->flags & ASC_HOST_IN_RESET) {
-		spin_unlock_irqrestore(&boardp->lock, flags);
-		return FAILED;
-	}
-	boardp->flags |= ASC_HOST_IN_RESET;
-	spin_unlock_irqrestore(&boardp->lock, flags);
+	scmd_printk(KERN_INFO, scp, "SCSI bus reset started...\n");
 
 	if (ASC_NARROW_BOARD(boardp)) {
-		/*
-		 * Narrow Board
-		 */
-		asc_dvc_varp = &boardp->dvc_var.asc_dvc_var;
+		ASC_DVC_VAR *asc_dvc = &boardp->dvc_var.asc_dvc_var;
 
-		/*
-		 * Reset the chip and SCSI bus.
-		 */
+		/* Reset the chip and SCSI bus. */
 		ASC_DBG(1, "advansys_reset: before AscInitAsc1000Driver()\n");
-		status = AscInitAsc1000Driver(asc_dvc_varp);
+		status = AscInitAsc1000Driver(asc_dvc);
 
 		/* Refer to ASC_IERR_* defintions for meaning of 'err_code'. */
-		if (asc_dvc_varp->err_code) {
-			ASC_PRINT2("advansys_reset: board %d: SCSI bus reset "
-				   "error: 0x%x\n", boardp->id,
-				   asc_dvc_varp->err_code);
+		if (asc_dvc->err_code) {
+			scmd_printk(KERN_INFO, scp, "SCSI bus reset error: "
+				    "0x%x\n", asc_dvc->err_code);
 			ret = FAILED;
 		} else if (status) {
-			ASC_PRINT2("advansys_reset: board %d: SCSI bus reset "
-				   "warning: 0x%x\n", boardp->id, status);
+			scmd_printk(KERN_INFO, scp, "SCSI bus reset warning: "
+				    "0x%x\n", status);
 		} else {
-			ASC_PRINT1("advansys_reset: board %d: SCSI bus reset "
-				   "successful.\n", boardp->id);
+			scmd_printk(KERN_INFO, scp, "SCSI bus reset "
+				    "successful\n");
 		}
 
 		ASC_DBG(1, "advansys_reset: after AscInitAsc1000Driver()\n");
 		spin_lock_irqsave(&boardp->lock, flags);
-
 	} else {
 		/*
-		 * Wide Board
-		 *
 		 * If the suggest reset bus flags are set, then reset the bus.
 		 * Otherwise only reset the device.
 		 */
-		adv_dvc_varp = &boardp->dvc_var.adv_dvc_var;
+		ADV_DVC_VAR *adv_dvc = &boardp->dvc_var.adv_dvc_var;
 
 		/*
 		 * Reset the target's SCSI bus.
 		 */
 		ASC_DBG(1, "advansys_reset: before AdvResetChipAndSB()\n");
-		switch (AdvResetChipAndSB(adv_dvc_varp)) {
+		switch (AdvResetChipAndSB(adv_dvc)) {
 		case ASC_TRUE:
-			ASC_PRINT1("advansys_reset: board %d: SCSI bus reset "
-				   "successful.\n", boardp->id);
+			scmd_printk(KERN_INFO, scp, "SCSI bus reset "
+				    "successful\n");
 			break;
 		case ASC_FALSE:
 		default:
-			ASC_PRINT1("advansys_reset: board %d: SCSI bus reset "
-				   "error.\n", boardp->id);
+			scmd_printk(KERN_INFO, scp, "SCSI bus reset error\n");
 			ret = FAILED;
 			break;
 		}
 		spin_lock_irqsave(&boardp->lock, flags);
-		AdvISR(adv_dvc_varp);
+		AdvISR(adv_dvc);
 	}
-	/* Board lock is held. */
 
 	/* Save the time of the most recently completed reset. */
 	boardp->last_reset = jiffies;
-
-	/* Clear reset flag. */
-	boardp->flags &= ~ASC_HOST_IN_RESET;
 	spin_unlock_irqrestore(&boardp->lock, flags);
 
 	ASC_DBG1(1, "advansys_reset: ret %d\n", ret);
-- 
1.5.2.4

