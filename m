From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 7/7] scsi_dh: force modular build if SCSI is a module
Date: Wed, 27 Jan 2016 16:57:23 +0100
Message-ID: <1453910247-3447628-8-git-send-email-arnd@arndb.de>
References: <1453910247-3447628-1-git-send-email-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1453910247-3447628-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, James.Bottomley@HansenPartnership.com
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@odin.com>, Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When the scsi_dh core was moved into the scsi core module,
CONFIG_SCSI_DH became a 'bool' option, and now anything depending
on it can be built-in even when CONFIG_SCSI=m. This of course
cannot link successfully:

drivers/scsi/built-in.o: In function `rdac_init':
scsi_dh_alua.c:(.init.text+0x14): undefined reference to `scsi_register_device_handler'
scsi_dh_alua.c:(.init.text+0x64): undefined reference to `scsi_unregister_device_handler'
drivers/scsi/built-in.o: In function `alua_init':
scsi_dh_alua.c:(.init.text+0xb0): undefined reference to `scsi_register_device_handler'

As a workaround, this adds an extra dependency on CONFIG_SCSI,
so Kconfig can figure out whether built-in is allowed or not.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 086b91d052eb ("scsi_dh: integrate into the core SCSI code")
---
 drivers/scsi/device_handler/Kconfig | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/device_handler/Kconfig b/drivers/scsi/device_handler/Kconfig
index e5647d59224f..0b331c9c0a8f 100644
--- a/drivers/scsi/device_handler/Kconfig
+++ b/drivers/scsi/device_handler/Kconfig
@@ -13,13 +13,13 @@ menuconfig SCSI_DH
 
 config SCSI_DH_RDAC
 	tristate "LSI RDAC Device Handler"
-	depends on SCSI_DH
+	depends on SCSI_DH && SCSI
 	help
 	If you have a LSI RDAC select y. Otherwise, say N.
 
 config SCSI_DH_HP_SW
 	tristate "HP/COMPAQ MSA Device Handler"
-	depends on SCSI_DH
+	depends on SCSI_DH && SCSI
 	help
 	If you have a HP/COMPAQ MSA device that requires START_STOP to
 	be sent to start it and cannot upgrade the firmware then select y.
@@ -27,13 +27,13 @@ config SCSI_DH_HP_SW
 
 config SCSI_DH_EMC
 	tristate "EMC CLARiiON Device Handler"
-	depends on SCSI_DH
+	depends on SCSI_DH && SCSI
 	help
 	If you have a EMC CLARiiON select y. Otherwise, say N.
 
 config SCSI_DH_ALUA
 	tristate "SPC-3 ALUA Device Handler"
-	depends on SCSI_DH
+	depends on SCSI_DH && SCSI
 	help
 	  SCSI Device handler for generic SPC-3 Asymmetric Logical Unit
 	  Access (ALUA).
-- 
2.7.0
