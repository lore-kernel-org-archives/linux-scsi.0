From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] add ssleep(), kill scsi_sleep()
Date: Thu, 19 Aug 2004 00:51:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <412431D2.5080904@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000003080309040508070407"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:8100 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262279AbUHSEvs
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 00:51:48 -0400
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------000003080309040508070407
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit


So, the kernel needs a 'sleep', but that token is far too common, so I 
chose ssleep().

scsi_sleep() is a manually implemented msleep(), so I remove it.



--------------000003080309040508070407
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

===== drivers/scsi/aha1542.c 1.37 vs edited =====
--- 1.37/drivers/scsi/aha1542.c	2004-07-26 17:21:48 -04:00
+++ edited/drivers/scsi/aha1542.c	2004-08-18 22:38:11 -04:00
@@ -1479,7 +1479,7 @@
 	 * we are pretty desperate anyways.
 	 */
 	spin_unlock_irq(SCpnt->device->host->host_lock);
-	scsi_sleep(4 * HZ);
+	ssleep(4);
 	spin_lock_irq(SCpnt->device->host->host_lock);
 
 	WAIT(STATUS(SCpnt->device->host->io_port),
@@ -1543,7 +1543,7 @@
 	 * we are pretty desperate anyways.
 	 */
 	spin_unlock_irq(SCpnt->device->host->host_lock);
-	scsi_sleep(4 * HZ);
+	ssleep(4);
 	spin_lock_irq(SCpnt->device->host->host_lock);
 
 	WAIT(STATUS(SCpnt->device->host->io_port),
===== drivers/scsi/aic7xxx_old.c 1.57 vs edited =====
--- 1.57/drivers/scsi/aic7xxx_old.c	2004-07-26 17:38:41 -04:00
+++ edited/drivers/scsi/aic7xxx_old.c	2004-08-18 22:38:37 -04:00
@@ -10489,7 +10489,7 @@
       aic_outb(p, lastphase | ATNO, SCSISIGO);
       unpause_sequencer(p, FALSE);
       spin_unlock_irq(p->host->host_lock);
-      scsi_sleep(HZ);
+      ssleep(1);
       spin_lock_irq(p->host->host_lock);
       if(aic_dev->flags & BUS_DEVICE_RESET_PENDING)
         return FAILED;
@@ -10548,7 +10548,7 @@
   aic_outb(p, saved_scbptr, SCBPTR);
   unpause_sequencer(p, FALSE);
   spin_unlock_irq(p->host->host_lock);
-  scsi_sleep(HZ/4);
+  msleep(1000/4);
   spin_lock_irq(p->host->host_lock);
   if(aic_dev->flags & BUS_DEVICE_RESET_PENDING)
     return FAILED;
@@ -10786,7 +10786,7 @@
   }
   unpause_sequencer(p, FALSE);
   spin_unlock_irq(p->host->host_lock);
-  scsi_sleep(HZ/4);
+  msleep(1000/4);
   spin_lock_irq(p->host->host_lock);
   if (p->flags & AHC_ABORT_PENDING)
   {
@@ -10887,7 +10887,7 @@
   aic7xxx_run_done_queue(p, TRUE);
   unpause_sequencer(p, FALSE);
   spin_unlock_irq(p->host->host_lock);
-  scsi_sleep(2 * HZ);
+  ssleep(2);
   spin_lock_irq(p->host->host_lock);
   return SUCCESS;
 }
===== drivers/scsi/scsi_error.c 1.79 vs edited =====
--- 1.79/drivers/scsi/scsi_error.c	2004-06-19 10:47:16 -04:00
+++ edited/drivers/scsi/scsi_error.c	2004-08-18 22:45:39 -04:00
@@ -23,6 +23,7 @@
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
 #include <linux/smp_lock.h>
+#include <linux/delay.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_dbg.h>
@@ -42,8 +43,8 @@
  * These should *probably* be handled by the host itself.
  * Since it is allowed to sleep, it probably should.
  */
-#define BUS_RESET_SETTLE_TIME   (10*HZ)
-#define HOST_RESET_SETTLE_TIME  (10*HZ)
+#define BUS_RESET_SETTLE_TIME   (10)
+#define HOST_RESET_SETTLE_TIME  (10)
 
 /* called with shost->host_lock held */
 void scsi_eh_wakeup(struct Scsi_Host *shost)
@@ -1044,7 +1045,7 @@
 
 	if (rtn == SUCCESS) {
 		if (!scmd->device->host->hostt->skip_settle_delay)
-			scsi_sleep(BUS_RESET_SETTLE_TIME);
+			ssleep(BUS_RESET_SETTLE_TIME);
 		spin_lock_irqsave(scmd->device->host->host_lock, flags);
 		scsi_report_bus_reset(scmd->device->host, scmd->device->channel);
 		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
@@ -1076,7 +1077,7 @@
 
 	if (rtn == SUCCESS) {
 		if (!scmd->device->host->hostt->skip_settle_delay)
-			scsi_sleep(HOST_RESET_SETTLE_TIME);
+			ssleep(HOST_RESET_SETTLE_TIME);
 		spin_lock_irqsave(scmd->device->host->host_lock, flags);
 		scsi_report_bus_reset(scmd->device->host, scmd->device->channel);
 		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
@@ -1213,43 +1214,6 @@
 		scsi_eh_finish_cmd(scmd, done_q);
 	}
 	return;
-}
-
-/**
- * scsi_sleep_done - timer function for scsi_sleep
- * @sem:	semphore to signal
- *
- **/
-static void scsi_sleep_done(unsigned long data)
-{
-	struct semaphore *sem = (struct semaphore *)data;
-
-	if (sem)
-		up(sem);
-}
-
-/**
- * scsi_sleep - sleep for specified timeout
- * @timeout:	timeout value
- *
- **/
-void scsi_sleep(int timeout)
-{
-	DECLARE_MUTEX_LOCKED(sem);
-	struct timer_list timer;
-
-	init_timer(&timer);
-	timer.data = (unsigned long)&sem;
-	timer.expires = jiffies + timeout;
-	timer.function = (void (*)(unsigned long))scsi_sleep_done;
-
-	SCSI_LOG_ERROR_RECOVERY(5, printk("sleeping for timer tics %d\n",
-					  timeout));
-
-	add_timer(&timer);
-
-	down(&sem);
-	del_timer(&timer);
 }
 
 /**
===== drivers/scsi/scsi_syms.c 1.49 vs edited =====
--- 1.49/drivers/scsi/scsi_syms.c	2004-06-26 18:40:24 -04:00
+++ edited/drivers/scsi/scsi_syms.c	2004-08-18 22:39:16 -04:00
@@ -69,8 +69,6 @@
 EXPORT_SYMBOL(scsi_get_host_dev);
 EXPORT_SYMBOL(scsi_free_host_dev);
 
-EXPORT_SYMBOL(scsi_sleep);
-
 EXPORT_SYMBOL(scsi_io_completion);
 
 EXPORT_SYMBOL(scsi_add_device);
===== drivers/scsi/sg.c 1.95 vs edited =====
--- 1.95/drivers/scsi/sg.c	2004-08-07 22:11:33 -04:00
+++ edited/drivers/scsi/sg.c	2004-08-18 22:45:56 -04:00
@@ -47,8 +47,9 @@
 #include <linux/devfs_fs_kernel.h>
 #include <linux/cdev.h>
 #include <linux/seq_file.h>
-
 #include <linux/blkdev.h>
+#include <linux/delay.h>
+
 #include "scsi.h"
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_driver.h>
@@ -1547,7 +1548,7 @@
 	}
 
 	if (delay)
-		scsi_sleep(2);	/* dirty detach so delay device destruction */
+		msleep(10);	/* dirty detach so delay device destruction */
 }
 
 /* Set 'perm' (4th argument) to 0 to disable module_param's definition
===== drivers/scsi/sr_ioctl.c 1.35 vs edited =====
--- 1.35/drivers/scsi/sr_ioctl.c	2004-06-20 12:31:34 -04:00
+++ edited/drivers/scsi/sr_ioctl.c	2004-08-18 22:45:43 -04:00
@@ -7,6 +7,7 @@
 #include <linux/blkdev.h>
 #include <linux/blkpg.h>
 #include <linux/cdrom.h>
+#include <linux/delay.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
 
@@ -131,7 +132,7 @@
 					printk(KERN_INFO "%s: CDROM not ready yet.\n", cd->cdi.name);
 				if (retries++ < 10) {
 					/* sleep 2 sec and try again */
