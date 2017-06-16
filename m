From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 01/11] Fix system panic when express lane enabled.
Date: Fri, 16 Jun 2017 09:50:41 +0200
Message-ID: <ed003e57-3c11-e113-2606-a66352908635@suse.de>
References: <20170616055651.9674-1-jsmart2021@gmail.com>
 <20170616055651.9674-2-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53082 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752134AbdFPHun (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Jun 2017 03:50:43 -0400
In-Reply-To: <20170616055651.9674-2-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 06/16/2017 07:56 AM, James Smart wrote:
> There is a null pointer dereference that can happen in the FOF interrupt
> handler.
> 
> The driver was not setting up cq->assoc_qp_for sli4_hba->oas_cq.
> 
> Initialize cq->assoc_qp before accessing it.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_sli.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 040575adf9c6..4f2cc395597e 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -13560,6 +13560,9 @@ lpfc_sli4_fof_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe)
>  		return;
>  	}
>  
> +	/* Save EQ associated with this CQ */
> +	cq->assoc_qp = phba->sli4_hba.fof_eq;
> +
>  	/* Process all the entries to the OAS CQ */
>  	while ((cqe = lpfc_sli4_cq_get(cq))) {
>  		workposted |= lpfc_sli4_fp_handle_cqe(phba, cq, cqe);
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
