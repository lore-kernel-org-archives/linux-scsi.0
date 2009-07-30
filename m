From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 3/6] mpt2sas: When activating a inactive volume, hidden raid components disapper
Date: Thu, 30 Jul 2009 18:23:57 +0530
Message-ID: <20090730125351.GD20582@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og112.obsmtp.com ([64.18.2.177]:43700 "EHLO
	exprod7og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbZG3NOk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jul 2009 09:14:40 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


When a volume is activated, the driver will recieve a pair of ir config change events to remove the foreign volume, then add the native.
In the process of the removal event, the hidden raid componet is removed from the parent.
When the disks is added back, the adding of the port fails becuase there is no instance of the device in its parent.
To fix this issue, the driver needs to call mpt2sas_transport_update_links() prior to calling _scsih_add_device.
In addition, we added sanity checks on volume add and removal to ignore events for foreign volumes.

---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Eric Moore <Eric.moore@lsi.com>
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index cf58d69..1ab6b2c 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -4195,12 +4195,6 @@ _scsih_sas_volume_add(struct MPT2SAS_ADAPTER *ioc,
 	u16 handle = le16_to_cpu(element->VolDevHandle);
 	int rc;
 
-#if 0 /* RAID_HACKS */
-	if (le32_to_cpu(event_data->Flags) &
-	    MPI2_EVENT_IR_CHANGE_FLAGS_FOREIGN_CONFIG)
-		return;
-#endif
-
 	mpt2sas_config_get_volume_wwid(ioc, handle, &wwid);
 	if (!wwid) {
 		printk(MPT2SAS_ERR_FMT
@@ -4255,12 +4249,6 @@ _scsih_sas_volume_delete(struct MPT2SAS_ADAPTER *ioc,
 	unsigned long flags;
 	struct MPT2SAS_TARGET *sas_target_priv_data;
 
-#if 0 /* RAID_HACKS */
-	if (le32_to_cpu(event_data->Flags) &
-	    MPI2_EVENT_IR_CHANGE_FLAGS_FOREIGN_CONFIG)
-		return;
-#endif
-
 	spin_lock_irqsave(&ioc->raid_device_lock, flags);
 	raid_device = _scsih_raid_device_find_by_handle(ioc, handle);
 	spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
@@ -4373,14 +4361,38 @@ _scsih_sas_pd_add(struct MPT2SAS_ADAPTER *ioc,
 	struct _sas_device *sas_device;
 	unsigned long flags;
 	u16 handle = le16_to_cpu(element->PhysDiskDevHandle);
+	Mpi2ConfigReply_t mpi_reply;
+	Mpi2SasDevicePage0_t sas_device_pg0;
+	u32 ioc_status;
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
-	if (sas_device)
+	if (sas_device) {
 		sas_device->hidden_raid_component = 1;
-	else
-		_scsih_add_device(ioc, handle, 0, 1);
+		return;
+	}
+
+	if ((mpt2sas_config_get_sas_device_pg0(ioc, &mpi_reply, &sas_device_pg0,
+	    MPI2_SAS_DEVICE_PGAD_FORM_HANDLE, handle))) {
+		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		return;
+	}
+
+	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+	    MPI2_IOCSTATUS_MASK;
+	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		return;
+	}
+
+	mpt2sas_transport_update_links(ioc,
+	    le16_to_cpu(sas_device_pg0.ParentDevHandle),
+	    handle, sas_device_pg0.PhyNum, MPI2_SAS_NEG_LINK_RATE_1_5);
+
+	_scsih_add_device(ioc, handle, 0, 1);
 }
 
 #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
@@ -4480,12 +4492,15 @@ _scsih_sas_ir_config_change_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
 {
 	Mpi2EventIrConfigElement_t *element;
 	int i;
+	u8 foreign_config;
 
 #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
 	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
 		_scsih_sas_ir_config_change_event_debug(ioc, event_data);
 
 #endif
+	foreign_config = (le32_to_cpu(event_data->Flags) &
+	    MPI2_EVENT_IR_CHANGE_FLAGS_FOREIGN_CONFIG) ? 1 : 0;
 
 	element = (Mpi2EventIrConfigElement_t *)&event_data->ConfigElement[0];
 	for (i = 0; i < event_data->NumElements; i++, element++) {
@@ -4493,11 +4508,13 @@ _scsih_sas_ir_config_change_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
 		switch (element->ReasonCode) {
 		case MPI2_EVENT_IR_CHANGE_RC_VOLUME_CREATED:
 		case MPI2_EVENT_IR_CHANGE_RC_ADDED:
-			_scsih_sas_volume_add(ioc, element);
+			if (!foreign_config)
+				_scsih_sas_volume_add(ioc, element);
 			break;
 		case MPI2_EVENT_IR_CHANGE_RC_VOLUME_DELETED:
 		case MPI2_EVENT_IR_CHANGE_RC_REMOVED:
-			_scsih_sas_volume_delete(ioc, element);
+			if (!foreign_config)
+				_scsih_sas_volume_delete(ioc, element);
 			break;
 		case MPI2_EVENT_IR_CHANGE_RC_PD_CREATED:
 			_scsih_sas_pd_hide(ioc, element);
@@ -4616,6 +4633,9 @@ _scsih_sas_ir_physical_disk_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
 	u32 state;
 	struct _sas_device *sas_device;
 	unsigned long flags;
+	Mpi2ConfigReply_t mpi_reply;
+	Mpi2SasDevicePage0_t sas_device_pg0;
+	u32 ioc_status;
 
 	if (event_data->ReasonCode != MPI2_EVENT_IR_PHYSDISK_RC_STATE_CHANGED)
 		return;
@@ -4632,22 +4652,40 @@ _scsih_sas_ir_physical_disk_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 
 	switch (state) {
-#if 0
-	case MPI2_RAID_PD_STATE_OFFLINE:
-		if (sas_device)
-			_scsih_remove_device(ioc, handle);
-		break;
-#endif
 	case MPI2_RAID_PD_STATE_ONLINE:
 	case MPI2_RAID_PD_STATE_DEGRADED:
 	case MPI2_RAID_PD_STATE_REBUILDING:
 	case MPI2_RAID_PD_STATE_OPTIMAL:
-		if (sas_device)
+		if (sas_device) {
 			sas_device->hidden_raid_component = 1;
-		else
-			_scsih_add_device(ioc, handle, 0, 1);
+			return;
+		}
+
+		if ((mpt2sas_config_get_sas_device_pg0(ioc, &mpi_reply,
+		    &sas_device_pg0, MPI2_SAS_DEVICE_PGAD_FORM_HANDLE,
+		    handle))) {
+			printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
+			    ioc->name, __FILE__, __LINE__, __func__);
+			return;
+		}
+
+		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+		    MPI2_IOCSTATUS_MASK;
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+			printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
+			    ioc->name, __FILE__, __LINE__, __func__);
+			return;
+		}
+
+		mpt2sas_transport_update_links(ioc,
+		    le16_to_cpu(sas_device_pg0.ParentDevHandle),
+		    handle, sas_device_pg0.PhyNum, MPI2_SAS_NEG_LINK_RATE_1_5);
+
+		_scsih_add_device(ioc, handle, 0, 1);
+
 		break;
 
+	case MPI2_RAID_PD_STATE_OFFLINE:
 	case MPI2_RAID_PD_STATE_NOT_CONFIGURED:
 	case MPI2_RAID_PD_STATE_NOT_COMPATIBLE:
 	case MPI2_RAID_PD_STATE_HOT_SPARE:
