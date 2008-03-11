From: "Prakash, Sathya" <sathya.prakash@lsi.com>
Subject: [PATCH] mpt fusion: Fix for 1078 Data corruption issue for 36GB memory region
Date: Tue, 11 Mar 2008 14:14:33 +0530
Message-ID: <20080311084433.GA26757@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:42976 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbYCKIu3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Mar 2008 04:50:29 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id m2B8lIND020323
	for <linux-scsi@vger.kernel.org>; Tue, 11 Mar 2008 01:47:18 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: eric.moore@lsi.com

The reason for this change is there is a data corruption when four
different physical memory regions in the 36GB to 37GB region are accessed.
This is only affecting 1078.

The solution is we need to use different addressing when filling in the
scatter gather table for the effected memory regions.  So instead of
snooping on all four different memory holes, we treat any
physical addresses in the 36GB address with the same algorithm.

The fix is explained below
1) Ensure that the message frames are NOT located in the trouble
region. There is no remapping available for message frames, they
must be allocated outside the problem region.
2) Ensure that Sense buffers are NOT in the trouble region. There is
no remapping available.
3) Walk through the SGE entries and if any are inside the trouble
region then they need to be remapped as discussed below.
	1) Set the Local Address bit in the SGE Flags field.
	MPI_SGE_FLAGS_LOCAL_ADDRESS
	2) Ensure we are using 64-bit SGEs
	3) Set MSb (Bit 63) of the 64-bit address, this will indicate buffer
	location is Host Memory.

Signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
---

diff -Naurp b/drivers/message/fusion/mptbase.c a/drivers/message/fusion/mptbase.c
--- b/drivers/message/fusion/mptbase.c	2008-03-05 15:54:50.000000000 +0530
+++ a/drivers/message/fusion/mptbase.c	2008-03-10 04:35:57.000000000 +0530
@@ -925,33 +925,75 @@ mpt_free_msg_frame(MPT_ADAPTER *ioc, MPT
 	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
 }
 
+
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
- *	mpt_add_sge - Place a simple SGE at address pAddr.
- *	@pAddr: virtual address for SGE
+ *	mpt_add_sge - Place a simple 32 bit SGE at address addr.
+ *	@addr: virtual address for SGE
  *	@flagslength: SGE flags and data transfer length
  *	@dma_addr: Physical address
- *
- *	This routine places a MPT request frame back on the MPT adapter's
- *	FreeQ.
  */
-void
-mpt_add_sge(char *pAddr, u32 flagslength, dma_addr_t dma_addr)
+static void
+mpt_add_sge(char *addr, u32 flagslength, dma_addr_t dma_addr)
 {
-	if (sizeof(dma_addr_t) == sizeof(u64)) {
-		SGESimple64_t *pSge = (SGESimple64_t *) pAddr;
-		u32 tmp = dma_addr & 0xFFFFFFFF;
+	SGESimple32_t *pSge = (SGESimple32_t *) addr;
+	pSge->FlagsLength = cpu_to_le32(flagslength);
+	pSge->Address = cpu_to_le32(dma_addr);
+}
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/**
+ *	mpt_add_sge_64bit - Place a simple 64 bit SGE at address addr.
+ *	@addr: virtual address for SGE
+ *	@flagslength: SGE flags and data transfer length
+ *	@dma_addr: Physical address
+ */
+static void
+mpt_add_sge_64bit(char *addr, u32 flagslength, dma_addr_t dma_addr)
+{
+	SGESimple64_t *pSge = (SGESimple64_t *) addr;
+	u32 tmp = dma_addr & 0xFFFFFFFF;
 
-		pSge->FlagsLength = cpu_to_le32(flagslength);
-		pSge->Address.Low = cpu_to_le32(tmp);
-		tmp = (u32) ((u64)dma_addr >> 32);
-		pSge->Address.High = cpu_to_le32(tmp);
+	pSge->FlagsLength = cpu_to_le32(flagslength);
+	pSge->Address.Low = cpu_to_le32(tmp);
+	tmp = (u32) ((u64)dma_addr >> 32);
+	pSge->Address.High = cpu_to_le32(tmp);
+}
 
-	} else {
-		SGESimple32_t *pSge = (SGESimple32_t *) pAddr;
-		pSge->FlagsLength = cpu_to_le32(flagslength);
-		pSge->Address = cpu_to_le32(dma_addr);
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/**
+ *	mpt_add_sge_64bit_1078 - Place a simple 64 bit SGE at address addr
+ *	(1078 workaround).
+ *	@addr: virtual address for SGE
+ *	@flagslength: SGE flags and data transfer length
+ *	@dma_addr: Physical address
+ */
+static void
+mpt_add_sge_64bit_1078(char *addr, u32 flagslength, dma_addr_t dma_addr)
+{
+	SGESimple64_t *pSge = (SGESimple64_t *) addr;
+	u32 tmp;
+
+	tmp = dma_addr & 0xFFFFFFFF;
+	pSge->Address.Low = cpu_to_le32(tmp);
+	tmp = (u32) ((u64)dma_addr >> 32);
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
 	}
+
+	pSge->FlagsLength = cpu_to_le32(flagslength);
+	pSge->Address.High = cpu_to_le32(tmp);
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -1154,7 +1196,7 @@ mpt_host_page_alloc(MPT_ADAPTER *ioc, pI
 	}
 	flags_length = flags_length << MPI_SGE_FLAGS_SHIFT;
 	flags_length |= ioc->HostPageBuffer_sz;
-	mpt_add_sge(psge, flags_length, ioc->HostPageBuffer_dma);
+	ioc->add_sge(psge, flags_length, ioc->HostPageBuffer_dma);
 	ioc->facts.HostPageBufferSGE = ioc_init->HostPageBufferSGE;
 
 return 0;
@@ -1496,28 +1538,41 @@ mpt_attach(struct pci_dev *pdev, const s
 
 	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT ": mpt_adapter_install\n", ioc->name));
 
