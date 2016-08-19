From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v2 23/29] be2iscsi: Add FUNCTION_RESET during driver unload
Date: Fri, 19 Aug 2016 15:20:20 +0530
Message-ID: <1471600226-22055-24-git-send-email-jitendra.bhivare@broadcom.com>
References: <1471600226-22055-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:35731 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752244AbcHSJwJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Aug 2016 05:52:09 -0400
Received: by mail-wm0-f47.google.com with SMTP id f65so27495484wmi.0
        for <linux-scsi@vger.kernel.org>; Fri, 19 Aug 2016 02:51:57 -0700 (PDT)
In-Reply-To: <1471600226-22055-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mchristi@redhat.com, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Driver unload should call COMMON_FUNCTION_RESET. For TPE feature, this
ensures that FW has knowledge about driver getting unloaded and can
reset its bit vector.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/be2iscsi/be_cmds.c | 2 +-
 drivers/scsi/be2iscsi/be_cmds.h | 2 ++
 drivers/scsi/be2iscsi/be_main.c | 3 +++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index ad7405d..5fe1610 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -1595,7 +1595,7 @@ int beiscsi_check_fw_rdy(struct beiscsi_hba *phba)
 	return rdy;
 }
 
-static int beiscsi_cmd_function_reset(struct beiscsi_hba  *phba)
+int beiscsi_cmd_function_reset(struct beiscsi_hba *phba)
 {
 	struct be_ctrl_info *ctrl = &phba->ctrl;
 	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 26d7921..8283344 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -762,6 +762,8 @@ struct be_cmd_set_features {
 	} param;
 } __packed;
 
+int beiscsi_cmd_function_reset(struct beiscsi_hba *phba);
+
 int beiscsi_cmd_special_wrb(struct be_ctrl_info *ctrl, u32 load);
 
 int beiscsi_check_fw_rdy(struct beiscsi_hba *phba);
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index cf82973..3aa2f04 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3771,9 +3771,12 @@ static void hwi_cleanup_port(struct beiscsi_hba *phba)
 			beiscsi_cmd_q_destroy(ctrl, q, QTYPE_EQ);
 		}
 	}
+	/* this ensures complete FW cleanup */
+	beiscsi_cmd_function_reset(phba);
 	/* last communication, indicate driver is unloading */
 	beiscsi_cmd_special_wrb(&phba->ctrl, 0);
 }
+
 static int hwi_init_port(struct beiscsi_hba *phba)
 {
 	struct hwi_controller *phwi_ctrlr;
-- 
1.9.1

