From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/14] libata-eh: Set 'information' field for autosense
Date: Mon,  4 Apr 2016 11:43:59 +0200
Message-ID: <1459763047-125551-7-git-send-email-hare@suse.de>
References: <1459763047-125551-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59335 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754898AbcDDJoW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Apr 2016 05:44:22 -0400
In-Reply-To: <1459763047-125551-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.de>

If NCQ autosense or the sense data reporting feature is enabled
the LBA of the offending command should be stored in the sense
data 'information' field.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-eh.c   |  2 ++
 drivers/ata/libata-scsi.c | 17 +++++++++++++++++
 drivers/ata/libata.h      |  3 +++
 3 files changed, 22 insertions(+)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 1a009d7..d33e7b8 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1856,6 +1856,8 @@ void ata_eh_analyze_ncq_error(struct ata_link *link)
 		asc = (qc->result_tf.auxiliary >> 8) & 0xff;
 		ascq = qc->result_tf.auxiliary & 0xff;
 		ata_scsi_set_sense(qc->scsicmd, sense_key, asc, ascq);
+		ata_scsi_set_sense_information(dev, qc->scsicmd,
+					       &qc->result_tf);
 		qc->flags |= ATA_QCFLAG_SENSE_VALID;
 	}
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index de593d8..e43ca29 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -280,6 +280,23 @@ void ata_scsi_set_sense(struct scsi_cmnd *cmd, u8 sk, u8 asc, u8 ascq)
 	scsi_build_sense_buffer(0, cmd->sense_buffer, sk, asc, ascq);
 }
 
+void ata_scsi_set_sense_information(struct ata_device *dev,
+				    struct scsi_cmnd *cmd,
+				    const struct ata_taskfile *tf)
+{
+	u64 information;
+
+	if (!cmd)
+		return;
+
+	information = ata_tf_read_block(tf, dev);
+	if (information == (u64)-1)
+		return;
+
+	scsi_set_sense_information(cmd->sense_buffer,
+				   SCSI_SENSE_BUFFERSIZE, information);
+}
+
 static ssize_t
 ata_scsi_em_message_store(struct device *dev, struct device_attribute *attr,
 			  const char *buf, size_t count)
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 507c22f..dbc6760 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -139,6 +139,9 @@ extern int ata_scsi_add_hosts(struct ata_host *host,
 extern void ata_scsi_scan_host(struct ata_port *ap, int sync);
 extern int ata_scsi_offline_dev(struct ata_device *dev);
 extern void ata_scsi_set_sense(struct scsi_cmnd *cmd, u8 sk, u8 asc, u8 ascq);
+extern void ata_scsi_set_sense_information(struct ata_device *dev,
+					   struct scsi_cmnd *cmd,
+					   const struct ata_taskfile *tf);
 extern void ata_scsi_media_change_notify(struct ata_device *dev);
 extern void ata_scsi_hotplug(struct work_struct *work);
 extern void ata_schedule_scsi_eh(struct Scsi_Host *shost);
-- 
1.8.5.6

