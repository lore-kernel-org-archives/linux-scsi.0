From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 05/10] be2iscsi: Fix _get_initname buffer overflow
Date: Tue, 10 Oct 2017 16:18:15 +0530
Message-ID: <1507632500-26445-6-git-send-email-jitendra.bhivare@broadcom.com>
References: <1507632500-26445-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:52065 "EHLO
        mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755688AbdJJKsw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Oct 2017 06:48:52 -0400
Received: by mail-pf0-f169.google.com with SMTP id n14so14904908pfh.8
        for <linux-scsi@vger.kernel.org>; Tue, 10 Oct 2017 03:48:52 -0700 (PDT)
In-Reply-To: <1507632500-26445-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

be_cmd_get_initname pulls GET_HBA_NAME response of 276 bytes in embedded
WRB buffer of 236 bytes.

Use non-embedded functions to issue the IOCTL.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_cmds.h  |  2 --
 drivers/scsi/be2iscsi/be_iscsi.c | 44 +++----------------------------
 drivers/scsi/be2iscsi/be_mgmt.c  | 57 ++++++++++++++++++++--------------------
 drivers/scsi/be2iscsi/be_mgmt.h  |  2 ++
 4 files changed, 35 insertions(+), 70 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 22ddfe9..4f1ac97 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -793,8 +793,6 @@ int beiscsi_cmd_mccq_create(struct beiscsi_hba *phba,
 			struct be_queue_info *mccq,
 			struct be_queue_info *cq);
 
-unsigned int be_cmd_get_initname(struct beiscsi_hba *phba);
-
 void free_mcc_wrb(struct be_ctrl_info *ctrl, unsigned int tag);
 
 int beiscsi_modify_eq_delay(struct beiscsi_hba *phba, struct be_set_eqd *,
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 43a80ce..512c52a 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -684,41 +684,6 @@ int beiscsi_set_param(struct iscsi_cls_conn *cls_conn,
 }
 
 /**
- * beiscsi_get_initname - Read Initiator Name from flash
- * @buf: buffer bointer
- * @phba: The device priv structure instance
- *
- * returns number of bytes
- */
-static int beiscsi_get_initname(char *buf, struct beiscsi_hba *phba)
-{
-	int rc;
-	unsigned int tag;
-	struct be_mcc_wrb *wrb;
-	struct be_cmd_hba_name *resp;
-
-	tag = be_cmd_get_initname(phba);
-	if (!tag) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : Getting Initiator Name Failed\n");
-
-		return -EBUSY;
-	}
-
-	rc = beiscsi_mccq_compl_wait(phba, tag, &wrb, NULL);
-	if (rc) {
-		beiscsi_log(phba, KERN_ERR,
-			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-			    "BS_%d : Initiator Name MBX Failed\n");
-		return rc;
-	}
-
-	resp = embedded_payload(wrb);
-	rc = sprintf(buf, "%s\n", resp->initiator_name);
-	return rc;
-}
-
-/**
  * beiscsi_get_port_state - Get the Port State
  * @shost : pointer to scsi_host structure
  *
@@ -772,7 +737,6 @@ static void beiscsi_get_port_speed(struct Scsi_Host *shost)
  * @param: parameter type identifier
  * @buf: buffer pointer
  *
- * returns host parameter
  */
 int beiscsi_get_host_param(struct Scsi_Host *shost,
 			   enum iscsi_host_param param, char *buf)
@@ -783,7 +747,7 @@ int beiscsi_get_host_param(struct Scsi_Host *shost,
 	if (!beiscsi_hba_is_online(phba)) {
 		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
 			    "BS_%d : HBA in error 0x%lx\n", phba->state);
-		return -EBUSY;
+		return 0;
 	}
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
 		    "BS_%d : In beiscsi_get_host_param, param = %d\n", param);
@@ -794,15 +758,15 @@ int beiscsi_get_host_param(struct Scsi_Host *shost,
 		if (status < 0) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
 				    "BS_%d : beiscsi_get_macaddr Failed\n");
-			return status;
+			return 0;
 		}
 		break;
 	case ISCSI_HOST_PARAM_INITIATOR_NAME:
-		status = beiscsi_get_initname(buf, phba);
+		status = beiscsi_get_initiator_name(phba, buf);
 		if (status < 0) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
 				    "BS_%d : Retreiving Initiator Name Failed\n");
-			return status;
+			return 0;
 		}
 		break;
 	case ISCSI_HOST_PARAM_PORT_STATE:
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 2117ac0..0c25c10 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -335,6 +335,35 @@ int beiscsi_modify_eq_delay(struct beiscsi_hba *phba,
 				     __beiscsi_eq_delay_compl, NULL, 0);
 }
 
+/**
+ * beiscsi_get_initiator_name - read initiator name from flash
+ * @phba: device priv structure
+ * @name: buffer pointer
+ *
+ */
+int beiscsi_get_initiator_name(struct beiscsi_hba *phba, char *name)
+{
+	struct be_dma_mem nonemb_cmd;
+	struct be_cmd_hba_name resp;
+	int rc;
+
+	rc = beiscsi_prep_nemb_cmd(phba, &nonemb_cmd, CMD_SUBSYSTEM_ISCSI_INI,
+			OPCODE_ISCSI_INI_CFG_GET_HBA_NAME, sizeof(resp));
+	if (rc)
+		return rc;
+
+	rc = beiscsi_exec_nemb_cmd(phba, &nonemb_cmd, NULL,
+				   &resp, sizeof(resp));
+	if (rc) {
+		beiscsi_log(phba, KERN_ERR,
+			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
+			    "BS_%d : Initiator Name MBX Failed\n");
+		return rc;
+	}
+	rc = sprintf(name, "%s\n", resp.initiator_name);
+	return rc;
+}
+
 unsigned int beiscsi_if_get_handle(struct beiscsi_hba *phba)
 {
 	struct be_ctrl_info *ctrl = &phba->ctrl;
@@ -763,34 +792,6 @@ int mgmt_get_nic_conf(struct beiscsi_hba *phba,
 				     nic, sizeof(*nic));
 }
 
-
-
-unsigned int be_cmd_get_initname(struct beiscsi_hba *phba)
-{
-	unsigned int tag;
-	struct be_mcc_wrb *wrb;
-	struct be_cmd_hba_name *req;
-	struct be_ctrl_info *ctrl = &phba->ctrl;
-
-	if (mutex_lock_interruptible(&ctrl->mbox_lock))
-		return 0;
-	wrb = alloc_mcc_wrb(phba, &tag);
-	if (!wrb) {
-		mutex_unlock(&ctrl->mbox_lock);
-		return 0;
-	}
-
-	req = embedded_payload(wrb);
-	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
-	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI_INI,
-			OPCODE_ISCSI_INI_CFG_GET_HBA_NAME,
-			sizeof(*req));
-
-	be_mcc_notify(phba, tag);
-	mutex_unlock(&ctrl->mbox_lock);
-	return tag;
-}
-
 static void beiscsi_boot_process_compl(struct beiscsi_hba *phba,
 				       unsigned int tag)
 {
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index 06ddc5a..665fd89 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -178,6 +178,8 @@ int beiscsi_mgmt_invalidate_icds(struct beiscsi_hba *phba,
 				 struct invldt_cmd_tbl *inv_tbl,
 				 unsigned int nents);
 
+int beiscsi_get_initiator_name(struct beiscsi_hba *phba, char *name);
+
 int beiscsi_if_en_dhcp(struct beiscsi_hba *phba, u32 ip_type);
 
 int beiscsi_if_en_static(struct beiscsi_hba *phba, u32 ip_type,
-- 
2.7.4
