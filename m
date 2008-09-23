From: Bernd Schubert <bs@q-leap.de>
Subject: [ PATCH 1/4 ] mpt fusion SoftReset handler
Date: Tue, 23 Sep 2008 15:20:56 +0200
Message-ID: <200809231520.57630.bs@q-leap.de>
References: <200809231516.48197.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:48552 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbYIWNVJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Sep 2008 09:21:09 -0400
In-Reply-To: <200809231516.48197.bs@q-leap.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Eric Moore <Eric.Moore@lsi.com>, Sathya Prakash <Sathya.Prakash@lsi.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, DL-MPTFusionLinux@lsi.com

On dual port 53C1030 based HBAs such as the LSI22320R, the hard reset handler
will cause DID_SOFT_ERROR for innocent devices on the second port.
Introduce a mpt_SoftResetHandler() which doesn't cause this issue and 
slightly improve mpt_HardResetHandler().
This is mostly a backport of the fusion-4.x driver available from LSI.

Signed-off-by: Bernd Schubert <bs@q-leap.de>

 drivers/message/fusion/mptbase.c  |  211 ++++++++++++++++++++++++----
 drivers/message/fusion/mptbase.h  |   11 +
 drivers/message/fusion/mptctl.c   |    7
 drivers/message/fusion/mptsas.c   |    4
 drivers/message/fusion/mptscsih.c |   35 ++--
 5 files changed, 218 insertions(+), 50 deletions(-)

Index: linux-2.6.26/drivers/message/fusion/mptbase.c
===================================================================
--- linux-2.6.26.orig/drivers/message/fusion/mptbase.c
+++ linux-2.6.26/drivers/message/fusion/mptbase.c
@@ -5858,7 +5858,7 @@ mpt_timer_expired(unsigned long data)
 	dcprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mpt_timer_expired! \n", ioc->name));
 
 	/* Perform a FW reload */
-	if (mpt_HardResetHandler(ioc, NO_SLEEP) < 0)
+	if (mpt_SoftHardResetHandler(ioc, NO_SLEEP) < 0)
 		printk(MYIOC_s_WARN_FMT "Firmware Reload FAILED!\n", ioc->name);
 
 	/* No more processing.
@@ -6232,6 +6232,129 @@ mpt_print_ioc_summary(MPT_ADAPTER *ioc, 
 /*
  *	Reset Handling
  */
