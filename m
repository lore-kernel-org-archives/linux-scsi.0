From: Steve Brueggeman <xioborg@yahoo.com>
Subject: Should sd REALLY allocate a device for an offline device
Date: Fri, 14 Mar 2003 10:50:11 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <bj147v0fn10c6duj1n06jo84uurn1i0dvj@4ax.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


There's a managed storage device that reports 0x20 in byte 0 of the
Inquiry data, which means it's a SCSI_DISK, but the LUN is detached.

scan_scsis_single() acknowledgs this, and marks the device as not
online, and lets the upper level device drivers decide what to do.

It is my belief that if a device is not online, the scsi disk driver
should not allocate a device slot for it.  See the following simple
patch.  Any thoughts?  It seems obvious to me, but maybe I'm missing
something.

diff -ruN -X dontdiff linux-2.4.20.orig/drivers/scsi/sd.c
linux-2.4.20.new/drivers/scsi/sd.c
--- linux-2.4.20.orig/drivers/scsi/sd.c	Fri Aug  2 19:39:44 2002
+++ linux-2.4.20.new/drivers/scsi/sd.c	Fri Mar 14 10:26:32 2003
@@ -1264,6 +1264,8 @@
 {
 	if (SDp->type != TYPE_DISK && SDp->type != TYPE_MOD)
 		return 0;
+	if (!SDp->online)
+		return 0;
 	sd_template.dev_noticed++;
 	return 1;
 }
@@ -1276,6 +1278,8 @@
 	char nbuff[6];
 
 	if (SDp->type != TYPE_DISK && SDp->type != TYPE_MOD)
+		return 0;
+	if (!SDp->online)
 		return 0;
 
 	if (sd_template.nr_dev >= sd_template.dev_max || rscsi_disks
== NULL) {


