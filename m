From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 1/24] mpt fusion: [2.6.30-rc6] Fixing 1078 data corruption issue for 36GB memory region
Date: Fri, 22 May 2009 16:08:49 +0530
Message-ID: <20090522103849.GC16245@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og124.obsmtp.com ([64.18.2.26]:47665 "EHLO
	exprod7og124.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbZEVK7y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2009 06:59:54 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


The reason for this change is there is a data corruption when four different
physical memory regions in the 36GB to 37GB region are
accessed. This is only affecting 1078.

The solution is we need to use different addressing when filling in  
the scatter gather table for the effected memory regions.  So instead
of snooping on all four different memory holes, we treat any physical
addresses in the 36GB address with the same algorithm.

The fix is explained below
1) Ensure that the message frames are NOT located in the trouble  
region. There is no remapping available for message frames, they must
be allocated outside the problem region.
2) Ensure that Sense buffers are NOT in the trouble region. There is
no remapping available.
3) Walk through the SGE entries and if any are inside the trouble region 
   then they need to be remapped as discussed below.
	1) Set the Local Address bit in the SGE Flags field.
  	MPI_SGE_FLAGS_LOCAL_ADDRESS
  	2) Ensure we are using 64-bit SGEs
  	3) Set MSb (Bit 63) of the 64-bit address, this will indicate buffer 
	location is Host Memory.

Signed-off-by: Kashyap Desai <kadesai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 5d496a9..a663692 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -998,7 +998,7 @@ mpt_free_msg_frame(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf)
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
- *	mpt_add_sge - Place a simple SGE at address pAddr.
+ *	mpt_add_sge - Place a simple 32 bit SGE at address pAddr.
  *	@pAddr: virtual address for SGE
  *	@flagslength: SGE flags and data transfer length
  *	@dma_addr: Physical address
@@ -1006,23 +1006,117 @@ mpt_free_msg_frame(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf)
  *	This routine places a MPT request frame back on the MPT adapter's
  *	FreeQ.
  */
-void
-mpt_add_sge(char *pAddr, u32 flagslength, dma_addr_t dma_addr)
+static void
+mpt_add_sge(void *pAddr, u32 flagslength, dma_addr_t dma_addr)
 {
-	if (sizeof(dma_addr_t) == sizeof(u64)) {
-		SGESimple64_t *pSge = (SGESimple64_t *) pAddr;
+	SGESimple32_t *pSge = (SGESimple32_t *) pAddr;
+	pSge->FlagsLength = cpu_to_le32(flagslength);
+	pSge->Address = cpu_to_le32(dma_addr);
+}
+
+/**
+ *	mpt_add_sge_64bit - Place a simple 64 bit SGE at address pAddr.
+ *	@pAddr: virtual address for SGE
+ *	@flagslength: SGE flags and data transfer length
+ *	@dma_addr: Physical address
+ *
+ *	This routine places a MPT request frame back on the MPT adapter's
+ *	FreeQ.
+ **/
+static void
+mpt_add_sge_64bit(void *pAddr, u32 flagslength, dma_addr_t dma_addr)
+{
+	SGESimple64_t *pSge = (SGESimple64_t *) pAddr;
+	pSge->Address.Low = cpu_to_le32
+			(lower_32_bits((unsigned long)(dma_addr)));
+	pSge->Address.High = cpu_to_le32
+			(upper_32_bits((unsigned long)dma_addr));
+	pSge->FlagsLength = cpu_to_le32
+			((flagslength | MPT_SGE_FLAGS_64_BIT_ADDRESSING));
+}
+
+/**
+ *	mpt_add_sge_64bit_1078 - Place a simple 64 bit SGE at address pAddr
+ *	(1078 workaround).
+ *	@pAddr: virtual address for SGE
+ *	@flagslength: SGE flags and data transfer length
+ *	@dma_addr: Physical address
+ *
+ *	This routine places a MPT request frame back on the MPT adapter's
+ *	FreeQ.
+ **/
+static void
+mpt_add_sge_64bit_1078(void *pAddr, u32 flagslength, dma_addr_t dma_addr)
+{
+	SGESimple64_t *pSge = (SGESimple64_t *) pAddr;
+	u32 tmp;
+
+	pSge->Address.Low = cpu_to_le32
+			(lower_32_bits((unsigned long)(dma_addr)));
+	tmp = (u32)(upper_32_bits((unsigned long)dma_addr));
+
+	/*
+	 * 1078 errata workaround for the 36GB limitation
+	 */
+	if ((((u64)dma_addr + MPI_SGE_LENGTH(flagslength)) >> 32)  == 9) {
+		flagslength |=
+		    MPI_SGE_SET_FLAGS(MPI_SGE_FLAGS_LOCAL_ADDRESS);
+		tmp |= (1<<31);
+		if (mpt_debug_level & MPT_DEBUG_36GB_MEM)
+			printk(KERN_DEBUG "1078 P0M2 addressing for "
+			    "addr = 0x%llx len = %d\n",
+			    (unsigned long long)dma_addr,
+			    MPI_SGE_LENGTH(flagslength));
+	}
+
+	pSge->Address.High = cpu_to_le32(tmp);
+	pSge->FlagsLength = cpu_to_le32(
+		(flagslength | MPT_SGE_FLAGS_64_BIT_ADDRESSING));
+}
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/**
+ *	mpt_add_chain - Place a 32 bit chain SGE at address pAddr.
+ *	@pAddr: virtual address for SGE
+ *	@next: nextChainOffset value (u32's)
+ *	@length: length of next SGL segment
+ *	@dma_addr: Physical address
+ *
+ */
+static void
+mpt_add_chain(void *pAddr, u8 next, u16 length, dma_addr_t dma_addr)
+{
+		SGEChain32_t *pChain = (SGEChain32_t *) pAddr;
+		pChain->Length = cpu_to_le16(length);
+		pChain->Flags = MPI_SGE_FLAGS_CHAIN_ELEMENT;
+		pChain->NextChainOffset = next;
+		pChain->Address = cpu_to_le32(dma_addr);
+}
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/**
+ *	mpt_add_chain_64bit - Place a 64 bit chain SGE at address pAddr.
+ *	@pAddr: virtual address for SGE
+ *	@next: nextChainOffset value (u32's)
+ *	@length: length of next SGL segment
+ *	@dma_addr: Physical address
+ *
+ */
+static void
+mpt_add_chain_64bit(void *pAddr, u8 next, u16 length, dma_addr_t dma_addr)
+{
+		SGEChain64_t *pChain = (SGEChain64_t *) pAddr;
 		u32 tmp = dma_addr & 0xFFFFFFFF;
 
-		pSge->FlagsLength = cpu_to_le32(flagslength);
-		pSge->Address.Low = cpu_to_le32(tmp);
-		tmp = (u32) ((u64)dma_addr >> 32);
-		pSge->Address.High = cpu_to_le32(tmp);
+		pChain->Length = cpu_to_le16(length);
+		pChain->Flags = (MPI_SGE_FLAGS_CHAIN_ELEMENT |
+				 MPI_SGE_FLAGS_64_BIT_ADDRESSING);
 
-	} else {
-		SGESimple32_t *pSge = (SGESimple32_t *) pAddr;
-		pSge->FlagsLength = cpu_to_le32(flagslength);
-		pSge->Address = cpu_to_le32(dma_addr);
-	}
+		pChain->NextChainOffset = next;
+
+		pChain->Address.Low = cpu_to_le32(tmp);
+		tmp = (u32)(upper_32_bits((unsigned long)dma_addr));
+		pChain->Address.High = cpu_to_le32(tmp);
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -1225,7 +1319,7 @@ mpt_host_page_alloc(MPT_ADAPTER *ioc, pIOCInit_t ioc_init)
 	}
 	flags_length = flags_length << MPI_SGE_FLAGS_SHIFT;
 	flags_length |= ioc->HostPageBuffer_sz;
