From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/10] scsi: open-code scsi_decode_sense_buffer()
Date: Fri, 12 Oct 2012 10:33:48 +0200
Message-ID: <1350030830-25614-9-git-send-email-hare@suse.de>
References: <1350030830-25614-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34577 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933510Ab2JLIeA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Oct 2012 04:34:00 -0400
In-Reply-To: <1350030830-25614-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Kay Sievers <kay@vrfy.org>

Pointless, and actually wrong as there is no point in trying
to decode invalid sense data.

Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c |   43 +++++++++++++++++--------------------------
 1 files changed, 17 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index ded16d9..8bf2616 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1373,29 +1373,6 @@ scsi_cmd_print_sense_hdr(struct scsi_cmnd *scmd, const char *desc,
 EXPORT_SYMBOL(scsi_cmd_print_sense_hdr);
 
 static void
-scsi_decode_sense_buffer(const unsigned char *sense_buffer, int sense_len,
-		       struct scsi_sense_hdr *sshdr)
-{
-	int k, num, res;
-    
-	res = scsi_normalize_sense(sense_buffer, sense_len, sshdr);
-	if (0 == res) {
-		/* this may be SCSI-1 sense data */
-		num = (sense_len < 32) ? sense_len : 32;
-		printk("Unrecognized sense data (in hex):");
-		for (k = 0; k < num; ++k) {
-			if (0 == (k % 16)) {
-				printk("\n");
-				printk(KERN_INFO "        ");
-			}
-			printk("%02x ", sense_buffer[k]);
-		}
-		printk("\n");
-		return;
-	}
-}
-
-static void
 scsi_decode_sense_extras(const unsigned char *sense_buffer, int sense_len,
 			 struct scsi_sense_hdr *sshdr)
 {
@@ -1462,8 +1439,15 @@ void __scsi_print_sense(const char *name, const unsigned char *sense_buffer,
 {
 	struct scsi_sense_hdr sshdr;
 
+	if (!scsi_normalize_sense(sense_buffer, sense_len, &sshdr)) {
+		/* this may be SCSI-1 sense data */
+		int num = (sense_len < 32) ? sense_len : 32;
+		pr_info("%s: Unrecognized sense data (in hex):", name);
+		print_hex_dump(KERN_INFO, "        ", DUMP_PREFIX_OFFSET,
+			       16, 1, sense_buffer, num, false);
+		return;
+	}
 	printk(KERN_INFO "%s: ", name);
-	scsi_decode_sense_buffer(sense_buffer, sense_len, &sshdr);
 	scsi_show_sense_hdr(&sshdr);
 	scsi_decode_sense_extras(sense_buffer, sense_len, &sshdr);
 	printk(KERN_INFO "%s: ", name);
@@ -1476,9 +1460,16 @@ void scsi_print_sense(char *name, struct scsi_cmnd *cmd)
 {
 	struct scsi_sense_hdr sshdr;
 
+	if (!scsi_normalize_sense(cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE,
+				  &sshdr)) {
+		scmd_printk(KERN_INFO, cmd,
+			    "Unrecognized sense data (in hex):");
+		print_hex_dump(KERN_INFO, "        ", DUMP_PREFIX_OFFSET,
+			       16, 1, cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE,
+			       false);
+		return;
+	}
 	scmd_printk(KERN_INFO, cmd, " ");
-	scsi_decode_sense_buffer(cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE,
-				 &sshdr);
 	scsi_show_sense_hdr(&sshdr);
 	scsi_decode_sense_extras(cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE,
 				 &sshdr);
-- 
1.7.4.2

