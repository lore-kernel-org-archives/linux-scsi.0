From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 05/17] lpfc: NVME Initiator: Base modifications Part D
Date: Wed, 18 Jan 2017 14:39:59 +0100
Message-ID: <20170118133959.GE3514@linux-x5ow.site>
References: <587ec2f0.FOr4W1UKpsGdXJmP%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36438 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751769AbdARNka (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Jan 2017 08:40:30 -0500
Content-Disposition: inline
In-Reply-To: <587ec2f0.FOr4W1UKpsGdXJmP%jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

On Tue, Jan 17, 2017 at 05:20:48PM -0800, James Smart wrote:
> 
> NVME Initiator: Base modifications
> 
> This is part D of parts A..F.
> 
> Part D is the 2nd half of the mods to lpfc_init.c. This is the location
> of most of changes for the following:
> - sli3 ring vs sli4 wq splits
> - buffer pools are allocated/freed
> - sgl pools allocated/freed
> - adapter resources split up
> - queue config decided and enacted
> - receive buffer management
> 
> *********
> 
> Refer to Part A for a description of base modifications
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_init.c | 1088 +++++++++++++++++++++++------------------
>  1 file changed, 616 insertions(+), 472 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index ca54beb..ea12eca 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -7876,14 +7876,14 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
>  void
>  lpfc_sli4_queue_destroy(struct lpfc_hba *phba)
>  {
> -	int idx;
> +	int idx, numwq;
>  
>  	if (phba->cfg_fof)
>  		lpfc_fof_queue_destroy(phba);
>  
>  	if (phba->sli4_hba.hba_eq != NULL) {
>  		/* Release HBA event queue */
> -		for (idx = 0; idx < phba->cfg_fcp_io_channel; idx++) {
> +		for (idx = 0; idx < phba->io_channel; idx++) {
>  			if (phba->sli4_hba.hba_eq[idx] != NULL) {
>  				lpfc_sli4_queue_free(
>  					phba->sli4_hba.hba_eq[idx]);
> @@ -7907,9 +7907,22 @@ lpfc_sli4_queue_destroy(struct lpfc_hba *phba)
>  		phba->sli4_hba.fcp_cq = NULL;
>  	}
>  
> +	if (phba->sli4_hba.nvme_cq != NULL) {
> +		/* Release NVME completion queue */
> +		for (idx = 0; idx < phba->cfg_nvme_io_channel; idx++) {
> +			if (phba->sli4_hba.nvme_cq[idx] != NULL) {
> +				lpfc_sli4_queue_free(
> +					phba->sli4_hba.nvme_cq[idx]);
> +				phba->sli4_hba.nvme_cq[idx] = NULL;
> +			}
> +		}
> +		kfree(phba->sli4_hba.nvme_cq);
> +		phba->sli4_hba.nvme_cq = NULL;
> +	}
> +

		
static inline void lpfc_sli4_release_nvme_cqs(struct lpfc_hba *phba)
{
	int i;

	for (i = 0; i  < phba->cfg_nvme_io_channel; i++) {
		if (phba->sli4_hba.nvme_cq[idx] != NULL) {
			lpfc_sli4_queue_free(phba->sli4_hba.nvme_cq[idx]);
			phba->sli4_hba.nvme_cq[idx] = NULL;
		}
		kfree(phba->sli4_hba.nvme_cq);
		phba->sli4_hba.nvme_cq = NULL;
	}
}

And then:

	if (phba->sli4_hba.nvme_cq)
		lpfc_sli4_release_nvme_cqs(phba);

I know this might be annoying by now, but it's really hard to follow code that
is so much indented and lpfc really needs some love in the readability case.
Please don't misunderstand me, it has nothing to do with you and lpfc is not
the only driver that could need some refactoring. It's just I've spend a lot
of time looking at lpfc since I've started working in the storage area and
the code style is somewhat inconsistent with the reset of the kernel (as are
other SCSI drivers, I know). If you and Martin/James B. don't mind I'd even
volunteer to help you with cleaning it up a bit.

[...]

> @@ -7920,12 +7933,32 @@ lpfc_sli4_queue_destroy(struct lpfc_hba *phba)
>  		phba->sli4_hba.fcp_wq = NULL;
>  	}
>  
> +	if (phba->sli4_hba.nvme_wq != NULL) {
> +		/* Release NVME work queue */
> +		numwq = phba->cfg_nvme_max_hw_queue;
> +		for (idx = 0; idx < numwq; idx++) {
> +			if (phba->sli4_hba.nvme_wq[idx] != NULL) {
> +				lpfc_sli4_queue_free(
> +					phba->sli4_hba.nvme_wq[idx]);
> +				phba->sli4_hba.nvme_wq[idx] = NULL;
> +			}
> +		}
> +		kfree(phba->sli4_hba.nvme_wq);
> +		phba->sli4_hba.nvme_wq = NULL;
> +	}
> +

Same goes for the WQs here.

[...]

> +	nvme_cqidx = 0;
> +	nvme_wqidx = 0;
> +	if (phba->cfg_nvme_io_channel) {
> +		/* Set up fast-path NVME Response Complete Queue */
> +		if (!phba->sli4_hba.nvme_cq) {

Hint, if you write a comment what the specific code block is doing, you might
actually write a function. Here sth. like 'lpfc_nvme_setup_fast_path_cq()'
comes to my mind. Especially if you have to use more than 3 levels of
indentation and the block is more then 75-100 LoC. It is most likely getting
inlined by the compiler anyways.

[...]

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
