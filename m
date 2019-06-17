From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: fdomain: fix building pcmcia front-end
Date: Mon, 17 Jun 2019 13:19:17 +0200
Message-ID: <20190617111937.2355936-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Ondrej Zary <linux@zary.sk>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We get a warning when CONFIG_SCSI_LOWLEVEL is disabled here:

WARNING: unmet direct dependencies detected for SCSI_FDOMAIN
  Depends on [n]: SCSI_LOWLEVEL [=n] && SCSI [=y]
  Selected by [m]:
  - PCMCIA_FDOMAIN [=m] && SCSI_LOWLEVEL_PCMCIA [=y] && SCSI [=y] && PCMCIA [=y] && m && MODULES [=y]

Move the common support outside of the SCSI_LOWLEVEL section.
Alternatively, we could move all of SCSI_LOWLEVEL_PCMCIA into
SCSI_LOWLEVEL. This would be more sensible, but might cause
surprises for users that have SCSI_LOWLEVEL disabled.

Fixes: 7d47fa065e62 ("scsi: fdomain: Add PCMCIA support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/Kconfig | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 75f66f8ad3ea..dffe4b31e205 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -642,10 +642,6 @@ config SCSI_DMX3191D
 	  To compile this driver as a module, choose M here: the
 	  module will be called dmx3191d.
 
-config SCSI_FDOMAIN
-	tristate
-	depends on SCSI
-
 config SCSI_FDOMAIN_PCI
 	tristate "Future Domain TMC-3260/AHA-2920A PCI SCSI support"
 	depends on PCI && SCSI
@@ -1527,6 +1523,10 @@ endif # SCSI_LOWLEVEL
 
 source "drivers/scsi/pcmcia/Kconfig"
 
+config SCSI_FDOMAIN
+	tristate
+	depends on SCSI
+
 source "drivers/scsi/device_handler/Kconfig"
 
 endmenu
-- 
2.20.0
