From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/10] scsi: use per-cpu buffer for formatting scsi_print_result()
Date: Thu,  6 Nov 2014 09:30:37 +0100
Message-ID: <1415262639-121586-9-git-send-email-hare@suse.de>
References: <1415262639-121586-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42417 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbaKFImu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2014 03:42:50 -0500
In-Reply-To: <1415262639-121586-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Convert scsi_print_result() to use the per-cpu buffer for
decoding the command result and disposition.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c    | 22 ----------------------
 drivers/scsi/scsi.c         |  2 +-
 drivers/scsi/scsi_logging.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 82c8d68..dfa8639 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1286,25 +1286,3 @@ const char *scsi_mlreturn_string(int result)
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
-			    msg ? msg : "",
-			    mlret_string ? mlret_string : "UNKNOWN",
-			    hb_string ? hb_string : "invalid",
-			    db_string ? db_string : "invalid");
-	else
-		scmd_printk(KERN_INFO, cmd,
-			    "%s%s Result: hostbyte=0x%02x driverbyte=0x%02x",
-			    msg ? msg : "",
-			    mlret_string ? mlret_string : "UNKNOWN",
-			    host_byte(cmd->result), driver_byte(cmd->result));
-}
-EXPORT_SYMBOL(scsi_print_result);
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index bc52bbd..92d5912 100644
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
index 065792a3..e7e7cab 100644
--- a/drivers/scsi/scsi_logging.c
+++ b/drivers/scsi/scsi_logging.c
@@ -398,3 +398,47 @@ void scsi_print_sense(const struct scsi_cmnd *cmd)
 			     cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
 }
 EXPORT_SYMBOL(scsi_print_sense);
+
+void scsi_print_result(struct scsi_cmnd *cmd, const char *msg, int disposition)
+{
+	char *logbuf;
+	size_t off, logbuf_len;
+	const char *mlret_string = scsi_mlreturn_string(disposition);
+	const char *hb_string = scsi_hostbyte_string(cmd->result);
+	const char *db_string = scsi_driverbyte_string(cmd->result);
+
+	logbuf = scsi_log_reserve_buffer(&logbuf_len);
+	if (!logbuf)
+		return;
+
+	off = sdev_format_header(logbuf, logbuf_len,
+				 scmd_name(cmd), cmd->request->tag);
+
+	if (msg)
+		off += scnprintf(logbuf + off, logbuf_len - off,
+				 "%s: ", msg);
+	if (mlret_string)
+		off += scnprintf(logbuf + off, logbuf_len - off,
+				 "%s ", mlret_string);
+	else
+		off += scnprintf(logbuf + off, logbuf_len - off,
+				 "UNKNOWN(0x%02x) ", disposition);
+	off += scnprintf(logbuf + off, logbuf_len - off, "Result: ");
+	if (hb_string)
+		off += scnprintf(logbuf + off, logbuf_len - off,
+				 "hostbyte=%s ", hb_string);
+	else
+		off += scnprintf(logbuf + off, logbuf_len - off,
+				 "hostbyte=0x%02x ", host_byte(cmd->result));
+
+	if (db_string)
+		off += scnprintf(logbuf + off, logbuf_len - off,
+				 "driverbyte=%s", db_string);
+	else
+		off += scnprintf(logbuf + off, logbuf_len - off,
+				 "driverbyte=0x%02x", driver_byte(cmd->result));
+
+	dev_printk(KERN_INFO, &cmd->device->sdev_gendev, logbuf);
+	scsi_log_release_buffer(logbuf);
+}
+EXPORT_SYMBOL(scsi_print_result);
-- 
1.8.5.2

