From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 11/16] qla2xxx: Add host attributes.
Date: Fri, 26 Aug 2005 19:09:40 -0700 (PDT)
Message-ID: <20050827020940.27275.5266.sendpatchset@plap.qlogic.com>
References: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:15720 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751619AbVH0CJl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 22:09:41 -0400
In-Reply-To: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Add host attributes.

Export additional host information vi the shost_attrs member in
the scsi_host template.  Attributes include: driver version,
firmware version, ISP serial number, ISP type, ISP product ID,
HBA model name, HBA model description, PCI interconnect
information, and HBA port state.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/qla_attr.c |  132 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_gbl.h  |    2 +
 drivers/scsi/qla2xxx/qla_os.c   |    2 +
 3 files changed, 136 insertions(+), 0 deletions(-)

b274c510177f2013b5e00604e226878656b4dc77
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -211,6 +211,138 @@ qla2x00_free_sysfs_attr(scsi_qla_host_t 
 	sysfs_remove_bin_file(&host->shost_gendev.kobj, &sysfs_nvram_attr);
 }
 
+/* Scsi_Host attributes. */
+
+static ssize_t
+qla2x00_drvr_version_show(struct class_device *cdev, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%s\n", qla2x00_version_str);
+}
+
+static ssize_t
+qla2x00_fw_version_show(struct class_device *cdev, char *buf)
+{
+	scsi_qla_host_t *ha = to_qla_host(class_to_shost(cdev));
+	char fw_str[30];
+
+	return snprintf(buf, PAGE_SIZE, "%s\n",
+	    ha->isp_ops.fw_version_str(ha, fw_str));
+}
+
+static ssize_t
+qla2x00_serial_num_show(struct class_device *cdev, char *buf)
+{
+	scsi_qla_host_t *ha = to_qla_host(class_to_shost(cdev));
+	uint32_t sn;
+
+	sn = ((ha->serial0 & 0x1f) << 16) | (ha->serial2 << 8) | ha->serial1;
+	return snprintf(buf, PAGE_SIZE, "%c%05d\n", 'A' + sn / 100000,
+	    sn % 100000);
+}
+
+static ssize_t
+qla2x00_isp_name_show(struct class_device *cdev, char *buf)
+{
+	scsi_qla_host_t *ha = to_qla_host(class_to_shost(cdev));
+	return snprintf(buf, PAGE_SIZE, "%s\n", ha->brd_info->isp_name);
+}
+
+static ssize_t
+qla2x00_isp_id_show(struct class_device *cdev, char *buf)
+{
+	scsi_qla_host_t *ha = to_qla_host(class_to_shost(cdev));
+	return snprintf(buf, PAGE_SIZE, "%04x %04x %04x %04x\n",
+	    ha->product_id[0], ha->product_id[1], ha->product_id[2],
+	    ha->product_id[3]);
+}
+
+static ssize_t
+qla2x00_model_name_show(struct class_device *cdev, char *buf)
+{
+	scsi_qla_host_t *ha = to_qla_host(class_to_shost(cdev));
+	return snprintf(buf, PAGE_SIZE, "%s\n", ha->model_number);
+}
+
+static ssize_t
+qla2x00_model_desc_show(struct class_device *cdev, char *buf)
+{
+	scsi_qla_host_t *ha = to_qla_host(class_to_shost(cdev));
+	return snprintf(buf, PAGE_SIZE, "%s\n",
+	    ha->model_desc ? ha->model_desc: "");
+}
+
+static ssize_t
+qla2x00_pci_info_show(struct class_device *cdev, char *buf)
+{
+	scsi_qla_host_t *ha = to_qla_host(class_to_shost(cdev));
+	char pci_info[30];
+
+	return snprintf(buf, PAGE_SIZE, "%s\n",
+	    ha->isp_ops.pci_info_str(ha, pci_info));
+}
+
+static ssize_t
+qla2x00_state_show(struct class_device *cdev, char *buf)
+{
+	scsi_qla_host_t *ha = to_qla_host(class_to_shost(cdev));
+	int len = 0;
+
+	if (atomic_read(&ha->loop_state) == LOOP_DOWN ||
+	    atomic_read(&ha->loop_state) == LOOP_DEAD)
+		len = snprintf(buf, PAGE_SIZE, "Link Down\n");
+	else if (atomic_read(&ha->loop_state) != LOOP_READY ||
+	    test_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags) ||
+	    test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags))
+		len = snprintf(buf, PAGE_SIZE, "Unknown Link State\n");
+	else {
+		len = snprintf(buf, PAGE_SIZE, "Link Up - ");
+
+		switch (ha->current_topology) {
+		case ISP_CFG_NL:
+			len += snprintf(buf + len, PAGE_SIZE-len, "Loop\n");
+			break;
+		case ISP_CFG_FL:
+			len += snprintf(buf + len, PAGE_SIZE-len, "FL_Port\n");
+			break;
+		case ISP_CFG_N:
+			len += snprintf(buf + len, PAGE_SIZE-len,
+			    "N_Port to N_Port\n");
+			break;
+		case ISP_CFG_F:
+			len += snprintf(buf + len, PAGE_SIZE-len, "F_Port\n");
+			break;
+		default:
+			len += snprintf(buf + len, PAGE_SIZE-len, "Loop\n");
+			break;
+		}
+	}
+	return len;
+}
+
+static CLASS_DEVICE_ATTR(driver_version, S_IRUGO, qla2x00_drvr_version_show,
+	NULL);
+static CLASS_DEVICE_ATTR(fw_version, S_IRUGO, qla2x00_fw_version_show, NULL);
+static CLASS_DEVICE_ATTR(serial_num, S_IRUGO, qla2x00_serial_num_show, NULL);
+static CLASS_DEVICE_ATTR(isp_name, S_IRUGO, qla2x00_isp_name_show, NULL);
+static CLASS_DEVICE_ATTR(isp_id, S_IRUGO, qla2x00_isp_id_show, NULL);
+static CLASS_DEVICE_ATTR(model_name, S_IRUGO, qla2x00_model_name_show, NULL);
+static CLASS_DEVICE_ATTR(model_desc, S_IRUGO, qla2x00_model_desc_show, NULL);
+static CLASS_DEVICE_ATTR(pci_info, S_IRUGO, qla2x00_pci_info_show, NULL);
+static CLASS_DEVICE_ATTR(state, S_IRUGO, qla2x00_state_show, NULL);
+
+struct class_device_attribute *qla2x00_host_attrs[] = {
+	&class_device_attr_driver_version,
+	&class_device_attr_fw_version,
+	&class_device_attr_serial_num,
+	&class_device_attr_isp_name,
+	&class_device_attr_isp_id,
+	&class_device_attr_model_name,
+	&class_device_attr_model_desc,
+	&class_device_attr_pci_info,
+	&class_device_attr_state,
+	NULL,
+};
+
 /* Host attributes. */
 
 static void
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -290,6 +290,8 @@ extern void qla2x00_cancel_io_descriptor
 /*
  * Global Function Prototypes in qla_attr.c source file.
  */
+struct class_device_attribute;
+extern struct class_device_attribute *qla2x00_host_attrs[];
 struct fc_function_template;
 extern struct fc_function_template qla2xxx_transport_functions;
 extern void qla2x00_alloc_sysfs_attr(scsi_qla_host_t *);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -140,6 +140,7 @@ static struct scsi_host_template qla2x00
 	 * which equates to 0x800000 sectors.
 	 */
 	.max_sectors		= 0xFFFF,
+	.shost_attrs		= qla2x00_host_attrs,
 };
 
 static struct scsi_host_template qla24xx_driver_template = {
@@ -164,6 +165,7 @@ static struct scsi_host_template qla24xx
 	.sg_tablesize		= SG_ALL,
 
 	.max_sectors		= 0xFFFF,
+	.shost_attrs		= qla2x00_host_attrs,
 };
 
 static struct scsi_transport_template *qla2xxx_transport_template = NULL;

-- 
Andrew Vasquez
