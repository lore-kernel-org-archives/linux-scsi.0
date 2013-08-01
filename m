From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH RFC 00/51] Preview of DMA mask changes
Date: Thu, 1 Aug 2013 22:34:20 +0100
Message-ID: <20130801213420.GL23006@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org
Cc: Jens Axboe <axboe@kernel.dk>, Nicolas Pitre <nicolas.pitre@linaro.org>, linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Chris Ball <cjb@laptop.org>
List-Id: linux-scsi@vger.kernel.org

So, this patch set is a preview of the DMA mask changes which I currently
have in my tree.

This started out as a request to look at the DMA mask situation, and how
to solve the issues which we have on ARM.  One of those issues is how to
deal with the DT side of things, which I haven't yet addressed.

However, I started off reviewing how the dma_mask and coherent_dma_mask
was being used, and what I found was rather messy, and in some cases
rather buggy.  I tried to get some of the bug fixes in before the last
merge window, but it seems that the maintainers preferred to have the
full solution rather than a simple -rc suitable bug fix.

So, this is an attempt to clean things up.

The first point here is that drivers performing DMA should be calling
dma_set_mask()/dma_set_coherent_mask() in their probe function to verify
that DMA can be performed.  Lots of ARM drivers omit this step; please
refer to the DMA API documentation on this subject.

What this means is that the DMA mask provided by bus code is a default
value - nothing more.  It doesn't have to accurately reflect what the
device is actually capable of.  Apart from the storage for dev->dma_mask
being initialised for any device which is DMA capable, there is no other
initialisation which is strictly necessary at device creation time.

Now, these cleanups address two major areas:
1. The setting of DMA masks, particularly when both the coherent and
   streaming DMA masks are set together.

2. The initialisation of DMA masks by drivers - this seems to be becoming
   a popular habbit, one which may not be entirely the right solution.
   Rather than having this scattered throughout the tree, I've pulled
   that into a central location (and called it coercing the DMA mask -
   because it really is about forcing the DMA mask to be that value.)

3. Finally, addressing the long held misbelief that DMA masks somehow
   correspond with physical addresses.  We already have established
   long ago that dma_addr_t values returned from the DMA API are the
   values which you program into the DMA controller, and so are the
   bus addresses.  It is _only_ sane that DMA masks are also bus
   related too, and not related to physical address spaces.

(3) is a very important point for LPAE systems, which may still have
less than 4GB of memory, but this memory is all located above the 4GB
physical boundary.  This means with the current model, any device
using a 32-bit DMA mask fails - even though the DMA controller is
still only a 32-bit DMA controller but the 32-bit bus addresses map
to system memory.  To put it another way, the bus addresses have a
4GB physical offset on them.

