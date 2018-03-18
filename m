From: Boris Brezillon <boris.brezillon@bootlin.com>
Subject: Re: [PATCH v2 14/21] mtd: Remove depends on HAS_DMA in case of
 platform dependency
Date: Sun, 18 Mar 2018 23:04:10 +0100
Message-ID: <20180318230410.382f69a1@bbrezillon>
References: <1521208314-4783-1-git-send-email-geert@linux-m68k.org>
 <1521208314-4783-15-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1521208314-4783-15-git-send-email-geert@linux-m68k.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Wolfram Sang <wsa@the-dreams.de>, linux-iio@vger.kernel.org, linux-fpga@vger.kernel.org, linux-remoteproc@vger.kernel.org, alsa-devel@alsa-project.org, Bjorn Andersson <bjorn.andersson@linaro.org>, Eric Anholt <eric@anholt.net>, netdev@vger.kernel.org, linux-mtd@lists.infradead.org, linux-i2c@vger.kernel.org, linux1394-devel@lists.sourceforge.net, Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>, Stefan Wahren <stefan.wahren@i2se.com>, Boris Brezillon <boris.brezillon@free-electrons.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Herbert Xu <herbert@gondor.apana.org.au>, linux-scsi@vger.kernel.org, Richard Weinberger <richard@nod.at>, Joerg Roedel <joro@8bytes.org>, Jassi Brar <jassisinghbrar@gmail.com>, Marek Vasut <marek.vasut@gmail.com>, linux-serial@vger.kernel.org, Matias Bjorling <mb@lightn>
List-Id: linux-scsi@vger.kernel.org

Hi Geert,

On Fri, 16 Mar 2018 14:51:47 +0100
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> Remove dependencies on HAS_DMA where a Kconfig symbol depends on another
> symbol that implies HAS_DMA, and, optionally, on "|| COMPILE_TEST".
> In most cases this other symbol is an architecture or platform specific
> symbol, or PCI.
> 
> Generic symbols and drivers without platform dependencies keep their
> dependencies on HAS_DMA, to prevent compiling subsystems or drivers that
> cannot work anyway.
> 
> This simplifies the dependencies, and allows to improve compile-testing.
> 

Don't know which release you're targeting but it's likely to conflict
with the change I have in my nand/next branch. Is this a problem if I
take this patch through the mtd tree after [1] has reached Linus' tree?

Regards,

Boris

[1]https://lkml.org/lkml/2018/3/16/435

> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Acked-by: Robin Murphy <robin.murphy@arm.com>
> ---
> v2:
>   - Add Reviewed-by, Acked-by,
>   - Drop RFC state,
>   - Drop new dependency of MTD_NAND_MARVELL on HAS_DMA,
>   - Split per subsystem.
> ---
>  drivers/mtd/nand/Kconfig    | 8 ++------
>  drivers/mtd/spi-nor/Kconfig | 2 +-
>  2 files changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
> index 736ac887303c88ba..55a2f8a2fa90cd87 100644
> --- a/drivers/mtd/nand/Kconfig
> +++ b/drivers/mtd/nand/Kconfig
> @@ -46,7 +46,7 @@ config MTD_NAND_DENALI
>  config MTD_NAND_DENALI_PCI
>          tristate "Support Denali NAND controller on Intel Moorestown"
>  	select MTD_NAND_DENALI
> -	depends on HAS_DMA && PCI
> +	depends on PCI
>          help
>            Enable the driver for NAND flash on Intel Moorestown, using the
>            Denali NAND controller core.
> @@ -184,7 +184,6 @@ config MTD_NAND_S3C2410_CLKSTOP
>  config MTD_NAND_TANGO
>  	tristate "NAND Flash support for Tango chips"
>  	depends on ARCH_TANGO || COMPILE_TEST
> -	depends on HAS_DMA
>  	help
>  	  Enables the NAND Flash controller on Tango chips.
>  
> @@ -328,7 +327,7 @@ config MTD_NAND_MARVELL
>  	tristate "NAND controller support on Marvell boards"
>  	depends on PXA3xx || ARCH_MMP || PLAT_ORION || ARCH_MVEBU || \
>  		   COMPILE_TEST
> -	depends on HAS_IOMEM && HAS_DMA
> +	depends on HAS_IOMEM
>  	help
>  	  This enables the NAND flash controller driver for Marvell boards,
>  	  including:
> @@ -490,7 +489,6 @@ config MTD_NAND_SH_FLCTL
>  	tristate "Support for NAND on Renesas SuperH FLCTL"
>  	depends on SUPERH || COMPILE_TEST
>  	depends on HAS_IOMEM
> -	depends on HAS_DMA
>  	help
>  	  Several Renesas SuperH CPU has FLCTL. This option enables support
>  	  for NAND Flash using FLCTL.
> @@ -558,7 +556,6 @@ config MTD_NAND_SUNXI
>  config MTD_NAND_HISI504
>  	tristate "Support for NAND controller on Hisilicon SoC Hip04"
>  	depends on ARCH_HISI || COMPILE_TEST
> -	depends on HAS_DMA
>  	help
>  	  Enables support for NAND controller on Hisilicon SoC Hip04.
>  
> @@ -572,7 +569,6 @@ config MTD_NAND_QCOM
>  config MTD_NAND_MTK
>  	tristate "Support for NAND controller on MTK SoCs"
>  	depends on ARCH_MEDIATEK || COMPILE_TEST
> -	depends on HAS_DMA
>  	help
>  	  Enables support for NAND controller on MTK SoCs.
>  	  This controller is found on mt27xx, mt81xx, mt65xx SoCs.
> diff --git a/drivers/mtd/spi-nor/Kconfig b/drivers/mtd/spi-nor/Kconfig
> index 89da88e591215db1..c493b8230a38c059 100644
> --- a/drivers/mtd/spi-nor/Kconfig
> +++ b/drivers/mtd/spi-nor/Kconfig
> @@ -71,7 +71,7 @@ config SPI_FSL_QUADSPI
>  config SPI_HISI_SFC
>  	tristate "Hisilicon SPI-NOR Flash Controller(SFC)"
>  	depends on ARCH_HISI || COMPILE_TEST
> -	depends on HAS_IOMEM && HAS_DMA
> +	depends on HAS_IOMEM
>  	help
>  	  This enables support for hisilicon SPI-NOR flash controller.
>  



-- 
Boris Brezillon, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com
