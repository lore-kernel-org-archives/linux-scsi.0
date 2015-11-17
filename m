From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2] Separate target visibility from reaped state information
Date: Mon, 16 Nov 2015 16:18:41 -0800
Message-ID: <564A7261.7040403@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0091.outbound.protection.outlook.com ([157.56.111.91]:23608
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751342AbbKQASr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Nov 2015 19:18:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Dan Williams <dan.j.williams@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Instead of representing the states "visible in sysfs" and
"has been removed from the target list" by a single state
variable, use two variables to represent this information.

This patch avoids that SCSI device removal can trigger a
soft lockup.

See also:
* "scsi: restart list search after unlock in scsi_remove_target"
  (commit 40998193560d).
* "scsi_remove_target: fix softlockup regression on hot remove"
  (commit bc3f02a795d3).

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: stable <stable@vger.kernel.org>
---
 drivers/scsi/scsi_scan.c   | 31 +++----------------------------
 drivers/scsi/scsi_sysfs.c  |  7 ++++---
 include/scsi/scsi_device.h |  9 ++-------
 3 files changed, 9 insertions(+), 38 deletions(-)


Changes compared to v1:
- Renamed "visible" into "is_visible" for consistency with the rest of the
  SCSI initiator code.
- Removed the scsi_target_state since it is no longer used.

This patch has been tested on top of kernel v4.4-rc1 with the SRP initiator
driver.


diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 8324539..6accec3 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -314,7 +314,6 @@ static void scsi_target_destroy(struct scsi_target *starget)
 	struct Scsi_Host *shost = dev_to_shost(dev->parent);
 	unsigned long flags;
 
-	starget->state = STARGET_DEL;
 	transport_destroy_device(dev);
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (shost->hostt->target_destroy)
@@ -379,19 +378,15 @@ static void scsi_target_reap_ref_release(struct kref *kref)
 	struct scsi_target *starget
 		= container_of(kref, struct scsi_target, reap_ref);
 
-	/*
-	 * if we get here and the target is still in the CREATED state that
-	 * means it was allocated but never made visible (because a scan
-	 * turned up no LUNs), so don't call device_del() on it.
-	 */
-	if (starget->state != STARGET_CREATED) {
+	if (starget->is_visible) {
+		starget->is_visible = false;
 		transport_remove_device(&starget->dev);
 		device_del(&starget->dev);
 	}
 	scsi_target_destroy(starget);
 }
 
-static void scsi_target_reap_ref_put(struct scsi_target *starget)
+void scsi_target_reap(struct scsi_target *starget)
 {
 	kref_put(&starget->reap_ref, scsi_target_reap_ref_release);
 }
@@ -437,7 +432,6 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	starget->can_queue = 0;
 	INIT_LIST_HEAD(&starget->siblings);
 	INIT_LIST_HEAD(&starget->devices);
-	starget->state = STARGET_CREATED;
 	starget->scsi_level = SCSI_2;
 	starget->max_target_blocked = SCSI_DEFAULT_TARGET_BLOCKED;
  retry:
@@ -498,25 +492,6 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 }
 
 /**
- * scsi_target_reap - check to see if target is in use and destroy if not
- * @starget: target to be checked
- *
- * This is used after removing a LUN or doing a last put of the target
- * it checks atomically that nothing is using the target and removes
- * it if so.
- */
-void scsi_target_reap(struct scsi_target *starget)
-{
-	/*
-	 * serious problem if this triggers: STARGET_DEL is only set in the if
-	 * the reap_ref drops to zero, so we're trying to do another final put
-	 * on an already released kref
-	 */
-	BUG_ON(starget->state == STARGET_DEL);
-	scsi_target_reap_ref_put(starget);
-}
-
-/**
  * sanitize_inquiry_string - remove non-graphical chars from an INQUIRY result string
  * @s: INQUIRY result string to sanitize
  * @len: length of the string
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 8d23122..c5ea634 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1000,7 +1000,7 @@ static int scsi_target_add(struct scsi_target *starget)
 {
 	int error;
 
-	if (starget->state != STARGET_CREATED)
+	if (starget->is_visible)
 		return 0;
 
 	error = device_add(&starget->dev);
@@ -1009,7 +1009,7 @@ static int scsi_target_add(struct scsi_target *starget)
 		return error;
 	}
 	transport_add_device(&starget->dev);
-	starget->state = STARGET_RUNNING;
+	starget->is_visible = true;
 
 	pm_runtime_set_active(&starget->dev);
 	pm_runtime_enable(&starget->dev);
@@ -1198,10 +1198,11 @@ void scsi_remove_target(struct device *dev)
 restart:
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_for_each_entry(starget, &shost->__targets, siblings) {
-		if (starget->state == STARGET_DEL)
+		if (starget->reaped)
 			continue;
 		if (starget->dev.parent == dev || &starget->dev == dev) {
 			kref_get(&starget->reap_ref);
+			starget->reaped = true;
 			spin_unlock_irqrestore(shost->host_lock, flags);
 			__scsi_remove_target(starget);
 			scsi_target_reap(starget);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index fe89d7c..f11c794 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -236,12 +236,6 @@ scmd_printk(const char *, const struct scsi_cmnd *, const char *, ...);
 			sdev_dbg((scmd)->device, fmt, ##a);		   \
 	} while (0)
 
-enum scsi_target_state {
-	STARGET_CREATED = 1,
-	STARGET_RUNNING,
-	STARGET_DEL,
-};
-
 /*
  * scsi_target: representation of a scsi target, for now, this is only
  * used for single_lun devices. If no one has active IO to the target,
@@ -267,6 +261,8 @@ struct scsi_target {
 	unsigned int		expecting_lun_change:1;	/* A device has reported
 						 * a 3F/0E UA, other devices on
 						 * the same target will also. */
+	unsigned int		is_visible:1; /* visible in sysfs */
+	unsigned int		reaped:1; /* removed from target list */
 	/* commands actually active on LLD. */
 	atomic_t		target_busy;
 	atomic_t		target_blocked;
@@ -280,7 +276,6 @@ struct scsi_target {
 #define SCSI_DEFAULT_TARGET_BLOCKED	3
 
 	char			scsi_level;
-	enum scsi_target_state	state;
 	void 			*hostdata; /* available to low-level driver */
 	unsigned long		starget_data[0]; /* for the transport */
 	/* starget_data must be the last element!!!! */
-- 
2.1.4

