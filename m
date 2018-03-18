From: =?UTF-8?Q?Matias_Bj=c3=b8rling?= <mb@lightnvm.io>
Subject: Re: [PATCH v2 10/21] lightnvm: Remove depends on HAS_DMA in case of
 platform dependency
Date: Sun, 18 Mar 2018 19:46:11 +0100
Message-ID: <319a2b17-f08e-7219-cf5d-08e2df81d55c@lightnvm.io>
References: <1521208314-4783-1-git-send-email-geert@linux-m68k.org>
 <1521208314-4783-11-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521208314-4783-11-git-send-email-geert@linux-m68k.org>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>, Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Felipe Balbi <balbi@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>, Tejun Heo <tj@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Alan Tull <atull@kernel.org>, Moritz Fischer <mdf@kernel.org>, Wolfram Sang <wsa@the-dreams.de>
Cc: iommu@lists.linux-foundation.org, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, alsa-devel@alsa-project.org, linux-ide@vger.kernel.org, linux-crypto@vger.kernel.org, linux-fbdev@vger.kernel.org, linux1394-devel@lists.sourceforge.net, linux-fpga@vger.kernel.org, linux-i2c@vger.kernel.org, linux-iio@vger.kernel.org, linux-block@vger.kernel.org, linux-media@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org, netdev@vger.kernel.org, linux-remoteproc@vger.kernel.org, linux-serial@vger.kernel.org, linux-spi@vger.kernel.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 03/16/2018 02:51 PM, Geert Uytterhoeven wrote:
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
> Notes:
>    - FSL_FMAN keeps its dependency on HAS_DMA, as it calls set_dma_ops(),
>      which does not exist if HAS_DMA=n (Do we need a dummy? The use of
>      set_dma_ops() in this driver is questionable),
>    - SND_SOC_LPASS_IPQ806X and SND_SOC_LPASS_PLATFORM loose their
>      dependency on HAS_DMA, as they are selected from
>      SND_SOC_APQ8016_SBC.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Acked-by: Robin Murphy <robin.murphy@arm.com>
> ---
> v2:
>    - Add Reviewed-by, Acked-by,
>    - Drop RFC state,
>    - Split per subsystem.
> ---
>   drivers/lightnvm/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/lightnvm/Kconfig b/drivers/lightnvm/Kconfig
> index 10c08982185a572f..9c03f35d9df113c6 100644
> --- a/drivers/lightnvm/Kconfig
> +++ b/drivers/lightnvm/Kconfig
> @@ -4,7 +4,7 @@
>   
>   menuconfig NVM
>   	bool "Open-Channel SSD target support"
> -	depends on BLOCK && HAS_DMA && PCI
> +	depends on BLOCK && PCI
>   	select BLK_DEV_NVME
>   	help
>   	  Say Y here to get to enable Open-channel SSDs.
> 

Looks good.

Reviewed-by: Matias Bjørling <mb@lightnvm.io>
