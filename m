From: giridhar.malavali@qlogic.com
Subject: [PATCH 6/7] qla2xxx: Properly delete rports attached to a vport.
Date: Tue, 25 Aug 2009 11:36:20 -0700
Message-ID: <1251225381-768-7-git-send-email-giridhar.malavali@qlogic.com>
References: <1251225381-768-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:47045 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755499AbZHYSgZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 14:36:25 -0400
In-Reply-To: <1251225381-768-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Original code would inadvertently skip the deferred
fc_remote_port_delete() call for rports hanging off any vport.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |   12 +++++++-----
 drivers/scsi/qla2xxx/qla_os.c   |    6 ++++--
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 38d9fbf..493561a 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3495,15 +3495,17 @@ qla2x00_loop_resync(scsi_qla_host_t *vha)
 }
 
 void
-qla2x00_update_fcports(scsi_qla_host_t *vha)
+qla2x00_update_fcports(scsi_qla_host_t *base_vha)
 {
 	fc_port_t *fcport;
+	struct scsi_qla_host *tvp, *vha;
 
 	/* Go with deferred removal of rport references. */
-	list_for_each_entry(fcport, &vha->vp_fcports, list)
-		if (fcport && fcport->drport &&
-		    atomic_read(&fcport->state) != FCS_UNCONFIGURED)
-			qla2x00_rport_del(fcport);
+	list_for_each_entry_safe(vha, tvp, &base_vha->hw->vp_list, list)
+		list_for_each_entry(fcport, &vha->vp_fcports, list)
+			if (fcport && fcport->drport &&
+			    atomic_read(&fcport->state) != FCS_UNCONFIGURED)
+				qla2x00_rport_del(fcport);
 }
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 9283d00..29396c0 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2183,17 +2183,19 @@ qla2x00_schedule_rport_del(struct scsi_qla_host *vha, fc_port_t *fcport,
     int defer)
 {
 	struct fc_rport *rport;
+	scsi_qla_host_t *base_vha;
 
 	if (!fcport->rport)
 		return;
 
 	rport = fcport->rport;
 	if (defer) {
+		base_vha = pci_get_drvdata(vha->hw->pdev);
 		spin_lock_irq(vha->host->host_lock);
 		fcport->drport = rport;
 		spin_unlock_irq(vha->host->host_lock);
-		set_bit(FCPORT_UPDATE_NEEDED, &vha->dpc_flags);
-		qla2xxx_wake_dpc(vha);
+		set_bit(FCPORT_UPDATE_NEEDED, &base_vha->dpc_flags);
+		qla2xxx_wake_dpc(base_vha);
 	} else
 		fc_remote_port_delete(rport);
 }
-- 
1.6.2.rc1.30.gd43c

