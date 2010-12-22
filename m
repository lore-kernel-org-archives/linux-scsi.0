From: madhu.iyengar@qlogic.com
Subject: [PATCH 08/14] qla2xxx: Add sysfs node for displaying board temperature.
Date: Tue, 21 Dec 2010 16:00:21 -0800
Message-ID: <1292976027-12034-9-git-send-email-madhu.iyengar@qlogic.com>
References: <1292976027-12034-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36166 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753919Ab0LVADY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Dec 2010 19:03:24 -0500
In-Reply-To: <1292976027-12034-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Add sysfs node for displaying board thermal/temperature.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   27 ++++++++++++++++
 drivers/scsi/qla2xxx/qla_def.h  |    3 +-
 drivers/scsi/qla2xxx/qla_gbl.h  |    2 +
 drivers/scsi/qla2xxx/qla_init.c |    1 +
 drivers/scsi/qla2xxx/qla_mbx.c  |   65 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 97 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index bc8194f..44578b5 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1309,6 +1309,31 @@ qla2x00_fabric_param_show(struct device *dev, struct device_attribute *attr,
 }
 
 static ssize_t
+qla2x00_thermal_temp_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+	int rval = QLA_FUNCTION_FAILED;
+	uint16_t temp, frac;
+
+	if (!vha->hw->flags.thermal_supported)
+		return snprintf(buf, PAGE_SIZE, "\n");
+
+	temp = frac = 0;
+	if (test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
+	    test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags))
+		DEBUG2_3_11(printk(KERN_WARNING
+		    "%s(%ld): isp reset in progress.\n",
+		    __func__, vha->host_no));
+	else if (!vha->hw->flags.eeh_busy)
+		rval = qla2x00_get_thermal_temp(vha, &temp, &frac);
+	if (rval != QLA_SUCCESS)
+		temp = frac = 0;
+
+	return snprintf(buf, PAGE_SIZE, "%d.%02d\n", temp, frac);
+}
+
+static ssize_t
 qla2x00_fw_state_show(struct device *dev, struct device_attribute *attr,
     char *buf)
 {
@@ -1366,6 +1391,7 @@ static DEVICE_ATTR(vn_port_mac_address, S_IRUGO,
 		   qla2x00_vn_port_mac_address_show, NULL);
 static DEVICE_ATTR(fabric_param, S_IRUGO, qla2x00_fabric_param_show, NULL);
 static DEVICE_ATTR(fw_state, S_IRUGO, qla2x00_fw_state_show, NULL);
+static DEVICE_ATTR(thermal_temp, S_IRUGO, qla2x00_thermal_temp_show, NULL);
 
 struct device_attribute *qla2x00_host_attrs[] = {
 	&dev_attr_driver_version,
@@ -1394,6 +1420,7 @@ struct device_attribute *qla2x00_host_attrs[] = {
 	&dev_attr_fabric_param,
 	&dev_attr_fw_state,
 	&dev_attr_optrom_gold_fw_version,
+	&dev_attr_thermal_temp,
 	NULL,
 };
 
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 6168628..ccfc8e7 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2426,7 +2426,8 @@ struct qla_hw_data {
 		uint32_t	fcp_prio_enabled	:1;
 		uint32_t	fw_hung	:1;
 		uint32_t        quiesce_owner:1;
-		/* 29 bits */
+		uint32_t	thermal_supported:1;
+		/* 26 bits */
 	} flags;
 
 	/* This spinlock is used to protect "io transactions", you must
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index c228d24..39c4bdd 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -53,6 +53,8 @@ extern void qla2x00_update_fcport(scsi_qla_host_t *, fc_port_t *);
 extern void qla2x00_alloc_fw_dump(scsi_qla_host_t *);
 extern void qla2x00_try_to_stop_firmware(scsi_qla_host_t *);
 
+extern int qla2x00_get_thermal_temp(scsi_qla_host_t *, uint16_t *, uint16_t *);
+
 extern void qla84xx_put_chip(struct scsi_qla_host *);
 
 extern int qla2x00_async_login(struct scsi_qla_host *, fc_port_t *,
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index c8ca25a..d0a0dc9 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -498,6 +498,7 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 	vha->flags.reset_active = 0;
 	ha->flags.pci_channel_io_perm_failure = 0;
 	ha->flags.eeh_busy = 0;
+	ha->flags.thermal_supported = 1;
 	atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
 	atomic_set(&vha->loop_state, LOOP_DOWN);
 	vha->device_flags = DFLG_NO_CABLE;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 04d6cfc..e473e9f 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4160,6 +4160,71 @@ qla24xx_set_fcp_prio(scsi_qla_host_t *vha, uint16_t loop_id, uint16_t priority,
 }
 
 int
+qla2x00_get_thermal_temp(scsi_qla_host_t *vha, uint16_t *temp, uint16_t *frac)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+	struct qla_hw_data *ha = vha->hw;
+
+	DEBUG11(printk(KERN_INFO "%s(%ld): entered.\n", __func__, ha->host_no));
+
+	/* High bits. */
+	mcp->mb[0] = MBC_READ_SFP;
+	mcp->mb[1] = 0x98;
+	mcp->mb[2] = 0;
+	mcp->mb[3] = 0;
+	mcp->mb[6] = 0;
+	mcp->mb[7] = 0;
+	mcp->mb[8] = 1;
+	mcp->mb[9] = 0x01;
+	mcp->mb[10] = BIT_13|BIT_0;
+	mcp->out_mb = MBX_10|MBX_9|MBX_8|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->in_mb = MBX_1|MBX_0;
+	mcp->tov = MBX_TOV_SECONDS;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(vha, mcp);
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3_11(printk(KERN_WARNING
+		    "%s(%ld): failed=%x (%x).\n", __func__,
+		    vha->host_no, rval, mcp->mb[0]));
+		ha->flags.thermal_supported = 0;
+		goto fail;
+	}
+	*temp = mcp->mb[1] & 0xFF;
+
+	/* Low bits. */
+	mcp->mb[0] = MBC_READ_SFP;
+	mcp->mb[1] = 0x98;
+	mcp->mb[2] = 0;
+	mcp->mb[3] = 0;
+	mcp->mb[6] = 0;
+	mcp->mb[7] = 0;
+	mcp->mb[8] = 1;
+	mcp->mb[9] = 0x10;
+	mcp->mb[10] = BIT_13|BIT_0;
+	mcp->out_mb = MBX_10|MBX_9|MBX_8|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->in_mb = MBX_1|MBX_0;
+	mcp->tov = MBX_TOV_SECONDS;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(vha, mcp);
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3_11(printk(KERN_WARNING
+		    "%s(%ld): failed=%x (%x).\n", __func__,
+		    vha->host_no, rval, mcp->mb[0]));
+		ha->flags.thermal_supported = 0;
+		goto fail;
+	}
+	*frac = ((mcp->mb[1] & 0xFF) >> 6) * 25;
+
+	if (rval == QLA_SUCCESS)
+		DEBUG11(printk(KERN_INFO
+		    "%s(%ld): done.\n", __func__, ha->host_no));
+fail:
+	return rval;
+}
+
+int
 qla82xx_mbx_intr_enable(scsi_qla_host_t *vha)
 {
 	int rval;
-- 
1.6.0.2

