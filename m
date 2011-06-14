From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 04/07] mpt2sas: broadcast AEN and task management issue fixed.
Date: Tue, 14 Jun 2011 10:56:43 +0530
Message-ID: <20110614052639.GF14349@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:39289 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750878Ab1FNFCD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jun 2011 01:02:03 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Properly handling of target reset in multi-initiator environment

Clean up in broadcast change handling:
(1) Need to look at the status of each task management request, and retry
the TM when there are failures.
(2) Need quiescence IO so the driver doesn't take on more IO request while
it's in the middle of sending TM  request to firmware
(3)  Add support to keep track of how many pending broadcast AEN events
are received while the broadcast handling is active, then loop back at
the end of this routine if there were any events received.

Clean up in mpt2sas_scsih_issue_tm routine:
(1) Make sure proper status is returned when host reset fails
(2) Clean up sanity checks near end of routine, insuring all outstanding
IOs were completed.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 605ea3c..df135db 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -589,6 +589,16 @@ struct mpt2sas_port_facts {
 };
 
 /**
+ * enum mutex_type - task management mutex type
+ * @TM_MUTEX_OFF: mutex is not required becuase calling function is acquiring it
+ * @TM_MUTEX_ON: mutex is required
+ */
+enum mutex_type {
+	TM_MUTEX_OFF = 0,
+	TM_MUTEX_ON = 1,
+};
+
+/**
  * struct MPT2SAS_ADAPTER - per adapter struct
  * @list: ioc_list
  * @shost: shost object
@@ -750,6 +760,7 @@ struct MPT2SAS_ADAPTER {
 	 /* misc flags */
 	int		aen_event_read_flag;
 	u8		broadcast_aen_busy;
+	u16		broadcast_aen_pending;
 	u8		shost_recovery;
 
 	struct mutex	reset_in_progress_mutex;
@@ -979,8 +990,8 @@ void mpt2sas_halt_firmware(struct MPT2SAS_ADAPTER *ioc);
 u8 mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
     u32 reply);
 int mpt2sas_scsih_issue_tm(struct MPT2SAS_ADAPTER *ioc, u16 handle,
-    uint channel, uint id, uint lun, u8 type, u16 smid_task,
-    ulong timeout, struct scsi_cmnd *scmd);
+	uint channel, uint id, uint lun, u8 type, u16 smid_task,
+	ulong timeout, unsigned long serial_number, enum mutex_type m_type);
 void mpt2sas_scsih_set_tm_flag(struct MPT2SAS_ADAPTER *ioc, u16 handle);
 void mpt2sas_scsih_clear_tm_flag(struct MPT2SAS_ADAPTER *ioc, u16 handle);
 void mpt2sas_expander_remove(struct MPT2SAS_ADAPTER *ioc, u64 sas_address);
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index d1c3bba..38ed026 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -994,7 +994,7 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc,
 			mpt2sas_scsih_issue_tm(ioc,
 			    le16_to_cpu(mpi_request->FunctionDependent1), 0, 0,
 			    0, MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET, 0, 10,
-			    NULL);
+			    0, TM_MUTEX_ON);
 			ioc->tm_cmds.status = MPT2_CMD_NOT_USED;
 		} else
 			mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index ff0178a..30f77dd 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2237,6 +2237,8 @@ mpt2sas_scsih_clear_tm_flag(struct MPT2SAS_ADAPTER *ioc, u16 handle)
  * @type: MPI2_SCSITASKMGMT_TASKTYPE__XXX (defined in mpi2_init.h)
  * @smid_task: smid assigned to the task
  * @timeout: timeout in seconds
+ * @serial_number: the serial_number from scmd
+ * @m_type: TM_MUTEX_ON or TM_MUTEX_OFF
  * Context: user
  *
  * A generic API for sending task management requests to firmware.
