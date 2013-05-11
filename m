From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] qla2x00t: Fix a memory leak in an error path
Date: Sat, 11 May 2013 14:38:15 +0200
Message-ID: <518E3BB7.20109@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:44106 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab3EKMiS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 11 May 2013 08:38:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Avoid that the fcport structure gets leaked if
bsg_job->request->msgcode == FC_BSG_HST_ELS_NOLOGIN, the fcport
allocation succeeds and the !vha->flags.online branch is taken.
Detected by Coverity.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 39719f8..af35707 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -329,7 +329,7 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
 	if (!vha->flags.online) {
 		ql_log(ql_log_warn, vha, 0x7005, "Host not online.\n");
 		rval = -EIO;
-		goto done;
+		goto done_free_fcport;
 	}
 
 	req_sg_cnt =
-- 
1.7.10.4

