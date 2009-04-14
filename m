From: michaelc@cs.wisc.edu
Subject: [PATCH 2/2] sym53c8xx_2: slave_alloc/destroy safety (2.6.27.5)
Date: Tue, 14 Apr 2009 15:47:00 -0500
Message-ID: <1239742020-11429-3-git-send-email-michaelc@cs.wisc.edu>
References: <1239742020-11429-1-git-send-email-michaelc@cs.wisc.edu>
 <1239742020-11429-2-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42281 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676AbZDNUrL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Apr 2009 16:47:11 -0400
In-Reply-To: <1239742020-11429-2-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Aaro Koskinen <Aaro.Koskinen@nokia.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Aaro Koskinen <Aaro.Koskinen@nokia.com>

Make the sym53c8xx_2 driver slave_alloc/destroy less unsafe. References
to the destroyed LCB are cleared from the target structure (instead of
leaving a dangling pointer), and when the last LCB for the target is
destroyed the reference to the upper layer target data is cleared. The
host lock is used to prevent a race with the interrupt handler. Also
user commands are prevented for targets with all LCBs destroyed.

Signed-off-by: Aaro Koskinen <Aaro.Koskinen@nokia.com>
Tested-by: Tony Battersby <tonyb@cybernetics.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c |   66 +++++++++++++++++++++++++++-------
 drivers/scsi/sym53c8xx_2/sym_hipd.c |   40 ++++++++++++++++++++-
 drivers/scsi/sym53c8xx_2/sym_hipd.h |    2 +
 3 files changed, 93 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 23e7820..dd4970e 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -737,11 +737,14 @@ static int sym53c8xx_slave_alloc(struct scsi_device *sdev)
 	struct sym_hcb *np = sym_get_hcb(sdev->host);
 	struct sym_tcb *tp = &np->target[sdev->id];
 	struct sym_lcb *lp;
+	unsigned long flags;
+	int error;
 
 	if (sdev->id >= SYM_CONF_MAX_TARGET || sdev->lun >= SYM_CONF_MAX_LUN)
 		return -ENXIO;
 
-	tp->starget = sdev->sdev_target;
+	spin_lock_irqsave(np->s.host->host_lock, flags);
+
 	/*
 	 * Fail the device init if the device is flagged NOSCAN at BOOT in
 	 * the NVRAM.  This may speed up boot and maintain coherency with
@@ -753,26 +756,37 @@ static int sym53c8xx_slave_alloc(struct scsi_device *sdev)
 
 	if (tp->usrflags & SYM_SCAN_BOOT_DISABLED) {
 		tp->usrflags &= ~SYM_SCAN_BOOT_DISABLED;
-		starget_printk(KERN_INFO, tp->starget,
+		starget_printk(KERN_INFO, sdev->sdev_target,
 				"Scan at boot disabled in NVRAM\n");
-		return -ENXIO;
+		error = -ENXIO;
+		goto out;
 	}
 
 	if (tp->usrflags & SYM_SCAN_LUNS_DISABLED) {
-		if (sdev->lun != 0)
-			return -ENXIO;
-		starget_printk(KERN_INFO, tp->starget,
+		if (sdev->lun != 0) {
+			error = -ENXIO;
+			goto out;
+		}
+		starget_printk(KERN_INFO, sdev->sdev_target,
 				"Multiple LUNs disabled in NVRAM\n");
 	}
 
 	lp = sym_alloc_lcb(np, sdev->id, sdev->lun);
-	if (!lp)
-		return -ENOMEM;
+	if (!lp) {
+		error = -ENOMEM;
+		goto out;
+	}
+	if (tp->nlcb == 1)
+		tp->starget = sdev->sdev_target;
 
 	spi_min_period(tp->starget) = tp->usr_period;
 	spi_max_width(tp->starget) = tp->usr_width;
 
-	return 0;
+	error = 0;
+out:
+	spin_unlock_irqrestore(np->s.host->host_lock, flags);
+
+	return error;
 }
 
 /*
@@ -819,12 +833,34 @@ static int sym53c8xx_slave_configure(struct scsi_device *sdev)
 static void sym53c8xx_slave_destroy(struct scsi_device *sdev)
 {
 	struct sym_hcb *np = sym_get_hcb(sdev->host);
-	struct sym_lcb *lp = sym_lp(&np->target[sdev->id], sdev->lun);
+	struct sym_tcb *tp = &np->target[sdev->id];
+	struct sym_lcb *lp = sym_lp(tp, sdev->lun);
+	unsigned long flags;
+
+	spin_lock_irqsave(np->s.host->host_lock, flags);
+
+	if (lp->busy_itlq || lp->busy_itl) {
+		/*
+		 * This really shouldn't happen, but we can't return an error
+		 * so let's try to stop all on-going I/O.
+		 */
+		starget_printk(KERN_WARNING, tp->starget,
+			       "Removing busy LCB (%d)\n", sdev->lun);
+		sym_reset_scsi_bus(np, 1);
+	}
 
