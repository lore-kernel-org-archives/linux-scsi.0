From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 2/6] mpt fusion: Fixing sparse warnings
Date: Sat, 29 Sep 2007 10:16:28 -0600
Message-ID: <20070929161628.GA4361@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:41985 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756036AbXI2QQZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Sep 2007 12:16:25 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

List below is output from C=2 sparse compilation, which are fixed with this patch.

1) mptspi: pg0 is defined in x86 version of include/asm/pgtable.h
2) mptsas: context imbalance in 'mptsas_probe' different lock contexts for basic block
3) mptbase: from mpt_attach - cast adds address space to expression
4) mptbase: from mpt_do_upload - request[] is bad constant expression

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>

diff -uarpN b/drivers/message/fusion/mptbase.c a/drivers/message/fusion/mptbase.c
--- b/drivers/message/fusion/mptbase.c	2007-09-17 10:41:08.000000000 -0600
+++ a/drivers/message/fusion/mptbase.c	2007-09-17 15:39:28.000000000 -0600
@@ -1452,6 +1452,7 @@ mpt_attach(struct pci_dev *pdev, const s
 {
 	MPT_ADAPTER	*ioc;
 	u8		__iomem *mem;
+	u8		__iomem *pmem;
 	unsigned long	 mem_phys;
 	unsigned long	 port;
 	u32		 msize;
@@ -1576,11 +1577,9 @@ mpt_attach(struct pci_dev *pdev, const s
 	ioc->chip = (SYSIF_REGS __iomem *)mem;
 
 	/* Save Port IO values in case we need to do downloadboot */
-	{
-		u8 *pmem = (u8*)port;
-		ioc->pio_mem_phys = port;
-		ioc->pio_chip = (SYSIF_REGS __iomem *)pmem;
-	}
+	ioc->pio_mem_phys = port;
+	pmem = (u8 __iomem *)port;
+	ioc->pio_chip = (SYSIF_REGS __iomem *)pmem;
 
 	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &revision);
 	mpt_get_product_name(pdev->vendor, pdev->device, revision, ioc->prod_name);
@@ -3103,7 +3102,6 @@ mpt_free_fw_memory(MPT_ADAPTER *ioc)
 static int
 mpt_do_upload(MPT_ADAPTER *ioc, int sleepFlag)
 {
-	u8			 request[ioc->req_sz];
 	u8			 reply[sizeof(FWUploadReply_t)];
 	FWUpload_t		*prequest;
 	FWUploadReply_t		*preply;
@@ -3129,11 +3127,16 @@ mpt_do_upload(MPT_ADAPTER *ioc, int slee
 		return -ENOMEM;
 	}
 
-	prequest = (FWUpload_t *)&request;
-	preply = (FWUploadReply_t *)&reply;
+	prequest = (sleepFlag == NO_SLEEP) ? kzalloc(ioc->req_sz, GFP_ATOMIC) :
+	    kzalloc(ioc->req_sz, GFP_KERNEL);
+	if (!prequest) {
+		dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "fw upload failed "
+		    "while allocating memory \n", ioc->name));
+		mpt_free_fw_memory(ioc);
+		return -ENOMEM;
+	}
 
-	/*  Destination...  */
-	memset(prequest, 0, ioc->req_sz);
+	preply = (FWUploadReply_t *)&reply;
 
 	reply_sz = sizeof(reply);
 	memset(preply, 0, reply_sz);
@@ -3145,11 +3148,12 @@ mpt_do_upload(MPT_ADAPTER *ioc, int slee
 	ptcsge->DetailsLength = 12;
 	ptcsge->Flags = MPI_SGE_FLAGS_TRANSACTION_ELEMENT;
 	ptcsge->ImageSize = cpu_to_le32(sz);
+	ptcsge++;
 
 	sgeoffset = sizeof(FWUpload_t) - sizeof(SGE_MPI_UNION) + sizeof(FWUploadTCSGE_t);
 
 	flagsLength = MPT_SGE_FLAGS_SSIMPLE_READ | sz;
-	mpt_add_sge(&request[sgeoffset], flagsLength, ioc->cached_fw_dma);
+	mpt_add_sge((char *)ptcsge, flagsLength, ioc->cached_fw_dma);
 
 	sgeoffset += sizeof(u32) + sizeof(dma_addr_t);
 	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT ": Sending FW Upload (req @ %p) sgeoffset=%d \n",
@@ -3184,6 +3188,7 @@ mpt_do_upload(MPT_ADAPTER *ioc, int slee
 			ioc->name));
 		mpt_free_fw_memory(ioc);
 	}
