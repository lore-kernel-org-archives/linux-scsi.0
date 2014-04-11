From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 11/42] qla2xxx: Check for peg alive counter and clear any outstanding mailbox command.
Date: Fri, 11 Apr 2014 16:54:16 -0400
Message-ID: <1397249687-32666-12-git-send-email-saurav.kashyap@qlogic.com>
References: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:44042 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754689AbaDKVb6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2014 17:31:58 -0400
In-Reply-To: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx2.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index 6d73e2e..131a9d5 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -2124,6 +2124,13 @@ qla8044_watchdog(struct scsi_qla_host *vha)
 	    test_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags))) {
 		dev_state = qla8044_rd_direct(vha, QLA8044_CRB_DEV_STATE_INDEX);
 
+		if (qla8044_check_fw_alive(vha)) {
+			ha->flags.isp82xx_fw_hung = 1;
+			ql_log(ql_log_warn, vha, 0xb10a,
+			    "Firmware hung.\n");
+			qla82xx_clear_pending_mbx(vha);
+		}
+
 		if (qla8044_check_temp(vha)) {
 			set_bit(ISP_UNRECOVERABLE, &vha->dpc_flags);
 			ha->flags.isp82xx_fw_hung = 1;
@@ -2144,7 +2151,7 @@ qla8044_watchdog(struct scsi_qla_host *vha)
 			qla2xxx_wake_dpc(vha);
 		} else  {
 			/* Check firmware health */
-			if (qla8044_check_fw_alive(vha)) {
+			if (ha->flags.isp82xx_fw_hung) {
 				halt_status = qla8044_rd_direct(vha,
 					QLA8044_PEG_HALT_STATUS1_INDEX);
 				if (halt_status &
@@ -2180,12 +2187,8 @@ qla8044_watchdog(struct scsi_qla_host *vha)
 						    __func__);
 						set_bit(ISP_ABORT_NEEDED,
 						    &vha->dpc_flags);
-						qla82xx_clear_pending_mbx(vha);
 					}
 				}
-				ha->flags.isp82xx_fw_hung = 1;
-				ql_log(ql_log_warn, vha, 0xb10a,
-				    "Firmware hung.\n");
 				qla2xxx_wake_dpc(vha);
 			}
 		}
-- 
1.7.7

