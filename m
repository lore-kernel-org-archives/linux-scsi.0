From: John Soni Jose <sony.john@avagotech.com>
Subject: [PATCH 1/2] be2iscsi: Fix updating the next pointer during WRB posting
Date: Thu, 20 Aug 2015 04:44:30 +0530
Message-ID: <1440026071-27748-2-git-send-email-sony.john@avagotech.com>
References: <1440026071-27748-1-git-send-email-sony.john@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:50759 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753287AbbHSGtP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Aug 2015 02:49:15 -0400
In-Reply-To: <1440026071-27748-1-git-send-email-sony.john@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: John Soni Jose <sony.john@avagotech.com>

 While posting WRB the next_pointer of the current WRB should point
 to itself and the previous WRB next_pointer should point to the
 current WRB.

 The next pointer value was retrieved during alloc_pdu and was updated
 in wrb before ringing the doorbell. The fix retrieves the
 next_pointer just before ringing the doorbell and updates in the WRB.

Signed-off-by: John Soni Jose <sony.john@avagotech.com>
---
 drivers/scsi/be2iscsi/be_main.c |   62 +++++++++++++++++++++++++++++---------
 drivers/scsi/be2iscsi/be_main.h |    5 ++-
 drivers/scsi/be2iscsi/be_mgmt.c |   24 ++++++++++++--
 drivers/scsi/be2iscsi/be_mgmt.h |    7 +++-
 4 files changed, 75 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 7a6dbfb..a56ad6a 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1198,14 +1198,16 @@ free_io_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
  * alloc_wrb_handle - To allocate a wrb handle
  * @phba: The hba pointer
  * @cid: The cid to use for allocation
+ * @pwrb_context: ptr to ptr to wrb context
  *
  * This happens under session_lock until submission to chip
  */
-struct wrb_handle *alloc_wrb_handle(struct beiscsi_hba *phba, unsigned int cid)
+struct wrb_handle *alloc_wrb_handle(struct beiscsi_hba *phba, unsigned int cid,
+				     struct hwi_wrb_context **pcontext)
 {
 	struct hwi_wrb_context *pwrb_context;
 	struct hwi_controller *phwi_ctrlr;
-	struct wrb_handle *pwrb_handle, *pwrb_handle_tmp;
+	struct wrb_handle *pwrb_handle;
 	uint16_t cri_index = BE_GET_CRI_FROM_CID(cid);
 
 	phwi_ctrlr = phba->phwi_ctrlr;
@@ -1219,9 +1221,9 @@ struct wrb_handle *alloc_wrb_handle(struct beiscsi_hba *phba, unsigned int cid)
 			pwrb_context->alloc_index = 0;
 		else
 			pwrb_context->alloc_index++;
-		pwrb_handle_tmp = pwrb_context->pwrb_handle_base[
-						pwrb_context->alloc_index];
-		pwrb_handle->nxt_wrb_index = pwrb_handle_tmp->wrb_index;
+
+		/* Return the context address */
+		*pcontext = pwrb_context;
 	} else
 		pwrb_handle = NULL;
 	return pwrb_handle;
