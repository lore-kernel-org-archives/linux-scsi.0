From: michaelc@cs.wisc.edu
Subject: [PATCH 1/4] scsi: fix shared tag map setup
Date: Fri, 11 Jul 2008 19:50:32 -0500
Message-ID: <1215823835-4865-2-git-send-email-michaelc@cs.wisc.edu>
References: <1215823835-4865-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755128AbYGLAvD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jul 2008 20:51:03 -0400
In-Reply-To: <1215823835-4865-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, promise_linux@promise.com, david.somayajulu@qlogic.com
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Currently qla4xxx and stex pass in their can_queue values into
scsi_activate_tcq because they wanted the tag map that large.
The problem with this is that it ends up also setting the queue
depth to that large value. All we want to do this in this case
is set the device queue depth and the other device settings.
We do not need to touch the tag map sizing because the drivers
had setup that map according to their can_queue limits when the
shared map was created.

The scsi mid layer in request_fn will then handle the case where we
have more requests than available tags when it checks the host
queue ready function.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 36c92f9..5276e73 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -902,11 +902,20 @@ void scsi_adjust_queue_depth(struct scsi_device *sdev, int tagged, int tags)
 
 	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
 
-	/* Check to see if the queue is managed by the block layer.
-	 * If it is, and we fail to adjust the depth, exit. */
-	if (blk_queue_tagged(sdev->request_queue) &&
-	    blk_queue_resize_tags(sdev->request_queue, tags) != 0)
-		goto out;
+	/*
+	 * Check to see if the queue is managed by the block layer.
+	 * If it is, and we fail to adjust the depth, exit.
+	 *
+	 * Do not resize the tag map if it is a host wide share bqt,
+	 * because the size should be the hosts's can_queue. If there
+	 * is more IO than the LLD's can_queue (so there are not enuogh
+	 * tags) request_fn's host queue ready check will handle it.
+	 */
+	if (!sdev->host->bqt) {
+		if (blk_queue_tagged(sdev->request_queue) &&
+		    blk_queue_resize_tags(sdev->request_queue, tags) != 0)
+			goto out;
+	}
 
 	sdev->queue_depth = tags;
 	switch (tagged) {
-- 
1.5.4.1

