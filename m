From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: advansys needs ISA dma api for ISA support
Date: Mon, 12 Oct 2015 08:28:01 -0700
Message-ID: <1444663681.2205.14.camel@HansenPartnership.com>
References: <5081546.QjQ32dGX2L@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5081546.QjQ32dGX2L@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2015-10-12 at 17:10 +0200, Arnd Bergmann wrote:
> The advansys drvier uses the request_dma function that is used on ISA
> machines for the internal DMA controller, which causes build errors
> on platforms that have ISA slots but do not provide the ISA DMA API:
> 
> drivers/scsi/advansys.c: In function 'advansys_board_found':
> drivers/scsi/advansys.c:11300:10: error: implicit declaration of function 'request_dma' [-Werror=implicit-function-declaration]
> 
> The problem now showed up in ARM randconfig builds after commit
> 6571fb3f8b7f ("advansys: Update to version 3.5 and remove compilation
> warning") made it possible to build on platforms that have neither
> VIRT_TO_BUS nor ISA_DMA_API but that do have ISA.
> 
> This adds the missing dependency.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index d2f480b04a52..d4aa6a1a806c 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -499,6 +499,7 @@ config SCSI_ADVANSYS
>  	tristate "AdvanSys SCSI support"
>  	depends on SCSI
>  	depends on ISA || EISA || PCI
> +	depends on ISA_DMA_API || !ISA
>  	help
>  	  This is a driver for all SCSI host adapters manufactured by
>  	  AdvanSys. It is documented in the kernel source in

This fix looks wrong.  the request_dma code is confined within an #ifdef
CONFIG_ISA section but the advansys doesn't actually require an ISA DMA
channel to function, so you're saying there are systems with ISA but
without request_dma()?

If so I think we leave the depends alone and try to bring the board up
in NO_ISA_DMA mode.  That means the narrowboard check should be gated by
CONFIG_ISA_DMA_API ... do we also have to gate free_dma as well?

James