+
+/**
+ *	mpt_SoftResetHandler - Issues a less expensive reset
+ *	@ioc: Pointer to MPT_ADAPTER structure
+ *	@sleepFlag: Indicates if sleep or schedule must be called.
+
+ *
+ *	Returns 0 for SUCCESS or -1 if FAILED.
+ *
+ *	Message Unit Reset - instructs the IOC to reset the Reply Post and
+ *	Free FIFO's. All the Message Frames on Reply Free FIFO are discarded.
+ *	All posted buffers are freed, and event notification is turned off.
+ *	IOC doesnt reply to any outstanding request. This will transfer IOC
+ *	to READY state.
+ **/
+static int
+mpt_SoftResetHandler(MPT_ADAPTER *ioc, int sleepFlag)
+{
+	int		 rc;
+	int		 ii;
+	u8		 cb_idx;
+	unsigned long	 flags;
+	u32		 ioc_state;
+	unsigned long	 time_count;
+
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "SoftResetHandler Entered!\n",
+			      ioc->name));
+
+	ioc_state = mpt_GetIocState(ioc, 0) & MPI_IOC_STATE_MASK;
+	if (ioc_state == MPI_IOC_STATE_FAULT ||
+	    ioc_state == MPI_IOC_STATE_RESET) {
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "skipping, either in FAULT or RESET state!\n", ioc->name));
+		return -1;
+	}
+
+	spin_lock_irqsave(&ioc->diagLock, flags);
+	if (ioc->ioc_reset_in_progress) {
+		spin_unlock_irqrestore(&ioc->diagLock, flags);
+		return -1;
+	}
+	ioc->ioc_reset_in_progress = 1;
+	spin_unlock_irqrestore(&ioc->diagLock, flags);
+
+	rc = -1;
+
+	for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
+		if (MptResetHandlers[cb_idx])
+			mpt_signal_reset(cb_idx, ioc, MPT_IOC_SETUP_RESET);
+	}
+
+	for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
+		if (MptResetHandlers[cb_idx])
+			mpt_signal_reset(cb_idx, ioc, MPT_IOC_PRE_RESET);
+	}
+
+	/* Disable reply interrupts (also blocks FreeQ) */
+	CHIPREG_WRITE32(&ioc->chip->IntMask, 0xFFFFFFFF);
+	ioc->active = 0;
+	time_count = jiffies;
+	rc = SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET, sleepFlag);
+	if (rc != 0)
+		goto out;
+	ioc_state = mpt_GetIocState(ioc, 0) & MPI_IOC_STATE_MASK;
+	if (ioc_state != MPI_IOC_STATE_READY)
+		goto out;
+
+	for (ii = 0; ii < 5; ii++) {
+		/* Get IOC facts! Allow 5 retries */
+		rc = GetIocFacts(ioc, sleepFlag, MPT_HOSTEVENT_IOC_RECOVER);
+		if (rc == 0)
+			break;
+		if (sleepFlag == CAN_SLEEP)
+			msleep(100);
+		else
+			mdelay(100);
+	}
+	if (ii == 5)
+		goto out;
+
+	rc = PrimeIocFifos(ioc);
+	if (rc != 0)
+		goto out;
+
+	rc = SendIocInit(ioc, sleepFlag);
+	if (rc != 0)
+		goto out;
+
+	rc = SendEventNotification(ioc, 1);
+	if (rc != 0)
+		goto out;
+
+	if (ioc->hard_resets < -1)
+		ioc->hard_resets++;
+
+	/*
+	 * At this point, we know soft reset succeeded.
+	 */
+
+	ioc->active = 1;
+	CHIPREG_WRITE32(&ioc->chip->IntMask, MPI_HIM_DIM);
+
+ out:
+	spin_lock_irqsave(&ioc->diagLock, flags);
+	ioc->ioc_reset_in_progress = 0;
+	ioc->taskmgmt_quiesce_io = 0;
+	ioc->taskmgmt_in_progress = 0;
+	spin_unlock_irqrestore(&ioc->diagLock, flags);
+
+	if (ioc->active) {	/* otherwise, hard reset coming */
+		for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
+			if (MptResetHandlers[cb_idx])
+				mpt_signal_reset(cb_idx, ioc, MPT_IOC_POST_RESET);
+		}
+	}
+
+	printk(MYIOC_s_INFO_FMT "SoftResetHandler: completed (%d seconds): %s\n",
+	    ioc->name, jiffies_to_msecs(jiffies - time_count)/1000,
+	    ((rc == 0) ? "SUCCESS" : "FAILED"));
+
+	return rc;
+}
+
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mpt_HardResetHandler - Generic reset handler
@@ -6253,9 +6376,10 @@ int
 mpt_HardResetHandler(MPT_ADAPTER *ioc, int sleepFlag)
 {
 	int		 rc;
+	u8		 cb_idx;
 	unsigned long	 flags;
+	unsigned long	 time_count;
 
-	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "HardResetHandler Entered!\n", ioc->name));
 #ifdef MFCNT
 	printk(MYIOC_s_INFO_FMT "HardResetHandler Entered!\n", ioc->name);
 	printk("MF count 0x%x !\n", ioc->mfcnt);
