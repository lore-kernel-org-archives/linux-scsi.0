From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] eata: remove driver_lock
Date: Sat, 26 Jul 2014 09:25:59 -0700
Message-ID: <20140726162559.GA25106@infradead.org>
References: <1405326393-18559-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51934 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbaGZQ0C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Jul 2014 12:26:02 -0400
Content-Disposition: inline
In-Reply-To: <1405326393-18559-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

Can I get a quick review for this one?

On Mon, Jul 14, 2014 at 10:26:33AM +0200, Christoph Hellwig wrote:
> port_detect is only called from the module_init routine and thus implicitly
> serialized, so remove the driver lock which was held over potentially
> sleeping function calls.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Arthur Marsh <arthur.marsh@internode.on.net>
> Tested-by: Arthur Marsh <arthur.marsh@internode.on.net>
> ---
>  drivers/scsi/eata.c | 9 ---------
>  1 file changed, 9 deletions(-)
> 
> diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
> index 03372cf..980898e 100644
> --- a/drivers/scsi/eata.c
> +++ b/drivers/scsi/eata.c
> @@ -837,7 +837,6 @@ struct hostdata {
>  static struct Scsi_Host *sh[MAX_BOARDS];
>  static const char *driver_name = "EATA";
>  static char sha[MAX_BOARDS];
> -static DEFINE_SPINLOCK(driver_lock);
>  
>  /* Initialize num_boards so that ihdlr can work while detect is in progress */
>  static unsigned int num_boards = MAX_BOARDS;
> @@ -1097,8 +1096,6 @@ static int port_detect(unsigned long port_base, unsigned int j,
>  		goto fail;
>  	}
>  
> -	spin_lock_irq(&driver_lock);
> -
>  	if (do_dma(port_base, 0, READ_CONFIG_PIO)) {
>  #if defined(DEBUG_DETECT)
>  		printk("%s: detect, do_dma failed at 0x%03lx.\n", name,
> @@ -1265,10 +1262,7 @@ static int port_detect(unsigned long port_base, unsigned int j,
>  	}
>  #endif
>  
> -	spin_unlock_irq(&driver_lock);
>  	sh[j] = shost = scsi_register(tpnt, sizeof(struct hostdata));
> -	spin_lock_irq(&driver_lock);
> -
>  	if (shost == NULL) {
>  		printk("%s: unable to register host, detaching.\n", name);
>  		goto freedma;
> @@ -1345,8 +1339,6 @@ static int port_detect(unsigned long port_base, unsigned int j,
>  	else
>  		sprintf(dma_name, "DMA %u", dma_channel);
>  
> -	spin_unlock_irq(&driver_lock);
> -
>  	for (i = 0; i < shost->can_queue; i++)
>  		ha->cp[i].cp_dma_addr = pci_map_single(ha->pdev,
>  							  &ha->cp[i],
> @@ -1439,7 +1431,6 @@ static int port_detect(unsigned long port_base, unsigned int j,
>        freeirq:
>  	free_irq(irq, &sha[j]);
>        freelock:
> -	spin_unlock_irq(&driver_lock);
>  	release_region(port_base, REGION_SIZE);
>        fail:
>  	return 0;
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
