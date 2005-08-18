From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/4] fusion: extended config header support
Date: Thu, 18 Aug 2005 16:26:15 +0200
Message-ID: <20050818142615.GE24589@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:63418 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932229AbVHRO0X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Aug 2005 10:26:23 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: Eric.Moore@lsil.com, linux-scsi@vger.kernel.org

Index: scsi-misc-2.6/drivers/message/fusion/mptbase.c
===================================================================
--- scsi-misc-2.6.orig/drivers/message/fusion/mptbase.c	2005-08-18 15:24:27.000000000 +0200
+++ scsi-misc-2.6/drivers/message/fusion/mptbase.c	2005-08-18 15:24:28.000000000 +0200
@@ -485,10 +485,21 @@
 
 				pCfg->status = status;
 				if (status == MPI_IOCSTATUS_SUCCESS) {
-					pCfg->hdr->PageVersion = pReply->Header.PageVersion;
-					pCfg->hdr->PageLength = pReply->Header.PageLength;
-					pCfg->hdr->PageNumber = pReply->Header.PageNumber;
-					pCfg->hdr->PageType = pReply->Header.PageType;
+					if ((pReply->Header.PageType &
+					    MPI_CONFIG_PAGETYPE_MASK) ==
+					    MPI_CONFIG_PAGETYPE_EXTENDED) {
+						pCfg->cfghdr.ehdr->ExtPageLength =
+						    le16_to_cpu(pReply->ExtPageLength);
+						pCfg->cfghdr.ehdr->ExtPageType =
+						    pReply->ExtPageType;
+					}
+					pCfg->cfghdr.hdr->PageVersion = pReply->Header.PageVersion;
+
+					/* If this is a regular header, save PageLength. */
+					/* LMP Do this better so not using a reserved field! */
+					pCfg->cfghdr.hdr->PageLength = pReply->Header.PageLength;
+					pCfg->cfghdr.hdr->PageNumber = pReply->Header.PageNumber;
+					pCfg->cfghdr.hdr->PageType = pReply->Header.PageType;
 				}
 			}
 
@@ -3821,7 +3832,7 @@
 	hdr.PageLength = 0;
 	hdr.PageNumber = 0;
 	hdr.PageType = MPI_CONFIG_PAGETYPE_LAN;
-	cfg.hdr = &hdr;
+	cfg.cfghdr.hdr = &hdr;
 	cfg.physAddr = -1;
 	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
 	cfg.dir = 0;
@@ -3865,7 +3876,7 @@
 	hdr.PageLength = 0;
 	hdr.PageNumber = 1;
 	hdr.PageType = MPI_CONFIG_PAGETYPE_LAN;
-	cfg.hdr = &hdr;
+	cfg.cfghdr.hdr = &hdr;
 	cfg.physAddr = -1;
 	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
 	cfg.dir = 0;
@@ -3932,7 +3943,7 @@
 	hdr.PageLength = 0;
 	hdr.PageNumber = 0;
 	hdr.PageType = MPI_CONFIG_PAGETYPE_FC_PORT;
-	cfg.hdr = &hdr;
+	cfg.cfghdr.hdr = &hdr;
 	cfg.physAddr = -1;
 	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
 	cfg.dir = 0;
@@ -4014,7 +4025,7 @@
 	hdr.PageLength = 0;
 	hdr.PageNumber = 2;
 	hdr.PageType = MPI_CONFIG_PAGETYPE_IO_UNIT;
-	cfg.hdr = &hdr;
+	cfg.cfghdr.hdr = &hdr;
 	cfg.physAddr = -1;
 	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
 	cfg.dir = 0;
@@ -4104,7 +4115,7 @@
 	header.PageLength = 0;
 	header.PageNumber = 0;
 	header.PageType = MPI_CONFIG_PAGETYPE_SCSI_PORT;
-	cfg.hdr = &header;
+	cfg.cfghdr.hdr = &header;
 	cfg.physAddr = -1;
 	cfg.pageAddr = portnum;
 	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
@@ -4177,7 +4188,7 @@
 	header.PageLength = 0;
 	header.PageNumber = 2;
 	header.PageType = MPI_CONFIG_PAGETYPE_SCSI_PORT;
-	cfg.hdr = &header;
+	cfg.cfghdr.hdr = &header;
 	cfg.physAddr = -1;
 	cfg.pageAddr = portnum;
 	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
@@ -4245,7 +4256,7 @@
 	header.PageLength = 0;
 	header.PageNumber = 1;
 	header.PageType = MPI_CONFIG_PAGETYPE_SCSI_DEVICE;
-	cfg.hdr = &header;
+	cfg.cfghdr.hdr = &header;
 	cfg.physAddr = -1;
 	cfg.pageAddr = portnum;
 	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
