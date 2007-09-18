From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 8/9] mpt fusion: error recovery improvements, and synchronizing internal commands
Date: Mon, 17 Sep 2007 20:01:18 -0600
Message-ID: <20070918020117.GA22771@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:62097 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754310AbXIRCKI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Sep 2007 22:10:08 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

1) cleanup ioc_reset callback handlers, introducing wrappers for synchronizing error recovery (mpt_set_taskmgmt_in_progress_flag, mpt_clear_taskmgmt_in_progress_flag), as the fusion firmware only handles one task management request at a time.
2) rewrite of all internal generated functions that issue commands to firmware, porting them to be single threaded using the generic MPT_MGMT struct.
3) rewrite taskmanagement request and completion routines, making them single threaded and using the generic MPT_MGMT struct, deleting mptscsih_TMHandler, replacing with single request TM handler mptscsih_IssueTaskMgmt, and killing the watchdog timer functions.
4) moving mptscsih_quiesce_raid over from mptspi, using the single threaded internal command changes.

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>

--- b/drivers/message/fusion/mptscsih.c	2007-09-17 17:01:40.000000000 -0600
+++ a/drivers/message/fusion/mptscsih.c	2007-09-17 17:11:46.000000000 -0600
@@ -92,16 +92,10 @@ static int	mptscsih_AddSGE(MPT_ADAPTER *
 				 SCSIIORequest_t *pReq, int req_idx);
 static void	mptscsih_freeChainBuffers(MPT_ADAPTER *ioc, int req_idx);
 static void	mptscsih_copy_sense_data(struct scsi_cmnd *sc, MPT_SCSI_HOST *hd, MPT_FRAME_HDR *mf, SCSIIOReply_t *pScsiReply);
-static int	mptscsih_tm_pending_wait(MPT_SCSI_HOST * hd);
-static int	mptscsih_tm_wait_for_completion(MPT_SCSI_HOST * hd, ulong timeout );
-
-static int	mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int lun, int ctx2abort, ulong timeout);
 
 int		mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);
 int		mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply);
 
-int		mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
-static int	mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *iocmd);
 static void	mptscsih_synchronize_cache(MPT_SCSI_HOST *hd, VirtDevice *vdevice);
 
 void 		mptscsih_remove(struct pci_dev *);
@@ -1082,7 +1076,7 @@ static void
 mptscsih_report_queue_full(struct scsi_cmnd *sc, SCSIIOReply_t *pScsiReply, SCSIIORequest_t *pScsiReq)
 {
 	long time = jiffies;
-	MPT_SCSI_HOST		*hd;
+	MPT_SCSI_HOST	*hd;
 	MPT_ADAPTER	*ioc;
 
 	if (sc->device == NULL)
@@ -1109,7 +1103,7 @@ mptscsih_report_queue_full(struct scsi_c
 void
 mptscsih_remove(struct pci_dev *pdev)
 {
-	MPT_ADAPTER 		*ioc = pci_get_drvdata(pdev);
+	MPT_ADAPTER		*ioc = pci_get_drvdata(pdev);
 	struct Scsi_Host 	*host = ioc->sh;
 	MPT_SCSI_HOST		*hd;
 	int sz1;
@@ -1337,7 +1331,6 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, v
 	MPT_FRAME_HDR		*mf;
 	SCSIIORequest_t		*pScsiReq;
 	VirtDevice		*vdevice = SCpnt->device->hostdata;
-	int	 lun;
 	u32	 datalen;
 	u32	 scsictl;
 	u32	 scsidir;
@@ -1348,24 +1341,20 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, v
 
 	hd = shost_priv(SCpnt->device->host);
 	ioc = hd->ioc;
-	lun = SCpnt->device->lun;
 	SCpnt->scsi_done = done;
 
 	dmfprintk(ioc, printk(MYIOC_s_DEBUG_FMT "qcmd: SCpnt=%p, done()=%p\n",
 		ioc->name, SCpnt, done));
 
-	if (hd->resetPending) {
-		dtmprintk(ioc, printk(MYIOC_s_WARN_FMT "qcmd: SCpnt=%p timeout + 60HZ\n",
-			ioc->name, SCpnt));
+	if (ioc->taskmgmt_quiesce_io)
 		return SCSI_MLQUEUE_HOST_BUSY;
-	}
 
 	/*
 	 *  Put together a MPT SCSI request...
 	 */
 	if ((mf = mpt_get_msg_frame(ioc->DoneCtx, ioc)) == NULL) {
 		dprintk(ioc, printk(MYIOC_s_WARN_FMT "QueueCmd, no msg frames!!\n",
-				ioc->name));
+			ioc->name));
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
@@ -1517,119 +1506,290 @@ mptscsih_freeChainBuffers(MPT_ADAPTER *i
  *	Reset Handling
  */
 
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/**
- *	mptscsih_TMHandler - Generic handler for SCSI Task Management.
- *	@hd: Pointer to MPT SCSI HOST structure
- *	@type: Task Management type
- *	@channel: channel number for task management
- *	@id: Logical Target ID for reset (if appropriate)
- *	@lun: Logical Unit for reset (if appropriate)
- *	@ctx2abort: Context for the task to be aborted (if appropriate)
- *	@timeout: timeout for task management control
- *
- *	Fall through to mpt_HardResetHandler if: not operational, too many
- *	failed TM requests or handshake failure.
- *
- *	Remark: Currently invoked from a non-interrupt thread (_bh).
- *
- *	Remark: With old EH code, at most 1 SCSI TaskMgmt function per IOC
- *	will be active.
- *
- *	Returns 0 for SUCCESS, or %FAILED.
- **/
-int
-mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int lun, int ctx2abort, ulong timeout)
+static int
+mptscsih_scandv_bus_reset(MPT_ADAPTER *ioc)
 {
-	MPT_ADAPTER	*ioc;
-	int		 rc = -1;
-	u32		 ioc_raw_state;
-	unsigned long	 flags;
+	MPT_FRAME_HDR	*mf;
+	SCSITaskMgmt_t	*pScsiTm;
+	SCSITaskMgmtReply_t *pScsiTmReply;
+	int		 ii;
+	int		 retval;
+	unsigned long	 timeout;
+	unsigned long	 time_count;
+	u16		 iocstatus;
+
+	mutex_lock(&ioc->taskmgmt_cmds.mutex);
+	if (mpt_set_taskmgmt_in_progress_flag(ioc) != 0) {
+		mutex_unlock(&ioc->taskmgmt_cmds.mutex);
+		return -EPERM;
+	}
 
-	ioc = hd->ioc;
-	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "TMHandler Entered!\n", ioc->name));
+	/* Send request
+	 */
+	if ((mf = mpt_get_msg_frame(ioc->TaskCtx, ioc)) == NULL) {
+		dtmprintk(ioc, printk(MYIOC_s_WARN_FMT "TaskMgmt, no msg frames!!\n",
+				ioc->name));
+		mpt_clear_taskmgmt_in_progress_flag(ioc);
+		retval = -ENOMEM;
+		goto out;
+	}
 
-	// SJR - CHECKME - Can we avoid this here?
-	// (mpt_HardResetHandler has this check...)
-	spin_lock_irqsave(&ioc->diagLock, flags);
-	if ((ioc->diagPending) || (ioc->alt_ioc && ioc->alt_ioc->diagPending)) {
-		spin_unlock_irqrestore(&ioc->diagLock, flags);
-		return FAILED;
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "TaskMgmt request (mf=%p)\n",
+		ioc->name, mf));
+
+	pScsiTm = (SCSITaskMgmt_t *) mf;
+	memset(pScsiTm, 0, sizeof(SCSITaskMgmt_t));
+	pScsiTm->Function = MPI_FUNCTION_SCSI_TASK_MGMT;
+	pScsiTm->TaskType = MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS;
+	pScsiTm->MsgFlags = MPI_SCSITASKMGMT_MSGFLAGS_LIPRESET_RESET_OPTION;
+	pScsiTm->TargetID = 0;
+	pScsiTm->Bus = 0;
+	pScsiTm->ChainOffset = 0;
+	pScsiTm->Reserved = 0;
+	pScsiTm->Reserved1 = 0;
+	pScsiTm->TaskMsgContext = 0;
+	for (ii= 0; ii < 8; ii++)
+		pScsiTm->LUN[ii] = 0;
+	for (ii=0; ii < 7; ii++)
+		pScsiTm->Reserved2[ii] = 0;
+
+	switch (ioc->bus_type) {
+		case FC:
+			timeout = 40;
+			break;
+		case SAS:
+			timeout = 30;
+			break;
+		case SPI:
+		default:
+			timeout = 2;
+			break;
 	}
-	spin_unlock_irqrestore(&ioc->diagLock, flags);
 
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
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "TaskMgmt type=%d timeout=%ld\n",
+	    ioc->name, MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS, timeout));
+
+	INITIALIZE_MGMT_STATUS(ioc->taskmgmt_cmds.status)
+	CLEAR_MGMT_STATUS(ioc->internal_cmds.status)
+	retval = 0;
+	time_count = jiffies;
+	if ((ioc->facts.IOCCapabilities & MPI_IOCFACTS_CAPABILITY_HIGH_PRI_Q) &&
+	    (ioc->facts.MsgVersion >= MPI_VERSION_01_05))
+		mpt_put_msg_frame_hi_pri(ioc->TaskCtx, ioc, mf);
+	else {
+		retval = mpt_send_handshake_request(ioc->TaskCtx, ioc,
+		    sizeof(SCSITaskMgmt_t), (u32*)pScsiTm, CAN_SLEEP);
+		if (retval != 0) {
+			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT "TaskMgmt send_handshake FAILED!"
+				" (ioc %p, mf %p, rc=%d) \n", ioc->name,
+				ioc, mf, retval));
+			mpt_clear_taskmgmt_in_progress_flag(ioc);
+			goto out;
 		}
