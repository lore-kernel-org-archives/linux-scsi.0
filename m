From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH V2 12/18] be2iscsi: Fix dynamic CID allocation Mechanism in  driver
Date: Fri,  5 Apr 2013 20:38:32 -0700
Message-ID: <1365219519-3457-12-git-send-email-jayamohan.kallickal@emulex.com>
References: <1365219519-3457-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-da0-f47.google.com ([209.85.210.47]:49816 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422641Ab3DFDjG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Apr 2013 23:39:06 -0400
Received: by mail-da0-f47.google.com with SMTP id s35so1828220dak.6
        for <linux-scsi@vger.kernel.org>; Fri, 05 Apr 2013 20:39:06 -0700 (PDT)
In-Reply-To: <1365219519-3457-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

 Number of CID assigned to a function from adapter can be dynamic. The CID count
 for each function was fixed number before. Code Fix done so that adapters with
 fixed/dynamic CID count will work with the driver.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c |   38 +++++-----
 drivers/scsi/be2iscsi/be_main.c  |  150 +++++++++++++++++++++++++++-----------
 drivers/scsi/be2iscsi/be_main.h  |   15 ++--
 3 files changed, 133 insertions(+), 70 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 118089f..49cc2f6 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -161,7 +161,9 @@ static int beiscsi_bindconn_cid(struct beiscsi_hba *phba,
 				struct beiscsi_conn *beiscsi_conn,
 				unsigned int cid)
 {
-	if (phba->conn_table[cid]) {
+	uint16_t cri_index = BE_GET_CRI_FROM_CID(cid);
+
+	if (phba->conn_table[cri_index]) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
 			    "BS_%d : Connection table already occupied. Detected clash\n");
 
@@ -169,9 +171,9 @@ static int beiscsi_bindconn_cid(struct beiscsi_hba *phba,
 	} else {
 		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
 			    "BS_%d : phba->conn_table[%d]=%p(beiscsi_conn)\n",
-			    cid, beiscsi_conn);
+			    cri_index, beiscsi_conn);
 
-		phba->conn_table[cid] = beiscsi_conn;
+		phba->conn_table[cri_index] = beiscsi_conn;
 	}
 	return 0;
 }
@@ -994,6 +996,8 @@ static void beiscsi_free_ep(struct beiscsi_endpoint *beiscsi_ep)
 
 	beiscsi_put_cid(phba, beiscsi_ep->ep_cid);
 	beiscsi_ep->phba = NULL;
