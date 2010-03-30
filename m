From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH] mpt2sas : IOs needs to be pause until handles are refreshed for all device after recovery
Date: Tue, 30 Mar 2010 10:52:44 +0530
Message-ID: <20100330052219.GB1271@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:36841 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753990Ab0C3FyZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Mar 2010 01:54:25 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

This patch is taken considering base
mpt2sas version 05.100.00.00.
Last patch set for 05.100.00.00 was sent on 3/17/2010.
Subject lined : "[PATCH 11/11] mpt2sas : Bump version 05.100.00.00"

After Host Reset firmware will have new list of device handles for the target.
Device handle refresh in driver is part of Rescan topology logic.
(See functions like *_search_responding_*). This needs to be done from Host
Reset context before making shost_recovery to 0. Currently it is done in
Firwmare event context, which may leads IO to a wrong device.

Now handler refresh is moved to HBA reset context.
Apart from this, Now driver will stop IOs for all device setting deleted
flag to 1 at the time of HBA Reset through _scsih_prep_device_scan.
It will only unblock devices, if devices has been found as part of RESCAN.
This way it will make more safe IO blocking at the time of HBA reset at
mpt2sas driver layer.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 8e02218..9826139 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -5505,6 +5505,26 @@ _scsih_task_set_full(struct MPT2SAS_ADAPTER *ioc, struct fw_event_work
 }
 
 /**
+ * _scsih_prep_device_scan - initialize parameters prior to device scan
+ * @ioc: per adapter object
+ *
+ * Set the deleted flag prior to device scan.  If the device is found during
+ * the scan, then we clear the deleted flag.
+ */
+static void
+_scsih_prep_device_scan(struct MPT2SAS_ADAPTER *ioc)
+{
+	struct MPT2SAS_DEVICE *sas_device_priv_data;
+	struct scsi_device *sdev;
+
+	shost_for_each_device(sdev, ioc->shost) {
+		sas_device_priv_data = sdev->hostdata;
+		if (sas_device_priv_data && sas_device_priv_data->sas_target)
+			sas_device_priv_data->sas_target->deleted = 1;
+	}
+}
+
+/**
  * _scsih_mark_responding_sas_device - mark a sas_devices as responding
  * @ioc: per adapter object
  * @sas_address: sas address
@@ -5531,8 +5551,12 @@ _scsih_mark_responding_sas_device(struct MPT2SAS_ADAPTER *ioc, u64 sas_address,
 		    sas_device->slot == slot && sas_device->starget) {
 			sas_device->responding = 1;
 			starget = sas_device->starget;
-			sas_target_priv_data = starget->hostdata;
-			sas_target_priv_data->tm_busy = 0;
+			if (starget && starget->hostdata) {
+				sas_target_priv_data = starget->hostdata;
+				sas_target_priv_data->tm_busy = 0;
+				sas_target_priv_data->deleted = 0;
+			} else
+				sas_target_priv_data = NULL;
 			starget_printk(KERN_INFO, sas_device->starget,
 			    "handle(0x%04x), sas_addr(0x%016llx), enclosure "
 			    "logical id(0x%016llx), slot(%d)\n", handle,
@@ -5545,7 +5569,8 @@ _scsih_mark_responding_sas_device(struct MPT2SAS_ADAPTER *ioc, u64 sas_address,
 			printk(KERN_INFO "\thandle changed from(0x%04x)!!!\n",
 			    sas_device->handle);
 			sas_device->handle = handle;
-			sas_target_priv_data->handle = handle;
+			if (sas_target_priv_data)
+				sas_target_priv_data->handle = handle;
 			goto out;
 		}
 	}
@@ -5620,6 +5645,12 @@ _scsih_mark_responding_raid_device(struct MPT2SAS_ADAPTER *ioc, u64 wwid,
 	spin_lock_irqsave(&ioc->raid_device_lock, flags);
 	list_for_each_entry(raid_device, &ioc->raid_device_list, list) {
 		if (raid_device->wwid == wwid && raid_device->starget) {
+			starget = raid_device->starget;
+			if (starget && starget->hostdata) {
+				sas_target_priv_data = starget->hostdata;
+				sas_target_priv_data->deleted = 0;
+			} else
+				sas_target_priv_data = NULL;
 			raid_device->responding = 1;
 			starget_printk(KERN_INFO, raid_device->starget,
 			    "handle(0x%04x), wwid(0x%016llx)\n", handle,
@@ -5629,9 +5660,8 @@ _scsih_mark_responding_raid_device(struct MPT2SAS_ADAPTER *ioc, u64 wwid,
 			printk(KERN_INFO "\thandle changed from(0x%04x)!!!\n",
 			    raid_device->handle);
 			raid_device->handle = handle;
-			starget = raid_device->starget;
-			sas_target_priv_data = starget->hostdata;
-			sas_target_priv_data->handle = handle;
+			if (sas_target_priv_data)
+				sas_target_priv_data->handle = handle;
 			goto out;
 		}
 	}
@@ -5856,6 +5886,10 @@ mpt2sas_scsih_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase)
 		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
 		    "MPT2_IOC_DONE_RESET\n", ioc->name, __func__));
 		_scsih_sas_host_refresh(ioc);
+		_scsih_prep_device_scan(ioc);
+		_scsih_search_responding_sas_devices(ioc);
+		_scsih_search_responding_raid_devices(ioc);
+		_scsih_search_responding_expanders(ioc);
 		break;
 	}
 }
@@ -5893,9 +5927,6 @@ _firmware_event_work(struct work_struct *work)
 		} else
 			spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock,
 			    flags);
-		_scsih_search_responding_sas_devices(ioc);
-		_scsih_search_responding_raid_devices(ioc);
-		_scsih_search_responding_expanders(ioc);
 		_scsih_remove_unresponding_sas_devices(ioc);
 		return;
 	}
