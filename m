From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 16/17] lpfc: Use kzalloc instead of kmalloc
Date: Thu, 17 Dec 2015 09:39:13 +0100
Message-ID: <567274B1.9040602@suse.de>
References: <5671efc7.97bycJ6w84wBFCRH%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50376 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbbLQIjP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Dec 2015 03:39:15 -0500
In-Reply-To: <5671efc7.97bycJ6w84wBFCRH%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>, linux-scsi@vger.kernel.org

On 12/17/2015 12:12 AM, James Smart wrote:
>
> From:	Punit Vara <punitvara@gmail.com>
>
> This patch is to the lpfc_els.c which resolves following warning
> reported by coccicheck:
>
> WARNING: kzalloc should be used for rdp_context, instead of
> kmalloc/memset
>
> Signed-off-by: Punit Vara <punitvara@gmail.com>
> Signed-off-by: James Smart <james.smart@avagotech.com>
> ---
>   drivers/scsi/lpfc/lpfc_els.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_el=
s.c
> index 273a1db..7f5abb8 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -5016,13 +5016,12 @@ lpfc_els_rcv_rdp(struct lpfc_vport *vport, st=
ruct lpfc_iocbq *cmdiocb,
>   	if (RDP_NPORT_ID_SIZE !=3D
>   			be32_to_cpu(rdp_req->nport_id_desc.length))
>   		goto rjt_logerr;
> -	rdp_context =3D kmalloc(sizeof(struct lpfc_rdp_context), GFP_KERNEL=
);
> +	rdp_context =3D kzalloc(sizeof(struct lpfc_rdp_context), GFP_KERNEL=
);
>   	if (!rdp_context) {
>   		rjt_err =3D LSRJT_UNABLE_TPC;
>   		goto error;
>   	}
>
> -	memset(rdp_context, 0, sizeof(struct lpfc_rdp_context));
>   	cmd =3D &cmdiocb->iocb;
>   	rdp_context->ndlp =3D lpfc_nlp_get(ndlp);
>   	rdp_context->ox_id =3D cmd->unsli3.rcvsli3.ox_id;
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
