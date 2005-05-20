From: Matthew Wilcox <matthew@wil.cx>
Subject: sym2 version 2.2.1
Date: Fri, 20 May 2005 20:15:43 +0100
Message-ID: <20050520191543.GG6857@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:13495 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261533AbVETTPR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 May 2005 15:15:17 -0400
Received: from willy by parcelfarce.linux.theplanet.co.uk with local (Exim 4.43)
	id 1DZCyF-0000Fa-Va
	for linux-scsi@vger.kernel.org; Fri, 20 May 2005 20:15:44 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


sym2 version 2.2.1:
 - Fix MMIO BAR detection (Thanks to Bob Picco)
 - Fix odd-sized transfers with a wide bus (Thanks to Larry Stephens)
 - Write posting fixes (Thanks to Thibaut Varene)
 - Change one of the GFP_KERNEL allocations back into a GFP_ATOMIC
 - Make CCB_BA() return a script-endian address
 - Move range checks and disabling of devices from the queuecommand path
   to slave_alloc() 
 - Remove a warning in sym_setup_cdb()
 - Keep a pointer to the scsi_target instead of the scsi_dev in the tcb
 - Remove a check for the upper layers passing an oversized cmd
 - Replace CAM_REQ_ constants with the Linux DID_ constants
 - Replace CAM_DIR_ constants with the Linux DMA_ constants
 - Inline sym_read_parisc_pdc() on non-parisc systems

diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_defs.h parisc-2.6/drivers/scsi/sym53c8xx_2/sym_defs.h
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_defs.h	2005-03-18 06:21:13.000000000 -0700
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_defs.h	2005-05-20 08:22:30.000854197 -0600
@@ -40,7 +40,7 @@
 #ifndef SYM_DEFS_H
 #define SYM_DEFS_H
 
-#define SYM_VERSION "2.2.0"
+#define SYM_VERSION "2.2.1"
 #define SYM_DRIVER_NAME	"sym-" SYM_VERSION
 
 /*
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c parisc-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c	2005-05-08 20:03:38.000000000 -0600
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c	2005-05-20 12:38:10.465339985 -0600
@@ -155,10 +155,11 @@ pci_get_base_address(struct pci_dev *pde
 	base = tmp;
 	if ((tmp & 0x7) == PCI_BASE_ADDRESS_MEM_TYPE_64) {
 		pci_read_config_dword(pdev, PCI_BAR_OFFSET(index++), &tmp);
-		if (tmp > 0)
+		if (tmp > 0) {
 			dev_err(&pdev->dev,
 				"BAR %d is 64-bit, disabling\n", index - 1);
-		base = 0;
+			base = 0;
+		}
 	}
 
 	if ((base & PCI_BASE_ADDRESS_SPACE) == PCI_BASE_ADDRESS_SPACE_IO) {
@@ -389,13 +390,20 @@ static int sym_scatter_no_sglist(struct 
 {
 	struct sym_tblmove *data = &cp->phys.data[SYM_CONF_MAX_SG-1];
 	int segment;
+	unsigned int len = cmd->request_bufflen;
 
-	cp->data_len = cmd->request_bufflen;
-
-	if (cmd->request_bufflen) {
+	if (len) {
 		dma_addr_t baddr = map_scsi_single_data(np, cmd);
 		if (baddr) {
-			sym_build_sge(np, data, baddr, cmd->request_bufflen);
+			if (len & 1) {
+				struct sym_tcb *tp = &np->target[cp->target];
+				if (tp->head.wval & EWS) {
+					len++;
+					cp->odd_byte_adjustment++;
+				}
+			}
+			cp->data_len = len;
+			sym_build_sge(np, data, baddr, len);
 			segment = 1;
 		} else {
 			segment = -2;
@@ -418,6 +426,7 @@ static int sym_scatter(struct sym_hcb *n
 		segment = sym_scatter_no_sglist(np, cp, cmd);
 	else if ((use_sg = map_scsi_sg_data(np, cmd)) > 0) {
 		struct scatterlist *scatter = (struct scatterlist *)cmd->buffer;
+		struct sym_tcb *tp = &np->target[cp->target];
 		struct sym_tblmove *data;
 
 		if (use_sg > SYM_CONF_MAX_SG) {
@@ -431,6 +440,11 @@ static int sym_scatter(struct sym_hcb *n
 			dma_addr_t baddr = sg_dma_address(&scatter[segment]);
 			unsigned int len = sg_dma_len(&scatter[segment]);
 
+			if ((len & 1) && (tp->head.wval & EWS)) {
+				len++;
+				cp->odd_byte_adjustment++;
+			}
+
 			sym_build_sge(np, &data[segment], baddr, len);
 			cp->data_len += len;
 		}
@@ -456,10 +470,8 @@ static int sym_queue_command(struct sym_
 	 *  Minimal checkings, so that we will not 
 	 *  go outside our tables.
 	 */