-	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
-		dprintk(ioc, printk(MYIOC_s_INFO_FMT
-			": 64 BIT PCI BUS DMA ADDRESSING SUPPORTED\n", ioc->name));
-	} else if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
-		printk(MYIOC_s_WARN_FMT ": 32 BIT PCI BUS DMA ADDRESSING NOT SUPPORTED\n",
-		    ioc->name);
+	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)
+	    && !pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK)) {
+		ioc->dma_mask = DMA_64BIT_MASK;
+		dinitprintk(ioc, printk(MYIOC_s_INFO_FMT
+		    ": 64 BIT PCI BUS DMA ADDRESSING SUPPORTED\n",
+		    ioc->name));
+	} else if (!pci_set_dma_mask(pdev, DMA_32BIT_MASK)
+	    && !pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK)) {
+		ioc->dma_mask = DMA_32BIT_MASK;
+		dinitprintk(ioc, printk(MYIOC_s_INFO_FMT
+		    ": 32 BIT PCI BUS DMA ADDRESSING SUPPORTED\n",
+		    ioc->name));
+	} else {
+		printk(MYIOC_s_WARN_FMT "no suitable DMA mask for %s\n",
+		    ioc->name, pci_name(pdev));
 		kfree(ioc);
 		return r;
 	}
 
-	if (!pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK)) {
-		dprintk(ioc, printk(MYIOC_s_INFO_FMT
-			": Using 64 bit consistent mask\n", ioc->name));
-	} else {
-		dprintk(ioc, printk(MYIOC_s_INFO_FMT
-			": Not using 64 bit consistent mask\n", ioc->name));
-	}
 
 	ioc->alloc_total = sizeof(MPT_ADAPTER);
 	ioc->req_sz = MPT_DEFAULT_FRAME_SIZE;		/* avoid div by zero! */
 	ioc->reply_sz = MPT_REPLY_FRAME_SIZE;
 
+	/*
+	 * Setting up proper handlers for scatter gather handling
+	 */
+	if (sizeof(dma_addr_t) == sizeof(u64)) {
+		if (pdev->device == MPI_MANUFACTPAGE_DEVID_SAS1078)
+			ioc->add_sge = &mpt_add_sge_64bit_1078;
+		else
+			ioc->add_sge = &mpt_add_sge_64bit;
+	} else
+		ioc->add_sge = &mpt_add_sge;
+
 	ioc->pcidev = pdev;
 	ioc->diagPending = 0;
 	spin_lock_init(&ioc->diagLock);
