From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 9/22] mpt fusion: RESEND [2.6.30-rc6] Adding DeviceResetCtx for internal Device reset frame
Date: Wed, 27 May 2009 18:02:41 +0530
Message-ID: <20090527123234.GJ20010@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og102.obsmtp.com ([64.18.2.157]:45642 "EHLO
	exprod7og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759634AbZE0Mxz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2009 08:53:55 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


1.) 	Added taskmgmt_quiesce_io flag in IOC and removed resetPending from
	_MPT_SCSI_HOST sturct.
2.)	Reset from Scsi mid layer and internal Reset are seperate context.
	Adding DeviceResetCtx for internal Device reset frame.
	mptsas_taskmgmt_complete is optimized as part of implementation.
---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index af862bf..ae203ec 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -6243,6 +6243,7 @@ mpt_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
 {
 	switch (reset_phase) {
 	case MPT_IOC_SETUP_RESET:
+		ioc->taskmgmt_quiesce_io = 1;
 		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		    "%s: MPT_IOC_SETUP_RESET\n", ioc->name, __func__));
 		break;
@@ -6595,8 +6596,11 @@ mpt_set_taskmgmt_in_progress_flag(MPT_ADAPTER *ioc)
 	}
 	retval = 0;
 	ioc->taskmgmt_in_progress = 1;
-	if (ioc->alt_ioc)
+	ioc->taskmgmt_quiesce_io = 1;
+	if (ioc->alt_ioc) {
 		ioc->alt_ioc->taskmgmt_in_progress = 1;
+		ioc->alt_ioc->taskmgmt_quiesce_io = 1;
+	}
  out:
 	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
 	return retval;
@@ -6615,8 +6619,11 @@ mpt_clear_taskmgmt_in_progress_flag(MPT_ADAPTER *ioc)
 
 	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
 	ioc->taskmgmt_in_progress = 0;
-	if (ioc->alt_ioc)
+	ioc->taskmgmt_quiesce_io = 0;
+	if (ioc->alt_ioc) {
 		ioc->alt_ioc->taskmgmt_in_progress = 0;
+		ioc->alt_ioc->taskmgmt_quiesce_io = 0;
+	}
 	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
 }
 EXPORT_SYMBOL(mpt_clear_taskmgmt_in_progress_flag);
@@ -6731,9 +6738,11 @@ mpt_HardResetHandler(MPT_ADAPTER *ioc, int sleepFlag)
 
 	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
 	ioc->ioc_reset_in_progress = 0;
+	ioc->taskmgmt_quiesce_io = 0;
 	ioc->taskmgmt_in_progress = 0;
 	if (ioc->alt_ioc) {
 		ioc->alt_ioc->ioc_reset_in_progress = 0;
+		ioc->alt_ioc->taskmgmt_quiesce_io = 0;
 		ioc->alt_ioc->taskmgmt_in_progress = 0;
 	}
 	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 2129aff..a0bf7d8 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -713,6 +713,7 @@ typedef struct _MPT_ADAPTER
 	MPT_MGMT		 taskmgmt_cmds;
 	spinlock_t		 taskmgmt_lock; /* diagnostic reset lock */
 	int			 taskmgmt_in_progress;
+	u8			 taskmgmt_quiesce_io;
 	u8			 ioc_reset_in_progress;
 	struct work_struct	 sas_persist_task;
 
