From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: lpfc: fix block guard enablement on SLI3 adapters
Date: Fri, 16 Nov 2018 12:00:44 +0100
Message-ID: <f7216225-e4e6-18b4-d341-0126e1a41b1d@suse.de>
References: <20181112085837.24450-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20181112085837.24450-1-mwilck@suse.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Martin Wilck <mwilck@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Smart <jsmart2021@gmail.com>, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>
Cc: David Bond <dbond@suse.com>, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/12/18 9:58 AM, Martin Wilck wrote:
> Since f44ac12f1dcc, BG enablement is tracked with the
> LPFC_SLI3_BG_ENABLED bit, which is set in lpfc_get_cfgparam
> before lpfc_sli_config_sli_port() is called. The bit
> shouldn't be cleared before checking the feature.
> Based on problem analysis by David Bond.
> 
> Fixes: f44ac12f1dcc "scsi: lpfc: Memory allocation error during driver start-up on power8"
> Tested-by: David Bond <dbond@suse.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Cc: stable@vger.kernel.org # 4.17.x
> Cc: stable@vger.kernel.org # 4.18.x
> Cc: stable@vger.kernel.org # 4.19.x
> ---
>   drivers/scsi/lpfc/lpfc_init.c | 6 +++++-
>   drivers/scsi/lpfc/lpfc_sli.c  | 1 -
>   2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 323a32e..6b61cae 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -167,7 +167,11 @@ lpfc_config_port_prep(struct lpfc_hba *phba)
>   		       sizeof(phba->wwpn));
>   	}
>   
> -	phba->sli3_options = 0x0;
> +	/*
> +	 * Clear all option bits except LPFC_SLI3_BG_ENABLED,
> +	 * which was already set in lpfc_get_cfgparam()
> +	 */
> +	phba->sli3_options &= (uint32_t)LPFC_SLI3_BG_ENABLED;
>   
>   	/* Setup and issue mailbox READ REV command */
>   	lpfc_read_rev(phba, pmb);
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 783a154..b9e5cd7 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -4965,7 +4965,6 @@ lpfc_sli_config_port(struct lpfc_hba *phba, int sli_mode)
>   		phba->sli3_options &= ~(LPFC_SLI3_NPIV_ENABLED |
>   					LPFC_SLI3_HBQ_ENABLED |
>   					LPFC_SLI3_CRP_ENABLED |
> -					LPFC_SLI3_BG_ENABLED |
>   					LPFC_SLI3_DSS_ENABLED);
>   		if (rc != MBX_SUCCESS) {
>   			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
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
