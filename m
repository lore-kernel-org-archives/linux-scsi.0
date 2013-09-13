From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH 08/22] be2iscsi: Fix changes in ASYNC Path for SKH-R adapter
Date: Thu, 12 Sep 2013 22:09:58 -0700
Message-ID: <1379049014-32716-8-git-send-email-jayamohan.kallickal@emulex.com>
References: <1379049014-32716-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:62029 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab3IMFgb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Sep 2013 01:36:31 -0400
Received: by mail-pa0-f48.google.com with SMTP id kp13so2064964pab.21
        for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2013 22:36:30 -0700 (PDT)
In-Reply-To: <1379049014-32716-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

 DEF_Q[HDR/DATA] is created on the chute on which iSCSI Protocol is loaded.
 When a connection is offloaded, the DEF_Q HDR/Data ID needs to be passed.
 FW posts ASYNC message received from target on the passed DEF_Q. Connection
 can be offloaded on any of the chute so DEF_Q is created on each Chute.

 Change in the ASYNC path initialization based on the configuration parameters
 returned for each chute.

 For BE-X family iSCSI protocol is loaded only on Chute - 1.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_cmds.c |   42 ++-
 drivers/scsi/be2iscsi/be_cmds.h |   13 +-
 drivers/scsi/be2iscsi/be_main.c |  674 ++++++++++++++++++++++++---------------
 drivers/scsi/be2iscsi/be_main.h |   58 ++--
 drivers/scsi/be2iscsi/be_mgmt.c |   10 +-
 5 files changed, 515 insertions(+), 282 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 01e1915..1f7db25 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -1026,10 +1026,29 @@ int beiscsi_cmd_q_destroy(struct be_ctrl_info *ctrl, struct be_queue_info *q,
 	return status;
 }
 
