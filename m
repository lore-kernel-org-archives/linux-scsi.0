From: Hannes Reinecke <hare@suse.de>
Subject: [RFC] [PATCH] Resurrect sdev
Date: Tue, 13 Feb 2007 19:29:01 +0100
Message-ID: <20070213182901.GA4592@pentland.suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="FL5UXtIhxfXey3p5"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:36564 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbXBMS3E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Feb 2007 13:29:04 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.smart@emulex.com, james.bottomley@steeleye.com, hch@lst.de


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi all,

as discussed in San Jose here is a patch to resurrect sdevs which are
in state SDEV_CANCEL / SDEV_DEL.

I've updated sdev handling functions to be better aligned with the state
machine; we now have:

scsi_remove_device(): Same as before; transitioning into SDEV_CANCEL.
    Initiate the device removal.
scsi_destroy_device(): Transition into SDEV_DEL; just initiate
    the final device_put(). Device will be deleted properly once
    the refcount drops to zero.
scsi_configure_device(): Transistion into SDEV_RUNNING.
    If scsi_configure_device() succeeds it has to be added to
    sysfs with scsi_sysfs_add_sdev(). If it fails the sdev
    should be deleted with scsi_destroy_device().
scsi_resurrect_device(): Wrapper around scsi_configure_device.
    Transition a deleted device into SDEV_RUNNING.
    If it fails the device is in SDEV_DEL.

I've gone through the scanning mechanism and hopefully got it done properly.
I tried to ensure that after the scanning the sdevs are either in
SDEV_RUNNING or SDEV_DEL.

Patch apprears to work properly, but I haven't been running any stress tests
on it. Ie those cases which the patch is trying to solve :-)

Comments etc. welcome.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra�e 5				+49 911 74053 688
90409 N�rnberg				http://www.suse.de

--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=scsi-resurrect-sdev

diff --git a/block/elevator.c b/block/elevator.c
diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
diff --git a/drivers/block/sx8.c b/drivers/block/sx8.c
diff --git a/drivers/block/ub.c b/drivers/block/ub.c
diff --git a/drivers/block/viodasd.c b/drivers/block/viodasd.c
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
diff --git a/drivers/message/i2o/i2o_block.c b/drivers/message/i2o/i2o_block.c
diff --git a/drivers/mmc/mmc_block.c b/drivers/mmc/mmc_block.c
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
diff --git a/drivers/s390/char/tape_block.c b/drivers/s390/char/tape_block.c
diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index b8f0cab..73d0469 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -297,8 +297,7 @@ static struct scsi_device *scsi_alloc_sd
 	return sdev;
 
 out_device_destroy:
-	transport_destroy_device(&sdev->sdev_gendev);
-	put_device(&sdev->sdev_gendev);
+	scsi_destroy_device(sdev);
 out:
 	if (display_failure_msg)
 		printk(ALLOC_FAILURE_MSG, __FUNCTION__);
