From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 04/17] lpfc: NVME Initiator: Base modifications Part C
Date: Wed, 18 Jan 2017 12:03:04 +0100
Message-ID: <20170118110304.GD3514@linux-x5ow.site>
References: <587ec2ef.Y/y2qvlPHm64sAst%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51151 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754226AbdARLDK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Jan 2017 06:03:10 -0500
Content-Disposition: inline
In-Reply-To: <587ec2ef.Y/y2qvlPHm64sAst%jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

On Tue, Jan 17, 2017 at 05:20:47PM -0800, James Smart wrote:
> 
> NVME Initiator: Base modifications
> 
> This is part C of parts A..F.
> 
> Part C is the 1st half of the mods to lpfc_init.c. This is the location
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

[...]

> @@ -925,32 +926,43 @@ static void
>  lpfc_hba_clean_txcmplq(struct lpfc_hba *phba)
>  {
>  	struct lpfc_sli *psli = &phba->sli;
> +	struct lpfc_queue *qp = NULL;
>  	struct lpfc_sli_ring *pring;
>  	LIST_HEAD(completions);
>  	int i;
>  
> -	for (i = 0; i < psli->num_rings; i++) {
> -		pring = &psli->ring[i];
> -		if (phba->sli_rev >= LPFC_SLI_REV4)
> -			spin_lock_irq(&pring->ring_lock);
> -		else
> +	if (phba->sli_rev != LPFC_SLI_REV4) {
> +		for (i = 0; i < psli->num_rings; i++) {
> +			pring = &psli->sli3_ring[i];
>  			spin_lock_irq(&phba->hbalock);
> -		/* At this point in time the HBA is either reset or DOA. Either
> -		 * way, nothing should be on txcmplq as it will NEVER complete.
> -		 */
> -		list_splice_init(&pring->txcmplq, &completions);
> -		pring->txcmplq_cnt = 0;
> -
> -		if (phba->sli_rev >= LPFC_SLI_REV4)
> -			spin_unlock_irq(&pring->ring_lock);
> -		else
> +			/* At this point in time the HBA is either reset or DOA
> +			 * Nothing should be on txcmplq as it will
> +			 * NEVER complete.
> +			 */
> +			list_splice_init(&pring->txcmplq, &completions);
> +			pring->txcmplq_cnt = 0;
>  			spin_unlock_irq(&phba->hbalock);
>  
> +			lpfc_sli_abort_iocb_ring(phba, pring);
> +		}

>  		/* Cancel all the IOCBs from the completions list */
> -		lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
> -				      IOERR_SLI_ABORTED);
> +		lpfc_sli_cancel_iocbs(phba, &completions,
> +				      IOSTAT_LOCAL_REJECT, IOERR_SLI_ABORTED);
> +		return;
> +	}

And another great opportunity to factor a block into a helper function.

[...]

>  /**
> + * lpfc_sli4_nvme_sgl_update - update xri-sgl sizing and mapping
> + * @phba: pointer to lpfc hba data structure.
> + *
> + * This routine first calculates the sizes of the current els and allocated
> + * scsi sgl lists, and then goes through all sgls to updates the physical
> + * XRIs assigned due to port function reset. During port initialization, the
> + * current els and allocated scsi sgl lists are 0s.
> + *
> + * Return codes
> + *   0 - successful (for now, it always returns 0)
> + **/
> +int
> +lpfc_sli4_nvme_sgl_update(struct lpfc_hba *phba)
> +{
> +	struct lpfc_nvme_buf *lpfc_ncmd = NULL, *lpfc_ncmd_next = NULL;
> +	uint16_t i, lxri, els_xri_cnt;
> +	uint16_t nvme_xri_cnt;
> +	LIST_HEAD(nvme_sgl_list);
> +	int rc;
> +
> +	phba->total_nvme_bufs = 0;
> +
> +	if (!(phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME))
> +		return 0;
> +	/*
> +	 * update on pci function's allocated nvme xri-sgl list
> +	 */
> +
> +	/* maximum number of xris available for nvme buffers */
> +	els_xri_cnt = lpfc_sli4_get_els_iocb_cnt(phba);
> +	phba->sli4_hba.nvme_xri_max = phba->sli4_hba.max_cfg_param.max_xri -
> +				      els_xri_cnt;
> +	phba->sli4_hba.nvme_xri_max -= phba->sli4_hba.scsi_xri_max;

	nvme_xri_max = phba->sli4_hba.max_cfg_param.max_xri - els_xri_cnt;
	nvme_xri_max -= phba->sli4_hba.scsi_xri_max;
	phba->sli4_hba.nvme_xri_max = nvme_xri_max; 

Low hanging anti line-break fruit.

[...]

> @@ -4240,9 +4456,9 @@ lpfc_sli4_async_sli_evt(struct lpfc_hba *phba, struct lpfc_acqe_sli *acqe_sli)
>  			break;
>  		default:
>  			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
> -					"3296 "
> -					"LPFC_SLI_EVENT_TYPE_MISCONFIGURED "
> -					"event: Invalid link %d",
> +					"3296 LPFC_SLI_EVENT_TYPE_"
> +					"MISCONFIGURED  event: "
> +					"Invalid link %d\n",
>  					phba->sli4_hba.lnk_info.lnk_no);
>  			return;
>  		}
> @@ -4273,13 +4489,13 @@ lpfc_sli4_async_sli_evt(struct lpfc_hba *phba, struct lpfc_acqe_sli *acqe_sli)
>  			sprintf(message, "Unqualified optics - Replace with "
>  				"Avago optics for Warranty and Technical "

Is Avago still correct, or should it read Broadcom?

>  				"Support - Link is%s operational",
> -				(operational) ? "" : " not");
> +				(operational) ? " not" : "");
>  			break;

