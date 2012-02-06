From: Huang Ying <ying.huang@intel.com>
Subject: [RFC 3/5] scsi, pm, add pm_runtime_get/put in scsi request function
Date: Mon,  6 Feb 2012 15:32:26 +0800
Message-ID: <1328513548-19786-4-git-send-email-ying.huang@intel.com>
References: <1328513548-19786-1-git-send-email-ying.huang@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1328513548-19786-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: ming.m.lin@intel.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>, Huang Ying <ying.huang@intel.com>
List-Id: linux-scsi@vger.kernel.org

To support request based scsi device runtime PM.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/scsi/scsi_lib.c  |   10 ++++++++++
 drivers/scsi/scsi_pm.c   |   30 ++++++++++++++++++++++++++++++
 drivers/scsi/scsi_priv.h |    8 ++++++++
 3 files changed, 48 insertions(+)

--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -314,6 +314,8 @@ void scsi_device_unbusy(struct scsi_devi
 	spin_unlock(shost->host_lock);
 	spin_lock(sdev->request_queue->queue_lock);
 	sdev->device_busy--;
+	if (!sdev->device_busy)
+		scsi_autopm_put_device(sdev);
 	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 }
 
@@ -1418,6 +1420,8 @@ static void scsi_kill_request(struct req
 	 * bump busy counts.  To bump the counters, we need to dance
 	 * with the locks as normal issue path does.
 	 */
+	if (!sdev->device_busy)
+		scsi_autopm_get_device_noresume(sdev);
 	sdev->device_busy++;
 	spin_unlock(sdev->request_queue->queue_lock);
 	spin_lock(shost->host_lock);
@@ -1520,6 +1524,10 @@ static void scsi_request_fn(struct reque
 		}
 
 
+		if (!sdev->device_busy) {
+			if (scsi_autopm_get_device(sdev))
+				break;
+		}
 		/*
 		 * Remove the request from the request list.
 		 */
@@ -1600,6 +1608,8 @@ static void scsi_request_fn(struct reque
 	spin_lock_irq(q->queue_lock);
 	blk_requeue_request(q, req);
 	sdev->device_busy--;
+	if (sdev->device_busy == 0)
+		scsi_autopm_put_device_noidle(sdev);
 out_delay:
 	if (sdev->device_busy == 0)
 		blk_delay_queue(q, SCSI_QUEUE_DELAY);
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -176,12 +176,42 @@ int scsi_autopm_get_device_sync(struct s
 }
 EXPORT_SYMBOL_GPL(scsi_autopm_get_device_sync);
 
+int scsi_autopm_get_device(struct scsi_device *sdev)
+{
+	int	err;
+
+	err = pm_runtime_get(&sdev->sdev_gendev);
+	if (err < 0 && err != -EACCES && err != -EINPROGRESS &&
+	    err != -EAGAIN)
+		pm_runtime_put_noidle(&sdev->sdev_gendev);
+	else
+		err = 0;
+	return err;
+}
+
+void scsi_autopm_get_device_noresume(struct scsi_device *sdev)
+{
+	pm_runtime_get_noresume(&sdev->sdev_gendev);
+}
+
 void scsi_autopm_put_device_sync(struct scsi_device *sdev)
 {
+	pm_runtime_mark_last_busy(&sdev->sdev_gendev);
 	pm_runtime_put_sync(&sdev->sdev_gendev);
 }
 EXPORT_SYMBOL_GPL(scsi_autopm_put_device_sync);
 
+void scsi_autopm_put_device(struct scsi_device *sdev)
+{
+	pm_runtime_mark_last_busy(&sdev->sdev_gendev);
+	pm_runtime_put(&sdev->sdev_gendev);
+}
+
+void scsi_autopm_put_device_noidle(struct scsi_device *sdev)
+{
+	pm_runtime_put_noidle(&sdev->sdev_gendev);
+}
+
 void scsi_autopm_get_target_sync(struct scsi_target *starget)
 {
 	pm_runtime_get_sync(&starget->dev);
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -151,11 +151,19 @@ static inline void scsi_netlink_exit(voi
 extern const struct dev_pm_ops scsi_bus_pm_ops;
 #endif
 #ifdef CONFIG_PM_RUNTIME
+extern int scsi_autopm_get_device(struct scsi_device *);
+extern void scsi_autopm_get_device_noresume(struct scsi_device *);
+extern void scsi_autopm_put_device(struct scsi_device *);
+extern void scsi_autopm_put_device_noidle(struct scsi_device *);
 extern void scsi_autopm_get_target_sync(struct scsi_target *);
 extern void scsi_autopm_put_target_sync(struct scsi_target *);
 extern int scsi_autopm_get_host_sync(struct Scsi_Host *);
 extern void scsi_autopm_put_host_sync(struct Scsi_Host *);
 #else
+extern int scsi_autopm_get_device(struct scsi_device *sdev) { return 0; }
+extern void scsi_autopm_get_device_noresume(struct scsi_device *sdev) {}
+extern void scsi_autopm_put_device(struct scsi_device *sdev) {}
+extern void scsi_autopm_put_device_noidle(struct scsi_device *sdev) {}
 static inline void scsi_autopm_get_target_sync(struct scsi_target *t) {}
 static inline void scsi_autopm_put_target_sync(struct scsi_target *t) {}
 static inline int scsi_autopm_get_host_sync(struct Scsi_Host *h) { return 0; }
