From: michaelc@cs.wisc.edu
Subject: [PATCH 1/1] scsi: fix q->lock not held warning when target is busy
Date: Thu,  9 Apr 2009 15:57:10 -0500
Message-ID: <12393106303764-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60706 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274AbZDIU5S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Apr 2009 16:57:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

We cannot call blk_plug_device from scsi_target_queue_ready
because the q lock is not held. And we do not need to call
it from there because when we return 0, the scsi_request_fn
not_ready handling will plug the queue for us if needed.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_lib.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d1cb64a..bb218c8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1291,10 +1291,8 @@ static inline int scsi_target_queue_ready(struct Scsi_Host *shost,
 		if (--starget->target_blocked == 0) {
 			SCSI_LOG_MLQUEUE(3, starget_printk(KERN_INFO, starget,
 					 "unblocking target at zero depth\n"));
-		} else {
-			blk_plug_device(sdev->request_queue);
+		} else
 			return 0;
-		}
 	}
 
 	if (scsi_target_is_busy(starget)) {
-- 
1.6.0.6

