From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] libata: simple TEST UNIT READY simulation
Date: Fri, 21 Sep 2007 07:10:28 -0400
Message-ID: <20070921111028.GA19840@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


As per SAT (sans removable devices)...



commit 09d9637c413406cf63f0e1efb364411ac8a9243c
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Sep 21 07:09:36 2007 -0400

    [libata] SCSI: simple TEST UNIT READY simulation
    
    It's trivial to ping the device, and that's a much more sane behavior
    than no-op.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/ata/libata-scsi.c |   62 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 46 insertions(+), 16 deletions(-)

09d9637c413406cf63f0e1efb364411ac8a9243c
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index dbe8ac3..456b75f 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -906,6 +906,29 @@ static void ata_delayed_done(struct scsi_cmnd *scmd)
 }
 
 /**
+ *	ata_scsi_tur_xlat - Translate SCSI TEST UNIT READY command
+ *	@qc: Storage for translated ATA taskfile
+ *
+ *	Simulates a TEST UNIT READY command.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ *
+ *	RETURNS:
+ *	Zero on success, non-zero on error.
+ */
+static unsigned int ata_scsi_tur_xlat(struct ata_queued_cmd *qc)
+{
+	struct ata_taskfile *tf = &qc->tf;
+
+	tf->flags |= ATA_TFLAG_DEVICE;
+	tf->protocol = ATA_PROT_NODATA;
+	tf->command = ATA_CMD_CHK_POWER;
+
+	return 0;
+}
+
+/**
  *	ata_scsi_start_stop_xlat - Translate SCSI START STOP UNIT command
  *	@qc: Storage for translated ATA taskfile
  *
@@ -1376,6 +1399,12 @@ static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
 		}
 	}
 
+	/* For TEST UNIT READY failures, we are told to respond with
+	 * NOT READY / LOGICAL UNIT DOES NOT RESPOND TO SELECTION
+	 */
+	if ((cdb[0] == TEST_UNIT_READY) && need_sense)
+		ata_scsi_set_sense(cmd, NOT_READY, 0x05, 0x00);
+
 	/* For ATA pass thru (SAT) commands, generate a sense block if
 	 * user mandated it or if there's an error.  Note that if we
 	 * generate because the user forced us to, a check condition
@@ -1383,22 +1412,21 @@ static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
 	 * whether the command completed successfully or not. If there
 	 * was no error, SK, ASC and ASCQ will all be zero.
 	 */
-	if (((cdb[0] == ATA_16) || (cdb[0] == ATA_12)) &&
- 	    ((cdb[2] & 0x20) || need_sense)) {
+	else if (((cdb[0] == ATA_16) || (cdb[0] == ATA_12)) &&
+		 ((cdb[2] & 0x20) || need_sense))
 		ata_gen_passthru_sense(qc);
-	} else {
-		if (!need_sense) {
-			cmd->result = SAM_STAT_GOOD;
-		} else {
-			/* TODO: decide which descriptor format to use
-			 * for 48b LBA devices and call that here
-			 * instead of the fixed desc, which is only
-			 * good for smaller LBA (and maybe CHS?)
-			 * devices.
-			 */
-			ata_gen_ata_sense(qc);
-		}
-	}
+
+	else if (need_sense)
+		/* TODO: decide which descriptor format to use
+		 * for 48b LBA devices and call that here
+		 * instead of the fixed desc, which is only
+		 * good for smaller LBA (and maybe CHS?)
+		 * devices.
+		 */
+		ata_gen_ata_sense(qc);
+
+	else
+		cmd->result = SAM_STAT_GOOD;
 
 	/* XXX: track spindown state for spindown skipping and warning */
 	if (unlikely(qc->tf.command == ATA_CMD_STANDBY ||
@@ -2780,6 +2808,9 @@ static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev, u8 cmd)
 
 	case START_STOP:
 		return ata_scsi_start_stop_xlat;
+
+	case TEST_UNIT_READY:
+		return ata_scsi_tur_xlat;
 	}
 
 	return NULL;
@@ -2935,7 +2966,6 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
 		case REZERO_UNIT:
 		case SEEK_6:
 		case SEEK_10:
-		case TEST_UNIT_READY:
 		case FORMAT_UNIT:		/* FIXME: correct? */
 			ata_scsi_rbuf_fill(&args, ata_scsiop_noop);
 			break;
