From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 11/19] megaraid_sas: Move initialization of instance parameters inside newly created function megasas_init_ctrl_params
Date: Thu, 19 Oct 2017 02:48:58 -0700
Message-ID: <1508406546-25944-12-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1508406546-25944-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:56203 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752643AbdJSJu2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Oct 2017 05:50:28 -0400
Received: by mail-pf0-f194.google.com with SMTP id 17so6189409pfn.12
        for <linux-scsi@vger.kernel.org>; Thu, 19 Oct 2017 02:50:27 -0700 (PDT)
In-Reply-To: <1508406546-25944-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Code refactoring, no functional change - Create new function to initialize
all the controller parameters during load time.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 119 +++++++++++++++---------------
 1 file changed, 61 insertions(+), 58 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 2a68c75b7c4e..86cceb48ba84 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6225,6 +6225,59 @@ void megasas_free_ctrl_dma_buffers(struct megasas_instance *instance)
 				    instance->crash_dump_h);
 }
 
+/*
+ * megasas_init_ctrl_params -		Initialize controller's instance
+ *					parameters before FW init
+ * @instance -				Adapter soft instance
+ * @return -				void
+ */
+static inline void megasas_init_ctrl_params(struct megasas_instance *instance)
+{
+	instance->fw_crash_state = UNAVAILABLE;
+
+	megasas_poll_wait_aen = 0;
+	instance->issuepend_done = 1;
+	atomic_set(&instance->adprecovery, MEGASAS_HBA_OPERATIONAL);
+
+	/*
+	 * Initialize locks and queues
+	 */
+	INIT_LIST_HEAD(&instance->cmd_pool);
+	INIT_LIST_HEAD(&instance->internal_reset_pending_q);
+
+	atomic_set(&instance->fw_outstanding, 0);
+
+	init_waitqueue_head(&instance->int_cmd_wait_q);
+	init_waitqueue_head(&instance->abort_cmd_wait_q);
+
+	spin_lock_init(&instance->crashdump_lock);
+	spin_lock_init(&instance->mfi_pool_lock);
+	spin_lock_init(&instance->hba_lock);
+	spin_lock_init(&instance->stream_lock);
+	spin_lock_init(&instance->completion_lock);
+
+	mutex_init(&instance->hba_mutex);
+	mutex_init(&instance->reset_mutex);
+
+	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
+	    (instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0071SKINNY))
+		instance->flag_ieee = 1;
+
+	megasas_dbg_lvl = 0;
+	instance->flag = 0;
+	instance->unload = 1;
+	instance->last_time = 0;
+	instance->disableOnlineCtrlReset = 1;
+	instance->UnevenSpanSupport = 0;
+
+	if (instance->adapter_type != MFI_SERIES) {
+		INIT_WORK(&instance->work_init, megasas_fusion_ocr_wq);
+		INIT_WORK(&instance->crash_init, megasas_fusion_crash_dump_wq);
+	} else {
+		INIT_WORK(&instance->work_init, process_fw_state_change_wq);
+	}
+}
+
 /**
  * megasas_probe_one -	PCI hotplug entry point
  * @pdev:		PCI device structure
@@ -6279,74 +6332,24 @@ static int megasas_probe_one(struct pci_dev *pdev,
 	instance = (struct megasas_instance *)host->hostdata;
 	memset(instance, 0, sizeof(*instance));
 	atomic_set(&instance->fw_reset_no_pci_access, 0);
-	instance->pdev = pdev;
-
-	megasas_set_adapter_type(instance);
-
-	if (megasas_alloc_ctrl_mem(instance))
-		goto fail_alloc_dma_buf;
-
-	if (megasas_alloc_ctrl_dma_buffers(instance))
-		goto fail_alloc_dma_buf;
-
-	/* Crash dump feature related initialisation*/
-	instance->drv_buf_index = 0;
-	instance->drv_buf_alloc = 0;
-	instance->crash_dump_fw_support = 0;
-	instance->crash_dump_app_support = 0;
-	instance->fw_crash_state = UNAVAILABLE;
-	spin_lock_init(&instance->crashdump_lock);
-	instance->crash_dump_buf = NULL;
-
-	megasas_poll_wait_aen = 0;
-	instance->flag_ieee = 0;
-	instance->ev = NULL;
-	instance->issuepend_done = 1;
-	atomic_set(&instance->adprecovery, MEGASAS_HBA_OPERATIONAL);
-	instance->is_imr = 0;
-
-	/*
-	 * Initialize locks and queues
-	 */
-	INIT_LIST_HEAD(&instance->cmd_pool);
-	INIT_LIST_HEAD(&instance->internal_reset_pending_q);
-
-	atomic_set(&instance->fw_outstanding,0);
-
-	init_waitqueue_head(&instance->int_cmd_wait_q);
-	init_waitqueue_head(&instance->abort_cmd_wait_q);
-
-	spin_lock_init(&instance->mfi_pool_lock);
-	spin_lock_init(&instance->hba_lock);
-	spin_lock_init(&instance->stream_lock);
-	spin_lock_init(&instance->completion_lock);
-
-	mutex_init(&instance->reset_mutex);
-	mutex_init(&instance->hba_mutex);
 
 	/*
 	 * Initialize PCI related and misc parameters
 	 */
+	instance->pdev = pdev;
 	instance->host = host;
 	instance->unique_id = pdev->bus->number << 8 | pdev->devfn;
 	instance->init_id = MEGASAS_DEFAULT_INIT_ID;
 
-	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
-		(instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0071SKINNY))
-		instance->flag_ieee = 1;
+	megasas_set_adapter_type(instance);
 
-	megasas_dbg_lvl = 0;
-	instance->flag = 0;
-	instance->unload = 1;
-	instance->last_time = 0;
-	instance->disableOnlineCtrlReset = 1;
-	instance->UnevenSpanSupport = 0;
+	megasas_init_ctrl_params(instance);
 
-	if (instance->adapter_type != MFI_SERIES) {
-		INIT_WORK(&instance->work_init, megasas_fusion_ocr_wq);
-		INIT_WORK(&instance->crash_init, megasas_fusion_crash_dump_wq);
-	} else
-		INIT_WORK(&instance->work_init, process_fw_state_change_wq);
+	if (megasas_alloc_ctrl_mem(instance))
+		goto fail_alloc_dma_buf;
+
+	if (megasas_alloc_ctrl_dma_buffers(instance))
+		goto fail_alloc_dma_buf;
 
 	/*
 	 * Initialize MFI Firmware
-- 
2.14.1.dirty
