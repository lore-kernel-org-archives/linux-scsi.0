From: Jeff Moyer <jmoyer@redhat.com>
Subject: [patch,v3 10/10] cciss: use blk_init_queue_node
Date: Fri,  9 Nov 2012 14:18:07 -0500
Message-ID: <1352488687-19935-11-git-send-email-jmoyer@redhat.com>
References: <1352488687-19935-1-git-send-email-jmoyer@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755392Ab2KITSd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Nov 2012 14:18:33 -0500
In-Reply-To: <1352488687-19935-1-git-send-email-jmoyer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, Mike Miller <mike.miller@hp.com>, iss_storagedev@hp.com


Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 drivers/block/cciss.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index b0f553b..5fe5546 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1930,7 +1930,8 @@ static void cciss_get_serial_no(ctlr_info_t *h, int logvol,
 static int cciss_add_disk(ctlr_info_t *h, struct gendisk *disk,
 				int drv_index)
 {
-	disk->queue = blk_init_queue(do_cciss_request, &h->lock);
+	disk->queue = blk_init_queue_node(do_cciss_request, &h->lock,
+					  dev_to_node(&h->dev));
 	if (!disk->queue)
 		goto init_queue_failure;
 	sprintf(disk->disk_name, "cciss/c%dd%d", h->ctlr, drv_index);
-- 
1.7.1

