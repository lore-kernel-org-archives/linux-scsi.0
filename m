From: Anirban Chakraborty <anirban@qlogic.com>
Subject: [PATCH 5/5] qla2xxx: Code Refactoring
Date: Wed, 15 Oct 2008 22:47:57 -0700 (PDT)
Message-ID: <alpine.OSX.1.00.0810152235290.24642@ac-mac.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:41949 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbYJPF7j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Oct 2008 01:59:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, James.Smart@emulex.com, linux-scsi@vger.kernel.org
Cc: linux-driver@qlogic.com

Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c  | 1274 ++++++++++++++++++++++------------------
 drivers/scsi/qla2xxx/qla_sup.c |  537 +++++++++--------
 2 files changed, 982 insertions(+), 829 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3433441..22c753b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -183,42 +183,122 @@ struct scsi_transport_template *qla2xxx_transport_vport_template = NULL;
  */
 
 __inline__ void
-qla2x00_start_timer(scsi_qla_host_t *ha, void *func, unsigned long interval)
+qla2x00_start_timer(scsi_qla_host_t *vha, void *func, unsigned long interval)
 {
-	init_timer(&ha->timer);
-	ha->timer.expires = jiffies + interval * HZ;
-	ha->timer.data = (unsigned long)ha;
-	ha->timer.function = (void (*)(unsigned long))func;
-	add_timer(&ha->timer);
-	ha->timer_active = 1;
+	init_timer(&vha->timer);
+	vha->timer.expires = jiffies + interval * HZ;
+	vha->timer.data = (unsigned long)vha;
+	vha->timer.function = (void (*)(unsigned long))func;
+	add_timer(&vha->timer);
+	vha->timer_active = 1;
 }
 
 static inline void
-qla2x00_restart_timer(scsi_qla_host_t *ha, unsigned long interval)
+qla2x00_restart_timer(scsi_qla_host_t *vha, unsigned long interval)
 {
-	mod_timer(&ha->timer, jiffies + interval * HZ);
+	mod_timer(&vha->timer, jiffies + interval * HZ);
 }
 
 static __inline__ void
-qla2x00_stop_timer(scsi_qla_host_t *ha)
+qla2x00_stop_timer(scsi_qla_host_t *vha)
 {
-	del_timer_sync(&ha->timer);
-	ha->timer_active = 0;
+	del_timer_sync(&vha->timer);
+	vha->timer_active = 0;
 }
 
 static int qla2x00_do_dpc(void *data);
 
 static void qla2x00_rst_aen(scsi_qla_host_t *);
 
-static int qla2x00_mem_alloc(scsi_qla_host_t *);
-static void qla2x00_mem_free(scsi_qla_host_t *ha);
-static void qla2x00_sp_free_dma(scsi_qla_host_t *, srb_t *);
+static int qla2x00_mem_alloc(struct qla_hw_data *);
+static void qla2x00_mem_free(struct qla_hw_data *);
+static void qla2x00_sp_free_dma(srb_t *);
 
 /* -------------------------------------------------------------------------- */
+static int
+qla2x00_alloc_que(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len)
+{
+	struct req_que *req = NULL;
+	struct rsp_que *rsp = NULL;
+
+	req = kzalloc(sizeof(struct req_que), GFP_KERNEL);
+	if (!req) {
+		DEBUG(printk("Unable to allocate memory for req\n"));
+		goto fail_req;
+	}
+	ha->req = req;
+	req->length = req_len;
+	req->ring = dma_alloc_coherent(&ha->pdev->dev,
+		(req->length + 1) * sizeof(request_t),
+		&req->dma, GFP_KERNEL);
+	if (!req->ring) {
+		DEBUG(printk("Unable to allocate memory for req_ring\n"));
+		goto fail_req_ring;
+	}
+
+	rsp = kzalloc(sizeof(struct rsp_que), GFP_KERNEL);
+	if (!rsp) {
+		DEBUG(printk("Unable to allocate memory for rsp\n"));
+		goto fail_rsp;
+	}
+	ha->rsp = rsp;
+	rsp->hw = ha;
+	rsp->length = rsp_len;
+
+	rsp->ring = dma_alloc_coherent(&ha->pdev->dev,
+		(rsp->length + 1) * sizeof(response_t),
+		&rsp->dma, GFP_KERNEL);
+	if (!rsp->ring) {
+		DEBUG(printk("Unable to allocate memory for rsp_ring\n"));
+		goto fail_rsp_ring;
+	}
+	return 1;
+
+fail_rsp_ring:
+	kfree(rsp);
+	ha->rsp = NULL;
+fail_rsp:
+	dma_free_coherent(&ha->pdev->dev, (req->length + 1) *
+		sizeof(request_t), req->ring, req->dma);
+	req->ring = NULL;
+	req->dma = 0;
+fail_req_ring:
+	kfree(req);
+	ha->req = NULL;
+fail_req:
+	return 0;
+}
+
+static void
+qla2x00_free_que(struct qla_hw_data *ha)
+{
+	struct req_que *req = ha->req;
+	struct rsp_que *rsp = ha->rsp;
+	if (rsp) {
+		if (rsp->ring)
+			dma_free_coherent(&ha->pdev->dev,
+			(rsp->length + 1) * sizeof(response_t),
+			rsp->ring, rsp->dma);
+
+		kfree(rsp);
+		rsp = NULL;
+	}
+
+	if (req) {
+		if (req->ring)
+			dma_free_coherent(&ha->pdev->dev,
+			(req->length + 1) * sizeof(request_t),
+			req->ring, req->dma);
+
+		kfree(req);
+		req = NULL;
+	}
+}
 
 static char *
-qla2x00_pci_info_str(struct scsi_qla_host *ha, char *str)
+qla2x00_pci_info_str(struct scsi_qla_host *vha, char *str)
 {
+	struct qla_hw_data *ha = vha->hw;
 	static char *pci_bus_modes[] = {
 		"33", "66", "100", "133",
 	};
@@ -240,9 +320,10 @@ qla2x00_pci_info_str(struct scsi_qla_host *ha, char *str)
 }
 
 static char *
-qla24xx_pci_info_str(struct scsi_qla_host *ha, char *str)
+qla24xx_pci_info_str(struct scsi_qla_host *vha, char *str)
 {
 	static char *pci_bus_modes[] = { "33", "66", "100", "133", };
+	struct qla_hw_data *ha = vha->hw;
 	uint32_t pci_bus;
 	int pcie_reg;
 
@@ -290,9 +371,10 @@ qla24xx_pci_info_str(struct scsi_qla_host *ha, char *str)
 }
 
 static char *
