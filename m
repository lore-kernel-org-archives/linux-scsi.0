From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] CDC_MMC_WR
Date: Sat, 11 Oct 2003 10:21:44 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031011082144.GK10614@suse.de>
References: <1065832684.2877.37.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:60128 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262692AbTJKIV4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Oct 2003 04:21:56 -0400
Content-Disposition: inline
In-Reply-To: <1065832684.2877.37.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org

On Fri, Oct 10 2003, Pat LaVarre wrote:
> Jens A:
> 
> > > > Please add ...
> > > > to cdrom.c instead ... GPCMD_GET_CONFIGURATION
> > > 
> > > Happily will do.  I'll continue to reply
> > > as I progress or not.
> >
> > Great, thanks.
> 
> Please tell me what we think of this new patch?
> 
> You can see I've guessed I now should launch a new thread. The
> linux-scsi thread "writable mmc profiles actually are writable" walked
> us thru every painful step of me learning to write this patch.
> 
> So far I see Three design goals:
> 
> a) Add CDC_MMC_WR, masked by default, to: include/cdrom.h, to
> drivers/ide/ide-cd.c, and to drivers/scsi/sr.c.
> 
> b) Correct device->writeable in sr.c sometime after
> drivers/cdrom/cdrom.c discovers it was wrong.
> 
> c) Teach cdrom.c to discover CDC_MMC_WR.
> 
> That last goal I see divide into Eight changes to cdrom.c:
> 
> c1) Refuse to pass thru writes only if CDC_MMC_WR, no matter
> CDC_DVD_RAM.
> 
> c2) Define cdrom_get_cdc and call cdrom_get_cdc only if register_cdrom
> succeeds, just before register_cdrom does succeed.
> 
> c3) In cdrom_get_cdc, say &= ~CDC_MMC_WR if ide-cd or sr said &=
> ~CDC_DVD_RAM.
> 
> c4) In cdrom_get_cdc, also say &= ~CDC_MMC_WR if cdrom_get_capabilities
> ok and cdrom_get_configuration ok and the profile fetched is any one of
> the seven standard "random writable" profiles of mmc except not the
> x001A dvd+rw profile that maybe can't be overwritten more than 1000
> times in place, per Andy Polyakov's:
> http://fy.chalmers.se/~appro/linux/DVD+RW/#udf
> 
> c5) Define cdrom_get_capabilities in terms of cdrom_mode_sense by
> block-copy-edit of other cdrom.c source.
> 
> c6) Define cdrom_get_configuration in terms of cdo->generic_packet by
> block-copy-edit of other cdrom.c source
> 
> c7) Add a line of text to /proc/sys/dev/cdrom/info to reveal CDC_MMC_WR.
> 
> c8) Update change history, REVISION, VERSION.
> 
> Please tell me what we think of this new patch?

Lots of small nits, but in general I like it.

> +   3.13 Oct 10, 2003 - Jens Axboe <axboe@suse.de>
> +  -- Pass writes thru to all CDC_MMC_WR profiles, not just CDC_DVD_RAM.

That should be you :)

