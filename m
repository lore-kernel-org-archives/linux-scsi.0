From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH 16/22] [SCSI] mpt3sas: Provides the physical location of sas drives
Date: Thu, 20 Nov 2014 12:35:49 +0530
Message-ID: <1416467155-16869-17-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1416467155-16869-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og106.obsmtp.com ([64.18.2.165]:34635 "EHLO
	exprod7og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756907AbaKTHNu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Nov 2014 02:13:50 -0500
Received: by mail-pd0-f179.google.com with SMTP id w10so2534701pde.38
        for <linux-scsi@vger.kernel.org>; Wed, 19 Nov 2014 23:13:37 -0800 (PST)
In-Reply-To: <1416467155-16869-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

This Patch will provide more details of the devices such as slot number, enclosure logical id, enclosure level & connector name in the following scenarios,

- When end device is added in the topology,
- When the end device is removed from the setup,
- When the SCSI mid layer issues TASK ABORT/ DEVICE RESET/ TARGET RESET during error handling,
- When any command to the device fails with Sense key Hardware error or Medium error or Unit Attention,
- When firmware returns device error or device not ready status for the end device,
- When a Predicted fault is detected on an end device.

This information can be used by the user to identify the location of the desired drive in the topology.

Driver will get these information by reading the sas device page0.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h  |   2 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 238 +++++++++++++++++++++++++++++------
 2 files changed, 201 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 7dd5510..dba4d66 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -317,6 +317,8 @@ struct _sas_device {
 	u8	fast_path;
 	u8	pfa_led_on;
 	u8	pend_sas_rphy_add;
+	u8   enclosure_level;
+	u8   connector_name[4];
 };
 
 /**
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 1ca5f98..9c77045 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -590,6 +590,22 @@ _scsih_sas_device_remove(struct MPT3SAS_ADAPTER *ioc,
 
 	if (!sas_device)
 		return;
+	pr_info(MPT3SAS_FMT
+	    "removing handle(0x%04x), sas_addr(0x%016llx)\n",
+	    ioc->name, sas_device->handle,
+	    (unsigned long long) sas_device->sas_address);
+
+	if (sas_device->enclosure_handle != 0)
+		pr_info(MPT3SAS_FMT
+		   "removing enclosure logical id(0x%016llx), slot(%d)\n",
+		   ioc->name, (unsigned long long)
+		   sas_device->enclosure_logical_id, sas_device->slot);
+
+	if (sas_device->connector_name[0] != '\0')
+		pr_info(MPT3SAS_FMT
+		   "removing enclosure level(0x%04x), connector name( %s)\n",
+		   ioc->name, sas_device->enclosure_level,
+		   sas_device->connector_name);
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	list_del(&sas_device->list);
@@ -668,6 +684,18 @@ _scsih_sas_device_add(struct MPT3SAS_ADAPTER *ioc,
 		ioc->name, __func__, sas_device->handle,
 		(unsigned long long)sas_device->sas_address));
 
+	if (sas_device->enclosure_handle != 0)
+		dewtprintk(ioc, pr_info(MPT3SAS_FMT
+		    "%s: enclosure logical id(0x%016llx), slot( %d)\n",
+		    ioc->name, __func__, (unsigned long long)
+		    sas_device->enclosure_logical_id, sas_device->slot));
+
+	if (sas_device->connector_name[0] != '\0')
+		dewtprintk(ioc, pr_info(MPT3SAS_FMT
+		    "%s: enclosure level(0x%04x), connector name( %s)\n",
+		    ioc->name, __func__,
+		    sas_device->enclosure_level, sas_device->connector_name));
+
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	list_add_tail(&sas_device->list, &ioc->sas_device_list);
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
@@ -709,6 +737,18 @@ _scsih_sas_device_init_add(struct MPT3SAS_ADAPTER *ioc,
 		__func__, sas_device->handle,
 		(unsigned long long)sas_device->sas_address));
 
+	if (sas_device->enclosure_handle != 0)
+		dewtprintk(ioc, pr_info(MPT3SAS_FMT
+		    "%s: enclosure logical id(0x%016llx), slot( %d)\n",
+		    ioc->name, __func__, (unsigned long long)
+		    sas_device->enclosure_logical_id, sas_device->slot));
+
+	if (sas_device->connector_name[0] != '\0')
+		dewtprintk(ioc, pr_info(MPT3SAS_FMT
+		    "%s: enclosure level(0x%04x), connector name( %s)\n",
+		    ioc->name, __func__, sas_device->enclosure_level,
+		    sas_device->connector_name));
+
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	list_add_tail(&sas_device->list, &ioc->sas_device_init_list);
 	_scsih_determine_boot_device(ioc, sas_device, 0);
@@ -1800,10 +1840,16 @@ _scsih_slave_configure(struct scsi_device *sdev)
 	    "sas_addr(0x%016llx), phy(%d), device_name(0x%016llx)\n",
 	    ds, handle, (unsigned long long)sas_device->sas_address,
 	    sas_device->phy, (unsigned long long)sas_device->device_name);
-	sdev_printk(KERN_INFO, sdev,
-		"%s: enclosure_logical_id(0x%016llx), slot(%d)\n",
-		ds, (unsigned long long)
-	    sas_device->enclosure_logical_id, sas_device->slot);
+	if (sas_device->enclosure_handle != 0)
+		sdev_printk(KERN_INFO, sdev,
+		     "%s: enclosure_logical_id(0x%016llx), slot(%d)\n",
+		     ds, (unsigned long long)
+		     sas_device->enclosure_logical_id, sas_device->slot);
+	if (sas_device->connector_name[0] != '\0')
+		sdev_printk(KERN_INFO, sdev,
+		     "%s: enclosure level(0x%04x), connector name( %s)\n",
+		     ds, sas_device->enclosure_level,
+		     sas_device->connector_name);
 
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 
@@ -2217,10 +2263,17 @@ _scsih_tm_display_info(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd)
 			    sas_device->handle,
 			    (unsigned long long)sas_device->sas_address,
 			    sas_device->phy);
-			starget_printk(KERN_INFO, starget,
-			    "enclosure_logical_id(0x%016llx), slot(%d)\n",
-			   (unsigned long long)sas_device->enclosure_logical_id,
-			    sas_device->slot);
+			if (sas_device->enclosure_handle != 0)
+				starget_printk(KERN_INFO, starget,
+				 "enclosure_logical_id(0x%016llx), slot(%d)\n",
+				 (unsigned long long)
+				 sas_device->enclosure_logical_id,
+				 sas_device->slot);
+			if (sas_device->connector_name)
+				starget_printk(KERN_INFO, starget,
+				"enclosure level(0x%04x),connector name(%s)\n",
+				 sas_device->enclosure_level,
+				 sas_device->connector_name);
 		}
 		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 	}
@@ -2882,6 +2935,18 @@ _scsih_tm_tr_send(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 			"setting delete flag: handle(0x%04x), sas_addr(0x%016llx)\n",
 			ioc->name, handle,
 		    (unsigned long long)sas_address));
+		if (sas_device->enclosure_handle != 0)
+			dewtprintk(ioc, pr_info(MPT3SAS_FMT
+			 "setting delete flag:enclosure logical id(0x%016llx),"
+			 " slot(%d)\n", ioc->name, (unsigned long long)
+			  sas_device->enclosure_logical_id,
+			  sas_device->slot));
+		if (sas_device->connector_name)
+			dewtprintk(ioc, pr_info(MPT3SAS_FMT
+			 "setting delete flag: enclosure level(0x%04x),"
+			 " connector name( %s)\n", ioc->name,
+			  sas_device->enclosure_level,
+			  sas_device->connector_name));
 		_scsih_ublock_io_device(ioc, sas_address);
 		sas_target_priv_data->handle = MPT3SAS_INVALID_DEVICE_HANDLE;
 	}
@@ -3897,10 +3962,19 @@ _scsih_scsi_ioc_info(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 				"\tsas_address(0x%016llx), phy(%d)\n",
 				ioc->name, (unsigned long long)
 			    sas_device->sas_address, sas_device->phy);
-			pr_warn(MPT3SAS_FMT
-			    "\tenclosure_logical_id(0x%016llx), slot(%d)\n",
-			    ioc->name, (unsigned long long)
-			    sas_device->enclosure_logical_id, sas_device->slot);
+			if (sas_device->enclosure_handle != 0)
+				pr_warn(MPT3SAS_FMT
+				  "\tenclosure_logical_id(0x%016llx),"
+				  "slot(%d)\n", ioc->name,
+				  (unsigned long long)
+				  sas_device->enclosure_logical_id,
+				  sas_device->slot);
+			if (sas_device->connector_name[0])
+				pr_warn(MPT3SAS_FMT
+				  "\tenclosure level(0x%04x),"
+				  " connector name( %s)\n", ioc->name,
+				  sas_device->enclosure_level,
+				  sas_device->connector_name);
 		}
 		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 	}
@@ -4075,7 +4149,16 @@ _scsih_smart_predicted_fault(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 		return;
 	}
-	starget_printk(KERN_WARNING, starget, "predicted fault\n");
+	if (sas_device->enclosure_handle != 0)
+		starget_printk(KERN_INFO, starget, "predicted fault, "
+			"enclosure logical id(0x%016llx), slot(%d)\n",
+			(unsigned long long)sas_device->enclosure_logical_id,
+			sas_device->slot);
+	if (sas_device->connector_name[0] != '\0')
+		starget_printk(KERN_WARNING, starget, "predicted fault, "
+			"enclosure level(0x%04x), connector name( %s)\n",
+			sas_device->enclosure_level,
+			sas_device->connector_name);
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 
 	if (ioc->pdev->subsystem_vendor == PCI_VENDOR_ID_IBM)
@@ -4195,8 +4278,13 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 			_scsih_smart_predicted_fault(ioc,
 			    le16_to_cpu(mpi_reply->DevHandle));
 		mpt3sas_trigger_scsi(ioc, data.skey, data.asc, data.ascq);
-	}
 
+		if (!(ioc->logging_level & MPT_DEBUG_REPLY) &&
+		     ((scmd->sense_buffer[2] == UNIT_ATTENTION) ||
+		     (scmd->sense_buffer[2] == MEDIUM_ERROR) ||
+		     (scmd->sense_buffer[2] == HARDWARE_ERROR)))
+			_scsih_scsi_ioc_info(ioc , scmd, mpi_reply, smid);
+		}
 	switch (ioc_status) {
 	case MPI2_IOCSTATUS_BUSY:
 	case MPI2_IOCSTATUS_INSUFFICIENT_RESOURCES:
@@ -4864,6 +4952,16 @@ _scsih_check_device(struct MPT3SAS_ADAPTER *ioc,
 			sas_device->handle, handle);
 		sas_target_priv_data->handle = handle;
 		sas_device->handle = handle;
+		if (sas_device_pg0.Flags &
+		     MPI2_SAS_DEVICE0_FLAGS_ENCL_LEVEL_VALID) {
+			sas_device->enclosure_level =
+				le16_to_cpu(sas_device_pg0.EnclosureLevel);
+			memcpy(&sas_device->connector_name[0],
+				&sas_device_pg0.ConnectorName[0], 4);
+		} else {
+			sas_device->enclosure_level = 0;
+			sas_device->connector_name[0] = '\0';
+		}
 	}
 
 	/* check if device is present */
@@ -4970,14 +5068,24 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phy_num,
 		    ioc->name, __FILE__, __LINE__, __func__);
 	sas_device->enclosure_handle =
 	    le16_to_cpu(sas_device_pg0.EnclosureHandle);
