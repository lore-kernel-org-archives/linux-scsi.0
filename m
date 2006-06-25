From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [patch 13/26] lpfc: sparse NULL warnings
Date: Sun, 25 Jun 2006 09:46:26 -0400
Message-ID: <449E93B2.7060405@emulex.com>
References: <200606250858.k5P8wpO3021214@shell0.pdx.osdl.net>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:23225 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750944AbWFYNqj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Jun 2006 09:46:39 -0400
In-Reply-To: <200606250858.k5P8wpO3021214@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, rdunlap@xenotime.net

ACK

akpm@osdl.org wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix sparse warnings: use NULL instead of 0 for pointers:
> drivers/scsi/lpfc/lpfc_els.c:827:56: warning: Using plain integer as NULL pointer
> drivers/scsi/lpfc/lpfc_els.c:2781:18: warning: Using plain integer as NULL pointer
> drivers/scsi/lpfc/lpfc_els.c:2782:18: warning: Using plain integer as NULL pointer
> drivers/scsi/lpfc/lpfc_init.c:951:21: warning: Using plain integer as NULL pointer
> drivers/scsi/lpfc/lpfc_init.c:956:20: warning: Using plain integer as NULL pointer
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Andrew Morton <akpm@osdl.org>
> ---
> 
>  drivers/scsi/lpfc/lpfc_els.c  |    6 +++---
>  drivers/scsi/lpfc/lpfc_init.c |    4 ++--
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff -puN drivers/scsi/lpfc/lpfc_els.c~lpfc-sparse-null-warnings drivers/scsi/lpfc/lpfc_els.c
> --- a/drivers/scsi/lpfc/lpfc_els.c~lpfc-sparse-null-warnings
> +++ a/drivers/scsi/lpfc/lpfc_els.c
> @@ -821,7 +821,7 @@ lpfc_issue_els_plogi(struct lpfc_hba * p
>  	pring = &psli->ring[LPFC_ELS_RING];	/* ELS ring */
>  
>  	cmdsize = (sizeof (uint32_t) + sizeof (struct serv_parm));
> -	elsiocb = lpfc_prep_els_iocb(phba, 1, cmdsize, retry, 0, did,
> +	elsiocb = lpfc_prep_els_iocb(phba, 1, cmdsize, retry, NULL, did,
>  								ELS_CMD_PLOGI);
>  	if (!elsiocb)
>  		return 1;
> @@ -2791,8 +2791,8 @@ lpfc_els_rsp_rps_acc(struct lpfc_hba * p
>  
>  	ndlp = (struct lpfc_nodelist *) pmb->context2;
>  	xri = (uint16_t) ((unsigned long)(pmb->context1));
> -	pmb->context1 = 0;
> -	pmb->context2 = 0;
> +	pmb->context1 = NULL;
> +	pmb->context2 = NULL;
>  
>  	if (mb->mbxStatus) {
>  		mempool_free( pmb, phba->mbox_mem_pool);
> diff -puN drivers/scsi/lpfc/lpfc_init.c~lpfc-sparse-null-warnings drivers/scsi/lpfc/lpfc_init.c
> --- a/drivers/scsi/lpfc/lpfc_init.c~lpfc-sparse-null-warnings
> +++ a/drivers/scsi/lpfc/lpfc_init.c
> @@ -939,12 +939,12 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
>  					"10-port ", "PCIe"};
>  			break;
>  		default:
> -			m = (typeof(m)){ 0 };
> +			m = (typeof(m)){ NULL };
>  			break;
>  		}
>  		break;
>  	default:
> -		m = (typeof(m)){ 0 };
> +		m = (typeof(m)){ NULL };
>  		break;
>  	}
>  
> _
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
