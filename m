From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 13/19] qla2xxx: Add support to handle Loop Init error Asynchronus event.
Date: Wed, 6 Jul 2016 11:14:29 -0400
Message-ID: <1467818075-15246-14-git-send-email-himanshu.madhani@qlogic.com>
References: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:60651 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754145AbcGFQAN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 12:00:13 -0400
In-Reply-To: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |  2 +-
 drivers/scsi/qla2xxx/qla_isr.c | 11 +++++++++--
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index eebd1a58..288338d 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -30,7 +30,7 @@
  * |				  | 		       | 0x5047         |
  * |                              |                    | 0x5084,0x5075	|
  * |                              |                    | 0x503d,0x5044  |
- * |                              |                    | 0x507b,0x505f	|
+ * |                              |                    | 0x505f		|
  * | Timer Routines               |       0x6012       |                |
  * | User Space Interactions      |       0x70e3       | 0x7018,0x702e  |
  * |				  |		       | 0x7020,0x7024  |
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index b8d0b78a..134ad2f 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -710,16 +710,23 @@ skip_rio:
 
 	case MBA_RSP_TRANSFER_ERR:	/* Response Transfer Error */
 		ql_log(ql_log_warn, vha, 0x5007,
-		    "ISP Response Transfer Error.\n");
+		    "ISP Response Transfer Error (%x).\n", mb[1]);
 
 		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 		break;
 
 	case MBA_WAKEUP_THRES:		/* Request Queue Wake-up */
 		ql_dbg(ql_dbg_async, vha, 0x5008,
-		    "Asynchronous WAKEUP_THRES.\n");
+		    "Asynchronous WAKEUP_THRES (%x).\n", mb[1]);
+		break;
 
+	case MBA_LOOP_INIT_ERR:
+		ql_log(ql_log_warn, vha, 0x507b,
+		    "LOOP INIT ERROR (%x).\n", mb[1]);
+		ha->isp_ops->fw_dump(vha, 1);
+		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 		break;
+
 	case MBA_LIP_OCCURRED:		/* Loop Initialization Procedure */
 		ql_dbg(ql_dbg_async, vha, 0x5009,
 		    "LIP occurred (%x).\n", mb[1]);
-- 
2.7.2

