From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 12/17] lpfc: Fix mbox reuse in PLOGI completion
Date: Thu, 17 Dec 2015 09:32:55 +0100
Message-ID: <56727337.9000202@suse.de>
References: <5671efc3.0ctNdaGDOZR2f0ML%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50040 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbbLQIc5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Dec 2015 03:32:57 -0500
In-Reply-To: <5671efc3.0ctNdaGDOZR2f0ML%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>, linux-scsi@vger.kernel.org

On 12/17/2015 12:12 AM, James Smart wrote:
>
> Fix mbox reuse in PLOGI completion. Moved allocations so that buffer
> properly init'd.
>
> Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
> Signed-off-by: James Smart <james.smart@avagotech.com>
> ---
>   drivers/scsi/lpfc/lpfc_nportdisc.c | 31 +++++++++++++++++++++------=
----
>   1 file changed, 21 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/l=
pfc_nportdisc.c
> index 9e571dd..193733e 100644
> --- a/drivers/scsi/lpfc/lpfc_nportdisc.c
> +++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
> @@ -1045,16 +1045,6 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_vport =
*vport,
>   	if (irsp->ulpStatus)
>   		goto out;
>
> -	mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
> -	if (!mbox) {
> -		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
> -				 "0133 PLOGI: no memory for reg_login "
> -				 "Data: x%x x%x x%x x%x\n",
> -				 ndlp->nlp_DID, ndlp->nlp_state,
> -				 ndlp->nlp_flag, ndlp->nlp_rpi);
> -		goto out;
> -	}
> -
>   	pcmd =3D (struct lpfc_dmabuf *) cmdiocb->context2;
>
>   	prsp =3D list_get_first(&pcmd->list, struct lpfc_dmabuf, list);
> @@ -1118,6 +1108,17 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_vport =
*vport,
>   		if (phba->sli_rev =3D=3D LPFC_SLI_REV4) {
>   			lpfc_issue_reg_vfi(vport);
>   		} else {
> +			mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
> +			if (!mbox) {
> +				lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
> +						 "0133 PLOGI: no memory "
> +						 "for config_link "
> +						 "Data: x%x x%x x%x x%x\n",
> +						 ndlp->nlp_DID, ndlp->nlp_state,
> +						 ndlp->nlp_flag, ndlp->nlp_rpi);
> +				goto out;
> +			}
> +
>   			lpfc_config_link(phba, mbox);
>
>   			mbox->mbox_cmpl =3D lpfc_sli_def_mbox_cmpl;
> @@ -1132,6 +1133,16 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_vport =
*vport,
>
>   	lpfc_unreg_rpi(vport, ndlp);
>
> +	mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
> +	if (!mbox) {
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
> +				 "0018 PLOGI: no memory for reg_login "
> +				 "Data: x%x x%x x%x x%x\n",
> +				 ndlp->nlp_DID, ndlp->nlp_state,
> +				 ndlp->nlp_flag, ndlp->nlp_rpi);
> +		goto out;
> +	}
> +
>   	if (lpfc_reg_rpi(phba, vport->vpi, irsp->un.elsreq64.remoteID,
>   			 (uint8_t *) sp, mbox, ndlp->nlp_rpi) =3D=3D 0) {
>   		switch (ndlp->nlp_DID) {
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
