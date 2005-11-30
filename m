From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 3/11] [SYM2] Manage sym_lcb properly
Date: Tue, 29 Nov 2005 23:08:31 -0500 (EST)
Message-ID: <20051130040831.DEB7C7626F@gonzo>
References: <20051130040537.GC1597@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2-old.magma.ca ([206.191.0.250]:54974 "EHLO mx2.magma.ca")
	by vger.kernel.org with ESMTP id S1750842AbVK3EIe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Nov 2005 23:08:34 -0500
Received: from mail1.magma.ca (mail1.magma.ca [206.191.0.252])
	by mx2.magma.ca (8.13.0/8.13.0) with ESMTP id jAU48Xft014233
	for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2005 23:08:34 -0500
Received: from gonzo (ottawa-hs-209-217-123-220.d-ip.magma.ca [209.217.123.220])
	by mail1.magma.ca (8.13.0/8.13.0) with ESMTP id jAU48VHK000542
	for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2005 23:08:32 -0500
In-Reply-To: <20051130040537.GC1597@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Allocate the lcb in slave_alloc and free it in slave_destroy.  This allows
us to remove all the code that checks to see if it's already been allocated.

From: Christoph Hellwig <hch@lst.de>
Signed-off-by: Matthew Wilcox <matthew@wil.cx>

---

 drivers/scsi/sym53c8xx_2/sym_glue.c |   59 +++++++++++++-----------
 drivers/scsi/sym53c8xx_2/sym_hipd.c |   86 +++--------------------------------
 drivers/scsi/sym53c8xx_2/sym_hipd.h |   14 ------
 3 files changed, 38 insertions(+), 121 deletions(-)

