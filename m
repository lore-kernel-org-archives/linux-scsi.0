From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 10/18] qla2xxx: Always aquire the parent's hardware_lock.
Date: Thu, 10 Jul 2008 16:55:55 -0700
Message-ID: <1215734163-40825-10-git-send-email-andrew.vasquez@qlogic.com>
References: <20080710235458.GQ29099@plap4-2.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:45262 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756730AbYGJX4L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2008 19:56:11 -0400
In-Reply-To: <20080710235458.GQ29099@plap4-2.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

From: Seokmann Ju <seokmann.ju@qlogic.com>

While issuing a marker, manipulating the request/response queues
and modifying the outstanding command array.

Signed-off-by: Seokmann Ju <seokmann.ju@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 drivers/scsi/qla2xxx/qla_iocb.c |   23 +++++++++++++----------
 drivers/scsi/qla2xxx/qla_mbx.c  |   10 ++++++----
 3 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 80f4f9d..4c83ff8 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4052,7 +4052,7 @@ qla24xx_configure_vhba(scsi_qla_host_t *ha)
 	rval = qla2x00_fw_ready(ha->parent);
 	if (rval == QLA_SUCCESS) {
 		clear_bit(RESET_MARKER_NEEDED, &ha->dpc_flags);
-		qla2x00_marker(ha->parent, 0, 0, MK_SYNC_ALL);
+		qla2x00_marker(ha, 0, 0, MK_SYNC_ALL);
 	}
 
 	ha->flags.management_server_logged_in = 0;
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 5489d50..6e14c8e 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -269,7 +269,7 @@ qla2x00_start_scsi(srb_t *sp)
 {
 	int		ret, nseg;
 	unsigned long   flags;
-	scsi_qla_host_t	*ha;
+	scsi_qla_host_t	*ha, *pha;
 	struct scsi_cmnd *cmd;
 	uint32_t	*clr_ptr;
 	uint32_t        index;
@@ -283,6 +283,7 @@ qla2x00_start_scsi(srb_t *sp)
 	/* Setup device pointers. */
 	ret = 0;
 	ha = sp->ha;
+	pha = to_qla_parent(ha);
 	reg = &ha->iobase->isp;
 	cmd = sp->cmd;
 	/* So we know we haven't pci_map'ed anything yet */
@@ -297,7 +298,7 @@ qla2x00_start_scsi(srb_t *sp)
 	}
 
 	/* Acquire ring specific lock */
-	spin_lock_irqsave(&ha->hardware_lock, flags);
+	spin_lock_irqsave(&pha->hardware_lock, flags);
 
 	/* Check for room in outstanding command list. */
 	handle = ha->current_outstanding_cmd;
@@ -386,14 +387,14 @@ qla2x00_start_scsi(srb_t *sp)
 	    ha->response_ring_ptr->signature != RESPONSE_PROCESSED)
 		qla2x00_process_response_queue(ha);
 
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	spin_unlock_irqrestore(&pha->hardware_lock, flags);
 	return (QLA_SUCCESS);
 
 queuing_error:
 	if (tot_dsds)
 		scsi_dma_unmap(cmd);
 
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	spin_unlock_irqrestore(&pha->hardware_lock, flags);
 
 	return (QLA_FUNCTION_FAILED);
 }
@@ -454,10 +455,11 @@ qla2x00_marker(scsi_qla_host_t *ha, uint16_t loop_id, uint16_t lun,
 {
 	int ret;
 	unsigned long flags = 0;
+	scsi_qla_host_t *pha = to_qla_parent(ha);
 
-	spin_lock_irqsave(&ha->hardware_lock, flags);
+	spin_lock_irqsave(&pha->hardware_lock, flags);
 	ret = __qla2x00_marker(ha, loop_id, lun, type);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	spin_unlock_irqrestore(&pha->hardware_lock, flags);
 
 	return (ret);
 }
@@ -672,7 +674,7 @@ qla24xx_start_scsi(srb_t *sp)
 {
 	int		ret, nseg;
 	unsigned long   flags;
-	scsi_qla_host_t	*ha;
+	scsi_qla_host_t	*ha, *pha;
 	struct scsi_cmnd *cmd;
 	uint32_t	*clr_ptr;
 	uint32_t        index;
@@ -686,6 +688,7 @@ qla24xx_start_scsi(srb_t *sp)
 	/* Setup device pointers. */
 	ret = 0;
 	ha = sp->ha;
+	pha = to_qla_parent(ha);
 	reg = &ha->iobase->isp24;
 	cmd = sp->cmd;
 	/* So we know we haven't pci_map'ed anything yet */
@@ -700,7 +703,7 @@ qla24xx_start_scsi(srb_t *sp)
 	}
 
 	/* Acquire ring specific lock */
-	spin_lock_irqsave(&ha->hardware_lock, flags);
+	spin_lock_irqsave(&pha->hardware_lock, flags);
 
 	/* Check for room in outstanding command list. */
 	handle = ha->current_outstanding_cmd;
@@ -795,14 +798,14 @@ qla24xx_start_scsi(srb_t *sp)
 	    ha->response_ring_ptr->signature != RESPONSE_PROCESSED)
 		qla24xx_process_response_queue(ha);
 
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	spin_unlock_irqrestore(&pha->hardware_lock, flags);
 	return QLA_SUCCESS;
 
 queuing_error:
 	if (tot_dsds)
 		scsi_dma_unmap(cmd);
 
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	spin_unlock_irqrestore(&pha->hardware_lock, flags);
 
 	return QLA_FUNCTION_FAILED;
 }
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 250d2f6..dc5788b 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -749,17 +749,18 @@ qla2x00_abort_command(scsi_qla_host_t *ha, srb_t *sp)
 	uint32_t	handle;
 	mbx_cmd_t	mc;
 	mbx_cmd_t	*mcp = &mc;
+	scsi_qla_host_t *pha = to_qla_parent(ha);
 
 	DEBUG11(printk("qla2x00_abort_command(%ld): entered.\n", ha->host_no));
 
 	fcport = sp->fcport;
 
-	spin_lock_irqsave(&ha->hardware_lock, flags);
+	spin_lock_irqsave(&pha->hardware_lock, flags);
 	for (handle = 1; handle < MAX_OUTSTANDING_COMMANDS; handle++) {
 		if (ha->outstanding_cmds[handle] == sp)
 			break;
 	}
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	spin_unlock_irqrestore(&pha->hardware_lock, flags);
 
 	if (handle == MAX_OUTSTANDING_COMMANDS) {
 		/* command not found */
@@ -2161,17 +2162,18 @@ qla24xx_abort_command(scsi_qla_host_t *ha, srb_t *sp)
 	struct abort_entry_24xx *abt;
 	dma_addr_t	abt_dma;
 	uint32_t	handle;
+	scsi_qla_host_t *pha = to_qla_parent(ha);
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
 
 	fcport = sp->fcport;
 
-	spin_lock_irqsave(&ha->hardware_lock, flags);
+	spin_lock_irqsave(&pha->hardware_lock, flags);
 	for (handle = 1; handle < MAX_OUTSTANDING_COMMANDS; handle++) {
 		if (ha->outstanding_cmds[handle] == sp)
 			break;
 	}
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	spin_unlock_irqrestore(&pha->hardware_lock, flags);
 	if (handle == MAX_OUTSTANDING_COMMANDS) {
 		/* Command not found. */
 		return QLA_FUNCTION_FAILED;
-- 
1.5.6.2.292.ga9a3

