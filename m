From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] fusion: common code updates for SAS support
Date: Fri, 19 Aug 2005 18:27:27 +0200
Message-ID: <20050819162727.GB15401@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:34780 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S964996AbVHSQ1f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Aug 2005 12:27:35 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: Eric.Moore@lsil.com, linux-scsi@vger.kernel.org

Various core updates to support SAS, including host buffers support.

All this is ported from LSIs driver releases.


Index: scsi-misc-2.6/drivers/message/fusion/mptbase.h
===================================================================
--- scsi-misc-2.6.orig/drivers/message/fusion/mptbase.h	2005-08-18 15:34:16.000000000 +0200
+++ scsi-misc-2.6/drivers/message/fusion/mptbase.h	2005-08-18 15:39:16.000000000 +0200
@@ -65,6 +65,7 @@
 #include "lsi/mpi_fc.h"		/* Fibre Channel (lowlevel) support */
 #include "lsi/mpi_targ.h"	/* SCSI/FCP Target protcol support */
 #include "lsi/mpi_tool.h"	/* Tools support */
+#include "lsi/mpi_sas.h"	/* SAS support */
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 
@@ -477,6 +478,14 @@
 	u8		 rsvd[1];
 } ScsiCfgData;
 
+typedef	struct _SasCfgData {
+	u8		 ptClear;		/* 1 to automatically clear the
+						 * persistent table.
+						 * 0 to disable
+						 * automatic clearing.
+						 */
+}SasCfgData;
+
 /*
  *  Adapter Structure - pci_dev specific. Maximum: MPT_MAX_ADAPTERS
  */
@@ -530,11 +539,15 @@
 	u8			*sense_buf_pool;
 	dma_addr_t		 sense_buf_pool_dma;
 	u32			 sense_buf_low_dma;
+	u8			*HostPageBuffer; /* SAS - host page buffer support */
+	u32			HostPageBuffer_sz;
+	dma_addr_t		HostPageBuffer_dma;
 	int			 mtrr_reg;
 	struct pci_dev		*pcidev;	/* struct pci_dev pointer */
 	u8			__iomem *memmap;	/* mmap address */
 	struct Scsi_Host	*sh;		/* Scsi Host pointer */
 	ScsiCfgData		spi_data;	/* Scsi config. data */
+	SasCfgData		sas_data;	/* Sas config. data */
 	MPT_IOCTL		*ioctl;		/* ioctl data pointer */
 	struct proc_dir_entry	*ioc_dentry;
 	struct _MPT_ADAPTER	*alt_ioc;	/* ptr to 929 bound adapter port */
@@ -554,30 +567,33 @@
 #else
 	u32			 mfcnt;
 #endif
-	u32			 NB_for_64_byte_frame;       
+	u32			 NB_for_64_byte_frame;
 	u32			 hs_req[MPT_MAX_FRAME_SIZE/sizeof(u32)];
 	u16			 hs_reply[MPT_MAX_FRAME_SIZE/sizeof(u16)];
 	IOCFactsReply_t		 facts;
 	PortFactsReply_t	 pfacts[2];
 	FCPortPage0_t		 fc_port_page0[2];
+	struct timer_list	 persist_timer;	/* persist table timer */
+	int			 persist_wait_done; /* persist completion flag */
+	u8			 persist_reply_frame[MPT_DEFAULT_FRAME_SIZE]; /* persist reply */
 	LANPage0_t		 lan_cnfg_page0;
 	LANPage1_t		 lan_cnfg_page1;
-	/*  
+	/*
 	 * Description: errata_flag_1064
 	 * If a PCIX read occurs within 1 or 2 cycles after the chip receives
 	 * a split completion for a read data, an internal address pointer incorrectly
 	 * increments by 32 bytes
 	 */
-	int			 errata_flag_1064;	
+	int			 errata_flag_1064;
 	u8			 FirstWhoInit;
 	u8			 upload_fw;	/* If set, do a fw upload */
 	u8			 reload_fw;	/* Force a FW Reload on next reset */
-	u8			 NBShiftFactor;  /* NB Shift Factor based on Block Size (Facts)  */     
+	u8			 NBShiftFactor;  /* NB Shift Factor based on Block Size (Facts)  */
 	u8			 pad1[4];
 	int			 DoneCtx;
 	int			 TaskCtx;
 	int			 InternalCtx;
-	struct list_head	 list; 
+	struct list_head	 list;
 	struct net_device	*netdev;
 } MPT_ADAPTER;
 
@@ -964,6 +980,7 @@
 extern void	 mpt_free_fw_memory(MPT_ADAPTER *ioc);
 extern int	 mpt_findImVolumes(MPT_ADAPTER *ioc);
 extern int	 mpt_read_ioc_pg_3(MPT_ADAPTER *ioc);