+/**
+ * be_cmd_create_default_pdu_queue()- Create DEFQ for the adapter
+ * @ctrl: ptr to ctrl_info
+ * @cq: Completion Queue
+ * @dq: Default Queue
+ * @lenght: ring size
+ * @entry_size: size of each entry in DEFQ
+ * @is_header: Header or Data DEFQ
+ * @ulp_num: Bind to which ULP
+ *
+ * Create HDR/Data DEFQ for the passed ULP. Unsol PDU are posted
+ * on this queue by the FW
+ *
+ * return
+ *	Success: 0
+ *	Failure: Non-Zero Value
+ *
+ **/
 int be_cmd_create_default_pdu_queue(struct be_ctrl_info *ctrl,
 				    struct be_queue_info *cq,
 				    struct be_queue_info *dq, int length,
-				    int entry_size)
+				    int entry_size, uint8_t is_header,
+				    uint8_t ulp_num)
 {
 	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
 	struct be_defq_create_req *req = embedded_payload(wrb);
@@ -1047,6 +1066,11 @@ int be_cmd_create_default_pdu_queue(struct be_ctrl_info *ctrl,
 			   OPCODE_COMMON_ISCSI_DEFQ_CREATE, sizeof(*req));
 
 	req->num_pages = PAGES_4K_SPANNED(q_mem->va, q_mem->size);
+	if (phba->fw_config.dual_ulp_aware) {
+		req->ulp_num = ulp_num;
+		req->dua_feature |= (1 << BEISCSI_DUAL_ULP_AWARE_BIT);
+		req->dua_feature |= (1 << BEISCSI_BIND_Q_TO_ULP_BIT);
+	}
 
 	if (is_chip_be2_be3r(phba)) {
 		AMAP_SET_BITS(struct amap_be_default_pdu_context,
@@ -1084,10 +1108,26 @@ int be_cmd_create_default_pdu_queue(struct be_ctrl_info *ctrl,
 
 	status = be_mbox_notify(ctrl);
 	if (!status) {
+		struct be_ring *defq_ring;
 		struct be_defq_create_resp *resp = embedded_payload(wrb);
 
 		dq->id = le16_to_cpu(resp->id);
 		dq->created = true;
+		if (is_header)
+			defq_ring = &phba->phwi_ctrlr->default_pdu_hdr[ulp_num];
+		else
+			defq_ring = &phba->phwi_ctrlr->
+				    default_pdu_data[ulp_num];
+
+		defq_ring->id = dq->id;
+
+		if (!phba->fw_config.dual_ulp_aware) {
+			defq_ring->ulp_num = BEISCSI_ULP0;
+			defq_ring->doorbell_offset = DB_RXULP0_OFFSET;
+		} else {
+			defq_ring->ulp_num = resp->ulp_num;
+			defq_ring->doorbell_offset = resp->doorbell_offset;
+		}
 	}
 	spin_unlock(&ctrl->mbox_lock);
 
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index b812e38..40bc285 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -729,7 +729,8 @@ int be_mbox_notify(struct be_ctrl_info *ctrl);
 int be_cmd_create_default_pdu_queue(struct be_ctrl_info *ctrl,
 				    struct be_queue_info *cq,
 				    struct be_queue_info *dq, int length,
-				    int entry_size);
+				    int entry_size, uint8_t is_header,
+				    uint8_t ulp_num);
 
 int be_cmd_iscsi_post_template_hdr(struct be_ctrl_info *ctrl,
 				    struct be_dma_mem *q_mem);
@@ -788,7 +789,9 @@ struct be_defq_create_req {
 	struct be_cmd_req_hdr hdr;
 	u16 num_pages;
 	u8 ulp_num;
-	u8 rsvd0;
+#define BEISCSI_DUAL_ULP_AWARE_BIT	0	/* Byte 3 - Bit 0 */
+#define BEISCSI_BIND_Q_TO_ULP_BIT	1	/* Byte 3 - Bit 1 */
+	u8 dua_feature;
 	struct be_default_pdu_context context;
 	struct phys_addr pages[8];
 } __packed;
@@ -796,7 +799,11 @@ struct be_defq_create_req {
 struct be_defq_create_resp {
 	struct be_cmd_req_hdr hdr;
 	u16 id;
-	u16 rsvd0;
+	u8 rsvd0;
+	u8 ulp_num;
+	u32 doorbell_offset;
+	u16 register_set;
+	u16 doorbell_format;
 } __packed;
 
 struct be_post_template_pages_req {
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 8995507..a54fa4d 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1691,7 +1691,10 @@ static void hwi_free_async_msg(struct beiscsi_hba *phba,
 	struct list_head *plist;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
-	pasync_ctx = HWI_GET_ASYNC_PDU_CTX(phwi_ctrlr);
+
+	/* Get async_ctx for specific ULP */
+	pasync_ctx = HWI_GET_ASYNC_PDU_CTX(phwi_ctrlr,
+		     BEISCSI_GET_ULP_FROM_CRI(phwi_ctrlr, cri));
 
 	plist  = &pasync_ctx->async_entry[cri].wait_queue.list;
 
@@ -1729,7 +1732,7 @@ hwi_get_ring_address(struct hwi_async_pdu_context *pasync_ctx,
 }
 
 static void hwi_post_async_buffers(struct beiscsi_hba *phba,
-				   unsigned int is_header)
+				    unsigned int is_header, uint8_t ulp_num)
 {
 	struct hwi_controller *phwi_ctrlr;
 	struct hwi_async_pdu_context *pasync_ctx;
@@ -1737,13 +1740,13 @@ static void hwi_post_async_buffers(struct beiscsi_hba *phba,
 	struct list_head *pfree_link, *pbusy_list;
 	struct phys_addr *pasync_sge;
 	unsigned int ring_id, num_entries;
-	unsigned int host_write_num;
+	unsigned int host_write_num, doorbell_offset;
 	unsigned int writables;
 	unsigned int i = 0;
 	u32 doorbell = 0;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
-	pasync_ctx = HWI_GET_ASYNC_PDU_CTX(phwi_ctrlr);
+	pasync_ctx = HWI_GET_ASYNC_PDU_CTX(phwi_ctrlr, ulp_num);
 	num_entries = pasync_ctx->num_entries;
 
 	if (is_header) {
@@ -1751,13 +1754,19 @@ static void hwi_post_async_buffers(struct beiscsi_hba *phba,
 				pasync_ctx->async_header.free_entries);
 		pfree_link = pasync_ctx->async_header.free_list.next;
 		host_write_num = pasync_ctx->async_header.host_write_ptr;
-		ring_id = phwi_ctrlr->default_pdu_hdr.id;
+		ring_id = phwi_ctrlr->default_pdu_hdr[ulp_num].id;
+		doorbell_offset =
+				   phwi_ctrlr->default_pdu_hdr[ulp_num].
+				   doorbell_offset;
 	} else {
 		writables = min(pasync_ctx->async_data.writables,
 				pasync_ctx->async_data.free_entries);
 		pfree_link = pasync_ctx->async_data.free_list.next;
 		host_write_num = pasync_ctx->async_data.host_write_ptr;
-		ring_id = phwi_ctrlr->default_pdu_data.id;
+		ring_id = phwi_ctrlr->default_pdu_data[ulp_num].id;
+		doorbell_offset =
+				    phwi_ctrlr->default_pdu_data[ulp_num].
+				    doorbell_offset;
 	}
 
 	writables = (writables / 8) * 8;
@@ -1805,7 +1814,7 @@ static void hwi_post_async_buffers(struct beiscsi_hba *phba,
 		doorbell |= (writables & DB_DEF_PDU_CQPROC_MASK)
 					<< DB_DEF_PDU_CQPROC_SHIFT;
 
-		iowrite32(doorbell, phba->db_va + DB_RXULP0_OFFSET);
+		iowrite32(doorbell, phba->db_va + doorbell_offset);
 	}
 }
 
@@ -1817,9 +1826,13 @@ static void hwi_flush_default_pdu_buffer(struct beiscsi_hba *phba,
 	struct hwi_async_pdu_context *pasync_ctx;
 	struct async_pdu_handle *pasync_handle = NULL;
 	unsigned int cq_index = -1;
+	uint16_t cri_index = BE_GET_CRI_FROM_CID(
+			     beiscsi_conn->beiscsi_conn_cid);
 
 	phwi_ctrlr = phba->phwi_ctrlr;
-	pasync_ctx = HWI_GET_ASYNC_PDU_CTX(phwi_ctrlr);
+	pasync_ctx = HWI_GET_ASYNC_PDU_CTX(phwi_ctrlr,
+		     BEISCSI_GET_ULP_FROM_CRI(phwi_ctrlr,
+		     cri_index));
 
 	pasync_handle = hwi_get_async_handle(phba, beiscsi_conn, pasync_ctx,
 					     pdpdu_cqe, &cq_index);
@@ -1829,7 +1842,9 @@ static void hwi_flush_default_pdu_buffer(struct beiscsi_hba *phba,
 					   pasync_handle->is_header, cq_index);
 
 	hwi_free_async_msg(phba, pasync_handle->cri);
-	hwi_post_async_buffers(phba, pasync_handle->is_header);
+	hwi_post_async_buffers(phba, pasync_handle->is_header,
+			       BEISCSI_GET_ULP_FROM_CRI(phwi_ctrlr,
+			       cri_index));
 }
 
 static unsigned int
@@ -1884,7 +1899,9 @@ hwi_gather_async_pdu(struct beiscsi_conn *beiscsi_conn,
 	struct pdu_base *ppdu;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
-	pasync_ctx = HWI_GET_ASYNC_PDU_CTX(phwi_ctrlr);
+	pasync_ctx = HWI_GET_ASYNC_PDU_CTX(phwi_ctrlr,
+		     BEISCSI_GET_ULP_FROM_CRI(phwi_ctrlr,
+		     cri));
 
 	list_del(&pasync_handle->link);
 	if (pasync_handle->is_header) {
@@ -1945,9 +1962,14 @@ static void hwi_process_default_pdu_ring(struct beiscsi_conn *beiscsi_conn,
 	struct hwi_async_pdu_context *pasync_ctx;
 	struct async_pdu_handle *pasync_handle = NULL;
 	unsigned int cq_index = -1;
+	uint16_t cri_index = BE_GET_CRI_FROM_CID(
+			     beiscsi_conn->beiscsi_conn_cid);
 
 	phwi_ctrlr = phba->phwi_ctrlr;
-	pasync_ctx = HWI_GET_ASYNC_PDU_CTX(phwi_ctrlr);
+	pasync_ctx = HWI_GET_ASYNC_PDU_CTX(phwi_ctrlr,
+		     BEISCSI_GET_ULP_FROM_CRI(phwi_ctrlr,
+		     cri_index));
+
 	pasync_handle = hwi_get_async_handle(phba, beiscsi_conn, pasync_ctx,
 					     pdpdu_cqe, &cq_index);
 
@@ -1956,7 +1978,9 @@ static void hwi_process_default_pdu_ring(struct beiscsi_conn *beiscsi_conn,
 					   pasync_handle->is_header, cq_index);
 
 	hwi_gather_async_pdu(beiscsi_conn, phba, pasync_handle);
-	hwi_post_async_buffers(phba, pasync_handle->is_header);
+	hwi_post_async_buffers(phba, pasync_handle->is_header,
+			       BEISCSI_GET_ULP_FROM_CRI(
+			       phwi_ctrlr, cri_index));
 }
 
 static void  beiscsi_process_mcc_isr(struct beiscsi_hba *phba)
@@ -2497,24 +2521,13 @@ static void hwi_write_buffer(struct iscsi_wrb *pwrb, struct iscsi_task *task)
  **/
 static void beiscsi_find_mem_req(struct beiscsi_hba *phba)
 {
+	uint8_t mem_descr_index, ulp_num;
 	unsigned int num_cq_pages, num_async_pdu_buf_pages;
 	unsigned int num_async_pdu_data_pages, wrb_sz_per_cxn;
 	unsigned int num_async_pdu_buf_sgl_pages, num_async_pdu_data_sgl_pages;
 
 	num_cq_pages = PAGES_REQUIRED(phba->params.num_cq_entries * \
 				      sizeof(struct sol_cqe));
-	num_async_pdu_buf_pages =
-			PAGES_REQUIRED(phba->params.asyncpdus_per_ctrl * \
-				       phba->params.defpdu_hdr_sz);
-	num_async_pdu_buf_sgl_pages =
-			PAGES_REQUIRED(phba->params.asyncpdus_per_ctrl * \
-				       sizeof(struct phys_addr));
-	num_async_pdu_data_pages =
-			PAGES_REQUIRED(phba->params.asyncpdus_per_ctrl * \
-				       phba->params.defpdu_data_sz);
-	num_async_pdu_data_sgl_pages =
-			PAGES_REQUIRED(phba->params.asyncpdus_per_ctrl * \
-				       sizeof(struct phys_addr));
 
 	phba->params.hwi_ws_sz = sizeof(struct hwi_controller);
 
@@ -2538,24 +2551,74 @@ static void beiscsi_find_mem_req(struct beiscsi_hba *phba)
 		phba->params.num_sge_per_io * phba->params.icds_per_ctrl;
 	phba->mem_req[HWI_MEM_TEMPLATE_HDR] = phba->params.cxns_per_ctrl *
 					      BEISCSI_TEMPLATE_HDR_PER_CXN_SIZE;
+	for (ulp_num = 0; ulp_num < BEISCSI_ULP_COUNT; ulp_num++) {
+		if (test_bit(ulp_num, &phba->fw_config.ulp_supported)) {
 
-	phba->mem_req[HWI_MEM_ASYNC_HEADER_BUF] =
-		num_async_pdu_buf_pages * PAGE_SIZE;
-	phba->mem_req[HWI_MEM_ASYNC_DATA_BUF] =
-		num_async_pdu_data_pages * PAGE_SIZE;
-	phba->mem_req[HWI_MEM_ASYNC_HEADER_RING] =
-		num_async_pdu_buf_sgl_pages * PAGE_SIZE;
-	phba->mem_req[HWI_MEM_ASYNC_DATA_RING] =
-		num_async_pdu_data_sgl_pages * PAGE_SIZE;
-	phba->mem_req[HWI_MEM_ASYNC_HEADER_HANDLE] =
-		phba->params.asyncpdus_per_ctrl *
-		sizeof(struct async_pdu_handle);
-	phba->mem_req[HWI_MEM_ASYNC_DATA_HANDLE] =
-		phba->params.asyncpdus_per_ctrl *
-		sizeof(struct async_pdu_handle);
-	phba->mem_req[HWI_MEM_ASYNC_PDU_CONTEXT] =
-		sizeof(struct hwi_async_pdu_context) +
-		(phba->params.cxns_per_ctrl * sizeof(struct hwi_async_entry));
+			num_async_pdu_buf_sgl_pages =
+				PAGES_REQUIRED(BEISCSI_GET_CID_COUNT(
+					       phba, ulp_num) *
+					       sizeof(struct phys_addr));
+
+			num_async_pdu_buf_pages =
+				PAGES_REQUIRED(BEISCSI_GET_CID_COUNT(
+					       phba, ulp_num) *
+					       phba->params.defpdu_hdr_sz);
+
+			num_async_pdu_data_pages =
+				PAGES_REQUIRED(BEISCSI_GET_CID_COUNT(
+					       phba, ulp_num) *
+					       phba->params.defpdu_data_sz);
+
+			num_async_pdu_data_sgl_pages =
+				PAGES_REQUIRED(BEISCSI_GET_CID_COUNT(
+					       phba, ulp_num) *
+					       sizeof(struct phys_addr));
+
+
+			mem_descr_index = (HWI_MEM_ASYNC_HEADER_BUF_ULP0 +
+					  (ulp_num * MEM_DESCR_OFFSET));
+			phba->mem_req[mem_descr_index] =
+					  num_async_pdu_buf_pages *
+					  PAGE_SIZE;
+
+			mem_descr_index = (HWI_MEM_ASYNC_DATA_BUF_ULP0 +
+					  (ulp_num * MEM_DESCR_OFFSET));
+			phba->mem_req[mem_descr_index] =
+					  num_async_pdu_data_pages *
+					  PAGE_SIZE;
+
+			mem_descr_index = (HWI_MEM_ASYNC_HEADER_RING_ULP0 +
+					  (ulp_num * MEM_DESCR_OFFSET));
+			phba->mem_req[mem_descr_index] =
+					  num_async_pdu_buf_sgl_pages *
+					  PAGE_SIZE;
+
+			mem_descr_index = (HWI_MEM_ASYNC_DATA_RING_ULP0 +
+					  (ulp_num * MEM_DESCR_OFFSET));
+			phba->mem_req[mem_descr_index] =
+					  num_async_pdu_data_sgl_pages *
+					  PAGE_SIZE;
+
+			mem_descr_index = (HWI_MEM_ASYNC_HEADER_HANDLE_ULP0 +
+					  (ulp_num * MEM_DESCR_OFFSET));
+			phba->mem_req[mem_descr_index] =
+					  BEISCSI_GET_CID_COUNT(phba, ulp_num) *
+					  sizeof(struct async_pdu_handle);
+
+			mem_descr_index = (HWI_MEM_ASYNC_DATA_HANDLE_ULP0 +
+					  (ulp_num * MEM_DESCR_OFFSET));
+			phba->mem_req[mem_descr_index] =
+					  BEISCSI_GET_CID_COUNT(phba, ulp_num) *
+					  sizeof(struct async_pdu_handle);
+
+			mem_descr_index = (HWI_MEM_ASYNC_PDU_CONTEXT_ULP0 +
+					  (ulp_num * MEM_DESCR_OFFSET));
+			phba->mem_req[mem_descr_index] =
+					  sizeof(struct hwi_async_pdu_context) +
+					 (BEISCSI_GET_CID_COUNT(phba, ulp_num) *
+					  sizeof(struct hwi_async_entry));
+		}
+	}
 }
 
 static int beiscsi_alloc_mem(struct beiscsi_hba *phba)
@@ -2597,6 +2660,12 @@ static int beiscsi_alloc_mem(struct beiscsi_hba *phba)
 
 	mem_descr = phba->init_mem;
 	for (i = 0; i < SE_MEM_MAX; i++) {
+		if (!phba->mem_req[i]) {
+			mem_descr->mem_array = NULL;
+			mem_descr++;
+			continue;
+		}
+
 		j = 0;
 		mem_arr = mem_arr_orig;
 		alloc_size = phba->mem_req[i];
@@ -2800,6 +2869,7 @@ init_wrb_hndl_failed:
 
 static int hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 {
+	uint8_t ulp_num;
 	struct hwi_controller *phwi_ctrlr;
 	struct hba_parameters *p = &phba->params;
 	struct hwi_async_pdu_context *pasync_ctx;
@@ -2807,155 +2877,150 @@ static int hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 	unsigned int index, idx, num_per_mem, num_async_data;
 	struct be_mem_descriptor *mem_descr;
 
-	mem_descr = (struct be_mem_descriptor *)phba->init_mem;
-	mem_descr += HWI_MEM_ASYNC_PDU_CONTEXT;
+	for (ulp_num = 0; ulp_num < BEISCSI_ULP_COUNT; ulp_num++) {
+		if (test_bit(ulp_num, &phba->fw_config.ulp_supported)) {
 
-	phwi_ctrlr = phba->phwi_ctrlr;
-	phwi_ctrlr->phwi_ctxt->pasync_ctx = (struct hwi_async_pdu_context *)
+			mem_descr = (struct be_mem_descriptor *)phba->init_mem;
+			mem_descr += (HWI_MEM_ASYNC_PDU_CONTEXT_ULP0 +
+				     (ulp_num * MEM_DESCR_OFFSET));
+
+			phwi_ctrlr = phba->phwi_ctrlr;
+			phwi_ctrlr->phwi_ctxt->pasync_ctx[ulp_num] =
+				(struct hwi_async_pdu_context *)
+				 mem_descr->mem_array[0].virtual_address;
+
+			pasync_ctx = phwi_ctrlr->phwi_ctxt->pasync_ctx[ulp_num];
+			memset(pasync_ctx, 0, sizeof(*pasync_ctx));
+
+			pasync_ctx->async_entry =
+				(struct hwi_async_entry *)
+				((long unsigned int)pasync_ctx +
+				 sizeof(struct hwi_async_pdu_context));
+
+			pasync_ctx->num_entries =
+				BEISCSI_GET_CID_COUNT(phba, ulp_num);
+			pasync_ctx->buffer_size = p->defpdu_hdr_sz;
+
+			mem_descr = (struct be_mem_descriptor *)phba->init_mem;
+			mem_descr += HWI_MEM_ASYNC_HEADER_BUF_ULP0 +
+				(ulp_num * MEM_DESCR_OFFSET);
+			if (mem_descr->mem_array[0].virtual_address) {
+				beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
+					    "BM_%d : hwi_init_async_pdu_ctx"
+					    " HWI_MEM_ASYNC_HEADER_BUF_ULP%d va=%p\n",
+					    ulp_num,
+					    mem_descr->mem_array[0].
+					    virtual_address);
+			} else
+				beiscsi_log(phba, KERN_WARNING,
+					    BEISCSI_LOG_INIT,
+					    "BM_%d : No Virtual address for ULP : %d\n",
+					    ulp_num);
+
+			pasync_ctx->async_header.va_base =
 				mem_descr->mem_array[0].virtual_address;
-	pasync_ctx = phwi_ctrlr->phwi_ctxt->pasync_ctx;
-	memset(pasync_ctx, 0, sizeof(*pasync_ctx));
-
-	pasync_ctx->async_entry = kzalloc(sizeof(struct hwi_async_entry) *
-					  phba->params.cxns_per_ctrl,
-					  GFP_KERNEL);
-	if (!pasync_ctx->async_entry) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : hwi_init_async_pdu_ctx Mem Alloc Failed\n");
-		return -ENOMEM;
-	}
-
-	pasync_ctx->num_entries = p->asyncpdus_per_ctrl;
-	pasync_ctx->buffer_size = p->defpdu_hdr_sz;
-
-	mem_descr = (struct be_mem_descriptor *)phba->init_mem;
-	mem_descr += HWI_MEM_ASYNC_HEADER_BUF;
-	if (mem_descr->mem_array[0].virtual_address) {
-		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-			    "BM_%d : hwi_init_async_pdu_ctx"
-			    " HWI_MEM_ASYNC_HEADER_BUF va=%p\n",
-			    mem_descr->mem_array[0].virtual_address);
-	} else
-		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_INIT,
-			    "BM_%d : No Virtual address\n");
 
-	pasync_ctx->async_header.va_base =
-			mem_descr->mem_array[0].virtual_address;
-
-	pasync_ctx->async_header.pa_base.u.a64.address =
-			mem_descr->mem_array[0].bus_address.u.a64.address;
-
-	mem_descr = (struct be_mem_descriptor *)phba->init_mem;
-	mem_descr += HWI_MEM_ASYNC_HEADER_RING;
-	if (mem_descr->mem_array[0].virtual_address) {
-		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-			    "BM_%d : hwi_init_async_pdu_ctx"
-			    " HWI_MEM_ASYNC_HEADER_RING va=%p\n",
-			    mem_descr->mem_array[0].virtual_address);
-	} else
-		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_INIT,
-			    "BM_%d : No Virtual address\n");
-
-	pasync_ctx->async_header.ring_base =
-			mem_descr->mem_array[0].virtual_address;
-
-	mem_descr = (struct be_mem_descriptor *)phba->init_mem;
-	mem_descr += HWI_MEM_ASYNC_HEADER_HANDLE;
-	if (mem_descr->mem_array[0].virtual_address) {
-		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-			    "BM_%d : hwi_init_async_pdu_ctx"
-			    " HWI_MEM_ASYNC_HEADER_HANDLE va=%p\n",
-			    mem_descr->mem_array[0].virtual_address);
-	} else
-		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_INIT,
-			    "BM_%d : No Virtual address\n");
-
-	pasync_ctx->async_header.handle_base =
-			mem_descr->mem_array[0].virtual_address;
-	pasync_ctx->async_header.writables = 0;
-	INIT_LIST_HEAD(&pasync_ctx->async_header.free_list);
-
-
-	mem_descr = (struct be_mem_descriptor *)phba->init_mem;
-	mem_descr += HWI_MEM_ASYNC_DATA_RING;
-	if (mem_descr->mem_array[0].virtual_address) {
-		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-			    "BM_%d : hwi_init_async_pdu_ctx"
-			    " HWI_MEM_ASYNC_DATA_RING va=%p\n",
-			    mem_descr->mem_array[0].virtual_address);
-	} else
-		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_INIT,
-			    "BM_%d : No Virtual address\n");
-
-	pasync_ctx->async_data.ring_base =
-			mem_descr->mem_array[0].virtual_address;
+			pasync_ctx->async_header.pa_base.u.a64.address =
+				mem_descr->mem_array[0].
+				bus_address.u.a64.address;
 
-	mem_descr = (struct be_mem_descriptor *)phba->init_mem;
-	mem_descr += HWI_MEM_ASYNC_DATA_HANDLE;
-	if (!mem_descr->mem_array[0].virtual_address)
-		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_INIT,
-			    "BM_%d : No Virtual address\n");
+			mem_descr = (struct be_mem_descriptor *)phba->init_mem;
+			mem_descr += HWI_MEM_ASYNC_HEADER_RING_ULP0 +
+				     (ulp_num * MEM_DESCR_OFFSET);
+			if (mem_descr->mem_array[0].virtual_address) {
+				beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
+					    "BM_%d : hwi_init_async_pdu_ctx"
+					    " HWI_MEM_ASYNC_HEADER_RING_ULP%d va=%p\n",
+					    ulp_num,
+					    mem_descr->mem_array[0].
+					    virtual_address);
+			} else
+				beiscsi_log(phba, KERN_WARNING,
+					    BEISCSI_LOG_INIT,
+					    "BM_%d : No Virtual address for ULP : %d\n",
+					    ulp_num);
+
+			pasync_ctx->async_header.ring_base =
+				mem_descr->mem_array[0].virtual_address;
 
