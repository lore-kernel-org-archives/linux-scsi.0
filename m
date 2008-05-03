From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: blk request timeout handler against 2.6.26
Date: Sat, 3 May 2008 07:20:58 -0600
Message-ID: <20080503132058.GZ14976@parisc-linux.org>
References: <20080503020000.GU14976@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:36424 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbYECNVO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 May 2008 09:21:14 -0400
Content-Disposition: inline
In-Reply-To: <20080503020000.GU14976@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>


Hm.  That'll teach me to work on two things in the same tree.  Ignore
these three hunks.

On Fri, May 02, 2008 at 08:00:00PM -0600, Matthew Wilcox wrote:
> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
> index 460d402..00bd514 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -1199,15 +1199,6 @@ static int aac_scsi_32(struct fib * fib, struct scsi_cmnd * cmd)
>  				  (fib_callback) aac_srb_callback, (void *) cmd);
>  }
>  
> -static int aac_scsi_32_64(struct fib * fib, struct scsi_cmnd * cmd)
> -{
> -	if ((sizeof(dma_addr_t) > 4) &&
> -	 (num_physpages > (0xFFFFFFFFULL >> PAGE_SHIFT)) &&
> -	 (fib->dev->adapter_info.options & AAC_OPT_SGMAP_HOST64))
> -		return FAILED;
> -	return aac_scsi_32(fib, cmd);
> -}
> -
>  int aac_get_adapter_info(struct aac_dev* dev)
>  {
>  	struct fib* fibptr;
> @@ -1367,26 +1358,36 @@ int aac_get_adapter_info(struct aac_dev* dev)
>  		printk(KERN_INFO "%s%d: Non-DASD support enabled.\n",dev->name, dev->id);
>  
>  	dev->dac_support = 0;
> -	if( (sizeof(dma_addr_t) > 4) && (dev->adapter_info.options & AAC_OPT_SGMAP_HOST64)){
> +	if ((sizeof(dma_addr_t) > 4) &&
> +	    (dev->adapter_info.options & AAC_OPT_SGMAP_HOST64)) {
>  		if (!dev->in_reset)
>  			printk(KERN_INFO "%s%d: 64bit support enabled.\n",
>  				dev->name, dev->id);
>  		dev->dac_support = 1;
>  	}
>  
> -	if(dacmode != -1) {
> +	if (dacmode != -1) {
>  		dev->dac_support = (dacmode!=0);
>  	}
> -	if(dev->dac_support != 0) {
> +	if (dev->dac_support &&
> +	    !(aac_get_driver_ident(dev->cardtype)->quirks &
> +							AAC_QUIRK_SCSI_32)) {
>  		if (!pci_set_dma_mask(dev->pdev, DMA_64BIT_MASK) &&
> -			!pci_set_consistent_dma_mask(dev->pdev, DMA_64BIT_MASK)) {
> +		    !pci_set_consistent_dma_mask(dev->pdev, DMA_64BIT_MASK)) {
>  			if (!dev->in_reset)
>  				printk(KERN_INFO"%s%d: 64 Bit DAC enabled\n",
>  					dev->name, dev->id);
>  		} else if (!pci_set_dma_mask(dev->pdev, DMA_32BIT_MASK) &&
> -			!pci_set_consistent_dma_mask(dev->pdev, DMA_32BIT_MASK)) {
> +			   !pci_set_consistent_dma_mask(dev->pdev,
> +							DMA_32BIT_MASK)) {
>  			printk(KERN_INFO"%s%d: DMA mask set failed, 64 Bit DAC disabled\n",
>  				dev->name, dev->id);
> +	 		if (dev->adapter_info.options & AAC_OPT_SGMAP_HOST64) {
> +				printk(KERN_INFO "%s%d: 64-bit DAC required "
> +					"for this host, bailing out\n",
> +					dev->name, dev->id);
> +				rcode = -ENOMEM;
> +			}
>  			dev->dac_support = 0;
>  		} else {
>  			printk(KERN_WARNING"%s%d: No suitable DMA available.\n",
> @@ -1398,11 +1399,7 @@ int aac_get_adapter_info(struct aac_dev* dev)
>  	 * Deal with configuring for the individualized limits of each packet
>  	 * interface.
>  	 */
> -	dev->a_ops.adapter_scsi = (dev->dac_support)
> -	  ? ((aac_get_driver_ident(dev->cardtype)->quirks & AAC_QUIRK_SCSI_32)
> -				? aac_scsi_32_64
> -				: aac_scsi_64)
> -				: aac_scsi_32;
> +	dev->a_ops.adapter_scsi = dev->dac_support ? aac_scsi_64 : aac_scsi_32;
>  	if (dev->raw_io_interface) {
>  		dev->a_ops.adapter_bounds = (dev->raw_io_64)
>  					? aac_bounds_64

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
