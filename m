From: Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH update] SCSI: update Kconfig help text to indicate SCSI
	core's widespread usage
Date: Sat, 15 Sep 2007 14:59:24 +0200
Message-ID: <20070915125924.GR3563@stusta.de>
References: <20070912224655.GC3563@stusta.de> <46EAA08F.30703@s5r6.in-berlin.de> <20070914151522.GL3563@stusta.de> <46EAAAC1.3050409@s5r6.in-berlin.de> <tkrat.d922469e152fe0f3@s5r6.in-berlin.de> <20070914185434.GD5386@csclub.uwaterloo.ca> <tkrat.e1d898d6a272d681@s5r6.in-berlin.de> <20070914202102.GE5386@csclub.uwaterloo.ca> <tkrat.f4379d6e5f1ce499@s5r6.in-berlin.de> <tkrat.0e73b94c1e80a481@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58415 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751261AbXIOM7O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Sep 2007 08:59:14 -0400
Content-Disposition: inline
In-Reply-To: <tkrat.0e73b94c1e80a481@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>, James Bottomley <james.bottomley@steeleye.com>, linux-scsi@vger.kernel.org, Jeff Garzik <jeff@garzik.org>, Andi Kleen <andi@firstfloor.org>, Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 11:14:21PM +0200, Stefan Richter wrote:
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
> 
> And one more update:
> There is SAS too, and I forgot 'is' in "on a disk which __ accessed via".
> 
>  drivers/scsi/Kconfig |   67 ++++++++++++++++++++++---------------------
>  1 file changed, 35 insertions(+), 32 deletions(-)
> 
> Index: linux-2.6.23-rc6/drivers/scsi/Kconfig
> ===================================================================
> --- linux-2.6.23-rc6.orig/drivers/scsi/Kconfig
> +++ linux-2.6.23-rc6/drivers/scsi/Kconfig
> @@ -12,23 +12,31 @@ config SCSI
>  	depends on BLOCK
>  	select SCSI_DMA if HAS_DMA
>  	---help---
> -	  If you want to use a SCSI hard disk, SCSI tape drive, SCSI CD-ROM or
> -	  any other SCSI device under Linux, say Y and make sure that you know
> -	  the name of your SCSI host adapter (the card inside your computer
> -	  that "speaks" the SCSI protocol, also called SCSI controller),
> -	  because you will be asked for it.
> -
> -	  You also need to say Y here if you have a device which speaks
> -	  the SCSI protocol.  Examples of this include the parallel port
> -	  version of the IOMEGA ZIP drive, USB storage devices, Fibre
> -	  Channel, FireWire storage and the IDE-SCSI emulation driver.
> +	  This option enables core support for SCSI protocols.
> +	  You need it
> +	  - for classic parallel SCSI hardware,
> +	  - for newer SCSI transports such as Fibre Channel, FireWire storage,
> +	    SAS, or iSCSI,
> +	  - for non-SCSI hardware which speaks SCSI protocols, such as USB
> +	    storage devices or the parallel port version of Iomega Zip drive,


but not for CONFIG_BLK_DEV_UB


> +	  - for non-SCSI hardware whose drivers translate from and to SCSI
> +	    protocols, most notably all Serial ATA drivers, and Parallel ATA
> +	    via the ATA configuration option.


but not for CONFIG_BLK_DEV_IDE_SATA


>  	  To compile this driver as a module, choose M here and read
>  	  <file:Documentation/scsi/scsi.txt>.
>  	  The module will be called scsi_mod.
>  
>  	  However, do not compile this as a module if your root file system
> -	  (the one containing the directory /) is located on a SCSI device.
> +	  (the one containing the directory /) is located on a SCSI device
> +	  or on a device whose driver represents it as SCSI device, as
> +	  indicated above.  Choose Y in this case, or set up an initrd.
> +
> +	  Subsequent options in this menu enable specific SCSI command set
> +	  support for harddisks, CD/DVD-ROM/R/W, tapes etc..  This menu also
> +	  presents options for specific SCSI controllers, while options for
> +	  some other SCSI transports and all non-SCSI controllers are located
> +	  in other menus (SATA, USB, FireWire etc.).
>...


You expect all kconfig users to read and completely understand this?

Although it's no longer required that the user sees the CONFIG_SCSI 
option at all since we can determine automaically when it's required
and when not?


> Stefan Richter

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

