From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 11/22] mpt fusion: RESEND [2.6.30-rc6] Firmware event implementation using seperate WorkQueue
Date: Wed, 27 May 2009 18:04:27 +0530
Message-ID: <20090527123419.GL20010@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og117.obsmtp.com ([64.18.2.6]:56011 "EHLO
	exprod7og117.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758765AbZE0Mzw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2009 08:55:52 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

1) 	Now Firmware events are handled by firmware event queue.
	Previously it was handled in interrupt context/WorkQueue of Linux.
	Firmware Event handling is restructured and optimized.
---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index ae203ec..d67b263 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1931,6 +1931,11 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	 */
 	mpt_detect_bound_ports(ioc, pdev);
 
+	INIT_LIST_HEAD(&ioc->fw_event_list);
+	spin_lock_init(&ioc->fw_event_lock);
+	snprintf(ioc->fw_event_q_name, 20, "mpt/%d", ioc->id);
+	ioc->fw_event_q = create_singlethread_workqueue(ioc->fw_event_q_name);
+
 	if ((r = mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_BRINGUP,
 	    CAN_SLEEP)) != 0){
 		printk(MYIOC_s_ERR_FMT "didn't initialize properly! (%d)\n",
@@ -2010,6 +2015,11 @@ mpt_detach(struct pci_dev *pdev)
 	cancel_delayed_work(&ioc->fault_reset_work);
 	destroy_workqueue(wq);
 
+	spin_lock_irqsave(&ioc->fw_event_lock, flags);
+	wq = ioc->fw_event_q;
+	ioc->fw_event_q = NULL;
+	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
+	destroy_workqueue(wq);
 
 	sprintf(pname, MPT_PROCFS_MPTBASEDIR "/%s/summary", ioc->name);
 	remove_proc_entry(pname, NULL);
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 24d6012..b6efc64 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -694,9 +694,18 @@ typedef struct _MPT_ADAPTER
 	struct net_device	*netdev;
 	struct list_head	 sas_topology;
 	struct mutex		 sas_topology_mutex;
+
+	struct workqueue_struct	*fw_event_q;
+	struct list_head	 fw_event_list;
+	spinlock_t		 fw_event_lock;
+	u8			 fw_events_off; /* if '1', then ignore events */
+	char 			 fw_event_q_name[20];
+
 	struct mutex		 sas_discovery_mutex;
 	u8			 sas_discovery_runtime;
 	u8			 sas_discovery_ignore_events;
+	struct list_head	 sas_device_info_list;
+	struct mutex		 sas_device_info_mutex;
 	u8			 sas_discovery_quiesce_io;
 	int			 sas_index; /* index refrencing */
 	MPT_MGMT		 sas_mgmt;
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index eb6b10e..38403b2 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -95,7 +95,24 @@ static u8	mptsasInternalCtx = MPT_MAX_PROTOCOL_DRIVERS; /* Used only for interna
 static u8	mptsasMgmtCtx = MPT_MAX_PROTOCOL_DRIVERS;
 static u8	mptsasDeviceResetCtx = MPT_MAX_PROTOCOL_DRIVERS;
 
-static void mptsas_hotplug_work(struct work_struct *work);
+static void mptsas_firmware_event_work(struct work_struct *work);
+static void mptsas_send_sas_event(struct fw_event_work *fw_event);
+static void mptsas_send_raid_event(struct fw_event_work *fw_event);
+static void mptsas_send_ir2_event(struct fw_event_work *fw_event);
+static void mptsas_parse_device_info(struct sas_identify *identify,
+		struct mptsas_devinfo *device_info);
+static inline void mptsas_set_rphy(MPT_ADAPTER *ioc,
+		struct mptsas_phyinfo *phy_info, struct sas_rphy *rphy);
+static struct mptsas_phyinfo	*mptsas_find_phyinfo_by_sas_address
+		(MPT_ADAPTER *ioc, u64 sas_address);
+static int mptsas_sas_device_pg0(MPT_ADAPTER *ioc,
+	struct mptsas_devinfo *device_info, u32 form, u32 form_specific);
+static int mptsas_sas_enclosure_pg0(MPT_ADAPTER *ioc,
+	struct mptsas_enclosure *enclosure, u32 form, u32 form_specific);
+static int mptsas_add_end_device(MPT_ADAPTER *ioc,
+	struct mptsas_phyinfo *phy_info);
+static void mptsas_del_end_device(MPT_ADAPTER *ioc,
+	struct mptsas_phyinfo *phy_info);
 
 static void mptsas_print_phy_data(MPT_ADAPTER *ioc,
 					MPI_SAS_IO_UNIT0_PHY_DATA *phy_data)
@@ -219,6 +236,100 @@ static void mptsas_print_expander_pg1(MPT_ADAPTER *ioc, SasExpanderPage1_t *pg1)
 	    le16_to_cpu(pg1->AttachedDevHandle)));
 }
 
+/* inhibit sas firmware event handling */
+static void
+mptsas_fw_event_off(MPT_ADAPTER *ioc)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ioc->fw_event_lock, flags);
+	ioc->fw_events_off = 1;
+	ioc->sas_discovery_quiesce_io = 0;
+	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
+
+}
+
+/* enable sas firmware event handling */
+static void
+mptsas_fw_event_on(MPT_ADAPTER *ioc)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ioc->fw_event_lock, flags);
+	ioc->fw_events_off = 0;
+	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
+}
+
+/* queue a sas firmware event */
+static void
+mptsas_add_fw_event(MPT_ADAPTER *ioc, struct fw_event_work *fw_event,
+    unsigned long delay)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ioc->fw_event_lock, flags);
+	list_add_tail(&fw_event->list, &ioc->fw_event_list);
+	INIT_DELAYED_WORK(&fw_event->work, mptsas_firmware_event_work);
+	devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT "%s: add (fw_event=0x%p)\n",
+	    ioc->name, __func__, fw_event));
+	queue_delayed_work(ioc->fw_event_q, &fw_event->work,
+	    delay);
+	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
+}
+
+/* free memory assoicated to a sas firmware event */
+static void
+mptsas_free_fw_event(MPT_ADAPTER *ioc, struct fw_event_work *fw_event)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ioc->fw_event_lock, flags);
+	devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT "%s: kfree (fw_event=0x%p)\n",
+	    ioc->name, __func__, fw_event));
+	list_del(&fw_event->list);
+	kfree(fw_event);
+	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
+}
+
+/* walk the firmware event queue, and either stop or wait for
+ * outstanding events to complete */
+static void
+mptsas_cleanup_fw_event_q(MPT_ADAPTER *ioc)
+{
+	struct fw_event_work *fw_event, *next;
+	struct mptsas_target_reset_event *target_reset_list, *n;
+	u8	flush_q;
+	MPT_SCSI_HOST	*hd = shost_priv(ioc->sh);
+
+	/* flush the target_reset_list */
+	if (!list_empty(&hd->target_reset_list)) {
+		list_for_each_entry_safe(target_reset_list, n,
+		    &hd->target_reset_list, list) {
+			dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+			    "%s: removing target reset for id=%d\n",
+			    ioc->name, __func__,
+			   target_reset_list->sas_event_data.TargetID));
+			list_del(&target_reset_list->list);
+			kfree(target_reset_list);
+		}
+	}
+
+	if (list_empty(&ioc->fw_event_list) ||
+	     !ioc->fw_event_q || in_interrupt())
+		return;
+
+	flush_q = 0;
+	list_for_each_entry_safe(fw_event, next, &ioc->fw_event_list, list) {
+		if (cancel_delayed_work(&fw_event->work))
+			mptsas_free_fw_event(ioc, fw_event);
+		else
+			flush_q = 1;
+	}
+	if (flush_q)
+		flush_workqueue(ioc->fw_event_q);
+}
+
+
 static inline MPT_ADAPTER *phy_to_ioc(struct sas_phy *phy)
 {
 	struct Scsi_Host *shost = dev_to_shost(phy->dev.parent);
@@ -309,6 +420,7 @@ mptsas_port_delete(MPT_ADAPTER *ioc, struct mptsas_portinfo_details * port_detai
 		if(phy_info->port_details != port_details)
 			continue;
 		memset(&phy_info->attached, 0, sizeof(struct mptsas_devinfo));
+		mptsas_set_rphy(ioc, phy_info, NULL);
 		phy_info->port_details = NULL;
 	}
 	kfree(port_details);
@@ -380,6 +492,157 @@ starget)
 		phy_info->port_details->starget = starget;
 }
 
