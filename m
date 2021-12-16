Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14518C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Dec 2021 23:30:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236941AbhLPXaL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Dec 2021 18:30:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235555AbhLPXaJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Dec 2021 18:30:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA52FC061574
        for <linux-scsi@vger.kernel.org>; Thu, 16 Dec 2021 15:30:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4154361F95
        for <linux-scsi@vger.kernel.org>; Thu, 16 Dec 2021 23:30:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD83C36AE2;
        Thu, 16 Dec 2021 23:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639697407;
        bh=NuA3cAAK2dcxfHxbQ2yR+gNvIsfrDVg3qrtU8XtrzxM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=HJbX5nl7r8oy17HHaelH+cnO6fSNQK7kZu8pCDyrlNzKLWp5dQf/z7POtqKgDLt6p
         p2r/u9ic+MwZw8+tk2iGqr9HlfK7ihQnAOj88bWIIyJo1Gn0Y1HbNwGklNMjiN1r6O
         5NA/sUdylKVuLxpzrfOJ4YKwRHLROMdv/MFiVFzfRi+TBA2MAUJtroQF44CpJF3an+
         +yF1+S3H+LaWbAoyZXi5kN25sxvhAljwLfMgcztOlS9v9lLMmp+ItwI4E+FTC/ME0n
         E5WGQYhyBfX9hI0TbZfKCPGbXU0DYdYZ4iUti8+ZRJwzwceBs8izDffHejb4kAKlxt
         fmrYx5r67Ca5Q==
Date:   Thu, 16 Dec 2021 17:30:06 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, steve.hagan@broadcom.com,
        peter.rivera@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        sathya.prakash@broadcom.com,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>
Subject: Re: [PATCH v6 21/24] mpi3mr: add support of PM suspend and resume
Message-ID: <20211216233006.GA801149@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520152545.2710479-22-kashyap.desai@broadcom.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

[+cc Vaibhav since my main question is about converting to generic PM]

