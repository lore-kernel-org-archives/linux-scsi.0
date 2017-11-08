From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH] lpfc: Fix hard lock up NMI in els timeout handling.
Date: Wed, 08 Nov 2017 13:57:14 -0500
Message-ID: <1510167434.4090.238.camel@localhost.localdomain>
References: <20171107205902.17352-1-jsmart2021@gmail.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46248 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751716AbdKHS5Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Nov 2017 13:57:16 -0500
In-Reply-To: <20171107205902.17352-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: linux-scsi@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On Tue, 2017-11-07 at 12:59 -0800, James Smart wrote:
> From: Dick Kennedy <dick.kennedy@broadcom.com>
> 
> System crashed due to a hard lockup at lpfc_els_timeout_handler+0x128.
> 
> The els ring's txcmplq list is corrupted: the last element in the list
> does not point back the the head causing a loop. Issue is the
> els processing path for sli4 hbas are using the hbalock instead of
> the ring_lock for removing elements from the txcmplq list.
> 
> Use the adapter SLI_REV to determine which lock should be used for
> removing iocbqs from the els rings txcmplq.
> 
> note: the future refactoring will address this so that we don't have
> this ugly type-based lock code.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_sli.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 1229f58bdd09..c1c7df607604 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -2732,7 +2732,8 @@ lpfc_sli_process_unsol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
>   *
>   * This function looks up the iocb_lookup table to get the command iocb
>   * corresponding to the given response iocb using the iotag of the
> - * response iocb. This function is called with the hbalock held.
> + * response iocb. This function is called with the hbalock held
> + * for sli3 devices or the ring_lock for sli4 devices.
>   * This function returns the command iocb object if it finds the command
>   * iocb else returns NULL.
>   **/
> @@ -2828,9 +2829,15 @@ lpfc_sli_process_sol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
>  	unsigned long iflag;
>  
>  	/* Based on the iotag field, get the cmd IOCB from the txcmplq */
> -	spin_lock_irqsave(&phba->hbalock, iflag);
> +	if (phba->sli_rev == LPFC_SLI_REV4)
> +		spin_lock_irqsave(&pring->ring_lock, iflag);
> +	else
> +		spin_lock_irqsave(&phba->hbalock, iflag);
>  	cmdiocbp = lpfc_sli_iocbq_lookup(phba, pring, saveq);
> -	spin_unlock_irqrestore(&phba->hbalock, iflag);
> +	if (phba->sli_rev == LPFC_SLI_REV4)
> +		spin_unlock_irqrestore(&pring->ring_lock, iflag);
> +	else
> +		spin_unlock_irqrestore(&phba->hbalock, iflag);
>  
>  	if (cmdiocbp) {
>  		if (cmdiocbp->iocb_cmpl) {

The other callers of lpfc_sli_iocbq_lookup() use the 2 different locks,
depending upon the SLI-3/SLI-4 case.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>
