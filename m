From: madhu.iyengar@qlogic.com
Subject: [PATCH 06/10] qla2xxx: Update to AER support, do early abort commands.
Date: Fri,  3 Sep 2010 15:20:53 -0700
Message-ID: <1283552457-4497-7-git-send-email-madhu.iyengar@qlogic.com>
References: <1283552457-4497-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:39332 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753419Ab0ICW06 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Sep 2010 18:26:58 -0400
In-Reply-To: <1283552457-4497-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Lalit Chandivade <lalit.chandivade@qlogic.com>

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

Currently the IOs are returned back in slot reset, this
could be late and can cause error handler to invoke.
If error handler invokes, eh_abort fails and escalate to
device/bus/host resets causing issues.
The commands need to be returned back to upper layer in
io_error_detected.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |   20 +++++++++++---------
 drivers/scsi/qla2xxx/qla_os.c   |    2 ++
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 3514237..669d58a 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3881,17 +3881,19 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
 			    LOOP_DOWN_TIME);
 	}
 
-	/* Make sure for ISP 82XX IO DMA is complete */
-	if (IS_QLA82XX(ha)) {
-		if (qla2x00_eh_wait_for_pending_commands(vha, 0, 0,
-			WAIT_HOST) == QLA_SUCCESS) {
-			DEBUG2(qla_printk(KERN_INFO, ha,
-			"Done wait for pending commands\n"));
+	if (!ha->flags.eeh_busy) {
+		/* Make sure for ISP 82XX IO DMA is complete */
+		if (IS_QLA82XX(ha)) {
+			if (qla2x00_eh_wait_for_pending_commands(vha, 0, 0,
+				WAIT_HOST) == QLA_SUCCESS) {
+				DEBUG2(qla_printk(KERN_INFO, ha,
+				"Done wait for pending commands\n"));
+			}
 		}
-	}
 
-	/* Requeue all commands in outstanding command list. */
-	qla2x00_abort_all_cmds(vha, DID_RESET << 16);
+		/* Requeue all commands in outstanding command list. */
+		qla2x00_abort_all_cmds(vha, DID_RESET << 16);
+	}
 }
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 6864eb1..dc495a3 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3800,6 +3800,8 @@ qla2xxx_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 		}
 		qla2x00_free_irqs(vha);
 		pci_disable_device(pdev);
+		/* Return back all IOs */
+		qla2x00_abort_all_cmds(vha, DID_RESET << 16);
 		return PCI_ERS_RESULT_NEED_RESET;
 	case pci_channel_io_perm_failure:
 		ha->flags.pci_channel_io_perm_failure = 1;
-- 
1.6.0.2

