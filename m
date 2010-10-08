From: Oliver Neukum <oneukum@suse.de>
Subject: [PATCH 1/2] SCSI: sd_suspend: evaluate lower layers' returns
Date: Fri, 8 Oct 2010 15:32:29 +0200
Message-ID: <201010081532.29066.oneukum@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:51873 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753683Ab0JHNcb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2010 09:32:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>, hare@suse.de, Alan Stern <stern@rowland.harvard.edu>, teheo@suse.de, linux-scsi@vger.kernel.org

>From 57262ff8bee869f671f843c81f48c2ed3d6713df Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oliver@neukum.org>
Date: Fri, 8 Oct 2010 15:00:16 +0200
Subject: [PATCH 1/2] SCSI: sd_suspend: evaluate lower layers' returns

sd_suspend() sends down commands that may fail.
Depending on the reason of failure the failures
can be ignored, the suspension retried or aborted.
This patch evaluates the error returns from the lower
layers to do so.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
---
 drivers/scsi/sd.c |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ffa0689..5784c94 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1083,9 +1083,7 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 			sd_print_sense_hdr(sdkp, &sshdr);
 	}
 
-	if (res)
-		return -EIO;
-	return 0;
+	return res;
 }
 
 static void sd_rescan(struct device *dev)
@@ -2526,7 +2524,25 @@ static int sd_suspend(struct device *dev, pm_message_t mesg)
 
 done:
 	scsi_disk_put(sdkp);
-	return ret;
+
+	if (ret) {
+		/* ??should errors due to medium removal be ignored? */
+		switch (host_byte(ret)) {
+		/* ignore errors due to racing a disconnection */
+		case DID_BAD_TARGET:
+		case DID_NO_CONNECT:	
+			return 0;
+		/* signal the upper layer it might try again */
+		case DID_BUS_BUSY:
+		case DID_ABORT:
+		case DID_RESET:
+			return -EBUSY;
+		default:
+			return -EIO;
+		}
+	} else {
+		return 0;
+	}
 }
 
 static int sd_resume(struct device *dev)
-- 
1.7.1

