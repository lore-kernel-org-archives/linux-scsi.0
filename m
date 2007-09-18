From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 5/9] mpt fusion: error recovery improvements, and synchronizing internal commands
Date: Mon, 17 Sep 2007 19:59:02 -0600
Message-ID: <20070918015901.GA22735@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:61991 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755335AbXIRCHq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Sep 2007 22:07:46 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

1) rewrite of ioctl_cmds internal generated function that issue commands to firmware, porting them to be single threaded using the generic MPT_MGMT struct.
2) added seperate callback handler for ioctl task managment (mptctl_taskmgmt_reply), to handle command that timeout
3) rewrite mptctl_bus_reset
4) cleanup ioc_reset callback handlers, introducing wrappers for synronizing error recovery (mpt_set_taskmgmt_in_progress_flag, mpt_clear_taskmgmt_in_progress_flag), as the fusion firmware only handles one task management request at a time.


Signed-off-by: Eric Moore <Eric.Moore@lsi.com>

--- b/drivers/message/fusion/mptctl.c	2007-09-17 11:58:15.000000000 -0600
+++ a/drivers/message/fusion/mptctl.c	2007-09-17 15:05:32.000000000 -0600
@@ -84,6 +84,7 @@ MODULE_VERSION(my_VERSION);
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 
 static u8 mptctl_id = MPT_MAX_PROTOCOL_DRIVERS;
+static u8 mptctl_taskmgmt_id = MPT_MAX_PROTOCOL_DRIVERS;
 
 static DECLARE_WAIT_QUEUE_HEAD ( mptctl_wait );
 
@@ -127,10 +128,6 @@ static MptSge_t *kbuf_alloc_2_sgl(int by
 		struct buflist **blp, dma_addr_t *sglbuf_dma, MPT_ADAPTER *ioc);
 static void kfree_sgl(MptSge_t *sgl, dma_addr_t sgl_dma,
 		struct buflist *buflist, MPT_ADAPTER *ioc);
-static void mptctl_timeout_expired (MPT_IOCTL *ioctl);
-static int  mptctl_bus_reset(MPT_IOCTL *ioctl);
-static int mptctl_set_tm_flags(MPT_SCSI_HOST *hd);
-static void mptctl_free_tm_flags(MPT_ADAPTER *ioc);
 
 /*
  * Reset Handler cleanup function
@@ -183,10 +180,10 @@ mptctl_syscall_down(MPT_ADAPTER *ioc, in
 	int rc = 0;
 
 	if (nonblock) {
-		if (!mutex_trylock(&ioc->ioctl->ioctl_mutex))
+		if (!mutex_trylock(&ioc->ioctl_cmds.mutex))
 			rc = -EAGAIN;
 	} else {
-		if (mutex_lock_interruptible(&ioc->ioctl->ioctl_mutex))
+		if (mutex_lock_interruptible(&ioc->ioctl_cmds.mutex))
 			rc = -ERESTARTSYS;
 	}
 	return rc;
@@ -202,131 +199,91 @@ mptctl_syscall_down(MPT_ADAPTER *ioc, in
 static int
 mptctl_reply(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req, MPT_FRAME_HDR *reply)
 {
-	char *sense_data;
-	int sz, req_index;
-	u16 iocStatus;
-	u8 cmd;
+	char	*sense_data;
+	int	req_index;
+	int	sz;
+
+	if (!req)
+		return 0;
 
-	if (req)
-		 cmd = req->u.hdr.Function;
-	else
-		return 1;
 	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "\tcompleting mpi function (0x%02X), req=%p, "
 	    "reply=%p\n", ioc->name,  req->u.hdr.Function, req, reply));
+	ioc->ioctl_cmds.status |= MPT_MGMT_STATUS_COMMAND_GOOD;
 
-	if (ioc->ioctl) {
-
-		if (reply==NULL) {
-
-			dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mptctl_reply() NULL Reply "
-				"Function=%x!\n", ioc->name, cmd));
-
-			ioc->ioctl->status |= MPT_IOCTL_STATUS_COMMAND_GOOD;
-			ioc->ioctl->reset &= ~MPTCTL_RESET_OK;
-
-			/* We are done, issue wake up
-	 		*/
-			ioc->ioctl->wait_done = 1;
-			wake_up (&mptctl_wait);
-			return 1;
-
-		}
-
-		/* Copy the reply frame (which much exist
-		 * for non-SCSI I/O) to the IOC structure.
-		 */
-		memcpy(ioc->ioctl->ReplyFrame, reply,
-			min(ioc->reply_sz, 4*reply->u.reply.MsgLength));
-		ioc->ioctl->status |= MPT_IOCTL_STATUS_RF_VALID;
+	if (!reply)
+		goto out;
 
-		/* Set the command status to GOOD if IOC Status is GOOD
-		 * OR if SCSI I/O cmd and data underrun or recovered error.
-		 */
-		iocStatus = le16_to_cpu(reply->u.reply.IOCStatus) & MPI_IOCSTATUS_MASK;
-		if (iocStatus  == MPI_IOCSTATUS_SUCCESS)
-			ioc->ioctl->status |= MPT_IOCTL_STATUS_COMMAND_GOOD;
-
-		if (iocStatus || reply->u.reply.IOCLogInfo)
-			dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "\tiocstatus (0x%04X), "
-				"loginfo (0x%08X)\n", ioc->name,
-				iocStatus,
-				le32_to_cpu(reply->u.reply.IOCLogInfo)));
-
-		if ((cmd == MPI_FUNCTION_SCSI_IO_REQUEST) ||
-			(cmd == MPI_FUNCTION_RAID_SCSI_IO_PASSTHROUGH)) {
-
-			if (reply->u.sreply.SCSIStatus || reply->u.sreply.SCSIState)
-				dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-					"\tscsi_status (0x%02x), scsi_state (0x%02x), "
-					"tag = (0x%04x), transfer_count (0x%08x)\n", ioc->name,
-					reply->u.sreply.SCSIStatus,
-					reply->u.sreply.SCSIState,
-					le16_to_cpu(reply->u.sreply.TaskTag),
-					le32_to_cpu(reply->u.sreply.TransferCount)));
-
-			ioc->ioctl->reset &= ~MPTCTL_RESET_OK;
-
-			if ((iocStatus == MPI_IOCSTATUS_SCSI_DATA_UNDERRUN) ||
-			(iocStatus == MPI_IOCSTATUS_SCSI_RECOVERED_ERROR)) {
-			ioc->ioctl->status |= MPT_IOCTL_STATUS_COMMAND_GOOD;
-			}
-		}
+	ioc->ioctl_cmds.status |= MPT_MGMT_STATUS_RF_VALID;
+	sz = min(ioc->reply_sz, 4*reply->u.reply.MsgLength);
+	memcpy(ioc->ioctl_cmds.reply, reply, sz);
+
+	if (reply->u.reply.IOCStatus || reply->u.reply.IOCLogInfo)
+		dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "\tiocstatus (0x%04X), "
+		    "loginfo (0x%08X)\n", ioc->name,
+		    le16_to_cpu(reply->u.reply.IOCStatus),
+		    le32_to_cpu(reply->u.reply.IOCLogInfo)));
+
+	if ((req->u.hdr.Function == MPI_FUNCTION_SCSI_IO_REQUEST) ||
+		(req->u.hdr.Function == MPI_FUNCTION_RAID_SCSI_IO_PASSTHROUGH)) {
+
+		if (reply->u.sreply.SCSIStatus || reply->u.sreply.SCSIState)
+			dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+			"\tscsi_status (0x%02x), scsi_state (0x%02x), "
+			"tag = (0x%04x), transfer_count (0x%08x)\n", ioc->name,
+			reply->u.sreply.SCSIStatus,
+			reply->u.sreply.SCSIState,
+			le16_to_cpu(reply->u.sreply.TaskTag),
+			le32_to_cpu(reply->u.sreply.TransferCount)));
 
