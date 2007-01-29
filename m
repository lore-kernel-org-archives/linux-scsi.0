From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 6/9] - fusion - serialize target resets in mptsas.c
Date: Mon, 29 Jan 2007 09:46:21 -0700
Message-ID: <20070129164621.GA1911@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:60639 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004AbXA2Qpp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Jan 2007 11:45:45 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

Fusion firmware requires target reset following hotplug removal event,
with purpose to flush target outstanding request in fw. Current implementation
does the target resets from delayed work tasks, that in heavy load
conditions, take too long to be invoked, resulting in command time outs
This patch will issue target reset immediately from ISR context, and will
queue remaining target resets to be issued after the previous one completes.
The delayed work tasks are spawned during the target reset completion.

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>


diff -uarpN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2007-01-28 12:57:29.000000000 -0700
+++ a/drivers/message/fusion/mptbase.h	2007-01-28 12:57:29.000000000 -0700
@@ -994,6 +994,7 @@ typedef struct _MPT_SCSI_HOST {
 	int			  scandv_wait_done;
 	long			  last_queue_full;
 	u16			  tm_iocstatus;
+	struct list_head	  target_reset_list;
 } MPT_SCSI_HOST;
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff -uarpN b/drivers/message/fusion/mptsas.c a/drivers/message/fusion/mptsas.c
--- b/drivers/message/fusion/mptsas.c	2007-01-28 12:57:29.000000000 -0700
+++ a/drivers/message/fusion/mptsas.c	2007-01-28 12:57:29.000000000 -0700
@@ -96,6 +96,12 @@ static int	mptsasMgmtCtx = -1;
 
 static void mptsas_hotplug_work(struct work_struct *work);
 
+struct mptsas_target_reset_event {
+	struct list_head 	list;
+	EVENT_DATA_SAS_DEVICE_STATUS_CHANGE sas_event_data;
+	u8	target_reset_issued;
+};
+
 enum mptsas_hotplug_action {
 	MPTSAS_ADD_DEVICE,
 	MPTSAS_DEL_DEVICE,
@@ -571,22 +577,273 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc
 	mutex_unlock(&ioc->sas_topology_mutex);
 }
 
+/**
+ * csmisas_find_vtarget
+ *
+ * @ioc
+ * @volume_id
+ * @volume_bus
+ *
+ **/
+static VirtTarget *
+mptsas_find_vtarget(MPT_ADAPTER *ioc, u8 channel, u8 id)
+{
+	struct scsi_device 		*sdev;
+	VirtDevice			*vdev;
+	VirtTarget 			*vtarget = NULL;
+
+	shost_for_each_device(sdev, ioc->sh) {
+		if ((vdev = sdev->hostdata) == NULL)
+			continue;
+		if (vdev->vtarget->id == id &&
+		    vdev->vtarget->channel == channel)
+			vtarget = vdev->vtarget;
+	}
+	return vtarget;
+}
+
+/**
+ * mptsas_target_reset
+ *
+ * Issues TARGET_RESET to end device using handshaking method
+ *
+ * @ioc
+ * @channel
+ * @id
+ *
+ * Returns (1) success
+ *         (0) failure
+ *
+ **/
+static int
+mptsas_target_reset(MPT_ADAPTER *ioc, u8 channel, u8 id)
+{
+	MPT_FRAME_HDR	*mf;
+	SCSITaskMgmt_t	*pScsiTm;
+
+	if ((mf = mpt_get_msg_frame(ioc->TaskCtx, ioc)) == NULL) {
+		dfailprintk((MYIOC_s_WARN_FMT "%s, no msg frames @%d!!\n",
+		    ioc->name,__FUNCTION__, __LINE__));
+		return 0;
+	}
+
+	/* Format the Request
+	 */
+	pScsiTm = (SCSITaskMgmt_t *) mf;
+	memset (pScsiTm, 0, sizeof(SCSITaskMgmt_t));
+	pScsiTm->TargetID = id;
+	pScsiTm->Bus = channel;
+	pScsiTm->Function = MPI_FUNCTION_SCSI_TASK_MGMT;
+	pScsiTm->TaskType = MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET;
+	pScsiTm->MsgFlags = MPI_SCSITASKMGMT_MSGFLAGS_LIPRESET_RESET_OPTION;
+
+	DBG_DUMP_TM_REQUEST_FRAME(mf);
+
+	if (mpt_send_handshake_request(ioc->TaskCtx, ioc,
+	    sizeof(SCSITaskMgmt_t), (u32 *)mf, NO_SLEEP)) {
+		mpt_free_msg_frame(ioc, mf);
+		dfailprintk((MYIOC_s_WARN_FMT "%s, tm handshake failed @%d!!\n",
+		    ioc->name,__FUNCTION__, __LINE__));
+		return 0;
+	}
+
+	return 1;
+}
+
+/**
+ * mptsas_target_reset_queue
+ *
+ * Receive request for TARGET_RESET after recieving an firmware
+ * event NOT_RESPONDING_EVENT, then put command in link list
+ * and queue if task_queue already in use.
+ *
+ * @ioc
+ * @sas_event_data
+ *
+ **/
 static void