@@ -4254,8 +4265,8 @@
 	if (mpt_config(ioc, &cfg) != 0)
 		 return -EFAULT;
 
-	ioc->spi_data.sdp1version = cfg.hdr->PageVersion;
-	ioc->spi_data.sdp1length = cfg.hdr->PageLength;
+	ioc->spi_data.sdp1version = cfg.cfghdr.hdr->PageVersion;
+	ioc->spi_data.sdp1length = cfg.cfghdr.hdr->PageLength;
 
 	header.PageVersion = 0;
 	header.PageLength = 0;
@@ -4264,8 +4275,8 @@
 	if (mpt_config(ioc, &cfg) != 0)
 		 return -EFAULT;
 
-	ioc->spi_data.sdp0version = cfg.hdr->PageVersion;
-	ioc->spi_data.sdp0length = cfg.hdr->PageLength;
+	ioc->spi_data.sdp0version = cfg.cfghdr.hdr->PageVersion;
+	ioc->spi_data.sdp0length = cfg.cfghdr.hdr->PageLength;
 
 	dcprintk((MYIOC_s_INFO_FMT "Headers: 0: version %d length %d\n",
 			ioc->name, ioc->spi_data.sdp0version, ioc->spi_data.sdp0length));
@@ -4307,7 +4318,7 @@
 	header.PageLength = 0;
 	header.PageNumber = 2;
 	header.PageType = MPI_CONFIG_PAGETYPE_IOC;
-	cfg.hdr = &header;
+	cfg.cfghdr.hdr = &header;
 	cfg.physAddr = -1;
 	cfg.pageAddr = 0;
 	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
@@ -4403,7 +4414,7 @@
 	header.PageLength = 0;
 	header.PageNumber = 3;
 	header.PageType = MPI_CONFIG_PAGETYPE_IOC;
-	cfg.hdr = &header;
+	cfg.cfghdr.hdr = &header;
 	cfg.physAddr = -1;
 	cfg.pageAddr = 0;
 	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
@@ -4455,7 +4466,7 @@
 	header.PageLength = 0;
 	header.PageNumber = 4;
 	header.PageType = MPI_CONFIG_PAGETYPE_IOC;
-	cfg.hdr = &header;
+	cfg.cfghdr.hdr = &header;
 	cfg.physAddr = -1;
 	cfg.pageAddr = 0;
 	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
@@ -4507,7 +4518,7 @@
 	header.PageLength = 0;
 	header.PageNumber = 1;
 	header.PageType = MPI_CONFIG_PAGETYPE_IOC;
-	cfg.hdr = &header;
+	cfg.cfghdr.hdr = &header;
 	cfg.physAddr = -1;
 	cfg.pageAddr = 0;
 	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
