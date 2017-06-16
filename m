From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/11] Fix crash doing IO with resets
Date: Fri, 16 Jun 2017 10:02:06 +0200
Message-ID: <9ef4c3d1-0b16-f3ed-d8b4-a1fff17705da@suse.de>
References: <20170616055651.9674-1-jsmart2021@gmail.com>
 <20170616055651.9674-9-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56589 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752134AbdFPICI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Jun 2017 04:02:08 -0400
In-Reply-To: <20170616055651.9674-9-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 06/16/2017 07:56 AM, James Smart wrote:
> During every reset, IOCBs are allocated. So, at one point, number of
> allocated IOCBs reaches maximum limit and lpfc_sli_next_iotag fails.
> 
> Allocate IOCBs only during initialization. Reuse them after every reset
> instead of allocating new set of IOCBs.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_sli.c | 22 ++++++++--------------
>  1 file changed, 8 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 8de70b9d79dd..e948ea05fd33 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -6927,18 +6927,6 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
>  		cnt = phba->cfg_iocb_cnt * 1024;
>  		/* We need 1 iocbq for every SGL, for IO processing */
>  		cnt += phba->sli4_hba.nvmet_xri_cnt;
> -		/* Initialize and populate the iocb list per host */
> -		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
> -				"2821 initialize iocb list %d total %d\n",
> -				phba->cfg_iocb_cnt, cnt);
> -		rc = lpfc_init_iocb_list(phba, cnt);
> -		if (rc) {
> -			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> -					"1413 Failed to init iocb list.\n");
> -			goto out_destroy_queue;
> -		}
> -
> -		lpfc_nvmet_create_targetport(phba);
>  	} else {
>  		/* update host scsi xri-sgl sizes and mappings */
>  		rc = lpfc_sli4_scsi_sgl_update(phba);
> @@ -6959,18 +6947,24 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
>  		}
>  
>  		cnt = phba->cfg_iocb_cnt * 1024;
> +	}
> +
> +	if (!phba->sli.iocbq_lookup) {
>  		/* Initialize and populate the iocb list per host */
>  		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
> -				"2820 initialize iocb list %d total %d\n",
> +				"2821 initialize iocb list %d total %d\n",
>  				phba->cfg_iocb_cnt, cnt);
>  		rc = lpfc_init_iocb_list(phba, cnt);
>  		if (rc) {
>  			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> -					"6301 Failed to init iocb list.\n");
> +					"1413 Failed to init iocb list.\n");
>  			goto out_destroy_queue;
>  		}
>  	}
>  
> +	if (phba->nvmet_support)
> +		lpfc_nvmet_create_targetport(phba);
> +
>  	if (phba->nvmet_support && phba->cfg_nvmet_mrq) {
>  		/* Post initial buffers to all RQs created */
>  		for (i = 0; i < phba->cfg_nvmet_mrq; i++) {
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
