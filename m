From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH  09/14] qla2xxx: Add support to show MPI and PEP FW version for ISP27xx.
Date: Tue, 4 Aug 2015 13:37:59 -0400
Message-ID: <1438709884-623-10-git-send-email-himanshu.madhani@qlogic.com>
References: <1438709884-623-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:10903 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752775AbbHDSXq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2015 14:23:46 -0400
In-Reply-To: <1438709884-623-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Sawan Chandak <sawan.chandak@qlogic.com>

Signed-off-by: Sawan Chandak <sawan.chandak@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   19 ++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_def.h  |    1 +
 drivers/scsi/qla2xxx/qla_mbx.c  |   13 ++++++++++++-
 3 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 437254e..b6bf948 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1348,7 +1348,8 @@ qla2x00_mpi_version_show(struct device *dev, struct device_attribute *attr,
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 	struct qla_hw_data *ha = vha->hw;
 
-	if (!IS_QLA81XX(ha) && !IS_QLA8031(ha) && !IS_QLA8044(ha))
+	if (!IS_QLA81XX(ha) && !IS_QLA8031(ha) && !IS_QLA8044(ha) &&
+	    !IS_QLA27XX(ha))
 		return scnprintf(buf, PAGE_SIZE, "\n");
 
 	return scnprintf(buf, PAGE_SIZE, "%d.%02d.%02d (%x)\n",
@@ -1537,6 +1538,20 @@ qla2x00_allow_cna_fw_dump_store(struct device *dev,
 	return strlen(buf);
 }
 
+static ssize_t
+qla2x00_pep_version_show(struct device *dev, struct device_attribute *attr,
+	char *buf)
+{
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+	struct qla_hw_data *ha = vha->hw;
+
+	if (!IS_QLA27XX(ha))
+		return scnprintf(buf, PAGE_SIZE, "\n");
+
+	return scnprintf(buf, PAGE_SIZE, "%d.%02d.%02d\n",
+	    ha->pep_version[0], ha->pep_version[1], ha->pep_version[2]);
+}
+
 static DEVICE_ATTR(driver_version, S_IRUGO, qla2x00_drvr_version_show, NULL);
 static DEVICE_ATTR(fw_version, S_IRUGO, qla2x00_fw_version_show, NULL);
 static DEVICE_ATTR(serial_num, S_IRUGO, qla2x00_serial_num_show, NULL);
@@ -1581,6 +1596,7 @@ static DEVICE_ATTR(fw_dump_size, S_IRUGO, qla2x00_fw_dump_size_show, NULL);
 static DEVICE_ATTR(allow_cna_fw_dump, S_IRUGO | S_IWUSR,
 		   qla2x00_allow_cna_fw_dump_show,
 		   qla2x00_allow_cna_fw_dump_store);
+static DEVICE_ATTR(pep_version, S_IRUGO, qla2x00_pep_version_show, NULL);
 
 struct device_attribute *qla2x00_host_attrs[] = {
 	&dev_attr_driver_version,
@@ -1614,6 +1630,7 @@ struct device_attribute *qla2x00_host_attrs[] = {
 	&dev_attr_diag_megabytes,
 	&dev_attr_fw_dump_size,
 	&dev_attr_allow_cna_fw_dump,
+	&dev_attr_pep_version,
 	NULL,
 };
 
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 06d61a4..8becec9 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3289,6 +3289,7 @@ struct qla_hw_data {
 	uint8_t		mpi_version[3];
 	uint32_t	mpi_capabilities;
 	uint8_t		phy_version[3];
+	uint8_t		pep_version[3];
 
 	/* Firmware dump template */
 	void		*fw_dump_template;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 5ac6577..9da519b 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -555,7 +555,9 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha)
 	if (IS_FWI2_CAPABLE(ha))
 		mcp->in_mb |= MBX_17|MBX_16|MBX_15;
 	if (IS_QLA27XX(ha))
-		mcp->in_mb |= MBX_21|MBX_20|MBX_19|MBX_18;
+		mcp->in_mb |= MBX_23 | MBX_22 | MBX_21 | MBX_20 | MBX_19 |
+		    MBX_18 | MBX_14 | MBX_13 | MBX_11 | MBX_10 | MBX_9 | MBX_8;
+
 	mcp->flags = 0;
 	mcp->tov = MBX_TOV_SECONDS;
 	rval = qla2x00_mailbox_command(vha, mcp);
@@ -571,6 +573,7 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha)
 		ha->fw_memory_size = 0x1FFFF;		/* Defaults to 128KB. */
 	else
 		ha->fw_memory_size = (mcp->mb[5] << 16) | mcp->mb[4];
+
 	if (IS_QLA81XX(vha->hw) || IS_QLA8031(vha->hw) || IS_QLA8044(ha)) {
 		ha->mpi_version[0] = mcp->mb[10] & 0xff;
 		ha->mpi_version[1] = mcp->mb[11] >> 8;
@@ -580,6 +583,7 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha)
 		ha->phy_version[1] = mcp->mb[9] >> 8;
 		ha->phy_version[2] = mcp->mb[9] & 0xff;
 	}
+
 	if (IS_FWI2_CAPABLE(ha)) {
 		ha->fw_attributes_h = mcp->mb[15];
 		ha->fw_attributes_ext[0] = mcp->mb[16];
@@ -591,7 +595,14 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha)
 		    "%s: Ext_FwAttributes Upper: 0x%x, Lower: 0x%x.\n",
 		    __func__, mcp->mb[17], mcp->mb[16]);
 	}
+
 	if (IS_QLA27XX(ha)) {
+		ha->mpi_version[0] = mcp->mb[10] & 0xff;
+		ha->mpi_version[1] = mcp->mb[11] >> 8;
+		ha->mpi_version[2] = mcp->mb[11] & 0xff;
+		ha->pep_version[0] = mcp->mb[13] & 0xff;
+		ha->pep_version[1] = mcp->mb[14] >> 8;
+		ha->pep_version[2] = mcp->mb[14] & 0xff;
 		ha->fw_shared_ram_start = (mcp->mb[19] << 16) | mcp->mb[18];
 		ha->fw_shared_ram_end = (mcp->mb[21] << 16) | mcp->mb[20];
 	}
-- 
1.7.7

