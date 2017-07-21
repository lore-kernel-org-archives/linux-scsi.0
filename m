From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH, RESEND] scsi: lpfc: fix linking against modular NVMe support
Date: Fri, 21 Jul 2017 22:53:46 +0200
Message-ID: <20170721205401.3374331-1-arnd@arndb.de>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Finn Thain <fthain@telegraphics.com.au>, Johannes Thumshirn <jthumshirn@suse.de>, James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
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
Cc: stable@vger.kernel.org
Link: https://patchwork.kernel.org/patch/9636569/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
I originally sent the patch in March 2013, the day after the broken
patch made it into Linux-next. Unfortunately there was some
misunderstanding about it (James Smart thought the broken patch
was the correct version), and my fix never got merged.
---
 drivers/scsi/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index d384f4f86c26..f4538d7a3016 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1230,6 +1230,8 @@ config SCSI_LPFC
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