applies-to: 39aa6a194e7e6c1d9161ef6a8163cbd8d5874abc
d1fa3658c5837cd3284f0cee1d03025b6eff4f50
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index d76766c..60beee2 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -563,10 +563,7 @@ int sym_setup_data_and_start(struct sym_
 	/*
 	 *	activate this job.
 	 */
-	if (lp)
-		sym_start_next_ccbs(np, lp, 2);
-	else
-		sym_put_start_queue(np, cp);
+	sym_start_next_ccbs(np, lp, 2);
 	return 0;
 
 out_abort:
@@ -981,15 +978,13 @@ static int device_queue_depth(struct sym
 
 static int sym53c8xx_slave_alloc(struct scsi_device *sdev)
 {
-	struct sym_hcb *np;
-	struct sym_tcb *tp;
+	struct sym_hcb *np = sym_get_hcb(sdev->host);
+	struct sym_tcb *tp = &np->target[sdev->id];
+	struct sym_lcb *lp;
 
 	if (sdev->id >= SYM_CONF_MAX_TARGET || sdev->lun >= SYM_CONF_MAX_LUN)
 		return -ENXIO;
 
-	np = sym_get_hcb(sdev->host);
-	tp = &np->target[sdev->id];
-
 	/*
 	 * Fail the device init if the device is flagged NOSCAN at BOOT in
 	 * the NVRAM.  This may speed up boot and maintain coherency with
@@ -1005,6 +1000,10 @@ static int sym53c8xx_slave_alloc(struct 
 		return -ENXIO;
 	}
 
+	lp = sym_alloc_lcb(np, sdev->id, sdev->lun);
+	if (!lp)
+		return -ENOMEM;
+
 	tp->starget = sdev->sdev_target;
 	return 0;
 }
@@ -1012,22 +1011,14 @@ static int sym53c8xx_slave_alloc(struct 
 /*
  * Linux entry point for device queue sizing.
  */
-static int sym53c8xx_slave_configure(struct scsi_device *device)
+static int sym53c8xx_slave_configure(struct scsi_device *sdev)
 {
-	struct sym_hcb *np = sym_get_hcb(device->host);
-	struct sym_tcb *tp = &np->target[device->id];
-	struct sym_lcb *lp;
+	struct sym_hcb *np = sym_get_hcb(sdev->host);
+	struct sym_tcb *tp = &np->target[sdev->id];
+	struct sym_lcb *lp = sym_lp(tp, sdev->lun);
 	int reqtags, depth_to_use;
 
 	/*
-	 *  Allocate the LCB if not yet.
-	 *  If it fail, we may well be in the sh*t. :)
-	 */
-	lp = sym_alloc_lcb(np, device->id, device->lun);
-	if (!lp)
-		return -ENOMEM;
-
-	/*
 	 *  Get user flags.
 	 */
 	lp->curr_flags = lp->user_flags;
@@ -1038,10 +1029,10 @@ static int sym53c8xx_slave_configure(str
 	 *  Use at least 2.
 	 *  Donnot use more than our maximum.
 	 */
-	reqtags = device_queue_depth(np, device->id, device->lun);
+	reqtags = device_queue_depth(np, sdev->id, sdev->lun);
 	if (reqtags > tp->usrtags)
 		reqtags = tp->usrtags;
-	if (!device->tagged_supported)
+	if (!sdev->tagged_supported)
 		reqtags = 0;
 #if 1 /* Avoid to locally queue commands for no good reasons */
 	if (reqtags > SYM_CONF_MAX_TAG)
@@ -1050,19 +1041,30 @@ static int sym53c8xx_slave_configure(str
 #else
 	depth_to_use = (reqtags ? SYM_CONF_MAX_TAG : 2);
 #endif
-	scsi_adjust_queue_depth(device,
-				(device->tagged_supported ?
+	scsi_adjust_queue_depth(sdev,
+				(sdev->tagged_supported ?
 				 MSG_SIMPLE_TAG : 0),
 				depth_to_use);
 	lp->s.scdev_depth = depth_to_use;
-	sym_tune_dev_queuing(tp, device->lun, reqtags);
+	sym_tune_dev_queuing(tp, sdev->lun, reqtags);
 
-	if (!spi_initial_dv(device->sdev_target))
-		spi_dv_device(device);
+	if (!spi_initial_dv(sdev->sdev_target))
+		spi_dv_device(sdev);
 
 	return 0;
 }
 
+static void sym53c8xx_slave_destroy(struct scsi_device *sdev)
+{
+	struct sym_hcb *np = sym_get_hcb(sdev->host);
+	struct sym_lcb *lp = sym_lp(&np->target[sdev->id], sdev->lun);
+
+	if (lp->itlq_tbl)
+		sym_mfree_dma(lp->itlq_tbl, SYM_CONF_MAX_TASK * 4, "ITLQ_TBL");
+	kfree(lp->cb_tags);
+	sym_mfree_dma(lp, sizeof(*lp), "LCB");
+}
+
 /*
  *  Linux entry point for info() function
  */
@@ -1926,6 +1928,7 @@ static struct scsi_host_template sym2_te
 	.queuecommand		= sym53c8xx_queue_command,
 	.slave_alloc		= sym53c8xx_slave_alloc,
 	.slave_configure	= sym53c8xx_slave_configure,
+	.slave_destroy		= sym53c8xx_slave_destroy,
 	.eh_abort_handler	= sym53c8xx_eh_abort_handler,
 	.eh_device_reset_handler = sym53c8xx_eh_device_reset_handler,
 	.eh_bus_reset_handler	= sym53c8xx_eh_bus_reset_handler,
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 113e3b3..bec6448 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -1523,7 +1523,7 @@ static int sym_prepare_nego(struct sym_h
 /*
  *  Insert a job into the start queue.
  */
-void sym_put_start_queue(struct sym_hcb *np, struct sym_ccb *cp)
+static void sym_put_start_queue(struct sym_hcb *np, struct sym_ccb *cp)
 {
 	u_short	qidx;
 
@@ -4664,30 +4664,7 @@ struct sym_ccb *sym_get_ccb (struct sym_
 		goto out;
 	cp = sym_que_entry(qp, struct sym_ccb, link_ccbq);
 
-#ifndef SYM_OPT_HANDLE_DEVICE_QUEUEING
-	/*
-	 *  If the LCB is not yet available and the LUN
-	 *  has been probed ok, try to allocate the LCB.
-	 */
-	if (!lp && sym_is_bit(tp->lun_map, ln)) {
-		lp = sym_alloc_lcb(np, tn, ln);
-		if (!lp)
-			goto out_free;
-	}
-#endif
-
-	/*
-	 *  If the LCB is not available here, then the 
-	 *  logical unit is not yet discovered. For those 
-	 *  ones only accept 1 SCSI IO per logical unit, 
-	 *  since we cannot allow disconnections.
-	 */
-	if (!lp) {
-		if (!sym_is_bit(tp->busy0_map, ln))
-			sym_set_bit(tp->busy0_map, ln);
-		else
-			goto out_free;
-	} else {
+	{
 		/*
 		 *  If we have been asked for a tagged command.
 		 */
@@ -4840,12 +4817,6 @@ void sym_free_ccb (struct sym_hcb *np, s
 			lp->head.resel_sa =
 				cpu_to_scr(SCRIPTB_BA(np, resel_bad_lun));
 	}
-	/*
-	 *  Otherwise, we only accept 1 IO per LUN.
-	 *  Clear the bit that keeps track of this IO.
-	 */
-	else
-		sym_clr_bit(tp->busy0_map, cp->lun);
 
 	/*
 	 *  We donnot queue more than 1 ccb per target 
@@ -4997,20 +4968,7 @@ static void sym_init_tcb (struct sym_hcb
 struct sym_lcb *sym_alloc_lcb (struct sym_hcb *np, u_char tn, u_char ln)
 {
 	struct sym_tcb *tp = &np->target[tn];
-	struct sym_lcb *lp = sym_lp(tp, ln);
-
-	/*
-	 *  Already done, just return.
-	 */
-	if (lp)
-		return lp;
-
-	/*
-	 *  Donnot allow LUN control block 
-	 *  allocation for not probed LUNs.
-	 */
-	if (!sym_is_bit(tp->lun_map, ln))
-		return NULL;
+	struct sym_lcb *lp = NULL;
 
 	/*
 	 *  Initialize the target control block if not yet.
@@ -5082,13 +5040,7 @@ struct sym_lcb *sym_alloc_lcb (struct sy
 	lp->started_max   = SYM_CONF_MAX_TASK;
 	lp->started_limit = SYM_CONF_MAX_TASK;
 #endif
-	/*
-	 *  If we are busy, count the IO.
-	 */
-	if (sym_is_bit(tp->busy0_map, ln)) {
-		lp->busy_itl = 1;
-		sym_clr_bit(tp->busy0_map, ln);
-	}
+
 fail:
 	return lp;
 }
@@ -5103,12 +5055,6 @@ static void sym_alloc_lcb_tags (struct s
 	int i;
 
 	/*
-	 *  If LCB not available, try to allocate it.
-	 */
-	if (!lp && !(lp = sym_alloc_lcb(np, tn, ln)))
-		goto fail;
-
-	/*
 	 *  Allocate the task table and and the tag allocation 
 	 *  circular buffer. We want both or none.
 	 */
@@ -5481,8 +5427,7 @@ finish:
 	/*
 	 *  Donnot start more than 1 command after an error.
 	 */
-	if (lp)
-		sym_start_next_ccbs(np, lp, 1);
+	sym_start_next_ccbs(np, lp, 1);
 #endif
 }
 
@@ -5521,12 +5466,6 @@ void sym_complete_ok (struct sym_hcb *np
 	lp = sym_lp(tp, cp->lun);
 
 	/*
-	 *  Assume device discovered on first success.
-	 */
-	if (!lp)
-		sym_set_bit(tp->lun_map, cp->lun);
-
-	/*
 	 *  If all data have been transferred, given than no
 	 *  extended error did occur, there is no residual.
 	 */
@@ -5578,7 +5517,7 @@ if (resid)
 	/*
 	 *  Requeue a couple of awaiting scsi commands.
 	 */
-	if (lp && !sym_que_empty(&lp->waiting_ccbq))
+	if (!sym_que_empty(&lp->waiting_ccbq))
 		sym_start_next_ccbs(np, lp, 2);
 #endif
 	/*
@@ -5821,8 +5760,7 @@ void sym_hcb_free(struct sym_hcb *np)
 	SYM_QUEHEAD *qp;
 	struct sym_ccb *cp;
 	struct sym_tcb *tp;
-	struct sym_lcb *lp;
-	int target, lun;
+	int target;
 
 	if (np->scriptz0)
 		sym_mfree_dma(np->scriptz0, np->scriptz_sz, "SCRIPTZ0");
@@ -5848,16 +5786,6 @@ void sym_hcb_free(struct sym_hcb *np)
 
 	for (target = 0; target < SYM_CONF_MAX_TARGET ; target++) {
 		tp = &np->target[target];
-		for (lun = 0 ; lun < SYM_CONF_MAX_LUN ; lun++) {
-			lp = sym_lp(tp, lun);
-			if (!lp)
-				continue;
-			if (lp->itlq_tbl)
-				sym_mfree_dma(lp->itlq_tbl, SYM_CONF_MAX_TASK*4,
-				       "ITLQ_TBL");
-			kfree(lp->cb_tags);
-			sym_mfree_dma(lp, sizeof(*lp), "LCB");
-		}
 #if SYM_CONF_MAX_LUN > 1
 		kfree(tp->lunmp);
 #endif 
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.h b/drivers/scsi/sym53c8xx_2/sym_hipd.h
index 3a264a4..7560088 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.h
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.h
@@ -416,19 +416,6 @@ struct sym_tcb {
 	struct sym_lcb **lunmp;		/* Other LCBs [1..MAX_LUN]	*/
 #endif
 
-	/*
-	 *  Bitmap that tells about LUNs that succeeded at least 
-	 *  1 IO and therefore assumed to be a real device.
-	 *  Avoid useless allocation of the LCB structure.
-	 */
-	u32	lun_map[(SYM_CONF_MAX_LUN+31)/32];
-
-	/*
-	 *  Bitmap that tells about LUNs that haven't yet an LCB 
-	 *  allocated (not discovered or LCB allocation failed).
-	 */
-	u32	busy0_map[(SYM_CONF_MAX_LUN+31)/32];
-
 #ifdef	SYM_HAVE_STCB
 	/*
 	 *  O/S specific data structure.
@@ -1077,7 +1064,6 @@ char *sym_driver_name(void);
 void sym_print_xerr(struct scsi_cmnd *cmd, int x_status);
 int sym_reset_scsi_bus(struct sym_hcb *np, int enab_int);
 struct sym_chip *sym_lookup_chip_table(u_short device_id, u_char revision);
-void sym_put_start_queue(struct sym_hcb *np, struct sym_ccb *cp);
 #ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
 void sym_start_next_ccbs(struct sym_hcb *np, struct sym_lcb *lp, int maxn);
 #endif
---
0.99.9.GIT
