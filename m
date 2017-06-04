From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/6] libata: factor out a ata_log_supported helper
Date: Sun,  4 Jun 2017 14:42:21 +0200
Message-ID: <20170604124225.27032-3-hch@lst.de>
References: <20170604124225.27032-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:47015 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751186AbdFDMmg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Jun 2017 08:42:36 -0400
In-Reply-To: <20170604124225.27032-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Scott Bauer <scott.bauer@intel.com>, Jonathan Derrick <jonathan.derrick@intel.com>, Rafael Antognolli <rafael.antognolli@intel.com>, Robert Elliott <elliott@hpe.com>, linux-ide@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/ata/libata-core.c | 59 +++++++++++++----------------------------------
 1 file changed, 16 insertions(+), 43 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index d4bab5052268..0672733997bb 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2111,6 +2111,15 @@ unsigned int ata_read_log_page(struct ata_device *dev, u8 log,
 	return err_mask;
 }
 
+static bool ata_log_supported(struct ata_device *dev, u8 log)
+{
+	struct ata_port *ap = dev->link->ap;
+
+	if (ata_read_log_page(dev, ATA_LOG_DIRECTORY, 0, ap->sector_buf, 1))
+		return false;
+	return get_unaligned_le16(&ap->sector_buf[log * 2]) ? true : false;
+}
+
 static int ata_do_link_spd_horkage(struct ata_device *dev)
 {
 	struct ata_link *plink = ata_dev_phys_link(dev);
@@ -2158,21 +2167,9 @@ static void ata_dev_config_ncq_send_recv(struct ata_device *dev)
 {
 	struct ata_port *ap = dev->link->ap;
 	unsigned int err_mask;
-	int log_index = ATA_LOG_NCQ_SEND_RECV * 2;
-	u16 log_pages;
 
-	err_mask = ata_read_log_page(dev, ATA_LOG_DIRECTORY,
-				     0, ap->sector_buf, 1);
-	if (err_mask) {
-		ata_dev_dbg(dev,
-			    "failed to get Log Directory Emask 0x%x\n",
-			    err_mask);
-		return;
-	}
-	log_pages = get_unaligned_le16(&ap->sector_buf[log_index]);
-	if (!log_pages) {
-		ata_dev_warn(dev,
-			     "NCQ Send/Recv Log not supported\n");
+	if (!ata_log_supported(dev, ATA_LOG_NCQ_SEND_RECV)) {
+		ata_dev_warn(dev, "NCQ Send/Recv Log not supported\n");
 		return;
 	}
 	err_mask = ata_read_log_page(dev, ATA_LOG_NCQ_SEND_RECV,
@@ -2199,19 +2196,8 @@ static void ata_dev_config_ncq_non_data(struct ata_device *dev)
 {
 	struct ata_port *ap = dev->link->ap;
 	unsigned int err_mask;
-	int log_index = ATA_LOG_NCQ_NON_DATA * 2;
-	u16 log_pages;
 
-	err_mask = ata_read_log_page(dev, ATA_LOG_DIRECTORY,
-				     0, ap->sector_buf, 1);
-	if (err_mask) {
-		ata_dev_dbg(dev,
-			    "failed to get Log Directory Emask 0x%x\n",
-			    err_mask);
-		return;
-	}
-	log_pages = get_unaligned_le16(&ap->sector_buf[log_index]);
-	if (!log_pages) {
+	if (!ata_log_supported(dev, ATA_LOG_NCQ_NON_DATA)) {
 		ata_dev_warn(dev,
 			     "NCQ Send/Recv Log not supported\n");
 		return;
@@ -2339,7 +2325,7 @@ static void ata_dev_config_zac(struct ata_device *dev)
 	struct ata_port *ap = dev->link->ap;
 	unsigned int err_mask;
 	u8 *identify_buf = ap->sector_buf;
-	int log_index = ATA_LOG_SATA_ID_DEV_DATA * 2, i, found = 0;
+	int i, found = 0;
 	u16 log_pages;
 
 	dev->zac_zones_optimal_open = U32_MAX;
@@ -2360,24 +2346,11 @@ static void ata_dev_config_zac(struct ata_device *dev)
 	if (!(dev->flags & ATA_DFLAG_ZAC))
 		return;
 
-	/*
-	 * Read Log Directory to figure out if IDENTIFY DEVICE log
-	 * is supported.
-	 */
-	err_mask = ata_read_log_page(dev, ATA_LOG_DIRECTORY,
-				     0, ap->sector_buf, 1);
-	if (err_mask) {
-		ata_dev_info(dev,
-			     "failed to get Log Directory Emask 0x%x\n",
-			     err_mask);
-		return;
-	}
-	log_pages = get_unaligned_le16(&ap->sector_buf[log_index]);
-	if (log_pages == 0) {
-		ata_dev_warn(dev,
-			     "ATA Identify Device Log not supported\n");
+	if (!ata_log_supported(dev, ATA_LOG_SATA_ID_DEV_DATA)) {
+		ata_dev_warn(dev, "ATA Identify Device Log not supported\n");
 		return;
 	}
+
 	/*
 	 * Read IDENTIFY DEVICE data log, page 0, to figure out
 	 * if page 9 is supported.
-- 
2.11.0
