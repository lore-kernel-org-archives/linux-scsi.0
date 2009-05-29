From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 7/17] mpt fusion: [2.6.30-rc6][Reviewed] rewrite taskmgmt request and completion routines
Date: Fri, 29 May 2009 16:44:48 +0530
Message-ID: <20090529111441.GH10181@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og106.obsmtp.com ([64.18.2.165]:40425 "EHLO
	exprod7og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756948AbZE2LgI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 May 2009 07:36:08 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

1.)	 rewrite taskmanagement request and completion routines, making them
single threaded and using the generic MPT_MGMT struct, deleting
mptscsih_TMHandler, replacing with single request TM handler
mptscsih_IssueTaskMgmt, and killing the watchdog timer functions.
2.) cleanup ioc_reset callback handlers, introducing wrappers for
synchronizing error recovery (mpt_set_taskmgmt_in_progress_flag,
mpt_clear_taskmgmt_in_progress_flag), as the fusion firmware only handles
one task management request at a time
---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index d8d5231..af862bf 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -341,7 +341,7 @@ mpt_fault_reset_work(struct work_struct *work)
 	int		 rc;
 	unsigned long	 flags;
 
-	if (ioc->diagPending || !ioc->active)
+	if (ioc->ioc_reset_in_progress || !ioc->active)
 		goto out;
 
 	ioc_raw_state = mpt_GetIocState(ioc, 0);
@@ -1771,14 +1771,15 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	ioc->reply_sz = MPT_REPLY_FRAME_SIZE;
 
 	ioc->pcidev = pdev;
-	ioc->diagPending = 0;
-	spin_lock_init(&ioc->diagLock);
 	spin_lock_init(&ioc->initializing_hba_lock);
 
+	spin_lock_init(&ioc->taskmgmt_lock);
 	mutex_init(&ioc->internal_cmds.mutex);
 	init_completion(&ioc->internal_cmds.done);
 	mutex_init(&ioc->mptbase_cmds.mutex);
 	init_completion(&ioc->mptbase_cmds.done);
+	mutex_init(&ioc->taskmgmt_cmds.mutex);
+	init_completion(&ioc->taskmgmt_cmds.done);
 
 	/* Initialize the event logging.
 	 */
@@ -6572,6 +6573,53 @@ mpt_print_ioc_summary(MPT_ADAPTER *ioc, char *buffer, int *size, int len, int sh
 
 	*size = y;
 }
+/**
+ *	mpt_set_taskmgmt_in_progress_flag - set flags associated with task managment
+ *	@ioc: Pointer to MPT_ADAPTER structure
+ *
+ *	Returns 0 for SUCCESS or -1 if FAILED.
+ *
+ *	If -1 is return, then it was not possible to set the flags
+ **/
+int
+mpt_set_taskmgmt_in_progress_flag(MPT_ADAPTER *ioc)
+{
+	unsigned long	 flags;
+	int		 retval;
+
+	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
+	if (ioc->ioc_reset_in_progress || ioc->taskmgmt_in_progress ||
+	    (ioc->alt_ioc && ioc->alt_ioc->taskmgmt_in_progress)) {
+		retval = -1;
+		goto out;
+	}
+	retval = 0;
+	ioc->taskmgmt_in_progress = 1;
+	if (ioc->alt_ioc)
+		ioc->alt_ioc->taskmgmt_in_progress = 1;
+ out:
+	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
+	return retval;
+}
+EXPORT_SYMBOL(mpt_set_taskmgmt_in_progress_flag);
+
+/**
+ *	mpt_clear_taskmgmt_in_progress_flag - clear flags associated with task managment
+ *	@ioc: Pointer to MPT_ADAPTER structure
+ *
+ **/
+void
+mpt_clear_taskmgmt_in_progress_flag(MPT_ADAPTER *ioc)
+{
+	unsigned long	 flags;
+
+	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
+	ioc->taskmgmt_in_progress = 0;
+	if (ioc->alt_ioc)
+		ioc->alt_ioc->taskmgmt_in_progress = 0;
+	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
+}
+EXPORT_SYMBOL(mpt_clear_taskmgmt_in_progress_flag);
 
 
 /**
@@ -6638,14 +6686,15 @@ mpt_HardResetHandler(MPT_ADAPTER *ioc, int sleepFlag)
 	/* Reset the adapter. Prevent more than 1 call to
 	 * mpt_do_ioc_recovery at any instant in time.
 	 */
