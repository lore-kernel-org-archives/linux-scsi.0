From: Michael Reed <mdr@sgi.com>
Subject: [REPOST][PATCH 2/6] mpt fusion - move fc event/reset handling to
 mptfc
Date: Thu, 18 May 2006 17:14:44 -0500
Message-ID: <446CF1D4.9010505@sgi.com>
References: <446CD233.70508@sgi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020405060306030409020103"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:36298 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1750764AbWERWOq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 May 2006 18:14:46 -0400
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [192.26.80.2])
	by omx2.sgi.com (8.12.11/8.12.9/linux-outbound_gateway-1.1) with ESMTP id k4J0WXqJ023063
	for <linux-scsi@vger.kernel.org>; Thu, 18 May 2006 17:32:34 -0700
In-Reply-To: <446CD233.70508@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------020405060306030409020103
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This patch has been respun to take into account James Bottomley's
version of the fix to the fusion reset handlers.  This patch
replaces the previous patch.

http://marc.theaimsgroup.com/?l=linux-scsi&m=114790729315904&w=2

Aside from line number changes, there is a one line difference between
the two patches.  The test for bus_type is no longer required with the
application of James' fix.

> --- rc4u/drivers/message/fusion/mptfc.c       2006-05-18 16:31:32.389384812 -0500
> +++ rc4/drivers/message/fusion/mptfc.c        2006-05-18 16:32:50.941453888 -0500
349c349
< +     if (rc == 0 || ioc->bus_type != FC)
---
> +     if (rc == 0)

Only patches two and five in the sequence required change.

Signed-off-by: Michael Reed <mdr@sgi.com>


