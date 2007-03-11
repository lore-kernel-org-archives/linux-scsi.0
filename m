From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] make scsi_wait_scan always modular
Date: Sun, 11 Mar 2007 21:56:50 +0100 (CET)
Message-ID: <Pine.LNX.4.60.0703112141580.5942@poirot.grange>
References: <1173640604.3420.21.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34915 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932215AbXCKU4t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 Mar 2007 16:56:49 -0400
In-Reply-To: <1173640604.3420.21.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Hi

On Sun, 11 Mar 2007, James Bottomley wrote:

> Currently scsi_wait_scan is only built modular if SCSI is modular.
> However, it's perfectly possible for a built in SCSI still to have
> modular drivers and thus need scsi_wait_scan as a module.  Therefore,
> scsi_wait_scan should always be built as a module (unless the kernel
> doesn't support modules).
> 
> James
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 4cd280e..f3bc0f4 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -241,6 +241,12 @@ config SCSI_SCAN_ASYNC
>  	  You can override this choice by specifying "scsi_mod.scan=sync"
>  	  or async on the kernel's command line.
>  
> +config SCSI_WAIT_SCAN
> +	tristate
> +	default m
> +	depends on SCSI
> +	depends on MODULES
> +
>  menu "SCSI Transports"
>  	depends on SCSI
>  
> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
> index 79ecf4e..41c7883 100644
> --- a/drivers/scsi/Makefile
> +++ b/drivers/scsi/Makefile
> @@ -145,7 +145,7 @@ obj-$(CONFIG_CHR_DEV_SCH)	+= ch.o
>  # This goes last, so that "real" scsi devices probe earlier
>  obj-$(CONFIG_SCSI_DEBUG)	+= scsi_debug.o
>  
> -obj-$(CONFIG_SCSI)		+= scsi_wait_scan.o
> +obj-$(CONFIG_SCSI_WAIT_SCAN)	+= scsi_wait_scan.o

Which means, with this change you cannot build a kernel without module 
support but with scsi_wait_scan, which was possible before. Don't know if 
anybody would ever want to do this though...

Thanks
Guennadi
---
Guennadi Liakhovetski