-	pasync_ctx->async_data.handle_base =
-			mem_descr->mem_array[0].virtual_address;
-	pasync_ctx->async_data.writables = 0;
-	INIT_LIST_HEAD(&pasync_ctx->async_data.free_list);
+			mem_descr = (struct be_mem_descriptor *)phba->init_mem;
+			mem_descr += HWI_MEM_ASYNC_HEADER_HANDLE_ULP0 +
+				     (ulp_num * MEM_DESCR_OFFSET);
+			if (mem_descr->mem_array[0].virtual_address) {
+				beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
+					    "BM_%d : hwi_init_async_pdu_ctx"
+					    " HWI_MEM_ASYNC_HEADER_HANDLE_ULP%d va=%p\n",
+					    ulp_num,
+					    mem_descr->mem_array[0].
+					    virtual_address);
+			} else
+				beiscsi_log(phba, KERN_WARNING,
+					    BEISCSI_LOG_INIT,
+					    "BM_%d : No Virtual address for ULP : %d\n",
+					    ulp_num);
+
+			pasync_ctx->async_header.handle_base =
+				mem_descr->mem_array[0].virtual_address;
+			pasync_ctx->async_header.writables = 0;
+			INIT_LIST_HEAD(&pasync_ctx->async_header.free_list);
+
+			mem_descr = (struct be_mem_descriptor *)phba->init_mem;
+			mem_descr += HWI_MEM_ASYNC_DATA_RING_ULP0 +
+				     (ulp_num * MEM_DESCR_OFFSET);
+			if (mem_descr->mem_array[0].virtual_address) {
+				beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
+					    "BM_%d : hwi_init_async_pdu_ctx"
+					    " HWI_MEM_ASYNC_DATA_RING_ULP%d va=%p\n",
+					    ulp_num,
+					    mem_descr->mem_array[0].
+					    virtual_address);
+			} else
+				beiscsi_log(phba, KERN_WARNING,
+					    BEISCSI_LOG_INIT,
+					    "BM_%d : No Virtual address for ULP : %d\n",
+					    ulp_num);
+
+			pasync_ctx->async_data.ring_base =
+				mem_descr->mem_array[0].virtual_address;
 