+	phba->ep_array[BE_GET_CRI_FROM_CID
+		       (beiscsi_ep->ep_cid)] = NULL;
 
 	/**
 	 * Check if any connection resource allocated by driver
@@ -1044,15 +1048,8 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 		    "BS_%d : In beiscsi_open_conn, ep_cid=%d\n",
 		    beiscsi_ep->ep_cid);
 
-	phba->ep_array[beiscsi_ep->ep_cid -
-		       phba->fw_config.iscsi_cid_start] = ep;
-	if (beiscsi_ep->ep_cid > (phba->fw_config.iscsi_cid_start +
-				  phba->params.cxns_per_ctrl * 2)) {
-
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : Failed in allocate iscsi cid\n");
-		goto free_ep;
-	}
+	phba->ep_array[BE_GET_CRI_FROM_CID
+		       (beiscsi_ep->ep_cid)] = ep;
 
 	beiscsi_ep->cid_vld = 0;
 	nonemb_cmd.va = pci_alloc_consistent(phba->ctrl.pdev,
@@ -1064,7 +1061,7 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 			    "BS_%d : Failed to allocate memory for"
 			    " mgmt_open_connection\n");
 
-		beiscsi_put_cid(phba, beiscsi_ep->ep_cid);
+		beiscsi_free_ep(beiscsi_ep);
 		return -ENOMEM;
 	}
 	nonemb_cmd.size = sizeof(struct tcp_connect_and_offload_in);
@@ -1075,9 +1072,9 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 			    "BS_%d : mgmt_open_connection Failed for cid=%d\n",
 			    beiscsi_ep->ep_cid);
 
-		beiscsi_put_cid(phba, beiscsi_ep->ep_cid);
 		pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
 				    nonemb_cmd.va, nonemb_cmd.dma);
+		beiscsi_free_ep(beiscsi_ep);
 		return -EAGAIN;
 	}
 
@@ -1089,7 +1086,8 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 
 		pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
 			    nonemb_cmd.va, nonemb_cmd.dma);
-		goto free_ep;
+		beiscsi_free_ep(beiscsi_ep);
+		return -EBUSY;
 	}
 
 	ptcpcnct_out = (struct tcp_connect_and_offload_out *)nonemb_cmd.va;
@@ -1102,10 +1100,6 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 	pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
 			    nonemb_cmd.va, nonemb_cmd.dma);
 	return 0;
-
-free_ep:
-	beiscsi_free_ep(beiscsi_ep);
-	return -EBUSY;
 }
 
 /**
@@ -1216,8 +1210,10 @@ static int beiscsi_close_conn(struct  beiscsi_endpoint *beiscsi_ep, int flag)
 static int beiscsi_unbind_conn_to_cid(struct beiscsi_hba *phba,
 				      unsigned int cid)
 {
-	if (phba->conn_table[cid])
-		phba->conn_table[cid] = NULL;
+	uint16_t cri_index = BE_GET_CRI_FROM_CID(cid);
+
+	if (phba->conn_table[cri_index])
+		phba->conn_table[cri_index] = NULL;
 	else {
 		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
 			    "BS_%d : Connection table Not occupied.\n");
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index a60a43d..01439a5 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -706,7 +706,7 @@ static void beiscsi_get_params(struct beiscsi_hba *phba)
 				    + BE2_TMFS
 				    + BE2_NOPOUT_REQ));
 	phba->params.cxns_per_ctrl = phba->fw_config.iscsi_cid_count;
-	phba->params.asyncpdus_per_ctrl = phba->fw_config.iscsi_cid_count * 2;
+	phba->params.asyncpdus_per_ctrl = phba->fw_config.iscsi_cid_count;
 	phba->params.icds_per_ctrl = phba->fw_config.iscsi_icd_count;
 	phba->params.num_sge_per_io = BE2_SGE;
 	phba->params.defpdu_hdr_sz = BE2_DEFPDU_HDR_SZ;
@@ -1036,7 +1036,6 @@ static void hwi_ring_cq_db(struct beiscsi_hba *phba,
 static unsigned int
 beiscsi_process_async_pdu(struct beiscsi_conn *beiscsi_conn,
 			  struct beiscsi_hba *phba,
-			  unsigned short cid,
 			  struct pdu_base *ppdu,
 			  unsigned long pdu_len,
 			  void *pbuffer, unsigned long buf_len)
@@ -1148,9 +1147,10 @@ struct wrb_handle *alloc_wrb_handle(struct beiscsi_hba *phba, unsigned int cid)
 	struct hwi_wrb_context *pwrb_context;
 	struct hwi_controller *phwi_ctrlr;
 	struct wrb_handle *pwrb_handle, *pwrb_handle_tmp;
+	uint16_t cri_index = BE_GET_CRI_FROM_CID(cid);
 
 	phwi_ctrlr = phba->phwi_ctrlr;
-	pwrb_context = &phwi_ctrlr->wrb_context[cid];
+	pwrb_context = &phwi_ctrlr->wrb_context[cri_index];
 	if (pwrb_context->wrb_handles_available >= 2) {
 		pwrb_handle = pwrb_context->pwrb_handle_base[
 					    pwrb_context->alloc_index];
@@ -1367,7 +1367,7 @@ hwi_complete_drvr_msgs(struct beiscsi_conn *beiscsi_conn,
 	struct hwi_controller *phwi_ctrlr;
 	struct iscsi_task *task;
 	struct beiscsi_io_task *io_task;
-	uint16_t wrb_index, cid;
+	uint16_t wrb_index, cid, cri_index;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
 	if (is_chip_be2_be3r(phba)) {
@@ -1382,8 +1382,8 @@ hwi_complete_drvr_msgs(struct beiscsi_conn *beiscsi_conn,
 				    cid, psol);
 	}
 
-	pwrb_context = &phwi_ctrlr->wrb_context[
-			cid - phba->fw_config.iscsi_cid_start];
+	cri_index = BE_GET_CRI_FROM_CID(cid);
+	pwrb_context = &phwi_ctrlr->wrb_context[cri_index];
 	pwrb_handle = pwrb_context->pwrb_handle_basestd[wrb_index];
 	task = pwrb_handle->pio_handle;
 
@@ -1478,14 +1478,15 @@ static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 	struct iscsi_conn *conn = beiscsi_conn->conn;
 	struct iscsi_session *session = conn->session;
 	struct common_sol_cqe csol_cqe = {0};
+	uint16_t cri_index = 0;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
 
 	/* Copy the elements to a common structure */
 	adapter_get_sol_cqe(phba, psol, &csol_cqe);
 
