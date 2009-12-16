From: giridhar.malavali@qlogic.com
Subject: [PATCH 3/5] qla2xxx: Extend base EEH support in qla2xxx.
Date: Tue, 15 Dec 2009 21:29:46 -0800
Message-ID: <1260941388-548-4-git-send-email-giridhar.malavali@qlogic.com>
References: <1260941388-548-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:57219 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1752304AbZLPF3v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Dec 2009 00:29:51 -0500
In-Reply-To: <1260941388-548-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   32 +++++++++++++--
 drivers/scsi/qla2xxx/qla_dbg.h  |    9 ++++-
 drivers/scsi/qla2xxx/qla_def.h  |    2 +
 drivers/scsi/qla2xxx/qla_init.c |   20 +++++++++
 drivers/scsi/qla2xxx/qla_isr.c  |    9 +++-
 drivers/scsi/qla2xxx/qla_mbx.c  |   31 +++++++++++++--
 drivers/scsi/qla2xxx/qla_os.c   |   83 +++++++++++++++++++++++++++++++++++----
 7 files changed, 165 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 21e2bc4..3a9f5b2 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -232,6 +232,9 @@ qla2x00_sysfs_write_optrom_ctl(struct kobject *kobj,
 	if (off)
 		return 0;
 
+	if (unlikely(pci_channel_offline(ha->pdev)))
+		return 0;
+
 	if (sscanf(buf, "%d:%x:%x", &val, &start, &size) < 1)
 		return -EINVAL;
 	if (start > ha->optrom_size)
@@ -379,6 +382,9 @@ qla2x00_sysfs_read_vpd(struct kobject *kobj,
 	    struct device, kobj)));
 	struct qla_hw_data *ha = vha->hw;
 
+	if (unlikely(pci_channel_offline(ha->pdev)))
+		return 0;
+
 	if (!capable(CAP_SYS_ADMIN))
 		return 0;
 
