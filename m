From: Oliver Neukum <oneukum@suse.de>
Subject: [PATCH]SCSI: don't return errors for failures in sd_suspend()
Date: Tue, 5 Oct 2010 16:28:21 +0200
Message-ID: <201010051628.21414.oneukum@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:51729 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291Ab0JEO1X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2010 10:27:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, hare@suse.de

>From f4eee84ae76a303f8ceca761f0d9e3813b4d45cb Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oliver@neukum.org>
Date: Tue, 5 Oct 2010 16:10:30 +0200
Subject: [PATCH] SCSI: don't return errors for failures in sd_suspend()

If an uncoorectable error happens during the suspension
of an sd device, the device is unsalvageable. The error
can be ignored, as offlined devices will be ignored in
the future anyway.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
---
 drivers/scsi/sd.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ffa0689..5bda210 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2526,7 +2526,8 @@ static int sd_suspend(struct device *dev, pm_message_t mesg)
 
 done:
 	scsi_disk_put(sdkp);
-	return ret;
+	sd_printk(KERN_ERR, sdkp, "Error %d suspending device\n", ret);
+	return 0;
 }
 
 static int sd_resume(struct device *dev)
-- 
1.7.1

