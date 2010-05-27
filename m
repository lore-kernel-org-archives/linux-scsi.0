From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 07/24] hpsa: factor out hpsa_find_cfgtables
Date: Thu, 27 May 2010 15:13:17 -0500
Message-ID: <20100527201317.3116.58539.stgit@beardog.cce.hp.com>
References: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:27139 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759332Ab0E0UIi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2010 16:08:38 -0400
In-Reply-To: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, dab@hp.com, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: factor out hpsa_find_cfgtables

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   50 ++++++++++++++++++++++++++++++--------------------
 1 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 12b1625..3ed0fd7 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3325,12 +3325,39 @@ static int __devinit hpsa_wait_for_board_ready(struct ctlr_info *h)
 	return -ENODEV;
 }
 
-static int __devinit hpsa_pci_init(struct ctlr_info *h)
+static int __devinit hpsa_find_cfgtables(struct ctlr_info *h)
 {
 	u64 cfg_offset;
 	u32 cfg_base_addr;
 	u64 cfg_base_addr_index;
 	u32 trans_offset;
+
+	/* get the address index number */
+	cfg_base_addr = readl(h->vaddr + SA5_CTCFG_OFFSET);
+	cfg_base_addr &= (u32) 0x0000ffff;
+	cfg_base_addr_index = find_PCI_BAR_index(h->pdev, cfg_base_addr);
+	if (cfg_base_addr_index == -1) {
+		dev_warn(&h->pdev->dev, "cannot find cfg_base_addr_index\n");
+		return -ENODEV;
+	}
+	cfg_offset = readl(h->vaddr + SA5_CTMEM_OFFSET);
+	h->cfgtable = remap_pci_mem(pci_resource_start(h->pdev,
+			       cfg_base_addr_index) + cfg_offset,
+				sizeof(h->cfgtable));
+	if (!h->cfgtable)
+		return -ENOMEM;
+	/* Find performant mode table. */
+	trans_offset = readl(&(h->cfgtable->TransMethodOffset));
+	h->transtable = remap_pci_mem(pci_resource_start(h->pdev,
+				cfg_base_addr_index)+cfg_offset+trans_offset,
+				sizeof(*h->transtable));
+	if (!h->transtable)
+		return -ENOMEM;
+	return 0;
+}
+
+static int __devinit hpsa_pci_init(struct ctlr_info *h)
+{
 	int i, prod_index, err;
 
 	prod_index = hpsa_lookup_board_id(h->pdev, &h->board_id);
@@ -3364,26 +3391,9 @@ static int __devinit hpsa_pci_init(struct ctlr_info *h)
 	err = hpsa_wait_for_board_ready(h);
 	if (err)
 		goto err_out_free_res;
-
-	/* get the address index number */
-	cfg_base_addr = readl(h->vaddr + SA5_CTCFG_OFFSET);
-	cfg_base_addr &= (u32) 0x0000ffff;
-	cfg_base_addr_index = find_PCI_BAR_index(h->pdev, cfg_base_addr);
-	if (cfg_base_addr_index == -1) {
-		dev_warn(&h->pdev->dev, "cannot find cfg_base_addr_index\n");
-		err = -ENODEV;
+	err = hpsa_find_cfgtables(h);
+	if (err)
 		goto err_out_free_res;
-	}
-
-	cfg_offset = readl(h->vaddr + SA5_CTMEM_OFFSET);
-	h->cfgtable = remap_pci_mem(pci_resource_start(h->pdev,
-			       cfg_base_addr_index) + cfg_offset,
-				sizeof(h->cfgtable));
-	/* Find performant mode table. */
-	trans_offset = readl(&(h->cfgtable->TransMethodOffset));
-	h->transtable = remap_pci_mem(pci_resource_start(h->pdev,
-				cfg_base_addr_index)+cfg_offset+trans_offset,
-				sizeof(*h->transtable));
 
 	h->max_commands = readl(&(h->cfgtable->MaxPerformantModeCommands));
 	h->maxsgentries = readl(&(h->cfgtable->MaxScatterGatherElements));

