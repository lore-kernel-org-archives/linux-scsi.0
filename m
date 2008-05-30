From: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Subject: RE: [PATCH 4/6] mpt fusion: Fixing 1078 data corruption issue for36GB memory region resubmitted with review suggestions included
Date: Sat, 31 May 2008 03:22:49 +0800
Message-ID: <5AE055B67BB5764693E2900C7E3699BE0117BE99@pamail.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:44481 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753274AbYE3TXE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 May 2008 15:23:04 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, "Moore, Eric" <Eric.Moore@lsi.com>

James,
We have started using the dma_get_required_mask instead of
sizeof(dma_addr_t) in our internal versions of the driver. But this
change requires lot of other changes in the driver and it is still in
testing phase. So I will submit the usage of dma_get_required_mask
instead of sizeof(dma_addr_t) as a separate patch.

The other patches can go in. I will resubmit the patch again with all
other suggestions except the usage of dma_get_required_mask.

Thanks
Sathya
  

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
Sent: Wednesday, May 28, 2008 1:44 AM
To: Prakash, Sathya
Cc: linux-scsi@vger.kernel.org; Moore, Eric
Subject: Re: [PATCH 4/6] mpt fusion: Fixing 1078 data corruption issue
for36GB memory region resubmitted with review suggestions included

On Wed, 2008-05-21 at 01:00 +0530, Prakash, Sathya wrote: 
> This patch is resubmitted with the changes suggested by James, except 
> the usage of dma_get_required_mask instead of dma_addr_t size.

I thought you said it was slightly more efficient to use the 32 bit
addressing mode?  So it should be slightly more efficient to use the 32
bit mode even on 64 bit kernels as long as all memory is < 4GB.

> This change requires
> additional modifications and will be submitted later as a seperate 
> patch

So that means this 4/6 can't go in now?  but 5/6 and 6/6 are OK (since I
can't see anything in 5 or 6 which is relevant to this)?

Also, just a note about the replacement of a 3 way 'if' that always
takes the same branch with a function pointer: in general, function
pointers are less efficient because they destroy pipelining and
speculation.  A simple branch might be better (particularly in this case
where the prediction should always get it right since the logic value
doesn't alter).  However, the CPUs that suffer most from this are the
long pipeline ones like ia64 and parisc, I suspect the effect is much
more marginal on x86.

> ---
> 
> The reason for this change is there is a data corruption when four 
> different physical memory regions in the 36GB to 37GB region are
accessed.
> This is only affecting 1078.
> 
>  The solution is we need to use different addressing when filling in  
> the scatter gather table for the effected memory regions.  So instead

> of snooping on all four different memory holes, we treat any physical

> addresses in the 36GB address with the same algorithm.
> 
>  The fix is explained below
>  1) Ensure that the message frames are NOT located in the trouble  
> region. There is no remapping available for message frames, they must

> be allocated outside the problem region.
>  2) Ensure that Sense buffers are NOT in the trouble region. There is

> no remapping available.
>  3) Walk through the SGE entries and if any are inside the trouble  
> region then they need to be remapped as discussed below.
>  	1) Set the Local Address bit in the SGE Flags field.
>  	MPI_SGE_FLAGS_LOCAL_ADDRESS
>  	2) Ensure we are using 64-bit SGEs
>  	3) Set MSb (Bit 63) of the 64-bit address, this will indicate
buffer
>  	location is Host Memory.
> 
> Signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
> ---
> 
> diff --git a/drivers/message/fusion/mptbase.c 
> b/drivers/message/fusion/mptbase.c
> index ff9965d..f64f6b3 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -925,33 +925,75 @@ mpt_free_msg_frame(MPT_ADAPTER *ioc,
MPT_FRAME_HDR *mf)
>  	spin_unlock_irqrestore(&ioc->FreeQlock, flags);  }
>  
> +
>  
> /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
> =-=-=-=*/
>  /**
> - *	mpt_add_sge - Place a simple SGE at address pAddr.
> - *	@pAddr: virtual address for SGE
> + *	mpt_add_sge - Place a simple 32 bit SGE at address addr.
> + *	@addr: virtual address for SGE
>   *	@flagslength: SGE flags and data transfer length
>   *	@dma_addr: Physical address
> - *
> - *	This routine places a MPT request frame back on the MPT
adapter's
> - *	FreeQ.
>   */
> -void
> -mpt_add_sge(char *pAddr, u32 flagslength, dma_addr_t dma_addr)
> +static void
> +mpt_add_sge(char *addr, u32 flagslength, dma_addr_t dma_addr)

