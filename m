From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 02/12] mptfusion: Updated SCSI IO IOCTL error handling.
Date: Thu, 18 Mar 2010 19:13:10 +0530
Message-ID: <20100318134259.GC22510@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:46818 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753821Ab0CROON (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Mar 2010 10:14:13 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Behavior changes only for IOCTLs that time out.
Current behavior of Bus Reset remains the same for RAID Passthru
Timeouts
Current behavior of Diagnostic reset for any other type of IOCTL
remains the same

CHANGE: For IOCTL SCSI IOs that timeout, a Target Reset TM is
sent, instead of Bus Reset. All error handing from that point is the same
as what the driver currently does, which is to say that if the Device Reset
TM fails it escalates do diagnostic reset.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index d0aa8fc..dc6b8f8 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -128,7 +128,6 @@ static MptSge_t *kbuf_alloc_2_sgl(int bytes, u32 dir, int sge_offset, int *frags
 		struct buflist **blp, dma_addr_t *sglbuf_dma, MPT_ADAPTER *ioc);
 static void kfree_sgl(MptSge_t *sgl, dma_addr_t sgl_dma,
 		struct buflist *buflist, MPT_ADAPTER *ioc);
-static int mptctl_bus_reset(MPT_ADAPTER *ioc, u8 function);
 
 /*
  * Reset Handler cleanup function
@@ -275,45 +274,6 @@ mptctl_reply(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req, MPT_FRAME_HDR *reply)
 	return 1;
 }
 
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/* mptctl_timeout_expired
- *
- * Expecting an interrupt, however timed out.
- *
- */
-static void
-mptctl_timeout_expired(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf)
-{
-	unsigned long flags;
-
-	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT ": %s\n",
-		ioc->name, __func__));
-
-	if (mpt_fwfault_debug)
-		mpt_halt_firmware(ioc);
-
-	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
-	if (ioc->ioc_reset_in_progress) {
-		spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
-		CLEAR_MGMT_PENDING_STATUS(ioc->ioctl_cmds.status)
-		mpt_free_msg_frame(ioc, mf);
-		return;
-	}
-	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
-
-
-	if (!mptctl_bus_reset(ioc, mf->u.hdr.Function))
-		return;
-
-	/* Issue a reset for this device.
-	 * The IOC is not responding.
-	 */
-	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Calling HardReset! \n",
-		 ioc->name));
-	CLEAR_MGMT_PENDING_STATUS(ioc->ioctl_cmds.status)
-	mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
-	mpt_free_msg_frame(ioc, mf);
-}
 
 static int
 mptctl_taskmgmt_reply(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
@@ -343,12 +303,8 @@ mptctl_taskmgmt_reply(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 	return 0;
 }
 
-/* mptctl_bus_reset
- *
- * Bus reset code.
- *
- */
-static int mptctl_bus_reset(MPT_ADAPTER *ioc, u8 function)
+static int
+mptctl_do_taskmgmt(MPT_ADAPTER *ioc, u8 tm_type, u8 bus_id, u8 target_id)
 {
 	MPT_FRAME_HDR	*mf;
 	SCSITaskMgmt_t	*pScsiTm;
@@ -359,13 +315,6 @@ static int mptctl_bus_reset(MPT_ADAPTER *ioc, u8 function)
 	unsigned long	 time_count;
 	u16		 iocstatus;
 
-	/* bus reset is only good for SCSI IO, RAID PASSTHRU */
-	if (!(function == MPI_FUNCTION_RAID_SCSI_IO_PASSTHROUGH ||
-		function == MPI_FUNCTION_SCSI_IO_REQUEST)) {
-		dtmprintk(ioc, printk(MYIOC_s_WARN_FMT
-			"TaskMgmt, not SCSI_IO!!\n", ioc->name));
-		return -EPERM;
-	}
 
 	mutex_lock(&ioc->taskmgmt_cmds.mutex);
 	if (mpt_set_taskmgmt_in_progress_flag(ioc) != 0) {
@@ -375,15 +324,14 @@ static int mptctl_bus_reset(MPT_ADAPTER *ioc, u8 function)
 
 	retval = 0;
 
-	/* Send request
-	 */
 	mf = mpt_get_msg_frame(mptctl_taskmgmt_id, ioc);
 	if (mf == NULL) {
-		dtmprintk(ioc, printk(MYIOC_s_WARN_FMT
-			"TaskMgmt, no msg frames!!\n", ioc->name));
+		dtmprintk(ioc,
+			printk(MYIOC_s_WARN_FMT "TaskMgmt, no msg frames!!\n",
+			ioc->name));
 		mpt_clear_taskmgmt_in_progress_flag(ioc);
 		retval = -ENOMEM;
-		goto mptctl_bus_reset_done;
+		goto tm_done;
 	}
 
 	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "TaskMgmt request (mf=%p)\n",
@@ -392,10 +340,13 @@ static int mptctl_bus_reset(MPT_ADAPTER *ioc, u8 function)
 	pScsiTm = (SCSITaskMgmt_t *) mf;
 	memset(pScsiTm, 0, sizeof(SCSITaskMgmt_t));
 	pScsiTm->Function = MPI_FUNCTION_SCSI_TASK_MGMT;
-	pScsiTm->TaskType = MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS;
-	pScsiTm->MsgFlags = MPI_SCSITASKMGMT_MSGFLAGS_LIPRESET_RESET_OPTION;
-	pScsiTm->TargetID = 0;
-	pScsiTm->Bus = 0;
+	pScsiTm->TaskType = tm_type;
+	if ((tm_type == MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS) &&
+		(ioc->bus_type == FC))
+		pScsiTm->MsgFlags =
+				MPI_SCSITASKMGMT_MSGFLAGS_LIPRESET_RESET_OPTION;
+	pScsiTm->TargetID = target_id;
+	pScsiTm->Bus = bus_id;
 	pScsiTm->ChainOffset = 0;
 	pScsiTm->Reserved = 0;
 	pScsiTm->Reserved1 = 0;
@@ -413,17 +364,16 @@ static int mptctl_bus_reset(MPT_ADAPTER *ioc, u8 function)
 		timeout = 30;
 		break;
 	case SPI:
-	default:
-		timeout = 2;
+		default:
+		timeout = 10;
 		break;
 	}
 
-	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-		"TaskMgmt type=%d timeout=%ld\n",
-		ioc->name, MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS, timeout));
+	dtmprintk(ioc,
+		printk(MYIOC_s_DEBUG_FMT "TaskMgmt type=%d timeout=%ld\n",
+		ioc->name, tm_type, timeout));
 
 	INITIALIZE_MGMT_STATUS(ioc->taskmgmt_cmds.status)
