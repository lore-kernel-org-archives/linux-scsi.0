From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 18/31] qla2xxx: Allow SNS fabric login to be retried
Date: Wed, 23 Aug 2017 15:05:12 -0700
Message-ID: <20170823220525.3115-19-himanshu.madhani@cavium.com>
References: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0087.outbound.protection.outlook.com ([104.47.33.87]:37568
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751112AbdHWWFw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Aug 2017 18:05:52 -0400
In-Reply-To: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@cavium.com>

If SNS fabric login fails, set loop resync flag to retry via dpc.

Signed-off-by: Joe Carnuccio <joe.carnuccio@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index d00e0129c51b..fe2d196833aa 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4752,24 +4752,16 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 			qla2x00_fdmi_register(vha);
 
 		/* Ensure we are logged into the SNS. */
-		if (IS_FWI2_CAPABLE(ha))
-			loop_id = NPH_SNS;
-		else
-			loop_id = SIMPLE_NAME_SERVER;
+		loop_id = NPH_SNS_LID(ha);
 		rval = ha->isp_ops->fabric_login(vha, loop_id, 0xff, 0xff,
 		    0xfc, mb, BIT_1|BIT_0);
-		if (rval != QLA_SUCCESS) {
+		if (rval != QLA_SUCCESS || mb[0] != MBS_COMMAND_COMPLETE) {
+			ql_dbg(ql_dbg_disc, vha, 0x20a1,
+			    "Failed SNS login: loop_id=%x mb[0]=%x mb[1]=%x mb[2]=%x mb[6]=%x mb[7]=%x (%x).\n",
+			    loop_id, mb[0], mb[1], mb[2], mb[6], mb[7], rval);
 			set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 			return rval;
 		}
-		if (mb[0] != MBS_COMMAND_COMPLETE) {
-			ql_dbg(ql_dbg_disc, vha, 0x20a1,
-			    "Failed SNS login: loop_id=%x mb[0]=%x mb[1]=%x mb[2]=%x "
-			    "mb[6]=%x mb[7]=%x.\n", loop_id, mb[0], mb[1],
-			    mb[2], mb[6], mb[7]);
-			return (QLA_SUCCESS);
-		}
-
 		if (test_and_clear_bit(REGISTER_FC4_NEEDED, &vha->dpc_flags)) {
 			if (qla2x00_rft_id(vha)) {
 				/* EMPTY */
-- 
2.12.0
