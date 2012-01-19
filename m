From: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC] Proposed fix for scsi related boot crash
Date: Thu, 19 Jan 2012 12:41:28 +0100
Message-ID: <20120119114127.GC6514@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329Ab2ASLlc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jan 2012 06:41:32 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

Hi

We have fedora bug report where system crash at boot when SCSI card is
plugged into the system:
https://bugzilla.redhat.com/show_bug.cgi?id=781625

Since it is 3.1.2 -> 3.1.4 regression, it was easy to find out that
the problem is caused by:

commit 4e6c82b3614a18740ef63109d58743a359266daf
Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Mon Nov 7 08:51:24 2011 -0600

    [SCSI] fix WARNING: at drivers/scsi/scsi_lib.c:1704
 
User confirmed that reverting the commit fixed the problem (and
generates lot's of scsi/scsi_lib.c:1704 warnings).

The remain question is how to properly fix. My proposition is to
revert 4e6c82b361 and nullify sdev->request_queue->queuedata what
should fix the warning.

Thanks
Stanislaw

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 89da43f..fcc8b53 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -319,7 +319,15 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	return sdev;
 
 out_device_destroy:
-	__scsi_remove_device(sdev);
+	scsi_device_set_state(sdev, SDEV_DEL);
+	transport_destroy_device(&sdev->sdev_gendev);
+	put_device(&sdev->sdev_dev);
+
+	/* stop the block layer for our device */
+	sdev->request_queue->queuedata = NULL;
+	scsi_free_queue(sdev->request_queue);
+
+	put_device(&sdev->sdev_gendev);
 out:
 	if (display_failure_msg)
 		printk(ALLOC_FAILURE_MSG, __func__);
