From: Jens Axboe <axboe@suse.de>
Subject: [PATCH] nsp_cs bad queuecommand return
Date: Fri, 19 Nov 2004 10:02:04 +0100
Message-ID: <20041119090204.GE26240@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:45504 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261319AbUKSJCd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Nov 2004 04:02:33 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Hi,

Return 0 from queuecommand, if the command has been completed already.

Signed-off-by: Jens Axboe <axboe@suse.de>

===== drivers/scsi/pcmcia/nsp_cs.c 1.35 vs edited =====
--- 1.35/drivers/scsi/pcmcia/nsp_cs.c	2004-10-05 22:11:16 +02:00
+++ edited/drivers/scsi/pcmcia/nsp_cs.c	2004-11-19 09:36:39 +01:00
@@ -226,7 +226,7 @@ static int nsp_queuecommand(Scsi_Cmnd *S
 		nsp_msg(KERN_DEBUG, "CurrentSC!=NULL this can't be happen");
 		SCpnt->result   = DID_BAD_TARGET << 16;
 		nsp_scsi_done(SCpnt);
-		return SCSI_MLQUEUE_HOST_BUSY;
+		return 0;
 	}
 
 #if 0
@@ -273,7 +273,7 @@ static int nsp_queuecommand(Scsi_Cmnd *S
 		nsp_dbg(NSP_DEBUG_QUEUECOMMAND, "selection fail");
 		SCpnt->result   = DID_BUS_BUSY << 16;
 		nsp_scsi_done(SCpnt);
-		return SCSI_MLQUEUE_DEVICE_BUSY;
+		return 0;
 	}
 
 
-- 
Jens Axboe

