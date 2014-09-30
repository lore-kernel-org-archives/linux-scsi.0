From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 20/23] scsi: simplify scsi_log_(send|completion)
Date: Tue, 30 Sep 2014 13:50:49 +0200
Message-ID: <1412077852-40893-21-git-send-email-hare@suse.de>
References: <1412077852-40893-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57135 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbaI3LvG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Sep 2014 07:51:06 -0400
In-Reply-To: <1412077852-40893-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>

Simplify scsi_log_(send|completion) by externalizing
scsi_mlreturn_string() and always print the command address.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c | 39 ++++++++++++++++++++++++++++++++++++---
 drivers/scsi/scsi.c      | 43 ++++++-------------------------------------
 drivers/scsi/scsi_lib.c  | 13 ++++++++++---
 include/scsi/scsi_dbg.h  |  3 ++-
 4 files changed, 54 insertions(+), 44 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index b131900..207ebef 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1437,19 +1437,52 @@ const char *scsi_driverbyte_string(int result)
 }
 EXPORT_SYMBOL(scsi_driverbyte_string);
 
-void scsi_print_result(struct scsi_cmnd *cmd)
+#ifdef CONFIG_SCSI_CONSTANTS
+#define scsi_mlreturn_name(result)	{ result, #result }
+static const struct value_name_pair scsi_mlreturn_arr[] = {
+	scsi_mlreturn_name(NEEDS_RETRY),
+	scsi_mlreturn_name(SUCCESS),
+	scsi_mlreturn_name(FAILED),
+	scsi_mlreturn_name(QUEUED),
+	scsi_mlreturn_name(SOFT_ERROR),
+	scsi_mlreturn_name(ADD_TO_MLQUEUE),
+	scsi_mlreturn_name(TIMEOUT_ERROR),
+	scsi_mlreturn_name(SCSI_RETURN_NOT_HANDLED),
+	scsi_mlreturn_name(FAST_IO_FAIL)
+};
+#endif
+
+const char *scsi_mlreturn_string(int result)
+{
+#ifdef CONFIG_SCSI_CONSTANTS
+	const struct value_name_pair *arr = scsi_mlreturn_arr;
+	int k;
+
+	for (k = 0; k < ARRAY_SIZE(scsi_mlreturn_arr); ++k, ++arr) {
+		if (result == arr->value)
+			return arr->name;
+	}
+#endif
+	return NULL;
+}
+EXPORT_SYMBOL(scsi_mlreturn_string);
+
+void scsi_print_result(struct scsi_cmnd *cmd, const char *msg, int disposition)
 {
+	const char *mlret_string = scsi_mlreturn_string(disposition);
 	const char *hb_string = scsi_hostbyte_string(cmd->result);
 	const char *db_string = scsi_driverbyte_string(cmd->result);
 
 	if (hb_string || db_string)
 		scmd_printk(KERN_INFO, cmd,
-			    "Result: hostbyte=%s driverbyte=%s",
+			    "%s%s Result: hostbyte=%s driverbyte=%s",
+			    msg, mlret_string ? mlret_string : "UNKNOWN",
 			    hb_string ? hb_string : "invalid",
 			    db_string ? db_string : "invalid");
 	else
 		scmd_printk(KERN_INFO, cmd,
-			    "Result: hostbyte=0x%02x driverbyte=0x%02x",
+			    "%s%s Result: hostbyte=0x%02x driverbyte=0x%02x",
+			    msg, mlret_string ? mlret_string : "UNKNOWN",
 			    host_byte(cmd->result), driver_byte(cmd->result));
 }
 EXPORT_SYMBOL(scsi_print_result);
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 61aeaf1..3d81a07 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -527,9 +527,9 @@ void scsi_log_send(struct scsi_cmnd *cmd)
 	 *
 	 * 1: nothing (match completion)
 	 *
-	 * 2: log opcode + command of all commands
+	 * 2: log opcode + command of all commands + cmd address
 	 *
-	 * 3: same as 2 plus dump cmd address
+	 * 3: same as 2
 	 *
 	 * 4: same as 3 plus dump extra junk
 	 */
