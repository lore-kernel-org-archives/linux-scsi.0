From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [scsi 1/2 V2] scsi_debug: schedule_resp fix input variable check
Date: Mon, 23 Feb 2015 17:18:48 +0200
Message-ID: <1424704728-16445-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:35557 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbbBWPUZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Feb 2015 10:20:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley\"" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>, Douglas Gilbert <dgilbert@interlog.com>

The function should never be called with cmnd NULL so
put a fat WARN there.
Fix also smatch wraning:
schedule_resp() warn: variable dereferenced before check 'cmnd'

Cc: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
V2: 1. Actually drop struct scsi_device *sdp = cmnd->device;
    2. fix typo in comment
 drivers/scsi/scsi_debug.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index ccbe1282e975..6dda38ca83ee 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3945,13 +3945,20 @@ schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 	unsigned long iflags;
 	int k, num_in_q, qdepth, inject;
 	struct sdebug_queued_cmd *sqcp = NULL;
-	struct scsi_device *sdp = cmnd->device;
+	struct scsi_device *sdp;
+
+	/* this should never happen */
+	if (WARN_ON(!cmnd))
+		return SCSI_MLQUEUE_HOST_BUSY;
 
-	if (NULL == cmnd || NULL == devip) {
-		pr_warn("called with NULL cmnd or devip pointer\n");
+	if (NULL == devip) {
+		pr_warn("called devip == NULL\n");
 		/* no particularly good error to report back */
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
+
+	sdp = cmnd->device;
+
 	if ((scsi_result) && (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts))
 		sdev_printk(KERN_INFO, sdp, "%s: non-zero result=0x%x\n",
 			    __func__, scsi_result);
-- 
1.9.3

