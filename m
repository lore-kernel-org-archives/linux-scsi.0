From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/2] scsi: don't use execute_in_process_context()
Date: Tue, 19 Oct 2010 14:58:04 +0200
Message-ID: <4CBD95DC.8000001@kernel.org>
References: <4CBD95C0.6060302@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:47366 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756664Ab0JSM6T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Oct 2010 08:58:19 -0400
In-Reply-To: <4CBD95C0.6060302@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, lkml <linux-kernel@vger.kernel.org>

SCSI is the only subsystem which uses execute_in_process_context().
With the recent workqueue updates, unconditionally using work wouldn't
cause deadlocks around execution resources and the two places where
SCSI uses them are cold paths where using work unconditionally
wouldn't make any difference.  Drop execute_in_process_context() and
use work directly.

* scsi_device->ew is replaced with release_work.  scsi_target->ew is
  replaced with reap_work.

* Both works are initialized with the respective release/reap function
  during device/target init.  scsi_target_reap_usercontext() is moved
  upwards to avoid needing forward declaration.

* scsi_alloc_target() now explicitly flushes the reap_work of the
  found dying target before putting it instead of depending on
  flush_scheduled_work().

This is in preparation of deprecation of flush_scheduled_work() and
execute_in_process_context().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/scsi/scsi_scan.c   |   26 +++++++++++++-------------
 drivers/scsi/scsi_sysfs.c  |    8 +++++---
 include/scsi/scsi_device.h |    4 ++--
 3 files changed, 20 insertions(+), 18 deletions(-)

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
@@ -429,6 +439,7 @@ static struct scsi_target *scsi_alloc_ta
 	starget->state = STARGET_CREATED;
 	starget->scsi_level = SCSI_2;
 	starget->max_target_blocked = SCSI_DEFAULT_TARGET_BLOCKED;
+	INIT_WORK(&starget->reap_work, scsi_target_reap_usercontext);
  retry:
 	spin_lock_irqsave(shost->host_lock, flags);

@@ -464,21 +475,11 @@ static struct scsi_target *scsi_alloc_ta
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
@@ -509,8 +510,7 @@ void scsi_target_reap(struct scsi_target
 	if (state == STARGET_CREATED)
 		scsi_target_destroy(starget);
 	else
-		execute_in_process_context(scsi_target_reap_usercontext,
-					   &starget->ew);
+		schedule_work(&starget->reap_work);
 }

 /**
Index: work/drivers/scsi/scsi_sysfs.c
===================================================================
--- work.orig/drivers/scsi/scsi_sysfs.c
+++ work/drivers/scsi/scsi_sysfs.c
@@ -298,7 +298,7 @@ static void scsi_device_dev_release_user
 	struct list_head *this, *tmp;
 	unsigned long flags;

-	sdev = container_of(work, struct scsi_device, ew.work);
+	sdev = container_of(work, struct scsi_device, release_work);

 	parent = sdev->sdev_gendev.parent;
 	starget = to_scsi_target(parent);
@@ -341,8 +341,8 @@ static void scsi_device_dev_release_user
 static void scsi_device_dev_release(struct device *dev)
 {
 	struct scsi_device *sdp = to_scsi_device(dev);
-	execute_in_process_context(scsi_device_dev_release_usercontext,
-				   &sdp->ew);
+
+	schedule_work(&sdp->release_work);
 }

 static struct class sdev_class = {
@@ -1066,6 +1066,8 @@ void scsi_sysfs_device_initialize(struct
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
@@ -166,7 +166,7 @@ struct scsi_device {
 	struct device		sdev_gendev,
 				sdev_dev;

-	struct execute_work	ew; /* used to get process context on put */
+	struct work_struct	release_work; /* for process context on put */

 	struct scsi_dh_data	*scsi_dh_data;
 	enum scsi_device_state sdev_state;
@@ -256,7 +256,7 @@ struct scsi_target {
 #define SCSI_DEFAULT_TARGET_BLOCKED	3

 	char			scsi_level;
-	struct execute_work	ew;
+	struct work_struct	reap_work;
 	enum scsi_target_state	state;
 	void 			*hostdata; /* available to low-level driver */
 	unsigned long		starget_data[0]; /* for the transport */
