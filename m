From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 1/1] be2iscsi: Fixes for powerpc compile
Date: Wed, 9 Sep 2009 07:26:55 +0530
Message-ID: <20090909015642.GA30860@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:43533 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752575AbZIIB45 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2009 21:56:57 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, sfr@canb.auug.org.au, michaelc@cs.wisc.edu

This patch fixes the tab / code alignment concerns exressed by Mike Christie.
This  also contains fixes to  remove virt_to_* family from the driver.
It contains some function name changes to a few low level functions
to avoid name clash with our net driver.

This patch applies on 
git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-post-merge-2.6.git

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be.h       |    4 +-
 drivers/scsi/be2iscsi/be_cmds.c  |   27 +++++++---------
 drivers/scsi/be2iscsi/be_cmds.h  |   16 +++++-----
 drivers/scsi/be2iscsi/be_iscsi.c |   60 +++++++++++++++++++++++++++++++++++--
 drivers/scsi/be2iscsi/be_iscsi.h |    2 +
 drivers/scsi/be2iscsi/be_main.c  |   58 ++++++++++++++++++------------------
 drivers/scsi/be2iscsi/be_main.h  |    3 +-
 7 files changed, 111 insertions(+), 59 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be.h b/drivers/scsi/be2iscsi/be.h
index 8c973a2..b36020d 100644
--- a/drivers/scsi/be2iscsi/be.h
+++ b/drivers/scsi/be2iscsi/be.h
@@ -177,7 +177,7 @@ static inline void swap_dws(void *wrb, int len)
 #endif /* __BIG_ENDIAN */
 }
 
-extern void be_cq_notify(struct be_ctrl_info *ctrl, u16 qid, bool arm,
-		u16 num_popped);
+extern void beiscsi_cq_notify(struct be_ctrl_info *ctrl, u16 qid, bool arm,
+			      u16 num_popped);
 
 #endif /* BEISCSI_H */
diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 63afea2..08007b6 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -60,7 +60,8 @@ static inline bool is_link_state_evt(u32 trailer)
 		ASYNC_TRAILER_EVENT_CODE_MASK) == ASYNC_EVENT_CODE_LINK_STATE);
 }
 
-void be_cq_notify(struct be_ctrl_info *ctrl, u16 qid, bool arm, u16 num_popped)
+void beiscsi_cq_notify(struct be_ctrl_info *ctrl, u16 qid, bool arm,
+		       u16 num_popped)
 {
 	u32 val = 0;
 	val |= qid & DB_CQ_RING_ID_MASK;
@@ -202,8 +203,8 @@ struct be_mcc_wrb *wrb_from_mbox(struct be_dma_mem *mbox_mem)
 	return &((struct be_mcc_mailbox *)(mbox_mem->va))->wrb;
 }
 
-int be_cmd_eq_create(struct be_ctrl_info *ctrl,
-		struct be_queue_info *eq, int eq_delay)
+int beiscsi_cmd_eq_create(struct be_ctrl_info *ctrl,
+			  struct be_queue_info *eq, int eq_delay)
 {
 	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
 	struct be_cmd_req_eq_create *req = embedded_payload(wrb);
@@ -270,9 +271,9 @@ int be_cmd_fw_initialize(struct be_ctrl_info *ctrl)
 	return status;
 }
 
