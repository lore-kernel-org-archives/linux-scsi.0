From: <alexey@technomagesinc.com>
Subject: Re: hot scsi disk resize
Date: 04 Mar 2003 10:00:18 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m365qz8vlp.fsf@lexa.home.net>
References: <m3bs0s9xij.fsf@lexa.home.net>
	<20030303181536.A30199@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030303181536.A30199@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, Jens Axboe <axboe@suse.de>, alexey@technomagesinc.com, Dennis Gerasimov <denis@technomagesinc.com>


Hi!

Here is new version of the patch. All procfs-related stuff has been removed.
One may rescan device size writing something to /sysfs/.../<scsi device>/rescan:

root@zefir:~# echo 1 >/sysfs/bus/scsi/devices/0\:0\:1\:0/rescan 
root@zefir:~# dmesg
scsi0:A:1:0: Tagged Queuing enabled.  Depth 64
scsi: host 0 channel 0 id 1 lun16384 has a LUN larger than allowed by the host adapter
SCSI device sda: 2097152 512-byte hdwr sectors (1074 MB)
SCSI device sda: drive cache: write through
 sda: unknown partition table
Attached scsi disk sda at scsi0, channel 0, id 1, lun 0
SCSI device sda: 125829120 512-byte hdwr sectors (64425 MB)
root@zefir:~# 



diff -uNr linux/drivers/scsi/hosts.h edited/drivers/scsi/hosts.h
--- linux/drivers/scsi/hosts.h	Thu Feb 20 13:18:16 2003
+++ edited/drivers/scsi/hosts.h	Mon Mar  3 18:48:16 2003
@@ -558,6 +558,7 @@
     void (*detach)(Scsi_Device *);
     int (*init_command)(Scsi_Cmnd *);     /* Used by new queueing code. 
                                            Selects command for blkdevs */
+    void (*rescan)(Scsi_Device *);
     struct device_driver scsi_driverfs_driver;
 };
 
diff -uNr linux/drivers/scsi/scsi.c edited/drivers/scsi/scsi.c
--- linux/drivers/scsi/scsi.c	Thu Feb 20 13:18:17 2003
+++ edited/drivers/scsi/scsi.c	Mon Mar  3 18:48:16 2003
@@ -1510,6 +1510,21 @@
 	up_read(&scsi_devicelist_mutex);
 }
 