-	pasync_header_h =
-		(struct async_pdu_handle *)pasync_ctx->async_header.handle_base;
-	pasync_data_h =
-		(struct async_pdu_handle *)pasync_ctx->async_data.handle_base;
+			mem_descr = (struct be_mem_descriptor *)phba->init_mem;
+			mem_descr += HWI_MEM_ASYNC_DATA_HANDLE_ULP0 +
+				     (ulp_num * MEM_DESCR_OFFSET);
+			if (!mem_descr->mem_array[0].virtual_address)
+				beiscsi_log(phba, KERN_WARNING,
+					    BEISCSI_LOG_INIT,
+					    "BM_%d : No Virtual address for ULP : %d\n",
+					    ulp_num);
 
-	mem_descr = (struct be_mem_descriptor *)phba->init_mem;
-	mem_descr += HWI_MEM_ASYNC_DATA_BUF;
-	if (mem_descr->mem_array[0].virtual_address) {
-		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-			    "BM_%d : hwi_init_async_pdu_ctx"
-			    " HWI_MEM_ASYNC_DATA_BUF va=%p\n",
-			    mem_descr->mem_array[0].virtual_address);
-	} else
-		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_INIT,
-			    "BM_%d : No Virtual address\n");
-
-	idx = 0;
-	pasync_ctx->async_data.va_base =
-			mem_descr->mem_array[idx].virtual_address;
-	pasync_ctx->async_data.pa_base.u.a64.address =
-			mem_descr->mem_array[idx].bus_address.u.a64.address;
-
-	num_async_data = ((mem_descr->mem_array[idx].size) /
-				phba->params.defpdu_data_sz);
-	num_per_mem = 0;
-
-	for (index = 0; index < p->asyncpdus_per_ctrl; index++) {
-		pasync_header_h->cri = -1;
-		pasync_header_h->index = (char)index;
-		INIT_LIST_HEAD(&pasync_header_h->link);
-		pasync_header_h->pbuffer =
-			(void *)((unsigned long)
-			(pasync_ctx->async_header.va_base) +
-			(p->defpdu_hdr_sz * index));
-
-		pasync_header_h->pa.u.a64.address =
-			pasync_ctx->async_header.pa_base.u.a64.address +
-			(p->defpdu_hdr_sz * index);
-
-		list_add_tail(&pasync_header_h->link,
-				&pasync_ctx->async_header.free_list);
-		pasync_header_h++;
-		pasync_ctx->async_header.free_entries++;
-		pasync_ctx->async_header.writables++;
-
-		INIT_LIST_HEAD(&pasync_ctx->async_entry[index].wait_queue.list);
-		INIT_LIST_HEAD(&pasync_ctx->async_entry[index].
-			       header_busy_list);
-		pasync_data_h->cri = -1;
-		pasync_data_h->index = (char)index;
-		INIT_LIST_HEAD(&pasync_data_h->link);
-
-		if (!num_async_data) {
-			num_per_mem = 0;
-			idx++;
+			pasync_ctx->async_data.handle_base =
+				mem_descr->mem_array[0].virtual_address;
+			pasync_ctx->async_data.writables = 0;
+			INIT_LIST_HEAD(&pasync_ctx->async_data.free_list);
+
+			pasync_header_h =
+				(struct async_pdu_handle *)
+				pasync_ctx->async_header.handle_base;
+			pasync_data_h =
+				(struct async_pdu_handle *)
+				pasync_ctx->async_data.handle_base;
+
+			mem_descr = (struct be_mem_descriptor *)phba->init_mem;
+			mem_descr += HWI_MEM_ASYNC_DATA_BUF_ULP0 +
+				     (ulp_num * MEM_DESCR_OFFSET);
+			if (mem_descr->mem_array[0].virtual_address) {
+				beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
+					    "BM_%d : hwi_init_async_pdu_ctx"
+					    " HWI_MEM_ASYNC_DATA_BUF_ULP%d va=%p\n",
+					    ulp_num,
+					    mem_descr->mem_array[0].
+					    virtual_address);
+			} else
+				beiscsi_log(phba, KERN_WARNING,
+					    BEISCSI_LOG_INIT,
+					    "BM_%d : No Virtual address for ULP : %d\n",
+					    ulp_num);
+
+			idx = 0;
 			pasync_ctx->async_data.va_base =
 				mem_descr->mem_array[idx].virtual_address;
 			pasync_ctx->async_data.pa_base.u.a64.address =
@@ -2964,32 +3029,83 @@ static int hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 
 			num_async_data = ((mem_descr->mem_array[idx].size) /
 					phba->params.defpdu_data_sz);
-		}
-		pasync_data_h->pbuffer =
-			(void *)((unsigned long)
-			(pasync_ctx->async_data.va_base) +
-			(p->defpdu_data_sz * num_per_mem));
-
-		pasync_data_h->pa.u.a64.address =
-		    pasync_ctx->async_data.pa_base.u.a64.address +
-		    (p->defpdu_data_sz * num_per_mem);
-		num_per_mem++;
-		num_async_data--;
+			num_per_mem = 0;
 
