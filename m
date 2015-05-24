From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH 4/9] lpfc: Add support for using block multi-queue
Date: Sun, 24 May 2015 22:12:51 +0200
Message-ID: <20150524221251.000050db@localhost>
References: <555f405e.2o5/YwCIJ/19LVTb%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:54978 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbbEXUMv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 May 2015 16:12:51 -0400
In-Reply-To: <555f405e.2o5/YwCIJ/19LVTb%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>
Cc: linux-scsi@vger.kernel.org, Sebastian Herbszt <herbszt@gmx.de>

James Smart wrote:
> 
> Add support for using block multi-queue
> 
> With blk-mq support in the mid-layer, lpfc can do IO steering based
> on the information in the request tag.  This patch allows lpfc to use

two spaces

> blk-mq if enabled. If not enabled, we fall back into the emulex-internal
> affinity mappings.
> 
> This feature can be turned on via CONFIG_SCSI_MQ_DEFAULT or passing
> scsi_mod.use_blk_mq=Y as a parameter to the kernel.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
> Signed-off-by: James Smart <james.smart@avagotech.com>
> ---
>  drivers/scsi/lpfc/lpfc_init.c |  4 ++-
>  drivers/scsi/lpfc/lpfc_scsi.c | 43 +++++++++++++++++++++++++
>  drivers/scsi/lpfc/lpfc_scsi.h |  3 ++
>  drivers/scsi/lpfc/lpfc_sli.c  | 74 ++++++++++++++-----------------------------
>  4 files changed, 72 insertions(+), 52 deletions(-)

snip

> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index 116df9c..4a2a818 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -3846,6 +3846,49 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
>  }
>  
>  /**
> + * lpfc_sli4_scmd_to_wqidx_distr - scsi command to SLI4 WQ index distribution
> + * @phba: Pointer to HBA context object.

@lpfc_cmd is missing

> + *
> + * This routine performs a roundrobin SCSI command to SLI4 FCP WQ index
> + * distribution.  This is called by __lpfc_sli_issue_iocb_s4() with the hbalock

two spaces

> + * held.
> + * If scsi-mq is enabled, get the default block layer mapping of software queues
> + * to hardware queues. This information is saved in request tag.
> + *
> + * Return: index into SLI4 fast-path FCP queue index.
> + **/
> +int lpfc_sli4_scmd_to_wqidx_distr(struct lpfc_hba *phba,
> +				  struct lpfc_scsi_buf *lpfc_cmd)
> +{
> +	struct scsi_cmnd *cmnd = lpfc_cmd->pCmd;
> +	struct lpfc_vector_map_info *cpup;
> +	int chann, cpu;
> +	uint32_t tag;
> +	uint16_t hwq;
> +
> +	if (shost_use_blk_mq(cmnd->device->host)) {
> +		tag = blk_mq_unique_tag(cmnd->request);
> +		hwq = blk_mq_unique_tag_to_hwq(tag);
> +

remove new line?

> +		return hwq;
> +	}
> +
> +	if (phba->cfg_fcp_io_sched == LPFC_FCP_SCHED_BY_CPU
> +	    && phba->cfg_fcp_io_channel > 1) {
> +		cpu = smp_processor_id();
> +		if (cpu < phba->sli4_hba.num_present_cpu) {
> +			cpup = phba->sli4_hba.cpu_map;
> +			cpup += cpu;
> +			return cpup->channel_id;
> +		}
> +	}

maybe add new line?

> +	chann = atomic_add_return(1, &phba->fcp_qidx);
> +	chann = (chann % phba->cfg_fcp_io_channel);
> +	return chann;
> +}
> +
> +
> +/**
>   * lpfc_scsi_cmd_iocb_cmpl - Scsi cmnd IOCB completion routine
>   * @phba: The Hba for which this call is being executed.
>   * @pIocbIn: The command IOCBQ for the scsi cmnd.
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.h b/drivers/scsi/lpfc/lpfc_scsi.h
> index 474e30c..18b9260 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.h
> +++ b/drivers/scsi/lpfc/lpfc_scsi.h
> @@ -184,3 +184,6 @@ struct lpfc_scsi_buf {
>  #define FIND_FIRST_OAS_LUN		 0
>  #define NO_MORE_OAS_LUN			-1
>  #define NOT_OAS_ENABLED_LUN		NO_MORE_OAS_LUN
> +
> +int lpfc_sli4_scmd_to_wqidx_distr(struct lpfc_hba *phba,
> +				  struct lpfc_scsi_buf *lpfc_cmd);
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 41d3370..07df296 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c

snip

> @@ -8807,27 +8777,29 @@ int
>  lpfc_sli_calc_ring(struct lpfc_hba *phba, uint32_t ring_number,
>  		    struct lpfc_iocbq *piocb)
>  {
> -	if (phba->sli_rev == LPFC_SLI_REV4) {
> -		if (piocb->iocb_flag &  (LPFC_IO_FCP | LPFC_USE_FCPWQIDX)) {
> -			if (!(phba->cfg_fof) ||
> -			    (!(piocb->iocb_flag & LPFC_IO_FOF))) {
> -				if (unlikely(!phba->sli4_hba.fcp_wq))
> -					return LPFC_HBA_ERROR;
> -				/*
> -				 * for abort iocb fcp_wqidx should already
> -				 * be setup based on what work queue we used.
> -				 */
> -				if (!(piocb->iocb_flag & LPFC_USE_FCPWQIDX))
> -					piocb->fcp_wqidx =
> -					    lpfc_sli4_scmd_to_wqidx_distr(phba);
> -				ring_number = MAX_SLI3_CONFIGURED_RINGS +
> -						piocb->fcp_wqidx;
> -			} else {
> -				if (unlikely(!phba->sli4_hba.oas_wq))
> -					return LPFC_HBA_ERROR;
> -				piocb->fcp_wqidx = 0;
> -				ring_number =  LPFC_FCP_OAS_RING;
> -			}
> +	if (phba->sli_rev < LPFC_SLI_REV4)
> +		return ring_number;
> +
> +	if (piocb->iocb_flag &  (LPFC_IO_FCP | LPFC_USE_FCPWQIDX)) {

two spaces

> +		if (!(phba->cfg_fof) ||
> +				(!(piocb->iocb_flag & LPFC_IO_FOF))) {
> +			if (unlikely(!phba->sli4_hba.fcp_wq))
> +				return LPFC_HBA_ERROR;
> +			/*
> +			 * for abort iocb fcp_wqidx should already
> +			 * be setup based on what work queue we used.
> +			 */
> +			if (!(piocb->iocb_flag & LPFC_USE_FCPWQIDX))
> +				piocb->fcp_wqidx =
> +					lpfc_sli4_scmd_to_wqidx_distr(phba,
> +							      piocb->context1);
> +			ring_number = MAX_SLI3_CONFIGURED_RINGS +
> +				piocb->fcp_wqidx;
> +		} else {
> +			if (unlikely(!phba->sli4_hba.oas_wq))
> +				return LPFC_HBA_ERROR;
> +			piocb->fcp_wqidx = 0;
> +			ring_number =  LPFC_FCP_OAS_RING;

two spaces

>  		}
>  	}
>  	return ring_number;

Sebastian
