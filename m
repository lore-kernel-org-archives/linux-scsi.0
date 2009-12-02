From: giridhar.malavali@qlogic.com
Subject: [PATCH 2/3] Fix to accommodate a hardware bug in multiqueue mode that does not work properly when acknowledgement of MSIX Interrupts is disabled.
Date: Wed,  2 Dec 2009 10:36:55 -0800
Message-ID: <1259779016-1762-3-git-send-email-giridhar.malavali@qlogic.com>
References: <1259779016-1762-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:45739 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1754375AbZLBSm7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Dec 2009 13:42:59 -0500
In-Reply-To: <1259779016-1762-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Anirban Chakraborty <anirban.chakraborty@qlogic.com>

From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>

Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |    2 ++
 drivers/scsi/qla2xxx/qla_init.c |   12 +++++++++++-
 drivers/scsi/qla2xxx/qla_isr.c  |   11 ++++++++++-
 drivers/scsi/qla2xxx/qla_mid.c  |    4 ++++
 4 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 7a81e98..384afda 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2262,6 +2262,7 @@ struct qla_hw_data {
 		uint32_t	port0			:1;
 		uint32_t	running_gold_fw		:1;
 		uint32_t	cpu_affinity_enabled	:1;
+		uint32_t	disable_msix_handshake	:1;
 	} flags;
 
 	/* This spinlock is used to protect "io transactions", you must
@@ -2384,6 +2385,7 @@ struct qla_hw_data {
 #define IS_QLA81XX(ha)		(IS_QLA8001(ha))
 #define IS_QLA2XXX_MIDTYPE(ha)	(IS_QLA24XX(ha) || IS_QLA84XX(ha) || \
 				IS_QLA25XX(ha) || IS_QLA81XX(ha))
+#define IS_MSIX_NACK_CAPABLE(ha) (IS_QLA81XX(ha))
 #define IS_NOPOLLING_TYPE(ha)	((IS_QLA25XX(ha) || IS_QLA81XX(ha)) && \
 				(ha)->flags.msix_enabled)
 #define IS_FAC_REQUIRED(ha)	(IS_QLA81XX(ha))
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index b74924b..73a7935 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1442,7 +1442,17 @@ qla24xx_config_rings(struct scsi_qla_host *vha)
 			icb->firmware_options_2 |=
 				__constant_cpu_to_le32(BIT_18);
 
-		icb->firmware_options_2 &= __constant_cpu_to_le32(~BIT_22);
+		/* Use Disable MSIX Handshake mode for capable adapters */
+		if (IS_MSIX_NACK_CAPABLE(ha)) {
+			icb->firmware_options_2 &=
+				__constant_cpu_to_le32(~BIT_22);
+			ha->flags.disable_msix_handshake = 1;
+			qla_printk(KERN_INFO, ha,
+				"MSIX Handshake Disable Mode turned on\n");
+		} else {
+			icb->firmware_options_2 |=
+				__constant_cpu_to_le32(BIT_22);
+		}
 		icb->firmware_options_2 |= __constant_cpu_to_le32(BIT_23);
 
 		WRT_REG_DWORD(&reg->isp25mq.req_q_in, 0);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index bc07d83..1692a88 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1928,7 +1928,7 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
 
 	vha = qla25xx_get_host(rsp);
 	qla24xx_process_response_queue(vha, rsp);
-	if (!ha->mqenable) {
+	if (!ha->flags.disable_msix_handshake) {
 		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
 		RD_REG_DWORD_RELAXED(&reg->hccr);
 	}
@@ -1942,6 +1942,7 @@ qla25xx_msix_rsp_q(int irq, void *dev_id)
 {
 	struct qla_hw_data *ha;
 	struct rsp_que *rsp;
+	struct device_reg_24xx __iomem *reg;
 
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
@@ -1951,6 +1952,14 @@ qla25xx_msix_rsp_q(int irq, void *dev_id)
 	}
 	ha = rsp->hw;
 
+	/* Clear the interrupt, if enabled, for this response queue */
+	if (rsp->options & ~BIT_6) {
+		reg = &ha->iobase->isp24;
+		spin_lock_irq(&ha->hardware_lock);
+		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
+		RD_REG_DWORD_RELAXED(&reg->hccr);
+		spin_unlock_irq(&ha->hardware_lock);
+	}
 	queue_work_on((int) (rsp->id - 1), ha->wq, &rsp->q_work);
 
 	return IRQ_HANDLED;
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index a47d343..2a4c7f4 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -696,6 +696,10 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 	/* Use alternate PCI devfn */
 	if (LSB(rsp->rid))
 		options |= BIT_5;
+	/* Enable MSIX handshake mode on for uncapable adapters */
+	if (!IS_MSIX_NACK_CAPABLE(ha))
+		options |= BIT_6;
+
 	rsp->options = options;
 	rsp->id = que_id;
 	reg = ISP_QUE_REG(ha, que_id);
-- 
1.6.2.rc1.30.gd43c

