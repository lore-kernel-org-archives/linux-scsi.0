From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 17/22] qla2xxx: Use scnprintf() instead of snprintf() in the sysfs handlers.
Date: Wed, 30 Oct 2013 03:38:24 -0400
Message-ID: <1383118709-5569-18-git-send-email-saurav.kashyap@qlogic.com>
References: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:13651 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752515Ab3J3IJw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Oct 2013 04:09:52 -0400
In-Reply-To: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Sawan Chandak <sawan.chandak@qlogic.com>

Signed-off-by: Sawan Chandak <sawan.chandak@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |  104 +++++++++++++++++++-------------------
 1 files changed, 52 insertions(+), 52 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index b8c15ed..570c7fc 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -890,7 +890,7 @@ static ssize_t
 qla2x00_drvr_version_show(struct device *dev,
 			  struct device_attribute *attr, char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%s\n", qla2x00_version_str);
+	return scnprintf(buf, PAGE_SIZE, "%s\n", qla2x00_version_str);
 }
 
 static ssize_t
@@ -901,7 +901,7 @@ qla2x00_fw_version_show(struct device *dev,
 	struct qla_hw_data *ha = vha->hw;
 	char fw_str[128];
 
-	return snprintf(buf, PAGE_SIZE, "%s\n",
+	return scnprintf(buf, PAGE_SIZE, "%s\n",
 	    ha->isp_ops->fw_version_str(vha, fw_str));
 }
 
@@ -914,7 +914,7 @@ qla2x00_serial_num_show(struct device *dev, struct device_attribute *attr,
 	uint32_t sn;
 
 	if (IS_QLAFX00(vha->hw)) {
-		return snprintf(buf, PAGE_SIZE, "%s\n",
+		return scnprintf(buf, PAGE_SIZE, "%s\n",
 		    vha->hw->mr.serial_num);
 	} else if (IS_FWI2_CAPABLE(ha)) {
 		qla2xxx_get_vpd_field(vha, "SN", buf, PAGE_SIZE - 1);
@@ -922,7 +922,7 @@ qla2x00_serial_num_show(struct device *dev, struct device_attribute *attr,
 	}
 
 	sn = ((ha->serial0 & 0x1f) << 16) | (ha->serial2 << 8) | ha->serial1;
-	return snprintf(buf, PAGE_SIZE, "%c%05d\n", 'A' + sn / 100000,
+	return scnprintf(buf, PAGE_SIZE, "%c%05d\n", 'A' + sn / 100000,
 	    sn % 100000);
 }
 
@@ -931,7 +931,7 @@ qla2x00_isp_name_show(struct device *dev, struct device_attribute *attr,
 		      char *buf)
 {
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
-	return snprintf(buf, PAGE_SIZE, "ISP%04X\n", vha->hw->pdev->device);
+	return scnprintf(buf, PAGE_SIZE, "ISP%04X\n", vha->hw->pdev->device);
 }
 
 static ssize_t
@@ -942,10 +942,10 @@ qla2x00_isp_id_show(struct device *dev, struct device_attribute *attr,
 	struct qla_hw_data *ha = vha->hw;
 
 	if (IS_QLAFX00(vha->hw))
-		return snprintf(buf, PAGE_SIZE, "%s\n",
+		return scnprintf(buf, PAGE_SIZE, "%s\n",
 		    vha->hw->mr.hw_version);
 
-	return snprintf(buf, PAGE_SIZE, "%04x %04x %04x %04x\n",
+	return scnprintf(buf, PAGE_SIZE, "%04x %04x %04x %04x\n",
 	    ha->product_id[0], ha->product_id[1], ha->product_id[2],
 	    ha->product_id[3]);
 }
@@ -956,7 +956,7 @@ qla2x00_model_name_show(struct device *dev, struct device_attribute *attr,
 {
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 
-	return snprintf(buf, PAGE_SIZE, "%s\n", vha->hw->model_number);
+	return scnprintf(buf, PAGE_SIZE, "%s\n", vha->hw->model_number);
 }
 
 static ssize_t
@@ -964,7 +964,7 @@ qla2x00_model_desc_show(struct device *dev, struct device_attribute *attr,
 			char *buf)
 {
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
-	return snprintf(buf, PAGE_SIZE, "%s\n",
+	return scnprintf(buf, PAGE_SIZE, "%s\n",
 	    vha->hw->model_desc ? vha->hw->model_desc : "");
 }
 
@@ -975,7 +975,7 @@ qla2x00_pci_info_show(struct device *dev, struct device_attribute *attr,
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 	char pci_info[30];
 
-	return snprintf(buf, PAGE_SIZE, "%s\n",
+	return scnprintf(buf, PAGE_SIZE, "%s\n",
 	    vha->hw->isp_ops->pci_info_str(vha, pci_info));
 }
 
@@ -990,29 +990,29 @@ qla2x00_link_state_show(struct device *dev, struct device_attribute *attr,
 	if (atomic_read(&vha->loop_state) == LOOP_DOWN ||
 	    atomic_read(&vha->loop_state) == LOOP_DEAD ||
 	    vha->device_flags & DFLG_NO_CABLE)
-		len = snprintf(buf, PAGE_SIZE, "Link Down\n");
+		len = scnprintf(buf, PAGE_SIZE, "Link Down\n");
 	else if (atomic_read(&vha->loop_state) != LOOP_READY ||
 	    qla2x00_reset_active(vha))
-		len = snprintf(buf, PAGE_SIZE, "Unknown Link State\n");
+		len = scnprintf(buf, PAGE_SIZE, "Unknown Link State\n");
 	else {
-		len = snprintf(buf, PAGE_SIZE, "Link Up - ");
+		len = scnprintf(buf, PAGE_SIZE, "Link Up - ");
 
 		switch (ha->current_topology) {
 		case ISP_CFG_NL:
-			len += snprintf(buf + len, PAGE_SIZE-len, "Loop\n");
+			len += scnprintf(buf + len, PAGE_SIZE-len, "Loop\n");
 			break;
 		case ISP_CFG_FL:
-			len += snprintf(buf + len, PAGE_SIZE-len, "FL_Port\n");
+			len += scnprintf(buf + len, PAGE_SIZE-len, "FL_Port\n");
 			break;
 		case ISP_CFG_N:
-			len += snprintf(buf + len, PAGE_SIZE-len,
+			len += scnprintf(buf + len, PAGE_SIZE-len,
 			    "N_Port to N_Port\n");
 			break;
 		case ISP_CFG_F:
-			len += snprintf(buf + len, PAGE_SIZE-len, "F_Port\n");
+			len += scnprintf(buf + len, PAGE_SIZE-len, "F_Port\n");
 			break;
 		default:
-			len += snprintf(buf + len, PAGE_SIZE-len, "Loop\n");
+			len += scnprintf(buf + len, PAGE_SIZE-len, "Loop\n");
 			break;
 		}
 	}
@@ -1028,10 +1028,10 @@ qla2x00_zio_show(struct device *dev, struct device_attribute *attr,
 
 	switch (vha->hw->zio_mode) {
 	case QLA_ZIO_MODE_6:
-		len += snprintf(buf + len, PAGE_SIZE-len, "Mode 6\n");
+		len += scnprintf(buf + len, PAGE_SIZE-len, "Mode 6\n");
 		break;
 	case QLA_ZIO_DISABLED:
-		len += snprintf(buf + len, PAGE_SIZE-len, "Disabled\n");
+		len += scnprintf(buf + len, PAGE_SIZE-len, "Disabled\n");
 		break;
 	}
 	return len;
@@ -1071,7 +1071,7 @@ qla2x00_zio_timer_show(struct device *dev, struct device_attribute *attr,
 {
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 
-	return snprintf(buf, PAGE_SIZE, "%d us\n", vha->hw->zio_timer * 100);
+	return scnprintf(buf, PAGE_SIZE, "%d us\n", vha->hw->zio_timer * 100);
 }
 
 static ssize_t
@@ -1101,9 +1101,9 @@ qla2x00_beacon_show(struct device *dev, struct device_attribute *attr,
 	int len = 0;
 
 	if (vha->hw->beacon_blink_led)
-		len += snprintf(buf + len, PAGE_SIZE-len, "Enabled\n");
+		len += scnprintf(buf + len, PAGE_SIZE-len, "Enabled\n");
 	else
-		len += snprintf(buf + len, PAGE_SIZE-len, "Disabled\n");
+		len += scnprintf(buf + len, PAGE_SIZE-len, "Disabled\n");
 	return len;
 }
 
@@ -1145,7 +1145,7 @@ qla2x00_optrom_bios_version_show(struct device *dev,
 {
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 	struct qla_hw_data *ha = vha->hw;
-	return snprintf(buf, PAGE_SIZE, "%d.%02d\n", ha->bios_revision[1],
+	return scnprintf(buf, PAGE_SIZE, "%d.%02d\n", ha->bios_revision[1],
 	    ha->bios_revision[0]);
 }
 
@@ -1155,7 +1155,7 @@ qla2x00_optrom_efi_version_show(struct device *dev,
 {
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 	struct qla_hw_data *ha = vha->hw;
-	return snprintf(buf, PAGE_SIZE, "%d.%02d\n", ha->efi_revision[1],
+	return scnprintf(buf, PAGE_SIZE, "%d.%02d\n", ha->efi_revision[1],
 	    ha->efi_revision[0]);
 }
 
@@ -1165,7 +1165,7 @@ qla2x00_optrom_fcode_version_show(struct device *dev,
 {
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 	struct qla_hw_data *ha = vha->hw;
-	return snprintf(buf, PAGE_SIZE, "%d.%02d\n", ha->fcode_revision[1],
+	return scnprintf(buf, PAGE_SIZE, "%d.%02d\n", ha->fcode_revision[1],
 	    ha->fcode_revision[0]);
 }
 
@@ -1175,7 +1175,7 @@ qla2x00_optrom_fw_version_show(struct device *dev,
 {
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 	struct qla_hw_data *ha = vha->hw;
-	return snprintf(buf, PAGE_SIZE, "%d.%02d.%02d %d\n",
+	return scnprintf(buf, PAGE_SIZE, "%d.%02d.%02d %d\n",
 	    ha->fw_revision[0], ha->fw_revision[1], ha->fw_revision[2],
 	    ha->fw_revision[3]);
 }
@@ -1188,9 +1188,9 @@ qla2x00_optrom_gold_fw_version_show(struct device *dev,
 	struct qla_hw_data *ha = vha->hw;
 
 	if (!IS_QLA81XX(ha) && !IS_QLA83XX(ha))
-		return snprintf(buf, PAGE_SIZE, "\n");
+		return scnprintf(buf, PAGE_SIZE, "\n");
 
-	return snprintf(buf, PAGE_SIZE, "%d.%02d.%02d (%d)\n",
+	return scnprintf(buf, PAGE_SIZE, "%d.%02d.%02d (%d)\n",
 	    ha->gold_fw_version[0], ha->gold_fw_version[1],
 	    ha->gold_fw_version[2], ha->gold_fw_version[3]);
 }
@@ -1200,7 +1200,7 @@ qla2x00_total_isp_aborts_show(struct device *dev,
 			      struct device_attribute *attr, char *buf)
 {
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
-	return snprintf(buf, PAGE_SIZE, "%d\n",
+	return scnprintf(buf, PAGE_SIZE, "%d\n",
 	    vha->qla_stats.total_isp_aborts);
 }
 
@@ -1214,16 +1214,16 @@ qla24xx_84xx_fw_version_show(struct device *dev,
 	struct qla_hw_data *ha = vha->hw;
 
 	if (!IS_QLA84XX(ha))
-		return snprintf(buf, PAGE_SIZE, "\n");
+		return scnprintf(buf, PAGE_SIZE, "\n");
 
 	if (ha->cs84xx->op_fw_version == 0)
 		rval = qla84xx_verify_chip(vha, status);
 
 	if ((rval == QLA_SUCCESS) && (status[0] == 0))
-		return snprintf(buf, PAGE_SIZE, "%u\n",
+		return scnprintf(buf, PAGE_SIZE, "%u\n",
 			(uint32_t)ha->cs84xx->op_fw_version);
 
-	return snprintf(buf, PAGE_SIZE, "\n");
+	return scnprintf(buf, PAGE_SIZE, "\n");
 }
 
 static ssize_t
@@ -1234,9 +1234,9 @@ qla2x00_mpi_version_show(struct device *dev, struct device_attribute *attr,
 	struct qla_hw_data *ha = vha->hw;
 
 	if (!IS_QLA81XX(ha) && !IS_QLA8031(ha) && !IS_QLA8044(ha))
-		return snprintf(buf, PAGE_SIZE, "\n");
+		return scnprintf(buf, PAGE_SIZE, "\n");
 
-	return snprintf(buf, PAGE_SIZE, "%d.%02d.%02d (%x)\n",
+	return scnprintf(buf, PAGE_SIZE, "%d.%02d.%02d (%x)\n",
 	    ha->mpi_version[0], ha->mpi_version[1], ha->mpi_version[2],
 	    ha->mpi_capabilities);
 }
@@ -1249,9 +1249,9 @@ qla2x00_phy_version_show(struct device *dev, struct device_attribute *attr,
 	struct qla_hw_data *ha = vha->hw;
 
 	if (!IS_QLA81XX(ha) && !IS_QLA8031(ha))
-		return snprintf(buf, PAGE_SIZE, "\n");
+		return scnprintf(buf, PAGE_SIZE, "\n");
 
-	return snprintf(buf, PAGE_SIZE, "%d.%02d.%02d\n",
+	return scnprintf(buf, PAGE_SIZE, "%d.%02d.%02d\n",
 	    ha->phy_version[0], ha->phy_version[1], ha->phy_version[2]);
 }
 
@@ -1262,7 +1262,7 @@ qla2x00_flash_block_size_show(struct device *dev,
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 	struct qla_hw_data *ha = vha->hw;
 
-	return snprintf(buf, PAGE_SIZE, "0x%x\n", ha->fdt_block_size);
+	return scnprintf(buf, PAGE_SIZE, "0x%x\n", ha->fdt_block_size);
 }
 
 static ssize_t
@@ -1272,9 +1272,9 @@ qla2x00_vlan_id_show(struct device *dev, struct device_attribute *attr,
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 
 	if (!IS_CNA_CAPABLE(vha->hw))
-		return snprintf(buf, PAGE_SIZE, "\n");
+		return scnprintf(buf, PAGE_SIZE, "\n");
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", vha->fcoe_vlan_id);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", vha->fcoe_vlan_id);
 }
 
 static ssize_t
@@ -1284,9 +1284,9 @@ qla2x00_vn_port_mac_address_show(struct device *dev,
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 
 	if (!IS_CNA_CAPABLE(vha->hw))
-		return snprintf(buf, PAGE_SIZE, "\n");
+		return scnprintf(buf, PAGE_SIZE, "\n");
 
-	return snprintf(buf, PAGE_SIZE, "%pMR\n", vha->fcoe_vn_port_mac);
+	return scnprintf(buf, PAGE_SIZE, "%pMR\n", vha->fcoe_vn_port_mac);
 }
 
 static ssize_t
@@ -1295,7 +1295,7 @@ qla2x00_fabric_param_show(struct device *dev, struct device_attribute *attr,
 {
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", vha->hw->switch_cap);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", vha->hw->switch_cap);
 }
 
 static ssize_t
@@ -1316,10 +1316,10 @@ qla2x00_thermal_temp_show(struct device *dev,
 	}
 
 	if (qla2x00_get_thermal_temp(vha, &temp) == QLA_SUCCESS)
-		return snprintf(buf, PAGE_SIZE, "%d\n", temp);
+		return scnprintf(buf, PAGE_SIZE, "%d\n", temp);
 
 done:
-	return snprintf(buf, PAGE_SIZE, "\n");
+	return scnprintf(buf, PAGE_SIZE, "\n");
 }
 
 static ssize_t
@@ -1333,7 +1333,7 @@ qla2x00_fw_state_show(struct device *dev, struct device_attribute *attr,
 
 	if (IS_QLAFX00(vha->hw)) {
 		pstate = qlafx00_fw_state_show(dev, attr, buf);
-		return snprintf(buf, PAGE_SIZE, "0x%x\n", pstate);
+		return scnprintf(buf, PAGE_SIZE, "0x%x\n", pstate);
 	}
 
 	if (qla2x00_reset_active(vha))
@@ -1344,7 +1344,7 @@ qla2x00_fw_state_show(struct device *dev, struct device_attribute *attr,
 	if (rval != QLA_SUCCESS)
 		memset(state, -1, sizeof(state));
 
-	return snprintf(buf, PAGE_SIZE, "0x%x 0x%x 0x%x 0x%x 0x%x\n", state[0],
+	return scnprintf(buf, PAGE_SIZE, "0x%x 0x%x 0x%x 0x%x 0x%x\n", state[0],
 	    state[1], state[2], state[3], state[4]);
 }
 
@@ -1355,9 +1355,9 @@ qla2x00_diag_requests_show(struct device *dev,
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 
 	if (!IS_BIDI_CAPABLE(vha->hw))
-		return snprintf(buf, PAGE_SIZE, "\n");
+		return scnprintf(buf, PAGE_SIZE, "\n");
 
-	return snprintf(buf, PAGE_SIZE, "%llu\n", vha->bidi_stats.io_count);
+	return scnprintf(buf, PAGE_SIZE, "%llu\n", vha->bidi_stats.io_count);
 }
 
 static ssize_t
@@ -1367,9 +1367,9 @@ qla2x00_diag_megabytes_show(struct device *dev,
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 
 	if (!IS_BIDI_CAPABLE(vha->hw))
-		return snprintf(buf, PAGE_SIZE, "\n");
+		return scnprintf(buf, PAGE_SIZE, "\n");
 
-	return snprintf(buf, PAGE_SIZE, "%llu\n",
+	return scnprintf(buf, PAGE_SIZE, "%llu\n",
 	    vha->bidi_stats.transfer_bytes >> 20);
 }
 
@@ -1388,7 +1388,7 @@ qla2x00_fw_dump_size_show(struct device *dev, struct device_attribute *attr,
 	else
 		size = ha->fw_dump_len;
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", size);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", size);
 }
 
 static DEVICE_ATTR(driver_version, S_IRUGO, qla2x00_drvr_version_show, NULL);
-- 
1.7.7

