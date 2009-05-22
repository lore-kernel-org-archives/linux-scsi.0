From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 11/24] mpt fusion: [2.6.30-rc6]rewrite of ioctl_cmds internal generated function
Date: Fri, 22 May 2009 16:31:15 +0530
Message-ID: <20090522110106.GE16331@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og124.obsmtp.com ([64.18.2.26]:56178 "EHLO
	exprod7og124.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbZEVLWQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2009 07:22:16 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

1) rewrite of ioctl_cmds internal generated function that issue commands to
firmware, porting them to be single threaded using the generic MPT_MGMT
struct. All wait Queues are replace by completion Queue.
2) added seperate callback handler for ioctl task managment
(mptctl_taskmgmt_reply), to handle command that timeout
3) rewrite mptctl_bus_reset
---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index a0bf7d8..24d6012 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -434,18 +434,6 @@ do { \
 
 #define MPTCTL_RESET_OK			0x01	/* Issue Bus Reset */
 
-typedef struct _MPT_IOCTL {
-	struct _MPT_ADAPTER	*ioc;
-	u8			 ReplyFrame[MPT_DEFAULT_FRAME_SIZE];	/* reply frame data */
-	u8			 sense[MPT_SENSE_BUFFER_ALLOC];
-	int			 wait_done;	/* wake-up value for this ioc */
-	u8			 rsvd;
-	u8			 status;	/* current command status */
-	u8			 reset;		/* 1 if bus reset allowed */
-	u8			 id;		/* target for reset */
-	struct mutex		 ioctl_mutex;
-} MPT_IOCTL;
-
 #define MPT_MGMT_STATUS_RF_VALID	0x01	/* The Reply Frame is VALID */
 #define MPT_MGMT_STATUS_COMMAND_GOOD	0x02	/* Command Status GOOD */
 #define MPT_MGMT_STATUS_PENDING		0x04	/* command is pending */
@@ -460,6 +448,10 @@ typedef struct _MPT_IOCTL {
 	status = MPT_MGMT_STATUS_PENDING;
 #define CLEAR_MGMT_STATUS(status) \
 	status = 0;
+#define CLEAR_MGMT_PENDING_STATUS(status) \
+	status &= ~MPT_MGMT_STATUS_PENDING;
+#define SET_MGMT_MSG_CONTEXT(msg_context, value) \
+	msg_context = value;
 
 typedef struct _MPT_MGMT {
 	struct mutex		 mutex;
@@ -468,6 +460,7 @@ typedef struct _MPT_MGMT {
 	u8			 sense[MPT_SENSE_BUFFER_ALLOC];
 	u8			 status;	/* current command status */
 	int			 completion_code;
+	u32			 msg_context;
 } MPT_MGMT;
 
 /*
@@ -654,7 +647,6 @@ typedef struct _MPT_ADAPTER
 	RaidCfgData		raid_data;	/* Raid config. data */
 	SasCfgData		sas_data;	/* Sas config. data */
 	FcCfgData		fc_data;	/* Fc config. data */
-	MPT_IOCTL		*ioctl;		/* ioctl data pointer */
 	struct proc_dir_entry	*ioc_dentry;
 	struct _MPT_ADAPTER	*alt_ioc;	/* ptr to 929 bound adapter port */
 	u32			 biosVersion;	/* BIOS version from IO Unit Page 2 */
@@ -711,6 +703,7 @@ typedef struct _MPT_ADAPTER
 	MPT_MGMT		 mptbase_cmds; /* for sending config pages */
 	MPT_MGMT		 internal_cmds;
 	MPT_MGMT		 taskmgmt_cmds;
+	MPT_MGMT		 ioctl_cmds;
 	spinlock_t		 taskmgmt_lock; /* diagnostic reset lock */
 	int			 taskmgmt_in_progress;
 	u8			 taskmgmt_quiesce_io;
@@ -855,10 +848,8 @@ typedef struct _MPT_SCSI_HOST {
 		/* Pool of memory for holding SCpnts before doing
 		 * OS callbacks. freeQ is the free pool.
 		 */
-	u8			  tmPending;
 	u8			  negoNvram;		/* DV disabled, nego NVRAM */
 	u8			  pad1;
-	u8                        tmState;
 	u8			  rsvd[2];
 	MPT_FRAME_HDR		 *cmdPtr;		/* Ptr to nonOS request */
 	struct scsi_cmnd	 *abortSCpnt;
diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index 6ffb982..ab62013 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -84,6 +84,7 @@ MODULE_VERSION(my_VERSION);
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 
 static u8 mptctl_id = MPT_MAX_PROTOCOL_DRIVERS;
+static u8 mptctl_taskmgmt_id = MPT_MAX_PROTOCOL_DRIVERS;
 
 static DECLARE_WAIT_QUEUE_HEAD ( mptctl_wait );
 
@@ -127,10 +128,7 @@ static MptSge_t *kbuf_alloc_2_sgl(int bytes, u32 dir, int sge_offset, int *frags
 		struct buflist **blp, dma_addr_t *sglbuf_dma, MPT_ADAPTER *ioc);
 static void kfree_sgl(MptSge_t *sgl, dma_addr_t sgl_dma,
 		struct buflist *buflist, MPT_ADAPTER *ioc);
-static void mptctl_timeout_expired (MPT_IOCTL *ioctl);
-static int  mptctl_bus_reset(MPT_IOCTL *ioctl);
-static int mptctl_set_tm_flags(MPT_SCSI_HOST *hd);
-static void mptctl_free_tm_flags(MPT_ADAPTER *ioc);
+static int mptctl_bus_reset(MPT_ADAPTER *ioc, u8 function);
 
 /*
  * Reset Handler cleanup function
@@ -183,10 +181,10 @@ mptctl_syscall_down(MPT_ADAPTER *ioc, int nonblock)
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
@@ -202,99 +200,78 @@ mptctl_syscall_down(MPT_ADAPTER *ioc, int nonblock)
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
 
-	if (req)
-		 cmd = req->u.hdr.Function;
-	else
-		return 1;
-	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "\tcompleting mpi function (0x%02X), req=%p, "
-	    "reply=%p\n", ioc->name,  req->u.hdr.Function, req, reply));
-
-	if (ioc->ioctl) {
-
-		if (reply==NULL) {
-
-			dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mptctl_reply() NULL Reply "
-				"Function=%x!\n", ioc->name, cmd));
+	if (!req)
+		return 0;
 
-			ioc->ioctl->status |= MPT_MGMT_STATUS_COMMAND_GOOD;
-			ioc->ioctl->reset &= ~MPTCTL_RESET_OK;
+	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "completing mpi function "
+	    "(0x%02X), req=%p, reply=%p\n", ioc->name,  req->u.hdr.Function,
+	    req, reply));
 
-			/* We are done, issue wake up
-	 		*/
-			ioc->ioctl->wait_done = 1;
-			wake_up (&mptctl_wait);
-			return 1;
+	/*
+	 * Handling continuation of the same reply. Processing the first
+	 * reply, and eating the other replys that come later.
+	 */
+	if (ioc->ioctl_cmds.msg_context != req->u.hdr.MsgContext)
+		goto out_continuation;
 
-		}
+	ioc->ioctl_cmds.status |= MPT_MGMT_STATUS_COMMAND_GOOD;
 
-		/* Copy the reply frame (which much exist
-		 * for non-SCSI I/O) to the IOC structure.
-		 */
-		memcpy(ioc->ioctl->ReplyFrame, reply,
-			min(ioc->reply_sz, 4*reply->u.reply.MsgLength));
-		ioc->ioctl->status |= MPT_MGMT_STATUS_RF_VALID;
+	if (!reply)
+		goto out;
 
-		/* Set the command status to GOOD if IOC Status is GOOD
-		 * OR if SCSI I/O cmd and data underrun or recovered error.
-		 */
-		iocStatus = le16_to_cpu(reply->u.reply.IOCStatus) & MPI_IOCSTATUS_MASK;
-		if (iocStatus  == MPI_IOCSTATUS_SUCCESS)
-			ioc->ioctl->status |= MPT_MGMT_STATUS_COMMAND_GOOD;
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
-			ioc->ioctl->status |= MPT_MGMT_STATUS_COMMAND_GOOD;
-			}
-		}
+	ioc->ioctl_cmds.status |= MPT_MGMT_STATUS_RF_VALID;
+	sz = min(ioc->reply_sz, 4*reply->u.reply.MsgLength);
+	memcpy(ioc->ioctl_cmds.reply, reply, sz);
 
-		/* Copy the sense data - if present
-		 */
-		if ((cmd == MPI_FUNCTION_SCSI_IO_REQUEST) &&
-			(reply->u.sreply.SCSIState &
-			 MPI_SCSI_STATE_AUTOSENSE_VALID)){
+	if (reply->u.reply.IOCStatus || reply->u.reply.IOCLogInfo)
+		dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "iocstatus (0x%04X), loginfo (0x%08X)\n", ioc->name,
+		    le16_to_cpu(reply->u.reply.IOCStatus),
+		    le32_to_cpu(reply->u.reply.IOCLogInfo)));
+
+	if ((req->u.hdr.Function == MPI_FUNCTION_SCSI_IO_REQUEST) ||
+		(req->u.hdr.Function ==
+		 MPI_FUNCTION_RAID_SCSI_IO_PASSTHROUGH)) {
+
+		if (reply->u.sreply.SCSIStatus || reply->u.sreply.SCSIState)
+			dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+			"scsi_status (0x%02x), scsi_state (0x%02x), "
+			"tag = (0x%04x), transfer_count (0x%08x)\n", ioc->name,
+			reply->u.sreply.SCSIStatus,
+			reply->u.sreply.SCSIState,
+			le16_to_cpu(reply->u.sreply.TaskTag),
+			le32_to_cpu(reply->u.sreply.TransferCount)));
+
+		if (reply->u.sreply.SCSIState &
+			MPI_SCSI_STATE_AUTOSENSE_VALID) {
 			sz = req->u.scsireq.SenseBufferLength;
 			req_index =
 			    le16_to_cpu(req->u.frame.hwhdr.msgctxu.fld.req_idx);
-			sense_data =
-			    ((u8 *)ioc->sense_buf_pool +
+			sense_data = ((u8 *)ioc->sense_buf_pool +
 			     (req_index * MPT_SENSE_BUFFER_ALLOC));
-			memcpy(ioc->ioctl->sense, sense_data, sz);
-			ioc->ioctl->status |= MPT_MGMT_STATUS_SENSE_VALID;
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
+		if (req->u.hdr.Function == MPI_FUNCTION_SCSI_TASK_MGMT)
+			mpt_clear_taskmgmt_in_progress_flag(ioc);
+		ioc->ioctl_cmds.status &= ~MPT_MGMT_STATUS_PENDING;
+		complete(&ioc->ioctl_cmds.done);
 	}
+
+ out_continuation:
+	if (reply && (reply->u.reply.MsgFlags &
+	    MPI_MSGFLAGS_CONTINUATION_REPLY))
+		return 0;
 	return 1;
 }
 