@@ -2248,17 +2250,18 @@ mpt2sas_scsih_clear_tm_flag(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 int
 mpt2sas_scsih_issue_tm(struct MPT2SAS_ADAPTER *ioc, u16 handle, uint channel,
     uint id, uint lun, u8 type, u16 smid_task, ulong timeout,
-    struct scsi_cmnd *scmd)
+	unsigned long serial_number, enum mutex_type m_type)
 {
 	Mpi2SCSITaskManagementRequest_t *mpi_request;
 	Mpi2SCSITaskManagementReply_t *mpi_reply;
 	u16 smid = 0;
 	u32 ioc_state;
 	unsigned long timeleft;
-	struct scsi_cmnd *scmd_lookup;
+	struct scsiio_tracker *scsi_lookup = NULL;
 	int rc;
 
-	mutex_lock(&ioc->tm_cmds.mutex);
+	if (m_type == TM_MUTEX_ON)
+		mutex_lock(&ioc->tm_cmds.mutex);
 	if (ioc->tm_cmds.status != MPT2_CMD_NOT_USED) {
 		printk(MPT2SAS_INFO_FMT "%s: tm_cmd busy!!!\n",
 		    __func__, ioc->name);
@@ -2278,18 +2281,18 @@ mpt2sas_scsih_issue_tm(struct MPT2SAS_ADAPTER *ioc, u16 handle, uint channel,
 	if (ioc_state & MPI2_DOORBELL_USED) {
 		dhsprintk(ioc, printk(MPT2SAS_INFO_FMT "unexpected doorbell "
 		    "active!\n", ioc->name));
-		mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
+		rc = mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
 		    FORCE_BIG_HAMMER);
-		rc = SUCCESS;
+		rc = (!rc) ? SUCCESS : FAILED;
 		goto err_out;
 	}
 
 	if ((ioc_state & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_FAULT) {
 		mpt2sas_base_fault_info(ioc, ioc_state &
 		    MPI2_DOORBELL_DATA_MASK);
-		mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
+		rc = mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
 		    FORCE_BIG_HAMMER);
-		rc = SUCCESS;
+		rc = (!rc) ? SUCCESS : FAILED;
 		goto err_out;
 	}
 
@@ -2301,6 +2304,9 @@ mpt2sas_scsih_issue_tm(struct MPT2SAS_ADAPTER *ioc, u16 handle, uint channel,
 		goto err_out;
 	}
 
+	if (type == MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK)
+		scsi_lookup = &ioc->scsi_lookup[smid_task - 1];
+
 	dtmprintk(ioc, printk(MPT2SAS_INFO_FMT "sending tm: handle(0x%04x),"
 	    " task_type(0x%02x), smid(%d)\n", ioc->name, handle, type,
 	    smid_task));
@@ -2308,6 +2314,7 @@ mpt2sas_scsih_issue_tm(struct MPT2SAS_ADAPTER *ioc, u16 handle, uint channel,
 	mpi_request = mpt2sas_base_get_msg_frame(ioc, smid);
 	ioc->tm_cmds.smid = smid;
 	memset(mpi_request, 0, sizeof(Mpi2SCSITaskManagementRequest_t));
+	memset(ioc->tm_cmds.reply, 0, sizeof(Mpi2SCSITaskManagementReply_t));
 	mpi_request->Function = MPI2_FUNCTION_SCSI_TASK_MGMT;
 	mpi_request->DevHandle = cpu_to_le16(handle);
 	mpi_request->TaskType = type;
@@ -2323,9 +2330,9 @@ mpt2sas_scsih_issue_tm(struct MPT2SAS_ADAPTER *ioc, u16 handle, uint channel,
 		_debug_dump_mf(mpi_request,
 		    sizeof(Mpi2SCSITaskManagementRequest_t)/4);
 		if (!(ioc->tm_cmds.status & MPT2_CMD_RESET)) {
-			mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
+			rc = mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
 			    FORCE_BIG_HAMMER);
-			rc = SUCCESS;
+			rc = (!rc) ? SUCCESS : FAILED;
 			ioc->tm_cmds.status = MPT2_CMD_NOT_USED;
 			mpt2sas_scsih_clear_tm_flag(ioc, handle);
 			goto err_out;
@@ -2347,20 +2354,12 @@ mpt2sas_scsih_issue_tm(struct MPT2SAS_ADAPTER *ioc, u16 handle, uint channel,
 		}
 	}
 
-	/* sanity check:
-	 * Check to see the commands were terminated.
-	 * This is only needed for eh callbacks, hence the scmd check.
-	 */
-	rc = FAILED;
-	if (scmd == NULL)
-		goto bypass_sanity_checks;
 	switch (type) {
 	case MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK:
-		scmd_lookup = _scsih_scsi_lookup_get(ioc, smid_task);
-		if (scmd_lookup)
-			rc = FAILED;
-		else
-			rc = SUCCESS;
+		rc = SUCCESS;
+		if (scsi_lookup->scmd == NULL)
+			break;
+		rc = FAILED;
 		break;
 
 	case MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET:
@@ -2370,24 +2369,31 @@ mpt2sas_scsih_issue_tm(struct MPT2SAS_ADAPTER *ioc, u16 handle, uint channel,
 			rc = SUCCESS;
 		break;
 
+	case MPI2_SCSITASKMGMT_TASKTYPE_ABRT_TASK_SET:
 	case MPI2_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET:
 		if (_scsih_scsi_lookup_find_by_lun(ioc, id, lun, channel))
 			rc = FAILED;
 		else
 			rc = SUCCESS;
 		break;
+	case MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK:
+		rc = SUCCESS;
+		break;
+	default:
+		rc = FAILED;
+		break;
 	}
 
- bypass_sanity_checks:
-
 	mpt2sas_scsih_clear_tm_flag(ioc, handle);
 	ioc->tm_cmds.status = MPT2_CMD_NOT_USED;
-	mutex_unlock(&ioc->tm_cmds.mutex);
+	if (m_type == TM_MUTEX_ON)
+		mutex_unlock(&ioc->tm_cmds.mutex);
 
 	return rc;
 
  err_out:
-	mutex_unlock(&ioc->tm_cmds.mutex);
+	if (m_type == TM_MUTEX_ON)
+		mutex_unlock(&ioc->tm_cmds.mutex);
 	return rc;
 }
 
@@ -2497,7 +2503,8 @@ _scsih_abort(struct scsi_cmnd *scmd)
 	handle = sas_device_priv_data->sas_target->handle;
 	r = mpt2sas_scsih_issue_tm(ioc, handle, scmd->device->channel,
 	    scmd->device->id, scmd->device->lun,
-	    MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK, smid, 30, scmd);
+	    MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK, smid, 30,
+	    scmd->serial_number, TM_MUTEX_ON);
 
  out:
 	sdev_printk(KERN_INFO, scmd->device, "task abort: %s scmd(%p)\n",
@@ -2558,7 +2565,8 @@ _scsih_dev_reset(struct scsi_cmnd *scmd)
 
 	r = mpt2sas_scsih_issue_tm(ioc, handle, scmd->device->channel,
 	    scmd->device->id, scmd->device->lun,
-	    MPI2_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, 0, 30, scmd);
+	    MPI2_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, 0, 30, 0,
+	    TM_MUTEX_ON);
 
  out:
 	sdev_printk(KERN_INFO, scmd->device, "device reset: %s scmd(%p)\n",
@@ -2618,7 +2626,7 @@ _scsih_target_reset(struct scsi_cmnd *scmd)
 
 	r = mpt2sas_scsih_issue_tm(ioc, handle, scmd->device->channel,
 	    scmd->device->id, 0, MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET, 0,
-	    30, scmd);
+	    30, 0, TM_MUTEX_ON);
 
  out:
 	starget_printk(KERN_INFO, starget, "target reset: %s scmd(%p)\n",
@@ -2751,6 +2759,31 @@ _scsih_fw_event_cleanup_queue(struct MPT2SAS_ADAPTER *ioc)
 }
 
 /**
+ * _scsih_ublock_io_all_device - unblock every device
+ * @ioc: per adapter object
+ *
+ * change the device state from block to running
+ */
+static void
+_scsih_ublock_io_all_device(struct MPT2SAS_ADAPTER *ioc)
+{
+	struct MPT2SAS_DEVICE *sas_device_priv_data;
+	struct scsi_device *sdev;
+
+	shost_for_each_device(sdev, ioc->shost) {
+		sas_device_priv_data = sdev->hostdata;
+		if (!sas_device_priv_data)
+			continue;
+		if (!sas_device_priv_data->block)
+			continue;
+		sas_device_priv_data->block = 0;
+		dewtprintk(ioc, sdev_printk(KERN_INFO, sdev, "device_running, "
+		    "handle(0x%04x)\n",
+		    sas_device_priv_data->sas_target->handle));
+		scsi_internal_device_unblock(sdev);
+	}
+}
+/**
  * _scsih_ublock_io_device - set the device state to SDEV_RUNNING
  * @ioc: per adapter object
  * @handle: device handle
@@ -2780,6 +2813,34 @@ _scsih_ublock_io_device(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 }
 
 /**
+ * _scsih_block_io_all_device - set the device state to SDEV_BLOCK
+ * @ioc: per adapter object
+ * @handle: device handle
+ *
+ * During device pull we need to appropiately set the sdev state.
+ */
+static void
+_scsih_block_io_all_device(struct MPT2SAS_ADAPTER *ioc)
+{
+	struct MPT2SAS_DEVICE *sas_device_priv_data;
+	struct scsi_device *sdev;
+
+	shost_for_each_device(sdev, ioc->shost) {
+		sas_device_priv_data = sdev->hostdata;
+		if (!sas_device_priv_data)
+			continue;
+		if (sas_device_priv_data->block)
+			continue;
+		sas_device_priv_data->block = 1;
+		dewtprintk(ioc, sdev_printk(KERN_INFO, sdev, "device_blocked, "
+		    "handle(0x%04x)\n",
+		    sas_device_priv_data->sas_target->handle));
+		scsi_internal_device_block(sdev);
+	}
+}
+
+
+/**
  * _scsih_block_io_device - set the device state to SDEV_BLOCK
  * @ioc: per adapter object
  * @handle: device handle
@@ -5351,9 +5412,10 @@ _scsih_sas_device_status_change_event_debug(struct MPT2SAS_ADAPTER *ioc,
 		break;
 	}
 	printk(MPT2SAS_INFO_FMT "device status change: (%s)\n"
-	    "\thandle(0x%04x), sas address(0x%016llx)", ioc->name,
-	    reason_str, le16_to_cpu(event_data->DevHandle),
-	    (unsigned long long)le64_to_cpu(event_data->SASAddress));
+	    "\thandle(0x%04x), sas address(0x%016llx), tag(%d)",
+	    ioc->name, reason_str, le16_to_cpu(event_data->DevHandle),
+	    (unsigned long long)le64_to_cpu(event_data->SASAddress),
+	    le16_to_cpu(event_data->TaskTag));
 	if (event_data->ReasonCode == MPI2_EVENT_SAS_DEV_STAT_RC_SMART_DATA)
 		printk(MPT2SAS_INFO_FMT ", ASC(0x%x), ASCQ(0x%x)\n", ioc->name,
 		    event_data->ASC, event_data->ASCQ);
@@ -5493,25 +5555,38 @@ _scsih_sas_broadcast_primative_event(struct MPT2SAS_ADAPTER *ioc,
 	u32 termination_count;
 	u32 query_count;
 	Mpi2SCSITaskManagementReply_t *mpi_reply;
-#ifdef CONFIG_SCSI_MPT2SAS_LOGGING
 	Mpi2EventDataSasBroadcastPrimitive_t *event_data = fw_event->event_data;
-#endif
 	u16 ioc_status;
 	unsigned long flags;
 	int r;
+	u8 max_retries = 0;
+	u8 task_abort_retries;
 
-	dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "broadcast primitive: "
-	    "phy number(%d), width(%d)\n", ioc->name, event_data->PhyNum,
-	    event_data->PortWidth));
-	dtmprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: enter\n", ioc->name,
-	    __func__));
+	mutex_lock(&ioc->tm_cmds.mutex);
+	dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: enter: phy number(%d), "
+	    "width(%d)\n", ioc->name, __func__, event_data->PhyNum,
+	     event_data->PortWidth));
+
+	_scsih_block_io_all_device(ioc);
 
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	ioc->broadcast_aen_busy = 0;
+	mpi_reply = ioc->tm_cmds.reply;
+broadcast_aen_retry:
+
+	/* sanity checks for retrying this loop */
+	if (max_retries++ == 5) {
+		dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: giving up\n",
+		    ioc->name, __func__));
+		goto out;
+	} else if (max_retries > 1)
+		dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: %d retry\n",
+		    ioc->name, __func__, max_retries - 1));
+
 	termination_count = 0;
 	query_count = 0;