-		/* Copy the sense data - if present
-		 */
-		if ((cmd == MPI_FUNCTION_SCSI_IO_REQUEST) &&
-			(reply->u.sreply.SCSIState &
-			 MPI_SCSI_STATE_AUTOSENSE_VALID)){
+		if (reply->u.sreply.SCSIState & MPI_SCSI_STATE_AUTOSENSE_VALID) {
 			sz = req->u.scsireq.SenseBufferLength;
 			req_index =
 			    le16_to_cpu(req->u.frame.hwhdr.msgctxu.fld.req_idx);
-			sense_data =
-			    ((u8 *)ioc->sense_buf_pool +
+			sense_data = ((u8 *)ioc->sense_buf_pool +
 			     (req_index * MPT_SENSE_BUFFER_ALLOC));
-			memcpy(ioc->ioctl->sense, sense_data, sz);
-			ioc->ioctl->status |= MPT_IOCTL_STATUS_SENSE_VALID;
+			memcpy(ioc->ioctl_cmds.sense, sense_data, sz);
+			ioc->ioctl_cmds.status |= MPT_MGMT_STATUS_SENSE_VALID;
 		}
+	}
 
-		if (cmd == MPI_FUNCTION_SCSI_TASK_MGMT)
-			mptctl_free_tm_flags(ioc);
-
-		/* We are done, issue wake up
-		 */
-		ioc->ioctl->wait_done = 1;
-		wake_up (&mptctl_wait);
+ out:
+	/* We are done, issue wake up
+	 */
+	if (ioc->ioctl_cmds.status & MPT_MGMT_STATUS_PENDING) {
+		if (reply && (req->u.hdr.Function == MPI_FUNCTION_SCSI_TASK_MGMT))
+			mpt_clear_taskmgmt_in_progress_flag(ioc);
+		ioc->ioctl_cmds.status &= ~MPT_MGMT_STATUS_PENDING;
+		complete(&ioc->ioctl_cmds.done);
+		return 1;
 	}
-	return 1;
+	return 0;
 }
 
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/* mptctl_timeout_expired
- *
- * Expecting an interrupt, however timed out.
- *
- */
-static void mptctl_timeout_expired (MPT_IOCTL *ioctl)
+static int
+mptctl_taskmgmt_reply(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 {
-	int rc = 1;
+	if (!mf)
+		return 0;
 
-	dctlprintk(ioctl->ioc, printk(MYIOC_s_DEBUG_FMT ": Timeout Expired! Host %d\n",
-				ioctl->ioc->name, ioctl->ioc->id));
-	if (ioctl == NULL)
-		return;
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "TaskMgmt completed (mf=%p, mr=%p)\n",
+	    ioc->name, mf, mr));
 
-	ioctl->wait_done = 0;
-	if (ioctl->reset & MPTCTL_RESET_OK)
-		rc = mptctl_bus_reset(ioctl);
-
-	if (rc) {
-		/* Issue a reset for this device.
-		 * The IOC is not responding.
-		 */
-		dctlprintk(ioctl->ioc, printk(MYIOC_s_DEBUG_FMT "Calling HardReset! \n",
-			 ioctl->ioc->name));
-		mpt_HardResetHandler(ioctl->ioc, CAN_SLEEP);
-	}
-	return;
+	ioc->taskmgmt_cmds.status |= MPT_MGMT_STATUS_COMMAND_GOOD;
 
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
 }
 
 /* mptctl_bus_reset
@@ -334,132 +291,178 @@ static void mptctl_timeout_expired (MPT_
  * Bus reset code.
  *
  */
-static int mptctl_bus_reset(MPT_IOCTL *ioctl)
+static int
+mptctl_bus_reset(MPT_ADAPTER *ioc, u8 function)
 {
 	MPT_FRAME_HDR	*mf;
 	SCSITaskMgmt_t	*pScsiTm;
-	MPT_SCSI_HOST	*hd;
+	SCSITaskMgmtReply_t *pScsiTmReply;
 	int		 ii;
-	int		 retval=0;
-
-
-	ioctl->reset &= ~MPTCTL_RESET_OK;
-
-	if (ioctl->ioc->sh == NULL)
+	int		 retval;
+	unsigned long	 timeout;
+	unsigned long	 time_count;
+	u16		 iocstatus;
+
+	/* bus reset is only good for SCSI IO, RAID PASSTHRU */
+	if (!(function == MPI_FUNCTION_RAID_SCSI_IO_PASSTHROUGH) ||
+	    (function == MPI_FUNCTION_SCSI_IO_REQUEST)) {
+		dtmprintk(ioc, printk(MYIOC_s_WARN_FMT "TaskMgmt, not SCSI_IO!!\n",
+				ioc->name));
 		return -EPERM;
+	}
 
-	hd = shost_priv(ioctl->ioc->sh);
-	if (hd == NULL)
+	mutex_lock(&ioc->taskmgmt_cmds.mutex);
+	if (mpt_set_taskmgmt_in_progress_flag(ioc) != 0) {
+		mutex_unlock(&ioc->taskmgmt_cmds.mutex);
 		return -EPERM;
+	}
 
-	/* Single threading ....
-	 */
-	if (mptctl_set_tm_flags(hd) != 0)
-		return -EPERM;
+	retval = 0;
 
 	/* Send request
 	 */
-	if ((mf = mpt_get_msg_frame(mptctl_id, ioctl->ioc)) == NULL) {
-		dtmprintk(ioctl->ioc, printk(MYIOC_s_DEBUG_FMT "IssueTaskMgmt, no msg frames!!\n",
-				ioctl->ioc->name));
-
-		mptctl_free_tm_flags(ioctl->ioc);
-		return -ENOMEM;
+	if ((mf = mpt_get_msg_frame(mptctl_taskmgmt_id, ioc)) == NULL) {
+		dtmprintk(ioc, printk(MYIOC_s_WARN_FMT "TaskMgmt, no msg frames!!\n",
+				ioc->name));
+		mpt_clear_taskmgmt_in_progress_flag(ioc);
+		retval = -ENOMEM;
+		goto mptctl_bus_reset_done;
 	}
 
-	dtmprintk(ioctl->ioc, printk(MYIOC_s_DEBUG_FMT "IssueTaskMgmt request @ %p\n",
-			ioctl->ioc->name, mf));
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "TaskMgmt request (mf=%p)\n",
+		ioc->name, mf));
 
 	pScsiTm = (SCSITaskMgmt_t *) mf;
