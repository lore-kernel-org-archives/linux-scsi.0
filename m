From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 2/3] sd: implement START/STOP management
Date: Wed, 21 Mar 2007 00:13:59 +0900
Message-ID: <20070320151359.GG6152@htj.dyndns.org>
References: <20070320150718.GF6152@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.237]:41570 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933641AbXCTPOG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Mar 2007 11:14:06 -0400
Received: by wr-out-0506.google.com with SMTP id 41so2077815wry
        for <linux-scsi@vger.kernel.org>; Tue, 20 Mar 2007 08:14:05 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20070320150718.GF6152@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, djwong@us.ibm.com, hmh@hmh.eng.br

Implement SBC START/STOP management.  sdev->mange_start_stop is added.
When it's set to one, sd STOPs the device on suspend and shutdown and
STARTs it on resume.  sdev->manage_start_stop defaults is in sdev
instead of scsi_disk cdev to allow ->slave_config() override the
default configuration but is exported under scsi_disk sysfs node as
sdev->allow_restart is.

When manage_start_stop is zero (the default value), this patch doesn't
introduce any behavior change.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 drivers/scsi/scsi_sysfs.c  |   31 +++++++++++--
 drivers/scsi/sd.c          |  102 +++++++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h |    1 
 3 files changed, 130 insertions(+), 4 deletions(-)

