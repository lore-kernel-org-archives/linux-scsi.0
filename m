From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v2 01/13] be2iscsi: Fix use of invalidate command table req
Date: Tue, 13 Dec 2016 15:55:54 +0530
Message-ID: <1481624766-13846-2-git-send-email-jitendra.bhivare@broadcom.com>
References: <1481624766-13846-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:35155 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932220AbcLMK0h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2016 05:26:37 -0500
Received: by mail-qt0-f170.google.com with SMTP id c47so102221293qtc.2
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2016 02:26:37 -0800 (PST)
In-Reply-To: <1481624766-13846-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Remove shared structure inv_tbl in phba for all sessions to post
invalidation IOCTL.
Always allocate and then free the table after use in reset handler.
Abort handler needs just one instance so define it on stack.
Add checks for BE_INVLDT_CMD_TBL_SZ to not exceed invalidation
command table size in IOCTL.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_main.c | 85 ++++++++++++++++++++++++-----------------
 drivers/scsi/be2iscsi/be_main.h | 16 ++++----
 drivers/scsi/be2iscsi/be_mgmt.c | 12 +++---
 drivers/scsi/be2iscsi/be_mgmt.h | 40 +++++++++----------
 4 files changed, 83 insertions(+), 70 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index b5112d6..3811a0d 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -225,9 +225,9 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 	struct beiscsi_conn *beiscsi_conn;
 	struct beiscsi_hba *phba;
 	struct iscsi_session *session;
-	struct invalidate_command_table *inv_tbl;
+	struct invldt_cmd_tbl inv_tbl;
 	struct be_dma_mem nonemb_cmd;
-	unsigned int cid, tag, num_invalidate;
+	unsigned int cid, tag;
 	int rc;
 
 	cls_session = starget_to_session(scsi_target(sc->device));
@@ -247,35 +247,30 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 		return SUCCESS;
 	}
 	spin_unlock_bh(&session->frwd_lock);
-	/* Invalidate WRB Posted for this Task */
-	AMAP_SET_BITS(struct amap_iscsi_wrb, invld,
-		      aborted_io_task->pwrb_handle->pwrb,
-		      1);
 
 	conn = aborted_task->conn;
 	beiscsi_conn = conn->dd_data;
 	phba = beiscsi_conn->phba;
-
+	/* Invalidate WRB Posted for this Task */
+	AMAP_SET_BITS(struct amap_iscsi_wrb, invld,
+		      aborted_io_task->pwrb_handle->pwrb,
+		      1);
 	/* invalidate iocb */
 	cid = beiscsi_conn->beiscsi_conn_cid;
-	inv_tbl = phba->inv_tbl;
-	memset(inv_tbl, 0x0, sizeof(*inv_tbl));
-	inv_tbl->cid = cid;
-	inv_tbl->icd = aborted_io_task->psgl_handle->sgl_index;
-	num_invalidate = 1;
-	nonemb_cmd.va = pci_alloc_consistent(phba->ctrl.pdev,
-				sizeof(struct invalidate_commands_params_in),
-				&nonemb_cmd.dma);
+	inv_tbl.cid = cid;
+	inv_tbl.icd = aborted_io_task->psgl_handle->sgl_index;
+	nonemb_cmd.size = sizeof(union be_invldt_cmds_params);
+	nonemb_cmd.va = pci_zalloc_consistent(phba->ctrl.pdev,
+					      nonemb_cmd.size,
+					      &nonemb_cmd.dma);
 	if (nonemb_cmd.va == NULL) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_EH,
 			    "BM_%d : Failed to allocate memory for"
 			    "mgmt_invalidate_icds\n");
 		return FAILED;
 	}
-	nonemb_cmd.size = sizeof(struct invalidate_commands_params_in);
 
