From: Jens Axboe <axboe@suse.de>
Subject: Re: CDC_RAM for lk 2.4, PATCH proposed
Date: Wed, 19 May 2004 10:15:35 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040519081534.GE30348@suse.de>
References: <1083116778.3899.7.camel@patibmrh9> <1084897080.3746.38.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:28128 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S264105AbUESIP5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 May 2004 04:15:57 -0400
Content-Disposition: inline
In-Reply-To: <1084897080.3746.38.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org, John McKell <McKellj@iomega.com>

On Tue, May 18 2004, Pat LaVarre wrote:
> In the absence of a consensus over a more elegant resolution, I'm
> getting by for now with the following, dramatically concise,
> alternative.
> 
> Pat LaVarre
> 
> ----- Forwarded Message -----
> ...
> 
> grep in the rewritable-patch-0.3b/rewrite-2.4.26.patch of
> http://sourceforge.net/projects/iomrrdtools/ reminds me the source files
> at issue are:
> 
> include/linux/cdrom.h
> drivers/ide/ide-cd.h
> drivers/ide/ide-cd.c
> drivers/scsi/sr.c
> drivers/cdrom/cdrom.c
> 
> The following two file patch gives me the result:
> 
> $ sudo rrd scan
> /dev/scd0 is Iomega RRD 74.B rw
> /dev/hdc is Iomega RRD 74.B rw
> $
> $ sudo dd of=/dev/scd0 bs=64K count=1 if=/dev/zero
> 1+0 records in
> 1+0 records out
> $
> $ sudo dd of=/dev/hdc bs=64K count=1 if=/dev/zero
> 1+0 records in
> 1+0 records out
> $
> 
> rather than the kernel.org 2.4.18 default:
> 
> $ sudo rrd scan
> /dev/scd0 is Iomega RRD 74.B rw
> /dev/hdc is Iomega RRD 74.B rw
> $
> $ sudo dd of=/dev/scd0 bs=64K skip=0 count=1 if=/dev/zero
> dd: opening `/dev/scd0': Read-only file system
> $
> $ sudo dd of=/dev/hdc bs=64K skip=0 count=1 if=/dev/zero
> dd: opening `/dev/hdc': Read-only file system
> $
> 
> Pat LaVarre
> 
> diff -Nurp linux-2.4.18/include/linux/cdrom.h linux-2.4.18-pel/include/linux/cdrom.h
> diff -Nurp linux-2.4.18/drivers/ide/ide-cd.h linux-2.4.18-pel/drivers/ide/ide-cd.h
> diff -Nurp linux-2.4.18/drivers/ide/ide-cd.c linux-2.4.18-pel/drivers/ide/ide-cd.c
> --- linux-2.4.18/drivers/ide/ide-cd.c	2002-02-25 12:37:57.000000000 -0700
> +++ linux-2.4.18-pel/drivers/ide/ide-cd.c	2004-05-18 08:55:14.000000000 -0600
> @@ -2599,6 +2599,13 @@ int ide_cdrom_get_capabilities(ide_drive
>  		if (!stat)
>  			break;
>  	} while (--attempts);
> +#if 1 /* see all DVD/CD drives as DVD-RAM/ DVD-ROM compatible */
> +	if (!stat) {
> +		cap->dvd_rom = 1;
> +		cap->dvd_ram_read = 1;
> +		cap->dvd_ram_write = 1;
> +	}
> +#endif
>  	return stat;
>  }

This looks incredibly odd - if we succeed in getting the mode sense
capabilities page, you force setting og dvd-rom/ram?!

> diff -Nurp linux-2.4.18/drivers/scsi/sr.c linux-2.4.18-pel/drivers/scsi/sr.c
> --- linux-2.4.18/drivers/scsi/sr.c	2002-02-25 12:38:04.000000000 -0700
> +++ linux-2.4.18-pel/drivers/scsi/sr.c	2004-05-18 08:55:53.000000000 -0600
> @@ -709,6 +709,10 @@ void get_capabilities(int i)
>  		return;
>  	}
>  	n = buffer[3] + 4;
> +#if 1 /* see all DVD/CD drives as DVD-RAM/ DVD-ROM compatible */
> +	buffer[n + 2] |= 0x28; /* readable: x20 = DVD-RAM, x08 = DVD-ROM */
> +	buffer[n + 3] |= 0x20; /* writable: x20 = DVD-RAM */
> +#endif
>  	scsi_CDs[i].cdi.speed = ((buffer[n + 8] << 8) + buffer[n + 9]) / 176;
>  	scsi_CDs[i].readcd_known = 1;
>  	scsi_CDs[i].readcd_cdda = buffer[n + 5] & 0x01;
> diff -Nurp linux-2.4.18/drivers/cdrom/cdrom.c linux-2.4.18-pel/drivers/cdrom/cdrom.c

Ditto here. Please explain your reasoning for this patch. And do base
patches on recent kernels please, 2.4.18 is over 2 years old.

-- 
Jens Axboe

