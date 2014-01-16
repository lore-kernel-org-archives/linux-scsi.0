From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 25/41] hpsa: teach hpsa_device_reset to do either target
 or lun reset
Date: Thu, 16 Jan 2014 09:36:42 +0100
Message-ID: <52D79A1A.5060409@suse.de>
References: <20140115223354.5061.50276.stgit@beardog.cce.hp.com> <20140115223826.5061.13848.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36280 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbaAPIgn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jan 2014 03:36:43 -0500
In-Reply-To: <20140115223826.5061.13848.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, jbottomley@parallels.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, matthew.gates@hp.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

On 01/15/2014 11:38 PM, Stephen M. Cameron wrote:
> From: Scott Teel <scott.teel@hp.com>
>=20
> Signed-off-by: Scott Teel <scott.teel@hp.com>
> Acked-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> ---
>  drivers/scsi/hpsa.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 9628e12..7cab95f 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -1858,7 +1858,8 @@ out:
>  	return rc;
>  }
> =20
> -static int hpsa_send_reset(struct ctlr_info *h, unsigned char *scsi3=
addr)
> +static int hpsa_send_reset(struct ctlr_info *h, unsigned char *scsi3=
addr,
> +	u8 reset_type)
>  {
>  	int rc =3D IO_OK;
>  	struct CommandList *c;
> @@ -1872,8 +1873,8 @@ static int hpsa_send_reset(struct ctlr_info *h,=
 unsigned char *scsi3addr)
>  	}
> =20
>  	/* fill_cmd can't fail here, no data buffer to map. */
> -	(void) fill_cmd(c, HPSA_DEVICE_RESET_MSG, h,
> -			NULL, 0, 0, scsi3addr, TYPE_MSG);
> +	(void) fill_cmd(c, HPSA_DEVICE_RESET_MSG, h, NULL, 0, 0, scsi3addr,=
 TYPE_MSG);
> +	c->Request.CDB[1] =3D reset_type; /* fill_cmd defaults to LUN reset=
 type */
>  	hpsa_scsi_do_simple_cmd_core(h, c);
>  	/* no unmap needed here because no data xfer. */
> =20
> @@ -3397,7 +3398,7 @@ static int hpsa_eh_device_reset_handler(struct =
scsi_cmnd *scsicmd)
>  	dev_warn(&h->pdev->dev, "resetting device %d:%d:%d:%d\n",
>  		h->scsi_host->host_no, dev->bus, dev->target, dev->lun);
>  	/* send a reset to the SCSI LUN which the command was sent to */
> -	rc =3D hpsa_send_reset(h, dev->scsi3addr);
> +	rc =3D hpsa_send_reset(h, dev->scsi3addr, HPSA_RESET_TYPE_LUN);
>  	if (rc =3D=3D 0 && wait_for_device_to_become_ready(h, dev->scsi3add=
r) =3D=3D 0)
>  		return SUCCESS;
> =20
>=20
Would you mind using the correct eh_X callbacks here?
LUN Reset is _not_ identical to TARGET Reset (conceptually, at
least). And I'm currently trying to disentangle those;
idea is to have the actual device as the argument, not the command.

Having yet another driver which mangles those only serves to
increase the patch here ...

Thanks.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
