From: madhu.iyengar@qlogic.com
Subject: [PATCH 11/13] qla2xxx: The ISP82XX should be online while waiting for commands completion.
Date: Wed, 23 Feb 2011 15:27:16 -0800
Message-ID: <1298503638-22396-12-git-send-email-madhu.iyengar@qlogic.com>
References: <1298503638-22396-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:52637 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755204Ab1BWXab (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Feb 2011 18:30:31 -0500
In-Reply-To: <1298503638-22396-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Saurav Kashyap <saurav.kashyap@qlogic.com>

From: Saurav Kashyap <saurav.kashyap@qlogic.com>

If adapter is not online, the driver will not process the response queue, even
on getting an interrupt.

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index bbf4a15..8575808 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3947,7 +3947,11 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
 	unsigned long flags;
 	fc_port_t *fcport;
 
-	vha->flags.online = 0;
+	/* For ISP82XX, driver waits for completion of the commands.
+	 * online flag should be set.
+	 */
+	if (!IS_QLA82XX(ha))
+		vha->flags.online = 0;
 	ha->flags.chip_reset_done = 0;
 	clear_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 	ha->qla_stats.total_isp_aborts++;
@@ -3955,7 +3959,10 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
 	qla_printk(KERN_INFO, ha,
 	    "Performing ISP error recovery - ha= %p.\n", ha);
 
-	/* Chip reset does not apply to 82XX */
+	/* For ISP82XX, reset_chip is just disabling interrupts.
+	 * Driver waits for the completion of the commands.
+	 * the interrupts need to be enabled.
+	 */
 	if (!IS_QLA82XX(ha))
 		ha->isp_ops->reset_chip(vha);
 
@@ -3999,9 +4006,15 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
 
 	if (!ha->flags.eeh_busy) {
 		/* Make sure for ISP 82XX IO DMA is complete */
-		if (IS_QLA82XX(ha))
+		if (IS_QLA82XX(ha)) {
 			qla82xx_chip_reset_cleanup(vha);
 
+			/* Done waiting for pending commands.
+			 * Reset the online flag.
+			 */
+			vha->flags.online = 0;
+		}
+
 		/* Requeue all commands in outstanding command list. */
 		qla2x00_abort_all_cmds(vha, DID_RESET << 16);
 	}
-- 
1.6.0.2

