From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 08/31] qla2xxx: Use BIT_6 to acquire FAWWPN from switch
Date: Wed, 23 Aug 2017 15:05:02 -0700
Message-ID: <20170823220525.3115-9-himanshu.madhani@cavium.com>
References: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0078.outbound.protection.outlook.com ([104.47.34.78]:29120
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751112AbdHWWFk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Aug 2017 18:05:40 -0400
In-Reply-To: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Sawan Chandak <sawan.chandak@cavium.com>

If FA-WWPN feature disabled on the switch side and
enabled for the adapter, then driver would update
the port name with switch port name.

This patch fixes issue by checking correct BIT flag to validate.

Fixes: 41dc529a4602 ("qla2xxx: Improve RSCN handling in driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Sawan Chandak <sawan.chandak@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 234ef442ef5d..6164a2c9a1f4 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3682,7 +3682,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 				if (qla_ini_mode_enabled(vha) &&
 				    ha->flags.fawwpn_enabled &&
 				    (rptid_entry->u.f1.flags &
-				     VP_FLAGS_NAME_VALID)) {
+				     BIT_6)) {
 					memcpy(vha->port_name,
 					    rptid_entry->u.f1.port_name,
 					    WWN_SIZE);
-- 
2.12.0
