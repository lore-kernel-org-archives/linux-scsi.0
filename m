From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 24/39] megaraid_sas: Change max_cmd from u32 to u16 in all functions
Date: Mon,  6 Feb 2017 01:59:57 -0800
Message-ID: <1486375212-17329-25-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:32959 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751799AbdBFKCc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 05:02:32 -0500
Received: by mail-pg0-f49.google.com with SMTP id 204so27453605pge.0
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 02:02:32 -0800 (PST)
In-Reply-To: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Since maximum supported FW commands are all defined as u16, change
all local variables referring to max_cmd from u32 to u16.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   | 10 +++++-----
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  5 +++--
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index ac88ad6..e435c2b 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1546,7 +1546,7 @@ megasas_dump_pending_frames(struct megasas_instance *instance)
 	struct megasas_io_frame *ldio;
 	struct megasas_pthru_frame *pthru;
 	u32 sgcount;
-	u32 max_cmd = instance->max_fw_cmds;
+	u16 max_cmd = instance->max_fw_cmds;
 
 	dev_err(&instance->pdev->dev, "[%d]: Dumping Frame Phys Address of all pending cmds in FW\n",instance->host->host_no);
 	dev_err(&instance->pdev->dev, "[%d]: Total OS Pending cmds : %d\n",instance->host->host_no,atomic_read(&instance->fw_outstanding));
@@ -3464,7 +3464,7 @@ megasas_internal_reset_defer_cmds(struct megasas_instance *instance)
 {
 	struct megasas_cmd *cmd;
 	int i;
-	u32 max_cmd = instance->max_fw_cmds;
+	u16 max_cmd = instance->max_fw_cmds;
 	u32 defer_index;
 	unsigned long flags;
 
@@ -3840,7 +3840,7 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 static void megasas_teardown_frame_pool(struct megasas_instance *instance)
 {
 	int i;
-	u32 max_cmd = instance->max_mfi_cmds;
+	u16 max_cmd = instance->max_mfi_cmds;
 	struct megasas_cmd *cmd;
 
 	if (!instance->frame_dma_pool)
@@ -3884,7 +3884,7 @@ static void megasas_teardown_frame_pool(struct megasas_instance *instance)
 static int megasas_create_frame_pool(struct megasas_instance *instance)
 {
 	int i;
-	u32 max_cmd;
+	u16 max_cmd;
 	u32 sge_sz;
 	u32 total_sz;
 	u32 frame_count;
@@ -4018,7 +4018,7 @@ int megasas_alloc_cmds(struct megasas_instance *instance)
 {
 	int i;
 	int j;
-	u32 max_cmd;
+	u16 max_cmd;
 	struct megasas_cmd *cmd;
 	struct fusion_context *fusion;
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index cf3e2f8..22965b6 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -367,7 +367,7 @@ megasas_free_cmds_fusion(struct megasas_instance *instance)
 static int megasas_create_sg_sense_fusion(struct megasas_instance *instance)
 {
 	int i;
-	u32 max_cmd;
+	u16 max_cmd;
 	struct fusion_context *fusion;
 	struct megasas_cmd_fusion *cmd;
 
@@ -1271,7 +1271,8 @@ megasas_init_adapter_fusion(struct megasas_instance *instance)
 {
 	struct megasas_register_set __iomem *reg_set;
 	struct fusion_context *fusion;
-	u32 max_cmd, scratch_pad_2;
+	u16 max_cmd;
+	u32 scratch_pad_2;
 	int i = 0, count;
 
 	fusion = instance->ctrl_context;
-- 
2.8.3
