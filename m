From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/6] libata: support device-managed ZAC devices
Date: Fri, 31 Jul 2015 15:02:07 +0200
Message-ID: <1438347728-106434-6-git-send-email-hare@suse.de>
References: <1438347728-106434-1-git-send-email-hare@suse.de>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1438347728-106434-1-git-send-email-hare@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <james.bottomley@hansenpartnership.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Device-managed ZAC devices just set the zoned capabilities field
in INQUIRY byte 69 (cf ACS-4). This corresponds to the 'zoned'
field in the block device characteristics VPD page.
As this is only defined in SPC-5/SBC-4 we also need to update
the supported SCSI version descriptor.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-scsi.c | 19 ++++++++++---------
 include/linux/ata.h       |  5 +++++
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index e0dede3..a5d1e74 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1987,14 +1987,14 @@ static unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf)
 		0x00,
 		0xA0,	/* SAM-5 (no version claimed) */
 
-		0x04,
-		0xC0,	/* SBC-3 (no version claimed) */
+		0x06,
+		0x00,	/* SBC-4 (no version claimed) */
 
-		0x04,
-		0x60,	/* SPC-4 (no version claimed) */
+		0x05,
+		0xC0,	/* SPC-5 (no version claimed) */
 
 		0x60,
-		0x20,   /* ZBC (no version claimed) */
+		0x22,   /* ZBC r02 */
 	};
 
 	u8 hdr[] = {
@@ -2011,10 +2011,8 @@ static unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf)
 	if (ata_id_removable(args->id))
 		hdr[1] |= (1 << 7);
 
-	if (args->dev->class == ATA_DEV_ZAC) {
+	if (args->dev->class == ATA_DEV_ZAC)
 		hdr[0] = TYPE_ZBC;
-		hdr[2] = 0x6; /* ZBC is defined in SPC-4 */
-	}
 
 	memcpy(rbuf, hdr, sizeof(hdr));
 	memcpy(&rbuf[8], "ATA     ", 8);
@@ -2028,7 +2026,7 @@ static unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf)
 	if (rbuf[32] == 0 || rbuf[32] == ' ')
 		memcpy(&rbuf[32], "n/a ", 4);
 
-	if (args->dev->class == ATA_DEV_ZAC)
+	if (ata_id_zoned_cap(args->id) || args->dev->class == ATA_DEV_ZAC)
 		memcpy(rbuf + 58, versions_zbc, sizeof(versions_zbc));
 	else
 		memcpy(rbuf + 58, versions, sizeof(versions));
@@ -2224,12 +2222,15 @@ static unsigned int ata_scsiop_inq_b1(struct ata_scsi_args *args, u8 *rbuf)
 {
 	int form_factor = ata_id_form_factor(args->id);
 	int media_rotation_rate = ata_id_rotation_rate(args->id);
+	u8 zoned = ata_id_zoned_cap(args->id);
 
 	rbuf[1] = 0xb1;
 	rbuf[3] = 0x3c;
 	rbuf[4] = media_rotation_rate >> 8;
 	rbuf[5] = media_rotation_rate;
 	rbuf[7] = form_factor;
+	if (zoned)
+		rbuf[8] = (zoned << 4);
 
 	return 0;
 }
diff --git a/include/linux/ata.h b/include/linux/ata.h
index ef7b14a..2d604ca 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -900,6 +900,11 @@ static inline bool ata_id_is_ssd(const u16 *id)
 	return id[ATA_ID_ROT_SPEED] == 0x01;
 }
 
+static inline u8 ata_id_zoned_cap(const u16 *id)
+{
+	return (id[ATA_ID_ADDITIONAL_SUPP] & 0x3);
+}
+
 static inline bool ata_id_pio_need_iordy(const u16 *id, const u8 pio)
 {
 	/* CF spec. r4.1 Table 22 says no IORDY on PIO5 and PIO6. */
-- 
1.8.5.2