@@ -855,7 +856,6 @@ typedef struct _MPT_SCSI_HOST {
 		 * OS callbacks. freeQ is the free pool.
 		 */
 	u8			  tmPending;
-	u8			  resetPending;
 	u8			  negoNvram;		/* DV disabled, nego NVRAM */
 	u8			  pad1;
 	u8                        tmState;
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index d093871..a53b332 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -1292,7 +1292,6 @@ mptfc_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	 */
 	hd->tmPending = 0;
 	hd->tmState = TM_STATE_NONE;
-	hd->resetPending = 0;
 	hd->abortSCpnt = NULL;
 
 	/* Clear the pointer used to store
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 16c4232..3efa728 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -93,6 +93,7 @@ static u8	mptsasDoneCtx = MPT_MAX_PROTOCOL_DRIVERS;
 static u8	mptsasTaskCtx = MPT_MAX_PROTOCOL_DRIVERS;
 static u8	mptsasInternalCtx = MPT_MAX_PROTOCOL_DRIVERS; /* Used only for internal commands */
 static u8	mptsasMgmtCtx = MPT_MAX_PROTOCOL_DRIVERS;
+static u8	mptsasDeviceResetCtx = MPT_MAX_PROTOCOL_DRIVERS;
 
 static void mptsas_hotplug_work(struct work_struct *work);
 
@@ -523,10 +524,12 @@ mptsas_find_vtarget(MPT_ADAPTER *ioc, u8 channel, u8 id)
 	VirtTarget 			*vtarget = NULL;
 
 	shost_for_each_device(sdev, ioc->sh) {
-		if ((vdevice = sdev->hostdata) == NULL)
+		vdevice = sdev->hostdata;
+		if ((vdevice == NULL) ||
+			(vdevice->vtarget == NULL))
 			continue;
 		if (vdevice->vtarget->id == id &&
-		    vdevice->vtarget->channel == channel)
+			vdevice->vtarget->channel == channel)
 			vtarget = vdevice->vtarget;
 	}
 	return vtarget;
@@ -551,9 +554,11 @@ mptsas_target_reset(MPT_ADAPTER *ioc, u8 channel, u8 id)
 	MPT_FRAME_HDR	*mf;
 	SCSITaskMgmt_t	*pScsiTm;
 
-	if ((mf = mpt_get_msg_frame(ioc->TaskCtx, ioc)) == NULL) {
-		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT "%s, no msg frames @%d!!\n",
-		    ioc->name,__func__, __LINE__));
+	mf = mpt_get_msg_frame(mptsasDeviceResetCtx, ioc);
+	if (mf == NULL) {
+		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT
+			"%s, no msg frames @%d!!\n",
+			ioc->name, __func__, __LINE__));
 		return 0;
 	}
 
@@ -569,7 +574,7 @@ mptsas_target_reset(MPT_ADAPTER *ioc, u8 channel, u8 id)
 
 	DBG_DUMP_TM_REQUEST_FRAME(ioc, (u32 *)mf);
 
-	mpt_put_msg_frame_hi_pri(ioc->TaskCtx, ioc, mf);
+	mpt_put_msg_frame_hi_pri(mptsasDeviceResetCtx, ioc, mf);
 
 	return 1;
 }
@@ -605,8 +610,9 @@ mptsas_target_reset_queue(MPT_ADAPTER *ioc,
 	target_reset_list = kzalloc(sizeof(*target_reset_list),
 	    GFP_ATOMIC);
 	if (!target_reset_list) {
-		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT "%s, failed to allocate mem @%d..!!\n",
-		    ioc->name,__func__, __LINE__));
+		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT
+			"%s, failed to allocate mem @%d..!!\n",
+			ioc->name, __func__, __LINE__));
 		return;
 	}
 
@@ -614,55 +620,94 @@ mptsas_target_reset_queue(MPT_ADAPTER *ioc,
 		sizeof(*sas_event_data));
 	list_add_tail(&target_reset_list->list, &hd->target_reset_list);
 
-	if (hd->resetPending)
-		return;
+	target_reset_list->time_count = jiffies;
 
 	if (mptsas_target_reset(ioc, channel, id)) {
 		target_reset_list->target_reset_issued = 1;
-		hd->resetPending = 1;
 	}
 }
 
 /**
- * mptsas_dev_reset_complete
- *
- * Completion for TARGET_RESET after NOT_RESPONDING_EVENT,
- * enable work queue to finish off removing device from upper layers.
- * then send next TARGET_RESET in the queue.
- *
- * @ioc
+ *	mptsas_taskmgmt_complete - Completion for TARGET_RESET after
+ *	NOT_RESPONDING_EVENT, enable work queue to finish off removing device
+ *	from upper layers. then send next TARGET_RESET in the queue.
+ *	@ioc: Pointer to MPT_ADAPTER structure
  *
  **/
