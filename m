From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 8/21] advansys: Rewrite resource management
Date: Thu, 26 Jul 2007 13:22:44 -0400
Message-ID: <11854705773172-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:41119 "EHLO
	smtp-06.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935903AbXGZSFE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jul 2007 14:05:04 -0400
In-Reply-To: 20070726171141.GE19275@parisc-linux.org
References: 20070726171141.GE19275@parisc-linux.org
In-Reply-To: <20070726171141.GE19275@parisc-linux.org>
References: <20070726171141.GE19275@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Make sure the resources are reserved and released by all the callers of
advansys_board_found().  This eliminates the check_region-style race.
It also allows us to use the pci_request_regions() API.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |  103 +++++++++++++++++++---------------------------
 1 files changed, 43 insertions(+), 60 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 48dc28d..a4d3372 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -1935,7 +1935,6 @@ static int AscCompareString(uchar *, uchar *, int);
 #ifdef CONFIG_ISA
 static ushort AscGetEisaChipCfg(PortAddr);
 static PortAddr AscSearchIOPortAddr11(PortAddr);
-static PortAddr AscSearchIOPortAddr(PortAddr, ushort);
 static void AscSetISAPNPWaitForKey(void);
 #endif /* CONFIG_ISA */
 static uchar AscGetChipScsiCtrl(PortAddr);
@@ -8261,7 +8260,7 @@ static PortAddr _asc_def_iop_base[ASC_IOADR_TABLE_MAX_IX] __initdata = {
 };
 
 #ifdef CONFIG_ISA
-static uchar _isa_pnp_inited __initdata = 0;
+static unsigned char _isa_pnp_inited __initdata = 0;
 
 static PortAddr __init AscSearchIOPortAddr(PortAddr iop_beg, ushort bus_type)
 {
@@ -8269,12 +8268,11 @@ static PortAddr __init AscSearchIOPortAddr(PortAddr iop_beg, ushort bus_type)
 		while ((iop_beg = AscSearchIOPortAddr11(iop_beg)) != 0) {
 			if (AscGetChipVersion(iop_beg, bus_type) <=
 			    ASC_CHIP_MAX_VER_VL) {
-				return (iop_beg);
+				return iop_beg;
 			}
+			release_region(iop_beg, ASC_IOADR_GAP);
 		}
-		return (0);
-	}
-	if (bus_type & ASC_IS_ISA) {
+	} else if (bus_type & ASC_IS_ISA) {
 		if (_isa_pnp_inited == 0) {
 			AscSetISAPNPWaitForKey();
 			_isa_pnp_inited++;
@@ -8282,40 +8280,33 @@ static PortAddr __init AscSearchIOPortAddr(PortAddr iop_beg, ushort bus_type)
 		while ((iop_beg = AscSearchIOPortAddr11(iop_beg)) != 0) {
 			if ((AscGetChipVersion(iop_beg, bus_type) &
 			     ASC_CHIP_VER_ISA_BIT) != 0) {
-				return (iop_beg);
+				return iop_beg;
 			}
+			release_region(iop_beg, ASC_IOADR_GAP);
 		}
-		return (0);
 	}
-	return (0);
+	return 0;
 }
 
 static PortAddr __init AscSearchIOPortAddr11(PortAddr s_addr)
 {
 	int i;
-	PortAddr iop_base;
 
 	for (i = 0; i < ASC_IOADR_TABLE_MAX_IX; i++) {
-		if (_asc_def_iop_base[i] > s_addr) {
-			break;
-		}
-	}
-	for (; i < ASC_IOADR_TABLE_MAX_IX; i++) {
-		iop_base = _asc_def_iop_base[i];
+		PortAddr iop_base = _asc_def_iop_base[i];
+		if (iop_base <= s_addr)
+			continue;
 		if (!request_region(iop_base, ASC_IOADR_GAP, "advansys")) {
-			ASC_DBG1(1,
-				 "AscSearchIOPortAddr11: check_region() failed I/O port 0x%x\n",
-				 iop_base);
+			ASC_DBG1(1, "AscSearchIOPortAddr11: I/O port 0x%x "
+				 "in use\n", iop_base);
 			continue;
 		}
 		ASC_DBG1(1, "AscSearchIOPortAddr11: probing I/O port 0x%x\n",
 			 iop_base);
-		release_region(iop_base, ASC_IOADR_GAP);
-		if (AscFindSignature(iop_base)) {
-			return (iop_base);
-		}
+		if (AscFindSignature(iop_base))
+			return iop_base;
 	}
-	return (0);
+	return 0;
 }
 
 static void __init AscSetISAPNPWaitForKey(void)
@@ -17842,14 +17833,12 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 			     boardp->id, pci_memory_address, iolen);
 			goto err_shost;
 		}
