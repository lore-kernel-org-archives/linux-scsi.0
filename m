From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 2/8] mpt fusion: standardize printks and debug info
Date: Fri, 14 Sep 2007 18:46:51 -0600
Message-ID: <20070915004651.GA16822@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:48338 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518AbXIOAzI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Sep 2007 20:55:08 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

Standardize all prints using common MYIOC_s_XXX_FMT macro defined in mptbase.h. Currently the driver uses several different methods to display info, where in some cases the "controller name" generating the printk is not provided.

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>

diff -uarpN b/drivers/message/fusion/mptbase.c a/drivers/message/fusion/mptbase.c
--- b/drivers/message/fusion/mptbase.c	2007-09-13 14:30:29.000000000 -0600
+++ a/drivers/message/fusion/mptbase.c	2007-09-14 17:23:24.000000000 -0600
@@ -349,7 +349,7 @@ mpt_reply(MPT_ADAPTER *ioc, u32 pa)
 
 	dmfprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Got non-TURBO reply=%p req_idx=%x cb_idx=%x Function=%x\n",
 			ioc->name, mr, req_idx, cb_idx, mr->u.hdr.Function));
-	DBG_DUMP_REPLY_FRAME(ioc, (u32 *)mr)
+	DBG_DUMP_REPLY_FRAME(ioc, (u32 *)mr);
 
 	 /*  Check/log IOC log info
 	 */
@@ -451,8 +451,9 @@ mpt_base_reply(MPT_ADAPTER *ioc, MPT_FRA
 #ifdef CONFIG_FUSION_LOGGING
 	if ((ioc->debug_level & MPT_DEBUG_MSG_FRAME) &&
 			!(reply->u.hdr.MsgFlags & MPI_MSGFLAGS_CONTINUATION_REPLY)) {
-		dmfprintk(ioc, printk(KERN_INFO MYNAM ": Original request frame (@%p) header\n", mf));
-		DBG_DUMP_REQUEST_FRAME_HDR(ioc, (u32 *)mf)
+		dmfprintk(ioc, printk(MYIOC_s_INFO_FMT ": Original request frame (@%p) header\n",
+		    ioc->name, mf));
+		DBG_DUMP_REQUEST_FRAME_HDR(ioc, (u32 *)mf);
 	}
 #endif
 
@@ -517,8 +518,8 @@ mpt_base_reply(MPT_ADAPTER *ioc, MPT_FRA
 				u16		 status;
 
 				status = le16_to_cpu(pReply->IOCStatus) & MPI_IOCSTATUS_MASK;
-				dcprintk(ioc, printk(KERN_NOTICE "  IOCStatus=%04xh, IOCLogInfo=%08xh\n",
-				     status, le32_to_cpu(pReply->IOCLogInfo)));
+				dcprintk(ioc, printk(MYIOC_s_NOTE_FMT "  IOCStatus=%04xh, IOCLogInfo=%08xh\n",
+				     ioc->name, status, le32_to_cpu(pReply->IOCLogInfo)));
 
 				pCfg->status = status;
 				if (status == MPI_IOCSTATUS_SUCCESS) {
@@ -783,7 +784,8 @@ mpt_get_msg_frame(u8 cb_idx, MPT_ADAPTER
 
 #ifdef MFCNT
 	if (!ioc->active)
-		printk(KERN_WARNING "IOC Not Active! mpt_get_msg_frame returning NULL!\n");
+		printk(MYIOC_s_WARN_FMT "IOC Not Active! mpt_get_msg_frame "
+		    "returning NULL!\n", ioc->name);
 #endif
 
 	/* If interrupts are not attached, do not return a request frame */
@@ -804,7 +806,8 @@ mpt_get_msg_frame(u8 cb_idx, MPT_ADAPTER
 		req_idx = req_offset / ioc->req_sz;
 		mf->u.frame.hwhdr.msgctxu.fld.req_idx = cpu_to_le16(req_idx);
 		mf->u.frame.hwhdr.msgctxu.fld.rsvd = 0;
-		ioc->RequestNB[req_idx] = ioc->NB_for_64_byte_frame; /* Default, will be changed if necessary in SG generation */
+		/* Default, will be changed if necessary in SG generation */
+		ioc->RequestNB[req_idx] = ioc->NB_for_64_byte_frame;
 #ifdef MFCNT
 		ioc->mfcnt++;
 #endif
@@ -815,14 +818,17 @@ mpt_get_msg_frame(u8 cb_idx, MPT_ADAPTER
 
 #ifdef MFCNT
 	if (mf == NULL)
-		printk(KERN_WARNING "IOC Active. No free Msg Frames! Count 0x%x Max 0x%x\n", ioc->mfcnt, ioc->req_depth);
+		printk(MYIOC_s_WARN_FMT "IOC Active. No free Msg Frames! "
+		    "Count 0x%x Max 0x%x\n", ioc->name, ioc->mfcnt,
+		    ioc->req_depth);
 	mfcounter++;
 	if (mfcounter == PRINT_MF_COUNT)
-		printk(KERN_INFO "MF Count 0x%x Max 0x%x \n", ioc->mfcnt, ioc->req_depth);
+		printk(MYIOC_s_INFO_FMT "MF Count 0x%x Max 0x%x \n", ioc->name,
+		    ioc->mfcnt, ioc->req_depth);
 #endif
 
-	dmfprintk(ioc, printk(KERN_INFO MYNAM ": %s: mpt_get_msg_frame(%d,%d), got mf=%p\n",
-			ioc->name, cb_idx, ioc->id, mf));
+	dmfprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mpt_get_msg_frame(%d,%d), got mf=%p\n",
+	    ioc->name, cb_idx, ioc->id, mf));
 	return mf;
 }
 
@@ -855,7 +861,9 @@ mpt_put_msg_frame(u8 cb_idx, MPT_ADAPTER
 	DBG_DUMP_PUT_MSG_FRAME(ioc, (u32 *)mf);
 
 	mf_dma_addr = (ioc->req_frames_low_dma + req_offset) | ioc->RequestNB[req_idx];
-	dsgprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mf_dma_addr=%x req_idx=%d RequestNB=%x\n", ioc->name, mf_dma_addr, req_idx, ioc->RequestNB[req_idx]));
+	dsgprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mf_dma_addr=%x req_idx=%d "
+	    "RequestNB=%x\n", ioc->name, mf_dma_addr, req_idx,
+	    ioc->RequestNB[req_idx]));
 	CHIPREG_WRITE32(&ioc->chip->RequestFifo, mf_dma_addr);
 }
 
@@ -1002,7 +1010,7 @@ mpt_send_handshake_request(u8 cb_idx, MP
 	if (!(CHIPREG_READ32(&ioc->chip->Doorbell) & MPI_DOORBELL_ACTIVE))
 		return -5;
 
-	dhsprintk(ioc, printk(KERN_INFO MYNAM ": %s: mpt_send_handshake_request start, WaitCnt=%d\n",
+	dhsprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mpt_send_handshake_request start, WaitCnt=%d\n",
 		ioc->name, ii));
 
 	CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);
@@ -1470,24 +1478,27 @@ mpt_attach(struct pci_dev *pdev, const s
 		return -ENOMEM;
 	}
 	ioc->debug_level = mpt_debug_level;
+	ioc->id = mpt_ids++;
+	sprintf(ioc->name, "ioc%d", ioc->id);
 
-	dinitprintk(ioc, printk(KERN_WARNING MYNAM ": mpt_adapter_install\n"));
+	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT ": mpt_adapter_install\n", ioc->name));
 
 	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
-		dprintk(ioc, printk(KERN_INFO MYNAM
-			": 64 BIT PCI BUS DMA ADDRESSING SUPPORTED\n"));
+		dprintk(ioc, printk(MYIOC_s_INFO_FMT
+			": 64 BIT PCI BUS DMA ADDRESSING SUPPORTED\n", ioc->name));
 	} else if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
-		printk(KERN_WARNING MYNAM ": 32 BIT PCI BUS DMA ADDRESSING NOT SUPPORTED\n");
+		printk(MYIOC_s_WARN_FMT ": 32 BIT PCI BUS DMA ADDRESSING NOT SUPPORTED\n",
+		    ioc->name);
 		kfree(ioc);
 		return r;
 	}
 
 	if (!pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK)) {
-		dprintk(ioc, printk(KERN_INFO MYNAM
-			": Using 64 bit consistent mask\n"));
+		dprintk(ioc, printk(MYIOC_s_INFO_FMT
+			": Using 64 bit consistent mask\n", ioc->name));
 	} else {
-		dprintk(ioc, printk(KERN_INFO MYNAM
-			": Not using 64 bit consistent mask\n"));
+		dprintk(ioc, printk(MYIOC_s_INFO_FMT
+			": Not using 64 bit consistent mask\n", ioc->name));
 	}
 
 	ioc->alloc_total = sizeof(MPT_ADAPTER);
@@ -1526,7 +1537,6 @@ mpt_attach(struct pci_dev *pdev, const s
 
 	/* Find lookup slot. */
 	INIT_LIST_HEAD(&ioc->list);
-	ioc->id = mpt_ids++;
 
 	mem_phys = msize = 0;
 	port = psize = 0;
@@ -1552,15 +1562,15 @@ mpt_attach(struct pci_dev *pdev, const s
 	/*mem = ioremap(mem_phys, msize);*/
 	mem = ioremap(mem_phys, msize);
 	if (mem == NULL) {
-		printk(KERN_ERR MYNAM ": ERROR - Unable to map adapter memory!\n");
+		printk(MYIOC_s_ERR_FMT "Unable to map adapter memory!\n", ioc->name);
 		kfree(ioc);
 		return -EINVAL;
 	}
 	ioc->memmap = mem;
-	dinitprintk(ioc, printk(KERN_INFO MYNAM ": mem = %p, mem_phys = %lx\n", mem, mem_phys));
+	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "mem = %p, mem_phys = %lx\n", ioc->name, mem, mem_phys));
 
-	dinitprintk(ioc, printk(KERN_INFO MYNAM ": facts @ %p, pfacts[0] @ %p\n",
-			&ioc->facts, &ioc->pfacts[0]));
+	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "facts @ %p, pfacts[0] @ %p\n",
+	    ioc->name, &ioc->facts, &ioc->pfacts[0]));
 
 	ioc->mem_phys = mem_phys;
 	ioc->chip = (SYSIF_REGS __iomem *)mem;
@@ -1642,8 +1652,6 @@ mpt_attach(struct pci_dev *pdev, const s
 	if (ioc->errata_flag_1064)
 		pci_disable_io_access(pdev);
 
-	sprintf(ioc->name, "ioc%d", ioc->id);
-
 	spin_lock_init(&ioc->FreeQlock);
 
 	/* Disable all! */
@@ -1660,9 +1668,8 @@ mpt_attach(struct pci_dev *pdev, const s
 
 	if ((r = mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_BRINGUP,
 	    CAN_SLEEP)) != 0){
-		printk(KERN_WARNING MYNAM
-		  ": WARNING - %s did not initialize properly! (%d)\n",
-		  ioc->name, r);
+		printk(MYIOC_s_ERR_FMT "didn't initialize properly! (%d)\n",
+		    ioc->name, r);
 
 		list_del(&ioc->list);
 		if (ioc->alt_ioc)
@@ -1888,8 +1895,8 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 	int	 irq_allocated = 0;
 	u8	*a;
 
-	printk(KERN_INFO MYNAM ": Initiating %s %s\n",
-			ioc->name, reason==MPT_HOSTEVENT_IOC_BRINGUP ? "bringup" : "recovery");
+	printk(MYIOC_s_INFO_FMT "Initiating %s\n", ioc->name,
+	    reason == MPT_HOSTEVENT_IOC_BRINGUP ? "bringup" : "recovery");
 
 	/* Disable reply interrupts (also blocks FreeQ) */
 	CHIPREG_WRITE32(&ioc->chip->IntMask, 0xFFFFFFFF);
@@ -1910,21 +1917,19 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 
 	if ((hard_reset_done = MakeIocReady(ioc, hard, sleepFlag)) < 0) {
 		if (hard_reset_done == -4) {
-			printk(KERN_WARNING MYNAM ": %s Owned by PEER..skipping!\n",
-					ioc->name);
+			printk(MYIOC_s_WARN_FMT "Owned by PEER..skipping!\n",
+			    ioc->name);
 
 			if (reset_alt_ioc_active && ioc->alt_ioc) {
 				/* (re)Enable alt-IOC! (reply interrupt, FreeQ) */
-				dprintk(ioc, printk(KERN_INFO MYNAM
-					": alt-%s reply irq re-enabled\n",
-						ioc->alt_ioc->name));
+				dprintk(ioc, printk(MYIOC_s_INFO_FMT
+				    "alt_ioc reply irq re-enabled\n", ioc->alt_ioc->name));
 				CHIPREG_WRITE32(&ioc->alt_ioc->chip->IntMask, MPI_HIM_DIM);
 				ioc->alt_ioc->active = 1;
 			}
 
 		} else {
-			printk(KERN_WARNING MYNAM ": %s NOT READY WARNING!\n",
-					ioc->name);
+			printk(MYIOC_s_WARN_FMT "NOT READY!\n", ioc->name);
 		}
 		return -1;
 	}
@@ -1936,9 +1941,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 		if ((rc = MakeIocReady(ioc->alt_ioc, 0, sleepFlag)) == 0)
 			alt_ioc_ready = 1;
 		else
-			printk(KERN_WARNING MYNAM
-					": alt-%s: Not ready WARNING!\n",
-					ioc->alt_ioc->name);
+			printk(MYIOC_s_WARN_FMT "alt_ioc not ready!\n", ioc->alt_ioc->name);
 	}
 
 	for (ii=0; ii<5; ii++) {
@@ -1949,7 +1952,8 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 
 
 	if (ii == 5) {
-		dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Retry IocFacts failed rc=%x\n", ioc->name, rc));
+		dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "Retry IocFacts failed rc=%x\n", ioc->name, rc));
 		ret = -2;
 	} else if (reason == MPT_HOSTEVENT_IOC_BRINGUP) {
 		MptDisplayIocCapabilities(ioc);
@@ -1958,14 +1962,14 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 	if (alt_ioc_ready) {
 		if ((rc = GetIocFacts(ioc->alt_ioc, sleepFlag, reason)) != 0) {
 			dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-				"Initial Alt IocFacts failed rc=%x\n", ioc->name, rc));
+			    "Initial Alt IocFacts failed rc=%x\n", ioc->name, rc));
 			/* Retry - alt IOC was initialized once
 			 */
 			rc = GetIocFacts(ioc->alt_ioc, sleepFlag, reason);
 		}
 		if (rc) {
 			dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-				"Retry Alt IocFacts failed rc=%x\n", ioc->name, rc));
+			    "Retry Alt IocFacts failed rc=%x\n", ioc->name, rc));
 			alt_ioc_ready = 0;
 			reset_alt_ioc_active = 0;
 		} else if (reason == MPT_HOSTEVENT_IOC_BRINGUP) {
@@ -1983,13 +1987,12 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 		if (ioc->pcidev->irq) {
 			if (mpt_msi_enable && !pci_enable_msi(ioc->pcidev))
 				printk(MYIOC_s_INFO_FMT "PCI-MSI enabled\n",
-					ioc->name);
+				    ioc->name);
 			rc = request_irq(ioc->pcidev->irq, mpt_interrupt,
-					IRQF_SHARED, ioc->name, ioc);
+			    IRQF_SHARED, ioc->name, ioc);
 			if (rc < 0) {
 				printk(MYIOC_s_ERR_FMT "Unable to allocate "
-					"interrupt %d!\n", ioc->name,
-					ioc->pcidev->irq);
+				    "interrupt %d!\n", ioc->name, ioc->pcidev->irq);
 				if (mpt_msi_enable)
 					pci_disable_msi(ioc->pcidev);
 				return -EBUSY;
@@ -1998,8 +2001,8 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 			ioc->pci_irq = ioc->pcidev->irq;
 			pci_set_master(ioc->pcidev);		/* ?? */
 			pci_set_drvdata(ioc->pcidev, ioc);
-			dprintk(ioc, printk(KERN_INFO MYNAM ": %s installed at interrupt "
-				"%d\n", ioc->name, ioc->pcidev->irq));
+			dprintk(ioc, printk(MYIOC_s_INFO_FMT "installed at interrupt "
+			    "%d\n", ioc->name, ioc->pcidev->irq));
 		}
 	}
 
@@ -2018,8 +2021,8 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 		ret = -4;
 // NEW!
 	if (alt_ioc_ready && ((rc = PrimeIocFifos(ioc->alt_ioc)) != 0)) {
-		printk(KERN_WARNING MYNAM ": alt-%s: (%d) FIFO mgmt alloc WARNING!\n",
-				ioc->alt_ioc->name, rc);
+		printk(MYIOC_s_WARN_FMT ": alt_ioc (%d) FIFO mgmt alloc!\n",
+		    ioc->alt_ioc->name, rc);
 		alt_ioc_ready = 0;
 		reset_alt_ioc_active = 0;
 	}
