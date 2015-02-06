From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 31/36] aha1542: remove DEB macro and simplify debug code
Date: Fri,  6 Feb 2015 23:11:52 +0100
Message-ID: <1423260717-15944-32-git-send-email-linux@rainbow-software.org>
References: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56966 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758250AbbBFWP7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2015 17:15:59 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YJr8I-0006fF-Dm
	for linux-scsi@vger.kernel.org; Fri, 06 Feb 2015 23:12:14 +0100
In-Reply-To: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Remove DEB macro and join ifdef DEBUG blocks

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/aha1542.c |   56 +++++++++++++++++++-----------------------------
 1 file changed, 22 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index d607f59..6d4532c 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -24,11 +24,6 @@
 #include <scsi/scsi_host.h>
 #include "aha1542.h"
 
-#ifdef DEBUG
-#define DEB(x) x
-#else
-#define DEB(x)
-#endif
 #define MAXBOARDS 4
 
 static bool isapnp = 1;
@@ -195,7 +190,9 @@ static int makecode(unsigned hosterr, unsigned scsierr)
 	case 0x1a:		/* Invalid CCB or Segment List Parameter-A segment list with a zero
 				   length segment or invalid segment list boundaries was received.
 				   A CCB parameter was invalid. */
-		DEB(printk("Aha1542: %x %x\n", hosterr, scsierr));
+#ifdef DEBUG
+		printk("Aha1542: %x %x\n", hosterr, scsierr);
+#endif
 		hosterr = DID_ERROR;	/* Couldn't find any better */
 		break;
 
@@ -340,11 +337,9 @@ static void aha1542_intr_handle(struct Scsi_Host *sh)
 		spin_unlock_irqrestore(&aha1542_lock, flags);
 
 #ifdef DEBUG
-		{
-			if (ccb[mbo].tarstat | ccb[mbo].hastat)
-				shost_printk(KERN_DEBUG, sh, "aha1542_command: returning %x (status %d)\n",
-				       ccb[mbo].tarstat + ((int) ccb[mbo].hastat << 16), mb[mbi].status);
-		};
+		if (ccb[mbo].tarstat | ccb[mbo].hastat)
+			shost_printk(KERN_DEBUG, sh, "aha1542_command: returning %x (status %d)\n",
+			       ccb[mbo].tarstat + ((int) ccb[mbo].hastat << 16), mb[mbi].status);
 #endif
 
 		if (mbistatus == 3)
@@ -386,26 +381,17 @@ static void aha1542_intr_handle(struct Scsi_Host *sh)
 		if (errstatus)
 			shost_printk(KERN_DEBUG, sh, "(aha1542 error:%x %x %x) ", errstatus,
 			       ccb[mbo].hastat, ccb[mbo].tarstat);
-#endif
-
 		if (ccb[mbo].tarstat == 2) {
-#ifdef DEBUG
 			int i;
-#endif
-			DEB(printk("aha1542_intr_handle: sense:"));
-#ifdef DEBUG
+
+			printk("aha1542_intr_handle: sense:");
 			for (i = 0; i < 12; i++)
 				printk("%02x ", ccb[mbo].cdb[ccb[mbo].cdblen + i]);
 			printk("\n");
-#endif
-			/*
-			   DEB(printk("aha1542_intr_handle: buf:"));
-			   for (i = 0; i < bufflen; i++)
-			   printk("%02x ", ((unchar *)buff)[i]);
-			   printk("\n");
-			 */
 		}
-		DEB(if (errstatus) printk("aha1542_intr_handle: returning %6x\n", errstatus));
+		if (errstatus)
+			printk("aha1542_intr_handle: returning %6x\n", errstatus);
+#endif
 		tmp_cmd->result = errstatus;
 		aha1542->int_cmds[mbo] = NULL;	/* This effectively frees up the mailbox slot, as
 						   far as queuecommand is concerned */
@@ -438,15 +424,15 @@ static int aha1542_queuecommand_lck(struct scsi_cmnd *cmd, void (*done) (struct
 	int mbo;
 	struct mailbox *mb = aha1542->mb;
 	struct ccb *ccb = aha1542->ccb;
+#ifdef DEBUG
+	int i;
 
-	DEB(int i);
-
-	DEB(if (target > 1) {
-	    cmd->result = DID_TIME_OUT << 16;
-	    done(cmd); return 0;
-	    }
-	);
-
+	if (target > 1) {
+		cmd->result = DID_TIME_OUT << 16;
+		done(cmd);
+		return 0;
+	}
+#endif
 	if (*cmd->cmnd == REQUEST_SENSE) {
 		/* Don't do the command - we have the sense data already */
 		cmd->result = 0;
@@ -564,7 +550,9 @@ static int aha1542_queuecommand_lck(struct scsi_cmnd *cmd, void (*done) (struct
 #endif
 
 	if (done) {
-		DEB(printk("aha1542_queuecommand: now waiting for interrupt "));
+#ifdef DEBUG
+		printk("aha1542_queuecommand: now waiting for interrupt ");
+#endif
 		cmd->scsi_done = done;
 		mb[mbo].status = 1;
 		aha1542_outb(cmd->device->host->io_port, CMD_START_SCSI);
-- 
Ondrej Zary