-	sas_device->slot =
-	    le16_to_cpu(sas_device_pg0.Slot);
+	if (sas_device->enclosure_handle != 0)
+		sas_device->slot =
+		    le16_to_cpu(sas_device_pg0.Slot);
 	sas_device->device_info = device_info;
 	sas_device->sas_address = sas_address;
 	sas_device->phy = sas_device_pg0.PhyNum;
 	sas_device->fast_path = (le16_to_cpu(sas_device_pg0.Flags) &
 	    MPI25_SAS_DEVICE0_FLAGS_FAST_PATH_CAPABLE) ? 1 : 0;
 
+	if (sas_device_pg0.Flags & MPI2_SAS_DEVICE0_FLAGS_ENCL_LEVEL_VALID) {
+		sas_device->enclosure_level =
+			le16_to_cpu(sas_device_pg0.EnclosureLevel);
+		memcpy(&sas_device->connector_name[0],
+			&sas_device_pg0.ConnectorName[0], 4);
+	} else {
+		sas_device->enclosure_level = 0;
+		sas_device->connector_name[0] = '\0';
+	}
 	/* get enclosure_logical_id */
 	if (sas_device->enclosure_handle && !(mpt3sas_config_get_enclosure_pg0(
 	   ioc, &mpi_reply, &enclosure_pg0, MPI2_SAS_ENCLOS_PGAD_FORM_HANDLE,
@@ -5019,6 +5127,18 @@ _scsih_remove_device(struct MPT3SAS_ADAPTER *ioc,
 		ioc->name, __func__,
 	    sas_device->handle, (unsigned long long)
 	    sas_device->sas_address));
+	if (sas_device->enclosure_handle != 0)
+		dewtprintk(ioc, pr_info(MPT3SAS_FMT
+		    "%s: enter: enclosure logical id(0x%016llx), slot(%d)\n",
+		    ioc->name, __func__,
+		    (unsigned long long)sas_device->enclosure_logical_id,
+		    sas_device->slot));
+	if (sas_device->connector_name[0] != '\0')
+		dewtprintk(ioc, pr_info(MPT3SAS_FMT
+		  "%s: enter: enclosure level(0x%04x), connector name( %s)\n",
+		  ioc->name, __func__,
+		  sas_device->enclosure_level,
+		  sas_device->connector_name));
 
 	if (sas_device->starget && sas_device->starget->hostdata) {
 		sas_target_priv_data = sas_device->starget->hostdata;
@@ -5035,12 +5155,34 @@ _scsih_remove_device(struct MPT3SAS_ADAPTER *ioc,
 		"removing handle(0x%04x), sas_addr(0x%016llx)\n",
 		ioc->name, sas_device->handle,
 	    (unsigned long long) sas_device->sas_address);
+	if (sas_device->enclosure_handle != 0)
+		pr_info(MPT3SAS_FMT
+		  "removing : enclosure logical id(0x%016llx), slot(%d)\n",
+		  ioc->name,
+		  (unsigned long long)sas_device->enclosure_logical_id,
+		  sas_device->slot);
+	if (sas_device->connector_name[0] != '\0')
+		pr_info(MPT3SAS_FMT
+		  "removing enclosure level(0x%04x), connector name( %s)\n",
+		  ioc->name, sas_device->enclosure_level,
+		  sas_device->connector_name);
 
 	dewtprintk(ioc, pr_info(MPT3SAS_FMT
 		"%s: exit: handle(0x%04x), sas_addr(0x%016llx)\n",
 		ioc->name, __func__,
-	    sas_device->handle, (unsigned long long)
-	    sas_device->sas_address));
+		sas_device->handle, (unsigned long long)
+		sas_device->sas_address));
+	if (sas_device->enclosure_handle != 0)
+		dewtprintk(ioc, pr_info(MPT3SAS_FMT
+		    "%s: exit: enclosure logical id(0x%016llx), slot(%d)\n",
+		    ioc->name, __func__,
+		    (unsigned long long)sas_device->enclosure_logical_id,
+		    sas_device->slot));
+	if (sas_device->connector_name[0] != '\0')
+		dewtprintk(ioc, pr_info(MPT3SAS_FMT
+		    "%s: exit: enclosure level(0x%04x), connector name(%s)\n",
+		    ioc->name, __func__, sas_device->enclosure_level,
+		    sas_device->connector_name));
 
 	kfree(sas_device);
 }
