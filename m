From: michaelc@cs.wisc.edu
Subject: [PATCH 1/1] scsi_lib: use blk_rq_tagged in scsi_request_fn
Date: Tue, 22 Jul 2008 15:34:38 -0500
Message-ID: <1216758878-4358-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbYGVUem (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jul 2008 16:34:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

I goofed and did not see the macro for checking if a request is tagged.
This patch has us use blk_rq_tagged instead of digging into the req->tag.

Patch was made over scsi-misc.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a20730c..6d62be6 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1533,7 +1533,7 @@ static void scsi_request_fn(struct request_queue *q)
 		 * we add the dev to the starved list so it eventually gets
 		 * a run when a tag is freed.
 		 */
-		if (blk_queue_tagged(q) && (req->tag == -1)) {
+		if (blk_queue_tagged(q) && !blk_rq_tagged(req)) {
 			if (list_empty(&sdev->starved_entry))
 				list_add_tail(&sdev->starved_entry,
 					      &shost->starved_list);
-- 
1.5.4.1

