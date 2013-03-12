From: jayamohank@gmail.com
Subject: [PATCH 01/15] be2iscsi: Fix lack of uninitialize pattern to FW
Date: Mon, 11 Mar 2013 21:39:31 -0700
Message-ID: <1363063186-4902-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:65078 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab3CLEj6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Mar 2013 00:39:58 -0400
Received: by mail-pb0-f51.google.com with SMTP id un15so4560006pbc.38
        for <linux-scsi@vger.kernel.org>; Mon, 11 Mar 2013 21:39:58 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: "Jayamohan.Kallickal" <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

From: "Jayamohan.Kallickal" <jayamohan.kallickal@emulex.com>

 This patch sends uninitialize pattern to FW during driver unload
which is expected by FW for cleanup

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan.Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_cmds.c |   51 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/be2iscsi/be_cmds.h |    1 +
 drivers/scsi/be2iscsi/be_main.c |    1 +
 3 files changed, 53 insertions(+)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 5c87768..0b44cc9 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -732,6 +732,16 @@ int beiscsi_cmd_eq_create(struct be_ctrl_info *ctrl,
 	return status;
 }
 
+/**
+ * be_cmd_fw_initialize()- Initialize FW
+ * @ctrl: Pointer to function control structure
+ *
+ * Send FW initialize pattern for the function.
+ *
+ * return
+ * Success: 0
+ * Failure: Non-Zero value
+ **/
 int be_cmd_fw_initialize(struct be_ctrl_info *ctrl)
 {
 	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
@@ -762,6 +772,47 @@ int be_cmd_fw_initialize(struct be_ctrl_info *ctrl)
 	return status;
 }
 
+/**
+ * be_cmd_fw_uninit()- Uinitialize FW
+ * @ctrl: Pointer to function control structure
+ *
+ * Send FW uninitialize pattern for the function
+ *
+ * return
+ * Success: 0
+ * Failure: Non-Zero value
+ **/
+int be_cmd_fw_uninit(struct be_ctrl_info *ctrl)
+{
+	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	struct beiscsi_hba *phba = pci_get_drvdata(ctrl->pdev);
+	int status;
+	u8 *endian_check;
+
+	spin_lock(&ctrl->mbox_lock);
+	memset(wrb, 0, sizeof(*wrb));
+
+	endian_check = (u8 *) wrb;
+	*endian_check++ = 0xFF;
+	*endian_check++ = 0xAA;
+	*endian_check++ = 0xBB;
+	*endian_check++ = 0xFF;
+	*endian_check++ = 0xFF;
+	*endian_check++ = 0xCC;
+	*endian_check++ = 0xDD;
+	*endian_check = 0xFF;
+
+	be_dws_cpu_to_le(wrb, sizeof(*wrb));
+
+	status = be_mbox_notify(ctrl);
+	if (status)
+		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
+			    "BC_%d : be_cmd_fw_uninit Failed\n");
+
+	spin_unlock(&ctrl->mbox_lock);
+	return status;
+}
+
 int beiscsi_cmd_cq_create(struct be_ctrl_info *ctrl,
 			  struct be_queue_info *cq, struct be_queue_info *eq,
 			  bool sol_evts, bool no_delay, int coalesce_wm)
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 23397d5..0f8c920 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -697,6 +697,7 @@ int beiscsi_mccq_compl(struct beiscsi_hba *phba,
 			uint32_t tag, struct be_mcc_wrb **wrb, void *cmd_va);
 /*ISCSI Functuions */
 int be_cmd_fw_initialize(struct be_ctrl_info *ctrl);
+int be_cmd_fw_uninit(struct be_ctrl_info *ctrl);
 
 struct be_mcc_wrb *wrb_from_mbox(struct be_dma_mem *mbox_mem);
 struct be_mcc_wrb *wrb_from_mccq(struct beiscsi_hba *phba);
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 4e2733d..3fb997f 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3430,6 +3430,7 @@ static void hwi_cleanup(struct beiscsi_hba *phba)
 			beiscsi_cmd_q_destroy(ctrl, q, QTYPE_EQ);
 	}
 	be_mcc_queues_destroy(phba);
+	be_cmd_fw_uninit(ctrl);
 }
 
 static int be_mcc_queues_create(struct beiscsi_hba *phba,
-- 
1.7.10.4

