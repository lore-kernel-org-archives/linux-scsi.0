From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 14/20] scsi: use local buffer for printing CDB
Date: Wed,  3 Sep 2014 12:06:09 +0200
Message-ID: <1409738775-80876-15-git-send-email-hare@suse.de>
References: <1409738775-80876-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59733 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932435AbaICKGb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Sep 2014 06:06:31 -0400
In-Reply-To: <1409738775-80876-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Yoshihiro Yunomae <yoshihiro.yunomae.ez@hitachi.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

The CDB needs to be printed in one line (ie with one printk
statement) to avoid the individual bytes to be broken up
under high load.
As using individual printk() statements here would lead to
unnecessary complicated code and needs the stack space to
hold the format string we should be using a local buffer
here. If the CDB is longer than the provided buffer
it will be printed in several lines.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/ch.c        |  5 +--
 drivers/scsi/constants.c | 82 ++++++++++++++++++++++++++++++++----------------
 drivers/scsi/sr_ioctl.c  |  9 ++++--
 include/scsi/scsi_dbg.h  |  2 +-
 4 files changed, 65 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index eea94a9..f0df02e 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -189,6 +189,7 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd,
 {
 	int errno, retries = 0, timeout, result;
 	struct scsi_sense_hdr sshdr;
+	char buf[80];
 
 	timeout = (cmd[0] == INITIALIZE_ELEMENT_STATUS)
 		? timeout_init : timeout_move;
@@ -196,8 +197,8 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd,
  retry:
 	errno = 0;
 	if (debug) {
-		DPRINTK("command: ");
-		__scsi_print_command(cmd);
+		__scsi_print_command(cmd, buf, 80);
+		DPRINTK("command: %s", buf);
 	}
 
 	result = scsi_execute_req(ch->device, cmd, direction, buffer,
diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 6076969..5486816 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -322,19 +322,20 @@ static bool scsi_opcode_sa_name(int cmd, int service_action,
 	return true;
 }
 
-/* attempt to guess cdb length if cdb_len==0 . No trailing linefeed. */
-static void print_opcode_name(unsigned char * cdbp, int cdb_len)
+/* attempt to guess cdb length if cdb_len==0 */
+static int print_opcode_name(unsigned char * cdbp, int cdb_len,
+			     char *buf, int buf_len)
 {
-	int sa, len, cdb0;
+	int sa, len, cdb0, off = 0;
 	const char *cdb_name = NULL, *sa_name = NULL;
 
 	cdb0 = cdbp[0];
 	if (cdb0 == VARIABLE_LENGTH_CMD) {
 		len = scsi_varlen_cdb_length(cdbp);
 		if (len < 10) {
-			printk("short variable length command, "
-			       "len=%d ext_len=%d", len, cdb_len);
-			return;
+			return scnprintf(buf, buf_len,
+					 "short variable length command, "
+					 "len=%d ext_len=%d", len, cdb_len);
 		}
 		sa = (cdbp[8] << 8) + cdbp[9];
 	} else {
@@ -344,54 +345,81 @@ static void print_opcode_name(unsigned char * cdbp, int cdb_len)
 
 	if (!scsi_opcode_sa_name(cdb0, sa, &cdb_name, &sa_name)) {
 		if (cdb_name)
-			printk("%s", cdb_name);
+			off = scnprintf(buf, buf_len, "%s", cdb_name);
 		else if (cdb0 > 0xc0)
-			printk("cdb[0]=0x%x (vendor)", cdb0);
+			off = scnprintf(buf, buf_len,
+					 "cdb[0]=0x%x (vendor)", cdb0);
 		else if (cdb0 > 0x60 && cdb0 < 0x7e)
-			printk("cdb[0]=0x%x (reserved)", cdb0);
+			off = scnprintf(buf, buf_len,
+					 "cdb[0]=0x%x (reserved)", cdb0);
 		else
-			printk("cdb[0]=0x%x", cdb0);
+			off = scnprintf(buf, buf_len, "cdb[0]=0x%x", cdb0);
 	} else {
 		if (sa_name)
-			printk("%s", sa_name);
+			off = scnprintf(buf, buf_len, "%s", sa_name);
 		else if (cdb_name)
-			printk("%s, sa=0x%x", cdb_name, sa);
+			off = scnprintf(buf, buf_len,
+					"%s, sa=0x%x", cdb_name, sa);
 		else
-			printk("cdb[0]=0x%x, sa=0x%x", cdb0, sa);
+			off = scnprintf(buf, buf_len,
+					"cdb[0]=0x%x, sa=0x%x", cdb0, sa);
 
 		if (cdb_len > 0 && len != cdb_len)
-			printk(", in_cdb_len=%d, ext_len=%d", len, cdb_len);
+			off += scnprintf(buf + off, buf_len - off,
+					 ", in_cdb_len=%d, ext_len=%d",
+					 len, cdb_len);
 	}
+	return off;
 }
 
-void __scsi_print_command(unsigned char *cdb)
+void __scsi_print_command(unsigned char *cdb, char *buf, int buf_len)
 {
-	int k, len;
+	int len, off;
 
-	print_opcode_name(cdb, 0);
+	off = print_opcode_name(cdb, 0, buf, buf_len);
 	len = scsi_command_size(cdb);
+	/* Variable length CDBs are not supported */
+	if (len > 16)
+		return;
 	/* print out all bytes in cdb */
-	for (k = 0; k < len; ++k)
-		printk(" %02x", cdb[k]);
-	printk("\n");
+	hex_dump_to_buffer(cdb, len, 16, 1,
+			   buf, buf_len - off, false);
 }
 EXPORT_SYMBOL(__scsi_print_command);
 
 void scsi_print_command(struct scsi_cmnd *cmd)
 {
-	int k;
+	int k, off = 0;
+	/* 16 bytes + space take up 48 bytes */
+	char buf[48];
+	int buf_len = 48, linelen;
 
 	if (cmd->cmnd == NULL)
 		return;
 
-	scmd_printk(KERN_INFO, cmd, "CDB: ");
-	print_opcode_name(cmd->cmnd, cmd->cmd_len);
+	off = print_opcode_name(cmd->cmnd, cmd->cmd_len, buf, buf_len);
 
 	/* print out all bytes in cdb */
-	printk(":");
-	for (k = 0; k < cmd->cmd_len; ++k)
-		printk(" %02x", cmd->cmnd[k]);
-	printk("\n");
+	if (buf_len - off > cmd->cmd_len * 3 + 2) {
+		/* If we have enough space print CDB in one line */
+		off += scnprintf(buf + off, buf_len - off, ": ");
+		hex_dump_to_buffer(cmd->cmnd, cmd->cmd_len, 16, 1,
+				   buf, buf_len - off, false);
+		scmd_printk(KERN_INFO, cmd, "CDB: %s\n", buf);
+	} else {
+		/*
+		 * Otherwise print opcode in one line and use
+		 * separate lines for the CDB
+		 */
+		scmd_printk(KERN_INFO, cmd, "CDB: %s\n", buf);
+		for (k = 0; k < cmd->cmd_len; k += 16) {
+			linelen = min(cmd->cmd_len - k, 16);
+			hex_dump_to_buffer(cmd->cmnd, linelen, 16, 1,
+					   buf, sizeof(buf), false);
+			scmd_printk(KERN_INFO, cmd, "CDB[%0x2]: %s\n",
+				    k / 16, buf);
+		}
+	}
 }
 EXPORT_SYMBOL(scsi_print_command);
 
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index 17e0c2b..8090571 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -188,6 +188,7 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 	struct scsi_sense_hdr sshdr;
 	int result, err = 0, retries = 0;
 	struct request_sense *sense = cgc->sense;
+	char buf[80];
 
 	SDev = cd->device;
 
@@ -257,14 +258,16 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 				/* sense: Invalid command operation code */
 				err = -EDRIVE_CANT_DO_THIS;
 #ifdef DEBUG
-			__scsi_print_command(cgc->cmd);
+			__scsi_print_command(cgc->cmd, buf, 80);
+			sr_printk(KERN_ERR, cd,
+				  "CDROM (ioctl) invalid command %s\n", buf);
 			scsi_print_sense_hdr(cd->device, cd->cdi.name, &sshdr);
 #endif
 			break;
 		default:
+		    __scsi_print_command(cgc->cmd, buf, 80);
 			sr_printk(KERN_ERR, cd,
-				  "CDROM (ioctl) error, command: ");
-			__scsi_print_command(cgc->cmd);
+				  "CDROM (ioctl) error, command: %s\n", buf);
 			scsi_print_sense_hdr(cd->device, cd->cdi.name, &sshdr);
 			err = -EIO;
 		}
diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
index 44bea15..5020e5e 100644
--- a/include/scsi/scsi_dbg.h
+++ b/include/scsi/scsi_dbg.h
@@ -6,7 +6,7 @@ struct scsi_device;
 struct scsi_sense_hdr;
 
 extern void scsi_print_command(struct scsi_cmnd *);
-extern void __scsi_print_command(unsigned char *);
+extern void __scsi_print_command(unsigned char *, char *, int);
 extern void scsi_show_extd_sense(struct scsi_device *, const char *,
 				 unsigned char, unsigned char);
 extern void scsi_show_sense_hdr(struct scsi_device *, const char *,
-- 
1.8.5.2

