From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 20/22] mpt fusion: RESEND [2.6.30-rc6] Added support for Broadcast primitives Event handling
Date: Wed, 27 May 2009 18:15:51 +0530
Message-ID: <20090527124546.GU20010@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og124.obsmtp.com ([64.18.2.26]:41651 "EHLO
	exprod7og124.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760122AbZE0NHH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2009 09:07:07 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Firmware is able to handle Broadcast primitives, but upstream driver does not
have support for broadcast primitive handling. Now this patch is mainly to
support broadcast primitives.
---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 4f3d4c3..1c8514d 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -758,6 +758,7 @@ typedef struct _MPT_ADAPTER
 	struct scsi_cmnd	**ScsiLookup;
 	spinlock_t		  scsi_lookup_lock;
 	u64			dma_mask;
+	u32			  broadcast_aen_busy;
 	char			 reset_work_q_name[MPT_KOBJ_NAME_LEN];
 	struct workqueue_struct *reset_work_q;
 	struct delayed_work	 fault_reset_work;
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index b6ca13e..7f0c8a3 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -121,6 +121,7 @@ static void mptsas_expander_delete(MPT_ADAPTER *ioc,
 static void mptsas_send_expander_event(struct fw_event_work *fw_event);
 static void mptsas_not_responding_devices(MPT_ADAPTER *ioc);
 static void mptsas_scan_sas_topology(MPT_ADAPTER *ioc);
+static void mptsas_broadcast_primative_work(struct fw_event_work *fw_event);
 static void mptsas_handle_queue_full_event(struct fw_event_work *fw_event);
 static void mptsas_volume_delete(MPT_ADAPTER *ioc, u8 id);
 
@@ -287,6 +288,21 @@ mptsas_add_fw_event(MPT_ADAPTER *ioc, struct fw_event_work *fw_event,
 	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
 }
 
+/* requeue a sas firmware event */
+static void
+mptsas_requeue_fw_event(MPT_ADAPTER *ioc, struct fw_event_work *fw_event,
+    unsigned long delay)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&ioc->fw_event_lock, flags);
+	devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT "%s: reschedule task "
+	    "(fw_event=0x%p)\n", ioc->name, __func__, fw_event));
+	fw_event->retries++;
+	queue_delayed_work(ioc->fw_event_q, &fw_event->work,
+	    msecs_to_jiffies(delay));
+	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
+}
+
 /* free memory assoicated to a sas firmware event */
 static void
 mptsas_free_fw_event(MPT_ADAPTER *ioc, struct fw_event_work *fw_event)
@@ -1606,6 +1622,9 @@ mptsas_firmware_event_work(struct work_struct *work)
 		    MPI_SAS_OP_CLEAR_NOT_PRESENT);
 		mptsas_free_fw_event(ioc, fw_event);
 		break;
+	case MPI_EVENT_SAS_BROADCAST_PRIMITIVE:
+		mptsas_broadcast_primative_work(fw_event);
+		break;
 	case MPI_EVENT_SAS_EXPANDER_STATUS_CHANGE:
 		mptsas_send_expander_event(fw_event);
 		break;
@@ -4319,6 +4338,182 @@ mptsas_send_raid_event(struct fw_event_work *fw_event)
 		mptsas_free_fw_event(ioc, fw_event);
 }
 