-	tag = mgmt_invalidate_icds(phba, inv_tbl, num_invalidate,
-				   cid, &nonemb_cmd);
+	tag = mgmt_invalidate_icds(phba, &inv_tbl, 1, cid, &nonemb_cmd);
 	if (!tag) {
 		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_EH,
 			    "BM_%d : mgmt_invalidate_icds could not be"
@@ -303,10 +298,10 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 	struct beiscsi_hba *phba;
 	struct iscsi_session *session;
 	struct iscsi_cls_session *cls_session;
-	struct invalidate_command_table *inv_tbl;
+	struct invldt_cmd_tbl *inv_tbl;
 	struct be_dma_mem nonemb_cmd;
-	unsigned int cid, tag, i, num_invalidate;
-	int rc;
+	unsigned int cid, tag, i, nents;
+	int rc, more = 0;
 
 	/* invalidate iocbs */
 	cls_session = starget_to_session(scsi_target(sc->device));
@@ -320,9 +315,15 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 	beiscsi_conn = conn->dd_data;
 	phba = beiscsi_conn->phba;
 	cid = beiscsi_conn->beiscsi_conn_cid;
-	inv_tbl = phba->inv_tbl;
-	memset(inv_tbl, 0x0, sizeof(*inv_tbl) * BE2_CMDS_PER_CXN);
-	num_invalidate = 0;
+
+	inv_tbl = kcalloc(BE_INVLDT_CMD_TBL_SZ, sizeof(*inv_tbl), GFP_KERNEL);
+	if (!inv_tbl) {
+		spin_unlock_bh(&session->frwd_lock);
+		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_EH,
+			    "BM_%d : invldt_cmd_tbl alloc failed\n");
+		return FAILED;
+	}
+	nents = 0;
 	for (i = 0; i < conn->session->cmds_max; i++) {
 		abrt_task = conn->session->cmds[i];
 		abrt_io_task = abrt_task->dd_data;
@@ -331,33 +332,47 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 
 		if (sc->device->lun != abrt_task->sc->device->lun)
 			continue;
+		/**
+		 * Can't fit in more cmds? Normally this won't happen b'coz
+		 * BEISCSI_CMD_PER_LUN is same as BE_INVLDT_CMD_TBL_SZ.
+		 */
+		if (nents == BE_INVLDT_CMD_TBL_SZ) {
+			more = 1;
+			break;
+		}
 
 		/* Invalidate WRB Posted for this Task */
 		AMAP_SET_BITS(struct amap_iscsi_wrb, invld,
 			      abrt_io_task->pwrb_handle->pwrb,
 			      1);
 
-		inv_tbl->cid = cid;
-		inv_tbl->icd = abrt_io_task->psgl_handle->sgl_index;
-		num_invalidate++;
-		inv_tbl++;
+		inv_tbl[nents].cid = cid;
+		inv_tbl[nents].icd = abrt_io_task->psgl_handle->sgl_index;
+		nents++;
 	}
 	spin_unlock_bh(&session->frwd_lock);
-	inv_tbl = phba->inv_tbl;
 
-	nonemb_cmd.va = pci_alloc_consistent(phba->ctrl.pdev,
-				sizeof(struct invalidate_commands_params_in),
-				&nonemb_cmd.dma);
+	if (more) {
+		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_EH,
+			    "BM_%d : number of cmds exceeds size of invalidation table\n");
+		kfree(inv_tbl);
+		return FAILED;
+	}
+
+	nonemb_cmd.size = sizeof(union be_invldt_cmds_params);
+	nonemb_cmd.va = pci_zalloc_consistent(phba->ctrl.pdev,
+					      nonemb_cmd.size,
+					      &nonemb_cmd.dma);
 	if (nonemb_cmd.va == NULL) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_EH,
 			    "BM_%d : Failed to allocate memory for"
 			    "mgmt_invalidate_icds\n");
+		kfree(inv_tbl);
 		return FAILED;
 	}
