From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/4 ver 3] SCSI: add construction flags to scsi_device
 structure
Date: Thu, 19 Nov 2009 17:48:29 -0500
Message-ID: <1258670909.6363.647.camel@mulgrave.site>
References: <Pine.LNX.4.44L0.0910281456510.3061-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50312 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756250AbZKSWs3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Nov 2009 17:48:29 -0500
In-Reply-To: <Pine.LNX.4.44L0.0910281456510.3061-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 2009-10-28 at 15:09 -0400, Alan Stern wrote:
> This patch (as1250c) adds extra flags to the scsi_device structure, to
> keep track of what parts have been constructed.  These flags are used
> in the destructor routines to determine which fields need to be torn
> down.  This allows all the slave_destroy() and
> transport_destroy_device() calls to be moved to a single place in
> scsi_device_dev_release_user_context() instead of appearing in
> multiple locations throughout the source.
> 
> This also simplifies the destructors.  There's no need for a separate
> scsi_destroy_sdev() routine; __scsi_remove_device() can handle
> everything.  The error paths are more robust because now it's easy to
> verify that all the destructors are called along every pathway.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

The diffstats really say this is a wash on simplification:

 drivers/scsi/scsi_scan.c   |   22 ++++++----------------
 drivers/scsi/scsi_sysfs.c  |   37 ++++++++++++++++++++-----------------
 include/scsi/scsi_device.h |    7 +++++++
 3 files changed, 33 insertions(+), 33 deletions(-)

Your 5 constructor flags are what makes this so complex ... plus it now
doesn't actually work with the memory leak fix commit:

commit 37e6ba00720c2786330dec2a9a5081e9e049422f
Author: James Bottomley <James.Bottomley@suse.de>
Date:   Fri Oct 2 13:30:08 2009 -0500

    [SCSI] fix memory leak in initialization
 
I think you can make this much simpler just by having one visible flag
(i.e. was scsi_sysfs_sdev_add() called or not) and making everything
unwind back to either the alloc or the add state on failure.  Like the
attached.  It also cleanly fixes the USB scan crash in an easily
backportable manner.

James

---

 drivers/scsi/scsi_scan.c   |   18 +++----------
 drivers/scsi/scsi_sysfs.c  |   63 +++++++++++++++++++-------------------------
 include/scsi/scsi_device.h |    1 +
 3 files changed, 32 insertions(+), 50 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index a0e0632..ded615d 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -955,16 +955,6 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	return SCSI_SCAN_LUN_PRESENT;
 }
 
-static inline void scsi_destroy_sdev(struct scsi_device *sdev)
-{
-	scsi_device_set_state(sdev, SDEV_DEL);
-	if (sdev->host->hostt->slave_destroy)
-		sdev->host->hostt->slave_destroy(sdev);
-	transport_destroy_device(&sdev->sdev_gendev);
-	put_device(&sdev->sdev_dev);
-	put_device(&sdev->sdev_gendev);
-}
-
 #ifdef CONFIG_SCSI_LOGGING
 /** 
  * scsi_inq_str - print INQUIRY data from min to max index, strip trailing whitespace
@@ -1142,7 +1132,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 			}
 		}
 	} else
-		scsi_destroy_sdev(sdev);
+		__scsi_remove_device(sdev);
  out:
 	return res;
 }
@@ -1503,7 +1493,7 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 		/*
 		 * the sdev we used didn't appear in the report luns scan
 		 */
-		scsi_destroy_sdev(sdev);
+		__scsi_remove_device(sdev);
 	return ret;
 }
 
@@ -1713,7 +1703,7 @@ static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
 	shost_for_each_device(sdev, shost) {
 		if (!scsi_host_scan_allowed(shost) ||
 		    scsi_sysfs_add_sdev(sdev) != 0)
-			scsi_destroy_sdev(sdev);
+			__scsi_remove_device(sdev);
 	}
 }
 
