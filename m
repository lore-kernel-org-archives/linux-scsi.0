From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/6] libata-scsi: use ata_scsi_set_sense when generating ATA sense
Date: Fri, 31 Jul 2015 15:02:04 +0200
Message-ID: <1438347728-106434-3-git-send-email-hare@suse.de>
References: <1438347728-106434-1-git-send-email-hare@suse.de>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1438347728-106434-1-git-send-email-hare@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <james.bottomley@hansenpartnership.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

When generating ATA sense we should be using 'ata_scsi_set_sense'
and avoid the hand-crafted functions.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-scsi.c | 41 ++++++++---------------------------------
 1 file changed, 8 insertions(+), 33 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 641a61a..7fc1bb4 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1064,45 +1064,26 @@ static void ata_gen_passthru_sense(struct ata_queued_cmd *qc)
  */
 static void ata_gen_ata_sense(struct ata_queued_cmd *qc)
 {
-	struct ata_device *dev = qc->dev;
 	struct scsi_cmnd *cmd = qc->scsicmd;
 	struct ata_taskfile *tf = &qc->result_tf;
-	unsigned char *sb = cmd->sense_buffer;
-	unsigned char *desc = sb + 8;
 	int verbose = qc->ap->ops->error_handler == NULL;
-	u64 block;
 
-	memset(sb, 0, SCSI_SENSE_BUFFERSIZE);
-
-	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
-
-	/* sense data is current and format is descriptor */
-	sb[0] = 0x72;
+	set_driver_byte(cmd, DRIVER_SENSE);
 
 	/* Use ata_to_sense_error() to map status register bits
 	 * onto sense key, asc & ascq.
 	 */
 	if (qc->err_mask ||
 	    tf->command & (ATA_BUSY | ATA_DF | ATA_ERR | ATA_DRQ)) {
-		ata_to_sense_error(qc->ap->print_id, tf->command, tf->feature,
-				   &sb[1], &sb[2], &sb[3], verbose);
-		sb[1] &= 0x0f;
-	}
+		u8 sense_key, asc, ascq;
 
-	block = ata_tf_read_block(&qc->result_tf, dev);
-
-	/* information sense data descriptor */
-	sb[7] = 12;
-	desc[0] = 0x00;
-	desc[1] = 10;
+		ata_to_sense_error(qc->ap->print_id, tf->command, tf->feature,
+				   &sense_key, &asc, &ascq, verbose);
 
-	desc[2] |= 0x80;	/* valid */
-	desc[6] = block >> 40;
-	desc[7] = block >> 32;
-	desc[8] = block >> 24;
-	desc[9] = block >> 16;
-	desc[10] = block >> 8;
-	desc[11] = block;
+		ata_scsi_set_sense(cmd, sense_key, asc, ascq);
+		ata_scsi_set_sense_information(cmd, &qc->result_tf);
+	} else
+		ata_scsi_set_sense(cmd, ABORTED_COMMAND, 0, 0);
 }
 
 static void ata_scsi_sdev_config(struct scsi_device *sdev)
@@ -1797,12 +1778,6 @@ static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
 		} else if (!need_sense) {
 			cmd->result = SAM_STAT_GOOD;
 		} else {
-			/* TODO: decide which descriptor format to use
-			 * for 48b LBA devices and call that here
-			 * instead of the fixed desc, which is only
-			 * good for smaller LBA (and maybe CHS?)
-			 * devices.
-			 */
 			ata_gen_ata_sense(qc);
 		}
 	}
-- 
1.8.5.2

