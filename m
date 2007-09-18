From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 7/9] mpt fusion: error recovery improvements, and synchronizing internal commands
Date: Mon, 17 Sep 2007 20:00:35 -0600
Message-ID: <20070918020035.GA22747@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:62060 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553AbXIRCJW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Sep 2007 22:09:22 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

1) cleanup ioc_reset callback handlers, introducing wrappers for synronizing error recovery (mpt_set_taskmgmt_in_progress_flag, mpt_clear_taskmgmt_in_progress_flag), as the fusion firmware only handles one task management request at a time.
2) rewrite of all internal generated functions that issue commands to firmware, porting them to be single threaded using the generic MPT_MGMT struct.

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>

--- b/drivers/message/fusion/mptsas.c	2007-09-17 16:35:06.000000000 -0600
+++ a/drivers/message/fusion/mptsas.c	2007-09-17 19:35:03.000000000 -0600
@@ -600,12 +600,12 @@ mptsas_target_reset_queue(MPT_ADAPTER *i
 		sizeof(*sas_event_data));
 	list_add_tail(&target_reset_list->list, &hd->target_reset_list);
 
-	if (hd->resetPending)
+	if (ioc->ioc_reset_in_progress)
 		return;
 
 	if (mptsas_target_reset(ioc, channel, id)) {
 		target_reset_list->target_reset_issued = 1;
-		hd->resetPending = 1;
+		ioc->ioc_reset_in_progress = 1;
 	}
 }
 
@@ -638,7 +638,7 @@ mptsas_dev_reset_complete(MPT_ADAPTER *i
 	sas_event_data = &target_reset_list->sas_event_data;
 	id = sas_event_data->TargetID;
 	channel = sas_event_data->Bus;
-	hd->resetPending = 0;
+	ioc->ioc_reset_in_progress = 0;
 
 	/*
 	 * retry target reset
@@ -646,7 +646,7 @@ mptsas_dev_reset_complete(MPT_ADAPTER *i
 	if (!target_reset_list->target_reset_issued) {
 		if (mptsas_target_reset(ioc, channel, id)) {
 			target_reset_list->target_reset_issued = 1;
-			hd->resetPending = 1;
+			ioc->ioc_reset_in_progress = 1;
 		}
 		return;
 	}
@@ -696,7 +696,7 @@ mptsas_dev_reset_complete(MPT_ADAPTER *i
 
 	if (mptsas_target_reset(ioc, channel, id)) {
 		target_reset_list->target_reset_issued = 1;
-		hd->resetPending = 1;
+		ioc->ioc_reset_in_progress = 1;
 	}
 }
 
@@ -716,41 +716,56 @@ mptsas_taskmgmt_complete(MPT_ADAPTER *io
 }
 
 /**
- * mptscsih_ioc_reset
- *
- * @ioc
- * @reset_phase
+ *	mptsas_ioc_reset -
+ *	@ioc: Pointer to MPT_ADAPTER structure
+ *	@reset_phase:
  *
  **/
 static int
 mptsas_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
 {
-	MPT_SCSI_HOST	*hd;
+	MPT_SCSI_HOST   *hd;
 	struct mptsas_target_reset_event *target_reset_list, *n;
 	int rc;
 
 	rc = mptscsih_ioc_reset(ioc, reset_phase);
+	if ((ioc->bus_type != SAS) || (!rc))
+		return rc;
 
-	if (ioc->bus_type != SAS)
-		goto out;
-
-	if (reset_phase != MPT_IOC_POST_RESET)
-		goto out;
-
-	if (!ioc->sh || !ioc->sh->hostdata)
-		goto out;
-	hd = shost_priv(ioc->sh);
-	if (!hd->ioc)
-		goto out;
-
-	if (list_empty(&hd->target_reset_list))
-		goto out;
-
-	/* flush the target_reset_list */
-	list_for_each_entry_safe(target_reset_list, n,
-	    &hd->target_reset_list, list) {
-		list_del(&target_reset_list->list);
-		kfree(target_reset_list);
+	switch(reset_phase) {
+	case MPT_IOC_SETUP_RESET:
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "%s: MPT_IOC_SETUP_RESET\n", ioc->name, __FUNCTION__));
+		break;
+	case MPT_IOC_PRE_RESET:
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "%s: MPT_IOC_PRE_RESET\n", ioc->name, __FUNCTION__));
+		break;
+	case MPT_IOC_POST_RESET:
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "%s: MPT_IOC_POST_RESET\n", ioc->name, __FUNCTION__));
+		if (ioc->sas_mgmt.status & MPT_MGMT_STATUS_PENDING) {
+			ioc->sas_mgmt.status |= MPT_MGMT_STATUS_DID_IOCRESET;
+			complete(&ioc->sas_mgmt.done);
+		}
+		hd = shost_priv(ioc->sh);
+		if (!hd->ioc)
+			goto out;
+		if (list_empty(&hd->target_reset_list))
+			break;
+		/* flush the target_reset_list */
+		list_for_each_entry_safe(target_reset_list, n,
+		    &hd->target_reset_list, list) {
+			dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+			    "%s: removing target reset for id=%d\n",
+			    ioc->name, __FUNCTION__,
+			    target_reset_list->sas_event_data.TargetID));
+			list_del(&target_reset_list->list);
+			kfree(target_reset_list);
+		}
+		break;
+	default:
+		break;
 	}
 
  out:
