From: Oliver Neukum <oliver@neukum.org>
Subject: [PATCH 2/3] sd: handle errors in sd_start_stop_device()
Date: Wed,  1 Aug 2012 16:44:09 +0200
Message-ID: <1343832250-24228-3-git-send-email-oliver@neukum.org>
References: <1343832250-24228-1-git-send-email-oliver@neukum.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:50461 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab2HAPAC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Aug 2012 11:00:02 -0400
In-Reply-To: <1343832250-24228-1-git-send-email-oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org, hare@suse.de
Cc: Oliver Neukum <oliver@neukum.org>

Errors are not handled correctly in sd_start_stop_device().

First, if a device cannot be stopped because a medium has been
removed, this is not an error. This fixes a bug when suspending
the system right after pulling a medium out of a card reader.

Second, if the full system is to be suspended, a failure to stop
a device is not a good reason to abort a suspend, as that won't
improve matters.

Signed-of-by: Oliver Neukum <oneukum@suse.de>
---
 drivers/scsi/sd.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index cef06f5..a344220 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2828,6 +2828,10 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 		sd_print_result(sdkp, res);
 		if (driver_byte(res) & DRIVER_SENSE)
 			sd_print_sense_hdr(sdkp, &sshdr);
+		if ((scsi_sense_valid(&sshdr) &&
+			/* 0x3a is medium not present */
+			sshdr.asc == 0x3a))
+			res = 0;
 	}
 
 	/* SCSI error codes must not go to the generic layer */
@@ -2884,6 +2888,10 @@ static int sd_suspend(struct device *dev, pm_message_t mesg)
 	if ((mesg.event & PM_EVENT_SLEEP) && sdkp->device->manage_start_stop) {
 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
 		ret = sd_start_stop_device(sdkp, 0);
+
+		/* an error is not worth aborting a system sleep */
+		if (!(mesg.event & PM_EVENT_AUTO))
+			ret = 0;
 	}
 
 done:
-- 
1.7.7

