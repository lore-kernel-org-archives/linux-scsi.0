From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 6/21] advansys: Move to scsi hotplug initialisation model
Date: Thu, 26 Jul 2007 15:19:31 -0400
Message-ID: <46A8F3C3.9030500@garzik.org>
References: 20070726171141.GE19275@parisc-linux.org <11854705779-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:50815 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932163AbXGZTTd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jul 2007 15:19:33 -0400
In-Reply-To: <11854705779-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> @@ -18511,13 +18493,24 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
>  	}
>  
>  	if (err_code != 0)
> -		goto err_free_irq;
> +		goto err_free_wide_mem;
>  
>  	ASC_DBG_PRT_SCSI_HOST(2, shost);
>  
> +	ret = scsi_add_host(shost, dev);
> +	if (ret)
> +		goto err_free_wide_mem;
> +
> +	scsi_scan_host(shost);
>  	return shost;
>  
> - err_free_irq:
> + err_free_wide_mem:
> +	kfree(boardp->orig_carrp);
> +	kfree(boardp->orig_reqp);
> +	while ((sgp = boardp->adv_sgblkp) != NULL) {
> +		boardp->adv_sgblkp = sgp->next_sgblkp;
> +		kfree(sgp);
> +	}
>  	free_irq(shost->irq, boardp);
>   err_free_dma:
>  	if (shost->dma_channel != NO_ISA_DMA)

When this patch is considered in context of replies to patch #3, it's 
OK...  it un-breaks driver which was broken in patch #3.

But like I noted, this should be done -before- PCI hotplug conversion, 
for the obvious reasons.

Generally the process involves:

* call foo_detect from module init
* for each scsi host, call foo_release from module exit
* do the scsi conversion as you've presented it here

and then in later patches, rip out the PCI code from foo_detect and 
foo_release, etc.

	Jeff


