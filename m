From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 5/23] advansys: Make advansys_board_found a little more readable
Date: Mon, 30 Jul 2007 10:56:50 -0600
Message-ID: <11858146282252-git-send-email-matthew@wil.cx>
References: <20070730165508.GH21219@parisc-linux.org> <11858146283240-git-send-email-matthew@wil.cx> <1185814628978-git-send-email-matthew@wil.cx> <11858146282602-git-send-email-matthew@wil.cx> <11858146283106-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:43704 "EHLO
	smtp-04.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936844AbXG3Q5L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jul 2007 12:57:11 -0400
In-Reply-To: <11858146283106-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

 - Put all the error cleanup at the end of the function and goto the
   appropriate label
 - Split advansys_wide_init_chip out of advansys_board_found
 - Split advansys_wide_free_mem out of advansys_board_found.  Use it
   from advansys_release
 - Use GFP_KERNEL, not GFP_ATOMIC, when allocating memory during
   initialisation
 - Eliminate lots of PROC_FS ifdefs by removing the ifdefs around the prtbuf
   struct member

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |  394 +++++++++++++++++++----------------------------
 1 files changed, 158 insertions(+), 236 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 7a964bb..303dc98 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -3825,10 +3825,8 @@ typedef struct asc_board {
 	} eep_config;
 	ulong last_reset;	/* Saved last reset time */
 	spinlock_t lock;	/* Board spinlock */
-#ifdef CONFIG_PROC_FS
 	/* /proc/scsi/advansys/[0...] */
 	char *prtbuf;		/* /proc print buffer */
-#endif				/* CONFIG_PROC_FS */
 #ifdef ADVANSYS_STATS
 	struct asc_stats asc_stats;	/* Board statistics */
 #endif				/* ADVANSYS_STATS */
@@ -3845,7 +3843,7 @@ typedef struct asc_board {
 	 */
 	void __iomem *ioremap_addr;	/* I/O Memory remap address. */
 	ushort ioport;		/* I/O Port address. */
-	ADV_CARR_T *orig_carrp;	/* ADV_CARR_T memory block. */
+	ADV_CARR_T *carrp;	/* ADV_CARR_T memory block. */
 	adv_req_t *orig_reqp;	/* adv_req_t memory block. */
 	adv_req_t *adv_reqp;	/* Request structures. */
 	adv_sgblk_t *adv_sgblkp;	/* Scatter-gather structures. */
@@ -17703,6 +17701,124 @@ static void AdvInquiryHandling(ADV_DVC_VAR *asc_dvc, ADV_SCSI_REQ_Q *scsiq)
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
+static void advansys_wide_free_mem(asc_board_t *boardp)
+{
+	kfree(boardp->carrp);
+	boardp->carrp = NULL;
+	kfree(boardp->orig_reqp);
+	boardp->orig_reqp = boardp->adv_reqp = NULL;
+	while (boardp->adv_sgblkp) {
+		adv_sgblk_t *sgp = boardp->adv_sgblkp;
+		boardp->adv_sgblkp = sgp->next_sgblkp;
+		kfree(sgp);
+	}
+}
+
 static struct Scsi_Host *__devinit
 advansys_board_found(int iop, struct device *dev, int bus_type)
 {
@@ -17711,7 +17827,6 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 	asc_board_t *boardp;
 	ASC_DVC_VAR *asc_dvc_varp = NULL;
 	ADV_DVC_VAR *adv_dvc_varp = NULL;
-	adv_sgblk_t *sgp = NULL;
 	int share_irq;
 	int iolen = 0;
 	ADV_PADDR pci_memory_address;
@@ -17814,9 +17929,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
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
@@ -17846,13 +17959,11 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
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
 
@@ -17978,14 +18089,8 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
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
@@ -18067,12 +18172,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
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
@@ -18276,10 +18376,8 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 
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
@@ -18337,12 +18435,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
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
@@ -18352,19 +18445,12 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
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
@@ -18391,17 +18477,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
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
@@ -18419,173 +18495,33 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
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
-		free_irq(shost->irq, shost);
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
+	advansys_wide_free_mem(boardp);
+	free_irq(shost->irq, shost);
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
@@ -18901,24 +18837,10 @@ static int advansys_release(struct Scsi_Host *shost)
 	}
 	release_region(shost->io_port, boardp->asc_n_io_port);
 	if (ASC_WIDE_BOARD(boardp)) {
-		adv_sgblk_t *sgp = NULL;
-
 		iounmap(boardp->ioremap_addr);
-		kfree(boardp->orig_carrp);
-		boardp->orig_carrp = NULL;
-		if (boardp->orig_reqp) {
-			kfree(boardp->orig_reqp);
-			boardp->orig_reqp = boardp->adv_reqp = NULL;
-		}
-		while ((sgp = boardp->adv_sgblkp) != NULL) {
-			boardp->adv_sgblkp = sgp->next_sgblkp;
-			kfree(sgp);
-		}
+		advansys_wide_free_mem(boardp);
 	}
-#ifdef CONFIG_PROC_FS
-	ASC_ASSERT(boardp->prtbuf != NULL);
 	kfree(boardp->prtbuf);
-#endif /* CONFIG_PROC_FS */
 	scsi_unregister(shost);
 	ASC_DBG(1, "advansys_release: end\n");
 	return 0;
-- 
1.4.4.4

