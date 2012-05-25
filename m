From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC PATCH] scsi: fix hot unplug vs async scan race
Date: Fri, 25 May 2012 00:55:48 -0700
Message-ID: <20120525075352.27883.81838.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20903 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293Ab2EYHjq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 May 2012 03:39:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com

The following crash results from cases where the end_device has been
removed before scsi_sysfs_add_sdev has had a chance to run.

 BUG: unable to handle kernel NULL pointer dereference at 0000000000000098
 IP: [<ffffffff8115e100>] sysfs_create_dir+0x32/0xb6
 ...
 Call Trace:
  [<ffffffff8125e4a8>] kobject_add_internal+0x120/0x1e3
  [<ffffffff81075149>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff8125e641>] kobject_add_varg+0x41/0x50
  [<ffffffff8125e70b>] kobject_add+0x64/0x66
  [<ffffffff8131122b>] device_add+0x12d/0x63a
  [<ffffffff814b65ea>] ? _raw_spin_unlock_irqrestore+0x47/0x56
  [<ffffffff8107de15>] ? module_refcount+0x89/0xa0
  [<ffffffff8132f348>] scsi_sysfs_add_sdev+0x4e/0x28a
  [<ffffffff8132dcbb>] do_scan_async+0x9c/0x145

...teach scsi_sysfs_add_devices to check for deleted device before
trying to add them.

This teaches scsi_transport_sas to bypass scsi_remove_target() since it
is unable to find the target from the end_device rphy since
device_for_each_child() relies on the target device having gone through
a device_add().

Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Robert Love <robert.w.love@intel.com>
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
Cc: Kashyap Desai <kashyap.desai@lsi.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: <stable@vger.kernel.org>
[stable: v2.6.20+]
Reported-by: Dariusz Majchrzak <dariusz.majchrzak@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

This is larger than I would like, but could not think of better way to
retrieve the starget from the transport device.  Other ideas?

--
Dan


 drivers/scsi/scsi_scan.c          |   24 ++++++++++++++++--------
 drivers/scsi/scsi_sysfs.c         |   15 ++++++++++++++-
 drivers/scsi/scsi_transport_sas.c |    5 +++--
 include/scsi/scsi_device.h        |    5 +++--
 include/scsi/scsi_transport_sas.h |    1 +
 5 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 01b0374..5e00e09 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1562,8 +1562,8 @@ void scsi_rescan_device(struct device *dev)
 }
 EXPORT_SYMBOL(scsi_rescan_device);
 
