From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/6] scsi: don't use execute_in_process_context()
Date: Tue, 21 Dec 2010 16:02:01 +0100
Message-ID: <1292943721-4519-7-git-send-email-tj@kernel.org>
References: <1292943721-4519-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f45.google.com ([209.85.214.45]:55293 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab0LUPCT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Dec 2010 10:02:19 -0500
In-Reply-To: <1292943721-4519-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, Eric.Moore@lsi.com, dgilbert@interlog.com
Cc: Tejun Heo <tj@kernel.org>

SCSI is the only subsystem which uses execute_in_process_context() and
its use is racy against module unload.  ie. the reap work is not
properly flushed and could still be running after the scsi module is
unloaded.

Although execute_in_process_context() can be more efficient when the
caller already has a context, in this case, the call sites are quite
cold and the difference is practically meaningless.  With commit
c8efcc25 (workqueue: allow chained queueing during destruction), the
race condition can easily be fixed by using a dedicated workqueue and
destroying it on module unload.

Create and use scsi_wq instead of execute_in_process_context().

* scsi_device->ew is replaced with release_work.  scsi_target->ew is
  replaced with reap_work.

* Both works are initialized with the respective release/reap function
  during device/target init.  scsi_target_reap_usercontext() is moved
  upwards to avoid needing forward declaration.

* scsi_alloc_target() now explicitly flushes the reap_work of the
  found dying target before putting it instead of depending on
  flush_scheduled_work().

For more info on the issues, please read the following thread.

 http://thread.gmane.org/gmane.linux.scsi/62923

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/scsi/scsi.c        |   15 +++++++++++++--
 drivers/scsi/scsi_scan.c   |   26 +++++++++++++-------------
 drivers/scsi/scsi_sysfs.c  |    8 +++++---
 include/scsi/scsi_device.h |    6 ++++--
 4 files changed, 35 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 2aeb2e9..12ebcbc 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -70,6 +70,11 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/scsi.h>
 
+/*
+ * Utility multithreaded workqueue for SCSI.
+ */
+struct workqueue_struct *scsi_wq;
+
 static void scsi_done(struct scsi_cmnd *cmd);
 
 /*
@@ -1306,11 +1311,14 @@ MODULE_PARM_DESC(scsi_logging_level, "a bit mask of logging levels");
 
 static int __init init_scsi(void)
 {
-	int error;
+	int error = -ENOMEM;
 
+	scsi_wq = alloc_workqueue("scsi", 0, 0);
+	if (!scsi_wq)
+		return error;
 	error = scsi_init_queue();
 	if (error)
-		return error;
+		goto cleanup_wq;
 	error = scsi_init_procfs();
 	if (error)
 		goto cleanup_queue;
@@ -1342,6 +1350,8 @@ cleanup_procfs:
 	scsi_exit_procfs();
 cleanup_queue:
 	scsi_exit_queue();
+cleanup_wq:
+	destroy_workqueue(scsi_wq);
 	printk(KERN_ERR "SCSI subsystem failed to initialize, error = %d\n",
 	       -error);
 	return error;
@@ -1356,6 +1366,7 @@ static void __exit exit_scsi(void)
 	scsi_exit_devinfo();
 	scsi_exit_procfs();
 	scsi_exit_queue();
+	destroy_workqueue(scsi_wq);
 }
 
 subsys_initcall(init_scsi);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 087821f..4222b58 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -362,6 +362,16 @@ int scsi_is_target_device(const struct device *dev)
 }
 EXPORT_SYMBOL(scsi_is_target_device);
 
+static void scsi_target_reap_usercontext(struct work_struct *work)
+{
+	struct scsi_target *starget =
+		container_of(work, struct scsi_target, reap_work);
+
+	transport_remove_device(&starget->dev);
+	device_del(&starget->dev);
+	scsi_target_destroy(starget);
+}
+
 static struct scsi_target *__scsi_find_target(struct device *parent,
 					      int channel, uint id)
 {
@@ -427,6 +437,7 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	starget->state = STARGET_CREATED;
 	starget->scsi_level = SCSI_2;
 	starget->max_target_blocked = SCSI_DEFAULT_TARGET_BLOCKED;
+	INIT_WORK(&starget->reap_work, scsi_target_reap_usercontext);
  retry:
 	spin_lock_irqsave(shost->host_lock, flags);
 
@@ -462,21 +473,11 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	}
 	/* Unfortunately, we found a dying target; need to
 	 * wait until it's dead before we can get a new one */
+	flush_work(&found_target->reap_work);
 	put_device(&found_target->dev);
-	flush_scheduled_work();
 	goto retry;
 }
 
