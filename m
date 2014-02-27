From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: [PATCH RESEND] scsi: Output error messages using structured printk
 in single line
Date: Thu, 27 Feb 2014 13:17:38 +0900
Message-ID: <20140227041738.31316.14684.stgit@yunodevel>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail9.hitachi.co.jp ([133.145.228.44]:40206 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbaB0ERr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Feb 2014 23:17:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Prarit Bhargava <prarit@redhat.com>, linux-scsi@vger.kernel.org, Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org, Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, yrl.pp-manager.tt@hitachi.com, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Output error messages using structured printk in single line.
In SCSI drivers, some error messages which should be output in single line are
divided in multiple lines. When user tools handle the error messages, those
divided messages will create some inconveniences.

The reason why this problem is induced is structured printk for error messages.
Structured printk can add device information for printk, and it is used in
scmd_printk() and sd_printk(). The printk aims at output in atomic, so we
cannot use those functions for connecting multiple messages like KERN_CONT.
However, some error messages is implemented as follows:
   structured_printk("DEVICE INFORMATION:");
   printk(KERN_CONT, "DETAIL INFORMATION\n");
This implementation will be expected to output like "DEVICE INFORMATION: DETAIL
INFORMATION", but actually, this will be output as follows:
   DEVICE INFORMATION:
   DETAIL INFORMATION

For instance, in a following pseudo SCSI error test, the device information and
the detail information are divided:

-- Pseudo SCSI error test for current kernel
  # modprobe scsi_debug
  # cd /sys/bus/pseudo/drivers/scsi_debug
  # echo 2 > opts
  # dd if=/dev/sdb of=/dev/null 2> /dev/null

-- Result for current kernel
  # dmesg

[   17.842110] sd 2:0:0:0: [sdb] Attached SCSI disk
[   18.859098] sd 2:0:0:0: [sdb] Unhandled sense code
[   18.859103] sd 2:0:0:0: [sdb]
[   18.859106] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[   18.859108] sd 2:0:0:0: [sdb]
[   18.859110] Sense Key : Medium Error [current]
[   18.859114] Info fld=0x1234
[   18.859116] sd 2:0:0:0: [sdb]
[   18.859119] Add. Sense: Unrecovered read error
[   18.859122] sd 2:0:0:0: [sdb] CDB:
[   18.859124] Read(10): 28 00 00 00 11 e0 00 01 00 00

In a SCSI device driver, sd_print_result() is implemented as follows:
   sd_print_result()
   {
       sd_printk(KERN_INFO, sdkp, " ");
       scsi_show_result(result);
   }
Here, first sd_printk() outputs "sd 2:0:0:0: [sdb] ", then scsi_show_sense_hdr()
outputs "Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE". sd_printk() does not
include "\n", but it forcibly starts a new line. Therefore, when the driver
outputs error messages, those messages are divided.

This patch makes those multiple line messages output in single line as follows:

  # dmesg

[   17.145085]  sdb: unknown partition table
[   17.149096] sd 2:0:0:0: [sdb] Attached SCSI disk
[   18.166090] sd 2:0:0:0: [sdb] Unhandled sense code
[   18.166095] sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[   18.166099] sd 2:0:0:0: [sdb] Sense Key : Medium Error [current]
[   18.166104] Info fld=0x1234
[   18.166106] sd 2:0:0:0: [sdb] Add. Sense: Unrecovered read error
[   18.166111] sd 2:0:0:0: [sdb] CDB: Read(10): 28 00 00 00 11 e0 00 01 00 00

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: James E.J. Bottomley <JBottomley@parallels.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Kay Sievers <kay@vrfy.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/constants.c |  206 ++++++++++++++++++++++++++++------------------
 drivers/scsi/scsi.c      |   28 ++++--
 drivers/scsi/sd.c        |   19 +++-
 include/scsi/scsi_dbg.h  |   23 ++++-
 4 files changed, 176 insertions(+), 100 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index d35a5d6..cb93435 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -256,8 +256,26 @@ static const char * get_sa_name(const struct value_name_pair * arr,
 	return (k < arr_sz) ? arr->name : NULL;
 }
 
+/* Store a SCSI logging event to buf. */
+__printf(2, 3)
+void scsi_log_add(struct scsi_log_line *log, const char *fmt, ...)
+{
+	va_list args;
+	int len;
+
+	va_start(args, fmt);
+	len = vscnprintf(log->buf + log->offset,
+			 SCSI_LOG_LINE_MAX - log->offset, fmt, args);
+	WARN_ONCE(!len, "Cannot store the message '%s' in a local log buffer\n",
+		  fmt);
+	log->offset += len;
+	va_end(args);
+}
+EXPORT_SYMBOL(scsi_log_add);
+
 /* attempt to guess cdb length if cdb_len==0 . No trailing linefeed. */
-static void print_opcode_name(unsigned char * cdbp, int cdb_len)
+static void print_opcode_name(unsigned char *cdbp, int cdb_len,
+			      struct scsi_log_line *log)
 {
 	int sa, len, cdb0;
 	int fin_name = 0;
@@ -268,20 +286,22 @@ static void print_opcode_name(unsigned char * cdbp, int cdb_len)
 	case VARIABLE_LENGTH_CMD:
 		len = scsi_varlen_cdb_length(cdbp);
 		if (len < 10) {
-			printk("short variable length command, "
-			       "len=%d ext_len=%d", len, cdb_len);
+			scsi_log_add(log,
+			     "short variable length command, len=%d ext_len=%d",
+			     len, cdb_len);
 			break;
 		}
 		sa = (cdbp[8] << 8) + cdbp[9];
 		name = get_sa_name(variable_length_arr, VARIABLE_LENGTH_SZ,
 				   sa);
 		if (name)
-			printk("%s", name);
+			scsi_log_add(log, "%s", name);
 		else
-			printk("cdb[0]=0x%x, sa=0x%x", cdb0, sa);
+			scsi_log_add(log, "cdb[0]=0x%x, sa=0x%x", cdb0, sa);
 
 		if ((cdb_len > 0) && (len != cdb_len))
-			printk(", in_cdb_len=%d, ext_len=%d", len, cdb_len);
+			scsi_log_add(log, ", in_cdb_len=%d, ext_len=%d",
+				     len, cdb_len);
 
 		break;
 	case MAINTENANCE_IN:
@@ -343,24 +363,26 @@ static void print_opcode_name(unsigned char * cdbp, int cdb_len)
 		if (cdb0 < 0xc0) {
 			name = cdb_byte0_names[cdb0];
 			if (name)
-				printk("%s", name);
+				scsi_log_add(log, "%s", name);
 			else
-				printk("cdb[0]=0x%x (reserved)", cdb0);
+				scsi_log_add(log, "cdb[0]=0x%x (reserved)",
+					     cdb0);
 		} else
-			printk("cdb[0]=0x%x (vendor)", cdb0);
+			scsi_log_add(log, "cdb[0]=0x%x (vendor)", cdb0);
 		break;
 	}
 	if (fin_name) {
 		if (name)
-			printk("%s", name);
+			scsi_log_add(log, "%s", name);
 		else
-			printk("cdb[0]=0x%x, sa=0x%x", cdb0, sa);
+			scsi_log_add(log, "cdb[0]=0x%x, sa=0x%x", cdb0, sa);
 	}
 }
 
 #else /* ifndef CONFIG_SCSI_CONSTANTS */
 
