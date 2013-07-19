From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: [PATCH] mpt2sas: don't handle broadcast primitives
Date: Fri, 19 Jul 2013 18:07:00 -0400
Message-ID: <20130719220659.GF29404@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com, "James E.J. Bottomley" <JBottomley@parallels.com>, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mit@purestorage.com
List-Id: linux-scsi@vger.kernel.org

The handling of broadcast primitives involves
_scsih_block_io_all_device(), which does what the name implies.  I have
observed cases with >60s of blocking io on all devices, caused by a
single bad device.  The downsides of this code are obvious, while the
upsides are more elusive.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c  |    4 -
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |  238 ----------------------------------
 2 files changed, 242 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 21c0a27..bba2209 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -586,9 +586,6 @@ _base_display_event_data(struct MPT2SAS_ADAPTER *ioc,
 		printk("\n");
 		return;
 	}
-	case MPI2_EVENT_SAS_BROADCAST_PRIMITIVE:
-		desc = "SAS Broadcast Primitive";
-		break;
 	case MPI2_EVENT_SAS_INIT_DEVICE_STATUS_CHANGE:
 		desc = "SAS Init Device Status Change";
 		break;
@@ -4370,7 +4367,6 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 
 	/* here we enable the events we care about */
 	_base_unmask_events(ioc, MPI2_EVENT_SAS_DISCOVERY);