-static void scsi_target_reap_usercontext(struct work_struct *work)
-{
-	struct scsi_target *starget =
-		container_of(work, struct scsi_target, ew.work);
-
-	transport_remove_device(&starget->dev);
-	device_del(&starget->dev);
-	scsi_target_destroy(starget);
-}
-
 /**
  * scsi_target_reap - check to see if target is in use and destroy if not
  * @starget: target to be checked
@@ -507,8 +508,7 @@ void scsi_target_reap(struct scsi_target *starget)
 	if (state == STARGET_CREATED)
 		scsi_target_destroy(starget);
 	else
-		execute_in_process_context(scsi_target_reap_usercontext,
-					   &starget->ew);
+		queue_work(scsi_wq, &starget->reap_work);
 }
 
 /**
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 76ee2e7..b0cae21 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -300,7 +300,7 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	struct list_head *this, *tmp;
 	unsigned long flags;
 
-	sdev = container_of(work, struct scsi_device, ew.work);
+	sdev = container_of(work, struct scsi_device, release_work);
 
 	parent = sdev->sdev_gendev.parent;
 	starget = to_scsi_target(parent);
@@ -343,8 +343,8 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 static void scsi_device_dev_release(struct device *dev)
 {
 	struct scsi_device *sdp = to_scsi_device(dev);
-	execute_in_process_context(scsi_device_dev_release_usercontext,
-				   &sdp->ew);
+
+	queue_work(scsi_wq, &sdp->release_work);
 }
 
 static struct class sdev_class = {
@@ -1069,6 +1069,8 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 	dev_set_name(&sdev->sdev_dev, "%d:%d:%d:%d",
 		     sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
 	sdev->scsi_level = starget->scsi_level;
+	INIT_WORK(&sdev->release_work, scsi_device_dev_release_usercontext);
+
 	transport_setup_device(&sdev->sdev_gendev);
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_add_tail(&sdev->same_target_siblings, &starget->devices);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 85867dc..64de831 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -168,7 +168,7 @@ struct scsi_device {
 	struct device		sdev_gendev,
 				sdev_dev;
 
-	struct execute_work	ew; /* used to get process context on put */
+	struct work_struct	release_work; /* for process context on put */
 
 	struct scsi_dh_data	*scsi_dh_data;
 	enum scsi_device_state sdev_state;
@@ -258,7 +258,7 @@ struct scsi_target {
 #define SCSI_DEFAULT_TARGET_BLOCKED	3
 
 	char			scsi_level;
-	struct execute_work	ew;
+	struct work_struct	reap_work;
 	enum scsi_target_state	state;
 	void 			*hostdata; /* available to low-level driver */
 	unsigned long		starget_data[0]; /* for the transport */
@@ -276,6 +276,8 @@ static inline struct scsi_target *scsi_target(struct scsi_device *sdev)
 #define starget_printk(prefix, starget, fmt, a...)	\
 	dev_printk(prefix, &(starget)->dev, fmt, ##a)
 
+extern struct workqueue_struct *scsi_wq;
+
 extern struct scsi_device *__scsi_add_device(struct Scsi_Host *,
 		uint, uint, uint, void *hostdata);
 extern int scsi_add_device(struct Scsi_Host *host, uint channel,
-- 
1.7.1

