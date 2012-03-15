From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: [PATCH 5/6] qla2xxx: Rewrite ISP_QUE_REG as inline function
Date: Thu, 15 Mar 2012 15:07:38 -0400
Message-ID: <20120315190737.GF7685@logfs.org>
References: <20120315190512.GB7685@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120315190512.GB7685@logfs.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: target-devel@vger.kernel.org, linux-driver@qlogic.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

And remove two write-only __iomem variables.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/scsi/qla2xxx/qla_def.h |   14 +++++++++-----
 drivers/scsi/qla2xxx/qla_mid.c |    2 --
 drivers/scsi/qla2xxx/qla_nx.c  |    2 --
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index b2f3cf0..64ae345 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2357,11 +2357,7 @@ struct qla_statistics {
 #define QLA_QUE_PAGE 0X1000
 #define QLA_MQ_SIZE 32
 #define QLA_MAX_QUEUES 256
-#define ISP_QUE_REG(ha, id) \
-	((ha->mqenable) ? \
-	((void *)(ha->mqiobase) +\
-	(QLA_QUE_PAGE * id)) :\
-	((void *)(ha->iobase)))
+
 #define QLA_REQ_QUE_ID(tag) \
 	((tag < QLA_MAX_QUEUES && tag > 0) ? tag : 0)
 #define QLA_DEFAULT_QUE_QOS 5
@@ -2883,6 +2879,14 @@ struct qla_hw_data {
 	uint8_t tgt_node_name[WWN_SIZE];
 };
 
+static inline device_reg_t __iomem *ISP_QUE_REG(struct qla_hw_data *ha, u16 id)
+{
+	if (ha->mqenable)
+		return (void *)ha->mqiobase + (QLA_QUE_PAGE * id);
+	else
+		return (void *)ha->iobase;
+}
+
 /*
  * Qlogic scsi host structure
  */
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index dd7810e..21bc2fc 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -633,7 +633,6 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
 	struct req_que *req = NULL;
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 	uint16_t que_id = 0;
-	device_reg_t __iomem *reg;
 	uint32_t cnt;
 
 	req = kzalloc(sizeof(struct req_que), GFP_KERNEL);
@@ -697,7 +696,6 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
 	req->ring_index = 0;
 	req->cnt = req->length;
 	req->id = que_id;
-	reg = ISP_QUE_REG(ha, que_id);
 	req->max_q_depth = ha->req_q_map[0]->max_q_depth;
 	mutex_unlock(&ha->vport_lock);
 	ql_dbg(ql_dbg_multiq, base_vha, 0xc004,
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index d6f34c6..f40bd22 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -3273,7 +3273,6 @@ qla82xx_start_iocbs(srb_t *sp)
 {
 	struct qla_hw_data *ha = sp->fcport->vha->hw;
 	struct req_que *req = ha->req_q_map[0];
-	struct device_reg_82xx __iomem *reg;
 	uint32_t dbval;
 
 	/* Adjust ring index. */
@@ -3284,7 +3283,6 @@ qla82xx_start_iocbs(srb_t *sp)
 	} else
 		req->ring_ptr++;
 
-	reg = &ha->iobase->isp82;
 	dbval = 0x04 | (ha->portnum << 5);
 
 	dbval = dbval | (req->id << 8) | (req->ring_index << 16);
-- 
1.7.9
