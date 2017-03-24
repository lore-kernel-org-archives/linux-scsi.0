From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v3 02/10] be2iscsi: Fix closing of connection
Date: Fri, 24 Mar 2017 14:11:41 +0530
Message-ID: <1490344909-29541-3-git-send-email-jitendra.bhivare@broadcom.com>
References: <1490344909-29541-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:34790 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753977AbdCXImc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Mar 2017 04:42:32 -0400
Received: by mail-qk0-f176.google.com with SMTP id p64so5689968qke.1
        for <linux-scsi@vger.kernel.org>; Fri, 24 Mar 2017 01:42:10 -0700 (PDT)
In-Reply-To: <1490344909-29541-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: thenzl@redhat.com, cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

CID needs to be freed even when invalidate or upload connection fails.
Attempt to close connection 3 times before freeing CID.

Set cleanup_type to INVALIDATE instead of force TCP_RST.
This unnecessarily is terminating connection with reset instead of
gracefully closing it.

Set save_cfg to 0 - session not to be saved on flash.

Add delay and process CQ before uploading connection.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be.h       |   1 -
 drivers/scsi/be2iscsi/be_cmds.h  |  63 +++++++++----------
 drivers/scsi/be2iscsi/be_iscsi.c |  98 +++++++++++++++++-------------
 drivers/scsi/be2iscsi/be_mgmt.c  | 127 ++++++++++++++++++++-------------------
 drivers/scsi/be2iscsi/be_mgmt.h  |  30 ++-------
 5 files changed, 159 insertions(+), 160 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be.h b/drivers/scsi/be2iscsi/be.h
