From: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Subject: Re: [PATCH] Stop using num_physpages in aacraid
Date: Fri, 2 May 2008 15:06:42 -0400
Message-ID: <CA69411A-909E-4161-A4E3-FC86246CDA22@adaptec.com>
References: <20080502185227.GN14976@parisc-linux.org>
Mime-Version: 1.0 (Apple Message framework v919.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:38389 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965501AbYEBTGo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 15:06:44 -0400
In-Reply-To: <20080502185227.GN14976@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

The num_physpages variable works as needed for the PERC controllers  
that are installed in vanilla x86 machines is it not? The PERC card  
would not be installed in any other arch.

AAC_QUIRK_SCSI_32 means the card can not send 64bit format commands to  
the SCSI devices (non DASD) but can send 64bit format commands to the  
logical (Array) devices. This is for a select set of old PERC cards.

AAC_OPT_SGMAP_HOST64 means this card 'can' do DAC (send 64 bit format  
commands to both SCSI and to Array devices), but sadly some that  
report this are borken (hence the Quirk AAC_QUIRK_SCSI_32).

Dropping the cards is not an option, that is the whole reason this  
workaround was put in place.

I can handle dropping these select PERC cards from the list if the  
architecture was NOT x86, since that was never a supported  
architecture for these cards, but I am sure some folks are using them  
this way ;-} I would prefer to DROP Non-DASD support for these cards  
in 64 bit kernels if one is not to use num_physpages!

Sincerely -- Mark Salyzyn

On May 2, 2008, at 2:52 PM, Matthew Wilcox wrote:

>
> The num_physpages variable has an interesting and varied definition
> depending on the architecture and various CONFIG options, not to  
> mention
> whether memory has been hotplugged or not.  At any rate, it doesn't do
> what aacraid is trying to use it for -- to determine whether a dma  
> will
> be 64-bit.
>
> This patch removes the aac_scsi_32_64() function altogether, favouring
> a failure to initialise over failing every command sent to the device.
>
> The various quirks, options and flags are quite confusing.  I think  
> I've
> managed to get it right, but I have no hardware to test with.
>
> My understanding:
>        AAC_QUIRK_SCSI_32 means "This card cannot address above 64-bit.
>        But it does support the 64-bit format."
>
>        AAC_OPT_SGMAP_HOST64 means "This card MUST do DAC".
>
> The patch below is intended to reflect that understanding.  If I've
> misunderstood the old code, or that wasn't what the old code was  
> supposed
> to mean then the below patch is wrong.
>
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
>
> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/ 
> aachba.c
> index 460d402..95e524a 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -1199,15 +1199,6 @@ static int aac_scsi_32(struct fib * fib,  
> struct scsi_cmnd * cmd)
>                                  (fib_callback) aac_srb_callback,  
> (void *) cmd);
> }
>
> -static int aac_scsi_32_64(struct fib * fib, struct scsi_cmnd * cmd)
> -{
> -       if ((sizeof(dma_addr_t) > 4) &&
> -        (num_physpages > (0xFFFFFFFFULL >> PAGE_SHIFT)) &&
> -        (fib->dev->adapter_info.options & AAC_OPT_SGMAP_HOST64))
> -               return FAILED;
> -       return aac_scsi_32(fib, cmd);
> -}
> -
> int aac_get_adapter_info(struct aac_dev* dev)
> {
>        struct fib* fibptr;
> @@ -1367,26 +1358,36 @@ int aac_get_adapter_info(struct aac_dev* dev)
>                printk(KERN_INFO "%s%d: Non-DASD support enabled. 
> \n",dev->name, dev->id);
>
>        dev->dac_support = 0;
> -       if( (sizeof(dma_addr_t) > 4) && (dev->adapter_info.options &  
> AAC_OPT_SGMAP_HOST64)){
> +       if ((sizeof(dma_addr_t) > 4) &&
> +           (dev->adapter_info.options & AAC_OPT_SGMAP_HOST64)) {
>                if (!dev->in_reset)
>                        printk(KERN_INFO "%s%d: 64bit support enabled. 
> \n",
>                                dev->name, dev->id);
>                dev->dac_support = 1;
>        }
>
> -       if(dacmode != -1) {
> +       if (dacmode != -1) {
>                dev->dac_support = (dacmode!=0);
>        }
> -       if(dev->dac_support != 0) {
> +       if (dev->dac_support &&
> +           !(aac_get_driver_ident(dev->cardtype)->quirks &
> +                                                        
> AAC_QUIRK_SCSI_32)) {
>                if (!pci_set_dma_mask(dev->pdev, DMA_64BIT_MASK) &&
> -                       !pci_set_consistent_dma_mask(dev->pdev,  
> DMA_64BIT_MASK)) {
> +                   !pci_set_consistent_dma_mask(dev->pdev,  
> DMA_64BIT_MASK)) {
>                        if (!dev->in_reset)
>                                printk(KERN_INFO"%s%d: 64 Bit DAC  
> enabled\n",
>                                        dev->name, dev->id);
>                } else if (!pci_set_dma_mask(dev->pdev,  
> DMA_32BIT_MASK) &&
> -                       !pci_set_consistent_dma_mask(dev->pdev,  
> DMA_32BIT_MASK)) {
> +                          !pci_set_consistent_dma_mask(dev->pdev,
> +                                                        
> DMA_32BIT_MASK)) {
>                        printk(KERN_INFO"%s%d: DMA mask set failed,  
> 64 Bit DAC disabled\n",
>                                dev->name, dev->id);
> +                       if (dev->adapter_info.options &  
> AAC_OPT_SGMAP_HOST64) {
> +                               printk(KERN_INFO "%s%d: 64-bit DAC  
> required "
> +                                       "for this host, bailing out 
> \n",
> +                                       dev->name, dev->id);
> +                               rcode = -ENOMEM;
> +                       }
>                        dev->dac_support = 0;
>                } else {
>                        printk(KERN_WARNING"%s%d: No suitable DMA  
> available.\n",
> @@ -1398,11 +1399,7 @@ int aac_get_adapter_info(struct aac_dev* dev)
>         * Deal with configuring for the individualized limits of  
> each packet
>         * interface.
>         */
> -       dev->a_ops.adapter_scsi = (dev->dac_support)
> -         ? ((aac_get_driver_ident(dev->cardtype)->quirks &  
> AAC_QUIRK_SCSI_32)
> -                               ? aac_scsi_32_64
> -                               : aac_scsi_64)
> -                               : aac_scsi_32;
> +       dev->a_ops.adapter_scsi = dev->dac_support ? aac_scsi_64 :  
> aac_scsi_32;
>        if (dev->raw_io_interface) {
>                dev->a_ops.adapter_bounds = (dev->raw_io_64)
>                                        ? aac_bounds_64
>
> --
> Intel are signing my paycheques ... these opinions are still mine
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."

