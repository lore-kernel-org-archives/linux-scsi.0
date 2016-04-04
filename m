From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/4] libata: support device-managed ZAC devices
Date: Mon,  4 Apr 2016 11:47:50 +0200
Message-ID: <1459763271-125856-4-git-send-email-hare@suse.de>
References: <1459763271-125856-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59595 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754788AbcDDJr4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Apr 2016 05:47:56 -0400
In-Reply-To: <1459763271-125856-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.de>

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
index 6db2aaf..ff95ef6 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2076,14 +2076,14 @@ static unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf)
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
+		0x24,   /* ZBC r05 */
 	};
 
 	u8 hdr[] = {
@@ -2103,10 +2103,8 @@ static unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf)
 	    (args->dev->link->ap->pflags & ATA_PFLAG_EXTERNAL))
 		hdr[1] |= (1 << 7);
 
-	if (args->dev->class == ATA_DEV_ZAC) {
+	if (args->dev->class == ATA_DEV_ZAC)
 		hdr[0] = TYPE_ZBC;
-		hdr[2] = 0x6; /* ZBC is defined in SPC-4 */
-	}
 
 	memcpy(rbuf, hdr, sizeof(hdr));
 	memcpy(&rbuf[8], "ATA     ", 8);
@@ -2120,7 +2118,7 @@ static unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf)
 	if (rbuf[32] == 0 || rbuf[32] == ' ')
 		memcpy(&rbuf[32], "n/a ", 4);
 
-	if (args->dev->class == ATA_DEV_ZAC)
+	if (ata_id_zoned_cap(args->id) || args->dev->class == ATA_DEV_ZAC)
 		memcpy(rbuf + 58, versions_zbc, sizeof(versions_zbc));
 	else
 		memcpy(rbuf + 58, versions, sizeof(versions));
@@ -2316,12 +2314,15 @@ static unsigned int ata_scsiop_inq_b1(struct ata_scsi_args *args, u8 *rbuf)
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
index eef9d80..4ad7363 100644
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
1.8.5.6

