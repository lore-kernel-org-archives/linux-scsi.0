From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/10] scsi: use per-cpu buffer for formatting sense
Date: Thu,  6 Nov 2014 09:30:36 +0100
Message-ID: <1415262639-121586-8-git-send-email-hare@suse.de>
References: <1415262639-121586-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbaKFIap (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2014 03:30:45 -0500
In-Reply-To: <1415262639-121586-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Convert sense buffer logging to use the per-cpu
buffer to avoid line breakup.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c    | 107 ----------------------------
 drivers/scsi/scsi_logging.c | 167 +++++++++++++++++++++++++++++++++++++++++---
 drivers/scsi/sd.c           |   7 +-
 drivers/scsi/ufs/ufshcd.c   |   6 +-
 4 files changed, 162 insertions(+), 125 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 003735f..82c8d68 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1216,113 +1216,6 @@ scsi_extd_sense_format(unsigned char asc, unsigned char ascq, const char **fmt)
 }
 EXPORT_SYMBOL(scsi_extd_sense_format);
 
-void
-scsi_show_extd_sense(const struct scsi_device *sdev, const char *name,
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
-scsi_show_sense_hdr(const struct scsi_device *sdev, const char *name,
-		    const struct scsi_sense_hdr *sshdr)
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
-scsi_print_sense_hdr(const struct scsi_device *sdev, const char *name,
-		     const struct scsi_sense_hdr *sshdr)
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
-void __scsi_print_sense(const struct scsi_device *sdev, const char *name,
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
-void scsi_print_sense(const struct scsi_cmnd *cmd)
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
diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
index d166d12..065792a3 100644
--- a/drivers/scsi/scsi_logging.c
+++ b/drivers/scsi/scsi_logging.c
@@ -64,14 +64,20 @@ static void scsi_log_release_buffer(char *bufptr)
 	preempt_enable();
 }
 
-static size_t scmd_format_header(char *logbuf, size_t logbuf_len,
-				 struct gendisk *disk, int tag)
+static inline const char *scmd_name(const struct scsi_cmnd *scmd)
+{
+	return scmd->request->rq_disk ?
+		scmd->request->rq_disk->disk_name : NULL;
+}
+
+static size_t sdev_format_header(char *logbuf, size_t logbuf_len,
+				 const char *name, int tag)
 {
 	size_t off = 0;
 
-	if (disk)
+	if (name)
 		off += scnprintf(logbuf + off, logbuf_len - off,
-				 "[%s] ", disk->disk_name);
+				 "[%s] ", name);
 
 	if (tag >= 0)
 		off += scnprintf(logbuf + off, logbuf_len - off,
@@ -109,7 +115,6 @@ EXPORT_SYMBOL_GPL(sdev_prefix_printk);
 int scmd_printk(const char *level, const struct scsi_cmnd *scmd,
 		const char *fmt, ...)
 {
-	struct gendisk *disk = scmd->request->rq_disk;
 	va_list args;
 	char *logbuf;
 	size_t off = 0, logbuf_len;
@@ -121,7 +126,7 @@ int scmd_printk(const char *level, const struct scsi_cmnd *scmd,
 	logbuf = scsi_log_reserve_buffer(&logbuf_len);
 	if (!logbuf)
 		return 0;
-	off = scmd_format_header(logbuf, logbuf_len, disk,
+	off = sdev_format_header(logbuf, logbuf_len, scmd_name(scmd),
 				 scmd->request->tag);
 	va_start(args, fmt);
 	off += vscnprintf(logbuf + off, logbuf_len - off, fmt, args);
@@ -201,7 +206,6 @@ EXPORT_SYMBOL(__scsi_format_command);
 
 void scsi_print_command(struct scsi_cmnd *cmd)
 {
-	struct gendisk *disk = cmd->request->rq_disk;
 	int k;
 	char *logbuf;
 	size_t off, logbuf_len;
@@ -213,7 +217,8 @@ void scsi_print_command(struct scsi_cmnd *cmd)
 	if (!logbuf)
 		return;
 
-	off = scmd_format_header(logbuf, logbuf_len, disk, cmd->request->tag);
+	off = sdev_format_header(logbuf, logbuf_len,
+				 scmd_name(cmd), cmd->request->tag);
 	off += scnprintf(logbuf + off, logbuf_len - off, "CDB: ");
 	off += scsi_format_opcode_name(logbuf + off, logbuf_len - off,
 				       cmd->cmnd);
@@ -229,7 +234,8 @@ void scsi_print_command(struct scsi_cmnd *cmd)
 			logbuf = scsi_log_reserve_buffer(&logbuf_len);
 			if (!logbuf)
 				break;
-			off = scmd_format_header(logbuf, logbuf_len, disk,
+			off = sdev_format_header(logbuf, logbuf_len,
+						 scmd_name(cmd),
 						 cmd->request->tag);
 			off += scnprintf(logbuf + off, logbuf_len - off,
 					 "CDB[%02x]: ", k);
@@ -249,3 +255,146 @@ void scsi_print_command(struct scsi_cmnd *cmd)
 	}
 }
 EXPORT_SYMBOL(scsi_print_command);
+
+static size_t
+scsi_format_extd_sense(char *buffer, size_t buf_len,
+		       unsigned char asc, unsigned char ascq)
+{
+	size_t off = 0;
+	const char *extd_sense_fmt = NULL;
+	const char *extd_sense_str = scsi_extd_sense_format(asc, ascq,
+							    &extd_sense_fmt);
+
+	if (extd_sense_str) {
+		off = scnprintf(buffer, buf_len, "Add. Sense: %s",
+				extd_sense_str);
+		if (extd_sense_fmt)
+			off += scnprintf(buffer + off, buf_len - off,
+					 "(%s%x)", extd_sense_fmt, ascq);
+	} else {
+		if (asc >= 0x80)
+			off = scnprintf(buffer, buf_len, "<<vendor>>");
+		off += scnprintf(buffer + off, buf_len - off,
+				 "ASC=0x%x ", asc);
+		if (ascq >= 0x80)
+			off += scnprintf(buffer + off, buf_len - off,
+					 "<<vendor>>");
+		off += scnprintf(buffer + off, buf_len - off,
+				 "ASCQ=0x%x ", ascq);
+	}
+	return off;
+}
+
+static size_t
+scsi_format_sense_hdr(char *buffer, size_t buf_len,
+		      const struct scsi_sense_hdr *sshdr)
+{
+	const char *sense_txt;
+	size_t off;
+
+	off = scnprintf(buffer, buf_len, "Sense Key : ");
+	sense_txt = scsi_sense_key_string(sshdr->sense_key);
+	if (sense_txt)
+		off += scnprintf(buffer + off, buf_len - off,
+				 "%s ", sense_txt);
+	else
+		off += scnprintf(buffer + off, buf_len - off,
+				 "0x%x ", sshdr->sense_key);
+	off += scnprintf(buffer + off, buf_len - off,
+		scsi_sense_is_deferred(sshdr) ? "[deferred] " : "[current] ");
+
+	if (sshdr->response_code >= 0x72)
+		off += scnprintf(buffer + off, buf_len - off, "[descriptor] ");
+	return off;
+}
+
+static void
+scsi_log_dump_sense(const struct scsi_device *sdev, const char *name, int tag,
+		    const unsigned char *sense_buffer, int sense_len)
+{
+	int i;
+
+	for (i = 0; i < sense_len; i += 16) {
+		char *logbuf;
+		int len = min(sense_len - i, 16);
+		size_t off, logbuf_len;
+
+		logbuf = scsi_log_reserve_buffer(&logbuf_len);
+		if (!logbuf)
+			break;
+		off = sdev_format_header(logbuf, logbuf_len,
+					 name, tag);
+		hex_dump_to_buffer(&sense_buffer[i], len, 16, 1,
+				   logbuf + off, logbuf_len - off,
+				   false);
+		dev_printk(KERN_INFO, &sdev->sdev_gendev, logbuf);
+		scsi_log_release_buffer(logbuf);
+	}
+}
+
+static void
+scsi_log_print_sense_hdr(const struct scsi_device *sdev, const char *name,
+			 int tag, const struct scsi_sense_hdr *sshdr)
+{
+	char *logbuf;
+	size_t off, logbuf_len;
+
+	logbuf = scsi_log_reserve_buffer(&logbuf_len);
+	if (!logbuf)
+		return;
+	off = sdev_format_header(logbuf, logbuf_len, name, tag);
+	off += scsi_format_sense_hdr(logbuf + off, logbuf_len - off, sshdr);
+	dev_printk(KERN_INFO, &sdev->sdev_gendev, logbuf);
+	scsi_log_release_buffer(logbuf);
+
+	logbuf = scsi_log_reserve_buffer(&logbuf_len);
+	if (!logbuf)
+		return;
+	off = sdev_format_header(logbuf, logbuf_len, name, tag);
+	off += scsi_format_extd_sense(logbuf + off, logbuf_len - off,
+				      sshdr->asc, sshdr->ascq);
+	dev_printk(KERN_INFO, &sdev->sdev_gendev, logbuf);
+	scsi_log_release_buffer(logbuf);
+}
+
+static void
+scsi_log_print_sense(const struct scsi_device *sdev, const char *name, int tag,
+		     const unsigned char *sense_buffer, int sense_len)
+{
+	struct scsi_sense_hdr sshdr;
+
+	if (scsi_normalize_sense(sense_buffer, sense_len, &sshdr))
+		scsi_log_print_sense_hdr(sdev, name, tag, &sshdr);
+	else
+		scsi_log_dump_sense(sdev, name, tag, sense_buffer, sense_len);
+}
+
+/*
+ * Print normalized SCSI sense header with a prefix.
+ */
+void
+scsi_print_sense_hdr(const struct scsi_device *sdev, const char *name,
+		     const struct scsi_sense_hdr *sshdr)
+{
+	scsi_log_print_sense_hdr(sdev, name, -1, sshdr);
+}
+EXPORT_SYMBOL(scsi_print_sense_hdr);
+
+/* Normalize and print sense buffer with name prefix */
+void __scsi_print_sense(const struct scsi_device *sdev, const char *name,
+			const unsigned char *sense_buffer, int sense_len)
+{
+	scsi_log_print_sense(sdev, name, -1, sense_buffer, sense_len);
+}
+EXPORT_SYMBOL(__scsi_print_sense);
+
+/* Normalize and print sense buffer in SCSI command */
+void scsi_print_sense(const struct scsi_cmnd *cmd)
+{
+	struct gendisk *disk = cmd->request->rq_disk;
+	const char *disk_name = disk ? disk->disk_name : NULL;
+
+	scsi_log_print_sense(cmd->device, disk_name, cmd->request->tag,
+			     cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
+}
+EXPORT_SYMBOL(scsi_print_sense);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e57baaf..5f6b199 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3315,11 +3315,8 @@ module_exit(exit_sd);
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
 
 static void sd_print_result(const struct scsi_disk *sdkp, const char *msg,
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9da3191..5c0298e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4709,10 +4709,8 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 		sdev_printk(KERN_WARNING, sdp,
 			    "START_STOP failed for power mode: %d, result %x\n",
 			    pwr_mode, ret);
-		if (driver_byte(ret) & DRIVER_SENSE) {
-			scsi_show_sense_hdr(sdp, NULL, &sshdr);
-			scsi_show_extd_sense(sdp, NULL, sshdr.asc, sshdr.ascq);
-		}
+		if (driver_byte(ret) & DRIVER_SENSE)
+			scsi_print_sense_hdr(sdp, NULL, &sshdr);
 	}
 
 	if (!ret)
-- 
1.8.5.2

