From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 15/21] advansys: ioremap no longer needs page-aligned addresses
Date: Thu, 26 Jul 2007 13:22:51 -0400
Message-ID: <11854705773192-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:51157 "EHLO
	mail-06.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933760AbXGZRvu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jul 2007 13:51:50 -0400
In-Reply-To: 20070726171141.GE19275@parisc-linux.org
References: 20070726171141.GE19275@parisc-linux.org
In-Reply-To: <20070726171141.GE19275@parisc-linux.org>
References: <20070726171141.GE19275@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

At some point during Linux 2.1 development, ioremap() gained the ability
to handle addresses which weren't page-aligned.  Also expand the CONFIG_PCI
range to encompass that entire section of wide board initialisation, since
all wide boards are PCI.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |   52 ++++++++++------------------------------------
 1 files changed, 12 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 8df7542..acd4055 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -17237,8 +17237,6 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 	ADV_DVC_VAR *adv_dvc_varp = NULL;
 	adv_sgblk_t *sgp;
 	int share_irq;
-	int iolen = 0;
-	ADV_PADDR pci_memory_address;
 	int warn_code, err_code;
 	int ret;
 
@@ -17286,13 +17284,13 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 		asc_dvc_varp->iop_base = iop;
 		asc_dvc_varp->isr_callback = asc_isr_callback;
 	} else {
+#ifdef CONFIG_PCI
 		ASC_DBG(1, "advansys_board_found: wide board\n");
 		adv_dvc_varp = &boardp->dvc_var.adv_dvc_var;
 		adv_dvc_varp->drv_ptr = boardp;
 		adv_dvc_varp->cfg = &boardp->dvc_cfg.adv_dvc_cfg;
 		adv_dvc_varp->isr_callback = adv_isr_callback;
 		adv_dvc_varp->async_callback = adv_async_callback;
-#ifdef CONFIG_PCI
 		if (pdev->device == PCI_DEVICE_ID_ASP_ABP940UW) {
 			ASC_DBG(1, "advansys_board_found: ASC-3550\n");
 			adv_dvc_varp->chip_type = ADV_CHIP_ASC3550;
@@ -17303,46 +17301,20 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 			ASC_DBG(1, "advansys_board_found: ASC-38C1600\n");
 			adv_dvc_varp->chip_type = ADV_CHIP_ASC38C1600;
 		}
-#endif /* CONFIG_PCI */
 
-		/*
-		 * Map the board's registers into virtual memory for
-		 * PCI slave access. Only memory accesses are used to
-		 * access the board's registers.
-		 *
-		 * Note: The PCI register base address is not always
-		 * page aligned, but the address passed to ioremap()
-		 * must be page aligned. It is guaranteed that the
-		 * PCI register base address will not cross a page
-		 * boundary.
-		 */
-		if (adv_dvc_varp->chip_type == ADV_CHIP_ASC3550) {
-			iolen = ADV_3550_IOLEN;
-		} else if (adv_dvc_varp->chip_type == ADV_CHIP_ASC38C0800) {
-			iolen = ADV_38C0800_IOLEN;
-		} else {
-			iolen = ADV_38C1600_IOLEN;
-		}
-#ifdef CONFIG_PCI
-		pci_memory_address = pci_resource_start(pdev, 1);
-		ASC_DBG1(1,
-			 "advansys_board_found: pci_memory_address: 0x%lx\n",
-			 (ulong)pci_memory_address);
-		if ((boardp->ioremap_addr =
-		     ioremap(pci_memory_address & PAGE_MASK, PAGE_SIZE)) == 0) {
+		boardp->asc_n_io_port = pci_resource_len(pdev, 1);
+		boardp->ioremap_addr = ioremap(pci_resource_start(pdev, 1),
+					       boardp->asc_n_io_port);
+		if (!boardp->ioremap_addr) {
 			ASC_PRINT3
 			    ("advansys_board_found: board %d: ioremap(%x, %d) returned NULL\n",
-			     boardp->id, pci_memory_address, iolen);
+			     boardp->id, pci_resource_start(pdev, 1),
+			     boardp->asc_n_io_port);
 			goto err_shost;
 		}
-		ASC_DBG1(1, "advansys_board_found: ioremap_addr: 0x%lx\n",
-			 (ulong)boardp->ioremap_addr);
-		adv_dvc_varp->iop_base = (AdvPortAddr)
-		    (boardp->ioremap_addr +
-		     (pci_memory_address - (pci_memory_address & PAGE_MASK)));
+		adv_dvc_varp->iop_base = (AdvPortAddr)boardp->ioremap_addr
 		ASC_DBG1(1, "advansys_board_found: iop_base: 0x%lx\n",
 			 adv_dvc_varp->iop_base);
-#endif /* CONFIG_PCI */
 
 		/*
 		 * Even though it isn't used to access wide boards, other
@@ -17351,9 +17323,10 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 		 */
 		boardp->ioport = iop;
 
-		ASC_DBG2(1,
-			 "advansys_board_found: iopb_chip_id_1 0x%x, iopw_chip_id_0 0x%x\n",
-			 (ushort)inp(iop + 1), (ushort)inpw(iop));
+		ASC_DBG2(1, "advansys_board_found: iopb_chip_id_1 0x%x, "
+			 "iopw_chip_id_0 0x%x\n", (ushort)inp(iop + 1),
+			 (ushort)inpw(iop));
+#endif /* CONFIG_PCI */
 	}
 
 #ifdef CONFIG_PROC_FS
@@ -17706,7 +17679,6 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 		 * PCI Memory Mapped I/O.
 		 */
 		shost->io_port = iop;
-		boardp->asc_n_io_port = iolen;
 
 		shost->this_id = adv_dvc_varp->chip_scsi_id;
 
-- 
1.4.4.4