@@ -6265,12 +6389,15 @@ mpt_HardResetHandler(MPT_ADAPTER *ioc, i
 	 * mpt_do_ioc_recovery at any instant in time.
 	 */
 	spin_lock_irqsave(&ioc->diagLock, flags);
-	if ((ioc->diagPending) || (ioc->alt_ioc && ioc->alt_ioc->diagPending)){
+	if (ioc->ioc_reset_in_progress) {
 		spin_unlock_irqrestore(&ioc->diagLock, flags);
 		return 0;
 	} else {
 		ioc->diagPending = 1;
 	}
+	ioc->ioc_reset_in_progress = 1;
+	if (ioc->alt_ioc)
+		ioc->alt_ioc->ioc_reset_in_progress = 1;
 	spin_unlock_irqrestore(&ioc->diagLock, flags);
 
 	/* FIXME: If do_ioc_recovery fails, repeat....
@@ -6281,42 +6408,71 @@ mpt_HardResetHandler(MPT_ADAPTER *ioc, i
 	 * Prevents timeouts occurring during a diagnostic reset...very bad.
 	 * For all other protocol drivers, this is a no-op.
 	 */
-	{
-		u8	 cb_idx;
-		int	 r = 0;
-
-		for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
-			if (MptResetHandlers[cb_idx]) {
-				dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Calling IOC reset_setup handler #%d\n",
-						ioc->name, cb_idx));
-				r += mpt_signal_reset(cb_idx, ioc, MPT_IOC_SETUP_RESET);
-				if (ioc->alt_ioc) {
-					dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Calling alt-%s setup reset handler #%d\n",
-							ioc->name, ioc->alt_ioc->name, cb_idx));
-					r += mpt_signal_reset(cb_idx, ioc->alt_ioc, MPT_IOC_SETUP_RESET);
-				}
-			}
+	for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
+		if (MptResetHandlers[cb_idx]) {
+			mpt_signal_reset(cb_idx, ioc, MPT_IOC_SETUP_RESET);
+			if (ioc->alt_ioc)
+				mpt_signal_reset(cb_idx, ioc->alt_ioc, MPT_IOC_SETUP_RESET);
 		}
 	}
 
-	if ((rc = mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_RECOVER, sleepFlag)) != 0) {
-		printk(MYIOC_s_WARN_FMT "Cannot recover rc = %d!\n", ioc->name, rc);
+	time_count = jiffies;
+	rc = mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_RECOVER, sleepFlag);
+	if (rc != 0) {
+		printk(KERN_WARNING MYNAM ": WARNING - (%d) Cannot recover %s\n",
+			rc, ioc->name);
+	} else {
+		if (ioc->hard_resets < -1)
+			ioc->hard_resets++;
 	}
-	ioc->reload_fw = 0;
-	if (ioc->alt_ioc)
-		ioc->alt_ioc->reload_fw = 0;
 
 	spin_lock_irqsave(&ioc->diagLock, flags);
-	ioc->diagPending = 0;
-	if (ioc->alt_ioc)
-		ioc->alt_ioc->diagPending = 0;
+	ioc->ioc_reset_in_progress = 0;
+	ioc->taskmgmt_quiesce_io = 0;
+	ioc->taskmgmt_in_progress = 0;
+	if (ioc->alt_ioc) {
+		ioc->alt_ioc->ioc_reset_in_progress = 0;
+		ioc->alt_ioc->taskmgmt_quiesce_io   = 0;
+		ioc->alt_ioc->taskmgmt_in_progress  = 0;
+	}
 	spin_unlock_irqrestore(&ioc->diagLock, flags);
 
-	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "HardResetHandler rc = %d!\n", ioc->name, rc));
+	for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
+		if (MptResetHandlers[cb_idx]) {
+			mpt_signal_reset(cb_idx, ioc, MPT_IOC_POST_RESET);
+			if (ioc->alt_ioc)
+				mpt_signal_reset(cb_idx, ioc->alt_ioc, MPT_IOC_POST_RESET);
+		}
+	}
+
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "HardResetHandler: completed (%d seconds): %s\n",
+	    ioc->name, jiffies_to_msecs(jiffies - time_count)/1000,
+	    ((rc == 0) ? "SUCCESS" : "FAILED")));
+	return rc;
+}
+
+/**
+ *	mpt_SoftHardResetHandler - Generic reset handler
+ *	@ioc: Pointer to MPT_ADAPTER structure
+ *	@sleepFlag: Indicates if sleep or schedule must be called.
+ *
+ *	First try to do a soft reset and if this fails, call the
+ *	hard-reset-handler
+ */
+int
+mpt_SoftHardResetHandler(MPT_ADAPTER *ioc, int sleepFlag)
+{
+	int rc;
+
+	rc = mpt_SoftResetHandler(ioc, sleepFlag);
+	if (rc) {
+		rc = mpt_HardResetHandler(ioc, sleepFlag);
+	}
 
 	return rc;
 }
 
