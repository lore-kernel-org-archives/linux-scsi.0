From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: lpfc: fix linking against modular NVMe support
Date: Tue, 21 Mar 2017 14:09:05 +0100
Message-ID: <20170321131017.2207105-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Hannes Reinecke <hare@suse.de>, Finn Thain <fthain@telegraphics.com.au>, Johannes Thumshirn <jthumshirn@suse.de>, James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When LPFC is built-in but NVMe is a loadable module, we fail to
link the kernel:

drivers/scsi/built-in.o: In function `lpfc_nvme_create_localport':
(.text+0x156a82): undefined reference to `nvme_fc_register_localport'
drivers/scsi/built-in.o: In function `lpfc_nvme_destroy_localport':
(.text+0x156eaa): undefined reference to `nvme_fc_unregister_remoteport'

We can avoid this either by forcing lpfc to be a module, or by disabling
NVMe support in this case. This implements the former.

Fixes: 7d7080335f8d ("scsi: lpfc: Finalize Kconfig options for nvme")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 3c52867dfe28..d145e0d90227 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1241,6 +1241,8 @@ config SCSI_LPFC
 	tristate "Emulex LightPulse Fibre Channel Support"
 	depends on PCI && SCSI
 	depends on SCSI_FC_ATTRS
+	depends on NVME_TARGET_FC || NVME_TARGET_FC=n
+	depends on NVME_FC || NVME_FC=n
 	select CRC_T10DIF
 	---help---
           This lpfc driver supports the Emulex LightPulse
-- 
2.9.0