+/**
+ *	mptsas_add_device_component -
+ *	@ioc: Pointer to MPT_ADAPTER structure
+ *	@channel: fw mapped id's
+ *	@id:
+ *	@sas_address:
+ *	@device_info:
+ *
+ **/
+static void
+mptsas_add_device_component(MPT_ADAPTER *ioc, u8 channel, u8 id,
+	u64 sas_address, u32 device_info, u16 slot, u64 enclosure_logical_id)
+{
+	struct sas_device_info	*sas_info, *next;
+	struct scsi_device	*sdev;
+	struct scsi_target	*starget;
+	struct sas_rphy	*rphy;
+
+	/*
+	 * Delete all matching devices out of the list
+	 */
+	mutex_lock(&ioc->sas_device_info_mutex);
+	list_for_each_entry_safe(sas_info, next, &ioc->sas_device_info_list,
+	    list) {
+		if ((sas_info->sas_address == sas_address ||
+			(sas_info->fw.channel == channel &&
+			sas_info->fw.id == id))) {
+			list_del(&sas_info->list);
+			kfree(sas_info);
+		}
+	}
+
+	sas_info = kzalloc(sizeof(struct sas_device_info), GFP_KERNEL);
+	if (!sas_info)
+		goto out;
+
+	/*
+	 * Set Firmware mapping
+	 */
+	sas_info->fw.id = id;
+	sas_info->fw.channel = channel;
+
+	sas_info->sas_address = sas_address;
+	sas_info->device_info = device_info;
+	sas_info->slot = slot;
+	sas_info->enclosure_logical_id = enclosure_logical_id;
+	INIT_LIST_HEAD(&sas_info->list);
+	list_add_tail(&sas_info->list, &ioc->sas_device_info_list);
+
+	/*
+	 * Set OS mapping
+	 */
+	shost_for_each_device(sdev, ioc->sh) {
+		starget = scsi_target(sdev);
+		rphy = dev_to_rphy(starget->dev.parent);
+		if (rphy->identify.sas_address == sas_address) {
+			sas_info->os.id = starget->id;
+			sas_info->os.channel = starget->channel;
+		}
+	}
+
+ out:
+	mutex_unlock(&ioc->sas_device_info_mutex);
+	return;
+}
+
+/**
+ *	mptsas_add_device_component_by_fw -
+ *	@ioc: Pointer to MPT_ADAPTER structure
+ *	@channel:  fw mapped id's
+ *	@id:
+ *
+ **/
+static void
+mptsas_add_device_component_by_fw(MPT_ADAPTER *ioc, u8 channel, u8 id)
+{
+	struct mptsas_devinfo sas_device;
+	struct mptsas_enclosure enclosure_info;
+	int rc;
+
+	rc = mptsas_sas_device_pg0(ioc, &sas_device,
+	    (MPI_SAS_DEVICE_PGAD_FORM_BUS_TARGET_ID <<
+	     MPI_SAS_DEVICE_PGAD_FORM_SHIFT),
+	    (channel << 8) + id);
+	if (rc)
+		return;
+
+	memset(&enclosure_info, 0, sizeof(struct mptsas_enclosure));
+	mptsas_sas_enclosure_pg0(ioc, &enclosure_info,
+	    (MPI_SAS_ENCLOS_PGAD_FORM_HANDLE <<
+	     MPI_SAS_ENCLOS_PGAD_FORM_SHIFT),
+	     sas_device.handle_enclosure);
+
+	mptsas_add_device_component(ioc, sas_device.channel,
+	    sas_device.id, sas_device.sas_address, sas_device.device_info,
+	    sas_device.slot, enclosure_info.enclosure_logical_id);
+}
+
+/**
+ *	mptsas_add_device_component_starget -
+ *	@ioc: Pointer to MPT_ADAPTER structure
+ *	@starget:
+ *
+ **/
+static void
+mptsas_add_device_component_starget(MPT_ADAPTER *ioc,
+	struct scsi_target *starget)
+{
+	VirtTarget	*vtarget;
+	struct sas_rphy	*rphy;
+	struct mptsas_phyinfo	*phy_info = NULL;
+	struct mptsas_enclosure	enclosure_info;
+
+	rphy = dev_to_rphy(starget->dev.parent);
+	vtarget = starget->hostdata;
+	phy_info = mptsas_find_phyinfo_by_sas_address(ioc,
+			rphy->identify.sas_address);
+	if (!phy_info)
+		return;
+
+	memset(&enclosure_info, 0, sizeof(struct mptsas_enclosure));
+	mptsas_sas_enclosure_pg0(ioc, &enclosure_info,
+		(MPI_SAS_ENCLOS_PGAD_FORM_HANDLE <<
+		MPI_SAS_ENCLOS_PGAD_FORM_SHIFT),
+		phy_info->attached.handle_enclosure);
+
+	mptsas_add_device_component(ioc, phy_info->attached.channel,
+		phy_info->attached.id, phy_info->attached.sas_address,
+		phy_info->attached.device_info,
+		phy_info->attached.slot, enclosure_info.enclosure_logical_id);
+}
+
+/**
+ *	mptsas_del_device_components - Cleaning the list
+ *	@ioc: Pointer to MPT_ADAPTER structure
+ *
+ **/
+static void
+mptsas_del_device_components(MPT_ADAPTER *ioc)
+{
+	struct sas_device_info	*sas_info, *next;
+
+	mutex_lock(&ioc->sas_device_info_mutex);
+	list_for_each_entry_safe(sas_info, next, &ioc->sas_device_info_list,
+		list) {
+		list_del(&sas_info->list);
+		kfree(sas_info);
+	}
+	mutex_unlock(&ioc->sas_device_info_mutex);
+}
+
 
 /*
  * mptsas_setup_wide_ports
@@ -535,6 +798,29 @@ mptsas_find_vtarget(MPT_ADAPTER *ioc, u8 channel, u8 id)
 	return vtarget;
 }
 
+static void
+mptsas_queue_device_delete(MPT_ADAPTER *ioc,
+	MpiEventDataSasDeviceStatusChange_t *sas_event_data)
+{
+	struct fw_event_work *fw_event;
+	int sz;
+
+	sz = offsetof(struct fw_event_work, event_data) +
+	    sizeof(MpiEventDataSasDeviceStatusChange_t);
+	fw_event = kzalloc(sz, GFP_ATOMIC);
+	if (!fw_event) {
+		printk(MYIOC_s_WARN_FMT "%s: failed at (line=%d)\n",
+		    ioc->name, __func__, __LINE__);
+		return;
+	}
+	memcpy(fw_event->event_data, sas_event_data,
+	    sizeof(MpiEventDataSasDeviceStatusChange_t));
+	fw_event->event = MPI_EVENT_SAS_DEVICE_STATUS_CHANGE;
+	fw_event->ioc = ioc;
+	mptsas_add_fw_event(ioc, fw_event, msecs_to_jiffies(1));
+}
+
+
 /**
  * mptsas_target_reset
  *
@@ -654,10 +940,8 @@ mptsas_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 {
 	MPT_SCSI_HOST	*hd = shost_priv(ioc->sh);
         struct list_head *head = &hd->target_reset_list;
-	struct mptsas_hotplug_event *ev;
 	EVENT_DATA_SAS_DEVICE_STATUS_CHANGE *sas_event_data;
 	u8		id, channel;
-	__le64		sas_address;
 	struct mptsas_target_reset_event	*target_reset_list;
 	SCSITaskMgmtReply_t *pScsiTmReply;
 
@@ -729,41 +1013,9 @@ mptsas_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 	 * enable work queue to remove device from upper layers
 	 */
 	list_del(&target_reset_list->list);
-
-	ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
-	if (!ev) {
-		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT "%s, failed to allocate mem @%d..!!\n",
-		    ioc->name,__func__, __LINE__));
-		goto out_fail;
-	}
-
-	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "TaskMgmt request (mf=%p)\n",
-		ioc->name, mf));
-
-	INIT_WORK(&ev->work, mptsas_hotplug_work);
-	ev->ioc = ioc;
-	ev->handle = le16_to_cpu(sas_event_data->DevHandle);
-	ev->parent_handle =
-	    le16_to_cpu(sas_event_data->ParentDevHandle);
-	ev->channel = channel;
-	ev->id =id;
-	ev->phy_id = sas_event_data->PhyNum;
-	memcpy(&sas_address, &sas_event_data->SASAddress,
-	    sizeof(__le64));
-	ev->sas_address = le64_to_cpu(sas_address);
-	ev->device_info = le32_to_cpu(sas_event_data->DeviceInfo);
-	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-	   "TaskMgmt type=%d (sas device delete) fw_channel = %d fw_id = %d)\n",
-	   ioc->name, MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET, channel, id));
-
-	ev->event_type = MPTSAS_DEL_DEVICE;
-	schedule_work(&ev->work);
-	kfree(target_reset_list);
-
- out_fail:
-
-	mpt_clear_taskmgmt_in_progress_flag(ioc);
-	return 0;
+	if ((mptsas_find_vtarget(ioc, channel, id)) && !ioc->fw_events_off)
+		mptsas_queue_device_delete(ioc,
+			&target_reset_list->sas_event_data);
 
 
 	/*
@@ -798,37 +1050,58 @@ static int
 mptsas_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
 {
 	MPT_SCSI_HOST	*hd;
-	struct mptsas_target_reset_event *target_reset_list, *n;
 	int rc;
 
 	rc = mptscsih_ioc_reset(ioc, reset_phase);
+	if ((ioc->bus_type != SAS) || (!rc))
+		return rc;
 
-	if (ioc->bus_type != SAS)
-		goto out;
-
-	if (reset_phase != MPT_IOC_POST_RESET)
-		goto out;
-
-	if (!ioc->sh || !ioc->sh->hostdata)
-		goto out;
 	hd = shost_priv(ioc->sh);
 	if (!hd->ioc)
 		goto out;
 
-	if (list_empty(&hd->target_reset_list))
-		goto out;
-
-	/* flush the target_reset_list */
-	list_for_each_entry_safe(target_reset_list, n,
-	    &hd->target_reset_list, list) {
-		list_del(&target_reset_list->list);
-		kfree(target_reset_list);
+	switch (reset_phase) {
+	case MPT_IOC_SETUP_RESET:
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "%s: MPT_IOC_SETUP_RESET\n", ioc->name, __func__));
+		mptsas_fw_event_off(ioc);
+		break;
+	case MPT_IOC_PRE_RESET:
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "%s: MPT_IOC_PRE_RESET\n", ioc->name, __func__));
+		break;
+	case MPT_IOC_POST_RESET:
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "%s: MPT_IOC_POST_RESET\n", ioc->name, __func__));
+		if (ioc->sas_mgmt.status & MPT_MGMT_STATUS_PENDING) {
+			ioc->sas_mgmt.status |= MPT_MGMT_STATUS_DID_IOCRESET;
+			complete(&ioc->sas_mgmt.done);
+		}
+		mptsas_cleanup_fw_event_q(ioc);
+		mptsas_fw_event_on(ioc);
+		break;
+	default:
+		break;
 	}
 
  out:
 	return rc;
 }
 
