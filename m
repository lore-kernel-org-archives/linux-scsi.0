From: Dave Jones <davej@redhat.com>
Subject: two leaks in scsi_alloc_sdev failure paths
Date: Wed, 8 Mar 2006 22:36:20 -0500
Message-ID: <20060309033620.GA19906@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55492 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S932658AbWCIDgj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2006 22:36:39 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.11/8.12.11) with ESMTP id k293aWmN009973
	for <linux-scsi@vger.kernel.org>; Wed, 8 Mar 2006 22:36:32 -0500
Received: from nwo.kernelslacker.org (vpn83-124.boston.redhat.com [172.16.83.124])
	by int-mx1.corp.redhat.com (8.11.6/8.11.6) with ESMTP id k293aM127223
	for <linux-scsi@vger.kernel.org>; Wed, 8 Mar 2006 22:36:22 -0500
Received: from nwo.kernelslacker.org (localhost.localdomain [127.0.0.1])
	by nwo.kernelslacker.org (8.13.5/8.13.5) with ESMTP id k293aLUK019923
	for <linux-scsi@vger.kernel.org>; Wed, 8 Mar 2006 22:36:21 -0500
Received: (from davej@localhost)
	by nwo.kernelslacker.org (8.13.5/8.13.5/Submit) id k293aLFm019922
	for linux-scsi@vger.kernel.org; Wed, 8 Mar 2006 22:36:21 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

If the scsi_alloc_queue or the slave_alloc calls in scsi_alloc_device fail,
we forget to release the locally allocated sdev on the failure path.

Coverity #609
Signed-off-by: Dave Jones <davej@redhat.com>

--- linux-2.6/drivers/scsi/scsi_scan.c~	2006-03-08 22:28:50.000000000 -0500
+++ linux-2.6/drivers/scsi/scsi_scan.c	2006-03-08 22:31:38.000000000 -0500
@@ -252,7 +252,7 @@ static struct scsi_device *scsi_alloc_sd
 		/* release fn is set up in scsi_sysfs_device_initialise, so
 		 * have to free and put manually here */
 		put_device(&starget->dev);
-		goto out;
+		goto out_free;
 	}
 
 	sdev->request_queue->queuedata = sdev;
@@ -278,6 +278,8 @@ static struct scsi_device *scsi_alloc_sd
 out_device_destroy:
 	transport_destroy_device(&sdev->sdev_gendev);
 	put_device(&sdev->sdev_gendev);
+out_free:
+	kfree(sdev);
 out:
 	if (display_failure_msg)
 		printk(ALLOC_FAILURE_MSG, __FUNCTION__);

-- 
http://www.codemonkey.org.uk
