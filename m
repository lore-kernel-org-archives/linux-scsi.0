From: "Ryan C. Underwood" <nemesis@icequake.net>
Subject: [PATCH 1/1] 3w-xxxx: pass through compat mode ioctls
Date: Thu, 24 Dec 2015 21:45:27 -0800
Message-ID: <1451022327-26943-1-git-send-email-nemesis@icequake.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 64-251-151-187.fidnet.com ([64.251.151.187]:39703 "EHLO
	mail.icequake.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbbLYFwC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Dec 2015 00:52:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adam Radford <linuxraid@lsi.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, "Ryan C. Underwood" <nemesis@icequake.net>

This allows 32-bit userspace tools (tw_cli, smartctl) to work on a 64-bit
system.  The command buffer is opaque to us, so, no word size problems.

Signed-off-by: Ryan C. Underwood <nemesis@icequake.net>
---
 drivers/scsi/3w-xxxx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 2940bd7..25aba16 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1045,6 +1045,9 @@ static int tw_chrdev_open(struct inode *inode, struct file *file)
 static const struct file_operations tw_fops = {
 	.owner		= THIS_MODULE,
 	.unlocked_ioctl	= tw_chrdev_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl   = tw_chrdev_ioctl,
+#endif
 	.open		= tw_chrdev_open,
 	.release	= NULL,
 	.llseek		= noop_llseek,
-- 
2.6.4

