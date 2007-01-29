From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 8/9] - fusion - error handling bug fix's
Date: Mon, 29 Jan 2007 09:47:47 -0700
Message-ID: <20070129164747.GA1923@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:60724 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbXA2QrM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Jan 2007 11:47:12 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

misc error handling bug fix's
- properly interpret iocstatus returned after task management request
- clear tmState after a failed doorbell
- cleanup mptscsih_taskmgmt_complete

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>

diff -uarpN b/drivers/message/fusion/mptbase.c a/drivers/message/fusion/mptbase.c
--- b/drivers/message/fusion/mptbase.c	2007-01-28 12:57:29.000000000 -0700
+++ a/drivers/message/fusion/mptbase.c	2007-01-28 12:57:29.000000000 -0700
@@ -916,7 +916,7 @@ mpt_add_sge(char *pAddr, u32 flagslength
 int
 mpt_send_handshake_request(int handle, MPT_ADAPTER *ioc, int reqBytes, u32 *req, int sleepFlag)
 {
-	int		 r = 0;
+	int	r = 0;
 	u8	*req_as_bytes;
 	int	 ii;
 
@@ -3219,6 +3219,9 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ign
 	u32 diag1val = 0;
 #endif
 
+	/* Clear any existing interrupts */
+	CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);
+
 	if (ioc->pcidev->device == MPI_MANUFACTPAGE_DEVID_SAS1078) {
 		drsprintk((MYIOC_s_WARN_FMT "%s: Doorbell=%p; 1078 reset "
 			"address=%p\n",  ioc->name, __FUNCTION__,
@@ -3238,7 +3241,7 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ign
 			        " count=%d\n",
 				ioc->name, doorbell, count));
 			if (doorbell == MPI_IOC_STATE_READY) {
-				return 0;
+				return 1;
 			}
 
 			/* wait 1 sec */
@@ -3250,9 +3253,6 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ign
 		return -1;
 	}
 
-	/* Clear any existing interrupts */
-	CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);
-
 	/* Use "Diagnostic reset" method! (only thing available!) */
 	diag0val = CHIPREG_READ32(&ioc->chip->Diagnostic);
 