+/**
+ *	mptsas_issue_tm - send mptsas internal tm request
+ *	@ioc: Pointer to MPT_ADAPTER structure
+ *	@type
+ *	@channel
+ *	@id
+ *	@lun
+ *	@task_context
+ *	@timeout
+ *
+ *	return:
+ *
+ **/
+static int
+mptsas_issue_tm(MPT_ADAPTER *ioc, u8 type, u8 channel, u8 id, u64 lun,
+	int task_context, ulong timeout, u8 *issue_reset)
+{
+	MPT_FRAME_HDR	*mf;
+	SCSITaskMgmt_t	*pScsiTm;
+	int		 retval;
+	unsigned long	 timeleft;
+
+	*issue_reset = 0;
+	mf = mpt_get_msg_frame(mptsasDeviceResetCtx, ioc);
+	if (mf == NULL) {
+		retval = -1; /* return failure */
+		dtmprintk(ioc, printk(MYIOC_s_WARN_FMT "TaskMgmt request: no "
+		    "msg frames!!\n", ioc->name));
+		goto out;
+	}
+
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "TaskMgmt request: mr = %p, "
+	    "task_type = 0x%02X,\n\t timeout = %ld, fw_channel = %d, "
+	    "fw_id = %d, lun = %lld,\n\t task_context = 0x%x\n", ioc->name, mf,
+	     type, timeout, channel, id, (unsigned long long)lun,
+	     task_context));
+
+	pScsiTm = (SCSITaskMgmt_t *) mf;
+	memset(pScsiTm, 0, sizeof(SCSITaskMgmt_t));
+	pScsiTm->Function = MPI_FUNCTION_SCSI_TASK_MGMT;
+	pScsiTm->TaskType = type;
+	pScsiTm->MsgFlags = 0;
+	pScsiTm->TargetID = id;
+	pScsiTm->Bus = channel;
+	pScsiTm->ChainOffset = 0;
+	pScsiTm->Reserved = 0;
+	pScsiTm->Reserved1 = 0;
+	pScsiTm->TaskMsgContext = task_context;
+	int_to_scsilun(lun, (struct scsi_lun *)pScsiTm->LUN);
+
+	INITIALIZE_MGMT_STATUS(ioc->taskmgmt_cmds.status)
+	CLEAR_MGMT_STATUS(ioc->internal_cmds.status)
+	retval = 0;
+	mpt_put_msg_frame_hi_pri(mptsasDeviceResetCtx, ioc, mf);
+
+	/* Now wait for the command to complete */
+	timeleft = wait_for_completion_timeout(&ioc->taskmgmt_cmds.done,
+	    timeout*HZ);
+	if (!(ioc->taskmgmt_cmds.status & MPT_MGMT_STATUS_COMMAND_GOOD)) {
+		retval = -1; /* return failure */
+		dtmprintk(ioc, printk(MYIOC_s_ERR_FMT
+		    "TaskMgmt request: TIMED OUT!(mr=%p)\n", ioc->name, mf));
+		mpt_free_msg_frame(ioc, mf);
+		if (ioc->taskmgmt_cmds.status & MPT_MGMT_STATUS_DID_IOCRESET)
+			goto out;
+		*issue_reset = 1;
+		goto out;
+	}
+
+	if (!(ioc->taskmgmt_cmds.status & MPT_MGMT_STATUS_RF_VALID)) {
+		retval = -1; /* return failure */
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "TaskMgmt request: failed with no reply\n", ioc->name));
+		goto out;
+	}
+
+ out:
+	CLEAR_MGMT_STATUS(ioc->taskmgmt_cmds.status)
+	return retval;
+}
+
+/**
+ *	mptsas_broadcast_primative_work - Work queue thread to handle
+ *	broadcast primitive events
+ *	@work: work queue payload containing info describing the event
+ *
+ **/
+static void
+mptsas_broadcast_primative_work(struct fw_event_work *fw_event)
+{
+	MPT_ADAPTER *ioc = fw_event->ioc;
+	MPT_FRAME_HDR	*mf;
+	VirtDevice	*vdevice;
+	int			ii;
+	struct scsi_cmnd	*sc;
+	SCSITaskMgmtReply_t	*pScsiTmReply;
+	u8			issue_reset;
+	int			task_context;
+	u8			channel, id;
+	int			 lun;
+	u32			 termination_count;
+	u32			 query_count;
+
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+	    "%s - enter\n", ioc->name, __func__));
+
+	mutex_lock(&ioc->taskmgmt_cmds.mutex);
+	if (mpt_set_taskmgmt_in_progress_flag(ioc) != 0) {
+		mutex_unlock(&ioc->taskmgmt_cmds.mutex);
+		mptsas_requeue_fw_event(ioc, fw_event, 1000);
+		return;
+	}
+
+	issue_reset = 0;
+	termination_count = 0;
+	query_count = 0;
+	mpt_findImVolumes(ioc);
+	pScsiTmReply = (SCSITaskMgmtReply_t *) ioc->taskmgmt_cmds.reply;
+
+	for (ii = 0; ii < ioc->req_depth; ii++) {
+		if (ioc->fw_events_off)
+			goto out;
+		sc = mptscsih_get_scsi_lookup(ioc, ii);
+		if (!sc)
+			continue;
+		mf = MPT_INDEX_2_MFPTR(ioc, ii);
+		if (!mf)
+			continue;
+		task_context = mf->u.frame.hwhdr.msgctxu.MsgContext;
+		vdevice = sc->device->hostdata;
+		if (!vdevice || !vdevice->vtarget)
+			continue;
+		if (vdevice->vtarget->tflags & MPT_TARGET_FLAGS_RAID_COMPONENT)
+			continue; /* skip hidden raid components */
+		if (vdevice->vtarget->raidVolume)
+			continue; /* skip hidden raid components */
+		channel = vdevice->vtarget->channel;
+		id = vdevice->vtarget->id;
+		lun = vdevice->lun;
+		if (mptsas_issue_tm(ioc, MPI_SCSITASKMGMT_TASKTYPE_QUERY_TASK,
+		    channel, id, (u64)lun, task_context, 30, &issue_reset))
+			goto out;
+		query_count++;
+		termination_count +=
+		    le32_to_cpu(pScsiTmReply->TerminationCount);
+		if ((pScsiTmReply->IOCStatus == MPI_IOCSTATUS_SUCCESS) &&
+		    (pScsiTmReply->ResponseCode ==
+		    MPI_SCSITASKMGMT_RSP_TM_SUCCEEDED ||
+		    pScsiTmReply->ResponseCode ==
+		    MPI_SCSITASKMGMT_RSP_IO_QUEUED_ON_IOC))
+			continue;
+		if (mptsas_issue_tm(ioc,
+		    MPI_SCSITASKMGMT_TASKTYPE_ABRT_TASK_SET,
+		    channel, id, (u64)lun, 0, 30, &issue_reset))
+			goto out;
+		termination_count +=
+		    le32_to_cpu(pScsiTmReply->TerminationCount);
+	}
+
+ out:
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+	    "%s - exit, query_count = %d termination_count = %d\n",
+	    ioc->name, __func__, query_count, termination_count));
+
+	ioc->broadcast_aen_busy = 0;
+	mpt_clear_taskmgmt_in_progress_flag(ioc);
+	mutex_unlock(&ioc->taskmgmt_cmds.mutex);
+
+	if (issue_reset) {
+		printk(MYIOC_s_WARN_FMT "Issuing Reset from %s!!\n",
+		    ioc->name, __func__);
+		mpt_HardResetHandler(ioc, CAN_SLEEP);
+	}
+	mptsas_free_fw_event(ioc, fw_event);
+}
+
 /*
  * mptsas_send_ir2_event - handle exposing hidden disk when
  * an inactive raid volume is added
@@ -4382,6 +4577,18 @@ mptsas_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *reply)
 
 	delay = msecs_to_jiffies(1);
 	switch (event) {
+	case MPI_EVENT_SAS_BROADCAST_PRIMITIVE:
+	{
+		EVENT_DATA_SAS_BROADCAST_PRIMITIVE *broadcast_event_data =
+		    (EVENT_DATA_SAS_BROADCAST_PRIMITIVE *)reply->Data;
+		if (broadcast_event_data->Primitive !=
+		    MPI_EVENT_PRIMITIVE_ASYNCHRONOUS_EVENT)
+			return 0;
+		if (ioc->broadcast_aen_busy)
+			return 0;
+		ioc->broadcast_aen_busy = 1;
+		break;
+	}
 	case MPI_EVENT_SAS_DEVICE_STATUS_CHANGE:
 	{
 		EVENT_DATA_SAS_DEVICE_STATUS_CHANGE *sas_event_data =
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 2b2e89a..3783535 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -80,6 +80,7 @@ MODULE_VERSION(my_VERSION);
 /*
  *  Other private/forward protos...
  */
