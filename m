From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] sbp2 (ieee1394) for lk2.5.44-bk3
Date: Thu, 31 Oct 2002 11:39:11 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DC07BAF.3070109@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (dm1-22.triode.net.au [202.147.125.22])
	by iggy.triode.net.au (8.11.6/8.11.6) with ESMTP id g9V0lDC24037
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2002 11:47:13 +1100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This firewire mass storage driver is broken by the biosparam
changes. Small hack in patch below so it will compile in
2.5.44 (was set up anticipating 2.5.45 but would not have
compiled).

Doug Gilbert

--- linux/drivers/ieee1394/sbp2.h	2002-10-26 03:11:32.000000000 +1000
+++ linux/drivers/ieee1394/sbp2.h2544bk3fix	2002-10-31 11:27:25.000000000 +1100
@@ -552,7 +552,8 @@
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,28)
 static int sbp2scsi_biosparam (Scsi_Disk *disk, kdev_t dev, int geom[]);
 #else
-static int sbp2scsi_biosparam (Scsi_Disk *disk, struct block_device *dev, int geom[]);
+static int sbp2scsi_biosparam (struct scsi_device *sdev, 
+			struct block_device *dev, sector_t capacy, int geom[]);
 #endif
 static int sbp2scsi_abort (Scsi_Cmnd *SCpnt); 
 static int sbp2scsi_reset (Scsi_Cmnd *SCpnt); 
--- linux/drivers/ieee1394/sbp2.c	2002-10-31 09:22:50.000000000 +1100
+++ linux/drivers/ieee1394/sbp2.c2544bk3fix	2002-10-31 11:30:20.000000000 +1100
@@ -3137,14 +3137,14 @@
 /*
  * Called by scsi stack to get bios parameters (used by fdisk, and at boot).
  */
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,44)
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,43)
 static int sbp2scsi_biosparam (struct scsi_device *sdev,
-		struct block_device *dev, sector_t capacy, int geom[]) 
+		struct block_device *dev, sector_t capacity, int geom[]) 
 {
 #else
 static int sbp2scsi_biosparam (Scsi_Disk *disk, kdev_t dev, int geom[]) 
 {
-	sector_t capacy = disk->capacity;
+	sector_t capacity = disk->capacity;
 #endif
 	int heads, sectors, cylinders;
 