@@ -861,9 +876,14 @@ mptsas_target_alloc(struct scsi_target *
 	 * RAID volumes placed beyond the last expected port.
 	 */
 	if (starget->channel == MPTSAS_RAID_CHANNEL) {
+		if (!ioc->raid_data.pIocPg2) {
+			kfree(vtarget);
+			return -ENXIO;
+		}
 		for (i=0; i < ioc->raid_data.pIocPg2->NumActiveVolumes; i++)
 			if (id == ioc->raid_data.pIocPg2->RaidVolume[i].VolumeID)
 				channel = ioc->raid_data.pIocPg2->RaidVolume[i].VolumeBus;
+		vtarget->raidVolume = 1;
 		goto out;
 	}
 
@@ -1100,14 +1120,19 @@ static int mptsas_get_linkerrors(struct 
 static int mptsas_mgmt_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req,
 		MPT_FRAME_HDR *reply)
 {
-	ioc->sas_mgmt.status |= MPT_SAS_MGMT_STATUS_COMMAND_GOOD;
+	ioc->sas_mgmt.status |= MPT_MGMT_STATUS_COMMAND_GOOD;
 	if (reply != NULL) {
-		ioc->sas_mgmt.status |= MPT_SAS_MGMT_STATUS_RF_VALID;
+		ioc->sas_mgmt.status |= MPT_MGMT_STATUS_RF_VALID;
 		memcpy(ioc->sas_mgmt.reply, reply,
 		    min(ioc->reply_sz, 4 * reply->u.reply.MsgLength));
 	}
-	complete(&ioc->sas_mgmt.done);
-	return 1;
+
+	if (ioc->sas_mgmt.status & MPT_MGMT_STATUS_PENDING) {
+		ioc->sas_mgmt.status &= ~MPT_MGMT_STATUS_PENDING;
+		complete(&ioc->sas_mgmt.done);
+		return 1;
+	}
+	return 0;
 }
 
 static int mptsas_phy_reset(struct sas_phy *phy, int hard_reset)
@@ -1146,21 +1171,24 @@ static int mptsas_phy_reset(struct sas_p
 		MPI_SAS_OP_PHY_HARD_RESET : MPI_SAS_OP_PHY_LINK_RESET;
 	req->PhyNum = phy->identify.phy_identifier;
 
+	INITIALIZE_MGMT_STATUS(ioc->sas_mgmt.status)
 	mpt_put_msg_frame(mptsasMgmtCtx, ioc, mf);
-
-	timeleft = wait_for_completion_timeout(&ioc->sas_mgmt.done,
-			10 * HZ);
-	if (!timeleft) {
-		/* On timeout reset the board */
+	timeleft = wait_for_completion_timeout(&ioc->sas_mgmt.done, 10*HZ);
+	if (!(ioc->sas_mgmt.status & MPT_MGMT_STATUS_COMMAND_GOOD)) {
+		error = -ETIME;
 		mpt_free_msg_frame(ioc, mf);
-		mpt_HardResetHandler(ioc, CAN_SLEEP);
-		error = -ETIMEDOUT;
+		if (ioc->sas_mgmt.status & MPT_MGMT_STATUS_DID_IOCRESET)
+			goto out;
+		if (!timeleft) {
+			if (mpt_SoftResetHandler(ioc, CAN_SLEEP) != 0)
+				mpt_HardResetHandler(ioc, CAN_SLEEP);
+		}
 		goto out_unlock;
 	}
 
 	/* a reply frame is expected */
 	if ((ioc->sas_mgmt.status &
-	    MPT_IOCTL_STATUS_RF_VALID) == 0) {
+	    MPT_MGMT_STATUS_RF_VALID) == 0) {
 		error = -ENXIO;
 		goto out_unlock;
 	}
@@ -1177,6 +1205,7 @@ static int mptsas_phy_reset(struct sas_p
 	error = 0;
 
  out_unlock:
+	CLEAR_MGMT_STATUS(ioc->sas_mgmt.status)
 	mutex_unlock(&ioc->sas_mgmt.mutex);
  out:
 	return error;
@@ -1325,19 +1354,24 @@ static int mptsas_smp_handler(struct Scs
 		goto unmap;
 	mpt_add_sge(psge, flagsLength, dma_addr_in);
 
+	INITIALIZE_MGMT_STATUS(ioc->sas_mgmt.status)
 	mpt_put_msg_frame(mptsasMgmtCtx, ioc, mf);
-
 	timeleft = wait_for_completion_timeout(&ioc->sas_mgmt.done, 10 * HZ);
-	if (!timeleft) {
-		printk(MYIOC_s_ERR_FMT "%s: smp timeout!\n", ioc->name, __FUNCTION__);
-		/* On timeout reset the board */
-		mpt_HardResetHandler(ioc, CAN_SLEEP);
-		ret = -ETIMEDOUT;
+	if (!(ioc->sas_mgmt.status & MPT_MGMT_STATUS_COMMAND_GOOD)) {
+		ret = -ETIME;
+		mpt_free_msg_frame(ioc, mf);
+		if (ioc->sas_mgmt.status & MPT_MGMT_STATUS_DID_IOCRESET)
+			goto out;
+		if (!timeleft) {
+			if (mpt_SoftResetHandler(ioc, CAN_SLEEP) != 0)
+				mpt_HardResetHandler(ioc, CAN_SLEEP);
+		}
 		goto unmap;
 	}
+
 	mf = NULL;
 
-	if (ioc->sas_mgmt.status & MPT_IOCTL_STATUS_RF_VALID) {
+	if ((ioc->sas_mgmt.status & MPT_MGMT_STATUS_RF_VALID) == 0) {
 		SmpPassthroughReply_t *smprep;
 
 		smprep = (SmpPassthroughReply_t *)ioc->sas_mgmt.reply;
@@ -1349,6 +1383,7 @@ static int mptsas_smp_handler(struct Scs
 		ret = -ENXIO;
 	}
 unmap:
+	CLEAR_MGMT_STATUS(ioc->sas_mgmt.status)
 	if (dma_addr_out)
 		pci_unmap_single(ioc->pcidev, dma_addr_out, req->data_len,
 				 PCI_DMA_BIDIRECTIONAL);
@@ -3232,32 +3267,8 @@ mptsas_probe(struct pci_dev *pdev, const
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
 	ioc->sas_data.ptClear = mpt_pt_clear;
 
-	init_waitqueue_head(&hd->scandv_waitq);
-	hd->scandv_wait_done = 0;
 	hd->last_queue_full = 0;
 	INIT_LIST_HEAD(&hd->target_reset_list);
 	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
