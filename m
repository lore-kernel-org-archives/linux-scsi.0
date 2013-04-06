From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH V2 06/18] be2iscsi: Fix MACRO for checking the adapter type
Date: Fri,  5 Apr 2013 20:38:26 -0700
Message-ID: <1365219519-3457-6-git-send-email-jayamohan.kallickal@emulex.com>
References: <1365219519-3457-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:64523 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1163198Ab3DFDi5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Apr 2013 23:38:57 -0400
Received: by mail-pa0-f49.google.com with SMTP id kp14so2361408pab.36
        for <linux-scsi@vger.kernel.org>; Fri, 05 Apr 2013 20:38:56 -0700 (PDT)
In-Reply-To: <1365219519-3457-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

 Fixed the code flow based on the MACRO defined to check for
 adapter.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_cmds.c |   28 ++++-----
 drivers/scsi/be2iscsi/be_main.c |  123 ++++++++++++++++++++-------------------
 drivers/scsi/be2iscsi/be_main.h |    4 +-
 3 files changed, 79 insertions(+), 76 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index dfbe7e4..db6c50b 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -855,20 +855,7 @@ int beiscsi_cmd_cq_create(struct be_ctrl_info *ctrl,
 			OPCODE_COMMON_CQ_CREATE, sizeof(*req));
 
 	req->num_pages = cpu_to_le16(PAGES_4K_SPANNED(q_mem->va, q_mem->size));
