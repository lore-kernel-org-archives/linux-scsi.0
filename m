From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix sr device number handling
Date: Fri, 29 Nov 2002 23:30:23 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021129233023.A13089@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, axboe@suse.de
Cc: linux-scsi@vger.kernel.org

The same for sr (I didn't actually had a chance to actually test this,
but it's the same change as in sd).


--- 1.68/drivers/scsi/sr.c	Thu Nov 28 15:09:53 2002
+++ edited/drivers/scsi/sr.c	Fri Nov 29 23:25:16 2002
@@ -32,8 +32,6 @@
  *	check resource allocation in sr_init and some cleanups
  */
 
-#define MAJOR_NR SCSI_CDROM_MAJOR
-
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/kernel.h>
@@ -57,6 +55,9 @@
 
 MODULE_PARM(xa_test, "i");	/* see sr_ioctl.c */
 
+
+#define SR_DISKS	(1 << KDEV_MINOR_BITS)
+
 #define MAX_RETRIES	3
 #define SR_TIMEOUT	(30 * HZ)
 #define SR_CAPABILITIES \
@@ -82,10 +83,12 @@
 	},
 };
 
-static int sr_nr_dev;	/* XXX(hch) bad hack, we want a bitmap instead */
 static LIST_HEAD(sr_devlist);
 static spinlock_t sr_devlist_lock = SPIN_LOCK_UNLOCKED;
 
+static unsigned long sr_index_bits[SR_DISKS / BITS_PER_LONG];
+static spinlock_t sr_index_lock = SPIN_LOCK_UNLOCKED;
+
 static int sr_open(struct cdrom_device_info *, int);
 static void sr_release(struct cdrom_device_info *);
 
@@ -514,16 +517,17 @@
 	if (!disk)
 		goto fail_free;
 
-	/*
-	 * XXX  This doesn't make us better than the previous code in the
-	 * XXX  end (not worse either, though..).
-	 * XXX  To properly support hotplugging we should have a bitmap and
-	 * XXX  use find_first_zero_bit on it.  This will happen at the
-	 * XXX  same time template->nr_* goes away.		--hch
-	 */
-	minor = sr_nr_dev++;
+	spin_lock(&sr_index_lock);
+	minor = find_first_zero_bit(sr_index_bits, SR_DISKS);
+	if (minor == SR_DISKS) {
+		spin_unlock(&sr_index_lock);
+		error = -EBUSY;
+		goto fail_put;
+	}
+	__set_bit(minor, sr_index_bits);
+	spin_unlock(&sr_index_lock);
 
-	disk->major = MAJOR_NR;
+	disk->major = SCSI_CDROM_MAJOR;
 	disk->first_minor = minor;
 	sprintf(disk->disk_name, "sr%d", minor);
 	disk->fops = &sr_bdops;
@@ -570,6 +574,8 @@
 	    sdev->id, sdev->lun);
 	return 0;
 
+fail_put:
+	put_disk(disk);
 fail_free:
 	kfree(cd);
 fail:
@@ -802,13 +808,15 @@
 		return;
 
 	sr_devlist_remove(cd);
+	scsi_slave_detach(SDp);
 	del_gendisk(cd->disk);
-	put_disk(cd->disk);
-	unregister_cdrom(&cd->cdi);
 
-	scsi_slave_detach(SDp);
-	sr_nr_dev--;
+	spin_lock(&sr_index_lock);
+	clear_bit(cd->disk->first_minor, sr_index_bits);
+	spin_unlock(&sr_index_lock);
 
+	put_disk(cd->disk);
+	unregister_cdrom(&cd->cdi);
 	kfree(cd);
 }
 
@@ -816,7 +824,7 @@
 {
 	int rc;
 
-	rc = register_blkdev(MAJOR_NR, "sr", &sr_bdops);
+	rc = register_blkdev(SCSI_CDROM_MAJOR, "sr", &sr_bdops);
 	if (rc)
 		return rc;
 	return scsi_register_device(&sr_template);
@@ -825,7 +833,7 @@
 static void __exit exit_sr(void)
 {
 	scsi_unregister_device(&sr_template);
-	unregister_blkdev(MAJOR_NR, "sr");
+	unregister_blkdev(SCSI_CDROM_MAJOR, "sr");
 }
 
 module_init(init_sr);