On Thu, May 20, 2021 at 08:55:42PM +0530, Kashyap Desai wrote:
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> 
> Cc: sathya.prakash@broadcom.com
> ---
>  drivers/scsi/mpi3mr/mpi3mr_os.c | 84 +++++++++++++++++++++++++++++++++
>  1 file changed, 84 insertions(+)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index e63db7c..dd71cdc 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -3389,6 +3389,86 @@ static void mpi3mr_shutdown(struct pci_dev *pdev)
>  	mpi3mr_cleanup_ioc(mrioc, 0);
>  }
>  
> +#ifdef CONFIG_PM
> +/**
> + * mpi3mr_suspend - PCI power management suspend callback
> + * @pdev: PCI device instance
> + * @state: New power state
> + *
> + * Change the power state to the given value and cleanup the IOC
> + * by issuing MUR and shutdown notification
> + *
> + * Return: 0 always.
> + */
> +static int mpi3mr_suspend(struct pci_dev *pdev, pm_message_t state)
> +{
> +	struct Scsi_Host *shost = pci_get_drvdata(pdev);
> +	struct mpi3mr_ioc *mrioc;
> +	pci_power_t device_state;
> +
> +	if (!shost)
> +		return 0;

This test of "shost" is unnecessary.  If you set the drvdata before
the .probe() method returns success, you will always get valid drvdata
here.  And you do:

  mpi3mr_probe
    mpi3mr_init_ioc
      mpi3mr_setup_resources
        pci_set_drvdata(pdev, mrioc->shost)

Sure, it's *possible* that a random memory corruption will clear out
the drvdata pointer, but there's no point in testing for that.

> +	mrioc = shost_priv(shost);
> +	while (mrioc->reset_in_progress || mrioc->is_driver_loading)
> +		ssleep(1);
> +	mrioc->stop_drv_processing = 1;
> +	mpi3mr_cleanup_fwevt_list(mrioc);
> +	scsi_block_requests(shost);
> +	mpi3mr_stop_watchdog(mrioc);
> +	mpi3mr_cleanup_ioc(mrioc, 1);

This looks possibly wrong.  mpi3mr_cleanup_ioc() takes a "reason",
which looks like it should be MPI3MR_COMPLETE_CLEANUP (0),
MPI3MR_REINIT_FAILURE (1), or MPI3MR_SUSPEND (2).

This should at least use the enum, and it looks like it should use
MPI3MR_SUSPEND instead of passing the MPI3MR_REINIT_FAILURE value.

> +	device_state = pci_choose_state(pdev, state);
> +	ioc_info(mrioc, "pdev=0x%p, slot=%s, entering operating state [D%d]\n",
> +	    pdev, pci_name(pdev), device_state);
> +	pci_save_state(pdev);
> +	pci_set_power_state(pdev, device_state);
> +	mpi3mr_cleanup_resources(mrioc);

Why is mpi3mr_cleanup_resources() needed here?  It frees IRQs,
iounmaps registers, calls pci_release_selected_regions(), etc.

Very few other drivers do this, and I don't think it's necessary for
suspend.  And if you don't clean it up here, you won't need to
re-initialize it during resume.

I'm asking because I want to convert this from the legacy PCI power
management model to the generic PM model.  The generic model works
like this:

  suspend_devices_and_enter
    dpm_suspend_start(PMSG_SUSPEND)
      pci_pm_suspend                    # PCI bus .suspend() method
        mpi3mr_suspend                  <-- device-specific stuff
    suspend_enter
      dpm_suspend_noirq(PMSG_SUSPEND)
        pci_pm_suspend_noirq            # PCI bus .suspend_noirq() method
          pci_save_state                <-- generic PCI
          pci_prepare_to_sleep          <-- generic PCI
            pci_set_power_state
    ...
    dpm_resume_end(PMSG_RESUME)
      pci_pm_resume                     # PCI bus .resume() method
        pci_restore_standard_config
          pci_set_power_state(PCI_D0)   <-- generic PCI
          pci_restore_state             <-- generic PCI
        mpi3mr_resume                   # dev->driver->pm->resume

Notice that in the generic model the PCI core takes care of
pci_save_state(), pci_set_power_state(), etc., and the device-specific
stuff is done before the generic PCI suspend, and after the generic
PCI resume.

mpi3mr_cleanup_resources() is problematic because the device-specific
stuff should be done *before* the generic PCI part, but you call it
*after* the generic PCI part.  I think it would be *possible* to do it
after by making a mpi3mr_suspend_noirq() method, but there are hardly
any drivers that do that, and I think mpi3mr_cleanup_resources() is
unnecessary here anyway.

> +	return 0;
> +}
> +
> +/**
> + * mpi3mr_resume - PCI power management resume callback
> + * @pdev: PCI device instance
> + *
> + * Restore the power state to D0 and reinitialize the controller
> + * and resume I/O operations to the target devices
> + *
> + * Return: 0 on success, non-zero on failure
> + */
> +static int mpi3mr_resume(struct pci_dev *pdev)
> +{
> +	struct Scsi_Host *shost = pci_get_drvdata(pdev);
> +	struct mpi3mr_ioc *mrioc;
> +	pci_power_t device_state = pdev->current_state;
> +	int r;
> +
> +	mrioc = shost_priv(shost);
> +
> +	ioc_info(mrioc, "pdev=0x%p, slot=%s, previous operating state [D%d]\n",
> +	    pdev, pci_name(pdev), device_state);
> +	pci_set_power_state(pdev, PCI_D0);
> +	pci_enable_wake(pdev, PCI_D0, 0);
> +	pci_restore_state(pdev);
> +	mrioc->pdev = pdev;
> +	mrioc->cpu_count = num_online_cpus();
> +	r = mpi3mr_setup_resources(mrioc);
> +	if (r) {
> +		ioc_info(mrioc, "%s: Setup resources failed[%d]\n",
> +		    __func__, r);
> +		return r;
> +	}
> +
> +	mrioc->stop_drv_processing = 0;
> +	mpi3mr_init_ioc(mrioc, 1);
> +	scsi_unblock_requests(shost);
> +	mpi3mr_start_watchdog(mrioc);
> +
> +	return 0;
> +}
> +#endif
> +
>  static const struct pci_device_id mpi3mr_pci_id_table[] = {
>  	{
>  		PCI_DEVICE_SUB(PCI_VENDOR_ID_LSI_LOGIC, 0x00A5,
> @@ -3404,6 +3484,10 @@ static struct pci_driver mpi3mr_pci_driver = {
>  	.probe = mpi3mr_probe,
>  	.remove = mpi3mr_remove,
>  	.shutdown = mpi3mr_shutdown,
> +#ifdef CONFIG_PM
> +	.suspend = mpi3mr_suspend,
> +	.resume = mpi3mr_resume,
> +#endif
>  };
>  
>  static int __init mpi3mr_init(void)
> -- 
> 2.18.1
> 


