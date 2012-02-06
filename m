From: Huang Ying <ying.huang@intel.com>
Subject: [RFC 2/5] scsi, pm, rename scsi_autopm_get/put_xxx to scsi_autopm_get/put_xxx_sync
Date: Mon,  6 Feb 2012 15:32:25 +0800
Message-ID: <1328513548-19786-3-git-send-email-ying.huang@intel.com>
References: <1328513548-19786-1-git-send-email-ying.huang@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1328513548-19786-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: ming.m.lin@intel.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>, Huang Ying <ying.huang@intel.com>
List-Id: linux-scsi@vger.kernel.org

To distinguish with the asynchronous version we will add later.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/scsi/hosts.c       |    2 +-
 drivers/scsi/scsi_error.c  |    8 ++++----
 drivers/scsi/scsi_pm.c     |   16 ++++++++--------
 drivers/scsi/scsi_priv.h   |   16 ++++++++--------
 drivers/scsi/scsi_scan.c   |   28 ++++++++++++++--------------
 drivers/scsi/scsi_sysfs.c  |    6 +++---
 drivers/scsi/sd.c          |   10 +++++-----
 drivers/scsi/sg.c          |    6 +++---
 include/scsi/scsi_device.h |    8 ++++----
 9 files changed, 50 insertions(+), 50 deletions(-)

--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -168,7 +168,7 @@ void scsi_remove_host(struct Scsi_Host *
 		}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
-	scsi_autopm_get_host(shost);
+	scsi_autopm_get_host_sync(shost);
 	scsi_forget_host(shost);
 	mutex_unlock(&shost->scan_mutex);
 	scsi_proc_host_rm(shost);
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1812,7 +1812,7 @@ int scsi_error_handler(void *data)
 		 * what we need to do to get it up and online again (if we can).
 		 * If we fail, we end up taking the thing offline.
 		 */
