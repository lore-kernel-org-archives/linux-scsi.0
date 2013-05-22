From: <Sumit.Saxena@lsi.com>
Subject: [PATCH 11/12] megaraid_sas : Add support to differentiate between iMR vs MR Firmware
Date: Wed, 22 May 2013 12:35:33 +0530
Message-ID: <201305221235.r4MCZnQH013033@cosmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:40583
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751035Ab3EVMgU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 May 2013 08:36:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, kashyap.desai@lsi.com, aradford@gmail.com

Add support to differentiate between iMR(no external memory) and MR(with external memory) controllers.

Signed-off-by: Sumit Saxena <sumit.saxena@lsi.com>
Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index dab46c2..1c2b1b9 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1533,6 +1533,7 @@ struct megasas_instance {
 	struct mutex reset_mutex;
 	int throttlequeuedepth;
 	u8 mask_interrupts;
+	u8 is_imr;
 };
 
 enum {
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 21f0434..adb3911 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1641,10 +1641,7 @@ megasas_check_and_restore_queue_depth(struct megasas_instance *instance)
 
 		spin_lock_irqsave(instance->host->host_lock, flags);
 		instance->flag &= ~MEGASAS_FW_BUSY;
-		if ((instance->pdev->device ==
-			PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
-			(instance->pdev->device ==
-			PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
+		if (instance->is_imr) {
 			instance->host->can_queue =
 				instance->max_fw_cmds - MEGASAS_SKINNY_INT_CMDS;
 		} else
@@ -3662,6 +3659,18 @@ static int megasas_init_fw(struct megasas_instance *instance)
 		max_sectors_2 = ctrl_info->max_request_size;
 
 		tmp_sectors = min_t(u32, max_sectors_1 , max_sectors_2);
+
+		/*Check whether controller is iMR or MR */
+		if (ctrl_info->memory_size) {
+			instance->is_imr = 0;
+			dev_info(&instance->pdev->dev, "Controller type: MR,"
+				"Memory size is: %dMB\n",
+				ctrl_info->memory_size);
+		} else {
+			instance->is_imr = 1;
+			dev_info(&instance->pdev->dev,
+				"Controller type: iMR\n");
+		}
 		instance->disableOnlineCtrlReset =
 		ctrl_info->properties.OnOffProperties.disableOnlineCtrlReset;
 		instance->UnevenSpanSupport =
@@ -3686,8 +3695,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	kfree(ctrl_info);
 
 	/* Check for valid throttlequeuedepth module parameter */
-	if (instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY ||
-	    instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0071SKINNY) {
+	if (instance->is_imr) {
 		if (throttlequeuedepth > (instance->max_fw_cmds -
 					  MEGASAS_SKINNY_INT_CMDS))
 			instance->throttlequeuedepth =
@@ -3971,8 +3979,7 @@ static int megasas_io_attach(struct megasas_instance *instance)
 	 */
 	host->irq = instance->pdev->irq;
 	host->unique_id = instance->unique_id;
-	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
-		(instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
+	if (instance->is_imr) {
 		host->can_queue =
 			instance->max_fw_cmds - MEGASAS_SKINNY_INT_CMDS;
 	} else
@@ -4167,6 +4174,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 	instance->ev = NULL;
 	instance->issuepend_done = 1;
 	instance->adprecovery = MEGASAS_HBA_OPERATIONAL;
+	instance->is_imr = 0;
 	megasas_poll_wait_aen = 0;
 
 	instance->evt_detail = pci_alloc_consistent(pdev,

