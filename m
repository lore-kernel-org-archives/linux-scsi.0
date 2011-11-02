From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH 2/3] scsi: add hooks for host runtime power management
Date: Wed,  2 Nov 2011 14:21:39 +0800
Message-ID: <1320214900-2112-3-git-send-email-ming.m.lin@intel.com>
References: <1320214900-2112-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1320214900-2112-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@Parallels.com>, Tejun Heo <tj@kernel.org>, Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

Adds ->suspend and ->resume callbacks in struct scsi_host_template
to do host runtime power management.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/scsi/scsi_pm.c   |   34 +++++++++++++++++++++++++++++++---
 include/scsi/scsi_host.h |    8 ++++++++
 2 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index 1be6c5a..5742bed2 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -42,6 +42,28 @@ static int scsi_dev_type_resume(struct device *dev)
 	return err;
 }
 
+static int scsi_host_suspend(struct device *dev)
+{
+	struct Scsi_Host *shost = dev_to_shost(dev);
+	int err = 0;
+
+	if (shost->hostt->suspend)
+		err = shost->hostt->suspend(shost);
+
+	return err;
+}
+
+static int scsi_host_resume(struct device *dev)
+{
+	struct Scsi_Host *shost = dev_to_shost(dev);
+	int err = 0;
+
+	if (shost->hostt->resume)
+		err = shost->hostt->resume(shost);
+
+	return err;
+}
+
 #ifdef CONFIG_PM_SLEEP
 
 static int scsi_bus_suspend_common(struct device *dev, pm_message_t msg)
@@ -106,7 +128,10 @@ static int scsi_runtime_suspend(struct device *dev)
 				round_jiffies_up_relative(HZ/10)));
 	}
 
-	/* Insert hooks here for targets, hosts, and transport classes */
+	/* Insert hooks here for targets and transport classes */
+
+	if (scsi_is_host_device(dev))
+		err = scsi_host_suspend(dev);
 
 	return err;
 }
@@ -119,7 +144,10 @@ static int scsi_runtime_resume(struct device *dev)
 	if (scsi_is_sdev_device(dev))
 		err = scsi_dev_type_resume(dev);
 
-	/* Insert hooks here for targets, hosts, and transport classes */
+	/* Insert hooks here for targets and transport classes */
+
+	if (scsi_is_host_device(dev))
+		err = scsi_host_resume(dev);
 
 	return err;
 }
@@ -132,7 +160,7 @@ static int scsi_runtime_idle(struct device *dev)
 
 	/* Insert hooks here for targets, hosts, and transport classes */
 
-	if (scsi_is_sdev_device(dev))
+	if (scsi_is_sdev_device(dev) || scsi_is_host_device(dev))
 		err = pm_schedule_suspend(dev, 100);
 	else
 		err = pm_runtime_suspend(dev);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index f1f2644..512e2a0 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -356,6 +356,14 @@ struct scsi_host_template {
 	enum blk_eh_timer_return (*eh_timed_out)(struct scsi_cmnd *);
 
 	/*
+	 * Optional routine for scsi host runtime pm.
+	 *
+	 * Status: OPTIONAL
+	 */
+	int (*suspend)(struct Scsi_Host *);
+	int (*resume)(struct Scsi_Host *);
+
+	/*
 	 * Name of proc directory
 	 */
 	const char *proc_name;
-- 
1.7.2.5
