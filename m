From: Adrian Bunk <bunk@kernel.org>
Subject: Re: [RFC PATCH] SCSI: split Kconfig menu into two
Date: Sat, 15 Sep 2007 15:53:14 +0200
Message-ID: <20070915135314.GS3563@stusta.de>
References: <46EAAAC1.3050409@s5r6.in-berlin.de> <tkrat.d922469e152fe0f3@s5r6.in-berlin.de> <tkrat.913e8b183cdf7888@s5r6.in-berlin.de> <20070914190033.GA4003@uranus.ravnborg.org> <20070914190609.GN3563@stusta.de> <tkrat.552dbee831c88bbe@s5r6.in-berlin.de> <20070915114055.GP3563@stusta.de> <46EBCEF1.4030702@s5r6.in-berlin.de> <20070915125055.GQ3563@stusta.de> <46EBDC06.3030202@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:56597 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751973AbXIONxE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Sep 2007 09:53:04 -0400
Content-Disposition: inline
In-Reply-To: <46EBDC06.3030202@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, James Bottomley <james.bottomley@steeleye.com>, linux-scsi@vger.kernel.org, Jeff Garzik <jeff@garzik.org>, Andi Kleen <andi@firstfloor.org>, Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org

On Sat, Sep 15, 2007 at 03:20:06PM +0200, Stefan Richter wrote:
> Adrian Bunk wrote:
> >>> There should first be the lowlevel SCSI, SATA, USB etc. drivers, these 
> >>> drivers should select CONFIG_SCSI, and then the menu offering support 
> >>> for disk, CD,...
> ...
> > If users who don't need it now enable CONFIG_SCSI (and drivers/ide/ 
> > usage is not that uncommon) that's a regression in the user interface.
> 
> Aha, first all interconnects/transports are configured.  If none of them
> 'select'ed SCSI, the menu for sd, sr, st stays invisible.  Otherwise it
> is exposed.
> 
> It still doesn't entirely clarify whether users need sd, sr, st, and
> whether thy need sd for the disk with root filesystem.

If you want to do it in a really perfect way, help texts aren't the 
solution. You'll have to make the options like CONFIG_BLK_DEV_SR no 
longer be user visible and select'ed through dummy options like e.g.:

config USB_STORAGE
        tristate "USB Mass Storage support"
        depends on USB
	select SCSI
	help
	  ...

config USB_STORAGE_SD
	tristate "USB Mass Storage hard disk support"
	depends on USB_STORAGE
	select BLK_DEV_SD
	help
	  ...

config USB_STORAGE_SR
        tristate "USB Mass Storage CD/DVD support"
        depends on USB_STORAGE
	select BLK_DEV_SR
        help
          ...


> Stefan Richter

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

