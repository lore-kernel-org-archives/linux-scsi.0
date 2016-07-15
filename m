From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 13/21] lpfc: Correct Port reset resulting in FC port going
 offline
Date: Fri, 15 Jul 2016 15:19:19 +0200
Message-ID: <735206ae-dc15-d019-23d1-bf6ae9dc0a8d@suse.de>
References: <577d5da6.Csc9NMYwiS/8EdfU%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55503 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbcGONTU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jul 2016 09:19:20 -0400
In-Reply-To: <577d5da6.Csc9NMYwiS/8EdfU%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

On 07/06/2016 09:36 PM, James Smart wrote:
>=20
> Correct Port reset resulting in FC port going offline
>=20
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_init.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_i=
nit.c
> index 6e11574..f4b3548 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -1595,9 +1595,10 @@ lpfc_sli4_port_sta_fn_reset(struct lpfc_hba *p=
hba, int mbx_action,
>  		 * ready before performing reset.
>  		 */
>  		rc =3D lpfc_sli4_pdev_status_reg_wait(phba);
> -		if (!rc)
> +		if (rc)
>  			return rc;
>  	}
> +
>  	/* need reset: attempt for port recovery */
>  	if (en_rn_msg)
>  		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
>=20
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
