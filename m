From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 08/19] megaraid_sas: Create separate functions for allocating and freeing controller DMA buffers
Date: Thu, 19 Oct 2017 02:48:55 -0700
Message-ID: <1508406546-25944-9-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1508406546-25944-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:43511 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752595AbdJSJuT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Oct 2017 05:50:19 -0400
Received: by mail-pg0-f68.google.com with SMTP id s75so6764878pgs.0
        for <linux-scsi@vger.kernel.org>; Thu, 19 Oct 2017 02:50:19 -0700 (PDT)
In-Reply-To: <1508406546-25944-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Code refactoring - create separate functions to allocate and free
controller DMA buffers

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 186 +++++++++++++++++-------------
 1 file changed, 103 insertions(+), 83 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 53f01729c6a8..443819747c5d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6092,6 +6092,103 @@ static inline void megasas_free_ctrl_mem(struct megasas_instance *instance)
 	}
 }
 
+/**
+ * megasas_alloc_ctrl_dma_buffers -	Allocate consistent DMA buffers during
+ *					driver load time
+ *
+ * @instance-				Adapter soft instance
+ * @return-				O for SUCCESS
+ */
+static inline
+int megasas_alloc_ctrl_dma_buffers(struct megasas_instance *instance)
+{
+	struct pci_dev *pdev = instance->pdev;
+
+	instance->evt_detail =
+		pci_alloc_consistent(pdev,
+				     sizeof(struct megasas_evt_detail),
+				     &instance->evt_detail_h);
+
+	if (!instance->evt_detail) {
+		dev_err(&instance->pdev->dev,
+			"Failed to allocate event detail buffer\n");
+		return -ENOMEM;
+	}
+
+	if (!reset_devices) {
+		instance->system_info_buf =
+			pci_alloc_consistent(pdev,
+					     sizeof(struct MR_DRV_SYSTEM_INFO),
+					     &instance->system_info_h);
+		instance->pd_info =
+			pci_alloc_consistent(pdev,
+					     sizeof(struct MR_PD_INFO),
+					     &instance->pd_info_h);
+		instance->tgt_prop =
+			pci_alloc_consistent(pdev,
+					     sizeof(struct MR_TARGET_PROPERTIES),
+					     &instance->tgt_prop_h);
+		instance->crash_dump_buf =
+			pci_alloc_consistent(pdev,
+					     CRASH_DMA_BUF_SIZE,
+					     &instance->crash_dump_h);
+
+		if (!instance->system_info_buf)
+			dev_err(&instance->pdev->dev,
+				"Failed to allocate system info buffer\n");
+
+		if (!instance->pd_info)
+			dev_err(&instance->pdev->dev,
+				"Failed to allocate pd_info buffer\n");
+
+		if (!instance->tgt_prop)
+			dev_err(&instance->pdev->dev,
+				"Failed to allocate tgt_prop buffer\n");
+
+		if (!instance->crash_dump_buf)
+			dev_err(&instance->pdev->dev,
+				"Failed to allocate crash dump buffer\n");
+	}
+
+	return 0;
+}
+
+/*
+ * megasas_free_ctrl_dma_buffers -	Free consistent DMA buffers allocated
+ *					during driver load time
+ *
+ * @instance-				Adapter soft instance
+ *
+ */
+static inline
+void megasas_free_ctrl_dma_buffers(struct megasas_instance *instance)
+{
+	struct pci_dev *pdev = instance->pdev;
+
+	if (instance->evt_detail)
+		pci_free_consistent(pdev, sizeof(struct megasas_evt_detail),
+				    instance->evt_detail,
+				    instance->evt_detail_h);
+
+	if (instance->system_info_buf)
+		pci_free_consistent(pdev, sizeof(struct MR_DRV_SYSTEM_INFO),
+				    instance->system_info_buf,
+				    instance->system_info_h);
+
+	if (instance->pd_info)
+		pci_free_consistent(pdev, sizeof(struct MR_PD_INFO),
+				    instance->pd_info, instance->pd_info_h);
+
+	if (instance->tgt_prop)
+		pci_free_consistent(pdev, sizeof(struct MR_TARGET_PROPERTIES),
+				    instance->tgt_prop, instance->tgt_prop_h);
+
+	if (instance->crash_dump_buf)
+		pci_free_consistent(pdev, CRASH_DMA_BUF_SIZE,
+				    instance->crash_dump_buf,
+				    instance->crash_dump_h);
+}
+
 /**
  * megasas_probe_one -	PCI hotplug entry point
  * @pdev:		PCI device structure
@@ -6153,6 +6250,9 @@ static int megasas_probe_one(struct pci_dev *pdev,
 	if (megasas_alloc_ctrl_mem(instance))
 		goto fail_alloc_dma_buf;
 
+	if (megasas_alloc_ctrl_dma_buffers(instance))
+		goto fail_alloc_dma_buf;
+
 	/* Crash dump feature related initialisation*/
 	instance->drv_buf_index = 0;
 	instance->drv_buf_alloc = 0;
