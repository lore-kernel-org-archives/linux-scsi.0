From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] serialize bus scanning
Date: Mon, 25 Aug 2003 14:24:16 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030825122416.GE15506@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:56475 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261811AbTHYMYU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2003 08:24:20 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

Synchronize all scanning activity, this fixes long-standing races
vs /proc/scsi/scsi and sysfs addition and deletion of devices.

Note that this does not serialize removing, the lists will get
their own locking soon.


diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	Mon Aug 25 13:37:29 2003
+++ b/drivers/scsi/scsi_scan.c	Mon Aug 25 13:37:29 2003
@@ -30,6 +30,7 @@
 #include <linux/moduleparam.h>
 #include <linux/init.h>
 #include <linux/blkdev.h>
+#include <asm/semaphore.h>
 
 #include "scsi.h"
 #include "hosts.h"
@@ -94,6 +95,13 @@
 		 " between 1 and 16384)");
 #endif
 
+/*
+ * This mutex serializes all scsi scanning activity from kernel- and
+ * userspace.  It could easily be made per-host but I'd like to avoid
+ * the overhead for now.
+ */
+static DECLARE_MUTEX(scsi_scan_mutex);
+
 /**
  * scsi_unlock_floptical - unlock device via a special MODE SENSE command
  * @sreq:	used to send the command
@@ -1067,9 +1075,12 @@
 	struct scsi_device *sdev;
 	int res;
 
+	down(&scsi_scan_mutex);
 	res = scsi_probe_and_add_lun(shost, channel, id, lun, NULL, &sdev, 1);
 	if (res != SCSI_SCAN_LUN_PRESENT)
 		sdev = ERR_PTR(-ENODEV);
+	up(&scsi_scan_mutex);
+
 	return sdev;
 }
 
@@ -1191,11 +1202,14 @@
 	    ((lun != SCAN_WILD_CARD) && (lun > shost->max_lun)))
 		return -EINVAL;
 
+	down(&scsi_scan_mutex);
 	if (channel == SCAN_WILD_CARD) 
 		for (channel = 0; channel <= shost->max_channel; channel++)
 			scsi_scan_channel(shost, channel, id, lun, rescan);
 	else
 		scsi_scan_channel(shost, channel, id, lun, rescan);
+	up(&scsi_scan_mutex);
+
 	return 0;
 }
 
