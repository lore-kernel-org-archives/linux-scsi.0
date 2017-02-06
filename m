From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 34/39] megaraid_sas: Use synchronize_irq to wait for IRQs to complete
Date: Mon,  6 Feb 2017 02:00:07 -0800
Message-ID: <1486375212-17329-35-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:36254 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751562AbdBFKDC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 05:03:02 -0500
Received: by mail-pg0-f50.google.com with SMTP id v184so27419787pgv.3
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 02:03:02 -0800 (PST)
In-Reply-To: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

FIX - Do not use random delay to synchronize with IRQ. Use kernel API.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 8edb6ba..5dda73d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3141,6 +3141,22 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex)
 }
 
 /**
+ * megasas_sync_irqs -	Synchronizes all IRQs owned by adapter
+ * @instance:			Adapter soft state
+ */
+void megasas_sync_irqs(unsigned long instance_addr)
+{
+	u32 count, i;
+	struct megasas_instance *instance =
+		(struct megasas_instance *)instance_addr;
+
+	count = instance->msix_vectors > 0 ? instance->msix_vectors : 1;
+
+	for (i = 0; i < count; i++)
+		synchronize_irq(pci_irq_vector(instance->pdev, i));
+}
+
+/**
  * megasas_complete_cmd_dpc_fusion -	Completes command
  * @instance:			Adapter soft state
  *
@@ -3816,7 +3832,7 @@ megasas_issue_tm(struct megasas_instance *instance, u16 device_handle,
 			break;
 		else {
 			instance->instancet->disable_intr(instance);
-			msleep(1000);
+			megasas_sync_irqs((unsigned long)instance);
 			megasas_complete_cmd_dpc_fusion
 					((unsigned long)instance);
 			instance->instancet->enable_intr(instance);
@@ -4170,7 +4186,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 	set_bit(MEGASAS_FUSION_IN_RESET, &instance->reset_flags);
 	atomic_set(&instance->adprecovery, MEGASAS_ADPRESET_SM_POLLING);
 	instance->instancet->disable_intr(instance);
-	msleep(1000);
+	megasas_sync_irqs((unsigned long)instance);
 
 	/* First try waiting for commands to complete */
 	if (megasas_wait_for_outstanding_fusion(instance, reason,
-- 
2.8.3
