From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] hpsa: add missing pci_set_master in kdump path
Date: Thu, 25 Sep 2014 14:20:39 +0200
Message-ID: <20140925122039.GA11116@infradead.org>
References: <5412EA9F.4060703@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:47243 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaIYMSQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Sep 2014 08:18:16 -0400
Content-Disposition: inline
In-Reply-To: <5412EA9F.4060703@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Tomas, can you also give me a signed-off-by for this one?

On Fri, Sep 12, 2014 at 02:44:15PM +0200, Tomas Henzl wrote:
> Add a call to pci_set_master(...)  missing in the previous
> patch "hpsa: refine the pci enable/disable handling".
> Found thanks to Rob Elliot.
> ---
>  drivers/scsi/hpsa.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 7828834..cef5d49 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -6544,7 +6544,7 @@ static int hpsa_init_reset_devices(struct pci_dev *pdev)
>  		dev_warn(&pdev->dev, "failed to enable device.\n");
>  		return -ENODEV;
>  	}
> -
> +	pci_set_master(pdev);
>  	/* Reset the controller with a PCI power-cycle or via doorbell */
>  	rc = hpsa_kdump_hard_reset_controller(pdev);
>  
> -- 
> 1.8.3.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