@@ -3968,7 +3968,7 @@ WaitForDoorbellAck(MPT_ADAPTER *ioc, int
 		}
 	} else {
 		while (--cntdn) {
-			mdelay (1);
+			udelay (1000);
 			intstat = CHIPREG_READ32(&ioc->chip->IntStatus);
 			if (! (intstat & MPI_HIS_IOP_DOORBELL_STATUS))
 				break;
@@ -4020,7 +4020,7 @@ WaitForDoorbellInt(MPT_ADAPTER *ioc, int
 			intstat = CHIPREG_READ32(&ioc->chip->IntStatus);
 			if (intstat & MPI_HIS_DOORBELL_INTERRUPT)
 				break;
-			mdelay(1);
+			udelay (1000);
 			count++;
 		}
 	}
diff -uarpN b/drivers/message/fusion/mptctl.c a/drivers/message/fusion/mptctl.c
--- b/drivers/message/fusion/mptctl.c	2007-01-28 12:57:29.000000000 -0700
+++ a/drivers/message/fusion/mptctl.c	2007-01-28 12:57:29.000000000 -0700
@@ -313,7 +313,7 @@ static void mptctl_timeout_expired (MPT_
 		 */
 		dctlprintk((MYIOC_s_INFO_FMT "Calling HardReset! \n",
 			 ioctl->ioc->name));
-		mpt_HardResetHandler(ioctl->ioc, NO_SLEEP);
+		mpt_HardResetHandler(ioctl->ioc, CAN_SLEEP);
 	}
 	return;
 
diff -uarpN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2007-01-28 12:57:29.000000000 -0700
+++ a/drivers/message/fusion/mptscsih.c	2007-01-28 12:57:29.000000000 -0700
@@ -1535,7 +1535,7 @@ mptscsih_freeChainBuffers(MPT_ADAPTER *i
  */
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/*
+/**
  *	mptscsih_TMHandler - Generic handler for SCSI Task Management.
  *	Fall through to mpt_HardResetHandler if: not operational, too many
  *	failed TM requests or handshake failure.
@@ -1551,28 +1551,17 @@ mptscsih_freeChainBuffers(MPT_ADAPTER *i
  *	Remark: With old EH code, at most 1 SCSI TaskMgmt function per IOC
  *	will be active.
  *
- *	Returns 0 for SUCCESS or -1 if FAILED.
- */
+ *	Returns 0 for SUCCESS, or FAILED.
+ **/
 int
 mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int lun, int ctx2abort, ulong timeout)
 {
 	MPT_ADAPTER	*ioc;
 	int		 rc = -1;
-	int		 doTask = 1;
 	u32		 ioc_raw_state;
 	unsigned long	 flags;
 
-	/* If FW is being reloaded currently, return success to
-	 * the calling function.
-	 */
-	if (hd == NULL)
-		return 0;
-
 	ioc = hd->ioc;
-	if (ioc == NULL) {
-		printk(KERN_ERR MYNAM " TMHandler" " NULL ioc!\n");
-		return FAILED;
-	}
 	dtmprintk((MYIOC_s_INFO_FMT "TMHandler Entered!\n", ioc->name));
 
 	// SJR - CHECKME - Can we avoid this here?
@@ -1585,8 +1574,10 @@ mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8
 	spin_unlock_irqrestore(&ioc->diagLock, flags);
 
 	/*  Wait a fixed amount of time for the TM pending flag to be cleared.
-	 *  If we time out and not bus reset, then we return a FAILED status to the caller.
-	 *  The call to mptscsih_tm_pending_wait() will set the pending flag if we are
+	 *  If we time out and not bus reset, then we return a FAILED status
+	 *  to the caller.
+	 *  The call to mptscsih_tm_pending_wait() will set the pending flag
+	 *  if we are
 	 *  successful. Otherwise, reload the FW.
 	 */
 	if (mptscsih_tm_pending_wait(hd) == FAILED) {
@@ -1596,18 +1587,16 @@ mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8
 			   hd->ioc->name, hd->tmPending));
 			return FAILED;
 		} else if (type == MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET) {
-			dtmprintk((KERN_INFO MYNAM ": %s: TMHandler target reset: "
-			   "Timed out waiting for last TM (%d) to complete! \n",
-			   hd->ioc->name, hd->tmPending));
+			dtmprintk((KERN_INFO MYNAM ": %s: TMHandler target "
+				"reset: Timed out waiting for last TM (%d) "
+				"to complete! \n", hd->ioc->name,
+				hd->tmPending));
 			return FAILED;
 		} else if (type == MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS) {
 			dtmprintk((KERN_INFO MYNAM ": %s: TMHandler bus reset: "
 			   "Timed out waiting for last TM (%d) to complete! \n",
 			   hd->ioc->name, hd->tmPending));
-			if (hd->tmPending & (1 << MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS))
-				return FAILED;
-
-			doTask = 0;
+			return FAILED;
 		}
 	} else {
 		spin_lock_irqsave(&hd->ioc->FreeQlock, flags);
@@ -1615,47 +1604,40 @@ mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8
 		spin_unlock_irqrestore(&hd->ioc->FreeQlock, flags);
 	}
 
-	/* Is operational?
-	 */
 	ioc_raw_state = mpt_GetIocState(hd->ioc, 0);
 
-#ifdef MPT_DEBUG_RESET
 	if ((ioc_raw_state & MPI_IOC_STATE_MASK) != MPI_IOC_STATE_OPERATIONAL) {
 		printk(MYIOC_s_WARN_FMT
-			"TM Handler: IOC Not operational(0x%x)!\n",
-			hd->ioc->name, ioc_raw_state);
+			"TM Handler for type=%x: IOC Not operational (0x%x)!\n",
+			ioc->name, type, ioc_raw_state);
+		printk(KERN_WARNING " Issuing HardReset!!\n");
+		if (mpt_HardResetHandler(ioc, CAN_SLEEP) < 0)
+			printk((KERN_WARNING "TMHandler: HardReset "
+				"FAILED!!\n"));
+		return FAILED;
 	}
