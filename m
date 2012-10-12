From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/10] scsi: use single printk call in scsi_print_command()
Date: Fri, 12 Oct 2012 10:33:46 +0200
Message-ID: <1350030830-25614-7-git-send-email-hare@suse.de>
References: <1350030830-25614-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34567 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933614Ab2JLId6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Oct 2012 04:33:58 -0400
In-Reply-To: <1350030830-25614-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Kay Sievers <kay@vrfy.org>

scsi_print_command is using several calls to printk(), causing
the output to be garbled. Modify it to use a single call to
printk().

Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c |   71 +++++++++++++++++++++++++++++++++++++++------
 1 files changed, 61 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index b469798..65367e8 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -349,34 +349,85 @@ static int print_opcode_name(char *buf, int buf_len,
 
 void __scsi_print_command(unsigned char *cdb)
 {
-	int k, len;
+	int k, len, rem, linelen;
 	char cdb_str[64];
+	char line[16 * 3 + 1];
 
 	print_opcode_name(cdb_str, 64, cdb, 0);
-	pr_info("%s", cdb_str);
 	len = scsi_command_size(cdb);
 	/* print out all bytes in cdb */
-	for (k = 0; k < len; ++k) 
-		printk(" %02x", cdb[k]);
-	printk("\n");
+	switch (len) {
+	case 6:
+		pr_info("%s %6ph\n", cdb_str, cdb);
+		break;
+	case 10:
+		pr_info("%s %10ph\n", cdb_str, cdb);
+		break;
+	case 12:
+		pr_info("%s %12ph\n", cdb_str, cdb);
+		break;
+	case 16:
+		pr_info("%s %16ph\n", cdb_str, cdb);
+		break;
+	default:
+		pr_info("%s\n", cdb_str);
+		rem = len;
+		for (k = 0; k < len; k += 16) {
+			linelen = min(rem, 16);
+			rem -= 16;
+
+			hex_dump_to_buffer(cdb + k, linelen, 16, 1,
+					   line, sizeof(line), false);
+			pr_info("%s\n", line);
+		}
+		break;
+	}
 }
 EXPORT_SYMBOL(__scsi_print_command);
 
 void scsi_print_command(struct scsi_cmnd *cmd)
 {
-	int k;
+	int k, rem, linelen;
 	char cdb_str[64];
+	char line[16 * 3 + 1];
 
 	if (cmd->cmnd == NULL)
 		return;
 
 	print_opcode_name(cdb_str, 64, cmd->cmnd, cmd->cmd_len);
-	scmd_printk(KERN_INFO, cmd, "CDB: %s:", cdb_str);
 
 	/* print out all bytes in cdb */
-	for (k = 0; k < cmd->cmd_len; ++k)
-		printk(" %02x", cmd->cmnd[k]);
-	printk("\n");
+	switch (cmd->cmd_len) {
+	case 6:
+		scmd_printk(KERN_INFO, cmd, "CDB: %s: %6ph\n",
+			    cdb_str, cmd->cmnd);
+		break;
+	case 10:
+		scmd_printk(KERN_INFO, cmd, "CDB: %s: %10ph\n",
+			    cdb_str, cmd->cmnd);
+		break;
+	case 12:
+		scmd_printk(KERN_INFO, cmd, "CDB: %s: %12ph\n",
+			    cdb_str, cmd->cmnd);
+		break;
+	case 16:
+		scmd_printk(KERN_INFO, cmd, "CDB: %s: %16ph\n",
+			    cdb_str, cmd->cmnd);
+		break;
+	default:
+		scmd_printk(KERN_INFO, cmd, "CDB: %s\n", cdb_str);
+		rem = cmd->cmd_len;
+		for (k = 0; k < cmd->cmd_len; k += 16) {
+			linelen = min(rem, 16);
+			rem -= 16;
+
+			hex_dump_to_buffer(cmd->cmnd + k, linelen, 16, 1,
+					   line, sizeof(line), false);
+			scmd_printk(KERN_INFO, cmd, "        %d: %s\n",
+				    k, line);
+		}
+		break;
+	}
 }
 EXPORT_SYMBOL(scsi_print_command);
 
-- 
1.7.4.2

