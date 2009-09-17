From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 07/20] cciss: Handle failure of blk_init_queue gracefully in
	cciss_add_disk.
Date: Thu, 17 Sep 2009 13:47:24 -0500
Message-ID: <20090917184724.15105.3664.stgit@beardog.cce.hp.com>
References: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0028.austin.hp.com ([15.216.28.35]:1166 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759436AbZIQSqz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2009 14:46:55 -0400
In-Reply-To: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, andrew.patterson@hp.com, mikem@beardog.cce.hp.com, scameron@beardog.cce.hp.com

Handle failure of blk_init_queue gracefully in cciss_add_disk.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/block/cciss.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 557b958..60fe3c6 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1689,6 +1689,8 @@ static int cciss_add_disk(ctlr_info_t *h, struct gendisk *disk,
 				int drv_index)
 {
 	disk->queue = blk_init_queue(do_cciss_request, &h->lock);
+	if (!disk->queue)
+		goto init_queue_failure;
 	sprintf(disk->disk_name, "cciss/c%dd%d", h->ctlr, drv_index);
 	disk->major = h->major;
 	disk->first_minor = drv_index << NWD_SHIFT;
@@ -1729,6 +1731,7 @@ static int cciss_add_disk(ctlr_info_t *h, struct gendisk *disk,
 cleanup_queue:
 	blk_cleanup_queue(disk->queue);
 	disk->queue = NULL;
+init_queue_failure:
 	return -1;
 }
 