-	pwrb_context = &phwi_ctrlr->wrb_context[
-			csol_cqe.cid - phba->fw_config.iscsi_cid_start];
+	cri_index = BE_GET_CRI_FROM_CID(csol_cqe.cid);
+	pwrb_context = &phwi_ctrlr->wrb_context[cri_index];
 
 	pwrb_handle = pwrb_context->pwrb_handle_basestd[
 		      csol_cqe.wrb_index];
@@ -1611,8 +1612,8 @@ hwi_get_async_handle(struct beiscsi_hba *phba,
 
 	WARN_ON(!pasync_handle);
 
-	pasync_handle->cri = (unsigned short)beiscsi_conn->beiscsi_conn_cid -
-					     phba->fw_config.iscsi_cid_start;
+	pasync_handle->cri =
+			BE_GET_CRI_FROM_CID(beiscsi_conn->beiscsi_conn_cid);
 	pasync_handle->is_header = is_header;
 	pasync_handle->buffer_len = dpl;
 	*pcq_index = index;
@@ -1854,8 +1855,6 @@ hwi_fwd_async_msg(struct beiscsi_conn *beiscsi_conn,
 	}
 
 	status = beiscsi_process_async_pdu(beiscsi_conn, phba,
-					   (beiscsi_conn->beiscsi_conn_cid -
-					    phba->fw_config.iscsi_cid_start),
 					    phdr, hdr_len, pfirst_buffer,
 					    offset);
 
@@ -2009,6 +2008,7 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 	unsigned int num_processed = 0;
 	unsigned int tot_nump = 0;
 	unsigned short code = 0, cid = 0;
+	uint16_t cri_index = 0;
 	struct beiscsi_conn *beiscsi_conn;
 	struct beiscsi_endpoint *beiscsi_ep;
 	struct iscsi_endpoint *ep;
@@ -2040,7 +2040,8 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 						     cid, sol);
 		}
 
-		ep = phba->ep_array[cid - phba->fw_config.iscsi_cid_start];
+		cri_index = BE_GET_CRI_FROM_CID(cid);
+		ep = phba->ep_array[cri_index];
 		beiscsi_ep = ep->dd_data;
 		beiscsi_conn = beiscsi_ep->conn;
 
@@ -2537,8 +2538,9 @@ static void beiscsi_find_mem_req(struct beiscsi_hba *phba)
 
 static int beiscsi_alloc_mem(struct beiscsi_hba *phba)
 {
-	struct be_mem_descriptor *mem_descr;
 	dma_addr_t bus_add;
+	struct hwi_controller *phwi_ctrlr;
+	struct be_mem_descriptor *mem_descr;
 	struct mem_array *mem_arr, *mem_arr_orig;
 	unsigned int i, j, alloc_size, curr_alloc_size;
 
@@ -2546,9 +2548,18 @@ static int beiscsi_alloc_mem(struct beiscsi_hba *phba)
 	if (!phba->phwi_ctrlr)
 		return -ENOMEM;
 
+	/* Allocate memory for wrb_context */
+	phwi_ctrlr = phba->phwi_ctrlr;
+	phwi_ctrlr->wrb_context = kzalloc(sizeof(struct hwi_wrb_context) *
+					  phba->params.cxns_per_ctrl,
+					  GFP_KERNEL);
+	if (!phwi_ctrlr->wrb_context)
+		return -ENOMEM;
+
 	phba->init_mem = kcalloc(SE_MEM_MAX, sizeof(*mem_descr),
 				 GFP_KERNEL);
 	if (!phba->init_mem) {
+		kfree(phwi_ctrlr->wrb_context);
 		kfree(phba->phwi_ctrlr);
 		return -ENOMEM;
 	}
@@ -2557,6 +2568,7 @@ static int beiscsi_alloc_mem(struct beiscsi_hba *phba)
 			       GFP_KERNEL);
 	if (!mem_arr_orig) {
 		kfree(phba->init_mem);
+		kfree(phwi_ctrlr->wrb_context);
 		kfree(phba->phwi_ctrlr);
 		return -ENOMEM;
 	}