index ca9440f..4dd8de4 100644
--- a/drivers/scsi/be2iscsi/be.h
+++ b/drivers/scsi/be2iscsi/be.h
@@ -154,7 +154,6 @@ struct be_ctrl_info {
 #define PAGE_SHIFT_4K 12
 #define PAGE_SIZE_4K (1 << PAGE_SHIFT_4K)
 #define mcc_timeout		120000 /* 12s timeout */
-#define BEISCSI_LOGOUT_SYNC_DELAY	250
 
 /* Returns number of pages spanned by the data starting at the given addr */
 #define PAGES_4K_SPANNED(_address, size)				\
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 1d40e83..88fe731 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -1145,24 +1145,49 @@ struct tcp_connect_and_offload_out {
 #define DB_DEF_PDU_EVENT_SHIFT		15
 #define DB_DEF_PDU_CQPROC_SHIFT		16
 
-struct dmsg_cqe {
-	u32 dw[4];
+struct be_invalidate_connection_params_in {
+	struct be_cmd_req_hdr hdr;
+	u32 session_handle;
+	u16 cid;
+	u16 unused;
+#define BE_CLEANUP_TYPE_INVALIDATE	0x8001
+#define BE_CLEANUP_TYPE_ISSUE_TCP_RST	0x8002
+	u16 cleanup_type;
+	u16 save_cfg;
+} __packed;
+
+struct be_invalidate_connection_params_out {
+	u32 session_handle;
+	u16 cid;
+	u16 unused;
 } __packed;
 
-struct tcp_upload_params_in {
+union be_invalidate_connection_params {
+	struct be_invalidate_connection_params_in req;
+	struct be_invalidate_connection_params_out resp;
+} __packed;
+
+struct be_tcp_upload_params_in {
 	struct be_cmd_req_hdr hdr;
 	u16 id;
+#define BE_UPLOAD_TYPE_GRACEFUL		1
+/* abortive upload with reset */
+#define BE_UPLOAD_TYPE_ABORT_RESET	2
+/* abortive upload without reset */
+#define BE_UPLOAD_TYPE_ABORT		3
+/* abortive upload with reset, sequence number by driver */
+#define BE_UPLOAD_TYPE_ABORT_WITH_SEQ	4
 	u16 upload_type;
 	u32 reset_seq;
 } __packed;
 
-struct tcp_upload_params_out {
+struct be_tcp_upload_params_out {
 	u32 dw[32];
 } __packed;
 
-union tcp_upload_params {
-	struct tcp_upload_params_in request;
-	struct tcp_upload_params_out response;
+union be_tcp_upload_params {
+	struct be_tcp_upload_params_in request;
+	struct be_tcp_upload_params_out response;
 } __packed;
 
 struct be_ulp_fw_cfg {
@@ -1243,10 +1268,7 @@ struct be_cmd_get_port_name {
 #define OPCODE_COMMON_WRITE_FLASH		96
 #define OPCODE_COMMON_READ_FLASH		97
 
-/* --- CMD_ISCSI_INVALIDATE_CONNECTION_TYPE --- */
 #define CMD_ISCSI_COMMAND_INVALIDATE		1
-#define CMD_ISCSI_CONNECTION_INVALIDATE		0x8001
-#define CMD_ISCSI_CONNECTION_ISSUE_TCP_RST	0x8002
 
 #define INI_WR_CMD			1	/* Initiator write command */
 #define INI_TMF_CMD			2	/* Initiator TMF command */
@@ -1269,27 +1291,6 @@ struct be_cmd_get_port_name {
 						 *  preparedby
 						 * driver should not be touched
 						 */
-/* --- CMD_CHUTE_TYPE --- */
-#define CMD_CONNECTION_CHUTE_0		1
-#define CMD_CONNECTION_CHUTE_1		2
-#define CMD_CONNECTION_CHUTE_2		3
-
-#define EQ_MAJOR_CODE_COMPLETION	0
-
-#define CMD_ISCSI_SESSION_DEL_CFG_FROM_FLASH 0
-#define CMD_ISCSI_SESSION_SAVE_CFG_ON_FLASH 1
-
-/* --- CONNECTION_UPLOAD_PARAMS --- */
-/* These parameters are used to define the type of upload desired.  */
-#define CONNECTION_UPLOAD_GRACEFUL      1	/* Graceful upload  */
-#define CONNECTION_UPLOAD_ABORT_RESET   2	/* Abortive upload with
-						 * reset
-						 */
-#define CONNECTION_UPLOAD_ABORT		3	/* Abortive upload without
-						 * reset
-						 */
-#define CONNECTION_UPLOAD_ABORT_WITH_SEQ 4	/* Abortive upload with reset,
-						 * sequence number by driver  */
 
 /* Returns the number of items in the field array. */
 #define BE_NUMBER_OF_FIELD(_type_, _field_)	\
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index a484457..bad6b5e 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -1263,31 +1263,58 @@ static void beiscsi_flush_cq(struct beiscsi_hba *phba)
 }
 
 /**
- * beiscsi_close_conn - Upload the  connection
+ * beiscsi_conn_close - Invalidate and upload connection
  * @ep: The iscsi endpoint
- * @flag: The type of connection closure
+ *
+ * Returns 0 on success,  -1 on failure.
  */
-static int beiscsi_close_conn(struct  beiscsi_endpoint *beiscsi_ep, int flag)
+static int beiscsi_conn_close(struct beiscsi_endpoint *beiscsi_ep)
 {
-	int ret = 0;
-	unsigned int tag;
 	struct beiscsi_hba *phba = beiscsi_ep->phba;
+	unsigned int tag, attempts;
+	int ret;
 
-	tag = mgmt_upload_connection(phba, beiscsi_ep->ep_cid, flag);
-	if (!tag) {
-		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-			    "BS_%d : upload failed for cid 0x%x\n",
-			    beiscsi_ep->ep_cid);
-
-		ret = -EAGAIN;
+	/**
+	 * Without successfully invalidating and uploading connection
+	 * driver can't reuse the CID so attempt more than once.
+	 */
+	attempts = 0;
+	while (attempts++ < 3) {
+		tag = beiscsi_invalidate_cxn(phba, beiscsi_ep);
+		if (tag) {
+			ret = beiscsi_mccq_compl_wait(phba, tag, NULL, NULL);
+			if (!ret)
+				break;
+			beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
+				    "BS_%d : invalidate conn failed cid %d\n",
+				    beiscsi_ep->ep_cid);
+		}
 	}
 
-	ret = beiscsi_mccq_compl_wait(phba, tag, NULL, NULL);
-
-	/* Flush the CQ entries */
+	/* wait for all completions to arrive, then process them */
+	msleep(250);
+	/* flush CQ entries */
 	beiscsi_flush_cq(phba);
 
-	return ret;
+	if (attempts > 3)
+		return -1;
+
+	attempts = 0;
+	while (attempts++ < 3) {
+		tag = beiscsi_upload_cxn(phba, beiscsi_ep);
+		if (tag) {
+			ret = beiscsi_mccq_compl_wait(phba, tag, NULL, NULL);
+			if (!ret)
+				break;
+			beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
+				    "BS_%d : upload conn failed cid %d\n",
+				    beiscsi_ep->ep_cid);
+		}
+	}
+	if (attempts > 3)
+		return -1;
+
+	return 0;
 }
 
 /**
@@ -1298,12 +1325,9 @@ static int beiscsi_close_conn(struct  beiscsi_endpoint *beiscsi_ep, int flag)
  */
 void beiscsi_ep_disconnect(struct iscsi_endpoint *ep)
 {
-	struct beiscsi_conn *beiscsi_conn;
 	struct beiscsi_endpoint *beiscsi_ep;
+	struct beiscsi_conn *beiscsi_conn;
 	struct beiscsi_hba *phba;
-	unsigned int tag;
-	uint8_t mgmt_invalidate_flag, tcp_upload_flag;
-	unsigned short savecfg_flag = CMD_ISCSI_SESSION_SAVE_CFG_ON_FLASH;
 	uint16_t cri_index;
 
 	beiscsi_ep = ep->dd_data;
@@ -1324,39 +1348,27 @@ void beiscsi_ep_disconnect(struct iscsi_endpoint *ep)
 	if (beiscsi_ep->conn) {
 		beiscsi_conn = beiscsi_ep->conn;
 		iscsi_suspend_queue(beiscsi_conn->conn);
-		mgmt_invalidate_flag = ~BEISCSI_NO_RST_ISSUE;
-		tcp_upload_flag = CONNECTION_UPLOAD_GRACEFUL;
-	} else {
-		mgmt_invalidate_flag = BEISCSI_NO_RST_ISSUE;
-		tcp_upload_flag = CONNECTION_UPLOAD_ABORT;
 	}
 
 	if (!beiscsi_hba_is_online(phba)) {
 		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
 			    "BS_%d : HBA in error 0x%lx\n", phba->state);
-		goto free_ep;
-	}
-
-	tag = mgmt_invalidate_connection(phba, beiscsi_ep,
-					  beiscsi_ep->ep_cid,
-					  mgmt_invalidate_flag,
-					  savecfg_flag);
-	if (!tag) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : mgmt_invalidate_connection Failed for cid=%d\n",
-			    beiscsi_ep->ep_cid);
+	} else {
+		/**
+		 * Make CID available even if close fails.
+		 * If not freed, FW might fail open using the CID.
+		 */
+		if (beiscsi_conn_close(beiscsi_ep) < 0)
+			__beiscsi_log(phba, KERN_ERR,
+				      "BS_%d : close conn failed cid %d\n",
+				      beiscsi_ep->ep_cid);
 	}
 
-	beiscsi_mccq_compl_wait(phba, tag, NULL, NULL);
-	beiscsi_close_conn(beiscsi_ep, tcp_upload_flag);
-free_ep:
-	msleep(BEISCSI_LOGOUT_SYNC_DELAY);
 	beiscsi_free_ep(beiscsi_ep);
 	if (!phba->conn_table[cri_index])
 		__beiscsi_log(phba, KERN_ERR,
-				"BS_%d : conn_table empty at %u: cid %u\n",
-				cri_index,
-				beiscsi_ep->ep_cid);
+			      "BS_%d : conn_table empty at %u: cid %u\n",
+			      cri_index, beiscsi_ep->ep_cid);
 	phba->conn_table[cri_index] = NULL;
 	iscsi_destroy_endpoint(beiscsi_ep->openiscsi_ep);
 }
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 2f6d5c2..3198c84 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -126,67 +126,6 @@ unsigned int mgmt_vendor_specific_fw_cmd(struct be_ctrl_info *ctrl,
 	return tag;
 }
 
-unsigned int mgmt_invalidate_connection(struct beiscsi_hba *phba,
-					 struct beiscsi_endpoint *beiscsi_ep,
-					 unsigned short cid,
-					 unsigned short issue_reset,
-					 unsigned short savecfg_flag)
-{
-	struct be_ctrl_info *ctrl = &phba->ctrl;
-	struct be_mcc_wrb *wrb;
-	struct iscsi_invalidate_connection_params_in *req;
-	unsigned int tag = 0;
-
-	mutex_lock(&ctrl->mbox_lock);
-	wrb = alloc_mcc_wrb(phba, &tag);
-	if (!wrb) {
-		mutex_unlock(&ctrl->mbox_lock);
-		return 0;
-	}
-
-	req = embedded_payload(wrb);
-	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
-	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI_INI,
-			   OPCODE_ISCSI_INI_DRIVER_INVALIDATE_CONNECTION,
-			   sizeof(*req));
-	req->session_handle = beiscsi_ep->fw_handle;
-	req->cid = cid;
-	if (issue_reset)
-		req->cleanup_type = CMD_ISCSI_CONNECTION_ISSUE_TCP_RST;
-	else
-		req->cleanup_type = CMD_ISCSI_CONNECTION_INVALIDATE;
-	req->save_cfg = savecfg_flag;
-	be_mcc_notify(phba, tag);
-	mutex_unlock(&ctrl->mbox_lock);
-	return tag;
-}
-
-unsigned int mgmt_upload_connection(struct beiscsi_hba *phba,
-				unsigned short cid, unsigned int upload_flag)
-{
-	struct be_ctrl_info *ctrl = &phba->ctrl;
-	struct be_mcc_wrb *wrb;
-	struct tcp_upload_params_in *req;
-	unsigned int tag;
-
-	mutex_lock(&ctrl->mbox_lock);
-	wrb = alloc_mcc_wrb(phba, &tag);
-	if (!wrb) {
-		mutex_unlock(&ctrl->mbox_lock);
-		return 0;
-	}
-
-	req = embedded_payload(wrb);
-	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
-	be_cmd_hdr_prepare(&req->hdr, CMD_COMMON_TCP_UPLOAD,
-			   OPCODE_COMMON_TCP_UPLOAD, sizeof(*req));
-	req->id = (unsigned short)cid;
-	req->upload_type = (unsigned char)upload_flag;
-	be_mcc_notify(phba, tag);
-	mutex_unlock(&ctrl->mbox_lock);
-	return tag;
-}
-
 /**
  * mgmt_open_connection()- Establish a TCP CXN
  * @dst_addr: Destination Address
@@ -1449,6 +1388,72 @@ void beiscsi_offload_cxn_v2(struct beiscsi_offload_params *params,
 		      exp_statsn) / 32] + 1));
 }
 
+unsigned int beiscsi_invalidate_cxn(struct beiscsi_hba *phba,
+				    struct beiscsi_endpoint *beiscsi_ep)
+{
+	struct be_invalidate_connection_params_in *req;
+	struct be_ctrl_info *ctrl = &phba->ctrl;
+	struct be_mcc_wrb *wrb;
+	unsigned int tag = 0;
+
+	mutex_lock(&ctrl->mbox_lock);
+	wrb = alloc_mcc_wrb(phba, &tag);
+	if (!wrb) {
+		mutex_unlock(&ctrl->mbox_lock);
+		return 0;
+	}
+
+	req = embedded_payload(wrb);
+	be_wrb_hdr_prepare(wrb, sizeof(union be_invalidate_connection_params),
+			   true, 0);
+	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI_INI,
+			   OPCODE_ISCSI_INI_DRIVER_INVALIDATE_CONNECTION,
+			   sizeof(*req));
+	req->session_handle = beiscsi_ep->fw_handle;
+	req->cid = beiscsi_ep->ep_cid;
+	if (beiscsi_ep->conn)
+		req->cleanup_type = BE_CLEANUP_TYPE_INVALIDATE;
+	else
+		req->cleanup_type = BE_CLEANUP_TYPE_ISSUE_TCP_RST;
+	/**
+	 * 0 - non-persistent targets
+	 * 1 - save session info on flash
+	 */
+	req->save_cfg = 0;
+	be_mcc_notify(phba, tag);
+	mutex_unlock(&ctrl->mbox_lock);
+	return tag;
+}
+
+unsigned int beiscsi_upload_cxn(struct beiscsi_hba *phba,
+				struct beiscsi_endpoint *beiscsi_ep)
+{
+	struct be_ctrl_info *ctrl = &phba->ctrl;
+	struct be_mcc_wrb *wrb;
+	struct be_tcp_upload_params_in *req;
+	unsigned int tag;
+
+	mutex_lock(&ctrl->mbox_lock);
+	wrb = alloc_mcc_wrb(phba, &tag);
+	if (!wrb) {
+		mutex_unlock(&ctrl->mbox_lock);
+		return 0;
+	}
+
+	req = embedded_payload(wrb);
+	be_wrb_hdr_prepare(wrb, sizeof(union be_tcp_upload_params), true, 0);
+	be_cmd_hdr_prepare(&req->hdr, CMD_COMMON_TCP_UPLOAD,
+			   OPCODE_COMMON_TCP_UPLOAD, sizeof(*req));
+	req->id = beiscsi_ep->ep_cid;
+	if (beiscsi_ep->conn)
+		req->upload_type = BE_UPLOAD_TYPE_GRACEFUL;
+	else
+		req->upload_type = BE_UPLOAD_TYPE_ABORT;
+	be_mcc_notify(phba, tag);
+	mutex_unlock(&ctrl->mbox_lock);
+	return tag;
+}
+
 int beiscsi_mgmt_invalidate_icds(struct beiscsi_hba *phba,
 				 struct invldt_cmd_tbl *inv_tbl,
 				 unsigned int nents)
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index 308f147..1ad6c40 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -41,35 +41,11 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 			 struct beiscsi_endpoint *beiscsi_ep,
 			 struct be_dma_mem *nonemb_cmd);
 
