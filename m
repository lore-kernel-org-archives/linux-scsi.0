From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] osst: mutex conversion
Date: Tue, 31 Jan 2006 18:16:03 +0100
Message-ID: <20060131171603.GB28889@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:21169 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1751268AbWAaRQG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Jan 2006 12:16:06 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: osst@riede.org, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

switch osst from semaphores to mutexes


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/osst.c
===================================================================
--- linux-2.6.orig/drivers/scsi/osst.c	2005-11-07 21:30:09.000000000 +0100
+++ linux-2.6/drivers/scsi/osst.c	2006-01-31 14:01:36.000000000 +0100
@@ -3243,7 +3243,7 @@
 	char		    * name = tape_name(STp);
 
 
-	if (down_interruptible(&STp->lock))
+	if (mutex_lock_interruptible(&STp->lock))
 		return (-ERESTARTSYS);
 
 	/*
@@ -3545,7 +3545,7 @@
 out:
 	if (SRpnt != NULL) scsi_release_request(SRpnt);
 
-	up(&STp->lock);
+	mutex_unlock(&STp->lock);
 
 	return retval;
 }
@@ -3564,7 +3564,7 @@
 	char		    * name  = tape_name(STp);
 
 
-	if (down_interruptible(&STp->lock))
+	if (mutex_lock_interruptible(&STp->lock))
 		return (-ERESTARTSYS);
 
 	/*
@@ -3730,7 +3730,7 @@
 out:
 	if (SRpnt != NULL) scsi_release_request(SRpnt);
 
-	up(&STp->lock);
+	mutex_unlock(&STp->lock);
 
 	return retval;
 }
@@ -4798,7 +4798,7 @@
 	char		    * name  = tape_name(STp);
 	void	    __user  * p     = (void __user *)arg;
 
-	if (down_interruptible(&STp->lock))
+	if (mutex_lock_interruptible(&STp->lock))
 		return -ERESTARTSYS;
 
 #if DEBUG
@@ -5109,14 +5109,14 @@
 	}
 	if (SRpnt) scsi_release_request(SRpnt);
 
-	up(&STp->lock);
+	mutex_unlock(&STp->lock);
 
 	return scsi_ioctl(STp->device, cmd_in, p);
 
 out:
 	if (SRpnt) scsi_release_request(SRpnt);
 
-	up(&STp->lock);
+	mutex_unlock(&STp->lock);
 
 	return retval;
 }
@@ -5792,7 +5792,7 @@
 	tpnt->modes[2].defined = 1;
 	tpnt->density_changed = tpnt->compression_changed = tpnt->blksize_changed = 0;
 
-	init_MUTEX(&tpnt->lock);
+	mutex_init(&tpnt->lock);
 	osst_nr_dev++;
 	write_unlock(&os_scsi_tapes_lock);
 	{
Index: linux-2.6/drivers/scsi/osst.h
===================================================================
--- linux-2.6.orig/drivers/scsi/osst.h	2005-10-31 12:23:46.000000000 +0100
+++ linux-2.6/drivers/scsi/osst.h	2006-01-31 14:00:24.000000000 +0100
@@ -5,6 +5,7 @@
 #include <asm/byteorder.h>
 #include <linux/config.h>
 #include <linux/completion.h>
+#include <linux/mutex.h>
 
 /*	FIXME - rename and use the following two types or delete them!
  *              and the types really should go to st.h anyway...
@@ -532,7 +533,7 @@
   struct scsi_driver *driver;
   unsigned capacity;
   struct scsi_device *device;
-  struct semaphore lock;       /* for serialization */
+  struct mutex lock;       /* for serialization */
   struct completion wait;      /* for SCSI commands */
   struct osst_buffer * buffer;
 