@@ -2627,6 +2639,7 @@ free_mem:
 	}
 	kfree(mem_arr_orig);
 	kfree(phba->init_mem);
+	kfree(phba->phwi_ctrlr->wrb_context);
 	kfree(phba->phwi_ctrlr);
 	return -ENOMEM;
 }
@@ -2665,6 +2678,7 @@ static void iscsi_init_global_templates(struct beiscsi_hba *phba)
 static int beiscsi_init_wrb_handle(struct beiscsi_hba *phba)
 {
 	struct be_mem_descriptor *mem_descr_wrbh, *mem_descr_wrb;
+	struct hwi_context_memory *phwi_ctxt;
 	struct wrb_handle *pwrb_handle = NULL;
 	struct hwi_controller *phwi_ctrlr;
 	struct hwi_wrb_context *pwrb_context;
@@ -2679,7 +2693,18 @@ static int beiscsi_init_wrb_handle(struct beiscsi_hba *phba)
 	mem_descr_wrb += HWI_MEM_WRB;
 	phwi_ctrlr = phba->phwi_ctrlr;
 
-	for (index = 0; index < phba->params.cxns_per_ctrl * 2; index += 2) {
+	/* Allocate memory for WRBQ */
+	phwi_ctxt = phwi_ctrlr->phwi_ctxt;
+	phwi_ctxt->be_wrbq = kzalloc(sizeof(struct be_queue_info) *
+				     phba->fw_config.iscsi_cid_count,
+				     GFP_KERNEL);
+	if (!phwi_ctxt->be_wrbq) {
+		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
+			    "BM_%d : WRBQ Mem Alloc Failed\n");
+		return -ENOMEM;
+	}
+
+	for (index = 0; index < phba->params.cxns_per_ctrl; index++) {
 		pwrb_context = &phwi_ctrlr->wrb_context[index];
 		pwrb_context->pwrb_handle_base =
 				kzalloc(sizeof(struct wrb_handle *) *
@@ -2722,7 +2747,7 @@ static int beiscsi_init_wrb_handle(struct beiscsi_hba *phba)
 		}
 	}
 	idx = 0;
-	for (index = 0; index < phba->params.cxns_per_ctrl * 2; index += 2) {
+	for (index = 0; index < phba->params.cxns_per_ctrl; index++) {
 		pwrb_context = &phwi_ctrlr->wrb_context[index];
 		if (!num_cxn_wrb) {
 			pwrb = mem_descr_wrb->mem_array[idx].virtual_address;
@@ -2751,7 +2776,7 @@ init_wrb_hndl_failed:
 	return -ENOMEM;
 }
 
-static void hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
+static int hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 {
 	struct hwi_controller *phwi_ctrlr;
 	struct hba_parameters *p = &phba->params;
@@ -2769,6 +2794,15 @@ static void hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 	pasync_ctx = phwi_ctrlr->phwi_ctxt->pasync_ctx;
 	memset(pasync_ctx, 0, sizeof(*pasync_ctx));
 
+	pasync_ctx->async_entry = kzalloc(sizeof(struct hwi_async_entry) *
+					  phba->fw_config.iscsi_cid_count,
+					  GFP_KERNEL);
+	if (!pasync_ctx->async_entry) {
+		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
+			    "BM_%d : hwi_init_async_pdu_ctx Mem Alloc Failed\n");
+		return -ENOMEM;
+	}
+
 	pasync_ctx->num_entries = p->asyncpdus_per_ctrl;
 	pasync_ctx->buffer_size = p->defpdu_hdr_sz;
 
@@ -2933,6 +2967,8 @@ static void hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 	pasync_ctx->async_header.ep_read_ptr = -1;
 	pasync_ctx->async_data.host_write_ptr = 0;
 	pasync_ctx->async_data.ep_read_ptr = -1;
+
+	return 0;
 }
 
 static int
@@ -3292,6 +3328,7 @@ beiscsi_create_wrb_rings(struct beiscsi_hba *phba,
 	void *wrb_vaddr;
 	struct be_dma_mem sgl;
 	struct be_mem_descriptor *mem_descr;
+	struct hwi_wrb_context *pwrb_context;
 	int status;
 
 	idx = 0;
@@ -3350,8 +3387,9 @@ beiscsi_create_wrb_rings(struct beiscsi_hba *phba,
 			kfree(pwrb_arr);
 			return status;
 		}
-		phwi_ctrlr->wrb_context[i * 2].cid = phwi_context->be_wrbq[i].
-								   id;
+		pwrb_context = &phwi_ctrlr->wrb_context[i];
+		pwrb_context->cid = phwi_context->be_wrbq[i].id;
+		BE_SET_CID_TO_CRI(i, pwrb_context->cid);
 	}
 	kfree(pwrb_arr);
 	return 0;
@@ -3364,7 +3402,7 @@ static void free_wrb_handles(struct beiscsi_hba *phba)
 	struct hwi_wrb_context *pwrb_context;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
-	for (index = 0; index < phba->params.cxns_per_ctrl * 2; index += 2) {
+	for (index = 0; index < phba->params.cxns_per_ctrl; index++) {
 		pwrb_context = &phwi_ctrlr->wrb_context[index];
 		kfree(pwrb_context->pwrb_handle_base);
 		kfree(pwrb_context->pwrb_handle_basestd);
@@ -3393,6 +3431,7 @@ static void hwi_cleanup(struct beiscsi_hba *phba)
 	struct be_ctrl_info *ctrl = &phba->ctrl;
 	struct hwi_controller *phwi_ctrlr;
 	struct hwi_context_memory *phwi_context;
+	struct hwi_async_pdu_context *pasync_ctx;
 	int i, eq_num;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
@@ -3402,6 +3441,7 @@ static void hwi_cleanup(struct beiscsi_hba *phba)
 		if (q->created)
 			beiscsi_cmd_q_destroy(ctrl, q, QTYPE_WRBQ);
 	}
+	kfree(phwi_context->be_wrbq);
 	free_wrb_handles(phba);
 
 	q = &phwi_context->be_def_hdrq;
@@ -3429,6 +3469,9 @@ static void hwi_cleanup(struct beiscsi_hba *phba)
 			beiscsi_cmd_q_destroy(ctrl, q, QTYPE_EQ);
 	}
 	be_mcc_queues_destroy(phba);
+
+	pasync_ctx = phwi_ctrlr->phwi_ctxt->pasync_ctx;
+	kfree(pasync_ctx->async_entry);
 	be_cmd_fw_uninit(ctrl);
 }
 
@@ -3607,7 +3650,12 @@ static int hwi_init_controller(struct beiscsi_hba *phba)
 	if (beiscsi_init_wrb_handle(phba))
 		return -ENOMEM;
 
-	hwi_init_async_pdu_ctx(phba);
+	if (hwi_init_async_pdu_ctx(phba)) {
+		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
+			    "BM_%d : hwi_init_async_pdu_ctx failed\n");
+		return -ENOMEM;
+	}
+
 	if (hwi_init_port(phba) != 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
 			    "BM_%d : hwi_init_controller failed\n");
