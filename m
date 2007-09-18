From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 9/9] mpt fusion: error recovery improvements, and synchronizing internal commands
Date: Mon, 17 Sep 2007 20:02:30 -0600
Message-ID: <20070918020230.GA22781@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:62149 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753310AbXIRCLQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Sep 2007 22:11:16 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

1) move mptscsih_quiesce_raid over to mptscsih.c
2) cleanup ioc_reset callback handlers, introducing wrappers for synchronizing error recovery (mpt_set_taskmgmt_in_progress_flag, mpt_clear_taskmgmt_in_progress_flag), as the fusion firmware only handles one task management request at a time.


Signed-off-by: Eric Moore <Eric.Moore@lsi.com>

--- b/drivers/message/fusion/mptspi.c	2007-09-17 16:35:27.000000000 -0600
+++ a/drivers/message/fusion/mptspi.c	2007-09-17 15:05:33.000000000 -0600
@@ -613,60 +613,6 @@ static void mptspi_read_parameters(struc
 	spi_width(starget) = (nego & MPI_SCSIDEVPAGE0_NP_WIDE) ? 1 : 0;
 }
 
-static int
-mptscsih_quiesce_raid(MPT_SCSI_HOST *hd, int quiesce, u8 channel, u8 id)
-{
-	MpiRaidActionRequest_t	*pReq;
-	MPT_FRAME_HDR		*mf;
-	MPT_ADAPTER *ioc = hd->ioc;
-
-	/* Get and Populate a free Frame
-	 */
-	if ((mf = mpt_get_msg_frame(ioc->InternalCtx, ioc)) == NULL) {
-		ddvprintk(ioc, printk(MYIOC_s_WARN_FMT "_do_raid: no msg frames!\n",
-					ioc->name));
-		return -EAGAIN;
-	}
-	pReq = (MpiRaidActionRequest_t *)mf;
-	if (quiesce)
-		pReq->Action = MPI_RAID_ACTION_QUIESCE_PHYS_IO;
-	else
-		pReq->Action = MPI_RAID_ACTION_ENABLE_PHYS_IO;
-	pReq->Reserved1 = 0;
-	pReq->ChainOffset = 0;
-	pReq->Function = MPI_FUNCTION_RAID_ACTION;
-	pReq->VolumeID = id;
-	pReq->VolumeBus = channel;
-	pReq->PhysDiskNum = 0;
-	pReq->MsgFlags = 0;
-	pReq->Reserved2 = 0;
-	pReq->ActionDataWord = 0; /* Reserved for this action */
-
-	mpt_add_sge((char *)&pReq->ActionDataSGE,
-		MPT_SGE_FLAGS_SSIMPLE_READ | 0, (dma_addr_t) -1);
-
-	ddvprintk(ioc, printk(MYIOC_s_DEBUG_FMT "RAID Volume action=%x channel=%d id=%d\n",
-			ioc->name, pReq->Action, channel, id));
-
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
-	mpt_put_msg_frame(ioc->InternalCtx, ioc, mf);
-	wait_event(hd->scandv_waitq, hd->scandv_wait_done);
-
-	if ((hd->pLocal == NULL) || (hd->pLocal->completion != 0))
-		return -1;
-
-	return 0;
-}
-
 static void mptspi_dv_device(struct _MPT_SCSI_HOST *hd,
 			     struct scsi_device *sdev)
 {
@@ -1266,14 +1212,20 @@ mptspi_dv_renegotiate(struct _MPT_SCSI_H
 static int
 mptspi_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
 {
-	struct _MPT_SCSI_HOST *hd = shost_priv(ioc->sh);
+	struct _MPT_SCSI_HOST *hd = NULL;
 	int rc;
 
 	rc = mptscsih_ioc_reset(ioc, reset_phase);
+	if ((ioc->bus_type != SPI) || (!rc))
+		goto out;
 
-	if (reset_phase == MPT_IOC_POST_RESET)
-		mptspi_dv_renegotiate(hd);
+	hd = shost_priv(ioc->sh);
+	if (!hd->ioc)
+		goto out;
 
+	if (ioc->active && reset_phase == MPT_IOC_POST_RESET)
+		mptspi_dv_renegotiate(hd);
+ out:
 	return rc;
 }
 
@@ -1456,39 +1408,11 @@ mptspi_probe(struct pci_dev *pdev, const
 	dprintk(ioc, printk(MYIOC_s_DEBUG_FMT "ScsiLookup @ %p\n",
 		 ioc->name, ioc->ScsiLookup));
 
-	/* Clear the TM flags
-	 */
-	hd->tmPending = 0;
-	hd->tmState = TM_STATE_NONE;
-	hd->resetPending = 0;
-	hd->abortSCpnt = NULL;
-
-	/* Clear the pointer used to store
-	 * single-threaded commands, i.e., those
-	 * issued during a bus scan, dv and
-	 * configuration pages.
-	 */
-	hd->cmdPtr = NULL;
-
-	/* Initialize this SCSI Hosts' timers
-	 * To use, set the timer expires field
-	 * and add_timer
-	 */
-	init_timer(&hd->timer);
-	hd->timer.data = (unsigned long) hd;
-	hd->timer.function = mptscsih_timer_expired;
-
 	ioc->spi_data.Saf_Te = mpt_saf_te;
-
-	hd->negoNvram = MPT_SCSICFG_USE_NVRAM;
 	ddvprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-		"saf_te %x\n",
-		ioc->name,
-		mpt_saf_te));
+	    "saf_te %x\n", ioc->name, mpt_saf_te));
 	ioc->spi_data.noQas = 0;
 
-	init_waitqueue_head(&hd->scandv_waitq);
-	hd->scandv_wait_done = 0;
 	hd->last_queue_full = 0;
 	hd->spi_pending = 0;
 
@@ -1508,7 +1432,7 @@ mptspi_probe(struct pci_dev *pdev, const
 	 * issue internal bus reset
 	 */
 	if (ioc->spi_data.bus_reset)
-		mptscsih_TMHandler(hd,
+		mptscsih_IssueTaskMgmt(hd,
 		    MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,
 		    0, 0, 0, 0, 5);
 