-mptsas_target_reset(MPT_ADAPTER *ioc, VirtTarget * vtarget)
+mptsas_target_reset_queue(MPT_ADAPTER *ioc,
+    EVENT_DATA_SAS_DEVICE_STATUS_CHANGE *sas_event_data)
 {
-	MPT_SCSI_HOST		*hd = (MPT_SCSI_HOST *)ioc->sh->hostdata;
+	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)ioc->sh->hostdata;
+	VirtTarget *vtarget = NULL;
+	struct mptsas_target_reset_event *target_reset_list;
+	u8		id, channel;
 
-	if (mptscsih_TMHandler(hd,
-	     MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
-	     vtarget->channel, vtarget->id, 0, 0, 5) < 0) {
-		hd->tmPending = 0;
-		hd->tmState = TM_STATE_NONE;
-		printk(MYIOC_s_WARN_FMT
-	       "Error processing TaskMgmt id=%d TARGET_RESET\n",
-			ioc->name, vtarget->id);
+	id = sas_event_data->TargetID;
+	channel = sas_event_data->Bus;
+
+	if (!(vtarget = mptsas_find_vtarget(ioc, channel, id)))
+		return;
+
+	vtarget->deleted = 1; /* block IO */
+
+	target_reset_list = kzalloc(sizeof(*target_reset_list),
+	    GFP_ATOMIC);
+	if (!target_reset_list) {
+		dfailprintk((MYIOC_s_WARN_FMT "%s, failed to allocate mem @%d..!!\n",
+		    ioc->name,__FUNCTION__, __LINE__));
+		return;
+	}
+
+	memcpy(&target_reset_list->sas_event_data, sas_event_data,
+		sizeof(*sas_event_data));
+	list_add_tail(&target_reset_list->list, &hd->target_reset_list);
+
+	if (hd->resetPending)
+		return;
+
+	if (mptsas_target_reset(ioc, channel, id)) {
+		target_reset_list->target_reset_issued = 1;
+		hd->resetPending = 1;
 	}
 }
 