-static void
-mptsas_dev_reset_complete(MPT_ADAPTER *ioc)
+static int
+mptsas_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 {
 	MPT_SCSI_HOST	*hd = shost_priv(ioc->sh);
         struct list_head *head = &hd->target_reset_list;
-	struct mptsas_target_reset_event *target_reset_list;
 	struct mptsas_hotplug_event *ev;
 	EVENT_DATA_SAS_DEVICE_STATUS_CHANGE *sas_event_data;
 	u8		id, channel;
 	__le64		sas_address;
+	struct mptsas_target_reset_event	*target_reset_list;
+	SCSITaskMgmtReply_t *pScsiTmReply;
+
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "TaskMgmt completed: "
+	    "(mf = %p, mr = %p)\n", ioc->name, mf, mr));
+
+	pScsiTmReply = (SCSITaskMgmtReply_t *)mr;
+	if (pScsiTmReply) {
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "\tTaskMgmt completed: fw_channel = %d, fw_id = %d,\n"
+		    "\ttask_type = 0x%02X, iocstatus = 0x%04X "
+		    "loginfo = 0x%08X,\n\tresponse_code = 0x%02X, "
+		    "term_cmnds = %d\n", ioc->name,
+		    pScsiTmReply->Bus, pScsiTmReply->TargetID,
+		    pScsiTmReply->TaskType,
+		    le16_to_cpu(pScsiTmReply->IOCStatus),
+		    le32_to_cpu(pScsiTmReply->IOCLogInfo),
+		    pScsiTmReply->ResponseCode,
+		    le32_to_cpu(pScsiTmReply->TerminationCount)));
+
+		if (pScsiTmReply->ResponseCode)
+			mptscsih_taskmgmt_response_code(ioc,
+			pScsiTmReply->ResponseCode);
+	}
+
+	if (pScsiTmReply && (pScsiTmReply->TaskType ==
+	    MPI_SCSITASKMGMT_TASKTYPE_QUERY_TASK || pScsiTmReply->TaskType ==
+	     MPI_SCSITASKMGMT_TASKTYPE_ABRT_TASK_SET)) {
+		ioc->taskmgmt_cmds.status |= MPT_MGMT_STATUS_COMMAND_GOOD;
+		ioc->taskmgmt_cmds.status |= MPT_MGMT_STATUS_RF_VALID;
+		memcpy(ioc->taskmgmt_cmds.reply, mr,
+		    min(MPT_DEFAULT_FRAME_SIZE, 4 * mr->u.reply.MsgLength));
+		if (ioc->taskmgmt_cmds.status & MPT_MGMT_STATUS_PENDING) {
+			ioc->taskmgmt_cmds.status &= ~MPT_MGMT_STATUS_PENDING;
+			complete(&ioc->taskmgmt_cmds.done);
+			return 1;
+		}
+		return 0;
+	}
+
+	mpt_clear_taskmgmt_in_progress_flag(ioc);
 
 	if (list_empty(head))
-		return;
+		return 1;
+
+	target_reset_list = list_entry(head->next,
+	    struct mptsas_target_reset_event, list);
 
-	target_reset_list = list_entry(head->next, struct mptsas_target_reset_event, list);
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+	    "TaskMgmt: completed (%d seconds)\n",
+	    ioc->name, jiffies_to_msecs(jiffies -
+	    target_reset_list->time_count)/1000));
 
 	sas_event_data = &target_reset_list->sas_event_data;
