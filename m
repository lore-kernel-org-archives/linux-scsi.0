From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 4/24] advansys: Make advansys_board_found a little more readable
Date: Fri, 27 Jul 2007 07:42:13 -0600
Message-ID: <1185543753768-git-send-email-matthew@wil.cx>
References: <20070727134038.GC21219@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:41982 "EHLO
	mail-07.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932318AbXG0Nmg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 09:42:36 -0400
In-Reply-To: <20070727134038.GC21219@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

 - Put all the error cleanup at the end of the function and goto the
   appropriate label
 - Split advansys_init_wide_chip out of advansys_board_found
 - Use GFP_KERNEL, not GFP_ATOMIC, when allocating memory during
   initialisation
 - Make share_irq be 0 or IRQD_SHARED, not FALSE or TRUE

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |  404 +++++++++++++++++++----------------------------
 1 files changed, 166 insertions(+), 238 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index a0bad3b..87e7730 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -3845,7 +3845,7 @@ typedef struct asc_board {
 	 */
 	void __iomem *ioremap_addr;	/* I/O Memory remap address. */
 	ushort ioport;		/* I/O Port address. */
-	ADV_CARR_T *orig_carrp;	/* ADV_CARR_T memory block. */
+	ADV_CARR_T *carrp;	/* ADV_CARR_T memory block. */
 	adv_req_t *orig_reqp;	/* adv_req_t memory block. */
 	adv_req_t *adv_reqp;	/* Request structures. */
 	adv_sgblk_t *adv_sgblkp;	/* Scatter-gather structures. */
@@ -17755,6 +17755,111 @@ static void AdvInquiryHandling(ADV_DVC_VAR *asc_dvc, ADV_SCSI_REQ_Q *scsiq)
 	}
 }
 
