From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 03/11] qla2xxx: Cleanup any outstanding SRB resources during shutdown.
Date: Thu, 31 Jan 2008 12:33:46 -0800
Message-ID: <1201811634-19865-3-git-send-email-andrew.vasquez@qlogic.com>
References: <20080131203216.GB19014@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:8353 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760376AbYAaUeG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jan 2008 15:34:06 -0500
In-Reply-To: <20080131203216.GB19014@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Refactor SRB-failure completion codes in the process.  Also,
signal the DPC routine to complete sooner as backend processing
at shutdown-time is superflous.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h  |    1 +
 drivers/scsi/qla2xxx/qla_init.c |   16 +---------------
 drivers/scsi/qla2xxx/qla_os.c   |   30 ++++++++++++++++++++++++++----
 3 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index ba35fc2..193f688 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -66,6 +66,7 @@ extern int ql2xqfullrampup;
 extern int num_hosts;
 
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
+extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
 
 /*
  * Global Functions in qla_mid.c source file.
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index d0633ca..2e51fa8 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3213,9 +3213,6 @@ int
 qla2x00_abort_isp(scsi_qla_host_t *ha)
 {
 	int rval;
-	unsigned long flags = 0;
-	uint16_t       cnt;
-	srb_t          *sp;
 	uint8_t        status = 0;
 
 	if (ha->flags.online) {
@@ -3236,19 +3233,8 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 				    LOOP_DOWN_TIME);
 		}
 
-		spin_lock_irqsave(&ha->hardware_lock, flags);
 		/* Requeue all commands in outstanding command list. */
-		for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
-			sp = ha->outstanding_cmds[cnt];
-			if (sp) {
-				ha->outstanding_cmds[cnt] = NULL;
-				sp->flags = 0;
-				sp->cmd->result = DID_RESET << 16;
-				sp->cmd->host_scribble = (unsigned char *)NULL;
-				qla2x00_sp_compl(ha, sp);
-			}
-		}
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		qla2x00_abort_all_cmds(ha, DID_RESET << 16);
 
 		ha->isp_ops->get_flash_version(ha, ha->request_ring);
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index bbdfd81..e2adfce 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1117,6 +1117,27 @@ qla2x00_device_reset(scsi_qla_host_t *ha, fc_port_t *reset_fcport)
 	return ha->isp_ops->abort_target(reset_fcport);
 }
 
+void
+qla2x00_abort_all_cmds(scsi_qla_host_t *ha, int res)
+{
+	int cnt;
+	unsigned long flags;
+	srb_t *sp;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
+		sp = ha->outstanding_cmds[cnt];
+		if (sp) {
+			ha->outstanding_cmds[cnt] = NULL;
+			sp->flags = 0;
+			sp->cmd->result = res;
+			sp->cmd->host_scribble = (unsigned char *)NULL;
+			qla2x00_sp_compl(ha, sp);
+		}
+	}
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+}
+
 static int
 qla2xxx_slave_alloc(struct scsi_device *sdev)
 {
@@ -1601,6 +1622,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	sprintf(ha->host_str, "%s_%ld", QLA2XXX_DRIVER_NAME, ha->host_no);
 	ha->parent = NULL;
 	ha->bars = bars;
+	spin_lock_init(&ha->hardware_lock);
 
 	/* Set ISP-type information. */
 	qla2x00_set_isp_flags(ha);
@@ -1614,8 +1636,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    "Found an ISP%04X, irq %d, iobase 0x%p\n", pdev->device, pdev->irq,
 	    ha->iobase);
 
-	spin_lock_init(&ha->hardware_lock);
-
 	ha->prev_topology = 0;
 	ha->init_cb_size = sizeof(init_cb_t);
 	ha->mgmt_svr_loop_id = MANAGEMENT_SERVER + ha->vp_idx;
@@ -1841,10 +1861,14 @@ qla2x00_remove_one(struct pci_dev *pdev)
 static void
 qla2x00_free_device(scsi_qla_host_t *ha)
 {
+	qla2x00_abort_all_cmds(ha, DID_NO_CONNECT << 16);
+
 	/* Disable timer */
 	if (ha->timer_active)
 		qla2x00_stop_timer(ha);
 
+	ha->flags.online = 0;
+
 	/* Kill the kernel thread for this host */
 	if (ha->dpc_thread) {
 		struct task_struct *t = ha->dpc_thread;
@@ -1863,8 +1887,6 @@ qla2x00_free_device(scsi_qla_host_t *ha)
 	if (ha->eft)
 		qla2x00_disable_eft_trace(ha);
 
-	ha->flags.online = 0;
-
 	/* Stop currently executing firmware. */
 	qla2x00_try_to_stop_firmware(ha);
 
-- 
1.5.4.rc5.5.gab98