@@ -2028,16 +2031,15 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 		if ((rc = SendIocInit(ioc->alt_ioc, sleepFlag)) != 0) {
 			alt_ioc_ready = 0;
 			reset_alt_ioc_active = 0;
-			printk(KERN_WARNING MYNAM
-				": alt-%s: (%d) init failure WARNING!\n",
-					ioc->alt_ioc->name, rc);
+			printk(MYIOC_s_WARN_FMT "alt_ioc (%d) init failure!\n",
+			    ioc->alt_ioc->name, rc);
 		}
 	}
 
 	if (reason == MPT_HOSTEVENT_IOC_BRINGUP){
 		if (ioc->upload_fw) {
 			ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-				"firmware upload required!\n", ioc->name));
+			    "firmware upload required!\n", ioc->name));
 
 			/* Controller is not operational, cannot do upload
 			 */
@@ -2053,12 +2055,13 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 						 * mpt_diag_reset)
 						 */
 						ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-							": mpt_upload:  alt_%s has cached_fw=%p \n",
-							ioc->name, ioc->alt_ioc->name, ioc->alt_ioc->cached_fw));
+						    "mpt_upload:  alt_%s has cached_fw=%p \n",
+						    ioc->name, ioc->alt_ioc->name, ioc->alt_ioc->cached_fw));
 						ioc->alt_ioc->cached_fw = NULL;
 					}
 				} else {
-					printk(KERN_WARNING MYNAM ": firmware upload failure!\n");
+					printk(MYIOC_s_WARN_FMT
+					    "firmware upload failure!\n", ioc->name);
 					ret = -5;
 				}
 			}
@@ -2073,8 +2076,8 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 
 	if (reset_alt_ioc_active && ioc->alt_ioc) {
 		/* (re)Enable alt-IOC! (reply interrupt) */
-		dinitprintk(ioc, printk(KERN_INFO MYNAM ": alt-%s reply irq re-enabled\n",
-				ioc->alt_ioc->name));
+		dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "alt_ioc reply irq re-enabled\n",
+		    ioc->alt_ioc->name));
 		CHIPREG_WRITE32(&ioc->alt_ioc->chip->IntMask, MPI_HIM_DIM);
 		ioc->alt_ioc->active = 1;
 	}
@@ -2127,10 +2130,8 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 				(void) GetLanConfigPages(ioc);
 				a = (u8*)&ioc->lan_cnfg_page1.HardwareAddressLow;
 				dprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-					"LanAddr = %02X:%02X:%02X:"
-					"%02X:%02X:%02X\n",
-					ioc->name, a[5], a[4],
-					a[3], a[2], a[1], a[0] ));
+				    "LanAddr = %02X:%02X:%02X:%02X:%02X:%02X\n",
+				    ioc->name, a[5], a[4], a[3], a[2], a[1], a[0]));
 
 			}
 		} else {
@@ -2169,16 +2170,16 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 		for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
 			if ((ret == 0) && MptResetHandlers[cb_idx]) {
 				dprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-					"Calling IOC post_reset handler #%d\n",
-					ioc->name, cb_idx));
+				    "Calling IOC post_reset handler #%d\n",
+				    ioc->name, cb_idx));
 				rc += mpt_signal_reset(cb_idx, ioc, MPT_IOC_POST_RESET);
 				handlers++;
 			}
 
 			if (alt_ioc_ready && MptResetHandlers[cb_idx]) {
 				drsprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-					"Calling alt-%s post_reset handler #%d\n",
-					ioc->name, ioc->alt_ioc->name, cb_idx));
+				    "Calling IOC post_reset handler #%d\n",
+				    ioc->alt_ioc->name, cb_idx));
 				rc += mpt_signal_reset(cb_idx, ioc->alt_ioc, MPT_IOC_POST_RESET);
 				handlers++;
 			}
@@ -2218,8 +2219,8 @@ mpt_detect_bound_ports(MPT_ADAPTER *ioc,
 
 	dprintk(ioc, printk(MYIOC_s_DEBUG_FMT "PCI device %s devfn=%x/%x,"
 	    " searching for devfn match on %x or %x\n",
-		ioc->name, pci_name(pdev), pdev->bus->number,
-		pdev->devfn, func-1, func+1));
+	    ioc->name, pci_name(pdev), pdev->bus->number,
+	    pdev->devfn, func-1, func+1));
 
 	peer = pci_get_slot(pdev->bus, PCI_DEVFN(slot,func-1));
 	if (!peer) {
@@ -2233,15 +2234,15 @@ mpt_detect_bound_ports(MPT_ADAPTER *ioc,
 		if (_pcidev == peer) {
 			/* Paranoia checks */
 			if (ioc->alt_ioc != NULL) {
-				printk(KERN_WARNING MYNAM ": Oops, already bound (%s <==> %s)!\n",
+				printk(MYIOC_s_WARN_FMT "Oops, already bound to %s!\n",
 					ioc->name, ioc->alt_ioc->name);
 				break;
 			} else if (ioc_srch->alt_ioc != NULL) {
-				printk(KERN_WARNING MYNAM ": Oops, already bound (%s <==> %s)!\n",
+				printk(MYIOC_s_WARN_FMT "Oops, already bound to %s!\n",
 					ioc_srch->name, ioc_srch->alt_ioc->name);
 				break;
 			}
-			dprintk(ioc, printk(KERN_INFO MYNAM ": FOUND! binding %s <==> %s\n",
+			dprintk(ioc, printk(MYIOC_s_INFO_FMT "FOUND! binding to %s\n",
 				ioc->name, ioc_srch->name));
 			ioc_srch->alt_ioc = ioc;
 			ioc->alt_ioc = ioc_srch;
@@ -2262,10 +2263,11 @@ mpt_adapter_disable(MPT_ADAPTER *ioc)
 	int ret;
 
 	if (ioc->cached_fw != NULL) {
-		ddlprintk(ioc, printk(KERN_INFO MYNAM ": mpt_adapter_disable: Pushing FW onto adapter\n"));
+		ddlprintk(ioc, printk(MYIOC_s_INFO_FMT
+		    "mpt_adapter_disable: Pushing FW onto adapter\n", ioc->name));
 		if ((ret = mpt_downloadboot(ioc, (MpiFwHeader_t *)ioc->cached_fw, NO_SLEEP)) < 0) {
-			printk(KERN_WARNING MYNAM
-				": firmware downloadboot failure (%d)!\n", ret);
+			printk(MYIOC_s_WARN_FMT "firmware downloadboot failure (%d)!\n",
+			    ioc->name, ret);
 		}
 	}
 
@@ -2277,8 +2279,8 @@ mpt_adapter_disable(MPT_ADAPTER *ioc)
 
 	if (ioc->alloc != NULL) {
 		sz = ioc->alloc_sz;
-		dexitprintk(ioc, printk(KERN_INFO MYNAM ": %s.free  @ %p, sz=%d bytes\n",
-		 	ioc->name, ioc->alloc, ioc->alloc_sz));
+		dexitprintk(ioc, printk(MYIOC_s_INFO_FMT "free  @ %p, sz=%d bytes\n",
+		    ioc->name, ioc->alloc, ioc->alloc_sz));
 		pci_free_consistent(ioc->pcidev, sz,
 				ioc->alloc, ioc->alloc_dma);
 		ioc->reply_frames = NULL;
@@ -2338,15 +2340,14 @@ mpt_adapter_disable(MPT_ADAPTER *ioc)
 	if (ioc->HostPageBuffer != NULL) {
 		if((ret = mpt_host_page_access_control(ioc,
 		    MPI_DB_HPBAC_FREE_BUFFER, NO_SLEEP)) != 0) {
-			printk(KERN_ERR MYNAM
-			   ": %s: host page buffers free failed (%d)!\n",
-			    __FUNCTION__, ret);
+			printk(MYIOC_s_ERR_FMT
+			   "host page buffers free failed (%d)!\n",
+			    ioc->name, ret);
 		}
-		dexitprintk(ioc, printk(KERN_INFO MYNAM ": %s HostPageBuffer free  @ %p, sz=%d bytes\n",
+		dexitprintk(ioc, printk(MYIOC_s_INFO_FMT "HostPageBuffer free  @ %p, sz=%d bytes\n",
 		 	ioc->name, ioc->HostPageBuffer, ioc->HostPageBuffer_sz));
 		pci_free_consistent(ioc->pcidev, ioc->HostPageBuffer_sz,
-				ioc->HostPageBuffer,
-				ioc->HostPageBuffer_dma);
+		    ioc->HostPageBuffer, ioc->HostPageBuffer_dma);
 		ioc->HostPageBuffer = NULL;
 		ioc->HostPageBuffer_sz = 0;
 		ioc->alloc_total -= ioc->HostPageBuffer_sz;
@@ -2388,7 +2389,7 @@ mpt_adapter_dispose(MPT_ADAPTER *ioc)
 #if defined(CONFIG_MTRR) && 0
 	if (ioc->mtrr_reg > 0) {
 		mtrr_del(ioc->mtrr_reg, 0, 0);
-		dprintk(ioc, printk(KERN_INFO MYNAM ": %s: MTRR region de-registered\n", ioc->name));
+		dprintk(ioc, printk(MYIOC_s_INFO_FMT "MTRR region de-registered\n", ioc->name));
 	}
 #endif
 
@@ -2396,8 +2397,8 @@ mpt_adapter_dispose(MPT_ADAPTER *ioc)
 	list_del(&ioc->list);
 
 	sz_last = ioc->alloc_total;
-	dprintk(ioc, printk(KERN_INFO MYNAM ": %s: free'd %d of %d bytes\n",
-			ioc->name, sz_first-sz_last+(int)sizeof(*ioc), sz_first));
+	dprintk(ioc, printk(MYIOC_s_INFO_FMT "free'd %d of %d bytes\n",
+	    ioc->name, sz_first-sz_last+(int)sizeof(*ioc), sz_first));
 
 	if (ioc->alt_ioc)
 		ioc->alt_ioc->alt_ioc = NULL;
@@ -2476,7 +2477,7 @@ MakeIocReady(MPT_ADAPTER *ioc, int force
 
 	/* Get current [raw] IOC state  */
 	ioc_state = mpt_GetIocState(ioc, 0);
-	dhsprintk(ioc, printk(KERN_INFO MYNAM "::MakeIocReady, %s [raw] state=%08x\n", ioc->name, ioc_state));
+	dhsprintk(ioc, printk(MYIOC_s_INFO_FMT "MakeIocReady [raw] state=%08x\n", ioc->name, ioc_state));
 
 	/*
 	 *	Check to see if IOC got left/stuck in doorbell handshake
@@ -2498,9 +2499,9 @@ MakeIocReady(MPT_ADAPTER *ioc, int force
 	if ((ioc_state & MPI_IOC_STATE_MASK) == MPI_IOC_STATE_FAULT) {
 		statefault = 2;
 		printk(MYIOC_s_WARN_FMT "IOC is in FAULT state!!!\n",
-				ioc->name);
-		printk(KERN_WARNING "           FAULT code = %04xh\n",
-				ioc_state & MPI_DOORBELL_DATA_MASK);
+		    ioc->name);
+		printk(MYIOC_s_WARN_FMT "           FAULT code = %04xh\n",
+		    ioc->name, ioc_state & MPI_DOORBELL_DATA_MASK);
 	}
 
 	/*
@@ -2516,9 +2517,9 @@ MakeIocReady(MPT_ADAPTER *ioc, int force
 		 * Else, fall through to KickStart case
 		 */
 		whoinit = (ioc_state & MPI_DOORBELL_WHO_INIT_MASK) >> MPI_DOORBELL_WHO_INIT_SHIFT;
-		dinitprintk(ioc, printk(KERN_INFO MYNAM
-			": whoinit 0x%x statefault %d force %d\n",
-			whoinit, statefault, force));
+		dinitprintk(ioc, printk(MYIOC_s_INFO_FMT
+			"whoinit 0x%x statefault %d force %d\n",
+			ioc->name, whoinit, statefault, force));
 		if (whoinit == MPI_WHOINIT_PCI_PEER)
 			return -4;
 		else {
@@ -2601,7 +2602,6 @@ mpt_GetIocState(MPT_ADAPTER *ioc, int co
 
 	/*  Get!  */
 	s = CHIPREG_READ32(&ioc->chip->Doorbell);
-//	dprintk((MYIOC_s_INFO_FMT "raw state = %08x\n", ioc->name, s));
 	sc = s & MPI_IOC_STATE_MASK;
 
 	/*  Save!  */
@@ -2633,9 +2633,8 @@ GetIocFacts(MPT_ADAPTER *ioc, int sleepF
 
 	/* IOC *must* NOT be in RESET state! */
 	if (ioc->last_state == MPI_IOC_STATE_RESET) {
-		printk(KERN_ERR MYNAM ": ERROR - Can't get IOCFacts, %s NOT READY! (%08x)\n",
-				ioc->name,
-				ioc->last_state );
+		printk(MYIOC_s_ERR_FMT "Can't get IOCFacts NOT READY! (%08x)\n",
+		    ioc->name, ioc->last_state );
 		return -44;
 	}
 
@@ -2755,8 +2754,8 @@ GetIocFacts(MPT_ADAPTER *ioc, int sleepF
 		}
 		ioc->NBShiftFactor  = shiftFactor;
 		dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-			"NB_for_64_byte_frame=%x NBShiftFactor=%x BlockSize=%x\n",
-			ioc->name, vv, shiftFactor, r));
+		    "NB_for_64_byte_frame=%x NBShiftFactor=%x BlockSize=%x\n",
+		    ioc->name, vv, shiftFactor, r));
 
 		if (reason == MPT_HOSTEVENT_IOC_BRINGUP) {
 			/*
@@ -2809,9 +2808,8 @@ GetPortFacts(MPT_ADAPTER *ioc, int portn
 
 	/* IOC *must* NOT be in RESET state! */
 	if (ioc->last_state == MPI_IOC_STATE_RESET) {
-		printk(KERN_ERR MYNAM ": ERROR - Can't get PortFacts, %s NOT READY! (%08x)\n",
-				ioc->name,
-				ioc->last_state );
+		printk(MYIOC_s_ERR_FMT "Can't get PortFacts NOT READY! (%08x)\n",
+		    ioc->name, ioc->last_state );
 		return -4;
 	}
 
@@ -2986,7 +2984,7 @@ SendIocInit(MPT_ADAPTER *ioc, int sleepF
 		state = mpt_GetIocState(ioc, 1);
 		count++;
 	}
-	dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "INFO - Wait IOC_OPERATIONAL state (cnt=%d)\n",
+	dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Wait IOC_OPERATIONAL state (cnt=%d)\n",
 			ioc->name, count));
 
 	ioc->aen_event_read_flag=0;
@@ -3079,10 +3077,9 @@ mpt_free_fw_memory(MPT_ADAPTER *ioc)
 	int sz;
 
 	sz = ioc->facts.FWImageSize;
-	dinitprintk(ioc, printk(KERN_INFO MYNAM "free_fw_memory: FW Image  @ %p[%p], sz=%d[%x] bytes\n",
-		 ioc->cached_fw, (void *)(ulong)ioc->cached_fw_dma, sz, sz));
-	pci_free_consistent(ioc->pcidev, sz,
-			ioc->cached_fw, ioc->cached_fw_dma);
+	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "free_fw_memory: FW Image  @ %p[%p], sz=%d[%x] bytes\n",
+	    ioc->name, ioc->cached_fw, (void *)(ulong)ioc->cached_fw_dma, sz, sz));
+	pci_free_consistent(ioc->pcidev, sz, ioc->cached_fw, ioc->cached_fw_dma);
 	ioc->cached_fw = NULL;
 
 	return;
@@ -3123,8 +3120,8 @@ mpt_do_upload(MPT_ADAPTER *ioc, int slee
 
 	mpt_alloc_fw_memory(ioc, sz);
 
-	dinitprintk(ioc, printk(KERN_INFO MYNAM ": FW Image  @ %p[%p], sz=%d[%x] bytes\n",
-		 ioc->cached_fw, (void *)(ulong)ioc->cached_fw_dma, sz, sz));
+	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT ": FW Image  @ %p[%p], sz=%d[%x] bytes\n",
+	    ioc->name, ioc->cached_fw, (void *)(ulong)ioc->cached_fw_dma, sz, sz));
 
 	if (ioc->cached_fw == NULL) {
 		/* Major Failure.
@@ -3155,14 +3152,14 @@ mpt_do_upload(MPT_ADAPTER *ioc, int slee
 	mpt_add_sge(&request[sgeoffset], flagsLength, ioc->cached_fw_dma);
 
 	sgeoffset += sizeof(u32) + sizeof(dma_addr_t);
-	dinitprintk(ioc, printk(KERN_INFO MYNAM ": Sending FW Upload (req @ %p) sgeoffset=%d \n",
-			prequest, sgeoffset));
-	DBG_DUMP_FW_REQUEST_FRAME(ioc, (u32 *)prequest)
+	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT ": Sending FW Upload (req @ %p) sgeoffset=%d \n",
+	    ioc->name, prequest, sgeoffset));
+	DBG_DUMP_FW_REQUEST_FRAME(ioc, (u32 *)prequest);
 
 	ii = mpt_handshake_req_reply_wait(ioc, sgeoffset, (u32*)prequest,
 				reply_sz, (u16*)preply, 65 /*seconds*/, sleepFlag);
 
-	dinitprintk(ioc, printk(KERN_INFO MYNAM ": FW Upload completed rc=%x \n", ii));
+	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT ": FW Upload completed rc=%x \n", ioc->name, ii));
 
 	cmdStatus = -EFAULT;
 	if (ii == 0) {
@@ -3433,7 +3430,7 @@ KickStart(MPT_ADAPTER *ioc, int force, i
 	u32 ioc_state=0;
 	int cnt,cntdn;
 
-	dinitprintk(ioc, printk(KERN_WARNING MYNAM ": KickStarting %s!\n", ioc->name));
+	dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "KickStarting!\n", ioc->name));
 	if (ioc->bus_type == SPI) {
 		/* Always issue a Msg Unit Reset first. This will clear some
 		 * SCSI bus hang conditions.
@@ -3452,7 +3449,7 @@ KickStart(MPT_ADAPTER *ioc, int force, i
 		return hard_reset_done;
 
 	dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Diagnostic reset successful!\n",
-			ioc->name));
+		ioc->name));
 
 	cntdn = ((sleepFlag == CAN_SLEEP) ? HZ : 1000) * 2;	/* 2 seconds */
 	for (cnt=0; cnt<cntdn; cnt++) {
@@ -3469,8 +3466,8 @@ KickStart(MPT_ADAPTER *ioc, int force, i
 		}
 	}
 
-	printk(MYIOC_s_ERR_FMT "Failed to come READY after reset! IocState=%x\n",
-			ioc->name, ioc_state);
+	dinitprintk(ioc, printk(MYIOC_s_ERR_FMT "Failed to come READY after reset! IocState=%x\n",
+		ioc->name, mpt_GetIocState(ioc, 0)));
 	return -1;
 }
 
@@ -3658,8 +3655,8 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ign
 			}
 			if ((count = mpt_downloadboot(ioc,
 				(MpiFwHeader_t *)iocp->cached_fw, sleepFlag)) < 0) {
-				printk(KERN_WARNING MYNAM
-					": firmware downloadboot failure (%d)!\n", count);
+				printk(MYIOC_s_WARN_FMT
+					"firmware downloadboot failure (%d)!\n", ioc->name, count);
 			}
 
 		} else {
@@ -3802,8 +3799,8 @@ SendIocReset(MPT_ADAPTER *ioc, u8 reset_
 			if (sleepFlag != CAN_SLEEP)
 				count *= 10;
 
-			printk(KERN_ERR MYNAM ": %s: ERROR - Wait IOC_READY state timeout(%d)!\n",
-					ioc->name, (int)((count+5)/HZ));
+			printk(MYIOC_s_ERR_FMT "Wait IOC_READY state timeout(%d)!\n",
+			    ioc->name, (int)((count+5)/HZ));
 			return -ETIME;
 		}
 
@@ -4196,7 +4193,7 @@ mpt_handshake_req_reply_wait(MPT_ADAPTER
 		}
 
 		dhsprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Handshake request frame (@%p) header\n", ioc->name, req));
-		DBG_DUMP_REQUEST_FRAME_HDR(ioc, (u32 *)req)
+		DBG_DUMP_REQUEST_FRAME_HDR(ioc, (u32 *)req);
 
 		dhsprintk(ioc, printk(MYIOC_s_DEBUG_FMT "HandShake request post done, WaitCnt=%d%s\n",
 				ioc->name, t, failcnt ? " - MISSING DOORBELL ACK!" : ""));
@@ -4401,7 +4398,7 @@ WaitForDoorbellReply(MPT_ADAPTER *ioc, i
 #endif
 
 	dhsprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Got Handshake reply:\n", ioc->name));
-	DBG_DUMP_REPLY_FRAME(ioc, (u32 *)mptReply)
+	DBG_DUMP_REPLY_FRAME(ioc, (u32 *)mptReply);
 
 	dhsprintk(ioc, printk(MYIOC_s_DEBUG_FMT "WaitForDoorbell REPLY WaitCnt=%d (sz=%d)\n",
 			ioc->name, t, u16cnt/2));
@@ -4876,8 +4873,8 @@ mpt_GetScsiPortSettings(MPT_ADAPTER *ioc
 
 				if ( (pPP0->Capabilities & MPI_SCSIPORTPAGE0_CAP_QAS) == 0 ) {
 					ioc->spi_data.noQas |= MPT_TARGET_NO_NEGO_QAS;
-					ddvprintk(ioc, printk(KERN_INFO MYNAM
-						" :%s noQas due to Capabilities=%x\n",
+					ddvprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+						"noQas due to Capabilities=%x\n",
 						ioc->name, pPP0->Capabilities));
 				}
 				ioc->spi_data.maxBusWidth = pPP0->Capabilities & MPI_SCSIPORTPAGE0_CAP_WIDE ? 1 : 0;
@@ -5785,10 +5782,10 @@ mpt_ioc_reset(MPT_ADAPTER *ioc, int rese
 	CONFIGPARMS *pCfg;
 	unsigned long flags;
 
-	dprintk(ioc, printk(KERN_DEBUG MYNAM
-			": IOC %s_reset routed to MPT base driver!\n",
-			reset_phase==MPT_IOC_SETUP_RESET ? "setup" : (
-			reset_phase==MPT_IOC_PRE_RESET ? "pre" : "post")));
+	dprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+	    ": IOC %s_reset routed to MPT base driver!\n",
+	    ioc->name, reset_phase==MPT_IOC_SETUP_RESET ? "setup" : (
+	    reset_phase==MPT_IOC_PRE_RESET ? "pre" : "post")));
 
 	if (reset_phase == MPT_IOC_SETUP_RESET) {
 		;
@@ -6201,8 +6198,7 @@ mpt_HardResetHandler(MPT_ADAPTER *ioc, i
 	}
 
 	if ((rc = mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_RECOVER, sleepFlag)) != 0) {
-		printk(KERN_WARNING MYNAM ": WARNING - (%d) Cannot recover %s\n",
-			rc, ioc->name);
+		printk(MYIOC_s_WARN_FMT "Cannot recover rc = %d!\n", ioc->name, rc);
 	}
 	ioc->reload_fw = 0;
 	if (ioc->alt_ioc)
@@ -6622,12 +6618,12 @@ ProcessEventNotification(MPT_ADAPTER *io
 			evStr));
 
 #ifdef CONFIG_FUSION_LOGGING
-	devtverboseprintk(ioc, printk(KERN_DEBUG MYNAM
-	    ": Event data:\n"));
+	devtverboseprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+	    ": Event data:\n", ioc->name));
 	for (ii = 0; ii < evDataLen; ii++)
 		devtverboseprintk(ioc, printk(" %08x",
 		    le32_to_cpu(pEventReply->Data[ii])));
-	devtverboseprintk(ioc, printk(KERN_DEBUG "\n"));
+	devtverboseprintk(ioc, printk("\n"));
 #endif
 
 	/*
@@ -7119,8 +7115,8 @@ mpt_iocstatus_info_config(MPT_ADAPTER *i
 	if (!desc)
 		return;
 
-	printk(MYIOC_s_INFO_FMT "IOCStatus(0x%04X): %s: %s\n",
-	    ioc->name, ioc_status, desc, extend_desc);
+	dreplyprintk(ioc, printk(MYIOC_s_DEBUG_FMT "IOCStatus(0x%04X): %s: %s\n",
+	    ioc->name, ioc_status, desc, extend_desc));
 }
 
 /**
@@ -7346,7 +7342,8 @@ mpt_iocstatus_info(MPT_ADAPTER *ioc, u32
 	if (!desc)
 		return;
 
-	printk(MYIOC_s_INFO_FMT "IOCStatus(0x%04X): %s\n", ioc->name, status, desc);
+	dreplyprintk(ioc, printk(MYIOC_s_DEBUG_FMT "IOCStatus(0x%04X): %s\n",
+	    ioc->name, status, desc));
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff -uarpN b/drivers/message/fusion/mptctl.c a/drivers/message/fusion/mptctl.c
--- b/drivers/message/fusion/mptctl.c	2007-09-13 14:30:29.000000000 -0600
+++ a/drivers/message/fusion/mptctl.c	2007-09-14 12:35:20.000000000 -0600
@@ -181,7 +181,6 @@ static inline int
 mptctl_syscall_down(MPT_ADAPTER *ioc, int nonblock)
 {
 	int rc = 0;
-//	dctlprintk(ioc, printk(KERN_DEBUG MYNAM "::mptctl_syscall_down(%p,%d) called\n", ioc, nonblock));
 
 	if (nonblock) {
 		if (!mutex_trylock(&ioc->ioctl->ioctl_mutex))
@@ -190,7 +189,6 @@ mptctl_syscall_down(MPT_ADAPTER *ioc, in
 		if (mutex_lock_interruptible(&ioc->ioctl->ioctl_mutex))
 			rc = -ERESTARTSYS;
 	}
-//	dctlprintk(ioc, printk(KERN_DEBUG MYNAM "::mptctl_syscall_down return %d\n", rc));
 	return rc;
 }
 
@@ -475,7 +473,7 @@ static int
 mptctl_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
 {
 	MPT_IOCTL *ioctl = ioc->ioctl;
-	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT ": IOC %s_reset routed to IOCTL driver!\n",ioc->name,
+	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "IOC %s_reset routed to IOCTL driver!\n", ioc->name,
 		reset_phase==MPT_IOC_SETUP_RESET ? "setup" : (
 		reset_phase==MPT_IOC_PRE_RESET ? "pre" : "post")));
 
@@ -581,7 +579,7 @@ __mptctl_ioctl(struct file *file, unsign
 	MPT_ADAPTER *iocp = NULL;
 
 	if (copy_from_user(&khdr, uhdr, sizeof(khdr))) {
-		printk(KERN_ERR "%s::mptctl_ioctl() @%d - "
+		printk(KERN_ERR MYNAM "%s::mptctl_ioctl() @%d - "
 				"Unable to copy mpt_ioctl_header data @ %p\n",
 				__FILE__, __LINE__, uhdr);
 		return -EFAULT;
@@ -594,13 +592,13 @@ __mptctl_ioctl(struct file *file, unsign
 	iocnumX = khdr.iocnum & 0xFF;
 	if (((iocnum = mpt_verify_adapter(iocnumX, &iocp)) < 0) ||
 	    (iocp == NULL)) {
-		printk(KERN_DEBUG "%s::mptctl_ioctl() @%d - ioc%d not found!\n",
+		printk(KERN_DEBUG MYNAM "%s::mptctl_ioctl() @%d - ioc%d not found!\n",
 				__FILE__, __LINE__, iocnumX);
 		return -ENODEV;
 	}
 
 	if (!iocp->active) {
-		printk(KERN_DEBUG "%s::mptctl_ioctl() @%d - Controller disabled.\n",
+		printk(KERN_DEBUG MYNAM "%s::mptctl_ioctl() @%d - Controller disabled.\n",
 				__FILE__, __LINE__);
 		return -EFAULT;
 	}
@@ -667,14 +665,14 @@ static int mptctl_do_reset(unsigned long
 	MPT_ADAPTER		*iocp;
 
 	if (copy_from_user(&krinfo, urinfo, sizeof(struct mpt_ioctl_diag_reset))) {
-		printk(KERN_ERR "%s@%d::mptctl_do_reset - "
+		printk(KERN_ERR MYNAM "%s@%d::mptctl_do_reset - "
 				"Unable to copy mpt_ioctl_diag_reset struct @ %p\n",
 				__FILE__, __LINE__, urinfo);
 		return -EFAULT;
 	}
 
 	if (mpt_verify_adapter(krinfo.hdr.iocnum, &iocp) < 0) {
-		printk(KERN_DEBUG "%s@%d::mptctl_do_reset - ioc%d not found!\n",
+		printk(KERN_DEBUG MYNAM "%s@%d::mptctl_do_reset - ioc%d not found!\n",
 				__FILE__, __LINE__, krinfo.hdr.iocnum);
 		return -ENODEV; /* (-6) No such device or address */
 	}
