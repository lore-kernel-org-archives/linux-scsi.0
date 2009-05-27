From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 6/22] mpt fusion: RESEND [2.6.30-rc6] rewrite of all internal generated functions that issue commands to FW
Date: Wed, 27 May 2009 17:55:46 +0530
Message-ID: <20090527122539.GG20010@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og123.obsmtp.com ([64.18.2.24]:39743 "EHLO
	exprod7og123.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761030AbZE0MrH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2009 08:47:07 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

1) rewrite of all internal generated functions that issue commands to
firmware, porting them to be single threaded using the generic MPT_MGMT
struct. Implemented using completion Queue.
---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index e63a626..d8d5231 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1775,6 +1775,8 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init(&ioc->diagLock);
 	spin_lock_init(&ioc->initializing_hba_lock);
 
+	mutex_init(&ioc->internal_cmds.mutex);
+	init_completion(&ioc->internal_cmds.done);
 	mutex_init(&ioc->mptbase_cmds.mutex);
 	init_completion(&ioc->mptbase_cmds.done);
 
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 41273ff..4d77256 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -465,7 +465,9 @@ typedef struct _MPT_MGMT {
 	struct mutex		 mutex;
 	struct completion	 done;
 	u8			 reply[MPT_DEFAULT_FRAME_SIZE]; /* reply frame data */
+	u8			 sense[MPT_SENSE_BUFFER_ALLOC];
 	u8			 status;	/* current command status */
+	int			 completion_code;
 } MPT_MGMT;
 
 /*
@@ -709,6 +711,7 @@ typedef struct _MPT_ADAPTER
 	int			 sas_index; /* index refrencing */
 	MPT_MGMT		 sas_mgmt;
 	MPT_MGMT		 mptbase_cmds; /* for sending config pages */
+	MPT_MGMT		 internal_cmds;
 	struct work_struct	 sas_persist_task;
 
 	struct work_struct	 fc_setup_reset_work;
@@ -863,8 +866,6 @@ typedef struct _MPT_SCSI_HOST {
 	unsigned long		  timeouts;		/* cmd timeouts */
 	ushort			  sel_timeout[MPT_MAX_FC_DEVICES];
 	char 			  *info_kbuf;
-	wait_queue_head_t	  scandv_waitq;
-	int			  scandv_wait_done;
 	long			  last_queue_full;
 	u16			  tm_iocstatus;
 	u16			  spi_pending;
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index da16b47..d093871 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -1310,8 +1310,6 @@ mptfc_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	hd->timer.data = (unsigned long) hd;
 	hd->timer.function = mptscsih_timer_expired;
 
-	init_waitqueue_head(&hd->scandv_waitq);
-	hd->scandv_wait_done = 0;
 	hd->last_queue_full = 0;
 
 	sh->transportt = mptfc_transport_template;
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index dc23adf..16c4232 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -3282,8 +3282,6 @@ mptsas_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	ioc->sas_data.ptClear = mpt_pt_clear;
 
-	init_waitqueue_head(&hd->scandv_waitq);
-	hd->scandv_wait_done = 0;
 	hd->last_queue_full = 0;
 	INIT_LIST_HEAD(&hd->target_reset_list);
 	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 8c08c73..3517325 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -100,6 +100,8 @@ static int	mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id,
 int		mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);
 int		mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply);
 
+static int	mptscsih_get_completion_code(MPT_ADAPTER *ioc,
+		MPT_FRAME_HDR *req, MPT_FRAME_HDR *reply);
 int		mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
 static int	mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *iocmd);
 static void	mptscsih_synchronize_cache(MPT_SCSI_HOST *hd, VirtDevice *vdevice);
@@ -2571,94 +2573,35 @@ int
 mptscsih_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
 {
 	MPT_SCSI_HOST	*hd;
-	unsigned long	 flags;
-
-	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-	    ": IOC %s_reset routed to SCSI host driver!\n",
-	    ioc->name, reset_phase==MPT_IOC_SETUP_RESET ? "setup" : (
-	    reset_phase==MPT_IOC_PRE_RESET ? "pre" : "post")));
 
-	/* If a FW reload request arrives after base installed but
-	 * before all scsi hosts have been attached, then an alt_ioc
-	 * may have a NULL sh pointer.
-	 */
 	if (ioc->sh == NULL || shost_priv(ioc->sh) == NULL)
 		return 0;