-	mpt_add_sge(psge, flags_length, ioc->HostPageBuffer_dma);
+	ioc->add_sge(psge, flags_length, ioc->HostPageBuffer_dma);
 	ioc->facts.HostPageBufferSGE = ioc_init->HostPageBufferSGE;
 
 return 0;
@@ -1534,21 +1628,42 @@ mpt_mapresources(MPT_ADAPTER *ioc)
 
 	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &revision);
 
-	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))
-	    && !pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64))) {
-		dinitprintk(ioc, printk(MYIOC_s_INFO_FMT
-		    ": 64 BIT PCI BUS DMA ADDRESSING SUPPORTED\n",
-		    ioc->name));
-	} else if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))
-	    && !pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32))) {
-		dinitprintk(ioc, printk(MYIOC_s_INFO_FMT
-		    ": 32 BIT PCI BUS DMA ADDRESSING SUPPORTED\n",
-		    ioc->name));
+	if (sizeof(dma_addr_t) > 4) {
+		const uint64_t required_mask = dma_get_required_mask
+		    (&pdev->dev);
+		if (required_mask > DMA_BIT_MASK(32)
+			&& !pci_set_dma_mask(pdev, DMA_BIT_MASK(64))
+			&& !pci_set_consistent_dma_mask(pdev,
+						 DMA_BIT_MASK(64))) {
+			ioc->dma_mask = DMA_BIT_MASK(64);
+			dinitprintk(ioc, printk(MYIOC_s_INFO_FMT
+				": 64 BIT PCI BUS DMA ADDRESSING SUPPORTED\n",
+				ioc->name));
+		} else if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))
+			&& !pci_set_consistent_dma_mask(pdev,
+						DMA_BIT_MASK(32))) {
+			ioc->dma_mask = DMA_BIT_MASK(32);
+			dinitprintk(ioc, printk(MYIOC_s_INFO_FMT
+				": 32 BIT PCI BUS DMA ADDRESSING SUPPORTED\n",
+				ioc->name));
+		} else {
+			printk(MYIOC_s_WARN_FMT "no suitable DMA mask for %s\n",
+			    ioc->name, pci_name(pdev));
+			return r;
+		}
 	} else {
-		printk(MYIOC_s_WARN_FMT "no suitable DMA mask for %s\n",
-		    ioc->name, pci_name(pdev));
-		pci_release_selected_regions(pdev, ioc->bars);
-		return r;
+		if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))
+			&& !pci_set_consistent_dma_mask(pdev,
+						DMA_BIT_MASK(32))) {
+			ioc->dma_mask = DMA_BIT_MASK(32);
+			dinitprintk(ioc, printk(MYIOC_s_INFO_FMT
+				": 32 BIT PCI BUS DMA ADDRESSING SUPPORTED\n",
+				ioc->name));
+		} else {
+			printk(MYIOC_s_WARN_FMT "no suitable DMA mask for %s\n",
+			    ioc->name, pci_name(pdev));
+			return r;
+		}
 	}
 
 	mem_phys = msize = 0;
@@ -1650,6 +1765,23 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 		return r;
 	}
 
+	/*
+	 * Setting up proper handlers for scatter gather handling
+	 */
+	if (ioc->dma_mask == DMA_BIT_MASK(64)) {
+		if (pdev->device == MPI_MANUFACTPAGE_DEVID_SAS1078)
+			ioc->add_sge = &mpt_add_sge_64bit_1078;
+		else
+			ioc->add_sge = &mpt_add_sge_64bit;
+		ioc->add_chain = &mpt_add_chain_64bit;
+		ioc->sg_addr_size = 8;
+	} else {
+		ioc->add_sge = &mpt_add_sge;
+		ioc->add_chain = &mpt_add_chain;
+		ioc->sg_addr_size = 4;
+	}
+	ioc->SGE_size = sizeof(u32) + ioc->sg_addr_size;
+
 	ioc->alloc_total = sizeof(MPT_ADAPTER);
 	ioc->req_sz = MPT_DEFAULT_FRAME_SIZE;		/* avoid div by zero! */
 	ioc->reply_sz = MPT_REPLY_FRAME_SIZE;