-int be_cmd_cq_create(struct be_ctrl_info *ctrl,
-		      struct be_queue_info *cq, struct be_queue_info *eq,
-		      bool sol_evts, bool no_delay, int coalesce_wm)
+int beiscsi_cmd_cq_create(struct be_ctrl_info *ctrl,
+			  struct be_queue_info *cq, struct be_queue_info *eq,
+			  bool sol_evts, bool no_delay, int coalesce_wm)
 {
 	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
 	struct be_cmd_req_cq_create *req = embedded_payload(wrb);
@@ -289,12 +290,8 @@ int be_cmd_cq_create(struct be_ctrl_info *ctrl,
 	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_COMMON,
 			OPCODE_COMMON_CQ_CREATE, sizeof(*req));
 
-	if (q_mem->va) {
-		SE_DEBUG(DBG_LVL_8, "In be_cmd_cq_create, q_mem->va =%p \n",
-								q_mem->va);
-	} else
-		SE_DEBUG(DBG_LVL_1,
-			"In be_cmd_cq_create, uninitialized q_mem->va\n");
+	if (!q_mem->va)
+		SE_DEBUG(DBG_LVL_1, "uninitialized q_mem->va\n");
 
 	req->num_pages = cpu_to_le16(PAGES_4K_SPANNED(q_mem->va, q_mem->size));
 
@@ -332,8 +329,8 @@ static u32 be_encoded_q_len(int q_len)
 		len_encoded = 0;
 	return len_encoded;
 }