+static int __devinit
+advansys_wide_init_chip(asc_board_t *boardp, ADV_DVC_VAR *adv_dvc_varp)
+{
+	int req_cnt = 0;
+	adv_req_t *reqp = NULL;
+	int sg_cnt = 0;
+	adv_sgblk_t *sgp;
+	int warn_code, err_code;
+
+	/*
+	 * Allocate buffer carrier structures. The total size
+	 * is about 4 KB, so allocate all at once.
+	 */
+	boardp->carrp = kmalloc(ADV_CARRIER_BUFSIZE, GFP_KERNEL);
+	ASC_DBG1(1, "advansys_wide_init_chip: carrp 0x%p\n", boardp->carrp);
+
+	if (!boardp->carrp)
+		goto kmalloc_failed;
+
+	/*
+	 * Allocate up to 'max_host_qng' request structures for the Wide
+	 * board. The total size is about 16 KB, so allocate all at once.
+	 * If the allocation fails decrement and try again.
+	 */
+	for (req_cnt = adv_dvc_varp->max_host_qng; req_cnt > 0; req_cnt--) {
+		reqp = kmalloc(sizeof(adv_req_t) * req_cnt, GFP_KERNEL);
+
+		ASC_DBG3(1, "advansys_wide_init_chip: reqp 0x%p, req_cnt %d, "
+			 "bytes %lu\n", reqp, req_cnt,
+			 (ulong)sizeof(adv_req_t) * req_cnt);
+
+		if (reqp)
+			break;
+	}
+
+	if (!reqp)
+		goto kmalloc_failed;
+
+	boardp->orig_reqp = reqp;
+
+	/*
+	 * Allocate up to ADV_TOT_SG_BLOCK request structures for
+	 * the Wide board. Each structure is about 136 bytes.
+	 */
+	boardp->adv_sgblkp = NULL;
+	for (sg_cnt = 0; sg_cnt < ADV_TOT_SG_BLOCK; sg_cnt++) {
+		sgp = kmalloc(sizeof(adv_sgblk_t), GFP_KERNEL);
+
+		if (!sgp)
+			break;
+
+		sgp->next_sgblkp = boardp->adv_sgblkp;
+		boardp->adv_sgblkp = sgp;
+
+	}
+
+	ASC_DBG3(1, "advansys_wide_init_chip: sg_cnt %d * %u = %u bytes\n",
+		 sg_cnt, sizeof(adv_sgblk_t),
+		 (unsigned)(sizeof(adv_sgblk_t) * sg_cnt));
+
+	if (!boardp->adv_sgblkp)
+		goto kmalloc_failed;
+
+	adv_dvc_varp->carrier_buf = boardp->carrp;
+
+	/*
+	 * Point 'adv_reqp' to the request structures and
+	 * link them together.
+	 */
+	req_cnt--;
+	reqp[req_cnt].next_reqp = NULL;
+	for (; req_cnt > 0; req_cnt--) {
+		reqp[req_cnt - 1].next_reqp = &reqp[req_cnt];
+	}
+	boardp->adv_reqp = &reqp[0];
+
+	if (adv_dvc_varp->chip_type == ADV_CHIP_ASC3550) {
+		ASC_DBG(2, "advansys_wide_init_chip: AdvInitAsc3550Driver()\n");
+		warn_code = AdvInitAsc3550Driver(adv_dvc_varp);
+	} else if (adv_dvc_varp->chip_type == ADV_CHIP_ASC38C0800) {
+		ASC_DBG(2, "advansys_wide_init_chip: AdvInitAsc38C0800Driver()"
+			   "\n");
+		warn_code = AdvInitAsc38C0800Driver(adv_dvc_varp);
+	} else {
+		ASC_DBG(2, "advansys_wide_init_chip: AdvInitAsc38C1600Driver()"
+			   "\n");
+		warn_code = AdvInitAsc38C1600Driver(adv_dvc_varp);
+	}
+	err_code = adv_dvc_varp->err_code;
+
+	if (warn_code || err_code) {
+		ASC_PRINT3("advansys_wide_init_chip: board %d error: warn 0x%x,"
+			   " error 0x%x\n", boardp->id, warn_code, err_code);
+	}
+
+	goto exit;
+
+ kmalloc_failed:
+	ASC_PRINT1("advansys_wide_init_chip: board %d error: kmalloc() "
+		   "failed\n", boardp->id);
+	err_code = ADV_ERROR;
+ exit:
+	return err_code;
+}
+
 static struct Scsi_Host *__devinit
 advansys_board_found(int iop, struct device *dev, int bus_type)
 {
@@ -17763,8 +17868,8 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 	asc_board_t *boardp;
 	ASC_DVC_VAR *asc_dvc_varp = NULL;
 	ADV_DVC_VAR *adv_dvc_varp = NULL;
-	adv_sgblk_t *sgp = NULL;
-	int share_irq = FALSE;
+	adv_sgblk_t *sgp;
+	int share_irq;
 	int iolen = 0;
 	ADV_PADDR pci_memory_address;
 	int warn_code, err_code;
@@ -17866,9 +17971,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
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
@@ -17898,13 +18001,11 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 	 * Allocate buffer for printing information from
 	 * /proc/scsi/advansys/[0...].
 	 */
-	if ((boardp->prtbuf = kmalloc(ASC_PRTBUF_SIZE, GFP_ATOMIC)) == NULL) {
-		ASC_PRINT3
-		    ("advansys_board_found: board %d: kmalloc(%d, %d) returned NULL\n",
-		     boardp->id, ASC_PRTBUF_SIZE, GFP_ATOMIC);
-		scsi_unregister(shost);
-		asc_board_count--;
-		return NULL;
+	boardp->prtbuf = kmalloc(ASC_PRTBUF_SIZE, GFP_KERNEL);
+	if (!boardp->prtbuf) {
+		ASC_PRINT2("advansys_board_found: board %d: kmalloc(%d) "
+			   "returned NULL\n", boardp->id, ASC_PRTBUF_SIZE);
+		goto err_unmap;
 	}
 #endif /* CONFIG_PROC_FS */
 
@@ -17918,15 +18019,15 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 #ifdef CONFIG_ISA
 		case ASC_IS_ISA:
 			shost->unchecked_isa_dma = TRUE;
-			share_irq = FALSE;
+			share_irq = 0;
 			break;
 		case ASC_IS_VL:
 			shost->unchecked_isa_dma = FALSE;
-			share_irq = FALSE;
+			share_irq = 0;
 			break;
 		case ASC_IS_EISA:
 			shost->unchecked_isa_dma = FALSE;
-			share_irq = TRUE;
+			share_irq = IRQF_SHARED;
 			break;
 #endif /* CONFIG_ISA */
 #ifdef CONFIG_PCI
@@ -17937,7 +18038,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 					 PCI_SLOT(pdev->devfn),
 					 PCI_FUNC(pdev->devfn));
 			shost->unchecked_isa_dma = FALSE;
-			share_irq = TRUE;
+			share_irq = IRQF_SHARED;
 			break;
 #endif /* CONFIG_PCI */
 		default:
@@ -17945,7 +18046,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 			    ("advansys_board_found: board %d: unknown adapter type: %d\n",
 			     boardp->id, asc_dvc_varp->bus_type);
 			shost->unchecked_isa_dma = TRUE;
-			share_irq = FALSE;
+			share_irq = 0;
 			break;
 		}
 	} else {
@@ -17961,7 +18062,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 				 PCI_SLOT(pdev->devfn),
 				 PCI_FUNC(pdev->devfn));
 		shost->unchecked_isa_dma = FALSE;
