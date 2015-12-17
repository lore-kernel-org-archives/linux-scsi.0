From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 15/17] lpfc: Delete unnecessary checks before the function
 call "mempool_destroy"
Date: Thu, 17 Dec 2015 09:38:55 +0100
Message-ID: <5672749F.3030801@suse.de>
References: <5671efc6.ZwH5WdfbRkt48aQV%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50358 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbbLQIi4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Dec 2015 03:38:56 -0500
In-Reply-To: <5671efc6.ZwH5WdfbRkt48aQV%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>, linux-scsi@vger.kernel.org

On 12/17/2015 12:12 AM, James Smart wrote:
>
> From: Markus Elfring <elfring@users.sourceforge.net>
>
> The mempool_destroy() function tests whether its argument is NULL
> and then returns immediately. Thus the test around the calls is not n=
eeded.
>
> This issue was detected by using the Coccinelle software.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> Signed-off-by: James Smart <james.smart@avagotech.com>
> ---
>   drivers/scsi/lpfc/lpfc_mem.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_me=
m.c
> index 3fa6533..4fb3581 100644
> --- a/drivers/scsi/lpfc/lpfc_mem.c
> +++ b/drivers/scsi/lpfc/lpfc_mem.c
> @@ -231,15 +231,13 @@ lpfc_mem_free(struct lpfc_hba *phba)
>   	if (phba->lpfc_hbq_pool)
>   		pci_pool_destroy(phba->lpfc_hbq_pool);
>   	phba->lpfc_hbq_pool =3D NULL;
> -
> -	if (phba->rrq_pool)
> -		mempool_destroy(phba->rrq_pool);
> +	mempool_destroy(phba->rrq_pool);
>   	phba->rrq_pool =3D NULL;
>
>   	/* Free NLP memory pool */
>   	mempool_destroy(phba->nlp_mem_pool);
>   	phba->nlp_mem_pool =3D NULL;
> -	if (phba->sli_rev =3D=3D LPFC_SLI_REV4 && phba->active_rrq_pool) {
> +	if (phba->sli_rev =3D=3D LPFC_SLI_REV4) {
>   		mempool_destroy(phba->active_rrq_pool);
>   		phba->active_rrq_pool =3D NULL;
>   	}
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
