From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH] SCSI: throttle SG_DXFER_TO_FROM_DEV warning message better
Date: Sat, 18 Aug 2007 03:52:53 +0900
Message-ID: <20070817185253.GA8590@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.189]:42897 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813AbXHQSxA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Aug 2007 14:53:00 -0400
Received: by rv-out-0910.google.com with SMTP id k20so532162rvb
        for <linux-scsi@vger.kernel.org>; Fri, 17 Aug 2007 11:53:00 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

When a program continually issues SG_DXFER_TO_FROM_DEV commands,
throttling via printk_ratelimit() isn't enough.  If the drive is fast
and the console is slow (e.g. vesafb), it can slow down the process
quite a bit.

This patch makes sg remember last printed comm name and skip warning
message if the name matches.  This can protect most use cases.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 drivers/scsi/sg.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 85d3894..913408a 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -605,8 +605,10 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 	 * but is is possible that the app intended SG_DXFER_TO_DEV, because there
 	 * is a non-zero input_size, so emit a warning.
 	 */
-	if (hp->dxfer_direction == SG_DXFER_TO_FROM_DEV)
-		if (printk_ratelimit())
+	if (hp->dxfer_direction == SG_DXFER_TO_FROM_DEV) {
+		static char last_printed[TASK_COMM_LEN];
+
+		if (strcmp(last_printed, current->comm) && printk_ratelimit()) {
 			printk(KERN_WARNING
 			       "sg_write: data in/out %d/%d bytes for SCSI command 0x%x--"
 			       "guessing data in;\n" KERN_WARNING "   "
@@ -614,6 +616,10 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 			       old_hdr.reply_len - (int)SZ_SG_HEADER,
 			       input_size, (unsigned int) cmnd[0],
 			       current->comm);
+
+			memcpy(last_printed, current->comm, TASK_COMM_LEN);
+		}
+	}
 	k = sg_common_write(sfp, srp, cmnd, sfp->timeout, blocking);
 	return (k < 0) ? k : count;
 }
