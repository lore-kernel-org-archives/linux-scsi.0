From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/12] scsi: add 'am53c974' driver
Date: Mon, 24 Nov 2014 05:50:41 -0800
Message-ID: <20141124135041.GA28523@infradead.org>
References: <1416573716-73890-1-git-send-email-hare@suse.de>
 <1416573716-73890-8-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49660 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbaKXNut (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Nov 2014 08:50:49 -0500
Content-Disposition: inline
In-Reply-To: <1416573716-73890-8-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, "David S. Miller" <davem@davemloft.net>, linux-scsi@vger.kernel.org

> +/*
> + * AMD am53c974 driver.
> + * Copyright (c) 2014 Hannes Reinecke, SUSE Linux GmbH
> + */

Is there anything left from the old driver that should get credit here?

> +#define PCI_ESP_GET_PRIV(esp) ((struct pci_esp_priv *) \
> +			       pci_get_drvdata((struct pci_dev *) \
> +					       (esp)->dev))

I think an inline function would be a lot cleaner, especially as that
should avoid all these casts.

> +#ifdef ESP_DMA_DEBUG
> +	shost_printk(KERN_INFO, esp->host, "start dma addr[%x] count[%d:%d]\n",
> +		     addr, esp_count, dma_count);
> +#endif

Can you add a esp_dma_printk or similar instead of all these ifdefs?

> +	u8 carryFlag = 1, j = 0x80, bval;

carry_flag.

> +	if (pci_request_regions(pdev, DRV_MODULE_NAME)) {

> +	if (request_irq(pdev->irq, scsi_esp_intr, IRQF_SHARED,
> +			DRV_MODULE_NAME, esp)) {

Please propagate the return values from these two.


Otherwise looks good.  Please resend with fixes for these and Dave's
style comment, and I'll apply it.
