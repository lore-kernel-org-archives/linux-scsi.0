From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 04/14] qla2xxx: Fix beacon blink for ISP27XX.
Date: Thu, 9 Apr 2015 14:59:58 -0400
Message-ID: <1428606008-14976-5-git-send-email-himanshu.madhani@qlogic.com>
References: <1428606008-14976-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:51688 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933354AbbDITlg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Apr 2015 15:41:36 -0400
In-Reply-To: <1428606008-14976-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Nigel Kirkland <nigel.kirkland@qlogic.com>

Signed-off-by: Nigel Kirkland <nigel.kirkland@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_sup.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index b656a05..028e8c8 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -1718,13 +1718,16 @@ qla83xx_beacon_blink(struct scsi_qla_host *vha)
 	uint16_t orig_led_cfg[6];
 	uint32_t led_10_value, led_43_value;
 
-	if (!IS_QLA83XX(ha) && !IS_QLA81XX(ha))
+	if (!IS_QLA83XX(ha) && !IS_QLA81XX(ha) && !IS_QLA27XX(ha))
 		return;
 
 	if (!ha->beacon_blink_led)
 		return;
 
-	if (IS_QLA2031(ha)) {
+	if (IS_QLA27XX(ha)) {
+		qla2x00_write_ram_word(vha, 0x1003, 0x40000230);
+		qla2x00_write_ram_word(vha, 0x1004, 0x40000230);
+	} else if (IS_QLA2031(ha)) {
 		led_select_value = qla83xx_select_led_port(ha);
 
 		qla83xx_wr_reg(vha, led_select_value, 0x40000230);
@@ -1811,7 +1814,7 @@ qla24xx_beacon_on(struct scsi_qla_host *vha)
 			return QLA_FUNCTION_FAILED;
 		}
 
-		if (IS_QLA2031(ha))
+		if (IS_QLA2031(ha) || IS_QLA27XX(ha))
 			goto skip_gpio;
 
 		spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -1848,7 +1851,7 @@ qla24xx_beacon_off(struct scsi_qla_host *vha)
 
 	ha->beacon_blink_led = 0;
 
-	if (IS_QLA2031(ha))
+	if (IS_QLA2031(ha) || IS_QLA27XX(ha))
 		goto set_fw_options;
 
 	if (IS_QLA8031(ha) || IS_QLA81XX(ha))
-- 
1.7.7

