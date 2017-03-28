From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: hisi_sas: fix SATA dependency
Date: Tue, 28 Mar 2017 16:22:03 +0200
Message-ID: <20170328142212.1816773-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Xiang Chen <chenxiang66@hisilicon.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Removing the 'select SCSI_SAS_LIBSAS' statement in Kconfig resulted
in a link failure in configurations that have hisi_sas built-in
but libsas as a loadable module:

drivers/scsi/built-in.o: In function `hisi_sas_scan_finished':
hisi_sas_main.c:(.text+0x37ce9): undefined reference to `sas_drain_work'
drivers/scsi/built-in.o: In function `hisi_sas_slave_configure':
hisi_sas_main.c:(.text+0x37d17): undefined reference to `sas_slave_configure'
hisi_sas_main.c:(.text+0x37d40): undefined reference to `sas_change_queue_depth'
drivers/scsi/built-in.o: In function `hisi_sas_remove':

All other libsas users have the 'select' statement, so we should do the
same here for consistency. For all I can tell, the patch that added
the sata softreset does not actually introduce a dependency on SCSI_SAS_ATA
but instead adds calls into libata itself, so we can express that with
a more specific dependency.

We cannot have 'select SCSI_SAS_LIBSAS; depends on SCSI_SAS_ATA' as that
would cause a dependency loop.

Fixes: 7c594f0407de ("scsi: hisi_sas: add softreset function for SATA disk")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/hisi_sas/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/Kconfig b/drivers/scsi/hisi_sas/Kconfig
index ded2c201071d..374a329b91fc 100644
--- a/drivers/scsi/hisi_sas/Kconfig
+++ b/drivers/scsi/hisi_sas/Kconfig
@@ -2,7 +2,8 @@ config SCSI_HISI_SAS
 	tristate "HiSilicon SAS"
 	depends on HAS_DMA && HAS_IOMEM
 	depends on ARM64 || COMPILE_TEST
-	depends on SCSI_SAS_ATA
+	select SCSI_SAS_LIBSAS
 	select BLK_DEV_INTEGRITY
+	depends on ATA
 	help
 		This driver supports HiSilicon's SAS HBA
-- 
2.9.0