-	pScsiTm->TargetID = ioctl->id;
-	pScsiTm->Bus = hd->port;	/* 0 */
-	pScsiTm->ChainOffset = 0;
+	memset(pScsiTm, 0, sizeof(SCSITaskMgmt_t));
 	pScsiTm->Function = MPI_FUNCTION_SCSI_TASK_MGMT;
-	pScsiTm->Reserved = 0;
 	pScsiTm->TaskType = MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS;
-	pScsiTm->Reserved1 = 0;
 	pScsiTm->MsgFlags = MPI_SCSITASKMGMT_MSGFLAGS_LIPRESET_RESET_OPTION;
-
+	pScsiTm->TargetID = 0;
+	pScsiTm->Bus = 0;
+	pScsiTm->ChainOffset = 0;
+	pScsiTm->Reserved = 0;
+	pScsiTm->Reserved1 = 0;
+	pScsiTm->TaskMsgContext = 0;
 	for (ii= 0; ii < 8; ii++)
 		pScsiTm->LUN[ii] = 0;
-
 	for (ii=0; ii < 7; ii++)
 		pScsiTm->Reserved2[ii] = 0;
 
-	pScsiTm->TaskMsgContext = 0;
-	dtmprintk(ioctl->ioc, printk(MYIOC_s_DEBUG_FMT
-		"mptctl_bus_reset: issued.\n", ioctl->ioc->name));
-
-	DBG_DUMP_TM_REQUEST_FRAME(ioctl->ioc, (u32 *)mf);
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
+	}
 
-	ioctl->wait_done=0;
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "TaskMgmt type=%d timeout=%ld\n",
+	    ioc->name, MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS, timeout));
 
-	if ((ioctl->ioc->facts.IOCCapabilities & MPI_IOCFACTS_CAPABILITY_HIGH_PRI_Q) &&
-	    (ioctl->ioc->facts.MsgVersion >= MPI_VERSION_01_05))
-		mpt_put_msg_frame_hi_pri(mptctl_id, ioctl->ioc, mf);
+	INITIALIZE_MGMT_STATUS(ioc->taskmgmt_cmds.status)
+	CLEAR_MGMT_STATUS(ioc->ioctl_cmds.status)
+	time_count = jiffies;
+	if ((ioc->facts.IOCCapabilities & MPI_IOCFACTS_CAPABILITY_HIGH_PRI_Q) &&
+	    (ioc->facts.MsgVersion >= MPI_VERSION_01_05))
+		mpt_put_msg_frame_hi_pri(mptctl_taskmgmt_id, ioc, mf);
 	else {
-		retval = mpt_send_handshake_request(mptctl_id, ioctl->ioc,
-			sizeof(SCSITaskMgmt_t), (u32*)pScsiTm, CAN_SLEEP);
+		retval = mpt_send_handshake_request(mptctl_taskmgmt_id, ioc,
+		    sizeof(SCSITaskMgmt_t), (u32*)pScsiTm, CAN_SLEEP);
 		if (retval != 0) {
-			dfailprintk(ioctl->ioc, printk(MYIOC_s_ERR_FMT "_send_handshake FAILED!"
-				" (hd %p, ioc %p, mf %p) \n", hd->ioc->name, hd,
-				hd->ioc, mf));
+			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT "TaskMgmt send_handshake FAILED!"
+				" (ioc %p, mf %p, rc=%d) \n", ioc->name,
+				ioc, mf, retval));
+			mpt_clear_taskmgmt_in_progress_flag(ioc);
 			goto mptctl_bus_reset_done;
 		}
 	}
 
 	/* Now wait for the command to complete */
-	ii = wait_event_timeout(mptctl_wait,
-	     ioctl->wait_done == 1,
-	     HZ*5 /* 5 second timeout */);
-
-	if(ii <=0 && (ioctl->wait_done != 1 ))  {
-		mpt_free_msg_frame(hd->ioc, mf);
-		ioctl->wait_done = 0;
-		retval = -1; /* return failure */
+	ii = wait_for_completion_timeout(&ioc->taskmgmt_cmds.done, timeout*HZ);
+	if (!(ioc->taskmgmt_cmds.status & MPT_MGMT_STATUS_COMMAND_GOOD)) {
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "TaskMgmt failed\n", ioc->name));
+		mpt_free_msg_frame(ioc, mf);
+		mpt_clear_taskmgmt_in_progress_flag(ioc);
+		if (ioc->taskmgmt_cmds.status & MPT_MGMT_STATUS_DID_IOCRESET)
+			retval = 0;
+		else
+			retval = -1; /* return failure */
+		goto mptctl_bus_reset_done;
 	}
 
-mptctl_bus_reset_done:
-
-	mptctl_free_tm_flags(ioctl->ioc);
-	return retval;
-}
-
-static int
-mptctl_set_tm_flags(MPT_SCSI_HOST *hd) {
-	unsigned long flags;
-
-	spin_lock_irqsave(&hd->ioc->FreeQlock, flags);
+	if (!(ioc->taskmgmt_cmds.status & MPT_MGMT_STATUS_RF_VALID)) {
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "TaskMgmt failed\n", ioc->name));
+		retval = -1; /* return failure */
+		goto mptctl_bus_reset_done;
+	}
 
-	if (hd->tmState == TM_STATE_NONE) {
-		hd->tmState = TM_STATE_IN_PROGRESS;
-		hd->tmPending = 1;
-		spin_unlock_irqrestore(&hd->ioc->FreeQlock, flags);
-	} else {
-		spin_unlock_irqrestore(&hd->ioc->FreeQlock, flags);
-		return -EBUSY;
+	pScsiTmReply = (SCSITaskMgmtReply_t *) ioc->taskmgmt_cmds.reply;
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+	    "TaskMgmt fw_channel = %d, fw_id = %d, task_type=0x%02X, "
+	    "iocstatus=0x%04X\n\tloginfo=0x%08X, response_code=0x%02X, "
+	    "term_cmnds=%d\n", ioc->name, pScsiTmReply->Bus,
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
 
-	return 0;
+
+ mptctl_bus_reset_done:
+	mutex_unlock(&ioc->taskmgmt_cmds.mutex);
+	CLEAR_MGMT_STATUS(ioc->taskmgmt_cmds.status)
+	return retval;
 }
 
 static void
