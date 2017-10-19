From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 14/19] megaraid_sas: Resize MFA frame used for IOC INIT to 4k
Date: Thu, 19 Oct 2017 02:49:01 -0700
Message-ID: <1508406546-25944-15-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1508406546-25944-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:47738 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752650AbdJSJuf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Oct 2017 05:50:35 -0400
Received: by mail-pg0-f66.google.com with SMTP id r25so6765730pgn.4
        for <linux-scsi@vger.kernel.org>; Thu, 19 Oct 2017 02:50:35 -0700 (PDT)
In-Reply-To: <1508406546-25944-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, stable@vger.kernel.org

Older firmware version unconditionally pulls 4k frame for
IOC INIT MFA frame.
But driver allocates 1k or 4k max_chain_frame_sz based on FW capability.
During boot time, this results in DMA read errors.
Workaround fix in driver by allocating separate ioc_init frame of 4k size
to support older firmware.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: stable@vger.kernel.org
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 65 +++++++++++++++++++++++++----
 drivers/scsi/megaraid/megaraid_sas_fusion.h |  2 +
 2 files changed, 58 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 277fd16305ee..857bdbb0f79d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -780,13 +780,7 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 	ioc_init_handle = fusion->ioc_init_request_phys;
 	IOCInitMessage = fusion->ioc_init_request;
 
-	cmd = megasas_get_cmd(instance);
-
-	if (!cmd) {
-		dev_err(&instance->pdev->dev, "Could not allocate cmd for INIT Frame\n");
-		ret = 1;
-		goto fail_get_cmd;
-	}
+	cmd = fusion->ioc_init_cmd;
 
 	scratch_pad_2 = readl
 		(&instance->reg_set->outbound_scratch_pad_2);
@@ -918,8 +912,6 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 	ret = 0;
 
 fail_fw_init:
-	megasas_return_cmd(instance, cmd);
-fail_get_cmd:
 	dev_err(&instance->pdev->dev,
 		"Init cmd return status %s for SCSI host %d\n",
 		ret ? "FAILED" : "SUCCESS", instance->host->host_no);
@@ -1333,6 +1325,56 @@ static inline int megasas_allocate_raid_maps(struct megasas_instance *instance)
 	return -ENOMEM;
 }
 
+static int megasas_alloc_ioc_init_frame(struct megasas_instance *instance)
+{
+	struct fusion_context *fusion;
+	struct megasas_cmd *cmd;
+
+	fusion = instance->ctrl_context;
+
+	cmd = kmalloc(sizeof(struct megasas_cmd), GFP_KERNEL);
+
+	if (!cmd) {
+		dev_err(&instance->pdev->dev, "Failed from func: %s line: %d\n",
+			__func__, __LINE__);
+		return -ENOMEM;
+	}
+
+	cmd->frame = dma_alloc_coherent(&instance->pdev->dev,
+					IOC_INIT_FRAME_SIZE,
+					&cmd->frame_phys_addr, GFP_KERNEL);
+
+	if (!cmd->frame) {
+		dev_err(&instance->pdev->dev, "Failed from func: %s line: %d\n",
+			__func__, __LINE__);
+		kfree(cmd);
+		return -ENOMEM;
+	}
+
+	fusion->ioc_init_cmd = cmd;
+	return 0;
+}
+
+/**
+ * megasas_free_ioc_init_cmd -	Free IOC INIT command frame
+ * @instance:		Adapter soft state
+ */
+static inline void megasas_free_ioc_init_cmd(struct megasas_instance *instance)
+{
+	struct fusion_context *fusion;
+
+	fusion = instance->ctrl_context;
+
+	if (fusion->ioc_init_cmd && fusion->ioc_init_cmd->frame)
+		dma_free_coherent(&instance->pdev->dev,
+				  IOC_INIT_FRAME_SIZE,
+				  fusion->ioc_init_cmd->frame,
+				  fusion->ioc_init_cmd->frame_phys_addr);
+
+	if (fusion->ioc_init_cmd)
+		kfree(fusion->ioc_init_cmd);
+}
+
 /**
  * megasas_init_adapter_fusion -	Initializes the FW
  * @instance:		Adapter soft state
@@ -1428,6 +1470,9 @@ megasas_init_adapter_fusion(struct megasas_instance *instance)
 				MEGASAS_FUSION_IOCTL_CMDS);
 	sema_init(&instance->ioctl_sem, MEGASAS_FUSION_IOCTL_CMDS);
 
+	if (megasas_alloc_ioc_init_frame(instance))
+		return 1;
+
 	/*
 	 * Allocate memory for descriptors
 	 * Create a pool of commands
@@ -1465,6 +1510,7 @@ megasas_init_adapter_fusion(struct megasas_instance *instance)
 fail_alloc_cmds:
 	megasas_free_cmds(instance);
 fail_alloc_mfi_cmds:
+	megasas_free_ioc_init_cmd(instance);
 	return 1;
 }
 
@@ -3383,6 +3429,7 @@ megasas_issue_dcmd_fusion(struct megasas_instance *instance,
 void
 megasas_release_fusion(struct megasas_instance *instance)
 {
+	megasas_free_ioc_init_cmd(instance);
 	megasas_free_cmds(instance);
 	megasas_free_cmds_fusion(instance);
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index 5b3f1dba1ab2..549f86b2e871 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -103,6 +103,7 @@ enum MR_RAID_FLAGS_IO_SUB_TYPE {
 #define THRESHOLD_REPLY_COUNT 50
 #define RAID_1_PEER_CMDS 2
 #define JBOD_MAPS_COUNT	2
+#define IOC_INIT_FRAME_SIZE 4096
 
 /*
  * Raid Context structure which describes MegaRAID specific IO Parameters
@@ -1317,6 +1318,7 @@ struct fusion_context {
 	struct LD_STREAM_DETECT **stream_detect_by_ld;
 	dma_addr_t ioc_init_request_phys;
 	struct MPI2_IOC_INIT_REQUEST *ioc_init_request;
+	struct megasas_cmd *ioc_init_cmd;
 
 };
 
-- 
2.14.1.dirty
