From: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Subject: [PATCH/RFC 6/6] Treewide: Remove depends on HAS_DMA in case of
	platform dependency
Date: Tue,  6 Feb 2018 11:14:52 +0100
Message-ID: <1517912092-15470-7-git-send-email-geert@linux-m68k.org>
References: <1517912092-15470-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1517912092-15470-1-git-send-email-geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Cc: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Felipe Balbi <balbi-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "James E . J . Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Martin K . Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Remove dependencies on HAS_DMA where a Kconfig symbol depends on another
symbol that implies HAS_DMA, and, optionally, on "|| COMPILE_TEST".
In most cases this other symbol is an architecture or platform specific
symbol, or PCI.

Generic symbols and drivers without platform dependencies keep their
dependencies on HAS_DMA, to prevent compiling subsystems or drivers that
cannot work anyway.

This simplifies the dependencies, and allows to improve compile-testing.

Notes:
  - FSL_FMAN keeps its dependency on HAS_DMA, as it calls set_dma_ops(),
    which does not exist if HAS_DMA=n (Do we need a dummy? The use of
    set_dma_ops() in this driver is questionable),
  - SND_SOC_LPASS_IPQ806X and SND_SOC_LPASS_PLATFORM loose their
    dependency on HAS_DMA, as they are selected from
    SND_SOC_APQ8016_SBC.

Signed-off-by: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
---
 drivers/ata/Kconfig                             |  2 --
 drivers/crypto/Kconfig                          | 14 +++------
 drivers/firewire/Kconfig                        |  1 -
 drivers/fpga/Kconfig                            |  1 -
 drivers/gpu/ipu-v3/Kconfig                      |  1 -
 drivers/i2c/busses/Kconfig                      |  3 --
 drivers/iio/adc/Kconfig                         |  3 --
 drivers/iommu/Kconfig                           |  5 ++--
 drivers/lightnvm/Kconfig                        |  2 +-
 drivers/mailbox/Kconfig                         |  2 --
 drivers/media/pci/dt3155/Kconfig                |  1 -
 drivers/media/pci/solo6x10/Kconfig              |  1 -
 drivers/media/pci/sta2x11/Kconfig               |  1 -
 drivers/media/pci/tw5864/Kconfig                |  1 -
 drivers/media/pci/tw686x/Kconfig                |  1 -
 drivers/media/platform/Kconfig                  | 40 ++++++++-----------------
 drivers/media/platform/am437x/Kconfig           |  2 +-
 drivers/media/platform/atmel/Kconfig            |  4 +--
 drivers/media/platform/blackfin/Kconfig         |  1 -
 drivers/media/platform/davinci/Kconfig          |  6 ----
 drivers/media/platform/marvell-ccic/Kconfig     |  3 +-
 drivers/media/platform/rcar-vin/Kconfig         |  2 +-
 drivers/media/platform/soc_camera/Kconfig       |  3 +-
 drivers/media/platform/sti/c8sectpfe/Kconfig    |  2 +-
 drivers/mmc/host/Kconfig                        | 10 ++-----
 drivers/mtd/nand/Kconfig                        |  8 ++---
 drivers/mtd/spi-nor/Kconfig                     |  2 +-
 drivers/net/ethernet/amd/Kconfig                |  2 +-
 drivers/net/ethernet/apm/xgene-v2/Kconfig       |  1 -
 drivers/net/ethernet/apm/xgene/Kconfig          |  1 -
 drivers/net/ethernet/arc/Kconfig                |  6 ++--
 drivers/net/ethernet/broadcom/Kconfig           |  2 --
 drivers/net/ethernet/calxeda/Kconfig            |  2 +-
 drivers/net/ethernet/hisilicon/Kconfig          |  2 +-
 drivers/net/ethernet/marvell/Kconfig            |  8 ++---
 drivers/net/ethernet/mellanox/mlxsw/Kconfig     |  2 +-
 drivers/net/ethernet/renesas/Kconfig            |  2 --
 drivers/net/ethernet/socionext/Kconfig          |  4 +--
 drivers/net/wireless/broadcom/brcm80211/Kconfig |  1 -
 drivers/net/wireless/quantenna/qtnfmac/Kconfig  |  2 +-
 drivers/remoteproc/Kconfig                      |  1 -
 drivers/scsi/hisi_sas/Kconfig                   |  2 +-
 drivers/spi/Kconfig                             | 12 ++------
 drivers/staging/media/davinci_vpfe/Kconfig      |  1 -
 drivers/staging/media/omap4iss/Kconfig          |  1 -
 drivers/staging/vc04_services/Kconfig           |  1 -
 drivers/tty/serial/Kconfig                      |  4 ---
 drivers/usb/gadget/udc/Kconfig                  |  4 +--
 drivers/usb/mtu3/Kconfig                        |  2 +-
 drivers/video/fbdev/Kconfig                     |  3 +-
 sound/soc/bcm/Kconfig                           |  3 +-
 sound/soc/kirkwood/Kconfig                      |  1 -
 sound/soc/pxa/Kconfig                           |  1 -
 sound/soc/qcom/Kconfig                          |  6 ++--
 54 files changed, 58 insertions(+), 141 deletions(-)

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index a7120d6211546949..9eaeed1fb237fa33 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -398,7 +398,6 @@ config SATA_DWC_VDEBUG
 
 config SATA_HIGHBANK
 	tristate "Calxeda Highbank SATA support"
-	depends on HAS_DMA
 	depends on ARCH_HIGHBANK || COMPILE_TEST
 	help
 	  This option enables support for the Calxeda Highbank SoC's
@@ -408,7 +407,6 @@ config SATA_HIGHBANK
 
 config SATA_MV
 	tristate "Marvell SATA support"
-	depends on HAS_DMA
 	depends on PCI || ARCH_DOVE || ARCH_MV78XX0 || \
 		   ARCH_MVEBU || ARCH_ORION5X || COMPILE_TEST
 	select GENERIC_PHY
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 4b741b83e23ff4de..3d27da7a430c0bc2 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -419,7 +419,7 @@ config CRYPTO_DEV_EXYNOS_RNG
 config CRYPTO_DEV_S5P
 	tristate "Support for Samsung S5PV210/Exynos crypto accelerator"
 	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
-	depends on HAS_IOMEM && HAS_DMA
+	depends on HAS_IOMEM
 	select CRYPTO_AES
 	select CRYPTO_BLKCIPHER
 	help
@@ -473,7 +473,6 @@ config CRYPTO_DEV_BFIN_CRC
 
 config CRYPTO_DEV_ATMEL_AUTHENC
 	tristate "Support for Atmel IPSEC/SSL hw accelerator"
-	depends on HAS_DMA
 	depends on ARCH_AT91 || COMPILE_TEST
 	select CRYPTO_AUTHENC
 	select CRYPTO_DEV_ATMEL_AES
@@ -486,7 +485,6 @@ config CRYPTO_DEV_ATMEL_AUTHENC
 
 config CRYPTO_DEV_ATMEL_AES
 	tristate "Support for Atmel AES hw accelerator"
-	depends on HAS_DMA
 	depends on ARCH_AT91 || COMPILE_TEST
 	select CRYPTO_AES
 	select CRYPTO_AEAD
@@ -501,7 +499,6 @@ config CRYPTO_DEV_ATMEL_AES
 
 config CRYPTO_DEV_ATMEL_TDES
 	tristate "Support for Atmel DES/TDES hw accelerator"
-	depends on HAS_DMA
 	depends on ARCH_AT91 || COMPILE_TEST
 	select CRYPTO_DES
 	select CRYPTO_BLKCIPHER
@@ -515,7 +512,6 @@ config CRYPTO_DEV_ATMEL_TDES
 
 config CRYPTO_DEV_ATMEL_SHA
 	tristate "Support for Atmel SHA hw accelerator"
-	depends on HAS_DMA
 	depends on ARCH_AT91 || COMPILE_TEST
 	select CRYPTO_HASH
 	help
@@ -581,7 +577,8 @@ config CRYPTO_DEV_CAVIUM_ZIP
 
 config CRYPTO_DEV_QCE
 	tristate "Qualcomm crypto engine accelerator"
-	depends on (ARCH_QCOM || COMPILE_TEST) && HAS_DMA && HAS_IOMEM
+	depends on ARCH_QCOM || COMPILE_TEST
+	depends on HAS_IOMEM
 	select CRYPTO_AES
 	select CRYPTO_DES
 	select CRYPTO_ECB
@@ -605,7 +602,6 @@ source "drivers/crypto/vmx/Kconfig"
 config CRYPTO_DEV_IMGTEC_HASH
 	tristate "Imagination Technologies hardware hash accelerator"
 	depends on MIPS || COMPILE_TEST
