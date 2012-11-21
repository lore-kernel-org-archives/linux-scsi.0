From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 12/19] qla2xxx: Add acquiring of risc semaphore before doing ISP reset.
Date: Wed, 21 Nov 2012 02:40:37 -0500
Message-ID: <1353483644-17262-13-git-send-email-saurav.kashyap@qlogic.com>
References: <1353483644-17262-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:9710 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753514Ab2KUH6z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2012 02:58:55 -0500
In-Reply-To: <1353483644-17262-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Try to acquire the semaphore; if semaphore is hung then acquire it by force.
The ISP reset clears the semaphore, thereby implicitly releasing it.

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_fw.h   |   21 ++++++++++
 drivers/scsi/qla2xxx/qla_init.c |   79 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 100 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 59524aa..be6d61a 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1092,6 +1092,27 @@ struct device_reg_24xx {
 	uint32_t unused_6[2];		/* Gap. */
 	uint32_t iobase_sdata;
 };
+/* RISC-RISC semaphore register PCI offet */
+#define RISC_REGISTER_BASE_OFFSET	0x7010
+#define RISC_REGISTER_WINDOW_OFFET	0x6
+
+/* RISC-RISC semaphore/flag register (risc address 0x7016) */
+
+#define RISC_SEMAPHORE		0x1UL
+#define RISC_SEMAPHORE_WE	(RISC_SEMAPHORE << 16)
+#define RISC_SEMAPHORE_CLR	(RISC_SEMAPHORE_WE | 0x0UL)
+#define RISC_SEMAPHORE_SET	(RISC_SEMAPHORE_WE | RISC_SEMAPHORE)
+
+#define RISC_SEMAPHORE_FORCE		0x8000UL
+#define RISC_SEMAPHORE_FORCE_WE		(RISC_SEMAPHORE_FORCE << 16)
+#define RISC_SEMAPHORE_FORCE_CLR	(RISC_SEMAPHORE_FORCE_WE | 0x0UL)
+#define RISC_SEMAPHORE_FORCE_SET	\
+		(RISC_SEMAPHORE_FORCE_WE | RISC_SEMAPHORE_FORCE)
+
+/* RISC semaphore timeouts (ms) */
+#define TIMEOUT_SEMAPHORE		2500
+#define TIMEOUT_SEMAPHORE_FORCE		2000
+#define TIMEOUT_TOTAL_ELAPSED		4500
 
 /* Trace Control *************************************************************/
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index b7e42a8..7464a47 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1095,6 +1095,83 @@ qla24xx_reset_risc(scsi_qla_host_t *vha)
 		ha->isp_ops->enable_intrs(ha);
 }
 
+static void
+qla25xx_read_risc_sema_reg(scsi_qla_host_t *vha, uint32_t *data)
+{
+	struct device_reg_24xx __iomem *reg = &vha->hw->iobase->isp24;
+
+	WRT_REG_DWORD(&reg->iobase_addr, RISC_REGISTER_BASE_OFFSET);
+	*data = RD_REG_DWORD(&reg->iobase_window + RISC_REGISTER_WINDOW_OFFET);
+
+}
+
+static void
+qla25xx_write_risc_sema_reg(scsi_qla_host_t *vha, uint32_t data)
+{
+	struct device_reg_24xx __iomem *reg = &vha->hw->iobase->isp24;
+
+	WRT_REG_DWORD(&reg->iobase_addr, RISC_REGISTER_BASE_OFFSET);
+	WRT_REG_DWORD(&reg->iobase_window + RISC_REGISTER_WINDOW_OFFET, data);
+}
+
+static void
+qla25xx_manipulate_risc_semaphore(scsi_qla_host_t *vha)
+{
+	struct qla_hw_data *ha = vha->hw;
+	uint32_t wd32 = 0;
+	uint delta_msec = 100;
+	uint elapsed_msec = 0;
+	uint timeout_msec;
+	ulong n;
+
+	if (!IS_QLA25XX(ha) && !IS_QLA2031(ha))
+		return;
+
+attempt:
+	timeout_msec = TIMEOUT_SEMAPHORE;
+	n = timeout_msec / delta_msec;
+	while (n--) {
+		qla25xx_write_risc_sema_reg(vha, RISC_SEMAPHORE_SET);
+		qla25xx_read_risc_sema_reg(vha, &wd32);
+		if (wd32 & RISC_SEMAPHORE)
+			break;
+		msleep(delta_msec);
+		elapsed_msec += delta_msec;
+		if (elapsed_msec > TIMEOUT_TOTAL_ELAPSED)
+			goto force;
+	}
+
+	if (!(wd32 & RISC_SEMAPHORE))
+		goto force;
+
+	if (!(wd32 & RISC_SEMAPHORE_FORCE))
+		goto acquired;
+
+	qla25xx_write_risc_sema_reg(vha, RISC_SEMAPHORE_CLR);
+	timeout_msec = TIMEOUT_SEMAPHORE_FORCE;
+	n = timeout_msec / delta_msec;
+	while (n--) {
+		qla25xx_read_risc_sema_reg(vha, &wd32);
+		if (!(wd32 & RISC_SEMAPHORE_FORCE))
+			break;
+		msleep(delta_msec);
+		elapsed_msec += delta_msec;
+		if (elapsed_msec > TIMEOUT_TOTAL_ELAPSED)
+			goto force;
+	}
+
+	if (wd32 & RISC_SEMAPHORE_FORCE)
+		qla25xx_write_risc_sema_reg(vha, RISC_SEMAPHORE_FORCE_CLR);
+
+	goto attempt;
+
+force:
+	qla25xx_write_risc_sema_reg(vha, RISC_SEMAPHORE_FORCE_SET);
+
+acquired:
+	return;
+}
+
 /**
  * qla24xx_reset_chip() - Reset ISP24xx chip.
  * @ha: HA context
@@ -1113,6 +1190,8 @@ qla24xx_reset_chip(scsi_qla_host_t *vha)
 
 	ha->isp_ops->disable_intrs(ha);
 
+	qla25xx_manipulate_risc_semaphore(vha);
+
 	/* Perform RISC reset. */
 	qla24xx_reset_risc(vha);
 }
-- 
1.7.7