-					scsi_sleep(2 * HZ);
+					ssleep(2);
 					goto retry;
 				} else {
 					/* 20 secs are enough? */
===== drivers/scsi/aacraid/linit.c 1.33 vs edited =====
--- 1.33/drivers/scsi/aacraid/linit.c	2004-07-13 21:33:33 -04:00
+++ edited/drivers/scsi/aacraid/linit.c	2004-08-18 23:54:47 -04:00
@@ -44,6 +44,7 @@
 #include <linux/spinlock.h>
 #include <linux/syscalls.h>
 #include <linux/ioctl32.h>
+#include <linux/delay.h>
 #include <asm/semaphore.h>
 
 #include <scsi/scsi.h>
@@ -416,7 +417,7 @@
 				return SUCCESS;
 		}
 		spin_unlock_irq(host->host_lock);
-		scsi_sleep(HZ);
+		ssleep(1);
 		spin_lock_irq(host->host_lock);
 	}
 	printk(KERN_ERR "%s: SCSI bus appears hung\n", AAC_DRIVERNAME);
===== drivers/scsi/aic7xxx/aic79xx_osm.c 1.53 vs edited =====
--- 1.53/drivers/scsi/aic7xxx/aic79xx_osm.c	2004-04-26 02:09:37 -04:00
+++ edited/drivers/scsi/aic7xxx/aic79xx_osm.c	2004-08-18 22:36:56 -04:00
@@ -61,6 +61,7 @@
 #endif
 
 #include <linux/mm.h>		/* For fetching system memory size */
