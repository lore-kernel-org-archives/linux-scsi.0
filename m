From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 32/38] scsi: use external buffer for command logging
Date: Mon, 29 Sep 2014 13:59:01 +0200
Message-ID: <1411991947-130166-33-git-send-email-hare@suse.de>
References: <1411991947-130166-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59373 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753928AbaI2L7S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2014 07:59:18 -0400
In-Reply-To: <1411991947-130166-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>

Use an external buffer for __scsi_print_command() and
move command logging over to seq_buf. With that we can
guarantee to have the command always in one line,
and can even print out a variable length command
correctly across several lines.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/ch.c           |  6 ++-
 drivers/scsi/constants.c    | 72 +----------------------------------
 drivers/scsi/scsi_logging.c | 93 +++++++++++++++++++++++++++++++++++++++++++--
 drivers/scsi/sr_ioctl.c     | 13 +++++--
 include/scsi/scsi.h         |  3 ++
 include/scsi/scsi_dbg.h     |  5 ++-
 6 files changed, 113 insertions(+), 79 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 53621a3..67a81c0 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -195,8 +195,10 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd,
  retry:
 	errno = 0;
 	if (debug) {
-		DPRINTK("command: ");
-		__scsi_print_command(cmd);
+		char logbuf[SCSI_LOG_BUFSIZE];
+
+		__scsi_print_command(logbuf, SCSI_LOG_BUFSIZE, cmd);
+		DPRINTK("command: %s", logbuf);
 	}
 
 	result = scsi_execute_req(ch->device, cmd, direction, buffer,
diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 207ebef..f854b7e 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -29,8 +29,6 @@
 #define THIRD_PARTY_COPY_OUT 0x83
 #define THIRD_PARTY_COPY_IN 0x84
 
-#define VENDOR_SPECIFIC_CDB 0xc0
-
 struct sa_name_list {
 	int cmd;
 	const struct value_name_pair *arr;
@@ -286,8 +284,8 @@ static struct sa_name_list sa_names_arr[] = {
 };
 #endif /* CONFIG_SCSI_CONSTANTS */
 
-static bool scsi_opcode_sa_name(int cmd, int service_action,
-				const char **cdb_name, const char **sa_name)
+bool scsi_opcode_sa_name(int cmd, int service_action,
+			 const char **cdb_name, const char **sa_name)
 {
 	struct sa_name_list *sa_name_ptr = sa_names_arr;
 	const struct value_name_pair *arr = NULL;
@@ -320,72 +318,6 @@ static bool scsi_opcode_sa_name(int cmd, int service_action,
 	return true;
 }
 
-static void print_opcode_name(unsigned char *cdbp)
-{
-	int sa, cdb0;
-	const char *cdb_name = NULL, *sa_name = NULL;
-
-	cdb0 = cdbp[0];
-	if (cdb0 == VARIABLE_LENGTH_CMD) {
-		int len = scsi_varlen_cdb_length(cdbp);
-		if (len < 10) {
-			printk("short variable length command, len=%d", len);
-			return;
-		}
-		sa = (cdbp[8] << 8) + cdbp[9];
-	} else
-		sa = cdbp[1] & 0x1f;
-
-	if (!scsi_opcode_sa_name(cdb0, sa, &cdb_name, &sa_name)) {
-		if (cdb_name)
-			printk("%s", cdb_name);
-		else if (cdb0 > VENDOR_SPECIFIC_CDB)
-			printk("cdb[0]=0x%x (vendor)", cdb0);
-		else if (cdb0 > 0x60 && cdb0 < 0x7e)
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
-void __scsi_print_command(unsigned char *cdb)
-{
-	int k, len;
-
-	print_opcode_name(cdb);
-	len = scsi_command_size(cdb);
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
-	print_opcode_name(cmd->cmnd);
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
index e07367e..9bc0aa6 100644
--- a/drivers/scsi/scsi_logging.c
+++ b/drivers/scsi/scsi_logging.c
@@ -13,9 +13,11 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
+#include <scsi/scsi_eh.h>
 #include <scsi/scsi_dbg.h>
 
-#define SCSI_LOG_BUFSIZE 512
+#define scmd_format_header(b, s, d, t) \
+	sdev_format_header(b, s, (d) ? (d)->disk_name : NULL, t)
 
 static void sdev_format_header(struct seq_buf *s, struct scsi_device *sdev,
 			       const char *disk_name, int tag)
@@ -71,11 +73,96 @@ int scmd_printk(const char *level, struct scsi_cmnd *scmd,
 		return 0;
 
 	seq_buf_init(&s, logbuf, SCSI_LOG_BUFSIZE);
-	sdev_format_header(&s, scmd->device, disk ? disk->disk_name : NULL,
-			   scmd->request->tag);
+	scmd_format_header(&s, scmd->device, disk, scmd->request->tag);
 	va_start(args, fmt);
 	seq_buf_vprintf(&s, fmt, args);
 	va_end(args);
 	return sdev_seq_printk(level, scmd->device, &s);
 }
 EXPORT_SYMBOL_GPL(scmd_printk);
+
+static void scsi_format_opcode_name(struct seq_buf *s, unsigned char *cdbp)
+{
+	int sa, cdb0;
+	const char *cdb_name = NULL, *sa_name = NULL;
+
+	cdb0 = cdbp[0];
+	if (cdb0 == VARIABLE_LENGTH_CMD) {
+		int len = scsi_varlen_cdb_length(cdbp);
+
+		if (len < 10) {
+			seq_buf_printf(s, "short variable length command,"
+				       " len=%d", len);
+			return;
+		}
+		sa = (cdbp[8] << 8) + cdbp[9];
+	} else
+		sa = cdbp[1] & 0x1f;
+
+	if (!scsi_opcode_sa_name(cdb0, sa, &cdb_name, &sa_name)) {
+		if (cdb_name)
+			seq_buf_printf(s, "%s", cdb_name);
+		else if (cdb0 > VENDOR_SPECIFIC_CDB)
+			seq_buf_printf(s, "cdb[0]=0x%x (vendor)", cdb0);
+		else if (cdb0 > 0x60 && cdb0 < 0x7e)
+			seq_buf_printf(s, "cdb[0]=0x%x (reserved)", cdb0);
+		else
+			seq_buf_printf(s, "cdb[0]=0x%x", cdb0);
+	} else {
+		if (sa_name)
+			seq_buf_printf(s, "%s", sa_name);
+		else if (cdb_name)
+			seq_buf_printf(s, "%s, sa=0x%x", cdb_name, sa);
+		else
+			seq_buf_printf(s, "cdb[0]=0x%x, sa=0x%x", cdb0, sa);
+	}
+}
+
+size_t __scsi_print_command(char *logbuf, size_t logbuf_size,
+			    unsigned char *cdb)
+{
+	int len;
+	struct seq_buf s;
+
+	seq_buf_init(&s, logbuf, logbuf_size);
+	scsi_format_opcode_name(&s, cdb);
+	len = scsi_command_size(cdb);
+	/* print out all bytes in cdb */
+	seq_buf_putmem_hex(&s, cdb, len);
+	return s.len;
+}
+EXPORT_SYMBOL(__scsi_print_command);
+
+void scsi_print_command(struct scsi_cmnd *cmd)
+{
+	struct gendisk *disk = cmd->request->rq_disk;
+	int k;
+	char logbuf[SCSI_LOG_BUFSIZE];
+	struct seq_buf s;
+
+	if (cmd->cmnd == NULL)
+		return;
+
+	seq_buf_init(&s, logbuf, SCSI_LOG_BUFSIZE);
+	scmd_format_header(&s, cmd->device, disk, cmd->request->tag);
+	seq_buf_printf(&s, "CDB: ");
+	scsi_format_opcode_name(&s, cmd->cmnd);
+	/* print out all bytes in cdb */
+	if (cmd->cmd_len > 16) {
+		for (k = 0; k < cmd->cmd_len; ++k) {
+			if ((k % 16) == 0) {
+				sdev_seq_printk(KERN_INFO, cmd->device, &s);
+				scmd_format_header(&s, cmd->device, disk,
+						   cmd->request->tag);
+				seq_buf_printf(&s, "CDB[%u]: ", k / 16);
+			}
+			seq_buf_printf(&s, " %02x", cmd->cmnd[k]);
+		}
+	} else {
+		for (k = 0; k < cmd->cmd_len; ++k)
+			seq_buf_printf(&s, " %02x", cmd->cmnd[k]);
+	}
+
+	sdev_seq_printk(KERN_INFO, cmd->device, &s);
+}
+EXPORT_SYMBOL(scsi_print_command);
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index 17e0c2b..b68366b 100644
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
-			__scsi_print_command(cgc->cmd);
+			__scsi_print_command(logbuf, SCSI_LOG_BUFSIZE,
+					     cgc->cmd);
+			sr_printk(KERN_INFO, cd,
+				  "CDROM (ioctl) invalid command: %s\n",
+				  logbuf);
 			scsi_print_sense_hdr(cd->device, cd->cdi.name, &sshdr);
 #endif
 			break;
 		default:
+			__scsi_print_command(logbuf, SCSI_LOG_BUFSIZE,
+					     cgc->cmd);
 			sr_printk(KERN_ERR, cd,
-				  "CDROM (ioctl) error, command: ");
-			__scsi_print_command(cgc->cmd);
+				  "CDROM (ioctl) error, command: %s\n",
+				  logbuf);
 			scsi_print_sense_hdr(cd->device, cd->cdi.name, &sshdr);
 			err = -EIO;
 		}
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 261e708..4f80064 100644
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
index d624ed0..0281842 100644
--- a/include/scsi/scsi_dbg.h
+++ b/include/scsi/scsi_dbg.h
@@ -5,8 +5,11 @@ struct scsi_cmnd;
 struct scsi_device;
 struct scsi_sense_hdr;
 
+#define SCSI_LOG_BUFSIZE 512
+
+extern bool scsi_opcode_sa_name(int, int, const char **, const char **);
 extern void scsi_print_command(struct scsi_cmnd *);
-extern void __scsi_print_command(unsigned char *);
+extern size_t __scsi_print_command(char *, size_t, unsigned char *);
 extern void scsi_show_extd_sense(struct scsi_device *, const char *,
 				 unsigned char, unsigned char);
 extern void scsi_show_sense_hdr(struct scsi_device *, const char *,
-- 
1.8.5.2

