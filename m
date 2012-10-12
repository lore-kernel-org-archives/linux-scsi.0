From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v3 1/5] sd: put to stopped power state when runtime suspend
Date: Fri, 12 Oct 2012 14:59:34 +0800
Message-ID: <1350025178-2976-2-git-send-email-aaron.lu@intel.com>
References: <1350025178-2976-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:50792 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837Ab2JLG75 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Oct 2012 02:59:57 -0400
In-Reply-To: <1350025178-2976-1-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@intel.com>

When device is runtime suspended, put it to stopped power state to save
some power.

This will also make the behaviour consistent with what the scsi_pm.c
thinks about sd as the comment says:
sd treats runtime suspend, system suspend and system hibernate identical.
With this patch, it is now identical.
And sd_shutdown will also do nothing when it finds the device has been
runtime suspended, if we do not spin down the disk in runtime suspend
by putting it into stopped power state, the disk will be shut down
incorrectly.
And the the same problem can be solved for runtime power off after
runtime suspended case by this change.

With the current runtime scheme for disk, it will only be runtime
suspended when no process opens the disk, so this shouldn't happen a
lot, which makes it acceptable to spin down the disk when runtime
suspended. If some day a more aggressive runtime scheme is used, like
the 'request based runtime pm for disk' that Alan Stern and Lin Ming
has been working, we can introduce some policy to control this. But for
now, make it simple and correct by spinning down the disk.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/scsi/sd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 12f6fdf..8b6e004 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2911,7 +2911,8 @@ static int sd_suspend(struct device *dev, pm_message_t mesg)
 			goto done;
 	}
 
-	if ((mesg.event & PM_EVENT_SLEEP) && sdkp->device->manage_start_stop) {
+	if (((mesg.event & PM_EVENT_SLEEP) || PMSG_IS_AUTO(mesg)) &&
+			sdkp->device->manage_start_stop) {
 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
 		ret = sd_start_stop_device(sdkp, 0);
 	}
-- 
1.7.12.21.g871e293