+/**
+ * mptsas_dev_reset_complete
+ *
+ * Completion for TARGET_RESET after NOT_RESPONDING_EVENT,
+ * enable work queue to finish off removing device from upper layers.
+ * then send next TARGET_RESET in the queue.
+ *
+ * @ioc
+ *
+ **/
+static void
+mptsas_dev_reset_complete(MPT_ADAPTER *ioc)
+{
+	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)ioc->sh->hostdata;
+        struct list_head *head = &hd->target_reset_list;
+	struct mptsas_target_reset_event *target_reset_list;
+	struct mptsas_hotplug_event *ev;
+	EVENT_DATA_SAS_DEVICE_STATUS_CHANGE *sas_event_data;
+	u8		id, channel;
+	__le64		sas_address;
+
+	if (list_empty(head))
+		return;
+
+	target_reset_list = list_entry(head->next, struct mptsas_target_reset_event, list);
+
+	sas_event_data = &target_reset_list->sas_event_data;
+	id = sas_event_data->TargetID;
+	channel = sas_event_data->Bus;
+	hd->resetPending = 0;
+
+	/*
+	 * retry target reset
+	 */
+	if (!target_reset_list->target_reset_issued) {
+		if (mptsas_target_reset(ioc, channel, id)) {
+			target_reset_list->target_reset_issued = 1;
+			hd->resetPending = 1;
+		}
+		return;
+	}
+
+	/*
+	 * enable work queue to remove device from upper layers
+	 */
+	list_del(&target_reset_list->list);
+
+	ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
+	if (!ev) {
+		dfailprintk((MYIOC_s_WARN_FMT "%s, failed to allocate mem @%d..!!\n",
+		    ioc->name,__FUNCTION__, __LINE__));
+		return;
+	}
+
+	INIT_WORK(&ev->work, mptsas_hotplug_work);
+	ev->ioc = ioc;
+	ev->handle = le16_to_cpu(sas_event_data->DevHandle);
+	ev->parent_handle =
+	    le16_to_cpu(sas_event_data->ParentDevHandle);
+	ev->channel = channel;
+	ev->id =id;
+	ev->phy_id = sas_event_data->PhyNum;
+	memcpy(&sas_address, &sas_event_data->SASAddress,
+	    sizeof(__le64));
+	ev->sas_address = le64_to_cpu(sas_address);
+	ev->device_info = le32_to_cpu(sas_event_data->DeviceInfo);
+	ev->event_type = MPTSAS_DEL_DEVICE;
+	schedule_work(&ev->work);
+	kfree(target_reset_list);
+
+	/*
+	 * issue target reset to next device in the queue
+	 */
+
+	head = &hd->target_reset_list;
+	if (list_empty(head))
+		return;
+
+	target_reset_list = list_entry(head->next, struct mptsas_target_reset_event,
+	    list);
+
+	sas_event_data = &target_reset_list->sas_event_data;
+	id = sas_event_data->TargetID;
+	channel = sas_event_data->Bus;
+
+	if (mptsas_target_reset(ioc, channel, id)) {
+		target_reset_list->target_reset_issued = 1;
+		hd->resetPending = 1;
+	}
+}
+
+/**
+ * mptsas_taskmgmt_complete
+ *
+ * @ioc
+ * @mf
+ * @mr
+ *
+ **/
+static int
+mptsas_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
+{
+	mptsas_dev_reset_complete(ioc);
+	return mptscsih_taskmgmt_complete(ioc, mf, mr);
+}
+
+/**
+ * mptscsih_ioc_reset
+ *
+ * @ioc
+ * @reset_phase
+ *
+ **/
+static int
+mptsas_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
+{
+	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)ioc->sh->hostdata;
+	struct mptsas_target_reset_event *target_reset_list, *n;
+	int rc;
+
+	rc = mptscsih_ioc_reset(ioc, reset_phase);
+
+	if (ioc->bus_type != SAS)
+		goto out;
+
+	if (reset_phase != MPT_IOC_POST_RESET)
+		goto out;
+
+	if (!hd || !hd->ioc)
+		goto out;
+
+	if (list_empty(&hd->target_reset_list))
+		goto out;
+
+	/* flush the target_reset_list */
+	list_for_each_entry_safe(target_reset_list, n,
+	    &hd->target_reset_list, list) {
+		list_del(&target_reset_list->list);
+		kfree(target_reset_list);
+	}
+
+ out:
+	return rc;
+}
+
 static int
 mptsas_sas_enclosure_pg0(MPT_ADAPTER *ioc, struct mptsas_enclosure *enclosure,
 		u32 form, u32 form_specific)