@@ -3201,7 +3256,7 @@ mpt_do_upload(MPT_ADAPTER *ioc, int slee
 	sgeoffset = sizeof(FWUpload_t) - sizeof(SGE_MPI_UNION) + sizeof(FWUploadTCSGE_t);
 
 	flagsLength = MPT_SGE_FLAGS_SSIMPLE_READ | sz;
-	mpt_add_sge((char *)ptcsge, flagsLength, ioc->cached_fw_dma);
+	ioc->add_sge((char *)ptcsge, flagsLength, ioc->cached_fw_dma);
 
 	sgeoffset += sizeof(u32) + sizeof(dma_addr_t);
 	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT ": Sending FW Upload (req @ %p) sgeoffset=%d \n",
@@ -3995,12 +4050,33 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 	dma_addr_t alloc_dma;
 	u8 *mem;
 	int i, reply_sz, sz, total_size, num_chain;
+	u64	dma_mask = 0;
 
 	/*  Prime reply FIFO...  */
 
 	if (ioc->reply_frames == NULL) {
 		if ( (num_chain = initChainBuffers(ioc)) < 0)
 			return -1;
+		/*
+		 * 1078 errata workaround for the 36GB limitation
+		 */
+		if (ioc->pcidev->device == MPI_MANUFACTPAGE_DEVID_SAS1078 &&
+		    ioc->dma_mask > MPT_DMA_35BIT_MASK) {
+			if (!pci_set_dma_mask(ioc->pcidev, DMA_32BIT_MASK)
+			    && !pci_set_consistent_dma_mask(ioc->pcidev,
+			    DMA_32BIT_MASK)) {
+				dma_mask = MPT_DMA_35BIT_MASK;
+				d36memprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+				    "setting 35 bit addressing for "
+				    "Request/Reply/Chain and Sense Buffers\n",
+				    ioc->name));
+			} else {
+				d36memprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+				    "failed setting 35 bit addressing for "
+				    "Request/Reply/Chain and Sense Buffers\n",
+				    ioc->name));
+			}
+		}
 
 		total_size = reply_sz = (ioc->reply_sz * ioc->reply_depth);
 		dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "ReplyBuffer sz=%d bytes, ReplyDepth=%d\n",
@@ -4139,6 +4215,12 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 		alloc_dma += ioc->reply_sz;
 	}
 
+	if (dma_mask == MPT_DMA_35BIT_MASK && !pci_set_dma_mask(ioc->pcidev,
+	    DMA_64BIT_MASK) && !pci_set_consistent_dma_mask(ioc->pcidev,
+	    DMA_64BIT_MASK))
+		d36memprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "restoring 64 bit addressing\n", ioc->name));
+
 	return 0;
 
 out_fail:
@@ -4158,6 +4240,13 @@ out_fail:
 				ioc->sense_buf_pool, ioc->sense_buf_pool_dma);
 		ioc->sense_buf_pool = NULL;
 	}
+
+	if (dma_mask == MPT_DMA_35BIT_MASK && !pci_set_dma_mask(ioc->pcidev,
+	    DMA_64BIT_MASK) && !pci_set_consistent_dma_mask(ioc->pcidev,
+	    DMA_64BIT_MASK))
+		d36memprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "restoring 64 bit addressing\n", ioc->name));
+
 	return -1;
 }
 
@@ -5761,7 +5850,7 @@ mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS
 			ioc->name, pReq->Header.PageType, pReq->Header.PageNumber, pReq->Action));
 	}
 
-	mpt_add_sge((char *)&pReq->PageBufferSGE, flagsLength, pCfg->physAddr);
+	ioc->add_sge((char *)&pReq->PageBufferSGE, flagsLength, pCfg->physAddr);
 
 	/* Append pCfg pointer to end of mf
 	 */
@@ -7421,7 +7510,6 @@ EXPORT_SYMBOL(mpt_get_msg_frame);
 EXPORT_SYMBOL(mpt_put_msg_frame);
 EXPORT_SYMBOL(mpt_put_msg_frame_hi_pri);
 EXPORT_SYMBOL(mpt_free_msg_frame);
-EXPORT_SYMBOL(mpt_add_sge);
 EXPORT_SYMBOL(mpt_send_handshake_request);
 EXPORT_SYMBOL(mpt_verify_adapter);
 EXPORT_SYMBOL(mpt_GetIocState);
diff -Naurp b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2008-03-04 14:41:54.000000000 +0530
+++ a/drivers/message/fusion/mptbase.h	2008-03-10 03:51:59.000000000 +0530
@@ -133,6 +133,8 @@
 
 #define MPT_COALESCING_TIMEOUT		0x10
 
+#define MPT_DMA_35BIT_MASK		0x00000007ffffffffULL
+
 /*
  * SCSI transfer rate defines.
  */
@@ -561,6 +563,8 @@ struct mptfc_rport_info
 	u8		flags;
 };
 
+typedef void (*MPT_ADD_SGE)(char *addr, u32 flagslength, dma_addr_t dma_addr);
+
 /*
  *  Adapter Structure - pci_dev specific. Maximum: MPT_MAX_ADAPTERS
  */
@@ -597,6 +601,8 @@ typedef struct _MPT_ADAPTER
 	int			 reply_depth;	/* Num Allocated reply frames */
 	int			 reply_sz;	/* Reply frame size */
 	int			 num_chain;	/* Number of chain buffers */