This work is ongoing, and I'm still fixing the odd bug which the nightly
autobuilder randconfigs find (when it doesn't hit some other problem.)

I'm not using get_maintainer.pl for this series yet, because the list
of recipients is gigantic and would not pass through vger's filters,
let alone other mailing lists.  So this initial posting will only be
sent to those listed explicitly in Cc:'s in the patches, linux-kernel
and linux-arm-kernel... and it will take about an hour to send all
these patches out.

Patches based on -rc2.

 Documentation/DMA-API-HOWTO.txt                   |   37 +++++++++------
 Documentation/DMA-API.txt                         |    8 +++
 arch/arm/include/asm/dma-mapping.h                |    8 +++
 arch/arm/mm/dma-mapping.c                         |   49 ++++++++++++++++++--
 arch/arm/mm/init.c                                |   12 +++---
 arch/arm/mm/mm.h                                  |    2 +
 arch/powerpc/kernel/vio.c                         |    3 +-
 block/blk-settings.c                              |    8 ++--
 drivers/amba/bus.c                                |    6 +--
 drivers/ata/pata_ixp4xx_cf.c                      |    5 ++-
 drivers/ata/pata_octeon_cf.c                      |    5 +-
 drivers/block/nvme-core.c                         |    7 +--
 drivers/crypto/ixp4xx_crypto.c                    |   48 ++++++++++----------
 drivers/dma/amba-pl08x.c                          |    5 ++
 drivers/dma/dw/platform.c                         |    8 +--
 drivers/dma/edma.c                                |    6 +--
 drivers/dma/pl330.c                               |    4 ++
 drivers/firmware/dcdbas.c                         |   23 +++++-----
 drivers/firmware/google/gsmi.c                    |   13 +++--
 drivers/gpu/drm/exynos/exynos_drm_drv.c           |    7 +++-
 drivers/gpu/drm/omapdrm/omap_dmm_tiler.c          |    5 +-
 drivers/media/platform/omap3isp/isp.c             |    6 +-
 drivers/media/platform/omap3isp/isp.h             |    3 -
 drivers/mmc/card/queue.c                          |    3 +-
 drivers/mmc/host/sdhci-acpi.c                     |    5 +-
 drivers/net/ethernet/broadcom/b44.c               |    3 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c  |    8 +---
 drivers/net/ethernet/brocade/bna/bnad.c           |   13 ++----
 drivers/net/ethernet/emulex/benet/be_main.c       |   12 +----
 drivers/net/ethernet/intel/e1000/e1000_main.c     |    9 +---
 drivers/net/ethernet/intel/e1000e/netdev.c        |   18 +++-----
 drivers/net/ethernet/intel/igb/igb_main.c         |   18 +++-----
 drivers/net/ethernet/intel/igbvf/netdev.c         |   18 +++-----
 drivers/net/ethernet/intel/ixgb/ixgb_main.c       |   16 ++-----
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c     |   15 ++----
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |   15 ++----
 drivers/net/ethernet/nxp/lpc_eth.c                |    6 ++-
 drivers/net/ethernet/octeon/octeon_mgmt.c         |    5 +-
 drivers/net/ethernet/sfc/efx.c                    |   12 +-----
 drivers/net/wireless/b43/dma.c                    |    9 +---
 drivers/net/wireless/b43legacy/dma.c              |    9 +---
 drivers/of/platform.c                             |    3 -
 drivers/parport/parport_pc.c                      |    8 +++-
 drivers/scsi/scsi_lib.c                           |    2 +-
 drivers/staging/dwc2/platform.c                   |    5 +-
 drivers/staging/et131x/et131x.c                   |   17 +------
 drivers/staging/imx-drm/imx-drm-core.c            |    8 +++-
 drivers/staging/imx-drm/ipuv3-crtc.c              |    4 +-
 drivers/staging/media/dt3155v4l/dt3155v4l.c       |    5 +--
 drivers/usb/chipidea/ci_hdrc_imx.c                |    7 +--
 drivers/usb/dwc3/dwc3-exynos.c                    |    7 +--
 drivers/usb/gadget/lpc32xx_udc.c                  |    4 +-
 drivers/usb/host/bcma-hcd.c                       |    3 +-
 drivers/usb/host/ehci-atmel.c                     |    7 +--
 drivers/usb/host/ehci-octeon.c                    |    4 +-
 drivers/usb/host/ehci-omap.c                      |   10 ++--
 drivers/usb/host/ehci-orion.c                     |    7 +--
 drivers/usb/host/ehci-platform.c                  |   10 ++--
 drivers/usb/host/ehci-s5p.c                       |    7 +--
 drivers/usb/host/ehci-spear.c                     |    7 +--
 drivers/usb/host/ehci-tegra.c                     |    7 +--
 drivers/usb/host/ohci-at91.c                      |    9 ++--
 drivers/usb/host/ohci-exynos.c                    |    7 +--
 drivers/usb/host/ohci-nxp.c                       |    5 +-
 drivers/usb/host/ohci-octeon.c                    |    5 +-
 drivers/usb/host/ohci-omap3.c                     |   10 ++--
 drivers/usb/host/ohci-pxa27x.c                    |    8 ++--
 drivers/usb/host/ohci-sa1111.c                    |    6 +++
 drivers/usb/host/ohci-spear.c                     |    7 +--
 drivers/usb/host/ssb-hcd.c                        |    3 +-
 drivers/usb/host/uhci-platform.c                  |    7 +--
 drivers/usb/musb/am35x.c                          |   50 +++++++--------------
 drivers/usb/musb/da8xx.c                          |   49 +++++++-------------
 drivers/usb/musb/davinci.c                        |   48 +++++++-------------
 drivers/usb/musb/tusb6010.c                       |   49 +++++++-------------
 drivers/video/amba-clcd.c                         |    5 ++
 include/linux/amba/bus.h                          |    2 -
 include/linux/dma-mapping.h                       |   31 +++++++++++++
 sound/arm/pxa2xx-pcm.c                            |    9 +---
 sound/soc/atmel/atmel-pcm.c                       |   11 ++---
 sound/soc/blackfin/bf5xx-ac97-pcm.c               |   11 ++---
 sound/soc/blackfin/bf5xx-i2s-pcm.c                |   10 ++---
 sound/soc/davinci/davinci-pcm.c                   |    9 +---
 sound/soc/fsl/fsl_dma.c                           |    9 +---
 sound/soc/fsl/mpc5200_dma.c                       |   10 ++---
 sound/soc/jz4740/jz4740-pcm.c                     |   12 ++---
 sound/soc/kirkwood/kirkwood-dma.c                 |    9 +---
 sound/soc/nuc900/nuc900-pcm.c                     |    9 ++--
 sound/soc/omap/omap-pcm.c                         |   11 ++---
 sound/soc/pxa/pxa2xx-pcm.c                        |   11 ++---
 sound/soc/s6000/s6000-pcm.c                       |    9 +---
 sound/soc/samsung/dma.c                           |   11 ++---
 sound/soc/samsung/idma.c                          |   11 ++---
 93 files changed, 492 insertions(+), 565 deletions(-)
