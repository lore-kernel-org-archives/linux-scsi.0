From: Aaron Lu <aaron.lu@amd.com>
Subject: [PATCH 1/5] scsi: sr: fix for sr suspend and resume
Date: Mon, 23 Jul 2012 14:49:36 +0800
Message-ID: <1343026180-22236-2-git-send-email-aaron.lu@amd.com>
References: <1343026180-22236-1-git-send-email-aaron.lu@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1343026180-22236-1-git-send-email-aaron.lu@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Lin Ming <minggr@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@amd.com>
List-Id: linux-scsi@vger.kernel.org

In sr_suspend, we do not need to do anything if it is not a runtime pm
request, so just return by checking the PM_EVENT_AUTO flag.
And in sr_resume, only reset the suspend_count back to 1 if the ODD is
waken up by the user, or the usage count of the scsi device will not
balance.

Signed-off-by: Aaron Lu <aaron.lu@amd.com>
---
 drivers/scsi/sr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 3da0879..5f4d19a 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -178,8 +178,8 @@ static int sr_suspend(struct device *dev, pm_message_t msg)
 	struct scsi_sense_hdr sshdr;
 	struct scsi_cd *cd = dev_get_drvdata(dev);
 
-	/* no action for system suspend */
-	if (msg.event == PM_EVENT_SUSPEND)
+	/* no action for system pm operations */
+	if (!(msg.event & PM_EVENT_AUTO))
 		return 0;
 
 	/* do another TUR to see if the ODD is still ready to be powered off */
@@ -217,9 +217,9 @@ static int sr_resume(struct device *dev)
 		cd->device->wakeup_by_user = 0;
 		if (!(cd->cdi.mask & CDC_CLOSE_TRAY))
 			sr_tray_move(&cd->cdi, 1);
-	}
 
-	atomic_set(&cd->suspend_count, 1);
+		atomic_set(&cd->suspend_count, 1);
+	}
 
 	return 0;
 }
-- 
1.7.11.3
