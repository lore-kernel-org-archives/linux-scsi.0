From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 09/14] qla2xxx: Encapsulate prematurely completing mailbox commands during ISP82xx firmware hang.
Date: Fri, 18 Nov 2011 09:02:17 -0800
Message-ID: <1321635742-16426-10-git-send-email-chad.dupuis@qlogic.com>
References: <1321635742-16426-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:43600
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758196Ab1KRRP3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2011 12:15:29 -0500
In-Reply-To: <1321635742-16426-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |    6 +++---
 drivers/scsi/qla2xxx/qla_gbl.h |    1 +
 drivers/scsi/qla2xxx/qla_nx.c  |   33 ++++++++++++++++-----------------
 drivers/scsi/qla2xxx/qla_os.c  |   12 ++----------
 4 files changed, 22 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 9df4787..e320d54 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -17,12 +17,12 @@
  * | Queue Command and IO tracing |       0x302e       |     0x3008     |
  * | DPC Thread                   |       0x401c       |		|
  * | Async Events                 |       0x5059       |		|
- * | Timer Routines               |       0x600d       |		|
+ * | Timer Routines               |       0x6010       | 0x600e,0x600f  |
  * | User Space Interactions      |       0x709d       |		|
- * | Task Management              |       0x8041       |    		|
+ * | Task Management              |       0x8041       | 0x800b         |
  * | AER/EEH                      |       0x900f       |		|
  * | Virtual Port                 |       0xa007       |		|
- * | ISP82XX Specific             |       0xb051       |    		|
+ * | ISP82XX Specific             |       0xb052       |    		|
  * | MultiQ                       |       0xc00b       |		|
  * | Misc                         |       0xd00b       |		|
  * ----------------------------------------------------------------------
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index ce32d81..c0c11af 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -578,6 +578,7 @@ extern int qla82xx_check_md_needed(scsi_qla_host_t *);
 extern void qla82xx_chip_reset_cleanup(scsi_qla_host_t *);
 extern int qla82xx_mbx_beacon_ctl(scsi_qla_host_t *, int);
 extern char *qdev_state(uint32_t);
+extern void qla82xx_clear_pending_mbx(scsi_qla_host_t *);
 
 /* BSG related functions */
 extern int qla24xx_bsg_request(struct fc_bsg_job *);
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index d025582..9e2c192 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -3817,6 +3817,19 @@ exit:
 	return rval;
 }
 
+void qla82xx_clear_pending_mbx(scsi_qla_host_t *vha)
+{
+	struct qla_hw_data *ha = vha->hw;
+
+	if (ha->flags.mbox_busy) {
+		ha->flags.mbox_int = 1;
+		ql_log(ql_log_warn, vha, 0x6010,
+		    "Doing premature completion of mbx command.\n");
+		if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags))
+			complete(&ha->mbx_intr_comp);
+	}
+}
+
 void qla82xx_watchdog(scsi_qla_host_t *vha)
 {
 	uint32_t dev_state, halt_status;
@@ -3874,16 +3887,8 @@ void qla82xx_watchdog(scsi_qla_host_t *vha)
 				}
 				qla2xxx_wake_dpc(vha);
 				ha->flags.isp82xx_fw_hung = 1;
-				if (ha->flags.mbox_busy) {
-					ha->flags.mbox_int = 1;
-					ql_log(ql_log_warn, vha, 0x6007,
-					    "Due to FW hung, doing "
-					    "premature completion of mbx "
-					    "command.\n");
-					if (test_bit(MBX_INTR_WAIT,
-					    &ha->mbx_cmd_flags))
-						complete(&ha->mbx_intr_comp);
-				}
+				ql_log(ql_log_warn, vha, 0x6007, "Firmware hung.\n");
+				qla82xx_clear_pending_mbx(vha);
 			}
 		}
 	}
@@ -4078,13 +4083,7 @@ qla82xx_chip_reset_cleanup(scsi_qla_host_t *vha)
 			msleep(1000);
 			if (qla82xx_check_fw_alive(vha)) {
 				ha->flags.isp82xx_fw_hung = 1;
-				if (ha->flags.mbox_busy) {
-					ha->flags.mbox_int = 1;
-					if (test_bit(MBX_INTR_WAIT,
-					    &ha->mbx_cmd_flags)) {
-						complete(&ha->mbx_intr_comp);
-					}
-				}
+				qla82xx_clear_pending_mbx(vha);
 				break;
 			}
 		}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 71d6259..f9e5b85 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4009,16 +4009,8 @@ qla2xxx_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 		/* For ISP82XX complete any pending mailbox cmd */
 		if (IS_QLA82XX(ha)) {
 			ha->flags.isp82xx_fw_hung = 1;
-			if (ha->flags.mbox_busy) {
-				ha->flags.mbox_int = 1;
-				ql_dbg(ql_dbg_aer, vha, 0x9001,
-				    "Due to pci channel io frozen, doing premature "
-				    "completion of mbx command.\n");
-				if (test_bit(MBX_INTR_WAIT,
-				    &ha->mbx_cmd_flags)) {
-					complete(&ha->mbx_intr_comp);
-				}
-			}
+			ql_dbg(ql_dbg_aer, vha, 0x9001, "Pci channel io frozen\n");
+			qla82xx_clear_pending_mbx(vha);
 		}
 		qla2x00_free_irqs(vha);
 		pci_disable_device(pdev);
-- 
1.6.0.2