-		if (!shost->eh_noresume && scsi_autopm_get_host(shost) != 0) {
+		if (!shost->eh_noresume && scsi_autopm_get_host_sync(shost) != 0) {
 			SCSI_LOG_ERROR_RECOVERY(1,
 				printk(KERN_ERR "Error handler scsi_eh_%d "
 						"unable to autoresume\n",
@@ -1834,7 +1834,7 @@ int scsi_error_handler(void *data)
 		 */
 		scsi_restart_operations(shost);
 		if (!shost->eh_noresume)
-			scsi_autopm_put_host(shost);
+			scsi_autopm_put_host_sync(shost);
 		set_current_state(TASK_INTERRUPTIBLE);
 	}
 	__set_current_state(TASK_RUNNING);
@@ -1938,7 +1938,7 @@ scsi_reset_provider(struct scsi_device *
 	unsigned long flags;
 	int rtn;
 
-	if (scsi_autopm_get_host(shost) < 0)
+	if (scsi_autopm_get_host_sync(shost) < 0)
 		return FAILED;
 
 	scmd = scsi_get_command(dev, GFP_KERNEL);
@@ -1998,7 +1998,7 @@ scsi_reset_provider(struct scsi_device *
 	scsi_run_host_queues(shost);
 
 	scsi_next_command(scmd);
-	scsi_autopm_put_host(shost);
+	scsi_autopm_put_host_sync(shost);
 	return rtn;
 }
 EXPORT_SYMBOL(scsi_reset_provider);
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -163,7 +163,7 @@ static int scsi_runtime_idle(struct devi
 	return err;
 }
 
-int scsi_autopm_get_device(struct scsi_device *sdev)
+int scsi_autopm_get_device_sync(struct scsi_device *sdev)
 {
 	int	err;
 
@@ -174,25 +174,25 @@ int scsi_autopm_get_device(struct scsi_d
 		err = 0;
 	return err;
 }
-EXPORT_SYMBOL_GPL(scsi_autopm_get_device);
+EXPORT_SYMBOL_GPL(scsi_autopm_get_device_sync);
 
-void scsi_autopm_put_device(struct scsi_device *sdev)
+void scsi_autopm_put_device_sync(struct scsi_device *sdev)
 {
 	pm_runtime_put_sync(&sdev->sdev_gendev);
 }
-EXPORT_SYMBOL_GPL(scsi_autopm_put_device);
+EXPORT_SYMBOL_GPL(scsi_autopm_put_device_sync);
 
-void scsi_autopm_get_target(struct scsi_target *starget)
+void scsi_autopm_get_target_sync(struct scsi_target *starget)
 {
 	pm_runtime_get_sync(&starget->dev);
 }
 
-void scsi_autopm_put_target(struct scsi_target *starget)
+void scsi_autopm_put_target_sync(struct scsi_target *starget)
 {
 	pm_runtime_put_sync(&starget->dev);
 }
 
-int scsi_autopm_get_host(struct Scsi_Host *shost)
+int scsi_autopm_get_host_sync(struct Scsi_Host *shost)
 {
 	int	err;
 
@@ -204,7 +204,7 @@ int scsi_autopm_get_host(struct Scsi_Hos
 	return err;
 }
 
-void scsi_autopm_put_host(struct Scsi_Host *shost)
+void scsi_autopm_put_host_sync(struct Scsi_Host *shost)
 {
 	pm_runtime_put_sync(&shost->shost_gendev);
 }
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -151,15 +151,15 @@ static inline void scsi_netlink_exit(voi
 extern const struct dev_pm_ops scsi_bus_pm_ops;
 #endif
 #ifdef CONFIG_PM_RUNTIME
-extern void scsi_autopm_get_target(struct scsi_target *);
-extern void scsi_autopm_put_target(struct scsi_target *);
-extern int scsi_autopm_get_host(struct Scsi_Host *);
-extern void scsi_autopm_put_host(struct Scsi_Host *);
+extern void scsi_autopm_get_target_sync(struct scsi_target *);
+extern void scsi_autopm_put_target_sync(struct scsi_target *);
+extern int scsi_autopm_get_host_sync(struct Scsi_Host *);
+extern void scsi_autopm_put_host_sync(struct Scsi_Host *);
 #else
-static inline void scsi_autopm_get_target(struct scsi_target *t) {}
-static inline void scsi_autopm_put_target(struct scsi_target *t) {}
-static inline int scsi_autopm_get_host(struct Scsi_Host *h) { return 0; }
-static inline void scsi_autopm_put_host(struct Scsi_Host *h) {}
+static inline void scsi_autopm_get_target_sync(struct scsi_target *t) {}
+static inline void scsi_autopm_put_target_sync(struct scsi_target *t) {}
+static inline int scsi_autopm_get_host_sync(struct Scsi_Host *h) { return 0; }
+static inline void scsi_autopm_put_host_sync(struct Scsi_Host *h) {}
 #endif /* CONFIG_PM_RUNTIME */
 
 /* 
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1510,18 +1510,18 @@ struct scsi_device *__scsi_add_device(st
 	starget = scsi_alloc_target(parent, channel, id);
 	if (!starget)
 		return ERR_PTR(-ENOMEM);
-	scsi_autopm_get_target(starget);
+	scsi_autopm_get_target_sync(starget);
 
 	mutex_lock(&shost->scan_mutex);
 	if (!shost->async_scan)
 		scsi_complete_async_scans();
 
-	if (scsi_host_scan_allowed(shost) && scsi_autopm_get_host(shost) == 0) {
+	if (scsi_host_scan_allowed(shost) && scsi_autopm_get_host_sync(shost) == 0) {
 		scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1, hostdata);
-		scsi_autopm_put_host(shost);
+		scsi_autopm_put_host_sync(shost);
 	}
 	mutex_unlock(&shost->scan_mutex);
-	scsi_autopm_put_target(starget);
+	scsi_autopm_put_target_sync(starget);
 	scsi_target_reap(starget);
 	put_device(&starget->dev);
 
@@ -1575,7 +1575,7 @@ static void __scsi_scan_target(struct de
 	starget = scsi_alloc_target(parent, channel, id);
 	if (!starget)
 		return;
-	scsi_autopm_get_target(starget);
+	scsi_autopm_get_target_sync(starget);
 
 	if (lun != SCAN_WILD_CARD) {
 		/*
@@ -1601,7 +1601,7 @@ static void __scsi_scan_target(struct de
 	}
 
  out_reap:
-	scsi_autopm_put_target(starget);
+	scsi_autopm_put_target_sync(starget);
 	/* now determine if the target has any children at all
 	 * and if not, nuke it */
 	scsi_target_reap(starget);
@@ -1636,9 +1636,9 @@ void scsi_scan_target(struct device *par
 	if (!shost->async_scan)
 		scsi_complete_async_scans();
 
-	if (scsi_host_scan_allowed(shost) && scsi_autopm_get_host(shost) == 0) {
+	if (scsi_host_scan_allowed(shost) && scsi_autopm_get_host_sync(shost) == 0) {
 		__scsi_scan_target(parent, channel, id, lun, rescan);
-		scsi_autopm_put_host(shost);
+		scsi_autopm_put_host_sync(shost);
 	}
 	mutex_unlock(&shost->scan_mutex);
 }
@@ -1691,7 +1691,7 @@ int scsi_scan_host_selected(struct Scsi_
 	if (!shost->async_scan)
 		scsi_complete_async_scans();
 
-	if (scsi_host_scan_allowed(shost) && scsi_autopm_get_host(shost) == 0) {
+	if (scsi_host_scan_allowed(shost) && scsi_autopm_get_host_sync(shost) == 0) {
 		if (channel == SCAN_WILD_CARD)
 			for (channel = 0; channel <= shost->max_channel;
 			     channel++)
@@ -1699,7 +1699,7 @@ int scsi_scan_host_selected(struct Scsi_
 						  rescan);
 		else
 			scsi_scan_channel(shost, channel, id, lun, rescan);
-		scsi_autopm_put_host(shost);
+		scsi_autopm_put_host_sync(shost);
 	}
 	mutex_unlock(&shost->scan_mutex);
 
@@ -1841,7 +1841,7 @@ static int do_scan_async(void *_data)
 
 	do_scsi_scan_host(shost);
 	scsi_finish_async_scan(data);
-	scsi_autopm_put_host(shost);
+	scsi_autopm_put_host_sync(shost);
 	return 0;
 }
 
@@ -1856,20 +1856,20 @@ void scsi_scan_host(struct Scsi_Host *sh
 
 	if (strncmp(scsi_scan_type, "none", 4) == 0)
 		return;
-	if (scsi_autopm_get_host(shost) < 0)
+	if (scsi_autopm_get_host_sync(shost) < 0)
 		return;
 
 	data = scsi_prep_async_scan(shost);
 	if (!data) {
 		do_scsi_scan_host(shost);
-		scsi_autopm_put_host(shost);
+		scsi_autopm_put_host_sync(shost);
 		return;
 	}
 
 	p = kthread_run(do_scan_async, data, "scsi_scan_%d", shost->host_no);
 	if (IS_ERR(p))
 		do_scan_async(data);
-	/* scsi_autopm_put_host(shost) is called in do_scan_async() */
+	/* scsi_autopm_put_host_sync(shost) is called in do_scan_async() */
 }
 EXPORT_SYMBOL(scsi_scan_host);
 
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -883,17 +883,17 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 	transport_configure_device(&starget->dev);
 
 	device_enable_async_suspend(&sdev->sdev_gendev);
-	scsi_autopm_get_target(starget);
+	scsi_autopm_get_target_sync(starget);
 	pm_runtime_set_active(&sdev->sdev_gendev);
 	pm_runtime_forbid(&sdev->sdev_gendev);
 	pm_runtime_enable(&sdev->sdev_gendev);
-	scsi_autopm_put_target(starget);
+	scsi_autopm_put_target_sync(starget);
 
 	/* The following call will keep sdev active indefinitely, until
 	 * its driver does a corresponding scsi_autopm_pm_device().  Only
 	 * drivers supporting autosuspend will do this.
 	 */
-	scsi_autopm_get_device(sdev);
+	scsi_autopm_get_device_sync(sdev);
 
 	error = device_add(&sdev->sdev_gendev);
 	if (error) {
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -936,7 +936,7 @@ static int sd_open(struct block_device *
 
 	sdev = sdkp->device;
 
-	retval = scsi_autopm_get_device(sdev);
+	retval = scsi_autopm_get_device_sync(sdev);
 	if (retval)
 		goto error_autopm;
 
@@ -984,7 +984,7 @@ static int sd_open(struct block_device *
 	return 0;
 
 error_out:
-	scsi_autopm_put_device(sdev);
+	scsi_autopm_put_device_sync(sdev);
 error_autopm:
 	scsi_disk_put(sdkp);
 	return retval;	
@@ -1020,7 +1020,7 @@ static int sd_release(struct gendisk *di
 	 * XXX is followed by a "rmmod sd_mod"?
 	 */
 
-	scsi_autopm_put_device(sdev);
+	scsi_autopm_put_device_sync(sdev);
 	scsi_disk_put(sdkp);
 	return 0;
 }
@@ -2543,7 +2543,7 @@ static void sd_probe_async(void *data, a
 
 	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
 		  sdp->removable ? "removable " : "");
-	scsi_autopm_put_device(sdp);
+	scsi_autopm_put_device_sync(sdp);
 	put_device(&sdkp->dev);
 }
 
@@ -2667,7 +2667,7 @@ static int sd_remove(struct device *dev)
 	struct scsi_disk *sdkp;
 
 	sdkp = dev_get_drvdata(dev);
-	scsi_autopm_get_device(sdkp->device);
+	scsi_autopm_get_device_sync(sdkp->device);
 
 	async_synchronize_full();
 	blk_queue_prep_rq(sdkp->device->request_queue, scsi_prep_fn);
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -248,7 +248,7 @@ sg_open(struct inode *inode, struct file
 	if (retval)
 		goto sg_put;
 
-	retval = scsi_autopm_get_device(sdp->device);
+	retval = scsi_autopm_get_device_sync(sdp->device);
 	if (retval)
 		goto sdp_put;
 
@@ -310,7 +310,7 @@ sg_open(struct inode *inode, struct file
 	retval = 0;
 error_out:
 	if (retval) {
-		scsi_autopm_put_device(sdp->device);
+		scsi_autopm_put_device_sync(sdp->device);
 sdp_put:
 		scsi_device_put(sdp->device);
 	}
@@ -337,7 +337,7 @@ sg_release(struct inode *inode, struct f
 	sdp->exclude = 0;
 	wake_up_interruptible(&sdp->o_excl_wait);
 
-	scsi_autopm_put_device(sdp->device);
+	scsi_autopm_put_device_sync(sdp->device);
 	kref_put(&sfp->f_ref, sg_remove_sfp);
 	return 0;
 }
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -386,11 +386,11 @@ extern int scsi_execute_req(struct scsi_
 			    int *resid);
 
 #ifdef CONFIG_PM_RUNTIME
-extern int scsi_autopm_get_device(struct scsi_device *);
-extern void scsi_autopm_put_device(struct scsi_device *);
+extern int scsi_autopm_get_device_sync(struct scsi_device *);
+extern void scsi_autopm_put_device_sync(struct scsi_device *);
 #else
-static inline int scsi_autopm_get_device(struct scsi_device *d) { return 0; }
-static inline void scsi_autopm_put_device(struct scsi_device *d) {}
+static inline int scsi_autopm_get_device_sync(struct scsi_device *d) { return 0; }
+static inline void scsi_autopm_put_device_sync(struct scsi_device *d) {}
 #endif /* CONFIG_PM_RUNTIME */
 
 static inline int __must_check scsi_device_reprobe(struct scsi_device *sdev)
