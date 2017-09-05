From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: scsi_transport_sas: select BLK_DEV_BSGLIB
Date: Tue,  5 Sep 2017 09:49:23 +0200
Message-ID: <20170905074956.469733-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Arnd Bergmann <arnd@arndb.de>, Hannes Reinicke <hare@suse.de>, Finn Thain <fthain@telegraphics.com.au>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Without CONFIG_BLK_DEV_BSGLIB, we get a link error here:

drivers/scsi/scsi_transport_sas.o: In function `sas_bsg_initialize':
scsi_transport_sas.c:(.text+0xcc0): undefined reference to `bsg_setup_queue'
scsi_transport_sas.c:(.text+0xd10): undefined reference to `bsg_setup_queue'
drivers/scsi/scsi_transport_sas.o: In function `sas_smp_dispatch':
scsi_transport_sas.c:(.text+0xe8c): undefined reference to `bsg_job_done'

This modifies the Kconfig 'select' statement accordingly, and matching
what we do for the other two scsi_transport implementations that use
bsglib.

Fixes: 651a01364994 ("scsi: scsi_transport_sas: switch to bsg-lib for SMP passthrough")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index d145e0d90227..41366339b950 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -283,7 +283,7 @@ config SCSI_ISCSI_ATTRS
 config SCSI_SAS_ATTRS
 	tristate "SAS Transport Attributes"
 	depends on SCSI
-	select BLK_DEV_BSG
+	select BLK_DEV_BSGLIB
 	help
 	  If you wish to export transport-specific information about
 	  each attached SAS device to sysfs, say Y.
-- 
2.9.0
