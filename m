From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2] scsi: advansys needs ISA dma api for ISA support
Date: Fri, 16 Oct 2015 06:53:44 -0700
Message-ID: <1445003624.2191.2.camel@HansenPartnership.com>
References: <4351271.eUtUWpTn54@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4351271.eUtUWpTn54@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2015-10-16 at 14:13 +0200, Arnd Bergmann wrote:
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
> This adds a dependency to only build the driver on ISA based machines
> if they also support ISA_DMA_API, or if they EISA or PCI are also
> enabled.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index d2f480b04a52..1d8b8257773d 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -498,7 +498,7 @@ config SCSI_DPT_I2O
>  config SCSI_ADVANSYS
>  	tristate "AdvanSys SCSI support"
>  	depends on SCSI
> -	depends on ISA || EISA || PCI
> +	depends on (ISA && ISA_DMA_API) || EISA || PCI

I thought the desire was to avoid a compile failure when ISA && !
ISA_DMA_API?  Won't this one fail if ISA is defined with either EISA or
PCI and !ISA_DMA_API?

James
