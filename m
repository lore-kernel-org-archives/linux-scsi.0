From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: RE: [PATCH] be2iscsi: switch to pci_alloc_irq_vectors
Date: Thu, 30 Mar 2017 14:35:42 +0530
Message-ID: <cfba32044a59f773049b12ca26d8ba5a@mail.gmail.com>
References: <1484324988-30962-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:35387 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932823AbdC3JFp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Mar 2017 05:05:45 -0400
Received: by mail-wr0-f175.google.com with SMTP id k6so45101927wre.2
        for <linux-scsi@vger.kernel.org>; Thu, 30 Mar 2017 02:05:44 -0700 (PDT)
In-Reply-To: <1484324988-30962-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Subramanian Seetharaman <subbu.seetharaman@broadcom.com>, Ketan Mukadam <ketan.mukadam@broadcom.com>, linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@lst.de]
> Sent: Friday, January 13, 2017 10:00 PM
> To: subbu.seetharaman@broadcom.com; ketan.mukadam@broadcom.com;
> jitendra.bhivare@broadcom.com; linux-scsi@vger.kernel.org
> Subject: [PATCH] be2iscsi: switch to pci_alloc_irq_vectors
>
> And get automatic MSI-X affinity for free.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/be2iscsi/be_main.c | 127
+++++++++++++---------------------------
>  drivers/scsi/be2iscsi/be_main.h |   2 -
>  2 files changed, 42 insertions(+), 87 deletions(-)
>
> diff --git a/drivers/scsi/be2iscsi/be_main.c
b/drivers/scsi/be2iscsi/be_main.c
> index 6372613..03faca8 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -801,12 +801,12 @@ static int beiscsi_init_irqs(struct beiscsi_hba
> *phba)
>  	struct pci_dev *pcidev = phba->pcidev;
>  	struct hwi_controller *phwi_ctrlr;
>  	struct hwi_context_memory *phwi_context;
> -	int ret, msix_vec, i, j;
> +	int ret, i, j;
>
>  	phwi_ctrlr = phba->phwi_ctrlr;
>  	phwi_context = phwi_ctrlr->phwi_ctxt;
>
> -	if (phba->msix_enabled) {
> +	if (pcidev->msix_enabled) {
>  		for (i = 0; i < phba->num_cpus; i++) {
>  			phba->msi_name[i] = kzalloc(BEISCSI_MSI_NAME,
>  						    GFP_KERNEL);
> @@ -817,9 +817,8 @@ static int beiscsi_init_irqs(struct beiscsi_hba
*phba)
>
>  			sprintf(phba->msi_name[i], "beiscsi_%02x_%02x",
>  				phba->shost->host_no, i);
> -			msix_vec = phba->msix_entries[i].vector;
> -			ret = request_irq(msix_vec, be_isr_msix, 0,
> -					  phba->msi_name[i],
> +			ret = request_irq(pci_irq_vector(pcidev, i),
> +					  be_isr_msix, 0,
phba->msi_name[i],
>  					  &phwi_context->be_eq[i]);
>  			if (ret) {
>  				beiscsi_log(phba, KERN_ERR,
> BEISCSI_LOG_INIT, @@ -837,9 +836,8 @@ static int
beiscsi_init_irqs(struct
> beiscsi_hba *phba)
>  		}
>  		sprintf(phba->msi_name[i], "beiscsi_mcc_%02x",
>  			phba->shost->host_no);
> -		msix_vec = phba->msix_entries[i].vector;
> -		ret = request_irq(msix_vec, be_isr_mcc, 0, phba-
> >msi_name[i],
> -				  &phwi_context->be_eq[i]);
> +		ret = request_irq(pci_irq_vector(pcidev, i), be_isr_mcc,
0,
> +				  phba->msi_name[i], &phwi_context-
> >be_eq[i]);
>  		if (ret) {
>  			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT ,
>  				    "BM_%d : beiscsi_init_irqs-"
> @@ -861,9 +859,8 @@ static int beiscsi_init_irqs(struct beiscsi_hba
*phba)
>  	return 0;
>  free_msix_irqs:
>  	for (j = i - 1; j >= 0; j--) {
> +		free_irq(pci_irq_vector(pcidev, i),
&phwi_context->be_eq[j]);
>  		kfree(phba->msi_name[j]);
> -		msix_vec = phba->msix_entries[j].vector;
> -		free_irq(msix_vec, &phwi_context->be_eq[j]);
>  	}
>  	return ret;
>  }
> @@ -3039,7 +3036,7 @@ static int beiscsi_create_eqs(struct beiscsi_hba
> *phba,
>  	num_eq_pages = PAGES_REQUIRED(phba->params.num_eq_entries *
> \
>  				      sizeof(struct be_eq_entry));
>
> -	if (phba->msix_enabled)
> +	if (phba->pcidev->msix_enabled)
>  		eq_for_mcc = 1;
>  	else
>  		eq_for_mcc = 0;
> @@ -3549,7 +3546,7 @@ static int be_mcc_queues_create(struct
> beiscsi_hba *phba,
>  			sizeof(struct be_mcc_compl)))
>  		goto err;
>  	/* Ask BE to create MCC compl queue; */
> -	if (phba->msix_enabled) {
> +	if (phba->pcidev->msix_enabled) {
>  		if (beiscsi_cmd_cq_create(ctrl, cq, &phwi_context->be_eq
>  					 [phba->num_cpus].q, false, true,
0))
>  		goto mcc_cq_free;
> @@ -3580,42 +3577,35 @@ static int be_mcc_queues_create(struct
> beiscsi_hba *phba,
>  	return -ENOMEM;
>  }
>
> -/**
> - * find_num_cpus()- Get the CPU online count
> - * @phba: ptr to priv structure
> - *
> - * CPU count is used for creating EQ.
> - **/
> -static void find_num_cpus(struct beiscsi_hba *phba)
> +static void be2iscsi_enable_msix(struct beiscsi_hba *phba)
>  {
> -	int  num_cpus = 0;
> -
> -	num_cpus = num_online_cpus();
> +	int nvec = 1;
>
>  	switch (phba->generation) {
>  	case BE_GEN2:
>  	case BE_GEN3:
> -		phba->num_cpus = (num_cpus > BEISCSI_MAX_NUM_CPUS) ?
> -				  BEISCSI_MAX_NUM_CPUS : num_cpus;
> +		nvec = BEISCSI_MAX_NUM_CPUS + 1;
>  		break;
>  	case BE_GEN4:
> -		/*
> -		 * If eqid_count == 1 fall back to
> -		 * INTX mechanism
> -		 **/
> -		if (phba->fw_config.eqid_count == 1) {
> -			enable_msix = 0;
> -			phba->num_cpus = 1;
> -			return;
> -		}
> -
> -		phba->num_cpus =
> -			(num_cpus > (phba->fw_config.eqid_count - 1)) ?
> -			(phba->fw_config.eqid_count - 1) : num_cpus;
> +		nvec = phba->fw_config.eqid_count;
>  		break;
>  	default:
> -		phba->num_cpus = 1;
> +		nvec = 2;
> +		break;
> +	}
> +
> +	/* if eqid_count == 1 fall back to INTX */
> +	if (enable_msix && nvec > 1) {
> +		const struct irq_affinity desc = { .post_vectors = 1 };
> +
> +		if (pci_alloc_irq_vectors_affinity(phba->pcidev, 2, nvec,
> +				PCI_IRQ_MSIX | PCI_IRQ_AFFINITY, &desc) <
> 0) {
> +			phba->num_cpus = nvec - 1;
> +			return;
> +		}
>  	}
> +
> +	phba->num_cpus = 1;
>  }
>
>  static void hwi_purge_eq(struct beiscsi_hba *phba) @@ -3632,7 +3622,7
> @@ static void hwi_purge_eq(struct beiscsi_hba *phba)
>
>  	phwi_ctrlr = phba->phwi_ctrlr;
>  	phwi_context = phwi_ctrlr->phwi_ctxt;
> -	if (phba->msix_enabled)
> +	if (phba->pcidev->msix_enabled)
>  		eq_msix = 1;
>  	else
>  		eq_msix = 0;
> @@ -3710,7 +3700,7 @@ static void hwi_cleanup_port(struct beiscsi_hba
> *phba)
>  	}
>
>  	be_mcc_queues_destroy(phba);
> -	if (phba->msix_enabled)
> +	if (phba->pcidev->msix_enabled)
>  		eq_for_mcc = 1;
>  	else
>  		eq_for_mcc = 0;
> @@ -4156,7 +4146,7 @@ static void hwi_enable_intr(struct beiscsi_hba
> *phba)
>  		iowrite32(reg, addr);
>  	}
>
> -	if (!phba->msix_enabled) {
> +	if (!phba->pcidev->msix_enabled) {
>  		eq = &phwi_context->be_eq[0].q;
>  		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
>  			    "BM_%d : eq->id=%d\n", eq->id);
> @@ -5279,19 +5269,6 @@ static void beiscsi_eqd_update_work(struct
> work_struct *work)
>
> msecs_to_jiffies(BEISCSI_EQD_UPDATE_INTERVAL));
>  }
>
> -static void beiscsi_msix_enable(struct beiscsi_hba *phba) -{
> -	int i, status;
> -
> -	for (i = 0; i <= phba->num_cpus; i++)
> -		phba->msix_entries[i].entry = i;
> -
> -	status = pci_enable_msix_range(phba->pcidev, phba->msix_entries,
> -				       phba->num_cpus + 1, phba->num_cpus
+
> 1);
> -	if (status > 0)
> -		phba->msix_enabled = true;
> -}
> -
>  static void beiscsi_hw_tpe_check(unsigned long ptr)  {
>  	struct beiscsi_hba *phba;
> @@ -5359,15 +5336,7 @@ static int beiscsi_enable_port(struct beiscsi_hba
> *phba)
>  	if (ret)
>  		return ret;
>
> -	if (enable_msix)
> -		find_num_cpus(phba);
> -	else
> -		phba->num_cpus = 1;
> -	if (enable_msix) {
> -		beiscsi_msix_enable(phba);
> -		if (!phba->msix_enabled)
> -			phba->num_cpus = 1;
> -	}
> +	be2iscsi_enable_msix(phba);
>
>  	beiscsi_get_params(phba);
>  	/* Re-enable UER. If different TPE occurs then it is recoverable.
*/
> @@ -5396,7 +5365,7 @@ static int beiscsi_enable_port(struct beiscsi_hba
> *phba)
>  		irq_poll_init(&pbe_eq->iopoll, be_iopoll_budget,
be_iopoll);
>  	}
>
> -	i = (phba->msix_enabled) ? i : 0;
> +	i = (phba->pcidev->msix_enabled) ? i : 0;
>  	/* Work item for MCC handling */
>  	pbe_eq = &phwi_context->be_eq[i];
>  	INIT_WORK(&pbe_eq->mcc_work, beiscsi_mcc_work); @@ -5434,9
> +5403,7 @@ static int beiscsi_enable_port(struct beiscsi_hba *phba)
>  	hwi_cleanup_port(phba);
>
>  disable_msix:
> -	if (phba->msix_enabled)
> -		pci_disable_msix(phba->pcidev);
> -
> +	pci_free_irq_vectors(phba->pcidev);
>  	return ret;
>  }
>
> @@ -5453,7 +5420,7 @@ static void beiscsi_disable_port(struct
beiscsi_hba
> *phba, int unload)
>  	struct hwi_context_memory *phwi_context;
>  	struct hwi_controller *phwi_ctrlr;
>  	struct be_eq_obj *pbe_eq;
> -	unsigned int i, msix_vec;
> +	unsigned int i;
>
>  	if (!test_and_clear_bit(BEISCSI_HBA_ONLINE, &phba->state))
>  		return;
> @@ -5461,16 +5428,16 @@ static void beiscsi_disable_port(struct
> beiscsi_hba *phba, int unload)
>  	phwi_ctrlr = phba->phwi_ctrlr;
>  	phwi_context = phwi_ctrlr->phwi_ctxt;
>  	hwi_disable_intr(phba);
> -	if (phba->msix_enabled) {
> +	if (phba->pcidev->msix_enabled) {
>  		for (i = 0; i <= phba->num_cpus; i++) {
> -			msix_vec = phba->msix_entries[i].vector;
> -			free_irq(msix_vec, &phwi_context->be_eq[i]);
> +			free_irq(pci_irq_vector(phba->pcidev, i),
> +				&phwi_context->be_eq[i]);
>  			kfree(phba->msi_name[i]);
>  		}
>  	} else
>  		if (phba->pcidev->irq)
>  			free_irq(phba->pcidev->irq, phba);
> -	pci_disable_msix(phba->pcidev);
> +	pci_free_irq_vectors(phba->pcidev);
>
>  	for (i = 0; i < phba->num_cpus; i++) {
>  		pbe_eq = &phwi_context->be_eq[i];
> @@ -5680,21 +5647,12 @@ static int beiscsi_dev_probe(struct pci_dev
> *pcidev,
>  	beiscsi_get_params(phba);
>  	beiscsi_set_uer_feature(phba);
>
> -	if (enable_msix)
> -		find_num_cpus(phba);
> -	else
> -		phba->num_cpus = 1;
> +	be2iscsi_enable_msix(phba);
>
>  	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
>  		    "BM_%d : num_cpus = %d\n",
>  		    phba->num_cpus);
>
> -	if (enable_msix) {
> -		beiscsi_msix_enable(phba);
> -		if (!phba->msix_enabled)
> -			phba->num_cpus = 1;
> -	}
> -
>  	phba->shost->max_id = phba->params.cxns_per_ctrl;
>  	phba->shost->can_queue = phba->params.ios_per_ctrl;
>  	ret = beiscsi_get_memory(phba);
> @@ -5744,7 +5702,7 @@ static int beiscsi_dev_probe(struct pci_dev
> *pcidev,
>  		irq_poll_init(&pbe_eq->iopoll, be_iopoll_budget,
be_iopoll);
>  	}
>
> -	i = (phba->msix_enabled) ? i : 0;
> +	i = (phba->pcidev->msix_enabled) ? i : 0;
>  	/* Work item for MCC handling */
>  	pbe_eq = &phwi_context->be_eq[i];
>  	INIT_WORK(&pbe_eq->mcc_work, beiscsi_mcc_work); @@ -5815,8
> +5773,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
>  			   phba->ctrl.mbox_mem_alloced.dma);
>  	beiscsi_unmap_pci_function(phba);
>  hba_free:
> -	if (phba->msix_enabled)
> -		pci_disable_msix(phba->pcidev);
> +	pci_disable_msix(phba->pcidev);
>  	pci_dev_put(phba->pcidev);
>  	iscsi_host_free(phba->shost);
>  	pci_set_drvdata(pcidev, NULL);
> diff --git a/drivers/scsi/be2iscsi/be_main.h
b/drivers/scsi/be2iscsi/be_main.h
> index 2188579..d1d03ee 100644
> --- a/drivers/scsi/be2iscsi/be_main.h
> +++ b/drivers/scsi/be2iscsi/be_main.h
> @@ -323,9 +323,7 @@ struct beiscsi_hba {
>  	struct pci_dev *pcidev;
>  	unsigned int num_cpus;
>  	unsigned int nxt_cqid;
> -	struct msix_entry msix_entries[MAX_CPUS];
>  	char *msi_name[MAX_CPUS];
> -	bool msix_enabled;
>  	struct be_mem_descriptor *init_mem;
>
>  	unsigned short io_sgl_alloc_index;
> --
> 2.1.4

Reviewed-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