@@ -6433,9 +6575,7 @@ _scsih_prep_device_scan(struct MPT3SAS_ADAPTER *ioc)
 /**
  * _scsih_mark_responding_sas_device - mark a sas_devices as responding
  * @ioc: per adapter object
- * @sas_address: sas address
- * @slot: enclosure slot id
- * @handle: device handle
+ * @sas_device_pg0: SAS Device page 0
  *
  * After host reset, find out whether devices are still responding.
  * Used in _scsih_remove_unresponsive_sas_devices.
@@ -6443,8 +6583,8 @@ _scsih_prep_device_scan(struct MPT3SAS_ADAPTER *ioc)
  * Return nothing.
  */
 static void
-_scsih_mark_responding_sas_device(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
-	u16 slot, u16 handle)
+_scsih_mark_responding_sas_device(struct MPT3SAS_ADAPTER *ioc,
+Mpi2SasDevicePage0_t *sas_device_pg0)
 {
 	struct MPT3SAS_TARGET *sas_target_priv_data = NULL;
 	struct scsi_target *starget;
@@ -6453,8 +6593,8 @@ _scsih_mark_responding_sas_device(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	list_for_each_entry(sas_device, &ioc->sas_device_list, list) {
-		if (sas_device->sas_address == sas_address &&
-		    sas_device->slot == slot) {
+		if ((sas_device->sas_address == sas_device_pg0->SASAddress) &&
+			(sas_device->slot == sas_device_pg0->Slot)) {
 			sas_device->responding = 1;
 			starget = sas_device->starget;
 			if (starget && starget->hostdata) {
@@ -6463,22 +6603,40 @@ _scsih_mark_responding_sas_device(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
 				sas_target_priv_data->deleted = 0;
 			} else
 				sas_target_priv_data = NULL;
-			if (starget)
+			if (starget) {
 				starget_printk(KERN_INFO, starget,
-				    "handle(0x%04x), sas_addr(0x%016llx), "
-				    "enclosure logical id(0x%016llx), "
-				    "slot(%d)\n", handle,
-				    (unsigned long long)sas_device->sas_address,
+				    "handle(0x%04x), sas_addr(0x%016llx)\n",
+				    sas_device_pg0->DevHandle,
 				    (unsigned long long)
-				    sas_device->enclosure_logical_id,
-				    sas_device->slot);
-			if (sas_device->handle == handle)
+				    sas_device->sas_address);
+
+				if (sas_device->enclosure_handle != 0)
+					starget_printk(KERN_INFO, starget,
+					 "enclosure logical id(0x%016llx),"
+					 " slot(%d)\n",
+					 (unsigned long long)
+					 sas_device->enclosure_logical_id,
+					 sas_device->slot);
+			}
+			if (sas_device_pg0->Flags &
+			      MPI2_SAS_DEVICE0_FLAGS_ENCL_LEVEL_VALID) {
+				sas_device->enclosure_level =
+				   le16_to_cpu(sas_device_pg0->EnclosureLevel);
+				memcpy(&sas_device->connector_name[0],
+					&sas_device_pg0->ConnectorName[0], 4);
+			} else {
+				sas_device->enclosure_level = 0;
+				sas_device->connector_name[0] = '\0';
+			}
+
+			if (sas_device->handle == sas_device_pg0->DevHandle)
 				goto out;
 			pr_info("\thandle changed from(0x%04x)!!!\n",
 			    sas_device->handle);
-			sas_device->handle = handle;
+			sas_device->handle = sas_device_pg0->DevHandle;
 			if (sas_target_priv_data)
-				sas_target_priv_data->handle = handle;
+				sas_target_priv_data->handle =
+					sas_device_pg0->DevHandle;
 			goto out;
 		}
 	}
@@ -6517,13 +6675,15 @@ _scsih_search_responding_sas_devices(struct MPT3SAS_ADAPTER *ioc)
 		    MPI2_IOCSTATUS_MASK;
 		if (ioc_status != MPI2_IOCSTATUS_SUCCESS)
 			break;
-		handle = le16_to_cpu(sas_device_pg0.DevHandle);
+		handle = sas_device_pg0.DevHandle =
+				le16_to_cpu(sas_device_pg0.DevHandle);
 		device_info = le32_to_cpu(sas_device_pg0.DeviceInfo);
 		if (!(_scsih_is_end_device(device_info)))
 			continue;
-		_scsih_mark_responding_sas_device(ioc,
-		    le64_to_cpu(sas_device_pg0.SASAddress),
-		    le16_to_cpu(sas_device_pg0.Slot), handle);
+		sas_device_pg0.SASAddress =
+				le64_to_cpu(sas_device_pg0.SASAddress);
+		sas_device_pg0.Slot = le16_to_cpu(sas_device_pg0.Slot);
+		_scsih_mark_responding_sas_device(ioc, &sas_device_pg0);
 	}
 
  out:
-- 
2.0.2

