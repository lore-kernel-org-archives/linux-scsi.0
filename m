From: <sreekanth.reddy@lsi.com>
Subject: [RESEND][PATCH 15/20][SCSI] mpt3sas: This patch is part 2 of
 mpt3sas_scsih.c
Date: Sat, 29 Sep 2012 19:50:57 +0530
Message-ID: <20120929142056.GA20833@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:54313 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751322Ab2I2Udq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Sep 2012 16:33:46 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jejb@kernel.org, Nagalakshmi.Nandigama@lsi.com, sreekanth.reddy@lsi.com
Cc: Sathya.Prakash@lsi.com

This patch contains code related to Scsi Host Layer for
MPT (Message Passing Technology) based controllers
This patch is part 2 of mpt3sas_scsih.c


Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Reviewed-by: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
---

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 26781ea..53aa1e6 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2768,3 +2768,2863 @@ _scsih_block_io_to_children_attached_directly(struct MPT3SAS_ADAPTER *ioc,
 			_scsih_block_io_device(ioc, handle);
 	}
 }
+
+/**
+ * _scsih_tm_tr_send - send task management request
+ * @ioc: per adapter object
+ * @handle: device handle
+ * Context: interrupt time.
+ *
+ * This code is to initiate the device removal handshake protocol
+ * with controller firmware.  This function will issue target reset
+ * using high priority request queue.  It will send a sas iounit
+ * control request (MPI2_SAS_OP_REMOVE_DEVICE) from this completion.
+ *
+ * This is designed to send muliple task management request at the same
+ * time to the fifo. If the fifo is full, we will append the request,
+ * and process it in a future completion.
+ */
+static void
+_scsih_tm_tr_send(struct MPT3SAS_ADAPTER *ioc, u16 handle)
+{
+	Mpi2SCSITaskManagementRequest_t *mpi_request;
+	u16 smid;
+	struct _sas_device *sas_device;
+	struct MPT3SAS_TARGET *sas_target_priv_data = NULL;
+	u64 sas_address = 0;
+	unsigned long flags;
+	struct _tr_list *delayed_tr;
+	u32 ioc_state;
+
+	if (ioc->remove_host) {
+		dewtprintk(ioc, pr_info(MPT3SAS_FMT
+			"%s: host has been removed: handle(0x%04x)\n",
+			__func__, ioc->name, handle));
+		return;
+	} else if (ioc->pci_error_recovery) {
+		dewtprintk(ioc, pr_info(MPT3SAS_FMT
+			"%s: host in pci error recovery: handle(0x%04x)\n",
+			__func__, ioc->name,
+		    handle));
+		return;
+	}
+	ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
+	if (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
+		dewtprintk(ioc, pr_info(MPT3SAS_FMT
+			"%s: host is not operational: handle(0x%04x)\n",
+			__func__, ioc->name,
+		   handle));
+		return;
+	}
+
+	/* if PD, then return */
+	if (test_bit(handle, ioc->pd_handles))
+		return;
+
+	spin_lock_irqsave(&ioc->sas_device_lock, flags);
+	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
+	if (sas_device && sas_device->starget &&
+	    sas_device->starget->hostdata) {
+		sas_target_priv_data = sas_device->starget->hostdata;
+		sas_target_priv_data->deleted = 1;
+		sas_address = sas_device->sas_address;
+	}
+	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+
+	if (sas_target_priv_data) {
+		dewtprintk(ioc, pr_info(MPT3SAS_FMT
+			"setting delete flag: handle(0x%04x), sas_addr(0x%016llx)\n",
+			ioc->name, handle,
+		    (unsigned long long)sas_address));
+		_scsih_ublock_io_device(ioc, sas_address);
+		sas_target_priv_data->handle = MPT3SAS_INVALID_DEVICE_HANDLE;
+	}
+
+	smid = mpt3sas_base_get_smid_hpr(ioc, ioc->tm_tr_cb_idx);
+	if (!smid) {
+		delayed_tr = kzalloc(sizeof(*delayed_tr), GFP_ATOMIC);
+		if (!delayed_tr)
+			return;
+		INIT_LIST_HEAD(&delayed_tr->list);
+		delayed_tr->handle = handle;
+		list_add_tail(&delayed_tr->list, &ioc->delayed_tr_list);
+		dewtprintk(ioc, pr_info(MPT3SAS_FMT
+		    "DELAYED:tr:handle(0x%04x), (open)\n",
+		    ioc->name, handle));
+		return;
+	}
+
+	dewtprintk(ioc, pr_info(MPT3SAS_FMT
+		"tr_send:handle(0x%04x), (open), smid(%d), cb(%d)\n",
+		ioc->name, handle, smid,
+	    ioc->tm_tr_cb_idx));
+	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
+	memset(mpi_request, 0, sizeof(Mpi2SCSITaskManagementRequest_t));
+	mpi_request->Function = MPI2_FUNCTION_SCSI_TASK_MGMT;
+	mpi_request->DevHandle = cpu_to_le16(handle);
+	mpi_request->TaskType = MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET;
+	mpt3sas_base_put_smid_hi_priority(ioc, smid);
+	mpt3sas_trigger_master(ioc, MASTER_TRIGGER_DEVICE_REMOVAL);
+}
+
+/**
+ * _scsih_tm_tr_complete -
+ * @ioc: per adapter object
+ * @smid: system request message index
+ * @msix_index: MSIX table index supplied by the OS
+ * @reply: reply message frame(lower 32bit addr)
+ * Context: interrupt time.
+ *
+ * This is the target reset completion routine.
+ * This code is part of the code to initiate the device removal
+ * handshake protocol with controller firmware.
+ * It will send a sas iounit control request (MPI2_SAS_OP_REMOVE_DEVICE)
+ *
+ * Return 1 meaning mf should be freed from _base_interrupt
+ *        0 means the mf is freed from this function.
+ */
+static u8
+_scsih_tm_tr_complete(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
+	u32 reply)
+{
+	u16 handle;
+	Mpi2SCSITaskManagementRequest_t *mpi_request_tm;
+	Mpi2SCSITaskManagementReply_t *mpi_reply =
+	    mpt3sas_base_get_reply_virt_addr(ioc, reply);
+	Mpi2SasIoUnitControlRequest_t *mpi_request;
+	u16 smid_sas_ctrl;
+	u32 ioc_state;
+
+	if (ioc->remove_host) {
+		dewtprintk(ioc, pr_info(MPT3SAS_FMT
+			"%s: host has been removed\n", __func__, ioc->name));
+		return 1;
+	} else if (ioc->pci_error_recovery) {
+		dewtprintk(ioc, pr_info(MPT3SAS_FMT
+			"%s: host in pci error recovery\n", __func__,
+			ioc->name));
+		return 1;
+	}
+	ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
+	if (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
+		dewtprintk(ioc, pr_info(MPT3SAS_FMT
+			"%s: host is not operational\n", __func__, ioc->name));
+		return 1;
+	}
+	if (unlikely(!mpi_reply)) {
+		pr_err(MPT3SAS_FMT "mpi_reply not valid at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		return 1;
+	}
+	mpi_request_tm = mpt3sas_base_get_msg_frame(ioc, smid);
+	handle = le16_to_cpu(mpi_request_tm->DevHandle);
+	if (handle != le16_to_cpu(mpi_reply->DevHandle)) {
+		dewtprintk(ioc, pr_err(MPT3SAS_FMT
+			"spurious interrupt: handle(0x%04x:0x%04x), smid(%d)!!!\n",
+			ioc->name, handle,
+		    le16_to_cpu(mpi_reply->DevHandle), smid));
+		return 0;
+	}
+
+	mpt3sas_trigger_master(ioc, MASTER_TRIGGER_TASK_MANAGMENT);
+	dewtprintk(ioc, pr_info(MPT3SAS_FMT
+	    "tr_complete:handle(0x%04x), (open) smid(%d), ioc_status(0x%04x), "
+	    "loginfo(0x%08x), completed(%d)\n", ioc->name,
+	    handle, smid, le16_to_cpu(mpi_reply->IOCStatus),
+	    le32_to_cpu(mpi_reply->IOCLogInfo),
+	    le32_to_cpu(mpi_reply->TerminationCount)));
+
+	smid_sas_ctrl = mpt3sas_base_get_smid(ioc, ioc->tm_sas_control_cb_idx);
+	if (!smid_sas_ctrl) {
+		pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
+		    ioc->name, __func__);
+		return 1;
+	}
+
+	dewtprintk(ioc, pr_info(MPT3SAS_FMT
+		"sc_send:handle(0x%04x), (open), smid(%d), cb(%d)\n",
+		ioc->name, handle, smid_sas_ctrl,
+	    ioc->tm_sas_control_cb_idx));
+	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid_sas_ctrl);
+	memset(mpi_request, 0, sizeof(Mpi2SasIoUnitControlRequest_t));
+	mpi_request->Function = MPI2_FUNCTION_SAS_IO_UNIT_CONTROL;
+	mpi_request->Operation = MPI2_SAS_OP_REMOVE_DEVICE;
+	mpi_request->DevHandle = mpi_request_tm->DevHandle;
+	mpt3sas_base_put_smid_default(ioc, smid_sas_ctrl);
+
+	return _scsih_check_for_pending_tm(ioc, smid);
+}
+
+
+/**
+ * _scsih_sas_control_complete - completion routine
+ * @ioc: per adapter object
+ * @smid: system request message index
+ * @msix_index: MSIX table index supplied by the OS
+ * @reply: reply message frame(lower 32bit addr)
+ * Context: interrupt time.
+ *
+ * This is the sas iounit control completion routine.
+ * This code is part of the code to initiate the device removal
+ * handshake protocol with controller firmware.
+ *
+ * Return 1 meaning mf should be freed from _base_interrupt
+ *        0 means the mf is freed from this function.
+ */
+static u8
+_scsih_sas_control_complete(struct MPT3SAS_ADAPTER *ioc, u16 smid,
+	u8 msix_index, u32 reply)
+{
+	Mpi2SasIoUnitControlReply_t *mpi_reply =
+	    mpt3sas_base_get_reply_virt_addr(ioc, reply);
+
+	if (likely(mpi_reply)) {
+		dewtprintk(ioc, pr_info(MPT3SAS_FMT
+		"sc_complete:handle(0x%04x), (open) "
+		"smid(%d), ioc_status(0x%04x), loginfo(0x%08x)\n",
+		ioc->name, le16_to_cpu(mpi_reply->DevHandle), smid,
+		le16_to_cpu(mpi_reply->IOCStatus),
+		le32_to_cpu(mpi_reply->IOCLogInfo)));
+	} else {
+		pr_err(MPT3SAS_FMT "mpi_reply not valid at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+	}
+	return 1;
+}
+
+/**
+ * _scsih_tm_tr_volume_send - send target reset request for volumes
+ * @ioc: per adapter object
+ * @handle: device handle
+ * Context: interrupt time.
+ *
+ * This is designed to send muliple task management request at the same
+ * time to the fifo. If the fifo is full, we will append the request,
+ * and process it in a future completion.
+ */
+static void
+_scsih_tm_tr_volume_send(struct MPT3SAS_ADAPTER *ioc, u16 handle)
+{
+	Mpi2SCSITaskManagementRequest_t *mpi_request;
+	u16 smid;
+	struct _tr_list *delayed_tr;
+
+	if (ioc->shost_recovery || ioc->remove_host ||
+	    ioc->pci_error_recovery) {
+		dewtprintk(ioc, pr_info(MPT3SAS_FMT
+			"%s: host reset in progress!\n",
+			__func__, ioc->name));
+		return;
+	}
+
+	smid = mpt3sas_base_get_smid_hpr(ioc, ioc->tm_tr_volume_cb_idx);
+	if (!smid) {
+		delayed_tr = kzalloc(sizeof(*delayed_tr), GFP_ATOMIC);
+		if (!delayed_tr)
+			return;
+		INIT_LIST_HEAD(&delayed_tr->list);
+		delayed_tr->handle = handle;
+		list_add_tail(&delayed_tr->list, &ioc->delayed_tr_volume_list);
+		dewtprintk(ioc, pr_info(MPT3SAS_FMT
+		    "DELAYED:tr:handle(0x%04x), (open)\n",
+		    ioc->name, handle));
+		return;
+	}
+
+	dewtprintk(ioc, pr_info(MPT3SAS_FMT
+		"tr_send:handle(0x%04x), (open), smid(%d), cb(%d)\n",
+		ioc->name, handle, smid,
+	    ioc->tm_tr_volume_cb_idx));
+	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
+	memset(mpi_request, 0, sizeof(Mpi2SCSITaskManagementRequest_t));
+	mpi_request->Function = MPI2_FUNCTION_SCSI_TASK_MGMT;
+	mpi_request->DevHandle = cpu_to_le16(handle);
+	mpi_request->TaskType = MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET;
+	mpt3sas_base_put_smid_hi_priority(ioc, smid);
+}
+
+/**
+ * _scsih_tm_volume_tr_complete - target reset completion
+ * @ioc: per adapter object
+ * @smid: system request message index
+ * @msix_index: MSIX table index supplied by the OS
+ * @reply: reply message frame(lower 32bit addr)
+ * Context: interrupt time.
+ *
+ * Return 1 meaning mf should be freed from _base_interrupt
+ *        0 means the mf is freed from this function.
+ */
+static u8
+_scsih_tm_volume_tr_complete(struct MPT3SAS_ADAPTER *ioc, u16 smid,
+	u8 msix_index, u32 reply)
+{
+	u16 handle;
+	Mpi2SCSITaskManagementRequest_t *mpi_request_tm;
+	Mpi2SCSITaskManagementReply_t *mpi_reply =
+	    mpt3sas_base_get_reply_virt_addr(ioc, reply);
+
+	if (ioc->shost_recovery || ioc->remove_host ||
+	    ioc->pci_error_recovery) {
+		dewtprintk(ioc, pr_info(MPT3SAS_FMT
+			"%s: host reset in progress!\n",
+			__func__, ioc->name));
+		return 1;
+	}
+	if (unlikely(!mpi_reply)) {
+		pr_err(MPT3SAS_FMT "mpi_reply not valid at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		return 1;
+	}
+
+	mpi_request_tm = mpt3sas_base_get_msg_frame(ioc, smid);
+	handle = le16_to_cpu(mpi_request_tm->DevHandle);
+	if (handle != le16_to_cpu(mpi_reply->DevHandle)) {
+		dewtprintk(ioc, pr_err(MPT3SAS_FMT
+			"spurious interrupt: handle(0x%04x:0x%04x), smid(%d)!!!\n",
+			ioc->name, handle,
+		    le16_to_cpu(mpi_reply->DevHandle), smid));
+		return 0;
+	}
+
+	dewtprintk(ioc, pr_info(MPT3SAS_FMT
+	    "tr_complete:handle(0x%04x), (open) smid(%d), ioc_status(0x%04x), "
+	    "loginfo(0x%08x), completed(%d)\n", ioc->name,
+	    handle, smid, le16_to_cpu(mpi_reply->IOCStatus),
+	    le32_to_cpu(mpi_reply->IOCLogInfo),
+	    le32_to_cpu(mpi_reply->TerminationCount)));
+
+	return _scsih_check_for_pending_tm(ioc, smid);
+}
+
+
+/**
+ * _scsih_check_for_pending_tm - check for pending task management
+ * @ioc: per adapter object
+ * @smid: system request message index
+ *
+ * This will check delayed target reset list, and feed the
+ * next reqeust.
+ *
+ * Return 1 meaning mf should be freed from _base_interrupt
+ *        0 means the mf is freed from this function.
+ */
+static u8
+_scsih_check_for_pending_tm(struct MPT3SAS_ADAPTER *ioc, u16 smid)
+{
+	struct _tr_list *delayed_tr;
+
+	if (!list_empty(&ioc->delayed_tr_volume_list)) {
+		delayed_tr = list_entry(ioc->delayed_tr_volume_list.next,
+		    struct _tr_list, list);
+		mpt3sas_base_free_smid(ioc, smid);
+		_scsih_tm_tr_volume_send(ioc, delayed_tr->handle);
+		list_del(&delayed_tr->list);
+		kfree(delayed_tr);
+		return 0;
+	}
+
+	if (!list_empty(&ioc->delayed_tr_list)) {
+		delayed_tr = list_entry(ioc->delayed_tr_list.next,
+		    struct _tr_list, list);
+		mpt3sas_base_free_smid(ioc, smid);
+		_scsih_tm_tr_send(ioc, delayed_tr->handle);
+		list_del(&delayed_tr->list);
+		kfree(delayed_tr);
+		return 0;
+	}
+
+	return 1;
+}
+
+/**
+ * _scsih_check_topo_delete_events - sanity check on topo events
+ * @ioc: per adapter object
+ * @event_data: the event data payload
+ *
+ * This routine added to better handle cable breaker.
+ *
+ * This handles the case where driver receives multiple expander
+ * add and delete events in a single shot.  When there is a delete event
+ * the routine will void any pending add events waiting in the event queue.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_check_topo_delete_events(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2EventDataSasTopologyChangeList_t *event_data)
+{
+	struct fw_event_work *fw_event;
+	Mpi2EventDataSasTopologyChangeList_t *local_event_data;
+	u16 expander_handle;
+	struct _sas_node *sas_expander;
+	unsigned long flags;
+	int i, reason_code;
+	u16 handle;
+
+	for (i = 0 ; i < event_data->NumEntries; i++) {
+		handle = le16_to_cpu(event_data->PHY[i].AttachedDevHandle);
+		if (!handle)
+			continue;
+		reason_code = event_data->PHY[i].PhyStatus &
+		    MPI2_EVENT_SAS_TOPO_RC_MASK;
+		if (reason_code == MPI2_EVENT_SAS_TOPO_RC_TARG_NOT_RESPONDING)
+			_scsih_tm_tr_send(ioc, handle);
+	}
+
+	expander_handle = le16_to_cpu(event_data->ExpanderDevHandle);
+	if (expander_handle < ioc->sas_hba.num_phys) {
+		_scsih_block_io_to_children_attached_directly(ioc, event_data);
+		return;
+	}
+	if (event_data->ExpStatus ==
+	    MPI2_EVENT_SAS_TOPO_ES_DELAY_NOT_RESPONDING) {
+		/* put expander attached devices into blocking state */
+		spin_lock_irqsave(&ioc->sas_node_lock, flags);
+		sas_expander = mpt3sas_scsih_expander_find_by_handle(ioc,
+		    expander_handle);
+		_scsih_block_io_to_children_attached_to_ex(ioc, sas_expander);
+		spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
+		do {
+			handle = find_first_bit(ioc->blocking_handles,
+			    ioc->facts.MaxDevHandle);
+			if (handle < ioc->facts.MaxDevHandle)
+				_scsih_block_io_device(ioc, handle);
+		} while (test_and_clear_bit(handle, ioc->blocking_handles));
+	} else if (event_data->ExpStatus == MPI2_EVENT_SAS_TOPO_ES_RESPONDING)
+		_scsih_block_io_to_children_attached_directly(ioc, event_data);
+
+	if (event_data->ExpStatus != MPI2_EVENT_SAS_TOPO_ES_NOT_RESPONDING)
+		return;
+
+	/* mark ignore flag for pending events */
+	spin_lock_irqsave(&ioc->fw_event_lock, flags);
+	list_for_each_entry(fw_event, &ioc->fw_event_list, list) {
+		if (fw_event->event != MPI2_EVENT_SAS_TOPOLOGY_CHANGE_LIST ||
+		    fw_event->ignore)
+			continue;
+		local_event_data = fw_event->event_data;
+		if (local_event_data->ExpStatus ==
+		    MPI2_EVENT_SAS_TOPO_ES_ADDED ||
+		    local_event_data->ExpStatus ==
+		    MPI2_EVENT_SAS_TOPO_ES_RESPONDING) {
+			if (le16_to_cpu(local_event_data->ExpanderDevHandle) ==
+			    expander_handle) {
+				dewtprintk(ioc, pr_info(MPT3SAS_FMT
+				    "setting ignoring flag\n", ioc->name));
+				fw_event->ignore = 1;
+			}
+		}
+	}
+	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
+}
+
+/**
+ * _scsih_set_volume_delete_flag - setting volume delete flag
+ * @ioc: per adapter object
+ * @handle: device handle
+ *
+ * This returns nothing.
+ */
+static void
+_scsih_set_volume_delete_flag(struct MPT3SAS_ADAPTER *ioc, u16 handle)
+{
+	struct _raid_device *raid_device;
+	struct MPT3SAS_TARGET *sas_target_priv_data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ioc->raid_device_lock, flags);
+	raid_device = _scsih_raid_device_find_by_handle(ioc, handle);
+	if (raid_device && raid_device->starget &&
+	    raid_device->starget->hostdata) {
+		sas_target_priv_data =
+		    raid_device->starget->hostdata;
+		sas_target_priv_data->deleted = 1;
+		dewtprintk(ioc, pr_info(MPT3SAS_FMT
+		    "setting delete flag: handle(0x%04x), "
+		    "wwid(0x%016llx)\n", ioc->name, handle,
+		    (unsigned long long) raid_device->wwid));
+	}
+	spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
+}
+
+/**
+ * _scsih_set_volume_handle_for_tr - set handle for target reset to volume
+ * @handle: input handle
+ * @a: handle for volume a
+ * @b: handle for volume b
+ *
+ * IR firmware only supports two raid volumes.  The purpose of this
+ * routine is to set the volume handle in either a or b. When the given
+ * input handle is non-zero, or when a and b have not been set before.
+ */
+static void
+_scsih_set_volume_handle_for_tr(u16 handle, u16 *a, u16 *b)
+{
+	if (!handle || handle == *a || handle == *b)
+		return;
+	if (!*a)
+		*a = handle;
+	else if (!*b)
+		*b = handle;
+}
+
+/**
+ * _scsih_check_ir_config_unhide_events - check for UNHIDE events
+ * @ioc: per adapter object
+ * @event_data: the event data payload
+ * Context: interrupt time.
+ *
+ * This routine will send target reset to volume, followed by target
+ * resets to the PDs. This is called when a PD has been removed, or
+ * volume has been deleted or removed. When the target reset is sent
+ * to volume, the PD target resets need to be queued to start upon
+ * completion of the volume target reset.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_check_ir_config_unhide_events(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2EventDataIrConfigChangeList_t *event_data)
+{
+	Mpi2EventIrConfigElement_t *element;
+	int i;
+	u16 handle, volume_handle, a, b;
+	struct _tr_list *delayed_tr;
+
+	a = 0;
+	b = 0;
+
+	/* Volume Resets for Deleted or Removed */
+	element = (Mpi2EventIrConfigElement_t *)&event_data->ConfigElement[0];
+	for (i = 0; i < event_data->NumElements; i++, element++) {
+		if (le32_to_cpu(event_data->Flags) &
+		    MPI2_EVENT_IR_CHANGE_FLAGS_FOREIGN_CONFIG)
+			continue;
+		if (element->ReasonCode ==
+		    MPI2_EVENT_IR_CHANGE_RC_VOLUME_DELETED ||
+		    element->ReasonCode ==
+		    MPI2_EVENT_IR_CHANGE_RC_REMOVED) {
+			volume_handle = le16_to_cpu(element->VolDevHandle);
+			_scsih_set_volume_delete_flag(ioc, volume_handle);
+			_scsih_set_volume_handle_for_tr(volume_handle, &a, &b);
+		}
+	}
+
+	/* Volume Resets for UNHIDE events */
+	element = (Mpi2EventIrConfigElement_t *)&event_data->ConfigElement[0];
+	for (i = 0; i < event_data->NumElements; i++, element++) {
+		if (le32_to_cpu(event_data->Flags) &
+		    MPI2_EVENT_IR_CHANGE_FLAGS_FOREIGN_CONFIG)
+			continue;
+		if (element->ReasonCode == MPI2_EVENT_IR_CHANGE_RC_UNHIDE) {
+			volume_handle = le16_to_cpu(element->VolDevHandle);
+			_scsih_set_volume_handle_for_tr(volume_handle, &a, &b);
+		}
+	}
+
+	if (a)
+		_scsih_tm_tr_volume_send(ioc, a);
+	if (b)
+		_scsih_tm_tr_volume_send(ioc, b);
+
+	/* PD target resets */
+	element = (Mpi2EventIrConfigElement_t *)&event_data->ConfigElement[0];
+	for (i = 0; i < event_data->NumElements; i++, element++) {
+		if (element->ReasonCode != MPI2_EVENT_IR_CHANGE_RC_UNHIDE)
+			continue;
+		handle = le16_to_cpu(element->PhysDiskDevHandle);
+		volume_handle = le16_to_cpu(element->VolDevHandle);
+		clear_bit(handle, ioc->pd_handles);
+		if (!volume_handle)
+			_scsih_tm_tr_send(ioc, handle);
+		else if (volume_handle == a || volume_handle == b) {
+			delayed_tr = kzalloc(sizeof(*delayed_tr), GFP_ATOMIC);
+			BUG_ON(!delayed_tr);
+			INIT_LIST_HEAD(&delayed_tr->list);
+			delayed_tr->handle = handle;
+			list_add_tail(&delayed_tr->list, &ioc->delayed_tr_list);
+			dewtprintk(ioc, pr_info(MPT3SAS_FMT
+			    "DELAYED:tr:handle(0x%04x), (open)\n", ioc->name,
+			    handle));
+		} else
+			_scsih_tm_tr_send(ioc, handle);
+	}
+}
+
+
+/**
+ * _scsih_check_volume_delete_events - set delete flag for volumes
+ * @ioc: per adapter object
+ * @event_data: the event data payload
+ * Context: interrupt time.
+ *
+ * This will handle the case when the cable connected to entire volume is
+ * pulled. We will take care of setting the deleted flag so normal IO will
+ * not be sent.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_check_volume_delete_events(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2EventDataIrVolume_t *event_data)
+{
+	u32 state;
+
+	if (event_data->ReasonCode != MPI2_EVENT_IR_VOLUME_RC_STATE_CHANGED)
+		return;
+	state = le32_to_cpu(event_data->NewValue);
+	if (state == MPI2_RAID_VOL_STATE_MISSING || state ==
+	    MPI2_RAID_VOL_STATE_FAILED)
+		_scsih_set_volume_delete_flag(ioc,
+		    le16_to_cpu(event_data->VolDevHandle));
+}
+
+/**
+ * _scsih_flush_running_cmds - completing outstanding commands.
+ * @ioc: per adapter object
+ *
+ * The flushing out of all pending scmd commands following host reset,
+ * where all IO is dropped to the floor.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_flush_running_cmds(struct MPT3SAS_ADAPTER *ioc)
+{
+	struct scsi_cmnd *scmd;
+	u16 smid;
+	u16 count = 0;
+
+	for (smid = 1; smid <= ioc->scsiio_depth; smid++) {
+		scmd = _scsih_scsi_lookup_get_clear(ioc, smid);
+		if (!scmd)
+			continue;
+		count++;
+		mpt3sas_base_free_smid(ioc, smid);
+		scsi_dma_unmap(scmd);
+		if (ioc->pci_error_recovery)
+			scmd->result = DID_NO_CONNECT << 16;
+		else
+			scmd->result = DID_RESET << 16;
+		scmd->scsi_done(scmd);
+	}
+	dtmprintk(ioc, pr_info(MPT3SAS_FMT "completing %d cmds\n",
+	    ioc->name, count));
+}
+
+/**
+ * _scsih_setup_eedp - setup MPI request for EEDP transfer
+ * @ioc: per adapter object
+ * @scmd: pointer to scsi command object
+ * @mpi_request: pointer to the SCSI_IO reqest message frame
+ *
+ * Supporting protection 1 and 3.
+ *
+ * Returns nothing
+ */
+static void
+_scsih_setup_eedp(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
+	Mpi2SCSIIORequest_t *mpi_request)
+{
+	u16 eedp_flags;
+	unsigned char prot_op = scsi_get_prot_op(scmd);
+	unsigned char prot_type = scsi_get_prot_type(scmd);
+	Mpi25SCSIIORequest_t *mpi_request_3v =
+	   (Mpi25SCSIIORequest_t *)mpi_request;
+
+	if (prot_type == SCSI_PROT_DIF_TYPE0 || prot_op == SCSI_PROT_NORMAL)
+		return;
+
+	if (prot_op ==  SCSI_PROT_READ_STRIP)
+		eedp_flags = MPI2_SCSIIO_EEDPFLAGS_CHECK_REMOVE_OP;
+	else if (prot_op ==  SCSI_PROT_WRITE_INSERT)
+		eedp_flags = MPI2_SCSIIO_EEDPFLAGS_INSERT_OP;
+	else
+		return;
+
+	switch (prot_type) {
+	case SCSI_PROT_DIF_TYPE1:
+	case SCSI_PROT_DIF_TYPE2:
+
+		/*
+		* enable ref/guard checking
+		* auto increment ref tag
+		*/
+		eedp_flags |= MPI2_SCSIIO_EEDPFLAGS_INC_PRI_REFTAG |
+		    MPI2_SCSIIO_EEDPFLAGS_CHECK_REFTAG |
+		    MPI2_SCSIIO_EEDPFLAGS_CHECK_GUARD;
+		mpi_request->CDB.EEDP32.PrimaryReferenceTag =
+		    cpu_to_be32(scsi_get_lba(scmd));
+		break;
+
+	case SCSI_PROT_DIF_TYPE3:
+
+		/*
+		* enable guard checking
+		*/
+		eedp_flags |= MPI2_SCSIIO_EEDPFLAGS_CHECK_GUARD;
+
+		break;
+	}
+
+	mpi_request_3v->EEDPBlockSize =
+	    cpu_to_le16(scmd->device->sector_size);
+	mpi_request->EEDPFlags = cpu_to_le16(eedp_flags);
+}
+
+/**
+ * _scsih_eedp_error_handling - return sense code for EEDP errors
+ * @scmd: pointer to scsi command object
+ * @ioc_status: ioc status
+ *
+ * Returns nothing
+ */
+static void
+_scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
+{
+	u8 ascq;
+
+	switch (ioc_status) {
+	case MPI2_IOCSTATUS_EEDP_GUARD_ERROR:
+		ascq = 0x01;
+		break;
+	case MPI2_IOCSTATUS_EEDP_APP_TAG_ERROR:
+		ascq = 0x02;
+		break;
+	case MPI2_IOCSTATUS_EEDP_REF_TAG_ERROR:
+		ascq = 0x03;
+		break;
+	default:
+		ascq = 0x00;
+		break;
+	}
+	scsi_build_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST, 0x10,
+	    ascq);
+	scmd->result = DRIVER_SENSE << 24 | (DID_ABORT << 16) |
+	    SAM_STAT_CHECK_CONDITION;
+}
+
+
+/**
+ * _scsih_qcmd_lck - main scsi request entry point
+ * @scmd: pointer to scsi command object
+ * @done: function pointer to be invoked on completion
+ *
+ * The callback index is set inside `ioc->scsi_io_cb_idx`.
+ *
+ * Returns 0 on success.  If there's a failure, return either:
+ * SCSI_MLQUEUE_DEVICE_BUSY if the device queue is full, or
+ * SCSI_MLQUEUE_HOST_BUSY if the entire host queue is full
+ */
+static int
+_scsih_qcmd_lck(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
+{
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
+	struct MPT3SAS_DEVICE *sas_device_priv_data;
+	struct MPT3SAS_TARGET *sas_target_priv_data;
+	Mpi2SCSIIORequest_t *mpi_request;
+	u32 mpi_control;
+	u16 smid;
+	u16 handle;
+
+#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
+	if (ioc->logging_level & MPT_DEBUG_SCSI)
+		scsi_print_command(scmd);
+#endif
+
+	scmd->scsi_done = done;
+	sas_device_priv_data = scmd->device->hostdata;
+	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
+		scmd->result = DID_NO_CONNECT << 16;
+		scmd->scsi_done(scmd);
+		return 0;
+	}
+
+	if (ioc->pci_error_recovery || ioc->remove_host) {
+		scmd->result = DID_NO_CONNECT << 16;
+		scmd->scsi_done(scmd);
+		return 0;
+	}
+
+	sas_target_priv_data = sas_device_priv_data->sas_target;
+
+	/* invalid device handle */
+	handle = sas_target_priv_data->handle;
+	if (handle == MPT3SAS_INVALID_DEVICE_HANDLE) {
+		scmd->result = DID_NO_CONNECT << 16;
+		scmd->scsi_done(scmd);
+		return 0;
+	}
+
+
+	/* host recovery or link resets sent via IOCTLs */
+	if (ioc->shost_recovery || ioc->ioc_link_reset_in_progress)
+		return SCSI_MLQUEUE_HOST_BUSY;
+
+	/* device has been deleted */
+	else if (sas_target_priv_data->deleted) {
+		scmd->result = DID_NO_CONNECT << 16;
+		scmd->scsi_done(scmd);
+		return 0;
+	/* device busy with task managment */
+	} else if (sas_target_priv_data->tm_busy ||
+	    sas_device_priv_data->block)
+		return SCSI_MLQUEUE_DEVICE_BUSY;
+
+	if (scmd->sc_data_direction == DMA_FROM_DEVICE)
+		mpi_control = MPI2_SCSIIO_CONTROL_READ;
+	else if (scmd->sc_data_direction == DMA_TO_DEVICE)
+		mpi_control = MPI2_SCSIIO_CONTROL_WRITE;
+	else
+		mpi_control = MPI2_SCSIIO_CONTROL_NODATATRANSFER;
+
+	/* set tags */
+	if (!(sas_device_priv_data->flags & MPT_DEVICE_FLAGS_INIT)) {
+		if (scmd->device->tagged_supported) {
+			if (scmd->device->ordered_tags)
+				mpi_control |= MPI2_SCSIIO_CONTROL_ORDEREDQ;
+			else
+				mpi_control |= MPI2_SCSIIO_CONTROL_SIMPLEQ;
+		} else
+/* MPI Revision I (UNIT = 0xA) - removed MPI2_SCSIIO_CONTROL_UNTAGGED */
+/*			mpi_control |= MPI2_SCSIIO_CONTROL_UNTAGGED;
+ */
+			mpi_control |= (0x500);
+	} else
+		mpi_control |= MPI2_SCSIIO_CONTROL_SIMPLEQ;
+
+	if ((sas_device_priv_data->flags & MPT_DEVICE_TLR_ON) &&
+	    scmd->cmd_len != 32)
+		mpi_control |= MPI2_SCSIIO_CONTROL_TLR_ON;
+
+	smid = mpt3sas_base_get_smid_scsiio(ioc, ioc->scsi_io_cb_idx, scmd);
+	if (!smid) {
+		pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
+		    ioc->name, __func__);
+		goto out;
+	}
+	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
+	memset(mpi_request, 0, sizeof(Mpi2SCSIIORequest_t));
+	_scsih_setup_eedp(ioc, scmd, mpi_request);
+
+	if (scmd->cmd_len == 32)
+		mpi_control |= 4 << MPI2_SCSIIO_CONTROL_ADDCDBLEN_SHIFT;
+	mpi_request->Function = MPI2_FUNCTION_SCSI_IO_REQUEST;
+	if (sas_device_priv_data->sas_target->flags &
+	    MPT_TARGET_FLAGS_RAID_COMPONENT)
+		mpi_request->Function = MPI2_FUNCTION_RAID_SCSI_IO_PASSTHROUGH;
+	else
+		mpi_request->Function = MPI2_FUNCTION_SCSI_IO_REQUEST;
+	mpi_request->DevHandle = cpu_to_le16(handle);
+	mpi_request->DataLength = cpu_to_le32(scsi_bufflen(scmd));
+	mpi_request->Control = cpu_to_le32(mpi_control);
+	mpi_request->IoFlags = cpu_to_le16(scmd->cmd_len);
+	mpi_request->MsgFlags = MPI2_SCSIIO_MSGFLAGS_SYSTEM_SENSE_ADDR;
+	mpi_request->SenseBufferLength = SCSI_SENSE_BUFFERSIZE;
+	mpi_request->SenseBufferLowAddress =
+	    mpt3sas_base_get_sense_buffer_dma(ioc, smid);
+	mpi_request->SGLOffset0 = offsetof(Mpi2SCSIIORequest_t, SGL) / 4;
+	int_to_scsilun(sas_device_priv_data->lun, (struct scsi_lun *)
+	    mpi_request->LUN);
+	memcpy(mpi_request->CDB.CDB32, scmd->cmnd, scmd->cmd_len);
+
+	if (mpi_request->DataLength) {
+		if (ioc->build_sg_scmd(ioc, scmd, smid)) {
+			mpt3sas_base_free_smid(ioc, smid);
+			goto out;
+		}
+	} else
+		ioc->build_zero_len_sge(ioc, &mpi_request->SGL);
+
+	if (likely(mpi_request->Function == MPI2_FUNCTION_SCSI_IO_REQUEST)) {
+		if (sas_target_priv_data->flags & MPT_TARGET_FASTPATH_IO) {
+			mpi_request->IoFlags = cpu_to_le16(scmd->cmd_len |
+			    MPI25_SCSIIO_IOFLAGS_FAST_PATH);
+			mpt3sas_base_put_smid_fast_path(ioc, smid, handle);
+		} else
+			mpt3sas_base_put_smid_scsi_io(ioc, smid, handle);
+	} else
+		mpt3sas_base_put_smid_default(ioc, smid);
+	return 0;
+
+ out:
+	return SCSI_MLQUEUE_HOST_BUSY;
+}
+static DEF_SCSI_QCMD(_scsih_qcmd)
+
+
+/**
+ * _scsih_normalize_sense - normalize descriptor and fixed format sense data
+ * @sense_buffer: sense data returned by target
+ * @data: normalized skey/asc/ascq
+ *
+ * Return nothing.
+ */
+static void
+_scsih_normalize_sense(char *sense_buffer, struct sense_info *data)
+{
+	if ((sense_buffer[0] & 0x7F) >= 0x72) {
+		/* descriptor format */
+		data->skey = sense_buffer[1] & 0x0F;
+		data->asc = sense_buffer[2];
+		data->ascq = sense_buffer[3];
+	} else {
+		/* fixed format */
+		data->skey = sense_buffer[2] & 0x0F;
+		data->asc = sense_buffer[12];
+		data->ascq = sense_buffer[13];
+	}
+}
+
+#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
+/**
+ * _scsih_scsi_ioc_info - translated non-succesfull SCSI_IO request
+ * @ioc: per adapter object
+ * @scmd: pointer to scsi command object
+ * @mpi_reply: reply mf payload returned from firmware
+ *
+ * scsi_status - SCSI Status code returned from target device
+ * scsi_state - state info associated with SCSI_IO determined by ioc
+ * ioc_status - ioc supplied status info
+ *
+ * Return nothing.
+ */
+static void
+_scsih_scsi_ioc_info(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
+	Mpi2SCSIIOReply_t *mpi_reply, u16 smid)
+{
+	u32 response_info;
+	u8 *response_bytes;
+	u16 ioc_status = le16_to_cpu(mpi_reply->IOCStatus) &
+	    MPI2_IOCSTATUS_MASK;
+	u8 scsi_state = mpi_reply->SCSIState;
+	u8 scsi_status = mpi_reply->SCSIStatus;
+	char *desc_ioc_state = NULL;
+	char *desc_scsi_status = NULL;
+	char *desc_scsi_state = ioc->tmp_string;
+	u32 log_info = le32_to_cpu(mpi_reply->IOCLogInfo);
+	struct _sas_device *sas_device = NULL;
+	unsigned long flags;
+	struct scsi_target *starget = scmd->device->sdev_target;
+	struct MPT3SAS_TARGET *priv_target = starget->hostdata;
+	char *device_str = NULL;
+
+	if (!priv_target)
+		return;
+	device_str = "volume";
+
+	if (log_info == 0x31170000)
+		return;
+
+	switch (ioc_status) {
+	case MPI2_IOCSTATUS_SUCCESS:
+		desc_ioc_state = "success";
+		break;
+	case MPI2_IOCSTATUS_INVALID_FUNCTION:
+		desc_ioc_state = "invalid function";
+		break;
+	case MPI2_IOCSTATUS_SCSI_RECOVERED_ERROR:
+		desc_ioc_state = "scsi recovered error";
+		break;
+	case MPI2_IOCSTATUS_SCSI_INVALID_DEVHANDLE:
+		desc_ioc_state = "scsi invalid dev handle";
+		break;
+	case MPI2_IOCSTATUS_SCSI_DEVICE_NOT_THERE:
+		desc_ioc_state = "scsi device not there";
+		break;
+	case MPI2_IOCSTATUS_SCSI_DATA_OVERRUN:
+		desc_ioc_state = "scsi data overrun";
+		break;
+	case MPI2_IOCSTATUS_SCSI_DATA_UNDERRUN:
+		desc_ioc_state = "scsi data underrun";
+		break;
+	case MPI2_IOCSTATUS_SCSI_IO_DATA_ERROR:
+		desc_ioc_state = "scsi io data error";
+		break;
+	case MPI2_IOCSTATUS_SCSI_PROTOCOL_ERROR:
+		desc_ioc_state = "scsi protocol error";
+		break;
+	case MPI2_IOCSTATUS_SCSI_TASK_TERMINATED:
+		desc_ioc_state = "scsi task terminated";
+		break;
+	case MPI2_IOCSTATUS_SCSI_RESIDUAL_MISMATCH:
+		desc_ioc_state = "scsi residual mismatch";
+		break;
+	case MPI2_IOCSTATUS_SCSI_TASK_MGMT_FAILED:
+		desc_ioc_state = "scsi task mgmt failed";
+		break;
+	case MPI2_IOCSTATUS_SCSI_IOC_TERMINATED:
+		desc_ioc_state = "scsi ioc terminated";
+		break;
+	case MPI2_IOCSTATUS_SCSI_EXT_TERMINATED:
+		desc_ioc_state = "scsi ext terminated";
+		break;
+	case MPI2_IOCSTATUS_EEDP_GUARD_ERROR:
+		desc_ioc_state = "eedp guard error";
+		break;
+	case MPI2_IOCSTATUS_EEDP_REF_TAG_ERROR:
+		desc_ioc_state = "eedp ref tag error";
+		break;
+	case MPI2_IOCSTATUS_EEDP_APP_TAG_ERROR:
+		desc_ioc_state = "eedp app tag error";
+		break;
+	default:
+		desc_ioc_state = "unknown";
+		break;
+	}
+
+	switch (scsi_status) {
+	case MPI2_SCSI_STATUS_GOOD:
+		desc_scsi_status = "good";
+		break;
+	case MPI2_SCSI_STATUS_CHECK_CONDITION:
+		desc_scsi_status = "check condition";
+		break;
+	case MPI2_SCSI_STATUS_CONDITION_MET:
+		desc_scsi_status = "condition met";
+		break;
+	case MPI2_SCSI_STATUS_BUSY:
+		desc_scsi_status = "busy";
+		break;
+	case MPI2_SCSI_STATUS_INTERMEDIATE:
+		desc_scsi_status = "intermediate";
+		break;
+	case MPI2_SCSI_STATUS_INTERMEDIATE_CONDMET:
+		desc_scsi_status = "intermediate condmet";
+		break;
+	case MPI2_SCSI_STATUS_RESERVATION_CONFLICT:
+		desc_scsi_status = "reservation conflict";
+		break;
+	case MPI2_SCSI_STATUS_COMMAND_TERMINATED:
+		desc_scsi_status = "command terminated";
+		break;
+	case MPI2_SCSI_STATUS_TASK_SET_FULL:
+		desc_scsi_status = "task set full";
+		break;
+	case MPI2_SCSI_STATUS_ACA_ACTIVE:
+		desc_scsi_status = "aca active";
+		break;
+	case MPI2_SCSI_STATUS_TASK_ABORTED:
+		desc_scsi_status = "task aborted";
+		break;
+	default:
+		desc_scsi_status = "unknown";
+		break;
+	}
+
+	desc_scsi_state[0] = '\0';
+	if (!scsi_state)
+		desc_scsi_state = " ";
+	if (scsi_state & MPI2_SCSI_STATE_RESPONSE_INFO_VALID)
+		strcat(desc_scsi_state, "response info ");
+	if (scsi_state & MPI2_SCSI_STATE_TERMINATED)
+		strcat(desc_scsi_state, "state terminated ");
+	if (scsi_state & MPI2_SCSI_STATE_NO_SCSI_STATUS)
+		strcat(desc_scsi_state, "no status ");
+	if (scsi_state & MPI2_SCSI_STATE_AUTOSENSE_FAILED)
+		strcat(desc_scsi_state, "autosense failed ");
+	if (scsi_state & MPI2_SCSI_STATE_AUTOSENSE_VALID)
+		strcat(desc_scsi_state, "autosense valid ");
+
+	scsi_print_command(scmd);
+
+	if (priv_target->flags & MPT_TARGET_FLAGS_VOLUME) {
+		pr_warn(MPT3SAS_FMT "\t%s wwid(0x%016llx)\n", ioc->name,
+		    device_str, (unsigned long long)priv_target->sas_address);
+	} else {
+		spin_lock_irqsave(&ioc->sas_device_lock, flags);
+		sas_device = mpt3sas_scsih_sas_device_find_by_sas_address(ioc,
+		    priv_target->sas_address);
+		if (sas_device) {
+			pr_warn(MPT3SAS_FMT
+				"\tsas_address(0x%016llx), phy(%d)\n",
+				ioc->name, (unsigned long long)
+			    sas_device->sas_address, sas_device->phy);
+			pr_warn(MPT3SAS_FMT
+			    "\tenclosure_logical_id(0x%016llx), slot(%d)\n",
+			    ioc->name, (unsigned long long)
+			    sas_device->enclosure_logical_id, sas_device->slot);
+		}
+		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+	}
+
+	pr_warn(MPT3SAS_FMT
+		"\thandle(0x%04x), ioc_status(%s)(0x%04x), smid(%d)\n",
+		ioc->name, le16_to_cpu(mpi_reply->DevHandle),
+	    desc_ioc_state, ioc_status, smid);
+	pr_warn(MPT3SAS_FMT
+		"\trequest_len(%d), underflow(%d), resid(%d)\n",
+		ioc->name, scsi_bufflen(scmd), scmd->underflow,
+	    scsi_get_resid(scmd));
+	pr_warn(MPT3SAS_FMT
+		"\ttag(%d), transfer_count(%d), sc->result(0x%08x)\n",
+		ioc->name, le16_to_cpu(mpi_reply->TaskTag),
+	    le32_to_cpu(mpi_reply->TransferCount), scmd->result);
+	pr_warn(MPT3SAS_FMT
+		"\tscsi_status(%s)(0x%02x), scsi_state(%s)(0x%02x)\n",
+		ioc->name, desc_scsi_status,
+	    scsi_status, desc_scsi_state, scsi_state);
+
+	if (scsi_state & MPI2_SCSI_STATE_AUTOSENSE_VALID) {
+		struct sense_info data;
+		_scsih_normalize_sense(scmd->sense_buffer, &data);
+		pr_warn(MPT3SAS_FMT
+			"\t[sense_key,asc,ascq]: [0x%02x,0x%02x,0x%02x], count(%d)\n",
+			ioc->name, data.skey,
+		    data.asc, data.ascq, le32_to_cpu(mpi_reply->SenseCount));
+	}
+
+	if (scsi_state & MPI2_SCSI_STATE_RESPONSE_INFO_VALID) {
+		response_info = le32_to_cpu(mpi_reply->ResponseInfo);
+		response_bytes = (u8 *)&response_info;
+		_scsih_response_code(ioc, response_bytes[0]);
+	}
+}
+#endif
+
+/**
+ * _scsih_turn_on_fault_led - illuminate Fault LED
+ * @ioc: per adapter object
+ * @handle: device handle
+ * Context: process
+ *
+ * Return nothing.
+ */
+static void
+_scsih_turn_on_fault_led(struct MPT3SAS_ADAPTER *ioc, u16 handle)
+{
+	Mpi2SepReply_t mpi_reply;
+	Mpi2SepRequest_t mpi_request;
+
+	memset(&mpi_request, 0, sizeof(Mpi2SepRequest_t));
+	mpi_request.Function = MPI2_FUNCTION_SCSI_ENCLOSURE_PROCESSOR;
+	mpi_request.Action = MPI2_SEP_REQ_ACTION_WRITE_STATUS;
+	mpi_request.SlotStatus =
+	    cpu_to_le32(MPI2_SEP_REQ_SLOTSTATUS_PREDICTED_FAULT);
+	mpi_request.DevHandle = cpu_to_le16(handle);
+	mpi_request.Flags = MPI2_SEP_REQ_FLAGS_DEVHANDLE_ADDRESS;
+	if ((mpt3sas_base_scsi_enclosure_processor(ioc, &mpi_reply,
+	    &mpi_request)) != 0) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n", ioc->name,
+		__FILE__, __LINE__, __func__);
+		return;
+	}
+
+	if (mpi_reply.IOCStatus || mpi_reply.IOCLogInfo) {
+		dewtprintk(ioc, pr_info(MPT3SAS_FMT
+			"enclosure_processor: ioc_status (0x%04x), loginfo(0x%08x)\n",
+			ioc->name, le16_to_cpu(mpi_reply.IOCStatus),
+		    le32_to_cpu(mpi_reply.IOCLogInfo)));
+		return;
+	}
+}
+
+/**
+ * _scsih_send_event_to_turn_on_fault_led - fire delayed event
+ * @ioc: per adapter object
+ * @handle: device handle
+ * Context: interrupt.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_send_event_to_turn_on_fault_led(struct MPT3SAS_ADAPTER *ioc, u16 handle)
+{
+	struct fw_event_work *fw_event;
+
+	fw_event = kzalloc(sizeof(struct fw_event_work), GFP_ATOMIC);
+	if (!fw_event)
+		return;
+	fw_event->event = MPT3SAS_TURN_ON_FAULT_LED;
+	fw_event->device_handle = handle;
+	fw_event->ioc = ioc;
+	_scsih_fw_event_add(ioc, fw_event);
+}
+
+/**
+ * _scsih_smart_predicted_fault - process smart errors
+ * @ioc: per adapter object
+ * @handle: device handle
+ * Context: interrupt.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_smart_predicted_fault(struct MPT3SAS_ADAPTER *ioc, u16 handle)
+{
+	struct scsi_target *starget;
+	struct MPT3SAS_TARGET *sas_target_priv_data;
+	Mpi2EventNotificationReply_t *event_reply;
+	Mpi2EventDataSasDeviceStatusChange_t *event_data;
+	struct _sas_device *sas_device;
+	ssize_t sz;
+	unsigned long flags;
+
+	/* only handle non-raid devices */
+	spin_lock_irqsave(&ioc->sas_device_lock, flags);
+	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
+	if (!sas_device) {
+		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+		return;
+	}
+	starget = sas_device->starget;
+	sas_target_priv_data = starget->hostdata;
+
+	if ((sas_target_priv_data->flags & MPT_TARGET_FLAGS_RAID_COMPONENT) ||
+	   ((sas_target_priv_data->flags & MPT_TARGET_FLAGS_VOLUME))) {
+		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+		return;
+	}
+	starget_printk(KERN_WARNING, starget, "predicted fault\n");
+	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+
+	if (ioc->pdev->subsystem_vendor == PCI_VENDOR_ID_IBM)
+		_scsih_send_event_to_turn_on_fault_led(ioc, handle);
+
+	/* insert into event log */
+	sz = offsetof(Mpi2EventNotificationReply_t, EventData) +
+	     sizeof(Mpi2EventDataSasDeviceStatusChange_t);
+	event_reply = kzalloc(sz, GFP_KERNEL);
+	if (!event_reply) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		return;
+	}
+
+	event_reply->Function = MPI2_FUNCTION_EVENT_NOTIFICATION;
+	event_reply->Event =
+	    cpu_to_le16(MPI2_EVENT_SAS_DEVICE_STATUS_CHANGE);
+	event_reply->MsgLength = sz/4;
+	event_reply->EventDataLength =
+	    cpu_to_le16(sizeof(Mpi2EventDataSasDeviceStatusChange_t)/4);
+	event_data = (Mpi2EventDataSasDeviceStatusChange_t *)
+	    event_reply->EventData;
+	event_data->ReasonCode = MPI2_EVENT_SAS_DEV_STAT_RC_SMART_DATA;
+	event_data->ASC = 0x5D;
+	event_data->DevHandle = cpu_to_le16(handle);
+	event_data->SASAddress = cpu_to_le64(sas_target_priv_data->sas_address);
+	mpt3sas_ctl_add_to_event_log(ioc, event_reply);
+	kfree(event_reply);
+}
+
+/**
+ * _scsih_io_done - scsi request callback
+ * @ioc: per adapter object
+ * @smid: system request message index
+ * @msix_index: MSIX table index supplied by the OS
+ * @reply: reply message frame(lower 32bit addr)
+ *
+ * Callback handler when using _scsih_qcmd.
+ *
+ * Return 1 meaning mf should be freed from _base_interrupt
+ *        0 means the mf is freed from this function.
+ */
+static u8
+_scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
+{
+	Mpi2SCSIIORequest_t *mpi_request;
+	Mpi2SCSIIOReply_t *mpi_reply;
+	struct scsi_cmnd *scmd;
+	u16 ioc_status;
+	u32 xfer_cnt;
+	u8 scsi_state;
+	u8 scsi_status;
+	u32 log_info;
+	struct MPT3SAS_DEVICE *sas_device_priv_data;
+	u32 response_code = 0;
+
+	mpi_reply = mpt3sas_base_get_reply_virt_addr(ioc, reply);
+	scmd = _scsih_scsi_lookup_get_clear(ioc, smid);
+	if (scmd == NULL)
+		return 1;
+
+	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
+
+	if (mpi_reply == NULL) {
+		scmd->result = DID_OK << 16;
+		goto out;
+	}
+
+	sas_device_priv_data = scmd->device->hostdata;
+	if (!sas_device_priv_data || !sas_device_priv_data->sas_target ||
+	     sas_device_priv_data->sas_target->deleted) {
+		scmd->result = DID_NO_CONNECT << 16;
+		goto out;
+	}
+	ioc_status = le16_to_cpu(mpi_reply->IOCStatus);
+
+	/* turning off TLR */
+	scsi_state = mpi_reply->SCSIState;
+	if (scsi_state & MPI2_SCSI_STATE_RESPONSE_INFO_VALID)
+		response_code =
+		    le32_to_cpu(mpi_reply->ResponseInfo) & 0xFF;
+	if (!sas_device_priv_data->tlr_snoop_check) {
+		sas_device_priv_data->tlr_snoop_check++;
+		if ((sas_device_priv_data->flags & MPT_DEVICE_TLR_ON) &&
+		    response_code == MPI2_SCSITASKMGMT_RSP_INVALID_FRAME)
+			sas_device_priv_data->flags &=
+			    ~MPT_DEVICE_TLR_ON;
+	}
+
+	xfer_cnt = le32_to_cpu(mpi_reply->TransferCount);
+	scsi_set_resid(scmd, scsi_bufflen(scmd) - xfer_cnt);
+	if (ioc_status & MPI2_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE)
+		log_info =  le32_to_cpu(mpi_reply->IOCLogInfo);
+	else
+		log_info = 0;
+	ioc_status &= MPI2_IOCSTATUS_MASK;
+	scsi_status = mpi_reply->SCSIStatus;
+
+	if (ioc_status == MPI2_IOCSTATUS_SCSI_DATA_UNDERRUN && xfer_cnt == 0 &&
+	    (scsi_status == MPI2_SCSI_STATUS_BUSY ||
+	     scsi_status == MPI2_SCSI_STATUS_RESERVATION_CONFLICT ||
+	     scsi_status == MPI2_SCSI_STATUS_TASK_SET_FULL)) {
+		ioc_status = MPI2_IOCSTATUS_SUCCESS;
+	}
+
+	if (scsi_state & MPI2_SCSI_STATE_AUTOSENSE_VALID) {
+		struct sense_info data;
+		const void *sense_data = mpt3sas_base_get_sense_buffer(ioc,
+		    smid);
+		u32 sz = min_t(u32, SCSI_SENSE_BUFFERSIZE,
+		    le32_to_cpu(mpi_reply->SenseCount));
+		memcpy(scmd->sense_buffer, sense_data, sz);
+		_scsih_normalize_sense(scmd->sense_buffer, &data);
+		/* failure prediction threshold exceeded */
+		if (data.asc == 0x5D)
+			_scsih_smart_predicted_fault(ioc,
+			    le16_to_cpu(mpi_reply->DevHandle));
+		mpt3sas_trigger_scsi(ioc, data.skey, data.asc, data.ascq);
+	}
+
+	switch (ioc_status) {
+	case MPI2_IOCSTATUS_BUSY:
+	case MPI2_IOCSTATUS_INSUFFICIENT_RESOURCES:
+		scmd->result = SAM_STAT_BUSY;
+		break;
+
+	case MPI2_IOCSTATUS_SCSI_DEVICE_NOT_THERE:
+		scmd->result = DID_NO_CONNECT << 16;
+		break;
+
+	case MPI2_IOCSTATUS_SCSI_IOC_TERMINATED:
+		if (sas_device_priv_data->block) {
+			scmd->result = DID_TRANSPORT_DISRUPTED << 16;
+			goto out;
+		}
+		if (log_info == 0x31110630) {
+			if (scmd->retries > 2) {
+				scmd->result = DID_NO_CONNECT << 16;
+				scsi_device_set_state(scmd->device,
+				    SDEV_OFFLINE);
+			} else {
+				scmd->result = DID_SOFT_ERROR << 16;
+				scmd->device->expecting_cc_ua = 1;
+			}
+			break;
+		}
+		scmd->result = DID_SOFT_ERROR << 16;
+		break;
+	case MPI2_IOCSTATUS_SCSI_TASK_TERMINATED:
+	case MPI2_IOCSTATUS_SCSI_EXT_TERMINATED:
+		scmd->result = DID_RESET << 16;
+		break;
+
+	case MPI2_IOCSTATUS_SCSI_RESIDUAL_MISMATCH:
+		if ((xfer_cnt == 0) || (scmd->underflow > xfer_cnt))
+			scmd->result = DID_SOFT_ERROR << 16;
+		else
+			scmd->result = (DID_OK << 16) | scsi_status;
+		break;
+
+	case MPI2_IOCSTATUS_SCSI_DATA_UNDERRUN:
+		scmd->result = (DID_OK << 16) | scsi_status;
+
+		if ((scsi_state & MPI2_SCSI_STATE_AUTOSENSE_VALID))
+			break;
+
+		if (xfer_cnt < scmd->underflow) {
+			if (scsi_status == SAM_STAT_BUSY)
+				scmd->result = SAM_STAT_BUSY;
+			else
+				scmd->result = DID_SOFT_ERROR << 16;
+		} else if (scsi_state & (MPI2_SCSI_STATE_AUTOSENSE_FAILED |
+		     MPI2_SCSI_STATE_NO_SCSI_STATUS))
+			scmd->result = DID_SOFT_ERROR << 16;
+		else if (scsi_state & MPI2_SCSI_STATE_TERMINATED)
+			scmd->result = DID_RESET << 16;
+		else if (!xfer_cnt && scmd->cmnd[0] == REPORT_LUNS) {
+			mpi_reply->SCSIState = MPI2_SCSI_STATE_AUTOSENSE_VALID;
+			mpi_reply->SCSIStatus = SAM_STAT_CHECK_CONDITION;
+			scmd->result = (DRIVER_SENSE << 24) |
+			    SAM_STAT_CHECK_CONDITION;
+			scmd->sense_buffer[0] = 0x70;
+			scmd->sense_buffer[2] = ILLEGAL_REQUEST;
+			scmd->sense_buffer[12] = 0x20;
+			scmd->sense_buffer[13] = 0;
+		}
+		break;
+
+	case MPI2_IOCSTATUS_SCSI_DATA_OVERRUN:
+		scsi_set_resid(scmd, 0);
+	case MPI2_IOCSTATUS_SCSI_RECOVERED_ERROR:
+	case MPI2_IOCSTATUS_SUCCESS:
+		scmd->result = (DID_OK << 16) | scsi_status;
+		if (response_code ==
+		    MPI2_SCSITASKMGMT_RSP_INVALID_FRAME ||
+		    (scsi_state & (MPI2_SCSI_STATE_AUTOSENSE_FAILED |
+		     MPI2_SCSI_STATE_NO_SCSI_STATUS)))
+			scmd->result = DID_SOFT_ERROR << 16;
+		else if (scsi_state & MPI2_SCSI_STATE_TERMINATED)
+			scmd->result = DID_RESET << 16;
+		break;
+
+	case MPI2_IOCSTATUS_EEDP_GUARD_ERROR:
+	case MPI2_IOCSTATUS_EEDP_REF_TAG_ERROR:
+	case MPI2_IOCSTATUS_EEDP_APP_TAG_ERROR:
+		_scsih_eedp_error_handling(scmd, ioc_status);
+		break;
+
+	case MPI2_IOCSTATUS_SCSI_PROTOCOL_ERROR:
+	case MPI2_IOCSTATUS_INVALID_FUNCTION:
+	case MPI2_IOCSTATUS_INVALID_SGL:
+	case MPI2_IOCSTATUS_INTERNAL_ERROR:
+	case MPI2_IOCSTATUS_INVALID_FIELD:
+	case MPI2_IOCSTATUS_INVALID_STATE:
+	case MPI2_IOCSTATUS_SCSI_IO_DATA_ERROR:
+	case MPI2_IOCSTATUS_SCSI_TASK_MGMT_FAILED:
+	default:
+		scmd->result = DID_SOFT_ERROR << 16;
+		break;
+
+	}
+
+#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
+	if (scmd->result && (ioc->logging_level & MPT_DEBUG_REPLY))
+		_scsih_scsi_ioc_info(ioc , scmd, mpi_reply, smid);
+#endif
+
+ out:
+
+	scsi_dma_unmap(scmd);
+
+	scmd->scsi_done(scmd);
+	return 1;
+}
+
+/**
+ * _scsih_sas_host_refresh - refreshing sas host object contents
+ * @ioc: per adapter object
+ * Context: user
+ *
+ * During port enable, fw will send topology events for every device. Its
+ * possible that the handles may change from the previous setting, so this
+ * code keeping handles updating if changed.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_sas_host_refresh(struct MPT3SAS_ADAPTER *ioc)
+{
+	u16 sz;
+	u16 ioc_status;
+	int i;
+	Mpi2ConfigReply_t mpi_reply;
+	Mpi2SasIOUnitPage0_t *sas_iounit_pg0 = NULL;
+	u16 attached_handle;
+	u8 link_rate;
+
+	dtmprintk(ioc, pr_info(MPT3SAS_FMT
+	    "updating handles for sas_host(0x%016llx)\n",
+	    ioc->name, (unsigned long long)ioc->sas_hba.sas_address));
+
+	sz = offsetof(Mpi2SasIOUnitPage0_t, PhyData) + (ioc->sas_hba.num_phys
+	    * sizeof(Mpi2SasIOUnit0PhyData_t));
+	sas_iounit_pg0 = kzalloc(sz, GFP_KERNEL);
+	if (!sas_iounit_pg0) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		return;
+	}
+
+	if ((mpt3sas_config_get_sas_iounit_pg0(ioc, &mpi_reply,
+	    sas_iounit_pg0, sz)) != 0)
+		goto out;
+	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) & MPI2_IOCSTATUS_MASK;
+	if (ioc_status != MPI2_IOCSTATUS_SUCCESS)
+		goto out;
+	for (i = 0; i < ioc->sas_hba.num_phys ; i++) {
+		link_rate = sas_iounit_pg0->PhyData[i].NegotiatedLinkRate >> 4;
+		if (i == 0)
+			ioc->sas_hba.handle = le16_to_cpu(sas_iounit_pg0->
+			    PhyData[0].ControllerDevHandle);
+		ioc->sas_hba.phy[i].handle = ioc->sas_hba.handle;
+		attached_handle = le16_to_cpu(sas_iounit_pg0->PhyData[i].
+		    AttachedDevHandle);
+		if (attached_handle && link_rate < MPI2_SAS_NEG_LINK_RATE_1_5)
+			link_rate = MPI2_SAS_NEG_LINK_RATE_1_5;
+		mpt3sas_transport_update_links(ioc, ioc->sas_hba.sas_address,
+		    attached_handle, i, link_rate);
+	}
+ out:
+	kfree(sas_iounit_pg0);
+}
+
+/**
+ * _scsih_sas_host_add - create sas host object
+ * @ioc: per adapter object
+ *
+ * Creating host side data object, stored in ioc->sas_hba
+ *
+ * Return nothing.
+ */
+static void
+_scsih_sas_host_add(struct MPT3SAS_ADAPTER *ioc)
+{
+	int i;
+	Mpi2ConfigReply_t mpi_reply;
+	Mpi2SasIOUnitPage0_t *sas_iounit_pg0 = NULL;
+	Mpi2SasIOUnitPage1_t *sas_iounit_pg1 = NULL;
+	Mpi2SasPhyPage0_t phy_pg0;
+	Mpi2SasDevicePage0_t sas_device_pg0;
+	Mpi2SasEnclosurePage0_t enclosure_pg0;
+	u16 ioc_status;
+	u16 sz;
+	u8 device_missing_delay;
+
+	mpt3sas_config_get_number_hba_phys(ioc, &ioc->sas_hba.num_phys);
+	if (!ioc->sas_hba.num_phys) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		return;
+	}
+
+	/* sas_iounit page 0 */
+	sz = offsetof(Mpi2SasIOUnitPage0_t, PhyData) + (ioc->sas_hba.num_phys *
+	    sizeof(Mpi2SasIOUnit0PhyData_t));
+	sas_iounit_pg0 = kzalloc(sz, GFP_KERNEL);
+	if (!sas_iounit_pg0) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		return;
+	}
+	if ((mpt3sas_config_get_sas_iounit_pg0(ioc, &mpi_reply,
+	    sas_iounit_pg0, sz))) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		goto out;
+	}
+	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+	    MPI2_IOCSTATUS_MASK;
+	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		goto out;
+	}
+
+	/* sas_iounit page 1 */
+	sz = offsetof(Mpi2SasIOUnitPage1_t, PhyData) + (ioc->sas_hba.num_phys *
+	    sizeof(Mpi2SasIOUnit1PhyData_t));
+	sas_iounit_pg1 = kzalloc(sz, GFP_KERNEL);
+	if (!sas_iounit_pg1) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		goto out;
+	}
+	if ((mpt3sas_config_get_sas_iounit_pg1(ioc, &mpi_reply,
+	    sas_iounit_pg1, sz))) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		goto out;
+	}
+	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+	    MPI2_IOCSTATUS_MASK;
+	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		goto out;
+	}
+
+	ioc->io_missing_delay =
+	    sas_iounit_pg1->IODeviceMissingDelay;
+	device_missing_delay =
+	    sas_iounit_pg1->ReportDeviceMissingDelay;
+	if (device_missing_delay & MPI2_SASIOUNIT1_REPORT_MISSING_UNIT_16)
+		ioc->device_missing_delay = (device_missing_delay &
+		    MPI2_SASIOUNIT1_REPORT_MISSING_TIMEOUT_MASK) * 16;
+	else
+		ioc->device_missing_delay = device_missing_delay &
+		    MPI2_SASIOUNIT1_REPORT_MISSING_TIMEOUT_MASK;
+
+	ioc->sas_hba.parent_dev = &ioc->shost->shost_gendev;
+	ioc->sas_hba.phy = kcalloc(ioc->sas_hba.num_phys,
+	    sizeof(struct _sas_phy), GFP_KERNEL);
+	if (!ioc->sas_hba.phy) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		goto out;
+	}
+	for (i = 0; i < ioc->sas_hba.num_phys ; i++) {
+		if ((mpt3sas_config_get_phy_pg0(ioc, &mpi_reply, &phy_pg0,
+		    i))) {
+			pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+			    ioc->name, __FILE__, __LINE__, __func__);
+			goto out;
+		}
+		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+		    MPI2_IOCSTATUS_MASK;
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+			pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+			    ioc->name, __FILE__, __LINE__, __func__);
+			goto out;
+		}
+
+		if (i == 0)
+			ioc->sas_hba.handle = le16_to_cpu(sas_iounit_pg0->
+			    PhyData[0].ControllerDevHandle);
+		ioc->sas_hba.phy[i].handle = ioc->sas_hba.handle;
+		ioc->sas_hba.phy[i].phy_id = i;
+		mpt3sas_transport_add_host_phy(ioc, &ioc->sas_hba.phy[i],
+		    phy_pg0, ioc->sas_hba.parent_dev);
+	}
+	if ((mpt3sas_config_get_sas_device_pg0(ioc, &mpi_reply, &sas_device_pg0,
+	    MPI2_SAS_DEVICE_PGAD_FORM_HANDLE, ioc->sas_hba.handle))) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		goto out;
+	}
+	ioc->sas_hba.enclosure_handle =
+	    le16_to_cpu(sas_device_pg0.EnclosureHandle);
+	ioc->sas_hba.sas_address = le64_to_cpu(sas_device_pg0.SASAddress);
+	pr_info(MPT3SAS_FMT
+		"host_add: handle(0x%04x), sas_addr(0x%016llx), phys(%d)\n",
+		ioc->name, ioc->sas_hba.handle,
+	    (unsigned long long) ioc->sas_hba.sas_address,
+	    ioc->sas_hba.num_phys) ;
+
+	if (ioc->sas_hba.enclosure_handle) {
+		if (!(mpt3sas_config_get_enclosure_pg0(ioc, &mpi_reply,
+		    &enclosure_pg0, MPI2_SAS_ENCLOS_PGAD_FORM_HANDLE,
+		   ioc->sas_hba.enclosure_handle)))
+			ioc->sas_hba.enclosure_logical_id =
+			    le64_to_cpu(enclosure_pg0.EnclosureLogicalID);
+	}
+
+ out:
+	kfree(sas_iounit_pg1);
+	kfree(sas_iounit_pg0);
+}
+
+/**
+ * _scsih_expander_add -  creating expander object
+ * @ioc: per adapter object
+ * @handle: expander handle
+ *
+ * Creating expander object, stored in ioc->sas_expander_list.
+ *
+ * Return 0 for success, else error.
+ */
+static int
+_scsih_expander_add(struct MPT3SAS_ADAPTER *ioc, u16 handle)
+{
+	struct _sas_node *sas_expander;
+	Mpi2ConfigReply_t mpi_reply;
+	Mpi2ExpanderPage0_t expander_pg0;
+	Mpi2ExpanderPage1_t expander_pg1;
+	Mpi2SasEnclosurePage0_t enclosure_pg0;
+	u32 ioc_status;
+	u16 parent_handle;
+	u64 sas_address, sas_address_parent = 0;
+	int i;
+	unsigned long flags;
+	struct _sas_port *mpt3sas_port = NULL;
+
+	int rc = 0;
+
+	if (!handle)
+		return -1;
+
+	if (ioc->shost_recovery || ioc->pci_error_recovery)
+		return -1;
+
+	if ((mpt3sas_config_get_expander_pg0(ioc, &mpi_reply, &expander_pg0,
+	    MPI2_SAS_EXPAND_PGAD_FORM_HNDL, handle))) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		return -1;
+	}
+
+	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+	    MPI2_IOCSTATUS_MASK;
+	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		return -1;
+	}
+
+	/* handle out of order topology events */
+	parent_handle = le16_to_cpu(expander_pg0.ParentDevHandle);
+	if (_scsih_get_sas_address(ioc, parent_handle, &sas_address_parent)
+	    != 0) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		return -1;
+	}
+	if (sas_address_parent != ioc->sas_hba.sas_address) {
+		spin_lock_irqsave(&ioc->sas_node_lock, flags);
+		sas_expander = mpt3sas_scsih_expander_find_by_sas_address(ioc,
+		    sas_address_parent);
+		spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
+		if (!sas_expander) {
+			rc = _scsih_expander_add(ioc, parent_handle);
+			if (rc != 0)
+				return rc;
+		}
+	}
+
+	spin_lock_irqsave(&ioc->sas_node_lock, flags);
+	sas_address = le64_to_cpu(expander_pg0.SASAddress);
+	sas_expander = mpt3sas_scsih_expander_find_by_sas_address(ioc,
+	    sas_address);
+	spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
+
+	if (sas_expander)
+		return 0;
+
+	sas_expander = kzalloc(sizeof(struct _sas_node),
+	    GFP_KERNEL);
+	if (!sas_expander) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		return -1;
+	}
+
+	sas_expander->handle = handle;
+	sas_expander->num_phys = expander_pg0.NumPhys;
+	sas_expander->sas_address_parent = sas_address_parent;
+	sas_expander->sas_address = sas_address;
+
+	pr_info(MPT3SAS_FMT "expander_add: handle(0x%04x)," \
+	    " parent(0x%04x), sas_addr(0x%016llx), phys(%d)\n", ioc->name,
+	    handle, parent_handle, (unsigned long long)
+	    sas_expander->sas_address, sas_expander->num_phys);
+
+	if (!sas_expander->num_phys)
+		goto out_fail;
+	sas_expander->phy = kcalloc(sas_expander->num_phys,
+	    sizeof(struct _sas_phy), GFP_KERNEL);
+	if (!sas_expander->phy) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		rc = -1;
+		goto out_fail;
+	}
+
+	INIT_LIST_HEAD(&sas_expander->sas_port_list);
+	mpt3sas_port = mpt3sas_transport_port_add(ioc, handle,
+	    sas_address_parent);
+	if (!mpt3sas_port) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		rc = -1;
+		goto out_fail;
+	}
+	sas_expander->parent_dev = &mpt3sas_port->rphy->dev;
+
+	for (i = 0 ; i < sas_expander->num_phys ; i++) {
+		if ((mpt3sas_config_get_expander_pg1(ioc, &mpi_reply,
+		    &expander_pg1, i, handle))) {
+			pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+			    ioc->name, __FILE__, __LINE__, __func__);
+			rc = -1;
+			goto out_fail;
+		}
+		sas_expander->phy[i].handle = handle;
+		sas_expander->phy[i].phy_id = i;
+
+		if ((mpt3sas_transport_add_expander_phy(ioc,
+		    &sas_expander->phy[i], expander_pg1,
+		    sas_expander->parent_dev))) {
+			pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+			    ioc->name, __FILE__, __LINE__, __func__);
+			rc = -1;
+			goto out_fail;
+		}
+	}
+
+	if (sas_expander->enclosure_handle) {
+		if (!(mpt3sas_config_get_enclosure_pg0(ioc, &mpi_reply,
+		    &enclosure_pg0, MPI2_SAS_ENCLOS_PGAD_FORM_HANDLE,
+		   sas_expander->enclosure_handle)))
+			sas_expander->enclosure_logical_id =
+			    le64_to_cpu(enclosure_pg0.EnclosureLogicalID);
+	}
+
+	_scsih_expander_node_add(ioc, sas_expander);
+	 return 0;
+
+ out_fail:
+
+	if (mpt3sas_port)
+		mpt3sas_transport_port_remove(ioc, sas_expander->sas_address,
+		    sas_address_parent);
+	kfree(sas_expander);
+	return rc;
+}
+
+/**
+ * mpt3sas_expander_remove - removing expander object
+ * @ioc: per adapter object
+ * @sas_address: expander sas_address
+ *
+ * Return nothing.
+ */
+void
+mpt3sas_expander_remove(struct MPT3SAS_ADAPTER *ioc, u64 sas_address)
+{
+	struct _sas_node *sas_expander;
+	unsigned long flags;
+
+	if (ioc->shost_recovery)
+		return;
+
+	spin_lock_irqsave(&ioc->sas_node_lock, flags);
+	sas_expander = mpt3sas_scsih_expander_find_by_sas_address(ioc,
+	    sas_address);
+	if (sas_expander)
+		list_del(&sas_expander->list);
+	spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
+	if (sas_expander)
+		_scsih_expander_node_remove(ioc, sas_expander);
+}
+
+/**
+ * _scsih_done -  internal SCSI_IO callback handler.
+ * @ioc: per adapter object
+ * @smid: system request message index
+ * @msix_index: MSIX table index supplied by the OS
+ * @reply: reply message frame(lower 32bit addr)
+ *
+ * Callback handler when sending internal generated SCSI_IO.
+ * The callback index passed is `ioc->scsih_cb_idx`
+ *
+ * Return 1 meaning mf should be freed from _base_interrupt
+ *        0 means the mf is freed from this function.
+ */
+static u8
+_scsih_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
+{
+	MPI2DefaultReply_t *mpi_reply;
+
+	mpi_reply =  mpt3sas_base_get_reply_virt_addr(ioc, reply);
+	if (ioc->scsih_cmds.status == MPT3_CMD_NOT_USED)
+		return 1;
+	if (ioc->scsih_cmds.smid != smid)
+		return 1;
+	ioc->scsih_cmds.status |= MPT3_CMD_COMPLETE;
+	if (mpi_reply) {
+		memcpy(ioc->scsih_cmds.reply, mpi_reply,
+		    mpi_reply->MsgLength*4);
+		ioc->scsih_cmds.status |= MPT3_CMD_REPLY_VALID;
+	}
+	ioc->scsih_cmds.status &= ~MPT3_CMD_PENDING;
+	complete(&ioc->scsih_cmds.done);
+	return 1;
+}
+
+
+
+
+#define MPT3_MAX_LUNS (255)
+
+
+/**
+ * _scsih_check_access_status - check access flags
+ * @ioc: per adapter object
+ * @sas_address: sas address
+ * @handle: sas device handle
+ * @access_flags: errors returned during discovery of the device
+ *
+ * Return 0 for success, else failure
+ */
+static u8
+_scsih_check_access_status(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
+	u16 handle, u8 access_status)
+{
+	u8 rc = 1;
+	char *desc = NULL;
+
+	switch (access_status) {
+	case MPI2_SAS_DEVICE0_ASTATUS_NO_ERRORS:
+	case MPI2_SAS_DEVICE0_ASTATUS_SATA_NEEDS_INITIALIZATION:
+		rc = 0;
+		break;
+	case MPI2_SAS_DEVICE0_ASTATUS_SATA_CAPABILITY_FAILED:
+		desc = "sata capability failed";
+		break;
+	case MPI2_SAS_DEVICE0_ASTATUS_SATA_AFFILIATION_CONFLICT:
+		desc = "sata affiliation conflict";
+		break;
+	case MPI2_SAS_DEVICE0_ASTATUS_ROUTE_NOT_ADDRESSABLE:
+		desc = "route not addressable";
+		break;
+	case MPI2_SAS_DEVICE0_ASTATUS_SMP_ERROR_NOT_ADDRESSABLE:
+		desc = "smp error not addressable";
+		break;
+	case MPI2_SAS_DEVICE0_ASTATUS_DEVICE_BLOCKED:
+		desc = "device blocked";
+		break;
+	case MPI2_SAS_DEVICE0_ASTATUS_SATA_INIT_FAILED:
+	case MPI2_SAS_DEVICE0_ASTATUS_SIF_UNKNOWN:
+	case MPI2_SAS_DEVICE0_ASTATUS_SIF_AFFILIATION_CONFLICT:
+	case MPI2_SAS_DEVICE0_ASTATUS_SIF_DIAG:
+	case MPI2_SAS_DEVICE0_ASTATUS_SIF_IDENTIFICATION:
+	case MPI2_SAS_DEVICE0_ASTATUS_SIF_CHECK_POWER:
+	case MPI2_SAS_DEVICE0_ASTATUS_SIF_PIO_SN:
+	case MPI2_SAS_DEVICE0_ASTATUS_SIF_MDMA_SN:
+	case MPI2_SAS_DEVICE0_ASTATUS_SIF_UDMA_SN:
+	case MPI2_SAS_DEVICE0_ASTATUS_SIF_ZONING_VIOLATION:
+	case MPI2_SAS_DEVICE0_ASTATUS_SIF_NOT_ADDRESSABLE:
+	case MPI2_SAS_DEVICE0_ASTATUS_SIF_MAX:
+		desc = "sata initialization failed";
+		break;
+	default:
+		desc = "unknown";
+		break;
+	}
+
+	if (!rc)
+		return 0;
+
+	pr_err(MPT3SAS_FMT
+		"discovery errors(%s): sas_address(0x%016llx), handle(0x%04x)\n",
+		ioc->name, desc, (unsigned long long)sas_address, handle);
+	return rc;
+}
+
+/**
+ * _scsih_check_device - checking device responsiveness
+ * @ioc: per adapter object
+ * @parent_sas_address: sas address of parent expander or sas host
+ * @handle: attached device handle
+ * @phy_numberv: phy number
+ * @link_rate: new link rate
+ *
+ * Returns nothing.
+ */
+static void
+_scsih_check_device(struct MPT3SAS_ADAPTER *ioc,
+	u64 parent_sas_address, u16 handle, u8 phy_number, u8 link_rate)
+{
+	Mpi2ConfigReply_t mpi_reply;
+	Mpi2SasDevicePage0_t sas_device_pg0;
+	struct _sas_device *sas_device;
+	u32 ioc_status;
+	unsigned long flags;
+	u64 sas_address;
+	struct scsi_target *starget;
+	struct MPT3SAS_TARGET *sas_target_priv_data;
+	u32 device_info;
+
+
+	if ((mpt3sas_config_get_sas_device_pg0(ioc, &mpi_reply, &sas_device_pg0,
+	    MPI2_SAS_DEVICE_PGAD_FORM_HANDLE, handle)))
+		return;
+
+	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) & MPI2_IOCSTATUS_MASK;
+	if (ioc_status != MPI2_IOCSTATUS_SUCCESS)
+		return;
+
+	/* wide port handling ~ we need only handle device once for the phy that
+	 * is matched in sas device page zero
+	 */
+	if (phy_number != sas_device_pg0.PhyNum)
+		return;
+
+	/* check if this is end device */
+	device_info = le32_to_cpu(sas_device_pg0.DeviceInfo);
+	if (!(_scsih_is_end_device(device_info)))
+		return;
+
+	spin_lock_irqsave(&ioc->sas_device_lock, flags);
+	sas_address = le64_to_cpu(sas_device_pg0.SASAddress);
+	sas_device = mpt3sas_scsih_sas_device_find_by_sas_address(ioc,
+	    sas_address);
+
+	if (!sas_device) {
+		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+		return;
+	}
+
+	if (unlikely(sas_device->handle != handle)) {
+		starget = sas_device->starget;
+		sas_target_priv_data = starget->hostdata;
+		starget_printk(KERN_INFO, starget,
+			"handle changed from(0x%04x) to (0x%04x)!!!\n",
+			sas_device->handle, handle);
+		sas_target_priv_data->handle = handle;
+		sas_device->handle = handle;
+	}
+
+	/* check if device is present */
+	if (!(le16_to_cpu(sas_device_pg0.Flags) &
+	    MPI2_SAS_DEVICE0_FLAGS_DEVICE_PRESENT)) {
+		pr_err(MPT3SAS_FMT
+			"device is not present handle(0x%04x), flags!!!\n",
+			ioc->name, handle);
+		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+		return;
+	}
+
+	/* check if there were any issues with discovery */
+	if (_scsih_check_access_status(ioc, sas_address, handle,
+	    sas_device_pg0.AccessStatus)) {
+		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+		return;
+	}
+
+	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+	_scsih_ublock_io_device(ioc, sas_address);
+
+}
+
+/**
+ * _scsih_add_device -  creating sas device object
+ * @ioc: per adapter object
+ * @handle: sas device handle
+ * @phy_num: phy number end device attached to
+ * @is_pd: is this hidden raid component
+ *
+ * Creating end device object, stored in ioc->sas_device_list.
+ *
+ * Returns 0 for success, non-zero for failure.
+ */
+static int
+_scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phy_num,
+	u8 is_pd)
+{
+	Mpi2ConfigReply_t mpi_reply;
+	Mpi2SasDevicePage0_t sas_device_pg0;
+	Mpi2SasEnclosurePage0_t enclosure_pg0;
+	struct _sas_device *sas_device;
+	u32 ioc_status;
+	u64 sas_address;
+	u32 device_info;
+	unsigned long flags;
+
+	if ((mpt3sas_config_get_sas_device_pg0(ioc, &mpi_reply, &sas_device_pg0,
+	    MPI2_SAS_DEVICE_PGAD_FORM_HANDLE, handle))) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		return -1;
+	}
+
+	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+	    MPI2_IOCSTATUS_MASK;
+	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		return -1;
+	}
+
+	/* check if this is end device */
+	device_info = le32_to_cpu(sas_device_pg0.DeviceInfo);
+	if (!(_scsih_is_end_device(device_info)))
+		return -1;
+	sas_address = le64_to_cpu(sas_device_pg0.SASAddress);
+
+	/* check if device is present */
+	if (!(le16_to_cpu(sas_device_pg0.Flags) &
+	    MPI2_SAS_DEVICE0_FLAGS_DEVICE_PRESENT)) {
+		pr_err(MPT3SAS_FMT "device is not present handle(0x04%x)!!!\n",
+			ioc->name, handle);
+		return -1;
+	}
+
+	/* check if there were any issues with discovery */
+	if (_scsih_check_access_status(ioc, sas_address, handle,
+	    sas_device_pg0.AccessStatus))
+		return -1;
+
+	spin_lock_irqsave(&ioc->sas_device_lock, flags);
+	sas_device = mpt3sas_scsih_sas_device_find_by_sas_address(ioc,
+	    sas_address);
+	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+
+	if (sas_device)
+		return -1;
+
+	sas_device = kzalloc(sizeof(struct _sas_device),
+	    GFP_KERNEL);
+	if (!sas_device) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		return 0;
+	}
+
+	sas_device->handle = handle;
+	if (_scsih_get_sas_address(ioc,
+	    le16_to_cpu(sas_device_pg0.ParentDevHandle),
+	    &sas_device->sas_address_parent) != 0)
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+	sas_device->enclosure_handle =
+	    le16_to_cpu(sas_device_pg0.EnclosureHandle);
+	sas_device->slot =
+	    le16_to_cpu(sas_device_pg0.Slot);
+	sas_device->device_info = device_info;
+	sas_device->sas_address = sas_address;
+	sas_device->phy = sas_device_pg0.PhyNum;
+	sas_device->fast_path = (le16_to_cpu(sas_device_pg0.Flags) &
+	    MPI25_SAS_DEVICE0_FLAGS_FAST_PATH_CAPABLE) ? 1 : 0;
+
+	/* get enclosure_logical_id */
+	if (sas_device->enclosure_handle && !(mpt3sas_config_get_enclosure_pg0(
+	   ioc, &mpi_reply, &enclosure_pg0, MPI2_SAS_ENCLOS_PGAD_FORM_HANDLE,
+	   sas_device->enclosure_handle)))
+		sas_device->enclosure_logical_id =
+		    le64_to_cpu(enclosure_pg0.EnclosureLogicalID);
+
+	/* get device name */
+	sas_device->device_name = le64_to_cpu(sas_device_pg0.DeviceName);
+
+	if (ioc->wait_for_discovery_to_complete)
+		_scsih_sas_device_init_add(ioc, sas_device);
+	else
+		_scsih_sas_device_add(ioc, sas_device);
+
+	return 0;
+}
+
+/**
+ * _scsih_remove_device -  removing sas device object
+ * @ioc: per adapter object
+ * @sas_device_delete: the sas_device object
+ *
+ * Return nothing.
+ */
+static void
+_scsih_remove_device(struct MPT3SAS_ADAPTER *ioc,
+	struct _sas_device *sas_device)
+{
+	struct MPT3SAS_TARGET *sas_target_priv_data;
+
+
+	dewtprintk(ioc, pr_info(MPT3SAS_FMT
+		"%s: enter: handle(0x%04x), sas_addr(0x%016llx)\n",
+		ioc->name, __func__,
+	    sas_device->handle, (unsigned long long)
+	    sas_device->sas_address));
+
+	if (sas_device->starget && sas_device->starget->hostdata) {
+		sas_target_priv_data = sas_device->starget->hostdata;
+		sas_target_priv_data->deleted = 1;
+		_scsih_ublock_io_device(ioc, sas_device->sas_address);
+		sas_target_priv_data->handle =
+		     MPT3SAS_INVALID_DEVICE_HANDLE;
+	}
+	mpt3sas_transport_port_remove(ioc,
+		    sas_device->sas_address,
+		    sas_device->sas_address_parent);
+
+	pr_info(MPT3SAS_FMT
+		"removing handle(0x%04x), sas_addr(0x%016llx)\n",
+		ioc->name, sas_device->handle,
+	    (unsigned long long) sas_device->sas_address);
+
+	dewtprintk(ioc, pr_info(MPT3SAS_FMT
+		"%s: exit: handle(0x%04x), sas_addr(0x%016llx)\n",
+		ioc->name, __func__,
+	    sas_device->handle, (unsigned long long)
+	    sas_device->sas_address));
+
+	kfree(sas_device);
+}
+
+#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
+/**
+ * _scsih_sas_topology_change_event_debug - debug for topology event
+ * @ioc: per adapter object
+ * @event_data: event data payload
+ * Context: user.
+ */
+static void
+_scsih_sas_topology_change_event_debug(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2EventDataSasTopologyChangeList_t *event_data)
+{
+	int i;
+	u16 handle;
+	u16 reason_code;
+	u8 phy_number;
+	char *status_str = NULL;
+	u8 link_rate, prev_link_rate;
+
+	switch (event_data->ExpStatus) {
+	case MPI2_EVENT_SAS_TOPO_ES_ADDED:
+		status_str = "add";
+		break;
+	case MPI2_EVENT_SAS_TOPO_ES_NOT_RESPONDING:
+		status_str = "remove";
+		break;
+	case MPI2_EVENT_SAS_TOPO_ES_RESPONDING:
+	case 0:
+		status_str =  "responding";
+		break;
+	case MPI2_EVENT_SAS_TOPO_ES_DELAY_NOT_RESPONDING:
+		status_str = "remove delay";
+		break;
+	default:
+		status_str = "unknown status";
+		break;
+	}
+	pr_info(MPT3SAS_FMT "sas topology change: (%s)\n",
+	    ioc->name, status_str);
+	pr_info("\thandle(0x%04x), enclosure_handle(0x%04x) " \
+	    "start_phy(%02d), count(%d)\n",
+	    le16_to_cpu(event_data->ExpanderDevHandle),
+	    le16_to_cpu(event_data->EnclosureHandle),
+	    event_data->StartPhyNum, event_data->NumEntries);
+	for (i = 0; i < event_data->NumEntries; i++) {
+		handle = le16_to_cpu(event_data->PHY[i].AttachedDevHandle);
+		if (!handle)
+			continue;
+		phy_number = event_data->StartPhyNum + i;
+		reason_code = event_data->PHY[i].PhyStatus &
+		    MPI2_EVENT_SAS_TOPO_RC_MASK;
+		switch (reason_code) {
+		case MPI2_EVENT_SAS_TOPO_RC_TARG_ADDED:
+			status_str = "target add";
+			break;
+		case MPI2_EVENT_SAS_TOPO_RC_TARG_NOT_RESPONDING:
+			status_str = "target remove";
+			break;
+		case MPI2_EVENT_SAS_TOPO_RC_DELAY_NOT_RESPONDING:
+			status_str = "delay target remove";
+			break;
+		case MPI2_EVENT_SAS_TOPO_RC_PHY_CHANGED:
+			status_str = "link rate change";
+			break;
+		case MPI2_EVENT_SAS_TOPO_RC_NO_CHANGE:
+			status_str = "target responding";
+			break;
+		default:
+			status_str = "unknown";
+			break;
+		}
+		link_rate = event_data->PHY[i].LinkRate >> 4;
+		prev_link_rate = event_data->PHY[i].LinkRate & 0xF;
+		pr_info("\tphy(%02d), attached_handle(0x%04x): %s:" \
+		    " link rate: new(0x%02x), old(0x%02x)\n", phy_number,
+		    handle, status_str, link_rate, prev_link_rate);
+
+	}
+}
+#endif
+
+/**
+ * _scsih_sas_topology_change_event - handle topology changes
+ * @ioc: per adapter object
+ * @fw_event: The fw_event_work object
+ * Context: user.
+ *
+ */
+static int
+_scsih_sas_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
+	struct fw_event_work *fw_event)
+{
+	int i;
+	u16 parent_handle, handle;
+	u16 reason_code;
+	u8 phy_number, max_phys;
+	struct _sas_node *sas_expander;
+	u64 sas_address;
+	unsigned long flags;
+	u8 link_rate, prev_link_rate;
+	Mpi2EventDataSasTopologyChangeList_t *event_data = fw_event->event_data;
+
+#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
+	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
+		_scsih_sas_topology_change_event_debug(ioc, event_data);
+#endif
+
+	if (ioc->shost_recovery || ioc->remove_host || ioc->pci_error_recovery)
+		return 0;
+
+	if (!ioc->sas_hba.num_phys)
+		_scsih_sas_host_add(ioc);
+	else
+		_scsih_sas_host_refresh(ioc);
+
+	if (fw_event->ignore) {
+		dewtprintk(ioc, pr_info(MPT3SAS_FMT
+			"ignoring expander event\n", ioc->name));
+		return 0;
+	}
+
+	parent_handle = le16_to_cpu(event_data->ExpanderDevHandle);
+
+	/* handle expander add */
+	if (event_data->ExpStatus == MPI2_EVENT_SAS_TOPO_ES_ADDED)
+		if (_scsih_expander_add(ioc, parent_handle) != 0)
+			return 0;
+
+	spin_lock_irqsave(&ioc->sas_node_lock, flags);
+	sas_expander = mpt3sas_scsih_expander_find_by_handle(ioc,
+	    parent_handle);
+	if (sas_expander) {
+		sas_address = sas_expander->sas_address;
+		max_phys = sas_expander->num_phys;
+	} else if (parent_handle < ioc->sas_hba.num_phys) {
+		sas_address = ioc->sas_hba.sas_address;
+		max_phys = ioc->sas_hba.num_phys;
+	} else {
+		spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
+		return 0;
+	}
+	spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
+
+	/* handle siblings events */
+	for (i = 0; i < event_data->NumEntries; i++) {
+		if (fw_event->ignore) {
+			dewtprintk(ioc, pr_info(MPT3SAS_FMT
+				"ignoring expander event\n", ioc->name));
+			return 0;
+		}
+		if (ioc->remove_host || ioc->pci_error_recovery)
+			return 0;
+		phy_number = event_data->StartPhyNum + i;
+		if (phy_number >= max_phys)
+			continue;
+		reason_code = event_data->PHY[i].PhyStatus &
+		    MPI2_EVENT_SAS_TOPO_RC_MASK;
+		if ((event_data->PHY[i].PhyStatus &
+		    MPI2_EVENT_SAS_TOPO_PHYSTATUS_VACANT) && (reason_code !=
+		    MPI2_EVENT_SAS_TOPO_RC_TARG_NOT_RESPONDING))
+				continue;
+		handle = le16_to_cpu(event_data->PHY[i].AttachedDevHandle);
+		if (!handle)
+			continue;
+		link_rate = event_data->PHY[i].LinkRate >> 4;
+		prev_link_rate = event_data->PHY[i].LinkRate & 0xF;
+		switch (reason_code) {
+		case MPI2_EVENT_SAS_TOPO_RC_PHY_CHANGED:
+
+			if (ioc->shost_recovery)
+				break;
+
+			if (link_rate == prev_link_rate)
+				break;
+
+			mpt3sas_transport_update_links(ioc, sas_address,
+			    handle, phy_number, link_rate);
+
+			if (link_rate < MPI2_SAS_NEG_LINK_RATE_1_5)
+				break;
+
+			_scsih_check_device(ioc, sas_address, handle,
+			    phy_number, link_rate);
+
+
+		case MPI2_EVENT_SAS_TOPO_RC_TARG_ADDED:
+
+			if (ioc->shost_recovery)
+				break;
+
+			mpt3sas_transport_update_links(ioc, sas_address,
+			    handle, phy_number, link_rate);
+
+			_scsih_add_device(ioc, handle, phy_number, 0);
+
+			break;
+		case MPI2_EVENT_SAS_TOPO_RC_TARG_NOT_RESPONDING:
+
+			_scsih_device_remove_by_handle(ioc, handle);
+			break;
+		}
+	}
+
+	/* handle expander removal */
+	if (event_data->ExpStatus == MPI2_EVENT_SAS_TOPO_ES_NOT_RESPONDING &&
+	    sas_expander)
+		mpt3sas_expander_remove(ioc, sas_address);
+
+	return 0;
+}
+
+#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
+/**
+ * _scsih_sas_device_status_change_event_debug - debug for device event
+ * @event_data: event data payload
+ * Context: user.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_sas_device_status_change_event_debug(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2EventDataSasDeviceStatusChange_t *event_data)
+{
+	char *reason_str = NULL;
+
+	switch (event_data->ReasonCode) {
+	case MPI2_EVENT_SAS_DEV_STAT_RC_SMART_DATA:
+		reason_str = "smart data";
+		break;
+	case MPI2_EVENT_SAS_DEV_STAT_RC_UNSUPPORTED:
+		reason_str = "unsupported device discovered";
+		break;
+	case MPI2_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET:
+		reason_str = "internal device reset";
+		break;
+	case MPI2_EVENT_SAS_DEV_STAT_RC_TASK_ABORT_INTERNAL:
+		reason_str = "internal task abort";
+		break;
+	case MPI2_EVENT_SAS_DEV_STAT_RC_ABORT_TASK_SET_INTERNAL:
+		reason_str = "internal task abort set";
+		break;
+	case MPI2_EVENT_SAS_DEV_STAT_RC_CLEAR_TASK_SET_INTERNAL:
+		reason_str = "internal clear task set";
+		break;
+	case MPI2_EVENT_SAS_DEV_STAT_RC_QUERY_TASK_INTERNAL:
+		reason_str = "internal query task";
+		break;
+	case MPI2_EVENT_SAS_DEV_STAT_RC_SATA_INIT_FAILURE:
+		reason_str = "sata init failure";
+		break;
+	case MPI2_EVENT_SAS_DEV_STAT_RC_CMP_INTERNAL_DEV_RESET:
+		reason_str = "internal device reset complete";
+		break;
+	case MPI2_EVENT_SAS_DEV_STAT_RC_CMP_TASK_ABORT_INTERNAL:
+		reason_str = "internal task abort complete";
+		break;
+	case MPI2_EVENT_SAS_DEV_STAT_RC_ASYNC_NOTIFICATION:
+		reason_str = "internal async notification";
+		break;
+	case MPI2_EVENT_SAS_DEV_STAT_RC_EXPANDER_REDUCED_FUNCTIONALITY:
+		reason_str = "expander reduced functionality";
+		break;
+	case MPI2_EVENT_SAS_DEV_STAT_RC_CMP_EXPANDER_REDUCED_FUNCTIONALITY:
+		reason_str = "expander reduced functionality complete";
+		break;
+	default:
+		reason_str = "unknown reason";
+		break;
+	}
+	pr_info(MPT3SAS_FMT "device status change: (%s)\n"
+	    "\thandle(0x%04x), sas address(0x%016llx), tag(%d)",
+	    ioc->name, reason_str, le16_to_cpu(event_data->DevHandle),
+	    (unsigned long long)le64_to_cpu(event_data->SASAddress),
+	    le16_to_cpu(event_data->TaskTag));
+	if (event_data->ReasonCode == MPI2_EVENT_SAS_DEV_STAT_RC_SMART_DATA)
+		pr_info(MPT3SAS_FMT ", ASC(0x%x), ASCQ(0x%x)\n", ioc->name,
+		    event_data->ASC, event_data->ASCQ);
+	pr_info("\n");
+}
+#endif
+
+/**
+ * _scsih_sas_device_status_change_event - handle device status change
+ * @ioc: per adapter object
+ * @fw_event: The fw_event_work object
+ * Context: user.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_sas_device_status_change_event(struct MPT3SAS_ADAPTER *ioc,
+	struct fw_event_work *fw_event)
+{
+	struct MPT3SAS_TARGET *target_priv_data;
+	struct _sas_device *sas_device;
+	u64 sas_address;
+	unsigned long flags;
+	Mpi2EventDataSasDeviceStatusChange_t *event_data =
+	    fw_event->event_data;
+
+#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
+	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
+		_scsih_sas_device_status_change_event_debug(ioc,
+		     event_data);
+#endif
+
+	/* In MPI Revision K (0xC), the internal device reset complete was
+	 * implemented, so avoid setting tm_busy flag for older firmware.
+	 */
+	if ((ioc->facts.HeaderVersion >> 8) < 0xC)
+		return;
+
+	if (event_data->ReasonCode !=
+	    MPI2_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET &&
+	   event_data->ReasonCode !=
+	    MPI2_EVENT_SAS_DEV_STAT_RC_CMP_INTERNAL_DEV_RESET)
+		return;
+
+	spin_lock_irqsave(&ioc->sas_device_lock, flags);
+	sas_address = le64_to_cpu(event_data->SASAddress);
+	sas_device = mpt3sas_scsih_sas_device_find_by_sas_address(ioc,
+	    sas_address);
+
+	if (!sas_device || !sas_device->starget) {
+		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+		return;
+	}
+
+	target_priv_data = sas_device->starget->hostdata;
+	if (!target_priv_data) {
+		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+		return;
+	}
+
+	if (event_data->ReasonCode ==
+	    MPI2_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET)
+		target_priv_data->tm_busy = 1;
+	else
+		target_priv_data->tm_busy = 0;
+	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+}
+
+#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
+/**
+ * _scsih_sas_enclosure_dev_status_change_event_debug - debug for enclosure
+ * event
+ * @ioc: per adapter object
+ * @event_data: event data payload
+ * Context: user.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_sas_enclosure_dev_status_change_event_debug(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2EventDataSasEnclDevStatusChange_t *event_data)
+{
+	char *reason_str = NULL;
+
+	switch (event_data->ReasonCode) {
+	case MPI2_EVENT_SAS_ENCL_RC_ADDED:
+		reason_str = "enclosure add";
+		break;
+	case MPI2_EVENT_SAS_ENCL_RC_NOT_RESPONDING:
+		reason_str = "enclosure remove";
+		break;
+	default:
+		reason_str = "unknown reason";
+		break;
+	}
+
+	pr_info(MPT3SAS_FMT "enclosure status change: (%s)\n"
+	    "\thandle(0x%04x), enclosure logical id(0x%016llx)"
+	    " number slots(%d)\n", ioc->name, reason_str,
+	    le16_to_cpu(event_data->EnclosureHandle),
+	    (unsigned long long)le64_to_cpu(event_data->EnclosureLogicalID),
+	    le16_to_cpu(event_data->StartSlot));
+}
+#endif
+
+/**
+ * _scsih_sas_enclosure_dev_status_change_event - handle enclosure events
+ * @ioc: per adapter object
+ * @fw_event: The fw_event_work object
+ * Context: user.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_sas_enclosure_dev_status_change_event(struct MPT3SAS_ADAPTER *ioc,
+	struct fw_event_work *fw_event)
+{
+#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
+	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
+		_scsih_sas_enclosure_dev_status_change_event_debug(ioc,
+		     fw_event->event_data);
+#endif
+}
+
+/**
+ * _scsih_sas_broadcast_primitive_event - handle broadcast events
+ * @ioc: per adapter object
+ * @fw_event: The fw_event_work object
+ * Context: user.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_sas_broadcast_primitive_event(struct MPT3SAS_ADAPTER *ioc,
+	struct fw_event_work *fw_event)
+{
+	struct scsi_cmnd *scmd;
+	struct scsi_device *sdev;
+	u16 smid, handle;
+	u32 lun;
+	struct MPT3SAS_DEVICE *sas_device_priv_data;
+	u32 termination_count;
+	u32 query_count;
+	Mpi2SCSITaskManagementReply_t *mpi_reply;
+	u16 ioc_status;
+	unsigned long flags;
+	int r;
+	u8 max_retries = 0;
+	u8 task_abort_retries;
+
+	mutex_lock(&ioc->tm_cmds.mutex);
+	dewtprintk(ioc, pr_info(MPT3SAS_FMT
+		"%s: enter: phy number(%d), width(%d)\n",
+		ioc->name, __func__, event_data->PhyNum,
+	     event_data->PortWidth));
+
+	  _scsih_block_io_all_device(ioc);
+
+	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+	mpi_reply = ioc->tm_cmds.reply;
+ broadcast_aen_retry:
+
+	/* sanity checks for retrying this loop */
+	if (max_retries++ == 5) {
+		dewtprintk(ioc, pr_info(MPT3SAS_FMT "%s: giving up\n",
+		    ioc->name, __func__));
+		goto out;
+	} else if (max_retries > 1)
+		dewtprintk(ioc, pr_info(MPT3SAS_FMT "%s: %d retry\n",
+		    ioc->name, __func__, max_retries - 1));
+
+	termination_count = 0;
+	query_count = 0;
+	for (smid = 1; smid <= ioc->scsiio_depth; smid++) {
+		if (ioc->shost_recovery)
+			goto out;
+		scmd = _scsih_scsi_lookup_get(ioc, smid);
+		if (!scmd)
+			continue;
+		sdev = scmd->device;
+		sas_device_priv_data = sdev->hostdata;
+		if (!sas_device_priv_data || !sas_device_priv_data->sas_target)
+			continue;
+		 /* skip hidden raid components */
+		if (sas_device_priv_data->sas_target->flags &
+		    MPT_TARGET_FLAGS_RAID_COMPONENT)
+			continue;
+		 /* skip volumes */
+		if (sas_device_priv_data->sas_target->flags &
+		    MPT_TARGET_FLAGS_VOLUME)
+			continue;
+
+		handle = sas_device_priv_data->sas_target->handle;
+		lun = sas_device_priv_data->lun;
+		query_count++;
+
+		if (ioc->shost_recovery)
+			goto out;
+
+		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+		r = mpt3sas_scsih_issue_tm(ioc, handle, 0, 0, lun,
+		    MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK, smid, 30, 0,
+		    TM_MUTEX_OFF);
+		if (r == FAILED) {
+			sdev_printk(KERN_WARNING, sdev,
+			    "mpt3sas_scsih_issue_tm: FAILED when sending "
+			    "QUERY_TASK: scmd(%p)\n", scmd);
+			spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+			goto broadcast_aen_retry;
+		}
+		ioc_status = le16_to_cpu(mpi_reply->IOCStatus)
+		    & MPI2_IOCSTATUS_MASK;
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+			sdev_printk(KERN_WARNING, sdev,
+				"query task: FAILED with IOCSTATUS(0x%04x), scmd(%p)\n",
+				ioc_status, scmd);
+			spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+			goto broadcast_aen_retry;
+		}
+
+		/* see if IO is still owned by IOC and target */
+		if (mpi_reply->ResponseCode ==
+		     MPI2_SCSITASKMGMT_RSP_TM_SUCCEEDED ||
+		     mpi_reply->ResponseCode ==
+		     MPI2_SCSITASKMGMT_RSP_IO_QUEUED_ON_IOC) {
+			spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+			continue;
+		}
+		task_abort_retries = 0;
+ tm_retry:
+		if (task_abort_retries++ == 60) {
+			dewtprintk(ioc, pr_info(MPT3SAS_FMT
+			    "%s: ABORT_TASK: giving up\n", ioc->name,
+			    __func__));
+			spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+			goto broadcast_aen_retry;
+		}
+
+		if (ioc->shost_recovery)
+			goto out_no_lock;
+
+		r = mpt3sas_scsih_issue_tm(ioc, handle, sdev->channel, sdev->id,
+		    sdev->lun, MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK, smid, 30,
+		    scmd->serial_number, TM_MUTEX_OFF);
+		if (r == FAILED) {
+			sdev_printk(KERN_WARNING, sdev,
+			    "mpt3sas_scsih_issue_tm: ABORT_TASK: FAILED : "
+			    "scmd(%p)\n", scmd);
+			goto tm_retry;
+		}
+
+		if (task_abort_retries > 1)
+			sdev_printk(KERN_WARNING, sdev,
+			    "mpt3sas_scsih_issue_tm: ABORT_TASK: RETRIES (%d):"
+			    " scmd(%p)\n",
+			    task_abort_retries - 1, scmd);
+
+		termination_count += le32_to_cpu(mpi_reply->TerminationCount);
+		spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+	}
+
+	if (ioc->broadcast_aen_pending) {
+		dewtprintk(ioc, pr_info(MPT3SAS_FMT
+			"%s: loop back due to pending AEN\n",
+			ioc->name, __func__));
+		 ioc->broadcast_aen_pending = 0;
+		 goto broadcast_aen_retry;
+	}
+
+ out:
+	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+ out_no_lock:
+
+	dewtprintk(ioc, pr_info(MPT3SAS_FMT
+	    "%s - exit, query_count = %d termination_count = %d\n",
+	    ioc->name, __func__, query_count, termination_count));
+
+	ioc->broadcast_aen_busy = 0;
+	if (!ioc->shost_recovery)
+		_scsih_ublock_io_all_device(ioc);
+	mutex_unlock(&ioc->tm_cmds.mutex);
+}
+
+/**
+ * _scsih_sas_discovery_event - handle discovery events
+ * @ioc: per adapter object
+ * @fw_event: The fw_event_work object
+ * Context: user.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_sas_discovery_event(struct MPT3SAS_ADAPTER *ioc,
+	struct fw_event_work *fw_event)
+{
+	Mpi2EventDataSasDiscovery_t *event_data = fw_event->event_data;
+
+#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
+	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK) {
+		pr_info(MPT3SAS_FMT "discovery event: (%s)", ioc->name,
+		    (event_data->ReasonCode == MPI2_EVENT_SAS_DISC_RC_STARTED) ?
+		    "start" : "stop");
+	if (event_data->DiscoveryStatus)
+		pr_info("discovery_status(0x%08x)",
+		    le32_to_cpu(event_data->DiscoveryStatus));
+	pr_info("\n");
+	}
+#endif
+
+	if (event_data->ReasonCode == MPI2_EVENT_SAS_DISC_RC_STARTED &&
+	    !ioc->sas_hba.num_phys) {
+		if (disable_discovery > 0 && ioc->shost_recovery) {
+			/* Wait for the reset to complete */
+			while (ioc->shost_recovery)
+				ssleep(1);
+		}
+		_scsih_sas_host_add(ioc);
+	}
+}
+
+/**
+ * _scsih_ir_fastpath - turn on fastpath for IR physdisk
+ * @ioc: per adapter object
+ * @handle: device handle for physical disk
+ * @phys_disk_num: physical disk number
+ *
+ * Return 0 for success, else failure.
+ */
+static int
+_scsih_ir_fastpath(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phys_disk_num)
+{
+	Mpi2RaidActionRequest_t *mpi_request;
+	Mpi2RaidActionReply_t *mpi_reply;
+	u16 smid;
+	u8 issue_reset = 0;
+	int rc = 0;
+	u16 ioc_status;
+	u32 log_info;
+
+
+	mutex_lock(&ioc->scsih_cmds.mutex);
+
+	if (ioc->scsih_cmds.status != MPT3_CMD_NOT_USED) {
+		pr_err(MPT3SAS_FMT "%s: scsih_cmd in use\n",
+		    ioc->name, __func__);
+		rc = -EAGAIN;
+		goto out;
+	}
+	ioc->scsih_cmds.status = MPT3_CMD_PENDING;
+
+	smid = mpt3sas_base_get_smid(ioc, ioc->scsih_cb_idx);
+	if (!smid) {
+		pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
+		    ioc->name, __func__);
+		ioc->scsih_cmds.status = MPT3_CMD_NOT_USED;
+		rc = -EAGAIN;
+		goto out;
+	}
+
+	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
+	ioc->scsih_cmds.smid = smid;
+	memset(mpi_request, 0, sizeof(Mpi2RaidActionRequest_t));
+
+	mpi_request->Function = MPI2_FUNCTION_RAID_ACTION;
+	mpi_request->Action = MPI2_RAID_ACTION_PHYSDISK_HIDDEN;
+	mpi_request->PhysDiskNum = phys_disk_num;
+
+	dewtprintk(ioc, pr_info(MPT3SAS_FMT "IR RAID_ACTION: turning fast "\
+	    "path on for handle(0x%04x), phys_disk_num (0x%02x)\n", ioc->name,
+	    handle, phys_disk_num));
+
+	init_completion(&ioc->scsih_cmds.done);
+	mpt3sas_base_put_smid_default(ioc, smid);
+	wait_for_completion_timeout(&ioc->scsih_cmds.done, 10*HZ);
+
+	if (!(ioc->scsih_cmds.status & MPT3_CMD_COMPLETE)) {
+		pr_err(MPT3SAS_FMT "%s: timeout\n",
+		    ioc->name, __func__);
+		if (!(ioc->scsih_cmds.status & MPT3_CMD_RESET))
+			issue_reset = 1;
+		rc = -EFAULT;
+		goto out;
+	}
+
+	if (ioc->scsih_cmds.status & MPT3_CMD_REPLY_VALID) {
+
+		mpi_reply = ioc->scsih_cmds.reply;
+		ioc_status = le16_to_cpu(mpi_reply->IOCStatus);
+		if (ioc_status & MPI2_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE)
+			log_info =  le32_to_cpu(mpi_reply->IOCLogInfo);
+		else
+			log_info = 0;
+		ioc_status &= MPI2_IOCSTATUS_MASK;
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+			dewtprintk(ioc, pr_info(MPT3SAS_FMT
+			    "IR RAID_ACTION: failed: ioc_status(0x%04x), "
+			    "loginfo(0x%08x)!!!\n", ioc->name, ioc_status,
+			    log_info));
+			rc = -EFAULT;
+		} else
+			dewtprintk(ioc, pr_info(MPT3SAS_FMT
+			    "IR RAID_ACTION: completed successfully\n",
+			    ioc->name));
+	}
+
+ out:
+	ioc->scsih_cmds.status = MPT3_CMD_NOT_USED;
+	mutex_unlock(&ioc->scsih_cmds.mutex);
+
+	if (issue_reset)
+		mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP,
+		    FORCE_BIG_HAMMER);
+	return rc;
+}