[...]


> @@ -4854,17 +5070,20 @@ static int
>  lpfc_enable_pci_dev(struct lpfc_hba *phba)
>  {
>  	struct pci_dev *pdev;
> +	int bars = 0;
>  
>  	/* Obtain PCI device reference */
>  	if (!phba->pcidev)
>  		goto out_error;
>  	else
>  		pdev = phba->pcidev;
> +	/* Select PCI BARs */
> +	bars = pci_select_bars(pdev, IORESOURCE_MEM);
>  	/* Enable PCI device */
>  	if (pci_enable_device_mem(pdev))
>  		goto out_error;
>  	/* Request PCI resource for the device */
> -	if (pci_request_mem_regions(pdev, LPFC_DRIVER_NAME))
> +	if (pci_request_selected_regions(pdev, bars, LPFC_DRIVER_NAME))
>  		goto out_disable_device;
>  	/* Set up device as PCI master and save state for EEH */
>  	pci_set_master(pdev);
> @@ -4881,7 +5100,7 @@ lpfc_enable_pci_dev(struct lpfc_hba *phba)
>  	pci_disable_device(pdev);
>  out_error:
>  	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> -			"1401 Failed to enable pci device\n");
> +			"1401 Failed to enable pci device, bars:x%x\n", bars);
>  	return -ENODEV;
>  }

I don't get this change. pci_request_mem_regions does

pci_request_selected_regions(pdev, 
		pci_select_bars(pdev, IORESOURCE_MEM), name);

if you want to have the bars in the error log please do:
  	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
			"1401 Failed to enable pci device, bars:x%x\n",
			pci_select_regions(pdev, IORESOURCE_MEM));
>  
> @@ -4896,14 +5115,17 @@ static void
>  lpfc_disable_pci_dev(struct lpfc_hba *phba)
>  {
>  	struct pci_dev *pdev;
> +	int bars;
>  
>  	/* Obtain PCI device reference */
>  	if (!phba->pcidev)
>  		return;
>  	else
>  		pdev = phba->pcidev;
> +	/* Select PCI BARs */
> +	bars = pci_select_bars(pdev, IORESOURCE_MEM);
>  	/* Release PCI resource and disable PCI device */
> -	pci_release_mem_regions(pdev);
> +	pci_release_selected_regions(pdev, bars);
>  	pci_disable_device(pdev);
>  

Ditto.

[...]

> +	for_each_present_cpu(cpu) {
> +		if (cpu_online(cpu))
> +			i++;
> +	}

I'm sure you want for_each_online_cpu(cpu)

[...]

> +	for (idx = 0; idx < phba->sli4_hba.num_present_cpu; idx++) {
> +		if (phba->cfg_nvme_io_channel && (idx < numwq)) {
> +			/* Create Fast Path NVME WQs. */
>  
> +			/* For NVME, every posted buffer potentially
> +			 * represents 1 IO and IOs are spread across
> +			 * cfg_nvme_max_hw_queue NVME hardware queues.
> +			 *
> +			 * Thus we need to ensure we have
> +			 * enough WQE slots in the WQs to address all IOs.
> +			 */
> +			cnt = phba->cfg_nvme_posted_buf /
> +				phba->cfg_nvme_max_hw_queue;
> +			if (cnt < LPFC_WQE128_DEF_COUNT)
> +				cnt = LPFC_WQE128_DEF_COUNT;
> +			qdesc = lpfc_sli4_queue_alloc(phba,
> +						      LPFC_WQE128_SIZE,
> +						      cnt);
> +			if (!qdesc) {
> +				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> +						"0509 Failed allocate "
> +						"fast-path NVME WQ (%d)\n",
> +						idx);
> +				goto out_error;
> +			}
> +			phba->sli4_hba.nvme_wq[idx] = qdesc;
> +			list_add_tail(&qdesc->wq_list,
> +				      &phba->sli4_hba.lpfc_wq_list);
> +		}
> +		if ((phba->cfg_fcp_io_channel) &&
> +		    (idx < phba->cfg_fcp_max_hw_queue)) {
> +			/* Create Fast Path FCP WQs */
> +			if (phba->fcp_embed_io) {
> +				qdesc = lpfc_sli4_queue_alloc(phba,
> +							LPFC_WQE128_SIZE,
> +							LPFC_WQE128_DEF_COUNT);
> +			} else {
> +				qdesc = lpfc_sli4_queue_alloc(phba,
> +						phba->sli4_hba.wq_esize,
> +						phba->sli4_hba.wq_ecount);
> +			}
> +			if (!qdesc) {
> +				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> +						"0503 Failed allocate "
> +						"fast-path FCP WQ (%d)\n",
> +						idx);
> +				goto out_error;
> +			}
> +			phba->sli4_hba.fcp_wq[idx] = qdesc;
> +			list_add_tail(&qdesc->wq_list,
> +				      &phba->sli4_hba.lpfc_wq_list);
> +		}
> +	}

Please try to factor out the body of the for loop or the bodies of the if
statements. Just don't let it shift so far to the right.

Thanks,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
