From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/8]  fusion - mptctl - backplane istwi fix
Date: Sat, 4 Feb 2006 11:06:17 +0000
Message-ID: <20060204110616.GE27621@infradead.org>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F24369A@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:24510 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932340AbWBDLGU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Feb 2006 06:06:20 -0500
Content-Disposition: inline
In-Reply-To: <F331B95B72AFFB4B87467BE1C8E9CF5F24369A@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Feb 02, 2006 at 05:19:47PM -0700, Moore, Eric wrote:
> Moving the toolbox call from mptbase.c, over to
> mptctl.c, and using the mptctl infastructure to issue
> the call.  The existing code is hanging on certain HP platforms
> when this ioctl is issued, and this patch fix's that.

ok.  keeping code only in the module that needs it is a good thing.


diff -uarN b/drivers/message/fusion/mptbase.c a/drivers/message/fusion/mptbase.c
--- b/drivers/message/fusion/mptbase.c	2006-02-02 15:18:57.000000000 -0700
+++ a/drivers/message/fusion/mptbase.c	2006-02-02 15:59:22.000000000 -0700
@@ -452,8 +452,7 @@
 	} else if (func == MPI_FUNCTION_EVENT_ACK) {
 		dprintk((MYIOC_s_INFO_FMT "mpt_base_reply, EventAck reply received\n",
 				ioc->name));
-	} else if (func == MPI_FUNCTION_CONFIG ||
-		   func == MPI_FUNCTION_TOOLBOX) {
+	} else if (func == MPI_FUNCTION_CONFIG) {
 		CONFIGPARMS *pCfg;
 		unsigned long flags;
 
@@ -5327,115 +5326,6 @@
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/**
- *	mpt_toolbox - Generic function to issue toolbox message
- *	@ioc - Pointer to an adapter structure
- *	@cfg - Pointer to a toolbox structure. Struct contains
- *		action, page address, direction, physical address
- *		and pointer to a configuration page header
- *		Page header is updated.
- *
- *	Returns 0 for success
- *	-EPERM if not allowed due to ISR context
- *	-EAGAIN if no msg frames currently available
- *	-EFAULT for non-successful reply or no reply (timeout)
- */
-int
-mpt_toolbox(MPT_ADAPTER *ioc, CONFIGPARMS *pCfg)
-{
-	ToolboxIstwiReadWriteRequest_t	*pReq;
-	MPT_FRAME_HDR	*mf;
-	struct pci_dev	*pdev;
-	unsigned long	 flags;
-	int		 rc;
-	u32		 flagsLength;
-	int		 in_isr;
-
-	/*	Prevent calling wait_event() (below), if caller happens
-	 *	to be in ISR context, because that is fatal!
-	 */
-	in_isr = in_interrupt();
-	if (in_isr) {
-		dcprintk((MYIOC_s_WARN_FMT "toobox request not allowed in ISR context!\n",
-				ioc->name));
-		return -EPERM;
-	}
-
-	/* Get and Populate a free Frame
-	 */
-	if ((mf = mpt_get_msg_frame(mpt_base_index, ioc)) == NULL) {
-		dcprintk((MYIOC_s_WARN_FMT "mpt_toolbox: no msg frames!\n",
-				ioc->name));
-		return -EAGAIN;
-	}
-	pReq = (ToolboxIstwiReadWriteRequest_t	*)mf;
-	pReq->Tool = pCfg->action;
-	pReq->Reserved = 0;
-	pReq->ChainOffset = 0;
-	pReq->Function = MPI_FUNCTION_TOOLBOX;
-	pReq->Reserved1 = 0;
-	pReq->Reserved2 = 0;
-	pReq->MsgFlags = 0;
-	pReq->Flags = pCfg->dir;
-	pReq->BusNum = 0;
-	pReq->Reserved3 = 0;
-	pReq->NumAddressBytes = 0x01;
-	pReq->Reserved4 = 0;
-	pReq->DataLength = cpu_to_le16(0x04);
-	pdev = ioc->pcidev;
-	if (pdev->devfn & 1)
-		pReq->DeviceAddr = 0xB2;
-	else
-		pReq->DeviceAddr = 0xB0;
-	pReq->Addr1 = 0;
-	pReq->Addr2 = 0;
-	pReq->Addr3 = 0;
-	pReq->Reserved5 = 0;
-
-	/* Add a SGE to the config request.
-	 */
-
-	flagsLength = MPT_SGE_FLAGS_SSIMPLE_READ | 4;
-
-	mpt_add_sge((char *)&pReq->SGL, flagsLength, pCfg->physAddr);
-
-	dcprintk((MYIOC_s_INFO_FMT "Sending Toolbox request, Tool=%x\n",
-		ioc->name, pReq->Tool));
-
-	/* Append pCfg pointer to end of mf
-	 */
-	*((void **) (((u8 *) mf) + (ioc->req_sz - sizeof(void *)))) =  (void *) pCfg;
-
-	/* Initalize the timer
-	 */
-	init_timer(&pCfg->timer);
-	pCfg->timer.data = (unsigned long) ioc;
-	pCfg->timer.function = mpt_timer_expired;
-	pCfg->wait_done = 0;
-
-	/* Set the timer; ensure 10 second minimum */
-	if (pCfg->timeout < 10)
-		pCfg->timer.expires = jiffies + HZ*10;
-	else
-		pCfg->timer.expires = jiffies + HZ*pCfg->timeout;
-
-	/* Add to end of Q, set timer and then issue this command */
-	spin_lock_irqsave(&ioc->FreeQlock, flags);
-	list_add_tail(&pCfg->linkage, &ioc->configQ);
-	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
-
-	add_timer(&pCfg->timer);
-	mpt_put_msg_frame(mpt_base_index, ioc, mf);
-	wait_event(mpt_waitq, pCfg->wait_done);
-
-	/* mf has been freed - do not access */
-
-	rc = pCfg->status;
-
-	return rc;
-}
-
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
  *	mpt_timer_expired - Call back for timer process.
  *	Used only internal config functionality.
@@ -6540,7 +6430,6 @@
 EXPORT_SYMBOL(mpt_stm_index);
 EXPORT_SYMBOL(mpt_HardResetHandler);
 EXPORT_SYMBOL(mpt_config);
-EXPORT_SYMBOL(mpt_toolbox);
 EXPORT_SYMBOL(mpt_findImVolumes);
 EXPORT_SYMBOL(mpt_read_ioc_pg_3);
 EXPORT_SYMBOL(mpt_alloc_fw_memory);
diff -uarN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2006-02-02 14:52:22.000000000 -0700
+++ a/drivers/message/fusion/mptbase.h	2006-02-02 16:00:04.000000000 -0700
@@ -1026,7 +1026,6 @@
 extern void	 mpt_print_ioc_summary(MPT_ADAPTER *ioc, char *buf, int *size, int len, int showlan);
 extern int	 mpt_HardResetHandler(MPT_ADAPTER *ioc, int sleepFlag);
 extern int	 mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS *cfg);