+
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 static void
 EventDescriptionStr(u8 event, u32 evData0, char *evStr)
@@ -7475,6 +7631,7 @@ EXPORT_SYMBOL(mpt_verify_adapter);
 EXPORT_SYMBOL(mpt_GetIocState);
 EXPORT_SYMBOL(mpt_print_ioc_summary);
 EXPORT_SYMBOL(mpt_HardResetHandler);
+EXPORT_SYMBOL(mpt_SoftHardResetHandler);
 EXPORT_SYMBOL(mpt_config);
 EXPORT_SYMBOL(mpt_findImVolumes);
 EXPORT_SYMBOL(mpt_alloc_fw_memory);
Index: linux-2.6.26/drivers/message/fusion/mptbase.h
===================================================================
--- linux-2.6.26.orig/drivers/message/fusion/mptbase.h
+++ linux-2.6.26/drivers/message/fusion/mptbase.h
@@ -699,6 +699,9 @@ typedef struct _MPT_ADAPTER
 	MPT_SAS_MGMT		 sas_mgmt;
 	struct work_struct	 sas_persist_task;
 
+	int			 taskmgmt_in_progress;
+	u8			 taskmgmt_quiesce_io;
+
 	struct work_struct	 fc_setup_reset_work;
 	struct list_head	 fc_rports;
 	struct work_struct	 fc_lsc_work;
@@ -707,6 +710,11 @@ typedef struct _MPT_ADAPTER
 	struct work_struct	 fc_rescan_work;
 	char			 fc_rescan_work_q_name[KOBJ_NAME_LEN];
 	struct workqueue_struct *fc_rescan_work_q;
+
+	unsigned long		 hard_resets;	/* driver forced bus resets count */
+	unsigned long		 soft_resets;	/* fw/external bus resets count */
+	u8			 ioc_reset_in_progress;
+
 	struct scsi_cmnd	**ScsiLookup;
 	spinlock_t		  scsi_lookup_lock;
 } MPT_ADAPTER;
@@ -836,8 +844,6 @@ typedef struct _MPT_SCSI_HOST {
 	MPT_FRAME_HDR		 *cmdPtr;		/* Ptr to nonOS request */
 	struct scsi_cmnd	 *abortSCpnt;
 	MPT_LOCAL_REPLY		  localReply;		/* internal cmd reply struct */
-	unsigned long		  hard_resets;		/* driver forced bus resets count */
-	unsigned long		  soft_resets;		/* fw/external bus resets count */
 	unsigned long		  timeouts;		/* cmd timeouts */
 	ushort			  sel_timeout[MPT_MAX_FC_DEVICES];
 	char 			  *info_kbuf;
@@ -908,6 +914,7 @@ extern int	 mpt_verify_adapter(int iocid
 extern u32	 mpt_GetIocState(MPT_ADAPTER *ioc, int cooked);
 extern void	 mpt_print_ioc_summary(MPT_ADAPTER *ioc, char *buf, int *size, int len, int showlan);
 extern int	 mpt_HardResetHandler(MPT_ADAPTER *ioc, int sleepFlag);
+extern int	 mpt_SoftHardResetHandler(MPT_ADAPTER *ioc, int sleepFlag);
 extern int	 mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS *cfg);
 extern int	 mpt_alloc_fw_memory(MPT_ADAPTER *ioc, int size);
 extern void	 mpt_free_fw_memory(MPT_ADAPTER *ioc);
Index: linux-2.6.26/drivers/message/fusion/mptscsih.c
===================================================================
--- linux-2.6.26.orig/drivers/message/fusion/mptscsih.c
+++ linux-2.6.26/drivers/message/fusion/mptscsih.c
@@ -1605,7 +1605,7 @@ mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8
 			"TM Handler for type=%x: IOC Not operational (0x%x)!\n",
 			ioc->name, type, ioc_raw_state);
 		printk(MYIOC_s_WARN_FMT " Issuing HardReset!!\n", ioc->name);