if you used void * instead of char * here, you wouldn't need to do all
the recasting (both into and out of this function).  Since you get
absolutely zero type safety from any of this, I think void * makes a lot
more sense and is much more readable.

> {
> -	if (sizeof(dma_addr_t) == sizeof(u64)) {
> -		SGESimple64_t *pSge = (SGESimple64_t *) pAddr;
> -		u32 tmp = dma_addr & 0xFFFFFFFF;
> +	SGESimple32_t *pSge = (SGESimple32_t *) addr;
> +	pSge->FlagsLength = cpu_to_le32(flagslength);
> +	pSge->Address = cpu_to_le32(dma_addr); }
>  
> -		pSge->FlagsLength = cpu_to_le32(flagslength);
> -		pSge->Address.Low = cpu_to_le32(tmp);
> -		tmp = (u32) ((u64)dma_addr >> 32);
> -		pSge->Address.High = cpu_to_le32(tmp);
> +/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
> +-=-=-=-=*/
> +/**
> + *	mpt_add_sge_64bit - Place a simple 64 bit SGE at address addr.
> + *	@addr: virtual address for SGE
> + *	@flagslength: SGE flags and data transfer length
> + *	@dma_addr: Physical address
> + */
> +static void
> +mpt_add_sge_64bit(char *addr, u32 flagslength, dma_addr_t dma_addr) {
> +	SGESimple64_t *pSge = (SGESimple64_t *) addr;
> +	u32 tmp = dma_addr & 0xFFFFFFFF;
>  
> -	} else {
> -		SGESimple32_t *pSge = (SGESimple32_t *) pAddr;
> -		pSge->FlagsLength = cpu_to_le32(flagslength);
> -		pSge->Address = cpu_to_le32(dma_addr);
> -	}
> +	pSge->FlagsLength = cpu_to_le32(flagslength);
> +	pSge->Address.Low = cpu_to_le32(tmp);
> +	tmp = (u32) ((u64)dma_addr >> 32);

Use the macro upper_32_bits() here.

> +	pSge->Address.High = cpu_to_le32(tmp); }
> +
> +/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
> +-=-=-=-=*/
> +/**
> + *	mpt_add_sge_64bit_1078 - Place a simple 64 bit SGE at address
addr
> + *	(1078 workaround).
> + *	@addr: virtual address for SGE
> + *	@flagslength: SGE flags and data transfer length
> + *	@dma_addr: Physical address
> + */
> +static void
> +mpt_add_sge_64bit_1078(char *addr, u32 flagslength, dma_addr_t 
> +dma_addr) {
> +	SGESimple64_t *pSge = (SGESimple64_t *) addr;
> +	u32 tmp;
> +
> +	tmp = dma_addr & 0xFFFFFFFF;
> +	pSge->Address.Low = cpu_to_le32(tmp);
> +	tmp = (u32) ((u64)dma_addr >> 32);

upper_32_bits() again.

> +	/*
> +	 * 1078 errata workaround for the 36GB limitation
> +	 */
> +	if ((((u64)dma_addr + MPI_SGE_LENGTH(flagslength)) >> 32)  == 9)
{
> +		flagslength |=
> +		    MPI_SGE_SET_FLAGS(MPI_SGE_FLAGS_LOCAL_ADDRESS);
> +		tmp |= (1<<31);
> +		if (mpt_debug_level & MPT_DEBUG_36GB_MEM)
> +			printk(KERN_DEBUG "1078 P0M2 addressing for "
> +			    "addr = 0x%llx len = %d\n",
> +			    (unsigned long long)dma_addr,
> +			    MPI_SGE_LENGTH(flagslength));
> +	}
> +
> +	pSge->FlagsLength = cpu_to_le32(flagslength);
> +	pSge->Address.High = cpu_to_le32(tmp);
>  }
>  
>  
> /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
> =-=-=-=*/ @@ -1154,7 +1196,7 @@ mpt_host_page_alloc(MPT_ADAPTER *ioc, 
> pIOCInit_t ioc_init)
>  	}
>  	flags_length = flags_length << MPI_SGE_FLAGS_SHIFT;
>  	flags_length |= ioc->HostPageBuffer_sz;
> -	mpt_add_sge(psge, flags_length, ioc->HostPageBuffer_dma);
> +	ioc->add_sge(psge, flags_length, ioc->HostPageBuffer_dma);
>  	ioc->facts.HostPageBufferSGE = ioc_init->HostPageBufferSGE;
>  
>  return 0;
> @@ -1465,11 +1507,13 @@ mpt_mapresources(MPT_ADAPTER *ioc)
>  
>  	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)
>  	    && !pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK)) {
> +		ioc->dma_mask = DMA_64BIT_MASK;
>  		dinitprintk(ioc, printk(MYIOC_s_INFO_FMT
>  		    ": 64 BIT PCI BUS DMA ADDRESSING SUPPORTED\n",
>  		    ioc->name));
>  	} else if (!pci_set_dma_mask(pdev, DMA_32BIT_MASK)
>  	    && !pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK)) {
> +		ioc->dma_mask = DMA_32BIT_MASK;
>  		dinitprintk(ioc, printk(MYIOC_s_INFO_FMT
>  		    ": 32 BIT PCI BUS DMA ADDRESSING SUPPORTED\n",
>  		    ioc->name));
> @@ -1573,6 +1617,17 @@ mpt_attach(struct pci_dev *pdev, const struct 
> pci_device_id *id)
>  
>  	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT ":
mpt_adapter_install\n", 
> ioc->name));
>  
> +	/*
> +	 * Setting up proper handlers for scatter gather handling
> +	 */
> +	if (sizeof(dma_addr_t) == sizeof(u64)) {
> +		if (pdev->device == MPI_MANUFACTPAGE_DEVID_SAS1078)
> +			ioc->add_sge = &mpt_add_sge_64bit_1078;
> +		else
> +			ioc->add_sge = &mpt_add_sge_64bit;
> +	} else
> +		ioc->add_sge = &mpt_add_sge;
> +
>  	ioc->pcidev = pdev;
>  	if (mpt_mapresources(ioc)) {
>  		kfree(ioc);
> @@ -3245,7 +3300,7 @@ mpt_do_upload(MPT_ADAPTER *ioc, int sleepFlag)
>  	sgeoffset = sizeof(FWUpload_t) - sizeof(SGE_MPI_UNION) + 
> sizeof(FWUploadTCSGE_t);
>  
>  	flagsLength = MPT_SGE_FLAGS_SSIMPLE_READ | sz;
> -	mpt_add_sge((char *)ptcsge, flagsLength, ioc->cached_fw_dma);
> +	ioc->add_sge((char *)ptcsge, flagsLength, ioc->cached_fw_dma);
>  
>  	sgeoffset += sizeof(u32) + sizeof(dma_addr_t);
>  	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT ": Sending FW Upload
(req @ 
> %p) sgeoffset=%d \n", @@ -4039,12 +4094,33 @@
PrimeIocFifos(MPT_ADAPTER *ioc)
>  	dma_addr_t alloc_dma;
>  	u8 *mem;
>  	int i, reply_sz, sz, total_size, num_chain;
> +	u64	dma_mask = 0;
>  
>  	/*  Prime reply FIFO...  */
>  
>  	if (ioc->reply_frames == NULL) {
>  		if ( (num_chain = initChainBuffers(ioc)) < 0)
>  			return -1;
> +		/*
> +		 * 1078 errata workaround for the 36GB limitation
> +		 */
> +		if (ioc->pcidev->device ==
MPI_MANUFACTPAGE_DEVID_SAS1078 &&
> +		    ioc->dma_mask > DMA_35BIT_MASK) {
> +			if (!pci_set_dma_mask(ioc->pcidev,
DMA_35BIT_MASK)
> +			    && !pci_set_consistent_dma_mask(ioc->pcidev,
> +			    DMA_35BIT_MASK)) {
> +				dma_mask = DMA_35BIT_MASK;
> +				d36memprintk(ioc,
printk(MYIOC_s_DEBUG_FMT
> +				    "setting 35 bit addressing for "
> +				    "Request/Reply/Chain and Sense
Buffers\n",
> +				    ioc->name));
> +			} else {
> +				d36memprintk(ioc,
printk(MYIOC_s_DEBUG_FMT
> +				    "failed setting 35 bit addressing
for "
> +				    "Request/Reply/Chain and Sense
Buffers\n",
> +				    ioc->name));

This is a pretty serious failure isn't it?  Doesn't it mean that the
sense buffer for the device becomes unusable if it's placed in the wrong
memory and so the device is potentially inoperable?  It would seem that
some action stronger than a debug message might be required.

> +			}
> +		}
>  
>  		total_size = reply_sz = (ioc->reply_sz *
ioc->reply_depth);
>  		dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "ReplyBuffer
sz=%d bytes, 
> ReplyDepth=%d\n", @@ -4183,6 +4259,12 @@ PrimeIocFifos(MPT_ADAPTER
*ioc)
>  		alloc_dma += ioc->reply_sz;
>  	}
>  
> +	if (dma_mask == DMA_35BIT_MASK && !pci_set_dma_mask(ioc->pcidev,
> +	    DMA_64BIT_MASK) && !pci_set_consistent_dma_mask(ioc->pcidev,
> +	    DMA_64BIT_MASK))
> +		d36memprintk(ioc, printk(MYIOC_s_DEBUG_FMT
> +		    "restoring 64 bit addressing\n", ioc->name));
> +
>  	return 0;
>  
>  out_fail:
> @@ -4202,6 +4284,13 @@ out_fail:
>  				ioc->sense_buf_pool,
ioc->sense_buf_pool_dma);
>  		ioc->sense_buf_pool = NULL;
>  	}
> +
> +	if (dma_mask == DMA_35BIT_MASK && !pci_set_dma_mask(ioc->pcidev,
> +	    DMA_64BIT_MASK) && !pci_set_consistent_dma_mask(ioc->pcidev,
> +	    DMA_64BIT_MASK))
> +		d36memprintk(ioc, printk(MYIOC_s_DEBUG_FMT
> +		    "restoring 64 bit addressing\n", ioc->name));
> +
>  	return -1;
>  }
>  
> @@ -5805,7 +5894,7 @@ mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS *pCfg)
>  			ioc->name, pReq->Header.PageType,
pReq->Header.PageNumber, pReq->Action));
>  	}
>  
> -	mpt_add_sge((char *)&pReq->PageBufferSGE, flagsLength,
pCfg->physAddr);
> +	ioc->add_sge((char *)&pReq->PageBufferSGE, flagsLength, 
> +pCfg->physAddr);
>  
>  	/* Append pCfg pointer to end of mf
>  	 */
> @@ -7465,7 +7554,6 @@ EXPORT_SYMBOL(mpt_get_msg_frame);  
> EXPORT_SYMBOL(mpt_put_msg_frame);  
> EXPORT_SYMBOL(mpt_put_msg_frame_hi_pri);
>  EXPORT_SYMBOL(mpt_free_msg_frame);
> -EXPORT_SYMBOL(mpt_add_sge);
>  EXPORT_SYMBOL(mpt_send_handshake_request);
>  EXPORT_SYMBOL(mpt_verify_adapter);
>  EXPORT_SYMBOL(mpt_GetIocState);
> diff --git a/drivers/message/fusion/mptbase.h 
> b/drivers/message/fusion/mptbase.h
> index c8671a3..56630c6 100644
> --- a/drivers/message/fusion/mptbase.h
> +++ b/drivers/message/fusion/mptbase.h
> @@ -562,6 +562,8 @@ struct mptfc_rport_info
>  	u8		flags;
>  };
>  
> +typedef void (*MPT_ADD_SGE)(char *addr, u32 flagslength, dma_addr_t 
> +dma_addr);
> +
>  /*
>   *  Adapter Structure - pci_dev specific. Maximum: MPT_MAX_ADAPTERS
>   */
> @@ -598,6 +600,8 @@ typedef struct _MPT_ADAPTER
>  	int			 reply_depth;	/* Num Allocated reply
frames */
>  	int			 reply_sz;	/* Reply frame size */
>  	int			 num_chain;	/* Number of chain
buffers */
> +	MPT_ADD_SGE		 add_sge;
> +	u64			 dma_mask;

Can we not do this ... as I said before, there doesn't seem to be any
reason not to use ioc->pcidev->dma_mask.

James


