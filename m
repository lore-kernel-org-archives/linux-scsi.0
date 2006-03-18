From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] allow displaying and setting of cache type via sysfs
Date: Sat, 18 Mar 2006 14:14:21 -0600
Message-ID: <1142712861.3773.6.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:47812 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750902AbWCRUOW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Mar 2006 15:14:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: axboe@suse.de

I think I promised to do this two years ago

This patch adds a scsi_disk class with the cache type and FUA
parameters, so user land application can easily obtain them without
having to parse dmesg.  It also allows setting the cache type (use with
care...)

This patch is a bit dangerous because I've replaced the disk kref with a
class device reference ...

James

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3b01e5d..024ef86 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -47,7 +47,6 @@
 #include <linux/init.h>
 #include <linux/blkdev.h>
 #include <linux/blkpg.h>
-#include <linux/kref.h>
 #include <linux/delay.h>
 #include <linux/mutex.h>
 #include <asm/uaccess.h>
@@ -115,12 +114,10 @@ MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_DISK15_
  */
 #define SD_BUF_SIZE		512
 
-static void scsi_disk_release(struct kref *kref);
-
 struct scsi_disk {
 	struct scsi_driver *driver;	/* always &sd_template */
 	struct scsi_device *device;
-	struct kref	kref;
+	struct class_device cdev;
 	struct gendisk	*disk;
 	unsigned int	openers;	/* protected by BKL for now, yuck */
 	sector_t	capacity;	/* size in 512-byte sectors */
@@ -131,6 +128,7 @@ struct scsi_disk {
 	unsigned	RCD : 1;	/* state of disk RCD bit, unused */
 	unsigned	DPOFUA : 1;	/* state of disk DPOFUA bit */
 };
+#define to_scsi_disk(obj) container_of(obj,struct scsi_disk,cdev)
 
 static DEFINE_IDR(sd_index_idr);
 static DEFINE_SPINLOCK(sd_index_lock);
@@ -152,6 +150,92 @@ static int sd_issue_flush(struct device 
 static void sd_prepare_flush(request_queue_t *, struct request *);
 static void sd_read_capacity(struct scsi_disk *sdkp, char *diskname,
 			     unsigned char *buffer);
+static void scsi_disk_release(struct class_device *cdev);
+
+static const char *sd_cache_types[] = {
+	"write through", "none", "write back",
+	"write back, no read (daft)"
+};
+
+static ssize_t sd_store_cache_type(struct class_device *cdev, const char *buf,
+				   size_t count)
+{
+	int i, ct = -1, rcd, wce, sp;
+	struct scsi_disk *sdkp = to_scsi_disk(cdev);
+	struct scsi_device *sdp = sdkp->device;
+	char buffer[64];
+	char *buffer_data;
+	struct scsi_mode_data data;
+	struct scsi_sense_hdr sshdr;
+	int len;
+
+	if (sdp->type != TYPE_DISK)
+		/* no cache control on RBC devices; theoretically they
+		 * can do it, but there's probably so many exceptions
+		 * it's not worth the risk */
+		return -EINVAL;
+
+	for (i = 0; i < sizeof(sd_cache_types)/sizeof(sd_cache_types[0]); i++) {
+		const int len = strlen(sd_cache_types[i]);
+		if (strncmp(sd_cache_types[i], buf, len) == 0 &&
+		    buf[len] == '\n') {
+			ct = i;
+			break;
+		}
+	}
+	if (ct < 0)
+		return -EINVAL;
+	rcd = ct & 0x01 ? 1 : 0;
+	wce = ct & 0x02 ? 1 : 0;
+	if (scsi_mode_sense(sdp, 0x08, 8, buffer, sizeof(buffer), SD_TIMEOUT,
+			    SD_MAX_RETRIES, &data, NULL))
+		return -EINVAL;
+	len = min(sizeof(buffer), data.length - data.header_length -
+		  data.block_descriptor_length);
+	buffer_data = buffer + data.header_length +
+		data.block_descriptor_length;
+	buffer_data[2] &= ~0x05;
+	buffer_data[2] |= wce << 2 | rcd;
+	sp = buffer_data[0] & 0x80 ? 1 : 0;
+
+	if (scsi_mode_select(sdp, 1, sp, 8, buffer_data, len, SD_TIMEOUT,
+			     SD_MAX_RETRIES, &data, &sshdr)) {
+		if (scsi_sense_valid(&sshdr))
+			scsi_print_sense_hdr(sdkp->disk->disk_name, &sshdr);
+		return -EINVAL;
+	}
+	sd_revalidate_disk(sdkp->disk);
+	return count;
+}
+
+static ssize_t sd_show_cache_type(struct class_device *cdev, char *buf)
+{
+	struct scsi_disk *sdkp = to_scsi_disk(cdev);
+	int ct = sdkp->RCD + 2*sdkp->WCE;
+
+	return snprintf(buf, 40, "%s\n", sd_cache_types[ct]);
+}
+
+static ssize_t sd_show_fua(struct class_device *cdev, char *buf)
+{
+	struct scsi_disk *sdkp = to_scsi_disk(cdev);
+
+	return snprintf(buf, 20, "%u\n", sdkp->DPOFUA);
+}
+
+static struct class_device_attribute sd_disk_attrs[] = {
+	__ATTR(cache_type, S_IRUGO|S_IWUSR, sd_show_cache_type,
+	       sd_store_cache_type),
+	__ATTR(FUA, S_IRUGO, sd_show_fua, NULL),
+	__ATTR_NULL,
+};
+
+static struct class sd_disk_class = {
+	.name		= "scsi_disk",
+	.owner		= THIS_MODULE,
+	.release	= scsi_disk_release,
+	.class_dev_attrs = sd_disk_attrs,
+};
 
 static struct scsi_driver sd_template = {
 	.owner			= THIS_MODULE,
@@ -195,8 +279,6 @@ static int sd_major(int major_idx)
 	}
 }
 
-#define to_scsi_disk(obj) container_of(obj,struct scsi_disk,kref)
-
 static inline struct scsi_disk *scsi_disk(struct gendisk *disk)
 {
 	return container_of(disk->private_data, struct scsi_disk, driver);
@@ -209,7 +291,7 @@ static struct scsi_disk *__scsi_disk_get
 	if (disk->private_data) {
 		sdkp = scsi_disk(disk);
 		if (scsi_device_get(sdkp->device) == 0)
-			kref_get(&sdkp->kref);
+			class_device_get(&sdkp->cdev);
 		else
 			sdkp = NULL;
 	}
@@ -243,7 +325,7 @@ static void scsi_disk_put(struct scsi_di
 	struct scsi_device *sdev = sdkp->device;
 
 	mutex_lock(&sd_ref_mutex);
-	kref_put(&sdkp->kref, scsi_disk_release);
+	class_device_put(&sdkp->cdev);
 	scsi_device_put(sdev);
 	mutex_unlock(&sd_ref_mutex);
 }
@@ -1381,10 +1463,6 @@ sd_read_cache_type(struct scsi_disk *sdk
 	res = sd_do_mode_sense(sdp, dbd, modepage, buffer, len, &data, &sshdr);
 
 	if (scsi_status_is_good(res)) {
-		const char *types[] = {
-			"write through", "none", "write back",
-			"write back, no read (daft)"
-		};
 		int ct = 0;
 		int offset = data.header_length + data.block_descriptor_length;
 
@@ -1417,7 +1495,7 @@ sd_read_cache_type(struct scsi_disk *sdk
 		ct =  sdkp->RCD + 2*sdkp->WCE;
 
 		printk(KERN_NOTICE "SCSI device %s: drive cache: %s%s\n",
-		       diskname, types[ct],
+		       diskname, sd_cache_types[ct],
 		       sdkp->DPOFUA ? " w/ FUA" : "");
 
 		return;
@@ -1548,8 +1626,6 @@ static int sd_probe(struct device *dev)
 	if (!sdkp)
 		goto out;
 
-	kref_init(&sdkp->kref);
-
 	gd = alloc_disk(16);
 	if (!gd)
 		goto out_free;
@@ -1566,7 +1642,16 @@ static int sd_probe(struct device *dev)
 	if (error)
 		goto out_put;
 
+	class_device_initialize(&sdkp->cdev);
+	sdkp->cdev.dev = &sdp->sdev_gendev;
+	sdkp->cdev.class = &sd_disk_class;
+	strncpy(sdkp->cdev.class_id, sdp->sdev_gendev.bus_id, BUS_ID_SIZE);
+
+	if (class_device_add(&sdkp->cdev))
+		goto out_put;
+
 	get_device(&sdp->sdev_gendev);
+
 	sdkp->device = sdp;
 	sdkp->driver = &sd_template;
 	sdkp->disk = gd;
@@ -1616,11 +1701,11 @@ static int sd_probe(struct device *dev)
 
 	return 0;
 
-out_put:
+ out_put:
 	put_disk(gd);
-out_free:
+ out_free:
 	kfree(sdkp);
-out:
+ out:
 	return error;
 }
 
@@ -1639,12 +1724,13 @@ static int sd_remove(struct device *dev)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
+	class_device_del(&sdkp->cdev);
 	del_gendisk(sdkp->disk);
 	sd_shutdown(dev);
 
 	mutex_lock(&sd_ref_mutex);
 	dev_set_drvdata(dev, NULL);
-	kref_put(&sdkp->kref, scsi_disk_release);
+	class_device_put(&sdkp->cdev);
 	mutex_unlock(&sd_ref_mutex);
 
 	return 0;
@@ -1652,16 +1738,16 @@ static int sd_remove(struct device *dev)
 
 /**
  *	scsi_disk_release - Called to free the scsi_disk structure
- *	@kref: pointer to embedded kref
+ *	@cdev: pointer to embedded class device
  *
  *	sd_ref_mutex must be held entering this routine.  Because it is
  *	called on last put, you should always use the scsi_disk_get()
  *	scsi_disk_put() helpers which manipulate the semaphore directly
- *	and never do a direct kref_put().
+ *	and never do a direct class_device_put().
  **/
-static void scsi_disk_release(struct kref *kref)
+static void scsi_disk_release(struct class_device *cdev)
 {
-	struct scsi_disk *sdkp = to_scsi_disk(kref);
+	struct scsi_disk *sdkp = to_scsi_disk(cdev);
 	struct gendisk *disk = sdkp->disk;
 	
 	spin_lock(&sd_index_lock);
@@ -1715,6 +1801,8 @@ static int __init init_sd(void)
 	if (!majors)
 		return -ENODEV;
 
+	class_register(&sd_disk_class);
+
 	return scsi_register_driver(&sd_template.gendrv);
 }
 
@@ -1732,6 +1820,8 @@ static void __exit exit_sd(void)
 	scsi_unregister_driver(&sd_template.gendrv);
 	for (i = 0; i < SD_MAJORS; i++)
 		unregister_blkdev(sd_major(i), "sd");
+
+	class_unregister(&sd_disk_class);
 }
 
 module_init(init_sd);


