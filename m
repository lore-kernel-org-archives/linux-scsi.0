From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 02/14] lpfc: Correct loss of target discovery after cable
 swap.
Date: Tue, 21 Apr 2015 11:58:48 +0200
Message-ID: <55361F58.8040104@suse.de>
References: <55350589.0H28yntcywQuSNAP%james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59120 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823AbbDUJ6v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2015 05:58:51 -0400
In-Reply-To: <55350589.0H28yntcywQuSNAP%james.smart@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org

On 04/20/2015 03:56 PM, James Smart wrote:
>=20
> Correct loss of target discovery after cable swap.
>=20
> Fix incorrect reference counting
>=20
> Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
> Signed-off-by: James Smart <james.smart@emulex.com>
> ---
>  drivers/scsi/lpfc/lpfc_hbadisc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpf=
c_hbadisc.c
> index f2db89f..72388a6 100644
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
> @@ -4296,9 +4296,9 @@ lpfc_drop_node(struct lpfc_vport *vport, struct=
 lpfc_nodelist *ndlp)
>  	if (vport->phba->sli_rev =3D=3D LPFC_SLI_REV4) {
>  		lpfc_cleanup_vports_rrqs(vport, ndlp);
>  		lpfc_unreg_rpi(vport, ndlp);
> -	} else {
> -		lpfc_nlp_put(ndlp);
>  	}
> +
> +	lpfc_nlp_put(ndlp);
>  	return;
>  }
> =20
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

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