-		share_irq = TRUE;
+		share_irq = IRQF_SHARED;
 #endif /* CONFIG_PCI */
 	}
 
@@ -18030,14 +18131,8 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
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
@@ -18119,12 +18214,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
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
@@ -18328,10 +18418,8 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 
 	/* BIOS start address. */
 	if (ASC_NARROW_BOARD(boardp)) {
-		shost->base = ((ulong)
-			     AscGetChipBiosAddress(asc_dvc_varp->
-						   iop_base,
-						   asc_dvc_varp->bus_type));
+		shost->base = AscGetChipBiosAddress(asc_dvc_varp->iop_base,
+						    asc_dvc_varp->bus_type);
 	} else {
 		/*
 		 * Fill-in BIOS board variables. The Wide BIOS saves
@@ -18389,12 +18477,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
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
@@ -18404,19 +18487,12 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
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
@@ -18434,16 +18510,13 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
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
+	ret = request_irq(shost->irq, advansys_interrupt,
+			  share_irq | IRQF_DISABLED, "advansys", boardp);
+	if (ret)
+		ret = request_irq(shost->irq, advansys_interrupt,
+				  share_irq, "advansys", boardp);
+
+	if (ret) {
 		if (ret == -EBUSY) {
 			ASC_PRINT2
 			    ("advansys_board_found: board %d: request_irq(): IRQ 0x%x already in use.\n",
@@ -18457,17 +18530,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
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
@@ -18485,173 +18548,38 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 			     asc_dvc_varp->init_state, warn_code, err_code);
 		}
 	} else {
-		ADV_CARR_T *carrp;
-		int req_cnt = 0;
-		adv_req_t *reqp = NULL;
-		int sg_cnt = 0;
-
-		/*
-		 * Allocate buffer carrier structures. The total size
-		 * is about 4 KB, so allocate all at once.
-		 */
-		carrp = (ADV_CARR_T *) kmalloc(ADV_CARRIER_BUFSIZE, GFP_ATOMIC);
-		ASC_DBG1(1, "advansys_board_found: carrp 0x%lx\n", (ulong)carrp);
-
-		if (carrp == NULL) {
-			goto kmalloc_error;
-		}
-
-		/*
-		 * Allocate up to 'max_host_qng' request structures for
-		 * the Wide board. The total size is about 16 KB, so
-		 * allocate all at once. If the allocation fails decrement
-		 * and try again.
-		 */
-		for (req_cnt = adv_dvc_varp->max_host_qng;
-		     req_cnt > 0; req_cnt--) {
-
-			reqp = (adv_req_t *)
-			    kmalloc(sizeof(adv_req_t) * req_cnt, GFP_ATOMIC);
-
-			ASC_DBG3(1,
-				 "advansys_board_found: reqp 0x%lx, req_cnt %d, bytes %lu\n",
-				 (ulong)reqp, req_cnt,
-				 (ulong)sizeof(adv_req_t) * req_cnt);
-
-			if (reqp != NULL) {
-				break;
-			}
-		}
-		if (reqp == NULL) {
-			goto kmalloc_error;
-		}
-
-		/*
-		 * Allocate up to ADV_TOT_SG_BLOCK request structures for
-		 * the Wide board. Each structure is about 136 bytes.
-		 */
-		boardp->adv_sgblkp = NULL;
-		for (sg_cnt = 0; sg_cnt < ADV_TOT_SG_BLOCK; sg_cnt++) {
-
-			sgp = (adv_sgblk_t *)
-			    kmalloc(sizeof(adv_sgblk_t), GFP_ATOMIC);
-
-			if (sgp == NULL) {
-				break;
-			}
-
-			sgp->next_sgblkp = boardp->adv_sgblkp;
-			boardp->adv_sgblkp = sgp;
-
-		}
-		ASC_DBG3(1,
-			 "advansys_board_found: sg_cnt %d * %u = %u bytes\n",
-			 sg_cnt, sizeof(adv_sgblk_t),
-			 (unsigned)(sizeof(adv_sgblk_t) * sg_cnt));
-
-		/*
-		 * If no request structures or scatter-gather structures could
-		 * be allocated, then return an error. Otherwise continue with
-		 * initialization.
-		 */
- kmalloc_error:
-		if (carrp == NULL) {
-			ASC_PRINT1
-			    ("advansys_board_found: board %d error: failed to kmalloc() carrier buffer.\n",
-			     boardp->id);
-			err_code = ADV_ERROR;
-		} else if (reqp == NULL) {
-			kfree(carrp);
-			ASC_PRINT1
-			    ("advansys_board_found: board %d error: failed to kmalloc() adv_req_t buffer.\n",
-			     boardp->id);
-			err_code = ADV_ERROR;
-		} else if (boardp->adv_sgblkp == NULL) {
-			kfree(carrp);
-			kfree(reqp);
-			ASC_PRINT1
-			    ("advansys_board_found: board %d error: failed to kmalloc() adv_sgblk_t buffers.\n",
-			     boardp->id);
-			err_code = ADV_ERROR;
-		} else {
-
-			/* Save carrier buffer pointer. */
-			boardp->orig_carrp = carrp;
-
-			/*
-			 * Save original pointer for kfree() in case the
-			 * driver is built as a module and can be unloaded.
-			 */
-			boardp->orig_reqp = reqp;
-
-			adv_dvc_varp->carrier_buf = carrp;
-
-			/*
-			 * Point 'adv_reqp' to the request structures and
-			 * link them together.
-			 */
-			req_cnt--;
-			reqp[req_cnt].next_reqp = NULL;
-			for (; req_cnt > 0; req_cnt--) {
-				reqp[req_cnt - 1].next_reqp = &reqp[req_cnt];
-			}
-			boardp->adv_reqp = &reqp[0];
-
-			if (adv_dvc_varp->chip_type == ADV_CHIP_ASC3550) {
-				ASC_DBG(2,
-					"advansys_board_found: AdvInitAsc3550Driver()\n");
-				warn_code = AdvInitAsc3550Driver(adv_dvc_varp);
-			} else if (adv_dvc_varp->chip_type ==
-				   ADV_CHIP_ASC38C0800) {
-				ASC_DBG(2,
-					"advansys_board_found: AdvInitAsc38C0800Driver()\n");
-				warn_code =
-				    AdvInitAsc38C0800Driver(adv_dvc_varp);
-			} else {
-				ASC_DBG(2,
-					"advansys_board_found: AdvInitAsc38C1600Driver()\n");
-				warn_code =
-				    AdvInitAsc38C1600Driver(adv_dvc_varp);
-			}
-			err_code = adv_dvc_varp->err_code;
-
-			if (warn_code || err_code) {
-				ASC_PRINT3
-				    ("advansys_board_found: board %d error: warn 0x%x, error 0x%x\n",
-				     boardp->id, warn_code, err_code);
-			}
-		}
+		err_code = advansys_wide_init_chip(boardp, adv_dvc_varp);
 	}
 
