From: Jens Axboe <axboe@suse.de>
Subject: [PATCH] ide-scsi bad queuecommand return
Date: Fri, 19 Nov 2004 09:51:41 +0100
Message-ID: <20041119085141.GX26240@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:27324 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261308AbUKSIwJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Nov 2004 03:52:09 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Hi,

ide-scsi completes a command but returns ownership to the mid layer.

Signed-off-by: Jens Axboe <axboe@suse.de>

===== drivers/scsi/ide-scsi.c 1.47 vs edited =====
--- 1.47/drivers/scsi/ide-scsi.c	2004-10-22 01:46:25 +02:00
+++ edited/drivers/scsi/ide-scsi.c	2004-11-18 22:54:09 +01:00
@@ -891,7 +891,7 @@ abort:
 	if (rq) kfree (rq);
 	cmd->result = DID_ERROR << 16;
 	done(cmd);
-	return 1;
+	return 0;
 }
 
 static int idescsi_eh_abort (struct scsi_cmnd *cmd)

-- 
Jens Axboe