-	depends on HAS_DMA
 	select CRYPTO_MD5
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
@@ -657,7 +653,6 @@ config CRYPTO_DEV_ROCKCHIP
 
 config CRYPTO_DEV_MEDIATEK
 	tristate "MediaTek's EIP97 Cryptographic Engine driver"
-	depends on HAS_DMA
 	depends on (ARM && ARCH_MEDIATEK) || COMPILE_TEST
 	select CRYPTO_AES
 	select CRYPTO_AEAD
@@ -695,7 +690,7 @@ source "drivers/crypto/stm32/Kconfig"
 
 config CRYPTO_DEV_SAFEXCEL
 	tristate "Inside Secure's SafeXcel cryptographic engine driver"
-	depends on HAS_DMA && OF
+	depends on OF
 	depends on (ARM64 && ARCH_MVEBU) || (COMPILE_TEST && 64BIT)
 	select CRYPTO_AES
 	select CRYPTO_BLKCIPHER
@@ -713,7 +708,6 @@ config CRYPTO_DEV_SAFEXCEL
 config CRYPTO_DEV_ARTPEC6
 	tristate "Support for Axis ARTPEC-6/7 hardware crypto acceleration."
 	depends on ARM && (ARCH_ARTPEC || COMPILE_TEST)
-	depends on HAS_DMA
 	depends on OF
 	select CRYPTO_AEAD
 	select CRYPTO_AES
diff --git a/drivers/firewire/Kconfig b/drivers/firewire/Kconfig
index 145974f9662b63e6..4199849e37585181 100644
--- a/drivers/firewire/Kconfig
+++ b/drivers/firewire/Kconfig
@@ -1,5 +1,4 @@
 menu "IEEE 1394 (FireWire) support"
-	depends on HAS_DMA
 	depends on PCI || COMPILE_TEST
 	# firewire-core does not depend on PCI but is
 	# not useful without PCI controller driver
diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
index f47ef848bcd056d5..fd539132542e30ee 100644
--- a/drivers/fpga/Kconfig
+++ b/drivers/fpga/Kconfig
@@ -53,7 +53,6 @@ config FPGA_MGR_ALTERA_CVP
 config FPGA_MGR_ZYNQ_FPGA
 	tristate "Xilinx Zynq FPGA"
 	depends on ARCH_ZYNQ || COMPILE_TEST
-	depends on HAS_DMA
 	help
 	  FPGA manager driver support for Xilinx Zynq FPGAs.
 
diff --git a/drivers/gpu/ipu-v3/Kconfig b/drivers/gpu/ipu-v3/Kconfig
index 5eb484671539b27e..fe6f8c5b444583cf 100644
--- a/drivers/gpu/ipu-v3/Kconfig
+++ b/drivers/gpu/ipu-v3/Kconfig
@@ -2,7 +2,6 @@ config IMX_IPUV3_CORE
 	tristate "IPUv3 core support"
 	depends on SOC_IMX5 || SOC_IMX6Q || ARCH_MULTIPLATFORM || COMPILE_TEST
 	depends on DRM || !DRM # if DRM=m, this can't be 'y'
-	depends on HAS_DMA
 	select BITREVERSE
 	select GENERIC_ALLOCATOR if DRM
 	select GENERIC_IRQ_CHIP
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index a9805c7cb305ac56..bac92cf32682ce60 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -723,7 +723,6 @@ config I2C_MPC
 config I2C_MT65XX
 	tristate "MediaTek I2C adapter"
 	depends on ARCH_MEDIATEK || COMPILE_TEST
-	depends on HAS_DMA
 	help
 	  This selects the MediaTek(R) Integrated Inter Circuit bus driver
 	  for MT65xx and MT81xx.
@@ -901,7 +900,6 @@ config I2C_SH7760
 
 config I2C_SH_MOBILE
 	tristate "SuperH Mobile I2C Controller"
-	depends on HAS_DMA
 	depends on ARCH_SHMOBILE || ARCH_RENESAS || COMPILE_TEST
 	help
 	  If you say yes to this option, support will be included for the
@@ -1104,7 +1102,6 @@ config I2C_XLP9XX
 
 config I2C_RCAR
 	tristate "Renesas R-Car I2C Controller"
-	depends on HAS_DMA
 	depends on ARCH_RENESAS || COMPILE_TEST
 	select I2C_SLAVE
 	help
diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index bb0ea661e42e5f1f..57f46e88f5c2536e 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -158,7 +158,6 @@ config AT91_SAMA5D2_ADC
 	tristate "Atmel AT91 SAMA5D2 ADC"
 	depends on ARCH_AT91 || COMPILE_TEST
 	depends on HAS_IOMEM
-	depends on HAS_DMA
 	select IIO_TRIGGERED_BUFFER
 	help
 	  Say yes here to build support for Atmel SAMA5D2 ADC which is
@@ -647,7 +646,6 @@ config SD_ADC_MODULATOR
 config STM32_ADC_CORE
 	tristate "STMicroelectronics STM32 adc core"
 	depends on ARCH_STM32 || COMPILE_TEST
-	depends on HAS_DMA
 	depends on OF
 	depends on REGULATOR
 	select IIO_BUFFER
@@ -686,7 +684,6 @@ config STM32_DFSDM_CORE
 config STM32_DFSDM_ADC
 	tristate "STMicroelectronics STM32 dfsdm adc"
 	depends on (ARCH_STM32 && OF) || COMPILE_TEST
-	depends on HAS_DMA
 	select STM32_DFSDM_CORE
 	select REGMAP_MMIO
 	select IIO_BUFFER_HW_CONSUMER
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index f3a21343e636a8f2..32e91398c0555272 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -23,7 +23,7 @@ config IOMMU_IO_PGTABLE
 config IOMMU_IO_PGTABLE_LPAE
 	bool "ARMv7/v8 Long Descriptor Format"
 	select IOMMU_IO_PGTABLE
-	depends on HAS_DMA && (ARM || ARM64 || (COMPILE_TEST && !GENERIC_ATOMIC64))
+	depends on ARM || ARM64 || (COMPILE_TEST && !GENERIC_ATOMIC64)
 	help
 	  Enable support for the ARM long descriptor pagetable format.
 	  This allocator supports 4K/2M/1G, 16K/32M and 64K/512M page
@@ -42,7 +42,7 @@ config IOMMU_IO_PGTABLE_LPAE_SELFTEST
 config IOMMU_IO_PGTABLE_ARMV7S
 	bool "ARMv7/v8 Short Descriptor Format"
 	select IOMMU_IO_PGTABLE
-	depends on HAS_DMA && (ARM || ARM64 || COMPILE_TEST)
+	depends on ARM || ARM64 || COMPILE_TEST
 	help
 	  Enable support for the ARM Short-descriptor pagetable format.
 	  This supports 32-bit virtual and physical addresses mapped using
@@ -374,7 +374,6 @@ config QCOM_IOMMU
 	# Note: iommu drivers cannot (yet?) be built as modules
 	bool "Qualcomm IOMMU Support"
 	depends on ARCH_QCOM || (COMPILE_TEST && !GENERIC_ATOMIC64)
-	depends on HAS_DMA
 	select IOMMU_API
 	select IOMMU_IO_PGTABLE_LPAE
 	select ARM_DMA_USE_IOMMU
diff --git a/drivers/lightnvm/Kconfig b/drivers/lightnvm/Kconfig
index 10c08982185a572f..9c03f35d9df113c6 100644
--- a/drivers/lightnvm/Kconfig
+++ b/drivers/lightnvm/Kconfig
@@ -4,7 +4,7 @@
 
 menuconfig NVM
 	bool "Open-Channel SSD target support"
-	depends on BLOCK && HAS_DMA && PCI
+	depends on BLOCK && PCI
 	select BLK_DEV_NVME
 	help
 	  Say Y here to get to enable Open-channel SSDs.
diff --git a/drivers/mailbox/Kconfig b/drivers/mailbox/Kconfig
index ba2f1525f4eef454..f3c68fe15180d035 100644
--- a/drivers/mailbox/Kconfig
+++ b/drivers/mailbox/Kconfig
@@ -154,7 +154,6 @@ config XGENE_SLIMPRO_MBOX
 config BCM_PDC_MBOX
 	tristate "Broadcom FlexSparx DMA Mailbox"
 	depends on ARCH_BCM_IPROC || COMPILE_TEST
-	depends on HAS_DMA
 	help
 	  Mailbox implementation for the Broadcom FlexSparx DMA ring manager,
 	  which provides access to various offload engines on Broadcom
@@ -164,7 +163,6 @@ config BCM_FLEXRM_MBOX
 	tristate "Broadcom FlexRM Mailbox"
 	depends on ARM64
 	depends on ARCH_BCM_IPROC || COMPILE_TEST
