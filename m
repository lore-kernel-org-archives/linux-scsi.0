From: Matthew Wilcox <willy@debian.org>
Subject: Re: i450nx-scanning-fix.patch
Date: Mon, 29 Dec 2003 12:28:09 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031229122809.GF12479@parcelfarce.linux.theplanet.co.uk>
References: <20031229030235.315d5502.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:34010 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S263290AbTL2M2K
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Dec 2003 07:28:10 -0500
Content-Disposition: inline
In-Reply-To: <20031229030235.315d5502.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Matthew Wilcox <willy@debian.org>, linux-scsi@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz

On Mon, Dec 29, 2003 at 03:02:35AM -0800, Andrew Morton wrote:
> 
> I have had this in -mm for some time.  It works on my 450nx-based 4-way. 
> Was planning on merging it.  Speak now or forever hold your pieces.

Well, I made the same mistake in this patch as I made in a later patch, so
I know it never worked for anyone.  Namely, pci_bus->children is the list
of child busses, not the list of devices on the bus.  That's ->devices.
I swear I'm going to write a for_each_pci_device_on_this_bus() macro so
I don't make the same mistake a third time.

>  arch/i386/pci/fixup.c |   33 +++++++++++++++++++++++++++++----
>  1 files changed, 29 insertions(+), 4 deletions(-)
> 
> diff -puN arch/i386/pci/fixup.c~i450nx-scanning-fix arch/i386/pci/fixup.c
> --- 25/arch/i386/pci/fixup.c~i450nx-scanning-fix	2003-11-09 16:58:55.000000000 -0800
> +++ 25-akpm/arch/i386/pci/fixup.c	2003-11-09 16:58:55.000000000 -0800
> @@ -6,27 +6,52 @@
>  #include <linux/init.h>
>  #include "pci.h"
>  
> +static void __devinit i450nx_scan_bus(struct pci_bus *parent, u8 busnr)
> +{
> +	struct list_head *tmp;
> +
> +	pci_scan_bus(busnr, &pci_root_ops, NULL);
> +
> +	list_for_each(tmp, &parent->children) {
> +		u8 childnr;
> +		struct pci_dev *dev = pci_dev_b(tmp);
> +
> +		if (dev->hdr_type != PCI_HEADER_TYPE_BRIDGE)
> +			continue;
> +		pci_read_config_byte(dev, PCI_PRIMARY_BUS, &childnr);
> +		if (childnr != busnr)
> +			continue;
> +
> +		printk(KERN_WARNING "PCI: Removing fake PCI bridge %s\n",
> +				pci_name(dev));
> +		pci_remove_bus_device(dev);
> +		break;
> +	}
> +}
>  
>  static void __devinit pci_fixup_i450nx(struct pci_dev *d)
>  {
>  	/*
>  	 * i450NX -- Find and scan all secondary buses on all PXB's.
> +	 * Some manufacturers added fake PCI-PCI bridges that also point
> +	 * to the peer busses.  Look for them and delete them.
>  	 */
>  	int pxb, reg;
>  	u8 busno, suba, subb;
>  
> -	printk(KERN_WARNING "PCI: Searching for i450NX host bridges on %s\n", pci_name(d));
> +	printk(KERN_NOTICE "PCI: Searching for i450NX host bridges on %s\n", pci_name(d));
>  	reg = 0xd0;
> -	for(pxb=0; pxb<2; pxb++) {
> +	for (pxb = 0; pxb < 2; pxb++) {
>  		pci_read_config_byte(d, reg++, &busno);
>  		pci_read_config_byte(d, reg++, &suba);
>  		pci_read_config_byte(d, reg++, &subb);
>  		DBG("i450NX PXB %d: %02x/%02x/%02x\n", pxb, busno, suba, subb);
>  		if (busno)
> -			pci_scan_bus(busno, &pci_root_ops, NULL);	/* Bus A */
> +			i450nx_scan_bus(d->bus, busno);		/* Bus A */
>  		if (suba < subb)
> -			pci_scan_bus(suba+1, &pci_root_ops, NULL);	/* Bus B */
> +			i450nx_scan_bus(d->bus, suba+1);	/* Bus B */
>  	}
> +
>  	pcibios_last_bus = -1;
>  }
>  
> 
> _
> 

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
