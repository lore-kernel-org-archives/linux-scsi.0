From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 05/24] hpsa: factor out hpsa_find_memory_BAR
Date: Thu, 27 May 2010 15:13:07 -0500
Message-ID: <20100527201307.3116.43208.stgit@beardog.cce.hp.com>
References: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:40121 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757842Ab0E0UI2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2010 16:08:28 -0400
In-Reply-To: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, dab@hp.com, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: factor out hpsa_find_memory_BAR

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   34 +++++++++++++++++++---------------
 1 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index bea2d41..59c0101 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3293,6 +3293,23 @@ static inline bool hpsa_board_disabled(struct pci_dev *pdev)
 	return ((command & PCI_COMMAND_MEMORY) == 0);
 }
 
+static int __devinit hpsa_pci_find_memory_BAR(struct ctlr_info *h,
+	unsigned long *memory_bar)
+{
+	int i;
+
+	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++)
+		if (pci_resource_flags(h->pdev, i) & IORESOURCE_MEM) {
+			/* addressing mode bits already removed */
+			*memory_bar = pci_resource_start(h->pdev, i);
+			dev_dbg(&h->pdev->dev, "memory BAR = %lx\n",
+				*memory_bar);
+			return 0;
+		}
+	dev_warn(&h->pdev->dev, "no memory BAR found\n");
+	return -ENODEV;
+}
+
 static int __devinit hpsa_pci_init(struct ctlr_info *h)
 {
 	u32 scratchpad = 0;
@@ -3325,22 +3342,9 @@ static int __devinit hpsa_pci_init(struct ctlr_info *h)
 		return err;
 	}
 	hpsa_interrupt_mode(h);
-
-	/* find the memory BAR */
-	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
-		if (pci_resource_flags(h->pdev, i) & IORESOURCE_MEM)
-			break;
-	}
-	if (i == DEVICE_COUNT_RESOURCE) {
-		dev_warn(&h->pdev->dev, "no memory BAR found\n");
-		err = -ENODEV;
+	err = hpsa_pci_find_memory_BAR(h, &h->paddr);
+	if (err)
 		goto err_out_free_res;
-	}
-
-	h->paddr = pci_resource_start(h->pdev, i); /* addressing mode bits
-						 * already removed
-						 */
-
 	h->vaddr = remap_pci_mem(h->paddr, 0x250);
 
 	/* Wait for the board to become ready.  */