-mptctl_free_tm_flags(MPT_ADAPTER *ioc)
+mptctl_timeout_expired(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf)
 {
-	MPT_SCSI_HOST * hd;
 	unsigned long flags;
 
-	hd = shost_priv(ioc->sh);
-	if (hd == NULL)
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT ": %s\n",
+		ioc->name, __FUNCTION__));
+
+	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
+	if (ioc->ioc_reset_in_progress) {
+		spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
+		CLEAR_MGMT_PENDING_STATUS(ioc->ioctl_cmds.status)
+		mpt_free_msg_frame(ioc, mf);
 		return;
+	}
+	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
 
-	spin_lock_irqsave(&ioc->FreeQlock, flags);
 
-	hd->tmState = TM_STATE_NONE;
-	hd->tmPending = 0;
-	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
+	if (!mptctl_bus_reset(ioc, mf->u.hdr.Function))
+		return;
 
-	return;
+	/* Issue a reset for this device.
+	 * The IOC is not responding.
+	 */
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Calling HardReset! \n",
+		 ioc->name));
+	CLEAR_MGMT_PENDING_STATUS(ioc->ioctl_cmds.status)
+	mpt_free_msg_frame(ioc, mf);
+	if (mpt_SoftResetHandler(ioc, CAN_SLEEP) != 0)
+		mpt_HardResetHandler(ioc, CAN_SLEEP);
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -472,22 +475,23 @@ mptctl_free_tm_flags(MPT_ADAPTER *ioc)
 static int
 mptctl_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
 {
-	MPT_IOCTL *ioctl = ioc->ioctl;
-	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "IOC %s_reset routed to IOCTL driver!\n", ioc->name,
-		reset_phase==MPT_IOC_SETUP_RESET ? "setup" : (
-		reset_phase==MPT_IOC_PRE_RESET ? "pre" : "post")));
-
-	if(ioctl == NULL)
-		return 1;
-
 	switch(reset_phase) {
 	case MPT_IOC_SETUP_RESET:
-		ioctl->status |= MPT_IOCTL_STATUS_DID_IOCRESET;
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "%s: MPT_IOC_SETUP_RESET\n", ioc->name, __FUNCTION__));
+		break;
+	case MPT_IOC_PRE_RESET:
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "%s: MPT_IOC_PRE_RESET\n", ioc->name, __FUNCTION__));
 		break;
 	case MPT_IOC_POST_RESET:
-		ioctl->status &= ~MPT_IOCTL_STATUS_DID_IOCRESET;
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "%s: MPT_IOC_POST_RESET\n", ioc->name, __FUNCTION__));
+		if (ioc->ioctl_cmds.status & MPT_MGMT_STATUS_PENDING) {
+			ioc->ioctl_cmds.status |= MPT_MGMT_STATUS_DID_IOCRESET;
+			complete(&ioc->ioctl_cmds.done);
+		}
 		break;
-	case MPT_IOC_PRE_RESET:
 	default:
 		break;
 	}
@@ -597,12 +601,6 @@ __mptctl_ioctl(struct file *file, unsign
 		return -ENODEV;
 	}
 