+extern int	 mptbase_sas_persist_operation(MPT_ADAPTER *ioc, u8 persist_opcode);
 
 /*
  *  Public data decl's...
Index: scsi-misc-2.6/drivers/message/fusion/mptbase.c
===================================================================
--- scsi-misc-2.6.orig/drivers/message/fusion/mptbase.c	2005-08-18 15:34:16.000000000 +0200
+++ scsi-misc-2.6/drivers/message/fusion/mptbase.c	2005-08-18 15:37:46.000000000 +0200
@@ -141,7 +141,7 @@
 static int	SendIocInit(MPT_ADAPTER *ioc, int sleepFlag);
 static int	SendPortEnable(MPT_ADAPTER *ioc, int portnum, int sleepFlag);
 static int	mpt_do_upload(MPT_ADAPTER *ioc, int sleepFlag);
-static int	mpt_downloadboot(MPT_ADAPTER *ioc, int sleepFlag);
+static int	mpt_downloadboot(MPT_ADAPTER *ioc, MpiFwHeader_t *pFwHeader, int sleepFlag);
 static int	mpt_diag_reset(MPT_ADAPTER *ioc, int ignore, int sleepFlag);
 static int	KickStart(MPT_ADAPTER *ioc, int ignore, int sleepFlag);
 static int	SendIocReset(MPT_ADAPTER *ioc, u8 reset_type, int sleepFlag);
@@ -152,6 +152,7 @@
 static int	GetLanConfigPages(MPT_ADAPTER *ioc);
 static int	GetFcPortPage0(MPT_ADAPTER *ioc, int portnum);
 static int	GetIoUnitPage2(MPT_ADAPTER *ioc);
+int		mptbase_sas_persist_operation(MPT_ADAPTER *ioc, u8 persist_opcode);
 static int	mpt_GetScsiPortSettings(MPT_ADAPTER *ioc, int portnum);
 static int	mpt_readScsiDevicePageHeaders(MPT_ADAPTER *ioc, int portnum);
 static void 	mpt_read_ioc_pg_1(MPT_ADAPTER *ioc);
@@ -159,6 +160,8 @@
 static void	mpt_timer_expired(unsigned long data);
 static int	SendEventNotification(MPT_ADAPTER *ioc, u8 EvSwitch);
 static int	SendEventAck(MPT_ADAPTER *ioc, EventNotificationReply_t *evnp);
+static int	mpt_host_page_access_control(MPT_ADAPTER *ioc, u8 access_control_value, int sleepFlag);
+static int	mpt_host_page_alloc(MPT_ADAPTER *ioc, pIOCInit_t ioc_init);
 
 #ifdef CONFIG_PROC_FS
 static int	procmpt_summary_read(char *buf, char **start, off_t offset,
@@ -509,6 +512,14 @@
 			pCfg->wait_done = 1;
 			wake_up(&mpt_waitq);
 		}
+	} else if (func == MPI_FUNCTION_SAS_IO_UNIT_CONTROL) {
+		/* we should be always getting a reply frame */
+		memcpy(ioc->persist_reply_frame, reply,
+		    min(MPT_DEFAULT_FRAME_SIZE,
+		    4*reply->u.reply.MsgLength));
+		del_timer(&ioc->persist_timer);
+		ioc->persist_wait_done = 1;
+		wake_up(&mpt_waitq);
 	} else {
 		printk(MYIOC_s_ERR_FMT "Unexpected msg function (=%02Xh) reply received!\n",
 				ioc->name, func);
@@ -750,6 +761,7 @@
 		mf = list_entry(ioc->FreeQ.next, MPT_FRAME_HDR,
 				u.frame.linkage.list);
 		list_del(&mf->u.frame.linkage.list);
+		mf->u.frame.linkage.arg1 = 0;
 		mf->u.frame.hwhdr.msgctxu.fld.cb_idx = handle;	/* byte */
 		req_offset = (u8 *)mf - (u8 *)ioc->req_frames;
 								/* u16! */
@@ -845,6 +857,7 @@
 
 	/*  Put Request back on FreeQ!  */
 	spin_lock_irqsave(&ioc->FreeQlock, flags);
+	mf->u.frame.linkage.arg1 = 0xdeadbeaf; /* signature to know if this mf is freed */
 	list_add_tail(&mf->u.frame.linkage.list, &ioc->FreeQ);
 #ifdef MFCNT
 	ioc->mfcnt--;
@@ -971,12 +984,123 @@
 
 	/* Make sure there are no doorbells */
 	CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);
-	
+
 	return r;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