@@ -4678,6 +4680,7 @@ beiscsi_offload_connection(struct beiscsi_conn *beiscsi_conn,
 			   struct beiscsi_offload_params *params)
 {
 	struct wrb_handle *pwrb_handle;
+	struct hwi_wrb_context *pwrb_context = NULL;
 	struct beiscsi_hba *phba = beiscsi_conn->phba;
 	struct iscsi_task *task = beiscsi_conn->task;
 	struct iscsi_session *session = task->conn->session;
@@ -4692,14 +4695,17 @@ beiscsi_offload_connection(struct beiscsi_conn *beiscsi_conn,
 	beiscsi_cleanup_task(task);
 	spin_unlock_bh(&session->back_lock);
 
-	pwrb_handle = alloc_wrb_handle(phba, beiscsi_conn->beiscsi_conn_cid);
+	pwrb_handle = alloc_wrb_handle(phba, beiscsi_conn->beiscsi_conn_cid,
+				       &pwrb_context);
 
 	/* Check for the adapter family */
 	if (is_chip_be2_be3r(phba))
 		beiscsi_offload_cxn_v0(params, pwrb_handle,
-				       phba->init_mem);
+				       phba->init_mem,
+				       pwrb_context);
 	else
-		beiscsi_offload_cxn_v2(params, pwrb_handle);
+		beiscsi_offload_cxn_v2(params, pwrb_handle,
+				       pwrb_context);
 
 	be_dws_le_to_cpu(pwrb_handle->pwrb,
 			 sizeof(struct iscsi_target_context_update_wrb));
@@ -4769,7 +4775,8 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 			goto free_hndls;
 		}
 		io_task->pwrb_handle = alloc_wrb_handle(phba,
-					beiscsi_conn->beiscsi_conn_cid);
+					beiscsi_conn->beiscsi_conn_cid,
+					&io_task->pwrb_context);
 		if (!io_task->pwrb_handle) {
 			beiscsi_log(phba, KERN_ERR,
 				    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
@@ -4803,7 +4810,8 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 							io_task->psgl_handle;
 				io_task->pwrb_handle =
 					alloc_wrb_handle(phba,
-					beiscsi_conn->beiscsi_conn_cid);
+					beiscsi_conn->beiscsi_conn_cid,
+					&io_task->pwrb_context);
 				if (!io_task->pwrb_handle) {
 					beiscsi_log(phba, KERN_ERR,
 						    BEISCSI_LOG_IO |
@@ -4839,7 +4847,8 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 			}
 			io_task->pwrb_handle =
 					alloc_wrb_handle(phba,
-					beiscsi_conn->beiscsi_conn_cid);
+					beiscsi_conn->beiscsi_conn_cid,
+					&io_task->pwrb_context);
 			if (!io_task->pwrb_handle) {
 				beiscsi_log(phba, KERN_ERR,
 					    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
@@ -4925,7 +4934,12 @@ int beiscsi_iotask_v2(struct iscsi_task *task, struct scatterlist *sg,
 
 	hwi_write_sgl_v2(pwrb, sg, num_sg, io_task);
 	AMAP_SET_BITS(struct amap_iscsi_wrb_v2, ptr2nextwrb, pwrb,
-		      io_task->pwrb_handle->nxt_wrb_index);
+		      io_task->pwrb_handle->wrb_index);
+	if (io_task->pwrb_context->plast_wrb)
+		AMAP_SET_BITS(struct amap_iscsi_wrb_v2, ptr2nextwrb,
+			      io_task->pwrb_context->plast_wrb,
+			      io_task->pwrb_handle->wrb_index);
+	io_task->pwrb_context->plast_wrb = pwrb;
 
 	be_dws_le_to_cpu(pwrb, sizeof(struct iscsi_wrb));
 
@@ -4982,7 +4996,13 @@ static int beiscsi_iotask(struct iscsi_task *task, struct scatterlist *sg,
 	hwi_write_sgl(pwrb, sg, num_sg, io_task);
 
 	AMAP_SET_BITS(struct amap_iscsi_wrb, ptr2nextwrb, pwrb,
-		      io_task->pwrb_handle->nxt_wrb_index);
+		      io_task->pwrb_handle->wrb_index);
+	if (io_task->pwrb_context->plast_wrb)
+		AMAP_SET_BITS(struct amap_iscsi_wrb, ptr2nextwrb,
+			      io_task->pwrb_context->plast_wrb,
+			      io_task->pwrb_handle->wrb_index);
+	io_task->pwrb_context->plast_wrb = pwrb;
+
 	be_dws_le_to_cpu(pwrb, sizeof(struct iscsi_wrb));
 
 	doorbell |= beiscsi_conn->beiscsi_conn_cid & DB_WRB_POST_CID_MASK;
@@ -5020,7 +5040,13 @@ static int beiscsi_mtask(struct iscsi_task *task)
 		AMAP_SET_BITS(struct amap_iscsi_wrb, r2t_exp_dtl, pwrb,
 			      task->data_count);
 		AMAP_SET_BITS(struct amap_iscsi_wrb, ptr2nextwrb, pwrb,
-			      io_task->pwrb_handle->nxt_wrb_index);
+			      io_task->pwrb_handle->wrb_index);
+		if (io_task->pwrb_context->plast_wrb)
+			AMAP_SET_BITS(struct amap_iscsi_wrb, ptr2nextwrb,
+				      io_task->pwrb_context->plast_wrb,
+				      io_task->pwrb_handle->wrb_index);
+		io_task->pwrb_context->plast_wrb = pwrb;
+
 		pwrb_typeoffset = BE_WRB_TYPE_OFFSET;
 	} else {
 		AMAP_SET_BITS(struct amap_iscsi_wrb_v2, cmdsn_itt, pwrb,
@@ -5032,7 +5058,13 @@ static int beiscsi_mtask(struct iscsi_task *task)
 		AMAP_SET_BITS(struct amap_iscsi_wrb_v2, r2t_exp_dtl, pwrb,
 			      task->data_count);
 		AMAP_SET_BITS(struct amap_iscsi_wrb_v2, ptr2nextwrb, pwrb,
-			      io_task->pwrb_handle->nxt_wrb_index);
+			      io_task->pwrb_handle->wrb_index);
+		if (io_task->pwrb_context->plast_wrb)
+			AMAP_SET_BITS(struct amap_iscsi_wrb_v2, ptr2nextwrb,
+				      io_task->pwrb_context->plast_wrb,
+				      io_task->pwrb_handle->wrb_index);
+		io_task->pwrb_context->plast_wrb = pwrb;
+
 		pwrb_typeoffset = SKH_WRB_TYPE_OFFSET;
 	}
 
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index b8c0c78..afcd55f 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -502,6 +502,7 @@ struct beiscsi_io_task {
 	struct sgl_handle *psgl_handle;
 	struct beiscsi_conn *conn;
 	struct scsi_cmnd *scsi_cmnd;
+	struct hwi_wrb_context *pwrb_context;
 	unsigned int cmd_sn;
 	unsigned int flags;
 	unsigned short cid;
@@ -833,7 +834,8 @@ struct amap_iscsi_wrb_v2 {
 } __packed;
 
 
-struct wrb_handle *alloc_wrb_handle(struct beiscsi_hba *phba, unsigned int cid);
+struct wrb_handle *alloc_wrb_handle(struct beiscsi_hba *phba, unsigned int cid,
+				     struct hwi_wrb_context **pcontext);
 void
 free_mgmt_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle);
 
@@ -1044,7 +1046,6 @@ enum hwh_type_enum {
 struct wrb_handle {
 	enum hwh_type_enum type;
 	unsigned short wrb_index;
-	unsigned short nxt_wrb_index;
 
 	struct iscsi_task *pio_handle;
 	struct iscsi_wrb *pwrb;
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index ca4016f..b4e0415 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1573,7 +1573,8 @@ beiscsi_phys_port_disp(struct device *dev, struct device_attribute *attr,
 
 void beiscsi_offload_cxn_v0(struct beiscsi_offload_params *params,
 			     struct wrb_handle *pwrb_handle,
-			     struct be_mem_descriptor *mem_descr)
+			     struct be_mem_descriptor *mem_descr,
+			     struct hwi_wrb_context *pwrb_context)
 {
 	struct iscsi_wrb *pwrb = pwrb_handle->pwrb;
 
@@ -1617,7 +1618,14 @@ void beiscsi_offload_cxn_v0(struct beiscsi_offload_params *params,
 		      max_burst_length) / 32]);
 
 	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb, ptr2nextwrb,
-		      pwrb, pwrb_handle->nxt_wrb_index);
+		      pwrb, pwrb_handle->wrb_index);
+	if (pwrb_context->plast_wrb)
+		AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb,
+			      ptr2nextwrb,
+			      pwrb_context->plast_wrb,
+			      pwrb_handle->wrb_index);
+	pwrb_context->plast_wrb = pwrb;
+
 	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb,
 		      session_state, pwrb, 0);
 	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb, compltonack,
