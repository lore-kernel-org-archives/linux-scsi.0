From: giridhar.malavali@qlogic.com
Subject: [PATCH 05/17] qla2xxx: Check for golden firmware and show version if available
Date: Fri, 23 Jul 2010 15:28:26 +0500
Message-ID: <1279880918-62876-6-git-send-email-giridhar.malavali@qlogic.com>
References: <1279880918-62876-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:47940 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755135Ab0GWJ7M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jul 2010 05:59:12 -0400
In-Reply-To: <1279880918-62876-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, madhu.iyengar@qlogic.com, linux-scsi@vger.kernel.org, Madhuranath Iyengar <madhuranath.iyengar@qlogic.com>

From: Madhuranath Iyengar <madhuranath.iyengar@qlogic.com>


Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   18 ++++++++++++++++++
 drivers/scsi/qla2xxx/qla_def.h  |    2 ++
 drivers/scsi/qla2xxx/qla_sup.c  |   22 ++++++++++++++++++++++
 3 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index fd6f7b1..7ebf365 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1187,6 +1187,21 @@ qla2x00_optrom_fw_version_show(struct device *dev,
 }
 
 static ssize_t
+qla2x00_optrom_gold_fw_version_show(struct device *dev,
+    struct device_attribute *attr, char *buf)
+{
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+	struct qla_hw_data *ha = vha->hw;
+
+	if (!IS_QLA81XX(ha))
+		return snprintf(buf, PAGE_SIZE, "\n");
+
+	return snprintf(buf, PAGE_SIZE, "%d.%02d.%02d (%d)\n",
+	    ha->gold_fw_version[0], ha->gold_fw_version[1],
+	    ha->gold_fw_version[2], ha->gold_fw_version[3]);
+}
+
+static ssize_t
 qla2x00_total_isp_aborts_show(struct device *dev,
 			      struct device_attribute *attr, char *buf)
 {
@@ -1336,6 +1351,8 @@ static DEVICE_ATTR(optrom_fcode_version, S_IRUGO,
 		   qla2x00_optrom_fcode_version_show, NULL);
 static DEVICE_ATTR(optrom_fw_version, S_IRUGO, qla2x00_optrom_fw_version_show,
 		   NULL);
+static DEVICE_ATTR(optrom_gold_fw_version, S_IRUGO,
+    qla2x00_optrom_gold_fw_version_show, NULL);
 static DEVICE_ATTR(84xx_fw_version, S_IRUGO, qla24xx_84xx_fw_version_show,
 		   NULL);
 static DEVICE_ATTR(total_isp_aborts, S_IRUGO, qla2x00_total_isp_aborts_show,
@@ -1376,6 +1393,7 @@ struct device_attribute *qla2x00_host_attrs[] = {
 	&dev_attr_vn_port_mac_address,
 	&dev_attr_fabric_param,
 	&dev_attr_fw_state,
+	&dev_attr_optrom_gold_fw_version,
 	NULL,
 };
 
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 02c7480..7e11ccf 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2714,6 +2714,8 @@ struct qla_hw_data {
 	uint8_t 	fcode_revision[16];
 	uint32_t	fw_revision[4];
 
+	uint32_t	gold_fw_version[4];
+
 	/* Offsets for flash/nvram access (set to ~0 if not used). */
 	uint32_t	flash_conf_off;
 	uint32_t	flash_data_off;
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 3c5115f..df288dc 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -2759,6 +2759,28 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 		ha->fw_revision[3] = dcode[3];
 	}
 
+	/* Check for golden firmware and get version if available */
+	if (!IS_QLA81XX(ha)) {
+		/* Golden firmware is not present in non 81XX adapters */
+		return ret;
+	}
+
+	memset(ha->gold_fw_version, 0, sizeof(ha->gold_fw_version));
+	dcode = mbuf;
+	ha->isp_ops->read_optrom(vha, (uint8_t *)dcode,
+	    ha->flt_region_gold_fw << 2, 32);
+
+	if (dcode[4] == 0xFFFFFFFF && dcode[5] == 0xFFFFFFFF &&
+	    dcode[6] == 0xFFFFFFFF && dcode[7] == 0xFFFFFFFF) {
+		DEBUG2(qla_printk(KERN_INFO, ha,
+		    "%s(%ld): Unrecognized golden fw at 0x%x.\n",
+		    __func__, vha->host_no, ha->flt_region_gold_fw * 4));
+		return ret;
+	}
+
+	for (i = 4; i < 8; i++)
+		ha->gold_fw_version[i-4] = be32_to_cpu(dcode[i]);
+
 	return ret;
 }
 
-- 
1.6.0.2