@@ -3637,6 +3685,7 @@ static void beiscsi_free_mem(struct beiscsi_hba *phba)
 		mem_descr++;
 	}
 	kfree(phba->init_mem);
+	kfree(phba->phwi_ctrlr->wrb_context);
 	kfree(phba->phwi_ctrlr);
 }
 
@@ -3769,7 +3818,7 @@ static int beiscsi_init_sgl_handle(struct beiscsi_hba *phba)
 
 static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
 {
-	int i, new_cid;
+	int i;
 
 	phba->cid_array = kzalloc(sizeof(void *) * phba->params.cxns_per_ctrl,
 				  GFP_KERNEL);
@@ -3780,19 +3829,33 @@ static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
 		return -ENOMEM;
 	}
 	phba->ep_array = kzalloc(sizeof(struct iscsi_endpoint *) *
-				 phba->params.cxns_per_ctrl * 2, GFP_KERNEL);
+				 phba->params.cxns_per_ctrl, GFP_KERNEL);
 	if (!phba->ep_array) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
 			    "BM_%d : Failed to allocate memory in "
 			    "hba_setup_cid_tbls\n");
 		kfree(phba->cid_array);
+		phba->cid_array = NULL;
 		return -ENOMEM;
 	}
-	new_cid = phba->fw_config.iscsi_cid_start;
-	for (i = 0; i < phba->params.cxns_per_ctrl; i++) {
-		phba->cid_array[i] = new_cid;
-		new_cid += 2;
+
+	phba->conn_table = kzalloc(sizeof(struct beiscsi_conn *) *
+				   phba->params.cxns_per_ctrl, GFP_KERNEL);
+	if (!phba->conn_table) {
+		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
+			    "BM_%d : Failed to allocate memory in"
+			    "hba_setup_cid_tbls\n");
+
+		kfree(phba->cid_array);
+		kfree(phba->ep_array);
+		phba->cid_array = NULL;
+		phba->ep_array = NULL;
+		return -ENOMEM;
 	}
