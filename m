From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 2/3 ver 2] SCSI: implement runtime Power Management
Date: Thu, 17 Jun 2010 10:41:42 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1006171036540.1915-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1006161156510.1587-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:49710 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756007Ab0FQOlp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jun 2010 10:41:45 -0400
In-Reply-To: <Pine.LNX.4.44L0.1006161156510.1587-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1398b) adds runtime PM support to the SCSI layer.  Only
the machanism is provided; use of it is up to the various high-level
drivers, and the patch doesn't change any of them.  Except for sg --
the patch expicitly prevents a device from being runtime-suspended
while its sg device file is open.

The implementation is simplistic.  In general, hosts and targets are
automatically suspended when all their children are asleep, but for
them the runtime-suspend code doesn't actually do anything.  (A host's
runtime PM status is propagated up the device tree, though, so a
runtime-PM-aware lower-level driver could power down the host adapter
hardware at the appropriate times.)  There are comments indicating
where a transport class might be notified or some other hooks added.

LUNs are runtime-suspended by calling the drivers' existing suspend
handlers (and likewise for runtime-resume).  Somewhat arbitrarily, the
implementation delays for 100 ms before suspending an eligible LUN.
This is because there typically are occasions during bootup when the
same device file is opened and closed several times in quick
succession.

The way this all works is that the SCSI core increments a device's
PM-usage count when it is registered.  If a high-level driver does
nothing then the device will not be eligible for runtime-suspend
because of the elevated usage count.  If a high-level driver wants to
use runtime PM then it can call scsi_autopm_put_device() in its probe
routine to decrement the usage count and scsi_autopm_get_device() in
its remove routine to restore the original count.

Hosts, targets, and LUNs are not suspended while they are being probed
or removed, or while the error handler is running.  In fact, a fairly
large part of the patch consists of code to make sure that things
aren't suspended at such times.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Version 2 changes:

	Rebase to apply on top of the revised 1/3 patch.

	Add a KERN_ERR log level to the SCSI_LOG_ERROR_RECOVERY
	call, as recommended by checkpatch.

Incidentally, although I didn't mention it before, this patch assumes 
that the 7-part series beginning here:

	http://marc.info/?l=linux-scsi&m=127551091314515&w=2

has been merged.


Index: usb-2.6/drivers/scsi/scsi_priv.h
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_priv.h
+++ usb-2.6/drivers/scsi/scsi_priv.h
@@ -7,6 +7,7 @@ struct request_queue;
 struct request;
 struct scsi_cmnd;
 struct scsi_device;
+struct scsi_target;
 struct scsi_host_template;
 struct Scsi_Host;
 struct scsi_nl_hdr;