-qla2x00_fw_version_str(struct scsi_qla_host *ha, char *str)
+qla2x00_fw_version_str(struct scsi_qla_host *vha, char *str)
 {
 	char un_str[10];
+	struct qla_hw_data *ha = vha->hw;
 
 	sprintf(str, "%d.%02d.%02d ", ha->fw_major_version,
 	    ha->fw_minor_version,
@@ -328,8 +410,9 @@ qla2x00_fw_version_str(struct scsi_qla_host *ha, char *str)
 }
 
 static char *
-qla24xx_fw_version_str(struct scsi_qla_host *ha, char *str)
+qla24xx_fw_version_str(struct scsi_qla_host *vha, char *str)
 {
+	struct qla_hw_data *ha = vha->hw;
 	sprintf(str, "%d.%02d.%02d ", ha->fw_major_version,
 	    ha->fw_minor_version,
 	    ha->fw_subminor_version);
@@ -354,16 +437,17 @@ qla24xx_fw_version_str(struct scsi_qla_host *ha, char *str)
 }
 
 static inline srb_t *
-qla2x00_get_new_sp(scsi_qla_host_t *ha, fc_port_t *fcport,
+qla2x00_get_new_sp(scsi_qla_host_t *vha, fc_port_t *fcport,
     struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 {
 	srb_t *sp;
+	struct qla_hw_data *ha = vha->hw;
 
 	sp = mempool_alloc(ha->srb_mempool, GFP_ATOMIC);
 	if (!sp)
 		return sp;
 
-	sp->ha = ha;
+	sp->vha = vha;
 	sp->fcport = fcport;
 	sp->cmd = cmd;
 	sp->flags = 0;
@@ -376,9 +460,10 @@ qla2x00_get_new_sp(scsi_qla_host_t *ha, fc_port_t *fcport,
 static int
 qla2x00_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 {
-	scsi_qla_host_t *ha = shost_priv(cmd->device->host);
+	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
 	struct fc_rport *rport = starget_to_rport(scsi_target(cmd->device));
+	struct qla_hw_data *ha = vha->hw;
 	srb_t *sp;
 	int rval;
 
@@ -401,16 +486,16 @@ qla2x00_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 
 	if (atomic_read(&fcport->state) != FCS_ONLINE) {
 		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
-		    atomic_read(&ha->loop_state) == LOOP_DEAD) {
+		    atomic_read(&vha->loop_state) == LOOP_DEAD) {
 			cmd->result = DID_NO_CONNECT << 16;
 			goto qc_fail_command;
 		}
 		goto qc_host_busy;
 	}
 
-	spin_unlock_irq(ha->host->host_lock);
+	spin_unlock_irq(vha->host->host_lock);
 
-	sp = qla2x00_get_new_sp(ha, fcport, cmd, done);
+	sp = qla2x00_get_new_sp(vha, fcport, cmd, done);
 	if (!sp)
 		goto qc_host_busy_lock;
 
@@ -418,16 +503,16 @@ qla2x00_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 	if (rval != QLA_SUCCESS)
 		goto qc_host_busy_free_sp;
 
-	spin_lock_irq(ha->host->host_lock);
+	spin_lock_irq(vha->host->host_lock);
 
 	return 0;
 
 qc_host_busy_free_sp:
-	qla2x00_sp_free_dma(ha, sp);
+	qla2x00_sp_free_dma(sp);
 	mempool_free(sp, ha->srb_mempool);
 
 qc_host_busy_lock:
-	spin_lock_irq(ha->host->host_lock);
+	spin_lock_irq(vha->host->host_lock);
 
 qc_host_busy:
 	return SCSI_MLQUEUE_HOST_BUSY;
@@ -442,14 +527,15 @@ qc_fail_command:
 static int
 qla24xx_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 {
-	scsi_qla_host_t *ha = shost_priv(cmd->device->host);
+	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
 	struct fc_rport *rport = starget_to_rport(scsi_target(cmd->device));
+	struct qla_hw_data *ha = vha->hw;
+	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 	srb_t *sp;
 	int rval;
-	scsi_qla_host_t *pha = to_qla_parent(ha);
 
-	if (unlikely(pci_channel_offline(pha->pdev))) {
+	if (unlikely(pci_channel_offline(ha->pdev))) {
 		cmd->result = DID_REQUEUE << 16;
 		goto qc24_fail_command;
 	}
@@ -468,33 +554,33 @@ qla24xx_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 
 	if (atomic_read(&fcport->state) != FCS_ONLINE) {
 		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
-		    atomic_read(&pha->loop_state) == LOOP_DEAD) {
+		    atomic_read(&base_vha->loop_state) == LOOP_DEAD) {
 			cmd->result = DID_NO_CONNECT << 16;
 			goto qc24_fail_command;
 		}
 		goto qc24_host_busy;
 	}
 
-	spin_unlock_irq(ha->host->host_lock);
+	spin_unlock_irq(vha->host->host_lock);
 
-	sp = qla2x00_get_new_sp(pha, fcport, cmd, done);
+	sp = qla2x00_get_new_sp(base_vha, fcport, cmd, done);
 	if (!sp)
 		goto qc24_host_busy_lock;
 
-	rval = qla24xx_start_scsi(sp);
+	rval = ha->isp_ops->start_scsi(sp);
 	if (rval != QLA_SUCCESS)
 		goto qc24_host_busy_free_sp;
 
-	spin_lock_irq(ha->host->host_lock);
+	spin_lock_irq(vha->host->host_lock);
 
 	return 0;
 
 qc24_host_busy_free_sp:
-	qla2x00_sp_free_dma(pha, sp);
-	mempool_free(sp, pha->srb_mempool);
+	qla2x00_sp_free_dma(sp);
+	mempool_free(sp, ha->srb_mempool);
 
 qc24_host_busy_lock:
-	spin_lock_irq(ha->host->host_lock);
+	spin_lock_irq(vha->host->host_lock);
 
 qc24_host_busy:
 	return SCSI_MLQUEUE_HOST_BUSY;
@@ -512,17 +598,14 @@ qc24_fail_command:
  *    max time.
  *
  * Input:
- *    ha = actual ha whose done queue will contain the command
- *	      returned by firmware.
  *    cmd = Scsi Command to wait on.
- *    flag = Abort/Reset(Bus or Device Reset)
  *
  * Return:
  *    Not Found : 0
  *    Found : 1
  */
 static int
-qla2x00_eh_wait_on_command(scsi_qla_host_t *ha, struct scsi_cmnd *cmd)
+qla2x00_eh_wait_on_command(struct scsi_cmnd *cmd)
 {
 #define ABORT_POLLING_PERIOD	1000
 #define ABORT_WAIT_ITER		((10 * 1000) / (ABORT_POLLING_PERIOD))
@@ -559,21 +642,22 @@ qla2x00_eh_wait_on_command(scsi_qla_host_t *ha, struct scsi_cmnd *cmd)
  *    Failed  (Adapter is offline/disabled) : 1
  */
 int
-qla2x00_wait_for_hba_online(scsi_qla_host_t *ha)
+qla2x00_wait_for_hba_online(scsi_qla_host_t *vha)
 {
 	int		return_status;
 	unsigned long	wait_online;
-	scsi_qla_host_t *pha = to_qla_parent(ha);
+	struct qla_hw_data *ha = vha->hw;
+	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 
 	wait_online = jiffies + (MAX_LOOP_TIMEOUT * HZ);
-	while (((test_bit(ISP_ABORT_NEEDED, &pha->dpc_flags)) ||
-	    test_bit(ABORT_ISP_ACTIVE, &pha->dpc_flags) ||
-	    test_bit(ISP_ABORT_RETRY, &pha->dpc_flags) ||
-	    pha->dpc_active) && time_before(jiffies, wait_online)) {
+	while (((test_bit(ISP_ABORT_NEEDED, &base_vha->dpc_flags)) ||
+	    test_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags) ||
+	    test_bit(ISP_ABORT_RETRY, &base_vha->dpc_flags) ||
+	    ha->dpc_active) && time_before(jiffies, wait_online)) {
 
 		msleep(1000);
 	}
-	if (pha->flags.online)
+	if (base_vha->flags.online)
 		return_status = QLA_SUCCESS;
 	else
 		return_status = QLA_FUNCTION_FAILED;
@@ -598,19 +682,20 @@ qla2x00_wait_for_hba_online(scsi_qla_host_t *ha)
  *    Failed  (LOOP_NOT_READY) : 1
  */
 static inline int
-qla2x00_wait_for_loop_ready(scsi_qla_host_t *ha)
+qla2x00_wait_for_loop_ready(scsi_qla_host_t *vha)
 {
 	int 	 return_status = QLA_SUCCESS;
 	unsigned long loop_timeout ;
-	scsi_qla_host_t *pha = to_qla_parent(ha);
+	struct qla_hw_data *ha = vha->hw;
+	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 
 	/* wait for 5 min at the max for loop to be ready */
 	loop_timeout = jiffies + (MAX_LOOP_TIMEOUT * HZ);
 
-	while ((!atomic_read(&pha->loop_down_timer) &&
-	    atomic_read(&pha->loop_state) == LOOP_DOWN) ||
-	    atomic_read(&pha->loop_state) != LOOP_READY) {
-		if (atomic_read(&pha->loop_state) == LOOP_DEAD) {
+	while ((!atomic_read(&base_vha->loop_down_timer) &&
+	    atomic_read(&base_vha->loop_state) == LOOP_DOWN) ||
+	    atomic_read(&base_vha->loop_state) != LOOP_READY) {
+		if (atomic_read(&base_vha->loop_state) == LOOP_DEAD) {
 			return_status = QLA_FUNCTION_FAILED;
 			break;
 		}
@@ -629,32 +714,33 @@ qla2x00_abort_fcport_cmds(fc_port_t *fcport)
 	int cnt;
 	unsigned long flags;
 	srb_t *sp;
-	scsi_qla_host_t *ha = fcport->ha;
-	scsi_qla_host_t *pha = to_qla_parent(ha);
+	scsi_qla_host_t *vha = fcport->vha;
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req;
 
-	spin_lock_irqsave(&pha->hardware_lock, flags);
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
-		sp = pha->outstanding_cmds[cnt];
+		sp = req->outstanding_cmds[cnt];
 		if (!sp)
 			continue;
 		if (sp->fcport != fcport)
 			continue;
 
-		spin_unlock_irqrestore(&pha->hardware_lock, flags);
-		if (ha->isp_ops->abort_command(ha, sp)) {
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		if (ha->isp_ops->abort_command(vha, sp)) {
 			DEBUG2(qla_printk(KERN_WARNING, ha,
 			    "Abort failed --  %lx\n", sp->cmd->serial_number));
 		} else {
-			if (qla2x00_eh_wait_on_command(ha, sp->cmd) !=
+			if (qla2x00_eh_wait_on_command(sp->cmd) !=
 			    QLA_SUCCESS)
 				DEBUG2(qla_printk(KERN_WARNING, ha,
 				    "Abort failed while waiting --  %lx\n",
 				    sp->cmd->serial_number));
 
 		}
-		spin_lock_irqsave(&pha->hardware_lock, flags);
+		spin_lock_irqsave(&ha->hardware_lock, flags);
 	}
-	spin_unlock_irqrestore(&pha->hardware_lock, flags);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 
 static void
@@ -692,14 +778,15 @@ qla2x00_block_error_handler(struct scsi_cmnd *cmnd)
 static int
 qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 {
-	scsi_qla_host_t *ha = shost_priv(cmd->device->host);
+	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	srb_t *sp;
 	int ret, i;
 	unsigned int id, lun;
 	unsigned long serial;
 	unsigned long flags;
 	int wait = 0;
-	scsi_qla_host_t *pha = to_qla_parent(ha);
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req;
 
 	qla2x00_block_error_handler(cmd);
 
@@ -713,9 +800,9 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	serial = cmd->serial_number;
 
 	/* Check active list for command command. */
-	spin_lock_irqsave(&pha->hardware_lock, flags);
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (i = 1; i < MAX_OUTSTANDING_COMMANDS; i++) {
-		sp = pha->outstanding_cmds[i];
+		sp = req->outstanding_cmds[i];
 
 		if (sp == NULL)
 			continue;
@@ -724,36 +811,36 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 			continue;
 
 		DEBUG2(printk("%s(%ld): aborting sp %p from RISC. pid=%ld.\n",
-		    __func__, ha->host_no, sp, serial));
+		    __func__, vha->host_no, sp, serial));
 
-		spin_unlock_irqrestore(&pha->hardware_lock, flags);
-		if (ha->isp_ops->abort_command(ha, sp)) {
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		if (ha->isp_ops->abort_command(vha, sp)) {
 			DEBUG2(printk("%s(%ld): abort_command "
-			    "mbx failed.\n", __func__, ha->host_no));
+			    "mbx failed.\n", __func__, vha->host_no));
 		} else {
 			DEBUG3(printk("%s(%ld): abort_command "
-			    "mbx success.\n", __func__, ha->host_no));
+			    "mbx success.\n", __func__, vha->host_no));
 			wait = 1;
 		}
-		spin_lock_irqsave(&pha->hardware_lock, flags);
+		spin_lock_irqsave(&ha->hardware_lock, flags);
 
 		break;
 	}
-	spin_unlock_irqrestore(&pha->hardware_lock, flags);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	/* Wait for the command to be returned. */
 	if (wait) {
-		if (qla2x00_eh_wait_on_command(ha, cmd) != QLA_SUCCESS) {
+		if (qla2x00_eh_wait_on_command(cmd) != QLA_SUCCESS) {
 			qla_printk(KERN_ERR, ha,
 			    "scsi(%ld:%d:%d): Abort handler timed out -- %lx "
-			    "%x.\n", ha->host_no, id, lun, serial, ret);
+			    "%x.\n", vha->host_no, id, lun, serial, ret);
 			ret = FAILED;
 		}
 	}
 
 	qla_printk(KERN_INFO, ha,
 	    "scsi(%ld:%d:%d): Abort command issued -- %d %lx %x.\n",
-	    ha->host_no, id, lun, wait, serial, ret);
+	    vha->host_no, id, lun, wait, serial, ret);
 
 	return ret;
 }
@@ -765,23 +852,24 @@ enum nexus_wait_type {
 };
 
 static int
-qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *ha, unsigned int t,
+qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *vha, unsigned int t,
     unsigned int l, enum nexus_wait_type type)
 {
 	int cnt, match, status;
 	srb_t *sp;
 	unsigned long flags;
-	scsi_qla_host_t *pha = to_qla_parent(ha);
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req;
 
 	status = QLA_SUCCESS;
-	spin_lock_irqsave(&pha->hardware_lock, flags);
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (cnt = 1; status == QLA_SUCCESS && cnt < MAX_OUTSTANDING_COMMANDS;
 	    cnt++) {
-		sp = pha->outstanding_cmds[cnt];
+		sp = req->outstanding_cmds[cnt];
 		if (!sp)
 			continue;
 
-		if (ha->vp_idx != sp->fcport->ha->vp_idx)
+		if (vha->vp_idx != sp->fcport->vha->vp_idx)
 			continue;
 		match = 0;
 		switch (type) {
@@ -799,11 +887,11 @@ qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *ha, unsigned int t,
 		if (!match)
 			continue;
 
-		spin_unlock_irqrestore(&pha->hardware_lock, flags);
-		status = qla2x00_eh_wait_on_command(ha, sp->cmd);
-		spin_lock_irqsave(&pha->hardware_lock, flags);
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		status = qla2x00_eh_wait_on_command(sp->cmd);
+		spin_lock_irqsave(&ha->hardware_lock, flags);
 	}
-	spin_unlock_irqrestore(&pha->hardware_lock, flags);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return status;
 }
@@ -819,7 +907,7 @@ static int
 __qla2xxx_eh_generic_reset(char *name, enum nexus_wait_type type,
     struct scsi_cmnd *cmd, int (*do_reset)(struct fc_port *, unsigned int))
 {
-	scsi_qla_host_t *ha = shost_priv(cmd->device->host);
+	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
 	int err;
 
@@ -828,31 +916,31 @@ __qla2xxx_eh_generic_reset(char *name, enum nexus_wait_type type,
 	if (!fcport)
 		return FAILED;
 
-	qla_printk(KERN_INFO, ha, "scsi(%ld:%d:%d): %s RESET ISSUED.\n",
-	    ha->host_no, cmd->device->id, cmd->device->lun, name);
+	qla_printk(KERN_INFO, vha->hw, "scsi(%ld:%d:%d): %s RESET ISSUED.\n",
+	    vha->host_no, cmd->device->id, cmd->device->lun, name);
 
 	err = 0;
-	if (qla2x00_wait_for_hba_online(ha) != QLA_SUCCESS)
+	if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS)
 		goto eh_reset_failed;
 	err = 1;
-	if (qla2x00_wait_for_loop_ready(ha) != QLA_SUCCESS)
+	if (qla2x00_wait_for_loop_ready(vha) != QLA_SUCCESS)
 		goto eh_reset_failed;
 	err = 2;
 	if (do_reset(fcport, cmd->device->lun) != QLA_SUCCESS)
 		goto eh_reset_failed;
 	err = 3;
-	if (qla2x00_eh_wait_for_pending_commands(ha, cmd->device->id,
+	if (qla2x00_eh_wait_for_pending_commands(vha, cmd->device->id,
 	    cmd->device->lun, type) != QLA_SUCCESS)
 		goto eh_reset_failed;
 
-	qla_printk(KERN_INFO, ha, "scsi(%ld:%d:%d): %s RESET SUCCEEDED.\n",
-	    ha->host_no, cmd->device->id, cmd->device->lun, name);
+	qla_printk(KERN_INFO, vha->hw, "scsi(%ld:%d:%d): %s RESET SUCCEEDED.\n",
+	    vha->host_no, cmd->device->id, cmd->device->lun, name);
 
 	return SUCCESS;
 
  eh_reset_failed:
-	qla_printk(KERN_INFO, ha, "scsi(%ld:%d:%d): %s RESET FAILED: %s.\n",
-	    ha->host_no, cmd->device->id, cmd->device->lun, name,
+	qla_printk(KERN_INFO, vha->hw, "scsi(%ld:%d:%d): %s RESET FAILED: %s.\n"
+	    , vha->host_no, cmd->device->id, cmd->device->lun, name,
 	    reset_errors[err]);
 	return FAILED;
 }
@@ -860,7 +948,8 @@ __qla2xxx_eh_generic_reset(char *name, enum nexus_wait_type type,
 static int
 qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
 {
-	scsi_qla_host_t *ha = shost_priv(cmd->device->host);
+	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
+	struct qla_hw_data *ha = vha->hw;
 
 	return __qla2xxx_eh_generic_reset("DEVICE", WAIT_LUN, cmd,
 	    ha->isp_ops->lun_reset);
@@ -869,7 +958,8 @@ qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
 static int
 qla2xxx_eh_target_reset(struct scsi_cmnd *cmd)
 {
-	scsi_qla_host_t *ha = shost_priv(cmd->device->host);
+	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
+	struct qla_hw_data *ha = vha->hw;
 
 	return __qla2xxx_eh_generic_reset("TARGET", WAIT_TARGET, cmd,
 	    ha->isp_ops->target_reset);
@@ -893,8 +983,7 @@ qla2xxx_eh_target_reset(struct scsi_cmnd *cmd)
 static int
 qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 {
-	scsi_qla_host_t *ha = shost_priv(cmd->device->host);
-	scsi_qla_host_t *pha = to_qla_parent(ha);
+	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
 	int ret = FAILED;
 	unsigned int id, lun;
@@ -909,28 +998,28 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 	if (!fcport)
 		return ret;
 
-	qla_printk(KERN_INFO, ha,
-	    "scsi(%ld:%d:%d): LOOP RESET ISSUED.\n", ha->host_no, id, lun);
+	qla_printk(KERN_INFO, vha->hw,
+	    "scsi(%ld:%d:%d): LOOP RESET ISSUED.\n", vha->host_no, id, lun);
 
-	if (qla2x00_wait_for_hba_online(ha) != QLA_SUCCESS) {
+	if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS) {
 		DEBUG2(printk("%s failed:board disabled\n",__func__));
 		goto eh_bus_reset_done;
 	}
 
-	if (qla2x00_wait_for_loop_ready(ha) == QLA_SUCCESS) {
-		if (qla2x00_loop_reset(ha) == QLA_SUCCESS)
+	if (qla2x00_wait_for_loop_ready(vha) == QLA_SUCCESS) {
+		if (qla2x00_loop_reset(vha) == QLA_SUCCESS)
 			ret = SUCCESS;
 	}
 	if (ret == FAILED)
 		goto eh_bus_reset_done;
 
 	/* Flush outstanding commands. */
-	if (qla2x00_eh_wait_for_pending_commands(pha, 0, 0, WAIT_HOST) !=
+	if (qla2x00_eh_wait_for_pending_commands(vha, 0, 0, WAIT_HOST) !=
 	    QLA_SUCCESS)
 		ret = FAILED;
 
 eh_bus_reset_done:
-	qla_printk(KERN_INFO, ha, "%s: reset %s\n", __func__,
+	qla_printk(KERN_INFO, vha->hw, "%s: reset %s\n", __func__,
 	    (ret == FAILED) ? "failed" : "succeded");
 
 	return ret;
@@ -954,12 +1043,13 @@ eh_bus_reset_done:
 static int
 qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 {
-	scsi_qla_host_t *ha = shost_priv(cmd->device->host);
+	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
+	struct qla_hw_data *ha = vha->hw;
 	int ret = FAILED;
 	unsigned int id, lun;
 	unsigned long serial;
-	scsi_qla_host_t *pha = to_qla_parent(ha);
+	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 
 	qla2x00_block_error_handler(cmd);
 
@@ -971,9 +1061,9 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 		return ret;
 
 	qla_printk(KERN_INFO, ha,
-	    "scsi(%ld:%d:%d): ADAPTER RESET ISSUED.\n", ha->host_no, id, lun);
+	    "scsi(%ld:%d:%d): ADAPTER RESET ISSUED.\n", vha->host_no, id, lun);
 
-	if (qla2x00_wait_for_hba_online(ha) != QLA_SUCCESS)
+	if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS)
 		goto eh_host_reset_lock;
 
 	/*
@@ -984,26 +1074,28 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 	 * devices as lost kicking of the port_down_timer
 	 * while dpc is stuck for the mailbox to complete.
 	 */
-	qla2x00_wait_for_loop_ready(ha);
-	set_bit(ABORT_ISP_ACTIVE, &pha->dpc_flags);
-	if (qla2x00_abort_isp(pha)) {
-		clear_bit(ABORT_ISP_ACTIVE, &pha->dpc_flags);
-		/* failed. schedule dpc to try */
-		set_bit(ISP_ABORT_NEEDED, &pha->dpc_flags);
-
-		if (qla2x00_wait_for_hba_online(ha) != QLA_SUCCESS)
+	qla2x00_wait_for_loop_ready(vha);
+	if (vha != base_vha) {
+		if (qla2x00_vp_abort_isp(vha))
 			goto eh_host_reset_lock;
+	} else {
+		set_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
+		if (qla2x00_abort_isp(base_vha)) {
+			clear_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
+			/* failed. schedule dpc to try */
+			set_bit(ISP_ABORT_NEEDED, &base_vha->dpc_flags);
+
+			if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS)
+				goto eh_host_reset_lock;
+		}
+		clear_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
 	}
-	clear_bit(ABORT_ISP_ACTIVE, &pha->dpc_flags);
 
-	/* Waiting for our command in done_queue to be returned to OS.*/
-	if (qla2x00_eh_wait_for_pending_commands(pha, 0, 0, WAIT_HOST) ==
-	    QLA_SUCCESS)
+	/* Waiting for command to be returned to OS.*/
+	if (qla2x00_eh_wait_for_pending_commands(vha, 0, 0, WAIT_HOST) ==
+		QLA_SUCCESS)
 		ret = SUCCESS;
 
-	if (ha->parent)
-		qla2x00_vp_abort_isp(ha);
-
 eh_host_reset_lock:
 	qla_printk(KERN_INFO, ha, "%s: reset %s\n", __func__,
 	    (ret == FAILED) ? "failed" : "succeded");
@@ -1022,35 +1114,33 @@ eh_host_reset_lock:
 *      0 = success
 */
 int
-qla2x00_loop_reset(scsi_qla_host_t *ha)
+qla2x00_loop_reset(scsi_qla_host_t *vha)
 {
 	int ret;
 	struct fc_port *fcport;
+	struct qla_hw_data *ha = vha->hw;
 
 	if (ha->flags.enable_lip_full_login) {
-		ret = qla2x00_full_login_lip(ha);
+		ret = qla2x00_full_login_lip(vha);
 		if (ret != QLA_SUCCESS) {
 			DEBUG2_3(printk("%s(%ld): bus_reset failed: "
-			    "full_login_lip=%d.\n", __func__, ha->host_no,
+			    "full_login_lip=%d.\n", __func__, vha->host_no,
 			    ret));
-		}
-		atomic_set(&ha->loop_state, LOOP_DOWN);
-		atomic_set(&ha->loop_down_timer, LOOP_DOWN_TIME);
-		qla2x00_mark_all_devices_lost(ha, 0);
-		qla2x00_wait_for_loop_ready(ha);
+		} else
+			qla2x00_wait_for_loop_ready(vha);
 	}
 
 	if (ha->flags.enable_lip_reset) {
-		ret = qla2x00_lip_reset(ha);
+		ret = qla2x00_lip_reset(vha);
 		if (ret != QLA_SUCCESS) {
 			DEBUG2_3(printk("%s(%ld): bus_reset failed: "
-			    "lip_reset=%d.\n", __func__, ha->host_no, ret));
-		}
-		qla2x00_wait_for_loop_ready(ha);
+			    "lip_reset=%d.\n", __func__, vha->host_no, ret));
+		} else
+			qla2x00_wait_for_loop_ready(vha);
 	}
 
 	if (ha->flags.enable_target_reset) {
-		list_for_each_entry(fcport, &ha->fcports, list) {
+		list_for_each_entry(fcport, &vha->vp_fcports, list) {
 			if (fcport->port_type != FCT_TARGET)
 				continue;
 
@@ -1058,31 +1148,33 @@ qla2x00_loop_reset(scsi_qla_host_t *ha)
 			if (ret != QLA_SUCCESS) {
 				DEBUG2_3(printk("%s(%ld): bus_reset failed: "
 				    "target_reset=%d d_id=%x.\n", __func__,
-				    ha->host_no, ret, fcport->d_id.b24));
+				    vha->host_no, ret, fcport->d_id.b24));
 			}
 		}
 	}
 
 	/* Issue marker command only when we are going to start the I/O */
-	ha->marker_needed = 1;
+	vha->marker_needed = 1;
 
 	return QLA_SUCCESS;
 }
 
 void
-qla2x00_abort_all_cmds(scsi_qla_host_t *ha, int res)
+qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 {
 	int cnt;
 	unsigned long flags;
 	srb_t *sp;
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
-		sp = ha->outstanding_cmds[cnt];
+		sp = req->outstanding_cmds[cnt];
 		if (sp) {
-			ha->outstanding_cmds[cnt] = NULL;
+			req->outstanding_cmds[cnt] = NULL;
 			sp->cmd->result = res;
-			qla2x00_sp_compl(ha, sp);
+			qla2x00_sp_compl(vha, sp);
 		}
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -1104,13 +1196,14 @@ qla2xxx_slave_alloc(struct scsi_device *sdev)
 static int
 qla2xxx_slave_configure(struct scsi_device *sdev)
 {
-	scsi_qla_host_t *ha = shost_priv(sdev->host);
+	scsi_qla_host_t *vha = shost_priv(sdev->host);
+	struct qla_hw_data *ha = vha->hw;
 	struct fc_rport *rport = starget_to_rport(sdev->sdev_target);
 
 	if (sdev->tagged_supported)
-		scsi_activate_tcq(sdev, ha->max_q_depth);
+		scsi_activate_tcq(sdev, ha->req->max_q_depth);
 	else
-		scsi_deactivate_tcq(sdev, ha->max_q_depth);
+		scsi_deactivate_tcq(sdev, ha->req->max_q_depth);
 
 	rport->dev_loss_tmo = ha->port_down_retry_count;
 
@@ -1153,8 +1246,9 @@ qla2x00_change_queue_type(struct scsi_device *sdev, int tag_type)
  * supported addressing method.
  */
 static void
-qla2x00_config_dma_addressing(scsi_qla_host_t *ha)
+qla2x00_config_dma_addressing(scsi_qla_host_t *vha)
 {
+	struct qla_hw_data *ha = vha->hw;
 	/* Assume a 32bit DMA mask. */
 	ha->flags.enable_64bit_addressing = 0;
 
@@ -1175,7 +1269,7 @@ qla2x00_config_dma_addressing(scsi_qla_host_t *ha)
 }
 
 static void
-qla2x00_enable_intrs(scsi_qla_host_t *ha)
+qla2x00_enable_intrs(struct qla_hw_data *ha)
 {
 	unsigned long flags = 0;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
@@ -1190,7 +1284,7 @@ qla2x00_enable_intrs(scsi_qla_host_t *ha)
 }
 
 static void
-qla2x00_disable_intrs(scsi_qla_host_t *ha)
+qla2x00_disable_intrs(struct qla_hw_data *ha)
 {
 	unsigned long flags = 0;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
@@ -1204,7 +1298,7 @@ qla2x00_disable_intrs(scsi_qla_host_t *ha)
 }
 
 static void
-qla24xx_enable_intrs(scsi_qla_host_t *ha)
+qla24xx_enable_intrs(struct qla_hw_data *ha)
 {
 	unsigned long flags = 0;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
@@ -1217,7 +1311,7 @@ qla24xx_enable_intrs(scsi_qla_host_t *ha)
 }
 
 static void
-qla24xx_disable_intrs(scsi_qla_host_t *ha)
+qla24xx_disable_intrs(struct qla_hw_data *ha)
 {
 	unsigned long flags = 0;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
@@ -1261,6 +1355,7 @@ static struct isp_operations qla2100_isp_ops = {
 	.read_optrom		= qla2x00_read_optrom_data,
 	.write_optrom		= qla2x00_write_optrom_data,
 	.get_flash_version	= qla2x00_get_flash_version,
+	.start_scsi		= qla2x00_start_scsi,
 };
 
 static struct isp_operations qla2300_isp_ops = {
@@ -1295,6 +1390,7 @@ static struct isp_operations qla2300_isp_ops = {
 	.read_optrom		= qla2x00_read_optrom_data,
 	.write_optrom		= qla2x00_write_optrom_data,
 	.get_flash_version	= qla2x00_get_flash_version,
+	.start_scsi		= qla2x00_start_scsi,
 };
 
 static struct isp_operations qla24xx_isp_ops = {
@@ -1329,6 +1425,7 @@ static struct isp_operations qla24xx_isp_ops = {
 	.read_optrom		= qla24xx_read_optrom_data,
 	.write_optrom		= qla24xx_write_optrom_data,
 	.get_flash_version	= qla24xx_get_flash_version,
+	.start_scsi		= qla24xx_start_scsi,
 };
 
 static struct isp_operations qla25xx_isp_ops = {
@@ -1363,10 +1460,11 @@ static struct isp_operations qla25xx_isp_ops = {
 	.read_optrom		= qla25xx_read_optrom_data,
 	.write_optrom		= qla24xx_write_optrom_data,
 	.get_flash_version	= qla24xx_get_flash_version,
+	.start_scsi		= qla24xx_start_scsi,
 };
 
 static inline void
-qla2x00_set_isp_flags(scsi_qla_host_t *ha)
+qla2x00_set_isp_flags(struct qla_hw_data *ha)
 {
 	ha->device_type = DT_EXTENDED_IDS;
 	switch (ha->pdev->device) {
@@ -1448,7 +1546,7 @@ qla2x00_set_isp_flags(scsi_qla_host_t *ha)
 }
 
 static int
-qla2x00_iospace_config(scsi_qla_host_t *ha)
+qla2x00_iospace_config(struct qla_hw_data *ha)
 {
 	resource_size_t pio;
 
@@ -1512,25 +1610,25 @@ iospace_error_exit:
 static void
 qla2xxx_scan_start(struct Scsi_Host *shost)
 {
-	scsi_qla_host_t *ha = shost_priv(shost);
+	scsi_qla_host_t *vha = shost_priv(shost);
 
-	set_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags);
-	set_bit(LOCAL_LOOP_UPDATE, &ha->dpc_flags);
-	set_bit(RSCN_UPDATE, &ha->dpc_flags);
-	set_bit(NPIV_CONFIG_NEEDED, &ha->dpc_flags);
+	set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
+	set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
+	set_bit(RSCN_UPDATE, &vha->dpc_flags);
+	set_bit(NPIV_CONFIG_NEEDED, &vha->dpc_flags);
 }
 
 static int
 qla2xxx_scan_finished(struct Scsi_Host *shost, unsigned long time)
 {
-	scsi_qla_host_t *ha = shost_priv(shost);
+	scsi_qla_host_t *vha = shost_priv(shost);
 
-	if (!ha->host)
+	if (!vha->host)
 		return 1;
-	if (time > ha->loop_reset_delay * HZ)
+	if (time > vha->hw->loop_reset_delay * HZ)
 		return 1;
 
-	return atomic_read(&ha->loop_state) == LOOP_READY;
+	return atomic_read(&vha->loop_state) == LOOP_READY;
 }
 
 /*
@@ -1541,11 +1639,13 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	int	ret = -ENODEV;
 	struct Scsi_Host *host;
-	scsi_qla_host_t *ha;
+	scsi_qla_host_t *base_vha = NULL;
+	struct qla_hw_data *ha;
 	char pci_info[30];
 	char fw_str[30];
 	struct scsi_host_template *sht;
-	int bars, mem_only = 0;
+	int bars, mem_only, max_id = 0;
+	uint16_t req_length = 0, rsp_length = 0;
 
 	bars = pci_select_bars(pdev, IORESOURCE_MEM | IORESOURCE_IO);
 	sht = &qla2x00_driver_template;
@@ -1572,33 +1672,24 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		if (pci_enable_pcie_error_reporting(pdev))
 			goto probe_out;
 
-	host = scsi_host_alloc(sht, sizeof(scsi_qla_host_t));
-	if (host == NULL) {
-		printk(KERN_WARNING
-		    "qla2xxx: Couldn't allocate host from scsi layer!\n");
-		goto probe_disable_device;
+	ha = kzalloc(sizeof(struct qla_hw_data), GFP_KERNEL);
+	if (!ha) {
+		DEBUG(printk("Unable to allocate memory for ha\n"));
+		goto probe_out;
 	}
+	ha->pdev = pdev;
 
 	/* Clear our data area */
-	ha = shost_priv(host);
-	memset(ha, 0, sizeof(scsi_qla_host_t));
-
-	ha->pdev = pdev;
-	ha->host = host;
-	ha->host_no = host->host_no;
-	sprintf(ha->host_str, "%s_%ld", QLA2XXX_DRIVER_NAME, ha->host_no);
-	ha->parent = NULL;
 	ha->bars = bars;
 	ha->mem_only = mem_only;
 	spin_lock_init(&ha->hardware_lock);
 
 	/* Set ISP-type information. */
 	qla2x00_set_isp_flags(ha);
-
 	/* Configure PCI I/O space */
 	ret = qla2x00_iospace_config(ha);
 	if (ret)
-		goto probe_failed;
+		goto probe_hw_failed;
 
 	qla_printk(KERN_INFO, ha,
 	    "Found an ISP%04X, irq %d, iobase 0x%p\n", pdev->device, pdev->irq,
@@ -1606,105 +1697,136 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	ha->prev_topology = 0;
 	ha->init_cb_size = sizeof(init_cb_t);
-	ha->mgmt_svr_loop_id = MANAGEMENT_SERVER + ha->vp_idx;
 	ha->link_data_rate = PORT_SPEED_UNKNOWN;
 	ha->optrom_size = OPTROM_SIZE_2300;
 
-	ha->max_q_depth = MAX_Q_DEPTH;
-	if (ql2xmaxqdepth != 0 && ql2xmaxqdepth <= 0xffffU)
-		ha->max_q_depth = ql2xmaxqdepth;
-
 	/* Assign ISP specific operations. */
+	max_id = MAX_TARGETS_2200;
 	if (IS_QLA2100(ha)) {
-		host->max_id = MAX_TARGETS_2100;
+		max_id = MAX_TARGETS_2100;
 		ha->mbx_count = MAILBOX_REGISTER_COUNT_2100;
-		ha->request_q_length = REQUEST_ENTRY_CNT_2100;
-		ha->response_q_length = RESPONSE_ENTRY_CNT_2100;
-		ha->last_loop_id = SNS_LAST_LOOP_ID_2100;
-		host->sg_tablesize = 32;
+		req_length = REQUEST_ENTRY_CNT_2100;
+		rsp_length = RESPONSE_ENTRY_CNT_2100;
+		ha->max_loop_id = SNS_LAST_LOOP_ID_2100;
 		ha->gid_list_info_size = 4;
 		ha->isp_ops = &qla2100_isp_ops;
 	} else if (IS_QLA2200(ha)) {
-		host->max_id = MAX_TARGETS_2200;
 		ha->mbx_count = MAILBOX_REGISTER_COUNT;
-		ha->request_q_length = REQUEST_ENTRY_CNT_2200;
-		ha->response_q_length = RESPONSE_ENTRY_CNT_2100;
-		ha->last_loop_id = SNS_LAST_LOOP_ID_2100;
+		req_length = REQUEST_ENTRY_CNT_2200;
+		rsp_length = RESPONSE_ENTRY_CNT_2100;
+		ha->max_loop_id = SNS_LAST_LOOP_ID_2100;
 		ha->gid_list_info_size = 4;
 		ha->isp_ops = &qla2100_isp_ops;
 	} else if (IS_QLA23XX(ha)) {
-		host->max_id = MAX_TARGETS_2200;
 		ha->mbx_count = MAILBOX_REGISTER_COUNT;
-		ha->request_q_length = REQUEST_ENTRY_CNT_2200;
-		ha->response_q_length = RESPONSE_ENTRY_CNT_2300;
-		ha->last_loop_id = SNS_LAST_LOOP_ID_2300;
+		req_length = REQUEST_ENTRY_CNT_2200;
+		rsp_length = RESPONSE_ENTRY_CNT_2300;
+		ha->max_loop_id = SNS_LAST_LOOP_ID_2300;
 		ha->gid_list_info_size = 6;
 		if (IS_QLA2322(ha) || IS_QLA6322(ha))
 			ha->optrom_size = OPTROM_SIZE_2322;
 		ha->isp_ops = &qla2300_isp_ops;
 	} else if (IS_QLA24XX_TYPE(ha)) {
-		host->max_id = MAX_TARGETS_2200;
 		ha->mbx_count = MAILBOX_REGISTER_COUNT;
-		ha->request_q_length = REQUEST_ENTRY_CNT_24XX;
-		ha->response_q_length = RESPONSE_ENTRY_CNT_2300;
-		ha->last_loop_id = SNS_LAST_LOOP_ID_2300;
+		req_length = REQUEST_ENTRY_CNT_24XX;
+		rsp_length = RESPONSE_ENTRY_CNT_2300;
+		ha->max_loop_id = SNS_LAST_LOOP_ID_2300;
 		ha->init_cb_size = sizeof(struct mid_init_cb_24xx);
-		ha->mgmt_svr_loop_id = 10 + ha->vp_idx;
 		ha->gid_list_info_size = 8;
 		ha->optrom_size = OPTROM_SIZE_24XX;
 		ha->isp_ops = &qla24xx_isp_ops;
 	} else if (IS_QLA25XX(ha)) {
-		host->max_id = MAX_TARGETS_2200;
 		ha->mbx_count = MAILBOX_REGISTER_COUNT;
-		ha->request_q_length = REQUEST_ENTRY_CNT_24XX;
-		ha->response_q_length = RESPONSE_ENTRY_CNT_2300;
-		ha->last_loop_id = SNS_LAST_LOOP_ID_2300;
+		req_length = REQUEST_ENTRY_CNT_24XX;
+		rsp_length = RESPONSE_ENTRY_CNT_2300;
+		ha->max_loop_id = SNS_LAST_LOOP_ID_2300;
 		ha->init_cb_size = sizeof(struct mid_init_cb_24xx);
-		ha->mgmt_svr_loop_id = 10 + ha->vp_idx;
 		ha->gid_list_info_size = 8;
 		ha->optrom_size = OPTROM_SIZE_25XX;
 		ha->isp_ops = &qla25xx_isp_ops;
 	}
-	host->can_queue = ha->request_q_length + 128;
 
 	mutex_init(&ha->vport_lock);
 	init_completion(&ha->mbx_cmd_comp);
 	complete(&ha->mbx_cmd_comp);
 	init_completion(&ha->mbx_intr_comp);
 
-	INIT_LIST_HEAD(&ha->list);
-	INIT_LIST_HEAD(&ha->fcports);
-	INIT_LIST_HEAD(&ha->vp_list);
-	INIT_LIST_HEAD(&ha->work_list);
-
 	set_bit(0, (unsigned long *) ha->vp_idx_map);
 
-	qla2x00_config_dma_addressing(ha);
 	if (qla2x00_mem_alloc(ha)) {
 		qla_printk(KERN_WARNING, ha,
 		    "[ERROR] Failed to allocate memory for adapter\n");
 
 		ret = -ENOMEM;
-		goto probe_failed;
+		goto probe_hw_failed;
+	}
+
+	/* Allocate queue specific rings */
+	if (!qla2x00_alloc_que(ha, req_length, rsp_length)) {
+		qla_printk(KERN_WARNING, ha,
+			"[ERROR] Failed to allocate memory for queues\n");
+		ret = -ENOMEM;
+		goto probe_hw_failed;
+	}
+
+	ha->req->max_q_depth = MAX_Q_DEPTH;
+	if (ql2xmaxqdepth != 0 && ql2xmaxqdepth <= 0xffffU)
+		ha->req->max_q_depth = ql2xmaxqdepth;
+
+	base_vha = qla2x00_create_host(sht, ha);
+	if (!base_vha) {
+		qla_printk(KERN_WARNING, ha,
+		    "[ERROR] Failed to allocate memory for scsi_host\n");
+
+		ret = -ENOMEM;
+		goto probe_hw_failed;
+	}
+
+	pci_set_drvdata(pdev, base_vha);
+
+	qla2x00_config_dma_addressing(base_vha);
+
+	host = base_vha->host;
+	host->can_queue = ha->req->length + 128;
+	if (IS_QLA2XXX_MIDTYPE(ha)) {
+		base_vha->mgmt_svr_loop_id = 10 + base_vha->vp_idx;
+	} else {
+		base_vha->mgmt_svr_loop_id = MANAGEMENT_SERVER +
+						base_vha->vp_idx;
 	}
+	if (IS_QLA2100(ha))
+		host->sg_tablesize = 32;
+	host->max_id = max_id;
+	host->this_id = 255;
+	host->cmd_per_lun = 3;
+	host->unique_id = host->host_no;
+	host->max_cmd_len = MAX_CMDSZ;
+	host->max_channel = MAX_BUSES - 1;
+	host->max_lun = MAX_LUNS;
+	host->transportt = qla2xxx_transport_template;
 
-	if (qla2x00_initialize_adapter(ha)) {
+	if (qla2x00_initialize_adapter(base_vha)) {
 		qla_printk(KERN_WARNING, ha,
 		    "Failed to initialize adapter\n");
 
 		DEBUG2(printk("scsi(%ld): Failed to initialize adapter - "
 		    "Adapter flags %x.\n",
-		    ha->host_no, ha->device_flags));
+		    base_vha->host_no, base_vha->device_flags));
 
 		ret = -ENODEV;
 		goto probe_failed;
 	}
 
+	/* Set up the irqs */
+	ret = qla2x00_request_irqs(ha);
+	if (ret)
+		goto probe_failed;
+
 	/*
 	 * Startup the kernel thread for this host adapter
 	 */
 	ha->dpc_thread = kthread_create(qla2x00_do_dpc, ha,
-			"%s_dpc", ha->host_str);
+			"%s_dpc", base_vha->host_str);
 	if (IS_ERR(ha->dpc_thread)) {
 		qla_printk(KERN_WARNING, ha,
 		    "Unable to start DPC thread!\n");
@@ -1712,28 +1834,19 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto probe_failed;
 	}
 
-	host->this_id = 255;
-	host->cmd_per_lun = 3;
-	host->unique_id = host->host_no;
-	host->max_cmd_len = MAX_CMDSZ;
-	host->max_channel = MAX_BUSES - 1;
-	host->max_lun = MAX_LUNS;
-	host->transportt = qla2xxx_transport_template;
-
-	ret = qla2x00_request_irqs(ha);
-	if (ret)
-		goto probe_failed;
+	list_add_tail(&base_vha->list, &ha->vp_list);
+	/* enable interrupts */
+	base_vha->host->irq = ha->pdev->irq;
+	ha->isp_ops->enable_intrs(ha);
 
 	/* Initialized the timer */
-	qla2x00_start_timer(ha, qla2x00_timer, WATCH_INTERVAL);
+	qla2x00_start_timer(base_vha, qla2x00_timer, WATCH_INTERVAL);
 
 	DEBUG2(printk("DEBUG: detect hba %ld at address = %p\n",
-	    ha->host_no, ha));
+	    base_vha->host_no, ha));
 
-	pci_set_drvdata(pdev, ha);
-
-	ha->flags.init_done = 1;
-	ha->flags.online = 1;
+	base_vha->flags.init_done = 1;
+	base_vha->flags.online = 1;
 
 	ret = scsi_add_host(host, &pdev->dev);
 	if (ret)
@@ -1743,76 +1856,94 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	scsi_scan_host(host);
 
-	qla2x00_alloc_sysfs_attr(ha);
+	qla2x00_alloc_sysfs_attr(base_vha);
 
-	qla2x00_init_host_attr(ha);
+	qla2x00_init_host_attr(base_vha);
 
-	qla2x00_dfs_setup(ha);
+	qla2x00_dfs_setup(base_vha);
 
 	qla_printk(KERN_INFO, ha, "\n"
 	    " QLogic Fibre Channel HBA Driver: %s\n"
 	    "  QLogic %s - %s\n"
 	    "  ISP%04X: %s @ %s hdma%c, host#=%ld, fw=%s\n",
 	    qla2x00_version_str, ha->model_number,
-	    ha->model_desc ? ha->model_desc: "", pdev->device,
-	    ha->isp_ops->pci_info_str(ha, pci_info), pci_name(pdev),
-	    ha->flags.enable_64bit_addressing ? '+': '-', ha->host_no,
-	    ha->isp_ops->fw_version_str(ha, fw_str));
+	    ha->model_desc ? ha->model_desc : "", pdev->device,
+	    ha->isp_ops->pci_info_str(base_vha, pci_info), pci_name(pdev),
+	    ha->flags.enable_64bit_addressing ? '+' : '-', base_vha->host_no,
+	    ha->isp_ops->fw_version_str(base_vha, fw_str));
 
 	return 0;
 
 probe_failed:
-	qla2x00_free_device(ha);
+	qla2x00_free_device(base_vha);
 
-	scsi_host_put(host);
+	scsi_host_put(base_vha->host);
 
-probe_disable_device:
-	pci_disable_device(pdev);
+probe_hw_failed:
+	if (ha->iobase)
+		iounmap(ha->iobase);
+
+	pci_release_selected_regions(ha->pdev, ha->bars);
+	kfree(ha);
+	ha = NULL;
 
 probe_out:
+	pci_disable_device(pdev);
 	return ret;
 }
 
 static void
 qla2x00_remove_one(struct pci_dev *pdev)
 {
-	scsi_qla_host_t *ha, *vha, *temp;
+	scsi_qla_host_t *base_vha, *vha, *temp;
+	struct qla_hw_data  *ha;
+
+	base_vha = pci_get_drvdata(pdev);
+	ha = base_vha->hw;
 
-	ha = pci_get_drvdata(pdev);
+	list_for_each_entry_safe(vha, temp, &ha->vp_list, list) {
+		if (vha && vha->fc_vport)
+			fc_vport_terminate(vha->fc_vport);
+	}
 
-	list_for_each_entry_safe(vha, temp, &ha->vp_list, vp_list)
-		fc_vport_terminate(vha->fc_vport);
+	set_bit(UNLOADING, &base_vha->dpc_flags);
 
-	set_bit(UNLOADING, &ha->dpc_flags);
+	qla2x00_dfs_remove(base_vha);
 
-	qla2x00_dfs_remove(ha);
+	qla84xx_put_chip(base_vha);
 
-	qla84xx_put_chip(ha);
+	qla2x00_free_sysfs_attr(base_vha);
 
-	qla2x00_free_sysfs_attr(ha);
+	fc_remove_host(base_vha->host);
 
-	fc_remove_host(ha->host);
+	scsi_remove_host(base_vha->host);
 
-	scsi_remove_host(ha->host);
+	qla2x00_free_device(base_vha);
 
-	qla2x00_free_device(ha);
+	scsi_host_put(base_vha->host);
 
-	scsi_host_put(ha->host);
+	if (ha->iobase)
+		iounmap(ha->iobase);
+
+	pci_release_selected_regions(ha->pdev, ha->bars);
+	kfree(ha);
+	ha = NULL;
 
 	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
 }
 
 static void
-qla2x00_free_device(scsi_qla_host_t *ha)
+qla2x00_free_device(scsi_qla_host_t *vha)
 {
-	qla2x00_abort_all_cmds(ha, DID_NO_CONNECT << 16);
+	struct qla_hw_data *ha = vha->hw;
+	qla2x00_abort_all_cmds(vha, DID_NO_CONNECT << 16);
 
 	/* Disable timer */
-	if (ha->timer_active)
-		qla2x00_stop_timer(ha);
+	if (vha->timer_active)
+		qla2x00_stop_timer(vha);
 
-	ha->flags.online = 0;
+	vha->flags.online = 0;
 
 	/* Kill the kernel thread for this host */
 	if (ha->dpc_thread) {
@@ -1827,45 +1958,41 @@ qla2x00_free_device(scsi_qla_host_t *ha)
 	}
 
 	if (ha->flags.fce_enabled)
-		qla2x00_disable_fce_trace(ha, NULL, NULL);
+		qla2x00_disable_fce_trace(vha, NULL, NULL);
 
 	if (ha->eft)
-		qla2x00_disable_eft_trace(ha);
+		qla2x00_disable_eft_trace(vha);
 
 	/* Stop currently executing firmware. */
-	qla2x00_try_to_stop_firmware(ha);
+	qla2x00_try_to_stop_firmware(vha);
 
 	/* turn-off interrupts on the card */
 	if (ha->interrupts_on)
 		ha->isp_ops->disable_intrs(ha);
 
-	qla2x00_mem_free(ha);
+	qla2x00_free_irqs(vha);
 
-	qla2x00_free_irqs(ha);
+	qla2x00_mem_free(ha);
 
-	/* release io space registers  */
-	if (ha->iobase)
-		iounmap(ha->iobase);
-	pci_release_selected_regions(ha->pdev, ha->bars);
+	qla2x00_free_que(ha);
 }
 
 static inline void
-qla2x00_schedule_rport_del(struct scsi_qla_host *ha, fc_port_t *fcport,
+qla2x00_schedule_rport_del(struct scsi_qla_host *vha, fc_port_t *fcport,
     int defer)
 {
 	struct fc_rport *rport;
-	scsi_qla_host_t *pha = to_qla_parent(ha);
 
 	if (!fcport->rport)
 		return;
 
 	rport = fcport->rport;
 	if (defer) {
-		spin_lock_irq(ha->host->host_lock);
+		spin_lock_irq(vha->host->host_lock);
 		fcport->drport = rport;
-		spin_unlock_irq(ha->host->host_lock);
-		set_bit(FCPORT_UPDATE_NEEDED, &pha->dpc_flags);
-		qla2xxx_wake_dpc(pha);
+		spin_unlock_irq(vha->host->host_lock);
+		set_bit(FCPORT_UPDATE_NEEDED, &vha->dpc_flags);
+		qla2xxx_wake_dpc(vha);
 	} else
 		fc_remote_port_delete(rport);
 }
@@ -1879,13 +2006,14 @@ qla2x00_schedule_rport_del(struct scsi_qla_host *ha, fc_port_t *fcport,
  *
  * Context:
  */
-void qla2x00_mark_device_lost(scsi_qla_host_t *ha, fc_port_t *fcport,
+void qla2x00_mark_device_lost(scsi_qla_host_t *vha, fc_port_t *fcport,
     int do_login, int defer)
 {
 	if (atomic_read(&fcport->state) == FCS_ONLINE &&
-	    ha->vp_idx == fcport->vp_idx)
-		qla2x00_schedule_rport_del(ha, fcport, defer);
-
+	    vha->vp_idx == fcport->vp_idx) {
+		atomic_set(&fcport->state, FCS_DEVICE_LOST);
+		qla2x00_schedule_rport_del(vha, fcport, defer);
+	}
 	/*
 	 * We may need to retry the login, so don't change the state of the
 	 * port but do the retries.
@@ -1897,13 +2025,13 @@ void qla2x00_mark_device_lost(scsi_qla_host_t *ha, fc_port_t *fcport,
 		return;
 
 	if (fcport->login_retry == 0) {
-		fcport->login_retry = ha->login_retry_count;
-		set_bit(RELOGIN_NEEDED, &ha->dpc_flags);
+		fcport->login_retry = vha->hw->login_retry_count;
+		set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 
 		DEBUG(printk("scsi(%ld): Port login retry: "
 		    "%02x%02x%02x%02x%02x%02x%02x%02x, "
 		    "id = 0x%04x retry cnt=%d\n",
-		    ha->host_no,
+		    vha->host_no,
 		    fcport->port_name[0],
 		    fcport->port_name[1],
 		    fcport->port_name[2],
@@ -1931,13 +2059,12 @@ void qla2x00_mark_device_lost(scsi_qla_host_t *ha, fc_port_t *fcport,
  * Context:
  */
 void
-qla2x00_mark_all_devices_lost(scsi_qla_host_t *ha, int defer)
+qla2x00_mark_all_devices_lost(scsi_qla_host_t *vha, int defer)
 {
 	fc_port_t *fcport;
-	scsi_qla_host_t *pha = to_qla_parent(ha);
 
-	list_for_each_entry(fcport, &pha->fcports, list) {
-		if (ha->vp_idx != fcport->vp_idx)
+	list_for_each_entry(fcport, &vha->vp_fcports, list) {
+		if (vha->vp_idx != fcport->vp_idx)
 			continue;
 		/*
 		 * No point in marking the device as lost, if the device is
@@ -1945,9 +2072,11 @@ qla2x00_mark_all_devices_lost(scsi_qla_host_t *ha, int defer)
 		 */
 		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD)
 			continue;
-		if (atomic_read(&fcport->state) == FCS_ONLINE)
-			qla2x00_schedule_rport_del(ha, fcport, defer);
-		atomic_set(&fcport->state, FCS_DEVICE_LOST);
+		if (atomic_read(&fcport->state) == FCS_ONLINE) {
+			atomic_set(&fcport->state, FCS_DEVICE_LOST);
+			qla2x00_schedule_rport_del(vha, fcport, defer);
+		} else
+			atomic_set(&fcport->state, FCS_DEVICE_LOST);
 	}
 }
 
@@ -1960,105 +2089,88 @@ qla2x00_mark_all_devices_lost(scsi_qla_host_t *ha, int defer)
 *      !0  = failure.
 */
 static int
-qla2x00_mem_alloc(scsi_qla_host_t *ha)
+qla2x00_mem_alloc(struct qla_hw_data *ha)
 {
 	char	name[16];
 
-	ha->request_ring = dma_alloc_coherent(&ha->pdev->dev,
-	    (ha->request_q_length + 1) * sizeof(request_t), &ha->request_dma,
-	    GFP_KERNEL);
-	if (!ha->request_ring)
-		goto fail;
-
-	ha->response_ring = dma_alloc_coherent(&ha->pdev->dev,
-	    (ha->response_q_length + 1) * sizeof(response_t),
-	    &ha->response_dma, GFP_KERNEL);
-	if (!ha->response_ring)
-		goto fail_free_request_ring;
-
-	ha->gid_list = dma_alloc_coherent(&ha->pdev->dev, GID_LIST_SIZE,
-	    &ha->gid_list_dma, GFP_KERNEL);
-	if (!ha->gid_list)
-		goto fail_free_response_ring;
+	ha->init_cb_size = sizeof(init_cb_t);
+	if (IS_QLA2XXX_MIDTYPE(ha))
+		ha->init_cb_size = sizeof(struct mid_init_cb_24xx);
 
 	ha->init_cb = dma_alloc_coherent(&ha->pdev->dev, ha->init_cb_size,
-	    &ha->init_cb_dma, GFP_KERNEL);
+		&ha->init_cb_dma, GFP_KERNEL);
 	if (!ha->init_cb)
-		goto fail_free_gid_list;
+		goto fail;
 
-	snprintf(name, sizeof(name), "%s_%ld", QLA2XXX_DRIVER_NAME,
-	    ha->host_no);
-	ha->s_dma_pool = dma_pool_create(name, &ha->pdev->dev,
-	    DMA_POOL_SIZE, 8, 0);
-	if (!ha->s_dma_pool)
+	ha->gid_list = dma_alloc_coherent(&ha->pdev->dev, GID_LIST_SIZE,
+		&ha->gid_list_dma, GFP_KERNEL);
+	if (!ha->gid_list)
 		goto fail_free_init_cb;
 
 	ha->srb_mempool = mempool_create_slab_pool(SRB_MIN_REQ, srb_cachep);
 	if (!ha->srb_mempool)
-		goto fail_free_s_dma_pool;
+		goto fail_free_gid_list;
 
 	/* Get memory for cached NVRAM */
 	ha->nvram = kzalloc(MAX_NVRAM_SIZE, GFP_KERNEL);
 	if (!ha->nvram)
 		goto fail_free_srb_mempool;
 
+	snprintf(name, sizeof(name), "%s_%d", QLA2XXX_DRIVER_NAME,
+		ha->pdev->device);
+	ha->s_dma_pool = dma_pool_create(name, &ha->pdev->dev,
+		DMA_POOL_SIZE, 8, 0);
+	if (!ha->s_dma_pool)
+		goto fail_free_nvram;
+
 	/* Allocate memory for SNS commands */
 	if (IS_QLA2100(ha) || IS_QLA2200(ha)) {
-		/* Get consistent memory allocated for SNS commands */
+	/* Get consistent memory allocated for SNS commands */
 		ha->sns_cmd = dma_alloc_coherent(&ha->pdev->dev,
-		    sizeof(struct sns_cmd_pkt), &ha->sns_cmd_dma, GFP_KERNEL);
+		sizeof(struct sns_cmd_pkt), &ha->sns_cmd_dma, GFP_KERNEL);
 		if (!ha->sns_cmd)
-			goto fail_free_nvram;
+			goto fail_dma_pool;
 	} else {
-		/* Get consistent memory allocated for MS IOCB */
+	/* Get consistent memory allocated for MS IOCB */
 		ha->ms_iocb = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL,
-		    &ha->ms_iocb_dma);
+			&ha->ms_iocb_dma);
 		if (!ha->ms_iocb)
-			goto fail_free_nvram;
-
-		/* Get consistent memory allocated for CT SNS commands */
+			goto fail_dma_pool;
+	/* Get consistent memory allocated for CT SNS commands */
 		ha->ct_sns = dma_alloc_coherent(&ha->pdev->dev,
-		    sizeof(struct ct_sns_pkt), &ha->ct_sns_dma, GFP_KERNEL);
+			sizeof(struct ct_sns_pkt), &ha->ct_sns_dma, GFP_KERNEL);
 		if (!ha->ct_sns)
 			goto fail_free_ms_iocb;
 	}
 
+	INIT_LIST_HEAD(&ha->vp_list);
 	return 0;
 
 fail_free_ms_iocb:
 	dma_pool_free(ha->s_dma_pool, ha->ms_iocb, ha->ms_iocb_dma);
 	ha->ms_iocb = NULL;
 	ha->ms_iocb_dma = 0;
+fail_dma_pool:
+	dma_pool_destroy(ha->s_dma_pool);
+	ha->s_dma_pool = NULL;
 fail_free_nvram:
 	kfree(ha->nvram);
 	ha->nvram = NULL;
 fail_free_srb_mempool:
 	mempool_destroy(ha->srb_mempool);
 	ha->srb_mempool = NULL;
-fail_free_s_dma_pool:
-	dma_pool_destroy(ha->s_dma_pool);
-	ha->s_dma_pool = NULL;
-fail_free_init_cb:
-	dma_free_coherent(&ha->pdev->dev, ha->init_cb_size, ha->init_cb,
-	    ha->init_cb_dma);
-	ha->init_cb = NULL;
-	ha->init_cb_dma = 0;
 fail_free_gid_list:
 	dma_free_coherent(&ha->pdev->dev, GID_LIST_SIZE, ha->gid_list,
-	    ha->gid_list_dma);
+	ha->gid_list_dma);
 	ha->gid_list = NULL;
 	ha->gid_list_dma = 0;
-fail_free_response_ring:
-	dma_free_coherent(&ha->pdev->dev, (ha->response_q_length + 1) *
-	    sizeof(response_t), ha->response_ring, ha->response_dma);
-	ha->response_ring = NULL;
-	ha->response_dma = 0;
-fail_free_request_ring:
-	dma_free_coherent(&ha->pdev->dev, (ha->request_q_length + 1) *
-	    sizeof(request_t), ha->request_ring, ha->request_dma);
-	ha->request_ring = NULL;
-	ha->request_dma = 0;
+fail_free_init_cb:
+	dma_free_coherent(&ha->pdev->dev, ha->init_cb_size, ha->init_cb,
+	ha->init_cb_dma);
+	ha->init_cb = NULL;
+	ha->init_cb_dma = 0;
 fail:
+	DEBUG(printk("%s: Memory allocation failure\n", __func__));
 	return -ENOMEM;
 }
 
@@ -2070,32 +2182,30 @@ fail:
 *      ha = adapter block pointer.
 */
 static void
-qla2x00_mem_free(scsi_qla_host_t *ha)
+qla2x00_mem_free(struct qla_hw_data *ha)
 {
-	struct list_head	*fcpl, *fcptemp;
-	fc_port_t	*fcport;
 
 	if (ha->srb_mempool)
 		mempool_destroy(ha->srb_mempool);
 
 	if (ha->fce)
 		dma_free_coherent(&ha->pdev->dev, FCE_SIZE, ha->fce,
-		    ha->fce_dma);
+		ha->fce_dma);
 
 	if (ha->fw_dump) {
 		if (ha->eft)
 			dma_free_coherent(&ha->pdev->dev,
-			    ntohl(ha->fw_dump->eft_size), ha->eft, ha->eft_dma);
+			ntohl(ha->fw_dump->eft_size), ha->eft, ha->eft_dma);
 		vfree(ha->fw_dump);
 	}
 
 	if (ha->sns_cmd)
 		dma_free_coherent(&ha->pdev->dev, sizeof(struct sns_cmd_pkt),
-		    ha->sns_cmd, ha->sns_cmd_dma);
+		ha->sns_cmd, ha->sns_cmd_dma);
 
 	if (ha->ct_sns)
 		dma_free_coherent(&ha->pdev->dev, sizeof(struct ct_sns_pkt),
-		    ha->ct_sns, ha->ct_sns_dma);
+		ha->ct_sns, ha->ct_sns_dma);
 
 	if (ha->sfp_data)
 		dma_pool_free(ha->s_dma_pool, ha->sfp_data, ha->sfp_data_dma);
@@ -2106,23 +2216,17 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
 	if (ha->s_dma_pool)
 		dma_pool_destroy(ha->s_dma_pool);
 
-	if (ha->init_cb)
-		dma_free_coherent(&ha->pdev->dev, ha->init_cb_size,
-		    ha->init_cb, ha->init_cb_dma);
 
 	if (ha->gid_list)
 		dma_free_coherent(&ha->pdev->dev, GID_LIST_SIZE, ha->gid_list,
-		    ha->gid_list_dma);
+		ha->gid_list_dma);
 
-	if (ha->response_ring)
-		dma_free_coherent(&ha->pdev->dev,
-		    (ha->response_q_length + 1) * sizeof(response_t),
-		    ha->response_ring, ha->response_dma);
 
-	if (ha->request_ring)
-		dma_free_coherent(&ha->pdev->dev,
-		    (ha->request_q_length + 1) * sizeof(request_t),
-		    ha->request_ring, ha->request_dma);
+	if (ha->init_cb)
+		dma_free_coherent(&ha->pdev->dev, ha->init_cb_size,
+		ha->init_cb, ha->init_cb_dma);
+	vfree(ha->optrom_buffer);
+	kfree(ha->nvram);
 
 	ha->srb_mempool = NULL;
 	ha->eft = NULL;
@@ -2141,30 +2245,45 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
 	ha->gid_list = NULL;
 	ha->gid_list_dma = 0;
 
-	ha->response_ring = NULL;
-	ha->response_dma = 0;
-	ha->request_ring = NULL;
-	ha->request_dma = 0;
+	ha->fw_dump = NULL;
+	ha->fw_dumped = 0;
+	ha->fw_dump_reading = 0;
+}
 
-	list_for_each_safe(fcpl, fcptemp, &ha->fcports) {
-		fcport = list_entry(fcpl, fc_port_t, list);
+struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
+						struct qla_hw_data *ha)
+{
+	struct Scsi_Host *host;
+	struct scsi_qla_host *vha = NULL;
 
-		/* fc ports */
-		list_del_init(&fcport->list);
-		kfree(fcport);
+	host = scsi_host_alloc(sht, sizeof(scsi_qla_host_t));
+	if (host == NULL) {
+		printk(KERN_WARNING
+		"qla2xxx: Couldn't allocate host from scsi layer!\n");
+		goto fail;
 	}
-	INIT_LIST_HEAD(&ha->fcports);
 
-	ha->fw_dump = NULL;
-	ha->fw_dumped = 0;
-	ha->fw_dump_reading = 0;
+	/* Clear our data area */
+	vha = shost_priv(host);
+	memset(vha, 0, sizeof(scsi_qla_host_t));
 
-	vfree(ha->optrom_buffer);
-	kfree(ha->nvram);
+	vha->host = host;
+	vha->host_no = host->host_no;
+	vha->hw = ha;
+
+	INIT_LIST_HEAD(&vha->vp_fcports);
+	INIT_LIST_HEAD(&vha->work_list);
+	INIT_LIST_HEAD(&vha->list);
+
+	sprintf(vha->host_str, "%s_%ld", QLA2XXX_DRIVER_NAME, vha->host_no);
+	return vha;
+
+fail:
+	return vha;
 }
 
 static struct qla_work_evt *
-qla2x00_alloc_work(struct scsi_qla_host *ha, enum qla_work_type type,
+qla2x00_alloc_work(struct scsi_qla_host *vha, enum qla_work_type type,
     int locked)
 {
 	struct qla_work_evt *e;
@@ -2181,42 +2300,42 @@ qla2x00_alloc_work(struct scsi_qla_host *ha, enum qla_work_type type,
 }
 
 static int
-qla2x00_post_work(struct scsi_qla_host *ha, struct qla_work_evt *e, int locked)
+qla2x00_post_work(struct scsi_qla_host *vha, struct qla_work_evt *e, int locked)
 {
 	unsigned long uninitialized_var(flags);
-	scsi_qla_host_t *pha = to_qla_parent(ha);
+	struct qla_hw_data *ha = vha->hw;
 
 	if (!locked)
-		spin_lock_irqsave(&pha->hardware_lock, flags);
-	list_add_tail(&e->list, &ha->work_list);
-	qla2xxx_wake_dpc(ha);
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+	list_add_tail(&e->list, &vha->work_list);
+	qla2xxx_wake_dpc(vha);
 	if (!locked)
-		spin_unlock_irqrestore(&pha->hardware_lock, flags);
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	return QLA_SUCCESS;
 }
 
 int
-qla2x00_post_aen_work(struct scsi_qla_host *ha, enum fc_host_event_code code,
+qla2x00_post_aen_work(struct scsi_qla_host *vha, enum fc_host_event_code code,
     u32 data)
 {
 	struct qla_work_evt *e;
 
-	e = qla2x00_alloc_work(ha, QLA_EVT_AEN, 1);
+	e = qla2x00_alloc_work(vha, QLA_EVT_AEN, 1);
 	if (!e)
 		return QLA_FUNCTION_FAILED;
 
 	e->u.aen.code = code;
 	e->u.aen.data = data;
-	return qla2x00_post_work(ha, e, 1);
+	return qla2x00_post_work(vha, e, 1);
 }
 
 int
-qla2x00_post_hwe_work(struct scsi_qla_host *ha, uint16_t code, uint16_t d1,
+qla2x00_post_hwe_work(struct scsi_qla_host *vha, uint16_t code, uint16_t d1,
     uint16_t d2, uint16_t d3)
 {
 	struct qla_work_evt *e;
 
-	e = qla2x00_alloc_work(ha, QLA_EVT_HWE_LOG, 1);
+	e = qla2x00_alloc_work(vha, QLA_EVT_HWE_LOG, 1);
 	if (!e)
 		return QLA_FUNCTION_FAILED;
 
@@ -2224,36 +2343,95 @@ qla2x00_post_hwe_work(struct scsi_qla_host *ha, uint16_t code, uint16_t d1,
 	e->u.hwe.d1 = d1;
 	e->u.hwe.d2 = d2;
 	e->u.hwe.d3 = d3;
-	return qla2x00_post_work(ha, e, 1);
+	return qla2x00_post_work(vha, e, 1);
 }
 
 static void
-qla2x00_do_work(struct scsi_qla_host *ha)
+qla2x00_do_work(struct scsi_qla_host *vha)
 {
 	struct qla_work_evt *e;
-	scsi_qla_host_t *pha = to_qla_parent(ha);
+	struct qla_hw_data *ha = vha->hw;
 
-	spin_lock_irq(&pha->hardware_lock);
-	while (!list_empty(&ha->work_list)) {
-		e = list_entry(ha->work_list.next, struct qla_work_evt, list);
+	spin_lock_irq(&ha->hardware_lock);
+	while (!list_empty(&vha->work_list)) {
+		e = list_entry(vha->work_list.next, struct qla_work_evt, list);
 		list_del_init(&e->list);
-		spin_unlock_irq(&pha->hardware_lock);
+		spin_unlock_irq(&ha->hardware_lock);
 
 		switch (e->type) {
 		case QLA_EVT_AEN:
-			fc_host_post_event(ha->host, fc_get_event_number(),
+			fc_host_post_event(vha->host, fc_get_event_number(),
 			    e->u.aen.code, e->u.aen.data);
 			break;
 		case QLA_EVT_HWE_LOG:
-			qla2xxx_hw_event_log(ha, e->u.hwe.code, e->u.hwe.d1,
+			qla2xxx_hw_event_log(vha, e->u.hwe.code, e->u.hwe.d1,
 			    e->u.hwe.d2, e->u.hwe.d3);
 			break;
 		}
 		if (e->flags & QLA_EVT_FLAG_FREE)
 			kfree(e);
-		spin_lock_irq(&pha->hardware_lock);
+		spin_lock_irq(&ha->hardware_lock);
+	}
+	spin_unlock_irq(&ha->hardware_lock);
+}
+/* Relogins all the fcports of a vport
+ * Context: dpc thread
+ */
+void qla2x00_relogin(struct scsi_qla_host *vha)
+{
+	fc_port_t       *fcport;
+	uint8_t         status;
+	uint16_t        next_loopid = 0;
+	struct qla_hw_data *ha = vha->hw;
+
+	list_for_each_entry(fcport, &vha->vp_fcports, list) {
+	/*
+	 * If the port is not ONLINE then try to login
+	 * to it if we haven't run out of retries.
+	 */
+		if (atomic_read(&fcport->state) !=
+			FCS_ONLINE && fcport->login_retry) {
+
+			if (fcport->flags & FCF_FABRIC_DEVICE) {
+				if (fcport->flags & FCF_TAPE_PRESENT)
+					ha->isp_ops->fabric_logout(vha,
+							fcport->loop_id,
+							fcport->d_id.b.domain,
+							fcport->d_id.b.area,
+							fcport->d_id.b.al_pa);
+
+				status = qla2x00_fabric_login(vha, fcport,
+							&next_loopid);
+			} else
+				status = qla2x00_local_device_login(vha,
+								fcport);
+
+			fcport->login_retry--;
+			if (status == QLA_SUCCESS) {
+				fcport->old_loop_id = fcport->loop_id;
+
+				DEBUG(printk("scsi(%ld): port login OK: logged "
+				"in ID 0x%x\n", vha->host_no, fcport->loop_id));
+
+				qla2x00_update_fcport(vha, fcport);
+
+			} else if (status == 1) {
+				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
+				/* retry the login again */
+				DEBUG(printk("scsi(%ld): Retrying"
+				" %d login again loop_id 0x%x\n",
+				vha->host_no, fcport->login_retry,
+						fcport->loop_id));
+			} else {
+				fcport->login_retry = 0;
+			}
+
+			if (fcport->login_retry == 0 && status != QLA_SUCCESS)
+				fcport->loop_id = FC_NO_LOOP_ID;
+		}
+		if (test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags))
+			break;
 	}
-	spin_unlock_irq(&pha->hardware_lock);
 }
 
 /**************************************************************************
@@ -2273,15 +2451,11 @@ static int
 qla2x00_do_dpc(void *data)
 {
 	int		rval;
-	scsi_qla_host_t *ha;
-	fc_port_t	*fcport;
-	uint8_t		status;
-	uint16_t	next_loopid;
-	struct scsi_qla_host *vha;
-	int             i;
-
+	scsi_qla_host_t *base_vha;
+	struct qla_hw_data *ha;
 
-	ha = (scsi_qla_host_t *)data;
+	ha = (struct qla_hw_data *)data;
+	base_vha = pci_get_drvdata(ha->pdev);
 
 	set_user_nice(current, -20);
 
@@ -2295,10 +2469,10 @@ qla2x00_do_dpc(void *data)
 		DEBUG3(printk("qla2x00: DPC handler waking up\n"));
 
 		/* Initialization not yet finished. Don't do anything yet. */
-		if (!ha->flags.init_done)
+		if (!base_vha->flags.init_done)
 			continue;
 
-		DEBUG3(printk("scsi(%ld): DPC handler\n", ha->host_no));
+		DEBUG3(printk("scsi(%ld): DPC handler\n", base_vha->host_no));
 
 		ha->dpc_active = 1;
 
@@ -2307,149 +2481,98 @@ qla2x00_do_dpc(void *data)
 			continue;
 		}
 
-		qla2x00_do_work(ha);
+		qla2x00_do_work(base_vha);
 
-		if (test_and_clear_bit(ISP_ABORT_NEEDED, &ha->dpc_flags)) {
+		if (test_and_clear_bit(ISP_ABORT_NEEDED,
+						&base_vha->dpc_flags)) {
 
 			DEBUG(printk("scsi(%ld): dpc: sched "
 			    "qla2x00_abort_isp ha = %p\n",
-			    ha->host_no, ha));
+			    base_vha->host_no, ha));
 			if (!(test_and_set_bit(ABORT_ISP_ACTIVE,
-			    &ha->dpc_flags))) {
+			    &base_vha->dpc_flags))) {
 
-				if (qla2x00_abort_isp(ha)) {
+				if (qla2x00_abort_isp(base_vha)) {
 					/* failed. retry later */
 					set_bit(ISP_ABORT_NEEDED,
-					    &ha->dpc_flags);
-				}
-				clear_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags);
-			}
-
-			for_each_mapped_vp_idx(ha, i) {
-				list_for_each_entry(vha, &ha->vp_list,
-				    vp_list) {
-					if (i == vha->vp_idx) {
-						set_bit(ISP_ABORT_NEEDED,
-						    &vha->dpc_flags);
-						break;
-					}
+					    &base_vha->dpc_flags);
 				}
+				clear_bit(ABORT_ISP_ACTIVE,
+						&base_vha->dpc_flags);
 			}
 
 			DEBUG(printk("scsi(%ld): dpc: qla2x00_abort_isp end\n",
-			    ha->host_no));
+			    base_vha->host_no));
 		}
 
-		if (test_bit(FCPORT_UPDATE_NEEDED, &ha->dpc_flags)) {
-			qla2x00_update_fcports(ha);
-			clear_bit(FCPORT_UPDATE_NEEDED, &ha->dpc_flags);
+		if (test_bit(FCPORT_UPDATE_NEEDED, &base_vha->dpc_flags)) {
+			qla2x00_update_fcports(base_vha);
+			clear_bit(FCPORT_UPDATE_NEEDED, &base_vha->dpc_flags);
 		}
 
-		if (test_and_clear_bit(RESET_MARKER_NEEDED, &ha->dpc_flags) &&
-		    (!(test_and_set_bit(RESET_ACTIVE, &ha->dpc_flags)))) {
+		if (test_and_clear_bit(RESET_MARKER_NEEDED,
+							&base_vha->dpc_flags) &&
+		    (!(test_and_set_bit(RESET_ACTIVE, &base_vha->dpc_flags)))) {
 
 			DEBUG(printk("scsi(%ld): qla2x00_reset_marker()\n",
-			    ha->host_no));
+			    base_vha->host_no));
 
-			qla2x00_rst_aen(ha);
-			clear_bit(RESET_ACTIVE, &ha->dpc_flags);
+			qla2x00_rst_aen(base_vha);
+			clear_bit(RESET_ACTIVE, &base_vha->dpc_flags);
 		}
 
 		/* Retry each device up to login retry count */
-		if ((test_and_clear_bit(RELOGIN_NEEDED, &ha->dpc_flags)) &&
-		    !test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags) &&
-		    atomic_read(&ha->loop_state) != LOOP_DOWN) {
+		if ((test_and_clear_bit(RELOGIN_NEEDED,
+						&base_vha->dpc_flags)) &&
+		    !test_bit(LOOP_RESYNC_NEEDED, &base_vha->dpc_flags) &&
+		    atomic_read(&base_vha->loop_state) != LOOP_DOWN) {
 
 			DEBUG(printk("scsi(%ld): qla2x00_port_login()\n",
-			    ha->host_no));
-
-			next_loopid = 0;
-			list_for_each_entry(fcport, &ha->fcports, list) {
-				/*
-				 * If the port is not ONLINE then try to login
-				 * to it if we haven't run out of retries.
-				 */
-				if (atomic_read(&fcport->state) != FCS_ONLINE &&
-				    fcport->login_retry) {
-
-					if (fcport->flags & FCF_FABRIC_DEVICE) {
-						if (fcport->flags &
-						    FCF_TAPE_PRESENT)
-							ha->isp_ops->fabric_logout(
-							    ha, fcport->loop_id,
-							    fcport->d_id.b.domain,
-							    fcport->d_id.b.area,
-							    fcport->d_id.b.al_pa);
-						status = qla2x00_fabric_login(
-						    ha, fcport, &next_loopid);
-					} else
-						status =
-						    qla2x00_local_device_login(
-							ha, fcport);
-
-					fcport->login_retry--;
-					if (status == QLA_SUCCESS) {
-						fcport->old_loop_id = fcport->loop_id;
-
-						DEBUG(printk("scsi(%ld): port login OK: logged in ID 0x%x\n",
-						    ha->host_no, fcport->loop_id));
-
-						qla2x00_update_fcport(ha,
-						    fcport);
-					} else if (status == 1) {
-						set_bit(RELOGIN_NEEDED, &ha->dpc_flags);
-						/* retry the login again */
-						DEBUG(printk("scsi(%ld): Retrying %d login again loop_id 0x%x\n",
-						    ha->host_no,
-						    fcport->login_retry, fcport->loop_id));
-					} else {
-						fcport->login_retry = 0;
-					}
-					if (fcport->login_retry == 0 && status != QLA_SUCCESS)
-						fcport->loop_id = FC_NO_LOOP_ID;
-				}
-				if (test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags))
-					break;
-			}
+					base_vha->host_no));
+			qla2x00_relogin(base_vha);
+
 			DEBUG(printk("scsi(%ld): qla2x00_port_login - end\n",
-			    ha->host_no));
+			    base_vha->host_no));
 		}
 
