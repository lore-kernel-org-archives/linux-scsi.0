From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 12/29] qla2xxx: Prep zero-length BSG data-transfer requests.
Date: Thu, 9 Feb 2012 11:15:44 -0800
Message-ID: <1328814961-21866-13-git-send-email-chad.dupuis@qlogic.com>
References: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:39587
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758419Ab2BITcM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 14:32:12 -0500
Received: from mail219-ch1 (localhost [127.0.0.1])	by
 mail219-ch1-R.bigfish.com (Postfix) with ESMTP id CE4DB2201E2	for
 <linux-scsi@vger.kernel.org>; Thu,  9 Feb 2012 19:32:11 +0000 (UTC)
In-Reply-To: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

During command failure/non-recognition, the upper-layer
FC-transport expects the drivers to set
job-reply->reply_payload_rcv_len.  Do this in a consistent manner
to avoid duplication.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c |   24 +++++++-----------------
 1 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index b2b6644..0207143 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -108,8 +108,6 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct fc_bsg_job *bsg_job)
 	uint32_t len;
 	uint32_t oper;
 
-	bsg_job->reply->reply_payload_rcv_len = 0;
-
 	if (!(IS_QLA24XX_TYPE(ha) || IS_QLA25XX(ha) || IS_QLA82XX(ha))) {
 		ret = -EINVAL;
 		goto exit_fcp_prio_cfg;
@@ -729,7 +727,6 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 			if (qla81xx_get_port_config(vha, config)) {
 				ql_log(ql_log_warn, vha, 0x701f,
 				    "Get port config failed.\n");
-				bsg_job->reply->reply_payload_rcv_len = 0;
 				bsg_job->reply->result = (DID_ERROR << 16);
 				rval = -EPERM;
 				goto done_free_dma_req;
@@ -743,8 +740,6 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 					new_config)) {
 					ql_log(ql_log_warn, vha, 0x7024,
 					    "Internal loopback failed.\n");
-					bsg_job->reply->reply_payload_rcv_len =
-						0;
 					bsg_job->reply->result =
 						(DID_ERROR << 16);
 					rval = -EPERM;
@@ -756,8 +751,6 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 				 */
 				if (qla81xx_reset_internal_loopback(vha,
 					config, 1)) {
-					bsg_job->reply->reply_payload_rcv_len =
-						0;
 					bsg_job->reply->result =
 						(DID_ERROR << 16);
 					rval = -EPERM;
@@ -794,7 +787,6 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 					    "MPI reset failed.\n");
 				}
 
-				bsg_job->reply->reply_payload_rcv_len = 0;
 				bsg_job->reply->result = (DID_ERROR << 16);
 				rval = -EIO;
 				goto done_free_dma_req;
@@ -819,7 +811,6 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 		fw_sts_ptr += sizeof(response);
 		*fw_sts_ptr = command_sent;
 		rval = 0;
-		bsg_job->reply->reply_payload_rcv_len = 0;
 		bsg_job->reply->result = (DID_ERROR << 16);
 	} else {
 		ql_dbg(ql_dbg_user, vha, 0x702d,
@@ -878,7 +869,7 @@ qla84xx_reset(struct fc_bsg_job *bsg_job)
 	if (rval) {
 		ql_log(ql_log_warn, vha, 0x7030,
 		    "Vendor request 84xx reset failed.\n");
-		rval = bsg_job->reply->reply_payload_rcv_len = 0;
+		rval = 0;
 		bsg_job->reply->result = (DID_ERROR << 16);
 
 	} else {
@@ -977,9 +968,8 @@ qla84xx_updatefw(struct fc_bsg_job *bsg_job)
 		ql_log(ql_log_warn, vha, 0x7037,
 		    "Vendor request 84xx updatefw failed.\n");
 
-		rval = bsg_job->reply->reply_payload_rcv_len = 0;
+		rval = 0;
 		bsg_job->reply->result = (DID_ERROR << 16);
-
 	} else {
 		ql_dbg(ql_dbg_user, vha, 0x7038,
 		    "Vendor request 84xx updatefw completed.\n");
@@ -1165,7 +1155,7 @@ qla84xx_mgmt_cmd(struct fc_bsg_job *bsg_job)
 		ql_log(ql_log_warn, vha, 0x7043,
 		    "Vendor request 84xx mgmt failed.\n");
 
-		rval = bsg_job->reply->reply_payload_rcv_len = 0;
+		rval = 0;
 		bsg_job->reply->result = (DID_ERROR << 16);
 
 	} else {
@@ -1216,8 +1206,6 @@ qla24xx_iidma(struct fc_bsg_job *bsg_job)
 	uint16_t mb[MAILBOX_REGISTER_COUNT];
 	uint8_t *rsp_ptr = NULL;
 
-	bsg_job->reply->reply_payload_rcv_len = 0;
-
 	if (!IS_IIDMA_CAPABLE(vha->hw)) {
 		ql_log(ql_log_info, vha, 0x7046, "iiDMA not supported.\n");
 		return -EINVAL;
@@ -1310,8 +1298,6 @@ qla2x00_optrom_setup(struct fc_bsg_job *bsg_job, scsi_qla_host_t *vha,
 	int valid = 0;
 	struct qla_hw_data *ha = vha->hw;
 
-	bsg_job->reply->reply_payload_rcv_len = 0;
-
 	if (unlikely(pci_channel_offline(ha->pdev)))
 		return -EINVAL;
 
@@ -1623,6 +1609,9 @@ qla24xx_bsg_request(struct fc_bsg_job *bsg_job)
 	struct Scsi_Host *host;
 	scsi_qla_host_t *vha;
 
+	/* In case no data transferred. */
+	bsg_job->reply->reply_payload_rcv_len = 0;
+
 	if (bsg_job->request->msgcode == FC_BSG_RPT_ELS) {
 		rport = bsg_job->rport;
 		fcport = *(fc_port_t **) rport->dd_data;
@@ -1661,6 +1650,7 @@ qla24xx_bsg_request(struct fc_bsg_job *bsg_job)
 	case FC_BSG_RPT_CT:
 	default:
 		ql_log(ql_log_warn, vha, 0x705a, "Unsupported BSG request.\n");
+		bsg_job->reply->result = ret;
 		break;
 	}
 	return ret;
-- 
1.6.0.2


