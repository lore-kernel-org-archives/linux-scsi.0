From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 05/10] scsi: use buffer for print_opcode_name()
Date: Fri, 12 Oct 2012 10:33:45 +0200
Message-ID: <1350030830-25614-6-git-send-email-hare@suse.de>
References: <1350030830-25614-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34565 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933575Ab2JLId5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Oct 2012 04:33:57 -0400
In-Reply-To: <1350030830-25614-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Kay Sievers <kay@vrfy.org>

Instead of printing directly to syslog print_opcode_name() should
be using a private buffer to avoid linebreaks during printout.

Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c |   98 +++++++++++++++++++++++++++------------------
 1 files changed, 59 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 76e4c03..b469798 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -204,9 +204,10 @@ static const char * get_sa_name(const struct value_name_pair * arr,
 }
 
 /* attempt to guess cdb length if cdb_len==0 . No trailing linefeed. */
-static void print_opcode_name(unsigned char * cdbp, int cdb_len)
+static int print_opcode_name(char *buf, int buf_len,
+			      unsigned char *cdbp, int cdb_len)
 {
-	int sa, len, cdb0;
+	int sa, len, cdb0, sz = 0;
 	const char * name;
 
 	cdb0 = cdbp[0];
@@ -214,101 +215,119 @@ static void print_opcode_name(unsigned char * cdbp, int cdb_len)
 	case VARIABLE_LENGTH_CMD:
 		len = scsi_varlen_cdb_length(cdbp);
 		if (len < 10) {
-			printk("short variable length command, "
-			       "len=%d ext_len=%d", len, cdb_len);
-			break;
+			sz = snprintf(buf, buf_len,
+				      "short variable length command, "
+				      "len=%d ext_len=%d", len, cdb_len);
+			return sz;
 		}
 		sa = (cdbp[8] << 8) + cdbp[9];
 		name = get_sa_name(variable_length_arr, VARIABLE_LENGTH_SZ, sa);
 		if (name)
-			printk("%s", name);
+			sz = snprintf(buf, buf_len, "%s", name);
 		else
-			printk("cdb[0]=0x%x, sa=0x%x", cdb0, sa);
+			sz = snprintf(buf, buf_len, "cdb[0]=0x%x, sa=0x%x",
+				      cdb0, sa);
 
 		if ((cdb_len > 0) && (len != cdb_len))
-			printk(", in_cdb_len=%d, ext_len=%d", len, cdb_len);
+			sz = snprintf(buf + sz, buf_len - sz,
+				      ", in_cdb_len=%d, ext_len=%d",
+				      len, cdb_len);
 
 		break;
 	case MAINTENANCE_IN:
 		sa = cdbp[1] & 0x1f;
 		name = get_sa_name(maint_in_arr, MAINT_IN_SZ, sa);
 		if (name)
-			printk("%s", name);
+			sz = snprintf(buf, buf_len, "%s", name);
 		else
-			printk("cdb[0]=0x%x, sa=0x%x", cdb0, sa);
+			sz = snprintf(buf, buf_len, "cdb[0]=0x%x, sa=0x%x",
+				      cdb0, sa);
 		break;
 	case MAINTENANCE_OUT:
 		sa = cdbp[1] & 0x1f;
 		name = get_sa_name(maint_out_arr, MAINT_OUT_SZ, sa);
 		if (name)
-			printk("%s", name);
+			sz = snprintf(buf, buf_len, "%s", name);
 		else
-			printk("cdb[0]=0x%x, sa=0x%x", cdb0, sa);
+			sz = snprintf(buf, buf_len, "cdb[0]=0x%x, sa=0x%x",
+				      cdb0, sa);
 		break;
 	case SERVICE_ACTION_IN_12:
 		sa = cdbp[1] & 0x1f;
 		name = get_sa_name(serv_in12_arr, SERV_IN12_SZ, sa);
 		if (name)
-			printk("%s", name);
+			sz = snprintf(buf, buf_len, "%s", name);
 		else
-			printk("cdb[0]=0x%x, sa=0x%x", cdb0, sa);
+			sz = snprintf(buf, buf_len, "cdb[0]=0x%x, sa=0x%x",
+				      cdb0, sa);
 		break;
 	case SERVICE_ACTION_OUT_12:
 		sa = cdbp[1] & 0x1f;
 		name = get_sa_name(serv_out12_arr, SERV_OUT12_SZ, sa);
 		if (name)
-			printk("%s", name);
+			sz = snprintf(buf, buf_len, "%s", name);
 		else
-			printk("cdb[0]=0x%x, sa=0x%x", cdb0, sa);
+			sz = snprintf(buf, buf_len, "cdb[0]=0x%x, sa=0x%x",
+				      cdb0, sa);
 		break;
 	case SERVICE_ACTION_IN_16:
 		sa = cdbp[1] & 0x1f;
 		name = get_sa_name(serv_in16_arr, SERV_IN16_SZ, sa);
 		if (name)
-			printk("%s", name);
+			sz = snprintf(buf, buf_len, "%s", name);
 		else
-			printk("cdb[0]=0x%x, sa=0x%x", cdb0, sa);
+			sz = snprintf(buf, buf_len, "cdb[0]=0x%x, sa=0x%x",
+				      cdb0, sa);
 		break;
 	case SERVICE_ACTION_OUT_16:
 		sa = cdbp[1] & 0x1f;
 		name = get_sa_name(serv_out16_arr, SERV_OUT16_SZ, sa);
 		if (name)
-			printk("%s", name);
+			sz = snprintf(buf, buf_len, "%s", name);
 		else
-			printk("cdb[0]=0x%x, sa=0x%x", cdb0, sa);
+			sz = snprintf(buf, buf_len, "cdb[0]=0x%x, sa=0x%x",
+				      cdb0, sa);
 		break;
 	default:
 		if (cdb0 < 0xc0) {
 			name = cdb_byte0_names[cdb0];
 			if (name)
-				printk("%s", name);
+				sz = snprintf(buf, buf_len, "%s", name);
 			else
-				printk("cdb[0]=0x%x (reserved)", cdb0);
+				sz = snprintf(buf, buf_len,
+					      "cdb[0]=0x%x (reserved)", cdb0);
 		} else
-			printk("cdb[0]=0x%x (vendor)", cdb0);
+			sz = snprintf(buf, buf_len, "cdb[0]=0x%x (vendor)",
+				      cdb0);
 		break;
 	}
