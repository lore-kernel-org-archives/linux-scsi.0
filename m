From: Martin Hicks <mort@wildopensource.com>
Subject: [PATCH] Call slave_destroy in scsi_alloc_sdev error path
Date: Fri, 9 Jan 2004 11:02:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040109160244.GL30627@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="oTHb8nViIGeoXxdp"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from galileo.bork.org ([66.11.174.156]:45488 "HELO galileo.bork.org")
	by vger.kernel.org with SMTP id S261950AbUAIQCr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jan 2004 11:02:47 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com


--oTHb8nViIGeoXxdp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hello,

This patch fixes a potential memory leak in scsi_alloc_sdev.

If slave_alloc kmallocs memory and the get_device() (around line 245)
fails then we goto the error path.  The error path never calls
slave_destroy.

This patch fixes this problem.
mh

-- 
Martin Hicks                Wild Open Source Inc.
mort@wildopensource.com     613-266-2296

--oTHb8nViIGeoXxdp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="scsi_slave_destroy.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1491  -> 1.1492 
#	drivers/scsi/scsi_scan.c	1.114   -> 1.115  
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 04/01/09	mort@green.i.bork.org	1.1492
# We should call slave_destroy on the error path if slave_alloc
# has already been called and has succeeded in scsi_alloc_sdev()
# --------------------------------------------
#
diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	Fri Jan  9 10:20:43 2004
+++ b/drivers/scsi/scsi_scan.c	Fri Jan  9 10:20:43 2004
@@ -254,7 +254,7 @@
 			 "%d:%d:%d:%d", sdev->host->host_no,
 			 sdev->channel, sdev->id, sdev->lun);
 	} else
-		goto out_free_queue;
+		goto out_cleanup_slave;
 
 	/*
 	 * If there are any same target siblings, add this to the
@@ -283,6 +283,9 @@
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	return sdev;
 
+out_cleanup_slave:
+	if (shost->hostt->slave_destroy)
+		shost->hostt->slave_destroy(sdev);
 out_free_queue:
 	scsi_free_queue(sdev->request_queue);
 out_free_dev:

--oTHb8nViIGeoXxdp--
