From: Aaron Lu <aaron.lu@intel.com>
Subject: [RFC PATCH] libata: scsi: flush cache on scsi stop command
Date: Wed, 19 Sep 2012 16:56:59 +0800
Message-ID: <1348045019-21532-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@intel.com>
List-Id: linux-scsi@vger.kernel.org

scsi stop command is used to put a device into stopped power
condition, and scsi devices will take care of its internal cache
before entering this power condition. For ata devices, this command
should be translated to flush cache + standby immediate, currently,
we are translating it to only standby.

This patch handle this by sending flush cache command when standby is
to be sent, and in its qc complete function, send the actual standby.

This patch will be used to support poweroff hard disk either when
runtime or when system is going to S3/S4/S5. The sd_suspend will be
modified to only send a stop command to the device if device manages
start_stop, the current implementation will send a sync cache command,
which is not necessary per the scsi spec.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/ata/libata-scsi.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 8ec81ca..de6e734 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1759,6 +1759,27 @@ static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
 	ata_qc_free(qc);
 }
 
+static void ata_flush_qc_complete(struct ata_queued_cmd *qc)
+{
+	if (qc->err_mask) {
+		ata_gen_ata_sense(qc);
+		qc->scsidone(qc->scsicmd);
+		ata_qc_free(qc);
+	} else {
+		qc->complete_fn = ata_scsi_qc_complete;
+		qc->tf.command = ATA_CMD_STANDBYNOW1;
+		ata_qc_issue(qc);
+	}
+}
+
+static void ata_qc_issue_flush(struct ata_queued_cmd *qc)
+{
+	qc->complete_fn = ata_flush_qc_complete;
+	qc->tf.command = qc->dev->flags & ATA_DFLAG_FLUSH_EXT ?
+				ATA_CMD_FLUSH_EXT : ATA_CMD_FLUSH;
+	ata_qc_issue(qc);
+}
+
 /**
  *	ata_scsi_translate - Translate then issue SCSI command to ATA device
  *	@dev: ATA device to which the command is addressed
@@ -1821,8 +1842,15 @@ static int ata_scsi_translate(struct ata_device *dev, struct scsi_cmnd *cmd,
 			goto defer;
 	}
 
-	/* select device, send command to hardware */
-	ata_qc_issue(qc);
+	/*
+	 * If we received scsi stop command,
+	 * we will need to flush cache first
+	 */
+	if (qc->tf.command == ATA_CMD_STANDBYNOW1 && ata_try_flush_cache(dev))
+		ata_qc_issue_flush(qc);
+	else
+		/* select device, send command to hardware */
+		ata_qc_issue(qc);
 
 	VPRINTK("EXIT\n");
 	return 0;
-- 
1.7.12.21.g871e293

