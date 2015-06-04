From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 05/10] qla2xxx: Specify the [noderef] attribute once
Date: Thu, 4 Jun 2015 15:55:04 -0700
Message-ID: <5570D748.4040504@sandisk.com>
References: <5570D656.9050704@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0072.outbound.protection.outlook.com ([65.55.169.72]:61568
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932316AbbFDWzP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Jun 2015 18:55:15 -0400
In-Reply-To: <5570D656.9050704@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@odin.com>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

This patch avoids that sparse complains about duplicate [noderef]
attributes.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Acked-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c  | 2 +-
 drivers/scsi/qla2xxx/qla_init.c | 2 +-
 drivers/scsi/qla2xxx/qla_iocb.c | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 3a786e4..1a1a221 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -627,7 +627,7 @@ qla25xx_copy_mq(struct qla_hw_data *ha, void *ptr, uint32_t **last_chain)
 	uint32_t cnt, que_idx;
 	uint8_t que_cnt;
 	struct qla2xxx_mq_chain *mq = ptr;
-	device_reg_t __iomem *reg;
+	device_reg_t *reg;
 
 	if (!ha->mqenable || IS_QLA83XX(ha) || IS_QLA27XX(ha))
 		return ptr;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 98f89a5..33cb3f6 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2085,7 +2085,7 @@ void
 qla24xx_config_rings(struct scsi_qla_host *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
-	device_reg_t __iomem *reg = ISP_QUE_REG(ha, 0);
+	device_reg_t *reg = ISP_QUE_REG(ha, 0);
 	struct device_reg_2xxx __iomem *ioreg = &ha->iobase->isp;
 	struct qla_msix_entry *msix;
 	struct init_cb_24xx *icb;
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 3ac0e41..25f31d9 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -451,7 +451,7 @@ void
 qla2x00_start_iocbs(struct scsi_qla_host *vha, struct req_que *req)
 {
 	struct qla_hw_data *ha = vha->hw;
-	device_reg_t __iomem *reg = ISP_QUE_REG(ha, req->id);
+	device_reg_t *reg = ISP_QUE_REG(ha, req->id);
 
 	if (IS_P3P_TYPE(ha)) {
 		qla82xx_start_iocbs(vha);
@@ -1795,7 +1795,7 @@ qla2x00_alloc_iocbs(scsi_qla_host_t *vha, srb_t *sp)
 {
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req = ha->req_q_map[0];
-	device_reg_t __iomem *reg = ISP_QUE_REG(ha, req->id);
+	device_reg_t *reg = ISP_QUE_REG(ha, req->id);
 	uint32_t index, handle;
 	request_t *pkt;
 	uint16_t cnt, req_cnt;
-- 
2.1.4

