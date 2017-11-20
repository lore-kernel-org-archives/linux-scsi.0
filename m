From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 11/17] lpfc: Linux LPFC driver does not process all
 RSCNs
Date: Mon, 20 Nov 2017 14:25:41 +0100
Message-ID: <3770f59b-4459-66cf-8018-44704611efe2@suse.de>
References: <20171110010834.4542-1-jsmart2021@gmail.com>
 <20171110010834.4542-12-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57151 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751100AbdKTNZn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Nov 2017 08:25:43 -0500
In-Reply-To: <20171110010834.4542-12-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 11/10/2017 02:08 AM, James Smart wrote:
> During RSCN storms, the driver does not rediscover some targets.
> The driver marks some RSCN as to be handled after the ones it's
> working on. The driver missed processing some deferred RSCN.
> 
> Move where the driver checks for deferred RSCNs and initiate
> deferred RSCN handling if the flag was set. Also revise nport state
> within the RSCN confirm routine. Add some state data to a possible
> debug print to aid future debugging.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_ct.c      | 19 +++++++++++++++++++
>  drivers/scsi/lpfc/lpfc_els.c     |  4 +---
>  drivers/scsi/lpfc/lpfc_hbadisc.c |  9 +++++++--
>  3 files changed, 27 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
> index 33417681f5d4..0990f81524cd 100644
> --- a/drivers/scsi/lpfc/lpfc_ct.c
> +++ b/drivers/scsi/lpfc/lpfc_ct.c
> @@ -685,6 +685,25 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
>  			lpfc_els_flush_rscn(vport);
>  		goto out;
>  	}
> +
> +	spin_lock_irq(shost->host_lock);
> +	if (vport->fc_flag & FC_RSCN_DEFERRED) {
> +		vport->fc_flag &= ~FC_RSCN_DEFERRED;
> +		spin_unlock_irq(shost->host_lock);
> +
> +		/*
> +		 * Skip processing the NS response
> +		 * Re-issue the NS cmd
> +		 */
> +		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
> +				 "0151 Process Deferred RSCN Data: x%x x%x\n",
> +				 vport->fc_flag, vport->fc_rscn_id_cnt);
> +		lpfc_els_handle_rscn(vport);
> +
> +		goto out;
> +	}
> +	spin_unlock_irq(shost->host_lock);
> +
>  	if (irsp->ulpStatus) {
>  		/* Check for retry */
>  		if (vport->fc_ns_retry < LPFC_MAX_NS_RETRY) {
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index 911066c9612d..71ec580f46a3 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -1675,6 +1675,7 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
>  
>  		/* Two ndlps cannot have the same did on the nodelist */
>  		ndlp->nlp_DID = keepDID;
> +		lpfc_nlp_set_state(vport, ndlp, keep_nlp_state);
>  		if (phba->sli_rev == LPFC_SLI_REV4 &&
>  		    active_rrqs_xri_bitmap)
>  			memcpy(ndlp->active_rrqs_xri_bitmap,
> @@ -6177,9 +6178,6 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
>  		lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);
>  		/* send RECOVERY event for ALL nodes that match RSCN payload */
>  		lpfc_rscn_recovery_check(vport);
> -		spin_lock_irq(shost->host_lock);
> -		vport->fc_flag &= ~FC_RSCN_DEFERRED;
> -		spin_unlock_irq(shost->host_lock);
>  		return 0;
>  	}
>  	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
> index 3468257bda02..4577330313c0 100644
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
> @@ -5832,14 +5832,19 @@ static struct lpfc_nodelist *
>  __lpfc_find_node(struct lpfc_vport *vport, node_filter filter, void *param)
>  {
>  	struct lpfc_nodelist *ndlp;
> +	uint32_t data1;
>  
>  	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
>  		if (filter(ndlp, param)) {
> +			data1 = (((uint32_t) ndlp->nlp_state << 24) |
> +				 ((uint32_t) ndlp->nlp_xri << 16) |
> +				 ((uint32_t) ndlp->nlp_type << 8) |
> +				 ((uint32_t) ndlp->nlp_rpi & 0xff));
>  			lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
>  					 "3185 FIND node filter %p DID "
> -					 "Data: x%p x%x x%x\n",
> +					 "Data: x%p x%x x%x x%x\n",
>  					 filter, ndlp, ndlp->nlp_DID,
> -					 ndlp->nlp_flag);
> +					 ndlp->nlp_flag, data1);
>  			return ndlp;
>  		}
>  	}
> 
Where _is_ the point of that?
Please use individual entries for the variables, and don't shift them
atop some random variable just so save some coding.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
