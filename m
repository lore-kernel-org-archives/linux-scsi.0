From: Jens Axboe <axboe@suse.de>
Subject: Re: writable mmc profiles actually are writable
Date: Mon, 6 Oct 2003 20:22:23 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031006182223.GF972@suse.de>
References: <1064271322.4797.9.camel@patehci2> <1064847281.24854.2.camel@patehci2> <1064850600.25057.7.camel@patehci2> <20030929164654.GS15415@suse.de> <1064855570.3184.3.camel@patehci2> <1064865746.4262.63.camel@patehci2> <1065460336.10804.1.camel@patehci2> <1065463946.5185.8.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:5343 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S263190AbTJFSWb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Oct 2003 14:22:31 -0400
Content-Disposition: inline
In-Reply-To: <1065463946.5185.8.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org

On Mon, Oct 06 2003, Pat LaVarre wrote:
> > Newsgroups: mlist.linux.scsi
> > Date: 2003-09-10 16:00:27 PST
> > Subject: Re: [PATCH] mount -w of dvd+rw etc. in vanilla 2.6
> > From: Patrick Mansfield (patmans@us.ibm.com)
> >
> > Should sd.c and sr.c be calling set_device_ro?
> > (after adding a read only block device, or
> > changing back to read/write)?
> 
> That good question stands open, I think.
> 
> The following inline plain text, now revved for -test6 & posted here,
> allows modprobe to overcome such uncooperative attitudes as:
> 
> $ sudo dd if=/dev/scd2 bs=2k count=1 | wc
> 1+0 records in
> 1+0 records out
>       0       0    2048
> $
> $ sudo dd of=/dev/scd2 bs=2k count=1 if=/dev/zero
> dd: opening `/dev/scd2': Read-only file system
> $
> 
> Allowing dd, mkudffs, etc. are the good consequences.  The evil
> consequences I do not yet know.  I do notice we have achieved
> writability without extending the enumeration that `cat
> /proc/sys/dev/cdrom/info` dumps:
> 
> Can write CD-R:         0
> Can write CD-RW:        0
> Can read DVD:           0
> Can write DVD-R:        0
> Can write DVD-RAM:      0

And the device isn't writable, so...?

> diff -ur linux-2.6.0-test6/drivers/cdrom/cdrom.c linux/drivers/cdrom/cdrom.c
> --- linux-2.6.0-test6/drivers/cdrom/cdrom.c	2003-09-27 18:50:10.000000000 -0600
> +++ linux/drivers/cdrom/cdrom.c	2003-10-06 11:53:41.826299728 -0600
> @@ -426,8 +426,8 @@
>  	if ((fp->f_flags & O_NONBLOCK) && (cdi->options & CDO_USE_FFLAGS))
>  		ret = cdi->ops->open(cdi, 1);
>  	else {
> -		if ((fp->f_mode & FMODE_WRITE) && !CDROM_CAN(CDC_DVD_RAM))
> -			return -EROFS;
> +//		if ((fp->f_mode & FMODE_WRITE) && !CDROM_CAN(CDC_DVD_RAM))
> +//			return -EROFS;
>  
>  		ret = open_for_data(cdi);
>  	}
> diff -ur linux-2.6.0-test6/drivers/scsi/sr.c linux/drivers/scsi/sr.c
> --- linux-2.6.0-test6/drivers/scsi/sr.c	2003-09-27 18:50:13.000000000 -0600
> +++ linux/drivers/scsi/sr.c	2003-10-06 11:51:59.655832000 -0600
> @@ -327,8 +327,8 @@
>  	}
>  
>  	if (rq_data_dir(SCpnt->request) == WRITE) {
> -		if (!cd->device->writeable)
> -			return 0;
> +//		if (!cd->device->writeable)
> +//			return 0;
>  		SCpnt->cmnd[0] = WRITE_10;
>  		SCpnt->sc_data_direction = SCSI_DATA_WRITE;
>  	} else if (rq_data_dir(SCpnt->request) == READ) {

This is obviously wrong. What are you trying to do? The uniform layer
uses CDC_DVD_RAM as meaning randomly writable media, the only thing the
kernel supports out of the box. So that is what the test is for.

Honestly, I have no idea what your are trying to pull. Calling read-only
media failing to be opened read-write as "uncooperative" is confusing,
borderline amusing :). Explain yourself in clear text, thanks.

-- 
Jens Axboe

