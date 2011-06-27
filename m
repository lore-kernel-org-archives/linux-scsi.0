From: Jon Mason <jdmason@kudzu.us>
Subject: [PATCH] bfa: remove redundant PCIE set MRRS logic
Date: Mon, 27 Jun 2011 11:13:10 -0500
Message-ID: <1309191190-14670-1-git-send-email-jdmason@kudzu.us>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54381 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab1F0QNP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jun 2011 12:13:15 -0400
Received: by pzk9 with SMTP id 9so3053801pzk.19
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jun 2011 09:13:15 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jing Huang <huangj@brocade.com>
Cc: linux-scsi@vger.kernel.org

bfad_pci_init has code to set the PCIe Maximum Read Request Size, but
this is unnecessary as this logic already exists in pcie_set_readrq.
Remove the redundant logic and call pcie_set_readrq.

Only compile tested.

Signed-off-by: Jon Mason <jdmason@kudzu.us>
---
 drivers/scsi/bfa/bfad.c |   47 ++---------------------------------------------
 1 files changed, 2 insertions(+), 45 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 59b5e9b..a90aafe 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -808,51 +808,8 @@ bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad)
 	bfad->pcidev = pdev;
 
 	/* Adjust PCIe Maximum Read Request Size */
-	if (pcie_max_read_reqsz > 0) {
-		int pcie_cap_reg;
-		u16 pcie_dev_ctl;
-		u16 mask = 0xffff;
-
-		switch (pcie_max_read_reqsz) {
-		case 128:
-			mask = 0x0;
-			break;
-		case 256:
-			mask = 0x1000;
-			break;
-		case 512:
-			mask = 0x2000;
-			break;
-		case 1024:
-			mask = 0x3000;
-			break;
-		case 2048:
-			mask = 0x4000;
-			break;
-		case 4096:
-			mask = 0x5000;
-			break;
-		default:
-			break;
-		}
-
-		pcie_cap_reg = pci_find_capability(pdev, PCI_CAP_ID_EXP);
-		if (mask != 0xffff && pcie_cap_reg) {
-			pcie_cap_reg += 0x08;
-			pci_read_config_word(pdev, pcie_cap_reg, &pcie_dev_ctl);
-			if ((pcie_dev_ctl & 0x7000) != mask) {
-				printk(KERN_WARNING "BFA[%s]: "
-				"pcie_max_read_request_size is %d, "
-				"reset to %d\n", bfad->pci_name,
-				(1 << ((pcie_dev_ctl & 0x7000) >> 12)) << 7,
-				pcie_max_read_reqsz);
-
-				pcie_dev_ctl &= ~0x7000;
-				pci_write_config_word(pdev, pcie_cap_reg,
-						pcie_dev_ctl | mask);
-			}
-		}
-	}
+	if (pcie_max_read_reqsz > 0)
+		pcie_set_readrq(pdev, pcie_max_read_reqsz);
 
 	return 0;
 
-- 
1.7.5.4