-	} else {
-		spin_lock_irqsave(&ioc->FreeQlock, flags);
-		hd->tmPending |=  (1 << type);
-		spin_unlock_irqrestore(&ioc->FreeQlock, flags);
 	}
 
-	ioc_raw_state = mpt_GetIocState(ioc, 0);
+	/* Now wait for the command to complete */
+	ii = wait_for_completion_timeout(&ioc->taskmgmt_cmds.done, timeout*HZ);
+	if (!(ioc->taskmgmt_cmds.status & MPT_MGMT_STATUS_COMMAND_GOOD)) {
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "TaskMgmt failed\n", ioc->name));
+		mpt_free_msg_frame(ioc, mf);
+		mpt_clear_taskmgmt_in_progress_flag(ioc);
+		retval = -1; /* return failure */
+		goto out;
+	}
 
-	if ((ioc_raw_state & MPI_IOC_STATE_MASK) != MPI_IOC_STATE_OPERATIONAL) {
-		printk(MYIOC_s_WARN_FMT
-			"TM Handler for type=%x: IOC Not operational (0x%x)!\n",
-			ioc->name, type, ioc_raw_state);
-		printk(MYIOC_s_WARN_FMT " Issuing HardReset!!\n", ioc->name);
-		if (mpt_HardResetHandler(ioc, CAN_SLEEP) < 0)
-			printk(MYIOC_s_WARN_FMT "TMHandler: HardReset "
-			    "FAILED!!\n", ioc->name);
-		return FAILED;
+	if (!(ioc->taskmgmt_cmds.status & MPT_MGMT_STATUS_RF_VALID)) {
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "TaskMgmt failed\n", ioc->name));
+		retval = -1; /* return failure */
+		goto out;
 	}
 
-	if (ioc_raw_state & MPI_DOORBELL_ACTIVE) {
-		printk(MYIOC_s_WARN_FMT
-			"TM Handler for type=%x: ioc_state: "
-			"DOORBELL_ACTIVE (0x%x)!\n",
-			ioc->name, type, ioc_raw_state);
-		return FAILED;
+	pScsiTmReply = (SCSITaskMgmtReply_t *) ioc->taskmgmt_cmds.reply;
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+	    "TaskMgmt fw_channel = %d, fw_id = %d, task_type = 0x%02X,\n"
+	    "\tiocstatus = 0x%04X, loginfo = 0x%08X, response_code = 0x%02X,\n"
+	    "\tterm_cmnds = %d\n", ioc->name, pScsiTmReply->Bus,
+	    pScsiTmReply->TargetID, MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,
+	    le16_to_cpu(pScsiTmReply->IOCStatus),
+	    le32_to_cpu(pScsiTmReply->IOCLogInfo),
+	    pScsiTmReply->ResponseCode,
+	    le32_to_cpu(pScsiTmReply->TerminationCount)));
+
+	iocstatus = le16_to_cpu(pScsiTmReply->IOCStatus) & MPI_IOCSTATUS_MASK;
+
+	if (iocstatus == MPI_IOCSTATUS_SCSI_TASK_TERMINATED ||
+	   iocstatus == MPI_IOCSTATUS_SCSI_IOC_TERMINATED ||
+	   iocstatus == MPI_IOCSTATUS_SUCCESS)
+		retval = 0;
+	else {
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "TaskMgmt failed\n", ioc->name));
+		retval = -1; /* return failure */
 	}
 
-	/* Isse the Task Mgmt request.
-	 */
-	if (hd->hard_resets < -1)
-		hd->hard_resets++;
+ out:
+	mutex_unlock(&ioc->taskmgmt_cmds.mutex);
+	CLEAR_MGMT_STATUS(ioc->taskmgmt_cmds.status)
+	return retval;
+}
 
-	rc = mptscsih_IssueTaskMgmt(hd, type, channel, id, lun,
-	    ctx2abort, timeout);
-	if (rc)
-		printk(MYIOC_s_INFO_FMT "Issue of TaskMgmt failed!\n",
-		       ioc->name);
-	else
-		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Issue of TaskMgmt Successful!\n",
-			   ioc->name));
+int
+mptscsih_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
+{
+	MPT_SCSI_HOST	*hd;
+
+	if ((ioc->sh == NULL) || (ioc->sh->hostdata == NULL))
+		return 0;
+
+	switch (reset_phase) {
+	case MPT_IOC_SETUP_RESET:
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "%s: MPT_IOC_SETUP_RESET\n", ioc->name, __FUNCTION__));
+		break;
+	case MPT_IOC_PRE_RESET:
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "%s: MPT_IOC_PRE_RESET\n", ioc->name, __FUNCTION__));
+		hd = shost_priv(ioc->sh);
+		mptscsih_flush_running_cmds(hd);
+		break;
+	case MPT_IOC_POST_RESET:
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "%s: MPT_IOC_POST_RESET\n", ioc->name, __FUNCTION__));
+		if (ioc->internal_cmds.status & MPT_MGMT_STATUS_PENDING) {
+			ioc->internal_cmds.status |= MPT_MGMT_STATUS_DID_IOCRESET;
+			complete(&ioc->internal_cmds.done);
+		}
+		break;
+	default:
+		break;
+	}
+	return 1;		/* currently means nothing really */
+}
+
+static void
+mptscsih_taskmgmt_response_code(MPT_ADAPTER *ioc, u8 response_code)
+{
+	char *desc;
+
+	switch (response_code) {
+	case MPI_SCSITASKMGMT_RSP_TM_COMPLETE:
+		desc = "The task completed.";
+		break;
+	case MPI_SCSITASKMGMT_RSP_INVALID_FRAME:
+		desc = "The IOC received an invalid frame status.";
+		break;
+	case MPI_SCSITASKMGMT_RSP_TM_NOT_SUPPORTED:
+		desc = "The task type is not supported.";
+		break;
+	case MPI_SCSITASKMGMT_RSP_TM_FAILED:
+		desc = "The requested task failed.";
+		break;
+	case MPI_SCSITASKMGMT_RSP_TM_SUCCEEDED:
+		desc = "The task completed successfully.";
+		break;
+	case MPI_SCSITASKMGMT_RSP_TM_INVALID_LUN:
+		desc = "The LUN request is invalid.";
+		break;
+	case MPI_SCSITASKMGMT_RSP_IO_QUEUED_ON_IOC:
+		desc = "The task is in the IOC queue and has not been sent to target.";
+		break;
+	default:
+		desc = "unknown";
+		break;
+	}
+	printk(MYIOC_s_DEBUG_FMT "Response Code(0x%08x): F/W: %s\n",
+		ioc->name, response_code, desc);
+}
+
+static int
+mptscsih_taskmgmt_reply(MPT_ADAPTER *ioc, u8 type, SCSITaskMgmtReply_t *pScsiTmReply)
+{
+	u16			 iocstatus;
+	u32			 termination_count;
+	int			 retval;
+
+	if (!(ioc->taskmgmt_cmds.status & MPT_MGMT_STATUS_RF_VALID)) {
+		retval = FAILED;
+		goto out;
+	}
+
+	DBG_DUMP_TM_REPLY_FRAME(ioc, (u32 *)pScsiTmReply);
+
+	iocstatus = le16_to_cpu(pScsiTmReply->IOCStatus) & MPI_IOCSTATUS_MASK;
+	termination_count = le32_to_cpu(pScsiTmReply->TerminationCount);
 
 	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-			"TMHandler rc = %d!\n", ioc->name, rc));
+	    "TaskMgmt fw_channel = %d, fw_id = %d, task_type = 0x%02X,\n"
+	    "\tiocstatus = 0x%04X, loginfo = 0x%08X, response_code = 0x%02X,\n"
+	    "\tterm_cmnds = %d\n", ioc->name, pScsiTmReply->Bus,
+	    pScsiTmReply->TargetID, type, le16_to_cpu(pScsiTmReply->IOCStatus),
+	    le32_to_cpu(pScsiTmReply->IOCLogInfo), pScsiTmReply->ResponseCode,
+	    termination_count));
 
-	return rc;
+	if (ioc->facts.MsgVersion >= MPI_VERSION_01_05 &&
+	    pScsiTmReply->ResponseCode)
+		mptscsih_taskmgmt_response_code(ioc,
+		    pScsiTmReply->ResponseCode);
+
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
 
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/**
+ *	mptscsih_taskmgmt_complete - Registered with Fusion MPT base driver
+ *	@ioc: Pointer to MPT_ADAPTER structure
+ *	@mf: Pointer to SCSI task mgmt request frame
+ *	@mr: Pointer to SCSI task mgmt reply frame
+ *
+ *	This routine is called from mptbase.c::mpt_interrupt() at the completion
+ *	of any SCSI task management request.
+ *	This routine is registered with the MPT (base) driver at driver
+ *	load/init time via the mpt_register() API call.
+ *
+ *	Returns 1 indicating alloc'd request frame ptr should be freed.
+ **/
+int
+mptscsih_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
+{
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "TaskMgmt completed (mf=%p, mr=%p)\n",
+	    ioc->name, mf, mr));
+
+	ioc->taskmgmt_cmds.status |= MPT_MGMT_STATUS_COMMAND_GOOD;
+
+	if (!mr)
+		goto out;
+
+	ioc->taskmgmt_cmds.status |= MPT_MGMT_STATUS_RF_VALID;
+	memcpy(ioc->taskmgmt_cmds.reply, mr,
+	    min(MPT_DEFAULT_FRAME_SIZE, 4 * mr->u.reply.MsgLength));
+ out:
+	if (ioc->taskmgmt_cmds.status & MPT_MGMT_STATUS_PENDING) {
+		mpt_clear_taskmgmt_in_progress_flag(ioc);
+		ioc->taskmgmt_cmds.status &= ~MPT_MGMT_STATUS_PENDING;
+		complete(&ioc->taskmgmt_cmds.done);
+		return 1;
+	}
+	return 0;
+}
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
@@ -1650,7 +1810,7 @@ mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8
  *	Returns 0 for SUCCESS, or FAILED.
  *
  **/
