From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] block: fix CDROM dependency on BLK_DEV
Date: Thu,  2 Nov 2017 12:19:32 +0100
Message-ID: <20171102111952.4021454-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bart.vanassche@wdc.com>, Hannes Reinecke <hare@suse.com>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

After the cdrom cleanup, I get randconfig warnings for some configurations:

warning: (BLK_DEV_IDECD && BLK_DEV_SR) selects CDROM which has unmet direct dependencies (BLK_DEV)

This adds an explicit BLK_DEV dependency for both drivers. The other
drivers that select 'CDROM' already have this and don't need a change.

Fixes: 2a750166a5be ("block: Rework drivers/cdrom/Makefile")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/ide/Kconfig  | 1 +
 drivers/scsi/Kconfig | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 7b92c591e4c1..cf1fb3fb5d26 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -117,6 +117,7 @@ config BLK_DEV_DELKIN
 
 config BLK_DEV_IDECD
 	tristate "Include IDE/ATAPI CDROM support"
+	depends on BLK_DEV
 	select IDE_ATAPI
 	select CDROM
 	---help---
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 1f98f666d2ef..8a739b74cfb7 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -130,7 +130,7 @@ config CHR_DEV_OSST
 
 config BLK_DEV_SR
 	tristate "SCSI CDROM support"
-	depends on SCSI
+	depends on SCSI && BLK_DEV
 	select CDROM
 	---help---
 	  If you want to use a CD or DVD drive attached to your computer
-- 
2.9.0
