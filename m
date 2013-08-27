From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 20/29] qla2xxx: QLAFX00 make over temperature AEN handling informational, add log for normal temperature AEN
Date: Tue, 27 Aug 2013 01:37:46 -0400
Message-ID: <1377581875-8574-21-git-send-email-saurav.kashyap@qlogic.com>
References: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:51802 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752891Ab3H0GGt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Aug 2013 02:06:49 -0400
Received: from pps.filterd (m0000643.ppops.net [127.0.0.1])
	by mx0b-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id r7R64OiF012247
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:47 -0700
Received: from avcashub1.qlogic.com (avcashub1.qlogic.com [198.70.193.115])
	by mx0b-0016ce01.pphosted.com with ESMTP id 1e5gq13pa9-17
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:47 -0700
In-Reply-To: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Armen Baloyan <armen.baloyan@qlogic.com>

Signed-off-by: Armen Baloyan <armen.baloyan@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |    2 +-
 drivers/scsi/qla2xxx/qla_mr.c  |   14 +++++++++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index b1b6bc1..ca6bcf6 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -26,7 +26,7 @@
  * |                              |                    | 0x3036,0x3038  |
  * |                              |                    | 0x303a		|
  * | DPC Thread                   |       0x4022       | 0x4002,0x4013  |
- * | Async Events                 |       0x5083       | 0x502b-0x502f  |
+ * | Async Events                 |       0x5086       | 0x502b-0x502f  |
  * |                              |                    | 0x5047,0x5052  |
  * |                              |                    | 0x5040,0x5075  |
  * |                              |                    | 0x503d,0x5044  |
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 470f070..e48a71e 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -1765,7 +1765,6 @@ qlafx00_process_aen(struct scsi_qla_host *vha, struct qla_work_evt *evt)
 		aen_code = FCH_EVT_LINKDOWN;
 		aen_data = 0;
 		break;
-	case QLAFX00_MBA_TEMP_OVER:
 	case QLAFX00_MBA_TEMP_CRIT:	/* Critical temperature event */
 		ql_log(ql_log_info, vha, 0x5082,
 		    "Process critical temperature event "
@@ -2915,6 +2914,19 @@ qlafx00_async_event(scsi_qla_host_t *vha)
 		break;
 
 	case QLAFX00_MBA_TEMP_OVER:	/* Over temperature event */
+		ql_log(ql_log_info, vha, 0x5085,
+		    "Asynchronous over temperature event received "
+		    "aenmb[0]: %x\n",
+		    ha->aenmb[0]);
+		break;
+
+	case QLAFX00_MBA_TEMP_NORM:	/* Normal temperature event */
+		ql_log(ql_log_info, vha, 0x5086,
+		    "Asynchronous normal temperature event received "
+		    "aenmb[0]: %x\n",
+		    ha->aenmb[0]);
+		break;
+
 	case QLAFX00_MBA_TEMP_CRIT:	/* Critical temperature event */
 		ql_log(ql_log_info, vha, 0x5083,
 		    "Asynchronous critical temperature event received "
-- 
1.7.7

