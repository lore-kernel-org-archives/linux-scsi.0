From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 3/5] aacraid: adjustable timeouts
Date: Wed, 10 May 2006 09:12:48 -0700
Message-ID: <1147277568.29108.34.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:16260 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965001AbWEJQMv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 May 2006 12:12:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

Received From Mark Salyzyn

Add the ability to adjust for unusual corner case failures. Both of
these additional module parameters deal with embedded, non-intel or
complicated system scenarios.

Aif_timeout can be increased past the default 2 minute timeout to drop
application registrations when a system has an unusually high event load
resulting from continuing management requests, or simultaneous builds,
or sluggish user space as a result of system load.

Startup_timeout can be increased past the default 3 minute timeout to
drop an adapter initialization for systems that have a very large number
of targets, or slow to spin-up targets, or a complicated set of array
configurations that extend the time for the firmware to declare that it
is operational. This timeout would only have an affect on non-intel
based systems, as the (more patient) BIOS would generally be where the
startup delay would be dealt with.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

---
Applies to the scsi-misc-2.6 tree.

--- scsi-misc-aac.orig/drivers/scsi/aacraid/aachba.c	2006-04-17 13:23:57.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/aachba.c	2006-04-20 12:55:54.000000000 -0700
@@ -148,6 +148,8 @@
 static int dacmode = -1;
 
 static int commit = -1;
+int startup_timeout = 180;
+int aif_timeout = 120;
 
 module_param(nondasd, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(nondasd, "Control scanning of hba for nondasd devices. 0=off, 1=on");
@@ -155,6 +157,10 @@
 MODULE_PARM_DESC(dacmode, "Control whether dma addressing is using 64 bit DAC. 0=off, 1=on");
 module_param(commit, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(commit, "Control whether a COMMIT_CONFIG is issued to the adapter for foreign arrays.\nThis is typically needed in systems that do not have a BIOS. 0=off, 1=on");
+module_param(startup_timeout, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(startup_timeout, "The duration of time in seconds to wait for adapter to have it's kernel up and\nrunning. This is typically adjusted for large systems that do not have a BIOS.");
+module_param(aif_timeout, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(aif_timeout, "The duration of time in seconds to wait for applications to pick up AIFs before\nderegistering them. This is typically adjusted for heavily burdened systems.");
 
 int numacb = -1;
 module_param(numacb, int, S_IRUGO|S_IWUSR);
--- scsi-misc-aac.orig/drivers/scsi/aacraid/commsup.c	2006-04-17 13:22:33.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/commsup.c	2006-05-09 14:48:14.000000000 -0700
@@ -1214,7 +1214,7 @@
 						 * since the last read off
 						 * the queue?
 						 */
-						if ((time_now - time_last) > 120) {
+						if ((time_now - time_last) > aif_timeout) {
 							entry = entry->next;
 							aac_close_fib_context(dev, fibctx);
 							continue;
--- scsi-misc-aac.orig/drivers/scsi/aacraid/rkt.c	2006-04-17 13:22:33.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/rkt.c	2006-05-09 14:48:27.000000000 -0700
@@ -444,14 +444,14 @@
 	 */
 	while (!(rkt_readl(dev, MUnit.OMRx[0]) & KERNEL_UP_AND_RUNNING))
 	{
-		if(time_after(jiffies, start+180*HZ))
+		if(time_after(jiffies, start+startup_timeout*HZ))
 		{
 			status = rkt_readl(dev, MUnit.OMRx[0]);
 			printk(KERN_ERR "%s%d: adapter kernel failed to start, init status = %lx.\n", 
 					dev->name, instance, status);
 			goto error_iounmap;
 		}
-		schedule_timeout_uninterruptible(1);
+		msleep(1);
 	}
 	if (request_irq(dev->scsi_host_ptr->irq, aac_rkt_intr, SA_SHIRQ|SA_INTERRUPT, "aacraid", (void *)dev)<0) 
 	{
--- scsi-misc-aac.orig/drivers/scsi/aacraid/rx.c	2006-04-17 13:22:33.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/rx.c	2006-05-09 14:48:40.000000000 -0700
@@ -444,14 +444,14 @@
 	while ((!(rx_readl(dev, IndexRegs.Mailbox[7]) & KERNEL_UP_AND_RUNNING))
 		|| (!(rx_readl(dev, MUnit.OMRx[0]) & KERNEL_UP_AND_RUNNING)))
 	{
-		if(time_after(jiffies, start+180*HZ))
+		if(time_after(jiffies, start+startup_timeout*HZ))
 		{
 			status = rx_readl(dev, IndexRegs.Mailbox[7]);
 			printk(KERN_ERR "%s%d: adapter kernel failed to start, init status = %lx.\n", 
 					dev->name, instance, status);
 			goto error_iounmap;
 		}
-		schedule_timeout_uninterruptible(1);
+		msleep(1);
 	}
 	if (request_irq(dev->scsi_host_ptr->irq, aac_rx_intr, SA_SHIRQ|SA_INTERRUPT, "aacraid", (void *)dev)<0) 
 	{
--- scsi-misc-aac.orig/drivers/scsi/aacraid/sa.c	2006-04-17 13:22:33.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/sa.c	2006-05-09 14:48:58.000000000 -0700
@@ -318,13 +318,13 @@
 	 *	Wait for the adapter to be up and running. Wait up to 3 minutes.
 	 */
 	while (!(sa_readl(dev, Mailbox7) & KERNEL_UP_AND_RUNNING)) {
-		if (time_after(jiffies, start+180*HZ)) {
+		if (time_after(jiffies, start+startup_timeout*HZ)) {
 			status = sa_readl(dev, Mailbox7);
 			printk(KERN_WARNING "%s%d: adapter kernel failed to start, init status = %lx.\n", 
 					name, instance, status);
 			goto error_iounmap;
 		}
-		schedule_timeout_uninterruptible(1);
+		msleep(1);
 	}
 
 	if (request_irq(dev->scsi_host_ptr->irq, aac_sa_intr, SA_SHIRQ|SA_INTERRUPT, "aacraid", (void *)dev ) < 0) {
--- scsi-misc-aac.orig/drivers/scsi/aacraid/aacraid.h	2006-05-09 14:46:37.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/aacraid.h	2006-05-09 14:49:33.000000000 -0700
@@ -1815,3 +1815,5 @@
 extern int numacb;
 extern int acbsize;
 extern char aac_driver_version[];
+extern int startup_timeout;
+extern int aif_timeout;

-- 
Mark Haverkamp <markh@osdl.org>