-#endif
-
-	if (doTask && ((ioc_raw_state & MPI_IOC_STATE_MASK) == MPI_IOC_STATE_OPERATIONAL)
-				&& !(ioc_raw_state & MPI_DOORBELL_ACTIVE)) {
 
-		/* Isse the Task Mgmt request.
-		 */
-		if (hd->hard_resets < -1)
-			hd->hard_resets++;
-		rc = mptscsih_IssueTaskMgmt(hd, type, channel, id, lun, ctx2abort, timeout);
-		if (rc) {
-			printk(MYIOC_s_INFO_FMT "Issue of TaskMgmt failed!\n", hd->ioc->name);
-		} else {
-			dtmprintk((MYIOC_s_INFO_FMT "Issue of TaskMgmt Successful!\n", hd->ioc->name));
-		}
+	if (ioc_raw_state & MPI_DOORBELL_ACTIVE) {
+		printk(MYIOC_s_WARN_FMT
+			"TM Handler for type=%x: ioc_state: "
+			"DOORBELL_ACTIVE (0x%x)!\n",
+			ioc->name, type, ioc_raw_state);
+		return FAILED;
 	}
 
-	/* Only fall through to the HRH if this is a bus reset
+	/* Isse the Task Mgmt request.
 	 */
-	if ((type == MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS) && (rc ||
-		ioc->reload_fw || (ioc->alt_ioc && ioc->alt_ioc->reload_fw))) {
-		dtmprintk((MYIOC_s_INFO_FMT "Calling HardReset! \n",
-			 hd->ioc->name));
-		rc = mpt_HardResetHandler(hd->ioc, CAN_SLEEP);
-	}
+	if (hd->hard_resets < -1)
+		hd->hard_resets++;
 
-	/*
-	 * Check IOCStatus from TM reply message
-	 */
-	 if (hd->tm_iocstatus != MPI_IOCSTATUS_SUCCESS)
-		rc = FAILED;
+	rc = mptscsih_IssueTaskMgmt(hd, type, channel, id, lun,
+	    ctx2abort, timeout);
+	if (rc)
+		printk(MYIOC_s_INFO_FMT "Issue of TaskMgmt failed!\n",
+		    hd->ioc->name);
+	else
+		dtmprintk((MYIOC_s_INFO_FMT "Issue of TaskMgmt Successful!\n",
+		       	hd->ioc->name));
 
 	dtmprintk((MYIOC_s_INFO_FMT "TMHandler rc = %d!\n", hd->ioc->name, rc));
 
@@ -1664,7 +1646,7 @@ mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8
 
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/*
+/**
  *	mptscsih_IssueTaskMgmt - Generic send Task Management function.
  *	@hd: Pointer to MPT_SCSI_HOST structure
  *	@type: Task Management type
@@ -1677,9 +1659,9 @@ mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8
  *
  *	Not all fields are meaningfull for all task types.
  *
- *	Returns 0 for SUCCESS, -999 for "no msg frames",
- *	else other non-zero value returned.
- */
+ *	Returns 0 for SUCCESS, or FAILED.
+ *
+ **/
 static int
 mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int lun, int ctx2abort, ulong timeout)
 {
@@ -1719,32 +1701,52 @@ mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd
 
 	pScsiTm->TaskMsgContext = ctx2abort;
 
-	dtmprintk((MYIOC_s_INFO_FMT "IssueTaskMgmt: ctx2abort (0x%08x) type=%d\n",
-			hd->ioc->name, ctx2abort, type));
+	dtmprintk((MYIOC_s_INFO_FMT "IssueTaskMgmt: ctx2abort (0x%08x) "
+		"type=%d\n", hd->ioc->name, ctx2abort, type));
 
 	DBG_DUMP_TM_REQUEST_FRAME((u32 *)pScsiTm);
 
 	if ((retval = mpt_send_handshake_request(hd->ioc->TaskCtx, hd->ioc,
-		sizeof(SCSITaskMgmt_t), (u32*)pScsiTm,
-		CAN_SLEEP)) != 0) {
-		dfailprintk((MYIOC_s_ERR_FMT "_send_handshake FAILED!"
-			" (hd %p, ioc %p, mf %p) \n", hd->ioc->name, hd,
-			hd->ioc, mf));
-		mpt_free_msg_frame(hd->ioc, mf);
-		return retval;
+		sizeof(SCSITaskMgmt_t), (u32*)pScsiTm, CAN_SLEEP)) != 0) {
+		dfailprintk((MYIOC_s_ERR_FMT "send_handshake FAILED!"
+			" (hd %p, ioc %p, mf %p, rc=%d) \n", hd->ioc->name, hd,
+			hd->ioc, mf, retval));
+		goto fail_out;
 	}
 
 	if(mptscsih_tm_wait_for_completion(hd, timeout) == FAILED) {
-		dfailprintk((MYIOC_s_ERR_FMT "_wait_for_completion FAILED!"
+		dfailprintk((MYIOC_s_ERR_FMT "task management request TIMED OUT!"
 			" (hd %p, ioc %p, mf %p) \n", hd->ioc->name, hd,
 			hd->ioc, mf));
-		mpt_free_msg_frame(hd->ioc, mf);
 		dtmprintk((MYIOC_s_INFO_FMT "Calling HardReset! \n",
 			 hd->ioc->name));
 		retval = mpt_HardResetHandler(hd->ioc, CAN_SLEEP);
+		dtmprintk((MYIOC_s_INFO_FMT "rc=%d \n",
+			 hd->ioc->name, retval));
+		goto fail_out;
 	}
 
+	/*
+	 * Handle success case, see if theres a non-zero ioc_status.
+	 */
+	if (hd->tm_iocstatus == MPI_IOCSTATUS_SUCCESS ||
+	   hd->tm_iocstatus == MPI_IOCSTATUS_SCSI_TASK_TERMINATED ||
+	   hd->tm_iocstatus == MPI_IOCSTATUS_SCSI_IOC_TERMINATED)
+		retval = 0;
+	else
+		retval = FAILED;
+
 	return retval;
+
+ fail_out:
+
+	/*
+	 * Free task managment mf, and corresponding tm flags
+	 */
+	mpt_free_msg_frame(hd->ioc, mf);
+	hd->tmPending = 0;
+	hd->tmState = TM_STATE_NONE;
+	return FAILED;
 }
 
 static int
@@ -1769,7 +1771,7 @@ mptscsih_get_tm_timeout(MPT_ADAPTER *ioc
  *	(linux scsi_host_template.eh_abort_handler routine)
  *
  *	Returns SUCCESS or FAILED.
- */
+ **/
 int
 mptscsih_abort(struct scsi_cmnd * SCpnt)
 {
@@ -1805,9 +1807,8 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 		return SUCCESS;
 	}
 
-	if (hd->resetPending) {
+	if (hd->resetPending)
 		return FAILED;
-	}
 
 	if (hd->timeouts < -1)
 		hd->timeouts++;
@@ -1834,9 +1835,8 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 		ctx2abort, mptscsih_get_tm_timeout(hd->ioc));
 
 	if (SCPNT_TO_LOOKUP_IDX(SCpnt) == scpnt_idx &&
-	    SCpnt->serial_number == sn) {
+	    SCpnt->serial_number == sn)
 		retval = FAILED;
-	}
 
 	printk (KERN_WARNING MYNAM ": %s: task abort: %s (sc=%p)\n",
 		hd->ioc->name,
@@ -1844,12 +1844,8 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 
 	if (retval == 0)
 		return SUCCESS;
-
-	if(retval != FAILED ) {
-		hd->tmPending = 0;
-		hd->tmState = TM_STATE_NONE;
-	}
-	return FAILED;
+	else
+		return FAILED;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -1860,7 +1856,7 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
  *	(linux scsi_host_template.eh_dev_reset_handler routine)
  *
  *	Returns SUCCESS or FAILED.
- */
+ **/
 int
 mptscsih_dev_reset(struct scsi_cmnd * SCpnt)
 {
@@ -1895,14 +1891,11 @@ mptscsih_dev_reset(struct scsi_cmnd * SC
 
 	if (retval == 0)
 		return SUCCESS;
-
-	if(retval != FAILED ) {
-		hd->tmPending = 0;
-		hd->tmState = TM_STATE_NONE;
-	}
-	return FAILED;
+	else
+		return FAILED;
 }
 
+
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mptscsih_bus_reset - Perform a SCSI BUS_RESET!	new_eh variant
@@ -1911,7 +1904,7 @@ mptscsih_dev_reset(struct scsi_cmnd * SC
  *	(linux scsi_host_template.eh_bus_reset_handler routine)
  *
  *	Returns SUCCESS or FAILED.
- */
+ **/
 int
 mptscsih_bus_reset(struct scsi_cmnd * SCpnt)
 {
@@ -1945,12 +1938,8 @@ mptscsih_bus_reset(struct scsi_cmnd * SC
 
 	if (retval == 0)
 		return SUCCESS;
-
-	if(retval != FAILED ) {
-		hd->tmPending = 0;
-		hd->tmState = TM_STATE_NONE;
-	}
-	return FAILED;
+	else
+		return FAILED;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -2033,7 +2022,6 @@ mptscsih_tm_pending_wait(MPT_SCSI_HOST *
 /**
  *	mptscsih_tm_wait_for_completion - wait for completion of TM task
  *	@hd: Pointer to MPT host structure.
- *	@timeout: timeout in seconds
  *
  *	Returns {SUCCESS,FAILED}.
  */
@@ -2107,7 +2095,7 @@ mptscsih_taskmgmt_response_code(MPT_ADAP
  *	load/init time via the mpt_register() API call.
  *
  *	Returns 1 indicating alloc'd request frame ptr should be freed.
- */
+ **/
 int
 mptscsih_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 {
@@ -2117,78 +2105,85 @@ mptscsih_taskmgmt_complete(MPT_ADAPTER *
 	unsigned long		 flags;
 	u16			 iocstatus;
 	u8			 tmType;
+	u32			 termination_count;
 
 	dtmprintk((MYIOC_s_WARN_FMT "TaskMgmt completed (mf=%p,mr=%p)\n",
-			ioc->name, mf, mr));
-	if (ioc->sh) {
-		/* Depending on the thread, a timer is activated for
-		 * the TM request.  Delete this timer on completion of TM.
-		 * Decrement count of outstanding TM requests.
-		 */
-		hd = (MPT_SCSI_HOST *)ioc->sh->hostdata;
-	} else {
-		dtmprintk((MYIOC_s_WARN_FMT "TaskMgmt Complete: NULL Scsi Host Ptr\n",
-			ioc->name));
+	    ioc->name, mf, mr));
+	if (!ioc->sh) {
+		dtmprintk((MYIOC_s_WARN_FMT
+		    "TaskMgmt Complete: NULL Scsi Host Ptr\n", ioc->name));
 		return 1;
 	}
 
 	if (mr == NULL) {
-		dtmprintk((MYIOC_s_WARN_FMT "ERROR! TaskMgmt Reply: NULL Request %p\n",
-			ioc->name, mf));
+		dtmprintk((MYIOC_s_WARN_FMT
+		    "ERROR! TaskMgmt Reply: NULL Request %p\n", ioc->name, mf));
 		return 1;
-	} else {
-		pScsiTmReply = (SCSITaskMgmtReply_t*)mr;
-		pScsiTmReq = (SCSITaskMgmt_t*)mf;
+	}
 
-		/* Figure out if this was ABORT_TASK, TARGET_RESET, or BUS_RESET! */
-		tmType = pScsiTmReq->TaskType;
+	hd = (MPT_SCSI_HOST *)ioc->sh->hostdata;
+	pScsiTmReply = (SCSITaskMgmtReply_t*)mr;
+	pScsiTmReq = (SCSITaskMgmt_t*)mf;
+	tmType = pScsiTmReq->TaskType;
+	iocstatus = le16_to_cpu(pScsiTmReply->IOCStatus) & MPI_IOCSTATUS_MASK;
+	termination_count = le32_to_cpu(pScsiTmReply->TerminationCount);
+
+	if (ioc->facts.MsgVersion >= MPI_VERSION_01_05 &&
+	    pScsiTmReply->ResponseCode)
+		mptscsih_taskmgmt_response_code(ioc,
+		    pScsiTmReply->ResponseCode);
+	DBG_DUMP_TM_REPLY_FRAME((u32 *)pScsiTmReply);
+
+#if defined(MPT_DEBUG_REPLY) || defined(MPT_DEBUG_TM)
+	printk("%s: ha=%d [%d:%d:0] task_type=0x%02X "
+	    "iocstatus=0x%04X\n\tloginfo=0x%08X response_code=0x%02X "
+	    "term_cmnds=%d\n", __FUNCTION__, ioc->id, pScsiTmReply->Bus,
+	    pScsiTmReply->TargetID, pScsiTmReq->TaskType,
+	    le16_to_cpu(pScsiTmReply->IOCStatus),
+	    le32_to_cpu(pScsiTmReply->IOCLogInfo),pScsiTmReply->ResponseCode,
+	    le32_to_cpu(pScsiTmReply->TerminationCount));
+#endif
+	if (!iocstatus) {
+		dtmprintk((MYIOC_s_WARN_FMT " TaskMgmt SUCCESS\n", ioc->name));
+			hd->abortSCpnt = NULL;
+		goto out;
+	}
 
-		if (ioc->facts.MsgVersion >= MPI_VERSION_01_05 &&
-		    pScsiTmReply->ResponseCode)
-			mptscsih_taskmgmt_response_code(ioc,
-			    pScsiTmReply->ResponseCode);
-
-		dtmprintk((MYIOC_s_WARN_FMT "  TaskType = %d, TerminationCount=%d\n",
-				ioc->name, tmType, le32_to_cpu(pScsiTmReply->TerminationCount)));
-		DBG_DUMP_TM_REPLY_FRAME((u32 *)pScsiTmReply);
-
-		iocstatus = le16_to_cpu(pScsiTmReply->IOCStatus) & MPI_IOCSTATUS_MASK;
-		hd->tm_iocstatus = iocstatus;
-		dtmprintk((MYIOC_s_WARN_FMT "  SCSI TaskMgmt (%d) IOCStatus=%04x IOCLogInfo=%08x\n",
-			ioc->name, tmType, iocstatus, le32_to_cpu(pScsiTmReply->IOCLogInfo)));
-		/* Error?  (anything non-zero?) */
-		if (iocstatus) {
+	/* Error?  (anything non-zero?) */
 
-			/* clear flags and continue.
-			 */
-			if (tmType == MPI_SCSITASKMGMT_TASKTYPE_ABORT_TASK)
-				hd->abortSCpnt = NULL;
+	/* clear flags and continue.
+	 */
+	switch (tmType) {
 
-			/* If an internal command is present
-			 * or the TM failed - reload the FW.
-			 * FC FW may respond FAILED to an ABORT
-			 */
-			if (tmType == MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS) {
-				if ((hd->cmdPtr) ||
-				    (iocstatus == MPI_IOCSTATUS_SCSI_TASK_MGMT_FAILED)) {
-					if (mpt_HardResetHandler(ioc, NO_SLEEP) < 0) {
-						printk((KERN_WARNING
-							" Firmware Reload FAILED!!\n"));
-					}
-				}
-			}
-		} else {
-			dtmprintk((MYIOC_s_WARN_FMT " TaskMgmt SUCCESS\n", ioc->name));
+	case MPI_SCSITASKMGMT_TASKTYPE_ABORT_TASK:
+		if (termination_count == 1)
+			iocstatus = MPI_IOCSTATUS_SCSI_TASK_TERMINATED;
+		hd->abortSCpnt = NULL;
+		break;
 
-			hd->abortSCpnt = NULL;
+	case MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS:
 
-		}
+		/* If an internal command is present
+		 * or the TM failed - reload the FW.
+		 * FC FW may respond FAILED to an ABORT
+		 */
+		if (iocstatus == MPI_IOCSTATUS_SCSI_TASK_MGMT_FAILED ||
+		    hd->cmdPtr)
+			if (mpt_HardResetHandler(ioc, NO_SLEEP) < 0)
+				printk((KERN_WARNING " Firmware Reload FAILED!!\n"));
+		break;
+
+	case MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET:
+	default:
+		break;
 	}
 
+ out:
 	spin_lock_irqsave(&ioc->FreeQlock, flags);
 	hd->tmPending = 0;
-	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
 	hd->tmState = TM_STATE_NONE;
+	hd->tm_iocstatus = iocstatus;
+	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
 
 	return 1;
 }
