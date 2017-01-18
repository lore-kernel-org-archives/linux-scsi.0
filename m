From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 02/17] lpfc: NVME Initiator: Base modifications Part A
Date: Wed, 18 Jan 2017 10:50:41 +0100
Message-ID: <20170118094921.GB3514@linux-x5ow.site>
References: <587ec2ed.BwM2pzG0hT3uy4dN%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40405 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751936AbdARKDw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Jan 2017 05:03:52 -0500
Content-Disposition: inline
In-Reply-To: <587ec2ed.BwM2pzG0hT3uy4dN%jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

Hi James,

On Tue, Jan 17, 2017 at 05:20:45PM -0800, James Smart wrote:
> 
> NVME Initiator: Base modifications
> 
> This is part A of parts A..F.
> 
> Part A is the bulk of the file list changed by the modifications as
> most mods are small-ish. Changes may be for any aspect below.
> 
> *********
> 
> This set of patches (6 parts) adds base modifications for NVME initiator
> support to the lpfc driver.
> 
> The base modifications consist of:
> - Formal split of SLI3 rings from SLI-4 WQs (sometimes referred to as
>   rings as well) as implementation now widely varies between the two.
> - Addition of configuration modes:
>    SCSI initiator only; NVME initiator only; NVME target only; and
>    SCSI and NVME initiator.
>    The configuration mode drives overall adapter configuration,
>    offloads enabled, and resource splits.
>    NVME support is only available on SLI-4 devices and newer fw.
> - Implements the following based on configuration mode:
>   - Exchange resources are split by protocol; Obviously, if only
>      1 mode, then no split occurs. Default is 50/50. module attribute
>      allows tuning.
>   - Each protocol has it's own set of queues, but share interrupt
>     vectors.
>      SCSI:
>        SLI3 devices have few queues and the original style of queue
>          allocation remains.
>        SLI4 devices piggy back on an "io-channel" concept that
>          eventually needs to merge with scsi-mq/blk-mq support (it is
> 	 underway).  For now, the paradigm continues as it existed
> 	 prior. io channel allocates N msix and N WQs (N=4 default)
> 	 and either round robins or uses cpu # modulo N for scheduling.
> 	 A bunch of module parameters allow the configuration to be
> 	 tuned.
>      NVME (initiator):
>        Allocates an msix per cpu (or whatever pci_alloc_irq_vectors
>          gets)
>        Allocates a WQ per cpu, and maps the WQs to msix on a WQ #
>          modulo msix vector count basis.
>        Module parameters exist to cap/control the config if desired.
>   - Each protocol has its own buffer and dma pools.
> 
> Unfortunately, it was very difficult to break out the above into
> functional patches. A such, they are presented as a 6-patch set to
> keep email size reasonable. All patches in the set must be applied to
> create a functional unit.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---

[...]

