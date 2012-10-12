From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/10] scsi: use buffer for scsi_show_result()
Date: Fri, 12 Oct 2012 10:33:47 +0200
Message-ID: <1350030830-25614-8-git-send-email-hare@suse.de>
References: <1350030830-25614-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34576 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933617Ab2JLIeA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Oct 2012 04:34:00 -0400
In-Reply-To: <1350030830-25614-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Kay Sievers <kay@vrfy.org>

scsi_show_result() should be printing the message into a supplied
buffer to avoid linebreaks during output.

Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c |   23 +++++++++++++----------
 drivers/scsi/sd.c        |    6 ++++--
 include/scsi/scsi_dbg.h  |    2 +-
 3 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 65367e8..ded16d9 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1502,32 +1502,35 @@ static const char * const driverbyte_table[]={
 "DRIVER_INVALID", "DRIVER_TIMEOUT", "DRIVER_HARD", "DRIVER_SENSE"};
 #define NUM_DRIVERBYTE_STRS ARRAY_SIZE(driverbyte_table)
 
-void scsi_show_result(int result)
+void scsi_show_result(char *buf, int buf_size, int result)
 {
 	int hb = host_byte(result);
 	int db = driver_byte(result);
 
-	printk("Result: hostbyte=%s driverbyte=%s\n",
-	       (hb < NUM_HOSTBYTE_STRS ? hostbyte_table[hb]     : "invalid"),
-	       (db < NUM_DRIVERBYTE_STRS ? driverbyte_table[db] : "invalid"));
+	snprintf(buf, buf_size,
+		"Result: hostbyte=%s driverbyte=%s\n",
+		(hb < NUM_HOSTBYTE_STRS ? hostbyte_table[hb]     : "invalid"),
+		(db < NUM_DRIVERBYTE_STRS ? driverbyte_table[db] : "invalid"));
 }
 
 #else
 
-void scsi_show_result(int result)
+void scsi_show_result(char *buf, int buf_size, int result)
 {
-	printk("Result: hostbyte=0x%02x driverbyte=0x%02x\n",
-	       host_byte(result), driver_byte(result));
+	snprintf(buf, buf_size,
+		 "Result: hostbyte=0x%02x driverbyte=0x%02x\n",
+		 host_byte(result), driver_byte(result));
 }
 
 #endif
 EXPORT_SYMBOL(scsi_show_result);
 
-
 void scsi_print_result(struct scsi_cmnd *cmd)
 {
-	scmd_printk(KERN_INFO, cmd, " ");
-	scsi_show_result(cmd->result);
+	char result_buf[70];
+
+	scsi_show_result(result_buf, 70, cmd->result);
+	scmd_printk(KERN_INFO, cmd, "%s", result_buf);
 }
 EXPORT_SYMBOL(scsi_print_result);
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 12f6fdf..f6165e6 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3025,7 +3025,9 @@ static void sd_print_sense_hdr(struct scsi_disk *sdkp,
 
 static void sd_print_result(struct scsi_disk *sdkp, int result)
 {
-	sd_printk(KERN_INFO, sdkp, " ");
-	scsi_show_result(result);
+	char result_buf[70];
+
+	scsi_show_result(result_buf, 70, result);
+	sd_printk(KERN_INFO, sdkp, "%s", result_buf);
 }
 
diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
index e89844c..cc6abb4 100644
--- a/include/scsi/scsi_dbg.h
+++ b/include/scsi/scsi_dbg.h
@@ -15,7 +15,7 @@ extern void scsi_print_sense(char *, struct scsi_cmnd *);
 extern void __scsi_print_sense(const char *name,
 			       const unsigned char *sense_buffer,
 			       int sense_len);
-extern void scsi_show_result(int);
+extern void scsi_show_result(char *, int, int);
 extern void scsi_print_result(struct scsi_cmnd *);
 extern void scsi_print_status(unsigned char);
 extern const char *scsi_sense_key_string(unsigned char);
-- 
1.7.4.2

