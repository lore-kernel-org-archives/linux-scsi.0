From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH V2 6/7]  be2iscsi : Logout of FW Boot Session
Date: Sat, 25 Apr 2015 08:18:13 +0530
Message-ID: <3cfad7a3-8fa9-472e-9d62-916ef0931596@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.emulex.com ([138.239.224.99]:6800 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbbDXKWP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2015 06:22:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: John Soni Jose <sony.john-n@emulex.com>, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 Once be2iscsi driver is loaded and operational close Boot
 session established by FW.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_cmds.h |   12 +++++++
 drivers/scsi/be2iscsi/be_main.c |    3 ++
 drivers/scsi/be2iscsi/be_mgmt.c |   69 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/be2iscsi/be_mgmt.h |    3 ++
 4 files changed, 87 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index d0097a2..0586815 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -304,6 +304,17 @@ struct mgmt_auth_method_format {
 	struct	mgmt_chap_format chap;
 } __packed;
 
+struct be_cmd_req_logout_fw_sess {
+	struct be_cmd_req_hdr hdr;	/* dw[4] */
+	uint32_t session_handle;
+} __packed;
+
+struct be_cmd_resp_logout_fw_sess {
+	struct be_cmd_resp_hdr hdr;	/* dw[4] */
+#define BEISCSI_MGMT_SESSION_CLOSE 0x20
+	uint32_t session_status;
+} __packed;
+
 struct mgmt_conn_login_options {
 	u8 flags;
 	u8 header_digest;
@@ -1136,6 +1147,7 @@ struct be_cmd_get_all_if_id_req {
 #define OPCODE_ISCSI_INI_CFG_GET_HBA_NAME	6
 #define OPCODE_ISCSI_INI_CFG_SET_HBA_NAME	7
 #define OPCODE_ISCSI_INI_SESSION_GET_A_SESSION  14
+#define OPCODE_ISCSI_INI_SESSION_LOGOUT_TARGET	 24
 #define OPCODE_ISCSI_INI_DRIVER_REOPEN_ALL_SESSIONS 36
 #define OPCODE_ISCSI_INI_DRIVER_OFFLOAD_SESSION 41
 #define OPCODE_ISCSI_INI_DRIVER_INVALIDATE_CONNECTION 42
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index b700fad..6fe8c9d 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4400,6 +4400,9 @@ static int beiscsi_get_boot_info(struct beiscsi_hba *phba)
 
 	memcpy(&phba->boot_sess, &session_resp->session_info,
 	       sizeof(struct mgmt_session_info));
+
+	 beiscsi_logout_fw_sess(phba,
+				phba->boot_sess.session_handle);
 	ret = 0;
 
 boot_freemem:
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 78f56a6..51cd1f0 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1707,3 +1707,72 @@ void beiscsi_offload_cxn_v2(struct beiscsi_offload_params *params,
 		     (params->dw[offsetof(struct amap_beiscsi_offload_params,
 		      exp_statsn) / 32] + 1));
 }
+
+/**
+ * beiscsi_logout_fw_sess()- Firmware Session Logout
+ * @phba: Device priv structure instance
+ * @fw_sess_handle: FW session handle
+ *
+ * Logout from the FW established sessions.
+ * returns
+ *  Success: 0
+ *  Failure: Non-Zero Value
+ *
+ */
+int beiscsi_logout_fw_sess(struct beiscsi_hba *phba,
+		uint32_t fw_sess_handle)
+{
+	struct be_ctrl_info *ctrl = &phba->ctrl;
+	struct be_mcc_wrb *wrb;
+	struct be_cmd_req_logout_fw_sess *req;
+	struct be_cmd_resp_logout_fw_sess *resp;
+	unsigned int tag;
+	int rc;
+
+	beiscsi_log(phba, KERN_INFO,
+		    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
+		    "BG_%d : In bescsi_logout_fwboot_sess\n");
+
+	spin_lock(&ctrl->mbox_lock);
+	tag = alloc_mcc_tag(phba);
+	if (!tag) {
+		spin_unlock(&ctrl->mbox_lock);
+		beiscsi_log(phba, KERN_INFO,
+			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
+			    "BG_%d : MBX Tag Failure\n");
+		return -EINVAL;
+	}
+
+	wrb = wrb_from_mccq(phba);
+	req = embedded_payload(wrb);
+	wrb->tag0 |= tag;
+	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
+	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI_INI,
+			   OPCODE_ISCSI_INI_SESSION_LOGOUT_TARGET,
+			   sizeof(struct be_cmd_req_logout_fw_sess));
+
+	/* Set the session handle */
+	req->session_handle = fw_sess_handle;
+	be_mcc_notify(phba);
+	spin_unlock(&ctrl->mbox_lock);
+
+	rc = beiscsi_mccq_compl(phba, tag, &wrb, NULL);
+	if (rc) {
+		beiscsi_log(phba, KERN_ERR,
+			    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
+			    "BG_%d : MBX CMD FW_SESSION_LOGOUT_TARGET Failed\n");
+		return -EBUSY;
+	}
+
+	resp = embedded_payload(wrb);
+	if (resp->session_status !=
+		BEISCSI_MGMT_SESSION_CLOSE) {
+		beiscsi_log(phba, KERN_ERR,
+			    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
+			    "BG_%d : FW_SESSION_LOGOUT_TARGET resp : 0x%x\n",
+			    resp->session_status);
+		rc = -EINVAL;
+	}
+
+	return rc;
+}
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index 95fd99b..c6a042e 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -338,4 +338,7 @@ void beiscsi_ue_detect(struct beiscsi_hba *phba);
 int be_cmd_modify_eq_delay(struct beiscsi_hba *phba,
 			 struct be_set_eqd *, int num);
 
+int beiscsi_logout_fw_sess(struct beiscsi_hba *phba,
+			    uint32_t fw_sess_handle);
+
 #endif
-- 
1.7.1