-		ASC_DBG1(1,
-			 "advansys_board_found: ioremap_addr: 0x%lx\n",
+		ASC_DBG1(1, "advansys_board_found: ioremap_addr: 0x%lx\n",
 			 (ulong)boardp->ioremap_addr);
 		adv_dvc_varp->iop_base = (AdvPortAddr)
 		    (boardp->ioremap_addr +
 		     (pci_memory_address - (pci_memory_address & PAGE_MASK)));
-		ASC_DBG1(1,
-			 "advansys_board_found: iop_base: 0x%lx\n",
+		ASC_DBG1(1, "advansys_board_found: iop_base: 0x%lx\n",
 			 adv_dvc_varp->iop_base);
 #endif /* CONFIG_PCI */
 
@@ -18330,25 +18319,6 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 	 * Register Board Resources - I/O Port, DMA, IRQ
 	 */
 
-	/*
-	 * Register I/O port range.
-	 *
-	 * For Wide boards the I/O ports are not used to access
-	 * the board, but request the region anyway.
-	 *
-	 * 'shost->n_io_port' is not referenced, because it may be truncated.
-	 */
-	ASC_DBG2(2,
-		 "advansys_board_found: request_region port 0x%lx, len 0x%x\n",
-		 (ulong)shost->io_port, boardp->asc_n_io_port);
-	if (request_region(shost->io_port, boardp->asc_n_io_port,
-			   "advansys") == NULL) {
-		ASC_PRINT3
-		    ("advansys_board_found: board %d: request_region() failed, port 0x%lx, len 0x%x\n",
-		     boardp->id, (ulong)shost->io_port, boardp->asc_n_io_port);
-		goto err_free_proc;
-	}
-
 	/* Register DMA Channel for Narrow boards. */
 	shost->dma_channel = NO_ISA_DMA;	/* Default to no ISA DMA. */
 #ifdef CONFIG_ISA
@@ -18361,7 +18331,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 				ASC_PRINT3
 				    ("advansys_board_found: board %d: request_dma() %d failed %d\n",
 				     boardp->id, shost->dma_channel, ret);
-				goto err_free_region;
+				goto err_free_proc;
 			}
 			AscEnableIsaDma(shost->dma_channel);
 		}
@@ -18445,8 +18415,6 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
  err_free_dma:
 	if (shost->dma_channel != NO_ISA_DMA)
 		free_dma(shost->dma_channel);
- err_free_region:
-	release_region(shost->io_port, boardp->asc_n_io_port);
  err_free_proc:
 	kfree(boardp->prtbuf);
  err_unmap:
@@ -18474,9 +18442,8 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 static int __init advansys_detect(void)
 {
 	static int detect_called = ASC_FALSE;
-	int iop;
-	int bus;
-	int ioport = 0;
+	int iop, bus, ioport = 0;
+	struct Scsi_Host *shost;
 
 	if (detect_called == ASC_FALSE) {
 		detect_called = ASC_TRUE;
@@ -18533,8 +18500,7 @@ static int __init advansys_detect(void)
 			case ASC_IS_VL:
 #ifdef CONFIG_ISA
 				if (asc_iopflag == ASC_FALSE) {
-					iop =
-					    AscSearchIOPortAddr(iop,
+					iop = AscSearchIOPortAddr(iop,
 								asc_bus[bus]);
 				} else {
 					/*
@@ -18630,7 +18596,9 @@ static int __init advansys_detect(void)
 				break;
 			}
 
-			advansys_board_found(iop, NULL, asc_bus[bus]);
+			shost = advansys_board_found(iop, NULL, asc_bus[bus]);
+			if (!shost)
+				release_region(iop, ASC_IOADR_GAP);
 		}
 	}
 
@@ -18655,7 +18623,6 @@ static int advansys_release(struct Scsi_Host *shost)
 		ASC_DBG(1, "advansys_release: free_dma()\n");
 		free_dma(shost->dma_channel);
 	}
-	release_region(shost->io_port, boardp->asc_n_io_port);
 	if (ASC_WIDE_BOARD(boardp)) {
 		adv_sgblk_t *sgp = NULL;
 
@@ -18720,12 +18687,22 @@ static int __devinit advansys_eisa_probe(struct device *dev)
 	ioport = edev->base_addr + 0xc30;
 
 	for (i = 0; i < 2; i++, ioport += 0x20) {
-		if (!AscFindSignature(ioport))
+		if (!request_region(ioport, ASC_IOADR_GAP, "advansys")) {
+			printk(KERN_WARNING "Region %x-%x busy\n", ioport,
+			       ioport + ASC_IOADR_GAP - 1);
+			continue;
+		}
+		if (!AscFindSignature(ioport)) {
+			release_region(ioport, ASC_IOADR_GAP);
 			continue;
+		}
 		inw(ioport + 4);
 		data->host[i] = advansys_board_found(ioport, dev, ASC_IS_EISA);
-		if (data->host[i])
+		if (data->host[i]) {
 			err = 0;
+		} else {
+			release_region(ioport, ASC_IOADR_GAP);
+		}
 	}
 
 	if (err) {
@@ -18748,6 +18725,7 @@ static __devexit int advansys_eisa_remove(struct device *dev)
 			continue;
 		ioport = shost->io_port;
 		advansys_remove(data->host[i]);
+		release_region(ioport, ASC_IOADR_GAP);
 	}
 
 	return 0;
@@ -18787,8 +18765,10 @@ advansys_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int ioport;
 	struct Scsi_Host *shost;
 
-	if (pci_enable_device(pdev))
+	if (pci_request_regions(pdev, "advansys"))
 		goto fail;
+	if (pci_enable_device(pdev))
+		goto release_regions;
 
 	ioport = pci_resource_start(pdev, 0);
 	shost = advansys_board_found(ioport, &pdev->dev, ASC_IS_PCI);
@@ -18799,6 +18779,8 @@ advansys_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	pci_disable_device(pdev);
+ release_regions:
+	pci_release_regions(pdev);
  fail:
 	return -ENODEV;
 }
@@ -18807,6 +18789,7 @@ static void __devexit advansys_pci_remove(struct pci_dev *pdev)
 {
 	advansys_remove(pci_get_drvdata(pdev));
 	pci_disable_device(pdev);
+	pci_release_regions(pdev);
 }
 
 static struct pci_driver advansys_pci_driver = {
-- 
1.4.4.4