Michael Reed wrote:
> Move fibre channel event and reset handling to mptfc.  This will
> result in fewer changes over time that need to be applied to
> either mptbase.c or mptscsih.c.
> 
> Signed-off-by: Michael Reed <mdr@sgi.com>
> 
> 
> 
> 
> 
> ------------------------------------------------------------------------
> 
> Move fibre channel event and reset handling to mptfc.  This will
> result in fewer changes over time that need to be applied to
> either mptbase.c or mptscsih.c.
> 
> Signed-off-by: Michael Reed <mdr@sgi.com>
> 
> 
> --- rc3c/drivers/message/fusion/mptbase.c	2006-05-04 14:17:05.679710768 -0500
> +++ rc3/drivers/message/fusion/mptbase.c	2006-05-04 14:17:25.014432823 -0500
> @@ -1188,7 +1188,6 @@
>  	ioc->pcidev = pdev;
>  	ioc->diagPending = 0;
>  	spin_lock_init(&ioc->diagLock);
> -	spin_lock_init(&ioc->fc_rescan_work_lock);
>  	spin_lock_init(&ioc->initializing_hba_lock);
>  
>  	/* Initialize the event logging.
> @@ -1826,14 +1825,6 @@
>  			mpt_findImVolumes(ioc);
>  
>  		} else if (ioc->bus_type == FC) {
> -			/*
> -			 *  Pre-fetch FC port WWN and stuff...
> -			 *  (FCPortPage0_t stuff)
> -			 */
> -			for (ii=0; ii < ioc->facts.NumberOfPorts; ii++) {
> -				(void) mptbase_GetFcPortPage0(ioc, ii);
> -			}
> -
>  			if ((ioc->pfacts[0].ProtocolFlags & MPI_PORTFACTS_PROTOCOL_LAN) &&
>  			    (ioc->lan_cnfg_page0.Header.PageLength == 0)) {
>  				/*
> @@ -4159,108 +4150,6 @@
>  
>  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
>  /*
> - *	mptbase_GetFcPortPage0 - Fetch FCPort config Page0.
> - *	@ioc: Pointer to MPT_ADAPTER structure
> - *	@portnum: IOC Port number
> - *
> - *	Return: 0 for success
> - *	-ENOMEM if no memory available
> - *		-EPERM if not allowed due to ISR context
> - *		-EAGAIN if no msg frames currently available
> - *		-EFAULT for non-successful reply or no reply (timeout)
> - */
> -int
> -mptbase_GetFcPortPage0(MPT_ADAPTER *ioc, int portnum)
> -{
> -	ConfigPageHeader_t	 hdr;
> -	CONFIGPARMS		 cfg;
> -	FCPortPage0_t		*ppage0_alloc;
> -	FCPortPage0_t		*pp0dest;
> -	dma_addr_t		 page0_dma;
> -	int			 data_sz;
> -	int			 copy_sz;
> -	int			 rc;
> -	int			 count = 400;
> -
> -
> -	/* Get FCPort Page 0 header */
> -	hdr.PageVersion = 0;
> -	hdr.PageLength = 0;
> -	hdr.PageNumber = 0;
> -	hdr.PageType = MPI_CONFIG_PAGETYPE_FC_PORT;
> -	cfg.cfghdr.hdr = &hdr;
> -	cfg.physAddr = -1;
> -	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
> -	cfg.dir = 0;
> -	cfg.pageAddr = portnum;
> -	cfg.timeout = 0;
> -
> -	if ((rc = mpt_config(ioc, &cfg)) != 0)
> -		return rc;
> -
> -	if (hdr.PageLength == 0)
> -		return 0;
> -
> -	data_sz = hdr.PageLength * 4;
> -	rc = -ENOMEM;
> -	ppage0_alloc = (FCPortPage0_t *) pci_alloc_consistent(ioc->pcidev, data_sz, &page0_dma);
> -	if (ppage0_alloc) {
> -
> - try_again:
> -		memset((u8 *)ppage0_alloc, 0, data_sz);
> -		cfg.physAddr = page0_dma;
> -		cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
> -
> -		if ((rc = mpt_config(ioc, &cfg)) == 0) {
> -			/* save the data */
> -			pp0dest = &ioc->fc_port_page0[portnum];
> -			copy_sz = min_t(int, sizeof(FCPortPage0_t), data_sz);
> -			memcpy(pp0dest, ppage0_alloc, copy_sz);
> -
> -			/*
> -			 *	Normalize endianness of structure data,
> -			 *	by byte-swapping all > 1 byte fields!
> -			 */
> -			pp0dest->Flags = le32_to_cpu(pp0dest->Flags);
> -			pp0dest->PortIdentifier = le32_to_cpu(pp0dest->PortIdentifier);
> -			pp0dest->WWNN.Low = le32_to_cpu(pp0dest->WWNN.Low);
> -			pp0dest->WWNN.High = le32_to_cpu(pp0dest->WWNN.High);
> -			pp0dest->WWPN.Low = le32_to_cpu(pp0dest->WWPN.Low);
> -			pp0dest->WWPN.High = le32_to_cpu(pp0dest->WWPN.High);
> -			pp0dest->SupportedServiceClass = le32_to_cpu(pp0dest->SupportedServiceClass);
> -			pp0dest->SupportedSpeeds = le32_to_cpu(pp0dest->SupportedSpeeds);
> -			pp0dest->CurrentSpeed = le32_to_cpu(pp0dest->CurrentSpeed);
> -			pp0dest->MaxFrameSize = le32_to_cpu(pp0dest->MaxFrameSize);
> -			pp0dest->FabricWWNN.Low = le32_to_cpu(pp0dest->FabricWWNN.Low);
> -			pp0dest->FabricWWNN.High = le32_to_cpu(pp0dest->FabricWWNN.High);
> -			pp0dest->FabricWWPN.Low = le32_to_cpu(pp0dest->FabricWWPN.Low);
> -			pp0dest->FabricWWPN.High = le32_to_cpu(pp0dest->FabricWWPN.High);
> -			pp0dest->DiscoveredPortsCount = le32_to_cpu(pp0dest->DiscoveredPortsCount);
> -			pp0dest->MaxInitiators = le32_to_cpu(pp0dest->MaxInitiators);
> -
> -			/*
> -			 * if still doing discovery,
> -			 * hang loose a while until finished
> -			 */
> -			if (pp0dest->PortState == MPI_FCPORTPAGE0_PORTSTATE_UNKNOWN) {
> -				if (count-- > 0) {
> -					msleep_interruptible(100);
> -					goto try_again;
> -				}
> -				printk(MYIOC_s_INFO_FMT "Firmware discovery not"
> -							" complete.\n",
> -						ioc->name);
> -			}
> -		}
> -
> -		pci_free_consistent(ioc->pcidev, data_sz, (u8 *) ppage0_alloc, page0_dma);
> -	}
> -
> -	return rc;
> -}
> -
> -/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
> -/*
>   *	mptbase_sas_persist_operation - Perform operation on SAS Persitent Table
>   *	@ioc: Pointer to MPT_ADAPTER structure
>   *	@sas_address: 64bit SAS Address for operation.
> @@ -6468,7 +6357,6 @@
>  EXPORT_SYMBOL(mpt_alloc_fw_memory);
>  EXPORT_SYMBOL(mpt_free_fw_memory);
>  EXPORT_SYMBOL(mptbase_sas_persist_operation);
> -EXPORT_SYMBOL(mptbase_GetFcPortPage0);
>  
>  
>  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
> --- rc3c/drivers/message/fusion/mptbase.h	2006-05-04 14:17:05.683710503 -0500
> +++ rc3/drivers/message/fusion/mptbase.h	2006-05-04 14:17:42.437284760 -0500
> @@ -1027,7 +1027,6 @@
>  extern void	 mpt_free_fw_memory(MPT_ADAPTER *ioc);
>  extern int	 mpt_findImVolumes(MPT_ADAPTER *ioc);
>  extern int	 mptbase_sas_persist_operation(MPT_ADAPTER *ioc, u8 persist_opcode);
> -extern int	 mptbase_GetFcPortPage0(MPT_ADAPTER *ioc, int portnum);
>  
>  /*
>   *  Public data decl's...
> --- rc3c/drivers/message/fusion/mptfc.c	2006-05-04 14:17:05.683710503 -0500
> +++ rc3/drivers/message/fusion/mptfc.c	2006-05-04 14:17:25.018432559 -0500
> @@ -596,6 +596,110 @@
>  	return err;
>  }
>  
> +/*
> + *	mptfc_GetFcPortPage0 - Fetch FCPort config Page0.
> + *	@ioc: Pointer to MPT_ADAPTER structure
> + *	@portnum: IOC Port number
> + *
> + *	Return: 0 for success
> + *	-ENOMEM if no memory available
> + *		-EPERM if not allowed due to ISR context
> + *		-EAGAIN if no msg frames currently available
> + *		-EFAULT for non-successful reply or no reply (timeout)
> + *		-EINVAL portnum arg out of range (hardwired to two elements)
> + */
> +static int
> +mptfc_GetFcPortPage0(MPT_ADAPTER *ioc, int portnum)
> +{
> +	ConfigPageHeader_t	 hdr;
> +	CONFIGPARMS		 cfg;
> +	FCPortPage0_t		*ppage0_alloc;
> +	FCPortPage0_t		*pp0dest;
> +	dma_addr_t		 page0_dma;
> +	int			 data_sz;
> +	int			 copy_sz;
> +	int			 rc;
> +	int			 count = 400;
> +
> +	if (portnum > 1)
> +		return -EINVAL;
> +
> +	/* Get FCPort Page 0 header */
> +	hdr.PageVersion = 0;
> +	hdr.PageLength = 0;
> +	hdr.PageNumber = 0;
> +	hdr.PageType = MPI_CONFIG_PAGETYPE_FC_PORT;
> +	cfg.cfghdr.hdr = &hdr;
> +	cfg.physAddr = -1;
> +	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
> +	cfg.dir = 0;
> +	cfg.pageAddr = portnum;
> +	cfg.timeout = 0;
> +
> +	if ((rc = mpt_config(ioc, &cfg)) != 0)
> +		return rc;
> +
> +	if (hdr.PageLength == 0)
> +		return 0;
> +
> +	data_sz = hdr.PageLength * 4;
> +	rc = -ENOMEM;
> +	ppage0_alloc = (FCPortPage0_t *) pci_alloc_consistent(ioc->pcidev, data_sz, &page0_dma);
> +	if (ppage0_alloc) {
> +
> + try_again:
> +		memset((u8 *)ppage0_alloc, 0, data_sz);
> +		cfg.physAddr = page0_dma;
> +		cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
> +
> +		if ((rc = mpt_config(ioc, &cfg)) == 0) {
> +			/* save the data */
> +			pp0dest = &ioc->fc_port_page0[portnum];
> +			copy_sz = min_t(int, sizeof(FCPortPage0_t), data_sz);
> +			memcpy(pp0dest, ppage0_alloc, copy_sz);
> +
> +			/*
> +			 *	Normalize endianness of structure data,
> +			 *	by byte-swapping all > 1 byte fields!
> +			 */
> +			pp0dest->Flags = le32_to_cpu(pp0dest->Flags);
> +			pp0dest->PortIdentifier = le32_to_cpu(pp0dest->PortIdentifier);
> +			pp0dest->WWNN.Low = le32_to_cpu(pp0dest->WWNN.Low);
> +			pp0dest->WWNN.High = le32_to_cpu(pp0dest->WWNN.High);
> +			pp0dest->WWPN.Low = le32_to_cpu(pp0dest->WWPN.Low);
> +			pp0dest->WWPN.High = le32_to_cpu(pp0dest->WWPN.High);
> +			pp0dest->SupportedServiceClass = le32_to_cpu(pp0dest->SupportedServiceClass);
> +			pp0dest->SupportedSpeeds = le32_to_cpu(pp0dest->SupportedSpeeds);
> +			pp0dest->CurrentSpeed = le32_to_cpu(pp0dest->CurrentSpeed);
> +			pp0dest->MaxFrameSize = le32_to_cpu(pp0dest->MaxFrameSize);
> +			pp0dest->FabricWWNN.Low = le32_to_cpu(pp0dest->FabricWWNN.Low);
> +			pp0dest->FabricWWNN.High = le32_to_cpu(pp0dest->FabricWWNN.High);
> +			pp0dest->FabricWWPN.Low = le32_to_cpu(pp0dest->FabricWWPN.Low);
> +			pp0dest->FabricWWPN.High = le32_to_cpu(pp0dest->FabricWWPN.High);
> +			pp0dest->DiscoveredPortsCount = le32_to_cpu(pp0dest->DiscoveredPortsCount);
> +			pp0dest->MaxInitiators = le32_to_cpu(pp0dest->MaxInitiators);
> +
> +			/*
> +			 * if still doing discovery,
> +			 * hang loose a while until finished
> +			 */
> +			if (pp0dest->PortState == MPI_FCPORTPAGE0_PORTSTATE_UNKNOWN) {
> +				if (count-- > 0) {
> +					msleep_interruptible(100);
> +					goto try_again;
> +				}
> +				printk(MYIOC_s_INFO_FMT "Firmware discovery not"
> +							" complete.\n",
> +						ioc->name);
> +			}
> +		}
> +
> +		pci_free_consistent(ioc->pcidev, data_sz, (u8 *) ppage0_alloc, page0_dma);
> +	}
> +
> +	return rc;
> +}
> +
>  static void
>  mptfc_init_host_attr(MPT_ADAPTER *ioc,int portnum)
>  {
> @@ -652,7 +756,7 @@
>  		 * will reregister existing rports
>  		 */
>  		for (ii=0; ii < ioc->facts.NumberOfPorts; ii++) {
> -			rc = mptbase_GetFcPortPage0(ioc, ii);
> +			rc = mptfc_GetFcPortPage0(ioc, ii);
>  			if (rc == -EAGAIN)
>  				break;
>  			mptfc_init_host_attr(ioc,ii);	/* refresh */
> @@ -772,6 +876,7 @@
>  		goto out_mptfc_probe;
>          }
>  
> +	spin_lock_init(&ioc->fc_rescan_work_lock);
>  	INIT_WORK(&ioc->fc_rescan_work, mptfc_rescan_devices,(void *)ioc);
>  
>  	spin_lock_irqsave(&ioc->FreeQlock, flags);
> @@ -908,6 +1013,14 @@
>  		goto out_mptfc_probe;
>  
>  	/*
> +	 *  Pre-fetch FC port WWN and stuff...
> +	 *  (FCPortPage0_t stuff)
> +	 */
> +	for (ii=0; ii < ioc->facts.NumberOfPorts; ii++) {
> +		(void) mptfc_GetFcPortPage0(ioc, ii);
> +	}
> +
> +	/*
>  	 * scan for rports -
>  	 *	by doing it via the workqueue, some locking is eliminated
>  	 */
> @@ -936,6 +1049,74 @@
>  #endif
>  };
>  
> +static int
> +mptfc_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply)
> +{
> +	MPT_SCSI_HOST *hd;
> +	u8 event = le32_to_cpu(pEvReply->Event) & 0xFF;
> +	unsigned long flags;
> +	int rc=1;
> +
> +	devtverboseprintk((MYIOC_s_INFO_FMT "MPT event (=%02Xh) routed to SCSI host driver!\n",
> +			ioc->name, event));
> +
> +	if (ioc->sh == NULL ||
> +		((hd = (MPT_SCSI_HOST *)ioc->sh->hostdata) == NULL))
> +		return 1;
> +
> +	switch (event) {
> +	case MPI_EVENT_RESCAN:
> +		spin_lock_irqsave(&ioc->fc_rescan_work_lock, flags);
> +		if (ioc->fc_rescan_work_q) {
> +			if (ioc->fc_rescan_work_count++ == 0) {
> +				queue_work(ioc->fc_rescan_work_q,
> +					   &ioc->fc_rescan_work);
> +			}
> +		}
> +		spin_unlock_irqrestore(&ioc->fc_rescan_work_lock, flags);
> +		break;
> +	default:
> +		rc = mptscsih_event_process(ioc,pEvReply);
> +		break;
> +	}
> +	return rc;
> +}
> +
> +static int
> +mptfc_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
> +{
> +	int		rc;
> +	unsigned long	flags;
> +
> +	rc = mptscsih_ioc_reset(ioc,reset_phase);
> +	if (rc == 0 || ioc->bus_type != FC)
> +		return rc;
> +
> +
> +	dtmprintk((KERN_WARNING MYNAM
> +		": IOC %s_reset routed to FC host driver!\n",
> +		reset_phase==MPT_IOC_SETUP_RESET ? "setup" : (
> +		reset_phase==MPT_IOC_PRE_RESET ? "pre" : "post")));
> +
> +	if (reset_phase == MPT_IOC_SETUP_RESET) {
> +	}
> +
> +	else if (reset_phase == MPT_IOC_PRE_RESET) {
> +	}
> +
> +	else {	/* MPT_IOC_POST_RESET */
> +		spin_lock_irqsave(&ioc->fc_rescan_work_lock, flags);
> +		if (ioc->fc_rescan_work_q) {
> +			if (ioc->fc_rescan_work_count++ == 0) {
> +				queue_work(ioc->fc_rescan_work_q,
> +					   &ioc->fc_rescan_work);
> +			}
> +		}
> +		spin_unlock_irqrestore(&ioc->fc_rescan_work_lock, flags);
> +	}
> +	return 1;
> +}
> +
>  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
>  /**
>   *	mptfc_init - Register MPT adapter(s) as SCSI host(s) with
> @@ -964,12 +1145,12 @@
>  	mptfcTaskCtx = mpt_register(mptscsih_taskmgmt_complete, MPTFC_DRIVER);
>  	mptfcInternalCtx = mpt_register(mptscsih_scandv_complete, MPTFC_DRIVER);
>  
> -	if (mpt_event_register(mptfcDoneCtx, mptscsih_event_process) == 0) {
> +	if (mpt_event_register(mptfcDoneCtx, mptfc_event_process) == 0) {
>  		devtverboseprintk((KERN_INFO MYNAM
>  		  ": Registered for IOC event notifications\n"));
>  	}
>  
> -	if (mpt_reset_register(mptfcDoneCtx, mptscsih_ioc_reset) == 0) {
> +	if (mpt_reset_register(mptfcDoneCtx, mptfc_ioc_reset) == 0) {
>  		dprintk((KERN_INFO MYNAM
>  		  ": Registered for IOC reset notifications\n"));
>  	}
> --- rc3c/drivers/message/fusion/mptscsih.c	2006-05-04 14:17:05.687710238 -0500
> +++ rc3/drivers/message/fusion/mptscsih.c	2006-05-04 14:17:25.018432559 -0500
> @@ -2521,18 +2521,6 @@
>  			hd->cmdPtr = NULL;
>  		}
>  
> -		/* 7. FC: Rescan for blocked rports which might have returned.
> -		 */
> -		if (ioc->bus_type == FC) {
> -			spin_lock_irqsave(&ioc->fc_rescan_work_lock, flags);
> -			if (ioc->fc_rescan_work_q) {
> -				if (ioc->fc_rescan_work_count++ == 0) {
> -					queue_work(ioc->fc_rescan_work_q,
> -						   &ioc->fc_rescan_work);
> -				}
> -			}
> -			spin_unlock_irqrestore(&ioc->fc_rescan_work_lock, flags);
> -		}
>  		dtmprintk((MYIOC_s_WARN_FMT "Post-Reset complete.\n", ioc->name));
>  
>  	}
> @@ -2546,7 +2534,6 @@
>  {
>  	MPT_SCSI_HOST *hd;
>  	u8 event = le32_to_cpu(pEvReply->Event) & 0xFF;
> -	unsigned long flags;
>  
>  	devtverboseprintk((MYIOC_s_INFO_FMT "MPT event (=%02Xh) routed to SCSI host driver!\n",
>  			ioc->name, event));
> @@ -2569,14 +2556,6 @@
>  		break;
>  
>  	case MPI_EVENT_RESCAN:				/* 06 */
> -		spin_lock_irqsave(&ioc->fc_rescan_work_lock, flags);
> -		if (ioc->fc_rescan_work_q) {
> -			if (ioc->fc_rescan_work_count++ == 0) {
> -				queue_work(ioc->fc_rescan_work_q,
> -					   &ioc->fc_rescan_work);
> -			}
> -		}
> -		spin_unlock_irqrestore(&ioc->fc_rescan_work_lock, flags);
>  		break;
>  
>  		/*

--------------020405060306030409020103
Content-Type: text/x-patch;
 name="02-mptfc_event_handler.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02-mptfc_event_handler.patch"

Move fibre channel event and reset handling to mptfc.  This will
result in fewer changes over time that need to be applied to
either mptbase.c or mptscsih.c.

Signed-off-by: Michael Reed <mdr@sgi.com>


--- rc4u/drivers/message/fusion/mptbase.c	2006-05-18 16:27:12.850372609 -0500
+++ rc4/drivers/message/fusion/mptbase.c	2006-05-18 16:32:50.941453888 -0500
@@ -1188,7 +1188,6 @@
 	ioc->pcidev = pdev;
 	ioc->diagPending = 0;
 	spin_lock_init(&ioc->diagLock);
-	spin_lock_init(&ioc->fc_rescan_work_lock);
 	spin_lock_init(&ioc->initializing_hba_lock);
 
 	/* Initialize the event logging.
@@ -1841,14 +1840,6 @@
 			mpt_findImVolumes(ioc);
 
 		} else if (ioc->bus_type == FC) {
-			/*
-			 *  Pre-fetch FC port WWN and stuff...
-			 *  (FCPortPage0_t stuff)
-			 */
-			for (ii=0; ii < ioc->facts.NumberOfPorts; ii++) {
-				(void) mptbase_GetFcPortPage0(ioc, ii);
-			}
-
 			if ((ioc->pfacts[0].ProtocolFlags & MPI_PORTFACTS_PROTOCOL_LAN) &&
 			    (ioc->lan_cnfg_page0.Header.PageLength == 0)) {
 				/*
@@ -4174,108 +4165,6 @@
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
- *	mptbase_GetFcPortPage0 - Fetch FCPort config Page0.
- *	@ioc: Pointer to MPT_ADAPTER structure
- *	@portnum: IOC Port number
- *
- *	Return: 0 for success
- *	-ENOMEM if no memory available
- *		-EPERM if not allowed due to ISR context
- *		-EAGAIN if no msg frames currently available
- *		-EFAULT for non-successful reply or no reply (timeout)
- */
-int
-mptbase_GetFcPortPage0(MPT_ADAPTER *ioc, int portnum)
-{
-	ConfigPageHeader_t	 hdr;
-	CONFIGPARMS		 cfg;
-	FCPortPage0_t		*ppage0_alloc;
-	FCPortPage0_t		*pp0dest;
-	dma_addr_t		 page0_dma;
-	int			 data_sz;
-	int			 copy_sz;
-	int			 rc;
-	int			 count = 400;
-
-
-	/* Get FCPort Page 0 header */
-	hdr.PageVersion = 0;
-	hdr.PageLength = 0;
-	hdr.PageNumber = 0;
-	hdr.PageType = MPI_CONFIG_PAGETYPE_FC_PORT;
-	cfg.cfghdr.hdr = &hdr;
-	cfg.physAddr = -1;
-	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
-	cfg.dir = 0;
-	cfg.pageAddr = portnum;
-	cfg.timeout = 0;
-
-	if ((rc = mpt_config(ioc, &cfg)) != 0)
-		return rc;
-
-	if (hdr.PageLength == 0)
-		return 0;
-
-	data_sz = hdr.PageLength * 4;
-	rc = -ENOMEM;
-	ppage0_alloc = (FCPortPage0_t *) pci_alloc_consistent(ioc->pcidev, data_sz, &page0_dma);
-	if (ppage0_alloc) {
-
- try_again:
-		memset((u8 *)ppage0_alloc, 0, data_sz);
-		cfg.physAddr = page0_dma;
-		cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
-
-		if ((rc = mpt_config(ioc, &cfg)) == 0) {
-			/* save the data */
-			pp0dest = &ioc->fc_port_page0[portnum];
-			copy_sz = min_t(int, sizeof(FCPortPage0_t), data_sz);
-			memcpy(pp0dest, ppage0_alloc, copy_sz);
-
-			/*
-			 *	Normalize endianness of structure data,
-			 *	by byte-swapping all > 1 byte fields!
-			 */
-			pp0dest->Flags = le32_to_cpu(pp0dest->Flags);
-			pp0dest->PortIdentifier = le32_to_cpu(pp0dest->PortIdentifier);
-			pp0dest->WWNN.Low = le32_to_cpu(pp0dest->WWNN.Low);
-			pp0dest->WWNN.High = le32_to_cpu(pp0dest->WWNN.High);
-			pp0dest->WWPN.Low = le32_to_cpu(pp0dest->WWPN.Low);
-			pp0dest->WWPN.High = le32_to_cpu(pp0dest->WWPN.High);
-			pp0dest->SupportedServiceClass = le32_to_cpu(pp0dest->SupportedServiceClass);
-			pp0dest->SupportedSpeeds = le32_to_cpu(pp0dest->SupportedSpeeds);
-			pp0dest->CurrentSpeed = le32_to_cpu(pp0dest->CurrentSpeed);
-			pp0dest->MaxFrameSize = le32_to_cpu(pp0dest->MaxFrameSize);
-			pp0dest->FabricWWNN.Low = le32_to_cpu(pp0dest->FabricWWNN.Low);
-			pp0dest->FabricWWNN.High = le32_to_cpu(pp0dest->FabricWWNN.High);
-			pp0dest->FabricWWPN.Low = le32_to_cpu(pp0dest->FabricWWPN.Low);
-			pp0dest->FabricWWPN.High = le32_to_cpu(pp0dest->FabricWWPN.High);
-			pp0dest->DiscoveredPortsCount = le32_to_cpu(pp0dest->DiscoveredPortsCount);
-			pp0dest->MaxInitiators = le32_to_cpu(pp0dest->MaxInitiators);
-
-			/*
-			 * if still doing discovery,
-			 * hang loose a while until finished
-			 */
-			if (pp0dest->PortState == MPI_FCPORTPAGE0_PORTSTATE_UNKNOWN) {
-				if (count-- > 0) {
-					msleep_interruptible(100);
-					goto try_again;
-				}
-				printk(MYIOC_s_INFO_FMT "Firmware discovery not"
-							" complete.\n",
-						ioc->name);
-			}
-		}
-
-		pci_free_consistent(ioc->pcidev, data_sz, (u8 *) ppage0_alloc, page0_dma);
-	}
-
-	return rc;
-}
-
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/*
  *	mptbase_sas_persist_operation - Perform operation on SAS Persitent Table
  *	@ioc: Pointer to MPT_ADAPTER structure
  *	@sas_address: 64bit SAS Address for operation.
@@ -6483,7 +6372,6 @@
 EXPORT_SYMBOL(mpt_alloc_fw_memory);
 EXPORT_SYMBOL(mpt_free_fw_memory);
 EXPORT_SYMBOL(mptbase_sas_persist_operation);
-EXPORT_SYMBOL(mptbase_GetFcPortPage0);
 
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
--- rc4u/drivers/message/fusion/mptbase.h	2006-05-12 00:14:15.000000000 -0500
+++ rc4/drivers/message/fusion/mptbase.h	2006-05-18 16:32:50.941453888 -0500
@@ -1027,7 +1027,6 @@
 extern void	 mpt_free_fw_memory(MPT_ADAPTER *ioc);
 extern int	 mpt_findImVolumes(MPT_ADAPTER *ioc);
 extern int	 mptbase_sas_persist_operation(MPT_ADAPTER *ioc, u8 persist_opcode);
-extern int	 mptbase_GetFcPortPage0(MPT_ADAPTER *ioc, int portnum);
 
 /*
  *  Public data decl's...
--- rc4u/drivers/message/fusion/mptfc.c	2006-05-18 16:31:32.389384812 -0500
+++ rc4/drivers/message/fusion/mptfc.c	2006-05-18 16:32:50.941453888 -0500
@@ -596,6 +596,110 @@
 	return err;
 }
 
+/*
+ *	mptfc_GetFcPortPage0 - Fetch FCPort config Page0.
+ *	@ioc: Pointer to MPT_ADAPTER structure
+ *	@portnum: IOC Port number
+ *
+ *	Return: 0 for success
+ *	-ENOMEM if no memory available
+ *		-EPERM if not allowed due to ISR context
+ *		-EAGAIN if no msg frames currently available
+ *		-EFAULT for non-successful reply or no reply (timeout)
+ *		-EINVAL portnum arg out of range (hardwired to two elements)
+ */
+static int
+mptfc_GetFcPortPage0(MPT_ADAPTER *ioc, int portnum)
+{
+	ConfigPageHeader_t	 hdr;
+	CONFIGPARMS		 cfg;
+	FCPortPage0_t		*ppage0_alloc;
+	FCPortPage0_t		*pp0dest;
+	dma_addr_t		 page0_dma;
+	int			 data_sz;
+	int			 copy_sz;
+	int			 rc;
+	int			 count = 400;
+
+	if (portnum > 1)
+		return -EINVAL;
+
+	/* Get FCPort Page 0 header */
+	hdr.PageVersion = 0;
+	hdr.PageLength = 0;
+	hdr.PageNumber = 0;
+	hdr.PageType = MPI_CONFIG_PAGETYPE_FC_PORT;
+	cfg.cfghdr.hdr = &hdr;
+	cfg.physAddr = -1;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
+	cfg.dir = 0;
+	cfg.pageAddr = portnum;
+	cfg.timeout = 0;
+
+	if ((rc = mpt_config(ioc, &cfg)) != 0)
+		return rc;
+
+	if (hdr.PageLength == 0)
+		return 0;
+
+	data_sz = hdr.PageLength * 4;
+	rc = -ENOMEM;
+	ppage0_alloc = (FCPortPage0_t *) pci_alloc_consistent(ioc->pcidev, data_sz, &page0_dma);
+	if (ppage0_alloc) {
+
+ try_again:
+		memset((u8 *)ppage0_alloc, 0, data_sz);
+		cfg.physAddr = page0_dma;
+		cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
+
+		if ((rc = mpt_config(ioc, &cfg)) == 0) {
+			/* save the data */
+			pp0dest = &ioc->fc_port_page0[portnum];
+			copy_sz = min_t(int, sizeof(FCPortPage0_t), data_sz);
+			memcpy(pp0dest, ppage0_alloc, copy_sz);
+
+			/*
+			 *	Normalize endianness of structure data,
+			 *	by byte-swapping all > 1 byte fields!
+			 */
+			pp0dest->Flags = le32_to_cpu(pp0dest->Flags);
+			pp0dest->PortIdentifier = le32_to_cpu(pp0dest->PortIdentifier);
+			pp0dest->WWNN.Low = le32_to_cpu(pp0dest->WWNN.Low);
+			pp0dest->WWNN.High = le32_to_cpu(pp0dest->WWNN.High);
+			pp0dest->WWPN.Low = le32_to_cpu(pp0dest->WWPN.Low);
+			pp0dest->WWPN.High = le32_to_cpu(pp0dest->WWPN.High);
+			pp0dest->SupportedServiceClass = le32_to_cpu(pp0dest->SupportedServiceClass);
+			pp0dest->SupportedSpeeds = le32_to_cpu(pp0dest->SupportedSpeeds);
+			pp0dest->CurrentSpeed = le32_to_cpu(pp0dest->CurrentSpeed);
+			pp0dest->MaxFrameSize = le32_to_cpu(pp0dest->MaxFrameSize);
+			pp0dest->FabricWWNN.Low = le32_to_cpu(pp0dest->FabricWWNN.Low);
+			pp0dest->FabricWWNN.High = le32_to_cpu(pp0dest->FabricWWNN.High);
+			pp0dest->FabricWWPN.Low = le32_to_cpu(pp0dest->FabricWWPN.Low);
+			pp0dest->FabricWWPN.High = le32_to_cpu(pp0dest->FabricWWPN.High);
+			pp0dest->DiscoveredPortsCount = le32_to_cpu(pp0dest->DiscoveredPortsCount);
+			pp0dest->MaxInitiators = le32_to_cpu(pp0dest->MaxInitiators);
+
+			/*
+			 * if still doing discovery,
+			 * hang loose a while until finished
+			 */
+			if (pp0dest->PortState == MPI_FCPORTPAGE0_PORTSTATE_UNKNOWN) {
+				if (count-- > 0) {
+					msleep_interruptible(100);
+					goto try_again;
+				}
+				printk(MYIOC_s_INFO_FMT "Firmware discovery not"
+							" complete.\n",
+						ioc->name);
+			}
+		}
+
+		pci_free_consistent(ioc->pcidev, data_sz, (u8 *) ppage0_alloc, page0_dma);
+	}
+
+	return rc;
+}
+
 static void
 mptfc_init_host_attr(MPT_ADAPTER *ioc,int portnum)
 {
@@ -652,7 +756,7 @@
 		 * will reregister existing rports
 		 */
 		for (ii=0; ii < ioc->facts.NumberOfPorts; ii++) {
-			rc = mptbase_GetFcPortPage0(ioc, ii);
+			rc = mptfc_GetFcPortPage0(ioc, ii);
 			if (rc == -EAGAIN)
 				break;
 			mptfc_init_host_attr(ioc,ii);	/* refresh */
@@ -772,6 +876,7 @@
 		goto out_mptfc_probe;
         }
 
+	spin_lock_init(&ioc->fc_rescan_work_lock);
 	INIT_WORK(&ioc->fc_rescan_work, mptfc_rescan_devices,(void *)ioc);
 
 	spin_lock_irqsave(&ioc->FreeQlock, flags);
@@ -908,6 +1013,14 @@
 		goto out_mptfc_probe;
 
 	/*
+	 *  Pre-fetch FC port WWN and stuff...
+	 *  (FCPortPage0_t stuff)
+	 */
+	for (ii=0; ii < ioc->facts.NumberOfPorts; ii++) {
+		(void) mptfc_GetFcPortPage0(ioc, ii);
+	}
+
+	/*
 	 * scan for rports -
 	 *	by doing it via the workqueue, some locking is eliminated
 	 */
@@ -936,6 +1049,74 @@
 #endif
 };
 
+static int
+mptfc_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply)
+{
+	MPT_SCSI_HOST *hd;
+	u8 event = le32_to_cpu(pEvReply->Event) & 0xFF;
+	unsigned long flags;
+	int rc=1;
+
+	devtverboseprintk((MYIOC_s_INFO_FMT "MPT event (=%02Xh) routed to SCSI host driver!\n",
+			ioc->name, event));
+
+	if (ioc->sh == NULL ||
+		((hd = (MPT_SCSI_HOST *)ioc->sh->hostdata) == NULL))
+		return 1;
+
+	switch (event) {
+	case MPI_EVENT_RESCAN:
+		spin_lock_irqsave(&ioc->fc_rescan_work_lock, flags);
+		if (ioc->fc_rescan_work_q) {
+			if (ioc->fc_rescan_work_count++ == 0) {
+				queue_work(ioc->fc_rescan_work_q,
+					   &ioc->fc_rescan_work);
+			}
+		}
+		spin_unlock_irqrestore(&ioc->fc_rescan_work_lock, flags);
+		break;
+	default:
+		rc = mptscsih_event_process(ioc,pEvReply);
+		break;
+	}
+	return rc;
+}
+
+static int
+mptfc_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
+{
+	int		rc;
+	unsigned long	flags;
+
+	rc = mptscsih_ioc_reset(ioc,reset_phase);
+	if (rc == 0)
+		return rc;
+
+
+	dtmprintk((KERN_WARNING MYNAM
+		": IOC %s_reset routed to FC host driver!\n",
+		reset_phase==MPT_IOC_SETUP_RESET ? "setup" : (
+		reset_phase==MPT_IOC_PRE_RESET ? "pre" : "post")));
+
+	if (reset_phase == MPT_IOC_SETUP_RESET) {
+	}
+
+	else if (reset_phase == MPT_IOC_PRE_RESET) {
+	}
+
+	else {	/* MPT_IOC_POST_RESET */
+		spin_lock_irqsave(&ioc->fc_rescan_work_lock, flags);
+		if (ioc->fc_rescan_work_q) {
+			if (ioc->fc_rescan_work_count++ == 0) {
+				queue_work(ioc->fc_rescan_work_q,
+					   &ioc->fc_rescan_work);
+			}
+		}
+		spin_unlock_irqrestore(&ioc->fc_rescan_work_lock, flags);
+	}
+	return 1;
+}
+
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mptfc_init - Register MPT adapter(s) as SCSI host(s) with
@@ -964,12 +1145,12 @@
 	mptfcTaskCtx = mpt_register(mptscsih_taskmgmt_complete, MPTFC_DRIVER);
 	mptfcInternalCtx = mpt_register(mptscsih_scandv_complete, MPTFC_DRIVER);
 
-	if (mpt_event_register(mptfcDoneCtx, mptscsih_event_process) == 0) {
+	if (mpt_event_register(mptfcDoneCtx, mptfc_event_process) == 0) {
 		devtverboseprintk((KERN_INFO MYNAM
 		  ": Registered for IOC event notifications\n"));
 	}
 
-	if (mpt_reset_register(mptfcDoneCtx, mptscsih_ioc_reset) == 0) {
+	if (mpt_reset_register(mptfcDoneCtx, mptfc_ioc_reset) == 0) {
 		dprintk((KERN_INFO MYNAM
 		  ": Registered for IOC reset notifications\n"));
 	}
--- rc4u/drivers/message/fusion/mptscsih.c	2006-05-12 00:14:15.000000000 -0500
+++ rc4/drivers/message/fusion/mptscsih.c	2006-05-18 16:32:50.945453688 -0500
@@ -2521,18 +2521,6 @@
 			hd->cmdPtr = NULL;
 		}
 
-		/* 7. FC: Rescan for blocked rports which might have returned.
-		 */
-		if (ioc->bus_type == FC) {
-			spin_lock_irqsave(&ioc->fc_rescan_work_lock, flags);
-			if (ioc->fc_rescan_work_q) {
-				if (ioc->fc_rescan_work_count++ == 0) {
-					queue_work(ioc->fc_rescan_work_q,
-						   &ioc->fc_rescan_work);
-				}
-			}
-			spin_unlock_irqrestore(&ioc->fc_rescan_work_lock, flags);
-		}
 		dtmprintk((MYIOC_s_WARN_FMT "Post-Reset complete.\n", ioc->name));
 
 	}
@@ -2546,7 +2534,6 @@
 {
 	MPT_SCSI_HOST *hd;
 	u8 event = le32_to_cpu(pEvReply->Event) & 0xFF;
-	unsigned long flags;
 
 	devtverboseprintk((MYIOC_s_INFO_FMT "MPT event (=%02Xh) routed to SCSI host driver!\n",
 			ioc->name, event));
@@ -2569,14 +2556,6 @@
 		break;
 
 	case MPI_EVENT_RESCAN:				/* 06 */
-		spin_lock_irqsave(&ioc->fc_rescan_work_lock, flags);
-		if (ioc->fc_rescan_work_q) {
-			if (ioc->fc_rescan_work_count++ == 0) {
-				queue_work(ioc->fc_rescan_work_q,
-					   &ioc->fc_rescan_work);
-			}
-		}
-		spin_unlock_irqrestore(&ioc->fc_rescan_work_lock, flags);
 		break;
 
 		/*

--------------020405060306030409020103--
