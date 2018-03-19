From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v2 06/21] fpga: Remove depends on HAS_DMA in case of
 platform dependency
Date: Mon, 19 Mar 2018 11:06:29 -0500
Message-ID: <CANk1AXR3sv2=G-KsQh1p0rdcvy-3XZs6qVy5EMbcAMS6OSVzeQ@mail.gmail.com>
References: <1521208314-4783-1-git-send-email-geert@linux-m68k.org>
 <1521208314-4783-7-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1521208314-4783-7-git-send-email-geert@linux-m68k.org>
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

On Fri, Mar 16, 2018 at 8:51 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:

Hi Geert,

This essentially removes this commit

commit 1c8cb409491403036919dd1c6b45013dc8835a44
Author: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Wed Aug 3 13:45:46 2016 -0700

    drivers/fpga/Kconfig: fix build failure

    While building m32r allmodconfig the build is failing with the error:

      ERROR: "bad_dma_ops" [drivers/fpga/zynq-fpga.ko] undefined!

    Xilinx Zynq FPGA is using DMA but there was no dependency while
    building.

    Link: http://lkml.kernel.org/r/1464346526-13913-1-git-send-email-sudipm.mukherjee@gmail.com
    Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
    Acked-by: Moritz Fischer <moritz.fischer@ettus.com>
    Cc: Alan Tull <atull@opensource.altera.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Alan

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
> ---
> v2:
>   - Add Reviewed-by, Acked-by,
>   - Drop RFC state,
>   - Split per subsystem.
> ---
>  drivers/fpga/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
> index f47ef848bcd056d5..fd539132542e30ee 100644
> --- a/drivers/fpga/Kconfig
> +++ b/drivers/fpga/Kconfig
> @@ -53,7 +53,6 @@ config FPGA_MGR_ALTERA_CVP
>  config FPGA_MGR_ZYNQ_FPGA
>         tristate "Xilinx Zynq FPGA"
>         depends on ARCH_ZYNQ || COMPILE_TEST
> -       depends on HAS_DMA
>         help
>           FPGA manager driver support for Xilinx Zynq FPGAs.
>
> --
> 2.7.4
>