-extern int	 mpt_toolbox(MPT_ADAPTER *ioc, CONFIGPARMS *cfg);
 extern void	 mpt_alloc_fw_memory(MPT_ADAPTER *ioc, int size);
 extern void	 mpt_free_fw_memory(MPT_ADAPTER *ioc);
 extern int	 mpt_findImVolumes(MPT_ADAPTER *ioc);
diff -uarN b/drivers/message/fusion/mptctl.c a/drivers/message/fusion/mptctl.c
--- b/drivers/message/fusion/mptctl.c	2006-02-02 15:54:08.000000000 -0700
+++ a/drivers/message/fusion/mptctl.c	2006-02-02 16:23:12.000000000 -0700
@@ -2271,13 +2271,16 @@
 	hp_host_info_t	__user *uarg = (void __user *) arg;
 	MPT_ADAPTER		*ioc;
 	struct pci_dev		*pdev;
-	char			*pbuf;
+	char                    *pbuf=NULL;
 	dma_addr_t		buf_dma;
 	hp_host_info_t		karg;
 	CONFIGPARMS		cfg;
 	ConfigPageHeader_t	hdr;
 	int			iocnum;
 	int			rc, cim_rev;
+	ToolboxIstwiReadWriteRequest_t	*IstwiRWRequest;
+	MPT_FRAME_HDR		*mf = NULL;
+	MPIHeader_t		*mpi_hdr;
 
 	dctlprintk((": mptctl_hp_hostinfo called.\n"));
 	/* Reset long to int. Should affect IA64 and SPARC only
@@ -2413,19 +2416,66 @@
 		}
 	}
 
-	cfg.pageAddr = 0;
-	cfg.action = MPI_TOOLBOX_ISTWI_READ_WRITE_TOOL;
-	cfg.dir = MPI_TB_ISTWI_FLAGS_READ;
-	cfg.timeout = 10;
+	/* 
+	 * Gather ISTWI(Industry Standard Two Wire Interface) Data
+	 */
+	if ((mf = mpt_get_msg_frame(mptctl_id, ioc)) == NULL) {
+		dfailprintk((MYIOC_s_WARN_FMT "%s, no msg frames!!\n",
+		    ioc->name,__FUNCTION__));
+		goto out;
+	}
+
+	IstwiRWRequest = (ToolboxIstwiReadWriteRequest_t *)mf;
+	mpi_hdr = (MPIHeader_t *) mf;
+	memset(IstwiRWRequest,0,sizeof(ToolboxIstwiReadWriteRequest_t));
+	IstwiRWRequest->Function = MPI_FUNCTION_TOOLBOX;
+	IstwiRWRequest->Tool = MPI_TOOLBOX_ISTWI_READ_WRITE_TOOL;
+	IstwiRWRequest->MsgContext = mpi_hdr->MsgContext;
+	IstwiRWRequest->Flags = MPI_TB_ISTWI_FLAGS_READ;
+	IstwiRWRequest->NumAddressBytes = 0x01;
+	IstwiRWRequest->DataLength = cpu_to_le16(0x04);
+	if (pdev->devfn & 1)
+		IstwiRWRequest->DeviceAddr = 0xB2;
+	else
+		IstwiRWRequest->DeviceAddr = 0xB0;
+
 	pbuf = pci_alloc_consistent(ioc->pcidev, 4, &buf_dma);