-	depends on HAS_DMA
 	select GENERIC_MSI_IRQ_DOMAIN
 	default m if ARCH_BCM_IPROC
 	help
diff --git a/drivers/media/pci/dt3155/Kconfig b/drivers/media/pci/dt3155/Kconfig
index 5145e0dfa2aa9e12..858b0f2f15bef9c8 100644
--- a/drivers/media/pci/dt3155/Kconfig
+++ b/drivers/media/pci/dt3155/Kconfig
@@ -1,7 +1,6 @@
 config VIDEO_DT3155
 	tristate "DT3155 frame grabber"
 	depends on PCI && VIDEO_DEV && VIDEO_V4L2
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	default n
 	---help---
diff --git a/drivers/media/pci/solo6x10/Kconfig b/drivers/media/pci/solo6x10/Kconfig
index 0fb91dc7ca73529e..d9e06a6bf1ebc1a7 100644
--- a/drivers/media/pci/solo6x10/Kconfig
+++ b/drivers/media/pci/solo6x10/Kconfig
@@ -1,7 +1,6 @@
 config VIDEO_SOLO6X10
 	tristate "Bluecherry / Softlogic 6x10 capture cards (MPEG-4/H.264)"
 	depends on PCI && VIDEO_DEV && SND && I2C
-	depends on HAS_DMA
 	select BITREVERSE
 	select FONT_SUPPORT
 	select FONT_8x16
diff --git a/drivers/media/pci/sta2x11/Kconfig b/drivers/media/pci/sta2x11/Kconfig
index e03587b1af714199..7b856395ede9295c 100644
--- a/drivers/media/pci/sta2x11/Kconfig
+++ b/drivers/media/pci/sta2x11/Kconfig
@@ -1,7 +1,6 @@
 config STA2X11_VIP
 	tristate "STA2X11 VIP Video For Linux"
 	depends on STA2X11
-	depends on HAS_DMA
 	select VIDEO_ADV7180 if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEOBUF2_DMA_CONTIG
 	depends on PCI && VIDEO_V4L2 && VIRT_TO_BUS
diff --git a/drivers/media/pci/tw5864/Kconfig b/drivers/media/pci/tw5864/Kconfig
index 87c8f327e2d49dfa..760fb11dfeaef47b 100644
--- a/drivers/media/pci/tw5864/Kconfig
+++ b/drivers/media/pci/tw5864/Kconfig
@@ -1,7 +1,6 @@
 config VIDEO_TW5864
 	tristate "Techwell TW5864 video/audio grabber and encoder"
 	depends on VIDEO_DEV && PCI && VIDEO_V4L2
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  Support for boards based on Techwell TW5864 chip which provides
diff --git a/drivers/media/pci/tw686x/Kconfig b/drivers/media/pci/tw686x/Kconfig
index 34ff37712313b780..da8bfee71b44cca5 100644
--- a/drivers/media/pci/tw686x/Kconfig
+++ b/drivers/media/pci/tw686x/Kconfig
@@ -1,7 +1,6 @@
 config VIDEO_TW686X
 	tristate "Intersil/Techwell TW686x video capture cards"
 	depends on PCI && VIDEO_DEV && VIDEO_V4L2 && SND
-	depends on HAS_DMA
 	select VIDEOBUF2_VMALLOC
 	select VIDEOBUF2_DMA_CONTIG
 	select VIDEOBUF2_DMA_SG
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index fd0c99859d6f4b8b..a9a1230bb835a4d9 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -36,7 +36,7 @@ source "drivers/media/platform/blackfin/Kconfig"
 config VIDEO_SH_VOU
 	tristate "SuperH VOU video output driver"
 	depends on MEDIA_CAMERA_SUPPORT
-	depends on VIDEO_DEV && I2C && HAS_DMA
+	depends on VIDEO_DEV && I2C
 	depends on ARCH_SHMOBILE || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	help
@@ -85,7 +85,7 @@ config VIDEO_MUX
 config VIDEO_OMAP3
 	tristate "OMAP 3 Camera support"
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3
-	depends on HAS_DMA && OF
+	depends on OF
 	depends on OMAP_IOMMU
 	select ARM_DMA_USE_IOMMU
 	select VIDEOBUF2_DMA_CONTIG
@@ -102,7 +102,7 @@ config VIDEO_OMAP3_DEBUG
 
 config VIDEO_PXA27x
 	tristate "PXA27x Quick Capture Interface driver"
-	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
+	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on PXA27x || COMPILE_TEST
 	select VIDEOBUF2_DMA_SG
 	select SG_SPLIT
@@ -112,7 +112,7 @@ config VIDEO_PXA27x
 
 config VIDEO_QCOM_CAMSS
 	tristate "Qualcomm 8x16 V4L2 Camera Subsystem driver"
-	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
+	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on (ARCH_QCOM && IOMMU_DMA) || COMPILE_TEST
 	select VIDEOBUF2_DMA_SG
 	select V4L2_FWNODE
@@ -122,7 +122,6 @@ config VIDEO_S3C_CAMIF
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
 	depends on PM
 	depends on ARCH_S3C64XX || PLAT_S3C24XX || COMPILE_TEST
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  This is a v4l2 driver for s3c24xx and s3c64xx SoC series camera
@@ -133,7 +132,7 @@ config VIDEO_S3C_CAMIF
 
 config VIDEO_STM32_DCMI
 	tristate "STM32 Digital Camera Memory Interface (DCMI) support"
-	depends on VIDEO_V4L2 && OF && HAS_DMA
+	depends on VIDEO_V4L2 && OF
 	depends on ARCH_STM32 || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_FWNODE
@@ -155,7 +154,6 @@ config VIDEO_TI_CAL
 	tristate "TI CAL (Camera Adaptation Layer) driver"
 	depends on VIDEO_DEV && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on SOC_DRA7XX || COMPILE_TEST
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_FWNODE
 	default n
@@ -183,7 +181,6 @@ if V4L_MEM2MEM_DRIVERS
 config VIDEO_CODA
 	tristate "Chips&Media Coda multi-standard codec IP"
 	depends on VIDEO_DEV && VIDEO_V4L2 && (ARCH_MXC || COMPILE_TEST)
-	depends on HAS_DMA
 	select SRAM
 	select VIDEOBUF2_DMA_CONTIG
 	select VIDEOBUF2_VMALLOC
@@ -201,7 +198,6 @@ config VIDEO_MEDIATEK_JPEG
 	depends on MTK_IOMMU_V1 || COMPILE_TEST
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_MEDIATEK || COMPILE_TEST
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	---help---
@@ -213,7 +209,7 @@ config VIDEO_MEDIATEK_JPEG
 
 config VIDEO_MEDIATEK_VPU
 	tristate "Mediatek Video Processor Unit"
-	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
+	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_MEDIATEK || COMPILE_TEST
 	---help---
 	    This driver provides downloading VPU firmware and
@@ -229,7 +225,6 @@ config VIDEO_MEDIATEK_MDP
 	depends on MTK_IOMMU || COMPILE_TEST
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_MEDIATEK || COMPILE_TEST
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	select VIDEO_MEDIATEK_VPU
@@ -244,7 +239,7 @@ config VIDEO_MEDIATEK_MDP
 config VIDEO_MEDIATEK_VCODEC
 	tristate "Mediatek Video Codec driver"
 	depends on MTK_IOMMU || COMPILE_TEST
-	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
+	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_MEDIATEK || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
@@ -271,7 +266,6 @@ config VIDEO_SAMSUNG_S5P_G2D
 	tristate "Samsung S5P and EXYNOS4 G2D 2d graphics accelerator driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	default n
@@ -283,7 +277,6 @@ config VIDEO_SAMSUNG_S5P_JPEG
 	tristate "Samsung S5P/Exynos3250/Exynos4 JPEG codec driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	---help---
@@ -294,7 +287,6 @@ config VIDEO_SAMSUNG_S5P_MFC
 	tristate "Samsung S5P MFC Video Codec"
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	default n
 	help
@@ -304,7 +296,6 @@ config VIDEO_MX2_EMMAPRP
 	tristate "MX2 eMMa-PrP support"
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on SOC_IMX27 || COMPILE_TEST
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	help
@@ -316,7 +307,6 @@ config VIDEO_SAMSUNG_EXYNOS_GSC
 	tristate "Samsung Exynos G-Scaler driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_EXYNOS || COMPILE_TEST
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	help
@@ -325,7 +315,6 @@ config VIDEO_SAMSUNG_EXYNOS_GSC
 config VIDEO_STI_BDISP
 	tristate "STMicroelectronics BDISP 2D blitter driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
-	depends on HAS_DMA
 	depends on ARCH_STI || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
