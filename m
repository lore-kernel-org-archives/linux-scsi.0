From: Andi Kleen <ak@suse.de>
Subject: [PATCH] Only print SCSI data direction warning once for a command
Date: Wed, 2 Jan 2008 07:03:01 +0100
Message-ID: <200801020703.01180.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45602 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773AbYABGDF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Jan 2008 01:03:05 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org


When I use cdparanoia my logs get spammed a lot by

printk: 464 messages suppressed.
sg_write: data in/out 30576/30576 bytes for SCSI command 0xbe--guessing data in;
   program cdparanoia not setting count and/or reply_len properly
printk: 1078 messages suppressed.

and many more of those. With this patch the message is only printed once
for a command in a row.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 drivers/scsi/sg.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux/drivers/scsi/sg.c
===================================================================
--- linux.orig/drivers/scsi/sg.c
+++ linux/drivers/scsi/sg.c
@@ -602,8 +602,9 @@ sg_write(struct file *filp, const char _
 	 * but is is possible that the app intended SG_DXFER_TO_DEV, because there
 	 * is a non-zero input_size, so emit a warning.
 	 */
-	if (hp->dxfer_direction == SG_DXFER_TO_FROM_DEV)
-		if (printk_ratelimit())
+	if (hp->dxfer_direction == SG_DXFER_TO_FROM_DEV) {
+		static char cmd[TASK_COMM_LEN];
+		if (printk_ratelimit() && strcmp(current->comm, cmd)) {
 			printk(KERN_WARNING
 			       "sg_write: data in/out %d/%d bytes for SCSI command 0x%x--"
 			       "guessing data in;\n" KERN_WARNING "   "
@@ -611,6 +612,9 @@ sg_write(struct file *filp, const char _
 			       old_hdr.reply_len - (int)SZ_SG_HEADER,
 			       input_size, (unsigned int) cmnd[0],
 			       current->comm);
+			strcpy(cmd, current->comm);
+		}
+	}
 	k = sg_common_write(sfp, srp, cmnd, sfp->timeout, blocking);
 	return (k < 0) ? k : count;
 }