+
+/**
+ * enum device_state -
+ * @DEVICE_RETRY: need to retry the TUR
+ * @DEVICE_ERROR: TUR return error, don't add device
+ * @DEVICE_READY: device can be added
+ *
+ */
+enum device_state{
+	DEVICE_RETRY,
+	DEVICE_ERROR,
+	DEVICE_READY,
+};
+
 static int
 mptsas_sas_enclosure_pg0(MPT_ADAPTER *ioc, struct mptsas_enclosure *enclosure,
 		u32 form, u32 form_specific)
@@ -894,15 +1167,268 @@ mptsas_sas_enclosure_pg0(MPT_ADAPTER *ioc, struct mptsas_enclosure *enclosure,
 	return error;
 }
 
+/**
+ *	mptsas_add_end_device - report a new end device to sas transport layer
+ *	@ioc: Pointer to MPT_ADAPTER structure
+ *	@phy_info: decribes attached device
+ *
+ *	return (0) success (1) failure
+ *
+ **/
+static int
+mptsas_add_end_device(MPT_ADAPTER *ioc, struct mptsas_phyinfo *phy_info)
+{
+	struct sas_rphy *rphy;
+	struct sas_port *port;
+	struct sas_identify identify;
+	char *ds = NULL;
+	u8 fw_id;
+
+	if (!phy_info) {
+		dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
+			"%s: exit at line=%d\n", ioc->name,
+			 __func__, __LINE__));
+		return 1;
+	}
+
+	fw_id = phy_info->attached.id;
+
+	if (mptsas_get_rphy(phy_info)) {
+		dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
+			"%s: fw_id=%d exit at line=%d\n", ioc->name,
+			 __func__, fw_id, __LINE__));
+		return 2;
+	}
+
+	port = mptsas_get_port(phy_info);
+	if (!port) {
+		dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
+			"%s: fw_id=%d exit at line=%d\n", ioc->name,
+			 __func__, fw_id, __LINE__));
+		return 3;
+	}
+
+	if (phy_info->attached.device_info &
+	    MPI_SAS_DEVICE_INFO_SSP_TARGET)
+		ds = "ssp";
+	if (phy_info->attached.device_info &
+	    MPI_SAS_DEVICE_INFO_STP_TARGET)
+		ds = "stp";
+	if (phy_info->attached.device_info &
+	    MPI_SAS_DEVICE_INFO_SATA_DEVICE)
+		ds = "sata";
+
+	printk(MYIOC_s_INFO_FMT "attaching %s device: fw_channel %d, fw_id %d,"
+	    " phy %d, sas_addr 0x%llx\n", ioc->name, ds,
+	    phy_info->attached.channel, phy_info->attached.id,
+	    phy_info->attached.phy_id, (unsigned long long)
+	    phy_info->attached.sas_address);
+
+	mptsas_parse_device_info(&identify, &phy_info->attached);
+	rphy = sas_end_device_alloc(port);
+	if (!rphy) {
+		dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
+			"%s: fw_id=%d exit at line=%d\n", ioc->name,
+			 __func__, fw_id, __LINE__));
+		return 5; /* non-fatal: an rphy can be added later */
+	}
+
+	rphy->identify = identify;
+	if (sas_rphy_add(rphy)) {
+		dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
+			"%s: fw_id=%d exit at line=%d\n", ioc->name,
+			 __func__, fw_id, __LINE__));
+		sas_rphy_free(rphy);
+		return 6;
+	}
+	mptsas_set_rphy(ioc, phy_info, rphy);
+	return 0;
+}
+
+/**
+ *	mptsas_del_end_device - report a deleted end device to sas transport
+ *	layer
+ *	@ioc: Pointer to MPT_ADAPTER structure
+ *	@phy_info: decribes attached device
+ *
+ **/
+static void
+mptsas_del_end_device(MPT_ADAPTER *ioc, struct mptsas_phyinfo *phy_info)
+{
+	struct sas_rphy *rphy;
+	struct sas_port *port;
+	struct mptsas_portinfo *port_info;
+	struct mptsas_phyinfo *phy_info_parent;
+	int i;
+	char *ds = NULL;
+	u8 fw_id;
+	u64 sas_address;
+
+	if (!phy_info)
+		return;
+
+	fw_id = phy_info->attached.id;
+	sas_address = phy_info->attached.sas_address;
+
+	if (!phy_info->port_details) {
+		dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
+			"%s: fw_id=%d exit at line=%d\n", ioc->name,
+			 __func__, fw_id, __LINE__));
+		return;
+	}
+	rphy = mptsas_get_rphy(phy_info);
+	if (!rphy) {
+		dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
+			"%s: fw_id=%d exit at line=%d\n", ioc->name,
+			 __func__, fw_id, __LINE__));
+		return;
+	}
+
+	if (phy_info->attached.device_info & MPI_SAS_DEVICE_INFO_SSP_INITIATOR
+		|| phy_info->attached.device_info
+			& MPI_SAS_DEVICE_INFO_SMP_INITIATOR
+		|| phy_info->attached.device_info
+			& MPI_SAS_DEVICE_INFO_STP_INITIATOR)
+		ds = "initiator";
+	if (phy_info->attached.device_info &
+	    MPI_SAS_DEVICE_INFO_SSP_TARGET)
+		ds = "ssp";
+	if (phy_info->attached.device_info &
+	    MPI_SAS_DEVICE_INFO_STP_TARGET)
+		ds = "stp";
+	if (phy_info->attached.device_info &
+	    MPI_SAS_DEVICE_INFO_SATA_DEVICE)
+		ds = "sata";
+
+	dev_printk(KERN_DEBUG, &rphy->dev, MYIOC_s_FMT
+	    "removing %s device: fw_channel %d, fw_id %d, phy %d,"
+	    "sas_addr 0x%llx\n", ioc->name, ds, phy_info->attached.channel,
+	    phy_info->attached.id, phy_info->attached.phy_id,
+	    (unsigned long long) sas_address);
+
+	port = mptsas_get_port(phy_info);
+	if (!port) {
+		dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
+			"%s: fw_id=%d exit at line=%d\n", ioc->name,
+			 __func__, fw_id, __LINE__));
+		return;
+	}
+	port_info = phy_info->portinfo;
+	phy_info_parent = port_info->phy_info;
+	for (i = 0; i < port_info->num_phys; i++, phy_info_parent++) {
+		if (!phy_info_parent->phy)
+			continue;
+		if (phy_info_parent->attached.sas_address !=
+		    sas_address)
+			continue;
+		dev_printk(KERN_DEBUG, &phy_info_parent->phy->dev,
+		    MYIOC_s_FMT "delete phy %d, phy-obj (0x%p)\n",
+		    ioc->name, phy_info_parent->phy_id,
+		    phy_info_parent->phy);
+		sas_port_delete_phy(port, phy_info_parent->phy);
+	}
+
+	dev_printk(KERN_DEBUG, &port->dev, MYIOC_s_FMT
+	    "delete port %d, sas_addr (0x%llx)\n", ioc->name,
+	     port->port_identifier, (unsigned long long)sas_address);
+	sas_port_delete(port);
+	mptsas_set_port(ioc, phy_info, NULL);
+	mptsas_port_delete(ioc, phy_info->port_details);
+}
+
+struct mptsas_phyinfo *
+mptsas_refreshing_device_handles(MPT_ADAPTER *ioc,
+	struct mptsas_devinfo *sas_device)
+{
+	struct mptsas_phyinfo *phy_info;
+	struct mptsas_portinfo *port_info;
+	int i;
+
+	phy_info = mptsas_find_phyinfo_by_sas_address(ioc,
+	    sas_device->sas_address);
+	if (!phy_info)
+		goto out;
+	port_info = phy_info->portinfo;
+	if (!port_info)
+		goto out;
+	mutex_lock(&ioc->sas_topology_mutex);
+	for (i = 0; i < port_info->num_phys; i++) {
+		if (port_info->phy_info[i].attached.sas_address !=
+			sas_device->sas_address)
+			continue;
+		port_info->phy_info[i].attached.channel = sas_device->channel;
+		port_info->phy_info[i].attached.id = sas_device->id;
+		port_info->phy_info[i].attached.sas_address =
+		    sas_device->sas_address;
+		port_info->phy_info[i].attached.handle = sas_device->handle;
+		port_info->phy_info[i].attached.handle_parent =
+		    sas_device->handle_parent;
+		port_info->phy_info[i].attached.handle_enclosure =
+		    sas_device->handle_enclosure;
+	}
+	mutex_unlock(&ioc->sas_topology_mutex);
+ out:
+	return phy_info;
+}
+
+/**
+ * mptsas_firmware_event_work - work thread for processing fw events
+ * @work: work queue payload containing info describing the event
+ * Context: user
+ *
+ */
+static void
+mptsas_firmware_event_work(struct work_struct *work)
+{
+	struct fw_event_work *fw_event =
+		container_of(work, struct fw_event_work, work.work);
+	MPT_ADAPTER *ioc = fw_event->ioc;
+
+
+	/* events handling turned off during host reset */
+	if (ioc->fw_events_off) {
+		mptsas_free_fw_event(ioc, fw_event);
+		return;
+	}
+
+	devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT "%s: fw_event=(0x%p), "
+	    "event = (0x%02x)\n", ioc->name, __func__, fw_event,
+	    (fw_event->event & 0xFF)));
+
+	switch (fw_event->event) {
+	case MPI_EVENT_SAS_DEVICE_STATUS_CHANGE:
+		mptsas_send_sas_event(fw_event);
+		break;
+	case MPI_EVENT_INTEGRATED_RAID:
+		mptsas_send_raid_event(fw_event);
+		break;
+	case MPI_EVENT_IR2:
+		mptsas_send_ir2_event(fw_event);
+		break;
+	case MPI_EVENT_PERSISTENT_TABLE_FULL:
+		mptbase_sas_persist_operation(ioc,
+		    MPI_SAS_OP_CLEAR_NOT_PRESENT);
+		mptsas_free_fw_event(ioc, fw_event);
+		break;
+	}
+}
+
+
+
 static int
 mptsas_slave_configure(struct scsi_device *sdev)
 {
+	struct Scsi_Host	*host = sdev->host;
+	MPT_SCSI_HOST	*hd = shost_priv(host);
+	MPT_ADAPTER	*ioc = hd->ioc;
 
 	if (sdev->channel == MPTSAS_RAID_CHANNEL)
 		goto out;
 
 	sas_read_port_mode_page(sdev);
 
+	mptsas_add_device_component_starget(ioc, scsi_target(sdev));
+
  out:
 	return mptscsih_slave_configure(sdev);
 }