@@ -683,8 +681,8 @@ static int mptctl_do_reset(unsigned long
 	    iocp->name));
 
 	if (mpt_HardResetHandler(iocp, CAN_SLEEP) != 0) {
-		printk (KERN_ERR "%s@%d::mptctl_do_reset - reset failed.\n",
-			__FILE__, __LINE__);
+		printk (MYIOC_s_ERR_FMT "%s@%d::mptctl_do_reset - reset failed.\n",
+			iocp->name, __FILE__, __LINE__);
 		return -1;
 	}
 
@@ -715,7 +713,7 @@ mptctl_fw_download(unsigned long arg)
 	struct mpt_fw_xfer	 kfwdl;
 
 	if (copy_from_user(&kfwdl, ufwdl, sizeof(struct mpt_fw_xfer))) {
-		printk(KERN_ERR "%s@%d::_ioctl_fwdl - "
+		printk(KERN_ERR MYNAM "%s@%d::_ioctl_fwdl - "
 				"Unable to copy mpt_fw_xfer struct @ %p\n",
 				__FILE__, __LINE__, ufwdl);
 		return -EFAULT;
@@ -763,7 +761,8 @@ mptctl_do_fw_download(int ioc, char __us
 	pFWDownloadReply_t	 ReplyMsg = NULL;
 
 	if (mpt_verify_adapter(ioc, &iocp) < 0) {
-		printk(KERN_DEBUG "ioctl_fwdl - ioc%d not found!\n",				 ioc);
+		printk(KERN_DEBUG MYNAM "ioctl_fwdl - ioc%d not found!\n",
+				 ioc);
 		return -ENODEV; /* (-6) No such device or address */
 	} else {
 
@@ -875,9 +874,9 @@ mptctl_do_fw_download(int ioc, char __us
 			mpt_add_sge(sgOut, sgIn->FlagsLength, sgIn->Address);
 			n++;
 			if (copy_from_user(bl->kptr, ufwbuf+fw_bytes_copied, bl->len)) {
-				printk(KERN_ERR "%s@%d::_ioctl_fwdl - "
-						"Unable to copy f/w buffer hunk#%d @ %p\n",
-						__FILE__, __LINE__, n, ufwbuf);
+				printk(MYIOC_s_ERR_FMT "%s@%d::_ioctl_fwdl - "
+					"Unable to copy f/w buffer hunk#%d @ %p\n",
+					iocp->name, __FILE__, __LINE__, n, ufwbuf);
 				goto fwdl_out;
 			}
 			fw_bytes_copied += bl->len;
@@ -913,21 +912,22 @@ mptctl_do_fw_download(int ioc, char __us
 	ReplyMsg = (pFWDownloadReply_t)iocp->ioctl->ReplyFrame;
 	iocstat = le16_to_cpu(ReplyMsg->IOCStatus) & MPI_IOCSTATUS_MASK;
 	if (iocstat == MPI_IOCSTATUS_SUCCESS) {
-		printk(KERN_INFO MYNAM ": F/W update successfully sent to %s!\n", iocp->name);
+		printk(MYIOC_s_INFO_FMT "F/W update successfull!\n", iocp->name);
 		return 0;
 	} else if (iocstat == MPI_IOCSTATUS_INVALID_FUNCTION) {
-		printk(KERN_WARNING MYNAM ": ?Hmmm...  %s says it doesn't support F/W download!?!\n",
-				iocp->name);
-		printk(KERN_WARNING MYNAM ": (time to go bang on somebodies door)\n");
+		printk(MYIOC_s_WARN_FMT "Hmmm...  F/W download not supported!?!\n",
+			iocp->name);
+		printk(MYIOC_s_WARN_FMT "(time to go bang on somebodies door)\n",
+			iocp->name);
 		return -EBADRQC;
 	} else if (iocstat == MPI_IOCSTATUS_BUSY) {
-		printk(KERN_WARNING MYNAM ": Warning!  %s says: IOC_BUSY!\n", iocp->name);
-		printk(KERN_WARNING MYNAM ": (try again later?)\n");
+		printk(MYIOC_s_WARN_FMT "IOC_BUSY!\n", iocp->name);
+		printk(MYIOC_s_WARN_FMT "(try again later?)\n", iocp->name);
 		return -EBUSY;
 	} else {
-		printk(KERN_WARNING MYNAM "::ioctl_fwdl() ERROR!  %s returned [bad] status = %04xh\n",
-				    iocp->name, iocstat);
-		printk(KERN_WARNING MYNAM ": (bad VooDoo)\n");
+		printk(MYIOC_s_WARN_FMT "ioctl_fwdl() returned [bad] status = %04xh\n",
+			iocp->name, iocstat);
+		printk(MYIOC_s_WARN_FMT "(bad VooDoo)\n", iocp->name);
 		return -ENOMSG;
 	}
 	return 0;
@@ -1014,10 +1014,10 @@ kbuf_alloc_2_sgl(int bytes, u32 sgdir, i
 		if (buflist[buflist_ent].kptr == NULL) {
 			alloc_sz = alloc_sz / 2;
 			if (alloc_sz == 0) {
-				printk(KERN_WARNING MYNAM "-SG: No can do - "
-						    "not enough memory!   :-(\n");
-				printk(KERN_WARNING MYNAM "-SG: (freeing %d frags)\n",
-						    numfrags);
+				printk(MYIOC_s_WARN_FMT "-SG: No can do - "
+				    "not enough memory!   :-(\n", ioc->name);
+				printk(MYIOC_s_WARN_FMT "-SG: (freeing %d frags)\n",
+					ioc->name, numfrags);
 				goto free_and_fail;
 			}
 			continue;
@@ -1040,18 +1040,19 @@ kbuf_alloc_2_sgl(int bytes, u32 sgdir, i
 
 		/* Need to chain? */
 		if (fragcnt == sg_spill) {
-			printk(KERN_WARNING MYNAM "-SG: No can do - " "Chain required!   :-(\n");
-			printk(KERN_WARNING MYNAM "(freeing %d frags)\n", numfrags);
+			printk(MYIOC_s_WARN_FMT
+			    "-SG: No can do - " "Chain required!   :-(\n", ioc->name);
+			printk(MYIOC_s_WARN_FMT "(freeing %d frags)\n", ioc->name, numfrags);
 			goto free_and_fail;
 		}
 
 		/* overflow check... */
 		if (numfrags*8 > MAX_SGL_BYTES){
 			/* GRRRRR... */
-			printk(KERN_WARNING MYNAM "-SG: No can do - "
-					    "too many SG frags!   :-(\n");
-			printk(KERN_WARNING MYNAM "-SG: (freeing %d frags)\n",
-					    numfrags);
+			printk(MYIOC_s_WARN_FMT "-SG: No can do - "
+				"too many SG frags!   :-(\n", ioc->name);
+			printk(MYIOC_s_WARN_FMT "-SG: (freeing %d frags)\n",
+				ioc->name, numfrags);
 			goto free_and_fail;
 		}
 	}
@@ -1072,8 +1073,6 @@ kbuf_alloc_2_sgl(int bytes, u32 sgdir, i
 
 free_and_fail:
 	if (sglbuf != NULL) {
-		int i;
-
 		for (i = 0; i < numfrags; i++) {
 			dma_addr_t dma_addr;
 			u8 *kptr;
@@ -1195,13 +1194,13 @@ mptctl_getiocinfo (unsigned long arg, un
 
 	karg = kmalloc(data_size, GFP_KERNEL);
 	if (karg == NULL) {
-		printk(KERN_ERR "%s::mpt_ioctl_iocinfo() @%d - no memory available!\n",
+		printk(KERN_ERR MYNAM "%s::mpt_ioctl_iocinfo() @%d - no memory available!\n",
 				__FILE__, __LINE__);
 		return -ENOMEM;
 	}
 
 	if (copy_from_user(karg, uarg, data_size)) {
-		printk(KERN_ERR "%s@%d::mptctl_getiocinfo - "
+		printk(KERN_ERR MYNAM "%s@%d::mptctl_getiocinfo - "
 			"Unable to read in mpt_ioctl_iocinfo struct @ %p\n",
 				__FILE__, __LINE__, uarg);
 		kfree(karg);
@@ -1210,7 +1209,7 @@ mptctl_getiocinfo (unsigned long arg, un
 
 	if (((iocnum = mpt_verify_adapter(karg->hdr.iocnum, &ioc)) < 0) ||
 	    (ioc == NULL)) {
-		printk(KERN_DEBUG "%s::mptctl_getiocinfo() @%d - ioc%d not found!\n",
+		printk(KERN_DEBUG MYNAM "%s::mptctl_getiocinfo() @%d - ioc%d not found!\n",
 				__FILE__, __LINE__, iocnum);
 		kfree(karg);
 		return -ENODEV;
@@ -1218,9 +1217,9 @@ mptctl_getiocinfo (unsigned long arg, un
 
 	/* Verify the data transfer size is correct. */
 	if (karg->hdr.maxDataSize != data_size) {
-		printk(KERN_ERR "%s@%d::mptctl_getiocinfo - "
+		printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_getiocinfo - "
 			"Structure size mismatch. Command not completed.\n",
-				__FILE__, __LINE__);
+			ioc->name, __FILE__, __LINE__);
 		kfree(karg);
 		return -EFAULT;
 	}
@@ -1296,9 +1295,9 @@ mptctl_getiocinfo (unsigned long arg, un
 	/* Copy the data from kernel memory to user memory
 	 */
 	if (copy_to_user((char __user *)arg, karg, data_size)) {
-		printk(KERN_ERR "%s@%d::mptctl_getiocinfo - "
+		printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_getiocinfo - "
 			"Unable to write out mpt_ioctl_iocinfo struct @ %p\n",
-				__FILE__, __LINE__, uarg);
+			ioc->name, __FILE__, __LINE__, uarg);
 		kfree(karg);
 		return -EFAULT;
 	}
@@ -1335,7 +1334,7 @@ mptctl_gettargetinfo (unsigned long arg)
 	struct scsi_device 	*sdev;
 
 	if (copy_from_user(&karg, uarg, sizeof(struct mpt_ioctl_targetinfo))) {
-		printk(KERN_ERR "%s@%d::mptctl_gettargetinfo - "
+		printk(KERN_ERR MYNAM "%s@%d::mptctl_gettargetinfo - "
 			"Unable to read in mpt_ioctl_targetinfo struct @ %p\n",
 				__FILE__, __LINE__, uarg);
 		return -EFAULT;
@@ -1343,7 +1342,7 @@ mptctl_gettargetinfo (unsigned long arg)
 
 	if (((iocnum = mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
 	    (ioc == NULL)) {
-		printk(KERN_DEBUG "%s::mptctl_gettargetinfo() @%d - ioc%d not found!\n",
+		printk(KERN_DEBUG MYNAM "%s::mptctl_gettargetinfo() @%d - ioc%d not found!\n",
 				__FILE__, __LINE__, iocnum);
 		return -ENODEV;
 	}
@@ -1359,8 +1358,8 @@ mptctl_gettargetinfo (unsigned long arg)
 	port = karg.hdr.port;
 
 	if (maxWordsLeft <= 0) {
-		printk(KERN_ERR "%s::mptctl_gettargetinfo() @%d - no memory available!\n",
-				__FILE__, __LINE__);
+		printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_gettargetinfo() - no memory available!\n",
+			ioc->name, __FILE__, __LINE__);
 		return -ENOMEM;
 	}
 
@@ -1380,8 +1379,8 @@ mptctl_gettargetinfo (unsigned long arg)
 	 */
 	pmem = kzalloc(numBytes, GFP_KERNEL);
 	if (!pmem) {
-		printk(KERN_ERR "%s::mptctl_gettargetinfo() @%d - no memory available!\n",
-				__FILE__, __LINE__);
+		printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_gettargetinfo() - no memory available!\n",
+			ioc->name, __FILE__, __LINE__);
 		return -ENOMEM;
 	}
 	pdata =  (int *) pmem;
@@ -1410,9 +1409,9 @@ mptctl_gettargetinfo (unsigned long arg)
 	 */
 	if (copy_to_user((char __user *)arg, &karg,
 				sizeof(struct mpt_ioctl_targetinfo))) {
-		printk(KERN_ERR "%s@%d::mptctl_gettargetinfo - "
+		printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_gettargetinfo - "
 			"Unable to write out mpt_ioctl_targetinfo struct @ %p\n",
-				__FILE__, __LINE__, uarg);
+			ioc->name, __FILE__, __LINE__, uarg);
 		kfree(pmem);
 		return -EFAULT;
 	}
@@ -1420,9 +1419,9 @@ mptctl_gettargetinfo (unsigned long arg)
 	/* Copy the remaining data from kernel memory to user memory
 	 */
 	if (copy_to_user(uarg->targetInfo, pmem, numBytes)) {
-		printk(KERN_ERR "%s@%d::mptctl_gettargetinfo - "
+		printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_gettargetinfo - "
 			"Unable to write out mpt_ioctl_targetinfo struct @ %p\n",
-				__FILE__, __LINE__, pdata);
+			ioc->name, __FILE__, __LINE__, pdata);
 		kfree(pmem);
 		return -EFAULT;
 	}
@@ -1449,7 +1448,7 @@ mptctl_readtest (unsigned long arg)
 	int iocnum;
 
 	if (copy_from_user(&karg, uarg, sizeof(struct mpt_ioctl_test))) {
-		printk(KERN_ERR "%s@%d::mptctl_readtest - "
+		printk(KERN_ERR MYNAM "%s@%d::mptctl_readtest - "
 			"Unable to read in mpt_ioctl_test struct @ %p\n",
 				__FILE__, __LINE__, uarg);
 		return -EFAULT;
@@ -1457,7 +1456,7 @@ mptctl_readtest (unsigned long arg)
 
 	if (((iocnum = mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
 	    (ioc == NULL)) {
-		printk(KERN_DEBUG "%s::mptctl_readtest() @%d - ioc%d not found!\n",
+		printk(KERN_DEBUG MYNAM "%s::mptctl_readtest() @%d - ioc%d not found!\n",
 				__FILE__, __LINE__, iocnum);
 		return -ENODEV;
 	}
@@ -1481,9 +1480,9 @@ mptctl_readtest (unsigned long arg)
 	/* Copy the data from kernel memory to user memory
 	 */
 	if (copy_to_user((char __user *)arg, &karg, sizeof(struct mpt_ioctl_test))) {
-		printk(KERN_ERR "%s@%d::mptctl_readtest - "
+		printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_readtest - "
 			"Unable to write out mpt_ioctl_test struct @ %p\n",
-				__FILE__, __LINE__, uarg);
+			ioc->name, __FILE__, __LINE__, uarg);
 		return -EFAULT;
 	}
 
@@ -1510,7 +1509,7 @@ mptctl_eventquery (unsigned long arg)
 	int iocnum;
 
 	if (copy_from_user(&karg, uarg, sizeof(struct mpt_ioctl_eventquery))) {
-		printk(KERN_ERR "%s@%d::mptctl_eventquery - "
+		printk(KERN_ERR MYNAM "%s@%d::mptctl_eventquery - "
 			"Unable to read in mpt_ioctl_eventquery struct @ %p\n",
 				__FILE__, __LINE__, uarg);
 		return -EFAULT;
@@ -1518,7 +1517,7 @@ mptctl_eventquery (unsigned long arg)
 
 	if (((iocnum = mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
 	    (ioc == NULL)) {
-		printk(KERN_DEBUG "%s::mptctl_eventquery() @%d - ioc%d not found!\n",
+		printk(KERN_DEBUG MYNAM "%s::mptctl_eventquery() @%d - ioc%d not found!\n",
 				__FILE__, __LINE__, iocnum);
 		return -ENODEV;
 	}
@@ -1531,9 +1530,9 @@ mptctl_eventquery (unsigned long arg)
 	/* Copy the data from kernel memory to user memory
 	 */
 	if (copy_to_user((char __user *)arg, &karg, sizeof(struct mpt_ioctl_eventquery))) {
-		printk(KERN_ERR "%s@%d::mptctl_eventquery - "
+		printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_eventquery - "
 			"Unable to write out mpt_ioctl_eventquery struct @ %p\n",
-				__FILE__, __LINE__, uarg);
+			ioc->name, __FILE__, __LINE__, uarg);
 		return -EFAULT;
 	}
 	return 0;
@@ -1549,7 +1548,7 @@ mptctl_eventenable (unsigned long arg)
 	int iocnum;
 
 	if (copy_from_user(&karg, uarg, sizeof(struct mpt_ioctl_eventenable))) {
-		printk(KERN_ERR "%s@%d::mptctl_eventenable - "
+		printk(KERN_ERR MYNAM "%s@%d::mptctl_eventenable - "
 			"Unable to read in mpt_ioctl_eventenable struct @ %p\n",
 				__FILE__, __LINE__, uarg);
 		return -EFAULT;
@@ -1557,7 +1556,7 @@ mptctl_eventenable (unsigned long arg)
 
 	if (((iocnum = mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
 	    (ioc == NULL)) {
-		printk(KERN_DEBUG "%s::mptctl_eventenable() @%d - ioc%d not found!\n",
+		printk(KERN_DEBUG MYNAM "%s::mptctl_eventenable() @%d - ioc%d not found!\n",
 				__FILE__, __LINE__, iocnum);
 		return -ENODEV;
 	}
@@ -1570,7 +1569,9 @@ mptctl_eventenable (unsigned long arg)
 		int sz = MPTCTL_EVENT_LOG_SIZE * sizeof(MPT_IOCTL_EVENTS);
 		ioc->events = kzalloc(sz, GFP_KERNEL);
 		if (!ioc->events) {
-			printk(KERN_ERR MYNAM ": ERROR - Insufficient memory to add adapter!\n");
+			printk(MYIOC_s_ERR_FMT
+			    ": ERROR - Insufficient memory to add adapter!\n",
+			    ioc->name);
 			return -ENOMEM;
 		}
 		ioc->alloc_total += sz;
@@ -1596,7 +1597,7 @@ mptctl_eventreport (unsigned long arg)
 	int			 numBytes, maxEvents, max;
 
 	if (copy_from_user(&karg, uarg, sizeof(struct mpt_ioctl_eventreport))) {
-		printk(KERN_ERR "%s@%d::mptctl_eventreport - "
+		printk(KERN_ERR MYNAM "%s@%d::mptctl_eventreport - "
 			"Unable to read in mpt_ioctl_eventreport struct @ %p\n",
 				__FILE__, __LINE__, uarg);
 		return -EFAULT;
@@ -1604,7 +1605,7 @@ mptctl_eventreport (unsigned long arg)
 
 	if (((iocnum = mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
 	    (ioc == NULL)) {
-		printk(KERN_DEBUG "%s::mptctl_eventreport() @%d - ioc%d not found!\n",
+		printk(KERN_DEBUG MYNAM "%s::mptctl_eventreport() @%d - ioc%d not found!\n",
 				__FILE__, __LINE__, iocnum);
 		return -ENODEV;
 	}
@@ -1630,9 +1631,9 @@ mptctl_eventreport (unsigned long arg)
 	 */
 	numBytes = max * sizeof(MPT_IOCTL_EVENTS);
 	if (copy_to_user(uarg->eventData, ioc->events, numBytes)) {
-		printk(KERN_ERR "%s@%d::mptctl_eventreport - "
+		printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_eventreport - "
 			"Unable to write out mpt_ioctl_eventreport struct @ %p\n",
-				__FILE__, __LINE__, ioc->events);
+			ioc->name, __FILE__, __LINE__, ioc->events);
 		return -EFAULT;
 	}
 
@@ -1650,7 +1651,7 @@ mptctl_replace_fw (unsigned long arg)
 	int			 newFwSize;
 
 	if (copy_from_user(&karg, uarg, sizeof(struct mpt_ioctl_replace_fw))) {
-		printk(KERN_ERR "%s@%d::mptctl_replace_fw - "
+		printk(KERN_ERR MYNAM "%s@%d::mptctl_replace_fw - "
 			"Unable to read in mpt_ioctl_replace_fw struct @ %p\n",
 				__FILE__, __LINE__, uarg);
 		return -EFAULT;
@@ -1658,7 +1659,7 @@ mptctl_replace_fw (unsigned long arg)
 
 	if (((iocnum = mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
 	    (ioc == NULL)) {
-		printk(KERN_DEBUG "%s::mptctl_replace_fw() @%d - ioc%d not found!\n",
+		printk(KERN_DEBUG MYNAM "%s::mptctl_replace_fw() @%d - ioc%d not found!\n",
 				__FILE__, __LINE__, iocnum);
 		return -ENODEV;
 	}
@@ -1688,9 +1689,9 @@ mptctl_replace_fw (unsigned long arg)
 	/* Copy the data from user memory to kernel space
 	 */
 	if (copy_from_user(ioc->cached_fw, uarg->newImage, newFwSize)) {
-		printk(KERN_ERR "%s@%d::mptctl_replace_fw - "
+		printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_replace_fw - "
 				"Unable to read in mpt_ioctl_replace_fw image "
-				"@ %p\n", __FILE__, __LINE__, uarg);
+				"@ %p\n", ioc->name, __FILE__, __LINE__, uarg);
 		mpt_free_fw_memory(ioc);
 		return -EFAULT;
 	}
@@ -1724,7 +1725,7 @@ mptctl_mpt_command (unsigned long arg)
 
 
 	if (copy_from_user(&karg, uarg, sizeof(struct mpt_ioctl_command))) {
-		printk(KERN_ERR "%s@%d::mptctl_mpt_command - "
+		printk(KERN_ERR MYNAM "%s@%d::mptctl_mpt_command - "
 			"Unable to read in mpt_ioctl_command struct @ %p\n",
 				__FILE__, __LINE__, uarg);
 		return -EFAULT;
@@ -1732,7 +1733,7 @@ mptctl_mpt_command (unsigned long arg)
 
 	if (((iocnum = mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
 	    (ioc == NULL)) {
-		printk(KERN_DEBUG "%s::mptctl_mpt_command() @%d - ioc%d not found!\n",
+		printk(KERN_DEBUG MYNAM "%s::mptctl_mpt_command() @%d - ioc%d not found!\n",
 				__FILE__, __LINE__, iocnum);
 		return -ENODEV;
 	}
@@ -1777,17 +1778,17 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 
 	if (((iocnum = mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
 	    (ioc == NULL)) {
-		printk(KERN_DEBUG "%s::mptctl_do_mpt_command() @%d - ioc%d not found!\n",
+		printk(KERN_DEBUG MYNAM "%s::mptctl_do_mpt_command() @%d - ioc%d not found!\n",
 				__FILE__, __LINE__, iocnum);
 		return -ENODEV;
 	}
 	if (!ioc->ioctl) {
-		printk(KERN_ERR "%s@%d::mptctl_do_mpt_command - "
+		printk(KERN_ERR MYNAM "%s@%d::mptctl_do_mpt_command - "
 			"No memory available during driver init.\n",
 				__FILE__, __LINE__);
 		return -ENOMEM;
 	} else if (ioc->ioctl->status & MPT_IOCTL_STATUS_DID_IOCRESET) {
-		printk(KERN_ERR "%s@%d::mptctl_do_mpt_command - "
+		printk(KERN_ERR MYNAM "%s@%d::mptctl_do_mpt_command - "
 			"Busy with IOC Reset \n", __FILE__, __LINE__);
 		return -EBUSY;
 	}
@@ -1801,9 +1802,9 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 		sz += sizeof(dma_addr_t) + sizeof(u32);
 
 	if (sz > ioc->req_sz) {
-		printk(KERN_ERR "%s@%d::mptctl_do_mpt_command - "
+		printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_do_mpt_command - "
 			"Request frame too large (%d) maximum (%d)\n",
-				__FILE__, __LINE__, sz, ioc->req_sz);
+			ioc->name, __FILE__, __LINE__, sz, ioc->req_sz);
 		return -EFAULT;
 	}
 
@@ -1821,9 +1822,9 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 	 * Request frame in user space
 	 */
 	if (copy_from_user(mf, mfPtr, karg.dataSgeOffset * 4)) {
-		printk(KERN_ERR "%s@%d::mptctl_do_mpt_command - "
+		printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_do_mpt_command - "
 			"Unable to read MF from mpt_ioctl_command struct @ %p\n",
-			__FILE__, __LINE__, mfPtr);
+			ioc->name, __FILE__, __LINE__, mfPtr);
 		rc = -EFAULT;
 		goto done_free_mem;
 	}
@@ -1874,17 +1875,17 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 
 			id = (ioc->devices_per_bus == 0) ? 256 : ioc->devices_per_bus;
 			if (pScsiReq->TargetID > id) {
-				printk(KERN_ERR "%s@%d::mptctl_do_mpt_command - "
+				printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_do_mpt_command - "
 					"Target ID out of bounds. \n",
-					__FILE__, __LINE__);
+					ioc->name, __FILE__, __LINE__);
 				rc = -ENODEV;
 				goto done_free_mem;
 			}
 
 			if (pScsiReq->Bus >= ioc->number_of_buses) {
-				printk(KERN_ERR "%s@%d::mptctl_do_mpt_command - "
+				printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_do_mpt_command - "
 					"Target Bus out of bounds. \n",
-					__FILE__, __LINE__);
+					ioc->name, __FILE__, __LINE__);
 				rc = -ENODEV;
 				goto done_free_mem;
 			}
@@ -1936,9 +1937,9 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 			ioc->ioctl->id = pScsiReq->TargetID;
 
 		} else {
-			printk(KERN_ERR "%s@%d::mptctl_do_mpt_command - "
+			printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_do_mpt_command - "
 				"SCSI driver is not loaded. \n",
-					__FILE__, __LINE__);
+				ioc->name, __FILE__, __LINE__);
 			rc = -EFAULT;
 			goto done_free_mem;
 		}
@@ -1955,9 +1956,9 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 
 	case MPI_FUNCTION_SATA_PASSTHROUGH:
 		if (!ioc->sh) {
-			printk(KERN_ERR "%s@%d::mptctl_do_mpt_command - "
+			printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_do_mpt_command - "
 				"SCSI driver is not loaded. \n",
-					__FILE__, __LINE__);
+				ioc->name, __FILE__, __LINE__);
 			rc = -EFAULT;
 			goto done_free_mem;
 		}
@@ -2014,9 +2015,9 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 			ioc->ioctl->reset = MPTCTL_RESET_OK;
 			ioc->ioctl->id = pScsiReq->TargetID;
 		} else {
-			printk(KERN_ERR "%s@%d::mptctl_do_mpt_command - "
+			printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_do_mpt_command - "
 				"SCSI driver is not loaded. \n",
-					__FILE__, __LINE__);
+				ioc->name, __FILE__, __LINE__);
 			rc = -EFAULT;
 			goto done_free_mem;
 		}
@@ -2026,9 +2027,9 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 		{
 			MPT_SCSI_HOST *hd = NULL;
 			if ((ioc->sh == NULL) || ((hd = (MPT_SCSI_HOST *)ioc->sh->hostdata) == NULL)) {
-				printk(KERN_ERR "%s@%d::mptctl_do_mpt_command - "
+				printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_do_mpt_command - "
 					"SCSI driver not loaded or SCSI host not found. \n",
-					__FILE__, __LINE__);
+					ioc->name, __FILE__, __LINE__);
 				rc = -EFAULT;
 				goto done_free_mem;
 			} else if (mptctl_set_tm_flags(hd) != 0) {
@@ -2059,9 +2060,9 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 				(pInit->ReplyFrameSize != cpu_to_le16(ioc->reply_sz)) ||
 				(pInit->HostMfaHighAddr != high_addr) ||
 				(pInit->SenseBufferHighAddr != sense_high)) {
-				printk(KERN_ERR "%s@%d::mptctl_do_mpt_command - "
+				printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_do_mpt_command - "
 					"IOC_INIT issued with 1 or more incorrect parameters. Rejected.\n",
-					__FILE__, __LINE__);
+					ioc->name, __FILE__, __LINE__);
 				rc = -EFAULT;
 				goto done_free_mem;
 			}
@@ -2092,9 +2093,9 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 		 	MPI_FUNCTION_LAN_RESET
 		*/
 
-		printk(KERN_ERR "%s@%d::mptctl_do_mpt_command - "
+		printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_do_mpt_command - "
 			"Illegal request (function 0x%x) \n",
-			__FILE__, __LINE__, hdr->Function);
+			ioc->name, __FILE__, __LINE__, hdr->Function);
 		rc = -EFAULT;
 		goto done_free_mem;
 	}
@@ -2151,11 +2152,11 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 				if (copy_from_user(bufOut.kptr,
 						karg.dataOutBufPtr,
 						bufOut.len)) {
-					printk(KERN_ERR
+					printk(MYIOC_s_ERR_FMT
 						"%s@%d::mptctl_do_mpt_command - Unable "
 						"to read user data "
 						"struct @ %p\n",
-						__FILE__, __LINE__,karg.dataOutBufPtr);
+						ioc->name, __FILE__, __LINE__,karg.dataOutBufPtr);
 					rc =  -EFAULT;
 					goto done_free_mem;
 				}
@@ -2242,10 +2243,10 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 		if (sz > 0) {
 			if (copy_to_user(karg.replyFrameBufPtr,
 				 &ioc->ioctl->ReplyFrame, sz)){
-				 printk(KERN_ERR
+				 printk(MYIOC_s_ERR_FMT
 				     "%s@%d::mptctl_do_mpt_command - "
 				 "Unable to write out reply frame %p\n",
-				 __FILE__, __LINE__, karg.replyFrameBufPtr);
+				 ioc->name, __FILE__, __LINE__, karg.replyFrameBufPtr);
 				 rc =  -ENODATA;
 				 goto done_free_mem;
 			}
@@ -2258,9 +2259,9 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 		sz = min(karg.maxSenseBytes, MPT_SENSE_BUFFER_SIZE);
 		if (sz > 0) {
 			if (copy_to_user(karg.senseDataPtr, ioc->ioctl->sense, sz)) {
-				printk(KERN_ERR "%s@%d::mptctl_do_mpt_command - "
+				printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_do_mpt_command - "
 				"Unable to write sense data to user %p\n",
-				__FILE__, __LINE__,
+				ioc->name, __FILE__, __LINE__,
 				karg.senseDataPtr);
 				rc =  -ENODATA;
 				goto done_free_mem;
@@ -2276,9 +2277,9 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 
 		if (copy_to_user(karg.dataInBufPtr,
 				 bufIn.kptr, karg.dataInSize)) {
-			printk(KERN_ERR "%s@%d::mptctl_do_mpt_command - "
+			printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_do_mpt_command - "
 				"Unable to write data to user %p\n",
-				__FILE__, __LINE__,
+				ioc->name, __FILE__, __LINE__,
 				karg.dataInBufPtr);
 			rc =  -ENODATA;
 		}
@@ -2349,7 +2350,7 @@ mptctl_hp_hostinfo(unsigned long arg, un
 		return -EFAULT;
 
 	if (copy_from_user(&karg, uarg, sizeof(hp_host_info_t))) {
-		printk(KERN_ERR "%s@%d::mptctl_hp_host_info - "
+		printk(KERN_ERR MYNAM "%s@%d::mptctl_hp_host_info - "
 			"Unable to read in hp_host_info struct @ %p\n",
 				__FILE__, __LINE__, uarg);
 		return -EFAULT;
@@ -2357,7 +2358,7 @@ mptctl_hp_hostinfo(unsigned long arg, un
 
 	if (((iocnum = mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
 	    (ioc == NULL)) {
-		printk(KERN_DEBUG "%s::mptctl_hp_hostinfo() @%d - ioc%d not found!\n",
+		printk(KERN_DEBUG MYNAM "%s::mptctl_hp_hostinfo() @%d - ioc%d not found!\n",
 				__FILE__, __LINE__, iocnum);
 		return -ENODEV;
 	}
@@ -2538,9 +2539,9 @@ mptctl_hp_hostinfo(unsigned long arg, un
 	/* Copy the data from kernel memory to user memory
 	 */
 	if (copy_to_user((char __user *)arg, &karg, sizeof(hp_host_info_t))) {
-		printk(KERN_ERR "%s@%d::mptctl_hpgethostinfo - "
+		printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_hpgethostinfo - "
 			"Unable to write out hp_host_info @ %p\n",
-				__FILE__, __LINE__, uarg);
+			ioc->name, __FILE__, __LINE__, uarg);
 		return -EFAULT;
 	}
 
@@ -2576,7 +2577,7 @@ mptctl_hp_targetinfo(unsigned long arg)
 	int			tmp, np, rc = 0;
 
 	if (copy_from_user(&karg, uarg, sizeof(hp_target_info_t))) {
-		printk(KERN_ERR "%s@%d::mptctl_hp_targetinfo - "
+		printk(KERN_ERR MYNAM "%s@%d::mptctl_hp_targetinfo - "
 			"Unable to read in hp_host_targetinfo struct @ %p\n",
 				__FILE__, __LINE__, uarg);
 		return -EFAULT;
@@ -2584,11 +2585,11 @@ mptctl_hp_targetinfo(unsigned long arg)
 
 	if (((iocnum = mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
 		(ioc == NULL)) {
-		printk(KERN_DEBUG "%s::mptctl_hp_targetinfo() @%d - ioc%d not found!\n",
+		printk(KERN_DEBUG MYNAM "%s::mptctl_hp_targetinfo() @%d - ioc%d not found!\n",
 				__FILE__, __LINE__, iocnum);
 		return -ENODEV;
 	}
-	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT ": mptctl_hp_targetinfo called.\n",
+	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mptctl_hp_targetinfo called.\n",
 	    ioc->name));
 
 	/*  There is nothing to do for FCP parts.
@@ -2689,9 +2690,9 @@ mptctl_hp_targetinfo(unsigned long arg)
 	/* Copy the data from kernel memory to user memory
 	 */
 	if (copy_to_user((char __user *)arg, &karg, sizeof(hp_target_info_t))) {
-		printk(KERN_ERR "%s@%d::mptctl_hp_target_info - "
+		printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_hp_target_info - "
 			"Unable to write out mpt_ioctl_targetinfo struct @ %p\n",
-				__FILE__, __LINE__, uarg);
+			ioc->name, __FILE__, __LINE__, uarg);
 		return -EFAULT;
 	}
 
@@ -2741,7 +2742,7 @@ compat_mptfwxfer_ioctl(struct file *filp
 	if (((iocnum = mpt_verify_adapter(iocnumX, &iocp)) < 0) ||
 	    (iocp == NULL)) {
 		printk(KERN_DEBUG MYNAM "::compat_mptfwxfer_ioctl @%d - ioc%d not found!\n",
-				__LINE__, iocnumX);
+			__LINE__, iocnumX);
 		return -ENODEV;
 	}
 
@@ -2781,7 +2782,7 @@ compat_mpt_command(struct file *filp, un
 	if (((iocnum = mpt_verify_adapter(iocnumX, &iocp)) < 0) ||
 	    (iocp == NULL)) {
 		printk(KERN_DEBUG MYNAM "::compat_mpt_command @%d - ioc%d not found!\n",
-				__LINE__, iocnumX);
+			__LINE__, iocnumX);
 		return -ENODEV;
 	}
 
diff -uarpN b/drivers/message/fusion/mptfc.c a/drivers/message/fusion/mptfc.c
--- b/drivers/message/fusion/mptfc.c	2007-09-13 14:30:29.000000000 -0600
+++ a/drivers/message/fusion/mptfc.c	2007-09-14 14:08:51.000000000 -0600
@@ -204,7 +204,7 @@ mptfc_block_error_handler(struct scsi_cm
 			"DID_IMM_RETRY, deferring %s recovery.\n",
 			((MPT_SCSI_HOST *) shost->hostdata)->ioc->name,
 			((MPT_SCSI_HOST *) shost->hostdata)->ioc->sh->host_no,
-			SCpnt->device->id,SCpnt->device->lun,caller));
+			SCpnt->device->id, SCpnt->device->lun, caller));
 		msleep(1000);
 		spin_lock_irqsave(shost->host_lock, flags);
 	}
@@ -216,7 +216,7 @@ mptfc_block_error_handler(struct scsi_cm
 			"port state %d, vdev %p.\n", caller,
 			((MPT_SCSI_HOST *) shost->hostdata)->ioc->name,
 			((MPT_SCSI_HOST *) shost->hostdata)->ioc->sh->host_no,
-			SCpnt->device->id,SCpnt->device->lun,ready,
+			SCpnt->device->id, SCpnt->device->lun, ready,
 			SCpnt->device->hostdata));
 		return FAILED;
 	}
@@ -224,7 +224,7 @@ mptfc_block_error_handler(struct scsi_cm
 		"%s.%d: %d:%d, executing recovery.\n", caller,
 		((MPT_SCSI_HOST *) shost->hostdata)->ioc->name,
 		((MPT_SCSI_HOST *) shost->hostdata)->ioc->sh->host_no,
-		SCpnt->device->id,SCpnt->device->lun));
+		SCpnt->device->id, SCpnt->device->lun));
 	return (*func)(SCpnt);
 }
 
@@ -1320,8 +1320,8 @@ mptfc_probe(struct pci_dev *pdev, const 
 	sh->transportt = mptfc_transport_template;
 	error = scsi_add_host (sh, &ioc->pcidev->dev);
 	if(error) {
-		dprintk(ioc, printk(KERN_ERR MYNAM
-		  "scsi_add_host failed\n"));
+		dprintk(ioc, printk(MYIOC_s_ERR_FMT
+		  "scsi_add_host failed\n", ioc->name));
 		goto out_mptfc_probe;
 	}
 
diff -uarpN b/drivers/message/fusion/mptsas.c a/drivers/message/fusion/mptsas.c
--- b/drivers/message/fusion/mptsas.c	2007-09-13 14:30:29.000000000 -0600
+++ a/drivers/message/fusion/mptsas.c	2007-09-14 15:05:35.000000000 -0600
@@ -100,19 +100,25 @@ static void mptsas_hotplug_work(struct w
 static void mptsas_print_phy_data(MPT_ADAPTER *ioc,
 					MPI_SAS_IO_UNIT0_PHY_DATA *phy_data)
 {
-	dsasprintk(ioc, printk(KERN_DEBUG "---- IO UNIT PAGE 0 ------------\n"));
-	dsasprintk(ioc, printk(KERN_DEBUG "Handle=0x%X\n",
-		le16_to_cpu(phy_data->AttachedDeviceHandle)));
-	dsasprintk(ioc, printk(KERN_DEBUG "Controller Handle=0x%X\n",
-		le16_to_cpu(phy_data->ControllerDevHandle)));
-	dsasprintk(ioc, printk(KERN_DEBUG "Port=0x%X\n", phy_data->Port));
-	dsasprintk(ioc, printk(KERN_DEBUG "Port Flags=0x%X\n", phy_data->PortFlags));
-	dsasprintk(ioc, printk(KERN_DEBUG "PHY Flags=0x%X\n", phy_data->PhyFlags));
-	dsasprintk(ioc, printk(KERN_DEBUG "Negotiated Link Rate=0x%X\n", phy_data->NegotiatedLinkRate));
-	dsasprintk(ioc, printk(KERN_DEBUG "Controller PHY Device Info=0x%X\n",
-		le32_to_cpu(phy_data->ControllerPhyDeviceInfo)));
-	dsasprintk(ioc, printk(KERN_DEBUG "DiscoveryStatus=0x%X\n\n",
-		le32_to_cpu(phy_data->DiscoveryStatus)));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+	    "---- IO UNIT PAGE 0 ------------\n", ioc->name));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Handle=0x%X\n",
+	    ioc->name, le16_to_cpu(phy_data->AttachedDeviceHandle)));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Controller Handle=0x%X\n",
+	    ioc->name, le16_to_cpu(phy_data->ControllerDevHandle)));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Port=0x%X\n",
+	    ioc->name, phy_data->Port));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Port Flags=0x%X\n",
+	    ioc->name, phy_data->PortFlags));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT "PHY Flags=0x%X\n",
+	       	ioc->name, phy_data->PhyFlags));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Negotiated Link Rate=0x%X\n",
+	    ioc->name, phy_data->NegotiatedLinkRate));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+	    "Controller PHY Device Info=0x%X\n", ioc->name,
+	    le32_to_cpu(phy_data->ControllerPhyDeviceInfo)));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT "DiscoveryStatus=0x%X\n\n",
+	    ioc->name, le32_to_cpu(phy_data->DiscoveryStatus)));
 }
 
 static void mptsas_print_phy_pg0(MPT_ADAPTER *ioc, SasPhyPage0_t *pg0)
@@ -121,27 +127,41 @@ static void mptsas_print_phy_pg0(MPT_ADA
 
 	memcpy(&sas_address, &pg0->SASAddress, sizeof(__le64));
 
-	dsasprintk(ioc, printk(KERN_DEBUG "---- SAS PHY PAGE 0 ------------\n"));
-	dsasprintk(ioc, printk(KERN_DEBUG "Attached Device Handle=0x%X\n",
-			le16_to_cpu(pg0->AttachedDevHandle)));
-	dsasprintk(ioc, printk(KERN_DEBUG "SAS Address=0x%llX\n",
-			(unsigned long long)le64_to_cpu(sas_address)));
-	dsasprintk(ioc, printk(KERN_DEBUG "Attached PHY Identifier=0x%X\n", pg0->AttachedPhyIdentifier));
-	dsasprintk(ioc, printk(KERN_DEBUG "Attached Device Info=0x%X\n",
-			le32_to_cpu(pg0->AttachedDeviceInfo)));
-	dsasprintk(ioc, printk(KERN_DEBUG "Programmed Link Rate=0x%X\n", pg0->ProgrammedLinkRate));
-	dsasprintk(ioc, printk(KERN_DEBUG "Change Count=0x%X\n", pg0->ChangeCount));
-	dsasprintk(ioc, printk(KERN_DEBUG "PHY Info=0x%X\n\n", le32_to_cpu(pg0->PhyInfo)));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+	    "---- SAS PHY PAGE 0 ------------\n", ioc->name));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+	    "Attached Device Handle=0x%X\n", ioc->name,
+	    le16_to_cpu(pg0->AttachedDevHandle)));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT "SAS Address=0x%llX\n",
+	    ioc->name, (unsigned long long)le64_to_cpu(sas_address)));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+	    "Attached PHY Identifier=0x%X\n", ioc->name,
+	    pg0->AttachedPhyIdentifier));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Attached Device Info=0x%X\n",
+	    ioc->name, le32_to_cpu(pg0->AttachedDeviceInfo)));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Programmed Link Rate=0x%X\n",
+	    ioc->name,  pg0->ProgrammedLinkRate));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Change Count=0x%X\n",
+	    ioc->name, pg0->ChangeCount));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT "PHY Info=0x%X\n\n",
+	    ioc->name, le32_to_cpu(pg0->PhyInfo)));
 }
 
 static void mptsas_print_phy_pg1(MPT_ADAPTER *ioc, SasPhyPage1_t *pg1)
 {
-	dsasprintk(ioc, printk(KERN_DEBUG "---- SAS PHY PAGE 1 ------------\n"));
-	dsasprintk(ioc, printk(KERN_DEBUG "Invalid Dword Count=0x%x\n", pg1->InvalidDwordCount));
-	dsasprintk(ioc, printk(KERN_DEBUG "Running Disparity Error Count=0x%x\n",
-			pg1->RunningDisparityErrorCount));
-	dsasprintk(ioc, printk(KERN_DEBUG "Loss Dword Synch Count=0x%x\n", pg1->LossDwordSynchCount));
-	dsasprintk(ioc, printk(KERN_DEBUG "PHY Reset Problem Count=0x%x\n\n", pg1->PhyResetProblemCount));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+	    "---- SAS PHY PAGE 1 ------------\n", ioc->name));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Invalid Dword Count=0x%x\n",
+	    ioc->name,  pg1->InvalidDwordCount));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+	    "Running Disparity Error Count=0x%x\n", ioc->name,
+	    pg1->RunningDisparityErrorCount));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+	    "Loss Dword Synch Count=0x%x\n", ioc->name,
+	    pg1->LossDwordSynchCount));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+	    "PHY Reset Problem Count=0x%x\n\n", ioc->name,
+	    pg1->PhyResetProblemCount));
 }
 
 static void mptsas_print_device_pg0(MPT_ADAPTER *ioc, SasDevicePage0_t *pg0)