-	if (!iocp->active) {
-		printk(KERN_DEBUG MYNAM "%s::mptctl_ioctl() @%d - Controller disabled.\n",
-				__FILE__, __LINE__);
-		return -EFAULT;
-	}
-
 	/* Handle those commands that are just returning
 	 * information stored in the driver.
 	 * These commands should never time out and are unaffected
@@ -643,7 +641,7 @@ __mptctl_ioctl(struct file *file, unsign
 	else
 		ret = -EINVAL;
 
-	mutex_unlock(&iocp->ioctl->ioctl_mutex);
+	mutex_unlock(&iocp->ioctl_cmds.mutex);
 
 	return ret;
 }
@@ -759,10 +757,10 @@ mptctl_do_fw_download(int ioc, char __us
 	int			 sge_offset = 0;
 	u16			 iocstat;
 	pFWDownloadReply_t	 ReplyMsg = NULL;
+	unsigned long		 timeleft;
 
 	if (mpt_verify_adapter(ioc, &iocp) < 0) {
-		printk(KERN_DEBUG MYNAM "ioctl_fwdl - ioc%d not found!\n",
-				 ioc);
+		printk(KERN_DEBUG MYNAM "ioctl_fwdl - ioc%d not found!\n", ioc);
 		return -ENODEV; /* (-6) No such device or address */
 	} else {
 
@@ -875,8 +873,8 @@ mptctl_do_fw_download(int ioc, char __us
 			n++;
 			if (copy_from_user(bl->kptr, ufwbuf+fw_bytes_copied, bl->len)) {
 				printk(MYIOC_s_ERR_FMT "%s@%d::_ioctl_fwdl - "
-					"Unable to copy f/w buffer hunk#%d @ %p\n",
-					iocp->name, __FILE__, __LINE__, n, ufwbuf);
+				    "Unable to copy f/w buffer hunk#%d @ %p\n",
+				    iocp->name, __FILE__, __LINE__, n, ufwbuf);
 				goto fwdl_out;
 			}
 			fw_bytes_copied += bl->len;
@@ -892,16 +890,26 @@ mptctl_do_fw_download(int ioc, char __us
 	 * Finally, perform firmware download.
 	 */
 	ReplyMsg = NULL;
+	INITIALIZE_MGMT_STATUS(iocp->ioctl_cmds.status)
 	mpt_put_msg_frame(mptctl_id, iocp, mf);
 
 	/* Now wait for the command to complete */
-	ret = wait_event_timeout(mptctl_wait,
-	     iocp->ioctl->wait_done == 1,
-	     HZ*60);
-
-	if(ret <=0 && (iocp->ioctl->wait_done != 1 )) {
-	/* Now we need to reset the board */
-		mptctl_timeout_expired(iocp->ioctl);
+	timeleft = wait_for_completion_timeout(&iocp->ioctl_cmds.done, HZ*60);
+	if (!(iocp->ioctl_cmds.status & MPT_MGMT_STATUS_COMMAND_GOOD)) {
+		ret = -ETIME;
+		printk(MYIOC_s_WARN_FMT "%s: failed\n", iocp->name, __FUNCTION__);
+		if (iocp->ioctl_cmds.status & MPT_MGMT_STATUS_DID_IOCRESET) {
+			mpt_free_msg_frame(iocp, mf);
+			goto fwdl_out;
+		}
+		if (!timeleft)
+			mptctl_timeout_expired(iocp, mf);
+		goto fwdl_out;
+	}
+
+	if (!(iocp->ioctl_cmds.status & MPT_MGMT_STATUS_RF_VALID)) {
+		printk(MYIOC_s_WARN_FMT "%s: failed\n", iocp->name, __FUNCTION__);
+		mpt_free_msg_frame(iocp, mf);
 		ret = -ENODATA;
 		goto fwdl_out;
 	}
@@ -909,7 +917,7 @@ mptctl_do_fw_download(int ioc, char __us
 	if (sgl)
 		kfree_sgl(sgl, sgl_dma, buflist, iocp);
 
-	ReplyMsg = (pFWDownloadReply_t)iocp->ioctl->ReplyFrame;
+	ReplyMsg = (pFWDownloadReply_t)iocp->ioctl_cmds.reply;
 	iocstat = le16_to_cpu(ReplyMsg->IOCStatus) & MPI_IOCSTATUS_MASK;
 	if (iocstat == MPI_IOCSTATUS_SUCCESS) {
 		printk(MYIOC_s_INFO_FMT "F/W update successfull!\n", iocp->name);
@@ -933,6 +941,8 @@ mptctl_do_fw_download(int ioc, char __us
 	return 0;
 
 fwdl_out:
+
+	CLEAR_MGMT_STATUS(iocp->ioctl_cmds.status)
         kfree_sgl(sgl, sgl_dma, buflist, iocp);
 	return ret;
 }
@@ -1015,9 +1025,9 @@ kbuf_alloc_2_sgl(int bytes, u32 sgdir, i
 			alloc_sz = alloc_sz / 2;
 			if (alloc_sz == 0) {
 				printk(MYIOC_s_WARN_FMT "-SG: No can do - "
-				    "not enough memory!   :-(\n", ioc->name);
+				    "not enough memory! :-(\n", ioc->name);
 				printk(MYIOC_s_WARN_FMT "-SG: (freeing %d frags)\n",
-					ioc->name, numfrags);
+				    ioc->name, numfrags);
 				goto free_and_fail;
 			}
 			continue;
@@ -1040,8 +1050,8 @@ kbuf_alloc_2_sgl(int bytes, u32 sgdir, i
 
 		/* Need to chain? */
 		if (fragcnt == sg_spill) {
-			printk(MYIOC_s_WARN_FMT
-			    "-SG: No can do - " "Chain required!   :-(\n", ioc->name);
+			printk(MYIOC_s_WARN_FMT "-SG: No can do - "
+			    "Chain required! :-(\n", ioc->name);
 			printk(MYIOC_s_WARN_FMT "(freeing %d frags)\n", ioc->name, numfrags);
 			goto free_and_fail;
 		}
@@ -1050,9 +1060,9 @@ kbuf_alloc_2_sgl(int bytes, u32 sgdir, i
 		if (numfrags*8 > MAX_SGL_BYTES){
 			/* GRRRRR... */
 			printk(MYIOC_s_WARN_FMT "-SG: No can do - "
-				"too many SG frags!   :-(\n", ioc->name);
+			    "too many SG frags! :-(\n", ioc->name);
 			printk(MYIOC_s_WARN_FMT "-SG: (freeing %d frags)\n",
-				ioc->name, numfrags);
+			    ioc->name, numfrags);
 			goto free_and_fail;
 		}
 	}
@@ -1073,6 +1083,7 @@ kbuf_alloc_2_sgl(int bytes, u32 sgdir, i
 
 free_and_fail:
 	if (sglbuf != NULL) {
+
 		for (i = 0; i < numfrags; i++) {
 			dma_addr_t dma_addr;
 			u8 *kptr;
@@ -1358,7 +1369,7 @@ mptctl_gettargetinfo (unsigned long arg)
 	port = karg.hdr.port;
 
 	if (maxWordsLeft <= 0) {
-		printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_gettargetinfo() - no memory available!\n",
+		printk(MYIOC_s_ERR_FMT "%s::mptctl_gettargetinfo() @%d - no memory available!\n",
 			ioc->name, __FILE__, __LINE__);
 		return -ENOMEM;
 	}
@@ -1379,7 +1390,7 @@ mptctl_gettargetinfo (unsigned long arg)
 	 */
 	pmem = kzalloc(numBytes, GFP_KERNEL);
 	if (!pmem) {
-		printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_gettargetinfo() - no memory available!\n",
+		printk(MYIOC_s_ERR_FMT "%s::mptctl_gettargetinfo() @%d - no memory available!\n",
 			ioc->name, __FILE__, __LINE__);
 		return -ENOMEM;
 	}
@@ -1569,9 +1580,7 @@ mptctl_eventenable (unsigned long arg)
 		int sz = MPTCTL_EVENT_LOG_SIZE * sizeof(MPT_IOCTL_EVENTS);
 		ioc->events = kzalloc(sz, GFP_KERNEL);
 		if (!ioc->events) {
-			printk(MYIOC_s_ERR_FMT
-			    ": ERROR - Insufficient memory to add adapter!\n",
-			    ioc->name);
+			printk(MYIOC_s_ERR_FMT "Insufficient memory to add adapter!\n", ioc->name);
 			return -ENOMEM;
 		}
 		ioc->alloc_total += sz;
@@ -1771,8 +1780,11 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 	int		sz, rc = 0;
 	int		msgContext;
 	u16		req_idx;
-	ulong 		timeout;
+	unsigned long 	timeout;
+	unsigned long	timeleft;
 	struct scsi_device *sdev;
+	unsigned long	 flags;
+	u8		 function;
 
 	bufIn.kptr = bufOut.kptr = NULL;
 
@@ -1782,16 +1794,15 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 				__FILE__, __LINE__, iocnum);
 		return -ENODEV;
 	}
-	if (!ioc->ioctl) {
-		printk(KERN_ERR MYNAM "%s@%d::mptctl_do_mpt_command - "
-			"No memory available during driver init.\n",
-				__FILE__, __LINE__);
-		return -ENOMEM;
-	} else if (ioc->ioctl->status & MPT_IOCTL_STATUS_DID_IOCRESET) {
+
+	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
+	if (ioc->ioc_reset_in_progress) {
+		spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
 		printk(KERN_ERR MYNAM "%s@%d::mptctl_do_mpt_command - "
-			"Busy with IOC Reset \n", __FILE__, __LINE__);
+			"Busy with diagnostic reset\n", __FILE__, __LINE__);
 		return -EBUSY;
 	}
+	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
 
 	/* Verify that the final request frame will not be too large.
 	 */
@@ -1825,18 +1836,20 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 		printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_do_mpt_command - "
 			"Unable to read MF from mpt_ioctl_command struct @ %p\n",
 			ioc->name, __FILE__, __LINE__, mfPtr);
+		function = -1;
 		rc = -EFAULT;
 		goto done_free_mem;
 	}
 	hdr->MsgContext = cpu_to_le32(msgContext);
+	function = hdr->Function;
 
 
 	/* Verify that this request is allowed.
 	 */
 	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "sending mpi function (0x%02X), req=%p\n",
-	    ioc->name, hdr->Function, mf));
+	    ioc->name, function, mf));
 