@@ -984,11 +1510,15 @@ mptsas_target_destroy(struct scsi_target *starget)
 	struct sas_rphy		*rphy;
 	struct mptsas_portinfo	*p;
 	int 			 i;
-	MPT_ADAPTER *ioc = hd->ioc;
+	MPT_ADAPTER	*ioc = hd->ioc;
+	VirtTarget	*vtarget;
 
 	if (!starget->hostdata)
 		return;
 
+	vtarget = starget->hostdata;
+
+
 	if (starget->channel == MPTSAS_RAID_CHANNEL)
 		goto out;
 
@@ -998,12 +1528,21 @@ mptsas_target_destroy(struct scsi_target *starget)
 			if (p->phy_info[i].attached.sas_address !=
 					rphy->identify.sas_address)
 				continue;
+
+			starget_printk(KERN_INFO, starget, MYIOC_s_FMT
+			"delete device: fw_channel %d, fw_id %d, phy %d, "
+			"sas_addr 0x%llx\n", ioc->name,
+			p->phy_info[i].attached.channel,
+			p->phy_info[i].attached.id,
+			p->phy_info[i].attached.phy_id, (unsigned long long)
+			p->phy_info[i].attached.sas_address);
+
 			mptsas_set_starget(&p->phy_info[i], NULL);
-			goto out;
 		}
 	}
 
  out:
+	vtarget->starget = NULL;
 	kfree(starget->hostdata);
 	starget->hostdata = NULL;
 }
@@ -2471,6 +3010,7 @@ mptsas_discovery_work(struct work_struct *work)
 	kfree(ev);
 }
 
+
 static struct mptsas_phyinfo *
 mptsas_find_phyinfo_by_sas_address(MPT_ADAPTER *ioc, u64 sas_address)
 {
@@ -2547,17 +3087,6 @@ mptsas_find_phyinfo_by_phys_disk_num(MPT_ADAPTER *ioc, u8 channel, u8 id)
 	return phy_info;
 }
 
-/*
- * Work queue thread to clear the persitency table
- */
-static void
-mptsas_persist_clear_table(struct work_struct *work)
-{
-	MPT_ADAPTER *ioc = container_of(work, MPT_ADAPTER, sas_persist_task);
-
-	mptbase_sas_persist_operation(ioc, MPI_SAS_OP_CLEAR_NOT_PRESENT);
-}
-
 static void
 mptsas_reprobe_lun(struct scsi_device *sdev, void *data)
 {
@@ -2583,7 +3112,8 @@ mptsas_adding_inactive_raid_components(MPT_ADAPTER *ioc, u8 channel, u8 id)
 	pRaidVolumePage0_t		buffer = NULL;
 	RaidPhysDiskPage0_t 		phys_disk;
 	int				i;
-	struct mptsas_hotplug_event 	*ev;
+	struct mptsas_phyinfo	*phy_info;
+	struct mptsas_devinfo		sas_device;
 
 	memset(&cfg, 0 , sizeof(CONFIGPARMS));
 	memset(&hdr, 0 , sizeof(ConfigPageHeader_t));
@@ -2623,20 +3153,16 @@ mptsas_adding_inactive_raid_components(MPT_ADAPTER *ioc, u8 channel, u8 id)
 		    buffer->PhysDisk[i].PhysDiskNum, &phys_disk) != 0)
 			continue;
 
-		ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
-		if (!ev) {
-			printk(MYIOC_s_WARN_FMT "mptsas: lost hotplug event\n", ioc->name);
-			goto out;
-		}
+		if (mptsas_sas_device_pg0(ioc, &sas_device,
+		    (MPI_SAS_DEVICE_PGAD_FORM_BUS_TARGET_ID <<
+		     MPI_SAS_DEVICE_PGAD_FORM_SHIFT),
+			(phys_disk.PhysDiskBus << 8) +
+			phys_disk.PhysDiskID))
+			continue;
 
-		INIT_WORK(&ev->work, mptsas_hotplug_work);
-		ev->ioc = ioc;
-		ev->id = phys_disk.PhysDiskID;
-		ev->channel = phys_disk.PhysDiskBus;
-		ev->phys_disk_num_valid = 1;
-		ev->phys_disk_num = phys_disk.PhysDiskNum;
-		ev->event_type = MPTSAS_ADD_DEVICE;
-		schedule_work(&ev->work);
+		phy_info = mptsas_find_phyinfo_by_sas_address(ioc,
+		    sas_device.sas_address);
+		mptsas_add_end_device(ioc, phy_info);
 	}
 
  out:
@@ -2648,417 +3174,385 @@ mptsas_adding_inactive_raid_components(MPT_ADAPTER *ioc, u8 channel, u8 id)
  * Work queue thread to handle SAS hotplug events
  */
 static void