-int be_cmd_q_destroy(struct be_ctrl_info *ctrl, struct be_queue_info *q,
-							int queue_type)
+int beiscsi_cmd_q_destroy(struct be_ctrl_info *ctrl, struct be_queue_info *q,
+			  int queue_type)
 {
 	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
 	struct be_cmd_req_q_destroy *req = embedded_payload(wrb);
@@ -521,6 +518,6 @@ int be_cmd_iscsi_post_sgl_pages(struct be_ctrl_info *ctrl,
 error:
 	spin_unlock(&ctrl->mbox_lock);
 	if (status != 0)
-		be_cmd_q_destroy(ctrl, NULL, QTYPE_SGL);
+		beiscsi_cmd_q_destroy(ctrl, NULL, QTYPE_SGL);
 	return status;
 }
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 1dc52cc..c20d686 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -407,16 +407,16 @@ struct be_cmd_resp_get_mac_addr {
 	u32 rsvd[23];
 };
 
-int be_cmd_eq_create(struct be_ctrl_info *ctrl,
-		     struct be_queue_info *eq, int eq_delay);
+int beiscsi_cmd_eq_create(struct be_ctrl_info *ctrl,
+			  struct be_queue_info *eq, int eq_delay);
 
-int be_cmd_cq_create(struct be_ctrl_info *ctrl,
-		     struct be_queue_info *cq, struct be_queue_info *eq,
-		     bool sol_evts, bool no_delay,
-		     int num_cqe_dma_coalesce);
+int beiscsi_cmd_cq_create(struct be_ctrl_info *ctrl,
+			  struct be_queue_info *cq, struct be_queue_info *eq,
+			  bool sol_evts, bool no_delay,
+			  int num_cqe_dma_coalesce);
 
-int be_cmd_q_destroy(struct be_ctrl_info *ctrl, struct be_queue_info *q,
-		     int type);
+int beiscsi_cmd_q_destroy(struct be_ctrl_info *ctrl, struct be_queue_info *q,
+			  int type);
 int be_poll_mcc(struct be_ctrl_info *ctrl);
 unsigned char mgmt_check_supported_fw(struct be_ctrl_info *ctrl);
 int be_cmd_get_mac_addr(struct be_ctrl_info *ctrl, u8 *mac_addr);
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 5a8fa33..b23526c 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -43,6 +43,15 @@ struct iscsi_cls_session *beiscsi_session_create(struct iscsi_endpoint *ep,
 {
 	struct Scsi_Host *shost;
 	struct beiscsi_endpoint *beiscsi_ep;
+	struct iscsi_cls_session *cls_session;
+	struct iscsi_session *sess;
+	struct beiscsi_hba *phba;
+	struct iscsi_task *task;
+	struct beiscsi_io_task *io_task;
+	unsigned int max_size, num_cmd;
+	dma_addr_t bus_add;
+	u64 pa_addr;
+	void *vaddr;
 
 	SE_DEBUG(DBG_LVL_8, "In beiscsi_session_create\n");
 
@@ -51,7 +60,8 @@ struct iscsi_cls_session *beiscsi_session_create(struct iscsi_endpoint *ep,
 		return NULL;
 	}
 	beiscsi_ep = ep->dd_data;
-	shost = beiscsi_ep->phba->shost;
+	phba = beiscsi_ep->phba;
+	shost = phba->shost;
 	if (cmds_max > beiscsi_ep->phba->params.wrbs_per_cxn) {
 		shost_printk(KERN_ERR, shost, "Cannot handle %d cmds."
 			     "Max cmds per session supported is %d. Using %d. "
@@ -61,9 +71,51 @@ struct iscsi_cls_session *beiscsi_session_create(struct iscsi_endpoint *ep,
 		cmds_max = beiscsi_ep->phba->params.wrbs_per_cxn;
 	}
 
-	return iscsi_session_setup(&beiscsi_iscsi_transport, shost, cmds_max,
-				   sizeof(struct beiscsi_io_task),
-				   initial_cmdsn, ISCSI_MAX_TARGET);
+	 cls_session = iscsi_session_setup(&beiscsi_iscsi_transport,
+					   shost, cmds_max,
+					   sizeof(struct beiscsi_io_task),
+					   initial_cmdsn, ISCSI_MAX_TARGET);
+	if (!cls_session)
+		return NULL;
+	sess = cls_session->dd_data;
+	max_size = ALIGN(sizeof(struct be_cmd_bhs), 64) * sess->cmds_max;
+	vaddr = pci_alloc_consistent(phba->pcidev, max_size, &bus_add);
+	pa_addr = (__u64) bus_add;
+
+	for (num_cmd = 0; num_cmd < sess->cmds_max; num_cmd++) {
+		task = sess->cmds[num_cmd];
+		io_task = task->dd_data;
+		io_task->cmd_bhs = vaddr;
+		io_task->bhs_pa.u.a64.address = pa_addr;
+		io_task->alloc_size = max_size;
+		vaddr += ALIGN(sizeof(struct be_cmd_bhs), 64);
+		pa_addr += ALIGN(sizeof(struct be_cmd_bhs), 64);
+	}
+	return cls_session;
+}
+
+/**
+ * beiscsi_session_destroy - destroys iscsi session
+ * @cls_session:	pointer to iscsi cls session
+ *
+ * Destroys iSCSI session instance and releases
+ * resources allocated for it.
+ */
+void beiscsi_session_destroy(struct iscsi_cls_session *cls_session)
+{
+	struct iscsi_task *task;
+	struct beiscsi_io_task *io_task;
+	struct iscsi_session *sess = cls_session->dd_data;
+	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
+	struct beiscsi_hba *phba = iscsi_host_priv(shost);
+
+	task = sess->cmds[0];
+	io_task = task->dd_data;
+	pci_free_consistent(phba->pcidev,
+			    io_task->alloc_size,
+			    io_task->cmd_bhs,
+			    io_task->bhs_pa.u.a64.address);
+	iscsi_session_teardown(cls_session);
 }
 
 /**
diff --git a/drivers/scsi/be2iscsi/be_iscsi.h b/drivers/scsi/be2iscsi/be_iscsi.h
index fab16fd..f92ffc5 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.h
+++ b/drivers/scsi/be2iscsi/be_iscsi.h
@@ -39,6 +39,8 @@ struct iscsi_cls_session *beiscsi_session_create(struct iscsi_endpoint *ep,
 						 uint16_t qdepth,
 						 uint32_t initial_cmdsn);
 
+void beiscsi_session_destroy(struct iscsi_cls_session *cls_session);
+
 struct iscsi_cls_conn *beiscsi_conn_create(struct iscsi_cls_session
 					   *cls_session, uint32_t cid);
 
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index ef82e22..d520fe8 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -565,7 +565,7 @@ be_complete_io(struct beiscsi_conn *beiscsi_conn,
 {
 	struct beiscsi_io_task *io_task = task->dd_data;
 	struct be_status_bhs *sts_bhs =
-				(struct be_status_bhs *)&io_task->cmd_bhs;
+				(struct be_status_bhs *)io_task->cmd_bhs;
 	struct iscsi_conn *conn = beiscsi_conn->conn;
 	unsigned int sense_len;
 	unsigned char *sense;
@@ -616,7 +616,7 @@ be_complete_io(struct beiscsi_conn *beiscsi_conn,
 		memcpy(task->sc->sense_buffer, sense,
 		       min_t(u16, sense_len, SCSI_SENSE_BUFFERSIZE));
 	}
-	if (io_task->cmd_bhs.iscsi_hdr.flags & ISCSI_FLAG_CMD_READ) {
+	if (io_task->cmd_bhs->iscsi_hdr.flags & ISCSI_FLAG_CMD_READ) {
 		if (psol->dw[offsetof(struct amap_sol_cqe, i_res_cnt) / 32]
 							& SOL_RES_CNT_MASK)
 			 conn->rxdata_octets += (psol->
@@ -1478,7 +1478,6 @@ static void hwi_write_buffer(struct iscsi_wrb *pwrb, struct iscsi_task *task)
 	struct beiscsi_hba *phba = beiscsi_conn->phba;
 
 	io_task->bhs_len = sizeof(struct be_nonio_bhs) - 2;
-	io_task->bhs_pa.u.a64.address = virt_to_bus(&io_task->cmd_bhs);
 	AMAP_SET_BITS(struct amap_iscsi_wrb, iscsi_bhs_addr_lo, pwrb,
 				io_task->bhs_pa.u.a32.address_lo);
 	AMAP_SET_BITS(struct amap_iscsi_wrb, iscsi_bhs_addr_hi, pwrb,
@@ -2070,10 +2069,11 @@ static int beiscsi_create_eq(struct beiscsi_hba *phba,
 
 	mem->dma = mem_descr->mem_array[idx].bus_address.u.a64.address;
 
-	ret = be_cmd_eq_create(&phba->ctrl, eq, phwi_context->be_eq.cur_eqd);
+	ret = beiscsi_cmd_eq_create(&phba->ctrl, eq,
+				    phwi_context->be_eq.cur_eqd);
 	if (ret) {
-		shost_printk(KERN_ERR, phba->shost, "be_cmd_eq_creat Failed"
-			     " for EQ \n");
+		shost_printk(KERN_ERR, phba->shost, "beiscsi_cmd_eq_create"
+			     "Failedfor EQ \n");
 		return ret;
 	}
 	SE_DEBUG(DBG_LVL_8, "eq id is %d\n", phwi_context->be_eq.q.id);
@@ -2106,10 +2106,10 @@ static int beiscsi_create_cq(struct beiscsi_hba *phba,
 	}
 
 	mem->dma = mem_descr->mem_array[idx].bus_address.u.a64.address;
-	ret = be_cmd_cq_create(&phba->ctrl, cq, eq, false, false, 0);
+	ret = beiscsi_cmd_cq_create(&phba->ctrl, cq, eq, false, false, 0);
 	if (ret) {
 		shost_printk(KERN_ERR, phba->shost,
-			     "be_cmd_eq_creat Failed for ISCSI CQ \n");
+			     "beiscsi_cmd_eq_create Failed for ISCSI CQ \n");
 		return ret;
 	}
 	SE_DEBUG(DBG_LVL_8, "iscsi cq id is %d\n", phwi_context->be_cq.id);
@@ -2151,7 +2151,7 @@ beiscsi_create_def_hdr(struct beiscsi_hba *phba,
 					      phba->params.defpdu_hdr_sz);
 	if (ret) {
 		shost_printk(KERN_ERR, phba->shost,
-			     "be_cmd_eq_creat Failed for DEF PDU HDR\n");
+			     "be_cmd_create_default_pdu_queue Failed DEFHDR\n");
 		return ret;
 	}
 	phwi_ctrlr->default_pdu_hdr.id = phwi_context->be_def_hdrq.id;
@@ -2195,7 +2195,8 @@ beiscsi_create_def_data(struct beiscsi_hba *phba,
 					      phba->params.defpdu_data_sz);
 	if (ret) {
 		shost_printk(KERN_ERR, phba->shost,
-			     "be_cmd_eq_creat Failed for DEF PDU DATA\n");
+			     "be_cmd_create_default_pdu_queue Failed"
+			     " for DEF PDU DATA\n");
 		return ret;
 	}
 	phwi_ctrlr->default_pdu_data.id = phwi_context->be_def_dataq.id;
@@ -2340,28 +2341,28 @@ static void hwi_cleanup(struct beiscsi_hba *phba)
 	for (i = 0; i < phba->params.cxns_per_ctrl; i++) {
 		q = &phwi_context->be_wrbq[i];
 		if (q->created)
-			be_cmd_q_destroy(ctrl, q, QTYPE_WRBQ);
+			beiscsi_cmd_q_destroy(ctrl, q, QTYPE_WRBQ);
 	}
 
 	free_wrb_handles(phba);
 
 	q = &phwi_context->be_def_hdrq;
 	if (q->created)
-		be_cmd_q_destroy(ctrl, q, QTYPE_DPDUQ);
+		beiscsi_cmd_q_destroy(ctrl, q, QTYPE_DPDUQ);
 
 	q = &phwi_context->be_def_dataq;
 	if (q->created)
-		be_cmd_q_destroy(ctrl, q, QTYPE_DPDUQ);
+		beiscsi_cmd_q_destroy(ctrl, q, QTYPE_DPDUQ);
 
-	be_cmd_q_destroy(ctrl, NULL, QTYPE_SGL);
+	beiscsi_cmd_q_destroy(ctrl, NULL, QTYPE_SGL);
 
 	q = &phwi_context->be_cq;
 	if (q->created)
-		be_cmd_q_destroy(ctrl, q, QTYPE_CQ);
+		beiscsi_cmd_q_destroy(ctrl, q, QTYPE_CQ);
 
 	q = &phwi_context->be_eq.q;
 	if (q->created)
-		be_cmd_q_destroy(ctrl, q, QTYPE_EQ);
+		beiscsi_cmd_q_destroy(ctrl, q, QTYPE_EQ);
 }
 
 static int hwi_init_port(struct beiscsi_hba *phba)
@@ -2886,7 +2887,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 	io_task->pwrb_handle->pio_handle = task;
 	io_task->conn = beiscsi_conn;
 
-	task->hdr = (struct iscsi_hdr *)&io_task->cmd_bhs.iscsi_hdr;
+	task->hdr = (struct iscsi_hdr *)&io_task->cmd_bhs->iscsi_hdr;
 	task->hdr_max = sizeof(struct be_cmd_bhs);
 
 	if (task->sc) {
@@ -2950,7 +2951,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 	}
 	itt = (itt_t) cpu_to_be32(((unsigned int)task->itt << 16) |
 			(unsigned int)(io_task->psgl_handle->sgl_index));
-	io_task->cmd_bhs.iscsi_hdr.itt = itt;
+	io_task->cmd_bhs->iscsi_hdr.itt = itt;
 	return 0;
 }
 
@@ -3003,21 +3004,20 @@ static int beiscsi_iotask(struct iscsi_task *task, struct scatterlist *sg,
 
 	pwrb = io_task->pwrb_handle->pwrb;
 
-	io_task->cmd_bhs.iscsi_hdr.exp_statsn = 0;
+	io_task->cmd_bhs->iscsi_hdr.exp_statsn = 0;
 	io_task->bhs_len = sizeof(struct be_cmd_bhs);
-	io_task->bhs_pa.u.a64.address = virt_to_bus(&io_task->cmd_bhs);
 
 	if (writedir) {
 		SE_DEBUG(DBG_LVL_4, " WRITE Command \t");
-		memset(&io_task->cmd_bhs.iscsi_data_pdu, 0, 48);
+		memset(&io_task->cmd_bhs->iscsi_data_pdu, 0, 48);
 		AMAP_SET_BITS(struct amap_pdu_data_out, itt,
-			      &io_task->cmd_bhs.iscsi_data_pdu,
-			      (unsigned int)io_task->cmd_bhs.iscsi_hdr.itt);
+			      &io_task->cmd_bhs->iscsi_data_pdu,
+			      (unsigned int)io_task->cmd_bhs->iscsi_hdr.itt);
 		AMAP_SET_BITS(struct amap_pdu_data_out, opcode,
-			      &io_task->cmd_bhs.iscsi_data_pdu,
+			      &io_task->cmd_bhs->iscsi_data_pdu,
 			      ISCSI_OPCODE_SCSI_DATA_OUT);
 		AMAP_SET_BITS(struct amap_pdu_data_out, final_bit,
-			      &io_task->cmd_bhs.iscsi_data_pdu, 1);
+			      &io_task->cmd_bhs->iscsi_data_pdu, 1);
 		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb, INI_WR_CMD);
 		AMAP_SET_BITS(struct amap_iscsi_wrb, dsp, pwrb, 1);
 
@@ -3026,12 +3026,12 @@ static int beiscsi_iotask(struct iscsi_task *task, struct scatterlist *sg,
 		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb, INI_RD_CMD);
 		AMAP_SET_BITS(struct amap_iscsi_wrb, dsp, pwrb, 0);
 	}
-	memcpy(&io_task->cmd_bhs.iscsi_data_pdu.
+	memcpy(&io_task->cmd_bhs->iscsi_data_pdu.
 	       dw[offsetof(struct amap_pdu_data_out, lun) / 32],
-	       io_task->cmd_bhs.iscsi_hdr.lun, sizeof(struct scsi_lun));
+	       io_task->cmd_bhs->iscsi_hdr.lun, sizeof(struct scsi_lun));
 
 	AMAP_SET_BITS(struct amap_iscsi_wrb, lun, pwrb,
-		      cpu_to_be16((unsigned short)io_task->cmd_bhs.iscsi_hdr.
+		      cpu_to_be16((unsigned short)io_task->cmd_bhs->iscsi_hdr.
 				  lun[0]));
 	AMAP_SET_BITS(struct amap_iscsi_wrb, r2t_exp_dtl, pwrb, xferlen);
 	AMAP_SET_BITS(struct amap_iscsi_wrb, wrb_idx, pwrb,
@@ -3325,7 +3325,7 @@ struct iscsi_transport beiscsi_iscsi_transport = {
 	.host_param_mask = ISCSI_HOST_HWADDRESS | ISCSI_HOST_IPADDRESS |
 				ISCSI_HOST_INITIATOR_NAME,
 	.create_session = beiscsi_session_create,
-	.destroy_session = iscsi_session_teardown,
+	.destroy_session = beiscsi_session_destroy,
 	.create_conn = beiscsi_conn_create,
 	.bind_conn = beiscsi_conn_bind,
 	.destroy_conn = iscsi_conn_teardown,
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 2c5022e..2520c39 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -386,7 +386,8 @@ struct beiscsi_io_task {
 	unsigned short cid;
 	unsigned short header_len;
 
-	struct be_cmd_bhs cmd_bhs;
+	unsigned int alloc_size;
+	struct be_cmd_bhs *cmd_bhs;
 	struct be_bus_address bhs_pa;
 	unsigned short bhs_len;
 };
-- 
1.6.4

