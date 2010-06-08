From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: RE: [PATCH] megaraid_sas: enable message-signaled interrupts
Date: Mon, 07 Jun 2010 17:28:34 -0700
Message-ID: <1275956914.6498.11.camel@haakon2.linux-iscsi.org>
References: <4C0CA170.70003@ladisch.de>
	 <4B6A08C587958942AA3002690DD4F8C3D0803AAB@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C3D0803AAB@cosmail02.lsi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: Clemens Ladisch <clemens@ladisch.de>, DL-MegaRAID Linux <megaraidlinux@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2010-06-07 at 15:37 -0600, Yang, Bo wrote:
> NACK.  The MSI will be turn on until driver fully support it.
> 
> 

Hi Bo,

Do you have an idea of when this will be supported in the upstream
megaraid_sas driver..?  I am asking because I would like to eventually
add MSI support into the QEMU-KVM Megaraid 8708EM2 HBA emulation that
Hannes has been working on.

Best,

--nab

> -----Original Message-----
> From: Clemens Ladisch [mailto:clemens@ladisch.de] 
> Sent: Monday, June 07, 2010 3:36 AM
> To: DL-MegaRAID Linux
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] megaraid_sas: enable message-signaled interrupts
> 
> To avoid sharing interrupts, enable message-signaled interrupts, if
> possible.
> 
> Tested with LSI 9260-8i/8e, where sharing the interrupt with the nvidia
> driver would reduce the RAID performance.
> 
> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
> Tested-by: Bert dd <bert.ddecker@gmail.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas.c |   17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> --- a/drivers/scsi/megaraid/megaraid_sas.c
> +++ b/drivers/scsi/megaraid/megaraid_sas.c
> @@ -3169,10 +3169,14 @@ megasas_probe_one(struct pci_dev *pdev,
>  	if (megasas_init_mfi(instance))
>  		goto fail_init_mfi;
>  
> +	pci_enable_msi(pdev);
> +
>  	/*
>  	 * Register IRQ
>  	 */
> -	if (request_irq(pdev->irq, megasas_isr, IRQF_SHARED, "megasas", instance)) {
> +	if (request_irq(pdev->irq, megasas_isr,
> +		pci_dev_msi_enabled(pdev) ? 0 : IRQF_SHARED,
> +		"megasas", instance)) {
>  		printk(KERN_DEBUG "megasas: Failed to register IRQ\n");
>  		goto fail_irq;
>  	}
> @@ -3222,6 +3226,8 @@ megasas_probe_one(struct pci_dev *pdev,
>  	megasas_release_mfi(instance);
>  
>        fail_irq:
> +	pci_disable_msi(pdev);
> +
>        fail_init_mfi:
>        fail_alloc_dma_buf:
>  	if (instance->evt_detail)
> @@ -3354,6 +3360,7 @@ megasas_suspend(struct pci_dev *pdev, pm
>  	pci_set_drvdata(instance->pdev, instance);
>  	instance->instancet->disable_intr(instance->reg_set);
>  	free_irq(instance->pdev->irq, instance);
> +	pci_disable_msi(pdev);
>  
>  	pci_save_state(pdev);
>  	pci_disable_device(pdev);
> @@ -3416,10 +3423,13 @@ megasas_resume(struct pci_dev *pdev)
>  	tasklet_init(&instance->isr_tasklet, megasas_complete_cmd_dpc,
>  			(unsigned long)instance);
>  
> +	pci_enable_msi(pdev);
> +
>  	/*
>  	 * Register IRQ
>  	 */
> -	if (request_irq(pdev->irq, megasas_isr, IRQF_SHARED,
> +	if (request_irq(pdev->irq, megasas_isr,
> +		pci_dev_msi_enabled(pdev) ? 0 : IRQF_SHARED,
>  		"megasas", instance)) {
>  		printk(KERN_ERR "megasas: Failed to register IRQ\n");
>  		goto fail_irq;
> @@ -3443,6 +3453,8 @@ megasas_resume(struct pci_dev *pdev)
>  	return 0;
>  
>  fail_irq:
> +	pci_disable_msi(pdev);
> +
>  fail_init_mfi:
>  	if (instance->evt_detail)
>  		pci_free_consistent(pdev, sizeof(struct megasas_evt_detail),
> @@ -3519,6 +3531,7 @@ static void __devexit megasas_detach_one
>  	instance->instancet->disable_intr(instance->reg_set);
>  
>  	free_irq(instance->pdev->irq, instance);
> +	pci_disable_msi(pdev);
>  
>  	megasas_release_mfi(instance);
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
