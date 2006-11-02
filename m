From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 5/8] cciss: disable DMA prefetch for P600
Date: Thu, 2 Nov 2006 15:12:13 +0100
Message-ID: <20061102141213.GJ13555@kernel.dk>
References: <20061101220633.GE29928@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:43098 "EHLO kernel.dk")
	by vger.kernel.org with ESMTP id S1752901AbWKBOKW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Nov 2006 09:10:22 -0500
Content-Disposition: inline
In-Reply-To: <20061101220633.GE29928@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Nov 01 2006, Mike Miller (OS Dev) wrote:
> 
> PATCH 5/8 
> 
> This disables DMA prefetch for the P600 on IPF. A chip bug may result in
> a DMA prefetch going falling off into holes in memory. On Proliant x86[_64]
> systems the top page of memory is mapped out and the io hole below 4GB is
> similiarly protected because the memory at the lower boundary of the hole 
> is used by ACPI and other things.
> Please consider this for inclusion.
> 
> Thanks,
> mikem
> 
> Signed-off-by: Mike Miller <mike.miller@hp.com>
> 
>  cciss.c     |   14 ++++++++++++++
>  cciss_cmd.h |    1 +
>  2 files changed, 15 insertions(+)
> --------------------------------------------------------------------------------
> diff -urNp linux-2.6-p00004/drivers/block/cciss.c linux-2.6/drivers/block/cciss.c
> --- linux-2.6-p00004/drivers/block/cciss.c	2006-10-31 15:20:25.000000000 -0600
> +++ linux-2.6/drivers/block/cciss.c	2006-10-31 15:42:59.000000000 -0600
> @@ -2997,6 +2997,20 @@ static int cciss_pci_init(ctlr_info_t *c
>  	}
>  #endif
>  
> +#ifdef CONFIG_IA64
> +	{
> +		/* DMA prefetch must be disabled on P600 on platforms that may
> +		 * present noncontiguous memory.
> +		 */
> +		__u32 dma_prefetch
> +		if(board_id == 0x3225103C) {
> +			dma_prefetch = readl(c->vaddr + I2O_DMA1_CFG);
> +			dma_prefetch |= 0x8000;
> +			writel(dma_prefetch, c->vaddr + I2O_DMA1_CFG);
> +		}
> +	}
> +#endif /* CONFIG_IA64 */

Hmm, what about other platforms with discontig memory support?

-- 
Jens Axboe

