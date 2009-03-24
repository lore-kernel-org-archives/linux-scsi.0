From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 02/26] qla2xxx: Consolidate queuecommand implementations.
Date: Tue, 24 Mar 2009 09:07:56 -0700
Message-ID: <1237910900-30817-3-git-send-email-andrew.vasquez@qlogic.com>
References: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29880 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762312AbZCXQIZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2009 12:08:25 -0400
In-Reply-To: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Post refactoring/multi-queue additions essentially eliminated the
need for separate ISP24XX+ queuecommand as isp_ops contains a
function pointer to the associated 'start_scsi()' operation.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h |    2 +-
 drivers/scsi/qla2xxx/qla_mid.c |    2 +-
 drivers/scsi/qla2xxx/qla_os.c  |  111 ++--------------------------------------
 3 files changed, 7 insertions(+), 108 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 6de283f..85b689c 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -82,7 +82,7 @@ extern void qla2x00_relogin(struct scsi_qla_host *);
 /*
  * Global Functions in qla_mid.c source file.
  */
-extern struct scsi_host_template qla24xx_driver_template;
+extern struct scsi_host_template qla2xxx_driver_template;
 extern struct scsi_transport_template *qla2xxx_transport_vport_template;
 extern void qla2x00_timer(scsi_qla_host_t *);
 extern void qla2x00_start_timer(scsi_qla_host_t *, void *, unsigned long);
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index e2bd36e..51716c7 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -359,7 +359,7 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 	scsi_qla_host_t *base_vha = shost_priv(fc_vport->shost);
 	struct qla_hw_data *ha = base_vha->hw;
 	scsi_qla_host_t *vha;
-	struct scsi_host_template *sht = &qla24xx_driver_template;
+	struct scsi_host_template *sht = &qla2xxx_driver_template;
 	struct Scsi_Host *host;
 
 	vha = qla2x00_create_host(sht, ha);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index a6761ff..41ff7d6 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -104,9 +104,7 @@ static int qla2xxx_slave_alloc(struct scsi_device *);
 static int qla2xxx_scan_finished(struct Scsi_Host *, unsigned long time);
 static void qla2xxx_scan_start(struct Scsi_Host *);
 static void qla2xxx_slave_destroy(struct scsi_device *);
