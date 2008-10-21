From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] pci: use pci_ioremap_bar() in drivers/scsi
Date: Mon, 20 Oct 2008 22:59:27 -0600
Message-ID: <20081021045926.GM26184@parisc-linux.org>
References: <20081020214934.1c6cf887@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:40198 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbYJUE7q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Oct 2008 00:59:46 -0400
Content-Disposition: inline
In-Reply-To: <20081020214934.1c6cf887@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Mon, Oct 20, 2008 at 09:49:34PM -0700, Arjan van de Ven wrote:
> Use the newly introduced pci_ioremap_bar() function in drivers/scsi.
> pci_ioremap_bar() just takes a pci device and a bar number, with the goal
> of making it really hard to get wrong, while also having a central place
> to stick sanity checks.
> 
> CC: linux-scsi@vger.kernel.org
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

For the advansys bits:

Acked-by: Matthew Wilcox <willy@linux.intel.com>

> ---
>  drivers/scsi/advansys.c          |    3 +--
>  drivers/scsi/arcmsr/arcmsr_hba.c |    8 +++-----
>  drivers/scsi/ipr.c               |    2 +-
>  drivers/scsi/nsp32.c             |    3 +--
>  drivers/scsi/qla1280.c           |    3 +--
>  drivers/scsi/stex.c              |    3 +--
>  6 files changed, 8 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
> index 218777b..70bb026 100644
> --- a/drivers/scsi/advansys.c
> +++ b/drivers/scsi/advansys.c
> @@ -13425,8 +13425,7 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
>  		}
>  
>  		boardp->asc_n_io_port = pci_resource_len(pdev, 1);
> -		boardp->ioremap_addr = ioremap(pci_resource_start(pdev, 1),
> -					       boardp->asc_n_io_port);
> +		boardp->ioremap_addr = pci_ioremap_bar(pdev, 1);
>  		if (!boardp->ioremap_addr) {
>  			shost_printk(KERN_ERR, shost, "ioremap(%lx, %d) "
>  					"returned NULL\n",
> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
> index f91f79c..106c04d 100644
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
> @@ -235,7 +235,7 @@ static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
>  		uint32_t intmask_org;
>  		int i, j;
>  
> -		acb->pmuA = ioremap(pci_resource_start(pdev, 0), pci_resource_len(pdev, 0));
> +		acb->pmuA = pci_ioremap_bar(pdev, 0);
>  		if (!acb->pmuA) {
>  			printk(KERN_NOTICE "arcmsr%d: memory mapping region fail \n",
>  							acb->host->host_no);
> @@ -329,13 +329,11 @@ static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
>  		reg = (struct MessageUnit_B *)(dma_coherent +
>  		ARCMSR_MAX_FREECCB_NUM * sizeof(struct CommandControlBlock));
>  		acb->pmuB = reg;
> -		mem_base0 = ioremap(pci_resource_start(pdev, 0),
> -					pci_resource_len(pdev, 0));
> +		mem_base0 = pci_ioremap_bar(pdev, 0);
>  		if (!mem_base0)
>  			goto out;
>  
> -		mem_base1 = ioremap(pci_resource_start(pdev, 2),
> -					pci_resource_len(pdev, 2));
> +		mem_base1 = pci_ioremap_bar(pdev, 2);
>  		if (!mem_base1) {
>  			iounmap(mem_base0);
>  			goto out;
> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> index 098739d..32c8e70 100644
> --- a/drivers/scsi/ipr.c
> +++ b/drivers/scsi/ipr.c
> @@ -7479,7 +7479,7 @@ static int __devinit ipr_probe_ioa(struct pci_dev *pdev,
>  		goto out_scsi_host_put;
>  	}
>  
> -	ipr_regs = ioremap(ipr_regs_pci, pci_resource_len(pdev, 0));
> +	ipr_regs = pci_ioremap_bar(pdev, 0);
>  
>  	if (!ipr_regs) {
>  		dev_err(&pdev->dev,
> diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
> index 22052bb..d06ec5a 100644
> --- a/drivers/scsi/nsp32.c
> +++ b/drivers/scsi/nsp32.c
> @@ -3401,8 +3401,7 @@ static int __devinit nsp32_probe(struct pci_dev *pdev, const struct pci_device_i
>  	data->IrqNumber   = pdev->irq;
>  	data->BaseAddress = pci_resource_start(pdev, 0);
>  	data->NumAddress  = pci_resource_len  (pdev, 0);
> -	data->MmioAddress = ioremap_nocache(pci_resource_start(pdev, 1),
> -					       pci_resource_len  (pdev, 1));
> +	data->MmioAddress = pci_ioremap_bar(pdev, 1);
>  	data->MmioLength  = pci_resource_len  (pdev, 1);
>  
>  	pci_set_master(pdev);
> diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
> index b6cd12b..8cb9240 100644
> --- a/drivers/scsi/qla1280.c
> +++ b/drivers/scsi/qla1280.c
> @@ -4294,8 +4294,7 @@ qla1280_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
>  	error = -ENODEV;
>  
>  #if MEMORY_MAPPED_IO
> -	ha->mmpbase = ioremap(pci_resource_start(ha->pdev, 1),
> -			      pci_resource_len(ha->pdev, 1));
> +	ha->mmpbase = pci_ioremap_bar(ha->pdev, 1);
>  	if (!ha->mmpbase) {
>  		printk(KERN_INFO "qla1280: Unable to map I/O memory\n");
>  		goto error_free_response_ring;
> diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
> index 3790906..fd3d4f5 100644
> --- a/drivers/scsi/stex.c
> +++ b/drivers/scsi/stex.c
> @@ -1108,8 +1108,7 @@ stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  		goto out_scsi_host_put;
>  	}
>  
> -	hba->mmio_base = ioremap_nocache(pci_resource_start(pdev, 0),
> -		pci_resource_len(pdev, 0));
> +	hba->mmio_base = pci_ioremap_bar(pdev, 0);
>  	if ( !hba->mmio_base) {
>  		printk(KERN_ERR DRV_NAME "(%s): memory map failed\n",
>  			pci_name(pdev));
> -- 
> 1.5.5.1
> 
> 
> -- 
> Arjan van de Ven 	Intel Open Source Technology Centre
> For development, discussion and tips for power savings, 
> visit http://www.lesswatts.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