-		if (test_and_clear_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags)) {
+		if (test_and_clear_bit(LOOP_RESYNC_NEEDED,
+							&base_vha->dpc_flags)) {
 
 			DEBUG(printk("scsi(%ld): qla2x00_loop_resync()\n",
-			    ha->host_no));
+				base_vha->host_no));
 
 			if (!(test_and_set_bit(LOOP_RESYNC_ACTIVE,
-			    &ha->dpc_flags))) {
+			    &base_vha->dpc_flags))) {
 
-				rval = qla2x00_loop_resync(ha);
+				rval = qla2x00_loop_resync(base_vha);
 
-				clear_bit(LOOP_RESYNC_ACTIVE, &ha->dpc_flags);
+				clear_bit(LOOP_RESYNC_ACTIVE,
+						&base_vha->dpc_flags);
 			}
 
 			DEBUG(printk("scsi(%ld): qla2x00_loop_resync - end\n",
-			    ha->host_no));
+			    base_vha->host_no));
 		}
 
-		if (test_bit(NPIV_CONFIG_NEEDED, &ha->dpc_flags) &&
-		    atomic_read(&ha->loop_state) == LOOP_READY) {
-			clear_bit(NPIV_CONFIG_NEEDED, &ha->dpc_flags);
-			qla2xxx_flash_npiv_conf(ha);
+		if (test_bit(NPIV_CONFIG_NEEDED, &base_vha->dpc_flags) &&
+		    atomic_read(&base_vha->loop_state) == LOOP_READY) {
+			clear_bit(NPIV_CONFIG_NEEDED, &base_vha->dpc_flags);
+			qla2xxx_flash_npiv_conf(base_vha);
 		}
 
 		if (!ha->interrupts_on)
 			ha->isp_ops->enable_intrs(ha);
 
-		if (test_and_clear_bit(BEACON_BLINK_NEEDED, &ha->dpc_flags))
-			ha->isp_ops->beacon_blink(ha);
+		if (test_and_clear_bit(BEACON_BLINK_NEEDED,
+					&base_vha->dpc_flags))
+			ha->isp_ops->beacon_blink(base_vha);
 
-		qla2x00_do_dpc_all_vps(ha);
+		qla2x00_do_dpc_all_vps(base_vha);
 
 		ha->dpc_active = 0;
 	} /* End of while(1) */
 
