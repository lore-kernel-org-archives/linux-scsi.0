From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 4/5] qla2xxx: Obtain loopback iteration count from bsg request.
Date: Thu, 28 Mar 2013 08:21:26 -0400
Message-ID: <1364473287-27640-5-git-send-email-saurav.kashyap@qlogic.com>
References: <1364473287-27640-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:18916 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755410Ab3C1MoU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Mar 2013 08:44:20 -0400
In-Reply-To: <1364473287-27640-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

qla2x00_loopback_test() was hard setting the loopback iteration
count to 1 rather than obtaining it from the bsg request.

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c |    2 ++
 drivers/scsi/qla2xxx/qla_def.h |    1 +
 drivers/scsi/qla2xxx/qla_mbx.c |    5 ++---
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 8631a7e..a708bad 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -768,6 +768,8 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 	elreq.transfer_size = req_data_len;
 
 	elreq.options = bsg_job->request->rqst_data.h_vendor.vendor_cmd[1];
+	elreq.iteration_count =
+	    bsg_job->request->rqst_data.h_vendor.vendor_cmd[2];
 
 	if (atomic_read(&vha->loop_state) == LOOP_READY &&
 	    (ha->current_topology == ISP_CFG_F ||
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index e52722d..c32efc7 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -417,6 +417,7 @@ struct msg_echo_lb {
 	uint16_t rsp_sg_cnt;
 	uint16_t options;
 	uint32_t transfer_size;
+	uint32_t iteration_count;
 };
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 3b6a41c..9e5d89d 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4113,7 +4113,6 @@ qla2x00_loopback_test(scsi_qla_host_t *vha, struct msg_echo_lb *mreq,
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
-	uint32_t iter_cnt = 0x1;
 
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x10f7,
 	    "Entered %s.\n", __func__);
@@ -4139,8 +4138,8 @@ qla2x00_loopback_test(scsi_qla_host_t *vha, struct msg_echo_lb *mreq,
 	mcp->mb[7] = MSW(MSD(mreq->rcv_dma));
 
 	/* Iteration count */
-	mcp->mb[18] = LSW(iter_cnt);
-	mcp->mb[19] = MSW(iter_cnt);
+	mcp->mb[18] = LSW(mreq->iteration_count);
+	mcp->mb[19] = MSW(mreq->iteration_count);
 
 	mcp->out_mb = MBX_21|MBX_20|MBX_19|MBX_18|MBX_17|MBX_16|MBX_15|
 	    MBX_14|MBX_13|MBX_12|MBX_11|MBX_10|MBX_7|MBX_6|MBX_1|MBX_0;
-- 
1.7.7

