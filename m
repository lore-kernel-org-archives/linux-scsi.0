From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: myrs: only build on little-endian platforms
Date: Fri,  2 Nov 2018 16:47:23 +0100
Message-ID: <20181102154740.2011289-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Reading throught the new driver, I noticed that this cannot work on
big-endian CPUs, and the old DAC960 had exactly the same behavior.

To document this for the future, add a Kconfig dependency that prevents it
from being included in big-endian kernels.  Since the hardware is really
old and we never had a working driver on it for big-endian platforms,
it's unlikely to make a difference to users.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index f07444d30b21..640cd1b31a18 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -578,6 +578,7 @@ config SCSI_MYRB
 config SCSI_MYRS
 	tristate "Mylex DAC960/DAC1100 PCI RAID Controller (SCSI Interface)"
 	depends on PCI
+	depends on !CPU_BIG_ENDIAN || COMPILE_TEST
 	select RAID_ATTRS
 	help
 	  This driver adds support for the Mylex DAC960, AcceleRAID, and
-- 
2.18.0
