From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 4/6] [SCSI] Generate uevents for certain Unit Attention
 codes
Date: Thu, 20 Jun 2013 10:35:18 +0200
Message-ID: <51C2BEC6.1020207@suse.de>
References: <1371663761-22481-1-git-send-email-emilne@redhat.com> <1371663761-22481-5-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49990 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012Ab3FTIfV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Jun 2013 04:35:21 -0400
In-Reply-To: <1371663761-22481-5-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org, jbottomley@parallels.com, rwheeler@redhat.com

Hi Ewan,

some comments inline:

On 06/19/2013 07:42 PM, Ewan D. Milne wrote:
> From: "Ewan D. Milne" <emilne@redhat.com>
>=20
> Generate a uevent on the scsi_target object when the following
> Unit Attention ASC/ASCQ code is received:
>=20
>     3F/0E  REPORTED LUNS DATA HAS CHANGED
>=20
> Generate a uevent on the scsi_device object when the following
> Unit Attention ASC/ASCQ codes are received:
>=20
>     2A/01  MODE PARAMETERS CHANGED
>     2A/09  CAPACITY DATA HAS CHANGED
>     38/07  THIN PROVISIONING SOFT THRESHOLD REACHED
>=20
> All uevent generation is aggregated and rate-limited so that any
> individual event is delivered no more than once every 2 seconds.
>=20
> Log kernel messages when the following Unit Attention ASC/ASCQ
> codes are received:
>=20
>     2A/xx  PARAMETERS CHANGED
>     3F/03  INQUIRY DATA HAS CHANGED
>     3F/xx  TARGET OPERATING CONDITIONS HAVE CHANGED
>=20
> Also changed the kernel log messages on existing Unit Attention
> codes, to remove text that indicates that the conditions were not
> handled in any way (since they are now handled in some way) and
> reflect the wording used in SPC-4.
>=20
> Also log a kernel message when the a scsi device reports a Unit
> Attention queue overflow, indicating that status has been lost.
>=20
> These changes are only enabled when the kernel config option
> CONFIG_SCSI_ENHANCED_UA is set.  Otherwise, the behavior is the
> same as before, including the existing kernel log messages.
> However, the detection of these conditions was moved to be earlier
> in scsi_check_sense(), because the code was not always reached.
>=20
> Added a new exported function scsi_report_sense() to allow drivers
> to report sense data that is not associated with a SCSI command.
>=20
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>  drivers/scsi/scsi_error.c  | 187 +++++++++++++++++++++++++++++++++++=
+++++-----
>  drivers/scsi/scsi_lib.c    |  17 ++++-
>  drivers/scsi/scsi_priv.h   |   2 +
>  drivers/scsi/scsi_scan.c   |   5 ++
>  drivers/scsi/scsi_sysfs.c  |   3 +
>  include/scsi/scsi_cmnd.h   |   4 +
>  include/scsi/scsi_device.h |  22 ++++++
>  include/scsi/scsi_eh.h     |   5 ++
>  8 files changed, 223 insertions(+), 22 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index d0f71e5..d0b5a26 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -223,6 +223,86 @@ static inline void scsi_eh_prt_fail_stats(struct=
 Scsi_Host *shost,
>  #endif
> =20
>  /**
> + * scsi_report_sense - Examine scsi sense information and log messag=
es for
> + *		       certain conditions, also issue uevents if so configured.
> + * @sshdr:	sshdr to be examined
> + */
> +void scsi_report_sense(struct scsi_device *sdev, struct scsi_sense_h=
dr *sshdr)
> +{
> +#ifdef CONFIG_SCSI_ENHANCED_UA
> +	if (sshdr->ua_queue_overflow)
> +		sdev_printk(KERN_WARNING, sdev,
> +			    "Unit Attention queue overflow");
> +#endif
> +
> +	if (sshdr->sense_key =3D=3D UNIT_ATTENTION) {
> +		if (sshdr->asc =3D=3D 0x3f && sshdr->ascq =3D=3D 0x03)
> +			sdev_printk(KERN_WARNING, sdev,
> +				    "Inquiry data has changed");
Why no event for this one?
I would think that this event warrants a device rescan, so
definitely would want to be informed here ...

> +		else if (sshdr->asc =3D=3D 0x3f && sshdr->ascq =3D=3D 0x0e) {
> +#ifdef CONFIG_SCSI_ENHANCED_UA
> +			struct scsi_target *starget =3D scsi_target(sdev);
> +			if (atomic_xchg(&starget->lun_change_reported, 1) =3D=3D 0)
> +				schedule_delayed_work(&starget->ua_dwork, 2*HZ);
> +			sdev_printk(KERN_WARNING, sdev,
> +				    "Reported LUNs data has changed");
> +#else
> +			sdev_printk(KERN_WARNING, sdev,
> +				    "Warning! Received an indication that the "
> +				    "LUN assignments on this target have "
> +				    "changed. The Linux SCSI layer does not "
> +				    "automatically remap LUN assignments.\n");
> +#endif
As James B. said, I would not modify the existing comment.
Just because we did send an event that doesn't mean that someone
actually too some action for that event ...
So I'd prefer to have the original messages in place.

> +		} else if (sshdr->asc =3D=3D 0x3f)
> +#ifdef CONFIG_SCSI_ENHANCED_UA
> +			sdev_printk(KERN_WARNING, sdev,
> +				    "Target operating conditions have changed");
> +#else
> +			sdev_printk(KERN_WARNING, sdev,
> +				    "Warning! Received an indication that the "
> +				    "operating parameters on this target have "
> +				    "changed. The Linux SCSI layer does not "
> +				    "automatically adjust these parameters.\n");
> +#endif
> +
> +		if (sshdr->asc =3D=3D 0x38 && sshdr->ascq =3D=3D 0x07) {
> +#ifdef CONFIG_SCSI_ENHANCED_UA
> +			if (atomic_xchg(&sdev->soft_threshold_reached, 1) =3D=3D 0)
> +				schedule_delayed_work(&sdev->ua_dwork, 2 * HZ);
> +			sdev_printk(KERN_WARNING, sdev,
> +				    "Thin provisioning soft threshold reached");
> +#else
> +			sdev_printk(KERN_WARNING, sdev,
> +				    "Warning! Received an indication that the "
> +				    "LUN reached a thin provisioning soft "
> +				    "threshold.\n");
> +#endif
Again, there is no need to change the message ...

> +		}
> +
> +		if (sshdr->asc =3D=3D 0x2a && sshdr->ascq =3D=3D 0x01) {
> +#ifdef CONFIG_SCSI_ENHANCED_UA
> +			if (atomic_xchg(&sdev->mode_parameter_change_reported,
> +					1) =3D=3D 0)
> +				schedule_delayed_work(&sdev->ua_dwork, 2 * HZ);
> +#endif
I'm not utterly keen on adding individual variables per event.
This will increase the structure for each new event.

I'd rather have a common variable which could then hold a bitmask of
the events. That way we could easily add more events to it.

[ .. ]
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index c55eea1..70503d2 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2186,7 +2186,17 @@ static void sdev_evt_emit(struct scsi_device *=
sdev, struct sdev_event *evt)
>  	case SDEV_EVT_MEDIA_CHANGE:
>  		envp[idx++] =3D "SDEV_MEDIA_CHANGE=3D1";
>  		break;
> -
> +#ifdef CONFIG_SCSI_ENHANCED_UA
> +	case SDEV_EVT_CAPACITY_CHANGE_REPORTED:
> +		envp[idx++] =3D "SDEV_CAPACITY_CHANGE_REPORTED=3D1";
> +		break;
> +	case SDEV_EVT_SOFT_THRESHOLD_REACHED:
> +		envp[idx++] =3D "SDEV_SOFT_THRESHOLD_REACHED=3D1";
> +		break;
> +	case SDEV_EVT_MODE_PARAMETER_CHANGE_REPORTED:
> +		envp[idx++] =3D "SDEV_MODE_PARAMETER_CHANGE_REPORTED=3D1";
> +		break;
> +#endif
Again, I don't really like to have on/off variables for uevents.
This will making it quite hard to code udev rules for it.
I'd rather have a common variable name like SDEV_EVENT
and then the event as the value.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