> +static int cdrom_get_capabilities(struct cdrom_device_info *cdi)
> +{
> +	struct cdrom_generic_command cgc0;
> +	struct cdrom_generic_command * cgc = &cgc0;

I see this repeated, what is the point? you are wasting 4/8 bytes on the
stack each time.


> +	u_char buf[0x18]; /* ide-cd length = x18, sr length = x80 */
> +	int ret;
> +	memset(cgc, 0, sizeof *cgc);

sizeof(*cgc);

> +	memset(&buf[0], 0, sizeof(buf));
> +	cgc->buffer = buf;
> +	cgc->buflen = sizeof buf;

sizeof(buf). There's a init_cdrom_command() for these types of
situations, please use it.

> +	ret = cdrom_mode_sense(cdi, cgc, GPMODE_CAPABILITIES_PAGE, 0);
> +	return ret;

No need for ret, either.

> +}
> +
> +static int cdrom_get_configuration(struct cdrom_device_info *cdi)
> +{
> +	struct cdrom_generic_command cgc0;
> +	struct cdrom_generic_command * cgc = &cgc0;

Ditto

> +	struct cdrom_device_ops *cdo = cdi->ops;
> +	u_char buf[8];
> +	int ret;
> +	int profile;
> +	memset(cgc, 0, sizeof *cgc);

Ditto

> +	memset(&buf[0], 0, sizeof(buf));
> +	cgc->buffer = buf;
> +	cgc->buflen = sizeof buf;
> +	cgc->cmd[0] = GPCMD_GET_CONFIGURATION;
> +	cgc->cmd[7] = cgc->buflen >> 8;
> +	cgc->cmd[8] = cgc->buflen & 0xff;
> +	cgc->data_direction = CGC_DATA_READ;
> +	ret = cdo->generic_packet(cdi, cgc);
> +	if (ret) return ret;
> +	profile = buf[6] << 8 | buf[7];
> +	cdinfo(CD_REG_UNREG, "profile x%04X\n", profile);
> +	switch (profile) {
> +		case 0x0001: /* Non-Removable Disk */
> +		case 0x0002: /* Removable Disk */
> +		case 0x0003: /* Magneto-Optical Erasable */
> +		case 0x0005: /* AS-MO */
> +		case 0x0012: /* DVD-RAM */
> +		case 0x0022: /* DDCD-RW */
> +			cdi->mask &= ~CDC_MMC_WR;
> +			break;
> +		case 0x001A: /* DVD+RW = not very rewritable in place */
> +			break;
> +		default:
> +			break;
> +	}
> +	return ret;

ret must be 0 here, so return 0 to make that clear.

> +static void cdrom_get_cdc(struct cdrom_device_info *cdi)
> +{
> +	cdinfo(CD_REG_UNREG, "cdrom_get_cdc\n");
> +	if (CDROM_CAN(CDC_DVD_RAM)) {
> +		cdi->mask &= ~CDC_MMC_WR;
> +	} else if (cdrom_get_capabilities(cdi)) {
> +		cdinfo(CD_WARNING,  "GET_CAPABILITIES not\n");
> +	} else {
> +		if (cdrom_get_configuration(cdi)) {
> +			cdinfo(CD_WARNING,  "GET_CONFIGURATION not\n");
> +		}
> +	}
> +}

Ugly flow here. And what is the point of the cdrom_get_capabilities()
call? If you just want to see if it's supported, the probe sequence in
ide-cd/sr should already have done that. I'd greatly prefer something
ala:

static void cdrom_get_cdc(struct cdrom_device_info *cdi)
{
	cdrom_get_configuration(cdi);

	if (CDROM_CAN(CDC_DVD_RAM))
		cdi->mask &= ~CDC_MMC_WR
}

> @@ -426,8 +497,9 @@
>  	if ((fp->f_flags & O_NONBLOCK) && (cdi->options & CDO_USE_FFLAGS))
>  		ret = cdi->ops->open(cdi, 1);
>  	else {
> -		if ((fp->f_mode & FMODE_WRITE) && !CDROM_CAN(CDC_DVD_RAM))
> +		if ((fp->f_mode & FMODE_WRITE) && !CDROM_CAN(CDC_MMC_WR)) {
>  			return -EROFS;
> +		}
>  
>  		ret = open_for_data(cdi);
>  	}
> @@ -2406,6 +2478,10 @@
>  	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
>  	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_DVD_RAM) != 0);
>  
> +	pos += sprintf(info+pos, "\nTolerates random write:");
> +	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
> +	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_MMC_WR) != 0);
> +
>  	strcpy(info+pos,"\n\n");
>  		
>          return proc_dostring(ctl, write, filp, buffer, lenp);
> diff -Nur linux-2.6.0-test7/include/linux/cdrom.h linux/include/linux/cdrom.h
> --- linux-2.6.0-test7/include/linux/cdrom.h	2003-10-08 13:24:00.000000000 -0600
> +++ linux/include/linux/cdrom.h	2003-10-10 15:37:16.000000000 -0600
> @@ -388,6 +388,7 @@
>  #define CDC_DVD_R		0x10000	/* drive can write DVD-R */
>  #define CDC_DVD_RAM		0x20000	/* drive can write DVD-RAM */
>  #define CDC_MO_DRIVE		0x40000 /* drive is an MO device */
> +#define CDC_MMC_WR		0x80000	/* profile includes random write */
>  
>  /* drive status possibilities returned by CDROM_DRIVE_STATUS ioctl */
>  #define CDS_NO_INFO		0	/* if not implemented */
> diff -Nur linux-2.6.0-test7/drivers/ide/ide-cd.c linux/drivers/ide/ide-cd.c
> --- linux-2.6.0-test7/drivers/ide/ide-cd.c	2003-10-08 13:24:04.000000000 -0600
> +++ linux/drivers/ide/ide-cd.c	2003-10-10 15:36:33.000000000 -0600
> @@ -2822,7 +2822,7 @@
>  				CDC_MEDIA_CHANGED | CDC_PLAY_AUDIO | CDC_RESET |
>  				CDC_IOCTLS | CDC_DRIVE_STATUS | CDC_CD_R |
>  				CDC_CD_RW | CDC_DVD | CDC_DVD_R| CDC_DVD_RAM |
> -				CDC_GENERIC_PACKET | CDC_MO_DRIVE,
> +				CDC_GENERIC_PACKET | CDC_MO_DRIVE | CDC_MMC_WR,
>  	.generic_packet		= ide_cdrom_packet,
>  };
>  
> @@ -2832,7 +2832,7 @@
>  	struct cdrom_device_info *devinfo = &info->devinfo;
>  
>  	devinfo->ops = &ide_cdrom_dops;
> -	devinfo->mask = 0;
> +	devinfo->mask = CDC_MMC_WR;

