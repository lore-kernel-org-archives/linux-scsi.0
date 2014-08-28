From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 15/22] scsi: use dev_printk() variants in scsi_print_command()
Date: Thu, 28 Aug 2014 19:33:29 +0200
Message-ID: <1409247216-76074-16-git-send-email-hare@suse.de>
References: <1409247216-76074-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60194 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbaH1Rdl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2014 13:33:41 -0400
In-Reply-To: <1409247216-76074-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>, Hannes Reinecke <hare@suse.de>

We already have a local buffer, so we can use it to format
the cdb, too.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index c74cb85..771cd8e 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -412,18 +412,30 @@ EXPORT_SYMBOL(__scsi_print_command);
 void scsi_print_command(struct scsi_cmnd *cmd)
 {
 	char buf[80];
-	int k, off = 0;
+	int k, off = 0, linelen, remaining = cmd->cmd_len;
 
 	if (cmd->cmnd == NULL)
 		return;
 
 	off = print_opcode_name(cmd->cmnd, cmd->cmd_len, buf, 80);
-	scmd_printk(KERN_INFO, cmd, "CDB: %s:", buf);
+	if (cmd->cmd_len <= 16) {
+		strcat(buf, " CDB:");
+		off += 5;
 
-	/* print out all bytes in cdb */
-	for (k = 0; k < cmd->cmd_len; ++k)
-		printk(" %02x", cmd->cmnd[k]);
-	printk("\n");
+		hex_dump_to_buffer(cmd->cmnd, cmd->cmd_len, 16, 1,
+				   buf + off, sizeof(buf) - off, false);
+		scmd_printk(KERN_INFO, cmd, "%s\n", buf);
+	} else {
+		scmd_printk(KERN_INFO, cmd, "%s:\n", buf);
+		/* print out all bytes in cdb */
+		for (k = 0; k < cmd->cmd_len; k += 16) {
+			linelen = min(remaining, 16);
+			remaining -= 16;
+			hex_dump_to_buffer(cmd->cmnd + k, linelen, 16, 1,
+					   buf, sizeof(buf), false);
+			scmd_printk(KERN_INFO, cmd, "CDB: %s\n", buf);
+		}
+	}
 }
 EXPORT_SYMBOL(scsi_print_command);
 
-- 
1.8.5.2

