From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH RESEND] SCSI not showing tray status correctly
Date: Tue, 30 Oct 2007 22:32:03 -0500
Message-ID: <1193801523.3321.138.camel@localhost.localdomain>
References: <20071027225830.585C8657DB@smtp.gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:33639 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752113AbXJaDcG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Oct 2007 23:32:06 -0400
In-Reply-To: <20071027225830.585C8657DB@smtp.gentoo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maarten Bressers <mbres@gentoo.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, axboe@kernel.dk, tasio@hierro.tasio.net, dsd@gentoo.org

On Sat, 2007-10-27 at 22:58 +0000, Maarten Bressers wrote:
> > This patch is too simplistic.  ide-cd.c:ide_cdrom_drive_status() looks
> > to be a reasonable implementation.  However, the worry is that
> > GET_EVENT_NOTIFICATION is a MMC command; devices not conforming to MMC
> > won't support it.  In theory, they should just return ILLEGAL_REQUEST,
> > but USB devices have been known to crash when given commands they don't
> > understand.  How widely tested has this been (if it's been in Gentoo
> > since 2004, then it's probably widely tested enough)?
> >
> > James
> >
> This patch hasn't been tested at all, I'm sorry if I gave you that
> impression, it isn't in Gentoo's patches, it's just been brought to our
> attention in the bug I linked too.
> 
> I created another patch, based on your recommendations, and with a lot of
> help from Daniel Drake (dsd@gentoo.org), that's included below. Some
> changes are made to test_unit_ready() to be able to pass the sense data
> to sr_drive_status(). Currently, sr_do_ioctl() swallows this data and
> makes its own interpretations of sense codes, which isn't what we want
> here.
> 
> Is this what you had in mind? Do you think the possible problems with
> USB drives that you mentioned will prevent this patch from going in? 
> The patch has only been compile tested right now, we can do some real
> testing later, for now I'd just like to get your feedback on it.

In general it looks good ... I suppose the only way to test it is to
stick it in and see what happens.  However, there are a few rough edges.

> Maarten
> 
> ---
> 
> --- a/drivers/scsi/sr_ioctl.c	2007-10-26 22:40:41.000000000 +0200
> +++ b/drivers/scsi/sr_ioctl.c	2007-10-27 23:56:16.000000000 +0200
> @@ -275,16 +275,21 @@ int sr_do_ioctl(Scsi_CD *cd, struct pack
>  /* ---------------------------------------------------------------------- */
>  /* interface to cdrom.c                                                   */
>  
> -static int test_unit_ready(Scsi_CD *cd)
> +static int test_unit_ready(Scsi_CD *cd, struct request_sense *sense)
>  {
> -	struct packet_command cgc;
> +	struct scsi_device *SDev = cd->device;
> +	unsigned char cmd[CDROM_PACKET_SIZE] = { GPCMD_TEST_UNIT_READY };
> +	int result;
>  
> -	memset(&cgc, 0, sizeof(struct packet_command));
> -	cgc.cmd[0] = GPCMD_TEST_UNIT_READY;
> -	cgc.quiet = 1;
> -	cgc.data_direction = DMA_NONE;
> -	cgc.timeout = IOCTL_TIMEOUT;
> -	return sr_do_ioctl(cd, &cgc);
> +	if (!scsi_block_when_processing_errors(SDev))
> +		return -ENODEV;
> +
> +	memset(sense, 0, sizeof(*sense));
> +	result = scsi_execute(SDev, cmd, DMA_NONE,
> +			      NULL, 0, (char *)sense,
> +			      IOCTL_TIMEOUT, IOCTL_RETRIES, 0);
> +
> +	return driver_byte(result);

This bit isn't quite right ... this will return true if there's a
collected sense code and false otherwise (so it returns 0 on failure
that doesn't produce any sense information).

>  }
>  
>  int sr_tray_move(struct cdrom_device_info *cdi, int pos)
> @@ -310,14 +315,41 @@ int sr_lock_door(struct cdrom_device_inf
>  
>  int sr_drive_status(struct cdrom_device_info *cdi, int slot)
>  {
> +	struct request_sense sense;
> +	struct media_event_desc med;
> +
>  	if (CDSL_CURRENT != slot) {
>  		/* we have no changer support */
>  		return -EINVAL;
>  	}
> -	if (0 == test_unit_ready(cdi->handle))
> +	if ((0 == test_unit_ready(cdi->handle, &sense)) || 
> +	    sense.sense_key == UNIT_ATTENTION)

Unit attention won't necessarily mean the media is OK ... unit attention
can mean the media or tray status has changed.

>  		return CDS_DISC_OK;
>  
> -	return CDS_TRAY_OPEN;
> +	if (!cdrom_get_media_event(cdi, &med)) {
> +		if (med.media_present)
> +			return CDS_DISC_OK;
> +		else if (med.door_open)
> +			return CDS_TRAY_OPEN;
> +		else
> +			return CDS_NO_DISC;
> +	}
> +
> +	if (sense.sense_key == NOT_READY && sense.asc == 0x04 && sense.ascq == 0x04)

Actually, all asc 0x4 codes are some type of in progress operation,
format doesn't necessarily have to be treated specially.

> +		return CDS_DISC_OK;
> +
> +	/*
> +	 * If not using Mt Fuji extended media tray reports,
> +	 * just return TRAY_OPEN since ATAPI doesn't provide
> +	 * any other way to detect this...
> +	 */
> +	if (sense.sense_key == NOT_READY) {
> +		if (sense.asc == 0x3a && sense.ascq == 1)
> +			return CDS_NO_DISC;
> +		else
> +			return CDS_TRAY_OPEN;

This is also a bit odd.  asc 0x3a ascq 0x2 definitely means tray open,
but there are a lot of other not ready conditions that don't mean this.

> +	}
> +	return CDS_DRIVE_NOT_READY;
>  }
>  
>  int sr_disk_status(struct cdrom_device_info *cdi)

James