-static int
+int
 mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int lun, int ctx2abort, ulong timeout)
 {
 	MPT_FRAME_HDR	*mf;
@@ -1658,15 +1818,51 @@ mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd
 	int		 ii;
 	int		 retval;
 	MPT_ADAPTER 	*ioc = hd->ioc;
+	unsigned long	 timeleft;
+	u8		 issue_hard_reset;
+	u32		 ioc_raw_state;
+	unsigned long	 time_count;
+
+	issue_hard_reset = 0;
+	ioc_raw_state = mpt_GetIocState(ioc, 0);
+
+	if ((ioc_raw_state & MPI_IOC_STATE_MASK) != MPI_IOC_STATE_OPERATIONAL) {
+		printk(MYIOC_s_WARN_FMT
+			"TaskMgmt type=%x: IOC Not operational (0x%x)!\n",
+			ioc->name, type, ioc_raw_state);
+		printk(MYIOC_s_WARN_FMT "Issuing HardReset from %s!!\n",
+		    ioc->name, __FUNCTION__);
+		if (mpt_HardResetHandler(ioc, CAN_SLEEP) < 0)
+			printk(MYIOC_s_WARN_FMT "TaskMgmt HardReset "
+			    "FAILED!!\n", ioc->name);
+		return 0;
+	}
+
+	if (ioc_raw_state & MPI_DOORBELL_ACTIVE) {
+		printk(MYIOC_s_WARN_FMT
+			"TaskMgmt type=%x: ioc_state: "
+			"DOORBELL_ACTIVE (0x%x)!\n",
+			ioc->name, type, ioc_raw_state);
+		return FAILED;
+	}
+
+	mutex_lock(&ioc->taskmgmt_cmds.mutex);
+	if (mpt_set_taskmgmt_in_progress_flag(ioc) != 0) {
+	mutex_unlock(&ioc->taskmgmt_cmds.mutex);
+		retval = FAILED;
+		goto out;
+	}
 
 	/* Return Fail to calling function if no message frames available.
 	 */
 	if ((mf = mpt_get_msg_frame(ioc->TaskCtx, ioc)) == NULL) {
-		dfailprintk(ioc, printk(MYIOC_s_ERR_FMT "IssueTaskMgmt, no msg frames!!\n",
+		dfailprintk(ioc, printk(MYIOC_s_ERR_FMT "TaskMgmt no msg frames!!\n",
 				ioc->name));
-		return FAILED;
+		retval = FAILED;
+		mpt_clear_taskmgmt_in_progress_flag(ioc);
+		goto out;
 	}
-	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "IssueTaskMgmt request @ %p\n",
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "TaskMgmt request (mf=%p)\n",
 			ioc->name, mf));
 
 	/* Format the Request
@@ -1690,11 +1886,14 @@ mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd
 
 	pScsiTm->TaskMsgContext = ctx2abort;
 
-	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "IssueTaskMgmt: ctx2abort (0x%08x) "
-		"type=%d\n", ioc->name, ctx2abort, type));
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "TaskMgmt: ctx2abort (0x%08x) "
+	    "task_type = 0x%02X, timeout = %ld\n", ioc->name, ctx2abort,
+	    type, timeout));
 
 	DBG_DUMP_TM_REQUEST_FRAME(ioc, (u32 *)pScsiTm);
 
+	INITIALIZE_MGMT_STATUS(ioc->taskmgmt_cmds.status)
+	time_count = jiffies;
 	if ((ioc->facts.IOCCapabilities & MPI_IOCFACTS_CAPABILITY_HIGH_PRI_Q) &&
 	    (ioc->facts.MsgVersion >= MPI_VERSION_01_05))
 		mpt_put_msg_frame_hi_pri(ioc->TaskCtx, ioc, mf);
@@ -1702,46 +1901,47 @@ mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd
 		retval = mpt_send_handshake_request(ioc->TaskCtx, ioc,
 			sizeof(SCSITaskMgmt_t), (u32*)pScsiTm, CAN_SLEEP);
 		if (retval) {
-			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT "send_handshake FAILED!"
-			" (hd %p, ioc %p, mf %p, rc=%d) \n", ioc->name, hd,
-			ioc, mf, retval));
-			goto fail_out;
+			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT "TaskMgmt handshake FAILED!"
+			    " (mf=%p, rc=%d) \n", ioc->name, mf, retval));
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
+	timeleft = wait_for_completion_timeout(&ioc->taskmgmt_cmds.done, timeout*HZ);
+	if (!(ioc->taskmgmt_cmds.status & MPT_MGMT_STATUS_COMMAND_GOOD)) {
+		retval = FAILED;
+		dtmprintk(ioc, printk(MYIOC_s_ERR_FMT
+		    "TaskMgmt TIMED OUT!(mf=%p)\n", ioc->name, mf));
+		mpt_free_msg_frame(ioc, mf);
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
-	 * Free task managment mf, and corresponding tm flags
-	 */
-	mpt_free_msg_frame(ioc, mf);
-	hd->tmPending = 0;
-	hd->tmState = TM_STATE_NONE;
-	return FAILED;
+	CLEAR_MGMT_STATUS(ioc->taskmgmt_cmds.status)
+	if(issue_hard_reset) {
+		printk(MYIOC_s_WARN_FMT "Issuing Reset from %s!!\n",
+		    ioc->name, __FUNCTION__);
+		if ((retval = mpt_SoftResetHandler(ioc, CAN_SLEEP)) != 0)
+			retval = mpt_HardResetHandler(ioc, CAN_SLEEP);
+	}
+
+	retval = (retval == 0) ? 0 : FAILED;
+	mutex_unlock(&ioc->taskmgmt_cmds.mutex);
+	return retval;
 }
 
 static int
@@ -1751,10 +1951,10 @@ mptscsih_get_tm_timeout(MPT_ADAPTER *ioc
 	case FC:
 		return 40;
 	case SAS:
-		return 10;
+		return 30;
 	case SPI:
 	default:
-		return 2;
+		return 10;
 	}
 }
 
@@ -1801,11 +2001,25 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 		    ioc->name, SCpnt));
 		SCpnt->result = DID_NO_CONNECT << 16;
 		SCpnt->scsi_done(SCpnt);
-		retval = 0;
+		retval = SUCCESS;
 		goto out;
 	}
 
-	/* Task aborts are not supported for hidden raid components.
+	/* Find this command
+	 */
+	if ((scpnt_idx = SCPNT_TO_LOOKUP_IDX(ioc, SCpnt)) < 0) {
+		/* Cmd not found in ScsiLookup.
+		 * Do OS callback.
+		 */
+		SCpnt->result = DID_RESET << 16;
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "task abort: command not in the active list! (sc=%p)\n",
+		    ioc->name, SCpnt));
+		retval = SUCCESS;
+		goto out;
+	}
+
+	/* Task aborts are not supported for hidden raid components.
 	 */
 	if (vdevice->vtarget->tflags & MPT_TARGET_FLAGS_RAID_COMPONENT) {
 		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
@@ -1816,27 +2030,20 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 		goto out;
 	}
 
-	/* Find this command
+	/* Task aborts are not supported for volumes.
 	 */
-	if ((scpnt_idx = SCPNT_TO_LOOKUP_IDX(ioc, SCpnt)) < 0) {
-		/* Cmd not found in ScsiLookup.
-		 * Do OS callback.
-		 */
+	if (vdevice->vtarget->raidVolume) {
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "task abort: raid volume (sc=%p)\n",
+		    ioc->name, SCpnt));
 		SCpnt->result = DID_RESET << 16;
-		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "task abort: "
-		   "Command not in the active list! (sc=%p)\n", ioc->name,
-		   SCpnt));
-		retval = 0;
-		goto out;
-	}
-
-	if (hd->resetPending) {
 		retval = FAILED;
 		goto out;
 	}
 
-	if (hd->timeouts < -1)
-		hd->timeouts++;
+	if (ioc->timeouts < -1)
+		ioc->timeouts++;
+
 
 	/* Most important!  Set TaskMsgContext to SCpnt's MsgContext!
 	 * (the IO to be ABORT'd)
@@ -1847,25 +2054,31 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 	 */
 	mf = MPT_INDEX_2_MFPTR(ioc, scpnt_idx);
 	ctx2abort = mf->u.frame.hwhdr.msgctxu.MsgContext;
-
-	hd->abortSCpnt = SCpnt;
-
-	retval = mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_ABORT_TASK,
+	mptscsih_IssueTaskMgmt(hd, MPI_SCSITASKMGMT_TASKTYPE_ABORT_TASK,
 	    vdevice->vtarget->channel, vdevice->vtarget->id, vdevice->lun,
 	    ctx2abort, mptscsih_get_tm_timeout(ioc));
 
