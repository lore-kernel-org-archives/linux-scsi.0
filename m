From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 03/10] scsi: use external buffer for command logging
Date: Tue,  4 Nov 2014 09:06:42 +0100
Message-ID: <1415088409-46590-4-git-send-email-hare@suse.de>
References: <1415088409-46590-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38539 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbaKDIG4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Nov 2014 03:06:56 -0500
In-Reply-To: <1415088409-46590-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Use an external buffer for __scsi_print_command() and
move command logging over to use the per-cpu logging
buffer. With that we can guarantee the command always
will always be formatted in one line.
So we can even print out a variable length command
correctly across several lines.
Finally rename __scsi_print_command() to
__scsi_format_comment() to better reflect the
functionality.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/ch.c           |   6 +-
 drivers/scsi/constants.c    |  74 +----------------------
 drivers/scsi/scsi_logging.c | 144 +++++++++++++++++++++++++++++++++++++++++---
 drivers/scsi/sr_ioctl.c     |  13 +++-
 include/scsi/scsi.h         |   3 +
 include/scsi/scsi_dbg.h     |   6 +-
 6 files changed, 160 insertions(+), 86 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 226ef77..225a867 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -195,8 +195,10 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
  retry:
 	errno = 0;
 	if (debug) {
-		DPRINTK("command: ");
-		__scsi_print_command(cmd, cmd_len);
+		char logbuf[SCSI_LOG_BUFSIZE];
+
+		__scsi_format_command(logbuf, SCSI_LOG_BUFSIZE, cmd, cmd_len);
+		DPRINTK("command: %s", logbuf);
 	}
 
 	result = scsi_execute_req(ch->device, cmd, direction, buffer,
diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index a1a7fca..68c6a66 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -29,8 +29,6 @@
 #define THIRD_PARTY_COPY_OUT 0x83
 #define THIRD_PARTY_COPY_IN 0x84
 
-#define VENDOR_SPECIFIC_CDB 0xc0
-
 struct sa_name_list {
 	int opcode;
 	const struct value_name_pair *arr;
@@ -286,8 +284,8 @@ static struct sa_name_list sa_names_arr[] = {
 };
 #endif /* CONFIG_SCSI_CONSTANTS */
 
-static bool scsi_opcode_sa_name(int opcode, int service_action,
-				const char **cdb_name, const char **sa_name)
+bool scsi_opcode_sa_name(int opcode, int service_action,
+			 const char **cdb_name, const char **sa_name)
 {
 	struct sa_name_list *sa_name_ptr;
 	const struct value_name_pair *arr = NULL;
@@ -320,74 +318,6 @@ static bool scsi_opcode_sa_name(int opcode, int service_action,
 	return true;
 }
 
-static void print_opcode_name(const unsigned char *cdbp, size_t cdb_len)
-{
-	int sa, cdb0;
-	const char *cdb_name = NULL, *sa_name = NULL;
-
-	cdb0 = cdbp[0];
-	if (cdb0 == VARIABLE_LENGTH_CMD) {
-		if (cdb_len < 10) {
-			printk("short variable length command, len=%zu",
-			       cdb_len);
-			return;
-		}
-		sa = (cdbp[8] << 8) + cdbp[9];
-	} else
-		sa = cdbp[1] & 0x1f;
-
-	if (!scsi_opcode_sa_name(cdb0, sa, &cdb_name, &sa_name)) {
-		if (cdb_name)
-			printk("%s", cdb_name);
-		else if (cdb0 >= VENDOR_SPECIFIC_CDB)
-			printk("cdb[0]=0x%x (vendor)", cdb0);
-		else if (cdb0 >= 0x60 && cdb0 < 0x7e)
-			printk("cdb[0]=0x%x (reserved)", cdb0);
-		else
-			printk("cdb[0]=0x%x", cdb0);
-	} else {
-		if (sa_name)
-			printk("%s", sa_name);
-		else if (cdb_name)
-			printk("%s, sa=0x%x", cdb_name, sa);
-		else
-			printk("cdb[0]=0x%x, sa=0x%x", cdb0, sa);
-	}
-}
-
-void __scsi_print_command(const unsigned char *cdb, size_t cdb_len)
-{
-	int k, len;
-
-	print_opcode_name(cdb, cdb_len);
-	len = scsi_command_size(cdb);
-	if (cdb_len < len)
-		len = cdb_len;
-	/* print out all bytes in cdb */
-	for (k = 0; k < len; ++k)
-		printk(" %02x", cdb[k]);
-	printk("\n");
-}
-EXPORT_SYMBOL(__scsi_print_command);
-
-void scsi_print_command(struct scsi_cmnd *cmd)
-{
-	int k;
-
-	if (cmd->cmnd == NULL)
-		return;
-
-	scmd_printk(KERN_INFO, cmd, "CDB: ");
-	print_opcode_name(cmd->cmnd, cmd->cmd_len);
-
-	/* print out all bytes in cdb */
-	printk(":");
-	for (k = 0; k < cmd->cmd_len; ++k)
-		printk(" %02x", cmd->cmnd[k]);
-	printk("\n");
-}
-EXPORT_SYMBOL(scsi_print_command);
-
 #ifdef CONFIG_SCSI_CONSTANTS
 
 struct error_info {
diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
index dca45fe..d166d12 100644
--- a/drivers/scsi/scsi_logging.c
+++ b/drivers/scsi/scsi_logging.c
@@ -13,10 +13,10 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
+#include <scsi/scsi_eh.h>
 #include <scsi/scsi_dbg.h>
 
 #define SCSI_LOG_SPOOLSIZE 4096
-#define SCSI_LOG_BUFSIZE 128
 
 struct scsi_log_buf {
 	char buffer[SCSI_LOG_SPOOLSIZE];
@@ -64,6 +64,21 @@ static void scsi_log_release_buffer(char *bufptr)
 	preempt_enable();
 }
 
+static size_t scmd_format_header(char *logbuf, size_t logbuf_len,
+				 struct gendisk *disk, int tag)
+{
+	size_t off = 0;
+
+	if (disk)
+		off += scnprintf(logbuf + off, logbuf_len - off,
+				 "[%s] ", disk->disk_name);
+
+	if (tag >= 0)
+		off += scnprintf(logbuf + off, logbuf_len - off,
+				 "tag#%d ", tag);
+	return off;
+}
+
 int sdev_prefix_printk(const char *level, const struct scsi_device *sdev,
 		       const char *name, const char *fmt, ...)
 {
@@ -106,13 +121,8 @@ int scmd_printk(const char *level, const struct scsi_cmnd *scmd,
 	logbuf = scsi_log_reserve_buffer(&logbuf_len);
 	if (!logbuf)
 		return 0;
-	if (disk)
-		off += scnprintf(logbuf + off, logbuf_len - off,
-				 "[%s] ", disk->disk_name);
-
-	if (scmd->request->tag >= 0)
-		off += scnprintf(logbuf + off, logbuf_len - off,
-				 "tag#%d ", scmd->request->tag);
+	off = scmd_format_header(logbuf, logbuf_len, disk,
+				 scmd->request->tag);
 	va_start(args, fmt);
 	off += vscnprintf(logbuf + off, logbuf_len - off, fmt, args);
 	va_end(args);
@@ -121,3 +131,121 @@ int scmd_printk(const char *level, const struct scsi_cmnd *scmd,
 	return ret;
 }
 EXPORT_SYMBOL_GPL(scmd_printk);
+
+static size_t scsi_format_opcode_name(char *buffer, size_t buf_len,
+				      const unsigned char *cdbp)
+{
+	int sa, cdb0;
+	const char *cdb_name = NULL, *sa_name = NULL;
+	size_t off;
+
+	cdb0 = cdbp[0];
+	if (cdb0 == VARIABLE_LENGTH_CMD) {
+		int len = scsi_varlen_cdb_length(cdbp);
+
+		if (len < 10) {
+			off = scnprintf(buffer, buf_len,
+					"short variable length command, len=%d",
+					len);
+			return off;
+		}
+		sa = (cdbp[8] << 8) + cdbp[9];
+	} else
+		sa = cdbp[1] & 0x1f;
+
+	if (!scsi_opcode_sa_name(cdb0, sa, &cdb_name, &sa_name)) {
+		if (cdb_name)
+			off = scnprintf(buffer, buf_len, "%s", cdb_name);
+		else {
+			off = scnprintf(buffer, buf_len, "cdb[0]=0x%x", cdb0);
+			if (cdb0 > VENDOR_SPECIFIC_CDB)
+				off += scnprintf(buffer + off, buf_len - off,
+						 " (vendor)");
+			else if (cdb0 > 0x60 && cdb0 < 0x7e)
+				off += scnprintf(buffer + off, buf_len - off,
+						 " (reserved)");
+		}
+	} else {
+		if (sa_name)
+			off = scnprintf(buffer, buf_len, "%s", sa_name);
+		else if (cdb_name)
+			off = scnprintf(buffer, buf_len, "%s, sa=0x%x",
+					cdb_name, sa);
+		else
+			off = scnprintf(buffer, buf_len,
+					"cdb[0]=0x%x, sa=0x%x", cdb0, sa);
+	}
+	return off;
+}
+
+size_t __scsi_format_command(char *logbuf, size_t logbuf_len,
+			     const unsigned char *cdb, size_t cdb_len)
+{
+	int len, k;
+	size_t off;
+
+	off = scsi_format_opcode_name(logbuf, logbuf_len, cdb);
+	len = scsi_command_size(cdb);
+	if (cdb_len < len)
+		len = cdb_len;
+	/* print out all bytes in cdb */
+	for (k = 0; k < len; ++k) {
+		if (off + 3 > logbuf_len)
+			break;
+		off += scnprintf(logbuf + off, logbuf_len - off,
+				 " %02x", cdb[k]);
+	}
+	return off;
+}
+EXPORT_SYMBOL(__scsi_format_command);
+
+void scsi_print_command(struct scsi_cmnd *cmd)
+{
+	struct gendisk *disk = cmd->request->rq_disk;
+	int k;
+	char *logbuf;
+	size_t off, logbuf_len;
+
+	if (cmd->cmnd == NULL)
+		return;
+
+	logbuf = scsi_log_reserve_buffer(&logbuf_len);
+	if (!logbuf)
+		return;
+
+	off = scmd_format_header(logbuf, logbuf_len, disk, cmd->request->tag);
+	off += scnprintf(logbuf + off, logbuf_len - off, "CDB: ");
+	off += scsi_format_opcode_name(logbuf + off, logbuf_len - off,
+				       cmd->cmnd);
+	/* print out all bytes in cdb */
+	if (cmd->cmd_len > 16) {
+		/* Print opcode in one line and use separate lines for CDB */
+		off += scnprintf(logbuf + off, logbuf_len - off, "\n");
+		dev_printk(KERN_INFO, &cmd->device->sdev_gendev, logbuf);
+		scsi_log_release_buffer(logbuf);
+		for (k = 0; k < cmd->cmd_len; k += 16) {
+			size_t linelen = min(cmd->cmd_len - k, 16);
+
+			logbuf = scsi_log_reserve_buffer(&logbuf_len);
+			if (!logbuf)
+				break;
+			off = scmd_format_header(logbuf, logbuf_len, disk,
+						 cmd->request->tag);
+			off += scnprintf(logbuf + off, logbuf_len - off,
+					 "CDB[%02x]: ", k);
+			hex_dump_to_buffer(&cmd->cmnd[k], linelen, 16, 1,
+					   logbuf + off, logbuf_len - off,
+					   false);
+			dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
+				   logbuf);
+			scsi_log_release_buffer(logbuf);
+		}
+	} else {
+		off += scnprintf(logbuf + off, logbuf_len - off, " ");
+		hex_dump_to_buffer(cmd->cmnd, cmd->cmd_len, 16, 1,
+				   logbuf + off, logbuf_len - off, false);
+		dev_printk(KERN_INFO, &cmd->device->sdev_gendev, logbuf);
+		scsi_log_release_buffer(logbuf);
+	}
+}
+EXPORT_SYMBOL(scsi_print_command);
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index fb929fa..4f9fb3c 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -188,6 +188,7 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 	struct scsi_sense_hdr sshdr;
 	int result, err = 0, retries = 0;
 	struct request_sense *sense = cgc->sense;
+	char logbuf[SCSI_LOG_BUFSIZE];
 
 	SDev = cd->device;
 
@@ -257,14 +258,20 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 				/* sense: Invalid command operation code */
 				err = -EDRIVE_CANT_DO_THIS;
 #ifdef DEBUG
-			__scsi_print_command(cgc->cmd, CDROM_PACKET_SIZE);
+			__scsi_format_command(logbuf, SCSI_LOG_BUFSIZE,
+					      cgc->cmd, CDROM_PACKET_SIZE);
+			sr_printk(KERN_INFO, cd,
+				  "CDROM (ioctl) invalid command: %s\n",
+				  logbuf);
 			scsi_print_sense_hdr(cd->device, cd->cdi.name, &sshdr);
 #endif
 			break;
 		default:
+			__scsi_format_command(logbuf, SCSI_LOG_BUFSIZE,
+					      cgc->cmd, CDROM_PACKET_SIZE);
 			sr_printk(KERN_ERR, cd,
-				  "CDROM (ioctl) error, command: ");
-			__scsi_print_command(cgc->cmd, CDROM_PACKET_SIZE);
+				  "CDROM (ioctl) error, command: %s\n",
+				  logbuf);
 			scsi_print_sense_hdr(cd->device, cd->cdi.name, &sshdr);
 			err = -EIO;
 		}
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index d17178e..afd2a1b 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -191,6 +191,9 @@ enum scsi_timeouts {
 #define	ATA_16		      0x85	/* 16-byte pass-thru */
 #define	ATA_12		      0xa1	/* 12-byte pass-thru */
 
+/* Vendor specific CDBs start here */
+#define VENDOR_SPECIFIC_CDB 0xc0
+
 /*
  *	SCSI command lengths
  */
diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
index 7982795..c7ed7b8 100644
--- a/include/scsi/scsi_dbg.h
+++ b/include/scsi/scsi_dbg.h
@@ -5,8 +5,12 @@ struct scsi_cmnd;
 struct scsi_device;
 struct scsi_sense_hdr;
 
+#define SCSI_LOG_BUFSIZE 128
+
+extern bool scsi_opcode_sa_name(int, int, const char **, const char **);
 extern void scsi_print_command(struct scsi_cmnd *);
-extern void __scsi_print_command(const unsigned char *, size_t);
+extern size_t __scsi_format_command(char *, size_t,
+				   const unsigned char *, size_t);
 extern void scsi_show_extd_sense(const struct scsi_device *, const char *,
 				 unsigned char, unsigned char);
 extern void scsi_show_sense_hdr(const struct scsi_device *, const char *,
-- 
1.8.5.2

