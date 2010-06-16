From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 4/9] hpsa: factor out hpsa_find_cfg_addrs.
Date: Wed, 16 Jun 2010 13:51:30 -0500
Message-ID: <20100616185130.22798.45439.stgit@beardog.cce.hp.com>
References: <20100616184510.22798.26206.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:3346 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119Ab0FPSqc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2010 14:46:32 -0400
In-Reply-To: <20100616184510.22798.26206.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: andriusb@redhat.com, James.Bottomley@HansenPartnership.com, dab@hp.com, thenzl@redhat.com, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Rationale for this is that I will also need to use this code
in fixing kdump host reset code prior to having the hba structure.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   34 ++++++++++++++++++++++------------
 1 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 1decf16..67439c1 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3345,29 +3345,39 @@ static int __devinit hpsa_wait_for_board_ready(struct ctlr_info *h)
 	return -ENODEV;
 }
 
+static int __devinit hpsa_find_cfg_addrs(struct pci_dev *pdev,
+	void __iomem *vaddr, u32 *cfg_base_addr, u64 *cfg_base_addr_index,
+	u64 *cfg_offset)
+{
+	*cfg_base_addr = readl(vaddr + SA5_CTCFG_OFFSET);
+	*cfg_offset = readl(vaddr + SA5_CTMEM_OFFSET);
+	*cfg_base_addr &= (u32) 0x0000ffff;
+	*cfg_base_addr_index = find_PCI_BAR_index(pdev, *cfg_base_addr);
+	if (*cfg_base_addr_index == -1) {
+		dev_warn(&pdev->dev, "cannot find cfg_base_addr_index\n");
+		return -ENODEV;
+	}
+	return 0;
+}
+
 static int __devinit hpsa_find_cfgtables(struct ctlr_info *h)
 {
 	u64 cfg_offset;
 	u32 cfg_base_addr;
 	u64 cfg_base_addr_index;
 	u32 trans_offset;
+	int rc;
 
-	/* get the address index number */
-	cfg_base_addr = readl(h->vaddr + SA5_CTCFG_OFFSET);
-	cfg_base_addr &= (u32) 0x0000ffff;
-	cfg_base_addr_index = find_PCI_BAR_index(h->pdev, cfg_base_addr);
-	if (cfg_base_addr_index == -1) {
-		dev_warn(&h->pdev->dev, "cannot find cfg_base_addr_index\n");
-		return -ENODEV;
-	}
-	cfg_offset = readl(h->vaddr + SA5_CTMEM_OFFSET);
+	rc = hpsa_find_cfg_addrs(h->pdev, h->vaddr, &cfg_base_addr,
+		&cfg_base_addr_index, &cfg_offset);
+	if (rc)
+		return rc;
 	h->cfgtable = remap_pci_mem(pci_resource_start(h->pdev,
-			       cfg_base_addr_index) + cfg_offset,
-				sizeof(h->cfgtable));
+		       cfg_base_addr_index) + cfg_offset, sizeof(*h->cfgtable));
 	if (!h->cfgtable)
 		return -ENOMEM;
 	/* Find performant mode table. */
-	trans_offset = readl(&(h->cfgtable->TransMethodOffset));
+	trans_offset = readl(&h->cfgtable->TransMethodOffset);
 	h->transtable = remap_pci_mem(pci_resource_start(h->pdev,
 				cfg_base_addr_index)+cfg_offset+trans_offset,
 				sizeof(*h->transtable));

