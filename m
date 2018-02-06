From: Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH/RFC 0/6] Allow compile-testing NO_DMA
Date: Tue, 6 Feb 2018 13:05:44 +0000
Message-ID: <c68d8b8b-dc46-2066-0341-558f57ad113f@arm.com>
References: <1517912092-15470-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1517912092-15470-1-git-send-email-geert@linux-m68k.org>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>, Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>, Arnd Bergmann <arnd@arndb.de>, Mark Brown <broonie@kernel.org>, Richard Weinberger <richard@nod.at>
Cc: Felipe Balbi <balbi@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, iommu@lists.linux-foundation.org, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/02/18 10:14, Geert Uytterhoeven wrote:
> 	Hi all,
> 
> If NO_DMA=y, get_dma_ops() returns a reference to the non-existing
> symbol bad_dma_ops, thus causing a link failure if it is ever used.
> 
> The intention of this is twofold:
>    1. To catch users of the DMA API on systems that do no support the DMA
>       mapping API,
>    2. To avoid building drivers that cannot work on such systems anyway.
> 
> However, the disadvantage is that we have to keep on adding dependencies
> on HAS_DMA all over the place.
> 
> Thanks to the COMPILE_TEST symbol, lots of drivers now depend on one or
> more platform dependencies (that imply HAS_DMA) || COMPILE_TEST, thus
> already covering intention #2.  Having to add an explicit dependency on
> HAS_DMA here is cumbersome, and hinders compile-testing.
> 
> Hence I think the time is ripe to reconsider the link failure.
> This patch series:
>    - Changes get_dma_ops() to return NULL instead,
>    - Adds a few more dummies to enable compile-testing,
>    - Removes dependencies on HAS_DMA for symbols that already have
>      platform dependencies implying HAS_DMA.
> 
> Note that adding more platform dependencies and/or dependencies on
> COMPILE_TEST is encouraged!
> 
> This may make life harder for UML, though, as UML usually satisfies all
> other platform dependencies for HAS_DMA.  Similarly, HAS_IOMEM is even
> more complicated.  Can/do we want to do something similar for
> HAS_IOMEM?

It looks like we have only one real arch (score) without IOMEM, and two 
(s390 and tile) where it is possible to configure out, so it does seem 
like a reasonable feature to assume. Maybe we could have something like 
asm-generic/no-io.h to provide an "unimplemented" version of those 
interfaces.

Anyway, for this series:

Acked-by: Robin Murphy <robin.murphy@arm.com>

Thanks,
Robin.

> This series is against my current local tree, which has a few more
> "depends on HAS_DMA" than upstream.  Of course I will rebase, and split
> the last patch per subsystem, if this RFC is welcomed positively.
> 
> Compile-tested with allmodconfig and allyesconfig for m68k/sun3.
> 
> Thanks for your comments!
> 
> Geert Uytterhoeven (6):
>    [RFC] dma-mapping: Convert NO_DMA get_dma_ops() into a real dummy
>    [RFC] dma-coherent: Add NO_DMA dummies for managed DMA API
>    [RFC] usb: gadget: Add NO_DMA dummies for DMA mapping API
>    [RFC] mm: Add NO_DMA dummies for DMA pool API
>    [RFC] scsi: Add NO_DMA dummies for SCSI DMA mapping API
>    [RFC] Treewide: Remove depends on HAS_DMA in case of platform
>      dependency
> 
>   drivers/ata/Kconfig                             |  2 --
>   drivers/crypto/Kconfig                          | 14 +++------
>   drivers/firewire/Kconfig                        |  1 -
>   drivers/fpga/Kconfig                            |  1 -
>   drivers/gpu/ipu-v3/Kconfig                      |  1 -
>   drivers/i2c/busses/Kconfig                      |  3 --
>   drivers/iio/adc/Kconfig                         |  3 --
>   drivers/iommu/Kconfig                           |  5 ++--
>   drivers/lightnvm/Kconfig                        |  2 +-
>   drivers/mailbox/Kconfig                         |  2 --
>   drivers/media/pci/dt3155/Kconfig                |  1 -
>   drivers/media/pci/solo6x10/Kconfig              |  1 -
>   drivers/media/pci/sta2x11/Kconfig               |  1 -
>   drivers/media/pci/tw5864/Kconfig                |  1 -
>   drivers/media/pci/tw686x/Kconfig                |  1 -
>   drivers/media/platform/Kconfig                  | 40 ++++++++-----------------
>   drivers/media/platform/am437x/Kconfig           |  2 +-
>   drivers/media/platform/atmel/Kconfig            |  4 +--
>   drivers/media/platform/blackfin/Kconfig         |  1 -
>   drivers/media/platform/davinci/Kconfig          |  6 ----
>   drivers/media/platform/marvell-ccic/Kconfig     |  3 +-
>   drivers/media/platform/rcar-vin/Kconfig         |  2 +-
>   drivers/media/platform/soc_camera/Kconfig       |  3 +-
>   drivers/media/platform/sti/c8sectpfe/Kconfig    |  2 +-
>   drivers/mmc/host/Kconfig                        | 10 ++-----
>   drivers/mtd/nand/Kconfig                        |  8 ++---
>   drivers/mtd/spi-nor/Kconfig                     |  2 +-
>   drivers/net/ethernet/amd/Kconfig                |  2 +-
>   drivers/net/ethernet/apm/xgene-v2/Kconfig       |  1 -
>   drivers/net/ethernet/apm/xgene/Kconfig          |  1 -
>   drivers/net/ethernet/arc/Kconfig                |  6 ++--
>   drivers/net/ethernet/broadcom/Kconfig           |  2 --
>   drivers/net/ethernet/calxeda/Kconfig            |  2 +-
>   drivers/net/ethernet/hisilicon/Kconfig          |  2 +-
>   drivers/net/ethernet/marvell/Kconfig            |  8 ++---
>   drivers/net/ethernet/mellanox/mlxsw/Kconfig     |  2 +-
>   drivers/net/ethernet/renesas/Kconfig            |  2 --
>   drivers/net/ethernet/socionext/Kconfig          |  4 +--
>   drivers/net/wireless/broadcom/brcm80211/Kconfig |  1 -
>   drivers/net/wireless/quantenna/qtnfmac/Kconfig  |  2 +-
>   drivers/remoteproc/Kconfig                      |  1 -
>   drivers/scsi/hisi_sas/Kconfig                   |  2 +-
>   drivers/spi/Kconfig                             | 12 ++------
>   drivers/staging/media/davinci_vpfe/Kconfig      |  1 -
>   drivers/staging/media/omap4iss/Kconfig          |  1 -
>   drivers/staging/vc04_services/Kconfig           |  1 -
>   drivers/tty/serial/Kconfig                      |  4 ---
>   drivers/usb/gadget/udc/Kconfig                  |  4 +--
>   drivers/usb/mtu3/Kconfig                        |  2 +-
>   drivers/video/fbdev/Kconfig                     |  3 +-
>   include/linux/dma-mapping.h                     | 19 ++++++++----
>   include/linux/dmapool.h                         | 21 +++++++++++--
>   include/linux/usb/gadget.h                      | 12 ++++++++
>   include/scsi/scsi_cmnd.h                        |  5 ++++
>   sound/soc/bcm/Kconfig                           |  3 +-
>   sound/soc/kirkwood/Kconfig                      |  1 -
>   sound/soc/pxa/Kconfig                           |  1 -
>   sound/soc/qcom/Kconfig                          |  6 ++--
>   58 files changed, 108 insertions(+), 148 deletions(-)
> 
