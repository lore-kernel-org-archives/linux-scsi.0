From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v1.3 3/18] arcmsr: Add code to support system hibernation
Date: Thu, 07 Aug 2014 15:17:35 +0200
Message-ID: <53E37C6F.6090201@redhat.com>
References: <1406882173.10378.42.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1406882173.10378.42.camel@Centos6.3-64>
Sender: linux-kernel-owner@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>, hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/01/2014 10:36 AM, Ching Huang wrote:
> This patch adds code to support system hibernation.
>
> Signed-off-by: Ching<ching2048@areca.com.tw>
> ---
>
> diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-08-01 11:03:00.000000000 +0800
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-08-01 11:04:28.000000000 +0800
> @@ -89,11 +89,15 @@ static int arcmsr_bios_param(struct scsi
>  static int arcmsr_queue_command(struct Scsi_Host *h, struct scsi_cmnd *cmd);
>  static int arcmsr_probe(struct pci_dev *pdev,
>  				const struct pci_device_id *id);
> +static int arcmsr_suspend(struct pci_dev *pdev, pm_message_t state);
> +static int arcmsr_resume(struct pci_dev *pdev);
>  static void arcmsr_remove(struct pci_dev *pdev);
>  static void arcmsr_shutdown(struct pci_dev *pdev);
>  static void arcmsr_iop_init(struct AdapterControlBlock *acb);
>  static void arcmsr_free_ccb_pool(struct AdapterControlBlock *acb);
>  static u32 arcmsr_disable_outbound_ints(struct AdapterControlBlock *acb);
> +static void arcmsr_enable_outbound_ints(struct AdapterControlBlock *acb,
> +	u32 intmask_org);
>  static void arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb);
>  static void arcmsr_flush_hba_cache(struct AdapterControlBlock *acb);
>  static void arcmsr_flush_hbb_cache(struct AdapterControlBlock *acb);
> @@ -167,6 +171,8 @@ static struct pci_driver arcmsr_pci_driv
>  	.id_table			= arcmsr_device_id_table,
>  	.probe			= arcmsr_probe,
>  	.remove			= arcmsr_remove,
> +	.suspend		= arcmsr_suspend,
> +	.resume			= arcmsr_resume,
>  	.shutdown		= arcmsr_shutdown,
>  };
>  /*
> @@ -776,6 +782,77 @@ static void arcmsr_free_irq(struct pci_d
>  		free_irq(pdev->irq, acb);
>  }
>  
> +static int arcmsr_suspend(struct pci_dev *pdev, pm_message_t state)
> +{
> +	uint32_t intmask_org;
> +	struct Scsi_Host *host = pci_get_drvdata(pdev);
> +	struct AdapterControlBlock *acb =
> +		(struct AdapterControlBlock *)host->hostdata;
> +
> +	intmask_org = arcmsr_disable_outbound_ints(acb);
> +	arcmsr_free_irq(pdev, acb);
> +	del_timer_sync(&acb->eternal_timer);
> +	flush_scheduled_work();
> +	arcmsr_stop_adapter_bgrb(acb);
> +	arcmsr_flush_adapter_cache(acb);
> +	arcmsr_enable_outbound_ints(acb, intmask_org);
> +	pci_set_drvdata(pdev, host);
> +	pci_save_state(pdev);
> +	pci_disable_device(pdev);
> +	pci_set_power_state(pdev, pci_choose_state(pdev, state));
> +	return 0;

its' probably better to disable interrupts on card (arcmsr_enable_outbound_ints) and after that
deregister the isr functions (arcmsr_free_irq)
 

> +}
> +
> +static int arcmsr_resume(struct pci_dev *pdev)
> +{
> +	int error;
> +	struct Scsi_Host *host = pci_get_drvdata(pdev);
> +	struct AdapterControlBlock *acb =
> +		(struct AdapterControlBlock *)host->hostdata;
> +
> +	pci_set_power_state(pdev, PCI_D0);
> +	pci_enable_wake(pdev, PCI_D0, 0);
> +	pci_restore_state(pdev);
> +	if (pci_enable_device(pdev)) {
> +		pr_warn("%s: pci_enable_device error\n", __func__);
> +		return -ENODEV;
> +	}

a significant part of this code is equal to what is done in arcmsr_probe
is it possible to do it in an special function in one place ? 

> +	error = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
> +	if (error) {
> +		error = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
> +		if (error) {
> +			pr_warn("scsi%d: No suitable DMA mask available\n",
> +			       host->host_no);
> +			goto controller_unregister;
> +		}
> +	}
> +	pci_set_master(pdev);
> +	if (arcmsr_request_irq(pdev, acb) == ARC_FAILURE)
> +		goto controller_stop;
> +	arcmsr_iop_init(acb);
> +	INIT_WORK(&acb->arcmsr_do_message_isr_bh, arcmsr_message_isr_bh_fn);
> +	atomic_set(&acb->rq_map_token, 16);
> +	atomic_set(&acb->ante_token_value, 16);
> +	acb->fw_flag = FW_NORMAL;
> +	init_timer(&acb->eternal_timer);
> +	acb->eternal_timer.expires = jiffies + msecs_to_jiffies(6 * HZ);
> +	acb->eternal_timer.data = (unsigned long) acb;
> +	acb->eternal_timer.function = &arcmsr_request_device_map;
> +	add_timer(&acb->eternal_timer);
> +	return 0;
> +controller_stop:
> +	arcmsr_stop_adapter_bgrb(acb);
> +	arcmsr_flush_adapter_cache(acb);
> +controller_unregister:
> +	scsi_remove_host(host);
> +	arcmsr_free_ccb_pool(acb);
> +	arcmsr_unmap_pciregion(acb);
> +	pci_release_regions(pdev);
> +	scsi_host_put(host);
> +	pci_disable_device(pdev);
> +	return -ENODEV;
> +}
> +
>  static uint8_t arcmsr_abort_hba_allcmd(struct AdapterControlBlock *acb)
>  {
>  	struct MessageUnit_A __iomem *reg = acb->pmuA;

If you will repost a new version of this patch, please merge the
"[PATCH v1.3 18/18] arcmsr: replace flush_scheduled_work() by flush_work()"
into this one, there is no reason for having it separated.

--tms

>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
