From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH v3 4/7] libata: detech Device Attention support
Date: Wed, 28 Mar 2012 14:21:59 +0800
Message-ID: <1332915722-15963-5-git-send-email-ming.m.lin@intel.com>
References: <1332915722-15963-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1332915722-15963-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, Aaron Lu <aaron.lu@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Add a new flag ATA_DFLAG_DA to indicate that device supports "Device
Attention".

Acked-by: Aaron Lu <aaron.lu@amd.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/ata/libata-core.c |    3 +++
 include/linux/ata.h       |    1 +
 include/linux/libata.h    |    2 ++
 3 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 6742cc4..2a10701 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2368,6 +2368,9 @@ int ata_dev_configure(struct ata_device *dev)
 			dma_dir_string = ", DMADIR";
 		}
 
+		if (atapi_id_has_da(dev->id))
+			dev->flags |= ATA_DFLAG_DA;
+
 		/* print device info to dmesg */
 		if (ata_msg_drv(ap) && print_info)
 			ata_dev_info(dev,
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 32df2b6..6ee41cc 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -578,6 +578,7 @@ static inline int ata_is_data(u8 prot)
 	  ((u64) (id)[(n) + 0]) )
 
 #define ata_id_cdb_intr(id)	(((id)[ATA_ID_CONFIG] & 0x60) == 0x20)
+#define atapi_id_has_da(id)	((id)[77] & (1 << 4))
 
 static inline bool ata_id_has_hipm(const u16 *id)
 {
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 36970c6..3085bdc 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -161,6 +161,8 @@ enum {
 	ATA_DFLAG_DETACH	= (1 << 24),
 	ATA_DFLAG_DETACHED	= (1 << 25),
 
+	ATA_DFLAG_DA		= (1 << 26), /* device supports Device Attention */
+
 	ATA_DEV_UNKNOWN		= 0,	/* unknown device */
 	ATA_DEV_ATA		= 1,	/* ATA device */
 	ATA_DEV_ATA_UNSUP	= 2,	/* ATA device (unsupported) */
-- 
1.7.2.5
