From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5/6] scsi: remove a useless get/put_device pair in scsi_next_command
Date: Thu, 06 Feb 2014 10:43:11 -0800
Message-ID: <20140206184418.063744285@bombadil.infradead.org>
References: <20140206184306.997538898@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58567 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756588AbaBFSoS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2014 13:44:18 -0500
Content-Disposition: inline; filename=0005-scsi-remove-a-useless-get-put_device-pair-in-scsi_ne.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>

From: Bart Van Assche <bvanassche@acm.org>

Eliminate a get_device() / put_device() pair from scsi_next_command().
Both are atomic operations hence removing these slightly improves
performance.

[hch: slight changes due to different context]

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7d35678..91ca414 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -526,14 +526,9 @@ void scsi_next_command(struct scsi_cmnd *cmd)
 	struct scsi_device *sdev = cmd->device;
 	struct request_queue *q = sdev->request_queue;
 
-	/* need to hold a reference on the device before we let go of the cmd */
-	get_device(&sdev->sdev_gendev);
-
 	scsi_put_command(cmd);
-	put_device(&sdev->sdev_gendev);
 	scsi_run_queue(q);
 
-	/* ok to remove device now */
 	put_device(&sdev->sdev_gendev);
 }
 
-- 
1.7.10.4


