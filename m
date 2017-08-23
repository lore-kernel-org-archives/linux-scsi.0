From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 20/31] qla2xxx: Print correct mailbox registers in failed summary
Date: Wed, 23 Aug 2017 15:05:14 -0700
Message-ID: <20170823220525.3115-21-himanshu.madhani@cavium.com>
References: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0079.outbound.protection.outlook.com ([104.47.36.79]:29568
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751005AbdHWWkr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Aug 2017 18:40:47 -0400
In-Reply-To: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@cavium.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 52cb9882bf31..da992b761402 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -106,7 +106,6 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 	uint16_t __iomem *optr;
 	uint32_t	cnt;
 	uint32_t	mboxes;
-	uint16_t __iomem *mbx_reg;
 	unsigned long	wait_time;
 	struct qla_hw_data *ha = vha->hw;
 	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
@@ -490,21 +489,24 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 
 mbx_done:
 	if (rval) {
-		ql_dbg(ql_dbg_disc, base_vha, 0x1020,
-		    "**** Failed mbx[0]=%x, mb[1]=%x, mb[2]=%x, mb[3]=%x, cmd=%x ****.\n",
-		    mcp->mb[0], mcp->mb[1], mcp->mb[2], mcp->mb[3], command);
-
+		if (ql2xextended_error_logging & (ql_dbg_disc|ql_dbg_mbx)) {
+			pr_warn("%s [%s]-%04x:%ld: **** Failed", QL_MSGHDR,
+			    dev_name(&ha->pdev->dev), 0x1020+0x800,
+			    vha->host_no);
+			mboxes = mcp->in_mb;
+			cnt = 4;
+			for (i = 0; i < ha->mbx_count && cnt; i++, mboxes >>= 1)
+				if (mboxes & BIT_0) {
+					printk(" mb[%u]=%x", i, mcp->mb[i]);
+					cnt--;
+				}
+			pr_warn(" cmd=%x ****\n", command);
+		}
 		ql_dbg(ql_dbg_mbx, vha, 0x1198,
-		    "host status: 0x%x, flags:0x%lx, intr ctrl reg:0x%x, intr status:0x%x\n",
+		    "host_status=%#x intr_ctrl=%#x intr_status=%#x\n",
 		    RD_REG_DWORD(&reg->isp24.host_status),
-		    ha->fw_dump_cap_flags,
 		    RD_REG_DWORD(&reg->isp24.ictrl),
 		    RD_REG_DWORD(&reg->isp24.istatus));
-
-		mbx_reg = &reg->isp24.mailbox0;
-		for (i = 0; i < 6; i++)
-			ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1199,
-			    "mbox[%d] 0x%04x\n", i, RD_REG_WORD(mbx_reg++));
 	} else {
 		ql_dbg(ql_dbg_mbx, base_vha, 0x1021, "Done %s.\n", __func__);
 	}
-- 
2.12.0
