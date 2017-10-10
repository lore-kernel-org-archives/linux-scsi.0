From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 06/10] be2iscsi: Modify IOCTL to fetch user configured IQN
Date: Tue, 10 Oct 2017 16:18:16 +0530
Message-ID: <1507632500-26445-7-git-send-email-jitendra.bhivare@broadcom.com>
References: <1507632500-26445-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:53178 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755723AbdJJKsz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Oct 2017 06:48:55 -0400
Received: by mail-pf0-f178.google.com with SMTP id a1so13571687pfj.9
        for <linux-scsi@vger.kernel.org>; Tue, 10 Oct 2017 03:48:55 -0700 (PDT)
In-Reply-To: <1507632500-26445-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Add version 1 of GET_HBA_NAME to fetch port specific IQN first.
If it fails use version 0 to get the IQN.

To use this old IQN names of interfaces needs to be cleared from
the iscsiadm database.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c | 12 ++++++++----
 drivers/scsi/be2iscsi/be_mgmt.c  |  7 ++++++-
 drivers/scsi/be2iscsi/be_mgmt.h  |  2 +-
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 512c52a..aef9764 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -762,11 +762,15 @@ int beiscsi_get_host_param(struct Scsi_Host *shost,
 		}
 		break;
 	case ISCSI_HOST_PARAM_INITIATOR_NAME:
-		status = beiscsi_get_initiator_name(phba, buf);
+		/* try fetching user configured name first */
+		status = beiscsi_get_initiator_name(phba, buf, true);
 		if (status < 0) {
-			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-				    "BS_%d : Retreiving Initiator Name Failed\n");
-			return 0;
+			status = beiscsi_get_initiator_name(phba, buf, false);
+			if (status < 0) {
+				beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
+					    "BS_%d : Retreiving Initiator Name Failed\n");
+				status = 0;
+			}
 		}
 		break;
 	case ISCSI_HOST_PARAM_PORT_STATE:
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 0c25c10..713c7de 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -339,12 +339,14 @@ int beiscsi_modify_eq_delay(struct beiscsi_hba *phba,
  * beiscsi_get_initiator_name - read initiator name from flash
  * @phba: device priv structure
  * @name: buffer pointer
+ * @cfg: fetch user configured
  *
  */
-int beiscsi_get_initiator_name(struct beiscsi_hba *phba, char *name)
+int beiscsi_get_initiator_name(struct beiscsi_hba *phba, char *name, bool cfg)
 {
 	struct be_dma_mem nonemb_cmd;
 	struct be_cmd_hba_name resp;
+	struct be_cmd_hba_name *req;
 	int rc;
 
 	rc = beiscsi_prep_nemb_cmd(phba, &nonemb_cmd, CMD_SUBSYSTEM_ISCSI_INI,
@@ -352,6 +354,9 @@ int beiscsi_get_initiator_name(struct beiscsi_hba *phba, char *name)
 	if (rc)
 		return rc;
 
+	req = nonemb_cmd.va;
+	if (cfg)
+		req->hdr.version = 1;
 	rc = beiscsi_exec_nemb_cmd(phba, &nonemb_cmd, NULL,
 				   &resp, sizeof(resp));
 	if (rc) {
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index 665fd89..8d886f8 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -178,7 +178,7 @@ int beiscsi_mgmt_invalidate_icds(struct beiscsi_hba *phba,
 				 struct invldt_cmd_tbl *inv_tbl,
 				 unsigned int nents);
 
-int beiscsi_get_initiator_name(struct beiscsi_hba *phba, char *name);
+int beiscsi_get_initiator_name(struct beiscsi_hba *phba, char *name, bool cfg);
 
 int beiscsi_if_en_dhcp(struct beiscsi_hba *phba, u32 ip_type);
 
-- 
2.7.4
