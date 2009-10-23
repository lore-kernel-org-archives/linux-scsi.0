From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 2/2] be2iscsi: Adding Ring Mode Wrb's V3
Date: Fri, 23 Oct 2009 11:53:49 +0530
Message-ID: <20091023062338.GA3468@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:38748 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751879AbZJWGXh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Oct 2009 02:23:37 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu

 This patch adds support for ring based wrbs

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_cmds.c |    6 +-
 drivers/scsi/be2iscsi/be_cmds.h |    2 +-
 drivers/scsi/be2iscsi/be_main.c |  209 ++++++++++++++++++++++++++++++--------
 3 files changed, 169 insertions(+), 48 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 10f8fe7..698a527 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -125,7 +125,7 @@ static void beiscsi_cq_notify(struct beiscsi_hba *phba, u16 qid, bool arm,
 }
 
 
-int be_process_mcc(struct beiscsi_hba *phba)
+int beiscsi_process_mcc(struct beiscsi_hba *phba)
 {
 	struct be_mcc_compl *compl;
 	int num = 0, status = 0;
@@ -161,7 +161,7 @@ static int be_mcc_wait_compl(struct beiscsi_hba *phba)
 #define mcc_timeout		120000 /* 5s timeout */
 	int i, status;
 	for (i = 0; i < mcc_timeout; i++) {
-		status = be_process_mcc(phba);
+		status = beiscsi_process_mcc(phba);
 		if (status)
 			return status;
 
@@ -504,7 +504,7 @@ static u32 be_encoded_q_len(int q_len)
 	return len_encoded;
 }
 
-int be_cmd_mccq_create(struct beiscsi_hba *phba,
+int beiscsi_cmd_mccq_create(struct beiscsi_hba *phba,
 			struct be_queue_info *mccq,
 			struct be_queue_info *cq)
 {
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 76fe1f9..5de8acb 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -418,7 +418,7 @@ int beiscsi_cmd_cq_create(struct be_ctrl_info *ctrl,
 
 int beiscsi_cmd_q_destroy(struct be_ctrl_info *ctrl, struct be_queue_info *q,
 			  int type);
-int be_cmd_mccq_create(struct beiscsi_hba *phba,
+int beiscsi_cmd_mccq_create(struct beiscsi_hba *phba,
 			struct be_queue_info *mccq,
 			struct be_queue_info *cq);
 
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 2c3e99e..d15df07 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -40,6 +40,7 @@
 static unsigned int be_iopoll_budget = 10;
 static unsigned int be_max_phys_size = 64;
 static unsigned int enable_msix = 1;
+static unsigned int ring_mode;
 
 MODULE_DEVICE_TABLE(pci, beiscsi_pci_id_table);
 MODULE_DESCRIPTION(DRV_DESC " " BUILD_STR);
@@ -670,8 +671,9 @@ static void
 free_wrb_handle(struct beiscsi_hba *phba, struct hwi_wrb_context *pwrb_context,
 		struct wrb_handle *pwrb_handle)
 {
-
-	pwrb_context->pwrb_handle_base[pwrb_context->free_index] = pwrb_handle;
+	if (!ring_mode)
+		pwrb_context->pwrb_handle_base[pwrb_context->free_index] =
+					       pwrb_handle;
 	pwrb_context->wrb_handles_available++;
 	if (pwrb_context->free_index == (phba->params.wrbs_per_cxn - 1))
 		pwrb_context->free_index = 0;
@@ -857,6 +859,7 @@ hwi_complete_drvr_msgs(struct beiscsi_conn *beiscsi_conn,
 {
 	struct hwi_wrb_context *pwrb_context;
 	struct wrb_handle *pwrb_handle = NULL;
+	struct sgl_handle *psgl_handle = NULL;
 	struct hwi_controller *phwi_ctrlr;
 	struct iscsi_task *task;
 	struct beiscsi_io_task *io_task;
@@ -864,13 +867,23 @@ hwi_complete_drvr_msgs(struct beiscsi_conn *beiscsi_conn,
 	struct iscsi_session *session = conn->session;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
-	pwrb_context = &phwi_ctrlr->wrb_context[((psol->
-			dw[offsetof(struct amap_sol_cqe, cid) / 32] &
-			SOL_CID_MASK) >> 6)];
-	pwrb_handle = pwrb_context->pwrb_handle_basestd[((psol->
-			dw[offsetof(struct amap_sol_cqe, wrb_index) /
-			32] & SOL_WRB_INDEX_MASK) >> 16)];
-	task = pwrb_handle->pio_handle;
+	if (ring_mode) {
+		psgl_handle = phba->sgl_hndl_array[((psol->
+			      dw[offsetof(struct amap_sol_cqe_ring, icd_index) /
+				32] & SOL_ICD_INDEX_MASK) >> 6)];
+		pwrb_context = &phwi_ctrlr->wrb_context[psgl_handle->cid];
+		task = psgl_handle->task;
+		pwrb_handle = NULL;
+	} else {
+		pwrb_context = &phwi_ctrlr->wrb_context[((psol->
+				dw[offsetof(struct amap_sol_cqe, cid) / 32] &
+				SOL_CID_MASK) >> 6)];
+		pwrb_handle = pwrb_context->pwrb_handle_basestd[((psol->
+				dw[offsetof(struct amap_sol_cqe, wrb_index) /
+				32] & SOL_WRB_INDEX_MASK) >> 16)];
+		task = pwrb_handle->pio_handle;
+	}
+
 	io_task = task->dd_data;
 	spin_lock(&phba->mgmt_sgl_lock);
 	free_mgmt_sgl_handle(phba, io_task->psgl_handle);
@@ -910,23 +923,31 @@ static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 	struct iscsi_wrb *pwrb = NULL;
 	struct hwi_controller *phwi_ctrlr;
 	struct iscsi_task *task;
+	struct sgl_handle *psgl_handle = NULL;
 	unsigned int type;
 	struct iscsi_conn *conn = beiscsi_conn->conn;
 	struct iscsi_session *session = conn->session;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
-	pwrb_context = &phwi_ctrlr->
-			wrb_context[((psol->dw[offsetof
-			(struct amap_sol_cqe, cid) / 32]
-			& SOL_CID_MASK) >> 6)];
-	pwrb_handle = pwrb_context->pwrb_handle_basestd[((psol->
-			dw[offsetof(struct amap_sol_cqe, wrb_index) /
-			32] & SOL_WRB_INDEX_MASK) >> 16)];
-	task = pwrb_handle->pio_handle;
-	pwrb = pwrb_handle->pwrb;
-	type = (pwrb->dw[offsetof(struct amap_iscsi_wrb, type) / 32] &
+	if (ring_mode) {
+		psgl_handle = phba->sgl_hndl_array[((psol->
+			      dw[offsetof(struct amap_sol_cqe_ring, icd_index) /
+			      32] & SOL_ICD_INDEX_MASK) >> 6)];
+		task = psgl_handle->task;
+		type = psgl_handle->type;
+	} else {
+		pwrb_context = &phwi_ctrlr->
+				wrb_context[((psol->dw[offsetof
+				(struct amap_sol_cqe, cid) / 32]
+				& SOL_CID_MASK) >> 6)];
+		pwrb_handle = pwrb_context->pwrb_handle_basestd[((psol->
+				dw[offsetof(struct amap_sol_cqe, wrb_index) /
+				32] & SOL_WRB_INDEX_MASK) >> 16)];
+		task = pwrb_handle->pio_handle;
+		pwrb = pwrb_handle->pwrb;
+		type = (pwrb->dw[offsetof(struct amap_iscsi_wrb, type) / 32] &
 			 WRB_TYPE_MASK) >> 28;
-
+	}
 	spin_lock_bh(&session->lock);
 	switch (type) {
 	case HWH_TYPE_IO:
@@ -957,15 +978,24 @@ static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 		break;
 
 	default:
-		shost_printk(KERN_WARNING, phba->shost,
-			"In hwi_complete_cmd, unknown type = %d"
-			"wrb_index 0x%x CID 0x%x\n", type,
-			((psol->dw[offsetof(struct amap_iscsi_wrb,
-			type) / 32] & SOL_WRB_INDEX_MASK) >> 16),
-			((psol->dw[offsetof(struct amap_sol_cqe,
-			cid) / 32] & SOL_CID_MASK) >> 6));
+		if (ring_mode)
+			shost_printk(KERN_WARNING, phba->shost,
+				"In hwi_complete_cmd, unknown type = %d"
+				"icd_index 0x%x CID 0x%x\n", type,
+				((psol->dw[offsetof(struct amap_sol_cqe_ring,
+				icd_index) / 32] & SOL_ICD_INDEX_MASK) >> 6),
+				psgl_handle->cid);
+		else
+			shost_printk(KERN_WARNING, phba->shost,
+				"In hwi_complete_cmd, unknown type = %d"
+				"wrb_index 0x%x CID 0x%x\n", type,
+				((psol->dw[offsetof(struct amap_iscsi_wrb,
+				type) / 32] & SOL_WRB_INDEX_MASK) >> 16),
+				((psol->dw[offsetof(struct amap_sol_cqe,
+				cid) / 32] & SOL_CID_MASK) >> 6));
 		break;
 	}
+
 	spin_unlock_bh(&session->lock);
 }
 
@@ -1401,6 +1431,7 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 	unsigned int num_processed = 0;
 	unsigned int tot_nump = 0;
 	struct beiscsi_conn *beiscsi_conn;
+	struct sgl_handle *psgl_handle = NULL;
 	struct beiscsi_hba *phba;
 
 	cq = pbe_eq->cq;
@@ -1411,17 +1442,32 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 	       CQE_VALID_MASK) {
 		be_dws_le_to_cpu(sol, sizeof(struct sol_cqe));
 
-		beiscsi_conn = phba->conn_table[(u32) (sol->
+		if (ring_mode) {
+			psgl_handle = phba->sgl_hndl_array[((sol->
+				      dw[offsetof(struct amap_sol_cqe_ring,
+				      icd_index) / 32] & SOL_ICD_INDEX_MASK)
+				      >> 6)];
+			beiscsi_conn = phba->conn_table[psgl_handle->cid];
+			if (!beiscsi_conn || !beiscsi_conn->ep) {
+				shost_printk(KERN_WARNING, phba->shost,
+				     "Connection table empty for cid = %d\n",
+				      psgl_handle->cid);
+				return 0;
+			}
+
+		} else {
+			beiscsi_conn = phba->conn_table[(u32) (sol->
 				 dw[offsetof(struct amap_sol_cqe, cid) / 32] &
 				 SOL_CID_MASK) >> 6];
 
-		if (!beiscsi_conn || !beiscsi_conn->ep) {
-			shost_printk(KERN_WARNING, phba->shost,
+			if (!beiscsi_conn || !beiscsi_conn->ep) {
+				shost_printk(KERN_WARNING, phba->shost,
 				     "Connection table empty for cid = %d\n",
 				     (u32)(sol->dw[offsetof(struct amap_sol_cqe,
 				     cid) / 32] & SOL_CID_MASK) >> 6);
 				return 0;
 			}
+		}
 
 		if (num_processed >= 32) {
 			hwi_ring_cq_db(phba, cq->id,
@@ -1465,13 +1511,21 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 		case CMD_CXN_KILLED_ITT_INVALID:
 		case CMD_CXN_KILLED_SEQ_OUTOFORDER:
 		case CMD_CXN_KILLED_INVALID_DATASN_RCVD:
-			SE_DEBUG(DBG_LVL_1,
+			if (ring_mode) {
+				SE_DEBUG(DBG_LVL_1,
+				 "CQ Error notification for cmd.. "
+				 "code %d cid 0x%x\n",
+				 sol->dw[offsetof(struct amap_sol_cqe, code) /
+				 32] & CQE_CODE_MASK, psgl_handle->cid);
+			} else {
+				SE_DEBUG(DBG_LVL_1,
 				 "CQ Error notification for cmd.. "
 				 "code %d cid 0x%x\n",
 				 sol->dw[offsetof(struct amap_sol_cqe, code) /
 				 32] & CQE_CODE_MASK,
 				 (sol->dw[offsetof(struct amap_sol_cqe, cid) /
 				 32] & SOL_CID_MASK));
+			}
 			break;
 		case UNSOL_DATA_DIGEST_ERROR_NOTIFY:
 			SE_DEBUG(DBG_LVL_1,
@@ -1493,23 +1547,37 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 		case CXN_KILLED_OVER_RUN_RESIDUAL:
 		case CXN_KILLED_UNDER_RUN_RESIDUAL:
 		case CXN_KILLED_CMND_DATA_NOT_ON_SAME_CONN:
-			SE_DEBUG(DBG_LVL_1, "CQ Error %d, reset CID "
+			if (ring_mode) {
+				SE_DEBUG(DBG_LVL_1, "CQ Error %d, reset CID "
+				 "0x%x...\n",
+				 sol->dw[offsetof(struct amap_sol_cqe, code) /
+				 32] & CQE_CODE_MASK, psgl_handle->cid);
+			} else {
+				SE_DEBUG(DBG_LVL_1, "CQ Error %d, reset CID "
 				 "0x%x...\n",
 				 sol->dw[offsetof(struct amap_sol_cqe, code) /
 				 32] & CQE_CODE_MASK,
 				 sol->dw[offsetof(struct amap_sol_cqe, cid) /
 				 32] & CQE_CID_MASK);
+			}
 			iscsi_conn_failure(beiscsi_conn->conn,
 					   ISCSI_ERR_CONN_FAILED);
 			break;
 		case CXN_KILLED_RST_SENT:
 		case CXN_KILLED_RST_RCVD:
-			SE_DEBUG(DBG_LVL_1, "CQ Error %d, reset"
+			if (ring_mode) {
+				SE_DEBUG(DBG_LVL_1, "CQ Error %d, reset"
+				"received/sent on CID 0x%x...\n",
+				 sol->dw[offsetof(struct amap_sol_cqe, code) /
+				 32] & CQE_CODE_MASK, psgl_handle->cid);
+			} else {
+				SE_DEBUG(DBG_LVL_1, "CQ Error %d, reset"
 				"received/sent on CID 0x%x...\n",
 				 sol->dw[offsetof(struct amap_sol_cqe, code) /
 				 32] & CQE_CODE_MASK,
 				 sol->dw[offsetof(struct amap_sol_cqe, cid) /
 				 32] & CQE_CID_MASK);
+			}
 			iscsi_conn_failure(beiscsi_conn->conn,
 					   ISCSI_ERR_CONN_FAILED);
 			break;
@@ -2674,7 +2742,7 @@ static int be_mcc_queues_create(struct beiscsi_hba *phba,
 		goto mcc_cq_destroy;
 
 	/* Ask BE to create MCC queue */
-	if (be_cmd_mccq_create(phba, q, cq))
+	if (beiscsi_cmd_mccq_create(phba, q, cq))
 		goto mcc_q_free;
 
 	return 0;
@@ -2735,6 +2803,10 @@ static int hwi_init_port(struct beiscsi_hba *phba)
 		goto error;
 	}
 
+	if (phba->fw_config.iscsi_features == 0x1)
+		ring_mode = 1;
+	else
+		ring_mode = 0;
 	status = mgmt_get_fw_config(ctrl, phba);
 	if (status != 0) {
 		shost_printk(KERN_ERR, phba->shost,
@@ -2869,6 +2941,17 @@ static int beiscsi_init_sgl_handle(struct beiscsi_hba *phba)
 	phba->io_sgl_hndl_avbl = 0;
 	phba->eh_sgl_hndl_avbl = 0;
 
+	if (ring_mode) {
+		phba->sgl_hndl_array = kzalloc(sizeof(struct sgl_handle *) *
+					      phba->params.icds_per_ctrl,
+						 GFP_KERNEL);
+		if (!phba->sgl_hndl_array) {
+			shost_printk(KERN_ERR, phba->shost,
+			     "Mem Alloc Failed. Failing to load\n");
+			return -ENOMEM;
+		}
+	}
+
 	mem_descr_sglh = phba->init_mem;
 	mem_descr_sglh += HWI_MEM_SGLH;
 	if (1 == mem_descr_sglh->num_elements) {
@@ -2876,6 +2959,8 @@ static int beiscsi_init_sgl_handle(struct beiscsi_hba *phba)
 						 phba->params.ios_per_ctrl,
 						 GFP_KERNEL);
 		if (!phba->io_sgl_hndl_base) {
+			if (ring_mode)
+				kfree(phba->sgl_hndl_array);
 			shost_printk(KERN_ERR, phba->shost,
 				     "Mem Alloc Failed. Failing to load\n");
 			return -ENOMEM;
@@ -3060,6 +3145,8 @@ static int beiscsi_init_port(struct beiscsi_hba *phba)
 	if (hba_setup_cid_tbls(phba)) {
 		shost_printk(KERN_ERR, phba->shost,
 			     "Failed in hba_setup_cid_tbls\n");
+		if (ring_mode)
+			kfree(phba->sgl_hndl_array);
 		kfree(phba->io_sgl_hndl_base);
 		kfree(phba->eh_sgl_hndl_base);
 		goto do_cleanup_ctrlr;
@@ -3110,6 +3197,8 @@ static void beiscsi_clean_port(struct beiscsi_hba *phba)
 			     "mgmt_epfw_cleanup FAILED \n");
 	hwi_cleanup(phba);
 	hwi_purge_eq(phba);
+	if (ring_mode)
+		kfree(phba->sgl_hndl_array);
 	kfree(phba->io_sgl_hndl_base);
 	kfree(phba->eh_sgl_hndl_base);
 	kfree(phba->cid_array);
@@ -3194,7 +3283,8 @@ beiscsi_offload_connection(struct beiscsi_conn *beiscsi_conn,
 	be_dws_le_to_cpu(pwrb, sizeof(struct iscsi_target_context_update_wrb));
 
 	doorbell |= beiscsi_conn->beiscsi_conn_cid & DB_WRB_POST_CID_MASK;
-	doorbell |= (pwrb_handle->wrb_index & DB_DEF_PDU_WRB_INDEX_MASK)
+	if (!ring_mode)
+		doorbell |= (pwrb_handle->wrb_index & DB_DEF_PDU_WRB_INDEX_MASK)
 			     << DB_DEF_PDU_WRB_INDEX_SHIFT;
 	doorbell |= 1 << DB_DEF_PDU_NUM_POSTED_SHIFT;
 
@@ -3280,7 +3370,14 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 	itt = (itt_t) cpu_to_be32(((unsigned int)io_task->pwrb_handle->
 				 wrb_index << 16) | (unsigned int)
 				(io_task->psgl_handle->sgl_index));
-	io_task->pwrb_handle->pio_handle = task;
+	if (ring_mode) {
+		phba->sgl_hndl_array[io_task->psgl_handle->sgl_index -
+				     phba->fw_config.iscsi_cid_start] =
+				     io_task->psgl_handle;
+		io_task->psgl_handle->task = task;
+		io_task->psgl_handle->cid = beiscsi_conn->beiscsi_conn_cid;
+	} else
+		io_task->pwrb_handle->pio_handle = task;
 
 	io_task->cmd_bhs->iscsi_hdr.itt = itt;
 	return 0;
@@ -3363,11 +3460,17 @@ static int beiscsi_iotask(struct iscsi_task *task, struct scatterlist *sg,
 			      ISCSI_OPCODE_SCSI_DATA_OUT);
 		AMAP_SET_BITS(struct amap_pdu_data_out, final_bit,
 			      &io_task->cmd_bhs->iscsi_data_pdu, 1);
-		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
+		if (ring_mode)
+			io_task->psgl_handle->type = INI_WR_CMD;
+		else
+			AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
 				      INI_WR_CMD);
 		AMAP_SET_BITS(struct amap_iscsi_wrb, dsp, pwrb, 1);
 	} else {
-		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
+		if (ring_mode)
+			io_task->psgl_handle->type = INI_RD_CMD;
+		else
+			AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
 				      INI_RD_CMD);
 		AMAP_SET_BITS(struct amap_iscsi_wrb, dsp, pwrb, 0);
 	}
@@ -3393,7 +3496,8 @@ static int beiscsi_iotask(struct iscsi_task *task, struct scatterlist *sg,
 	be_dws_le_to_cpu(pwrb, sizeof(struct iscsi_wrb));
 
 	doorbell |= beiscsi_conn->beiscsi_conn_cid & DB_WRB_POST_CID_MASK;
-	doorbell |= (io_task->pwrb_handle->wrb_index &
+	if (!ring_mode)
+		doorbell |= (io_task->pwrb_handle->wrb_index &
 		     DB_DEF_PDU_WRB_INDEX_MASK) << DB_DEF_PDU_WRB_INDEX_SHIFT;
 	doorbell |= 1 << DB_DEF_PDU_NUM_POSTED_SHIFT;
 
@@ -3427,19 +3531,28 @@ static int beiscsi_mtask(struct iscsi_task *task)
 
 	switch (task->hdr->opcode & ISCSI_OPCODE_MASK) {
 	case ISCSI_OP_LOGIN:
-		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
+		if (ring_mode)
+			io_task->psgl_handle->type = TGT_DM_CMD;
+		else
+			AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
 				      TGT_DM_CMD);
 		AMAP_SET_BITS(struct amap_iscsi_wrb, dmsg, pwrb, 0);
 		AMAP_SET_BITS(struct amap_iscsi_wrb, cmdsn_itt, pwrb, 1);
 		hwi_write_buffer(pwrb, task);
 		break;
 	case ISCSI_OP_NOOP_OUT:
-		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
+		if (ring_mode)
+			io_task->psgl_handle->type = INI_RD_CMD;
+		else
+			AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
 				      INI_RD_CMD);
 		hwi_write_buffer(pwrb, task);
 		break;
 	case ISCSI_OP_TEXT:
-		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
+		if (ring_mode)
+			io_task->psgl_handle->type = INI_WR_CMD;
+		else
+			AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
 				      INI_WR_CMD);
 		AMAP_SET_BITS(struct amap_iscsi_wrb, dsp, pwrb, 1);
 		hwi_write_buffer(pwrb, task);
@@ -3462,13 +3575,19 @@ static int beiscsi_mtask(struct iscsi_task *task)
 		mgmt_invalidate_icds(phba,
 				     aborted_io_task->psgl_handle->sgl_index,
 				     cid);
-		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
+		if (ring_mode)
+			io_task->psgl_handle->type = INI_TMF_CMD;
+		else
+			AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
 				      INI_TMF_CMD);
 		AMAP_SET_BITS(struct amap_iscsi_wrb, dmsg, pwrb, 0);
 		hwi_write_buffer(pwrb, task);
 		break;
 	case ISCSI_OP_LOGOUT:
 		AMAP_SET_BITS(struct amap_iscsi_wrb, dmsg, pwrb, 0);
+		if (ring_mode)
+			io_task->psgl_handle->type = HWH_TYPE_LOGOUT;
+		else
 		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
 				HWH_TYPE_LOGOUT);
 		hwi_write_buffer(pwrb, task);
@@ -3487,7 +3606,8 @@ static int beiscsi_mtask(struct iscsi_task *task)
 	be_dws_le_to_cpu(pwrb, sizeof(struct iscsi_wrb));
 
 	doorbell |= cid & DB_WRB_POST_CID_MASK;
-	doorbell |= (io_task->pwrb_handle->wrb_index &
+	if (!ring_mode)
+		doorbell |= (io_task->pwrb_handle->wrb_index &
 		     DB_DEF_PDU_WRB_INDEX_MASK) << DB_DEF_PDU_WRB_INDEX_SHIFT;
 	doorbell |= 1 << DB_DEF_PDU_NUM_POSTED_SHIFT;
 	iowrite32(doorbell, phba->db_va + DB_TXULP0_OFFSET);
@@ -3797,6 +3917,7 @@ static int __init beiscsi_module_init(void)
 			 "beiscsi pci driver.\n");
 		goto unregister_iscsi_transport;
 	}
+	ring_mode = 0;
 	return 0;
 
 unregister_iscsi_transport:
-- 
1.6.4

