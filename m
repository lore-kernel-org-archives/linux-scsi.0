From: "Prakash, Sathya" <sathya.prakash@lsi.com>
Subject: [PATCH 2/5] mpt fusion: Changes in mptbase.c for logging support
Date: Tue, 24 Jul 2007 15:42:08 +0530
Message-ID: <20070724101206.GC1831@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:42759 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761947AbXGXKOh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jul 2007 06:14:37 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id l6OADGcV000414
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jul 2007 03:13:16 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: eric.moore@lsi.com

This patch contains changes in mptbase.c to support logging in MPT fusion
drivers.

The changes are majorly in debug printks, the existing debugprintk are
modified accroding to new debug macros defined in the file mptbdebug.h

A new module parameter mpt_debug_level is added to pass the debug level as
module parameter.

signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
---

diff -Naurp b/drivers/message/fusion/mptbase.c a/drivers/message/fusion/mptbase.c
--- b/drivers/message/fusion/mptbase.c	2007-07-23 14:24:35.000000000 +0530
+++ a/drivers/message/fusion/mptbase.c	2007-07-23 16:40:27.000000000 +0530
@@ -87,6 +87,10 @@ static int mpt_channel_mapping;
 module_param(mpt_channel_mapping, int, 0);
 MODULE_PARM_DESC(mpt_channel_mapping, " Mapping id's to channels (default=0)");
 
+static int mpt_debug_level;
+module_param(mpt_debug_level, int, 0);
+MODULE_PARM_DESC(mpt_debug_level, " debug level - refer to mptdebug.h - (default=0)");
+
 #ifdef MFCNT
 static int mfcounter = 0;
 #define PRINT_MF_COUNT 20000