-	else
-		hd = shost_priv(ioc->sh);
-
-	if (reset_phase == MPT_IOC_SETUP_RESET) {
-		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Setup-Diag Reset\n", ioc->name));
 
-		/* Clean Up:
-		 * 1. Set Hard Reset Pending Flag
-		 * All new commands go to doneQ
-		 */
+	hd = shost_priv(ioc->sh);
+	switch (reset_phase) {
+	case MPT_IOC_SETUP_RESET:
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "%s: MPT_IOC_SETUP_RESET\n", ioc->name, __func__));
 		hd->resetPending = 1;
-
-	} else if (reset_phase == MPT_IOC_PRE_RESET) {
-		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Pre-Diag Reset\n", ioc->name));
-
-		/* 2. Flush running commands
-		 *	Clean ScsiLookup (and associated memory)
-		 *	AND clean mytaskQ
-		 */
-
-		/* 2b. Reply to OS all known outstanding I/O commands.
-		 */
-		mptscsih_flush_running_cmds(hd);
-
-		/* 2c. If there was an internal command that
-		 * has not completed, configuration or io request,
-		 * free these resources.
-		 */
-		if (hd->cmdPtr) {
-			del_timer(&hd->timer);
-			mpt_free_msg_frame(ioc, hd->cmdPtr);
-		}
-
-		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Pre-Reset complete.\n", ioc->name));
-
-	} else {
-		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Post-Diag Reset\n", ioc->name));
-
-		/* Once a FW reload begins, all new OS commands are
-		 * redirected to the doneQ w/ a reset status.
-		 * Init all control structures.
-		 */
-
-		/* 2. Chain Buffer initialization
-		 */
-
-		/* 4. Renegotiate to all devices, if SPI
-		 */
-
-		/* 5. Enable new commands to be posted
-		 */
-		spin_lock_irqsave(&ioc->FreeQlock, flags);
-		hd->tmPending = 0;
-		spin_unlock_irqrestore(&ioc->FreeQlock, flags);
+		break;
+	case MPT_IOC_PRE_RESET:
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "%s: MPT_IOC_PRE_RESET\n", ioc->name, __func__));
 		hd->resetPending = 0;
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
+		mptscsih_flush_running_cmds(hd);
+		break;
+	case MPT_IOC_POST_RESET:
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "%s: MPT_IOC_POST_RESET\n", ioc->name, __func__));
+		if (ioc->internal_cmds.status & MPT_MGMT_STATUS_PENDING) {
+			ioc->internal_cmds.status |=
+				MPT_MGMT_STATUS_DID_IOCRESET;
+			complete(&ioc->internal_cmds.done);
 		}
-
-		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Post-Reset complete.\n", ioc->name));
-
+		break;
+	default:
+		break;
 	}
-
 	return 1;		/* currently means nothing really */
 }
 
@@ -2669,8 +2612,9 @@ mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply)
 	MPT_SCSI_HOST *hd;
 	u8 event = le32_to_cpu(pEvReply->Event) & 0xFF;
 
-	devtverboseprintk(ioc, printk(MYIOC_s_DEBUG_FMT "MPT event (=%02Xh) routed to SCSI host driver!\n",
-			ioc->name, event));
+	devtverboseprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		"MPT event (=%02Xh) routed to SCSI host driver!\n",
+		ioc->name, event));
 
 	if (ioc->sh == NULL ||
 		((hd = shost_priv(ioc->sh)) == NULL))
@@ -2711,8 +2655,9 @@ mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply)
 	case MPI_EVENT_STATE_CHANGE:			/* 02 */
 	case MPI_EVENT_EVENT_CHANGE:			/* 0A */
 	default:
-		dprintk(ioc, printk(MYIOC_s_DEBUG_FMT ": Ignoring event (=%02Xh)\n",
-		    ioc->name, event));
+		dprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+			": Ignoring event (=%02Xh)\n",
+			ioc->name, event));
 		break;
 	}
 
@@ -2745,153 +2690,44 @@ mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply)
  *	Used ONLY for DV and other internal commands.
  */
 int
-mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
+mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req,
+				MPT_FRAME_HDR *reply)
 {
-	MPT_SCSI_HOST	*hd;
 	SCSIIORequest_t *pReq;
-	int		 completionCode;
+	SCSIIOReply_t	*pReply;
+	u8		 cmd;
 	u16		 req_idx;
+	u8	*sense_data;
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
 
@@ -2940,6 +2776,95 @@ mptscsih_timer_expired(unsigned long data)
 	return;
 }
 
+/**
+ *	mptscsih_get_completion_code -
+ *	@ioc: Pointer to MPT_ADAPTER structure
+ *	@reply:
+ *	@cmd:
+ *
+ **/
+static int
+mptscsih_get_completion_code(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req,
+				MPT_FRAME_HDR *reply)
+{
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
+	    "IOCStatus=%04xh, SCSIState=%02xh, SCSIStatus=%02xh,"
+	    "IOCLogInfo=%08xh\n", ioc->name, status, pReply->SCSIState,
+	    scsi_status, le32_to_cpu(pReply->IOCLogInfo)));
+
+	switch (status) {
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
+	case MPI_IOCSTATUS_BUSY:
+	case MPI_IOCSTATUS_INSUFFICIENT_RESOURCES:
+		completion_code = MPT_SCANDV_BUSY;
+		break;
+
+	case MPI_IOCSTATUS_SCSI_DATA_UNDERRUN:		/* 0x0045 */
+	case MPI_IOCSTATUS_SCSI_RECOVERED_ERROR:	/* 0x0040 */
+	case MPI_IOCSTATUS_SUCCESS:			/* 0x0000 */
+		if (pReply->Function == MPI_FUNCTION_CONFIG) {
+			completion_code = MPT_SCANDV_GOOD;
+		} else if (pReply->Function == MPI_FUNCTION_RAID_ACTION) {
+			pr = (MpiRaidActionReply_t *)reply;
+			if (le16_to_cpu(pr->ActionStatus) ==
+				MPI_RAID_ACTION_ASTATUS_SUCCESS)
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
+		} else if (pReply->SCSIState & MPI_SCSI_STATE_NO_SCSI_STATUS)
+			completion_code = MPT_SCANDV_DID_RESET;
+		else if (pReply->SCSIState & MPI_SCSI_STATE_TERMINATED)
+			completion_code = MPT_SCANDV_DID_RESET;
+		else if (scsi_status == MPI_SCSI_STATUS_BUSY)
+			completion_code = MPT_SCANDV_BUSY;
+		else
+			completion_code = MPT_SCANDV_GOOD;
+		break;
+
+	case MPI_IOCSTATUS_SCSI_PROTOCOL_ERROR:		/* 0x0047 */
+		if (pReply->SCSIState & MPI_SCSI_STATE_TERMINATED)
+			completion_code = MPT_SCANDV_DID_RESET;
+		else
+			completion_code = MPT_SCANDV_SOME_ERROR;
+		break;
+	default:
+		completion_code = MPT_SCANDV_SOME_ERROR;
+		break;
+
+	}	/* switch(status) */
+
+	devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+	    "  completionCode set to %08xh\n", ioc->name, completion_code));
+	return completion_code;
+}
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
@@ -2966,22 +2891,17 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *io)
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
-
-	in_isr = in_interrupt();
-	if (in_isr) {
-		dprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Internal SCSI IO request not allowed in ISR context!\n",
-					ioc->name));
-		return -EPERM;
-	}
+	u8		 cmd = io->cmd;
+	MPT_ADAPTER *ioc = hd->ioc;
+	int		 ret = 0;
+	unsigned long	 timeleft;
+	unsigned long	 flags;
 
+	mutex_lock(&ioc->internal_cmds.mutex);
 
 	/* Set command specific information
 	 */
@@ -2991,13 +2911,13 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *io)
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
@@ -3005,7 +2925,7 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *io)
 		dir = MPI_SCSIIO_CONTROL_READ;
 		CDB[0] = cmd;
 		CDB[4] = 1;	/*Spin up the disk */
-		cmdTimeout = 15;
+		timeout = 15;
 		break;
 
 	case REQUEST_SENSE:
@@ -3013,7 +2933,7 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *io)
 		CDB[0] = cmd;
 		CDB[4] = io->size;
 		dir = MPI_SCSIIO_CONTROL_READ;
-		cmdTimeout = 10;
+		timeout = 10;
 		break;
 
 	case READ_BUFFER:
@@ -3032,7 +2952,7 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *io)
 		CDB[6] = (io->size >> 16) & 0xFF;
 		CDB[7] = (io->size >>  8) & 0xFF;
 		CDB[8] = io->size & 0xFF;
-		cmdTimeout = 10;
+		timeout = 10;
 		break;
 
 	case WRITE_BUFFER:
@@ -3047,21 +2967,21 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *io)
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
@@ -3069,20 +2989,23 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *io)
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
+		    ioc->name, __func__));
+		ret = MPT_SCANDV_BUSY;
+		goto out;
 	}
 
 	pScsiReq = (SCSIIORequest_t *) mf;
@@ -3120,74 +3043,58 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *io)
 
 	if (cmd == REQUEST_SENSE) {
 		pScsiReq->Control = cpu_to_le32(dir | MPI_SCSIIO_CONTROL_UNTAGGED);
-		ddvprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Untagged! 0x%2x\n",
-			ioc->name, cmd));
+		devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "%s: Untagged! 0x%02x\n", ioc->name, __func__, cmd));
 	}
 
-	for (ii=0; ii < 16; ii++)
+	for (ii = 0; ii < 16; ii++)
 		pScsiReq->CDB[ii] = CDB[ii];
 
 	pScsiReq->DataLength = cpu_to_le32(io->size);
 	pScsiReq->SenseBufferLowAddr = cpu_to_le32(ioc->sense_buf_low_dma
 					   + (my_idx * MPT_SENSE_BUFFER_ALLOC));
 
-	ddvprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Sending Command 0x%x for (%d:%d:%d)\n",
-			ioc->name, cmd, io->channel, io->id, io->lun));
+	devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+	    "%s: Sending Command 0x%02x for fw_channel=%d fw_id=%d lun=%d\n",
+	    ioc->name, __func__, cmd, io->channel, io->id, io->lun));
 
-	if (dir == MPI_SCSIIO_CONTROL_READ) {
+	if (dir == MPI_SCSIIO_CONTROL_READ)
 		ioc->add_sge((char *) &pScsiReq->SGL,
-			MPT_SGE_FLAGS_SSIMPLE_READ | io->size,
-			io->data_dma);
-	} else {
+		    MPT_SGE_FLAGS_SSIMPLE_READ | io->size, io->data_dma);
+	else
 		ioc->add_sge((char *) &pScsiReq->SGL,
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
+		    MPT_SGE_FLAGS_SSIMPLE_WRITE | io->size, io->data_dma);
 
-	/* Save cmd pointer, for resource free if timeout or
-	 * FW reload occurs
-	 */
-	hd->cmdPtr = mf;
-
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
+		ret = MPT_SCANDV_DID_RESET;
+		dfailprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "%s: TIMED OUT for cmd=0x%02x\n", ioc->name, __func__,
+		    cmd));
+		if (ioc->internal_cmds.status & MPT_MGMT_STATUS_DID_IOCRESET) {
+			mpt_free_msg_frame(ioc, mf);
+			goto out;
+		}
+		if (!timeleft) {
+			printk(MYIOC_s_WARN_FMT "Issuing Reset from %s!!\n",
+			    ioc->name, __func__);
+			mpt_HardResetHandler(ioc, CAN_SLEEP);
+			mpt_free_msg_frame(ioc, mf);
+		}
+		goto out;
 	}
 
-	return rc;
+	ret = ioc->internal_cmds.completion_code;
+	devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT "%s: success, rc=0x%02x\n",
+			ioc->name, __func__, ret));
+
+ out:
+	CLEAR_MGMT_STATUS(ioc->internal_cmds.status)
+	mutex_unlock(&ioc->internal_cmds.mutex);
+	return ret;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -3427,6 +3334,7 @@ struct device_attribute *mptscsih_host_attrs[] = {
 	&dev_attr_debug_level,
 	NULL,
 };
+
 EXPORT_SYMBOL(mptscsih_host_attrs);
 
 EXPORT_SYMBOL(mptscsih_remove);
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
index 319aa30..0b103a2 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -60,6 +60,7 @@
 #define MPT_SCANDV_SELECTION_TIMEOUT	(0x00000008)
 #define MPT_SCANDV_ISSUE_SENSE		(0x00000010)
 #define MPT_SCANDV_FALLBACK		(0x00000020)
