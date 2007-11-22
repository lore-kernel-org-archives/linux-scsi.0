From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH -mm 4/4] call dma_set_seg_boundary in __scsi_alloc_queue
Date: Thu, 22 Nov 2007 11:43:35 +0900
Message-ID: <20071122114218Q.tomof@acm.org>
References: <522edb7703e4a70374b0c689cd7bae659fb0908b.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:50993 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072AbXKVCoE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2007 21:44:04 -0500
In-Reply-To: <522edb7703e4a70374b0c689cd7bae659fb0908b.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, greg@kroah.com, jeff@garzik.org, fujita.tomonori@lab.ntt.co.jp

This is a one-line patch to add the following to __scsi_alloc_queue():

dma_set_seg_boundary(dev, shost->dma_boundary);

This is the simplest approach but the result looks odd,
__scsi_alloc_queue() does:

blk_queue_segment_boundary(q, shost->dma_boundary);
dma_set_seg_boundary(dev, shost->dma_boundary);
blk_queue_max_segment_size(q, dma_get_max_seg_size(dev));

I think that it would be better to set up segment boundary in the same
way as we did for the maximum segment size. That is, removing
shost->dma_boundary and LLDs call pci_set_dma_seg_boundary (or its
friends).

Then __scsi_alloc_queue() can set up both limits in the same way:

blk_queue_segment_boundary(q, dma_get_seg_boundary(dev));
blk_queue_max_segment_size(q, dma_get_max_seg_size(dev));

killing dma_boundary in scsi_host_template needs a large patch for
libata (dma_boundary is used by only libata and sym53c8xx). I'll send
a patch to do that if it is acceptable. James and Jeff?

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_lib.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 733176d..2a15a3b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1767,6 +1767,7 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
 	blk_queue_max_sectors(q, shost->max_sectors);
 	blk_queue_bounce_limit(q, scsi_calculate_bounce_limit(shost));
 	blk_queue_segment_boundary(q, shost->dma_boundary);
+	dma_set_seg_boundary(dev, shost->dma_boundary);
 
 	blk_queue_max_segment_size(q, dma_get_max_seg_size(dev));
 
-- 
1.5.3.4

