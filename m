From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 13/21] qla2xxx: Add midlayer target/device reset support.
Date: Thu,  3 Apr 2008 13:13:24 -0700
Message-ID: <1207253612-15538-13-git-send-email-andrew.vasquez@qlogic.com>
References: <20080403201152.GB8033@plap4.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:6416 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761671AbYDCUN4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2008 16:13:56 -0400
In-Reply-To: <20080403201152.GB8033@plap4.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Now that infrastructure is present within the midlayer and there
is a clear distinction between what is expected from a device and
target reset, convert the current device-reset codes to a
target-reset, and add codes to perform a proper device-reset (LUN
reset).

In the process of adding reset support, collapse and consolidate
large sections of mailbox-command (TMF issuance) codes,
generalize the two 'wait-for-commands-to-complete' functions, and
add a generic-reset routine for use by midlayer reset functions.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    3 +-
 drivers/scsi/qla2xxx/qla_fw.h  |    2 +-
 drivers/scsi/qla2xxx/qla_gbl.h |    8 +-
 drivers/scsi/qla2xxx/qla_mbx.c |  123 +++++++++++++-------
 drivers/scsi/qla2xxx/qla_os.c  |  254 ++++++++++++++++------------------------
 5 files changed, 192 insertions(+), 198 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 3843eaa..f7919d3 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2062,7 +2062,8 @@ struct isp_operations {
 	void (*disable_intrs) (struct scsi_qla_host *);
 
 	int (*abort_command) (struct scsi_qla_host *, srb_t *);
-	int (*abort_target) (struct fc_port *);
+	int (*target_reset) (struct fc_port *, unsigned int);
+	int (*lun_reset) (struct fc_port *, unsigned int);
 	int (*fabric_login) (struct scsi_qla_host *, uint16_t, uint8_t,
 		uint8_t, uint8_t, uint16_t *, uint8_t);
 	int (*fabric_logout) (struct scsi_qla_host *, uint16_t, uint8_t,
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 38adc0f..c6a5e49 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -719,7 +719,7 @@ struct tsk_mgmt_entry {
 
 	uint16_t timeout;		/* Command timeout. */
 
-	uint8_t lun[8];			/* FCP LUN (BE). */
+	struct scsi_lun lun;		/* FCP LUN (BE). */
 
 	uint32_t control_flags;		/* Control Flags. */
 #define TCF_NOTMCMD_TO_TARGET	BIT_31
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index f25aa63..f213364 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -153,7 +153,10 @@ extern int
 qla2x00_abort_command(scsi_qla_host_t *, srb_t *);
 
 extern int
-qla2x00_abort_target(fc_port_t *);
+qla2x00_abort_target(struct fc_port *, unsigned int);
+
+extern int
+qla2x00_lun_reset(struct fc_port *, unsigned int);
 
 extern int
 qla2x00_get_adapter_id(scsi_qla_host_t *, uint16_t *, uint8_t *, uint8_t *,
@@ -219,7 +222,8 @@ qla24xx_get_isp_stats(scsi_qla_host_t *, struct link_statistics *,
     dma_addr_t);
 
 extern int qla24xx_abort_command(scsi_qla_host_t *, srb_t *);
-extern int qla24xx_abort_target(fc_port_t *);
+extern int qla24xx_abort_target(struct fc_port *, unsigned int);
+extern int qla24xx_lun_reset(struct fc_port *, unsigned int);
 
 extern int
 qla2x00_set_serdes_params(scsi_qla_host_t *, uint16_t, uint16_t, uint16_t);
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index b25c15a..c1af56d 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -784,35 +784,20 @@ qla2x00_abort_command(scsi_qla_host_t *ha, srb_t *sp)
 	return rval;
 }
 
-/*
- * qla2x00_abort_target
- *	Issue abort target mailbox command.
- *
- * Input:
- *	ha = adapter block pointer.
- *
- * Returns:
- *	qla2x00 local function return status code.
- *
- * Context:
- *	Kernel context.
- */
 int
-qla2x00_abort_target(fc_port_t *fcport)
+qla2x00_abort_target(struct fc_port *fcport, unsigned int l)
 {
-	int        rval;
+	int rval, rval2;
 	mbx_cmd_t  mc;
 	mbx_cmd_t  *mcp = &mc;
 	scsi_qla_host_t *ha;
 
-	if (fcport == NULL)
-		return 0;
-
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, fcport->ha->host_no));
 
+	l = l;
 	ha = fcport->ha;
 	mcp->mb[0] = MBC_ABORT_TARGET;
-	mcp->out_mb = MBX_2|MBX_1|MBX_0;
+	mcp->out_mb = MBX_9|MBX_2|MBX_1|MBX_0;
 	if (HAS_EXTENDED_IDS(ha)) {
 		mcp->mb[1] = fcport->loop_id;
 		mcp->mb[10] = 0;
@@ -821,22 +806,66 @@ qla2x00_abort_target(fc_port_t *fcport)
 		mcp->mb[1] = fcport->loop_id << 8;
 	}
 	mcp->mb[2] = ha->loop_reset_delay;
+	mcp->mb[9] = ha->vp_idx;
 
 	mcp->in_mb = MBX_0;
 	mcp->tov = 30;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
+		    ha->host_no, rval));
+	}
+
+	/* Issue marker IOCB. */
+	rval2 = qla2x00_marker(ha, fcport->loop_id, 0, MK_SYNC_ID);
+	if (rval2 != QLA_SUCCESS) {
+		DEBUG2_3_11(printk("%s(%ld): failed to issue Marker IOCB "
+		    "(%x).\n", __func__, ha->host_no, rval2));
+	} else {
+		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+	}
+
+	return rval;
+}
+
+int
+qla2x00_lun_reset(struct fc_port *fcport, unsigned int l)
+{
+	int rval, rval2;
+	mbx_cmd_t  mc;
+	mbx_cmd_t  *mcp = &mc;
+	scsi_qla_host_t *ha;
+
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, fcport->ha->host_no));
 