+struct scsi_cmnd	*mptscsih_get_scsi_lookup(MPT_ADAPTER *ioc, int i);
 static struct scsi_cmnd * mptscsih_getclear_scsi_lookup(MPT_ADAPTER *ioc, int i);
 static void	mptscsih_set_scsi_lookup(MPT_ADAPTER *ioc, int i, struct scsi_cmnd *scmd);
 static int	SCPNT_TO_LOOKUP_IDX(MPT_ADAPTER *ioc, struct scsi_cmnd *scmd);
@@ -2417,6 +2418,30 @@ mptscsih_copy_sense_data(struct scsi_cmnd *sc, MPT_SCSI_HOST *hd, MPT_FRAME_HDR
 	}
 }
 
+/**
+ * mptscsih_get_scsi_lookup
+ *
+ * retrieves scmd entry from ScsiLookup[] array list
+ *
+ * @ioc: Pointer to MPT_ADAPTER structure
+ * @i: index into the array
+ *
+ * Returns the scsi_cmd pointer
+ *
+ **/
+struct scsi_cmnd *
+mptscsih_get_scsi_lookup(MPT_ADAPTER *ioc, int i)
+{
+	unsigned long	flags;
+	struct scsi_cmnd *scmd;
+
+	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+	scmd = ioc->ScsiLookup[i];
+	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+
+	return scmd;
+}
+EXPORT_SYMBOL(mptscsih_get_scsi_lookup);
 
 /**
  * mptscsih_getclear_scsi_lookup
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
index a472977..77f021e 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -133,4 +133,5 @@ extern int mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int
 extern u8 mptscsih_raid_id_to_num(MPT_ADAPTER *ioc, u8 channel, u8 id);
 extern int mptscsih_is_phys_disk(MPT_ADAPTER *ioc, u8 channel, u8 id);
 extern struct device_attribute *mptscsih_host_attrs[];
+extern struct scsi_cmnd	*mptscsih_get_scsi_lookup(MPT_ADAPTER *ioc, int i);
 extern void mptscsih_taskmgmt_response_code(MPT_ADAPTER *ioc, u8 response_code);