-	spin_lock_irqsave(&ioc->diagLock, flags);
-	if ((ioc->diagPending) || (ioc->alt_ioc && ioc->alt_ioc->diagPending)){
-		spin_unlock_irqrestore(&ioc->diagLock, flags);
+	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
+	if (ioc->ioc_reset_in_progress) {
+		spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
 		return 0;
-	} else {
-		ioc->diagPending = 1;
 	}
-	spin_unlock_irqrestore(&ioc->diagLock, flags);
+	ioc->ioc_reset_in_progress = 1;
+	if (ioc->alt_ioc)
+		ioc->alt_ioc->ioc_reset_in_progress = 1;
+	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
 
 	/* FIXME: If do_ioc_recovery fails, repeat....
 	 */
@@ -6680,11 +6729,14 @@ mpt_HardResetHandler(MPT_ADAPTER *ioc, int sleepFlag)
 	if (ioc->alt_ioc)
 		ioc->alt_ioc->reload_fw = 0;
 
-	spin_lock_irqsave(&ioc->diagLock, flags);
-	ioc->diagPending = 0;
-	if (ioc->alt_ioc)
-		ioc->alt_ioc->diagPending = 0;
-	spin_unlock_irqrestore(&ioc->diagLock, flags);
+	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
+	ioc->ioc_reset_in_progress = 0;
+	ioc->taskmgmt_in_progress = 0;
+	if (ioc->alt_ioc) {
+		ioc->alt_ioc->ioc_reset_in_progress = 0;
+		ioc->alt_ioc->taskmgmt_in_progress = 0;
+	}
+	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
 
 	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "HardResetHandler rc = %d!\n", ioc->name, rc));
 
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 4d77256..2129aff 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -657,8 +657,6 @@ typedef struct _MPT_ADAPTER
 	MPT_IOCTL		*ioctl;		/* ioctl data pointer */
 	struct proc_dir_entry	*ioc_dentry;
 	struct _MPT_ADAPTER	*alt_ioc;	/* ptr to 929 bound adapter port */
-	spinlock_t		 diagLock;	/* diagnostic reset lock */
-	int			 diagPending;
 	u32			 biosVersion;	/* BIOS version from IO Unit Page 2 */
 	int			 eventTypes;	/* Event logging parameters */
 	int			 eventContext;	/* Next event context */
@@ -712,6 +710,10 @@ typedef struct _MPT_ADAPTER
 	MPT_MGMT		 sas_mgmt;
 	MPT_MGMT		 mptbase_cmds; /* for sending config pages */
 	MPT_MGMT		 internal_cmds;
+	MPT_MGMT		 taskmgmt_cmds;
+	spinlock_t		 taskmgmt_lock; /* diagnostic reset lock */
+	int			 taskmgmt_in_progress;
+	u8			 ioc_reset_in_progress;
 	struct work_struct	 sas_persist_task;
 
 	struct work_struct	 fc_setup_reset_work;
@@ -931,6 +933,8 @@ extern void	 mpt_free_fw_memory(MPT_ADAPTER *ioc);
 extern int	 mpt_findImVolumes(MPT_ADAPTER *ioc);
 extern int	 mptbase_sas_persist_operation(MPT_ADAPTER *ioc, u8 persist_opcode);
 extern int	 mpt_raid_phys_disk_pg0(MPT_ADAPTER *ioc, u8 phys_disk_num, pRaidPhysDiskPage0_t phys_disk);
+extern int	 mpt_set_taskmgmt_in_progress_flag(MPT_ADAPTER *ioc);
+extern void	 mpt_clear_taskmgmt_in_progress_flag(MPT_ADAPTER *ioc);
 extern void     mpt_halt_firmware(MPT_ADAPTER *ioc);
 
 
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 3517325..2463731 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -92,20 +92,24 @@ static int	mptscsih_AddSGE(MPT_ADAPTER *ioc, struct scsi_cmnd *SCpnt,
 				 SCSIIORequest_t *pReq, int req_idx);
 static void	mptscsih_freeChainBuffers(MPT_ADAPTER *ioc, int req_idx);
 static void	mptscsih_copy_sense_data(struct scsi_cmnd *sc, MPT_SCSI_HOST *hd, MPT_FRAME_HDR *mf, SCSIIOReply_t *pScsiReply);
-static int	mptscsih_tm_pending_wait(MPT_SCSI_HOST * hd);
-static int	mptscsih_tm_wait_for_completion(MPT_SCSI_HOST * hd, ulong timeout );
 
-static int	mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int lun, int ctx2abort, ulong timeout);
+int	mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id,
+		int lun, int ctx2abort, ulong timeout);
 
 int		mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);
 int		mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply);
 
