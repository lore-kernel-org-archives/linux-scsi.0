From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 8/24] advansys: Rewrite resource management
Date: Fri, 27 Jul 2007 07:42:17 -0600
Message-ID: <11855437534057-git-send-email-matthew@wil.cx>
References: <20070727134038.GC21219@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:50060 "EHLO
	smtp-06.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761199AbXG0Nmf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 09:42:35 -0400
In-Reply-To: <20070727134038.GC21219@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Make sure the resources are reserved and released by all the callers of
advansys_board_found().  This eliminates the check_region-style race.
It also allows us to use the pci_request_regions() API.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |  102 ++++++++++++++++++++---------------------------
 1 files changed, 43 insertions(+), 59 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 2246b69..7dee55b 100644
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
@@ -17841,14 +17832,12 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
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
 
@@ -18329,25 +18318,6 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
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
@@ -18360,7 +18330,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 				ASC_PRINT3
 				    ("advansys_board_found: board %d: request_dma() %d failed %d\n",
 				     boardp->id, shost->dma_channel, ret);
-				goto err_free_region;
+				goto err_free_proc;
 			}
 			AscEnableIsaDma(shost->dma_channel);
 		}
@@ -18442,8 +18412,6 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
  err_free_dma:
 	if (shost->dma_channel != NO_ISA_DMA)
 		free_dma(shost->dma_channel);
- err_free_region:
-	release_region(shost->io_port, boardp->asc_n_io_port);
  err_free_proc:
 	kfree(boardp->prtbuf);
  err_unmap:
@@ -18470,9 +18438,8 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
  */
 static int __init advansys_detect(void)
 {
-	int iop;
-	int bus;
-	int ioport = 0;
+	int iop, bus, ioport = 0;
+	struct Scsi_Host *shost;
 
 	ASC_DBG(1, "advansys_detect: begin\n");
 
@@ -18521,8 +18488,7 @@ static int __init advansys_detect(void)
 			case ASC_IS_VL:
 #ifdef CONFIG_ISA
 				if (asc_iopflag == ASC_FALSE) {
-					iop =
-					    AscSearchIOPortAddr(iop,
+					iop = AscSearchIOPortAddr(iop,
 								asc_bus[bus]);
 				} else {
 					/*
@@ -18618,7 +18584,9 @@ static int __init advansys_detect(void)
 				break;
 			}
 
-			advansys_board_found(iop, NULL, asc_bus[bus]);
+			shost = advansys_board_found(iop, NULL, asc_bus[bus]);
+			if (!shost)
+				release_region(iop, ASC_IOADR_GAP);
 		}
 	}
 
@@ -18643,7 +18611,6 @@ static int advansys_release(struct Scsi_Host *shost)
 		ASC_DBG(1, "advansys_release: free_dma()\n");
 		free_dma(shost->dma_channel);
 	}
-	release_region(shost->io_port, boardp->asc_n_io_port);
 	if (ASC_WIDE_BOARD(boardp)) {
 		adv_sgblk_t *sgp = NULL;
 
@@ -18713,12 +18680,22 @@ static int __devinit advansys_eisa_probe(struct device *dev)
 
 	err = -ENODEV;
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
@@ -18742,6 +18719,7 @@ static __devexit int advansys_eisa_remove(struct device *dev)
 			continue;
 		ioport = shost->io_port;
 		advansys_remove(data->host[i]);
+		release_region(ioport, ASC_IOADR_GAP);
 	}
 
 	kfree(data);
@@ -18785,6 +18763,9 @@ advansys_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	err = pci_enable_device(pdev);
 	if (err)
 		goto fail;
+	err = pci_request_regions(pdev, "advansys");
+	if (err)
+		goto disable_device;
 
 	ioport = pci_resource_start(pdev, 0);
 	shost = advansys_board_found(ioport, &pdev->dev, ASC_IS_PCI);
@@ -18795,6 +18776,8 @@ advansys_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	err = -ENODEV;
+	pci_release_regions(pdev);
+ disable_device:
 	pci_disable_device(pdev);
  fail:
 	return err;
@@ -18803,6 +18786,7 @@ advansys_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 static void __devexit advansys_pci_remove(struct pci_dev *pdev)
 {
 	advansys_remove(pci_get_drvdata(pdev));
+	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 }
 
-- 
1.4.4.4

