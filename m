From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] aacraid reset handler
Date: Thu, 01 Jul 2004 09:26:17 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1088699175.22606.15.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:57053 "EHLO fire-2.osdl.org")
	by vger.kernel.org with ESMTP id S266031AbUGAQ0U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2004 12:26:20 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

This restores a fix to the aacraid reset handler.  It makes sure that
there are no active commands on any attached device before exiting with
SUCCESS.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

===== drivers/scsi/aacraid/linit.c 1.31 vs edited =====
--- 1.31/drivers/scsi/aacraid/linit.c	2004-06-18 13:19:24 -07:00
+++ edited/drivers/scsi/aacraid/linit.c	2004-06-29 11:22:58 -07:00
@@ -409,13 +409,15 @@
 				}
 			}
 			spin_unlock_irqrestore(&dev->list_lock, flags);
+			if (active)
+				break;
 
-			/*
-			 * We can exit If all the commands are complete
-			 */
-			if (active == 0)
-				return SUCCESS;
 		}
+		/*
+		 * We can exit If all the commands are complete
+		 */
+		if (active == 0)
+			return SUCCESS;
 		spin_unlock_irq(host->host_lock);
 		scsi_sleep(HZ);
 		spin_lock_irq(host->host_lock);

-- 
Mark Haverkamp <markh@osdl.org>