-		list_add_tail(&pasync_data_h->link,
-			      &pasync_ctx->async_data.free_list);
-		pasync_data_h++;
-		pasync_ctx->async_data.free_entries++;
-		pasync_ctx->async_data.writables++;
+			for (index = 0;	index < BEISCSI_GET_CID_COUNT
+					(phba, ulp_num); index++) {
+				pasync_header_h->cri = -1;
+				pasync_header_h->index = (char)index;
+				INIT_LIST_HEAD(&pasync_header_h->link);
+				pasync_header_h->pbuffer =
+					(void *)((unsigned long)
+						 (pasync_ctx->
+						  async_header.va_base) +
+						 (p->defpdu_hdr_sz * index));
+
+				pasync_header_h->pa.u.a64.address =
+					pasync_ctx->async_header.pa_base.u.a64.
+					address + (p->defpdu_hdr_sz * index);
+
+				list_add_tail(&pasync_header_h->link,
+					      &pasync_ctx->async_header.
+					      free_list);
+				pasync_header_h++;
+				pasync_ctx->async_header.free_entries++;
+				pasync_ctx->async_header.writables++;
+
+				INIT_LIST_HEAD(&pasync_ctx->async_entry[index].
+					       wait_queue.list);
+				INIT_LIST_HEAD(&pasync_ctx->async_entry[index].
+					       header_busy_list);
+				pasync_data_h->cri = -1;
+				pasync_data_h->index = (char)index;
+				INIT_LIST_HEAD(&pasync_data_h->link);
+
+				if (!num_async_data) {
+					num_per_mem = 0;
+					idx++;
+					pasync_ctx->async_data.va_base =
+						mem_descr->mem_array[idx].
+						virtual_address;
+					pasync_ctx->async_data.pa_base.u.
+						a64.address =
+						mem_descr->mem_array[idx].
+						bus_address.u.a64.address;
+					num_async_data =
+						((mem_descr->mem_array[idx].
+						  size) /
+						 phba->params.defpdu_data_sz);
+				}
+				pasync_data_h->pbuffer =
+					(void *)((unsigned long)
+					(pasync_ctx->async_data.va_base) +
+					(p->defpdu_data_sz * num_per_mem));
+
+				pasync_data_h->pa.u.a64.address =
+					pasync_ctx->async_data.pa_base.u.a64.
+					address + (p->defpdu_data_sz *
+					num_per_mem);
+				num_per_mem++;
+				num_async_data--;
+
+				list_add_tail(&pasync_data_h->link,
+					      &pasync_ctx->async_data.
+					      free_list);
+				pasync_data_h++;
+				pasync_ctx->async_data.free_entries++;
+				pasync_ctx->async_data.writables++;
+
+				INIT_LIST_HEAD(&pasync_ctx->async_entry[index].
+					       data_busy_list);
+			}
 