+static void
+mptscsih_taskmgmt_response_code(MPT_ADAPTER *ioc, u8 response_code);
 static int	mptscsih_get_completion_code(MPT_ADAPTER *ioc,
 		MPT_FRAME_HDR *req, MPT_FRAME_HDR *reply);
 int		mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
 static int	mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *iocmd);
 static void	mptscsih_synchronize_cache(MPT_SCSI_HOST *hd, VirtDevice *vdevice);
 
+static int
+mptscsih_taskmgmt_reply(MPT_ADAPTER *ioc, u8 type,
+				SCSITaskMgmtReply_t *pScsiTmReply);
 void 		mptscsih_remove(struct pci_dev *);
 void 		mptscsih_shutdown(struct pci_dev *);
 #ifdef CONFIG_PM
@@ -1466,8 +1470,8 @@ mptscsih_freeChainBuffers(MPT_ADAPTER *ioc, int req_idx)
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
- *	mptscsih_TMHandler - Generic handler for SCSI Task Management.
- *	@hd: Pointer to MPT SCSI HOST structure
+ *	mptscsih_IssueTaskMgmt - Generic send Task Management function.
+ *	@hd: Pointer to MPT_SCSI_HOST structure
  *	@type: Task Management type
  *	@channel: channel number for task management
  *	@id: Logical Target ID for reset (if appropriate)
@@ -1475,145 +1479,68 @@ mptscsih_freeChainBuffers(MPT_ADAPTER *ioc, int req_idx)
  *	@ctx2abort: Context for the task to be aborted (if appropriate)
  *	@timeout: timeout for task management control
  *
- *	Fall through to mpt_HardResetHandler if: not operational, too many
- *	failed TM requests or handshake failure.
+ *	Remark: _HardResetHandler can be invoked from an interrupt thread (timer)
+ *	or a non-interrupt thread.  In the former, must not call schedule().
  *
- *	Remark: Currently invoked from a non-interrupt thread (_bh).
+ *	Not all fields are meaningfull for all task types.
  *
- *	Note: With old EH code, at most 1 SCSI TaskMgmt function per IOC
- *	will be active.
+ *	Returns 0 for SUCCESS, or FAILED.
  *
- *	Returns 0 for SUCCESS, or %FAILED.
  **/
 int
-mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int lun, int ctx2abort, ulong timeout)
+mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int lun,
+	int ctx2abort, ulong timeout)
 {
-	MPT_ADAPTER	*ioc;
-	int		 rc = -1;
+	MPT_FRAME_HDR	*mf;
+	SCSITaskMgmt_t	*pScsiTm;
+	int		 ii;
+	int		 retval;
+	MPT_ADAPTER 	*ioc = hd->ioc;
+	unsigned long	 timeleft;
+	u8		 issue_hard_reset;
 	u32		 ioc_raw_state;
-	unsigned long	 flags;
-
-	ioc = hd->ioc;
-	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "TMHandler Entered!\n", ioc->name));
-
-	// SJR - CHECKME - Can we avoid this here?
-	// (mpt_HardResetHandler has this check...)
-	spin_lock_irqsave(&ioc->diagLock, flags);
-	if ((ioc->diagPending) || (ioc->alt_ioc && ioc->alt_ioc->diagPending)) {
-		spin_unlock_irqrestore(&ioc->diagLock, flags);
-		return FAILED;
-	}
-	spin_unlock_irqrestore(&ioc->diagLock, flags);
-
-	/*  Wait a fixed amount of time for the TM pending flag to be cleared.
-	 *  If we time out and not bus reset, then we return a FAILED status
-	 *  to the caller.
-	 *  The call to mptscsih_tm_pending_wait() will set the pending flag
-	 *  if we are
-	 *  successful. Otherwise, reload the FW.
-	 */
-	if (mptscsih_tm_pending_wait(hd) == FAILED) {
-		if (type == MPI_SCSITASKMGMT_TASKTYPE_ABORT_TASK) {
-			dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "TMHandler abort: "
-			   "Timed out waiting for last TM (%d) to complete! \n",
-			   ioc->name, hd->tmPending));
-			return FAILED;
-		} else if (type == MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET) {
-			dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "TMHandler target "
-				"reset: Timed out waiting for last TM (%d) "
-				"to complete! \n", ioc->name,
-				hd->tmPending));
-			return FAILED;
-		} else if (type == MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS) {
-			dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "TMHandler bus reset: "
-			   "Timed out waiting for last TM (%d) to complete! \n",
-			  ioc->name, hd->tmPending));
-			return FAILED;
-		}
-	} else {
-		spin_lock_irqsave(&ioc->FreeQlock, flags);
-		hd->tmPending |=  (1 << type);
-		spin_unlock_irqrestore(&ioc->FreeQlock, flags);
-	}
+	unsigned long	 time_count;
 
