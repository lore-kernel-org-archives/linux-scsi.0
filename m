From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] megaraid_sas: enable intx only if msix request fails
Date: Wed, 8 Mar 2017 07:09:27 -0800
Message-ID: <20170308150927.GA27450@infradead.org>
References: <1488452056-16083-1-git-send-email-kashyap.desai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:57388 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751635AbdCHPJp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2017 10:09:45 -0500
Content-Disposition: inline
In-Reply-To: <1488452056-16083-1-git-send-email-kashyap.desai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, hare@suse.de

On Thu, Mar 02, 2017 at 02:54:16AM -0800, Kashyap Desai wrote:
> Without this fix, driver will enable INTx Interrupt pin even
>  though MSI-x vectors are enabled. See below lspci output. DisINTx is unset
>  for MSIx setup.
> 
> lspci -s 85:00.0 -vvv |grep INT |grep Control
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
> 
> After applying this fix, driver will enable INTx Interrupt pin only if Legacy interrupt method is required.
> See below lspci output. DisINTx is unset for MSIx setup.
> lspci -s 85:00.0 -vvv |grep INT |grep Control
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 7ac9a9e..82a8ec8 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -4990,6 +4990,7 @@ int megasas_set_crash_dump_params(struct megasas_instance *instance,
>  	struct pci_dev *pdev;
>  
>  	pdev = instance->pdev;
> +	pci_intx(pdev, 1);

Please use pci_alloc_irq_vectors with the PCI_IRQ_LEGACY flag here,
I'd like to phase out the pci_intx API.
