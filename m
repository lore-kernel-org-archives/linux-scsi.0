From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] DVD-R capability flag set incorrectly, /proc formatting fix
Date: Tue, 10 Feb 2004 09:52:26 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040210085226.GB4109@suse.de>
References: <1076369160.3594.6.camel@lintest.iomegacorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:31891 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S265791AbUBJIwa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2004 03:52:30 -0500
Content-Disposition: inline
In-Reply-To: <1076369160.3594.6.camel@lintest.iomegacorp.com>
List-Id: linux-scsi@vger.kernel.org
To: John McKell <mckellj@iomega.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Feb 09 2004, John McKell wrote:
> This patch for scsi/sr.c and cdrom/cdrom.c persuades 
> /proc/sys/dev/cdrom/info to report that connecting a drive via USB 
> rather than ATAPI in fact does not make it able to write DVD-R.
> 
> In linux-2.6.2 without this patch, when sr0 and hdd are the same type
> of device connected via USB and ATAPI respectively, I see:
> 
> $ cat /proc/sys/dev/cdrom/info:
> drive name:             sr1     sr0     hdd
> ...
> Can write CD-R:         1       0       0
> Can write CD-RW:        1       0       0
> Can read DVD:           0       0       0
> Can write DVD-R:        1       1       0
> Can write DVD-RAM:      0       0       0
> Can read MRW:           0               0               0
> Can write MRW:          0               0               0
> 
> With this patch applied, instead I see:
> 
> $ cat /proc/sys/dev/cdrom/info:
> drive name:             sr1     sr0     hdd
> ...
> Can write CD-R:         1       0       0
> Can write CD-RW:        1       0       0
> Can read DVD:           0       0       0
> Can write DVD-R:        0       0       0
> Can write DVD-RAM:      0       0       0
> Can read MRW:           0       0       0
> Can write MRW:          0       0       0
> 
> The sr1 device in particular is an ordinary CD-RW that in fact cannot 
> write DVD-R.
> 
> While messing with this code, I also thought to tweak the /proc 
> formatting to align the tabbed columns.
> 
> ---John McKell, Iomega Corp
> 
> diff -Nurp linux-2.6.2/drivers/scsi/sr.c linux/drivers/scsi/sr.c
> --- linux-2.6.2/drivers/scsi/sr.c	2004-02-03 20:43:19.000000000 -0700
> +++ linux/drivers/scsi/sr.c	2004-02-09 13:59:10.000000000 -0700
> @@ -795,10 +795,9 @@ static void get_capabilities(struct scsi
>  	if ((buffer[n + 2] & 0x8) == 0)
>  		/* not a DVD drive */
>  		cd->cdi.mask |= CDC_DVD;
> -	if ((buffer[n + 3] & 0x20) == 0) {
> +	if ((buffer[n + 3] & 0x20) == 0) 
>  		/* can't write DVD-RAM media */
>  		cd->cdi.mask |= CDC_DVD_RAM;
> -	} else
>  	if ((buffer[n + 3] & 0x10) == 0)
>  		/* can't write DVD-R media */
>  		cd->cdi.mask |= CDC_DVD_R;

Good spotting, that's surely a bug!

-- 
Jens Axboe

