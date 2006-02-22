From: Brian King <brking@us.ibm.com>
Subject: [PATCH 1/1] scsi: Handle device_add failure in scsi_alloc_target
Date: Wed, 22 Feb 2006 14:28:24 -0600
Message-ID: <200602222028.k1MKSPlH002129@d01av03.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36053 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1750765AbWBVU21 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2006 15:28:27 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id k1MKSQ9s013615
	for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2006 15:28:26 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k1MKSQLd217670
	for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2006 15:28:26 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k1MKSQ0a002165
	for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2006 15:28:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, olh@suse.de, brking@us.ibm.com


Fixes scsi to handle device_add failure in scsi_alloc_target.
Without this patch, if this call were to fail, we can oops
when we free the target.


Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/scsi_scan.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/scsi_scan.c~scsi_alloc_target_device_add_failure drivers/scsi/scsi_scan.c
--- linux-2.6/drivers/scsi/scsi_scan.c~scsi_alloc_target_device_add_failure	2006-02-20 14:55:13.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/scsi_scan.c	2006-02-22 12:50:20.000000000 -0600
@@ -333,6 +333,7 @@ static struct scsi_target *scsi_alloc_ta
 		+ shost->transportt->target_size;
 	struct scsi_target *starget;
 	struct scsi_target *found_target;
+	int error;
 
 	starget = kmalloc(size, GFP_KERNEL);
 	if (!starget) {
@@ -361,10 +362,20 @@ static struct scsi_target *scsi_alloc_ta
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	/* allocate and add */
 	transport_setup_device(dev);
-	device_add(dev);
+	error = device_add(dev);
+	if (error) {
+		dev_err(dev, "target device_add failed, error %d\n", error);
+		spin_lock_irqsave(shost->host_lock, flags);
+		list_del_init(&starget->siblings);
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		transport_destroy_device(dev);
+		put_device(parent);
+		kfree(starget);
+		return NULL;
+	}
 	transport_add_device(dev);
 	if (shost->hostt->target_alloc) {
-		int error = shost->hostt->target_alloc(starget);
+		error = shost->hostt->target_alloc(starget);
 
 		if(error) {
 			dev_printk(KERN_ERR, dev, "target allocation failed, error %d\n", error);
_
