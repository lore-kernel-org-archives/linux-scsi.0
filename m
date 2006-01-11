From: Jes Sorensen <jes@trained-monkey.org>
Subject: [patch] sem2mutex 3w-[x9]xxx
Date: 11 Jan 2006 08:39:45 -0500
Message-ID: <yq0slru3mu6.fsf@jaguar.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vanessarodrigues.com ([192.139.46.150]:29326 "EHLO
	jaguar.mkp.net") by vger.kernel.org with ESMTP id S1751477AbWAKNjt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jan 2006 08:39:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Adam Radford <linuxraid@amcc.com>

Hi,

The following patch converts the two 3W driver to using mutexes
instead of semaphores.

Cheers,
Jes

Convert a the 3w-9xxx.c and 3w-xxxx.c drivers to use mutexes instead
of semaphores. Untested, but compiles and looks obviously correct.

Signed-off-by: Jes Sorensen <jes@sgi.com>

----

 drivers/scsi/3w-9xxx.c |    7 ++++---
 drivers/scsi/3w-9xxx.h |    2 +-
 drivers/scsi/3w-xxxx.c |    7 ++++---
 drivers/scsi/3w-xxxx.h |    2 +-
 4 files changed, 10 insertions(+), 8 deletions(-)

Index: linux-2.6/drivers/scsi/3w-9xxx.c
===================================================================
--- linux-2.6.orig/drivers/scsi/3w-9xxx.c
+++ linux-2.6/drivers/scsi/3w-9xxx.c
@@ -73,6 +73,7 @@
 #include <linux/delay.h>
 #include <linux/pci.h>
 #include <linux/time.h>
+#include <linux/mutex.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/uaccess.h>
@@ -615,7 +616,7 @@
 	void __user *argp = (void __user *)arg;
 
 	/* Only let one of these through at a time */
-	if (down_interruptible(&tw_dev->ioctl_sem)) {
+	if (mutex_lock_interruptible(&tw_dev->ioctl_lock)) {
 		retval = TW_IOCTL_ERROR_OS_EINTR;
 		goto out;
 	}
@@ -852,7 +853,7 @@
 	/* Now free ioctl buf memory */
 	dma_free_coherent(&tw_dev->tw_pci_dev->dev, data_buffer_length_adjusted+sizeof(TW_Ioctl_Buf_Apache) - 1, cpu_addr, dma_handle);
 out2:
-	up(&tw_dev->ioctl_sem);
+	mutex_unlock(&tw_dev->ioctl_lock);
 out:
 	return retval;
 } /* End twa_chrdev_ioctl() */
@@ -1182,7 +1183,7 @@
 	tw_dev->error_sequence_id = 1;
 	tw_dev->chrdev_request_id = TW_IOCTL_CHRDEV_FREE;
 
-	init_MUTEX(&tw_dev->ioctl_sem);
+	mutex_init(&tw_dev->ioctl_lock);
 	init_waitqueue_head(&tw_dev->ioctl_wqueue);
 
 	retval = 0;
Index: linux-2.6/drivers/scsi/3w-9xxx.h
===================================================================
--- linux-2.6.orig/drivers/scsi/3w-9xxx.h
+++ linux-2.6/drivers/scsi/3w-9xxx.h
@@ -672,7 +672,7 @@
 	u32                     ioctl_msec;
 	int			chrdev_request_id;
 	wait_queue_head_t	ioctl_wqueue;
-	struct semaphore	ioctl_sem;
+	struct mutex		ioctl_lock;
 	char			aen_clobber;
 	unsigned short		working_srl;
 	unsigned short		working_branch;
Index: linux-2.6/drivers/scsi/3w-xxxx.c
===================================================================
--- linux-2.6.orig/drivers/scsi/3w-xxxx.c
+++ linux-2.6/drivers/scsi/3w-xxxx.c
@@ -203,6 +203,7 @@
 #include <linux/delay.h>
 #include <linux/pci.h>
 #include <linux/time.h>
+#include <linux/mutex.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/uaccess.h>
@@ -888,7 +889,7 @@
 	dprintk(KERN_WARNING "3w-xxxx: tw_chrdev_ioctl()\n");
 
 	/* Only let one of these through at a time */
-	if (down_interruptible(&tw_dev->ioctl_sem))
+	if (mutex_lock_interruptible(&tw_dev->ioctl_lock))
 		return -EINTR;
 
 	/* First copy down the buffer length */
@@ -1029,7 +1030,7 @@
 	/* Now free ioctl buf memory */
 	dma_free_coherent(&tw_dev->tw_pci_dev->dev, data_buffer_length_adjusted+sizeof(TW_New_Ioctl) - 1, cpu_addr, dma_handle);
 out:
-	up(&tw_dev->ioctl_sem);
+	mutex_unlock(&tw_dev->ioctl_lock);
 	return retval;
 } /* End tw_chrdev_ioctl() */
 
@@ -1270,7 +1271,7 @@
 	tw_dev->pending_tail = TW_Q_START;
 	tw_dev->chrdev_request_id = TW_IOCTL_CHRDEV_FREE;
 
-	init_MUTEX(&tw_dev->ioctl_sem);
+	mutex_init(&tw_dev->ioctl_lock);
 	init_waitqueue_head(&tw_dev->ioctl_wqueue);
 
 	return 0;
Index: linux-2.6/drivers/scsi/3w-xxxx.h
===================================================================
--- linux-2.6.orig/drivers/scsi/3w-xxxx.h
+++ linux-2.6/drivers/scsi/3w-xxxx.h
@@ -420,7 +420,7 @@
 	u32			max_sector_count;
 	u32			aen_count;
 	struct Scsi_Host	*host;
-	struct semaphore	ioctl_sem;
+	struct mutex		ioctl_lock;
 	unsigned short		aen_queue[TW_Q_LENGTH];
 	unsigned char		aen_head;
 	unsigned char		aen_tail;