@@ -304,30 +281,66 @@ mptctl_reply(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req, MPT_FRAME_HDR *reply)
  * Expecting an interrupt, however timed out.
  *
  */
-static void mptctl_timeout_expired (MPT_IOCTL *ioctl)
+static void
+mptctl_timeout_expired(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf)
 {
-	int rc = 1;
+	unsigned long flags;
 
-	if (ioctl == NULL)
-		return;
-	dctlprintk(ioctl->ioc,
-		   printk(MYIOC_s_DEBUG_FMT ": Timeout Expired! Host %d\n",
-		   ioctl->ioc->name, ioctl->ioc->id));
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT ": %s\n",
+		ioc->name, __func__));
 
-	ioctl->wait_done = 0;
-	if (ioctl->reset & MPTCTL_RESET_OK)
-		rc = mptctl_bus_reset(ioctl);
+	if (mpt_fwfault_debug)
+		mpt_halt_firmware(ioc);
 
-	if (rc) {
-		/* Issue a reset for this device.
-		 * The IOC is not responding.
-		 */
-		dctlprintk(ioctl->ioc, printk(MYIOC_s_DEBUG_FMT "Calling HardReset! \n",
-			 ioctl->ioc->name));
-		mpt_HardResetHandler(ioctl->ioc, CAN_SLEEP);
+	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
+	if (ioc->ioc_reset_in_progress) {
+		spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
+		CLEAR_MGMT_PENDING_STATUS(ioc->ioctl_cmds.status)
+		mpt_free_msg_frame(ioc, mf);
+		return;
 	}
-	return;
+	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
+
 
+	if (!mptctl_bus_reset(ioc, mf->u.hdr.Function))
+		return;
+
+	/* Issue a reset for this device.
+	 * The IOC is not responding.
+	 */
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Calling HardReset! \n",
+		 ioc->name));
+	CLEAR_MGMT_PENDING_STATUS(ioc->ioctl_cmds.status)
+	mpt_HardResetHandler(ioc, CAN_SLEEP);
+	mpt_free_msg_frame(ioc, mf);
+}
+
+static int
+mptctl_taskmgmt_reply(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
+{
+	if (!mf)
+		return 0;
+
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		"TaskMgmt completed (mf=%p, mr=%p)\n",
+		ioc->name, mf, mr));
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
 }
 
 /* mptctl_bus_reset
@@ -335,133 +348,150 @@ static void mptctl_timeout_expired (MPT_IOCTL *ioctl)
  * Bus reset code.
  *
  */
