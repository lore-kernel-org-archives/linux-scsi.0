From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 02/20] qla2xxx: Add handling for boot indication progress AENs for ISPFX00.
Date: Fri, 13 Dec 2013 15:03:42 -0500
Message-ID: <1386965040-20611-3-git-send-email-saurav.kashyap@qlogic.com>
References: <1386965040-20611-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:11151 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753266Ab3LMUhG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Dec 2013 15:37:06 -0500
In-Reply-To: <1386965040-20611-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Armen Baloyan <armen.baloyan@qlogic.com>

Signed-off-by: Armen Baloyan <armen.baloyan@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    2 +-
 drivers/scsi/qla2xxx/qla_mr.c  |    3 +++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 859c63a..02ad5d8 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -808,7 +808,7 @@ struct mbx_cmd_32 {
 					   Notification */
 #define MBA_FW_POLL_STATE	0x8600  /* Firmware in poll diagnostic state */
 #define MBA_FW_RESET_FCT	0x8502	/* Firmware reset factory defaults */
-
+#define MBA_FW_INIT_INPROGRESS	0x8500	/* Firmware boot in progress */
 /* 83XX FCoE specific */
 #define MBA_IDC_AEN		0x8200  /* FCoE: NIC Core state change AEN */
 
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index ba6f8b1..6ca4807 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -997,6 +997,9 @@ qlafx00_init_fw_ready(scsi_qla_host_t *vha)
 			break;
 
 		default:
+			if ((aenmbx & 0xFF00) == MBA_FW_INIT_INPROGRESS)
+				break;
+
 			/* If fw is apparently not ready. In order to continue,
 			 * we might need to issue Mbox cmd, but the problem is
 			 * that the DoorBell vector values that come with the
-- 
1.7.7

