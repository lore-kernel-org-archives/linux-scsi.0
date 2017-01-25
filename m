From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH V2 01/24] aacraid: Remove duplicate irq management code
Date: Wed, 25 Jan 2017 10:00:48 -0800
Message-ID: <20170125180111.25401-2-RaghavaAditya.Renukunta@microsemi.com>
References: <20170125180111.25401-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0043.outbound.protection.outlook.com ([104.47.36.43]:18784
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751839AbdAZAh6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Jan 2017 19:37:58 -0500
In-Reply-To: <20170125180111.25401-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, RaghavaAditya.Renukunta@microsemi.com, Scott.Benesh@microsemi.com

Removed duplicate code that for acquiring and releasing irqs

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>

---
 Changes in  V2:
  None

 drivers/scsi/aacraid/linit.c | 58 +++-----------------------------------------
 1 file changed, 3 insertions(+), 55 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 3ecbf20..fd26a2d 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1327,35 +1327,12 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 static void aac_release_resources(struct aac_dev *aac)
 {
-	int i;
-
 	aac_adapter_disable_int(aac);
-	if (aac->pdev->device == PMC_DEVICE_S6 ||
-	    aac->pdev->device == PMC_DEVICE_S7 ||
-	    aac->pdev->device == PMC_DEVICE_S8 ||
-	    aac->pdev->device == PMC_DEVICE_S9) {
-		if (aac->max_msix > 1) {
-			for (i = 0; i < aac->max_msix; i++)
-				free_irq(pci_irq_vector(aac->pdev, i),
-					&(aac->aac_msix[i]));
-		} else {
-			free_irq(aac->pdev->irq, &(aac->aac_msix[0]));
-		}
-	} else {
-		free_irq(aac->pdev->irq, aac);
-	}
-	if (aac->msi)
-		pci_disable_msi(aac->pdev);
-	else if (aac->max_msix > 1)
-		pci_disable_msix(aac->pdev);
-
+	aac_free_irq(aac);
 }
 
 static int aac_acquire_resources(struct aac_dev *dev)
 {
-	int i, j;
-	int instance = dev->id;
-	const char *name = dev->name;
 	unsigned long status;
 	/*
 	 *	First clear out all interrupts.  Then enable the one's that we
@@ -1377,37 +1354,8 @@ static int aac_acquire_resources(struct aac_dev *dev)
 	if (dev->msi_enabled)
 		aac_src_access_devreg(dev, AAC_ENABLE_MSIX);
 
-	if (!dev->sync_mode && dev->msi_enabled && dev->max_msix > 1) {
-		for (i = 0; i < dev->max_msix; i++) {
-			dev->aac_msix[i].vector_no = i;
-			dev->aac_msix[i].dev = dev;
-
-			if (request_irq(pci_irq_vector(dev->pdev, i),
-					dev->a_ops.adapter_intr,
-					0, "aacraid", &(dev->aac_msix[i]))) {
-				printk(KERN_ERR "%s%d: Failed to register IRQ for vector %d.\n",
-						name, instance, i);
-				for (j = 0 ; j < i ; j++)
-					free_irq(pci_irq_vector(dev->pdev, j),
-						 &(dev->aac_msix[j]));
-				pci_disable_msix(dev->pdev);
-				goto error_iounmap;
-			}
-		}
-	} else {
-		dev->aac_msix[0].vector_no = 0;
-		dev->aac_msix[0].dev = dev;
-
-		if (request_irq(dev->pdev->irq, dev->a_ops.adapter_intr,
-			IRQF_SHARED, "aacraid",
-			&(dev->aac_msix[0])) < 0) {
-			if (dev->msi)
-				pci_disable_msi(dev->pdev);
-			printk(KERN_ERR "%s%d: Interrupt unavailable.\n",
-					name, instance);
-			goto error_iounmap;
-		}
-	}
+	if (aac_acquire_irq(dev))
+		goto error_iounmap;
 
 	aac_adapter_enable_int(dev);
 
-- 
2.7.4

