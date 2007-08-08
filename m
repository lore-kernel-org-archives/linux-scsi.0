From: Andi Kleen <ak@suse.de>
Subject: [PATCH] Quieten down sg warnings with cdparanoia
Date: Wed, 8 Aug 2007 17:12:31 +0200
Message-ID: <200708081712.31580.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:49203 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935529AbXHHPMf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Aug 2007 11:12:35 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, linux-scsi@vger.kernel.org

Quieten down sg warnings

When using cdparanoia on SUSE 10.2 I get thousands of warnings.
While I'm sure the warning is something important that I just miss quieten it 
down a bit to report only once for a program.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux-2.6.23-rc1-misc/drivers/scsi/sg.c
===================================================================
--- linux-2.6.23-rc1-misc.orig/drivers/scsi/sg.c
+++ linux-2.6.23-rc1-misc/drivers/scsi/sg.c
@@ -605,8 +605,9 @@ sg_write(struct file *filp, const char _
 	 * but is is possible that the app intended SG_DXFER_TO_DEV, because there
 	 * is a non-zero input_size, so emit a warning.
 	 */
-	if (hp->dxfer_direction == SG_DXFER_TO_FROM_DEV)
-		if (printk_ratelimit())
+	if (hp->dxfer_direction == SG_DXFER_TO_FROM_DEV) { 
+		static char comm[sizeof(((struct task_struct *)0)->comm)];
+		if (printk_ratelimit() && strcmp(current->comm, comm)) {
 			printk(KERN_WARNING
 			       "sg_write: data in/out %d/%d bytes for SCSI command 0x%x--"
 			       "guessing data in;\n" KERN_WARNING "   "
@@ -614,6 +615,9 @@ sg_write(struct file *filp, const char _
 			       old_hdr.reply_len - (int)SZ_SG_HEADER,
 			       input_size, (unsigned int) cmnd[0],
 			       current->comm);
+			strcpy(comm, current->comm);
+		}
+	}
 	k = sg_common_write(sfp, srp, cmnd, sfp->timeout, blocking);
 	return (k < 0) ? k : count;
 }