-static int mptctl_bus_reset(MPT_IOCTL *ioctl)
+static int mptctl_bus_reset(MPT_ADAPTER *ioc, u8 function)
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
+		dtmprintk(ioc, printk(MYIOC_s_WARN_FMT
+			"TaskMgmt, not SCSI_IO!!\n", ioc->name));
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
+	mf = mpt_get_msg_frame(mptctl_taskmgmt_id, ioc);
+	if (mf == NULL) {
+		dtmprintk(ioc, printk(MYIOC_s_WARN_FMT
+			"TaskMgmt, no msg frames!!\n", ioc->name));
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
+	case FC:
+		timeout = 40;
+		break;
+	case SAS:
+		timeout = 30;
+		break;
+	case SPI:
+	default:
+		timeout = 2;
+		break;
+	}
 
-	ioctl->wait_done=0;
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		"TaskMgmt type=%d timeout=%ld\n",
+		ioc->name, MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS, timeout));
 
-	if ((ioctl->ioc->facts.IOCCapabilities & MPI_IOCFACTS_CAPABILITY_HIGH_PRI_Q) &&
-	    (ioctl->ioc->facts.MsgVersion >= MPI_VERSION_01_05))
-		mpt_put_msg_frame_hi_pri(mptctl_id, ioctl->ioc, mf);
+	INITIALIZE_MGMT_STATUS(ioc->taskmgmt_cmds.status)
+	CLEAR_MGMT_STATUS(ioc->taskmgmt_cmds.status)
+	time_count = jiffies;
+	if ((ioc->facts.IOCCapabilities & MPI_IOCFACTS_CAPABILITY_HIGH_PRI_Q) &&
+	    (ioc->facts.MsgVersion >= MPI_VERSION_01_05))
+		mpt_put_msg_frame_hi_pri(mptctl_taskmgmt_id, ioc, mf);
 	else {
-		retval = mpt_send_handshake_request(mptctl_id, ioctl->ioc,
-			sizeof(SCSITaskMgmt_t), (u32*)pScsiTm, CAN_SLEEP);
+		retval = mpt_send_handshake_request(mptctl_taskmgmt_id, ioc,
+		    sizeof(SCSITaskMgmt_t), (u32 *)pScsiTm, CAN_SLEEP);
 		if (retval != 0) {
-			dfailprintk(ioctl->ioc, printk(MYIOC_s_ERR_FMT "_send_handshake FAILED!"
-				" (hd %p, ioc %p, mf %p) \n", hd->ioc->name, hd,
-				hd->ioc, mf));
+			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
+				"TaskMgmt send_handshake FAILED!"
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
+	}
 
-	if(ii <=0 && (ioctl->wait_done != 1 ))  {
-		mpt_free_msg_frame(hd->ioc, mf);
-		ioctl->wait_done = 0;
+	if (!(ioc->taskmgmt_cmds.status & MPT_MGMT_STATUS_RF_VALID)) {
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "TaskMgmt failed\n", ioc->name));
+		retval = -1; /* return failure */
+		goto mptctl_bus_reset_done;
+	}
+
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
 		retval = -1; /* return failure */
 	}
 