-static void print_opcode_name(unsigned char * cdbp, int cdb_len)
+static void print_opcode_name(unsigned char *cdbp, int cdb_len,
+			      struct scsi_log_line *log)
 {
 	int sa, len, cdb0;
 
@@ -369,14 +391,16 @@ static void print_opcode_name(unsigned char * cdbp, int cdb_len)
 	case VARIABLE_LENGTH_CMD:
 		len = scsi_varlen_cdb_length(cdbp);
 		if (len < 10) {
-			printk("short opcode=0x%x command, len=%d "
-			       "ext_len=%d", cdb0, len, cdb_len);
+			scsi_log_add(log,
+				 "short opcode=0x%x command, len=%d ext_len=%d",
+				 cdb0, len, cdb_len);
 			break;
 		}
 		sa = (cdbp[8] << 8) + cdbp[9];
-		printk("cdb[0]=0x%x, sa=0x%x", cdb0, sa);
+		scsi_log_add(log, "cdb[0]=0x%x, sa=0x%x", cdb0, sa);
 		if (len != cdb_len)
-			printk(", in_cdb_len=%d, ext_len=%d", len, cdb_len);
+			scsi_log_add(log, ", in_cdb_len=%d, ext_len=%d",
+				     len, cdb_len);
 		break;
 	case MAINTENANCE_IN:
 	case MAINTENANCE_OUT:
@@ -390,46 +414,50 @@ static void print_opcode_name(unsigned char * cdbp, int cdb_len)
 	case THIRD_PARTY_COPY_IN:
 	case THIRD_PARTY_COPY_OUT:
 		sa = cdbp[1] & 0x1f;
-		printk("cdb[0]=0x%x, sa=0x%x", cdb0, sa);
+		scsi_log_add(log, "cdb[0]=0x%x, sa=0x%x", cdb0, sa);
 		break;
 	default:
 		if (cdb0 < 0xc0)
-			printk("cdb[0]=0x%x", cdb0);
+			scsi_log_add(log, "cdb[0]=0x%x", cdb0);
 		else
-			printk("cdb[0]=0x%x (vendor)", cdb0);
+			scsi_log_add(log, "cdb[0]=0x%x (vendor)", cdb0);
 		break;
 	}
