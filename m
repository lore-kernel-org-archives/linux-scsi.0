From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 14/19] drivers/scsi: Use PCI_VDEVICE
Date: Sat, 27 Jun 2009 12:20:35 -0500
Message-ID: <1246123235.3990.15.camel@mulgrave.site>
References: <cover.1245906151.git.joe@perches.com>
	 <079fbc10b41dd4b7f0d381b7e969134184652c95.1245906152.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55764 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753671AbZF0RUl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Jun 2009 13:20:41 -0400
In-Reply-To: <079fbc10b41dd4b7f0d381b7e969134184652c95.1245906152.git.joe@perches.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Adam Radford <linuxraid@amcc.com>, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, Rik Faith <faith@cs.unc.edu>, Neela Syam Kolli <megaraidlinux@lsi.com>, Willem Riede <osst@riede.org>, Kai =?ISO-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>, Matthew Wilcox <matthew@wil.cx>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Kurt Garloff <garloff@suse.de>, linux-scsi@vger.kernel.org, osst-users@lists.sourceforge.net

On Wed, 2009-06-24 at 22:13 -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>

OK, so there's no description whatsoever how am I supposed to divine the
reasons for doing this?

Because if I look at an example:

> --- a/drivers/scsi/3w-9xxx.c
> +++ b/drivers/scsi/3w-9xxx.c
> @@ -2278,14 +2278,10 @@ out_disable_device:
>  
>  /* PCI Devices supported by this driver */
>  static struct pci_device_id twa_pci_tbl[] __devinitdata = {
> -	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_9000,
> -	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
> -	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_9550SX,
> -	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
> -	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_9650SE,
> -	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
> -	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_9690SA,
> -	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
> +	{ PCI_VDEVICE(3WARE, PCI_DEVICE_ID_3WARE_9000), 0},
> +	{ PCI_VDEVICE(3WARE, PCI_DEVICE_ID_3WARE_9550SX), 0},
> +	{ PCI_VDEVICE(3WARE, PCI_DEVICE_ID_3WARE_9650SE), 0},
> +	{ PCI_VDEVICE(3WARE, PCI_DEVICE_ID_3WARE_9690SA), 0},

It appears to take PCI matching on vendor device with any subvendor,
device and reproduce the results with a macro, which, for good measure
pastes PCI_VENDOR_ID on to the first argument but *doesn't* paste
PCI_DEVICE_ID on to the second?

So it transforms a relatively opaque initialiser which most people would
have to look up in pci.h into another relatively opaque initialiser
indirected via a macro, so now I have to look up both the structure and
the macro to figure out what's going on.

If that's all it does, I'm having a hard time seeing any actual
improvement here.

James


