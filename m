From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 02/24] hpsa: factor out hpsa_lookup_board_id
Date: Thu, 27 May 2010 15:12:52 -0500
Message-ID: <20100527201252.3116.24227.stgit@beardog.cce.hp.com>
References: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:30384 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757120Ab0E0UIN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2010 16:08:13 -0400
In-Reply-To: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, dab@hp.com, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: factor out hpsa_lookup_board_id

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   58 +++++++++++++++++++++++++++------------------------
 1 files changed, 31 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index d3c7c4b..0d6a088 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3264,37 +3264,44 @@ default_int_mode:
 	h->intr[PERF_MODE_INT] = h->pdev->irq;
 }
 
+static int __devinit hpsa_lookup_board_id(struct pci_dev *pdev, u32 *board_id)
+{
+	int i;
+	u32 subsystem_vendor_id, subsystem_device_id;
+
+	subsystem_vendor_id = pdev->subsystem_vendor;
+	subsystem_device_id = pdev->subsystem_device;
+	*board_id = ((subsystem_device_id << 16) & 0xffff0000) |
+		    subsystem_vendor_id;
+
+	for (i = 0; i < ARRAY_SIZE(products); i++)
+		if (*board_id == products[i].board_id)
+			return i;
+
+	if (subsystem_vendor_id != PCI_VENDOR_ID_HP || !hpsa_allow_any) {
+		dev_warn(&pdev->dev, "unrecognized board ID: "
+			"0x%08x, ignoring.\n", *board_id);
+			return -ENODEV;
+	}
+	return ARRAY_SIZE(products) - 1; /* generic unknown smart array */
+}
+
 static int __devinit hpsa_pci_init(struct ctlr_info *h)
 {
-	ushort subsystem_vendor_id, subsystem_device_id, command;
-	u32 board_id, scratchpad = 0;
+	ushort command;
+	u32 scratchpad = 0;
 	u64 cfg_offset;
 	u32 cfg_base_addr;
 	u64 cfg_base_addr_index;
 	u32 trans_offset;
 	int i, prod_index, err;
 
-	subsystem_vendor_id = h->pdev->subsystem_vendor;
-	subsystem_device_id = h->pdev->subsystem_device;
-	board_id = (((u32) (subsystem_device_id << 16) & 0xffff0000) |
-		    subsystem_vendor_id);
-
-	for (i = 0; i < ARRAY_SIZE(products); i++)
-		if (board_id == products[i].board_id)
-			break;
-
-	prod_index = i;
+	prod_index = hpsa_lookup_board_id(h->pdev, &h->board_id);
+	if (prod_index < 0)
+		return -ENODEV;
+	h->product_name = products[prod_index].product_name;
+	h->access = *(products[prod_index].access);
 
-	if (prod_index == ARRAY_SIZE(products)) {
-		prod_index--;
-		if (subsystem_vendor_id != PCI_VENDOR_ID_HP ||
-				!hpsa_allow_any) {
-			dev_warn(&h->pdev->dev, "unrecognized board ID:"
-				" 0x%08lx, ignoring.\n",
-				(unsigned long) board_id);
-			return -ENODEV;
-		}
-	}
 	/* check to see if controller has been disabled
 	 * BEFORE trying to enable it
 	 */
@@ -3320,7 +3327,7 @@ static int __devinit hpsa_pci_init(struct ctlr_info *h)
 	/* If the kernel supports MSI/MSI-X we will try to enable that,
 	 * else we use the IO-APIC interrupt assigned to us by system ROM.
 	 */
-	hpsa_interrupt_mode(h, board_id);
+	hpsa_interrupt_mode(h, h->board_id);
 
 	/* find the memory BAR */
 	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
@@ -3372,7 +3379,6 @@ static int __devinit hpsa_pci_init(struct ctlr_info *h)
 				cfg_base_addr_index)+cfg_offset+trans_offset,
 				sizeof(*h->transtable));
 
-	h->board_id = board_id;
 	h->max_commands = readl(&(h->cfgtable->MaxPerformantModeCommands));
 	h->maxsgentries = readl(&(h->cfgtable->MaxScatterGatherElements));
 
@@ -3391,8 +3397,6 @@ static int __devinit hpsa_pci_init(struct ctlr_info *h)
 		h->chainsize = 0;
 	}
 
-	h->product_name = products[prod_index].product_name;
-	h->access = *(products[prod_index].access);
 	/* Allow room for some ioctls */
 	h->nr_cmds = h->max_commands - 4;
 
@@ -3418,7 +3422,7 @@ static int __devinit hpsa_pci_init(struct ctlr_info *h)
 	 * An ASIC bug may result in a prefetch beyond
 	 * physical memory.
 	 */
-	if (board_id == 0x3225103C) {
+	if (h->board_id == 0x3225103C) {
 		u32 dma_prefetch;
 		dma_prefetch = readl(h->vaddr + I2O_DMA1_CFG);
 		dma_prefetch |= 0x8000;

