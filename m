From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH v2 12/15] lpfc: Fix rport leak.
Date: Sun, 24 May 2015 13:56:36 +0200
Message-ID: <20150524135636.00000f81@localhost>
References: <555e1c10.+P+E84TfJG4E7Wsc%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:63985 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbbEXL4i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 May 2015 07:56:38 -0400
In-Reply-To: <555e1c10.+P+E84TfJG4E7Wsc%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>
Cc: linux-scsi@vger.kernel.org, Sebastian Herbszt <herbszt@gmx.de>

James Smart wrote:
> 
> Fix rport leak.
> 
> Correct locking and refcounting in tracking our rports
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
> Signed-off-by: James Smart <james.smart@avagotech.com>
> ---
>  drivers/scsi/lpfc/lpfc_disc.h    |   4 +-
>  drivers/scsi/lpfc/lpfc_els.c     |  12 +++-
>  drivers/scsi/lpfc/lpfc_hbadisc.c | 145 +++++++++++++++++++--------------------
>  3 files changed, 79 insertions(+), 82 deletions(-)

snip

> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
> index 0dfa566..88af258 100644
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
> @@ -106,6 +106,7 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
>  	struct lpfc_rport_data *rdata;
>  	struct lpfc_nodelist * ndlp;
>  	struct lpfc_vport *vport;
> +	struct Scsi_Host *shost;
>  	struct lpfc_hba   *phba;
>  	struct lpfc_work_evt *evtp;
>  	int  put_node;
> @@ -146,49 +147,32 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
>  	if (ndlp->nlp_state == NLP_STE_MAPPED_NODE)
>  		return;
>  
> -	if (ndlp->nlp_type & NLP_FABRIC) {
> -
> -		/* If the WWPN of the rport and ndlp don't match, ignore it */
> -		if (rport->port_name != wwn_to_u64(ndlp->nlp_portname.u.wwn)) {
> -			lpfc_printf_vlog(vport, KERN_ERR, LOG_NODE,
> -				"6789 rport name %lx != node port name %lx",
> -				(unsigned long)rport->port_name,
> -				(unsigned long)wwn_to_u64(
> -						ndlp->nlp_portname.u.wwn));
> -			put_node = rdata->pnode != NULL;
> -			put_rport = ndlp->rport != NULL;
> -			rdata->pnode = NULL;
> -			ndlp->rport = NULL;
> -			if (put_node)
> -				lpfc_nlp_put(ndlp);
> -			if (put_rport)
> -				put_device(&rport->dev);
> -			return;
> -		}
> -
> -		put_node = rdata->pnode != NULL;
> -		put_rport = ndlp->rport != NULL;
> -		rdata->pnode = NULL;
> -		ndlp->rport = NULL;
> -		if (put_node)
> -			lpfc_nlp_put(ndlp);
> -		if (put_rport)
> -			put_device(&rport->dev);
> -		return;
> -	}
> +	if (rport->port_name != wwn_to_u64(ndlp->nlp_portname.u.wwn))
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_NODE,
> +				"6789 rport name %llx != node port name %llx",
> +				rport->port_name,
> +				wwn_to_u64(ndlp->nlp_portname.u.wwn));
>  
>  	evtp = &ndlp->dev_loss_evt;
>  
> -	if (!list_empty(&evtp->evt_listp))
> +	if (!list_empty(&evtp->evt_listp)) {
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_NODE,
> +				"6790 rport name %llx dev_loss_evt pending",
> +				rport->port_name);
>  		return;
> +	}
>  
> -	evtp->evt_arg1  = lpfc_nlp_get(ndlp);
> -	ndlp->nlp_add_flag |= NLP_IN_DEV_LOSS;
> +	shost = lpfc_shost_from_vport(vport);
> +	spin_lock_irq(shost->host_lock);
> +	ndlp->nlp_flag |= NLP_IN_DEV_LOSS;
> +	spin_unlock_irq(shost->host_lock);
>  
> -	spin_lock_irq(&phba->hbalock);
>  	/* We need to hold the node by incrementing the reference
>  	 * count until this queued work is done
>  	 */
> +	evtp->evt_arg1  = lpfc_nlp_get(ndlp);

Additional space here

> +
> +	spin_lock_irq(&phba->hbalock);
>  	if (evtp->evt_arg1) {
>  		evtp->evt = LPFC_EVT_DEV_LOSS;
>  		list_add_tail(&evtp->evt_listp, &phba->work_list);

snip

> @@ -4799,14 +4782,24 @@ lpfc_nlp_remove(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
>  	lpfc_cleanup_node(vport, ndlp);
>  
>  	/*
> -	 * We can get here with a non-NULL ndlp->rport because when we
> -	 * unregister a rport we don't break the rport/node linkage.  So if we
> -	 * do, make sure we don't leaving any dangling pointers behind.
> +	 * ndlp->rport must be set to NULL before it reaches here
> +	 * i.e. break rport/node link before doing lpfc_nlp_put for
> +	 * registered rport and then drop the reference of rport.
>  	 */
>  	if (ndlp->rport) {
> -		rdata = ndlp->rport->dd_data;
> +		/*
> +		 * extra lpfc_nlp_put dropped the reference of ndlp
> +		 * for registered rport so need to cleanup rport
> +		 */
> +		lpfc_printf_vlog(vport, KERN_WARNING, LOG_NODE,
> +				"0940 removed node x%p DID x%x "
> +				" rport not null %p\n",
> +				ndlp, ndlp->nlp_DID, ndlp->rport);

checkpatch suggests to not split this user-visible string.

> +		rport = ndlp->rport;
> +		rdata = rport->dd_data;
>  		rdata->pnode = NULL;
>  		ndlp->rport = NULL;
> +		put_device(&rport->dev);
>  	}
>  }
>  

Sebastian
