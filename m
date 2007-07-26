From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 4/21] advansys: restructure error handling in advansys_board_found
Date: Thu, 26 Jul 2007 13:22:40 -0400
Message-ID: <11854705771175-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:47341 "EHLO
	mail-05.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762801AbXGZR6D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jul 2007 13:58:03 -0400
In-Reply-To: 20070726171141.GE19275@parisc-linux.org
References: 20070726171141.GE19275@parisc-linux.org
In-Reply-To: <20070726171141.GE19275@parisc-linux.org>
References: <20070726171141.GE19275@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Put all the error cleanup at the end of the function and goto the
correct spot.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |  106 ++++++++++++++++------------------------------
 1 files changed, 37 insertions(+), 69 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index d1ab0dc..3620322 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -17804,9 +17804,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 			ASC_PRINT3
 			    ("advansys_board_found: board %d: ioremap(%x, %d) returned NULL\n",
 			     boardp->id, pci_memory_address, iolen);
-			scsi_unregister(shost);
-			asc_board_count--;
-			return NULL;
+			goto err_shost;
 		}
 		ASC_DBG1(1,
 			 "advansys_board_found: ioremap_addr: 0x%lx\n",
@@ -17840,9 +17838,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 		ASC_PRINT3
 		    ("advansys_board_found: board %d: kmalloc(%d, %d) returned NULL\n",
 		     boardp->id, ASC_PRTBUF_SIZE, GFP_ATOMIC);
-		scsi_unregister(shost);
-		asc_board_count--;
-		return NULL;
+		goto err_unmap;
 	}
 #endif /* CONFIG_PROC_FS */
 
@@ -17968,14 +17964,8 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 		}
 	}
 
-	if (err_code != 0) {
-#ifdef CONFIG_PROC_FS
-		kfree(boardp->prtbuf);
-#endif /* CONFIG_PROC_FS */
-		scsi_unregister(shost);
-		asc_board_count--;
-		return NULL;
-	}
+	if (err_code != 0)
+		goto err_free_proc;
 
 	/*
 	 * Save the EEPROM configuration so that it can be displayed
@@ -18057,12 +18047,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 			    ("AscInitSetConfig: board %d error: init_state 0x%x, err_code 0x%x\n",
 			     boardp->id,
 			     asc_dvc_varp->init_state, asc_dvc_varp->err_code);
-#ifdef CONFIG_PROC_FS
-			kfree(boardp->prtbuf);
-#endif /* CONFIG_PROC_FS */
-			scsi_unregister(shost);
-			asc_board_count--;
-			return NULL;
+			goto err_free_proc;
 		}
 
 		/*
@@ -18327,12 +18312,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 		ASC_PRINT3
 		    ("advansys_board_found: board %d: request_region() failed, port 0x%lx, len 0x%x\n",
 		     boardp->id, (ulong)shost->io_port, boardp->asc_n_io_port);
-#ifdef CONFIG_PROC_FS
-		kfree(boardp->prtbuf);
-#endif /* CONFIG_PROC_FS */
-		scsi_unregister(shost);
-		asc_board_count--;
-		return NULL;
+		goto err_free_proc;
 	}
 
 	/* Register DMA Channel for Narrow boards. */
