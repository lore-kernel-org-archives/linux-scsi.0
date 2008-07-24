From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 4/5] qla2xxx: Additional NPIV corrections.
Date: Thu, 24 Jul 2008 08:31:49 -0700
Message-ID: <1216913510-14767-4-git-send-email-andrew.vasquez@qlogic.com>
References: <20080724153108.GI561@plap4-2.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:23068 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486AbYGXPby (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jul 2008 11:31:54 -0400
In-Reply-To: <20080724153108.GI561@plap4-2.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Minor fixes addressing:
- rport managements during vport deletion.
- acquire proper physical-ha during qla24xx_abort_command() and
  qla24xx_queuecommand()
- do not needlessly acquire the pha for non-NPIV capable ISPs.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    5 +++++
 drivers/scsi/qla2xxx/qla_init.c |    3 ++-
 drivers/scsi/qla2xxx/qla_iocb.c |    9 ++++-----
 drivers/scsi/qla2xxx/qla_mbx.c  |    7 +++----
 drivers/scsi/qla2xxx/qla_mid.c  |    1 +
 drivers/scsi/qla2xxx/qla_os.c   |    6 ++++--
 6 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index fcec43a..7a4409a 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1177,6 +1177,11 @@ static int
 qla24xx_vport_delete(struct fc_vport *fc_vport)
 {
 	scsi_qla_host_t *vha = fc_vport->dd_data;
+	scsi_qla_host_t *pha = to_qla_parent(vha);
+
+	while (test_bit(LOOP_RESYNC_ACTIVE, &vha->dpc_flags) ||
+	    test_bit(FCPORT_UPDATE_NEEDED, &pha->dpc_flags))
+		msleep(1000);
 
 	qla24xx_disable_vp(vha);
 	qla24xx_deallocate_vp_id(vha);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 597ac20..601a6b2 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3231,7 +3231,8 @@ qla2x00_update_fcports(scsi_qla_host_t *ha)
 
 	/* Go with deferred removal of rport references. */
 	list_for_each_entry(fcport, &ha->fcports, list)
-		if (fcport->drport)
+		if (fcport->drport &&
+		    atomic_read(&fcport->state) != FCS_UNCONFIGURED)
 			qla2x00_rport_del(fcport);
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 6e14c8e..d57669a 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -269,7 +269,7 @@ qla2x00_start_scsi(srb_t *sp)
 {
 	int		ret, nseg;
 	unsigned long   flags;
-	scsi_qla_host_t	*ha, *pha;
+	scsi_qla_host_t	*ha;
 	struct scsi_cmnd *cmd;
 	uint32_t	*clr_ptr;
 	uint32_t        index;
@@ -283,7 +283,6 @@ qla2x00_start_scsi(srb_t *sp)
 	/* Setup device pointers. */
 	ret = 0;
 	ha = sp->ha;
-	pha = to_qla_parent(ha);
 	reg = &ha->iobase->isp;
 	cmd = sp->cmd;
 	/* So we know we haven't pci_map'ed anything yet */
@@ -298,7 +297,7 @@ qla2x00_start_scsi(srb_t *sp)
 	}
 
 	/* Acquire ring specific lock */
-	spin_lock_irqsave(&pha->hardware_lock, flags);
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 
 	/* Check for room in outstanding command list. */
 	handle = ha->current_outstanding_cmd;
@@ -387,14 +386,14 @@ qla2x00_start_scsi(srb_t *sp)
 	    ha->response_ring_ptr->signature != RESPONSE_PROCESSED)
 		qla2x00_process_response_queue(ha);
 
-	spin_unlock_irqrestore(&pha->hardware_lock, flags);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	return (QLA_SUCCESS);
 
 queuing_error:
 	if (tot_dsds)
 		scsi_dma_unmap(cmd);
 
-	spin_unlock_irqrestore(&pha->hardware_lock, flags);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return (QLA_FUNCTION_FAILED);
 }
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 7d7de59..bc90d6b 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -749,18 +749,17 @@ qla2x00_abort_command(scsi_qla_host_t *ha, srb_t *sp)
 	uint32_t	handle;
 	mbx_cmd_t	mc;
 	mbx_cmd_t	*mcp = &mc;
-	scsi_qla_host_t *pha = to_qla_parent(ha);
 
 	DEBUG11(printk("qla2x00_abort_command(%ld): entered.\n", ha->host_no));
 
 	fcport = sp->fcport;
 
-	spin_lock_irqsave(&pha->hardware_lock, flags);
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (handle = 1; handle < MAX_OUTSTANDING_COMMANDS; handle++) {
 		if (ha->outstanding_cmds[handle] == sp)
 			break;
 	}
-	spin_unlock_irqrestore(&pha->hardware_lock, flags);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	if (handle == MAX_OUTSTANDING_COMMANDS) {
 		/* command not found */
@@ -2172,7 +2171,7 @@ qla24xx_abort_command(scsi_qla_host_t *ha, srb_t *sp)
 
 	spin_lock_irqsave(&pha->hardware_lock, flags);
 	for (handle = 1; handle < MAX_OUTSTANDING_COMMANDS; handle++) {
-		if (ha->outstanding_cmds[handle] == sp)
+		if (pha->outstanding_cmds[handle] == sp)
 			break;
 	}
 	spin_unlock_irqrestore(&pha->hardware_lock, flags);
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 9a850a2..50baf6a 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -106,6 +106,7 @@ qla2x00_mark_vp_devices_dead(scsi_qla_host_t *vha)
 		    vha->host_no, fcport->loop_id, fcport->vp_idx));
 
 		qla2x00_mark_device_lost(vha, fcport, 0, 0);
+		atomic_set(&fcport->state, FCS_UNCONFIGURED);
 	}
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8fc712b..7c8af7e 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -449,7 +449,7 @@ qla24xx_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 	int rval;
 	scsi_qla_host_t *pha = to_qla_parent(ha);
 
-	if (unlikely(pci_channel_offline(ha->pdev))) {
+	if (unlikely(pci_channel_offline(pha->pdev))) {
 		cmd->result = DID_REQUEUE << 16;
 		goto qc24_fail_command;
 	}
@@ -2335,8 +2335,10 @@ qla2x00_do_dpc(void *data)
 			    ha->host_no));
 		}
 
-		if (test_and_clear_bit(FCPORT_UPDATE_NEEDED, &ha->dpc_flags))
+		if (test_bit(FCPORT_UPDATE_NEEDED, &ha->dpc_flags)) {
 			qla2x00_update_fcports(ha);
+			clear_bit(FCPORT_UPDATE_NEEDED, &ha->dpc_flags);
+		}
 
 		if (test_and_clear_bit(RESET_MARKER_NEEDED, &ha->dpc_flags) &&
 		    (!(test_and_set_bit(RESET_ACTIVE, &ha->dpc_flags)))) {
-- 
1.6.0.rc0.42.g186458