-mptctl_bus_reset_done:
 
-	mptctl_free_tm_flags(ioctl->ioc);
+ mptctl_bus_reset_done:
+	mutex_unlock(&ioc->taskmgmt_cmds.mutex);
+	CLEAR_MGMT_STATUS(ioc->taskmgmt_cmds.status)
 	return retval;
 }
 
-static int
-mptctl_set_tm_flags(MPT_SCSI_HOST *hd) {
-	unsigned long flags;
-
-	spin_lock_irqsave(&hd->ioc->FreeQlock, flags);
-
-	if (hd->tmState == TM_STATE_NONE) {
-		hd->tmState = TM_STATE_IN_PROGRESS;
-		hd->tmPending = 1;
-		spin_unlock_irqrestore(&hd->ioc->FreeQlock, flags);
-	} else {
-		spin_unlock_irqrestore(&hd->ioc->FreeQlock, flags);
-		return -EBUSY;
-	}
-
-	return 0;
-}
-
-static void
-mptctl_free_tm_flags(MPT_ADAPTER *ioc)
-{
-	MPT_SCSI_HOST * hd;
-	unsigned long flags;
-
-	hd = shost_priv(ioc->sh);
-	if (hd == NULL)
-		return;
-
-	spin_lock_irqsave(&ioc->FreeQlock, flags);
-
-	hd->tmState = TM_STATE_NONE;
-	hd->tmPending = 0;
-	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
-
-	return;
-}
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /* mptctl_ioc_reset
@@ -473,22 +503,23 @@ mptctl_free_tm_flags(MPT_ADAPTER *ioc)
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
-		ioctl->status |= MPT_MGMT_STATUS_DID_IOCRESET;
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "%s: MPT_IOC_SETUP_RESET\n", ioc->name, __func__));
+		break;
+	case MPT_IOC_PRE_RESET:
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "%s: MPT_IOC_PRE_RESET\n", ioc->name, __func__));
 		break;
 	case MPT_IOC_POST_RESET:
-		ioctl->status &= ~MPT_MGMT_STATUS_DID_IOCRESET;
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "%s: MPT_IOC_POST_RESET\n", ioc->name, __func__));
+		if (ioc->ioctl_cmds.status & MPT_MGMT_STATUS_PENDING) {
+			ioc->ioctl_cmds.status |= MPT_MGMT_STATUS_DID_IOCRESET;
+			complete(&ioc->ioctl_cmds.done);
+		}
 		break;
-	case MPT_IOC_PRE_RESET:
 	default:
 		break;
 	}
@@ -642,7 +673,7 @@ __mptctl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	else
 		ret = -EINVAL;
 
-	mutex_unlock(&iocp->ioctl->ioctl_mutex);
+	mutex_unlock(&iocp->ioctl_cmds.mutex);
 
 	return ret;
 }
@@ -758,6 +789,7 @@ mptctl_do_fw_download(int ioc, char __user *ufwbuf, size_t fwlen)
 	int			 sge_offset = 0;
 	u16			 iocstat;
 	pFWDownloadReply_t	 ReplyMsg = NULL;
+	unsigned long		 timeleft;
 
 	if (mpt_verify_adapter(ioc, &iocp) < 0) {
 		printk(KERN_DEBUG MYNAM "ioctl_fwdl - ioc%d not found!\n",
@@ -892,16 +924,30 @@ mptctl_do_fw_download(int ioc, char __user *ufwbuf, size_t fwlen)
 	 * Finally, perform firmware download.
 	 */
 	ReplyMsg = NULL;
