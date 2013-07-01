From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v12 3/6] Restrict device state changes allowed via sysfs
Date: Mon, 01 Jul 2013 10:23:09 +0200
Message-ID: <51D13C6D.4000906@suse.de>
References: <51CC5176.90609@acm.org> <51CC522A.4010805@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45977 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752990Ab3GAIXN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Jul 2013 04:23:13 -0400
In-Reply-To: <51CC522A.4010805@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Chanho Min <chanho.min@lge.com>, Joe Lawrence <jdl1291@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, David Milburn <dmilburn@redhat.com>, Tejun Heo <tj@kernel.org>

On 06/27/2013 04:54 PM, Bart Van Assche wrote:
> Restrict the SCSI device state changes allowd via sysfs to the
> OFFLINE<>RUNNING transitions. Other transitions may confuse
> the SCSI mid-layer. As an example, changing the state of a SCSI
> device via sysfs into "cancel" or "deleted" prevents removal of
> a SCSI device by scsi_remove_host().
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: James Bottomley <JBottomley@Parallels.com>
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: David Milburn <dmilburn@redhat.com>
> ---
>  drivers/scsi/scsi_sysfs.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 931a7d9..013c6de 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -605,7 +605,7 @@ store_state_field(struct device *dev, struct devi=
ce_attribute *attr,
>  			break;
>  		}
>  	}
> -	if (!state)
> +	if (state !=3D SDEV_OFFLINE && state !=3D SDEV_RUNNING)
>  		return -EINVAL;
> =20
>  	if (scsi_device_set_state(sdev, state))
>=20
Acked-by: Hannes Reinecke <hare@suse.de>

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