+
+	for (i = 0; i < phba->params.cxns_per_ctrl; i++)
+		phba->cid_array[i] = phba->phwi_ctrlr->wrb_context[i].cid;
+
 	phba->avlbl_cids = phba->params.cxns_per_ctrl;
 	return 0;
 }
@@ -4062,6 +4125,7 @@ static void beiscsi_clean_port(struct beiscsi_hba *phba)
 	kfree(phba->eh_sgl_hndl_base);
 	kfree(phba->cid_array);
 	kfree(phba->ep_array);
+	kfree(phba->conn_table);
 }
 
 /**
@@ -4079,11 +4143,12 @@ beiscsi_free_mgmt_task_handles(struct beiscsi_conn *beiscsi_conn,
 	struct beiscsi_hba *phba = beiscsi_conn->phba;
 	struct hwi_wrb_context *pwrb_context;
 	struct hwi_controller *phwi_ctrlr;
+	uint16_t cri_index = BE_GET_CRI_FROM_CID(
+				beiscsi_conn->beiscsi_conn_cid);
 
 	phwi_ctrlr = phba->phwi_ctrlr;
-	pwrb_context = &phwi_ctrlr->wrb_context
-		       [beiscsi_conn->beiscsi_conn_cid
-		       - phba->fw_config.iscsi_cid_start];
+	pwrb_context = &phwi_ctrlr->wrb_context[cri_index];
+
 	io_task = task->dd_data;
 
 	if (io_task->pwrb_handle) {
@@ -4123,10 +4188,11 @@ static void beiscsi_cleanup_task(struct iscsi_task *task)
 	struct beiscsi_session *beiscsi_sess = beiscsi_conn->beiscsi_sess;
 	struct hwi_wrb_context *pwrb_context;
 	struct hwi_controller *phwi_ctrlr;
+	uint16_t cri_index = BE_GET_CRI_FROM_CID(
+			     beiscsi_conn->beiscsi_conn_cid);
 
 	phwi_ctrlr = phba->phwi_ctrlr;
-	pwrb_context = &phwi_ctrlr->wrb_context[beiscsi_conn->beiscsi_conn_cid
-			- phba->fw_config.iscsi_cid_start];
+	pwrb_context = &phwi_ctrlr->wrb_context[cri_index];
 
 	if (io_task->cmd_bhs) {
 		pci_pool_free(beiscsi_sess->bhs_pool, io_task->cmd_bhs,
@@ -4172,8 +4238,7 @@ beiscsi_offload_connection(struct beiscsi_conn *beiscsi_conn,
 	beiscsi_cleanup_task(task);
 	spin_unlock_bh(&session->lock);
 
-	pwrb_handle = alloc_wrb_handle(phba, (beiscsi_conn->beiscsi_conn_cid -
-				       phba->fw_config.iscsi_cid_start));
+	pwrb_handle = alloc_wrb_handle(phba, beiscsi_conn->beiscsi_conn_cid);
 
 	/* Check for the adapter family */
 	if (is_chip_be2_be3r(phba))
@@ -4220,6 +4285,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 	struct hwi_wrb_context *pwrb_context;
 	struct hwi_controller *phwi_ctrlr;
 	itt_t itt;
+	uint16_t cri_index = 0;
 	struct beiscsi_session *beiscsi_sess = beiscsi_conn->beiscsi_sess;
 	dma_addr_t paddr;
 