@@ -1946,7 +1936,7 @@ void scsi_free_host_dev(struct scsi_device *sdev)
 {
 	BUG_ON(sdev->id != sdev->host->this_id);
 
-	scsi_destroy_sdev(sdev);
+	__scsi_remove_device(sdev);
 }
 EXPORT_SYMBOL(scsi_free_host_dev);
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 758598f..5a06505 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -888,15 +888,17 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	transport_configure_device(&starget->dev);
 	error = device_add(&sdev->sdev_gendev);
 	if (error) {
-		put_device(sdev->sdev_gendev.parent);
 		printk(KERN_INFO "error 1\n");
-		return error;
+		goto out_remove;
 	}
 	error = device_add(&sdev->sdev_dev);
 	if (error) {
 		printk(KERN_INFO "error 2\n");
-		goto clean_device;
+		device_del(&sdev->sdev_gendev);
+		goto out_remove;
 	}
+	transport_add_device(&sdev->sdev_gendev);
+	sdev->is_visible = 1;
 
 	/* create queue files, which may be writable, depending on the host */
 	if (sdev->host->hostt->change_queue_depth) {
@@ -907,67 +909,56 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	}
 	else
 		error = device_create_file(&sdev->sdev_gendev, &dev_attr_queue_depth);
-	if (error) {
-		__scsi_remove_device(sdev);
-		goto out;
-	}
+	if (error)
+		goto out_remove;
+
 	if (sdev->host->hostt->change_queue_type)
 		error = device_create_file(&sdev->sdev_gendev, &sdev_attr_queue_type_rw);
 	else
 		error = device_create_file(&sdev->sdev_gendev, &dev_attr_queue_type);
-	if (error) {
-		__scsi_remove_device(sdev);
-		goto out;
-	}
+	if (error)
+		goto out_remove;
 
 	error = bsg_register_queue(rq, &sdev->sdev_gendev, NULL, NULL);
 
 	if (error)
+		/* we're treating error on bsg register as non-fatal,
+		 * so pretend nothing went wrong */
 		sdev_printk(KERN_INFO, sdev,
 			    "Failed to register bsg queue, errno=%d\n", error);
 
-	/* we're treating error on bsg register as non-fatal, so pretend
-	 * nothing went wrong */
-	error = 0;
-
 	/* add additional host specific attributes */
 	if (sdev->host->hostt->sdev_attrs) {
 		for (i = 0; sdev->host->hostt->sdev_attrs[i]; i++) {
 			error = device_create_file(&sdev->sdev_gendev,
 					sdev->host->hostt->sdev_attrs[i]);
-			if (error) {
-				__scsi_remove_device(sdev);
-				goto out;
-			}
+			if (error)
+				goto out_remove;
 		}
 	}
 
-	transport_add_device(&sdev->sdev_gendev);
- out:
-	return error;
-
- clean_device:
-	scsi_device_set_state(sdev, SDEV_CANCEL);
-
-	device_del(&sdev->sdev_gendev);
-	transport_destroy_device(&sdev->sdev_gendev);
-	put_device(&sdev->sdev_dev);
-	put_device(&sdev->sdev_gendev);
+	return 0;
 
+ out_remove:
+	__scsi_remove_device(sdev);
 	return error;
+
 }
 
 void __scsi_remove_device(struct scsi_device *sdev)
 {
 	struct device *dev = &sdev->sdev_gendev;
 
-	if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
-		return;
+	if (sdev->is_visible) {
+		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
+			return;
 
-	bsg_unregister_queue(sdev->request_queue);
-	device_unregister(&sdev->sdev_dev);
-	transport_remove_device(dev);
-	device_del(dev);
+		bsg_unregister_queue(sdev->request_queue);
+		device_unregister(&sdev->sdev_dev);
+		transport_remove_device(dev);
+		device_del(dev);
+	} else
+		put_device(&sdev->sdev_dev);
 	scsi_device_set_state(sdev, SDEV_DEL);
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 68d185c..7c44499 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -148,6 +148,7 @@ struct scsi_device {
 	unsigned retry_hwerror:1;	/* Retry HARDWARE_ERROR */
 	unsigned last_sector_bug:1;	/* do not use multisector accesses on
 					   SD_LAST_BUGGY_SECTORS */
+	unsigned is_visible:1;	/* is the device visible in sysfs */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
 	struct list_head event_list;	/* asserted events */