-mptsas_hotplug_work(struct work_struct *work)
+mptsas_hotplug_work(MPT_ADAPTER *ioc, struct fw_event_work *fw_event,
+    struct mptsas_hotplug_event *hot_plug_info)
 {
-	struct mptsas_hotplug_event *ev =
-		container_of(work, struct mptsas_hotplug_event, work);
-
-	MPT_ADAPTER *ioc = ev->ioc;
 	struct mptsas_phyinfo *phy_info;
-	struct sas_rphy *rphy;
-	struct sas_port *port;
-	struct scsi_device *sdev;
 	struct scsi_target * starget;
-	struct sas_identify identify;
-	char *ds = NULL;
 	struct mptsas_devinfo sas_device;
 	VirtTarget *vtarget;
-	VirtDevice *vdevice;
+	int i;
 
-	mutex_lock(&ioc->sas_discovery_mutex);
-	switch (ev->event_type) {
-	case MPTSAS_DEL_DEVICE:
+	switch (hot_plug_info->event_type) {
 
-		phy_info = NULL;
-		if (ev->phys_disk_num_valid) {
-			if (ev->hidden_raid_component){
-				if (mptsas_sas_device_pg0(ioc, &sas_device,
-				    (MPI_SAS_DEVICE_PGAD_FORM_BUS_TARGET_ID <<
-				     MPI_SAS_DEVICE_PGAD_FORM_SHIFT),
-				    (ev->channel << 8) + ev->id)) {
-					dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
-					"%s: exit at line=%d\n", ioc->name,
-						__func__, __LINE__));
-					break;
-				}
-				phy_info = mptsas_find_phyinfo_by_sas_address(
-				    ioc, sas_device.sas_address);
-			}else
-				phy_info = mptsas_find_phyinfo_by_phys_disk_num(
-				    ioc, ev->channel, ev->phys_disk_num);
+	case MPTSAS_ADD_PHYSDISK:
+
+		if (!ioc->raid_data.pIocPg2)
+			break;
+
+		for (i = 0; i < ioc->raid_data.pIocPg2->NumActiveVolumes; i++) {
+			if (ioc->raid_data.pIocPg2->RaidVolume[i].VolumeID ==
+			    hot_plug_info->id) {
+				printk(MYIOC_s_WARN_FMT "firmware bug: unable "
+				    "to add hidden disk - target_id matchs "
+				    "volume_id\n", ioc->name);
+				mptsas_free_fw_event(ioc, fw_event);
+				return;
+			}
 		}
+		mpt_findImVolumes(ioc);
+
+	case MPTSAS_ADD_DEVICE:
+		memset(&sas_device, 0, sizeof(struct mptsas_devinfo));
+		mptsas_sas_device_pg0(ioc, &sas_device,
+		    (MPI_SAS_DEVICE_PGAD_FORM_BUS_TARGET_ID <<
+		    MPI_SAS_DEVICE_PGAD_FORM_SHIFT),
+		    (hot_plug_info->channel << 8) +
+		    hot_plug_info->id);
+
+		if (!sas_device.handle)
+			return;
 
+		phy_info = mptsas_refreshing_device_handles(ioc, &sas_device);
 		if (!phy_info)
-			phy_info = mptsas_find_phyinfo_by_target(ioc,
-			    ev->channel, ev->id);
+			break;
 
-		/*
-		 * Sanity checks, for non-existing phys and remote rphys.
-		 */
-		if (!phy_info){
+		if (mptsas_get_rphy(phy_info))
+			break;
+
+		mptsas_add_end_device(ioc, phy_info);
+		break;
+
+	case MPTSAS_DEL_DEVICE:
+		phy_info = mptsas_find_phyinfo_by_sas_address(ioc,
+		    hot_plug_info->sas_address);
+		mptsas_del_end_device(ioc, phy_info);
+		break;
+
+	case MPTSAS_DEL_PHYSDISK:
+
+		mpt_findImVolumes(ioc);
+
+		phy_info = mptsas_find_phyinfo_by_phys_disk_num(
+				ioc, hot_plug_info->channel,
+				hot_plug_info->phys_disk_num);
+		mptsas_del_end_device(ioc, phy_info);
+		break;
+
+	case MPTSAS_ADD_PHYSDISK_REPROBE:
+
+		if (mptsas_sas_device_pg0(ioc, &sas_device,
+		    (MPI_SAS_DEVICE_PGAD_FORM_BUS_TARGET_ID <<
+		     MPI_SAS_DEVICE_PGAD_FORM_SHIFT),
+		    (hot_plug_info->channel << 8) + hot_plug_info->id)) {
 			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
-				"%s: exit at line=%d\n", ioc->name,
-				__func__, __LINE__));
+			"%s: fw_id=%d exit at line=%d\n", ioc->name,
+				 __func__, hot_plug_info->id, __LINE__));
 			break;
 		}
-		if (!phy_info->port_details) {
+
+		phy_info = mptsas_find_phyinfo_by_sas_address(
+		    ioc, sas_device.sas_address);
+
+		if (!phy_info) {
 			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
-				"%s: exit at line=%d\n", ioc->name,
-			       	__func__, __LINE__));
+				"%s: fw_id=%d exit at line=%d\n", ioc->name,
+				 __func__, hot_plug_info->id, __LINE__));
 			break;
 		}
-		rphy = mptsas_get_rphy(phy_info);
-		if (!rphy) {
+
+		starget = mptsas_get_starget(phy_info);
+		if (!starget) {
 			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
-				"%s: exit at line=%d\n", ioc->name,
-			       	__func__, __LINE__));
+				"%s: fw_id=%d exit at line=%d\n", ioc->name,
+				 __func__, hot_plug_info->id, __LINE__));
 			break;
 		}
 
-		port = mptsas_get_port(phy_info);
-		if (!port) {
+		vtarget = starget->hostdata;
+		if (!vtarget) {
 			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
-				"%s: exit at line=%d\n", ioc->name,
-			       	__func__, __LINE__));
+				"%s: fw_id=%d exit at line=%d\n", ioc->name,
+				 __func__, hot_plug_info->id, __LINE__));
 			break;
 		}
 
-		starget = mptsas_get_starget(phy_info);
-		if (starget) {
-			vtarget = starget->hostdata;
+		mpt_findImVolumes(ioc);
 
-			if (!vtarget) {
-				dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
-					"%s: exit at line=%d\n", ioc->name,
-					__func__, __LINE__));
-				break;
-			}
+		starget_printk(KERN_INFO, starget, MYIOC_s_FMT "RAID Hidding: "
+		    "fw_channel=%d, fw_id=%d, physdsk %d, sas_addr 0x%llx\n",
+		    ioc->name, hot_plug_info->channel, hot_plug_info->id,
+		    hot_plug_info->phys_disk_num, (unsigned long long)
+		    sas_device.sas_address);
 
-			/*
-			 * Handling  RAID components
-			 */
-			if (ev->phys_disk_num_valid &&
-			    ev->hidden_raid_component) {
-				printk(MYIOC_s_INFO_FMT
-				    "RAID Hidding: channel=%d, id=%d, "
-				    "physdsk %d \n", ioc->name, ev->channel,
-				    ev->id, ev->phys_disk_num);
-				vtarget->id = ev->phys_disk_num;
-				vtarget->tflags |=
-				    MPT_TARGET_FLAGS_RAID_COMPONENT;
-				mptsas_reprobe_target(starget, 1);
-				phy_info->attached.phys_disk_num =
-				    ev->phys_disk_num;
-			break;
-			}
-		}
-
-		if (phy_info->attached.device_info &
-		    MPI_SAS_DEVICE_INFO_SSP_TARGET)
-			ds = "ssp";
-		if (phy_info->attached.device_info &
-		    MPI_SAS_DEVICE_INFO_STP_TARGET)
-			ds = "stp";
-		if (phy_info->attached.device_info &
-		    MPI_SAS_DEVICE_INFO_SATA_DEVICE)
-			ds = "sata";
-
-		printk(MYIOC_s_INFO_FMT
-		       "removing %s device, channel %d, id %d, phy %d\n",
-		       ioc->name, ds, ev->channel, ev->id, phy_info->phy_id);
-		dev_printk(KERN_DEBUG, &port->dev, MYIOC_s_FMT
-		    "delete port (%d)\n", ioc->name, port->port_identifier);
-		sas_port_delete(port);
-		mptsas_port_delete(ioc, phy_info->port_details);
+		vtarget->id = hot_plug_info->phys_disk_num;
+		vtarget->tflags |= MPT_TARGET_FLAGS_RAID_COMPONENT;
+		phy_info->attached.phys_disk_num = hot_plug_info->phys_disk_num;
+		mptsas_reprobe_target(starget, 1);
 		break;
-	case MPTSAS_ADD_DEVICE:
 
-		if (ev->phys_disk_num_valid)
-			mpt_findImVolumes(ioc);
+	case MPTSAS_DEL_PHYSDISK_REPROBE:
 
-		/*
-		 * Refresh sas device pg0 data
-		 */
 		if (mptsas_sas_device_pg0(ioc, &sas_device,
 		    (MPI_SAS_DEVICE_PGAD_FORM_BUS_TARGET_ID <<
 		     MPI_SAS_DEVICE_PGAD_FORM_SHIFT),
-			(ev->channel << 8) + ev->id)) {
+			(hot_plug_info->channel << 8) + hot_plug_info->id)) {
 				dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
-					"%s: exit at line=%d\n", ioc->name,
-					__func__, __LINE__));
+				    "%s: fw_id=%d exit at line=%d\n",
+				    ioc->name, __func__,
+				    hot_plug_info->id, __LINE__));
 			break;
 		}
 
-		__mptsas_discovery_work(ioc);
-
 		phy_info = mptsas_find_phyinfo_by_sas_address(ioc,
 				sas_device.sas_address);
-
-		if (!phy_info || !phy_info->port_details) {
+		if (!phy_info) {
 			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
-				"%s: exit at line=%d\n", ioc->name,
-			       	__func__, __LINE__));
+			    "%s: fw_id=%d exit at line=%d\n", ioc->name,
+			 __func__, hot_plug_info->id, __LINE__));
 			break;
 		}
 
 		starget = mptsas_get_starget(phy_info);
-		if (starget && (!ev->hidden_raid_component)){
-
-			vtarget = starget->hostdata;
-
-			if (!vtarget) {
-				dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
-				    "%s: exit at line=%d\n", ioc->name,
-				    __func__, __LINE__));
-				break;
-			}
-			/*
-			 * Handling  RAID components
-			 */
-			if (vtarget->tflags & MPT_TARGET_FLAGS_RAID_COMPONENT) {
-				printk(MYIOC_s_INFO_FMT
-				    "RAID Exposing: channel=%d, id=%d, "
-				    "physdsk %d \n", ioc->name, ev->channel,
-				    ev->id, ev->phys_disk_num);
-				vtarget->tflags &=
-				    ~MPT_TARGET_FLAGS_RAID_COMPONENT;
-				vtarget->id = ev->id;
-				mptsas_reprobe_target(starget, 0);
-				phy_info->attached.phys_disk_num = ~0;
-			}
+		if (!starget) {
+			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
+			    "%s: fw_id=%d exit at line=%d\n", ioc->name,
+			 __func__, hot_plug_info->id, __LINE__));
 			break;
 		}
 
-		if (mptsas_get_rphy(phy_info)) {
+		vtarget = starget->hostdata;
+		if (!vtarget) {
 			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
-				"%s: exit at line=%d\n", ioc->name,
-			       	__func__, __LINE__));
-			if (ev->channel) printk("%d\n", __LINE__);
+			    "%s: fw_id=%d exit at line=%d\n", ioc->name,
+			 __func__, hot_plug_info->id, __LINE__));
 			break;
 		}
 
