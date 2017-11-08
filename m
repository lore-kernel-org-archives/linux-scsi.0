From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 01/17] lpfc: FLOGI failures are reported when connected to
 a private loop.
Date: Wed, 8 Nov 2017 10:05:19 +0100
Message-ID: <669a5545-35eb-5569-9d8f-d5d44268f425@suse.de>
References: <20171103225628.24716-1-jsmart2021@gmail.com>
 <20171103225628.24716-2-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55147 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751295AbdKHJFV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Nov 2017 04:05:21 -0500
In-Reply-To: <20171103225628.24716-2-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 11/03/2017 11:56 PM, James Smart wrote:
> When the HBA is connected to a private loop, the driver
> reports FLOGI loop-open failure as functional error. This is
> an expected condition.
> 
> Mark loop-open failure as a warning instead of error.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_els.c | 35 +++++++++++++++++++++--------------
>  1 file changed, 21 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index b14f7c5653cd..7df791047f55 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -1030,29 +1030,36 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
>  
>  stop_rr_fcf_flogi:
>  		/* FLOGI failure */
> -		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
> -				"2858 FLOGI failure Status:x%x/x%x TMO:x%x "
> -				"Data x%x x%x\n",
> -				irsp->ulpStatus, irsp->un.ulpWord[4],
> -				irsp->ulpTimeout, phba->hba_flag,
> -				phba->fcf.fcf_flag);
> +		if (!(irsp->ulpStatus == IOSTAT_LOCAL_REJECT &&
> +		      ((irsp->un.ulpWord[4] & IOERR_PARAM_MASK) ==
> +					IOERR_LOOP_OPEN_FAILURE)))
> +			lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
> +					"2858 FLOGI failure Status:x%x/x%x "
> +					"TMO:x%x Data x%x x%x\n",
> +					irsp->ulpStatus, irsp->un.ulpWord[4],
> +					irsp->ulpTimeout, phba->hba_flag,
> +					phba->fcf.fcf_flag);
>  
>  		/* Check for retry */
>  		if (lpfc_els_retry(phba, cmdiocb, rspiocb))
>  			goto out;
>  
> -		/* FLOGI failure */
> -		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
> -				 "0100 FLOGI failure Status:x%x/x%x TMO:x%x\n",
> -				 irsp->ulpStatus, irsp->un.ulpWord[4],
> -				 irsp->ulpTimeout);
> -
> -
>  		/* If this is not a loop open failure, bail out */
>  		if (!(irsp->ulpStatus == IOSTAT_LOCAL_REJECT &&
>  		      ((irsp->un.ulpWord[4] & IOERR_PARAM_MASK) ==
> -					IOERR_LOOP_OPEN_FAILURE)))
> +					IOERR_LOOP_OPEN_FAILURE))) {
> +			/* FLOGI failure */
> +			lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
> +					 "0100 FLOGI failure Status:x%x/x%x TMO:x%x\n",
> +					 irsp->ulpStatus, irsp->un.ulpWord[4],
> +					 irsp->ulpTimeout);
>  			goto flogifail;
> +		}
> +
> +		lpfc_printf_vlog(vport, KERN_WARNING, LOG_ELS,
> +				 "0150 FLOGI failure Status:x%x/x%x TMO:x%x\n",
> +				 irsp->ulpStatus, irsp->un.ulpWord[4],
> +				 irsp->ulpTimeout);
>  
>  		/* FLOGI failed, so there is no fabric */
>  		spin_lock_irq(shost->host_lock);
> 
Isn't that a bit excessive?
Printing the same message _two_ times, and not providing additional info?
Please do only duplicate message if there is new information printed;
otherwise we might as well skip the second message.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