@@ -335,7 +324,6 @@ config VIDEO_STI_BDISP
 config VIDEO_STI_HVA
 	tristate "STMicroelectronics HVA multi-format video encoder V4L2 driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
-	depends on HAS_DMA
 	depends on ARCH_STI || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
@@ -362,7 +350,6 @@ config VIDEO_STI_DELTA
 	tristate "STMicroelectronics DELTA multi-format video decoder V4L2 driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_STI || COMPILE_TEST
-	depends on HAS_DMA
 	help
 		This V4L2 driver enables DELTA multi-format video decoder
 		of STMicroelectronics STiH4xx SoC series allowing hardware
@@ -408,7 +395,7 @@ config VIDEO_SH_VEU
 
 config VIDEO_RENESAS_FDP1
 	tristate "Renesas Fine Display Processor"
-	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
+	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_SHMOBILE || COMPILE_TEST
 	depends on (!ARCH_RENESAS && !VIDEO_RENESAS_FCP) || VIDEO_RENESAS_FCP
 	select VIDEOBUF2_DMA_CONTIG
@@ -422,7 +409,7 @@ config VIDEO_RENESAS_FDP1
 
 config VIDEO_RENESAS_JPU
 	tristate "Renesas JPEG Processing Unit"
-	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
+	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_RENESAS || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
@@ -447,7 +434,7 @@ config VIDEO_RENESAS_FCP
 
 config VIDEO_RENESAS_VSP1
 	tristate "Renesas VSP1 Video Processing Engine"
-	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
+	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on (ARCH_RENESAS && OF) || COMPILE_TEST
 	depends on (!ARM64 && !VIDEO_RENESAS_FCP) || VIDEO_RENESAS_FCP
 	select VIDEOBUF2_DMA_CONTIG
@@ -460,7 +447,7 @@ config VIDEO_RENESAS_VSP1
 
 config VIDEO_ROCKCHIP_RGA
 	tristate "Rockchip Raster 2d Graphic Acceleration Unit"
-	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
+	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_ROCKCHIP || COMPILE_TEST
 	select VIDEOBUF2_DMA_SG
 	select V4L2_MEM2MEM_DEV
@@ -477,7 +464,6 @@ config VIDEO_TI_VPE
 	tristate "TI VPE (Video Processing Engine) driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on SOC_DRA7XX || COMPILE_TEST
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	select VIDEO_TI_VPDMA
@@ -496,7 +482,7 @@ config VIDEO_TI_VPE_DEBUG
 
 config VIDEO_QCOM_VENUS
 	tristate "Qualcomm Venus V4L2 encoder/decoder driver"
-	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
+	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on (ARCH_QCOM && IOMMU_DMA) || COMPILE_TEST
 	select QCOM_MDT_LOADER if ARCH_QCOM
 	select QCOM_SCM if ARCH_QCOM
@@ -638,7 +624,7 @@ if SDR_PLATFORM_DRIVERS
 
 config VIDEO_RCAR_DRIF
 	tristate "Renesas Digitial Radio Interface (DRIF)"
-	depends on VIDEO_V4L2 && HAS_DMA
+	depends on VIDEO_V4L2
 	depends on ARCH_RENESAS || COMPILE_TEST
 	select VIDEOBUF2_VMALLOC
 	---help---
diff --git a/drivers/media/platform/am437x/Kconfig b/drivers/media/platform/am437x/Kconfig
index 160e77e9a0fbfa61..f4ce1176e4dc8179 100644
--- a/drivers/media/platform/am437x/Kconfig
+++ b/drivers/media/platform/am437x/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_AM437X_VPFE
 	tristate "TI AM437x VPFE video capture driver"
-	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
+	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on SOC_AM43XX || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_FWNODE
diff --git a/drivers/media/platform/atmel/Kconfig b/drivers/media/platform/atmel/Kconfig
index 55de751e5f51500b..a211ef20f77eadba 100644
--- a/drivers/media/platform/atmel/Kconfig
+++ b/drivers/media/platform/atmel/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_ATMEL_ISC
 	tristate "ATMEL Image Sensor Controller (ISC) support"
-	depends on VIDEO_V4L2 && COMMON_CLK && VIDEO_V4L2_SUBDEV_API && HAS_DMA
+	depends on VIDEO_V4L2 && COMMON_CLK && VIDEO_V4L2_SUBDEV_API
 	depends on ARCH_AT91 || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select REGMAP_MMIO
@@ -11,7 +11,7 @@ config VIDEO_ATMEL_ISC
 
 config VIDEO_ATMEL_ISI
 	tristate "ATMEL Image Sensor Interface (ISI) support"
-	depends on VIDEO_V4L2 && OF && HAS_DMA
+	depends on VIDEO_V4L2 && OF
 	depends on ARCH_AT91 || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_FWNODE
diff --git a/drivers/media/platform/blackfin/Kconfig b/drivers/media/platform/blackfin/Kconfig
index 68fa90151b8f40f2..cc239972fa2c3228 100644
--- a/drivers/media/platform/blackfin/Kconfig
+++ b/drivers/media/platform/blackfin/Kconfig
@@ -1,7 +1,6 @@
 config VIDEO_BLACKFIN_CAPTURE
 	tristate "Blackfin Video Capture Driver"
 	depends on VIDEO_V4L2 && BLACKFIN && I2C
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	help
 	  V4L2 bridge driver for Blackfin video capture device.
diff --git a/drivers/media/platform/davinci/Kconfig b/drivers/media/platform/davinci/Kconfig
index 55982e681d779d3a..6273853a86f900c3 100644
--- a/drivers/media/platform/davinci/Kconfig
+++ b/drivers/media/platform/davinci/Kconfig
@@ -2,7 +2,6 @@ config VIDEO_DAVINCI_VPIF_DISPLAY
 	tristate "TI DaVinci VPIF V4L2-Display driver"
 	depends on VIDEO_V4L2
 	depends on ARCH_DAVINCI || COMPILE_TEST
-	depends on HAS_DMA
 	depends on I2C
 	select VIDEOBUF2_DMA_CONTIG
 	select VIDEO_ADV7343 if MEDIA_SUBDRV_AUTOSELECT
@@ -19,7 +18,6 @@ config VIDEO_DAVINCI_VPIF_CAPTURE
 	tristate "TI DaVinci VPIF video capture driver"
 	depends on VIDEO_V4L2
 	depends on ARCH_DAVINCI || COMPILE_TEST
-	depends on HAS_DMA
 	depends on I2C
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_FWNODE
@@ -35,7 +33,6 @@ config VIDEO_DM6446_CCDC
 	tristate "TI DM6446 CCDC video capture driver"
 	depends on VIDEO_V4L2
 	depends on ARCH_DAVINCI || COMPILE_TEST
-	depends on HAS_DMA
 	depends on I2C
 	select VIDEOBUF_DMA_CONTIG
 	help
@@ -52,7 +49,6 @@ config VIDEO_DM355_CCDC
 	tristate "TI DM355 CCDC video capture driver"
 	depends on VIDEO_V4L2
 	depends on ARCH_DAVINCI || COMPILE_TEST
-	depends on HAS_DMA
 	depends on I2C
 	select VIDEOBUF_DMA_CONTIG
 	help
@@ -68,7 +64,6 @@ config VIDEO_DM355_CCDC
 config VIDEO_DM365_ISIF
 	tristate "TI DM365 ISIF video capture driver"
 	depends on VIDEO_V4L2 && ARCH_DAVINCI
-	depends on HAS_DMA
 	depends on I2C
 	select VIDEOBUF_DMA_CONTIG
 	help
@@ -82,7 +77,6 @@ config VIDEO_DM365_ISIF
 config VIDEO_DAVINCI_VPBE_DISPLAY
 	tristate "TI DaVinci VPBE V4L2-Display driver"
 	depends on VIDEO_V4L2 && ARCH_DAVINCI
-	depends on HAS_DMA
 	depends on I2C
 	select VIDEOBUF2_DMA_CONTIG
 	help
diff --git a/drivers/media/platform/marvell-ccic/Kconfig b/drivers/media/platform/marvell-ccic/Kconfig
index 4bf5bd1e90d69fea..7f7868bc6fcbee87 100644
--- a/drivers/media/platform/marvell-ccic/Kconfig
+++ b/drivers/media/platform/marvell-ccic/Kconfig
@@ -1,7 +1,6 @@
 config VIDEO_CAFE_CCIC
 	tristate "Marvell 88ALP01 (Cafe) CMOS Camera Controller support"
 	depends on PCI && I2C && VIDEO_V4L2
-	depends on HAS_DMA
 	select VIDEO_OV7670
 	select VIDEOBUF2_VMALLOC
 	select VIDEOBUF2_DMA_CONTIG