-	/* Issue marker command. */
-	ha->marker_needed = 1;
+	ha = fcport->ha;
+	mcp->mb[0] = MBC_LUN_RESET;
+	mcp->out_mb = MBX_9|MBX_3|MBX_2|MBX_1|MBX_0;
+	if (HAS_EXTENDED_IDS(ha))
+		mcp->mb[1] = fcport->loop_id;
+	else
+		mcp->mb[1] = fcport->loop_id << 8;
+	mcp->mb[2] = l;
+	mcp->mb[3] = 0;
+	mcp->mb[9] = ha->vp_idx;
 
+	mcp->in_mb = MBX_0;
+	mcp->tov = 30;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(ha, mcp);
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("qla2x00_abort_target(%ld): failed=%x.\n",
+		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
 		    ha->host_no, rval));
+	}
+
+	/* Issue marker IOCB. */
+	rval2 = qla2x00_marker(ha, fcport->loop_id, l, MK_SYNC_ID_LUN);
+	if (rval2 != QLA_SUCCESS) {
+		DEBUG2_3_11(printk("%s(%ld): failed to issue Marker IOCB "
+		    "(%x).\n", __func__, ha->host_no, rval2));
 	} else {
-		/*EMPTY*/
-		DEBUG11(printk("qla2x00_abort_target(%ld): done.\n",
-		    ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
 	}
 
 	return rval;
@@ -2186,17 +2215,15 @@ struct tsk_mgmt_cmd {
 	} p;
 };
 
-int
-qla24xx_abort_target(fc_port_t *fcport)
+static int
+__qla24xx_issue_tmf(char *name, uint32_t type, struct fc_port *fcport,
+    unsigned int l)
 {
-	int		rval;
+	int		rval, rval2;
 	struct tsk_mgmt_cmd *tsk;
 	dma_addr_t	tsk_dma;
 	scsi_qla_host_t *ha, *pha;
 
-	if (fcport == NULL)
-		return 0;
-
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, fcport->ha->host_no));
 
 	ha = fcport->ha;
@@ -2213,47 +2240,61 @@ qla24xx_abort_target(fc_port_t *fcport)
 	tsk->p.tsk.entry_count = 1;
 	tsk->p.tsk.nport_handle = cpu_to_le16(fcport->loop_id);
 	tsk->p.tsk.timeout = cpu_to_le16(ha->r_a_tov / 10 * 2);
-	tsk->p.tsk.control_flags = __constant_cpu_to_le32(TCF_TARGET_RESET);
+	tsk->p.tsk.control_flags = cpu_to_le32(type);
 	tsk->p.tsk.port_id[0] = fcport->d_id.b.al_pa;
 	tsk->p.tsk.port_id[1] = fcport->d_id.b.area;
 	tsk->p.tsk.port_id[2] = fcport->d_id.b.domain;
 	tsk->p.tsk.vp_index = fcport->vp_idx;
