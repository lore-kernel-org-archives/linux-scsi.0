From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/4] SCSI: send KOBJ_CHANGE when device is set to running
 v2
Date: Mon, 21 May 2012 13:45:28 +0200
Message-ID: <4FBA2AD8.3040909@suse.de>
References: <1337317019-12001-1-git-send-email-michaelc@cs.wisc.edu> <1337317019-12001-5-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49349 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012Ab2EULpa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 May 2012 07:45:30 -0400
In-Reply-To: <1337317019-12001-5-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org

On 05/18/2012 06:56 AM, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
>=20
> If a device goes offline while the device is opened then closed
> while it is still offline, udev will remove the /dev/disk/by-id
> link. If the device comes back and is set to running, userspace
> is not notified, and the by-id link will not get remade.
>=20
> This patch has scsi-ml send a KOBJ_CHANGE event so tools like udev
> will know that it can being to use the device again. With this patch
> udev see the KOBJ_CHANGE event and will reprobe the device and recrea=
te
> a /dev/disk/by-id link.
>=20
> v2
> - Added SDEV_EVT_STATE_RUNNING evt type.
>=20
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  drivers/scsi/scsi_lib.c    |    9 +++++++++
>  include/scsi/scsi_device.h |    2 ++
>  2 files changed, 11 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index d15b243..b54030d 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2061,6 +2061,7 @@ int
>  scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_sta=
te state)
>  {
>  	enum scsi_device_state oldstate =3D sdev->sdev_state;
> +	int change_evt =3D 0;
> =20
>  	if (state =3D=3D oldstate)
>  		return 0;
> @@ -2079,6 +2080,11 @@ scsi_device_set_state(struct scsi_device *sdev=
, enum scsi_device_state state)
>  		switch (oldstate) {
>  		case SDEV_OFFLINE:
>  		case SDEV_TRANSPORT_OFFLINE:
> +			/*
> +			 * Notify userspace we can accept IO by sending
> +			 * change event.
> +			 */
> +			change_evt =3D 1;
>  		case SDEV_QUIESCE:
>  		case SDEV_BLOCK:
>  		case SDEV_CREATED:
> @@ -2160,6 +2166,8 @@ scsi_device_set_state(struct scsi_device *sdev,=
 enum scsi_device_state state)
> =20
>  	}
>  	sdev->sdev_state =3D state;
> +	if (change_evt)
> +		sdev_evt_send_simple(sdev, SDEV_EVT_STATE_RUNNING, GFP_ATOMIC);
>  	return 0;
> =20
>   illegal:
> @@ -2283,6 +2291,7 @@ struct scsi_event *sdev_evt_alloc(enum scsi_dev=
ice_event evt_type,
>  	/* evt_type-specific initialization, if any */
>  	switch (evt_type) {
>  	case SDEV_EVT_MEDIA_CHANGE:
> +	case SDEV_EVT_STATE_RUNNING:
>  	default:
>  		/* do nothing */
>  		break;
Hmm. So we're only getting notified if the device switched to OFFLINE?
Weird. We'll get notified about this eventually anyway (aborting
I/Os etc).
I'd be more interested to get notified if the device becomes
_available_ again, ie when entering RUNNING state. That's really
hard to figure out without polling.

Care to add the 'change_evt' thing to the SDEV_RUNNING case
statement, too?

Or am I missing something?

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
