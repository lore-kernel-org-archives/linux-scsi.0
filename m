From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 11/23] qla2xxx: Move loopback mode reset after chip reset check.
Date: Fri,  8 Feb 2013 01:57:52 -0500
Message-ID: <1360306684-8286-12-git-send-email-saurav.kashyap@qlogic.com>
References: <1360306684-8286-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:51989 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1759978Ab3BHHTL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Feb 2013 02:19:11 -0500
In-Reply-To: <1360306684-8286-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

If we need to do a chip reset because of a serious loopback error don't try to
reset the loopback mode on the port as the mailbox command will timeout.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c |   39 ++++++++++++++++++++-------------------
 1 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 5478fff..169dc85 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -790,6 +790,26 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 			command_sent = INT_DEF_LB_LOOPBACK_CMD;
 			rval = qla2x00_loopback_test(vha, &elreq, response);
 
+			if (response[0] == MBS_COMMAND_ERROR &&
+					response[1] == MBS_LB_RESET) {
+				ql_log(ql_log_warn, vha, 0x7029,
+				    "MBX command error, Aborting ISP.\n");
+				set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+				qla2xxx_wake_dpc(vha);
+				qla2x00_wait_for_chip_reset(vha);
+				/* Also reset the MPI */
+				if (IS_QLA81XX(ha)) {
+					if (qla81xx_restart_mpi_firmware(vha) !=
+					    QLA_SUCCESS) {
+						ql_log(ql_log_warn, vha, 0x702a,
+						    "MPI reset failed.\n");
+					}
+				}
+
+				rval = -EIO;
+				goto done_free_dma_rsp;
+			}
+
 			if (new_config[0]) {
 				int ret;
 
@@ -811,25 +831,6 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 
 			}
 
-			if (response[0] == MBS_COMMAND_ERROR &&
-					response[1] == MBS_LB_RESET) {
-				ql_log(ql_log_warn, vha, 0x7029,
-				    "MBX command error, Aborting ISP.\n");
-				set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
-				qla2xxx_wake_dpc(vha);
-				qla2x00_wait_for_chip_reset(vha);
-				/* Also reset the MPI */
-				if (IS_QLA81XX(ha)) {
-					if (qla81xx_restart_mpi_firmware(vha) !=
-					    QLA_SUCCESS) {
-						ql_log(ql_log_warn, vha, 0x702a,
-						    "MPI reset failed.\n");
-					}
-				}
-
-				rval = -EIO;
-				goto done_free_dma_rsp;
-			}
 		} else {
 			type = "FC_BSG_HST_VENDOR_LOOPBACK";
 			ql_dbg(ql_dbg_user, vha, 0x702b,
-- 
1.7.7

