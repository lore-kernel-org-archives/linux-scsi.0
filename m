From: Huang Ying <ying.huang@intel.com>
Subject: [RFC 4/5] scsi, pm, use autosuspend for scsi runtime PM
Date: Mon,  6 Feb 2012 15:32:27 +0800
Message-ID: <1328513548-19786-5-git-send-email-ying.huang@intel.com>
References: <1328513548-19786-1-git-send-email-ying.huang@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1328513548-19786-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: ming.m.lin@intel.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>, Huang Ying <ying.huang@intel.com>
List-Id: linux-scsi@vger.kernel.org

So that the timeout can be adjusted for each device, make it easy to
implement request and open/close based runtime PM.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/scsi/scsi_pm.c    |    2 +-
 drivers/scsi/scsi_sysfs.c |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -157,7 +157,7 @@ static int scsi_runtime_idle(struct devi
 	/* Insert hooks here for targets, hosts, and transport classes */
 
 	if (scsi_is_sdev_device(dev))
-		err = pm_schedule_suspend(dev, 100);
+		err = pm_runtime_autosuspend(dev);
 	else
 		err = pm_runtime_suspend(dev);
 	return err;
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -887,6 +887,8 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 	pm_runtime_set_active(&sdev->sdev_gendev);
 	pm_runtime_forbid(&sdev->sdev_gendev);
 	pm_runtime_enable(&sdev->sdev_gendev);
+	pm_runtime_set_autosuspend_delay(&sdev->sdev_gendev, 100);
+	pm_runtime_use_autosuspend(&sdev->sdev_gendev);
 	scsi_autopm_put_target_sync(starget);
 
 	/* The following call will keep sdev active indefinitely, until
