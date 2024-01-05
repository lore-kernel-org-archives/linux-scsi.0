Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9D4440E
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jan 2024 03:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oIQl8GfF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9901C433C8;
	Fri,  5 Jan 2024 03:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704424807;
	bh=Br7czjksqCRiDTa+SaRpP+WJlC2sOQ7TdtHyLC+h0Cw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=oIQl8GfFTVxyelPva8M+kZ7wIiakTNDVPeV+zzWLyIHcXZbyHYJWp11x7J3Iiso4p
	 LR2JD9++m7mqYNM/sy/sMmGli+MQ0LqpxacxgwGiHv4KuKWSsOrNWqot9/g/KBQpNo
	 E5pnp1uQ0ZJYjhL/jxrOuAJ0Tpfz59qY+72YVOk7/U/qypohk3TOhU6Zv3UYow7+hV
	 yu+tv6/adCT/G0aZliJ8CxFFkMMj3OQAcy6XHtD45TitLm1SqBJACehjviNgg5nyLj
	 wJHZfNtOD38dvgj6yO9PS/UuXvXzEQ5lE0yiSYrfu9bMW03/mZvZOfo48H5IkRrBKN
	 vSD0H2D3s8c0w==
Date: Thu, 4 Jan 2024 21:20:04 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
	rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com
Subject: Re: [PATCH v2 3/6] mpi3mr: Prevent PCI writes from driver during PCI
 error recovery
Message-ID: <20240105032004.GA1833246@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214205900.270488-4-ranjan.kumar@broadcom.com>