+	if (type == TCF_LUN_RESET) {
+		int_to_scsilun(l, &tsk->p.tsk.lun);
+		host_to_fcp_swap((uint8_t *)&tsk->p.tsk.lun,
+		    sizeof(tsk->p.tsk.lun));
+	}
 
 	rval = qla2x00_issue_iocb(ha, tsk, tsk_dma, 0);
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed to issue Target Reset IOCB "
-		    "(%x).\n", __func__, ha->host_no, rval));
-		goto atarget_done;
+		DEBUG2_3_11(printk("%s(%ld): failed to issue %s Reset IOCB "
+		    "(%x).\n", __func__, ha->host_no, name, rval));
 	} else if (tsk->p.sts.entry_status != 0) {
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
 		    "-- error status (%x).\n", __func__, ha->host_no,
 		    tsk->p.sts.entry_status));
 		rval = QLA_FUNCTION_FAILED;
-		goto atarget_done;
 	} else if (tsk->p.sts.comp_status !=
 	    __constant_cpu_to_le16(CS_COMPLETE)) {
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
 		    "-- completion status (%x).\n", __func__,
 		    ha->host_no, le16_to_cpu(tsk->p.sts.comp_status)));
 		rval = QLA_FUNCTION_FAILED;
-		goto atarget_done;
 	}
 
 	/* Issue marker IOCB. */
-	rval = qla2x00_marker(ha, fcport->loop_id, 0, MK_SYNC_ID);
-	if (rval != QLA_SUCCESS) {
+	rval2 = qla2x00_marker(ha, fcport->loop_id, l,
+	    type == TCF_LUN_RESET ? MK_SYNC_ID_LUN: MK_SYNC_ID);
+	if (rval2 != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed to issue Marker IOCB "
-		    "(%x).\n", __func__, ha->host_no, rval));
+		    "(%x).\n", __func__, ha->host_no, rval2));
 	} else {
 		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
 	}
 
-atarget_done:
 	dma_pool_free(pha->s_dma_pool, tsk, tsk_dma);
 
 	return rval;
 }
 
+int
+qla24xx_abort_target(struct fc_port *fcport, unsigned int l)
+{
+	return __qla24xx_issue_tmf("Target", TCF_TARGET_RESET, fcport, l);
+}
+
+int
+qla24xx_lun_reset(struct fc_port *fcport, unsigned int l)
+{
+	return __qla24xx_issue_tmf("Lun", TCF_LUN_RESET, fcport, l);
+}
+
 #if 0
 
 int
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index ba7d2ca..5cddc50 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -100,6 +100,7 @@ static int qla24xx_queuecommand(struct scsi_cmnd *cmd,
 		void (*fn)(struct scsi_cmnd *));
 static int qla2xxx_eh_abort(struct scsi_cmnd *);
 static int qla2xxx_eh_device_reset(struct scsi_cmnd *);
+static int qla2xxx_eh_target_reset(struct scsi_cmnd *);
 static int qla2xxx_eh_bus_reset(struct scsi_cmnd *);
 static int qla2xxx_eh_host_reset(struct scsi_cmnd *);
 
@@ -113,6 +114,7 @@ static struct scsi_host_template qla2x00_driver_template = {
 
 	.eh_abort_handler	= qla2xxx_eh_abort,
 	.eh_device_reset_handler = qla2xxx_eh_device_reset,
+	.eh_target_reset_handler = qla2xxx_eh_target_reset,
 	.eh_bus_reset_handler	= qla2xxx_eh_bus_reset,
 	.eh_host_reset_handler	= qla2xxx_eh_host_reset,
 
@@ -144,6 +146,7 @@ struct scsi_host_template qla24xx_driver_template = {
 
 	.eh_abort_handler	= qla2xxx_eh_abort,
 	.eh_device_reset_handler = qla2xxx_eh_device_reset,
+	.eh_target_reset_handler = qla2xxx_eh_target_reset,
 	.eh_bus_reset_handler	= qla2xxx_eh_bus_reset,
 	.eh_host_reset_handler	= qla2xxx_eh_host_reset,
 
@@ -566,8 +569,6 @@ qla2x00_wait_for_hba_online(scsi_qla_host_t *ha)
 	else
 		return_status = QLA_FUNCTION_FAILED;
 
-	DEBUG2(printk("%s return_status=%d\n",__func__,return_status));
-
 	return (return_status);
 }
 
@@ -714,181 +715,122 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	return ret;
 }
 