-	if (sdev->id == np->myaddr ||
-	    sdev->id >= SYM_CONF_MAX_TARGET ||
-	    sdev->lun >= SYM_CONF_MAX_LUN) {
-		sym_xpt_done2(np, cmd, CAM_DEV_NOT_THERE);
+	if (sdev->id == np->myaddr) {
+		sym_xpt_done2(np, cmd, DID_NO_CONNECT);
 		return 0;
 	}
 
@@ -469,28 +481,6 @@ static int sym_queue_command(struct sym_
 	tp = &np->target[sdev->id];
 
 	/*
-	 *  Complete the 1st INQUIRY command with error 
-	 *  condition if the device is flagged NOSCAN 
-	 *  at BOOT in the NVRAM. This may speed up 
-	 *  the boot and maintain coherency with BIOS 
-	 *  device numbering. Clearing the flag allows 
-	 *  user to rescan skipped devices later.
-	 *  We also return error for devices not flagged 
-	 *  for SCAN LUNS in the NVRAM since some mono-lun 
-	 *  devices behave badly when asked for some non 
-	 *  zero LUN. Btw, this is an absolute hack.:-)
-	 */
-	if (cmd->cmnd[0] == 0x12 || cmd->cmnd[0] == 0x0) {
-		if ((tp->usrflags & SYM_SCAN_BOOT_DISABLED) ||
-		    ((tp->usrflags & SYM_SCAN_LUNS_DISABLED) && 
-		     sdev->lun != 0)) {
-			tp->usrflags &= ~SYM_SCAN_BOOT_DISABLED;
-			sym_xpt_done2(np, cmd, CAM_DEV_NOT_THERE);
-			return 0;
-		}
-	}
-
-	/*
 	 *  Select tagged/untagged.
 	 */
 	lp = sym_lp(tp, sdev->lun);
@@ -511,23 +501,10 @@ static int sym_queue_command(struct sym_
  */
 static inline int sym_setup_cdb(struct sym_hcb *np, struct scsi_cmnd *cmd, struct sym_ccb *cp)
 {
-	u32	cmd_ba;
-	int	cmd_len;
-
-	/*
-	 *  CDB is 16 bytes max.
-	 */
-	if (cmd->cmd_len > sizeof(cp->cdb_buf)) {
-		sym_set_cam_status(cp->cmd, CAM_REQ_INVALID);
-		return -1;
-	}
-
 	memcpy(cp->cdb_buf, cmd->cmnd, cmd->cmd_len);
-	cmd_ba  = CCB_BA (cp, cdb_buf[0]);
-	cmd_len = cmd->cmd_len;
 
-	cp->phys.cmd.addr	= cpu_to_scr(cmd_ba);
-	cp->phys.cmd.size	= cpu_to_scr(cmd_len);
+	cp->phys.cmd.addr = CCB_BA(cp, cdb_buf[0]);
+	cp->phys.cmd.size = cpu_to_scr(cmd->cmd_len);
 
 	return 0;
 }
@@ -554,10 +531,7 @@ int sym_setup_data_and_start(struct sym_
 	if (dir != DMA_NONE) {
 		cp->segments = sym_scatter(np, cp, cmd);
 		if (cp->segments < 0) {
-			if (cp->segments == -2)
-				sym_set_cam_status(cmd, CAM_RESRC_UNAVAIL);
-			else
-				sym_set_cam_status(cmd, CAM_REQ_TOO_BIG);
+			sym_set_cam_status(cmd, DID_ERROR);
 			goto out_abort;
 		}
 	} else {
@@ -855,7 +829,7 @@ prepare:
 	ep->to_do = to_do;
 	/* Complete the command with locks held as required by the driver */
 	if (to_do == SYM_EH_DO_COMPLETE)
-		sym_xpt_done2(np, cmd, CAM_REQ_ABORTED);
+		sym_xpt_done2(np, cmd, DID_ABORT);
 
 	/* Wait for completion with locks released, as required by kernel */
 	if (to_do == SYM_EH_DO_WAIT) {
@@ -921,7 +895,7 @@ static void sym_tune_dev_queuing(struct 
 	lp->s.reqtags     = reqtags;
 
 	if (reqtags != oldtags) {
-		dev_info(&tp->sdev->sdev_target->dev,
+		dev_info(&tp->starget->dev,
 		         "tagged command queuing %s, command queue depth %d.\n",
 		          lp->s.reqtags ? "enabled" : "disabled",
  		          lp->started_limit);
@@ -981,22 +955,34 @@ static int device_queue_depth(struct sym
 	return DEF_DEPTH;
 }
 
-static int sym53c8xx_slave_alloc(struct scsi_device *device)
+static int sym53c8xx_slave_alloc(struct scsi_device *sdev)
 {
-	struct sym_hcb *np = sym_get_hcb(device->host);
-	struct sym_tcb *tp = &np->target[device->id];
-	if (!tp->sdev)
-		tp->sdev = device;
+	struct sym_hcb *np;
+	struct sym_tcb *tp;
 
-	return 0;
-}
+	if (sdev->id >= SYM_CONF_MAX_TARGET || sdev->lun >= SYM_CONF_MAX_LUN)
+		return -ENXIO;
 
-static void sym53c8xx_slave_destroy(struct scsi_device *device)
-{
-	struct sym_hcb *np = sym_get_hcb(device->host);
-	struct sym_tcb *tp = &np->target[device->id];
-	if (tp->sdev == device)
-		tp->sdev = NULL;
+	np = sym_get_hcb(sdev->host);
+	tp = &np->target[sdev->id];
+
+	/*
+	 * Fail the device init if the device is flagged NOSCAN at BOOT in
+	 * the NVRAM.  This may speed up boot and maintain coherency with
+	 * BIOS device numbering.  Clearing the flag allows the user to
+	 * rescan skipped devices later.  We also return an error for
+	 * devices not flagged for SCAN LUNS in the NVRAM since some single
+	 * lun devices behave badly when asked for a non zero LUN.
+	 */
+
+	if ((tp->usrflags & SYM_SCAN_BOOT_DISABLED) ||
+	    ((tp->usrflags & SYM_SCAN_LUNS_DISABLED) && sdev->lun != 0)) {
+		tp->usrflags &= ~SYM_SCAN_BOOT_DISABLED;
+		return -ENXIO;
+	}
+
+	tp->starget = sdev->sdev_target;
+	return 0;
 }
 
 /*
@@ -1897,6 +1883,7 @@ static int sym_detach(struct sym_hcb *np
 	 */
 	printk("%s: resetting chip\n", sym_name(np));
 	OUTB(np, nc_istat, SRST);
+	INB(np, nc_mbox1);
 	udelay(10);
 	OUTB(np, nc_istat, 0);
 
@@ -1915,7 +1902,6 @@ static struct scsi_host_template sym2_te
 	.queuecommand		= sym53c8xx_queue_command,
 	.slave_alloc		= sym53c8xx_slave_alloc,
 	.slave_configure	= sym53c8xx_slave_configure,
-	.slave_destroy		= sym53c8xx_slave_destroy,
 	.eh_abort_handler	= sym53c8xx_eh_abort_handler,
 	.eh_device_reset_handler = sym53c8xx_eh_device_reset_handler,
 	.eh_bus_reset_handler	= sym53c8xx_eh_bus_reset_handler,
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_glue.h parisc-2.6/drivers/scsi/sym53c8xx_2/sym_glue.h
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_glue.h	2005-05-08 20:03:38.000000000 -0600
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_glue.h	2005-05-20 08:22:30.026854337 -0600
@@ -142,33 +142,6 @@
 #define scr_to_cpu(dw)	le32_to_cpu(dw)
 
 /*
- *  Remap some status field values.
- */
-#define CAM_REQ_CMP		DID_OK
-#define CAM_SEL_TIMEOUT		DID_NO_CONNECT
-#define CAM_CMD_TIMEOUT		DID_TIME_OUT
-#define CAM_REQ_ABORTED		DID_ABORT
-#define CAM_UNCOR_PARITY	DID_PARITY
-#define CAM_SCSI_BUS_RESET	DID_RESET	
-#define CAM_REQUEUE_REQ		DID_SOFT_ERROR
-#define	CAM_UNEXP_BUSFREE	DID_ERROR
-#define	CAM_SCSI_BUSY		DID_BUS_BUSY
-
-#define	CAM_DEV_NOT_THERE	DID_NO_CONNECT
-#define	CAM_REQ_INVALID		DID_ERROR
-#define	CAM_REQ_TOO_BIG		DID_ERROR
-
-#define	CAM_RESRC_UNAVAIL	DID_ERROR
-
-/*
- *  Remap data direction values.
- */
-#define CAM_DIR_NONE		DMA_NONE
-#define CAM_DIR_IN		DMA_FROM_DEVICE
-#define CAM_DIR_OUT		DMA_TO_DEVICE
-#define CAM_DIR_UNKNOWN		DMA_BIDIRECTIONAL
-
-/*
  *  These ones are used as return code from 
  *  error recovery handlers under Linux.
  */
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c parisc-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c	2005-05-08 20:03:38.000000000 -0600
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c	2005-05-20 12:38:10.492340128 -0600
@@ -97,7 +97,7 @@ static void sym_print_msg(struct sym_ccb
 static void sym_print_nego_msg(struct sym_hcb *np, int target, char *label, u_char *msg)
 {
 	struct sym_tcb *tp = &np->target[target];
-	dev_info(&tp->sdev->sdev_target->dev, "%s: ", label);
+	dev_info(&tp->starget->dev, "%s: ", label);
 
 	sym_show_msg(msg);
 	printf(".\n");
@@ -149,8 +149,10 @@ static char *sym_scsi_bus_mode(int mode)
 static void sym_chip_reset (struct sym_hcb *np)
 {
 	OUTB(np, nc_istat, SRST);
+	INB(np, nc_mbox1);
 	udelay(10);
 	OUTB(np, nc_istat, 0);
+	INB(np, nc_mbox1);
 	udelay(2000);	/* For BUS MODE to settle */
 }
 
@@ -216,6 +218,7 @@ int sym_reset_scsi_bus(struct sym_hcb *n
 	OUTB(np, nc_stest3, TE);
 	OUTB(np, nc_dcntl, (np->rv_dcntl & IRQM));
 	OUTB(np, nc_scntl1, CRST);
+	INB(np, nc_mbox1);
 	udelay(200);
 
 	if (!SYM_SETUP_SCSI_BUS_CHECK)
@@ -280,8 +283,10 @@ static void sym_selectclock(struct sym_h
 		if (!i)
 			printf("%s: the chip cannot lock the frequency\n",
 				sym_name(np));
-	} else
-		udelay((50+10));
+	} else {
+		INB(np, nc_mbox1);
+		udelay(50+10);
+	}
 	OUTB(np, nc_stest3, HSC);		/* Halt the scsi clock	*/
 	OUTB(np, nc_scntl3, scntl3);
 	OUTB(np, nc_stest1, (DBLEN|DBLSEL));/* Select clock multiplier	*/
@@ -1445,7 +1450,7 @@ static void sym_check_goals(struct sym_h
 static int sym_prepare_nego(struct sym_hcb *np, struct sym_ccb *cp, u_char *msgptr)
 {
 	struct sym_tcb *tp = &np->target[cp->target];
-	struct scsi_target *starget = tp->sdev->sdev_target;
+	struct scsi_target *starget = tp->starget;
 	struct sym_trans *goal = &tp->tgoal;
 	int msglen = 0;
 	int nego;
@@ -1690,7 +1695,7 @@ static void sym_flush_comp_queue(struct 
 		if (cam_status)
 			sym_set_cam_status(cmd, cam_status);
 #ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
-		if (sym_get_cam_status(cmd) == CAM_REQUEUE_REQ) {
+		if (sym_get_cam_status(cmd) == DID_SOFT_ERROR) {
 			struct sym_tcb *tp = &np->target[cp->target];
 			struct sym_lcb *lp = sym_lp(tp, cp->lun);
 			if (lp) {
@@ -1791,12 +1796,13 @@ void sym_start_up (struct sym_hcb *np, i
 	/*
 	 *  Wakeup all pending jobs.
 	 */
-	sym_flush_busy_queue(np, CAM_SCSI_BUS_RESET);
+	sym_flush_busy_queue(np, DID_RESET);
 
 	/*
 	 *  Init chip.
 	 */
 	OUTB(np, nc_istat,  0x00);			/*  Remove Reset, abort */
+	INB(np, nc_mbox1);
 	udelay(2000); /* The 895 needs time for the bus mode to settle */
 
 	OUTB(np, nc_scntl0, np->rv_scntl0 | 0xc0);
@@ -1905,6 +1911,7 @@ void sym_start_up (struct sym_hcb *np, i
 	if (np->features & (FE_ULTRA2|FE_ULTRA3)) {
 		OUTONW(np, nc_sien, SBMC);
 		if (reason == 0) {
+			INB(np, nc_mbox1);
 			mdelay(100);
 			INW(np, nc_sist);
 		}
@@ -2074,7 +2081,7 @@ static void sym_settrans(struct sym_hcb 
 static void sym_setwide(struct sym_hcb *np, int target, u_char wide)
 {
 	struct sym_tcb *tp = &np->target[target];
-	struct scsi_target *starget = tp->sdev->sdev_target;
+	struct scsi_target *starget = tp->starget;
 
 	if (spi_width(starget) == wide)
 		return;
@@ -2102,7 +2109,7 @@ sym_setsync(struct sym_hcb *np, int targ
             u_char ofs, u_char per, u_char div, u_char fak)
 {
 	struct sym_tcb *tp = &np->target[target];
-	struct scsi_target *starget = tp->sdev->sdev_target;
+	struct scsi_target *starget = tp->starget;
 	u_char wide = (tp->head.wval & EWS) ? BUS_16_BIT : BUS_8_BIT;
 
 	sym_settrans(np, target, 0, ofs, per, wide, div, fak);
@@ -2129,7 +2136,7 @@ sym_setpprot(struct sym_hcb *np, int tar
              u_char per, u_char wide, u_char div, u_char fak)
 {
 	struct sym_tcb *tp = &np->target[target];
-	struct scsi_target *starget = tp->sdev->sdev_target;
+	struct scsi_target *starget = tp->starget;
 
 	sym_settrans(np, target, opts, ofs, per, wide, div, fak);
 
@@ -2944,7 +2951,7 @@ unknown_int:
  *  Dequeue from the START queue all CCBs that match 
  *  a given target/lun/task condition (-1 means all),
  *  and move them from the BUSY queue to the COMP queue 
- *  with CAM_REQUEUE_REQ status condition.
+ *  with DID_SOFT_ERROR status condition.
  *  This function is used during error handling/recovery.
  *  It is called with SCRIPTS not running.
  */
@@ -2974,7 +2981,7 @@ sym_dequeue_from_squeue(struct sym_hcb *
 		if ((target == -1 || cp->target == target) &&
 		    (lun    == -1 || cp->lun    == lun)    &&
 		    (task   == -1 || cp->tag    == task)) {
-			sym_set_cam_status(cp->cmd, CAM_REQUEUE_REQ);
+			sym_set_cam_status(cp->cmd, DID_SOFT_ERROR);
 			sym_remque(&cp->link_ccbq);
 			sym_insque_tail(&cp->link_ccbq, &np->comp_ccbq);
 		}
@@ -3093,13 +3100,13 @@ static void sym_sir_bad_scsi_status(stru
 		/*
 		 *  Message table indirect structure.
 		 */
-		cp->phys.smsg.addr	= cpu_to_scr(CCB_BA(cp, scsi_smsg2));
+		cp->phys.smsg.addr	= CCB_BA(cp, scsi_smsg2);
 		cp->phys.smsg.size	= cpu_to_scr(msglen);
 
 		/*
 		 *  sense command
 		 */
-		cp->phys.cmd.addr	= cpu_to_scr(CCB_BA(cp, sensecmd));
+		cp->phys.cmd.addr	= CCB_BA(cp, sensecmd);
 		cp->phys.cmd.size	= cpu_to_scr(6);
 
 		/*
@@ -3116,7 +3123,7 @@ static void sym_sir_bad_scsi_status(stru
 		 *  sense data
 		 */
 		memset(cp->sns_bbuf, 0, SYM_SNS_BBUF_LEN);
-		cp->phys.sense.addr	= cpu_to_scr(CCB_BA(cp, sns_bbuf));
+		cp->phys.sense.addr	= CCB_BA(cp, sns_bbuf);
 		cp->phys.sense.size	= cpu_to_scr(SYM_SNS_BBUF_LEN);
 
 		/*
@@ -3198,7 +3205,7 @@ int sym_clear_tasks(struct sym_hcb *np, 
 		sym_insque_tail(&cp->link_ccbq, &np->comp_ccbq);
 
 		/* Preserve the software timeout condition */
-		if (sym_get_cam_status(cmd) != CAM_CMD_TIMEOUT)
+		if (sym_get_cam_status(cmd) != DID_TIME_OUT)
 			sym_set_cam_status(cmd, cam_status);
 		++i;
 #if 0
@@ -3366,7 +3373,7 @@ static void sym_sir_task_recovery(struct
 		 *  Make sure at least our IO to abort has been dequeued.
 		 */
 #ifndef SYM_OPT_HANDLE_DEVICE_QUEUEING
-		assert(i && sym_get_cam_status(cp->cmd) == CAM_REQUEUE_REQ);
+		assert(i && sym_get_cam_status(cp->cmd) == DID_SOFT_ERROR);
 #else
 		sym_remque(&cp->link_ccbq);
 		sym_insque_tail(&cp->link_ccbq, &np->comp_ccbq);
@@ -3375,9 +3382,9 @@ static void sym_sir_task_recovery(struct
 		 *  Keep track in cam status of the reason of the abort.
 		 */
 		if (cp->to_abort == 2)
-			sym_set_cam_status(cp->cmd, CAM_CMD_TIMEOUT);
+			sym_set_cam_status(cp->cmd, DID_TIME_OUT);
 		else
-			sym_set_cam_status(cp->cmd, CAM_REQ_ABORTED);
+			sym_set_cam_status(cp->cmd, DID_ABORT);
 
 		/*
 		 *  Complete with error everything that we have dequeued.
@@ -3491,7 +3498,7 @@ static void sym_sir_task_recovery(struct
 		 *  conditions not due to timeout.
 		 */
 		if (cp->to_abort == 2)
-			sym_set_cam_status(cp->cmd, CAM_CMD_TIMEOUT);
+			sym_set_cam_status(cp->cmd, DID_TIME_OUT);
 		cp->to_abort = 0; /* We donnot expect to fail here */
 		break;
 
@@ -3502,7 +3509,7 @@ static void sym_sir_task_recovery(struct
 	case SIR_ABORT_SENT:
 		target = INB(np, nc_sdid) & 0xf;
 		tp = &np->target[target];
-		starget = tp->sdev->sdev_target;
+		starget = tp->starget;
 		
 		/*
 		**  If we didn't abort anything, leave here.
@@ -3551,7 +3558,7 @@ static void sym_sir_task_recovery(struct
 		 */
 		i = (INL(np, nc_scratcha) - np->squeue_ba) / 4;
 		sym_dequeue_from_squeue(np, i, target, lun, -1);
-		sym_clear_tasks(np, CAM_REQ_ABORTED, target, lun, task);
+		sym_clear_tasks(np, DID_ABORT, target, lun, task);
 		sym_flush_comp_queue(np, 0);
 
  		/*
@@ -3566,7 +3573,7 @@ static void sym_sir_task_recovery(struct
 	 *  Print to the log the message we intend to send.
 	 */
 	if (num == SIR_TARGET_SELECTED) {
-		dev_info(&tp->sdev->sdev_target->dev, "control msgout:");
+		dev_info(&tp->starget->dev, "control msgout:");
 		sym_printl_hex(np->abrt_msg, np->abrt_tbl.size);
 		np->abrt_tbl.size = cpu_to_scr(np->abrt_tbl.size);
 	}
@@ -3877,6 +3884,8 @@ int sym_compute_residual(struct sym_hcb 
 		resid += (tmp & 0xffffff);
 	}
 
+	resid -= cp->odd_byte_adjustment;
+
 	/*
 	 *  Hopefully, the result is not too wrong.
 	 */
@@ -4758,10 +4767,8 @@ struct sym_ccb *sym_get_ccb (struct sym_
 	}
 
 #endif
-	/*
-	 *  Remember all informations needed to free this CCB.
-	 */
 	cp->to_abort = 0;
+	cp->odd_byte_adjustment = 0;
 	cp->tag	   = tag;
 	cp->order  = tag_order;
 	cp->target = tn;
@@ -5104,7 +5111,7 @@ static void sym_alloc_lcb_tags (struct s
 	lp->itlq_tbl = sym_calloc_dma(SYM_CONF_MAX_TASK*4, "ITLQ_TBL");
 	if (!lp->itlq_tbl)
 		goto fail;
-	lp->cb_tags = kcalloc(SYM_CONF_MAX_TASK, 1, GFP_KERNEL);
+	lp->cb_tags = kcalloc(SYM_CONF_MAX_TASK, 1, GFP_ATOMIC);
 	if (!lp->cb_tags) {
 		sym_mfree_dma(lp->itlq_tbl, SYM_CONF_MAX_TASK*4, "ITLQ_TBL");
 		lp->itlq_tbl = NULL;
@@ -5243,7 +5250,7 @@ int sym_queue_scsiio(struct sym_hcb *np,
 	/*
 	 *  message
 	 */
-	cp->phys.smsg.addr	= cpu_to_scr(CCB_BA(cp, scsi_smsg));
+	cp->phys.smsg.addr	= CCB_BA(cp, scsi_smsg);
 	cp->phys.smsg.size	= cpu_to_scr(msglen);
 
 	/*
@@ -5343,7 +5350,7 @@ int sym_abort_scsiio(struct sym_hcb *np,
 }
 
 /*
- *  Complete execution of a SCSI command with extented 
+ *  Complete execution of a SCSI command with extended 
  *  error, SCSI status error, or having been auto-sensed.
  *
  *  The SCRIPTS processor is not running there, so we 
@@ -5441,7 +5448,7 @@ if (resid)
 		/*
 		 *  Let's requeue it to device.
 		 */
-		sym_set_cam_status(cmd, CAM_REQUEUE_REQ);
+		sym_set_cam_status(cmd, DID_SOFT_ERROR);
 		goto finish;
 	}
 weirdness:
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.h parisc-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.h
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.h	2005-05-08 20:03:38.000000000 -0600
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.h	2005-05-20 08:22:30.093854697 -0600
@@ -444,7 +444,7 @@ struct sym_tcb {
 	 */
 	u_char	usrflags;
 	u_short	usrtags;
-	struct scsi_device *sdev;
+	struct scsi_target *starget;
 };
 
 /*
@@ -754,10 +754,8 @@ struct sym_ccb {
 	int	segments;	/* Number of SG segments	*/
 
 	u8	order;		/* Tag type (if tagged command)	*/
+	unsigned char odd_byte_adjustment;	/* odd-sized req on wide bus */
 
-	/*
-	 *  Miscellaneous status'.
-	 */
 	u_char	nego_status;	/* Negotiation status		*/
 	u_char	xerr_status;	/* Extended error flags		*/
 	u32	extra_bytes;	/* Extraneous bytes transferred	*/
@@ -809,7 +807,7 @@ struct sym_ccb {
 #endif
 };
 
-#define CCB_BA(cp,lbl)	(cp->ccb_ba + offsetof(struct sym_ccb, lbl))
+#define CCB_BA(cp,lbl)	cpu_to_scr(cp->ccb_ba + offsetof(struct sym_ccb, lbl))
 
 #ifdef	SYM_OPT_HANDLE_DIR_UNKNOWN
 #define	sym_goalp(cp) ((cp->host_flags & HF_DATA_IN) ? cp->goalp : cp->wgoalp)
@@ -1138,33 +1136,33 @@ static inline void sym_setup_data_pointe
 	 *  No segments means no data.
 	 */
 	if (!cp->segments)
-		dir = CAM_DIR_NONE;
+		dir = DMA_NONE;
 
 	/*
 	 *  Set the data pointer.
 	 */
 	switch(dir) {
 #ifdef	SYM_OPT_HANDLE_DIR_UNKNOWN
-	case CAM_DIR_UNKNOWN:
+	case DMA_BIDIRECTIONAL:
 #endif
-	case CAM_DIR_OUT:
+	case DMA_TO_DEVICE:
 		goalp = SCRIPTA_BA(np, data_out2) + 8;
 		lastp = goalp - 8 - (cp->segments * (2*4));
 #ifdef	SYM_OPT_HANDLE_DIR_UNKNOWN
 		cp->wgoalp = cpu_to_scr(goalp);
-		if (dir != CAM_DIR_UNKNOWN)
+		if (dir != DMA_BIDIRECTIONAL)
 			break;
 		cp->phys.head.wlastp = cpu_to_scr(lastp);
 		/* fall through */
 #else
 		break;
 #endif
-	case CAM_DIR_IN:
+	case DMA_FROM_DEVICE:
 		cp->host_flags |= HF_DATA_IN;
 		goalp = SCRIPTA_BA(np, data_in2) + 8;
 		lastp = goalp - 8 - (cp->segments * (2*4));
 		break;
-	case CAM_DIR_NONE:
+	case DMA_NONE:
 	default:
 #ifdef	SYM_OPT_HANDLE_DIR_UNKNOWN
 		cp->host_flags |= HF_DATA_IN;
@@ -1185,7 +1183,7 @@ static inline void sym_setup_data_pointe
 	/*
 	 *  If direction is unknown, start at data_io.
 	 */
-	if (dir == CAM_DIR_UNKNOWN)
+	if (dir == DMA_BIDIRECTIONAL)
 		cp->phys.head.savep = cpu_to_scr(SCRIPTB_BA(np, data_io));
 #endif
 }
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_nvram.c parisc-2.6/drivers/scsi/sym53c8xx_2/sym_nvram.c
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_nvram.c	2005-05-08 20:03:38.000000000 -0600
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_nvram.c	2005-05-20 12:38:10.500340171 -0600
@@ -270,6 +270,7 @@ static void S24C16_set_bit(struct sym_de
 
 	}
 	OUTB(np, nc_gpreg, *gpreg);
+	INB(np, nc_mbox1);
 	udelay(5);
 }
 
@@ -547,6 +548,7 @@ static int sym_read_Symbios_nvram(struct
 static void T93C46_Clk(struct sym_device *np, u_char *gpreg)
 {
 	OUTB(np, nc_gpreg, *gpreg | 0x04);
+	INB(np, nc_mbox1);
 	udelay(2);
 	OUTB(np, nc_gpreg, *gpreg);
 }
@@ -574,6 +576,7 @@ static void T93C46_Write_Bit(struct sym_
 	*gpreg |= 0x10;
 		
 	OUTB(np, nc_gpreg, *gpreg);
+	INB(np, nc_mbox1);
 	udelay(2);
 
 	T93C46_Clk(np, gpreg);
@@ -586,6 +589,7 @@ static void T93C46_Stop(struct sym_devic
 {
 	*gpreg &= 0xef;
 	OUTB(np, nc_gpreg, *gpreg);
+	INB(np, nc_mbox1);
 	udelay(2);
 
 	T93C46_Clk(np, gpreg);
@@ -733,7 +737,8 @@ static int sym_read_parisc_pdc(struct sy
 	return SYM_PARISC_PDC;
 }
 #else
-static int sym_read_parisc_pdc(struct sym_device *np, struct pdc_initiator *x)
+static inline int sym_read_parisc_pdc(struct sym_device *np,
+					struct pdc_initiator *x)
 {
 	return 0;
 }

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