Must be left-over junk, should still be 0 here.

>  	devinfo->speed = CDROM_STATE_FLAGS(drive)->current_speed;
>  	devinfo->capacity = nslots;
>  	devinfo->handle = (void *) drive;
> diff -Nur linux-2.6.0-test7/drivers/scsi/sr.c linux/drivers/scsi/sr.c
> --- linux-2.6.0-test7/drivers/scsi/sr.c	2003-10-08 13:24:03.000000000 -0600
> +++ linux/drivers/scsi/sr.c	2003-10-10 15:48:12.000000000 -0600
> @@ -67,7 +67,8 @@
>  	(CDC_CLOSE_TRAY|CDC_OPEN_TRAY|CDC_LOCK|CDC_SELECT_SPEED| \
>  	 CDC_SELECT_DISC|CDC_MULTI_SESSION|CDC_MCN|CDC_MEDIA_CHANGED| \
>  	 CDC_PLAY_AUDIO|CDC_RESET|CDC_IOCTLS|CDC_DRIVE_STATUS| \
> -	 CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R|CDC_DVD_RAM|CDC_GENERIC_PACKET)
> +	 CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R|CDC_DVD_RAM|CDC_GENERIC_PACKET| \
> +	 CDC_MMC_WR)
>  
>  static int sr_probe(struct device *);
>  static int sr_remove(struct device *);
> @@ -327,8 +328,12 @@
>  	}
>  
>  	if (rq_data_dir(SCpnt->request) == WRITE) {
> -		if (!cd->device->writeable)
> -			return 0;
> +		if (!cd->device->writeable) {
> +			if ((cd->cdi.mask & CDC_MMC_WR) != 0) {
> +				return 0;
> +			}
> +			cd->device->writeable = 1;
> +		}

This is ugly, don't hack around it like that. If CDC_MMC_WR set, sr
should have set device->writeable as well. Needs to go.


>  		SCpnt->cmnd[0] = WRITE_10;
>  		SCpnt->sc_data_direction = SCSI_DATA_WRITE;
>  	} else if (rq_data_dir(SCpnt->request) == READ) {
> @@ -550,7 +555,7 @@
>  
>  	cd->cdi.ops = &sr_dops;
>  	cd->cdi.handle = cd;
> -	cd->cdi.mask = 0;
> +	cd->cdi.mask = CDC_MMC_WR;
>  	cd->cdi.capacity = 1;
>  	sprintf(cd->cdi.name, "sr%d", minor);

Ditto, why are you changing this?! Why do you think CDC_MMC_WR is
special compared to the other mask flags?

-- 
Jens Axboe

