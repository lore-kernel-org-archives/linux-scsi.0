From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 10/29] qla2xxx: Reconfigure thermal temperature.
Date: Tue, 27 Aug 2013 01:37:36 -0400
Message-ID: <1377581875-8574-11-git-send-email-saurav.kashyap@qlogic.com>
References: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:51791 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752874Ab3H0GGq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Aug 2013 02:06:46 -0400
Received: from pps.filterd (m0000643.ppops.net [127.0.0.1])
	by mx0b-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id r7R63vVs012060
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:45 -0700
Received: from avcashub1.qlogic.com (avcashub2.qlogic.com [198.70.193.116])
	by mx0b-0016ce01.pphosted.com with ESMTP id 1e5gq13pa4-13
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:45 -0700
In-Reply-To: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

For supported ISPS, Read asic temperature by calling the
GET PARAMS (type C) mailbox command.

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    6 ----
 drivers/scsi/qla2xxx/qla_dbg.c  |    4 ++-
 drivers/scsi/qla2xxx/qla_def.h  |    3 --
 drivers/scsi/qla2xxx/qla_gbl.h  |    2 +
 drivers/scsi/qla2xxx/qla_init.c |    1 -
 drivers/scsi/qla2xxx/qla_mbx.c  |   61 ++++++++++++++++++++------------------
 drivers/scsi/qla2xxx/qla_mr.c   |    1 -
 drivers/scsi/qla2xxx/qla_nx.c   |    8 +++++
 drivers/scsi/qla2xxx/qla_nx2.c  |    8 +++++
 9 files changed, 53 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 8e8b50e..93f3783 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1300,12 +1300,6 @@ qla2x00_thermal_temp_show(struct device *dev,
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 	uint16_t temp = 0;
 
-	if (!vha->hw->thermal_support) {
-		ql_log(ql_log_warn, vha, 0x70db,
-		    "Thermal not supported by this card.\n");
-		goto done;
-	}
-
 	if (qla2x00_reset_active(vha)) {
 		ql_log(ql_log_warn, vha, 0x70dc, "ISP reset active.\n");
 		goto done;
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index ecaafe4..aa31f7a 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -14,6 +14,8 @@
  * | Module Init and Probe        |       0x0151       | 0x4b,0xba,0xfa |
  * | Mailbox commands             |       0x1181       | 0x111a-0x111b  |
  * |                              |                    | 0x1155-0x1158  |
+ * |                              |                    | 0x1018-0x1019  |
+ * |                              |                    | 0x10ca		|
  * | Device Discovery             |       0x2095       | 0x2020-0x2022, |
  * |                              |                    | 0x2011-0x2012, |
  * |                              |                    | 0x2016         |
@@ -37,7 +39,7 @@
  * |                              |                    | 0x70a5,0x70a6, |
  * |                              |                    | 0x70a8,0x70ab, |
  * |                              |                    | 0x70ad-0x70ae, |
- * |                              |                    | 0x70d1-0x70da, |
+ * |                              |                    | 0x70d1-0x70db, |
  * |                              |                    | 0x7047,0x703b	|
  * | Task Management              |       0x803d       | 0x8025-0x8026  |
  * |                              |                    | 0x800b,0x8039  |
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index f393d24..a494e2e 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3304,9 +3304,6 @@ struct qla_hw_data {
 	struct mr_data_fx00 mr;
 
 	struct qlt_hw_data tgt;
-	uint16_t	thermal_support;
-#define THERMAL_SUPPORT_I2C BIT_0
-#define THERMAL_SUPPORT_ISP BIT_1
 };
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index dc14ac2..d03b15d 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -685,6 +685,8 @@ extern int qla81xx_get_led_config(scsi_qla_host_t *, uint16_t *);
 extern int qla82xx_mbx_beacon_ctl(scsi_qla_host_t *, int);
 extern char *qdev_state(uint32_t);
 extern void qla82xx_clear_pending_mbx(scsi_qla_host_t *);
+extern int qla82xx_read_temperature(scsi_qla_host_t *);
+extern int qla8044_read_temperature(scsi_qla_host_t *);
 
 /* BSG related functions */
 extern int qla24xx_bsg_request(struct fc_bsg_job *);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 71cbdeb..91df7a5 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -524,7 +524,6 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 	vha->flags.reset_active = 0;
 	ha->flags.pci_channel_io_perm_failure = 0;
 	ha->flags.eeh_busy = 0;
-	ha->thermal_support = THERMAL_SUPPORT_I2C|THERMAL_SUPPORT_ISP;
 	atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
 	atomic_set(&vha->loop_state, LOOP_DOWN);
 	vha->device_flags = DFLG_NO_CABLE;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index ce76110..1261884 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4608,40 +4608,43 @@ qla2x00_get_thermal_temp(scsi_qla_host_t *vha, uint16_t *temp)
 	struct qla_hw_data *ha = vha->hw;
 	uint8_t byte;
 
-	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x10ca,
-	    "Entered %s.\n", __func__);
-
-	if (ha->thermal_support & THERMAL_SUPPORT_I2C) {
-		rval = qla2x00_read_sfp(vha, 0, &byte,
-		    0x98, 0x1, 1, BIT_13|BIT_12|BIT_0);
-		*temp = byte;
-		if (rval == QLA_SUCCESS)
-			goto done;
-
-		ql_log(ql_log_warn, vha, 0x10c9,
-		    "Thermal not supported through I2C bus, trying alternate "
-		    "method (ISP access).\n");
-		ha->thermal_support &= ~THERMAL_SUPPORT_I2C;
+	if (!IS_FWI2_CAPABLE(ha) || IS_QLA24XX_TYPE(ha) || IS_QLA81XX(ha)) {
+		ql_dbg(ql_dbg_mbx, vha, 0x1150,
+		    "Thermal not supported by this card.\n");
+		return rval;
 	}
 
-	if (ha->thermal_support & THERMAL_SUPPORT_ISP) {
-		rval = qla2x00_read_asic_temperature(vha, temp);
-		if (rval == QLA_SUCCESS)
-			goto done;
-
-		ql_log(ql_log_warn, vha, 0x1019,
-		    "Thermal not supported through ISP.\n");
-		ha->thermal_support &= ~THERMAL_SUPPORT_ISP;
+	if (IS_QLA25XX(ha)) {
+		if (ha->pdev->subsystem_vendor == PCI_VENDOR_ID_QLOGIC &&
+		    ha->pdev->subsystem_device == 0x0175) {
+			rval = qla2x00_read_sfp(vha, 0, &byte,
+			    0x98, 0x1, 1, BIT_13|BIT_0);
+			*temp = byte;
+			return rval;
+		}
+		if (ha->pdev->subsystem_vendor == PCI_VENDOR_ID_HP &&
+		    ha->pdev->subsystem_device == 0x338e) {
+			rval = qla2x00_read_sfp(vha, 0, &byte,
+			    0x98, 0x1, 1, BIT_15|BIT_14|BIT_0);
+			*temp = byte;
+			return rval;
+		}
+		ql_dbg(ql_dbg_mbx, vha, 0x10c9,
+		    "Thermal not supported by this card.\n");
+		return rval;
 	}
 
-	ql_log(ql_log_warn, vha, 0x1150,
-	    "Thermal not supported by this card "
-	    "(ignoring further requests).\n");
-	return  rval;
+	if (IS_QLA82XX(ha)) {
+		*temp = qla82xx_read_temperature(vha);
+		rval = QLA_SUCCESS;
+		return rval;
+	} else if (IS_QLA8044(ha)) {
+		*temp = qla8044_read_temperature(vha);
+		rval = QLA_SUCCESS;
+		return rval;
+	}
 
-done:
-	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1018,
-	    "Done %s.\n", __func__);
+	rval = qla2x00_read_asic_temperature(vha, temp);
 	return rval;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index be60a77..e087a49 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -2062,7 +2062,6 @@ qlafx00_initialize_adapter(scsi_qla_host_t *vha)
 	vha->flags.reset_active = 0;
 	ha->flags.pci_channel_io_perm_failure = 0;
 	ha->flags.eeh_busy = 0;
-	ha->thermal_support = 0;
 	atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
 	atomic_set(&vha->loop_state, LOOP_DOWN);
 	vha->device_flags = DFLG_NO_CABLE;
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index b3e48f5..11ce53d 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -3327,6 +3327,14 @@ static int qla82xx_check_temp(scsi_qla_host_t *vha)
 	return 0;
 }
 
+int qla82xx_read_temperature(scsi_qla_host_t *vha)
+{
+	uint32_t temp;
+
+	temp = qla82xx_rd_32(vha->hw, CRB_TEMP_STATE);
+	return qla82xx_get_temp_val(temp);
+}
+
 void qla82xx_clear_pending_mbx(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index 005cd6b..712a9bb 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -1945,6 +1945,14 @@ qla8044_check_temp(struct scsi_qla_host *vha)
 	return 0;
 }
 
+int qla8044_read_temperature(scsi_qla_host_t *vha)
+{
+	uint32_t temp;
+
+	temp = qla8044_rd_direct(vha, QLA8044_CRB_TEMP_STATE_INDEX);
+	return qla82xx_get_temp_val(temp);
+}
+
 /**
  * qla8044_check_fw_alive  - Check firmware health
  * @ha: Pointer to host adapter structure.
-- 
1.7.7