@@ -1637,7 +1645,8 @@ void beiscsi_offload_cxn_v0(struct beiscsi_offload_params *params,
 }
 
 void beiscsi_offload_cxn_v2(struct beiscsi_offload_params *params,
-			     struct wrb_handle *pwrb_handle)
+			     struct wrb_handle *pwrb_handle,
+			     struct hwi_wrb_context *pwrb_context)
 {
 	struct iscsi_wrb *pwrb = pwrb_handle->pwrb;
 
@@ -1652,7 +1661,14 @@ void beiscsi_offload_cxn_v2(struct beiscsi_offload_params *params,
 		      BE_TGT_CTX_UPDT_CMD);
 	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb_v2,
 		      ptr2nextwrb,
-		      pwrb, pwrb_handle->nxt_wrb_index);
+		      pwrb, pwrb_handle->wrb_index);
+	if (pwrb_context->plast_wrb)
+		AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb_v2,
+			      ptr2nextwrb,
+			      pwrb_context->plast_wrb,
+			      pwrb_handle->wrb_index);
+	pwrb_context->plast_wrb = pwrb;
+
 	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb_v2, wrb_idx,
 		      pwrb, pwrb_handle->wrb_index);
 	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb_v2,
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index b58a7de..1df0a01 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -330,10 +330,13 @@ ssize_t beiscsi_phys_port_disp(struct device *dev,
 
 void beiscsi_offload_cxn_v0(struct beiscsi_offload_params *params,
 			     struct wrb_handle *pwrb_handle,
-			     struct be_mem_descriptor *mem_descr);
+			     struct be_mem_descriptor *mem_descr,
+			     struct hwi_wrb_context *pwrb_context);
 
 void beiscsi_offload_cxn_v2(struct beiscsi_offload_params *params,
-			     struct wrb_handle *pwrb_handle);
+			     struct wrb_handle *pwrb_handle,
+			     struct hwi_wrb_context *pwrb_context);
+
 void beiscsi_ue_detect(struct beiscsi_hba *phba);
 int be_cmd_modify_eq_delay(struct beiscsi_hba *phba,
 			 struct be_set_eqd *, int num);
-- 
1.7.1

