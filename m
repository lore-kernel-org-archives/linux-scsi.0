From: Aaron Lu <Aaron.Lu@amd.com>
Subject: [RFC PATCH]scsi: pm: resume device if suspend failed
Date: Fri, 11 May 2012 14:54:54 +0800
Message-ID: <1336719294-25598-1-git-send-email-Aaron.Lu@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:8895
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754114Ab2EKGzs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 May 2012 02:55:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <Aaron.Lu@amd.com>

For scsi devices which use scsi bus runtime callback, runtime suspend
will call scsi_dev_type_suspend, and if the drv->suspend failed, the
device will still be in active state. But since scsi_device_quiesce is
called, the device will not be able to respond any more commands.
So add a check here to see if err occured, if so, bring the device back
to normal state with scsi_device_resume.

Signed-off-by: Aaron Lu <Aaron.Lu@amd.com>
---
 drivers/scsi/scsi_pm.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index c467064..33b8bf9 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -24,8 +24,11 @@ static int scsi_dev_type_suspend(struct device *dev, pm_message_t msg)
 	err = scsi_device_quiesce(to_scsi_device(dev));
 	if (err == 0) {
 		drv = dev->driver;
-		if (drv && drv->suspend)
+		if (drv && drv->suspend) {
 			err = drv->suspend(dev, msg);
+			if (err)
+				scsi_device_resume(dev);
+		}
 	}
 	dev_dbg(dev, "scsi suspend: %d\n", err);
 	return err;
-- 
1.7.9.6