+	SET_MGMT_MSG_CONTEXT(iocp->ioctl_cmds.msg_context, dlmsg->MsgContext);
+	INITIALIZE_MGMT_STATUS(iocp->ioctl_cmds.status)
 	mpt_put_msg_frame(mptctl_id, iocp, mf);
 
 	/* Now wait for the command to complete */
-	ret = wait_event_timeout(mptctl_wait,
-	     iocp->ioctl->wait_done == 1,
-	     HZ*60);
+retry_wait:
+	timeleft = wait_for_completion_timeout(&iocp->ioctl_cmds.done, HZ*60);
+	if (!(iocp->ioctl_cmds.status & MPT_MGMT_STATUS_COMMAND_GOOD)) {
+		ret = -ETIME;
+		printk(MYIOC_s_WARN_FMT "%s: failed\n", iocp->name, __func__);
+		if (iocp->ioctl_cmds.status & MPT_MGMT_STATUS_DID_IOCRESET) {
+			mpt_free_msg_frame(iocp, mf);
+			goto fwdl_out;
+		}
+		if (!timeleft)
+			mptctl_timeout_expired(iocp, mf);
+		else
+			goto retry_wait;
+		goto fwdl_out;
+	}
 
-	if(ret <=0 && (iocp->ioctl->wait_done != 1 )) {
-	/* Now we need to reset the board */
-		mptctl_timeout_expired(iocp->ioctl);
+	if (!(iocp->ioctl_cmds.status & MPT_MGMT_STATUS_RF_VALID)) {
+		printk(MYIOC_s_WARN_FMT "%s: failed\n", iocp->name, __func__);
+		mpt_free_msg_frame(iocp, mf);
 		ret = -ENODATA;
 		goto fwdl_out;
 	}
@@ -909,7 +955,7 @@ mptctl_do_fw_download(int ioc, char __user *ufwbuf, size_t fwlen)
 	if (sgl)
 		kfree_sgl(sgl, sgl_dma, buflist, iocp);
 
-	ReplyMsg = (pFWDownloadReply_t)iocp->ioctl->ReplyFrame;
+	ReplyMsg = (pFWDownloadReply_t)iocp->ioctl_cmds.reply;
 	iocstat = le16_to_cpu(ReplyMsg->IOCStatus) & MPI_IOCSTATUS_MASK;
 	if (iocstat == MPI_IOCSTATUS_SUCCESS) {
 		printk(MYIOC_s_INFO_FMT "F/W update successfull!\n", iocp->name);
@@ -933,6 +979,9 @@ mptctl_do_fw_download(int ioc, char __user *ufwbuf, size_t fwlen)
 	return 0;
 
 fwdl_out:
+
+	CLEAR_MGMT_STATUS(iocp->ioctl_cmds.status);
+	SET_MGMT_MSG_CONTEXT(iocp->ioctl_cmds.msg_context, 0);
         kfree_sgl(sgl, sgl_dma, buflist, iocp);
 	return ret;
 }
@@ -1773,7 +1822,10 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
 	int		msgContext;
 	u16		req_idx;
 	ulong 		timeout;
+	unsigned long	timeleft;
 	struct scsi_device *sdev;
+	unsigned long	 flags;
+	u8		 function;
 
 	/* bufIn and bufOut are used for user to kernel space transfers
 	 */
@@ -1786,16 +1838,15 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
 				__FILE__, __LINE__, iocnum);
 		return -ENODEV;
 	}
-	if (!ioc->ioctl) {
-		printk(KERN_ERR MYNAM "%s@%d::mptctl_do_mpt_command - "
-			"No memory available during driver init.\n",
-				__FILE__, __LINE__);
-		return -ENOMEM;
-	} else if (ioc->ioctl->status & MPT_MGMT_STATUS_DID_IOCRESET) {
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
@@ -1829,10 +1880,12 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
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
@@ -1840,7 +1893,7 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
 	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "sending mpi function (0x%02X), req=%p\n",
 	    ioc->name, hdr->Function, mf));
 
