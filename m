From: James Bottomley <James.Bottomley@suse.de>
Subject: [PATCH 2/2] put stricter guards on queue dead checks
Date: Fri, 22 Apr 2011 10:39:59 -0500
Message-ID: <1303486799.2590.25.camel@mulgrave.site>
References: <1303486638.2590.21.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54403 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755557Ab1DVPkD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Apr 2011 11:40:03 -0400
In-Reply-To: <1303486638.2590.21.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>

SCSI uses request_queue->queuedata == NULL as a signal that the queue
is dying.  We set this state in the sdev release function.  However,
this allows a small window where we release the last reference but
haven't quite got to this stage yet and so something will try to take
a reference in scsi_request_fn and oops.  It's very rare, but we had a
report here, so we're pushing this as a bug fix

The actual fix is to set request_queue->queuedata to NULL in
scsi_remove_device() before we drop the reference.  This causes
correct automatic rejects from scsi_request_fn as people who hold
additional references try to submit work and prevents anything from
getting a new reference to the sdev that way.

Cc: stable@kernel.org
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
---
 drivers/scsi/scsi_sysfs.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index e44ff64..e639125 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -322,14 +322,8 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 		kfree(evt);
 	}
 
-	if (sdev->request_queue) {
-		sdev->request_queue->queuedata = NULL;
-		/* user context needed to free queue */
-		scsi_free_queue(sdev->request_queue);
-		/* temporary expedient, try to catch use of queue lock
-		 * after free of sdev */
-		sdev->request_queue = NULL;
-	}
+	/* NULL queue means the device can't be used */
+	sdev->request_queue = NULL;
 
 	scsi_target_reap(scsi_target(sdev));
 
@@ -937,6 +931,12 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(dev);
+
+	/* cause the request function to reject all I/O requests */
+	sdev->request_queue->queuedata = NULL;
+
+	/* Freeing the queue signals to block that we're done */
+	scsi_free_queue(sdev->request_queue);
 	put_device(dev);
 }
 
-- 
1.7.4.1



