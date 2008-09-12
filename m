From: Bernd Schubert <bs@q-leap.de>
Subject: [PATCH 3/5] fusion remove the TMHandler
Date: Fri, 12 Sep 2008 21:01:29 +0200
Message-ID: <200809122101.29534.bs@q-leap.de>
References: <200809122057.41565.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:41639 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754993AbYILTBe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Sep 2008 15:01:34 -0400
In-Reply-To: <200809122057.41565.bs@q-leap.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Eric Moore <Eric.Moore@lsi.com>, Sathya Prakash <Sathya.Prakash@lsi.com>

The mptscsih_TMHandler() seems to be redundant to mptscsih_IssueTaskMgmt().
Since there is no need to have two functions doing the same stuff, replace
all calls of mptscsih_TMHandler() by mptscsih_IssueTaskMgmt() and remove
mptscsih_TMHandler().

Signed-off-by: Bernd Schubert <bs@q-leap.de>

 drivers/message/fusion/mptscsih.c |  156 ----------------------------
 drivers/message/fusion/mptscsih.h |    2
 drivers/message/fusion/mptspi.c   |    2
 3 files changed, 6 insertions(+), 154 deletions(-)


Index: linux-2.6.26/drivers/message/fusion/mptscsih.c
===================================================================
--- linux-2.6.26.orig/drivers/message/fusion/mptscsih.c
+++ linux-2.6.26/drivers/message/fusion/mptscsih.c
@@ -92,11 +92,8 @@ static int	mptscsih_AddSGE(MPT_ADAPTER *
 				 SCSIIORequest_t *pReq, int req_idx);
 static void	mptscsih_freeChainBuffers(MPT_ADAPTER *ioc, int req_idx);
 static void	mptscsih_copy_sense_data(struct scsi_cmnd *sc, MPT_SCSI_HOST *hd, MPT_FRAME_HDR *mf, SCSIIOReply_t 
*pScsiReply);
-static int	mptscsih_tm_pending_wait(MPT_SCSI_HOST * hd);
 static int	mptscsih_tm_wait_for_completion(MPT_SCSI_HOST * hd, ulong timeout );
 
-static int	mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int lun, int ctx2abort, ulong 
timeout);
-
 int		mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);
 int		mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply);
 
@@ -1528,120 +1525,6 @@ mptscsih_freeChainBuffers(MPT_ADAPTER *i
 
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
-	if (ioc->hard_resets < -1)
-		ioc->hard_resets++;
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
@@ -1659,7 +1542,7 @@ mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8
  *	Returns 0 for SUCCESS, or FAILED.
  *
  **/
-static int
+int
 mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int lun, int ctx2abort, ulong timeout)
 {
 	MPT_FRAME_HDR	*mf;
@@ -1946,7 +1829,7 @@ mptscsih_dev_reset(struct scsi_cmnd * SC
 		goto out;
 	}
 
-	retval = mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
+	retval = mptscsih_IssueTaskMgmt(hd, MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
 	    vdevice->vtarget->channel, vdevice->vtarget->id, 0, 0,
 	    mptscsih_get_tm_timeout(ioc));
 
@@ -1995,7 +1878,7 @@ mptscsih_bus_reset(struct scsi_cmnd * SC
 		hd->timeouts++;
 
 	vdevice = SCpnt->device->hostdata;
-	retval = mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,
+	retval = mptscsih_IssueTaskMgmt(hd, MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,
 	    vdevice->vtarget->channel, 0, 0, 0, mptscsih_get_tm_timeout(ioc));
 
 	printk(MYIOC_s_INFO_FMT "bus reset: %s (sc=%p)\n",
@@ -2055,37 +1938,6 @@ mptscsih_host_reset(struct scsi_cmnd *SC
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
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
  *	mptscsih_tm_wait_for_completion - wait for completion of TM task
  *	@hd: Pointer to MPT host structure.
  *	@timeout: timeout value
@@ -3526,12 +3378,12 @@ EXPORT_SYMBOL(mptscsih_bus_reset);
 EXPORT_SYMBOL(mptscsih_host_reset);
 EXPORT_SYMBOL(mptscsih_bios_param);
 EXPORT_SYMBOL(mptscsih_io_done);
+EXPORT_SYMBOL(mptscsih_IssueTaskMgmt);
 EXPORT_SYMBOL(mptscsih_taskmgmt_complete);
 EXPORT_SYMBOL(mptscsih_scandv_complete);
 EXPORT_SYMBOL(mptscsih_event_process);
 EXPORT_SYMBOL(mptscsih_ioc_reset);
 EXPORT_SYMBOL(mptscsih_change_queue_depth);
 EXPORT_SYMBOL(mptscsih_timer_expired);
-EXPORT_SYMBOL(mptscsih_TMHandler);
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
Index: linux-2.6.26/drivers/message/fusion/mptscsih.h
===================================================================
--- linux-2.6.26.orig/drivers/message/fusion/mptscsih.h
+++ linux-2.6.26/drivers/message/fusion/mptscsih.h
@@ -120,13 +120,13 @@ extern int mptscsih_bus_reset(struct scs
 extern int mptscsih_host_reset(struct scsi_cmnd *SCpnt);
 extern int mptscsih_bios_param(struct scsi_device * sdev, struct block_device *bdev, sector_t capacity, int geom[]);
 extern int mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
+extern int mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int lun, int ctx2abort, ulong timeout);
 extern int mptscsih_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
 extern int mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
 extern int mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply);
 extern int mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);
 extern int mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth);
 extern void mptscsih_timer_expired(unsigned long data);
-extern int mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int lun, int ctx2abort, ulong timeout);
 extern u8 mptscsih_raid_id_to_num(MPT_ADAPTER *ioc, u8 channel, u8 id);
 extern int mptscsih_is_phys_disk(MPT_ADAPTER *ioc, u8 channel, u8 id);
 extern struct device_attribute *mptscsih_host_attrs[];
Index: linux-2.6.26/drivers/message/fusion/mptspi.c
===================================================================
--- linux-2.6.26.orig/drivers/message/fusion/mptspi.c
+++ linux-2.6.26/drivers/message/fusion/mptspi.c
@@ -1513,7 +1513,7 @@ mptspi_probe(struct pci_dev *pdev, const
 	 * issue internal bus reset
 	 */
 	if (ioc->spi_data.bus_reset)
-		mptscsih_TMHandler(hd,
+		mptscsih_IssueTaskMgmt(hd,
 		    MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,
 		    0, 0, 0, 0, 5);
 