+ * mpt_host_page_access_control - provides mechanism for the host
+ * driver to control the IOC's Host Page Buffer access.
+ * @ioc: Pointer to MPT adapter structure
+ * @access_control_value: define bits below
+ *
+ * Access Control Value - bits[15:12]
+ * 0h Reserved
+ * 1h Enable Access { MPI_DB_HPBAC_ENABLE_ACCESS }
+ * 2h Disable Access { MPI_DB_HPBAC_DISABLE_ACCESS }
+ * 3h Free Buffer { MPI_DB_HPBAC_FREE_BUFFER }
+ *
+ * Returns 0 for success, non-zero for failure.
+ */
+
+static int
+mpt_host_page_access_control(MPT_ADAPTER *ioc, u8 access_control_value, int sleepFlag)
+{
+	int	 r = 0;
+
+	/* return if in use */
+	if (CHIPREG_READ32(&ioc->chip->Doorbell)
+	    & MPI_DOORBELL_ACTIVE)
+	    return -1;
+
+	CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);
+
+	CHIPREG_WRITE32(&ioc->chip->Doorbell,
+		((MPI_FUNCTION_HOST_PAGEBUF_ACCESS_CONTROL
+		 <<MPI_DOORBELL_FUNCTION_SHIFT) |
+		 (access_control_value<<12)));
+
+	/* Wait for IOC to clear Doorbell Status bit */
+	if ((r = WaitForDoorbellAck(ioc, 5, sleepFlag)) < 0) {
+		return -2;
+	}else
+		return 0;
+}
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/**
+ *	mpt_host_page_alloc - allocate system memory for the fw
+ *	If we already allocated memory in past, then resend the same pointer.
+ *	ioc@: Pointer to pointer to IOC adapter
+ *	ioc_init@: Pointer to ioc init config page
+ *
+ *	Returns 0 for success, non-zero for failure.
+ */
+static int
+mpt_host_page_alloc(MPT_ADAPTER *ioc, pIOCInit_t ioc_init)
+{
+	char	*psge;
+	int	flags_length;
+	u32	host_page_buffer_sz=0;
+
+	if(!ioc->HostPageBuffer) {
+
+		host_page_buffer_sz =
+		    le32_to_cpu(ioc->facts.HostPageBufferSGE.FlagsLength) & 0xFFFFFF;
+
+		if(!host_page_buffer_sz)
+			return 0; /* fw doesn't need any host buffers */
+
+		/* spin till we get enough memory */
+		while(host_page_buffer_sz > 0) {
+
+			if((ioc->HostPageBuffer = pci_alloc_consistent(
+			    ioc->pcidev,
+			    host_page_buffer_sz,
+			    &ioc->HostPageBuffer_dma)) != NULL) {
+
+				dinitprintk((MYIOC_s_INFO_FMT
+				    "host_page_buffer @ %p, dma @ %x, sz=%d bytes\n",
+				    ioc->name,
+				    ioc->HostPageBuffer,
+				    ioc->HostPageBuffer_dma,
+				    hst_page_buffer_sz));
+				ioc->alloc_total += host_page_buffer_sz;
+				ioc->HostPageBuffer_sz = host_page_buffer_sz;
+				break;
+			}
+
+			host_page_buffer_sz -= (4*1024);
+		}
+	}
+
+	if(!ioc->HostPageBuffer) {
+		printk(MYIOC_s_ERR_FMT
+		    "Failed to alloc memory for host_page_buffer!\n",
+		    ioc->name);
+		return -999;
+	}
+
+	psge = (char *)&ioc_init->HostPageBufferSGE;
+	flags_length = MPI_SGE_FLAGS_SIMPLE_ELEMENT |
+	    MPI_SGE_FLAGS_SYSTEM_ADDRESS |
+	    MPI_SGE_FLAGS_32_BIT_ADDRESSING |
+	    MPI_SGE_FLAGS_HOST_TO_IOC |
+	    MPI_SGE_FLAGS_END_OF_BUFFER;
+	if (sizeof(dma_addr_t) == sizeof(u64)) {
+	    flags_length |= MPI_SGE_FLAGS_64_BIT_ADDRESSING;
+	}
+	flags_length = flags_length << MPI_SGE_FLAGS_SHIFT;
+	flags_length |= ioc->HostPageBuffer_sz;
+	mpt_add_sge(psge, flags_length, ioc->HostPageBuffer_dma);
+	ioc->facts.HostPageBufferSGE = ioc_init->HostPageBufferSGE;
+
+return 0;
+}
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/**
  *	mpt_verify_adapter - Given a unique IOC identifier, set pointer to
  *	the associated MPT adapter structure.
  *	@iocid: IOC unique identifier (integer)
@@ -1213,6 +1337,33 @@
 		ioc->prod_name = "LSI53C1035";
 		ioc->bus_type = SCSI;
 	}
+	else if (pdev->device == MPI_MANUFACTPAGE_DEVID_SAS1064) {
+		ioc->prod_name = "LSISAS1064";
+		ioc->bus_type = SAS;
+		ioc->errata_flag_1064 = 1;
+	}
+	else if (pdev->device == MPI_MANUFACTPAGE_DEVID_SAS1066) {
+		ioc->prod_name = "LSISAS1066";
+		ioc->bus_type = SAS;
+		ioc->errata_flag_1064 = 1;
+	}
+	else if (pdev->device == MPI_MANUFACTPAGE_DEVID_SAS1068) {
+		ioc->prod_name = "LSISAS1068";
+		ioc->bus_type = SAS;
+		ioc->errata_flag_1064 = 1;
+	}
+	else if (pdev->device == MPI_MANUFACTPAGE_DEVID_SAS1064E) {
+		ioc->prod_name = "LSISAS1064E";
+		ioc->bus_type = SAS;
+	}
+	else if (pdev->device == MPI_MANUFACTPAGE_DEVID_SAS1066E) {
+		ioc->prod_name = "LSISAS1066E";
+		ioc->bus_type = SAS;
+	}
+	else if (pdev->device == MPI_MANUFACTPAGE_DEVID_SAS1068E) {
+		ioc->prod_name = "LSISAS1068E";
+		ioc->bus_type = SAS;
+	}
 
 	if (ioc->errata_flag_1064)
 		pci_disable_io_access(pdev);
@@ -1640,7 +1791,22 @@
 	 *	and we try GetLanConfigPages again...
 	 */
 	if ((ret == 0) && (reason == MPT_HOSTEVENT_IOC_BRINGUP)) {
-		if (ioc->bus_type == FC) {
+		if (ioc->bus_type == SAS) {
+
+			/* clear persistency table */
+			if(ioc->facts.IOCExceptions &
+			    MPI_IOCFACTS_EXCEPT_PERSISTENT_TABLE_FULL) {
+				ret = mptbase_sas_persist_operation(ioc,
+				    MPI_SAS_OP_CLEAR_NOT_PRESENT);
+				if(ret != 0)
+					return -1;
+			}
+
+			/* Find IM volumes
+			 */
+			mpt_findImVolumes(ioc);
+
+		} else if (ioc->bus_type == FC) {
 			/*
 			 *  Pre-fetch FC port WWN and stuff...
 			 *  (FCPortPage0_t stuff)
@@ -1783,7 +1949,7 @@
 
 	if (ioc->cached_fw != NULL) {
 		ddlprintk((KERN_INFO MYNAM ": mpt_adapter_disable: Pushing FW onto adapter\n"));
-		if ((ret = mpt_downloadboot(ioc, NO_SLEEP)) < 0) {
+		if ((ret = mpt_downloadboot(ioc, (MpiFwHeader_t *)ioc->cached_fw, NO_SLEEP)) < 0) {
 			printk(KERN_WARNING MYNAM
 				": firmware downloadboot failure (%d)!\n", ret);
 		}
@@ -1852,6 +2018,23 @@
 
 	kfree(ioc->ChainToChain);
 	ioc->ChainToChain = NULL;
+
+	if (ioc->HostPageBuffer != NULL) {
+		if((ret = mpt_host_page_access_control(ioc,
+		    MPI_DB_HPBAC_FREE_BUFFER, NO_SLEEP)) != 0) {
+			printk(KERN_ERR MYNAM
+			   ": %s: host page buffers free failed (%d)!\n",
+			    __FUNCTION__, ret);
+		}
+		dexitprintk((KERN_INFO MYNAM ": %s HostPageBuffer free  @ %p, sz=%d bytes\n",
+		 	ioc->name, ioc->HostPageBuffer, ioc->HostPageBuffer_sz));
+		pci_free_consistent(ioc->pcidev, ioc->HostPageBuffer_sz,
+				ioc->HostPageBuffer,
+				ioc->HostPageBuffer_dma);
+		ioc->HostPageBuffer = NULL;
+		ioc->HostPageBuffer_sz = 0;
+		ioc->alloc_total -= ioc->HostPageBuffer_sz;
+	}
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -2034,7 +2217,7 @@
 	 *  Loop here waiting for IOC to come READY.
 	 */
 	ii = 0;
-	cntdn = ((sleepFlag == CAN_SLEEP) ? HZ : 1000) * 15;	/* 15 seconds */
+	cntdn = ((sleepFlag == CAN_SLEEP) ? HZ : 1000) * 5;	/* 5 seconds */
 
 	while ((ioc_state = mpt_GetIocState(ioc, 1)) != MPI_IOC_STATE_READY) {
 		if (ioc_state == MPI_IOC_STATE_OPERATIONAL) {
@@ -2212,6 +2395,7 @@
 				le32_to_cpu(facts->CurrentSenseBufferHighAddr);
 		facts->CurReplyFrameSize =
 				le16_to_cpu(facts->CurReplyFrameSize);
+		facts->IOCCapabilities = le32_to_cpu(facts->IOCCapabilities);
 
 		/*
 		 * Handle NEW (!) IOCFactsReply fields in MPI-1.01.xx
@@ -2383,13 +2567,25 @@
 	ddlprintk((MYIOC_s_INFO_FMT "upload_fw %d facts.Flags=%x\n",
 		   ioc->name, ioc->upload_fw, ioc->facts.Flags));
 
-	if (ioc->bus_type == FC)
+	if(ioc->bus_type == SAS)
+		ioc_init.MaxDevices = ioc->facts.MaxDevices;
+	else if(ioc->bus_type == FC)
 		ioc_init.MaxDevices = MPT_MAX_FC_DEVICES;
 	else
 		ioc_init.MaxDevices = MPT_MAX_SCSI_DEVICES;
-	
 	ioc_init.MaxBuses = MPT_MAX_BUS;
-
+	dinitprintk((MYIOC_s_INFO_FMT "facts.MsgVersion=%x\n",
+		   ioc->name, ioc->facts.MsgVersion));
+	if (ioc->facts.MsgVersion >= MPI_VERSION_01_05) {
+		// set MsgVersion and HeaderVersion host driver was built with
+		ioc_init.MsgVersion = cpu_to_le16(MPI_VERSION);
+	        ioc_init.HeaderVersion = cpu_to_le16(MPI_HEADER_VERSION);
+
+		if (ioc->facts.Flags & MPI_IOCFACTS_FLAGS_HOST_PAGE_BUFFER_PERSISTENT) {
+			ioc_init.HostPageBufferSGE = ioc->facts.HostPageBufferSGE;
+		} else if(mpt_host_page_alloc(ioc, &ioc_init))
+			return -99;
+	}
 	ioc_init.ReplyFrameSize = cpu_to_le16(ioc->reply_sz);	/* in BYTES */
 
 	if (sizeof(dma_addr_t) == sizeof(u64)) {
@@ -2403,17 +2599,21 @@
 		ioc_init.HostMfaHighAddr = cpu_to_le32(0);
 		ioc_init.SenseBufferHighAddr = cpu_to_le32(0);
 	}
-		
+
 	ioc->facts.CurrentHostMfaHighAddr = ioc_init.HostMfaHighAddr;
 	ioc->facts.CurrentSenseBufferHighAddr = ioc_init.SenseBufferHighAddr;
+	ioc->facts.MaxDevices = ioc_init.MaxDevices;
+	ioc->facts.MaxBuses = ioc_init.MaxBuses;
 
 	dhsprintk((MYIOC_s_INFO_FMT "Sending IOCInit (req @ %p)\n",
 			ioc->name, &ioc_init));
 
 	r = mpt_handshake_req_reply_wait(ioc, sizeof(IOCInit_t), (u32*)&ioc_init,
 				sizeof(MPIDefaultReply_t), (u16*)&init_reply, 10 /*seconds*/, sleepFlag);
-	if (r != 0)
+	if (r != 0) {
+		printk(MYIOC_s_ERR_FMT "Sending IOCInit failed(%d)!\n",ioc->name, r);
 		return r;
+	}
 
 	/* No need to byte swap the multibyte fields in the reply
 	 * since we don't even look at it's contents.
@@ -2472,7 +2672,7 @@
 {
 	PortEnable_t		 port_enable;
 	MPIDefaultReply_t	 reply_buf;
-	int	 ii;
+	int	 rc;
 	int	 req_sz;
 	int	 reply_sz;
 
@@ -2494,22 +2694,15 @@
 
 	/* RAID FW may take a long time to enable
 	 */
-	if (ioc->bus_type == FC) {
-		ii = mpt_handshake_req_reply_wait(ioc, req_sz, (u32*)&port_enable,
-				reply_sz, (u16*)&reply_buf, 65 /*seconds*/, sleepFlag);
-	} else {
-		ii = mpt_handshake_req_reply_wait(ioc, req_sz, (u32*)&port_enable,
+	if ( (ioc->facts.ProductID & MPI_FW_HEADER_PID_PROD_MASK)
+			> MPI_FW_HEADER_PID_PROD_TARGET_SCSI ) {
+		rc = mpt_handshake_req_reply_wait(ioc, req_sz, (u32*)&port_enable,
 				reply_sz, (u16*)&reply_buf, 300 /*seconds*/, sleepFlag);
+	} else {
+		rc = mpt_handshake_req_reply_wait(ioc, req_sz, (u32*)&port_enable,
+				reply_sz, (u16*)&reply_buf, 30 /*seconds*/, sleepFlag);
 	}
-
-	if (ii != 0)
-		return ii;
-
-	/* We do not even look at the reply, so we need not
-	 * swap the multi-byte fields.
-	 */
-
-	return 0;
+	return rc;
 }
 
 /*
@@ -2666,9 +2859,8 @@
  *		<0 for fw upload failure.
  */
 static int
-mpt_downloadboot(MPT_ADAPTER *ioc, int sleepFlag)
+mpt_downloadboot(MPT_ADAPTER *ioc, MpiFwHeader_t *pFwHeader, int sleepFlag)
 {
-	MpiFwHeader_t		*pFwHeader;
 	MpiExtImageHeader_t	*pExtImage;
 	u32			 fwSize;
 	u32			 diag0val;
@@ -2679,18 +2871,8 @@
 	u32			 load_addr;
 	u32 			 ioc_state=0;
 
-	ddlprintk((MYIOC_s_INFO_FMT "downloadboot: fw size 0x%x, ioc FW Ptr %p\n",
-				ioc->name, ioc->facts.FWImageSize, ioc->cached_fw));
-
-	if ( ioc->facts.FWImageSize == 0 )
-		return -1;
-
-	if (ioc->cached_fw == NULL)
-		return -2;
-
-	/* prevent a second downloadboot and memory free with alt_ioc */
-	if (ioc->alt_ioc && ioc->alt_ioc->cached_fw)
-		ioc->alt_ioc->cached_fw = NULL;
+	ddlprintk((MYIOC_s_INFO_FMT "downloadboot: fw size 0x%x (%d), FW Ptr %p\n",
+				ioc->name, pFwHeader->ImageSize, pFwHeader->ImageSize, pFwHeader));
 
 	CHIPREG_WRITE32(&ioc->chip->WriteSequence, 0xFF);
 	CHIPREG_WRITE32(&ioc->chip->WriteSequence, MPI_WRSEQ_1ST_KEY_VALUE);
@@ -2718,16 +2900,17 @@
 				ioc->name, count));
 			break;
 		}
-		/* wait 1 sec */
+		/* wait .1 sec */
 		if (sleepFlag == CAN_SLEEP) {
-			msleep_interruptible (1000);
+			msleep_interruptible (100);
 		} else {
-			mdelay (1000);
+			mdelay (100);
 		}
 	}
 
 	if ( count == 30 ) {
-		ddlprintk((MYIOC_s_INFO_FMT "downloadboot failed! Unable to RESET_ADAPTER diag0val=%x\n",
+		ddlprintk((MYIOC_s_INFO_FMT "downloadboot failed! "
+		"Unable to get MPI_DIAG_DRWE mode, diag0val=%x\n",
 		ioc->name, diag0val));
 		return -3;
 	}
@@ -2742,7 +2925,6 @@
 	/* Set the DiagRwEn and Disable ARM bits */
 	CHIPREG_WRITE32(&ioc->chip->Diagnostic, (MPI_DIAG_RW_ENABLE | MPI_DIAG_DISABLE_ARM));
 
-	pFwHeader = (MpiFwHeader_t *) ioc->cached_fw;
 	fwSize = (pFwHeader->ImageSize + 3)/4;
 	ptrFw = (u32 *) pFwHeader;
 
@@ -2792,19 +2974,38 @@
 	/* Clear the internal flash bad bit - autoincrementing register,
 	 * so must do two writes.
 	 */
-	CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwAddress, 0x3F000000);
-	diagRwData = CHIPREG_PIO_READ32(&ioc->pio_chip->DiagRwData);
-	diagRwData |= 0x4000000;
-	CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwAddress, 0x3F000000);
-	CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwData, diagRwData);
+	if (ioc->bus_type == SCSI) {
+		/*
+		 * 1030 and 1035 H/W errata, workaround to access
+		 * the ClearFlashBadSignatureBit
+		 */
+		CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwAddress, 0x3F000000);
+		diagRwData = CHIPREG_PIO_READ32(&ioc->pio_chip->DiagRwData);
+		diagRwData |= 0x40000000;
+		CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwAddress, 0x3F000000);
+		CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwData, diagRwData);
+
+	} else /* if((ioc->bus_type == SAS) || (ioc->bus_type == FC)) */ {
+		diag0val = CHIPREG_READ32(&ioc->chip->Diagnostic);
+		CHIPREG_WRITE32(&ioc->chip->Diagnostic, diag0val |
+		    MPI_DIAG_CLEAR_FLASH_BAD_SIG);
+
+		/* wait 1 msec */
+		if (sleepFlag == CAN_SLEEP) {
+			msleep_interruptible (1);
+		} else {
+			mdelay (1);
+		}
+	}
 
 	if (ioc->errata_flag_1064)
 		pci_disable_io_access(ioc->pcidev);
 
 	diag0val = CHIPREG_READ32(&ioc->chip->Diagnostic);