-	switch (hdr->Function) {
+	switch (function) {
 	case MPI_FUNCTION_IOC_FACTS:
 	case MPI_FUNCTION_PORT_FACTS:
 		karg.dataOutSize  = karg.dataInSize = 0;
@@ -1937,8 +1990,6 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
 			pScsiReq->Control = cpu_to_le32(scsidir | qtag);
 			pScsiReq->DataLength = cpu_to_le32(dataSize);
 
-			ioc->ioctl->reset = MPTCTL_RESET_OK;
-			ioc->ioctl->id = pScsiReq->TargetID;
 
 		} else {
 			printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_do_mpt_command - "
@@ -2016,8 +2067,6 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
 			pScsiReq->Control = cpu_to_le32(scsidir | qtag);
 			pScsiReq->DataLength = cpu_to_le32(dataSize);
 
-			ioc->ioctl->reset = MPTCTL_RESET_OK;
-			ioc->ioctl->id = pScsiReq->TargetID;
 		} else {
 			printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_do_mpt_command - "
 				"SCSI driver is not loaded. \n",
@@ -2028,20 +2077,17 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
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
+		dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+			"\tTaskType=0x%x MsgFlags=0x%x "
+			"TaskMsgContext=0x%x id=%d channel=%d\n",
+			ioc->name, pScsiTm->TaskType, le32_to_cpu
+			(pScsiTm->TaskMsgContext), pScsiTm->MsgFlags,
+			pScsiTm->TargetID, pScsiTm->Bus));
 		break;
+	}
 
 	case MPI_FUNCTION_IOC_INIT:
 		{
@@ -2185,9 +2231,16 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
 		ioc->add_sge(psge, flagsLength, (dma_addr_t) -1);
 	}
 
