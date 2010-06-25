From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH RFC] support sata odd zero power
Date: Fri, 25 Jun 2010 15:39:16 +0200
Message-ID: <4C24B184.6050009@gmail.com>
References: <AANLkTimajvNh3frP9LcytXUhFAGk1gB52wa0LlGe0ZS0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35813 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646Ab0FYNjV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Jun 2010 09:39:21 -0400
Received: by bwz7 with SMTP id 7so711265bwz.19
        for <linux-scsi@vger.kernel.org>; Fri, 25 Jun 2010 06:39:19 -0700 (PDT)
In-Reply-To: <AANLkTimajvNh3frP9LcytXUhFAGk1gB52wa0LlGe0ZS0@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: su henry <henry.su.ati@gmail.com>
Cc: axboe@kernel.dk, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>

(cc'ing James)

On 06/25/2010 12:15 PM, su henry wrote:
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -55,6 +55,7 @@
>  #include <scsi/scsi_eh.h>
>  #include <scsi/scsi_host.h>
>  #include <scsi/scsi_ioctl.h>	/* For the door lock/unlock commands */
> +#include <acpi/acpi_bus.h>
> 
>  #include "scsi_logging.h"
>  #include "sr.h"
> @@ -89,6 +90,19 @@ static struct scsi_driver sr_template = {
>  	.done			= sr_done,
>  };
> 
> +static struct sr_zpodd_device_info {
> +	acpi_handle handle;
> +	mechtype_t mechtype;
> +
> +#define SR_NO_MEDIA_TIMEOUT	(120*HZ)
> +#define SR_IS_ZPODD		0x01
> +#define SR_ZPODD_NO_DISK	0x02
> +#define SR_ZPODD_NEED_EJECT	0x04
> +
> +	u32 flags;

It's more customary to use unsigned int.

> +	unsigned long last_jiffies;
> +} sr_zpodd_device;

Can you please align fields?  Also, single struct for the whole
system?  I haven't read the spec but I don't think anybody would be
defining things like this system-wide.  Right?

> @@ -205,6 +219,7 @@ static int sr_media_change(struct
> cdrom_device_info *cdi, int slot)
>  	struct scsi_cd *cd = cdi->handle;
>  	int retval;
>  	struct scsi_sense_hdr *sshdr;
> +	int isvalid;

bool?

>  	if (CDSL_CURRENT != slot) {
>  		/* no changer support */
> @@ -213,7 +228,59 @@ static int sr_media_change(struct
> cdrom_device_info *cdi, int slot)
> 
>  	sshdr =  kzalloc(sizeof(*sshdr), GFP_KERNEL);
>  	retval = sr_test_unit_ready(cd->device, sshdr);
> -	if (retval || (scsi_sense_valid(sshdr) &&
> +	isvalid = scsi_sense_valid(sshdr);
> +
> +	if (!(sr_zpodd_device.flags & SR_IS_ZPODD))
> +		goto out_not_zpodd_device;
> +
> +	/* Remove the power supply to the drive with no media and
> +	 * tray closed for tray/drawer/pop-up type drive,
> +	 * or no media and tray open for caddy/slot type drive.
> +	 */
> +	switch (sr_zpodd_device.mechtype) {
> +	case mechtype_caddy:
> +		/* 3a/02(asc/ascq) means MEDIUM NOT PRESENT - TRAY OPEN */
> +		if (isvalid && (sshdr->asc  == 0x3a &&
> +				sshdr->ascq == 0x02)) {
> +			if (!(sr_zpodd_device.flags & SR_ZPODD_NO_DISK)) {
> +				sr_zpodd_device.flags |= SR_ZPODD_NO_DISK;
> +				sr_zpodd_device.last_jiffies = jiffies;
> +			} else if (time_after(jiffies,
> +					sr_zpodd_device.last_jiffies +
> +					SR_NO_MEDIA_TIMEOUT)) {
> +				acpi_bus_set_power(sr_zpodd_device.handle,
> +							ACPI_STATE_D3);
> +			}
> +		} else
> +			sr_zpodd_device.flags &= ~SR_ZPODD_NO_DISK;
> +		break;

This thing definitely belongs to struct scsi_cd.  What are the
synchronization rules here?  Also, what happens if async notification
is in use?  How does the timer get activated then?

> +	default:
> +		/*tray/drawer/pop-up type*/
> +		/* 3a/01(asc/ascq) means MEDIUM NOT PRESENT - TRAY CLOSED */
> +		if (isvalid && (sshdr->asc  == 0x3a &&
> +				sshdr->ascq == 0x01)) {
> +
> +			/* Eject the tray for a tray type drive*/
> +			if (sr_zpodd_device.flags & SR_ZPODD_NEED_EJECT) {
> +				sr_tray_move(cdi, 1);
> +				sr_zpodd_device.flags &= ~SR_ZPODD_NEED_EJECT;
> +			} else if (!(sr_zpodd_device.flags &
> +					SR_ZPODD_NO_DISK)) {
> +				sr_zpodd_device.flags |= SR_ZPODD_NO_DISK;
> +				sr_zpodd_device.last_jiffies = jiffies;
> +			} else if (time_after(jiffies,
> +					sr_zpodd_device.last_jiffies
> +					+ SR_NO_MEDIA_TIMEOUT)) {
> +				acpi_bus_set_power(sr_zpodd_device.handle,
> +							ACPI_STATE_D3);
> +			}
> +		} else
> +			sr_zpodd_device.flags &= ~SR_ZPODD_NO_DISK;
> +		break;
> +	}

It would probably be better to separate decision making and updating
states.

Thanks.

-- 
tejun
