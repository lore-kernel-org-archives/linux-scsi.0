From: Adrian Bunk <bunk@kernel.org>
Subject: Re: [RFC PATCH] SCSI: split Kconfig menu into two
Date: Sat, 15 Sep 2007 14:50:55 +0200
Message-ID: <20070915125055.GQ3563@stusta.de>
References: <46EAA08F.30703@s5r6.in-berlin.de> <20070914151522.GL3563@stusta.de> <46EAAAC1.3050409@s5r6.in-berlin.de> <tkrat.d922469e152fe0f3@s5r6.in-berlin.de> <tkrat.913e8b183cdf7888@s5r6.in-berlin.de> <20070914190033.GA4003@uranus.ravnborg.org> <20070914190609.GN3563@stusta.de> <tkrat.552dbee831c88bbe@s5r6.in-berlin.de> <20070915114055.GP3563@stusta.de> <46EBCEF1.4030702@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38474 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752900AbXIOMup (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Sep 2007 08:50:45 -0400
Content-Disposition: inline
In-Reply-To: <46EBCEF1.4030702@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, James Bottomley <james.bottomley@steeleye.com>, linux-scsi@vger.kernel.org, Jeff Garzik <jeff@garzik.org>, Andi Kleen <andi@firstfloor.org>, Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org

On Sat, Sep 15, 2007 at 02:24:17PM +0200, Stefan Richter wrote:
> Adrian Bunk wrote:
>...
> >>  # drivers/Kconfig
> >>  
> >> +source "drivers/scsi/Kconfig"
> >> +
> >>  menu "Device Drivers"
> >>  
> >>  source "drivers/base/Kconfig"
> >> @@ -22,7 +24,7 @@ source "drivers/misc/Kconfig"
> >>  
> >>  source "drivers/ide/Kconfig"
> >>  
> >> -source "drivers/scsi/Kconfig"
> >> +source "drivers/scsi/Kconfig.lowlevel"
> >>  
> >>  source "drivers/ata/Kconfig"
> >> ...
> > 
> > This way the order is wrong:
> > 
> > There should first be the lowlevel SCSI, SATA, USB etc. drivers, these 
> > drivers should select CONFIG_SCSI, and then the menu offering support 
> > for disk, CD,...
> 
> The order was inspired by
> 
> 	# the protocols etc.
> 	"Networking"
> 
> 	# the interconnects
> 	"Device Drivers"/ "Network device support"
> 
> So that order is wrong too?

It's different since _all_ network device drivers require networking 
support.

> However, there is also precedence for the order which you suggest:  The
> partition and filesystems options come after device driver options.
> 
> [...]
> >> +menu "Storage (core and SCSI commands)"
> >>  
> >>  config SCSI
> >> -	tristate "SCSI device support"
> >> +	tristate "Storage support (core and SCSI commands)"
> >>  	depends on BLOCK
> >>  	select SCSI_DMA if HAS_DMA
> >>  	---help---
> >> ...
> > 
> > What is "storage support"?
> > SATA?
> > PATA?
> > USB mass storage?
> > MMC?
> > MTD?
> 
> What is "Networking"?  Ethernet?  Infiniband?  ...?

Different to CONFIG_SCSI, CONFIG_NET=n is so exotic that we should 
change it to no longer show users the question unless CONFIG_EMBEDDED=y.

> > Whether or not a driver uses the SCSI layer is an implementation detail 
> > (it even differs for the two USB mass storage implementations and the 
> > two PATA implementations in the kernel) the user shouldn't have to know 
> > about.
> > 
> > I don't see any reason why CONFIG_SCSI should have to stay user-visible 
> > at all after your patch.
> 
> Vice versa, I don't see any reason for "select SCSI" anywhere after my
> patch.

If users who don't need it now enable CONFIG_SCSI (and drivers/ide/ 
usage is not that uncommon) that's a regression in the user interface.

If the lowlevel SCSI drivers move into a separate menu as your patch 
does, we simply no longer have any good reason for bothering the user 
with the CONFIG_SCSI.

> Stefan Richter

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

