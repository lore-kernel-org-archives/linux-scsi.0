From: Adrian Bunk <bunk@kernel.org>
Subject: Re: [RFC PATCH] SCSI: split Kconfig menu into two
Date: Sat, 15 Sep 2007 13:40:55 +0200
Message-ID: <20070915114055.GP3563@stusta.de>
References: <46E46190.6080607@garzik.org> <20070912224655.GC3563@stusta.de> <46EAA08F.30703@s5r6.in-berlin.de> <20070914151522.GL3563@stusta.de> <46EAAAC1.3050409@s5r6.in-berlin.de> <tkrat.d922469e152fe0f3@s5r6.in-berlin.de> <tkrat.913e8b183cdf7888@s5r6.in-berlin.de> <20070914190033.GA4003@uranus.ravnborg.org> <20070914190609.GN3563@stusta.de> <tkrat.552dbee831c88bbe@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:57261 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751169AbXIOLkp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Sep 2007 07:40:45 -0400
Content-Disposition: inline
In-Reply-To: <tkrat.552dbee831c88bbe@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, James Bottomley <james.bottomley@steeleye.com>, linux-scsi@vger.kernel.org, Jeff Garzik <jeff@garzik.org>, Andi Kleen <andi@firstfloor.org>, Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 10:01:18PM +0200, Stefan Richter wrote:
> On 14 Sep, Adrian Bunk wrote:
> > On Fri, Sep 14, 2007 at 09:00:33PM +0200, Sam Ravnborg wrote:
> >> Hi Stefan.
> >> 
> >> Such a patch really calls for some minimal unifacation among
> >> the architectures.
> >> 
> >> > 
> >> >  arch/alpha/Kconfig            |    2 
> >> >  arch/arm/Kconfig              |    2 
> >> >  arch/avr32/Kconfig            |    2 
> >> >  arch/blackfin/Kconfig         |    2 
> >> >  arch/cris/Kconfig             |    2 
> >> >  arch/frv/Kconfig              |    2 
> >> >  arch/i386/Kconfig             |    2 
> >> >  arch/ia64/Kconfig             |    2 
> >> >  arch/m32r/Kconfig             |    2 
> >> >  arch/m68k/Kconfig             |    2 
> >> >  arch/m68knommu/Kconfig        |    2 
> >> >  arch/mips/Kconfig             |    2 
> >> >  arch/parisc/Kconfig           |    2 
> >> >  arch/powerpc/Kconfig          |    2 
> >> >  arch/ppc/Kconfig              |    2 
> >> >  arch/s390/Kconfig             |    2 
> >> >  arch/sh/Kconfig               |    2 
> >> >  arch/sh64/Kconfig             |    2 
> >> >  arch/sparc/Kconfig            |    2 
> >> >  arch/sparc64/Kconfig          |    2 
> >> >  arch/um/Kconfig               |    2 
> >> >  arch/v850/Kconfig             |    2 
> >> >  arch/x86_64/Kconfig           |    4 
> >> >  arch/xtensa/Kconfig           |    2 
> >> 
> >> 
> >> Exactly the same change for all architectures.
> >> IT would be good to introduce a common file that contains
> >> some of the shared stuff from the different architectures.
> >> We could start out simple with:
> >> 
> >> arch/Kconfig.arch:
> >>...
> 
> Yes, that would be good.  But Adrian has a point too.
> 
> > Stefan simply shouldn't move it out of drivers/Kconfig.
>...
>  drivers/Kconfig               |    4 
>  drivers/scsi/Kconfig          | 1589 ----------------------------------
>  drivers/scsi/Kconfig.lowlevel | 1578 +++++++++++++++++++++++++++++++++
>  3 files changed, 1588 insertions(+), 1583 deletions(-)

Nearly right.  ;-)

There are a few architectures not (yet) using drivers/Kconfig.

> Index: linux-2.6.23-rc6/drivers/Kconfig
> ===================================================================
> --- linux-2.6.23-rc6.orig/drivers/Kconfig
> +++ linux-2.6.23-rc6/drivers/Kconfig
> @@ -1,5 +1,7 @@
>  # drivers/Kconfig
>  
> +source "drivers/scsi/Kconfig"
> +
>  menu "Device Drivers"
>  
>  source "drivers/base/Kconfig"
> @@ -22,7 +24,7 @@ source "drivers/misc/Kconfig"
>  
>  source "drivers/ide/Kconfig"
>  
> -source "drivers/scsi/Kconfig"
> +source "drivers/scsi/Kconfig.lowlevel"
>  
>  source "drivers/ata/Kconfig"
>...

This way the order is wrong:

There should first be the lowlevel SCSI, SATA, USB etc. drivers, these 
drivers should select CONFIG_SCSI, and then the menu offering support 
for disk, CD,...

> Index: linux-2.6.23-rc6/drivers/scsi/Kconfig
> ===================================================================
> --- linux-2.6.23-rc6.orig/drivers/scsi/Kconfig
> +++ linux-2.6.23-rc6/drivers/scsi/Kconfig
> @@ -1,14 +1,7 @@
> -menu "SCSI device support"
> -
> -config RAID_ATTRS
> -	tristate "RAID Transport Class"
> -	default n
> -	depends on BLOCK
> -	---help---
> -	  Provides RAID
> +menu "Storage (core and SCSI commands)"
>  
>  config SCSI
> -	tristate "SCSI device support"
> +	tristate "Storage support (core and SCSI commands)"
>  	depends on BLOCK
>  	select SCSI_DMA if HAS_DMA
>  	---help---
>...

What is "storage support"?
SATA?
PATA?
USB mass storage?
MMC?
MTD?

Whether or not a driver uses the SCSI layer is an implementation detail 
(it even differs for the two USB mass storage implementations and the 
two PATA implementations in the kernel) the user shouldn't have to know 
about.

I don't see any reason why CONFIG_SCSI should have to stay user-visible 
at all after your patch.

> Stefan Richter

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

