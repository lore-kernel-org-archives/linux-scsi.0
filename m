From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH B] scsi: fdomain: fix building pcmcia front-end
Date: Mon, 22 Jul 2019 14:19:08 +0200
Message-ID: <20190722121908.163702-2-arnd@arndb.de>
References: <20190722121908.163702-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190722121908.163702-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Ondrej Zary <linux@zary.sk>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-scsi@vger.kernel.org

We get a warning when CONFIG_SCSI_LOWLEVEL is disabled here:

WARNING: unmet direct dependencies detected for SCSI_FDOMAIN
  Depends on [n]: SCSI_LOWLEVEL [=n] && SCSI [=y]
  Selected by [m]:
  - PCMCIA_FDOMAIN [=m] && SCSI_LOWLEVEL_PCMCIA [=y] && SCSI [=y] && PCMCIA [=y] && m && MODULES [=y]

Move all of SCSI_LOWLEVEL_PCMCIA inside of the existing
SCSI_LOWLEVEL section. Very few people use the PCMCIA support
these days, and they likely don't mind having to turn on
SCSI_LOWLEVEL as well. This way we avoid the link error
and get a more sensible structure.

Fixes: 7d47fa065e62 ("scsi: fdomain: Add PCMCIA support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
One of two ways to fix the problem, please pick either

 drivers/scsi/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 75f66f8ad3ea..1b92f3c19ff3 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1523,10 +1523,10 @@ config SCSI_VIRTIO
 
 source "drivers/scsi/csiostor/Kconfig"
 
-endif # SCSI_LOWLEVEL
-
 source "drivers/scsi/pcmcia/Kconfig"
 
+endif # SCSI_LOWLEVEL
+
 source "drivers/scsi/device_handler/Kconfig"
 
 endmenu
-- 
2.20.0