-		port = mptsas_get_port(phy_info);
-		if (!port) {
+		if (!(vtarget->tflags & MPT_TARGET_FLAGS_RAID_COMPONENT)) {
 			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
-				"%s: exit at line=%d\n", ioc->name,
-			       	__func__, __LINE__));
+			    "%s: fw_id=%d exit at line=%d\n", ioc->name,
+			 __func__, hot_plug_info->id, __LINE__));
 			break;
 		}
-		memcpy(&phy_info->attached, &sas_device,
-		    sizeof(struct mptsas_devinfo));
-
-		if (phy_info->attached.device_info &
-		    MPI_SAS_DEVICE_INFO_SSP_TARGET)
-			ds = "ssp";
-		if (phy_info->attached.device_info &
-		    MPI_SAS_DEVICE_INFO_STP_TARGET)
-			ds = "stp";
-		if (phy_info->attached.device_info &
-		    MPI_SAS_DEVICE_INFO_SATA_DEVICE)
-			ds = "sata";
-
-		printk(MYIOC_s_INFO_FMT
-		       "attaching %s device, channel %d, id %d, phy %d\n",
-		       ioc->name, ds, ev->channel, ev->id, ev->phy_id);
 
-		mptsas_parse_device_info(&identify, &phy_info->attached);
-		rphy = sas_end_device_alloc(port);
-		if (!rphy) {
-			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
-				"%s: exit at line=%d\n", ioc->name,
-			       	__func__, __LINE__));
-			break; /* non-fatal: an rphy can be added later */
-		}
+		mpt_findImVolumes(ioc);
 
-		rphy->identify = identify;
-		if (sas_rphy_add(rphy)) {
-			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
-				"%s: exit at line=%d\n", ioc->name,
-			       	__func__, __LINE__));
-			sas_rphy_free(rphy);
-			break;
-		}
-		mptsas_set_rphy(ioc, phy_info, rphy);
+		starget_printk(KERN_INFO, starget, MYIOC_s_FMT "RAID Exposing:"
+		    " fw_channel=%d, fw_id=%d, physdsk %d, sas_addr 0x%llx\n",
+		    ioc->name, hot_plug_info->channel, hot_plug_info->id,
+		    hot_plug_info->phys_disk_num, (unsigned long long)
+		    sas_device.sas_address);
+
+		vtarget->tflags &= ~MPT_TARGET_FLAGS_RAID_COMPONENT;
+		vtarget->id = hot_plug_info->id;
+		phy_info->attached.phys_disk_num = ~0;
+		mptsas_reprobe_target(starget, 0);
+		mptsas_add_device_component_by_fw(ioc,
+		    hot_plug_info->channel, hot_plug_info->id);
 		break;
+
 	case MPTSAS_ADD_RAID:
-		sdev = scsi_device_lookup(ioc->sh, MPTSAS_RAID_CHANNEL,
-		    ev->id, 0);
-		if (sdev) {
-			scsi_device_put(sdev);
-			break;
-		}
-		printk(MYIOC_s_INFO_FMT
-		       "attaching raid volume, channel %d, id %d\n",
-		       ioc->name, MPTSAS_RAID_CHANNEL, ev->id);
-		scsi_add_device(ioc->sh, MPTSAS_RAID_CHANNEL, ev->id, 0);
+
 		mpt_findImVolumes(ioc);
+		printk(MYIOC_s_INFO_FMT "attaching raid volume, channel %d, "
+		    "id %d\n", ioc->name, MPTSAS_RAID_CHANNEL,
+		    hot_plug_info->id);
+		scsi_add_device(ioc->sh, MPTSAS_RAID_CHANNEL,
+		    hot_plug_info->id, 0);
 		break;
+
 	case MPTSAS_DEL_RAID:
-		sdev = scsi_device_lookup(ioc->sh, MPTSAS_RAID_CHANNEL,
-		    ev->id, 0);
-		if (!sdev)
-			break;
-		printk(MYIOC_s_INFO_FMT
-		       "removing raid volume, channel %d, id %d\n",
-		       ioc->name, MPTSAS_RAID_CHANNEL, ev->id);
-		vdevice = sdev->hostdata;
-		scsi_remove_device(sdev);
-		scsi_device_put(sdev);
+
 		mpt_findImVolumes(ioc);
+		printk(MYIOC_s_INFO_FMT "removing raid volume, channel %d, "
+		    "id %d\n", ioc->name, MPTSAS_RAID_CHANNEL,
+		    hot_plug_info->id);
+		scsi_remove_device(hot_plug_info->sdev);
+		scsi_device_put(hot_plug_info->sdev);
 		break;
+
 	case MPTSAS_ADD_INACTIVE_VOLUME:
+
+		mpt_findImVolumes(ioc);
 		mptsas_adding_inactive_raid_components(ioc,
-		    ev->channel, ev->id);
+		    hot_plug_info->channel, hot_plug_info->id);
 		break;
-	case MPTSAS_IGNORE_EVENT:
+
 	default:
 		break;
 	}
 
-	mutex_unlock(&ioc->sas_discovery_mutex);
-	kfree(ev);
+	mptsas_free_fw_event(ioc, fw_event);
 }
 
 static void
-mptsas_send_sas_event(MPT_ADAPTER *ioc,
-		EVENT_DATA_SAS_DEVICE_STATUS_CHANGE *sas_event_data)
+mptsas_send_sas_event(struct fw_event_work *fw_event)
 {
-	struct mptsas_hotplug_event *ev;
-	u32 device_info = le32_to_cpu(sas_event_data->DeviceInfo);
-	__le64 sas_address;
+	MPT_ADAPTER *ioc;
+	struct mptsas_hotplug_event hot_plug_info;
+	EVENT_DATA_SAS_DEVICE_STATUS_CHANGE *sas_event_data;
+	u32 device_info;
+	u64 sas_address;
+
+	ioc = fw_event->ioc;
+	sas_event_data = (EVENT_DATA_SAS_DEVICE_STATUS_CHANGE *)
+	    fw_event->event_data;
+	device_info = le32_to_cpu(sas_event_data->DeviceInfo);
 
 	if ((device_info &
-	     (MPI_SAS_DEVICE_INFO_SSP_TARGET |
-	      MPI_SAS_DEVICE_INFO_STP_TARGET |
-	      MPI_SAS_DEVICE_INFO_SATA_DEVICE )) == 0)
+		(MPI_SAS_DEVICE_INFO_SSP_TARGET |
+		MPI_SAS_DEVICE_INFO_STP_TARGET |
+		MPI_SAS_DEVICE_INFO_SATA_DEVICE)) == 0) {
+		mptsas_free_fw_event(ioc, fw_event);
 		return;
+	}
+
+	if (sas_event_data->ReasonCode ==
+		MPI_EVENT_SAS_DEV_STAT_RC_NO_PERSIST_ADDED) {
+		mptbase_sas_persist_operation(ioc,
+		MPI_SAS_OP_CLEAR_NOT_PRESENT);
+		mptsas_free_fw_event(ioc, fw_event);
+		return;
+	}
 
 	switch (sas_event_data->ReasonCode) {
 	case MPI_EVENT_SAS_DEV_STAT_RC_NOT_RESPONDING:
-
-		mptsas_target_reset_queue(ioc, sas_event_data);
-		break;
-
 	case MPI_EVENT_SAS_DEV_STAT_RC_ADDED:
-		ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
-		if (!ev) {
-			printk(MYIOC_s_WARN_FMT "lost hotplug event\n", ioc->name);
-			break;
-		}
-
-		INIT_WORK(&ev->work, mptsas_hotplug_work);
-		ev->ioc = ioc;
-		ev->handle = le16_to_cpu(sas_event_data->DevHandle);
-		ev->parent_handle =
-		    le16_to_cpu(sas_event_data->ParentDevHandle);
-		ev->channel = sas_event_data->Bus;
-		ev->id = sas_event_data->TargetID;
-		ev->phy_id = sas_event_data->PhyNum;
+		memset(&hot_plug_info, 0, sizeof(struct mptsas_hotplug_event));
+		hot_plug_info.handle = le16_to_cpu(sas_event_data->DevHandle);
+		hot_plug_info.channel = sas_event_data->Bus;
+		hot_plug_info.id = sas_event_data->TargetID;
+		hot_plug_info.phy_id = sas_event_data->PhyNum;
 		memcpy(&sas_address, &sas_event_data->SASAddress,
-		    sizeof(__le64));
-		ev->sas_address = le64_to_cpu(sas_address);
-		ev->device_info = device_info;
-
+		    sizeof(u64));
+		hot_plug_info.sas_address = le64_to_cpu(sas_address);
+		hot_plug_info.device_info = device_info;
 		if (sas_event_data->ReasonCode &
 		    MPI_EVENT_SAS_DEV_STAT_RC_ADDED)
-			ev->event_type = MPTSAS_ADD_DEVICE;
+			hot_plug_info.event_type = MPTSAS_ADD_DEVICE;
 		else
-			ev->event_type = MPTSAS_DEL_DEVICE;
-		schedule_work(&ev->work);
+			hot_plug_info.event_type = MPTSAS_DEL_DEVICE;
+		mptsas_hotplug_work(ioc, fw_event, &hot_plug_info);
 		break;