-	DEBUG(printk("scsi(%ld): DPC handler exiting\n", ha->host_no));
+	DEBUG(printk("scsi(%ld): DPC handler exiting\n", base_vha->host_no));
 
 	/*
 	 * Make sure that nobody tries to wake us up again.
@@ -2460,11 +2583,12 @@ qla2x00_do_dpc(void *data)
 }
 
 void
-qla2xxx_wake_dpc(scsi_qla_host_t *ha)
+qla2xxx_wake_dpc(struct scsi_qla_host *vha)
 {
+	struct qla_hw_data *ha = vha->hw;
 	struct task_struct *t = ha->dpc_thread;
 
-	if (!test_bit(UNLOADING, &ha->dpc_flags) && t)
+	if (!test_bit(UNLOADING, &vha->dpc_flags) && t)
 		wake_up_process(t);
 }
 
@@ -2476,26 +2600,26 @@ qla2xxx_wake_dpc(scsi_qla_host_t *ha)
 *      ha  = adapter block pointer.
 */
 static void
-qla2x00_rst_aen(scsi_qla_host_t *ha)
+qla2x00_rst_aen(scsi_qla_host_t *vha)
 {
-	if (ha->flags.online && !ha->flags.reset_active &&
-	    !atomic_read(&ha->loop_down_timer) &&
-	    !(test_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags))) {
+	if (vha->flags.online && !vha->flags.reset_active &&
+	    !atomic_read(&vha->loop_down_timer) &&
+	    !(test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags))) {
 		do {
-			clear_bit(RESET_MARKER_NEEDED, &ha->dpc_flags);
+			clear_bit(RESET_MARKER_NEEDED, &vha->dpc_flags);
 
 			/*
 			 * Issue marker command only when we are going to start
 			 * the I/O.
 			 */
-			ha->marker_needed = 1;
-		} while (!atomic_read(&ha->loop_down_timer) &&
-		    (test_bit(RESET_MARKER_NEEDED, &ha->dpc_flags)));
+			vha->marker_needed = 1;
+		} while (!atomic_read(&vha->loop_down_timer) &&
+		    (test_bit(RESET_MARKER_NEEDED, &vha->dpc_flags)));
 	}
 }
 
 static void
