From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 6/9] mpt fusion: error recovery improvements, and synchronizing internal commands
Date: Mon, 17 Sep 2007 19:59:52 -0600
Message-ID: <20070918015952.GA22742@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:62026 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754310AbXIRCIg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Sep 2007 22:08:36 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

1) cleanup ioc_reset callback handlers, introducing wrappers for synronizing error recovery (mpt_set_taskmgmt_in_progress_flag, mpt_clear_taskmgmt_in_progress_flag), as the fusion firmware only handles one task management request at a time.
2) set vtarget->deleted flag when devices have been removed.
3) mdr@sgi.com - fix's provided from SGI after testing with single threaded internal commands


Signed-off-by: Eric Moore <Eric.Moore@lsi.com>

--- b/drivers/message/fusion/mptfc.c	2007-09-17 16:35:48.000000000 -0600
+++ a/drivers/message/fusion/mptfc.c	2007-09-17 15:05:33.000000000 -0600
@@ -476,6 +476,7 @@ mptfc_register_dev(MPT_ADAPTER *ioc, int
 				if (vtarget) {
 					vtarget->id = pg0->CurrentTargetID;
 					vtarget->channel = pg0->CurrentBus;
+					vtarget->deleted = 0;
 				}
 			}
 			*((struct mptfc_rport_info **)rport->dd_data) = ri;