-	if (pbuf) {
-		cfg.physAddr = buf_dma;
-		if ((mpt_toolbox(ioc, &cfg)) == 0) {
-			karg.rsvd = *(u32 *)pbuf;
-		}
+	if (!pbuf)
+		goto out;
+	mpt_add_sge((char *)&IstwiRWRequest->SGL,
+	    (MPT_SGE_FLAGS_SSIMPLE_READ|4), buf_dma);
+
+	ioc->ioctl->wait_done = 0;
+	mpt_put_msg_frame(mptctl_id, ioc, mf);
+
+	rc = wait_event_timeout(mptctl_wait,
+	     ioc->ioctl->wait_done == 1,
+	     HZ*MPT_IOCTL_DEFAULT_TIMEOUT /* 10 sec */);
+
+	if(rc <=0 && (ioc->ioctl->wait_done != 1 )) {
+		/* 
+		 * Now we need to reset the board
+		 */
+		mpt_free_msg_frame(ioc, mf);
+		mptctl_timeout_expired(ioc->ioctl);
+		goto out;
+	}
+
+	/* 
+	 *ISTWI Data Definition
+	 * pbuf[0] = FW_VERSION = 0x4
+	 * pbuf[1] = Bay Count = 6 or 4 or 2, depending on
+	 *  the config, you should be seeing one out of these three values
+	 * pbuf[2] = Drive Installed Map = bit pattern depend on which
+	 *   bays have drives in them
+	 * pbuf[3] = Checksum (0x100 = (byte0 + byte2 + byte3)
+	 */
+	if (ioc->ioctl->status & MPT_IOCTL_STATUS_RF_VALID)
+		karg.rsvd = *(u32 *)pbuf;
+
+ out:
+	if (pbuf)
 		pci_free_consistent(ioc->pcidev, 4, pbuf, buf_dma);
-		pbuf = NULL;
-	}
 
 	/* Copy the data from kernel memory to user memory
 	 */
