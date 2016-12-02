From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v3 5/6] qla2xxx: Add Block Multi Queue functionality.
Date: Fri, 2 Dec 2016 13:44:56 -0800
Message-ID: <1480715097-13611-6-git-send-email-himanshu.madhani@cavium.com>
References: <1480715097-13611-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0073.outbound.protection.outlook.com ([104.47.36.73]:63950
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751845AbcLBWAu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Dec 2016 17:00:50 -0500
In-Reply-To: <1480715097-13611-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

From: Michael Hernandez <michael.hernandez@cavium.com>

Tell the SCSI layer how many hardware queues we have based on the number
of max queue pairs created. The number of max queue pairs created will
depend on number of MSI-X vector count.

This feature can be turned on via CONFIG_SCSI_MQ_DEFAULT or passing
scsi_mod.use_blk_mq=Y as a parameter to the kernel

Queue pair creation depend on module parameter "ql2xmqsupport", which
need to be enabled to create queue pair.

Signed-off-by: Sawan Chandak <sawan.chandak@cavium.com>
Signed-off-by: Michael Hernandez <michael.hernandez@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 37 ++++++++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index b06722a..3371b3f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -667,16 +667,26 @@ static void qla2x00_free_queues(struct qla_hw_data *ha)
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 	srb_t *sp;
 	int rval;
-	struct qla_qpair *qpair;
+	struct qla_qpair *qpair = NULL;
+	uint32_t tag;
+	uint16_t hwq;
 
 	if (unlikely(test_bit(UNLOADING, &base_vha->dpc_flags))) {
 		cmd->result = DID_NO_CONNECT << 16;
 		goto qc24_fail_command;
 	}
 
-	if (vha->vp_idx && vha->qpair) {
-		qpair = vha->qpair;
-		return qla2xxx_mqueuecommand(host, cmd, qpair);
+	if (ha->mqenable) {
+		if (shost_use_blk_mq(vha->host)) {
+			tag = blk_mq_unique_tag(cmd->request);
+			hwq = blk_mq_unique_tag_to_hwq(tag);
+			qpair = ha->queue_pair_map[hwq];
+		} else if (vha->vp_idx && vha->qpair) {
+			qpair = vha->qpair;
+		}
+
+		if (qpair)
+			return qla2xxx_mqueuecommand(host, cmd, qpair);
 	}
 
 	if (ha->flags.eeh_busy) {
@@ -2362,6 +2372,7 @@ static void qla2x00_destroy_mbx_wq(struct qla_hw_data *ha)
 	uint16_t req_length = 0, rsp_length = 0;
 	struct req_que *req = NULL;
 	struct rsp_que *rsp = NULL;
+	int i;
 
 	bars = pci_select_bars(pdev, IORESOURCE_MEM | IORESOURCE_IO);
 	sht = &qla2xxx_driver_template;
@@ -2727,6 +2738,16 @@ static void qla2x00_destroy_mbx_wq(struct qla_hw_data *ha)
 		goto probe_init_failed;
 	}
 
+	if (ha->mqenable && shost_use_blk_mq(host)) {
+		/* number of hardware queues supported by blk/scsi-mq*/
+		host->nr_hw_queues = ha->max_qpairs;
+
+		ql_dbg(ql_dbg_init, base_vha, 0x0192,
+			"blk/scsi-mq enabled, HW queues = %d.\n", host->nr_hw_queues);
+	} else
+		ql_dbg(ql_dbg_init, base_vha, 0x0193,
+			"blk/scsi-mq disabled.\n");
+
 	qlt_probe_one_stage1(base_vha, ha);
 
 	pci_save_state(pdev);
@@ -2827,8 +2848,14 @@ static void qla2x00_destroy_mbx_wq(struct qla_hw_data *ha)
 	    host->can_queue, base_vha->req,
 	    base_vha->mgmt_svr_loop_id, host->sg_tablesize);
 
-	if (ha->mqenable)
+	if (ha->mqenable) {
 		ha->wq = alloc_workqueue("qla2xxx_wq", WQ_MEM_RECLAIM, 1);
+		/* Create start of day qpairs for Block MQ */
+		if (shost_use_blk_mq(host)) {
+			for (i = 0; i < ha->max_qpairs; i++)
+				qla2xxx_create_qpair(base_vha, 5, 0);
+		}
+	}
 
 	if (ha->flags.running_gold_fw)
 		goto skip_dpc;
-- 
1.8.3.1

