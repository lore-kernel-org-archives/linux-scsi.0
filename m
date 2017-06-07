From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 08/15] qla2xxx: Use shadow register for ISP27XX
Date: Wed, 7 Jun 2017 14:43:26 -0700
Message-ID: <20170607214333.23110-9-himanshu.madhani@cavium.com>
References: <20170607214333.23110-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0063.outbound.protection.outlook.com ([104.47.34.63]:40418
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751694AbdFGVn7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 7 Jun 2017 17:43:59 -0400
In-Reply-To: <20170607214333.23110-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

From: Quinn Tran <quinn.tran@cavium.com>

For ISP27XX, use shadow register to read FW provided
REQQ's consumer index. The shadow register is dma'ed
by firmware.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h    | 1 +
 drivers/scsi/qla2xxx/qla_init.c   | 1 +
 drivers/scsi/qla2xxx/qla_os.c     | 1 +
 drivers/scsi/qla2xxx/qla_target.c | 3 ++-
 4 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index dfa001357110..b3ba32773db4 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3266,6 +3266,7 @@ struct qla_qpair {
 	uint32_t fw_started:1;
 	uint32_t enable_class_2:1;
 	uint32_t enable_explicit_conf:1;
+	uint32_t use_shadow_reg:1;
 
 	uint16_t id;			/* qp number used with FW */
 	uint16_t vp_idx;		/* vport ID */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 360abede3f6b..f586f4f7dc57 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -7614,6 +7614,7 @@ struct qla_qpair *qla2xxx_create_qpair(struct scsi_qla_host *vha, int qos,
 		qpair->vha = vha;
 		qpair->qp_lock_ptr = &qpair->qp_lock;
 		spin_lock_init(&qpair->qp_lock);
+		qpair->use_shadow_reg = IS_SHADOW_REG_CAPABLE(ha) ? 1 : 0;
 
 		/* Assign available que pair id */
 		mutex_lock(&ha->mq_lock);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 44be2c8237fd..1d66954b7e5a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -384,6 +384,7 @@ static int qla2x00_alloc_queues(struct qla_hw_data *ha, struct req_que *req,
 	ha->base_qpair->rsp = rsp;
 	ha->base_qpair->vha = vha;
 	ha->base_qpair->qp_lock_ptr = &ha->hardware_lock;
+	ha->base_qpair->use_shadow_reg = IS_SHADOW_REG_CAPABLE(ha) ? 1 : 0;
 	/* init qpair to this cpu. Will adjust at run time. */
 	ha->base_qpair->msix = &ha->msix_entries[QLA_MSIX_RSP_Q];
 	INIT_LIST_HEAD(&ha->base_qpair->hints_list);
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 66bb4825339f..1d6cc24c0640 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2288,7 +2288,8 @@ static int qlt_check_reserve_free_req(struct qla_qpair *qpair,
 	struct req_que *req = qpair->req;
 
 	if (req->cnt < (req_cnt + 2)) {
-		cnt = (uint16_t)RD_REG_DWORD(req->req_q_out);
+		cnt = (uint16_t)(qpair->use_shadow_reg ? *req->out_ptr :
+		    RD_REG_DWORD_RELAXED(req->req_q_out));
 
 		if  (req->ring_index < cnt)
 			req->cnt = cnt - req->ring_index;
-- 
2.12.0
