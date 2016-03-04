From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 1/7] cxlflash: Simplify PCI registration
Date: Fri,  4 Mar 2016 15:55:14 -0600
Message-ID: <1457128520-53056-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1457128424-53017-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e17.ny.us.ibm.com ([129.33.205.207]:42994 "EHLO
	e17.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758796AbcCDV5S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Mar 2016 16:57:18 -0500
Received: from localhost
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
	Fri, 4 Mar 2016 16:57:17 -0500
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 4F000C90027
	for <linux-scsi@vger.kernel.org>; Fri,  4 Mar 2016 16:57:12 -0500 (EST)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u24LvFe031850542
	for <linux-scsi@vger.kernel.org>; Fri, 4 Mar 2016 21:57:15 GMT
Received: from d01av05.pok.ibm.com (localhost [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u24LqtXp028522
	for <linux-scsi@vger.kernel.org>; Fri, 4 Mar 2016 16:52:58 -0500
In-Reply-To: <1457128424-53017-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

The calls to pci_request_regions(), pci_resource_start(),
pci_set_dma_mask(), pci_set_master() and pci_save_state() are all
unnecessary for the IBM CXL flash adapter since data buffers
are not required to be mapped to the device's memory.

The use of services such as pci_set_dma_mask() are problematic on
hypervisor managed systems as the IBM CXL flash adapter is operating
under a virtual PCI Host Bridge (virtual PHB) which does not support
these services.

cxlflash 0001:00:00.0: init_pci: Failed to set PCI DMA mask rc=-5

The resolution is to simplify init_pci(), to a point where it does the
bare minimum (pci_enable_device). Similarly, remove the call the
pci_release_regions() from cxlflash_remove().

Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 54 +-------------------------------------------
 1 file changed, 1 insertion(+), 53 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index f6d90ce..3dbb9fa 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -767,7 +767,6 @@ static void cxlflash_remove(struct pci_dev *pdev)
 		cancel_work_sync(&cfg->work_q);
 		term_afu(cfg);
 	case INIT_STATE_PCI:
-		pci_release_regions(cfg->dev);
 		pci_disable_device(pdev);
 	case INIT_STATE_NONE:
 		free_mem(cfg);
@@ -840,15 +839,6 @@ static int init_pci(struct cxlflash_cfg *cfg)
 	struct pci_dev *pdev = cfg->dev;
 	int rc = 0;
 
-	cfg->cxlflash_regs_pci = pci_resource_start(pdev, 0);
-	rc = pci_request_regions(pdev, CXLFLASH_NAME);
-	if (rc < 0) {
-		dev_err(&pdev->dev,
-			"%s: Couldn't register memory range of registers\n",
-			__func__);
-		goto out;
-	}
-
 	rc = pci_enable_device(pdev);
 	if (rc || pci_channel_offline(pdev)) {
 		if (pci_channel_offline(pdev)) {
@@ -860,55 +850,13 @@ static int init_pci(struct cxlflash_cfg *cfg)
 			dev_err(&pdev->dev, "%s: Cannot enable adapter\n",
 				__func__);
 			cxlflash_wait_for_pci_err_recovery(cfg);
-			goto out_release_regions;
-		}
-	}
-
-	rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
-	if (rc < 0) {
-		dev_dbg(&pdev->dev, "%s: Failed to set 64 bit PCI DMA mask\n",
-			__func__);
-		rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
-	}
-
-	if (rc < 0) {
-		dev_err(&pdev->dev, "%s: Failed to set PCI DMA mask\n",
-			__func__);
-		goto out_disable;
-	}
-
-	pci_set_master(pdev);
-
-	if (pci_channel_offline(pdev)) {
-		cxlflash_wait_for_pci_err_recovery(cfg);
-		if (pci_channel_offline(pdev)) {
-			rc = -EIO;
-			goto out_msi_disable;
+			goto out;
 		}
 	}
 
-	rc = pci_save_state(pdev);
-
-	if (rc != PCIBIOS_SUCCESSFUL) {
-		dev_err(&pdev->dev, "%s: Failed to save PCI config space\n",
-			__func__);
-		rc = -EIO;
-		goto cleanup_nolog;
-	}
-
 out:
 	pr_debug("%s: returning rc=%d\n", __func__, rc);
 	return rc;
-
-cleanup_nolog:
-out_msi_disable:
-	cxlflash_wait_for_pci_err_recovery(cfg);
-out_disable:
-	pci_disable_device(pdev);
-out_release_regions:
-	pci_release_regions(pdev);
-	goto out;
-
 }
 
 /**
-- 
2.1.0