@@ -150,37 +170,53 @@ static void mptsas_print_device_pg0(MPT_
 
 	memcpy(&sas_address, &pg0->SASAddress, sizeof(__le64));
 
-	dsasprintk(ioc, printk(KERN_DEBUG "---- SAS DEVICE PAGE 0 ---------\n"));
-	dsasprintk(ioc, printk(KERN_DEBUG "Handle=0x%X\n" ,le16_to_cpu(pg0->DevHandle)));
-	dsasprintk(ioc, printk(KERN_DEBUG "Parent Handle=0x%X\n" ,le16_to_cpu(pg0->ParentDevHandle)));
-	dsasprintk(ioc, printk(KERN_DEBUG "Enclosure Handle=0x%X\n", le16_to_cpu(pg0->EnclosureHandle)));
-	dsasprintk(ioc, printk(KERN_DEBUG "Slot=0x%X\n", le16_to_cpu(pg0->Slot)));
-	dsasprintk(ioc, printk(KERN_DEBUG "SAS Address=0x%llX\n", (unsigned long long)
-	    le64_to_cpu(sas_address)));
-	dsasprintk(ioc, printk(KERN_DEBUG "Target ID=0x%X\n", pg0->TargetID));
-	dsasprintk(ioc, printk(KERN_DEBUG "Bus=0x%X\n", pg0->Bus));
-	/* The PhyNum field specifies the PHY number of the parent
-	 * device this device is linked to
-	 */
-	dsasprintk(ioc, printk(KERN_DEBUG "Parent Phy Num=0x%X\n", pg0->PhyNum));
-	dsasprintk(ioc, printk(KERN_DEBUG "Access Status=0x%X\n", le16_to_cpu(pg0->AccessStatus)));
-	dsasprintk(ioc, printk(KERN_DEBUG "Device Info=0x%X\n", le32_to_cpu(pg0->DeviceInfo)));
-	dsasprintk(ioc, printk(KERN_DEBUG "Flags=0x%X\n", le16_to_cpu(pg0->Flags)));
-	dsasprintk(ioc, printk(KERN_DEBUG "Physical Port=0x%X\n\n", pg0->PhysicalPort));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+	    "---- SAS DEVICE PAGE 0 ---------\n", ioc->name));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Handle=0x%X\n",
+	    ioc->name, le16_to_cpu(pg0->DevHandle)));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Parent Handle=0x%X\n",
+	    ioc->name, le16_to_cpu(pg0->ParentDevHandle)));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Enclosure Handle=0x%X\n",
+	    ioc->name, le16_to_cpu(pg0->EnclosureHandle)));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Slot=0x%X\n",
+	    ioc->name, le16_to_cpu(pg0->Slot)));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT "SAS Address=0x%llX\n",
+	    ioc->name, (unsigned long long)le64_to_cpu(sas_address)));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Target ID=0x%X\n",
+	    ioc->name, pg0->TargetID));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Bus=0x%X\n",
+	    ioc->name, pg0->Bus));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Parent Phy Num=0x%X\n",
+	    ioc->name, pg0->PhyNum));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Access Status=0x%X\n",
+	    ioc->name, le16_to_cpu(pg0->AccessStatus)));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Device Info=0x%X\n",
+	    ioc->name, le32_to_cpu(pg0->DeviceInfo)));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Flags=0x%X\n",
+	    ioc->name, le16_to_cpu(pg0->Flags)));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Physical Port=0x%X\n\n",
+	    ioc->name, pg0->PhysicalPort));
 }
 
 static void mptsas_print_expander_pg1(MPT_ADAPTER *ioc, SasExpanderPage1_t *pg1)
 {
-	dsasprintk(ioc, printk(KERN_DEBUG "---- SAS EXPANDER PAGE 1 ------------\n"));
-	dsasprintk(ioc, printk(KERN_DEBUG "Physical Port=0x%X\n", pg1->PhysicalPort));
-	dsasprintk(ioc, printk(KERN_DEBUG "PHY Identifier=0x%X\n", pg1->PhyIdentifier));
-	dsasprintk(ioc, printk(KERN_DEBUG "Negotiated Link Rate=0x%X\n", pg1->NegotiatedLinkRate));
-	dsasprintk(ioc, printk(KERN_DEBUG "Programmed Link Rate=0x%X\n", pg1->ProgrammedLinkRate));
-	dsasprintk(ioc, printk(KERN_DEBUG "Hardware Link Rate=0x%X\n", pg1->HwLinkRate));
-	dsasprintk(ioc, printk(KERN_DEBUG "Owner Device Handle=0x%X\n",
-			le16_to_cpu(pg1->OwnerDevHandle)));
-	dsasprintk(ioc, printk(KERN_DEBUG "Attached Device Handle=0x%X\n\n",
-			le16_to_cpu(pg1->AttachedDevHandle)));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+	    "---- SAS EXPANDER PAGE 1 ------------\n", ioc->name));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Physical Port=0x%X\n",
+	    ioc->name, pg1->PhysicalPort));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT "PHY Identifier=0x%X\n",
+	    ioc->name, pg1->PhyIdentifier));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Negotiated Link Rate=0x%X\n",
+	    ioc->name, pg1->NegotiatedLinkRate));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Programmed Link Rate=0x%X\n",
+	    ioc->name, pg1->ProgrammedLinkRate));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Hardware Link Rate=0x%X\n",
+	    ioc->name, pg1->HwLinkRate));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Owner Device Handle=0x%X\n",
+	    ioc->name, le16_to_cpu(pg1->OwnerDevHandle)));
+	dsasprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+	    "Attached Device Handle=0x%X\n\n", ioc->name,
+	    le16_to_cpu(pg1->AttachedDevHandle)));
 }
 
 static inline MPT_ADAPTER *phy_to_ioc(struct sas_phy *phy)
