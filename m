From: Jens Axboe <axboe@suse.de>
Subject: [PATCH] nsp32 bad queuecommand return
Date: Fri, 19 Nov 2004 09:57:22 +0100
Message-ID: <20041119085721.GB26240@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:39614 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261314AbUKSI5t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Nov 2004 03:57:49 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Hi,

The driver appropriately returns SCSI_MLQUEUE_HOST_BUSY, but it has
already completed the command. Just return 0 instead and let the mid
layer handle it through scsi_done().

Signed-off-by: Jens Axboe <axboe@suse.de>

===== drivers/scsi/nsp32.c 1.32 vs edited =====
--- 1.32/drivers/scsi/nsp32.c	2004-10-20 21:24:36 +02:00
+++ edited/drivers/scsi/nsp32.c	2004-11-19 09:10:05 +01:00
@@ -970,8 +970,7 @@ static int nsp32_queuecommand(struct scs
 		data->CurrentSC = NULL;
 		SCpnt->result   = DID_NO_CONNECT << 16;
 		done(SCpnt);
-
-		return SCSI_MLQUEUE_HOST_BUSY;
+		return 0;
 	}
 
 	/* check target ID is not same as this initiator ID */
@@ -979,7 +978,7 @@ static int nsp32_queuecommand(struct scs
 		nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND, "terget==host???");
 		SCpnt->result = DID_BAD_TARGET << 16;
 		done(SCpnt);
-		return SCSI_MLQUEUE_DEVICE_BUSY;
+		return 0;
 	}
 
 	/* check target LUN is allowable value */
@@ -987,7 +986,7 @@ static int nsp32_queuecommand(struct scs
 		nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND, "no more lun");
 		SCpnt->result = DID_BAD_TARGET << 16;
 		done(SCpnt);
-		return SCSI_MLQUEUE_DEVICE_BUSY;
+		return 0;
 	}
 
 	show_command(SCpnt);
@@ -1019,7 +1018,7 @@ static int nsp32_queuecommand(struct scs
 		nsp32_msg(KERN_ERR, "SGT fail");
 		SCpnt->result = DID_ERROR << 16;
 		nsp32_scsi_done(SCpnt);
-		return SCSI_MLQUEUE_HOST_BUSY;
+		return 0;
 	}
 
 	/* Build IDENTIFY */
@@ -1089,7 +1088,6 @@ static int nsp32_queuecommand(struct scs
 	if (ret != TRUE) {
 		nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND, "selection fail");
 		nsp32_scsi_done(SCpnt);
-		return SCSI_MLQUEUE_DEVICE_BUSY;
 	}
 
 	return 0;

 
-- 
Jens Axboe

