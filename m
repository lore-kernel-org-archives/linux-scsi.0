From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [scsi 1/2] scsi_debug: schedule_resp fix input variable check
Date: Mon, 23 Feb 2015 13:13:20 +0200
Message-ID: <1424690001-2482-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:43223 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215AbbBWLO0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Feb 2015 06:14:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley\"" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>

The function should never be called with cmnd NULL so
put a fat WARN there.
Fix also smatch wraning:
schedule_resp() warn: variable dereferenced before check 'cmnd'

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/scsi/scsi_debug.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index ccbe1282e975..f032aac75997 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3947,11 +3947,18 @@ schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 	struct sdebug_queued_cmd *sqcp = NULL;
 	struct scsi_device *sdp = cmnd->device;
 
-	if (NULL == cmnd || NULL == devip) {
-		pr_warn("called with NULL cmnd or devip pointer\n");
+	/* this should never happend */
+	if (WARN_ON(!cmnd))
+		return SCSI_MLQUEUE_HOST_BUSY;
+
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