On Fri, Dec 15, 2023 at 02:28:57AM +0530, Ranjan Kumar wrote:
> Prevent interacting with the hardware while
> the error recovery in progress.
> 
> Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
> ---
>  drivers/scsi/mpi3mr/mpi3mr.h           | 26 ++++++++++
>  drivers/scsi/mpi3mr/mpi3mr_app.c       | 64 +++++++++++++----------
>  drivers/scsi/mpi3mr/mpi3mr_fw.c        | 28 +++++++---
>  drivers/scsi/mpi3mr/mpi3mr_os.c        | 71 +++++++++++++++-----------
>  drivers/scsi/mpi3mr/mpi3mr_transport.c | 39 ++++++++++++--
>  5 files changed, 158 insertions(+), 70 deletions(-)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index 25e6e3a09468..1ac7f88dc1cd 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -481,6 +481,7 @@ struct mpi3mr_throttle_group_info {
>  
>  /* HBA port flags */
>  #define MPI3MR_HBA_PORT_FLAG_DIRTY	0x01
> +#define MPI3MR_HBA_PORT_FLAG_NEW       0x02
>  
>  /* IOCTL data transfer sge*/
>  #define MPI3MR_NUM_IOCTL_SGE		256
> @@ -900,6 +901,29 @@ struct scmd_priv {
>  	u8 mpi3mr_scsiio_req[MPI3MR_ADMIN_REQ_FRAME_SZ];
>  };
>  
> +/**
> + * struct mpi3mr_pdevinfo - PCI device information
> + *
> + * @dev_id: PCI device ID of the adapter
> + * @dev_hw_rev: PCI revision of the adapter
> + * @subsys_dev_id: PCI subsystem device ID of the adapter
> + * @subsys_ven_id: PCI subsystem vendor ID of the adapter
> + * @dev: PCI device
> + * @func: PCI function
> + * @bus: PCI bus
> + * @seg_id: PCI segment ID

These names don't match the actual structure members, so I bet
scripts/kernel-doc is going to complain about them.

> + */
> +struct mpi3mr_pdevinfo {
> +	u16 id;
> +	u16 ssid;
> +	u16 ssvid;
> +	u16 segment;
> +	u8 dev:5;
> +	u8 func:3;
> +	u8 bus;
> +	u8 revision;
> +};
> +
>  /**
>   * struct mpi3mr_ioc - Adapter anchor structure stored in shost
>   * private data
> @@ -1058,6 +1082,7 @@ struct scmd_priv {
>   * @ioctl_sges_allocated: Flag for IOCTL SGEs allocated or not
>   * @pcie_err_recovery: PCIe error recovery in progress
>   * @block_on_pcie_err: Block IO during PCI error recovery
> + * @pdevinfo: PCI device information
>   */
>  struct mpi3mr_ioc {
>  	struct list_head list;
> @@ -1251,6 +1276,7 @@ struct mpi3mr_ioc {
>  	bool ioctl_sges_allocated;
>  	bool pcie_err_recovery;
>  	bool block_on_pcie_err;
> +	struct mpi3mr_pdevinfo pdevinfo;

I don't understand the reason to add "pdevinfo".  mpi3mr_probe() fills
pdevinfo from mrioc->pdev.  mpi3mr_bsg_populate_adpinfo() previously
filled adpinfo from mrioc->pdev, and now fills it from pdevinfo
instead.

It seems like the same data.  Is this related to the fact that
mpi3mr_pcierr_detected() set mrioc->pdev to NULL?  If so, this patch
would have to come first, otherwise if we bisect at the point between
patch [2/6] and this [3/6], there's a potential NULL pointer
dereference.  Bisection should work correctly at every commit.

I don't think setting mrioc->pdev to NULL is a good idea, so hopefully
pdevinfo can just go away.

>  };
>  
>  /**
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
> index 4b93b7440da6..a11d6f026f0e 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> @@ -31,7 +31,7 @@ static int mpi3mr_bsg_pel_abort(struct mpi3mr_ioc *mrioc)
>  		dprint_bsg_err(mrioc, "%s: reset in progress\n", __func__);
>  		return -1;
>  	}
> -	if (mrioc->stop_bsgs) {
> +	if (mrioc->stop_bsgs || mrioc->block_on_pcie_err) {
>  		dprint_bsg_err(mrioc, "%s: bsgs are blocked\n", __func__);
>  		return -1;
>  	}
> @@ -424,6 +424,9 @@ static long mpi3mr_bsg_adp_reset(struct mpi3mr_ioc *mrioc,
>  		goto out;
>  	}
>  
> +	if (mrioc->unrecoverable || mrioc->block_on_pcie_err)
> +		return -EINVAL;
> +
>  	sg_copy_to_buffer(job->request_payload.sg_list,
>  			  job->request_payload.sg_cnt,
>  			  &adpreset, sizeof(adpreset));
> @@ -470,25 +473,29 @@ static long mpi3mr_bsg_populate_adpinfo(struct mpi3mr_ioc *mrioc,
>  
>  	memset(&adpinfo, 0, sizeof(adpinfo));
>  	adpinfo.adp_type = MPI3MR_BSG_ADPTYPE_AVGFAMILY;
> -	adpinfo.pci_dev_id = mrioc->pdev->device;
> -	adpinfo.pci_dev_hw_rev = mrioc->pdev->revision;
> -	adpinfo.pci_subsys_dev_id = mrioc->pdev->subsystem_device;
> -	adpinfo.pci_subsys_ven_id = mrioc->pdev->subsystem_vendor;
> -	adpinfo.pci_bus = mrioc->pdev->bus->number;
> -	adpinfo.pci_dev = PCI_SLOT(mrioc->pdev->devfn);
> -	adpinfo.pci_func = PCI_FUNC(mrioc->pdev->devfn);
> -	adpinfo.pci_seg_id = pci_domain_nr(mrioc->pdev->bus);
>  	adpinfo.app_intfc_ver = MPI3MR_IOCTL_VERSION;
>  
> -	ioc_state = mpi3mr_get_iocstate(mrioc);
> -	if (ioc_state == MRIOC_STATE_UNRECOVERABLE)
> -		adpinfo.adp_state = MPI3MR_BSG_ADPSTATE_UNRECOVERABLE;
> -	else if ((mrioc->reset_in_progress) || (mrioc->stop_bsgs))
> +	if (mrioc->reset_in_progress || mrioc->stop_bsgs ||
> +	    mrioc->block_on_pcie_err)
>  		adpinfo.adp_state = MPI3MR_BSG_ADPSTATE_IN_RESET;
> -	else if (ioc_state == MRIOC_STATE_FAULT)
> -		adpinfo.adp_state = MPI3MR_BSG_ADPSTATE_FAULT;
> -	else
> -		adpinfo.adp_state = MPI3MR_BSG_ADPSTATE_OPERATIONAL;
> +	else {
> +		ioc_state = mpi3mr_get_iocstate(mrioc);
> +		if (ioc_state == MRIOC_STATE_UNRECOVERABLE)
> +			adpinfo.adp_state = MPI3MR_BSG_ADPSTATE_UNRECOVERABLE;
> +		else if (ioc_state == MRIOC_STATE_FAULT)
> +			adpinfo.adp_state = MPI3MR_BSG_ADPSTATE_FAULT;
> +		else
> +			adpinfo.adp_state = MPI3MR_BSG_ADPSTATE_OPERATIONAL;
> +	}
> +
> +	adpinfo.pci_dev_id = mrioc->pdevinfo.id;
> +	adpinfo.pci_dev_hw_rev = mrioc->pdevinfo.revision;
> +	adpinfo.pci_subsys_dev_id = mrioc->pdevinfo.ssid;
> +	adpinfo.pci_subsys_ven_id = mrioc->pdevinfo.ssvid;
> +	adpinfo.pci_bus = mrioc->pdevinfo.bus;
> +	adpinfo.pci_dev = mrioc->pdevinfo.dev;
> +	adpinfo.pci_func = mrioc->pdevinfo.func;
> +	adpinfo.pci_seg_id = mrioc->pdevinfo.segment;

I don't know if it's possible, but if the adpinfo changes could be
moved to their own patch (or even removed altogether), this patch
would be more about what the commit log advertises: preventing
interaction with the hardware during error recovery.

>  	memcpy((u8 *)&adpinfo.driver_info, (u8 *)&mrioc->driver_info,
>  	    sizeof(adpinfo.driver_info));
> @@ -1495,7 +1502,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
>  		mutex_unlock(&mrioc->bsg_cmds.mutex);
>  		goto out;
>  	}
> -	if (mrioc->stop_bsgs) {
> +	if (mrioc->stop_bsgs || mrioc->block_on_pcie_err) {
>  		dprint_bsg_err(mrioc, "%s: bsgs are blocked\n", __func__);
>  		rval = -EAGAIN;
>  		mutex_unlock(&mrioc->bsg_cmds.mutex);
> @@ -2020,17 +2027,20 @@ adp_state_show(struct device *dev, struct device_attribute *attr,
>  	enum mpi3mr_iocstate ioc_state;
>  	uint8_t adp_state;
>  
> -	ioc_state = mpi3mr_get_iocstate(mrioc);
> -	if (ioc_state == MRIOC_STATE_UNRECOVERABLE)
> -		adp_state = MPI3MR_BSG_ADPSTATE_UNRECOVERABLE;
> -	else if ((mrioc->reset_in_progress) || (mrioc->stop_bsgs))
> +	if (mrioc->reset_in_progress || mrioc->stop_bsgs ||
> +		 mrioc->block_on_pcie_err)
>  		adp_state = MPI3MR_BSG_ADPSTATE_IN_RESET;
> -	else if (ioc_state == MRIOC_STATE_FAULT)
> -		adp_state = MPI3MR_BSG_ADPSTATE_FAULT;
> -	else
> -		adp_state = MPI3MR_BSG_ADPSTATE_OPERATIONAL;
> +	else {
> +		ioc_state = mpi3mr_get_iocstate(mrioc);
> +		if (ioc_state == MRIOC_STATE_UNRECOVERABLE)
> +			adp_state = MPI3MR_BSG_ADPSTATE_UNRECOVERABLE;
> +		else if (ioc_state == MRIOC_STATE_FAULT)
> +			adp_state = MPI3MR_BSG_ADPSTATE_FAULT;
> +		else
> +			adp_state = MPI3MR_BSG_ADPSTATE_OPERATIONAL;
> +	}
>  
> -	return sysfs_emit(buf, "%u\n", adp_state);
> +	return snprintf(buf, PAGE_SIZE, "%u\n", adp_state);
>  }
>  
>  static DEVICE_ATTR_RO(adp_state);
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> index d8c57a0a518f..c50fc27231cd 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -595,7 +595,7 @@ int mpi3mr_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num)
>  	mrioc = (struct mpi3mr_ioc *)shost->hostdata;
>  
>  	if ((mrioc->reset_in_progress || mrioc->prepare_for_reset ||
> -	    mrioc->unrecoverable))
> +	    mrioc->unrecoverable || mrioc->pcie_err_recovery))
>  		return 0;
>  
>  	num_entries = mpi3mr_process_op_reply_q(mrioc,
> @@ -1037,13 +1037,13 @@ enum mpi3mr_iocstate mpi3mr_get_iocstate(struct mpi3mr_ioc *mrioc)
>  	u32 ioc_status, ioc_config;
>  	u8 ready, enabled;
>  
> -	ioc_status = readl(&mrioc->sysif_regs->ioc_status);
> -	ioc_config = readl(&mrioc->sysif_regs->ioc_configuration);
> -
>  	if (mrioc->unrecoverable)
>  		return MRIOC_STATE_UNRECOVERABLE;
> +	ioc_status = readl(&mrioc->sysif_regs->ioc_status);
> +
>  	if (ioc_status & MPI3_SYSIF_IOC_STATUS_FAULT)
>  		return MRIOC_STATE_FAULT;
> +	ioc_config = readl(&mrioc->sysif_regs->ioc_configuration);

These reads look suspect because you cannot rely on
mrioc->unrecoverable to catch all cases where the device is
inaccessible.  For example, the device may be unplugged here:

  # device is operating normally

  if (mrioc->unrecoverable)
    return MRIOC_STATE_UNRECOVERABLE;

  # device is hot-unplugged here

  readl(&mrioc->sysif_regs->ioc_status);

  # this readl() returns ~0 because the MMIO access failed on PCI

>  	ready = (ioc_status & MPI3_SYSIF_IOC_STATUS_READY);
>  	enabled = (ioc_config & MPI3_SYSIF_IOC_CONFIG_ENABLE_IOC);
> @@ -1667,6 +1667,12 @@ int mpi3mr_admin_request_post(struct mpi3mr_ioc *mrioc, void *admin_req,
>  		retval = -EAGAIN;
>  		goto out;
>  	}
> +	if (mrioc->pcie_err_recovery) {
> +		ioc_err(mrioc, "admin request queue submission failed due to pcie error recovery in progress\n");
> +		retval = -EAGAIN;
> +		goto out;
> +	}
> +
>  	areq_entry = (u8 *)mrioc->admin_req_base +
>  	    (areq_pi * MPI3MR_ADMIN_REQ_FRAME_SZ);
>  	memset(areq_entry, 0, MPI3MR_ADMIN_REQ_FRAME_SZ);
> @@ -2337,6 +2343,11 @@ int mpi3mr_op_request_post(struct mpi3mr_ioc *mrioc,
>  		retval = -EAGAIN;
>  		goto out;
>  	}
> +	if (mrioc->pcie_err_recovery) {
> +		ioc_err(mrioc, "operational request queue submission failed due to pcie error recovery in progress\n");
> +		retval = -EAGAIN;
> +		goto out;
> +	}
>  
>  	segment_base_addr = segments[pi / op_req_q->segment_qd].segment;
>  	req_entry = (u8 *)segment_base_addr +
> @@ -2585,7 +2596,7 @@ static void mpi3mr_watchdog_work(struct work_struct *work)
>  	u32 fault, host_diagnostic, ioc_status;
>  	u32 reset_reason = MPI3MR_RESET_FROM_FAULT_WATCH;
>  
> -	if (mrioc->reset_in_progress)
> +	if (mrioc->reset_in_progress || mrioc->pcie_err_recovery)
>  		return;
>  
>  	if (!mrioc->unrecoverable && !pci_device_is_present(mrioc->pdev)) {
> @@ -4111,7 +4122,7 @@ int mpi3mr_reinit_ioc(struct mpi3mr_ioc *mrioc, u8 is_resume)
>  		goto out_failed_noretry;
>  	}
>  
> -	if (is_resume) {
> +	if (is_resume || mrioc->block_on_pcie_err) {
>  		dprint_reset(mrioc, "setting up single ISR\n");
>  		retval = mpi3mr_setup_isr(mrioc, 1);
>  		if (retval) {
> @@ -4151,7 +4162,7 @@ int mpi3mr_reinit_ioc(struct mpi3mr_ioc *mrioc, u8 is_resume)
>  		goto out_failed;
>  	}
>  
> -	if (is_resume) {
> +	if (is_resume || mrioc->block_on_pcie_err) {
>  		dprint_reset(mrioc, "setting up multiple ISR\n");
>  		retval = mpi3mr_setup_isr(mrioc, 0);
>  		if (retval) {
> @@ -4625,7 +4636,8 @@ void mpi3mr_cleanup_ioc(struct mpi3mr_ioc *mrioc)
>  
>  	ioc_state = mpi3mr_get_iocstate(mrioc);
>  
> -	if ((!mrioc->unrecoverable) && (!mrioc->reset_in_progress) &&
> +	if (!mrioc->unrecoverable && !mrioc->reset_in_progress &&
> +	    !mrioc->pcie_err_recovery &&
>  	    (ioc_state == MRIOC_STATE_READY)) {
>  		if (mpi3mr_issue_and_process_mur(mrioc,
>  		    MPI3MR_RESET_FROM_CTLR_CLEANUP))
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index dea47ef53abb..d61fd105dfad 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -919,7 +919,7 @@ static int mpi3mr_report_tgtdev_to_host(struct mpi3mr_ioc *mrioc,
>  	int retval = 0;
>  	struct mpi3mr_tgt_dev *tgtdev;
>  
> -	if (mrioc->reset_in_progress)
> +	if (mrioc->reset_in_progress || mrioc->pcie_err_recovery)
>  		return -1;
>  
>  	tgtdev = mpi3mr_get_tgtdev_by_perst_id(mrioc, perst_id);
> @@ -2000,8 +2000,13 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
>  	}
>  	case MPI3_EVENT_WAIT_FOR_DEVICES_TO_REFRESH:
>  	{
> -		while (mrioc->device_refresh_on)
> +		while ((mrioc->device_refresh_on || mrioc->block_on_pcie_err) &&
> +		    !mrioc->unrecoverable && !mrioc->pcie_err_recovery) {
>  			msleep(500);
> +		}

Looks like a potential hang here.  I guess it was always a potential
hang; this just makes the conditional more complicated.  Usually you
want a timeout or other means of ensuring the loop exits.

> +
> +		if (mrioc->unrecoverable || mrioc->pcie_err_recovery)
> +			break;
>  
>  		dprint_event_bh(mrioc,
>  		    "scan for non responding and newly added devices after soft reset started\n");
> @@ -3680,6 +3685,13 @@ int mpi3mr_issue_tm(struct mpi3mr_ioc *mrioc, u8 tm_type,
>  		mutex_unlock(&drv_cmd->mutex);
>  		goto out;
>  	}
> +	if (mrioc->block_on_pcie_err) {
> +		retval = -1;
> +		dprint_tm(mrioc, "sending task management failed due to\n"
> +				"pcie error recovery in progress\n");
> +		mutex_unlock(&drv_cmd->mutex);
> +		goto out;
> +	}
>  
>  	drv_cmd->state = MPI3MR_CMD_PENDING;
>  	drv_cmd->is_waiting = 1;
> @@ -4073,12 +4085,19 @@ static int mpi3mr_eh_bus_reset(struct scsi_cmnd *scmd)
>  	if (dev_type == MPI3_DEVICE_DEVFORM_VD) {
>  		mpi3mr_wait_for_host_io(mrioc,
>  			MPI3MR_RAID_ERRREC_RESET_TIMEOUT);
> -		if (!mpi3mr_get_fw_pending_ios(mrioc))
> +		if (!mpi3mr_get_fw_pending_ios(mrioc)) {
> +			while (mrioc->reset_in_progress ||
> +			       mrioc->prepare_for_reset ||
> +			       mrioc->block_on_pcie_err)
> +				ssleep(1);

Another possible hang?

>  			retval = SUCCESS;
> +			goto out;
> +		}
>  	}
>  	if (retval == FAILED)
>  		mpi3mr_print_pending_host_io(mrioc);
>  
> +out:
>  	sdev_printk(KERN_INFO, scmd->device,
>  		"Bus reset is %s for scmd(%p)\n",
>  		((retval == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
> @@ -4779,7 +4798,8 @@ static int mpi3mr_qcmd(struct Scsi_Host *shost,
>  		goto out;
>  	}
>  
> -	if (mrioc->reset_in_progress) {
> +	if (mrioc->reset_in_progress || mrioc->prepare_for_reset
> +	    || mrioc->block_on_pcie_err) {
>  		retval = SCSI_MLQUEUE_HOST_BUSY;
>  		goto out;
>  	}
> @@ -5123,6 +5143,14 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	mrioc->logging_level = logging_level;
>  	mrioc->shost = shost;
>  	mrioc->pdev = pdev;
> +	mrioc->pdevinfo.id = pdev->device;
> +	mrioc->pdevinfo.revision = pdev->revision;
> +	mrioc->pdevinfo.ssid = pdev->subsystem_device;
> +	mrioc->pdevinfo.ssvid = pdev->subsystem_vendor;
> +	mrioc->pdevinfo.bus = pdev->bus->number;
> +	mrioc->pdevinfo.dev = PCI_SLOT(pdev->devfn);
> +	mrioc->pdevinfo.func = PCI_FUNC(pdev->devfn);
> +	mrioc->pdevinfo.segment = pci_domain_nr(pdev->bus);
>  	mrioc->stop_bsgs = 1;
>  
>  	mrioc->max_sgl_entries = max_sgl_entries;
> @@ -5276,17 +5304,21 @@ static void mpi3mr_remove(struct pci_dev *pdev)
>  	struct workqueue_struct	*wq;
>  	unsigned long flags;
>  	struct mpi3mr_tgt_dev *tgtdev, *tgtdev_next;
> -	struct mpi3mr_hba_port *port, *hba_port_next;
> -	struct mpi3mr_sas_node *sas_expander, *sas_expander_next;
>  
>  	if (mpi3mr_get_shost_and_mrioc(pdev, &shost, &mrioc))
>  		return;
>  
> -	mrioc = shost_priv(shost);
>  	while (mrioc->reset_in_progress || mrioc->is_driver_loading)
>  		ssleep(1);
>  
> -	if (!pci_device_is_present(mrioc->pdev)) {
> +	if (mrioc->block_on_pcie_err) {
> +		mrioc->block_on_pcie_err = false;
> +		scsi_unblock_requests(shost);
> +		mrioc->unrecoverable = 1;
> +	}
> +
> +	if (!pci_device_is_present(mrioc->pdev) ||
> +	    mrioc->pcie_err_recovery) {
>  		mrioc->unrecoverable = 1;
>  		mpi3mr_flush_cmds_for_unrecovered_controller(mrioc);
>  	}
> @@ -5316,29 +5348,6 @@ static void mpi3mr_remove(struct pci_dev *pdev)
>  	mpi3mr_cleanup_ioc(mrioc);
>  	mpi3mr_free_mem(mrioc);
>  	mpi3mr_cleanup_resources(mrioc);
> -
> -	spin_lock_irqsave(&mrioc->sas_node_lock, flags);
> -	list_for_each_entry_safe_reverse(sas_expander, sas_expander_next,
> -	    &mrioc->sas_expander_list, list) {
> -		spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
> -		mpi3mr_expander_node_remove(mrioc, sas_expander);
> -		spin_lock_irqsave(&mrioc->sas_node_lock, flags);
> -	}
> -	list_for_each_entry_safe(port, hba_port_next, &mrioc->hba_port_table_list, list) {
> -		ioc_info(mrioc,
> -		    "removing hba_port entry: %p port: %d from hba_port list\n",
> -		    port, port->port_id);
> -		list_del(&port->list);
> -		kfree(port);
> -	}
> -	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
> -
> -	if (mrioc->sas_hba.num_phys) {
> -		kfree(mrioc->sas_hba.phy);
> -		mrioc->sas_hba.phy = NULL;
> -		mrioc->sas_hba.num_phys = 0;
> -	}
> -
>  	spin_lock(&mrioc_list_lock);
>  	list_del(&mrioc->list);
>  	spin_unlock(&mrioc_list_lock);
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
> index c0c8ab586957..8c8368104a27 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
> @@ -149,6 +149,11 @@ static int mpi3mr_report_manufacture(struct mpi3mr_ioc *mrioc,
>  		return -EFAULT;
>  	}
>  
> +	if (mrioc->pcie_err_recovery) {
> +		ioc_err(mrioc, "%s: pcie error recovery in progress!\n", __func__);
> +		return -EFAULT;
> +	}
> +
>  	data_out_sz = sizeof(struct rep_manu_request);
>  	data_in_sz = sizeof(struct rep_manu_reply);
>  	data_out = dma_alloc_coherent(&mrioc->pdev->dev,
> @@ -792,6 +797,12 @@ static int mpi3mr_set_identify(struct mpi3mr_ioc *mrioc, u16 handle,
>  		return -EFAULT;
>  	}
>  
> +	if (mrioc->pcie_err_recovery) {
> +		ioc_err(mrioc, "%s: pcie error recovery in progress!\n",
> +		    __func__);
> +		return -EFAULT;
> +	}
> +
>  	if ((mpi3mr_cfg_get_dev_pg0(mrioc, &ioc_status, &device_pg0,
>  	    sizeof(device_pg0), MPI3_DEVICE_PGAD_FORM_HANDLE, handle))) {
>  		ioc_err(mrioc, "%s: device page0 read failed\n", __func__);
> @@ -1009,6 +1020,9 @@ mpi3mr_alloc_hba_port(struct mpi3mr_ioc *mrioc, u16 port_id)
>  	hba_port->port_id = port_id;
>  	ioc_info(mrioc, "hba_port entry: %p, port: %d is added to hba_port list\n",
>  	    hba_port, hba_port->port_id);
> +	if (mrioc->reset_in_progress ||
> +		mrioc->pcie_err_recovery)

  if (mrioc->reset_in_progress || mrioc->pcie_err_recovery)

would fit on one line and make this easier to read.

> +		hba_port->flags = MPI3MR_HBA_PORT_FLAG_NEW;
>  	list_add_tail(&hba_port->list, &mrioc->hba_port_table_list);
>  	return hba_port;
>  }
> @@ -1057,7 +1071,7 @@ void mpi3mr_update_links(struct mpi3mr_ioc *mrioc,
>  	struct mpi3mr_sas_node *mr_sas_node;
>  	struct mpi3mr_sas_phy *mr_sas_phy;
>  
> -	if (mrioc->reset_in_progress)
> +	if (mrioc->reset_in_progress || mrioc->pcie_err_recovery)
>  		return;
>  
>  	spin_lock_irqsave(&mrioc->sas_node_lock, flags);
> @@ -1965,7 +1979,7 @@ int mpi3mr_expander_add(struct mpi3mr_ioc *mrioc, u16 handle)
>  	if (!handle)
>  		return -1;
>  
> -	if (mrioc->reset_in_progress)
> +	if (mrioc->reset_in_progress || mrioc->pcie_err_recovery)
>  		return -1;
>  
>  	if ((mpi3mr_cfg_get_sas_exp_pg0(mrioc, &ioc_status, &expander_pg0,
> @@ -2171,7 +2185,7 @@ void mpi3mr_expander_node_remove(struct mpi3mr_ioc *mrioc,
>  	/* remove sibling ports attached to this expander */
>  	list_for_each_entry_safe(mr_sas_port, next,
>  	   &sas_expander->sas_port_list, port_list) {
> -		if (mrioc->reset_in_progress)
> +		if (mrioc->reset_in_progress || mrioc->pcie_err_recovery)
>  			return;
>  		if (mr_sas_port->remote_identify.device_type ==
>  		    SAS_END_DEVICE)
> @@ -2221,7 +2235,7 @@ void mpi3mr_expander_remove(struct mpi3mr_ioc *mrioc, u64 sas_address,
>  	struct mpi3mr_sas_node *sas_expander;
>  	unsigned long flags;
>  
> -	if (mrioc->reset_in_progress)
> +	if (mrioc->reset_in_progress || mrioc->pcie_err_recovery)
>  		return;
>  
>  	if (!hba_port)
> @@ -2532,6 +2546,11 @@ static int mpi3mr_get_expander_phy_error_log(struct mpi3mr_ioc *mrioc,
>  		return -EFAULT;
>  	}
>  
> +	if (mrioc->pcie_err_recovery) {
> +		ioc_err(mrioc, "%s: pcie error recovery in progress!\n", __func__);
> +		return -EFAULT;
> +	}
> +
>  	data_out_sz = sizeof(struct phy_error_log_request);
>  	data_in_sz = sizeof(struct phy_error_log_reply);
>  	sz = data_out_sz + data_in_sz;
> @@ -2791,6 +2810,12 @@ mpi3mr_expander_phy_control(struct mpi3mr_ioc *mrioc,
>  		return -EFAULT;
>  	}
>  
> +	if (mrioc->pcie_err_recovery) {
> +		ioc_err(mrioc, "%s: pcie error recovery in progress!\n",
> +		    __func__);
> +		return -EFAULT;
> +	}
> +
>  	data_out_sz = sizeof(struct phy_control_request);
>  	data_in_sz = sizeof(struct phy_control_reply);
>  	sz = data_out_sz + data_in_sz;
> @@ -3214,6 +3239,12 @@ mpi3mr_transport_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
>  		goto out;
>  	}
>  
> +	if (mrioc->pcie_err_recovery) {
> +		ioc_err(mrioc, "%s: pcie error recovery in progress!\n", __func__);
> +		rc = -EFAULT;
> +		goto out;
> +	}
> +
>  	rc = mpi3mr_map_smp_buffer(&mrioc->pdev->dev, &job->request_payload,
>  	    &dma_addr_out, &dma_len_out, &addr_out);
>  	if (rc)
> -- 
> 2.31.1
> 


