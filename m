From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [patch] 4/5 scsi-locking-2.5 list_del starved_entry plus use GFP_ATOMIC
Date: Wed, 9 Apr 2003 16:47:56 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030409164756.D23701@beaverton.ibm.com>
References: <20030409164612.A23701@beaverton.ibm.com> <20030409164701.B23701@beaverton.ibm.com> <20030409164733.C23701@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:30935 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S263897AbTDIXkD (for <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Apr 2003 19:40:03 -0400
Content-Disposition: inline
In-Reply-To: <20030409164733.C23701@beaverton.ibm.com>; from patmans@us.ibm.com on Wed, Apr 09, 2003 at 04:47:33PM -0700
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

list_del the starved_entry when sdev goes away.

Use GFP_ATOMIC when allocating starget, since we hold a lock.

diff -purN -X /home/patman/dontdiff 03_no_loop/drivers/scsi/scsi_scan.c 04_scan_changes/drivers/scsi/scsi_scan.c
--- 03_no_loop/drivers/scsi/scsi_scan.c	Wed Apr  9 12:39:15 2003
+++ 04_scan_changes/drivers/scsi/scsi_scan.c	Wed Apr  9 13:37:02 2003
@@ -489,13 +489,14 @@ static void scsi_free_sdev(struct scsi_d
 		sdev->host->hostt->slave_destroy(sdev);
 	if (sdev->inquiry)
 		kfree(sdev->inquiry);
+	spin_lock_irqsave(sdev->host->host_lock, flags);
+	list_del(&sdev->starved_entry);
 	if (sdev->single_lun) {
-		spin_lock_irqsave(sdev->host->host_lock, flags);
 		sdev->sdev_target->starget_refcnt--;
 		if (sdev->sdev_target->starget_refcnt == 0)
 			kfree(sdev->sdev_target);
-		spin_unlock_irqrestore(sdev->host->host_lock, flags);
 	}
+	spin_unlock_irqrestore(sdev->host->host_lock, flags);
 
 	kfree(sdev);
 }
@@ -1275,7 +1276,7 @@ static int scsi_add_lun(Scsi_Device *sde
 			}
 		}
 		if (!starget) {
-			starget = kmalloc(sizeof(*starget), GFP_KERNEL);
+			starget = kmalloc(sizeof(*starget), GFP_ATOMIC);
 			if (!starget) {
 				printk(ALLOC_FAILURE_MSG, __FUNCTION__);
 				spin_unlock_irqrestore(sdev->host->host_lock,
