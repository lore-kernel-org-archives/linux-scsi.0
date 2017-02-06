From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 27/39] megaraid_sas: megasas_return_cmd does not memset IO frame to zero
Date: Mon,  6 Feb 2017 02:00:00 -0800
Message-ID: <1486375212-17329-28-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:34201 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751805AbdBFKCk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 05:02:40 -0500
Received: by mail-pg0-f50.google.com with SMTP id 14so27438849pgg.1
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 02:02:40 -0800 (PST)
In-Reply-To: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Memset the IO frame to zero after release.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h      |  1 +
 drivers/scsi/megaraid/megaraid_sas_base.c | 10 ++++++----
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index ec5f003..59fe39d 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2238,6 +2238,7 @@ struct megasas_instance {
 	u8 is_rdpq;
 	bool dev_handle;
 	bool fw_sync_cache_support;
+	u32 mfi_frame_size;
 	bool is_ventura;
 	bool msix_combined;
 	u16 max_raid_mapsize;
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index e435c2b..2d72460 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -268,6 +268,8 @@ megasas_return_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
 	cmd->scmd = NULL;
 	cmd->frame_count = 0;
 	cmd->flags = 0;
+	memset(cmd->frame, 0, instance->mfi_frame_size);
+	cmd->frame->io.context = cpu_to_le32(cmd->index);
 	if (!fusion && reset_devices)
 		cmd->frame->hdr.cmd = MFI_CMD_INVALID;
 	list_add(&cmd->list, (&instance->cmd_pool)->next);
@@ -3886,7 +3888,6 @@ static int megasas_create_frame_pool(struct megasas_instance *instance)
 	int i;
 	u16 max_cmd;
 	u32 sge_sz;
-	u32 total_sz;
 	u32 frame_count;
 	struct megasas_cmd *cmd;
 
@@ -3914,12 +3915,13 @@ static int megasas_create_frame_pool(struct megasas_instance *instance)
 	 * Total 192 byte (3 MFI frame of 64 byte)
 	 */
 	frame_count = instance->ctrl_context ? (3 + 1) : (15 + 1);
-	total_sz = MEGAMFI_FRAME_SIZE * frame_count;
+	instance->mfi_frame_size = MEGAMFI_FRAME_SIZE * frame_count;
 	/*
 	 * Use DMA pool facility provided by PCI layer
 	 */
 	instance->frame_dma_pool = pci_pool_create("megasas frame pool",
-					instance->pdev, total_sz, 256, 0);
+					instance->pdev, instance->mfi_frame_size,
+					256, 0);
 
 	if (!instance->frame_dma_pool) {
 		dev_printk(KERN_DEBUG, &instance->pdev->dev, "failed to setup frame pool\n");
@@ -3963,7 +3965,7 @@ static int megasas_create_frame_pool(struct megasas_instance *instance)
 			return -ENOMEM;
 		}
 
-		memset(cmd->frame, 0, total_sz);
+		memset(cmd->frame, 0, instance->mfi_frame_size);
 		cmd->frame->io.context = cpu_to_le32(cmd->index);
 		cmd->frame->io.pad_0 = 0;
 		if (!instance->ctrl_context && reset_devices)
-- 
2.8.3
