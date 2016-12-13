From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v2 08/13] be2iscsi: Remove unused struct members
Date: Tue, 13 Dec 2016 15:56:01 +0530
Message-ID: <1481624766-13846-9-git-send-email-jitendra.bhivare@broadcom.com>
References: <1481624766-13846-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:36411 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932220AbcLMK1G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2016 05:27:06 -0500
Received: by mail-qt0-f177.google.com with SMTP id w33so102121047qtc.3
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2016 02:27:05 -0800 (PST)
In-Reply-To: <1481624766-13846-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Fix errors reported in static analysis.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be.h       |  3 --
 drivers/scsi/be2iscsi/be_cmds.c  |  8 +++---
 drivers/scsi/be2iscsi/be_cmds.h  | 17 ++++++------
 drivers/scsi/be2iscsi/be_iscsi.c |  2 +-
 drivers/scsi/be2iscsi/be_main.c  | 24 +++-------------
 drivers/scsi/be2iscsi/be_main.h  | 22 ---------------
 drivers/scsi/be2iscsi/be_mgmt.c  |  9 ++----
 drivers/scsi/be2iscsi/be_mgmt.h  | 60 ----------------------------------------
 8 files changed, 21 insertions(+), 124 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be.h b/drivers/scsi/be2iscsi/be.h
