From: wenxiong@linux.vnet.ibm.com
Subject: Re: [PATCH v2 1/3] cxlflash: Base error recovery support
Date: Wed, 29 Jul 2015 18:12:53 -0400
Message-ID: <20150729181253.Horde.skEaoxQBlFsVmLXOtcyLAw7@ltc.linux.ibm.com>
References: <1437089195-52118-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <55B13A99.7030603@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:57678 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbbG2WM6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2015 18:12:58 -0400
Received: from /spool/local
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wenxiong@linux.vnet.ibm.com>;
	Wed, 29 Jul 2015 18:12:57 -0400
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 70A9BC90042
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2015 18:04:01 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t6TMCtYI62455946
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2015 22:12:55 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t6TMCr24003615
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2015 18:12:55 -0400
In-Reply-To: <55B13A99.7030603@linux.vnet.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mrochs@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com
Cc: hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, wenxiong@linux.vnet.ibm.com


> Subject: [PATCH v2 1/3] cxlflash: Base error recovery support
> Date: Thu, 16 Jul 2015 18:26:35 -0500
> From: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> To: linux-scsi@vger.kernel.org,  
> James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org,  
> brking@linux.vnet.ibm.com
> CC: hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com,  
> dja@ozlabs.au.ibm.com, Manoj N. Kumar <manoj@linux.vnet.ibm.com>
>
> Introduce support for enhanced I/O error handling.
>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
> ---
>  drivers/scsi/cxlflash/common.h |  11 +++-
>  drivers/scsi/cxlflash/main.c   | 135  
> ++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 133 insertions(+), 13 deletions(-)
>

> +/**
> + * cxlflash_pci_error_detected() - called when a PCI error is detected
> + * @pdev:	PCI device struct.
> + * @state:	PCI channel state.
> + *
> + * Return: PCI_ERS_RESULT_NEED_RESET or PCI_ERS_RESULT_DISCONNECT
> + */
> +static pci_ers_result_t cxlflash_pci_error_detected(struct pci_dev *pdev,
> +						    pci_channel_state_t state)
> +{
> +	struct cxlflash_cfg *cfg = pci_get_drvdata(pdev);
> +
> +	pr_debug("%s: pdev=%p state=%u\n", __func__, pdev, state);
> +
> +	switch (state) {
> +	case pci_channel_io_frozen:
> +		cfg->eeh_active = EEH_STATE_ACTIVE;
> +		udelay(100);
> +
> +		term_mc(cfg, UNDO_START);
> +		stop_afu(cfg);
> +
> +		return PCI_ERS_RESULT_CAN_RECOVER;
> +	case pci_channel_io_perm_failure:
> +		cfg->eeh_active = EEH_STATE_FAILED;
> +		wake_up_all(&cfg->eeh_waitq);
> +		return PCI_ERS_RESULT_DISCONNECT;
> +	default:
> +		break;
> +	}
> +	return PCI_ERS_RESULT_NEED_RESET;
> +}
> +
> +/**
> + * cxlflash_pci_slot_reset() - called when PCI slot has been reset
> + * @pdev:	PCI device struct.
> + *
> + * This routine is called by the pci error recovery code after the PCI
> + * slot has been reset, just before we should resume normal operations.
> + *
> + * Return: PCI_ERS_RESULT_RECOVERED or PCI_ERS_RESULT_DISCONNECT
> + */
> +static pci_ers_result_t cxlflash_pci_slot_reset(struct pci_dev *pdev)
> +{
> +	int rc = 0;
> +	struct cxlflash_cfg *cfg = pci_get_drvdata(pdev);
> +
> +	pr_debug("%s: pdev=%p\n", __func__, pdev);
> +
> +	rc = init_afu(cfg);
> +	if (unlikely(rc)) {
> +		pr_err("%s: EEH recovery failed! (%d)\n", __func__, rc);
> +		return PCI_ERS_RESULT_DISCONNECT;
> +	}
> +
> +	return PCI_ERS_RESULT_RECOVERED;
> +}
> +
> +/**
> + * cxlflash_pci_resume() - called when normal operation can resume
> + * @pdev:	PCI device struct
> + */
> +static void cxlflash_pci_resume(struct pci_dev *pdev)
> +{
> +	struct cxlflash_cfg *cfg = pci_get_drvdata(pdev);
> +
> +	pr_debug("%s: pdev=%p\n", __func__, pdev);
> +
> +	cfg->eeh_active = EEH_STATE_NONE;
> +	wake_up_all(&cfg->eeh_waitq);
> +}
> +

Do you need host->lock in these EEH callback functions?

> +static const struct pci_error_handlers cxlflash_err_handler = {
> +	.error_detected = cxlflash_pci_error_detected,
> +	.slot_reset = cxlflash_pci_slot_reset,
> +	.resume = cxlflash_pci_resume,
> +};
> +
>  /*
>   * PCI device structure
>   */
> @@ -2267,6 +2381,7 @@ static struct pci_driver cxlflash_driver = {
>  	.id_table = cxlflash_pci_table,
>  	.probe = cxlflash_probe,
>  	.remove = cxlflash_remove,
> +	.err_handler = &cxlflash_err_handler,
>  };
>
>  /**
> -- 
> 2.1.0

Thanks,
Wendy