-		INIT_LIST_HEAD(&pasync_ctx->async_entry[index].data_busy_list);
+			pasync_ctx->async_header.host_write_ptr = 0;
+			pasync_ctx->async_header.ep_read_ptr = -1;
+			pasync_ctx->async_data.host_write_ptr = 0;
+			pasync_ctx->async_data.ep_read_ptr = -1;
+		}
 	}
 
-	pasync_ctx->async_header.host_write_ptr = 0;
-	pasync_ctx->async_header.ep_read_ptr = -1;
-	pasync_ctx->async_data.host_write_ptr = 0;
-	pasync_ctx->async_data.ep_read_ptr = -1;
-
 	return 0;
 }
 
@@ -3185,7 +3301,7 @@ static int
 beiscsi_create_def_hdr(struct beiscsi_hba *phba,
 		       struct hwi_context_memory *phwi_context,
 		       struct hwi_controller *phwi_ctrlr,
-		       unsigned int def_pdu_ring_sz)
+		       unsigned int def_pdu_ring_sz, uint8_t ulp_num)
 {
 	unsigned int idx;
 	int ret;
@@ -3195,36 +3311,42 @@ beiscsi_create_def_hdr(struct beiscsi_hba *phba,
 	void *dq_vaddress;
 
 	idx = 0;
-	dq = &phwi_context->be_def_hdrq;
+	dq = &phwi_context->be_def_hdrq[ulp_num];
 	cq = &phwi_context->be_cq[0];
 	mem = &dq->dma_mem;
 	mem_descr = phba->init_mem;
-	mem_descr += HWI_MEM_ASYNC_HEADER_RING;
+	mem_descr += HWI_MEM_ASYNC_HEADER_RING_ULP0 +
+		    (ulp_num * MEM_DESCR_OFFSET);
 	dq_vaddress = mem_descr->mem_array[idx].virtual_address;
 	ret = be_fill_queue(dq, mem_descr->mem_array[0].size /
 			    sizeof(struct phys_addr),
 			    sizeof(struct phys_addr), dq_vaddress);
 	if (ret) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : be_fill_queue Failed for DEF PDU HDR\n");
+			    "BM_%d : be_fill_queue Failed for DEF PDU HDR on ULP : %d\n",
+			    ulp_num);
+
 		return ret;
 	}
 	mem->dma = (unsigned long)mem_descr->mem_array[idx].
 				  bus_address.u.a64.address;
 	ret = be_cmd_create_default_pdu_queue(&phba->ctrl, cq, dq,
 					      def_pdu_ring_sz,
-					      phba->params.defpdu_hdr_sz);
+					      phba->params.defpdu_hdr_sz,
+					      BEISCSI_DEFQ_HDR, ulp_num);
 	if (ret) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : be_cmd_create_default_pdu_queue Failed DEFHDR\n");
+			    "BM_%d : be_cmd_create_default_pdu_queue Failed DEFHDR on ULP : %d\n",
+			    ulp_num);
+
 		return ret;
 	}
-	phwi_ctrlr->default_pdu_hdr.id = phwi_context->be_def_hdrq.id;
-	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-		    "BM_%d : iscsi def pdu id is %d\n",
-		    phwi_context->be_def_hdrq.id);
 
-	hwi_post_async_buffers(phba, 1);
+	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
+		    "BM_%d : iscsi hdr def pdu id for ULP : %d is %d\n",
+		    ulp_num,
+		    phwi_context->be_def_hdrq[ulp_num].id);
+	hwi_post_async_buffers(phba, BEISCSI_DEFQ_HDR, ulp_num);
 	return 0;
 }
 
@@ -3232,7 +3354,7 @@ static int
 beiscsi_create_def_data(struct beiscsi_hba *phba,
 			struct hwi_context_memory *phwi_context,
 			struct hwi_controller *phwi_ctrlr,
-			unsigned int def_pdu_ring_sz)
+			unsigned int def_pdu_ring_sz, uint8_t ulp_num)
 {
 	unsigned int idx;
 	int ret;
@@ -3242,39 +3364,47 @@ beiscsi_create_def_data(struct beiscsi_hba *phba,
 	void *dq_vaddress;
 
 	idx = 0;
-	dataq = &phwi_context->be_def_dataq;
+	dataq = &phwi_context->be_def_dataq[ulp_num];
 	cq = &phwi_context->be_cq[0];
 	mem = &dataq->dma_mem;
 	mem_descr = phba->init_mem;
-	mem_descr += HWI_MEM_ASYNC_DATA_RING;
+	mem_descr += HWI_MEM_ASYNC_DATA_RING_ULP0 +
+		    (ulp_num * MEM_DESCR_OFFSET);
 	dq_vaddress = mem_descr->mem_array[idx].virtual_address;
 	ret = be_fill_queue(dataq, mem_descr->mem_array[0].size /
 			    sizeof(struct phys_addr),
 			    sizeof(struct phys_addr), dq_vaddress);
 	if (ret) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : be_fill_queue Failed for DEF PDU DATA\n");
+			    "BM_%d : be_fill_queue Failed for DEF PDU "
+			    "DATA on ULP : %d\n",
+			    ulp_num);
+
 		return ret;
 	}
 	mem->dma = (unsigned long)mem_descr->mem_array[idx].
 				  bus_address.u.a64.address;
 	ret = be_cmd_create_default_pdu_queue(&phba->ctrl, cq, dataq,
 					      def_pdu_ring_sz,
-					      phba->params.defpdu_data_sz);
+					      phba->params.defpdu_data_sz,
+					      BEISCSI_DEFQ_DATA, ulp_num);
 	if (ret) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
 			    "BM_%d be_cmd_create_default_pdu_queue"
-			    " Failed for DEF PDU DATA\n");
+			    " Failed for DEF PDU DATA on ULP : %d\n",
+			    ulp_num);
 		return ret;
 	}
-	phwi_ctrlr->default_pdu_data.id = phwi_context->be_def_dataq.id;
+
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-		    "BM_%d : iscsi def data id is %d\n",
-		    phwi_context->be_def_dataq.id);
+		    "BM_%d : iscsi def data id on ULP : %d is  %d\n",
+		    ulp_num,
+		    phwi_context->be_def_dataq[ulp_num].id);
 
-	hwi_post_async_buffers(phba, 0);
+	hwi_post_async_buffers(phba, BEISCSI_DEFQ_DATA, ulp_num);
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-		    "BM_%d : DEFAULT PDU DATA RING CREATED\n");
+		    "BM_%d : DEFAULT PDU DATA RING CREATED"
+		    "on ULP : %d\n", ulp_num);
 
 	return 0;
 }
@@ -3484,7 +3614,7 @@ static void hwi_cleanup(struct beiscsi_hba *phba)
 	struct hwi_controller *phwi_ctrlr;
 	struct hwi_context_memory *phwi_context;
 	struct hwi_async_pdu_context *pasync_ctx;
-	int i, eq_num;
+	int i, eq_num, ulp_num;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
 	phwi_context = phwi_ctrlr->phwi_ctxt;
