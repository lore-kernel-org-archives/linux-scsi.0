From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: scsi_forget_host() and scsi_remove_device()
Date: Fri, 4 Jul 2003 15:36:55 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0307041505110.22716-100000@netrider.rowland.org>
References: <20030703221940.GA5983@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:47108 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S266125AbTGDTW1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Jul 2003 15:22:27 -0400
In-Reply-To: <20030703221940.GA5983@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 3 Jul 2003, Mike Anderson wrote:

> I am still cleaning up a patch set for hosts and devices so it is not
> quite ready for review yet (I got pulled off on to some other issues for
> a few days).
> 
> For scsi devices here is a quick snap shot of what I trying to test.
> 	scsi_device_register:
> 		calls device_initialize on sdev_driverfs_dev
> 		calls class_device_initialize on sdev_classdev
> 		calls device_add on sdev_driverfs_dev
> 		calls class_device_add on sdev_classdev
> 		calls get_device on sdev_driverfs_dev
> 
> 	scsi_device_unregister:
> 		sets a state the scsi_device indicating "delete"
> 		calls class_device_unregister on sdev_classdev
> 
> 	scsi_device_cls_release:
> 		calls put_device on sdev_driverfs_dev
> 
> 	scsi_device_dev_release:
> 		calls device_del sdev_driverfs_dev (I have a hack in here to ensure
> 		device_add was previously called).	
> 		calls scsi_free_sdev
> 
> 	scsi_device_get:
> 		if device state says get ok
> 			calls get_device on sdev_driverfs_dev
> 	(I still have access_count on try_module_get in the function).
> 
> 	scsi_device_put:
> 		calls put_device on sdev_driverfs_dev
> 	(I still have access_count on try_module_put in the function).

Okay, it looks like maybe I'm running up against problems from the areas
that you haven't had time to fix yet.

What I'm seeing is that the host is gone and the device is marked offline, 
but the device structure is still present because sr.c hasn't yet done its 
final scsi_device_put(), since a user process still has the device opened.  

When the user process closes the file, sr.c tries to unlock the door by
calling scsi_set_medium_removal().  This filters through
ioctl_internal_command(), scsi_wait_req(), scsi_do_req(),
scsi_request_fn(), scsi_prep_fn(), scsi_get_command(), and
__scsi_get_command() -- all without noticing that the device is offline!
Finally a segmentation violation occurs when __scsi_get_command() tries to
access dev->host->cmd_pool->gfp_mask.  Not surprising since the host
structure is gone.

[By the way, even to get this far I had to change scsi_device_get() and 
scsi_device_put() to make them do get_device(&sdev->sdev_driverfs_dev) and 
put_device(&sdev->sdev_driverfs_dev).  Without that, the scsi_device's 
refcount would go to 0 and the structure would be deallocated, even though 
sr.c still had outstanding references via scsi_device_get().]

My feeling is that when the device is offline, it should still be okay 
for the higher layers (sr, sd, etc.) to submit SCSI requests.  The check 
for whether the device is still available should be centralized in the 
midlayer instead of spread all over the place.  Such requests should 
simply fail with -ENODEV or something similar.

Below are the changes I made to sr.h and sr.c.

Alan Stern


--- 2.5.74-drivers/scsi/sr.h.orig	Mon Jun 16 15:28:36 2003
+++ 2.5.74-drivers/scsi/sr.h	Fri Jul  4 14:11:29 2003
@@ -35,6 +35,8 @@
 	unsigned xa_flag:1;	/* CD has XA sectors ? */
 	unsigned readcd_known:1;	/* drive supports READ_CD (0xbe) */
 	unsigned readcd_cdda:1;	/* reading audio data using READ_CD */
+	unsigned gone:1;	/* device has been hot-unplugged */
+	unsigned int use_count;	/* number of current users */
 	struct cdrom_device_info cdi;
 	struct gendisk *disk;
 } Scsi_CD;
--- 2.5.74-drivers/scsi/sr.c.orig	Wed Jul  2 11:42:54 2003
+++ 2.5.74-drivers/scsi/sr.c	Fri Jul  4 14:14:23 2003
@@ -86,6 +86,9 @@
 static unsigned long sr_index_bits[SR_DISKS / BITS_PER_LONG];
 static spinlock_t sr_index_lock = SPIN_LOCK_UNLOCKED;
 
+/* prevent races between sr_block_open() and sr_remove() */
+static DECLARE_MUTEX (sr_open_remove_sem);
+
 static int sr_open(struct cdrom_device_info *, int);
 static void sr_release(struct cdrom_device_info *);
 
@@ -386,14 +389,42 @@
 
 static int sr_block_open(struct inode *inode, struct file *file)
 {
-	struct scsi_cd *cd = scsi_cd(inode->i_bdev->bd_disk);
-	return cdrom_open(&cd->cdi, inode, file);
+	struct scsi_cd *cd;
+	int rc;
+
+	down(&sr_open_remove_sem);
+	if (!inode->i_bdev->bd_disk->private_data)
+		rc = -ENODEV;
+	else {
+		cd = scsi_cd(inode->i_bdev->bd_disk);
+		if (cd->gone)
+			rc = -ENODEV;
+		else {
+			++cd->use_count;
+			up(&sr_open_remove_sem);
+			rc = cdrom_open(&cd->cdi, inode, file);
+			down(&sr_open_remove_sem);
+			if (rc) {
+				if (--cd->use_count == 0 && cd->gone)
+					kfree(cd);
+			}
+		}
+	}
+	up(&sr_open_remove_sem);
+	return rc;
 }
 
 static int sr_block_release(struct inode *inode, struct file *file)
 {
+	int rc;
 	struct scsi_cd *cd = scsi_cd(inode->i_bdev->bd_disk);
-	return cdrom_release(&cd->cdi, file);
+
+	rc = cdrom_release(&cd->cdi, file);
+	down(&sr_open_remove_sem);
+	if (--cd->use_count == 0 && cd->gone)
+		kfree(cd);
+	up(&sr_open_remove_sem);
+	return rc;
 }
 
 static int sr_block_ioctl(struct inode *inode, struct file *file, unsigned cmd,
@@ -775,7 +806,11 @@
 
 	put_disk(cd->disk);
 	unregister_cdrom(&cd->cdi);
-	kfree(cd);
+	down(&sr_open_remove_sem);
+	cd->gone = 1;
+	if (!cd->use_count)
+		kfree(cd);
+	up(&sr_open_remove_sem);
 
 	return 0;
 }

