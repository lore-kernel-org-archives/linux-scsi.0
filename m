From: <nagalakshmi.nandigama@lsi.com>
Subject: RESEND [PATCH 08/10] mpt2sas: Fix for issue Port Reset taking
 long time(around 5 mins) to complete while issued during creating a volume
Date: Wed, 19 Oct 2011 15:37:37 +0530
Message-ID: <201110191613.p9JGDYS2026507@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:37742 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756435Ab1JSQNm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Oct 2011 12:13:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, kashyap.desai@lsi.com, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com
Cc: JBottomley@parallels.com

Fix for issue Port Reset is taking long time(around 5 mins) to complete
while issued during creating a volume.

This is due to the slave_configuration routine is getting called when
host reset is active, and config page reads are failing, and driver
attempts to added device with stale config data.

To fix the issue, added error checking in slave_configure to check
for configuration pages failing, and return "1" so the device  is
not configured.  The config pages are failing if raid volume is
configured while issuing a host reset, thus driver is reading stale
data and proceeding to attempt to add.  The fix is to return error 
so the volume is not configured.  


Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 6478cb3..bd25cf1 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -1621,8 +1621,10 @@ _scsih_set_level(struct scsi_device *sdev, struct _raid_device *raid_device)
  * _scsih_get_volume_capabilities - volume capabilities
  * @ioc: per adapter object
  * @sas_device: the raid_device object
+ *
+ * Returns 0 for success, else 1
  */
-static void
+static int
 _scsih_get_volume_capabilities(struct MPT2SAS_ADAPTER *ioc,
     struct _raid_device *raid_device)
 {
@@ -1635,9 +1637,10 @@ _scsih_get_volume_capabilities(struct MPT2SAS_ADAPTER *ioc,
 
 	if ((mpt2sas_config_get_number_pds(ioc, raid_device->handle,
 	    &num_pds)) || !num_pds) {
-		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
-		return;
+		dfailprintk(ioc, printk(MPT2SAS_WARN_FMT
+		    "failure at %s:%d/%s()!\n", ioc->name, __FILE__, __LINE__,
+		    __func__));
+		return 1;
 	}
 
 	raid_device->num_pds = num_pds;
@@ -1645,17 +1648,19 @@ _scsih_get_volume_capabilities(struct MPT2SAS_ADAPTER *ioc,
 	    sizeof(Mpi2RaidVol0PhysDisk_t));
 	vol_pg0 = kzalloc(sz, GFP_KERNEL);
 	if (!vol_pg0) {
-		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
-		return;
+		dfailprintk(ioc, printk(MPT2SAS_WARN_FMT
+		    "failure at %s:%d/%s()!\n", ioc->name, __FILE__, __LINE__,
+		    __func__));
+		return 1;
 	}
 
 	if ((mpt2sas_config_get_raid_volume_pg0(ioc, &mpi_reply, vol_pg0,
 	     MPI2_RAID_VOLUME_PGAD_FORM_HANDLE, raid_device->handle, sz))) {
-		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
+		dfailprintk(ioc, printk(MPT2SAS_WARN_FMT
+		    "failure at %s:%d/%s()!\n", ioc->name, __FILE__, __LINE__,
+		    __func__));
 		kfree(vol_pg0);
-		return;
+		return 1;
 	}
 
 	raid_device->volume_type = vol_pg0->VolumeType;
@@ -1675,6 +1680,7 @@ _scsih_get_volume_capabilities(struct MPT2SAS_ADAPTER *ioc,
 	}
 
 	kfree(vol_pg0);
+	return 0;
 }
 /**
  * _scsih_disable_ddio - Disable direct I/O for all the volumes
@@ -1945,13 +1951,20 @@ _scsih_slave_configure(struct scsi_device *sdev)
 		     sas_target_priv_data->handle);
 		spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
 		if (!raid_device) {
-			printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
-			    ioc->name, __FILE__, __LINE__, __func__);
-			return 0;
+			dfailprintk(ioc, printk(MPT2SAS_WARN_FMT
+			    "failure at %s:%d/%s()!\n", ioc->name, __FILE__,
+			    __LINE__, __func__));
+			return 1;
 		}
 
 		_scsih_get_volume_capabilities(ioc, raid_device);
 
+		if (_scsih_get_volume_capabilities(ioc, raid_device)) {
+			dfailprintk(ioc, printk(MPT2SAS_WARN_FMT
+			    "failure at %s:%d/%s()!\n", ioc->name, __FILE__,
+			    __LINE__, __func__));
+			return 1;
+		}
 		/*
 		 * WARPDRIVE: Initialize the required data for Direct IO
 		 */
@@ -2025,11 +2038,21 @@ _scsih_slave_configure(struct scsi_device *sdev)
 	if (sas_device) {
 		if (sas_target_priv_data->flags &
 		    MPT_TARGET_FLAGS_RAID_COMPONENT) {
-			mpt2sas_config_get_volume_handle(ioc,
-			    sas_device->handle, &sas_device->volume_handle);
-			mpt2sas_config_get_volume_wwid(ioc,
+			if (mpt2sas_config_get_volume_handle(ioc,
+			    sas_device->handle, &sas_device->volume_handle)) {
+				dfailprintk(ioc, printk(MPT2SAS_WARN_FMT
+				    "failure at %s:%d/%s()!\n", ioc->name,
+				    __FILE__, __LINE__, __func__));
+				return 1;
+			}
+			if (mpt2sas_config_get_volume_wwid(ioc,
 			    sas_device->volume_handle,
-			    &sas_device->volume_wwid);
+			    &sas_device->volume_wwid)) {
+				dfailprintk(ioc, printk(MPT2SAS_WARN_FMT
+				    "failure at %s:%d/%s()!\n", ioc->name,
+				    __FILE__, __LINE__, __func__));
+				return 1;
+			}
 		}
 		if (sas_device->device_info & MPI2_SAS_DEVICE_INFO_SSP_TARGET) {
 			qdepth = MPT2SAS_SAS_QUEUE_DEPTH;
@@ -2058,6 +2081,11 @@ _scsih_slave_configure(struct scsi_device *sdev)
 
 		if (!ssp_target)
 			_scsih_display_sata_capabilities(ioc, sas_device, sdev);
+	} else {
+		dfailprintk(ioc, printk(MPT2SAS_WARN_FMT
+		    "failure at %s:%d/%s()!\n", ioc->name, __FILE__, __LINE__,
+		    __func__));
+		return 1;
 	}
 
 	_scsih_change_queue_depth(sdev, qdepth, SCSI_QDEPTH_DEFAULT);
