From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: qedi: select UIO
Date: Tue, 10 Jan 2017 16:27:29 +0100
Message-ID: <20170110152744.3139180-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, QLogic-Storage-Upstream@cavium.com, Johannes Thumshirn <jthumshirn@suse.de>, Nilesh Javali <nilesh.javali@cavium.com>, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>, Manish Rangankar <manish.rangankar@cavium.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The newly added qedi driver links against the UIO framework, but can
be built without that:

drivers/scsi/qedi/qedi_main.o: In function `qedi_free_uio':
qedi_main.c:(.text.qedi_free_uio+0x78): undefined reference to `uio_unregister_device'
drivers/scsi/qedi/qedi_main.o: In function `qedi_ll2_recv_thread':
qedi_main.c:(.text.qedi_ll2_recv_thread+0x18c): undefined reference to `uio_event_notify'
drivers/scsi/qedi/qedi_main.o: In function `__qedi_probe.constprop.1':
qedi_main.c:(.text.__qedi_probe.constprop.1+0x1368): undefined reference to `__uio_register_device'

This adds a compile-time dependency.

Fixes: ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI driver framework.")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/qedi/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qedi/Kconfig b/drivers/scsi/qedi/Kconfig
index 23ca8a274586..913610f3d274 100644
--- a/drivers/scsi/qedi/Kconfig
+++ b/drivers/scsi/qedi/Kconfig
@@ -2,6 +2,7 @@ config QEDI
 	tristate "QLogic QEDI 25/40/100Gb iSCSI Initiator Driver Support"
 	depends on PCI && SCSI
 	depends on QED
+	depends on UIO
 	select SCSI_ISCSI_ATTRS
 	select QED_LL2
 	select QED_ISCSI
-- 
2.9.0