+	MPT_ADD_SGE		 add_sge;
+	u64			 dma_mask;
 		/* Pool of buffers for chaining. ReqToChain
 		 * and ChainToChain track index of chain buffers.
 		 * ChainBuffer (DMA) virt/phys addresses.
@@ -900,8 +906,6 @@ extern MPT_FRAME_HDR	*mpt_get_msg_frame(
 extern void	 mpt_free_msg_frame(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf);
 extern void	 mpt_put_msg_frame(u8 cb_idx, MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf);
 extern void	 mpt_put_msg_frame_hi_pri(u8 cb_idx, MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf);
-extern void	 mpt_add_sge(char *pAddr, u32 flagslength, dma_addr_t dma_addr);
-
 extern int	 mpt_send_handshake_request(u8 cb_idx, MPT_ADAPTER *ioc, int reqBytes, u32 *req, int sleepFlag);
 extern int	 mpt_verify_adapter(int iocid, MPT_ADAPTER **iocpp);
 extern u32	 mpt_GetIocState(MPT_ADAPTER *ioc, int cooked);
diff -Naurp b/drivers/message/fusion/mptctl.c a/drivers/message/fusion/mptctl.c
--- b/drivers/message/fusion/mptctl.c	2008-03-04 14:41:54.000000000 +0530
+++ a/drivers/message/fusion/mptctl.c	2008-03-10 03:51:59.000000000 +0530
@@ -871,7 +871,7 @@ mptctl_do_fw_download(int ioc, char __us
 		if (nib == 0 || nib == 3) {
 			;
 		} else if (sgIn->Address) {
-			mpt_add_sge(sgOut, sgIn->FlagsLength, sgIn->Address);
+			iocp->add_sge(sgOut, sgIn->FlagsLength, sgIn->Address);
 			n++;
 			if (copy_from_user(bl->kptr, ufwbuf+fw_bytes_copied, bl->len)) {
 				printk(MYIOC_s_ERR_FMT "%s@%d::_ioctl_fwdl - "
@@ -2142,7 +2142,7 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 				/* Set up this SGE.
 				 * Copy to MF and to sglbuf
 				 */
-				mpt_add_sge(psge, flagsLength, dma_addr_out);
+				ioc->add_sge(psge, flagsLength, dma_addr_out);
 				psge += (sizeof(u32) + sizeof(dma_addr_t));
 
 				/* Copy user data to kernel space.
@@ -2176,13 +2176,13 @@ mptctl_do_mpt_command (struct mpt_ioctl_
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
@@ -2499,7 +2499,7 @@ mptctl_hp_hostinfo(unsigned long arg, un
 	pbuf = pci_alloc_consistent(ioc->pcidev, 4, &buf_dma);
 	if (!pbuf)
 		goto out;
-	mpt_add_sge((char *)&IstwiRWRequest->SGL,
+	ioc->add_sge((char *)&IstwiRWRequest->SGL,
 	    (MPT_SGE_FLAGS_SSIMPLE_READ|4), buf_dma);
 
 	ioc->ioctl->wait_done = 0;
diff -Naurp b/drivers/message/fusion/mptdebug.h a/drivers/message/fusion/mptdebug.h
--- b/drivers/message/fusion/mptdebug.h	2008-03-04 14:41:54.000000000 +0530
+++ a/drivers/message/fusion/mptdebug.h	2008-03-10 03:51:59.000000000 +0530
@@ -58,6 +58,7 @@
 #define MPT_DEBUG_FC			0x00080000
 #define MPT_DEBUG_SAS			0x00100000
 #define MPT_DEBUG_SAS_WIDE		0x00200000
+#define MPT_DEBUG_36GB_MEM		0x00400000
 
 /*
  * CONFIG_FUSION_LOGGING - enabled in Kconfig
@@ -135,6 +136,8 @@
 #define dsaswideprintk(IOC, CMD)		\
 	MPT_CHECK_LOGGING(IOC, CMD, MPT_DEBUG_SAS_WIDE)
 
+#define d36memprintk(IOC, CMD)		\
+	MPT_CHECK_LOGGING(IOC, CMD, MPT_DEBUG_36GB_MEM)
 
 
 /*
diff -Naurp b/drivers/message/fusion/mptsas.c a/drivers/message/fusion/mptsas.c
--- b/drivers/message/fusion/mptsas.c	2008-03-06 19:04:18.000000000 +0530
+++ a/drivers/message/fusion/mptsas.c	2008-03-10 03:51:59.000000000 +0530
@@ -1313,7 +1313,7 @@ static int mptsas_smp_handler(struct Scs
 				      req->data_len, PCI_DMA_BIDIRECTIONAL);
 	if (!dma_addr_out)
 		goto put_mf;
-	mpt_add_sge(psge, flagsLength, dma_addr_out);
+	ioc->add_sge(psge, flagsLength, dma_addr_out);
 	psge += (sizeof(u32) + sizeof(dma_addr_t));
 
 	/* response */
