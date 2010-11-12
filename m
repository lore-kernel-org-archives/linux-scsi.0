From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 07/11] mpt2sas: Remove code for TASK_SET_FULL from driver.
Date: Sat, 13 Nov 2010 04:37:36 +0530
Message-ID: <20101112230729.GI853@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:37815 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933178Ab0KLXuB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Nov 2010 18:50:01 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

remove support for MPI2_EVENT_TASK_SET_FULL
This event is obsoleted, so this processing of this event
needs to be removed from the driver.  The controller firmware is going
to handle TASK_SET_FULL, the driver doesn't need to do anything.
Even though we are removing the EVENT handling, the behavour has not
changed between driver versions becuase fimrware will still be handling
queue throttling, and retrying of commands when the target device queues
are full.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index c8f39f8..b2a8170 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -518,9 +518,6 @@ _base_display_event_data(struct MPT2SAS_ADAPTER *ioc,
 	case MPI2_EVENT_EVENT_CHANGE:
 		desc = "Event Change";
 		break;
-	case MPI2_EVENT_TASK_SET_FULL:
-		desc = "Task Set Full";
-		break;
 	case MPI2_EVENT_SAS_DEVICE_STATUS_CHANGE:
 		desc = "Device Status Change";
 		break;
@@ -3863,7 +3860,6 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 	_base_unmask_events(ioc, MPI2_EVENT_IR_VOLUME);
 	_base_unmask_events(ioc, MPI2_EVENT_IR_PHYSICAL_DISK);
 	_base_unmask_events(ioc, MPI2_EVENT_IR_OPERATION_STATUS);
-	_base_unmask_events(ioc, MPI2_EVENT_TASK_SET_FULL);
 	_base_unmask_events(ioc, MPI2_EVENT_LOG_ENTRY_ADDED);
 	r = _base_make_ioc_operational(ioc, CAN_SLEEP);
 	if (r)
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 0c17352..dc10e1c 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -5815,90 +5815,6 @@ _scsih_sas_ir_operation_status_event(struct MPT2SAS_ADAPTER *ioc,
 }
 
 /**
- * _scsih_task_set_full - handle task set full
- * @ioc: per adapter object
- * @fw_event: The fw_event_work object
- * Context: user.
- *
- * Throttle back qdepth.
- */
-static void
-_scsih_task_set_full(struct MPT2SAS_ADAPTER *ioc, struct fw_event_work
-	*fw_event)
-{
-	unsigned long flags;
-	struct _sas_device *sas_device;
-	static struct _raid_device *raid_device;
-	struct scsi_device *sdev;
-	int depth;
-	u16 current_depth;
-	u16 handle;
-	int id, channel;
-	u64 sas_address;
-	Mpi2EventDataTaskSetFull_t *event_data = fw_event->event_data;
-
-	current_depth = le16_to_cpu(event_data->CurrentDepth);
-	handle = le16_to_cpu(event_data->DevHandle);
-	spin_lock_irqsave(&ioc->sas_device_lock, flags);
-	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
-	if (!sas_device) {
-		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
-		return;
-	}
-	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
-	id = sas_device->id;
-	channel = sas_device->channel;
-	sas_address = sas_device->sas_address;
-
-	/* if hidden raid component, then change to volume characteristics */
-	if (test_bit(handle, ioc->pd_handles) && sas_device->volume_handle) {
-		spin_lock_irqsave(&ioc->raid_device_lock, flags);
-		raid_device = _scsih_raid_device_find_by_handle(
-		    ioc, sas_device->volume_handle);
-		spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
-		if (raid_device) {
-			id = raid_device->id;
-			channel = raid_device->channel;
-			handle = raid_device->handle;
-			sas_address = raid_device->wwid;
-		}
-	}
-
-	if (ioc->logging_level & MPT_DEBUG_TASK_SET_FULL)
-		starget_printk(KERN_INFO, sas_device->starget, "task set "
-		    "full: handle(0x%04x), sas_addr(0x%016llx), depth(%d)\n",
-		    handle, (unsigned long long)sas_address, current_depth);
-
-	shost_for_each_device(sdev, ioc->shost) {
-		if (sdev->id == id && sdev->channel == channel) {
-			if (current_depth > sdev->queue_depth) {
-				if (ioc->logging_level &
-				    MPT_DEBUG_TASK_SET_FULL)
-					sdev_printk(KERN_INFO, sdev, "strange "
-					    "observation, the queue depth is"
-					    " (%d) meanwhile fw queue depth "
-					    "is (%d)\n", sdev->queue_depth,
-					    current_depth);
-				continue;
-			}
-			depth = scsi_track_queue_full(sdev,
-			    current_depth - 1);
-			if (depth > 0)
-				sdev_printk(KERN_INFO, sdev, "Queue depth "
-				    "reduced to (%d)\n", depth);
-			else if (depth < 0)
-				sdev_printk(KERN_INFO, sdev, "Tagged Command "
-				    "Queueing is being disabled\n");
-			else if (depth == 0)
-				if (ioc->logging_level &
-				     MPT_DEBUG_TASK_SET_FULL)
-					sdev_printk(KERN_INFO, sdev,
-					     "Queue depth not changed yet\n");
-		}
-	}
-}
-
-/**
  * _scsih_prep_device_scan - initialize parameters prior to device scan
  * @ioc: per adapter object
  *
@@ -6385,9 +6301,6 @@ _firmware_event_work(struct work_struct *work)
 	case MPI2_EVENT_IR_OPERATION_STATUS:
 		_scsih_sas_ir_operation_status_event(ioc, fw_event);
 		break;
-	case MPI2_EVENT_TASK_SET_FULL:
-		_scsih_task_set_full(ioc, fw_event);
-		break;
 	}
 	_scsih_fw_event_free(ioc, fw_event);
 }
@@ -6457,7 +6370,6 @@ mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
 	case MPI2_EVENT_SAS_DISCOVERY:
 	case MPI2_EVENT_SAS_ENCL_DEVICE_STATUS_CHANGE:
 	case MPI2_EVENT_IR_PHYSICAL_DISK:
-	case MPI2_EVENT_TASK_SET_FULL:
 		break;
 
 	default: /* ignore the rest */