-/**************************************************************************
-* qla2x00_eh_wait_for_pending_target_commands
-*
-* Description:
-*    Waits for all the commands to come back from the specified target.
-*
-* Input:
-*    ha - pointer to scsi_qla_host structure.
-*    t  - target
-* Returns:
-*    Either SUCCESS or FAILED.
-*
-* Note:
-**************************************************************************/
+enum nexus_wait_type {
+	WAIT_HOST = 0,
+	WAIT_TARGET,
+	WAIT_LUN,
+};
+
 static int
-qla2x00_eh_wait_for_pending_target_commands(scsi_qla_host_t *ha, unsigned int t)
+qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *ha, unsigned int t,
+    unsigned int l, enum nexus_wait_type type)
 {
-	int	cnt;
-	int	status;
-	srb_t		*sp;
-	struct scsi_cmnd *cmd;
+	int cnt, match, status;
+	srb_t *sp;
 	unsigned long flags;
 	scsi_qla_host_t *pha = to_qla_parent(ha);
 
-	status = 0;
-
-	/*
-	 * Waiting for all commands for the designated target in the active
-	 * array
-	 */
-	for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
-		spin_lock_irqsave(&pha->hardware_lock, flags);
+	status = QLA_SUCCESS;
+	spin_lock_irqsave(&pha->hardware_lock, flags);
+	for (cnt = 1; status == QLA_SUCCESS && cnt < MAX_OUTSTANDING_COMMANDS;
+	    cnt++) {
 		sp = pha->outstanding_cmds[cnt];
-		if (sp) {
-			cmd = sp->cmd;
-			spin_unlock_irqrestore(&pha->hardware_lock, flags);
-			if (cmd->device->id == t &&
-			    ha->vp_idx == sp->ha->vp_idx) {
-				if (!qla2x00_eh_wait_on_command(ha, cmd)) {
-					status = 1;
-					break;
-				}
-			}
-		} else {
-			spin_unlock_irqrestore(&pha->hardware_lock, flags);
+		if (!sp)
+			continue;
+		if (ha->vp_idx != sp->ha->vp_idx)
+			continue;
+		match = 0;
+		switch (type) {
+		case WAIT_HOST:
+			match = 1;
+			break;
+		case WAIT_TARGET:
+			match = sp->cmd->device->id == t;
+			break;
+		case WAIT_LUN:
+			match = (sp->cmd->device->id == t &&
+			    sp->cmd->device->lun == l);
+			break;
 		}
+		if (!match)
+			continue;
+
+		spin_unlock_irqrestore(&pha->hardware_lock, flags);
+		status = qla2x00_eh_wait_on_command(ha, sp->cmd);
+		spin_lock_irqsave(&pha->hardware_lock, flags);
 	}
-	return (status);
+	spin_unlock_irqrestore(&pha->hardware_lock, flags);
+
+	return status;
 }
 
+static char *reset_errors[] = {
+	"HBA not online",
+	"HBA not ready",
+	"Task management failed",
+	"Waiting for command completions",
+};
 
-/**************************************************************************
-* qla2xxx_eh_device_reset
-*
-* Description:
-*    The device reset function will reset the target and abort any
-*    executing commands.
-*
-*    NOTE: The use of SP is undefined within this context.  Do *NOT*
-*          attempt to use this value, even if you determine it is
-*          non-null.
-*
-* Input:
-*    cmd = Linux SCSI command packet of the command that cause the
-*          bus device reset.
-*
-* Returns:
-*    SUCCESS/FAILURE (defined as macro in scsi.h).
-*
-**************************************************************************/
 static int
-qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
+__qla2xxx_eh_generic_reset(char *name, enum nexus_wait_type type,
+    struct scsi_cmnd *cmd, int (*do_reset)(struct fc_port *, unsigned int))
 {
 	scsi_qla_host_t *ha = shost_priv(cmd->device->host);
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
-	int ret = FAILED;
-	unsigned int id, lun;
-	unsigned long serial;
+	int err;
 
 	qla2x00_block_error_handler(cmd);
 
-	id = cmd->device->id;
-	lun = cmd->device->lun;
-	serial = cmd->serial_number;
-
 	if (!fcport)
-		return ret;
+		return FAILED;
 
-	qla_printk(KERN_INFO, ha,
-	    "scsi(%ld:%d:%d): DEVICE RESET ISSUED.\n", ha->host_no, id, lun);
+	qla_printk(KERN_INFO, ha, "scsi(%ld:%d:%d): %s RESET ISSUED.\n",
+	    ha->host_no, cmd->device->id, cmd->device->lun, name);
 
+	err = 0;
 	if (qla2x00_wait_for_hba_online(ha) != QLA_SUCCESS)
-		goto eh_dev_reset_done;
-
-	if (qla2x00_wait_for_loop_ready(ha) == QLA_SUCCESS) {
-		if (ha->isp_ops->abort_target(fcport) == 0)
-			ret = SUCCESS;
-	} else {
-		DEBUG2(printk(KERN_INFO
-		    "%s failed: loop not ready\n",__func__));
-	}
-
-	if (ret == FAILED) {
-		DEBUG3(printk("%s(%ld): device reset failed\n",
-		    __func__, ha->host_no));
-		qla_printk(KERN_INFO, ha, "%s: device reset failed\n",
-		    __func__);
+		goto eh_reset_failed;
+	err = 1;
+	if (qla2x00_wait_for_loop_ready(ha) != QLA_SUCCESS)
+		goto eh_reset_failed;
+	err = 2;
+	if (do_reset(fcport, cmd->device->lun) != QLA_SUCCESS)
+		goto eh_reset_failed;
+	err = 3;
+	if (qla2x00_eh_wait_for_pending_commands(ha, cmd->device->id,
+	    cmd->device->lun, type) != QLA_SUCCESS)
+		goto eh_reset_failed;
+
+	qla_printk(KERN_INFO, ha, "scsi(%ld:%d:%d): %s RESET SUCCEEDED.\n",
+	    ha->host_no, cmd->device->id, cmd->device->lun, name);
+
+	return SUCCESS;
+
+ eh_reset_failed:
+	qla_printk(KERN_INFO, ha, "scsi(%ld:%d:%d): %s RESET FAILED: %s.\n",
+	    ha->host_no, cmd->device->id, cmd->device->lun, name,
+	    reset_errors[err]);
+	return FAILED;
+}
 
-		goto eh_dev_reset_done;
-	}
+static int
+qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
+{
+	scsi_qla_host_t *ha = shost_priv(cmd->device->host);
 
-	/* Flush outstanding commands. */
-	if (qla2x00_eh_wait_for_pending_target_commands(ha, id))
-		ret = FAILED;
-	if (ret == FAILED) {
-		DEBUG3(printk("%s(%ld): failed while waiting for commands\n",
-		    __func__, ha->host_no));
-		qla_printk(KERN_INFO, ha,
-		    "%s: failed while waiting for commands\n", __func__);
-	} else
-		qla_printk(KERN_INFO, ha,
-		    "scsi(%ld:%d:%d): DEVICE RESET SUCCEEDED.\n", ha->host_no,
-		    id, lun);
- eh_dev_reset_done:
-	return ret;
+	return __qla2xxx_eh_generic_reset("DEVICE", WAIT_LUN, cmd,
+	    ha->isp_ops->lun_reset);
 }
 
-/**************************************************************************
-* qla2x00_eh_wait_for_pending_commands
-*
-* Description:
-*    Waits for all the commands to come back from the specified host.
-*
-* Input:
-*    ha - pointer to scsi_qla_host structure.
-*
-* Returns:
-*    1 : SUCCESS
-*    0 : FAILED
-*
-* Note:
-**************************************************************************/
 static int
-qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *ha)
+qla2xxx_eh_target_reset(struct scsi_cmnd *cmd)
 {
-	int	cnt;
-	int	status;
-	srb_t		*sp;
-	struct scsi_cmnd *cmd;
-	unsigned long flags;
-
-	status = 1;
+	scsi_qla_host_t *ha = shost_priv(cmd->device->host);
 
-	/*
-	 * Waiting for all commands for the designated target in the active
-	 * array
-	 */
-	for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
-		spin_lock_irqsave(&ha->hardware_lock, flags);
-		sp = ha->outstanding_cmds[cnt];
-		if (sp) {
-			cmd = sp->cmd;
-			spin_unlock_irqrestore(&ha->hardware_lock, flags);
-			status = qla2x00_eh_wait_on_command(ha, cmd);
-			if (status == 0)
-				break;
-		}
-		else {
-			spin_unlock_irqrestore(&ha->hardware_lock, flags);
-		}
-	}
-	return (status);
+	return __qla2xxx_eh_generic_reset("TARGET", WAIT_TARGET, cmd,
+	    ha->isp_ops->target_reset);
 }
 
