From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 3/9] hpsa: make hpsa_find_memory_BAR not require the per HBA
	structure.
Date: Wed, 16 Jun 2010 13:51:25 -0500
Message-ID: <20100616185125.22798.6345.stgit@beardog.cce.hp.com>
References: <20100616184510.22798.26206.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:6805 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119Ab0FPSq1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2010 14:46:27 -0400
In-Reply-To: <20100616184510.22798.26206.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: andriusb@redhat.com, James.Bottomley@HansenPartnership.com, dab@hp.com, thenzl@redhat.com, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Rationale for this is that in order to fix the hard reset code used
by kdump, we need to use this function before we even have the per
HBA structure.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 661a320..1decf16 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3313,20 +3313,20 @@ static inline bool hpsa_board_disabled(struct pci_dev *pdev)
 	return ((command & PCI_COMMAND_MEMORY) == 0);
 }
 
-static int __devinit hpsa_pci_find_memory_BAR(struct ctlr_info *h,
+static int __devinit hpsa_pci_find_memory_BAR(struct pci_dev *pdev,
 	unsigned long *memory_bar)
 {
 	int i;
 
 	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++)
-		if (pci_resource_flags(h->pdev, i) & IORESOURCE_MEM) {
+		if (pci_resource_flags(pdev, i) & IORESOURCE_MEM) {
 			/* addressing mode bits already removed */
-			*memory_bar = pci_resource_start(h->pdev, i);
-			dev_dbg(&h->pdev->dev, "memory BAR = %lx\n",
+			*memory_bar = pci_resource_start(pdev, i);
+			dev_dbg(&pdev->dev, "memory BAR = %lx\n",
 				*memory_bar);
 			return 0;
 		}
-	dev_warn(&h->pdev->dev, "no memory BAR found\n");
+	dev_warn(&pdev->dev, "no memory BAR found\n");
 	return -ENODEV;
 }
 
@@ -3503,7 +3503,7 @@ static int __devinit hpsa_pci_init(struct ctlr_info *h)
 		return err;
 	}
 	hpsa_interrupt_mode(h);
-	err = hpsa_pci_find_memory_BAR(h, &h->paddr);
+	err = hpsa_pci_find_memory_BAR(h->pdev, &h->paddr);
 	if (err)
 		goto err_out_free_res;
 	h->vaddr = remap_pci_mem(h->paddr, 0x250);

