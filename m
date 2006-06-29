From: Ishai Rabinovitz <ishai@mellanox.co.il>
Subject: [PATCH] Fix bad error handling in sg.c
Date: Thu, 29 Jun 2006 16:39:54 +0300
Message-ID: <20060629133954.GA7834@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mxl145v68.mxlogic.net ([208.65.145.68]:7890 "EHLO
	p02c11o145.mxlogic.net") by vger.kernel.org with ESMTP
	id S1750715AbWF2Nkq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jun 2006 09:40:46 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I'm taking a part in the development of SRP (Scsi RDMA Protocol).
While running tests on SRP, I think I found a bug in the scsi layer.

I got a NULL derefrence in cdev_del+1 when called from sg_remove. By looking at
the code of sg_add, sg_alloc and sg_remove (all in drivers/scsi/sg.c) I found
out that sg_add is calling sg_alloc but if it fails afterwards it does not
deallocate the space that was allocated in sg_alloc and the redundant entry has
NULL in cdev. When sg_remove is being called, it tries to perform cdev_del to
this NULL cdev and fails.

I think that the following patch solves this problem.

Signed-off-by: Ishai Rabinovitz <ishai@mellanox.co.il>

Index: ishai/linux-2.6.17/drivers/scsi/sg.c
===================================================================
--- linux-2.6.17.orig/drivers/scsi/sg.c	2006-06-15 17:08:11.659864000 +0300
+++ linux-2.6.17/drivers/scsi/sg.c	2006-06-16 00:32:26.676638000 +0300
@@ -1402,6 +1402,7 @@ sg_add(struct class_device *cl_dev, stru
 	Sg_device *sdp = NULL;
 	struct cdev * cdev = NULL;
 	int error, k;
+	unsigned long iflags;
 
 	disk = alloc_disk(1);
 	if (!disk) {
@@ -1429,7 +1430,7 @@ sg_add(struct class_device *cl_dev, stru
 
 	error = cdev_add(cdev, MKDEV(SCSI_GENERIC_MAJOR, k), 1);
 	if (error)
-		goto out;
+		goto cdev_add_err;
 
 	sdp->cdev = cdev;
 	if (sg_sysfs_valid) {
@@ -1456,6 +1457,13 @@ sg_add(struct class_device *cl_dev, stru
 
 	return 0;
 
+cdev_add_err:
+	write_lock_irqsave(&sg_dev_arr_lock, iflags);
+	kfree(sg_dev_arr[k]);
+	sg_dev_arr[k] = NULL;
+	sg_nr_dev--;
+	write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
+
 out:
 	put_disk(disk);
 	if (cdev)
-- 
Ishai Rabinovitz
