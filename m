From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 2.6] aacraid reset handler fix
Date: Mon, 10 May 2004 13:29:33 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1084220973.31146.26.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:7555 "EHLO fire-2.osdl.org")
	by vger.kernel.org with ESMTP id S261551AbUEJU3h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 May 2004 16:29:37 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>

This fixes a situation where the handler can exit too early.

Mark.

===== linit.c 1.28 vs edited =====
--- 1.28/drivers/scsi/aacraid/linit.c	Tue Mar 16 00:57:16 2004
+++ edited/linit.c	Mon May 10 11:42:31 2004
@@ -381,13 +381,15 @@
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

