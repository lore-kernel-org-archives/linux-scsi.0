From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 15/17] qla2xxx: Accelerate SCSI BUSY status generation in target mode
Date: Tue, 30 May 2017 10:54:30 -0700
Message-ID: <20170530175432.26984-16-himanshu.madhani@cavium.com>
References: <20170530175432.26984-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0074.outbound.protection.outlook.com ([104.47.40.74]:35232
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751157AbdE3RzR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 May 2017 13:55:17 -0400
In-Reply-To: <20170530175432.26984-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Accelerate generation of SCSI busy to let initiators slow
down when target is running low in resources.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 13 +++++++++++--
 drivers/scsi/qla2xxx/qla_mbx.c  |  2 ++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 0ee9159457e4..3a51ddab36b8 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -7381,10 +7381,19 @@ qla81xx_update_fw_options(scsi_qla_host_t *vha)
 	}
 
 	if (qla_tgt_mode_enabled(vha) ||
-	    qla_dual_mode_enabled(vha))
+	    qla_dual_mode_enabled(vha)) {
+		/* FW auto send SCSI status during */
+		ha->fw_options[1] |= BIT_8;
+		ha->fw_options[10] |= (u16)SAM_STAT_BUSY << 8;
+
+		/* FW perform Exchang validation */
 		ha->fw_options[2] |= BIT_4;
-	else
+	} else {
+		ha->fw_options[1]  &= ~BIT_8;
+		ha->fw_options[10] &= 0x00ff;
+
 		ha->fw_options[2] &= ~BIT_4;
+	}
 
 	if (ql2xetsenable) {
 		/* Enable ETS Burst. */
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index bebac42d9e9e..f02a2baffb5b 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1048,6 +1048,8 @@ qla2x00_set_fw_options(scsi_qla_host_t *vha, uint16_t *fwopts)
 	mcp->in_mb = MBX_0;
 	if (IS_FWI2_CAPABLE(vha->hw)) {
 		mcp->in_mb |= MBX_1;
+		mcp->mb[10] = fwopts[10];
+		mcp->out_mb |= MBX_10;
 	} else {
 		mcp->mb[10] = fwopts[10];
 		mcp->mb[11] = fwopts[11];
-- 
2.12.0
