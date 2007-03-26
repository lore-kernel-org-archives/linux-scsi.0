From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] PCMCIA: Allow PCMCIA SCSI drivers to be built into the
 kernel.
Date: Mon, 26 Mar 2007 15:40:13 +0200
Message-ID: <4607CD3D.7080400@s5r6.in-berlin.de>
References: <Pine.LNX.4.64.0703251353260.25176@CPE00045a9c397f-CM001225dbafb6>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:56823 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbXCZNkV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Mar 2007 09:40:21 -0400
In-Reply-To: <Pine.LNX.4.64.0703251353260.25176@CPE00045a9c397f-CM001225dbafb6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Robert P. J. Day" <rpjday@mindspring.com>, linux-scsi@vger.kernel.org, linux-pcmcia@lists.infradead.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

On 3/25/2007 7:59 PM, Robert P. J. Day wrote:
> Remove the Kconfig requirement that the PCMCIA SCSI drivers be built
> only as modules, and allow them to be built into the kernel.
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> 
> ---
> 
> i imagine there's a historical reason for these drivers being forced
> to be built only as modules.

(I don't know. Maybe hot-ejection or re-insertion is broken?)

> and i'm not sure whether i should have
> CCed the SCSI folks, the PCMCIA folks, or both.  or whatever.

I'd say, if in doubt send to both of these, instead of LKML.

> compile-tested on x86 with "make allyesconfig".
> 
> diff --git a/drivers/scsi/pcmcia/Kconfig b/drivers/scsi/pcmcia/Kconfig
> index eac8e17..7dd787f 100644
> --- a/drivers/scsi/pcmcia/Kconfig
> +++ b/drivers/scsi/pcmcia/Kconfig
> @@ -3,11 +3,11 @@
>  #
> 
>  menu "PCMCIA SCSI adapter support"
> -	depends on SCSI!=n && PCMCIA!=n && MODULES
> +	depends on SCSI!=n && PCMCIA!=n
> 
>  config PCMCIA_AHA152X
>  	tristate "Adaptec AHA152X PCMCIA support"
> -	depends on m && !64BIT
> +	depends on !64BIT
>  	select SCSI_SPI_ATTRS
>  	help
>  	  Say Y here if you intend to attach this type of PCMCIA SCSI host
> @@ -18,7 +18,6 @@ config PCMCIA_AHA152X
> 
>  config PCMCIA_FDOMAIN
>  	tristate "Future Domain PCMCIA support"
> -	depends on m
>  	help
>  	  Say Y here if you intend to attach this type of PCMCIA SCSI host
>  	  adapter to your computer.
> @@ -28,7 +27,7 @@ config PCMCIA_FDOMAIN
> 
>  config PCMCIA_NINJA_SCSI
>  	tristate "NinjaSCSI-3 / NinjaSCSI-32Bi (16bit) PCMCIA support"
> -	depends on m && !64BIT
> +	depends on !64BIT
>  	help
>  	  If you intend to attach this type of PCMCIA SCSI host adapter to
>  	  your computer, say Y here and read
> @@ -62,7 +61,6 @@ config PCMCIA_NINJA_SCSI
> 
>  config PCMCIA_QLOGIC
>  	tristate "Qlogic PCMCIA support"
> -	depends on m
>  	help
>  	  Say Y here if you intend to attach this type of PCMCIA SCSI host
>  	  adapter to your computer.
> @@ -72,7 +70,6 @@ config PCMCIA_QLOGIC
> 
>  config PCMCIA_SYM53C500
>  	tristate "Symbios 53c500 PCMCIA support"
> -	depends on m
>  	help
>  	  Say Y here if you have a New Media Bus Toaster or other PCMCIA
>  	  SCSI adapter based on the Symbios 53c500 controller.


-- 
Stefan Richter
-=====-=-=== --== ==-=-
http://arcgraph.de/sr/