@@ -1994,6 +2126,21 @@ mpt_resume(struct pci_dev *pdev)
 	if (err)
 		return err;
 
+	if (ioc->dma_mask == DMA_BIT_MASK(64)) {
+		if (pdev->device == MPI_MANUFACTPAGE_DEVID_SAS1078)
+			ioc->add_sge = &mpt_add_sge_64bit_1078;
+		else
+			ioc->add_sge = &mpt_add_sge_64bit;
+		ioc->add_chain = &mpt_add_chain_64bit;
+		ioc->sg_addr_size = 8;
+	} else {
+
+		ioc->add_sge = &mpt_add_sge;
+		ioc->add_chain = &mpt_add_chain;
+		ioc->sg_addr_size = 4;
+	}
+	ioc->SGE_size = sizeof(u32) + ioc->sg_addr_size;
+
 	printk(MYIOC_s_INFO_FMT "pci-resume: ioc-state=0x%x,doorbell=0x%x\n",
 	    ioc->name, (mpt_GetIocState(ioc, 1) >> MPI_IOC_STATE_SHIFT),
 	    CHIPREG_READ32(&ioc->chip->Doorbell));
@@ -3325,11 +3472,10 @@ mpt_do_upload(MPT_ADAPTER *ioc, int sleepFlag)
 	FWUpload_t		*prequest;
 	FWUploadReply_t		*preply;
 	FWUploadTCSGE_t		*ptcsge;
-	int			 sgeoffset;
 	u32			 flagsLength;
 	int			 ii, sz, reply_sz;
 	int			 cmdStatus;
-
+	int			request_size;
 	/* If the image size is 0, we are done.
 	 */
 	if ((sz = ioc->facts.FWImageSize) == 0)
@@ -3364,18 +3510,17 @@ mpt_do_upload(MPT_ADAPTER *ioc, int sleepFlag)
 	ptcsge->ImageSize = cpu_to_le32(sz);
 	ptcsge++;
 
-	sgeoffset = sizeof(FWUpload_t) - sizeof(SGE_MPI_UNION) + sizeof(FWUploadTCSGE_t);
-
 	flagsLength = MPT_SGE_FLAGS_SSIMPLE_READ | sz;
-	mpt_add_sge((char *)ptcsge, flagsLength, ioc->cached_fw_dma);
-
-	sgeoffset += sizeof(u32) + sizeof(dma_addr_t);
-	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT ": Sending FW Upload (req @ %p) sgeoffset=%d \n",
-	    ioc->name, prequest, sgeoffset));
+	ioc->add_sge((char *)ptcsge, flagsLength, ioc->cached_fw_dma);
+	request_size = offsetof(FWUpload_t, SGL) + sizeof(FWUploadTCSGE_t) +
+	    ioc->SGE_size;
+	dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Sending FW Upload "
+	    " (req @ %p) fw_size=%d mf_request_size=%d\n", ioc->name, prequest,
+	    ioc->facts.FWImageSize, request_size));
 	DBG_DUMP_FW_REQUEST_FRAME(ioc, (u32 *)prequest);
 
-	ii = mpt_handshake_req_reply_wait(ioc, sgeoffset, (u32*)prequest,
-				reply_sz, (u16*)preply, 65 /*seconds*/, sleepFlag);
+	ii = mpt_handshake_req_reply_wait(ioc, request_size, (u32 *)prequest,
+	    reply_sz, (u16 *)preply, 65 /*seconds*/, sleepFlag);
 
 	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT ": FW Upload completed rc=%x \n", ioc->name, ii));
 
@@ -4090,18 +4235,18 @@ initChainBuffers(MPT_ADAPTER *ioc)
 	 * num_sge = num sge in request frame + last chain buffer
 	 * scale = num sge per chain buffer if no chain element
 	 */
-	scale = ioc->req_sz/(sizeof(dma_addr_t) + sizeof(u32));
-	if (sizeof(dma_addr_t) == sizeof(u64))
-		num_sge =  scale + (ioc->req_sz - 60) / (sizeof(dma_addr_t) + sizeof(u32));
+	scale = ioc->req_sz / ioc->SGE_size;
+	if (ioc->sg_addr_size == sizeof(u64))
+		num_sge =  scale + (ioc->req_sz - 60) / ioc->SGE_size;
 	else
-		num_sge =  1+ scale + (ioc->req_sz - 64) / (sizeof(dma_addr_t) + sizeof(u32));
+		num_sge =  1 + scale + (ioc->req_sz - 64) / ioc->SGE_size;
 
-	if (sizeof(dma_addr_t) == sizeof(u64)) {
+	if (ioc->sg_addr_size == sizeof(u64)) {
 		numSGE = (scale - 1) * (ioc->facts.MaxChainDepth-1) + scale +
-			(ioc->req_sz - 60) / (sizeof(dma_addr_t) + sizeof(u32));
+			(ioc->req_sz - 60) / ioc->SGE_size;
 	} else {
-		numSGE = 1 + (scale - 1) * (ioc->facts.MaxChainDepth-1) + scale +
-			(ioc->req_sz - 64) / (sizeof(dma_addr_t) + sizeof(u32));
+		numSGE = 1 + (scale - 1) * (ioc->facts.MaxChainDepth-1) +
+		    scale + (ioc->req_sz - 64) / ioc->SGE_size;
 	}
 	dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "num_sge=%d numSGE=%d\n",
 		ioc->name, num_sge, numSGE));
@@ -4161,12 +4306,42 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 	dma_addr_t alloc_dma;
 	u8 *mem;
 	int i, reply_sz, sz, total_size, num_chain;