@@ -4658,10 +4669,11 @@
 mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS *pCfg)
 {
 	Config_t	*pReq;
+	ConfigExtendedPageHeader_t  *pExtHdr = NULL;
 	MPT_FRAME_HDR	*mf;
 	unsigned long	 flags;
 	int		 ii, rc;
-	u32		 flagsLength;
+	int		 flagsLength;
 	int		 in_isr;
 
 	/*	Prevent calling wait_event() (below), if caller happens
@@ -4686,16 +4698,30 @@
 	pReq->Reserved = 0;
 	pReq->ChainOffset = 0;
 	pReq->Function = MPI_FUNCTION_CONFIG;
+
+	/* Assume page type is not extended and clear "reserved" fields. */
 	pReq->ExtPageLength = 0;
 	pReq->ExtPageType = 0;
 	pReq->MsgFlags = 0;
+
 	for (ii=0; ii < 8; ii++)
 		pReq->Reserved2[ii] = 0;
 
-	pReq->Header.PageVersion = pCfg->hdr->PageVersion;
-	pReq->Header.PageLength = pCfg->hdr->PageLength;
-	pReq->Header.PageNumber = pCfg->hdr->PageNumber;
-	pReq->Header.PageType = (pCfg->hdr->PageType & MPI_CONFIG_PAGETYPE_MASK);
+	pReq->Header.PageVersion = pCfg->cfghdr.hdr->PageVersion;
+	pReq->Header.PageLength = pCfg->cfghdr.hdr->PageLength;
+	pReq->Header.PageNumber = pCfg->cfghdr.hdr->PageNumber;
+	pReq->Header.PageType = (pCfg->cfghdr.hdr->PageType & MPI_CONFIG_PAGETYPE_MASK);
+
+	if ((pCfg->cfghdr.hdr->PageType & MPI_CONFIG_PAGETYPE_MASK) == MPI_CONFIG_PAGETYPE_EXTENDED) {
+		pExtHdr = (ConfigExtendedPageHeader_t *)pCfg->cfghdr.ehdr;
+		pReq->ExtPageLength = cpu_to_le16(pExtHdr->ExtPageLength);
+		pReq->ExtPageType = pExtHdr->ExtPageType;
+		pReq->Header.PageType = MPI_CONFIG_PAGETYPE_EXTENDED;
+
+		/* Page Length must be treated as a reserved field for the extended header. */
+		pReq->Header.PageLength = 0;
+	}
+
 	pReq->PageAddress = cpu_to_le32(pCfg->pageAddr);
 
 	/* Add a SGE to the config request.
@@ -4705,12 +4731,20 @@
 	else
 		flagsLength = MPT_SGE_FLAGS_SSIMPLE_READ;
 
-	flagsLength |= pCfg->hdr->PageLength * 4;
+	if ((pCfg->cfghdr.hdr->PageType & MPI_CONFIG_PAGETYPE_MASK) == MPI_CONFIG_PAGETYPE_EXTENDED) {
+		flagsLength |= pExtHdr->ExtPageLength * 4;
 
-	mpt_add_sge((char *)&pReq->PageBufferSGE, flagsLength, pCfg->physAddr);
+		dcprintk((MYIOC_s_INFO_FMT "Sending Config request type %d, page %d and action %d\n",
+			ioc->name, pReq->ExtPageType, pReq->Header.PageNumber, pReq->Action));
+	}
+	else {
+		flagsLength |= pCfg->cfghdr.hdr->PageLength * 4;
 
-	dcprintk((MYIOC_s_INFO_FMT "Sending Config request type %d, page %d and action %d\n",
-		ioc->name, pReq->Header.PageType, pReq->Header.PageNumber, pReq->Action));
+		dcprintk((MYIOC_s_INFO_FMT "Sending Config request type %d, page %d and action %d\n",
+			ioc->name, pReq->Header.PageType, pReq->Header.PageNumber, pReq->Action));
+	}
+
+	mpt_add_sge((char *)&pReq->PageBufferSGE, flagsLength, pCfg->physAddr);
 
 	/* Append pCfg pointer to end of mf
 	 */
Index: scsi-misc-2.6/drivers/message/fusion/mptbase.h
===================================================================
--- scsi-misc-2.6.orig/drivers/message/fusion/mptbase.h	2005-08-18 15:24:01.000000000 +0200
+++ scsi-misc-2.6/drivers/message/fusion/mptbase.h	2005-08-18 15:24:28.000000000 +0200
@@ -915,7 +915,10 @@
 typedef struct _x_config_parms {
 	struct list_head	 linkage;	/* linked list */
 	struct timer_list	 timer;		/* timer function for this request  */
-	ConfigPageHeader_t	*hdr;
+	union {
+		ConfigExtendedPageHeader_t	*ehdr;
+		ConfigPageHeader_t	*hdr;
+	} cfghdr;
 	dma_addr_t		 physAddr;
 	int			 wait_done;	/* wait for this request */
 	u32			 pageAddr;	/* properly formatted */
Index: scsi-misc-2.6/drivers/message/fusion/mptctl.c
===================================================================
--- scsi-misc-2.6.orig/drivers/message/fusion/mptctl.c	2005-08-18 15:24:27.000000000 +0200
+++ scsi-misc-2.6/drivers/message/fusion/mptctl.c	2005-08-18 15:24:28.000000000 +0200
@@ -2324,7 +2324,7 @@
 	hdr.PageLength = 0;
 	hdr.PageNumber = 0;
 	hdr.PageType = MPI_CONFIG_PAGETYPE_MANUFACTURING;
-	cfg.hdr = &hdr;
+	cfg.cfghdr.hdr = &hdr;
 	cfg.physAddr = -1;
 	cfg.pageAddr = 0;
 	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
@@ -2333,7 +2333,7 @@
 
 	strncpy(karg.serial_number, " ", 24);
 	if (mpt_config(ioc, &cfg) == 0) {
-		if (cfg.hdr->PageLength > 0) {
+		if (cfg.cfghdr.hdr->PageLength > 0) {
 			/* Issue the second config page request */
 			cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
 
@@ -2479,7 +2479,7 @@
 		hdr.PageNumber = 0;
 		hdr.PageType = MPI_CONFIG_PAGETYPE_SCSI_DEVICE;
 
-		cfg.hdr = &hdr;
+		cfg.cfghdr.hdr = &hdr;
 		cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
 		cfg.dir = 0;
 		cfg.timeout = 0;
@@ -2527,15 +2527,15 @@
 	hdr.PageNumber = 3;
 	hdr.PageType = MPI_CONFIG_PAGETYPE_SCSI_DEVICE;
 
-	cfg.hdr = &hdr;
+	cfg.cfghdr.hdr = &hdr;
 	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
 	cfg.dir = 0;
 	cfg.timeout = 0;
 	cfg.physAddr = -1;
-	if ((mpt_config(ioc, &cfg) == 0) && (cfg.hdr->PageLength > 0)) {
+	if ((mpt_config(ioc, &cfg) == 0) && (cfg.cfghdr.hdr->PageLength > 0)) {
 		/* Issue the second config page request */
 		cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
-		data_sz = (int) cfg.hdr->PageLength * 4;
+		data_sz = (int) cfg.cfghdr.hdr->PageLength * 4;
 		pg3_alloc = (SCSIDevicePage3_t *) pci_alloc_consistent(
 							ioc->pcidev, data_sz, &page_dma);
 		if (pg3_alloc) {
Index: scsi-misc-2.6/drivers/message/fusion/mptscsih.c
===================================================================
--- scsi-misc-2.6.orig/drivers/message/fusion/mptscsih.c	2005-08-18 15:24:27.000000000 +0200
+++ scsi-misc-2.6/drivers/message/fusion/mptscsih.c	2005-08-18 15:24:28.000000000 +0200
@@ -3961,7 +3961,7 @@
 				header1.PageLength = ioc->spi_data.sdp1length;
 				header1.PageNumber = 1;
 				header1.PageType = MPI_CONFIG_PAGETYPE_SCSI_DEVICE;
-				cfg.hdr = &header1;
+				cfg.cfghdr.hdr = &header1;
 				cfg.physAddr = cfg1_dma_addr;
 				cfg.action = MPI_CONFIG_ACTION_PAGE_WRITE_CURRENT;
 				cfg.dir = 1;
@@ -4359,7 +4359,7 @@
 	/* Prep cfg structure
 	 */
 	cfg.pageAddr = (bus<<8) | id;
-	cfg.hdr = NULL;
+	cfg.cfghdr.hdr = NULL;
 
 	/* Prep SDP0 header
 	 */
@@ -4405,7 +4405,7 @@
 	pcfg1Data = (SCSIDevicePage1_t *) (pDvBuf + sz);
 	cfg1_dma_addr = dvbuf_dma + sz;
 
-	/* Skip this ID? Set cfg.hdr to force config page write
+	/* Skip this ID? Set cfg.cfghdr.hdr to force config page write
 	 */
 	{
 		ScsiCfgData *pspi_data = &hd->ioc->spi_data;
@@ -4423,7 +4423,7 @@
 
 				dv.cmd = MPT_SET_MAX;
 				mptscsih_dv_parms(hd, &dv, (void *)pcfg1Data);
-				cfg.hdr = &header1;
+				cfg.cfghdr.hdr = &header1;
 
 				/* Save the final negotiated settings to
 				 * SCSI device page 1.
@@ -4489,7 +4489,7 @@
 		dv.cmd = MPT_SET_MIN;
 		mptscsih_dv_parms(hd, &dv, (void *)pcfg1Data);
 
-		cfg.hdr = &header1;
+		cfg.cfghdr.hdr = &header1;
 		cfg.physAddr = cfg1_dma_addr;
 		cfg.action = MPI_CONFIG_ACTION_PAGE_WRITE_CURRENT;
 		cfg.dir = 1;
@@ -4643,7 +4643,7 @@
 					u32 sdp0_info;
 					u32 sdp0_nego;
 
-					cfg.hdr = &header0;
+					cfg.cfghdr.hdr = &header0;
 					cfg.physAddr = cfg0_dma_addr;
 					cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
 					cfg.dir = 0;
@@ -4728,7 +4728,7 @@
 	 * 4) release
 	 * 5) update nego parms to target struct
 	 */
-	cfg.hdr = &header1;
+	cfg.cfghdr.hdr = &header1;
 	cfg.physAddr = cfg1_dma_addr;
 	cfg.action = MPI_CONFIG_ACTION_PAGE_WRITE_CURRENT;
 	cfg.dir = 1;
@@ -5127,7 +5127,7 @@
 
 	/* Set if cfg1_dma_addr contents is valid
 	 */
-	if ((cfg.hdr != NULL) && (retcode == 0)){
+	if ((cfg.cfghdr.hdr != NULL) && (retcode == 0)){
 		/* If disk, not U320, disable QAS
 		 */
 		if ((inq0 == 0) && (dv.now.factor > MPT_ULTRA320)) {
@@ -5143,7 +5143,7 @@
 		 * skip save of the final negotiated settings to
 		 * SCSI device page 1.
 		 *
-		cfg.hdr = &header1;
+		cfg.cfghdr.hdr = &header1;
 		cfg.physAddr = cfg1_dma_addr;
 		cfg.action = MPI_CONFIG_ACTION_PAGE_WRITE_CURRENT;
 		cfg.dir = 1;
