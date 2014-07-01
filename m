From: Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] [SCSI] qla2xxx: Remove duplicate __iomem annotation
Date: Wed,  2 Jul 2014 00:31:54 +0200
Message-ID: <1404253914-24400-1-git-send-email-emilgoode@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
List-Id: linux-scsi@vger.kernel.org

The device_reg_t type now has __iomem annotation.

Sparse is warning about this:
drivers/scsi/qla2xxx/qla_init.c:2040:22: warning: duplicate [noderef]
drivers/scsi/qla2xxx/qla_iocb.c:477:22: warning: duplicate [noderef]
drivers/scsi/qla2xxx/qla_iocb.c:1866:22: warning: duplicate [noderef]
drivers/scsi/qla2xxx/qla_dbg.c:632:22: warning: duplicate [noderef]
drivers/scsi/qla2xxx/qla_target.c:1435:22: warning: duplicate [noderef]

Introduced by commit:
f73cb695d3eccd171f03ed194e72d67732b17487
("[SCSI] qla2xxx: Add support for ISP2071.")

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c    |    2 +-
 drivers/scsi/qla2xxx/qla_init.c   |    2 +-
 drivers/scsi/qla2xxx/qla_iocb.c   |    4 ++--
 drivers/scsi/qla2xxx/qla_target.c |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index c72ee97b..47998b9 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -629,7 +629,7 @@ qla25xx_copy_mq(struct qla_hw_data *ha, void *ptr, uint32_t **last_chain)
 	uint32_t cnt, que_idx;
 	uint8_t que_cnt;
 	struct qla2xxx_mq_chain *mq = ptr;
-	device_reg_t __iomem *reg;
+	device_reg_t *reg;
 
 	if (!ha->mqenable || IS_QLA83XX(ha) || IS_QLA27XX(ha))
 		return ptr;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e218441..8d4e368 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2037,7 +2037,7 @@ void
 qla24xx_config_rings(struct scsi_qla_host *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
-	device_reg_t __iomem *reg = ISP_QUE_REG(ha, 0);
+	device_reg_t *reg = ISP_QUE_REG(ha, 0);
 	struct device_reg_2xxx __iomem *ioreg = &ha->iobase->isp;
 	struct qla_msix_entry *msix;
 	struct init_cb_24xx *icb;
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 150529d..39ebf34 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -474,7 +474,7 @@ void
 qla2x00_start_iocbs(struct scsi_qla_host *vha, struct req_que *req)
 {
 	struct qla_hw_data *ha = vha->hw;
-	device_reg_t __iomem *reg = ISP_QUE_REG(ha, req->id);
+	device_reg_t *reg = ISP_QUE_REG(ha, req->id);
 
 	if (IS_P3P_TYPE(ha)) {
 		qla82xx_start_iocbs(vha);
@@ -1863,7 +1863,7 @@ qla2x00_alloc_iocbs(scsi_qla_host_t *vha, srb_t *sp)
 {
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req = ha->req_q_map[0];
-	device_reg_t __iomem *reg = ISP_QUE_REG(ha, req->id);
+	device_reg_t *reg = ISP_QUE_REG(ha, req->id);
 	uint32_t index, handle;
 	request_t *pkt;
 	uint16_t cnt, req_cnt;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index e632e14..6fc0702 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1432,7 +1432,7 @@ static int qlt_check_reserve_free_req(struct scsi_qla_host *vha,
 	uint32_t req_cnt)
 {
 	struct qla_hw_data *ha = vha->hw;
-	device_reg_t __iomem *reg = ha->iobase;
+	device_reg_t *reg = ha->iobase;
 	uint32_t cnt;
 
 	if (vha->req->cnt < (req_cnt + 2)) {
-- 
1.7.10.4
