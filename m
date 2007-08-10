From: akpm@linux-foundation.org
Subject: [patch 17/30] Use mutex instead of semaphore in the OnStream SCSI Tape driver
Date: Fri, 10 Aug 2007 14:50:44 -0700
Message-ID: <200708102150.l7ALoinx011368@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43776 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755134AbXHJWCQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Aug 2007 18:02:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, matthias.kaehlcke@gmail.com, satyam@infradead.org

From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The OnStream SCSI Tape driver uses a semaphore as mutex.  Use the mutex API
instead of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Reviewed-by: Satyam Sharma <satyam@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/osst.c |   16 ++++++++--------
 drivers/scsi/osst.h |    3 ++-
 2 files changed, 10 insertions(+), 9 deletions(-)

diff -puN drivers/scsi/osst.c~use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver drivers/scsi/osst.c
--- a/drivers/scsi/osst.c~use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver
+++ a/drivers/scsi/osst.c
@@ -3298,7 +3298,7 @@ static ssize_t osst_write(struct file * 
 	char		    * name = tape_name(STp);
 
 
-	if (down_interruptible(&STp->lock))
+	if (mutex_lock_interruptible(&STp->lock))
 		return (-ERESTARTSYS);
 
 	/*
@@ -3600,7 +3600,7 @@ if (SRpnt) printk(KERN_ERR "%s:A: Not su
 out:
 	if (SRpnt != NULL) osst_release_request(SRpnt);
 
-	up(&STp->lock);
+	mutex_unlock(&STp->lock);
 
 	return retval;
 }
@@ -3619,7 +3619,7 @@ static ssize_t osst_read(struct file * f
 	char		    * name  = tape_name(STp);
 
 
-	if (down_interruptible(&STp->lock))
+	if (mutex_lock_interruptible(&STp->lock))
 		return (-ERESTARTSYS);
 
 	/*
@@ -3785,7 +3785,7 @@ static ssize_t osst_read(struct file * f
 out:
 	if (SRpnt != NULL) osst_release_request(SRpnt);
 
-	up(&STp->lock);
+	mutex_unlock(&STp->lock);
 
 	return retval;
 }
@@ -4852,7 +4852,7 @@ static int osst_ioctl(struct inode * ino
 	char		    * name  = tape_name(STp);
 	void	    __user  * p     = (void __user *)arg;
 
-	if (down_interruptible(&STp->lock))
+	if (mutex_lock_interruptible(&STp->lock))
 		return -ERESTARTSYS;
 
 #if DEBUG
@@ -5163,14 +5163,14 @@ static int osst_ioctl(struct inode * ino
 	}
 	if (SRpnt) osst_release_request(SRpnt);
 
-	up(&STp->lock);
+	mutex_unlock(&STp->lock);
 
 	return scsi_ioctl(STp->device, cmd_in, p);
 
 out:
 	if (SRpnt) osst_release_request(SRpnt);
 
-	up(&STp->lock);
+	mutex_unlock(&STp->lock);
 
 	return retval;
 }
@@ -5866,7 +5866,7 @@ static int osst_probe(struct device *dev
 	tpnt->modes[2].defined = 1;
 	tpnt->density_changed = tpnt->compression_changed = tpnt->blksize_changed = 0;
 
-	init_MUTEX(&tpnt->lock);
+	mutex_init(&tpnt->lock);
 	osst_nr_dev++;
 	write_unlock(&os_scsi_tapes_lock);
 
diff -puN drivers/scsi/osst.h~use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver drivers/scsi/osst.h
--- a/drivers/scsi/osst.h~use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver
+++ a/drivers/scsi/osst.h
@@ -4,6 +4,7 @@
 
 #include <asm/byteorder.h>
 #include <linux/completion.h>
+#include <linux/mutex.h>
 
 /*	FIXME - rename and use the following two types or delete them!
  *              and the types really should go to st.h anyway...
@@ -532,7 +533,7 @@ struct osst_tape {
   struct scsi_driver *driver;
   unsigned capacity;
   struct scsi_device *device;
-  struct semaphore lock;       /* for serialization */
+  struct mutex lock;           /* for serialization */
   struct completion wait;      /* for SCSI commands */
   struct osst_buffer * buffer;
 
_
