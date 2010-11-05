From: Oliver Neukum <oneukum@suse.de>
Subject: [PATCH 3/3] SCSI:sd: sd_start_stop_device() error handling
Date: Fri, 5 Nov 2010 11:09:22 +0100
Message-ID: <201011051109.22392.oneukum@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40506 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815Ab0KEKJC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Nov 2010 06:09:02 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.221.2])
	by mx2.suse.de (Postfix) with ESMTP id B2DEB8655F
	for <linux-scsi@vger.kernel.org>; Fri,  5 Nov 2010 11:09:00 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>, hare@suse.de, linux-scsi@vger.kernel.org

>From 63cd566f7e63bc1592e2652b95b53cf7aaa7dcb3 Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oliver@neukum.org>
Date: Mon, 25 Oct 2010 15:36:27 +0200
Subject: [PATCH 3/3] SCSI:sd: sd_start_stop_device() error handling

- ignore failure of sd_start_stop_device() due to medium removal
- do not abort a system suspension due to a failure in sd_start_stop_device()

Signed-off-by: Oliver Neukum <oneukum@suse.de>
---
 drivers/scsi/sd.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5ed75bf..9559fc4 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2569,6 +2569,10 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 		sd_print_result(sdkp, res);
 		if (driver_byte(res) & DRIVER_SENSE)
 			sd_print_sense_hdr(sdkp, &sshdr);
+		if ((scsi_sense_valid(&sshdr) &&
+			/* 0x3a is medium not present */
+			sshdr.asc == 0x3a))
+			res = 0;
 	}
 
 	/* SCSI error codes must not go to the generic layer */
@@ -2621,6 +2625,10 @@ static int sd_suspend(struct device *dev, pm_message_t mesg)
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
1.7.1