@@ -18342,19 +18322,12 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 		/* Register DMA channel for ISA bus. */
 		if (asc_dvc_varp->bus_type & ASC_IS_ISA) {
 			shost->dma_channel = asc_dvc_varp->cfg->isa_dma_channel;
-			if ((ret =
-			     request_dma(shost->dma_channel, "advansys")) != 0) {
+			ret = request_dma(shost->dma_channel, "advansys");
+			if (ret) {
 				ASC_PRINT3
 				    ("advansys_board_found: board %d: request_dma() %d failed %d\n",
 				     boardp->id, shost->dma_channel, ret);
-				release_region(shost->io_port,
-					       boardp->asc_n_io_port);
-#ifdef CONFIG_PROC_FS
-				kfree(boardp->prtbuf);
-#endif /* CONFIG_PROC_FS */
-				scsi_unregister(shost);
-				asc_board_count--;
-				return NULL;
+				goto err_free_region;
 			}
 			AscEnableIsaDma(shost->dma_channel);
 		}
@@ -18372,16 +18345,15 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 	 * If IRQF_DISABLED is not set, then interrupts are enabled
 	 * before the driver interrupt function is called.
 	 */
-	if (((ret = request_irq(shost->irq, advansys_interrupt,
-				IRQF_DISABLED | (share_irq ==
-						 TRUE ?
-						 IRQF_SHARED :
-						 0), "advansys", boardp)) != 0)
-	    &&
-	    ((ret =
-	      request_irq(shost->irq, advansys_interrupt,
-			  (share_irq == TRUE ? IRQF_SHARED : 0),
-			  "advansys", boardp)) != 0)) {
+	ret = request_irq(shost->irq, advansys_interrupt, IRQF_DISABLED |
+			   (share_irq == TRUE ?  IRQF_SHARED : 0), "advansys",
+			  boardp);
+	if (ret)
+		ret = request_irq(shost->irq, advansys_interrupt,
+				  (share_irq == TRUE ? IRQF_SHARED : 0),
+				  "advansys", boardp);
+
+	if (ret) {
 		if (ret == -EBUSY) {
 			ASC_PRINT2
 			    ("advansys_board_found: board %d: request_irq(): IRQ 0x%x already in use.\n",
@@ -18395,17 +18367,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 			    ("advansys_board_found: board %d: request_irq(): IRQ 0x%x failed with %d\n",
 			     boardp->id, shost->irq, ret);
 		}
-		release_region(shost->io_port, boardp->asc_n_io_port);
-		iounmap(boardp->ioremap_addr);
-		if (shost->dma_channel != NO_ISA_DMA) {
-			free_dma(shost->dma_channel);
-		}
-#ifdef CONFIG_PROC_FS
-		kfree(boardp->prtbuf);
-#endif /* CONFIG_PROC_FS */
-		scsi_unregister(shost);
-		asc_board_count--;
-		return NULL;
+		goto err_free_dma;
 	}
 
 	/*
@@ -18562,9 +18524,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 	}
 
 	if (err_code != 0) {
-		release_region(shost->io_port, boardp->asc_n_io_port);
 		if (ASC_WIDE_BOARD(boardp)) {
-			iounmap(boardp->ioremap_addr);
 			kfree(boardp->orig_carrp);
 			boardp->orig_carrp = NULL;
 			if (boardp->orig_reqp) {
@@ -18576,20 +18536,28 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 				kfree(sgp);
 			}
 		}
-		if (shost->dma_channel != NO_ISA_DMA) {
-			free_dma(shost->dma_channel);
-		}
-#ifdef CONFIG_PROC_FS
-		kfree(boardp->prtbuf);
-#endif /* CONFIG_PROC_FS */
-		free_irq(shost->irq, boardp);
-		scsi_unregister(shost);
-		asc_board_count--;
-		return NULL;
+		goto err_free_irq;
 	}
 	ASC_DBG_PRT_SCSI_HOST(2, shost);
 
 	return shost;
+
+ err_free_irq:
+	free_irq(shost->irq, boardp);
+ err_free_dma:
+	if (shost->dma_channel != NO_ISA_DMA)
+		free_dma(shost->dma_channel);
+ err_free_region:
+	release_region(shost->io_port, boardp->asc_n_io_port);
+ err_free_proc:
+	kfree(boardp->prtbuf);
+ err_unmap:
+	if (boardp->ioremap_addr)
+		iounmap(boardp->ioremap_addr);
+ err_shost:
+	scsi_unregister(shost);
+	asc_board_count--;
+	return NULL;
 }
 
 /*
-- 
1.4.4.4

