From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH] scsi_debug: fix failure to probe with scsi_level=1 or 2 due to NULL devip
Date: Tue, 25 Aug 2015 15:47:54 -0400
Message-ID: <1440532074-28321-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbbHYTr5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2015 15:47:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, dgilbert@interlog.com

From: "Ewan D. Milne" <emilne@redhat.com>

commit cbf67842c3d9 ("scsi_debug: support scsi-mq, queues and locks")
added a test for devip == NULL in schedule_resp which returned
SCSI_MLQUEUE_HOST_BUSY.  Unfortunately, if scsi_level 1 or 2 is specified,
devip will be NULL for the INQUIRY command for the next LUN above the
configured value and it will be retried indefinitely with an error message.
Fix this by returning the command in the same context if no devip exists.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_debug.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 30268bb..25f5cee1 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3944,8 +3944,11 @@ schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 	struct sdebug_queued_cmd *sqcp = NULL;
 	struct scsi_device *sdp = cmnd->device;
 
-	if (NULL == cmnd || NULL == devip) {
-		pr_warn("%s: called with NULL cmnd or devip pointer\n",
+	/* devip will be NULL when probing nonexistent LUNs w/o REPORT LUNS */
+	if (NULL == devip)
+		goto respond_in_thread;
+	if (NULL == cmnd) {
+		pr_warn("%s: called with NULL cmnd pointer\n",
 			__func__);
 		/* no particularly good error to report back */
 		return SCSI_MLQUEUE_HOST_BUSY;
-- 
2.1.0

