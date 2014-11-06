From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/6] scsi: don't use scsi_next_command in scsi_reset_provider
Date: Thu,  6 Nov 2014 08:40:25 +0100
Message-ID: <1415259630-20784-2-git-send-email-hch@lst.de>
References: <1415259630-20784-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:51531 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaKFHk1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2014 02:40:27 -0500
In-Reply-To: <1415259630-20784-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>

scsi_reset_provider already manually runs all queues for the given host,
so it doesn't need the scsi_run_queues call from it, and it doesn't need
a reference on the device because it's synchronous.

So let's just call scsi_put_command directly and avoid the device reference
dance to simplify the code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_error.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index ba19687..a1ffdb0 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2335,14 +2335,9 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 		return -EIO;
 
 	error = -EIO;
-	if (!get_device(&dev->sdev_gendev))
-		goto out_put_autopm_host;
-
 	scmd = scsi_get_command(dev, GFP_KERNEL);
-	if (!scmd) {
-		put_device(&dev->sdev_gendev);
+	if (!scmd)
 		goto out_put_autopm_host;
-	}
 
 	blk_rq_init(NULL, &req);
 	scmd->request = &req;
@@ -2404,10 +2399,10 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 			     "waking up host to restart after TMF\n"));
 
 	wake_up(&shost->host_wait);
-
 	scsi_run_host_queues(shost);
 
-	scsi_next_command(scmd);
+	scsi_put_command(scmd);
+
 out_put_autopm_host:
 	scsi_autopm_put_host(shost);
 	return error;
-- 
1.9.1