+	return offset;
 }
 #endif
 
 void __scsi_print_command(unsigned char *cdb)
 {
+	struct scsi_log_line log;
 	int k, len;
 
-	print_opcode_name(cdb, 0);
+	scsi_log_line_init(&log);
+	print_opcode_name(cdb, 0, &log);
 	len = scsi_command_size(cdb);
 	/* print out all bytes in cdb */
 	for (k = 0; k < len; ++k)
-		printk(" %02x", cdb[k]);
-	printk("\n");
+		scsi_log_add(&log, " %02x", cdb[k]);
+	pr_info("%s\n", log.buf);
 }
 EXPORT_SYMBOL(__scsi_print_command);
 
 void scsi_print_command(struct scsi_cmnd *cmd)
 {
+	struct scsi_log_line log;
 	int k;
 
 	if (cmd->cmnd == NULL)
 		return;
 
-	scmd_printk(KERN_INFO, cmd, "CDB: ");
-	print_opcode_name(cmd->cmnd, cmd->cmd_len);
+	scsi_log_line_init(&log);
+	print_opcode_name(cmd->cmnd, cmd->cmd_len, &log);
 
 	/* print out all bytes in cdb */
-	printk(":");
+	scsi_log_add(&log, ":");
 	for (k = 0; k < cmd->cmd_len; ++k)
-		printk(" %02x", cmd->cmnd[k]);
-	printk("\n");
+		scsi_log_add(&log, " %02x", cmd->cmnd[k]);
+	scmd_printk(KERN_INFO, cmd, "CDB: %s\n", log.buf);
 }
 EXPORT_SYMBOL(scsi_print_command);
 
@@ -1368,50 +1396,50 @@ scsi_extd_sense_format(unsigned char asc, unsigned char ascq) {
 }
 EXPORT_SYMBOL(scsi_extd_sense_format);
 
