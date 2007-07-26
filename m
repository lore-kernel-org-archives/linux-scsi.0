From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 5/21] advansys: split advansys_init_wide_chip() out of advansys_board_found()
Date: Thu, 26 Jul 2007 13:22:41 -0400
Message-ID: <11854705771743-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:44654 "EHLO
	mail-01.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935428AbXGZSHw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jul 2007 14:07:52 -0400
In-Reply-To: 20070726171141.GE19275@parisc-linux.org
References: 20070726171141.GE19275@parisc-linux.org
In-Reply-To: <20070726171141.GE19275@parisc-linux.org>
References: <20070726171141.GE19275@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

The error handling around that part of advansys_board_found() was tricky,
so I split out that part into its own function.  It's still 120 lines, but
it's somewhat easier to see what's going on.  Also use GFP_KERNEL when
allocating memory during initialisation, not GFP_ATOMIC.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |  285 +++++++++++++++++++++-------------------------
 1 files changed, 130 insertions(+), 155 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 3620322..a663d14 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -17693,6 +17693,129 @@ static void AdvInquiryHandling(ADV_DVC_VAR *asc_dvc, ADV_SCSI_REQ_Q *scsiq)
 	}
 }
 
+static int __devinit
+advansys_wide_init_chip(asc_board_t *boardp, ADV_DVC_VAR *adv_dvc_varp)
+{
+	ADV_CARR_T *carrp;
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
+	carrp = kmalloc(ADV_CARRIER_BUFSIZE, GFP_KERNEL);
+	ASC_DBG1(1, "advansys_wide_init_chip: carrp 0x%lx\n", (ulong) carrp);
+
+	if (!carrp)
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
+	/* Save carrier buffer pointer. */
+	boardp->orig_carrp = carrp;
+
+	/*
+	 * Save original pointer for kfree() in case the
+	 * driver is built as a module and can be unloaded.
+	 */
+	boardp->orig_reqp = reqp;
+
+	adv_dvc_varp->carrier_buf = carrp;
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
+	if (err_code == 0)
+		return 0;
+
+	while ((sgp = boardp->adv_sgblkp) != NULL) {
+		boardp->adv_sgblkp = sgp->next_sgblkp;
+		kfree(sgp);
+	}
+
+ failed:
+	kfree(reqp);
+	kfree(carrp);
+	return err_code;
+
+ kmalloc_failed:
+	ASC_PRINT1("advansys_wide_init_chip: board %d error: kmalloc() "
+		   "failed\n", boardp->id);
+	err_code = ADV_ERROR;
+	goto failed;
+}
+
 static struct Scsi_Host *__devinit
 advansys_board_found(int iop, struct device *dev, int bus_type)
 {
@@ -17701,7 +17824,6 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 	asc_board_t *boardp;
 	ASC_DVC_VAR *asc_dvc_varp = NULL;
 	ADV_DVC_VAR *adv_dvc_varp = NULL;
-	adv_sgblk_t *sgp = NULL;
 	int share_irq = FALSE;
 	int iolen = 0;
 	ADV_PADDR pci_memory_address;
@@ -17834,10 +17956,10 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 	 * Allocate buffer for printing information from
 	 * /proc/scsi/advansys/[0...].
 	 */
-	if ((boardp->prtbuf = kmalloc(ASC_PRTBUF_SIZE, GFP_ATOMIC)) == NULL) {
-		ASC_PRINT3
-		    ("advansys_board_found: board %d: kmalloc(%d, %d) returned NULL\n",
-		     boardp->id, ASC_PRTBUF_SIZE, GFP_ATOMIC);
+	boardp->prtbuf = kmalloc(ASC_PRTBUF_SIZE, GFP_KERNEL);
+	if (!boardp->prtbuf) {
+		ASC_PRINT2("advansys_board_found: board %d: kmalloc(%d) "
+			   "returned NULL\n", boardp->id, ASC_PRTBUF_SIZE);
 		goto err_unmap;
 	}
 #endif /* CONFIG_PROC_FS */
@@ -18385,159 +18507,12 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
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
-		if (ASC_WIDE_BOARD(boardp)) {
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
+	if (err_code != 0)
 		goto err_free_irq;
-	}
+
 	ASC_DBG_PRT_SCSI_HOST(2, shost);
 
 	return shost;
-- 
1.4.4.4