-	id = sas_event_data->TargetID;
-	channel = sas_event_data->Bus;
-	hd->resetPending = 0;
+	id = pScsiTmReply->TargetID;
+	channel = pScsiTmReply->Bus;
+	target_reset_list->time_count = jiffies;
 
 	/*
 	 * retry target reset
 	 */
 	if (!target_reset_list->target_reset_issued) {
-		if (mptsas_target_reset(ioc, channel, id)) {
+		if (mptsas_target_reset(ioc, channel, id))
 			target_reset_list->target_reset_issued = 1;
-			hd->resetPending = 1;
-		}
-		return;
+		return 1;
 	}
 
 	/*
@@ -674,7 +719,7 @@ mptsas_dev_reset_complete(MPT_ADAPTER *ioc)
 	if (!ev) {
 		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT "%s, failed to allocate mem @%d..!!\n",
 		    ioc->name,__func__, __LINE__));
-		return;
+		return 0;
 	}
 
 	INIT_WORK(&ev->work, mptsas_hotplug_work);
@@ -693,40 +738,26 @@ mptsas_dev_reset_complete(MPT_ADAPTER *ioc)
 	schedule_work(&ev->work);
 	kfree(target_reset_list);
 
+
 	/*
 	 * issue target reset to next device in the queue
 	 */
 
 	head = &hd->target_reset_list;
 	if (list_empty(head))
-		return;
+		return 1;
 
 	target_reset_list = list_entry(head->next, struct mptsas_target_reset_event,
 	    list);
 
-	sas_event_data = &target_reset_list->sas_event_data;
-	id = sas_event_data->TargetID;
-	channel = sas_event_data->Bus;
+	id = target_reset_list->sas_event_data.TargetID;
+	channel = target_reset_list->sas_event_data.Bus;
+	target_reset_list->time_count = jiffies;
 
-	if (mptsas_target_reset(ioc, channel, id)) {
+	if (mptsas_target_reset(ioc, channel, id))
 		target_reset_list->target_reset_issued = 1;
-		hd->resetPending = 1;
-	}
-}
 
-/**
- * mptsas_taskmgmt_complete
- *
- * @ioc
- * @mf
- * @mr
- *
- **/
-static int
-mptsas_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
-{
-	mptsas_dev_reset_complete(ioc);
-	return mptscsih_taskmgmt_complete(ioc, mf, mr);
+	return 1;
 }
 
 /**
@@ -3262,7 +3293,6 @@ mptsas_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	 */
 	hd->tmPending = 0;
 	hd->tmState = TM_STATE_NONE;
