From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 13/13] libata: Media rotation rate and form factor heuristics
Date: Fri, 15 May 2009 00:40:35 -0400
Message-ID: <1242362435-11953-14-git-send-email-martin.petersen@oracle.com>
References: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-ide-owner@vger.kernel.org
To: rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, jens.axboe@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

From: Martin K. Petersen <martin.petersen@oracle.com>

This patch delegates setting the queue NONROT flag to SCSI.

It also provides new heuristics for parsing both the form factor and
media rotation rate ATA IDENFITY words.

The reported ATA version must be 7 or greater and the device must return
values defined as valid in the standard.  Only then are the
characteristics reported to SCSI via the VPD B1 page.

This seems like a reasonable compromise to me considering that we have
been shipping several kernel releases that key off the rotation rate bit
without any version checking whatsoever.  With no complaints so far.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/ata/libata-scsi.c |   15 ++++++---------
 include/linux/ata.h       |   28 ++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 5072003..0244846 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1119,10 +1119,6 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
 
 		blk_queue_dma_drain(q, atapi_drain_needed, buf, ATAPI_MAX_DRAIN);
 	} else {
-		if (ata_id_is_ssd(dev->id))
-			queue_flag_set_unlocked(QUEUE_FLAG_NONROT,
-						sdev->request_queue);
-
 		/* ATA devices must be sector aligned */
 		blk_queue_update_dma_alignment(sdev->request_queue,
 					       ATA_SECT_SIZE - 1);
@@ -2142,13 +2138,14 @@ static unsigned int ata_scsiop_inq_89(struct ata_scsi_args *args, u8 *rbuf)
 
 static unsigned int ata_scsiop_inq_b1(struct ata_scsi_args *args, u8 *rbuf)
 {
+	int form_factor = ata_id_form_factor(args->id);
+	int media_rotation_rate = ata_id_rotation_rate(args->id);
+
 	rbuf[1] = 0xb1;
 	rbuf[3] = 0x3c;
-	if (ata_id_major_version(args->id) > 7) {
-		rbuf[4] = args->id[217] >> 8;
-		rbuf[5] = args->id[217];
-		rbuf[7] = args->id[168] & 0xf;
-	}
+	rbuf[4] = media_rotation_rate >> 8;
+	rbuf[5] = media_rotation_rate;
+	rbuf[7] = form_factor;
 
 	return 0;
 }
diff --git a/include/linux/ata.h b/include/linux/ata.h
index cb79b7a..915da43 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -730,6 +730,34 @@ static inline int ata_id_has_unload(const u16 *id)
 	return 0;
 }
 
+static inline int ata_id_form_factor(const u16 *id)
+{
+	u16 val = id[168];
+
+	if (ata_id_major_version(id) < 7 || val == 0 || val == 0xffff)
+		return 0;
+
+	val &= 0xf;
+
+	if (val > 5)
+		return 0;
+
+	return val;
+}
+
+static inline int ata_id_rotation_rate(const u16 *id)
+{
+	u16 val = id[217];
+
+	if (ata_id_major_version(id) < 7 || val == 0 || val == 0xffff)
+		return 0;
+
+	if (val > 1 && val < 0x401)
+		return 0;
+
+	return val;
+}
+
 static inline int ata_id_has_trim(const u16 *id)
 {
 	if (ata_id_major_version(id) >= 7 &&
-- 
1.6.0.6