+	issue_hard_reset = 0;
 	ioc_raw_state = mpt_GetIocState(ioc, 0);
 
 	if ((ioc_raw_state & MPI_IOC_STATE_MASK) != MPI_IOC_STATE_OPERATIONAL) {
 		printk(MYIOC_s_WARN_FMT
-			"TM Handler for type=%x: IOC Not operational (0x%x)!\n",
+			"TaskMgmt type=%x: IOC Not operational (0x%x)!\n",
 			ioc->name, type, ioc_raw_state);
-		printk(MYIOC_s_WARN_FMT " Issuing HardReset!!\n", ioc->name);
+		printk(MYIOC_s_WARN_FMT "Issuing HardReset from %s!!\n",
+		    ioc->name, __func__);
 		if (mpt_HardResetHandler(ioc, CAN_SLEEP) < 0)
-			printk(MYIOC_s_WARN_FMT "TMHandler: HardReset "
+			printk(MYIOC_s_WARN_FMT "TaskMgmt HardReset "
 			    "FAILED!!\n", ioc->name);
-		return FAILED;
+		return 0;
 	}
 
 	if (ioc_raw_state & MPI_DOORBELL_ACTIVE) {
 		printk(MYIOC_s_WARN_FMT
-			"TM Handler for type=%x: ioc_state: "
+			"TaskMgmt type=%x: ioc_state: "
 			"DOORBELL_ACTIVE (0x%x)!\n",
 			ioc->name, type, ioc_raw_state);
 		return FAILED;
 	}
 
-	/* Isse the Task Mgmt request.
-	 */
-	if (hd->hard_resets < -1)
-		hd->hard_resets++;
-
-	rc = mptscsih_IssueTaskMgmt(hd, type, channel, id, lun,
-	    ctx2abort, timeout);
-	if (rc)
-		printk(MYIOC_s_INFO_FMT "Issue of TaskMgmt failed!\n",
-		       ioc->name);
-	else
-		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Issue of TaskMgmt Successful!\n",
-			   ioc->name));
-
-	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-			"TMHandler rc = %d!\n", ioc->name, rc));
-
-	return rc;
-}
-
-
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/**
- *	mptscsih_IssueTaskMgmt - Generic send Task Management function.
- *	@hd: Pointer to MPT_SCSI_HOST structure
- *	@type: Task Management type
- *	@channel: channel number for task management
- *	@id: Logical Target ID for reset (if appropriate)
- *	@lun: Logical Unit for reset (if appropriate)
- *	@ctx2abort: Context for the task to be aborted (if appropriate)
- *	@timeout: timeout for task management control
- *
- *	Remark: _HardResetHandler can be invoked from an interrupt thread (timer)
- *	or a non-interrupt thread.  In the former, must not call schedule().
- *
- *	Not all fields are meaningfull for all task types.
- *
- *	Returns 0 for SUCCESS, or FAILED.
- *
- **/
-static int
-mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int lun, int ctx2abort, ulong timeout)
-{
-	MPT_FRAME_HDR	*mf;
-	SCSITaskMgmt_t	*pScsiTm;
-	int		 ii;
-	int		 retval;
-	MPT_ADAPTER 	*ioc = hd->ioc;
+	mutex_lock(&ioc->taskmgmt_cmds.mutex);
+	if (mpt_set_taskmgmt_in_progress_flag(ioc) != 0) {
+		mf = NULL;
+		retval = FAILED;
+		goto out;
+	}
 
 	/* Return Fail to calling function if no message frames available.
 	 */
 	if ((mf = mpt_get_msg_frame(ioc->TaskCtx, ioc)) == NULL) {
-		dfailprintk(ioc, printk(MYIOC_s_ERR_FMT "IssueTaskMgmt, no msg frames!!\n",
-				ioc->name));
-		return FAILED;
+		dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
+			"TaskMgmt no msg frames!!\n", ioc->name));
+		retval = FAILED;
+		mpt_clear_taskmgmt_in_progress_flag(ioc);
+		goto out;
 	}
