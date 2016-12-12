From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v5 4/5] qla2xxx: Add Block Multi Queue functionality.
Date: Mon, 12 Dec 2016 14:40:08 -0800
Message-ID: <1481582409-22027-5-git-send-email-himanshu.madhani@cavium.com>
References: <1481582409-22027-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0084.outbound.protection.outlook.com ([104.47.34.84]:8944
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751697AbcLLWkm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Dec 2016 17:40:42 -0500
In-Reply-To: <1481582409-22027-1-git-send-email-himanshu.madhani@cavium.com>
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
 drivers/scsi/qla2xxx/qla_os.c | 47 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 42 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 6ef32c9..d10a876 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -13,6 +13,7 @@
 #include <linux/mutex.h>
 #include <linux/kobject.h>
 #include <linux/slab.h>
+#include <linux/blk-mq-pci.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsicam.h>
 #include <scsi/scsi_transport.h>
@@ -254,6 +255,7 @@
 static void qla2x00_clear_drv_active(struct qla_hw_data *);
 static void qla2x00_free_device(scsi_qla_host_t *);
 static void qla83xx_disable_laser(scsi_qla_host_t *vha);
+static int qla2xxx_map_queues(struct Scsi_Host *shost);
 
 struct scsi_host_template qla2xxx_driver_template = {
 	.module			= THIS_MODULE,
@@ -273,6 +275,7 @@ struct scsi_host_template qla2xxx_driver_template = {
 	.scan_finished		= qla2xxx_scan_finished,
 	.scan_start		= qla2xxx_scan_start,
 	.change_queue_depth	= scsi_change_queue_depth,
+	.map_queues             = qla2xxx_map_queues,
 	.this_id		= -1,
 	.cmd_per_lun		= 3,
 	.use_clustering		= ENABLE_CLUSTERING,
@@ -738,16 +741,26 @@ static void qla2x00_free_queues(struct qla_hw_data *ha)
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
@@ -2509,6 +2522,7 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 	uint16_t req_length = 0, rsp_length = 0;
 	struct req_que *req = NULL;
 	struct rsp_que *rsp = NULL;
+	int i;
 
 	bars = pci_select_bars(pdev, IORESOURCE_MEM | IORESOURCE_IO);
 	sht = &qla2xxx_driver_template;
@@ -2874,6 +2888,16 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
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
@@ -2965,8 +2989,14 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
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
@@ -6109,6 +6139,13 @@ struct fw_blob *
 	qla83xx_wr_reg(vha, reg, data);
 }
 
+static int qla2xxx_map_queues(struct Scsi_Host *shost)
+{
+	scsi_qla_host_t *vha = (scsi_qla_host_t *)shost->hostdata;
+
+	return blk_mq_pci_map_queues(&shost->tag_set, vha->hw->pdev);
+}
+
 static const struct pci_error_handlers qla2xxx_err_handler = {
 	.error_detected = qla2xxx_pci_error_detected,
 	.mmio_enabled = qla2xxx_pci_mmio_enabled,
-- 
1.8.3.1

