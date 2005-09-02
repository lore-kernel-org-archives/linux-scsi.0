From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [PATCH  2/4] fusion: whitespace fixes
Date: Fri, 2 Sep 2005 10:07:58 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C03DF17A9@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:4068 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751495AbVIBQIR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Sep 2005 12:08:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

Please apply

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

> 
> Index: scsi-misc-2.6/drivers/message/fusion/mptspi.c
> ===================================================================
> --- scsi-misc-2.6.orig/drivers/message/fusion/mptspi.c	
> 2005-08-17 19:46:11.000000000 +0200
> +++ scsi-misc-2.6/drivers/message/fusion/mptspi.c	
> 2005-08-17 19:46:46.000000000 +0200
> @@ -162,15 +162,15 @@
>  	u8			*mem;
>  	int			error=0;
>  	int			r;
> -	
> +
>  	if ((r = mpt_attach(pdev,id)) != 0)
>  		return r;
> -	
> +
>  	ioc = pci_get_drvdata(pdev);
>  	ioc->DoneCtx = mptspiDoneCtx;
>  	ioc->TaskCtx = mptspiTaskCtx;
>  	ioc->InternalCtx = mptspiInternalCtx;
> -	
> +
>  	/*  Added sanity check on readiness of the MPT adapter.
>  	 */
>  	if (ioc->last_state != MPI_IOC_STATE_OPERATIONAL) {
> Index: scsi-misc-2.6/drivers/message/fusion/mptbase.c
> ===================================================================
> --- scsi-misc-2.6.orig/drivers/message/fusion/mptbase.c	
> 2005-08-17 19:46:11.000000000 +0200
> +++ scsi-misc-2.6/drivers/message/fusion/mptbase.c	
> 2005-08-17 21:22:03.000000000 +0200
> @@ -218,8 +218,7 @@
>   *	(also referred to as a IO Controller or IOC).
>   *	This routine must clear the interrupt from the adapter and does
>   *	so by reading the reply FIFO.  Multiple replies may be processed
> - *	per single call to this routine; up to MPT_MAX_REPLIES_PER_ISR
> - *	which is currently set to 32 in mptbase.h.
> + *	per single call to this routine.
>   *
>   *	This routine handles register-level access of the adapter but
>   *	dispatches (calls) a protocol-specific callback routine 
> to handle
> @@ -279,11 +278,11 @@
>  			cb_idx = mr->u.frame.hwhdr.msgctxu.fld.cb_idx;
>  			mf = MPT_INDEX_2_MFPTR(ioc, req_idx);
>  
> -			dmfprintk((MYIOC_s_INFO_FMT "Got 
> non-TURBO reply=%p req_idx=%x\n",
> -					ioc->name, mr, req_idx));
> +			dmfprintk((MYIOC_s_INFO_FMT "Got 
> non-TURBO reply=%p req_idx=%x cb_idx=%x Function=%x\n",
> +					ioc->name, mr, req_idx, 
> cb_idx, mr->u.hdr.Function));
>  			DBG_DUMP_REPLY_FRAME(mr)
>  
> -			/*  Check/log IOC log info
> +			 /*  Check/log IOC log info
>  			 */
>  			ioc_stat = le16_to_cpu(mr->u.reply.IOCStatus);
>  			if (ioc_stat & 
> MPI_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE) {
> @@ -345,7 +344,7 @@
>  			if ((mf) && ((mf >= 
> MPT_INDEX_2_MFPTR(ioc, ioc->req_depth))
>  				|| (mf < ioc->req_frames)) ) {
>  				printk(MYIOC_s_WARN_FMT
> -					"mpt_interrupt: Invalid 
> mf (%p) req_idx (%d)!\n", ioc->name, (void *)mf, req_idx);
> +					"mpt_interrupt: Invalid 
> mf (%p)!\n", ioc->name, (void *)mf);
>  				cb_idx = 0;
>  				pa = 0;
>  				freeme = 0;
> @@ -399,7 +398,7 @@
>   *	@mf: Pointer to original MPT request frame
>   *	@reply: Pointer to MPT reply frame (NULL if TurboReply)
>   *
> -	*	Returns 1 indicating original alloc'd request frame ptr
> + *	Returns 1 indicating original alloc'd request frame ptr
>   *	should be freed, or 0 if it shouldn't.
>   */
>  static int
> @@ -408,28 +407,17 @@
>  	int freereq = 1;
>  	u8 func;
>  
> -	dprintk((MYIOC_s_INFO_FMT "mpt_base_reply() called\n", 
> ioc->name));
> -
> -	if ((mf == NULL) ||
> -	    (mf >= MPT_INDEX_2_MFPTR(ioc, ioc->req_depth))) {
> -		printk(MYIOC_s_ERR_FMT "NULL or BAD request 
> frame ptr! (=%p)\n",
> -				ioc->name, (void *)mf);
> -		return 1;
> -	}
> -
> -	if (reply == NULL) {
> -		dprintk((MYIOC_s_ERR_FMT "Unexpected NULL Event 
> (turbo?) reply!\n",
> -				ioc->name));
> -		return 1;
> -	}
> +	dmfprintk((MYIOC_s_INFO_FMT "mpt_base_reply() 
> called\n", ioc->name));
>  
> +#if defined(MPT_DEBUG_MSG_FRAME)
>  	if (!(reply->u.hdr.MsgFlags & 
> MPI_MSGFLAGS_CONTINUATION_REPLY)) {
>  		dmfprintk((KERN_INFO MYNAM ": Original request 
> frame (@%p) header\n", mf));
>  		DBG_DUMP_REQUEST_FRAME_HDR(mf)
>  	}
> +#endif
>  
>  	func = reply->u.hdr.Function;
> -	dprintk((MYIOC_s_INFO_FMT "mpt_base_reply, Function=%02Xh\n",
> +	dmfprintk((MYIOC_s_INFO_FMT "mpt_base_reply, Function=%02Xh\n",
>  			ioc->name, func));
>  
>  	if (func == MPI_FUNCTION_EVENT_NOTIFICATION) {
> @@ -448,8 +436,14 @@
>  		 *	Hmmm...  It seems that 
> EventNotificationReply is an exception
>  		 *	to the rule of one reply per request.
>  		 */
> -		if (pEvReply->MsgFlags & 
> MPI_MSGFLAGS_CONTINUATION_REPLY)
> +		if (pEvReply->MsgFlags & 
> MPI_MSGFLAGS_CONTINUATION_REPLY) {
>  			freereq = 0;
> +			devtprintk((MYIOC_s_WARN_FMT 
> "EVENT_NOTIFICATION reply %p does not return Request frame\n",
> +				ioc->name, pEvReply));
> +		} else {
> +			devtprintk((MYIOC_s_WARN_FMT 
> "EVENT_NOTIFICATION reply %p returns Request frame\n",
> +				ioc->name, pEvReply));
> +		}
>  
>  #ifdef CONFIG_PROC_FS
>  //		LogEvent(ioc, pEvReply);
> @@ -705,7 +699,7 @@
>  		if (dd_cbfunc->remove)
>  			dd_cbfunc->remove(ioc->pcidev);
>  	}
> -	
> +
>  	MptDeviceDriverHandlers[cb_idx] = NULL;
>  }
>  
> @@ -818,7 +812,7 @@
>  	}
>  #endif
>  
> -	mf_dma_addr = (ioc->req_frames_low_dma + req_offset) | 
> ioc->RequestNB[req_idx];  
> +	mf_dma_addr = (ioc->req_frames_low_dma + req_offset) | 
> ioc->RequestNB[req_idx];
>  	dsgprintk((MYIOC_s_INFO_FMT "mf_dma_addr=%x req_idx=%d 
> RequestNB=%x\n", ioc->name, mf_dma_addr, req_idx, 
> ioc->RequestNB[req_idx]));
>  	CHIPREG_WRITE32(&ioc->chip->RequestFifo, mf_dma_addr);
>  }
> @@ -920,7 +914,7 @@
>  
>  	/* Make sure there are no doorbells */
>  	CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);
> -	
> +
>  	CHIPREG_WRITE32(&ioc->chip->Doorbell,
>  			
> ((MPI_FUNCTION_HANDSHAKE<<MPI_DOORBELL_FUNCTION_SHIFT) |
>  			 
> ((reqBytes/4)<<MPI_DOORBELL_ADD_DWORDS_SHIFT)));
> @@ -935,14 +929,14 @@
>  		return -5;
>  
>  	dhsprintk((KERN_INFO MYNAM ": %s: 
> mpt_send_handshake_request start, WaitCnt=%d\n",
> -			ioc->name, ii));
> +		ioc->name, ii));
>  
>  	CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);
>  
>  	if ((r = WaitForDoorbellAck(ioc, 5, sleepFlag)) < 0) {
>  		return -2;
>  	}
> -		
> +
>  	/* Send request via doorbell handshake */
>  	req_as_bytes = (u8 *) req;
>  	for (ii = 0; ii < reqBytes/4; ii++) {
> @@ -988,9 +982,9 @@
>  		if (ioc->id == iocid) {
>  			*iocpp =ioc;
>  			return iocid;
> -		} 
> +		}
>  	}
> -	
> +
>  	*iocpp = NULL;
>  	return -1;
>  }
> @@ -1032,9 +1026,9 @@
>  
>  	if (pci_enable_device(pdev))
>  		return r;
> -	
> +
>  	dinitprintk((KERN_WARNING MYNAM ": mpt_adapter_install\n"));
> -	
> +
>  	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
>  		dprintk((KERN_INFO MYNAM
>  			": 64 BIT PCI BUS DMA ADDRESSING SUPPORTED\n"));
> @@ -1059,7 +1053,7 @@
>  	ioc->alloc_total = sizeof(MPT_ADAPTER);
>  	ioc->req_sz = MPT_DEFAULT_FRAME_SIZE;		/* 
> avoid div by zero! */
>  	ioc->reply_sz = MPT_REPLY_FRAME_SIZE;
> -	
> +
>  	ioc->pcidev = pdev;
>  	ioc->diagPending = 0;
>  	spin_lock_init(&ioc->diagLock);
> @@ -1088,7 +1082,7 @@
>  	/* Find lookup slot. */
>  	INIT_LIST_HEAD(&ioc->list);
>  	ioc->id = mpt_ids++;
> -	
> +
>  	mem_phys = msize = 0;
>  	port = psize = 0;
>  	for (ii=0; ii < DEVICE_COUNT_RESOURCE; ii++) {
> @@ -1143,7 +1137,7 @@
>  		ioc->prod_name = "LSIFC909";
>  		ioc->bus_type = FC;
>  	}
> -	if (pdev->device == MPI_MANUFACTPAGE_DEVICEID_FC929) {
> +	else if (pdev->device == MPI_MANUFACTPAGE_DEVICEID_FC929) {
>  		ioc->prod_name = "LSIFC929";
>  		ioc->bus_type = FC;
>  	}
> @@ -1322,7 +1316,7 @@
>  	remove_proc_entry(pname, NULL);
>  	sprintf(pname, MPT_PROCFS_MPTBASEDIR "/%s", ioc->name);
>  	remove_proc_entry(pname, NULL);
> -	
> +
>  	/* call per device driver remove entry point */
>  	for(ii=0; ii<MPT_MAX_PROTOCOL_DRIVERS; ii++) {
>  		if(MptDeviceDriverHandlers[ii] &&
> @@ -1330,7 +1324,7 @@
>  			MptDeviceDriverHandlers[ii]->remove(pdev);
>  		}
>  	}
> -	
> +
>  	/* Disable interrupts! */
>  	CHIPREG_WRITE32(&ioc->chip->IntMask, 0xFFFFFFFF);
>  
> @@ -1403,7 +1397,7 @@
>  	u32 device_state = pdev->current_state;
>  	int recovery_state;
>  	int ii;
> -	
> +
>  	printk(MYIOC_s_INFO_FMT
>  	"pci-resume: pdev=0x%p, slot=%s, Previous operating 
> state [D%d]\n",
>  		ioc->name, pdev, pci_name(pdev), device_state);
> @@ -1534,7 +1528,7 @@
>  		if ((rc = GetIocFacts(ioc, sleepFlag, reason)) == 0)
>  			break;
>  	}
> -	
> +
>  
>  	if (ii == 5) {
>  		dinitprintk((MYIOC_s_INFO_FMT "Retry IocFacts 
> failed rc=%x\n", ioc->name, rc));
> @@ -1542,7 +1536,7 @@
>  	} else if (reason == MPT_HOSTEVENT_IOC_BRINGUP) {
>  		MptDisplayIocCapabilities(ioc);
>  	}
> -	
> +
>  	if (alt_ioc_ready) {
>  		if ((rc = GetIocFacts(ioc->alt_ioc, sleepFlag, 
> reason)) != 0) {
>  			dinitprintk((MYIOC_s_INFO_FMT "Initial 
> Alt IocFacts failed rc=%x\n", ioc->name, rc));
> @@ -1613,7 +1607,7 @@
>  
>  	if (reset_alt_ioc_active && ioc->alt_ioc) {
>  		/* (re)Enable alt-IOC! (reply interrupt) */
> -		dprintk((KERN_INFO MYNAM ": alt-%s reply irq 
> re-enabled\n",
> +		dinitprintk((KERN_INFO MYNAM ": alt-%s reply 
> irq re-enabled\n",
>  				ioc->alt_ioc->name));
>  		CHIPREG_WRITE32(&ioc->alt_ioc->chip->IntMask, 
> ~(MPI_HIM_RIM));
>  		ioc->alt_ioc->active = 1;
> @@ -1670,7 +1664,7 @@
>  
>  			/* Find IM volumes
>  			 */
> -			if (ioc->facts.MsgVersion >= 0x0102)
> +			if (ioc->facts.MsgVersion >= MPI_VERSION_01_02)
>  				mpt_findImVolumes(ioc);
>  
>  			/* Check, and possibly reset, the 
> coalescing value
> @@ -1700,7 +1694,7 @@
>  			}
>  
>  			if (alt_ioc_ready && MptResetHandlers[ii]) {
> -				dprintk((MYIOC_s_INFO_FMT 
> "Calling alt-%s post_reset handler #%d\n",
> +				drsprintk((MYIOC_s_INFO_FMT 
> "Calling alt-%s post_reset handler #%d\n",
>  						ioc->name, 
> ioc->alt_ioc->name, ii));
>  				rc += 
> (*(MptResetHandlers[ii]))(ioc->alt_ioc, MPT_IOC_POST_RESET);
>  				handlers++;
> @@ -1733,8 +1727,8 @@
>  
>  	dprintk((MYIOC_s_INFO_FMT "PCI device %s devfn=%x/%x,"
>  	    " searching for devfn match on %x or %x\n",
> -		ioc->name, pci_name(pdev), pdev->devfn,
> -		func-1, func+1));
> +		ioc->name, pci_name(pdev), pdev->bus->number,
> +		pdev->devfn, func-1, func+1));
>  
>  	peer = pci_get_slot(pdev->bus, PCI_DEVFN(slot,func-1));
>  	if (!peer) {
> @@ -1861,36 +1855,39 @@
>  static void
>  mpt_adapter_dispose(MPT_ADAPTER *ioc)
>  {
> -	if (ioc != NULL) {
> -		int sz_first, sz_last;
> +	int sz_first, sz_last;
>  
> -		sz_first = ioc->alloc_total;
> +	if (ioc == NULL)
> +		return;
>  
> -		mpt_adapter_disable(ioc);
> +	sz_first = ioc->alloc_total;
>  
> -		if (ioc->pci_irq != -1) {
> -			free_irq(ioc->pci_irq, ioc);
> -			ioc->pci_irq = -1;
> -		}
> +	mpt_adapter_disable(ioc);
>  
> -		if (ioc->memmap != NULL)
> -			iounmap(ioc->memmap);
> +	if (ioc->pci_irq != -1) {
> +		free_irq(ioc->pci_irq, ioc);
> +		ioc->pci_irq = -1;
> +	}
> +
> +	if (ioc->memmap != NULL) {
> +		iounmap(ioc->memmap);
> +		ioc->memmap = NULL;
> +	}
>  
>  #if defined(CONFIG_MTRR) && 0
> -		if (ioc->mtrr_reg > 0) {
> -			mtrr_del(ioc->mtrr_reg, 0, 0);
> -			dprintk((KERN_INFO MYNAM ": %s: MTRR 
> region de-registered\n", ioc->name));
> -		}
> +	if (ioc->mtrr_reg > 0) {
> +		mtrr_del(ioc->mtrr_reg, 0, 0);
> +		dprintk((KERN_INFO MYNAM ": %s: MTRR region 
> de-registered\n", ioc->name));
> +	}
>  #endif
>  
> -		/*  Zap the adapter lookup ptr!  */
> -		list_del(&ioc->list);
> +	/*  Zap the adapter lookup ptr!  */
> +	list_del(&ioc->list);
>  
> -		sz_last = ioc->alloc_total;
> -		dprintk((KERN_INFO MYNAM ": %s: free'd %d of %d 
> bytes\n",
> -				ioc->name, 
> sz_first-sz_last+(int)sizeof(*ioc), sz_first));
> -		kfree(ioc);
> -	}
> +	sz_last = ioc->alloc_total;
> +	dprintk((KERN_INFO MYNAM ": %s: free'd %d of %d bytes\n",
> +			ioc->name, 
> sz_first-sz_last+(int)sizeof(*ioc), sz_first));
> +	kfree(ioc);
>  }
>  
>  
> /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
> =-=-=-=-=-=-=-=*/
> @@ -1977,7 +1974,7 @@
>  	}
>  
>  	/* Is it already READY? */
> -	if (!statefault && (ioc_state & MPI_IOC_STATE_MASK) == 
> MPI_IOC_STATE_READY) 
> +	if (!statefault && (ioc_state & MPI_IOC_STATE_MASK) == 
> MPI_IOC_STATE_READY)
>  		return 0;
>  
>  	/*
> @@ -1995,7 +1992,7 @@
>  	 *	Hmmm...  Did it get left operational?
>  	 */
>  	if ((ioc_state & MPI_IOC_STATE_MASK) == 
> MPI_IOC_STATE_OPERATIONAL) {
> -		dinitprintk((MYIOC_s_WARN_FMT "IOC operational 
> unexpected\n",
> +		dinitprintk((MYIOC_s_INFO_FMT "IOC operational 
> unexpected\n",
>  				ioc->name));
>  
>  		/* Check WhoInit.
> @@ -2004,8 +2001,8 @@
>  		 * Else, fall through to KickStart case
>  		 */
>  		whoinit = (ioc_state & 
> MPI_DOORBELL_WHO_INIT_MASK) >> MPI_DOORBELL_WHO_INIT_SHIFT;
> -		dprintk((KERN_WARNING MYNAM
> -			": whoinit 0x%x\n statefault %d force %d\n",
> +		dinitprintk((KERN_INFO MYNAM
> +			": whoinit 0x%x statefault %d force %d\n",
>  			whoinit, statefault, force));
>  		if (whoinit == MPI_WHOINIT_PCI_PEER)
>  			return -4;
> @@ -2140,8 +2137,8 @@
>  	get_facts.Function = MPI_FUNCTION_IOC_FACTS;
>  	/* Assert: All other get_facts fields are zero! */
>  
> -	dinitprintk((MYIOC_s_INFO_FMT 
> -	    "Sending get IocFacts request req_sz=%d reply_sz=%d\n", 
> +	dinitprintk((MYIOC_s_INFO_FMT
> +	    "Sending get IocFacts request req_sz=%d reply_sz=%d\n",
>  	    ioc->name, req_sz, reply_sz));
>  
>  	/* No non-zero fields in the get_facts request are greater than
> @@ -2221,7 +2218,7 @@
>  		if ( sz & 0x02 )
>  			sz += 2;
>  		facts->FWImageSize = sz;
> -		
> +
>  		if (!facts->RequestFrameSize) {
>  			/*  Something is wrong!  */
>  			printk(MYIOC_s_ERR_FMT "IOC reported 
> invalid 0 request size!\n",
> @@ -2240,7 +2237,7 @@
>  		ioc->NBShiftFactor  = shiftFactor;
>  		dinitprintk((MYIOC_s_INFO_FMT 
> "NB_for_64_byte_frame=%x NBShiftFactor=%x BlockSize=%x\n",
>  					ioc->name, vv, shiftFactor, r));
> -    
> +
>  		if (reason == MPT_HOSTEVENT_IOC_BRINGUP) {
>  			/*
>  			 * Set values for this IOC's request & 
> reply frame sizes,
> @@ -2261,7 +2258,7 @@
>  				return r;
>  		}
>  	} else {
> -		printk(MYIOC_s_ERR_FMT 
> +		printk(MYIOC_s_ERR_FMT
>  		     "Invalid IOC facts reply, msgLength=%d 
> offsetof=%zd!\n",
>  		     ioc->name, facts->MsgLength, 
> (offsetof(IOCFactsReply_t,
>  		     RequestFrameSize)/sizeof(u32)));
> @@ -2413,9 +2410,11 @@
>  
>  	dhsprintk((MYIOC_s_INFO_FMT "Sending PortEnable (req @ %p)\n",
>  			ioc->name, &ioc_init));
> -	
> -	if ((r = SendPortEnable(ioc, 0, sleepFlag)) != 0)
> +
> +	if ((r = SendPortEnable(ioc, 0, sleepFlag)) != 0) {
> +		printk(MYIOC_s_ERR_FMT "Sending PortEnable 
> failed(%d)!\n",ioc->name, r);
>  		return r;
> +	}
>  
>  	/* YIKES!  SUPER IMPORTANT!!!
>  	 *  Poll IocState until _OPERATIONAL while IOC is doing
> @@ -2440,7 +2439,7 @@
>  		state = mpt_GetIocState(ioc, 1);
>  		count++;
>  	}
> -	dhsprintk((MYIOC_s_INFO_FMT "INFO - Wait 
> IOC_OPERATIONAL state (cnt=%d)\n",
> +	dinitprintk((MYIOC_s_INFO_FMT "INFO - Wait 
> IOC_OPERATIONAL state (cnt=%d)\n",
>  			ioc->name, count));
>  
>  	return r;
> @@ -2529,7 +2528,7 @@
>  	int sz;
>  
>  	sz = ioc->facts.FWImageSize;
> -	dinitprintk((KERN_WARNING MYNAM "free_fw_memory: FW 
> Image  @ %p[%p], sz=%d[%x] bytes\n",
> +	dinitprintk((KERN_INFO MYNAM "free_fw_memory: FW Image  
> @ %p[%p], sz=%d[%x] bytes\n",
>  		 ioc->cached_fw, (void 
> *)(ulong)ioc->cached_fw_dma, sz, sz));
>  	pci_free_consistent(ioc->pcidev, sz,
>  			ioc->cached_fw, ioc->cached_fw_dma);
> @@ -2573,9 +2572,9 @@
>  
>  	mpt_alloc_fw_memory(ioc, sz);
>  
> -	dinitprintk((KERN_WARNING MYNAM ": FW Image  @ %p[%p], 
> sz=%d[%x] bytes\n",
> +	dinitprintk((KERN_INFO MYNAM ": FW Image  @ %p[%p], 
> sz=%d[%x] bytes\n",
>  		 ioc->cached_fw, (void 
> *)(ulong)ioc->cached_fw_dma, sz, sz));
> -	
> +
>  	if (ioc->cached_fw == NULL) {
>  		/* Major Failure.
>  		 */
> @@ -2605,14 +2604,14 @@
>  	mpt_add_sge(&request[sgeoffset], flagsLength, 
> ioc->cached_fw_dma);
>  
>  	sgeoffset += sizeof(u32) + sizeof(dma_addr_t);
> -	dinitprintk((KERN_WARNING MYNAM "Sending FW Upload (req 
> @ %p) sgeoffset=%d \n",
> +	dinitprintk((KERN_INFO MYNAM ": Sending FW Upload (req 
> @ %p) sgeoffset=%d \n",
>  			prequest, sgeoffset));
>  	DBG_DUMP_FW_REQUEST_FRAME(prequest)
>  
>  	ii = mpt_handshake_req_reply_wait(ioc, sgeoffset, 
> (u32*)prequest,
>  				reply_sz, (u16*)preply, 65 
> /*seconds*/, sleepFlag);
>  
> -	dinitprintk((KERN_WARNING MYNAM "FW Upload completed 
> rc=%x \n", ii));
> +	dinitprintk((KERN_INFO MYNAM ": FW Upload completed 
> rc=%x \n", ii));
>  
>  	cmdStatus = -EFAULT;
>  	if (ii == 0) {
> @@ -2627,10 +2626,10 @@
>  				cmdStatus = 0;
>  		}
>  	}
> -	dinitprintk((MYIOC_s_INFO_FMT ": do_upload status %d \n",
> +	dinitprintk((MYIOC_s_INFO_FMT ": do_upload cmdStatus=%d \n",
>  			ioc->name, cmdStatus));
>  
> -	
> +
>  	if (cmdStatus) {
>  
>  		ddlprintk((MYIOC_s_INFO_FMT ": fw upload 
> failed, freeing image \n",
> @@ -2761,8 +2760,8 @@
>  		fwSize = (pExtImage->ImageSize + 3) >> 2;
>  		ptrFw = (u32 *)pExtImage;
>  
> -		ddlprintk((MYIOC_s_INFO_FMT "Write Ext Image: 
> 0x%x bytes @ %p load_addr=%x\n",
> -						ioc->name, 
> fwSize*4, ptrFw, load_addr));
> +		ddlprintk((MYIOC_s_INFO_FMT "Write Ext Image: 
> 0x%x (%d) bytes @ %p load_addr=%x\n",
> +						ioc->name, 
> fwSize*4, fwSize*4, ptrFw, load_addr));
>  		
> CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwAddress, load_addr);
>  
>  		while (fwSize--) {
> @@ -2845,9 +2844,9 @@
>   *			  0 else
>   *
>   *	Returns:
> - *		 1 - hard reset, READY	
> - *		 0 - no reset due to History bit, READY	
> - *		-1 - no reset due to History bit but not READY	
> + *		 1 - hard reset, READY
> + *		 0 - no reset due to History bit, READY
> + *		-1 - no reset due to History bit but not READY
>   *		     OR reset but failed to come READY
>   *		-2 - no reset, could not enter DIAG mode
>   *		-3 - reset but bad FW bit
> @@ -2990,7 +2989,7 @@
>  		 *
>  		 */
>  		CHIPREG_WRITE32(&ioc->chip->Diagnostic, 
> diag0val | MPI_DIAG_DISABLE_ARM);
> -		mdelay (1);
> +		mdelay(1);
>  
>  		/*
>  		 * Now hit the reset bit in the Diagnostic register
> @@ -3170,7 +3169,7 @@
>  	u32 state;
>  	int cntdn, count;
>  
> -	drsprintk((KERN_WARNING MYNAM ": %s: Sending IOC 
> reset(0x%02x)!\n",
> +	drsprintk((KERN_INFO MYNAM ": %s: Sending IOC reset(0x%02x)!\n",
>  			ioc->name, reset_type));
>  	CHIPREG_WRITE32(&ioc->chip->Doorbell, 
> reset_type<<MPI_DOORBELL_FUNCTION_SHIFT);
>  	if ((r = WaitForDoorbellAck(ioc, 5, sleepFlag)) < 0)
> @@ -3374,6 +3373,9 @@
>  		ioc->reply_frames = (MPT_FRAME_HDR *) mem;
>  		ioc->reply_frames_low_dma = (u32) (alloc_dma & 
> 0xFFFFFFFF);
>  
> +		dinitprintk((KERN_INFO MYNAM ": %s ReplyBuffers 
> @ %p[%p]\n",
> +	 		ioc->name, ioc->reply_frames, (void 
> *)(ulong)alloc_dma));
> +
>  		alloc_dma += reply_sz;
>  		mem += reply_sz;
>  
> @@ -3382,7 +3384,7 @@
>  		ioc->req_frames = (MPT_FRAME_HDR *) mem;
>  		ioc->req_frames_dma = alloc_dma;
>  
> -		dinitprintk((KERN_INFO MYNAM ": 
> %s.RequestBuffers @ %p[%p]\n",
> +		dinitprintk((KERN_INFO MYNAM ": %s 
> RequestBuffers @ %p[%p]\n",
>  			 	ioc->name, mem, (void 
> *)(ulong)alloc_dma));
>  
>  		ioc->req_frames_low_dma = (u32) (alloc_dma & 
> 0xFFFFFFFF);
> @@ -3408,7 +3410,7 @@
>  		ioc->ChainBuffer = mem;
>  		ioc->ChainBufferDMA = alloc_dma;
>  
> -		dinitprintk((KERN_INFO MYNAM " :%s.ChainBuffers 
> @ %p(%p)\n",
> +		dinitprintk((KERN_INFO MYNAM " :%s ChainBuffers 
> @ %p(%p)\n",
>  			ioc->name, ioc->ChainBuffer, (void 
> *)(ulong)ioc->ChainBufferDMA));
>  
>  		/* Initialize the free chain Q.
> @@ -3513,7 +3515,7 @@
>   */
>  static int
>  mpt_handshake_req_reply_wait(MPT_ADAPTER *ioc, int reqBytes, 
> u32 *req,
> -				int replyBytes, u16 *u16reply, 
> int maxwait, int sleepFlag)
> +		int replyBytes, u16 *u16reply, int maxwait, int 
> sleepFlag)
>  {
>  	MPIDefaultReply_t *mptReply;
>  	int failcnt = 0;
> @@ -3588,7 +3590,7 @@
>  		 */
>  		if (!failcnt && (t = WaitForDoorbellReply(ioc, 
> maxwait, sleepFlag)) < 0)
>  			failcnt++;
> -		
> +
>  		dhsprintk((MYIOC_s_INFO_FMT "HandShake reply 
> count=%d%s\n",
>  				ioc->name, t, failcnt ? " - 
> MISSING DOORBELL REPLY!" : ""));
>  
> @@ -3747,7 +3749,7 @@
>  	}
>  
>  	dhsprintk((MYIOC_s_INFO_FMT "WaitCnt=%d First handshake 
> reply word=%08x%s\n",
> -			ioc->name, t, le32_to_cpu(*(u32 *)hs_reply), 
> +			ioc->name, t, le32_to_cpu(*(u32 *)hs_reply),
>  			failcnt ? " - MISSING DOORBELL 
> HANDSHAKE!" : ""));
>  
>  	/*
> @@ -4122,6 +4124,8 @@
>  				ioc->spi_data.minSyncFactor = MPT_ASYNC;
>  				ioc->spi_data.busType = 
> MPT_HOST_BUS_UNKNOWN;
>  				rc = 1;
> +				ddvprintk((MYIOC_s_INFO_FMT 
> "Unable to read PortPage0 minSyncFactor=%x\n",
> +					ioc->name, 
> ioc->spi_data.minSyncFactor));
>  			} else {
>  				/* Save the Port Page 0 data
>  				 */
> @@ -4131,7 +4135,7 @@
>  
>  				if ( (pPP0->Capabilities & 
> MPI_SCSIPORTPAGE0_CAP_QAS) == 0 ) {
>  					ioc->spi_data.noQas |= 
> MPT_TARGET_NO_NEGO_QAS;
> -					dinitprintk((KERN_INFO 
> MYNAM " :%s noQas due to Capabilities=%x\n",
> +					ddvprintk((KERN_INFO 
> MYNAM " :%s noQas due to Capabilities=%x\n",
>  						ioc->name, 
> pPP0->Capabilities));
>  				}
>  				ioc->spi_data.maxBusWidth = 
> pPP0->Capabilities & MPI_SCSIPORTPAGE0_CAP_WIDE ? 1 : 0;
> @@ -4140,6 +4144,8 @@
>  					
> ioc->spi_data.maxSyncOffset = (u8) (data >> 16);
>  					data = 
> pPP0->Capabilities & MPI_SCSIPORTPAGE0_CAP_MIN_SYNC_PERIOD_MASK;
>  					
> ioc->spi_data.minSyncFactor = (u8) (data >> 8);
> +					
> ddvprintk((MYIOC_s_INFO_FMT "PortPage0 minSyncFactor=%x\n",
> +						ioc->name, 
> ioc->spi_data.minSyncFactor));
>  				} else {
>  					ioc->spi_data.maxSyncOffset = 0;
>  					
> ioc->spi_data.minSyncFactor = MPT_ASYNC;
> @@ -4152,8 +4158,11 @@
>  				if ((ioc->spi_data.busType == 
> MPI_SCSIPORTPAGE0_PHY_SIGNAL_HVD) ||
>  					(ioc->spi_data.busType 
> == MPI_SCSIPORTPAGE0_PHY_SIGNAL_SE))  {
>  
> -				if (ioc->spi_data.minSyncFactor 
> < MPT_ULTRA)
> +					if 
> (ioc->spi_data.minSyncFactor < MPT_ULTRA) {
>  						
> ioc->spi_data.minSyncFactor = MPT_ULTRA;
> +						
> ddvprintk((MYIOC_s_INFO_FMT "HVD or SE detected, minSyncFactor=%x\n",
> +							
> ioc->name, ioc->spi_data.minSyncFactor));
> +					}
>  				}
>  			}
>  			if (pbuf) {
> @@ -4580,13 +4589,13 @@
>  
>  	evnp = (EventNotification_t *) 
> mpt_get_msg_frame(mpt_base_index, ioc);
>  	if (evnp == NULL) {
> -		dprintk((MYIOC_s_WARN_FMT "Unable to allocate 
> event request frame!\n",
> +		devtprintk((MYIOC_s_WARN_FMT "Unable to 
> allocate event request frame!\n",
>  				ioc->name));
>  		return 0;
>  	}
>  	memset(evnp, 0, sizeof(*evnp));
>  
> -	dprintk((MYIOC_s_INFO_FMT "Sending 
> EventNotification(%d)\n", ioc->name, EvSwitch));
> +	devtprintk((MYIOC_s_INFO_FMT "Sending EventNotification 
> (%d) request %p\n", ioc->name, EvSwitch, evnp));
>  
>  	evnp->Function = MPI_FUNCTION_EVENT_NOTIFICATION;
>  	evnp->ChainOffset = 0;
> @@ -4610,8 +4619,10 @@
>  	EventAck_t	*pAck;
>  
>  	if ((pAck = (EventAck_t *) 
> mpt_get_msg_frame(mpt_base_index, ioc)) == NULL) {
> -		printk(MYIOC_s_WARN_FMT "Unable to allocate 
> event ACK request frame!\n",
> -				ioc->name);
> +		printk(MYIOC_s_WARN_FMT "Unable to allocate event ACK "
> +			"request frame for Event=%x 
> EventContext=%x EventData=%x!\n",
> +			ioc->name, evnp->Event, 
> le32_to_cpu(evnp->EventContext),
> +			le32_to_cpu(evnp->Data[0]));
>  		return -1;
>  	}
>  	memset(pAck, 0, sizeof(*pAck));
> @@ -5504,6 +5515,8 @@
>  	 *  If needed, send (a single) EventAck.
>  	 */
>  	if (pEventReply->AckRequired == 
> MPI_EVENT_NOTIFICATION_ACK_REQUIRED) {
> +		devtprintk((MYIOC_s_WARN_FMT
> +			"EventAck required\n",ioc->name));
>  		if ((ii = SendEventAck(ioc, pEventReply)) != 0) {
>  			devtprintk((MYIOC_s_WARN_FMT 
> "SendEventAck returned %d\n",
>  					ioc->name, ii));
> @@ -5584,7 +5597,7 @@
>  	case 0x00080000:
>  		desc = "Outbound DMA Overrun";
>  		break;
> -	
> +
>  	case 0x00090000:
>  		desc = "Task Management";
>  		break;
> @@ -5600,7 +5613,7 @@
>  	case 0x000C0000:
>  		desc = "Untagged Table Size";
>  		break;
> -	
> +
>  	}
>  
>  	printk(MYIOC_s_INFO_FMT "LogInfo(0x%08x): F/W: %s\n", 
> ioc->name, log_info, desc);
> @@ -5692,7 +5705,7 @@
>  		break;
>  
>  	case MPI_IOCSTATUS_SCSI_DATA_UNDERRUN: /* 0x0045 */
> -		/* This error is checked in scsi_io_done(). Skip. 
> +		/* This error is checked in scsi_io_done(). Skip.
>  		desc = "SCSI Data Underrun";
>  		*/
>  		break;
> Index: scsi-misc-2.6/drivers/message/fusion/mptscsih.c
> ===================================================================
> --- scsi-misc-2.6.orig/drivers/message/fusion/mptscsih.c	
> 2005-08-17 19:46:11.000000000 +0200
> +++ scsi-misc-2.6/drivers/message/fusion/mptscsih.c	
> 2005-08-17 21:22:03.000000000 +0200
> @@ -281,12 +281,12 @@
>  		offset = (u8 *)chainBuf - (u8 *)ioc->ChainBuffer;
>  		chain_idx = offset / ioc->req_sz;
>  		rc = SUCCESS;
> -		dsgprintk((MYIOC_s_INFO_FMT "getFreeChainBuffer 
> (index %d), got buf=%p\n",
> -			ioc->name, *retIndex, chainBuf));
> +		dsgprintk((MYIOC_s_ERR_FMT "getFreeChainBuffer 
> chainBuf=%p ChainBuffer=%p offset=%d chain_idx=%d\n",
> +			ioc->name, chainBuf, ioc->ChainBuffer, 
> offset, chain_idx));
>  	} else {
>  		rc = FAILED;
>  		chain_idx = MPT_HOST_NO_CHAIN;
> -		dfailprintk((MYIOC_s_ERR_FMT 
> "getFreeChainBuffer failed\n",
> +		dfailprintk((MYIOC_s_INFO_FMT 
> "getFreeChainBuffer failed\n",
>  			ioc->name));
>  	}
>  	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
> @@ -432,7 +432,7 @@
>  			 */
>  			pReq->ChainOffset = 0;
>  			RequestNB = (((sgeOffset - 1) >> 
> ioc->NBShiftFactor)  + 1) & 0x03;
> -			dsgprintk((MYIOC_s_ERR_FMT 
> +			dsgprintk((MYIOC_s_INFO_FMT
>  			    "Single Buffer RequestNB=%x, 
> sgeOffset=%d\n", ioc->name, RequestNB, sgeOffset));
>  			ioc->RequestNB[req_idx] = RequestNB;
>  		}
> @@ -491,11 +491,12 @@
>  		/* NOTE: psge points to the beginning of the 
> chain element
>  		 * in current buffer. Get a chain buffer.
>  		 */
> -		dsgprintk((MYIOC_s_INFO_FMT 
> -		    "calling getFreeChainBuffer SCSI cmd=%02x (%p)\n",
> -		    ioc->name, pReq->CDB[0], SCpnt));
> -		if ((mptscsih_getFreeChainBuffer(ioc, 
> &newIndex)) == FAILED)
> +		if ((mptscsih_getFreeChainBuffer(ioc, 
> &newIndex)) == FAILED) {
> +			dfailprintk((MYIOC_s_INFO_FMT
> +			    "getFreeChainBuffer FAILED SCSI 
> cmd=%02x (%p)\n",
> + 			    ioc->name, pReq->CDB[0], SCpnt));
>  			return FAILED;
> +		}
>  
>  		/* Update the tracking arrays.
>  		 * If chainSge == NULL, update ReqToChain, else 
> ChainToChain
> @@ -577,14 +578,20 @@
>  		return 1;
>  	}
>  
> -	dmfprintk((MYIOC_s_INFO_FMT
> -		"ScsiDone (mf=%p,mr=%p,sc=%p,idx=%d)\n",
> -		ioc->name, mf, mr, sc, req_idx));
> -
>  	sc->result = DID_OK << 16;		/* Set default 
> reply as OK */
>  	pScsiReq = (SCSIIORequest_t *) mf;
>  	pScsiReply = (SCSIIOReply_t *) mr;
>  
> +	if((ioc->facts.MsgVersion >= MPI_VERSION_01_05) && pScsiReply){
> +		dmfprintk((MYIOC_s_INFO_FMT
> +			"ScsiDone 
> (mf=%p,mr=%p,sc=%p,idx=%d,task-tag=%d)\n",
> +			ioc->name, mf, mr, sc, req_idx, 
> pScsiReply->TaskTag));
> +	}else{
> +		dmfprintk((MYIOC_s_INFO_FMT
> +			"ScsiDone (mf=%p,mr=%p,sc=%p,idx=%d)\n",
> +			ioc->name, mf, mr, sc, req_idx));
> +	}
> +
>  	if (pScsiReply == NULL) {
>  		/* special context reply handling */
>  		;
> @@ -658,8 +665,8 @@
>  				/* Sufficient data transfer occurred */
>  				sc->result = (DID_OK << 16) | 
> scsi_status;
>  			} else if ( xfer_cnt == 0 ) {
> -				/* A CRC Error causes this 
> condition; retry */ 
> -				sc->result = (DRIVER_SENSE << 
> 24) | (DID_OK << 16) | 
> +				/* A CRC Error causes this 
> condition; retry */
> +				sc->result = (DRIVER_SENSE << 
> 24) | (DID_OK << 16) |
>  					(CHECK_CONDITION << 1);
>  				sc->sense_buffer[0] = 0x70;
>  				sc->sense_buffer[2] = NO_SENSE;
> @@ -668,7 +675,9 @@
>  			} else {
>  				sc->result = DID_SOFT_ERROR << 16;
>  			}
> -			dreplyprintk((KERN_NOTICE 
> "RESIDUAL_MISMATCH: result=%x on id=%d\n", sc->result, sc->target));
> +			dreplyprintk((KERN_NOTICE
> +			    "RESIDUAL_MISMATCH: result=%x on id=%d\n",
> +			    sc->result, sc->device->id));
>  			break;
>  
>  		case MPI_IOCSTATUS_SCSI_DATA_UNDERRUN:		
> /* 0x0045 */
> @@ -796,7 +805,6 @@
>  	return 1;
>  }
>  
> -
>  /*
>   *	mptscsih_flush_running_cmds - For each command found, search
>   *		Scsi_Host instance taskQ and reply to OS.
> @@ -1017,7 +1025,7 @@
>  	scsi_host_put(host);
>  
>  	mpt_detach(pdev);
> -	
> +
>  }
>  
>  
> /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
> =-=-=-=-=-=-=-=*/
> @@ -1072,7 +1080,7 @@
>  	MPT_SCSI_HOST		*hd;
>  
>  	mpt_resume(pdev);
> -	
> +
>  	if(!host)
>  		return 0;
>  
> @@ -1214,8 +1222,8 @@
>  	int size = 0;
>  
>  	if (func) {
> -		/* 
> -		 * write is not supported 
> +		/*
> +		 * write is not supported
>  		 */
>  	} else {
>  		if (start)
> @@ -1535,17 +1543,17 @@
>  	 */
>  	if (mptscsih_tm_pending_wait(hd) == FAILED) {
>  		if (type == MPI_SCSITASKMGMT_TASKTYPE_ABORT_TASK) {
> -			dtmprintk((KERN_WARNING MYNAM ": %s: 
> TMHandler abort: "
> +			dtmprintk((KERN_INFO MYNAM ": %s: 
> TMHandler abort: "
>  			   "Timed out waiting for last TM (%d) 
> to complete! \n",
>  			   hd->ioc->name, hd->tmPending));
>  			return FAILED;
>  		} else if (type == 
> MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET) {
> -			dtmprintk((KERN_WARNING MYNAM ": %s: 
> TMHandler target reset: "
> +			dtmprintk((KERN_INFO MYNAM ": %s: 
> TMHandler target reset: "
>  			   "Timed out waiting for last TM (%d) 
> to complete! \n",
>  			   hd->ioc->name, hd->tmPending));
>  			return FAILED;
>  		} else if (type == 
> MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS) {
> -			dtmprintk((KERN_WARNING MYNAM ": %s: 
> TMHandler bus reset: "
> +			dtmprintk((KERN_INFO MYNAM ": %s: 
> TMHandler bus reset: "
>  			   "Timed out waiting for last TM (%d) 
> to complete! \n",
>  			   hd->ioc->name, hd->tmPending));
>  			if (hd->tmPending & (1 << 
> MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS))
> @@ -1631,8 +1639,7 @@
>  	if ((mf = mpt_get_msg_frame(hd->ioc->TaskCtx, hd->ioc)) 
> == NULL) {
>  		dfailprintk((MYIOC_s_ERR_FMT "IssueTaskMgmt, no 
> msg frames!!\n",
>  				hd->ioc->name));
> -		//return FAILED;
> -		return -999;
> +		return FAILED;
>  	}
>  	dtmprintk((MYIOC_s_INFO_FMT "IssueTaskMgmt request @ %p\n",
>  			hd->ioc->name, mf));
> @@ -1661,9 +1668,8 @@
>  
>  	pScsiTm->TaskMsgContext = ctx2abort;
>  
> -	dtmprintk((MYIOC_s_INFO_FMT
> -		"IssueTaskMgmt: ctx2abort (0x%08x) type=%d\n",
> -		hd->ioc->name, ctx2abort, type));
> +	dtmprintk((MYIOC_s_INFO_FMT "IssueTaskMgmt: ctx2abort 
> (0x%08x) type=%d\n",
> +			hd->ioc->name, ctx2abort, type));
>  
>  	DBG_DUMP_TM_REQUEST_FRAME((u32 *)pScsiTm);
>  
> @@ -1902,13 +1908,13 @@
>  
>  	/*  If we can't locate the host to reset, then we failed. */
>  	if ((hd = (MPT_SCSI_HOST *) 
> SCpnt->device->host->hostdata) == NULL){
> -		dtmprintk( ( KERN_WARNING MYNAM ": 
> mptscsih_host_reset: "
> +		dtmprintk( ( KERN_INFO MYNAM ": mptscsih_host_reset: "
>  			     "Can't locate host! (sc=%p)\n",
>  			     SCpnt ) );
>  		return FAILED;
>  	}
>  
> -	printk(KERN_WARNING MYNAM ": %s: >> Attempting host 
> reset! (sc=%p)\n",
> +	printk(KERN_WARNING MYNAM ": %s: Attempting host reset! 
> (sc=%p)\n",
>  	       hd->ioc->name, SCpnt);
>  
>  	/*  If our attempts to reset the host failed, then 
> return a failed
> @@ -1924,7 +1930,7 @@
>  		hd->tmState = TM_STATE_NONE;
>  	}
>  
> -	dtmprintk( ( KERN_WARNING MYNAM ": mptscsih_host_reset: "
> +	dtmprintk( ( KERN_INFO MYNAM ": mptscsih_host_reset: "
>  		     "Status = %s\n",
>  		     (status == SUCCESS) ? "SUCCESS" : "FAILED" ) );
>  
> @@ -1951,8 +1957,8 @@
>  		if (hd->tmState == TM_STATE_NONE) {
>  			hd->tmState = TM_STATE_IN_PROGRESS;
>  			hd->tmPending = 1;
> -			status = SUCCESS;
>  			
> spin_unlock_irqrestore(&hd->ioc->FreeQlock, flags);
> +			status = SUCCESS;
>  			break;
>  		}
>  		spin_unlock_irqrestore(&hd->ioc->FreeQlock, flags);
> @@ -1980,7 +1986,7 @@
>  		spin_lock_irqsave(&hd->ioc->FreeQlock, flags);
>  		if(hd->tmPending == 0) {
>  			status = SUCCESS;
> -			
> spin_unlock_irqrestore(&hd->ioc->FreeQlock, flags);
> + 			
> spin_unlock_irqrestore(&hd->ioc->FreeQlock, flags);
>  			break;
>  		}
>  		spin_unlock_irqrestore(&hd->ioc->FreeQlock, flags);
> @@ -2318,10 +2324,10 @@
>  	if (pTarget == NULL) {
>  		/* Driver doesn't know about this device.
>  		 * Kernel may generate a "Dummy Lun 0" which
> -		 * may become a real Lun if a 
> +		 * may become a real Lun if a
>  		 * "scsi add-single-device" command is executed
> -		 * while the driver is active (hot-plug a 
> -		 * device).  LSI Raid controllers need 
> +		 * while the driver is active (hot-plug a
> +		 * device).  LSI Raid controllers need
>  		 * queue_depth set to DEV_HIGH for this reason.
>  		 */
>  		scsi_adjust_queue_depth(device, MSG_SIMPLE_TAG,
> @@ -2691,7 +2697,7 @@
>  	 * If the peripheral qualifier filter is enabled then 
> if the target reports a 0x1
>  	 * (i.e. The targer is capable of supporting the 
> specified peripheral device type
>  	 * on this logical unit; however, the physical device 
> is not currently connected
> -	 * to this logical unit) it will be converted to a 0x3 
> (i.e. The target is not 
> +	 * to this logical unit) it will be converted to a 0x3 
> (i.e. The target is not
>  	 * capable of supporting a physical device on this 
> logical unit). This is to work
>  	 * around a bug in th emid-layer in some distributions 
> in which the mid-layer will
>  	 * continue to try to communicate to the LUN and 
> evntually create a dummy LUN.
> @@ -3194,8 +3200,8 @@
>  		/* Get a MF for this command.
>  		 */
>  		if ((mf = mpt_get_msg_frame(ioc->DoneCtx, ioc)) 
> == NULL) {
> -			dprintk((MYIOC_s_WARN_FMT "write SDP1: 
> no msg frames!\n",
> -						ioc->name));
> +			dfailprintk((MYIOC_s_WARN_FMT "write 
> SDP1: no msg frames!\n",
> +				ioc->name));
>  			return -EAGAIN;
>  		}
>  
> @@ -3289,7 +3295,7 @@
>  	/* Get a MF for this command.
>  	 */
>  	if ((mf = mpt_get_msg_frame(ioc->DoneCtx, ioc)) == NULL) {
> -		dprintk((MYIOC_s_WARN_FMT "writeIOCPage4 : no 
> msg frames!\n",
> +		dfailprintk((MYIOC_s_WARN_FMT "writeIOCPage4 : 
> no msg frames!\n",
>  					ioc->name));
>  		return -EAGAIN;
>  	}
> @@ -4596,8 +4602,8 @@
>  				if ((pbuf1[56] & 0x02) == 0) {
>  					pTarget->negoFlags |= 
> MPT_TARGET_NO_NEGO_QAS;
>  					hd->ioc->spi_data.noQas 
> = MPT_TARGET_NO_NEGO_QAS;
> -					ddvprintk((MYIOC_s_NOTE_FMT 
> -					    "DV: Start Basic 
> noQas on id=%d due to pbuf1[56]=%x\n", 
> +					ddvprintk((MYIOC_s_NOTE_FMT
> +					    "DV: Start Basic 
> noQas on id=%d due to pbuf1[56]=%x\n",
>  					    ioc->name, id, pbuf1[56]));
>  				}
>  			}
> @@ -4673,7 +4679,7 @@
>  						if (!firstPass)
>  							doFallback = 1;
>  					} else {
> -						
> ddvprintk((MYIOC_s_NOTE_FMT 
> +						
> ddvprintk((MYIOC_s_NOTE_FMT
>  						    "DV:Inquiry 
> compared id=%d, calling initTarget\n", ioc->name, id));
>  						
> hd->ioc->spi_data.dvStatus[id] &= ~MPT_SCSICFG_DV_NOT_DONE;
>  						mptscsih_initTarget(hd,
> @@ -4689,8 +4695,8 @@
>  
>  			} else if (rc == MPT_SCANDV_ISSUE_SENSE)
>  				doFallback = 1;	/* set fallback flag */
> -			else if ((rc == MPT_SCANDV_DID_RESET) || 
> -				 (rc == MPT_SCANDV_SENSE) || 
> +			else if ((rc == MPT_SCANDV_DID_RESET) ||
> +				 (rc == MPT_SCANDV_SENSE) ||
>  				 (rc == MPT_SCANDV_FALLBACK))
>  				doFallback = 1;	/* set fallback flag */
>  			else
> @@ -5126,7 +5132,7 @@
>  		 */
>  		if ((inq0 == 0) && (dv.now.factor > MPT_ULTRA320)) {
>  			hd->ioc->spi_data.noQas = 
> MPT_TARGET_NO_NEGO_QAS;
> -			ddvprintk((MYIOC_s_NOTE_FMT 
> +			ddvprintk((MYIOC_s_NOTE_FMT
>  			    "noQas set due to id=%d has 
> factor=%x\n", ioc->name, id, dv.now.factor));
>  		}
>  
> 
