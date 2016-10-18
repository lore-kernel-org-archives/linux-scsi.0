From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: g_NCR5380: add HAS_IOPORT_MAP dependency
Date: Tue, 18 Oct 2016 17:18:06 +0200
Message-ID: <20161018151827.2729976-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Ondrej Zary <linux@rainbow-software.org>, Finn Thain <fthain@telegraphics.com.au>, Arnd Bergmann <arnd@arndb.de>, Hannes Reinecke <hare@suse.com>, Hannes Reinicke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The driver was changed to call ioport_map, which breaks platforms that
cannot provide this function:

drivers/scsi/g_NCR5380.o: In function `generic_NCR5380_init_one.constprop.0':
g_NCR5380.c:(.text.generic_NCR5380_init_one.constprop.0+0x388): undefined reference to `ioport_map'

This adds a Kconfig dependency.

Fixes: 04c40f82ccc5 ("scsi: g_NCR5380: Merge g_NCR5380 and g_NCR5380_mmio drivers")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 98451fe031a4..3b416c9efe5e 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -744,7 +744,7 @@ config SCSI_ISCI
 
 config SCSI_GENERIC_NCR5380
 	tristate "Generic NCR5380/53c400 SCSI ISA card support"
-	depends on ISA && SCSI
+	depends on ISA && SCSI && HAS_IOPORT_MAP
 	select SCSI_SPI_ATTRS
 	---help---
 	  This is a driver for old ISA card SCSI controllers based on a
-- 
2.9.0