+
 	case MPI_EVENT_SAS_DEV_STAT_RC_NO_PERSIST_ADDED:
-	/*
-	 * Persistent table is full.
-	 */
-		INIT_WORK(&ioc->sas_persist_task,
-		    mptsas_persist_clear_table);
-		schedule_work(&ioc->sas_persist_task);
+		mptbase_sas_persist_operation(ioc,
+		    MPI_SAS_OP_CLEAR_NOT_PRESENT);
+		mptsas_free_fw_event(ioc, fw_event);
 		break;
-	/*
-	 * TODO, handle other events
-	 */
+
 	case MPI_EVENT_SAS_DEV_STAT_RC_SMART_DATA:
-	case MPI_EVENT_SAS_DEV_STAT_RC_UNSUPPORTED:
+	/* TODO */
 	case MPI_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET:
-	case MPI_EVENT_SAS_DEV_STAT_RC_TASK_ABORT_INTERNAL:
-	case MPI_EVENT_SAS_DEV_STAT_RC_ABORT_TASK_SET_INTERNAL:
-	case MPI_EVENT_SAS_DEV_STAT_RC_CLEAR_TASK_SET_INTERNAL:
-	case MPI_EVENT_SAS_DEV_STAT_RC_QUERY_TASK_INTERNAL:
+	/* TODO */
 	default:
+		mptsas_free_fw_event(ioc, fw_event);
 		break;
 	}
 }
+
 static void
-mptsas_send_raid_event(MPT_ADAPTER *ioc,
-		EVENT_DATA_RAID *raid_event_data)
+mptsas_send_raid_event(struct fw_event_work *fw_event)
 {
-	struct mptsas_hotplug_event *ev;
-	int status = le32_to_cpu(raid_event_data->SettingsStatus);
-	int state = (status >> 8) & 0xff;
-
-	if (ioc->bus_type != SAS)
-		return;
-
-	ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
-	if (!ev) {
-		printk(MYIOC_s_WARN_FMT "lost hotplug event\n", ioc->name);
-		return;
+	MPT_ADAPTER *ioc;
+	EVENT_DATA_RAID *raid_event_data;
+	struct mptsas_hotplug_event hot_plug_info;
+	int status;
+	int state;
+	struct scsi_device *sdev = NULL;
+	VirtDevice *vdevice = NULL;
+	RaidPhysDiskPage0_t phys_disk;
+
+	ioc = fw_event->ioc;
+	raid_event_data = (EVENT_DATA_RAID *)fw_event->event_data;
+	status = le32_to_cpu(raid_event_data->SettingsStatus);
+	state = (status >> 8) & 0xff;
+
+	memset(&hot_plug_info, 0, sizeof(struct mptsas_hotplug_event));
+	hot_plug_info.id = raid_event_data->VolumeID;
+	hot_plug_info.channel = raid_event_data->VolumeBus;
+	hot_plug_info.phys_disk_num = raid_event_data->PhysDiskNum;
+
+	if (raid_event_data->ReasonCode == MPI_EVENT_RAID_RC_VOLUME_DELETED ||
+	    raid_event_data->ReasonCode == MPI_EVENT_RAID_RC_VOLUME_CREATED ||
+	    raid_event_data->ReasonCode ==
+	    MPI_EVENT_RAID_RC_VOLUME_STATUS_CHANGED) {
+		sdev = scsi_device_lookup(ioc->sh, MPTSAS_RAID_CHANNEL,
+		    hot_plug_info.id, 0);
+		hot_plug_info.sdev = sdev;
+		if (sdev)
+			vdevice = sdev->hostdata;
 	}
 
-	INIT_WORK(&ev->work, mptsas_hotplug_work);
-	ev->ioc = ioc;
-	ev->id = raid_event_data->VolumeID;
-	ev->channel = raid_event_data->VolumeBus;
-	ev->event_type = MPTSAS_IGNORE_EVENT;
+	devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Entering %s: "
+	    "ReasonCode=%02x\n", ioc->name, __func__,
+	    raid_event_data->ReasonCode));
 
 	switch (raid_event_data->ReasonCode) {
 	case MPI_EVENT_RAID_RC_PHYSDISK_DELETED:
-		ev->phys_disk_num_valid = 1;
-		ev->phys_disk_num = raid_event_data->PhysDiskNum;
-		ev->event_type = MPTSAS_ADD_DEVICE;
+		hot_plug_info.event_type = MPTSAS_DEL_PHYSDISK_REPROBE;
 		break;
 	case MPI_EVENT_RAID_RC_PHYSDISK_CREATED:
-		ev->phys_disk_num_valid = 1;
-		ev->phys_disk_num = raid_event_data->PhysDiskNum;
-		ev->hidden_raid_component = 1;
-		ev->event_type = MPTSAS_DEL_DEVICE;
+		hot_plug_info.event_type = MPTSAS_ADD_PHYSDISK_REPROBE;
 		break;
 	case MPI_EVENT_RAID_RC_PHYSDISK_STATUS_CHANGED:
 		switch (state) {
 		case MPI_PD_STATE_ONLINE:
 		case MPI_PD_STATE_NOT_COMPATIBLE:
-			ev->phys_disk_num_valid = 1;
-			ev->phys_disk_num = raid_event_data->PhysDiskNum;
-			ev->hidden_raid_component = 1;
-			ev->event_type = MPTSAS_ADD_DEVICE;
+			mpt_raid_phys_disk_pg0(ioc,
+			    raid_event_data->PhysDiskNum, &phys_disk);
+			hot_plug_info.id = phys_disk.PhysDiskID;
+			hot_plug_info.channel = phys_disk.PhysDiskBus;
+			hot_plug_info.event_type = MPTSAS_ADD_PHYSDISK;
 			break;
+		case MPI_PD_STATE_FAILED:
 		case MPI_PD_STATE_MISSING:
 		case MPI_PD_STATE_OFFLINE_AT_HOST_REQUEST:
 		case MPI_PD_STATE_FAILED_AT_HOST_REQUEST:
 		case MPI_PD_STATE_OFFLINE_FOR_ANOTHER_REASON:
-			ev->phys_disk_num_valid = 1;
-			ev->phys_disk_num = raid_event_data->PhysDiskNum;
-			ev->event_type = MPTSAS_DEL_DEVICE;
+			hot_plug_info.event_type = MPTSAS_DEL_PHYSDISK;
 			break;
 		default:
 			break;
 		}
 		break;
 	case MPI_EVENT_RAID_RC_VOLUME_DELETED:
-		ev->event_type = MPTSAS_DEL_RAID;
+		if (!sdev)
+			break;
+		vdevice->vtarget->deleted = 1; /* block IO */
+		hot_plug_info.event_type = MPTSAS_DEL_RAID;
 		break;
 	case MPI_EVENT_RAID_RC_VOLUME_CREATED:
-		ev->event_type = MPTSAS_ADD_RAID;
+		if (sdev) {
+			scsi_device_put(sdev);
+			break;
+		}
+		hot_plug_info.event_type = MPTSAS_ADD_RAID;
 		break;
 	case MPI_EVENT_RAID_RC_VOLUME_STATUS_CHANGED:
+		if (!(status & MPI_RAIDVOL0_STATUS_FLAG_ENABLED)) {
+			if (!sdev)
+				break;
+			vdevice->vtarget->deleted = 1; /* block IO */
+			hot_plug_info.event_type = MPTSAS_DEL_RAID;
+			break;
+		}
 		switch (state) {
 		case MPI_RAIDVOL0_STATUS_STATE_FAILED:
 		case MPI_RAIDVOL0_STATUS_STATE_MISSING:
-			ev->event_type = MPTSAS_DEL_RAID;
+			if (!sdev)
+				break;
+			vdevice->vtarget->deleted = 1; /* block IO */
+			hot_plug_info.event_type = MPTSAS_DEL_RAID;
 			break;
 		case MPI_RAIDVOL0_STATUS_STATE_OPTIMAL:
 		case MPI_RAIDVOL0_STATUS_STATE_DEGRADED:
-			ev->event_type = MPTSAS_ADD_RAID;
+			if (sdev) {
+				scsi_device_put(sdev);
+				break;
+			}
+			hot_plug_info.event_type = MPTSAS_ADD_RAID;
 			break;
 		default:
 			break;
@@ -3067,7 +3561,11 @@ mptsas_send_raid_event(MPT_ADAPTER *ioc,
 	default:
 		break;
 	}
-	schedule_work(&ev->work);
+
+	if (hot_plug_info.event_type != MPTSAS_IGNORE_EVENT)
+		mptsas_hotplug_work(ioc, fw_event, &hot_plug_info);
+	else
+		mptsas_free_fw_event(ioc, fw_event);
 }
 
 static void
@@ -3106,76 +3604,88 @@ mptsas_send_discovery_event(MPT_ADAPTER *ioc,
  *
  */
 static void
-mptsas_send_ir2_event(MPT_ADAPTER *ioc, PTR_MPI_EVENT_DATA_IR2 ir2_data)
+mptsas_send_ir2_event(struct fw_event_work *fw_event)
 {
-	struct mptsas_hotplug_event *ev;
-
-	if (ir2_data->ReasonCode !=
-	    MPI_EVENT_IR2_RC_FOREIGN_CFG_DETECTED)
-		return;
-
-	ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
-	if (!ev)
+	MPT_ADAPTER	*ioc;
+	struct mptsas_hotplug_event hot_plug_info;
+	MPI_EVENT_DATA_IR2	*ir2_data;
+	u8 reasonCode;
+
+	ioc = fw_event->ioc;
+	ir2_data = (MPI_EVENT_DATA_IR2 *)fw_event->event_data;
+	reasonCode = ir2_data->ReasonCode;
+
+	devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Entering %s: "
+	    "ReasonCode=%02x\n", ioc->name, __func__, reasonCode));
+
+	memset(&hot_plug_info, 0, sizeof(struct mptsas_hotplug_event));
+	hot_plug_info.id = ir2_data->TargetID;
+	hot_plug_info.channel = ir2_data->Bus;
+	switch (reasonCode) {
+	case MPI_EVENT_IR2_RC_FOREIGN_CFG_DETECTED:
+		hot_plug_info.event_type = MPTSAS_ADD_INACTIVE_VOLUME;
+		break;
+	default:
+		mptsas_free_fw_event(ioc, fw_event);
 		return;
-
-	INIT_WORK(&ev->work, mptsas_hotplug_work);
-	ev->ioc = ioc;
-	ev->id = ir2_data->TargetID;
-	ev->channel = ir2_data->Bus;
-	ev->event_type = MPTSAS_ADD_INACTIVE_VOLUME;
-
-	schedule_work(&ev->work);
-};
+	}
+	mptsas_hotplug_work(ioc, fw_event, &hot_plug_info);
+}
 
 static int
 mptsas_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *reply)
 {
-	int rc=1;
-	u8 event = le32_to_cpu(reply->Event) & 0xFF;
-
-	if (!ioc->sh)
-		goto out;
+	u32 event = le32_to_cpu(reply->Event);
+	int sz, event_data_sz;
+	struct fw_event_work *fw_event;
+	unsigned long delay;
 
-	/*
-	 * sas_discovery_ignore_events
-	 *
-	 * This flag is to prevent anymore processing of
-	 * sas events once mptsas_remove function is called.
-	 */
-	if (ioc->sas_discovery_ignore_events) {
-		rc = mptscsih_event_process(ioc, reply);
-		goto out;
-	}
+	/* events turned off due to host reset or driver unloading */
+	if (ioc->fw_events_off)
+		return 0;
 
+	delay = msecs_to_jiffies(1);
 	switch (event) {
 	case MPI_EVENT_SAS_DEVICE_STATUS_CHANGE:
-		mptsas_send_sas_event(ioc,
-			(EVENT_DATA_SAS_DEVICE_STATUS_CHANGE *)reply->Data);
-		break;
-	case MPI_EVENT_INTEGRATED_RAID:
-		mptsas_send_raid_event(ioc,
-			(EVENT_DATA_RAID *)reply->Data);
-		break;
-	case MPI_EVENT_PERSISTENT_TABLE_FULL:
-		INIT_WORK(&ioc->sas_persist_task,
-		    mptsas_persist_clear_table);
-		schedule_work(&ioc->sas_persist_task);
+	{
+		EVENT_DATA_SAS_DEVICE_STATUS_CHANGE *sas_event_data =
+		    (EVENT_DATA_SAS_DEVICE_STATUS_CHANGE *)reply->Data;
+
+		if (sas_event_data->ReasonCode ==
+		    MPI_EVENT_SAS_DEV_STAT_RC_NOT_RESPONDING) {
+			mptsas_target_reset_queue(ioc, sas_event_data);
+			return 0;
+		}
 		break;
-	 case MPI_EVENT_SAS_DISCOVERY:
+	}
+	case MPI_EVENT_SAS_DISCOVERY:
 		mptsas_send_discovery_event(ioc,
 			(EVENT_DATA_SAS_DISCOVERY *)reply->Data);
 		break;
+	case MPI_EVENT_INTEGRATED_RAID:
+	case MPI_EVENT_PERSISTENT_TABLE_FULL:
 	case MPI_EVENT_IR2:
-		mptsas_send_ir2_event(ioc,
-		    (PTR_MPI_EVENT_DATA_IR2)reply->Data);
+	case MPI_EVENT_SAS_PHY_LINK_STATUS:
+	case MPI_EVENT_QUEUE_FULL:
 		break;
 	default:
-		rc = mptscsih_event_process(ioc, reply);
-		break;
+		return 0;
 	}
- out:
 
-	return rc;
+	event_data_sz = ((reply->MsgLength * 4) -
+	    offsetof(EventNotificationReply_t, Data));
+	sz = offsetof(struct fw_event_work, event_data) + event_data_sz;
+	fw_event = kzalloc(sz, GFP_ATOMIC);
+	if (!fw_event) {
+		printk(MYIOC_s_WARN_FMT "%s: failed at (line=%d)\n", ioc->name,
+		 __func__, __LINE__);
+		return 0;
+	}
+	memcpy(fw_event->event_data, reply->Data, event_data_sz);
+	fw_event->event = event;
+	fw_event->ioc = ioc;
+	mptsas_add_fw_event(ioc, fw_event, delay);
+	return 0;
 }
 
 static int
