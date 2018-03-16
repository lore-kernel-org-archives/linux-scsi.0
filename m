From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH v2 17/21] scsi: hisi_sas: Remove depends on HAS_DMA in case of platform dependency
Date: Fri, 16 Mar 2018 14:51:50 +0100
Message-ID: <1521208314-4783-18-git-send-email-geert@linux-m68k.org>
References: <1521208314-4783-1-git-send-email-geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521208314-4783-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Felipe Balbi <balbi@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>, Tejun Heo <tj@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Alan Tull <atull@kernel.org>, Moritz Fischer <mdf@kernel.org>, Wolfram Sang <wsa@the-dreams.de>, Jonathan Cameron <jic23@kernel.org>, Joe
Cc: iommu@lists.linux-foundation.org, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, alsa-devel@alsa-project.org, linux-ide@vger.kernel.org, linux-crypto@vger.kernel.org, linux-fbdev@vger.kernel.org, linux1394-devel@lists.sourceforge.net, linux-fpga@vger.kernel.org, linux-i2c@vger.kernel.org, linux-iio@vger.kernel.org, linux-block@vger.kernel.org, linux-media@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org, netdev@vger.kernel.org, linux-remoteproc@vger.kernel.org, linux-serial@vger.kernel.org, linux-spi@vger.kernel.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Remove dependencies on HAS_DMA where a Kconfig symbol depends on another
symbol that implies HAS_DMA, and, optionally, on "|| COMPILE_TEST".
In most cases this other symbol is an architecture or platform specific
symbol, or PCI.

Generic symbols and drivers without platform dependencies keep their
dependencies on HAS_DMA, to prevent compiling subsystems or drivers that
cannot work anyway.

This simplifies the dependencies, and allows to improve compile-testing.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Acked-by: Robin Murphy <robin.murphy@arm.com>
---
v2:
  - Add Reviewed-by, Acked-by,
  - Drop RFC state,
  - Split per subsystem.
---
 drivers/scsi/hisi_sas/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
-- 
2.7.4
