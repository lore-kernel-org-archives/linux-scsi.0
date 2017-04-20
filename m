From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH-v1 03/22] Fix rejected nvme LS Req.
Date: Thu, 20 Apr 2017 09:29:26 +0200
Message-ID: <20170420072926.GD6217@linux-x5ow.site>
References: <20170420044641.10657-1-jsmart2021@gmail.com>
 <20170420044641.10657-4-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48001 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S938363AbdDTH3a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 20 Apr 2017 03:29:30 -0400
Content-Disposition: inline
In-Reply-To: <20170420044641.10657-4-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jsmart2021@gmail.com
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, martin.petersen@oracle.com, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On Wed, Apr 19, 2017 at 09:46:22PM -0700, jsmart2021@gmail.com wrote:
> From: James Smart <jsmart2021@gmail.com>
> 
> In this case, the NVME initiator is sending an LS REQ command on an NDLP
> that is not MAPPED.  The FW rejects it.
> 
>  The lpfc_nvme_ls_req routine checks for a NULL ndlp pointer
> but does not check the NDLP state.  This allows the routine
> to send an LS IO when the ndlp is disconnected.
> 
>  Check the ndlp for NULL, actual node, Target and MAPPED
> or Initiator and UNMAPPED. This avoids Fabric nodes getting
> the Create Association or Create Connection commands.  Initiators
> are free to Reject either Create.
> Also some of the messages numbers in lpfc_nvme_ls_req were changed because
> they were already used in other log messages.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_nvme.c | 25 ++++++++++++++++++++-----
>  1 file changed, 20 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
> index a39d72c..2a87428 100644
> --- a/drivers/scsi/lpfc/lpfc_nvme.c
> +++ b/drivers/scsi/lpfc/lpfc_nvme.c
> @@ -417,11 +417,26 @@ lpfc_nvme_ls_req(struct nvme_fc_local_port *pnvme_lport,
>  	vport = lport->vport;
>  
>  	ndlp = lpfc_findnode_did(vport, pnvme_rport->port_id);
> -	if (!ndlp) {
> -		lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_DISC,
> -				 "6043 Could not find node for DID %x\n",
> +	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)) {
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_NODE | LOG_NVME_IOERR,
> +				 "6051 DID x%06x not an active rport.\n",
>  				 pnvme_rport->port_id);
> -		return 1;
> +		return -ENODEV;
> +	}
> +
> +	/* The remote node has to be a mapped nvme target or an
> +	 * unmapped nvme initiator or it's an error.
> +	 */
> +	if (((ndlp->nlp_type & NLP_NVME_TARGET) &&
> +	     (ndlp->nlp_state != NLP_STE_MAPPED_NODE)) ||
> +	    ((ndlp->nlp_type & NLP_NVME_INITIATOR) &&
> +	     (ndlp->nlp_state != NLP_STE_UNMAPPED_NODE))) {
> +		lpfc_printf_vlog(vport, KERN_ERR, LOG_NODE | LOG_NVME_IOERR,
> +				 "6088 DID x%06x not ready for "
> +				 "IO. State x%x, Type x%x\n",
> +				 pnvme_rport->port_id,
> +				 ndlp->nlp_state, ndlp->nlp_type);
> +		return -ENODEV;

This if statement is horrible to read with all those parenthesis. It really
looks more like LISP than C. IIRC I already told you this in my last review.

With this fixed up,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
