From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: bug 2400
Date: 06 Apr 2004 08:56:45 -0500
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <1081259807.1804.9.camel@mulgrave>
References: <20040401131502.41136788.akpm@osdl.org>
	<1080862354.2118.78.camel@mulgrave> <1080949016.1804.161.camel@mulgrave>
	<20040404213307.A29446@beaverton.ibm.com>
	<1081199233.2105.45.camel@mulgrave>  <20040406092244.GH28109@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <20040406092244.GH28109@suse.de>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Jens Axboe <axboe@suse.de>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Andrew Morton <akpm@osdl.org>, greg@kroah.com, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2004-04-06 at 04:22, Jens Axboe wrote:
> Really? It doesn't even compile :-)

Heh, I really must learn that I have to copy the file from the test
machine to the email machine *before* attaching it.  You got a stale
copy of an older incarnation, I think.

The attached (hopefully) is what I compiled and tested with.  The test,
incidentally, is simply to hold the device open and then forcibly remove
it using scsi remove-single-device before closing it.

James

===== drivers/scsi/sr.c 1.103 vs edited =====
--- 1.103/drivers/scsi/sr.c	Fri Apr  2 11:30:44 2004
+++ edited/drivers/scsi/sr.c	Tue Apr  6 08:49:30 2004
@@ -113,6 +113,28 @@
 	.generic_packet		= sr_packet,
 };
 
+static void sr_kobject_release(struct kobject *kobj);
+
+static struct kobj_type scsi_cdrom_kobj_type = {
+	.release = sr_kobject_release,
+};
+
+/*
+ * The get and put routines for the struct scsi_cd.  Note this entity
+ * has a scsi_device pointer and owns a reference to this.
+ */
+static inline int scsi_cd_get(struct scsi_cd *cd)
+{
+	if (!kobject_get(&cd->kobj))
+		return -ENODEV;
+	return 0;
+}
+
+static inline void scsi_cd_put(struct scsi_cd *cd)
+{
+	kobject_put(&cd->kobj);
+}
+
 /*
  * This function checks to see if the media has been changed in the
  * CDROM drive.  It is possible that we have already sensed a change,
@@ -424,8 +446,15 @@
 
 static int sr_block_release(struct inode *inode, struct file *file)
 {
+	int ret;
 	struct scsi_cd *cd = scsi_cd(inode->i_bdev->bd_disk);
-	return cdrom_release(&cd->cdi, file);
+	ret = cdrom_release(&cd->cdi, file);
+	if(ret)
+		return ret;
+	
+	scsi_cd_put(cd);
+
+	return 0;
 }
 
 static int sr_block_ioctl(struct inode *inode, struct file *file, unsigned cmd,
@@ -467,7 +496,7 @@
 	struct scsi_device *sdev = cd->device;
 	int retval;
 
-	retval = scsi_device_get(sdev);
+	retval = scsi_cd_get(cd);
 	if (retval)
 		return retval;
 	
@@ -489,7 +518,7 @@
 	return 0;
 
 error_out:
-	scsi_device_put(sdev);
+	scsi_cd_put(cd);
 	return retval;	
 }
 
@@ -500,7 +529,6 @@
 	if (cd->device->sector_size > 2048)
 		sr_set_blocklength(cd, 2048);
 
-	scsi_device_put(cd->device);
 }
 
 static int sr_probe(struct device *dev)
@@ -514,12 +542,18 @@
 	if (sdev->type != TYPE_ROM && sdev->type != TYPE_WORM)
 		goto fail;
 
+	if ((error = scsi_device_get(sdev)) != 0)
+		goto fail;
+
 	error = -ENOMEM;
 	cd = kmalloc(sizeof(*cd), GFP_KERNEL);
 	if (!cd)
-		goto fail;
+		goto fail_put_sdev;
 	memset(cd, 0, sizeof(*cd));
 
+	kobject_init(&cd->kobj);
+	cd->kobj.ktype = &scsi_cdrom_kobj_type;
+
 	disk = alloc_disk(1);
 	if (!disk)
 		goto fail_free;
@@ -588,6 +622,8 @@
 	put_disk(disk);
 fail_free:
 	kfree(cd);
+fail_put_sdev:
+	scsi_device_put(sdev);
 fail:
 	return error;
 }
@@ -863,19 +899,31 @@
 	return cgc->stat;
 }
 
-static int sr_remove(struct device *dev)
+static void sr_kobject_release(struct kobject *kobj)
 {
-	struct scsi_cd *cd = dev_get_drvdata(dev);
-
-	del_gendisk(cd->disk);
+	struct scsi_cd *cd = container_of(kobj, struct scsi_cd, kobj);
+	struct scsi_device *sdev = cd->device;
 
 	spin_lock(&sr_index_lock);
 	clear_bit(cd->disk->first_minor, sr_index_bits);
 	spin_unlock(&sr_index_lock);
 
-	put_disk(cd->disk);
 	unregister_cdrom(&cd->cdi);
+
+	put_disk(cd->disk);
+
 	kfree(cd);
+
+	scsi_device_put(sdev);
+}
+
+static int sr_remove(struct device *dev)
+{
+	struct scsi_cd *cd = dev_get_drvdata(dev);
+
+	del_gendisk(cd->disk);
+
+	scsi_cd_put(cd);
 
 	return 0;
 }



-------------------------------------------------------
This SF.Net email is sponsored by: IBM Linux Tutorials
Free Linux tutorial presented by Daniel Robbins, President and CEO of
GenToo technologies. Learn everything from fundamentals to system
administration.http://ads.osdn.com/?ad_id=1470&alloc_id=3638&op=click
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