-	nonemb_cmd.size = sizeof(struct invalidate_commands_params_in);
-	memset(nonemb_cmd.va, 0, nonemb_cmd.size);
-	tag = mgmt_invalidate_icds(phba, inv_tbl, num_invalidate,
+	tag = mgmt_invalidate_icds(phba, inv_tbl, nents,
 				   cid, &nonemb_cmd);
+	kfree(inv_tbl);
 	if (!tag) {
 		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_EH,
 			    "BM_%d : mgmt_invalidate_icds could not be"
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 6376657..f869e37 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -57,7 +57,6 @@
 
 #define BE2_IO_DEPTH		1024
 #define BE2_MAX_SESSIONS	256
-#define BE2_CMDS_PER_CXN	128
 #define BE2_TMFS		16
 #define BE2_NOPOUT_REQ		16
 #define BE2_SGE			32
@@ -72,8 +71,13 @@
 
 #define BEISCSI_SGLIST_ELEMENTS	30
 
-#define BEISCSI_CMD_PER_LUN	128 /* scsi_host->cmd_per_lun */
-#define BEISCSI_MAX_SECTORS	1024 /* scsi_host->max_sectors */
+/**
+ * BE_INVLDT_CMD_TBL_SZ is 128 which is total number commands that can
+ * be invalidated at a time, consider it before changing the value of
+ * BEISCSI_CMD_PER_LUN.
+ */
+#define BEISCSI_CMD_PER_LUN	128	/* scsi_host->cmd_per_lun */
+#define BEISCSI_MAX_SECTORS	1024	/* scsi_host->max_sectors */
 #define BEISCSI_TEMPLATE_HDR_PER_CXN_SIZE 128 /* Template size per cxn */
 
 #define BEISCSI_MAX_CMD_LEN	16	/* scsi_host->max_cmd_len */
@@ -272,11 +276,6 @@ struct hba_parameters {
 	unsigned int num_sge;
 };
 
-struct invalidate_command_table {
-	unsigned short icd;
-	unsigned short cid;
-} __packed;
-
 #define BEISCSI_GET_ULP_FROM_CRI(phwi_ctrlr, cri) \
 	(phwi_ctrlr->wrb_context[cri].ulp_num)
 struct hwi_wrb_context {
@@ -430,7 +429,6 @@ struct beiscsi_hba {
 	struct be_ctrl_info ctrl;
 	unsigned int generation;
 	unsigned int interface_handle;
-	struct invalidate_command_table inv_tbl[128];
 
 	struct be_aic_obj aic_obj[MAX_CPUS];
 	unsigned int attr_log_enable;
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index ac05317..5f02e8d 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -129,7 +129,7 @@ unsigned int mgmt_vendor_specific_fw_cmd(struct be_ctrl_info *ctrl,
 }
 
 unsigned int  mgmt_invalidate_icds(struct beiscsi_hba *phba,
-				struct invalidate_command_table *inv_tbl,
+				struct invldt_cmd_tbl *inv_tbl,
 				unsigned int num_invalidate, unsigned int cid,
 				struct be_dma_mem *nonemb_cmd)
 
@@ -137,9 +137,12 @@ unsigned int  mgmt_invalidate_icds(struct beiscsi_hba *phba,
 	struct be_ctrl_info *ctrl = &phba->ctrl;
 	struct be_mcc_wrb *wrb;
 	struct be_sge *sge;
-	struct invalidate_commands_params_in *req;
+	struct invldt_cmds_params_in *req;
 	unsigned int i, tag;
 
+	if (num_invalidate > BE_INVLDT_CMD_TBL_SZ)
+		return 0;
+
 	mutex_lock(&ctrl->mbox_lock);
 	wrb = alloc_mcc_wrb(phba, &tag);
 	if (!wrb) {
@@ -158,10 +161,9 @@ unsigned int  mgmt_invalidate_icds(struct beiscsi_hba *phba,
 	req->ref_handle = 0;
 	req->cleanup_type = CMD_ISCSI_COMMAND_INVALIDATE;
 	for (i = 0; i < num_invalidate; i++) {
-		req->table[i].icd = inv_tbl->icd;
-		req->table[i].cid = inv_tbl->cid;
+		req->table[i].icd = inv_tbl[i].icd;
+		req->table[i].cid = inv_tbl[i].cid;
 		req->icd_count++;
-		inv_tbl++;
 	}
 	sge->pa_hi = cpu_to_le32(upper_32_bits(nonemb_cmd->dma));
 	sge->pa_lo = cpu_to_le32(nonemb_cmd->dma & 0xFFFFFFFF);
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index b897cfd..6e19281 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -104,10 +104,6 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 unsigned int mgmt_upload_connection(struct beiscsi_hba *phba,
 				     unsigned short cid,
 				     unsigned int upload_flag);
-unsigned int mgmt_invalidate_icds(struct beiscsi_hba *phba,
-				struct invalidate_command_table *inv_tbl,
-				unsigned int num_invalidate, unsigned int cid,
-				struct be_dma_mem *nonemb_cmd);
 unsigned int mgmt_vendor_specific_fw_cmd(struct be_ctrl_info *ctrl,
 					 struct beiscsi_hba *phba,
 					 struct bsg_job *job,
@@ -134,24 +130,31 @@ union iscsi_invalidate_connection_params {
 	struct iscsi_invalidate_connection_params_out response;
 } __packed;
 
-struct invalidate_commands_params_in {
+#define BE_INVLDT_CMD_TBL_SZ	128
+struct invldt_cmd_tbl {
+	unsigned short icd;
+	unsigned short cid;
+} __packed;
+
+struct invldt_cmds_params_in {
 	struct be_cmd_req_hdr hdr;
 	unsigned int ref_handle;
 	unsigned int icd_count;
-	struct invalidate_command_table table[128];
+	struct invldt_cmd_tbl table[BE_INVLDT_CMD_TBL_SZ];
 	unsigned short cleanup_type;
 	unsigned short unused;
 } __packed;
 
-struct invalidate_commands_params_out {
+struct invldt_cmds_params_out {
+	struct be_cmd_resp_hdr hdr;
 	unsigned int ref_handle;
 	unsigned int icd_count;
-	unsigned int icd_status[128];
+	unsigned int icd_status[BE_INVLDT_CMD_TBL_SZ];
 } __packed;
 
-union invalidate_commands_params {
-	struct invalidate_commands_params_in request;
-	struct invalidate_commands_params_out response;
+union be_invldt_cmds_params {
+	struct invldt_cmds_params_in request;
+	struct invldt_cmds_params_out response;
 } __packed;
 
 struct mgmt_hba_attributes {
@@ -231,16 +234,6 @@ struct be_bsg_vendor_cmd {
 
 #define GET_MGMT_CONTROLLER_WS(phba)    (phba->pmgmt_ws)
 
-/* MGMT CMD flags */
-
-#define MGMT_CMDH_FREE                (1<<0)
-
-/*  --- MGMT_ERROR_CODES --- */
-/*  Error Codes returned in the status field of the CMD response header */
-#define MGMT_STATUS_SUCCESS 0	/* The CMD completed without errors */
-#define MGMT_STATUS_FAILED 1	/* Error status in the Status field of */
-				/* the CMD_RESPONSE_HEADER  */
-
 #define ISCSI_GET_PDU_TEMPLATE_ADDRESS(pc, pa) {\
 	pa->lo = phba->init_mem[ISCSI_MEM_GLOBAL_HEADER].mem_array[0].\
 					bus_address.u.a32.address_lo;  \
@@ -265,6 +258,11 @@ struct beiscsi_endpoint {
 	u16 cid_vld;
 };
 
+unsigned int mgmt_invalidate_icds(struct beiscsi_hba *phba,
+				struct invldt_cmd_tbl *inv_tbl,
+				unsigned int num_invalidate, unsigned int cid,
+				struct be_dma_mem *nonemb_cmd);
+
 unsigned int mgmt_invalidate_connection(struct beiscsi_hba *phba,
 					 struct beiscsi_endpoint *beiscsi_ep,
 					 unsigned short cid,
-- 
2.7.4

