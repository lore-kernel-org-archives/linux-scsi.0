From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 17/20] scsi: separate out scsi_host_hostbyte() and scsi_show_driverbyte()
Date: Wed,  3 Sep 2014 12:06:12 +0200
Message-ID: <1409738775-80876-18-git-send-email-hare@suse.de>
References: <1409738775-80876-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59779 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932460AbaICKGc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Sep 2014 06:06:32 -0400
In-Reply-To: <1409738775-80876-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Yoshihiro Yunomae <yoshihiro.yunomae.ez@hitachi.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c | 56 +++++++++++++++++++++++++++++++++++++-----------
 include/scsi/scsi_dbg.h  |  2 ++
 2 files changed, 46 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 85d2da0..630e272 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1468,31 +1468,63 @@ static const char * const driverbyte_table[]={
 "DRIVER_INVALID", "DRIVER_TIMEOUT", "DRIVER_HARD", "DRIVER_SENSE"};
 #define NUM_DRIVERBYTE_STRS ARRAY_SIZE(driverbyte_table)
 
-void scsi_show_result(int result)
+#endif
+
+const char *scsi_show_hostbyte(int result)
 {
+	const char *hb_string = NULL;
+#ifdef CONFIG_SCSI_CONSTANTS
 	int hb = host_byte(result);
-	int db = driver_byte(result);
 
-	printk("Result: hostbyte=%s driverbyte=%s\n",
-	       (hb < NUM_HOSTBYTE_STRS ? hostbyte_table[hb]     : "invalid"),
-	       (db < NUM_DRIVERBYTE_STRS ? driverbyte_table[db] : "invalid"));
+	if (hb < NUM_HOSTBYTE_STRS)
+		hb_string = hostbyte_table[hb];
+#endif
+	return hb_string;
 }
+EXPORT_SYMBOL(scsi_show_hostbyte);
 
-#else
+const char *scsi_show_driverbyte(int result)
+{
+	const char *db_string = NULL;
+#ifdef CONFIG_SCSI_CONSTANTS
+	int db = driver_byte(result);
+
+	if (db < NUM_DRIVERBYTE_STRS)
+		db_string = driverbyte_table[db];
+#endif
+	return db_string;
+}
+EXPORT_SYMBOL(scsi_show_driverbyte);
 
 void scsi_show_result(int result)
 {
-	printk("Result: hostbyte=0x%02x driverbyte=0x%02x\n",
-	       host_byte(result), driver_byte(result));
-}
+	const char *hb_string = scsi_show_hostbyte(result);
+	const char *db_string = scsi_show_driverbyte(result);
 
-#endif
+	if (hb_string || db_string)
+		printk("Result: hostbyte=%s driverbyte=%s\n",
+		       hb_string ? hb_string : "invalid",
+		       db_string ? db_string : "invalid");
+	else
+		printk("Result: hostbyte=0x%02x driverbyte=0x%02x\n",
+		       host_byte(result), driver_byte(result));
+}
 EXPORT_SYMBOL(scsi_show_result);
 
 
 void scsi_print_result(struct scsi_cmnd *cmd)
 {
-	scmd_printk(KERN_INFO, cmd, " ");
-	scsi_show_result(cmd->result);
+	const char *hb_string = scsi_show_hostbyte(cmd->result);
+	const char *db_string = scsi_show_driverbyte(cmd->result);
+
+	if (hb_string || db_string)
+		scmd_printk(KERN_INFO, cmd,
+			    "Result: hostbyte=%s driverbyte=%s",
+			    hb_string ? hb_string : "invalid",
+			    db_string ? db_string : "invalid");
+	else
+		scmd_printk(KERN_INFO, cmd,
+			    "Result: hostbyte=0x%02x driverbyte=0x%02x",
+			    host_byte(cmd->result), driver_byte(cmd->result));
 }
 EXPORT_SYMBOL(scsi_print_result);
diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
index 1030cc1..a3170a5 100644
--- a/include/scsi/scsi_dbg.h
+++ b/include/scsi/scsi_dbg.h
@@ -19,6 +19,8 @@ extern void __scsi_print_sense(struct scsi_device *, const char *name,
 			       int sense_len);
 extern void scsi_show_result(int);
 extern void scsi_print_result(struct scsi_cmnd *);
+extern const char *scsi_show_hostbyte(int);
+extern const char *scsi_show_driverbyte(int);
 extern const char *scsi_retval_string(unsigned int);
 extern const char *scsi_sense_key_string(unsigned char);
 extern const char *scsi_extd_sense_format(unsigned char, unsigned char,
-- 
1.8.5.2