-qla2x00_sp_free_dma(scsi_qla_host_t *ha, srb_t *sp)
+qla2x00_sp_free_dma(srb_t *sp)
 {
 	struct scsi_cmnd *cmd = sp->cmd;
 
@@ -2507,11 +2631,12 @@ qla2x00_sp_free_dma(scsi_qla_host_t *ha, srb_t *sp)
 }
 
 void
-qla2x00_sp_compl(scsi_qla_host_t *ha, srb_t *sp)
+qla2x00_sp_compl(scsi_qla_host_t *vha, srb_t *sp)
 {
+	struct qla_hw_data *ha = vha->hw;
 	struct scsi_cmnd *cmd = sp->cmd;
 
-	qla2x00_sp_free_dma(ha, sp);
+	qla2x00_sp_free_dma(sp);
 
 	mempool_free(sp, ha->srb_mempool);
 
@@ -2527,7 +2652,7 @@ qla2x00_sp_compl(scsi_qla_host_t *ha, srb_t *sp)
 * Context: Interrupt
 ***************************************************************************/
 void
-qla2x00_timer(scsi_qla_host_t *ha)
+qla2x00_timer(scsi_qla_host_t *vha)
 {
 	unsigned long	cpu_flags = 0;
 	fc_port_t	*fcport;
@@ -2535,8 +2660,8 @@ qla2x00_timer(scsi_qla_host_t *ha)
 	int		index;
 	srb_t		*sp;
 	int		t;
-	scsi_qla_host_t *pha = to_qla_parent(ha);
-
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req;
 	/*
 	 * Ports - Port down timer.
 	 *
@@ -2545,7 +2670,7 @@ qla2x00_timer(scsi_qla_host_t *ha)
 	 * the port it marked DEAD.
 	 */
 	t = 0;
-	list_for_each_entry(fcport, &ha->fcports, list) {
+	list_for_each_entry(fcport, &vha->vp_fcports, list) {
 		if (fcport->port_type != FCT_TARGET)
 			continue;
 
@@ -2559,7 +2684,7 @@ qla2x00_timer(scsi_qla_host_t *ha)
 
 			DEBUG(printk("scsi(%ld): fcport-%d - port retry count: "
 			    "%d remaining\n",
-			    ha->host_no,
+			    vha->host_no,
 			    t, atomic_read(&fcport->port_down_timer)));
 		}
 		t++;
@@ -2567,22 +2692,23 @@ qla2x00_timer(scsi_qla_host_t *ha)
 
 
 	/* Loop down handler. */
-	if (atomic_read(&ha->loop_down_timer) > 0 &&
-	    !(test_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags)) && ha->flags.online) {
+	if (atomic_read(&vha->loop_down_timer) > 0 &&
+	    !(test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags))
+		&& vha->flags.online) {
 
-		if (atomic_read(&ha->loop_down_timer) ==
-		    ha->loop_down_abort_time) {
+		if (atomic_read(&vha->loop_down_timer) ==
+		    vha->loop_down_abort_time) {
 
 			DEBUG(printk("scsi(%ld): Loop Down - aborting the "
 			    "queues before time expire\n",
-			    ha->host_no));
+			    vha->host_no));
 
-			if (!IS_QLA2100(ha) && ha->link_down_timeout)
-				atomic_set(&ha->loop_state, LOOP_DEAD);
+			if (!IS_QLA2100(ha) && vha->link_down_timeout)
+				atomic_set(&vha->loop_state, LOOP_DEAD);
 
 			/* Schedule an ISP abort to return any tape commands. */
 			/* NPIV - scan physical port only */
-			if (!ha->parent) {
+			if (!vha->vp_idx) {
 				spin_lock_irqsave(&ha->hardware_lock,
 				    cpu_flags);
 				for (index = 1;
@@ -2590,7 +2716,7 @@ qla2x00_timer(scsi_qla_host_t *ha)
 				    index++) {
 					fc_port_t *sfcp;
 
-					sp = ha->outstanding_cmds[index];
+					sp = req->outstanding_cmds[index];
 					if (!sp)
 						continue;
 					sfcp = sp->fcport;
@@ -2598,63 +2724,63 @@ qla2x00_timer(scsi_qla_host_t *ha)
 						continue;
 
 					set_bit(ISP_ABORT_NEEDED,
-					    &ha->dpc_flags);
+							&vha->dpc_flags);
 					break;
 				}
 				spin_unlock_irqrestore(&ha->hardware_lock,
-				    cpu_flags);
+								cpu_flags);
 			}
-			set_bit(ABORT_QUEUES_NEEDED, &ha->dpc_flags);
+			set_bit(ABORT_QUEUES_NEEDED, &vha->dpc_flags);
 			start_dpc++;
 		}
 
 		/* if the loop has been down for 4 minutes, reinit adapter */
-		if (atomic_dec_and_test(&ha->loop_down_timer) != 0) {
+		if (atomic_dec_and_test(&vha->loop_down_timer) != 0) {
 			DEBUG(printk("scsi(%ld): Loop down exceed 4 mins - "
 			    "restarting queues.\n",
-			    ha->host_no));
+			    vha->host_no));
 
-			set_bit(RESTART_QUEUES_NEEDED, &ha->dpc_flags);
+			set_bit(RESTART_QUEUES_NEEDED, &vha->dpc_flags);
 			start_dpc++;
 
-			if (!(ha->device_flags & DFLG_NO_CABLE) &&
-			    !ha->parent) {
+			if (!(vha->device_flags & DFLG_NO_CABLE) &&
+			    !vha->vp_idx) {
 				DEBUG(printk("scsi(%ld): Loop down - "
 				    "aborting ISP.\n",
-				    ha->host_no));
+				    vha->host_no));
 				qla_printk(KERN_WARNING, ha,
 				    "Loop down - aborting ISP.\n");
 
-				set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+				set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 			}
 		}
 		DEBUG3(printk("scsi(%ld): Loop Down - seconds remaining %d\n",
-		    ha->host_no,
-		    atomic_read(&ha->loop_down_timer)));
+		    vha->host_no,
+		    atomic_read(&vha->loop_down_timer)));
 	}
 
 	/* Check if beacon LED needs to be blinked */
 	if (ha->beacon_blink_led == 1) {
-		set_bit(BEACON_BLINK_NEEDED, &ha->dpc_flags);
+		set_bit(BEACON_BLINK_NEEDED, &vha->dpc_flags);
 		start_dpc++;
 	}
 
 	/* Process any deferred work. */
-	if (!list_empty(&ha->work_list))
+	if (!list_empty(&vha->work_list))
 		start_dpc++;
 
 	/* Schedule the DPC routine if needed */
-	if ((test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags) ||
-	    test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags) ||
-	    test_bit(FCPORT_UPDATE_NEEDED, &ha->dpc_flags) ||
+	if ((test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags) ||
+	    test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags) ||
+	    test_bit(FCPORT_UPDATE_NEEDED, &vha->dpc_flags) ||
 	    start_dpc ||
-	    test_bit(RESET_MARKER_NEEDED, &ha->dpc_flags) ||
-	    test_bit(BEACON_BLINK_NEEDED, &ha->dpc_flags) ||
-	    test_bit(VP_DPC_NEEDED, &ha->dpc_flags) ||
-	    test_bit(RELOGIN_NEEDED, &ha->dpc_flags)))
-		qla2xxx_wake_dpc(pha);
+	    test_bit(RESET_MARKER_NEEDED, &vha->dpc_flags) ||
+	    test_bit(BEACON_BLINK_NEEDED, &vha->dpc_flags) ||
+	    test_bit(VP_DPC_NEEDED, &vha->dpc_flags) ||
+	    test_bit(RELOGIN_NEEDED, &vha->dpc_flags)))
+		qla2xxx_wake_dpc(vha);
 
-	qla2x00_restart_timer(ha, WATCH_INTERVAL);
+	qla2x00_restart_timer(vha, WATCH_INTERVAL);
 }
 
 /* Firmware interface routines. */
@@ -2686,8 +2812,9 @@ static struct fw_blob qla_fw_blobs[FW_BLOBS] = {
 };
 
 struct fw_blob *
-qla2x00_request_firmware(scsi_qla_host_t *ha)
+qla2x00_request_firmware(scsi_qla_host_t *vha)
 {
+	struct qla_hw_data *ha = vha->hw;
 	struct fw_blob *blob;
 
 	blob = NULL;
@@ -2711,7 +2838,7 @@ qla2x00_request_firmware(scsi_qla_host_t *ha)
 
 	if (request_firmware(&blob->fw, blob->name, &ha->pdev->dev)) {
 		DEBUG2(printk("scsi(%ld): Failed to load firmware image "
-		    "(%s).\n", ha->host_no, blob->name));
+		    "(%s).\n", vha->host_no, blob->name));
 		blob->fw = NULL;
 		blob = NULL;
 		goto out;
@@ -2756,7 +2883,8 @@ qla2xxx_pci_mmio_enabled(struct pci_dev *pdev)
 	int risc_paused = 0;
 	uint32_t stat;
 	unsigned long flags;
-	scsi_qla_host_t *ha = pci_get_drvdata(pdev);
+	scsi_qla_host_t *base_vha = pci_get_drvdata(pdev);
+	struct qla_hw_data *ha = base_vha->hw;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	struct device_reg_24xx __iomem *reg24 = &ha->iobase->isp24;
 
@@ -2779,7 +2907,7 @@ qla2xxx_pci_mmio_enabled(struct pci_dev *pdev)
 	if (risc_paused) {
 		qla_printk(KERN_INFO, ha, "RISC paused -- mmio_enabled, "
 		    "Dumping firmware!\n");
-		ha->isp_ops->fw_dump(ha, 0);
+		ha->isp_ops->fw_dump(base_vha, 0);
 
 		return PCI_ERS_RESULT_NEED_RESET;
 	} else
@@ -2790,7 +2918,8 @@ static pci_ers_result_t
 qla2xxx_pci_slot_reset(struct pci_dev *pdev)
 {
 	pci_ers_result_t ret = PCI_ERS_RESULT_DISCONNECT;
-	scsi_qla_host_t *ha = pci_get_drvdata(pdev);
+	scsi_qla_host_t *base_vha = pci_get_drvdata(pdev);
+	struct qla_hw_data *ha = base_vha->hw;
 	int rc;
 
 	if (ha->mem_only)
@@ -2806,13 +2935,13 @@ qla2xxx_pci_slot_reset(struct pci_dev *pdev)
 	}
 	pci_set_master(pdev);
 
-	if (ha->isp_ops->pci_config(ha))
+	if (ha->isp_ops->pci_config(base_vha))
 		return ret;
 
-	set_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags);
-	if (qla2x00_abort_isp(ha)== QLA_SUCCESS)
+	set_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
+	if (qla2x00_abort_isp(base_vha) == QLA_SUCCESS)
 		ret =  PCI_ERS_RESULT_RECOVERED;
-	clear_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags);
+	clear_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
 
 	return ret;
 }