-		if (mpt_HardResetHandler(ioc, CAN_SLEEP) < 0)
+		if (mpt_SoftHardResetHandler(ioc, CAN_SLEEP) < 0)
 			printk(MYIOC_s_WARN_FMT "TMHandler: HardReset "
 			    "FAILED!!\n", ioc->name);
 		return FAILED;
@@ -1621,8 +1621,8 @@ mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8
 
 	/* Isse the Task Mgmt request.
 	 */
-	if (hd->hard_resets < -1)
-		hd->hard_resets++;
+	if (ioc->hard_resets < -1)
+		ioc->hard_resets++;
 
 	rc = mptscsih_IssueTaskMgmt(hd, type, channel, id, lun,
 	    ctx2abort, timeout);
@@ -1724,7 +1724,7 @@ mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd
 			ioc, mf));
 		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Calling HardReset! \n",
 			 ioc->name));
-		retval = mpt_HardResetHandler(ioc, CAN_SLEEP);
+		retval = mpt_SoftHardResetHandler(ioc, CAN_SLEEP);
 		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "rc=%d \n",
 			 ioc->name, retval));
 		goto fail_out;
@@ -1999,11 +1999,12 @@ int
 mptscsih_host_reset(struct scsi_cmnd *SCpnt)
 {
 	MPT_SCSI_HOST *  hd;
-	int              retval;
+	int		 retval, status;
 	MPT_ADAPTER	*ioc;
 
 	/*  If we can't locate the host to reset, then we failed. */
-	if ((hd = shost_priv(SCpnt->device->host)) == NULL){
+	hd = shost_priv(SCpnt->device->host);
+	if (hd == NULL) {
 		printk(KERN_ERR MYNAM ": host reset: "
 		    "Can't locate host! (sc=%p)\n", SCpnt);
 		return FAILED;
@@ -2016,21 +2017,23 @@ mptscsih_host_reset(struct scsi_cmnd *SC
 	/*  If our attempts to reset the host failed, then return a failed
 	 *  status.  The host will be taken off line by the SCSI mid-layer.
 	 */
-	if (mpt_HardResetHandler(ioc, CAN_SLEEP) < 0) {
-		retval = FAILED;
-	} else {
+	retval = mpt_SoftHardResetHandler(ioc, CAN_SLEEP);
+
+	if (retval < 0)
+		status = FAILED;
+	else {
 		/*  Make sure TM pending is cleared and TM state is set to
 		 *  NONE.
 		 */
-		retval = 0;
+		status = SUCCESS;
 		hd->tmPending = 0;
 		hd->tmState = TM_STATE_NONE;
 	}
 
 	printk(MYIOC_s_INFO_FMT "host reset: %s (sc=%p)\n",
-	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
+	    ioc->name, ((status == SUCCESS) ? "SUCCESS" : "FAILED"), SCpnt);
 
-	return retval;
+	return status;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -2219,7 +2222,7 @@ mptscsih_taskmgmt_complete(MPT_ADAPTER *
 		 */
 		if (iocstatus == MPI_IOCSTATUS_SCSI_TASK_MGMT_FAILED ||
 		    hd->cmdPtr)
-			if (mpt_HardResetHandler(ioc, NO_SLEEP) < 0)
+			if (mpt_SoftHardResetHandler(ioc, NO_SLEEP) < 0)
 				printk(MYIOC_s_WARN_FMT " Firmware Reload FAILED!!\n", ioc->name);
 		break;
 
@@ -2741,8 +2744,8 @@ mptscsih_event_process(MPT_ADAPTER *ioc,
 		break;
 	case MPI_EVENT_IOC_BUS_RESET:			/* 04 */
 	case MPI_EVENT_EXT_BUS_RESET:			/* 05 */
-		if (hd && (ioc->bus_type == SPI) && (hd->soft_resets < -1))
-			hd->soft_resets++;
+		if (hd && (ioc->bus_type == SPI) && (ioc->soft_resets < -1))
+			ioc->soft_resets++;
 		break;
 	case MPI_EVENT_LOGOUT:				/* 09 */
 		/* FIXME! */
@@ -2980,7 +2983,7 @@ mptscsih_timer_expired(unsigned long dat
 			 */
 		} else {
 			/* Perform a FW reload */
-			if (mpt_HardResetHandler(ioc, NO_SLEEP) < 0) {
+			if (mpt_SoftHardResetHandler(ioc, NO_SLEEP) < 0) {
 				printk(MYIOC_s_WARN_FMT "Firmware Reload FAILED!\n", ioc->name);
 			}
 		}
Index: linux-2.6.26/drivers/message/fusion/mptctl.c
===================================================================
--- linux-2.6.26.orig/drivers/message/fusion/mptctl.c
+++ linux-2.6.26/drivers/message/fusion/mptctl.c
@@ -323,7 +323,7 @@ static void mptctl_timeout_expired (MPT_
 		 */
 		dctlprintk(ioctl->ioc, printk(MYIOC_s_DEBUG_FMT "Calling HardReset! \n",
 			 ioctl->ioc->name));
-		mpt_HardResetHandler(ioctl->ioc, CAN_SLEEP);
+		mpt_SoftHardResetHandler(ioctl->ioc, CAN_SLEEP);
 	}
 	return;
 
@@ -680,6 +680,7 @@ static int mptctl_do_reset(unsigned long
 	dctlprintk(iocp, printk(MYIOC_s_DEBUG_FMT "mptctl_do_reset called.\n",
 	    iocp->name));
 
+	/* FIXME: Can we call mptSoftHardResetHandler() here? */
 	if (mpt_HardResetHandler(iocp, CAN_SLEEP) != 0) {
 		printk (MYIOC_s_ERR_FMT "%s@%d::mptctl_do_reset - reset failed.\n",
 			iocp->name, __FILE__, __LINE__);
@@ -2467,8 +2468,8 @@ mptctl_hp_hostinfo(unsigned long arg, un
 		MPT_SCSI_HOST *hd =  shost_priv(ioc->sh);
 
 		if (hd && (cim_rev == 1)) {
-			karg.hard_resets = hd->hard_resets;
-			karg.soft_resets = hd->soft_resets;
+			karg.hard_resets = ioc->hard_resets;
+			karg.soft_resets = ioc->soft_resets;
 			karg.timeouts = hd->timeouts;
 		}
 	}
Index: linux-2.6.26/drivers/message/fusion/mptsas.c
===================================================================
--- linux-2.6.26.orig/drivers/message/fusion/mptsas.c
+++ linux-2.6.26/drivers/message/fusion/mptsas.c
@@ -1167,7 +1167,7 @@ static int mptsas_phy_reset(struct sas_p
 	if (!timeleft) {
 		/* On timeout reset the board */
 		mpt_free_msg_frame(ioc, mf);
-		mpt_HardResetHandler(ioc, CAN_SLEEP);
+		mpt_SoftHardResetHandler(ioc, CAN_SLEEP);
 		error = -ETIMEDOUT;
 		goto out_unlock;
 	}
@@ -1345,7 +1345,7 @@ static int mptsas_smp_handler(struct Scs
 	if (!timeleft) {
 		printk(MYIOC_s_ERR_FMT "%s: smp timeout!\n", ioc->name, __FUNCTION__);
 		/* On timeout reset the board */
-		mpt_HardResetHandler(ioc, CAN_SLEEP);
+		mpt_SoftHardResetHandler(ioc, CAN_SLEEP);
 		ret = -ETIMEDOUT;
 		goto unmap;
 	}


-- 
Bernd Schubert
Q-Leap Networks GmbH
