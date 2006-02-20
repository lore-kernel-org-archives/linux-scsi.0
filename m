From: Tom Scanlan <tscanlan@sosaith.org>
Subject: sd/usb deadlock
Date: Sun, 19 Feb 2006 22:14:26 -0500
Message-ID: <43F93412.6070700@sosaith.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090608090705000507010903"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp01.mrf.mail.rcn.net ([207.172.4.61]:30106 "EHLO
	smtp01.mrf.mail.rcn.net") by vger.kernel.org with ESMTP
	id S932598AbWBTDO3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Feb 2006 22:14:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------090608090705000507010903
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Not sure if I should report this or ask around elsewhere... This was
also sent to drew@colorado.edu, as he was first in sd.c.


sd_open in drivers/scsi/sd.c  seems to have a deadlock.  It was noticed
when plugging and unplugging lots of usb disks in random order on a slow
machine.  The hotplug scripts were running fdisk -l on the devices and
trying to mount the disks as they were getting (un)plugged.  I saw this
in version 2.4.21, but the code is the same at least up to 2.4.30.

revalidate_scsidisk marks the disk as busy, then we hit an sd_open and
got stuck in a loop waiting for the disk to become not busy.  The change
is to fail on open if the disk is busy.  Requiring a mount retry is
better behavior than hanging the kernel.

The diff is attached... I'm not sure the process to getting it in a
release... pointers would be helpful.  If there is a reason this
shouldn't be used let me know, as I'm not much of a kernel hacker.


--------------090608090705000507010903
Content-Type: text/plain;
 name="sd.c.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sd.c.diff"

--- sd.c	2006-02-10 12:22:41.000000000 -0500
+++ sd.c~	2006-02-08 16:27:31.000000000 -0500
@@ -466,10 +466,15 @@
 	 * is being re-read.
 	 */
 
- 	if  (rscsi_disks[target].device->busy) {
-		printk("device %d was busy, can't open it, try again soon.\n", target);
- 		return -ENXIO;
- 	}
+
+	while (rscsi_disks[target].device->busy) {
+		barrier();
+		cpu_relax();
+	}
+
 	/*
 	 * The following code can sleep.
 	 * Module unloading must be prevented


--------------090608090705000507010903--
