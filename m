From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 36/38] scsi: use seq_buf for formatting scsi_print_result()
Date: Mon, 29 Sep 2014 13:59:05 +0200
Message-ID: <1411991947-130166-37-git-send-email-hare@suse.de>
References: <1411991947-130166-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59329 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665AbaI2L7T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2014 07:59:19 -0400
In-Reply-To: <1411991947-130166-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>

Convert scsi_print_result() to use seq_buf to properly
decode the command result and disposition.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c    | 20 --------------------
 drivers/scsi/scsi.c         |  2 +-
 drivers/scsi/scsi_logging.c | 36 ++++++++++++++++++++++++++++++++++++
 3 files changed, 37 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 0f02abe..37300b2 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1291,23 +1291,3 @@ const char *scsi_mlreturn_string(int result)
 	return NULL;
 }
 EXPORT_SYMBOL(scsi_mlreturn_string);
-
-void scsi_print_result(struct scsi_cmnd *cmd, const char *msg, int disposition)
-{
-	const char *mlret_string = scsi_mlreturn_string(disposition);
-	const char *hb_string = scsi_hostbyte_string(cmd->result);
-	const char *db_string = scsi_driverbyte_string(cmd->result);
-
-	if (hb_string || db_string)
-		scmd_printk(KERN_INFO, cmd,
-			    "%s%s Result: hostbyte=%s driverbyte=%s",
-			    msg, mlret_string ? mlret_string : "UNKNOWN",
-			    hb_string ? hb_string : "invalid",
-			    db_string ? db_string : "invalid");
-	else
-		scmd_printk(KERN_INFO, cmd,
-			    "%s%s Result: hostbyte=0x%02x driverbyte=0x%02x",
-			    msg, mlret_string ? mlret_string : "UNKNOWN",
-			    host_byte(cmd->result), driver_byte(cmd->result));
-}
-EXPORT_SYMBOL(scsi_print_result);
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 3d81a07..3487685 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -572,7 +572,7 @@ void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
 				       SCSI_LOG_MLCOMPLETE_BITS);
 		if (((level > 0) && (cmd->result || disposition != SUCCESS)) ||
 		    (level > 1)) {
-			scsi_print_result(cmd, "Done: ", disposition);
+			scsi_print_result(cmd, "Done", disposition);
 			scsi_print_command(cmd);
 			if (status_byte(cmd->result) & CHECK_CONDITION)
 				scsi_print_sense(cmd);
diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
index c3672e5..4e0249d 100644
--- a/drivers/scsi/scsi_logging.c
+++ b/drivers/scsi/scsi_logging.c
@@ -270,3 +270,39 @@ void scsi_print_sense(struct scsi_cmnd *cmd)
 			   cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
 }
 EXPORT_SYMBOL(scsi_print_sense);
+
+void scsi_print_result(struct scsi_cmnd *cmd, const char *msg, int disposition)
+{
+	char logbuf[SCSI_LOG_BUFSIZE];
+	struct seq_buf s;
+	struct gendisk *disk = cmd->request->rq_disk;
+	const char *mlret_string = scsi_mlreturn_string(disposition);
+	const char *hb_string = scsi_hostbyte_string(cmd->result);
+	const char *db_string = scsi_driverbyte_string(cmd->result);
+
+	seq_buf_init(&s, logbuf, SCSI_LOG_BUFSIZE);
+	sdev_format_header(&s, cmd->device, disk ? disk->disk_name : NULL,
+			   cmd->request->tag);
+
+	if (msg)
+		seq_buf_printf(&s, "%s: ", msg);
+	if (mlret_string)
+		seq_buf_printf(&s, "%s ", mlret_string);
+	else
+		seq_buf_printf(&s, "UNKNOWN(0x%02x) ", disposition);
+	seq_buf_printf(&s, "Result: ");
+	if (hb_string)
+		seq_buf_printf(&s, "hostbyte=%s ", hb_string);
+	else
+		seq_buf_printf(&s, "hostbyte=0x%02x ",
+			       host_byte(cmd->result));
+
+	if (db_string)
+		seq_buf_printf(&s, "driverbyte=%s", db_string);
+	else
+		seq_buf_printf(&s, "driverbyte=0x%02x",
+			       driver_byte(cmd->result));
+
+	sdev_seq_printk(KERN_INFO, cmd->device, &s);
+}
+EXPORT_SYMBOL(scsi_print_result);
-- 
1.8.5.2

