From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH 2.4] rewritable USB DVD-RAM vs. mode sense op choice
Date: Mon, 23 Aug 2004 17:48:51 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040823154850.GC2301@suse.de>
References: <1092673789.4297.7.camel@patlinux.iomegacorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:57731 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S265784AbUHWPuP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Aug 2004 11:50:15 -0400
Content-Disposition: inline
In-Reply-To: <1092673789.4297.7.camel@patlinux.iomegacorp.com>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org

On Mon, Aug 16 2004, Pat LaVarre wrote:
> Jens A:
> 
> 2.4.26 and 2.4.27 strace of dd of=, mount -w, etc. chokes via EROFS for
> USB DVD-RAM.  2.4.25 I have not tried.
> 
> This small patch substitutes the MMC op x5A "MODE SENSE (10)" for the op
> x1A that in t10.org PDT x05 is vendor-specific.  Such consideration
> persuades a standard DVD-RAM drive to admit it rewrites DVD-RAM discs.
> 
> Revising the CDB alone of course does not suffice: we also have to step
> past a different size of data in header.
> 
> Pat LaVarre
> 
> diff -urp linux-2.4.27/drivers/scsi/sr.c linux-2.4.27-pel/drivers/scsi/sr.c
> --- linux-2.4.27/drivers/scsi/sr.c	2003-06-13 08:51:36.000000000 -0600
> +++ linux-2.4.27-pel/drivers/scsi/sr.c	2004-08-16 10:08:37.000000000 -0600
> @@ -691,7 +691,7 @@ void get_sectorsize(int i)
>  
>  void get_capabilities(int i)
>  {
> -	unsigned char cmd[6];
> +	unsigned char cmd[16];
>  	unsigned char *buffer;
>  	int rc, n;
>  
> @@ -713,12 +713,12 @@ void get_capabilities(int i)
>  		printk(KERN_ERR "sr: out of memory.\n");
>  		return;
>  	}
> -	cmd[0] = MODE_SENSE;
> +	memset(cmd, '\0', sizeof cmd);

	memset(cmd, 0, sizeof(cmd));

> +	cmd[0] = MODE_SENSE_10;
>  	cmd[1] = (scsi_CDs[i].device->scsi_level <= SCSI_2) ?
>  		 ((scsi_CDs[i].device->lun << 5) & 0xe0) : 0;
>  	cmd[2] = 0x2a;
> -	cmd[4] = 128;
> -	cmd[3] = cmd[5] = 0;
> +	cmd[8] = 128;
>  	rc = sr_do_ioctl(i, cmd, buffer, 128, 1, SCSI_DATA_READ, NULL);

This gives me a bad vibe - I'm assuming your device is failing the
6-byte mode sense? This has to work with devices that don't support
MODE_SENSE_10, if you want it to work for you as well, then make the
MODE_SENSE_10 a fall back when MODE_SENSE fails. You cannot rely on the
change you made.

-- 
Jens Axboe