-	switch (hdr->Function) {
+	switch (function) {
 	case MPI_FUNCTION_IOC_FACTS:
 	case MPI_FUNCTION_PORT_FACTS:
 		karg.dataOutSize  = karg.dataInSize = 0;
@@ -1933,9 +1946,6 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 			pScsiReq->Control = cpu_to_le32(scsidir | qtag);
 			pScsiReq->DataLength = cpu_to_le32(dataSize);
 
-			ioc->ioctl->reset = MPTCTL_RESET_OK;
-			ioc->ioctl->id = pScsiReq->TargetID;
-
 		} else {
 			printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_do_mpt_command - "
 				"SCSI driver is not loaded. \n",
@@ -2012,8 +2022,6 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 			pScsiReq->Control = cpu_to_le32(scsidir | qtag);
 			pScsiReq->DataLength = cpu_to_le32(dataSize);
 
-			ioc->ioctl->reset = MPTCTL_RESET_OK;
-			ioc->ioctl->id = pScsiReq->TargetID;
 		} else {
 			printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_do_mpt_command - "
 				"SCSI driver is not loaded. \n",
@@ -2024,20 +2032,15 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 		break;
 
 	case MPI_FUNCTION_SCSI_TASK_MGMT:
-		{
-			MPT_SCSI_HOST *hd = NULL;
-			if ((ioc->sh == NULL) || ((hd = shost_priv(ioc->sh)) == NULL)) {
-				printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_do_mpt_command - "
-					"SCSI driver not loaded or SCSI host not found. \n",
-					ioc->name, __FILE__, __LINE__);
-				rc = -EFAULT;
-				goto done_free_mem;
-			} else if (mptctl_set_tm_flags(hd) != 0) {
-				rc = -EPERM;
-				goto done_free_mem;
-			}
-		}
+	{
+		SCSITaskMgmt_t	*pScsiTm;
+		pScsiTm = (SCSITaskMgmt_t *)mf;
+		dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "\tTaskType=0x%x MsgFlags=0x%x "
+		    "TaskMsgContext=0x%x id=%d channel=%d\n", ioc->name, pScsiTm->TaskType,
+		    le32_to_cpu(pScsiTm->TaskMsgContext), pScsiTm->MsgFlags,
+		    pScsiTm->TargetID, pScsiTm->Bus));
 		break;
+	}
 
 	case MPI_FUNCTION_IOC_INIT:
 		{
@@ -2095,7 +2098,7 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 
 		printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_do_mpt_command - "
 			"Illegal request (function 0x%x) \n",
-			ioc->name, __FILE__, __LINE__, hdr->Function);
+			ioc->name, __FILE__, __LINE__, function);
 		rc = -EFAULT;
 		goto done_free_mem;
 	}
@@ -2187,8 +2190,14 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 		mpt_add_sge(psge, flagsLength, (dma_addr_t) -1);
 	}
 
-	ioc->ioctl->wait_done = 0;
-	if (hdr->Function == MPI_FUNCTION_SCSI_TASK_MGMT) {
+	INITIALIZE_MGMT_STATUS(ioc->ioctl_cmds.status)
+	if (function == MPI_FUNCTION_SCSI_TASK_MGMT) {
+
+		mutex_lock(&ioc->taskmgmt_cmds.mutex);
+		if (mpt_set_taskmgmt_in_progress_flag(ioc) != 0) {
+			mutex_unlock(&ioc->taskmgmt_cmds.mutex);
+			goto done_free_mem;
+		}
 
 		DBG_DUMP_TM_REQUEST_FRAME(ioc, (u32 *)mf);
 
@@ -2196,57 +2205,61 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 		    (ioc->facts.MsgVersion >= MPI_VERSION_01_05))
 			mpt_put_msg_frame_hi_pri(mptctl_id, ioc, mf);
 		else {
-			rc =mpt_send_handshake_request(mptctl_id, ioc,
-				sizeof(SCSITaskMgmt_t), (u32*)mf, CAN_SLEEP);
+			rc = mpt_send_handshake_request(mptctl_id, ioc,
+			    sizeof(SCSITaskMgmt_t), (u32*)mf, CAN_SLEEP);
 			if (rc != 0) {
 				dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
-				    "_send_handshake FAILED! (ioc %p, mf %p)\n",
+				    "send_handshake FAILED! (ioc %p, mf %p)\n",
 				    ioc->name, ioc, mf));
-				mptctl_free_tm_flags(ioc);
+				mpt_clear_taskmgmt_in_progress_flag(ioc);
 				rc = -ENODATA;
+				mutex_unlock(&ioc->taskmgmt_cmds.mutex);
 				goto done_free_mem;
 			}
 		}
-
 	} else
 		mpt_put_msg_frame(mptctl_id, ioc, mf);
 
 	/* Now wait for the command to complete */
 	timeout = (karg.timeout > 0) ? karg.timeout : MPT_IOCTL_DEFAULT_TIMEOUT;