@@ -697,6 +696,8 @@ static int scsi_probe_lun(struct scsi_de
 static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		int *bflags, int async)
 {
+	int ret;
+
 	/*
 	 * XXX do not save the inquiry, since it can change underneath us,
 	 * save just vendor/model/rev.
@@ -846,10 +847,6 @@ static int scsi_add_lun(struct scsi_devi
 	if (*bflags & BLIST_USE_10_BYTE_MS)
 		sdev->use_10_for_ms = 1;
 
-	/* set the device running here so that slave configure
-	 * may do I/O */
-	scsi_device_set_state(sdev, SDEV_RUNNING);
-
 	if (*bflags & BLIST_MS_192_BYTES_FOR_3F)
 		sdev->use_192_bytes_for_3f = 1;
 
@@ -859,21 +856,18 @@ static int scsi_add_lun(struct scsi_devi
 	if (*bflags & BLIST_RETRY_HWERROR)
 		sdev->retry_hwerror = 1;
 
-	transport_configure_device(&sdev->sdev_gendev);
-
-	if (sdev->host->hostt->slave_configure) {
-		int ret = sdev->host->hostt->slave_configure(sdev);
-		if (ret) {
-			/*
-			 * if LLDD reports slave not present, don't clutter
-			 * console with alloc failure messages
-			 */
-			if (ret != -ENXIO) {
-				sdev_printk(KERN_ERR, sdev,
-					"failed to configure device\n");
-			}
-			return SCSI_SCAN_NO_RESPONSE;
+	ret = scsi_configure_device(sdev);
+	if (ret) {
+		/*
+		 * if LLDD reports slave not present, don't clutter
+		 * console with alloc failure messages
+		 */
+		if (ret != -ENXIO) {
+			sdev_printk(KERN_ERR, sdev,
+				    "failed to configure device\n");
 		}
+		scsi_destroy_device(sdev);
+		return SCSI_SCAN_NO_RESPONSE;
 	}
 
 	/*
@@ -887,15 +881,6 @@ static int scsi_add_lun(struct scsi_devi
 	return SCSI_SCAN_LUN_PRESENT;
 }
 
-static inline void scsi_destroy_sdev(struct scsi_device *sdev)
-{
-	scsi_device_set_state(sdev, SDEV_DEL);
-	if (sdev->host->hostt->slave_destroy)
-		sdev->host->hostt->slave_destroy(sdev);
-	transport_destroy_device(&sdev->sdev_gendev);
-	put_device(&sdev->sdev_gendev);
-}
-
 #ifdef CONFIG_SCSI_LOGGING
 /** 
  * scsi_inq_str - print INQUIRY data from min to max index,
@@ -957,6 +942,10 @@ static int scsi_probe_and_add_lun(struct
 	 */
 	sdev = scsi_device_lookup_by_target(starget, lun);
 	if (sdev) {
+		if (scsi_resurrect_device(sdev)) {
+			scsi_device_put(sdev);
+			return SCSI_SCAN_NO_RESPONSE;
+		}
 		if (rescan || sdev->sdev_state != SDEV_CREATED) {
 			SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
 				"scsi scan: device exists on %s\n",
@@ -1067,11 +1056,12 @@ static int scsi_probe_and_add_lun(struct
 				*sdevp = sdev;
 			} else {
 				__scsi_remove_device(sdev);
+				scsi_destroy_device(sdev);
 				res = SCSI_SCAN_NO_RESPONSE;
 			}
 		}
 	} else
-		scsi_destroy_sdev(sdev);
+		scsi_destroy_device(sdev);
  out:
 	return res;
 }
@@ -1273,6 +1263,9 @@ static int scsi_report_lun_scan(struct s
 			return 0;
 		if (scsi_device_get(sdev))
 			return 0;
+	} else if (scsi_resurrect_device(sdev)) {
+		scsi_device_put(sdev);
+		return 0;
 	}
 
 	sprintf(devname, "host %d channel %d id %d",
@@ -1425,7 +1418,7 @@ static int scsi_report_lun_scan(struct s
 		/*
 		 * the sdev we used didn't appear in the report luns scan
 		 */
-		scsi_destroy_sdev(sdev);
+		scsi_destroy_device(sdev);
 	return ret;
 }
 
@@ -1628,8 +1621,11 @@ static void scsi_sysfs_add_devices(struc
 {
 	struct scsi_device *sdev;
 	shost_for_each_device(sdev, shost) {
-		if (scsi_sysfs_add_sdev(sdev) != 0)
-			scsi_destroy_sdev(sdev);
+		/* 
+		 * scsi_sysfs_add_sdev will clean up on failure,
+		 * no need to do it here.
+		 */
+		scsi_sysfs_add_sdev(sdev);
 	}
 }
 
@@ -1776,6 +1772,7 @@ void scsi_forget_host(struct Scsi_Host *
 			continue;
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		__scsi_remove_device(sdev);
+		scsi_destroy_device(sdev);
 		goto restart;
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
@@ -1843,7 +1840,7 @@ void scsi_free_host_dev(struct scsi_devi
 {
 	BUG_ON(sdev->id != sdev->host->this_id);
 
-	scsi_destroy_sdev(sdev);
+	scsi_destroy_device(sdev);
 }
 EXPORT_SYMBOL(scsi_free_host_dev);
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 259c90c..e4d0c97 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -230,6 +230,10 @@ static void scsi_device_dev_release_user
 	parent = sdev->sdev_gendev.parent;
 	starget = to_scsi_target(parent);
 
+	if (sdev->host->hostt->slave_destroy)
+		sdev->host->hostt->slave_destroy(sdev);
+	transport_destroy_device(&sdev->sdev_gendev);
+
 	spin_lock_irqsave(sdev->host->host_lock, flags);
 	starget->reap_ref++;
 	list_del(&sdev->siblings);
@@ -681,14 +685,17 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 
 	error = device_add(&sdev->sdev_gendev);
 	if (error) {
-		put_device(sdev->sdev_gendev.parent);
 		printk(KERN_INFO "error 1\n");
+		scsi_device_set_state(sdev, SDEV_CANCEL);
+		put_device(sdev->sdev_gendev.parent);
 		return error;
 	}
 	error = class_device_add(&sdev->sdev_classdev);
 	if (error) {
 		printk(KERN_INFO "error 2\n");
-		goto clean_device;
+		scsi_device_set_state(sdev, SDEV_CANCEL);
+		device_del(&sdev->sdev_gendev);
+		goto out_error;
 	}
 
 	/* take a reference for the sdev_classdev; this is
@@ -700,7 +707,7 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 					sdev->host->hostt->sdev_attrs[i]);
 			if (error) {
 				__scsi_remove_device(sdev);
-				goto out;
+				goto out_error;
 			}
 		}
 	}
@@ -714,25 +721,76 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 			error = device_create_file(&sdev->sdev_gendev, attr);
 			if (error) {
 				__scsi_remove_device(sdev);
-				goto out;
+				goto out_error;
 			}
 		}
 	}
 
 	transport_add_device(&sdev->sdev_gendev);
- out:
-	return error;
 
- clean_device:
-	scsi_device_set_state(sdev, SDEV_CANCEL);
+	return error;
 
-	device_del(&sdev->sdev_gendev);
-	transport_destroy_device(&sdev->sdev_gendev);
-	put_device(&sdev->sdev_gendev);
+ out_error:
+	scsi_destroy_device(sdev);
 
 	return error;
 }
 
+int scsi_resurrect_device(struct scsi_device *sdev)
+{
+	int ret = 0;
+
+	/* Device is active, return */
+	if (sdev->sdev_state == SDEV_RUNNING || sdev->sdev_state == SDEV_CREATED)
+		return 0;
+
+	/*
+	 * Set the device to SDEV_CANCEL to start resurrection
+	 */
+	if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
+		return -ENXIO;
+
+	ret = scsi_configure_device(sdev);
+	if (ret) {
+		scsi_destroy_device(sdev);
+		return ret;
+	}
+
+	/*
+	 * Ok, the device is now all set up, we can
+	 * register it and tell the rest of the kernel
+	 * about it.
+	 */
+	return scsi_sysfs_add_sdev(sdev);
+}
+
+int scsi_configure_device(struct scsi_device *sdev)
+{
+	/* set the device running here so that slave configure
+	 * may do I/O */
+	if (scsi_device_set_state(sdev, SDEV_RUNNING) != 0)
+		return -ENXIO;
+	
+	transport_configure_device(&sdev->sdev_gendev);
+
+	if (sdev->host->hostt->slave_configure) {
+		int ret = sdev->host->hostt->slave_configure(sdev);
+		if (ret) {
+			/*
+			 * if LLDD reports slave not present, don't clutter
+			 * console with alloc failure messages
+			 */
+			if (ret != -ENXIO) {
+				sdev_printk(KERN_ERR, sdev,
+					"failed to configure device\n");
+			}
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
 void __scsi_remove_device(struct scsi_device *sdev)
 {
 	struct device *dev = &sdev->sdev_gendev;
@@ -743,11 +801,6 @@ void __scsi_remove_device(struct scsi_de
 	class_device_unregister(&sdev->sdev_classdev);
 	transport_remove_device(dev);
 	device_del(dev);
-	scsi_device_set_state(sdev, SDEV_DEL);
-	if (sdev->host->hostt->slave_destroy)
-		sdev->host->hostt->slave_destroy(sdev);
-	transport_destroy_device(dev);
-	put_device(dev);
 }
 
 /**
@@ -760,6 +813,7 @@ void scsi_remove_device(struct scsi_devi
 
 	mutex_lock(&shost->scan_mutex);
 	__scsi_remove_device(sdev);
+	scsi_destroy_device(sdev);
 	mutex_unlock(&shost->scan_mutex);
 }
 EXPORT_SYMBOL(scsi_remove_device);
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index ebf31b1..af127aa 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -202,6 +202,8 @@ extern struct scsi_device *__scsi_add_de
 		uint, uint, uint, void *hostdata);
 extern int scsi_add_device(struct Scsi_Host *host, uint channel,
 			   uint target, uint lun);
+extern int scsi_configure_device(struct scsi_device *);
+extern int scsi_resurrect_device(struct scsi_device *);
 extern void scsi_remove_device(struct scsi_device *);
 extern int scsi_device_cancel(struct scsi_device *, int);
 
@@ -316,6 +318,12 @@ static inline unsigned int sdev_id(struc
 #define scmd_id(scmd) sdev_id((scmd)->device)
 #define scmd_channel(scmd) sdev_channel((scmd)->device)
 
+static inline void scsi_destroy_device(struct scsi_device *sdev)
+{
+	scsi_device_set_state(sdev, SDEV_DEL);
+	put_device(&sdev->sdev_gendev);
+}
+
 static inline int scsi_device_online(struct scsi_device *sdev)
 {
 	return sdev->sdev_state != SDEV_OFFLINE;

--FL5UXtIhxfXey3p5--