@@ -250,8 +286,8 @@ mptsas_port_delete(MPT_ADAPTER *ioc, str
 	port_info = port_details->port_info;
 	phy_info = port_info->phy_info;
 
-	dsaswideprintk(ioc, printk(KERN_DEBUG "%s: [%p]: num_phys=%02d "
-	    "bitmask=0x%016llX\n", __FUNCTION__, port_details,
+	dsaswideprintk(ioc, printk(MYIOC_s_DEBUG_FMT "%s: [%p]: num_phys=%02d "
+	    "bitmask=0x%016llX\n", ioc->name, __FUNCTION__, port_details,
 	    port_details->num_phys, (unsigned long long)
 	    port_details->phy_bitmask));
 
@@ -278,14 +314,15 @@ mptsas_set_rphy(MPT_ADAPTER *ioc, struct
 {
 	if (phy_info->port_details) {
 		phy_info->port_details->rphy = rphy;
-		dsaswideprintk(ioc, printk(KERN_DEBUG "sas_rphy_add: rphy=%p\n", rphy));
+		dsaswideprintk(ioc, printk(MYIOC_s_DEBUG_FMT "sas_rphy_add: rphy=%p\n",
+		    ioc->name, rphy));
 	}
 
 	if (rphy) {
-		dsaswideprintk(ioc, dev_printk(KERN_DEBUG,
-		    &rphy->dev, "add:"));
-		dsaswideprintk(ioc, printk(KERN_DEBUG "rphy=%p release=%p\n",
-			rphy, rphy->dev.release));
+		dsaswideprintk(ioc, dev_printk(MYIOC_s_DEBUG_FMT,
+		    &rphy->dev, "add:", ioc->name));
+		dsaswideprintk(ioc, printk(MYIOC_s_DEBUG_FMT "rphy=%p release=%p\n",
+		    ioc->name, rphy, rphy->dev.release));
 	}
 }
 
@@ -305,10 +342,10 @@ mptsas_set_port(MPT_ADAPTER *ioc, struct
 		phy_info->port_details->port = port;
 
 	if (port) {
-		dsaswideprintk(ioc, dev_printk(KERN_DEBUG,
-		    &port->dev, "add:"));
-		dsaswideprintk(ioc, printk(KERN_DEBUG "port=%p release=%p\n",
-			port, port->dev.release));
+		dsaswideprintk(ioc, dev_printk(MYIOC_s_DEBUG_FMT,
+		    &port->dev, "add:", ioc->name));
+		dsaswideprintk(ioc, printk(MYIOC_s_DEBUG_FMT "port=%p release=%p\n",
+		    ioc->name, port, port->dev.release));
 	}
 }
 
@@ -359,9 +396,9 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc
 		 * Removing a phy from a port, letting the last
 		 * phy be removed by firmware events.
 		 */
-		dsaswideprintk(ioc, printk(KERN_DEBUG
-			"%s: [%p]: deleting phy = %d\n",
-			__FUNCTION__, port_details, i));
+		dsaswideprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "%s: [%p]: deleting phy = %d\n",
+		    ioc->name, __FUNCTION__, port_details, i));
 		port_details->num_phys--;
 		port_details->phy_bitmask &= ~ (1 << phy_info->phy_id);
 		memset(&phy_info->attached, 0, sizeof(struct mptsas_devinfo));
@@ -375,8 +412,8 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc
 	phy_info = port_info->phy_info;
 	for (i = 0 ; i < port_info->num_phys ; i++, phy_info++) {
 		sas_address = phy_info->attached.sas_address;
-		dsaswideprintk(ioc, printk(KERN_DEBUG "phy_id=%d sas_address=0x%018llX\n",
-		    i, (unsigned long long)sas_address));
+		dsaswideprintk(ioc, printk(MYIOC_s_DEBUG_FMT "phy_id=%d sas_address=0x%018llX\n",
+		    ioc->name, i, (unsigned long long)sas_address));
 		if (!sas_address)
 			continue;
 		port_details = phy_info->port_details;
@@ -394,9 +431,9 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc
 				port_details->phy_bitmask |=
 				    (1 << phy_info->phy_id);
 			phy_info->sas_port_add_phy=1;
-			dsaswideprintk(ioc, printk(KERN_DEBUG "\t\tForming port\n\t\t"
+			dsaswideprintk(ioc, printk(MYIOC_s_DEBUG_FMT "\t\tForming port\n\t\t"
 			    "phy_id=%d sas_address=0x%018llX\n",
-			    i, (unsigned long long)sas_address));
+			    ioc->name, i, (unsigned long long)sas_address));
 			phy_info->port_details = port_details;
 		}
 
@@ -411,9 +448,9 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc
 				continue;
 			if (phy_info_cmp->port_details == port_details )
 				continue;
-			dsaswideprintk(ioc, printk(KERN_DEBUG
+			dsaswideprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 			    "\t\tphy_id=%d sas_address=0x%018llX\n",
-			    j, (unsigned long long)
+			    ioc->name, j, (unsigned long long)
 			    phy_info_cmp->attached.sas_address));
 			if (phy_info_cmp->port_details) {
 				port_details->rphy =
@@ -445,15 +482,15 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc
 		port_details = port_info->phy_info[i].port_details;
 		if (!port_details)
 			continue;
-		dsaswideprintk(ioc, printk(KERN_DEBUG
+		dsaswideprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		    "%s: [%p]: phy_id=%02d num_phys=%02d "
-		    "bitmask=0x%016llX\n", __FUNCTION__,
+		    "bitmask=0x%016llX\n", ioc->name, __FUNCTION__,
 		    port_details, i, port_details->num_phys,
 		    (unsigned long long)port_details->phy_bitmask));
-		dsaswideprintk(ioc, printk(KERN_DEBUG"\t\tport = %p rphy=%p\n",
-			port_details->port, port_details->rphy));
+		dsaswideprintk(ioc, printk(MYIOC_s_DEBUG_FMT "\t\tport = %p rphy=%p\n",
+		    ioc->name, port_details->port, port_details->rphy));
 	}
-	dsaswideprintk(ioc, printk(KERN_DEBUG"\n"));
+	dsaswideprintk(ioc, printk("\n"));
 	mutex_unlock(&ioc->sas_topology_mutex);
 }
 
@@ -1129,10 +1166,8 @@ static int mptsas_phy_reset(struct sas_p
 	/* process the completed Reply Message Frame */
 	reply = (SasIoUnitControlReply_t *)ioc->sas_mgmt.reply;
 	if (reply->IOCStatus != MPI_IOCSTATUS_SUCCESS) {
-		printk("%s: IOCStatus=0x%X IOCLogInfo=0x%X\n",
-		    __FUNCTION__,
-		    reply->IOCStatus,
-		    reply->IOCLogInfo);
+		printk(MYIOC_s_INFO_FMT "%s: IOCStatus=0x%X IOCLogInfo=0x%X\n",
+		    ioc->name, __FUNCTION__, reply->IOCStatus, reply->IOCLogInfo);
 		error = -ENXIO;
 		goto out_unlock;
 	}
@@ -1218,16 +1253,16 @@ static int mptsas_smp_handler(struct Scs
 	u64 sas_address = 0;
 
 	if (!rsp) {
-		printk(KERN_ERR "%s: the smp response space is missing\n",
-		       __FUNCTION__);
+		printk(MYIOC_s_ERR_FMT "%s: the smp response space is missing\n",
+		    ioc->name, __FUNCTION__);
 		return -EINVAL;
 	}
 
 	/* do we need to support multiple segments? */
 	if (req->bio->bi_vcnt > 1 || rsp->bio->bi_vcnt > 1) {
-		printk(KERN_ERR "%s: multiple segments req %u %u, rsp %u %u\n",
-		       __FUNCTION__, req->bio->bi_vcnt, req->data_len,
-		       rsp->bio->bi_vcnt, rsp->data_len);
+		printk(MYIOC_s_ERR_FMT "%s: multiple segments req %u %u, rsp %u %u\n",
+		    ioc->name, __FUNCTION__, req->bio->bi_vcnt, req->data_len,
+		    rsp->bio->bi_vcnt, rsp->data_len);
 		return -EINVAL;
 	}
 
@@ -1292,7 +1327,7 @@ static int mptsas_smp_handler(struct Scs
 
 	timeleft = wait_for_completion_timeout(&ioc->sas_mgmt.done, 10 * HZ);
 	if (!timeleft) {
-		printk(KERN_ERR "%s: smp timeout!\n", __FUNCTION__);
+		printk(MYIOC_s_ERR_FMT "%s: smp timeout!\n", ioc->name, __FUNCTION__);
 		/* On timeout reset the board */
 		mpt_HardResetHandler(ioc, CAN_SLEEP);
 		ret = -ETIMEDOUT;
@@ -1307,8 +1342,8 @@ static int mptsas_smp_handler(struct Scs
 		memcpy(req->sense, smprep, sizeof(*smprep));
 		req->sense_len = sizeof(*smprep);
 	} else {
-		printk(KERN_ERR "%s: smp passthru reply failed to be returned\n",
-		       __FUNCTION__);
+		printk(MYIOC_s_ERR_FMT "%s: smp passthru reply failed to be returned\n",
+		    ioc->name, __FUNCTION__);
 		ret = -ENXIO;
 	}
 unmap:
@@ -1952,12 +1987,12 @@ static int mptsas_probe_one_phy(struct d
 				goto out;
 			}
 			mptsas_set_port(ioc, phy_info, port);
-			dsaswideprintk(ioc, printk(KERN_DEBUG
+			dsaswideprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 			    "sas_port_alloc: port=%p dev=%p port_id=%d\n",
-			    port, dev, port->port_identifier));
+			    ioc->name, port, dev, port->port_identifier));
 		}
-		dsaswideprintk(ioc, printk(KERN_DEBUG "sas_port_add_phy: phy_id=%d\n",
-		    phy_info->phy_id));
+		dsaswideprintk(ioc, printk(MYIOC_s_DEBUG_FMT "sas_port_add_phy: phy_id=%d\n",
+		    ioc->name, phy_info->phy_id));
 		sas_port_add_phy(port, phy_info->phy);
 		phy_info->sas_port_add_phy = 0;
 	}
@@ -2259,8 +2294,8 @@ mptsas_delete_expander_phys(MPT_ADAPTER 
 					expander_sas_address)
 					continue;
 				dsaswideprintk(ioc,
-					dev_printk(KERN_DEBUG, &port->dev,
-					"delete port (%d)\n", port->port_identifier));
+				    dev_printk(MYIOC_s_DEBUG_FMT, &port->dev,
+				    "delete port (%d)\n", ioc->name, port->port_identifier));
 				sas_port_delete(port);
 				mptsas_port_delete(ioc, phy_info->port_details);
 			}