-void
-scsi_show_extd_sense(unsigned char asc, unsigned char ascq)
+void scsi_show_extd_sense(unsigned char asc, unsigned char ascq,
+			  struct scsi_log_line *log)
 {
         const char *extd_sense_fmt = scsi_extd_sense_format(asc, ascq);
 
 	if (extd_sense_fmt) {
 		if (strstr(extd_sense_fmt, "%x")) {
-			printk("Add. Sense: ");
-			printk(extd_sense_fmt, ascq);
+			scsi_log_add(log, "Add. Sense: ");
+			scsi_log_add(log, extd_sense_fmt, ascq);
 		} else
-			printk("Add. Sense: %s", extd_sense_fmt);
+			scsi_log_add(log, "Add. Sense: %s", extd_sense_fmt);
 	} else {
 		if (asc >= 0x80)
-			printk("<<vendor>> ASC=0x%x ASCQ=0x%x", asc,
-			       ascq);
+			scsi_log_add(log, "<<vendor>> ASC=0x%x ASCQ=0x%x",
+				     asc, ascq);
 		if (ascq >= 0x80)
-			printk("ASC=0x%x <<vendor>> ASCQ=0x%x", asc,
-			       ascq);
+			scsi_log_add(log, "ASC=0x%x <<vendor>> ASCQ=0x%x",
+				     asc, ascq);
 		else
-			printk("ASC=0x%x ASCQ=0x%x", asc, ascq);
+			scsi_log_add(log, "ASC=0x%x ASCQ=0x%x", asc, ascq);
 	}
 
-	printk("\n");
+	scsi_log_add(log, "\n");
 }
 EXPORT_SYMBOL(scsi_show_extd_sense);
 
 void
-scsi_show_sense_hdr(struct scsi_sense_hdr *sshdr)
+scsi_show_sense_hdr(struct scsi_sense_hdr *sshdr, struct scsi_log_line *log)
 {
 	const char *sense_txt;
 
 	sense_txt = scsi_sense_key_string(sshdr->sense_key);
 	if (sense_txt)
-		printk("Sense Key : %s ", sense_txt);
+		scsi_log_add(log, "Sense Key : %s ", sense_txt);
 	else
-		printk("Sense Key : 0x%x ", sshdr->sense_key);
+		scsi_log_add(log, "Sense Key : 0x%x ", sshdr->sense_key);
 
-	printk("%s", scsi_sense_is_deferred(sshdr) ? "[deferred] " :
-	       "[current] ");
+	scsi_log_add(log, "%s", scsi_sense_is_deferred(sshdr) ?
+		     "[deferred] " : "[current] ");
 
 	if (sshdr->response_code >= 0x72)
-		printk("[descriptor]");
+		scsi_log_add(log, "[descriptor]");
 
-	printk("\n");
+	scsi_log_add(log, "\n");
 }
 EXPORT_SYMBOL(scsi_show_sense_hdr);
 
@@ -1421,10 +1449,15 @@ EXPORT_SYMBOL(scsi_show_sense_hdr);
 void
 scsi_print_sense_hdr(const char *name, struct scsi_sense_hdr *sshdr)
 {
-	printk(KERN_INFO "%s: ", name);
-	scsi_show_sense_hdr(sshdr);
-	printk(KERN_INFO "%s: ", name);
-	scsi_show_extd_sense(sshdr->asc, sshdr->ascq);
+	struct scsi_log_line log;
+
+	scsi_log_line_init(&log);
+	scsi_show_sense_hdr(sshdr, &log);
+	pr_info("%s: %s", name, log.buf);
+
+	scsi_log_line_init(&log);
+	scsi_show_extd_sense(sshdr->asc, sshdr->ascq, &log);
+	pr_info("%s: %s", name, log.buf);
 }
 EXPORT_SYMBOL(scsi_print_sense_hdr);
 
