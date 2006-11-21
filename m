From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 2/2] SCSI: add scsi_device->retries, take #2
Date: Tue, 21 Nov 2006 12:13:29 +0900
Message-ID: <20061121031329.GT2184@htj.dyndns.org>
References: <20061121031101.GS2184@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:30916 "EHLO
	ug-out-1314.google.com") by vger.kernel.org with ESMTP
	id S1030666AbWKUDNi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Nov 2006 22:13:38 -0500
Received: by ug-out-1314.google.com with SMTP id m3so1397048ugc
        for <linux-scsi@vger.kernel.org>; Mon, 20 Nov 2006 19:13:37 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20061121031101.GS2184@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org
Cc: Kai.Makisara@kolumbus.fi

Add scsi_device->retries to provide generic control over command
retries, which is very similar to sdev->timeout.  The initial value is
-1 and high level driver is free to override on attach if negative.
Note that -1 has the same effect as 0 (no retry) and signifies that
it's the default value.  As with sdev->timeout, sdev->retries is
exported under the device sysfs node.

sd and sr are converted to use it for retry value. Note that
sd_sync_cache() and sr::get_sectorsize() loop three more times around
normal command execution on failure.

st and osst are left alone as they have different requirements.  Those
will be updated separately if necessary.

Signed-off-by: Tejun Heo <htejun@gmail.com>

Index: scsi-misc-2.6/drivers/scsi/sd.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sd.c	2006-11-21 11:39:29.000000000 +0900
+++ scsi-misc-2.6/drivers/scsi/sd.c	2006-11-21 11:39:33.000000000 +0900
@@ -187,7 +187,7 @@ static ssize_t sd_store_cache_type(struc
 	rcd = ct & 0x01 ? 1 : 0;
 	wce = ct & 0x02 ? 1 : 0;
 	if (scsi_mode_sense(sdp, 0x08, 8, buffer, sizeof(buffer), sdp->timeout,
-			    SD_MAX_RETRIES, &data, NULL))
+			    sdp->retries, &data, NULL))
 		return -EINVAL;
 	len = min_t(size_t, sizeof(buffer), data.length - data.header_length -
 		  data.block_descriptor_length);
@@ -198,7 +198,7 @@ static ssize_t sd_store_cache_type(struc
 	sp = buffer_data[0] & 0x80 ? 1 : 0;
 
 	if (scsi_mode_select(sdp, 1, sp, 8, buffer_data, len, sdp->timeout,
-			     SD_MAX_RETRIES, &data, &sshdr)) {
+			     sdp->retries, &data, &sshdr)) {
 		if (scsi_sense_valid(&sshdr))
 			scsi_print_sense_hdr(sdkp->disk->disk_name, &sshdr);
 		return -EINVAL;
@@ -509,7 +509,7 @@ static int sd_init_command(struct scsi_c
 	 */
 	SCpnt->transfersize = sdp->sector_size;
 	SCpnt->underflow = this_count << 9;
-	SCpnt->allowed = SD_MAX_RETRIES;
+	SCpnt->allowed = sdp->retries;
 	SCpnt->timeout_per_command = sdp->timeout;
 
 	/*
@@ -758,7 +758,7 @@ static int sd_media_changed(struct gendi
 	 */
 	retval = -ENODEV;
 	if (scsi_block_when_processing_errors(sdp))
-		retval = scsi_test_unit_ready(sdp, sdp->timeout, SD_MAX_RETRIES);
+		retval = scsi_test_unit_ready(sdp, sdp->timeout, sdp->retries);
 
 	/*
 	 * Unable to test, unit probably not ready.   This usually
@@ -804,7 +804,7 @@ static int sd_sync_cache(struct scsi_dev
 		 * flush everything.
 		 */
 		res = scsi_execute_req(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
-				       sdp->timeout, SD_MAX_RETRIES);
+				       sdp->timeout, sdp->retries);
 		if (res == 0)
 			break;
 	}
@@ -1052,7 +1052,7 @@ sd_spinup_disk(struct scsi_disk *sdkp, c
 			the_result = scsi_execute_req(sdp, cmd,
 						      DMA_NONE, NULL, 0,
 						      &sshdr, sdp->timeout,
-						      SD_MAX_RETRIES);
+						      sdp->retries);
 
 			/*
 			 * If the drive has indicated to us that it
@@ -1108,7 +1108,7 @@ sd_spinup_disk(struct scsi_disk *sdkp, c
 				cmd[4] = 1;	/* Start spin cycle */
 				scsi_execute_req(sdp, cmd, DMA_NONE,
 						 NULL, 0, &sshdr,
-						 sdp->timeout, SD_MAX_RETRIES);
+						 sdp->timeout, sdp->retries);
 				spintime_expire = jiffies + 100 * HZ;
 				spintime = 1;
 			}
@@ -1183,7 +1183,7 @@ repeat:
 		
 		the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
 					      buffer, longrc ? 12 : 8, &sshdr,
-					      sdp->timeout, SD_MAX_RETRIES);
+					      sdp->timeout, sdp->retries);
 
 		if (media_not_present(sdkp, &sshdr))
 			return;
