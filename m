From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 17/22] scsi: print disposition in scsi_print_result()
Date: Thu, 28 Aug 2014 19:33:31 +0200
Message-ID: <1409247216-76074-18-git-send-email-hare@suse.de>
References: <1409247216-76074-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60183 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017AbaH1Rdn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2014 13:33:43 -0400
In-Reply-To: <1409247216-76074-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>, Hannes Reinecke <hare@suse.de>

Print the result disposition in scsi_print_result() to simplify
code.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c | 43 +++++++++++++++++++++++++++++++++++++------
 drivers/scsi/scsi.c      | 28 +---------------------------
 drivers/scsi/scsi_lib.c  |  2 +-
 drivers/scsi/sd.c        |  6 ++++--
 include/scsi/scsi_dbg.h  |  4 ++--
 5 files changed, 45 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 771cd8e..c59d128 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1501,6 +1501,33 @@ int scsi_print_sense(struct scsi_cmnd *cmd)
 EXPORT_SYMBOL(scsi_print_sense);
 
 #ifdef CONFIG_SCSI_CONSTANTS
+static const struct error_info disposition_table[] =
+{
+	{ NEEDS_RETRY, "NEEDS_RETRY " },
+	{ SUCCESS, "SUCCESS " },
+	{ FAILED, "FAILED " },
+	{ QUEUED, "QUEUED " },
+	{ SOFT_ERROR, "SOFT_ERROR " },
+	{ ADD_TO_MLQUEUE, "ADD_TO_MLQUEUE " },
+	{ TIMEOUT_ERROR, "TIMEOUT " },
+	{ SCSI_RETURN_NOT_HANDLED, "NOT_HANDLED " },
+	{ FAST_IO_FAIL, "FAST_IO_FAIL " },
+};
+#endif
+
+const char *
+scsi_disposition_string(unsigned int disposition) {
+#ifdef CONFIG_SCSI_CONSTANTS
+	int i;
+
+	for (i = 0; disposition_table[i].text; i++)
+		if (disposition_table[i].code12 == disposition)
+			return disposition_table[i].text;
+#endif
+	return NULL;
+}
+
+#ifdef CONFIG_SCSI_CONSTANTS
 
 static const char * const hostbyte_table[]={
 "DID_OK", "DID_NO_CONNECT", "DID_BUS_BUSY", "DID_TIME_OUT", "DID_BAD_TARGET",
@@ -1515,7 +1542,8 @@ static const char * const driverbyte_table[]={
 "DRIVER_INVALID", "DRIVER_TIMEOUT", "DRIVER_HARD", "DRIVER_SENSE"};
 #define NUM_DRIVERBYTE_STRS ARRAY_SIZE(driverbyte_table)
 
-void scsi_show_result(struct scsi_device *sdev, const char *name, int result)
+void scsi_show_result(struct scsi_device *sdev, const char *name,
+		      int result, int disposition)
 {
 	int hb = host_byte(result);
 	int db = driver_byte(result);
@@ -1528,26 +1556,29 @@ void scsi_show_result(struct scsi_device *sdev, const char *name, int result)
 
 
 	sdev_prefix_printk(KERN_INFO, sdev, name,
-			   "Result: hostbyte=%s driverbyte=%s\n",
+			   "%sResult: hostbyte=%s driverbyte=%s\n",
+			   scsi_disposition_string(disposition),
 			   hb_string, db_string);
 }
 
 #else
 
-void scsi_show_result(struct scsi_device *sdev, const char *name, int result)
+void scsi_show_result(struct scsi_device *sdev, const char *name,
+		      int result, int disposition)
 {
 	sdev_prefix_printk(KERN_INFO, sdev, name,
-			   "Result: hostbyte=0x%02x driverbyte=0x%02x\n",
+			   "%sResult: hostbyte=0x%02x driverbyte=0x%02x\n",
+			   scsi_disposition_string(disposition),
 			   host_byte(result), driver_byte(result));
 }
 
 #endif
 EXPORT_SYMBOL(scsi_show_result);
 
-void scsi_print_result(struct scsi_cmnd *cmd)
+void scsi_print_result(struct scsi_cmnd *cmd, int disposition)
 {
 	const char *devname = cmd->request->rq_disk ?
 		cmd->request->rq_disk->disk_name : NULL;
-	scsi_show_result(cmd->device, devname, cmd->result);
+	scsi_show_result(cmd->device, devname, cmd->result, disposition);
 }
 EXPORT_SYMBOL(scsi_print_result);
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 283f053..d267e61 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -569,33 +569,7 @@ void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
 			scmd_printk(KERN_INFO, cmd, "Done: ");
 			if (level > 2)
 				printk("0x%p ", cmd);
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
+			scsi_print_result(cmd, disposition);
 			scsi_print_command(cmd);
 			if (status_byte(cmd->result) & CHECK_CONDITION) {
 				if (scsi_print_sense(cmd))
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index de178f7..d3657b6 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1038,7 +1038,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	case ACTION_FAIL:
 		/* Give up and fail the remainder of the request */
 		if (!(req->cmd_flags & REQ_QUIET)) {
-			scsi_print_result(cmd);
+			scsi_print_result(cmd, SUCCESS);
 			if (driver_byte(result) & DRIVER_SENSE)
 				scsi_print_sense(cmd);
 			scsi_print_command(cmd);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e780644..624692c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1701,7 +1701,7 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 			sense_deferred = scsi_sense_is_deferred(&sshdr);
 	}
 #ifdef CONFIG_SCSI_LOGGING
-	SCSI_LOG_HLCOMPLETE(1, scsi_print_result(SCpnt));
+	SCSI_LOG_HLCOMPLETE(1, scsi_print_result(SCpnt, SUCCESS));
 	if (sense_valid) {
 		SCSI_LOG_HLCOMPLETE(1, scmd_printk(KERN_INFO, SCpnt,
 						   "sd_done: sb[respc,sk,asc,"
@@ -3328,6 +3328,8 @@ static void sd_print_sense_hdr(struct scsi_disk *sdkp,
 
 static void sd_print_result(struct scsi_disk *sdkp, int result)
 {
-	scsi_show_result(sdkp->device, sdkp->disk->disk_name, result);
+	scsi_show_result(sdkp->device,
+			 sdkp->disk ? sdkp->disk->disk_name : NULL,
+			 result, SUCCESS);
 }
 
diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
index e682fe3..fa04587 100644
--- a/include/scsi/scsi_dbg.h
+++ b/include/scsi/scsi_dbg.h
@@ -19,8 +19,8 @@ extern int __scsi_print_sense(struct scsi_device *, const char *,
 extern void scsi_dump_sense(struct scsi_cmnd *);
 extern void __scsi_dump_sense(struct scsi_device *, const char *,
 			      const unsigned char *, int);
-extern void scsi_show_result(struct scsi_device *, const char *, int);
-extern void scsi_print_result(struct scsi_cmnd *);
+extern void scsi_show_result(struct scsi_device *, const char *, int, int);
+extern void scsi_print_result(struct scsi_cmnd *, int);
 extern const char *scsi_print_status(unsigned char);
 extern const char *scsi_sense_key_string(unsigned char);
 extern const char *scsi_extd_sense_format(unsigned char, unsigned char,
-- 
1.8.5.2

