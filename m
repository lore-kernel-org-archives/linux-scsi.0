From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] fix cdrom mt rainier probe
Date: Fri, 16 Jul 2004 18:02:24 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040716160224.GA2402@suse.de>
References: <20040716122845.GE2025@suse.de> <1089993519.7028.26.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:39089 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S266575AbUGPQCe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jul 2004 12:02:34 -0400
Content-Disposition: inline
In-Reply-To: <1089993519.7028.26.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org

On Fri, Jul 16 2004, Pat LaVarre wrote:
> diff -urp linux-2.6.8-rc1/drivers/cdrom/cdrom.c linux-2.6.8-rc1-pel/drivers/cdrom/cdrom.c
> --- linux-2.6.8-rc1/drivers/cdrom/cdrom.c	2004-07-13 08:26:02.000000000 -0600
> +++ linux-2.6.8-rc1-pel/drivers/cdrom/cdrom.c	2004-07-16 09:40:22.765020896 -0600
> @@ -897,10 +897,10 @@ int cdrom_open(struct cdrom_device_info 
>  			goto err;
>  		if (fp->f_mode & FMODE_WRITE) {
>  			ret = -EROFS;
> -			if (!CDROM_CAN(CDC_RAM))
> -				goto err;
>  			if (cdrom_open_write(cdi))
>  				goto err;
> +			if (!CDROM_CAN(CDC_RAM))
> +				goto err;
>  			ret = 0;
>  		}
>  	}
> diff -urp linux-2.6.8-rc1/drivers/ide/ide-cd.c linux-2.6.8-rc1-pel/drivers/ide/ide-cd.c
> --- linux-2.6.8-rc1/drivers/ide/ide-cd.c	2004-07-13 08:26:05.000000000 -0600
> +++ linux-2.6.8-rc1-pel/drivers/ide/ide-cd.c	2004-07-16 09:37:07.613688408 -0600
> @@ -785,14 +785,6 @@ static int cdrom_decode_status(ide_drive
>  				do_end_request = 1;
>  		} else if (sense_key == ILLEGAL_REQUEST ||
>  			   sense_key == DATA_PROTECT) {
> -			/*
> -			 * check if this was a write protected media
> -			 */
> -			if (rq_data_dir(rq) == WRITE) {
> -				printk("ide-cd: media marked write protected\n");
> -				set_disk_ro(drive->disk, 1);
> -			}
> -
>  			/* No point in retrying after an illegal
>  			   request or data protect error.*/
>  			ide_dump_status (drive, "command error", stat);
> @@ -3248,9 +3240,8 @@ int ide_cdrom_setup (ide_drive_t *drive)
>  	nslots = ide_cdrom_probe_capabilities (drive);
>  
>  	/*
> -	 * set correct block size and read-only for non-ram media
> +	 * set correct block size
>  	 */
> -	set_disk_ro(drive->disk, !CDROM_CONFIG_FLAGS(drive)->ram);
>  	blk_queue_hardsect_size(drive->queue, CD_FRAMESIZE);
>  
>  #if 0
> diff -urp linux-2.6.8-rc1/drivers/scsi/sr.c linux-2.6.8-rc1-pel/drivers/scsi/sr.c
> --- linux-2.6.8-rc1/drivers/scsi/sr.c	2004-07-13 08:26:16.000000000 -0600
> +++ linux-2.6.8-rc1-pel/drivers/scsi/sr.c	2004-07-15 14:29:34.000000000 -0600
> @@ -775,9 +775,6 @@ static void get_capabilities(struct scsi
>  		""
>  	};
>  
> -	/* Set read only initially */
> -	set_disk_ro(cd->disk, 1);
> -
>  	/* allocate a request for the TEST_UNIT_READY */
>  	SRpnt = scsi_allocate_request(cd->device, GFP_KERNEL);
>  	if (!SRpnt) {
> @@ -885,7 +882,6 @@ static void get_capabilities(struct scsi
>  	if ((cd->cdi.mask & (CDC_DVD_RAM | CDC_MRW_W | CDC_RAM)) !=
>  			(CDC_DVD_RAM | CDC_MRW_W | CDC_RAM)) {
>  		cd->device->writeable = 1;
> -		set_disk_ro(cd->disk, 0);
>  	}
>  
>  	scsi_release_request(SRpnt);
> 
> 
> 

This looks perfect! Have you tested it works as expected as well, with
rw and ro media?

-- 
Jens Axboe