+#include <linux/delay.h>	/* For ssleep/msleep */
 
 /*
  * Lock protecting manipulation of the ahd softc list.
@@ -3163,7 +3164,7 @@
 				break;
 			}
 			if (status & SSQ_DELAY)
-				scsi_sleep(1 * HZ);
+				ssleep(1);
 
 			break;
 		case SS_START:
@@ -3323,7 +3324,7 @@
 			}
 			if (targ->dv_state_retry <= 10) {
 				if ((status & (SSQ_DELAY_RANDOM|SSQ_DELAY))!= 0)
-					scsi_sleep(ahd->our_id*HZ/10);
+					msleep(ahd->our_id*1000/10);
 				break;
 			}
 #ifdef AHD_DEBUG
@@ -3367,7 +3368,7 @@
 				targ->dv_state_retry--;
 			} else if (targ->dv_state_retry < 60) {
 				if ((status & SSQ_DELAY) != 0)
-					scsi_sleep(1 * HZ);
+					ssleep(1);
 			} else {
 #ifdef AHD_DEBUG
 				if (ahd_debug & AHD_SHOW_DV) {
===== drivers/scsi/aic7xxx/aic7xxx_osm.c 1.55 vs edited =====
--- 1.55/drivers/scsi/aic7xxx/aic7xxx_osm.c	2004-06-25 10:50:05 -04:00
+++ edited/drivers/scsi/aic7xxx/aic7xxx_osm.c	2004-08-18 22:37:31 -04:00
@@ -140,6 +140,7 @@
 
 #include <linux/mm.h>		/* For fetching system memory size */
 #include <linux/blkdev.h>		/* For block_size() */
+#include <linux/delay.h>	/* For ssleep/msleep */
 
 /*
  * Lock protecting manipulation of the ahc softc list.
@@ -2825,7 +2826,7 @@
 				break;
 			}
 			if (status & SSQ_DELAY)
-				scsi_sleep(1 * HZ);
+				ssleep(1);
 
 			break;
 		case SS_START:
@@ -2985,7 +2986,7 @@
 			}
 			if (targ->dv_state_retry <= 10) {
 				if ((status & (SSQ_DELAY_RANDOM|SSQ_DELAY))!= 0)
-					scsi_sleep(ahc->our_id*HZ/10);
+					msleep(ahc->our_id*1000/10);
 				break;
 			}
 #ifdef AHC_DEBUG
@@ -3029,7 +3030,7 @@
 				targ->dv_state_retry--;
 			} else if (targ->dv_state_retry < 60) {
 				if ((status & SSQ_DELAY) != 0)
-					scsi_sleep(1 * HZ);
+					ssleep(1);
 			} else {
 #ifdef AHC_DEBUG
 				if (ahc_debug & AHC_SHOW_DV) {
===== drivers/scsi/arm/fas216.c 1.27 vs edited =====
--- 1.27/drivers/scsi/arm/fas216.c	2004-06-19 11:53:28 -04:00
+++ edited/drivers/scsi/arm/fas216.c	2004-08-18 22:37:53 -04:00
@@ -2681,7 +2681,7 @@
 	 * IRQs after the sleep.
 	 */
 	spin_unlock_irq(info->host->host_lock);
-	scsi_sleep(50 * HZ/100);
+	msleep(50 * 1000/100);
 	spin_lock_irq(info->host->host_lock);
 
 	/*
@@ -2920,7 +2920,7 @@
 	 * scsi standard says wait 250ms
 	 */
 	spin_unlock_irq(info->host->host_lock);
-	scsi_sleep(100*HZ/100);
+	msleep(100*1000/100);
 	spin_lock_irq(info->host->host_lock);
 
 	fas216_writeb(info, REG_CNTL1, info->scsi.cfg[0]);
===== include/linux/delay.h 1.4 vs edited =====
--- 1.4/include/linux/delay.h	2004-05-18 11:48:36 -04:00
+++ edited/include/linux/delay.h	2004-08-18 22:35:15 -04:00
@@ -40,4 +40,9 @@
 
 void msleep(unsigned int msecs);
 
+static inline void ssleep(unsigned int seconds)
+{
+	msleep(seconds * 1000);
+}
+
 #endif /* defined(_LINUX_DELAY_H) */
===== include/scsi/scsi_eh.h 1.2 vs edited =====
--- 1.2/include/scsi/scsi_eh.h	2004-06-04 07:45:01 -04:00
+++ edited/include/scsi/scsi_eh.h	2004-08-18 22:39:39 -04:00
@@ -11,7 +11,6 @@
 extern void scsi_report_bus_reset(struct Scsi_Host *, int);
 extern void scsi_report_device_reset(struct Scsi_Host *, int, int);
 extern int scsi_block_when_processing_errors(struct scsi_device *);
-extern void scsi_sleep(int);
 
 /*
  * Reset request from external source

--------------000003080309040508070407--
