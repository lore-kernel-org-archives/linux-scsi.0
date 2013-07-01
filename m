From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v12 6/6] Avoid re-enabling I/O after the transport became
 offline
Date: Mon, 01 Jul 2013 10:27:56 +0200
Message-ID: <51D13D8C.9070407@suse.de>
References: <51CC5176.90609@acm.org> <51CC52EB.9040900@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46133 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375Ab3GAI15 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Jul 2013 04:27:57 -0400
In-Reply-To: <51CC52EB.9040900@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Chanho Min <chanho.min@lge.com>, Joe Lawrence <jdl1291@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, David Milburn <dmilburn@redhat.com>, Tejun Heo <tj@kernel.org>

On 06/27/2013 04:57 PM, Bart Van Assche wrote:
> Disallow the SDEV_TRANSPORT_OFFLINE to SDEV_CANCEL transition such
> that no I/O is sent to devices for which the transport is offline.
> Notes:
> - Functions like sd_shutdown() use scsi_execute_req() and hence
>   set the REQ_PREEMPT flag. Such requests are passed to the LLD
>   queuecommand callback in the SDEV_CANCEL state.
> - This patch does not affect Fibre Channel LLD drivers since these
>   drivers invoke fc_remote_port_chkready() before submitting a SCSI
>   request to the HBA. That prevents a timeout to occur in state
>   SDEV_CANCEL if the transport is offline.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> Cc: James Bottomley <JBottomley@Parallels.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Tejun Heo <tj@kernel.org>
> ---
>  drivers/scsi/scsi_lib.c   |    1 -
>  drivers/scsi/scsi_sysfs.c |    4 +++-
>  2 files changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 6a4fde7..63875c3 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2180,7 +2180,6 @@ scsi_device_set_state(struct scsi_device *sdev,=
 enum scsi_device_state state)
>  		case SDEV_RUNNING:
>  		case SDEV_QUIESCE:
>  		case SDEV_OFFLINE:
> -		case SDEV_TRANSPORT_OFFLINE:
>  		case SDEV_BLOCK:
>  			break;
>  		default:
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index dfbaa34..666b741 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -959,14 +959,16 @@ void __scsi_remove_device(struct scsi_device *s=
dev)
>  {
>  	struct Scsi_Host *shost =3D sdev->host;
>  	struct device *dev =3D &sdev->sdev_gendev;
> +	enum scsi_device_state sdev_state;
>  	int res;
> =20
>  	if (sdev->is_visible) {
>  		spin_lock_irq(shost->host_lock);
> +		sdev_state =3D sdev->sdev_state;
>  		res =3D scsi_device_set_state(sdev, SDEV_CANCEL);
>  		spin_unlock_irq(shost->host_lock);
> =20
> -		if (res !=3D 0)
> +		if (res !=3D 0 && sdev_state !=3D SDEV_TRANSPORT_OFFLINE)
>  			return;
> =20
>  		bsg_unregister_queue(sdev->request_queue);
>=20
Hmm. This is really subtle. Do you mind adding inserting a comment
here on why this is required?

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