> @@ -2704,7 +2710,7 @@ static int lpfcdiag_loop_get_xri(struct lpfc_hba *phba, uint16_t rpi,
>   * @phba: Pointer to HBA context object
>   *
>   * This function allocates BSG_MBOX_SIZE (4KB) page size dma buffer and.
> - * returns the pointer to the buffer.
> + * retruns the pointer to the buffer.

This hunk introduces a spelling error.

>   **/
>  static struct lpfc_dmabuf *
>  lpfc_bsg_dma_page_alloc(struct lpfc_hba *phba)
> @@ -2876,7 +2882,7 @@ static int lpfcdiag_loop_post_rxbufs(struct lpfc_hba *phba, uint16_t rxxri,
>  			     size_t len)
>  {
>  	struct lpfc_sli *psli = &phba->sli;
> -	struct lpfc_sli_ring *pring = &psli->ring[LPFC_ELS_RING];
> +	struct lpfc_sli_ring *pring;
>  	struct lpfc_iocbq *cmdiocbq;
>  	IOCB_t *cmd = NULL;
>  	struct list_head head, *curr, *next;
> @@ -2890,6 +2896,11 @@ static int lpfcdiag_loop_post_rxbufs(struct lpfc_hba *phba, uint16_t rxxri,
>  	int iocb_stat;
>  	int i = 0;
>  
> +	if (phba->sli_rev == LPFC_SLI_REV4)
> +		pring = phba->sli4_hba.els_wq->pring;
> +	else
> +		pring = &psli->sli3_ring[LPFC_ELS_RING];
> +
>  	cmdiocbq = lpfc_sli_get_iocbq(phba);
>  	rxbmp = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
>  	if (rxbmp != NULL) {
> @@ -5258,7 +5269,7 @@ static int
>  lpfc_forced_link_speed(struct bsg_job *job)
>  {
>  	struct Scsi_Host *shost = fc_bsg_to_shost(job);
> -	struct lpfc_vport *vport = shost_priv(shost);
> +	struct lpfc_vport *vport = (struct lpfc_vport *)shost->hostdata;

Please don't. A) it's unnecessary to cast a void* and b) shost_priv() just
returns shost->hostdata (casted to void*). So all's fine.

[...]

> diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
> index 361f5b3..1d07a5f 100644
> --- a/drivers/scsi/lpfc/lpfc_disc.h
> +++ b/drivers/scsi/lpfc/lpfc_disc.h
> @@ -133,6 +133,7 @@ struct lpfc_node_rrq {
>  /* Defines for nlp_flag (uint32) */
>  #define NLP_IGNR_REG_CMPL  0x00000001 /* Rcvd rscn before we cmpl reg login */
>  #define NLP_REG_LOGIN_SEND 0x00000002   /* sent reglogin to adapter */
> +#define NLP_SUPPRESS_RSP   0x00000010	/* Remote NPort supports suppress rsp */
>  #define NLP_PLOGI_SND      0x00000020	/* sent PLOGI request for this entry */
>  #define NLP_PRLI_SND       0x00000040	/* sent PRLI request for this entry */
>  #define NLP_ADISC_SND      0x00000080	/* sent ADISC request for this entry */
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index 27f0cbb..f61e1c2 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -1323,7 +1323,10 @@ lpfc_els_abort_flogi(struct lpfc_hba *phba)
>  			"0201 Abort outstanding I/O on NPort x%x\n",
>  			Fabric_DID);
>  
> -	pring = &phba->sli.ring[LPFC_ELS_RING];
> +	if (phba->sli_rev != LPFC_SLI_REV4)
> +		pring = &phba->sli.sli3_ring[LPFC_ELS_RING];
> +	else
> +		pring = phba->sli4_hba.els_wq->pring;
>  

You're doing this quite often, can you make a small helper for it?
static inline struct lpfc_sli_ring *lpfc_sli_ring_from_hba(struct lpfc_hba *phba)
{
	if (phba->sli_rev != LPFC_SLI_REV4)
		pring = &phba->sli.sli3_ring[LPFC_ELS_RING];
	else
		pring = phba->sli4_hba.els_wq->pring;
}

[...]

> @@ -1751,7 +1757,7 @@ lpfc_sli4_new_fcf_random_select(struct lpfc_hba *phba, uint32_t fcf_cnt)
>  	uint32_t rand_num;
>  
>  	/* Get 16-bit uniform random number */
> -	rand_num = 0xFFFF & prandom_u32();
> +	rand_num = (0xFFFF & prandom_u32());

Unnecessary introduction of parenthesis.


[...]

> @@ -4452,28 +4471,51 @@ lpfc_no_rpi(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
>  	psli = &phba->sli;
>  	if (ndlp->nlp_flag & NLP_RPI_REGISTERED) {
>  		/* Now process each ring */
> -		for (i = 0; i < psli->num_rings; i++) {
> -			pring = &psli->ring[i];
> -
> -			spin_lock_irq(&phba->hbalock);
> -			list_for_each_entry_safe(iocb, next_iocb, &pring->txq,
> -						 list) {
> -				/*
> -				 * Check to see if iocb matches the nport we are
> -				 * looking for
> -				 */
> +		if (phba->sli_rev != LPFC_SLI_REV4) {
> +			for (i = 0; i < psli->num_rings; i++) {
> +				pring = &psli->sli3_ring[i];
> +				spin_lock_irq(&phba->hbalock);
> +				list_for_each_entry_safe(iocb, next_iocb,
> +							 &pring->txq, list) {
> +					/*
> +					 * Check to see if iocb matches the
> +					 * nport we are looking for
> +					 */
> +					if ((lpfc_check_sli_ndlp(phba, pring,
> +								 iocb, ndlp))) {
> +						/* It matches, so deque and
> +						 * call compl with an error
> +						 */
> +						list_move_tail(&iocb->list,
> +							       &completions);
> +					}
> +				}
> +				spin_unlock_irq(&phba->hbalock);
> +			}
> +			goto out;
> +		}

Can you please factor the for loop into an own function so that we get

		if (phba->sli_rev != LPFC_SLI_REV4)
			lpfc_handle_sli_rev4();

The level of indentation is just too high. Btw checkpatch.pl tells you about
it with '--type DEEP_INDENTATION'.

> +		spin_lock_irq(&phba->hbalock);
> +		list_for_each_entry(qp, &phba->sli4_hba.lpfc_wq_list, wq_list) {
> +			pring = qp->pring;
> +			if (!pring)
> +				continue;
> +			spin_lock_irq(&pring->ring_lock);
> +			list_for_each_entry_safe(iocb, next_iocb,
> +						 &pring->txq, list) {
>  				if ((lpfc_check_sli_ndlp(phba, pring, iocb,
>  							 ndlp))) {
> -					/* It matches, so deque and call compl
> -					   with an error */
> +					/* It matches, so deque and
> +					 * call compl with an error
> +					 */
>  					list_move_tail(&iocb->list,
>  						       &completions);
>  				}
>  			}
> -			spin_unlock_irq(&phba->hbalock);
> +			spin_unlock_irq(&pring->ring_lock);
>  		}

like above, is it possible to do
		spin_lock_irq(...);
		handler();
		spin_unlock_irq();

This makes it way easier to follow.

[...]

> @@ -5207,7 +5248,10 @@ lpfc_free_tx(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
>  	struct lpfc_sli_ring *pring;
>  
>  	psli = &phba->sli;
> -	pring = &psli->ring[LPFC_ELS_RING];
> +	if (phba->sli_rev != LPFC_SLI_REV4)
> +		pring = &phba->sli.sli3_ring[LPFC_ELS_RING];
> +	else
> +		pring = phba->sli4_hba.els_wq->pring;
>  
you really might want to write a coccinelle rule for this pattern... 

[...]

> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index 19d349f..c60dfc9 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -242,6 +242,7 @@ lpfc_update_stats(struct lpfc_hba *phba, struct  lpfc_scsi_buf *lpfc_cmd)
>  	spin_unlock_irqrestore(shost->host_lock, flags);
>  }
>  
> +

Stray newine.

[...]

> @@ -605,7 +610,7 @@ lpfc_sli4_fcp_xri_aborted(struct lpfc_hba *phba,
>  }
>  
>  /**
> - * lpfc_sli4_post_scsi_sgl_list - Post blocks of scsi buffer sgls from a list
> + * lpfc_sli4_post_scsi_sgl_list - Psot blocks of scsi buffer sgls from a list
                                     ^^^ o.O

[...]

> @@ -3894,7 +3896,7 @@ int lpfc_sli4_scmd_to_wqidx_distr(struct lpfc_hba *phba,
>  		}
>  	}
>  	chann = atomic_add_return(1, &phba->fcp_qidx);
> -	chann = (chann % phba->cfg_fcp_io_channel);
> +	chann = (chann % phba->cfg_fcp_max_hw_queue);

No need for the parenthesis.

[...]

> @@ -4959,11 +4968,11 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct scsi_cmnd *cmnd,
>  	int status;
>  
>  	rdata = lpfc_rport_data_from_scsi_device(cmnd->device);
> -	if (!rdata || !rdata->pnode || !NLP_CHK_NODE_ACT(rdata->pnode))
> -		return FAILED;

OK, I don't get this hunk. lpfc_rport_data_from_scsi_device() cannot return
NULL anymore?

I at least expected something like:

  	rdata = lpfc_rport_data_from_scsi_device(cmnd->device);
	if (!rdata || !rdata->pnode)
		return FAILED;
	
	pnode = rdata->pnode;
	if (!NLP_CHK_NODE_ACT(pnode)
		return FAILED;

>  	pnode = rdata->pnode;
> +	if (!pnode || !NLP_CHK_NODE_ACT(pnode))
> +		return FAILED;
>  
> -	lpfc_cmd = lpfc_get_scsi_buf(phba, pnode);
> +	lpfc_cmd = lpfc_get_scsi_buf(phba, rdata->pnode);
>  	if (lpfc_cmd == NULL)
>  		return FAILED;
>  	lpfc_cmd->timeout = phba->cfg_task_mgmt_tmo;


[...]

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