@@ -147,7 +148,18 @@ static inline void scsi_netlink_exit(voi
 /* scsi_pm.c */
 #ifdef CONFIG_PM_OPS
 extern const struct dev_pm_ops scsi_bus_pm_ops;
+#ifdef CONFIG_PM_RUNTIME
+extern void scsi_autopm_get_target(struct scsi_target *);
+extern void scsi_autopm_put_target(struct scsi_target *);
+extern int scsi_autopm_get_host(struct Scsi_Host *);
+extern void scsi_autopm_put_host(struct Scsi_Host *);
 #else
+static inline void scsi_autopm_get_target(struct scsi_target *) {}
+static inline void scsi_autopm_put_target(struct scsi_target *) {}
+static inline int scsi_autopm_get_host(struct Scsi_Host *) { return 0; }
+static inline void scsi_autopm_put_host(struct Scsi_Host *) {}
+#endif /* CONFIG_PM_RUNTIME */
+#else /* CONFIG_PM_OPS */
 #define scsi_bus_pm_ops		(*NULL)
 #endif
 
Index: usb-2.6/include/scsi/scsi_device.h
===================================================================
--- usb-2.6.orig/include/scsi/scsi_device.h
+++ usb-2.6/include/scsi/scsi_device.h
@@ -381,6 +381,14 @@ extern int scsi_execute_req(struct scsi_
 			    struct scsi_sense_hdr *, int timeout, int retries,
 			    int *resid);
 
+#ifdef CONFIG_PM_RUNTIME
+extern int scsi_autopm_get_device(struct scsi_device *);
+extern void scsi_autopm_put_device(struct scsi_device *);
+#else
+static inline int scsi_autopm_get_device(struct scsi_device *) { return 0; }
+static inline void scsi_autopm_put_device(struct scsi_device *) {}
+#endif /* CONFIG_PM_RUNTIME */
+
 static inline int __must_check scsi_device_reprobe(struct scsi_device *sdev)
 {
 	return device_reprobe(&sdev->sdev_gendev);
Index: usb-2.6/drivers/scsi/scsi_pm.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_pm.c
+++ usb-2.6/drivers/scsi/scsi_pm.c
@@ -59,6 +59,12 @@ static int scsi_bus_resume_common(struct
 
 	if (scsi_is_sdev_device(dev))
 		err = scsi_dev_type_resume(dev);
+
+	if (err == 0) {
+		pm_runtime_disable(dev);
+		pm_runtime_set_active(dev);
+		pm_runtime_enable(dev);
+	}
 	return err;
 }
 
@@ -86,6 +92,107 @@ static int scsi_bus_poweroff(struct devi
 
 #endif /* CONFIG_PM_SLEEP */
 
+#ifdef CONFIG_PM_RUNTIME
+
+static int scsi_runtime_suspend(struct device *dev)
+{
+	int err = 0;
+
+	dev_dbg(dev, "scsi_runtime_suspend\n");
+	if (scsi_is_sdev_device(dev)) {
+		err = scsi_dev_type_suspend(dev, PMSG_AUTO_SUSPEND);
+		if (err == -EAGAIN)
+			pm_schedule_suspend(dev, jiffies_to_msecs(
+				round_jiffies_up_relative(HZ/10)));
+	}
+
+	/* Insert hooks here for targets, hosts, and transport classes */
+
+	return err;
+}
+
+static int scsi_runtime_resume(struct device *dev)
+{
+	int err = 0;
+
+	dev_dbg(dev, "scsi_runtime_resume\n");
+	if (scsi_is_sdev_device(dev))
+		err = scsi_dev_type_resume(dev);
+
+	/* Insert hooks here for targets, hosts, and transport classes */
+
+	return err;
+}
+
+static int scsi_runtime_idle(struct device *dev)
+{
+	int err;
+
+	dev_dbg(dev, "scsi_runtime_idle\n");
+
+	/* Insert hooks here for targets, hosts, and transport classes */
+
+	if (scsi_is_sdev_device(dev))
+		err = pm_schedule_suspend(dev, 100);
+	else
+		err = pm_runtime_suspend(dev);
+	return err;
+}
+
+int scsi_autopm_get_device(struct scsi_device *sdev)
+{
+	int	err;
+
+	err = pm_runtime_get_sync(&sdev->sdev_gendev);
+	if (err < 0)
+		pm_runtime_put_sync(&sdev->sdev_gendev);
+	else if (err > 0)
+		err = 0;
+	return err;
+}
+EXPORT_SYMBOL_GPL(scsi_autopm_get_device);
+
+void scsi_autopm_put_device(struct scsi_device *sdev)
+{
+	pm_runtime_put_sync(&sdev->sdev_gendev);
+}
+EXPORT_SYMBOL_GPL(scsi_autopm_put_device);
+
+void scsi_autopm_get_target(struct scsi_target *starget)
+{
+	pm_runtime_get_sync(&starget->dev);
+}
+
+void scsi_autopm_put_target(struct scsi_target *starget)
+{
+	pm_runtime_put_sync(&starget->dev);
+}
+
+int scsi_autopm_get_host(struct Scsi_Host *shost)
+{
+	int	err;
+
+	err = pm_runtime_get_sync(&shost->shost_gendev);
+	if (err < 0)
+		pm_runtime_put_sync(&shost->shost_gendev);
+	else if (err > 0)
+		err = 0;
+	return err;
+}
+
+void scsi_autopm_put_host(struct Scsi_Host *shost)
+{
+	pm_runtime_put_sync(&shost->shost_gendev);
+}
+
+#else
+
+#define scsi_runtime_suspend	NULL
+#define scsi_runtime_resume	NULL
+#define scsi_runtime_idle	NULL
+
+#endif /* CONFIG_PM_RUNTIME */
+
 const struct dev_pm_ops scsi_bus_pm_ops = {
 	.suspend =		scsi_bus_suspend,
 	.resume =		scsi_bus_resume_common,
@@ -93,4 +200,7 @@ struct dev_pm_ops scsi_bus_pm_ops = {
 	.thaw =			scsi_bus_resume_common,
 	.poweroff =		scsi_bus_poweroff,
 	.restore =		scsi_bus_resume_common,
+	.runtime_suspend =	scsi_runtime_suspend,
+	.runtime_resume =	scsi_runtime_resume,
+	.runtime_idle =		scsi_runtime_idle,
 };
Index: usb-2.6/drivers/scsi/hosts.c
===================================================================
--- usb-2.6.orig/drivers/scsi/hosts.c
+++ usb-2.6/drivers/scsi/hosts.c
@@ -32,6 +32,7 @@
 #include <linux/completion.h>
 #include <linux/transport_class.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
@@ -156,6 +157,7 @@ EXPORT_SYMBOL(scsi_host_set_state);
 void scsi_remove_host(struct Scsi_Host *shost)
 {
 	unsigned long flags;
+
 	mutex_lock(&shost->scan_mutex);
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (scsi_host_set_state(shost, SHOST_CANCEL))
@@ -165,6 +167,8 @@ void scsi_remove_host(struct Scsi_Host *
 			return;
 		}
 	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	scsi_autopm_get_host(shost);
 	scsi_forget_host(shost);
 	mutex_unlock(&shost->scan_mutex);
 	scsi_proc_host_rm(shost);
@@ -216,12 +220,14 @@ int scsi_add_host_with_dma(struct Scsi_H
 		shost->shost_gendev.parent = dev ? dev : &platform_bus;
 	shost->dma_dev = dma_dev;
 
-	device_enable_async_suspend(&shost->shost_gendev);
-
 	error = device_add(&shost->shost_gendev);
 	if (error)
 		goto out;
 
+	pm_runtime_set_active(&shost->shost_gendev);
+	pm_runtime_enable(&shost->shost_gendev);
+	device_enable_async_suspend(&shost->shost_gendev);
+
 	scsi_host_set_state(shost, SHOST_RUNNING);
 	get_device(shost->shost_gendev.parent);
 
Index: usb-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_sysfs.c
+++ usb-2.6/drivers/scsi/scsi_sysfs.c
@@ -11,6 +11,7 @@
 #include <linux/init.h>
 #include <linux/blkdev.h>
 #include <linux/device.h>
+#include <linux/pm_runtime.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -803,8 +804,6 @@ static int scsi_target_add(struct scsi_t
 	if (starget->state != STARGET_CREATED)
 		return 0;
 
-	device_enable_async_suspend(&starget->dev);
-
 	error = device_add(&starget->dev);
 	if (error) {
 		dev_err(&starget->dev, "target device_add failed, error %d\n", error);
@@ -813,6 +812,10 @@ static int scsi_target_add(struct scsi_t
 	transport_add_device(&starget->dev);
 	starget->state = STARGET_RUNNING;
 
+	pm_runtime_set_active(&starget->dev);
+	pm_runtime_enable(&starget->dev);
+	device_enable_async_suspend(&starget->dev);
+
 	return 0;
 }
 
@@ -842,7 +845,20 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 		return error;
 
 	transport_configure_device(&starget->dev);
+
 	device_enable_async_suspend(&sdev->sdev_gendev);
+	scsi_autopm_get_target(starget);
+	pm_runtime_set_active(&sdev->sdev_gendev);
+	pm_runtime_forbid(&sdev->sdev_gendev);
+	pm_runtime_enable(&sdev->sdev_gendev);
+	scsi_autopm_put_target(starget);
+
+	/* The following call will keep sdev active indefinitely, until
+	 * its driver does a corresponding scsi_autopm_pm_device().  Only
+	 * drivers supporting autosuspend will do this.
+	 */
+	scsi_autopm_get_device(sdev);
+
 	error = device_add(&sdev->sdev_gendev);
 	if (error) {
 		sdev_printk(KERN_INFO, sdev,
Index: usb-2.6/drivers/scsi/scsi_error.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_error.c
+++ usb-2.6/drivers/scsi/scsi_error.c
@@ -1765,6 +1765,14 @@ int scsi_error_handler(void *data)
 		 * what we need to do to get it up and online again (if we can).
 		 * If we fail, we end up taking the thing offline.
 		 */
+		if (scsi_autopm_get_host(shost) != 0) {
+			SCSI_LOG_ERROR_RECOVERY(1,
+				printk(KERN_ERR "Error handler scsi_eh_%d "
+						"unable to autoresume\n",
+						shost->host_no));
+			continue;
+		}
+
 		if (shost->transportt->eh_strategy_handler)
 			shost->transportt->eh_strategy_handler(shost);
 		else
@@ -1778,6 +1786,8 @@ int scsi_error_handler(void *data)
 		 * which are still online.
 		 */
 		scsi_restart_operations(shost);
+
+		scsi_autopm_put_host(shost);
 	}
 
 	SCSI_LOG_ERROR_RECOVERY(1,
@@ -1873,12 +1883,16 @@ scsi_reset_provider_done_command(struct 
 int
 scsi_reset_provider(struct scsi_device *dev, int flag)
 {
-	struct scsi_cmnd *scmd = scsi_get_command(dev, GFP_KERNEL);
+	struct scsi_cmnd *scmd;
 	struct Scsi_Host *shost = dev->host;
 	struct request req;
 	unsigned long flags;
 	int rtn;
 
+	if (scsi_autopm_get_host(shost) < 0)
+		return FAILED;
+
+	scmd = scsi_get_command(dev, GFP_KERNEL);
 	blk_rq_init(NULL, &req);
 	scmd->request = &req;
 
@@ -1935,6 +1949,7 @@ scsi_reset_provider(struct scsi_device *
 	scsi_run_host_queues(shost);
 
 	scsi_next_command(scmd);
+	scsi_autopm_put_host(shost);
 	return rtn;
 }
 EXPORT_SYMBOL(scsi_reset_provider);
Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -1521,14 +1521,18 @@ struct scsi_device *__scsi_add_device(st
 	starget = scsi_alloc_target(parent, channel, id);
 	if (!starget)
 		return ERR_PTR(-ENOMEM);
+	scsi_autopm_get_target(starget);
 
 	mutex_lock(&shost->scan_mutex);
 	if (!shost->async_scan)
 		scsi_complete_async_scans();
 
-	if (scsi_host_scan_allowed(shost))
+	if (scsi_host_scan_allowed(shost) && scsi_autopm_get_host(shost) == 0) {
 		scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1, hostdata);
+		scsi_autopm_put_host(shost);
+	}
 	mutex_unlock(&shost->scan_mutex);
+	scsi_autopm_put_target(starget);
 	scsi_target_reap(starget);
 	put_device(&starget->dev);
 
@@ -1582,6 +1586,7 @@ static void __scsi_scan_target(struct de
 	starget = scsi_alloc_target(parent, channel, id);
 	if (!starget)
 		return;
+	scsi_autopm_get_target(starget);
 
 	if (lun != SCAN_WILD_CARD) {
 		/*
@@ -1607,6 +1612,7 @@ static void __scsi_scan_target(struct de
 	}
 
  out_reap:
+	scsi_autopm_put_target(starget);
 	/* now determine if the target has any children at all
 	 * and if not, nuke it */
 	scsi_target_reap(starget);
@@ -1641,8 +1647,10 @@ void scsi_scan_target(struct device *par
 	if (!shost->async_scan)
 		scsi_complete_async_scans();
 
-	if (scsi_host_scan_allowed(shost))
+	if (scsi_host_scan_allowed(shost) && scsi_autopm_get_host(shost) == 0) {
 		__scsi_scan_target(parent, channel, id, lun, rescan);
+		scsi_autopm_put_host(shost);
+	}
 	mutex_unlock(&shost->scan_mutex);
 }
 EXPORT_SYMBOL(scsi_scan_target);
@@ -1694,7 +1702,7 @@ int scsi_scan_host_selected(struct Scsi_
 	if (!shost->async_scan)
 		scsi_complete_async_scans();
 
-	if (scsi_host_scan_allowed(shost)) {
+	if (scsi_host_scan_allowed(shost) && scsi_autopm_get_host(shost) == 0) {
 		if (channel == SCAN_WILD_CARD)
 			for (channel = 0; channel <= shost->max_channel;
 			     channel++)
@@ -1702,6 +1710,7 @@ int scsi_scan_host_selected(struct Scsi_
 						  rescan);
 		else
 			scsi_scan_channel(shost, channel, id, lun, rescan);
+		scsi_autopm_put_host(shost);
 	}
 	mutex_unlock(&shost->scan_mutex);
 
@@ -1839,8 +1848,11 @@ static void do_scsi_scan_host(struct Scs
 static int do_scan_async(void *_data)
 {
 	struct async_scan_data *data = _data;
-	do_scsi_scan_host(data->shost);
+	struct Scsi_Host *shost = data->shost;
+
+	do_scsi_scan_host(shost);
 	scsi_finish_async_scan(data);
+	scsi_autopm_put_host(shost);
 	return 0;
 }
 
@@ -1855,16 +1867,20 @@ void scsi_scan_host(struct Scsi_Host *sh
 
 	if (strncmp(scsi_scan_type, "none", 4) == 0)
 		return;
+	if (scsi_autopm_get_host(shost) < 0)
+		return;
 
 	data = scsi_prep_async_scan(shost);
 	if (!data) {
 		do_scsi_scan_host(shost);
+		scsi_autopm_put_host(shost);
 		return;
 	}
 
 	p = kthread_run(do_scan_async, data, "scsi_scan_%d", shost->host_no);
 	if (IS_ERR(p))
 		do_scan_async(data);
+	/* scsi_autopm_put_host(shost) is called in do_scan_async() */
 }
 EXPORT_SYMBOL(scsi_scan_host);
 
Index: usb-2.6/drivers/scsi/sg.c
===================================================================
--- usb-2.6.orig/drivers/scsi/sg.c
+++ usb-2.6/drivers/scsi/sg.c
@@ -245,6 +245,10 @@ sg_open(struct inode *inode, struct file
 	if (retval)
 		goto sg_put;
 
+	retval = scsi_autopm_get_device(sdp->device);
+	if (retval)
+		goto sdp_put;
+
 	if (!((flags & O_NONBLOCK) ||
 	      scsi_block_when_processing_errors(sdp->device))) {
 		retval = -ENXIO;
@@ -302,8 +306,11 @@ sg_open(struct inode *inode, struct file
 	}
 	retval = 0;
 error_out:
-	if (retval)
+	if (retval) {
+		scsi_autopm_put_device(sdp->device);
+sdp_put:
 		scsi_device_put(sdp->device);
+	}
 sg_put:
 	if (sdp)
 		sg_put_dev(sdp);
@@ -327,6 +334,7 @@ sg_release(struct inode *inode, struct f
 	sdp->exclude = 0;
 	wake_up_interruptible(&sdp->o_excl_wait);
 
+	scsi_autopm_put_device(sdp->device);
 	kref_put(&sfp->f_ref, sg_remove_sfp);
 	return 0;
 }

