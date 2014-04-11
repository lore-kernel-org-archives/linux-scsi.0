From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 27/42] qla2xxx: Adjust adapter reset routine to the changes in firmware specification for ISPFx00.
Date: Fri, 11 Apr 2014 16:54:32 -0400
Message-ID: <1397249687-32666-28-git-send-email-saurav.kashyap@qlogic.com>
References: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:8296 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754957AbaDKVcD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2014 17:32:03 -0400
In-Reply-To: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Armen Baloyan <armen.baloyan@qlogic.com>

Signed-off-by: Armen Baloyan <armen.baloyan@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mr.c |   55 +++++++++++++++++++++++++++++++++++------
 drivers/scsi/qla2xxx/qla_mr.h |    1 +
 2 files changed, 48 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 3fdf844..abeb390 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -527,21 +527,63 @@ qlafx00_soc_cpu_reset(scsi_qla_host_t *vha)
 	struct qla_hw_data *ha = vha->hw;
 	int i, core;
 	uint32_t cnt;
+	uint32_t reg_val;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+
+	QLAFX00_SET_HBA_SOC_REG(ha, 0x80004, 0);
+	QLAFX00_SET_HBA_SOC_REG(ha, 0x82004, 0);
+
+	/* stop the XOR DMA engines */
+	QLAFX00_SET_HBA_SOC_REG(ha, 0x60920, 0x02);
+	QLAFX00_SET_HBA_SOC_REG(ha, 0x60924, 0x02);
+	QLAFX00_SET_HBA_SOC_REG(ha, 0xf0920, 0x02);
+	QLAFX00_SET_HBA_SOC_REG(ha, 0xf0924, 0x02);
+
+	/* stop the IDMA engines */
+	reg_val = QLAFX00_GET_HBA_SOC_REG(ha, 0x60840);
+	reg_val &= ~(1<<12);
+	QLAFX00_SET_HBA_SOC_REG(ha, 0x60840, reg_val);
+
+	reg_val = QLAFX00_GET_HBA_SOC_REG(ha, 0x60844);
+	reg_val &= ~(1<<12);
+	QLAFX00_SET_HBA_SOC_REG(ha, 0x60844, reg_val);
+
+	reg_val = QLAFX00_GET_HBA_SOC_REG(ha, 0x60848);
+	reg_val &= ~(1<<12);
+	QLAFX00_SET_HBA_SOC_REG(ha, 0x60848, reg_val);
+
+	reg_val = QLAFX00_GET_HBA_SOC_REG(ha, 0x6084C);
+	reg_val &= ~(1<<12);
+	QLAFX00_SET_HBA_SOC_REG(ha, 0x6084C, reg_val);
+
+	for (i = 0; i < 100000; i++) {
+		if ((QLAFX00_GET_HBA_SOC_REG(ha, 0xd0000) & 0x10000000) == 0 &&
+		    (QLAFX00_GET_HBA_SOC_REG(ha, 0x10600) & 0x1) == 0)
+			break;
+		udelay(100);
+	}
 
 	/* Set all 4 cores in reset */
 	for (i = 0; i < 4; i++) {
 		QLAFX00_SET_HBA_SOC_REG(ha,
 		    (SOC_SW_RST_CONTROL_REG_CORE0 + 8*i), (0xF01));
-	}
-
-	/* Set all 4 core Clock gating control */
-	for (i = 0; i < 4; i++) {
 		QLAFX00_SET_HBA_SOC_REG(ha,
 		    (SOC_SW_RST_CONTROL_REG_CORE0 + 4 + 8*i), (0x01010101));
 	}
 
 	/* Reset all units in Fabric */
-	QLAFX00_SET_HBA_SOC_REG(ha, SOC_FABRIC_RST_CONTROL_REG, (0x11F0101));
+	QLAFX00_SET_HBA_SOC_REG(ha, SOC_FABRIC_RST_CONTROL_REG, (0x011f0101));
+
+	/* */
+	QLAFX00_SET_HBA_SOC_REG(ha, 0x10610, 1);
+	QLAFX00_SET_HBA_SOC_REG(ha, 0x10600, 0);
+
+	/* Set all 4 core Memory Power Down Registers */
+	for (i = 0; i < 5; i++) {
+		QLAFX00_SET_HBA_SOC_REG(ha,
+		    (SOC_PWR_MANAGEMENT_PWR_DOWN_REG + 4*i), (0x0));
+	}
 
 	/* Reset all interrupt control registers */
 	for (i = 0; i < 115; i++) {
@@ -564,8 +606,6 @@ qlafx00_soc_cpu_reset(scsi_qla_host_t *vha)
 	QLAFX00_SET_HBA_SOC_REG(ha, SOC_FABRIC_CONTROL_REG, (0x2));
 	QLAFX00_SET_HBA_SOC_REG(ha, SOC_FABRIC_CONFIG_REG, (0x3));
 
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-
 	/* Kick in Fabric units */
 	QLAFX00_SET_HBA_SOC_REG(ha, SOC_FABRIC_RST_CONTROL_REG, (0x0));
 
@@ -598,7 +638,6 @@ qlafx00_soft_reset(scsi_qla_host_t *vha)
 
 	ha->isp_ops->disable_intrs(ha);
 	qlafx00_soc_cpu_reset(vha);
-	ha->isp_ops->enable_intrs(ha);
 }
 
 /**
diff --git a/drivers/scsi/qla2xxx/qla_mr.h b/drivers/scsi/qla2xxx/qla_mr.h
index 1e6941e..aeaa1b4 100644
--- a/drivers/scsi/qla2xxx/qla_mr.h
+++ b/drivers/scsi/qla2xxx/qla_mr.h
@@ -351,6 +351,7 @@ struct config_info_data {
 #define SOC_FABRIC_RST_CONTROL_REG       0x0020840
 #define SOC_FABRIC_CONTROL_REG           0x0020200
 #define SOC_FABRIC_CONFIG_REG            0x0020204
+#define SOC_PWR_MANAGEMENT_PWR_DOWN_REG  0x001820C
 
 #define SOC_INTERRUPT_SOURCE_I_CONTROL_REG     0x0020B00
 #define SOC_CORE_TIMER_REG                     0x0021850
-- 
1.7.7