@@ -2503,7 +2538,7 @@ mptsas_adding_inactive_raid_components(M
 
 		ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
 		if (!ev) {
-			printk(KERN_WARNING "mptsas: lost hotplug event\n");
+			printk(MYIOC_s_WARN_FMT "mptsas: lost hotplug event\n", ioc->name);
 			goto out;
 		}
 
@@ -2644,8 +2679,8 @@ mptsas_hotplug_work(struct work_struct *
 		printk(MYIOC_s_INFO_FMT
 		       "removing %s device, channel %d, id %d, phy %d\n",
 		       ioc->name, ds, ev->channel, ev->id, phy_info->phy_id);
-		dev_printk(KERN_DEBUG, &port->dev,
-		    "delete port (%d)\n", port->port_identifier);
+		dev_printk(MYIOC_s_DEBUG_FMT, &port->dev,
+		    "delete port (%d)\n", ioc->name, port->port_identifier);
 		sas_port_delete(port);
 		mptsas_port_delete(ioc, phy_info->port_details);
 		break;
@@ -2686,8 +2721,8 @@ mptsas_hotplug_work(struct work_struct *
 
 			if (!vtarget) {
 				dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
-					"%s: exit at line=%d\n", ioc->name,
-				       	__FUNCTION__, __LINE__));
+				    "%s: exit at line=%d\n", ioc->name,
+				    __FUNCTION__, __LINE__));
 				break;
 			}
 			/*
@@ -2820,7 +2855,7 @@ mptsas_send_sas_event(MPT_ADAPTER *ioc,
 	case MPI_EVENT_SAS_DEV_STAT_RC_ADDED:
 		ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
 		if (!ev) {
-			printk(KERN_WARNING "mptsas: lost hotplug event\n");
+			printk(MYIOC_s_WARN_FMT "lost hotplug event\n", ioc->name);
 			break;
 		}
 
@@ -2879,7 +2914,7 @@ mptsas_send_raid_event(MPT_ADAPTER *ioc,
 
 	ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
 	if (!ev) {
-		printk(KERN_WARNING "mptsas: lost hotplug event\n");
+		printk(MYIOC_s_WARN_FMT "lost hotplug event\n", ioc->name);
 		return;
 	}
 
@@ -3230,8 +3265,8 @@ mptsas_probe(struct pci_dev *pdev, const
 
 	error = scsi_add_host(sh, &ioc->pcidev->dev);
 	if (error) {
-		dprintk(ioc, printk(KERN_ERR MYNAM
-		  "scsi_add_host failed\n"));
+		dprintk(ioc, printk(MYIOC_s_ERR_FMT
+		  "scsi_add_host failed\n", ioc->name));
 		goto out_mptsas_probe;
 	}
 
diff -uarpN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2007-09-13 14:30:29.000000000 -0600
+++ a/drivers/message/fusion/mptscsih.c	2007-09-14 14:58:22.000000000 -0600
@@ -192,7 +192,7 @@ mptscsih_getFreeChainBuffer(MPT_ADAPTER 
 	int chain_idx;
 
 	dsgprintk(ioc, printk(MYIOC_s_DEBUG_FMT "getFreeChainBuffer called\n",
-			ioc->name));
+	    ioc->name));
 	spin_lock_irqsave(&ioc->FreeQlock, flags);
 	if (!list_empty(&ioc->FreeChainQ)) {
 		int offset;
@@ -203,13 +203,14 @@ mptscsih_getFreeChainBuffer(MPT_ADAPTER 
 		offset = (u8 *)chainBuf - (u8 *)ioc->ChainBuffer;
 		chain_idx = offset / ioc->req_sz;
 		rc = SUCCESS;
-		dsgprintk(ioc, printk(MYIOC_s_DEBUG_FMT "getFreeChainBuffer chainBuf=%p ChainBuffer=%p offset=%d chain_idx=%d\n",
-			ioc->name, chainBuf, ioc->ChainBuffer, offset, chain_idx));
+		dsgprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "getFreeChainBuffer chainBuf=%p ChainBuffer=%p offset=%d chain_idx=%d\n",
+		    ioc->name, chainBuf, ioc->ChainBuffer, offset, chain_idx));
 	} else {
 		rc = FAILED;
 		chain_idx = MPT_HOST_NO_CHAIN;
-		dfailprintk(ioc, printk(MYIOC_s_DEBUG_FMT "getFreeChainBuffer failed\n",
-			ioc->name));
+		dfailprintk(ioc, printk(MYIOC_s_ERR_FMT "getFreeChainBuffer failed\n",
+		    ioc->name));
 	}
 	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
 
@@ -419,8 +420,8 @@ nextSGEset:
 		 *   out the Address and Flags fields.
 		 */
 		chainSge = (char *) psge;
