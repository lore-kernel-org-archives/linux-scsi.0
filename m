From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 35/38] scsi: use seq_buf for formatting sense buffer
Date: Mon, 29 Sep 2014 13:59:04 +0200
Message-ID: <1411991947-130166-36-git-send-email-hare@suse.de>
References: <1411991947-130166-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59370 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880AbaI2L7S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2014 07:59:18 -0400
In-Reply-To: <1411991947-130166-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>

Convert sense buffer logging to use seq_buf to
avoid line breakup.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c    | 107 --------------------------------------------
 drivers/scsi/osst.c         |   4 +-
 drivers/scsi/scsi_logging.c | 104 ++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/sd.c           |   7 +--
 drivers/scsi/sg.c           |   2 +-
 drivers/scsi/st.c           |   4 +-
 include/scsi/scsi_dbg.h     |   2 +-
 7 files changed, 112 insertions(+), 118 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index f854b7e..0f02abe 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1221,113 +1221,6 @@ scsi_extd_sense_format(unsigned char asc, unsigned char ascq, const char **fmt)
 }
 EXPORT_SYMBOL(scsi_extd_sense_format);
 
-void
-scsi_show_extd_sense(struct scsi_device *sdev, const char *name,
-		     unsigned char asc, unsigned char ascq)
-{
-	const char *extd_sense_fmt = NULL;
-	const char *extd_sense_str = scsi_extd_sense_format(asc, ascq,
-							    &extd_sense_fmt);
-
-	if (extd_sense_str) {
-		if (extd_sense_fmt)
-			sdev_prefix_printk(KERN_INFO, sdev, name,
-					   "Add. Sense: %s (%s%x)",
-					   extd_sense_str, extd_sense_fmt,
-					   ascq);
-		else
-			sdev_prefix_printk(KERN_INFO, sdev, name,
-					   "Add. Sense: %s", extd_sense_str);
-
-	} else {
-		sdev_prefix_printk(KERN_INFO, sdev, name,
-				   "%sASC=0x%x %sASCQ=0x%x\n",
-				   asc >= 0x80 ? "<<vendor>> " : "", asc,
-				   ascq >= 0x80 ? "<<vendor>> " : "", ascq);
-	}
-}
-EXPORT_SYMBOL(scsi_show_extd_sense);
-
-void
-scsi_show_sense_hdr(struct scsi_device *sdev, const char *name,
-		    struct scsi_sense_hdr *sshdr)
-{
-	const char *sense_txt;
-
-	sense_txt = scsi_sense_key_string(sshdr->sense_key);
-	if (sense_txt)
-		sdev_prefix_printk(KERN_INFO, sdev, name,
-				   "Sense Key : %s [%s]%s\n", sense_txt,
-				   scsi_sense_is_deferred(sshdr) ?
-				   "deferred" : "current",
-				   sshdr->response_code >= 0x72 ?
-				   " [descriptor]" : "");
-	else
-		sdev_prefix_printk(KERN_INFO, sdev, name,
-				   "Sense Key : 0x%x [%s]%s", sshdr->sense_key,
-				   scsi_sense_is_deferred(sshdr) ?
-				   "deferred" : "current",
-				   sshdr->response_code >= 0x72 ?
-				   " [descriptor]" : "");
-}
-EXPORT_SYMBOL(scsi_show_sense_hdr);
-
-/*
- * Print normalized SCSI sense header with a prefix.
- */
-void
-scsi_print_sense_hdr(struct scsi_device *sdev, const char *name,
-		     struct scsi_sense_hdr *sshdr)
-{
-	scsi_show_sense_hdr(sdev, name, sshdr);
-	scsi_show_extd_sense(sdev, name, sshdr->asc, sshdr->ascq);
-}
-EXPORT_SYMBOL(scsi_print_sense_hdr);
-
-static void
-scsi_dump_sense_buffer(const unsigned char *sense_buffer, int sense_len)
-{
-	int k, num;
-
-	num = (sense_len < 32) ? sense_len : 32;
-	printk("Unrecognized sense data (in hex):");
-	for (k = 0; k < num; ++k) {
-		if (0 == (k % 16)) {
-			printk("\n");
-			printk(KERN_INFO "        ");
-		}
-		printk("%02x ", sense_buffer[k]);
-	}
-	printk("\n");
-	return;
-}
-
-/* Normalize and print sense buffer with name prefix */
-void __scsi_print_sense(struct scsi_device *sdev, const char *name,
-			const unsigned char *sense_buffer, int sense_len)
-{
-	struct scsi_sense_hdr sshdr;
-
-	if (!scsi_normalize_sense(sense_buffer, sense_len, &sshdr)) {
-		scsi_dump_sense_buffer(sense_buffer, sense_len);
-		return;
-	}
-	scsi_show_sense_hdr(sdev, name, &sshdr);
-	scsi_show_extd_sense(sdev, name, sshdr.asc, sshdr.ascq);
-}
-EXPORT_SYMBOL(__scsi_print_sense);
-
-/* Normalize and print sense buffer in SCSI command */
-void scsi_print_sense(struct scsi_cmnd *cmd)
-{
-	struct gendisk *disk = cmd->request->rq_disk;
-	const char *disk_name = disk ? disk->disk_name : NULL;
-
-	__scsi_print_sense(cmd->device, disk_name, cmd->sense_buffer,
-			   SCSI_SENSE_BUFFERSIZE);
-}
-EXPORT_SYMBOL(scsi_print_sense);
-
 #ifdef CONFIG_SCSI_CONSTANTS
 
 static const char * const hostbyte_table[]={
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 4ba2a9f..3616633 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -261,7 +261,7 @@ static int osst_chk_result(struct osst_tape * STp, struct osst_request * SRpnt)
 		if (scode) printk(OSST_DEB_MSG "%s:D: Sense: %02x, ASC: %02x, ASCQ: %02x\n",
 				  name, scode, sense[12], sense[13]);
 		if (cmdstatp->have_sense)
-			__scsi_print_sense(STp->device, name,
+			__scsi_print_sense(STp->device, name, -1,
 					   SRpnt->sense, SCSI_SENSE_BUFFERSIZE);
 	}
 	else
@@ -276,7 +276,7 @@ static int osst_chk_result(struct osst_tape * STp, struct osst_request * SRpnt)
 		 SRpnt->cmd[0] != TEST_UNIT_READY)) { /* Abnormal conditions for tape */
 		if (cmdstatp->have_sense) {
 			printk(KERN_WARNING "%s:W: Command with sense data:\n", name);
-			__scsi_print_sense(STp->device, name,
+			__scsi_print_sense(STp->device, name, -1,
 					   SRpnt->sense, SCSI_SENSE_BUFFERSIZE);
 		}
 		else {
diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
index 9bc0aa6..c3672e5 100644
--- a/drivers/scsi/scsi_logging.c
+++ b/drivers/scsi/scsi_logging.c
@@ -166,3 +166,107 @@ void scsi_print_command(struct scsi_cmnd *cmd)
 	sdev_seq_printk(KERN_INFO, cmd->device, &s);
 }
 EXPORT_SYMBOL(scsi_print_command);
+
+void
+scsi_format_extd_sense(struct seq_buf *s,
+		       unsigned char asc, unsigned char ascq)
+{
+	const char *extd_sense_fmt = NULL;
+	const char *extd_sense_str = scsi_extd_sense_format(asc, ascq,
+							    &extd_sense_fmt);
+
+	if (extd_sense_str) {
+		seq_buf_printf(s, "Add. Sense: %s", extd_sense_str);
+		if (extd_sense_fmt)
+			seq_buf_printf(s, "(%s%x)", extd_sense_fmt, ascq);
+	} else {
+		if (asc >= 0x80)
+			seq_buf_printf(s, "<<vendor>>");
+		seq_buf_printf(s, "ASC=0x%x ", asc);
+		if (ascq >= 0x80)
+			seq_buf_printf(s, "<<vendor>>");
+		seq_buf_printf(s, "ASCQ=0x%x ", ascq);
+	}
+}
+
+void
+scsi_format_sense_hdr(struct seq_buf *s, struct scsi_sense_hdr *sshdr)
+{
+	const char *sense_txt;
+
+	seq_buf_printf(s, "Sense Key : ");
+	sense_txt = scsi_sense_key_string(sshdr->sense_key);
+	if (sense_txt)
+		seq_buf_printf(s, "%s ", sense_txt);
+	else
+		seq_buf_printf(s, "0x%x ", sshdr->sense_key);
+	seq_buf_printf(s, "[%s] ",
+		   scsi_sense_is_deferred(sshdr) ? "deferred" : "current");
+	if (sshdr->response_code >= 0x72)
+		seq_buf_printf(s, "[descriptor] ");
+}
+
+static void __sdev_print_sense(struct seq_buf *s, struct scsi_device *sdev,
+			       const char *name, int tag,
+			       struct scsi_sense_hdr *sshdr)
+{
+	sdev_format_header(s, sdev, name, tag);
+	scsi_format_sense_hdr(s, sshdr);
+	sdev_seq_printk(KERN_INFO, sdev, s);
+
+	sdev_format_header(s, sdev, name, tag);
+	scsi_format_extd_sense(s, sshdr->asc, sshdr->ascq);
+	sdev_seq_printk(KERN_INFO, sdev, s);
+}
+
+/*
+ * Print normalized SCSI sense header with a prefix.
+ */
+void
+scsi_print_sense_hdr(struct scsi_device *sdev, const char *name,
+		     struct scsi_sense_hdr *sshdr)
+{
+	char logbuf[SCSI_LOG_BUFSIZE];
+	struct seq_buf s;
+
+	seq_buf_init(&s, logbuf, SCSI_LOG_BUFSIZE);
+	__sdev_print_sense(&s, sdev, name, -1, sshdr);
+}
+EXPORT_SYMBOL(scsi_print_sense_hdr);
+
+/* Normalize and print sense buffer with name prefix */
+void __scsi_print_sense(struct scsi_device *sdev, const char *name, int tag,
+			const unsigned char *sense_buffer, int sense_len)
+{
+	struct scsi_sense_hdr sshdr;
+	char logbuf[SCSI_LOG_BUFSIZE];
+	struct seq_buf s;
+
+	seq_buf_init(&s, logbuf, SCSI_LOG_BUFSIZE);
+
+	if (!scsi_normalize_sense(sense_buffer, sense_len, &sshdr)) {
+		int i;
+
+		for (i = 0; i < sense_len; i += 16) {
+			int len = min(sense_len - i, 16);
+
+			sdev_format_header(&s, sdev, name, tag);
+			seq_buf_putmem_hex(&s, &sense_buffer[i], len);
+			sdev_seq_printk(KERN_INFO, sdev, &s);
+		}
+		return;
+	}
+	__sdev_print_sense(&s, sdev, name, tag, &sshdr);
+}
+EXPORT_SYMBOL(__scsi_print_sense);
+
+/* Normalize and print sense buffer in SCSI command */
+void scsi_print_sense(struct scsi_cmnd *cmd)
+{
+	struct gendisk *disk = cmd->request->rq_disk;
+	const char *disk_name = disk ? disk->disk_name : NULL;
+
+	__scsi_print_sense(cmd->device, disk_name, cmd->request->tag,
+			   cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
+}
+EXPORT_SYMBOL(scsi_print_sense);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2cc8703..754419f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3312,11 +3312,8 @@ module_exit(exit_sd);
 static void sd_print_sense_hdr(struct scsi_disk *sdkp,
 			       struct scsi_sense_hdr *sshdr)
 {
-	scsi_show_sense_hdr(sdkp->device,
-			    sdkp->disk ? sdkp->disk->disk_name : NULL, sshdr);
-	scsi_show_extd_sense(sdkp->device,
-			     sdkp->disk ? sdkp->disk->disk_name : NULL,
-			     sshdr->asc, sshdr->ascq);
+	scsi_print_sense_hdr(sdkp->device,
+			     sdkp->disk ? sdkp->disk->disk_name : NULL, sshdr);
 }
 
 static void sd_print_result(struct scsi_disk *sdkp, const char *msg,
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index fde1f18..cc60f90 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1360,7 +1360,7 @@ sg_rq_end_io(struct request *rq, int uptodate)
 		if ((sdp->sgdebug > 0) &&
 		    ((CHECK_CONDITION == srp->header.masked_status) ||
 		     (COMMAND_TERMINATED == srp->header.masked_status)))
-			__scsi_print_sense(sdp->device, __func__, sense,
+			__scsi_print_sense(sdp->device, __func__, -1, sense,
 					   SCSI_SENSE_BUFFERSIZE);
 
 		/* Following if statement is a patch supplied by Eric Youngdale */
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 052d1f9..2ee9fbb 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -373,7 +373,7 @@ static int st_chk_result(struct scsi_tape *STp, struct st_request * SRpnt)
 			    SRpnt->cmd[0], SRpnt->cmd[1], SRpnt->cmd[2],
 			    SRpnt->cmd[3], SRpnt->cmd[4], SRpnt->cmd[5]);
 		if (cmdstatp->have_sense)
-			__scsi_print_sense(STp->device, name,
+			__scsi_print_sense(STp->device, name, -1,
 					   SRpnt->sense, SCSI_SENSE_BUFFERSIZE);
 	} ) /* end DEB */
 	if (!debugging) { /* Abnormal conditions for tape */
@@ -390,7 +390,7 @@ static int st_chk_result(struct scsi_tape *STp, struct st_request * SRpnt)
 			 SRpnt->cmd[0] != MODE_SENSE &&
 			 SRpnt->cmd[0] != TEST_UNIT_READY) {
 
-			__scsi_print_sense(STp->device, name,
+			__scsi_print_sense(STp->device, name, -1,
 					   SRpnt->sense, SCSI_SENSE_BUFFERSIZE);
 		}
 	}
diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
index 0281842..2a5f9b2 100644
--- a/include/scsi/scsi_dbg.h
+++ b/include/scsi/scsi_dbg.h
@@ -17,7 +17,7 @@ extern void scsi_show_sense_hdr(struct scsi_device *, const char *,
 extern void scsi_print_sense_hdr(struct scsi_device *, const char *,
 				 struct scsi_sense_hdr *);
 extern void scsi_print_sense(struct scsi_cmnd *);
-extern void __scsi_print_sense(struct scsi_device *, const char *name,
+extern void __scsi_print_sense(struct scsi_device *, const char *name, int tag,
 			       const unsigned char *sense_buffer,
 			       int sense_len);
 extern void scsi_print_result(struct scsi_cmnd *, const char *, int);
-- 
1.8.5.2

