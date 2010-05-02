From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/3 ] SCSI: Support HW reset for EH and polling scheme
 for scsi device
Date: Sun, 02 May 2010 10:59:05 -0400
Message-ID: <1272812345.23834.15.camel@mulgrave.site>
References: <D4960FDBD0714FA69F9D9D77831E95FB@areca4e4f859d4>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55399 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056Ab0EBO7O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 May 2010 10:59:14 -0400
In-Reply-To: <D4960FDBD0714FA69F9D9D77831E95FB@areca4e4f859d4>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nick.cheng@areca.com.tw
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 2010-04-15 at 13:56 +0800, Nick Cheng wrote:
> 1. To support instantaneous report for SCSI device existing by periodic
> polling
> 2. In arcmsr_iop_xfer(), inform AP of F/W's deadlock state to prevent
> endless waiting
> 3. To block the coming SCSI command while the driver is handling bus reset
> 4. To support HW reset in bus reset error handler
> Signed-off-by: Nick Cheng< nick.cheng@areca.com.tw >

This is reverting essential build fixes (and other deprecation fixes)
like this:


> @@ -96,14 +103,18 @@ static u32 arcmsr_disable_outbound_ints(struct AdapterControlBlock *acb);
>  static void arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb);
>  static void arcmsr_flush_hba_cache(struct AdapterControlBlock *acb);
>  static void arcmsr_flush_hbb_cache(struct AdapterControlBlock *acb);
> +static void arcmsr_request_device_map(unsigned long pacb);
> +static void arcmsr_request_hba_device_map(struct AdapterControlBlock *acb);
> +static void arcmsr_request_hbb_device_map(struct AdapterControlBlock *acb);
> +static void arcmsr_message_isr_bh_fn(struct work_struct *work);
> +static void *arcmsr_get_firmware_spec(struct AdapterControlBlock *acb, int mode);
> +static void arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb);
> +
>  static const char *arcmsr_info(struct Scsi_Host *);
>  static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb);
>  static int arcmsr_adjust_disk_queue_depth(struct scsi_device *sdev,
> -					  int queue_depth, int reason)
> +								int queue_depth)

The indentation is bad, but removing one of the arguments causes this compile warning:

drivers/scsi/arcmsr/arcmsr_hba.c:133: warning: initialization from incompatible pointer type

Which is right, this function is supposed to have three arguments.



> @@ -66,6 +66,17 @@ struct device_attribute;
>  #define ARC_SUCCESS
> 0
>  #define ARC_FAILURE
> 1
>  /*
> +**********************************************************************************
> +**
> +**********************************************************************************
> +*/
> +#ifndef TRUE
> +#define TRUE 1
> +#endif
> +#ifndef FALSE
> +#define FALSE 0
> +#endif

This one's a no-no ... we've been trying to get rid of the 10 million
different TRUE/FALSE defines.  The gcc compiler for the kernel supports
the bool type and the true/false keywords, use them instead.  Oh, and
all the

> +		if (acb->fw_state == FALSE) {
> +			pcmdmessagefld->cmdmessage.ReturnCode =

Is much better written

	if (!acb->fw_state)


> @@ -397,9 +478,9 @@ static int arcmsr_probe(struct pci_dev *
>         acb = (struct AdapterControlBlock *)host->hostdata;
>         memset(acb, 0, sizeof (struct AdapterControlBlock));
>  
> -       error = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
> +       error = pci_set_dma_mask(pdev, DMA_64BIT_MASK);
>         if (error) {
> -               error = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
> +               error = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
>                 if (error) {
>                         printk(KERN_WARNING
>                                "scsi%d: No suitable DMA mask available
> \n",
> @@ -432,17 +513,17 @@ static int arcmsr_probe(struct pci_dev *

This is again reverting a necessary change.  With this in place the
compile now spits warnings about DMA_nnBIT_MASK being deprecated.


> iff -Naurp --ignore-blank-lines --ignore-all-space
> --ignore-space-change linux-2.6/drivers/scsi/arcmsr/Makefile
> linux-2.6/drivers/scsi/arcmsr.1.20.00.15-81103/Makefile
> --- linux-2.6/drivers/scsi/arcmsr/Makefile      2010-04-14
> 19:15:11.000000000 +0800
> +++
> linux-2.6/drivers/scsi/arcmsr.1.20.00.15-81103/Makefile     1970-01-01
> 08:00:00.000000000 +0800
> @@ -1,6 +0,0 @@
> -# File: drivers/arcmsr/Makefile
> -# Makefile for the ARECA PCI-X PCI-EXPRESS SATA RAID controllers SCSI
> driver.
> -
> -arcmsr-objs := arcmsr_attr.o arcmsr_hba.o
> -
> -obj-$(CONFIG_SCSI_ARCMSR) := arcmsr.o

So if you take away the Makefile, this doesn't even build.

James


