From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH2.5] ips 3/4: use pci_dma APIs and remove GFP abuse
Date: Fri, 15 Aug 2003 17:09:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F3D4C14.4090907@pobox.com>
References: <1060951415.3251.46.camel@blackmagic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:21895 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S270926AbTHOVJy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Aug 2003 17:09:54 -0400
In-Reply-To: <1060951415.3251.46.camel@blackmagic>
List-Id: linux-scsi@vger.kernel.org
To: David Jeffery <david_jeffery@adaptec.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

David Jeffery wrote:
> -#if !defined(__i386__) && !defined(__ia64__)
> -#error "This driver has only been tested on the x86/ia64 platforms"
> +#if !defined(__i386__) && !defined(__ia64__) && !defined(__x86_64__)
> +#error "This driver has only been tested on the x86/ia64/x86_64 platforms"
>  #endif

This should be removed completely.

Under Linux, you limit the architectures that build your driver via 
Kconfig (or in 2.4, Config.in) dependencies.

Further, Linux actively encourages that all PCI platforms at least 
attempt to build PCI drivers -- even if the company does not support the 
driver on that platform.  This leads to an increase in driver quality, 
as it increases the opportunities others have to point out bugs, and 
offer fixes.


>  #if LINUX_VERSION_CODE <= KERNEL_VERSION(2,5,0)
> @@ -250,6 +250,7 @@
>  static int ips_ioctlsize = IPS_IOCTL_SIZE;	/* Size of the ioctl buffer        */
>  static int ips_cd_boot;		/* Booting from Manager CD         */
>  static char *ips_FlashData = NULL;	/* CD Boot - Flash Data Buffer      */
> +static dma_addr_t ips_flashbusaddr;
>  static long ips_FlashDataInUse;	/* CD Boot - Flash Data In Use Flag */
>  static uint32_t MaxLiteCmds = 32;	/* Max Active Cmds for a Lite Adapter */
>  static Scsi_Host_Template ips_driver_template = {
> @@ -589,17 +590,6 @@
>  		ips_setup(ips);
>  #endif
>  
> -	/* If Booting from the Manager CD, Allocate a large Flash        */
> -	/* Buffer ( so we won't need to allocate one for each adapter ). */
> -	if (ips_cd_boot) {
> -		ips_FlashData = (char *) __get_free_pages(IPS_INIT_GFP, 7);
> -		if (ips_FlashData == NULL) {
> -			/* The validity of this pointer is checked in ips_make_passthru() before it is used */
> -			printk(KERN_WARNING
> -			       "ERROR: Can't Allocate Large Buffer for Flashing\n");
> -		}
> -	}
> -
>  	for (i = 0; i < ips_num_controllers; i++) {
>  		if (ips_register_scsi(i))
>  			ips_free(ips_ha[i]);
> @@ -1630,21 +1620,20 @@
>  ips_alloc_passthru_buffer(ips_ha_t * ha, int length)
>  {
>  	void *bigger_buf;
> -	int count;
> -	int order;
> +	dma_addr_t dma_busaddr;
>  
> -	if (ha->ioctl_data && length <= (PAGE_SIZE << ha->ioctl_order))
> +	if (ha->ioctl_data && length <= ha->ioctl_len)
>  		return 0;
>  	/* there is no buffer or it's not big enough, allocate a new one */
> -	for (count = PAGE_SIZE, order = 0;
> -	     count < length; order++, count <<= 1) ;
> -	bigger_buf = (void *) __get_free_pages(IPS_ATOMIC_GFP, order);
> +	bigger_buf = pci_alloc_consistent(ha->pcidev, length, &dma_busaddr);

It's not wrong... but it's a bit nasty to be calling 
pci_alloc_consistent from the interrupt handler.  Typically, if you can, 
it would be better to have buffers waiting for you, and you simply map 
them here, using pci_map_single or pci_map_page or whatever.

Also, as a tangent, I was thinking that it might be beneficial to move 
ips_next() to a tasklet.  Change all callers to call schedule_tasklet() 
instead.  That should allow more streamlined usage, IMO...



> @@ -7394,7 +7366,7 @@
>  		return ips_abort_init(ha, index);
>  	}
>  
> -	ha->nvram = kmalloc(sizeof (IPS_NVRAM_P5), IPS_INIT_GFP);
> +	ha->nvram = kmalloc(sizeof (IPS_NVRAM_P5), GFP_KERNEL);
>  
>  	if (!ha->nvram) {
>  		IPS_PRINTK(KERN_WARNING, pci_dev,
> @@ -7402,7 +7374,7 @@
>  		return ips_abort_init(ha, index);
>  	}
>  
> -	ha->subsys = kmalloc(sizeof (IPS_SUBSYS), IPS_INIT_GFP);
> +	ha->subsys = kmalloc(sizeof (IPS_SUBSYS), GFP_KERNEL);

Looks good.  Now if we could convince you to change structs to style 
"struct foo" instead of SHOUTING STYLE, it would be even cooler :)