+void scsi_rescan_device(struct scsi_device *sdev)
+{
+	struct Scsi_Device_Template *sdt;
+
+	down_read(&scsi_devicelist_mutex);
+	list_for_each_entry(sdt, &scsi_devicelist, list) {
+		if (!try_module_get(sdt->module))
+			continue;
+		if (*sdt->rescan)
+			(*sdt->rescan)(sdev);
+		module_put(sdt->module);
+	}
+	up_read(&scsi_devicelist_mutex);
+}
+
 int scsi_device_get(struct scsi_device *sdev)
 {
 	if (!try_module_get(sdev->host->hostt->module))
diff -uNr linux/drivers/scsi/scsi_sysfs.c edited/drivers/scsi/scsi_sysfs.c
--- linux/drivers/scsi/scsi_sysfs.c	Thu Feb 20 13:18:17 2003
+++ edited/drivers/scsi/scsi_sysfs.c	Tue Mar  4 09:15:42 2003
@@ -219,6 +219,25 @@
 sdev_rd_attr (rev, "%.4s\n");
 sdev_rw_attr_bit (online);
 
+static ssize_t
+show_rescan_field (struct device *dev, char *buf)
+{
+	return 0; 
+}
+
+static ssize_t
+store_rescan_field (struct device *dev, const char *buf, size_t count) 
+{
+	int ret = ENODEV;
+	struct scsi_device *sdev;
+	sdev = to_scsi_device(dev);
+	if (sdev)
+		ret = scsi_rescan_device(sdev);
+	return ret;
+}
+
+static DEVICE_ATTR(rescan, S_IRUGO | S_IWUSR, show_rescan_field, store_rescan_field)
+
 static struct device_attribute * const sdev_attrs[] = {
 	&dev_attr_device_blocked,
 	&dev_attr_queue_depth,
@@ -229,6 +248,7 @@
 	&dev_attr_model,
 	&dev_attr_rev,
 	&dev_attr_online,
+	&dev_attr_rescan,
 };
 
 /**
diff -uNr linux/drivers/scsi/sd.c edited/drivers/scsi/sd.c
--- linux/drivers/scsi/sd.c	Mon Jan 20 02:23:42 2003
+++ edited/drivers/scsi/sd.c	Mon Mar  3 19:19:25 2003
@@ -93,10 +93,12 @@
 
 static int sd_attach(struct scsi_device *);
 static void sd_detach(struct scsi_device *);
+static void sd_rescan(struct scsi_device *);
 static int sd_init_command(struct scsi_cmnd *);
 static int sd_synchronize_cache(struct scsi_disk *, int);
 static int sd_notifier(struct notifier_block *, unsigned long, void *);
-
+static void sd_read_capacity(struct scsi_disk *sdkp, char *diskname,
+		 struct scsi_request *SRpnt, unsigned char *buffer);
 static struct notifier_block sd_notifier_block = {sd_notifier, NULL, 0}; 
 
 static struct Scsi_Device_Template sd_template = {
@@ -106,6 +108,7 @@
 	.scsi_type	= TYPE_DISK,
 	.attach		= sd_attach,
 	.detach		= sd_detach,
+	.rescan		= sd_rescan,
 	.init_command	= sd_init_command,
 	.scsi_driverfs_driver = {
 		.name   = "sd",
@@ -627,6 +630,38 @@
 not_present:
 	set_media_not_present(sdkp);
 	return 1;
+}
+
+static void sd_rescan(struct scsi_device * sdp)
+{
+	unsigned char *buffer;
+	struct scsi_disk *sdkp = sd_find_by_sdev(sdp);
+	struct gendisk *gd;
+	struct scsi_request *SRpnt;
+
+	if (!sdkp || sdp->online == FALSE || !sdkp->media_present)
+		return;
+		
+	gd = sdkp->disk;
+	
+	SCSI_LOG_HLQUEUE(3, printk("sd_rescan: disk=%s\n", gd->disk_name));
+	
+	SRpnt = scsi_allocate_request(sdp);
+	if (!SRpnt) {
+		printk(KERN_WARNING "(sd_rescan:) Request allocation "
+		       "failure.\n");
+		return;
+	}
+
+	if (sdkp->device->host->unchecked_isa_dma)
+		buffer = kmalloc(512, GFP_DMA);
+	else
+		buffer = kmalloc(512, GFP_KERNEL);
+
+    	sd_read_capacity(sdkp, gd->disk_name, SRpnt, buffer);
+	set_capacity(gd, sdkp->capacity);	
+	scsi_release_request(SRpnt);
+	kfree(buffer);
 }
 
 static int sd_revalidate_disk(struct gendisk *disk)
diff -uNr linux/fs/block_dev.c edited/fs/block_dev.c
--- linux/fs/block_dev.c	Mon Jan 20 02:23:49 2003
+++ edited/fs/block_dev.c	Mon Mar  3 18:49:47 2003
@@ -546,7 +546,7 @@
 	return res;
 }
 
-static void bd_set_size(struct block_device *bdev, loff_t size)
+void bd_set_size(struct block_device *bdev, loff_t size)
 {
 	unsigned bsize = bdev_hardsect_size(bdev);
 	bdev->bd_inode->i_size = size;
@@ -623,6 +623,8 @@
 			up(&whole->bd_sem);
 		}
 	} else {
+		if (!part)
+			bd_set_size(bdev,(loff_t)get_capacity(disk)<<9);
 		put_disk(disk);
 		module_put(owner);
 		if (bdev->bd_contains == bdev) {


