Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF9EEC433E6
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 07:19:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 901D564E41
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 07:19:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbhCAHTY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 02:19:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:59122 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232421AbhCAHTX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 1 Mar 2021 02:19:23 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D2043AAC5;
        Mon,  1 Mar 2021 07:18:40 +0000 (UTC)
Subject: Re: [PATCH 21/24] mpi3mr: add support of PM suspend and resume
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, sathya.prakash@broadcom.com
References: <20201222101156.98308-1-kashyap.desai@broadcom.com>
 <20201222101156.98308-22-kashyap.desai@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <35b98859-ba79-3fda-c8bc-4c820ae2f653@suse.de>
Date:   Mon, 1 Mar 2021 08:18:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20201222101156.98308-22-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/22/20 11:11 AM, Kashyap Desai wrote:
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: sathya.prakash@broadcom.com
> ---
>   drivers/scsi/mpi3mr/mpi3mr_os.c | 85 +++++++++++++++++++++++++++++++++
>   1 file changed, 85 insertions(+)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index 1708aca1a5cd..ac47eed74705 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -3480,6 +3480,87 @@ static void mpi3mr_shutdown(struct pci_dev *pdev)
>   
>   }
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
> +
> +	mrioc = shost_priv(shost);
> +	while (mrioc->reset_in_progress || mrioc->is_driver_loading)
> +		ssleep(1);
> +	mrioc->stop_drv_processing = 1;
> +	mpi3mr_cleanup_fwevt_list(mrioc);
> +	scsi_block_requests(shost);
> +	mpi3mr_stop_watchdog(mrioc);
> +	mpi3mr_cleanup_ioc(mrioc, 1);
> +
> +	device_state = pci_choose_state(pdev, state);
> +	ioc_info(mrioc, "pdev=0x%p, slot=%s, entering operating state [D%d]\n",
> +	    pdev, pci_name(pdev), device_state);
> +	pci_save_state(pdev);
> +	pci_set_power_state(pdev, device_state);
> +	mpi3mr_cleanup_resources(mrioc);
> +
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
> +		ioc_info(mrioc, "%s: Setup resoruces failed[%d]\n",
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
> +
>   static const struct pci_device_id mpi3mr_pci_id_table[] = {
>   	{
>   		PCI_DEVICE_SUB(PCI_VENDOR_ID_LSI_LOGIC, 0x00A5,
> @@ -3495,6 +3576,10 @@ static struct pci_driver mpi3mr_pci_driver = {
>   	.probe = mpi3mr_probe,
>   	.remove = mpi3mr_remove,
>   	.shutdown = mpi3mr_shutdown,
> +#ifdef CONFIG_PM
> +	.suspend = mpi3mr_suspend,
> +	.resume = mpi3mr_resume,
> +#endif
>   };
>   
>   static int __init mpi3mr_init(void)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
