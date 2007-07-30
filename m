From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 10/23] advansys: Update resource management
Date: Mon, 30 Jul 2007 10:56:55 -0600
Message-ID: <11858146282332-git-send-email-matthew@wil.cx>
References: <20070730165508.GH21219@parisc-linux.org> <11858146283240-git-send-email-matthew@wil.cx> <1185814628978-git-send-email-matthew@wil.cx> <11858146282602-git-send-email-matthew@wil.cx> <11858146283106-git-send-email-matthew@wil.cx> <11858146282252-git-send-email-matthew@wil.cx> <11858146281790-git-send-email-matthew@wil.cx> <11858146281215-git-send-email-matthew@wil.cx> <11858146282469-git-send-email-matthew@wil.cx> <11858146281137-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:59939 "EHLO
	mail-08.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936769AbXG3Q5K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jul 2007 12:57:10 -0400
In-Reply-To: <11858146281137-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Make sure the resources are reserved and released by all the callers of
advansys_board_found().  This eliminates the check_region-style race.
It also allows us to use the pci_request_regions() API.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |   70 ++++++++++++++++++++++-------------------------
 1 files changed, 33 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index eda41f2..d51ca86 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -17681,14 +17681,12 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
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
 
@@ -18169,25 +18167,6 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
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
@@ -18200,7 +18179,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 				ASC_PRINT3
 				    ("advansys_board_found: board %d: request_dma() %d failed %d\n",
 				     boardp->id, shost->dma_channel, ret);
-				goto err_free_region;
+				goto err_free_proc;
 			}
 			AscEnableIsaDma(shost->dma_channel);
 		}
@@ -18266,8 +18245,6 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
  err_free_dma:
 	if (shost->dma_channel != NO_ISA_DMA)
 		free_dma(shost->dma_channel);
- err_free_region:
-	release_region(shost->io_port, boardp->asc_n_io_port);
  err_free_proc:
 	kfree(boardp->prtbuf);
  err_unmap:
@@ -18295,7 +18272,6 @@ static int advansys_release(struct Scsi_Host *shost)
 		ASC_DBG(1, "advansys_release: free_dma()\n");
 		free_dma(shost->dma_channel);
 	}
-	release_region(shost->io_port, boardp->asc_n_io_port);
 	if (ASC_WIDE_BOARD(boardp)) {
 		iounmap(boardp->ioremap_addr);
 		advansys_wide_free_mem(boardp);
@@ -18317,19 +18293,17 @@ static int __devinit advansys_isa_probe(struct device *dev, unsigned int id)
 	struct Scsi_Host *shost;
 
 	if (!request_region(iop_base, ASC_IOADR_GAP, "advansys")) {
-		ASC_DBG1(1, "advansys_isa_match: check_region() failed "
-			 "I/O port 0x%x\n", iop_base);
+		ASC_DBG1(1, "advansys_isa_match: I/O port 0x%x busy\n",
+			 iop_base);
 		return -ENODEV;
 	}
 	ASC_DBG1(1, "advansys_isa_match: probing I/O port 0x%x\n", iop_base);
-	release_region(iop_base, ASC_IOADR_GAP);
 	if (!AscFindSignature(iop_base))
 		goto nodev;
 	if (!(AscGetChipVersion(iop_base, ASC_IS_ISA) & ASC_CHIP_VER_ISA_BIT))
 		goto nodev;
 
 	shost = advansys_board_found(iop_base, dev, ASC_IS_ISA);
-
 	if (!shost)
 		goto nodev;
 
@@ -18337,12 +18311,15 @@ static int __devinit advansys_isa_probe(struct device *dev, unsigned int id)
 	return 0;
 
  nodev:
+	release_region(iop_base, ASC_IOADR_GAP);
 	return -ENODEV;
 }
 
 static int __devexit advansys_isa_remove(struct device *dev, unsigned int id)
 {
+	int ioport = _asc_def_iop_base[id];
 	advansys_release(dev_get_drvdata(dev));
+	release_region(ioport, ASC_IOADR_GAP);
 	return 0;
 }
 
@@ -18361,12 +18338,11 @@ static int __devinit advansys_vlb_probe(struct device *dev, unsigned int id)
 	struct Scsi_Host *shost;
 
 	if (!request_region(iop_base, ASC_IOADR_GAP, "advansys")) {
-		ASC_DBG1(1, "advansys_vlb_match: check_region() failed "
-			 "I/O port 0x%x\n", iop_base);
+		ASC_DBG1(1, "advansys_vlb_match: I/O port 0x%x busy\n",
+			 iop_base);
 		return -ENODEV;
 	}
 	ASC_DBG1(1, "advansys_vlb_match: probing I/O port 0x%x\n", iop_base);
-	release_region(iop_base, ASC_IOADR_GAP);
 	if (!AscFindSignature(iop_base))
 		goto nodev;
 	/*
@@ -18378,7 +18354,6 @@ static int __devinit advansys_vlb_probe(struct device *dev, unsigned int id)
 		goto nodev;
 
 	shost = advansys_board_found(iop_base, dev, ASC_IS_VL);
-
 	if (!shost)
 		goto nodev;
 
@@ -18386,6 +18361,7 @@ static int __devinit advansys_vlb_probe(struct device *dev, unsigned int id)
 	return 0;
 
  nodev:
+	release_region(iop_base, ASC_IOADR_GAP);
 	return -ENODEV;
 }
 
@@ -18429,8 +18405,16 @@ static int __devinit advansys_eisa_probe(struct device *dev)
 
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
+
 		/*
 		 * I don't know why we need to do this for EISA chips, but
 		 * not for any others.  It looks to be equivalent to
@@ -18440,8 +18424,11 @@ static int __devinit advansys_eisa_probe(struct device *dev)
 		 */
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
@@ -18460,10 +18447,13 @@ static __devexit int advansys_eisa_remove(struct device *dev)
 	struct eisa_scsi_data *data = dev_get_drvdata(dev);
 
 	for (i = 0; i < 2; i++) {
+		int ioport;
 		struct Scsi_Host *shost = data->host[i];
 		if (!shost)
 			continue;
+		ioport = shost->io_port;
 		advansys_release(shost);
+		release_region(ioport, ASC_IOADR_GAP);
 	}
 
 	kfree(data);
@@ -18507,6 +18497,9 @@ advansys_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	err = pci_enable_device(pdev);
 	if (err)
 		goto fail;
+	err = pci_request_regions(pdev, "advansys");
+	if (err)
+		goto disable_device;
 
 	if (pci_resource_len(pdev, 0) == 0)
 		goto nodev;
@@ -18522,6 +18515,8 @@ advansys_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
  nodev:
 	err = -ENODEV;
+	pci_release_regions(pdev);
+ disable_device:
 	pci_disable_device(pdev);
  fail:
 	return err;
@@ -18530,6 +18525,7 @@ advansys_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 static void __devexit advansys_pci_remove(struct pci_dev *pdev)
 {
 	advansys_release(pci_get_drvdata(pdev));
+	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 }
 
-- 
1.4.4.4

