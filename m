From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Possible explanation for SCSI benchmark problems in 2.5
Date: Sun, 29 Sep 2002 16:48:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200209292048.g8TKmN424799@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed ;
	boundary="==_Exmh_17712291840"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id NAA16619
	for <linux-scsi@vger.kernel.org>; Sun, 29 Sep 2002 13:48:33 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Andrew Morton <akpm@digeo.com>, Jens Axboe <axboe@suse.de>

This is a multipart MIME message.

--==_Exmh_17712291840
Content-Type: text/plain; charset=us-ascii

Hi All,

While looking at other code (OK, how to get the MCA drivers not to use bounce 
buffers...)  I discovered that the way scsi_scan.c calls 
scsi_initialize_merge_fn() guarantees (on an x86) that the 
blk_queue_bounce_limit is always called with BLK_BOUNCE_HIGH.  This will 
probably hurt benchmarks on machines with 1Gb or more of memory.

The problem is that scsi_initialize_merge_fn() checks sdev->type, but this is 
always -1 in scsi_alloc_sdev, and thus it never uses the pci dma mask for disk 
devices.

The attached patch moves the initialisation to after sdev->type has the 
correct value.

James


--==_Exmh_17712291840
Content-Type: text/plain ; name="bounce_limit.diff"; charset=us-ascii
Content-Description: bounce_limit.diff
Content-Disposition: attachment; filename="bounce_limit.diff"

===== drivers/scsi/scsi_scan.c 1.21 vs edited =====
--- 1.21/drivers/scsi/scsi_scan.c	Wed Aug 14 10:06:05 2002
+++ edited/drivers/scsi/scsi_scan.c	Sun Sep 29 15:41:47 2002
@@ -528,7 +528,6 @@
 		scsi_initialize_queue(sdev, shost);
 		sdev->request_queue.queuedata = (void *) sdev;
 
-		scsi_initialize_merge_fn(sdev);
 		init_waitqueue_head(&sdev->scpnt_wait);
 
 		/*
@@ -1408,6 +1407,11 @@
 	sdev->removable = (0x80 & inq_result[1]) >> 7;
 	sdev->lockable = sdev->removable;
 	sdev->soft_reset = (inq_result[7] & 1) && ((inq_result[3] & 7) == 2);
+
+	/* initialise merge function needs some of the above data to 
+	 * work correctly */
+	scsi_initialize_merge_fn(sdev);
+
 
 	/*
 	 * XXX maybe move the identifier and driverfs/devfs setup to a new

--==_Exmh_17712291840--


