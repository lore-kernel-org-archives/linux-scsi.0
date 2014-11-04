From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/11] ufs: remove spurious scsi_set_tag_type call
Date: Tue,  4 Nov 2014 08:54:16 +0100
Message-ID: <1415087656-9491-12-git-send-email-hch@lst.de>
References: <1415087656-9491-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:34732 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbaKDHy0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2014 02:54:26 -0500
In-Reply-To: <1415087656-9491-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

ufs never looks at the tag type, so there is no need to set it either.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/ufs/ufshcd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 67e2280..362b818 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2768,7 +2768,6 @@ static int ufshcd_slave_alloc(struct scsi_device *sdev)
 
 	/* Mode sense(6) is not supported by UFS, so use Mode sense(10) */
 	sdev->use_10_for_ms = 1;
-	scsi_set_tag_type(sdev, MSG_SIMPLE_TAG);
 
 	/* allow SCSI layer to restart the device in case of errors */
 	sdev->allow_restart = 1;
-- 
1.9.1

