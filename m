From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 2/6] libata: Report supported TRIM payload size
Date: Thu, 19 Aug 2010 11:48:57 -0400
Message-ID: <1282232941-9910-3-git-send-email-martin.petersen@oracle.com>
References: <1282232941-9910-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1282232941-9910-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

ATA IDENTIFY DEVICE word 105 contains the number of 512-byte blocks of
TRIM payload information the device can accept in one command.  Use this
value to enable payloads > 512 bytes.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/ata/libata-scsi.c |    7 ++++++-
 include/linux/ata.h       |    9 +++++++++
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index e280ae6..145f099 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2152,7 +2152,12 @@ static unsigned int ata_scsiop_inq_b0(struct ata_scsi_args *args, u8 *rbuf)
 	 * with the unmap bit set.
 	 */
 	if (ata_id_has_trim(args->id)) {
-		put_unaligned_be32(65535 * 512 / 8, &rbuf[20]);
+		unsigned int blocks;
+
+		/* Default to 1 if unspecified in word 105.  Cap at 1 page. */
+		blocks = clamp(ata_id_trim_range_blocks(args->id), 1U, 8U);
+
+		put_unaligned_be32(65535 * 512 / 8 * blocks, &rbuf[20]);
 		put_unaligned_be32(1, &rbuf[28]);
 	}
 
diff --git a/include/linux/ata.h b/include/linux/ata.h
index fe6e681..5584356 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -88,6 +88,7 @@ enum {
 	ATA_ID_HW_CONFIG	= 93,
 	ATA_ID_SPG		= 98,
 	ATA_ID_LBA_CAPACITY_2	= 100,
+	ATA_ID_TRIM_RANGE_BLKS	= 105,
 	ATA_ID_SECTOR_SIZE	= 106,
 	ATA_ID_LAST_LUN		= 126,
 	ATA_ID_DLF		= 128,
@@ -827,6 +828,14 @@ static inline int ata_id_has_zero_after_trim(const u16 *id)
 	return 0;
 }
 
+static inline unsigned int ata_id_trim_range_blocks(const u16 *id)
+{
+	if (ata_id_has_trim(id))
+		return id[ATA_ID_TRIM_RANGE_BLKS];
+
+	return 0;
+}
+
 static inline int ata_id_current_chs_valid(const u16 *id)
 {
 	/* For ATA-1 devices, if the INITIALIZE DEVICE PARAMETERS command
-- 
1.7.2.1