@@ -179,9 +183,7 @@ static void	mpt_get_fw_exp_ver(char *buf
 
 //int		mpt_HardResetHandler(MPT_ADAPTER *ioc, int sleepFlag);
 static int	ProcessEventNotification(MPT_ADAPTER *ioc, EventNotificationReply_t *evReply, int *evHandlers);
-#ifdef MPT_DEBUG_REPLY
 static void	mpt_iocstatus_info(MPT_ADAPTER *ioc, u32 ioc_status, MPT_FRAME_HDR *mf);
-#endif
 static void	mpt_fc_log_info(MPT_ADAPTER *ioc, u32 log_info);
 static void	mpt_spi_log_info(MPT_ADAPTER *ioc, u32 log_info);
 static void	mpt_sas_log_info(MPT_ADAPTER *ioc, u32 log_info);
@@ -229,7 +231,7 @@ mpt_turbo_reply(MPT_ADAPTER *ioc, u32 pa
 	int req_idx = 0;
 	int cb_idx;
 
-	dmfprintk((MYIOC_s_INFO_FMT "Got TURBO reply req_idx=%08x\n",
+	dmfprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Got TURBO reply req_idx=%08x\n",
 				ioc->name, pa));
 
 	switch (pa >> MPI_CONTEXT_REPLY_TYPE_SHIFT) {
@@ -312,9 +314,9 @@ mpt_reply(MPT_ADAPTER *ioc, u32 pa)
 	cb_idx = mr->u.frame.hwhdr.msgctxu.fld.cb_idx;
 	mf = MPT_INDEX_2_MFPTR(ioc, req_idx);
 
-	dmfprintk((MYIOC_s_INFO_FMT "Got non-TURBO reply=%p req_idx=%x cb_idx=%x Function=%x\n",
+	dmfprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Got non-TURBO reply=%p req_idx=%x cb_idx=%x Function=%x\n",
 			ioc->name, mr, req_idx, cb_idx, mr->u.hdr.Function));
-	DBG_DUMP_REPLY_FRAME(mr)
+	DBG_DUMP_REPLY_FRAME(ioc, (u32 *)mr)
 
 	 /*  Check/log IOC log info
 	 */
@@ -329,10 +331,8 @@ mpt_reply(MPT_ADAPTER *ioc, u32 pa)
 			mpt_sas_log_info(ioc, log_info);
 	}
 
-#ifdef MPT_DEBUG_REPLY
 	if (ioc_stat & MPI_IOCSTATUS_MASK)
 		mpt_iocstatus_info(ioc, (u32)ioc_stat, mf);
-#endif
 
 	/*  Check for (valid) IO callback!  */
 	if (cb_idx < 1 || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS ||
@@ -414,17 +414,17 @@ mpt_base_reply(MPT_ADAPTER *ioc, MPT_FRA
 	int freereq = 1;
 	u8 func;
 
-	dmfprintk((MYIOC_s_INFO_FMT "mpt_base_reply() called\n", ioc->name));
-
-#if defined(MPT_DEBUG_MSG_FRAME)
-	if (!(reply->u.hdr.MsgFlags & MPI_MSGFLAGS_CONTINUATION_REPLY)) {
-		dmfprintk((KERN_INFO MYNAM ": Original request frame (@%p) header\n", mf));
-		DBG_DUMP_REQUEST_FRAME_HDR(mf)
+	dmfprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mpt_base_reply() called\n", ioc->name));
+#ifdef CONFIG_FUSION_LOGGING
+	if ((ioc->debug_level & MPT_DEBUG_MSG_FRAME) &&
+			!(reply->u.hdr.MsgFlags & MPI_MSGFLAGS_CONTINUATION_REPLY)) {
+		dmfprintk(ioc, printk(KERN_INFO MYNAM ": Original request frame (@%p) header\n", mf));
+		DBG_DUMP_REQUEST_FRAME_HDR(ioc, (u32 *)mf)
 	}
 #endif
 
 	func = reply->u.hdr.Function;
-	dmfprintk((MYIOC_s_INFO_FMT "mpt_base_reply, Function=%02Xh\n",
+	dmfprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mpt_base_reply, Function=%02Xh\n",
 			ioc->name, func));
 
 	if (func == MPI_FUNCTION_EVENT_NOTIFICATION) {
@@ -435,7 +435,7 @@ mpt_base_reply(MPT_ADAPTER *ioc, MPT_FRA
 		results = ProcessEventNotification(ioc, pEvReply, &evHandlers);
 		if (results != evHandlers) {
 			/* CHECKME! Any special handling needed here? */
-			devtverboseprintk((MYIOC_s_WARN_FMT "Called %d event handlers, sum results = %d\n",
+			devtverboseprintk(ioc, printk(MYIOC_s_WARN_FMT "Called %d event handlers, sum results = %d\n",
 					ioc->name, evHandlers, results));
 		}
 
@@ -446,7 +446,7 @@ mpt_base_reply(MPT_ADAPTER *ioc, MPT_FRA
 		if (pEvReply->MsgFlags & MPI_MSGFLAGS_CONTINUATION_REPLY) {
 			freereq = 0;
 		} else {
-			devtverboseprintk((MYIOC_s_WARN_FMT "EVENT_NOTIFICATION reply %p returns Request frame\n",
+			devtverboseprintk(ioc, printk(MYIOC_s_WARN_FMT "EVENT_NOTIFICATION reply %p returns Request frame\n",
 				ioc->name, pEvReply));
 		}
 
@@ -455,13 +455,13 @@ mpt_base_reply(MPT_ADAPTER *ioc, MPT_FRA
 #endif
 
 	} else if (func == MPI_FUNCTION_EVENT_ACK) {
-		dprintk((MYIOC_s_INFO_FMT "mpt_base_reply, EventAck reply received\n",
+		dprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mpt_base_reply, EventAck reply received\n",
 				ioc->name));
 	} else if (func == MPI_FUNCTION_CONFIG) {
 		CONFIGPARMS *pCfg;
 		unsigned long flags;
 
-		dcprintk((MYIOC_s_INFO_FMT "config_complete (mf=%p,mr=%p)\n",
+		dcprintk(ioc, printk(MYIOC_s_DEBUG_FMT "config_complete (mf=%p,mr=%p)\n",
 				ioc->name, mf, reply));
 
 		pCfg = * ((CONFIGPARMS **)((u8 *) mf + ioc->req_sz - sizeof(void *)));
@@ -484,7 +484,7 @@ mpt_base_reply(MPT_ADAPTER *ioc, MPT_FRA
 				u16		 status;
 
 				status = le16_to_cpu(pReply->IOCStatus) & MPI_IOCSTATUS_MASK;
-				dcprintk((KERN_NOTICE "  IOCStatus=%04xh, IOCLogInfo=%08xh\n",
+				dcprintk(ioc, printk(KERN_NOTICE "  IOCStatus=%04xh, IOCLogInfo=%08xh\n",
 				     status, le32_to_cpu(pReply->IOCLogInfo)));
 
 				pCfg->status = status;
@@ -789,7 +789,7 @@ mpt_get_msg_frame(int handle, MPT_ADAPTE
 		printk(KERN_INFO "MF Count 0x%x Max 0x%x \n", ioc->mfcnt, ioc->req_depth);
 #endif
 
-	dmfprintk((KERN_INFO MYNAM ": %s: mpt_get_msg_frame(%d,%d), got mf=%p\n",
+	dmfprintk(ioc, printk(KERN_INFO MYNAM ": %s: mpt_get_msg_frame(%d,%d), got mf=%p\n",
 			ioc->name, handle, ioc->id, mf));
 	return mf;
 }
@@ -820,27 +820,10 @@ mpt_put_msg_frame(int handle, MPT_ADAPTE
 	mf->u.frame.hwhdr.msgctxu.fld.req_idx = cpu_to_le16(req_idx);
 	mf->u.frame.hwhdr.msgctxu.fld.rsvd = 0;
 
-#ifdef MPT_DEBUG_MSG_FRAME
-	{
-		u32	*m = mf->u.frame.hwhdr.__hdr;
-		int	 ii, n;
-
-		printk(KERN_INFO MYNAM ": %s: About to Put msg frame @ %p:\n" KERN_INFO " ",
-				ioc->name, m);
-		n = ioc->req_sz/4 - 1;
-		while (m[n] == 0)
-			n--;
-		for (ii=0; ii<=n; ii++) {
-			if (ii && ((ii%8)==0))
-				printk("\n" KERN_INFO " ");
-			printk(" %08x", le32_to_cpu(m[ii]));
-		}
-		printk("\n");
-	}
-#endif
+	DBG_DUMP_PUT_MSG_FRAME(ioc, (u32 *)mf);
 
 	mf_dma_addr = (ioc->req_frames_low_dma + req_offset) | ioc->RequestNB[req_idx];
-	dsgprintk((MYIOC_s_INFO_FMT "mf_dma_addr=%x req_idx=%d RequestNB=%x\n", ioc->name, mf_dma_addr, req_idx, ioc->RequestNB[req_idx]));
+	dsgprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mf_dma_addr=%x req_idx=%d RequestNB=%x\n", ioc->name, mf_dma_addr, req_idx, ioc->RequestNB[req_idx]));
 	CHIPREG_WRITE32(&ioc->chip->RequestFifo, mf_dma_addr);
 }
 
@@ -955,7 +938,7 @@ mpt_send_handshake_request(int handle, M
 	if (!(CHIPREG_READ32(&ioc->chip->Doorbell) & MPI_DOORBELL_ACTIVE))
 		return -5;
 
-	dhsprintk((KERN_INFO MYNAM ": %s: mpt_send_handshake_request start, WaitCnt=%d\n",
+	dhsprintk(ioc, printk(KERN_INFO MYNAM ": %s: mpt_send_handshake_request start, WaitCnt=%d\n",
 		ioc->name, ii));
 
 	CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);
@@ -1066,7 +1049,7 @@ mpt_host_page_alloc(MPT_ADAPTER *ioc, pI
 			    host_page_buffer_sz,
 			    &ioc->HostPageBuffer_dma)) != NULL) {
 
-				dinitprintk((MYIOC_s_INFO_FMT
+				dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 				    "host_page_buffer @ %p, dma @ %x, sz=%d bytes\n",
 				    ioc->name, ioc->HostPageBuffer,
 				    (u32)ioc->HostPageBuffer_dma,
@@ -1410,31 +1393,37 @@ mpt_attach(struct pci_dev *pdev, const s
 	struct proc_dir_entry *dent, *ent;
 #endif
 
+	ioc = kzalloc(sizeof(MPT_ADAPTER), GFP_ATOMIC);
+	if (ioc == NULL) {
+		printk(KERN_ERR MYNAM ": ERROR - Insufficient memory to add adapter!\n");
+		return -ENOMEM;
+	}
+
+	ioc->debug_level = mpt_debug_level;
+	if (mpt_debug_level)
+		printk(KERN_INFO MYNAM ": mpt_debug_level=%xh\n", mpt_debug_level);
+
 	if (pci_enable_device(pdev))
 		return r;
 
-	dinitprintk((KERN_WARNING MYNAM ": mpt_adapter_install\n"));
+	dinitprintk(ioc, printk(KERN_WARNING MYNAM ": mpt_adapter_install\n"));
 
 	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
-		dprintk((KERN_INFO MYNAM
+		dprintk(ioc, printk(KERN_INFO MYNAM
 			": 64 BIT PCI BUS DMA ADDRESSING SUPPORTED\n"));
 	} else if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
 		printk(KERN_WARNING MYNAM ": 32 BIT PCI BUS DMA ADDRESSING NOT SUPPORTED\n");
 		return r;
 	}
 
-	if (!pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK))
-		dprintk((KERN_INFO MYNAM
+	if (!pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK)) {
+		dprintk(ioc, printk(KERN_INFO MYNAM
 			": Using 64 bit consistent mask\n"));
-	else
-		dprintk((KERN_INFO MYNAM
+	} else {
+		dprintk(ioc, printk(KERN_INFO MYNAM
 			": Not using 64 bit consistent mask\n"));
-
-	ioc = kzalloc(sizeof(MPT_ADAPTER), GFP_ATOMIC);
-	if (ioc == NULL) {
-		printk(KERN_ERR MYNAM ": ERROR - Insufficient memory to add adapter!\n");
-		return -ENOMEM;
 	}
+
 	ioc->alloc_total = sizeof(MPT_ADAPTER);
 	ioc->req_sz = MPT_DEFAULT_FRAME_SIZE;		/* avoid div by zero! */
 	ioc->reply_sz = MPT_REPLY_FRAME_SIZE;
@@ -1502,9 +1491,9 @@ mpt_attach(struct pci_dev *pdev, const s
 		return -EINVAL;
 	}
 	ioc->memmap = mem;
-	dinitprintk((KERN_INFO MYNAM ": mem = %p, mem_phys = %lx\n", mem, mem_phys));
+	dinitprintk(ioc, printk(KERN_INFO MYNAM ": mem = %p, mem_phys = %lx\n", mem, mem_phys));
 
-	dinitprintk((KERN_INFO MYNAM ": facts @ %p, pfacts[0] @ %p\n",
+	dinitprintk(ioc, printk(KERN_INFO MYNAM ": facts @ %p, pfacts[0] @ %p\n",
 			&ioc->facts, &ioc->pfacts[0]));
 
 	ioc->mem_phys = mem_phys;
@@ -1830,6 +1819,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 	int	 ret = 0;
 	int	 reset_alt_ioc_active = 0;
 	int	 irq_allocated = 0;
+	u8	*a;
 
 	printk(KERN_INFO MYNAM ": Initiating %s %s\n",
 			ioc->name, reason==MPT_HOSTEVENT_IOC_BRINGUP ? "bringup" : "recovery");
@@ -1858,7 +1848,8 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 
 			if (reset_alt_ioc_active && ioc->alt_ioc) {
 				/* (re)Enable alt-IOC! (reply interrupt, FreeQ) */
-				dprintk((KERN_INFO MYNAM ": alt-%s reply irq re-enabled\n",
+				dprintk(ioc, printk(KERN_INFO MYNAM
+					": alt-%s reply irq re-enabled\n",
 						ioc->alt_ioc->name));
 				CHIPREG_WRITE32(&ioc->alt_ioc->chip->IntMask, MPI_HIM_DIM);
 				ioc->alt_ioc->active = 1;
@@ -1891,7 +1882,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 
 
 	if (ii == 5) {
-		dinitprintk((MYIOC_s_INFO_FMT "Retry IocFacts failed rc=%x\n", ioc->name, rc));
+		dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Retry IocFacts failed rc=%x\n", ioc->name, rc));
 		ret = -2;
 	} else if (reason == MPT_HOSTEVENT_IOC_BRINGUP) {
 		MptDisplayIocCapabilities(ioc);
@@ -1899,13 +1890,15 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 
 	if (alt_ioc_ready) {
 		if ((rc = GetIocFacts(ioc->alt_ioc, sleepFlag, reason)) != 0) {
-			dinitprintk((MYIOC_s_INFO_FMT "Initial Alt IocFacts failed rc=%x\n", ioc->name, rc));
+			dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+				"Initial Alt IocFacts failed rc=%x\n", ioc->name, rc));
 			/* Retry - alt IOC was initialized once
 			 */
 			rc = GetIocFacts(ioc->alt_ioc, sleepFlag, reason);
 		}
 		if (rc) {
-			dinitprintk((MYIOC_s_INFO_FMT "Retry Alt IocFacts failed rc=%x\n", ioc->name, rc));
+			dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+				"Retry Alt IocFacts failed rc=%x\n", ioc->name, rc));
 			alt_ioc_ready = 0;
 			reset_alt_ioc_active = 0;
 		} else if (reason == MPT_HOSTEVENT_IOC_BRINGUP) {
@@ -1938,7 +1931,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 			ioc->pci_irq = ioc->pcidev->irq;
 			pci_set_master(ioc->pcidev);		/* ?? */
 			pci_set_drvdata(ioc->pcidev, ioc);
-			dprintk((KERN_INFO MYNAM ": %s installed at interrupt "
+			dprintk(ioc, printk(KERN_INFO MYNAM ": %s installed at interrupt "
 				"%d\n", ioc->name, ioc->pcidev->irq));
 		}
 	}
@@ -1976,7 +1969,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 
 	if (reason == MPT_HOSTEVENT_IOC_BRINGUP){
 		if (ioc->upload_fw) {
-			ddlprintk((MYIOC_s_INFO_FMT
+			ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 				"firmware upload required!\n", ioc->name));
 
 			/* Controller is not operational, cannot do upload
@@ -1992,7 +1985,8 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 						 * chips (mpt_adapter_disable,
 						 * mpt_diag_reset)
 						 */
-						ddlprintk((MYIOC_s_INFO_FMT ": mpt_upload:  alt_%s has cached_fw=%p \n",
+						ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+							": mpt_upload:  alt_%s has cached_fw=%p \n",
 							ioc->name, ioc->alt_ioc->name, ioc->alt_ioc->cached_fw));
 						ioc->alt_ioc->cached_fw = NULL;
 					}
@@ -2012,7 +2006,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 
 	if (reset_alt_ioc_active && ioc->alt_ioc) {
 		/* (re)Enable alt-IOC! (reply interrupt) */
-		dinitprintk((KERN_INFO MYNAM ": alt-%s reply irq re-enabled\n",
+		dinitprintk(ioc, printk(KERN_INFO MYNAM ": alt-%s reply irq re-enabled\n",
 				ioc->alt_ioc->name));
 		CHIPREG_WRITE32(&ioc->alt_ioc->chip->IntMask, MPI_HIM_DIM);
 		ioc->alt_ioc->active = 1;
@@ -2064,13 +2058,13 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 				 *  (LANPage1_t stuff)
 				 */
 				(void) GetLanConfigPages(ioc);
-#ifdef MPT_DEBUG
-				{
-					u8 *a = (u8*)&ioc->lan_cnfg_page1.HardwareAddressLow;
-					dprintk((MYIOC_s_INFO_FMT "LanAddr = %02X:%02X:%02X:%02X:%02X:%02X\n",
-							ioc->name, a[5], a[4], a[3], a[2], a[1], a[0] ));
-				}
-#endif
+				a = (u8*)&ioc->lan_cnfg_page1.HardwareAddressLow;
+				dprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+					"LanAddr = %02X:%02X:%02X:"
+					"%02X:%02X:%02X\n",
+					ioc->name, a[5], a[4],
+					a[3], a[2], a[1], a[0] ));
+
 			}
 		} else {
 			/* Get NVRAM and adapter maximums from SPP 0 and 2
@@ -2107,15 +2101,17 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 		rc = handlers = 0;
 		for (ii=MPT_MAX_PROTOCOL_DRIVERS-1; ii; ii--) {
 			if ((ret == 0) && MptResetHandlers[ii]) {
-				dprintk((MYIOC_s_INFO_FMT "Calling IOC post_reset handler #%d\n",
-						ioc->name, ii));
+				dprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+					"Calling IOC post_reset handler #%d\n",
+					ioc->name, ii));
 				rc += mpt_signal_reset(ii, ioc, MPT_IOC_POST_RESET);
 				handlers++;
 			}
 
 			if (alt_ioc_ready && MptResetHandlers[ii]) {
-				drsprintk((MYIOC_s_INFO_FMT "Calling alt-%s post_reset handler #%d\n",
-						ioc->name, ioc->alt_ioc->name, ii));
+				drsprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+					"Calling alt-%s post_reset handler #%d\n",
+					ioc->name, ioc->alt_ioc->name, ii));
 				rc += mpt_signal_reset(ii, ioc->alt_ioc, MPT_IOC_POST_RESET);
 				handlers++;
 			}
@@ -2153,7 +2149,7 @@ mpt_detect_bound_ports(MPT_ADAPTER *ioc,
 	unsigned int func = PCI_FUNC(pdev->devfn);
 	MPT_ADAPTER *ioc_srch;
 
-	dprintk((MYIOC_s_INFO_FMT "PCI device %s devfn=%x/%x,"
+	dprintk(ioc, printk(MYIOC_s_DEBUG_FMT "PCI device %s devfn=%x/%x,"
 	    " searching for devfn match on %x or %x\n",
 		ioc->name, pci_name(pdev), pdev->bus->number,
 		pdev->devfn, func-1, func+1));
@@ -2178,7 +2174,7 @@ mpt_detect_bound_ports(MPT_ADAPTER *ioc,
 					ioc_srch->name, ioc_srch->alt_ioc->name);
 				break;
 			}
-			dprintk((KERN_INFO MYNAM ": FOUND! binding %s <==> %s\n",
+			dprintk(ioc, printk(KERN_INFO MYNAM ": FOUND! binding %s <==> %s\n",
 				ioc->name, ioc_srch->name));
 			ioc_srch->alt_ioc = ioc;
 			ioc->alt_ioc = ioc_srch;
@@ -2199,7 +2195,7 @@ mpt_adapter_disable(MPT_ADAPTER *ioc)
 	int ret;
 
 	if (ioc->cached_fw != NULL) {
-		ddlprintk((KERN_INFO MYNAM ": mpt_adapter_disable: Pushing FW onto adapter\n"));
+		ddlprintk(ioc, printk(KERN_INFO MYNAM ": mpt_adapter_disable: Pushing FW onto adapter\n"));
 		if ((ret = mpt_downloadboot(ioc, (MpiFwHeader_t *)ioc->cached_fw, NO_SLEEP)) < 0) {
 			printk(KERN_WARNING MYNAM
 				": firmware downloadboot failure (%d)!\n", ret);
@@ -2214,7 +2210,7 @@ mpt_adapter_disable(MPT_ADAPTER *ioc)
 
 	if (ioc->alloc != NULL) {
 		sz = ioc->alloc_sz;
-		dexitprintk((KERN_INFO MYNAM ": %s.free  @ %p, sz=%d bytes\n",
+		dexitprintk(ioc, printk(KERN_INFO MYNAM ": %s.free  @ %p, sz=%d bytes\n",
 		 	ioc->name, ioc->alloc, ioc->alloc_sz));
 		pci_free_consistent(ioc->pcidev, sz,
 				ioc->alloc, ioc->alloc_dma);
@@ -2256,7 +2252,7 @@ mpt_adapter_disable(MPT_ADAPTER *ioc)
 
 	if (ioc->spi_data.pIocPg4 != NULL) {
 		sz = ioc->spi_data.IocPg4Sz;
-		pci_free_consistent(ioc->pcidev, sz, 
+		pci_free_consistent(ioc->pcidev, sz,
 			ioc->spi_data.pIocPg4,
 			ioc->spi_data.IocPg4_dma);
 		ioc->spi_data.pIocPg4 = NULL;
@@ -2279,7 +2275,7 @@ mpt_adapter_disable(MPT_ADAPTER *ioc)
 			   ": %s: host page buffers free failed (%d)!\n",
 			    __FUNCTION__, ret);
 		}
-		dexitprintk((KERN_INFO MYNAM ": %s HostPageBuffer free  @ %p, sz=%d bytes\n",
+		dexitprintk(ioc, printk(KERN_INFO MYNAM ": %s HostPageBuffer free  @ %p, sz=%d bytes\n",
 		 	ioc->name, ioc->HostPageBuffer, ioc->HostPageBuffer_sz));
 		pci_free_consistent(ioc->pcidev, ioc->HostPageBuffer_sz,
 				ioc->HostPageBuffer,
@@ -2325,7 +2321,7 @@ mpt_adapter_dispose(MPT_ADAPTER *ioc)
 #if defined(CONFIG_MTRR) && 0
 	if (ioc->mtrr_reg > 0) {
 		mtrr_del(ioc->mtrr_reg, 0, 0);
-		dprintk((KERN_INFO MYNAM ": %s: MTRR region de-registered\n", ioc->name));
+		dprintk(ioc, printk(KERN_INFO MYNAM ": %s: MTRR region de-registered\n", ioc->name));
 	}
 #endif
 
@@ -2333,7 +2329,7 @@ mpt_adapter_dispose(MPT_ADAPTER *ioc)
 	list_del(&ioc->list);
 
 	sz_last = ioc->alloc_total;
-	dprintk((KERN_INFO MYNAM ": %s: free'd %d of %d bytes\n",
+	dprintk(ioc, printk(KERN_INFO MYNAM ": %s: free'd %d of %d bytes\n",
 			ioc->name, sz_first-sz_last+(int)sizeof(*ioc), sz_first));
 
 	if (ioc->alt_ioc)
@@ -2413,7 +2409,7 @@ MakeIocReady(MPT_ADAPTER *ioc, int force
 
 	/* Get current [raw] IOC state  */
 	ioc_state = mpt_GetIocState(ioc, 0);
-	dhsprintk((KERN_INFO MYNAM "::MakeIocReady, %s [raw] state=%08x\n", ioc->name, ioc_state));
+	dhsprintk(ioc, printk(KERN_INFO MYNAM "::MakeIocReady, %s [raw] state=%08x\n", ioc->name, ioc_state));
 
 	/*
 	 *	Check to see if IOC got left/stuck in doorbell handshake
@@ -2444,7 +2440,7 @@ MakeIocReady(MPT_ADAPTER *ioc, int force
 	 *	Hmmm...  Did it get left operational?
 	 */
 	if ((ioc_state & MPI_IOC_STATE_MASK) == MPI_IOC_STATE_OPERATIONAL) {
-		dinitprintk((MYIOC_s_INFO_FMT "IOC operational unexpected\n",
+		dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "IOC operational unexpected\n",
 				ioc->name));
 
 		/* Check WhoInit.
@@ -2453,7 +2449,7 @@ MakeIocReady(MPT_ADAPTER *ioc, int force
 		 * Else, fall through to KickStart case
 		 */
 		whoinit = (ioc_state & MPI_DOORBELL_WHO_INIT_MASK) >> MPI_DOORBELL_WHO_INIT_SHIFT;
-		dinitprintk((KERN_INFO MYNAM
+		dinitprintk(ioc, printk(KERN_INFO MYNAM
 			": whoinit 0x%x statefault %d force %d\n",
 			whoinit, statefault, force));
 		if (whoinit == MPI_WHOINIT_PCI_PEER)
@@ -2589,7 +2585,7 @@ GetIocFacts(MPT_ADAPTER *ioc, int sleepF
 	get_facts.Function = MPI_FUNCTION_IOC_FACTS;
 	/* Assert: All other get_facts fields are zero! */
 
-	dinitprintk((MYIOC_s_INFO_FMT
+	dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 	    "Sending get IocFacts request req_sz=%d reply_sz=%d\n",
 	    ioc->name, req_sz, reply_sz));
 
@@ -2691,8 +2687,9 @@ GetIocFacts(MPT_ADAPTER *ioc, int sleepF
 			sz = sz >> 1;
 		}
 		ioc->NBShiftFactor  = shiftFactor;
-		dinitprintk((MYIOC_s_INFO_FMT "NB_for_64_byte_frame=%x NBShiftFactor=%x BlockSize=%x\n",
-					ioc->name, vv, shiftFactor, r));
+		dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+			"NB_for_64_byte_frame=%x NBShiftFactor=%x BlockSize=%x\n",
+			ioc->name, vv, shiftFactor, r));
 
 		if (reason == MPT_HOSTEVENT_IOC_BRINGUP) {
 			/*
@@ -2704,9 +2701,9 @@ GetIocFacts(MPT_ADAPTER *ioc, int sleepF
 			ioc->reply_sz = MPT_REPLY_FRAME_SIZE;
 			ioc->reply_depth = min_t(int, MPT_DEFAULT_REPLY_DEPTH, facts->ReplyQueueDepth);
 
-			dinitprintk((MYIOC_s_INFO_FMT "reply_sz=%3d, reply_depth=%4d\n",
+			dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "reply_sz=%3d, reply_depth=%4d\n",
 				ioc->name, ioc->reply_sz, ioc->reply_depth));
-			dinitprintk((MYIOC_s_INFO_FMT "req_sz  =%3d, req_depth  =%4d\n",
+			dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "req_sz  =%3d, req_depth  =%4d\n",
 				ioc->name, ioc->req_sz, ioc->req_depth));
 
 			/* Get port facts! */
@@ -2765,7 +2762,7 @@ GetPortFacts(MPT_ADAPTER *ioc, int portn
 	get_pfacts.PortNumber = portnum;
 	/* Assert: All other get_pfacts fields are zero! */
 
-	dinitprintk((MYIOC_s_INFO_FMT "Sending get PortFacts(%d) request\n",
+	dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Sending get PortFacts(%d) request\n",
 			ioc->name, portnum));
 
 	/* No non-zero fields in the get_pfacts request are greater than
@@ -2841,12 +2838,12 @@ SendIocInit(MPT_ADAPTER *ioc, int sleepF
 		ioc->upload_fw = 1;
 	else
 		ioc->upload_fw = 0;
-	ddlprintk((MYIOC_s_INFO_FMT "upload_fw %d facts.Flags=%x\n",
+	ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "upload_fw %d facts.Flags=%x\n",
 		   ioc->name, ioc->upload_fw, ioc->facts.Flags));
 
 	ioc_init.MaxDevices = (U8)ioc->devices_per_bus;
 	ioc_init.MaxBuses = (U8)ioc->number_of_buses;
-	dinitprintk((MYIOC_s_INFO_FMT "facts.MsgVersion=%x\n",
+	dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "facts.MsgVersion=%x\n",
 		   ioc->name, ioc->facts.MsgVersion));
 	if (ioc->facts.MsgVersion >= MPI_VERSION_01_05) {
 		// set MsgVersion and HeaderVersion host driver was built with
@@ -2877,7 +2874,7 @@ SendIocInit(MPT_ADAPTER *ioc, int sleepF
 	ioc->facts.MaxDevices = ioc_init.MaxDevices;
 	ioc->facts.MaxBuses = ioc_init.MaxBuses;
 
-	dhsprintk((MYIOC_s_INFO_FMT "Sending IOCInit (req @ %p)\n",
+	dhsprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Sending IOCInit (req @ %p)\n",
 			ioc->name, &ioc_init));
 
 	r = mpt_handshake_req_reply_wait(ioc, sizeof(IOCInit_t), (u32*)&ioc_init,
@@ -2891,7 +2888,7 @@ SendIocInit(MPT_ADAPTER *ioc, int sleepF
 	 * since we don't even look at its contents.
 	 */
 
-	dhsprintk((MYIOC_s_INFO_FMT "Sending PortEnable (req @ %p)\n",
+	dhsprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Sending PortEnable (req @ %p)\n",
 			ioc->name, &ioc_init));
 
 	if ((r = SendPortEnable(ioc, 0, sleepFlag)) != 0) {
@@ -2922,7 +2919,7 @@ SendIocInit(MPT_ADAPTER *ioc, int sleepF
 		state = mpt_GetIocState(ioc, 1);
 		count++;
 	}
-	dinitprintk((MYIOC_s_INFO_FMT "INFO - Wait IOC_OPERATIONAL state (cnt=%d)\n",
+	dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "INFO - Wait IOC_OPERATIONAL state (cnt=%d)\n",
 			ioc->name, count));
 
 	ioc->aen_event_read_flag=0;
@@ -2962,7 +2959,7 @@ SendPortEnable(MPT_ADAPTER *ioc, int por
 /*	port_enable.MsgFlags = 0;		*/
 /*	port_enable.MsgContext = 0;		*/
 
-	dinitprintk((MYIOC_s_INFO_FMT "Sending Port(%d)Enable (req @ %p)\n",
+	dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Sending Port(%d)Enable (req @ %p)\n",
 			ioc->name, portnum, &port_enable));
 
 	/* RAID FW may take a long time to enable
@@ -3015,7 +3012,7 @@ mpt_free_fw_memory(MPT_ADAPTER *ioc)
 	int sz;
 
 	sz = ioc->facts.FWImageSize;
-	dinitprintk((KERN_INFO MYNAM "free_fw_memory: FW Image  @ %p[%p], sz=%d[%x] bytes\n",
+	dinitprintk(ioc, printk(KERN_INFO MYNAM "free_fw_memory: FW Image  @ %p[%p], sz=%d[%x] bytes\n",
 		 ioc->cached_fw, (void *)(ulong)ioc->cached_fw_dma, sz, sz));
 	pci_free_consistent(ioc->pcidev, sz,
 			ioc->cached_fw, ioc->cached_fw_dma);
@@ -3059,7 +3056,7 @@ mpt_do_upload(MPT_ADAPTER *ioc, int slee
 
 	mpt_alloc_fw_memory(ioc, sz);
 
-	dinitprintk((KERN_INFO MYNAM ": FW Image  @ %p[%p], sz=%d[%x] bytes\n",
+	dinitprintk(ioc, printk(KERN_INFO MYNAM ": FW Image  @ %p[%p], sz=%d[%x] bytes\n",
 		 ioc->cached_fw, (void *)(ulong)ioc->cached_fw_dma, sz, sz));
 
 	if (ioc->cached_fw == NULL) {
@@ -3091,14 +3088,14 @@ mpt_do_upload(MPT_ADAPTER *ioc, int slee
 	mpt_add_sge(&request[sgeoffset], flagsLength, ioc->cached_fw_dma);
 
 	sgeoffset += sizeof(u32) + sizeof(dma_addr_t);
-	dinitprintk((KERN_INFO MYNAM ": Sending FW Upload (req @ %p) sgeoffset=%d \n",
+	dinitprintk(ioc, printk(KERN_INFO MYNAM ": Sending FW Upload (req @ %p) sgeoffset=%d \n",
 			prequest, sgeoffset));
-	DBG_DUMP_FW_REQUEST_FRAME(prequest)
+	DBG_DUMP_FW_REQUEST_FRAME(ioc, (u32 *)prequest)
 
 	ii = mpt_handshake_req_reply_wait(ioc, sgeoffset, (u32*)prequest,
 				reply_sz, (u16*)preply, 65 /*seconds*/, sleepFlag);
 
-	dinitprintk((KERN_INFO MYNAM ": FW Upload completed rc=%x \n", ii));
+	dinitprintk(ioc, printk(KERN_INFO MYNAM ": FW Upload completed rc=%x \n", ii));
 
 	cmdStatus = -EFAULT;
 	if (ii == 0) {
@@ -3113,13 +3110,13 @@ mpt_do_upload(MPT_ADAPTER *ioc, int slee
 				cmdStatus = 0;
 		}
 	}
-	dinitprintk((MYIOC_s_INFO_FMT ": do_upload cmdStatus=%d \n",
+	dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT ": do_upload cmdStatus=%d \n",
 			ioc->name, cmdStatus));
 
 
 	if (cmdStatus) {
 
-		ddlprintk((MYIOC_s_INFO_FMT ": fw upload failed, freeing image \n",
+		ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT ": fw upload failed, freeing image \n",
 			ioc->name));
 		mpt_free_fw_memory(ioc);
 	}
@@ -3154,7 +3151,7 @@ mpt_downloadboot(MPT_ADAPTER *ioc, MpiFw
 	u32			 load_addr;
 	u32 			 ioc_state=0;
 
-	ddlprintk((MYIOC_s_INFO_FMT "downloadboot: fw size 0x%x (%d), FW Ptr %p\n",
+	ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "downloadboot: fw size 0x%x (%d), FW Ptr %p\n",
 				ioc->name, pFwHeader->ImageSize, pFwHeader->ImageSize, pFwHeader));
 
 	CHIPREG_WRITE32(&ioc->chip->WriteSequence, 0xFF);
@@ -3179,7 +3176,7 @@ mpt_downloadboot(MPT_ADAPTER *ioc, MpiFw
 	for (count = 0; count < 30; count ++) {
 		diag0val = CHIPREG_READ32(&ioc->chip->Diagnostic);
 		if (!(diag0val & MPI_DIAG_RESET_ADAPTER)) {
-			ddlprintk((MYIOC_s_INFO_FMT "RESET_ADAPTER cleared, count=%d\n",
+			ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "RESET_ADAPTER cleared, count=%d\n",
 				ioc->name, count));
 			break;
 		}
@@ -3192,7 +3189,7 @@ mpt_downloadboot(MPT_ADAPTER *ioc, MpiFw
 	}
 
 	if ( count == 30 ) {
-		ddlprintk((MYIOC_s_INFO_FMT "downloadboot failed! "
+		ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "downloadboot failed! "
 		"Unable to get MPI_DIAG_DRWE mode, diag0val=%x\n",
 		ioc->name, diag0val));
 		return -3;
@@ -3218,10 +3215,10 @@ mpt_downloadboot(MPT_ADAPTER *ioc, MpiFw
 		pci_enable_io_access(ioc->pcidev);
 
 	CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwAddress, pFwHeader->LoadStartAddress);
-	ddlprintk((MYIOC_s_INFO_FMT "LoadStart addr written 0x%x \n",
+	ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "LoadStart addr written 0x%x \n",
 		ioc->name, pFwHeader->LoadStartAddress));
 
-	ddlprintk((MYIOC_s_INFO_FMT "Write FW Image: 0x%x bytes @ %p\n",
+	ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Write FW Image: 0x%x bytes @ %p\n",
 				ioc->name, fwSize*4, ptrFw));
 	while (fwSize--) {
 		CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwData, *ptrFw++);
@@ -3236,7 +3233,7 @@ mpt_downloadboot(MPT_ADAPTER *ioc, MpiFw
 		fwSize = (pExtImage->ImageSize + 3) >> 2;
 		ptrFw = (u32 *)pExtImage;
 
-		ddlprintk((MYIOC_s_INFO_FMT "Write Ext Image: 0x%x (%d) bytes @ %p load_addr=%x\n",
+		ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Write Ext Image: 0x%x (%d) bytes @ %p load_addr=%x\n",
 						ioc->name, fwSize*4, fwSize*4, ptrFw, load_addr));
 		CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwAddress, load_addr);
 
@@ -3247,11 +3244,11 @@ mpt_downloadboot(MPT_ADAPTER *ioc, MpiFw
 	}
 
 	/* Write the IopResetVectorRegAddr */
-	ddlprintk((MYIOC_s_INFO_FMT "Write IopResetVector Addr=%x! \n", ioc->name, 	pFwHeader->IopResetRegAddr));
+	ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Write IopResetVector Addr=%x! \n", ioc->name, 	pFwHeader->IopResetRegAddr));
 	CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwAddress, pFwHeader->IopResetRegAddr);
 
 	/* Write the IopResetVectorValue */
-	ddlprintk((MYIOC_s_INFO_FMT "Write IopResetVector Value=%x! \n", ioc->name, pFwHeader->IopResetVectorValue));
+	ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Write IopResetVector Value=%x! \n", ioc->name, pFwHeader->IopResetVectorValue));
 	CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwData, pFwHeader->IopResetVectorValue);
 
 	/* Clear the internal flash bad bit - autoincrementing register,
@@ -3285,11 +3282,11 @@ mpt_downloadboot(MPT_ADAPTER *ioc, MpiFw
 		pci_disable_io_access(ioc->pcidev);
 
 	diag0val = CHIPREG_READ32(&ioc->chip->Diagnostic);
-	ddlprintk((MYIOC_s_INFO_FMT "downloadboot diag0val=%x, "
+	ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "downloadboot diag0val=%x, "
 		"turning off PREVENT_IOC_BOOT, DISABLE_ARM, RW_ENABLE\n",
 		ioc->name, diag0val));
 	diag0val &= ~(MPI_DIAG_PREVENT_IOC_BOOT | MPI_DIAG_DISABLE_ARM | MPI_DIAG_RW_ENABLE);
-	ddlprintk((MYIOC_s_INFO_FMT "downloadboot now diag0val=%x\n",
+	ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "downloadboot now diag0val=%x\n",
 		ioc->name, diag0val));
 	CHIPREG_WRITE32(&ioc->chip->Diagnostic, diag0val);
 
@@ -3300,7 +3297,7 @@ mpt_downloadboot(MPT_ADAPTER *ioc, MpiFw
 		ioc_state = mpt_GetIocState(ioc, 0);
 		if ( (GetIocFacts(ioc, sleepFlag,
 				MPT_HOSTEVENT_IOC_BRINGUP)) != 0 ) {
-			ddlprintk((MYIOC_s_INFO_FMT "GetIocFacts failed: IocState=%x\n",
+			ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "GetIocFacts failed: IocState=%x\n",
 					ioc->name, ioc_state));
 			return -EFAULT;
 		}
@@ -3308,17 +3305,20 @@ mpt_downloadboot(MPT_ADAPTER *ioc, MpiFw
 
 	for (count=0; count<HZ*20; count++) {
 		if ((ioc_state = mpt_GetIocState(ioc, 0)) & MPI_IOC_STATE_READY) {
-			ddlprintk((MYIOC_s_INFO_FMT "downloadboot successful! (count=%d) IocState=%x\n",
-					ioc->name, count, ioc_state));
+			ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+				"downloadboot successful! (count=%d) IocState=%x\n",
+				ioc->name, count, ioc_state));
 			if (ioc->bus_type == SAS) {
 				return 0;
 			}
 			if ((SendIocInit(ioc, sleepFlag)) != 0) {
-				ddlprintk((MYIOC_s_INFO_FMT "downloadboot: SendIocInit failed\n",
+				ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+					"downloadboot: SendIocInit failed\n",
 					ioc->name));
 				return -EFAULT;
 			}
-			ddlprintk((MYIOC_s_INFO_FMT "downloadboot: SendIocInit successful\n",
+			ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+					"downloadboot: SendIocInit successful\n",
 					ioc->name));
 			return 0;
 		}
@@ -3328,8 +3328,8 @@ mpt_downloadboot(MPT_ADAPTER *ioc, MpiFw
 			mdelay (10);
 		}
 	}
-	ddlprintk((MYIOC_s_INFO_FMT "downloadboot failed! IocState=%x\n",
-		ioc->name, ioc_state));
+	ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		"downloadboot failed! IocState=%x\n",ioc->name, ioc_state));
 	return -EFAULT;
 }
 
@@ -3366,7 +3366,7 @@ KickStart(MPT_ADAPTER *ioc, int force, i
 	u32 ioc_state=0;
 	int cnt,cntdn;
 
-	dinitprintk((KERN_WARNING MYNAM ": KickStarting %s!\n", ioc->name));
+	dinitprintk(ioc, printk(KERN_WARNING MYNAM ": KickStarting %s!\n", ioc->name));
 	if (ioc->bus_type == SPI) {
 		/* Always issue a Msg Unit Reset first. This will clear some
 		 * SCSI bus hang conditions.
@@ -3384,14 +3384,14 @@ KickStart(MPT_ADAPTER *ioc, int force, i
 	if (hard_reset_done < 0)
 		return hard_reset_done;
 
-	dinitprintk((MYIOC_s_INFO_FMT "Diagnostic reset successful!\n",
+	dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Diagnostic reset successful!\n",
 			ioc->name));
 
 	cntdn = ((sleepFlag == CAN_SLEEP) ? HZ : 1000) * 2;	/* 2 seconds */
 	for (cnt=0; cnt<cntdn; cnt++) {
 		ioc_state = mpt_GetIocState(ioc, 1);
 		if ((ioc_state == MPI_IOC_STATE_READY) || (ioc_state == MPI_IOC_STATE_OPERATIONAL)) {
-			dinitprintk((MYIOC_s_INFO_FMT "KickStart successful! (cnt=%d)\n",
+			dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "KickStart successful! (cnt=%d)\n",
  					ioc->name, cnt));
 			return hard_reset_done;
 		}
@@ -3434,15 +3434,13 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ign
 	u32 doorbell;
 	int hard_reset_done = 0;
 	int count = 0;
-#ifdef MPT_DEBUG
 	u32 diag1val = 0;
-#endif
 
 	/* Clear any existing interrupts */
 	CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);
 
 	if (ioc->pcidev->device == MPI_MANUFACTPAGE_DEVID_SAS1078) {
-		drsprintk((MYIOC_s_WARN_FMT "%s: Doorbell=%p; 1078 reset "
+		drsprintk(ioc, printk(MYIOC_s_WARN_FMT "%s: Doorbell=%p; 1078 reset "
 			"address=%p\n",  ioc->name, __FUNCTION__,
 			&ioc->chip->Doorbell, &ioc->chip->Reset_1078));
 		CHIPREG_WRITE32(&ioc->chip->Reset_1078, 0x07);
@@ -3455,7 +3453,7 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ign
 			doorbell = CHIPREG_READ32(&ioc->chip->Doorbell);
 			doorbell &= MPI_IOC_STATE_MASK;
 
-			drsprintk((MYIOC_s_INFO_FMT
+			drsprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 				"looking for READY STATE: doorbell=%x"
 			        " count=%d\n",
 				ioc->name, doorbell, count));
@@ -3475,12 +3473,12 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ign
 	/* Use "Diagnostic reset" method! (only thing available!) */
 	diag0val = CHIPREG_READ32(&ioc->chip->Diagnostic);
 
-#ifdef MPT_DEBUG
-	if (ioc->alt_ioc)
-		diag1val = CHIPREG_READ32(&ioc->alt_ioc->chip->Diagnostic);
-	dprintk((MYIOC_s_INFO_FMT "DbG1: diag0=%08x, diag1=%08x\n",
+	if (ioc->debug_level & MPT_DEBUG) {
+		if (ioc->alt_ioc)
+			diag1val = CHIPREG_READ32(&ioc->alt_ioc->chip->Diagnostic);
+		dprintk(ioc, printk(MYIOC_s_DEBUG_FMT "DbG1: diag0=%08x, diag1=%08x\n",
 			ioc->name, diag0val, diag1val));
-#endif
+	}
 
 	/* Do the reset if we are told to ignore the reset history
 	 * or if the reset history is 0
@@ -3514,16 +3512,16 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ign
 
 			diag0val = CHIPREG_READ32(&ioc->chip->Diagnostic);
 
-			dprintk((MYIOC_s_INFO_FMT "Wrote magic DiagWriteEn sequence (%x)\n",
+			dprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Wrote magic DiagWriteEn sequence (%x)\n",
 					ioc->name, diag0val));
 		}
 
-#ifdef MPT_DEBUG
-		if (ioc->alt_ioc)
-			diag1val = CHIPREG_READ32(&ioc->alt_ioc->chip->Diagnostic);
-		dprintk((MYIOC_s_INFO_FMT "DbG2: diag0=%08x, diag1=%08x\n",
+		if (ioc->debug_level & MPT_DEBUG) {
+			if (ioc->alt_ioc)
+				diag1val = CHIPREG_READ32(&ioc->alt_ioc->chip->Diagnostic);
+			dprintk(ioc, printk(MYIOC_s_DEBUG_FMT "DbG2: diag0=%08x, diag1=%08x\n",
 				ioc->name, diag0val, diag1val));
-#endif
+		}
 		/*
 		 * Disable the ARM (Bug fix)
 		 *
@@ -3537,7 +3535,7 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ign
 		 */
 		CHIPREG_WRITE32(&ioc->chip->Diagnostic, diag0val | MPI_DIAG_RESET_ADAPTER);
 		hard_reset_done = 1;
-		dprintk((MYIOC_s_INFO_FMT "Diagnostic reset performed\n",
+		dprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Diagnostic reset performed\n",
 				ioc->name));
 
 		/*
@@ -3552,12 +3550,14 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ign
 
 			for (ii=MPT_MAX_PROTOCOL_DRIVERS-1; ii; ii--) {
 				if (MptResetHandlers[ii]) {
-					dprintk((MYIOC_s_INFO_FMT "Calling IOC pre_reset handler #%d\n",
-							ioc->name, ii));
+					dprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+						"Calling IOC pre_reset handler #%d\n",
+						ioc->name, ii));
 					r += mpt_signal_reset(ii, ioc, MPT_IOC_PRE_RESET);
 					if (ioc->alt_ioc) {
-						dprintk((MYIOC_s_INFO_FMT "Calling alt-%s pre_reset handler #%d\n",
-								ioc->name, ioc->alt_ioc->name, ii));
+						dprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+							"Calling alt-%s pre_reset handler #%d\n",
+							ioc->name, ioc->alt_ioc->name, ii));
 						r += mpt_signal_reset(ii, ioc->alt_ioc, MPT_IOC_PRE_RESET);
 					}
 				}
@@ -3580,7 +3580,7 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ign
 					break;
 				}
 
-				dprintk((MYIOC_s_INFO_FMT "cached_fw: diag0val=%x count=%d\n",
+				dprintk(ioc, printk(MYIOC_s_DEBUG_FMT "cached_fw: diag0val=%x count=%d\n",
 					iocp->name, diag0val, count));
 				/* wait 1 sec */
 				if (sleepFlag == CAN_SLEEP) {
@@ -3621,12 +3621,12 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ign
 	}
 
 	diag0val = CHIPREG_READ32(&ioc->chip->Diagnostic);
-#ifdef MPT_DEBUG
-	if (ioc->alt_ioc)
-		diag1val = CHIPREG_READ32(&ioc->alt_ioc->chip->Diagnostic);
-	dprintk((MYIOC_s_INFO_FMT "DbG3: diag0=%08x, diag1=%08x\n",
-		ioc->name, diag0val, diag1val));
-#endif
+	if (ioc->debug_level & MPT_DEBUG) {
+		if (ioc->alt_ioc)
+			diag1val = CHIPREG_READ32(&ioc->alt_ioc->chip->Diagnostic);
+		dprintk(ioc, printk(MYIOC_s_DEBUG_FMT "DbG3: diag0=%08x, diag1=%08x\n",
+			ioc->name, diag0val, diag1val));
+	}
 
 	/* Clear RESET_HISTORY bit!  Place board in the
 	 * diagnostic mode to update the diag register.
@@ -3680,12 +3680,12 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ign
 		return -3;
 	}
 
-#ifdef MPT_DEBUG
-	if (ioc->alt_ioc)
-		diag1val = CHIPREG_READ32(&ioc->alt_ioc->chip->Diagnostic);
-	dprintk((MYIOC_s_INFO_FMT "DbG4: diag0=%08x, diag1=%08x\n",
+	if (ioc->debug_level & MPT_DEBUG) {
+		if (ioc->alt_ioc)
+			diag1val = CHIPREG_READ32(&ioc->alt_ioc->chip->Diagnostic);
+		dprintk(ioc, printk(MYIOC_s_DEBUG_FMT "DbG4: diag0=%08x, diag1=%08x\n",
 			ioc->name, diag0val, diag1val));
-#endif
+	}
 
 	/*
 	 * Reset flag that says we've enabled event notification
@@ -3717,7 +3717,7 @@ SendIocReset(MPT_ADAPTER *ioc, u8 reset_
 	u32 state;
 	int cntdn, count;
 
-	drsprintk((KERN_INFO MYNAM ": %s: Sending IOC reset(0x%02x)!\n",
+	drsprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Sending IOC reset(0x%02x)!\n",
 			ioc->name, reset_type));
 	CHIPREG_WRITE32(&ioc->chip->Doorbell, reset_type<<MPI_DOORBELL_FUNCTION_SHIFT);
 	if ((r = WaitForDoorbellAck(ioc, 5, sleepFlag)) < 0)
@@ -3782,14 +3782,14 @@ initChainBuffers(MPT_ADAPTER *ioc)
 			return -1;
 
 		ioc->ReqToChain = (int *) mem;
-		dinitprintk((KERN_INFO MYNAM ": %s ReqToChain alloc  @ %p, sz=%d bytes\n",
+		dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "ReqToChain alloc  @ %p, sz=%d bytes\n",
 			 	ioc->name, mem, sz));
 		mem = kmalloc(sz, GFP_ATOMIC);
 		if (mem == NULL)
 			return -1;
 
 		ioc->RequestNB = (int *) mem;
-		dinitprintk((KERN_INFO MYNAM ": %s RequestNB alloc  @ %p, sz=%d bytes\n",
+		dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "RequestNB alloc  @ %p, sz=%d bytes\n",
 			 	ioc->name, mem, sz));
 	}
 	for (ii = 0; ii < ioc->req_depth; ii++) {
@@ -3819,7 +3819,7 @@ initChainBuffers(MPT_ADAPTER *ioc)
 		numSGE = 1 + (scale - 1) * (ioc->facts.MaxChainDepth-1) + scale +
 			(ioc->req_sz - 64) / (sizeof(dma_addr_t) + sizeof(u32));
 	}
-	dinitprintk((KERN_INFO MYNAM ": %s num_sge=%d numSGE=%d\n",
+	dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "num_sge=%d numSGE=%d\n",
 		ioc->name, num_sge, numSGE));
 
 	if ( numSGE > MPT_SCSI_SG_DEPTH	)
@@ -3832,7 +3832,7 @@ initChainBuffers(MPT_ADAPTER *ioc)
 	}
 	num_chain++;
 
-	dinitprintk((KERN_INFO MYNAM ": %s Now numSGE=%d num_sge=%d num_chain=%d\n",
+	dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Now numSGE=%d num_sge=%d num_chain=%d\n",
 		ioc->name, numSGE, num_sge, num_chain));
 
 	if (ioc->bus_type == SPI)
@@ -3849,7 +3849,7 @@ initChainBuffers(MPT_ADAPTER *ioc)
 			return -1;
 
 		ioc->ChainToChain = (int *) mem;
-		dinitprintk((KERN_INFO MYNAM ": %s ChainToChain alloc @ %p, sz=%d bytes\n",
+		dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "ChainToChain alloc @ %p, sz=%d bytes\n",
 			 	ioc->name, mem, sz));
 	} else {
 		mem = (u8 *) ioc->ChainToChain;
@@ -3885,22 +3885,22 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 			return -1;
 
 		total_size = reply_sz = (ioc->reply_sz * ioc->reply_depth);
-		dinitprintk((KERN_INFO MYNAM ": %s.ReplyBuffer sz=%d bytes, ReplyDepth=%d\n",
+		dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "ReplyBuffer sz=%d bytes, ReplyDepth=%d\n",
 			 	ioc->name, ioc->reply_sz, ioc->reply_depth));
-		dinitprintk((KERN_INFO MYNAM ": %s.ReplyBuffer sz=%d[%x] bytes\n",
+		dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "ReplyBuffer sz=%d[%x] bytes\n",
 			 	ioc->name, reply_sz, reply_sz));
 
 		sz = (ioc->req_sz * ioc->req_depth);
-		dinitprintk((KERN_INFO MYNAM ": %s.RequestBuffer sz=%d bytes, RequestDepth=%d\n",
+		dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "RequestBuffer sz=%d bytes, RequestDepth=%d\n",
 			 	ioc->name, ioc->req_sz, ioc->req_depth));
-		dinitprintk((KERN_INFO MYNAM ": %s.RequestBuffer sz=%d[%x] bytes\n",
+		dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "RequestBuffer sz=%d[%x] bytes\n",
 			 	ioc->name, sz, sz));
 		total_size += sz;
 
 		sz = num_chain * ioc->req_sz; /* chain buffer pool size */
-		dinitprintk((KERN_INFO MYNAM ": %s.ChainBuffer sz=%d bytes, ChainDepth=%d\n",
+		dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "ChainBuffer sz=%d bytes, ChainDepth=%d\n",
 			 	ioc->name, ioc->req_sz, num_chain));
-		dinitprintk((KERN_INFO MYNAM ": %s.ChainBuffer sz=%d[%x] bytes num_chain=%d\n",
+		dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "ChainBuffer sz=%d[%x] bytes num_chain=%d\n",
 			 	ioc->name, sz, sz, num_chain));
 
 		total_size += sz;
@@ -3911,7 +3911,7 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 			goto out_fail;
 		}
 
-		dinitprintk((KERN_INFO MYNAM ": %s.Total alloc @ %p[%p], sz=%d[%x] bytes\n",
+		dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Total alloc @ %p[%p], sz=%d[%x] bytes\n",
 			 	ioc->name, mem, (void *)(ulong)alloc_dma, total_size, total_size));
 
 		memset(mem, 0, total_size);
@@ -3922,7 +3922,7 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 		ioc->reply_frames = (MPT_FRAME_HDR *) mem;
 		ioc->reply_frames_low_dma = (u32) (alloc_dma & 0xFFFFFFFF);
 
-		dinitprintk((KERN_INFO MYNAM ": %s ReplyBuffers @ %p[%p]\n",
+		dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "ReplyBuffers @ %p[%p]\n",
 	 		ioc->name, ioc->reply_frames, (void *)(ulong)alloc_dma));
 
 		alloc_dma += reply_sz;
@@ -3933,7 +3933,7 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 		ioc->req_frames = (MPT_FRAME_HDR *) mem;
 		ioc->req_frames_dma = alloc_dma;
 
-		dinitprintk((KERN_INFO MYNAM ": %s RequestBuffers @ %p[%p]\n",
+		dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "RequestBuffers @ %p[%p]\n",
 			 	ioc->name, mem, (void *)(ulong)alloc_dma));
 
 		ioc->req_frames_low_dma = (u32) (alloc_dma & 0xFFFFFFFF);
@@ -3947,7 +3947,7 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 		ioc->mtrr_reg = mtrr_add(ioc->req_frames_dma,
 					 sz,
 					 MTRR_TYPE_WRCOMB, 1);
-		dprintk((MYIOC_s_INFO_FMT "MTRR region registered (base:size=%08x:%x)\n",
+		dprintk(ioc, printk(MYIOC_s_DEBUG_FMT "MTRR region registered (base:size=%08x:%x)\n",
 				ioc->name, ioc->req_frames_dma, sz));
 #endif
 
@@ -3959,7 +3959,7 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 		ioc->ChainBuffer = mem;
 		ioc->ChainBufferDMA = alloc_dma;
 
-		dinitprintk((KERN_INFO MYNAM " :%s ChainBuffers @ %p(%p)\n",
+		dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "ChainBuffers @ %p(%p)\n",
 			ioc->name, ioc->ChainBuffer, (void *)(ulong)ioc->ChainBufferDMA));
 
 		/* Initialize the free chain Q.
@@ -4004,7 +4004,7 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 
 		ioc->sense_buf_low_dma = (u32) (ioc->sense_buf_pool_dma & 0xFFFFFFFF);
 		ioc->alloc_total += sz;
-		dinitprintk((KERN_INFO MYNAM ": %s.SenseBuffers @ %p[%p]\n",
+		dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "SenseBuffers @ %p[%p]\n",
  			ioc->name, ioc->sense_buf_pool, (void *)(ulong)ioc->sense_buf_pool_dma));
 
 	}
@@ -4012,7 +4012,7 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 	/* Post Reply frames to FIFO
 	 */
 	alloc_dma = ioc->alloc_dma;
-	dinitprintk((KERN_INFO MYNAM ": %s.ReplyBuffers @ %p[%p]\n",
+	dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "ReplyBuffers @ %p[%p]\n",
 	 	ioc->name, ioc->reply_frames, (void *)(ulong)alloc_dma));
 
 	for (i = 0; i < ioc->reply_depth; i++) {
@@ -4093,7 +4093,7 @@ mpt_handshake_req_reply_wait(MPT_ADAPTER
 	if ((t = WaitForDoorbellInt(ioc, 5, sleepFlag)) < 0)
 		failcnt++;
 
-	dhsprintk((MYIOC_s_INFO_FMT "HandShake request start reqBytes=%d, WaitCnt=%d%s\n",
+	dhsprintk(ioc, printk(MYIOC_s_DEBUG_FMT "HandShake request start reqBytes=%d, WaitCnt=%d%s\n",
 			ioc->name, reqBytes, t, failcnt ? " - MISSING DOORBELL HANDSHAKE!" : ""));
 
 	/* Read doorbell and check for active bit */
@@ -4128,10 +4128,10 @@ mpt_handshake_req_reply_wait(MPT_ADAPTER
 				failcnt++;
 		}
 
-		dhsprintk((KERN_INFO MYNAM ": Handshake request frame (@%p) header\n", req));
-		DBG_DUMP_REQUEST_FRAME_HDR(req)
+		dhsprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Handshake request frame (@%p) header\n", ioc->name, req));
+		DBG_DUMP_REQUEST_FRAME_HDR(ioc, (u32 *)req)
 
-		dhsprintk((MYIOC_s_INFO_FMT "HandShake request post done, WaitCnt=%d%s\n",
+		dhsprintk(ioc, printk(MYIOC_s_DEBUG_FMT "HandShake request post done, WaitCnt=%d%s\n",
 				ioc->name, t, failcnt ? " - MISSING DOORBELL ACK!" : ""));
 
 		/*
@@ -4140,7 +4140,7 @@ mpt_handshake_req_reply_wait(MPT_ADAPTER
 		if (!failcnt && (t = WaitForDoorbellReply(ioc, maxwait, sleepFlag)) < 0)
 			failcnt++;
 
-		dhsprintk((MYIOC_s_INFO_FMT "HandShake reply count=%d%s\n",
+		dhsprintk(ioc, printk(MYIOC_s_DEBUG_FMT "HandShake reply count=%d%s\n",
 				ioc->name, t, failcnt ? " - MISSING DOORBELL REPLY!" : ""));
 
 		/*
@@ -4196,7 +4196,7 @@ WaitForDoorbellAck(MPT_ADAPTER *ioc, int
 	}
 
 	if (cntdn) {
-		dprintk((MYIOC_s_INFO_FMT "WaitForDoorbell ACK (count=%d)\n",
+		dprintk(ioc, printk(MYIOC_s_DEBUG_FMT "WaitForDoorbell ACK (count=%d)\n",
 				ioc->name, count));
 		return count;
 	}
@@ -4245,7 +4245,7 @@ WaitForDoorbellInt(MPT_ADAPTER *ioc, int
 	}
 
 	if (cntdn) {
-		dprintk((MYIOC_s_INFO_FMT "WaitForDoorbell INT (cnt=%d) howlong=%d\n",
+		dprintk(ioc, printk(MYIOC_s_DEBUG_FMT "WaitForDoorbell INT (cnt=%d) howlong=%d\n",
 				ioc->name, count, howlong));
 		return count;
 	}
@@ -4297,7 +4297,7 @@ WaitForDoorbellReply(MPT_ADAPTER *ioc, i
 		}
 	}
 
-	dhsprintk((MYIOC_s_INFO_FMT "WaitCnt=%d First handshake reply word=%08x%s\n",
+	dhsprintk(ioc, printk(MYIOC_s_DEBUG_FMT "WaitCnt=%d First handshake reply word=%08x%s\n",
 			ioc->name, t, le32_to_cpu(*(u32 *)hs_reply),
 			failcnt ? " - MISSING DOORBELL HANDSHAKE!" : ""));
 
@@ -4333,10 +4333,10 @@ WaitForDoorbellReply(MPT_ADAPTER *ioc, i
 	}
 #endif
 
-	dhsprintk((MYIOC_s_INFO_FMT "Got Handshake reply:\n", ioc->name));
-	DBG_DUMP_REPLY_FRAME(mptReply)
+	dhsprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Got Handshake reply:\n", ioc->name));
+	DBG_DUMP_REPLY_FRAME(ioc, (u32 *)mptReply)
 
-	dhsprintk((MYIOC_s_INFO_FMT "WaitForDoorbell REPLY WaitCnt=%d (sz=%d)\n",
+	dhsprintk(ioc, printk(MYIOC_s_DEBUG_FMT "WaitForDoorbell REPLY WaitCnt=%d (sz=%d)\n",
 			ioc->name, t, u16cnt/2));
 	return u16cnt/2;
 }
@@ -4761,7 +4761,7 @@ mpt_GetScsiPortSettings(MPT_ADAPTER *ioc
 
 		ioc->spi_data.nvram = (int *) mem;
 
-		dprintk((MYIOC_s_INFO_FMT "SCSI device NVRAM settings @ %p, sz=%d\n",
+		dprintk(ioc, printk(MYIOC_s_DEBUG_FMT "SCSI device NVRAM settings @ %p, sz=%d\n",
 			ioc->name, ioc->spi_data.nvram, sz));
 	}
 
@@ -4797,7 +4797,8 @@ mpt_GetScsiPortSettings(MPT_ADAPTER *ioc
 				ioc->spi_data.minSyncFactor = MPT_ASYNC;
 				ioc->spi_data.busType = MPT_HOST_BUS_UNKNOWN;
 				rc = 1;
-				ddvprintk((MYIOC_s_INFO_FMT "Unable to read PortPage0 minSyncFactor=%x\n",
+				ddvprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+					"Unable to read PortPage0 minSyncFactor=%x\n",
 					ioc->name, ioc->spi_data.minSyncFactor));
 			} else {
 				/* Save the Port Page 0 data
@@ -4808,7 +4809,8 @@ mpt_GetScsiPortSettings(MPT_ADAPTER *ioc
 
 				if ( (pPP0->Capabilities & MPI_SCSIPORTPAGE0_CAP_QAS) == 0 ) {
 					ioc->spi_data.noQas |= MPT_TARGET_NO_NEGO_QAS;
-					ddvprintk((KERN_INFO MYNAM " :%s noQas due to Capabilities=%x\n",
+					ddvprintk(ioc, printk(KERN_INFO MYNAM
+						" :%s noQas due to Capabilities=%x\n",
 						ioc->name, pPP0->Capabilities));
 				}
 				ioc->spi_data.maxBusWidth = pPP0->Capabilities & MPI_SCSIPORTPAGE0_CAP_WIDE ? 1 : 0;
@@ -4817,7 +4819,8 @@ mpt_GetScsiPortSettings(MPT_ADAPTER *ioc
 					ioc->spi_data.maxSyncOffset = (u8) (data >> 16);
 					data = pPP0->Capabilities & MPI_SCSIPORTPAGE0_CAP_MIN_SYNC_PERIOD_MASK;
 					ioc->spi_data.minSyncFactor = (u8) (data >> 8);
-					ddvprintk((MYIOC_s_INFO_FMT "PortPage0 minSyncFactor=%x\n",
+					ddvprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+						"PortPage0 minSyncFactor=%x\n",
 						ioc->name, ioc->spi_data.minSyncFactor));
 				} else {
 					ioc->spi_data.maxSyncOffset = 0;
@@ -4833,7 +4836,8 @@ mpt_GetScsiPortSettings(MPT_ADAPTER *ioc
 
 					if (ioc->spi_data.minSyncFactor < MPT_ULTRA) {
 						ioc->spi_data.minSyncFactor = MPT_ULTRA;
-						ddvprintk((MYIOC_s_INFO_FMT "HVD or SE detected, minSyncFactor=%x\n",
+						ddvprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+							"HVD or SE detected, minSyncFactor=%x\n",
 							ioc->name, ioc->spi_data.minSyncFactor));
 					}
 				}
@@ -4949,10 +4953,10 @@ mpt_readScsiDevicePageHeaders(MPT_ADAPTE
 	ioc->spi_data.sdp0version = cfg.cfghdr.hdr->PageVersion;
 	ioc->spi_data.sdp0length = cfg.cfghdr.hdr->PageLength;
 
-	dcprintk((MYIOC_s_INFO_FMT "Headers: 0: version %d length %d\n",
+	dcprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Headers: 0: version %d length %d\n",
 			ioc->name, ioc->spi_data.sdp0version, ioc->spi_data.sdp0length));
 
-	dcprintk((MYIOC_s_INFO_FMT "Headers: 1: version %d length %d\n",
+	dcprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Headers: 1: version %d length %d\n",
 			ioc->name, ioc->spi_data.sdp1version, ioc->spi_data.sdp1length));
 	return 0;
 }
@@ -5361,12 +5365,12 @@ mpt_read_ioc_pg_1(MPT_ADAPTER *ioc)
 	cfg.physAddr = ioc1_dma;
 	cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
 	if (mpt_config(ioc, &cfg) == 0) {
-		
+
 		tmp = le32_to_cpu(pIoc1->Flags) & MPI_IOCPAGE1_REPLY_COALESCING;
 		if (tmp == MPI_IOCPAGE1_REPLY_COALESCING) {
 			tmp = le32_to_cpu(pIoc1->CoalescingTimeout);
 
-			dprintk((MYIOC_s_INFO_FMT "Coalescing Enabled Timeout = %d\n",
+			dprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Coalescing Enabled Timeout = %d\n",
 					ioc->name, tmp));
 
 			if (tmp > MPT_COALESCING_TIMEOUT) {
@@ -5377,26 +5381,29 @@ mpt_read_ioc_pg_1(MPT_ADAPTER *ioc)
 				cfg.dir = 1;
 				cfg.action = MPI_CONFIG_ACTION_PAGE_WRITE_CURRENT;
 				if (mpt_config(ioc, &cfg) == 0) {
-					dprintk((MYIOC_s_INFO_FMT "Reset Current Coalescing Timeout to = %d\n",
+					dprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Reset Current Coalescing Timeout to = %d\n",
 							ioc->name, MPT_COALESCING_TIMEOUT));
 
 					cfg.action = MPI_CONFIG_ACTION_PAGE_WRITE_NVRAM;
 					if (mpt_config(ioc, &cfg) == 0) {
-						dprintk((MYIOC_s_INFO_FMT "Reset NVRAM Coalescing Timeout to = %d\n",
+						dprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+								"Reset NVRAM Coalescing Timeout to = %d\n",
 								ioc->name, MPT_COALESCING_TIMEOUT));
 					} else {
-						dprintk((MYIOC_s_INFO_FMT "Reset NVRAM Coalescing Timeout Failed\n",
-									ioc->name));
+						dprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+								"Reset NVRAM Coalescing Timeout Failed\n",
+								ioc->name));
 					}
 
 				} else {
-					dprintk((MYIOC_s_WARN_FMT "Reset of Current Coalescing Timeout Failed!\n",
-								ioc->name));
+					dprintk(ioc, printk(MYIOC_s_WARN_FMT
+						"Reset of Current Coalescing Timeout Failed!\n",
+						ioc->name));
 				}
 			}
 
 		} else {
-			dprintk((MYIOC_s_WARN_FMT "Coalescing Disabled\n", ioc->name));
+			dprintk(ioc, printk(MYIOC_s_WARN_FMT "Coalescing Disabled\n", ioc->name));
 		}
 	}
 
@@ -5461,13 +5468,13 @@ SendEventNotification(MPT_ADAPTER *ioc, 
 
 	evnp = (EventNotification_t *) mpt_get_msg_frame(mpt_base_index, ioc);
 	if (evnp == NULL) {
-		devtverboseprintk((MYIOC_s_WARN_FMT "Unable to allocate event request frame!\n",
+		devtverboseprintk(ioc, printk(MYIOC_s_WARN_FMT "Unable to allocate event request frame!\n",
 				ioc->name));
 		return 0;
 	}
 	memset(evnp, 0, sizeof(*evnp));
 
-	devtverboseprintk((MYIOC_s_INFO_FMT "Sending EventNotification (%d) request %p\n", ioc->name, EvSwitch, evnp));
+	devtverboseprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Sending EventNotification (%d) request %p\n", ioc->name, EvSwitch, evnp));
 
 	evnp->Function = MPI_FUNCTION_EVENT_NOTIFICATION;
 	evnp->ChainOffset = 0;
@@ -5491,12 +5498,12 @@ SendEventAck(MPT_ADAPTER *ioc, EventNoti
 	EventAck_t	*pAck;
 
 	if ((pAck = (EventAck_t *) mpt_get_msg_frame(mpt_base_index, ioc)) == NULL) {
-		dfailprintk((MYIOC_s_WARN_FMT "%s, no msg frames!!\n",
+		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT "%s, no msg frames!!\n",
 		    ioc->name,__FUNCTION__));
 		return -1;
 	}
 
-	devtverboseprintk((MYIOC_s_INFO_FMT "Sending EventAck\n", ioc->name));
+	devtverboseprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Sending EventAck\n", ioc->name));
 
 	pAck->Function     = MPI_FUNCTION_EVENT_ACK;
 	pAck->ChainOffset  = 0;
@@ -5541,7 +5548,7 @@ mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS
 	 */
 	in_isr = in_interrupt();
 	if (in_isr) {
-		dcprintk((MYIOC_s_WARN_FMT "Config request not allowed in ISR context!\n",
+		dcprintk(ioc, printk(MYIOC_s_WARN_FMT "Config request not allowed in ISR context!\n",
 				ioc->name));
 		return -EPERM;
 	}
@@ -5549,7 +5556,7 @@ mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS
 	/* Get and Populate a free Frame
 	 */
 	if ((mf = mpt_get_msg_frame(mpt_base_index, ioc)) == NULL) {
-		dcprintk((MYIOC_s_WARN_FMT "mpt_config: no msg frames!\n",
+		dcprintk(ioc, printk(MYIOC_s_WARN_FMT "mpt_config: no msg frames!\n",
 				ioc->name));
 		return -EAGAIN;
 	}
@@ -5594,13 +5601,13 @@ mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS
 	if ((pCfg->cfghdr.hdr->PageType & MPI_CONFIG_PAGETYPE_MASK) == MPI_CONFIG_PAGETYPE_EXTENDED) {
 		flagsLength |= pExtHdr->ExtPageLength * 4;
 
-		dcprintk((MYIOC_s_INFO_FMT "Sending Config request type %d, page %d and action %d\n",
+		dcprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Sending Config request type %d, page %d and action %d\n",
 			ioc->name, pReq->ExtPageType, pReq->Header.PageNumber, pReq->Action));
 	}
 	else {
 		flagsLength |= pCfg->cfghdr.hdr->PageLength * 4;
 
-		dcprintk((MYIOC_s_INFO_FMT "Sending Config request type %d, page %d and action %d\n",
+		dcprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Sending Config request type %d, page %d and action %d\n",
 			ioc->name, pReq->Header.PageType, pReq->Header.PageNumber, pReq->Action));
 	}
 
@@ -5650,7 +5657,7 @@ mpt_timer_expired(unsigned long data)
 {
 	MPT_ADAPTER *ioc = (MPT_ADAPTER *) data;
 
-	dcprintk((MYIOC_s_WARN_FMT "mpt_timer_expired! \n", ioc->name));
+	dcprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mpt_timer_expired! \n", ioc->name));
 
 	/* Perform a FW reload */
 	if (mpt_HardResetHandler(ioc, NO_SLEEP) < 0)
@@ -5660,7 +5667,7 @@ mpt_timer_expired(unsigned long data)
 	 * Hard reset clean-up will wake up
 	 * process and free all resources.
 	 */
-	dcprintk((MYIOC_s_WARN_FMT "mpt_timer_expired complete!\n", ioc->name));
+	dcprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mpt_timer_expired complete!\n", ioc->name));
 
 	return;
 }
@@ -5679,7 +5686,7 @@ mpt_ioc_reset(MPT_ADAPTER *ioc, int rese
 	CONFIGPARMS *pCfg;
 	unsigned long flags;
 
-	dprintk((KERN_WARNING MYNAM
+	dprintk(ioc, printk(KERN_DEBUG MYNAM
 			": IOC %s_reset routed to MPT base driver!\n",
 			reset_phase==MPT_IOC_SETUP_RESET ? "setup" : (
 			reset_phase==MPT_IOC_PRE_RESET ? "pre" : "post")));
@@ -6050,7 +6057,7 @@ mpt_HardResetHandler(MPT_ADAPTER *ioc, i
 	int		 rc;
 	unsigned long	 flags;
 
-	dtmprintk((MYIOC_s_INFO_FMT "HardResetHandler Entered!\n", ioc->name));
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "HardResetHandler Entered!\n", ioc->name));
 #ifdef MFCNT
 	printk(MYIOC_s_INFO_FMT "HardResetHandler Entered!\n", ioc->name);
 	printk("MF count 0x%x !\n", ioc->mfcnt);
@@ -6082,11 +6089,11 @@ mpt_HardResetHandler(MPT_ADAPTER *ioc, i
 
 		for (ii=MPT_MAX_PROTOCOL_DRIVERS-1; ii; ii--) {
 			if (MptResetHandlers[ii]) {
-				dtmprintk((MYIOC_s_INFO_FMT "Calling IOC reset_setup handler #%d\n",
+				dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Calling IOC reset_setup handler #%d\n",
 						ioc->name, ii));
 				r += mpt_signal_reset(ii, ioc, MPT_IOC_SETUP_RESET);
 				if (ioc->alt_ioc) {
-					dtmprintk((MYIOC_s_INFO_FMT "Calling alt-%s setup reset handler #%d\n",
+					dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Calling alt-%s setup reset handler #%d\n",
 							ioc->name, ioc->alt_ioc->name, ii));
 					r += mpt_signal_reset(ii, ioc->alt_ioc, MPT_IOC_SETUP_RESET);
 				}
@@ -6108,7 +6115,7 @@ mpt_HardResetHandler(MPT_ADAPTER *ioc, i
 		ioc->alt_ioc->diagPending = 0;
 	spin_unlock_irqrestore(&ioc->diagLock, flags);
 
-	dtmprintk((MYIOC_s_INFO_FMT "HardResetHandler rc = %d!\n", ioc->name, rc));
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "HardResetHandler rc = %d!\n", ioc->name, rc));
 
 	return rc;
 }
@@ -6509,16 +6516,18 @@ ProcessEventNotification(MPT_ADAPTER *io
 	}
 
 	EventDescriptionStr(event, evData0, evStr);
-	devtprintk((MYIOC_s_INFO_FMT "MPT event:(%02Xh) : %s\n",
+	devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT "MPT event:(%02Xh) : %s\n",
 			ioc->name,
 			event,
 			evStr));
 
-#if defined(MPT_DEBUG) || defined(MPT_DEBUG_VERBOSE_EVENTS)
-	printk(KERN_INFO MYNAM ": Event data:\n" KERN_INFO);
+#ifdef CONFIG_FUSION_LOGGING
+	devtverboseprintk(ioc, printk(KERN_DEBUG MYNAM
+	    ": Event data:\n"));
 	for (ii = 0; ii < evDataLen; ii++)
-		printk(" %08x", le32_to_cpu(pEventReply->Data[ii]));
-	printk("\n");
+		devtverboseprintk(ioc, printk(" %08x",
+		    le32_to_cpu(pEventReply->Data[ii])));
+	devtverboseprintk(ioc, printk(KERN_DEBUG "\n"));
 #endif
 
 	/*
@@ -6573,7 +6582,7 @@ ProcessEventNotification(MPT_ADAPTER *io
 	 */
 	for (ii=MPT_MAX_PROTOCOL_DRIVERS-1; ii; ii--) {
 		if (MptEvHandlers[ii]) {
-			devtverboseprintk((MYIOC_s_INFO_FMT "Routing Event to event handler #%d\n",
+			devtverboseprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Routing Event to event handler #%d\n",
 					ioc->name, ii));
 			r += (*(MptEvHandlers[ii]))(ioc, pEventReply);
 			handlers++;
@@ -6585,10 +6594,10 @@ ProcessEventNotification(MPT_ADAPTER *io
 	 *  If needed, send (a single) EventAck.
 	 */
 	if (pEventReply->AckRequired == MPI_EVENT_NOTIFICATION_ACK_REQUIRED) {
-		devtverboseprintk((MYIOC_s_WARN_FMT
+		devtverboseprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 			"EventAck required\n",ioc->name));
 		if ((ii = SendEventAck(ioc, pEventReply)) != 0) {
-			devtverboseprintk((MYIOC_s_WARN_FMT "SendEventAck returned %d\n",
+			devtverboseprintk(ioc, printk(MYIOC_s_DEBUG_FMT "SendEventAck returned %d\n",
 					ioc->name, ii));
 		}
 	}
@@ -6935,7 +6944,6 @@ union loginfo_type {
 			sas_loginfo.dw.code, sas_loginfo.dw.subcode);
 }
 
-#ifdef MPT_DEBUG_REPLY
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mpt_iocstatus_info_config - IOCSTATUS information for config pages
@@ -7240,7 +7248,6 @@ mpt_iocstatus_info(MPT_ADAPTER *ioc, u32
 
 	printk(MYIOC_s_INFO_FMT "IOCStatus(0x%04X): %s\n", ioc->name, status, desc);
 }
-#endif
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 EXPORT_SYMBOL(mpt_attach);
@@ -7305,11 +7312,7 @@ fusion_init(void)
 
 	/* Register for hard reset handling callbacks.
 	 */
-	if (mpt_reset_register(mpt_base_index, mpt_ioc_reset) == 0) {
-		dprintk((KERN_INFO MYNAM ": Register for IOC reset notification\n"));
-	} else {
-		/* FIXME! */
-	}
+	mpt_reset_register(mpt_base_index, mpt_ioc_reset);
 
 #ifdef CONFIG_PROC_FS
 	(void) procmpt_create();
@@ -7328,8 +7331,6 @@ static void __exit
 fusion_exit(void)
 {
 
-	dexitprintk((KERN_INFO MYNAM ": fusion_exit() called!\n"));
-
 	mpt_reset_deregister(mpt_base_index);
 
 #ifdef CONFIG_PROC_FS