@@ -4249,8 +4315,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 			goto free_hndls;
 		}
 		io_task->pwrb_handle = alloc_wrb_handle(phba,
-					beiscsi_conn->beiscsi_conn_cid -
-					phba->fw_config.iscsi_cid_start);
+					beiscsi_conn->beiscsi_conn_cid);
 		if (!io_task->pwrb_handle) {
 			beiscsi_log(phba, KERN_ERR,
 				    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
@@ -4284,8 +4349,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 							io_task->psgl_handle;
 				io_task->pwrb_handle =
 					alloc_wrb_handle(phba,
-					beiscsi_conn->beiscsi_conn_cid -
-					phba->fw_config.iscsi_cid_start);
+					beiscsi_conn->beiscsi_conn_cid);
 				if (!io_task->pwrb_handle) {
 					beiscsi_log(phba, KERN_ERR,
 						    BEISCSI_LOG_IO |
@@ -4321,8 +4385,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 			}
 			io_task->pwrb_handle =
 					alloc_wrb_handle(phba,
-					beiscsi_conn->beiscsi_conn_cid -
-					phba->fw_config.iscsi_cid_start);
+					beiscsi_conn->beiscsi_conn_cid);
 			if (!io_task->pwrb_handle) {
 				beiscsi_log(phba, KERN_ERR,
 					    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
@@ -4350,12 +4413,13 @@ free_io_hndls:
 free_mgmt_hndls:
 	spin_lock(&phba->mgmt_sgl_lock);
 	free_mgmt_sgl_handle(phba, io_task->psgl_handle);
+	io_task->psgl_handle = NULL;
 	spin_unlock(&phba->mgmt_sgl_lock);
 free_hndls:
 	phwi_ctrlr = phba->phwi_ctrlr;
-	pwrb_context = &phwi_ctrlr->wrb_context[
-			beiscsi_conn->beiscsi_conn_cid -
-			phba->fw_config.iscsi_cid_start];
+	cri_index = BE_GET_CRI_FROM_CID(
+	beiscsi_conn->beiscsi_conn_cid);
+	pwrb_context = &phwi_ctrlr->wrb_context[cri_index];
 	if (io_task->pwrb_handle)
 		free_wrb_handle(phba, pwrb_context, io_task->pwrb_handle);
 	io_task->pwrb_handle = NULL;
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index ac4ef34..6d83ad8 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -307,10 +307,15 @@ struct beiscsi_hba {
 	unsigned short avlbl_cids;
 	unsigned short cid_alloc;
 	unsigned short cid_free;
-	struct beiscsi_conn *conn_table[BE2_MAX_SESSIONS * 2];
 	struct list_head hba_queue;
+#define BE_MAX_SESSION 2048
+#define BE_SET_CID_TO_CRI(cri_index, cid) \
+			  (phba->cid_to_cri_map[cid] = cri_index)
+#define BE_GET_CRI_FROM_CID(cid) (phba->cid_to_cri_map[cid])
+	unsigned short cid_to_cri_map[BE_MAX_SESSION];
 	unsigned short *cid_array;
 	struct iscsi_endpoint **ep_array;
+	struct beiscsi_conn **conn_table;
 	struct iscsi_boot_kset *boot_kset;
 	struct Scsi_Host *shost;
 	struct iscsi_iface *ipv4_iface;
@@ -567,7 +572,7 @@ struct hwi_async_pdu_context {
 	 * This is a varying size list! Do not add anything
 	 * after this entry!!
 	 */
-	struct hwi_async_entry async_entry[BE2_MAX_SESSIONS * 2];
+	struct hwi_async_entry *async_entry;
 };
 
 #define PDUCQE_CODE_MASK	0x0000003F
@@ -939,7 +944,7 @@ struct hwi_controller {
 	struct sgl_handle *psgl_handle_base;
 	unsigned int wrb_mem_index;
 
-	struct hwi_wrb_context wrb_context[BE2_MAX_SESSIONS * 2];
+	struct hwi_wrb_context *wrb_context;
 	struct mcc_wrb *pmcc_wrb_base;
 	struct be_ring default_pdu_hdr;
 	struct be_ring default_pdu_data;
@@ -976,9 +981,7 @@ struct hwi_context_memory {
 	struct be_queue_info be_def_hdrq;
 	struct be_queue_info be_def_dataq;
 
-	struct be_queue_info be_wrbq[BE2_MAX_SESSIONS];
-	struct be_mcc_wrb_context *pbe_mcc_context;
-
+	struct be_queue_info *be_wrbq;
 	struct hwi_async_pdu_context *pasync_ctx;
 };
 
-- 
1.7.10.4

