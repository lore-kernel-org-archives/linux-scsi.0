From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 09/12] be2iscsi: Enable async mode for mcc rings
Date: Tue, 5 Jan 2010 05:10:46 +0530
Message-ID: <20100104234034.GA16857@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:15182 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753968Ab0ADXk0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2010 18:40:26 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

	This patches enables async mode for mcc rings so that
multiple requests can be queued.

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be.h       |   16 ++++-
 drivers/scsi/be2iscsi/be_cmds.c  |   82 +++++++++++++++++++++---
 drivers/scsi/be2iscsi/be_cmds.h  |   12 +++-
 drivers/scsi/be2iscsi/be_iscsi.c |  100 ++++++++++++++++++++++++++----
 drivers/scsi/be2iscsi/be_main.c  |   83 ++++++++++++++++++++++---
 drivers/scsi/be2iscsi/be_main.h  |    2 +
 drivers/scsi/be2iscsi/be_mgmt.c  |  128 ++++++++++++++++++++-----------------
 drivers/scsi/be2iscsi/be_mgmt.h  |    3 -
 8 files changed, 330 insertions(+), 96 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be.h b/drivers/scsi/be2iscsi/be.h
index a93a504..3861cf4 100644
--- a/drivers/scsi/be2iscsi/be.h
+++ b/drivers/scsi/be2iscsi/be.h
@@ -24,6 +24,7 @@
 #define FW_VER_LEN	32
 #define MCC_Q_LEN	128
 #define MCC_CQ_LEN	256
+#define MAX_MCC_CMD	16
 
 struct be_dma_mem {
 	void *va;
@@ -57,6 +58,11 @@ static inline void *queue_head_node(struct be_queue_info *q)
 	return q->dma_mem.va + q->head * q->entry_size;
 }
 
