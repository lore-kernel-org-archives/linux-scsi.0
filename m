From: Jens Axboe <axboe@suse.de>
Subject: Re: bug 2400
Date: Mon, 5 Apr 2004 16:03:10 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040405140309.GF9422@suse.de>
References: <20040401131502.41136788.akpm@osdl.org> <1080862354.2118.78.camel@mulgrave> <1080949016.1804.161.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:2976 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262497AbUDEOD3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Apr 2004 10:03:29 -0400
Content-Disposition: inline
In-Reply-To: <1080949016.1804.161.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andrew Morton <akpm@osdl.org>, greg@kroah.com, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Apr 02 2004, James Bottomley wrote:
> On Thu, 2004-04-01 at 18:32, James Bottomley wrote:
> > Now, the questions are, whose issue is this and how do we fix it?  I can
> > see that a driver needs early notification of unplugs so it can deny all
> > access to a gone device.  On the other hand, for a user land open where
> > we still have to hold resources in the driver, we'd like the driver to
> > have a notify when the device reference count drops to zero so we can
> > clean up.
> 
> OK, I think this is easily fixable in sr.c by moving around the release
> code to do the right thing (and not drop the reference to sdev_gendev
> until we're completely finished).
> 
> Jens, does this look OK (or have I just opened up another race window
> somewhere else)?

Doesn't quite work, how about something like this as a work-around?

diff -ur /mnt/kscratch/linux-2.6.4/drivers/cdrom/cdrom.c linux-2.6.4-SUSE-20040402/drivers/cdrom/cdrom.c
--- /mnt/kscratch/linux-2.6.4/drivers/cdrom/cdrom.c	2004-04-02 14:53:42.000000000 +0200
+++ linux-2.6.4-SUSE-20040402/drivers/cdrom/cdrom.c	2004-04-05 15:43:01.603675727 +0200
@@ -379,6 +379,8 @@
 #endif /* CONFIG_SYSCTL */ 
 	}
 
+	atomic_set(&cdi->all_use, 1);
+
 	ENSURE(drive_status, CDC_DRIVE_STATUS );
 	ENSURE(media_changed, CDC_MEDIA_CHANGED);
 	ENSURE(tray_move, CDC_CLOSE_TRAY | CDC_OPEN_TRAY);
@@ -425,6 +427,9 @@
 	struct cdrom_device_info *cdi, *prev;
 	cdinfo(CD_OPEN, "entering unregister_cdrom\n"); 
 
+	if (!atomic_dec_and_test(&unreg->all_use))
+		return -EBUSY;
+
 	prev = NULL;
 	spin_lock(&cdrom_lock);
 	cdi = topCdromPtr;
@@ -891,6 +896,8 @@
 	if (ret)
 		goto err;
 
+	atomic_inc(&cdi->all_use);
+
 	cdinfo(CD_OPEN, "Use count for \"/dev/%s\" now %d\n",
 			cdi->name, cdi->use_count);
 	/* Do this on open.  Don't wait for mount, because they might
@@ -1096,6 +1103,7 @@
 		    cdi->options & CDO_AUTO_EJECT && CDROM_CAN(CDC_OPEN_TRAY))
 			cdo->tray_move(cdi, 1);
 	}
+
 	return 0;
 }
 
diff -ur /mnt/kscratch/linux-2.6.4/drivers/scsi/sr.c linux-2.6.4-SUSE-20040402/drivers/scsi/sr.c
--- /mnt/kscratch/linux-2.6.4/drivers/scsi/sr.c	2004-04-02 14:53:42.000000000 +0200
+++ linux-2.6.4-SUSE-20040402/drivers/scsi/sr.c	2004-04-05 15:57:35.577714398 +0200
@@ -419,13 +419,36 @@
 static int sr_block_open(struct inode *inode, struct file *file)
 {
 	struct scsi_cd *cd = scsi_cd(inode->i_bdev->bd_disk);
-	return cdrom_open(&cd->cdi, inode, file);
+	struct scsi_device *sdev = cd->device;
+	int retval;
+
+	retval = scsi_device_get(sdev);
+	if (retval)
+		return retval;
+	
+	retval = cdrom_open(&cd->cdi, inode, file);
+	if (retval)
+		scsi_device_put(sdev);
+
+	return retval;
+}
+
+static void sr_cleanup(struct scsi_cd *cd)
+{
+	if (!unregister_cdrom(&cd->cdi)) {
+		scsi_device_put(cd->device);
+		kfree(cd);
+	}
 }
 
 static int sr_block_release(struct inode *inode, struct file *file)
 {
 	struct scsi_cd *cd = scsi_cd(inode->i_bdev->bd_disk);
-	return cdrom_release(&cd->cdi, file);
+	int ret;
+
+	ret = cdrom_release(&cd->cdi, file);
+	sr_cleanup(cd);
+	return ret;
 }
 
 static int sr_block_ioctl(struct inode *inode, struct file *file, unsigned cmd,
@@ -467,10 +490,6 @@
 	struct scsi_device *sdev = cd->device;
 	int retval;
 
-	retval = scsi_device_get(sdev);
-	if (retval)
-		return retval;
-	
 	/*
 	 * If the device is in error recovery, wait until it is done.
 	 * If the device is offline, then disallow any access to it.
@@ -499,8 +518,6 @@
 
 	if (cd->device->sector_size > 2048)
 		sr_set_blocklength(cd, 2048);
-
-	scsi_device_put(cd->device);
 }
 
 static int sr_probe(struct device *dev)
@@ -874,8 +891,8 @@
 	spin_unlock(&sr_index_lock);
 
 	put_disk(cd->disk);
-	unregister_cdrom(&cd->cdi);
-	kfree(cd);
+
+	sr_cleanup(cd);
 
 	return 0;
 }
diff -ur /mnt/kscratch/linux-2.6.4/include/linux/cdrom.h linux-2.6.4-SUSE-20040402/include/linux/cdrom.h
--- /mnt/kscratch/linux-2.6.4/include/linux/cdrom.h	2004-04-02 14:53:42.000000000 +0200
+++ linux-2.6.4-SUSE-20040402/include/linux/cdrom.h	2004-04-05 15:10:46.347243055 +0200
@@ -916,6 +916,7 @@
 
 /* Uniform cdrom data structures for cdrom.c */
 struct cdrom_device_info {
+	atomic_t all_use;
 	struct cdrom_device_ops  *ops;  /* link to device_ops */
 	struct cdrom_device_info *next; /* next device_info for this major */
 	struct gendisk *disk;		/* matching block layer disk */

-- 
Jens Axboe

