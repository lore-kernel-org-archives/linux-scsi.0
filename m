From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 18/20] qla2xxx: Export additional firmware-states for application support.
Date: Wed,  3 Jun 2009 09:55:29 -0700
Message-ID: <1244048131-56590-19-git-send-email-andrew.vasquez@qlogic.com>
References: <1244048131-56590-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:4799 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756517AbZFCQzu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2009 12:55:50 -0400
In-Reply-To: <1244048131-56590-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   18 ++++++++++++++++++
 drivers/scsi/qla2xxx/qla_init.c |    7 ++++---
 drivers/scsi/qla2xxx/qla_mbx.c  |    4 +++-
 3 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index cbdafb0..0f87962 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1233,6 +1233,22 @@ qla2x00_fabric_param_show(struct device *dev, struct device_attribute *attr,
 	return snprintf(buf, PAGE_SIZE, "%d\n", vha->hw->switch_cap);
 }
 
+static ssize_t
+qla2x00_fw_state_show(struct device *dev, struct device_attribute *attr,
+    char *buf)
+{
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+	int rval;
+	uint16_t state[5];
+
+	rval = qla2x00_get_firmware_state(vha, state);
+	if (rval != QLA_SUCCESS)
+		memset(state, -1, sizeof(state));
+
+	return snprintf(buf, PAGE_SIZE, "0x%x 0x%x 0x%x 0x%x 0x%x\n", state[0],
+	    state[1], state[2], state[3], state[4]);
+}
+
 static DEVICE_ATTR(driver_version, S_IRUGO, qla2x00_drvr_version_show, NULL);
 static DEVICE_ATTR(fw_version, S_IRUGO, qla2x00_fw_version_show, NULL);
 static DEVICE_ATTR(serial_num, S_IRUGO, qla2x00_serial_num_show, NULL);
@@ -1265,6 +1281,7 @@ static DEVICE_ATTR(vlan_id, S_IRUGO, qla2x00_vlan_id_show, NULL);
 static DEVICE_ATTR(vn_port_mac_address, S_IRUGO,
 		   qla2x00_vn_port_mac_address_show, NULL);
 static DEVICE_ATTR(fabric_param, S_IRUGO, qla2x00_fabric_param_show, NULL);
+static DEVICE_ATTR(fw_state, S_IRUGO, qla2x00_fw_state_show, NULL);
 
 struct device_attribute *qla2x00_host_attrs[] = {
 	&dev_attr_driver_version,
@@ -1290,6 +1307,7 @@ struct device_attribute *qla2x00_host_attrs[] = {
 	&dev_attr_vlan_id,
 	&dev_attr_vn_port_mac_address,
 	&dev_attr_fabric_param,
+	&dev_attr_fw_state,
 	NULL,
 };
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 46bd085..36cea22 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1304,7 +1304,7 @@ qla2x00_fw_ready(scsi_qla_host_t *vha)
 	unsigned long	wtime, mtime, cs84xx_time;
 	uint16_t	min_wait;	/* Minimum wait time if loop is down */
 	uint16_t	wait_time;	/* Wait time if loop is coming ready */
-	uint16_t	state[3];
+	uint16_t	state[5];
 	struct qla_hw_data *ha = vha->hw;
 
 	rval = QLA_SUCCESS;
@@ -1403,8 +1403,9 @@ qla2x00_fw_ready(scsi_qla_host_t *vha)
 		    vha->host_no, state[0], jiffies));
 	} while (1);
 
-	DEBUG(printk("scsi(%ld): fw_state=%x curr time=%lx.\n",
-	    vha->host_no, state[0], jiffies));
+	DEBUG(printk("scsi(%ld): fw_state=%x (%x, %x, %x, %x) curr time=%lx.\n",
+	    vha->host_no, state[0], state[1], state[2], state[3], state[4],
+	    jiffies));
 
 	if (rval) {
 		DEBUG2_3(printk("scsi(%ld): Firmware ready **** FAILED ****.\n",
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index df919c0..f215578 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1267,7 +1267,7 @@ qla2x00_get_firmware_state(scsi_qla_host_t *vha, uint16_t *states)
 
 	mcp->mb[0] = MBC_GET_FIRMWARE_STATE;
 	mcp->out_mb = MBX_0;
-	mcp->in_mb = MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->in_mb = MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(vha, mcp);
@@ -1276,6 +1276,8 @@ qla2x00_get_firmware_state(scsi_qla_host_t *vha, uint16_t *states)
 	states[0] = mcp->mb[1];
 	states[1] = mcp->mb[2];
 	states[2] = mcp->mb[3];
+	states[3] = mcp->mb[4];
+	states[4] = mcp->mb[5];
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
-- 
1.6.3.1.244.gf9275

