From: Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH v2 08/21] iio: adc: Remove depends on HAS_DMA in case of
 platform dependency
Date: Sat, 17 Mar 2018 16:42:41 +0000
Message-ID: <20180317164241.6fbad835@archlinux>
References: <1521208314-4783-1-git-send-email-geert@linux-m68k.org>
 <1521208314-4783-9-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1521208314-4783-9-git-send-email-geert@linux-m68k.org>
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

On Fri, 16 Mar 2018 14:51:41 +0100
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
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Acked-by: Robin Murphy <robin.murphy@arm.com>
Great.
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

Thanks for doing this - this has been annoying for a long time :)

> ---
> v2:
>   - Add Reviewed-by, Acked-by,
>   - Drop RFC state,
>   - Split per subsystem.
> ---
>  drivers/iio/adc/Kconfig | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
> index 72bc2b71765ae2ff..57f46e88f5c2536e 100644
> --- a/drivers/iio/adc/Kconfig
> +++ b/drivers/iio/adc/Kconfig
> @@ -158,7 +158,6 @@ config AT91_SAMA5D2_ADC
>  	tristate "Atmel AT91 SAMA5D2 ADC"
>  	depends on ARCH_AT91 || COMPILE_TEST
>  	depends on HAS_IOMEM
> -	depends on HAS_DMA
>  	select IIO_TRIGGERED_BUFFER
>  	help
>  	  Say yes here to build support for Atmel SAMA5D2 ADC which is
> @@ -647,7 +646,6 @@ config SD_ADC_MODULATOR
>  config STM32_ADC_CORE
>  	tristate "STMicroelectronics STM32 adc core"
>  	depends on ARCH_STM32 || COMPILE_TEST
> -	depends on HAS_DMA
>  	depends on OF
>  	depends on REGULATOR
>  	select IIO_BUFFER
