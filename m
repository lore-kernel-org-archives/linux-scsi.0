From: Phillip Susi <psusi@ubuntu.com>
Subject: [PATCH 6/6] libata: return power status in REQUEST SENSE command
Date: Mon, 16 Dec 2013 18:30:57 -0500
Message-ID: <1387236657-4852-7-git-send-email-psusi@ubuntu.com>
References: <cover.1384030893.git.psusi@ubuntu.com>
 <1387236657-4852-1-git-send-email-psusi@ubuntu.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1387236657-4852-1-git-send-email-psusi@ubuntu.com>
Sender: linux-ide-owner@vger.kernel.org
To: todd.e.brandt@linux.intel.com
Cc: tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

SAT-3 says REQUEST SENSE should issue CHECK POWER and return
a sense status indicating the drive's power status.
---
 drivers/ata/libata-scsi.c | 40 ++++++++++++++++++++++++++++++++++------
 1 file changed, 34 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index f92eb21..8b17352 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3313,6 +3313,38 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 	return 1;
 }
 
+static void ata_scsi_request_sense_complete(struct ata_queued_cmd *qc)
+{
+	struct scsi_cmnd *cmd = qc->scsicmd;
+	cmd->result = (DRIVER_SENSE << 24);
+	if (qc->result_tf.nsect == 0)
+		/* POWER STATE CHANGE TO STANDBY */
+	{
+		scsi_build_sense_buffer(0, cmd->sense_buffer, 0, 0x5E, 0x43);
+	}
+	else scsi_build_sense_buffer(0, cmd->sense_buffer, 0, 0, 0);
+	qc->scsidone(cmd);
+	ata_qc_free(qc);
+}
+
+/**
+ *	ata_scsi_request_sense_xlat - Simulate REQUEST SENSE command
+ *	@qc: Storage for translated ATA taskfile
+ *
+ *	Converts a REQUEST SENSE command to an ATA CHECK POWER MODE taskfile.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ */
+static unsigned int ata_scsi_request_sense_xlat(struct ata_queued_cmd *qc)
+{
+	qc->tf.command = ATA_CMD_CHK_POWER;
+	qc->flags |= ATA_QCFLAG_RESULT_TF;
+	qc->tf.protocol = ATA_PROT_NODATA;
+	qc->complete_fn = ata_scsi_request_sense_complete;
+	return 0;
+}
+
 /**
  *	ata_get_xlat_func - check if SCSI to ATA translation is possible
  *	@dev: ATA device
@@ -3360,6 +3392,8 @@ static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev, u8 cmd)
 
 	case START_STOP:
 		return ata_scsi_start_stop_xlat;
+	case REQUEST_SENSE:
+		return ata_scsi_request_sense_xlat;
 	}
 
 	return NULL;
@@ -3565,12 +3599,6 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd)
 		ata_scsi_rbuf_fill(&args, ata_scsiop_report_luns);
 		break;
 
-	case REQUEST_SENSE:
-		ata_scsi_set_sense(cmd, 0, 0, 0);
-		cmd->result = (DRIVER_SENSE << 24);
-		cmd->scsi_done(cmd);
-		break;
-
 	/* if we reach this, then writeback caching is disabled,
 	 * turning this into a no-op.
 	 */
-- 
1.8.3.2