@@ -14,7 +13,7 @@ config VIDEO_CAFE_CCIC
 config VIDEO_MMP_CAMERA
 	tristate "Marvell Armada 610 integrated camera controller support"
 	depends on ARCH_MMP && I2C && VIDEO_V4L2
-	depends on HAS_DMA && BROKEN
+	depends on BROKEN
 	select VIDEO_OV7670
 	select I2C_GPIO
 	select VIDEOBUF2_DMA_SG
diff --git a/drivers/media/platform/rcar-vin/Kconfig b/drivers/media/platform/rcar-vin/Kconfig
index af4c98b44d2e22cb..9064337a4bd9fc66 100644
--- a/drivers/media/platform/rcar-vin/Kconfig
+++ b/drivers/media/platform/rcar-vin/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_RCAR_VIN
 	tristate "R-Car Video Input (VIN) Driver"
-	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF && HAS_DMA && MEDIA_CONTROLLER
+	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF && MEDIA_CONTROLLER
 	depends on ARCH_RENESAS || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_FWNODE
diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
index f5979c12ad618f4a..669d116b8f09b2aa 100644
--- a/drivers/media/platform/soc_camera/Kconfig
+++ b/drivers/media/platform/soc_camera/Kconfig
@@ -18,9 +18,8 @@ config SOC_CAMERA_PLATFORM
 
 config VIDEO_SH_MOBILE_CEU
 	tristate "SuperH Mobile CEU Interface driver"
-	depends on VIDEO_DEV && SOC_CAMERA && HAS_DMA && HAVE_CLK
+	depends on VIDEO_DEV && SOC_CAMERA && HAVE_CLK
 	depends on ARCH_SHMOBILE || COMPILE_TEST
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select SOC_CAMERA_SCALE_CROP
 	---help---
diff --git a/drivers/media/platform/sti/c8sectpfe/Kconfig b/drivers/media/platform/sti/c8sectpfe/Kconfig
index 740190f8a3b606d3..7420a50572d347ef 100644
--- a/drivers/media/platform/sti/c8sectpfe/Kconfig
+++ b/drivers/media/platform/sti/c8sectpfe/Kconfig
@@ -1,6 +1,6 @@
 config DVB_C8SECTPFE
 	tristate "STMicroelectronics C8SECTPFE DVB support"
-	depends on PINCTRL && DVB_CORE && I2C && HAS_DMA
+	depends on PINCTRL && DVB_CORE && I2C
 	depends on ARCH_STI || ARCH_MULTIPLATFORM || COMPILE_TEST
 	select FW_LOADER
 	select DEBUG_FS
diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 0eae619419d9ddeb..3705b459687293c5 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -358,7 +358,6 @@ config MMC_MESON_MX_SDIO
 	tristate "Amlogic Meson6/Meson8/Meson8b SD/MMC Host Controller support"
 	depends on ARCH_MESON || COMPILE_TEST
 	depends on COMMON_CLK
-	depends on HAS_DMA
 	depends on OF
 	help
 	  This selects support for the SD/MMC Host Controller on
@@ -401,7 +400,6 @@ config MMC_OMAP
 
 config MMC_OMAP_HS
 	tristate "TI OMAP High Speed Multimedia Card Interface support"
-	depends on HAS_DMA
 	depends on ARCH_OMAP2PLUS || ARCH_KEYSTONE || COMPILE_TEST
 	help
 	  This selects the TI OMAP High Speed Multimedia card Interface.
@@ -511,7 +509,6 @@ config MMC_DAVINCI
 
 config MMC_GOLDFISH
 	tristate "goldfish qemu Multimedia Card Interface support"
-	depends on HAS_DMA
 	depends on GOLDFISH || COMPILE_TEST
 	help
 	  This selects the Goldfish Multimedia card Interface emulation
@@ -605,7 +602,7 @@ config MMC_SDHI
 
 config MMC_SDHI_SYS_DMAC
 	tristate "DMA for SDHI SD/SDIO controllers using SYS-DMAC"
-	depends on MMC_SDHI && HAS_DMA
+	depends on MMC_SDHI
 	default MMC_SDHI if (SUPERH || ARM)
 	help
 	  This provides DMA support for SDHI SD/SDIO controllers
@@ -615,7 +612,7 @@ config MMC_SDHI_SYS_DMAC
 config MMC_SDHI_INTERNAL_DMAC
 	tristate "DMA for SDHI SD/SDIO controllers using on-chip bus mastering"
 	depends on ARM64 || COMPILE_TEST
-	depends on MMC_SDHI && HAS_DMA
+	depends on MMC_SDHI
 	default MMC_SDHI if ARM64
 	help
 	  This provides DMA support for SDHI SD/SDIO controllers
@@ -688,7 +685,6 @@ config MMC_CAVIUM_THUNDERX
 
 config MMC_DW
 	tristate "Synopsys DesignWare Memory Card Interface"
-	depends on HAS_DMA
 	depends on ARC || ARM || ARM64 || MIPS || COMPILE_TEST
 	help
 	  This selects support for the Synopsys DesignWare Mobile Storage IP
@@ -758,7 +754,6 @@ config MMC_DW_ZX
 
 config MMC_SH_MMCIF
 	tristate "SuperH Internal MMCIF support"
-	depends on HAS_DMA
 	depends on SUPERH || ARCH_RENESAS || COMPILE_TEST
 	help
 	  This selects the MMC Host Interface controller (MMCIF) found in various
@@ -879,7 +874,6 @@ config MMC_TOSHIBA_PCI
 config MMC_BCM2835
 	tristate "Broadcom BCM2835 SDHOST MMC Controller support"
 	depends on ARCH_BCM2835 || COMPILE_TEST
-	depends on HAS_DMA
 	help
 	  This selects the BCM2835 SDHOST MMC controller. If you have
 	  a BCM2835 platform with SD or MMC devices, say Y or M here.
diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 736ac887303c88ba..55a2f8a2fa90cd87 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -46,7 +46,7 @@ config MTD_NAND_DENALI
 config MTD_NAND_DENALI_PCI
         tristate "Support Denali NAND controller on Intel Moorestown"
 	select MTD_NAND_DENALI
-	depends on HAS_DMA && PCI
+	depends on PCI
         help
           Enable the driver for NAND flash on Intel Moorestown, using the
           Denali NAND controller core.
@@ -184,7 +184,6 @@ config MTD_NAND_S3C2410_CLKSTOP
 config MTD_NAND_TANGO
 	tristate "NAND Flash support for Tango chips"
 	depends on ARCH_TANGO || COMPILE_TEST
-	depends on HAS_DMA
 	help
 	  Enables the NAND Flash controller on Tango chips.
 
@@ -328,7 +327,7 @@ config MTD_NAND_MARVELL
 	tristate "NAND controller support on Marvell boards"
 	depends on PXA3xx || ARCH_MMP || PLAT_ORION || ARCH_MVEBU || \
 		   COMPILE_TEST
-	depends on HAS_IOMEM && HAS_DMA
+	depends on HAS_IOMEM
 	help
 	  This enables the NAND flash controller driver for Marvell boards,
 	  including:
@@ -490,7 +489,6 @@ config MTD_NAND_SH_FLCTL
 	tristate "Support for NAND on Renesas SuperH FLCTL"
 	depends on SUPERH || COMPILE_TEST
 	depends on HAS_IOMEM
-	depends on HAS_DMA
 	help
 	  Several Renesas SuperH CPU has FLCTL. This option enables support
 	  for NAND Flash using FLCTL.
@@ -558,7 +556,6 @@ config MTD_NAND_SUNXI
 config MTD_NAND_HISI504
 	tristate "Support for NAND controller on Hisilicon SoC Hip04"
 	depends on ARCH_HISI || COMPILE_TEST
-	depends on HAS_DMA
 	help
 	  Enables support for NAND controller on Hisilicon SoC Hip04.
 
@@ -572,7 +569,6 @@ config MTD_NAND_QCOM
 config MTD_NAND_MTK
 	tristate "Support for NAND controller on MTK SoCs"
 	depends on ARCH_MEDIATEK || COMPILE_TEST
-	depends on HAS_DMA
 	help
 	  Enables support for NAND controller on MTK SoCs.
 	  This controller is found on mt27xx, mt81xx, mt65xx SoCs.
diff --git a/drivers/mtd/spi-nor/Kconfig b/drivers/mtd/spi-nor/Kconfig
index 89da88e591215db1..c493b8230a38c059 100644
--- a/drivers/mtd/spi-nor/Kconfig
+++ b/drivers/mtd/spi-nor/Kconfig
@@ -71,7 +71,7 @@ config SPI_FSL_QUADSPI
 config SPI_HISI_SFC
 	tristate "Hisilicon SPI-NOR Flash Controller(SFC)"
 	depends on ARCH_HISI || COMPILE_TEST
