From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 14/19] qla2xxx: Correction to function qla26xx_dport_diagnostics().
Date: Wed, 6 Jul 2016 11:14:30 -0400
Message-ID: <1467818075-15246-15-git-send-email-himanshu.madhani@qlogic.com>
References: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:65311 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754657AbcGFP7r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 11:59:47 -0400
In-Reply-To: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c | 2 +-
 drivers/scsi/qla2xxx/qla_isr.c | 8 +++-----
 drivers/scsi/qla2xxx/qla_mbx.c | 5 -----
 3 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 288338d..1a04270 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -14,7 +14,7 @@
  * | Module Init and Probe        |       0x0191       | 0x0146         |
  * |                              |                    | 0x015b-0x0160	|
  * |                              |                    | 0x016e		|
- * | Mailbox commands             |       0x1196       |		|
+ * | Mailbox commands             |       0x1196       | 0x1193		|
  * |                              |                    |		|
  * | Device Discovery             |       0x2003       | 0x2016		|
  * |                              |                    | 0x2011-0x2012, |
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 134ad2f..1b87977 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1159,13 +1159,11 @@ global_port_update:
 
 	case MBA_DPORT_DIAGNOSTICS:
 		ql_dbg(ql_dbg_async, vha, 0x5052,
-		    "D-Port Diagnostics: %04x result=%s index=%u size=%u\n",
+		    "D-Port Diagnostics: %04x result=%s\n",
 		    mb[0],
 		    mb[1] == 0 ? "start" :
-		    mb[1] == 1 ? "done (ok)" :
-		    mb[1] == 2 ? "done (error)" : "other",
-		    LSB(mb[2]),
-		    mb[3]);
+		    mb[1] == 1 ? "done (pass)" :
+		    mb[1] == 2 ? "done (error)" : "other");
 		break;
 
 	case MBA_TEMPERATURE_ALERT:
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 0f7b83a..bf16e6f 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -5764,11 +5764,6 @@ qla26xx_dport_diagnostics(scsi_qla_host_t *vha,
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1192,
 	    "Entered %s.\n", __func__);
 
-	if (size < 1024) {
-		ql_log(ql_log_warn, vha, 0x1193, "Failed insufficient size.\n");
-		return QLA_FUNCTION_PARAMETER_ERROR;
-	}
-
 	dd_dma = dma_map_single(&vha->hw->pdev->dev,
 	    dd_buf, size, DMA_FROM_DEVICE);
 	if (!dd_dma) {
-- 
2.7.2