-	_base_unmask_events(ioc, MPI2_EVENT_SAS_BROADCAST_PRIMITIVE);
 	_base_unmask_events(ioc, MPI2_EVENT_SAS_TOPOLOGY_CHANGE_LIST);
 	_base_unmask_events(ioc, MPI2_EVENT_SAS_DEVICE_STATUS_CHANGE);
 	_base_unmask_events(ioc, MPI2_EVENT_SAS_ENCL_DEVICE_STATUS_CHANGE);
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 3fffb95..856a502 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2915,31 +2915,6 @@ _scsih_fw_event_cleanup_queue(struct MPT2SAS_ADAPTER *ioc)
 }
 
 /**
- * _scsih_ublock_io_all_device - unblock every device
- * @ioc: per adapter object
- *
- * change the device state from block to running
- */
-static void
-_scsih_ublock_io_all_device(struct MPT2SAS_ADAPTER *ioc)
-{
-	struct MPT2SAS_DEVICE *sas_device_priv_data;
-	struct scsi_device *sdev;
-
-	shost_for_each_device(sdev, ioc->shost) {
-		sas_device_priv_data = sdev->hostdata;
-		if (!sas_device_priv_data)
-			continue;
-		if (!sas_device_priv_data->block)
-			continue;
-		sas_device_priv_data->block = 0;
-		dewtprintk(ioc, sdev_printk(KERN_INFO, sdev, "device_running, "
-		    "handle(0x%04x)\n",
-		    sas_device_priv_data->sas_target->handle));
-		scsi_internal_device_unblock(sdev, SDEV_RUNNING);
-	}
-}
-/**
  * _scsih_ublock_io_device - set the device state to SDEV_RUNNING
  * @ioc: per adapter object
  * @handle: device handle
@@ -2971,34 +2946,6 @@ _scsih_ublock_io_device(struct MPT2SAS_ADAPTER *ioc, u64 sas_address)
 }
 
 /**
- * _scsih_block_io_all_device - set the device state to SDEV_BLOCK
- * @ioc: per adapter object
- * @handle: device handle
- *
- * During device pull we need to appropiately set the sdev state.
- */
-static void
-_scsih_block_io_all_device(struct MPT2SAS_ADAPTER *ioc)
-{
-	struct MPT2SAS_DEVICE *sas_device_priv_data;
-	struct scsi_device *sdev;
-
-	shost_for_each_device(sdev, ioc->shost) {
-		sas_device_priv_data = sdev->hostdata;
-		if (!sas_device_priv_data)
-			continue;
-		if (sas_device_priv_data->block)
-			continue;
-		sas_device_priv_data->block = 1;
-		dewtprintk(ioc, sdev_printk(KERN_INFO, sdev, "device_blocked, "
-		    "handle(0x%04x)\n",
-		    sas_device_priv_data->sas_target->handle));
-		scsi_internal_device_block(sdev);
-	}
-}
-
-
-/**
  * _scsih_block_io_device - set the device state to SDEV_BLOCK
  * @ioc: per adapter object
  * @handle: device handle
@@ -5829,166 +5776,6 @@ _scsih_sas_enclosure_dev_status_change_event(struct MPT2SAS_ADAPTER *ioc,
 }
 
 /**
- * _scsih_sas_broadcast_primitive_event - handle broadcast events
- * @ioc: per adapter object
- * @fw_event: The fw_event_work object
- * Context: user.
- *
- * Return nothing.
- */
-static void
-_scsih_sas_broadcast_primitive_event(struct MPT2SAS_ADAPTER *ioc,
-    struct fw_event_work *fw_event)
-{
-	struct scsi_cmnd *scmd;
-	unsigned long ser_no;
-	struct scsi_device *sdev;
-	u16 smid, handle;
-	u32 lun;
-	struct MPT2SAS_DEVICE *sas_device_priv_data;
-	u32 termination_count;
-	u32 query_count;
-	Mpi2SCSITaskManagementReply_t *mpi_reply;
-	Mpi2EventDataSasBroadcastPrimitive_t *event_data = fw_event->event_data;
-	u16 ioc_status;
-	unsigned long flags;
-	int r;
-	u8 max_retries = 0;
-	u8 task_abort_retries;
-
-	mutex_lock(&ioc->tm_cmds.mutex);
-	dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: enter: phy number(%d), "
-	    "width(%d)\n", ioc->name, __func__, event_data->PhyNum,
-	     event_data->PortWidth));
-
-	_scsih_block_io_all_device(ioc);
-
-	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	mpi_reply = ioc->tm_cmds.reply;
-broadcast_aen_retry:
-
-	/* sanity checks for retrying this loop */
-	if (max_retries++ == 5) {
-		dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: giving up\n",
-		    ioc->name, __func__));
-		goto out;
-	} else if (max_retries > 1)
-		dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: %d retry\n",
-		    ioc->name, __func__, max_retries - 1));
-
-	termination_count = 0;
-	query_count = 0;
-	for (smid = 1; smid <= ioc->scsiio_depth; smid++) {
-		if (ioc->shost_recovery)
-			goto out;
-		scmd = _scsih_scsi_lookup_get(ioc, smid);
-		if (!scmd)
-			continue;
-		sdev = scmd->device;
-		ser_no = scmd->serial_number;
-		sas_device_priv_data = sdev->hostdata;
-		if (!sas_device_priv_data || !sas_device_priv_data->sas_target)
-			continue;
-		 /* skip hidden raid components */
-		if (sas_device_priv_data->sas_target->flags &
-		    MPT_TARGET_FLAGS_RAID_COMPONENT)
-			continue;
-		 /* skip volumes */
-		if (sas_device_priv_data->sas_target->flags &
-		    MPT_TARGET_FLAGS_VOLUME)
-			continue;
-
-		handle = sas_device_priv_data->sas_target->handle;
-		lun = sas_device_priv_data->lun;
-		query_count++;
-
-		if (ioc->shost_recovery)
-			goto out;
-
-		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
-		r = mpt2sas_scsih_issue_tm(ioc, handle, 0, 0, lun,
-		    MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK, smid, 30, 0,
-		    TM_MUTEX_OFF);
-		if (r == FAILED) {
-			sdev_printk(KERN_WARNING, sdev,
-			    "mpt2sas_scsih_issue_tm: FAILED when sending "
-			    "QUERY_TASK: scmd(%p)\n", scmd);
-			spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-			goto broadcast_aen_retry;
-		}
-		ioc_status = le16_to_cpu(mpi_reply->IOCStatus)
-		    & MPI2_IOCSTATUS_MASK;
-		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
-			sdev_printk(KERN_WARNING, sdev, "query task: FAILED "
-			    "with IOCSTATUS(0x%04x), scmd(%p)\n", ioc_status,
-			    scmd);
-			spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-			goto broadcast_aen_retry;
-		}
-
-		/* see if IO is still owned by IOC and target */
-		if (mpi_reply->ResponseCode ==
-		     MPI2_SCSITASKMGMT_RSP_TM_SUCCEEDED ||
-		     mpi_reply->ResponseCode ==
-		     MPI2_SCSITASKMGMT_RSP_IO_QUEUED_ON_IOC) {
-			spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-			continue;
-		}
-		task_abort_retries = 0;
- tm_retry:
-		if (task_abort_retries++ == 60) {
-			dewtprintk(ioc, printk(MPT2SAS_INFO_FMT
-			    "%s: ABORT_TASK: giving up\n", ioc->name,
-			    __func__));
-			spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-			goto broadcast_aen_retry;
-		}
-
-		if (ioc->shost_recovery)
-			goto out_no_lock;
-
-		r = mpt2sas_scsih_issue_tm(ioc, handle, sdev->channel, sdev->id,
-		    sdev->lun, MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK, smid, 30,
-		    ser_no, TM_MUTEX_OFF);
-		if (r == FAILED) {
-			sdev_printk(KERN_WARNING, sdev,
-			    "mpt2sas_scsih_issue_tm: ABORT_TASK: FAILED : "
-			    "scmd(%p)\n", scmd);
-			goto tm_retry;
-		}
-
-		if (task_abort_retries > 1)
-			sdev_printk(KERN_WARNING, sdev,
-			    "mpt2sas_scsih_issue_tm: ABORT_TASK: RETRIES (%d):"
-			    " scmd(%p)\n",
-			    task_abort_retries - 1, scmd);
-
-		termination_count += le32_to_cpu(mpi_reply->TerminationCount);
-		spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	}
-
-	if (ioc->broadcast_aen_pending) {
-		dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: loop back due to"
-		     " pending AEN\n", ioc->name, __func__));
-		 ioc->broadcast_aen_pending = 0;
-		 goto broadcast_aen_retry;
-	}
-
- out:
-	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
- out_no_lock:
-
-	dewtprintk(ioc, printk(MPT2SAS_INFO_FMT
-	    "%s - exit, query_count = %d termination_count = %d\n",
-	    ioc->name, __func__, query_count, termination_count));
-
-	ioc->broadcast_aen_busy = 0;
-	if (!ioc->shost_recovery)
-		_scsih_ublock_io_all_device(ioc);
-	mutex_unlock(&ioc->tm_cmds.mutex);
-}
-
-/**
  * _scsih_sas_discovery_event - handle discovery events
  * @ioc: per adapter object
  * @fw_event: The fw_event_work object
@@ -7081,8 +6868,6 @@ _scsih_remove_unresponding_sas_devices(struct MPT2SAS_ADAPTER *ioc)
 	}
 	printk(MPT2SAS_INFO_FMT "removing unresponding devices: complete\n",
 	    ioc->name);
-	/* unblock devices */
-	_scsih_ublock_io_all_device(ioc);
 }
 
 static void