-	depends on HAS_IOMEM && HAS_DMA
+	depends on HAS_IOMEM
 	help
 	  This enables support for hisilicon SPI-NOR flash controller.
 
diff --git a/drivers/net/ethernet/amd/Kconfig b/drivers/net/ethernet/amd/Kconfig
index d5c15e8bb3de706b..f273af136fc7c995 100644
--- a/drivers/net/ethernet/amd/Kconfig
+++ b/drivers/net/ethernet/amd/Kconfig
@@ -173,7 +173,7 @@ config SUNLANCE
 
 config AMD_XGBE
 	tristate "AMD 10GbE Ethernet driver"
-	depends on ((OF_NET && OF_ADDRESS) || ACPI || PCI) && HAS_IOMEM && HAS_DMA
+	depends on ((OF_NET && OF_ADDRESS) || ACPI || PCI) && HAS_IOMEM
 	depends on X86 || ARM64 || COMPILE_TEST
 	select BITREVERSE
 	select CRC32
diff --git a/drivers/net/ethernet/apm/xgene-v2/Kconfig b/drivers/net/ethernet/apm/xgene-v2/Kconfig
index 1205861b631896a0..eedd3f3dd22e2201 100644
--- a/drivers/net/ethernet/apm/xgene-v2/Kconfig
+++ b/drivers/net/ethernet/apm/xgene-v2/Kconfig
@@ -1,6 +1,5 @@
 config NET_XGENE_V2
 	tristate "APM X-Gene SoC Ethernet-v2 Driver"
-	depends on HAS_DMA
 	depends on ARCH_XGENE || COMPILE_TEST
 	help
 	  This is the Ethernet driver for the on-chip ethernet interface
diff --git a/drivers/net/ethernet/apm/xgene/Kconfig b/drivers/net/ethernet/apm/xgene/Kconfig
index afccb033177b3923..e4e33c900b577161 100644
--- a/drivers/net/ethernet/apm/xgene/Kconfig
+++ b/drivers/net/ethernet/apm/xgene/Kconfig
@@ -1,6 +1,5 @@
 config NET_XGENE
 	tristate "APM X-Gene SoC Ethernet Driver"
-	depends on HAS_DMA
 	depends on ARCH_XGENE || COMPILE_TEST
 	select PHYLIB
 	select MDIO_XGENE
diff --git a/drivers/net/ethernet/arc/Kconfig b/drivers/net/ethernet/arc/Kconfig
index e743ddf46343302f..5d0ab8e74b680cc6 100644
--- a/drivers/net/ethernet/arc/Kconfig
+++ b/drivers/net/ethernet/arc/Kconfig
@@ -24,7 +24,8 @@ config ARC_EMAC_CORE
 config ARC_EMAC
 	tristate "ARC EMAC support"
 	select ARC_EMAC_CORE
-	depends on OF_IRQ && OF_NET && HAS_DMA && (ARC || COMPILE_TEST)
+	depends on OF_IRQ && OF_NET
+	depends on ARC || COMPILE_TEST
 	---help---
 	  On some legacy ARC (Synopsys) FPGA boards such as ARCAngel4/ML50x
 	  non-standard on-chip ethernet device ARC EMAC 10/100 is used.
@@ -33,7 +34,8 @@ config ARC_EMAC
 config EMAC_ROCKCHIP
 	tristate "Rockchip EMAC support"
 	select ARC_EMAC_CORE
-	depends on OF_IRQ && OF_NET && REGULATOR && HAS_DMA && (ARCH_ROCKCHIP || COMPILE_TEST)
+	depends on OF_IRQ && OF_NET && REGULATOR
+	depends on ARCH_ROCKCHIP || COMPILE_TEST
 	---help---
 	  Support for Rockchip RK3036/RK3066/RK3188 EMAC ethernet controllers.
 	  This selects Rockchip SoC glue layer support for the
diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
index af75156919edfead..4c3bfde6e8de00f2 100644
--- a/drivers/net/ethernet/broadcom/Kconfig
+++ b/drivers/net/ethernet/broadcom/Kconfig
@@ -157,7 +157,6 @@ config BGMAC
 config BGMAC_BCMA
 	tristate "Broadcom iProc GBit BCMA support"
 	depends on BCMA && BCMA_HOST_SOC
-	depends on HAS_DMA
 	depends on BCM47XX || ARCH_BCM_5301X || COMPILE_TEST
 	select BGMAC
 	select PHYLIB
@@ -170,7 +169,6 @@ config BGMAC_BCMA
 
 config BGMAC_PLATFORM
 	tristate "Broadcom iProc GBit platform support"
-	depends on HAS_DMA
 	depends on ARCH_BCM_IPROC || COMPILE_TEST
 	depends on OF
 	select BGMAC
diff --git a/drivers/net/ethernet/calxeda/Kconfig b/drivers/net/ethernet/calxeda/Kconfig
index 07d2201530d26c85..9fdd496b90ff47cb 100644
--- a/drivers/net/ethernet/calxeda/Kconfig
+++ b/drivers/net/ethernet/calxeda/Kconfig
@@ -1,6 +1,6 @@
 config NET_CALXEDA_XGMAC
 	tristate "Calxeda 1G/10G XGMAC Ethernet driver"
-	depends on HAS_IOMEM && HAS_DMA
+	depends on HAS_IOMEM
 	depends on ARCH_HIGHBANK || COMPILE_TEST
 	select CRC32
 	help
diff --git a/drivers/net/ethernet/hisilicon/Kconfig b/drivers/net/ethernet/hisilicon/Kconfig
index 8bcf470ff5f38a4e..fb1a7251f45d3369 100644
--- a/drivers/net/ethernet/hisilicon/Kconfig
+++ b/drivers/net/ethernet/hisilicon/Kconfig
@@ -5,7 +5,7 @@
 config NET_VENDOR_HISILICON
 	bool "Hisilicon devices"
 	default y
-	depends on (OF || ACPI) && HAS_DMA
+	depends on OF || ACPI
 	depends on ARM || ARM64 || COMPILE_TEST
 	---help---
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/marvell/Kconfig b/drivers/net/ethernet/marvell/Kconfig
index ebe5c91489355c9e..0704a1900bbca444 100644
--- a/drivers/net/ethernet/marvell/Kconfig
+++ b/drivers/net/ethernet/marvell/Kconfig
@@ -18,8 +18,8 @@ if NET_VENDOR_MARVELL
 
 config MV643XX_ETH
 	tristate "Marvell Discovery (643XX) and Orion ethernet support"
-	depends on (MV64X60 || PPC32 || PLAT_ORION || COMPILE_TEST) && INET
-	depends on HAS_DMA
+	depends on MV64X60 || PPC32 || PLAT_ORION || COMPILE_TEST
+	depends on INET
 	select PHYLIB
 	select MVMDIO
 	---help---
@@ -58,7 +58,6 @@ config MVNETA_BM_ENABLE
 config MVNETA
 	tristate "Marvell Armada 370/38x/XP/37xx network interface support"
 	depends on ARCH_MVEBU || COMPILE_TEST
-	depends on HAS_DMA
 	select MVMDIO
 	select PHYLINK
 	---help---
@@ -84,7 +83,6 @@ config MVNETA_BM
 config MVPP2
 	tristate "Marvell Armada 375/7K/8K network interface support"
 	depends on ARCH_MVEBU || COMPILE_TEST
-	depends on HAS_DMA
 	select MVMDIO
 	---help---
 	  This driver supports the network interface units in the
@@ -92,7 +90,7 @@ config MVPP2
 
 config PXA168_ETH
 	tristate "Marvell pxa168 ethernet support"
-	depends on HAS_IOMEM && HAS_DMA
+	depends on HAS_IOMEM
 	depends on CPU_PXA168 || ARCH_BERLIN || COMPILE_TEST
 	select PHYLIB
 	---help---
diff --git a/drivers/net/ethernet/mellanox/mlxsw/Kconfig b/drivers/net/ethernet/mellanox/mlxsw/Kconfig
index d56eea3105090051..b591c8cc9896ccb7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlxsw/Kconfig
@@ -30,7 +30,7 @@ config MLXSW_CORE_THERMAL
 
 config MLXSW_PCI
 	tristate "PCI bus implementation for Mellanox Technologies Switch ASICs"
-	depends on PCI && HAS_DMA && HAS_IOMEM && MLXSW_CORE
+	depends on PCI && HAS_IOMEM && MLXSW_CORE
 	default m
 	---help---
 	  This is PCI bus implementation for Mellanox Technologies Switch ASICs.
