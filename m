From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 8/22] mpt fusion: RESEND [2.6.30-rc6] removed mptscsih_TMHandler, mptscsih_tm_pending_wait,mptscsih_tm_wait_for_completion
Date: Wed, 27 May 2009 18:01:53 +0530
Message-ID: <20090527123148.GI20010@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og124.obsmtp.com ([64.18.2.26]:33678 "EHLO
	exprod7og124.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760712AbZE0MxI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2009 08:53:08 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Three functions are removed.
mptscsih_TMHandler, mptscsih_tm_pending_wait and mptscsih_tm_wait_for_completion

---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 83eb2d6..39de69e 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -92,8 +92,6 @@ static int	mptscsih_AddSGE(MPT_ADAPTER *ioc, struct scsi_cmnd *SCpnt,
 				 SCSIIORequest_t *pReq, int req_idx);
 static void	mptscsih_freeChainBuffers(MPT_ADAPTER *ioc, int req_idx);
 static void	mptscsih_copy_sense_data(struct scsi_cmnd *sc, MPT_SCSI_HOST *hd, MPT_FRAME_HDR *mf, SCSIIOReply_t *pScsiReply);
-static int	mptscsih_tm_pending_wait(MPT_SCSI_HOST * hd);
-static int	mptscsih_tm_wait_for_completion(MPT_SCSI_HOST * hd, ulong timeout );
 
 static int	mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int lun, int ctx2abort, ulong timeout);
 
@@ -1471,120 +1469,6 @@ mptscsih_freeChainBuffers(MPT_ADAPTER *ioc, int req_idx)
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
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
- *	Note: With old EH code, at most 1 SCSI TaskMgmt function per IOC
- *	will be active.
- *
- *	Returns 0 for SUCCESS, or %FAILED.
- **/
-int
-mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int lun, int ctx2abort, ulong timeout)
-{
-	MPT_ADAPTER	*ioc;
-	int		 rc = -1;
-	u32		 ioc_raw_state;
-	unsigned long	 flags;
-
-	ioc = hd->ioc;
-	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "TMHandler Entered!\n", ioc->name));
-
-	// SJR - CHECKME - Can we avoid this here?
-	// (mpt_HardResetHandler has this check...)
-	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
-	if (ioc->ioc_reset_in_progress) {
-		spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
-		return FAILED;
-	}
-	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
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
-
-	ioc_raw_state = mpt_GetIocState(ioc, 0);
-
-	if ((ioc_raw_state & MPI_IOC_STATE_MASK) != MPI_IOC_STATE_OPERATIONAL) {
-		printk(MYIOC_s_WARN_FMT
-			"TM Handler for type=%x: IOC Not operational (0x%x)!\n",
-			ioc->name, type, ioc_raw_state);
-		printk(MYIOC_s_WARN_FMT " Issuing HardReset!!\n", ioc->name);
-		if (mpt_HardResetHandler(ioc, CAN_SLEEP) < 0)
-			printk(MYIOC_s_WARN_FMT "TMHandler: HardReset "
-			    "FAILED!!\n", ioc->name);
-		return FAILED;
-	}
-
-	if (ioc_raw_state & MPI_DOORBELL_ACTIVE) {
-		printk(MYIOC_s_WARN_FMT
-			"TM Handler for type=%x: ioc_state: "
-			"DOORBELL_ACTIVE (0x%x)!\n",
-			ioc->name, type, ioc_raw_state);
-		return FAILED;
-	}
-
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
  *	mptscsih_IssueTaskMgmt - Generic send Task Management function.
  *	@hd: Pointer to MPT_SCSI_HOST structure
  *	@type: Task Management type
@@ -2029,68 +1913,6 @@ mptscsih_host_reset(struct scsi_cmnd *SCpnt)
 	return retval;
 }
 
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
-	return status;
-}
-
-
 static int
 mptscsih_taskmgmt_reply(MPT_ADAPTER *ioc, u8 type,
 	SCSITaskMgmtReply_t *pScsiTmReply)
@@ -3406,6 +3228,5 @@ EXPORT_SYMBOL(mptscsih_event_process);
 EXPORT_SYMBOL(mptscsih_ioc_reset);
 EXPORT_SYMBOL(mptscsih_change_queue_depth);
 EXPORT_SYMBOL(mptscsih_timer_expired);
-EXPORT_SYMBOL(mptscsih_TMHandler);
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
