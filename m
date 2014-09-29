From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 16/38] scsi: remove last argument from print_opcode_name()
Date: Mon, 29 Sep 2014 13:58:45 +0200
Message-ID: <1411991947-130166-17-git-send-email-hare@suse.de>
References: <1411991947-130166-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59327 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753644AbaI2L7O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2014 07:59:14 -0400
In-Reply-To: <1411991947-130166-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>

print_opcode_name() was only ever called with a '0' argument
from LLDDs and ULDs which were _not_ supporting variable length
CDBs, so the 'if' clause was never triggered.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 2110d61..713e1e0 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -320,25 +320,21 @@ static bool scsi_opcode_sa_name(int cmd, int service_action,
 	return true;
 }
 
-/* attempt to guess cdb length if cdb_len==0 . No trailing linefeed. */
-static void print_opcode_name(unsigned char * cdbp, int cdb_len)
+static void print_opcode_name(unsigned char *cdbp)
 {
-	int sa, len, cdb0;
+	int sa, cdb0;
 	const char *cdb_name = NULL, *sa_name = NULL;
 
 	cdb0 = cdbp[0];
 	if (cdb0 == VARIABLE_LENGTH_CMD) {
-		len = scsi_varlen_cdb_length(cdbp);
+		int len = scsi_varlen_cdb_length(cdbp);
 		if (len < 10) {
-			printk("short variable length command, "
-			       "len=%d ext_len=%d", len, cdb_len);
+			printk("short variable length command, len=%d", len);
 			return;
 		}
 		sa = (cdbp[8] << 8) + cdbp[9];
-	} else {
+	} else
 		sa = cdbp[1] & 0x1f;
-		len = cdb_len;
-	}
 
 	if (!scsi_opcode_sa_name(cdb0, sa, &cdb_name, &sa_name)) {
 		if (cdb_name)
@@ -356,9 +352,6 @@ static void print_opcode_name(unsigned char * cdbp, int cdb_len)
 			printk("%s, sa=0x%x", cdb_name, sa);
 		else
 			printk("cdb[0]=0x%x, sa=0x%x", cdb0, sa);
-
-		if (cdb_len > 0 && len != cdb_len)
-			printk(", in_cdb_len=%d, ext_len=%d", len, cdb_len);
 	}
 }
 
@@ -366,7 +359,7 @@ void __scsi_print_command(unsigned char *cdb)
 {
 	int k, len;
 
-	print_opcode_name(cdb, 0);
+	print_opcode_name(cdb);
 	len = scsi_command_size(cdb);
 	/* print out all bytes in cdb */
 	for (k = 0; k < len; ++k)
@@ -383,7 +376,7 @@ void scsi_print_command(struct scsi_cmnd *cmd)
 		return;
 
 	scmd_printk(KERN_INFO, cmd, "CDB: ");
-	print_opcode_name(cmd->cmnd, cmd->cmd_len);
+	print_opcode_name(cmd->cmnd);
 
 	/* print out all bytes in cdb */
 	printk(":");
-- 
1.8.5.2