+	u64	dma_mask;
+
+	dma_mask = 0;
 
 	/*  Prime reply FIFO...  */
 
 	if (ioc->reply_frames == NULL) {
 		if ( (num_chain = initChainBuffers(ioc)) < 0)
 			return -1;
+		/*
+		 * 1078 errata workaround for the 36GB limitation
+		 */
+		if (ioc->pcidev->device == MPI_MANUFACTPAGE_DEVID_SAS1078 &&
+		    ioc->dma_mask > DMA_35BIT_MASK) {
+			if (!pci_set_dma_mask(ioc->pcidev, DMA_BIT_MASK(32))
+			    && !pci_set_consistent_dma_mask(ioc->pcidev,
+			    DMA_BIT_MASK(32))) {
+				dma_mask = DMA_35BIT_MASK;
+				d36memprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+				    "setting 35 bit addressing for "
+				    "Request/Reply/Chain and Sense Buffers\n",
+				    ioc->name));
+			} else {
+				/*Reseting DMA mask to 64 bit*/
+				pci_set_dma_mask(ioc->pcidev,
+					DMA_BIT_MASK(64));
+				pci_set_consistent_dma_mask(ioc->pcidev,
+					DMA_BIT_MASK(64));
+
+				printk(MYIOC_s_ERR_FMT
+				    "failed setting 35 bit addressing for "
+				    "Request/Reply/Chain and Sense Buffers\n",
+				    ioc->name);
+				return -1;
+			}
+		}
 
 		total_size = reply_sz = (ioc->reply_sz * ioc->reply_depth);
 		dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "ReplyBuffer sz=%d bytes, ReplyDepth=%d\n",
@@ -4305,6 +4480,12 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 		alloc_dma += ioc->reply_sz;
 	}
 
+	if (dma_mask == DMA_35BIT_MASK && !pci_set_dma_mask(ioc->pcidev,
+	    ioc->dma_mask) && !pci_set_consistent_dma_mask(ioc->pcidev,
+	    ioc->dma_mask))
+		d36memprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "restoring 64 bit addressing\n", ioc->name));
+
 	return 0;
 
 out_fail:
@@ -4324,6 +4505,13 @@ out_fail:
 				ioc->sense_buf_pool, ioc->sense_buf_pool_dma);
 		ioc->sense_buf_pool = NULL;
 	}
+
+	if (dma_mask == DMA_35BIT_MASK && !pci_set_dma_mask(ioc->pcidev,
+	    DMA_BIT_MASK(64)) && !pci_set_consistent_dma_mask(ioc->pcidev,
+	    DMA_BIT_MASK(64)))
+		d36memprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "restoring 64 bit addressing\n", ioc->name));
+
 	return -1;
 }
 
@@ -5926,7 +6114,7 @@ mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS *pCfg)
 			ioc->name, pReq->Header.PageType, pReq->Header.PageNumber, pReq->Action));
 	}
 
-	mpt_add_sge((char *)&pReq->PageBufferSGE, flagsLength, pCfg->physAddr);
+	ioc->add_sge((char *)&pReq->PageBufferSGE, flagsLength, pCfg->physAddr);
 
 	/* Append pCfg pointer to end of mf
 	 */
@@ -7613,7 +7801,6 @@ EXPORT_SYMBOL(mpt_get_msg_frame);
 EXPORT_SYMBOL(mpt_put_msg_frame);
 EXPORT_SYMBOL(mpt_put_msg_frame_hi_pri);
 EXPORT_SYMBOL(mpt_free_msg_frame);
-EXPORT_SYMBOL(mpt_add_sge);
 EXPORT_SYMBOL(mpt_send_handshake_request);
 EXPORT_SYMBOL(mpt_verify_adapter);
 EXPORT_SYMBOL(mpt_GetIocState);
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index b3e981d..e75300c 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -76,8 +76,8 @@
 #define COPYRIGHT	"Copyright (c) 1999-2008 " MODULEAUTHOR
 #endif
 
-#define MPT_LINUX_VERSION_COMMON	"3.04.07"
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.07"
+#define MPT_LINUX_VERSION_COMMON	"3.04.08"
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.08"
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
 
 #define show_mptmod_ver(s,ver)  \
@@ -134,6 +134,7 @@
 
 #define MPT_COALESCING_TIMEOUT		0x10
 
+
 /*
  * SCSI transfer rate defines.
  */
@@ -564,6 +565,10 @@ struct mptfc_rport_info
 	u8		flags;
 };
 
+typedef void (*MPT_ADD_SGE)(void *pAddr, u32 flagslength, dma_addr_t dma_addr);
+typedef void (*MPT_ADD_CHAIN)(void *pAddr, u8 next, u16 length,
+		dma_addr_t dma_addr);
+
 /*
  *  Adapter Structure - pci_dev specific. Maximum: MPT_MAX_ADAPTERS
  */
@@ -600,6 +605,10 @@ typedef struct _MPT_ADAPTER
 	int			 reply_depth;	/* Num Allocated reply frames */
 	int			 reply_sz;	/* Reply frame size */
 	int			 num_chain;	/* Number of chain buffers */
