From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] fix sd open/remove race
Date: Fri, 9 Apr 2004 10:11:02 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0404091005520.1000-100000@ida.rowland.org>
References: <20040408115148.A12041@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:2308 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261313AbUDIOLD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Apr 2004 10:11:03 -0400
In-Reply-To: <20040408115148.A12041@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 8 Apr 2004, Patrick Mansfield wrote:

> James posted this sd.c patch to fix the open/remove race:
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=108130838613268&w=2

The patch is almost but not quite correct.  It acquires the new semaphore 
unnecessarily during scsi_disk_put, it fails to acquire it when erasing 
the gendisk private_data, and it needs to erase the private_data during 
sd_remove (not scsi_disk_release).  It also contains a syntax error.

This patch, applied on top of James's, should fix things up.  It compiles 
okay, but I haven't tried running it.

Alan Stern


--- 2.6/drivers/scsi/sd.c.orig	Fri Apr  9 10:01:22 2004
+++ 2.6/drivers/scsi/sd.c	Fri Apr  9 10:01:13 2004
@@ -162,7 +162,7 @@
 
 /* reverse mapping dev -> (sd_nr, part) not currently needed */
 
-#define to_scsi_disk(obj) container_of(obj,struct scsi_disk,kobj);
+#define to_scsi_disk(obj) container_of(obj,struct scsi_disk,kobj)
 
 static inline struct scsi_disk *scsi_disk(struct gendisk *disk)
 {
@@ -186,9 +186,7 @@
 
 static void scsi_disk_put(struct scsi_disk *sdkp)
 {
-	down(&sd_ref_sem);
 	kobject_put(&sdkp->kobj);
-	up(&sd_ref_sem);
 }
 
 /**
@@ -1442,6 +1440,10 @@
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
+	down(&sd_ref_sem);
+	sdkp->disk->private_data = NULL;
+	up(&sd_ref_sem);
+
 	del_gendisk(sdkp->disk);
 	sd_shutdown(dev);
 	kobject_put(&sdkp->kobj);
@@ -1457,15 +1459,12 @@
 {
 	struct scsi_disk *sdkp = to_scsi_disk(kobj);
 	struct scsi_device *sdev = sdkp->device;
-	struct gendisk *disk = sdkp->disk;
 	
 	spin_lock(&sd_index_lock);
 	clear_bit(sdkp->index, sd_index_bits);
 	spin_unlock(&sd_index_lock);
 
-	disk->private_data = NULL;
-
-	put_disk(disk);
+	put_disk(sdkp->disk);
 
 	kfree(sdkp);
 