index b1d0fdc..ca9440f 100644
--- a/drivers/scsi/be2iscsi/be.h
+++ b/drivers/scsi/be2iscsi/be.h
@@ -84,7 +84,6 @@ static inline void queue_tail_inc(struct be_queue_info *q)
 /*ISCSI */
 
 struct be_aic_obj {		/* Adaptive interrupt coalescing (AIC) info */
-	bool enable;
 	u32 min_eqd;		/* in usecs */
 	u32 max_eqd;		/* in usecs */
 	u32 prev_eqd;		/* in usecs */
@@ -94,8 +93,6 @@ struct be_aic_obj {		/* Adaptive interrupt coalescing (AIC) info */
 };
 
 struct be_eq_obj {
-	bool todo_mcc_cq;
-	bool todo_cq;
 	u32 cq_count;
 	struct be_queue_info q;
 	struct beiscsi_hba *phba;
diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 94aae45..5d59e263 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -676,10 +676,10 @@ void be_wrb_hdr_prepare(struct be_mcc_wrb *wrb, int payload_len,
 				bool embedded, u8 sge_cnt)
 {
 	if (embedded)
-		wrb->embedded |= MCC_WRB_EMBEDDED_MASK;
+		wrb->emb_sgecnt_special |= MCC_WRB_EMBEDDED_MASK;
 	else
-		wrb->embedded |= (sge_cnt & MCC_WRB_SGE_CNT_MASK) <<
-						MCC_WRB_SGE_CNT_SHIFT;
+		wrb->emb_sgecnt_special |= (sge_cnt & MCC_WRB_SGE_CNT_MASK) <<
+					   MCC_WRB_SGE_CNT_SHIFT;
 	wrb->payload_length = payload_len;
 	be_dws_cpu_to_le(wrb, 8);
 }
@@ -1599,7 +1599,7 @@ int beiscsi_cmd_function_reset(struct beiscsi_hba *phba)
 {
 	struct be_ctrl_info *ctrl = &phba->ctrl;
 	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
-	struct be_post_sgl_pages_req *req = embedded_payload(wrb);
+	struct be_post_sgl_pages_req *req;
 	int status;
 
 	mutex_lock(&ctrl->mbox_lock);
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 328fb5b..1d40e83 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -31,10 +31,16 @@ struct be_sge {
 	__le32 len;
 };
 
-#define MCC_WRB_SGE_CNT_SHIFT 3	/* bits 3 - 7 of dword 0 */
-#define MCC_WRB_SGE_CNT_MASK 0x1F	/* bits 3 - 7 of dword 0 */
 struct be_mcc_wrb {
-	u32 embedded;		/* dword 0 */
+	u32 emb_sgecnt_special;	/* dword 0 */
+	/* bits 0 - embedded    */
+	/* bits 1 - 2 reserved	*/
+	/* bits 3 - 7 sge count	*/
+	/* bits 8 - 23 reserved	*/
+	/* bits 24 - 31 special	*/
+#define MCC_WRB_EMBEDDED_MASK 1
+#define MCC_WRB_SGE_CNT_SHIFT 3
+#define MCC_WRB_SGE_CNT_MASK 0x1F
 	u32 payload_length;	/* dword 1 */
 	u32 tag0;		/* dword 2 */
 	u32 tag1;		/* dword 3 */
@@ -1133,11 +1139,6 @@ struct tcp_connect_and_offload_out {
 
 } __packed;
 
-struct be_mcc_wrb_context {
-	struct MCC_WRB *wrb;
-	int *users_final_status;
-} __packed;
-
 #define DB_DEF_PDU_RING_ID_MASK	0x3FFF	/* bits 0 - 13 */
 #define DB_DEF_PDU_CQPROC_MASK		0x3FFF	/* bits 16 - 29 */
 #define DB_DEF_PDU_REARM_SHIFT		14
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index ba25821..0ec0625 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -1114,7 +1114,7 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 	nonemb_cmd.size = req_memsize;
 	memset(nonemb_cmd.va, 0, nonemb_cmd.size);
 	tag = mgmt_open_connection(phba, dst_addr, beiscsi_ep, &nonemb_cmd);
-	if (tag <= 0) {
+	if (!tag) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
 			    "BS_%d : mgmt_open_connection Failed for cid=%d\n",
 			    beiscsi_ep->ep_cid);
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index c6af6e5..a8e67c6 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -67,8 +67,6 @@ beiscsi_##_name##_disp(struct device *dev,\
 {	\
 	struct Scsi_Host *shost = class_to_shost(dev);\
 	struct beiscsi_hba *phba = iscsi_host_priv(shost); \
-	uint32_t param_val = 0;	\
-	param_val = phba->attr_##_name;\
 	return snprintf(buf, PAGE_SIZE, "%d\n",\
 			phba->attr_##_name);\
 }
@@ -642,7 +640,6 @@ static void beiscsi_get_params(struct beiscsi_hba *phba)
 	phba->params.num_sge_per_io = BE2_SGE;
 	phba->params.defpdu_hdr_sz = BE2_DEFPDU_HDR_SZ;
 	phba->params.defpdu_data_sz = BE2_DEFPDU_DATA_SZ;
-	phba->params.eq_timer = 64;
 	phba->params.num_eq_entries = 1024;
 	phba->params.num_cq_entries = 1024;
 	phba->params.wrbs_per_cxn = 256;
@@ -1335,7 +1332,6 @@ static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 	struct hwi_wrb_context *pwrb_context;
 	struct hwi_controller *phwi_ctrlr;
 	struct wrb_handle *pwrb_handle;
-	struct iscsi_wrb *pwrb = NULL;
 	struct iscsi_task *task;
 	uint16_t cri_index = 0;
 	uint8_t type;
@@ -1357,7 +1353,6 @@ static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 		spin_unlock_bh(&session->back_lock);
 		return;
 	}
-	pwrb = pwrb_handle->pwrb;
 	type = ((struct beiscsi_io_task *)task->dd_data)->wrb_type;
 
 	switch (type) {
@@ -1721,13 +1716,12 @@ beiscsi_hdq_post_handles(struct beiscsi_hba *phba,
 	struct list_head *hfree_list;
 	struct phys_addr *pasync_sge;
 	u32 ring_id, doorbell = 0;
-	u16 index, num_entries;
 	u32 doorbell_offset;
 	u16 prod = 0, cons;
+	u16 index;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
 	pasync_ctx = HWI_GET_ASYNC_PDU_CTX(phwi_ctrlr, ulp_num);
-	num_entries = pasync_ctx->num_entries;
 	if (header) {
 		cons = pasync_ctx->async_header.free_entries;
 		hfree_list = &pasync_ctx->async_header.free_list;
@@ -2384,13 +2378,10 @@ static int hwi_write_buffer(struct iscsi_wrb *pwrb, struct iscsi_task *task)
 static void beiscsi_find_mem_req(struct beiscsi_hba *phba)
 {
 	uint8_t mem_descr_index, ulp_num;
-	unsigned int num_cq_pages, num_async_pdu_buf_pages;
+	unsigned int num_async_pdu_buf_pages;
 	unsigned int num_async_pdu_data_pages, wrb_sz_per_cxn;
 	unsigned int num_async_pdu_buf_sgl_pages, num_async_pdu_data_sgl_pages;
 
-	num_cq_pages = PAGES_REQUIRED(phba->params.num_cq_entries * \
-				      sizeof(struct sol_cqe));
-
 	phba->params.hwi_ws_sz = sizeof(struct hwi_controller);
 
 	phba->mem_req[ISCSI_MEM_GLOBAL_HEADER] = 2 *
@@ -3377,7 +3368,7 @@ beiscsi_create_wrb_rings(struct beiscsi_hba *phba,
 			 struct hwi_context_memory *phwi_context,
 			 struct hwi_controller *phwi_ctrlr)
 {
-	unsigned int wrb_mem_index, offset, size, num_wrb_rings;
+	unsigned int num_wrb_rings;
 	u64 pa_addr_lo;
 	unsigned int idx, num, i, ulp_num;
 	struct mem_array *pwrb_arr;
@@ -3442,10 +3433,6 @@ beiscsi_create_wrb_rings(struct beiscsi_hba *phba,
 		}
 
 	for (i = 0; i < phba->params.cxns_per_ctrl; i++) {
-		wrb_mem_index = 0;
-		offset = 0;
-		size = 0;
-
 		if (ulp_count > 1) {
 			ulp_base_num = (ulp_base_num + 1) % BEISCSI_ULP_COUNT;
 
@@ -3673,7 +3660,6 @@ static void hwi_cleanup_port(struct beiscsi_hba *phba)
 	struct be_ctrl_info *ctrl = &phba->ctrl;
 	struct hwi_controller *phwi_ctrlr;
 	struct hwi_context_memory *phwi_context;
-	struct hd_async_context *pasync_ctx;
 	int i, eq_for_mcc, ulp_num;
 
 	for (ulp_num = 0; ulp_num < BEISCSI_ULP_COUNT; ulp_num++)
@@ -3710,8 +3696,6 @@ static void hwi_cleanup_port(struct beiscsi_hba *phba)
 			q = &phwi_context->be_def_dataq[ulp_num];
 			if (q->created)
 				beiscsi_cmd_q_destroy(ctrl, q, QTYPE_DPDUQ);
-
-			pasync_ctx = phwi_ctrlr->phwi_ctxt->pasync_ctx[ulp_num];
 		}
 	}
 
@@ -3937,7 +3921,7 @@ static void beiscsi_free_mem(struct beiscsi_hba *phba)
 
 static int beiscsi_init_controller(struct beiscsi_hba *phba)
 {
-	int ret = -ENOMEM;
+	int ret;
 
 	ret = beiscsi_get_memory(phba);
 	if (ret < 0) {
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 8ba8c12..73cc2f7 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -243,19 +243,7 @@ struct hba_parameters {
 	unsigned int num_cq_entries;
 	unsigned int num_eq_entries;
 	unsigned int wrbs_per_cxn;
-	unsigned int crashmode;
-	unsigned int hba_num;
-
-	unsigned int mgmt_ws_sz;
 	unsigned int hwi_ws_sz;
-
-	unsigned int eto;
-	unsigned int ldto;
-
-	unsigned int dbg_flags;
-	unsigned int num_cxn;
-
-	unsigned int eq_timer;
 	/**
 	 * These are calculated from other params. They're here
 	 * for debug purposes
@@ -333,7 +321,6 @@ struct beiscsi_hba {
 	struct be_bus_address pci_pa;	/* CSR */
 	/* PCI representation of our HBA */
 	struct pci_dev *pcidev;
-	unsigned short asic_revision;
 	unsigned int num_cpus;
 	unsigned int nxt_cqid;
 	struct msix_entry msix_entries[MAX_CPUS];
@@ -354,7 +341,6 @@ struct beiscsi_hba {
 	spinlock_t io_sgl_lock;
 	spinlock_t mgmt_sgl_lock;
 	spinlock_t async_pdu_lock;
-	unsigned int age;
 	struct list_head hba_queue;
 #define BE_MAX_SESSION 2048
 #define BE_SET_CID_TO_CRI(cri_index, cid) \
@@ -523,10 +509,6 @@ struct beiscsi_io_task {
 	struct scsi_cmnd *scsi_cmnd;
 	int num_sg;
 	struct hwi_wrb_context *pwrb_context;
-	unsigned int cmd_sn;
-	unsigned int flags;
-	unsigned short cid;
-	unsigned short header_len;
 	itt_t libiscsi_itt;
 	struct be_cmd_bhs *cmd_bhs;
 	struct be_bus_address bhs_pa;
@@ -1040,10 +1022,8 @@ struct hwi_controller {
 	struct list_head io_sgl_list;
 	struct list_head eh_sgl_list;
 	struct sgl_handle *psgl_handle_base;
-	unsigned int wrb_mem_index;
 
 	struct hwi_wrb_context *wrb_context;
-	struct mcc_wrb *pmcc_wrb_base;
 	struct be_ring default_pdu_hdr[BEISCSI_ULP_COUNT];
 	struct be_ring default_pdu_data[BEISCSI_ULP_COUNT];
 	struct hwi_context_memory *phwi_ctxt;
@@ -1060,9 +1040,7 @@ enum hwh_type_enum {
 };
 
 struct wrb_handle {
-	enum hwh_type_enum type;
 	unsigned short wrb_index;
-
 	struct iscsi_task *pio_handle;
 	struct iscsi_wrb *pwrb;
 };
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 110c0d0..8acacd5e 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -66,7 +66,6 @@ unsigned int mgmt_vendor_specific_fw_cmd(struct be_ctrl_info *ctrl,
 					 struct bsg_job *job,
 					 struct be_dma_mem *nonemb_cmd)
 {
-	struct be_cmd_resp_hdr *resp;
 	struct be_mcc_wrb *wrb;
 	struct be_sge *mcc_sge;
 	unsigned int tag = 0;
@@ -76,7 +75,6 @@ unsigned int mgmt_vendor_specific_fw_cmd(struct be_ctrl_info *ctrl,
 
 	nonemb_cmd->size = job->request_payload.payload_len;
 	memset(nonemb_cmd->va, 0, nonemb_cmd->size);
-	resp = nonemb_cmd->va;
 	region =  bsg_req->rqst_data.h_vendor.vendor_cmd[1];
 	sector_size =  bsg_req->rqst_data.h_vendor.vendor_cmd[2];
 	sector =  bsg_req->rqst_data.h_vendor.vendor_cmd[3];
@@ -1022,7 +1020,6 @@ unsigned int beiscsi_boot_reopen_sess(struct beiscsi_hba *phba)
 unsigned int beiscsi_boot_get_sinfo(struct beiscsi_hba *phba)
 {
 	struct be_ctrl_info *ctrl = &phba->ctrl;
-	struct be_cmd_get_session_resp *resp;
 	struct be_cmd_get_session_req *req;
 	struct be_dma_mem *nonemb_cmd;
 	struct be_mcc_wrb *wrb;
@@ -1037,7 +1034,7 @@ unsigned int beiscsi_boot_get_sinfo(struct beiscsi_hba *phba)
 	}
 
 	nonemb_cmd = &phba->boot_struct.nonemb_cmd;
-	nonemb_cmd->size = sizeof(*resp);
+	nonemb_cmd->size = sizeof(struct be_cmd_get_session_resp);
 	nonemb_cmd->va = pci_alloc_consistent(phba->ctrl.pdev,
 					      nonemb_cmd->size,
 					      &nonemb_cmd->dma);
@@ -1052,7 +1049,7 @@ unsigned int beiscsi_boot_get_sinfo(struct beiscsi_hba *phba)
 	be_wrb_hdr_prepare(wrb, sizeof(*req), false, 1);
 	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI_INI,
 			   OPCODE_ISCSI_INI_SESSION_GET_A_SESSION,
-			   sizeof(*resp));
+			   sizeof(struct be_cmd_get_session_resp));
 	req->session_handle = phba->boot_struct.s_handle;
 	sge->pa_hi = cpu_to_le32(upper_32_bits(nonemb_cmd->dma));
 	sge->pa_lo = cpu_to_le32(nonemb_cmd->dma & 0xFFFFFFFF);
@@ -1297,7 +1294,7 @@ beiscsi_phys_port_disp(struct device *dev, struct device_attribute *attr,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct beiscsi_hba *phba = iscsi_host_priv(shost);
 
-	return snprintf(buf, PAGE_SIZE, "Port Identifier : %d\n",
+	return snprintf(buf, PAGE_SIZE, "Port Identifier : %u\n",
 			phba->fw_config.phys_port);
 }
 
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index f301d57..308f147 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -36,66 +36,6 @@
 #define PCICFG_UE_STATUS_MASK_LOW       0xA8
 #define PCICFG_UE_STATUS_MASK_HI        0xAC
 
-/**
- * Pseudo amap definition in which each bit of the actual structure is defined
- * as a byte: used to calculate offset/shift/mask of each field
- */
-struct amap_mcc_sge {
-	u8 pa_lo[32];		/* dword 0 */
-	u8 pa_hi[32];		/* dword 1 */
-	u8 length[32];		/* DWORD 2 */
-} __packed;
-
-/**
- * Pseudo amap definition in which each bit of the actual structure is defined
- * as a byte: used to calculate offset/shift/mask of each field
- */
-struct amap_mcc_wrb_payload {
-	union {
-		struct amap_mcc_sge sgl[19];
-		u8 embedded[59 * 32];	/* DWORDS 57 to 115 */
-	} u;
-} __packed;
-
-/**
- * Pseudo amap definition in which each bit of the actual structure is defined
- * as a byte: used to calculate offset/shift/mask of each field
- */
-struct amap_mcc_wrb {
-	u8 embedded;		/* DWORD 0 */
-	u8 rsvd0[2];		/* DWORD 0 */
-	u8 sge_count[5];	/* DWORD 0 */
-	u8 rsvd1[16];		/* DWORD 0 */
-	u8 special[8];		/* DWORD 0 */
-	u8 payload_length[32];
-	u8 tag[64];		/* DWORD 2 */
-	u8 rsvd2[32];		/* DWORD 4 */
-	struct amap_mcc_wrb_payload payload;
-};
-
-struct mcc_sge {
-	u32 pa_lo;		/* dword 0 */
-	u32 pa_hi;		/* dword 1 */
-	u32 length;		/* DWORD 2 */
-} __packed;
-
-struct mcc_wrb_payload {
-	union {
-		struct mcc_sge sgl[19];
-		u32 embedded[59];	/* DWORDS 57 to 115 */
-	} u;
-} __packed;
-
-#define MCC_WRB_EMBEDDED_MASK                0x00000001
-
-struct mcc_wrb {
-	u32 dw[0];		/* DWORD 0 */
-	u32 payload_length;
-	u32 tag[2];		/* DWORD 2 */
-	u32 rsvd2[1];		/* DWORD 4 */
-	struct mcc_wrb_payload payload;
-};
-
 int mgmt_open_connection(struct beiscsi_hba *phba,
 			 struct sockaddr *dst_addr,
 			 struct beiscsi_endpoint *beiscsi_ep,
-- 
2.7.4