+	/* check to see whether command actually completed and/or
+	 * terminated
+	 */
 	if (SCPNT_TO_LOOKUP_IDX(ioc, SCpnt) == scpnt_idx &&
-	    SCpnt->serial_number == sn)
+	    SCpnt->serial_number == sn) {
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "task abort: command still in active list! (sc=%p)\n",
+		    ioc->name, SCpnt));
 		retval = FAILED;
+	} else {
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "task abort: command cleared from active list! (sc=%p)\n",
+		    ioc->name, SCpnt));
+		retval = SUCCESS;
+	}
 
  out:
 	printk(MYIOC_s_INFO_FMT "task abort: %s (sc=%p)\n",
-	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
+	    ioc->name, ((retval == SUCCESS) ? "SUCCESS" : "FAILED" ), SCpnt);
 
-	if (retval == 0)
-		return SUCCESS;
-	else
-		return FAILED;
+	return retval;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -1898,14 +2111,9 @@ mptscsih_dev_reset(struct scsi_cmnd * SC
 	       ioc->name, SCpnt);
 	scsi_print_command(SCpnt);
 
-	if (hd->resetPending) {
-		retval = FAILED;
-		goto out;
-	}
-
 	vdevice = SCpnt->device->hostdata;
 	if (!vdevice || !vdevice->vtarget) {
-		retval = 0;
+		retval = SUCCESS;
 		goto out;
 	}
 
@@ -1916,12 +2124,12 @@ mptscsih_dev_reset(struct scsi_cmnd * SC
 		goto out;
 	}
 
-	retval = mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
-	    vdevice->vtarget->channel, vdevice->vtarget->id, 0, 0,
-	    mptscsih_get_tm_timeout(ioc));
+	retval = mptscsih_IssueTaskMgmt(hd,
+	    MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET, vdevice->vtarget->channel,
+	    vdevice->vtarget->id, 0, 0, mptscsih_get_tm_timeout(ioc));
 
  out:
-	printk (MYIOC_s_INFO_FMT "target reset: %s (sc=%p)\n",
+	printk(MYIOC_s_INFO_FMT "target reset: %s (sc=%p)\n",
 	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
 
 	if (retval == 0)
@@ -1946,7 +2154,7 @@ mptscsih_bus_reset(struct scsi_cmnd * SC
 	MPT_SCSI_HOST	*hd;
 	int		 retval;
 	VirtDevice	 *vdevice;
-	MPT_ADAPTER	*ioc;
+	MPT_ADAPTER *ioc;
 
 	/* If we can't locate our host adapter structure, return FAILED status.
 	 */
@@ -1961,11 +2169,13 @@ mptscsih_bus_reset(struct scsi_cmnd * SC
 	       ioc->name, SCpnt);
 	scsi_print_command(SCpnt);
 
-	if (hd->timeouts < -1)
-		hd->timeouts++;
+	if (ioc->timeouts < -1)
+		ioc->timeouts++;
 
 	vdevice = SCpnt->device->hostdata;
-	retval = mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,
+	if (!vdevice || !vdevice->vtarget)
+		return SUCCESS;
+	retval = mptscsih_IssueTaskMgmt(hd, MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,
 	    vdevice->vtarget->channel, 0, 0, 0, mptscsih_get_tm_timeout(ioc));
 
 	printk(MYIOC_s_INFO_FMT "bus reset: %s (sc=%p)\n",
@@ -1990,8 +2200,9 @@ int
 mptscsih_host_reset(struct scsi_cmnd *SCpnt)
 {
 	MPT_SCSI_HOST *  hd;
-	int              retval;
-	MPT_ADAPTER	*ioc;
+	int              status = SUCCESS;
+	MPT_ADAPTER 	*ioc;
+	int		retval;
 
 	/*  If we can't locate the host to reset, then we failed. */
 	if ((hd = shost_priv(SCpnt->device->host)) == NULL){
@@ -2007,227 +2218,20 @@ mptscsih_host_reset(struct scsi_cmnd *SC
 	/*  If our attempts to reset the host failed, then return a failed
 	 *  status.  The host will be taken off line by the SCSI mid-layer.
 	 */
-	if (mpt_HardResetHandler(ioc, CAN_SLEEP) < 0) {
-		retval = FAILED;
-	} else {
-		/*  Make sure TM pending is cleared and TM state is set to
-		 *  NONE.
-		 */
-		retval = 0;
-		hd->tmPending = 0;
-		hd->tmState = TM_STATE_NONE;
-	}
+	if ((retval = mpt_SoftResetHandler(ioc, CAN_SLEEP)) != 0)
+		retval = mpt_HardResetHandler(ioc, CAN_SLEEP);
+
+	if (retval < 0)
+		status = FAILED;
+	else
+		status = SUCCESS;
 
 	printk(MYIOC_s_INFO_FMT "host reset: %s (sc=%p)\n",
 	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
 
-	return retval;
-}
-
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/**
- *	mptscsih_tm_pending_wait - wait for pending task management request to complete
- *	@hd: Pointer to MPT host structure.
- *
- *	Returns {SUCCESS,FAILED}.
- */
-static int
-mptscsih_tm_pending_wait(MPT_SCSI_HOST * hd)
-{
-	unsigned long  flags;
-	int            loop_count = 4 * 10;  /* Wait 10 seconds */
-	int            status = FAILED;
-	MPT_ADAPTER	*ioc = hd->ioc;
-
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
-
-	return status;
-}
-
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
-
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
-
 	return status;
 }
 
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-static void
-mptscsih_taskmgmt_response_code(MPT_ADAPTER *ioc, u8 response_code)
-{
-	char *desc;
-
-	switch (response_code) {
-	case MPI_SCSITASKMGMT_RSP_TM_COMPLETE:
-		desc = "The task completed.";
-		break;
-	case MPI_SCSITASKMGMT_RSP_INVALID_FRAME:
-		desc = "The IOC received an invalid frame status.";
-		break;
-	case MPI_SCSITASKMGMT_RSP_TM_NOT_SUPPORTED:
-		desc = "The task type is not supported.";
-		break;
-	case MPI_SCSITASKMGMT_RSP_TM_FAILED:
-		desc = "The requested task failed.";
-		break;
-	case MPI_SCSITASKMGMT_RSP_TM_SUCCEEDED:
-		desc = "The task completed successfully.";
-		break;
-	case MPI_SCSITASKMGMT_RSP_TM_INVALID_LUN:
-		desc = "The LUN request is invalid.";
-		break;
-	case MPI_SCSITASKMGMT_RSP_IO_QUEUED_ON_IOC:
-		desc = "The task is in the IOC queue and has not been sent to target.";
-		break;
-	default:
-		desc = "unknown";
-		break;
-	}
-	printk(MYIOC_s_INFO_FMT "Response Code(0x%08x): F/W: %s\n",
-		ioc->name, response_code, desc);
-}
-
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/**
- *	mptscsih_taskmgmt_complete - Registered with Fusion MPT base driver
- *	@ioc: Pointer to MPT_ADAPTER structure
- *	@mf: Pointer to SCSI task mgmt request frame
- *	@mr: Pointer to SCSI task mgmt reply frame
- *
- *	This routine is called from mptbase.c::mpt_interrupt() at the completion
- *	of any SCSI task management request.
- *	This routine is registered with the MPT (base) driver at driver
- *	load/init time via the mpt_register() API call.
- *
- *	Returns 1 indicating alloc'd request frame ptr should be freed.
- **/
-int
-mptscsih_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
-{
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
-
-	if (ioc->facts.MsgVersion >= MPI_VERSION_01_05 &&
-	    pScsiTmReply->ResponseCode)
-		mptscsih_taskmgmt_response_code(ioc,
-		    pScsiTmReply->ResponseCode);
-	DBG_DUMP_TM_REPLY_FRAME(ioc, (u32 *)pScsiTmReply);
-
-#ifdef CONFIG_FUSION_LOGGING
-	if ((ioc->debug_level & MPT_DEBUG_REPLY) ||
-				(ioc->debug_level & MPT_DEBUG_TM ))
-		printk("%s: ha=%d [%d:%d:0] task_type=0x%02X "
-			"iocstatus=0x%04X\n\tloginfo=0x%08X response_code=0x%02X "
-			"term_cmnds=%d\n", __FUNCTION__, ioc->id, pScsiTmReply->Bus,
-			 pScsiTmReply->TargetID, pScsiTmReq->TaskType,
-			le16_to_cpu(pScsiTmReply->IOCStatus),
-			le32_to_cpu(pScsiTmReply->IOCLogInfo),pScsiTmReply->ResponseCode,
-			le32_to_cpu(pScsiTmReply->TerminationCount));
-#endif
-	if (!iocstatus) {
-		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT " TaskMgmt SUCCESS\n", ioc->name));
-			hd->abortSCpnt = NULL;
-		goto out;
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
-
- out:
-	spin_lock_irqsave(&ioc->FreeQlock, flags);
-	hd->tmPending = 0;
-	hd->tmState = TM_STATE_NONE;
-	hd->tm_iocstatus = iocstatus;
-	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
-
-	return 1;
-}
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
@@ -2276,7 +2280,7 @@ int
 mptscsih_is_phys_disk(MPT_ADAPTER *ioc, u8 channel, u8 id)
 {
 	struct inactive_raid_component_info *component_info;
-	int i;
+	u8 i;
 	int rc = 0;
 
 	if (!ioc->raid_data.pIocPg3)
@@ -2487,7 +2491,7 @@ mptscsih_copy_sense_data(struct scsi_cmn
 	VirtDevice	*vdevice;
 	SCSIIORequest_t	*pReq;
 	u32		 sense_count = le32_to_cpu(pScsiReply->SenseCount);
-	MPT_ADAPTER 	*ioc = hd->ioc;
+	MPT_ADAPTER	*ioc = hd->ioc;
 
 	/* Get target structure
 	 */
@@ -2634,380 +2638,221 @@ SCPNT_TO_LOOKUP_IDX(MPT_ADAPTER *ioc, st
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 int
-mptscsih_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
+mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply)
 {
-	MPT_SCSI_HOST	*hd;
-	unsigned long	 flags;
-
-	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-	    ": IOC %s_reset routed to SCSI host driver!\n",
-	    ioc->name, reset_phase==MPT_IOC_SETUP_RESET ? "setup" : (
-	    reset_phase==MPT_IOC_PRE_RESET ? "pre" : "post")));
-
-	/* If a FW reload request arrives after base installed but
-	 * before all scsi hosts have been attached, then an alt_ioc
-	 * may have a NULL sh pointer.
-	 */
-	if (ioc->sh == NULL || shost_priv(ioc->sh) == NULL)
-		return 0;
-	else
-		hd = shost_priv(ioc->sh);
-
-	if (reset_phase == MPT_IOC_SETUP_RESET) {
-		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Setup-Diag Reset\n", ioc->name));
-
-		/* Clean Up:
-		 * 1. Set Hard Reset Pending Flag
-		 * All new commands go to doneQ
-		 */
-		hd->resetPending = 1;
-
-	} else if (reset_phase == MPT_IOC_PRE_RESET) {
-		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Pre-Diag Reset\n", ioc->name));
+	u8 event = le32_to_cpu(pEvReply->Event) & 0xFF;
 
-		/* 2. Flush running commands
-		 *	Clean ScsiLookup (and associated memory)
-		 *	AND clean mytaskQ
-		 */
+	devtverboseprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+	    "MPT event (=%02Xh) routed to SCSI host driver!\n",
+	    ioc->name, event));
 
-		/* 2b. Reply to OS all known outstanding I/O commands.
-		 */
-		mptscsih_flush_running_cmds(hd);
+	if ((event == MPI_EVENT_IOC_BUS_RESET ||
+	    event == MPI_EVENT_EXT_BUS_RESET) &&
+	    (ioc->bus_type == SPI) && (ioc->soft_resets < -1))
+			ioc->soft_resets++;
 
-		/* 2c. If there was an internal command that
-		 * has not completed, configuration or io request,
-		 * free these resources.
-		 */
-		if (hd->cmdPtr) {
-			del_timer(&hd->timer);
-			mpt_free_msg_frame(ioc, hd->cmdPtr);
-		}
+	return 1;		/* currently means nothing really */
+}
 
-		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Pre-Reset complete.\n", ioc->name));
+int
+mptscsih_quiesce_raid(MPT_SCSI_HOST *hd, int quiesce, u8 channel, u8 id)
+{
+	MPT_ADAPTER 		*ioc = hd->ioc;
+	MpiRaidActionRequest_t	*pReq;
+	MPT_FRAME_HDR		*mf;
+	int			ret;
+	unsigned long	 	timeleft;
 
-	} else {
-		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Post-Diag Reset\n", ioc->name));
+	mutex_lock(&ioc->internal_cmds.mutex);
 
-		/* Once a FW reload begins, all new OS commands are
-		 * redirected to the doneQ w/ a reset status.
-		 * Init all control structures.
-		 */
+	/* Get and Populate a free Frame
+	 */
+	if ((mf = mpt_get_msg_frame(ioc->InternalCtx, ioc)) == NULL) {
+		dfailprintk(hd->ioc, printk(MYIOC_s_WARN_FMT "%s: no msg frames!\n",
+			ioc->name, __FUNCTION__));
+		ret = -EAGAIN;
+		goto out;
+	}
+	pReq = (MpiRaidActionRequest_t *)mf;
+	if (quiesce)
+		pReq->Action = MPI_RAID_ACTION_QUIESCE_PHYS_IO;
+	else
+		pReq->Action = MPI_RAID_ACTION_ENABLE_PHYS_IO;
+	pReq->Reserved1 = 0;
+	pReq->ChainOffset = 0;
+	pReq->Function = MPI_FUNCTION_RAID_ACTION;
+	pReq->VolumeID = id;
+	pReq->VolumeBus = channel;
+	pReq->PhysDiskNum = 0;
+	pReq->MsgFlags = 0;
+	pReq->Reserved2 = 0;
+	pReq->ActionDataWord = 0; /* Reserved for this action */
 
-		/* 2. Chain Buffer initialization
-		 */
+	mptscsih_add_sge((char *)&pReq->ActionDataSGE,
+		MPT_SGE_FLAGS_SSIMPLE_READ | 0, (dma_addr_t) -1);
 
-		/* 4. Renegotiate to all devices, if SPI
-		 */
+	ddvprintk(ioc, printk(MYIOC_s_DEBUG_FMT "RAID Volume action=%x channel=%d id=%d\n",
+			ioc->name, pReq->Action, channel, id));
 
-		/* 5. Enable new commands to be posted
-		 */
-		spin_lock_irqsave(&ioc->FreeQlock, flags);
-		hd->tmPending = 0;
-		spin_unlock_irqrestore(&ioc->FreeQlock, flags);
-		hd->resetPending = 0;
-		hd->tmState = TM_STATE_NONE;
-
-		/* 6. If there was an internal command,
-		 * wake this process up.
-		 */
-		if (hd->cmdPtr) {
-			/*
-			 * Wake up the original calling thread
-			 */
-			hd->pLocal = &hd->localReply;
-			hd->pLocal->completion = MPT_SCANDV_DID_RESET;
-			hd->scandv_wait_done = 1;
-			wake_up(&hd->scandv_waitq);
-			hd->cmdPtr = NULL;
+	INITIALIZE_MGMT_STATUS(ioc->internal_cmds.status)
+	mpt_put_msg_frame(ioc->InternalCtx, ioc, mf);
+	timeleft = wait_for_completion_timeout(&ioc->internal_cmds.done, 10*HZ);
+	if (!(ioc->internal_cmds.status & MPT_MGMT_STATUS_COMMAND_GOOD)) {
+		ret = -ETIME;
+		dfailprintk(ioc, printk(MYIOC_s_DEBUG_FMT "%s: TIMED OUT!\n",
+		    ioc->name, __FUNCTION__));
+		mpt_free_msg_frame(ioc, mf);
+		if (ioc->internal_cmds.status & MPT_MGMT_STATUS_DID_IOCRESET)
+			goto out;
+		if (!timeleft) {
+			printk(MYIOC_s_WARN_FMT "Issuing Reset from %s!!\n",
+			    ioc->name, __FUNCTION__);
+			if (mpt_SoftResetHandler(ioc, CAN_SLEEP) != 0)
+				mpt_HardResetHandler(ioc, CAN_SLEEP);
 		}
-
-		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Post-Reset complete.\n", ioc->name));
-
+		goto out;
 	}
 
-	return 1;		/* currently means nothing really */
+	ret = ioc->internal_cmds.completion_code;
+
+ out:
+	CLEAR_MGMT_STATUS(ioc->internal_cmds.status)
+	mutex_unlock(&ioc->internal_cmds.mutex);
+	return ret;
 }
 
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-int
-mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply)
+/**
+ *	mptscsih_get_completion_code -
+ *	@ioc: Pointer to MPT_ADAPTER structure
+ *	@reply:
+ *	@cmd:
+ *
+ **/
+static int
+mptscsih_get_completion_code(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req, MPT_FRAME_HDR *reply)
 {
-	MPT_SCSI_HOST *hd;
-	u8 event = le32_to_cpu(pEvReply->Event) & 0xFF;
-
-	devtverboseprintk(ioc, printk(MYIOC_s_DEBUG_FMT "MPT event (=%02Xh) routed to SCSI host driver!\n",
-			ioc->name, event));
-
-	if (ioc->sh == NULL ||
-		((hd = shost_priv(ioc->sh)) == NULL))
-		return 1;
-
-	switch (event) {
-	case MPI_EVENT_UNIT_ATTENTION:			/* 03 */
-		/* FIXME! */
-		break;
-	case MPI_EVENT_IOC_BUS_RESET:			/* 04 */
-	case MPI_EVENT_EXT_BUS_RESET:			/* 05 */
-		if (hd && (ioc->bus_type == SPI) && (hd->soft_resets < -1))
-			hd->soft_resets++;
-		break;
-	case MPI_EVENT_LOGOUT:				/* 09 */
-		/* FIXME! */
-		break;
-
-	case MPI_EVENT_RESCAN:				/* 06 */
-		break;
-
-		/*
-		 *  CHECKME! Don't think we need to do
-		 *  anything for these, but...
-		 */
-	case MPI_EVENT_LINK_STATUS_CHANGE:		/* 07 */
-	case MPI_EVENT_LOOP_STATE_CHANGE:		/* 08 */
-		/*
-		 *  CHECKME!  Falling thru...
-		 */
+	SCSIIOReply_t	*pReply;
+	MpiRaidActionReply_t *pr;
+	u8		 scsi_status;
+	u16		 status;
+	int		 completion_code;
+
+	pReply = (SCSIIOReply_t *)reply;
+	status = le16_to_cpu(pReply->IOCStatus) & MPI_IOCSTATUS_MASK;
+	scsi_status = pReply->SCSIStatus;
+
+	devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+	    "IOCStatus=%04xh, SCSIState=%02xh, SCSIStatus=%02xh, IOCLogInfo=%08xh\n",
+	     ioc->name, status, pReply->SCSIState, scsi_status, le32_to_cpu(pReply->IOCLogInfo)));
+
+	switch(status) {
+
+	case MPI_IOCSTATUS_SCSI_DEVICE_NOT_THERE:	/* 0x0043 */
+		completion_code = MPT_SCANDV_SELECTION_TIMEOUT;
+		break;
+
+	case MPI_IOCSTATUS_SCSI_IO_DATA_ERROR:		/* 0x0046 */
+	case MPI_IOCSTATUS_SCSI_TASK_TERMINATED:	/* 0x0048 */
+	case MPI_IOCSTATUS_SCSI_IOC_TERMINATED:		/* 0x004B */
+	case MPI_IOCSTATUS_SCSI_EXT_TERMINATED:		/* 0x004C */
+		completion_code = MPT_SCANDV_DID_RESET;
+		break;
+
+	case MPI_IOCSTATUS_SCSI_DATA_UNDERRUN:		/* 0x0045 */
+	case MPI_IOCSTATUS_SCSI_RECOVERED_ERROR:	/* 0x0040 */
+	case MPI_IOCSTATUS_SUCCESS:			/* 0x0000 */
+		if (pReply->Function == MPI_FUNCTION_CONFIG) {
+			completion_code = MPT_SCANDV_GOOD;
+		} else if (pReply->Function == MPI_FUNCTION_RAID_ACTION) {
+			pr = (MpiRaidActionReply_t *)reply;
+			if (le16_to_cpu(pr->ActionStatus) == MPI_RAID_ACTION_ASTATUS_SUCCESS)
+				completion_code = MPT_SCANDV_GOOD;
+			else
+				completion_code = MPT_SCANDV_SOME_ERROR;
+		} else if (pReply->SCSIState & MPI_SCSI_STATE_AUTOSENSE_VALID)
+			completion_code = MPT_SCANDV_SENSE;
+		else if (pReply->SCSIState & MPI_SCSI_STATE_AUTOSENSE_FAILED) {
+			if (req->u.scsireq.CDB[0] == INQUIRY)
+				completion_code = MPT_SCANDV_ISSUE_SENSE;
+			else
+				completion_code = MPT_SCANDV_DID_RESET;
+		}
+		else if (pReply->SCSIState & MPI_SCSI_STATE_NO_SCSI_STATUS)
+			completion_code = MPT_SCANDV_DID_RESET;
+		else if (pReply->SCSIState & MPI_SCSI_STATE_TERMINATED)
+			completion_code = MPT_SCANDV_DID_RESET;
+		else if (scsi_status == MPI_SCSI_STATUS_BUSY)
+			completion_code = MPT_SCANDV_BUSY;
+		else
+			completion_code = MPT_SCANDV_GOOD;
 		break;
 
-	case MPI_EVENT_INTEGRATED_RAID:			/* 0B */
+	case MPI_IOCSTATUS_SCSI_PROTOCOL_ERROR:		/* 0x0047 */
+		if (pReply->SCSIState & MPI_SCSI_STATE_TERMINATED)
+			completion_code = MPT_SCANDV_DID_RESET;
+		else
+			completion_code = MPT_SCANDV_SOME_ERROR;
 		break;
-
-	case MPI_EVENT_NONE:				/* 00 */
-	case MPI_EVENT_LOG_DATA:			/* 01 */
-	case MPI_EVENT_STATE_CHANGE:			/* 02 */
-	case MPI_EVENT_EVENT_CHANGE:			/* 0A */
 	default:
-		dprintk(ioc, printk(MYIOC_s_DEBUG_FMT ": Ignoring event (=%02Xh)\n",
-		    ioc->name, event));
+		completion_code = MPT_SCANDV_SOME_ERROR;
 		break;
-	}
 
-	return 1;		/* currently means nothing really */
-}
+	}	/* switch(status) */
 
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/*
- *  Bus Scan and Domain Validation functionality ...
- */
+	devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+	    "  completionCode set to %08xh\n", ioc->name, completion_code));
+	return completion_code;
+}
 
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/*
- *	mptscsih_scandv_complete - Scan and DV callback routine registered
- *	to Fustion MPT (base) driver.
- *
+/**
+ *	mptscsih_scandv_complete -
  *	@ioc: Pointer to MPT_ADAPTER structure
- *	@mf: Pointer to original MPT request frame
- *	@mr: Pointer to MPT reply frame (NULL if TurboReply)
+ *	@req:
+ *	@reply:
  *
- *	This routine is called from mpt.c::mpt_interrupt() at the completion
- *	of any SCSI IO request.
- *	This routine is registered with the Fusion MPT (base) driver at driver
- *	load/init time via the mpt_register() API call.
- *
- *	Returns 1 indicating alloc'd request frame ptr should be freed.
- *
- *	Remark: Sets a completion code and (possibly) saves sense data
- *	in the IOC member localReply structure.
- *	Used ONLY for DV and other internal commands.
- */
+ **/
 int
-mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
+mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req, MPT_FRAME_HDR *reply)
 {
-	MPT_SCSI_HOST	*hd;
 	SCSIIORequest_t *pReq;
-	int		 completionCode;
+	SCSIIOReply_t	*pReply;
+	u8		 cmd;
 	u16		 req_idx;
+	u8		*sense_data;
+	int		 sz;
 
-	hd = shost_priv(ioc->sh);
-
-	if ((mf == NULL) ||
-	    (mf >= MPT_INDEX_2_MFPTR(ioc, ioc->req_depth))) {
-		printk(MYIOC_s_ERR_FMT
-			"ScanDvComplete, %s req frame ptr! (=%p)\n",
-				ioc->name, mf?"BAD":"NULL", (void *) mf);
-		goto wakeup;
-	}
-
-	del_timer(&hd->timer);
-	req_idx = le16_to_cpu(mf->u.frame.hwhdr.msgctxu.fld.req_idx);
-	mptscsih_set_scsi_lookup(ioc, req_idx, NULL);
-	pReq = (SCSIIORequest_t *) mf;
+	ioc->internal_cmds.status |= MPT_MGMT_STATUS_COMMAND_GOOD;
+	ioc->internal_cmds.completion_code = MPT_SCANDV_GOOD;
+	if (!reply)
+		goto out;
 
-	if (mf != hd->cmdPtr) {
-		printk(MYIOC_s_WARN_FMT "ScanDvComplete (mf=%p, cmdPtr=%p, idx=%d)\n",
-				ioc->name, (void *)mf, (void *) hd->cmdPtr, req_idx);
+	pReply = (SCSIIOReply_t *) reply;
+	pReq = (SCSIIORequest_t *) req;
+	ioc->internal_cmds.completion_code =
+	    mptscsih_get_completion_code(ioc, req, reply);
+	ioc->internal_cmds.status |= MPT_MGMT_STATUS_RF_VALID;
+	memcpy(ioc->internal_cmds.reply, reply,
+	    min(MPT_DEFAULT_FRAME_SIZE, 4 * reply->u.reply.MsgLength));
+	cmd = reply->u.hdr.Function;
+	if (((cmd == MPI_FUNCTION_SCSI_IO_REQUEST) ||
+	    (cmd == MPI_FUNCTION_RAID_SCSI_IO_PASSTHROUGH)) &&
+	    (pReply->SCSIState & MPI_SCSI_STATE_AUTOSENSE_VALID)) {
+		req_idx = le16_to_cpu(req->u.frame.hwhdr.msgctxu.fld.req_idx);
+		sense_data = ((u8 *)ioc->sense_buf_pool +
+		    (req_idx * MPT_SENSE_BUFFER_ALLOC));
+		sz = min_t(int, pReq->SenseBufferLength,
+		    MPT_SENSE_BUFFER_ALLOC);
+		memcpy(ioc->internal_cmds.sense, sense_data, sz);
 	}
-	hd->cmdPtr = NULL;
-
-	ddvprintk(ioc, printk(MYIOC_s_DEBUG_FMT "ScanDvComplete (mf=%p,mr=%p,idx=%d)\n",
-			ioc->name, mf, mr, req_idx));
-
-	hd->pLocal = &hd->localReply;
-	hd->pLocal->scsiStatus = 0;
-
-	/* If target struct exists, clear sense valid flag.
-	 */
-	if (mr == NULL) {
-		completionCode = MPT_SCANDV_GOOD;
-	} else {
-		SCSIIOReply_t	*pReply;
-		u16		 status;
-		u8		 scsi_status;
-
-		pReply = (SCSIIOReply_t *) mr;
-
-		status = le16_to_cpu(pReply->IOCStatus) & MPI_IOCSTATUS_MASK;
-		scsi_status = pReply->SCSIStatus;
-
-
-		switch(status) {
-
-		case MPI_IOCSTATUS_SCSI_DEVICE_NOT_THERE:	/* 0x0043 */
-			completionCode = MPT_SCANDV_SELECTION_TIMEOUT;
-			break;
-
-		case MPI_IOCSTATUS_SCSI_IO_DATA_ERROR:		/* 0x0046 */
-		case MPI_IOCSTATUS_SCSI_TASK_TERMINATED:	/* 0x0048 */
-		case MPI_IOCSTATUS_SCSI_IOC_TERMINATED:		/* 0x004B */
-		case MPI_IOCSTATUS_SCSI_EXT_TERMINATED:		/* 0x004C */
-			completionCode = MPT_SCANDV_DID_RESET;
-			break;
-
-		case MPI_IOCSTATUS_SCSI_DATA_UNDERRUN:		/* 0x0045 */
-		case MPI_IOCSTATUS_SCSI_RECOVERED_ERROR:	/* 0x0040 */
-		case MPI_IOCSTATUS_SUCCESS:			/* 0x0000 */
-			if (pReply->Function == MPI_FUNCTION_CONFIG) {
-				ConfigReply_t *pr = (ConfigReply_t *)mr;
-				completionCode = MPT_SCANDV_GOOD;
-				hd->pLocal->header.PageVersion = pr->Header.PageVersion;
-				hd->pLocal->header.PageLength = pr->Header.PageLength;
-				hd->pLocal->header.PageNumber = pr->Header.PageNumber;
-				hd->pLocal->header.PageType = pr->Header.PageType;
-
-			} else if (pReply->Function == MPI_FUNCTION_RAID_ACTION) {
-				/* If the RAID Volume request is successful,
-				 * return GOOD, else indicate that
-				 * some type of error occurred.
-				 */
-				MpiRaidActionReply_t	*pr = (MpiRaidActionReply_t *)mr;
-				if (le16_to_cpu(pr->ActionStatus) == MPI_RAID_ACTION_ASTATUS_SUCCESS)
-					completionCode = MPT_SCANDV_GOOD;
-				else
-					completionCode = MPT_SCANDV_SOME_ERROR;
-				memcpy(hd->pLocal->sense, pr, sizeof(hd->pLocal->sense));
-
-			} else if (pReply->SCSIState & MPI_SCSI_STATE_AUTOSENSE_VALID) {
-				u8		*sense_data;
-				int		 sz;
-
-				/* save sense data in global structure
-				 */
-				completionCode = MPT_SCANDV_SENSE;
-				hd->pLocal->scsiStatus = scsi_status;
-				sense_data = ((u8 *)ioc->sense_buf_pool +
-					(req_idx * MPT_SENSE_BUFFER_ALLOC));
-
-				sz = min_t(int, pReq->SenseBufferLength,
-							SCSI_STD_SENSE_BYTES);
-				memcpy(hd->pLocal->sense, sense_data, sz);
-
-				ddvprintk(ioc, printk(MYIOC_s_DEBUG_FMT "  Check Condition, sense ptr %p\n",
-				    ioc->name, sense_data));
-			} else if (pReply->SCSIState & MPI_SCSI_STATE_AUTOSENSE_FAILED) {
-				if (pReq->CDB[0] == INQUIRY)
-					completionCode = MPT_SCANDV_ISSUE_SENSE;
-				else
-					completionCode = MPT_SCANDV_DID_RESET;
-			}
-			else if (pReply->SCSIState & MPI_SCSI_STATE_NO_SCSI_STATUS)
-				completionCode = MPT_SCANDV_DID_RESET;
-			else if (pReply->SCSIState & MPI_SCSI_STATE_TERMINATED)
-				completionCode = MPT_SCANDV_DID_RESET;
-			else {
-				completionCode = MPT_SCANDV_GOOD;
-				hd->pLocal->scsiStatus = scsi_status;
-			}
-			break;
-
-		case MPI_IOCSTATUS_SCSI_PROTOCOL_ERROR:		/* 0x0047 */
-			if (pReply->SCSIState & MPI_SCSI_STATE_TERMINATED)
-				completionCode = MPT_SCANDV_DID_RESET;
-			else
-				completionCode = MPT_SCANDV_SOME_ERROR;
-			break;
-
-		default:
-			completionCode = MPT_SCANDV_SOME_ERROR;
-			break;
-
-		}	/* switch(status) */
-
-	} /* end of address reply case */
-
-	hd->pLocal->completion = completionCode;
-
-	/* MF and RF are freed in mpt_interrupt
-	 */
-wakeup:
-	/* Free Chain buffers (will never chain) in scan or dv */
-	//mptscsih_freeChainBuffers(ioc, req_idx);
-
-	/*
-	 * Wake up the original calling thread
-	 */
-	hd->scandv_wait_done = 1;
-	wake_up(&hd->scandv_waitq);
-
+ out:
+	if (!(ioc->internal_cmds.status & MPT_MGMT_STATUS_PENDING))
+		return 0;
+	ioc->internal_cmds.status &= ~MPT_MGMT_STATUS_PENDING;
+	complete(&ioc->internal_cmds.done);
 	return 1;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/*	mptscsih_timer_expired - Call back for timer process.
- *	Used only for dv functionality.
- *	@data: Pointer to MPT_SCSI_HOST recast as an unsigned long
- *
- */
-void
-mptscsih_timer_expired(unsigned long data)
-{
-	MPT_SCSI_HOST *hd = (MPT_SCSI_HOST *) data;
-	MPT_ADAPTER 	*ioc = hd->ioc;
-
-	ddvprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Timer Expired! Cmd %p\n", ioc->name, hd->cmdPtr));
-
-	if (hd->cmdPtr) {
-		MPIHeader_t *cmd = (MPIHeader_t *)hd->cmdPtr;
-
-		if (cmd->Function == MPI_FUNCTION_SCSI_IO_REQUEST) {
-			/* Desire to issue a task management request here.
-			 * TM requests MUST be single threaded.
-			 * If old eh code and no TM current, issue request.
-			 * If new eh code, do nothing. Wait for OS cmd timeout
-			 *	for bus reset.
-			 */
-		} else {
-			/* Perform a FW reload */
-			if (mpt_HardResetHandler(ioc, NO_SLEEP) < 0) {
-				printk(MYIOC_s_WARN_FMT "Firmware Reload FAILED!\n", ioc->name);
-			}
-		}
-	} else {
-		/* This should NEVER happen */
-		printk(MYIOC_s_WARN_FMT "Null cmdPtr!!!!\n", ioc->name);
-	}
-
-	/* No more processing.
-	 * TM call will generate an interrupt for SCSI TM Management.
-	 * The FW will reply to all outstanding commands, callback will finish cleanup.
-	 * Hard reset clean-up will free all resources.
-	 */
-	ddvprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Timer Expired Complete!\n", ioc->name));
-
-	return;
-}
-
-
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mptscsih_do_cmd - Do internal command.
  *	@hd: MPT_SCSI_HOST pointer
@@ -3027,27 +2872,32 @@ mptscsih_timer_expired(unsigned long dat
  *
  *		 > 0 if command complete but some type of completion error.
  */
-static int
+int
 mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *io)
 {
 	MPT_FRAME_HDR	*mf;
 	SCSIIORequest_t	*pScsiReq;
-	SCSIIORequest_t	 ReqCopy;
 	int		 my_idx, ii, dir;
-	int		 rc, cmdTimeout;
-	int		in_isr;
+	int		 timeout;
 	char		 cmdLen;
 	char		 CDB[]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
-	char		 cmd = io->cmd;
-	MPT_ADAPTER 	*ioc = hd->ioc;
+	u8		 cmd = io->cmd;
+	MPT_ADAPTER *ioc = hd->ioc;
+	int		 ret = 0;
+	unsigned long	 timeleft;
+	unsigned long	 flags;
 
-	in_isr = in_interrupt();
-	if (in_isr) {
-		dprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Internal SCSI IO request not allowed in ISR context!\n",
-					ioc->name));
-		return -EPERM;
+	/* don't send internal command during diag reset */
+	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
+	if (ioc->ioc_reset_in_progress) {
+		spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
+		dfailprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "%s: busy with host reset\n", ioc->name, __FUNCTION__));
+		return MPT_SCANDV_BUSY;
 	}
