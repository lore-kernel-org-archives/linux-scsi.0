From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 17/42] qla2xxx: Implement beacon support for ISP83xx.
Date: Wed, 22 Aug 2012 14:21:11 -0400
Message-ID: <1345659696-3670-18-git-send-email-chad.dupuis@qlogic.com>
References: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:53253 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S964986Ab2HVSiR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 14:38:17 -0400
In-Reply-To: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_sup.c |   41 ++++++++++++++++++++++++++++++++++-----
 1 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 41ed7af..32fdc2a 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -1662,6 +1662,23 @@ qla24xx_beacon_blink(struct scsi_qla_host *vha)
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 
+static uint32_t
+qla83xx_select_led_port(struct qla_hw_data *ha)
+{
+	uint32_t led_select_value = 0;
+
+	if (!IS_QLA83XX(ha))
+		goto out;
+
+	if (ha->flags.port0)
+		led_select_value = QLA83XX_LED_PORT0;
+	else
+		led_select_value = QLA83XX_LED_PORT1;
+
+out:
+	return led_select_value;
+}
+
 void
 qla83xx_beacon_blink(struct scsi_qla_host *vha)
 {
@@ -1669,22 +1686,34 @@ qla83xx_beacon_blink(struct scsi_qla_host *vha)
 	struct qla_hw_data *ha = vha->hw;
 	uint16_t led_cfg[6];
 	uint16_t orig_led_cfg[6];
+	uint32_t led_10_value, led_43_value;
 
 	if (!IS_QLA83XX(ha) && !IS_QLA81XX(ha))
 		return;
 
-	if (IS_QLA2031(ha) && ha->beacon_blink_led) {
-		if (ha->flags.port0)
-			led_select_value = QLA83XX_LED_PORT0;
-		else
-			led_select_value = QLA83XX_LED_PORT1;
+	if (!ha->beacon_blink_led)
+		return;
+
+	if (IS_QLA2031(ha)) {
+		led_select_value = qla83xx_select_led_port(ha);
 
 		qla83xx_wr_reg(vha, led_select_value, 0x40002000);
 		qla83xx_wr_reg(vha, led_select_value + 4, 0x40002000);
 		msleep(1000);
 		qla83xx_wr_reg(vha, led_select_value, 0x40004000);
 		qla83xx_wr_reg(vha, led_select_value + 4, 0x40004000);
-	} else if ((IS_QLA8031(ha) || IS_QLA81XX(ha)) && ha->beacon_blink_led) {
+	} else if (IS_QLA8031(ha)) {
+		led_select_value = qla83xx_select_led_port(ha);
+
+		qla83xx_rd_reg(vha, led_select_value, &led_10_value);
+		qla83xx_rd_reg(vha, led_select_value + 0x10, &led_43_value);
+		qla83xx_wr_reg(vha, led_select_value, 0x01f44000);
+		msleep(500);
+		qla83xx_wr_reg(vha, led_select_value, 0x400001f4);
+		msleep(1000);
+		qla83xx_wr_reg(vha, led_select_value, led_10_value);
+		qla83xx_wr_reg(vha, led_select_value + 0x10, led_43_value);
+	} else if (IS_QLA81XX(ha)) {
 		int rval;
 
 		/* Save Current */
-- 
1.7.7

