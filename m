From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 16/20] scsi: separate out scsi_retval_string()
Date: Wed,  3 Sep 2014 12:06:11 +0200
Message-ID: <1409738775-80876-17-git-send-email-hare@suse.de>
References: <1409738775-80876-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59645 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932338AbaICKGb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Sep 2014 06:06:31 -0400
In-Reply-To: <1409738775-80876-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Yoshihiro Yunomae <yoshihiro.yunomae.ez@hitachi.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Implement scsi_retval_string() to simplify logging.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c | 28 ++++++++++++++++++++++++++++
 drivers/scsi/scsi.c      | 34 ++++++----------------------------
 include/scsi/scsi_dbg.h  |  1 +
 3 files changed, 35 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 5486816..85d2da0 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1426,6 +1426,34 @@ void scsi_print_sense(struct scsi_cmnd *cmd)
 EXPORT_SYMBOL(scsi_print_sense);
 
 #ifdef CONFIG_SCSI_CONSTANTS
+static const struct error_info internal_retval_table[] =
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
+scsi_retval_string(unsigned int ret)
+{
+#ifdef CONFIG_SCSI_CONSTANTS
+	int i;
+
+	for (i = 0; internal_retval_table[i].text; i++)
+		if (internal_retval_table[i].code12 == ret)
+			return internal_retval_table[i].text;
+#endif
+	return NULL;
+}
+
+#ifdef CONFIG_SCSI_CONSTANTS
 
 static const char * const hostbyte_table[]={
 "DID_OK", "DID_NO_CONNECT", "DID_BUS_BUSY", "DID_TIME_OUT", "DID_BAD_TARGET",
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 8954036..a1944c8 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -566,35 +566,13 @@ void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
 				       SCSI_LOG_MLCOMPLETE_BITS);
 		if (((level > 0) && (cmd->result || disposition != SUCCESS)) ||
 		    (level > 1)) {
-			scmd_printk(KERN_INFO, cmd, "Done: ");
 			if (level > 2)
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
+				scmd_printk(KERN_INFO, cmd,
+					    "Done: 0x%p %s\n", cmd,
+					    scsi_retval_string(disposition));
+			else
+				scmd_printk(KERN_INFO, cmd, "Done: %s",
+					    scsi_retval_string(disposition));
 			scsi_print_result(cmd);
 			scsi_print_command(cmd);
 			if (status_byte(cmd->result) & CHECK_CONDITION)
diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
index 5020e5e..1030cc1 100644
--- a/include/scsi/scsi_dbg.h
+++ b/include/scsi/scsi_dbg.h
@@ -19,6 +19,7 @@ extern void __scsi_print_sense(struct scsi_device *, const char *name,
 			       int sense_len);
 extern void scsi_show_result(int);
 extern void scsi_print_result(struct scsi_cmnd *);
+extern const char *scsi_retval_string(unsigned int);
 extern const char *scsi_sense_key_string(unsigned char);
 extern const char *scsi_extd_sense_format(unsigned char, unsigned char,
 					  const char **);
-- 
1.8.5.2