diff --git a/drivers/net/ethernet/renesas/Kconfig b/drivers/net/ethernet/renesas/Kconfig
index 27be51f0a421b43e..f3f7477043ce1061 100644
--- a/drivers/net/ethernet/renesas/Kconfig
+++ b/drivers/net/ethernet/renesas/Kconfig
@@ -17,7 +17,6 @@ if NET_VENDOR_RENESAS
 
 config SH_ETH
 	tristate "Renesas SuperH Ethernet support"
-	depends on HAS_DMA
 	depends on ARCH_RENESAS || SUPERH || COMPILE_TEST
 	select CRC32
 	select MII
@@ -31,7 +30,6 @@ config SH_ETH
 
 config RAVB
 	tristate "Renesas Ethernet AVB support"
-	depends on HAS_DMA
 	depends on ARCH_RENESAS || COMPILE_TEST
 	select CRC32
 	select MII
diff --git a/drivers/net/ethernet/socionext/Kconfig b/drivers/net/ethernet/socionext/Kconfig
index fe6f9e2bad4d7fc2..cfdc762ed7ed641d 100644
--- a/drivers/net/ethernet/socionext/Kconfig
+++ b/drivers/net/ethernet/socionext/Kconfig
@@ -14,7 +14,7 @@ if NET_VENDOR_SOCIONEXT
 config SNI_AVE
 	tristate "Socionext AVE ethernet support"
 	depends on ARCH_UNIPHIER || COMPILE_TEST
-	depends on OF && HAS_DMA
+	depends on OF
 	select PHYLIB
 	---help---
 	  Driver for gigabit ethernet MACs, called AVE, in the
@@ -23,7 +23,7 @@ config SNI_AVE
 config SNI_NETSEC
 	tristate "Socionext NETSEC ethernet support"
 	depends on ARCH_SYNQUACER || COMPILE_TEST
-	depends on OF && HAS_DMA
+	depends on OF
 	select PHYLIB
 	select MII
 	---help---
diff --git a/drivers/net/wireless/broadcom/brcm80211/Kconfig b/drivers/net/wireless/broadcom/brcm80211/Kconfig
index 9d99eb42d9176f0f..6acba67bca07abd7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/Kconfig
+++ b/drivers/net/wireless/broadcom/brcm80211/Kconfig
@@ -60,7 +60,6 @@ config BRCMFMAC_PCIE
 	bool "PCIE bus interface support for FullMAC driver"
 	depends on BRCMFMAC
 	depends on PCI
-	depends on HAS_DMA
 	select BRCMFMAC_PROTO_MSGBUF
 	select FW_LOADER
 	---help---
diff --git a/drivers/net/wireless/quantenna/qtnfmac/Kconfig b/drivers/net/wireless/quantenna/qtnfmac/Kconfig
index 025fa6018550895a..8d1492a90bd135c0 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/Kconfig
+++ b/drivers/net/wireless/quantenna/qtnfmac/Kconfig
@@ -7,7 +7,7 @@ config QTNFMAC
 config QTNFMAC_PEARL_PCIE
 	tristate "Quantenna QSR10g PCIe support"
 	default n
-	depends on HAS_DMA && PCI && CFG80211
+	depends on PCI && CFG80211
 	select QTNFMAC
 	select FW_LOADER
 	select CRC32
diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
index b609e1d3654ba65f..b60d8132113de0f7 100644
--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -23,7 +23,6 @@ config IMX_REMOTEPROC
 
 config OMAP_REMOTEPROC
 	tristate "OMAP remoteproc support"
-	depends on HAS_DMA
 	depends on ARCH_OMAP4 || SOC_OMAP5
 	depends on OMAP_IOMMU
 	select MAILBOX
diff --git a/drivers/scsi/hisi_sas/Kconfig b/drivers/scsi/hisi_sas/Kconfig
index d42f29a5eb65046d..57183fce70fb6355 100644
--- a/drivers/scsi/hisi_sas/Kconfig
+++ b/drivers/scsi/hisi_sas/Kconfig
@@ -1,6 +1,6 @@
 config SCSI_HISI_SAS
 	tristate "HiSilicon SAS"
-	depends on HAS_DMA && HAS_IOMEM
+	depends on HAS_IOMEM
 	depends on ARM64 || COMPILE_TEST
 	select SCSI_SAS_LIBSAS
 	select BLK_DEV_INTEGRITY
diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 593617154586611a..73e016cb2880235d 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -71,7 +71,6 @@ config SPI_ARMADA_3700
 
 config SPI_ATMEL
 	tristate "Atmel SPI Controller"
-	depends on HAS_DMA
 	depends on (ARCH_AT91 || AVR32 || COMPILE_TEST)
 	help
 	  This selects a driver for the Atmel SPI Controller, present on
@@ -252,7 +251,6 @@ config SPI_EFM32
 
 config SPI_EP93XX
 	tristate "Cirrus Logic EP93xx SPI controller"
-	depends on HAS_DMA
 	depends on ARCH_EP93XX || COMPILE_TEST
 	help
 	  This enables using the Cirrus EP93xx SPI controller in master
@@ -374,7 +372,6 @@ config SPI_FSL_SPI
 config SPI_FSL_DSPI
 	tristate "Freescale DSPI controller"
 	select REGMAP_MMIO
-	depends on HAS_DMA
 	depends on SOC_VF610 || SOC_LS1021A || ARCH_LAYERSCAPE || M5441x || COMPILE_TEST
 	help
 	  This enables support for the Freescale DSPI controller in master
@@ -456,7 +453,6 @@ config SPI_OMAP_UWIRE
 
 config SPI_OMAP24XX
 	tristate "McSPI driver for OMAP"
-	depends on HAS_DMA
 	depends on ARCH_OMAP2PLUS || COMPILE_TEST
 	select SG_SPLIT
 	help
@@ -465,7 +461,6 @@ config SPI_OMAP24XX
 
 config SPI_TI_QSPI
 	tristate "DRA7xxx QSPI controller support"
-	depends on HAS_DMA
 	depends on ARCH_OMAP2PLUS || COMPILE_TEST
 	help
 	  QSPI master controller for DRA7xxx used for flash devices.
@@ -494,7 +489,6 @@ config SPI_PIC32
 config SPI_PIC32_SQI
 	tristate "Microchip PIC32 Quad SPI driver"
 	depends on MACH_PIC32 || COMPILE_TEST
-	depends on HAS_DMA
 	help
 	  SPI driver for PIC32 Quad SPI controller.
 
@@ -597,7 +591,7 @@ config SPI_SC18IS602
 
 config SPI_SH_MSIOF
 	tristate "SuperH MSIOF SPI controller"
-	depends on HAVE_CLK && HAS_DMA
+	depends on HAVE_CLK
 	depends on ARCH_SHMOBILE || ARCH_RENESAS || COMPILE_TEST
 	help
 	  SPI driver for SuperH and SH Mobile MSIOF blocks.
@@ -675,7 +669,7 @@ config SPI_MXS
 config SPI_TEGRA114
 	tristate "NVIDIA Tegra114 SPI Controller"
 	depends on (ARCH_TEGRA && TEGRA20_APB_DMA) || COMPILE_TEST
-	depends on RESET_CONTROLLER && HAS_DMA
+	depends on RESET_CONTROLLER
 	help
 	  SPI driver for NVIDIA Tegra114 SPI Controller interface. This controller
 	  is different than the older SoCs SPI controller and also register interface
@@ -693,7 +687,7 @@ config SPI_TEGRA20_SFLASH
 config SPI_TEGRA20_SLINK
 	tristate "Nvidia Tegra20/Tegra30 SLINK Controller"
 	depends on (ARCH_TEGRA && TEGRA20_APB_DMA) || COMPILE_TEST
-	depends on RESET_CONTROLLER && HAS_DMA
+	depends on RESET_CONTROLLER
 	help
 	  SPI driver for Nvidia Tegra20/Tegra30 SLINK Controller interface.
 
diff --git a/drivers/staging/media/davinci_vpfe/Kconfig b/drivers/staging/media/davinci_vpfe/Kconfig
index f40a06954a92eaec..0da8d7a5f57f818f 100644
--- a/drivers/staging/media/davinci_vpfe/Kconfig
+++ b/drivers/staging/media/davinci_vpfe/Kconfig
@@ -1,7 +1,6 @@
 config VIDEO_DM365_VPFE
 	tristate "DM365 VPFE Media Controller Capture Driver"
 	depends on VIDEO_V4L2 && ARCH_DAVINCI_DM365 && !VIDEO_DM365_ISIF
-	depends on HAS_DMA
 	depends on VIDEO_V4L2_SUBDEV_API
 	depends on VIDEO_DAVINCI_VPBE_DISPLAY
 	select VIDEOBUF2_DMA_CONTIG
