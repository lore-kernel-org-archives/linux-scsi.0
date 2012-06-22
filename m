From: Dan Williams <dan.j.williams@intel.com>
Subject: [set5 PATCH 6/6] scsi: fix hot unplug vs async scan race
Date: Thu, 21 Jun 2012 23:47:28 -0700
Message-ID: <20120622064727.21538.26483.stgit@dwillia2-linux.jf.intel.com>
References: <20120622064657.21538.61711.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:60295 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761412Ab2FVGau (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jun 2012 02:30:50 -0400
In-Reply-To: <20120622064657.21538.61711.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, Kashyap Desai <kashyap.desai@lsi.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Dariusz Majchrzak <dariusz.majchrzak@intel.com>, Robert Love <robert.w.love@intel.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>

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

...teach scsi_sysfs_add_devices() to check for deleted devices() before
trying to add them, and teach scsi_remove_target() how to remove targets
that have not been added via device_add().

Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Robert Love <robert.w.love@intel.com>
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
Cc: Kashyap Desai <kashyap.desai@lsi.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: <stable@vger.kernel.org>
Reported-by: Dariusz Majchrzak <dariusz.majchrzak@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/scsi_scan.c  |    3 +++
 drivers/scsi/scsi_sysfs.c |   41 ++++++++++++++++++++++++++---------------
 2 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 03ebb37..56a9379 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1702,6 +1702,9 @@ static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
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
index 04c2a27..f888aad 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1000,7 +1000,6 @@ static void __scsi_remove_target(struct scsi_target *starget)
 	struct scsi_device *sdev;
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	starget->reap_ref++;
  restart:
 	list_for_each_entry(sdev, &shost->__devices, siblings) {
 		if (sdev->channel != starget->channel ||
@@ -1014,14 +1013,6 @@ static void __scsi_remove_target(struct scsi_target *starget)
 		goto restart;
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
-	scsi_target_reap(starget);
-}
-
-static int __remove_child (struct device * dev, void * data)
-{
-	if (scsi_is_target_device(dev))
-		__scsi_remove_target(to_scsi_target(dev));
-	return 0;
 }
 
 /**
@@ -1034,14 +1025,34 @@ static int __remove_child (struct device * dev, void * data)
  */
 void scsi_remove_target(struct device *dev)
 {
-	if (scsi_is_target_device(dev)) {
-		__scsi_remove_target(to_scsi_target(dev));
-		return;
+	struct Scsi_Host *shost = dev_to_shost(dev->parent);
+	struct scsi_target *starget, *found;
+	unsigned long flags;
+
+ restart:
+	found = NULL;
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_for_each_entry(starget, &shost->__targets, siblings) {
+		if (starget->state == STARGET_DEL)
+			continue;
+		if (starget->dev.parent == dev || &starget->dev == dev) {
+			found = starget;
+			found->reap_ref++;
+			break;
+		}
 	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
 
-	get_device(dev);
-	device_for_each_child(dev, NULL, __remove_child);
-	put_device(dev);
+	if (found) {
+		__scsi_remove_target(found);
+		scsi_target_reap(found);
+		/* in the case where @dev has multiple starget children,
+		 * continue removing.
+		 *
+		 * FIXME: does such a case exist?
+		 */
+		goto restart;
+	}
 }
 EXPORT_SYMBOL(scsi_remove_target);
 

