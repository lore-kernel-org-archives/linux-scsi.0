From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/14] libata-scsi: generate correct ATA pass-through sense
Date: Mon,  4 Apr 2016 11:44:02 +0200
Message-ID: <1459763047-125551-10-git-send-email-hare@suse.de>
References: <1459763047-125551-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59391 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755111AbcDDJoZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Apr 2016 05:44:25 -0400
In-Reply-To: <1459763047-125551-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Generate ATA pass-through sense for both fixed and descriptor
format sense.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/ata/libata-scsi.c | 93 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 59 insertions(+), 34 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index c69186b..84c5e13 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1016,43 +1016,68 @@ static void ata_gen_passthru_sense(struct ata_queued_cmd *qc)
 				   &sense_key, &asc, &ascq, verbose);
 		ata_scsi_set_sense(cmd, sense_key, asc, ascq);
 	} else {
-		/* ATA PASS-THROUGH INFORMATION AVAILABLE */
-		ata_scsi_set_sense(cmd, RECOVERED_ERROR, 0, 0x1D);
+		/*
+		 * ATA PASS-THROUGH INFORMATION AVAILABLE
+		 * Always in descriptor format sense.
+		 */
+		scsi_build_sense_buffer(1, cmd->sense_buffer,
+					RECOVERED_ERROR, 0, 0x1D);
 	}
 
-	/*
-	 * Sense data is current and format is descriptor.
-	 */
-	sb[0] = 0x72;
-
-	desc[0] = 0x09;
-
-	/* set length of additional sense data */
-	sb[7] = 14;
-	desc[1] = 12;
-
-	/*
-	 * Copy registers into sense buffer.
-	 */
-	desc[2] = 0x00;
-	desc[3] = tf->feature;	/* == error reg */
-	desc[5] = tf->nsect;
-	desc[7] = tf->lbal;
-	desc[9] = tf->lbam;
-	desc[11] = tf->lbah;
-	desc[12] = tf->device;
-	desc[13] = tf->command; /* == status reg */
+	if ((cmd->sense_buffer[0] & 0x7f) >= 0x72) {
+		u8 len;
+
+		/* descriptor format */
+		len = sb[7];
+		desc = (char *)scsi_sense_desc_find(sb, len + 8, 9);
+		if (!desc) {
+			if (SCSI_SENSE_BUFFERSIZE < len + 14)
+				return;
+			sb[7] = len + 14;
+			desc = sb + 8 + len;
+		}
+		desc[0] = 9;
+		desc[1] = 12;
+		/*
+		 * Copy registers into sense buffer.
+		 */
+		desc[2] = 0x00;
+		desc[3] = tf->feature;	/* == error reg */
+		desc[5] = tf->nsect;
+		desc[7] = tf->lbal;
+		desc[9] = tf->lbam;
+		desc[11] = tf->lbah;
+		desc[12] = tf->device;
+		desc[13] = tf->command; /* == status reg */
 
-	/*
-	 * Fill in Extend bit, and the high order bytes
-	 * if applicable.
-	 */
-	if (tf->flags & ATA_TFLAG_LBA48) {
-		desc[2] |= 0x01;
-		desc[4] = tf->hob_nsect;
-		desc[6] = tf->hob_lbal;
-		desc[8] = tf->hob_lbam;
-		desc[10] = tf->hob_lbah;
+		/*
+		 * Fill in Extend bit, and the high order bytes
+		 * if applicable.
+		 */
+		if (tf->flags & ATA_TFLAG_LBA48) {
+			desc[2] |= 0x01;
+			desc[4] = tf->hob_nsect;
+			desc[6] = tf->hob_lbal;
+			desc[8] = tf->hob_lbam;
+			desc[10] = tf->hob_lbah;
+		}
+	} else {
+		/* Fixed sense format */
+		desc[0] = tf->feature;
+		desc[1] = tf->command; /* status */
+		desc[2] = tf->device;
+		desc[3] = tf->nsect;
+		desc[0] = 0;
+		if (tf->flags & ATA_TFLAG_LBA48)  {
+			desc[8] |= 0x80;
+			if (tf->hob_nsect)
+				desc[8] |= 0x40;
+			if (tf->hob_lbal || tf->hob_lbam || tf->hob_lbah)
+				desc[8] |= 0x20;
+		}
+		desc[9] = tf->lbal;
+		desc[10] = tf->lbam;
+		desc[11] = tf->lbah;
 	}
 }
 
-- 
1.8.5.6

