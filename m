From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] 2.6.1-rc2 - MPT Fusion driver 3.00.00 update
Date: Wed, 7 Jan 2004 09:58:08 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040107095808.A26814@infradead.org>
References: <3FFB4E0F.704@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:23556 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S266172AbUAGJ6P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Jan 2004 04:58:15 -0500
Content-Disposition: inline
In-Reply-To: <3FFB4E0F.704@lsil.com>; from emoore@lsil.com on Tue, Jan 06, 2004 at 05:08:47PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <emoore@lsil.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Jan 06, 2004 at 05:08:47PM -0700, Eric Moore wrote:
> Here's an driver update for mpt fusion driver version 3.00.00.
> 
> If you find this inline patch malformed,
> please kindly download this patch from this URL:

Yes, it's mangled :)

> +/****************************************************************************
> + * Supported hardware
> + */
> +#define    DEVT_INDEX_MPT        0x0000        /* Fusion MPT Interface */

This is superflous - you don't need to set the driver_data member at all
and it'll be zero implicitly.

> +#ifndef MPTSCSIH_DISABLE_DOMAIN_VALIDATION

Negated cpp symbols aren't a good idea, thus should read

#ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION

or even better get rid of the ifdef completely.

> +static int
> +__devinit mptbase_probe(struct pci_dev *pdev, const struct 

the __devinit belong on the first line.

> pci_device_id *id)
>  {
>      MPT_ADAPTER    *ioc;
>      u8        *mem;
> @@ -1292,6 +1317,13 @@
>          return r;
>      }
>  
> +    if (!pci_set_consistent_dma_mask(pdev, mask))
> +        dprintk((KERN_INFO MYNAM
> +            ": Using 64 bit consistent mask\n"));
> +    else
> +        dprintk((KERN_INFO MYNAM
> +            ": Not using 64 bit consistent mask\n"));

isn't this a bit verbose?

> +static void
> +__devexit mptbase_remove(struct pci_dev *pdev)

same as above.

> +{
> +    mptscsih_sync_irq(pdev->irq);
> +    pci_set_drvdata(pdev, NULL);

You need to move all per-chip exit code here.

> +
> +/**************************************************************************
> + * Power Management
> + */
> +#ifdef CONFIG_PM
> +#include <acpi/acpi_drivers.h>

this is completly b0rked.  Drivers shouldn't include acpi headers
directly.

> -    if ((i = mpt_pci_scan()) < 0)
> -        return i;
> +    r = pci_module_init(&mptbase_driver);
>  
> -    return 0;
> +#ifdef CONFIG_PROC_FS
> +    (void) procmpt_create();
> +#endif
> +

If the pci_module_init failed you don't want to register procfs nodes.

> -    struct pci_dev *pdev = NULL;
>  
>      dprintk((KERN_INFO MYNAM ": fusion_exit() called!\n"));
>  
> +    pci_unregister_driver(&mptbase_driver);
> +
>      /* Whups?  20010120 -sralston
>       *  Moved this *above* removal of all MptAdapters!
>       */
> @@ -5956,9 +6148,6 @@
>  
>          this->active = 0;
>  
> -        pdev = (struct pci_dev *)this->pcidev;
> -        mptscsih_sync_irq(pdev->irq);
> -
>          /* Clear any lingering interrupt */
>          CHIPREG_WRITE32(&this->chip->IntStatus, 0);

Everything here needs to move to the _remove routine.

> +#ifdef MPT_SCSIHOST_NEED_ENTRY_EXIT_HOOKUPS

Why the ifdef again?

> +static Scsi_Host_Template driver_template = {

For 2.6 please use struct scsi_host_template instead.

> @@ -264,12 +298,14 @@
>  mptscsih_io_direction(Scsi_Cmnd *cmd)
>  {
>      switch (cmd->cmnd[0]) {
> -    case WRITE_6:       
> -    case WRITE_10:       
> +    case WRITE_6:
> +    case WRITE_10:

Eeek!  you get that info from cmd->sc_data_direction

> +                /* set 16 byte cdb's
> +                */
> +                sh->max_cmd_len = 16;
> +

Please set this in the host template instead of in the host.

> +                scsi_add_host (sh, &this->pcidev->dev);

you need to check for an error return here.

> -    if (mpt_scsi_hosts > 0)
> +    if (mpt_scsi_hosts > 0) {
>          register_reboot_notifier(&mptscsih_notifier);
> -    else {
> +        return 0;
> +    } else {

Please don't use reboot notifier but rather the shutdown routine in
the struct device_driver embedded in struct pci_driver.  See the
megaraid driver in 2.6.1-rc for an example.

> +static void
> +__exit mptscsih_exit(void)
> +{
> +    MPT_ADAPTER        *this;
> +    struct Scsi_Host    *sh = NULL;
> +
> +    this = mpt_adapter_find_first();
> +    while (this != NULL) {
> +
> +        if (this->last_state != MPI_IOC_STATE_OPERATIONAL) {
> +            this = mpt_adapter_find_next(this);
> +            continue;
> +        }
> +
> +        sh = this->sh;
> +        if( sh == NULL ) {
> +            continue;
> +        }
> +
> +        scsi_remove_host(sh);
> +        mptscsih_release(sh);
> +        scsi_host_put(sh);
> +        this->sh = NULL;
> +        this = mpt_adapter_find_next(this);

This looks extremly bogus.  All that should be triggered by the PCI
->remove callback.

> +#ifdef CONFIG_LBD
> +    dummy = heads * sectors;
> +    cylinders = capacity;
> +    do_div(cylinders,dummy);
> +#else
> +    cylinders = (ulong)capacity / (heads * sectors);
> +#endif

Please use the sector_div routine that gets both cases right for you.

> +#ifdef CONFIG_LBD
> +        dummy = heads * sectors;
> +        cylinders = capacity;
> +        do_div(cylinders,dummy);
> +#else
> +        cylinders = (ulong)capacity / (heads * sectors);
> +#endif

Dito.

