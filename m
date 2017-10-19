From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 16/19] megaraid_sas: Retry with reduced queue depth when alloc fails for higher QD
Date: Thu, 19 Oct 2017 02:49:03 -0700
Message-ID: <1508406546-25944-17-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1508406546-25944-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:46666 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752621AbdJSJul (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Oct 2017 05:50:41 -0400
Received: by mail-pf0-f195.google.com with SMTP id p87so6199292pfj.3
        for <linux-scsi@vger.kernel.org>; Thu, 19 Oct 2017 02:50:40 -0700 (PDT)
In-Reply-To: <1508406546-25944-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

In certain cases, the host memory is limited and with FW supporting higher
queue depths there are increasing chances of IO request frame allocation
failures that we are seeing. In case of request frame allocation failures,
retry allocation with reduced queue depth (in steps of 64) to continue
to configure the controller with a reduced performance rather than failing
load.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 106 ++++++++++++++++++----------
 drivers/scsi/megaraid/megaraid_sas_fusion.h |   1 +
 2 files changed, 68 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 857bdbb0f79d..8b7a08af275e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -96,6 +96,8 @@ extern unsigned int resetwaittime;
 extern unsigned int dual_qdepth_disable;
 static void megasas_free_rdpq_fusion(struct megasas_instance *instance);
 static void megasas_free_reply_fusion(struct megasas_instance *instance);
+static inline
+void megasas_configure_queue_sizes(struct megasas_instance *instance);
 
 
 
@@ -254,8 +256,8 @@ megasas_fusion_update_can_queue(struct megasas_instance *instance, int fw_boot_c
 			(instance->instancet->read_fw_status_reg(reg_set) & 0x00FFFF) - MEGASAS_FUSION_IOCTL_CMDS;
 
 	dev_info(&instance->pdev->dev,
-			"Current firmware maximum commands: %d\t LDIO threshold: %d\n",
-			cur_max_fw_cmds, ldio_threshold);
+		 "Current firmware supports maximum commands: %d\t LDIO thershold: %d\n",
+		 cur_max_fw_cmds, ldio_threshold);
 
 	if (fw_boot_context == OCR_CONTEXT) {
 		cur_max_fw_cmds = cur_max_fw_cmds - 1;
@@ -283,19 +285,7 @@ megasas_fusion_update_can_queue(struct megasas_instance *instance, int fw_boot_c
 		* does not exceed max cmds that the FW can support
 		*/
 		instance->max_fw_cmds = instance->max_fw_cmds-1;
-
-		instance->max_scsi_cmds = instance->max_fw_cmds -
-				(MEGASAS_FUSION_INTERNAL_CMDS +
-				MEGASAS_FUSION_IOCTL_CMDS);
-		instance->cur_can_queue = instance->max_scsi_cmds;
-		instance->host->can_queue = instance->cur_can_queue;
 	}
-
-	if (instance->adapter_type == VENTURA_SERIES)
-		instance->max_mpt_cmds =
-		instance->max_fw_cmds * RAID_1_PEER_CMDS;
-	else
-		instance->max_mpt_cmds = instance->max_fw_cmds;
 }
 /**
  * megasas_free_cmds_fusion -	Free all the cmds in the free cmd pool
@@ -468,16 +458,7 @@ megasas_alloc_request_fusion(struct megasas_instance *instance)
 
 	fusion = instance->ctrl_context;
 
-	fusion->req_frames_desc =
-		dma_alloc_coherent(&instance->pdev->dev,
-			fusion->request_alloc_sz,
-			&fusion->req_frames_desc_phys, GFP_KERNEL);
-	if (!fusion->req_frames_desc) {
-		dev_err(&instance->pdev->dev,
-			"Failed from %s %d\n",  __func__, __LINE__);
-		return -ENOMEM;
-	}
-
+retry_alloc:
 	fusion->io_request_frames_pool =
 			dma_pool_create("mr_ioreq", &instance->pdev->dev,
 				fusion->io_frames_alloc_sz, 16, 0);
@@ -492,10 +473,28 @@ megasas_alloc_request_fusion(struct megasas_instance *instance)
 			dma_pool_alloc(fusion->io_request_frames_pool,
 				GFP_KERNEL, &fusion->io_request_frames_phys);
 	if (!fusion->io_request_frames) {
+		if (instance->max_fw_cmds >= (MEGASAS_REDUCE_QD_COUNT * 2)) {
+			instance->max_fw_cmds -= MEGASAS_REDUCE_QD_COUNT;
+			dma_pool_destroy(fusion->io_request_frames_pool);
+			megasas_configure_queue_sizes(instance);
+			goto retry_alloc;
+		} else {
+			dev_err(&instance->pdev->dev,
+				"Failed from %s %d\n",  __func__, __LINE__);
+			return -ENOMEM;
+		}
+	}
+
+	fusion->req_frames_desc =
+		dma_alloc_coherent(&instance->pdev->dev,
+				   fusion->request_alloc_sz,
+				   &fusion->req_frames_desc_phys, GFP_KERNEL);
+	if (!fusion->req_frames_desc) {
 		dev_err(&instance->pdev->dev,
 			"Failed from %s %d\n",  __func__, __LINE__);
 		return -ENOMEM;
 	}
+
 	return 0;
 }
 
@@ -664,9 +663,6 @@ megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 
 	fusion = instance->ctrl_context;
 
-	if (megasas_alloc_cmdlist_fusion(instance))
-		goto fail_exit;
-
 	if (megasas_alloc_request_fusion(instance))
 		goto fail_exit;
 
@@ -677,6 +673,11 @@ megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 		if (megasas_alloc_reply_fusion(instance))
 			goto fail_exit;
 
+	if (megasas_alloc_cmdlist_fusion(instance))
+		goto fail_exit;
+
+	dev_info(&instance->pdev->dev, "Configured max firmware commands: %d\n",
+		 instance->max_fw_cmds);
 
 	/* The first 256 bytes (SMID 0) is not used. Don't add to the cmd list */
 	io_req_base = fusion->io_request_frames + MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE;
@@ -1325,6 +1326,44 @@ static inline int megasas_allocate_raid_maps(struct megasas_instance *instance)
 	return -ENOMEM;
 }
 