-	if (lp->itlq_tbl)
-		sym_mfree_dma(lp->itlq_tbl, SYM_CONF_MAX_TASK * 4, "ITLQ_TBL");
-	kfree(lp->cb_tags);
-	sym_mfree_dma(lp, sizeof(*lp), "LCB");
+	if (sym_free_lcb(np, sdev->id, sdev->lun) == 0) {
+		/*
+		 * It was the last unit for this target.
+		 */
+		tp->head.sval        = 0;
+		tp->head.wval        = np->rv_scntl3;
+		tp->head.uval        = 0;
+		tp->tgoal.check_nego = 1;
+		tp->starget	     = NULL;
+	}
+
+	spin_unlock_irqrestore(np->s.host->host_lock, flags);
 }
 
 /*
@@ -890,6 +926,8 @@ static void sym_exec_user_command (struct sym_hcb *np, struct sym_usrcmd *uc)
 			if (!((uc->target >> t) & 1))
 				continue;
 			tp = &np->target[t];
+			if (!tp->nlcb)
+				continue;
 
 			switch (uc->cmd) {
 
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 60d6a6d..69ad494 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -4997,7 +4997,7 @@ struct sym_lcb *sym_alloc_lcb (struct sym_hcb *np, u_char tn, u_char ln)
 	 */
 	if (ln && !tp->lunmp) {
 		tp->lunmp = kcalloc(SYM_CONF_MAX_LUN, sizeof(struct sym_lcb *),
-				GFP_KERNEL);
+				GFP_ATOMIC);
 		if (!tp->lunmp)
 			goto fail;
 	}
@@ -5017,6 +5017,7 @@ struct sym_lcb *sym_alloc_lcb (struct sym_hcb *np, u_char tn, u_char ln)
 		tp->lun0p = lp;
 		tp->head.lun0_sa = cpu_to_scr(vtobus(lp));
 	}
+	tp->nlcb++;
 
 	/*
 	 *  Let the itl task point to error handling.
@@ -5094,6 +5095,43 @@ fail:
 }
 
 /*
+ *  Lun control block deallocation. Returns the number of valid remaing LCBs
+ *  for the target.
+ */
+int sym_free_lcb(struct sym_hcb *np, u_char tn, u_char ln)
+{
+	struct sym_tcb *tp = &np->target[tn];
+	struct sym_lcb *lp = sym_lp(tp, ln);
+
+	tp->nlcb--;
+
+	if (ln) {
+		if (!tp->nlcb) {
+			kfree(tp->lunmp);
+			sym_mfree_dma(tp->luntbl, 256, "LUNTBL");
+			tp->lunmp = NULL;
+			tp->luntbl = NULL;
+			tp->head.luntbl_sa = cpu_to_scr(vtobus(np->badluntbl));
+		} else {
+			tp->luntbl[ln] = cpu_to_scr(vtobus(&np->badlun_sa));
+			tp->lunmp[ln] = NULL;
+		}
+	} else {
+		tp->lun0p = NULL;
+		tp->head.lun0_sa = cpu_to_scr(vtobus(&np->badlun_sa));
+	}
+
+	if (lp->itlq_tbl) {
+		sym_mfree_dma(lp->itlq_tbl, SYM_CONF_MAX_TASK*4, "ITLQ_TBL");
+		kfree(lp->cb_tags);
+	}
+
+	sym_mfree_dma(lp, sizeof(*lp), "LCB");
+
+	return tp->nlcb;
+}
+
+/*
  *  Queue a SCSI IO to the controller.
  */
 int sym_queue_scsiio(struct sym_hcb *np, struct scsi_cmnd *cmd, struct sym_ccb *cp)
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.h b/drivers/scsi/sym53c8xx_2/sym_hipd.h
index 1588c90..e4ce480 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.h
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.h
@@ -401,6 +401,7 @@ struct sym_tcb {
 	 *  An array of bus addresses is used on reselection.
 	 */
 	u32	*luntbl;	/* LCBs bus address table	*/
+	int	nlcb;		/* Number of valid LCBs (including LUN #0) */
 
 	/*
 	 *  LUN table used by the C code.
@@ -1065,6 +1066,7 @@ int sym_clear_tasks(struct sym_hcb *np, int cam_status, int target, int lun, int
 struct sym_ccb *sym_get_ccb(struct sym_hcb *np, struct scsi_cmnd *cmd, u_char tag_order);
 void sym_free_ccb(struct sym_hcb *np, struct sym_ccb *cp);
 struct sym_lcb *sym_alloc_lcb(struct sym_hcb *np, u_char tn, u_char ln);
+int sym_free_lcb(struct sym_hcb *np, u_char tn, u_char ln);
 int sym_queue_scsiio(struct sym_hcb *np, struct scsi_cmnd *csio, struct sym_ccb *cp);
 int sym_abort_scsiio(struct sym_hcb *np, struct scsi_cmnd *ccb, int timed_out);
 int sym_reset_scsi_target(struct sym_hcb *np, int target);
-- 
1.6.0.6

