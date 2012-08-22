From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 03/42] qla2xxx: Add check in qla82xx_watchdog for failed hardware state.
Date: Wed, 22 Aug 2012 14:20:57 -0400
Message-ID: <1345659696-3670-4-git-send-email-chad.dupuis@qlogic.com>
References: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:28827 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S964958Ab2HVSiK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 14:38:10 -0400
In-Reply-To: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |    2 +-
 drivers/scsi/qla2xxx/qla_nx.c  |   16 ++++++++++++----
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index fdee561..72a1ea9 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -30,7 +30,7 @@
  * |                              |                    | 0x800b,0x8039  |
  * | AER/EEH                      |       0x9011       |		|
  * | Virtual Port                 |       0xa007       |		|
- * | ISP82XX Specific             |       0xb054       | 0xb024         |
+ * | ISP82XX Specific             |       0xb055       | 0xb024         |
  * | MultiQ                       |       0xc00c       |		|
  * | Misc                         |       0xd010       |		|
  * | Target Mode		  |	  0xe06f       |		|
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 9ce3a8f..1c3f65b 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -3027,7 +3027,6 @@ qla82xx_dev_failed_handler(scsi_qla_host_t *vha)
 	ql_log(ql_log_fatal, vha, 0x00b8,
 	    "Disabling the board.\n");
 
-	qla82xx_idc_lock(ha);
 	qla82xx_clear_drv_active(ha);
 	qla82xx_idc_unlock(ha);
 
@@ -3267,7 +3266,7 @@ qla82xx_device_state_handler(scsi_qla_host_t *vha)
 		switch (dev_state) {
 		case QLA82XX_DEV_READY:
 			ha->flags.isp82xx_reset_owner = 0;
-			goto exit;
+			goto rel_lock;
 		case QLA82XX_DEV_COLD:
 			rval = qla82xx_device_bootstrap(vha);
 			break;
@@ -3298,7 +3297,7 @@ qla82xx_device_state_handler(scsi_qla_host_t *vha)
 			 * to get changed
 			 */
 			if (ha->flags.quiesce_owner)
-				goto exit;
+				goto rel_lock;
 
 			qla82xx_idc_unlock(ha);
 			msleep(1000);
@@ -3319,8 +3318,9 @@ qla82xx_device_state_handler(scsi_qla_host_t *vha)
 		}
 		loopcount++;
 	}
-exit:
+rel_lock:
 	qla82xx_idc_unlock(ha);
+exit:
 	return rval;
 }
 
@@ -3384,6 +3384,14 @@ void qla82xx_watchdog(scsi_qla_host_t *vha)
 			ql_log(ql_log_warn, vha, 0x6002,
 			    "Quiescent needed.\n");
 			set_bit(ISP_QUIESCE_NEEDED, &vha->dpc_flags);
+		} else if (dev_state == QLA82XX_DEV_FAILED &&
+			!test_bit(ISP_UNRECOVERABLE, &vha->dpc_flags) &&
+			vha->flags.online == 1) {
+			ql_log(ql_log_warn, vha, 0xb055,
+			    "Adapter state is failed. Offlining.\n");
+			set_bit(ISP_UNRECOVERABLE, &vha->dpc_flags);
+			ha->flags.isp82xx_fw_hung = 1;
+			qla82xx_clear_pending_mbx(vha);
 		} else {
 			if (qla82xx_check_fw_alive(vha)) {
 				ql_dbg(ql_dbg_timer, vha, 0x6011,
-- 
1.7.7

