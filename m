From: "Jeffery, David" <David_Jeffery@adaptec.com>
Subject: RE: [PATCH2.5] ips 3/4: use pci_dma APIs and remove GFP abuse
Date: Mon, 18 Aug 2003 12:09:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A3B9245C291EEF4785A24A1DBE8D852B037809@rtpexc01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [216.52.22.10] ([216.52.22.10]:12453 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S272299AbTHRQJz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Aug 2003 12:09:55 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Jeff Garzik' <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org


> -----Original Message-----
> From: Jeff Garzik
> Sent: Friday, August 15, 2003 5:10 PM
> To: Jeffery, David
> Cc: linux-scsi
> Subject: Re: [PATCH2.5] ips 3/4: use pci_dma APIs and remove GFP abuse
> 
> 
> David Jeffery wrote:
> > -#if !defined(__i386__) && !defined(__ia64__)
> > -#error "This driver has only been tested on the x86/ia64 platforms"
> > +#if !defined(__i386__) && !defined(__ia64__) && 
> !defined(__x86_64__)
> > +#error "This driver has only been tested on the 
> x86/ia64/x86_64 platforms"
> >  #endif
> 
> This should be removed completely.
> 
> Under Linux, you limit the architectures that build your driver via 
> Kconfig (or in 2.4, Config.in) dependencies.
> 
> Further, Linux actively encourages that all PCI platforms at least 
> attempt to build PCI drivers -- even if the company does not 
> support the 
> driver on that platform.  This leads to an increase in driver 
> quality, 
> as it increases the opportunities others have to point out bugs, and 
> offer fixes.

I need to fix up the Kconfig file.  How about I also downgrade that to
a #warning like Andi suggested earlier?
 
> 
> >  #if LINUX_VERSION_CODE <= KERNEL_VERSION(2,5,0)
> > @@ -250,6 +250,7 @@
> >  static int ips_ioctlsize = IPS_IOCTL_SIZE;	/* Size of the 
> ioctl buffer        */
> >  static int ips_cd_boot;		/* Booting from Manager 
> CD         */
> >  static char *ips_FlashData = NULL;	/* CD Boot - Flash Data 
> Buffer      */
> > +static dma_addr_t ips_flashbusaddr;
> >  static long ips_FlashDataInUse;	/* CD Boot - Flash Data 
> In Use Flag */
> >  static uint32_t MaxLiteCmds = 32;	/* Max Active Cmds for 
> a Lite Adapter */
> >  static Scsi_Host_Template ips_driver_template = {
> > @@ -589,17 +590,6 @@
> >  		ips_setup(ips);
> >  #endif
> >  
> > -	/* If Booting from the Manager CD, Allocate a large 
> Flash        */
> > -	/* Buffer ( so we won't need to allocate one for each 
> adapter ). */
> > -	if (ips_cd_boot) {
> > -		ips_FlashData = (char *) 
> __get_free_pages(IPS_INIT_GFP, 7);
> > -		if (ips_FlashData == NULL) {
> > -			/* The validity of this pointer is 
> checked in ips_make_passthru() before it is used */
> > -			printk(KERN_WARNING
> > -			       "ERROR: Can't Allocate Large 
> Buffer for Flashing\n");
> > -		}
> > -	}
> > -
> >  	for (i = 0; i < ips_num_controllers; i++) {
> >  		if (ips_register_scsi(i))
> >  			ips_free(ips_ha[i]);
> > @@ -1630,21 +1620,20 @@
> >  ips_alloc_passthru_buffer(ips_ha_t * ha, int length)
> >  {
> >  	void *bigger_buf;
> > -	int count;
> > -	int order;
> > +	dma_addr_t dma_busaddr;
> >  
> > -	if (ha->ioctl_data && length <= (PAGE_SIZE << ha->ioctl_order))
> > +	if (ha->ioctl_data && length <= ha->ioctl_len)
> >  		return 0;
> >  	/* there is no buffer or it's not big enough, allocate 
> a new one */
> > -	for (count = PAGE_SIZE, order = 0;
> > -	     count < length; order++, count <<= 1) ;
> > -	bigger_buf = (void *) __get_free_pages(IPS_ATOMIC_GFP, order);
> > +	bigger_buf = pci_alloc_consistent(ha->pcidev, length, 
> &dma_busaddr);
> 
> It's not wrong... but it's a bit nasty to be calling 
> pci_alloc_consistent from the interrupt handler.  Typically, 
> if you can, 
> it would be better to have buffers waiting for you, and you 
> simply map 
> them here, using pci_map_single or pci_map_page or whatever.

Normally, that is what happens.  A new, larger buffer will
only be allocated in a few very rare cases.  No user should
ever hit those allocations when using the ServeRAID tools.
Only a few special commands like flashing firmware should
ever trigger reallocation.

> Also, as a tangent, I was thinking that it might be 
> beneficial to move 
> ips_next() to a tasklet.  Change all callers to call 
> schedule_tasklet() 
> instead.  That should allow more streamlined usage, IMO...

Reworking ips_next is on my large list of Things To Do if I
Had Time.

> 
> 
> > @@ -7394,7 +7366,7 @@
> >  		return ips_abort_init(ha, index);
> >  	}
> >  
> > -	ha->nvram = kmalloc(sizeof (IPS_NVRAM_P5), IPS_INIT_GFP);
> > +	ha->nvram = kmalloc(sizeof (IPS_NVRAM_P5), GFP_KERNEL);
> >  
> >  	if (!ha->nvram) {
> >  		IPS_PRINTK(KERN_WARNING, pci_dev,
> > @@ -7402,7 +7374,7 @@
> >  		return ips_abort_init(ha, index);
> >  	}
> >  
> > -	ha->subsys = kmalloc(sizeof (IPS_SUBSYS), IPS_INIT_GFP);
> > +	ha->subsys = kmalloc(sizeof (IPS_SUBSYS), GFP_KERNEL);
> 
> Looks good.  Now if we could convince you to change structs to style 
> "struct foo" instead of SHOUTING STYLE, it would be even cooler :)

The code still has plenty of warts and I wish I had more time to work
on them. (Notice a theme about time? :)

David Jeffery