-	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "IssueTaskMgmt request @ %p\n",
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "TaskMgmt request (mf=%p)\n",
 			ioc->name, mf));
 
 	/* Format the Request
@@ -1637,11 +1564,14 @@ mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int lun, i
 
 	pScsiTm->TaskMsgContext = ctx2abort;
 
-	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "IssueTaskMgmt: ctx2abort (0x%08x) "
-		"type=%d\n", ioc->name, ctx2abort, type));
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "TaskMgmt: ctx2abort (0x%08x) "
+		"task_type = 0x%02X, timeout = %ld\n", ioc->name, ctx2abort,
+		type, timeout));
 
 	DBG_DUMP_TM_REQUEST_FRAME(ioc, (u32 *)pScsiTm);
 
+	INITIALIZE_MGMT_STATUS(ioc->taskmgmt_cmds.status)
+	time_count = jiffies;
 	if ((ioc->facts.IOCCapabilities & MPI_IOCFACTS_CAPABILITY_HIGH_PRI_Q) &&
 	    (ioc->facts.MsgVersion >= MPI_VERSION_01_05))
 		mpt_put_msg_frame_hi_pri(ioc->TaskCtx, ioc, mf);
@@ -1649,47 +1579,50 @@ mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int lun, i
 		retval = mpt_send_handshake_request(ioc->TaskCtx, ioc,
 			sizeof(SCSITaskMgmt_t), (u32*)pScsiTm, CAN_SLEEP);
 		if (retval) {
-			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT "send_handshake FAILED!"
-			" (hd %p, ioc %p, mf %p, rc=%d) \n", ioc->name, hd,
-			ioc, mf, retval));
-			goto fail_out;
+			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
+				"TaskMgmt handshake FAILED!(mf=%p, rc=%d) \n",
+				ioc->name, mf, retval));
+			mpt_free_msg_frame(ioc, mf);
+			mpt_clear_taskmgmt_in_progress_flag(ioc);
+			goto out;
 		}
 	}
 
-	if(mptscsih_tm_wait_for_completion(hd, timeout) == FAILED) {
-		dfailprintk(ioc, printk(MYIOC_s_ERR_FMT "task management request TIMED OUT!"
-			" (hd %p, ioc %p, mf %p) \n", ioc->name, hd,
-			ioc, mf));
-		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Calling HardReset! \n",
-			 ioc->name));
-		retval = mpt_HardResetHandler(ioc, CAN_SLEEP);
-		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "rc=%d \n",
-			 ioc->name, retval));
-		goto fail_out;
+	timeleft = wait_for_completion_timeout(&ioc->taskmgmt_cmds.done,
+		timeout*HZ);
+	if (!(ioc->taskmgmt_cmds.status & MPT_MGMT_STATUS_COMMAND_GOOD)) {
+		retval = FAILED;
+		dtmprintk(ioc, printk(MYIOC_s_ERR_FMT
+		    "TaskMgmt TIMED OUT!(mf=%p)\n", ioc->name, mf));
+		mpt_clear_taskmgmt_in_progress_flag(ioc);
+		if (ioc->taskmgmt_cmds.status & MPT_MGMT_STATUS_DID_IOCRESET)
+			goto out;
+		issue_hard_reset = 1;
+		goto out;
 	}
 
-	/*
-	 * Handle success case, see if theres a non-zero ioc_status.
-	 */
-	if (hd->tm_iocstatus == MPI_IOCSTATUS_SUCCESS ||
-	   hd->tm_iocstatus == MPI_IOCSTATUS_SCSI_TASK_TERMINATED ||
-	   hd->tm_iocstatus == MPI_IOCSTATUS_SCSI_IOC_TERMINATED)
-		retval = 0;
-	else
-		retval = FAILED;
+	retval = mptscsih_taskmgmt_reply(ioc, type,
+	    (SCSITaskMgmtReply_t *) ioc->taskmgmt_cmds.reply);
 
-	return retval;
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+	    "TaskMgmt completed (%d seconds)\n",
+	    ioc->name, jiffies_to_msecs(jiffies - time_count)/1000));
 
- fail_out:
+ out:
 
-	/*
-	 * Free task management mf, and corresponding tm flags
-	 */
-	mpt_free_msg_frame(ioc, mf);
-	hd->tmPending = 0;
-	hd->tmState = TM_STATE_NONE;
-	return FAILED;
+	CLEAR_MGMT_STATUS(ioc->taskmgmt_cmds.status)
+	if (issue_hard_reset) {
+		printk(MYIOC_s_WARN_FMT "Issuing Reset from %s!!\n",
+			ioc->name, __func__);
+		retval = mpt_HardResetHandler(ioc, CAN_SLEEP);
+		mpt_free_msg_frame(ioc, mf);
+	}
+
+	retval = (retval == 0) ? 0 : FAILED;
+	mutex_unlock(&ioc->taskmgmt_cmds.mutex);
+	return retval;
 }
+EXPORT_SYMBOL(mptscsih_IssueTaskMgmt);
 
 static int
 mptscsih_get_tm_timeout(MPT_ADAPTER *ioc)
@@ -1799,9 +1732,11 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 
 	hd->abortSCpnt = SCpnt;
 