+	kfree(prequest);
 
 	return cmdStatus;
 }
diff -uarpN b/drivers/message/fusion/mptsas.c a/drivers/message/fusion/mptsas.c
--- b/drivers/message/fusion/mptsas.c	2007-09-17 11:56:56.000000000 -0600
+++ a/drivers/message/fusion/mptsas.c	2007-09-17 15:14:35.000000000 -0600
@@ -3224,6 +3224,7 @@ mptsas_probe(struct pci_dev *pdev, const
 	hd->ScsiLookup = kcalloc(ioc->req_depth, sizeof(void *), GFP_ATOMIC);
 	if (!hd->ScsiLookup) {
 		error = -ENOMEM;
+		spin_unlock_irqrestore(&ioc->FreeQlock, flags);
 		goto out_mptsas_probe;
 	}
 
diff -uarpN b/drivers/message/fusion/mptspi.c a/drivers/message/fusion/mptspi.c
--- b/drivers/message/fusion/mptspi.c	2007-09-17 11:59:07.000000000 -0600
+++ a/drivers/message/fusion/mptspi.c	2007-09-17 15:17:26.000000000 -0600
@@ -516,8 +516,8 @@ static int mptspi_read_spi_device_pg0(st
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
 	struct _MPT_SCSI_HOST *hd = shost_priv(shost);
 	struct _MPT_ADAPTER *ioc = hd->ioc;
-	struct _CONFIG_PAGE_SCSI_DEVICE_0 *pg0;
-	dma_addr_t pg0_dma;
+	struct _CONFIG_PAGE_SCSI_DEVICE_0 *spi_dev_pg0;
+	dma_addr_t spi_dev_pg0_dma;
 	int size;
 	struct _x_config_parms cfg;
 	struct _CONFIG_PAGE_HEADER hdr;
@@ -535,8 +535,8 @@ static int mptspi_read_spi_device_pg0(st
 	size += 2048;
 	*/
 
-	pg0 = dma_alloc_coherent(&ioc->pcidev->dev, size, &pg0_dma, GFP_KERNEL);
-	if (pg0 == NULL) {
+	spi_dev_pg0 = dma_alloc_coherent(&ioc->pcidev->dev, size, &spi_dev_pg0_dma, GFP_KERNEL);
+	if (spi_dev_pg0 == NULL) {
 		starget_printk(MYIOC_s_ERR_FMT, starget,
 		    "dma_alloc_coherent for parameters failed\n", ioc->name);
 		return -EINVAL;
@@ -552,7 +552,7 @@ static int mptspi_read_spi_device_pg0(st
 	memset(&cfg, 0, sizeof(cfg));
 
 	cfg.cfghdr.hdr = &hdr;
-	cfg.physAddr = pg0_dma;
+	cfg.physAddr = spi_dev_pg0_dma;
 	cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
 	cfg.dir = 0;
 	cfg.pageAddr = starget->id;
@@ -562,12 +562,12 @@ static int mptspi_read_spi_device_pg0(st
 		goto out_free;
 	}
 	err = 0;
-	memcpy(pass_pg0, pg0, size);
+	memcpy(pass_pg0, spi_dev_pg0, size);
 
-	mptspi_print_read_nego(hd, starget, le32_to_cpu(pg0->NegotiatedParameters));
+	mptspi_print_read_nego(hd, starget, le32_to_cpu(spi_dev_pg0->NegotiatedParameters));
 
  out_free:
-	dma_free_coherent(&ioc->pcidev->dev, size, pg0, pg0_dma);
+	dma_free_coherent(&ioc->pcidev->dev, size, spi_dev_pg0, spi_dev_pg0_dma);
 	return err;
 }
 
@@ -594,11 +594,11 @@ static u32 mptspi_getRP(struct scsi_targ
 static void mptspi_read_parameters(struct scsi_target *starget)
 {
 	int nego;
-	struct _CONFIG_PAGE_SCSI_DEVICE_0 pg0;
+	struct _CONFIG_PAGE_SCSI_DEVICE_0 spi_dev_pg0;
 
-	mptspi_read_spi_device_pg0(starget, &pg0);
+	mptspi_read_spi_device_pg0(starget, &spi_dev_pg0);
 
-	nego = le32_to_cpu(pg0.NegotiatedParameters);
+	nego = le32_to_cpu(spi_dev_pg0.NegotiatedParameters);
 
 	spi_iu(starget) = (nego & MPI_SCSIDEVPAGE0_NP_IU) ? 1 : 0;
 	spi_dt(starget) = (nego & MPI_SCSIDEVPAGE0_NP_DT) ? 1 : 0;
