From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 13/22] scsi: use local buffer for printing the opcode
Date: Thu, 28 Aug 2014 19:33:27 +0200
Message-ID: <1409247216-76074-14-git-send-email-hare@suse.de>
References: <1409247216-76074-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60193 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbaH1Rdl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2014 13:33:41 -0400
In-Reply-To: <1409247216-76074-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>, Hannes Reinecke <hare@suse.de>

SCSI opcode printing is tricky and needs to take into account
several different corner cases. So instead of trying to come
up with an elaborate printk() statement we should be printing
it into a local buffer.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c | 72 ++++++++++++++++++++++++++++++------------------
 1 file changed, 45 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 813c482..e9c099d 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -295,18 +295,20 @@ static int scsi_opcode_sa_name(int cmd, int service_action,
 }
 
 /* attempt to guess cdb length if cdb_len==0 . No trailing linefeed. */
-static void print_opcode_name(unsigned char * cdbp, int cdb_len)
+static int print_opcode_name(unsigned char * cdbp, int cdb_len,
+			     char *buf, int buf_len)
 {
-	int sa, len, cdb0;
-	const char * name;
+	int sa, len, cdb0, off;
+	const char * name = NULL;
 
 	cdb0 = cdbp[0];
 	if (cdb0 == VARIABLE_LENGTH_CMD) {
 		len = scsi_varlen_cdb_length(cdbp);
 		if (len < 10) {
-			printk("short variable length command, "
-			       "len=%d ext_len=%d", len, cdb_len);
-			return;
+			off = scnprintf(buf, buf_len,
+					"short variable length command, "
+					"len=%d ext_len=%d", len, cdb_len);
+			return off;
 		}
 		sa = (cdbp[8] << 8) + cdbp[9];
 	} else {
@@ -318,41 +320,51 @@ static void print_opcode_name(unsigned char * cdbp, int cdb_len)
 		if (cdb0 < 0xc0) {
 			name = cdb_byte0_names[cdb0];
 			if (name)
-				printk("%s", name);
+				off = scnprintf(buf, buf_len, "%s", name);
 			else
-				printk("cdb[0]=0x%x (reserved)", cdb0);
+				off = scnprintf(buf, buf_len,
+						"cdb[0]=0x%x (reserved)", cdb0);
 		} else
-			printk("cdb[0]=0x%x (vendor)", cdb0);
+			off = scnprintf(buf, buf_len,
+					"cdb[0]=0x%x (vendor)", cdb0);
 	} else {
 		if (name)
-			printk("%s", name);
+			off = scnprintf(buf, buf_len, "%s", name);
 		else
-			printk("cdb[0]=0x%x, sa=0x%x", cdb0, sa);
+			off = scnprintf(buf, buf_len,
+					"cdb[0]=0x%x, sa=0x%x", cdb0, sa);
 
 		if ((cdb_len > 0) && (len != cdb_len))
-			printk(", in_cdb_len=%d, ext_len=%d", len, cdb_len);
+			off += scnprintf(buf + off, buf_len - off,
+					 ", in_cdb_len=%d, ext_len=%d",
+					 len, cdb_len);
 	}
+	return off;
 }
 
 #else /* ifndef CONFIG_SCSI_CONSTANTS */
 
-static void print_opcode_name(unsigned char * cdbp, int cdb_len)
+static int print_opcode_name(unsigned char * cdbp, int cdb_len,
+			     char *buf, int buf_len)
 {
-	int sa, len, cdb0;
+	int sa, len, cdb0, off;
 
 	cdb0 = cdbp[0];
 	switch(cdb0) {
 	case VARIABLE_LENGTH_CMD:
 		len = scsi_varlen_cdb_length(cdbp);
 		if (len < 10) {
-			printk("short opcode=0x%x command, len=%d "
-			       "ext_len=%d", cdb0, len, cdb_len);
+			off = scnprintf(buf, buf_len,
+					"short opcode=0x%x command, len=%d "
+					"ext_len=%d", cdb0, len, cdb_len);
 			break;
 		}
 		sa = (cdbp[8] << 8) + cdbp[9];
-		printk("cdb[0]=0x%x, sa=0x%x", cdb0, sa);
+		off = scnprintf(buf, buf_len, "cdb[0]=0x%x, sa=0x%x", cdb0, sa);
 		if (len != cdb_len)
-			printk(", in_cdb_len=%d, ext_len=%d", len, cdb_len);
+			off += scnprintf(buf + off, buflen - off,
+					 ", in_cdb_len=%d, ext_len=%d",
+					 len, cdb_len);
 		break;
 	case MAINTENANCE_IN:
 	case MAINTENANCE_OUT:
@@ -366,23 +378,29 @@ static void print_opcode_name(unsigned char * cdbp, int cdb_len)
 	case THIRD_PARTY_COPY_IN:
 	case THIRD_PARTY_COPY_OUT:
 		sa = cdbp[1] & 0x1f;
-		printk("cdb[0]=0x%x, sa=0x%x", cdb0, sa);
+		off = scnprintf(buf + off, buflen - off,
+				"cdb[0]=0x%x, sa=0x%x", cdb0, sa);
 		break;
 	default:
 		if (cdb0 < 0xc0)
-			printk("cdb[0]=0x%x", cdb0);
+			off = scnprintf(buf + off, buf_len - off,
+					"cdb[0]=0x%x", cdb0);
 		else
-			printk("cdb[0]=0x%x (vendor)", cdb0);
+			off = scnprintf(buf + off, buf_len - off,
+					"cdb[0]=0x%x (vendor)", cdb0);
 		break;
 	}
+	return off;
 }
 #endif
 
 void __scsi_print_command(unsigned char *cdb)
 {
-	int k, len;
+	char buf[80];
+	int k, len, off = 0;
 
-	print_opcode_name(cdb, 0);
+	off = print_opcode_name(cdb, 0, buf, 80);
+	printk("%s", buf);
 	len = scsi_command_size(cdb);
 	/* print out all bytes in cdb */
 	for (k = 0; k < len; ++k)
@@ -393,16 +411,16 @@ EXPORT_SYMBOL(__scsi_print_command);
 
 void scsi_print_command(struct scsi_cmnd *cmd)
 {
-	int k;
+	char buf[80];
+	int k, off = 0;
 
 	if (cmd->cmnd == NULL)
 		return;
 
-	scmd_printk(KERN_INFO, cmd, "CDB: ");
-	print_opcode_name(cmd->cmnd, cmd->cmd_len);
+	off = print_opcode_name(cmd->cmnd, cmd->cmd_len, buf, 80);
+	scmd_printk(KERN_INFO, cmd, "CDB: %s:", buf);
 
 	/* print out all bytes in cdb */
-	printk(":");
 	for (k = 0; k < cmd->cmd_len; ++k)
 		printk(" %02x", cmd->cmnd[k]);
 	printk("\n");
-- 
1.8.5.2

