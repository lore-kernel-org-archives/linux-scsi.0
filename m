From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 35/42] qla2xxx: Fix beacon blink logic for ISP26xx/83xx.
Date: Fri, 11 Apr 2014 16:54:40 -0400
Message-ID: <1397249687-32666-36-git-send-email-saurav.kashyap@qlogic.com>
References: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:7123 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754976AbaDKVcE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2014 17:32:04 -0400
In-Reply-To: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Himanshu Madani <himanshu.madani@qlogic.com>

Signed-off-by: Himanshu Madani <himanshu.madani@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c  |    6 ++++--
 drivers/scsi/qla2xxx/qla_sup.c |    7 ++-----
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 575404f..ef6332b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5127,8 +5127,10 @@ intr_on_check:
 			ha->isp_ops->enable_intrs(ha);
 
 		if (test_and_clear_bit(BEACON_BLINK_NEEDED,
-					&base_vha->dpc_flags))
-			ha->isp_ops->beacon_blink(base_vha);
+					&base_vha->dpc_flags)) {
+			if (ha->beacon_blink_led == 1)
+				ha->isp_ops->beacon_blink(base_vha);
+		}
 
 		if (!IS_QLAFX00(ha))
 			qla2x00_do_dpc_all_vps(base_vha);
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 5dcaaca..bca173e 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -1727,11 +1727,8 @@ qla83xx_beacon_blink(struct scsi_qla_host *vha)
 	if (IS_QLA2031(ha)) {
 		led_select_value = qla83xx_select_led_port(ha);
 
-		qla83xx_wr_reg(vha, led_select_value, 0x40002000);
-		qla83xx_wr_reg(vha, led_select_value + 4, 0x40002000);
-		msleep(1000);
-		qla83xx_wr_reg(vha, led_select_value, 0x40004000);
-		qla83xx_wr_reg(vha, led_select_value + 4, 0x40004000);
+		qla83xx_wr_reg(vha, led_select_value, 0x40000230);
+		qla83xx_wr_reg(vha, led_select_value + 4, 0x40000230);
 	} else if (IS_QLA8031(ha)) {
 		led_select_value = qla83xx_select_led_port(ha);
 
-- 
1.7.7

