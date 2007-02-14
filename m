From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] lpfc: add PCI error recovery support
Date: Wed, 14 Feb 2007 16:12:14 -0500
Message-ID: <45D37B2E.5050704@emulex.com>
References: <20070214202836.GS923@austin.ibm.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:36517 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932603AbXBNVVk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Feb 2007 16:21:40 -0500
In-Reply-To: <20070214202836.GS923@austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linas Vepstas <linas@austin.ibm.com>
Cc: James.Bottomley@SteelEye.com, linuxppc-dev@ozlabs.org, linux-pci@atrey.karlin.mff.cuni.cz, linux-scsi@vger.kernel.org, rlary@us.ibm.com, Bino.Sebastian@Emulex.Com, linux-kernel@vger.kernel.org

ACK - the patch is fine for lpfc....

-- james s


Linas Vepstas wrote:
> James,
> 
> Please review and forward upstream.  This is a patch I'd previously
> submitted, and reworked by Bino.Sebastian@Emulex.Com in January.
> Not clear if I need to also nag James Smart (who is listed as the
> maintainer) for an Acked-by (which I am lead to beleive should be
> forthcoming? Ahh the joys of indirect communication!)
> 
> --linas
> 
> This patch adds PCI Error recovery support to the
> Emulex Lightpulse Fibrechannel (lpfc) SCSI device driver.
> Lightly tested at this point, works.
> 
> Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
> Signed-off-by: Bino.Sebastian@Emulex.Com
> Cc: James Smart <james.smart@emulex.com>
> 
> ----
> 
>  drivers/scsi/lpfc/lpfc_init.c |   97 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/lpfc/lpfc_sli.c  |   12 +++++
>  2 files changed, 109 insertions(+)
> 
> Index: linux-2.6.20-git4/drivers/scsi/lpfc/lpfc_init.c
> ===================================================================
> --- linux-2.6.20-git4.orig/drivers/scsi/lpfc/lpfc_init.c	2007-02-09 17:22:30.000000000 -0600
> +++ linux-2.6.20-git4/drivers/scsi/lpfc/lpfc_init.c	2007-02-14 14:12:22.000000000 -0600
> @@ -518,6 +518,10 @@ lpfc_handle_eratt(struct lpfc_hba * phba
>  	struct lpfc_sli *psli = &phba->sli;
>  	struct lpfc_sli_ring  *pring;
>  	uint32_t event_data;
> +	/* If the pci channel is offline, ignore possible errors,
> +	 * since we cannot communicate with the pci card anyway. */
> +	if (pci_channel_offline(phba->pcidev))
> +		return;
>  
>  	if (phba->work_hs & HS_FFER6 ||
>  	    phba->work_hs & HS_FFER5) {
> @@ -1797,6 +1801,92 @@ lpfc_pci_remove_one(struct pci_dev *pdev
>  	pci_set_drvdata(pdev, NULL);
>  }
>  
> +/**
> + * lpfc_io_error_detected - called when PCI error is detected
> + * @pdev: Pointer to PCI device
> + * @state: The current pci conneection state
> + *
> + * This function is called after a PCI bus error affecting
> + * this device has been detected.
> + */
> +static pci_ers_result_t lpfc_io_error_detected(struct pci_dev *pdev,
> +				pci_channel_state_t state)
> +{
> +	struct Scsi_Host *host = pci_get_drvdata(pdev);
> +	struct lpfc_hba *phba = (struct lpfc_hba *)host->hostdata;
> +	struct lpfc_sli *psli = &phba->sli;
> +	struct lpfc_sli_ring  *pring;
> +
> +	if (state == pci_channel_io_perm_failure) {
> +		lpfc_pci_remove_one(pdev);
> +		return PCI_ERS_RESULT_DISCONNECT;
> +	}
> +	pci_disable_device(pdev);
> +	/*
> +	 * There may be I/Os dropped by the firmware.
> +	 * Error iocb (I/O) on txcmplq and let the SCSI layer
> +	 * retry it after re-establishing link.
> +	 */
> +	pring = &psli->ring[psli->fcp_ring];
> +	lpfc_sli_abort_iocb_ring(phba, pring);
> +
> +	/* Request a slot reset. */
> +	return PCI_ERS_RESULT_NEED_RESET;
> +}
> +
> +/**
> + * lpfc_io_slot_reset - called after the pci bus has been reset.
> + * @pdev: Pointer to PCI device
> + *
> + * Restart the card from scratch, as if from a cold-boot.
> + */
> +static pci_ers_result_t lpfc_io_slot_reset(struct pci_dev *pdev)
> +{
> +	struct Scsi_Host *host = pci_get_drvdata(pdev);
> +	struct lpfc_hba *phba = (struct lpfc_hba *)host->hostdata;
> +	struct lpfc_sli *psli = &phba->sli;
> +	int bars = pci_select_bars(pdev, IORESOURCE_MEM);
> +
> +	dev_printk(KERN_INFO, &pdev->dev, "recovering from a slot reset.\n");
> +	if (pci_enable_device_bars(pdev, bars)) {
> +		printk(KERN_ERR "lpfc: Cannot re-enable "
> +			"PCI device after reset.\n");
> +		return PCI_ERS_RESULT_DISCONNECT;
> +	}
> +
> +	pci_set_master(pdev);
> +
> +	/* Re-establishing Link */
> +	spin_lock_irq(phba->host->host_lock);
> +	phba->fc_flag |= FC_ESTABLISH_LINK;
> +	psli->sli_flag &= ~LPFC_SLI2_ACTIVE;
> +	spin_unlock_irq(phba->host->host_lock);
> +
> +
> +	/* Take device offline; this will perform cleanup */
> +	lpfc_offline(phba);
> +	lpfc_sli_brdrestart(phba);
> +
> +	return PCI_ERS_RESULT_RECOVERED;
> +}
> +
> +/**
> + * lpfc_io_resume - called when traffic can start flowing again.
> + * @pdev: Pointer to PCI device
> + *
> + * This callback is called when the error recovery driver tells us that
> + * its OK to resume normal operation.
> + */
> +static void lpfc_io_resume(struct pci_dev *pdev)
> +{
> +	struct Scsi_Host *host = pci_get_drvdata(pdev);
> +	struct lpfc_hba *phba = (struct lpfc_hba *)host->hostdata;
> +
> +	if (lpfc_online(phba) == 0) {
> +		mod_timer(&phba->fc_estabtmo, jiffies + HZ * 60);
> +	}
> +}
> +
>  static struct pci_device_id lpfc_id_table[] = {
>  	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_VIPER,
>  		PCI_ANY_ID, PCI_ANY_ID, },
> @@ -1857,11 +1947,18 @@ static struct pci_device_id lpfc_id_tabl
>  
>  MODULE_DEVICE_TABLE(pci, lpfc_id_table);
>  
> +static struct pci_error_handlers lpfc_err_handler = {
> +	.error_detected = lpfc_io_error_detected,
> +	.slot_reset = lpfc_io_slot_reset,
> +	.resume = lpfc_io_resume,
> +};
> +
>  static struct pci_driver lpfc_driver = {
>  	.name		= LPFC_DRIVER_NAME,
>  	.id_table	= lpfc_id_table,
>  	.probe		= lpfc_pci_probe_one,
>  	.remove		= __devexit_p(lpfc_pci_remove_one),
> +	.err_handler = &lpfc_err_handler,
>  };
>  
>  static int __init
> Index: linux-2.6.20-git4/drivers/scsi/lpfc/lpfc_sli.c
> ===================================================================
> --- linux-2.6.20-git4.orig/drivers/scsi/lpfc/lpfc_sli.c	2007-02-09 17:22:30.000000000 -0600
> +++ linux-2.6.20-git4/drivers/scsi/lpfc/lpfc_sli.c	2007-02-14 14:01:31.000000000 -0600
> @@ -2104,6 +2104,10 @@ lpfc_sli_issue_mbox(struct lpfc_hba * ph
>  	volatile uint32_t word0, ldata;
>  	void __iomem *to_slim;
>  
> +	/* If the PCI channel is in offline state, do not post mbox. */
> +	if (unlikely(pci_channel_offline(phba->pcidev)))
> +		return MBX_NOT_FINISHED;
> +
>  	psli = &phba->sli;
>  
>  	spin_lock_irqsave(phba->host->host_lock, drvr_flag);
> @@ -2407,6 +2411,10 @@ lpfc_sli_issue_iocb(struct lpfc_hba *phb
>  	struct lpfc_iocbq *nextiocb;
>  	IOCB_t *iocb;
>  
> +	/* If the PCI channel is in offline state, do not post iocbs. */
> +	if (unlikely(pci_channel_offline(phba->pcidev)))
> +		return IOCB_ERROR;
> +
>  	/*
>  	 * We should never get an IOCB if we are in a < LINK_DOWN state
>  	 */
> @@ -3154,6 +3162,10 @@ lpfc_intr_handler(int irq, void *dev_id)
>  	if (unlikely(!phba))
>  		return IRQ_NONE;
>  
> +	/* If the pci channel is offline, ignore all the interrupts. */
> +	if (unlikely(pci_channel_offline(phba->pcidev)))
> +		return IRQ_NONE;
> +
>  	phba->sli.slistat.sli_intr++;
>  
>  	/*
> 
