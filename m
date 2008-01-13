From: Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] Only print SCSI data direction warning once for a command
Date: Sun, 13 Jan 2008 17:41:43 +0100
Message-ID: <200801131741.43173.ak@suse.de>
References: <200801020703.01180.ak@suse.de> <1200166584.3656.36.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:39652 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbYAMQlr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Jan 2008 11:41:47 -0500
In-Reply-To: <1200166584.3656.36.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dougg@torque.net


> to the log because they come from printk_ratelimit().  So all you've
> done is halved the volume of flow to the logs and left a dangling printk
> suppressed message that keeps spewing, so I don't think the patch even
> does what you describe it as doing ...  if you reverse the order of the
> operands in the if() it will ...

Here's an updated patch with the reversed order.

-Andi

---

Only print SCSI data direction warning once for a command v2

When I use cdparanoia my logs get spammed a lot by

printk: 464 messages suppressed.
sg_write: data in/out 30576/30576 bytes for SCSI command 0xbe--guessing data in;
   program cdparanoia not setting count and/or reply_len properly
printk: 1078 messages suppressed.

and many more of those. With this patch the message is only printed once
for a command in a row.

v1->v2: Prevent rate limit messages too (pointed out by jejb)

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
+		if (strcmp(current->comm, cmd) && printk_ratelimit()) {
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
