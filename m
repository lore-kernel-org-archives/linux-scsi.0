From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 2.6] aacraid reset handler update
Date: Tue, 16 Mar 2004 09:05:33 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1079456732.22289.14.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:12696 "EHLO fire-2.osdl.org")
	by vger.kernel.org with ESMTP id S263639AbUCPRFj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Mar 2004 12:05:39 -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>

This is an update from the Adaptec version of the driver to the aacraid
reset handler.  The current code has a logic error that is fixed by this
version.  This builds against 2.6.5-rc1.

Mark.

===== drivers/scsi/aacraid/linit.c 1.27 vs edited =====
--- 1.27/drivers/scsi/aacraid/linit.c	Fri Mar 12 03:19:14 2004
+++ edited/drivers/scsi/aacraid/linit.c	Tue Mar 16 08:57:16 2004
@@ -371,15 +371,22 @@
 	 * target (block maximum 60 seconds).
 	 */
 	for (count = 60; count; --count) {
+		int active = 0;
 		__shost_for_each_device(dev, host) {
 			spin_lock_irqsave(&dev->list_lock, flags);
 			list_for_each_entry(command, &dev->cmd_list, list) {
 				if (command->serial_number) {
-					spin_unlock_irqrestore(&dev->list_lock, flags);
-					return SUCCESS;
+					active++;
+					break;
 				}
 			}
 			spin_unlock_irqrestore(&dev->list_lock, flags);
+
+			/*
+			 * We can exit If all the commands are complete
+			 */
+			if (active == 0)
+				return SUCCESS;
 		}
 		spin_unlock_irq(host->host_lock);
 		scsi_sleep(HZ);




-- 
Mark Haverkamp <markh@osdl.org>

