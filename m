From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/14] lpfc: Fix possible use-after-free and double free
 in lpfc_mbx_cmpl_rdp_page_a2()
Date: Mon, 14 Sep 2015 09:37:18 +0200
Message-ID: <55F6792E.7000802@suse.de>
References: <55e4bd8f.66pL9YWWXA/xjdG0%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40382 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbbINHhU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Sep 2015 03:37:20 -0400
In-Reply-To: <55e4bd8f.66pL9YWWXA/xjdG0%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>, linux-scsi@vger.kernel.org

On 08/31/2015 10:48 PM, James Smart wrote:
>=20
> From: Johannes Thumshirn <jthumshirn@suse.de>
>=20
> If the bf_get() call in lpfc_mbx_cmpl_rdp_page_a2() does succeeds, ex=
ecution
> continues normally and mp gets kfree()d.
>=20
> If the subsequent call to lpfc_sli_issue_mbox() fails execution jumps=
 to the
> error label where lpfc_mbuf_free() is called with mp->virt and mp->ph=
ys as
> function arguments. This is the use after free. Following the use aft=
er free mp
> gets kfree()d again which is a double free.
>=20
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Signed-off-by: James Smart <james.smart@avagotech.com>
> ---
>  drivers/scsi/lpfc/lpfc_mbox.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_m=
box.c
> index 723e110..18838ea 100644
> --- a/drivers/scsi/lpfc/lpfc_mbox.c
> +++ b/drivers/scsi/lpfc/lpfc_mbox.c
> @@ -2276,7 +2276,7 @@ lpfc_mbx_cmpl_rdp_page_a2(struct lpfc_hba *phba=
, LPFC_MBOXQ_t *mbox)
>  			(struct lpfc_rdp_context *)(mbox->context2);
> =20
>  	if (bf_get(lpfc_mqe_status, &mbox->u.mqe))
> -		goto error;
> +		goto error_mbuf_free;
> =20
>  	lpfc_sli_bemem_bcopy(mp->virt, &rdp_context->page_a2,
>  				DMP_SFF_PAGE_A2_SIZE);
> @@ -2291,13 +2291,14 @@ lpfc_mbx_cmpl_rdp_page_a2(struct lpfc_hba *ph=
ba, LPFC_MBOXQ_t *mbox)
>  	mbox->mbox_cmpl =3D lpfc_mbx_cmpl_rdp_link_stat;
>  	mbox->context2 =3D (struct lpfc_rdp_context *) rdp_context;
>  	if (lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT) =3D=3D MBX_NOT_FINI=
SHED)
> -		goto error;
> +		goto error_cmd_free;
> =20
>  	return;
> =20
> -error:
> +error_mbuf_free:
>  	lpfc_mbuf_free(phba, mp->virt, mp->phys);
>  	kfree(mp);
> +error_cmd_free:
>  	lpfc_sli4_mbox_cmd_free(phba, mbox);
>  	rdp_context->cmpl(phba, rdp_context, FAILURE);
>  }
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

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
