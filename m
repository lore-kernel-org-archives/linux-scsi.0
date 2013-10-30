From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 15/22] qla2xxx: Add changes to obtain ISPFX00 adapters product information in accordance with firmware update.
Date: Wed, 30 Oct 2013 03:38:22 -0400
Message-ID: <1383118709-5569-16-git-send-email-saurav.kashyap@qlogic.com>
References: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:58658 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752371Ab3J3IJw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Oct 2013 04:09:52 -0400
In-Reply-To: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Armen Baloyan <armen.baloyan@qlogic.com>

Signed-off-by: Armen Baloyan <armen.baloyan@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    4 ----
 drivers/scsi/qla2xxx/qla_dbg.c  |    1 +
 drivers/scsi/qla2xxx/qla_mr.c   |    4 ++--
 drivers/scsi/qla2xxx/qla_mr.h   |    5 +++--
 drivers/scsi/qla2xxx/qla_os.c   |    8 ++------
 5 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 2a14df8..b8c15ed 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -956,10 +956,6 @@ qla2x00_model_name_show(struct device *dev, struct device_attribute *attr,
 {
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 
-	if (IS_QLAFX00(vha->hw))
-		return snprintf(buf, PAGE_SIZE, "%s\n",
-		    vha->hw->mr.product_name);
-
 	return snprintf(buf, PAGE_SIZE, "%s\n", vha->hw->model_number);
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 9cd767c..f6103f5 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -12,6 +12,7 @@
  * |             Level            |   Last Value Used  |     Holes	|
  * ----------------------------------------------------------------------
  * | Module Init and Probe        |       0x015b       | 0x4b,0xba,0xfa |
+ * |                              |                    | 0x0x015a	|
  * | Mailbox commands             |       0x1187       | 0x111a-0x111b  |
  * |                              |                    | 0x1155-0x1158  |
  * |                              |                    | 0x1018-0x1019  |
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index b396c3b..e38965e 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -1969,8 +1969,8 @@ qlafx00_fx_disc(scsi_qla_host_t *vha, fc_port_t *fcport, uint16_t fx_type)
 	if (fx_type == FXDISC_GET_CONFIG_INFO) {
 		struct config_info_data *pinfo =
 		    (struct config_info_data *) fdisc->u.fxiocb.rsp_addr;
-		memcpy(&vha->hw->mr.product_name, pinfo->product_name,
-		    sizeof(vha->hw->mr.product_name));
+		strcpy(vha->hw->model_number, pinfo->model_num);
+		strcpy(vha->hw->model_desc, pinfo->model_description);
 		memcpy(&vha->hw->mr.symbolic_name, pinfo->symbolic_name,
 		    sizeof(vha->hw->mr.symbolic_name));
 		memcpy(&vha->hw->mr.serial_num, pinfo->serial_num,
diff --git a/drivers/scsi/qla2xxx/qla_mr.h b/drivers/scsi/qla2xxx/qla_mr.h
index c8b8acd..1416e5e 100644
--- a/drivers/scsi/qla2xxx/qla_mr.h
+++ b/drivers/scsi/qla2xxx/qla_mr.h
@@ -304,7 +304,9 @@ struct register_host_info {
 #define QLAFX00_TGT_NODE_LIST_SIZE (sizeof(uint32_t) * 32)
 
 struct config_info_data {
-	uint8_t		product_name[256];
+	uint8_t		model_num[16];
+	uint8_t		model_description[80];
+	uint8_t		reserved0[160];
 	uint8_t		symbolic_name[64];
 	uint8_t		serial_num[32];
 	uint8_t		hw_version[16];
@@ -491,7 +493,6 @@ struct qla_mt_iocb_rsp_fx00 {
 #define FX00_DEF_RATOV	10
 
 struct mr_data_fx00 {
-	uint8_t	product_name[256];
 	uint8_t	symbolic_name[64];
 	uint8_t	serial_num[32];
 	uint8_t	hw_version[16];
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index ae447d9..edd2a52 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2840,12 +2840,8 @@ skip_dpc:
 
 	qla2x00_dfs_setup(base_vha);
 
-	if (IS_QLAFX00(ha))
-		ql_log(ql_log_info, base_vha, 0x015a,
-		    "QLogic %s.\n", ha->mr.product_name);
-	else
-		ql_log(ql_log_info, base_vha, 0x00fb,
-		    "QLogic %s - %s.\n", ha->model_number, ha->model_desc);
+	ql_log(ql_log_info, base_vha, 0x00fb,
+	    "QLogic %s - %s.\n", ha->model_number, ha->model_desc);
 	ql_log(ql_log_info, base_vha, 0x00fc,
 	    "ISP%04X: %s @ %s hdma%c host#=%ld fw=%s.\n",
 	    pdev->device, ha->isp_ops->pci_info_str(base_vha, pci_info),
-- 
1.7.7

