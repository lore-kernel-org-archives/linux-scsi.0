From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 5/9] mpt2sas: Target Reset will be issued from Interrupt context.
Date: Mon, 14 Sep 2009 11:04:23 +0530
Message-ID: <20090914053408.GG31450@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og115.obsmtp.com ([64.18.2.217]:42313 "EHLO
	exprod7og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbZINF5R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Sep 2009 01:57:17 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


(1) Added three new functions to handle sending target resest and OP_REMOVE
from interrupt time, they are _scsih_tm_tr_send, _scsih_tm_tr_complete, and
_scsih_sas_control_complete.  This code will create a link list of pending
target resets if there is no more available request in the hipriority
request queue.  The list is stored in ioc->delayed_tr_list.

(2) All callback handler return type is changed from void to u8.
Now _base_interrupt will check for return type of callback handlers to
take decision of message frame is already freed or not.
In genral,
Return 1 meaning mf should be freed from _base_interrupt
       0 means the mf is freed from function.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 4c583ff..a9c7176 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -575,9 +575,10 @@ _base_display_reply_info(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
  * @msix_index: MSIX table index supplied by the OS
  * @reply: reply message frame(lower 32bit addr)
  *
- * Return nothing.
+ * Return 1 meaning mf should be freed from _base_interrupt
+ *        0 means the mf is freed from this function.
  */
-void
+u8
 mpt2sas_base_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
     u32 reply)
 {
@@ -585,10 +586,10 @@ mpt2sas_base_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 
 	mpi_reply = mpt2sas_base_get_reply_virt_addr(ioc, reply);
 	if (mpi_reply && mpi_reply->Function == MPI2_FUNCTION_EVENT_ACK)
-		return;
+		return 1;
 
 	if (ioc->base_cmds.status == MPT2_CMD_NOT_USED)
-		return;
+		return 1;
 
 	ioc->base_cmds.status |= MPT2_CMD_COMPLETE;
 	if (mpi_reply) {
@@ -597,6 +598,7 @@ mpt2sas_base_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 	}
 	ioc->base_cmds.status &= ~MPT2_CMD_PENDING;
 	complete(&ioc->base_cmds.done);
+	return 1;
 }
 
 /**
@@ -605,9 +607,10 @@ mpt2sas_base_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
  * @msix_index: MSIX table index supplied by the OS
  * @reply: reply message frame(lower 32bit addr)
  *
- * Return nothing.
+ * Return 1 meaning mf should be freed from _base_interrupt
+ *        0 means the mf is freed from this function.
  */
-static void
+static u8
 _base_async_event(struct MPT2SAS_ADAPTER *ioc, u8 msix_index, u32 reply)
 {
 	Mpi2EventNotificationReply_t *mpi_reply;
@@ -616,9 +619,9 @@ _base_async_event(struct MPT2SAS_ADAPTER *ioc, u8 msix_index, u32 reply)
 
 	mpi_reply = mpt2sas_base_get_reply_virt_addr(ioc, reply);
 	if (!mpi_reply)
-		return;
+		return 1;
 	if (mpi_reply->Function != MPI2_FUNCTION_EVENT_NOTIFICATION)
-		return;
+		return 1;
 #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
 	_base_display_event_data(ioc, mpi_reply);
 #endif
@@ -647,6 +650,8 @@ _base_async_event(struct MPT2SAS_ADAPTER *ioc, u8 msix_index, u32 reply)
 
 	/* ctl callback handler */
 	mpt2sas_ctl_event_callback(ioc, msix_index, reply);
+
+	return 1;
 }
 
 /**
@@ -745,6 +750,7 @@ _base_interrupt(int irq, void *bus_id)
 	u8 msix_index;
 	struct MPT2SAS_ADAPTER *ioc = bus_id;
 	Mpi2ReplyDescriptorsUnion_t *rpf;
+	u8 rc;
 
 	if (ioc->mask_interrupts)
 		return IRQ_NONE;
@@ -777,12 +783,13 @@ _base_interrupt(int irq, void *bus_id)
 		if (smid)
 			cb_idx = _base_get_cb_idx(ioc, smid);
 		if (smid && cb_idx != 0xFF) {
-			mpt_callbacks[cb_idx](ioc, smid, msix_index,
+			rc = mpt_callbacks[cb_idx](ioc, smid, msix_index,
 			    reply);
 			if (reply)
 				_base_display_reply_info(ioc, smid, msix_index,
 				    reply);
-			mpt2sas_base_free_smid(ioc, smid);
+			if (rc)
+				mpt2sas_base_free_smid(ioc, smid);
 		}
 		if (!smid)
 			_base_async_event(ioc, msix_index, reply);
@@ -3323,10 +3330,18 @@ _base_make_ioc_operational(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 	unsigned long	flags;
 	u32 reply_address;
 	u16 smid;
+	struct _tr_list *delayed_tr, *delayed_tr_next;
 
 	dinitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\n", ioc->name,
 	    __func__));
 
+	/* clean the delayed target reset list */
+	list_for_each_entry_safe(delayed_tr, delayed_tr_next,
+	    &ioc->delayed_tr_list, list) {
+		list_del(&delayed_tr->list);
+		kfree(delayed_tr);
+	}
+
 	/* initialize the scsi lookup free list */
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	INIT_LIST_HEAD(&ioc->free_list);
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 9113262..7f94be9 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -307,6 +307,7 @@ struct _sas_device {
 	u16	slot;
 	u8	hidden_raid_component;
 	u8	responding;
+	u16	state;
 };
 
 /**
@@ -443,6 +444,17 @@ struct request_tracker {
 	struct list_head tracker_list;
 };
 
+/**
+ * struct _tr_list - target reset list
+ * @handle: device handle
+ * @state: state machine
+ */
+struct _tr_list {
+	struct list_head list;
+	u16	handle;
+	u16	state;
+};
+
 typedef void (*MPT_ADD_SGE)(void *paddr, u32 flags_length, dma_addr_t dma_addr);
 
 /**
@@ -617,6 +629,8 @@ struct MPT2SAS_ADAPTER {
 	u8		ctl_cb_idx;
 	u8		base_cb_idx;
 	u8		config_cb_idx;
+	u8		tm_tr_cb_idx;
+	u8		tm_sas_control_cb_idx;
 	struct _internal_cmd base_cmds;
 	struct _internal_cmd transport_cmds;
 	struct _internal_cmd tm_cmds;
@@ -727,6 +741,8 @@ struct MPT2SAS_ADAPTER {
 	struct dma_pool *reply_post_free_dma_pool;
 	u32		reply_post_host_index;
 
+	struct list_head delayed_tr_list;
+
 	/* diag buffer support */
 	u8		*diag_buffer[MPI2_DIAG_BUF_TYPE_COUNT];
 	u32		diag_buffer_sz[MPI2_DIAG_BUF_TYPE_COUNT];
@@ -738,8 +754,8 @@ struct MPT2SAS_ADAPTER {
 	u32		diagnostic_flags[MPI2_DIAG_BUF_TYPE_COUNT];
 };
 
-typedef void (*MPT_CALLBACK)(struct MPT2SAS_ADAPTER *ioc, u16 smid,
-    u8 msix_index, u32 reply);
+typedef u8 (*MPT_CALLBACK)(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
+    u32 reply);
 
 
 /* base shared API */
@@ -757,7 +773,8 @@ int mpt2sas_base_hard_reset_handler(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
 void *mpt2sas_base_get_msg_frame(struct MPT2SAS_ADAPTER *ioc, u16 smid);
 void *mpt2sas_base_get_sense_buffer(struct MPT2SAS_ADAPTER *ioc, u16 smid);
 void mpt2sas_base_build_zero_len_sge(struct MPT2SAS_ADAPTER *ioc, void *paddr);
-dma_addr_t mpt2sas_base_get_sense_buffer_dma(struct MPT2SAS_ADAPTER *ioc, u16 smid);
+dma_addr_t mpt2sas_base_get_sense_buffer_dma(struct MPT2SAS_ADAPTER *ioc,
+    u16 smid);
 
 /* hi-priority queue */
 u16 mpt2sas_base_get_smid_hpr(struct MPT2SAS_ADAPTER *ioc, u8 cb_idx);
@@ -776,7 +793,7 @@ void mpt2sas_base_initialize_callback_handler(void);
 u8 mpt2sas_base_register_callback_handler(MPT_CALLBACK cb_func);
 void mpt2sas_base_release_callback_handler(u8 cb_idx);
 
-void mpt2sas_base_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
+u8 mpt2sas_base_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
     u32 reply);
 void *mpt2sas_base_get_reply_virt_addr(struct MPT2SAS_ADAPTER *ioc, u32 phys_addr);
 
@@ -791,6 +808,8 @@ int mpt2sas_base_scsi_enclosure_processor(struct MPT2SAS_ADAPTER *ioc,
 void mpt2sas_base_validate_event_type(struct MPT2SAS_ADAPTER *ioc, u32 *event_type);
 
 /* scsih shared API */
+u8 mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
+    u32 reply);
 void mpt2sas_scsih_issue_tm(struct MPT2SAS_ADAPTER *ioc, u16 handle, uint lun,
     u8 type, u16 smid_task, ulong timeout);
 void mpt2sas_scsih_set_tm_flag(struct MPT2SAS_ADAPTER *ioc, u16 handle);
@@ -802,12 +821,10 @@ struct _sas_node *mpt2sas_scsih_expander_find_by_sas_address(struct MPT2SAS_ADAP
 struct _sas_device *mpt2sas_scsih_sas_device_find_by_sas_address(
     struct MPT2SAS_ADAPTER *ioc, u64 sas_address);
 
-void mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
-    u32 reply);
 void mpt2sas_scsih_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase);
 
 /* config shared API */
