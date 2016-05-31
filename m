From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 3/5] scsi: Use pci_(request|release)_mem_regions
Date: Tue, 31 May 2016 14:05:11 +0200
Message-ID: <1123377cf09b08091957c7d1f58be1601dbfb50c.1464694724.git.jthumshirn@suse.de>
References: <cover.1464694724.git.jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1464694724.git.jthumshirn@suse.de>
In-Reply-To: <cover.1464694724.git.jthumshirn@suse.de>
References: <cover.1464694724.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
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
 drivers/scsi/lpfc/lpfc_init.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index f57d02c..75af768 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4820,17 +4820,14 @@ static void
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
-- 
1.8.5.6