@@ -614,7 +615,6 @@ mptfc_slave_alloc(struct scsi_device *sd
 
 	hd = shost_priv(sdev->host);
 	ioc = hd->ioc;
-
 	vdevice = kzalloc(sizeof(VirtDevice), GFP_KERNEL);
 	if (!vdevice) {
 		printk(MYIOC_s_ERR_FMT "slave_alloc kmalloc(%zd) FAILED!\n",
@@ -944,11 +944,12 @@ start_over:
 	return rc;
 }
 
-static void
+static int
 mptfc_SetFcPortPage1_defaults(MPT_ADAPTER *ioc)
 {
 	int		ii;
 	FCPortPage1_t	*pp1;
+	int		rc;
 
 	#define MPTFC_FW_DEVICE_TIMEOUT	(1)
 	#define MPTFC_FW_IO_PEND_TIMEOUT (1)
@@ -956,8 +957,8 @@ mptfc_SetFcPortPage1_defaults(MPT_ADAPTE
 	#define OFF_FLAGS (MPI_FCPORTPAGE1_FLAGS_VERBOSE_RESCAN_EVENTS)
 
 	for (ii=0; ii<ioc->facts.NumberOfPorts; ii++) {
-		if (mptfc_GetFcPortPage1(ioc, ii) != 0)
-			continue;
+		if ((rc = mptfc_GetFcPortPage1(ioc, ii)) < 0)
+			return rc;
 		pp1 = ioc->fc_data.fc_port_page1[ii].data;
 		if ((pp1->InitiatorDeviceTimeout == MPTFC_FW_DEVICE_TIMEOUT)
 		 && (pp1->InitiatorIoPendTimeout == MPTFC_FW_IO_PEND_TIMEOUT)
@@ -968,8 +969,10 @@ mptfc_SetFcPortPage1_defaults(MPT_ADAPTE
 		pp1->InitiatorIoPendTimeout = MPTFC_FW_IO_PEND_TIMEOUT;
 		pp1->Flags &= ~OFF_FLAGS;
 		pp1->Flags |= ON_FLAGS;
-		mptfc_WriteFcPortPage1(ioc, ii);
+		if ((rc = mptfc_WriteFcPortPage1(ioc, ii)) < 0)
+			return rc;
 	}
+	return 0;
 }
 
 
@@ -1086,6 +1089,8 @@ mptfc_setup_reset(struct work_struct *wo
 		container_of(work, MPT_ADAPTER, fc_setup_reset_work);
 	u64			pn;
 	struct mptfc_rport_info *ri;
+	struct scsi_target      *starget;
+	VirtTarget              *vtarget;
 
 	/* reset about to happen, delete (block) all rports */
 	list_for_each_entry(ri, &ioc->fc_rports, list) {
@@ -1093,6 +1098,12 @@ mptfc_setup_reset(struct work_struct *wo
 			ri->flags &= ~MPT_RPORT_INFO_FLAGS_REGISTERED;
 			fc_remote_port_delete(ri->rport);	/* won't sleep */
 			ri->rport = NULL;
+			starget = ri->starget;
+			if (starget) {
+				vtarget = starget->hostdata;
+				if (vtarget)
+					vtarget->deleted = 1;
+			}
 
 			pn = (u64)ri->pg0.WWPN.High << 32 |
 			     (u64)ri->pg0.WWPN.Low;
@@ -1111,8 +1122,22 @@ mptfc_rescan_devices(struct work_struct 
 	MPT_ADAPTER		*ioc =
 		container_of(work, MPT_ADAPTER, fc_rescan_work);
 	int			ii;
+	int			rc;
 	u64			pn;
 	struct mptfc_rport_info *ri;
+	struct scsi_target      *starget;
+	VirtTarget              *vtarget;
+
+	/*
+	 * if cannot set defaults, something's really wrong, bail out
+	 */
+
+	if ((rc = mptfc_SetFcPortPage1_defaults(ioc)) < 0) {
+		dfcprintk (ioc, printk(MYIOC_s_DEBUG_FMT
+		    "mptfc_rescan.%d: unable to set PP1 defaults, rc %d.\n",
+		    ioc->name, ioc->sh->host_no, rc));
+		return;
+	}
 
 	/* start by tagging all ports as missing */
 	list_for_each_entry(ri, &ioc->fc_rports, list) {
@@ -1140,6 +1165,12 @@ mptfc_rescan_devices(struct work_struct 
 				       MPT_RPORT_INFO_FLAGS_MISSING);
 			fc_remote_port_delete(ri->rport);	/* won't sleep */
 			ri->rport = NULL;
+			starget = ri->starget;
+			if (starget) {
+				vtarget = starget->hostdata;
+				if (vtarget)
+					vtarget->deleted = 1;
+			}
 
 			pn = (u64)ri->pg0.WWPN.High << 32 |
 			     (u64)ri->pg0.WWPN.Low;
@@ -1292,30 +1323,6 @@ mptfc_probe(struct pci_dev *pdev, const 
 	dprintk(ioc, printk(MYIOC_s_DEBUG_FMT "ScsiLookup @ %p\n",
 		 ioc->name, ioc->ScsiLookup));
 
-	/* Clear the TM flags
-	 */
-	hd->tmPending = 0;
-	hd->tmState = TM_STATE_NONE;
-	hd->resetPending = 0;
-	hd->abortSCpnt = NULL;
-
-	/* Clear the pointer used to store
-	 * single-threaded commands, i.e., those
-	 * issued during a bus scan, dv and
-	 * configuration pages.
-	 */
-	hd->cmdPtr = NULL;
-
-	/* Initialize this SCSI Hosts' timers
-	 * To use, set the timer expires field
-	 * and add_timer
-	 */
-	init_timer(&hd->timer);
-	hd->timer.data = (unsigned long) hd;
-	hd->timer.function = mptscsih_timer_expired;
-
-	init_waitqueue_head(&hd->scandv_waitq);
-	hd->scandv_wait_done = 0;
 	hd->last_queue_full = 0;
 
 	sh->transportt = mptfc_transport_template;
@@ -1342,7 +1349,6 @@ mptfc_probe(struct pci_dev *pdev, const 
 	for (ii=0; ii < ioc->facts.NumberOfPorts; ii++) {
 		(void) mptfc_GetFcPortPage0(ioc, ii);
 	}
-	mptfc_SetFcPortPage1_defaults(ioc);
 
 	/*
 	 * scan for rports -
@@ -1380,9 +1386,6 @@ mptfc_event_process(MPT_ADAPTER *ioc, Ev
 	unsigned long flags;
 	int rc=1;
 
-	devtverboseprintk(ioc, printk(MYIOC_s_DEBUG_FMT "MPT event (=%02Xh) routed to SCSI host driver!\n",
-			ioc->name, event));
-
 	if (ioc->sh == NULL ||
 		((hd = shost_priv(ioc->sh)) == NULL))
 		return 1;
@@ -1418,35 +1421,36 @@ mptfc_ioc_reset(MPT_ADAPTER *ioc, int re
 	unsigned long	flags;
 
 	rc = mptscsih_ioc_reset(ioc,reset_phase);
-	if (rc == 0)
+	if ((ioc->bus_type != FC) || (!rc))
 		return rc;
 
-
-	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-		": IOC %s_reset routed to FC host driver!\n",ioc->name,
-		reset_phase==MPT_IOC_SETUP_RESET ? "setup" : (
-		reset_phase==MPT_IOC_PRE_RESET ? "pre" : "post")));
-
-	if (reset_phase == MPT_IOC_SETUP_RESET) {
+	switch(reset_phase) {
+	case MPT_IOC_SETUP_RESET:
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "%s: MPT_IOC_SETUP_RESET\n", ioc->name, __FUNCTION__));
 		spin_lock_irqsave(&ioc->fc_rescan_work_lock, flags);
 		if (ioc->fc_rescan_work_q) {
 			queue_work(ioc->fc_rescan_work_q,
 				   &ioc->fc_setup_reset_work);
 		}
 		spin_unlock_irqrestore(&ioc->fc_rescan_work_lock, flags);
-	}
-
-	else if (reset_phase == MPT_IOC_PRE_RESET) {
-	}
-
-	else {	/* MPT_IOC_POST_RESET */
-		mptfc_SetFcPortPage1_defaults(ioc);
+		break;
+	case MPT_IOC_PRE_RESET:
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "%s: MPT_IOC_PRE_RESET\n", ioc->name, __FUNCTION__));
+		break;
+	case MPT_IOC_POST_RESET:
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "%s: MPT_IOC_POST_RESET\n",  ioc->name, __FUNCTION__));
 		spin_lock_irqsave(&ioc->fc_rescan_work_lock, flags);
 		if (ioc->fc_rescan_work_q) {
 			queue_work(ioc->fc_rescan_work_q,
 				   &ioc->fc_rescan_work);
 		}
 		spin_unlock_irqrestore(&ioc->fc_rescan_work_lock, flags);
+		break;
+	default:
+		break;
 	}
 	return 1;
 }