-	if (err_code != 0) {
-		release_region(shost->io_port, boardp->asc_n_io_port);
-		if (ASC_WIDE_BOARD(boardp)) {
-			iounmap(boardp->ioremap_addr);
-			kfree(boardp->orig_carrp);
-			boardp->orig_carrp = NULL;
-			if (boardp->orig_reqp) {
-				kfree(boardp->orig_reqp);
-				boardp->orig_reqp = boardp->adv_reqp = NULL;
-			}
-			while ((sgp = boardp->adv_sgblkp) != NULL) {
-				boardp->adv_sgblkp = sgp->next_sgblkp;
-				kfree(sgp);
-			}
-		}
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
-	}
+	if (err_code != 0)
+		goto err_free_wide_mem;
+
 	ASC_DBG_PRT_SCSI_HOST(2, shost);
 
 	return shost;
+
+ err_free_wide_mem:
+	kfree(boardp->carrp);
+	kfree(boardp->orig_reqp);
+	while ((sgp = boardp->adv_sgblkp) != NULL) {
+		boardp->adv_sgblkp = sgp->next_sgblkp;
+		kfree(sgp);
+	}
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
@@ -18970,8 +18898,8 @@ static int advansys_release(struct Scsi_Host *shost)
 		adv_sgblk_t *sgp = NULL;
 
 		iounmap(boardp->ioremap_addr);
-		kfree(boardp->orig_carrp);
-		boardp->orig_carrp = NULL;
+		kfree(boardp->carrp);
+		boardp->carrp = NULL;
 		if (boardp->orig_reqp) {
 			kfree(boardp->orig_reqp);
 			boardp->orig_reqp = boardp->adv_reqp = NULL;
-- 
1.4.4.4

