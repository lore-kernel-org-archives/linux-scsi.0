From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 10/10] esp: enable CONFIG2_FENAB for am53c974
Date: Fri, 21 Nov 2014 11:08:43 +0100
Message-ID: <546F0F2B.40901@redhat.com>
References: <1416562077-105715-1-git-send-email-hare@suse.de> <1416562077-105715-11-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755062AbaKUKI6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2014 05:08:58 -0500
In-Reply-To: <1416562077-105715-11-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org



On 21/11/2014 10:27, Hannes Reinecke wrote:
> CONFIG2_FENAB ('feature enable') changed definition between chip
> revisions, from 'Latch SCSI Phase' to 'Latch SCSI Phase, display
> chip ID upon reset, and enable 24 bit addresses'.
> So only enable it for am53c974 where we know what it's doing.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/am53c974.c | 30 ++++++++++++++++++++++++++++++
>  drivers/scsi/esp_scsi.c |  4 ++++
>  2 files changed, 34 insertions(+)
> 
> diff --git a/drivers/scsi/am53c974.c b/drivers/scsi/am53c974.c
> index 0452ed1..722e781 100644
> --- a/drivers/scsi/am53c974.c
> +++ b/drivers/scsi/am53c974.c
> @@ -252,6 +252,8 @@ static void pci_esp_send_dma_cmd(struct esp *esp, u32 addr, u32 esp_count,
>  
>  	pci_esp_write8(esp, (esp_count >> 0) & 0xff, ESP_TCLOW);
>  	pci_esp_write8(esp, (esp_count >> 8) & 0xff, ESP_TCMED);
> +	if (esp->config2 & ESP_CONFIG2_FENAB)
> +		pci_esp_write8(esp, (esp_count >> 16) & 0xff, ESP_TCHI);

Why do this conditionally?  We know that FENAB is true here, don't we?

(Maybe I'm missing something obvious though).

Paolo
>  
>  	pci_esp_write32(esp, esp_count, ESP_DMA_STC);
>  	pci_esp_write32(esp, addr, ESP_DMA_SPA);
> @@ -265,6 +267,33 @@ static void pci_esp_send_dma_cmd(struct esp *esp, u32 addr, u32 esp_count,
>  	pci_esp_write8(esp, ESP_DMA_CMD_START | val, ESP_DMA_CMD);
>  }
>  
> +static u32 pci_esp_dma_length_limit(struct esp *esp, u32 dma_addr, u32 dma_len)
> +{
> +	int dma_limit = 16;
> +	u32 base, end;
> +
> +	/*
> +	 * If CONFIG2_FENAB is set we can
> +	 * handle up to 24 bit addresses
> +	 */
> +	if (esp->config2 & ESP_CONFIG2_FENAB)
> +		dma_limit = 24;
> +
> +	if (dma_len > (1U << dma_limit))
> +		dma_len = (1U << dma_limit);
> +
> +	/*
> +	 * Prevent crossing a 24-bit address boundary.
> +	 */
> +	base = dma_addr & ((1U << 24) - 1U);
> +	end = base + dma_len;
> +	if (end > (1U << 24))
> +		end = (1U <<24);
> +	dma_len = end - base;
> +
> +	return dma_len;
> +}
> +
>  static const struct esp_driver_ops pci_esp_ops = {
>  	.esp_write8	=	pci_esp_write8,
>  	.esp_read8	=	pci_esp_read8,
> @@ -278,6 +307,7 @@ static const struct esp_driver_ops pci_esp_ops = {
>  	.dma_invalidate	=	pci_esp_dma_invalidate,
>  	.send_dma_cmd	=	pci_esp_send_dma_cmd,
>  	.dma_error	=	pci_esp_dma_error,
> +	.dma_length_limit =	pci_esp_dma_length_limit,
>  };
>  
>  /*
> diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
> index 01753f5..d0b7b32 100644
> --- a/drivers/scsi/esp_scsi.c
> +++ b/drivers/scsi/esp_scsi.c
> @@ -289,6 +289,8 @@ static void esp_reset_esp(struct esp *esp)
>  
>  	case FAS236:
>  	case PCSCSI:
> +		if (esp->rev == PCSCSI)
> +			esp->config2 |= ESP_CONFIG2_FENAB;
>  		/* Fast 236, AM53c974 or HME */
>  		esp_write8(esp->config2, ESP_CFG2);
>  		if (esp->rev == FASHME) {
> @@ -1362,6 +1364,8 @@ static int esp_data_bytes_sent(struct esp *esp, struct esp_cmd_entry *ent,
>  			  (((unsigned int)esp_read8(ESP_TCMED)) << 8));
>  		if (esp->rev == FASHME)
>  			ecount |= ((unsigned int)esp_read8(FAS_RLO)) << 16;
> +		if (esp->rev == PCSCSI && (esp->config2 & ESP_CONFIG2_FENAB))
> +			ecount |= ((unsigned int)esp_read8(ESP_TCHI)) << 16;
>  	}
>  
>  	bytes_sent = esp->data_dma_len;
> 