-	retval = mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_ABORT_TASK,
-	    vdevice->vtarget->channel, vdevice->vtarget->id, vdevice->lun,
-	    ctx2abort, mptscsih_get_tm_timeout(ioc));
+	retval = mptscsih_IssueTaskMgmt(hd,
+			 MPI_SCSITASKMGMT_TASKTYPE_ABORT_TASK,
+			 vdevice->vtarget->channel,
+			 vdevice->vtarget->id, vdevice->lun,
+			 ctx2abort, mptscsih_get_tm_timeout(ioc));
 
 	if (SCPNT_TO_LOOKUP_IDX(ioc, SCpnt) == scpnt_idx &&
 	    SCpnt->serial_number == sn)
@@ -1865,9 +1800,11 @@ mptscsih_dev_reset(struct scsi_cmnd * SCpnt)
 		goto out;
 	}
 
-	retval = mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
-	    vdevice->vtarget->channel, vdevice->vtarget->id, 0, 0,
-	    mptscsih_get_tm_timeout(ioc));
+	retval = mptscsih_IssueTaskMgmt(hd,
+				MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
+				vdevice->vtarget->channel,
+				vdevice->vtarget->id, 0, 0,
+				mptscsih_get_tm_timeout(ioc));
 
  out:
 	printk (MYIOC_s_INFO_FMT "target reset: %s (sc=%p)\n",
@@ -1914,8 +1851,10 @@ mptscsih_bus_reset(struct scsi_cmnd * SCpnt)
 		hd->timeouts++;
 
 	vdevice = SCpnt->device->hostdata;
-	retval = mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,
-	    vdevice->vtarget->channel, 0, 0, 0, mptscsih_get_tm_timeout(ioc));
+	retval = mptscsih_IssueTaskMgmt(hd,
+					MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,
+					vdevice->vtarget->channel, 0, 0, 0,
+					mptscsih_get_tm_timeout(ioc));
 
 	printk(MYIOC_s_INFO_FMT "bus reset: %s (sc=%p)\n",
 	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
@@ -1976,65 +1915,55 @@ mptscsih_host_reset(struct scsi_cmnd *SCpnt)
 	return retval;
 }
 
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/**
- *	mptscsih_tm_pending_wait - wait for pending task management request to complete
- *	@hd: Pointer to MPT host structure.
- *
- *	Returns {SUCCESS,FAILED}.
- */
 static int
-mptscsih_tm_pending_wait(MPT_SCSI_HOST * hd)
+mptscsih_taskmgmt_reply(MPT_ADAPTER *ioc, u8 type,
+	SCSITaskMgmtReply_t *pScsiTmReply)
 {
-	unsigned long  flags;
-	int            loop_count = 4 * 10;  /* Wait 10 seconds */
-	int            status = FAILED;
-	MPT_ADAPTER	*ioc = hd->ioc;
+	u16			 iocstatus;
+	u32			 termination_count;
+	int			 retval;
 
-	do {
-		spin_lock_irqsave(&ioc->FreeQlock, flags);
-		if (hd->tmState == TM_STATE_NONE) {
-			hd->tmState = TM_STATE_IN_PROGRESS;
-			hd->tmPending = 1;
-			spin_unlock_irqrestore(&ioc->FreeQlock, flags);
-			status = SUCCESS;
-			break;
-		}
-		spin_unlock_irqrestore(&ioc->FreeQlock, flags);
-		msleep(250);
-	} while (--loop_count);
+	if (!(ioc->taskmgmt_cmds.status & MPT_MGMT_STATUS_RF_VALID)) {
+		retval = FAILED;
+		goto out;
+	}
 
-	return status;
-}
+	DBG_DUMP_TM_REPLY_FRAME(ioc, (u32 *)pScsiTmReply);
 
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/**
- *	mptscsih_tm_wait_for_completion - wait for completion of TM task
- *	@hd: Pointer to MPT host structure.
- *	@timeout: timeout value
- *
- *	Returns {SUCCESS,FAILED}.
- */
-static int
-mptscsih_tm_wait_for_completion(MPT_SCSI_HOST * hd, ulong timeout )
-{
-	unsigned long  flags;
-	int            loop_count = 4 * timeout;
-	int            status = FAILED;
-	MPT_ADAPTER	*ioc = hd->ioc;
+	iocstatus = le16_to_cpu(pScsiTmReply->IOCStatus) & MPI_IOCSTATUS_MASK;
+	termination_count = le32_to_cpu(pScsiTmReply->TerminationCount);
 
-	do {
-		spin_lock_irqsave(&ioc->FreeQlock, flags);
-		if(hd->tmPending == 0) {
-			status = SUCCESS;
-			spin_unlock_irqrestore(&ioc->FreeQlock, flags);
-			break;
-		}
-		spin_unlock_irqrestore(&ioc->FreeQlock, flags);
-		msleep(250);
-	} while (--loop_count);
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+	    "TaskMgmt fw_channel = %d, fw_id = %d, task_type = 0x%02X,\n"
+	    "\tiocstatus = 0x%04X, loginfo = 0x%08X, response_code = 0x%02X,\n"
+	    "\tterm_cmnds = %d\n", ioc->name, pScsiTmReply->Bus,
+	    pScsiTmReply->TargetID, type, le16_to_cpu(pScsiTmReply->IOCStatus),
+	    le32_to_cpu(pScsiTmReply->IOCLogInfo), pScsiTmReply->ResponseCode,
+	    termination_count));
+
+	if (ioc->facts.MsgVersion >= MPI_VERSION_01_05 &&
+	    pScsiTmReply->ResponseCode)
+		mptscsih_taskmgmt_response_code(ioc,
+		    pScsiTmReply->ResponseCode);
 
