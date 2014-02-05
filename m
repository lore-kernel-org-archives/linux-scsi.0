From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 13/15] scsi: partially stub out scsi_adjust_queue_depth when using blk-mq
Date: Wed, 05 Feb 2014 04:41:31 -0800
Message-ID: <20140205124154.547270203@bombadil.infradead.org>
References: <20140205124118.332902571@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53242 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbaBEMl4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Feb 2014 07:41:56 -0500
Content-Disposition: inline; filename=0013-scsi-partially-stub-out-scsi_adjust_queue_depth-when.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org

This will have to be funnelled to blk-mq directly, but skip it for now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index cf5c110..014b642 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -837,7 +837,7 @@ void scsi_adjust_queue_depth(struct scsi_device *sdev, int tagged, int tags)
 	 * is more IO than the LLD's can_queue (so there are not enuogh
 	 * tags) request_fn's host queue ready check will handle it.
 	 */
-	if (!sdev->host->bqt) {
+	if (!sdev->host->hostt->use_blk_mq && !sdev->host->bqt) {
 		if (blk_queue_tagged(sdev->request_queue) &&
 		    blk_queue_resize_tags(sdev->request_queue, tags) != 0)
 			goto out;
-- 
1.7.10.4