@@ -3197,6 +3707,7 @@ mptsas_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return r;
 
 	ioc = pci_get_drvdata(pdev);
+	mptsas_fw_event_off(ioc);
 	ioc->DoneCtx = mptsasDoneCtx;
 	ioc->TaskCtx = mptsasTaskCtx;
 	ioc->InternalCtx = mptsasInternalCtx;
@@ -3339,6 +3850,9 @@ mptsas_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	hd->last_queue_full = 0;
 	INIT_LIST_HEAD(&hd->target_reset_list);
+	INIT_LIST_HEAD(&ioc->sas_device_info_list);
+	mutex_init(&ioc->sas_device_info_mutex);
+
 	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
 
 	if (ioc->sas_data.ptClear==1) {
@@ -3354,7 +3868,7 @@ mptsas_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	mptsas_scan_sas_topology(ioc);
-
+	mptsas_fw_event_on(ioc);
 	return 0;
 
  out_mptsas_probe:
@@ -3368,7 +3882,8 @@ mptsas_shutdown(struct pci_dev *pdev)
 {
 	MPT_ADAPTER *ioc = pci_get_drvdata(pdev);
 
-	ioc->sas_discovery_quiesce_io = 0;
+	mptsas_fw_event_off(ioc);
+	mptsas_cleanup_fw_event_q(ioc);
 }
 
 static void __devexit mptsas_remove(struct pci_dev *pdev)
@@ -3379,6 +3894,8 @@ static void __devexit mptsas_remove(struct pci_dev *pdev)
 
 	mptsas_shutdown(pdev);
 
+	mptsas_del_device_components(ioc);
+
 	ioc->sas_discovery_ignore_events = 1;
 	sas_remove_host(ioc->sh);
 
@@ -3387,6 +3904,7 @@ static void __devexit mptsas_remove(struct pci_dev *pdev)
 		list_del(&p->list);
 		for (i = 0 ; i < p->num_phys ; i++)
 			mptsas_port_delete(ioc, p->phy_info[i].port_details);
+
 		kfree(p->phy_info);
 		kfree(p);
 	}
diff --git a/drivers/message/fusion/mptsas.h b/drivers/message/fusion/mptsas.h
index bf528a5..842b3f4 100644
--- a/drivers/message/fusion/mptsas.h
+++ b/drivers/message/fusion/mptsas.h
@@ -61,12 +61,30 @@ enum mptsas_hotplug_action {
 	MPTSAS_DEL_DEVICE,
 	MPTSAS_ADD_RAID,
 	MPTSAS_DEL_RAID,
+	MPTSAS_ADD_PHYSDISK,
+	MPTSAS_ADD_PHYSDISK_REPROBE,
+	MPTSAS_DEL_PHYSDISK,
+	MPTSAS_DEL_PHYSDISK_REPROBE,
 	MPTSAS_ADD_INACTIVE_VOLUME,
 	MPTSAS_IGNORE_EVENT,
 };
 
+struct sas_mapping{
+	u8			id;
+	u8			channel;
+};
+
+struct sas_device_info {
+	struct list_head 	list;
+	struct sas_mapping	os;	/* operating system mapping*/
+	struct sas_mapping	fw;	/* firmware mapping */
+	u64			sas_address;
+	u32			device_info; /* specific bits for devices */
+	u16			slot;		/* enclosure slot id */
+	u64			enclosure_logical_id; /*enclosure address */
+};
+
 struct mptsas_hotplug_event {
-	struct work_struct	work;
 	MPT_ADAPTER		*ioc;
 	enum mptsas_hotplug_action event_type;
 	u64			sas_address;
@@ -74,11 +92,18 @@ struct mptsas_hotplug_event {
 	u8			id;
 	u32			device_info;
 	u16			handle;
-	u16			parent_handle;
 	u8			phy_id;
-	u8			phys_disk_num_valid;	/* hrc (hidden raid component) */
 	u8			phys_disk_num;		/* hrc - unique index*/
-	u8			hidden_raid_component;	/* hrc - don't expose*/
+	struct scsi_device	*sdev;
+};
+
+struct fw_event_work {
+	struct list_head 	list;
+	struct delayed_work	 work;
+	MPT_ADAPTER	*ioc;
+	u32			event;
+	u8			retries;
+	u8			event_data[1];
 };
 
 struct mptsas_discovery_event {
