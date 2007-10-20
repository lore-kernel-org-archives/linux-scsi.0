From: michaelc@cs.wisc.edu
Subject: [PATCH 06/10] use GFP_NOIO in dm rdac
Date: Sat, 20 Oct 2007 00:44:40 -0500
Message-ID: <11928590884170-git-send-email-michaelc@cs.wisc.edu>
References: <11928590843394-git-send-email-michaelc@cs.wisc.edu>
 <1192859085521-git-send-email-michaelc@cs.wisc.edu>
 <11928590862112-git-send-email-michaelc@cs.wisc.edu>
 <11928590861021-git-send-email-michaelc@cs.wisc.edu>
 <11928590871413-git-send-email-michaelc@cs.wisc.edu>
 <11928590871678-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763224AbXJTFo6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Oct 2007 01:44:58 -0400
In-Reply-To: <11928590871678-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, dm-devel@redhat.com, jens.axboe@oracle.com
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

The pg_init path needs to be GFP_NOIO since it used
to failover a deviec and we cannot end up calling
back into the device.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/md/dm-mpath-rdac.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-mpath-rdac.c b/drivers/md/dm-mpath-rdac.c
index 9e71e0e..bb8ce6d 100644
--- a/drivers/md/dm-mpath-rdac.c
+++ b/drivers/md/dm-mpath-rdac.c
@@ -271,7 +271,7 @@ static struct request *get_rdac_req(struct rdac_handler *h,
 	struct request *rq;
 	struct request_queue *q = bdev_get_queue(h->path->dev->bdev);
 
-	rq = blk_get_request(q, rw, GFP_KERNEL);
+	rq = blk_get_request(q, rw, GFP_NOIO);
 
 	if (!rq) {
 		DMINFO("get_rdac_req: blk_get_request failed");
@@ -279,7 +279,7 @@ static struct request *get_rdac_req(struct rdac_handler *h,
 	}
 
 	if (buflen && blk_rq_map_kern(NULL, q, rq, buffer, buflen,
-				      GFP_KERNEL)) {
+				      GFP_NOIO)) {
 		blk_put_request(rq);
 		DMINFO("get_rdac_req: blk_rq_map_kern failed");
 		return NULL;
-- 
1.5.1.2

