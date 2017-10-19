From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 12/19] megaraid_sas: Move controller memory allocations and DMA mask settings from probe to megasas_init_fw
Date: Thu, 19 Oct 2017 02:48:59 -0700
Message-ID: <1508406546-25944-13-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1508406546-25944-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:43102 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752626AbdJSJua (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Oct 2017 05:50:30 -0400
Received: by mail-pf0-f195.google.com with SMTP id a8so6201243pfc.0
        for <linux-scsi@vger.kernel.org>; Thu, 19 Oct 2017 02:50:30 -0700 (PDT)
In-Reply-To: <1508406546-25944-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 43 ++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 86cceb48ba84..3a179c3fabc0 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -206,6 +206,18 @@ wait_and_poll(struct megasas_instance *instance, struct megasas_cmd *cmd,
 void megasas_fusion_ocr_wq(struct work_struct *work);
 static int megasas_get_ld_vf_affiliation(struct megasas_instance *instance,
 					 int initial);
+static int
+megasas_set_dma_mask(struct pci_dev *pdev);
+static int
+megasas_alloc_ctrl_mem(struct megasas_instance *instance);
+static inline void
+megasas_free_ctrl_mem(struct megasas_instance *instance);
+static inline int
+megasas_alloc_ctrl_dma_buffers(struct megasas_instance *instance);
+static inline void
+megasas_free_ctrl_dma_buffers(struct megasas_instance *instance);
+static inline void
+megasas_init_ctrl_params(struct megasas_instance *instance);
 
 void
 megasas_issue_dcmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
@@ -5179,6 +5191,19 @@ static int megasas_init_fw(struct megasas_instance *instance)
 			goto fail_ready_state;
 	}
 
+	megasas_init_ctrl_params(instance);
+
+	if (megasas_set_dma_mask(instance->pdev))
+		goto fail_ready_state;
+
+	if (megasas_alloc_ctrl_mem(instance))
+		goto fail_alloc_dma_buf;
+
+	if (megasas_alloc_ctrl_dma_buffers(instance))
+		goto fail_alloc_dma_buf;
+
+	fusion = instance->ctrl_context;
+
 	if (instance->adapter_type == VENTURA_SERIES) {
 		scratch_pad_3 =
 			readl(&instance->reg_set->outbound_scratch_pad_3);
@@ -5475,6 +5500,9 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	if (instance->msix_vectors)
 		pci_free_irq_vectors(instance->pdev);
 	instance->msix_vectors = 0;
+fail_alloc_dma_buf:
+	megasas_free_ctrl_dma_buffers(instance);
+	megasas_free_ctrl_mem(instance);
 fail_ready_state:
 	iounmap(instance->reg_set);
 
@@ -6318,9 +6346,6 @@ static int megasas_probe_one(struct pci_dev *pdev,
 
 	pci_set_master(pdev);
 
-	if (megasas_set_dma_mask(pdev))
-		goto fail_set_dma_mask;
-
 	host = scsi_host_alloc(&megasas_template,
 			       sizeof(struct megasas_instance));
 
@@ -6343,14 +6368,6 @@ static int megasas_probe_one(struct pci_dev *pdev,
 
 	megasas_set_adapter_type(instance);
 
-	megasas_init_ctrl_params(instance);
-
-	if (megasas_alloc_ctrl_mem(instance))
-		goto fail_alloc_dma_buf;
-
-	if (megasas_alloc_ctrl_dma_buffers(instance))
-		goto fail_alloc_dma_buf;
-
 	/*
 	 * Initialize MFI Firmware
 	 */
@@ -6432,13 +6449,9 @@ static int megasas_probe_one(struct pci_dev *pdev,
 	if (instance->msix_vectors)
 		pci_free_irq_vectors(instance->pdev);
 fail_init_mfi:
-fail_alloc_dma_buf:
-	megasas_free_ctrl_dma_buffers(instance);
-	megasas_free_ctrl_mem(instance);
 	scsi_host_put(host);
 
 fail_alloc_instance:
-fail_set_dma_mask:
 	pci_disable_device(pdev);
 
 	return -ENODEV;
-- 
2.14.1.dirty
