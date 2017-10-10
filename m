From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 07/10] be2iscsi: Add cmd to set host data
Date: Tue, 10 Oct 2017 16:18:17 +0530
Message-ID: <1507632500-26445-8-git-send-email-jitendra.bhivare@broadcom.com>
References: <1507632500-26445-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:47644 "EHLO
        mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751398AbdJJKs5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Oct 2017 06:48:57 -0400
Received: by mail-pf0-f169.google.com with SMTP id z11so6868781pfk.4
        for <linux-scsi@vger.kernel.org>; Tue, 10 Oct 2017 03:48:57 -0700 (PDT)
In-Reply-To: <1507632500-26445-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Provide driver version in host data to FW.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_cmds.c | 46 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/be2iscsi/be_cmds.h | 26 +++++++++++++++++++++++
 drivers/scsi/be2iscsi/be_main.c |  2 ++
 3 files changed, 74 insertions(+)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 6af448d..0499666 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -1522,6 +1522,52 @@ int beiscsi_get_port_name(struct be_ctrl_info *ctrl, struct beiscsi_hba *phba)
 	return ret;
 }
 
+int beiscsi_set_host_data(struct beiscsi_hba *phba)
+{
+	struct be_ctrl_info *ctrl = &phba->ctrl;
+	struct be_cmd_set_host_data *ioctl;
+	struct be_mcc_wrb *wrb;
+	int ret = 0;
+
+	if (is_chip_be2_be3r(phba))
+		return ret;
+
+	mutex_lock(&ctrl->mbox_lock);
+	wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	memset(wrb, 0, sizeof(*wrb));
+	ioctl = embedded_payload(wrb);
+
+	be_wrb_hdr_prepare(wrb, sizeof(*ioctl), true, 0);
+	be_cmd_hdr_prepare(&ioctl->h.req_hdr, CMD_SUBSYSTEM_COMMON,
+			   OPCODE_COMMON_SET_HOST_DATA,
+			   EMBED_MBX_MAX_PAYLOAD_SIZE);
+	ioctl->param.req.param_id = BE_CMD_SET_HOST_PARAM_ID;
+	ioctl->param.req.param_len =
+		snprintf((char *)ioctl->param.req.param_data,
+			 sizeof(ioctl->param.req.param_data),
+			 "Linux iSCSI v%s", BUILD_STR);
+	ioctl->param.req.param_len = ALIGN(ioctl->param.req.param_len, 4);
+	if (ioctl->param.req.param_len > BE_CMD_MAX_DRV_VERSION)
+		ioctl->param.req.param_len = BE_CMD_MAX_DRV_VERSION;
+	ret = be_mbox_notify(ctrl);
+	if (!ret) {
+		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
+			    "BG_%d : HBA set host driver version\n");
+	} else {
+		/**
+		 * Check "MCC_STATUS_INVALID_LENGTH" for SKH.
+		 * Older FW versions return this error.
+		 */
+		if (ret == MCC_STATUS_ILLEGAL_REQUEST ||
+				ret == MCC_STATUS_INVALID_LENGTH)
+			__beiscsi_log(phba, KERN_INFO,
+				      "BG_%d : HBA failed to set host driver version\n");
+	}
+
+	mutex_unlock(&ctrl->mbox_lock);
+	return ret;
+}
+
 int beiscsi_set_uer_feature(struct beiscsi_hba *phba)
 {
 	struct be_ctrl_info *ctrl = &phba->ctrl;
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 4f1ac97..5d5e8fb 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -230,6 +230,7 @@ struct be_mcc_mailbox {
 #define OPCODE_COMMON_QUERY_FIRMWARE_CONFIG		58
 #define OPCODE_COMMON_FUNCTION_RESET			61
 #define OPCODE_COMMON_GET_PORT_NAME			77
+#define OPCODE_COMMON_SET_HOST_DATA			93
 #define OPCODE_COMMON_SET_FEATURES			191
 
 /**
@@ -737,6 +738,30 @@ struct be_cmd_hba_name {
 	u8 initiator_alias[BE_INI_ALIAS_LEN];
 } __packed;
 
+/******************** COMMON SET HOST DATA *******************/
+#define BE_CMD_SET_HOST_PARAM_ID	0x2
+#define BE_CMD_MAX_DRV_VERSION		0x30
+struct be_sethost_req {
+	u32 param_id;
+	u32 param_len;
+	u32 param_data[32];
+};
+
+struct be_sethost_resp {
+	u32 rsvd0;
+};
+
+struct be_cmd_set_host_data {
+	union {
+		struct be_cmd_req_hdr req_hdr;
+		struct be_cmd_resp_hdr resp_hdr;
+	} h;
+	union {
+		struct be_sethost_req req;
+		struct be_sethost_resp resp;
+	} param;
+} __packed;
+
 /******************** COMMON SET Features *******************/
 #define BE_CMD_SET_FEATURE_UER	0x10
 #define BE_CMD_UER_SUPP_BIT	0x1
@@ -845,6 +870,7 @@ int beiscsi_get_fw_config(struct be_ctrl_info *ctrl, struct beiscsi_hba *phba);
 int beiscsi_get_port_name(struct be_ctrl_info *ctrl, struct beiscsi_hba *phba);
 
 int beiscsi_set_uer_feature(struct beiscsi_hba *phba);
+int beiscsi_set_host_data(struct beiscsi_hba *phba);
 
 struct be_default_pdu_context {
 	u32 dw[4];
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 8f7e394..02144c5 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5325,6 +5325,7 @@ static int beiscsi_enable_port(struct beiscsi_hba *phba)
 	be2iscsi_enable_msix(phba);
 
 	beiscsi_get_params(phba);
+	beiscsi_set_host_data(phba);
 	/* Re-enable UER. If different TPE occurs then it is recoverable. */
 	beiscsi_set_uer_feature(phba);
 
@@ -5623,6 +5624,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	}
 	beiscsi_get_port_name(&phba->ctrl, phba);
 	beiscsi_get_params(phba);
+	beiscsi_set_host_data(phba);
 	beiscsi_set_uer_feature(phba);
 
 	be2iscsi_enable_msix(phba);
-- 
2.7.4
