From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_transport_fc: Unexport scsi_is_fc_vport()
Date: Tue, 29 Mar 2016 08:45:04 +0200
Message-ID: <56FA2470.6000102@suse.de>
References: <56F9A418.5040607@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38940 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbcC2GpH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Mar 2016 02:45:07 -0400
In-Reply-To: <56F9A418.5040607@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Smart <james.smart@avagotech.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 03/28/2016 11:37 PM, Bart Van Assche wrote:
> Running the command "git grep -nHw scsi_is_fc_vport" shows that this
> function is only called from inside scsi_transport_fc.c. Hence unexpo=
rt
> this function.
>=20
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: James Smart <james.smart@avagotech.com>
> ---
>  drivers/scsi/scsi_transport_fc.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_tra=
nsport_fc.c
> index 8a88226..90afe5d 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -2027,11 +2027,10 @@ static void fc_vport_dev_release(struct devic=
e *dev)
>  	kfree(vport);
>  }
> =20
> -int scsi_is_fc_vport(const struct device *dev)
> +static int scsi_is_fc_vport(const struct device *dev)
>  {
>  	return dev->release =3D=3D fc_vport_dev_release;
>  }
> -EXPORT_SYMBOL(scsi_is_fc_vport);
> =20
>  static int fc_vport_match(struct attribute_container *cont,
>  			    struct device *dev)
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
