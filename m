From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: [PATCH] megaraid_sas: enable intx only if msix request fails
Date: Thu,  2 Mar 2017 02:54:16 -0800
Message-ID: <1488452056-16083-1-git-send-email-kashyap.desai@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:35798 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751888AbdCBMkb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2017 07:40:31 -0500
Received: by mail-pf0-f171.google.com with SMTP id j5so22101535pfb.2
        for <linux-scsi@vger.kernel.org>; Thu, 02 Mar 2017 04:39:02 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, hare@suse.de, Kashyap Desai <kashyap.desai@broadcom.com>

Without this fix, driver will enable INTx Interrupt pin even
 though MSI-x vectors are enabled. See below lspci output. DisINTx is unset
 for MSIx setup.

lspci -s 85:00.0 -vvv |grep INT |grep Control
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-

After applying this fix, driver will enable INTx Interrupt pin only if Legacy interrupt method is required.
See below lspci output. DisINTx is unset for MSIx setup.
lspci -s 85:00.0 -vvv |grep INT |grep Control
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 7ac9a9e..82a8ec8 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4990,6 +4990,7 @@ int megasas_set_crash_dump_params(struct megasas_instance *instance,
 	struct pci_dev *pdev;
 
 	pdev = instance->pdev;
+	pci_intx(pdev, 1);
 	instance->irq_context[0].instance = instance;
 	instance->irq_context[0].MSIxIndex = 0;
 	if (request_irq(pci_irq_vector(pdev, 0),
@@ -5277,10 +5278,6 @@ static int megasas_init_fw(struct megasas_instance *instance)
 			MPI2_REPLY_POST_HOST_INDEX_OFFSET);
 	}
 
-	i = pci_alloc_irq_vectors(instance->pdev, 1, 1, PCI_IRQ_LEGACY);
-	if (i < 0)
-		goto fail_setup_irqs;
-
 	dev_info(&instance->pdev->dev,
 		"firmware supports msix\t: (%d)", fw_msix_count);
 	dev_info(&instance->pdev->dev,
@@ -5494,7 +5491,6 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	instance->instancet->disable_intr(instance);
 fail_init_adapter:
 	megasas_destroy_irqs(instance);
-fail_setup_irqs:
 	if (instance->msix_vectors)
 		pci_free_irq_vectors(instance->pdev);
 	instance->msix_vectors = 0;
-- 
1.8.3.1
