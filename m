From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 16/39] megaraid_sas: reduce size of fusion_context and use vmalloc if kmalloc fails
Date: Mon,  6 Feb 2017 01:59:49 -0800
Message-ID: <1486375212-17329-17-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:33697 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751701AbdBFKCJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 05:02:09 -0500
Received: by mail-pf0-f178.google.com with SMTP id y143so23099560pfb.0
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 02:02:09 -0800 (PST)
In-Reply-To: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Currently fusion context has fixed array load_balance_info. Use dynamic allocation.
In few places, driver do not want physically contigious memory.
Attempt to use vmalloc if physical contiguous memory is not available.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        |  2 +
 drivers/scsi/megaraid/megaraid_sas_base.c   | 15 ++----
 drivers/scsi/megaraid/megaraid_sas_fp.c     |  3 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 71 +++++++++++++++++++++++++++--
 drivers/scsi/megaraid/megaraid_sas_fusion.h |  3 +-
 5 files changed, 76 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index ac2aed3..f023e23 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2488,4 +2488,6 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason);
 int megasas_task_abort_fusion(struct scsi_cmnd *scmd);
 int megasas_reset_target_fusion(struct scsi_cmnd *scmd);
 u32 mega_mod64(u64 dividend, u32 divisor);
+int megasas_alloc_fusion_context(struct megasas_instance *instance);
+void megasas_free_fusion_context(struct megasas_instance *instance);
 #endif				/*LSI_MEGARAID_SAS_H */
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index de01e36..c38b9c3 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6024,18 +6024,12 @@ static int megasas_probe_one(struct pci_dev *pdev,
 	case PCI_DEVICE_ID_LSI_CUTLASS_52:
 	case PCI_DEVICE_ID_LSI_CUTLASS_53:
 	{
-		instance->ctrl_context_pages =
-			get_order(sizeof(struct fusion_context));
-		instance->ctrl_context = (void *)__get_free_pages(GFP_KERNEL,
-				instance->ctrl_context_pages);
-		if (!instance->ctrl_context) {
-			dev_printk(KERN_DEBUG, &pdev->dev, "Failed to allocate "
-			       "memory for Fusion context info\n");
+		if (megasas_alloc_fusion_context(instance)) {
+			megasas_free_fusion_context(instance);
 			goto fail_alloc_dma_buf;
 		}
 		fusion = instance->ctrl_context;
-		memset(fusion, 0,
-			((1 << PAGE_SHIFT) << instance->ctrl_context_pages));
+
 		if ((instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION) ||
 			(instance->pdev->device == PCI_DEVICE_ID_LSI_PLASMA))
 			fusion->adapter_type = THUNDERBOLT_SERIES;
@@ -6678,8 +6672,7 @@ static void megasas_detach_one(struct pci_dev *pdev)
 					fusion->pd_seq_sync[i],
 					fusion->pd_seq_phys[i]);
 		}
-		free_pages((ulong)instance->ctrl_context,
-			instance->ctrl_context_pages);
+		megasas_free_fusion_context(instance);
 	} else {
 		megasas_release_mfi(instance);
 		pci_free_consistent(pdev, sizeof(u32),
diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index c3ef82d..d9b0f28 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -489,7 +489,8 @@ u8 MR_ValidateMapInfo(struct megasas_instance *instance)
 	if (instance->UnevenSpanSupport)
 		mr_update_span_set(drv_map, ldSpanInfo);
 
-	mr_update_load_balance_params(drv_map, lbInfo);
+	if (lbInfo)
+		mr_update_load_balance_params(drv_map, lbInfo);
 
 	num_lds = le16_to_cpu(drv_map->raidMap.ldCount);
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 8dd4944..2f523f2 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -47,6 +47,7 @@
 #include <linux/blkdev.h>
 #include <linux/mutex.h>
 #include <linux/poll.h>
+#include <linux/vmalloc.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -2394,8 +2395,9 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 			io_request->IoFlags |=
 			cpu_to_le16(MPI25_SAS_DEVICE0_FLAGS_ENABLED_FAST_PATH);
 		}
-		if ((fusion->load_balance_info[device_id].loadBalanceFlag) &&
-		    (io_info.isRead)) {
+		if (fusion->load_balance_info &&
+			(fusion->load_balance_info[device_id].loadBalanceFlag) &&
+			(io_info.isRead)) {
 			io_info.devHandle =
 				get_updated_dev_handle(instance,
 					&fusion->load_balance_info[device_id],
@@ -4266,9 +4268,10 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 				retval = FAILED;
 			}
 			/* Reset load balance info */
-			memset(fusion->load_balance_info, 0,
-			       sizeof(struct LD_LOAD_BALANCE_INFO)
-			       *MAX_LOGICAL_DRIVES_EXT);
+			if (fusion->load_balance_info)
+				memset(fusion->load_balance_info, 0,
+				       (sizeof(struct LD_LOAD_BALANCE_INFO) *
+				       MAX_LOGICAL_DRIVES_EXT));
 
 			if (!megasas_get_map_info(instance))
 				megasas_sync_map_info(instance);
@@ -4422,6 +4425,64 @@ void megasas_fusion_ocr_wq(struct work_struct *work)
 	megasas_reset_fusion(instance->host, 0);
 }
 
+/* Allocate fusion context */
+int
+megasas_alloc_fusion_context(struct megasas_instance *instance)
+{
+	struct fusion_context *fusion;
+
+	instance->ctrl_context_pages = get_order(sizeof(struct fusion_context));
+	instance->ctrl_context = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+		instance->ctrl_context_pages);
+	if (!instance->ctrl_context) {
+		/* fall back to using vmalloc for fusion_context */
+		instance->ctrl_context = vzalloc(sizeof(struct fusion_context));
+		if (!instance->ctrl_context) {
+			dev_err(&instance->pdev->dev, "Failed from %s %d\n", __func__, __LINE__);
+			return -ENOMEM;
+		}
+	}
+
+	fusion = instance->ctrl_context;
+
+	fusion->load_balance_info_pages = get_order(MAX_LOGICAL_DRIVES_EXT *
+		sizeof(struct LD_LOAD_BALANCE_INFO));
+	fusion->load_balance_info =
+		(struct LD_LOAD_BALANCE_INFO *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+		fusion->load_balance_info_pages);
+	if (!fusion->load_balance_info) {
+		fusion->load_balance_info = vzalloc(MAX_LOGICAL_DRIVES_EXT *
+			sizeof(struct LD_LOAD_BALANCE_INFO));
+		if (!fusion->load_balance_info)
+			dev_err(&instance->pdev->dev, "Failed to allocate load_balance_info, "
+				"continuing without Load Balance support\n");
+	}
+
+	return 0;
+}
+
+void
+megasas_free_fusion_context(struct megasas_instance *instance)
+{
+	struct fusion_context *fusion = instance->ctrl_context;
+
+	if (fusion) {
+		if (fusion->load_balance_info) {
+			if (is_vmalloc_addr(fusion->load_balance_info))
+				vfree(fusion->load_balance_info);
+			else
+				free_pages((ulong)fusion->load_balance_info,
+					fusion->load_balance_info_pages);
+		}
+
+		if (is_vmalloc_addr(fusion))
+			vfree(fusion);
+		else
+			free_pages((ulong)fusion,
+				instance->ctrl_context_pages);
+	}
+}
+
 struct megasas_instance_template megasas_instance_template_fusion = {
 	.enable_intr = megasas_enable_intr_fusion,
 	.disable_intr = megasas_disable_intr_fusion,
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index c606ca0..f25a262 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -1287,7 +1287,8 @@ struct fusion_context {
 	struct MR_PD_CFG_SEQ_NUM_SYNC	*pd_seq_sync[JBOD_MAPS_COUNT];
 	dma_addr_t pd_seq_phys[JBOD_MAPS_COUNT];
 	u8 fast_path_io;
-	struct LD_LOAD_BALANCE_INFO load_balance_info[MAX_LOGICAL_DRIVES_EXT];
+	struct LD_LOAD_BALANCE_INFO *load_balance_info;
+	u32 load_balance_info_pages;
 	LD_SPAN_INFO log_to_span[MAX_LOGICAL_DRIVES_EXT];
 	u8 adapter_type;
 	struct LD_STREAM_DETECT **stream_detect_by_ld;
-- 
2.8.3
