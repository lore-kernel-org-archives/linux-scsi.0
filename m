From: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Subject: Re: [PATCH] Stop using num_physpages in aacraid
Date: Fri, 2 May 2008 15:45:30 -0400
Message-ID: <ECD41FEE-6B1E-4396-9DB5-0FCE55F99B57@adaptec.com>
References: <20080502185227.GN14976@parisc-linux.org>
Mime-Version: 1.0 (Apple Message framework v919.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:39266 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758646AbYEBTpb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 May 2008 15:45:31 -0400
In-Reply-To: <20080502185227.GN14976@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

As a follow up:

diff -ru a/aachba.c b/aachba.c
--- a/aachba.c  2008-05-02 15:35:39.227304669 -0400
+++ b/aachba.c  2008-05-02 15:36:07.450684444 -0400
@@ -1207,7 +1207,6 @@
  static int aac_scsi_32_64(struct fib * fib, struct scsi_cmnd * cmd)
  {
         if ((sizeof(dma_addr_t) > 4) &&
-        (num_physpages > (0xFFFFFFFFULL >> PAGE_SHIFT)) &&
          (fib->dev->adapter_info.options & AAC_OPT_SGMAP_HOST64))
                 return FAILED;
         return aac_scsi_32(fib, cmd);

will turn off NON-DASD (Tapes, CDROMS etc) support, and still enable  
64 bit I/O on 64 bit operating systems to the Arrays on the defective  
controllers. At least with the code before this change, we would allow  
NON-DASD support if the memory did not hit the 32 bit boundary even if  
it was a 64 bit OS.

One can switch to 32 bit I/O to the Arrays on 64 bit operating systems  
and keep NON-DASD support:

diff -ru a/aachba.c b/aachba.c
--- a/aachba.c  2008-05-02 15:35:39.227304669 -0400
+++ b/aachba.c  2008-05-02 15:42:08.261039455 -0400
@@ -1204,15 +1204,6 @@
                                   (fib_callback) aac_srb_callback,  
(void *) cmd);
  }

-static int aac_scsi_32_64(struct fib * fib, struct scsi_cmnd * cmd)
-{
-       if ((sizeof(dma_addr_t) > 4) &&
-        (num_physpages > (0xFFFFFFFFULL >> PAGE_SHIFT)) &&
-        (fib->dev->adapter_info.options & AAC_OPT_SGMAP_HOST64))
-               return FAILED;
-       return aac_scsi_32(fib, cmd);
-}
-
  int aac_get_adapter_info(struct aac_dev* dev)
  {
         struct fib* fibptr;
@@ -1382,6 +1373,8 @@
         if(dacmode != -1) {
                 dev->dac_support = (dacmode!=0);
         }
+       if (aac_get_driver_ident(dev->cardtype)->quirks &  
AAC_QUIRK_SCSI_32)
+               dev->dac_support = 0;
         if(dev->dac_support != 0) {
                 if (!pci_set_dma_mask(dev->pdev, DMA_64BIT_MASK) &&
                         !pci_set_consistent_dma_mask(dev->pdev,  
DMA_64BIT_MASK)) {
@@ -1404,10 +1397,7 @@
          * interface.
          */
         dev->a_ops.adapter_scsi = (dev->dac_support)
-         ? ((aac_get_driver_ident(dev->cardtype)->quirks &  
AAC_QUIRK_SCSI_32)
-                               ? aac_scsi_32_64
-                               : aac_scsi_64)
-                               : aac_scsi_32;
+                               ? aac_scsi_64 : aac_scsi_32;
         if (dev->raw_io_interface) {
                 dev->a_ops.adapter_bounds = (dev->raw_io_64)
                                         ? aac_bounds_64

But you can not have BOTH, choose performance on Arrays, or NON-DASD  
functionality.

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