-	ddlprintk((MYIOC_s_INFO_FMT "downloadboot diag0val=%x, turning off PREVENT_IOC_BOOT, DISABLE_ARM\n",
+	ddlprintk((MYIOC_s_INFO_FMT "downloadboot diag0val=%x, "
+		"turning off PREVENT_IOC_BOOT, DISABLE_ARM, RW_ENABLE\n",
 		ioc->name, diag0val));
-	diag0val &= ~(MPI_DIAG_PREVENT_IOC_BOOT | MPI_DIAG_DISABLE_ARM);
+	diag0val &= ~(MPI_DIAG_PREVENT_IOC_BOOT | MPI_DIAG_DISABLE_ARM | MPI_DIAG_RW_ENABLE);
 	ddlprintk((MYIOC_s_INFO_FMT "downloadboot now diag0val=%x\n",
 		ioc->name, diag0val));
 	CHIPREG_WRITE32(&ioc->chip->Diagnostic, diag0val);
@@ -2812,10 +3013,23 @@
 	/* Write 0xFF to reset the sequencer */
 	CHIPREG_WRITE32(&ioc->chip->WriteSequence, 0xFF);
 
+	if (ioc->bus_type == SAS) {
+		ioc_state = mpt_GetIocState(ioc, 0);
+		if ( (GetIocFacts(ioc, sleepFlag,
+				MPT_HOSTEVENT_IOC_BRINGUP)) != 0 ) {
+			ddlprintk((MYIOC_s_INFO_FMT "GetIocFacts failed: IocState=%x\n",
+					ioc->name, ioc_state));
+			return -EFAULT;
+		}
+	}
+
 	for (count=0; count<HZ*20; count++) {
 		if ((ioc_state = mpt_GetIocState(ioc, 0)) & MPI_IOC_STATE_READY) {
 			ddlprintk((MYIOC_s_INFO_FMT "downloadboot successful! (count=%d) IocState=%x\n",
 					ioc->name, count, ioc_state));
+			if (ioc->bus_type == SAS) {
+				return 0;
+			}
 			if ((SendIocInit(ioc, sleepFlag)) != 0) {
 				ddlprintk((MYIOC_s_INFO_FMT "downloadboot: SendIocInit failed\n",
 					ioc->name));
@@ -3049,12 +3263,13 @@
 
 				/* wait 1 sec */
 				if (sleepFlag == CAN_SLEEP) {
-					ssleep(1);
+					msleep_interruptible (1000);
 				} else {
 					mdelay (1000);
 				}
 			}
-			if ((count = mpt_downloadboot(ioc, sleepFlag)) < 0) {
+			if ((count = mpt_downloadboot(ioc,
+				(MpiFwHeader_t *)ioc->cached_fw, sleepFlag)) < 0) {
 				printk(KERN_WARNING MYNAM
 					": firmware downloadboot failure (%d)!\n", count);
 			}
@@ -4001,6 +4216,85 @@
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
+ *	mptbase_sas_persist_operation - Perform operation on SAS Persitent Table
+ *	@ioc: Pointer to MPT_ADAPTER structure
+ *	@sas_address: 64bit SAS Address for operation.
+ *	@target_id: specified target for operation
+ *	@bus: specified bus for operation
+ *	@persist_opcode: see below
+ *
+ *	MPI_SAS_OP_CLEAR_NOT_PRESENT - Free all persist TargetID mappings for
+ *		devices not currently present.
+ *	MPI_SAS_OP_CLEAR_ALL_PERSISTENT - Clear al persist TargetID mappings
+ *
+ *	NOTE: Don't use not this function during interrupt time.
+ *
+ *	Returns: 0 for success, non-zero error
+ */
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+int
+mptbase_sas_persist_operation(MPT_ADAPTER *ioc, u8 persist_opcode)
+{
+	SasIoUnitControlRequest_t	*sasIoUnitCntrReq;
+	SasIoUnitControlReply_t		*sasIoUnitCntrReply;
+	MPT_FRAME_HDR			*mf = NULL;
+	MPIHeader_t			*mpi_hdr;
+
+
+	/* insure garbage is not sent to fw */
+	switch(persist_opcode) {
+
+	case MPI_SAS_OP_CLEAR_NOT_PRESENT:
+	case MPI_SAS_OP_CLEAR_ALL_PERSISTENT:
+		break;
+
+	default:
+		return -1;
+		break;
+	}
+
+	printk("%s: persist_opcode=%x\n",__FUNCTION__, persist_opcode);
+
+	/* Get a MF for this command.
+	 */
+	if ((mf = mpt_get_msg_frame(mpt_base_index, ioc)) == NULL) {
+		printk("%s: no msg frames!\n",__FUNCTION__);
+		return -1;
+        }
+
+	mpi_hdr = (MPIHeader_t *) mf;
+	sasIoUnitCntrReq = (SasIoUnitControlRequest_t *)mf;
+	memset(sasIoUnitCntrReq,0,sizeof(SasIoUnitControlRequest_t));
+	sasIoUnitCntrReq->Function = MPI_FUNCTION_SAS_IO_UNIT_CONTROL;
+	sasIoUnitCntrReq->MsgContext = mpi_hdr->MsgContext;
+	sasIoUnitCntrReq->Operation = persist_opcode;
+
+	init_timer(&ioc->persist_timer);
+	ioc->persist_timer.data = (unsigned long) ioc;
+	ioc->persist_timer.function = mpt_timer_expired;
+	ioc->persist_timer.expires = jiffies + HZ*10 /* 10 sec */;
+	ioc->persist_wait_done=0;
+	add_timer(&ioc->persist_timer);
+	mpt_put_msg_frame(mpt_base_index, ioc, mf);
+	wait_event(mpt_waitq, ioc->persist_wait_done);
+
+	sasIoUnitCntrReply =
+	    (SasIoUnitControlReply_t *)ioc->persist_reply_frame;
+	if (le16_to_cpu(sasIoUnitCntrReply->IOCStatus) != MPI_IOCSTATUS_SUCCESS) {
+		printk("%s: IOCStatus=0x%X IOCLogInfo=0x%X\n",
+		    __FUNCTION__,
+		    sasIoUnitCntrReply->IOCStatus,
+		    sasIoUnitCntrReply->IOCLogInfo);
+		return -1;
+	}
+
+	printk("%s: success\n",__FUNCTION__);
+	return 0;
+}
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/*
  *	GetIoUnitPage2 - Retrieve BIOS version and boot order information.
  *	@ioc: Pointer to MPT_ADAPTER structure
  *
@@ -5366,8 +5660,8 @@
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-static char *
-EventDescriptionStr(u8 event, u32 evData0)
+static void
+EventDescriptionStr(u8 event, u32 evData0, char *evStr)
 {
 	char *ds;
 
@@ -5420,8 +5714,95 @@
 			ds = "Events(OFF) Change";
 		break;
 	case MPI_EVENT_INTEGRATED_RAID:
-		ds = "Integrated Raid";
+	{
+		u8 ReasonCode = (u8)(evData0 >> 16);
+		switch (ReasonCode) {
+		case MPI_EVENT_RAID_RC_VOLUME_CREATED :
+			ds = "Integrated Raid: Volume Created";
+			break;
+		case MPI_EVENT_RAID_RC_VOLUME_DELETED :
+			ds = "Integrated Raid: Volume Deleted";
+			break;
+		case MPI_EVENT_RAID_RC_VOLUME_SETTINGS_CHANGED :
+			ds = "Integrated Raid: Volume Settings Changed";
+			break;
+		case MPI_EVENT_RAID_RC_VOLUME_STATUS_CHANGED :
+			ds = "Integrated Raid: Volume Status Changed";
+			break;
+		case MPI_EVENT_RAID_RC_VOLUME_PHYSDISK_CHANGED :
+			ds = "Integrated Raid: Volume Physdisk Changed";
+			break;
+		case MPI_EVENT_RAID_RC_PHYSDISK_CREATED :
+			ds = "Integrated Raid: Physdisk Created";
+			break;
+		case MPI_EVENT_RAID_RC_PHYSDISK_DELETED :
+			ds = "Integrated Raid: Physdisk Deleted";
+			break;
+		case MPI_EVENT_RAID_RC_PHYSDISK_SETTINGS_CHANGED :
+			ds = "Integrated Raid: Physdisk Settings Changed";
+			break;
+		case MPI_EVENT_RAID_RC_PHYSDISK_STATUS_CHANGED :
+			ds = "Integrated Raid: Physdisk Status Changed";
+			break;
+		case MPI_EVENT_RAID_RC_DOMAIN_VAL_NEEDED :
+			ds = "Integrated Raid: Domain Validation Needed";
+			break;
+		case MPI_EVENT_RAID_RC_SMART_DATA :
+			ds = "Integrated Raid; Smart Data";
+			break;
+		case MPI_EVENT_RAID_RC_REPLACE_ACTION_STARTED :
+			ds = "Integrated Raid: Replace Action Started";
+			break;
+		default:
+			ds = "Integrated Raid";
 		break;
+		}
+		break;
+	}
+	case MPI_EVENT_SCSI_DEVICE_STATUS_CHANGE:
+		ds = "SCSI Device Status Change";
+		break;
+	case MPI_EVENT_SAS_DEVICE_STATUS_CHANGE:
+	{
+		u8 ReasonCode = (u8)(evData0 >> 16);
+		switch (ReasonCode) {
+		case MPI_EVENT_SAS_DEV_STAT_RC_ADDED:
+			ds = "SAS Device Status Change: Added";
+			break;
+		case MPI_EVENT_SAS_DEV_STAT_RC_NOT_RESPONDING:
+			ds = "SAS Device Status Change: Deleted";
+			break;
+		case MPI_EVENT_SAS_DEV_STAT_RC_SMART_DATA:
+			ds = "SAS Device Status Change: SMART Data";
+			break;
+		case MPI_EVENT_SAS_DEV_STAT_RC_NO_PERSIST_ADDED:
+			ds = "SAS Device Status Change: No Persistancy Added";
+			break;
+		default:
+			ds = "SAS Device Status Change: Unknown";
+		break;
+		}
+		break;
+	}
+	case MPI_EVENT_ON_BUS_TIMER_EXPIRED:
+		ds = "Bus Timer Expired";
+		break;
+	case MPI_EVENT_QUEUE_FULL:
+		ds = "Queue Full";
+		break;
+	case MPI_EVENT_SAS_SES:
+		ds = "SAS SES Event";
+		break;
+	case MPI_EVENT_PERSISTENT_TABLE_FULL:
+		ds = "Persistent Table Full";
+		break;
+	case MPI_EVENT_SAS_PHY_LINK_STATUS:
+		ds = "SAS PHY Link Status";
+		break;
+	case MPI_EVENT_SAS_DISCOVERY_ERROR:
+		ds = "SAS Discovery Error";
+		break;
+
 	/*
 	 *  MPT base "custom" events may be added here...
 	 */
@@ -5429,7 +5810,7 @@
 		ds = "Unknown";
 		break;
 	}
-	return ds;
+	strcpy(evStr,ds);
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -5451,7 +5832,7 @@
 	int ii;
 	int r = 0;
 	int handlers = 0;
-	char *evStr;
+	char evStr[100];
 	u8 event;
 
 	/*
@@ -5464,7 +5845,7 @@
 		evData0 = le32_to_cpu(pEventReply->Data[0]);
 	}
 
-	evStr = EventDescriptionStr(event, evData0);
+	EventDescriptionStr(event, evData0, evStr);
 	devtprintk((MYIOC_s_INFO_FMT "MPT event (%s=%02Xh) detected!\n",
 			ioc->name,
 			evStr,
@@ -5481,20 +5862,6 @@
 	 *  Do general / base driver event processing
 	 */
 	switch(event) {
-	case MPI_EVENT_NONE:			/* 00 */
-	case MPI_EVENT_LOG_DATA:		/* 01 */
-	case MPI_EVENT_STATE_CHANGE:		/* 02 */
-	case MPI_EVENT_UNIT_ATTENTION:		/* 03 */
-	case MPI_EVENT_IOC_BUS_RESET:		/* 04 */
-	case MPI_EVENT_EXT_BUS_RESET:		/* 05 */
-	case MPI_EVENT_RESCAN:			/* 06 */
-	case MPI_EVENT_LINK_STATUS_CHANGE:	/* 07 */
-	case MPI_EVENT_LOOP_STATE_CHANGE:	/* 08 */
-	case MPI_EVENT_LOGOUT:			/* 09 */
-	case MPI_EVENT_INTEGRATED_RAID:		/* 0B */
-	case MPI_EVENT_SCSI_DEVICE_STATUS_CHANGE:	/* 0C */
-	default:
-		break;
 	case MPI_EVENT_EVENT_CHANGE:		/* 0A */
 		if (evDataLen) {
 			u8 evState = evData0 & 0xFF;
@@ -5507,6 +5874,8 @@
 			}
 		}
 		break;
+	default:
+		break;
 	}
 
 	/*
