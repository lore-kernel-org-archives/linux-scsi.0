From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [patch for 2.6.32? 3/3] scsi: fix another crash at disconnect
 of usb strorage
Date: Fri, 20 Nov 2009 12:26:21 -0500
Message-ID: <1258737981.2889.208.camel@mulgrave.site>
References: <200911172210.nAHMADAW014298@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:44220 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626AbZKTR0Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Nov 2009 12:26:24 -0500
In-Reply-To: <200911172210.nAHMADAW014298@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, kuznet@ms2.inr.ac.ru, alan@lxorguk.ukuu.org.uk, den@openvz.org, stern@rowland.harvard.edu

On Tue, 2009-11-17 at 14:10 -0800, akpm@linux-foundation.org wrote:
> From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
> 
> Asynchronous scan (scsi_add_lun()) sets state to SDEV_RUNNING, but the
> device is not registered in sysfs.  Before async scan it was OK, because
> before releasing scan_mutex old code called either scsi_sysfs_add_sdev()
> or scsi_destroy_sdev() and, therefore, completed the work or discarded it.
> 
> With async scan the invariant is broken and scsi crashes in
> __scsi_remove_device() when trying to unregister not registered devices.
> 
> The fix could be introducing new state(s), which is equivalent to
> SDEV_RUNNING, except for one thing, we know that scsi_sysfs_add_sdev() has
> not been called yet.  Or a separate flag, because the state can be
> SDEV_BLOCK or even something else.

Another state is possible ... but the state model was really supposed to
reflect SCSI state ... this is really external visibility and is
independent of SCSI state, so perhaps just adding it as a flag is
easier.

> Simpler way is just to check that the device is regstered in sysfs before
> unregistering.  Another operations in __scsi_remove_device() seem to be
> idempotent or even required, because scsi_add_lun() makes some part of
> work duplicated in scsi_sysfs_add_sdev().

> Signed-off-by: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Denis V. Lunev <den@openvz.org>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/scsi/scsi_sysfs.c |   12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff -puN drivers/scsi/scsi_sysfs.c~scsi-fix-another-crash-at-disconnect-of-usb-strorage drivers/scsi/scsi_sysfs.c
> --- a/drivers/scsi/scsi_sysfs.c~scsi-fix-another-crash-at-disconnect-of-usb-strorage
> +++ a/drivers/scsi/scsi_sysfs.c
> @@ -965,9 +965,17 @@ void __scsi_remove_device(struct scsi_de
>  		return;
>  
>  	bsg_unregister_queue(sdev->request_queue);
> -	device_unregister(&sdev->sdev_dev);
> +	/* Asynchronous scan violates invariant that SDEV_RUNNING
> +	 * implies that device is registered in sysfs.
> +	 * We could introduce new state flag or extend set of state,
> +	 * but just plain checking that device is registered already
> +	 * before trying to unregister it is enough.
> +	 */
> +	if (sdev->sdev_dev.kobj.parent)

Checking embedded kobject parents as proof of registration, while
technically correct today is assuming deep magic within sysfs and will
attract the ire and fire of the sysfs people, so we can't really do it.
We'll have to use a visibility flag we control instead.

> +		device_unregister(&sdev->sdev_dev);

This patch also returns us to leaking the sdev_dev name because we need
an sdev_dev put in the invisible case

>  	transport_remove_device(dev);
> -	device_del(dev);
> +	if (dev->kobj.parent)
> +		device_del(dev);
>  	scsi_device_set_state(sdev, SDEV_DEL);
>  	if (sdev->host->hostt->slave_destroy)
>  		sdev->host->hostt->slave_destroy(sdev);

So how about this, it does the flag thing and hopefully keeps track of
the visibility correctly.

There still look to be some hanging loose ends in that
__scsi_remove_device() gets called twice in a few cases, but the state
model should just take no action for the duplicate call.

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


