From: Jens Axboe <axboe@suse.de>
Subject: [PATCH] aacraid bad queuecommand return
Date: Fri, 19 Nov 2004 09:59:29 +0100
Message-ID: <20041119085929.GC26240@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:37055 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261312AbUKSI75 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Nov 2004 03:59:57 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Hi,

aac_read() and aac_write() may complete a command but return -1, which
is propagated through aac_scsi_cmd() to the mid layer through
->queuecommand. If the command has been completed, it must return 0.

Signed-off-by: Jens Axboe <axboe@suse.de>


===== drivers/scsi/aacraid/aachba.c 1.29 vs edited =====
--- 1.29/drivers/scsi/aacraid/aachba.c	2004-10-01 17:10:08 +02:00
+++ edited/drivers/scsi/aacraid/aachba.c	2004-11-18 23:10:40 +01:00
@@ -894,7 +894,7 @@ int aac_read(struct scsi_cmnd * scsicmd,
 	aac_io_done(scsicmd);
 	fib_complete(cmd_fibcontext);
 	fib_free(cmd_fibcontext);
-	return -1;
+	return 0;
 }
 
 static int aac_write(struct scsi_cmnd * scsicmd, int cid)
@@ -928,7 +928,7 @@ static int aac_write(struct scsi_cmnd * 
 	if (!(cmd_fibcontext = fib_alloc(dev))) {
 		scsicmd->result = DID_ERROR << 16;
 		aac_io_done(scsicmd);
-		return -1;
+		return 0;
 	}
 	fib_init(cmd_fibcontext);
 
@@ -1004,7 +1004,7 @@ static int aac_write(struct scsi_cmnd * 
 
 	fib_complete(cmd_fibcontext);
 	fib_free(cmd_fibcontext);
-	return -1;
+	return 0;
 }
 
 
-- 
Jens Axboe

