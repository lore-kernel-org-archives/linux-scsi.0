From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 06/14] libata: Check log page directory before accessing pages
Date: Tue, 12 Apr 2016 08:47:50 +0200
Message-ID: <1460443678-57934-7-git-send-email-hare@suse.de>
References: <1460443678-57934-1-git-send-email-hare@suse.de>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1460443678-57934-1-git-send-email-hare@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

When reading the NCQ Send/Recv log it might actually not
supported, thereby causing irritating messages
'READ LOG DMA EXT failed'.
Instead we should be reading the log directory first to
figure out if the log is actually supported before trying
to access it.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/ata/libata-core.c | 17 +++++++++++++++++
 include/linux/ata.h       |  1 +
 2 files changed, 18 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index f48f152..cfde6bc 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -66,6 +66,7 @@
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
 #include <asm/byteorder.h>
+#include <asm/unaligned.h>
 #include <linux/cdrom.h>
 #include <linux/ratelimit.h>
 #include <linux/pm_runtime.h>
@@ -2083,7 +2084,23 @@ static void ata_dev_config_ncq_send_recv(struct ata_device *dev)
 {
 	struct ata_port *ap = dev->link->ap;
 	unsigned int err_mask;
+	int log_index = ATA_LOG_NCQ_SEND_RECV * 2;
+	u16 log_pages;
 
+	err_mask = ata_read_log_page(dev, ATA_LOG_DIRECTORY,
+				     0, ap->sector_buf, 1, true);
+	if (err_mask) {
+		ata_dev_dbg(dev,
+			    "failed to get Log Directory Emask 0x%x\n",
+			    err_mask);
+		return;
+	}
+	log_pages = get_unaligned_le16(&ap->sector_buf[log_index]);
+	if (!log_pages) {
+		ata_dev_warn(dev,
+			     "NCQ Send/Recv Log not supported\n");
+		return;
+	}
 	err_mask = ata_read_log_page(dev, ATA_LOG_NCQ_SEND_RECV,
 				     0, ap->sector_buf, 1, true);
 	if (err_mask) {
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 94ccde5..b5be5e8 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -314,6 +314,7 @@ enum {
 	ATA_SUBCMD_FPDMA_SEND_WR_LOG_DMA_EXT = 0x02,
 
 	/* READ_LOG_EXT pages */
+	ATA_LOG_DIRECTORY	= 0x0,
 	ATA_LOG_SATA_NCQ	= 0x10,
 	ATA_LOG_NCQ_SEND_RECV	  = 0x13,
 	ATA_LOG_SATA_ID_DEV_DATA  = 0x30,
-- 
1.8.5.6