@@ -398,6 +404,9 @@ qla2x00_sysfs_write_vpd(struct kobject *kobj,
 	struct qla_hw_data *ha = vha->hw;
 	uint8_t *tmp_data;
 
+	if (unlikely(pci_channel_offline(ha->pdev)))
+		return 0;
+
 	if (!capable(CAP_SYS_ADMIN) || off != 0 || count != ha->vpd_size ||
 	    !ha->isp_ops->write_nvram)
 		return 0;
@@ -1238,10 +1247,11 @@ qla2x00_fw_state_show(struct device *dev, struct device_attribute *attr,
     char *buf)
 {
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
-	int rval;
+	int rval = QLA_FUNCTION_FAILED;
 	uint16_t state[5];
 
-	rval = qla2x00_get_firmware_state(vha, state);
+	if (!vha->hw->flags.eeh_busy)
+		rval = qla2x00_get_firmware_state(vha, state);
 	if (rval != QLA_SUCCESS)
 		memset(state, -1, sizeof(state));
 
@@ -1452,10 +1462,13 @@ qla2x00_dev_loss_tmo_callbk(struct fc_rport *rport)
 	if (!fcport)
 		return;
 
-	if (unlikely(pci_channel_offline(fcport->vha->hw->pdev)))
+	if (test_bit(ABORT_ISP_ACTIVE, &fcport->vha->dpc_flags))
+		return;
+
+	if (unlikely(pci_channel_offline(fcport->vha->hw->pdev))) {
 		qla2x00_abort_all_cmds(fcport->vha, DID_NO_CONNECT << 16);
-	else
-		qla2x00_abort_fcport_cmds(fcport);
+		return;
+	}
 
 	/*
 	 * Transport has effectively 'deleted' the rport, clear
@@ -1475,6 +1488,9 @@ qla2x00_terminate_rport_io(struct fc_rport *rport)
 	if (!fcport)
 		return;
 
+	if (test_bit(ABORT_ISP_ACTIVE, &fcport->vha->dpc_flags))
+		return;
+
 	if (unlikely(pci_channel_offline(fcport->vha->hw->pdev))) {
 		qla2x00_abort_all_cmds(fcport->vha, DID_NO_CONNECT << 16);
 		return;
@@ -1515,6 +1531,12 @@ qla2x00_get_fc_host_stats(struct Scsi_Host *shost)
 	pfc_host_stat = &ha->fc_host_stat;
 	memset(pfc_host_stat, -1, sizeof(struct fc_host_statistics));
 
+	if (test_bit(UNLOADING, &vha->dpc_flags))
+		goto done;
+
+	if (unlikely(pci_channel_offline(ha->pdev)))
+		goto done;
+
 	stats = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &stats_dma);
 	if (stats == NULL) {
 		DEBUG2_3_11(printk("%s(%ld): Failed to allocate memory.\n",
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index f660dd7..d6d9c86 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -26,7 +26,7 @@
 /* #define QL_DEBUG_LEVEL_14 */ /* Output RSCN trace msgs */
 /* #define QL_DEBUG_LEVEL_15 */ /* Output NPIV trace msgs */
 /* #define QL_DEBUG_LEVEL_16 */ /* Output ISP84XX trace msgs */
-/* #define QL_DEBUG_LEVEL_17 */ /* Output MULTI-Q trace messages */
+/* #define QL_DEBUG_LEVEL_17 */ /* Output EEH trace messages */
 
 /*
 * Macros use for debugging the driver.
@@ -132,6 +132,13 @@
 #else
 #define DEBUG16(x)	do {} while (0)
 #endif
+
+#if defined(QL_DEBUG_LEVEL_17)
+#define DEBUG17(x)	do {x;} while (0)
+#else
+#define DEBUG17(x)	do {} while (0)
+#endif
+
 /*
  * Firmware Dump structure definition
  */
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 384afda..608e675 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2256,11 +2256,13 @@ struct qla_hw_data {
 		uint32_t	disable_serdes		:1;
 		uint32_t	gpsc_supported		:1;
 		uint32_t	npiv_supported		:1;
+		uint32_t	pci_channel_io_perm_failure	:1;
 		uint32_t	fce_enabled		:1;
 		uint32_t	fac_supported		:1;
 		uint32_t	chip_reset_done		:1;
 		uint32_t	port0			:1;
 		uint32_t	running_gold_fw		:1;
+		uint32_t	eeh_busy		:1;
 		uint32_t	cpu_affinity_enabled	:1;
 		uint32_t	disable_msix_handshake	:1;
 	} flags;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 0f7ea6c..b4a0eac 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -269,6 +269,8 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 	vha->flags.online = 0;
 	ha->flags.chip_reset_done = 0;
 	vha->flags.reset_active = 0;
+	ha->flags.pci_channel_io_perm_failure = 0;
+	ha->flags.eeh_busy = 0;
 	atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
 	atomic_set(&vha->loop_state, LOOP_DOWN);
 	vha->device_flags = DFLG_NO_CABLE;
@@ -581,6 +583,9 @@ qla2x00_reset_chip(scsi_qla_host_t *vha)
 	uint32_t	cnt;
 	uint16_t	cmd;
 
+	if (unlikely(pci_channel_offline(ha->pdev)))
+		return;
+
 	ha->isp_ops->disable_intrs(ha);
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -786,6 +791,12 @@ void
 qla24xx_reset_chip(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
+
+	if (pci_channel_offline(ha->pdev) &&
+	    ha->flags.pci_channel_io_perm_failure) {
+		return;
+	}
+
 	ha->isp_ops->disable_intrs(ha);
 
 	/* Perform RISC reset. */
@@ -3562,6 +3573,13 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 		/* Requeue all commands in outstanding command list. */
 		qla2x00_abort_all_cmds(vha, DID_RESET << 16);
 
+		if (unlikely(pci_channel_offline(ha->pdev) &&
+		    ha->flags.pci_channel_io_perm_failure)) {
+			clear_bit(ISP_ABORT_RETRY, &vha->dpc_flags);
+			status = 0;
+			return status;
+		}
+
 		ha->isp_ops->get_flash_version(vha, req->ring);
 
 		ha->isp_ops->nvram_config(vha);
@@ -4460,6 +4478,8 @@ qla2x00_try_to_stop_firmware(scsi_qla_host_t *vha)
 	int ret, retries;
 	struct qla_hw_data *ha = vha->hw;
 
+	if (ha->flags.pci_channel_io_perm_failure)
+		return;
 	if (!IS_FWI2_CAPABLE(ha))
 		return;
 	if (!ha->fw_major_version)
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 1692a88..ffd0efd 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -152,7 +152,7 @@ qla2300_intr_handler(int irq, void *dev_id)
 	for (iter = 50; iter--; ) {
 		stat = RD_REG_DWORD(&reg->u.isp2300.host_status);
 		if (stat & HSR_RISC_PAUSED) {
-			if (pci_channel_offline(ha->pdev))
+			if (unlikely(pci_channel_offline(ha->pdev)))
 				break;
 
 			hccr = RD_REG_WORD(&reg->hccr);
@@ -1846,12 +1846,15 @@ qla24xx_intr_handler(int irq, void *dev_id)
 	reg = &ha->iobase->isp24;
 	status = 0;
 
+	if (unlikely(pci_channel_offline(ha->pdev)))
+		return IRQ_HANDLED;
+
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	vha = pci_get_drvdata(ha->pdev);
 	for (iter = 50; iter--; ) {
 		stat = RD_REG_DWORD(&reg->host_status);
 		if (stat & HSRX_RISC_PAUSED) {
-			if (pci_channel_offline(ha->pdev))
+			if (unlikely(pci_channel_offline(ha->pdev)))
 				break;
 
 			hccr = RD_REG_DWORD(&reg->hccr);
@@ -1992,7 +1995,7 @@ qla24xx_msix_default(int irq, void *dev_id)
 	do {
 		stat = RD_REG_DWORD(&reg->host_status);
 		if (stat & HSRX_RISC_PAUSED) {
-			if (pci_channel_offline(ha->pdev))
+			if (unlikely(pci_channel_offline(ha->pdev)))
 				break;
 
 			hccr = RD_REG_DWORD(&reg->hccr);
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index e91f3d8..056e4d4 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -56,6 +56,12 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, base_vha->host_no));
 
+	if (ha->flags.pci_channel_io_perm_failure) {
+		DEBUG(printk("%s(%ld): Perm failure on EEH, timeout MBX "
+			     "Exiting.\n", __func__, vha->host_no));
+		return QLA_FUNCTION_TIMEOUT;
+	}
+
 	/*
 	 * Wait for active mailbox commands to finish by waiting at most tov
 	 * seconds. This is to serialize actual issuing of mailbox cmds during
@@ -154,10 +160,14 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 			/* Check for pending interrupts. */
 			qla2x00_poll(ha->rsp_q_map[0]);
 
-			if (command != MBC_LOAD_RISC_RAM_EXTENDED &&
-			    !ha->flags.mbox_int)
+			if (!ha->flags.mbox_int &&
+			    !(IS_QLA2200(ha) &&
+			    command == MBC_LOAD_RISC_RAM_EXTENDED))
 				msleep(10);
 		} /* while */
+		DEBUG17(qla_printk(KERN_WARNING, ha,
+			"Waited %d sec\n",
+			(uint)((jiffies - (wait_time - (mcp->tov * HZ)))/HZ)));
 	}
 
 	/* Check whether we timed out */
@@ -227,7 +237,8 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 
 	if (rval == QLA_FUNCTION_TIMEOUT &&
 	    mcp->mb[0] != MBC_GEN_SYSTEM_ERROR) {
-		if (!io_lock_on || (mcp->flags & IOCTL_CMD)) {
+		if (!io_lock_on || (mcp->flags & IOCTL_CMD) ||
+		    ha->flags.eeh_busy) {
 			/* not in dpc. schedule it for dpc to take over. */
 			DEBUG(printk("%s(%ld): timeout schedule "
 			"isp_abort_needed.\n", __func__,
@@ -237,7 +248,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 			base_vha->host_no));
 			qla_printk(KERN_WARNING, ha,
 			    "Mailbox command timeout occurred. Scheduling ISP "
-			    "abort.\n");
+			    "abort. eeh_busy: 0x%x\n", ha->flags.eeh_busy);
 			set_bit(ISP_ABORT_NEEDED, &base_vha->dpc_flags);
 			qla2xxx_wake_dpc(vha);
 		} else if (!abort_active) {
@@ -2530,6 +2541,9 @@ qla2x00_enable_eft_trace(scsi_qla_host_t *vha, dma_addr_t eft_dma,
 	if (!IS_FWI2_CAPABLE(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
+	if (unlikely(pci_channel_offline(vha->hw->pdev)))
+		return QLA_FUNCTION_FAILED;
+
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_TRACE_CONTROL;
@@ -2565,6 +2579,9 @@ qla2x00_disable_eft_trace(scsi_qla_host_t *vha)
 	if (!IS_FWI2_CAPABLE(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
+	if (unlikely(pci_channel_offline(vha->hw->pdev)))
+		return QLA_FUNCTION_FAILED;
+
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_TRACE_CONTROL;
@@ -2595,6 +2612,9 @@ qla2x00_enable_fce_trace(scsi_qla_host_t *vha, dma_addr_t fce_dma,
 	if (!IS_QLA25XX(vha->hw) && !IS_QLA81XX(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
+	if (unlikely(pci_channel_offline(vha->hw->pdev)))
+		return QLA_FUNCTION_FAILED;
+
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_TRACE_CONTROL;
@@ -2639,6 +2659,9 @@ qla2x00_disable_fce_trace(scsi_qla_host_t *vha, uint64_t *wr, uint64_t *rd)
 	if (!IS_FWI2_CAPABLE(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
+	if (unlikely(pci_channel_offline(vha->hw->pdev)))
+		return QLA_FUNCTION_FAILED;
+
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_TRACE_CONTROL;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 2f873d2..1ab3582 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -475,11 +475,11 @@ qla2xxx_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 	srb_t *sp;
 	int rval;
 
-	if (unlikely(pci_channel_offline(ha->pdev))) {
-		if (ha->pdev->error_state == pci_channel_io_frozen)
-			cmd->result = DID_REQUEUE << 16;
-		else
+	if (ha->flags.eeh_busy) {
+		if (ha->flags.pci_channel_io_perm_failure)
 			cmd->result = DID_NO_CONNECT << 16;
+		else
+			cmd->result = DID_REQUEUE << 16;
 		goto qc24_fail_command;
 	}
 
@@ -552,8 +552,15 @@ qla2x00_eh_wait_on_command(struct scsi_cmnd *cmd)
 #define ABORT_POLLING_PERIOD	1000
 #define ABORT_WAIT_ITER		((10 * 1000) / (ABORT_POLLING_PERIOD))
 	unsigned long wait_iter = ABORT_WAIT_ITER;
+	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
+	struct qla_hw_data *ha = vha->hw;
 	int ret = QLA_SUCCESS;
 
+	if (unlikely(pci_channel_offline(ha->pdev)) || ha->flags.eeh_busy) {
+		DEBUG17(qla_printk(KERN_WARNING, ha, "return:eh_wait\n"));
+		return ret;
+	}
+
 	while (CMD_SP(cmd) && wait_iter--) {
 		msleep(ABORT_POLLING_PERIOD);
 	}
@@ -2174,6 +2181,24 @@ qla2x00_free_device(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
 
+	qla2x00_abort_all_cmds(vha, DID_NO_CONNECT << 16);
+
+	/* Disable timer */
+	if (vha->timer_active)
+		qla2x00_stop_timer(vha);
+
+	/* Kill the kernel thread for this host */
+	if (ha->dpc_thread) {
+		struct task_struct *t = ha->dpc_thread;
+
+		/*
+		 * qla2xxx_wake_dpc checks for ->dpc_thread
+		 * so we need to zero it out.
+		 */
+		ha->dpc_thread = NULL;
+		kthread_stop(t);
+	}
+
 	qla25xx_delete_queues(vha);
 
 	if (ha->flags.fce_enabled)
@@ -2185,6 +2210,8 @@ qla2x00_free_device(scsi_qla_host_t *vha)
 	/* Stop currently executing firmware. */
 	qla2x00_try_to_stop_firmware(vha);
 
+	vha->flags.online = 0;
+
 	/* turn-off interrupts on the card */
 	if (ha->interrupts_on)
 		ha->isp_ops->disable_intrs(ha);
@@ -2859,6 +2886,13 @@ qla2x00_do_dpc(void *data)
 		if (!base_vha->flags.init_done)
 			continue;
 
+		if (ha->flags.eeh_busy) {
+			DEBUG17(qla_printk(KERN_WARNING, ha,
+			    "qla2x00_do_dpc: dpc_flags: %lx\n",
+			    base_vha->dpc_flags));
+			continue;
+		}
+
 		DEBUG3(printk("scsi(%ld): DPC handler\n", base_vha->host_no));
 
 		ha->dpc_active = 1;
@@ -3049,8 +3083,13 @@ qla2x00_timer(scsi_qla_host_t *vha)
 	int		index;
 	srb_t		*sp;
 	int		t;
+	uint16_t        w;
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req;
+
+	/* Hardware read to raise pending EEH errors during mailbox waits. */
+	if (!pci_channel_offline(ha->pdev))
+		pci_read_config_word(ha->pdev, PCI_VENDOR_ID, &w);
 	/*
 	 * Ports - Port down timer.
 	 *
@@ -3252,16 +3291,23 @@ qla2x00_release_firmware(void)
 static pci_ers_result_t
 qla2xxx_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 {
-	scsi_qla_host_t *base_vha = pci_get_drvdata(pdev);
+	scsi_qla_host_t *vha = pci_get_drvdata(pdev);
+	struct qla_hw_data *ha = vha->hw;
+
+	DEBUG2(qla_printk(KERN_WARNING, ha, "error_detected:state %x\n",
+	    state));
 
 	switch (state) {
 	case pci_channel_io_normal:
+		ha->flags.eeh_busy = 0;
 		return PCI_ERS_RESULT_CAN_RECOVER;
 	case pci_channel_io_frozen:
+		ha->flags.eeh_busy = 1;
 		pci_disable_device(pdev);
 		return PCI_ERS_RESULT_NEED_RESET;
 	case pci_channel_io_perm_failure:
-		qla2x00_abort_all_cmds(base_vha, DID_NO_CONNECT << 16);
+		ha->flags.pci_channel_io_perm_failure = 1;
+		qla2x00_abort_all_cmds(vha, DID_NO_CONNECT << 16);
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 	return PCI_ERS_RESULT_NEED_RESET;
@@ -3312,6 +3358,8 @@ qla2xxx_pci_slot_reset(struct pci_dev *pdev)
 	struct qla_hw_data *ha = base_vha->hw;
 	int rc;
 
+	DEBUG17(qla_printk(KERN_WARNING, ha, "slot_reset\n"));
+
 	if (ha->mem_only)
 		rc = pci_enable_device_mem(pdev);
 	else
@@ -3320,19 +3368,33 @@ qla2xxx_pci_slot_reset(struct pci_dev *pdev)
 	if (rc) {
 		qla_printk(KERN_WARNING, ha,
 		    "Can't re-enable PCI device after reset.\n");
-
 		return ret;
 	}
-	pci_set_master(pdev);
 
 	if (ha->isp_ops->pci_config(base_vha))
 		return ret;
 
+#ifdef QL_DEBUG_LEVEL_17
+	{
+		uint8_t b;
+		uint32_t i;
+
+		printk("slot_reset_1: ");
+		for (i = 0; i < 256; i++) {
+			pci_read_config_byte(ha->pdev, i, &b);
+			printk("%s%02x", (i%16) ? " " : "\n", b);
+		}
+		printk("\n");
+	}
+#endif
 	set_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
 	if (qla2x00_abort_isp(base_vha) == QLA_SUCCESS)
 		ret =  PCI_ERS_RESULT_RECOVERED;
 	clear_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
 
+	DEBUG17(qla_printk(KERN_WARNING, ha,
+	    "slot_reset-return:ret=%x\n", ret));
+
 	return ret;
 }
 
@@ -3343,12 +3405,17 @@ qla2xxx_pci_resume(struct pci_dev *pdev)
 	struct qla_hw_data *ha = base_vha->hw;
 	int ret;
 
+	DEBUG17(qla_printk(KERN_WARNING, ha, "pci_resume\n"));
+
 	ret = qla2x00_wait_for_hba_online(base_vha);
 	if (ret != QLA_SUCCESS) {
 		qla_printk(KERN_ERR, ha,
 		    "the device failed to resume I/O "
 		    "from slot/link_reset");
 	}
+
+	ha->flags.eeh_busy = 0;
+
 	pci_cleanup_aer_uncorrect_error_status(pdev);
 }
 
-- 
1.6.2.rc1.30.gd43c

