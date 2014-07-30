From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/4] libata-scsi: Update SATL for ZAC drives
Date: Wed, 30 Jul 2014 09:55:10 +0200
Message-ID: <1406706911-79510-4-git-send-email-hare@suse.de>
References: <1406706911-79510-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60034 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbaG3HzQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2014 03:55:16 -0400
In-Reply-To: <1406706911-79510-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Hannes Reinecke <hare@suse.de>

ZAC (zoned-access command) drives translate into ZBC (Zoned block
command) device type for SCSI. So implement the correct mappings
into libata-scsi and update the SCSI command set versions.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-scsi.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index bea6e7f..1db6eab 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1969,6 +1969,7 @@ static void ata_scsi_rbuf_fill(struct ata_scsi_args *args,
 static unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf)
 {
 	const u8 versions[] = {
+		0x00,
 		0x60,	/* SAM-3 (no version claimed) */
 
 		0x03,
@@ -1977,6 +1978,20 @@ static unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf)
 		0x02,
 		0x60	/* SPC-3 (no version claimed) */
 	};
+	const u8 versions_zbc[] = {
+		0x00,
+		0xA0,	/* SAM-5 (no version claimed) */
+
+		0x04,
+		0xC0,	/* SBC-3 (no version claimed) */
+
+		0x04,
+		0x60,	/* SPC-4 (no version claimed) */
+
+		0x60,
+		0x20,   /* ZBC (no version claimed) */
+	};
+
 	u8 hdr[] = {
 		TYPE_DISK,
 		0,
@@ -1991,6 +2006,11 @@ static unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf)
 	if (ata_id_removeable(args->id))
 		hdr[1] |= (1 << 7);
 
+	if (args->dev->class == ATA_DEV_ZAC) {
+		hdr[0] = TYPE_ZBC;
+		hdr[2] = 0x6; /* ZBC is defined in SPC-4 */
+	}
+
 	memcpy(rbuf, hdr, sizeof(hdr));
 	memcpy(&rbuf[8], "ATA     ", 8);
 	ata_id_string(args->id, &rbuf[16], ATA_ID_PROD, 16);
@@ -2003,7 +2023,10 @@ static unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf)
 	if (rbuf[32] == 0 || rbuf[32] == ' ')
 		memcpy(&rbuf[32], "n/a ", 4);
 
-	memcpy(rbuf + 59, versions, sizeof(versions));
+	if (args->dev->class == ATA_DEV_ZAC)
+		memcpy(rbuf + 58, versions_zbc, sizeof(versions_zbc));
+	else
+		memcpy(rbuf + 58, versions, sizeof(versions));
 
 	return 0;
 }
-- 
1.7.12.4