-		dsgprintk(ioc, printk(KERN_DEBUG "  Current buff @ %p (index 0x%x)",
-				psge, req_idx));
+		dsgprintk(ioc, printk(MYIOC_s_DEBUG_FMT "  Current buff @ %p (index 0x%x)",
+		    ioc->name, psge, req_idx));
 
 		/* Start the SGE for the next buffer
 		 */
@@ -428,8 +429,8 @@ nextSGEset:
 		sgeOffset = 0;
 		sg_done = 0;
 
-		dsgprintk(ioc, printk(KERN_DEBUG "  Chain buff @ %p (index 0x%x)\n",
-				psge, chain_idx));
+		dsgprintk(ioc, printk(MYIOC_s_DEBUG_FMT "  Chain buff @ %p (index 0x%x)\n",
+		    ioc->name, psge, chain_idx));
 
 		/* Start the SGE for the next buffer
 		 */
@@ -588,18 +589,17 @@ mptscsih_info_scsiio(MPT_ADAPTER *ioc, s
 	}
 
 	scsi_print_command(sc);
-	printk(KERN_DEBUG "\tfw_channel = %d, fw_id = %d\n",
-	    pScsiReply->Bus, pScsiReply->TargetID);
-	printk(KERN_DEBUG "\trequest_len = %d, underflow = %d, resid = %d\n",
-	    scsi_bufflen(sc), sc->underflow, scsi_get_resid(sc));
-	printk(KERN_DEBUG "\ttag = %d, transfer_count = %d, sc->result = %08X\n",
-	    le16_to_cpu(pScsiReply->TaskTag),
+	printk(MYIOC_s_DEBUG_FMT "\tfw_channel = %d, fw_id = %d\n",
+	    ioc->name, pScsiReply->Bus, pScsiReply->TargetID);
+	printk(MYIOC_s_DEBUG_FMT "\trequest_len = %d, underflow = %d, "
+	    "resid = %d\n", ioc->name, scsi_bufflen(sc), sc->underflow,
+	    scsi_get_resid(sc));
+	printk(MYIOC_s_DEBUG_FMT "\ttag = %d, transfer_count = %d, "
+	    "sc->result = %08X\n", ioc->name, le16_to_cpu(pScsiReply->TaskTag),
 	    le32_to_cpu(pScsiReply->TransferCount), sc->result);
-
-	printk(KERN_DEBUG "\tiocstatus = %s (0x%04x), "
+	printk(MYIOC_s_DEBUG_FMT "\tiocstatus = %s (0x%04x), "
 	    "scsi_status = %s (0x%02x), scsi_state = (0x%02x)\n",
-	    desc, ioc_status,
-	    desc1, pScsiReply->SCSIStatus,
+	    ioc->name, desc, ioc_status, desc1, pScsiReply->SCSIStatus,
 	    pScsiReply->SCSIState);
 
 	if (pScsiReply->SCSIState & MPI_SCSI_STATE_AUTOSENSE_VALID) {
@@ -607,9 +607,8 @@ mptscsih_info_scsiio(MPT_ADAPTER *ioc, s
 		asc = sc->sense_buffer[12];
 		ascq = sc->sense_buffer[13];
 
-		printk(KERN_DEBUG "\t[sense_key,asc,ascq]: "
-		    "[0x%02x,0x%02x,0x%02x]\n",
-		    skey, asc, ascq);
+		printk(MYIOC_s_DEBUG_FMT "\t[sense_key,asc,ascq]: "
+		    "[0x%02x,0x%02x,0x%02x]\n", ioc->name, skey, asc, ascq);
 	}
 
 	/*
@@ -617,8 +616,8 @@ mptscsih_info_scsiio(MPT_ADAPTER *ioc, s
 	 */
 	if (pScsiReply->SCSIState & MPI_SCSI_STATE_RESPONSE_INFO_VALID &&
 	    pScsiReply->ResponseInfo)
-		printk(KERN_DEBUG "response_info = %08xh\n",
-		    le32_to_cpu(pScsiReply->ResponseInfo));
+		printk(MYIOC_s_DEBUG_FMT "response_info = %08xh\n",
+		    ioc->name, le32_to_cpu(pScsiReply->ResponseInfo));
 }
 #endif
 
@@ -738,8 +737,8 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 		 */
 		if (scsi_state & MPI_SCSI_STATE_RESPONSE_INFO_VALID &&
 		    pScsiReply->ResponseInfo) {
-			printk(KERN_NOTICE "[%d:%d:%d:%d] "
-			"FCP_ResponseInfo=%08xh\n",
+			printk(MYIOC_s_NOTE_FMT "[%d:%d:%d:%d] "
+			"FCP_ResponseInfo=%08xh\n", ioc->name,
 			sc->device->host->host_no, sc->device->channel,
 			sc->device->id, sc->device->lun,
 			le32_to_cpu(pScsiReply->ResponseInfo));
@@ -824,9 +823,9 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 				sc->result=DID_SOFT_ERROR << 16;
 			else /* Sufficient data transfer occurred */
 				sc->result = (DID_OK << 16) | scsi_status;
-			dreplyprintk(ioc, printk(KERN_DEBUG
+			dreplyprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 			    "RESIDUAL_MISMATCH: result=%x on channel=%d id=%d\n",
-			    sc->result, sc->device->channel, sc->device->id));
+			    ioc->name, sc->result, sc->device->channel, sc->device->id));
 			break;
 
 		case MPI_IOCSTATUS_SCSI_DATA_UNDERRUN:		/* 0x0045 */
@@ -858,9 +857,11 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 			}
 
 
-			dreplyprintk(ioc, printk(KERN_DEBUG "  sc->underflow={report ERR if < %02xh bytes xfer'd}\n",
-					sc->underflow));
-			dreplyprintk(ioc, printk(KERN_DEBUG "  ActBytesXferd=%02xh\n", xfer_cnt));
+			dreplyprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+			    "  sc->underflow={report ERR if < %02xh bytes xfer'd}\n",
+			    ioc->name, sc->underflow));
+			dreplyprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+			    "  ActBytesXferd=%02xh\n", ioc->name, xfer_cnt));
 
 			/* Report Queue Full
 			 */
