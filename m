From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 06/11] Fix SLI3 drivers attempting NVME ELS commands.
Date: Fri, 16 Jun 2017 10:00:50 +0200
Message-ID: <4d0b0bd6-2762-f786-5140-b967c794a61c@suse.de>
References: <20170616055651.9674-1-jsmart2021@gmail.com>
 <20170616055651.9674-7-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56162 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752469AbdFPIAw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Jun 2017 04:00:52 -0400
In-Reply-To: <20170616055651.9674-7-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 06/16/2017 07:56 AM, James Smart wrote:
> In a server with an 8G adapter and a 32G adapter, running NVME
> and FCP, the server would crash with the following stack.
> 
> RIP: 0010: ... lpfc_nvme_register_port+0x38/0x420 [lpfc]
>  lpfc_nlp_state_cleanup+0x154/0x4f0 [lpfc]
>  lpfc_nlp_set_state+0x9d/0x1a0 [lpfc]
>  lpfc_cmpl_prli_prli_issue+0x35f/0x440 [lpfc]
>  lpfc_disc_state_machine+0x78/0x1c0 [lpfc]
>  lpfc_cmpl_els_prli+0x17c/0x1f0 [lpfc]
>  lpfc_sli_sp_handle_rspiocb+0x39b/0x6b0 [lpfc]
>  lpfc_sli_handle_slow_ring_event_s3+0x134/0x2d0 [lpfc]
>  lpfc_work_done+0x8ac/0x13b0 [lpfc]
>  lpfc_do_work+0xf1/0x1b0 [lpfc]
> 
> Crash, on the 8G adapter, is due to a vport which does not have
> a nvme local port structure. It's not supposed to have one. NVME is
> not supported on the 8G adapter, so the NVME PRLI, which started
> this flow shouldn't have been sent in the first place.
> 
> Correct discovery engine to recognize when on an SLI3 rport, which
> doesn't support SLI3, if the rport supports only NVME, don't send
> a NVME PRLI. Instead, as no FC4 will be used, a LOGO is sent.
> If rport is FCP and NVME, only execute the SCSI PRLI.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_els.c     | 16 +++++++++++++++-
>  drivers/scsi/lpfc/lpfc_hbadisc.c |  3 ++-
>  2 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index a140318d6159..54de984d695f 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -2168,6 +2168,19 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
>  				 ndlp->nlp_fc4_type, ndlp->nlp_DID);
>  		return 1;
>  	}
> +
> +	/* SLI3 ports don't support NVME.  If this rport is a strict NVME
> +	 * FC4 type, implicitly LOGO.
> +	 */
> +	if (phba->sli_rev == LPFC_SLI_REV3 &&
> +	    ndlp->nlp_fc4_type == NLP_FC4_NVME) {
> +		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
> +				 "3088 Rport fc4 type 0x%x not supported by SLI3 adapter\n",
> +				 ndlp->nlp_type);
> +		lpfc_disc_state_machine(vport, ndlp, NULL, NLP_EVT_DEVICE_RM);
> +		return 1;
> +	}
> +
>  	elsiocb = lpfc_prep_els_iocb(vport, 1, cmdsize, retry, ndlp,
>  				     ndlp->nlp_DID, elscmd);
>  	if (!elsiocb)
> @@ -2268,7 +2281,8 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
>  	/* The driver supports 2 FC4 types.  Make sure
>  	 * a PRLI is issued for all types before exiting.
>  	 */
> -	if (local_nlp_type & (NLP_FC4_FCP | NLP_FC4_NVME))
> +	if (phba->sli_rev == LPFC_SLI_REV4 &&
> +	    local_nlp_type & (NLP_FC4_FCP | NLP_FC4_NVME))
>  		goto send_next_prli;
>  
>  	return 0;
> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
> index db2d0e692ddf..aa5e5ff56dfb 100644
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
> @@ -4194,7 +4194,8 @@ lpfc_nlp_state_cleanup(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
>  			lpfc_register_remote_port(vport, ndlp);
>  		}
>  		/* Notify the NVME transport of this new rport. */
> -		if (ndlp->nlp_fc4_type & NLP_FC4_NVME) {
> +		if (vport->phba->sli_rev >= LPFC_SLI_REV4 &&
> +		    ndlp->nlp_fc4_type & NLP_FC4_NVME) {
>  			if (vport->phba->nvmet_support == 0) {
>  				/* Register this rport with the transport.
>  				 * Initiators take the NDLP ref count in
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
