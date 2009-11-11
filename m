From: michaelc@cs.wisc.edu
Subject: [PATCH 7/7] libiscsi: hook into ramp up/down handling
Date: Wed, 11 Nov 2009 16:34:36 -0600
Message-ID: <1257978876-2742-8-git-send-email-michaelc@cs.wisc.edu>
References: <1257978876-2742-1-git-send-email-michaelc@cs.wisc.edu>
 <1257978876-2742-2-git-send-email-michaelc@cs.wisc.edu>
 <1257978876-2742-3-git-send-email-michaelc@cs.wisc.edu>
 <1257978876-2742-4-git-send-email-michaelc@cs.wisc.edu>
 <1257978876-2742-5-git-send-email-michaelc@cs.wisc.edu>
 <1257978876-2742-6-git-send-email-michaelc@cs.wisc.edu>
 <1257978876-2742-7-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759509AbZKKWey (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Nov 2009 17:34:54 -0500
In-Reply-To: <1257978876-2742-7-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

It is rare to get a queue full with iscsi, because targets seem to
just reduce the iscsi cmd window. However, there is at least
one iscsi target that will throw a queue full when overloaded.
This hooks the iscsi code in to the ramp up/down code, so we
can handle it.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 07ec997..b7689f3 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1739,10 +1739,19 @@ EXPORT_SYMBOL_GPL(iscsi_queuecommand);
 
 int iscsi_change_queue_depth(struct scsi_device *sdev, int depth, int reason)
 {
-	if (reason != SCSI_QDEPTH_DEFAULT)
+	switch (reason) {
+	case SCSI_QDEPTH_DEFAULT:
+		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), depth);
+		break;
+	case SCSI_QDEPTH_QFULL:
+		scsi_track_queue_full(sdev, depth);
+		break;
+	case SCSI_QDEPTH_RAMP_UP:
+		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), depth);
+		break;
+	default:
 		return -EOPNOTSUPP;
-
-	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), depth);
+	}
 	return sdev->queue_depth;
 }
 EXPORT_SYMBOL_GPL(iscsi_change_queue_depth);
-- 
1.6.2.2

