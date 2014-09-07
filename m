From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/8] scsi: don't use scsi_next_command in scsi_reset_provider
Date: Sun,  7 Sep 2014 09:31:02 -0700
Message-ID: <1410107469-896-2-git-send-email-hch@lst.de>
References: <1410107469-896-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:35026 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbaIGQ2y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Sep 2014 12:28:54 -0400
Received: from [50.247.105.171] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XQfKe-0006Sk-R8
	for linux-scsi@vger.kernel.org; Sun, 07 Sep 2014 16:28:53 +0000
In-Reply-To: <1410107469-896-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

scsi_reset_provider already manually runs all queues for the given host,
so it doesn't need the scsi_run_queues call from it, and it doesn't need
a reference on the device because it's synchronous.

So let's just call scsi_put_command directly and avoid the device reference
dance to simplify the code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_error.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 6b20ef3..14cece9 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2317,15 +2317,9 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 	if (scsi_autopm_get_host(shost) < 0)
 		return FAILED;
 
-	if (!get_device(&dev->sdev_gendev)) {
-		rtn = FAILED;
-		goto out_put_autopm_host;
-	}
-
 	scmd = scsi_get_command(dev, GFP_KERNEL);
 	if (!scmd) {
 		rtn = FAILED;
-		put_device(&dev->sdev_gendev);
 		goto out_put_autopm_host;
 	}
 
@@ -2381,10 +2375,9 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 			     "waking up host to restart after TMF\n"));
 
 	wake_up(&shost->host_wait);
-
 	scsi_run_host_queues(shost);
 
-	scsi_next_command(scmd);
+	scsi_put_command(scmd);
 out_put_autopm_host:
 	scsi_autopm_put_host(shost);
 	return rtn;
-- 
1.9.1

