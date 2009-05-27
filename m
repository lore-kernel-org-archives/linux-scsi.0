From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 19/22] mpt fusion: RESEND [2.6.30-rc6] Queue full event handling
Date: Wed, 27 May 2009 18:14:41 +0530
Message-ID: <20090527124436.GT20010@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og106.obsmtp.com ([64.18.2.165]:49347 "EHLO
	exprod7og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760599AbZE0NGF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2009 09:06:05 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Handle Queue full event.
FW will report Queue full event to Driver and driver will handle this queue
full event to SCSI Mid layer.

---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index e9ece65..ec86d88 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -121,6 +121,7 @@ static void mptsas_expander_delete(MPT_ADAPTER *ioc,
 static void mptsas_send_expander_event(struct fw_event_work *fw_event);
 static void mptsas_not_responding_devices(MPT_ADAPTER *ioc);
 static void mptsas_scan_sas_topology(MPT_ADAPTER *ioc);
+static void mptsas_handle_queue_full_event(struct fw_event_work *fw_event);
 static void mptsas_volume_delete(MPT_ADAPTER *ioc, u8 id);
 
 static void mptsas_print_phy_data(MPT_ADAPTER *ioc,
@@ -680,6 +681,18 @@ mptsas_add_device_component_starget_ir(MPT_ADAPTER *ioc,
 		mptsas_add_device_component_by_fw(ioc, phys_disk.PhysDiskBus,
 		    phys_disk.PhysDiskID);
 
+		mutex_lock(&ioc->sas_device_info_mutex);
+		list_for_each_entry(sas_info, &ioc->sas_device_info_list,
+		    list) {
+			if (!sas_info->is_logical_volume &&
+			    (sas_info->fw.channel == phys_disk.PhysDiskBus &&
+			    sas_info->fw.id == phys_disk.PhysDiskID)) {
+				sas_info->is_hidden_raid_component = 1;
+				sas_info->volume_id = starget->id;
+			}
+		}
+		mutex_unlock(&ioc->sas_device_info_mutex);
+
 	}
 
 	/*
@@ -747,6 +760,29 @@ mptsas_add_device_component_starget(MPT_ADAPTER *ioc,
 }
 
 /**
+ *	mptsas_del_device_component_by_os - Once a device has been removed, we
+ *	mark the entry in the list as being cached
+ *	@ioc: Pointer to MPT_ADAPTER structure
+ *	@channel: os mapped id's
+ *	@id:
+ *
+ **/
+static void
+mptsas_del_device_component_by_os(MPT_ADAPTER *ioc, u8 channel, u8 id)
+{
+	struct sas_device_info	*sas_info, *next;
+
+	/*
+	 * Set is_cached flag
+	 */
+	list_for_each_entry_safe(sas_info, next, &ioc->sas_device_info_list,
+		list) {
+		if (sas_info->os.channel == channel && sas_info->os.id == id)
+			sas_info->is_cached = 1;
+	}
+}
+
+/**
  *	mptsas_del_device_components - Cleaning the list
  *	@ioc: Pointer to MPT_ADAPTER structure
  *
@@ -1576,6 +1612,9 @@ mptsas_firmware_event_work(struct work_struct *work)
 	case MPI_EVENT_SAS_PHY_LINK_STATUS:
 		mptsas_send_link_status_event(fw_event);
 		break;
+	case MPI_EVENT_QUEUE_FULL:
+		mptsas_handle_queue_full_event(fw_event);
+		break;
 	}
 }
 
@@ -1705,6 +1744,9 @@ mptsas_target_destroy(struct scsi_target *starget)
 
 	vtarget = starget->hostdata;
 
+	mptsas_del_device_component_by_os(ioc, starget->channel,
+	    starget->id);
+
 
 	if (starget->channel == MPTSAS_RAID_CHANNEL)
 		goto out;
@@ -3397,6 +3439,8 @@ mptsas_not_responding_devices(MPT_ADAPTER *ioc)
 	/* devices, logical volumes */
  redo_device_scan:
 	list_for_each_entry(sas_info, &ioc->sas_device_info_list, list) {
+		if (sas_info->is_cached)
+			continue;
 		if (!sas_info->is_logical_volume) {
 			sas_device.handle = 0;
 			retry_count = 0;
@@ -3606,6 +3650,95 @@ mptsas_scan_sas_topology(MPT_ADAPTER *ioc)
 	}
 }
 
+
+static void
+mptsas_handle_queue_full_event(struct fw_event_work *fw_event)
+{
+	MPT_ADAPTER *ioc;
+	EventDataQueueFull_t *qfull_data;
+	struct sas_device_info *sas_info;
+	struct scsi_device	*sdev;
+	int depth;
+	int id = -1;
+	int channel = -1;
+	int fw_id, fw_channel;
+	u16 current_depth;
+
+
+	ioc = fw_event->ioc;
+	qfull_data = (EventDataQueueFull_t *)fw_event->event_data;
+	fw_id = qfull_data->TargetID;
+	fw_channel = qfull_data->Bus;
+	current_depth = le16_to_cpu(qfull_data->CurrentDepth);
+
+	/* if hidden raid component, look for the volume id */
+	mutex_lock(&ioc->sas_device_info_mutex);
+	if (mptscsih_is_phys_disk(ioc, fw_channel, fw_id)) {
+		list_for_each_entry(sas_info, &ioc->sas_device_info_list,
+		    list) {
+			if (sas_info->is_cached ||
+			    sas_info->is_logical_volume)
+				continue;
+			if (sas_info->is_hidden_raid_component &&
+			    (sas_info->fw.channel == fw_channel &&
+			    sas_info->fw.id == fw_id)) {
+				id = sas_info->volume_id;
+				channel = MPTSAS_RAID_CHANNEL;
+				goto out;
+			}
+		}
+	} else {
+		list_for_each_entry(sas_info, &ioc->sas_device_info_list,
+		    list) {
+			if (sas_info->is_cached ||
+			    sas_info->is_hidden_raid_component ||
+			    sas_info->is_logical_volume)
+				continue;
+			if (sas_info->fw.channel == fw_channel &&
+			    sas_info->fw.id == fw_id) {
+				id = sas_info->os.id;
+				channel = sas_info->os.channel;
+				goto out;
+			}
+		}
+
+	}
+
+ out:
+	mutex_unlock(&ioc->sas_device_info_mutex);
+
+	if (id != -1) {
+		shost_for_each_device(sdev, ioc->sh) {
+			if (sdev->id == id && sdev->channel == channel) {
+				if (current_depth > sdev->queue_depth) {
+					sdev_printk(KERN_INFO, sdev,
+					    "strange observation, the queue "
+					    "depth is (%d) meanwhile fw queue "
+					    "depth (%d)\n", sdev->queue_depth,
+					    current_depth);
+					continue;
+				}
+				depth = scsi_track_queue_full(sdev,
+				    current_depth - 1);
+				if (depth > 0)
+					sdev_printk(KERN_INFO, sdev,
+					"Queue depth reduced to (%d)\n",
+					   depth);
+				else if (depth < 0)
+					sdev_printk(KERN_INFO, sdev,
+					"Tagged Command Queueing is being "
+					"disabled\n");
+				else if (depth == 0)
+					sdev_printk(KERN_INFO, sdev,
+					"Queue depth not changed yet\n");
+			}
+		}
+	}
+
+	mptsas_free_fw_event(ioc, fw_event);
+}
+
+
 static struct mptsas_phyinfo *
 mptsas_find_phyinfo_by_sas_address(MPT_ADAPTER *ioc, u64 sas_address)
 {
diff --git a/drivers/message/fusion/mptsas.h b/drivers/message/fusion/mptsas.h
index 779bb66..7a87ec0 100644
--- a/drivers/message/fusion/mptsas.h
+++ b/drivers/message/fusion/mptsas.h
@@ -83,6 +83,12 @@ struct sas_device_info {
 	u16			slot;		/* enclosure slot id */
 	u64			enclosure_logical_id; /*enclosure address */
 	u8			is_logical_volume; /* is this logical volume */
+	/* this belongs to volume */
+	u8			is_hidden_raid_component;
+	/* this valid when is_hidden_raid_component set */
+	u8			volume_id;
+	/* cached data for a removed device */
+	u8			is_cached;
 };
 
 struct mptsas_hotplug_event {
