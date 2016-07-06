From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 17/19] qla2xxx: Fix duplicate message id.
Date: Wed, 6 Jul 2016 11:14:33 -0400
Message-ID: <1467818075-15246-18-git-send-email-himanshu.madhani@qlogic.com>
References: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:41103 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754795AbcGFQAL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 12:00:11 -0400
In-Reply-To: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, linux-scsi@vger.kernel.org

From: Sawan Chandak <sawan.chandak@qlogic.com>

Signed-off-by: Sawan Chandak <sawan.chandak@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c | 7 +++----
 drivers/scsi/qla2xxx/qla_isr.c | 2 +-
 drivers/scsi/qla2xxx/qla_mbx.c | 4 ++--
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 97b0a9d..45af34d 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -14,9 +14,8 @@
  * | Module Init and Probe        |       0x0191       | 0x0146         |
  * |                              |                    | 0x015b-0x0160	|
  * |                              |                    | 0x016e		|
- * | Mailbox commands             |       0x1196       | 0x1193		|
- * |                              |                    |		|
- * | Device Discovery             |       0x2003       | 0x2016		|
+ * | Mailbox commands             |       0x1199       | 0x1193		|
+ * | Device Discovery             |       0x2004       | 0x2016		|
  * |                              |                    | 0x2011-0x2012, |
  * |                              |                    | 0x2099-0x20a4  |
  * | Queue Command and IO tracing |       0x3074       | 0x300b         |
@@ -26,7 +25,7 @@
  * |                              |                    | 0x3036,0x3038  |
  * |                              |                    | 0x303a		|
  * | DPC Thread                   |       0x4023       | 0x4002,0x4013  |
- * | Async Events                 |       0x5089       | 0x502b-0x502f  |
+ * | Async Events                 |       0x5090       | 0x502b-0x502f  |
  * |				  | 		       | 0x5047         |
  * |                              |                    | 0x5084,0x5075	|
  * |                              |                    | 0x503d,0x5044  |
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 1b87977..90b3c2e 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -721,7 +721,7 @@ skip_rio:
 		break;
 
 	case MBA_LOOP_INIT_ERR:
-		ql_log(ql_log_warn, vha, 0x507b,
+		ql_log(ql_log_warn, vha, 0x5090,
 		    "LOOP INIT ERROR (%x).\n", mb[1]);
 		ha->isp_ops->fw_dump(vha, 1);
 		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index bf16e6f..23698c9 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -404,7 +404,7 @@ mbx_done:
 		    "**** Failed mbx[0]=%x, mb[1]=%x, mb[2]=%x, mb[3]=%x, cmd=%x ****.\n",
 		    mcp->mb[0], mcp->mb[1], mcp->mb[2], mcp->mb[3], command);
 
-		ql_dbg(ql_dbg_disc, vha, 0x1115,
+		ql_dbg(ql_dbg_mbx, vha, 0x1198,
 		    "host status: 0x%x, flags:0x%lx, intr ctrl reg:0x%x, intr status:0x%x\n",
 		    RD_REG_DWORD(&reg->isp24.host_status),
 		    ha->fw_dump_cap_flags,
@@ -413,7 +413,7 @@ mbx_done:
 
 		mbx_reg = &reg->isp24.mailbox0;
 		for (i = 0; i < 6; i++)
-			ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0x1116,
+			ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1199,
 			    "mbox[%d] 0x%04x\n", i, RD_REG_WORD(mbx_reg++));
 	} else {
 		ql_dbg(ql_dbg_mbx, base_vha, 0x1021, "Done %s.\n", __func__);
-- 
2.7.2