-	mpi_reply = ioc->tm_cmds.reply;
 	for (smid = 1; smid <= ioc->scsiio_depth; smid++) {
+		if (ioc->ioc_reset_in_progress_status)
+			goto out;
 		scmd = _scsih_scsi_lookup_get(ioc, smid);
 		if (!scmd)
 			continue;
@@ -5532,34 +5607,90 @@ _scsih_sas_broadcast_primative_event(struct MPT2SAS_ADAPTER *ioc,
 		lun = sas_device_priv_data->lun;
 		query_count++;
 
+		if (ioc->ioc_reset_in_progress_status)
+			goto out;
+
 		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
-		mpt2sas_scsih_issue_tm(ioc, handle, 0, 0, lun,
-		    MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK, smid, 30, NULL);
-		ioc->tm_cmds.status = MPT2_CMD_NOT_USED;
+		r = mpt2sas_scsih_issue_tm(ioc, handle, 0, 0, lun,
+		    MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK, smid, 30, 0,
+		    TM_MUTEX_OFF);
+		if (r == FAILED) {
+			sdev_printk(KERN_WARNING, sdev,
+			    "mpt2sas_scsih_issue_tm: FAILED when sending "
+			    "QUERY_TASK: scmd(%p)\n", scmd);
+			spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+			goto broadcast_aen_retry;
+		}
 		ioc_status = le16_to_cpu(mpi_reply->IOCStatus)
 		    & MPI2_IOCSTATUS_MASK;
-		if ((ioc_status == MPI2_IOCSTATUS_SUCCESS) &&
-		    (mpi_reply->ResponseCode ==
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+			sdev_printk(KERN_WARNING, sdev, "query task: FAILED "
+			    "with IOCSTATUS(0x%04x), scmd(%p)\n", ioc_status,
+			    scmd);
+			spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+			goto broadcast_aen_retry;
+		}
+
+		/* see if IO is still owned by IOC and target */
+		if (mpi_reply->ResponseCode ==
 		     MPI2_SCSITASKMGMT_RSP_TM_SUCCEEDED ||
 		     mpi_reply->ResponseCode ==
-		     MPI2_SCSITASKMGMT_RSP_IO_QUEUED_ON_IOC)) {
+		     MPI2_SCSITASKMGMT_RSP_IO_QUEUED_ON_IOC) {
 			spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 			continue;
 		}
+		task_abort_retries = 0;
+ tm_retry:
+		if (task_abort_retries++ == 60) {
+			dewtprintk(ioc, printk(MPT2SAS_INFO_FMT
+			    "%s: ABORT_TASK: giving up\n", ioc->name,
+			    __func__));
+			spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+			goto broadcast_aen_retry;
+		}
+
+		if (ioc->ioc_reset_in_progress_status)
+			goto out_no_lock;
+
 		r = mpt2sas_scsih_issue_tm(ioc, handle, sdev->channel, sdev->id,
 		    sdev->lun, MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK, smid, 30,
-		    scmd);
-		if (r == FAILED)
-			sdev_printk(KERN_WARNING, sdev, "task abort: FAILED "
+		    scmd->serial_number, TM_MUTEX_OFF);
+		if (r == FAILED) {
+			sdev_printk(KERN_WARNING, sdev,
+			    "mpt2sas_scsih_issue_tm: ABORT_TASK: FAILED : "
 			    "scmd(%p)\n", scmd);
+			goto tm_retry;
+		}
+
+		if (task_abort_retries > 1)
+			sdev_printk(KERN_WARNING, sdev,
+			    "mpt2sas_scsih_issue_tm: ABORT_TASK: RETRIES (%d):"
+			    " scmd(%p)\n",
+			    task_abort_retries - 1, scmd);
+
 		termination_count += le32_to_cpu(mpi_reply->TerminationCount);
 		spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	}
+
+	if (ioc->broadcast_aen_pending) {
+		dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: loop back due to"
+		     " pending AEN\n", ioc->name, __func__));
+		 ioc->broadcast_aen_pending = 0;
+		 goto broadcast_aen_retry;
+	}
+
+ out:
 	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+ out_no_lock:
 
-	dtmprintk(ioc, printk(MPT2SAS_INFO_FMT
+	dewtprintk(ioc, printk(MPT2SAS_INFO_FMT
 	    "%s - exit, query_count = %d termination_count = %d\n",
 	    ioc->name, __func__, query_count, termination_count));
+
+	ioc->broadcast_aen_busy = 0;
+	if (!ioc->ioc_reset_in_progress_status)
+		_scsih_ublock_io_all_device(ioc);
+	mutex_unlock(&ioc->tm_cmds.mutex);
 }
 
 /**
@@ -6830,10 +6961,14 @@ mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
 		    mpi_reply->EventData;
 
 		if (baen_data->Primitive !=
-		    MPI2_EVENT_PRIMITIVE_ASYNCHRONOUS_EVENT ||
-		    ioc->broadcast_aen_busy)
+		    MPI2_EVENT_PRIMITIVE_ASYNCHRONOUS_EVENT)
 			return 1;
-		ioc->broadcast_aen_busy = 1;
+
+		if (ioc->broadcast_aen_busy) {
+			ioc->broadcast_aen_pending++;
+			return 1;
+		} else
+			ioc->broadcast_aen_busy = 1;
 		break;
 	}
 
