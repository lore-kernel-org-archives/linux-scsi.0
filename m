From: wenxiong@linux.vnet.ibm.com
Subject: Re: [PATCH 2/6] ipr: Reset in task context
Date: Fri, 27 Mar 2015 12:49:41 -0400
Message-ID: <20150327124941.Horde.IueHaooiD8os75YKfXvs6Q1@ltc.linux.ibm.com>
References: <201503261623.t2QGNqZe002091@d01av05.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:54899 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbbC0Qtq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2015 12:49:46 -0400
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wenxiong@linux.vnet.ibm.com>;
	Fri, 27 Mar 2015 10:49:45 -0600
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id CED1D19D8042
	for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2015 10:40:49 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t2RGlwKG28049450
	for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2015 09:47:58 -0700
Received: from d03av02.boulder.ibm.com (localhost [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t2RGngKc010475
	for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2015 10:49:43 -0600
In-Reply-To: <201503261623.t2QGNqZe002091@d01av05.pok.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@hansenpartnership.com, hch@lst.de, linux-scsi@vger.kernel.org, kreling@linux.vnet.ibm.com, krisman@linux.vnet.ibm.com

Reviewed-by: Wen Xiong<wenxiong@linux.vnet.ibm.com>

Thanks,
Wendy

Quoting Brian King <brking@linux.vnet.ibm.com>:

> The pci_set_pcie_reset_state has changed semantics to not be callable
> from interrupt context, so change ipr's usage of the API to comply with
> this change by ensuring this occurs from a workqueue.
>
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> ---
>
>  drivers/scsi/ipr.c |   91  
> +++++++++++++++++++++++++++++++++++++----------------
>  drivers/scsi/ipr.h |    2 +
>  2 files changed, 67 insertions(+), 26 deletions(-)
>
> diff -puN drivers/scsi/ipr.c~ipr_reset_task drivers/scsi/ipr.c
> --- linux/drivers/scsi/ipr.c~ipr_reset_task	2015-03-26  
> 11:14:39.103798589 -0500
> +++ linux-bjking1/drivers/scsi/ipr.c	2015-03-26 11:14:39.113798523 -0500
> @@ -8320,7 +8320,6 @@ static int ipr_reset_start_bist(struct i
>  static int ipr_reset_slot_reset_done(struct ipr_cmnd *ipr_cmd)
>  {
>  	ENTER;
> -	pci_set_pcie_reset_state(ipr_cmd->ioa_cfg->pdev, pcie_deassert_reset);
>  	ipr_cmd->job_step = ipr_reset_bist_done;
>  	ipr_reset_start_timer(ipr_cmd, IPR_WAIT_FOR_BIST_TIMEOUT);
>  	LEAVE;
> @@ -8328,6 +8327,32 @@ static int ipr_reset_slot_reset_done(str
>  }
>
>  /**
> + * ipr_reset_reset_work - Pulse a PCIe fundamental reset
> + * @work:	work struct
> + *
> + * Description: This pulses warm reset to a slot.
> + *
> + **/
> +static void ipr_reset_reset_work(struct work_struct *work)
> +{
> +	struct ipr_cmnd *ipr_cmd = container_of(work, struct ipr_cmnd, work);
> +	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
> +	struct pci_dev *pdev = ioa_cfg->pdev;
> +	unsigned long lock_flags = 0;
> +
> +	ENTER;
> +	pci_set_pcie_reset_state(pdev, pcie_warm_reset);
> +	msleep(jiffies_to_msecs(IPR_PCI_RESET_TIMEOUT));
> +	pci_set_pcie_reset_state(pdev, pcie_deassert_reset);
> +
> +	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
> +	if (ioa_cfg->reset_cmd == ipr_cmd)
> +		ipr_reset_ioa_job(ipr_cmd);
> +	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
> +	LEAVE;
> +}
> +
> +/**
>   * ipr_reset_slot_reset - Reset the PCI slot of the adapter.
>   * @ipr_cmd:	ipr command struct
>   *
> @@ -8339,12 +8364,11 @@ static int ipr_reset_slot_reset_done(str
>  static int ipr_reset_slot_reset(struct ipr_cmnd *ipr_cmd)
>  {
>  	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
> -	struct pci_dev *pdev = ioa_cfg->pdev;
>
>  	ENTER;
> -	pci_set_pcie_reset_state(pdev, pcie_warm_reset);
> +	INIT_WORK(&ipr_cmd->work, ipr_reset_reset_work);
> +	queue_work(ioa_cfg->reset_work_q, &ipr_cmd->work);
>  	ipr_cmd->job_step = ipr_reset_slot_reset_done;
> -	ipr_reset_start_timer(ipr_cmd, IPR_PCI_RESET_TIMEOUT);
>  	LEAVE;
>  	return IPR_RC_JOB_RETURN;
>  }
> @@ -9093,26 +9117,25 @@ static void ipr_free_mem(struct ipr_ioa_
>  }
>
>  /**
> - * ipr_free_all_resources - Free all allocated resources for an adapter.
> - * @ipr_cmd:	ipr command struct
> + * ipr_free_irqs - Free all allocated IRQs for the adapter.
> + * @ioa_cfg:	ipr cfg struct
>   *
> - * This function frees all allocated resources for the
> + * This function frees all allocated IRQs for the
>   * specified adapter.
>   *
>   * Return value:
>   * 	none
>   **/
> -static void ipr_free_all_resources(struct ipr_ioa_cfg *ioa_cfg)
> +static void ipr_free_irqs(struct ipr_ioa_cfg *ioa_cfg)
>  {
>  	struct pci_dev *pdev = ioa_cfg->pdev;
>
> -	ENTER;
>  	if (ioa_cfg->intr_flag == IPR_USE_MSI ||
>  	    ioa_cfg->intr_flag == IPR_USE_MSIX) {
>  		int i;
>  		for (i = 0; i < ioa_cfg->nvectors; i++)
>  			free_irq(ioa_cfg->vectors_info[i].vec,
> -				&ioa_cfg->hrrq[i]);
> +				 &ioa_cfg->hrrq[i]);
>  	} else
>  		free_irq(pdev->irq, &ioa_cfg->hrrq[0]);
>
> @@ -9123,7 +9146,26 @@ static void ipr_free_all_resources(struc
>  		pci_disable_msix(pdev);
>  		ioa_cfg->intr_flag &= ~IPR_USE_MSIX;
>  	}
> +}
> +
> +/**
> + * ipr_free_all_resources - Free all allocated resources for an adapter.
> + * @ipr_cmd:	ipr command struct
> + *
> + * This function frees all allocated resources for the
> + * specified adapter.
> + *
> + * Return value:
> + * 	none
> + **/
> +static void ipr_free_all_resources(struct ipr_ioa_cfg *ioa_cfg)
> +{
> +	struct pci_dev *pdev = ioa_cfg->pdev;
>
> +	ENTER;
> +	ipr_free_irqs(ioa_cfg);
> +	if (ioa_cfg->reset_work_q)
> +		destroy_workqueue(ioa_cfg->reset_work_q);
>  	iounmap(ioa_cfg->hdw_dma_regs);
>  	pci_release_regions(pdev);
>  	ipr_free_mem(ioa_cfg);
> @@ -9943,6 +9985,14 @@ static int ipr_probe_ioa(struct pci_dev
>  	    (dev_id->device == PCI_DEVICE_ID_IBM_OBSIDIAN_E && !ioa_cfg->revid)) {
>  		ioa_cfg->needs_warm_reset = 1;
>  		ioa_cfg->reset = ipr_reset_slot_reset;
> +
> +		ioa_cfg->reset_work_q = alloc_ordered_workqueue("ipr_reset_%d",
> +								WQ_MEM_RECLAIM, host->host_no);
> +
> +		if (!ioa_cfg->reset_work_q) {
> +			dev_err(&pdev->dev, "Couldn't register reset workqueue\n");
> +			goto out_free_irq;
> +		}
>  	} else
>  		ioa_cfg->reset = ipr_reset_start_bist;
>
> @@ -9954,6 +10004,8 @@ static int ipr_probe_ioa(struct pci_dev
>  out:
>  	return rc;
>
> +out_free_irq:
> +	ipr_free_irqs(ioa_cfg);
>  cleanup_nolog:
>  	ipr_free_mem(ioa_cfg);
>  out_msi_disable:
> @@ -10034,6 +10086,8 @@ static void __ipr_remove(struct pci_dev
>  	spin_unlock_irqrestore(ioa_cfg->host->host_lock, host_lock_flags);
>  	wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
>  	flush_work(&ioa_cfg->work_q);
> +	if (ioa_cfg->reset_work_q)
> +		flush_workqueue(ioa_cfg->reset_work_q);
>  	INIT_LIST_HEAD(&ioa_cfg->used_res_q);
>  	spin_lock_irqsave(ioa_cfg->host->host_lock, host_lock_flags);
>
> @@ -10179,22 +10233,7 @@ static void ipr_shutdown(struct pci_dev
>  	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
>  	wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
>  	if (ipr_fast_reboot && system_state == SYSTEM_RESTART && ioa_cfg->sis64) {
> -		if (ioa_cfg->intr_flag == IPR_USE_MSI ||
> -		    ioa_cfg->intr_flag == IPR_USE_MSIX) {
> -			int i;
> -			for (i = 0; i < ioa_cfg->nvectors; i++)
> -				free_irq(ioa_cfg->vectors_info[i].vec,
> -					 &ioa_cfg->hrrq[i]);
> -		}
> -
> -		if (ioa_cfg->intr_flag == IPR_USE_MSI) {
> -			pci_disable_msi(ioa_cfg->pdev);
> -			ioa_cfg->intr_flag &= ~IPR_USE_MSI;
> -		} else if (ioa_cfg->intr_flag == IPR_USE_MSIX) {
> -			pci_disable_msix(ioa_cfg->pdev);
> -			ioa_cfg->intr_flag &= ~IPR_USE_MSIX;
> -		}
> -
> +		ipr_free_irqs(ioa_cfg);
>  		pci_disable_device(ioa_cfg->pdev);
>  	}
>  }
> diff -puN drivers/scsi/ipr.h~ipr_reset_task drivers/scsi/ipr.h
> --- linux/drivers/scsi/ipr.h~ipr_reset_task	2015-03-26  
> 11:14:39.107798561 -0500
> +++ linux-bjking1/drivers/scsi/ipr.h	2015-03-26 11:14:39.123798456 -0500
> @@ -1540,6 +1540,7 @@ struct ipr_ioa_cfg {
>  	u8 saved_mode_page_len;
>
>  	struct work_struct work_q;
> +	struct workqueue_struct *reset_work_q;
>
>  	wait_queue_head_t reset_wait_q;
>  	wait_queue_head_t msi_wait_q;
> @@ -1591,6 +1592,7 @@ struct ipr_cmnd {
>  	struct ata_queued_cmd *qc;
>  	struct completion completion;
>  	struct timer_list timer;
> +	struct work_struct work;
>  	void (*fast_done) (struct ipr_cmnd *);
>  	void (*done) (struct ipr_cmnd *);
>  	int (*job_step) (struct ipr_cmnd *);
> _


