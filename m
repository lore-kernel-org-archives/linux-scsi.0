From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v2 3/6] lpfc: Use pci_(request|release)_mem_regions
Date: Thu,  2 Jun 2016 09:30:31 +0200
Message-ID: <51b9bf3879e440da6c34094dfd1ee765f94f51c3.1464795082.git.jthumshirn@suse.de>
References: <cover.1464795082.git.jthumshirn@suse.de>
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <cover.1464795082.git.jthumshirn@suse.de>
In-Reply-To: <cover.1464795082.git.jthumshirn@suse.de>
References: <cover.1464795082.git.jthumshirn@suse.de>
Sender: linux-pci-owner@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Johannes Thumshirn <jthumshirn@suse.de>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Now that we do have pci_request_mem_regions() and pci_release_mem_regions() at
hand, use it in the lpfc driver.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Cc: James Smart <james.smart@avagotech.com>
Cc: Dick Kennedy <dick.kennedy@avagotech.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/scsi/lpfc/lpfc_init.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index f57d02c..a8735f7 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4775,20 +4775,17 @@ static int
 lpfc_enable_pci_dev(struct lpfc_hba *phba)
 {
 	struct pci_dev *pdev;
-	int bars = 0;
 
 	/* Obtain PCI device reference */
 	if (!phba->pcidev)
 		goto out_error;
 	else
 		pdev = phba->pcidev;
-	/* Select PCI BARs */
-	bars = pci_select_bars(pdev, IORESOURCE_MEM);
 	/* Enable PCI device */
 	if (pci_enable_device_mem(pdev))
 		goto out_error;
 	/* Request PCI resource for the device */
-	if (pci_request_selected_regions(pdev, bars, LPFC_DRIVER_NAME))
+	if (pci_request_mem_regions(pdev, LPFC_DRIVER_NAME))
 		goto out_disable_device;
 	/* Set up device as PCI master and save state for EEH */
 	pci_set_master(pdev);
@@ -4805,7 +4802,7 @@ out_disable_device:
 	pci_disable_device(pdev);
 out_error:
 	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-			"1401 Failed to enable pci device, bars:x%x\n", bars);
+			"1401 Failed to enable pci device\n");
 	return -ENODEV;
 }
 
@@ -4820,17 +4817,14 @@ static void
 lpfc_disable_pci_dev(struct lpfc_hba *phba)
 {
 	struct pci_dev *pdev;
-	int bars;
 
 	/* Obtain PCI device reference */
 	if (!phba->pcidev)
 		return;
 	else
 		pdev = phba->pcidev;
-	/* Select PCI BARs */
-	bars = pci_select_bars(pdev, IORESOURCE_MEM);
 	/* Release PCI resource and disable PCI device */
-	pci_release_selected_regions(pdev, bars);
+	pci_release_mem_regions(pdev);
 	pci_disable_device(pdev);
 
 	return;
@@ -9705,7 +9699,6 @@ lpfc_pci_remove_one_s3(struct pci_dev *pdev)
 	struct lpfc_vport **vports;
 	struct lpfc_hba   *phba = vport->phba;
 	int i;
-	int bars = pci_select_bars(pdev, IORESOURCE_MEM);
 
 	spin_lock_irq(&phba->hbalock);
 	vport->load_flag |= FC_UNLOADING;
@@ -9780,7 +9773,7 @@ lpfc_pci_remove_one_s3(struct pci_dev *pdev)
 
 	lpfc_hba_free(phba);
 
-	pci_release_selected_regions(pdev, bars);
+	pci_release_mem_regions(pdev);
 	pci_disable_device(pdev);
 }
 
-- 
1.8.5.6
