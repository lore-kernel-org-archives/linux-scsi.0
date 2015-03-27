From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] am53c974: Fix crash during modprobe
Date: Fri, 27 Mar 2015 08:57:39 +0100
Message-ID: <1427443059.2250.6.camel@HansenPartnership.com>
References: <1427441343-122454-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43796 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753007AbbC0H5o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Mar 2015 03:57:44 -0400
In-Reply-To: <1427441343-122454-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Fri, 2015-03-27 at 08:29 +0100, Hannes Reinecke wrote:
> On systems with shared interrupts the interrupt routine might
> be called as soon as the interrupt is enabled.
> As this might happen before pci_set_drvdata() is called the
> system would crash.
> 
> Reported-by: Andreas Brogle <anbro@ok.de>
> Tested-by: Andreas Brogle <anbro@ok.de>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/am53c974.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/am53c974.c b/drivers/scsi/am53c974.c
> index a6f5ee8..3a35502 100644
> --- a/drivers/scsi/am53c974.c
> +++ b/drivers/scsi/am53c974.c
> @@ -144,6 +144,9 @@ static int pci_esp_irq_pending(struct esp *esp)
>  {
>  	struct pci_esp_priv *pep = pci_esp_get_priv(esp);
>  
> +	if (!pep)
> +		return 0;
> +

Surely this is superfluous now you've done

>  	pep->dma_status = pci_esp_read8(esp, ESP_DMA_STATUS);
>  	esp_dma_log("dma intr dreg[%02x]\n", pep->dma_status);
>  
> @@ -476,6 +479,8 @@ static int pci_esp_probe_one(struct pci_dev *pdev,
>  		goto fail_unmap_regs;
>  	}
>  
> +	pci_set_drvdata(pdev, pep);
> +

This?  How can the pep ever be NULL in the interrupt?

James


>  	err = request_irq(pdev->irq, scsi_esp_intr, IRQF_SHARED,
>  			  DRV_MODULE_NAME, esp);
>  	if (err < 0) {
> @@ -496,8 +501,6 @@ static int pci_esp_probe_one(struct pci_dev *pdev,
>  	/* Assume 40MHz clock */
>  	esp->cfreq = 40000000;
>  
> -	pci_set_drvdata(pdev, pep);
> -
>  	err = scsi_esp_register(esp, &pdev->dev);
>  	if (err)
>  		goto fail_free_irq;
> @@ -507,6 +510,7 @@ static int pci_esp_probe_one(struct pci_dev *pdev,
>  fail_free_irq:
>  	free_irq(pdev->irq, esp);
>  fail_unmap_command_block:
> +	pci_set_drvdata(pdev, NULL);
>  	pci_free_consistent(pdev, 16, esp->command_block,
>  			    esp->command_block_dma);
>  fail_unmap_regs:
> @@ -530,6 +534,7 @@ static void pci_esp_remove_one(struct pci_dev *pdev)
>  
>  	scsi_esp_unregister(esp);
>  	free_irq(pdev->irq, esp);
> +	pci_set_drvdata(pdev, NULL);
>  	pci_free_consistent(pdev, 16, esp->command_block,
>  			    esp->command_block_dma);
>  	pci_iounmap(pdev, esp->regs);



