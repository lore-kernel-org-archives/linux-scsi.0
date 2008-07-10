From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] make sr_mod report more accurate drive status after
	closing the tray.
Date: Thu, 10 Jul 2008 16:51:59 -0500
Message-ID: <1215726719.3353.92.camel@localhost.localdomain>
References: <48767E08.50202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40772 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752186AbYGJVwD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jul 2008 17:52:03 -0400
In-Reply-To: <48767E08.50202@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Peter Jones <pjones@redhat.com>
Cc: linux-scsi@vger.kernel.org, fedora-kernel-list <fedora-kernel-list@redhat.com>

On Thu, 2008-07-10 at 17:24 -0400, Peter Jones wrote:
> Right now, when using sr_mod and issuing the CDROM_DRIVE_STATUS ioctl,
> there's no way to differentiate between when you've just closed the
> drive tray, but the media is not yet loaded, and when there's no media.
> This seems to be accidental.
> 
> Here's a patch that seems to fix this behaviour:

I'm very wary of doing something like this because it took us months to
fix up all the breakage the last time ...

> Signed-off-by: Peter Jones <pjones@redhat.com>
> 
> diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
> index ae87d08..43a084b 100644
> --- a/drivers/scsi/sr_ioctl.c
> +++ b/drivers/scsi/sr_ioctl.c
> @@ -306,10 +306,9 @@ int sr_drive_status(struct cdrom_device_info *cdi, 
> int slot)
>   		/* we have no changer support */
>   		return -EINVAL;
>   	}
> -	if (0 == sr_test_unit_ready(cd->device, &sshdr))
> -		return CDS_DISC_OK;
> -
> -	if (!cdrom_get_media_event(cdi, &med)) {
> +	if (0 == sr_test_unit_ready(cd->device, &sshdr)
> +			&& sshdr.sense_key == 0

This can't be right; if the return is zero, the sense_key must also be
zero (as in to have valid sense, it must have returned with at least
DRIVER_SENSE)

> +			&& !cdrom_get_media_event(cdi, &med)) {

And this really doesn't look right either.  Now you're only calling the
media event if the test unit ready succeeded.  A drive can be open (thus
returning not ready and hence non zero) and still give you a valid media
event.

>   		if (med.media_present)
>   			return CDS_DISC_OK;
>   		else if (med.door_open)
> @@ -319,10 +318,27 @@ int sr_drive_status(struct cdrom_device_info *cdi, 
> int slot)
>   	}
> 
>   	/*
> -	 * 0x04 is format in progress .. but there must be a disc present!
> +	 * ASC: 0x04: "logical unit is not ready"
> +	 * ASCQ: 0x01: cause not reportable
> +	 *       0x02: in process of becoming ready
> +	 *       0x03: initializing command required
> +	 *       0x04: format in progress .. but there must be a disc present!
> +	 *       0x07: operation in progress
> +	 *       0x08: long write in progress
>   	 */
> -	if (sshdr.sense_key == NOT_READY && sshdr.asc == 0x04)
> -		return CDS_DISC_OK;

This seems to be a nasty historical lie.  It seems to play into the new
media changed stuff by stalling the change until the media is ready.
Convince me that if we actually tell the truth here we're not going to
fire a slew of spurious events at hal.

> +	if (sshdr.sense_key == NOT_READY && sshdr.asc == 0x04) {
> +		switch (sshdr.ascq) {
> +			case 0x01:
> +			case 0x02:
> +				return CDS_DRIVE_NOT_READY;
> +			case 0x03:
> +				return CDS_TRAY_OPEN;

That's a stretch ... the initialising command can be start motor, but
the tray can be closed just fine.

> +			case 0x04:
> +			case 0x07:
> +			case 0x08:
> +				return CDS_DRIVE_NOT_READY;
> +		}
> +	}

James