@@ -1885,8 +2142,6 @@ mptsas_delete_expander_phys(MPT_ADAPTER 
 	struct mptsas_portinfo buffer;
 	struct mptsas_portinfo *port_info, *n, *parent;
 	struct mptsas_phyinfo *phy_info;
-	struct scsi_target * starget;
-	VirtTarget * vtarget;
 	struct sas_port * port;
 	int i;
 	u64	expander_sas_address;
@@ -1904,25 +2159,6 @@ mptsas_delete_expander_phys(MPT_ADAPTER 
 		     MPI_SAS_EXPAND_PGAD_FORM_SHIFT), port_info->handle)) {
 
 			/*
-			 * Issue target reset to all child end devices
-			 * then mark them deleted to prevent further
-			 * IO going to them.
-			 */
-			phy_info = port_info->phy_info;
-			for (i = 0; i < port_info->num_phys; i++, phy_info++) {
-				starget = mptsas_get_starget(phy_info);
-				if (!starget)
-					continue;
-				vtarget = starget->hostdata;
-				if(vtarget->deleted)
-					continue;
-				vtarget->deleted = 1;
-				mptsas_target_reset(ioc, vtarget);
-				sas_port_delete(mptsas_get_port(phy_info));
-				mptsas_port_delete(phy_info->port_details);
-			}
-
-			/*
 			 * Obtain the port_info instance to the parent port
 			 */
 			parent = mptsas_find_portinfo_by_handle(ioc,
@@ -2319,9 +2555,6 @@ mptsas_hotplug_work(struct work_struct *
 				    ev->phys_disk_num;
 			break;
 			}
-
-			vtarget->deleted = 1;
-			mptsas_target_reset(ioc, vtarget);
 		}
 
 		if (phy_info->attached.device_info &
@@ -2474,8 +2707,6 @@ mptsas_hotplug_work(struct work_struct *
 		printk(MYIOC_s_INFO_FMT
 		       "removing raid volume, channel %d, id %d\n",
 		       ioc->name, MPTSAS_RAID_CHANNEL, ev->id);
-		vdevice->vtarget->deleted = 1;
-		mptsas_target_reset(ioc, vdevice->vtarget);
 		vdevice = sdev->hostdata;
 		scsi_remove_device(sdev);
 		scsi_device_put(sdev);
@@ -2509,8 +2740,12 @@ mptsas_send_sas_event(MPT_ADAPTER *ioc,
 		return;
 
 	switch (sas_event_data->ReasonCode) {
-	case MPI_EVENT_SAS_DEV_STAT_RC_ADDED:
 	case MPI_EVENT_SAS_DEV_STAT_RC_NOT_RESPONDING:
+
+		mptsas_target_reset_queue(ioc, sas_event_data);
+		break;
+
+	case MPI_EVENT_SAS_DEV_STAT_RC_ADDED:
 		ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
 		if (!ev) {
 			printk(KERN_WARNING "mptsas: lost hotplug event\n");
@@ -2871,8 +3106,6 @@ mptsas_probe(struct pci_dev *pdev, const
 		sh->sg_tablesize = numSGE;
 	}
 
-	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
-
 	hd = (MPT_SCSI_HOST *) sh->hostdata;
 	hd->ioc = ioc;
 
@@ -2912,15 +3145,17 @@ mptsas_probe(struct pci_dev *pdev, const
 
 	ioc->sas_data.ptClear = mpt_pt_clear;
 
+	init_waitqueue_head(&hd->scandv_waitq);
+	hd->scandv_wait_done = 0;
+	hd->last_queue_full = 0;
+	INIT_LIST_HEAD(&hd->target_reset_list);
+	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
+
 	if (ioc->sas_data.ptClear==1) {
 		mptbase_sas_persist_operation(
 		    ioc, MPI_SAS_OP_CLEAR_ALL_PERSISTENT);
 	}
 
-	init_waitqueue_head(&hd->scandv_waitq);
-	hd->scandv_wait_done = 0;
-	hd->last_queue_full = 0;
-
 	error = scsi_add_host(sh, &ioc->pcidev->dev);
 	if (error) {
 		dprintk((KERN_ERR MYNAM
@@ -2999,7 +3234,7 @@ mptsas_init(void)
 		return -ENODEV;
 
 	mptsasDoneCtx = mpt_register(mptscsih_io_done, MPTSAS_DRIVER);
-	mptsasTaskCtx = mpt_register(mptscsih_taskmgmt_complete, MPTSAS_DRIVER);
+	mptsasTaskCtx = mpt_register(mptsas_taskmgmt_complete, MPTSAS_DRIVER);
 	mptsasInternalCtx =
 		mpt_register(mptscsih_scandv_complete, MPTSAS_DRIVER);
 	mptsasMgmtCtx = mpt_register(mptsas_mgmt_done, MPTSAS_DRIVER);
@@ -3009,7 +3244,7 @@ mptsas_init(void)
 		  ": Registered for IOC event notifications\n"));
 	}
 
-	if (mpt_reset_register(mptsasDoneCtx, mptscsih_ioc_reset) == 0) {
+	if (mpt_reset_register(mptsasDoneCtx, mptsas_ioc_reset) == 0) {
 		dprintk((KERN_INFO MYNAM
 		  ": Registered for IOC reset notifications\n"));
 	}
