From: mathieu.poirier@linaro.org
Subject: [PATCH 7/7] drivers/scsi: some ISA drivers need ISA_DMA_API
Date: Fri, 11 May 2012 16:09:28 -0600
Message-ID: <1336774168-26577-8-git-send-email-mathieu.poirier@linaro.org>
References: <1336774168-26577-1-git-send-email-mathieu.poirier@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1336774168-26577-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: megaraidlinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, mathieu.poirier@linaro.org
List-Id: linux-scsi@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The two options are separate, and some platforms (e.g. arm pxa)
have ISA slots but no ISA dma controller, so they cannot build
drivers using the enable_dma etc functions.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/scsi/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 2f49a00..495feca 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1124,7 +1124,7 @@ config SCSI_IZIP_SLOW_CTR
 
 config SCSI_NCR53C406A
 	tristate "NCR53c406a SCSI support"
-	depends on ISA && SCSI
+	depends on ISA && SCSI && ISA_DMA_API
 	help
 	  This is support for the NCR53c406a SCSI host adapter.  For user
 	  configurable parameters, check out <file:drivers/scsi/NCR53c406a.c>
@@ -1392,7 +1392,7 @@ config SCSI_NCR53C8XX_NO_DISCONNECT
 
 config SCSI_PAS16
 	tristate "PAS16 SCSI support"
-	depends on ISA && SCSI
+	depends on ISA && ISA_DMA_API && SCSI
 	select SCSI_SPI_ATTRS
 	---help---
 	  This is support for a SCSI host adapter.  It is explained in section
@@ -1406,7 +1406,7 @@ config SCSI_PAS16
 
 config SCSI_QLOGIC_FAS
 	tristate "Qlogic FAS SCSI support"
-	depends on ISA && SCSI
+	depends on ISA && SCSI && ISA_DMA_API
 	---help---
 	  This is a driver for the ISA, VLB, and PCMCIA versions of the Qlogic
 	  FastSCSI! cards as well as any other card based on the FASXX chip
-- 
1.7.5.4