-void mpt2sas_config_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
+u8 mpt2sas_config_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
     u32 reply);
 int mpt2sas_config_get_number_hba_phys(struct MPT2SAS_ADAPTER *ioc, u8 *num_phys);
 int mpt2sas_config_get_manufacturing_pg0(struct MPT2SAS_ADAPTER *ioc,
@@ -861,17 +878,17 @@ extern struct device_attribute *mpt2sas_host_attrs[];
 extern struct device_attribute *mpt2sas_dev_attrs[];
 void mpt2sas_ctl_init(void);
 void mpt2sas_ctl_exit(void);
-void mpt2sas_ctl_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
+u8 mpt2sas_ctl_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
     u32 reply);
 void mpt2sas_ctl_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase);
-void mpt2sas_ctl_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
+u8 mpt2sas_ctl_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
     u32 reply);
 void mpt2sas_ctl_add_to_event_log(struct MPT2SAS_ADAPTER *ioc,
     Mpi2EventNotificationReply_t *mpi_reply);
 
 /* transport shared API */
-void mpt2sas_transport_done(struct MPT2SAS_ADAPTER *ioc, u16 smid,
-    u8 msix_index, u32 reply);
+u8 mpt2sas_transport_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
+    u32 reply);
 struct _sas_port *mpt2sas_transport_port_add(struct MPT2SAS_ADAPTER *ioc,
     u16 handle, u16 parent_handle);
 void mpt2sas_transport_port_remove(struct MPT2SAS_ADAPTER *ioc, u64 sas_address,
@@ -885,6 +902,8 @@ void mpt2sas_transport_update_links(struct MPT2SAS_ADAPTER *ioc, u16 handle,
 extern struct sas_function_template mpt2sas_transport_functions;
 extern struct scsi_transport_template *mpt2sas_transport_template;
 extern int scsi_internal_device_block(struct scsi_device *sdev);
+extern u8 mpt2sas_stm_zero_smid_handler(struct MPT2SAS_ADAPTER *ioc,
+    u8 msix_index, u32 reply);
 extern int scsi_internal_device_unblock(struct scsi_device *sdev);
 
 #endif /* MPT2SAS_BASE_H_INCLUDED */
diff --git a/drivers/scsi/mpt2sas/mpt2sas_config.c b/drivers/scsi/mpt2sas/mpt2sas_config.c
index d79a4dd..594a389 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_config.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_config.c
@@ -233,18 +233,19 @@ _config_free_config_dma_memory(struct MPT2SAS_ADAPTER *ioc,
  *
  * The callback handler when using _config_request.
  *
- * Return nothing.
+ * Return 1 meaning mf should be freed from _base_interrupt
+ *        0 means the mf is freed from this function.
  */
-void
+u8
 mpt2sas_config_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
     u32 reply)
 {
 	MPI2DefaultReply_t *mpi_reply;
 
 	if (ioc->config_cmds.status == MPT2_CMD_NOT_USED)
-		return;
+		return 1;
 	if (ioc->config_cmds.smid != smid)
-		return;
+		return 1;
 	ioc->config_cmds.status |= MPT2_CMD_COMPLETE;
 	mpi_reply =  mpt2sas_base_get_reply_virt_addr(ioc, reply);
 	if (mpi_reply) {
@@ -258,6 +259,7 @@ mpt2sas_config_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 #endif
 	ioc->config_cmds.smid = USHORT_MAX;
 	complete(&ioc->config_cmds.done);
+	return 1;
 }
 
 /**
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index 466e2f4..33463ac 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -225,18 +225,19 @@ _ctl_display_some_debug(struct MPT2SAS_ADAPTER *ioc, u16 smid,
  *
  * The callback handler when using ioc->ctl_cb_idx.
  *
- * Return nothing.
+ * Return 1 meaning mf should be freed from _base_interrupt
+ *        0 means the mf is freed from this function.
  */
-void
+u8
 mpt2sas_ctl_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 	u32 reply)
 {
 	MPI2DefaultReply_t *mpi_reply;
 
 	if (ioc->ctl_cmds.status == MPT2_CMD_NOT_USED)
-		return;
+		return 1;
 	if (ioc->ctl_cmds.smid != smid)
-		return;
+		return 1;
 	ioc->ctl_cmds.status |= MPT2_CMD_COMPLETE;
 	mpi_reply = mpt2sas_base_get_reply_virt_addr(ioc, reply);
 	if (mpi_reply) {
@@ -248,6 +249,7 @@ mpt2sas_ctl_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 #endif
 	ioc->ctl_cmds.status &= ~MPT2_CMD_PENDING;
 	complete(&ioc->ctl_cmds.done);
+	return 1;
 }
 
 /**
@@ -336,9 +338,10 @@ mpt2sas_ctl_add_to_event_log(struct MPT2SAS_ADAPTER *ioc,
  * This function merely adds a new work task into ioc->firmware_event_thread.
  * The tasks are worked from _firmware_event_work in user context.
  *
- * Return nothing.
+ * Return 1 meaning mf should be freed from _base_interrupt
+ *        0 means the mf is freed from this function.
  */
-void
+u8
 mpt2sas_ctl_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
 	u32 reply)
 {
@@ -346,6 +349,7 @@ mpt2sas_ctl_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
 
 	mpi_reply = mpt2sas_base_get_reply_virt_addr(ioc, reply);
 	mpt2sas_ctl_add_to_event_log(ioc, mpi_reply);
+	return 1;
 }
 
 /**
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 0a489c6..5ea6431 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -79,6 +79,9 @@ static u8 transport_cb_idx = -1;
 static u8 config_cb_idx = -1;
 static int mpt_ids;
 
+static u8 tm_tr_cb_idx = -1 ;
+static u8 tm_sas_control_cb_idx = -1;
+
 /* command line options */
 static u32 logging_level;
 MODULE_PARM_DESC(logging_level, " bits for enabling additional logging info "
@@ -1641,17 +1644,18 @@ _scsih_response_code(struct MPT2SAS_ADAPTER *ioc, u8 response_code)
  *
  * The callback handler when using scsih_issue_tm.
  *
- * Return nothing.
+ * Return 1 meaning mf should be freed from _base_interrupt
+ *        0 means the mf is freed from this function.
  */
-static void
+static u8
 _scsih_tm_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 {
 	MPI2DefaultReply_t *mpi_reply;
 
 	if (ioc->tm_cmds.status == MPT2_CMD_NOT_USED)
-		return;
+		return 1;
 	if (ioc->tm_cmds.smid != smid)
-		return;
+		return 1;
 	ioc->tm_cmds.status |= MPT2_CMD_COMPLETE;
 	mpi_reply =  mpt2sas_base_get_reply_virt_addr(ioc, reply);
 	if (mpi_reply) {
@@ -1660,6 +1664,7 @@ _scsih_tm_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	}
 	ioc->tm_cmds.status &= ~MPT2_CMD_PENDING;
 	complete(&ioc->tm_cmds.done);
+	return 1;
 }
 
 /**
@@ -2312,6 +2317,231 @@ _scsih_block_io_to_children_attached_directly(struct MPT2SAS_ADAPTER *ioc,
 }
 
 /**
+ * _scsih_tm_tr_send - send task management request
+ * @ioc: per adapter object
+ * @handle: device handle
+ * Context: interrupt time.
+ *
+ * This code is to initiate the device removal handshake protocal
+ * with controller firmware.  This function will issue target reset
+ * using high priority request queue.  It will send a sas iounit
+ * controll request (MPI2_SAS_OP_REMOVE_DEVICE) from this completion.
+ *
+ * This is designed to send muliple task management request at the same
+ * time to the fifo. If the fifo is full, we will append the request,
+ * and process it in a future completion.
+ */
+static void
+_scsih_tm_tr_send(struct MPT2SAS_ADAPTER *ioc, u16 handle)
+{
+	Mpi2SCSITaskManagementRequest_t *mpi_request;
+	struct MPT2SAS_TARGET *sas_target_priv_data;
+	u16 smid;
+	struct _sas_device *sas_device;
+	unsigned long flags;
+	struct _tr_list *delayed_tr;
+
+	if (ioc->shost_recovery) {
+		printk(MPT2SAS_INFO_FMT "%s: host reset in progress!\n",
+		    __func__, ioc->name);
+		return;
+	}
+
+	spin_lock_irqsave(&ioc->sas_device_lock, flags);
+	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
+	if (!sas_device) {
+		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+		printk(MPT2SAS_ERR_FMT "%s: failed finding sas_device\n",
+		    ioc->name, __func__);
+		return;
+	}
+	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+
+	/* skip is hidden raid component */
+	if (sas_device->hidden_raid_component)
+		return;
+
+	smid = mpt2sas_base_get_smid_hpr(ioc, ioc->tm_tr_cb_idx);
+	if (!smid) {
+		delayed_tr = kzalloc(sizeof(*delayed_tr), GFP_ATOMIC);
+		if (!delayed_tr)
+			return;
+		INIT_LIST_HEAD(&delayed_tr->list);
+		delayed_tr->handle = handle;
+		delayed_tr->state = MPT2SAS_REQ_SAS_CNTRL;
+		list_add_tail(&delayed_tr->list,
+		    &ioc->delayed_tr_list);
+		if (sas_device->starget)
+			dewtprintk(ioc, starget_printk(KERN_INFO,
+			    sas_device->starget, "DELAYED:tr:handle(0x%04x), "
+			    "(open)\n", sas_device->handle));
+		return;
+	}
+
+	if (sas_device->starget && sas_device->starget->hostdata) {
+		sas_target_priv_data = sas_device->starget->hostdata;
+		sas_target_priv_data->tm_busy = 1;
+		dewtprintk(ioc, starget_printk(KERN_INFO, sas_device->starget,
+		    "tr:handle(0x%04x), (open)\n", sas_device->handle));
+	}
+
+	mpi_request = mpt2sas_base_get_msg_frame(ioc, smid);
+	memset(mpi_request, 0, sizeof(Mpi2SCSITaskManagementRequest_t));
+	mpi_request->Function = MPI2_FUNCTION_SCSI_TASK_MGMT;
+	mpi_request->DevHandle = cpu_to_le16(handle);
+	mpi_request->TaskType = MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET;
+	sas_device->state |= MPTSAS_STATE_TR_SEND;
+	sas_device->state |= MPT2SAS_REQ_SAS_CNTRL;
+	mpt2sas_base_put_smid_hi_priority(ioc, smid);
+}
+
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
+ * This is the sas iounit controll completion routine.
+ * This code is part of the code to initiate the device removal
+ * handshake protocal with controller firmware.
+ *
+ * Return 1 meaning mf should be freed from _base_interrupt
+ *        0 means the mf is freed from this function.
+ */
+static u8
+_scsih_sas_control_complete(struct MPT2SAS_ADAPTER *ioc, u16 smid,
+    u8 msix_index, u32 reply)
+{
+	unsigned long flags;
+	u16 handle;
+	struct _sas_device *sas_device;
+	Mpi2SasIoUnitControlReply_t *mpi_reply =
+	    mpt2sas_base_get_reply_virt_addr(ioc, reply);
+
+	handle = le16_to_cpu(mpi_reply->DevHandle);
+
+	spin_lock_irqsave(&ioc->sas_device_lock, flags);
+	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
+	if (!sas_device) {
+		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+		printk(MPT2SAS_ERR_FMT "%s: failed finding sas_device\n",
+		    ioc->name, __func__);
+		return 1;
+	}
+	sas_device->state |= MPTSAS_STATE_CNTRL_COMPLETE;
+	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+
+	if (sas_device->starget)
+		dewtprintk(ioc, starget_printk(KERN_INFO, sas_device->starget,
+		    "sc_complete:handle(0x%04x), "
+		    "ioc_status(0x%04x), loginfo(0x%08x)\n",
+		    handle, le16_to_cpu(mpi_reply->IOCStatus),
+		    le32_to_cpu(mpi_reply->IOCLogInfo)));
+	return 1;
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
+ * handshake protocal with controller firmware.
+ * It will send a sas iounit controll request (MPI2_SAS_OP_REMOVE_DEVICE)
+ *
+ * Return 1 meaning mf should be freed from _base_interrupt
+ *        0 means the mf is freed from this function.
+ */
+static u8
+_scsih_tm_tr_complete(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
+    u32 reply)
+{
+	unsigned long flags;
+	u16 handle;
+	struct _sas_device *sas_device;
+	Mpi2SCSITaskManagementReply_t *mpi_reply =
+	    mpt2sas_base_get_reply_virt_addr(ioc, reply);
+	Mpi2SasIoUnitControlRequest_t *mpi_request;
+	u16 smid_sas_ctrl;
+	struct MPT2SAS_TARGET *sas_target_priv_data;
+	struct _tr_list *delayed_tr;
+	u8 rc;
+
+	handle = le16_to_cpu(mpi_reply->DevHandle);
+	spin_lock_irqsave(&ioc->sas_device_lock, flags);
+	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
+	if (!sas_device) {
+		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+		printk(MPT2SAS_ERR_FMT "%s: failed finding sas_device\n",
+		    ioc->name, __func__);
+		return 1;
+	}
+	sas_device->state |= MPTSAS_STATE_TR_COMPLETE;
+	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+
+	if (sas_device->starget)
+		dewtprintk(ioc, starget_printk(KERN_INFO, sas_device->starget,
+		    "tr_complete:handle(0x%04x), (%s) ioc_status(0x%04x), "
+		    "loginfo(0x%08x), completed(%d)\n",
+		    sas_device->handle, (sas_device->state &
+		    MPT2SAS_REQ_SAS_CNTRL) ? "open" : "active",
+		    le16_to_cpu(mpi_reply->IOCStatus),
+		    le32_to_cpu(mpi_reply->IOCLogInfo),
+		    le32_to_cpu(mpi_reply->TerminationCount)));
+
+	if (sas_device->starget && sas_device->starget->hostdata) {
+		sas_target_priv_data = sas_device->starget->hostdata;
+		sas_target_priv_data->tm_busy = 0;
+	}
+
+	if (!list_empty(&ioc->delayed_tr_list)) {
+		delayed_tr = list_entry(ioc->delayed_tr_list.next,
+		    struct _tr_list, list);
+		mpt2sas_base_free_smid(ioc, smid);
+		if (delayed_tr->state & MPT2SAS_REQ_SAS_CNTRL)
+			_scsih_tm_tr_send(ioc, delayed_tr->handle);
+		list_del(&delayed_tr->list);
+		kfree(delayed_tr);
+		rc = 0; /* tells base_interrupt not to free mf */
+	} else
+		rc = 1;
+
+
+	if (!(sas_device->state & MPT2SAS_REQ_SAS_CNTRL))
+		return rc;
+
+	if (ioc->shost_recovery) {
+		printk(MPT2SAS_INFO_FMT "%s: host reset in progress!\n",
+		    __func__, ioc->name);
+		return rc;
+	}
+
+	smid_sas_ctrl = mpt2sas_base_get_smid(ioc, ioc->tm_sas_control_cb_idx);
+	if (!smid_sas_ctrl) {
+		printk(MPT2SAS_ERR_FMT "%s: failed obtaining a smid\n",
+		    ioc->name, __func__);
+		return rc;
+	}
+
+	mpi_request = mpt2sas_base_get_msg_frame(ioc, smid_sas_ctrl);
+	memset(mpi_request, 0, sizeof(Mpi2SasIoUnitControlRequest_t));
+	mpi_request->Function = MPI2_FUNCTION_SAS_IO_UNIT_CONTROL;
+	mpi_request->Operation = MPI2_SAS_OP_REMOVE_DEVICE;
+	mpi_request->DevHandle = mpi_reply->DevHandle;
+	sas_device->state |= MPTSAS_STATE_CNTRL_SEND;
+	mpt2sas_base_put_smid_default(ioc, smid_sas_ctrl);
+	return rc;
+}
+
+/**
  * _scsih_check_topo_delete_events - sanity check on topo events
  * @ioc: per adapter object
  * @event_data: the event data payload
@@ -2333,6 +2563,21 @@ _scsih_check_topo_delete_events(struct MPT2SAS_ADAPTER *ioc,
 	u16 expander_handle;
 	struct _sas_node *sas_expander;
 	unsigned long flags;
+	int i, reason_code;
+	u16 handle;
+
+	for (i = 0 ; i < event_data->NumEntries; i++) {
+		if (event_data->PHY[i].PhyStatus &
+		    MPI2_EVENT_SAS_TOPO_PHYSTATUS_VACANT)
+			continue;
+		handle = le16_to_cpu(event_data->PHY[i].AttachedDevHandle);
+		if (!handle)
+			continue;
+		reason_code = event_data->PHY[i].PhyStatus &
+		    MPI2_EVENT_SAS_TOPO_RC_MASK;
+		if (reason_code == MPI2_EVENT_SAS_TOPO_RC_TARG_NOT_RESPONDING)
+			_scsih_tm_tr_send(ioc, handle);
+	}
 
 	expander_handle = le16_to_cpu(event_data->ExpanderDevHandle);
 	if (expander_handle < ioc->sas_hba.num_phys) {
@@ -2915,11 +3160,12 @@ _scsih_smart_predicted_fault(struct MPT2SAS_ADAPTER *ioc, u16 handle)
  * @msix_index: MSIX table index supplied by the OS
  * @reply: reply message frame(lower 32bit addr)
  *
- * Callback handler when using scsih_qcmd.
+ * Callback handler when using _scsih_qcmd.
  *
- * Return nothing.
+ * Return 1 meaning mf should be freed from _base_interrupt
+ *        0 means the mf is freed from this function.
  */
-static void
+static u8
 _scsih_io_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 {
 	Mpi2SCSIIORequest_t *mpi_request;
@@ -2936,7 +3182,7 @@ _scsih_io_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	mpi_reply = mpt2sas_base_get_reply_virt_addr(ioc, reply);
 	scmd = _scsih_scsi_lookup_get(ioc, smid);
 	if (scmd == NULL)
-		return;
+		return 1;
 
 	mpi_request = mpt2sas_base_get_msg_frame(ioc, smid);
 
@@ -3092,6 +3338,7 @@ _scsih_io_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
  out:
 	scsi_dma_unmap(scmd);
 	scmd->scsi_done(scmd);
+	return 1;
 }
 
 /**
@@ -3623,6 +3870,12 @@ _scsih_remove_device(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 	if (ioc->remove_host)
 		goto out;
 
+	if ((sas_device->state & MPTSAS_STATE_TR_COMPLETE)) {
+		dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "\tskip "
+		   "target_reset handle(0x%04x)\n", ioc->name, handle));
+		goto skip_tr;
+	}
+
 	/* Target Reset to flush out all the outstanding IO */
 	device_handle = (sas_device->hidden_raid_component) ?
 	    sas_device->volume_handle : handle;
@@ -3639,6 +3892,13 @@ _scsih_remove_device(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 		if (ioc->shost_recovery)
 			goto out;
 	}
+ skip_tr:
+
+	if ((sas_device->state & MPTSAS_STATE_CNTRL_COMPLETE)) {
+		dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "\tskip "
+		   "sas_cntrl handle(0x%04x)\n", ioc->name, handle));
+		goto out;
+	}
 
 	/* SAS_IO_UNIT_CNTR - send REMOVE_DEVICE */
 	dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "sas_iounit: handle"
@@ -4829,6 +5089,10 @@ _scsih_mark_responding_sas_device(struct MPT2SAS_ADAPTER *ioc, u64 sas_address,
 		if (sas_device->sas_address == sas_address &&
 		    sas_device->slot == slot && sas_device->starget) {
 			sas_device->responding = 1;
+			sas_device->state = 0;
+			starget = sas_device->starget;
+			sas_target_priv_data = starget->hostdata;
+			sas_target_priv_data->tm_busy = 0;
 			starget_printk(KERN_INFO, sas_device->starget,
 			    "handle(0x%04x), sas_addr(0x%016llx), enclosure "
 			    "logical id(0x%016llx), slot(%d)\n", handle,
@@ -4841,8 +5105,6 @@ _scsih_mark_responding_sas_device(struct MPT2SAS_ADAPTER *ioc, u64 sas_address,
 			printk(KERN_INFO "\thandle changed from(0x%04x)!!!\n",
 			    sas_device->handle);
 			sas_device->handle = handle;
-			starget = sas_device->starget;
-			sas_target_priv_data = starget->hostdata;
 			sas_target_priv_data->handle = handle;
 			goto out;
 		}
@@ -5235,9 +5497,10 @@ _firmware_event_work(struct work_struct *work)
  * This function merely adds a new work task into ioc->firmware_event_thread.
  * The tasks are worked from _firmware_event_work in user context.
  *
- * Return nothing.
+ * Return 1 meaning mf should be freed from _base_interrupt
+ *        0 means the mf is freed from this function.
  */
-void
+u8
 mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
 	u32 reply)
 {
@@ -5250,11 +5513,11 @@ mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
 	spin_lock_irqsave(&ioc->fw_event_lock, flags);
 	if (ioc->fw_events_off || ioc->remove_host) {
 		spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
-		return;
+		return 1;
 	}
 	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
 
-	mpi_reply =  mpt2sas_base_get_reply_virt_addr(ioc, reply);
+	mpi_reply = mpt2sas_base_get_reply_virt_addr(ioc, reply);
 	event = le16_to_cpu(mpi_reply->Event);
 
 	switch (event) {
@@ -5268,7 +5531,7 @@ mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
 		if (baen_data->Primitive !=
 		    MPI2_EVENT_PRIMITIVE_ASYNCHRONOUS_EVENT ||
 		    ioc->broadcast_aen_busy)
-			return;
+			return 1;
 		ioc->broadcast_aen_busy = 1;
 		break;
 	}
@@ -5290,14 +5553,14 @@ mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
 		break;
 
 	default: /* ignore the rest */
-		return;
+		return 1;
 	}
 
 	fw_event = kzalloc(sizeof(struct fw_event_work), GFP_ATOMIC);
 	if (!fw_event) {
 		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
-		return;
+		return 1;
 	}
 	fw_event->event_data =
 	    kzalloc(mpi_reply->EventDataLength*4, GFP_ATOMIC);
@@ -5305,7 +5568,7 @@ mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
 		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
 		kfree(fw_event);
-		return;
+		return 1;
 	}
 
 	memcpy(fw_event->event_data, mpi_reply->EventData,
@@ -5315,6 +5578,7 @@ mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
 	fw_event->VP_ID = mpi_reply->VP_ID;
 	fw_event->event = event;
 	_scsih_fw_event_add(ioc, fw_event);
+	return 1;
 }
 
 /* shost template */
@@ -5574,7 +5838,7 @@ _scsih_probe_raid(struct MPT2SAS_ADAPTER *ioc)
 }
 
 /**
- * _scsih_probe_sas - reporting raid volumes to sas transport
+ * _scsih_probe_sas - reporting sas devices to sas transport
  * @ioc: per adapter object
  *
  * Called during initial loading of the driver.
@@ -5671,6 +5935,8 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ioc->base_cb_idx = base_cb_idx;
 	ioc->transport_cb_idx = transport_cb_idx;
 	ioc->config_cb_idx = config_cb_idx;
+	ioc->tm_tr_cb_idx = tm_tr_cb_idx;
+	ioc->tm_sas_control_cb_idx = tm_sas_control_cb_idx;
 	ioc->logging_level = logging_level;
 	/* misc semaphores and spin locks */
 	spin_lock_init(&ioc->ioc_reset_in_progress_lock);
@@ -5686,6 +5952,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_LIST_HEAD(&ioc->fw_event_list);
 	INIT_LIST_HEAD(&ioc->raid_device_list);
 	INIT_LIST_HEAD(&ioc->sas_hba.sas_port_list);
+	INIT_LIST_HEAD(&ioc->delayed_tr_list);
 
 	/* init shost parameters */
 	shost->max_cmd_len = 16;
@@ -5702,6 +5969,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	scsi_host_set_prot(shost, SHOST_DIF_TYPE1_PROTECTION
 	    | SHOST_DIF_TYPE3_PROTECTION);
+	scsi_host_set_guard(shost, SHOST_DIX_GUARD_CRC);
 
 	/* event thread */
 	snprintf(ioc->firmware_event_name, sizeof(ioc->firmware_event_name),
@@ -5851,6 +6119,11 @@ _scsih_init(void)
 	/* ctl module callback handler */
 	ctl_cb_idx = mpt2sas_base_register_callback_handler(mpt2sas_ctl_done);
 
+	tm_tr_cb_idx = mpt2sas_base_register_callback_handler(
+	    _scsih_tm_tr_complete);
+	tm_sas_control_cb_idx = mpt2sas_base_register_callback_handler(
+	    _scsih_sas_control_complete);
+
 	mpt2sas_ctl_init();
 
 	error = pci_register_driver(&scsih_driver);
@@ -5881,6 +6154,9 @@ _scsih_exit(void)
 	mpt2sas_base_release_callback_handler(config_cb_idx);
 	mpt2sas_base_release_callback_handler(ctl_cb_idx);
 
+	mpt2sas_base_release_callback_handler(tm_tr_cb_idx);
+	mpt2sas_base_release_callback_handler(tm_sas_control_cb_idx);
+
 	mpt2sas_ctl_exit();
 }
 
diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index 4b7201a..8bc57e3 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -218,9 +218,10 @@ _transport_set_identify(struct MPT2SAS_ADAPTER *ioc, u16 handle,
  * Callback handler when sending internal generated transport cmds.
  * The callback index passed is `ioc->transport_cb_idx`
  *
- * Return nothing.
+ * Return 1 meaning mf should be freed from _base_interrupt
+ *        0 means the mf is freed from this function.
  */
-void
+u8
 mpt2sas_transport_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
     u32 reply)
 {
@@ -228,9 +229,9 @@ mpt2sas_transport_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 
 	mpi_reply =  mpt2sas_base_get_reply_virt_addr(ioc, reply);
 	if (ioc->transport_cmds.status == MPT2_CMD_NOT_USED)
-		return;
+		return 1;
 	if (ioc->transport_cmds.smid != smid)
-		return;
+		return 1;
 	ioc->transport_cmds.status |= MPT2_CMD_COMPLETE;
 	if (mpi_reply) {
 		memcpy(ioc->transport_cmds.reply, mpi_reply,
@@ -239,6 +240,7 @@ mpt2sas_transport_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 	}
 	ioc->transport_cmds.status &= ~MPT2_CMD_PENDING;
 	complete(&ioc->transport_cmds.done);
+	return 1;
 }
 
 /* report manufacture request structure */