+/**
+ * megasas_configure_queue_sizes -	Calculate size of request desc queue,
+ *					reply desc queue,
+ *					IO request frame queue, set can_queue.
+ * @instance:				Adapter soft state
+ * @return:				void
+ */
+static inline
+void megasas_configure_queue_sizes(struct megasas_instance *instance)
+{
+	struct fusion_context *fusion;
+	u16 max_cmd;
+
+	fusion = instance->ctrl_context;
+	max_cmd = instance->max_fw_cmds;
+
+	if (instance->adapter_type == VENTURA_SERIES)
+		instance->max_mpt_cmds = instance->max_fw_cmds * RAID_1_PEER_CMDS;
+	else
+		instance->max_mpt_cmds = instance->max_fw_cmds;
+
+	instance->max_scsi_cmds = instance->max_fw_cmds -
+			(MEGASAS_FUSION_INTERNAL_CMDS +
+			MEGASAS_FUSION_IOCTL_CMDS);
+	instance->cur_can_queue = instance->max_scsi_cmds;
+	instance->host->can_queue = instance->cur_can_queue;
+
+	fusion->reply_q_depth = 2 * ((max_cmd + 1 + 15) / 16) * 16;
+
+	fusion->request_alloc_sz = sizeof(union MEGASAS_REQUEST_DESCRIPTOR_UNION) *
+					  instance->max_mpt_cmds;
+	fusion->reply_alloc_sz = sizeof(union MPI2_REPLY_DESCRIPTORS_UNION) *
+					(fusion->reply_q_depth);
+	fusion->io_frames_alloc_sz = MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE +
+		(MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE
+		 * (instance->max_mpt_cmds + 1)); /* Extra 1 for SMID 0 */
+}
+
 static int megasas_alloc_ioc_init_frame(struct megasas_instance *instance)
 {
 	struct fusion_context *fusion;
@@ -1386,7 +1425,6 @@ megasas_init_adapter_fusion(struct megasas_instance *instance)
 {
 	struct megasas_register_set __iomem *reg_set;
 	struct fusion_context *fusion;
-	u16 max_cmd;
 	u32 scratch_pad_2;
 	int i = 0, count;
 
@@ -1402,17 +1440,7 @@ megasas_init_adapter_fusion(struct megasas_instance *instance)
 	instance->max_mfi_cmds =
 		MEGASAS_FUSION_INTERNAL_CMDS + MEGASAS_FUSION_IOCTL_CMDS;
 
-	max_cmd = instance->max_fw_cmds;
-
-	fusion->reply_q_depth = 2 * (((max_cmd + 1 + 15)/16)*16);
-
-	fusion->request_alloc_sz =
-	sizeof(union MEGASAS_REQUEST_DESCRIPTOR_UNION) * instance->max_mpt_cmds;
-	fusion->reply_alloc_sz = sizeof(union MPI2_REPLY_DESCRIPTORS_UNION)
-		*(fusion->reply_q_depth);
-	fusion->io_frames_alloc_sz = MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE +
-		(MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE
-		* (instance->max_mpt_cmds + 1)); /* Extra 1 for SMID 0 */
+	megasas_configure_queue_sizes(instance);
 
 	scratch_pad_2 = readl(&instance->reg_set->outbound_scratch_pad_2);
 	/* If scratch_pad_2 & MEGASAS_MAX_CHAIN_SIZE_UNITS_MASK is set,
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index 549f86b2e871..4e229d72dfb0 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -103,6 +103,7 @@ enum MR_RAID_FLAGS_IO_SUB_TYPE {
 #define THRESHOLD_REPLY_COUNT 50
 #define RAID_1_PEER_CMDS 2
 #define JBOD_MAPS_COUNT	2
+#define MEGASAS_REDUCE_QD_COUNT 64
 #define IOC_INIT_FRAME_SIZE 4096
 
 /*
-- 
2.14.1.dirty