+	MPT_ADD_SGE              add_sge;       /* Pointer to add_sge
+						   function */
+	MPT_ADD_CHAIN		 add_chain;	/* Pointer to add_chain
+						   function */
 		/* Pool of buffers for chaining. ReqToChain
 		 * and ChainToChain track index of chain buffers.
 		 * ChainBuffer (DMA) virt/phys addresses.
@@ -711,12 +720,15 @@ typedef struct _MPT_ADAPTER
 	struct workqueue_struct *fc_rescan_work_q;
 	struct scsi_cmnd	**ScsiLookup;
 	spinlock_t		  scsi_lookup_lock;
-
+	u64			dma_mask;
 	char			 reset_work_q_name[20];
 	struct workqueue_struct *reset_work_q;
 	struct delayed_work	 fault_reset_work;
 	spinlock_t		 fault_reset_work_lock;
 
+	u8			sg_addr_size;
+	u8			SGE_size;
+
 } MPT_ADAPTER;
 
 /*
@@ -753,14 +765,14 @@ typedef struct _mpt_sge {
 	dma_addr_t	Address;
 } MptSge_t;
 
-#define mpt_addr_size() \
-	((sizeof(dma_addr_t) == sizeof(u64)) ? MPI_SGE_FLAGS_64_BIT_ADDRESSING : \
-		MPI_SGE_FLAGS_32_BIT_ADDRESSING)
 
 #define mpt_msg_flags() \
 	((sizeof(dma_addr_t) == sizeof(u64)) ? MPI_SCSIIO_MSGFLGS_SENSE_WIDTH_64 : \
 		MPI_SCSIIO_MSGFLGS_SENSE_WIDTH_32)
 
+#define MPT_SGE_FLAGS_64_BIT_ADDRESSING \
+	(MPI_SGE_FLAGS_64_BIT_ADDRESSING << MPI_SGE_FLAGS_SHIFT)
+
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
  *  Funky (private) macros...
@@ -909,7 +921,6 @@ extern MPT_FRAME_HDR	*mpt_get_msg_frame(u8 cb_idx, MPT_ADAPTER *ioc);
 extern void	 mpt_free_msg_frame(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf);
 extern void	 mpt_put_msg_frame(u8 cb_idx, MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf);
 extern void	 mpt_put_msg_frame_hi_pri(u8 cb_idx, MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf);
-extern void	 mpt_add_sge(char *pAddr, u32 flagslength, dma_addr_t dma_addr);
 
 extern int	 mpt_send_handshake_request(u8 cb_idx, MPT_ADAPTER *ioc, int reqBytes, u32 *req, int sleepFlag);
 extern int	 mpt_verify_adapter(int iocid, MPT_ADAPTER **iocpp);
@@ -959,7 +970,6 @@ extern int mpt_fwfault_debug;
 #define MPT_SGE_FLAGS_END_OF_BUFFER		(0x40000000)
 #define MPT_SGE_FLAGS_LOCAL_ADDRESS		(0x08000000)
 #define MPT_SGE_FLAGS_DIRECTION			(0x04000000)
-#define MPT_SGE_FLAGS_ADDRESSING		(mpt_addr_size() << MPI_SGE_FLAGS_SHIFT)
 #define MPT_SGE_FLAGS_END_OF_LIST		(0x01000000)
 
 #define MPT_SGE_FLAGS_TRANSACTION_ELEMENT	(0x00000000)
@@ -972,14 +982,12 @@ extern int mpt_fwfault_debug;
 	 MPT_SGE_FLAGS_END_OF_BUFFER |	\
 	 MPT_SGE_FLAGS_END_OF_LIST |	\
 	 MPT_SGE_FLAGS_SIMPLE_ELEMENT |	\
-	 MPT_SGE_FLAGS_ADDRESSING | \
 	 MPT_TRANSFER_IOC_TO_HOST)
 #define MPT_SGE_FLAGS_SSIMPLE_WRITE \
 	(MPT_SGE_FLAGS_LAST_ELEMENT |	\
 	 MPT_SGE_FLAGS_END_OF_BUFFER |	\
 	 MPT_SGE_FLAGS_END_OF_LIST |	\
 	 MPT_SGE_FLAGS_SIMPLE_ELEMENT |	\
-	 MPT_SGE_FLAGS_ADDRESSING | \
 	 MPT_TRANSFER_HOST_TO_IOC)
 
 /*}-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index c638171..55f6102 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -841,8 +841,9 @@ mptctl_do_fw_download(int ioc, char __user *ufwbuf, size_t fwlen)
 	 *	96		8
 	 *	64		4
 	 */
