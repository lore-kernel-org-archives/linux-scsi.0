From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH] m68k link error and NCR5380_exit()
Date: Mon, 7 Mar 2005 17:30:03 +1100 (EST)
Message-ID: <Pine.LNX.4.61.0503071612290.27126@loopy.telegraphics.com.au>
References: <Pine.LNX.4.61.0502110155440.7310@loopy.telegraphics.com.au>
 <20050210171518.GA22265@pants.nu> <Pine.LNX.4.61.0502111930340.11381@loopy.telegraphics.com.au>
 <Pine.LNX.4.61.0502121539440.20941@loopy.telegraphics.com.au>
 <20050212075645.GA30669@pants.nu> <Pine.LNX.4.61.0502122135230.21876@loopy.telegraphics.com.au>
 <20050213040948.GA10198@orchestra.cs.caltech.edu>
 <Pine.LNX.4.61.0502131618470.25204@loopy.telegraphics.com.au>
 <20050213063225.GA17415@orchestra.cs.caltech.edu>
 <Pine.LNX.4.61.0502131736300.25553@loopy.telegraphics.com.au>
 <20050213075506.GA18622@orchestra.cs.caltech.edu>
 <Pine.LNX.4.61.0502212233290.15372@loopy.telegraphics.com.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Received: from loopy.telegraphics.com.au ([202.45.126.152]:5586 "EHLO
	loopy.telegraphics.com.au") by vger.kernel.org with ESMTP
	id S261648AbVCGGaL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Mar 2005 01:30:11 -0500
In-Reply-To: <Pine.LNX.4.61.0502212233290.15372@loopy.telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux scsi <linux-scsi@vger.kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>, Noah Misch <noah@cs.caltech.edu>, linux m68k <linux-m68k@vger.kernel.org>


If this patch looks okay to you SCSI people, I'll ask the m68k maintainer 
to apply it. It fixes a link failure in the !CONFIG_HOTPLUG m68k kernel 
caused by the mac_scsi driver. The patch should apply to v2.6.10.

AFAICT, the introduction of __devexit NCR5380_exit() in 2.6.9 necessitated
this fix for m68k macs, which don't need hotplug, and typically want 
mac_scsi built into the kernel.

Given !MODULE and !HOTPLUG, g_NCR5380 has the same problem (as do other 
NCR5380 SCSI drivers, I expect). However, the x86 linker doesn't care, and 
I don't have the hardware, so I haven't patched them.

Signed-off-by: fthain@telegraphics.com.au


--- a/drivers/scsi/mac_scsi.c	2005-02-28 15:12:31.050279180 +1100
+++ b/drivers/scsi/mac_scsi.c	2005-02-28 15:14:16.499002032 +1100
@@ -233,7 +233,7 @@
  *
  */
  
-int macscsi_detect(Scsi_Host_Template * tpnt)
+int __init macscsi_detect(Scsi_Host_Template * tpnt)
 {
     static int called = 0;
     int flags = 0;
@@ -322,7 +322,7 @@
     return 1;
 }
 
-int macscsi_release (struct Scsi_Host *shpnt)
+int __exit macscsi_release (struct Scsi_Host *shpnt)
 {
 	if (shpnt->irq != SCSI_IRQ_NONE)
 		free_irq (shpnt->irq, NCR5380_intr);
@@ -336,7 +336,7 @@
  * Our 'bus reset on boot' function
  */
 
-static void mac_scsi_reset_boot(struct Scsi_Host *instance)
+static void __init mac_scsi_reset_boot(struct Scsi_Host *instance)
 {
 	unsigned long end;
 
@@ -586,7 +586,7 @@
 	.proc_info			= macscsi_proc_info,
 	.name				= "Macintosh NCR5380 SCSI",
 	.detect				= macscsi_detect,
-	.release			= macscsi_release,
+	.release			= __exit_p(macscsi_release),
 	.info				= macscsi_info,
 	.queuecommand			= macscsi_queue_command,
 	.eh_abort_handler		= macscsi_abort,
--- a/drivers/scsi/scsi_module.c	2005-02-28 18:16:17.408413324 +1100
+++ b/drivers/scsi/scsi_module.c	2005-02-28 18:16:46.696503105 +1100
@@ -21,12 +21,14 @@
 	struct list_head *l;
 	int error;
 
+#ifdef MODULE
 	if (!sht->release) {
 		printk(KERN_ERR
 		    "scsi HBA driver %s didn't set a release method.\n",
 		    sht->name);
 		return -EINVAL;
 	}
+#endif
 
 	sht->module = THIS_MODULE;
 	INIT_LIST_HEAD(&sht->legacy_hosts);
