From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] st: mutex conversion
Date: Tue, 31 Jan 2006 18:15:19 +0100
Message-ID: <20060131171519.GA28889@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:10673 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1751267AbWAaRPZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Jan 2006 12:15:25 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

switch st from semaphores to mutexes


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/st.c
===================================================================
--- linux-2.6.orig/drivers/scsi/st.c	2006-01-31 12:23:38.000000000 +0100
+++ linux-2.6/drivers/scsi/st.c	2006-01-31 13:50:36.000000000 +0100
@@ -1481,7 +1481,7 @@
 	struct st_buffer *STbp;
 	char *name = tape_name(STp);
 
-	if (down_interruptible(&STp->lock))
+	if (mutex_lock_interruptible(&STp->lock))
 		return -ERESTARTSYS;
 
 	retval = rw_checks(STp, filp, count);
@@ -1732,7 +1732,7 @@
 	if (SRpnt != NULL)
 		st_release_request(SRpnt);
 	release_buffering(STp, 0);
-	up(&STp->lock);
+	mutex_unlock(&STp->lock);
 
 	return retval;
 }
@@ -1938,7 +1938,7 @@
 	struct st_buffer *STbp = STp->buffer;
 	DEB( char *name = tape_name(STp); )
 
-	if (down_interruptible(&STp->lock))
+	if (mutex_lock_interruptible(&STp->lock))
 		return -ERESTARTSYS;
 
 	retval = rw_checks(STp, filp, count);
@@ -2063,7 +2063,7 @@
 		release_buffering(STp, 1);
 		STbp->buffer_bytes = 0;
 	}
-	up(&STp->lock);
+	mutex_unlock(&STp->lock);
 
 	return retval;
 }
@@ -3217,7 +3217,7 @@
 	char *name = tape_name(STp);
 	void __user *p = (void __user *)arg;
 
-	if (down_interruptible(&STp->lock))
+	if (mutex_lock_interruptible(&STp->lock))
 		return -ERESTARTSYS;
 
         DEB(
@@ -3528,7 +3528,7 @@
 			retval = (-EFAULT);
 		goto out;
 	}
-	up(&STp->lock);
+	mutex_unlock(&STp->lock);
 	switch (cmd_in) {
 		case SCSI_IOCTL_GET_IDLUN:
 		case SCSI_IOCTL_GET_BUS_NUMBER:
@@ -3553,7 +3553,7 @@
 	return retval;
 
  out:
-	up(&STp->lock);
+	mutex_unlock(&STp->lock);
 	return retval;
 }
 
@@ -4023,7 +4023,7 @@
 
 	tpnt->density_changed = tpnt->compression_changed =
 	    tpnt->blksize_changed = 0;
-	init_MUTEX(&tpnt->lock);
+	mutex_init(&tpnt->lock);
 
 	st_nr_dev++;
 	write_unlock(&st_dev_arr_lock);
Index: linux-2.6/drivers/scsi/st.h
===================================================================
--- linux-2.6.orig/drivers/scsi/st.h	2006-01-06 12:51:02.000000000 +0100
+++ linux-2.6/drivers/scsi/st.h	2006-01-31 13:50:53.000000000 +0100
@@ -4,6 +4,7 @@
 
 #include <linux/completion.h>
 #include <linux/kref.h>
+#include <linux/mutex.h>
 #include <scsi/scsi_cmnd.h>
 
 /* Descriptor for analyzed sense data */
@@ -99,7 +100,7 @@
 struct scsi_tape {
 	struct scsi_driver *driver;
 	struct scsi_device *device;
-	struct semaphore lock;	/* For serialization */
+	struct mutex lock;	/* For serialization */
 	struct completion wait;	/* For SCSI commands */
 	struct st_buffer *buffer;
 
