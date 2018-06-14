From: Zhouyang Jia <jiazhouyang09@gmail.com>
Subject: [PATCH v2] scsi: bfa: add error handling for pci_iomap
Date: Thu, 14 Jun 2018 19:57:39 +0800
Message-ID: <1528977459-52285-1-git-send-email-jiazhouyang09@gmail.com>
References: <1528705581-34646-1-git-send-email-jiazhouyang09@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1528705581-34646-1-git-send-email-jiazhouyang09@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Zhouyang Jia <jiazhouyang09@gmail.com>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When pci_iomap fails, the lack of error-handling code may
cause unexpected results.

This patch adds error-handling code after calling pci_iomap.

Signed-off-by: Zhouyang Jia <jiazhouyang09@gmail.com>
---
v1->v2:
- Unmap bfad->pci_bar0_kva.
---
 drivers/scsi/bfa/bfad.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index bd7e6a6f..693e180 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -760,6 +760,11 @@ bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad)
 		goto out_release_region;
 	}
 
+	if (bfad->pci_bar2_kva == NULL) {
+		printk(KERN_ERR "Fail to map bar2\n");
+		goto out_unmap_bar0;
+	}
+
 	bfad->hal_pcidev.pci_slot = PCI_SLOT(pdev->devfn);
 	bfad->hal_pcidev.pci_func = PCI_FUNC(pdev->devfn);
 	bfad->hal_pcidev.pci_bar_kva = bfad->pci_bar0_kva;
@@ -797,6 +802,8 @@ bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad)
 
 	return 0;
 
+out_unmap_bar0:
+	pci_iounmap(pdev, bfad->pci_bar0_kva);
 out_release_region:
 	pci_release_regions(pdev);
 out_disable_device:
-- 
2.7.4