+	return sz;
 }
 
 #else /* ifndef CONFIG_SCSI_CONSTANTS */
 
-static void print_opcode_name(unsigned char * cdbp, int cdb_len)
+static int print_opcode_name(char *buf, int buf_len,
+			     unsigned char *cdbp, int cdb_len)
 {
-	int sa, len, cdb0;
+	int sa, len, cdb0, sz = 0;
 
 	cdb0 = cdbp[0];
+	sz = snprintf(buf, buf_len, "cdb[0]=0x%x", cdb0);
 	switch(cdb0) {
 	case VARIABLE_LENGTH_CMD:
 		len = scsi_varlen_cdb_length(cdbp);
 		if (len < 10) {
-			printk("short opcode=0x%x command, len=%d "
-			       "ext_len=%d", cdb0, len, cdb_len);
+			sz += snprintf(buf + sz, buf_size - sz,
+				       "short command, len=%d ext_len=%d",
+				       len, cdb_len);
 			break;
 		}
 		sa = (cdbp[8] << 8) + cdbp[9];
-		printk("cdb[0]=0x%x, sa=0x%x", cdb0, sa);
+		sz += snprintf(buf + sz, buf_len - sz, ", sa=0x%x", sa);
 		if (len != cdb_len)
-			printk(", in_cdb_len=%d, ext_len=%d", len, cdb_len);
+			sz += snprintf(buf + sz, buf_len - sz,
+				       ", in_cdb_len=%d, ext_len=%d",
+				       len, cdb_len);
 		break;
 	case MAINTENANCE_IN:
 	case MAINTENANCE_OUT:
@@ -317,23 +336,24 @@ static void print_opcode_name(unsigned char * cdbp, int cdb_len)
 	case SERVICE_ACTION_IN_16:
 	case SERVICE_ACTION_OUT_16:
 		sa = cdbp[1] & 0x1f;
-		printk("cdb[0]=0x%x, sa=0x%x", cdb0, sa);
+		sz += snprintf(buf + sz, buf_len - sz, ", sa=0x%x", sa);
 		break;
 	default:
-		if (cdb0 < 0xc0)
-			printk("cdb[0]=0x%x", cdb0);
-		else
-			printk("cdb[0]=0x%x (vendor)", cdb0);
+		if (cdb0 >= 0xc0)
+			sz += snprintf(buf + sz, buf_len - sz, " (vendor)");
 		break;
 	}
+	return sz;
 }
-#endif  
+#endif
 
 void __scsi_print_command(unsigned char *cdb)
 {
 	int k, len;
+	char cdb_str[64];
 
-	print_opcode_name(cdb, 0);
+	print_opcode_name(cdb_str, 64, cdb, 0);
+	pr_info("%s", cdb_str);
 	len = scsi_command_size(cdb);
 	/* print out all bytes in cdb */
 	for (k = 0; k < len; ++k) 
@@ -345,15 +365,15 @@ EXPORT_SYMBOL(__scsi_print_command);
 void scsi_print_command(struct scsi_cmnd *cmd)
 {
 	int k;
+	char cdb_str[64];
 
 	if (cmd->cmnd == NULL)
 		return;
 
-	scmd_printk(KERN_INFO, cmd, "CDB: ");
-	print_opcode_name(cmd->cmnd, cmd->cmd_len);
+	print_opcode_name(cdb_str, 64, cmd->cmnd, cmd->cmd_len);
+	scmd_printk(KERN_INFO, cmd, "CDB: %s:", cdb_str);
 
 	/* print out all bytes in cdb */
-	printk(":");
 	for (k = 0; k < cmd->cmd_len; ++k)
 		printk(" %02x", cmd->cmnd[k]);
 	printk("\n");
-- 
1.7.4.2