-	maxfrags = (iocp->req_sz - sizeof(MPIHeader_t) - sizeof(FWDownloadTCSGE_t))
-			/ (sizeof(dma_addr_t) + sizeof(u32));
+	maxfrags = (iocp->req_sz - sizeof(MPIHeader_t) -
+			sizeof(FWDownloadTCSGE_t))
+			/ iocp->SGE_size;
 	if (numfrags > maxfrags) {
 		ret = -EMLINK;
 		goto fwdl_out;
@@ -870,7 +871,7 @@ mptctl_do_fw_download(int ioc, char __user *ufwbuf, size_t fwlen)
 		if (nib == 0 || nib == 3) {
 			;
 		} else if (sgIn->Address) {
-			mpt_add_sge(sgOut, sgIn->FlagsLength, sgIn->Address);
+			iocp->add_sge(sgOut, sgIn->FlagsLength, sgIn->Address);
 			n++;
 			if (copy_from_user(bl->kptr, ufwbuf+fw_bytes_copied, bl->len)) {
 				printk(MYIOC_s_ERR_FMT "%s@%d::_ioctl_fwdl - "
@@ -882,7 +883,7 @@ mptctl_do_fw_download(int ioc, char __user *ufwbuf, size_t fwlen)
 		}
 		sgIn++;
 		bl++;
-		sgOut += (sizeof(dma_addr_t) + sizeof(u32));
+		sgOut += iocp->SGE_size;
 	}
 
 	DBG_DUMP_FW_DOWNLOAD(iocp, (u32 *)mf, numfrags);
@@ -1003,7 +1004,7 @@ kbuf_alloc_2_sgl(int bytes, u32 sgdir, int sge_offset, int *frags,
 	 *
 	 */
 	sgl = sglbuf;
-	sg_spill = ((ioc->req_sz - sge_offset)/(sizeof(dma_addr_t) + sizeof(u32))) - 1;
+	sg_spill = ((ioc->req_sz - sge_offset)/ioc->SGE_size) - 1;
 	while (bytes_allocd < bytes) {
 		this_alloc = min(alloc_sz, bytes-bytes_allocd);
 		buflist[buflist_ent].len = this_alloc;
@@ -1024,8 +1025,9 @@ kbuf_alloc_2_sgl(int bytes, u32 sgdir, int sge_offset, int *frags,
 			dma_addr_t dma_addr;
 
 			bytes_allocd += this_alloc;
-			sgl->FlagsLength = (0x10000000|MPT_SGE_FLAGS_ADDRESSING|sgdir|this_alloc);
-			dma_addr = pci_map_single(ioc->pcidev, buflist[buflist_ent].kptr, this_alloc, dir);
+			sgl->FlagsLength = (0x10000000|sgdir|this_alloc);
+			dma_addr = pci_map_single(ioc->pcidev,
+				buflist[buflist_ent].kptr, this_alloc, dir);
 			sgl->Address = dma_addr;
 
 			fragcnt++;
@@ -1799,9 +1801,9 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
 	 */
 	sz = karg.dataSgeOffset * 4;
 	if (karg.dataInSize > 0)
-		sz += sizeof(dma_addr_t) + sizeof(u32);
+		sz += ioc->SGE_size;
 	if (karg.dataOutSize > 0)
-		sz += sizeof(dma_addr_t) + sizeof(u32);
+		sz += ioc->SGE_size;
 
 	if (sz > ioc->req_sz) {
 		printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_do_mpt_command - "
@@ -2123,8 +2125,7 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
 			if (karg.dataInSize > 0) {
 				flagsLength = ( MPI_SGE_FLAGS_SIMPLE_ELEMENT |
 						MPI_SGE_FLAGS_END_OF_BUFFER |
-						MPI_SGE_FLAGS_DIRECTION |
-						mpt_addr_size() )
+						MPI_SGE_FLAGS_DIRECTION)
 						<< MPI_SGE_FLAGS_SHIFT;
 			} else {
 				flagsLength = MPT_SGE_FLAGS_SSIMPLE_WRITE;
@@ -2141,8 +2142,8 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
 				/* Set up this SGE.
 				 * Copy to MF and to sglbuf
 				 */
-				mpt_add_sge(psge, flagsLength, dma_addr_out);
-				psge += (sizeof(u32) + sizeof(dma_addr_t));
+				ioc->add_sge(psge, flagsLength, dma_addr_out);
+				psge += ioc->SGE_size;
 
 				/* Copy user data to kernel space.
 				 */
@@ -2175,13 +2176,13 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
 				/* Set up this SGE
 				 * Copy to MF and to sglbuf
 				 */
-				mpt_add_sge(psge, flagsLength, dma_addr_in);
+				ioc->add_sge(psge, flagsLength, dma_addr_in);
 			}
 		}
 	} else  {
 		/* Add a NULL SGE
 		 */
-		mpt_add_sge(psge, flagsLength, (dma_addr_t) -1);
+		ioc->add_sge(psge, flagsLength, (dma_addr_t) -1);
 	}
 
 	ioc->ioctl->wait_done = 0;
@@ -2498,7 +2499,7 @@ mptctl_hp_hostinfo(unsigned long arg, unsigned int data_size)
 	pbuf = pci_alloc_consistent(ioc->pcidev, 4, &buf_dma);
 	if (!pbuf)
 		goto out;
-	mpt_add_sge((char *)&IstwiRWRequest->SGL,
+	ioc->add_sge((char *)&IstwiRWRequest->SGL,
 	    (MPT_SGE_FLAGS_SSIMPLE_READ|4), buf_dma);
 
 	ioc->ioctl->wait_done = 0;
diff --git a/drivers/message/fusion/mptdebug.h b/drivers/message/fusion/mptdebug.h
index 510b9f4..28e4788 100644
--- a/drivers/message/fusion/mptdebug.h
+++ b/drivers/message/fusion/mptdebug.h
@@ -58,6 +58,7 @@
 #define MPT_DEBUG_FC			0x00080000
 #define MPT_DEBUG_SAS			0x00100000
 #define MPT_DEBUG_SAS_WIDE		0x00200000
+#define MPT_DEBUG_36GB_MEM              0x00400000
 
 /*
  * CONFIG_FUSION_LOGGING - enabled in Kconfig
@@ -135,6 +136,8 @@
 #define dsaswideprintk(IOC, CMD)		\
 	MPT_CHECK_LOGGING(IOC, CMD, MPT_DEBUG_SAS_WIDE)
 
+#define d36memprintk(IOC, CMD)		\
+	MPT_CHECK_LOGGING(IOC, CMD, MPT_DEBUG_36GB_MEM)
 
 
 /*
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index c3c24fd..da16b47 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -1251,17 +1251,15 @@ mptfc_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	 * A slightly different algorithm is required for
 	 * 64bit SGEs.
 	 */
-	scale = ioc->req_sz/(sizeof(dma_addr_t) + sizeof(u32));
-	if (sizeof(dma_addr_t) == sizeof(u64)) {
+	scale = ioc->req_sz/ioc->SGE_size;
+	if (ioc->sg_addr_size == sizeof(u64)) {
 		numSGE = (scale - 1) *
 		  (ioc->facts.MaxChainDepth-1) + scale +
-		  (ioc->req_sz - 60) / (sizeof(dma_addr_t) +
-		  sizeof(u32));
+		  (ioc->req_sz - 60) / ioc->SGE_size;
 	} else {
 		numSGE = 1 + (scale - 1) *
 		  (ioc->facts.MaxChainDepth-1) + scale +
-		  (ioc->req_sz - 64) / (sizeof(dma_addr_t) +
-		  sizeof(u32));
+		  (ioc->req_sz - 64) / ioc->SGE_size;
 	}
 
 	if (numSGE < sh->sg_tablesize) {
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index a9019f0..b162f7a 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1319,15 +1319,15 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	/* request */
 	flagsLength = (MPI_SGE_FLAGS_SIMPLE_ELEMENT |
 		       MPI_SGE_FLAGS_END_OF_BUFFER |
-		       MPI_SGE_FLAGS_DIRECTION |
-		       mpt_addr_size()) << MPI_SGE_FLAGS_SHIFT;
+		       MPI_SGE_FLAGS_DIRECTION)
+		       << MPI_SGE_FLAGS_SHIFT;
 	flagsLength |= (req->data_len - 4);
 
 	dma_addr_out = pci_map_single(ioc->pcidev, bio_data(req->bio),
 				      req->data_len, PCI_DMA_BIDIRECTIONAL);
 	if (!dma_addr_out)
 		goto put_mf;
-	mpt_add_sge(psge, flagsLength, dma_addr_out);
+	ioc->add_sge(psge, flagsLength, dma_addr_out);
 	psge += (sizeof(u32) + sizeof(dma_addr_t));
 
 	/* response */
@@ -1337,7 +1337,7 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 				      rsp->data_len, PCI_DMA_BIDIRECTIONAL);
 	if (!dma_addr_in)
 		goto unmap;
-	mpt_add_sge(psge, flagsLength, dma_addr_in);
+	ioc->add_sge(psge, flagsLength, dma_addr_in);
 
 	mpt_put_msg_frame(mptsasMgmtCtx, ioc, mf);
 
@@ -3211,17 +3211,15 @@ mptsas_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	 * A slightly different algorithm is required for
 	 * 64bit SGEs.
 	 */
-	scale = ioc->req_sz/(sizeof(dma_addr_t) + sizeof(u32));
-	if (sizeof(dma_addr_t) == sizeof(u64)) {
+	scale = ioc->req_sz/ioc->SGE_size;
+	if (ioc->sg_addr_size == sizeof(u64)) {
 		numSGE = (scale - 1) *
 		  (ioc->facts.MaxChainDepth-1) + scale +
-		  (ioc->req_sz - 60) / (sizeof(dma_addr_t) +
-		  sizeof(u32));
+		  (ioc->req_sz - 60) / ioc->SGE_size;
 	} else {
 		numSGE = 1 + (scale - 1) *
 		  (ioc->facts.MaxChainDepth-1) + scale +
-		  (ioc->req_sz - 64) / (sizeof(dma_addr_t) +
-		  sizeof(u32));
+		  (ioc->req_sz - 64) / ioc->SGE_size;
 	}
 
 	if (numSGE < sh->sg_tablesize) {
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index e62c6bc..a1ce079 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -113,69 +113,6 @@ int 		mptscsih_resume(struct pci_dev *pdev);
 
 #define SNS_LEN(scp)	SCSI_SENSE_BUFFERSIZE
 
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/**
- *	mptscsih_add_sge - Place a simple SGE at address pAddr.
- *	@pAddr: virtual address for SGE
- *	@flagslength: SGE flags and data transfer length
- *	@dma_addr: Physical address
- *
- *	This routine places a MPT request frame back on the MPT adapter's
- *	FreeQ.
- */
-static inline void
-mptscsih_add_sge(char *pAddr, u32 flagslength, dma_addr_t dma_addr)
-{
-	if (sizeof(dma_addr_t) == sizeof(u64)) {
-		SGESimple64_t *pSge = (SGESimple64_t *) pAddr;
-		u32 tmp = dma_addr & 0xFFFFFFFF;
-
-		pSge->FlagsLength = cpu_to_le32(flagslength);
-		pSge->Address.Low = cpu_to_le32(tmp);
-		tmp = (u32) ((u64)dma_addr >> 32);
-		pSge->Address.High = cpu_to_le32(tmp);
-
-	} else {
-		SGESimple32_t *pSge = (SGESimple32_t *) pAddr;
-		pSge->FlagsLength = cpu_to_le32(flagslength);
-		pSge->Address = cpu_to_le32(dma_addr);
-	}
-} /* mptscsih_add_sge() */
-
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/**
- *	mptscsih_add_chain - Place a chain SGE at address pAddr.
- *	@pAddr: virtual address for SGE
- *	@next: nextChainOffset value (u32's)
- *	@length: length of next SGL segment
- *	@dma_addr: Physical address
- *
- *	This routine places a MPT request frame back on the MPT adapter's
- *	FreeQ.
- */
-static inline void
-mptscsih_add_chain(char *pAddr, u8 next, u16 length, dma_addr_t dma_addr)
-{
-	if (sizeof(dma_addr_t) == sizeof(u64)) {
-		SGEChain64_t *pChain = (SGEChain64_t *) pAddr;
-		u32 tmp = dma_addr & 0xFFFFFFFF;
-
-		pChain->Length = cpu_to_le16(length);
-		pChain->Flags = MPI_SGE_FLAGS_CHAIN_ELEMENT | mpt_addr_size();
-
-		pChain->NextChainOffset = next;
-
-		pChain->Address.Low = cpu_to_le32(tmp);
-		tmp = (u32) ((u64)dma_addr >> 32);
-		pChain->Address.High = cpu_to_le32(tmp);
-	} else {
-		SGEChain32_t *pChain = (SGEChain32_t *) pAddr;
-		pChain->Length = cpu_to_le16(length);
-		pChain->Flags = MPI_SGE_FLAGS_CHAIN_ELEMENT | mpt_addr_size();
-		pChain->NextChainOffset = next;
-		pChain->Address = cpu_to_le32(dma_addr);
-	}
-} /* mptscsih_add_chain() */
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
@@ -281,10 +218,10 @@ mptscsih_AddSGE(MPT_ADAPTER *ioc, struct scsi_cmnd *SCpnt,
 	 */
 
 nextSGEset:
-	numSgeSlots = ((frm_sz - sgeOffset) / (sizeof(u32) + sizeof(dma_addr_t)) );
+	numSgeSlots = ((frm_sz - sgeOffset) / ioc->SGE_size);
 	numSgeThisFrame = (sges_left < numSgeSlots) ? sges_left : numSgeSlots;
 
-	sgflags = MPT_SGE_FLAGS_SIMPLE_ELEMENT | MPT_SGE_FLAGS_ADDRESSING | sgdir;
+	sgflags = MPT_SGE_FLAGS_SIMPLE_ELEMENT | sgdir;
 
 	/* Get first (num - 1) SG elements
 	 * Skip any SG entries with a length of 0
@@ -299,11 +236,11 @@ nextSGEset:
 		}
 
 		v2 = sg_dma_address(sg);
-		mptscsih_add_sge(psge, sgflags | thisxfer, v2);
+		ioc->add_sge(psge, sgflags | thisxfer, v2);
 
 		sg = sg_next(sg);	/* Get next SG element from the OS */
-		psge += (sizeof(u32) + sizeof(dma_addr_t));
-		sgeOffset += (sizeof(u32) + sizeof(dma_addr_t));
+		psge += ioc->SGE_size;
+		sgeOffset += ioc->SGE_size;
 		sg_done++;
 	}
 
@@ -320,12 +257,8 @@ nextSGEset:
 		thisxfer = sg_dma_len(sg);
 
 		v2 = sg_dma_address(sg);
-		mptscsih_add_sge(psge, sgflags | thisxfer, v2);
-		/*
-		sg = sg_next(sg);
-		psge += (sizeof(u32) + sizeof(dma_addr_t));
-		*/
-		sgeOffset += (sizeof(u32) + sizeof(dma_addr_t));
+		ioc->add_sge(psge, sgflags | thisxfer, v2);
+		sgeOffset += ioc->SGE_size;
 		sg_done++;
 
 		if (chainSge) {
@@ -334,7 +267,8 @@ nextSGEset:
 			 * Update the chain element
 			 * Offset and Length fields.
 			 */
-			mptscsih_add_chain((char *)chainSge, 0, sgeOffset, ioc->ChainBufferDMA + chain_dma_off);
+			ioc->add_chain((char *)chainSge, 0, sgeOffset,
+				ioc->ChainBufferDMA + chain_dma_off);
 		} else {
 			/* The current buffer is the original MF
 			 * and there is no Chain buffer.
@@ -367,7 +301,7 @@ nextSGEset:
 		 * set properly).
 		 */
 		if (sg_done) {
-			u32 *ptmp = (u32 *) (psge - (sizeof(u32) + sizeof(dma_addr_t)));
+			u32 *ptmp = (u32 *) (psge - ioc->SGE_size);
 			sgflags = le32_to_cpu(*ptmp);
 			sgflags |= MPT_SGE_FLAGS_LAST_ELEMENT;
 			*ptmp = cpu_to_le32(sgflags);
@@ -381,8 +315,9 @@ nextSGEset:
 			 * Old chain element is now complete.
 			 */
 			u8 nextChain = (u8) (sgeOffset >> 2);
-			sgeOffset += (sizeof(u32) + sizeof(dma_addr_t));
-			mptscsih_add_chain((char *)chainSge, nextChain, sgeOffset, ioc->ChainBufferDMA + chain_dma_off);
+			sgeOffset += ioc->SGE_size;
+			ioc->add_chain((char *)chainSge, nextChain, sgeOffset,
+					 ioc->ChainBufferDMA + chain_dma_off);
 		} else {
 			/* The original MF buffer requires a chain buffer -
 			 * set the offset.
@@ -1448,7 +1383,8 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 	 */
 	if (datalen == 0) {
 		/* Add a NULL SGE */
-		mptscsih_add_sge((char *)&pScsiReq->SGL, MPT_SGE_FLAGS_SSIMPLE_READ | 0,
+		ioc->add_sge((char *)&pScsiReq->SGL,
+			MPT_SGE_FLAGS_SSIMPLE_READ | 0,
 			(dma_addr_t) -1);
 	} else {
 		/* Add a 32 or 64 bit SGE */
@@ -3199,11 +3135,11 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *io)
 			ioc->name, cmd, io->channel, io->id, io->lun));
 
 	if (dir == MPI_SCSIIO_CONTROL_READ) {
-		mpt_add_sge((char *) &pScsiReq->SGL,
+		ioc->add_sge((char *) &pScsiReq->SGL,
 			MPT_SGE_FLAGS_SSIMPLE_READ | io->size,
 			io->data_dma);
 	} else {
-		mpt_add_sge((char *) &pScsiReq->SGL,
+		ioc->add_sge((char *) &pScsiReq->SGL,
 			MPT_SGE_FLAGS_SSIMPLE_WRITE | io->size,
 			io->data_dma);
 	}
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 6162014..643a3c6 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -300,7 +300,7 @@ mptspi_writeIOCPage4(MPT_SCSI_HOST *hd, u8 channel , u8 id)
 	flagsLength = MPT_SGE_FLAGS_SSIMPLE_WRITE |
 		(IOCPage4Ptr->Header.PageLength + ii) * 4;
 
-	mpt_add_sge((char *)&pReq->PageBufferSGE, flagsLength, dataDma);
+	ioc->add_sge((char *)&pReq->PageBufferSGE, flagsLength, dataDma);
 
 	ddvprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		"writeIOCPage4: MaxSEP=%d ActiveSEP=%d id=%d bus=%d\n",
@@ -643,7 +643,7 @@ mptscsih_quiesce_raid(MPT_SCSI_HOST *hd, int quiesce, u8 channel, u8 id)
 	pReq->Reserved2 = 0;
 	pReq->ActionDataWord = 0; /* Reserved for this action */
 
-	mpt_add_sge((char *)&pReq->ActionDataSGE,
+	ioc->add_sge((char *)&pReq->ActionDataSGE,
 		MPT_SGE_FLAGS_SSIMPLE_READ | 0, (dma_addr_t) -1);
 
 	ddvprintk(ioc, printk(MYIOC_s_DEBUG_FMT "RAID Volume action=%x channel=%d id=%d\n",
@@ -1423,17 +1423,15 @@ mptspi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	 * A slightly different algorithm is required for
 	 * 64bit SGEs.
 	 */
-	scale = ioc->req_sz/(sizeof(dma_addr_t) + sizeof(u32));
-	if (sizeof(dma_addr_t) == sizeof(u64)) {
+	scale = ioc->req_sz/ioc->SGE_size;
+	if (ioc->sg_addr_size == sizeof(u64)) {
 		numSGE = (scale - 1) *
 		  (ioc->facts.MaxChainDepth-1) + scale +
-		  (ioc->req_sz - 60) / (sizeof(dma_addr_t) +
-		  sizeof(u32));
+		  (ioc->req_sz - 60) / ioc->SGE_size;
 	} else {
 		numSGE = 1 + (scale - 1) *
 		  (ioc->facts.MaxChainDepth-1) + scale +
-		  (ioc->req_sz - 64) / (sizeof(dma_addr_t) +
-		  sizeof(u32));
+		  (ioc->req_sz - 64) / ioc->SGE_size;
 	}
 
 	if (numSGE < sh->sg_tablesize) {
