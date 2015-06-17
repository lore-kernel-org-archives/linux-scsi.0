From: Maninder Singh <maninder1.s@samsung.com>
Subject: [PATCH 1/1] scsi: Initialize sdp after NULL check of cmnd
Date: Wed, 17 Jun 2015 16:51:07 +0530
Message-ID: <1434540067-69384-1-git-send-email-maninder1.s@samsung.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:39648 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756AbbFQLWC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2015 07:22:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: pankaj.m@samsung.com, Maninder Singh <maninder1.s@samsung.com>

Currently cmnd pointer is already dereferenced before NULL check
and thus getting below warning in static analysis:
warn: variable dereferenced before check 'cmnd'

So initialize struct scsi_device *sdp after NULL check
of cmnd


Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Reviewed-by: Akhilesh Kumar <akhilesh.k@samsung.com>
---
 drivers/scsi/scsi_debug.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 1f8e2dc..bb97a5a 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3942,7 +3942,7 @@ schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 	unsigned long iflags;
 	int k, num_in_q, qdepth, inject;
 	struct sdebug_queued_cmd *sqcp = NULL;
-	struct scsi_device *sdp = cmnd->device;
+	struct scsi_device *sdp;
 
 	if (NULL == cmnd || NULL == devip) {
 		pr_warn("%s: called with NULL cmnd or devip pointer\n",
@@ -3950,6 +3950,8 @@ schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 		/* no particularly good error to report back */
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
+
+	sdp = cmnd->device;
 	if ((scsi_result) && (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts))
 		sdev_printk(KERN_INFO, sdp, "%s: non-zero result=0x%x\n",
 			    __func__, scsi_result);
-- 
1.7.1

