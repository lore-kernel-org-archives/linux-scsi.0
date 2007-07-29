From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Subject: [PATCH 2/5] Use mutex instead of semaphore in the OnStream SCSI Tape driver
Date: Sun, 29 Jul 2007 23:36:33 +0200
Message-ID: <20070729213633.GE3432@traven>
References: <20070729212909.GC3432@traven>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:33546
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S936199AbXG2Vgv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jul 2007 17:36:51 -0400
Content-Disposition: inline
In-Reply-To: <20070729212909.GC3432@traven>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: osst@riede.org, osst-users@lists.sourceforge.net, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org

The OnStream SCSI Tape driver uses a semaphore as mutex. Use the mutex
API instead of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 08060fb..0e2452c 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -3298,7 +3298,7 @@ static ssize_t osst_write(struct file * filp, const char __user * buf, size_t co
 	char		    * name = tape_name(STp);
 
 
-	if (down_interruptible(&STp->lock))
+	if (mutex_lock_interruptible(&STp->lock))
 		return (-ERESTARTSYS);
 
 	/*
@@ -3600,7 +3600,7 @@ if (SRpnt) printk(KERN_ERR "%s:A: Not supposed to have SRpnt at line %d\n", name
 out:
 	if (SRpnt != NULL) osst_release_request(SRpnt);
 
-	up(&STp->lock);
+	mutex_unlock(&STp->lock);
 
 	return retval;
 }
@@ -3619,7 +3619,7 @@ static ssize_t osst_read(struct file * filp, char __user * buf, size_t count, lo
 	char		    * name  = tape_name(STp);
 
 
-	if (down_interruptible(&STp->lock))
+	if (mutex_lock_interruptible(&STp->lock))
 		return (-ERESTARTSYS);
 
 	/*
@@ -3785,7 +3785,7 @@ static ssize_t osst_read(struct file * filp, char __user * buf, size_t count, lo
 out:
 	if (SRpnt != NULL) osst_release_request(SRpnt);
 
-	up(&STp->lock);
+	mutex_unlock(&STp->lock);
 
 	return retval;
 }
@@ -4852,7 +4852,7 @@ static int osst_ioctl(struct inode * inode,struct file * file,
 	char		    * name  = tape_name(STp);
 	void	    __user  * p     = (void __user *)arg;
 
-	if (down_interruptible(&STp->lock))
+	if (mutex_lock_interruptible(&STp->lock))
 		return -ERESTARTSYS;
 
 #if DEBUG
@@ -5163,14 +5163,14 @@ static int osst_ioctl(struct inode * inode,struct file * file,
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
@@ -5866,7 +5866,7 @@ static int osst_probe(struct device *dev)
 	tpnt->modes[2].defined = 1;
 	tpnt->density_changed = tpnt->compression_changed = tpnt->blksize_changed = 0;
 
-	init_MUTEX(&tpnt->lock);
+	mutex_init(&tpnt->lock);
 	osst_nr_dev++;
 	write_unlock(&os_scsi_tapes_lock);
 
diff --git a/drivers/scsi/osst.h b/drivers/scsi/osst.h
index 2cc7b5a..5aa2274 100644
--- a/drivers/scsi/osst.h
+++ b/drivers/scsi/osst.h
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

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

                Don't walk behind me, I may not lead
             Don't walk in front of me, I may not follow
                Just walk beside me and be my friend
                          (Albert Camus)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
