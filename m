From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v4 5/6] qla2xxx: Add Block Multi Queue functionality.
Date: Tue, 6 Dec 2016 11:07:45 -0800
Message-ID: <1481051266-32362-6-git-send-email-himanshu.madhani@cavium.com>
References: <1481051266-32362-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0059.outbound.protection.outlook.com ([104.47.36.59]:56361
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753154AbcLFTI0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Dec 2016 14:08:26 -0500
In-Reply-To: <1481051266-32362-1-git-send-email-himanshu.madhani@cavium.com>
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

Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Sawan Chandak <sawan.chandak@cavium.com>
Signed-off-by: Michael Hernandez <michael.hernandez@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 37 ++++++++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c5d0525..bc7008d 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -738,16 +738,26 @@ static void qla2x00_free_queues(struct qla_hw_data *ha)
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
@@ -2520,6 +2530,7 @@ static void qla2x00_destroy_mbx_wq(struct qla_hw_data *ha)
 	uint16_t req_length = 0, rsp_length = 0;
 	struct req_que *req = NULL;
 	struct rsp_que *rsp = NULL;
+	int i;
 
 	bars = pci_select_bars(pdev, IORESOURCE_MEM | IORESOURCE_IO);
 	sht = &qla2xxx_driver_template;
@@ -2885,6 +2896,16 @@ static void qla2x00_destroy_mbx_wq(struct qla_hw_data *ha)
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
@@ -2985,8 +3006,14 @@ static void qla2x00_destroy_mbx_wq(struct qla_hw_data *ha)
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