-unsigned int mgmt_upload_connection(struct beiscsi_hba *phba,
-				     unsigned short cid,
-				     unsigned int upload_flag);
 unsigned int mgmt_vendor_specific_fw_cmd(struct be_ctrl_info *ctrl,
 					 struct beiscsi_hba *phba,
 					 struct bsg_job *job,
 					 struct be_dma_mem *nonemb_cmd);
 
-#define BEISCSI_NO_RST_ISSUE	0
-struct iscsi_invalidate_connection_params_in {
-	struct be_cmd_req_hdr hdr;
-	unsigned int session_handle;
-	unsigned short cid;
-	unsigned short unused;
-	unsigned short cleanup_type;
-	unsigned short save_cfg;
-} __packed;
-
-struct iscsi_invalidate_connection_params_out {
-	unsigned int session_handle;
-	unsigned short cid;
-	unsigned short unused;
-} __packed;
-
-union iscsi_invalidate_connection_params {
-	struct iscsi_invalidate_connection_params_in request;
-	struct iscsi_invalidate_connection_params_out response;
-} __packed;
-
 #define BE_INVLDT_CMD_TBL_SZ	128
 struct invldt_cmd_tbl {
 	unsigned short icd;
@@ -265,6 +241,12 @@ void beiscsi_offload_cxn_v2(struct beiscsi_offload_params *params,
 			     struct wrb_handle *pwrb_handle,
 			     struct hwi_wrb_context *pwrb_context);
 
+unsigned int beiscsi_invalidate_cxn(struct beiscsi_hba *phba,
+				    struct beiscsi_endpoint *beiscsi_ep);
+
+unsigned int beiscsi_upload_cxn(struct beiscsi_hba *phba,
+				struct beiscsi_endpoint *beiscsi_ep);
+
 int be_cmd_modify_eq_delay(struct beiscsi_hba *phba,
 			 struct be_set_eqd *, int num);
 
-- 
2.7.4
