From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: [ANNOUNCE]: megaraid driver version 2.20.1.0
Date: Fri, 25 Jun 2004 21:43:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57033BC7DC@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:42919 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S266919AbUFZBoT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jun 2004 21:44:19 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

The driver 2.20.1.0 with the below mentioned fix is now available on

ftp://ftp.lsil.com/pub/linux-megaraid/drivers/version-2.20.1.0/

Thanks
-Atul Mukker


> -----Original Message-----
> From: Mukker, Atul 
> Sent: Friday, June 25, 2004 8:56 PM
> To: 'Christoph Hellwig'
> Cc: 'linux-scsi@vger.kernel.org'
> Subject: RE: [ANNOUNCE]: megaraid driver version 2.20.0.1
> Importance: High
> 
> 
> A bug was discovered in the driver unload path, causing 
> kernel panic. The new driver will be available in the FTP 
> site soon. The patch with the fix is inlined.
> 
> 
> 
> 
> diff -u 2.20.0.1/ChangeLog.megaraid 2.20.1.0/ChangeLog.megaraid
> --- 2.20.0.1/ChangeLog.megaraid	2004-06-24 
> 20:59:46.000000000 -0400
> +++ 2.20.1.0/ChangeLog.megaraid	2004-06-25 
> 20:58:56.000000000 -0400
> @@ -1,3 +1,11 @@
> +Release Date	: Fri Jun 25 18:58:43 EDT 2004 - Atul Mukker 
> <atulm@lsil.com>
> +Current Version	: 2.20.1.0
> +Older Version	: megaraid 2.20.0.1
> +
> +i.	Stale list pointer in adapter causes kernel panic when module
> +	megaraid_mbox is unloaded
> +
> +
>  Release Date	: Thu Jun 24 20:37:11 EDT 2004 - Atul Mukker 
> <atulm@lsil.com>
>  Current Version	: 2.20.0.1
>  Older Version	: megaraid 2.20.0.00
> @@ -13,6 +21,7 @@
>  iv.	scsi_host_put(), do just before completing HBA shutdown.
>  
>  
> +
>  Release Date	: Mon Jun 21 19:53:54 EDT 2004 - Atul Mukker 
> <atulm@lsil.com>
>  Current Version	: 2.20.0.0
>  Older Version	: megaraid 2.20.0.rc2 and 2.00.3
> diff -u 2.20.0.1/mega_common.h 2.20.1.0/mega_common.h
> --- 2.20.0.1/mega_common.h	2004-06-24 20:59:46.000000000 -0400
> +++ 2.20.1.0/mega_common.h	2004-06-25 20:58:57.000000000 -0400
> @@ -113,7 +113,6 @@
>   * @param max_channel		: maximum channel 
> number supported - inclusive
>   * @param max_target		: max target supported - inclusive
>   * @param max_lun		: max lun supported - inclusive
> - * @param list			: list of megaraid host 
> structures
>   * @param unique_id		: unique identifier for each adapter
>   * @param irq			: IRQ for this adapter
>   * @param ito			: internal timeout 
> value, (-1) means no timeout
> @@ -171,7 +170,6 @@
>  	uint16_t		max_target;
>  	uint8_t			max_lun;
>  
> -	struct list_head	list;
>  	uint32_t		unique_id;
>  	uint8_t			irq;
>  	uint8_t			ito;
> diff -u 2.20.0.1/megaraid_mbox.c 2.20.1.0/megaraid_mbox.c
> --- 2.20.0.1/megaraid_mbox.c	2004-06-24 20:59:46.000000000 -0400
> +++ 2.20.1.0/megaraid_mbox.c	2004-06-25 20:58:57.000000000 -0400
> @@ -10,7 +10,7 @@
>   *	   2 of the License, or (at your option) any later version.
>   *
>   * FILE		: megaraid.c
> - * Version	: v2.20.0.1 (June 24 2004)
> + * Version	: v2.20.1.0 (June 25 2004)
>   *
>   * Authors:
>   * 	Atul Mukker		<Atul.Mukker@lsil.com>
> @@ -683,9 +683,6 @@
>  	// pending with us?
>  	atomic_set(&adapter->being_detached, 1);
>  
> -	// remove the adapter from the global list of our controllers
> -	list_del_init(&adapter->list);
> -
>  	// detach from the IO sub-system
>  	megaraid_io_detach(adapter);
>  
> diff -u 2.20.0.1/megaraid_mbox.h 2.20.1.0/megaraid_mbox.h
> --- 2.20.0.1/megaraid_mbox.h	2004-06-24 20:59:46.000000000 -0400
> +++ 2.20.1.0/megaraid_mbox.h	2004-06-25 20:58:58.000000000 -0400
> @@ -21,8 +21,8 @@
>  #include "megaraid_ioctl.h"
>  
>  
> -#define MEGARAID_VERSION	"2.20.0.1"
> -#define MEGARAID_EXT_VERSION	"(Release Date: Thu Jun 24 
> 20:37:11 EDT 2004)"
> +#define MEGARAID_VERSION	"2.20.1.0"
> +#define MEGARAID_EXT_VERSION	"(Release Date: Fri Jun 25 
> 18:58:43 EDT 2004)"
>  
>  
>  /*
> 
> 
> > -----Original Message-----
> > From: 'Christoph Hellwig' [mailto:hch@infradead.org]
> > Sent: Friday, June 25, 2004 4:14 AM
> > To: Mukker, Atul
> > Cc: 'Christoph Hellwig'; 'linux-scsi@vger.kernel.org'
> > Subject: Re: [ANNOUNCE]: megaraid driver version 2.20.0.1
> > 
> > 
> > On Thu, Jun 24, 2004 at 09:07:48PM -0400, Mukker, Atul wrote:
> > > Christoph,
> > > 
> > > I have put the revised driver on the ftp server
> > > 
> > > ftp://ftp.lsil.com/pub/linux-megaraid/drivers/version-2.20.0.1/
> > > 
> > > This driver incorporates almost all your suggestions. I 
> > think it's high
> > > time, the driver makes into the mainstream kernel.
> > 
> > Oh well, let's include it and I'll fix up some minor cruft later on.
> > Note that changes to drivers/pci/pci.ids should be sent 
> separately to
> > pci-ids@ucw.cz (see http://pciids.sourceforge.net/ for defails)
> > 
> 
