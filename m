From: michaelc@cs.wisc.edu
Subject: [PATCH 4/4] scsi: fix shared tag map tag allocation
Date: Fri, 11 Jul 2008 19:50:35 -0500
Message-ID: <1215823835-4865-5-git-send-email-michaelc@cs.wisc.edu>
References: <1215823835-4865-1-git-send-email-michaelc@cs.wisc.edu>
 <1215823835-4865-2-git-send-email-michaelc@cs.wisc.edu>
 <1215823835-4865-3-git-send-email-michaelc@cs.wisc.edu>
 <1215823835-4865-4-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755782AbYGLAvD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jul 2008 20:51:03 -0400
In-Reply-To: <1215823835-4865-4-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, promise_linux@promise.com, david.somayajulu@qlogic.com
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

When drivers use a shared tag map we can end up with more requests
than tags, because the tag map is shost->can_queue tags and there
can be sdevs * sdev->queue_depth requests. In scsi_request_fn
if tag allocation fails we just drop down to just dequeueing the
tag without a tag. The problem is that drivers using the shared tag
map rely on a valid tag always being set, because it will use the
tag number to lookup commands later.

This patch has us check if we got a valid tag when the host lock
is held right before we check if the host queue is ready. We do the
check here because to allocate the tag we need the q lock, but
if the tag is bad we want to add the device/q onto the starved list
which requires the host lock.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_lib.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0451903..f1af78d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1488,6 +1488,21 @@ static void scsi_request_fn(struct request_queue *q)
 		}
 		spin_lock(shost->host_lock);
 
+		/*
+		 * We hit this when the driver is using a host wide
+		 * tag map. For device level tag maps the queue_depth check
+		 * in the device ready fn would prevent us from trying
+		 * to allocate a tag. Since the map is a shared host resource
+		 * we add the dev to the starved list so it eventually gets
+		 * a run when a tag is freed.
+		 */
+		if (blk_queue_tagged(q) && (req->tag == -1)) {
+			if (list_empty(&sdev->starved_entry))
+				list_add_tail(&sdev->starved_entry,
+					      &shost->starved_list);
+			goto not_ready;
+		}
+
 		if (!scsi_host_queue_ready(q, shost, sdev))
 			goto not_ready;
 		if (scsi_target(sdev)->single_lun) {
-- 
1.5.4.1

