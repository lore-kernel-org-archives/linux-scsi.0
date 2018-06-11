From: Zhouyang Jia <jiazhouyang09@gmail.com>
Subject: [PATCH] scsi: bfa: add error handling for pci_iomap
Date: Mon, 11 Jun 2018 16:26:21 +0800
Message-ID: <1528705581-34646-1-git-send-email-jiazhouyang09@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Zhouyang Jia <jiazhouyang09@gmail.com>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When pci_iomap fails, the lack of error-handling code may
cause unexpected results.

This patch adds error-handling code after calling pci_iomap.

Signed-off-by: Zhouyang Jia <jiazhouyang09@gmail.com>
---
 drivers/scsi/bfa/bfad.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index bd7e6a6f..74e39d7 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -760,6 +760,11 @@ bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad)
 		goto out_release_region;
 	}
 
+	if (bfad->pci_bar2_kva == NULL) {
+		printk(KERN_ERR "Fail to map bar2\n");
+		goto out_release_region;
+	}
+
 	bfad->hal_pcidev.pci_slot = PCI_SLOT(pdev->devfn);
 	bfad->hal_pcidev.pci_func = PCI_FUNC(pdev->devfn);
 	bfad->hal_pcidev.pci_bar_kva = bfad->pci_bar0_kva;
-- 
2.7.4
