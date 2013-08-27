From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 21/29] qla2xxx: Set default critical temperature value in cases when ISPFX00 firmware doesn't provide it
Date: Tue, 27 Aug 2013 01:37:47 -0400
Message-ID: <1377581875-8574-22-git-send-email-saurav.kashyap@qlogic.com>
References: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:51820 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752908Ab3H0GGu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Aug 2013 02:06:50 -0400
Received: from pps.filterd (m0000643.ppops.net [127.0.0.1])
	by mx0b-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id r7R64OiH012247
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:49 -0700
Received: from avcashub1.qlogic.com (avcashub1.qlogic.com [198.70.193.115])
	by mx0b-0016ce01.pphosted.com with ESMTP id 1e5gq13pa9-19
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:49 -0700
In-Reply-To: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Armen Baloyan <armen.baloyan@qlogic.com>

Signed-off-by: Armen Baloyan <armen.baloyan@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mr.c |    4 +++-
 drivers/scsi/qla2xxx/qla_mr.h |    3 +++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index e48a71e..39d1306 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -1965,7 +1965,9 @@ qlafx00_fx_disc(scsi_qla_host_t *vha, fc_port_t *fcport, uint16_t fx_type)
 		    sizeof(vha->hw->mr.uboot_version));
 		memcpy(&vha->hw->mr.fru_serial_num, pinfo->fru_serial_num,
 		    sizeof(vha->hw->mr.fru_serial_num));
-		vha->hw->mr.critical_temperature = pinfo->nominal_temp_value;
+		vha->hw->mr.critical_temperature =
+		    (pinfo->nominal_temp_value) ?
+		    pinfo->nominal_temp_value : QLAFX00_CRITEMP_THRSHLD;
 		ha->mr.extended_io_enabled = (pinfo->enabled_capabilities &
 		    QLAFX00_EXTENDED_IO_EN_MASK) != 0;
 	} else if (fx_type == FXDISC_GET_PORT_INFO) {
diff --git a/drivers/scsi/qla2xxx/qla_mr.h b/drivers/scsi/qla2xxx/qla_mr.h
index 7b33416..79a93c5 100644
--- a/drivers/scsi/qla2xxx/qla_mr.h
+++ b/drivers/scsi/qla2xxx/qla_mr.h
@@ -537,4 +537,7 @@ struct mr_data_fx00 {
 #define QLAFX00_RESET_INTERVAL		120	/* number of seconds */
 #define QLAFX00_MAX_RESET_INTERVAL	600	/* number of seconds */
 #define QLAFX00_CRITEMP_INTERVAL	60	/* number of seconds */
+
+#define QLAFX00_CRITEMP_THRSHLD		80	/* Celsius degrees */
+
 #endif
-- 
1.7.7

