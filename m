From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/17] lpfc: Fix RDP ACC being too long.
Date: Thu, 17 Dec 2015 09:25:49 +0100
Message-ID: <5672718D.808@suse.de>
References: <5671efc0.SB0qVbj8lP/LNAjA%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49722 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbbLQIZv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Dec 2015 03:25:51 -0500
In-Reply-To: <5671efc0.SB0qVbj8lP/LNAjA%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>, linux-scsi@vger.kernel.org

On 12/17/2015 12:12 AM, James Smart wrote:
>
> Fix RDP ACC being too long.
>
> Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
> Signed-off-by: James Smart <james.smart@avagotech.com>
> ---
>   drivers/scsi/lpfc/lpfc_els.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
>
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_el=
s.c
> index f7a2967..817cdfc 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -4824,6 +4824,7 @@ lpfc_els_rdp_cmpl(struct lpfc_hba *phba, struct=
 lpfc_rdp_context *rdp_context,
>   	struct lpfc_nodelist *ndlp =3D rdp_context->ndlp;
>   	struct lpfc_vport *vport =3D ndlp->vport;
>   	struct lpfc_iocbq *elsiocb;
> +	struct ulp_bde64 *bpl;
>   	IOCB_t *icmd;
>   	uint8_t *pcmd;
>   	struct ls_rjt *stat;
> @@ -4833,6 +4834,8 @@ lpfc_els_rdp_cmpl(struct lpfc_hba *phba, struct=
 lpfc_rdp_context *rdp_context,
>
>   	if (status !=3D SUCCESS)
>   		goto error;
> +
> +	/* This will change once we know the true size of the RDP payload *=
/
>   	cmdsize =3D sizeof(struct fc_rdp_res_frame);
>
>   	elsiocb =3D lpfc_prep_els_iocb(vport, 0, cmdsize,
> @@ -4874,6 +4877,13 @@ lpfc_els_rdp_cmpl(struct lpfc_hba *phba, struc=
t lpfc_rdp_context *rdp_context,
>   	rdp_res->length =3D cpu_to_be32(fec_size + RDP_DESC_PAYLOAD_SIZE);
>   	elsiocb->iocb_cmpl =3D lpfc_cmpl_els_rsp;
>
> +	/* Now that we know the true size of the payload, update the BPL */
> +	bpl =3D (struct ulp_bde64 *)
> +		(((struct lpfc_dmabuf *)(elsiocb->context3))->virt);
> +	bpl->tus.f.bdeSize =3D (fec_size + RDP_DESC_PAYLOAD_SIZE + 8);
> +	bpl->tus.f.bdeFlags =3D 0;
> +	bpl->tus.w =3D le32_to_cpu(bpl->tus.w);
> +
>   	phba->fc_stat.elsXmitACC++;
>   	rc =3D lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
>   	if (rc =3D=3D IOCB_ERROR)
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
