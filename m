From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: qedi: select CONFIG_ISCSI_BOOT_SYSFS
Date: Fri, 21 Jul 2017 18:11:25 +0200
Message-ID: <20170721161139.3330251-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@cavium.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Saurav Kashyap <saurav.kashyap@cavium.com>, Manish Rangankar <manish.rangankar@cavium.com>, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Without the base library support, we get a link failure

drivers/scsi/qedi/qedi_main.o: In function `__qedi_probe.constprop.0':
qedi_main.c:(.text+0x2d8e): undefined reference to `iscsi_boot_create_target'
qedi_main.c:(.text+0x2dee): undefined reference to `iscsi_boot_create_initiator'
qedi_main.c:(.text+0x2e1c): undefined reference to `iscsi_boot_create_ethernet'

This selects the Kconfig symbol like the other two users of that
module do.

Fixes: c57ec8fb7c02 ("scsi: qedi: Add support for Boot from SAN over iSCSI offload")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/qedi/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qedi/Kconfig b/drivers/scsi/qedi/Kconfig
index 21331453db7b..8deb8723c4dd 100644
--- a/drivers/scsi/qedi/Kconfig
+++ b/drivers/scsi/qedi/Kconfig
@@ -2,6 +2,7 @@ config QEDI
 	tristate "QLogic QEDI 25/40/100Gb iSCSI Initiator Driver Support"
 	depends on PCI && SCSI && UIO
 	depends on QED
+	select ISCSI_BOOT_SYSFS
 	select SCSI_ISCSI_ATTRS
 	select QED_LL2
 	select QED_ISCSI
-- 
2.9.0
