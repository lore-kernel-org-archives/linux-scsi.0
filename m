From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] fix cdrom mt rainier probe
Date: Wed, 14 Jul 2004 07:41:33 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040714054133.GI3055@suse.de>
References: <1089741428.3806.3.camel@patibmrh9> <1089752141.3786.3.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:30351 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S267219AbUGNFle (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jul 2004 01:41:34 -0400
Content-Disposition: inline
In-Reply-To: <1089752141.3786.3.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org

On Tue, Jul 13 2004, Pat LaVarre wrote:
> > > Mt rainier probe must be deferred to media load time, ...
> > ...
> > something broke in deciding disc rewritable or not? ...
> > Only for /dev/hdd PATAPI, not for /dev/scd0 USB?
> 
> Can any of us easily sketch a legit fix for this?  By now we know,
> 
> a)
> 
> The key evil is not getting back 0 0 in reply to the query:
> 
> $ sudo blockdev --getro /dev/hdd /dev/scd0
> 1
> 0
> $
> 
> b)
> 
> A completely bogus hack of a workaround is:
> 
> sudo blockdev --setrw /dev/hdd
> 
> c)
> 
> Below is that same completely bogus hack, expressed as a kernel patch
> Not suitable for kernel.org.
> 
> Pat LaVarre
> http://linux-pel.blog-city.com/read/728344.htm
> 
> --- linux-2.6.8-rc1/drivers/ide/ide-cd.c	2004-07-13 08:26:05.000000000 -0600
> +++ linux-2.6.8-rc1-pel/drivers/ide/ide-cd.c	2004-07-13 14:33:40.000000000 -0600
> @@ -3251,6 +3251,7 @@ int ide_cdrom_setup (ide_drive_t *drive)
>  	 * set correct block size and read-only for non-ram media
>  	 */
>  	set_disk_ro(drive->disk, !CDROM_CONFIG_FLAGS(drive)->ram);
> +	set_disk_ro(drive->disk, 0);

Trace that backwards and find out why ->ram isn't getting set.

-- 
Jens Axboe

