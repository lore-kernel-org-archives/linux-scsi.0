From: Oliver Neukum <oneukum-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] scsi: introduce a quirk for false cache reporting
Date: Sun, 14 Aug 2016 17:27:44 +0200
Message-ID: <1471188464.4879.9.camel@suse.com>
References: <1470657309-9564-1-git-send-email-oneukum@suse.com>
	 <yq18tw4rpsy.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <yq18tw4rpsy.fsf-+q57XtR/GgMb6DWv4sQWN6xOck334EZe@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2016-08-10 at 22:40 -0400, Martin K. Petersen wrote:
> >>>>> "Oliver" == Oliver Neukum <oneukum-IBi9RG/b67k@public.gmane.org> writes:
> 
> Oliver> Some SATA to USB bridges fail to cooperate with some drives
> Oliver> resulting in no cache being present being reported to the
> Oliver> host. That causes the host to skip sending a command to
> Oliver> synchronize caches. That causes data loss when the drive is
> Oliver> powered down.
> 
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index a6c346d..392d166 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -179,6 +179,7 @@ struct scsi_device {
>  	unsigned try_rc_10_first:1;	/* Try READ_CAPACACITY_10 first */
>  	unsigned is_visible:1;	/* is the device visible in sysfs */
>  	unsigned wce_default_on:1;	/* Cache is ON by default */
> +	unsigned always_sync:1;		/* synchronize cache in every case*/
>  	unsigned no_dif:1;	/* T10 PI (DIF) should be disabled */
>  	unsigned broken_fua:1;		/* Don't set FUA bit */
>  	unsigned lun_in_cdb:1;		/* Store LUN bits in CDB[1] */
> 
> I must be missing something. How is always_sync different from just
> setting wce_default_on?

Hi,

wce_default_on controls the default if the device provides no
indication. The problem here is that the indication the device
provides must be overridden, as they are false.

	Regards
		Oliver


--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