-	hd->resetPending = 0;
 	hd->abortSCpnt = NULL;
 
 	/* Clear the pointer used to store
@@ -3381,10 +3411,12 @@ mptsas_init(void)
 		return -ENODEV;
 
 	mptsasDoneCtx = mpt_register(mptscsih_io_done, MPTSAS_DRIVER);
-	mptsasTaskCtx = mpt_register(mptsas_taskmgmt_complete, MPTSAS_DRIVER);
+	mptsasTaskCtx = mpt_register(mptscsih_taskmgmt_complete, MPTSAS_DRIVER);
 	mptsasInternalCtx =
 		mpt_register(mptscsih_scandv_complete, MPTSAS_DRIVER);
 	mptsasMgmtCtx = mpt_register(mptsas_mgmt_done, MPTSAS_DRIVER);
+	mptsasDeviceResetCtx =
+		mpt_register(mptsas_taskmgmt_complete, MPTSAS_DRIVER);
 
 	mpt_event_register(mptsasDoneCtx, mptsas_event_process);
 	mpt_reset_register(mptsasDoneCtx, mptsas_ioc_reset);
@@ -3409,6 +3441,7 @@ mptsas_exit(void)
 	mpt_deregister(mptsasInternalCtx);
 	mpt_deregister(mptsasTaskCtx);
 	mpt_deregister(mptsasDoneCtx);
+	mpt_deregister(mptsasDeviceResetCtx);
 }
 
 module_init(mptsas_init);
diff --git a/drivers/message/fusion/mptsas.h b/drivers/message/fusion/mptsas.h
index 2b544e0..bf528a5 100644
--- a/drivers/message/fusion/mptsas.h
+++ b/drivers/message/fusion/mptsas.h
@@ -53,6 +53,7 @@ struct mptsas_target_reset_event {
 	struct list_head 	list;
 	EVENT_DATA_SAS_DEVICE_STATUS_CHANGE sas_event_data;
 	u8	target_reset_issued;
+	unsigned long	 time_count;
 };
 
 enum mptsas_hotplug_action {
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 39de69e..f95c6b9 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -98,7 +98,7 @@ static int	mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id,
 int		mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);
 int		mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply);
 
-static void
+void
 mptscsih_taskmgmt_response_code(MPT_ADAPTER *ioc, u8 response_code);
 static int	mptscsih_get_completion_code(MPT_ADAPTER *ioc,
 		MPT_FRAME_HDR *req, MPT_FRAME_HDR *reply);
@@ -1303,7 +1303,7 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 	dmfprintk(ioc, printk(MYIOC_s_DEBUG_FMT "qcmd: SCpnt=%p, done()=%p\n",
 		ioc->name, SCpnt, done));
 
-	if (hd->resetPending) {
+	if (ioc->taskmgmt_quiesce_io) {
 		dtmprintk(ioc, printk(MYIOC_s_WARN_FMT "qcmd: SCpnt=%p timeout + 60HZ\n",
 			ioc->name, SCpnt));
 		return SCSI_MLQUEUE_HOST_BUSY;
@@ -1707,11 +1707,6 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 		goto out;
 	}
 
-	if (hd->resetPending) {
-		retval = FAILED;
-		goto out;
-	}
-
 	if (hd->timeouts < -1)
 		hd->timeouts++;
 
@@ -1780,11 +1775,6 @@ mptscsih_dev_reset(struct scsi_cmnd * SCpnt)
 	       ioc->name, SCpnt);
 	scsi_print_command(SCpnt);
 
-	if (hd->resetPending) {
-		retval = FAILED;
-		goto out;
-	}
-
 	vdevice = SCpnt->device->hostdata;
 	if (!vdevice || !vdevice->vtarget) {
 		retval = 0;
@@ -1965,7 +1955,7 @@ mptscsih_taskmgmt_reply(MPT_ADAPTER *ioc, u8 type,
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-static void
+void
 mptscsih_taskmgmt_response_code(MPT_ADAPTER *ioc, u8 response_code)
 {
 	char *desc;
@@ -1999,6 +1989,7 @@ mptscsih_taskmgmt_response_code(MPT_ADAPTER *ioc, u8 response_code)
 	printk(MYIOC_s_INFO_FMT "Response Code(0x%08x): F/W: %s\n",
 		ioc->name, response_code, desc);
 }
+EXPORT_SYMBOL(mptscsih_taskmgmt_response_code);
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
@@ -2440,12 +2431,10 @@ mptscsih_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
 	case MPT_IOC_SETUP_RESET:
 		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		    "%s: MPT_IOC_SETUP_RESET\n", ioc->name, __func__));
-		hd->resetPending = 1;
 		break;
 	case MPT_IOC_PRE_RESET:
 		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		    "%s: MPT_IOC_PRE_RESET\n", ioc->name, __func__));
-		hd->resetPending = 0;
 		mptscsih_flush_running_cmds(hd);
 		break;
 	case MPT_IOC_POST_RESET:
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
index 0b103a2..1fa7182 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -131,3 +131,4 @@ extern int mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int
 extern u8 mptscsih_raid_id_to_num(MPT_ADAPTER *ioc, u8 channel, u8 id);
 extern int mptscsih_is_phys_disk(MPT_ADAPTER *ioc, u8 channel, u8 id);
 extern struct device_attribute *mptscsih_host_attrs[];
+extern void mptscsih_taskmgmt_response_code(MPT_ADAPTER *ioc, u8 response_code);
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 8f46fdf..df30629 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -1476,7 +1476,6 @@ mptspi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	 */
 	hd->tmPending = 0;
 	hd->tmState = TM_STATE_NONE;
-	hd->resetPending = 0;
 	hd->abortSCpnt = NULL;
 
 	/* Clear the pointer used to store
