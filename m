From: Tejun Heo <teheo@suse.de>
Subject: Re: [PATCH 2/2] scsi: don't use execute_in_process_context()
Date: Wed, 15 Dec 2010 20:34:31 +0100
Message-ID: <4D091847.2030201@suse.de>
References: <4CBD95C0.6060302@kernel.org>  <4CBD95DC.8000001@kernel.org>	 <1292194113.2989.9.camel@mulgrave.site>  <4D073E9A.3000608@kernel.org>	 <1292335754.3058.2.camel@mulgrave.site>  <4D077CD9.6050907@kernel.org>	 <1292336798.3058.5.camel@mulgrave.site>  <4D078052.3040800@kernel.org>	 <1292382245.19511.56.camel@mulgrave.site>  <4D08E2FF.5090605@kernel.org>	 <1292428486.4688.180.camel@mulgrave.site>  <4D08E624.3020808@kernel.org>	 <1292433773.4688.278.camel@mulgrave.site>  <4D09116C.6010508@kernel.org> <1292440246.4688.416.camel@mulgrave.site> <4D0914B5.20208@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [130.75.117.88] ([130.75.117.88]:47772 "EHLO htj.dyndns.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753299Ab0LOTok (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Dec 2010 14:44:40 -0500
In-Reply-To: <4D0914B5.20208@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, lkml <linux-kernel@vger.kernel.org>

On 12/15/2010 08:19 PM, Tejun Heo wrote:
> Given that the structures containing the work items are dynamically
> allocated, I would introduce a scsi_wq, unconditionally schedule
> release works on them and flush them before unloading.  Please note
> that workqueues no longer require dedicated threads, so it's quite
> cheap.

So, something like the following.

---
 drivers/scsi/scsi.c        |   15 +++++++++++++--
 drivers/scsi/scsi_scan.c   |   26 +++++++++++++-------------
 drivers/scsi/scsi_sysfs.c  |    8 +++++---
 include/scsi/scsi_device.h |    6 ++++--
 4 files changed, 35 insertions(+), 20 deletions(-)

Index: work/drivers/scsi/scsi_scan.c
===================================================================
--- work.orig/drivers/scsi/scsi_scan.c
+++ work/drivers/scsi/scsi_scan.c
@@ -362,6 +362,16 @@ int scsi_is_target_device(const struct d
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
@@ -427,6 +437,7 @@ static struct scsi_target *scsi_alloc_ta
 	starget->state = STARGET_CREATED;
 	starget->scsi_level = SCSI_2;
 	starget->max_target_blocked = SCSI_DEFAULT_TARGET_BLOCKED;
+	INIT_WORK(&starget->reap_work, scsi_target_reap_usercontext);
  retry:
 	spin_lock_irqsave(shost->host_lock, flags);

@@ -462,21 +473,11 @@ static struct scsi_target *scsi_alloc_ta
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
@@ -507,8 +508,7 @@ void scsi_target_reap(struct scsi_target
 	if (state == STARGET_CREATED)
 		scsi_target_destroy(starget);
 	else
-		execute_in_process_context(scsi_target_reap_usercontext,
-					   &starget->ew);
+		queue_work(scsi_wq, &starget->reap_work);
 }

 /**
Index: work/drivers/scsi/scsi_sysfs.c
===================================================================
--- work.orig/drivers/scsi/scsi_sysfs.c
+++ work/drivers/scsi/scsi_sysfs.c
@@ -300,7 +300,7 @@ static void scsi_device_dev_release_user
 	struct list_head *this, *tmp;
 	unsigned long flags;

-	sdev = container_of(work, struct scsi_device, ew.work);
+	sdev = container_of(work, struct scsi_device, release_work);

 	parent = sdev->sdev_gendev.parent;
 	starget = to_scsi_target(parent);
@@ -343,8 +343,8 @@ static void scsi_device_dev_release_user
 static void scsi_device_dev_release(struct device *dev)
 {
 	struct scsi_device *sdp = to_scsi_device(dev);
-	execute_in_process_context(scsi_device_dev_release_usercontext,
-				   &sdp->ew);
+
+	queue_work(scsi_wq, &sdp->release_work);
 }

 static struct class sdev_class = {
@@ -1069,6 +1069,8 @@ void scsi_sysfs_device_initialize(struct
 	dev_set_name(&sdev->sdev_dev, "%d:%d:%d:%d",
 		     sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
 	sdev->scsi_level = starget->scsi_level;
+	INIT_WORK(&sdev->release_work, scsi_device_dev_release_usercontext);
+
 	transport_setup_device(&sdev->sdev_gendev);
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_add_tail(&sdev->same_target_siblings, &starget->devices);
Index: work/include/scsi/scsi_device.h
===================================================================
--- work.orig/include/scsi/scsi_device.h
+++ work/include/scsi/scsi_device.h
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
@@ -276,6 +276,8 @@ static inline struct scsi_target *scsi_t
 #define starget_printk(prefix, starget, fmt, a...)	\
 	dev_printk(prefix, &(starget)->dev, fmt, ##a)

+extern struct workqueue_struct *scsi_wq;
+
 extern struct scsi_device *__scsi_add_device(struct Scsi_Host *,
 		uint, uint, uint, void *hostdata);
 extern int scsi_add_device(struct Scsi_Host *host, uint channel,
Index: work/drivers/scsi/scsi.c
===================================================================
--- work.orig/drivers/scsi/scsi.c
+++ work/drivers/scsi/scsi.c
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
@@ -1306,11 +1311,14 @@ MODULE_PARM_DESC(scsi_logging_level, "a

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
