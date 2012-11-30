From: <sreekanth.reddy@lsi.com>
Subject: [v2 PATCH 16/20][SCSI] mpt3sas: This patch is part 3 of
 mpt3sas_scsih.c
Date: Fri, 30 Nov 2012 07:55:33 +0530
Message-ID: <20121130022533.GA10300@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:42149 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752947Ab2K2P11 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Nov 2012 10:27:27 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jejb@kernel.org, Nagalakshmi.Nandigama@lsi.com, sreekanth.reddy@lsi.com
Cc: Sathya.Prakash@lsi.com

This patch contains code related to Scsi Host Layer for
MPT (Message Passing Technology) based controllers
This patch is part 3 of mpt3sas_scsih.c


Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Reviewed-by: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
---

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 120d309..05f8045 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -5626,3 +5626,2542 @@ _scsih_ir_fastpath(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phys_disk_num)
 		    FORCE_BIG_HAMMER);
 	return rc;
 }
+
+/**
+ * _scsih_reprobe_lun - reprobing lun
+ * @sdev: scsi device struct
+ * @no_uld_attach: sdev->no_uld_attach flag setting
+ *
+ **/
+static void
+_scsih_reprobe_lun(struct scsi_device *sdev, void *no_uld_attach)
+{
+	int rc;
+	sdev->no_uld_attach = no_uld_attach ? 1 : 0;
+	sdev_printk(KERN_INFO, sdev, "%s raid component\n",
+	    sdev->no_uld_attach ? "hidding" : "exposing");
+	rc = scsi_device_reprobe(sdev);
+}
+
+/**
+ * _scsih_sas_volume_add - add new volume
+ * @ioc: per adapter object
+ * @element: IR config element data
+ * Context: user.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_sas_volume_add(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2EventIrConfigElement_t *element)
+{
+	struct _raid_device *raid_device;
+	unsigned long flags;
+	u64 wwid;
+	u16 handle = le16_to_cpu(element->VolDevHandle);
+	int rc;
+
+	mpt3sas_config_get_volume_wwid(ioc, handle, &wwid);
+	if (!wwid) {
+		pr_err(MPT3SAS_FMT
+		    "failure at %s:%d/%s()!\n", ioc->name,
+		    __FILE__, __LINE__, __func__);
+		return;
+	}
+
+	spin_lock_irqsave(&ioc->raid_device_lock, flags);
+	raid_device = _scsih_raid_device_find_by_wwid(ioc, wwid);
+	spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
+
+	if (raid_device)
+		return;
+
+	raid_device = kzalloc(sizeof(struct _raid_device), GFP_KERNEL);
+	if (!raid_device) {
+		pr_err(MPT3SAS_FMT
+		    "failure at %s:%d/%s()!\n", ioc->name,
+		    __FILE__, __LINE__, __func__);
+		return;
+	}
+
+	raid_device->id = ioc->sas_id++;
+	raid_device->channel = RAID_CHANNEL;
+	raid_device->handle = handle;
+	raid_device->wwid = wwid;
+	_scsih_raid_device_add(ioc, raid_device);
+	if (!ioc->wait_for_discovery_to_complete) {
+		rc = scsi_add_device(ioc->shost, RAID_CHANNEL,
+		    raid_device->id, 0);
+		if (rc)
+			_scsih_raid_device_remove(ioc, raid_device);
+	} else {
+		spin_lock_irqsave(&ioc->raid_device_lock, flags);
+		_scsih_determine_boot_device(ioc, raid_device, 1);
+		spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
+	}
+}
+
+/**
+ * _scsih_sas_volume_delete - delete volume
+ * @ioc: per adapter object
+ * @handle: volume device handle
+ * Context: user.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_sas_volume_delete(struct MPT3SAS_ADAPTER *ioc, u16 handle)
+{
+	struct _raid_device *raid_device;
+	unsigned long flags;
+	struct MPT3SAS_TARGET *sas_target_priv_data;
+	struct scsi_target *starget = NULL;
+
+	spin_lock_irqsave(&ioc->raid_device_lock, flags);
+	raid_device = _scsih_raid_device_find_by_handle(ioc, handle);
+	if (raid_device) {
+		if (raid_device->starget) {
+			starget = raid_device->starget;
+			sas_target_priv_data = starget->hostdata;
+			sas_target_priv_data->deleted = 1;
+		}
+		pr_info(MPT3SAS_FMT "removing handle(0x%04x), wwid(0x%016llx)\n",
+			ioc->name,  raid_device->handle,
+		    (unsigned long long) raid_device->wwid);
+		list_del(&raid_device->list);
+		kfree(raid_device);
+	}
+	spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
+	if (starget)
+		scsi_remove_target(&starget->dev);
+}
+
+/**
+ * _scsih_sas_pd_expose - expose pd component to /dev/sdX
+ * @ioc: per adapter object
+ * @element: IR config element data
+ * Context: user.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_sas_pd_expose(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2EventIrConfigElement_t *element)
+{
+	struct _sas_device *sas_device;
+	struct scsi_target *starget = NULL;
+	struct MPT3SAS_TARGET *sas_target_priv_data;
+	unsigned long flags;
+	u16 handle = le16_to_cpu(element->PhysDiskDevHandle);
+
+	spin_lock_irqsave(&ioc->sas_device_lock, flags);
+	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
+	if (sas_device) {
+		sas_device->volume_handle = 0;
+		sas_device->volume_wwid = 0;
+		clear_bit(handle, ioc->pd_handles);
+		if (sas_device->starget && sas_device->starget->hostdata) {
+			starget = sas_device->starget;
+			sas_target_priv_data = starget->hostdata;
+			sas_target_priv_data->flags &=
+			    ~MPT_TARGET_FLAGS_RAID_COMPONENT;
+		}
+	}
+	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+	if (!sas_device)
+		return;
+
+	/* exposing raid component */
+	if (starget)
+		starget_for_each_device(starget, NULL, _scsih_reprobe_lun);
+}
+
+/**
+ * _scsih_sas_pd_hide - hide pd component from /dev/sdX
+ * @ioc: per adapter object
+ * @element: IR config element data
+ * Context: user.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_sas_pd_hide(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2EventIrConfigElement_t *element)
+{
+	struct _sas_device *sas_device;
+	struct scsi_target *starget = NULL;
+	struct MPT3SAS_TARGET *sas_target_priv_data;
+	unsigned long flags;
+	u16 handle = le16_to_cpu(element->PhysDiskDevHandle);
+	u16 volume_handle = 0;
+	u64 volume_wwid = 0;
+
+	mpt3sas_config_get_volume_handle(ioc, handle, &volume_handle);
+	if (volume_handle)
+		mpt3sas_config_get_volume_wwid(ioc, volume_handle,
+		    &volume_wwid);
+
+	spin_lock_irqsave(&ioc->sas_device_lock, flags);
+	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
+	if (sas_device) {
+		set_bit(handle, ioc->pd_handles);
+		if (sas_device->starget && sas_device->starget->hostdata) {
+			starget = sas_device->starget;
+			sas_target_priv_data = starget->hostdata;
+			sas_target_priv_data->flags |=
+			    MPT_TARGET_FLAGS_RAID_COMPONENT;
+			sas_device->volume_handle = volume_handle;
+			sas_device->volume_wwid = volume_wwid;
+		}
+	}
+	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+	if (!sas_device)
+		return;
+
+	/* hiding raid component */
+	_scsih_ir_fastpath(ioc, handle, element->PhysDiskNum);
+	if (starget)
+		starget_for_each_device(starget, (void *)1, _scsih_reprobe_lun);
+}
+
+/**
+ * _scsih_sas_pd_delete - delete pd component
+ * @ioc: per adapter object
+ * @element: IR config element data
+ * Context: user.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_sas_pd_delete(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2EventIrConfigElement_t *element)
+{
+	u16 handle = le16_to_cpu(element->PhysDiskDevHandle);
+
+	_scsih_device_remove_by_handle(ioc, handle);
+}
+
+/**
+ * _scsih_sas_pd_add - remove pd component
+ * @ioc: per adapter object
+ * @element: IR config element data
+ * Context: user.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_sas_pd_add(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2EventIrConfigElement_t *element)
+{
+	struct _sas_device *sas_device;
+	unsigned long flags;
+	u16 handle = le16_to_cpu(element->PhysDiskDevHandle);
+	Mpi2ConfigReply_t mpi_reply;
+	Mpi2SasDevicePage0_t sas_device_pg0;
+	u32 ioc_status;
+	u64 sas_address;
+	u16 parent_handle;
+
+	set_bit(handle, ioc->pd_handles);
+
+	spin_lock_irqsave(&ioc->sas_device_lock, flags);
+	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
+	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+	if (sas_device) {
+		_scsih_ir_fastpath(ioc, handle, element->PhysDiskNum);
+		return;
+	}
+
+	if ((mpt3sas_config_get_sas_device_pg0(ioc, &mpi_reply, &sas_device_pg0,
+	    MPI2_SAS_DEVICE_PGAD_FORM_HANDLE, handle))) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		return;
+	}
+
+	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+	    MPI2_IOCSTATUS_MASK;
+	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		return;
+	}
+
+	parent_handle = le16_to_cpu(sas_device_pg0.ParentDevHandle);
+	if (!_scsih_get_sas_address(ioc, parent_handle, &sas_address))
+		mpt3sas_transport_update_links(ioc, sas_address, handle,
+		    sas_device_pg0.PhyNum, MPI2_SAS_NEG_LINK_RATE_1_5);
+
+	_scsih_ir_fastpath(ioc, handle, element->PhysDiskNum);
+	_scsih_add_device(ioc, handle, 0, 1);
+}
+
+#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
+/**
+ * _scsih_sas_ir_config_change_event_debug - debug for IR Config Change events
+ * @ioc: per adapter object
+ * @event_data: event data payload
+ * Context: user.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_sas_ir_config_change_event_debug(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2EventDataIrConfigChangeList_t *event_data)
+{
+	Mpi2EventIrConfigElement_t *element;
+	u8 element_type;
+	int i;
+	char *reason_str = NULL, *element_str = NULL;
+
+	element = (Mpi2EventIrConfigElement_t *)&event_data->ConfigElement[0];
+
+	pr_info(MPT3SAS_FMT "raid config change: (%s), elements(%d)\n",
+	    ioc->name, (le32_to_cpu(event_data->Flags) &
+	    MPI2_EVENT_IR_CHANGE_FLAGS_FOREIGN_CONFIG) ?
+	    "foreign" : "native", event_data->NumElements);
+	for (i = 0; i < event_data->NumElements; i++, element++) {
+		switch (element->ReasonCode) {
+		case MPI2_EVENT_IR_CHANGE_RC_ADDED:
+			reason_str = "add";
+			break;
+		case MPI2_EVENT_IR_CHANGE_RC_REMOVED:
+			reason_str = "remove";
+			break;
+		case MPI2_EVENT_IR_CHANGE_RC_NO_CHANGE:
+			reason_str = "no change";
+			break;
+		case MPI2_EVENT_IR_CHANGE_RC_HIDE:
+			reason_str = "hide";
+			break;
+		case MPI2_EVENT_IR_CHANGE_RC_UNHIDE:
+			reason_str = "unhide";
+			break;
+		case MPI2_EVENT_IR_CHANGE_RC_VOLUME_CREATED:
+			reason_str = "volume_created";
+			break;
+		case MPI2_EVENT_IR_CHANGE_RC_VOLUME_DELETED:
+			reason_str = "volume_deleted";
+			break;
+		case MPI2_EVENT_IR_CHANGE_RC_PD_CREATED:
+			reason_str = "pd_created";
+			break;
+		case MPI2_EVENT_IR_CHANGE_RC_PD_DELETED:
+			reason_str = "pd_deleted";
+			break;
+		default:
+			reason_str = "unknown reason";
+			break;
+		}
+		element_type = le16_to_cpu(element->ElementFlags) &
+		    MPI2_EVENT_IR_CHANGE_EFLAGS_ELEMENT_TYPE_MASK;
+		switch (element_type) {
+		case MPI2_EVENT_IR_CHANGE_EFLAGS_VOLUME_ELEMENT:
+			element_str = "volume";
+			break;
+		case MPI2_EVENT_IR_CHANGE_EFLAGS_VOLPHYSDISK_ELEMENT:
+			element_str = "phys disk";
+			break;
+		case MPI2_EVENT_IR_CHANGE_EFLAGS_HOTSPARE_ELEMENT:
+			element_str = "hot spare";
+			break;
+		default:
+			element_str = "unknown element";
+			break;
+		}
+		pr_info("\t(%s:%s), vol handle(0x%04x), " \
+		    "pd handle(0x%04x), pd num(0x%02x)\n", element_str,
+		    reason_str, le16_to_cpu(element->VolDevHandle),
+		    le16_to_cpu(element->PhysDiskDevHandle),
+		    element->PhysDiskNum);
+	}
+}
+#endif
+
+/**
+ * _scsih_sas_ir_config_change_event - handle ir configuration change events
+ * @ioc: per adapter object
+ * @fw_event: The fw_event_work object
+ * Context: user.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_sas_ir_config_change_event(struct MPT3SAS_ADAPTER *ioc,
+	struct fw_event_work *fw_event)
+{
+	Mpi2EventIrConfigElement_t *element;
+	int i;
+	u8 foreign_config;
+	Mpi2EventDataIrConfigChangeList_t *event_data = fw_event->event_data;
+
+#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
+	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
+		_scsih_sas_ir_config_change_event_debug(ioc, event_data);
+
+#endif
+
+	foreign_config = (le32_to_cpu(event_data->Flags) &
+	    MPI2_EVENT_IR_CHANGE_FLAGS_FOREIGN_CONFIG) ? 1 : 0;
+
+	element = (Mpi2EventIrConfigElement_t *)&event_data->ConfigElement[0];
+	if (ioc->shost_recovery) {
+
+		for (i = 0; i < event_data->NumElements; i++, element++) {
+			if (element->ReasonCode == MPI2_EVENT_IR_CHANGE_RC_HIDE)
+				_scsih_ir_fastpath(ioc,
+					le16_to_cpu(element->PhysDiskDevHandle),
+					element->PhysDiskNum);
+		}
+		return;
+	}
+	for (i = 0; i < event_data->NumElements; i++, element++) {
+
+		switch (element->ReasonCode) {
+		case MPI2_EVENT_IR_CHANGE_RC_VOLUME_CREATED:
+		case MPI2_EVENT_IR_CHANGE_RC_ADDED:
+			if (!foreign_config)
+				_scsih_sas_volume_add(ioc, element);
+			break;
+		case MPI2_EVENT_IR_CHANGE_RC_VOLUME_DELETED:
+		case MPI2_EVENT_IR_CHANGE_RC_REMOVED:
+			if (!foreign_config)
+				_scsih_sas_volume_delete(ioc,
+				    le16_to_cpu(element->VolDevHandle));
+			break;
+		case MPI2_EVENT_IR_CHANGE_RC_PD_CREATED:
+			_scsih_sas_pd_hide(ioc, element);
+			break;
+		case MPI2_EVENT_IR_CHANGE_RC_PD_DELETED:
+			_scsih_sas_pd_expose(ioc, element);
+			break;
+		case MPI2_EVENT_IR_CHANGE_RC_HIDE:
+			_scsih_sas_pd_add(ioc, element);
+			break;
+		case MPI2_EVENT_IR_CHANGE_RC_UNHIDE:
+			_scsih_sas_pd_delete(ioc, element);
+			break;
+		}
+	}
+}
+
+/**
+ * _scsih_sas_ir_volume_event - IR volume event
+ * @ioc: per adapter object
+ * @fw_event: The fw_event_work object
+ * Context: user.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_sas_ir_volume_event(struct MPT3SAS_ADAPTER *ioc,
+	struct fw_event_work *fw_event)
+{
+	u64 wwid;
+	unsigned long flags;
+	struct _raid_device *raid_device;
+	u16 handle;
+	u32 state;
+	int rc;
+	Mpi2EventDataIrVolume_t *event_data = fw_event->event_data;
+
+	if (ioc->shost_recovery)
+		return;
+
+	if (event_data->ReasonCode != MPI2_EVENT_IR_VOLUME_RC_STATE_CHANGED)
+		return;
+
+	handle = le16_to_cpu(event_data->VolDevHandle);
+	state = le32_to_cpu(event_data->NewValue);
+	dewtprintk(ioc, pr_info(MPT3SAS_FMT
+		"%s: handle(0x%04x), old(0x%08x), new(0x%08x)\n",
+		ioc->name, __func__,  handle,
+	    le32_to_cpu(event_data->PreviousValue), state));
+	switch (state) {
+	case MPI2_RAID_VOL_STATE_MISSING:
+	case MPI2_RAID_VOL_STATE_FAILED:
+		_scsih_sas_volume_delete(ioc, handle);
+		break;
+
+	case MPI2_RAID_VOL_STATE_ONLINE:
+	case MPI2_RAID_VOL_STATE_DEGRADED:
+	case MPI2_RAID_VOL_STATE_OPTIMAL:
+
+		spin_lock_irqsave(&ioc->raid_device_lock, flags);
+		raid_device = _scsih_raid_device_find_by_handle(ioc, handle);
+		spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
+
+		if (raid_device)
+			break;
+
+		mpt3sas_config_get_volume_wwid(ioc, handle, &wwid);
+		if (!wwid) {
+			pr_err(MPT3SAS_FMT
+			    "failure at %s:%d/%s()!\n", ioc->name,
+			    __FILE__, __LINE__, __func__);
+			break;
+		}
+
+		raid_device = kzalloc(sizeof(struct _raid_device), GFP_KERNEL);
+		if (!raid_device) {
+			pr_err(MPT3SAS_FMT
+			    "failure at %s:%d/%s()!\n", ioc->name,
+			    __FILE__, __LINE__, __func__);
+			break;
+		}
+
+		raid_device->id = ioc->sas_id++;
+		raid_device->channel = RAID_CHANNEL;
+		raid_device->handle = handle;
+		raid_device->wwid = wwid;
+		_scsih_raid_device_add(ioc, raid_device);
+		rc = scsi_add_device(ioc->shost, RAID_CHANNEL,
+		    raid_device->id, 0);
+		if (rc)
+			_scsih_raid_device_remove(ioc, raid_device);
+		break;
+
+	case MPI2_RAID_VOL_STATE_INITIALIZING:
+	default:
+		break;
+	}
+}
+
+/**
+ * _scsih_sas_ir_physical_disk_event - PD event
+ * @ioc: per adapter object
+ * @fw_event: The fw_event_work object
+ * Context: user.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_sas_ir_physical_disk_event(struct MPT3SAS_ADAPTER *ioc,
+	struct fw_event_work *fw_event)
+{
+	u16 handle, parent_handle;
+	u32 state;
+	struct _sas_device *sas_device;
+	unsigned long flags;
+	Mpi2ConfigReply_t mpi_reply;
+	Mpi2SasDevicePage0_t sas_device_pg0;
+	u32 ioc_status;
+	Mpi2EventDataIrPhysicalDisk_t *event_data = fw_event->event_data;
+	u64 sas_address;
+
+	if (ioc->shost_recovery)
+		return;
+
+	if (event_data->ReasonCode != MPI2_EVENT_IR_PHYSDISK_RC_STATE_CHANGED)
+		return;
+
+	handle = le16_to_cpu(event_data->PhysDiskDevHandle);
+	state = le32_to_cpu(event_data->NewValue);
+
+	dewtprintk(ioc, pr_info(MPT3SAS_FMT
+		"%s: handle(0x%04x), old(0x%08x), new(0x%08x)\n",
+		ioc->name, __func__,  handle,
+		    le32_to_cpu(event_data->PreviousValue), state));
+	switch (state) {
+	case MPI2_RAID_PD_STATE_ONLINE:
+	case MPI2_RAID_PD_STATE_DEGRADED:
+	case MPI2_RAID_PD_STATE_REBUILDING:
+	case MPI2_RAID_PD_STATE_OPTIMAL:
+	case MPI2_RAID_PD_STATE_HOT_SPARE:
+
+		set_bit(handle, ioc->pd_handles);
+		spin_lock_irqsave(&ioc->sas_device_lock, flags);
+		sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
+		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+
+		if (sas_device)
+			return;
+
+		if ((mpt3sas_config_get_sas_device_pg0(ioc, &mpi_reply,
+		    &sas_device_pg0, MPI2_SAS_DEVICE_PGAD_FORM_HANDLE,
+		    handle))) {
+			pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+			    ioc->name, __FILE__, __LINE__, __func__);
+			return;
+		}
+
+		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+		    MPI2_IOCSTATUS_MASK;
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+			pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+			    ioc->name, __FILE__, __LINE__, __func__);
+			return;
+		}
+
+		parent_handle = le16_to_cpu(sas_device_pg0.ParentDevHandle);
+		if (!_scsih_get_sas_address(ioc, parent_handle, &sas_address))
+			mpt3sas_transport_update_links(ioc, sas_address, handle,
+			    sas_device_pg0.PhyNum, MPI2_SAS_NEG_LINK_RATE_1_5);
+
+		_scsih_add_device(ioc, handle, 0, 1);
+
+		break;
+
+	case MPI2_RAID_PD_STATE_OFFLINE:
+	case MPI2_RAID_PD_STATE_NOT_CONFIGURED:
+	case MPI2_RAID_PD_STATE_NOT_COMPATIBLE:
+	default:
+		break;
+	}
+}
+
+#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
+/**
+ * _scsih_sas_ir_operation_status_event_debug - debug for IR op event
+ * @ioc: per adapter object
+ * @event_data: event data payload
+ * Context: user.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_sas_ir_operation_status_event_debug(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2EventDataIrOperationStatus_t *event_data)
+{
+	char *reason_str = NULL;
+
+	switch (event_data->RAIDOperation) {
+	case MPI2_EVENT_IR_RAIDOP_RESYNC:
+		reason_str = "resync";
+		break;
+	case MPI2_EVENT_IR_RAIDOP_ONLINE_CAP_EXPANSION:
+		reason_str = "online capacity expansion";
+		break;
+	case MPI2_EVENT_IR_RAIDOP_CONSISTENCY_CHECK:
+		reason_str = "consistency check";
+		break;
+	case MPI2_EVENT_IR_RAIDOP_BACKGROUND_INIT:
+		reason_str = "background init";
+		break;
+	case MPI2_EVENT_IR_RAIDOP_MAKE_DATA_CONSISTENT:
+		reason_str = "make data consistent";
+		break;
+	}
+
+	if (!reason_str)
+		return;
+
+	pr_info(MPT3SAS_FMT "raid operational status: (%s)" \
+	    "\thandle(0x%04x), percent complete(%d)\n",
+	    ioc->name, reason_str,
+	    le16_to_cpu(event_data->VolDevHandle),
+	    event_data->PercentComplete);
+}
+#endif
+
+/**
+ * _scsih_sas_ir_operation_status_event - handle RAID operation events
+ * @ioc: per adapter object
+ * @fw_event: The fw_event_work object
+ * Context: user.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_sas_ir_operation_status_event(struct MPT3SAS_ADAPTER *ioc,
+	struct fw_event_work *fw_event)
+{
+	Mpi2EventDataIrOperationStatus_t *event_data = fw_event->event_data;
+	static struct _raid_device *raid_device;
+	unsigned long flags;
+	u16 handle;
+
+#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
+	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
+		_scsih_sas_ir_operation_status_event_debug(ioc,
+		     event_data);
+#endif
+
+	/* code added for raid transport support */
+	if (event_data->RAIDOperation == MPI2_EVENT_IR_RAIDOP_RESYNC) {
+
+		spin_lock_irqsave(&ioc->raid_device_lock, flags);
+		handle = le16_to_cpu(event_data->VolDevHandle);
+		raid_device = _scsih_raid_device_find_by_handle(ioc, handle);
+		if (raid_device)
+			raid_device->percent_complete =
+			    event_data->PercentComplete;
+		spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
+	}
+}
+
+/**
+ * _scsih_prep_device_scan - initialize parameters prior to device scan
+ * @ioc: per adapter object
+ *
+ * Set the deleted flag prior to device scan.  If the device is found during
+ * the scan, then we clear the deleted flag.
+ */
+static void
+_scsih_prep_device_scan(struct MPT3SAS_ADAPTER *ioc)
+{
+	struct MPT3SAS_DEVICE *sas_device_priv_data;
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
+ * _scsih_mark_responding_sas_device - mark a sas_devices as responding
+ * @ioc: per adapter object
+ * @sas_address: sas address
+ * @slot: enclosure slot id
+ * @handle: device handle
+ *
+ * After host reset, find out whether devices are still responding.
+ * Used in _scsih_remove_unresponsive_sas_devices.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_mark_responding_sas_device(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
+	u16 slot, u16 handle)
+{
+	struct MPT3SAS_TARGET *sas_target_priv_data = NULL;
+	struct scsi_target *starget;
+	struct _sas_device *sas_device;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ioc->sas_device_lock, flags);
+	list_for_each_entry(sas_device, &ioc->sas_device_list, list) {
+		if (sas_device->sas_address == sas_address &&
+		    sas_device->slot == slot) {
+			sas_device->responding = 1;
+			starget = sas_device->starget;
+			if (starget && starget->hostdata) {
+				sas_target_priv_data = starget->hostdata;
+				sas_target_priv_data->tm_busy = 0;
+				sas_target_priv_data->deleted = 0;
+			} else
+				sas_target_priv_data = NULL;
+			if (starget)
+				starget_printk(KERN_INFO, starget,
+				    "handle(0x%04x), sas_addr(0x%016llx), "
+				    "enclosure logical id(0x%016llx), "
+				    "slot(%d)\n", handle,
+				    (unsigned long long)sas_device->sas_address,
+				    (unsigned long long)
+				    sas_device->enclosure_logical_id,
+				    sas_device->slot);
+			if (sas_device->handle == handle)
+				goto out;
+			pr_info("\thandle changed from(0x%04x)!!!\n",
+			    sas_device->handle);
+			sas_device->handle = handle;
+			if (sas_target_priv_data)
+				sas_target_priv_data->handle = handle;
+			goto out;
+		}
+	}
+ out:
+	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+}
+
+/**
+ * _scsih_search_responding_sas_devices -
+ * @ioc: per adapter object
+ *
+ * After host reset, find out whether devices are still responding.
+ * If not remove.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_search_responding_sas_devices(struct MPT3SAS_ADAPTER *ioc)
+{
+	Mpi2SasDevicePage0_t sas_device_pg0;
+	Mpi2ConfigReply_t mpi_reply;
+	u16 ioc_status;
+	u16 handle;
+	u32 device_info;
+
+	pr_info(MPT3SAS_FMT "search for end-devices: start\n", ioc->name);
+
+	if (list_empty(&ioc->sas_device_list))
+		goto out;
+
+	handle = 0xFFFF;
+	while (!(mpt3sas_config_get_sas_device_pg0(ioc, &mpi_reply,
+	    &sas_device_pg0, MPI2_SAS_DEVICE_PGAD_FORM_GET_NEXT_HANDLE,
+	    handle))) {
+		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+		    MPI2_IOCSTATUS_MASK;
+		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
+			break;
+		handle = le16_to_cpu(sas_device_pg0.DevHandle);
+		device_info = le32_to_cpu(sas_device_pg0.DeviceInfo);
+		if (!(_scsih_is_end_device(device_info)))
+			continue;
+		_scsih_mark_responding_sas_device(ioc,
+		    le64_to_cpu(sas_device_pg0.SASAddress),
+		    le16_to_cpu(sas_device_pg0.Slot), handle);
+	}
+
+ out:
+	pr_info(MPT3SAS_FMT "search for end-devices: complete\n",
+	    ioc->name);
+}
+
+/**
+ * _scsih_mark_responding_raid_device - mark a raid_device as responding
+ * @ioc: per adapter object
+ * @wwid: world wide identifier for raid volume
+ * @handle: device handle
+ *
+ * After host reset, find out whether devices are still responding.
+ * Used in _scsih_remove_unresponsive_raid_devices.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_mark_responding_raid_device(struct MPT3SAS_ADAPTER *ioc, u64 wwid,
+	u16 handle)
+{
+	struct MPT3SAS_TARGET *sas_target_priv_data;
+	struct scsi_target *starget;
+	struct _raid_device *raid_device;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ioc->raid_device_lock, flags);
+	list_for_each_entry(raid_device, &ioc->raid_device_list, list) {
+		if (raid_device->wwid == wwid && raid_device->starget) {
+			starget = raid_device->starget;
+			if (starget && starget->hostdata) {
+				sas_target_priv_data = starget->hostdata;
+				sas_target_priv_data->deleted = 0;
+			} else
+				sas_target_priv_data = NULL;
+			raid_device->responding = 1;
+			spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
+			starget_printk(KERN_INFO, raid_device->starget,
+			    "handle(0x%04x), wwid(0x%016llx)\n", handle,
+			    (unsigned long long)raid_device->wwid);
+			spin_lock_irqsave(&ioc->raid_device_lock, flags);
+			if (raid_device->handle == handle) {
+				spin_unlock_irqrestore(&ioc->raid_device_lock,
+				    flags);
+				return;
+			}
+			pr_info("\thandle changed from(0x%04x)!!!\n",
+			    raid_device->handle);
+			raid_device->handle = handle;
+			if (sas_target_priv_data)
+				sas_target_priv_data->handle = handle;
+			spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
+			return;
+		}
+	}
+	spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
+}
+
+/**
+ * _scsih_search_responding_raid_devices -
+ * @ioc: per adapter object
+ *
+ * After host reset, find out whether devices are still responding.
+ * If not remove.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_search_responding_raid_devices(struct MPT3SAS_ADAPTER *ioc)
+{
+	Mpi2RaidVolPage1_t volume_pg1;
+	Mpi2RaidVolPage0_t volume_pg0;
+	Mpi2RaidPhysDiskPage0_t pd_pg0;
+	Mpi2ConfigReply_t mpi_reply;
+	u16 ioc_status;
+	u16 handle;
+	u8 phys_disk_num;
+
+	if (!ioc->ir_firmware)
+		return;
+
+	pr_info(MPT3SAS_FMT "search for raid volumes: start\n",
+	    ioc->name);
+
+	if (list_empty(&ioc->raid_device_list))
+		goto out;
+
+	handle = 0xFFFF;
+	while (!(mpt3sas_config_get_raid_volume_pg1(ioc, &mpi_reply,
+	    &volume_pg1, MPI2_RAID_VOLUME_PGAD_FORM_GET_NEXT_HANDLE, handle))) {
+		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+		    MPI2_IOCSTATUS_MASK;
+		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
+			break;
+		handle = le16_to_cpu(volume_pg1.DevHandle);
+
+		if (mpt3sas_config_get_raid_volume_pg0(ioc, &mpi_reply,
+		    &volume_pg0, MPI2_RAID_VOLUME_PGAD_FORM_HANDLE, handle,
+		     sizeof(Mpi2RaidVolPage0_t)))
+			continue;
+
+		if (volume_pg0.VolumeState == MPI2_RAID_VOL_STATE_OPTIMAL ||
+		    volume_pg0.VolumeState == MPI2_RAID_VOL_STATE_ONLINE ||
+		    volume_pg0.VolumeState == MPI2_RAID_VOL_STATE_DEGRADED)
+			_scsih_mark_responding_raid_device(ioc,
+			    le64_to_cpu(volume_pg1.WWID), handle);
+	}
+
+	/* refresh the pd_handles */
+		phys_disk_num = 0xFF;
+		memset(ioc->pd_handles, 0, ioc->pd_handles_sz);
+		while (!(mpt3sas_config_get_phys_disk_pg0(ioc, &mpi_reply,
+		    &pd_pg0, MPI2_PHYSDISK_PGAD_FORM_GET_NEXT_PHYSDISKNUM,
+		    phys_disk_num))) {
+			ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+			    MPI2_IOCSTATUS_MASK;
+			if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
+				break;
+			phys_disk_num = pd_pg0.PhysDiskNum;
+			handle = le16_to_cpu(pd_pg0.DevHandle);
+			set_bit(handle, ioc->pd_handles);
+		}
+ out:
+	pr_info(MPT3SAS_FMT "search for responding raid volumes: complete\n",
+		ioc->name);
+}
+
+/**
+ * _scsih_mark_responding_expander - mark a expander as responding
+ * @ioc: per adapter object
+ * @sas_address: sas address
+ * @handle:
+ *
+ * After host reset, find out whether devices are still responding.
+ * Used in _scsih_remove_unresponsive_expanders.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_mark_responding_expander(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
+	u16 handle)
+{
+	struct _sas_node *sas_expander;
+	unsigned long flags;
+	int i;
+
+	spin_lock_irqsave(&ioc->sas_node_lock, flags);
+	list_for_each_entry(sas_expander, &ioc->sas_expander_list, list) {
+		if (sas_expander->sas_address != sas_address)
+			continue;
+		sas_expander->responding = 1;
+		if (sas_expander->handle == handle)
+			goto out;
+		pr_info("\texpander(0x%016llx): handle changed" \
+		    " from(0x%04x) to (0x%04x)!!!\n",
+		    (unsigned long long)sas_expander->sas_address,
+		    sas_expander->handle, handle);
+		sas_expander->handle = handle;
+		for (i = 0 ; i < sas_expander->num_phys ; i++)
+			sas_expander->phy[i].handle = handle;
+		goto out;
+	}
+ out:
+	spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
+}
+
+/**
+ * _scsih_search_responding_expanders -
+ * @ioc: per adapter object
+ *
+ * After host reset, find out whether devices are still responding.
+ * If not remove.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_search_responding_expanders(struct MPT3SAS_ADAPTER *ioc)
+{
+	Mpi2ExpanderPage0_t expander_pg0;
+	Mpi2ConfigReply_t mpi_reply;
+	u16 ioc_status;
+	u64 sas_address;
+	u16 handle;
+
+	pr_info(MPT3SAS_FMT "search for expanders: start\n", ioc->name);
+
+	if (list_empty(&ioc->sas_expander_list))
+		goto out;
+
+	handle = 0xFFFF;
+	while (!(mpt3sas_config_get_expander_pg0(ioc, &mpi_reply, &expander_pg0,
+	    MPI2_SAS_EXPAND_PGAD_FORM_GET_NEXT_HNDL, handle))) {
+
+		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+		    MPI2_IOCSTATUS_MASK;
+		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
+			break;
+
+		handle = le16_to_cpu(expander_pg0.DevHandle);
+		sas_address = le64_to_cpu(expander_pg0.SASAddress);
+		pr_info("\texpander present: handle(0x%04x), sas_addr(0x%016llx)\n",
+			handle,
+		    (unsigned long long)sas_address);
+		_scsih_mark_responding_expander(ioc, sas_address, handle);
+	}
+
+ out:
+	pr_info(MPT3SAS_FMT "search for expanders: complete\n", ioc->name);
+}
+
+/**
+ * _scsih_remove_unresponding_sas_devices - removing unresponding devices
+ * @ioc: per adapter object
+ *
+ * Return nothing.
+ */
+static void
+_scsih_remove_unresponding_sas_devices(struct MPT3SAS_ADAPTER *ioc)
+{
+	struct _sas_device *sas_device, *sas_device_next;
+	struct _sas_node *sas_expander, *sas_expander_next;
+	struct _raid_device *raid_device, *raid_device_next;
+	struct list_head tmp_list;
+	unsigned long flags;
+
+	pr_info(MPT3SAS_FMT "removing unresponding devices: start\n",
+	    ioc->name);
+
+	/* removing unresponding end devices */
+	pr_info(MPT3SAS_FMT "removing unresponding devices: end-devices\n",
+	    ioc->name);
+	list_for_each_entry_safe(sas_device, sas_device_next,
+	    &ioc->sas_device_list, list) {
+		if (!sas_device->responding)
+			mpt3sas_device_remove_by_sas_address(ioc,
+			    sas_device->sas_address);
+		else
+			sas_device->responding = 0;
+	}
+
+	/* removing unresponding volumes */
+	if (ioc->ir_firmware) {
+		pr_info(MPT3SAS_FMT "removing unresponding devices: volumes\n",
+			ioc->name);
+		list_for_each_entry_safe(raid_device, raid_device_next,
+		    &ioc->raid_device_list, list) {
+			if (!raid_device->responding)
+				_scsih_sas_volume_delete(ioc,
+				    raid_device->handle);
+			else
+				raid_device->responding = 0;
+		}
+	}
+
+	/* removing unresponding expanders */
+	pr_info(MPT3SAS_FMT "removing unresponding devices: expanders\n",
+	    ioc->name);
+	spin_lock_irqsave(&ioc->sas_node_lock, flags);
+	INIT_LIST_HEAD(&tmp_list);
+	list_for_each_entry_safe(sas_expander, sas_expander_next,
+	    &ioc->sas_expander_list, list) {
+		if (!sas_expander->responding)
+			list_move_tail(&sas_expander->list, &tmp_list);
+		else
+			sas_expander->responding = 0;
+	}
+	spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
+	list_for_each_entry_safe(sas_expander, sas_expander_next, &tmp_list,
+	    list) {
+		list_del(&sas_expander->list);
+		_scsih_expander_node_remove(ioc, sas_expander);
+	}
+
+	pr_info(MPT3SAS_FMT "removing unresponding devices: complete\n",
+	    ioc->name);
+
+	/* unblock devices */
+	_scsih_ublock_io_all_device(ioc);
+}
+
+static void
+_scsih_refresh_expander_links(struct MPT3SAS_ADAPTER *ioc,
+	struct _sas_node *sas_expander, u16 handle)
+{
+	Mpi2ExpanderPage1_t expander_pg1;
+	Mpi2ConfigReply_t mpi_reply;
+	int i;
+
+	for (i = 0 ; i < sas_expander->num_phys ; i++) {
+		if ((mpt3sas_config_get_expander_pg1(ioc, &mpi_reply,
+		    &expander_pg1, i, handle))) {
+			pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+			    ioc->name, __FILE__, __LINE__, __func__);
+			return;
+		}
+
+		mpt3sas_transport_update_links(ioc, sas_expander->sas_address,
+		    le16_to_cpu(expander_pg1.AttachedDevHandle), i,
+		    expander_pg1.NegotiatedLinkRate >> 4);
+	}
+}
+
+/**
+ * _scsih_scan_for_devices_after_reset - scan for devices after host reset
+ * @ioc: per adapter object
+ *
+ * Return nothing.
+ */
+static void
+_scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
+{
+	Mpi2ExpanderPage0_t expander_pg0;
+	Mpi2SasDevicePage0_t sas_device_pg0;
+	Mpi2RaidVolPage1_t volume_pg1;
+	Mpi2RaidVolPage0_t volume_pg0;
+	Mpi2RaidPhysDiskPage0_t pd_pg0;
+	Mpi2EventIrConfigElement_t element;
+	Mpi2ConfigReply_t mpi_reply;
+	u8 phys_disk_num;
+	u16 ioc_status;
+	u16 handle, parent_handle;
+	u64 sas_address;
+	struct _sas_device *sas_device;
+	struct _sas_node *expander_device;
+	static struct _raid_device *raid_device;
+	u8 retry_count;
+	unsigned long flags;
+
+	pr_info(MPT3SAS_FMT "scan devices: start\n", ioc->name);
+
+	_scsih_sas_host_refresh(ioc);
+
+	pr_info(MPT3SAS_FMT "\tscan devices: expanders start\n", ioc->name);
+
+	/* expanders */
+	handle = 0xFFFF;
+	while (!(mpt3sas_config_get_expander_pg0(ioc, &mpi_reply, &expander_pg0,
+	    MPI2_SAS_EXPAND_PGAD_FORM_GET_NEXT_HNDL, handle))) {
+		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+		    MPI2_IOCSTATUS_MASK;
+		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
+			break;
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+			pr_info(MPT3SAS_FMT "\tbreak from expander scan: " \
+			    "ioc_status(0x%04x), loginfo(0x%08x)\n",
+			    ioc->name, ioc_status,
+			    le32_to_cpu(mpi_reply.IOCLogInfo));
+			break;
+		}
+		handle = le16_to_cpu(expander_pg0.DevHandle);
+		spin_lock_irqsave(&ioc->sas_node_lock, flags);
+		expander_device = mpt3sas_scsih_expander_find_by_sas_address(
+		    ioc, le64_to_cpu(expander_pg0.SASAddress));
+		spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
+		if (expander_device)
+			_scsih_refresh_expander_links(ioc, expander_device,
+			    handle);
+		else {
+			pr_info(MPT3SAS_FMT "\tBEFORE adding expander: " \
+			    "handle (0x%04x), sas_addr(0x%016llx)\n", ioc->name,
+			    handle, (unsigned long long)
+			    le64_to_cpu(expander_pg0.SASAddress));
+			_scsih_expander_add(ioc, handle);
+			pr_info(MPT3SAS_FMT "\tAFTER adding expander: " \
+			    "handle (0x%04x), sas_addr(0x%016llx)\n", ioc->name,
+			    handle, (unsigned long long)
+			    le64_to_cpu(expander_pg0.SASAddress));
+		}
+	}
+
+	pr_info(MPT3SAS_FMT "\tscan devices: expanders complete\n",
+	    ioc->name);
+
+	if (!ioc->ir_firmware)
+		goto skip_to_sas;
+
+	pr_info(MPT3SAS_FMT "\tscan devices: phys disk start\n", ioc->name);
+
+	/* phys disk */
+	phys_disk_num = 0xFF;
+	while (!(mpt3sas_config_get_phys_disk_pg0(ioc, &mpi_reply,
+	    &pd_pg0, MPI2_PHYSDISK_PGAD_FORM_GET_NEXT_PHYSDISKNUM,
+	    phys_disk_num))) {
+		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+		    MPI2_IOCSTATUS_MASK;
+		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
+			break;
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+			pr_info(MPT3SAS_FMT "\tbreak from phys disk scan: "\
+			    "ioc_status(0x%04x), loginfo(0x%08x)\n",
+			    ioc->name, ioc_status,
+			    le32_to_cpu(mpi_reply.IOCLogInfo));
+			break;
+		}
+		phys_disk_num = pd_pg0.PhysDiskNum;
+		handle = le16_to_cpu(pd_pg0.DevHandle);
+		spin_lock_irqsave(&ioc->sas_device_lock, flags);
+		sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
+		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+		if (sas_device)
+			continue;
+		if (mpt3sas_config_get_sas_device_pg0(ioc, &mpi_reply,
+		    &sas_device_pg0, MPI2_SAS_DEVICE_PGAD_FORM_HANDLE,
+		    handle) != 0)
+			continue;
+		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+		    MPI2_IOCSTATUS_MASK;
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+			pr_info(MPT3SAS_FMT "\tbreak from phys disk scan " \
+			    "ioc_status(0x%04x), loginfo(0x%08x)\n",
+			    ioc->name, ioc_status,
+			    le32_to_cpu(mpi_reply.IOCLogInfo));
+			break;
+		}
+		parent_handle = le16_to_cpu(sas_device_pg0.ParentDevHandle);
+		if (!_scsih_get_sas_address(ioc, parent_handle,
+		    &sas_address)) {
+			pr_info(MPT3SAS_FMT "\tBEFORE adding phys disk: " \
+			    " handle (0x%04x), sas_addr(0x%016llx)\n",
+			    ioc->name, handle, (unsigned long long)
+			    le64_to_cpu(sas_device_pg0.SASAddress));
+			mpt3sas_transport_update_links(ioc, sas_address,
+			    handle, sas_device_pg0.PhyNum,
+			    MPI2_SAS_NEG_LINK_RATE_1_5);
+			set_bit(handle, ioc->pd_handles);
+			retry_count = 0;
+			/* This will retry adding the end device.
+			 * _scsih_add_device() will decide on retries and
+			 * return "1" when it should be retried
+			 */
+			while (_scsih_add_device(ioc, handle, retry_count++,
+			    1)) {
+				ssleep(1);
+			}
+			pr_info(MPT3SAS_FMT "\tAFTER adding phys disk: " \
+			    " handle (0x%04x), sas_addr(0x%016llx)\n",
+			    ioc->name, handle, (unsigned long long)
+			    le64_to_cpu(sas_device_pg0.SASAddress));
+		}
+	}
+
+	pr_info(MPT3SAS_FMT "\tscan devices: phys disk complete\n",
+	    ioc->name);
+
+	pr_info(MPT3SAS_FMT "\tscan devices: volumes start\n", ioc->name);
+
+	/* volumes */
+	handle = 0xFFFF;
+	while (!(mpt3sas_config_get_raid_volume_pg1(ioc, &mpi_reply,
+	    &volume_pg1, MPI2_RAID_VOLUME_PGAD_FORM_GET_NEXT_HANDLE, handle))) {
+		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+		    MPI2_IOCSTATUS_MASK;
+		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
+			break;
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+			pr_info(MPT3SAS_FMT "\tbreak from volume scan: " \
+			    "ioc_status(0x%04x), loginfo(0x%08x)\n",
+			    ioc->name, ioc_status,
+			    le32_to_cpu(mpi_reply.IOCLogInfo));
+			break;
+		}
+		handle = le16_to_cpu(volume_pg1.DevHandle);
+		spin_lock_irqsave(&ioc->raid_device_lock, flags);
+		raid_device = _scsih_raid_device_find_by_wwid(ioc,
+		    le64_to_cpu(volume_pg1.WWID));
+		spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
+		if (raid_device)
+			continue;
+		if (mpt3sas_config_get_raid_volume_pg0(ioc, &mpi_reply,
+		    &volume_pg0, MPI2_RAID_VOLUME_PGAD_FORM_HANDLE, handle,
+		     sizeof(Mpi2RaidVolPage0_t)))
+			continue;
+		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+		    MPI2_IOCSTATUS_MASK;
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+			pr_info(MPT3SAS_FMT "\tbreak from volume scan: " \
+			    "ioc_status(0x%04x), loginfo(0x%08x)\n",
+			    ioc->name, ioc_status,
+			    le32_to_cpu(mpi_reply.IOCLogInfo));
+			break;
+		}
+		if (volume_pg0.VolumeState == MPI2_RAID_VOL_STATE_OPTIMAL ||
+		    volume_pg0.VolumeState == MPI2_RAID_VOL_STATE_ONLINE ||
+		    volume_pg0.VolumeState == MPI2_RAID_VOL_STATE_DEGRADED) {
+			memset(&element, 0, sizeof(Mpi2EventIrConfigElement_t));
+			element.ReasonCode = MPI2_EVENT_IR_CHANGE_RC_ADDED;
+			element.VolDevHandle = volume_pg1.DevHandle;
+			pr_info(MPT3SAS_FMT
+				"\tBEFORE adding volume: handle (0x%04x)\n",
+				ioc->name, volume_pg1.DevHandle);
+			_scsih_sas_volume_add(ioc, &element);
+			pr_info(MPT3SAS_FMT
+				"\tAFTER adding volume: handle (0x%04x)\n",
+				ioc->name, volume_pg1.DevHandle);
+		}
+	}
+
+	pr_info(MPT3SAS_FMT "\tscan devices: volumes complete\n",
+	    ioc->name);
+
+ skip_to_sas:
+
+	pr_info(MPT3SAS_FMT "\tscan devices: end devices start\n",
+	    ioc->name);
+
+	/* sas devices */
+	handle = 0xFFFF;
+	while (!(mpt3sas_config_get_sas_device_pg0(ioc, &mpi_reply,
+	    &sas_device_pg0, MPI2_SAS_DEVICE_PGAD_FORM_GET_NEXT_HANDLE,
+	    handle))) {
+		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+		    MPI2_IOCSTATUS_MASK;
+		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
+			break;
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+			pr_info(MPT3SAS_FMT "\tbreak from end device scan:"\
+			    " ioc_status(0x%04x), loginfo(0x%08x)\n",
+			    ioc->name, ioc_status,
+			    le32_to_cpu(mpi_reply.IOCLogInfo));
+			break;
+		}
+		handle = le16_to_cpu(sas_device_pg0.DevHandle);
+		if (!(_scsih_is_end_device(
+		    le32_to_cpu(sas_device_pg0.DeviceInfo))))
+			continue;
+		spin_lock_irqsave(&ioc->sas_device_lock, flags);
+		sas_device = mpt3sas_scsih_sas_device_find_by_sas_address(ioc,
+		    le64_to_cpu(sas_device_pg0.SASAddress));
+		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+		if (sas_device)
+			continue;
+		parent_handle = le16_to_cpu(sas_device_pg0.ParentDevHandle);
+		if (!_scsih_get_sas_address(ioc, parent_handle, &sas_address)) {
+			pr_info(MPT3SAS_FMT "\tBEFORE adding end device: " \
+			    "handle (0x%04x), sas_addr(0x%016llx)\n", ioc->name,
+			    handle, (unsigned long long)
+			    le64_to_cpu(sas_device_pg0.SASAddress));
+			mpt3sas_transport_update_links(ioc, sas_address, handle,
+			    sas_device_pg0.PhyNum, MPI2_SAS_NEG_LINK_RATE_1_5);
+			retry_count = 0;
+			/* This will retry adding the end device.
+			 * _scsih_add_device() will decide on retries and
+			 * return "1" when it should be retried
+			 */
+			while (_scsih_add_device(ioc, handle, retry_count++,
+			    0)) {
+				ssleep(1);
+			}
+			pr_info(MPT3SAS_FMT "\tAFTER adding end device: " \
+			    "handle (0x%04x), sas_addr(0x%016llx)\n", ioc->name,
+			    handle, (unsigned long long)
+			    le64_to_cpu(sas_device_pg0.SASAddress));
+		}
+	}
+	pr_info(MPT3SAS_FMT "\tscan devices: end devices complete\n",
+	    ioc->name);
+
+	pr_info(MPT3SAS_FMT "scan devices: complete\n", ioc->name);
+}
+/**
+ * mpt3sas_scsih_reset_handler - reset callback handler (for scsih)
+ * @ioc: per adapter object
+ * @reset_phase: phase
+ *
+ * The handler for doing any required cleanup or initialization.
+ *
+ * The reset phase can be MPT3_IOC_PRE_RESET, MPT3_IOC_AFTER_RESET,
+ * MPT3_IOC_DONE_RESET
+ *
+ * Return nothing.
+ */
+void
+mpt3sas_scsih_reset_handler(struct MPT3SAS_ADAPTER *ioc, int reset_phase)
+{
+	switch (reset_phase) {
+	case MPT3_IOC_PRE_RESET:
+		dtmprintk(ioc, pr_info(MPT3SAS_FMT
+			"%s: MPT3_IOC_PRE_RESET\n", ioc->name, __func__));
+		break;
+	case MPT3_IOC_AFTER_RESET:
+		dtmprintk(ioc, pr_info(MPT3SAS_FMT
+			"%s: MPT3_IOC_AFTER_RESET\n", ioc->name, __func__));
+		if (ioc->scsih_cmds.status & MPT3_CMD_PENDING) {
+			ioc->scsih_cmds.status |= MPT3_CMD_RESET;
+			mpt3sas_base_free_smid(ioc, ioc->scsih_cmds.smid);
+			complete(&ioc->scsih_cmds.done);
+		}
+		if (ioc->tm_cmds.status & MPT3_CMD_PENDING) {
+			ioc->tm_cmds.status |= MPT3_CMD_RESET;
+			mpt3sas_base_free_smid(ioc, ioc->tm_cmds.smid);
+			complete(&ioc->tm_cmds.done);
+		}
+
+		_scsih_fw_event_cleanup_queue(ioc);
+		_scsih_flush_running_cmds(ioc);
+		break;
+	case MPT3_IOC_DONE_RESET:
+		dtmprintk(ioc, pr_info(MPT3SAS_FMT
+			"%s: MPT3_IOC_DONE_RESET\n", ioc->name, __func__));
+		if ((!ioc->is_driver_loading) && !(disable_discovery > 0 &&
+		    !ioc->sas_hba.num_phys)) {
+			_scsih_prep_device_scan(ioc);
+			_scsih_search_responding_sas_devices(ioc);
+			_scsih_search_responding_raid_devices(ioc);
+			_scsih_search_responding_expanders(ioc);
+			_scsih_error_recovery_delete_devices(ioc);
+		}
+		break;
+	}
+}
+
+/**
+ * _mpt3sas_fw_work - delayed task for processing firmware events
+ * @ioc: per adapter object
+ * @fw_event: The fw_event_work object
+ * Context: user.
+ *
+ * Return nothing.
+ */
+static void
+_mpt3sas_fw_work(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
+{
+	/* the queue is being flushed so ignore this event */
+	if (ioc->remove_host || fw_event->cancel_pending_work ||
+	    ioc->pci_error_recovery) {
+		_scsih_fw_event_free(ioc, fw_event);
+		return;
+	}
+
+	switch (fw_event->event) {
+	case MPT3SAS_PROCESS_TRIGGER_DIAG:
+		mpt3sas_process_trigger_data(ioc, fw_event->event_data);
+		break;
+	case MPT3SAS_REMOVE_UNRESPONDING_DEVICES:
+		while (scsi_host_in_recovery(ioc->shost) || ioc->shost_recovery)
+			ssleep(1);
+		_scsih_remove_unresponding_sas_devices(ioc);
+		_scsih_scan_for_devices_after_reset(ioc);
+		break;
+	case MPT3SAS_PORT_ENABLE_COMPLETE:
+		ioc->start_scan = 0;
+	if (missing_delay[0] != -1 && missing_delay[1] != -1)
+			mpt3sas_base_update_missing_delay(ioc, missing_delay[0],
+			    missing_delay[1]);
+		dewtprintk(ioc, pr_info(MPT3SAS_FMT
+			"port enable: complete from worker thread\n",
+			ioc->name));
+		break;
+	case MPT3SAS_TURN_ON_FAULT_LED:
+		_scsih_turn_on_fault_led(ioc, fw_event->device_handle);
+		break;
+	case MPI2_EVENT_SAS_TOPOLOGY_CHANGE_LIST:
+		_scsih_sas_topology_change_event(ioc, fw_event);
+		break;
+	case MPI2_EVENT_SAS_DEVICE_STATUS_CHANGE:
+		_scsih_sas_device_status_change_event(ioc, fw_event);
+		break;
+	case MPI2_EVENT_SAS_DISCOVERY:
+		_scsih_sas_discovery_event(ioc, fw_event);
+		break;
+	case MPI2_EVENT_SAS_BROADCAST_PRIMITIVE:
+		_scsih_sas_broadcast_primitive_event(ioc, fw_event);
+		break;
+	case MPI2_EVENT_SAS_ENCL_DEVICE_STATUS_CHANGE:
+		_scsih_sas_enclosure_dev_status_change_event(ioc,
+		    fw_event);
+		break;
+	case MPI2_EVENT_IR_CONFIGURATION_CHANGE_LIST:
+		_scsih_sas_ir_config_change_event(ioc, fw_event);
+		break;
+	case MPI2_EVENT_IR_VOLUME:
+		_scsih_sas_ir_volume_event(ioc, fw_event);
+		break;
+	case MPI2_EVENT_IR_PHYSICAL_DISK:
+		_scsih_sas_ir_physical_disk_event(ioc, fw_event);
+		break;
+	case MPI2_EVENT_IR_OPERATION_STATUS:
+		_scsih_sas_ir_operation_status_event(ioc, fw_event);
+		break;
+	}
+	_scsih_fw_event_free(ioc, fw_event);
+}
+
+/**
+ * _firmware_event_work
+ * @ioc: per adapter object
+ * @work: The fw_event_work object
+ * Context: user.
+ *
+ * wrappers for the work thread handling firmware events
+ *
+ * Return nothing.
+ */
+
+static void
+_firmware_event_work(struct work_struct *work)
+{
+	struct fw_event_work *fw_event = container_of(work,
+	    struct fw_event_work, work);
+
+	_mpt3sas_fw_work(fw_event->ioc, fw_event);
+}
+
+/**
+ * mpt3sas_scsih_event_callback - firmware event handler (called at ISR time)
+ * @ioc: per adapter object
+ * @msix_index: MSIX table index supplied by the OS
+ * @reply: reply message frame(lower 32bit addr)
+ * Context: interrupt.
+ *
+ * This function merely adds a new work task into ioc->firmware_event_thread.
+ * The tasks are worked from _firmware_event_work in user context.
+ *
+ * Return 1 meaning mf should be freed from _base_interrupt
+ *        0 means the mf is freed from this function.
+ */
+u8
+mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
+	u32 reply)
+{
+	struct fw_event_work *fw_event;
+	Mpi2EventNotificationReply_t *mpi_reply;
+	u16 event;
+	u16 sz;
+
+	/* events turned off due to host reset or driver unloading */
+	if (ioc->remove_host || ioc->pci_error_recovery)
+		return 1;
+
+	mpi_reply = mpt3sas_base_get_reply_virt_addr(ioc, reply);
+
+	if (unlikely(!mpi_reply)) {
+		pr_err(MPT3SAS_FMT "mpi_reply not valid at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		return 1;
+	}
+
+	event = le16_to_cpu(mpi_reply->Event);
+
+	if (event != MPI2_EVENT_LOG_ENTRY_ADDED)
+		mpt3sas_trigger_event(ioc, event, 0);
+
+	switch (event) {
+	/* handle these */
+	case MPI2_EVENT_SAS_BROADCAST_PRIMITIVE:
+	{
+		Mpi2EventDataSasBroadcastPrimitive_t *baen_data =
+		    (Mpi2EventDataSasBroadcastPrimitive_t *)
+		    mpi_reply->EventData;
+
+		if (baen_data->Primitive !=
+		    MPI2_EVENT_PRIMITIVE_ASYNCHRONOUS_EVENT)
+			return 1;
+
+		if (ioc->broadcast_aen_busy) {
+			ioc->broadcast_aen_pending++;
+			return 1;
+		} else
+			ioc->broadcast_aen_busy = 1;
+		break;
+	}
+
+	case MPI2_EVENT_SAS_TOPOLOGY_CHANGE_LIST:
+		_scsih_check_topo_delete_events(ioc,
+		    (Mpi2EventDataSasTopologyChangeList_t *)
+		    mpi_reply->EventData);
+		break;
+	case MPI2_EVENT_IR_CONFIGURATION_CHANGE_LIST:
+		_scsih_check_ir_config_unhide_events(ioc,
+		    (Mpi2EventDataIrConfigChangeList_t *)
+		    mpi_reply->EventData);
+		break;
+	case MPI2_EVENT_IR_VOLUME:
+		_scsih_check_volume_delete_events(ioc,
+		    (Mpi2EventDataIrVolume_t *)
+		    mpi_reply->EventData);
+		break;
+
+	case MPI2_EVENT_SAS_DEVICE_STATUS_CHANGE:
+	case MPI2_EVENT_IR_OPERATION_STATUS:
+	case MPI2_EVENT_SAS_DISCOVERY:
+	case MPI2_EVENT_SAS_ENCL_DEVICE_STATUS_CHANGE:
+	case MPI2_EVENT_IR_PHYSICAL_DISK:
+		break;
+
+	default: /* ignore the rest */
+		return 1;
+	}
+
+	fw_event = kzalloc(sizeof(struct fw_event_work), GFP_ATOMIC);
+	if (!fw_event) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		return 1;
+	}
+	sz = le16_to_cpu(mpi_reply->EventDataLength) * 4;
+	fw_event->event_data = kzalloc(sz, GFP_ATOMIC);
+	if (!fw_event->event_data) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		kfree(fw_event);
+		return 1;
+	}
+
+	memcpy(fw_event->event_data, mpi_reply->EventData, sz);
+	fw_event->ioc = ioc;
+	fw_event->VF_ID = mpi_reply->VF_ID;
+	fw_event->VP_ID = mpi_reply->VP_ID;
+	fw_event->event = event;
+	_scsih_fw_event_add(ioc, fw_event);
+	return 1;
+}
+
+/* shost template */
+static struct scsi_host_template scsih_driver_template = {
+	.module				= THIS_MODULE,
+	.name				= "Fusion MPT SAS Host",
+	.proc_name			= MPT3SAS_DRIVER_NAME,
+	.queuecommand			= _scsih_qcmd,
+	.target_alloc			= _scsih_target_alloc,
+	.slave_alloc			= _scsih_slave_alloc,
+	.slave_configure		= _scsih_slave_configure,
+	.target_destroy			= _scsih_target_destroy,
+	.slave_destroy			= _scsih_slave_destroy,
+	.scan_finished			= _scsih_scan_finished,
+	.scan_start			= _scsih_scan_start,
+	.change_queue_depth		= _scsih_change_queue_depth,
+	.change_queue_type		= _scsih_change_queue_type,
+	.eh_abort_handler		= _scsih_abort,
+	.eh_device_reset_handler	= _scsih_dev_reset,
+	.eh_target_reset_handler	= _scsih_target_reset,
+	.eh_host_reset_handler		= _scsih_host_reset,
+	.bios_param			= _scsih_bios_param,
+	.can_queue			= 1,
+	.this_id			= -1,
+	.sg_tablesize			= MPT3SAS_SG_DEPTH,
+	.max_sectors			= 32767,
+	.cmd_per_lun			= 7,
+	.use_clustering			= ENABLE_CLUSTERING,
+	.shost_attrs			= mpt3sas_host_attrs,
+	.sdev_attrs			= mpt3sas_dev_attrs,
+};
+
+/**
+ * _scsih_expander_node_remove - removing expander device from list.
+ * @ioc: per adapter object
+ * @sas_expander: the sas_device object
+ * Context: Calling function should acquire ioc->sas_node_lock.
+ *
+ * Removing object and freeing associated memory from the
+ * ioc->sas_expander_list.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_expander_node_remove(struct MPT3SAS_ADAPTER *ioc,
+	struct _sas_node *sas_expander)
+{
+	struct _sas_port *mpt3sas_port, *next;
+
+	/* remove sibling ports attached to this expander */
+	list_for_each_entry_safe(mpt3sas_port, next,
+	   &sas_expander->sas_port_list, port_list) {
+		if (ioc->shost_recovery)
+			return;
+		if (mpt3sas_port->remote_identify.device_type ==
+		    SAS_END_DEVICE)
+			mpt3sas_device_remove_by_sas_address(ioc,
+			    mpt3sas_port->remote_identify.sas_address);
+		else if (mpt3sas_port->remote_identify.device_type ==
+		    SAS_EDGE_EXPANDER_DEVICE ||
+		    mpt3sas_port->remote_identify.device_type ==
+		    SAS_FANOUT_EXPANDER_DEVICE)
+			mpt3sas_expander_remove(ioc,
+			    mpt3sas_port->remote_identify.sas_address);
+	}
+
+	mpt3sas_transport_port_remove(ioc, sas_expander->sas_address,
+	    sas_expander->sas_address_parent);
+
+	pr_info(MPT3SAS_FMT
+		"expander_remove: handle(0x%04x), sas_addr(0x%016llx)\n",
+		ioc->name,
+	    sas_expander->handle, (unsigned long long)
+	    sas_expander->sas_address);
+
+	kfree(sas_expander->phy);
+	kfree(sas_expander);
+}
+
+/**
+ * _scsih_ir_shutdown - IR shutdown notification
+ * @ioc: per adapter object
+ *
+ * Sending RAID Action to alert the Integrated RAID subsystem of the IOC that
+ * the host system is shutting down.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_ir_shutdown(struct MPT3SAS_ADAPTER *ioc)
+{
+	Mpi2RaidActionRequest_t *mpi_request;
+	Mpi2RaidActionReply_t *mpi_reply;
+	u16 smid;
+
+	/* is IR firmware build loaded ? */
+	if (!ioc->ir_firmware)
+		return;
+
+	/* are there any volumes ? */
+	if (list_empty(&ioc->raid_device_list))
+		return;
+
+	mutex_lock(&ioc->scsih_cmds.mutex);
+
+	if (ioc->scsih_cmds.status != MPT3_CMD_NOT_USED) {
+		pr_err(MPT3SAS_FMT "%s: scsih_cmd in use\n",
+		    ioc->name, __func__);
+		goto out;
+	}
+	ioc->scsih_cmds.status = MPT3_CMD_PENDING;
+
+	smid = mpt3sas_base_get_smid(ioc, ioc->scsih_cb_idx);
+	if (!smid) {
+		pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
+		    ioc->name, __func__);
+		ioc->scsih_cmds.status = MPT3_CMD_NOT_USED;
+		goto out;
+	}
+
+	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
+	ioc->scsih_cmds.smid = smid;
+	memset(mpi_request, 0, sizeof(Mpi2RaidActionRequest_t));
+
+	mpi_request->Function = MPI2_FUNCTION_RAID_ACTION;
+	mpi_request->Action = MPI2_RAID_ACTION_SYSTEM_SHUTDOWN_INITIATED;
+
+	pr_info(MPT3SAS_FMT "IR shutdown (sending)\n", ioc->name);
+	init_completion(&ioc->scsih_cmds.done);
+	mpt3sas_base_put_smid_default(ioc, smid);
+	wait_for_completion_timeout(&ioc->scsih_cmds.done, 10*HZ);
+
+	if (!(ioc->scsih_cmds.status & MPT3_CMD_COMPLETE)) {
+		pr_err(MPT3SAS_FMT "%s: timeout\n",
+		    ioc->name, __func__);
+		goto out;
+	}
+
+	if (ioc->scsih_cmds.status & MPT3_CMD_REPLY_VALID) {
+		mpi_reply = ioc->scsih_cmds.reply;
+		pr_info(MPT3SAS_FMT
+			"IR shutdown (complete): ioc_status(0x%04x), loginfo(0x%08x)\n",
+		    ioc->name, le16_to_cpu(mpi_reply->IOCStatus),
+		    le32_to_cpu(mpi_reply->IOCLogInfo));
+	}
+
+ out:
+	ioc->scsih_cmds.status = MPT3_CMD_NOT_USED;
+	mutex_unlock(&ioc->scsih_cmds.mutex);
+}
+
+/**
+ * _scsih_remove - detach and remove add host
+ * @pdev: PCI device struct
+ *
+ * Routine called when unloading the driver.
+ * Return nothing.
+ */
+static void __devexit
+_scsih_remove(struct pci_dev *pdev)
+{
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
+	struct _sas_port *mpt3sas_port, *next_port;
+	struct _raid_device *raid_device, *next;
+	struct MPT3SAS_TARGET *sas_target_priv_data;
+	struct workqueue_struct	*wq;
+	unsigned long flags;
+
+	ioc->remove_host = 1;
+	_scsih_fw_event_cleanup_queue(ioc);
+
+	spin_lock_irqsave(&ioc->fw_event_lock, flags);
+	wq = ioc->firmware_event_thread;
+	ioc->firmware_event_thread = NULL;
+	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
+	if (wq)
+		destroy_workqueue(wq);
+
+	/* release all the volumes */
+	_scsih_ir_shutdown(ioc);
+	list_for_each_entry_safe(raid_device, next, &ioc->raid_device_list,
+	    list) {
+		if (raid_device->starget) {
+			sas_target_priv_data =
+			    raid_device->starget->hostdata;
+			sas_target_priv_data->deleted = 1;
+			scsi_remove_target(&raid_device->starget->dev);
+		}
+		pr_info(MPT3SAS_FMT "removing handle(0x%04x), wwid(0x%016llx)\n",
+			ioc->name,  raid_device->handle,
+		    (unsigned long long) raid_device->wwid);
+		_scsih_raid_device_remove(ioc, raid_device);
+	}
+
+	/* free ports attached to the sas_host */
+	list_for_each_entry_safe(mpt3sas_port, next_port,
+	   &ioc->sas_hba.sas_port_list, port_list) {
+		if (mpt3sas_port->remote_identify.device_type ==
+		    SAS_END_DEVICE)
+			mpt3sas_device_remove_by_sas_address(ioc,
+			    mpt3sas_port->remote_identify.sas_address);
+		else if (mpt3sas_port->remote_identify.device_type ==
+		    SAS_EDGE_EXPANDER_DEVICE ||
+		    mpt3sas_port->remote_identify.device_type ==
+		    SAS_FANOUT_EXPANDER_DEVICE)
+			mpt3sas_expander_remove(ioc,
+			    mpt3sas_port->remote_identify.sas_address);
+	}
+
+	/* free phys attached to the sas_host */
+	if (ioc->sas_hba.num_phys) {
+		kfree(ioc->sas_hba.phy);
+		ioc->sas_hba.phy = NULL;
+		ioc->sas_hba.num_phys = 0;
+	}
+
+	sas_remove_host(shost);
+	mpt3sas_base_detach(ioc);
+	list_del(&ioc->list);
+	scsi_remove_host(shost);
+	scsi_host_put(shost);
+}
+
+/**
+ * _scsih_shutdown - routine call during system shutdown
+ * @pdev: PCI device struct
+ *
+ * Return nothing.
+ */
+static void
+_scsih_shutdown(struct pci_dev *pdev)
+{
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
+	struct workqueue_struct	*wq;
+	unsigned long flags;
+
+	ioc->remove_host = 1;
+	_scsih_fw_event_cleanup_queue(ioc);
+
+	spin_lock_irqsave(&ioc->fw_event_lock, flags);
+	wq = ioc->firmware_event_thread;
+	ioc->firmware_event_thread = NULL;
+	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
+	if (wq)
+		destroy_workqueue(wq);
+
+	_scsih_ir_shutdown(ioc);
+	mpt3sas_base_detach(ioc);
+}
+
+
+/**
+ * _scsih_probe_boot_devices - reports 1st device
+ * @ioc: per adapter object
+ *
+ * If specified in bios page 2, this routine reports the 1st
+ * device scsi-ml or sas transport for persistent boot device
+ * purposes.  Please refer to function _scsih_determine_boot_device()
+ */
+static void
+_scsih_probe_boot_devices(struct MPT3SAS_ADAPTER *ioc)
+{
+	u8 is_raid;
+	void *device;
+	struct _sas_device *sas_device;
+	struct _raid_device *raid_device;
+	u16 handle;
+	u64 sas_address_parent;
+	u64 sas_address;
+	unsigned long flags;
+	int rc;
+
+	 /* no Bios, return immediately */
+	if (!ioc->bios_pg3.BiosVersion)
+		return;
+
+	device = NULL;
+	is_raid = 0;
+	if (ioc->req_boot_device.device) {
+		device =  ioc->req_boot_device.device;
+		is_raid = ioc->req_boot_device.is_raid;
+	} else if (ioc->req_alt_boot_device.device) {
+		device =  ioc->req_alt_boot_device.device;
+		is_raid = ioc->req_alt_boot_device.is_raid;
+	} else if (ioc->current_boot_device.device) {
+		device =  ioc->current_boot_device.device;
+		is_raid = ioc->current_boot_device.is_raid;
+	}
+
+	if (!device)
+		return;
+
+	if (is_raid) {
+		raid_device = device;
+		rc = scsi_add_device(ioc->shost, RAID_CHANNEL,
+		    raid_device->id, 0);
+		if (rc)
+			_scsih_raid_device_remove(ioc, raid_device);
+	} else {
+		spin_lock_irqsave(&ioc->sas_device_lock, flags);
+		sas_device = device;
+		handle = sas_device->handle;
+		sas_address_parent = sas_device->sas_address_parent;
+		sas_address = sas_device->sas_address;
+		list_move_tail(&sas_device->list, &ioc->sas_device_list);
+		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+
+		if (!mpt3sas_transport_port_add(ioc, handle,
+		    sas_address_parent)) {
+			_scsih_sas_device_remove(ioc, sas_device);
+		} else if (!sas_device->starget) {
+			if (!ioc->is_driver_loading)
+				mpt3sas_transport_port_remove(ioc, sas_address,
+				    sas_address_parent);
+			_scsih_sas_device_remove(ioc, sas_device);
+		}
+	}
+}
+
+/**
+ * _scsih_probe_raid - reporting raid volumes to scsi-ml
+ * @ioc: per adapter object
+ *
+ * Called during initial loading of the driver.
+ */
+static void
+_scsih_probe_raid(struct MPT3SAS_ADAPTER *ioc)
+{
+	struct _raid_device *raid_device, *raid_next;
+	int rc;
+
+	list_for_each_entry_safe(raid_device, raid_next,
+	    &ioc->raid_device_list, list) {
+		if (raid_device->starget)
+			continue;
+		rc = scsi_add_device(ioc->shost, RAID_CHANNEL,
+		    raid_device->id, 0);
+		if (rc)
+			_scsih_raid_device_remove(ioc, raid_device);
+	}
+}
+
+/**
+ * _scsih_probe_sas - reporting sas devices to sas transport
+ * @ioc: per adapter object
+ *
+ * Called during initial loading of the driver.
+ */
+static void
+_scsih_probe_sas(struct MPT3SAS_ADAPTER *ioc)
+{
+	struct _sas_device *sas_device, *next;
+	unsigned long flags;
+
+	/* SAS Device List */
+	list_for_each_entry_safe(sas_device, next, &ioc->sas_device_init_list,
+	    list) {
+
+		if (!mpt3sas_transport_port_add(ioc, sas_device->handle,
+		    sas_device->sas_address_parent)) {
+			list_del(&sas_device->list);
+			kfree(sas_device);
+			continue;
+		} else if (!sas_device->starget) {
+			/*
+			 * When asyn scanning is enabled, its not possible to
+			 * remove devices while scanning is turned on due to an
+			 * oops in scsi_sysfs_add_sdev()->add_device()->
+			 * sysfs_addrm_start()
+			 */
+			if (!ioc->is_driver_loading)
+				mpt3sas_transport_port_remove(ioc,
+				    sas_device->sas_address,
+				    sas_device->sas_address_parent);
+			list_del(&sas_device->list);
+			kfree(sas_device);
+			continue;
+		}
+
+		spin_lock_irqsave(&ioc->sas_device_lock, flags);
+		list_move_tail(&sas_device->list, &ioc->sas_device_list);
+		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+	}
+}
+
+/**
+ * _scsih_probe_devices - probing for devices
+ * @ioc: per adapter object
+ *
+ * Called during initial loading of the driver.
+ */
+static void
+_scsih_probe_devices(struct MPT3SAS_ADAPTER *ioc)
+{
+	u16 volume_mapping_flags;
+
+	if (!(ioc->facts.ProtocolFlags & MPI2_IOCFACTS_PROTOCOL_SCSI_INITIATOR))
+		return;  /* return when IOC doesn't support initiator mode */
+
+	_scsih_probe_boot_devices(ioc);
+
+	if (ioc->ir_firmware) {
+		volume_mapping_flags =
+		    le16_to_cpu(ioc->ioc_pg8.IRVolumeMappingFlags) &
+		    MPI2_IOCPAGE8_IRFLAGS_MASK_VOLUME_MAPPING_MODE;
+		if (volume_mapping_flags ==
+		    MPI2_IOCPAGE8_IRFLAGS_LOW_VOLUME_MAPPING) {
+			_scsih_probe_raid(ioc);
+			_scsih_probe_sas(ioc);
+		} else {
+			_scsih_probe_sas(ioc);
+			_scsih_probe_raid(ioc);
+		}
+	} else
+		_scsih_probe_sas(ioc);
+}
+
+/**
+ * _scsih_scan_start - scsi lld callback for .scan_start
+ * @shost: SCSI host pointer
+ *
+ * The shost has the ability to discover targets on its own instead
+ * of scanning the entire bus.  In our implemention, we will kick off
+ * firmware discovery.
+ */
+static void
+_scsih_scan_start(struct Scsi_Host *shost)
+{
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
+	int rc;
+	if (diag_buffer_enable != -1 && diag_buffer_enable != 0)
+		mpt3sas_enable_diag_buffer(ioc, diag_buffer_enable);
+
+	if (disable_discovery > 0)
+		return;
+
+	ioc->start_scan = 1;
+	rc = mpt3sas_port_enable(ioc);
+
+	if (rc != 0)
+		pr_info(MPT3SAS_FMT "port enable: FAILED\n", ioc->name);
+}
+
+/**
+ * _scsih_scan_finished - scsi lld callback for .scan_finished
+ * @shost: SCSI host pointer
+ * @time: elapsed time of the scan in jiffies
+ *
+ * This function will be called periodicallyn until it returns 1 with the
+ * scsi_host and the elapsed time of the scan in jiffies. In our implemention,
+ * we wait for firmware discovery to complete, then return 1.
+ */
+static int
+_scsih_scan_finished(struct Scsi_Host *shost, unsigned long time)
+{
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
+
+	if (disable_discovery > 0) {
+		ioc->is_driver_loading = 0;
+		ioc->wait_for_discovery_to_complete = 0;
+		return 1;
+	}
+
+	if (time >= (300 * HZ)) {
+		ioc->base_cmds.status = MPT3_CMD_NOT_USED;
+		pr_info(MPT3SAS_FMT
+			"port enable: FAILED with timeout (timeout=300s)\n",
+			ioc->name);
+		ioc->is_driver_loading = 0;
+		return 1;
+	}
+
+	if (ioc->start_scan)
+		return 0;
+
+	if (ioc->start_scan_failed) {
+		pr_info(MPT3SAS_FMT
+			"port enable: FAILED with (ioc_status=0x%08x)\n",
+			ioc->name, ioc->start_scan_failed);
+		ioc->is_driver_loading = 0;
+		ioc->wait_for_discovery_to_complete = 0;
+		ioc->remove_host = 1;
+		return 1;
+	}
+
+	pr_info(MPT3SAS_FMT "port enable: SUCCESS\n", ioc->name);
+	ioc->base_cmds.status = MPT3_CMD_NOT_USED;
+
+	if (ioc->wait_for_discovery_to_complete) {
+		ioc->wait_for_discovery_to_complete = 0;
+		_scsih_probe_devices(ioc);
+	}
+	mpt3sas_base_start_watchdog(ioc);
+	ioc->is_driver_loading = 0;
+	return 1;
+}
+
+/**
+ * _scsih_probe - attach and add scsi host
+ * @pdev: PCI device struct
+ * @id: pci device id
+ *
+ * Returns 0 success, anything else error.
+ */
+static int
+_scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct MPT3SAS_ADAPTER *ioc;
+	struct Scsi_Host *shost;
+
+	shost = scsi_host_alloc(&scsih_driver_template,
+	    sizeof(struct MPT3SAS_ADAPTER));
+	if (!shost)
+		return -ENODEV;
+
+	/* init local params */
+	ioc = shost_priv(shost);
+	memset(ioc, 0, sizeof(struct MPT3SAS_ADAPTER));
+	INIT_LIST_HEAD(&ioc->list);
+	list_add_tail(&ioc->list, &mpt3sas_ioc_list);
+	ioc->shost = shost;
+	ioc->id = mpt_ids++;
+	sprintf(ioc->name, "%s%d", MPT3SAS_DRIVER_NAME, ioc->id);
+	ioc->pdev = pdev;
+	ioc->scsi_io_cb_idx = scsi_io_cb_idx;
+	ioc->tm_cb_idx = tm_cb_idx;
+	ioc->ctl_cb_idx = ctl_cb_idx;
+	ioc->base_cb_idx = base_cb_idx;
+	ioc->port_enable_cb_idx = port_enable_cb_idx;
+	ioc->transport_cb_idx = transport_cb_idx;
+	ioc->scsih_cb_idx = scsih_cb_idx;
+	ioc->config_cb_idx = config_cb_idx;
+	ioc->tm_tr_cb_idx = tm_tr_cb_idx;
+	ioc->tm_tr_volume_cb_idx = tm_tr_volume_cb_idx;
+	ioc->tm_sas_control_cb_idx = tm_sas_control_cb_idx;
+	ioc->logging_level = logging_level;
+	ioc->schedule_dead_ioc_flush_running_cmds = &_scsih_flush_running_cmds;
+	/* misc semaphores and spin locks */
+	mutex_init(&ioc->reset_in_progress_mutex);
+	spin_lock_init(&ioc->ioc_reset_in_progress_lock);
+	spin_lock_init(&ioc->scsi_lookup_lock);
+	spin_lock_init(&ioc->sas_device_lock);
+	spin_lock_init(&ioc->sas_node_lock);
+	spin_lock_init(&ioc->fw_event_lock);
+	spin_lock_init(&ioc->raid_device_lock);
+	spin_lock_init(&ioc->diag_trigger_lock);
+
+	INIT_LIST_HEAD(&ioc->sas_device_list);
+	INIT_LIST_HEAD(&ioc->sas_device_init_list);
+	INIT_LIST_HEAD(&ioc->sas_expander_list);
+	INIT_LIST_HEAD(&ioc->fw_event_list);
+	INIT_LIST_HEAD(&ioc->raid_device_list);
+	INIT_LIST_HEAD(&ioc->sas_hba.sas_port_list);
+	INIT_LIST_HEAD(&ioc->delayed_tr_list);
+	INIT_LIST_HEAD(&ioc->delayed_tr_volume_list);
+
+	/* init shost parameters */
+	shost->max_cmd_len = 32;
+	shost->max_lun = max_lun;
+	shost->transportt = mpt3sas_transport_template;
+	shost->unique_id = ioc->id;
+
+	if (max_sectors != 0xFFFF) {
+		if (max_sectors < 64) {
+			shost->max_sectors = 64;
+			pr_warn(MPT3SAS_FMT "Invalid value %d passed " \
+			    "for max_sectors, range is 64 to 32767. Assigning "
+			    "value of 64.\n", ioc->name, max_sectors);
+		} else if (max_sectors > 32767) {
+			shost->max_sectors = 32767;
+			pr_warn(MPT3SAS_FMT "Invalid value %d passed " \
+			    "for max_sectors, range is 64 to 32767. Assigning "
+			    "default value of 32767.\n", ioc->name,
+			    max_sectors);
+		} else {
+			shost->max_sectors = max_sectors & 0xFFFE;
+			pr_info(MPT3SAS_FMT
+				"The max_sectors value is set to %d\n",
+				ioc->name, shost->max_sectors);
+		}
+	}
+
+	if ((scsi_add_host(shost, &pdev->dev))) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		list_del(&ioc->list);
+		goto out_add_shost_fail;
+	}
+
+	/* register EEDP capabilities with SCSI layer */
+	if (prot_mask > 0)
+		scsi_host_set_prot(shost, prot_mask);
+	else
+		scsi_host_set_prot(shost, SHOST_DIF_TYPE1_PROTECTION
+				   | SHOST_DIF_TYPE2_PROTECTION
+				   | SHOST_DIF_TYPE3_PROTECTION);
+
+	scsi_host_set_guard(shost, SHOST_DIX_GUARD_CRC);
+
+	/* event thread */
+	snprintf(ioc->firmware_event_name, sizeof(ioc->firmware_event_name),
+	    "fw_event%d", ioc->id);
+	ioc->firmware_event_thread = create_singlethread_workqueue(
+	    ioc->firmware_event_name);
+	if (!ioc->firmware_event_thread) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		goto out_thread_fail;
+	}
+
+	ioc->is_driver_loading = 1;
+	if ((mpt3sas_base_attach(ioc))) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		goto out_attach_fail;
+	}
+	scsi_scan_host(shost);
+	return 0;
+
+ out_attach_fail:
+	destroy_workqueue(ioc->firmware_event_thread);
+ out_thread_fail:
+	list_del(&ioc->list);
+	scsi_remove_host(shost);
+ out_add_shost_fail:
+	scsi_host_put(shost);
+	return -ENODEV;
+}
+
+#ifdef CONFIG_PM
+/**
+ * _scsih_suspend - power management suspend main entry point
+ * @pdev: PCI device struct
+ * @state: PM state change to (usually PCI_D3)
+ *
+ * Returns 0 success, anything else error.
+ */
+static int
+_scsih_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
+	pci_power_t device_state;
+
+	mpt3sas_base_stop_watchdog(ioc);
+	flush_scheduled_work();
+	scsi_block_requests(shost);
+	device_state = pci_choose_state(pdev, state);
+	pr_info(MPT3SAS_FMT
+		"pdev=0x%p, slot=%s, entering operating state [D%d]\n",
+		ioc->name, pdev, pci_name(pdev), device_state);
+
+	pci_save_state(pdev);
+	mpt3sas_base_free_resources(ioc);
+	pci_set_power_state(pdev, device_state);
+	return 0;
+}
+
+/**
+ * _scsih_resume - power management resume main entry point
+ * @pdev: PCI device struct
+ *
+ * Returns 0 success, anything else error.
+ */
+static int
+_scsih_resume(struct pci_dev *pdev)
+{
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
+	pci_power_t device_state = pdev->current_state;
+	int r;
+
+	pr_info(MPT3SAS_FMT
+		"pdev=0x%p, slot=%s, previous operating state [D%d]\n",
+		ioc->name, pdev, pci_name(pdev), device_state);
+
+	pci_set_power_state(pdev, PCI_D0);
+	pci_enable_wake(pdev, PCI_D0, 0);
+	pci_restore_state(pdev);
+	ioc->pdev = pdev;
+	r = mpt3sas_base_map_resources(ioc);
+	if (r)
+		return r;
+
+	mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP, SOFT_RESET);
+	scsi_unblock_requests(shost);
+	mpt3sas_base_start_watchdog(ioc);
+	return 0;
+}
+#endif /* CONFIG_PM */
+
+/**
+ * _scsih_pci_error_detected - Called when a PCI error is detected.
+ * @pdev: PCI device struct
+ * @state: PCI channel state
+ *
+ * Description: Called when a PCI error is detected.
+ *
+ * Return value:
+ *      PCI_ERS_RESULT_NEED_RESET or PCI_ERS_RESULT_DISCONNECT
+ */
+static pci_ers_result_t
+_scsih_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
+{
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
+
+	pr_info(MPT3SAS_FMT "PCI error: detected callback, state(%d)!!\n",
+	    ioc->name, state);
+
+	switch (state) {
+	case pci_channel_io_normal:
+		return PCI_ERS_RESULT_CAN_RECOVER;
+	case pci_channel_io_frozen:
+		/* Fatal error, prepare for slot reset */
+		ioc->pci_error_recovery = 1;
+		scsi_block_requests(ioc->shost);
+		mpt3sas_base_stop_watchdog(ioc);
+		mpt3sas_base_free_resources(ioc);
+		return PCI_ERS_RESULT_NEED_RESET;
+	case pci_channel_io_perm_failure:
+		/* Permanent error, prepare for device removal */
+		ioc->pci_error_recovery = 1;
+		mpt3sas_base_stop_watchdog(ioc);
+		_scsih_flush_running_cmds(ioc);
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+	return PCI_ERS_RESULT_NEED_RESET;
+}
+
+/**
+ * _scsih_pci_slot_reset - Called when PCI slot has been reset.
+ * @pdev: PCI device struct
+ *
+ * Description: This routine is called by the pci error recovery
+ * code after the PCI slot has been reset, just before we
+ * should resume normal operations.
+ */
+static pci_ers_result_t
+_scsih_pci_slot_reset(struct pci_dev *pdev)
+{
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
+	int rc;
+
+	pr_info(MPT3SAS_FMT "PCI error: slot reset callback!!\n",
+	     ioc->name);
+
+	ioc->pci_error_recovery = 0;
+	ioc->pdev = pdev;
+	pci_restore_state(pdev);
+	rc = mpt3sas_base_map_resources(ioc);
+	if (rc)
+		return PCI_ERS_RESULT_DISCONNECT;
+
+	rc = mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP,
+	    FORCE_BIG_HAMMER);
+
+	pr_warn(MPT3SAS_FMT "hard reset: %s\n", ioc->name,
+	    (rc == 0) ? "success" : "failed");
+
+	if (!rc)
+		return PCI_ERS_RESULT_RECOVERED;
+	else
+		return PCI_ERS_RESULT_DISCONNECT;
+}
+
+/**
+ * _scsih_pci_resume() - resume normal ops after PCI reset
+ * @pdev: pointer to PCI device
+ *
+ * Called when the error recovery driver tells us that its
+ * OK to resume normal operation. Use completion to allow
+ * halted scsi ops to resume.
+ */
+static void
+_scsih_pci_resume(struct pci_dev *pdev)
+{
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
+
+	pr_info(MPT3SAS_FMT "PCI error: resume callback!!\n", ioc->name);
+
+	pci_cleanup_aer_uncorrect_error_status(pdev);
+	mpt3sas_base_start_watchdog(ioc);
+	scsi_unblock_requests(ioc->shost);
+}
+
+/**
+ * _scsih_pci_mmio_enabled - Enable MMIO and dump debug registers
+ * @pdev: pointer to PCI device
+ */
+static pci_ers_result_t
+_scsih_pci_mmio_enabled(struct pci_dev *pdev)
+{
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
+
+	pr_info(MPT3SAS_FMT "PCI error: mmio enabled callback!!\n",
+	    ioc->name);
+
+	/* TODO - dump whatever for debugging purposes */
+
+	/* Request a slot reset. */
+	return PCI_ERS_RESULT_NEED_RESET;
+}
+
+/* raid transport support */
+static struct raid_function_template mpt3sas_raid_functions = {
+	.cookie		= &scsih_driver_template,
+	.is_raid	= _scsih_is_raid,
+	.get_resync	= _scsih_get_resync,
+	.get_state	= _scsih_get_state,
+};
+
+static struct pci_error_handlers _scsih_err_handler = {
+	.error_detected = _scsih_pci_error_detected,
+	.mmio_enabled = _scsih_pci_mmio_enabled,
+	.slot_reset =	_scsih_pci_slot_reset,
+	.resume =	_scsih_pci_resume,
+};
+
+static struct pci_driver scsih_driver = {
+	.name		= MPT3SAS_DRIVER_NAME,
+	.id_table	= scsih_pci_table,
+	.probe		= _scsih_probe,
+	.remove		= __devexit_p(_scsih_remove),
+	.shutdown	= _scsih_shutdown,
+	.err_handler	= &_scsih_err_handler,
+#ifdef CONFIG_PM
+	.suspend	= _scsih_suspend,
+	.resume		= _scsih_resume,
+#endif
+};
+
+
+/**
+ * _scsih_init - main entry point for this driver.
+ *
+ * Returns 0 success, anything else error.
+ */
+static int __init
+_scsih_init(void)
+{
+	int error;
+
+	mpt_ids = 0;
+
+	pr_info("%s version %s loaded\n", MPT3SAS_DRIVER_NAME,
+	    MPT3SAS_DRIVER_VERSION);
+
+	mpt3sas_transport_template =
+	    sas_attach_transport(&mpt3sas_transport_functions);
+	if (!mpt3sas_transport_template)
+		return -ENODEV;
+
+/* raid transport support */
+	mpt3sas_raid_template = raid_class_attach(&mpt3sas_raid_functions);
+	if (!mpt3sas_raid_template) {
+		sas_release_transport(mpt3sas_transport_template);
+		return -ENODEV;
+	}
+
+	mpt3sas_base_initialize_callback_handler();
+
+	 /* queuecommand callback hander */
+	scsi_io_cb_idx = mpt3sas_base_register_callback_handler(_scsih_io_done);
+
+	/* task managment callback handler */
+	tm_cb_idx = mpt3sas_base_register_callback_handler(_scsih_tm_done);
+
+	/* base internal commands callback handler */
+	base_cb_idx = mpt3sas_base_register_callback_handler(mpt3sas_base_done);
+	port_enable_cb_idx = mpt3sas_base_register_callback_handler(
+	    mpt3sas_port_enable_done);
+
+	/* transport internal commands callback handler */
+	transport_cb_idx = mpt3sas_base_register_callback_handler(
+	    mpt3sas_transport_done);
+
+	/* scsih internal commands callback handler */
+	scsih_cb_idx = mpt3sas_base_register_callback_handler(_scsih_done);
+
+	/* configuration page API internal commands callback handler */
+	config_cb_idx = mpt3sas_base_register_callback_handler(
+	    mpt3sas_config_done);
+
+	/* ctl module callback handler */
+	ctl_cb_idx = mpt3sas_base_register_callback_handler(mpt3sas_ctl_done);
+
+	tm_tr_cb_idx = mpt3sas_base_register_callback_handler(
+	    _scsih_tm_tr_complete);
+
+	tm_tr_volume_cb_idx = mpt3sas_base_register_callback_handler(
+	    _scsih_tm_volume_tr_complete);
+
+	tm_sas_control_cb_idx = mpt3sas_base_register_callback_handler(
+	    _scsih_sas_control_complete);
+
+	mpt3sas_ctl_init();
+
+	error = pci_register_driver(&scsih_driver);
+	if (error) {
+		/* raid transport support */
+		raid_class_release(mpt3sas_raid_template);
+		sas_release_transport(mpt3sas_transport_template);
+	}
+
+	return error;
+}
+
+/**
+ * _scsih_exit - exit point for this driver (when it is a module).
+ *
+ * Returns 0 success, anything else error.
+ */
+static void __exit
+_scsih_exit(void)
+{
+	pr_info("mpt3sas version %s unloading\n",
+	    MPT3SAS_DRIVER_VERSION);
+
+	mpt3sas_ctl_exit();
+
+	pci_unregister_driver(&scsih_driver);
+
+
+	mpt3sas_base_release_callback_handler(scsi_io_cb_idx);
+	mpt3sas_base_release_callback_handler(tm_cb_idx);
+	mpt3sas_base_release_callback_handler(base_cb_idx);
+	mpt3sas_base_release_callback_handler(port_enable_cb_idx);
+	mpt3sas_base_release_callback_handler(transport_cb_idx);
+	mpt3sas_base_release_callback_handler(scsih_cb_idx);
+	mpt3sas_base_release_callback_handler(config_cb_idx);
+	mpt3sas_base_release_callback_handler(ctl_cb_idx);
+
+	mpt3sas_base_release_callback_handler(tm_tr_cb_idx);
+	mpt3sas_base_release_callback_handler(tm_tr_volume_cb_idx);
+	mpt3sas_base_release_callback_handler(tm_sas_control_cb_idx);
+
+/* raid transport support */
+	raid_class_release(mpt3sas_raid_template);
+	sas_release_transport(mpt3sas_transport_template);
+}
+
+module_init(_scsih_init);
+module_exit(_scsih_exit);
