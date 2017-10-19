From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 07/19] megaraid_sas: Create separate functions to allocate ctrl memory
Date: Thu, 19 Oct 2017 02:48:54 -0700
Message-ID: <1508406546-25944-8-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1508406546-25944-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:44715 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752512AbdJSJuR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Oct 2017 05:50:17 -0400
Received: by mail-pg0-f65.google.com with SMTP id j3so6769643pga.1
        for <linux-scsi@vger.kernel.org>; Thu, 19 Oct 2017 02:50:16 -0700 (PDT)
In-Reply-To: <1508406546-25944-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

No functional change. Code refactoring to improve readability.
Move the code to allocate and free controller memory into
separate functions.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 122 +++++++++++++++++++-----------
 1 file changed, 76 insertions(+), 46 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 5691e031112e..53f01729c6a8 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6023,6 +6023,75 @@ static inline void megasas_set_adapter_type(struct megasas_instance *instance)
 	}
 }
 
+static inline int megasas_alloc_mfi_ctrl_mem(struct megasas_instance *instance)
+{
+	instance->producer = pci_alloc_consistent(instance->pdev, sizeof(u32),
+						  &instance->producer_h);
+	instance->consumer = pci_alloc_consistent(instance->pdev, sizeof(u32),
+						  &instance->consumer_h);
+
+	if (!instance->producer || !instance->consumer) {
+		dev_err(&instance->pdev->dev,
+			"Failed to allocate memory for producer, consumer\n");
+		return -1;
+	}
+
+	*instance->producer = 0;
+	*instance->consumer = 0;
+	return 0;
+}
+
+/**
+ * megasas_alloc_ctrl_mem -	Allocate per controller memory for core data
+ *				structures which are not common across MFI
+ *				adapters and fusion adapters.
+ *				For MFI based adapters, allocate producer and
+ *				consumer buffers. For fusion adapters, allocate
+ *				memory for fusion context.
+ * @instance:			Adapter soft state
+ * return:			0 for SUCCESS
+ */
+static int megasas_alloc_ctrl_mem(struct megasas_instance *instance)
+{
+	switch (instance->adapter_type) {
+	case MFI_SERIES:
+		if (megasas_alloc_mfi_ctrl_mem(instance))
+			return -ENOMEM;
+		break;
+	case VENTURA_SERIES:
+	case THUNDERBOLT_SERIES:
+	case INVADER_SERIES:
+		if (megasas_alloc_fusion_context(instance))
+			return -ENOMEM;
+		break;
+	}
+
+	return 0;
+}
+
+/*
+ * megasas_free_ctrl_mem -	Free fusion context for fusion adapters and
+ *				producer, consumer buffers for MFI adapters
+ *
+ * @instance -			Adapter soft instance
+ *
+ */
+static inline void megasas_free_ctrl_mem(struct megasas_instance *instance)
+{
+	if (instance->adapter_type == MFI_SERIES) {
+		if (instance->producer)
+			pci_free_consistent(instance->pdev, sizeof(u32),
+					    instance->producer,
+					    instance->producer_h);
+		if (instance->consumer)
+			pci_free_consistent(instance->pdev, sizeof(u32),
+					    instance->consumer,
+					    instance->consumer_h);
+	} else {
+		megasas_free_fusion_context(instance);
+	}
+}
+
 /**
  * megasas_probe_one -	PCI hotplug entry point
  * @pdev:		PCI device structure
@@ -6081,33 +6150,8 @@ static int megasas_probe_one(struct pci_dev *pdev,
 
 	megasas_set_adapter_type(instance);
 
-	switch (instance->adapter_type) {
-	case MFI_SERIES:
-		instance->producer =
-			pci_alloc_consistent(pdev, sizeof(u32),
-					     &instance->producer_h);
-		instance->consumer =
-			pci_alloc_consistent(pdev, sizeof(u32),
-					     &instance->consumer_h);
-
-		if (!instance->producer || !instance->consumer) {
-			dev_printk(KERN_DEBUG, &pdev->dev, "Failed to allocate "
-			       "memory for producer, consumer\n");
-			goto fail_alloc_dma_buf;
-		}
-
-		*instance->producer = 0;
-		*instance->consumer = 0;
-
-		break;
-	case VENTURA_SERIES:
-	case THUNDERBOLT_SERIES:
-	case INVADER_SERIES:
-		if (megasas_alloc_fusion_context(instance)) {
-			megasas_free_fusion_context(instance);
-			goto fail_alloc_dma_buf;
-		}
-	}
+	if (megasas_alloc_ctrl_mem(instance))
+		goto fail_alloc_dma_buf;
 
 	/* Crash dump feature related initialisation*/
 	instance->drv_buf_index = 0;
@@ -6303,12 +6347,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 		pci_free_consistent(pdev, sizeof(struct MR_TARGET_PROPERTIES),
 					instance->tgt_prop,
 					instance->tgt_prop_h);
-	if (instance->producer)
-		pci_free_consistent(pdev, sizeof(u32), instance->producer,
-				    instance->producer_h);
-	if (instance->consumer)
-		pci_free_consistent(pdev, sizeof(u32), instance->consumer,
-				    instance->consumer_h);
+	megasas_free_ctrl_mem(instance);
 	scsi_host_put(host);
 
 fail_alloc_instance:
@@ -6579,12 +6618,8 @@ megasas_resume(struct pci_dev *pdev)
 		pci_free_consistent(pdev, sizeof(struct MR_TARGET_PROPERTIES),
 					instance->tgt_prop,
 					instance->tgt_prop_h);
-	if (instance->producer)
-		pci_free_consistent(pdev, sizeof(u32), instance->producer,
-				instance->producer_h);
-	if (instance->consumer)
-		pci_free_consistent(pdev, sizeof(u32), instance->consumer,
-				instance->consumer_h);
+
+	megasas_free_ctrl_mem(instance);
 	scsi_host_put(host);
 
 fail_set_dma_mask:
@@ -6725,15 +6760,8 @@ static void megasas_detach_one(struct pci_dev *pdev)
 					fusion->pd_seq_sync[i],
 					fusion->pd_seq_phys[i]);
 		}
-		megasas_free_fusion_context(instance);
 	} else {
 		megasas_release_mfi(instance);
-		pci_free_consistent(pdev, sizeof(u32),
-				    instance->producer,
-				    instance->producer_h);
-		pci_free_consistent(pdev, sizeof(u32),
-				    instance->consumer,
-				    instance->consumer_h);
 	}
 
 	kfree(instance->ctrl_info);
@@ -6774,6 +6802,8 @@ static void megasas_detach_one(struct pci_dev *pdev)
 		pci_free_consistent(pdev, sizeof(struct MR_DRV_SYSTEM_INFO),
 				    instance->system_info_buf, instance->system_info_h);
 
+	megasas_free_ctrl_mem(instance);
+
 	scsi_host_put(host);
 
 	pci_disable_device(pdev);
-- 
2.14.1.dirty