@@ -1435,16 +1468,22 @@ void
 scsi_cmd_print_sense_hdr(struct scsi_cmnd *scmd, const char *desc,
 			  struct scsi_sense_hdr *sshdr)
 {
-	scmd_printk(KERN_INFO, scmd, "%s: ", desc);
-	scsi_show_sense_hdr(sshdr);
-	scmd_printk(KERN_INFO, scmd, "%s: ", desc);
-	scsi_show_extd_sense(sshdr->asc, sshdr->ascq);
+	struct scsi_log_line log;
+
+	scsi_log_line_init(&log);
+	scsi_show_sense_hdr(sshdr, &log);
+	scmd_printk(KERN_INFO, scmd, "%s: %s", desc, log.buf);
+
+	scsi_log_line_init(&log);
+	scsi_show_extd_sense(sshdr->asc, sshdr->ascq, &log);
+	scmd_printk(KERN_INFO, scmd, "%s: %s", desc, log.buf);
 }
 EXPORT_SYMBOL(scsi_cmd_print_sense_hdr);
 
 static void
 scsi_decode_sense_buffer(const unsigned char *sense_buffer, int sense_len,
-		       struct scsi_sense_hdr *sshdr)
+			 struct scsi_sense_hdr *sshdr,
+			 struct scsi_log_line *log)
 {
 	int k, num, res;
 
@@ -1452,16 +1491,13 @@ scsi_decode_sense_buffer(const unsigned char *sense_buffer, int sense_len,
 	if (0 == res) {
 		/* this may be SCSI-1 sense data */
 		num = (sense_len < 32) ? sense_len : 32;
-		printk("Unrecognized sense data (in hex):");
+		scsi_log_add(log, "Unrecognized sense data (in hex):");
 		for (k = 0; k < num; ++k) {
-			if (0 == (k % 16)) {
-				printk("\n");
-				printk(KERN_INFO "        ");
-			}
-			printk("%02x ", sense_buffer[k]);
+			if (0 == (k % 16))
+				scsi_log_add(log, "\n        ");
+			scsi_log_add(log, "%02x ", sense_buffer[k]);
 		}
-		printk("\n");
-		return;
+		scsi_log_add(log, "\n");
 	}
 }
 
@@ -1531,13 +1567,17 @@ void __scsi_print_sense(const char *name, const unsigned char *sense_buffer,
 			int sense_len)
 {
 	struct scsi_sense_hdr sshdr;
+	struct scsi_log_line log;
 
-	printk(KERN_INFO "%s: ", name);
-	scsi_decode_sense_buffer(sense_buffer, sense_len, &sshdr);
-	scsi_show_sense_hdr(&sshdr);
+	scsi_log_line_init(&log);
+	scsi_decode_sense_buffer(sense_buffer, sense_len, &sshdr, &log);
+	scsi_show_sense_hdr(&sshdr, &log);
+	pr_info("%s: %s", name, log.buf);
 	scsi_decode_sense_extras(sense_buffer, sense_len, &sshdr);
-	printk(KERN_INFO "%s: ", name);
-	scsi_show_extd_sense(sshdr.asc, sshdr.ascq);
+
+	scsi_log_line_init(&log);
+	scsi_show_extd_sense(sshdr.asc, sshdr.ascq, &log);
+	pr_info("%s: %s", name, log.buf);
 }
 EXPORT_SYMBOL(__scsi_print_sense);
 
@@ -1545,15 +1585,19 @@ EXPORT_SYMBOL(__scsi_print_sense);
 void scsi_print_sense(char *name, struct scsi_cmnd *cmd)
 {
 	struct scsi_sense_hdr sshdr;
+	struct scsi_log_line log;
 
-	scmd_printk(KERN_INFO, cmd, " ");
+	scsi_log_line_init(&log);
 	scsi_decode_sense_buffer(cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE,
-				 &sshdr);
-	scsi_show_sense_hdr(&sshdr);
+				 &sshdr, &log);
+	scsi_show_sense_hdr(&sshdr, &log);
+	scmd_printk(KERN_INFO, cmd, "%s", log.buf);
 	scsi_decode_sense_extras(cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE,
 				 &sshdr);
-	scmd_printk(KERN_INFO, cmd, " ");
-	scsi_show_extd_sense(sshdr.asc, sshdr.ascq);
+
+	scsi_log_line_init(&log);
+	scsi_show_extd_sense(sshdr.asc, sshdr.ascq, &log);
+	scmd_printk(KERN_INFO, cmd, "%s", log.buf);
 }
 EXPORT_SYMBOL(scsi_print_sense);
 