-	CLEAR_MGMT_STATUS(ioc->taskmgmt_cmds.status)
 	time_count = jiffies;
 	if ((ioc->facts.IOCCapabilities & MPI_IOCFACTS_CAPABILITY_HIGH_PRI_Q) &&
 	    (ioc->facts.MsgVersion >= MPI_VERSION_01_05))
@@ -432,17 +382,20 @@ static int mptctl_bus_reset(MPT_ADAPTER *ioc, u8 function)
 		retval = mpt_send_handshake_request(mptctl_taskmgmt_id, ioc,
 		    sizeof(SCSITaskMgmt_t), (u32 *)pScsiTm, CAN_SLEEP);
 		if (retval != 0) {
-			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
+			dfailprintk(ioc,
+				printk(MYIOC_s_ERR_FMT
 				"TaskMgmt send_handshake FAILED!"
 				" (ioc %p, mf %p, rc=%d) \n", ioc->name,
 				ioc, mf, retval));
+			mpt_free_msg_frame(ioc, mf);
 			mpt_clear_taskmgmt_in_progress_flag(ioc);
-			goto mptctl_bus_reset_done;
+			goto tm_done;
 		}
 	}
 
 	/* Now wait for the command to complete */
 	ii = wait_for_completion_timeout(&ioc->taskmgmt_cmds.done, timeout*HZ);