@@ -3499,13 +3629,20 @@ static void hwi_cleanup(struct beiscsi_hba *phba)
 	kfree(phwi_context->be_wrbq);
 	free_wrb_handles(phba);
 
-	q = &phwi_context->be_def_hdrq;
-	if (q->created)
-		beiscsi_cmd_q_destroy(ctrl, q, QTYPE_DPDUQ);
+	for (ulp_num = 0; ulp_num < BEISCSI_ULP_COUNT; ulp_num++) {
+		if (test_bit(ulp_num, &phba->fw_config.ulp_supported)) {
 
-	q = &phwi_context->be_def_dataq;
-	if (q->created)
-		beiscsi_cmd_q_destroy(ctrl, q, QTYPE_DPDUQ);
+			q = &phwi_context->be_def_hdrq[ulp_num];
+			if (q->created)
+				beiscsi_cmd_q_destroy(ctrl, q, QTYPE_DPDUQ);
+
+			q = &phwi_context->be_def_dataq[ulp_num];
+			if (q->created)
+				beiscsi_cmd_q_destroy(ctrl, q, QTYPE_DPDUQ);
+
+			pasync_ctx = phwi_ctrlr->phwi_ctxt->pasync_ctx[ulp_num];
+		}
+	}
 
 	beiscsi_cmd_q_destroy(ctrl, NULL, QTYPE_SGL);
 
@@ -3524,9 +3661,6 @@ static void hwi_cleanup(struct beiscsi_hba *phba)
 			beiscsi_cmd_q_destroy(ctrl, q, QTYPE_EQ);
 	}
 	be_mcc_queues_destroy(phba);
-
-	pasync_ctx = phwi_ctrlr->phwi_ctxt->pasync_ctx;
-	kfree(pasync_ctx->async_entry);
 	be_cmd_fw_uninit(ctrl);
 }
 
@@ -3606,10 +3740,8 @@ static int hwi_init_port(struct beiscsi_hba *phba)
 	struct hwi_context_memory *phwi_context;
 	unsigned int def_pdu_ring_sz;
 	struct be_ctrl_info *ctrl = &phba->ctrl;
-	int status;
+	int status, ulp_num;
 
-	def_pdu_ring_sz =
-		phba->params.asyncpdus_per_ctrl * sizeof(struct phys_addr);
 	phwi_ctrlr = phba->phwi_ctrlr;
 	phwi_context = phwi_ctrlr->phwi_ctxt;
 	phwi_context->max_eqd = 0;
@@ -3642,20 +3774,35 @@ static int hwi_init_port(struct beiscsi_hba *phba)
 		goto error;
 	}
 
-	status = beiscsi_create_def_hdr(phba, phwi_context, phwi_ctrlr,
-					def_pdu_ring_sz);
-	if (status != 0) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : Default Header not created\n");
-		goto error;
-	}
+	for (ulp_num = 0; ulp_num < BEISCSI_ULP_COUNT; ulp_num++) {
+		if (test_bit(ulp_num, &phba->fw_config.ulp_supported)) {
 
-	status = beiscsi_create_def_data(phba, phwi_context,
-					 phwi_ctrlr, def_pdu_ring_sz);
-	if (status != 0) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : Default Data not created\n");
-		goto error;
+			def_pdu_ring_sz =
+				BEISCSI_GET_CID_COUNT(phba, ulp_num) *
+				sizeof(struct phys_addr);
+
+			status = beiscsi_create_def_hdr(phba, phwi_context,
+							phwi_ctrlr,
+							def_pdu_ring_sz,
+							ulp_num);
+			if (status != 0) {
+				beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
+					    "BM_%d : Default Header not created for ULP : %d\n",
+					    ulp_num);
+				goto error;
+			}
+
+			status = beiscsi_create_def_data(phba, phwi_context,
+							 phwi_ctrlr,
+							 def_pdu_ring_sz,
+							 ulp_num);
+			if (status != 0) {
+				beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
+					    "BM_%d : Default Data not created for ULP : %d\n",
+					    ulp_num);
+				goto error;
+			}
+		}
 	}
 
 	status = beiscsi_post_pages(phba);
@@ -3678,6 +3825,26 @@ static int hwi_init_port(struct beiscsi_hba *phba)
 		goto error;
 	}
 
+	for (ulp_num = 0; ulp_num < BEISCSI_ULP_COUNT; ulp_num++) {
+		uint16_t async_arr_idx = 0;
+
+		if (test_bit(ulp_num, &phba->fw_config.ulp_supported)) {
+			uint16_t cri = 0;
+			struct hwi_async_pdu_context *pasync_ctx;
+
+			pasync_ctx = HWI_GET_ASYNC_PDU_CTX(
+				     phwi_ctrlr, ulp_num);
+			for (cri = 0; cri <
+			     phba->params.cxns_per_ctrl; cri++) {
+				if (ulp_num == BEISCSI_GET_ULP_FROM_CRI
+					       (phwi_ctrlr, cri))
+					pasync_ctx->cid_to_async_cri_map[
+					phwi_ctrlr->wrb_context[cri].cid] =
+					async_arr_idx++;
+			}
+		}
+	}
+
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
 		    "BM_%d : hwi_init_port success\n");
 	return 0;
@@ -3742,6 +3909,7 @@ static void beiscsi_free_mem(struct beiscsi_hba *phba)
 			  (unsigned long)mem_descr->mem_array[j - 1].
 			  bus_address.u.a64.address);
 		}
+
 		kfree(mem_descr->mem_array);
 		mem_descr++;
 	}
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 39bc185..d0bbf37 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -105,7 +105,8 @@
  * So have atleast 8 of them by default
  */
 
-#define HWI_GET_ASYNC_PDU_CTX(phwi)	(phwi->phwi_ctxt->pasync_ctx)
+#define HWI_GET_ASYNC_PDU_CTX(phwi, ulp_num)	\
+	(phwi->phwi_ctxt->pasync_ctx[ulp_num])
 
 /********* Memory BAR register ************/
 #define PCICFG_MEMBAR_CTRL_INT_CTRL_OFFSET	0xfc
@@ -150,16 +151,19 @@
 #define DB_CQ_REARM_SHIFT		(29)	/* bit 29 */
 
 #define GET_HWI_CONTROLLER_WS(pc)	(pc->phwi_ctrlr)
-#define HWI_GET_DEF_BUFQ_ID(pc) (((struct hwi_controller *)\
-		(GET_HWI_CONTROLLER_WS(pc)))->default_pdu_data.id)
-#define HWI_GET_DEF_HDRQ_ID(pc) (((struct hwi_controller *)\
-		(GET_HWI_CONTROLLER_WS(pc)))->default_pdu_hdr.id)
+#define HWI_GET_DEF_BUFQ_ID(pc, ulp_num) (((struct hwi_controller *)\
+		(GET_HWI_CONTROLLER_WS(pc)))->default_pdu_data[ulp_num].id)
+#define HWI_GET_DEF_HDRQ_ID(pc, ulp_num) (((struct hwi_controller *)\
+		(GET_HWI_CONTROLLER_WS(pc)))->default_pdu_hdr[ulp_num].id)
 
 #define PAGES_REQUIRED(x) \
 	((x < PAGE_SIZE) ? 1 :  ((x + PAGE_SIZE - 1) / PAGE_SIZE))
 
 #define BEISCSI_MSI_NAME 20 /* size of msi_name string */
 
