From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH][RFC] get rid of global array and ->init in sd.c and sr.c
Date: Wed, 23 Oct 2002 01:28:53 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021023082853.GA9341@beaverton.ibm.com>
References: <20021022210739.A10079@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021022210739.A10079@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, axboe@suse.dk, linux-scsi@vger.kernel.org

Looks good. I ran it on a system with ips, aic, scsi_debug and qla2x00
as a module. 

When I applied the patch I got a quite a few rejects on sd.c and sr.c. I
fixed up sd.c, but did not run sr.c. My view is based off James
scsi-misc-2.5.

I noticed the patch seems to include some of your driver_register
removals (preiously posted) in init_sd and exit_sd, but there are no
adds to scsi_register_device or scsi_unregister_device.

Christoph Hellwig [hch@lst.de] wrote:
> +	list_for_each(p, &sd_devlist) {
> +		sdkp = list_entry(p, struct scsi_disk, list);
>  		sdp = sdkp->device;
>  		if (sdp && (sdp->host == shp) && (sdp->id == scsi_id)) {
>  			retval = MKDEV_SD(dsk_nr);
>  			break;

Might consider using list_for_each_entry since you always do both.

> --- linux/drivers/scsi/sd.h	Mon Oct 21 20:34:15 2002
> +++ linux-scsi/drivers/scsi/sd.h	Tue Oct 22 17:24:02 2002
> @@ -12,32 +12,20 @@
>  #ifndef _SD_H
>  #define _SD_H
>  
> -#ifndef _SCSI_H
> -#include "scsi.h"
> -#endif
> -
> -#ifndef _GENDISK_H
> -#include <linux/genhd.h>
> -#endif
> -
>  typedef struct scsi_disk {
> +	struct list_head list;
>  	sector_t capacity;		/* size in 512-byte sectors */
>  	Scsi_Device *device;
> +	struct gendisk *gd;
>  	unsigned char media_present;
>  	unsigned char write_prot;
>  	unsigned WCE:1;         /* state of disk WCE bit */
>  	unsigned RCD:1;         /* state of disk RCD bit */
>  } Scsi_Disk;

I received a compile failures on sector_t until I put back the scsi.h
include.

-andmike
--
Michael Anderson
andmike@us.ibm.com

