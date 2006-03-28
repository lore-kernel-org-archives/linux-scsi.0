From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 03/10] Simplify error handling a bit
Date: Tue, 28 Mar 2006 11:03:44 -0500
Message-ID: <11435618243467-git-send-email-matthew@wil.cx>
Reply-To: Matthew Wilcox <matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.magmacom.com ([206.191.0.217]:59583 "EHLO mx1.magmacom.com")
	by vger.kernel.org with ESMTP id S1751183AbWC1QD3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Mar 2006 11:03:29 -0500
In-Reply-To: 20060328160156.GJ3486@parisc-linux.org
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

 - to_do was never set to SYM_EH_DO_COMPLETE, so remove that code
 - move the spinlocks inside the common error handler code path

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

---

 drivers/scsi/sym53c8xx_2/sym_glue.c |   50 ++++++-----------------------------
 1 files changed, 8 insertions(+), 42 deletions(-)

3ea98e40e666302bbd8a1d2b265ed7d23480f622
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index e6ff89a..052ce11 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -712,7 +712,6 @@ static void sym53c8xx_timer(unsigned lon
  *  What we will do regarding the involved SCSI command.
  */
 #define SYM_EH_DO_IGNORE	0
-#define SYM_EH_DO_COMPLETE	1
 #define SYM_EH_DO_WAIT		2
 
 /*
@@ -764,25 +763,18 @@ static int sym_eh_handler(int op, char *
 
 	dev_warn(&cmd->device->sdev_gendev, "%s operation started.\n", opname);
 
+	spin_lock_irq(cmd->device->host->host_lock);
 	/* This one is queued in some place -> to wait for completion */
 	FOR_EACH_QUEUED_ELEMENT(&np->busy_ccbq, qp) {
 		struct sym_ccb *cp = sym_que_entry(qp, struct sym_ccb, link_ccbq);
 		if (cp->cmd == cmd) {
 			to_do = SYM_EH_DO_WAIT;
-			goto prepare;
+			break;
 		}
 	}
 
-prepare:
-	/* Prepare stuff to either ignore, complete or wait for completion */
-	switch(to_do) {
-	default:
-	case SYM_EH_DO_IGNORE:
-		break;
-	case SYM_EH_DO_WAIT:
+	if (to_do == SYM_EH_DO_WAIT) {
 		init_completion(&ep->done);
-		/* fall through */
-	case SYM_EH_DO_COMPLETE:
 		ep->old_done = cmd->scsi_done;
 		cmd->scsi_done = sym_eh_done;
 		SYM_UCMD_PTR(cmd)->eh_wait = ep;
@@ -818,9 +810,6 @@ prepare:
 	}
 
 	ep->to_do = to_do;
-	/* Complete the command with locks held as required by the driver */
-	if (to_do == SYM_EH_DO_COMPLETE)
-		sym_xpt_done2(np, cmd, DID_ABORT);
 
 	/* Wait for completion with locks released, as required by kernel */
 	if (to_do == SYM_EH_DO_WAIT) {
@@ -836,6 +825,7 @@ prepare:
 		if (ep->timed_out)
 			sts = -2;
 	}
+	spin_unlock_irq(cmd->device->host->host_lock);
 	dev_warn(&cmd->device->sdev_gendev, "%s operation %s.\n", opname,
 			sts==0 ? "complete" :sts==-2 ? "timed-out" : "failed");
 	return sts ? SCSI_FAILED : SCSI_SUCCESS;
@@ -847,46 +837,22 @@ prepare:
  */
 static int sym53c8xx_eh_abort_handler(struct scsi_cmnd *cmd)
 {
-	int rc;
-
-	spin_lock_irq(cmd->device->host->host_lock);
-	rc = sym_eh_handler(SYM_EH_ABORT, "ABORT", cmd);
-	spin_unlock_irq(cmd->device->host->host_lock);
-
-	return rc;
+	return sym_eh_handler(SYM_EH_ABORT, "ABORT", cmd);
 }
 
 static int sym53c8xx_eh_device_reset_handler(struct scsi_cmnd *cmd)
 {
-	int rc;
-
-	spin_lock_irq(cmd->device->host->host_lock);
-	rc = sym_eh_handler(SYM_EH_DEVICE_RESET, "DEVICE RESET", cmd);
-	spin_unlock_irq(cmd->device->host->host_lock);
-
-	return rc;
+	return sym_eh_handler(SYM_EH_DEVICE_RESET, "DEVICE RESET", cmd);
 }
 
 static int sym53c8xx_eh_bus_reset_handler(struct scsi_cmnd *cmd)
 {
-	int rc;
-
-	spin_lock_irq(cmd->device->host->host_lock);
-	rc = sym_eh_handler(SYM_EH_BUS_RESET, "BUS RESET", cmd);
-	spin_unlock_irq(cmd->device->host->host_lock);
-
-	return rc;
+	return sym_eh_handler(SYM_EH_BUS_RESET, "BUS RESET", cmd);
 }
 
 static int sym53c8xx_eh_host_reset_handler(struct scsi_cmnd *cmd)
 {
-	int rc;
-
-	spin_lock_irq(cmd->device->host->host_lock);
-	rc = sym_eh_handler(SYM_EH_HOST_RESET, "HOST RESET", cmd);
-	spin_unlock_irq(cmd->device->host->host_lock);
-
-	return rc;
+	return sym_eh_handler(SYM_EH_HOST_RESET, "HOST RESET", cmd);
 }
 
 /*
-- 
1.2.4.g375a5


