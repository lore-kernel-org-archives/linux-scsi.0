From: Jens Axboe <axboe@suse.de>
Subject: [PATCH] kill locking around scsi_done()
Date: Mon, 22 Nov 2004 09:08:14 +0100
Message-ID: <20041122080813.GN26240@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:7606 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261983AbUKVIIl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Nov 2004 03:08:41 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Hi,

Lets show the mid layer as a good example and remove the host lock
around the scsi_done() call.

Signed-off-by: Jens Axboe <axboe@suse.de>

===== drivers/scsi/scsi.c 1.148 vs edited =====
--- 1.148/drivers/scsi/scsi.c	2004-10-05 17:47:12 +02:00
+++ edited/drivers/scsi/scsi.c	2004-11-20 23:25:38 +01:00
@@ -606,9 +606,7 @@
 				printk("queuecommand : command too long.\n"));
 		cmd->result = (DID_ABORT << 16);
 
-		spin_lock_irqsave(host->host_lock, flags);
 		scsi_done(cmd);
-		spin_unlock_irqrestore(host->host_lock, flags);
 		goto out;
 	}
 
-- 
Jens Axboe