-	timeout = wait_event_timeout(mptctl_wait,
-	     ioc->ioctl->wait_done == 1,
-	     HZ*timeout);
-
-	if(timeout <=0 && (ioc->ioctl->wait_done != 1 )) {
-	/* Now we need to reset the board */
-
-		if (hdr->Function == MPI_FUNCTION_SCSI_TASK_MGMT)
-			mptctl_free_tm_flags(ioc);
-
-		mptctl_timeout_expired(ioc->ioctl);
-		rc = -ENODATA;
+	timeleft = wait_for_completion_timeout(&ioc->ioctl_cmds.done, HZ*timeout);
+	if (!(ioc->ioctl_cmds.status & MPT_MGMT_STATUS_COMMAND_GOOD)) {
+		rc = -ETIME;
+		dfailprintk(ioc, printk(MYIOC_s_ERR_FMT "%s: TIMED OUT!\n",
+		    ioc->name, __FUNCTION__));
+		if (function == MPI_FUNCTION_SCSI_TASK_MGMT)
+			mutex_unlock(&ioc->taskmgmt_cmds.mutex);
+		if (ioc->ioctl_cmds.status & MPT_MGMT_STATUS_DID_IOCRESET) {
+			goto done_free_mem;
+		}
+		if (!timeleft) {
+			mptctl_timeout_expired(ioc, mf);
+			mf = NULL;
+		}
 		goto done_free_mem;
 	}
 
+	if (function == MPI_FUNCTION_SCSI_TASK_MGMT)
+		mutex_unlock(&ioc->taskmgmt_cmds.mutex);
+
 	mf = NULL;
 
 	/* If a valid reply frame, copy to the user.
 	 * Offset 2: reply length in U32's
 	 */
-	if (ioc->ioctl->status & MPT_IOCTL_STATUS_RF_VALID) {
+	if (ioc->ioctl_cmds.status & MPT_MGMT_STATUS_RF_VALID) {
 		if (karg.maxReplyBytes < ioc->reply_sz) {
-			 sz = min(karg.maxReplyBytes, 4*ioc->ioctl->ReplyFrame[2]);
+			 sz = min(karg.maxReplyBytes, 4*ioc->ioctl_cmds.reply[2]);
 		} else {
-			 sz = min(ioc->reply_sz, 4*ioc->ioctl->ReplyFrame[2]);
+			 sz = min(ioc->reply_sz, 4*ioc->ioctl_cmds.reply[2]);
 		}
-
 		if (sz > 0) {
 			if (copy_to_user(karg.replyFrameBufPtr,
-				 &ioc->ioctl->ReplyFrame, sz)){
+				 ioc->ioctl_cmds.reply, sz)){
 				 printk(MYIOC_s_ERR_FMT
 				     "%s@%d::mptctl_do_mpt_command - "
 				 "Unable to write out reply frame %p\n",
-				 ioc->name, __FILE__, __LINE__, karg.replyFrameBufPtr);
+				ioc->name, __FILE__, __LINE__, karg.replyFrameBufPtr);
 				 rc =  -ENODATA;
 				 goto done_free_mem;
 			}
@@ -2255,10 +2268,10 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 
 	/* If valid sense data, copy to user.
 	 */
-	if (ioc->ioctl->status & MPT_IOCTL_STATUS_SENSE_VALID) {
+	if (ioc->ioctl_cmds.status & MPT_MGMT_STATUS_SENSE_VALID) {
 		sz = min(karg.maxSenseBytes, MPT_SENSE_BUFFER_SIZE);
 		if (sz > 0) {
-			if (copy_to_user(karg.senseDataPtr, ioc->ioctl->sense, sz)) {
+			if (copy_to_user(karg.senseDataPtr, ioc->ioctl_cmds.sense, sz)) {
 				printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_do_mpt_command - "
 				"Unable to write sense data to user %p\n",
 				ioc->name, __FILE__, __LINE__,
@@ -2272,11 +2285,10 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 	/* If the overall status is _GOOD and data in, copy data
 	 * to user.
 	 */
-	if ((ioc->ioctl->status & MPT_IOCTL_STATUS_COMMAND_GOOD) &&
-				(karg.dataInSize > 0) && (bufIn.kptr)) {
-
+	if ((ioc->ioctl_cmds.status & MPT_MGMT_STATUS_COMMAND_GOOD) &&
+		(karg.dataInSize > 0) && (bufIn.kptr)) {
 		if (copy_to_user(karg.dataInBufPtr,
-				 bufIn.kptr, karg.dataInSize)) {
+		    bufIn.kptr, karg.dataInSize)) {
 			printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_do_mpt_command - "
 				"Unable to write data to user %p\n",
 				ioc->name, __FILE__, __LINE__,
@@ -2287,9 +2299,7 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 
 done_free_mem:
 
-	ioc->ioctl->status &= ~(MPT_IOCTL_STATUS_COMMAND_GOOD |
-		MPT_IOCTL_STATUS_SENSE_VALID |
-		MPT_IOCTL_STATUS_RF_VALID );
+	CLEAR_MGMT_STATUS(ioc->ioctl_cmds.status)
 
 	/* Free the allocated memory.
 	 */
@@ -2329,16 +2339,16 @@ mptctl_hp_hostinfo(unsigned long arg, un
 	hp_host_info_t	__user *uarg = (void __user *) arg;
 	MPT_ADAPTER		*ioc;
 	struct pci_dev		*pdev;
-	char                    *pbuf=NULL;
+	char			*pbuf=NULL;
 	dma_addr_t		buf_dma;
 	hp_host_info_t		karg;
-	CONFIGPARMS		cfg;
-	ConfigPageHeader_t	hdr;
 	int			iocnum;
-	int			rc, cim_rev;
+	int			cim_rev;
 	ToolboxIstwiReadWriteRequest_t	*IstwiRWRequest;
 	MPT_FRAME_HDR		*mf = NULL;
 	MPIHeader_t		*mpi_hdr;
+	unsigned long		timeleft;
+	int			retval;
 
 	/* Reset long to int. Should affect IA64 and SPARC only
 	 */
@@ -2362,9 +2372,9 @@ mptctl_hp_hostinfo(unsigned long arg, un
 				__FILE__, __LINE__, iocnum);
 		return -ENODEV;
 	}
+
 	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT ": mptctl_hp_hostinfo called.\n",
 	    ioc->name));
-
 	/* Fill in the data and return the structure to the calling
 	 * program
 	 */
@@ -2404,42 +2414,9 @@ mptctl_hp_hostinfo(unsigned long arg, un
 	karg.fw_version[10] = (ioc->facts.FWVersion.Struct.Dev % 10 ) + '0';
 	karg.fw_version[11] = '\0';
 
-	/* Issue a config request to get the device serial number
-	 */
-	hdr.PageVersion = 0;
-	hdr.PageLength = 0;
-	hdr.PageNumber = 0;
-	hdr.PageType = MPI_CONFIG_PAGETYPE_MANUFACTURING;
-	cfg.cfghdr.hdr = &hdr;
-	cfg.physAddr = -1;
-	cfg.pageAddr = 0;
-	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
-	cfg.dir = 0;	/* read */
-	cfg.timeout = 10;
+	strncpy(karg.serial_number, ioc->board_tracer, 16);
 
-	strncpy(karg.serial_number, " ", 24);
-	if (mpt_config(ioc, &cfg) == 0) {
-		if (cfg.cfghdr.hdr->PageLength > 0) {
-			/* Issue the second config page request */
-			cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
-
-			pbuf = pci_alloc_consistent(ioc->pcidev, hdr.PageLength * 4, &buf_dma);
-			if (pbuf) {
-				cfg.physAddr = buf_dma;
-				if (mpt_config(ioc, &cfg) == 0) {
-					ManufacturingPage0_t *pdata = (ManufacturingPage0_t *) pbuf;
-					if (strlen(pdata->BoardTracerNumber) > 1) {
-						strncpy(karg.serial_number, 									    pdata->BoardTracerNumber, 24);
-						karg.serial_number[24-1]='\0';
-					}
-				}
-				pci_free_consistent(ioc->pcidev, hdr.PageLength * 4, pbuf, buf_dma);
-				pbuf = NULL;
-			}
-		}
-	}
-	rc = mpt_GetIocState(ioc, 1);
-	switch (rc) {
+	switch (mpt_GetIocState(ioc, 1)) {
 	case MPI_IOC_STATE_OPERATIONAL:
 		karg.ioc_status =  HP_STATUS_OK;
 		break;
@@ -2469,9 +2446,9 @@ mptctl_hp_hostinfo(unsigned long arg, un
 		MPT_SCSI_HOST *hd =  shost_priv(ioc->sh);
 
 		if (hd && (cim_rev == 1)) {
-			karg.hard_resets = hd->hard_resets;
-			karg.soft_resets = hd->soft_resets;
-			karg.timeouts = hd->timeouts;
+			karg.hard_resets = ioc->hard_resets;
+			karg.soft_resets = ioc->soft_resets;
+			karg.timeouts = ioc->timeouts;
 		}
 	}
 
@@ -2481,6 +2458,7 @@ mptctl_hp_hostinfo(unsigned long arg, un
 	if ((mf = mpt_get_msg_frame(mptctl_id, ioc)) == NULL) {
 		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT "%s, no msg frames!!\n",
 		    ioc->name,__FUNCTION__));
+		retval = -ENOMEM;
 		goto out;
 	}
 
@@ -2499,28 +2477,29 @@ mptctl_hp_hostinfo(unsigned long arg, un
 		IstwiRWRequest->DeviceAddr = 0xB0;
 
 	pbuf = pci_alloc_consistent(ioc->pcidev, 4, &buf_dma);
-	if (!pbuf)
+	if (!pbuf) {
+		retval = -ENOMEM;
 		goto out;
-	mpt_add_sge((char *)&IstwiRWRequest->SGL,
-	    (MPT_SGE_FLAGS_SSIMPLE_READ|4), buf_dma);
+	}
+	mpt_add_sge((char *)&IstwiRWRequest->SGL, (MPT_SGE_FLAGS_SSIMPLE_READ|4),buf_dma);
 
-	ioc->ioctl->wait_done = 0;
+	retval = 0;
+	INITIALIZE_MGMT_STATUS(ioc->ioctl_cmds.status)
 	mpt_put_msg_frame(mptctl_id, ioc, mf);
-
-	rc = wait_event_timeout(mptctl_wait,
-	     ioc->ioctl->wait_done == 1,
-	     HZ*MPT_IOCTL_DEFAULT_TIMEOUT /* 10 sec */);
-
-	if(rc <=0 && (ioc->ioctl->wait_done != 1 )) {
-		/*
-		 * Now we need to reset the board
-		 */
-		mpt_free_msg_frame(ioc, mf);
-		mptctl_timeout_expired(ioc->ioctl);
+	timeleft = wait_for_completion_timeout(&ioc->ioctl_cmds.done, HZ*MPT_IOCTL_DEFAULT_TIMEOUT);
+	if (!(ioc->ioctl_cmds.status & MPT_MGMT_STATUS_COMMAND_GOOD)) {
+		retval = -ETIME;
+		printk(MYIOC_s_WARN_FMT "%s: failed\n", ioc->name, __FUNCTION__);
+		if (ioc->ioctl_cmds.status & MPT_MGMT_STATUS_DID_IOCRESET) {
+			mpt_free_msg_frame(ioc, mf);
+			goto out;
+		}
+		if (!timeleft)
+			mptctl_timeout_expired(ioc, mf);
 		goto out;
 	}
 
-	/*
+	/* 
 	 *ISTWI Data Definition
 	 * pbuf[0] = FW_VERSION = 0x4
 	 * pbuf[1] = Bay Count = 6 or 4 or 2, depending on
@@ -2529,10 +2508,12 @@ mptctl_hp_hostinfo(unsigned long arg, un
 	 *   bays have drives in them
 	 * pbuf[3] = Checksum (0x100 = (byte0 + byte2 + byte3)
 	 */
-	if (ioc->ioctl->status & MPT_IOCTL_STATUS_RF_VALID)
+	if (ioc->ioctl_cmds.status & MPT_MGMT_STATUS_RF_VALID)
 		karg.rsvd = *(u32 *)pbuf;
 
  out:
+	CLEAR_MGMT_STATUS(ioc->ioctl_cmds.status)
+
 	if (pbuf)
 		pci_free_consistent(ioc->pcidev, 4, pbuf, buf_dma);
 
@@ -2545,7 +2526,7 @@ mptctl_hp_hostinfo(unsigned long arg, un
 		return -EFAULT;
 	}
 
-	return 0;
+	return retval;
 
 }
 
@@ -2757,7 +2738,7 @@ compat_mptfwxfer_ioctl(struct file *filp
 
 	ret = mptctl_do_fw_download(kfw.iocnum, kfw.bufp, kfw.fwlen);
 
-	mutex_unlock(&iocp->ioctl->ioctl_mutex);
+	mutex_unlock(&iocp->ioctl_cmds.mutex);
 
 	return ret;
 }
@@ -2811,7 +2792,7 @@ compat_mpt_command(struct file *filp, un
 	 */
 	ret = mptctl_do_mpt_command (karg, &uarg->MF);
 
-	mutex_unlock(&iocp->ioctl->ioctl_mutex);
+	mutex_unlock(&iocp->ioctl_cmds.mutex);
 
 	return ret;
 }
@@ -2859,25 +2840,15 @@ static long compat_mpctl_ioctl(struct fi
  *	Returns 0 for success, non-zero for failure.
  *
  */
-
 static int
 mptctl_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	MPT_IOCTL *mem;
 	MPT_ADAPTER *ioc = pci_get_drvdata(pdev);
 
-	/*
-	 * Allocate and inite a MPT_IOCTL structure
-	*/
-	mem = kzalloc(sizeof(MPT_IOCTL), GFP_KERNEL);
-	if (!mem) {
-		mptctl_remove(pdev);
-		return -ENOMEM;
-	}
+	mutex_init(&ioc->ioctl_cmds.mutex);
+	init_completion(&ioc->ioctl_cmds.done);
 
-	ioc->ioctl = mem;
-	ioc->ioctl->ioc = ioc;
-	mutex_init(&ioc->ioctl->ioctl_mutex);
+	mptctl_remove(pdev);
 	return 0;
 }
 
@@ -2891,9 +2862,6 @@ mptctl_probe(struct pci_dev *pdev, const
 static void
 mptctl_remove(struct pci_dev *pdev)
 {
-	MPT_ADAPTER *ioc = pci_get_drvdata(pdev);
-
-	kfree ( ioc->ioctl );
 }
 
 static struct mpt_pci_driver mptctl_driver = {
@@ -2927,12 +2895,13 @@ static int __init mptctl_init(void)
 	++where;
 	mptctl_id = mpt_register(mptctl_reply, MPTCTL_DRIVER);
 	if (!mptctl_id || mptctl_id >= MPT_MAX_PROTOCOL_DRIVERS) {
-		printk(KERN_ERR MYNAM ": ERROR: Failed to register with Fusion MPT base driver\n");
+		printk(KERN_ERR MYNAM ": Failed to register with Fusion MPT base driver\n");
 		misc_deregister(&mptctl_miscdev);
 		err = -EBUSY;
 		goto out_fail;
 	}
 
+	mptctl_taskmgmt_id = mpt_register(mptctl_taskmgmt_reply, MPTCTL_DRIVER);
 	mpt_reset_register(mptctl_id, mptctl_ioc_reset);
 	mpt_event_register(mptctl_id, mptctl_event_process);
 
@@ -2954,6 +2923,7 @@ static void mptctl_exit(void)
 
 	/* De-register reset handler from base module */
 	mpt_reset_deregister(mptctl_id);
+	mpt_reset_deregister(mptctl_taskmgmt_id);
 
 	/* De-register callback handler from base module */
 	mpt_deregister(mptctl_id);
--- b/drivers/message/fusion/mptctl.h	2007-09-05 15:23:33.000000000 -0600
+++ a/drivers/message/fusion/mptctl.h	2007-09-17 15:05:32.000000000 -0600
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/message/fusion/mptioctl.h
+ *  linux/drivers/message/fusion/mptctl.h
  *      Fusion MPT misc device (ioctl) driver.
  *      For use with PCI chip/adapter(s):
  *          LSIFC9xx/LSI409xx Fibre Channel
