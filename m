From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 16/16] qla2xxx: Fix a memory leak in an error path of qla2x00_process_els()
Date: Tue, 25 Jun 2013 11:27:31 -0400
Message-ID: <1372174051-4211-17-git-send-email-saurav.kashyap@qlogic.com>
References: <1372174051-4211-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:46421 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752198Ab3FYPxx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jun 2013 11:53:53 -0400
Received: from mail83-tx2 (localhost [127.0.0.1])	by mail83-tx2-R.bigfish.com
 (Postfix) with ESMTP id 5569F440147	for <linux-scsi@vger.kernel.org>; Tue, 25
 Jun 2013 15:53:52 +0000 (UTC)
Received: from TX2EHSMHS009.bigfish.com (unknown [10.9.14.231])	by
 mail83-tx2.bigfish.com (Postfix) with ESMTP id B0403100240	for
 <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2013 15:53:50 +0000 (UTC)
In-Reply-To: <1372174051-4211-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

Avoid that the fcport structure gets leaked if
bsg_job->request->msgcode == FC_BSG_HST_ELS_NOLOGIN, the fcport
allocation succeeds and the !vha->flags.online branch is taken.
This was detected by Coverity. However, Coverity does not recognize
that all qla2x00_process_els() callers specify either
FC_BSG_RPT_ELS or FC_BSG_HST_ELS_NOLOGIN in the field
bsg_job->request->msgcode and that the value of that field is not
modified inside that function. This results in a false positive
report about a possible memory leak in an error path for
bsg_job->request->msgcode values other than the two mentioned
values.  Make it easy for Coverity (and for humans) to recognize
that there is no fcport leak in the error path by changing the
bsg_job->request->msgcode == FC_BSG_HST_ELS_NOLOGIN test into
bsg_job->request->msgcode != FC_BSG_RPT_ELS.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index b85f002..417eaad 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -269,6 +269,12 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
 		type = "FC_BSG_HST_ELS_NOLOGIN";
 	}
 
+	if (!vha->flags.online) {
+		ql_log(ql_log_warn, vha, 0x7005, "Host not online.\n");
+		rval = -EIO;
+		goto done;
+	}
+
 	/* pass through is supported only for ISP 4Gb or higher */
 	if (!IS_FWI2_CAPABLE(ha)) {
 		ql_dbg(ql_dbg_user, vha, 0x7001,
@@ -326,12 +332,6 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
 			NPH_FABRIC_CONTROLLER : NPH_F_PORT;
 	}
 
-	if (!vha->flags.online) {
-		ql_log(ql_log_warn, vha, 0x7005, "Host not online.\n");
-		rval = -EIO;
-		goto done;
-	}
-
 	req_sg_cnt =
 		dma_map_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
 		bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
@@ -399,7 +399,7 @@ done_unmap_sg:
 	goto done_free_fcport;
 
 done_free_fcport:
-	if (bsg_job->request->msgcode == FC_BSG_HST_ELS_NOLOGIN)
+	if (bsg_job->request->msgcode == FC_BSG_RPT_ELS)
 		kfree(fcport);
 done:
 	return rval;
-- 
1.7.7


