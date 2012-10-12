From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/10] scsi: use local buffer for decoding sense data
Date: Fri, 12 Oct 2012 10:33:50 +0200
Message-ID: <1350030830-25614-11-git-send-email-hare@suse.de>
References: <1350030830-25614-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34587 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933621Ab2JLIeC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Oct 2012 04:34:02 -0400
In-Reply-To: <1350030830-25614-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Kay Sievers <kay@vrfy.org>

Instead of printing directly to console we should be using
a local buffer for formatting sense data.
This will avoid garbled output.

Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c |  102 +++++++++++++++++++++++++--------------------
 drivers/scsi/sd.c        |   10 +++--
 include/scsi/scsi_dbg.h  |    4 +-
 3 files changed, 65 insertions(+), 51 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index df69ba3..9115233 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1299,49 +1299,52 @@ scsi_extd_sense_format(unsigned char asc, unsigned char ascq) {
 EXPORT_SYMBOL(scsi_extd_sense_format);
 
 void
-scsi_show_extd_sense(unsigned char asc, unsigned char ascq)
+scsi_show_extd_sense(char *buf, int buf_len,
+		     unsigned char asc, unsigned char ascq)
 {
-        const char *extd_sense_fmt = scsi_extd_sense_format(asc, ascq);
+	const char *extd_sense_fmt = scsi_extd_sense_format(asc, ascq);
+	int sz = 0;
 
 	if (extd_sense_fmt) {
 		if (strstr(extd_sense_fmt, "%x")) {
-			printk("Add. Sense: ");
-			printk(extd_sense_fmt, ascq);
+			sz = snprintf(buf, buf_len, "Add. Sense: ");
+			sz += snprintf(buf + sz, buf_len - sz,
+				       extd_sense_fmt, ascq);
 		} else
-			printk("Add. Sense: %s", extd_sense_fmt);
+			sz = snprintf(buf, buf_len, "Add. Sense: %s",
+				      extd_sense_fmt);
 	} else {
 		if (asc >= 0x80)
-			printk("<<vendor>> ASC=0x%x ASCQ=0x%x", asc,
-			       ascq);
-		if (ascq >= 0x80)
-			printk("ASC=0x%x <<vendor>> ASCQ=0x%x", asc,
-			       ascq);
+			snprintf(buf, buf_len, "<<vendor>> ASC=0x%x ASCQ=0x%x",
+				 asc, ascq);
+		else if (ascq >= 0x80)
+			snprintf(buf, buf_len, "ASC=0x%x <<vendor>> ASCQ=0x%x",
+				 asc, ascq);
 		else
-			printk("ASC=0x%x ASCQ=0x%x", asc, ascq);
+			snprintf(buf, buf_len, "ASC=0x%x ASCQ=0x%x", asc, ascq);
 	}
-
-	printk("\n");
 }
 EXPORT_SYMBOL(scsi_show_extd_sense);
 
 void
-scsi_show_sense_hdr(struct scsi_sense_hdr *sshdr)
+scsi_show_sense_hdr(char *buf, int buf_len, struct scsi_sense_hdr *sshdr)
 {
 	const char *sense_txt;
+	int sz;
 
 	sense_txt = scsi_sense_key_string(sshdr->sense_key);
 	if (sense_txt)
-		printk("Sense Key : %s ", sense_txt);
+		sz = snprintf(buf, buf_len, "Sense Key : %s ", sense_txt);
 	else
-		printk("Sense Key : 0x%x ", sshdr->sense_key);
+		sz = snprintf(buf, buf_len, "Sense Key : 0x%x ",
+			      sshdr->sense_key);
 
-	printk("%s", scsi_sense_is_deferred(sshdr) ? "[deferred] " :
-	       "[current] ");
+	sz += snprintf(buf + sz, buf_len - sz, "%s",
+		       scsi_sense_is_deferred(sshdr) ?
+		       "[deferred] " : "[current] ");
 
 	if (sshdr->response_code >= 0x72)
-		printk("[descriptor]");
-
-	printk("\n");
+		sz += snprintf(buf + sz, buf_len - sz, "[descriptor]");
 }
 EXPORT_SYMBOL(scsi_show_sense_hdr);
 
@@ -1351,10 +1354,12 @@ EXPORT_SYMBOL(scsi_show_sense_hdr);
 void
 scsi_print_sense_hdr(const char *name, struct scsi_sense_hdr *sshdr)
 {
-	printk(KERN_INFO "%s: ", name);
-	scsi_show_sense_hdr(sshdr);
-	printk(KERN_INFO "%s: ", name);
-	scsi_show_extd_sense(sshdr->asc, sshdr->ascq);
+	char sense_buf[128];
+
+	scsi_show_sense_hdr(sense_buf, 128, sshdr);
+	pr_info("%s: %s", name, sense_buf);
+	scsi_show_extd_sense(sense_buf, 128, sshdr->asc, sshdr->ascq);
+	pr_info("%s: %s", name, sense_buf);
 }
 EXPORT_SYMBOL(scsi_print_sense_hdr);
 
@@ -1365,20 +1370,21 @@ void
 scsi_cmd_print_sense_hdr(struct scsi_cmnd *scmd, const char *desc,
 			  struct scsi_sense_hdr *sshdr)
 {
-	scmd_printk(KERN_INFO, scmd, "%s: ", desc);
-	scsi_show_sense_hdr(sshdr);
-	scmd_printk(KERN_INFO, scmd, "%s: ", desc);
-	scsi_show_extd_sense(sshdr->asc, sshdr->ascq);
+	char sense_buf[128];
+
+	scsi_show_sense_hdr(sense_buf, 128, sshdr);
+	scmd_printk(KERN_INFO, scmd, "%s: %s", desc, sense_buf);
+	scsi_show_extd_sense(sense_buf, 128, sshdr->asc, sshdr->ascq);
+	scmd_printk(KERN_INFO, scmd, "%s: %s", desc, sense_buf);
 }
 EXPORT_SYMBOL(scsi_cmd_print_sense_hdr);
 
-static void
-scsi_decode_sense_extras(const unsigned char *sense_buffer, int sense_len,
+static int
+scsi_decode_sense_extras(char *buff, int buff_len,
 			 struct scsi_sense_hdr *sshdr)
 {
 	int res = 0;
-	char buff[80];
-	int blen = sense_len;
+	int blen = buff_len;
 
 	if (sshdr->info)
 		res += snprintf(buff + res, blen - res,
@@ -1402,8 +1408,7 @@ scsi_decode_sense_extras(const unsigned char *sense_buffer, int sense_len,
 			res += snprintf(buff + res, blen - res, ", ");
 		res += snprintf(buff + res, blen - res, "ILI");
 	}
-	if (res > 0)
-		pr_info("%s\n", buff);
+	return res;
 }
 
 /* Normalize and print sense buffer with name prefix */
@@ -1411,6 +1416,8 @@ void __scsi_print_sense(const char *name, const unsigned char *sense_buffer,
 			int sense_len)
 {
 	struct scsi_sense_hdr sshdr;
+	char sense_buf[128];
+	int len;
 
 	if (!scsi_normalize_sense(sense_buffer, sense_len, &sshdr)) {
 		/* this may be SCSI-1 sense data */
@@ -1420,11 +1427,13 @@ void __scsi_print_sense(const char *name, const unsigned char *sense_buffer,
 			       16, 1, sense_buffer, num, false);
 		return;
 	}
+	scsi_show_sense_hdr(sense_buf, 128, &sshdr);
+	pr_info("%s: %s", name, sense_buf);
+	len = scsi_decode_sense_extras(sense_buf, 128, &sshdr);
+	if (len)
+		pr_info("%s: %s", name, sense_buf);
+	scsi_show_extd_sense(sense_buf, 128, sshdr.asc, sshdr.ascq);
 	printk(KERN_INFO "%s: ", name);
-	scsi_show_sense_hdr(&sshdr);
-	scsi_decode_sense_extras(sense_buffer, sense_len, &sshdr);
-	printk(KERN_INFO "%s: ", name);
-	scsi_show_extd_sense(sshdr.asc, sshdr.ascq);
 }
 EXPORT_SYMBOL(__scsi_print_sense);
 
@@ -1432,6 +1441,8 @@ EXPORT_SYMBOL(__scsi_print_sense);
 void scsi_print_sense(char *name, struct scsi_cmnd *cmd)
 {
 	struct scsi_sense_hdr sshdr;
+	char sense_buf[128];
+	int len;
 
 	if (!scsi_normalize_sense(cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE,
 				  &sshdr)) {
@@ -1442,12 +1453,13 @@ void scsi_print_sense(char *name, struct scsi_cmnd *cmd)
 			       false);
 		return;
 	}
-	scmd_printk(KERN_INFO, cmd, " ");
-	scsi_show_sense_hdr(&sshdr);
-	scsi_decode_sense_extras(cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE,
-				 &sshdr);
-	scmd_printk(KERN_INFO, cmd, " ");
-	scsi_show_extd_sense(sshdr.asc, sshdr.ascq);
+	scsi_show_sense_hdr(sense_buf, 128, &sshdr);
+	scmd_printk(KERN_INFO, cmd, "%s", sense_buf);
+	len = scsi_decode_sense_extras(sense_buf, 128, &sshdr);
+	if (len)
+		scmd_printk(KERN_INFO, cmd, "%s", sense_buf);
+	scsi_show_extd_sense(sense_buf, 128, sshdr.asc, sshdr.ascq);
+	scmd_printk(KERN_INFO, cmd, "%s", sense_buf);
 }
 EXPORT_SYMBOL(scsi_print_sense);
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f6165e6..0c3d8e6 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3017,10 +3017,12 @@ module_exit(exit_sd);
 static void sd_print_sense_hdr(struct scsi_disk *sdkp,
 			       struct scsi_sense_hdr *sshdr)
 {
-	sd_printk(KERN_INFO, sdkp, " ");
-	scsi_show_sense_hdr(sshdr);
-	sd_printk(KERN_INFO, sdkp, " ");
-	scsi_show_extd_sense(sshdr->asc, sshdr->ascq);
+	char sense_buf[128];
+
+	scsi_show_sense_hdr(sense_buf, 128, sshdr);
+	sd_printk(KERN_INFO, sdkp, "%s", sense_buf);
+	scsi_show_extd_sense(sense_buf, 128, sshdr->asc, sshdr->ascq);
+	sd_printk(KERN_INFO, sdkp, "%s", sense_buf);
 }
 
 static void sd_print_result(struct scsi_disk *sdkp, int result)
diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
index cc6abb4..301ce7d 100644
--- a/include/scsi/scsi_dbg.h
+++ b/include/scsi/scsi_dbg.h
@@ -6,8 +6,8 @@ struct scsi_sense_hdr;
 
 extern void scsi_print_command(struct scsi_cmnd *);
 extern void __scsi_print_command(unsigned char *);
-extern void scsi_show_extd_sense(unsigned char, unsigned char);
-extern void scsi_show_sense_hdr(struct scsi_sense_hdr *);
+extern void scsi_show_extd_sense(char *, int, unsigned char, unsigned char);
+extern void scsi_show_sense_hdr(char *, int, struct scsi_sense_hdr *);
 extern void scsi_print_sense_hdr(const char *, struct scsi_sense_hdr *);
 extern void scsi_cmd_print_sense_hdr(struct scsi_cmnd *, const char *,
 				     struct scsi_sense_hdr *);
-- 
1.7.4.2