-	return status;
+	if (iocstatus == MPI_IOCSTATUS_SUCCESS) {
+		retval = 0;
+		goto out;
+	}
+
+	retval = FAILED;
+	if (type == MPI_SCSITASKMGMT_TASKTYPE_ABORT_TASK) {
+		if (termination_count == 1)
+			retval = 0;
+		goto out;
+	}
+
+	if (iocstatus == MPI_IOCSTATUS_SCSI_TASK_TERMINATED ||
+	   iocstatus == MPI_IOCSTATUS_SCSI_IOC_TERMINATED)
+		retval = 0;
+
+ out:
+	return retval;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -2088,97 +2017,28 @@ mptscsih_taskmgmt_response_code(MPT_ADAPTER *ioc, u8 response_code)
  *	Returns 1 indicating alloc'd request frame ptr should be freed.
  **/
 int
-mptscsih_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
+mptscsih_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf,
+	MPT_FRAME_HDR *mr)
 {
-	SCSITaskMgmtReply_t	*pScsiTmReply;
-	SCSITaskMgmt_t		*pScsiTmReq;
-	MPT_SCSI_HOST		*hd;
-	unsigned long		 flags;
-	u16			 iocstatus;
-	u8			 tmType;
-	u32			 termination_count;
-
-	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "TaskMgmt completed (mf=%p,mr=%p)\n",
-	    ioc->name, mf, mr));
-	if (!ioc->sh) {
-		dtmprintk(ioc, printk(MYIOC_s_WARN_FMT
-		    "TaskMgmt Complete: NULL Scsi Host Ptr\n", ioc->name));
-		return 1;
-	}
-
-	if (mr == NULL) {
-		dtmprintk(ioc, printk(MYIOC_s_WARN_FMT
-		    "ERROR! TaskMgmt Reply: NULL Request %p\n", ioc->name, mf));
-		return 1;
-	}
-
-	hd = shost_priv(ioc->sh);
-	pScsiTmReply = (SCSITaskMgmtReply_t*)mr;
-	pScsiTmReq = (SCSITaskMgmt_t*)mf;
-	tmType = pScsiTmReq->TaskType;
-	iocstatus = le16_to_cpu(pScsiTmReply->IOCStatus) & MPI_IOCSTATUS_MASK;
-	termination_count = le32_to_cpu(pScsiTmReply->TerminationCount);
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		"TaskMgmt completed (mf=%p, mr=%p)\n", ioc->name, mf, mr));
 
-	if (ioc->facts.MsgVersion >= MPI_VERSION_01_05 &&
-	    pScsiTmReply->ResponseCode)
-		mptscsih_taskmgmt_response_code(ioc,
-		    pScsiTmReply->ResponseCode);
-	DBG_DUMP_TM_REPLY_FRAME(ioc, (u32 *)pScsiTmReply);
+	ioc->taskmgmt_cmds.status |= MPT_MGMT_STATUS_COMMAND_GOOD;
 
-#ifdef CONFIG_FUSION_LOGGING
-	if ((ioc->debug_level & MPT_DEBUG_REPLY) ||
-				(ioc->debug_level & MPT_DEBUG_TM ))
-		printk("%s: ha=%d [%d:%d:0] task_type=0x%02X "
-			"iocstatus=0x%04X\n\tloginfo=0x%08X response_code=0x%02X "
-			"term_cmnds=%d\n", __func__, ioc->id, pScsiTmReply->Bus,
-			 pScsiTmReply->TargetID, pScsiTmReq->TaskType,
-			le16_to_cpu(pScsiTmReply->IOCStatus),
-			le32_to_cpu(pScsiTmReply->IOCLogInfo),pScsiTmReply->ResponseCode,
-			le32_to_cpu(pScsiTmReply->TerminationCount));
-#endif
-	if (!iocstatus) {
-		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT " TaskMgmt SUCCESS\n", ioc->name));
-			hd->abortSCpnt = NULL;
+	if (!mr)
 		goto out;