@@ -6169,44 +6269,6 @@ static int megasas_probe_one(struct pci_dev *pdev,
 	atomic_set(&instance->adprecovery, MEGASAS_HBA_OPERATIONAL);
 	instance->is_imr = 0;
 
-	instance->evt_detail = pci_alloc_consistent(pdev,
-						    sizeof(struct
-							   megasas_evt_detail),
-						    &instance->evt_detail_h);
-
-	if (!instance->evt_detail) {
-		dev_printk(KERN_DEBUG, &pdev->dev, "Failed to allocate memory for "
-		       "event detail structure\n");
-		goto fail_alloc_dma_buf;
-	}
-
-	if (!reset_devices) {
-		instance->system_info_buf = pci_zalloc_consistent(pdev,
-					sizeof(struct MR_DRV_SYSTEM_INFO),
-					&instance->system_info_h);
-		if (!instance->system_info_buf)
-			dev_info(&instance->pdev->dev, "Can't allocate system info buffer\n");
-
-		instance->pd_info = pci_alloc_consistent(pdev,
-			sizeof(struct MR_PD_INFO), &instance->pd_info_h);
-
-		if (!instance->pd_info)
-			dev_err(&instance->pdev->dev, "Failed to alloc mem for pd_info\n");
-
-		instance->tgt_prop = pci_alloc_consistent(pdev,
-			sizeof(struct MR_TARGET_PROPERTIES), &instance->tgt_prop_h);
-
-		if (!instance->tgt_prop)
-			dev_err(&instance->pdev->dev, "Failed to alloc mem for tgt_prop\n");
-
-		instance->crash_dump_buf = pci_alloc_consistent(pdev,
-						CRASH_DMA_BUF_SIZE,
-						&instance->crash_dump_h);
-		if (!instance->crash_dump_buf)
-			dev_err(&pdev->dev, "Can't allocate Firmware "
-				"crash dump DMA buffer\n");
-	}
-
 	/*
 	 * Initialize locks and queues
 	 */
@@ -6334,19 +6396,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 		pci_free_irq_vectors(instance->pdev);
 fail_init_mfi:
 fail_alloc_dma_buf:
-	if (instance->evt_detail)
-		pci_free_consistent(pdev, sizeof(struct megasas_evt_detail),
-				    instance->evt_detail,
-				    instance->evt_detail_h);
-
-	if (instance->pd_info)
-		pci_free_consistent(pdev, sizeof(struct MR_PD_INFO),
-					instance->pd_info,
-					instance->pd_info_h);
-	if (instance->tgt_prop)
-		pci_free_consistent(pdev, sizeof(struct MR_TARGET_PROPERTIES),
-					instance->tgt_prop,
-					instance->tgt_prop_h);
+	megasas_free_ctrl_dma_buffers(instance);
 	megasas_free_ctrl_mem(instance);
 	scsi_host_put(host);
 
@@ -6605,20 +6655,7 @@ megasas_resume(struct pci_dev *pdev)
 	return 0;
 
 fail_init_mfi:
-	if (instance->evt_detail)
-		pci_free_consistent(pdev, sizeof(struct megasas_evt_detail),
-				instance->evt_detail,
-				instance->evt_detail_h);
-
-	if (instance->pd_info)
-		pci_free_consistent(pdev, sizeof(struct MR_PD_INFO),
-					instance->pd_info,
-					instance->pd_info_h);
-	if (instance->tgt_prop)
-		pci_free_consistent(pdev, sizeof(struct MR_TARGET_PROPERTIES),
-					instance->tgt_prop,
-					instance->tgt_prop_h);
-
+	megasas_free_ctrl_dma_buffers(instance);
 	megasas_free_ctrl_mem(instance);
 	scsi_host_put(host);
 
@@ -6766,17 +6803,6 @@ static void megasas_detach_one(struct pci_dev *pdev)
 
 	kfree(instance->ctrl_info);
 
-	if (instance->evt_detail)
-		pci_free_consistent(pdev, sizeof(struct megasas_evt_detail),
-				instance->evt_detail, instance->evt_detail_h);
-	if (instance->pd_info)
-		pci_free_consistent(pdev, sizeof(struct MR_PD_INFO),
-					instance->pd_info,
-					instance->pd_info_h);
-	if (instance->tgt_prop)
-		pci_free_consistent(pdev, sizeof(struct MR_TARGET_PROPERTIES),
-					instance->tgt_prop,
-					instance->tgt_prop_h);
 	if (instance->vf_affiliation)
 		pci_free_consistent(pdev, (MAX_LOGICAL_DRIVES + 1) *
 				    sizeof(struct MR_LD_VF_AFFILIATION),
@@ -6794,13 +6820,7 @@ static void megasas_detach_one(struct pci_dev *pdev)
 				    instance->hb_host_mem,
 				    instance->hb_host_mem_h);
 
-	if (instance->crash_dump_buf)
-		pci_free_consistent(pdev, CRASH_DMA_BUF_SIZE,
-			    instance->crash_dump_buf, instance->crash_dump_h);
-
-	if (instance->system_info_buf)
-		pci_free_consistent(pdev, sizeof(struct MR_DRV_SYSTEM_INFO),
-				    instance->system_info_buf, instance->system_info_h);
+	megasas_free_ctrl_dma_buffers(instance);
 
 	megasas_free_ctrl_mem(instance);
 
-- 
2.14.1.dirty