@@ -7358,10 +7143,6 @@ _firmware_event_work(struct work_struct *work)
 		_scsih_sas_discovery_event(ioc,
 		    fw_event);
 		break;
-	case MPI2_EVENT_SAS_BROADCAST_PRIMITIVE:
-		_scsih_sas_broadcast_primitive_event(ioc,
-		    fw_event);
-		break;
 	case MPI2_EVENT_SAS_ENCL_DEVICE_STATUS_CHANGE:
 		_scsih_sas_enclosure_dev_status_change_event(ioc,
 		    fw_event);
@@ -7419,25 +7200,6 @@ mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
 	event = le16_to_cpu(mpi_reply->Event);
 
 	switch (event) {
-	/* handle these */
-	case MPI2_EVENT_SAS_BROADCAST_PRIMITIVE:
-	{
-		Mpi2EventDataSasBroadcastPrimitive_t *baen_data =
-		    (Mpi2EventDataSasBroadcastPrimitive_t *)
-		    mpi_reply->EventData;
-
-		if (baen_data->Primitive !=
-		    MPI2_EVENT_PRIMITIVE_ASYNCHRONOUS_EVENT)
-			return 1;
-
-		if (ioc->broadcast_aen_busy) {
-			ioc->broadcast_aen_pending++;
-			return 1;
-		} else
-			ioc->broadcast_aen_busy = 1;
-		break;
-	}
-
 	case MPI2_EVENT_SAS_TOPOLOGY_CHANGE_LIST:
 		_scsih_check_topo_delete_events(ioc,
 		    (Mpi2EventDataSasTopologyChangeList_t *)
-- 
1.7.10.4