-
 /**************************************************************************
 * qla2xxx_eh_bus_reset
 *
@@ -939,7 +881,8 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 		goto eh_bus_reset_done;
 
 	/* Flush outstanding commands. */
-	if (!qla2x00_eh_wait_for_pending_commands(pha))
+	if (qla2x00_eh_wait_for_pending_commands(pha, 0, 0, WAIT_HOST) !=
+	    QLA_SUCCESS)
 		ret = FAILED;
 
 eh_bus_reset_done:
@@ -1010,7 +953,8 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 	clear_bit(ABORT_ISP_ACTIVE, &pha->dpc_flags);
 
 	/* Waiting for our command in done_queue to be returned to OS.*/
-	if (qla2x00_eh_wait_for_pending_commands(pha))
+	if (qla2x00_eh_wait_for_pending_commands(pha, 0, 0, WAIT_HOST) ==
+	    QLA_SUCCESS)
 		ret = SUCCESS;
 
 	if (ha->parent)
@@ -1066,7 +1010,7 @@ qla2x00_loop_reset(scsi_qla_host_t *ha)
 			if (fcport->port_type != FCT_TARGET)
 				continue;
 
-			ret = ha->isp_ops->abort_target(fcport);
+			ret = ha->isp_ops->target_reset(fcport, 0);
 			if (ret != QLA_SUCCESS) {
 				DEBUG2_3(printk("%s(%ld): bus_reset failed: "
 				    "target_reset=%d d_id=%x.\n", __func__,
@@ -1258,7 +1202,8 @@ static struct isp_operations qla2100_isp_ops = {
 	.enable_intrs		= qla2x00_enable_intrs,
 	.disable_intrs		= qla2x00_disable_intrs,
 	.abort_command		= qla2x00_abort_command,
-	.abort_target		= qla2x00_abort_target,
+	.target_reset		= qla2x00_abort_target,
+	.lun_reset		= qla2x00_lun_reset,
 	.fabric_login		= qla2x00_login_fabric,
 	.fabric_logout		= qla2x00_fabric_logout,
 	.calc_req_entries	= qla2x00_calc_iocbs_32,
@@ -1291,7 +1236,8 @@ static struct isp_operations qla2300_isp_ops = {
 	.enable_intrs		= qla2x00_enable_intrs,
 	.disable_intrs		= qla2x00_disable_intrs,
 	.abort_command		= qla2x00_abort_command,
-	.abort_target		= qla2x00_abort_target,
+	.target_reset		= qla2x00_abort_target,
+	.lun_reset		= qla2x00_lun_reset,
 	.fabric_login		= qla2x00_login_fabric,
 	.fabric_logout		= qla2x00_fabric_logout,
 	.calc_req_entries	= qla2x00_calc_iocbs_32,
@@ -1324,7 +1270,8 @@ static struct isp_operations qla24xx_isp_ops = {
 	.enable_intrs		= qla24xx_enable_intrs,
 	.disable_intrs		= qla24xx_disable_intrs,
 	.abort_command		= qla24xx_abort_command,
-	.abort_target		= qla24xx_abort_target,
+	.target_reset		= qla24xx_abort_target,
+	.lun_reset		= qla24xx_lun_reset,
 	.fabric_login		= qla24xx_login_fabric,
 	.fabric_logout		= qla24xx_fabric_logout,
 	.calc_req_entries	= NULL,
@@ -1357,7 +1304,8 @@ static struct isp_operations qla25xx_isp_ops = {
 	.enable_intrs		= qla24xx_enable_intrs,
 	.disable_intrs		= qla24xx_disable_intrs,
 	.abort_command		= qla24xx_abort_command,
-	.abort_target		= qla24xx_abort_target,
+	.target_reset		= qla24xx_abort_target,
+	.lun_reset		= qla24xx_lun_reset,
 	.fabric_login		= qla24xx_login_fabric,
 	.fabric_logout		= qla24xx_fabric_logout,
 	.calc_req_entries	= NULL,
-- 
1.5.5.rc2

