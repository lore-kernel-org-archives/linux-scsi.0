From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 8/11] aacraid: Re-start helper thread if it dies
Date: Mon, 27 Mar 2006 09:44:26 -0800
Message-ID: <1143481466.21975.43.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:41919 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751120AbWC0Ro3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Mar 2006 12:44:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

Received from Mark Salyzyn

Since the helper thread for the driver can be killed unceremoniously by
an application, we detect the loss of the helper and restart it.

Signed-off-by: Mark Haverkamp <markh@osdl.org>
---
Applies to the scsi-misc-2.6 git tree.

--- scsi-misc-aac.orig/drivers/scsi/aacraid/commctrl.c	2006-03-22 12:44:52.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/commctrl.c	2006-03-22 12:47:35.000000000 -0800
@@ -38,6 +38,8 @@
 #include <linux/completion.h>
 #include <linux/dma-mapping.h>
 #include <linux/blkdev.h>
+#include <linux/delay.h>
+#include <linux/kthread.h>
 #include <asm/semaphore.h>
 #include <asm/uaccess.h>
 
@@ -293,6 +295,16 @@
 		status = 0;
 	} else {
 		spin_unlock_irqrestore(&dev->fib_lock, flags);
+		/* If someone killed the AIF aacraid thread, restart it */
+		status = !dev->aif_thread;
+		if (status && dev->queues && dev->fsa_dev) {
+			/* Be paranoid, be very paranoid! */
+			kthread_stop(dev->thread);
+			ssleep(1);
+			dev->aif_thread = 0;
+			dev->thread = kthread_run(aac_command_thread, dev, dev->name);
+			ssleep(1);
+		}
 		if (f.wait) {
 			if(down_interruptible(&fibctx->wait_sem) < 0) {
 				status = -EINTR;

-- 
Mark Haverkamp <markh@osdl.org>