@@ -1323,7 +1323,7 @@ static int mptsas_smp_handler(struct Scs
 				      rsp->data_len, PCI_DMA_BIDIRECTIONAL);
 	if (!dma_addr_in)
 		goto unmap;
-	mpt_add_sge(psge, flagsLength, dma_addr_in);
+	ioc->add_sge(psge, flagsLength, dma_addr_in);
 
 	mpt_put_msg_frame(mptsasMgmtCtx, ioc, mf);
 
diff -Naurp b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2008-03-04 14:41:54.000000000 +0530
+++ a/drivers/message/fusion/mptscsih.c	2008-03-10 03:51:59.000000000 +0530
@@ -115,35 +115,6 @@ int 		mptscsih_resume(struct pci_dev *pd
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
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
  *	mptscsih_add_chain - Place a chain SGE at address pAddr.
  *	@pAddr: virtual address for SGE
  *	@next: nextChainOffset value (u32's)
@@ -299,7 +270,7 @@ nextSGEset:
 		}
 
 		v2 = sg_dma_address(sg);
-		mptscsih_add_sge(psge, sgflags | thisxfer, v2);
+		ioc->add_sge(psge, sgflags | thisxfer, v2);
 
 		sg = sg_next(sg);	/* Get next SG element from the OS */
 		psge += (sizeof(u32) + sizeof(dma_addr_t));
@@ -320,7 +291,7 @@ nextSGEset:
 		thisxfer = sg_dma_len(sg);
 
 		v2 = sg_dma_address(sg);
-		mptscsih_add_sge(psge, sgflags | thisxfer, v2);
+		ioc->add_sge(psge, sgflags | thisxfer, v2);
 		/*
 		sg = sg_next(sg);
 		psge += (sizeof(u32) + sizeof(dma_addr_t));
@@ -1439,8 +1410,8 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, v
 	 */
 	if (datalen == 0) {
 		/* Add a NULL SGE */
-		mptscsih_add_sge((char *)&pScsiReq->SGL, MPT_SGE_FLAGS_SSIMPLE_READ | 0,
-			(dma_addr_t) -1);
+		ioc->add_sge((char *)&pScsiReq->SGL,
+			MPT_SGE_FLAGS_SSIMPLE_READ | 0, (dma_addr_t) -1);
 	} else {
 		/* Add a 32 or 64 bit SGE */
 		if (mptscsih_AddSGE(ioc, SCpnt, pScsiReq, my_idx) != SUCCESS)
@@ -3193,11 +3164,11 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTER
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
diff -Naurp b/drivers/message/fusion/mptspi.c a/drivers/message/fusion/mptspi.c
--- b/drivers/message/fusion/mptspi.c	2008-03-04 14:41:54.000000000 +0530
+++ a/drivers/message/fusion/mptspi.c	2008-03-10 03:51:59.000000000 +0530
@@ -300,7 +300,7 @@ mptspi_writeIOCPage4(MPT_SCSI_HOST *hd, 
 	flagsLength = MPT_SGE_FLAGS_SSIMPLE_WRITE |
 		(IOCPage4Ptr->Header.PageLength + ii) * 4;
 
-	mpt_add_sge((char *)&pReq->PageBufferSGE, flagsLength, dataDma);
+	ioc->add_sge((char *)&pReq->PageBufferSGE, flagsLength, dataDma);
 
 	ddvprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		"writeIOCPage4: MaxSEP=%d ActiveSEP=%d id=%d bus=%d\n",
@@ -642,7 +642,7 @@ mptscsih_quiesce_raid(MPT_SCSI_HOST *hd,
 	pReq->Reserved2 = 0;
 	pReq->ActionDataWord = 0; /* Reserved for this action */
 
-	mpt_add_sge((char *)&pReq->ActionDataSGE,
+	ioc->add_sge((char *)&pReq->ActionDataSGE,
 		MPT_SGE_FLAGS_SSIMPLE_READ | 0, (dma_addr_t) -1);
 
 	ddvprintk(ioc, printk(MYIOC_s_DEBUG_FMT "RAID Volume action=%x channel=%d id=%d\n",
