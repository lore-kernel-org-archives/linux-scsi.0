From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Remove libsas PCI dependencies
Date: Thu, 26 Jul 2007 08:46:47 -0400
Message-ID: <1185454007.3501.34.camel@localhost.localdomain>
References: <Pine.SOC.4.64.0707261129220.17385@math.ut.ee>
	 <46A867AB.7050007@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:44599 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755126AbXGZMqt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jul 2007 08:46:49 -0400
In-Reply-To: <46A867AB.7050007@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Meelis Roos <mroos@linux.ee>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel list <linux-kernel@vger.kernel.org>, "Darrick J. Wong" <djwong@us.ibm.com>, Andrew Morton <akpm@linux-foundation.org>

On Thu, 2007-07-26 at 05:21 -0400, Jeff Garzik wrote:
> Meelis Roos wrote:
> > Tried to compile everythin SCSI on my SBus-only sparc64, including SAS 
> > supoort. Seems that libsas seems to depend on PCI - does it need to?
> > 
> >   MODPOST 446 modules
> > ERROR: "pci_iommu_ops" [drivers/scsi/libsas/libsas.ko] undefined!
> 
> 
> Does the attached patch fix things?  2.6.23-rc1 material, methinks.
> 
> libsas should -not- require PCI, even though aic94xx does.

Realistically, even for parisc, I can't see anyone producing a non-PCI
SAS device (even though I'd like one).

> Signed-off-by: Jeff Garzik <jeff@garzik.org>
> 
> plain text document attachment (patch)
> diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
> index ab00aec..63bcde2 100644
> --- a/drivers/scsi/aic94xx/aic94xx_init.c
> +++ b/drivers/scsi/aic94xx/aic94xx_init.c
> @@ -586,7 +586,7 @@ static int __devinit asd_pci_probe(struct pci_dev *dev,
>  		goto Err;
>  	}
>  	asd_ha->pcidev = dev;
> -	asd_ha->sas_ha.pcidev = asd_ha->pcidev;
> +	asd_ha->sas_ha.dev = &asd_ha->pcidev->dev;
>  	asd_ha->sas_ha.lldd_ha = asd_ha;
>  
>  	asd_ha->name = asd_dev->name;
> @@ -605,8 +605,6 @@ static int __devinit asd_pci_probe(struct pci_dev *dev,
>  		goto Err_free;
>  	}
>  
> -
> -
>  	err = asd_dev->setup(asd_ha);
>  	if (err)
>  		goto Err_free;
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> index ced2de3..77c4668 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -382,7 +382,7 @@ int sas_ata_init_host_and_port(struct domain_device *found_dev,
>  	struct ata_port *ap;
>  
>  	ata_host_init(&found_dev->sata_dev.ata_host,
> -		      &ha->pcidev->dev,
> +		      ha->dev,
>  		      sata_port_info.flags,
>  		      &sas_sata_ops);
>  	ap = ata_sas_port_alloc(&found_dev->sata_dev.ata_host,
> @@ -448,10 +448,10 @@ static void sas_disc_task_done(struct sas_task *task)
>   * @task: the task to be executed
>   * @buffer: pointer to buffer to do I/O
>   * @size: size of @buffer
> - * @pci_dma_dir: PCI_DMA_...
> + * @dma_dir: DMA direction.  DMA_xxx
>   */
>  static int sas_execute_task(struct sas_task *task, void *buffer, int size,
> -			    int pci_dma_dir)
> +			    int dma_dir)
>  {
>  	int res = 0;
>  	struct scatterlist *scatter = NULL;
> @@ -461,7 +461,7 @@ static int sas_execute_task(struct sas_task *task, void *buffer, int size,
>  	struct sas_internal *i =
>  		to_sas_internal(task->dev->port->ha->core.shost->transportt);
>  
> -	if (pci_dma_dir != PCI_DMA_NONE) {
> +	if (dma_dir != DMA_NONE) {
>  		scatter = kzalloc(sizeof(*scatter), GFP_KERNEL);
>  		if (!scatter)
>  			goto out;
> @@ -474,11 +474,11 @@ static int sas_execute_task(struct sas_task *task, void *buffer, int size,
>  	task->scatter = scatter;
>  	task->num_scatter = num_scatter;
>  	task->total_xfer_len = size;
> -	task->data_dir = pci_dma_dir;
> +	task->data_dir = dma_dir;
>  	task->task_done = sas_disc_task_done;
> -	if (pci_dma_dir != PCI_DMA_NONE &&
> +	if (dma_dir != DMA_NONE &&
>  	    sas_protocol_ata(task->task_proto)) {
> -		task->num_scatter = pci_map_sg(task->dev->port->ha->pcidev,
> +		task->num_scatter = dma_map_sg(task->dev->port->ha->dev,
>  					       task->scatter,
>  					       task->num_scatter,
>  					       task->data_dir);
> @@ -565,9 +565,9 @@ static int sas_execute_task(struct sas_task *task, void *buffer, int size,
>  		}
>  	}
>  ex_err:
> -	if (pci_dma_dir != PCI_DMA_NONE) {
> +	if (dma_dir != DMA_NONE) {
>  		if (sas_protocol_ata(task->task_proto))
> -			pci_unmap_sg(task->dev->port->ha->pcidev,
> +			dma_unmap_sg(task->dev->port->ha->dev,
>  				     task->scatter, task->num_scatter,
>  				     task->data_dir);
>  		kfree(scatter);
> @@ -628,11 +628,11 @@ static void sas_get_ata_command_set(struct domain_device *dev)
>   * @features: the features register
>   * @buffer: pointer to buffer to do I/O
>   * @size: size of @buffer
> - * @pci_dma_dir: PCI_DMA_...
> + * @dma_dir: DMA direction.  DMA_xxx
>   */
>  static int sas_issue_ata_cmd(struct domain_device *dev, u8 command,
>  			     u8 features, void *buffer, int size,
> -			     int pci_dma_dir)
> +			     int dma_dir)

This should become enum dma_data_direction if we're going to go the
generic route.

Otherwise, everything else looks fine.

James


