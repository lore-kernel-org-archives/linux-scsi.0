From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 03/11] Vport creation is failing with "Link Down" error
Date: Fri, 16 Jun 2017 09:51:42 +0200
Message-ID: <d79b83fd-090b-a4e9-44a2-1f3a1c2a5246@suse.de>
References: <20170616055651.9674-1-jsmart2021@gmail.com>
 <20170616055651.9674-4-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53362 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752375AbdFPHvo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Jun 2017 03:51:44 -0400
In-Reply-To: <20170616055651.9674-4-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 06/16/2017 07:56 AM, James Smart wrote:
> Vport creation fails for SLI-3 adapters.
> 
> Mailbox submission fails because mailbox interrupt is disabled. Mailbox
> interrupt is disabled during port reset.
> 
> Do reset only for physical port.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_init.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 9d3a12636455..77283705eb8d 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -3691,14 +3691,6 @@ lpfc_get_wwpn(struct lpfc_hba *phba)
>  	LPFC_MBOXQ_t *mboxq;
>  	MAILBOX_t *mb;
>  
> -	if (phba->sli_rev < LPFC_SLI_REV4) {
> -		/* Reset the port first */
> -		lpfc_sli_brdrestart(phba);
> -		rc = lpfc_sli_chipset_init(phba);
> -		if (rc)
> -			return (uint64_t)-1;
> -	}
> -
>  	mboxq = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool,
>  						GFP_KERNEL);
>  	if (!mboxq)
> @@ -3852,8 +3844,19 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
>  	int i;
>  	uint64_t wwn;
>  	bool use_no_reset_hba = false;
> +	int rc;
>  
> -	wwn = lpfc_get_wwpn(phba);
> +	if (lpfc_no_hba_reset_cnt) {
> +		if (phba->sli_rev < LPFC_SLI_REV4 &&
> +		    dev == &phba->pcidev->dev) {
> +			/* Reset the port first */
> +			lpfc_sli_brdrestart(phba);
> +			rc = lpfc_sli_chipset_init(phba);
> +			if (rc)
> +				return NULL;
> +		}
> +		wwn = lpfc_get_wwpn(phba);
> +	}
>  
>  	for (i = 0; i < lpfc_no_hba_reset_cnt; i++) {
>  		if (wwn == lpfc_no_hba_reset[i]) {
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