diff --git a/drivers/staging/media/omap4iss/Kconfig b/drivers/staging/media/omap4iss/Kconfig
index 46183464ee79f896..dbdb1ae82fdab323 100644
--- a/drivers/staging/media/omap4iss/Kconfig
+++ b/drivers/staging/media/omap4iss/Kconfig
@@ -1,7 +1,6 @@
 config VIDEO_OMAP4
 	tristate "OMAP 4 Camera support"
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && I2C && ARCH_OMAP4
-	depends on HAS_DMA
 	select MFD_SYSCON
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
diff --git a/drivers/staging/vc04_services/Kconfig b/drivers/staging/vc04_services/Kconfig
index f5aaf7d629f0fae9..98064ce2c2b47c7f 100644
--- a/drivers/staging/vc04_services/Kconfig
+++ b/drivers/staging/vc04_services/Kconfig
@@ -1,6 +1,5 @@
 menuconfig BCM_VIDEOCORE
 	tristate "Broadcom VideoCore support"
-	depends on HAS_DMA
 	depends on OF
 	depends on RASPBERRYPI_FIRMWARE || (COMPILE_TEST && !RASPBERRYPI_FIRMWARE)
 	default y
diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 3682fd3e960cbd64..a0ea146a2ef5af53 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -115,7 +115,6 @@ config SERIAL_SB1250_DUART_CONSOLE
 
 config SERIAL_ATMEL
 	bool "AT91 on-chip serial port support"
-	depends on HAS_DMA
 	depends on ARCH_AT91 || COMPILE_TEST
 	select SERIAL_CORE
 	select SERIAL_MCTRL_GPIO if GPIOLIB
@@ -586,7 +585,6 @@ config BFIN_UART3_CTSRTS
 
 config SERIAL_IMX
 	tristate "IMX serial port support"
-	depends on HAS_DMA
 	depends on ARCH_MXC || COMPILE_TEST
 	select SERIAL_CORE
 	select RATIONAL
@@ -1436,7 +1434,6 @@ config SERIAL_PCH_UART_CONSOLE
 
 config SERIAL_MXS_AUART
 	tristate "MXS AUART support"
-	depends on HAS_DMA
 	depends on ARCH_MXS || MACH_ASM9260 || COMPILE_TEST
 	select SERIAL_CORE
 	select SERIAL_MCTRL_GPIO if GPIOLIB
@@ -1656,7 +1653,6 @@ config SERIAL_SPRD_CONSOLE
 config SERIAL_STM32
 	tristate "STMicroelectronics STM32 serial port support"
 	select SERIAL_CORE
-	depends on HAS_DMA
 	depends on ARCH_STM32 || COMPILE_TEST
 	help
 	  This driver is for the on-chip Serial Controller on
diff --git a/drivers/usb/gadget/udc/Kconfig b/drivers/usb/gadget/udc/Kconfig
index 1e9567091d86073f..78529854471363c4 100644
--- a/drivers/usb/gadget/udc/Kconfig
+++ b/drivers/usb/gadget/udc/Kconfig
@@ -179,7 +179,7 @@ config USB_R8A66597
 
 config USB_RENESAS_USBHS_UDC
 	tristate 'Renesas USBHS controller'
-	depends on USB_RENESAS_USBHS && HAS_DMA
+	depends on USB_RENESAS_USBHS
 	help
 	   Renesas USBHS is a discrete USB host and peripheral controller chip
 	   that supports both full and high speed USB 2.0 data transfers.
@@ -192,7 +192,7 @@ config USB_RENESAS_USBHS_UDC
 config USB_RENESAS_USB3
 	tristate 'Renesas USB3.0 Peripheral controller'
 	depends on ARCH_RENESAS || COMPILE_TEST
-	depends on EXTCON && HAS_DMA
+	depends on EXTCON
 	help
 	   Renesas USB3.0 Peripheral controller is a USB peripheral controller
 	   that supports super, high, and full speed USB 3.0 data transfers.
diff --git a/drivers/usb/mtu3/Kconfig b/drivers/usb/mtu3/Kconfig
index 25cd61947beea51e..c0c0eb88e5eafc74 100644
--- a/drivers/usb/mtu3/Kconfig
+++ b/drivers/usb/mtu3/Kconfig
@@ -2,7 +2,7 @@
 
 config USB_MTU3
 	tristate "MediaTek USB3 Dual Role controller"
-	depends on EXTCON && (USB || USB_GADGET) && HAS_DMA
+	depends on EXTCON && (USB || USB_GADGET)
 	depends on ARCH_MEDIATEK || COMPILE_TEST
 	select USB_XHCI_MTK if USB_SUPPORT && USB_XHCI_HCD
 	help
diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index 381e9e5c7785c6cc..fd05b1ae9f732c3b 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -2175,7 +2175,8 @@ config FB_XILINX
 
 config FB_GOLDFISH
 	tristate "Goldfish Framebuffer"
-	depends on FB && HAS_DMA && (GOLDFISH || COMPILE_TEST)
+	depends on FB
+	depends on GOLDFISH || COMPILE_TEST
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
diff --git a/sound/soc/bcm/Kconfig b/sound/soc/bcm/Kconfig
index edf367100ebd2f17..02f50b7a966ff262 100644
--- a/sound/soc/bcm/Kconfig
+++ b/sound/soc/bcm/Kconfig
@@ -11,9 +11,8 @@ config SND_BCM2835_SOC_I2S
 config SND_SOC_CYGNUS
 	tristate "SoC platform audio for Broadcom Cygnus chips"
 	depends on ARCH_BCM_CYGNUS || COMPILE_TEST
-	depends on HAS_DMA
 	help
 	  Say Y if you want to add support for ASoC audio on Broadcom
 	  Cygnus chips (bcm958300, bcm958305, bcm911360)
 
-	  If you don't know what to do here, say N.
\ No newline at end of file
+	  If you don't know what to do here, say N.
diff --git a/sound/soc/kirkwood/Kconfig b/sound/soc/kirkwood/Kconfig
index bc3c7b5ac752e471..132bb83f8e99aff3 100644
--- a/sound/soc/kirkwood/Kconfig
+++ b/sound/soc/kirkwood/Kconfig
@@ -1,7 +1,6 @@
 config SND_KIRKWOOD_SOC
 	tristate "SoC Audio for the Marvell Kirkwood and Dove chips"
 	depends on ARCH_DOVE || ARCH_MVEBU || COMPILE_TEST
-	depends on HAS_DMA
 	help
 	  Say Y or M if you want to add support for codecs attached to
 	  the Kirkwood I2S interface. You will also need to select the
diff --git a/sound/soc/pxa/Kconfig b/sound/soc/pxa/Kconfig
index 484ab3c2ad672fc8..960744e46edc0549 100644
--- a/sound/soc/pxa/Kconfig
+++ b/sound/soc/pxa/Kconfig
@@ -1,7 +1,6 @@
 config SND_PXA2XX_SOC
 	tristate "SoC Audio for the Intel PXA2xx chip"
 	depends on ARCH_PXA || COMPILE_TEST
-	depends on HAS_DMA
 	select SND_PXA2XX_LIB
 	help
 	  Say Y or M if you want to add support for codecs attached to
diff --git a/sound/soc/qcom/Kconfig b/sound/soc/qcom/Kconfig
index 8ec9a074b38bd702..c7e05507aec2c28e 100644
--- a/sound/soc/qcom/Kconfig
+++ b/sound/soc/qcom/Kconfig
@@ -11,7 +11,6 @@ config SND_SOC_LPASS_CPU
 
 config SND_SOC_LPASS_PLATFORM
 	tristate
-	depends on HAS_DMA
 	select REGMAP_MMIO
 
 config SND_SOC_LPASS_IPQ806X
@@ -22,13 +21,12 @@ config SND_SOC_LPASS_IPQ806X
 
 config SND_SOC_LPASS_APQ8016
 	tristate
-	depends on HAS_DMA
 	select SND_SOC_LPASS_CPU
 	select SND_SOC_LPASS_PLATFORM
 
 config SND_SOC_STORM
 	tristate "ASoC I2S support for Storm boards"
-	depends on SND_SOC_QCOM && HAS_DMA
+	depends on SND_SOC_QCOM
 	select SND_SOC_LPASS_IPQ806X
 	select SND_SOC_MAX98357A
 	help
@@ -37,7 +35,7 @@ config SND_SOC_STORM
 
 config SND_SOC_APQ8016_SBC
 	tristate "SoC Audio support for APQ8016 SBC platforms"
-	depends on SND_SOC_QCOM && HAS_DMA
+	depends on SND_SOC_QCOM
 	select SND_SOC_LPASS_APQ8016
 	help
           Support for Qualcomm Technologies LPASS audio block in
-- 
2.7.4
