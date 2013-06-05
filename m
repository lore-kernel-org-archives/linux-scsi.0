From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 10/10] qla2xxx: Fix a memory leak in an error path of qla2x00_process_els()
Date: Wed, 05 Jun 2013 15:09:59 +0200
Message-ID: <51AF38A7.6020808@acm.org>
References: <51AF36BF.3030602@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:34589 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab3FENKB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jun 2013 09:10:01 -0400
In-Reply-To: <51AF36BF.3030602@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>

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
Cc: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index cf07491..f8a2634 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -255,6 +255,12 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
 	int rval =  (DRIVER_ERROR << 16);
 	uint16_t nextlid = 0;
 
+	if (!vha->flags.online) {
+		ql_log(ql_log_warn, vha, 0x7005, "Host not online.\n");
+		rval = -EIO;
+		goto done;
+	}
+
 	if (bsg_job->request->msgcode == FC_BSG_RPT_ELS) {
 		rport = bsg_job->rport;
 		fcport = *(fc_port_t **) rport->dd_data;
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
+	if (bsg_job->request->msgcode != FC_BSG_RPT_ELS)
 		kfree(fcport);
 done:
 	return rval;
-- 
1.7.10.4

