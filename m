From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 1/4] megaraid_sas: enable intx only if msix request fails
Date: Fri, 10 Mar 2017 03:22:12 -0800
Message-ID: <1489144935-26567-2-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1489144935-26567-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:32815 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933765AbdCJLWu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Mar 2017 06:22:50 -0500
Received: by mail-pf0-f175.google.com with SMTP id w189so40969032pfb.0
        for <linux-scsi@vger.kernel.org>; Fri, 10 Mar 2017 03:22:49 -0800 (PST)
In-Reply-To: <1489144935-26567-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Without this fix, driver will enable INTx Interrupt pin even though
MSI-x vectors are enabled. See below lspci output. DisINTx is unset
for MSIx setup.

lspci -s 85:00.0 -vvv |grep INT |grep Control
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-

After applying this fix, driver will enable INTx Interrupt pin only
if Legacy interrupt method is required.
See below lspci output. DisINTx is set for MSIx setup.
lspci -s 85:00.0 -vvv |grep INT |grep Control
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
---
V2 changes - As Christoph Hellwig suggested, use pci_alloc_irq_vectors
with PCI_IRQ_LEGACY flag in place of pci_intx().

 drivers/scsi/megaraid/megaraid_sas_base.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 7ac9a9e..016ffce 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5034,10 +5034,12 @@ megasas_setup_irqs_msix(struct megasas_instance *instance, u8 is_probe)
 					 &instance->irq_context[j]);
 			/* Retry irq register for IO_APIC*/
 			instance->msix_vectors = 0;
-			if (is_probe)
+			if (is_probe) {
+				pci_free_irq_vectors(instance->pdev);
 				return megasas_setup_irqs_ioapic(instance);
-			else
+			} else {
 				return -1;
+			}
 		}
 	}
 	return 0;
@@ -5277,9 +5279,11 @@ static int megasas_init_fw(struct megasas_instance *instance)
 			MPI2_REPLY_POST_HOST_INDEX_OFFSET);
 	}
 
-	i = pci_alloc_irq_vectors(instance->pdev, 1, 1, PCI_IRQ_LEGACY);
-	if (i < 0)
-		goto fail_setup_irqs;
+	if (!instance->msix_vectors) {
+		i = pci_alloc_irq_vectors(instance->pdev, 1, 1, PCI_IRQ_LEGACY);
+		if (i < 0)
+			goto fail_setup_irqs;
+	}
 
 	dev_info(&instance->pdev->dev,
 		"firmware supports msix\t: (%d)", fw_msix_count);
-- 
2.8.3
