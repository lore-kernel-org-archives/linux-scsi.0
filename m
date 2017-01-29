From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] storvsc: remove bogus code to transfer struct scatterlist
Date: Sun, 29 Jan 2017 10:12:18 +0100
Message-ID: <1485681138-21236-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:40112 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750799AbdA2KPl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jan 2017 05:15:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com
Cc: linux-scsi@vger.kernel.org

Remove a piece of code in storvsc_queuecommand that tries to pass the
physical address of the kernel struct scatterlist pointer to the host.

Fortunately the code can't ever be reached anyway.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/storvsc_drv.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 05526b7..62f4545 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1511,13 +1511,6 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 				page_to_pfn(sg_page((cur_sgl)));
 			cur_sgl = sg_next(cur_sgl);
 		}
-
-	} else if (scsi_sglist(scmnd)) {
-		payload->range.len = length;
-		payload->range.offset =
-			virt_to_phys(scsi_sglist(scmnd)) & (PAGE_SIZE-1);
-		payload->range.pfn_array[0] =
-			virt_to_phys(scsi_sglist(scmnd)) >> PAGE_SHIFT;
 	}
 
 	cmd_request->payload = payload;
-- 
2.1.4

