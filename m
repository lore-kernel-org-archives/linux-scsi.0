From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 03/25] qla2xxx: Allow ABTS RX, RIDA on ATIOQ for ISP83XX/27XX
Date: Fri, 19 May 2017 14:53:22 -0700
Message-ID: <20170519215344.2168-4-himanshu.madhani@cavium.com>
References: <20170519215344.2168-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0079.outbound.protection.outlook.com ([104.47.34.79]:18871
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756731AbdESVx7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 May 2017 17:53:59 -0400
In-Reply-To: <20170519215344.2168-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Allow ABTS RX, RIDA to be moved to ATIO Queue only for
ISP83XX and ISP27XX.

Cc: <stable@vger.kernel.org>
Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 034743309ada..a017a1af1707 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2946,7 +2946,8 @@ qla24xx_update_fw_options(scsi_qla_host_t *vha)
 	}
 
 	/* Move PUREX, ABTS RX & RIDA to ATIOQ */
-	if (ql2xmvasynctoatio) {
+	if (ql2xmvasynctoatio &&
+	    (IS_QLA83XX(ha) || IS_QLA27XX(ha))) {
 		if (qla_tgt_mode_enabled(vha) ||
 		    qla_dual_mode_enabled(vha))
 			ha->fw_options[2] |= BIT_11;
@@ -2958,7 +2959,9 @@ qla24xx_update_fw_options(scsi_qla_host_t *vha)
 		"%s, add FW options 1-3 = 0x%04x 0x%04x 0x%04x mode %x\n",
 		__func__, ha->fw_options[1], ha->fw_options[2],
 		ha->fw_options[3], vha->host->active_mode);
-	qla2x00_set_fw_options(vha, ha->fw_options);
+
+	if (ha->fw_options[1] || ha->fw_options[2] || ha->fw_options[3])
+		qla2x00_set_fw_options(vha, ha->fw_options);
 
 	/* Update Serial Link options. */
 	if ((le16_to_cpu(ha->fw_seriallink_options24[0]) & BIT_0) == 0)
-- 
2.12.0