@@ -2820,10 +2949,11 @@ qla2xxx_pci_slot_reset(struct pci_dev *pdev)
 static void
 qla2xxx_pci_resume(struct pci_dev *pdev)
 {
-	scsi_qla_host_t *ha = pci_get_drvdata(pdev);
+	scsi_qla_host_t *base_vha = pci_get_drvdata(pdev);
+	struct qla_hw_data *ha = base_vha->hw;
 	int ret;
 
-	ret = qla2x00_wait_for_hba_online(ha);
+	ret = qla2x00_wait_for_hba_online(base_vha);
 	if (ret != QLA_SUCCESS) {
 		qla_printk(KERN_ERR, ha,
 		    "the device failed to resume I/O "
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 90a1321..376cd2a 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -10,10 +10,6 @@
 #include <linux/vmalloc.h>
 #include <asm/uaccess.h>
 
-static uint16_t qla2x00_nvram_request(scsi_qla_host_t *, uint32_t);
-static void qla2x00_nv_deselect(scsi_qla_host_t *);
-static void qla2x00_nv_write(scsi_qla_host_t *, uint16_t);
-
 /*
  * NVRAM support routines
  */
@@ -23,7 +19,7 @@ static void qla2x00_nv_write(scsi_qla_host_t *, uint16_t);
  * @ha: HA context
  */
 static void
-qla2x00_lock_nvram_access(scsi_qla_host_t *ha)
+qla2x00_lock_nvram_access(struct qla_hw_data *ha)
 {
 	uint16_t data;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
@@ -56,7 +52,7 @@ qla2x00_lock_nvram_access(scsi_qla_host_t *ha)
  * @ha: HA context
  */
 static void
-qla2x00_unlock_nvram_access(scsi_qla_host_t *ha)
+qla2x00_unlock_nvram_access(struct qla_hw_data *ha)
 {
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
@@ -67,6 +63,84 @@ qla2x00_unlock_nvram_access(scsi_qla_host_t *ha)
 }
 
 /**
+ * qla2x00_nv_write() - Prepare for NVRAM read/write operation.
+ * @ha: HA context
+ * @data: Serial interface selector
+ */
+static void
+qla2x00_nv_write(struct qla_hw_data *ha, uint16_t data)
+{
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
+
+	WRT_REG_WORD(&reg->nvram, data | NVR_SELECT | NVR_WRT_ENABLE);
+	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
+	NVRAM_DELAY();
+	WRT_REG_WORD(&reg->nvram, data | NVR_SELECT | NVR_CLOCK |
+	    NVR_WRT_ENABLE);
+	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
+	NVRAM_DELAY();
+	WRT_REG_WORD(&reg->nvram, data | NVR_SELECT | NVR_WRT_ENABLE);
+	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
+	NVRAM_DELAY();
+}
+
+/**
+ * qla2x00_nvram_request() - Sends read command to NVRAM and gets data from
+ *	NVRAM.
+ * @ha: HA context
+ * @nv_cmd: NVRAM command
+ *
+ * Bit definitions for NVRAM command:
+ *
+ *	Bit 26     = start bit
+ *	Bit 25, 24 = opcode
+ *	Bit 23-16  = address
+ *	Bit 15-0   = write data
+ *
+ * Returns the word read from nvram @addr.
+ */
+static uint16_t
+qla2x00_nvram_request(struct qla_hw_data *ha, uint32_t nv_cmd)
+{
+	uint8_t		cnt;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
+	uint16_t	data = 0;
+	uint16_t	reg_data;
+
+	/* Send command to NVRAM. */
+	nv_cmd <<= 5;
+	for (cnt = 0; cnt < 11; cnt++) {
+		if (nv_cmd & BIT_31)
+			qla2x00_nv_write(ha, NVR_DATA_OUT);
+		else
+			qla2x00_nv_write(ha, 0);
+		nv_cmd <<= 1;
+	}
+
+	/* Read data from NVRAM. */
+	for (cnt = 0; cnt < 16; cnt++) {
+		WRT_REG_WORD(&reg->nvram, NVR_SELECT | NVR_CLOCK);
+		RD_REG_WORD(&reg->nvram);	/* PCI Posting. */
+		NVRAM_DELAY();
+		data <<= 1;
+		reg_data = RD_REG_WORD(&reg->nvram);
+		if (reg_data & NVR_DATA_IN)
+			data |= BIT_0;
+		WRT_REG_WORD(&reg->nvram, NVR_SELECT);
+		RD_REG_WORD(&reg->nvram);	/* PCI Posting. */
+		NVRAM_DELAY();
+	}
+
+	/* Deselect chip. */
+	WRT_REG_WORD(&reg->nvram, NVR_DESELECT);
+	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
+	NVRAM_DELAY();
+
+	return data;
+}
+
+
+/**
  * qla2x00_get_nvram_word() - Calculates word position in NVRAM and calls the
  *	request routine to get the word from NVRAM.
  * @ha: HA context
@@ -75,7 +149,7 @@ qla2x00_unlock_nvram_access(scsi_qla_host_t *ha)
  * Returns the word read from nvram @addr.
  */
 static uint16_t
-qla2x00_get_nvram_word(scsi_qla_host_t *ha, uint32_t addr)
+qla2x00_get_nvram_word(struct qla_hw_data *ha, uint32_t addr)
 {
 	uint16_t	data;
 	uint32_t	nv_cmd;
@@ -88,13 +162,27 @@ qla2x00_get_nvram_word(scsi_qla_host_t *ha, uint32_t addr)
 }
 
 /**
+ * qla2x00_nv_deselect() - Deselect NVRAM operations.
+ * @ha: HA context
+ */
+static void
+qla2x00_nv_deselect(struct qla_hw_data *ha)
+{
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
+
+	WRT_REG_WORD(&reg->nvram, NVR_DESELECT);
+	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
+	NVRAM_DELAY();
+}
+
+/**
  * qla2x00_write_nvram_word() - Write NVRAM data.
  * @ha: HA context
  * @addr: Address in NVRAM to write
  * @data: word to program
  */
 static void
-qla2x00_write_nvram_word(scsi_qla_host_t *ha, uint32_t addr, uint16_t data)
+qla2x00_write_nvram_word(struct qla_hw_data *ha, uint32_t addr, uint16_t data)
 {
 	int count;
 	uint16_t word;
@@ -132,7 +220,7 @@ qla2x00_write_nvram_word(scsi_qla_host_t *ha, uint32_t addr, uint16_t data)
 	do {
 		if (!--wait_cnt) {
 			DEBUG9_10(printk("%s(%ld): NVRAM didn't go ready...\n",
-			    __func__, ha->host_no));
+			    __func__, vha->host_no));
 			break;
 		}
 		NVRAM_DELAY();
@@ -150,8 +238,8 @@ qla2x00_write_nvram_word(scsi_qla_host_t *ha, uint32_t addr, uint16_t data)
 }
 
 static int
-qla2x00_write_nvram_word_tmo(scsi_qla_host_t *ha, uint32_t addr, uint16_t data,
-    uint32_t tmo)
+qla2x00_write_nvram_word_tmo(struct qla_hw_data *ha, uint32_t addr,
+	uint16_t data, uint32_t tmo)
 {
 	int ret, count;
 	uint16_t word;
@@ -209,102 +297,11 @@ qla2x00_write_nvram_word_tmo(scsi_qla_host_t *ha, uint32_t addr, uint16_t data,
 }
 
 /**
- * qla2x00_nvram_request() - Sends read command to NVRAM and gets data from
- *	NVRAM.
- * @ha: HA context
- * @nv_cmd: NVRAM command
- *
- * Bit definitions for NVRAM command:
- *
- *	Bit 26     = start bit
- *	Bit 25, 24 = opcode
- *	Bit 23-16  = address
- *	Bit 15-0   = write data
- *
- * Returns the word read from nvram @addr.
- */
-static uint16_t
-qla2x00_nvram_request(scsi_qla_host_t *ha, uint32_t nv_cmd)
-{
-	uint8_t		cnt;
-	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
-	uint16_t	data = 0;
-	uint16_t	reg_data;
-
-	/* Send command to NVRAM. */
-	nv_cmd <<= 5;
-	for (cnt = 0; cnt < 11; cnt++) {
-		if (nv_cmd & BIT_31)
-			qla2x00_nv_write(ha, NVR_DATA_OUT);
-		else
-			qla2x00_nv_write(ha, 0);
-		nv_cmd <<= 1;
-	}
-
-	/* Read data from NVRAM. */
-	for (cnt = 0; cnt < 16; cnt++) {
-		WRT_REG_WORD(&reg->nvram, NVR_SELECT | NVR_CLOCK);
-		RD_REG_WORD(&reg->nvram);	/* PCI Posting. */
-		NVRAM_DELAY();
-		data <<= 1;
-		reg_data = RD_REG_WORD(&reg->nvram);
-		if (reg_data & NVR_DATA_IN)
-			data |= BIT_0;
-		WRT_REG_WORD(&reg->nvram, NVR_SELECT);
-		RD_REG_WORD(&reg->nvram);	/* PCI Posting. */
-		NVRAM_DELAY();
-	}
-
-	/* Deselect chip. */
-	WRT_REG_WORD(&reg->nvram, NVR_DESELECT);
-	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
-	NVRAM_DELAY();
-
-	return (data);
-}
-
-/**
- * qla2x00_nv_write() - Clean NVRAM operations.
- * @ha: HA context
- */
-static void
-qla2x00_nv_deselect(scsi_qla_host_t *ha)
-{
-	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
-
-	WRT_REG_WORD(&reg->nvram, NVR_DESELECT);
-	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
-	NVRAM_DELAY();
-}
-
-/**
- * qla2x00_nv_write() - Prepare for NVRAM read/write operation.
- * @ha: HA context
- * @data: Serial interface selector
- */
-static void
-qla2x00_nv_write(scsi_qla_host_t *ha, uint16_t data)
-{
-	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
-
-	WRT_REG_WORD(&reg->nvram, data | NVR_SELECT | NVR_WRT_ENABLE);
-	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
-	NVRAM_DELAY();
-	WRT_REG_WORD(&reg->nvram, data | NVR_SELECT| NVR_CLOCK |
-	    NVR_WRT_ENABLE);
-	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
-	NVRAM_DELAY();
-	WRT_REG_WORD(&reg->nvram, data | NVR_SELECT | NVR_WRT_ENABLE);
-	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
-	NVRAM_DELAY();
-}
-
-/**
  * qla2x00_clear_nvram_protection() -
  * @ha: HA context
  */
 static int
-qla2x00_clear_nvram_protection(scsi_qla_host_t *ha)
+qla2x00_clear_nvram_protection(struct qla_hw_data *ha)
 {
 	int ret, stat;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
@@ -352,9 +349,8 @@ qla2x00_clear_nvram_protection(scsi_qla_host_t *ha)
 		wait_cnt = NVR_WAIT_CNT;
 		do {
 			if (!--wait_cnt) {
-				DEBUG9_10(printk("%s(%ld): NVRAM didn't go "
-				    "ready...\n", __func__,
-				    ha->host_no));
+				DEBUG9_10(qla_printk(
+				    "NVRAM didn't go ready...\n"));
 				break;
 			}
 			NVRAM_DELAY();
@@ -370,7 +366,7 @@ qla2x00_clear_nvram_protection(scsi_qla_host_t *ha)
 }
 
 static void
-qla2x00_set_nvram_protection(scsi_qla_host_t *ha, int stat)
+qla2x00_set_nvram_protection(struct qla_hw_data *ha, int stat)
 {
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	uint32_t word, wait_cnt;
@@ -412,8 +408,7 @@ qla2x00_set_nvram_protection(scsi_qla_host_t *ha, int stat)
 	wait_cnt = NVR_WAIT_CNT;
 	do {
 		if (!--wait_cnt) {
-			DEBUG9_10(printk("%s(%ld): NVRAM didn't go ready...\n",
-			    __func__, ha->host_no));
+			DEBUG9_10(qla_printk("NVRAM didn't go ready...\n"));
 			break;
 		}
 		NVRAM_DELAY();
@@ -454,7 +449,7 @@ nvram_data_to_access_addr(uint32_t naddr)
 }
 
 static uint32_t
-qla24xx_read_flash_dword(scsi_qla_host_t *ha, uint32_t addr)
+qla24xx_read_flash_dword(struct qla_hw_data *ha, uint32_t addr)
 {
 	int rval;
 	uint32_t cnt, data;
@@ -482,21 +477,20 @@ qla24xx_read_flash_dword(scsi_qla_host_t *ha, uint32_t addr)
 }
 
 uint32_t *
-qla24xx_read_flash_data(scsi_qla_host_t *ha, uint32_t *dwptr, uint32_t faddr,
+qla24xx_read_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
     uint32_t dwords)
 {
 	uint32_t i;
-
 	/* Dword reads to flash. */
 	for (i = 0; i < dwords; i++, faddr++)
-		dwptr[i] = cpu_to_le32(qla24xx_read_flash_dword(ha,
+		dwptr[i] = cpu_to_le32(qla24xx_read_flash_dword(vha->hw,
 		    flash_data_to_access_addr(faddr)));
 
 	return dwptr;
 }
 
 static int
-qla24xx_write_flash_dword(scsi_qla_host_t *ha, uint32_t addr, uint32_t data)
+qla24xx_write_flash_dword(struct qla_hw_data *ha, uint32_t addr, uint32_t data)
 {
 	int rval;
 	uint32_t cnt;
@@ -519,7 +513,7 @@ qla24xx_write_flash_dword(scsi_qla_host_t *ha, uint32_t addr, uint32_t data)
 }
 
 static void
-qla24xx_get_flash_manufacturer(scsi_qla_host_t *ha, uint8_t *man_id,
+qla24xx_get_flash_manufacturer(struct qla_hw_data *ha, uint8_t *man_id,
     uint8_t *flash_id)
 {
 	uint32_t ids;
@@ -544,7 +538,7 @@ qla24xx_get_flash_manufacturer(scsi_qla_host_t *ha, uint8_t *man_id,
 }
 
 static int
-qla2xxx_find_flt_start(scsi_qla_host_t *ha, uint32_t *start)
+qla2xxx_find_flt_start(scsi_qla_host_t *vha, uint32_t *start)
 {
 	const char *loc, *locations[] = { "DEF", "PCI" };
 	uint32_t pcihdr, pcids;
@@ -552,6 +546,8 @@ qla2xxx_find_flt_start(scsi_qla_host_t *ha, uint32_t *start)
 	uint8_t *buf, *bcode, last_image;
 	uint16_t cnt, chksum, *wptr;
 	struct qla_flt_location *fltl;
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req;
 
 	/*
 	 * FLT-location structure resides after the last PCI region.
@@ -563,20 +559,20 @@ qla2xxx_find_flt_start(scsi_qla_host_t *ha, uint32_t *start)
 	    FA_FLASH_LAYOUT_ADDR;
 
 	/* Begin with first PCI expansion ROM header. */
-	buf = (uint8_t *)ha->request_ring;
-	dcode = (uint32_t *)ha->request_ring;
+	buf = (uint8_t *)req->ring;
+	dcode = (uint32_t *)req->ring;
 	pcihdr = 0;
 	last_image = 1;
 	do {
 		/* Verify PCI expansion ROM header. */
-		qla24xx_read_flash_data(ha, dcode, pcihdr >> 2, 0x20);
+		qla24xx_read_flash_data(vha, dcode, pcihdr >> 2, 0x20);
 		bcode = buf + (pcihdr % 4);
 		if (bcode[0x0] != 0x55 || bcode[0x1] != 0xaa)
 			goto end;
 
 		/* Locate PCI data structure. */
 		pcids = pcihdr + ((bcode[0x19] << 8) | bcode[0x18]);
-		qla24xx_read_flash_data(ha, dcode, pcids >> 2, 0x20);
+		qla24xx_read_flash_data(vha, dcode, pcids >> 2, 0x20);
 		bcode = buf + (pcihdr % 4);
 
 		/* Validate signature of PCI data structure. */
@@ -591,14 +587,14 @@ qla2xxx_find_flt_start(scsi_qla_host_t *ha, uint32_t *start)
 	} while (!last_image);
 
 	/* Now verify FLT-location structure. */
-	fltl = (struct qla_flt_location *)ha->request_ring;
-	qla24xx_read_flash_data(ha, dcode, pcihdr >> 2,
+	fltl = (struct qla_flt_location *)req->ring;
+	qla24xx_read_flash_data(vha, dcode, pcihdr >> 2,
 	    sizeof(struct qla_flt_location) >> 2);
 	if (fltl->sig[0] != 'Q' || fltl->sig[1] != 'F' ||
 	    fltl->sig[2] != 'L' || fltl->sig[3] != 'T')
 		goto end;
 
-	wptr = (uint16_t *)ha->request_ring;
+	wptr = (uint16_t *)req->ring;
 	cnt = sizeof(struct qla_flt_location) >> 1;
 	for (chksum = 0; cnt; cnt--)
 		chksum += le16_to_cpu(*wptr++);
@@ -619,7 +615,7 @@ end:
 }
 
 static void
-qla2xxx_get_flt_info(scsi_qla_host_t *ha, uint32_t flt_addr)
+qla2xxx_get_flt_info(scsi_qla_host_t *vha, uint32_t flt_addr)
 {
 	const char *loc, *locations[] = { "DEF", "FLT" };
 	uint16_t *wptr;
@@ -627,12 +623,14 @@ qla2xxx_get_flt_info(scsi_qla_host_t *ha, uint32_t flt_addr)
 	uint32_t start;
 	struct qla_flt_header *flt;
 	struct qla_flt_region *region;
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req;
 
 	ha->flt_region_flt = flt_addr;
-	wptr = (uint16_t *)ha->request_ring;
-	flt = (struct qla_flt_header *)ha->request_ring;
+	wptr = (uint16_t *)req->ring;
+	flt = (struct qla_flt_header *)req->ring;
 	region = (struct qla_flt_region *)&flt[1];
-	ha->isp_ops->read_optrom(ha, (uint8_t *)ha->request_ring,
+	ha->isp_ops->read_optrom(vha, (uint8_t *)req->ring,
 	    flt_addr << 2, OPTROM_BURST_SIZE);
 	if (*wptr == __constant_cpu_to_le16(0xffff))
 		goto no_flash_data;
@@ -720,7 +718,7 @@ done:
 }
 
 static void
-qla2xxx_get_fdt_info(scsi_qla_host_t *ha)
+qla2xxx_get_fdt_info(scsi_qla_host_t *vha)
 {
 #define FLASH_BLK_SIZE_32K	0x8000
 #define FLASH_BLK_SIZE_64K	0x10000
@@ -730,10 +728,12 @@ qla2xxx_get_fdt_info(scsi_qla_host_t *ha)
 	struct qla_fdt_layout *fdt;
 	uint8_t	man_id, flash_id;
 	uint16_t mid, fid;
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req;
 
-	wptr = (uint16_t *)ha->request_ring;
-	fdt = (struct qla_fdt_layout *)ha->request_ring;
-	ha->isp_ops->read_optrom(ha, (uint8_t *)ha->request_ring,
+	wptr = (uint16_t *)req->ring;
+	fdt = (struct qla_fdt_layout *)req->ring;
+	ha->isp_ops->read_optrom(vha, (uint8_t *)req->ring,
 	    ha->flt_region_fdt << 2, OPTROM_BURST_SIZE);
 	if (*wptr == __constant_cpu_to_le16(0xffff))
 		goto no_flash_data;
@@ -808,26 +808,27 @@ done:
 }
 
 int
-qla2xxx_get_flash_info(scsi_qla_host_t *ha)
+qla2xxx_get_flash_info(scsi_qla_host_t *vha)
 {
 	int ret;
 	uint32_t flt_addr;
+	struct qla_hw_data *ha = vha->hw;
 
 	if (!IS_QLA24XX_TYPE(ha) && !IS_QLA25XX(ha))
 		return QLA_SUCCESS;
 
-	ret = qla2xxx_find_flt_start(ha, &flt_addr);
+	ret = qla2xxx_find_flt_start(vha, &flt_addr);
 	if (ret != QLA_SUCCESS)
 		return ret;
 
-	qla2xxx_get_flt_info(ha, flt_addr);
-	qla2xxx_get_fdt_info(ha);
+	qla2xxx_get_flt_info(vha, flt_addr);
+	qla2xxx_get_fdt_info(vha);
 
 	return QLA_SUCCESS;
 }
 
 void
-qla2xxx_flash_npiv_conf(scsi_qla_host_t *ha)
+qla2xxx_flash_npiv_conf(scsi_qla_host_t *vha)
 {
 #define NPIV_CONFIG_SIZE	(16*1024)
 	void *data;
@@ -835,11 +836,12 @@ qla2xxx_flash_npiv_conf(scsi_qla_host_t *ha)
 	uint16_t cnt, chksum;
 	struct qla_npiv_header hdr;
 	struct qla_npiv_entry *entry;
+	struct qla_hw_data *ha = vha->hw;
 
 	if (!IS_QLA24XX_TYPE(ha) && !IS_QLA25XX(ha))
 		return;
 
-	ha->isp_ops->read_optrom(ha, (uint8_t *)&hdr,
+	ha->isp_ops->read_optrom(vha, (uint8_t *)&hdr,
 	    ha->flt_region_npiv_conf << 2, sizeof(struct qla_npiv_header));
 	if (hdr.version == __constant_cpu_to_le16(0xffff))
 		return;
@@ -858,7 +860,7 @@ qla2xxx_flash_npiv_conf(scsi_qla_host_t *ha)
 		return;
 	}
 
-	ha->isp_ops->read_optrom(ha, (uint8_t *)data,
+	ha->isp_ops->read_optrom(vha, (uint8_t *)data,
 	    ha->flt_region_npiv_conf << 2, NPIV_CONFIG_SIZE);
 
 	cnt = (sizeof(struct qla_npiv_header) + le16_to_cpu(hdr.entries) *
@@ -894,24 +896,22 @@ qla2xxx_flash_npiv_conf(scsi_qla_host_t *ha)
 		vid.node_name = wwn_to_u64(entry->node_name);
 
 		DEBUG2(qla_printk(KERN_DEBUG, ha, "NPIV[%02x]: wwpn=%llx "
-		    "wwnn=%llx vf_id=0x%x qos=0x%x.\n", cnt,
-		    (unsigned long long)vid.port_name,
-		    (unsigned long long)vid.node_name,
-		    le16_to_cpu(entry->vf_id), le16_to_cpu(entry->qos)));
+		    "wwnn=%llx vf_id=0x%x qos=0x%x.\n", cnt, vid.port_name,
+		    vid.node_name, le16_to_cpu(entry->vf_id),
+		    le16_to_cpu(entry->qos)));
 
-		vport = fc_vport_create(ha->host, 0, &vid);
+		vport = fc_vport_create(vha->host, 0, &vid);
 		if (!vport)
 			qla_printk(KERN_INFO, ha, "NPIV-Config: Failed to "
 			    "create vport [%02x]: wwpn=%llx wwnn=%llx.\n", cnt,
-			    (unsigned long long)vid.port_name,
-			    (unsigned long long)vid.node_name);
+			    vid.port_name, vid.node_name);
 	}
 done:
 	kfree(data);
 }
 
 static void
-qla24xx_unprotect_flash(scsi_qla_host_t *ha)
+qla24xx_unprotect_flash(struct qla_hw_data *ha)
 {
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 
@@ -930,7 +930,7 @@ qla24xx_unprotect_flash(scsi_qla_host_t *ha)
 }
 
 static void
-qla24xx_protect_flash(scsi_qla_host_t *ha)
+qla24xx_protect_flash(struct qla_hw_data *ha)
 {
 	uint32_t cnt;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
@@ -956,7 +956,7 @@ skip_wrt_protect:
 }
 
 static int
-qla24xx_write_flash_data(scsi_qla_host_t *ha, uint32_t *dwptr, uint32_t faddr,
+qla24xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
     uint32_t dwords)
 {
 	int ret;
@@ -966,6 +966,7 @@ qla24xx_write_flash_data(scsi_qla_host_t *ha, uint32_t *dwptr, uint32_t faddr,
 	dma_addr_t optrom_dma;
 	void *optrom = NULL;
 	uint32_t *s, *d;
+	struct qla_hw_data *ha = vha->hw;
 
 	ret = QLA_SUCCESS;
 
@@ -1007,9 +1008,8 @@ qla24xx_write_flash_data(scsi_qla_host_t *ha, uint32_t *dwptr, uint32_t faddr,
 			    (fdata & 0xff00) |((fdata << 16) &
 			    0xff0000) | ((fdata >> 16) & 0xff));
 			if (ret != QLA_SUCCESS) {
-				DEBUG9(printk("%s(%ld) Unable to flash "
-				    "sector: address=%x.\n", __func__,
-				    ha->host_no, faddr));
+				DEBUG9(qla_printk("Unable to flash sector: "
+				    "address=%x.\n", faddr));
 				break;
 			}
 		}
@@ -1021,7 +1021,7 @@ qla24xx_write_flash_data(scsi_qla_host_t *ha, uint32_t *dwptr, uint32_t faddr,
 			    miter < OPTROM_BURST_DWORDS; miter++, s++, d++)
 				*s = cpu_to_le32(*d);
 
-			ret = qla2x00_load_ram(ha, optrom_dma,
+			ret = qla2x00_load_ram(vha, optrom_dma,
 			    flash_data_to_access_addr(faddr),
 			    OPTROM_BURST_DWORDS);
 			if (ret != QLA_SUCCESS) {
@@ -1049,7 +1049,7 @@ qla24xx_write_flash_data(scsi_qla_host_t *ha, uint32_t *dwptr, uint32_t faddr,
 		if (ret != QLA_SUCCESS) {
 			DEBUG9(printk("%s(%ld) Unable to program flash "
 			    "address=%x data=%x.\n", __func__,
-			    ha->host_no, faddr, *dwptr));
+			    vha->host_no, faddr, *dwptr));
 			break;
 		}
 
@@ -1072,11 +1072,12 @@ qla24xx_write_flash_data(scsi_qla_host_t *ha, uint32_t *dwptr, uint32_t faddr,
 }
 
 uint8_t *
-qla2x00_read_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
+qla2x00_read_nvram_data(scsi_qla_host_t *vha, uint8_t *buf, uint32_t naddr,
     uint32_t bytes)
 {
 	uint32_t i;
 	uint16_t *wptr;
+	struct qla_hw_data *ha = vha->hw;
 
 	/* Word reads to NVRAM via registers. */
 	wptr = (uint16_t *)buf;
@@ -1090,7 +1091,7 @@ qla2x00_read_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
 }
 
 uint8_t *
-qla24xx_read_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
+qla24xx_read_nvram_data(scsi_qla_host_t *vha, uint8_t *buf, uint32_t naddr,
     uint32_t bytes)
 {
 	uint32_t i;
@@ -1099,20 +1100,21 @@ qla24xx_read_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
 	/* Dword reads to flash. */
 	dwptr = (uint32_t *)buf;
 	for (i = 0; i < bytes >> 2; i++, naddr++)
-		dwptr[i] = cpu_to_le32(qla24xx_read_flash_dword(ha,
+		dwptr[i] = cpu_to_le32(qla24xx_read_flash_dword(vha->hw,
 		    nvram_data_to_access_addr(naddr)));
 
 	return buf;
 }
 
 int
-qla2x00_write_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
+qla2x00_write_nvram_data(scsi_qla_host_t *vha, uint8_t *buf, uint32_t naddr,
     uint32_t bytes)
 {
 	int ret, stat;
 	uint32_t i;
 	uint16_t *wptr;
 	unsigned long flags;
+	struct qla_hw_data *ha = vha->hw;
 
 	ret = QLA_SUCCESS;
 
@@ -1139,12 +1141,13 @@ qla2x00_write_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
 }
 
 int
-qla24xx_write_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
+qla24xx_write_nvram_data(scsi_qla_host_t *vha, uint8_t *buf, uint32_t naddr,
     uint32_t bytes)
 {
 	int ret;
 	uint32_t i;
 	uint32_t *dwptr;
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 
 	ret = QLA_SUCCESS;
@@ -1167,9 +1170,8 @@ qla24xx_write_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
 		    nvram_data_to_access_addr(naddr),
 		    cpu_to_le32(*dwptr));
 		if (ret != QLA_SUCCESS) {
-			DEBUG9(printk("%s(%ld) Unable to program "
-			    "nvram address=%x data=%x.\n", __func__,
-			    ha->host_no, naddr, *dwptr));
+			DEBUG9(qla_printk("Unable to program nvram address=%x "
+			    "data=%x.\n", naddr, *dwptr));
 			break;
 		}
 	}
@@ -1187,11 +1189,12 @@ qla24xx_write_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
 }
 
 uint8_t *
-qla25xx_read_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
+qla25xx_read_nvram_data(scsi_qla_host_t *vha, uint8_t *buf, uint32_t naddr,
     uint32_t bytes)
 {
 	uint32_t i;
 	uint32_t *dwptr;
+	struct qla_hw_data *ha = vha->hw;
 
 	/* Dword reads to flash. */
 	dwptr = (uint32_t *)buf;
@@ -1204,19 +1207,20 @@ qla25xx_read_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
 }
 
 int
-qla25xx_write_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
+qla25xx_write_nvram_data(scsi_qla_host_t *vha, uint8_t *buf, uint32_t naddr,
     uint32_t bytes)
 {
+	struct qla_hw_data *ha = vha->hw;
 #define RMW_BUFFER_SIZE	(64 * 1024)
 	uint8_t *dbuf;
 
 	dbuf = vmalloc(RMW_BUFFER_SIZE);
 	if (!dbuf)
 		return QLA_MEMORY_ALLOC_FAILED;
-	ha->isp_ops->read_optrom(ha, dbuf, ha->flt_region_vpd_nvram << 2,
+	ha->isp_ops->read_optrom(vha, dbuf, ha->flt_region_vpd_nvram << 2,
 	    RMW_BUFFER_SIZE);
 	memcpy(dbuf + (naddr << 2), buf, bytes);
-	ha->isp_ops->write_optrom(ha, dbuf, ha->flt_region_vpd_nvram << 2,
+	ha->isp_ops->write_optrom(vha, dbuf, ha->flt_region_vpd_nvram << 2,
 	    RMW_BUFFER_SIZE);
 	vfree(dbuf);
 
@@ -1224,7 +1228,7 @@ qla25xx_write_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
 }
 
 static inline void
-qla2x00_flip_colors(scsi_qla_host_t *ha, uint16_t *pflags)
+qla2x00_flip_colors(struct qla_hw_data *ha, uint16_t *pflags)
 {
 	if (IS_QLA2322(ha)) {
 		/* Flip all colors. */
@@ -1254,12 +1258,13 @@ qla2x00_flip_colors(scsi_qla_host_t *ha, uint16_t *pflags)
 #define PIO_REG(h, r) ((h)->pio_address + offsetof(struct device_reg_2xxx, r))
 
 void
-qla2x00_beacon_blink(struct scsi_qla_host *ha)
+qla2x00_beacon_blink(struct scsi_qla_host *vha)
 {
 	uint16_t gpio_enable;
 	uint16_t gpio_data;
 	uint16_t led_color = 0;
 	unsigned long flags;
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -1303,17 +1308,18 @@ qla2x00_beacon_blink(struct scsi_qla_host *ha)
 }
 
 int
-qla2x00_beacon_on(struct scsi_qla_host *ha)
+qla2x00_beacon_on(struct scsi_qla_host *vha)
 {
 	uint16_t gpio_enable;
 	uint16_t gpio_data;
 	unsigned long flags;
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	ha->fw_options[1] &= ~FO1_SET_EMPHASIS_SWING;
 	ha->fw_options[1] |= FO1_DISABLE_GPIO6_7;
 
-	if (qla2x00_set_fw_options(ha, ha->fw_options) != QLA_SUCCESS) {
+	if (qla2x00_set_fw_options(vha, ha->fw_options) != QLA_SUCCESS) {
 		qla_printk(KERN_WARNING, ha,
 		    "Unable to update fw options (beacon on).\n");
 		return QLA_FUNCTION_FAILED;
@@ -1359,9 +1365,10 @@ qla2x00_beacon_on(struct scsi_qla_host *ha)
 }
 
 int
-qla2x00_beacon_off(struct scsi_qla_host *ha)
+qla2x00_beacon_off(struct scsi_qla_host *vha)
 {
 	int rval = QLA_SUCCESS;
+	struct qla_hw_data *ha = vha->hw;
 
 	ha->beacon_blink_led = 0;
 
@@ -1371,12 +1378,12 @@ qla2x00_beacon_off(struct scsi_qla_host *ha)
 	else
 		ha->beacon_color_state = QLA_LED_GRN_ON;
 
-	ha->isp_ops->beacon_blink(ha);	/* This turns green LED off */
+	ha->isp_ops->beacon_blink(vha);	/* This turns green LED off */
 
 	ha->fw_options[1] &= ~FO1_SET_EMPHASIS_SWING;
 	ha->fw_options[1] &= ~FO1_DISABLE_GPIO6_7;
 
-	rval = qla2x00_set_fw_options(ha, ha->fw_options);
+	rval = qla2x00_set_fw_options(vha, ha->fw_options);
 	if (rval != QLA_SUCCESS)
 		qla_printk(KERN_WARNING, ha,
 		    "Unable to update fw options (beacon off).\n");
@@ -1385,7 +1392,7 @@ qla2x00_beacon_off(struct scsi_qla_host *ha)
 
 
 static inline void
-qla24xx_flip_colors(scsi_qla_host_t *ha, uint16_t *pflags)
+qla24xx_flip_colors(struct qla_hw_data *ha, uint16_t *pflags)
 {
 	/* Flip all colors. */
 	if (ha->beacon_color_state == QLA_LED_ALL_ON) {
@@ -1400,11 +1407,12 @@ qla24xx_flip_colors(scsi_qla_host_t *ha, uint16_t *pflags)
 }
 
 void
-qla24xx_beacon_blink(struct scsi_qla_host *ha)
+qla24xx_beacon_blink(struct scsi_qla_host *vha)
 {
 	uint16_t led_color = 0;
 	uint32_t gpio_data;
 	unsigned long flags;
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 
 	/* Save the Original GPIOD. */
@@ -1433,20 +1441,21 @@ qla24xx_beacon_blink(struct scsi_qla_host *ha)
 }
 
 int
-qla24xx_beacon_on(struct scsi_qla_host *ha)
+qla24xx_beacon_on(struct scsi_qla_host *vha)
 {
 	uint32_t gpio_data;
 	unsigned long flags;
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 
 	if (ha->beacon_blink_led == 0) {
 		/* Enable firmware for update */
 		ha->fw_options[1] |= ADD_FO1_DISABLE_GPIO_LED_CTRL;
 
-		if (qla2x00_set_fw_options(ha, ha->fw_options) != QLA_SUCCESS)
+		if (qla2x00_set_fw_options(vha, ha->fw_options) != QLA_SUCCESS)
 			return QLA_FUNCTION_FAILED;
 
-		if (qla2x00_get_fw_options(ha, ha->fw_options) !=
+		if (qla2x00_get_fw_options(vha, ha->fw_options) !=
 		    QLA_SUCCESS) {
 			qla_printk(KERN_WARNING, ha,
 			    "Unable to update fw options (beacon on).\n");
@@ -1474,16 +1483,17 @@ qla24xx_beacon_on(struct scsi_qla_host *ha)
 }
 
 int
-qla24xx_beacon_off(struct scsi_qla_host *ha)
+qla24xx_beacon_off(struct scsi_qla_host *vha)
 {
 	uint32_t gpio_data;
 	unsigned long flags;
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 
 	ha->beacon_blink_led = 0;
 	ha->beacon_color_state = QLA_LED_ALL_ON;
 
-	ha->isp_ops->beacon_blink(ha);	/* Will flip to all off. */
+	ha->isp_ops->beacon_blink(vha);	/* Will flip to all off. */
 
 	/* Give control back to firmware. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -1497,13 +1507,13 @@ qla24xx_beacon_off(struct scsi_qla_host *ha)
 
 	ha->fw_options[1] &= ~ADD_FO1_DISABLE_GPIO_LED_CTRL;
 
-	if (qla2x00_set_fw_options(ha, ha->fw_options) != QLA_SUCCESS) {
+	if (qla2x00_set_fw_options(vha, ha->fw_options) != QLA_SUCCESS) {
 		qla_printk(KERN_WARNING, ha,
 		    "Unable to update fw options (beacon off).\n");
 		return QLA_FUNCTION_FAILED;
 	}
 
-	if (qla2x00_get_fw_options(ha, ha->fw_options) != QLA_SUCCESS) {
+	if (qla2x00_get_fw_options(vha, ha->fw_options) != QLA_SUCCESS) {
 		qla_printk(KERN_WARNING, ha,
 		    "Unable to get fw options (beacon off).\n");
 		return QLA_FUNCTION_FAILED;
@@ -1522,7 +1532,7 @@ qla24xx_beacon_off(struct scsi_qla_host *ha)
  * @ha: HA context
  */
 static void
-qla2x00_flash_enable(scsi_qla_host_t *ha)
+qla2x00_flash_enable(struct qla_hw_data *ha)
 {
 	uint16_t data;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
@@ -1538,7 +1548,7 @@ qla2x00_flash_enable(scsi_qla_host_t *ha)
  * @ha: HA context
  */
 static void
-qla2x00_flash_disable(scsi_qla_host_t *ha)
+qla2x00_flash_disable(struct qla_hw_data *ha)
 {
 	uint16_t data;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
@@ -1559,7 +1569,7 @@ qla2x00_flash_disable(scsi_qla_host_t *ha)
  * Returns the byte read from flash @addr.
  */
 static uint8_t
-qla2x00_read_flash_byte(scsi_qla_host_t *ha, uint32_t addr)
+qla2x00_read_flash_byte(struct qla_hw_data *ha, uint32_t addr)
 {
 	uint16_t data;
 	uint16_t bank_select;
@@ -1620,7 +1630,7 @@ qla2x00_read_flash_byte(scsi_qla_host_t *ha, uint32_t addr)
  * @data: Data to write
  */
 static void
-qla2x00_write_flash_byte(scsi_qla_host_t *ha, uint32_t addr, uint8_t data)
+qla2x00_write_flash_byte(struct qla_hw_data *ha, uint32_t addr, uint8_t data)
 {
 	uint16_t bank_select;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
@@ -1683,7 +1693,7 @@ qla2x00_write_flash_byte(scsi_qla_host_t *ha, uint32_t addr, uint8_t data)
  * Returns 0 on success, else non-zero.
  */
 static int
-qla2x00_poll_flash(scsi_qla_host_t *ha, uint32_t addr, uint8_t poll_data,
+qla2x00_poll_flash(struct qla_hw_data *ha, uint32_t addr, uint8_t poll_data,
     uint8_t man_id, uint8_t flash_id)
 {
 	int status;
@@ -1723,8 +1733,8 @@ qla2x00_poll_flash(scsi_qla_host_t *ha, uint32_t addr, uint8_t poll_data,
  * Returns 0 on success, else non-zero.
  */
 static int
-qla2x00_program_flash_address(scsi_qla_host_t *ha, uint32_t addr, uint8_t data,
-    uint8_t man_id, uint8_t flash_id)
+qla2x00_program_flash_address(struct qla_hw_data *ha, uint32_t addr,
+    uint8_t data, uint8_t man_id, uint8_t flash_id)
 {
 	/* Write Program Command Sequence. */
 	if (IS_OEM_001(ha)) {
@@ -1760,7 +1770,7 @@ qla2x00_program_flash_address(scsi_qla_host_t *ha, uint32_t addr, uint8_t data,
  * Returns 0 on success, else non-zero.
  */
 static int
-qla2x00_erase_flash(scsi_qla_host_t *ha, uint8_t man_id, uint8_t flash_id)
+qla2x00_erase_flash(struct qla_hw_data *ha, uint8_t man_id, uint8_t flash_id)
 {
 	/* Individual Sector Erase Command Sequence */
 	if (IS_OEM_001(ha)) {
@@ -1796,7 +1806,7 @@ qla2x00_erase_flash(scsi_qla_host_t *ha, uint8_t man_id, uint8_t flash_id)
  * Returns 0 on success, else non-zero.
  */
 static int
-qla2x00_erase_flash_sector(scsi_qla_host_t *ha, uint32_t addr,
+qla2x00_erase_flash_sector(struct qla_hw_data *ha, uint32_t addr,
     uint32_t sec_mask, uint8_t man_id, uint8_t flash_id)
 {
 	/* Individual Sector Erase Command Sequence */
@@ -1822,7 +1832,7 @@ qla2x00_erase_flash_sector(scsi_qla_host_t *ha, uint32_t addr,
  * @flash_id: Flash ID
  */
 static void
-qla2x00_get_flash_manufacturer(scsi_qla_host_t *ha, uint8_t *man_id,
+qla2x00_get_flash_manufacturer(struct qla_hw_data *ha, uint8_t *man_id,
     uint8_t *flash_id)
 {
 	qla2x00_write_flash_byte(ha, 0x5555, 0xaa);
@@ -1836,8 +1846,8 @@ qla2x00_get_flash_manufacturer(scsi_qla_host_t *ha, uint8_t *man_id,
 }
 
 static void
-qla2x00_read_flash_data(scsi_qla_host_t *ha, uint8_t *tmp_buf, uint32_t saddr,
-        uint32_t length)
+qla2x00_read_flash_data(struct qla_hw_data *ha, uint8_t *tmp_buf,
+	uint32_t saddr, uint32_t length)
 {
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	uint32_t midpoint, ilength;
@@ -1861,14 +1871,15 @@ qla2x00_read_flash_data(scsi_qla_host_t *ha, uint8_t *tmp_buf, uint32_t saddr,
 }
 
 static inline void
-qla2x00_suspend_hba(struct scsi_qla_host *ha)
+qla2x00_suspend_hba(struct scsi_qla_host *vha)
 {
 	int cnt;
 	unsigned long flags;
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	/* Suspend HBA. */
-	scsi_block_requests(ha->host);
+	scsi_block_requests(vha->host);
 	ha->isp_ops->disable_intrs(ha);
 	set_bit(MBX_UPDATE_FLASH_ACTIVE, &ha->mbx_cmd_flags);
 
@@ -1889,26 +1900,29 @@ qla2x00_suspend_hba(struct scsi_qla_host *ha)
 }
 
 static inline void
-qla2x00_resume_hba(struct scsi_qla_host *ha)
+qla2x00_resume_hba(struct scsi_qla_host *vha)
 {
+	struct qla_hw_data *ha = vha->hw;
+
 	/* Resume HBA. */
 	clear_bit(MBX_UPDATE_FLASH_ACTIVE, &ha->mbx_cmd_flags);
-	set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
-	qla2xxx_wake_dpc(ha);
-	qla2x00_wait_for_hba_online(ha);
-	scsi_unblock_requests(ha->host);
+	set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+	qla2xxx_wake_dpc(vha);
+	qla2x00_wait_for_hba_online(vha);
+	scsi_unblock_requests(vha->host);
 }
 
 uint8_t *
-qla2x00_read_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
+qla2x00_read_optrom_data(struct scsi_qla_host *vha, uint8_t *buf,
     uint32_t offset, uint32_t length)
 {
 	uint32_t addr, midpoint;
 	uint8_t *data;
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	/* Suspend HBA. */
-	qla2x00_suspend_hba(ha);
+	qla2x00_suspend_hba(vha);
 
 	/* Go with read. */
 	midpoint = ha->optrom_size / 2;
@@ -1927,13 +1941,13 @@ qla2x00_read_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
 	qla2x00_flash_disable(ha);
 
 	/* Resume HBA. */
-	qla2x00_resume_hba(ha);
+	qla2x00_resume_hba(vha);
 
 	return buf;
 }
 
 int
-qla2x00_write_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
+qla2x00_write_optrom_data(struct scsi_qla_host *vha, uint8_t *buf,
     uint32_t offset, uint32_t length)
 {
 
@@ -1941,10 +1955,11 @@ qla2x00_write_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
 	uint8_t man_id, flash_id, sec_number, data;
 	uint16_t wd;
 	uint32_t addr, liter, sec_mask, rest_addr;
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	/* Suspend HBA. */
-	qla2x00_suspend_hba(ha);
+	qla2x00_suspend_hba(vha);
 
 	rval = QLA_SUCCESS;
 	sec_number = 0;
@@ -2144,55 +2159,58 @@ update_flash:
 	qla2x00_flash_disable(ha);
 
 	/* Resume HBA. */
-	qla2x00_resume_hba(ha);
+	qla2x00_resume_hba(vha);
 
 	return rval;
 }
 
 uint8_t *
-qla24xx_read_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
+qla24xx_read_optrom_data(struct scsi_qla_host *vha, uint8_t *buf,
     uint32_t offset, uint32_t length)
 {
+	struct qla_hw_data *ha = vha->hw;
+
 	/* Suspend HBA. */
-	scsi_block_requests(ha->host);
+	scsi_block_requests(vha->host);
 	set_bit(MBX_UPDATE_FLASH_ACTIVE, &ha->mbx_cmd_flags);
 
 	/* Go with read. */
-	qla24xx_read_flash_data(ha, (uint32_t *)buf, offset >> 2, length >> 2);
+	qla24xx_read_flash_data(vha, (uint32_t *)buf, offset >> 2, length >> 2);
 
 	/* Resume HBA. */
 	clear_bit(MBX_UPDATE_FLASH_ACTIVE, &ha->mbx_cmd_flags);
-	scsi_unblock_requests(ha->host);
+	scsi_unblock_requests(vha->host);
 
 	return buf;
 }
 
 int
-qla24xx_write_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
+qla24xx_write_optrom_data(struct scsi_qla_host *vha, uint8_t *buf,
     uint32_t offset, uint32_t length)
 {
 	int rval;
+	struct qla_hw_data *ha = vha->hw;
 
 	/* Suspend HBA. */
-	scsi_block_requests(ha->host);
+	scsi_block_requests(vha->host);
 	set_bit(MBX_UPDATE_FLASH_ACTIVE, &ha->mbx_cmd_flags);
 
 	/* Go with write. */
-	rval = qla24xx_write_flash_data(ha, (uint32_t *)buf, offset >> 2,
+	rval = qla24xx_write_flash_data(vha, (uint32_t *)buf, offset >> 2,
 	    length >> 2);
 
 	/* Resume HBA -- RISC reset needed. */
 	clear_bit(MBX_UPDATE_FLASH_ACTIVE, &ha->mbx_cmd_flags);
-	set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
-	qla2xxx_wake_dpc(ha);
-	qla2x00_wait_for_hba_online(ha);
-	scsi_unblock_requests(ha->host);
+	set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+	qla2xxx_wake_dpc(vha);
+	qla2x00_wait_for_hba_online(vha);
+	scsi_unblock_requests(vha->host);
 
 	return rval;
 }
 
 uint8_t *
-qla25xx_read_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
+qla25xx_read_optrom_data(struct scsi_qla_host *vha, uint8_t *buf,
     uint32_t offset, uint32_t length)
 {
 	int rval;
@@ -2200,6 +2218,7 @@ qla25xx_read_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
 	void *optrom;
 	uint8_t *pbuf;
 	uint32_t faddr, left, burst;
+	struct qla_hw_data *ha = vha->hw;
 
 	if (offset & 0xfff)
 		goto slow_read;
@@ -2224,7 +2243,7 @@ qla25xx_read_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
 		if (burst > left)
 			burst = left;
 
-		rval = qla2x00_dump_ram(ha, optrom_dma,
+		rval = qla2x00_dump_ram(vha, optrom_dma,
 		    flash_data_to_access_addr(faddr), burst);
 		if (rval) {
 			qla_printk(KERN_WARNING, ha,
@@ -2253,7 +2272,7 @@ qla25xx_read_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
 	return buf;
 
 slow_read:
-    return qla24xx_read_optrom_data(ha, buf, offset, length);
+    return qla24xx_read_optrom_data(vha, buf, offset, length);
 }
 
 /**
@@ -2275,7 +2294,7 @@ slow_read:
  * Returns QLA_SUCCESS on successful retrieval of version.
  */
 static void
-qla2x00_get_fcode_version(scsi_qla_host_t *ha, uint32_t pcids)
+qla2x00_get_fcode_version(struct qla_hw_data *ha, uint32_t pcids)
 {
 	int ret = QLA_FUNCTION_FAILED;
 	uint32_t istart, iend, iter, vend;
@@ -2349,13 +2368,14 @@ qla2x00_get_fcode_version(scsi_qla_host_t *ha, uint32_t pcids)
 }
 
 int
-qla2x00_get_flash_version(scsi_qla_host_t *ha, void *mbuf)
+qla2x00_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 {
 	int ret = QLA_SUCCESS;
 	uint8_t code_type, last_image;
 	uint32_t pcihdr, pcids;
 	uint8_t *dbyte;
 	uint16_t *dcode;
+	struct qla_hw_data *ha = vha->hw;
 
 	if (!ha->pio_address || !mbuf)
 		return QLA_FUNCTION_FAILED;
@@ -2375,8 +2395,8 @@ qla2x00_get_flash_version(scsi_qla_host_t *ha, void *mbuf)
 		if (qla2x00_read_flash_byte(ha, pcihdr) != 0x55 ||
 		    qla2x00_read_flash_byte(ha, pcihdr + 0x01) != 0xaa) {
 			/* No signature */
-			DEBUG2(printk("scsi(%ld): No matching ROM "
-			    "signature.\n", ha->host_no));
+			DEBUG2(qla_printk(KERN_DEBUG, ha, "No matching ROM "
+			    "signature.\n"));
 			ret = QLA_FUNCTION_FAILED;
 			break;
 		}
@@ -2392,8 +2412,8 @@ qla2x00_get_flash_version(scsi_qla_host_t *ha, void *mbuf)
 		    qla2x00_read_flash_byte(ha, pcids + 0x2) != 'I' ||
 		    qla2x00_read_flash_byte(ha, pcids + 0x3) != 'R') {
 			/* Incorrect header. */
-			DEBUG2(printk("%s(): PCI data struct not found "
-			    "pcir_adr=%x.\n", __func__, pcids));
+			DEBUG2(qla_printk(KERN_INFO, ha, "PCI data struct not "
+			    "found pcir_adr=%x.\n", pcids));
 			ret = QLA_FUNCTION_FAILED;
 			break;
 		}
@@ -2407,7 +2427,7 @@ qla2x00_get_flash_version(scsi_qla_host_t *ha, void *mbuf)
 			    qla2x00_read_flash_byte(ha, pcids + 0x12);
 			ha->bios_revision[1] =
 			    qla2x00_read_flash_byte(ha, pcids + 0x13);
-			DEBUG3(printk("%s(): read BIOS %d.%d.\n", __func__,
+			DEBUG3(qla_printk(KERN_DEBUG, ha, "read BIOS %d.%d.\n",
 			    ha->bios_revision[1], ha->bios_revision[0]));
 			break;
 		case ROM_CODE_TYPE_FCODE:
@@ -2421,12 +2441,12 @@ qla2x00_get_flash_version(scsi_qla_host_t *ha, void *mbuf)
 			    qla2x00_read_flash_byte(ha, pcids + 0x12);
 			ha->efi_revision[1] =
 			    qla2x00_read_flash_byte(ha, pcids + 0x13);
-			DEBUG3(printk("%s(): read EFI %d.%d.\n", __func__,
+			DEBUG3(qla_printk(KERN_DEBUG, ha, "read EFI %d.%d.\n",
 			    ha->efi_revision[1], ha->efi_revision[0]));
 			break;
 		default:
-			DEBUG2(printk("%s(): Unrecognized code type %x at "
-			    "pcids %x.\n", __func__, code_type, pcids));
+			DEBUG2(qla_printk(KERN_INFO, ha, "Unrecognized code "
+			    "type %x at pcids %x.\n", code_type, pcids));
 			break;
 		}
 
@@ -2446,16 +2466,16 @@ qla2x00_get_flash_version(scsi_qla_host_t *ha, void *mbuf)
 
 		qla2x00_read_flash_data(ha, dbyte, ha->flt_region_fw * 4 + 10,
 		    8);
-		DEBUG3(printk("%s(%ld): dumping fw ver from flash:\n",
-		    __func__, ha->host_no));
+		DEBUG3(qla_printk(KERN_DEBUG, ha, "dumping fw ver from "
+		    "flash:\n"));
 		DEBUG3(qla2x00_dump_buffer((uint8_t *)dbyte, 8));
 
 		if ((dcode[0] == 0xffff && dcode[1] == 0xffff &&
 		    dcode[2] == 0xffff && dcode[3] == 0xffff) ||
 		    (dcode[0] == 0 && dcode[1] == 0 && dcode[2] == 0 &&
 		    dcode[3] == 0)) {
-			DEBUG2(printk("%s(): Unrecognized fw revision at "
-			    "%x.\n", __func__, ha->flt_region_fw * 4));
+			DEBUG2(qla_printk(KERN_INFO, ha, "Unrecognized fw "
+			    "revision at %x.\n", ha->flt_region_fw * 4));
 		} else {
 			/* values are in big endian */
 			ha->fw_revision[0] = dbyte[0] << 16 | dbyte[1];
@@ -2470,7 +2490,7 @@ qla2x00_get_flash_version(scsi_qla_host_t *ha, void *mbuf)
 }
 
 int
-qla24xx_get_flash_version(scsi_qla_host_t *ha, void *mbuf)
+qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 {
 	int ret = QLA_SUCCESS;
 	uint32_t pcihdr, pcids;
@@ -2478,6 +2498,7 @@ qla24xx_get_flash_version(scsi_qla_host_t *ha, void *mbuf)
 	uint8_t *bcode;
 	uint8_t code_type, last_image;
 	int i;
+	struct qla_hw_data *ha = vha->hw;
 
 	if (!mbuf)
 		return QLA_FUNCTION_FAILED;
@@ -2494,12 +2515,12 @@ qla24xx_get_flash_version(scsi_qla_host_t *ha, void *mbuf)
 	last_image = 1;
 	do {
 		/* Verify PCI expansion ROM header. */
-		qla24xx_read_flash_data(ha, dcode, pcihdr >> 2, 0x20);
+		qla24xx_read_flash_data(vha, dcode, pcihdr >> 2, 0x20);
 		bcode = mbuf + (pcihdr % 4);
 		if (bcode[0x0] != 0x55 || bcode[0x1] != 0xaa) {
 			/* No signature */
-			DEBUG2(printk("scsi(%ld): No matching ROM "
-			    "signature.\n", ha->host_no));
+			DEBUG2(qla_printk(KERN_DEBUG, ha, "No matching ROM "
+			    "signature.\n"));
 			ret = QLA_FUNCTION_FAILED;
 			break;
 		}
@@ -2507,15 +2528,15 @@ qla24xx_get_flash_version(scsi_qla_host_t *ha, void *mbuf)
 		/* Locate PCI data structure. */
 		pcids = pcihdr + ((bcode[0x19] << 8) | bcode[0x18]);
 
-		qla24xx_read_flash_data(ha, dcode, pcids >> 2, 0x20);
+		qla24xx_read_flash_data(vha, dcode, pcids >> 2, 0x20);
 		bcode = mbuf + (pcihdr % 4);
 
 		/* Validate signature of PCI data structure. */
 		if (bcode[0x0] != 'P' || bcode[0x1] != 'C' ||
 		    bcode[0x2] != 'I' || bcode[0x3] != 'R') {
 			/* Incorrect header. */
-			DEBUG2(printk("%s(): PCI data struct not found "
-			    "pcir_adr=%x.\n", __func__, pcids));
+			DEBUG2(qla_printk(KERN_INFO, ha, "PCI data struct not "
+			    "found pcir_adr=%x.\n", pcids));
 			ret = QLA_FUNCTION_FAILED;
 			break;
 		}
@@ -2527,26 +2548,26 @@ qla24xx_get_flash_version(scsi_qla_host_t *ha, void *mbuf)
 			/* Intel x86, PC-AT compatible. */
 			ha->bios_revision[0] = bcode[0x12];
 			ha->bios_revision[1] = bcode[0x13];
-			DEBUG3(printk("%s(): read BIOS %d.%d.\n", __func__,
+			DEBUG3(qla_printk(KERN_DEBUG, ha, "read BIOS %d.%d.\n",
 			    ha->bios_revision[1], ha->bios_revision[0]));
 			break;
 		case ROM_CODE_TYPE_FCODE:
 			/* Open Firmware standard for PCI (FCode). */
 			ha->fcode_revision[0] = bcode[0x12];
 			ha->fcode_revision[1] = bcode[0x13];
-			DEBUG3(printk("%s(): read FCODE %d.%d.\n", __func__,
+			DEBUG3(qla_printk(KERN_DEBUG, ha, "read FCODE %d.%d.\n",
 			    ha->fcode_revision[1], ha->fcode_revision[0]));
 			break;
 		case ROM_CODE_TYPE_EFI:
 			/* Extensible Firmware Interface (EFI). */
 			ha->efi_revision[0] = bcode[0x12];
 			ha->efi_revision[1] = bcode[0x13];
-			DEBUG3(printk("%s(): read EFI %d.%d.\n", __func__,
+			DEBUG3(qla_printk(KERN_DEBUG, ha, "read EFI %d.%d.\n",
 			    ha->efi_revision[1], ha->efi_revision[0]));
 			break;
 		default:
-			DEBUG2(printk("%s(): Unrecognized code type %x at "
-			    "pcids %x.\n", __func__, code_type, pcids));
+			DEBUG2(qla_printk(KERN_INFO, ha, "Unrecognized code "
+			    "type %x at pcids %x.\n", code_type, pcids));
 			break;
 		}
 
@@ -2560,7 +2581,7 @@ qla24xx_get_flash_version(scsi_qla_host_t *ha, void *mbuf)
 	memset(ha->fw_revision, 0, sizeof(ha->fw_revision));
 	dcode = mbuf;
 
-	qla24xx_read_flash_data(ha, dcode, ha->flt_region_fw + 4, 4);
+	qla24xx_read_flash_data(vha, dcode, ha->flt_region_fw + 4, 4);
 	for (i = 0; i < 4; i++)
 		dcode[i] = be32_to_cpu(dcode[i]);
 
@@ -2568,8 +2589,8 @@ qla24xx_get_flash_version(scsi_qla_host_t *ha, void *mbuf)
 	    dcode[2] == 0xffffffff && dcode[3] == 0xffffffff) ||
 	    (dcode[0] == 0 && dcode[1] == 0 && dcode[2] == 0 &&
 	    dcode[3] == 0)) {
-		DEBUG2(printk("%s(): Unrecognized fw version at %x.\n",
-		    __func__, ha->flt_region_fw));
+		DEBUG2(qla_printk(KERN_INFO, ha, "Unrecognized fw "
+		    "revision at %x.\n", ha->flt_region_fw * 4));
 	} else {
 		ha->fw_revision[0] = dcode[0];
 		ha->fw_revision[1] = dcode[1];
@@ -2598,8 +2619,9 @@ qla2xxx_is_vpd_valid(uint8_t *pos, uint8_t *end)
 }
 
 int
-qla2xxx_get_vpd_field(scsi_qla_host_t *ha, char *key, char *str, size_t size)
+qla2xxx_get_vpd_field(scsi_qla_host_t *vha, char *key, char *str, size_t size)
 {
+	struct qla_hw_data *ha = vha->hw;
 	uint8_t *pos = ha->vpd;
 	uint8_t *end = pos + ha->vpd_size;
 	int len = 0;
@@ -2626,9 +2648,10 @@ qla2xxx_get_vpd_field(scsi_qla_host_t *ha, char *key, char *str, size_t size)
 }
 
 static int
-qla2xxx_hw_event_store(scsi_qla_host_t *ha, uint32_t *fdata)
+qla2xxx_hw_event_store(scsi_qla_host_t *vha, uint32_t *fdata)
 {
 	uint32_t d[2], faddr;
+	struct qla_hw_data *ha = vha->hw;
 
 	/* Locate first empty entry. */
 	for (;;) {
@@ -2639,7 +2662,7 @@ qla2xxx_hw_event_store(scsi_qla_host_t *ha, uint32_t *fdata)
 			return QLA_MEMORY_ALLOC_FAILED;
 		}
 
-		qla24xx_read_flash_data(ha, d, ha->hw_event_ptr, 2);
+		qla24xx_read_flash_data(vha, d, ha->hw_event_ptr, 2);
 		faddr = flash_data_to_access_addr(ha->hw_event_ptr);
 		ha->hw_event_ptr += FA_HW_EVENT_ENTRY_SIZE;
 		if (d[0] == __constant_cpu_to_le32(0xffffffff) &&
@@ -2660,12 +2683,12 @@ qla2xxx_hw_event_store(scsi_qla_host_t *ha, uint32_t *fdata)
 }
 
 int
-qla2xxx_hw_event_log(scsi_qla_host_t *ha, uint16_t code, uint16_t d1,
+qla2xxx_hw_event_log(scsi_qla_host_t *vha, uint16_t code, uint16_t d1,
     uint16_t d2, uint16_t d3)
 {
 #define QMARK(a, b, c, d) \
     cpu_to_le32(LSB(a) << 24 | LSB(b) << 16 | LSB(c) << 8 | LSB(d))
-
+	struct qla_hw_data *ha = vha->hw;
 	int rval;
 	uint32_t marker[2], fdata[4];
 
@@ -2686,7 +2709,7 @@ qla2xxx_hw_event_log(scsi_qla_host_t *ha, uint16_t code, uint16_t d1,
 		/* Locate marker. */
 		ha->hw_event_ptr = ha->flt_region_hw_event;
 		for (;;) {
-			qla24xx_read_flash_data(ha, fdata, ha->hw_event_ptr,
+			qla24xx_read_flash_data(vha, fdata, ha->hw_event_ptr,
 			    4);
 			if (fdata[0] == __constant_cpu_to_le32(0xffffffff) &&
 			    fdata[1] == __constant_cpu_to_le32(0xffffffff))
@@ -2705,7 +2728,7 @@ qla2xxx_hw_event_log(scsi_qla_host_t *ha, uint16_t code, uint16_t d1,
 		}
 		/* No marker, write it. */
 		if (!ha->flags.hw_event_marker_found) {
-			rval = qla2xxx_hw_event_store(ha, marker);
+			rval = qla2xxx_hw_event_store(vha, marker);
 			if (rval != QLA_SUCCESS) {
 				DEBUG2(qla_printk(KERN_WARNING, ha,
 				    "HW event -- Failed marker write=%x.!\n",
@@ -2719,7 +2742,7 @@ qla2xxx_hw_event_log(scsi_qla_host_t *ha, uint16_t code, uint16_t d1,
 	/* Store error.  */
 	fdata[0] = cpu_to_le32(code << 16 | d1);
 	fdata[1] = cpu_to_le32(d2 << 16 | d3);
-	rval = qla2xxx_hw_event_store(ha, fdata);
+	rval = qla2xxx_hw_event_store(vha, fdata);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2(qla_printk(KERN_WARNING, ha,
 		    "HW event -- Failed error write=%x.!\n",
