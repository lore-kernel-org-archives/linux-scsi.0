From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 14/19] drivers/scsi: Use PCI_VDEVICE
Date: Sat, 27 Jun 2009 15:56:45 -0500
Message-ID: <1246136205.3990.70.camel@mulgrave.site>
References: <cover.1245906151.git.joe@perches.com>
	 <079fbc10b41dd4b7f0d381b7e969134184652c95.1245906152.git.joe@perches.com>
	 <1246123235.3990.15.camel@mulgrave.site>
	 <1246132405.23023.190.camel@Joe-Laptop.home>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45349 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750840AbZF0U4r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Jun 2009 16:56:47 -0400
In-Reply-To: <1246132405.23023.190.camel@Joe-Laptop.home>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Adam Radford <linuxraid@amcc.com>, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, Rik Faith <faith@cs.unc.edu>, Neela Syam Kolli <megaraidlinux@lsi.com>, Willem Riede <osst@riede.org>, Kai =?ISO-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>, Matthew Wilcox <matthew@wil.cx>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Kurt Garloff <garloff@suse.de>, linux-scsi@vger.kernel.org, osst-users@lists.sourceforge.net

On Sat, 2009-06-27 at 12:53 -0700, Joe Perches wrote:
> On Sat, 2009-06-27 at 12:20 -0500, James Bottomley wrote:
> > OK, so there's no description whatsoever how am I supposed to divine the
> > reasons for doing this?
> 
> You might look at the 0/19 patch description.
> http://lkml.org/lkml/2009/6/25/21

That's not really an adequate admonishment because it didn't go to the
list I'm looking at these on, so it's hard to find but more importantly
anyone doing a git log through our sources at a later time will be
incredibly hard pressed to find it either.  the 0/X is supposed to be a
preamble, not a substitute for patch descriptions.  If you plan on
rolling all these patches up with the 0/19 as the description, that's
fine, but I'd have still liked to see the description accompanying the
patch to the list you sent it to.

> > Because if I look at an example:
> > 
> > > --- a/drivers/scsi/3w-9xxx.c
> > > +++ b/drivers/scsi/3w-9xxx.c
> > > @@ -2278,14 +2278,10 @@ out_disable_device:
> > >  
> > >  /* PCI Devices supported by this driver */
> > >  static struct pci_device_id twa_pci_tbl[] __devinitdata = {
> > > -	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_9000,
> > > -	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
> > > -	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_9550SX,
> > > -	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
> > > -	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_9650SE,
> > > -	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
> > > -	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_9690SA,
> > > -	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
> > > +	{ PCI_VDEVICE(3WARE, PCI_DEVICE_ID_3WARE_9000), 0},
> > > +	{ PCI_VDEVICE(3WARE, PCI_DEVICE_ID_3WARE_9550SX), 0},
> > > +	{ PCI_VDEVICE(3WARE, PCI_DEVICE_ID_3WARE_9650SE), 0},
> > > +	{ PCI_VDEVICE(3WARE, PCI_DEVICE_ID_3WARE_9690SA), 0},
> > 
> > It appears to take PCI matching on vendor device with any subvendor,
> > device and reproduce the results with a macro, which, for good measure
> > pastes PCI_VENDOR_ID on to the first argument but *doesn't* paste
> > PCI_DEVICE_ID on to the second?
> 
> A single macro can't use both a named constant and a magic number
> as the second argument.
> 
> Today, only about half of the pci device declarations use
> named constants, mostly defined in pci_ids.h
> 
> Style 1: PCI_VDEVICE(VENDOR, PCI_DEVICE_ID_<foo>)
> 
> $ grep -rP --include=*.[ch] \
> 	"\bPCI_VDEVICE\s*\(\s*\w+\s*,\s*PCI_DEVICE_ID" * | \
> 	wc -l
> 351
> 
> Style 2: PCI_VDEVICE(VENDOR, 0x<hex#>)
>  
> $ grep -rP --include=*.[ch] \
> 	"\bPCI_VDEVICE\s*\(\s*\w+\s*,\s*0[xX][0-9a-fA-F]{1,4}" * | \
> 	wc -l
> 287
> 
> PCI_DEVICE(VENDOR, PCI_DEVICE_ID_<foo>)
> 
> $ grep -rP --include=*.[ch] \
> 	"\bPCI_DEVICE\s*\(\s*\w+\s*,\s*PCI_DEVICE_ID" * | \
> 	wc -l
> 373
> 
> PCI_DEVICE(VENDOR, 0x<foo>)
> 
> $ grep -rP --include=*.[ch] \
> 	"\bPCI_DEVICE\s*\(\s*\w+\s*,\s*0[xX][0-9a-fA-F]{1,4}" * | \
> 	wc -l
> 320
> 
> After this patchset:
> 
> $ grep -rP --include=*.[ch] \
> 	"\bPCI_VDEVICE\s*\(\s*\w+\s*,\s*PCI_DEVICE_ID" * | \
> 	wc -l
> 831
> 
> $ grep -rP --include=*.[ch] \
> 	"\bPCI_VDEVICE\s*\(\s*\w+\s*,\s*0[xX][0-9a-fA-F]{1,4}" * | \
> 	wc -l
> 571
> 
> > So it transforms a relatively opaque initialiser which most people would
> > have to look up in pci.h into another relatively opaque initialiser
> > indirected via a macro, so now I have to look up both the structure and
> > the macro to figure out what's going on.
> > 
> > If that's all it does, I'm having a hard time seeing any actual
> > improvement here.
> 
> Greater standardization of declarations across multiple files.

If this applied to all driver files, I might buy it.  However, if you
have to match on subvendor/subdevice, you have to write out the whole
thing anyway.  PCI_VDEVICE() doesn't even give us the scope to expand
struct pci_device_id because it doesn't (and can't in its current form)
initialise the fields by name.

> Do you have a suggestion or preference for another macro name
> for the named constants uses?

I'm having trouble seeing the actual value of a macro at all.  As I said
above, it doesn't seem to be an improvement over the bare initialiser
values.  It seems principally designed to save driver writers from
typing ... which is fine, but not really if you apply it after the fact.
It also doesn't seem to have the hallmarks of a true standardisation
because of all the exceptions.  All it really does do is deprecate the
bare use of PCI_ANY_ID ... but is that worth all the code churn?

James