@@ -1572,31 +1616,33 @@ static const char * const driverbyte_table[]={
 "DRIVER_INVALID", "DRIVER_TIMEOUT", "DRIVER_HARD", "DRIVER_SENSE"};
 #define NUM_DRIVERBYTE_STRS ARRAY_SIZE(driverbyte_table)
 
-void scsi_show_result(int result)
+void scsi_show_result(int result, struct scsi_log_line *log)
 {
 	int hb = host_byte(result);
 	int db = driver_byte(result);
 
-	printk("Result: hostbyte=%s driverbyte=%s\n",
+	scsi_log_add(log, "Result: hostbyte=%s driverbyte=%s\n",
 	       (hb < NUM_HOSTBYTE_STRS ? hostbyte_table[hb]     : "invalid"),
 	       (db < NUM_DRIVERBYTE_STRS ? driverbyte_table[db] : "invalid"));
 }
 
 #else
 
-void scsi_show_result(int result)
+void scsi_show_result(int result, struct scsi_log_line *log)
 {
-	printk("Result: hostbyte=0x%02x driverbyte=0x%02x\n",
-	       host_byte(result), driver_byte(result));
+	scsi_log_add(log, "Result: hostbyte=0x%02x driverbyte=0x%02x\n",
+		     host_byte(result), driver_byte(result));
 }
 
 #endif
 EXPORT_SYMBOL(scsi_show_result);
 
-
 void scsi_print_result(struct scsi_cmnd *cmd)
 {
-	scmd_printk(KERN_INFO, cmd, " ");
-	scsi_show_result(cmd->result);
+	struct scsi_log_line log;
+
+	scsi_log_line_init(&log);
+	scsi_show_result(cmd->result, &log);
+	scmd_printk(KERN_INFO, cmd, "%s", log.buf);
 }
 EXPORT_SYMBOL(scsi_print_result);
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index d8afec8..40b2b23 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -550,10 +550,13 @@ void scsi_log_send(struct scsi_cmnd *cmd)
 		level = SCSI_LOG_LEVEL(SCSI_LOG_MLQUEUE_SHIFT,
 				       SCSI_LOG_MLQUEUE_BITS);
 		if (level > 1) {
-			scmd_printk(KERN_INFO, cmd, "Send: ");
+			struct scsi_log_line log;
+
+			scsi_log_line_init(&log);
 			if (level > 2)
-				printk("0x%p ", cmd);
-			printk("\n");
+				scsi_log_add(&log, "0x%p ", cmd);
+			scsi_log_add(&log, "\n");
+			scmd_printk(KERN_INFO, cmd, "Send: %s", log.buf);
 			scsi_print_command(cmd);
 			if (level > 3) {
 				printk(KERN_INFO "buffer = 0x%p, bufflen = %d,"
@@ -587,35 +590,38 @@ void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
 				       SCSI_LOG_MLCOMPLETE_BITS);
 		if (((level > 0) && (cmd->result || disposition != SUCCESS)) ||
 		    (level > 1)) {
-			scmd_printk(KERN_INFO, cmd, "Done: ");
+			struct scsi_log_line log;
+
+			scsi_log_line_init(&log);
 			if (level > 2)
-				printk("0x%p ", cmd);
+				scsi_log_add(&log, "0x%p ", cmd);
 			/*
 			 * Dump truncated values, so we usually fit within
 			 * 80 chars.
 			 */
 			switch (disposition) {
 			case SUCCESS:
-				printk("SUCCESS\n");
+				scsi_log_add(&log, "SUCCESS\n");
 				break;
 			case NEEDS_RETRY:
-				printk("RETRY\n");
+				scsi_log_add(&log, "RETRY\n");
 				break;
 			case ADD_TO_MLQUEUE:
-				printk("MLQUEUE\n");
+				scsi_log_add(&log, "MLQUEUE\n");
 				break;
 			case FAILED:
-				printk("FAILED\n");
+				scsi_log_add(&log, "FAILED\n");
 				break;
 			case TIMEOUT_ERROR:
 				/* 
 				 * If called via scsi_times_out.
 				 */
-				printk("TIMEOUT\n");
+				scsi_log_add(&log, "TIMEOUT\n");
 				break;
 			default:
-				printk("UNKNOWN\n");
+				scsi_log_add(&log, "UNKNOWN\n");
 			}
+			scmd_printk(KERN_INFO, cmd, "Done: %s", log.buf);
 			scsi_print_result(cmd);
 			scsi_print_command(cmd);
 			if (status_byte(cmd->result) & CHECK_CONDITION)
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 470954a..64d79b2 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3275,15 +3275,22 @@ module_exit(exit_sd);
 static void sd_print_sense_hdr(struct scsi_disk *sdkp,
 			       struct scsi_sense_hdr *sshdr)
 {
-	sd_printk(KERN_INFO, sdkp, " ");
-	scsi_show_sense_hdr(sshdr);
-	sd_printk(KERN_INFO, sdkp, " ");
-	scsi_show_extd_sense(sshdr->asc, sshdr->ascq);
+	struct scsi_log_line log;
+
+	scsi_log_line_init(&log);
+	scsi_show_sense_hdr(sshdr, &log);
+	sd_printk(KERN_INFO, sdkp, "%s", log.buf);
+	scsi_log_line_init(&log);
+	scsi_show_extd_sense(sshdr->asc, sshdr->ascq, &log);
+	sd_printk(KERN_INFO, sdkp, "%s", log.buf);
 }
 
 static void sd_print_result(struct scsi_disk *sdkp, int result)
 {
-	sd_printk(KERN_INFO, sdkp, " ");
-	scsi_show_result(result);
+	struct scsi_log_line log;
+
+	scsi_log_line_init(&log);
+	scsi_show_result(result, &log);
+	sd_printk(KERN_INFO, sdkp, "%s", log.buf);
 }
 
diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
index e89844c..3d8f39c 100644
--- a/include/scsi/scsi_dbg.h
+++ b/include/scsi/scsi_dbg.h
@@ -1,13 +1,25 @@
 #ifndef _SCSI_SCSI_DBG_H
 #define _SCSI_SCSI_DBG_H
 
+/* Maximum size of a local buffer for structured printk */
+#define SCSI_LOG_LINE_MAX 512
+
+/* Local buffer for structured printk */
+struct scsi_log_line {
+	int offset;
+	char buf[SCSI_LOG_LINE_MAX];
+};
+
 struct scsi_cmnd;
 struct scsi_sense_hdr;
 
+extern void scsi_log_add(struct scsi_log_line *log, const char *fmt, ...);
 extern void scsi_print_command(struct scsi_cmnd *);
 extern void __scsi_print_command(unsigned char *);
-extern void scsi_show_extd_sense(unsigned char, unsigned char);
-extern void scsi_show_sense_hdr(struct scsi_sense_hdr *);
+extern void scsi_show_extd_sense(unsigned char, unsigned char,
+				 struct scsi_log_line *log);
+extern void scsi_show_sense_hdr(struct scsi_sense_hdr *,
+				struct scsi_log_line *log);
 extern void scsi_print_sense_hdr(const char *, struct scsi_sense_hdr *);
 extern void scsi_cmd_print_sense_hdr(struct scsi_cmnd *, const char *,
 				     struct scsi_sense_hdr *);
@@ -15,10 +27,15 @@ extern void scsi_print_sense(char *, struct scsi_cmnd *);
 extern void __scsi_print_sense(const char *name,
 			       const unsigned char *sense_buffer,
 			       int sense_len);
-extern void scsi_show_result(int);
+extern void scsi_show_result(int, struct scsi_log_line *log);
 extern void scsi_print_result(struct scsi_cmnd *);
 extern void scsi_print_status(unsigned char);
 extern const char *scsi_sense_key_string(unsigned char);
 extern const char *scsi_extd_sense_format(unsigned char, unsigned char);
 
+static inline void scsi_log_line_init(struct scsi_log_line *log)
+{
+	log->offset = 0;
+}
+
 #endif /* _SCSI_SCSI_DBG_H */

