From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 10/17] scsi: micro-optimize scsi_next_command()
Date: Wed, 05 Feb 2014 04:39:40 -0800
Message-ID: <20140205124020.734455085@bombadil.infradead.org>
References: <20140205123930.150608699@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53166 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaBEMkW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Feb 2014 07:40:22 -0500
Content-Disposition: inline; filename=0010-scsi-micro-optimize-scsi_next_command.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>

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
index 568ac24..84d8211 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -521,14 +521,9 @@ void scsi_next_command(struct scsi_cmnd *cmd)
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


