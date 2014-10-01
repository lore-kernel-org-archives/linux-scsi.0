From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 19/24] scsi: separate out scsi_(host|driver)byte_string()
Date: Wed,  1 Oct 2014 08:22:55 +0200
Message-ID: <1412144580-72880-20-git-send-email-hare@suse.de>
References: <1412144580-72880-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52345 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbaJAGXJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Oct 2014 02:23:09 -0400
In-Reply-To: <1412144580-72880-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>

Export functions for later use.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c | 58 ++++++++++++++++++++++++++++++++++++------------
 include/scsi/scsi_dbg.h  |  2 ++
 2 files changed, 46 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 713e1e0..d3e1900 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1404,38 +1404,68 @@ static const char * const hostbyte_table[]={
 "DID_PASSTHROUGH", "DID_SOFT_ERROR", "DID_IMM_RETRY", "DID_REQUEUE",
 "DID_TRANSPORT_DISRUPTED", "DID_TRANSPORT_FAILFAST", "DID_TARGET_FAILURE",
 "DID_NEXUS_FAILURE" };
-#define NUM_HOSTBYTE_STRS ARRAY_SIZE(hostbyte_table)
 
 static const char * const driverbyte_table[]={
 "DRIVER_OK", "DRIVER_BUSY", "DRIVER_SOFT",  "DRIVER_MEDIA", "DRIVER_ERROR",
 "DRIVER_INVALID", "DRIVER_TIMEOUT", "DRIVER_HARD", "DRIVER_SENSE"};
-#define NUM_DRIVERBYTE_STRS ARRAY_SIZE(driverbyte_table)
 
-void scsi_show_result(int result)
+#endif
+
+const char *scsi_hostbyte_string(int result)
 {
+	const char *hb_string = NULL;
+#ifdef CONFIG_SCSI_CONSTANTS
 	int hb = host_byte(result);
-	int db = driver_byte(result);
 
-	printk("Result: hostbyte=%s driverbyte=%s\n",
-	       (hb < NUM_HOSTBYTE_STRS ? hostbyte_table[hb]     : "invalid"),
-	       (db < NUM_DRIVERBYTE_STRS ? driverbyte_table[db] : "invalid"));
+	if (hb < ARRAY_SIZE(hostbyte_table))
+		hb_string = hostbyte_table[hb];
+#endif
+	return hb_string;
 }
+EXPORT_SYMBOL(scsi_hostbyte_string);
 
-#else
+const char *scsi_driverbyte_string(int result)
+{
+	const char *db_string = NULL;
+#ifdef CONFIG_SCSI_CONSTANTS
+	int db = driver_byte(result);
+
+	if (db < ARRAY_SIZE(driverbyte_table))
+		db_string = driverbyte_table[db];
+#endif
+	return db_string;
+}
+EXPORT_SYMBOL(scsi_driverbyte_string);
 
 void scsi_show_result(int result)
 {
-	printk("Result: hostbyte=0x%02x driverbyte=0x%02x\n",
-	       host_byte(result), driver_byte(result));
-}
+	const char *hb_string = scsi_hostbyte_string(result);
+	const char *db_string = scsi_driverbyte_string(result);
 
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
+	const char *hb_string = scsi_hostbyte_string(cmd->result);
+	const char *db_string = scsi_driverbyte_string(cmd->result);
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
index 44bea15..fb3e0d4 100644
--- a/include/scsi/scsi_dbg.h
+++ b/include/scsi/scsi_dbg.h
@@ -19,6 +19,8 @@ extern void __scsi_print_sense(struct scsi_device *, const char *name,
 			       int sense_len);
 extern void scsi_show_result(int);
 extern void scsi_print_result(struct scsi_cmnd *);
+extern const char *scsi_hostbyte_string(int);
+extern const char *scsi_driverbyte_string(int);
 extern const char *scsi_sense_key_string(unsigned char);
 extern const char *scsi_extd_sense_format(unsigned char, unsigned char,
 					  const char **);
-- 
1.8.5.2