-static void __scsi_scan_target(struct device *parent, unsigned int channel,
-		unsigned int id, unsigned int lun, int rescan)
+static struct scsi_target *__scsi_scan_target(struct device *parent, unsigned int channel,
+					      unsigned int id, unsigned int lun, int rescan)
 {
 	struct Scsi_Host *shost = dev_to_shost(parent);
 	int bflags = 0;
@@ -1574,11 +1574,11 @@ static void __scsi_scan_target(struct device *parent, unsigned int channel,
 		/*
 		 * Don't scan the host adapter
 		 */
-		return;
+		return NULL;
 
 	starget = scsi_alloc_target(parent, channel, id);
 	if (!starget)
-		return;
+		return NULL;
 	scsi_autopm_get_target(starget);
 
 	if (lun != SCAN_WILD_CARD) {
@@ -1611,6 +1611,8 @@ static void __scsi_scan_target(struct device *parent, unsigned int channel,
 	scsi_target_reap(starget);
 
 	put_device(&starget->dev);
+
+	return starget;
 }
 
 /**
@@ -1628,23 +1630,26 @@ static void __scsi_scan_target(struct device *parent, unsigned int channel,
  *     First try a REPORT LUN scan, if that does not scan the target, do a
  *     sequential scan of LUNs on the target id.
  **/
-void scsi_scan_target(struct device *parent, unsigned int channel,
-		      unsigned int id, unsigned int lun, int rescan)
+struct scsi_target *scsi_scan_target(struct device *parent, unsigned int channel,
+				     unsigned int id, unsigned int lun, int rescan)
 {
 	struct Scsi_Host *shost = dev_to_shost(parent);
+	struct scsi_target *starget = NULL;
 
 	if (strncmp(scsi_scan_type, "none", 4) == 0)
-		return;
+		return NULL;
 
 	mutex_lock(&shost->scan_mutex);
 	if (!shost->async_scan)
 		scsi_complete_async_scans();
 
 	if (scsi_host_scan_allowed(shost) && scsi_autopm_get_host(shost) == 0) {
-		__scsi_scan_target(parent, channel, id, lun, rescan);
+		starget = __scsi_scan_target(parent, channel, id, lun, rescan);
 		scsi_autopm_put_host(shost);
 	}
 	mutex_unlock(&shost->scan_mutex);
+
+	return starget;
 }
 EXPORT_SYMBOL(scsi_scan_target);
 
@@ -1714,6 +1719,9 @@ static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
 {
 	struct scsi_device *sdev;
 	shost_for_each_device(sdev, shost) {
+		/* target removed before the device could be added */
+		if (sdev->sdev_state == SDEV_DEL)
+			continue;
 		if (!scsi_host_scan_allowed(shost) ||
 		    scsi_sysfs_add_sdev(sdev) != 0)
 			__scsi_remove_device(sdev);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 04c2a27..d1293b6 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -993,12 +993,24 @@ void scsi_remove_device(struct scsi_device *sdev)
 }
 EXPORT_SYMBOL(scsi_remove_device);
 
-static void __scsi_remove_target(struct scsi_target *starget)
+/**
+ * __scsi_remove_target - explicitly remove a target
+ * @starget: specific target to be removed
+ *
+ * This allows a target to be removed regardless of whether it has been
+ * async scanned or not.  scsi_remove_target() depends on
+ * device_for_each_child() and will not enumerate children that have not
+ * been through device_add() yet.
+ */
+void __scsi_remove_target(struct scsi_target *starget)
 {
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	unsigned long flags;
 	struct scsi_device *sdev;
 
+	if (!starget)
+		return;
+
 	spin_lock_irqsave(shost->host_lock, flags);
 	starget->reap_ref++;
  restart:
@@ -1016,6 +1028,7 @@ static void __scsi_remove_target(struct scsi_target *starget)
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	scsi_target_reap(starget);
 }
+EXPORT_SYMBOL_GPL(__scsi_remove_target);
 
 static int __remove_child (struct device * dev, void * data)
 {
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index f7565fc..3afb38d 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1592,7 +1592,7 @@ int sas_rphy_add(struct sas_rphy *rphy)
 		else
 			lun = 0;
 
-		scsi_scan_target(&rphy->dev, 0, rphy->scsi_target_id, lun, 0);
+		rphy->starget = scsi_scan_target(&rphy->dev, 0, rphy->scsi_target_id, lun, 0);
 	}
 
 	return 0;
@@ -1669,7 +1669,8 @@ sas_rphy_remove(struct sas_rphy *rphy)
 
 	switch (rphy->identify.device_type) {
 	case SAS_END_DEVICE:
-		scsi_remove_target(dev);
+		__scsi_remove_target(rphy->starget);
+		rphy->starget = NULL;
 		break;
 	case SAS_EDGE_EXPANDER_DEVICE:
 	case SAS_FANOUT_EXPANDER_DEVICE:
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 6efb2e1..7cd0d75 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -368,12 +368,13 @@ extern int scsi_device_quiesce(struct scsi_device *sdev);
 extern void scsi_device_resume(struct scsi_device *sdev);
 extern void scsi_target_quiesce(struct scsi_target *);
 extern void scsi_target_resume(struct scsi_target *);
-extern void scsi_scan_target(struct device *parent, unsigned int channel,
-			     unsigned int id, unsigned int lun, int rescan);
+extern struct scsi_target *scsi_scan_target(struct device *parent, unsigned int channel,
+					    unsigned int id, unsigned int lun, int rescan);
 extern void scsi_target_reap(struct scsi_target *);
 extern void scsi_target_block(struct device *);
 extern void scsi_target_unblock(struct device *);
 extern void scsi_remove_target(struct device *);
+extern void __scsi_remove_target(struct scsi_target *starget);
 extern void int_to_scsilun(unsigned int, struct scsi_lun *);
 extern int scsilun_to_int(struct scsi_lun *);
 extern const char *scsi_device_state_name(enum scsi_device_state);
diff --git a/include/scsi/scsi_transport_sas.h b/include/scsi/scsi_transport_sas.h
index 98b3a20..d98dcef 100644
--- a/include/scsi/scsi_transport_sas.h
+++ b/include/scsi/scsi_transport_sas.h
@@ -93,6 +93,7 @@ struct sas_rphy {
 	struct list_head	list;
 	struct request_queue	*q;
 	u32			scsi_target_id;
+	struct scsi_target	*starget;
 };
 
 #define dev_to_rphy(d) \

