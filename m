From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC PATCH 1/6] isci: initialization
Date: Thu, 17 Feb 2011 03:22:51 -0500
Message-ID: <4D5CDADB.6040508@garzik.org>
References: <20110207003056.27040.89174.stgit@localhost6.localdomain6> <20110207003440.27040.22825.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55816 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab1BQIW4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2011 03:22:56 -0500
Received: by vws16 with SMTP id 16so950151vws.19
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2011 00:22:55 -0800 (PST)
In-Reply-To: <20110207003440.27040.22825.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: james.bottomley@suse.de, dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

On 02/06/2011 07:34 PM, Dan Williams wrote:
> +irqreturn_t isci_isr(int vec, void *data)
> +{
> +	struct isci_host *isci_host
> +		= (struct isci_host *)data;
> +	struct scic_controller_handler_methods *handlers
> +		=&isci_host->scic_irq_handlers[SCI_MSIX_NORMAL_VECTOR];
> +	irqreturn_t ret = IRQ_NONE;
> +
> +	if (isci_host_get_state(isci_host) != isci_starting
> +	&&  handlers->interrupt_handler) {
> +
> +		if (handlers->interrupt_handler(isci_host->core_controller)) {
> +			if (isci_host_get_state(isci_host) != isci_stopped) {
> +				tasklet_schedule(
> +					&isci_host->completion_tasklet);
> +			} else
> +				dev_dbg(&isci_host->pdev->dev,
> +					"%s: controller stopped\n",
> +					__func__);
> +			ret = IRQ_HANDLED;
> +		}
> +	} else
> +		dev_warn(&isci_host->pdev->dev,
> +			 "%s: get_handler_methods failed, "
> +			 "isci_host->status = 0x%x\n",
> +			 __func__,
> +			 isci_host_get_state(isci_host));
> +
> +	return ret;
> +}

Obviously my grep-fu is failing me...  where is interrupt_handler 
assigned a value?  Creating a pointer for the interrupt handler, rather 
than directly registering the proper callback with the kernel, seems a 
bit odd.

	Jeff


