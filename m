From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH 3/7] megaraid_sas: Do not fire DCMDs during PCI shutdown/detach
Date: Mon, 17 Oct 2016 03:24:06 -0700
Message-ID: <1476699850-25083-4-git-send-email-sumit.saxena@broadcom.com>
References: <1476699850-25083-1-git-send-email-sumit.saxena@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35913 "EHLO
        mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933510AbcJQKYa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2016 06:24:30 -0400
Received: by mail-pa0-f54.google.com with SMTP id ry6so62359213pac.3
        for <linux-scsi@vger.kernel.org>; Mon, 17 Oct 2016 03:24:30 -0700 (PDT)
In-Reply-To: <1476699850-25083-1-git-send-email-sumit.saxena@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, Sumit Saxena <sumit.saxena@broadcom.com>

This patch addresses the issue of driver firing DCMDs in PCI
shutdown/detach path irrespective of firmware state.
Driver will check for whether firmware is operational state or not
before firing DCMDs. If firmware is in unrecoverbale
state or does not become operational within specfied time, driver will
skip firing DCMDs.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   | 46 +++++++++++++++++++++++++++++
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  9 ++++--
 2 files changed, 52 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 9ff57de..092387f 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6248,6 +6248,32 @@ fail_reenable_msix:
 #define megasas_resume	NULL
 #endif
 
+static inline int
+megasas_wait_for_adapter_operational(struct megasas_instance *instance)
+{
+	int wait_time = MEGASAS_RESET_WAIT_TIME * 2;
+	int i;
+
+	for (i = 0; i < wait_time; i++) {
+		if (atomic_read(&instance->adprecovery)
+			== MEGASAS_HBA_OPERATIONAL)
+			break;
+
+		if (!(i % MEGASAS_RESET_NOTICE_INTERVAL))
+			dev_notice(&instance->pdev->dev, "waiting for controller reset to finish\n");
+
+		msleep(1000);
+	}
+
+	if (atomic_read(&instance->adprecovery) != MEGASAS_HBA_OPERATIONAL) {
+		dev_info(&instance->pdev->dev, "%s timed out while waiting for HBA to recover.\n",
+			__func__);
+		return 1;
+	}
+
+	return 0;
+}
+
 /**
  * megasas_detach_one -	PCI hot"un"plug entry point
  * @pdev:		PCI device structure
@@ -6272,9 +6298,18 @@ static void megasas_detach_one(struct pci_dev *pdev)
 	if (instance->fw_crash_state != UNAVAILABLE)
 		megasas_free_host_crash_buffer(instance);
 	scsi_remove_host(instance->host);
+
+	msleep(1000);
+	if ((atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR)
+		|| ((atomic_read(&instance->adprecovery)
+			!= MEGASAS_HBA_OPERATIONAL) &&
+		megasas_wait_for_adapter_operational(instance)))
+		goto skip_firing_dcmds;
+
 	megasas_flush_cache(instance);
 	megasas_shutdown_controller(instance, MR_DCMD_CTRL_SHUTDOWN);
 
+skip_firing_dcmds:
 	/* cancel the delayed work if this work still in queue*/
 	if (instance->ev != NULL) {
 		struct megasas_aen_event *ev = instance->ev;
@@ -6388,8 +6423,19 @@ static void megasas_shutdown(struct pci_dev *pdev)
 	struct megasas_instance *instance = pci_get_drvdata(pdev);
 
 	instance->unload = 1;
+
+	msleep(1000);
+
+	if ((atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR)
+		|| ((atomic_read(&instance->adprecovery)
+			!= MEGASAS_HBA_OPERATIONAL)
+		&& megasas_wait_for_adapter_operational(instance)))
+		goto skip_firing_dcmds;
+
 	megasas_flush_cache(instance);
 	megasas_shutdown_controller(instance, MR_DCMD_CTRL_SHUTDOWN);
+
+skip_firing_dcmds:
 	instance->instancet->disable_intr(instance);
 	megasas_destroy_irqs(instance);
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 61be7ed..2159f6a 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2463,12 +2463,15 @@ irqreturn_t megasas_isr_fusion(int irq, void *devp)
 			/* Start collecting crash, if DMA bit is done */
 			if ((fw_state == MFI_STATE_FAULT) && dma_state)
 				schedule_work(&instance->crash_init);
-			else if (fw_state == MFI_STATE_FAULT)
-				schedule_work(&instance->work_init);
+			else if (fw_state == MFI_STATE_FAULT) {
+				if (instance->unload == 0)
+					schedule_work(&instance->work_init);
+			}
 		} else if (fw_state == MFI_STATE_FAULT) {
 			dev_warn(&instance->pdev->dev, "Iop2SysDoorbellInt"
 			       "for scsi%d\n", instance->host->host_no);
-			schedule_work(&instance->work_init);
+			if (instance->unload == 0)
+				schedule_work(&instance->work_init);
 		}
 	}
 
-- 
1.8.3.1

