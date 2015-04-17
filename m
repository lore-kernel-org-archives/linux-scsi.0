From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH 6/7] be2iscsi: Logout of FW Boot Session
Date: Fri, 17 Apr 2015 15:04:54 +0530
Message-ID: <81b67d78-0558-4d7e-bce7-16ccf9d7064f@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:54751 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbbDPRJB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2015 13:09:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: John Soni Jose <sony.john-n@emulex.com>, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 Once be2iscsi driver is loaded and operational close Boot
 session established by FW.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_cmds.h  |   12 ++++++
 drivers/scsi/be2iscsi/be_iscsi.c |   12 ++++++
 drivers/scsi/be2iscsi/be_main.c  |    1 +
 drivers/scsi/be2iscsi/be_main.h  |    2 +
 drivers/scsi/be2iscsi/be_mgmt.c  |   70 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/be2iscsi/be_mgmt.h  |    3 ++
 6 files changed, 100 insertions(+), 0 deletions(-)

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
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 508f017..566d27c 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -998,6 +998,18 @@ int beiscsi_conn_start(struct iscsi_cls_conn *cls_conn)
 	beiscsi_set_params_for_offld(beiscsi_conn, &params);
 	beiscsi_offload_connection(beiscsi_conn, &params);
 	iscsi_conn_start(cls_conn);
+
+	/* Logout from the FW boot session */
+	if (phba->fw_boot_state) {
+		int rc;
+
+		rc = beiscsi_logout_fw_sess(phba,
+			phba->boot_sess.session_handle);
+
+		if (!rc)
+			phba->fw_boot_state = 0;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index b700fad..dd0173b 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4400,6 +4400,7 @@ static int beiscsi_get_boot_info(struct beiscsi_hba *phba)
 
 	memcpy(&phba->boot_sess, &session_resp->session_info,
 	       sizeof(struct mgmt_session_info));
+	phba->fw_boot_state = BEISCSI_FW_BOOT_SESS_ACTIVE;
 	ret = 0;
 
 boot_freemem:
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 3ddde6f..8aff7cd 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -429,6 +429,8 @@ struct beiscsi_hba {
 	struct be_ctrl_info ctrl;
 	unsigned int generation;
 	unsigned int interface_handle;
+	unsigned char fw_boot_state;
+#define BEISCSI_FW_BOOT_SESS_ACTIVE	0x01
 	struct mgmt_session_info boot_sess;
 	struct invalidate_command_table inv_tbl[128];
 
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 78f56a6..1b37bbd 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1706,4 +1706,74 @@ void beiscsi_offload_cxn_v2(struct beiscsi_offload_params *params,
 		      pwrb,
 		     (params->dw[offsetof(struct amap_beiscsi_offload_params,
 		      exp_statsn) / 32] + 1));
+
+}
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
 }
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

