From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 05/29] qla2xxx: Set factory reset recovery timeout to 10 min. for ISPFX00.
Date: Tue, 27 Aug 2013 01:37:31 -0400
Message-ID: <1377581875-8574-6-git-send-email-saurav.kashyap@qlogic.com>
References: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:17819 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752679Ab3H0GGe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Aug 2013 02:06:34 -0400
Received: from pps.filterd (m0045602.ppops.net [127.0.0.1])
	by mx0a-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id r7R65MB0019646
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:34 -0700
Received: from avcashub1.qlogic.com (avcashub1.qlogic.com [198.70.193.115])
	by mx0a-0016ce01.pphosted.com with ESMTP id 1eg8v690w6-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:34 -0700
In-Reply-To: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Armen Baloyan <armen.baloyan@qlogic.com>

Signed-off-by: Armen Baloyan <armen.baloyan@qlogic.com>
Acked-by: Srinivasa Rao <srinivasa.rao@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    1 +
 drivers/scsi/qla2xxx/qla_mr.c  |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index d675860..58e4f19 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -806,6 +806,7 @@ struct mbx_cmd_32 {
 #define MBA_MIRROR_LUN_CHANGE	0x8402	/* Mirror LUN State Change
 					   Notification */
 #define MBA_FW_POLL_STATE	0x8600  /* Firmware in poll diagnostic state */
+#define MBA_FW_RESET_FCT	0x8502	/* Firmware reset factory defaults */
 
 /* 83XX FCoE specific */
 #define MBA_IDC_AEN		0x8200  /* FCoE: NIC Core state change AEN */
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 413f050..7136bf5 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -1539,6 +1539,9 @@ qlafx00_timer_routine(scsi_qla_host_t *vha)
 		} else if ((aenmbx0 & 0xFF00) == MBA_FW_POLL_STATE) {
 			ha->mr.fw_reset_timer_tick =
 			    QLAFX00_MAX_RESET_INTERVAL;
+		} else if (aenmbx0 == MBA_FW_RESET_FCT) {
+			ha->mr.fw_reset_timer_tick =
+			    QLAFX00_MAX_RESET_INTERVAL;
 		}
 		ha->mr.old_aenmbx0_state = aenmbx0;
 		ha->mr.fw_reset_timer_tick--;
-- 
1.7.7

