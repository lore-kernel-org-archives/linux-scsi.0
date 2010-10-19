From: Oliver Neukum <oneukum@suse.de>
Subject: [PATCH] SCSI: sd_suspend: evaluate lower layers' returns
Date: Tue, 19 Oct 2010 13:10:00 +0200
Message-ID: <201010191310.00930.oneukum@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:44305 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933947Ab0JSLJ6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Oct 2010 07:09:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>, hare@suse.de, Alan Stern <stern@rowland.harvard.edu>, linux-scsi@vger.kernel.org

commit 867780e1bbc4c9deed13397fbd80119f431d557f
Author: Oliver Neukum <oliver@neukum.org>
Date:   Mon Oct 18 19:09:26 2010 +0200

    SCSI: sd_suspend: evaluate lower layers' returns
    
    sd_suspend() sends down commands that may fail.
    Depending on the reason of failure the failures
    can be ignored, the suspension retried or aborted.
    This patch evaluates the error returns from the lower
    layers to do so.
    
    Signed-off-by: Oliver Neukum <oneukum@suse.de>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ffa0689..fa695c4 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1081,11 +1081,32 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 		sd_print_result(sdkp, res);
 		if (driver_byte(res) & DRIVER_SENSE)
 			sd_print_sense_hdr(sdkp, &sshdr);
-	}
 
-	if (res)
-		return -EIO;
-	return 0;
+		/* we need to evaluate the error return  */
+		if ((scsi_sense_valid(&sshdr) &&
+			/* 0x3a is medium not present */
+			sshdr.asc == 0x3a))
+			/* this is no error here */
+			return 0;
+
+		switch (host_byte(res)) {
+		/* ignore errors due to racing a disconnection */
+		case DID_BAD_TARGET:
+		case DID_NO_CONNECT:	
+			return 0;
+		/* signal the upper layer it might try again */
+		case DID_BUS_BUSY:
+		case DID_ABORT:
+		case DID_RESET:
+		case DID_IMM_RETRY:
+		case DID_SOFT_ERROR:
+			return -EBUSY;
+		default:
+			return -EIO;
+		}
+	} else {
+		return 0;
+	}
 }
 
 static void sd_rescan(struct device *dev)
@@ -2474,9 +2495,13 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 		sd_print_result(sdkp, res);
 		if (driver_byte(res) & DRIVER_SENSE)
 			sd_print_sense_hdr(sdkp, &sshdr);
+		/* no medium -> nobody cares */
+		if (scsi_sense_valid(&sshdr) && sshdr.asc == 0x3a)
+			return 0;
 	}
 
-	return res;
+	/* error returns should conform what the pm core expects */
+	return res ? -EIO : 0;
 }
 
 /*
@@ -2522,6 +2547,9 @@ static int sd_suspend(struct device *dev, pm_message_t mesg)
 	if ((mesg.event & PM_EVENT_SLEEP) && sdkp->device->manage_start_stop) {
 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
 		ret = sd_start_stop_device(sdkp, 0);
+		/* an error is not worth aborting a system sleep */
+		if (!(mesg.event & PM_EVENT_AUTO))
+			ret = 0;
 	}
 
 done:
