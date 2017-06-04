From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/6] libata: clarify log page naming / grouping
Date: Sun,  4 Jun 2017 14:42:22 +0200
Message-ID: <20170604124225.27032-4-hch@lst.de>
References: <20170604124225.27032-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170604124225.27032-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Scott Bauer <scott.bauer@intel.com>, Jonathan Derrick <jonathan.derrick@intel.com>, Rafael Antognolli <rafael.antognolli@intel.com>, Robert Elliott <elliott@hpe.com>, linux-ide@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/ata/libata-core.c | 10 +++++-----
 include/linux/ata.h       | 10 +++++++---
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 0672733997bb..445e7050637b 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2226,7 +2226,7 @@ static void ata_dev_config_ncq_prio(struct ata_device *dev)
 	}
 
 	err_mask = ata_read_log_page(dev,
-				     ATA_LOG_SATA_ID_DEV_DATA,
+				     ATA_LOG_IDENTIFY_DEVICE,
 				     ATA_LOG_SATA_SETTINGS,
 				     ap->sector_buf,
 				     1);
@@ -2346,7 +2346,7 @@ static void ata_dev_config_zac(struct ata_device *dev)
 	if (!(dev->flags & ATA_DFLAG_ZAC))
 		return;
 
-	if (!ata_log_supported(dev, ATA_LOG_SATA_ID_DEV_DATA)) {
+	if (!ata_log_supported(dev, ATA_LOG_IDENTIFY_DEVICE)) {
 		ata_dev_warn(dev, "ATA Identify Device Log not supported\n");
 		return;
 	}
@@ -2355,7 +2355,7 @@ static void ata_dev_config_zac(struct ata_device *dev)
 	 * Read IDENTIFY DEVICE data log, page 0, to figure out
 	 * if page 9 is supported.
 	 */
-	err_mask = ata_read_log_page(dev, ATA_LOG_SATA_ID_DEV_DATA, 0,
+	err_mask = ata_read_log_page(dev, ATA_LOG_IDENTIFY_DEVICE, 0,
 				     identify_buf, 1);
 	if (err_mask) {
 		ata_dev_info(dev,
@@ -2379,7 +2379,7 @@ static void ata_dev_config_zac(struct ata_device *dev)
 	/*
 	 * Read IDENTIFY DEVICE data log, page 9 (Zoned-device information)
 	 */
-	err_mask = ata_read_log_page(dev, ATA_LOG_SATA_ID_DEV_DATA,
+	err_mask = ata_read_log_page(dev, ATA_LOG_IDENTIFY_DEVICE,
 				     ATA_LOG_ZONED_INFORMATION,
 				     identify_buf, 1);
 	if (!err_mask) {
@@ -2608,7 +2608,7 @@ int ata_dev_configure(struct ata_device *dev)
 
 			dev->flags |= ATA_DFLAG_DEVSLP;
 			err_mask = ata_read_log_page(dev,
-						     ATA_LOG_SATA_ID_DEV_DATA,
+						     ATA_LOG_IDENTIFY_DEVICE,
 						     ATA_LOG_SATA_SETTINGS,
 						     sata_setting,
 						     1);
diff --git a/include/linux/ata.h b/include/linux/ata.h
index ad7d9ee89ff0..44de34c954d8 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -336,11 +336,15 @@ enum {
 	/* READ_LOG_EXT pages */
 	ATA_LOG_DIRECTORY	= 0x0,
 	ATA_LOG_SATA_NCQ	= 0x10,
-	ATA_LOG_NCQ_NON_DATA	  = 0x12,
-	ATA_LOG_NCQ_SEND_RECV	  = 0x13,
-	ATA_LOG_SATA_ID_DEV_DATA  = 0x30,
+	ATA_LOG_NCQ_NON_DATA	= 0x12,
+	ATA_LOG_NCQ_SEND_RECV	= 0x13,
+	ATA_LOG_IDENTIFY_DEVICE	= 0x30,
+
+	/* Identify device log pages: */
 	ATA_LOG_SATA_SETTINGS	  = 0x08,
 	ATA_LOG_ZONED_INFORMATION = 0x09,
+
+	/* Identify device SATA settings log:*/
 	ATA_LOG_DEVSLP_OFFSET	  = 0x30,
 	ATA_LOG_DEVSLP_SIZE	  = 0x08,
 	ATA_LOG_DEVSLP_MDAT	  = 0x00,
-- 
2.11.0
