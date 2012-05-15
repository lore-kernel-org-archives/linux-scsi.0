From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 04/22] qla2xxx: Remove unneeded DPC wakeups from qla82xx_watchdog.
Date: Tue, 15 May 2012 14:34:11 -0400
Message-ID: <1337106869-14191-5-git-send-email-chad.dupuis@qlogic.com>
References: <1337106869-14191-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:62842 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S966144Ab2EOS50 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 May 2012 14:57:26 -0400
In-Reply-To: <1337106869-14191-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index de722a9..6f8850c 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -3352,13 +3352,11 @@ void qla82xx_watchdog(scsi_qla_host_t *vha)
 			ql_log(ql_log_warn, vha, 0x6001,
 			    "Adapter reset needed.\n");
 			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
-			qla2xxx_wake_dpc(vha);
 		} else if (dev_state == QLA82XX_DEV_NEED_QUIESCENT &&
 			!test_bit(ISP_QUIESCE_NEEDED, &vha->dpc_flags)) {
 			ql_log(ql_log_warn, vha, 0x6002,
 			    "Quiescent needed.\n");
 			set_bit(ISP_QUIESCE_NEEDED, &vha->dpc_flags);
-			qla2xxx_wake_dpc(vha);
 		} else {
 			if (qla82xx_check_fw_alive(vha)) {
 				ql_dbg(ql_dbg_timer, vha, 0x6011,
@@ -3398,7 +3396,6 @@ void qla82xx_watchdog(scsi_qla_host_t *vha)
 					set_bit(ISP_ABORT_NEEDED,
 					    &vha->dpc_flags);
 				}
-				qla2xxx_wake_dpc(vha);
 				ha->flags.isp82xx_fw_hung = 1;
 				ql_log(ql_log_warn, vha, 0x6007, "Firmware hung.\n");
 				qla82xx_clear_pending_mbx(vha);
-- 
1.7.7

