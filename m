From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 1/8] be2iscsi:  Remove Ring mode from driver
Date: Sat, 23 Jan 2010 05:34:24 +0530
Message-ID: <20100123000413.GA12564@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:39857 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753416Ab0AWAEU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jan 2010 19:04:20 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

	Ring mode is not used. This patch removes the code.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_main.c |  181 +++++++--------------------------------
 1 files changed, 33 insertions(+), 148 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index d611a13..522e7d5 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -40,7 +40,6 @@
 static unsigned int be_iopoll_budget = 10;
 static unsigned int be_max_phys_size = 64;
 static unsigned int enable_msix = 1;
-static unsigned int ring_mode;
 
 MODULE_DEVICE_TABLE(pci, beiscsi_pci_id_table);
 MODULE_DESCRIPTION(DRV_DESC " " BUILD_STR);
@@ -671,9 +670,7 @@ static void
 free_wrb_handle(struct beiscsi_hba *phba, struct hwi_wrb_context *pwrb_context,
 		struct wrb_handle *pwrb_handle)
 {
-	if (!ring_mode)
-		pwrb_context->pwrb_handle_base[pwrb_context->free_index] =
-					       pwrb_handle;
+	pwrb_context->pwrb_handle_base[pwrb_context->free_index] = pwrb_handle;
 	pwrb_context->wrb_handles_available++;
 	if (pwrb_context->free_index == (phba->params.wrbs_per_cxn - 1))
 		pwrb_context->free_index = 0;
@@ -865,7 +862,6 @@ hwi_complete_drvr_msgs(struct beiscsi_conn *beiscsi_conn,
 {
 	struct hwi_wrb_context *pwrb_context;
 	struct wrb_handle *pwrb_handle = NULL;
-	struct sgl_handle *psgl_handle = NULL;
 	struct hwi_controller *phwi_ctrlr;
 	struct iscsi_task *task;
 	struct beiscsi_io_task *io_task;
@@ -873,23 +869,14 @@ hwi_complete_drvr_msgs(struct beiscsi_conn *beiscsi_conn,
 	struct iscsi_session *session = conn->session;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
-	if (ring_mode) {
-		psgl_handle = phba->sgl_hndl_array[((psol->
-			      dw[offsetof(struct amap_sol_cqe_ring, icd_index) /
-				32] & SOL_ICD_INDEX_MASK) >> 6)];
-		pwrb_context = &phwi_ctrlr->wrb_context[psgl_handle->cid];
-		task = psgl_handle->task;
-		pwrb_handle = NULL;
-	} else {
-		pwrb_context = &phwi_ctrlr->wrb_context[((psol->
+	pwrb_context = &phwi_ctrlr->wrb_context[((psol->
 				dw[offsetof(struct amap_sol_cqe, cid) / 32] &
 				SOL_CID_MASK) >> 6) -
 				phba->fw_config.iscsi_cid_start];
-		pwrb_handle = pwrb_context->pwrb_handle_basestd[((psol->
+	pwrb_handle = pwrb_context->pwrb_handle_basestd[((psol->
 				dw[offsetof(struct amap_sol_cqe, wrb_index) /
 				32] & SOL_WRB_INDEX_MASK) >> 16)];
-		task = pwrb_handle->pio_handle;
-	}
+	task = pwrb_handle->pio_handle;
 
 	io_task = task->dd_data;
 	spin_lock(&phba->mgmt_sgl_lock);
@@ -930,32 +917,23 @@ static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 	struct iscsi_wrb *pwrb = NULL;
 	struct hwi_controller *phwi_ctrlr;
 	struct iscsi_task *task;
-	struct sgl_handle *psgl_handle = NULL;
 	unsigned int type;
 	struct iscsi_conn *conn = beiscsi_conn->conn;
 	struct iscsi_session *session = conn->session;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
-	if (ring_mode) {
-		psgl_handle = phba->sgl_hndl_array[((psol->
-			      dw[offsetof(struct amap_sol_cqe_ring, icd_index) /
-			      32] & SOL_ICD_INDEX_MASK) >> 6)];
-		task = psgl_handle->task;
-		type = psgl_handle->type;
-	} else {
-		pwrb_context = &phwi_ctrlr->
-				wrb_context[((psol->dw[offsetof
+	pwrb_context = &phwi_ctrlr->wrb_context[((psol->dw[offsetof
 				(struct amap_sol_cqe, cid) / 32]
 				& SOL_CID_MASK) >> 6) -
 				phba->fw_config.iscsi_cid_start];
-		pwrb_handle = pwrb_context->pwrb_handle_basestd[((psol->
+	pwrb_handle = pwrb_context->pwrb_handle_basestd[((psol->
 				dw[offsetof(struct amap_sol_cqe, wrb_index) /
 				32] & SOL_WRB_INDEX_MASK) >> 16)];
-		task = pwrb_handle->pio_handle;
-		pwrb = pwrb_handle->pwrb;
-		type = (pwrb->dw[offsetof(struct amap_iscsi_wrb, type) / 32] &
-			 WRB_TYPE_MASK) >> 28;
-	}
+	task = pwrb_handle->pio_handle;
+	pwrb = pwrb_handle->pwrb;
+	type = (pwrb->dw[offsetof(struct amap_iscsi_wrb, type) / 32] &
+				 WRB_TYPE_MASK) >> 28;
+
 	spin_lock_bh(&session->lock);
 	switch (type) {
 	case HWH_TYPE_IO:
@@ -986,15 +964,7 @@ static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 		break;
 
 	default:
-		if (ring_mode)
-			shost_printk(KERN_WARNING, phba->shost,
-				"In hwi_complete_cmd, unknown type = %d"
-				"icd_index 0x%x CID 0x%x\n", type,
-				((psol->dw[offsetof(struct amap_sol_cqe_ring,
-				icd_index) / 32] & SOL_ICD_INDEX_MASK) >> 6),
-				psgl_handle->cid);
-		else
-			shost_printk(KERN_WARNING, phba->shost,
+		shost_printk(KERN_WARNING, phba->shost,
 				"In hwi_complete_cmd, unknown type = %d"
 				"wrb_index 0x%x CID 0x%x\n", type,
 				((psol->dw[offsetof(struct amap_iscsi_wrb,
@@ -1483,7 +1453,6 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 	unsigned int num_processed = 0;
 	unsigned int tot_nump = 0;
 	struct beiscsi_conn *beiscsi_conn;
-	struct sgl_handle *psgl_handle = NULL;
 	struct beiscsi_endpoint *beiscsi_ep;
 	struct iscsi_endpoint *ep;
 	struct beiscsi_hba *phba;
@@ -1496,18 +1465,11 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 	       CQE_VALID_MASK) {
 		be_dws_le_to_cpu(sol, sizeof(struct sol_cqe));
 
-		if (ring_mode) {
-			psgl_handle = phba->sgl_hndl_array[((sol->
-				      dw[offsetof(struct amap_sol_cqe_ring,
-				      icd_index) / 32] & SOL_ICD_INDEX_MASK)
-				      >> 6)];
-			ep = phba->ep_array[psgl_handle->cid];
-		} else {
-			ep = phba->ep_array[(u32) ((sol->
+		ep = phba->ep_array[(u32) ((sol->
 				   dw[offsetof(struct amap_sol_cqe, cid) / 32] &
 				   SOL_CID_MASK) >> 6) -
 				   phba->fw_config.iscsi_cid_start];
-		}
+
 		beiscsi_ep = ep->dd_data;
 		beiscsi_conn = beiscsi_ep->conn;
 
@@ -1553,21 +1515,13 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 		case CMD_CXN_KILLED_ITT_INVALID:
 		case CMD_CXN_KILLED_SEQ_OUTOFORDER:
 		case CMD_CXN_KILLED_INVALID_DATASN_RCVD:
-			if (ring_mode) {
-				SE_DEBUG(DBG_LVL_1,
-				 "CQ Error notification for cmd.. "
-				 "code %d cid 0x%x\n",
-				 sol->dw[offsetof(struct amap_sol_cqe, code) /
-				 32] & CQE_CODE_MASK, psgl_handle->cid);
-			} else {
-				SE_DEBUG(DBG_LVL_1,
+			SE_DEBUG(DBG_LVL_1,
 				 "CQ Error notification for cmd.. "
 				 "code %d cid 0x%x\n",
 				 sol->dw[offsetof(struct amap_sol_cqe, code) /
 				 32] & CQE_CODE_MASK,
 				 (sol->dw[offsetof(struct amap_sol_cqe, cid) /
 				 32] & SOL_CID_MASK));
-			}
 			break;
 		case UNSOL_DATA_DIGEST_ERROR_NOTIFY:
 			SE_DEBUG(DBG_LVL_1,
@@ -1589,37 +1543,23 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 		case CXN_KILLED_OVER_RUN_RESIDUAL:
 		case CXN_KILLED_UNDER_RUN_RESIDUAL:
 		case CXN_KILLED_CMND_DATA_NOT_ON_SAME_CONN:
-			if (ring_mode) {
-				SE_DEBUG(DBG_LVL_1, "CQ Error %d, reset CID "
-				 "0x%x...\n",
-				 sol->dw[offsetof(struct amap_sol_cqe, code) /
-				 32] & CQE_CODE_MASK, psgl_handle->cid);
-			} else {
-				SE_DEBUG(DBG_LVL_1, "CQ Error %d, reset CID "
+			SE_DEBUG(DBG_LVL_1, "CQ Error %d, reset CID "
 				 "0x%x...\n",
 				 sol->dw[offsetof(struct amap_sol_cqe, code) /
 				 32] & CQE_CODE_MASK,
 				 (sol->dw[offsetof(struct amap_sol_cqe, cid) /
 				 32] & CQE_CID_MASK));
-			}
 			iscsi_conn_failure(beiscsi_conn->conn,
 					   ISCSI_ERR_CONN_FAILED);
 			break;
 		case CXN_KILLED_RST_SENT:
 		case CXN_KILLED_RST_RCVD:
-			if (ring_mode) {
-				SE_DEBUG(DBG_LVL_1, "CQ Error %d, reset"
-				"received/sent on CID 0x%x...\n",
-				 sol->dw[offsetof(struct amap_sol_cqe, code) /
-				 32] & CQE_CODE_MASK, psgl_handle->cid);
-			} else {
-				SE_DEBUG(DBG_LVL_1, "CQ Error %d, reset"
+			SE_DEBUG(DBG_LVL_1, "CQ Error %d, reset"
 				"received/sent on CID 0x%x...\n",
 				 sol->dw[offsetof(struct amap_sol_cqe, code) /
 				 32] & CQE_CODE_MASK,
 				 (sol->dw[offsetof(struct amap_sol_cqe, cid) /
 				 32] & CQE_CID_MASK));
-			}
 			iscsi_conn_failure(beiscsi_conn->conn,
 					   ISCSI_ERR_CONN_FAILED);
 			break;
@@ -2848,11 +2788,6 @@ static int hwi_init_port(struct beiscsi_hba *phba)
 		goto error;
 	}
 
-	if (phba->fw_config.iscsi_features == 0x1)
-		ring_mode = 1;
-	else
-		ring_mode = 0;
-
 	status = beiscsi_create_cqs(phba, phwi_context);
 	if (status != 0) {
 		shost_printk(KERN_ERR, phba->shost, "CQ not created\n");
@@ -2980,17 +2915,6 @@ static int beiscsi_init_sgl_handle(struct beiscsi_hba *phba)
 	phba->io_sgl_hndl_avbl = 0;
 	phba->eh_sgl_hndl_avbl = 0;
 
-	if (ring_mode) {
-		phba->sgl_hndl_array = kzalloc(sizeof(struct sgl_handle *) *
-					      phba->params.icds_per_ctrl,
-						 GFP_KERNEL);
-		if (!phba->sgl_hndl_array) {
-			shost_printk(KERN_ERR, phba->shost,
-			     "Mem Alloc Failed. Failing to load\n");
-			return -ENOMEM;
-		}
-	}
-
 	mem_descr_sglh = phba->init_mem;
 	mem_descr_sglh += HWI_MEM_SGLH;
 	if (1 == mem_descr_sglh->num_elements) {
@@ -2998,8 +2922,6 @@ static int beiscsi_init_sgl_handle(struct beiscsi_hba *phba)
 						 phba->params.ios_per_ctrl,
 						 GFP_KERNEL);
 		if (!phba->io_sgl_hndl_base) {
-			if (ring_mode)
-				kfree(phba->sgl_hndl_array);
 			shost_printk(KERN_ERR, phba->shost,
 				     "Mem Alloc Failed. Failing to load\n");
 			return -ENOMEM;
@@ -3184,8 +3106,6 @@ static int beiscsi_init_port(struct beiscsi_hba *phba)
 	if (hba_setup_cid_tbls(phba)) {
 		shost_printk(KERN_ERR, phba->shost,
 			     "Failed in hba_setup_cid_tbls\n");
-		if (ring_mode)
-			kfree(phba->sgl_hndl_array);
 		kfree(phba->io_sgl_hndl_base);
 		kfree(phba->eh_sgl_hndl_base);
 		goto do_cleanup_ctrlr;
@@ -3242,8 +3162,6 @@ static void beiscsi_clean_port(struct beiscsi_hba *phba)
 
 	hwi_purge_eq(phba);
 	hwi_cleanup(phba);
-	if (ring_mode)
-		kfree(phba->sgl_hndl_array);
 	kfree(phba->io_sgl_hndl_base);
 	kfree(phba->eh_sgl_hndl_base);
 	kfree(phba->cid_array);
@@ -3329,8 +3247,7 @@ beiscsi_offload_connection(struct beiscsi_conn *beiscsi_conn,
 	be_dws_le_to_cpu(pwrb, sizeof(struct iscsi_target_context_update_wrb));
 
 	doorbell |= beiscsi_conn->beiscsi_conn_cid & DB_WRB_POST_CID_MASK;
-	if (!ring_mode)
-		doorbell |= (pwrb_handle->wrb_index & DB_DEF_PDU_WRB_INDEX_MASK)
+	doorbell |= (pwrb_handle->wrb_index & DB_DEF_PDU_WRB_INDEX_MASK)
 			     << DB_DEF_PDU_WRB_INDEX_SHIFT;
 	doorbell |= 1 << DB_DEF_PDU_NUM_POSTED_SHIFT;
 
@@ -3417,15 +3334,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 	itt = (itt_t) cpu_to_be32(((unsigned int)io_task->pwrb_handle->
 				 wrb_index << 16) | (unsigned int)
 				(io_task->psgl_handle->sgl_index));
-	if (ring_mode) {
-		phba->sgl_hndl_array[io_task->psgl_handle->sgl_index -
-				     phba->fw_config.iscsi_icd_start] =
-				     io_task->psgl_handle;
-		io_task->psgl_handle->task = task;
-		io_task->psgl_handle->cid = beiscsi_conn->beiscsi_conn_cid  -
-					    phba->fw_config.iscsi_cid_start;
-	} else
-		io_task->pwrb_handle->pio_handle = task;
+	io_task->pwrb_handle->pio_handle = task;
 
 	io_task->cmd_bhs->iscsi_hdr.itt = itt;
 	return 0;
@@ -3511,18 +3420,12 @@ static int beiscsi_iotask(struct iscsi_task *task, struct scatterlist *sg,
 			      ISCSI_OPCODE_SCSI_DATA_OUT);
 		AMAP_SET_BITS(struct amap_pdu_data_out, final_bit,
 			      &io_task->cmd_bhs->iscsi_data_pdu, 1);
-		if (ring_mode)
-			io_task->psgl_handle->type = INI_WR_CMD;
-		else
-			AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
-				      INI_WR_CMD);
+		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
+			      INI_WR_CMD);
 		AMAP_SET_BITS(struct amap_iscsi_wrb, dsp, pwrb, 1);
 	} else {
-		if (ring_mode)
-			io_task->psgl_handle->type = INI_RD_CMD;
-		else
-			AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
-				      INI_RD_CMD);
+		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
+			      INI_RD_CMD);
 		AMAP_SET_BITS(struct amap_iscsi_wrb, dsp, pwrb, 0);
 	}
 	memcpy(&io_task->cmd_bhs->iscsi_data_pdu.
@@ -3547,8 +3450,7 @@ static int beiscsi_iotask(struct iscsi_task *task, struct scatterlist *sg,
 	be_dws_le_to_cpu(pwrb, sizeof(struct iscsi_wrb));
 
 	doorbell |= beiscsi_conn->beiscsi_conn_cid & DB_WRB_POST_CID_MASK;
-	if (!ring_mode)
-		doorbell |= (io_task->pwrb_handle->wrb_index &
+	doorbell |= (io_task->pwrb_handle->wrb_index &
 		     DB_DEF_PDU_WRB_INDEX_MASK) << DB_DEF_PDU_WRB_INDEX_SHIFT;
 	doorbell |= 1 << DB_DEF_PDU_NUM_POSTED_SHIFT;
 
@@ -3583,21 +3485,15 @@ static int beiscsi_mtask(struct iscsi_task *task)
 
 	switch (task->hdr->opcode & ISCSI_OPCODE_MASK) {
 	case ISCSI_OP_LOGIN:
-		if (ring_mode)
-			io_task->psgl_handle->type = TGT_DM_CMD;
-		else
-			AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
-				      TGT_DM_CMD);
+		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
+			      TGT_DM_CMD);
 		AMAP_SET_BITS(struct amap_iscsi_wrb, dmsg, pwrb, 0);
 		AMAP_SET_BITS(struct amap_iscsi_wrb, cmdsn_itt, pwrb, 1);
 		hwi_write_buffer(pwrb, task);
 		break;
 	case ISCSI_OP_NOOP_OUT:
-		if (ring_mode)
-			io_task->psgl_handle->type = INI_RD_CMD;
-		else
-			AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
-				      INI_RD_CMD);
+		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
+			      INI_RD_CMD);
 		if (task->hdr->ttt == ISCSI_RESERVED_TAG)
 			AMAP_SET_BITS(struct amap_iscsi_wrb, dmsg, pwrb, 0);
 		else
@@ -3605,11 +3501,8 @@ static int beiscsi_mtask(struct iscsi_task *task)
 		hwi_write_buffer(pwrb, task);
 		break;
 	case ISCSI_OP_TEXT:
-		if (ring_mode)
-			io_task->psgl_handle->type = INI_WR_CMD;
-		else
-			AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
-				      INI_WR_CMD);
+		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
+			      INI_WR_CMD);
 		AMAP_SET_BITS(struct amap_iscsi_wrb, dmsg, pwrb, 0);
 		AMAP_SET_BITS(struct amap_iscsi_wrb, dsp, pwrb, 1);
 		hwi_write_buffer(pwrb, task);
@@ -3642,19 +3535,13 @@ static int beiscsi_mtask(struct iscsi_task *task)
 						 phba->ctrl.mcc_numtag[tag]);
 			free_mcc_tag(&phba->ctrl, tag);
 		}
-		if (ring_mode)
-			io_task->psgl_handle->type = INI_TMF_CMD;
-		else
-			AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
-				      INI_TMF_CMD);
+		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
+			      INI_TMF_CMD);
 		AMAP_SET_BITS(struct amap_iscsi_wrb, dmsg, pwrb, 0);
 		hwi_write_buffer(pwrb, task);
 		break;
 	case ISCSI_OP_LOGOUT:
 		AMAP_SET_BITS(struct amap_iscsi_wrb, dmsg, pwrb, 0);
-		if (ring_mode)
-			io_task->psgl_handle->type = HWH_TYPE_LOGOUT;
-		else
 		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
 				HWH_TYPE_LOGOUT);
 		hwi_write_buffer(pwrb, task);
@@ -3673,8 +3560,7 @@ static int beiscsi_mtask(struct iscsi_task *task)
 	be_dws_le_to_cpu(pwrb, sizeof(struct iscsi_wrb));
 
 	doorbell |= cid & DB_WRB_POST_CID_MASK;
-	if (!ring_mode)
-		doorbell |= (io_task->pwrb_handle->wrb_index &
+	doorbell |= (io_task->pwrb_handle->wrb_index &
 		     DB_DEF_PDU_WRB_INDEX_MASK) << DB_DEF_PDU_WRB_INDEX_SHIFT;
 	doorbell |= 1 << DB_DEF_PDU_NUM_POSTED_SHIFT;
 	iowrite32(doorbell, phba->db_va + DB_TXULP0_OFFSET);
@@ -3999,7 +3885,6 @@ static int __init beiscsi_module_init(void)
 			 "beiscsi pci driver.\n");
 		goto unregister_iscsi_transport;
 	}
-	ring_mode = 0;
 	return 0;
 
 unregister_iscsi_transport:
-- 
1.6.4