+	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
 
+	mutex_lock(&ioc->internal_cmds.mutex);
 
 	/* Set command specific information
 	 */
@@ -3057,13 +2907,13 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTER
 		dir = MPI_SCSIIO_CONTROL_READ;
 		CDB[0] = cmd;
 		CDB[4] = io->size;
-		cmdTimeout = 10;
+		timeout = 10;
 		break;
 
 	case TEST_UNIT_READY:
 		cmdLen = 6;
 		dir = MPI_SCSIIO_CONTROL_READ;
-		cmdTimeout = 10;
+		timeout = 10;
 		break;
 
 	case START_STOP:
@@ -3071,7 +2921,7 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTER
 		dir = MPI_SCSIIO_CONTROL_READ;
 		CDB[0] = cmd;
 		CDB[4] = 1;	/*Spin up the disk */
-		cmdTimeout = 15;
+		timeout = 15;
 		break;
 
 	case REQUEST_SENSE:
@@ -3079,7 +2929,7 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTER
 		CDB[0] = cmd;
 		CDB[4] = io->size;
 		dir = MPI_SCSIIO_CONTROL_READ;
-		cmdTimeout = 10;
+		timeout = 10;
 		break;
 
 	case READ_BUFFER:
@@ -3098,7 +2948,7 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTER
 		CDB[6] = (io->size >> 16) & 0xFF;
 		CDB[7] = (io->size >>  8) & 0xFF;
 		CDB[8] = io->size & 0xFF;
-		cmdTimeout = 10;
+		timeout = 10;
 		break;
 
 	case WRITE_BUFFER:
@@ -3113,21 +2963,21 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTER
 		CDB[6] = (io->size >> 16) & 0xFF;
 		CDB[7] = (io->size >>  8) & 0xFF;
 		CDB[8] = io->size & 0xFF;
-		cmdTimeout = 10;
+		timeout = 10;
 		break;
 
 	case RESERVE:
 		cmdLen = 6;
 		dir = MPI_SCSIIO_CONTROL_READ;
 		CDB[0] = cmd;
-		cmdTimeout = 10;
+		timeout = 10;
 		break;
 
 	case RELEASE:
 		cmdLen = 6;
 		dir = MPI_SCSIIO_CONTROL_READ;
 		CDB[0] = cmd;
-		cmdTimeout = 10;
+		timeout = 10;
 		break;
 
 	case SYNCHRONIZE_CACHE:
@@ -3135,20 +2985,23 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTER
 		dir = MPI_SCSIIO_CONTROL_READ;
 		CDB[0] = cmd;
 //		CDB[1] = 0x02;	/* set immediate bit */
-		cmdTimeout = 10;
+		timeout = 10;
 		break;
 
 	default:
 		/* Error Case */
-		return -EFAULT;
+		ret = -EFAULT;
+		goto out;
 	}
 
 	/* Get and Populate a free Frame
+	 * MsgContext set in mpt_get_msg_frame call
 	 */
 	if ((mf = mpt_get_msg_frame(ioc->InternalCtx, ioc)) == NULL) {
-		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT "No msg frames!\n",
-		    ioc->name));
-		return -EBUSY;
+		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT "%s: No msg frames!\n",
+		    ioc->name, __FUNCTION__));
+		ret = -EBUSY;
+		goto out;
 	}
 
 	pScsiReq = (SCSIIORequest_t *) mf;
@@ -3171,14 +3024,10 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTER
 
 	pScsiReq->CDBLength = cmdLen;
 	pScsiReq->SenseBufferLength = MPT_SENSE_BUFFER_SIZE;
-
 	pScsiReq->Reserved = 0;
-
 	pScsiReq->MsgFlags = mpt_msg_flags();
-	/* MsgContext set in mpt_get_msg_fram call  */
 
 	int_to_scsilun(io->lun, (struct scsi_lun *)pScsiReq->LUN);
-
 	if (io->flags & MPT_ICFLAG_TAGGED_CMD)
 		pScsiReq->Control = cpu_to_le32(dir | MPI_SCSIIO_CONTROL_SIMPLEQ);
 	else
@@ -3186,8 +3035,8 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTER
 
 	if (cmd == REQUEST_SENSE) {
 		pScsiReq->Control = cpu_to_le32(dir | MPI_SCSIIO_CONTROL_UNTAGGED);
-		ddvprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Untagged! 0x%2x\n",
-			ioc->name, cmd));
+		devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "%s: Untagged! 0x%02x\n", ioc->name, __FUNCTION__, cmd));
 	}
 
 	for (ii=0; ii < 16; ii++)
@@ -3197,63 +3046,50 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTER
 	pScsiReq->SenseBufferLowAddr = cpu_to_le32(ioc->sense_buf_low_dma
 					   + (my_idx * MPT_SENSE_BUFFER_ALLOC));
 
-	ddvprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Sending Command 0x%x for (%d:%d:%d)\n",
-			ioc->name, cmd, io->channel, io->id, io->lun));
-
-	if (dir == MPI_SCSIIO_CONTROL_READ) {
-		mpt_add_sge((char *) &pScsiReq->SGL,
-			MPT_SGE_FLAGS_SSIMPLE_READ | io->size,
-			io->data_dma);
-	} else {
-		mpt_add_sge((char *) &pScsiReq->SGL,
-			MPT_SGE_FLAGS_SSIMPLE_WRITE | io->size,
-			io->data_dma);
-	}
-
-	/* The ISR will free the request frame, but we need
-	 * the information to initialize the target. Duplicate.
-	 */
-	memcpy(&ReqCopy, pScsiReq, sizeof(SCSIIORequest_t));
-
-	/* Issue this command after:
-	 *	finish init
-	 *	add timer
-	 * Wait until the reply has been received
-	 *  ScsiScanDvCtx callback function will
-	 *	set hd->pLocal;
-	 *	set scandv_wait_done and call wake_up
-	 */
-	hd->pLocal = NULL;
-	hd->timer.expires = jiffies + HZ*cmdTimeout;
-	hd->scandv_wait_done = 0;
-
-	/* Save cmd pointer, for resource free if timeout or
-	 * FW reload occurs
-	 */
-	hd->cmdPtr = mf;
+	devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+	    "%s: Sending Command 0x%02x for fw_channel=%d fw_id=%d lun=%d\n",
+	    ioc->name, __FUNCTION__, cmd, io->channel, io->id, io->lun));
+
+	if (dir == MPI_SCSIIO_CONTROL_READ)
+		mptscsih_add_sge((char *) &pScsiReq->SGL,
+		    MPT_SGE_FLAGS_SSIMPLE_READ | io->size, io->data_dma);
+	else
+		mptscsih_add_sge((char *) &pScsiReq->SGL,
+		    MPT_SGE_FLAGS_SSIMPLE_WRITE | io->size, io->data_dma);
 
-	add_timer(&hd->timer);
+	INITIALIZE_MGMT_STATUS(ioc->internal_cmds.status)
 	mpt_put_msg_frame(ioc->InternalCtx, ioc, mf);
-	wait_event(hd->scandv_waitq, hd->scandv_wait_done);
-
-	if (hd->pLocal) {
-		rc = hd->pLocal->completion;
-		hd->pLocal->skip = 0;
-
-		/* Always set fatal error codes in some cases.
-		 */
-		if (rc == MPT_SCANDV_SELECTION_TIMEOUT)
-			rc = -ENXIO;
-		else if (rc == MPT_SCANDV_SOME_ERROR)
-			rc =  -rc;
-	} else {
-		rc = -EFAULT;
-		/* This should never happen. */
-		ddvprintk(ioc, printk(MYIOC_s_DEBUG_FMT "_do_cmd: Null pLocal!!!\n",
-				ioc->name));
+	timeleft = wait_for_completion_timeout(&ioc->internal_cmds.done,
+	    timeout*HZ);
+	if (!(ioc->internal_cmds.status & MPT_MGMT_STATUS_COMMAND_GOOD)) {
+		ret = -ETIME;
+		dfailprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "%s: TIMED OUT for cmd=0x%02x\n", ioc->name, __FUNCTION__,
+		    cmd));
+		if (ioc->internal_cmds.status & MPT_MGMT_STATUS_DID_IOCRESET) {
+			mpt_free_msg_frame(ioc, mf);
+			goto out;
+		}
+		if (!timeleft) {
+			if (!mptscsih_scandv_bus_reset(ioc))
+				goto out;
+			mpt_free_msg_frame(ioc, mf);
+			printk(MYIOC_s_WARN_FMT "Issuing Reset from %s!!\n",
+			    ioc->name, __FUNCTION__);
+			if (mpt_SoftResetHandler(ioc, CAN_SLEEP) != 0)
+				mpt_HardResetHandler(ioc, CAN_SLEEP);
+		}
+		goto out;
 	}
 
-	return rc;
+	ret = ioc->internal_cmds.completion_code;
+	devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT "%s: success, rc=0x%02x\n",
+			ioc->name, __FUNCTION__, ret));
+
+ out:
+	CLEAR_MGMT_STATUS(ioc->internal_cmds.status)
+	mutex_unlock(&ioc->internal_cmds.mutex);
+	return ret;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -3284,13 +3120,11 @@ mptscsih_synchronize_cache(MPT_SCSI_HOST
 	/* Following parameters will not change
 	 * in this routine.
 	 */
+	memset(&iocmd, 0, sizeof(INTERNAL_CMD));
 	iocmd.cmd = SYNCHRONIZE_CACHE;
-	iocmd.flags = 0;
 	iocmd.physDiskNum = -1;
 	iocmd.data = NULL;
 	iocmd.data_dma = -1;
-	iocmd.size = 0;
-	iocmd.rsvd = iocmd.rsvd2 = 0;
 	iocmd.channel = vdevice->vtarget->channel;
 	iocmd.id = vdevice->vtarget->id;
 	iocmd.lun = vdevice->lun;
@@ -3503,7 +3337,8 @@ EXPORT_SYMBOL(mptscsih_scandv_complete);
 EXPORT_SYMBOL(mptscsih_event_process);
 EXPORT_SYMBOL(mptscsih_ioc_reset);
 EXPORT_SYMBOL(mptscsih_change_queue_depth);
-EXPORT_SYMBOL(mptscsih_timer_expired);
-EXPORT_SYMBOL(mptscsih_TMHandler);
+EXPORT_SYMBOL(mptscsih_IssueTaskMgmt);
+EXPORT_SYMBOL(mptscsih_do_cmd);
+EXPORT_SYMBOL(mptscsih_quiesce_raid);
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
--- b/drivers/message/fusion/mptscsih.h	2007-09-05 15:23:33.000000000 -0600
+++ a/drivers/message/fusion/mptscsih.h	2007-09-17 15:05:33.000000000 -0600
@@ -60,6 +60,7 @@
 #define MPT_SCANDV_SELECTION_TIMEOUT	(0x00000008)
 #define MPT_SCANDV_ISSUE_SENSE		(0x00000010)
 #define MPT_SCANDV_FALLBACK		(0x00000020)
+#define MPT_SCANDV_BUSY			(0x00000040)
 
 #define MPT_SCANDV_MAX_RETRIES		(10)
 
@@ -125,8 +126,9 @@ extern int mptscsih_scandv_complete(MPT_
 extern int mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply);
 extern int mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);
 extern int mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth);
-extern void mptscsih_timer_expired(unsigned long data);
-extern int mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int lun, int ctx2abort, ulong timeout);
+extern int mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int lun, int ctx2abort, ulong timeout);
 extern u8 mptscsih_raid_id_to_num(MPT_ADAPTER *ioc, u8 channel, u8 id);
 extern int mptscsih_is_phys_disk(MPT_ADAPTER *ioc, u8 channel, u8 id);
+extern int mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *iocmd);
 extern struct class_device_attribute *mptscsih_host_attrs[];
+extern int mptscsih_quiesce_raid(MPT_SCSI_HOST *hd, int quiesce, u8 channel, u8 id);