@@ -974,7 +975,7 @@ mptscsih_flush_running_cmds(MPT_SCSI_HOS
 	int		 ii;
 	int		 max = ioc->req_depth;
 
-	dprintk(ioc, printk(KERN_DEBUG MYNAM ": flush_ScsiLookup called\n"));
+	dprintk(ioc, printk(MYIOC_s_DEBUG_FMT ": flush_ScsiLookup called\n", ioc->name));
 	for (ii= 0; ii < max; ii++) {
 		if ((SCpnt = hd->ScsiLookup[ii]) != NULL) {
 
@@ -986,8 +987,8 @@ mptscsih_flush_running_cmds(MPT_SCSI_HOS
 			hd->ScsiLookup[ii] = NULL;
 
 			mf = MPT_INDEX_2_MFPTR(ioc, ii);
-			dmfprintk(ioc, printk(KERN_DEBUG MYNAM ": flush: ScsiDone (mf=%p,sc=%p)\n",
-					mf, SCpnt));
+			dmfprintk(ioc, printk(MYIOC_s_DEBUG_FMT ": flush: ScsiDone (mf=%p,sc=%p)\n",
+			    ioc->name, mf, SCpnt));
 
 			/* Free Chain buffers */
 			mptscsih_freeChainBuffers(ioc, ii);
@@ -1036,8 +1037,8 @@ mptscsih_search_running_cmds(MPT_SCSI_HO
 	struct scsi_cmnd *sc;
 	struct scsi_lun  lun;
 
-	dsprintk(hd->ioc, printk(KERN_DEBUG MYNAM ": search_running channel %d id %d lun %d max %d\n",
-	    vdevice->vtarget->channel, vdevice->vtarget->id, vdevice->lun, max));
+	dsprintk(hd->ioc, printk(MYIOC_s_DEBUG_FMT ": search_running channel %d id %d lun %d max %d\n",
+	    hd->ioc->name, vdevice->vtarget->channel, vdevice->vtarget->id, vdevice->lun, max));
 
 	for (ii=0; ii < max; ii++) {
 		if ((sc = hd->ScsiLookup[ii]) != NULL) {
@@ -1069,8 +1070,8 @@ mptscsih_search_running_cmds(MPT_SCSI_HO
 			scsi_dma_unmap(sc);
 			sc->host_scribble = NULL;
 			sc->result = DID_NO_CONNECT << 16;
-			sdev_printk(KERN_INFO, sc->device, "completing cmds: fw_channel %d,"
-			   "fw_id %d, sc=%p, mf = %p, idx=%x\n", vdevice->vtarget->channel,
+			sdev_printk(MYIOC_s_INFO_FMT, sc->device, "completing cmds: fw_channel %d,"
+			   "fw_id %d, sc=%p, mf = %p, idx=%x\n", hd->ioc->name, vdevice->vtarget->channel,
 			   vdevice->vtarget->id, sc, mf, ii);
 			sc->scsi_done(sc);
 		}
@@ -1475,7 +1476,7 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, v
 	mpt_put_msg_frame(hd->ioc->DoneCtx, hd->ioc, mf);
 	dmfprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Issued SCSI cmd (%p) mf=%p idx=%d\n",
 			ioc->name, SCpnt, mf, my_idx));
-	DBG_DUMP_REQUEST_FRAME(ioc, (u32 *)mf)
+	DBG_DUMP_REQUEST_FRAME(ioc, (u32 *)mf);
 	return 0;
 
  fail:
@@ -1590,18 +1591,18 @@ mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8
 	 */
 	if (mptscsih_tm_pending_wait(hd) == FAILED) {
 		if (type == MPI_SCSITASKMGMT_TASKTYPE_ABORT_TASK) {
-			dtmprintk(ioc, printk(KERN_DEBUG MYNAM ": %s: TMHandler abort: "
+			dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "TMHandler abort: "
 			   "Timed out waiting for last TM (%d) to complete! \n",
 			   ioc->name, hd->tmPending));
 			return FAILED;
 		} else if (type == MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET) {
-			dtmprintk(ioc, printk(KERN_DEBUG MYNAM ": %s: TMHandler target "
+			dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "TMHandler target "
 				"reset: Timed out waiting for last TM (%d) "
 				"to complete! \n", ioc->name,
 				hd->tmPending));
 			return FAILED;
 		} else if (type == MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS) {
-			dtmprintk(ioc, printk(KERN_DEBUG MYNAM ": %s: TMHandler bus reset: "
+			dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "TMHandler bus reset: "
 			   "Timed out waiting for last TM (%d) to complete! \n",
 			  ioc->name, hd->tmPending));
 			return FAILED;
@@ -1618,10 +1619,10 @@ mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8
 		printk(MYIOC_s_WARN_FMT
 			"TM Handler for type=%x: IOC Not operational (0x%x)!\n",
 			ioc->name, type, ioc_raw_state);
-		printk(KERN_WARNING " Issuing HardReset!!\n");
+		printk(MYIOC_s_WARN_FMT " Issuing HardReset!!\n", ioc->name);
 		if (mpt_HardResetHandler(ioc, CAN_SLEEP) < 0)
-			printk((KERN_WARNING "TMHandler: HardReset "
-				"FAILED!!\n"));
+			printk(MYIOC_s_WARN_FMT "TMHandler: HardReset "
+			    "FAILED!!\n", ioc->name);
 		return FAILED;
 	}
 
@@ -1806,8 +1807,8 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 	if ((hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata) == NULL) {
 		SCpnt->result = DID_RESET << 16;
 		SCpnt->scsi_done(SCpnt);
-		printk(KERN_DEBUG MYNAM ": mptscsih_abort: Can't locate "
-		    "host! (sc=%p)\n", SCpnt);
+		printk(KERN_ERR MYNAM ": task abort: "
+		    "can't locate host! (sc=%p)\n", SCpnt);
 		return FAILED;
 	}
 
@@ -1818,8 +1819,9 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 
 	vdevice = SCpnt->device->hostdata;
 	if (!vdevice || !vdevice->vtarget) {
-		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "task abort: device has been "
-		    "deleted (sc=%p)\n", ioc->name, SCpnt));
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "task abort: device has been deleted (sc=%p)\n",
+		    ioc->name, SCpnt));
 		SCpnt->result = DID_NO_CONNECT << 16;
 		SCpnt->scsi_done(SCpnt);
 		retval = 0;
@@ -1829,8 +1831,9 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 	/* Task aborts are not supported for hidden raid components.
 	 */
 	if (vdevice->vtarget->tflags & MPT_TARGET_FLAGS_RAID_COMPONENT) {
-		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "task abort: hidden raid "
-		    "component (sc=%p)\n", ioc->name, SCpnt));
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "task abort: hidden raid component (sc=%p)\n",
+		    ioc->name, SCpnt));
 		SCpnt->result = DID_RESET << 16;
 		retval = FAILED;
 		goto out;
@@ -1843,7 +1846,7 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 		 * Do OS callback.
 		 */
 		SCpnt->result = DID_RESET << 16;
-		dtmprintk(ioc, printk(KERN_DEBUG MYNAM ": %s: mptscsih_abort: "
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "task abort: "
 		   "Command not in the active list! (sc=%p)\n", ioc->name,
 		   SCpnt));
 		retval = 0;
@@ -1908,8 +1911,8 @@ mptscsih_dev_reset(struct scsi_cmnd * SC
 	/* If we can't locate our host adapter structure, return FAILED status.
 	 */
 	if ((hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata) == NULL){
-		printk(KERN_DEBUG MYNAM ": mptscsih_dev_reset: Can't "
-		    "locate host! (sc=%p)\n", SCpnt);
+		printk(KERN_ERR MYNAM ": target reset: "
+		   "Can't locate host! (sc=%p)\n", SCpnt);
 		return FAILED;
 	}
 
@@ -1971,8 +1974,8 @@ mptscsih_bus_reset(struct scsi_cmnd * SC
 	/* If we can't locate our host adapter structure, return FAILED status.
 	 */
 	if ((hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata) == NULL){
-		printk(KERN_DEBUG MYNAM ": mptscsih_bus_reset: Can't "
-		    "locate host! (sc=%p)\n", SCpnt );
+		printk(KERN_ERR MYNAM ": bus reset: "
+		   "Can't locate host! (sc=%p)\n", SCpnt);
 		return FAILED;
 	}
 
@@ -2015,8 +2018,8 @@ mptscsih_host_reset(struct scsi_cmnd *SC
 
 	/*  If we can't locate the host to reset, then we failed. */
 	if ((hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata) == NULL){
-		printk( KERN_DEBUG MYNAM ": mptscsih_host_reset: Can't "
-		    "locate host! (sc=%p)\n", SCpnt);
+		printk(KERN_ERR MYNAM ": host reset: "
+		    "Can't locate host! (sc=%p)\n", SCpnt);
 		return FAILED;
 	}
 
@@ -2229,7 +2232,7 @@ mptscsih_taskmgmt_complete(MPT_ADAPTER *
 		if (iocstatus == MPI_IOCSTATUS_SCSI_TASK_MGMT_FAILED ||
 		    hd->cmdPtr)
 			if (mpt_HardResetHandler(ioc, NO_SLEEP) < 0)
-				printk((KERN_WARNING " Firmware Reload FAILED!!\n"));
+				printk(MYIOC_s_WARN_FMT " Firmware Reload FAILED!!\n", ioc->name);
 		break;
 
 	case MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET:
@@ -2576,10 +2579,10 @@ mptscsih_ioc_reset(MPT_ADAPTER *ioc, int
 	unsigned long	 flags;
 	int 		ii;
 
-	dtmprintk(ioc, printk(KERN_DEBUG MYNAM
-			": IOC %s_reset routed to SCSI host driver!\n",
-			reset_phase==MPT_IOC_SETUP_RESET ? "setup" : (
-			reset_phase==MPT_IOC_PRE_RESET ? "pre" : "post")));
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+	    ": IOC %s_reset routed to SCSI host driver!\n",
+	    ioc->name, reset_phase==MPT_IOC_SETUP_RESET ? "setup" : (
+	    reset_phase==MPT_IOC_PRE_RESET ? "pre" : "post")));
 
 	/* If a FW reload request arrives after base installed but
 	 * before all scsi hosts have been attached, then an alt_ioc
@@ -2719,7 +2722,8 @@ mptscsih_event_process(MPT_ADAPTER *ioc,
 	case MPI_EVENT_STATE_CHANGE:			/* 02 */
 	case MPI_EVENT_EVENT_CHANGE:			/* 0A */
 	default:
-		dprintk(ioc, printk(KERN_DEBUG MYNAM ": Ignoring event (=%02Xh)\n", event));
+		dprintk(ioc, printk(MYIOC_s_DEBUG_FMT ": Ignoring event (=%02Xh)\n",
+		    ioc->name, event));
 		break;
 	}
 
@@ -2852,8 +2856,8 @@ mptscsih_scandv_complete(MPT_ADAPTER *io
 							SCSI_STD_SENSE_BYTES);
 				memcpy(hd->pLocal->sense, sense_data, sz);
 
-				ddvprintk(ioc, printk(KERN_DEBUG "  Check Condition, sense ptr %p\n",
-						sense_data));
+				ddvprintk(ioc, printk(MYIOC_s_DEBUG_FMT "  Check Condition, sense ptr %p\n",
+				    ioc->name, sense_data));
 			} else if (pReply->SCSIState & MPI_SCSI_STATE_AUTOSENSE_FAILED) {
 				if (pReq->CDB[0] == INQUIRY)
 					completionCode = MPT_SCANDV_ISSUE_SENSE;
@@ -3085,8 +3089,8 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTER
 	/* Get and Populate a free Frame
 	 */
 	if ((mf = mpt_get_msg_frame(hd->ioc->InternalCtx, hd->ioc)) == NULL) {
-		ddvprintk(hd->ioc, printk(MYIOC_s_DEBUG_FMT "No msg frames!\n",
-					hd->ioc->name));
+		dfailprintk(hd->ioc, printk(MYIOC_s_WARN_FMT "No msg frames!\n",
+		    hd->ioc->name));
 		return -EBUSY;
 	}
 
diff -uarpN b/drivers/message/fusion/mptspi.c a/drivers/message/fusion/mptspi.c
--- b/drivers/message/fusion/mptspi.c	2007-09-13 14:30:29.000000000 -0600
+++ a/drivers/message/fusion/mptspi.c	2007-09-14 17:24:00.000000000 -0600
@@ -139,8 +139,9 @@ mptspi_setTargetNegoParms(MPT_SCSI_HOST 
 					factor = MPT_ULTRA320;
 					if (scsi_device_qas(sdev)) {
 						ddvprintk(hd->ioc,
-						printk(KERN_DEBUG "Enabling QAS due to "
-						"byte56=%02x on id=%d!\n", scsi_device_qas(sdev), id));
+						printk(MYIOC_s_DEBUG_FMT "Enabling QAS due to "
+						"byte56=%02x on id=%d!\n", hd->ioc->name,
+						scsi_device_qas(sdev), id));
 						noQas = 0;
 					}
 					if (sdev->type == TYPE_TAPE &&
@@ -227,8 +228,8 @@ mptspi_setTargetNegoParms(MPT_SCSI_HOST 
 		/* Disable QAS in a mixed configuration case
 		 */
 
-		ddvprintk(hd->ioc, printk(KERN_DEBUG
-			"Disabling QAS due to noQas=%02x on id=%d!\n", noQas, id));
+		ddvprintk(hd->ioc, printk(MYIOC_s_DEBUG_FMT
+			"Disabling QAS due to noQas=%02x on id=%d!\n", hd->ioc->name, noQas, id));
 	}
 }
 
@@ -302,7 +303,7 @@ mptspi_writeIOCPage4(MPT_SCSI_HOST *hd, 
 
 	ddvprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		"writeIOCPage4: MaxSEP=%d ActiveSEP=%d id=%d bus=%d\n",
-			ioc->name, IOCPage4Ptr->MaxSEP, IOCPage4Ptr->ActiveSEP, id, channel));
+		ioc->name, IOCPage4Ptr->MaxSEP, IOCPage4Ptr->ActiveSEP, id, channel));
 
 	mpt_put_msg_frame(ioc->DoneCtx, ioc, mf);
 
@@ -425,8 +426,8 @@ static int mptspi_target_alloc(struct sc
 	if (starget->channel == 0 &&
 	    mptspi_is_raid(hd, starget->id)) {
 		vtarget->raidVolume = 1;
-		ddvprintk(hd->ioc, printk(KERN_DEBUG
-		    "RAID Volume @ channel=%d id=%d\n", starget->channel,
+		ddvprintk(hd->ioc, printk(MYIOC_s_DEBUG_FMT
+		    "RAID Volume @ channel=%d id=%d\n", hd->ioc->name, starget->channel,
 		    starget->id));
 	}
 
@@ -532,7 +533,8 @@ static int mptspi_read_spi_device_pg0(st
 
 	pg0 = dma_alloc_coherent(&ioc->pcidev->dev, size, &pg0_dma, GFP_KERNEL);
 	if (pg0 == NULL) {
-		starget_printk(KERN_ERR, starget, "dma_alloc_coherent for parameters failed\n");
+		starget_printk(MYIOC_s_ERR_FMT, starget,
+		    "dma_alloc_coherent for parameters failed\n", ioc->name);
 		return -EINVAL;
 	}
 
@@ -552,7 +554,7 @@ static int mptspi_read_spi_device_pg0(st
 	cfg.pageAddr = starget->id;
 
 	if (mpt_config(ioc, &cfg)) {
-		starget_printk(KERN_ERR, starget, "mpt_config failed\n");
+		starget_printk(MYIOC_s_ERR_FMT, starget, "mpt_config failed\n", ioc->name);
 		goto out_free;
 	}
 	err = 0;
@@ -673,8 +675,8 @@ static void mptspi_dv_device(struct _MPT
 	/* If this is a piece of a RAID, then quiesce first */
 	if (sdev->channel == 1 &&
 	    mptscsih_quiesce_raid(hd, 1, vtarget->channel, vtarget->id) < 0) {
-		starget_printk(KERN_ERR, scsi_target(sdev),
-			       "Integrated RAID quiesce failed\n");
+		starget_printk(MYIOC_s_ERR_FMT, scsi_target(sdev),
+		    "Integrated RAID quiesce failed\n", hd->ioc->name);
 		return;
 	}
 
@@ -684,8 +686,8 @@ static void mptspi_dv_device(struct _MPT
 
 	if (sdev->channel == 1 &&
 	    mptscsih_quiesce_raid(hd, 0, vtarget->channel, vtarget->id) < 0)
-		starget_printk(KERN_ERR, scsi_target(sdev),
-			       "Integrated RAID resume failed\n");
+		starget_printk(MYIOC_s_ERR_FMT, scsi_target(sdev),
+		    "Integrated RAID resume failed\n", hd->ioc->name);
 
 	mptspi_read_parameters(sdev->sdev_target);
 	spi_display_xfer_agreement(sdev->sdev_target);
@@ -847,7 +849,8 @@ static int mptspi_write_spi_device_pg1(s
 
 	pg1 = dma_alloc_coherent(&ioc->pcidev->dev, size, &pg1_dma, GFP_KERNEL);
 	if (pg1 == NULL) {
-		starget_printk(KERN_ERR, starget, "dma_alloc_coherent for parameters failed\n");
+		starget_printk(MYIOC_s_ERR_FMT, starget,
+		    "dma_alloc_coherent for parameters failed\n", ioc->name);
 		return -EINVAL;
 	}
 
@@ -876,7 +879,8 @@ static int mptspi_write_spi_device_pg1(s
 	mptspi_print_write_nego(hd, starget, le32_to_cpu(pg1->RequestedParameters));
 
 	if (mpt_config(ioc, &cfg)) {
-		starget_printk(KERN_ERR, starget, "mpt_config failed\n");
+		starget_printk(MYIOC_s_ERR_FMT, starget,
+		    "mpt_config failed\n", ioc->name);
 		goto out_free;
 	}
 	err = 0;
@@ -1092,12 +1096,12 @@ static void mpt_work_wrapper(struct work
 		if(vtarget->id != disk)
 			continue;
 
-		starget_printk(KERN_INFO, vtarget->starget,
-			       "Integrated RAID requests DV of new device\n");
+		starget_printk(MYIOC_s_INFO_FMT, vtarget->starget,
+		    "Integrated RAID requests DV of new device\n", hd->ioc->name);
 		mptspi_dv_device(hd, sdev);
 	}
-	shost_printk(KERN_INFO, shost,
-		     "Integrated RAID detects new device %d\n", disk);
+	shost_printk(MYIOC_s_INFO_FMT, shost,
+	    "Integrated RAID detects new device %d\n", hd->ioc->name, disk);
 	scsi_scan_target(&hd->ioc->sh->shost_gendev, 1, disk, 0, 1);
 }
 
@@ -1107,9 +1111,9 @@ static void mpt_dv_raid(struct _MPT_SCSI
 	struct work_queue_wrapper *wqw = kmalloc(sizeof(*wqw), GFP_ATOMIC);
 
 	if (!wqw) {
-		shost_printk(KERN_ERR, hd->ioc->sh,
-			     "Failed to act on RAID event for physical disk %d\n",
-			   disk);
+		shost_printk(MYIOC_s_ERR_FMT, hd->ioc->sh,
+		    "Failed to act on RAID event for physical disk %d\n",
+		    hd->ioc->name, disk);
 		return;
 	}
 	INIT_WORK(&wqw->work, mpt_work_wrapper);
@@ -1418,7 +1422,7 @@ mptspi_probe(struct pci_dev *pdev, const
 
 	if (numSGE < sh->sg_tablesize) {
 		/* Reset this value */
-		dprintk(ioc, printk(MYIOC_s_INFO_FMT
+		dprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		  "Resetting sg_tablesize to %d from %d\n",
 		  ioc->name, numSGE, sh->sg_tablesize));
 		sh->sg_tablesize = numSGE;
@@ -1484,8 +1488,8 @@ mptspi_probe(struct pci_dev *pdev, const
 
 	error = scsi_add_host (sh, &ioc->pcidev->dev);
 	if(error) {
-		dprintk(ioc, printk(KERN_ERR MYNAM
-		  "scsi_add_host failed\n"));
+		dprintk(ioc, printk(MYIOC_s_ERR_FMT
+		  "scsi_add_host failed\n", ioc->name));
 		goto out_mptspi_probe;
 	}
 