-	}
-
-	/* Error?  (anything non-zero?) */
-
-	/* clear flags and continue.
-	 */
-	switch (tmType) {
-
-	case MPI_SCSITASKMGMT_TASKTYPE_ABORT_TASK:
-		if (termination_count == 1)
-			iocstatus = MPI_IOCSTATUS_SCSI_TASK_TERMINATED;
-		hd->abortSCpnt = NULL;
-		break;
-
-	case MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS:
-
-		/* If an internal command is present
-		 * or the TM failed - reload the FW.
-		 * FC FW may respond FAILED to an ABORT
-		 */
-		if (iocstatus == MPI_IOCSTATUS_SCSI_TASK_MGMT_FAILED ||
-		    hd->cmdPtr)
-			if (mpt_HardResetHandler(ioc, NO_SLEEP) < 0)
-				printk(MYIOC_s_WARN_FMT " Firmware Reload FAILED!!\n", ioc->name);
-		break;
-
-	case MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET:
-	default:
-		break;
-	}
 
+	ioc->taskmgmt_cmds.status |= MPT_MGMT_STATUS_RF_VALID;
+	memcpy(ioc->taskmgmt_cmds.reply, mr,
+	    min(MPT_DEFAULT_FRAME_SIZE, 4 * mr->u.reply.MsgLength));
  out:
-	spin_lock_irqsave(&ioc->FreeQlock, flags);
-	hd->tmPending = 0;
-	hd->tmState = TM_STATE_NONE;
-	hd->tm_iocstatus = iocstatus;
-	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
-
-	return 1;
+	if (ioc->taskmgmt_cmds.status & MPT_MGMT_STATUS_PENDING) {
+		mpt_clear_taskmgmt_in_progress_flag(ioc);
+		ioc->taskmgmt_cmds.status &= ~MPT_MGMT_STATUS_PENDING;
+		complete(&ioc->taskmgmt_cmds.done);
+		return 1;
+	}
+	return 0;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -2901,6 +2761,16 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *io)
 	unsigned long	 timeleft;
 	unsigned long	 flags;
 
+	/* don't send internal command during diag reset */
+	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
+	if (ioc->ioc_reset_in_progress) {
+		spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
+		dfailprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+			"%s: busy with host reset\n", ioc->name, __func__));
+		return MPT_SCANDV_BUSY;
+	}
+	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
+
 	mutex_lock(&ioc->internal_cmds.mutex);
 
 	/* Set command specific information
@@ -3360,6 +3230,5 @@ EXPORT_SYMBOL(mptscsih_event_process);
 EXPORT_SYMBOL(mptscsih_ioc_reset);
 EXPORT_SYMBOL(mptscsih_change_queue_depth);
 EXPORT_SYMBOL(mptscsih_timer_expired);
-EXPORT_SYMBOL(mptscsih_TMHandler);
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
index 0b103a2..6ac5d4a 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -113,6 +113,8 @@ extern int mptscsih_resume(struct pci_dev *pdev);
 extern int mptscsih_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset, int length, int func);
 extern const char * mptscsih_info(struct Scsi_Host *SChost);
 extern int mptscsih_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *));
+extern int mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel,
+	u8 id, int lun, int ctx2abort, ulong timeout);
 extern void mptscsih_slave_destroy(struct scsi_device *device);
 extern int mptscsih_slave_configure(struct scsi_device *device);
 extern int mptscsih_abort(struct scsi_cmnd * SCpnt);
@@ -127,7 +129,6 @@ extern int mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pE
 extern int mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);
 extern int mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth);
 extern void mptscsih_timer_expired(unsigned long data);
-extern int mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int lun, int ctx2abort, ulong timeout);
 extern u8 mptscsih_raid_id_to_num(MPT_ADAPTER *ioc, u8 channel, u8 id);
 extern int mptscsih_is_phys_disk(MPT_ADAPTER *ioc, u8 channel, u8 id);
 extern struct device_attribute *mptscsih_host_attrs[];
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 8f46fdf..e94c76d 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -1522,7 +1522,7 @@ mptspi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	 * issue internal bus reset
 	 */
 	if (ioc->spi_data.bus_reset)
-		mptscsih_TMHandler(hd,
+		mptscsih_IssueTaskMgmt(hd,
 		    MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,
 		    0, 0, 0, 0, 5);
 
