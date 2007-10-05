From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 6/17] sym53c8xx: Stop overriding scsi_done
Date: Fri,  5 Oct 2007 15:55:03 -0400
Message-ID: <1191614114683-git-send-email-matthew@wil.cx>
References: <11916141143747-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:43990 "EHLO
	mail-01.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761082AbXJETzV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Oct 2007 15:55:21 -0400
In-Reply-To: <11916141143747-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

Instead of telling the reset routine that the command completed from
sym_eh_done, do it from sym_xpt_done.  The 'to_do' element of the ucmd
is redundant -- it serves only to tell whether eh_done is valid or not,
and we can tell this by checking to see if it's NULL.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c |   60 ++++++++++------------------------
 1 files changed, 18 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 4d49a9b..6bc8789 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -134,8 +134,6 @@ static struct scsi_transport_template *sym2_transport_template = NULL;
  *  Driver private area in the SCSI command structure.
  */
 struct sym_ucmd {		/* Override the SCSI pointer structure */
-	unsigned char	to_do;			/* For error handling */
-	void (*old_done)(struct scsi_cmnd *);	/* For error handling */
 	struct completion *eh_done;		/* For error handling */
 };
 
@@ -147,6 +145,12 @@ struct sym_ucmd {		/* Override the SCSI pointer structure */
  */
 void sym_xpt_done(struct sym_hcb *np, struct scsi_cmnd *cmd)
 {
+	struct sym_ucmd *ucmd = SYM_UCMD_PTR(cmd);
+	BUILD_BUG_ON(sizeof(struct scsi_pointer) < sizeof(struct sym_ucmd));
+
+	if (ucmd->eh_done)
+		complete(ucmd->eh_done);
+
 	scsi_dma_unmap(cmd);
 	cmd->scsi_done(cmd);
 }
@@ -586,26 +590,6 @@ static void sym53c8xx_timer(unsigned long npref)
 #define SYM_EH_HOST_RESET	3
 
 /*
- *  What we will do regarding the involved SCSI command.
- */
-#define SYM_EH_DO_IGNORE	0
-#define SYM_EH_DO_WAIT		2
-
-/*
- *  scsi_done() alias when error recovery is in progress.
- */
-static void sym_eh_done(struct scsi_cmnd *cmd)
-{
-	struct sym_ucmd *ucmd = SYM_UCMD_PTR(cmd);
-	BUILD_BUG_ON(sizeof(struct scsi_pointer) < sizeof(struct sym_ucmd));
-
-	cmd->scsi_done = ucmd->old_done;
-
-	if (ucmd->to_do == SYM_EH_DO_WAIT)
-		complete(ucmd->eh_done);
-}
-
-/*
  *  Generic method for our eh processing.
  *  The 'op' argument tells what we have to do.
  */
@@ -615,7 +599,7 @@ static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
 	struct sym_ucmd *ucmd = SYM_UCMD_PTR(cmd);
 	struct Scsi_Host *host = cmd->device->host;
 	SYM_QUEHEAD *qp;
-	int to_do = SYM_EH_DO_IGNORE;
+	int cmd_queued = 0;
 	int sts = -1;
 	struct completion eh_done;
 
@@ -626,19 +610,11 @@ static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
 	FOR_EACH_QUEUED_ELEMENT(&np->busy_ccbq, qp) {
 		struct sym_ccb *cp = sym_que_entry(qp, struct sym_ccb, link_ccbq);
 		if (cp->cmd == cmd) {
-			to_do = SYM_EH_DO_WAIT;
+			cmd_queued = 1;
 			break;
 		}
 	}
 
-	if (to_do == SYM_EH_DO_WAIT) {
-		init_completion(&eh_done);
-		ucmd->old_done = cmd->scsi_done;
-		ucmd->eh_done = &eh_done;
-		wmb();
-		cmd->scsi_done = sym_eh_done;
-	}
-
 	/* Try to proceed the operation we have been asked for */
 	sts = -1;
 	switch(op) {
@@ -662,21 +638,21 @@ static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
 	}
 
 	/* On error, restore everything and cross fingers :) */
-	if (sts) {
-		cmd->scsi_done = ucmd->old_done;
-		to_do = SYM_EH_DO_IGNORE;
-	}
-
-	ucmd->to_do = to_do;
-	spin_unlock_irq(host->host_lock);
+	if (sts)
+		cmd_queued = 0;
 
-	if (to_do == SYM_EH_DO_WAIT) {
+	if (cmd_queued) {
+		init_completion(&eh_done);
+		ucmd->eh_done = &eh_done;
+		spin_unlock_irq(host->host_lock);
 		if (!wait_for_completion_timeout(&eh_done, 5*HZ)) {
-			ucmd->to_do = SYM_EH_DO_IGNORE;
-			wmb();
+			ucmd->eh_done = NULL;
 			sts = -2;
 		}
+	} else {
+		spin_unlock_irq(host->host_lock);
 	}
+
 	dev_warn(&cmd->device->sdev_gendev, "%s operation %s.\n", opname,
 			sts==0 ? "complete" :sts==-2 ? "timed-out" : "failed");
 	return sts ? SCSI_FAILED : SCSI_SUCCESS;
-- 
1.4.4.2