@@ -537,10 +537,8 @@ void scsi_log_send(struct scsi_cmnd *cmd)
 		level = SCSI_LOG_LEVEL(SCSI_LOG_MLQUEUE_SHIFT,
 				       SCSI_LOG_MLQUEUE_BITS);
 		if (level > 1) {
-			scmd_printk(KERN_INFO, cmd, "Send: ");
-			if (level > 2)
-				printk("0x%p ", cmd);
-			printk("\n");
+			scmd_printk(KERN_INFO, cmd,
+				    "Send: scmd 0x%p\n", cmd);
 			scsi_print_command(cmd);
 			if (level > 3) {
 				printk(KERN_INFO "buffer = 0x%p, bufflen = %d,"
@@ -565,7 +563,7 @@ void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
 	 *
 	 * 2: same as 1 but for all command completions.
 	 *
-	 * 3: same as 2 plus dump cmd address
+	 * 3: same as 2
 	 *
 	 * 4: same as 3 plus dump extra junk
 	 */
@@ -574,36 +572,7 @@ void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
 				       SCSI_LOG_MLCOMPLETE_BITS);
 		if (((level > 0) && (cmd->result || disposition != SUCCESS)) ||
 		    (level > 1)) {
-			scmd_printk(KERN_INFO, cmd, "Done: ");
-			if (level > 2)
-				printk("0x%p ", cmd);
-			/*
-			 * Dump truncated values, so we usually fit within
-			 * 80 chars.
-			 */
-			switch (disposition) {
-			case SUCCESS:
-				printk("SUCCESS\n");
-				break;
-			case NEEDS_RETRY:
-				printk("RETRY\n");
-				break;
-			case ADD_TO_MLQUEUE:
-				printk("MLQUEUE\n");
-				break;
-			case FAILED:
-				printk("FAILED\n");
-				break;
-			case TIMEOUT_ERROR:
-				/* 
-				 * If called via scsi_times_out.
-				 */
-				printk("TIMEOUT\n");
-				break;
-			default:
-				printk("UNKNOWN\n");
-			}
-			scsi_print_result(cmd);
+			scsi_print_result(cmd, "Done: ", disposition);
 			scsi_print_command(cmd);
 			if (status_byte(cmd->result) & CHECK_CONDITION)
 				scsi_print_sense(cmd);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b853659..2df485f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -831,7 +831,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	int error = 0;
 	struct scsi_sense_hdr sshdr;
 	bool sense_valid = false;
-	int sense_deferred = 0;
+	int sense_deferred = 0, level = 0;
 	enum {ACTION_FAIL, ACTION_REPREP, ACTION_RETRY,
 	      ACTION_DELAYED_RETRY} action;
 	unsigned long wait_for = (cmd->allowed + 1) * req->timeout;
@@ -1037,8 +1037,15 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	switch (action) {
 	case ACTION_FAIL:
 		/* Give up and fail the remainder of the request */
-		if (!(req->cmd_flags & REQ_QUIET)) {
-			scsi_print_result(cmd);
+		if (unlikely(scsi_logging_level))
+			level = SCSI_LOG_LEVEL(SCSI_LOG_MLQUEUE_SHIFT,
+					       SCSI_LOG_MLQUEUE_BITS);
+		/*
+		 * if logging is enabled the failure will be printed
+		 * in scsi_log_completion(), so avoid duplicate messages
+		 */
+		if (!level && !(req->cmd_flags & REQ_QUIET)) {
+			scsi_print_result(cmd, NULL, FAILED);
 			if (driver_byte(result) & DRIVER_SENSE)
 				scsi_print_sense(cmd);
 			scsi_print_command(cmd);
diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
index 43d7b2b..d624ed0 100644
--- a/include/scsi/scsi_dbg.h
+++ b/include/scsi/scsi_dbg.h
@@ -17,9 +17,10 @@ extern void scsi_print_sense(struct scsi_cmnd *);
 extern void __scsi_print_sense(struct scsi_device *, const char *name,
 			       const unsigned char *sense_buffer,
 			       int sense_len);
-extern void scsi_print_result(struct scsi_cmnd *);
+extern void scsi_print_result(struct scsi_cmnd *, const char *, int);
 extern const char *scsi_hostbyte_string(int);
 extern const char *scsi_driverbyte_string(int);
+extern const char *scsi_mlreturn_string(int);
 extern const char *scsi_sense_key_string(unsigned char);
 extern const char *scsi_extd_sense_format(unsigned char, unsigned char,
 					  const char **);
-- 
1.8.5.2