Index: work/drivers/scsi/sd.c
===================================================================
--- work.orig/drivers/scsi/sd.c
+++ work/drivers/scsi/sd.c
@@ -142,6 +142,8 @@ static void sd_rw_intr(struct scsi_cmnd 
 static int sd_probe(struct device *);
 static int sd_remove(struct device *);
 static void sd_shutdown(struct device *dev);
+static int sd_suspend(struct device *dev, pm_message_t state);
+static int sd_resume(struct device *dev);
 static void sd_rescan(struct device *);
 static int sd_init_command(struct scsi_cmnd *);
 static int sd_issue_flush(struct device *, sector_t *);
@@ -206,6 +208,20 @@ static ssize_t sd_store_cache_type(struc
 	return count;
 }
 
+static ssize_t sd_store_manage_start_stop(struct class_device *cdev,
+					  const char *buf, size_t count)
+{
+	struct scsi_disk *sdkp = to_scsi_disk(cdev);
+	struct scsi_device *sdp = sdkp->device;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	sdp->manage_start_stop = simple_strtoul(buf, NULL, 10);
+
+	return count;
+}
+
 static ssize_t sd_store_allow_restart(struct class_device *cdev, const char *buf,
 				      size_t count)
 {
@@ -238,6 +254,14 @@ static ssize_t sd_show_fua(struct class_
 	return snprintf(buf, 20, "%u\n", sdkp->DPOFUA);
 }
 
+static ssize_t sd_show_manage_start_stop(struct class_device *cdev, char *buf)
+{
+	struct scsi_disk *sdkp = to_scsi_disk(cdev);
+	struct scsi_device *sdp = sdkp->device;
+
+	return snprintf(buf, 20, "%u\n", sdp->manage_start_stop);
+}
+
 static ssize_t sd_show_allow_restart(struct class_device *cdev, char *buf)
 {
 	struct scsi_disk *sdkp = to_scsi_disk(cdev);
@@ -251,6 +275,8 @@ static struct class_device_attribute sd_
 	__ATTR(FUA, S_IRUGO, sd_show_fua, NULL),
 	__ATTR(allow_restart, S_IRUGO|S_IWUSR, sd_show_allow_restart,
 	       sd_store_allow_restart),
+	__ATTR(manage_start_stop, S_IRUGO|S_IWUSR, sd_show_manage_start_stop,
+	       sd_store_manage_start_stop),
 	__ATTR_NULL,
 };
 
@@ -267,6 +293,8 @@ static struct scsi_driver sd_template = 
 		.name		= "sd",
 		.probe		= sd_probe,
 		.remove		= sd_remove,
+		.suspend	= sd_suspend,
+		.resume		= sd_resume,
 		.shutdown	= sd_shutdown,
 	},
 	.rescan			= sd_rescan,
@@ -1776,6 +1804,32 @@ static void scsi_disk_release(struct cla
 	kfree(sdkp);
 }
 
+static int sd_start_stop_device(struct scsi_device *sdp, int start)
+{
+	unsigned char cmd[6] = { START_STOP };	/* START_VALID */
+	struct scsi_sense_hdr sshdr;
+	int res;
+
+	if (start)
+		cmd[4] |= 1;	/* START */
+
+	if (!scsi_device_online(sdp))
+		return -ENODEV;
+
+	res = scsi_execute_req(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
+			       SD_TIMEOUT, SD_MAX_RETRIES);
+	if (res) {
+		printk(KERN_WARNING "FAILED\n  status = %x, message = %02x, "
+		       "host = %d, driver = %02x\n  ",
+		       status_byte(res), msg_byte(res),
+		       host_byte(res), driver_byte(res));
+		if (driver_byte(res) & DRIVER_SENSE)
+			scsi_print_sense_hdr("sd", &sshdr);
+	}
+
+	return res;
+}
+
 /*
  * Send a SYNCHRONIZE CACHE instruction down to the device through
  * the normal SCSI command structure.  Wait for the command to
@@ -1794,9 +1848,57 @@ static void sd_shutdown(struct device *d
 				sdkp->disk->disk_name);
 		sd_sync_cache(sdp);
 	}
+
+	if (system_state != SYSTEM_RESTART && sdp->manage_start_stop) {
+ 		printk(KERN_NOTICE "Stopping disk %s: \n",
+		       sdkp->disk->disk_name);
+		sd_start_stop_device(sdp, 0);
+	}
+
 	scsi_disk_put(sdkp);
 }
 
+static int sd_suspend(struct device *dev, pm_message_t mesg)
+{
+	struct scsi_device *sdp = to_scsi_device(dev);
+	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
+	int ret;
+
+	if (!sdkp)
+		return 0;	/* this can happen */
+
+	if (sdkp->WCE) {
+		printk(KERN_NOTICE "Synchronizing SCSI cache for disk %s: \n",
+				sdkp->disk->disk_name);
+		ret = sd_sync_cache(sdp);
+		if (ret)
+			return ret;
+	}
+
+	if (mesg.event == PM_EVENT_SUSPEND && sdp->manage_start_stop) {
+		printk(KERN_NOTICE "Stopping disk %s: \n",
+		       sdkp->disk->disk_name);
+		ret = sd_start_stop_device(sdp, 0);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int sd_resume(struct device *dev)
+{
+	struct scsi_device *sdp = to_scsi_device(dev);
+	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
+
+	if (!sdp->manage_start_stop)
+		return 0;
+
+	printk(KERN_NOTICE "Starting disk %s: \n", sdkp->disk->disk_name);
+
+	return sd_start_stop_device(sdp, 1);
+}
+
 /**
  *	init_sd - entry point for this driver (both when built in or when
  *	a module).
Index: work/include/scsi/scsi_device.h
===================================================================
--- work.orig/include/scsi/scsi_device.h
+++ work/include/scsi/scsi_device.h
@@ -119,6 +119,7 @@ struct scsi_device {
 	unsigned use_192_bytes_for_3f:1; /* ask for 192 bytes from page 0x3f */
 	unsigned no_start_on_add:1;	/* do not issue start on add */
 	unsigned allow_restart:1; /* issue START_UNIT in error handler */
+	unsigned manage_start_stop:1;	/* Let HLD (sd) manage start/stop */
 	unsigned no_uld_attach:1; /* disable connecting to upper level drivers */
 	unsigned select_no_atn:1;
 	unsigned fix_capacity:1;	/* READ_CAPACITY is too high by 1 */
Index: work/drivers/scsi/scsi_sysfs.c
===================================================================
--- work.orig/drivers/scsi/scsi_sysfs.c
+++ work/drivers/scsi/scsi_sysfs.c
@@ -278,6 +278,7 @@ static int scsi_bus_match(struct device 
 
 static int scsi_bus_suspend(struct device * dev, pm_message_t state)
 {
+	struct device_driver *drv = dev->driver;
 	struct scsi_device *sdev = to_scsi_device(dev);
 	struct scsi_host_template *sht = sdev->host->hostt;
 	int err;
@@ -286,23 +287,45 @@ static int scsi_bus_suspend(struct devic
 	if (err)
 		return err;
 
-	if (sht->suspend)
+	/* call HLD suspend first */
+	if (drv && drv->suspend) {
+		err = drv->suspend(dev, state);
+		if (err)
+			return err;
+	}
+
+	/* then, call host suspend */
+	if (sht->suspend) {
 		err = sht->suspend(sdev, state);
+		if (err) {
+			if (drv && drv->resume)
+				drv->resume(dev);
+			return err;
+		}
+	}
 
-	return err;
+	return 0;
 }
 
 static int scsi_bus_resume(struct device * dev)
 {
+	struct device_driver *drv = dev->driver;
 	struct scsi_device *sdev = to_scsi_device(dev);
 	struct scsi_host_template *sht = sdev->host->hostt;
-	int err = 0;
+	int err = 0, err2 = 0;
 
+	/* call host resume first */
 	if (sht->resume)
 		err = sht->resume(sdev);
 
+	/* then, call HLD resume */
+	if (drv && drv->resume)
+		err2 = drv->resume(dev);
+
 	scsi_device_resume(sdev);
-	return err;
+
+	/* favor LLD failure */
+	return err ? err : err2;;
 }
 
 struct bus_type scsi_bus_type = {
