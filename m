From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 06/10] scsi: add 'am53c974' driver
Date: Fri, 21 Nov 2014 11:20:10 +0100
Message-ID: <546F11DA.8040800@redhat.com>
References: <1416562077-105715-1-git-send-email-hare@suse.de> <1416562077-105715-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757966AbaKUKUV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2014 05:20:21 -0500
In-Reply-To: <1416562077-105715-7-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Oops, hit send too early.  A small nit:

On 21/11/2014 10:27, Hannes Reinecke wrote:
> +static void pci_esp_dma_drain(struct esp *esp)
> +{
> +	u8 resid;
> +	int lim = 1000;
> +
> +
> +	if ((esp->sreg & ESP_STAT_PMASK) == ESP_DOP ||
> +	    (esp->sreg & ESP_STAT_PMASK) == ESP_DIP)
> +		/* Data-In or Data-Out, nothing to be done */
> +		return;
> +
> +	while (--lim > 0) {
> +		resid = pci_esp_read8(esp, ESP_FFLAGS) & ESP_FF_FBYTES;
> +		if (resid <= 1)
> +			break;

cpu_relax()?

> +	}
> +	if (resid > 1) {
> +		/* FIFO not cleared */
> +		shost_printk(KERN_INFO, esp->host,
> +			     "FIFO not cleared, %d bytes left\n",
> +			     resid);
> +	}
> +
> +	/*
> +	 * When there is a residual BCMPLT will never be set
> +	 * (obviously). But we still have to issue the BLAST
> +	 * command, otherwise the data will not being transferred.
> +	 * But we'll never know when the BLAST operation is
> +	 * finished. So check for some time and give up eventually.
> +	 */
> +	lim = 1000;
> +	pci_esp_write8(esp, ESP_DMA_CMD_DIR | ESP_DMA_CMD_BLAST, ESP_DMA_CMD);
> +	while (pci_esp_read8(esp, ESP_DMA_STATUS) & ESP_DMA_STAT_BCMPLT) {
> +		if (--lim == 0)
> +			break;

cpu_relax()?

Otherwise looks sane.

Paolo