+
 	if (!(ioc->taskmgmt_cmds.status & MPT_MGMT_STATUS_COMMAND_GOOD)) {
 		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		    "TaskMgmt failed\n", ioc->name));
@@ -452,14 +405,14 @@ static int mptctl_bus_reset(MPT_ADAPTER *ioc, u8 function)
 			retval = 0;
 		else
 			retval = -1; /* return failure */
-		goto mptctl_bus_reset_done;
+		goto tm_done;
 	}
 
 	if (!(ioc->taskmgmt_cmds.status & MPT_MGMT_STATUS_RF_VALID)) {
 		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		    "TaskMgmt failed\n", ioc->name));
 		retval = -1; /* return failure */
-		goto mptctl_bus_reset_done;
+		goto tm_done;
 	}
 
 	pScsiTmReply = (SCSITaskMgmtReply_t *) ioc->taskmgmt_cmds.reply;
@@ -467,7 +420,7 @@ static int mptctl_bus_reset(MPT_ADAPTER *ioc, u8 function)
 	    "TaskMgmt fw_channel = %d, fw_id = %d, task_type=0x%02X, "
 	    "iocstatus=0x%04X\n\tloginfo=0x%08X, response_code=0x%02X, "
 	    "term_cmnds=%d\n", ioc->name, pScsiTmReply->Bus,
-	    pScsiTmReply->TargetID, MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,
+	    pScsiTmReply->TargetID, tm_type,
 	    le16_to_cpu(pScsiTmReply->IOCStatus),
 	    le32_to_cpu(pScsiTmReply->IOCLogInfo),
 	    pScsiTmReply->ResponseCode,
@@ -485,13 +438,71 @@ static int mptctl_bus_reset(MPT_ADAPTER *ioc, u8 function)
 		retval = -1; /* return failure */
 	}
 
-
- mptctl_bus_reset_done:
+ tm_done:
 	mutex_unlock(&ioc->taskmgmt_cmds.mutex);
 	CLEAR_MGMT_STATUS(ioc->taskmgmt_cmds.status)
 	return retval;
 }
 
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/* mptctl_timeout_expired
+ *
+ * Expecting an interrupt, however timed out.
+ *
+ */
+static void
+mptctl_timeout_expired(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf)
+{
+	unsigned long flags;
+	int ret_val = -1;
+	SCSIIORequest_t *scsi_req = (SCSIIORequest_t *) mf;
+	u8 function = mf->u.hdr.Function;
+
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT ": %s\n",
+		ioc->name, __func__));
+
+	if (mpt_fwfault_debug)
+		mpt_halt_firmware(ioc);
+
+	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
+	if (ioc->ioc_reset_in_progress) {
+		spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
+		CLEAR_MGMT_PENDING_STATUS(ioc->ioctl_cmds.status)
+		mpt_free_msg_frame(ioc, mf);
+		return;
+	}
+	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
+
+
+	CLEAR_MGMT_PENDING_STATUS(ioc->ioctl_cmds.status)
+
+	if (ioc->bus_type == SAS) {
+		if (function == MPI_FUNCTION_SCSI_IO_REQUEST)
+			ret_val = mptctl_do_taskmgmt(ioc,
+				MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
+				scsi_req->Bus, scsi_req->TargetID);
+		else if (function == MPI_FUNCTION_RAID_SCSI_IO_PASSTHROUGH)
+			ret_val = mptctl_do_taskmgmt(ioc,
+				MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,
+				scsi_req->Bus, 0);
+		if (!ret_val)
+			return;
+	} else {
+		if ((function == MPI_FUNCTION_SCSI_IO_REQUEST) ||
+			(function == MPI_FUNCTION_RAID_SCSI_IO_PASSTHROUGH))
+			ret_val = mptctl_do_taskmgmt(ioc,
+				MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,
+				scsi_req->Bus, 0);
+		if (!ret_val)
+			return;
+	}
+
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Calling Reset! \n",
+		 ioc->name));
+	mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
+	mpt_free_msg_frame(ioc, mf);
+}
+
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /* mptctl_ioc_reset