+#define MPT_SCANDV_BUSY			(0x00000040)
 
 #define MPT_SCANDV_MAX_RETRIES		(10)
 
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 643a3c6..8f46fdf 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -614,19 +614,24 @@ static void mptspi_read_parameters(struct scsi_target *starget)
 	spi_width(starget) = (nego & MPI_SCSIDEVPAGE0_NP_WIDE) ? 1 : 0;
 }
 
-static int
+int
 mptscsih_quiesce_raid(MPT_SCSI_HOST *hd, int quiesce, u8 channel, u8 id)
 {
+	MPT_ADAPTER	*ioc = hd->ioc;
 	MpiRaidActionRequest_t	*pReq;
 	MPT_FRAME_HDR		*mf;
-	MPT_ADAPTER *ioc = hd->ioc;
+	int			ret;
+	unsigned long 	 	timeleft;
+
+	mutex_lock(&ioc->internal_cmds.mutex);
 
 	/* Get and Populate a free Frame
 	 */
 	if ((mf = mpt_get_msg_frame(ioc->InternalCtx, ioc)) == NULL) {
-		ddvprintk(ioc, printk(MYIOC_s_WARN_FMT "_do_raid: no msg frames!\n",
-					ioc->name));
-		return -EAGAIN;
+		dfailprintk(hd->ioc, printk(MYIOC_s_WARN_FMT
+			"%s: no msg frames!\n", ioc->name, __func__));
+		ret = -EAGAIN;
+		goto out;
 	}
 	pReq = (MpiRaidActionRequest_t *)mf;
 	if (quiesce)
@@ -649,23 +654,30 @@ mptscsih_quiesce_raid(MPT_SCSI_HOST *hd, int quiesce, u8 channel, u8 id)
 	ddvprintk(ioc, printk(MYIOC_s_DEBUG_FMT "RAID Volume action=%x channel=%d id=%d\n",
 			ioc->name, pReq->Action, channel, id));
 
-	hd->pLocal = NULL;
-	hd->timer.expires = jiffies + HZ*10; /* 10 second timeout */
-	hd->scandv_wait_done = 0;
-
-	/* Save cmd pointer, for resource free if timeout or
-	 * FW reload occurs
-	 */
-	hd->cmdPtr = mf;
-
-	add_timer(&hd->timer);
+	INITIALIZE_MGMT_STATUS(ioc->internal_cmds.status)
 	mpt_put_msg_frame(ioc->InternalCtx, ioc, mf);
-	wait_event(hd->scandv_waitq, hd->scandv_wait_done);
+	timeleft = wait_for_completion_timeout(&ioc->internal_cmds.done, 10*HZ);
+	if (!(ioc->internal_cmds.status & MPT_MGMT_STATUS_COMMAND_GOOD)) {
+		ret = -ETIME;
+		dfailprintk(ioc, printk(MYIOC_s_DEBUG_FMT "%s: TIMED OUT!\n",
+		    ioc->name, __func__));
+		if (ioc->internal_cmds.status & MPT_MGMT_STATUS_DID_IOCRESET)
+			goto out;
+		if (!timeleft) {
+			printk(MYIOC_s_WARN_FMT "Issuing Reset from %s!!\n",
+			    ioc->name, __func__);
+			mpt_HardResetHandler(ioc, CAN_SLEEP);
+			mpt_free_msg_frame(ioc, mf);
+		}
+		goto out;
+	}
 
-	if ((hd->pLocal == NULL) || (hd->pLocal->completion != 0))
-		return -1;
+	ret = ioc->internal_cmds.completion_code;
 
-	return 0;
+ out:
+	CLEAR_MGMT_STATUS(ioc->internal_cmds.status)
+	mutex_unlock(&ioc->internal_cmds.mutex);
+	return ret;
 }
 
 static void mptspi_dv_device(struct _MPT_SCSI_HOST *hd,
@@ -1491,8 +1503,6 @@ mptspi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		mpt_saf_te));
 	ioc->spi_data.noQas = 0;
 
-	init_waitqueue_head(&hd->scandv_waitq);
-	hd->scandv_wait_done = 0;
 	hd->last_queue_full = 0;
 	hd->spi_pending = 0;
 
