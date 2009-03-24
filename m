From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 09/26] qla2xxx: Update MPI/PHY version retrieval codes.
Date: Tue, 24 Mar 2009 09:08:03 -0700
Message-ID: <1237910900-30817-10-git-send-email-andrew.vasquez@qlogic.com>
References: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29880 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762300AbZCXQIc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2009 12:08:32 -0400
In-Reply-To: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Reflects layout and format of latest specification.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   20 ++++++++++++++++++--
 drivers/scsi/qla2xxx/qla_def.h  |    3 ++-
 drivers/scsi/qla2xxx/qla_gbl.h  |    4 ++--
 drivers/scsi/qla2xxx/qla_init.c |    3 ++-
 drivers/scsi/qla2xxx/qla_mbx.c  |   14 ++++++++------
 5 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 664d610..41ce1c6 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -818,9 +818,23 @@ qla2x00_mpi_version_show(struct device *dev, struct device_attribute *attr,
 	if (!IS_QLA81XX(ha))
 		return snprintf(buf, PAGE_SIZE, "\n");
 
-	return snprintf(buf, PAGE_SIZE, "%02x.%02x.%02x.%02x (%x)\n",
+	return snprintf(buf, PAGE_SIZE, "%d.%02d.%02d (%x)\n",
 	    ha->mpi_version[0], ha->mpi_version[1], ha->mpi_version[2],
-	    ha->mpi_version[3], ha->mpi_capabilities);
+	    ha->mpi_capabilities);
+}
+
+static ssize_t
+qla2x00_phy_version_show(struct device *dev, struct device_attribute *attr,
+    char *buf)
+{
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+	struct qla_hw_data *ha = vha->hw;
+
+	if (!IS_QLA81XX(ha))
+		return snprintf(buf, PAGE_SIZE, "\n");
+
+	return snprintf(buf, PAGE_SIZE, "%d.%02d.%02d\n",
+	    ha->phy_version[0], ha->phy_version[1], ha->phy_version[2]);
 }
 
 static DEVICE_ATTR(driver_version, S_IRUGO, qla2x00_drvr_version_show, NULL);
@@ -848,6 +862,7 @@ static DEVICE_ATTR(optrom_fw_version, S_IRUGO, qla2x00_optrom_fw_version_show,
 static DEVICE_ATTR(total_isp_aborts, S_IRUGO, qla2x00_total_isp_aborts_show,
 		   NULL);
 static DEVICE_ATTR(mpi_version, S_IRUGO, qla2x00_mpi_version_show, NULL);
+static DEVICE_ATTR(phy_version, S_IRUGO, qla2x00_phy_version_show, NULL);
 
 struct device_attribute *qla2x00_host_attrs[] = {
 	&dev_attr_driver_version,
@@ -868,6 +883,7 @@ struct device_attribute *qla2x00_host_attrs[] = {
 	&dev_attr_optrom_fw_version,
 	&dev_attr_total_isp_aborts,
 	&dev_attr_mpi_version,
+	&dev_attr_phy_version,
 	NULL,
 };
 
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 5e7389d..261c869 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2481,8 +2481,9 @@ struct qla_hw_data {
 	uint8_t		fw_seriallink_options[4];
 	uint16_t	fw_seriallink_options24[4];
 
-	uint8_t		mpi_version[4];
+	uint8_t		mpi_version[3];
 	uint32_t	mpi_capabilities;
+	uint8_t		phy_version[3];
 
 	/* Firmware dump information. */
 	struct qla2xxx_fw_dump *fw_dump;
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 85b689c..af36238 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -144,8 +144,8 @@ extern int
 qla2x00_execute_fw(scsi_qla_host_t *, uint32_t);
 
 extern void
-qla2x00_get_fw_version(scsi_qla_host_t *, uint16_t *,
-    uint16_t *, uint16_t *, uint16_t *, uint32_t *, uint8_t *, uint32_t *);
+qla2x00_get_fw_version(scsi_qla_host_t *, uint16_t *, uint16_t *, uint16_t *,
+    uint16_t *, uint32_t *, uint8_t *, uint32_t *, uint8_t *);
 
 extern int
 qla2x00_get_fw_options(scsi_qla_host_t *, uint16_t *);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e793387..0febfa6 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -994,7 +994,8 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
 				    &ha->fw_minor_version,
 				    &ha->fw_subminor_version,
 				    &ha->fw_attributes, &ha->fw_memory_size,
-				    ha->mpi_version, &ha->mpi_capabilities);
+				    ha->mpi_version, &ha->mpi_capabilities,
+				    ha->phy_version);
 				ha->flags.npiv_supported = 0;
 				if (IS_QLA2XXX_MIDTYPE(ha) &&
 					 (ha->fw_attributes & BIT_2)) {
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 91e133b..b380c6f 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -408,7 +408,7 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t risc_addr)
 void
 qla2x00_get_fw_version(scsi_qla_host_t *vha, uint16_t *major, uint16_t *minor,
     uint16_t *subminor, uint16_t *attributes, uint32_t *memory, uint8_t *mpi,
-    uint32_t *mpi_caps)
+    uint32_t *mpi_caps, uint8_t *phy)
 {
 	int		rval;
 	mbx_cmd_t	mc;
@@ -420,7 +420,7 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha, uint16_t *major, uint16_t *minor,
 	mcp->out_mb = MBX_0;
 	mcp->in_mb = MBX_6|MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
 	if (IS_QLA81XX(vha->hw))
-		mcp->in_mb |= MBX_13|MBX_12|MBX_11|MBX_10;
+		mcp->in_mb |= MBX_13|MBX_12|MBX_11|MBX_10|MBX_9|MBX_8;
 	mcp->flags = 0;
 	mcp->tov = MBX_TOV_SECONDS;
 	rval = qla2x00_mailbox_command(vha, mcp);
@@ -435,11 +435,13 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha, uint16_t *major, uint16_t *minor,
 	else
 		*memory = (mcp->mb[5] << 16) | mcp->mb[4];
 	if (IS_QLA81XX(vha->hw)) {
-		mpi[0] = mcp->mb[10] >> 8;
-		mpi[1] = mcp->mb[10] & 0xff;
-		mpi[2] = mcp->mb[11] >> 8;
-		mpi[3] = mcp->mb[11] & 0xff;
+		mpi[0] = mcp->mb[10] & 0xff;
+		mpi[1] = mcp->mb[11] >> 8;
+		mpi[2] = mcp->mb[11] & 0xff;
 		*mpi_caps = (mcp->mb[12] << 16) | mcp->mb[13];
+		phy[0] = mcp->mb[8] & 0xff;
+		phy[1] = mcp->mb[9] >> 8;
+		phy[2] = mcp->mb[9] & 0xff;
 	}
 
 	if (rval != QLA_SUCCESS) {
-- 
1.6.2.rc0.55.g30aa4f

