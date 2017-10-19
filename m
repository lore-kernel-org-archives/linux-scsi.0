From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 15/19] megaraid_sas: Incorrect processing of IOCTL frames for SMP/STP commands
Date: Thu, 19 Oct 2017 02:49:02 -0700
Message-ID: <1508406546-25944-16-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1508406546-25944-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:48165 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752621AbdJSJui (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Oct 2017 05:50:38 -0400
Received: by mail-pg0-f65.google.com with SMTP id v78so6761644pgb.5
        for <linux-scsi@vger.kernel.org>; Thu, 19 Oct 2017 02:50:38 -0700 (PDT)
In-Reply-To: <1508406546-25944-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Code fix - cmd->frame->dcmd.opcode will be valid only for MFI_CMD_DCMD
IOCTL frames. Currently driver check for cmd->frame->dcmd.opcode without
checking cmd type. Ensure we check dcmd opcode only for MFI_CMD_DCMD
commands. Separate handling of MFI_CMD_SMP/STP commands from
MFI_CMD_DCMD in completion path.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h      | 23 +++++++++++++----------
 drivers/scsi/megaraid/megaraid_sas_base.c | 22 ++++++++++++++++++----
 2 files changed, 31 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 83427b541629..85ef8415640c 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -187,16 +187,19 @@
 /*
  * MFI command opcodes
  */
-#define MFI_CMD_INIT				0x00
-#define MFI_CMD_LD_READ				0x01
-#define MFI_CMD_LD_WRITE			0x02
-#define MFI_CMD_LD_SCSI_IO			0x03
-#define MFI_CMD_PD_SCSI_IO			0x04
-#define MFI_CMD_DCMD				0x05
-#define MFI_CMD_ABORT				0x06
-#define MFI_CMD_SMP				0x07
-#define MFI_CMD_STP				0x08
-#define MFI_CMD_INVALID				0xff
+enum MFI_CMD_OP {
+	MFI_CMD_INIT		= 0x0,
+	MFI_CMD_LD_READ		= 0x1,
+	MFI_CMD_LD_WRITE	= 0x2,
+	MFI_CMD_LD_SCSI_IO	= 0x3,
+	MFI_CMD_PD_SCSI_IO	= 0x4,
+	MFI_CMD_DCMD		= 0x5,
+	MFI_CMD_ABORT		= 0x6,
+	MFI_CMD_SMP		= 0x7,
+	MFI_CMD_STP		= 0x8,
+	MFI_CMD_OP_COUNT,
+	MFI_CMD_INVALID		= 0xff
+};
 
 #define MR_DCMD_CTRL_GET_INFO			0x01010000
 #define MR_DCMD_LD_GET_LIST			0x03010000
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 3a179c3fabc0..995d70a06cb7 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3298,6 +3298,9 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 
 	case MFI_CMD_SMP:
 	case MFI_CMD_STP:
+		megasas_complete_int_cmd(instance, cmd);
+		break;
+
 	case MFI_CMD_DCMD:
 		opcode = le32_to_cpu(cmd->frame->dcmd.opcode);
 		/* Check for LD map update */
@@ -3384,6 +3387,7 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 	default:
 		dev_info(&instance->pdev->dev, "Unknown command completed! [0x%X]\n",
 		       hdr->cmd);
+		megasas_complete_int_cmd(instance, cmd);
 		break;
 	}
 }
@@ -7017,7 +7021,7 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 	void *sense = NULL;
 	dma_addr_t sense_handle;
 	unsigned long *sense_ptr;
-	u32 opcode;
+	u32 opcode = 0;
 
 	memset(kbuff_arr, 0, sizeof(kbuff_arr));
 
@@ -7027,6 +7031,13 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 		return -EINVAL;
 	}
 
+	if (ioc->frame.hdr.cmd >= MFI_CMD_OP_COUNT) {
+		dev_err(&instance->pdev->dev,
+			"Received invalid ioctl command 0x%x\n",
+			ioc->frame.hdr.cmd);
+		return -ENOTSUPP;
+	}
+
 	cmd = megasas_get_cmd(instance);
 	if (!cmd) {
 		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed to get a cmd packet\n");
@@ -7045,7 +7056,9 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 	cmd->frame->hdr.flags &= cpu_to_le16(~(MFI_FRAME_IEEE |
 					       MFI_FRAME_SGL64 |
 					       MFI_FRAME_SENSE64));
-	opcode = le32_to_cpu(cmd->frame->dcmd.opcode);
+
+	if (cmd->frame->hdr.cmd == MFI_CMD_DCMD)
+		opcode = le32_to_cpu(cmd->frame->dcmd.opcode);
 
 	if (opcode == MR_DCMD_CTRL_SHUTDOWN) {
 		if (megasas_get_ctrl_info(instance) != DCMD_SUCCESS) {
@@ -7127,8 +7140,9 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 	if (megasas_issue_blocked_cmd(instance, cmd, 0) == DCMD_NOT_FIRED) {
 		cmd->sync_cmd = 0;
 		dev_err(&instance->pdev->dev,
-			"return -EBUSY from %s %d opcode 0x%x cmd->cmd_status_drv 0x%x\n",
-			__func__, __LINE__, opcode,	cmd->cmd_status_drv);
+			"return -EBUSY from %s %d cmd 0x%x opcode 0x%x cmd->cmd_status_drv 0x%x\n",
+			__func__, __LINE__, cmd->frame->hdr.cmd, opcode,
+			cmd->cmd_status_drv);
 		return -EBUSY;
 	}
 
-- 
2.14.1.dirty