-	if (chip_skh_r(ctrl->pdev)) {
-		req->hdr.version = MBX_CMD_VER2;
-		req->page_size = 1;
-		AMAP_SET_BITS(struct amap_cq_context_v2, coalescwm,
-			      ctxt, coalesce_wm);
-		AMAP_SET_BITS(struct amap_cq_context_v2, nodelay,
-			      ctxt, no_delay);
-		AMAP_SET_BITS(struct amap_cq_context_v2, count, ctxt,
-			      __ilog2_u32(cq->len / 256));
-		AMAP_SET_BITS(struct amap_cq_context_v2, valid, ctxt, 1);
-		AMAP_SET_BITS(struct amap_cq_context_v2, eventable, ctxt, 1);
-		AMAP_SET_BITS(struct amap_cq_context_v2, eqid, ctxt, eq->id);
-		AMAP_SET_BITS(struct amap_cq_context_v2, armed, ctxt, 1);
-	} else {
+	if (is_chip_be2_be3r(phba)) {
 		AMAP_SET_BITS(struct amap_cq_context, coalescwm,
 			      ctxt, coalesce_wm);
 		AMAP_SET_BITS(struct amap_cq_context, nodelay, ctxt, no_delay);
@@ -881,6 +868,19 @@ int beiscsi_cmd_cq_create(struct be_ctrl_info *ctrl,
 		AMAP_SET_BITS(struct amap_cq_context, armed, ctxt, 1);
 		AMAP_SET_BITS(struct amap_cq_context, func, ctxt,
 			      PCI_FUNC(ctrl->pdev->devfn));
+	} else {
+		req->hdr.version = MBX_CMD_VER2;
+		req->page_size = 1;
+		AMAP_SET_BITS(struct amap_cq_context_v2, coalescwm,
+			      ctxt, coalesce_wm);
+		AMAP_SET_BITS(struct amap_cq_context_v2, nodelay,
+			      ctxt, no_delay);
+		AMAP_SET_BITS(struct amap_cq_context_v2, count, ctxt,
+			      __ilog2_u32(cq->len / 256));
+		AMAP_SET_BITS(struct amap_cq_context_v2, valid, ctxt, 1);
+		AMAP_SET_BITS(struct amap_cq_context_v2, eventable, ctxt, 1);
+		AMAP_SET_BITS(struct amap_cq_context_v2, eqid, ctxt, eq->id);
+		AMAP_SET_BITS(struct amap_cq_context_v2, armed, ctxt, 1);
 	}
 
 	be_dws_cpu_to_le(ctxt, sizeof(req->context));
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 75d7186..6be5e29 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1368,15 +1368,15 @@ hwi_complete_drvr_msgs(struct beiscsi_conn *beiscsi_conn,
 	uint16_t wrb_index, cid;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
-	if (chip_skh_r(phba->pcidev)) {
-		wrb_index = AMAP_GET_BITS(struct amap_it_dmsg_cqe_v2,
+	if (is_chip_be2_be3r(phba)) {
+		wrb_index = AMAP_GET_BITS(struct amap_it_dmsg_cqe,
 					  wrb_idx, psol);
-		cid = AMAP_GET_BITS(struct amap_it_dmsg_cqe_v2,
+		cid = AMAP_GET_BITS(struct amap_it_dmsg_cqe,
 				    cid, psol);
 	} else {
-		wrb_index = AMAP_GET_BITS(struct amap_it_dmsg_cqe,
+		wrb_index = AMAP_GET_BITS(struct amap_it_dmsg_cqe_v2,
 					  wrb_idx, psol);
-		cid = AMAP_GET_BITS(struct amap_it_dmsg_cqe,
+		cid = AMAP_GET_BITS(struct amap_it_dmsg_cqe_v2,
 				    cid, psol);
 	}
 
@@ -1418,7 +1418,26 @@ static void adapter_get_sol_cqe(struct beiscsi_hba *phba,
 		struct sol_cqe *psol,
 		struct common_sol_cqe *csol_cqe)
 {
-	if (chip_skh_r(phba->pcidev)) {
+	if (is_chip_be2_be3r(phba)) {
+		csol_cqe->exp_cmdsn = AMAP_GET_BITS(struct amap_sol_cqe,
+						    i_exp_cmd_sn, psol);
+		csol_cqe->res_cnt = AMAP_GET_BITS(struct amap_sol_cqe,
+						  i_res_cnt, psol);
+		csol_cqe->cmd_wnd = AMAP_GET_BITS(struct amap_sol_cqe,
+						  i_cmd_wnd, psol);
+		csol_cqe->wrb_index = AMAP_GET_BITS(struct amap_sol_cqe,
+						    wrb_index, psol);
+		csol_cqe->cid = AMAP_GET_BITS(struct amap_sol_cqe,
+					      cid, psol);
+		csol_cqe->hw_sts = AMAP_GET_BITS(struct amap_sol_cqe,
+						 hw_sts, psol);
+		csol_cqe->i_resp = AMAP_GET_BITS(struct amap_sol_cqe,
+						 i_resp, psol);
+		csol_cqe->i_sts = AMAP_GET_BITS(struct amap_sol_cqe,
+						i_sts, psol);
+		csol_cqe->i_flags = AMAP_GET_BITS(struct amap_sol_cqe,
+						  i_flags, psol);
+	} else {
 		csol_cqe->exp_cmdsn = AMAP_GET_BITS(struct amap_sol_cqe_v2,
 						    i_exp_cmd_sn, psol);
 		csol_cqe->res_cnt = AMAP_GET_BITS(struct amap_sol_cqe_v2,
@@ -1445,25 +1464,6 @@ static void adapter_get_sol_cqe(struct beiscsi_hba *phba,
 		if (AMAP_GET_BITS(struct amap_sol_cqe_v2,
 				  o, psol))
 			csol_cqe->i_flags |= ISCSI_FLAG_CMD_OVERFLOW;
-	} else {
-		csol_cqe->exp_cmdsn = AMAP_GET_BITS(struct amap_sol_cqe,
-						    i_exp_cmd_sn, psol);
-		csol_cqe->res_cnt = AMAP_GET_BITS(struct amap_sol_cqe,
-						  i_res_cnt, psol);
-		csol_cqe->cmd_wnd = AMAP_GET_BITS(struct amap_sol_cqe,
-						  i_cmd_wnd, psol);
-		csol_cqe->wrb_index = AMAP_GET_BITS(struct amap_sol_cqe,
-						    wrb_index, psol);
-		csol_cqe->cid = AMAP_GET_BITS(struct amap_sol_cqe,
-					      cid, psol);
-		csol_cqe->hw_sts = AMAP_GET_BITS(struct amap_sol_cqe,
-						 hw_sts, psol);
-		csol_cqe->i_resp = AMAP_GET_BITS(struct amap_sol_cqe,
-						 i_resp, psol);
-		csol_cqe->i_sts = AMAP_GET_BITS(struct amap_sol_cqe,
-						i_sts, psol);
-		csol_cqe->i_flags = AMAP_GET_BITS(struct amap_sol_cqe,
-						  i_flags, psol);
 	}
 }
 
@@ -1561,15 +1561,15 @@ hwi_get_async_handle(struct beiscsi_hba *phba,
 	unsigned char is_header = 0;
 	unsigned int index, dpl;
 
-	if (chip_skh_r(phba->pcidev)) {
-		dpl = AMAP_GET_BITS(struct amap_i_t_dpdu_cqe_v2,
+	if (is_chip_be2_be3r(phba)) {
+		dpl = AMAP_GET_BITS(struct amap_i_t_dpdu_cqe,
 				    dpl, pdpdu_cqe);
-		index = AMAP_GET_BITS(struct amap_i_t_dpdu_cqe_v2,
+		index = AMAP_GET_BITS(struct amap_i_t_dpdu_cqe,
 				      index, pdpdu_cqe);
 	} else {
-		dpl = AMAP_GET_BITS(struct amap_i_t_dpdu_cqe,
+		dpl = AMAP_GET_BITS(struct amap_i_t_dpdu_cqe_v2,
 				    dpl, pdpdu_cqe);
-		index = AMAP_GET_BITS(struct amap_i_t_dpdu_cqe,
+		index = AMAP_GET_BITS(struct amap_i_t_dpdu_cqe_v2,
 				      index, pdpdu_cqe);
 	}
 
@@ -2028,7 +2028,9 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 			 32] & CQE_CODE_MASK);
 
 		 /* Get the CID */
-		if (chip_skh_r(phba->pcidev)) {
+		if (is_chip_be2_be3r(phba)) {
+			cid = AMAP_GET_BITS(struct amap_sol_cqe, cid, sol);
+		} else {
 			if ((code == DRIVERMSG_NOTIFY) ||
 			    (code == UNSOL_HDR_NOTIFY) ||
 			    (code == UNSOL_DATA_NOTIFY))
@@ -2038,8 +2040,7 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 			 else
 				 cid = AMAP_GET_BITS(struct amap_sol_cqe_v2,
 						     cid, sol);
-		   } else
-			 cid = AMAP_GET_BITS(struct amap_sol_cqe, cid, sol);
+		}
 
 		ep = phba->ep_array[cid - phba->fw_config.iscsi_cid_start];
 		beiscsi_ep = ep->dd_data;
@@ -2416,11 +2417,11 @@ static void hwi_write_buffer(struct iscsi_wrb *pwrb, struct iscsi_task *task)
 		/* Check for the data_count */
 		dsp_value = (task->data_count) ? 1 : 0;
 
-		if (chip_skh_r(phba->pcidev))
-			AMAP_SET_BITS(struct amap_iscsi_wrb_v2, dsp,
+		if (is_chip_be2_be3r(phba))
+			AMAP_SET_BITS(struct amap_iscsi_wrb, dsp,
 				      pwrb, dsp_value);
 		else
-			AMAP_SET_BITS(struct amap_iscsi_wrb, dsp,
+			AMAP_SET_BITS(struct amap_iscsi_wrb_v2, dsp,
 				      pwrb, dsp_value);
 
 		/* Map addr only if there is data_count */
@@ -4175,11 +4176,11 @@ beiscsi_offload_connection(struct beiscsi_conn *beiscsi_conn,
 				       phba->fw_config.iscsi_cid_start));
 
 	/* Check for the adapter family */
-	if (chip_skh_r(phba->pcidev))
-		beiscsi_offload_cxn_v2(params, pwrb_handle);
-	else
+	if (is_chip_be2_be3r(phba))
 		beiscsi_offload_cxn_v0(params, pwrb_handle,
 				       phba->init_mem);
+	else
+		beiscsi_offload_cxn_v2(params, pwrb_handle);
 
 	be_dws_le_to_cpu(pwrb_handle->pwrb,
 			 sizeof(struct iscsi_target_context_update_wrb));
@@ -4490,19 +4491,7 @@ static int beiscsi_mtask(struct iscsi_task *task)
 	pwrb = io_task->pwrb_handle->pwrb;
 	memset(pwrb, 0, sizeof(*pwrb));
 
-	if (chip_skh_r(phba->pcidev)) {
-		AMAP_SET_BITS(struct amap_iscsi_wrb_v2, cmdsn_itt, pwrb,
-			      be32_to_cpu(task->cmdsn));
-		AMAP_SET_BITS(struct amap_iscsi_wrb_v2, wrb_idx, pwrb,
-			      io_task->pwrb_handle->wrb_index);
-		AMAP_SET_BITS(struct amap_iscsi_wrb_v2, sgl_idx, pwrb,
-			      io_task->psgl_handle->sgl_index);
-		AMAP_SET_BITS(struct amap_iscsi_wrb_v2, r2t_exp_dtl, pwrb,
-			      task->data_count);
-		AMAP_SET_BITS(struct amap_iscsi_wrb_v2, ptr2nextwrb, pwrb,
-			      io_task->pwrb_handle->nxt_wrb_index);
-		pwrb_typeoffset = SKH_WRB_TYPE_OFFSET;
-	} else {
+	if (is_chip_be2_be3r(phba)) {
 		AMAP_SET_BITS(struct amap_iscsi_wrb, cmdsn_itt, pwrb,
 			      be32_to_cpu(task->cmdsn));
 		AMAP_SET_BITS(struct amap_iscsi_wrb, wrb_idx, pwrb,
@@ -4514,6 +4503,18 @@ static int beiscsi_mtask(struct iscsi_task *task)
 		AMAP_SET_BITS(struct amap_iscsi_wrb, ptr2nextwrb, pwrb,
 			      io_task->pwrb_handle->nxt_wrb_index);
 		pwrb_typeoffset = BE_WRB_TYPE_OFFSET;
+	} else {
+		AMAP_SET_BITS(struct amap_iscsi_wrb_v2, cmdsn_itt, pwrb,
+			      be32_to_cpu(task->cmdsn));
+		AMAP_SET_BITS(struct amap_iscsi_wrb_v2, wrb_idx, pwrb,
+			      io_task->pwrb_handle->wrb_index);
+		AMAP_SET_BITS(struct amap_iscsi_wrb_v2, sgl_idx, pwrb,
+			      io_task->psgl_handle->sgl_index);
+		AMAP_SET_BITS(struct amap_iscsi_wrb_v2, r2t_exp_dtl, pwrb,
+			      task->data_count);
+		AMAP_SET_BITS(struct amap_iscsi_wrb_v2, ptr2nextwrb, pwrb,
+			      io_task->pwrb_handle->nxt_wrb_index);
+		pwrb_typeoffset = SKH_WRB_TYPE_OFFSET;
 	}
 
 
@@ -4526,19 +4527,19 @@ static int beiscsi_mtask(struct iscsi_task *task)
 	case ISCSI_OP_NOOP_OUT:
 		if (task->hdr->ttt != ISCSI_RESERVED_TAG) {
 			ADAPTER_SET_WRB_TYPE(pwrb, TGT_DM_CMD, pwrb_typeoffset);
-			if (chip_skh_r(phba->pcidev))
-				AMAP_SET_BITS(struct amap_iscsi_wrb_v2,
+			if (is_chip_be2_be3r(phba))
+				AMAP_SET_BITS(struct amap_iscsi_wrb,
 					      dmsg, pwrb, 1);
 			else
-				AMAP_SET_BITS(struct amap_iscsi_wrb,
+				AMAP_SET_BITS(struct amap_iscsi_wrb_v2,
 					      dmsg, pwrb, 1);
 		} else {
 			ADAPTER_SET_WRB_TYPE(pwrb, INI_RD_CMD, pwrb_typeoffset);
-			if (chip_skh_r(phba->pcidev))
-				AMAP_SET_BITS(struct amap_iscsi_wrb_v2,
+			if (is_chip_be2_be3r(phba))
+				AMAP_SET_BITS(struct amap_iscsi_wrb,
 					      dmsg, pwrb, 0);
 			else
-				AMAP_SET_BITS(struct amap_iscsi_wrb,
+				AMAP_SET_BITS(struct amap_iscsi_wrb_v2,
 					      dmsg, pwrb, 0);
 		}
 		hwi_write_buffer(pwrb, task);
@@ -4565,9 +4566,9 @@ static int beiscsi_mtask(struct iscsi_task *task)
 	}
 
 	/* Set the task type */
-	io_task->wrb_type = (chip_skh_r(phba->pcidev)) ?
-		AMAP_GET_BITS(struct amap_iscsi_wrb_v2, type, pwrb) :
-		AMAP_GET_BITS(struct amap_iscsi_wrb, type, pwrb);
+	io_task->wrb_type = (is_chip_be2_be3r(phba)) ?
+		AMAP_GET_BITS(struct amap_iscsi_wrb, type, pwrb) :
+		AMAP_GET_BITS(struct amap_iscsi_wrb_v2, type, pwrb);
 
 	doorbell |= cid & DB_WRB_POST_CID_MASK;
 	doorbell |= (io_task->pwrb_handle->wrb_index &
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index b098b5b..77b13c3 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -265,7 +265,9 @@ struct invalidate_command_table {
 	unsigned short cid;
 } __packed;
 
-#define chip_skh_r(pdev)	(pdev->device == OC_SKH_ID1)
+#define chip_be2(phba)      (phba->generation == BE_GEN2)
+#define chip_be3_r(phba)    (phba->generation == BE_GEN3)
+#define is_chip_be2_be3r(phba) (chip_be3_r(phba) || (chip_be2(phba)))
 struct beiscsi_hba {
 	struct hba_parameters params;
 	struct hwi_controller *phwi_ctrlr;
-- 
1.7.10.4