+static inline void *queue_get_wrb(struct be_queue_info *q, unsigned int wrb_num)
+{
+	return q->dma_mem.va + wrb_num * q->entry_size;
+}
+
 static inline void *queue_tail_node(struct be_queue_info *q)
 {
 	return q->dma_mem.va + q->tail * q->entry_size;
@@ -104,15 +110,19 @@ struct be_ctrl_info {
 	spinlock_t mcc_lock;	/* For serializing mcc cmds to BE card */
 	spinlock_t mcc_cq_lock;
 
-	/* MCC Async callback */
-	void (*async_cb) (void *adapter, bool link_up);
-	void *adapter_ctxt;
+	wait_queue_head_t mcc_wait[MAX_MCC_CMD + 1];
+	unsigned int mcc_tag[MAX_MCC_CMD];
+	unsigned int mcc_numtag[MAX_MCC_CMD + 1];
+	unsigned short mcc_alloc_index;
+	unsigned short mcc_free_index;
+	unsigned int mcc_tag_available;
 };
 
 #include "be_cmds.h"
 
 #define PAGE_SHIFT_4K 12
 #define PAGE_SIZE_4K (1 << PAGE_SHIFT_4K)
+#define mcc_timeout		120000 /* 5s timeout */
 
 /* Returns number of pages spanned by the data starting at the given addr */
 #define PAGES_4K_SPANNED(_address, size) 				\
diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index f008708..d4a0d1d 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -19,7 +19,7 @@
 #include "be_mgmt.h"
 #include "be_main.h"
 
-static void be_mcc_notify(struct beiscsi_hba *phba)
+void be_mcc_notify(struct beiscsi_hba *phba)
 {
 	struct be_queue_info *mccq = &phba->ctrl.mcc_obj.q;
 	u32 val = 0;
@@ -29,6 +29,52 @@ static void be_mcc_notify(struct beiscsi_hba *phba)
 	iowrite32(val, phba->db_va + DB_MCCQ_OFFSET);
 }
 
+unsigned int alloc_mcc_tag(struct beiscsi_hba *phba)
+{
+	unsigned int tag = 0;
+	unsigned int num = 0;
+
+mcc_tag_rdy:
+	if (phba->ctrl.mcc_tag_available) {
+		tag = phba->ctrl.mcc_tag[phba->ctrl.mcc_alloc_index];
+		phba->ctrl.mcc_tag[phba->ctrl.mcc_alloc_index] = 0;
+		phba->ctrl.mcc_numtag[tag] = 0;
+	} else {
+		udelay(100);
+		num++;
+		if (num < mcc_timeout)
+			goto mcc_tag_rdy;
+	}
+	if (tag) {
+		phba->ctrl.mcc_tag_available--;
+		if (phba->ctrl.mcc_alloc_index == (MAX_MCC_CMD - 1))
+			phba->ctrl.mcc_alloc_index = 0;
+		else
+			phba->ctrl.mcc_alloc_index++;
+	}
+	return tag;
+}
+
+void free_mcc_tag(struct be_ctrl_info *ctrl, unsigned int tag)
+{
+	spin_lock(&ctrl->mbox_lock);
+	tag = tag & 0x000000FF;
+	ctrl->mcc_tag[ctrl->mcc_free_index] = tag;
+	if (ctrl->mcc_free_index == (MAX_MCC_CMD - 1))
+		ctrl->mcc_free_index = 0;
+	else
+		ctrl->mcc_free_index++;
+	ctrl->mcc_tag_available++;
+	spin_unlock(&ctrl->mbox_lock);
+}
+
+bool is_link_state_evt(u32 trailer)
+{
+	return (((trailer >> ASYNC_TRAILER_EVENT_CODE_SHIFT) &
+		  ASYNC_TRAILER_EVENT_CODE_MASK) ==
+		  ASYNC_EVENT_CODE_LINK_STATE);
+}
+
 static inline bool be_mcc_compl_is_new(struct be_mcc_compl *compl)
 {
 	if (compl->flags != 0) {
@@ -64,12 +110,30 @@ static int be_mcc_compl_process(struct be_ctrl_info *ctrl,
 	return 0;
 }
 
-
-static inline bool is_link_state_evt(u32 trailer)
+int be_mcc_compl_process_isr(struct be_ctrl_info *ctrl,
+				    struct be_mcc_compl *compl)
 {
-	return (((trailer >> ASYNC_TRAILER_EVENT_CODE_SHIFT) &
-		  ASYNC_TRAILER_EVENT_CODE_MASK) ==
-		  ASYNC_EVENT_CODE_LINK_STATE);
+	u16 compl_status, extd_status;
+	unsigned short tag;
+
+	be_dws_le_to_cpu(compl, 4);
+
+	compl_status = (compl->status >> CQE_STATUS_COMPL_SHIFT) &
+					CQE_STATUS_COMPL_MASK;
+	/* The ctrl.mcc_numtag[tag] is filled with
+	 * [31] = valid, [30:24] = Rsvd, [23:16] = wrb, [15:8] = extd_status,
+	 * [7:0] = compl_status
+	 */
+	tag = (compl->tag0 & 0x000000FF);
+	extd_status = (compl->status >> CQE_STATUS_EXTD_SHIFT) &
+					CQE_STATUS_EXTD_MASK;
+
+	ctrl->mcc_numtag[tag]  = 0x80000000;
+	ctrl->mcc_numtag[tag] |= (compl->tag0 & 0x00FF0000);
+	ctrl->mcc_numtag[tag] |= (extd_status & 0x000000FF) << 8;
+	ctrl->mcc_numtag[tag] |= (compl_status & 0x000000FF);
+	wake_up_interruptible(&ctrl->mcc_wait[tag]);
+	return 0;
 }
 
 static struct be_mcc_compl *be_mcc_compl_get(struct beiscsi_hba *phba)
@@ -89,7 +153,7 @@ static void be2iscsi_fail_session(struct iscsi_cls_session *cls_session)
 	iscsi_session_failure(cls_session->dd_data, ISCSI_ERR_CONN_FAILED);
 }
 
-static void beiscsi_async_link_state_process(struct beiscsi_hba *phba,
+void beiscsi_async_link_state_process(struct beiscsi_hba *phba,
 		struct be_async_event_link_state *evt)
 {
 	switch (evt->port_link_status) {
@@ -162,7 +226,6 @@ int beiscsi_process_mcc(struct beiscsi_hba *phba)
 /* Wait till no more pending mcc requests are present */
 static int be_mcc_wait_compl(struct beiscsi_hba *phba)
 {
-#define mcc_timeout		120000 /* 5s timeout */
 	int i, status;
 	for (i = 0; i < mcc_timeout; i++) {
 		status = beiscsi_process_mcc(phba);
@@ -372,9 +435,10 @@ struct be_mcc_wrb *wrb_from_mccq(struct beiscsi_hba *phba)
 
 	BUG_ON(atomic_read(&mccq->used) >= mccq->len);
 	wrb = queue_head_node(mccq);
+	memset(wrb, 0, sizeof(*wrb));
+	wrb->tag0 = (mccq->head & 0x000000FF) << 16;
 	queue_head_inc(mccq);
 	atomic_inc(&mccq->used);
-	memset(wrb, 0, sizeof(*wrb));
 	return wrb;
 }
 
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 5de8acb..69dddfa 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -425,14 +425,20 @@ int beiscsi_cmd_mccq_create(struct beiscsi_hba *phba,
 int be_poll_mcc(struct be_ctrl_info *ctrl);
 unsigned char mgmt_check_supported_fw(struct be_ctrl_info *ctrl,
 				      struct beiscsi_hba *phba);
-int be_cmd_get_mac_addr(struct beiscsi_hba *phba, u8 *mac_addr);
-
+unsigned int be_cmd_get_mac_addr(struct beiscsi_hba *phba);
+void free_mcc_tag(struct be_ctrl_info *ctrl, unsigned int tag);
 /*ISCSI Functuions */
 int be_cmd_fw_initialize(struct be_ctrl_info *ctrl);
 
 struct be_mcc_wrb *wrb_from_mbox(struct be_dma_mem *mbox_mem);
 struct be_mcc_wrb *wrb_from_mccq(struct beiscsi_hba *phba);
 int be_mcc_notify_wait(struct beiscsi_hba *phba);
+void be_mcc_notify(struct beiscsi_hba *phba);
+unsigned int alloc_mcc_tag(struct beiscsi_hba *phba);
+void beiscsi_async_link_state_process(struct beiscsi_hba *phba,
+		struct be_async_event_link_state *evt);
+int be_mcc_compl_process_isr(struct be_ctrl_info *ctrl,
+				    struct be_mcc_compl *compl);
 
 int be_mbox_notify(struct be_ctrl_info *ctrl);
 
@@ -448,6 +454,8 @@ int be_cmd_iscsi_post_sgl_pages(struct be_ctrl_info *ctrl,
 int be_cmd_wrbq_create(struct be_ctrl_info *ctrl, struct be_dma_mem *q_mem,
 		       struct be_queue_info *wrbq);
 
+bool is_link_state_evt(u32 trailer);
+
 struct be_default_pdu_context {
 	u32 dw[4];
 } __packed;
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index f229184..95694d3 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -101,6 +101,7 @@ void beiscsi_session_destroy(struct iscsi_cls_session *cls_session)
 	struct iscsi_session *sess = cls_session->dd_data;
 	struct beiscsi_session *beiscsi_sess = sess->dd_data;
 
+	SE_DEBUG(DBG_LVL_8, "In beiscsi_session_destroy\n");
 	pci_pool_destroy(beiscsi_sess->bhs_pool);
 	iscsi_session_teardown(cls_session);
 }
@@ -224,6 +225,7 @@ int beiscsi_conn_get_param(struct iscsi_cls_conn *cls_conn,
 	struct beiscsi_conn *beiscsi_conn = conn->dd_data;
 	int len = 0;
 
+	SE_DEBUG(DBG_LVL_8, "In beiscsi_conn_get_param, param= %d\n", param);
 	beiscsi_ep = beiscsi_conn->ep;
 	if (!beiscsi_ep) {
 		SE_DEBUG(DBG_LVL_1,
@@ -254,6 +256,7 @@ int beiscsi_set_param(struct iscsi_cls_conn *cls_conn,
 	struct iscsi_session *session = conn->session;
 	int ret;
 
+	SE_DEBUG(DBG_LVL_8, "In beiscsi_conn_set_param, param= %d\n", param);
 	ret = iscsi_set_param(cls_conn, param, buf, buflen);
 	if (ret)
 		return ret;
@@ -293,12 +296,41 @@ int beiscsi_get_host_param(struct Scsi_Host *shost,
 			   enum iscsi_host_param param, char *buf)
 {
 	struct beiscsi_hba *phba = (struct beiscsi_hba *)iscsi_host_priv(shost);
+	struct be_cmd_resp_get_mac_addr *resp;
+	struct be_mcc_wrb *wrb;
+	unsigned int tag, wrb_num;
 	int len = 0;
+	unsigned short status, extd_status;
+	struct be_queue_info *mccq = &phba->ctrl.mcc_obj.q;
 
+	SE_DEBUG(DBG_LVL_8, "In beiscsi_get_host_param, param= %d\n", param);
 	switch (param) {
 	case ISCSI_HOST_PARAM_HWADDRESS:
-		be_cmd_get_mac_addr(phba, phba->mac_address);
-		len = sysfs_format_mac(buf, phba->mac_address, ETH_ALEN);
+		tag = be_cmd_get_mac_addr(phba);
+		if (!tag) {
+			SE_DEBUG(DBG_LVL_1, "be_cmd_get_mac_addr Failed \n");
+			return -1;
+		} else
+			wait_event_interruptible(phba->ctrl.mcc_wait[tag],
+						 phba->ctrl.mcc_numtag[tag]);
+
+		wrb_num = (phba->ctrl.mcc_numtag[tag] & 0x00FF0000) >> 16;
+		extd_status = (phba->ctrl.mcc_numtag[tag] & 0x0000FF00) >> 8;
+		status = phba->ctrl.mcc_numtag[tag] & 0x000000FF;
+		if (status || extd_status) {
+			SE_DEBUG(DBG_LVL_1, "be_cmd_get_mac_addr Failed"
+					    " status = %d extd_status = %d \n",
+					    status, extd_status);
+			free_mcc_tag(&phba->ctrl, tag);
+			return -1;
+		} else {
+			wrb = queue_get_wrb(mccq, wrb_num);
+			free_mcc_tag(&phba->ctrl, tag);
+			resp = embedded_payload(wrb);
+			memcpy(phba->mac_address, resp->mac_address, ETH_ALEN);
+			len = sysfs_format_mac(buf, phba->mac_address,
+					       ETH_ALEN);
+		}
 		break;
 	default:
 		return iscsi_host_get_param(shost, param, buf);
@@ -378,6 +410,7 @@ int beiscsi_conn_start(struct iscsi_cls_conn *cls_conn)
 	struct beiscsi_endpoint *beiscsi_ep;
 	struct beiscsi_offload_params params;
 
+	SE_DEBUG(DBG_LVL_8, "In beiscsi_conn_start\n");
 	memset(&params, 0, sizeof(struct beiscsi_offload_params));
 	beiscsi_ep = beiscsi_conn->ep;
 	if (!beiscsi_ep)
@@ -422,8 +455,14 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 {
 	struct beiscsi_endpoint *beiscsi_ep = ep->dd_data;
 	struct beiscsi_hba *phba = beiscsi_ep->phba;
+	struct be_queue_info *mccq = &phba->ctrl.mcc_obj.q;
+	struct be_mcc_wrb *wrb;
+	struct tcp_connect_and_offload_out *ptcpcnct_out;
+	unsigned short status, extd_status;
+	unsigned int tag, wrb_num;
 	int ret = -1;
 
+	SE_DEBUG(DBG_LVL_8, "In beiscsi_open_conn\n");
 	beiscsi_ep->ep_cid = beiscsi_get_cid(phba);
 	if (beiscsi_ep->ep_cid == 0xFFFF) {
 		SE_DEBUG(DBG_LVL_1, "No free cid available\n");
@@ -440,7 +479,35 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 	}
 
 	beiscsi_ep->cid_vld = 0;
-	return mgmt_open_connection(phba, dst_addr, beiscsi_ep);
+	tag = mgmt_open_connection(phba, dst_addr, beiscsi_ep);
+	if (!tag) {
+		SE_DEBUG(DBG_LVL_1,
+			 "mgmt_invalidate_connection Failed for cid=%d \n",
+			 beiscsi_ep->ep_cid);
+	} else {
+		wait_event_interruptible(phba->ctrl.mcc_wait[tag],
+					 phba->ctrl.mcc_numtag[tag]);
+	}
+	wrb_num = (phba->ctrl.mcc_numtag[tag] & 0x00FF0000) >> 16;
+	extd_status = (phba->ctrl.mcc_numtag[tag] & 0x0000FF00) >> 8;
+	status = phba->ctrl.mcc_numtag[tag] & 0x000000FF;
+	if (status || extd_status) {
+		SE_DEBUG(DBG_LVL_1, "mgmt_open_connection Failed"
+				    " status = %d extd_status = %d \n",
+				    status, extd_status);
+		free_mcc_tag(&phba->ctrl, tag);
+		return -1;
+	} else {
+		wrb = queue_get_wrb(mccq, wrb_num);
+		free_mcc_tag(&phba->ctrl, tag);
+
+		ptcpcnct_out = 	embedded_payload(wrb);
+		beiscsi_ep = ep->dd_data;
+		beiscsi_ep->fw_handle = ptcpcnct_out->connection_handle;
+		beiscsi_ep->cid_vld = 1;
+		SE_DEBUG(DBG_LVL_8, "mgmt_open_connection Success\n");
+	}
+	return 0;
 }
 
 /**
@@ -509,7 +576,6 @@ beiscsi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 	beiscsi_ep = ep->dd_data;
 	beiscsi_ep->phba = phba;
 	beiscsi_ep->openiscsi_ep = ep;
-
 	if (beiscsi_open_conn(ep, NULL, dst_addr, non_blocking)) {
 		SE_DEBUG(DBG_LVL_1, "Failed in beiscsi_open_conn \n");
 		ret = -ENOMEM;
@@ -549,16 +615,19 @@ int beiscsi_ep_poll(struct iscsi_endpoint *ep, int timeout_ms)
 static int beiscsi_close_conn(struct  beiscsi_endpoint *beiscsi_ep, int flag)
 {
 	int ret = 0;
+	unsigned int tag;
 	struct beiscsi_hba *phba = beiscsi_ep->phba;
 
-	if (MGMT_STATUS_SUCCESS !=
-	    mgmt_upload_connection(phba, beiscsi_ep->ep_cid,
-		flag)) {
+	tag = mgmt_upload_connection(phba, beiscsi_ep->ep_cid, flag);
+	if (!tag) {
 		SE_DEBUG(DBG_LVL_8, "upload failed for cid 0x%x",
 			 beiscsi_ep->ep_cid);
 		ret = -1;
+	} else {
+		wait_event_interruptible(phba->ctrl.mcc_wait[tag],
+					 phba->ctrl.mcc_numtag[tag]);
+		free_mcc_tag(&phba->ctrl, tag);
 	}
-
 	return ret;
 }
 
@@ -576,6 +645,8 @@ void beiscsi_ep_disconnect(struct iscsi_endpoint *ep)
 
 	beiscsi_ep = ep->dd_data;
 	phba = beiscsi_ep->phba;
+	SE_DEBUG(DBG_LVL_8, "In beiscsi_ep_disconnect for ep_cid = %d\n",
+			     beiscsi_ep->ep_cid);
 
 	if (beiscsi_ep->conn) {
 		beiscsi_conn = beiscsi_ep->conn;
@@ -614,22 +685,27 @@ void beiscsi_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 	struct iscsi_session *session = conn->session;
 	struct Scsi_Host *shost = iscsi_session_to_shost(session->cls_session);
 	struct beiscsi_hba *phba = iscsi_host_priv(shost);
-	unsigned int status;
+	unsigned int tag;
 	unsigned short savecfg_flag = CMD_ISCSI_SESSION_SAVE_CFG_ON_FLASH;
 
-	SE_DEBUG(DBG_LVL_8, "In beiscsi_conn_stop\n");
 	beiscsi_ep = beiscsi_conn->ep;
 	if (!beiscsi_ep) {
 		SE_DEBUG(DBG_LVL_8, "In beiscsi_conn_stop , no beiscsi_ep\n");
 		return;
 	}
-	status = mgmt_invalidate_connection(phba, beiscsi_ep,
+	SE_DEBUG(DBG_LVL_8, "In beiscsi_conn_stop  ep_cid = %d\n",
+			     beiscsi_ep->ep_cid);
+	tag = mgmt_invalidate_connection(phba, beiscsi_ep,
 					    beiscsi_ep->ep_cid, 1,
 					    savecfg_flag);
-	if (status != MGMT_STATUS_SUCCESS) {
+	if (!tag) {
 		SE_DEBUG(DBG_LVL_1,
 			 "mgmt_invalidate_connection Failed for cid=%d \n",
 			 beiscsi_ep->ep_cid);
+	} else {
+		wait_event_interruptible(phba->ctrl.mcc_wait[tag],
+					 phba->ctrl.mcc_numtag[tag]);
+		free_mcc_tag(&phba->ctrl, tag);
 	}
 	beiscsi_close_conn(beiscsi_ep, CONNECTION_UPLOAD_GRACEFUL);
 	beiscsi_free_ep(beiscsi_ep);
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 6170548..a6a2c64 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -442,7 +442,7 @@ static irqreturn_t be_isr(int irq, void *dev_id)
 			if (phba->todo_mcc_cq)
 				queue_work(phba->wq, &phba->work_cqs);
 
-		if ((num_mcceq_processed) && (!num_ioeq_processed))
+			if ((num_mcceq_processed) && (!num_ioeq_processed))
 				hwi_ring_eq_db(phba, eq->id, 0,
 					      (num_ioeq_processed +
 					       num_mcceq_processed) , 1, 1);
@@ -651,7 +651,6 @@ struct wrb_handle *alloc_wrb_handle(struct beiscsi_hba *phba, unsigned int cid)
 			pwrb_context->alloc_index = 0;
 		else
 			pwrb_context->alloc_index++;
-
 		pwrb_handle_tmp = pwrb_context->pwrb_handle_base[
 						pwrb_context->alloc_index];
 		pwrb_handle->nxt_wrb_index = pwrb_handle_tmp->wrb_index;
@@ -791,6 +790,7 @@ be_complete_io(struct beiscsi_conn *beiscsi_conn,
 		memcpy(task->sc->sense_buffer, sense,
 		       min_t(u16, sense_len, SCSI_SENSE_BUFFERSIZE));
 	}
+
 	if (io_task->cmd_bhs->iscsi_hdr.flags & ISCSI_FLAG_CMD_READ) {
 		if (psol->dw[offsetof(struct amap_sol_cqe, i_res_cnt) / 32]
 							& SOL_RES_CNT_MASK)
@@ -1432,6 +1432,48 @@ static void hwi_process_default_pdu_ring(struct beiscsi_conn *beiscsi_conn,
 	hwi_post_async_buffers(phba, pasync_handle->is_header);
 }
 
+static void  beiscsi_process_mcc_isr(struct beiscsi_hba *phba)
+{
+	struct be_queue_info *mcc_cq;
+	struct  be_mcc_compl *mcc_compl;
+	unsigned int num_processed = 0;
+
+	mcc_cq = &phba->ctrl.mcc_obj.cq;
+	mcc_compl = queue_tail_node(mcc_cq);
+	mcc_compl->flags = le32_to_cpu(mcc_compl->flags);
+	while (mcc_compl->flags & CQE_FLAGS_VALID_MASK) {
+
+		if (num_processed >= 32) {
+			hwi_ring_cq_db(phba, mcc_cq->id,
+					num_processed, 0, 0);
+			num_processed = 0;
+		}
+		if (mcc_compl->flags & CQE_FLAGS_ASYNC_MASK) {
+			/* Interpret flags as an async trailer */
+			if (is_link_state_evt(mcc_compl->flags))
+				/* Interpret compl as a async link evt */
+				beiscsi_async_link_state_process(phba,
+				(struct be_async_event_link_state *) mcc_compl);
+			else
+				SE_DEBUG(DBG_LVL_1,
+					" Unsupported Async Event, flags"
+					" = 0x%08x \n", mcc_compl->flags);
+		} else if (mcc_compl->flags & CQE_FLAGS_COMPLETED_MASK) {
+			be_mcc_compl_process_isr(&phba->ctrl, mcc_compl);
+			atomic_dec(&phba->ctrl.mcc_obj.q.used);
+		}
+
+		mcc_compl->flags = 0;
+		queue_tail_inc(mcc_cq);
+		mcc_compl = queue_tail_node(mcc_cq);
+		mcc_compl->flags = le32_to_cpu(mcc_compl->flags);
+		num_processed++;
+	}
+
+	if (num_processed > 0)
+		hwi_ring_cq_db(phba, mcc_cq->id, num_processed, 1, 0);
+
+}
 
 static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 {
@@ -1468,6 +1510,7 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 		}
 		beiscsi_ep = ep->dd_data;
 		beiscsi_conn = beiscsi_ep->conn;
+
 		if (num_processed >= 32) {
 			hwi_ring_cq_db(phba, cq->id,
 					num_processed, 0, 0);
@@ -1603,7 +1646,7 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 	return tot_nump;
 }
 
-static void beiscsi_process_all_cqs(struct work_struct *work)
+void beiscsi_process_all_cqs(struct work_struct *work)
 {
 	unsigned long flags;
 	struct hwi_controller *phwi_ctrlr;
@@ -1623,6 +1666,7 @@ static void beiscsi_process_all_cqs(struct work_struct *work)
 		spin_lock_irqsave(&phba->isr_lock, flags);
 		phba->todo_mcc_cq = 0;
 		spin_unlock_irqrestore(&phba->isr_lock, flags);
+		beiscsi_process_mcc_isr(phba);
 	}
 
 	if (phba->todo_cq) {
@@ -3160,6 +3204,7 @@ static void hwi_purge_eq(struct beiscsi_hba *phba)
 	struct be_queue_info *eq;
 	struct be_eq_entry *eqe = NULL;
 	int i, eq_msix;
+	unsigned int num_processed;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
 	phwi_context = phwi_ctrlr->phwi_ctxt;
@@ -3171,13 +3216,17 @@ static void hwi_purge_eq(struct beiscsi_hba *phba)
 	for (i = 0; i < (phba->num_cpus + eq_msix); i++) {
 		eq = &phwi_context->be_eq[i].q;
 		eqe = queue_tail_node(eq);
-
+		num_processed = 0;
 		while (eqe->dw[offsetof(struct amap_eq_entry, valid) / 32]
 					& EQE_VALID_MASK) {
 			AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
 			queue_tail_inc(eq);
 			eqe = queue_tail_node(eq);
+			num_processed++;
 		}
+
+		if (num_processed)
+			hwi_ring_eq_db(phba, eq->id, 1,	num_processed, 1, 1);
 	}
 }
 
@@ -3189,8 +3238,9 @@ static void beiscsi_clean_port(struct beiscsi_hba *phba)
 	if (mgmt_status)
 		shost_printk(KERN_WARNING, phba->shost,
 			     "mgmt_epfw_cleanup FAILED \n");
-	hwi_cleanup(phba);
+
 	hwi_purge_eq(phba);
+	hwi_cleanup(phba);
 	if (ring_mode)
 		kfree(phba->sgl_hndl_array);
 	kfree(phba->io_sgl_hndl_base);
@@ -3519,6 +3569,7 @@ static int beiscsi_mtask(struct iscsi_task *task)
 	unsigned int doorbell = 0;
 	unsigned int i, cid;
 	struct iscsi_task *aborted_task;
+	unsigned int tag;
 
 	cid = beiscsi_conn->beiscsi_conn_cid;
 	pwrb = io_task->pwrb_handle->pwrb;
@@ -3550,7 +3601,6 @@ static int beiscsi_mtask(struct iscsi_task *task)
 			AMAP_SET_BITS(struct amap_iscsi_wrb, dmsg, pwrb, 0);
 		else
 			AMAP_SET_BITS(struct amap_iscsi_wrb, dmsg, pwrb, 1);
-
 		hwi_write_buffer(pwrb, task);
 		break;
 	case ISCSI_OP_TEXT:
@@ -3579,9 +3629,18 @@ static int beiscsi_mtask(struct iscsi_task *task)
 		if (!aborted_io_task->scsi_cmnd)
 			return 0;
 
-		mgmt_invalidate_icds(phba,
+		tag = mgmt_invalidate_icds(phba,
 				     aborted_io_task->psgl_handle->sgl_index,
 				     cid);
+		if (!tag) {
+			shost_printk(KERN_WARNING, phba->shost,
+				     "mgmt_invalidate_icds could not be"
+				     " submitted\n");
+		} else {
+			wait_event_interruptible(phba->ctrl.mcc_wait[tag],
+						 phba->ctrl.mcc_numtag[tag]);
+			free_mcc_tag(&phba->ctrl, tag);
+		}
 		if (ring_mode)
 			io_task->psgl_handle->type = INI_TMF_CMD;
 		else
@@ -3656,7 +3715,6 @@ static int beiscsi_task_xmit(struct iscsi_task *task)
 	return beiscsi_iotask(task, sg, num_sg, xferlen, writedir);
 }
 
-
 static void beiscsi_remove(struct pci_dev *pcidev)
 {
 	struct beiscsi_hba *phba = NULL;
@@ -3776,6 +3834,15 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 		goto free_port;
 	}
 
+	for (i = 0; i < MAX_MCC_CMD ; i++) {
+		init_waitqueue_head(&phba->ctrl.mcc_wait[i + 1]);
+		phba->ctrl.mcc_tag[i] = i + 1;
+		phba->ctrl.mcc_numtag[i + 1] = 0;
+		phba->ctrl.mcc_tag_available++;
+	}
+
+	phba->ctrl.mcc_alloc_index = phba->ctrl.mcc_free_index = 0;
+
 	snprintf(phba->wq_name, sizeof(phba->wq_name), "beiscsi_q_irq%u",
 		 phba->shost->host_no);
 	phba->wq = create_workqueue(phba->wq_name);
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 0553f49..4cde8f6 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -655,6 +655,8 @@ struct wrb_handle *alloc_wrb_handle(struct beiscsi_hba *phba, unsigned int cid);
 void
 free_mgmt_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle);
 
+void beiscsi_process_all_cqs(struct work_struct *work);
+
 struct pdu_nop_out {
 	u32 dw[12];
 };
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index df1b327..18f8041 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -148,10 +148,17 @@ unsigned char mgmt_invalidate_icds(struct beiscsi_hba *phba,
 {
 	struct be_dma_mem nonemb_cmd;
 	struct be_ctrl_info *ctrl = &phba->ctrl;
-	struct be_mcc_wrb *wrb = wrb_from_mccq(phba);
-	struct be_sge *sge = nonembedded_sgl(wrb);
+	struct be_mcc_wrb *wrb;
+	struct be_sge *sge;
 	struct invalidate_commands_params_in *req;
-	int status = 0;
+	unsigned int tag = 0;
+
+	spin_lock(&ctrl->mbox_lock);
+	tag = alloc_mcc_tag(phba);
+	if (!tag) {
+		spin_unlock(&ctrl->mbox_lock);
+		return tag;
+	}
 
 	nonemb_cmd.va = pci_alloc_consistent(ctrl->pdev,
 				sizeof(struct invalidate_commands_params_in),
@@ -164,8 +171,9 @@ unsigned char mgmt_invalidate_icds(struct beiscsi_hba *phba,
 	}
 	nonemb_cmd.size = sizeof(struct invalidate_commands_params_in);
 	req = nonemb_cmd.va;
-	spin_lock(&ctrl->mbox_lock);
-	memset(wrb, 0, sizeof(*wrb));
+	wrb = wrb_from_mccq(phba);
+	sge = nonembedded_sgl(wrb);
+	wrb->tag0 |= tag;
 
 	be_wrb_hdr_prepare(wrb, sizeof(*req), false, 1);
 	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
@@ -180,14 +188,12 @@ unsigned char mgmt_invalidate_icds(struct beiscsi_hba *phba,
 	sge->pa_lo = cpu_to_le32(nonemb_cmd.dma & 0xFFFFFFFF);
 	sge->len = cpu_to_le32(nonemb_cmd.size);
 
-	status = be_mcc_notify_wait(phba);
-	if (status)
-		SE_DEBUG(DBG_LVL_1, "ICDS Invalidation Failed\n");
+	be_mcc_notify(phba);
 	spin_unlock(&ctrl->mbox_lock);
 	if (nonemb_cmd.va)
 		pci_free_consistent(ctrl->pdev, nonemb_cmd.size,
 				    nonemb_cmd.va, nonemb_cmd.dma);
-	return status;
+	return tag;
 }
 
 unsigned char mgmt_invalidate_connection(struct beiscsi_hba *phba,
@@ -197,13 +203,19 @@ unsigned char mgmt_invalidate_connection(struct beiscsi_hba *phba,
 					 unsigned short savecfg_flag)
 {
 	struct be_ctrl_info *ctrl = &phba->ctrl;
-	struct be_mcc_wrb *wrb = wrb_from_mccq(phba);
-	struct iscsi_invalidate_connection_params_in *req =
-						embedded_payload(wrb);
-	int status = 0;
+	struct be_mcc_wrb *wrb;
+	struct iscsi_invalidate_connection_params_in *req;
+	unsigned int tag = 0;
 
 	spin_lock(&ctrl->mbox_lock);
-	memset(wrb, 0, sizeof(*wrb));
+	tag = alloc_mcc_tag(phba);
+	if (!tag) {
+		spin_unlock(&ctrl->mbox_lock);
+		return tag;
+	}
+	wrb = wrb_from_mccq(phba);
+	wrb->tag0 |= tag;
+	req = embedded_payload(wrb);
 
 	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
 	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI_INI,
@@ -216,35 +228,37 @@ unsigned char mgmt_invalidate_connection(struct beiscsi_hba *phba,
 	else
 		req->cleanup_type = CMD_ISCSI_CONNECTION_INVALIDATE;
 	req->save_cfg = savecfg_flag;
-	status =  be_mcc_notify_wait(phba);
-	if (status)
-		SE_DEBUG(DBG_LVL_1, "Invalidation Failed\n");
-
+	be_mcc_notify(phba);
 	spin_unlock(&ctrl->mbox_lock);
-	return status;
+	return tag;
 }
 
 unsigned char mgmt_upload_connection(struct beiscsi_hba *phba,
 				unsigned short cid, unsigned int upload_flag)
 {
 	struct be_ctrl_info *ctrl = &phba->ctrl;
-	struct be_mcc_wrb *wrb = wrb_from_mccq(phba);
-	struct tcp_upload_params_in *req = embedded_payload(wrb);
-	int status = 0;
+	struct be_mcc_wrb *wrb;
+	struct tcp_upload_params_in *req;
+	unsigned int tag = 0;
 
 	spin_lock(&ctrl->mbox_lock);
-	memset(wrb, 0, sizeof(*wrb));
+	tag = alloc_mcc_tag(phba);
+	if (!tag) {
+		spin_unlock(&ctrl->mbox_lock);
+		return tag;
+	}
+	wrb = wrb_from_mccq(phba);
+	req = embedded_payload(wrb);
+	wrb->tag0 |= tag;
 
 	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
 	be_cmd_hdr_prepare(&req->hdr, CMD_COMMON_TCP_UPLOAD,
 			   OPCODE_COMMON_TCP_UPLOAD, sizeof(*req));
 	req->id = (unsigned short)cid;
 	req->upload_type = (unsigned char)upload_flag;
-	status = be_mcc_notify_wait(phba);
-	if (status)
-		SE_DEBUG(DBG_LVL_1, "mgmt_upload_connection Failed\n");
+	be_mcc_notify(phba);
 	spin_unlock(&ctrl->mbox_lock);
-	return status;
+	return tag;
 }
 
 int mgmt_open_connection(struct beiscsi_hba *phba,
@@ -256,13 +270,13 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 	struct sockaddr_in *daddr_in = (struct sockaddr_in *)dst_addr;
 	struct sockaddr_in6 *daddr_in6 = (struct sockaddr_in6 *)dst_addr;
 	struct be_ctrl_info *ctrl = &phba->ctrl;
-	struct be_mcc_wrb *wrb = wrb_from_mccq(phba);
-	struct tcp_connect_and_offload_in *req = embedded_payload(wrb);
+	struct be_mcc_wrb *wrb;
+	struct tcp_connect_and_offload_in *req;
 	unsigned short def_hdr_id;
 	unsigned short def_data_id;
 	struct phys_addr template_address = { 0, 0 };
 	struct phys_addr *ptemplate_address;
-	int status = 0;
+	unsigned int tag = 0;
 	unsigned int i;
 	unsigned short cid = beiscsi_ep->ep_cid;
 
@@ -274,7 +288,14 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 	ptemplate_address = &template_address;
 	ISCSI_GET_PDU_TEMPLATE_ADDRESS(phba, ptemplate_address);
 	spin_lock(&ctrl->mbox_lock);
-	memset(wrb, 0, sizeof(*wrb));
+	tag = alloc_mcc_tag(phba);
+	if (!tag) {
+		spin_unlock(&ctrl->mbox_lock);
+		return tag;
+	}
+	wrb = wrb_from_mccq(phba);
+	req = embedded_payload(wrb);
+	wrb->tag0 |= tag;
 
 	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
 	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
@@ -319,47 +340,36 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 	req->do_offload = 1;
 	req->dataout_template_pa.lo = ptemplate_address->lo;
 	req->dataout_template_pa.hi = ptemplate_address->hi;
-	status = be_mcc_notify_wait(phba);
-	if (!status) {
-		struct iscsi_endpoint *ep;
-		struct tcp_connect_and_offload_out *ptcpcnct_out =
-							embedded_payload(wrb);
-
-		ep = phba->ep_array[ptcpcnct_out->cid -
-				    phba->fw_config.iscsi_cid_start];
-		beiscsi_ep = ep->dd_data;
-		beiscsi_ep->fw_handle = ptcpcnct_out->connection_handle;
-		beiscsi_ep->cid_vld = 1;
-		SE_DEBUG(DBG_LVL_8, "mgmt_open_connection Success\n");
-	} else
-		SE_DEBUG(DBG_LVL_1, "mgmt_open_connection Failed\n");
+	be_mcc_notify(phba);
 	spin_unlock(&ctrl->mbox_lock);
-	return status;
+	return tag;
 }
 
-int be_cmd_get_mac_addr(struct beiscsi_hba *phba, u8 *mac_addr)
+unsigned int be_cmd_get_mac_addr(struct beiscsi_hba *phba)
 {
 	struct be_ctrl_info *ctrl = &phba->ctrl;
-	struct be_mcc_wrb *wrb = wrb_from_mccq(phba);
-	struct be_cmd_req_get_mac_addr *req = embedded_payload(wrb);
-	int status;
+	struct be_mcc_wrb *wrb;
+	struct be_cmd_req_get_mac_addr *req;
+	unsigned int tag = 0;
 
 	SE_DEBUG(DBG_LVL_8, "In be_cmd_get_mac_addr\n");
 	spin_lock(&ctrl->mbox_lock);
-	memset(wrb, 0, sizeof(*wrb));
+	tag = alloc_mcc_tag(phba);
+	if (!tag) {
+		spin_unlock(&ctrl->mbox_lock);
+		return tag;
+	}
+
+	wrb = wrb_from_mccq(phba);
+	req = embedded_payload(wrb);
+	wrb->tag0 |= tag;
 	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
 	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
 			   OPCODE_COMMON_ISCSI_NTWK_GET_NIC_CONFIG,
 			   sizeof(*req));
 
-	status = be_mcc_notify_wait(phba);
-	if (!status) {
-		struct be_cmd_resp_get_mac_addr *resp = embedded_payload(wrb);
-
-		memcpy(mac_addr, resp->mac_address, ETH_ALEN);
-	}
-
+	be_mcc_notify(phba);
 	spin_unlock(&ctrl->mbox_lock);
-	return status;
+	return tag;
 }
 
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index 6bc59e8..f873a66 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -250,7 +250,4 @@ unsigned char mgmt_invalidate_connection(struct beiscsi_hba *phba,
 					 unsigned short issue_reset,
 					 unsigned short savecfg_flag);
 
-unsigned char mgmt_fw_cmd(struct be_ctrl_info *ctrl,
-			  struct beiscsi_hba *phba,
-			  char *buf, unsigned int len);
 #endif
-- 
1.6.4

