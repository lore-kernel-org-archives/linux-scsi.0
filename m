From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 14/19] drivers/scsi: Use PCI_VDEVICE
Date: Sat, 27 Jun 2009 12:53:25 -0700
Message-ID: <1246132405.23023.190.camel@Joe-Laptop.home>
References: <cover.1245906151.git.joe@perches.com>
	 <079fbc10b41dd4b7f0d381b7e969134184652c95.1245906152.git.joe@perches.com>
	 <1246123235.3990.15.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4828 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbZF0Tx2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Jun 2009 15:53:28 -0400
In-Reply-To: <1246123235.3990.15.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, Adam Radford <linuxraid@amcc.com>, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, Rik Faith <faith@cs.unc.edu>, Neela Syam Kolli <megaraidlinux@lsi.com>, Willem Riede <osst@riede.org>, Kai =?ISO-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>, Matthew Wilcox <matthew@wil.cx>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Kurt Garloff <garloff@suse.de>, linux-scsi@vger.kernel.org, osst-users@lists.sourceforge.net

On Sat, 2009-06-27 at 12:20 -0500, James Bottomley wrote:
> OK, so there's no description whatsoever how am I supposed to divine the
> reasons for doing this?

You might look at the 0/19 patch description.
http://lkml.org/lkml/2009/6/25/21

> Because if I look at an example:
> 
> > --- a/drivers/scsi/3w-9xxx.c
> > +++ b/drivers/scsi/3w-9xxx.c
> > @@ -2278,14 +2278,10 @@ out_disable_device:
> >  
> >  /* PCI Devices supported by this driver */
> >  static struct pci_device_id twa_pci_tbl[] __devinitdata = {
> > -	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_9000,
> > -	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
> > -	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_9550SX,
> > -	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
> > -	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_9650SE,
> > -	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
> > -	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_9690SA,
> > -	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
> > +	{ PCI_VDEVICE(3WARE, PCI_DEVICE_ID_3WARE_9000), 0},
> > +	{ PCI_VDEVICE(3WARE, PCI_DEVICE_ID_3WARE_9550SX), 0},
> > +	{ PCI_VDEVICE(3WARE, PCI_DEVICE_ID_3WARE_9650SE), 0},
> > +	{ PCI_VDEVICE(3WARE, PCI_DEVICE_ID_3WARE_9690SA), 0},
> 
> It appears to take PCI matching on vendor device with any subvendor,
> device and reproduce the results with a macro, which, for good measure
> pastes PCI_VENDOR_ID on to the first argument but *doesn't* paste
> PCI_DEVICE_ID on to the second?

A single macro can't use both a named constant and a magic number
as the second argument.

Today, only about half of the pci device declarations use
named constants, mostly defined in pci_ids.h

Style 1: PCI_VDEVICE(VENDOR, PCI_DEVICE_ID_<foo>)

$ grep -rP --include=*.[ch] \
	"\bPCI_VDEVICE\s*\(\s*\w+\s*,\s*PCI_DEVICE_ID" * | \
	wc -l
351

Style 2: PCI_VDEVICE(VENDOR, 0x<hex#>)
 
$ grep -rP --include=*.[ch] \
	"\bPCI_VDEVICE\s*\(\s*\w+\s*,\s*0[xX][0-9a-fA-F]{1,4}" * | \
	wc -l
287

PCI_DEVICE(VENDOR, PCI_DEVICE_ID_<foo>)

$ grep -rP --include=*.[ch] \
	"\bPCI_DEVICE\s*\(\s*\w+\s*,\s*PCI_DEVICE_ID" * | \
	wc -l
373

PCI_DEVICE(VENDOR, 0x<foo>)

$ grep -rP --include=*.[ch] \
	"\bPCI_DEVICE\s*\(\s*\w+\s*,\s*0[xX][0-9a-fA-F]{1,4}" * | \
	wc -l
320

After this patchset:

$ grep -rP --include=*.[ch] \
	"\bPCI_VDEVICE\s*\(\s*\w+\s*,\s*PCI_DEVICE_ID" * | \
	wc -l
831

$ grep -rP --include=*.[ch] \
	"\bPCI_VDEVICE\s*\(\s*\w+\s*,\s*0[xX][0-9a-fA-F]{1,4}" * | \
	wc -l
571

> So it transforms a relatively opaque initialiser which most people would
> have to look up in pci.h into another relatively opaque initialiser
> indirected via a macro, so now I have to look up both the structure and
> the macro to figure out what's going on.
> 
> If that's all it does, I'm having a hard time seeing any actual
> improvement here.

Greater standardization of declarations across multiple files.

Do you have a suggestion or preference for another macro name
for the named constants uses?

drivers/edac/edac_core.h has:

#define PCI_VEND_DEV(vend, dev) PCI_VENDOR_ID_ ## vend, \
        PCI_DEVICE_ID_ ## vend ## _ ## dev

cheers, Joe

