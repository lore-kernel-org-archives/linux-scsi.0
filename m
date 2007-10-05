From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 13/17] sym53c8xx: Use scmd_printk where appropriate
Date: Fri,  5 Oct 2007 15:55:10 -0400
Message-ID: <1191614115834-git-send-email-matthew@wil.cx>
References: <11916141143747-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:55221 "EHLO
	mail-05.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761328AbXJETzV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Oct 2007 15:55:21 -0400
In-Reply-To: <11916141143747-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

If we have a scsi_cmnd, it gives the user more information than the
sym_name, and maybe the target.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c |    4 ++--
 drivers/scsi/sym53c8xx_2/sym_hipd.c |   35 +++++++++++++++++------------------
 2 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index e5b2213..e731618 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -392,7 +392,7 @@ int sym_setup_data_and_start(struct sym_hcb *np, struct scsi_cmnd *cmd, struct s
 	 */
 	switch (dir) {
 	case DMA_BIDIRECTIONAL:
-		printk("%s: got DMA_BIDIRECTIONAL command", sym_name(np));
+		scmd_printk(KERN_INFO, cmd, "got DMA_BIDIRECTIONAL command");
 		sym_set_cam_status(cmd, DID_ERROR);
 		goto out_abort;
 	case DMA_TO_DEVICE:
@@ -606,7 +606,7 @@ static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
 	int sts = -1;
 	struct completion eh_done;
 
-	dev_warn(&cmd->device->sdev_gendev, "%s operation started.\n", opname);
+	scmd_printk(KERN_WARNING, cmd, "%s operation started.\n", opname);
 
 	/* We may be in an error condition because the PCI bus
 	 * went down. In this case, we need to wait until the
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 5d0d356..13fd5b2 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -52,7 +52,7 @@
  *  Needed function prototypes.
  */
 static void sym_int_ma (struct sym_hcb *np);
-static void sym_int_sir (struct sym_hcb *np);
+static void sym_int_sir(struct sym_hcb *);
 static struct sym_ccb *sym_alloc_ccb(struct sym_hcb *np);
 static struct sym_ccb *sym_ccb_from_dsa(struct sym_hcb *np, u32 dsa);
 static void sym_alloc_lcb_tags (struct sym_hcb *np, u_char tn, u_char ln);
@@ -1522,7 +1522,8 @@ void sym_put_start_queue(struct sym_hcb *np, struct sym_ccb *cp)
 	np->squeueput = qidx;
 
 	if (DEBUG_FLAGS & DEBUG_QUEUE)
-		printf ("%s: queuepos=%d.\n", sym_name (np), np->squeueput);
+		scmd_printk(KERN_DEBUG, cp->cmd, "queuepos=%d\n",
+							np->squeueput);
 
 	/*
 	 *  Script processor may be waiting for reselect.
@@ -2852,7 +2853,7 @@ void sym_interrupt (struct sym_hcb *np)
 	    !(dstat & (MDPE|BF|ABRT|IID))) {
 		if	(sist & PAR)	sym_int_par (np, sist);
 		else if (sist & MA)	sym_int_ma (np);
-		else if (dstat & SIR)	sym_int_sir (np);
+		else if (dstat & SIR)	sym_int_sir(np);
 		else if (dstat & SSI)	OUTONB_STD();
 		else			goto unknown_int;
 		return;
@@ -4314,7 +4315,7 @@ static void sym_nego_rejected(struct sym_hcb *np, struct sym_tcb *tp, struct sym
 /*
  *  chip exception handler for programmed interrupts.
  */
-static void sym_int_sir (struct sym_hcb *np)
+static void sym_int_sir(struct sym_hcb *np)
 {
 	u_char	num	= INB(np, nc_dsps);
 	u32	dsa	= INL(np, nc_dsa);
@@ -4353,31 +4354,30 @@ static void sym_int_sir (struct sym_hcb *np)
 		return;
 	/*
 	 *  The device didn't go to MSG OUT phase after having 
-	 *  been selected with ATN. We donnot want to handle 
-	 *  that.
+	 *  been selected with ATN.  We do not want to handle that.
 	 */
 	case SIR_SEL_ATN_NO_MSG_OUT:
-		printf ("%s:%d: No MSG OUT phase after selection with ATN.\n",
-			sym_name (np), target);
+		scmd_printk(KERN_WARNING, cp->cmd,
+				"No MSG OUT phase after selection with ATN\n");
 		goto out_stuck;
 	/*
 	 *  The device didn't switch to MSG IN phase after 
-	 *  having reseleted the initiator.
+	 *  having reselected the initiator.
 	 */
 	case SIR_RESEL_NO_MSG_IN:
-		printf ("%s:%d: No MSG IN phase after reselection.\n",
-			sym_name (np), target);
+		scmd_printk(KERN_WARNING, cp->cmd,
+				"No MSG IN phase after reselection\n");
 		goto out_stuck;
 	/*
 	 *  After reselection, the device sent a message that wasn't 
 	 *  an IDENTIFY.
 	 */
 	case SIR_RESEL_NO_IDENTIFY:
-		printf ("%s:%d: No IDENTIFY after reselection.\n",
-			sym_name (np), target);
+		scmd_printk(KERN_WARNING, cp->cmd,
+				"No IDENTIFY after reselection\n");
 		goto out_stuck;
 	/*
-	 *  The device reselected a LUN we donnot know about.
+	 *  The device reselected a LUN we do not know about.
 	 */
 	case SIR_RESEL_BAD_LUN:
 		np->msgout[0] = M_RESET;
@@ -4390,8 +4390,7 @@ static void sym_int_sir (struct sym_hcb *np)
 		np->msgout[0] = M_ABORT;
 		goto out;
 	/*
-	 *  The device reselected for a tagged nexus that we donnot 
-	 *  have.
+	 * The device reselected for a tagged nexus that we do not have.
 	 */
 	case SIR_RESEL_BAD_I_T_L_Q:
 		np->msgout[0] = M_ABORT_TAG;
@@ -4403,8 +4402,8 @@ static void sym_int_sir (struct sym_hcb *np)
 	case SIR_RESEL_ABORTED:
 		np->lastmsg = np->msgout[0];
 		np->msgout[0] = M_NOOP;
-		printf ("%s:%d: message %x sent on bad reselection.\n",
-			sym_name (np), target, np->lastmsg);
+		scmd_printk(KERN_WARNING, cp->cmd,
+			"message %x sent on bad reselection\n", np->lastmsg);
 		goto out;
 	/*
 	 *  The SCRIPTS let us know that a message has been 
-- 
1.4.4.2

