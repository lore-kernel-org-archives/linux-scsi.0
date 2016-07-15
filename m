From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/21] lpfc: Fix SLI mode 2 config failure
Date: Fri, 15 Jul 2016 15:12:22 +0200
Message-ID: <395782c9-734b-3319-e52c-a1df4effc33f@suse.de>
References: <577d5da1.howAJT6W/zY/7Gi8%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54706 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbcGONMY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jul 2016 09:12:24 -0400
In-Reply-To: <577d5da1.howAJT6W/zY/7Gi8%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org

On 07/06/2016 09:36 PM, James Smart wrote:
>=20
> Fix SLI mode 2 config failure
>=20
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_sli.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sl=
i.c
> index 6eef972..b1ddbaa 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -4696,6 +4696,8 @@ lpfc_sli_hba_setup(struct lpfc_hba *phba)
>  				"Not supported by adapter.\n");
>  	if (rc && mode !=3D 2)
>  		rc =3D lpfc_sli_config_port(phba, 2);
> +	else if (rc && mode =3D=3D 2)
> +		rc =3D lpfc_sli_config_port(phba, 3);
>  	if (rc)
>  		goto lpfc_sli_hba_setup_error;
> =20
>=20
Hmm. Maybe a code reorg here
if (rc) {
  if (mode =3D=3D 2)
     ..
   else
     ..
 goto ...
}

would make things easier to read.
But it's not that important.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
