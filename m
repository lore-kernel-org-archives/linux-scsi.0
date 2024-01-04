Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C552D600
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jan 2024 23:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JnTUAbTu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD09C433C7;
	Thu,  4 Jan 2024 23:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704412186;
	bh=Aeg8Kyi0LEyQP7r5EGQNWCEWehjuO4pmL7LY5kjWBbc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=JnTUAbTuqin/s+/tFy9JCP4tOTC6HwlhkwyRL1J9zM/dQbNaELtmAbHnjKHung3to
	 XLfZYyq/HlS4Q0TqHrg/EWfan3ZlsseufCYrgbQHkcXlVw1iHeSD9EGEDk+QDakiTj
	 YQGCfIoM+mfJrOoIuWMFxb21EVGHXiRvbTkPNemRdVH6tHZHAqRbqOIwgfx0ArsbWa
	 SMqeI3p2Dnu1lN4jDqnJql+tBLU8GuiK3qtlsoAFXD69pKyH9ubHz39KiIF78YhuCm
	 w+IOfVYATE3+jKv0f6Avu8aIAYdKY4hN0GiyxikcA+ty+jaX/1+Mcv7xnZLQpknxlQ
	 vVkJbXBh+vKoA==
Date: Thu, 4 Jan 2024 17:49:45 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
	rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com
Subject: Re: [PATCH v2 2/6] mpi3mr: Support PCIe Error Recovery callback
 handlers
Message-ID: <20240104234945.GA1831894@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214205900.270488-3-ranjan.kumar@broadcom.com>

On Fri, Dec 15, 2023 at 02:28:56AM +0530, Ranjan Kumar wrote:
> The driver has been upgraded to include support for the
> PCIe error recovery callback handler which is crucial for
> the recovery of the controllers. This feature is
> necessary for addressing the errors reported by
> the PCIe AER (Advanced Error Reporting) mechanism.

I think PCI error handling is not strictly limited to PCIe AER because
the powerpc EEH framework also uses the pci_error_handlers callbacks,
so I would refer to this as just "PCI error recovery" and maybe omit
the AER part.

Commit log and comments appear to be wrapped to 60 or 70 columns,
which is unnecessarily short.  I'd recommend 75 columns for commit
log, maybe 78 for comments.

> Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
> ---
>  drivers/scsi/mpi3mr/mpi3mr.h    |   5 +
>  drivers/scsi/mpi3mr/mpi3mr_os.c | 197 ++++++++++++++++++++++++++++++++
>  2 files changed, 202 insertions(+)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index 3de1ee05c44e..25e6e3a09468 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -23,6 +23,7 @@
>  #include <linux/miscdevice.h>
>  #include <linux/module.h>
>  #include <linux/pci.h>
> +#include <linux/aer.h>
>  #include <linux/poll.h>
>  #include <linux/sched.h>
>  #include <linux/slab.h>
> @@ -1055,6 +1056,8 @@ struct scmd_priv {
>   * @ioctl_chain_sge: DMA buffer descriptor for IOCTL chain
>   * @ioctl_resp_sge: DMA buffer descriptor for Mgmt cmd response
>   * @ioctl_sges_allocated: Flag for IOCTL SGEs allocated or not
> + * @pcie_err_recovery: PCIe error recovery in progress
> + * @block_on_pcie_err: Block IO during PCI error recovery

s/PCIe error recovery/PCI error recovery/ so they match.

>  struct mpi3mr_ioc {
>  	struct list_head list;
> @@ -1246,6 +1249,8 @@ struct mpi3mr_ioc {
>  	struct dma_memory_desc ioctl_chain_sge;
>  	struct dma_memory_desc ioctl_resp_sge;
>  	bool ioctl_sges_allocated;
> +	bool pcie_err_recovery;
> +	bool block_on_pcie_err;
>  };
>  
>  /**
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index 76ba31a9517d..dea47ef53abb 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -5472,6 +5472,195 @@ mpi3mr_resume(struct device *dev)
>  	return 0;
>  }
>  
> +/**
> + * mpi3mr_pcierr_detected - PCI error detected callback
> + * @pdev: PCI device instance
> + * @state: channel state
> + *
> + * This function is called by the PCI error recovery driver and
> + * based on the state passed the driver decides what actions to
> + * be recommended back to PCI driver.
> + *
> + * For all of the states if there is no valid mrioc or scsi host
> + * references in the pci device then this function will retyrn
> + * the resul as disconnect.

s/pci device/PCI device/ to match other uses
s/retyrn/return/
s/resul/result/

> + * For normal state, this function will return the result as can
> + * recover.
> + *
> + * For frozen state, this function will block for any pennding

s/pennding/pending/

> + * controller initialization or re-initialization to complete,
> + * stop any new interactions with the controller and return
> + * status as reset required.
> + *
> + * For permanent failure state, this function will mark the
> + * controller as unrecoverable and return status as disconnect.
> + *
> + * Returns: PCI_ERS_RESULT_NEED_RESET or CAN_RECOVER or
> + * DISCONNECT based on the controller state.
> + */
> +static pci_ers_result_t
> +mpi3mr_pcierr_detected(struct pci_dev *pdev, pci_channel_state_t state)
> +{
> +	struct Scsi_Host *shost;
> +	struct mpi3mr_ioc *mrioc;
> +	pci_ers_result_t ret_val = PCI_ERS_RESULT_DISCONNECT;
> +
> +	dev_info(&pdev->dev, "%s: callback invoked state(%d)\n", __func__,
> +	    state);
> +
> +	if (mpi3mr_get_shost_and_mrioc(pdev, &shost, &mrioc)) {
> +		dev_err(&pdev->dev, "device not available\n");
> +		return ret_val;

Since you already know the return value here, use it explicitly:

  return PCI_ERS_RESULT_DISCONNECT;

> +	}
> +
> +	switch (state) {
> +	case pci_channel_io_normal:
> +		ret_val = PCI_ERS_RESULT_CAN_RECOVER;

Personally, I would just return directly from each case instead of
assigning "ret_val".

> +		break;
> +	case pci_channel_io_frozen:
> +		mrioc->pcie_err_recovery = true;
> +		mrioc->block_on_pcie_err = true;
> +		while (mrioc->reset_in_progress || mrioc->is_driver_loading)
> +			ssleep(1);

This looks like a potential hang.  What guarantees that one of these
is eventually set?

> +		scsi_block_requests(mrioc->shost);
> +		mpi3mr_stop_watchdog(mrioc);
> +		mpi3mr_cleanup_resources(mrioc);

Why are mpi3mr_cleanup_resources() and mpi3mr_setup_resources()
needed?

> +		mrioc->pdev = NULL;

Seems weird to clear mrioc->pdev and then restore it later.  What does
this accomplish?

> +		ret_val = PCI_ERS_RESULT_NEED_RESET;
> +		break;
> +	case pci_channel_io_perm_failure:
> +		mrioc->pcie_err_recovery = true;
> +		mrioc->block_on_pcie_err = true;
> +		mrioc->unrecoverable = 1;
> +		mpi3mr_stop_watchdog(mrioc);
> +		mpi3mr_flush_cmds_for_unrecovered_controller(mrioc);
> +		ret_val = PCI_ERS_RESULT_DISCONNECT;
> +		break;
> +	default:
> +		break;
> +	}
> +	return ret_val;

Then this could become "return PCI_ERS_RESULT_DISCONNECT;" and you
don't need "ret_val" at all.

> +}
> +
> +/**
> + * mpi3mr_pcierr_slot_reset_done - Post slot reset callback
> + * @pdev: PCI device instance
> + *
> + * This function is called by the PCI error recovery driver
> + * after a slot or link reset issued by it for the recovery, the
> + * driver is expected to bring back the controller and
> + * initialize it.
> + *
> + * This function restores pci state and reinitializes controller
> + * resoruces and the controller, this blocks for any pending
> + * reset to complete.

s/pci state/PCI state/ to match other uses
s/resoruces/resources/

> + * Returns: PCI_ERS_RESULT_DISCONNECT on failure or
> + * PCI_ERS_RESULT_RECOVERED
> + */
> +static pci_ers_result_t mpi3mr_pcierr_slot_reset_done(struct pci_dev *pdev)
> +{
> +	struct Scsi_Host *shost;
> +	struct mpi3mr_ioc *mrioc;
> +
> +

Spurious blank line.

> +	dev_info(&pdev->dev, "%s: callback invoked\n", __func__);
> +
> +	if (mpi3mr_get_shost_and_mrioc(pdev, &shost, &mrioc)) {
> +		dev_err(&pdev->dev, "device not available\n");
> +		return PCI_ERS_RESULT_DISCONNECT;
> +	}
> +
> +	while (mrioc->reset_in_progress)
> +		ssleep(1);

Another potential hang?

> +	mrioc->pdev = pdev;
> +	pci_restore_state(pdev);
> +
> +	if (mpi3mr_setup_resources(mrioc)) {
> +		ioc_err(mrioc, "setup resources failed\n");
> +		goto out_failed;
> +	}
> +	mrioc->unrecoverable = 0;
> +	mrioc->pcie_err_recovery = false;
> +
> +	if (mpi3mr_soft_reset_handler(mrioc, MPI3MR_RESET_FROM_FIRMWARE, 0))
> +		goto out_failed;
> +
> +	return PCI_ERS_RESULT_RECOVERED;
> +
> +out_failed:
> +	mrioc->unrecoverable = 1;
> +	mrioc->block_on_pcie_err = false;
> +	scsi_unblock_requests(shost);
> +	mpi3mr_start_watchdog(mrioc);

I'm not a SCSI person, but it seems odd to unblock requests and start
the watchdog here.  Isn't the device just dead at this point?

> +	return PCI_ERS_RESULT_DISCONNECT;
> +}
> +
> +/**
> + * mpi3mr_pcierr_resume - PCI error recovery resume
> + * callback
> + * @pdev: PCI device instance
> + *
> + * This function enables all I/O and IOCTLs post reset issued as
> + * part of the PCI advacned error reporting and handling

s/advacned/advanced/ (actually, I'd just omit "advanced", since this
covers more than just AER in the powerpc case).

> + * Return: Nothing.
> + */
> +static void mpi3mr_pcierr_resume(struct pci_dev *pdev)
> +{
> +	struct Scsi_Host *shost;
> +	struct mpi3mr_ioc *mrioc;
> +
> +	dev_info(&pdev->dev, "%s: callback invoked\n", __func__);
> +
> +	if (mpi3mr_get_shost_and_mrioc(pdev, &shost, &mrioc)) {
> +		dev_err(&pdev->dev, "device not available\n");
> +		return;
> +	}
> +
> +	pci_aer_clear_nonfatal_status(pdev);
> +
> +	if (mrioc->block_on_pcie_err) {
> +		mrioc->block_on_pcie_err = false;
> +		scsi_unblock_requests(shost);
> +		mpi3mr_start_watchdog(mrioc);
> +	}
> +
> +}
> +
> +/**
> + * mpi3mr_pcierr_mmio_enabled - PCI error recovery callback
> + * @pdev: PCI device instance
> + *
> + * This is called only if _pcierr_error_detected returns
> + * PCI_ERS_RESULT_CAN_RECOVER.

s/_pcierr_error_detected/mpi3mr_pcierr_detected()/ ?  (Or possible
different name as suggested below)

> + * Return: PCI_ERS_RESULT_DISCONNECT when the controller is
> + * unrecoverable or when the shost/mnrioc reference cannot be
> + * found, else return PCI_ERS_RESULT_RECOVERED

s/mnrioc/mrioc/

> +static pci_ers_result_t mpi3mr_pcierr_mmio_enabled(struct pci_dev *pdev)
> +{
> +
> +	struct Scsi_Host *shost;
> +	struct mpi3mr_ioc *mrioc;
> +/*
> + *
> + */

Spurious comment?

> +	dev_info(&pdev->dev, "%s: callback invoked\n", __func__);
> +
> +	if (mpi3mr_get_shost_and_mrioc(pdev, &shost, &mrioc)) {
> +		dev_err(&pdev->dev, "device not available\n");
> +		return PCI_ERS_RESULT_DISCONNECT;
> +	}
> +	if (mrioc->unrecoverable)
> +		return PCI_ERS_RESULT_DISCONNECT;
> +
> +	return PCI_ERS_RESULT_RECOVERED;
> +}
> +
>  static const struct pci_device_id mpi3mr_pci_id_table[] = {
>  	{
>  		PCI_DEVICE_SUB(MPI3_MFGPAGE_VENDORID_BROADCOM,
> @@ -5489,6 +5678,13 @@ static const struct pci_device_id mpi3mr_pci_id_table[] = {
>  };
>  MODULE_DEVICE_TABLE(pci, mpi3mr_pci_id_table);
>  
> +static struct pci_error_handlers mpi3mr_err_handler = {
> +	.error_detected = mpi3mr_pcierr_detected,
> +	.mmio_enabled = mpi3mr_pcierr_mmio_enabled,
> +	.slot_reset = mpi3mr_pcierr_slot_reset_done,

It would be helpful if you used "mpi3mr_pcierr_slot_reset()" to match
the function pointer name.  This would make it much easier to compare
.slot_reset() implementations across drivers.

I agree that "slot_reset_done()" is more descriptive and would
probably have been a better name for the function pointer, but that
ship has sailed.

I'd suggest "mpi3mr_pcierr_error_detected()" for the same reason.  Or
maybe remove "pcierr_" from all of them if it feels too redundant.

> +	.resume = mpi3mr_pcierr_resume,
> +};
> +
>  static SIMPLE_DEV_PM_OPS(mpi3mr_pm_ops, mpi3mr_suspend, mpi3mr_resume);
>  
>  static struct pci_driver mpi3mr_pci_driver = {
> @@ -5497,6 +5693,7 @@ static struct pci_driver mpi3mr_pci_driver = {
>  	.probe = mpi3mr_probe,
>  	.remove = mpi3mr_remove,
>  	.shutdown = mpi3mr_shutdown,
> +	.err_handler = &mpi3mr_err_handler,
>  	.driver.pm = &mpi3mr_pm_ops,
>  };
>  
> -- 
> 2.31.1
> 


