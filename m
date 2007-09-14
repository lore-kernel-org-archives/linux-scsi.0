From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/4] scsi: megaraid_sas -- add hibernation support
Date: Fri, 14 Sep 2007 09:42:42 -0500
Message-ID: <1189780962.3343.9.camel@localhost.localdomain>
References: <1189513284.6082.4.camel@dhcp-75-534.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:42370 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751594AbXINOmo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Sep 2007 10:42:44 -0400
In-Reply-To: <1189513284.6082.4.camel@dhcp-75-534.se.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-box <bo.yang@lsi.com>
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org, sumant.patro@lsi.com

On Tue, 2007-09-11 at 12:21 +0000, linux-box wrote:
> The megaraid_sas driver doesn't support the hibernation, the suspend/resume  
> routine implemented to support the hibernation.
> 
> Signed-off-by: Bo Yang <bo.yang@lsi.com> 

Just from a process point of view, your email from: is linux-box
<bo.yang@lsi.com>, but your signoff is Bo Yang <bo.yang@lsi.com>, I'm
assuming the signoff line is the real name you want me to use?

> @@ -2525,6 +2560,138 @@ static void megasas_shutdown_controller(
>  }
>  
>  /**
> + * megasas_suspend -    driver suspend entry point
> + * @pdev:               PCI device structure
> + * @state:		PCI power state to suspend routine
> + */
> +static int __devinit
> +megasas_suspend(struct pci_dev *pdev, pm_message_t state)
> +{
> +	struct Scsi_Host *host;
> +	struct megasas_instance *instance;
> +
> +	instance = pci_get_drvdata(pdev);
> +	host = instance->host;
> +
> +	megasas_flush_cache(instance);
> +	megasas_shutdown_controller(instance, MR_DCMD_HIBERNATE_SHUTDOWN);
> +	tasklet_kill(&instance->isr_tasklet);
> +
> +	pci_set_drvdata(instance->pdev, instance);
> +	instance->instancet->disable_intr(instance->reg_set);
> +	free_irq(instance->pdev->irq, instance);
> +
> +	scsi_host_put(host);

This can't be right.  You're not relinquishing the host here, since you
simply pick it out of the pci driver data on resume.

> +
> +	pci_save_state(pdev);
> +	pci_disable_device(pdev);
> +
> +	pci_set_power_state(pdev, pci_choose_state(pdev, state));
> +
> +	return 0;
> +}
> +
> +/**
> + * megasas_resume-      driver resume entry point
> + * @pdev:               PCI device structure
> + */
> +static int __devinit
> +megasas_resume(struct pci_dev *pdev)
> +{
> +	int rval;
> +	struct Scsi_Host *host;
> +	struct megasas_instance *instance;
> +
> +	instance = pci_get_drvdata(pdev);
> +	host = instance->host;

As in here ... to get the correct refcounting, you'd have to bump up the
reference here.  However, I don't think the put on suspend is correct.

> +       pci_set_power_state(pdev, PCI_D0);
> +       pci_enable_wake(pdev, PCI_D0, 0);
> +       pci_restore_state(pdev);
> +
> +       /*
> +        * PCI prepping: enable device set bus mastering and dma mask
> +        */
> +       rval = pci_enable_device(pdev);
> +
> +       if (rval) {
> +               printk(KERN_ERR "megasas: Enable device failed\n");
> +               return rval;
> +       }
> +
> +       pci_set_master(pdev);
> +
> +       if (megasas_set_dma_mask(pdev))
> +               goto fail_set_dma_mask;
> +
> +       /*
> +        * Initialize MFI Firmware
> +        */
> +
> +       *instance->producer = 0;
> +       *instance->consumer = 0;
> +
> +       atomic_set(&instance->fw_outstanding, 0);
> +
> +       /*
> +        * We expect the FW state to be READY
> +        */
> +       if (megasas_transition_to_ready(instance))
> +               goto fail_ready_state;
> +
> +       if (megasas_issue_init_mfi(instance))
> +               goto fail_init_mfi;
> +
> +       tasklet_init(&instance->isr_tasklet, megasas_complete_cmd_dpc,
> +                       (unsigned long)instance);
> +
> +       /*
> +        * Register IRQ
> +        */
> +       if (request_irq(pdev->irq, megasas_isr, IRQF_SHARED,
> +               "megasas", instance)) {
> +               printk(KERN_ERR "megasas: Failed to register IRQ\n");
> +               goto fail_irq;
> +       }
> +
> +       instance->instancet->enable_intr(instance->reg_set);
> +
> +       /*
> +        * Store instance in PCI softstate
> +        */
> +       pci_set_drvdata(pdev, instance);

This better be redundant ... you picked the instance out of the driver
data at the beginning of this routine ... it better still be there or
else something is seriously wrong.

> +
> +       /*
> +        * Initiate AEN (Asynchronous Event Notification)
> +        */
> +       if (megasas_start_aen(instance))
> +               printk(KERN_ERR "megasas: Start AEN failed\n");
> +
> +       return 0;


James


