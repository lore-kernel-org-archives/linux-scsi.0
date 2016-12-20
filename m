From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 09/11] lpfc: Correct oops on vport port resets
Date: Tue, 20 Dec 2016 14:47:01 +0100
Message-ID: <79712a55-ff54-0c08-9cc6-28f96a421101@suse.de>
References: <58586831.FyDLkYbAFDWuYypA%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33889 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754717AbcLTNrE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Dec 2016 08:47:04 -0500
In-Reply-To: <58586831.FyDLkYbAFDWuYypA%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org

On 12/20/2016 12:07 AM, James Smart wrote:
> 
> Correct oops on vport port resets. Incorrect WQE type, thus the clearing
> code actually overstepped the WQE.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_sli.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 47b5520..d0ffcf3 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -17219,7 +17219,8 @@ lpfc_drain_txq(struct lpfc_hba *phba)
>  	unsigned long iflags = 0;
>  	char *fail_msg = NULL;
>  	struct lpfc_sglq *sglq;
> -	union lpfc_wqe wqe;
> +	union lpfc_wqe128 wqe128;
> +	union lpfc_wqe *wqe = (union lpfc_wqe *) &wqe128;
>  	uint32_t txq_cnt = 0;
>  
>  	spin_lock_irqsave(&pring->ring_lock, iflags);
> @@ -17258,9 +17259,9 @@ lpfc_drain_txq(struct lpfc_hba *phba)
>  		piocbq->sli4_xritag = sglq->sli4_xritag;
>  		if (NO_XRI == lpfc_sli4_bpl2sgl(phba, piocbq, sglq))
>  			fail_msg = "to convert bpl to sgl";
> -		else if (lpfc_sli4_iocb2wqe(phba, piocbq, &wqe))
> +		else if (lpfc_sli4_iocb2wqe(phba, piocbq, wqe))
>  			fail_msg = "to convert iocb to wqe";
> -		else if (lpfc_sli4_wq_put(phba->sli4_hba.els_wq, &wqe))
> +		else if (lpfc_sli4_wq_put(phba->sli4_hba.els_wq, wqe))
>  			fail_msg = " - Wq is full";
>  		else
>  			lpfc_sli_ringtxcmpl_put(phba, pring, piocbq);
> 
Now that is what I call a dodgy interface.
Casting a 128-bit structure to a 64-bit structure, only to call a memset
on the 128-bit structure in lpfc_sli4_iocb2wqe() is positively evil.
Can't you clear up this mess by generally passing in a wqe128?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