@@ -1348,8 +1348,7 @@ sd_do_mode_sense(struct scsi_device *sdp
 		 struct scsi_sense_hdr *sshdr)
 {
 	return scsi_mode_sense(sdp, dbd, modepage, buffer, len,
-			       sdp->timeout, SD_MAX_RETRIES, data,
-			       sshdr);
+			       sdp->timeout, sdp->retries, data, sshdr);
 }
 
 /*
@@ -1673,6 +1672,9 @@ static int sd_probe(struct device *dev)
 			sdp->timeout = SD_MOD_TIMEOUT;
 	}
 
+	if (sdp->retries < 0)
+		sdp->retries = SD_MAX_RETRIES;
+
 	gd->major = sd_major((index & 0xf0) >> 4);
 	gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
 	gd->minors = 16;
Index: scsi-misc-2.6/include/scsi/scsi_device.h
===================================================================
--- scsi-misc-2.6.orig/include/scsi/scsi_device.h	2006-11-19 21:14:59.000000000 +0900
+++ scsi-misc-2.6/include/scsi/scsi_device.h	2006-11-21 11:39:33.000000000 +0900
@@ -134,6 +134,7 @@ struct scsi_device {
 	atomic_t ioerr_cnt;
 
 	int timeout;
+	int retries;
 
 	struct device		sdev_gendev;
 	struct class_device	sdev_classdev;
Index: scsi-misc-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_sysfs.c	2006-11-19 21:14:59.000000000 +0900
+++ scsi-misc-2.6/drivers/scsi/scsi_sysfs.c	2006-11-21 11:39:33.000000000 +0900
@@ -443,6 +443,33 @@ sdev_store_timeout (struct device *dev, 
 static DEVICE_ATTR(timeout, S_IRUGO | S_IWUSR, sdev_show_timeout, sdev_store_timeout);
 
 static ssize_t
+sdev_show_retries(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	int retries = sdev->retries;
+
+	/* negative indicates uninitialized default */
+	if (retries < 0)
+		retries = 0;
+
+	return snprintf(buf, 20, "%d\n", retries);
+}
+
+static ssize_t
+sdev_store_retries(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	int retries;
+
+	sscanf(buf, "%d\n", &retries);
+	if (retries < 0)
+		return -EINVAL;
+	sdev->retries = retries;
+	return count;
+}
+static DEVICE_ATTR(retries, S_IRUGO | S_IWUSR, sdev_show_retries, sdev_store_retries);
+
+static ssize_t
 store_rescan_field (struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
 {
 	scsi_rescan_device(dev);
@@ -548,6 +575,7 @@ static struct device_attribute *scsi_sys
 	&dev_attr_delete,
 	&dev_attr_state,
 	&dev_attr_timeout,
+	&dev_attr_retries,
 	&dev_attr_iocounterbits,
 	&dev_attr_iorequest_cnt,
 	&dev_attr_iodone_cnt,
Index: scsi-misc-2.6/drivers/scsi/sr.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sr.c	2006-11-21 11:39:29.000000000 +0900
+++ scsi-misc-2.6/drivers/scsi/sr.c	2006-11-21 11:39:33.000000000 +0900
@@ -185,7 +185,7 @@ int sr_media_change(struct cdrom_device_
 		return -EINVAL;
 	}
 
-	retval = scsi_test_unit_ready(sdev, sdev->timeout, MAX_RETRIES);
+	retval = scsi_test_unit_ready(sdev, sdev->timeout, sdev->retries);
 	if (retval) {
 		/* Unable to test, unit probably not ready.  This usually
 		 * means there is no disc in the drive.  Mark as changed,
@@ -407,7 +407,7 @@ static int sr_init_command(struct scsi_c
 	 */
 	SCpnt->transfersize = sdev->sector_size;
 	SCpnt->underflow = this_count << 9;
-	SCpnt->allowed = MAX_RETRIES;
+	SCpnt->allowed = sdev->retries;
 	SCpnt->timeout_per_command = sdev->timeout;
 
 	/*
@@ -583,6 +583,8 @@ static int sr_probe(struct device *dev)
 
 	if (!sdev->timeout)
 		sdev->timeout = SR_TIMEOUT;
+	if (sdev->retries < 0)
+		sdev->retries = MAX_RETRIES;
 
 	cd->cdi.ops = &sr_dops;
 	cd->cdi.handle = cd;
@@ -643,7 +645,7 @@ static void get_sectorsize(struct scsi_c
 		/* Do the command and wait.. */
 		the_result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE,
 					      buffer, 8, NULL, sdev->timeout,
-					      MAX_RETRIES);
+					      sdev->retries);
 
 		retries--;
 
@@ -748,7 +750,7 @@ static void get_capabilities(struct scsi
 
 		the_result = scsi_execute_req (sdev, cmd, DMA_NONE, NULL,
 					       0, &sshdr, sdev->timeout,
-					       MAX_RETRIES);
+					       sdev->retries);
 
 		retries++;
 	} while (retries < 5 && 
Index: scsi-misc-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_scan.c	2006-11-19 21:14:59.000000000 +0900
+++ scsi-misc-2.6/drivers/scsi/scsi_scan.c	2006-11-21 11:39:33.000000000 +0900
@@ -261,6 +261,13 @@ static struct scsi_device *scsi_alloc_sd
 	 */
 	sdev->borken = 1;
 
+	/*
+	 * -1 indicates uninitialized default and equivalent to zero
+	 * in effect.  High level driver is allowed to adjust retries
+	 * if it's negative.
+	 */
+	sdev->retries = -1;
+
 	sdev->request_queue = scsi_alloc_queue(sdev);
 	if (!sdev->request_queue) {
 		/* release fn is set up in scsi_sysfs_device_initialise, so
