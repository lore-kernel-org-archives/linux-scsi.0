From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v3 06/14] megaraid_sas: Fix endianness issues in DCMD handling
Date: Wed, 23 Aug 2017 04:47:00 -0700
Message-ID: <1503488828-2242-7-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1503488828-2242-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f46.google.com ([74.125.83.46]:33581 "EHLO
        mail-pg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753887AbdHWLrr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 07:47:47 -0400
Received: by mail-pg0-f46.google.com with SMTP id t3so6344782pgt.0
        for <linux-scsi@vger.kernel.org>; Wed, 23 Aug 2017 04:47:47 -0700 (PDT)
In-Reply-To: <1503488828-2242-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 2c309ec..b8b4654 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6866,6 +6866,7 @@ static int megasas_set_crash_dump_params_ioctl(struct megasas_cmd *cmd)
 	void *sense = NULL;
 	dma_addr_t sense_handle;
 	unsigned long *sense_ptr;
+	u32 opcode;
 
 	memset(kbuff_arr, 0, sizeof(kbuff_arr));
 
@@ -6893,15 +6894,16 @@ static int megasas_set_crash_dump_params_ioctl(struct megasas_cmd *cmd)
 	cmd->frame->hdr.flags &= cpu_to_le16(~(MFI_FRAME_IEEE |
 					       MFI_FRAME_SGL64 |
 					       MFI_FRAME_SENSE64));
+	opcode = le32_to_cpu(cmd->frame->dcmd.opcode);
 
-	if (cmd->frame->dcmd.opcode == MR_DCMD_CTRL_SHUTDOWN) {
+	if (opcode == MR_DCMD_CTRL_SHUTDOWN) {
 		if (megasas_get_ctrl_info(instance) != DCMD_SUCCESS) {
 			megasas_return_cmd(instance, cmd);
 			return -1;
 		}
 	}
 
-	if (cmd->frame->dcmd.opcode == MR_DRIVER_SET_APP_CRASHDUMP_MODE) {
+	if (opcode == MR_DRIVER_SET_APP_CRASHDUMP_MODE) {
 		error = megasas_set_crash_dump_params_ioctl(cmd);
 		megasas_return_cmd(instance, cmd);
 		return error;
@@ -6975,8 +6977,7 @@ static int megasas_set_crash_dump_params_ioctl(struct megasas_cmd *cmd)
 		cmd->sync_cmd = 0;
 		dev_err(&instance->pdev->dev,
 			"return -EBUSY from %s %d opcode 0x%x cmd->cmd_status_drv 0x%x\n",
-			__func__, __LINE__, cmd->frame->dcmd.opcode,
-			cmd->cmd_status_drv);
+			__func__, __LINE__, opcode,	cmd->cmd_status_drv);
 		return -EBUSY;
 	}
 
-- 
1.8.3.1
