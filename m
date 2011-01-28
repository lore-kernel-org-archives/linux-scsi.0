From: madhu.iyengar@qlogic.com
Subject: [PATCH 2/3] qla2xxx: Change from irq to irqsave with host_lock
Date: Fri, 28 Jan 2011 15:17:56 -0800
Message-ID: <1296256677-11572-3-git-send-email-madhu.iyengar@qlogic.com>
References: <1296256677-11572-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:59072 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753320Ab1A1XeD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jan 2011 18:34:03 -0500
In-Reply-To: <1296256677-11572-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>

From: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>

Make the driver safer by using irqsave/irqrestore with host_lock.

Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    5 +++--
 drivers/scsi/qla2xxx/qla_init.c |   10 ++++++----
 drivers/scsi/qla2xxx/qla_os.c   |    5 +++--
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 44578b5..d3e58d7 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1561,6 +1561,7 @@ qla2x00_dev_loss_tmo_callbk(struct fc_rport *rport)
 {
 	struct Scsi_Host *host = rport_to_shost(rport);
 	fc_port_t *fcport = *(fc_port_t **)rport->dd_data;
+	unsigned long flags;
 
 	if (!fcport)
 		return;
@@ -1573,10 +1574,10 @@ qla2x00_dev_loss_tmo_callbk(struct fc_rport *rport)
 	 * Transport has effectively 'deleted' the rport, clear
 	 * all local references.
 	 */
-	spin_lock_irq(host->host_lock);
+	spin_lock_irqsave(host->host_lock, flags);
 	fcport->rport = fcport->drport = NULL;
 	*((fc_port_t **)rport->dd_data) = NULL;
-	spin_unlock_irq(host->host_lock);
+	spin_unlock_irqrestore(host->host_lock, flags);
 
 	if (test_bit(ABORT_ISP_ACTIVE, &fcport->vha->dpc_flags))
 		return;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index f948e1a..d9479c3 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2505,11 +2505,12 @@ qla2x00_rport_del(void *data)
 {
 	fc_port_t *fcport = data;
 	struct fc_rport *rport;
+	unsigned long flags;
 
-	spin_lock_irq(fcport->vha->host->host_lock);
+	spin_lock_irqsave(fcport->vha->host->host_lock, flags);
 	rport = fcport->drport ? fcport->drport: fcport->rport;
 	fcport->drport = NULL;
-	spin_unlock_irq(fcport->vha->host->host_lock);
+	spin_unlock_irqrestore(fcport->vha->host->host_lock, flags);
 	if (rport)
 		fc_remote_port_delete(rport);
 }
@@ -2879,6 +2880,7 @@ qla2x00_reg_remote_port(scsi_qla_host_t *vha, fc_port_t *fcport)
 	struct fc_rport_identifiers rport_ids;
 	struct fc_rport *rport;
 	struct qla_hw_data *ha = vha->hw;
+	unsigned long flags;
 
 	qla2x00_rport_del(fcport);
 
@@ -2893,9 +2895,9 @@ qla2x00_reg_remote_port(scsi_qla_host_t *vha, fc_port_t *fcport)
 		    "Unable to allocate fc remote port!\n");
 		return;
 	}
-	spin_lock_irq(fcport->vha->host->host_lock);
+	spin_lock_irqsave(fcport->vha->host->host_lock, flags);
 	*((fc_port_t **)rport->dd_data) = fcport;
-	spin_unlock_irq(fcport->vha->host->host_lock);
+	spin_unlock_irqrestore(fcport->vha->host->host_lock, flags);
 
 	rport->supported_classes = fcport->supported_classes;
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 5dc548b..a32f135 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2512,6 +2512,7 @@ qla2x00_schedule_rport_del(struct scsi_qla_host *vha, fc_port_t *fcport,
 {
 	struct fc_rport *rport;
 	scsi_qla_host_t *base_vha;
+	unsigned long flags;
 
 	if (!fcport->rport)
 		return;
@@ -2519,9 +2520,9 @@ qla2x00_schedule_rport_del(struct scsi_qla_host *vha, fc_port_t *fcport,
 	rport = fcport->rport;
 	if (defer) {
 		base_vha = pci_get_drvdata(vha->hw->pdev);
-		spin_lock_irq(vha->host->host_lock);
+		spin_lock_irqsave(vha->host->host_lock, flags);
 		fcport->drport = rport;
-		spin_unlock_irq(vha->host->host_lock);
+		spin_unlock_irqrestore(vha->host->host_lock, flags);
 		set_bit(FCPORT_UPDATE_NEEDED, &base_vha->dpc_flags);
 		qla2xxx_wake_dpc(base_vha);
 	} else
-- 
1.6.0.2

