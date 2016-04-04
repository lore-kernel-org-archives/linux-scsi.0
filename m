From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/14] libata-scsi: use ata_scsi_set_sense()
Date: Mon,  4 Apr 2016 11:44:00 +0200
Message-ID: <1459763047-125551-8-git-send-email-hare@suse.de>
References: <1459763047-125551-1-git-send-email-hare@suse.de>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1459763047-125551-1-git-send-email-hare@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

Use ata_scsi_set_sense() throughout to ensure the sense code
format is consistent.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/ata/libata-scsi.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index e43ca29..c69186b 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1000,6 +1000,7 @@ static void ata_gen_passthru_sense(struct ata_queued_cmd *qc)
 	unsigned char *sb = cmd->sense_buffer;
 	unsigned char *desc = sb + 8;
 	int verbose = qc->ap->ops->error_handler == NULL;
+	u8 sense_key, asc, ascq;
 
 	memset(sb, 0, SCSI_SENSE_BUFFERSIZE);
 
@@ -1012,12 +1013,11 @@ static void ata_gen_passthru_sense(struct ata_queued_cmd *qc)
 	if (qc->err_mask ||
 	    tf->command & (ATA_BUSY | ATA_DF | ATA_ERR | ATA_DRQ)) {
 		ata_to_sense_error(qc->ap->print_id, tf->command, tf->feature,
-				   &sb[1], &sb[2], &sb[3], verbose);
-		sb[1] &= 0x0f;
+				   &sense_key, &asc, &ascq, verbose);
+		ata_scsi_set_sense(cmd, sense_key, asc, ascq);
 	} else {
-		sb[1] = RECOVERED_ERROR;
-		sb[2] = 0;
-		sb[3] = 0x1D;
+		/* ATA PASS-THROUGH INFORMATION AVAILABLE */
+		ata_scsi_set_sense(cmd, RECOVERED_ERROR, 0, 0x1D);
 	}
 
 	/*
@@ -1074,22 +1074,20 @@ static void ata_gen_ata_sense(struct ata_queued_cmd *qc)
 	unsigned char *sb = cmd->sense_buffer;
 	int verbose = qc->ap->ops->error_handler == NULL;
 	u64 block;
+	u8 sense_key, asc, ascq;
 
 	memset(sb, 0, SCSI_SENSE_BUFFERSIZE);
 
 	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
 
-	/* sense data is current and format is descriptor */
-	sb[0] = 0x72;
-
 	/* Use ata_to_sense_error() to map status register bits
 	 * onto sense key, asc & ascq.
 	 */
 	if (qc->err_mask ||
 	    tf->command & (ATA_BUSY | ATA_DF | ATA_ERR | ATA_DRQ)) {
 		ata_to_sense_error(qc->ap->print_id, tf->command, tf->feature,
-				   &sb[1], &sb[2], &sb[3], verbose);
-		sb[1] &= 0x0f;
+				   &sense_key, &asc, &ascq, verbose);
+		ata_scsi_set_sense(cmd, sense_key, asc, ascq);
 	} else {
 		/* Could not decode error */
 		ata_dev_warn(dev, "could not decode error status 0x%x err_mask 0x%x\n",
-- 
1.8.5.6