+#define MEM_DESCR_OFFSET 7
+#define BEISCSI_DEFQ_HDR 1
+#define BEISCSI_DEFQ_DATA 0
 enum be_mem_enum {
 	HWI_MEM_ADDN_CONTEXT,
 	HWI_MEM_WRB,
@@ -167,13 +171,20 @@ enum be_mem_enum {
 	HWI_MEM_SGLH,
 	HWI_MEM_SGE,
 	HWI_MEM_TEMPLATE_HDR,
-	HWI_MEM_ASYNC_HEADER_BUF,	/* 5 */
-	HWI_MEM_ASYNC_DATA_BUF,
-	HWI_MEM_ASYNC_HEADER_RING,
-	HWI_MEM_ASYNC_DATA_RING,
-	HWI_MEM_ASYNC_HEADER_HANDLE,
-	HWI_MEM_ASYNC_DATA_HANDLE,	/* 10 */
-	HWI_MEM_ASYNC_PDU_CONTEXT,
+	HWI_MEM_ASYNC_HEADER_BUF_ULP0,
+	HWI_MEM_ASYNC_DATA_BUF_ULP0,
+	HWI_MEM_ASYNC_HEADER_RING_ULP0,
+	HWI_MEM_ASYNC_DATA_RING_ULP0,
+	HWI_MEM_ASYNC_HEADER_HANDLE_ULP0,
+	HWI_MEM_ASYNC_DATA_HANDLE_ULP0,
+	HWI_MEM_ASYNC_PDU_CONTEXT_ULP0,
+	HWI_MEM_ASYNC_HEADER_BUF_ULP1,
+	HWI_MEM_ASYNC_DATA_BUF_ULP1,
+	HWI_MEM_ASYNC_HEADER_RING_ULP1,
+	HWI_MEM_ASYNC_DATA_RING_ULP1,
+	HWI_MEM_ASYNC_HEADER_HANDLE_ULP1,
+	HWI_MEM_ASYNC_DATA_HANDLE_ULP1,
+	HWI_MEM_ASYNC_PDU_CONTEXT_ULP1,
 	ISCSI_MEM_GLOBAL_HEADER,
 	SE_MEM_MAX
 };
@@ -337,7 +348,7 @@ struct beiscsi_hba {
 		unsigned int phys_port;
 		unsigned int iscsi_cid_start[BEISCSI_ULP_COUNT];
 #define BEISCSI_GET_CID_COUNT(phba, ulp_num) \
-			      (phba->fw_config.iscsi_cid_count[ulp_num])
+		(phba->fw_config.iscsi_cid_count[ulp_num])
 		unsigned int iscsi_cid_count[BEISCSI_ULP_COUNT];
 		unsigned int iscsi_icd_count[BEISCSI_ULP_COUNT];
 		unsigned int iscsi_icd_start[BEISCSI_ULP_COUNT];
@@ -577,7 +588,8 @@ struct hwi_async_pdu_context {
 
 	unsigned int buffer_size;
 	unsigned int num_entries;
-
+#define BE_GET_ASYNC_CRI_FROM_CID(cid) (pasync_ctx->cid_to_async_cri_map[cid])
+	unsigned short cid_to_async_cri_map[BE_MAX_SESSION];
 	/**
 	 * This is a varying size list! Do not add anything
 	 * after this entry!!
@@ -931,6 +943,10 @@ struct be_ring {
 	u32 cidx;		/* consumer index */
 	u32 pidx;		/* producer index -- not used by most rings */
 	u32 item_size;		/* size in bytes of one object */
+	u8 ulp_num;	/* ULP to which CID binded */
+	u16 register_set;
+	u16 doorbell_format;
+	u32 doorbell_offset;
 
 	void *va;		/* The virtual address of the ring.  This
 				 * should be last to allow 32 & 64 bit debugger
@@ -938,6 +954,8 @@ struct be_ring {
 				 */
 };
 
+#define BEISCSI_GET_ULP_FROM_CRI(phwi_ctrlr, cri) \
+	(phwi_ctrlr->wrb_context[cri].ulp_num)
 struct hwi_wrb_context {
 	struct list_head wrb_handle_list;
 	struct list_head wrb_handle_drvr_list;
@@ -948,6 +966,7 @@ struct hwi_wrb_context {
 	unsigned short free_index;
 	unsigned short wrb_handles_available;
 	unsigned short cid;
+	uint8_t ulp_num;	/* ULP to which CID binded */
 };
 
 struct hwi_controller {
@@ -958,8 +977,8 @@ struct hwi_controller {
 
 	struct hwi_wrb_context *wrb_context;
 	struct mcc_wrb *pmcc_wrb_base;
-	struct be_ring default_pdu_hdr;
-	struct be_ring default_pdu_data;
+	struct be_ring default_pdu_hdr[BEISCSI_ULP_COUNT];
+	struct be_ring default_pdu_data[BEISCSI_ULP_COUNT];
 	struct hwi_context_memory *phwi_ctxt;
 };
 
@@ -990,11 +1009,10 @@ struct hwi_context_memory {
 	struct be_eq_obj be_eq[MAX_CPUS];
 	struct be_queue_info be_cq[MAX_CPUS - 1];
 
-	struct be_queue_info be_def_hdrq;
-	struct be_queue_info be_def_dataq;
-
 	struct be_queue_info *be_wrbq;
-	struct hwi_async_pdu_context *pasync_ctx;
+	struct be_queue_info be_def_hdrq[BEISCSI_ULP_COUNT];
+	struct be_queue_info be_def_dataq[BEISCSI_ULP_COUNT];
+	struct hwi_async_pdu_context *pasync_ctx[BEISCSI_ULP_COUNT];
 };
 
 /* Logging related definitions */
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index ee0b4c7..0bebe3c 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -315,7 +315,7 @@ int mgmt_get_fw_config(struct be_ctrl_info *ctrl,
 			if (pfw_cfg->ulp[ulp_num].ulp_mode &
 			    BEISCSI_ULP_ISCSI_INI_MODE)
 				set_bit(ulp_num,
-					&phba->fw_config.ulp_supported);
+				&phba->fw_config.ulp_supported);
 
 		phba->fw_config.phys_port = pfw_cfg->phys_port;
 		for (ulp_num = 0; ulp_num < BEISCSI_ULP_COUNT; ulp_num++) {
@@ -507,8 +507,8 @@ int mgmt_epfw_cleanup(struct beiscsi_hba *phba, unsigned short chute)
 			   OPCODE_COMMON_ISCSI_CLEANUP, sizeof(*req));
 
 	req->chute = chute;
-	req->hdr_ring_id = cpu_to_le16(HWI_GET_DEF_HDRQ_ID(phba));
-	req->data_ring_id = cpu_to_le16(HWI_GET_DEF_BUFQ_ID(phba));
+	req->hdr_ring_id = cpu_to_le16(HWI_GET_DEF_HDRQ_ID(phba, 0));
+	req->data_ring_id = cpu_to_le16(HWI_GET_DEF_BUFQ_ID(phba, 0));
 
 	status =  be_mcc_notify_wait(phba);
 	if (status)
@@ -652,8 +652,8 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 
 	phwi_ctrlr = phba->phwi_ctrlr;
 	phwi_context = phwi_ctrlr->phwi_ctxt;
-	def_hdr_id = (unsigned short)HWI_GET_DEF_HDRQ_ID(phba);
-	def_data_id = (unsigned short)HWI_GET_DEF_BUFQ_ID(phba);
+	def_hdr_id = (unsigned short)HWI_GET_DEF_HDRQ_ID(phba, 0);
+	def_data_id = (unsigned short)HWI_GET_DEF_BUFQ_ID(phba, 0);
 
 	ptemplate_address = &template_address;
 	ISCSI_GET_PDU_TEMPLATE_ADDRESS(phba, ptemplate_address);
-- 
1.7.10.4

