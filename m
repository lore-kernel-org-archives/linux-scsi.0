From: Alex Tomas <bzzz@tmi.comex.ru>
Subject: hot scsi disk resize
Date: 03 Mar 2003 20:21:24 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m3bs0s9xij.fsf@lexa.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@steeleye.com>, Jens Axboe <axboe@suse.de>, Alex Tomas <bzzz@tmi.comex.ru>


Hello!

Here is patch to implement hot scsi resize function.
Modern storage boxes support virtualization feature and
may change logical volume size online. I think it would
be great if linux supports such abilities. Look at
this example:

root@zefir:# dmesg | tail
scsi0:A:1:0: Tagged Queuing enabled.  Depth 32
SCSI device sda: 2097152 512-byte hdwr sectors (1074 MB)
SCSI device sda: drive cache: write through
 sda: unknown partition table
Attached scsi disk sda at scsi0, channel 0, id 1, lun 0

root@zefir:# mount -treiserfs /dev/sda /mnt

root@zefir:# df -Th
Filesystem    Type    Size  Used Avail Use% Mounted on
/dev/hda1     ext3    1.9G  1.8G  138M  93% /
/dev/sda  reiserfs    1.0G   33M  991M   4% /mnt

root@zefir:# echo 'scsi rescan 0 0 1 0' >/proc/scsi/scsi 
root@zefir:# dmesg|tail -n1
SCSI device sda: 20971520 512-byte hdwr sectors (10737 MB)
root@zefir:# resize_reiserfs /dev/sda 

<-------------resize_reiserfs, 2002------------->
reiserfsprogs 3.6.4

root@zefir:# df -Th
Filesystem    Type    Size  Used Avail Use% Mounted on
/dev/hda1     ext3    1.9G  1.8G  138M  93% /
/dev/sda  reiserfs     10G   33M  9.9G   1% /mnt

I think it's really useful for for high-availability systems.
MS Windows has supported online disk resize since 2000. I Would
be happy to hear any comments and suggestions.




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
diff -uNr linux/drivers/scsi/scsi_proc.c edited/drivers/scsi/scsi_proc.c
--- linux/drivers/scsi/scsi_proc.c	Thu Feb 20 13:18:17 2003
+++ edited/drivers/scsi/scsi_proc.c	Mon Mar  3 18:48:16 2003
@@ -551,6 +551,18 @@
 		lun = simple_strtoul(p + 1, &p, 0);
 
 		err = scsi_remove_single_device(host, channel, id, lun);
+		if (err >= 0)
+			err = length;
+	} else if (!strncmp("rescan", buffer + 5, 6)) {
+		p = buffer + 12;
+
+		host = simple_strtoul(p, &p, 0);
+		channel = simple_strtoul(p + 1, &p, 0);
+		id = simple_strtoul(p + 1, &p, 0);
+		lun = simple_strtoul(p + 1, &p, 0);
+		err = scsi_rescan_single_device(host, channel, id, lun);
+		if (err >= 0)
+			err = length;
 	}
 out:
 	
diff -uNr linux/drivers/scsi/scsi_scan.c edited/drivers/scsi/scsi_scan.c
--- linux/drivers/scsi/scsi_scan.c	Thu Feb 20 13:18:17 2003
+++ edited/drivers/scsi/scsi_scan.c	Mon Mar  3 18:48:16 2003
@@ -1796,6 +1796,24 @@
 	return error;
 }
 
+int scsi_rescan_single_device(uint host, uint channel, uint id, uint lun)
+{
+	struct scsi_device *sdev;
+	struct Scsi_Host *shost;
+
+	shost = scsi_host_hn_get(host);
+	if (!shost)
+		return -ENODEV;
+	sdev = scsi_find_device(shost, channel, id, lun);
+	if (!sdev)
+		goto out;
+
+	scsi_rescan_device(sdev);	
+out:
+	scsi_host_put(shost);
+	return 0;
+}
+
 /**
  * scsi_scan_target - scan a target id, possibly including all LUNs on the
  *     target.
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
@@ -623,6 +623,8 @@
 			up(&whole->bd_sem);
 		}
 	} else {
+		if (!part)
+			bd_set_size(bdev,(loff_t)get_capacity(disk)<<9);
 		put_disk(disk);
 		module_put(owner);
 		if (bdev->bd_contains == bdev) {

