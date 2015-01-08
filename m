From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6/9] scsi: use per-cpu buffer for formatting scsi_print_result()
Date: Thu,  8 Jan 2015 07:43:47 +0100
Message-ID: <1420699430-9492-7-git-send-email-hare@suse.de>
References: <1420699430-9492-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60282 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318AbbAHGoN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jan 2015 01:44:13 -0500
In-Reply-To: <1420699430-9492-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Convert scsi_print_result() to use the per-cpu buffer for
decoding the command result and disposition.

Tested-by: Robert Elliott <elliott@hp.com>
Reviewed-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c    | 22 -----------------
 drivers/scsi/scsi.c         |  2 +-
 drivers/scsi/scsi_logging.c | 59 +++++++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_dbg.h     |  2 +-
 4 files changed, 61 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index a23ef75..956fbdd 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1316,25 +1316,3 @@ const char *scsi_mlreturn_string(int result)
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
index e028854..7f028cb 100644
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
index c7cba31..6128303 100644
--- a/drivers/scsi/scsi_logging.c
+++ b/drivers/scsi/scsi_logging.c
@@ -428,3 +428,62 @@ void scsi_print_sense(const struct scsi_cmnd *cmd)
 			     cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
 }
 EXPORT_SYMBOL(scsi_print_sense);
+
+void scsi_print_result(const struct scsi_cmnd *cmd, const char *msg,
+		       int disposition)
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
+	if (off >= logbuf_len)
+		goto out_printk;
+
+	if (msg) {
+		off += scnprintf(logbuf + off, logbuf_len - off,
+				 "%s: ", msg);
+		if (WARN_ON(off >= logbuf_len))
+			goto out_printk;
+	}
+	if (mlret_string)
+		off += scnprintf(logbuf + off, logbuf_len - off,
+				 "%s ", mlret_string);
+	else
+		off += scnprintf(logbuf + off, logbuf_len - off,
+				 "UNKNOWN(0x%02x) ", disposition);
+	if (WARN_ON(off >= logbuf_len))
+		goto out_printk;
+
+	off += scnprintf(logbuf + off, logbuf_len - off, "Result: ");
+	if (WARN_ON(off >= logbuf_len))
+		goto out_printk;
+
+	if (hb_string)
+		off += scnprintf(logbuf + off, logbuf_len - off,
+				 "hostbyte=%s ", hb_string);
+	else
+		off += scnprintf(logbuf + off, logbuf_len - off,
+				 "hostbyte=0x%02x ", host_byte(cmd->result));
+	if (WARN_ON(off >= logbuf_len))
+		goto out_printk;
+
+	if (db_string)
+		off += scnprintf(logbuf + off, logbuf_len - off,
+				 "driverbyte=%s", db_string);
+	else
+		off += scnprintf(logbuf + off, logbuf_len - off,
+				 "driverbyte=0x%02x", driver_byte(cmd->result));
+out_printk:
+	dev_printk(KERN_INFO, &cmd->device->sdev_gendev, logbuf);
+	scsi_log_release_buffer(logbuf);
+}
+EXPORT_SYMBOL(scsi_print_result);
diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
index c7ed7b8..365b674 100644
--- a/include/scsi/scsi_dbg.h
+++ b/include/scsi/scsi_dbg.h
@@ -21,7 +21,7 @@ extern void scsi_print_sense(const struct scsi_cmnd *);
 extern void __scsi_print_sense(const struct scsi_device *, const char *name,
 			       const unsigned char *sense_buffer,
 			       int sense_len);
-extern void scsi_print_result(struct scsi_cmnd *, const char *, int);
+extern void scsi_print_result(const struct scsi_cmnd *, const char *, int);
 extern const char *scsi_hostbyte_string(int);
 extern const char *scsi_driverbyte_string(int);
 extern const char *scsi_mlreturn_string(int);
-- 
1.8.4.5