-	ioc->ioctl->wait_done = 0;
+	SET_MGMT_MSG_CONTEXT(ioc->ioctl_cmds.msg_context, hdr->MsgContext);
+	INITIALIZE_MGMT_STATUS(ioc->ioctl_cmds.status)
 	if (hdr->Function == MPI_FUNCTION_SCSI_TASK_MGMT) {
 
+		mutex_lock(&ioc->taskmgmt_cmds.mutex);
+		if (mpt_set_taskmgmt_in_progress_flag(ioc) != 0) {
+			mutex_unlock(&ioc->taskmgmt_cmds.mutex);
+			goto done_free_mem;
+		}
+
 		DBG_DUMP_TM_REQUEST_FRAME(ioc, (u32 *)mf);
 
 		if ((ioc->facts.IOCCapabilities & MPI_IOCFACTS_CAPABILITY_HIGH_PRI_Q) &&
@@ -2198,10 +2251,11 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
 				sizeof(SCSITaskMgmt_t), (u32*)mf, CAN_SLEEP);
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
@@ -2211,36 +2265,47 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
 
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
+retry_wait:
+	timeleft = wait_for_completion_timeout(&ioc->ioctl_cmds.done,
+				HZ*timeout);
+	if (!(ioc->ioctl_cmds.status & MPT_MGMT_STATUS_COMMAND_GOOD)) {
+		rc = -ETIME;
+		dfailprintk(ioc, printk(MYIOC_s_ERR_FMT "%s: TIMED OUT!\n",
+		    ioc->name, __func__));
+		if (ioc->ioctl_cmds.status & MPT_MGMT_STATUS_DID_IOCRESET) {
+			if (function == MPI_FUNCTION_SCSI_TASK_MGMT)
+				mutex_unlock(&ioc->taskmgmt_cmds.mutex);
+			goto done_free_mem;
+		}
+		if (!timeleft) {
+			if (function == MPI_FUNCTION_SCSI_TASK_MGMT)
+				mutex_unlock(&ioc->taskmgmt_cmds.mutex);
+			mptctl_timeout_expired(ioc, mf);
+			mf = NULL;
+		} else
+			goto retry_wait;
 		goto done_free_mem;
 	}
 
+	if (function == MPI_FUNCTION_SCSI_TASK_MGMT)
+		mutex_unlock(&ioc->taskmgmt_cmds.mutex);
+
+
 	mf = NULL;
 
 	/* If a valid reply frame, copy to the user.
 	 * Offset 2: reply length in U32's
 	 */
-	if (ioc->ioctl->status & MPT_MGMT_STATUS_RF_VALID) {
+	if (ioc->ioctl_cmds.status & MPT_MGMT_STATUS_RF_VALID) {
 		if (karg.maxReplyBytes < ioc->reply_sz) {
-			 sz = min(karg.maxReplyBytes, 4*ioc->ioctl->ReplyFrame[2]);
+			sz = min(karg.maxReplyBytes,
+				4*ioc->ioctl_cmds.reply[2]);
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
@@ -2253,10 +2318,11 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
 
 	/* If valid sense data, copy to user.
 	 */
-	if (ioc->ioctl->status & MPT_MGMT_STATUS_SENSE_VALID) {
+	if (ioc->ioctl_cmds.status & MPT_MGMT_STATUS_SENSE_VALID) {
 		sz = min(karg.maxSenseBytes, MPT_SENSE_BUFFER_SIZE);
 		if (sz > 0) {
-			if (copy_to_user(karg.senseDataPtr, ioc->ioctl->sense, sz)) {
+			if (copy_to_user(karg.senseDataPtr,
+				ioc->ioctl_cmds.sense, sz)) {
 				printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_do_mpt_command - "
 				"Unable to write sense data to user %p\n",
 				ioc->name, __FILE__, __LINE__,
@@ -2270,7 +2336,7 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
 	/* If the overall status is _GOOD and data in, copy data
 	 * to user.
 	 */
-	if ((ioc->ioctl->status & MPT_MGMT_STATUS_COMMAND_GOOD) &&
+	if ((ioc->ioctl_cmds.status & MPT_MGMT_STATUS_COMMAND_GOOD) &&
 				(karg.dataInSize > 0) && (bufIn.kptr)) {
 
 		if (copy_to_user(karg.dataInBufPtr,
@@ -2285,9 +2351,8 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
 
 done_free_mem:
 
-	ioc->ioctl->status &= ~(MPT_MGMT_STATUS_COMMAND_GOOD |
-		MPT_MGMT_STATUS_SENSE_VALID |
-		MPT_MGMT_STATUS_RF_VALID );
+	CLEAR_MGMT_STATUS(ioc->ioctl_cmds.status)
+	SET_MGMT_MSG_CONTEXT(ioc->ioctl_cmds.msg_context, 0);
 
 	/* Free the allocated memory.
 	 */
@@ -2337,6 +2402,8 @@ mptctl_hp_hostinfo(unsigned long arg, unsigned int data_size)
 	ToolboxIstwiReadWriteRequest_t	*IstwiRWRequest;
 	MPT_FRAME_HDR		*mf = NULL;
 	MPIHeader_t		*mpi_hdr;
+	unsigned long		timeleft;
+	int			retval;
 
 	/* Reset long to int. Should affect IA64 and SPARC only
 	 */
@@ -2477,8 +2544,8 @@ mptctl_hp_hostinfo(unsigned long arg, unsigned int data_size)
 	 * Gather ISTWI(Industry Standard Two Wire Interface) Data
 	 */
 	if ((mf = mpt_get_msg_frame(mptctl_id, ioc)) == NULL) {
-		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT "%s, no msg frames!!\n",
-		    ioc->name,__func__));
+		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT
+			"%s, no msg frames!!\n", ioc->name, __func__));
 		goto out;
 	}
 
@@ -2502,19 +2569,26 @@ mptctl_hp_hostinfo(unsigned long arg, unsigned int data_size)
 	ioc->add_sge((char *)&IstwiRWRequest->SGL,
 	    (MPT_SGE_FLAGS_SSIMPLE_READ|4), buf_dma);
 
-	ioc->ioctl->wait_done = 0;
+	retval = 0;
+	SET_MGMT_MSG_CONTEXT(ioc->ioctl_cmds.msg_context,
+				IstwiRWRequest->MsgContext);
+	INITIALIZE_MGMT_STATUS(ioc->ioctl_cmds.status)
 	mpt_put_msg_frame(mptctl_id, ioc, mf);
 
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
+retry_wait:
+	timeleft = wait_for_completion_timeout(&ioc->ioctl_cmds.done,
+			HZ*MPT_IOCTL_DEFAULT_TIMEOUT);
+	if (!(ioc->ioctl_cmds.status & MPT_MGMT_STATUS_COMMAND_GOOD)) {
+		retval = -ETIME;
+		printk(MYIOC_s_WARN_FMT "%s: failed\n", ioc->name, __func__);
+		if (ioc->ioctl_cmds.status & MPT_MGMT_STATUS_DID_IOCRESET) {
+			mpt_free_msg_frame(ioc, mf);
+			goto out;
+		}
+		if (!timeleft)
+			mptctl_timeout_expired(ioc, mf);
+		else
+			goto retry_wait;
 		goto out;
 	}
 
@@ -2527,10 +2601,13 @@ mptctl_hp_hostinfo(unsigned long arg, unsigned int data_size)
 	 *   bays have drives in them
 	 * pbuf[3] = Checksum (0x100 = (byte0 + byte2 + byte3)
 	 */
-	if (ioc->ioctl->status & MPT_MGMT_STATUS_RF_VALID)
+	if (ioc->ioctl_cmds.status & MPT_MGMT_STATUS_RF_VALID)
 		karg.rsvd = *(u32 *)pbuf;
 
  out:
+	CLEAR_MGMT_STATUS(ioc->ioctl_cmds.status)
+	SET_MGMT_MSG_CONTEXT(ioc->ioctl_cmds.msg_context, 0);
+
 	if (pbuf)
 		pci_free_consistent(ioc->pcidev, 4, pbuf, buf_dma);
 
@@ -2754,7 +2831,7 @@ compat_mptfwxfer_ioctl(struct file *filp, unsigned int cmd,
 
 	ret = mptctl_do_fw_download(kfw.iocnum, kfw.bufp, kfw.fwlen);
 
-	mutex_unlock(&iocp->ioctl->ioctl_mutex);
+	mutex_unlock(&iocp->ioctl_cmds.mutex);
 
 	return ret;
 }
@@ -2808,7 +2885,7 @@ compat_mpt_command(struct file *filp, unsigned int cmd,
 	 */
 	ret = mptctl_do_mpt_command (karg, &uarg->MF);
 
-	mutex_unlock(&iocp->ioctl->ioctl_mutex);
+	mutex_unlock(&iocp->ioctl_cmds.mutex);
 
 	return ret;
 }
@@ -2860,21 +2937,10 @@ static long compat_mpctl_ioctl(struct file *f, unsigned int cmd, unsigned long a
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
-
-	ioc->ioctl = mem;
-	ioc->ioctl->ioc = ioc;
-	mutex_init(&ioc->ioctl->ioctl_mutex);
+	mutex_init(&ioc->ioctl_cmds.mutex);
+	init_completion(&ioc->ioctl_cmds.done);
 	return 0;
 }
 
@@ -2888,9 +2954,6 @@ mptctl_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 static void
 mptctl_remove(struct pci_dev *pdev)
 {
-	MPT_ADAPTER *ioc = pci_get_drvdata(pdev);
-
-	kfree ( ioc->ioctl );
 }
 
 static struct mpt_pci_driver mptctl_driver = {
@@ -2930,6 +2993,7 @@ static int __init mptctl_init(void)
 		goto out_fail;
 	}
 
+	mptctl_taskmgmt_id = mpt_register(mptctl_taskmgmt_reply, MPTCTL_DRIVER);
 	mpt_reset_register(mptctl_id, mptctl_ioc_reset);
 	mpt_event_register(mptctl_id, mptctl_event_process);
 
@@ -2954,6 +3018,7 @@ static void mptctl_exit(void)
 
 	/* De-register callback handler from base module */
 	mpt_deregister(mptctl_id);
+	mpt_reset_deregister(mptctl_taskmgmt_id);
 
         mpt_device_driver_deregister(MPTCTL_DRIVER);
 
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index a53b332..e61df13 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -1290,8 +1290,6 @@ mptfc_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	/* Clear the TM flags
 	 */
-	hd->tmPending = 0;
-	hd->tmState = TM_STATE_NONE;
 	hd->abortSCpnt = NULL;
 
 	/* Clear the pointer used to store
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 3efa728..0aecc13 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -553,6 +553,9 @@ mptsas_target_reset(MPT_ADAPTER *ioc, u8 channel, u8 id)
 {
 	MPT_FRAME_HDR	*mf;
 	SCSITaskMgmt_t	*pScsiTm;
+	if (mpt_set_taskmgmt_in_progress_flag(ioc) != 0)
+		return 0;
+
 
 	mf = mpt_get_msg_frame(mptsasDeviceResetCtx, ioc);
 	if (mf == NULL) {
@@ -719,9 +722,12 @@ mptsas_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 	if (!ev) {
 		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT "%s, failed to allocate mem @%d..!!\n",
 		    ioc->name,__func__, __LINE__));
-		return 0;
+		goto out_fail;
 	}
 
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "TaskMgmt request (mf=%p)\n",
+		ioc->name, mf));
+
 	INIT_WORK(&ev->work, mptsas_hotplug_work);
 	ev->ioc = ioc;
 	ev->handle = le16_to_cpu(sas_event_data->DevHandle);
@@ -734,10 +740,19 @@ mptsas_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 	    sizeof(__le64));
 	ev->sas_address = le64_to_cpu(sas_address);
 	ev->device_info = le32_to_cpu(sas_event_data->DeviceInfo);
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+	   "TaskMgmt type=%d (sas device delete) fw_channel = %d fw_id = %d)\n",
+	   ioc->name, MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET, channel, id));
+
 	ev->event_type = MPTSAS_DEL_DEVICE;
 	schedule_work(&ev->work);
 	kfree(target_reset_list);
 
+ out_fail:
+
+	mpt_clear_taskmgmt_in_progress_flag(ioc);
+	return 0;
+
 
 	/*
 	 * issue target reset to next device in the queue
@@ -3291,8 +3306,6 @@ mptsas_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	/* Clear the TM flags
 	 */
-	hd->tmPending = 0;
-	hd->tmState = TM_STATE_NONE;
 	hd->abortSCpnt = NULL;
 
 	/* Clear the pointer used to store
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index c19b0ee..483f333 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1895,8 +1895,6 @@ mptscsih_host_reset(struct scsi_cmnd *SCpnt)
 		 *  NONE.
 		 */
 		retval = 0;
-		hd->tmPending = 0;
-		hd->tmState = TM_STATE_NONE;
 	}
 
 	printk(MYIOC_s_INFO_FMT "host reset: %s (sc=%p)\n",
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index df30629..c9fa919 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -1474,8 +1474,6 @@ mptspi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	/* Clear the TM flags
 	 */
-	hd->tmPending = 0;
-	hd->tmState = TM_STATE_NONE;
 	hd->abortSCpnt = NULL;
 
 	/* Clear the pointer used to store
