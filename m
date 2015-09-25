From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH v2] scsi_debug: fix failure to probe with scsi_level=1 or 2 due to NULL devip
Date: Fri, 25 Sep 2015 09:02:07 -0400
Message-ID: <1443186127-8533-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755887AbbIYNCJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Sep 2015 09:02:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dgilbert@interlog.com

From: "Ewan D. Milne" <emilne@redhat.com>

commit cbf67842c3d9 ("scsi_debug: support scsi-mq, queues and locks")
added a test for devip == NULL in schedule_resp which returned
SCSI_MLQUEUE_HOST_BUSY.  However, devip will be NULL for any SCSI command
to a LUN above the configured value, and if scsi_level=1 or 2 is specified,
we will attempt to probe such unconfigured LUNs.  An INQUIRY command to an
unconfigured LUN will then be retried indefinitely with an error message.
Fix this by returning the command in the same context if no devip exists.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_debug.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index dfcc45b..a26b533 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3946,11 +3946,9 @@ schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 	if (WARN_ON(!cmnd))
 		return SCSI_MLQUEUE_HOST_BUSY;
 
-	if (NULL == devip) {
-		pr_warn("called devip == NULL\n");
-		/* no particularly good error to report back */
-		return SCSI_MLQUEUE_HOST_BUSY;
-	}
+	/* devip will be NULL when probing nonexistent LUNs w/o REPORT LUNS */
+	if (NULL == devip)
+		goto respond_in_thread;
 
 	sdp = cmnd->device;
 
-- 
2.1.0