-static int qla2x00_queuecommand(struct scsi_cmnd *cmd,
-		void (*fn)(struct scsi_cmnd *));
-static int qla24xx_queuecommand(struct scsi_cmnd *cmd,
+static int qla2xxx_queuecommand(struct scsi_cmnd *cmd,
 		void (*fn)(struct scsi_cmnd *));
 static int qla2xxx_eh_abort(struct scsi_cmnd *);
 static int qla2xxx_eh_device_reset(struct scsi_cmnd *);
@@ -117,42 +115,10 @@ static int qla2xxx_eh_host_reset(struct scsi_cmnd *);
 static int qla2x00_change_queue_depth(struct scsi_device *, int);
 static int qla2x00_change_queue_type(struct scsi_device *, int);
 
-static struct scsi_host_template qla2x00_driver_template = {
+struct scsi_host_template qla2xxx_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= QLA2XXX_DRIVER_NAME,
-	.queuecommand		= qla2x00_queuecommand,
-
-	.eh_abort_handler	= qla2xxx_eh_abort,
-	.eh_device_reset_handler = qla2xxx_eh_device_reset,
-	.eh_target_reset_handler = qla2xxx_eh_target_reset,
-	.eh_bus_reset_handler	= qla2xxx_eh_bus_reset,
-	.eh_host_reset_handler	= qla2xxx_eh_host_reset,
-
-	.slave_configure	= qla2xxx_slave_configure,
-
-	.slave_alloc		= qla2xxx_slave_alloc,
-	.slave_destroy		= qla2xxx_slave_destroy,
-	.scan_finished		= qla2xxx_scan_finished,
-	.scan_start		= qla2xxx_scan_start,
-	.change_queue_depth	= qla2x00_change_queue_depth,
-	.change_queue_type	= qla2x00_change_queue_type,
-	.this_id		= -1,
-	.cmd_per_lun		= 3,
-	.use_clustering		= ENABLE_CLUSTERING,
-	.sg_tablesize		= SG_ALL,
-
-	/*
-	 * The RISC allows for each command to transfer (2^32-1) bytes of data,
-	 * which equates to 0x800000 sectors.
-	 */
-	.max_sectors		= 0xFFFF,
-	.shost_attrs		= qla2x00_host_attrs,
-};
-
-struct scsi_host_template qla24xx_driver_template = {
-	.module			= THIS_MODULE,
-	.name			= QLA2XXX_DRIVER_NAME,
-	.queuecommand		= qla24xx_queuecommand,
+	.queuecommand		= qla2xxx_queuecommand,
 
 	.eh_abort_handler	= qla2xxx_eh_abort,
 	.eh_device_reset_handler = qla2xxx_eh_device_reset,
@@ -430,73 +396,7 @@ qla2x00_get_new_sp(scsi_qla_host_t *vha, fc_port_t *fcport,
 }
 
 static int
-qla2x00_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
-{
-	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
-	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
-	struct fc_rport *rport = starget_to_rport(scsi_target(cmd->device));
-	struct qla_hw_data *ha = vha->hw;
-	srb_t *sp;
-	int rval;
-
-	if (unlikely(pci_channel_offline(ha->pdev))) {
-		cmd->result = DID_REQUEUE << 16;
-		goto qc_fail_command;
-	}
-
-	rval = fc_remote_port_chkready(rport);
-	if (rval) {
-		cmd->result = rval;
-		goto qc_fail_command;
-	}
-
-	/* Close window on fcport/rport state-transitioning. */
-	if (fcport->drport)
-		goto qc_target_busy;
-
-	if (atomic_read(&fcport->state) != FCS_ONLINE) {
-		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
-		    atomic_read(&vha->loop_state) == LOOP_DEAD) {
-			cmd->result = DID_NO_CONNECT << 16;
-			goto qc_fail_command;
-		}
-		goto qc_target_busy;
-	}
-
-	spin_unlock_irq(vha->host->host_lock);
-
-	sp = qla2x00_get_new_sp(vha, fcport, cmd, done);
-	if (!sp)
-		goto qc_host_busy_lock;
-
-	rval = ha->isp_ops->start_scsi(sp);
-	if (rval != QLA_SUCCESS)
-		goto qc_host_busy_free_sp;
-
-	spin_lock_irq(vha->host->host_lock);
-
-	return 0;
-
-qc_host_busy_free_sp:
-	qla2x00_sp_free_dma(sp);
-	mempool_free(sp, ha->srb_mempool);
-
-qc_host_busy_lock:
-	spin_lock_irq(vha->host->host_lock);
-	return SCSI_MLQUEUE_HOST_BUSY;
-
-qc_target_busy:
-	return SCSI_MLQUEUE_TARGET_BUSY;
-
-qc_fail_command:
-	done(cmd);
-
-	return 0;
-}
-
-
-static int
-qla24xx_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
+qla2xxx_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 {
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
@@ -1712,7 +1612,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct rsp_que *rsp = NULL;
 
 	bars = pci_select_bars(pdev, IORESOURCE_MEM | IORESOURCE_IO);
-	sht = &qla2x00_driver_template;
+	sht = &qla2xxx_driver_template;
 	if (pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2422 ||
 	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2432 ||
 	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP8432 ||
@@ -1721,7 +1621,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2532 ||
 	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP8001) {
 		bars = pci_select_bars(pdev, IORESOURCE_MEM);
-		sht = &qla24xx_driver_template;
 		mem_only = 1;
 	}
 
-- 
1.6.2.rc0.55.g30aa4f

