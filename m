From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 11/19] qla2xxx: Add bsg interface to support statistics counter reset.
Date: Wed, 6 Jul 2016 11:14:27 -0400
Message-ID: <1467818075-15246-12-git-send-email-himanshu.madhani@qlogic.com>
References: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:19269 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754145AbcGFQAI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 12:00:08 -0400
In-Reply-To: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, linux-scsi@vger.kernel.org

From: Sawan Chandak <sawan.chandak@qlogic.com>

Signed-off-by: Sawan Chandak <sawan.chandak@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 48 ++++++++++++++++++++++--------------------
 drivers/scsi/qla2xxx/qla_bsg.h |  1 +
 2 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 592e924..8a953aa 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2246,53 +2246,54 @@ qla2x00_get_priv_stats(struct fc_bsg_job *bsg_job)
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 	struct link_statistics *stats = NULL;
 	dma_addr_t stats_dma;
-	int rval = QLA_FUNCTION_FAILED;
+	int rval;
+	uint32_t *cmd = bsg_job->request->rqst_data.h_vendor.vendor_cmd;
+	uint options = cmd[0] == QL_VND_GET_PRIV_STATS_EX ? cmd[1] : 0;
 
 	if (test_bit(UNLOADING, &vha->dpc_flags))
-		goto done;
+		return -ENODEV;
 
 	if (unlikely(pci_channel_offline(ha->pdev)))
-		goto done;
+		return -ENODEV;
 
 	if (qla2x00_reset_active(vha))
-		goto done;
+		return -EBUSY;
 
 	if (!IS_FWI2_CAPABLE(ha))
-		goto done;
+		return -EPERM;
 
 	stats = dma_alloc_coherent(&ha->pdev->dev,
-		sizeof(struct link_statistics), &stats_dma, GFP_KERNEL);
+		sizeof(*stats), &stats_dma, GFP_KERNEL);
 	if (!stats) {
 		ql_log(ql_log_warn, vha, 0x70e2,
-		"Failed to allocate memory for stats.\n");
-		goto done;
+		    "Failed to allocate memory for stats.\n");
+		return -ENOMEM;
 	}
 
-	memset(stats, 0, sizeof(struct link_statistics));
-
-	rval = qla24xx_get_isp_stats(base_vha, stats, stats_dma, 0);
-
-	if (rval != QLA_SUCCESS)
-		goto done_free;
+	memset(stats, 0, sizeof(*stats));
 
-	ql_dump_buffer(ql_dbg_user + ql_dbg_verbose, vha, 0x70e3,
-	    (uint8_t *)stats, sizeof(struct link_statistics));
+	rval = qla24xx_get_isp_stats(base_vha, stats, stats_dma, options);
 
-	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
-	bsg_job->reply_payload.sg_cnt, stats, sizeof(struct link_statistics));
-	bsg_job->reply->reply_payload_rcv_len = sizeof(struct link_statistics);
+	if (rval == QLA_SUCCESS) {
+		ql_dump_buffer(ql_dbg_user + ql_dbg_verbose, vha, 0x70e3,
+		    (uint8_t *)stats, sizeof(*stats));
+		sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
+			bsg_job->reply_payload.sg_cnt, stats, sizeof(*stats));
+	}
 
-	bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] = EXT_STATUS_OK;
+	bsg_job->reply->reply_payload_rcv_len = sizeof(*stats);
+	bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
+	    rval ? EXT_STATUS_MAILBOX : EXT_STATUS_OK;
 
-	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
+	bsg_job->reply_len = sizeof(*bsg_job->reply);
 	bsg_job->reply->result = DID_OK << 16;
 	bsg_job->job_done(bsg_job);
 
 done_free:
-	dma_free_coherent(&ha->pdev->dev, sizeof(struct link_statistics),
+	dma_free_coherent(&ha->pdev->dev, sizeof(*stats),
 		stats, stats_dma);
 done:
-	return rval;
+	return 0;
 }
 
 static int
@@ -2401,6 +2402,7 @@ qla2x00_process_vendor_specific(struct fc_bsg_job *bsg_job)
 		return qla27xx_get_bbcr_data(bsg_job);
 
 	case QL_VND_GET_PRIV_STATS:
+	case QL_VND_GET_PRIV_STATS_EX:
 		return qla2x00_get_priv_stats(bsg_job);
 
 	case QL_VND_DPORT_DIAGNOSTICS:
diff --git a/drivers/scsi/qla2xxx/qla_bsg.h b/drivers/scsi/qla2xxx/qla_bsg.h
index 3b1045f..d97dfd5 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.h
+++ b/drivers/scsi/qla2xxx/qla_bsg.h
@@ -30,6 +30,7 @@
 #define QL_VND_GET_BBCR_DATA    0x17
 #define QL_VND_GET_PRIV_STATS	0x18
 #define QL_VND_DPORT_DIAGNOSTICS	0x19
+#define QL_VND_GET_PRIV_STATS_EX	0x1A
 
 /* BSG Vendor specific subcode returns */
 #define EXT_STATUS_OK			0
-- 
2.7.2

