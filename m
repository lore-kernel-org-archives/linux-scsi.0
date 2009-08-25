From: giridhar.malavali@qlogic.com
Subject: [PATCH 5/7] qla2xxx: Correct various NPIV issues.
Date: Tue, 25 Aug 2009 11:36:19 -0700
Message-ID: <1251225381-768-6-git-send-email-giridhar.malavali@qlogic.com>
References: <1251225381-768-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:47042 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755831AbZHYSgZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 14:36:25 -0400
In-Reply-To: <1251225381-768-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

* Consolidate vport-count processing.
* Correct vp_idx restrictions during RSCN processing.
* Push topology verification check to qla2x00_do_dpc_all_vps().
* Don't skip vport full-login-lip/lip-reset mailbox handling.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    5 +++++
 drivers/scsi/qla2xxx/qla_init.c |    2 --
 drivers/scsi/qla2xxx/qla_isr.c  |    3 ++-
 drivers/scsi/qla2xxx/qla_mid.c  |   30 ++++++++++++++----------------
 drivers/scsi/qla2xxx/qla_os.c   |   21 +++++++++++----------
 5 files changed, 32 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index e03b51f..1dc1077 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1736,6 +1736,11 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 
 	qla24xx_deallocate_vp_id(vha);
 
+	mutex_lock(&ha->vport_lock);
+	ha->cur_vport_count--;
+	clear_bit(vha->vp_idx, ha->vp_idx_map);
+	mutex_unlock(&ha->vport_lock);
+
 	if (vha->timer_active) {
 		qla2x00_vp_stop_timer(vha);
 		DEBUG15(printk ("scsi(%ld): timer for the vport[%d] = %p "
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 79bd898..38d9fbf 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3540,8 +3540,6 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 		if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
 			atomic_set(&vha->loop_state, LOOP_DOWN);
 			qla2x00_mark_all_devices_lost(vha, 0);
-			list_for_each_entry_safe(vp, tvp, &ha->vp_list, list)
-			       qla2x00_mark_all_devices_lost(vp, 0);
 		} else {
 			if (!atomic_read(&vha->loop_down_timer))
 				atomic_set(&vha->loop_down_timer,
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 6c14b1e..88a80f6 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -687,8 +687,9 @@ skip_rio:
 		if (vha->vp_idx && test_bit(VP_SCR_NEEDED, &vha->vp_flags))
 			break;
 		/* Only handle SCNs for our Vport index. */
-		if (vha->vp_idx != (mb[3] & 0xff))
+		if (ha->flags.npiv_supported && vha->vp_idx != (mb[3] & 0xff))
 			break;
+
 		DEBUG2(printk("scsi(%ld): Asynchronous RSCR UPDATE.\n",
 		    vha->host_no));
 		DEBUG(printk(KERN_INFO
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index a748a95..42b799a 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -42,7 +42,6 @@ qla24xx_allocate_vp_id(scsi_qla_host_t *vha)
 
 	set_bit(vp_id, ha->vp_idx_map);
 	ha->num_vhosts++;
-	ha->cur_vport_count++;
 	vha->vp_idx = vp_id;
 	list_add_tail(&vha->list, &ha->vp_list);
 	mutex_unlock(&ha->vport_lock);
@@ -58,7 +57,6 @@ qla24xx_deallocate_vp_id(scsi_qla_host_t *vha)
 	mutex_lock(&ha->vport_lock);
 	vp_id = vha->vp_idx;
 	ha->num_vhosts--;
-	ha->cur_vport_count--;
 	clear_bit(vp_id, ha->vp_idx_map);
 	list_del(&vha->list);
 	mutex_unlock(&ha->vport_lock);
@@ -235,7 +233,11 @@ qla2x00_vp_abort_isp(scsi_qla_host_t *vha)
 			atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
 	}
 
-	/* To exclusively reset vport, we need to log it out first.*/
+	/*
+	 * To exclusively reset vport, we need to log it out first.  Note: this
+	 * control_vp can fail if ISP reset is already issued, this is
+	 * expected, as the vp would be already logged out due to ISP reset.
+	 */
 	if (!test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags))
 		qla24xx_control_vp(vha, VCE_COMMAND_DISABLE_VPS_LOGO_ALL);
 
@@ -247,23 +249,11 @@ qla2x00_vp_abort_isp(scsi_qla_host_t *vha)
 static int
 qla2x00_do_dpc_vp(scsi_qla_host_t *vha)
 {
-	struct qla_hw_data *ha = vha->hw;
-	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
-
-	if (!(ha->current_topology & ISP_CFG_F))
-		return 0;
-
 	qla2x00_do_work(vha);
 
 	if (test_and_clear_bit(VP_IDX_ACQUIRED, &vha->vp_flags)) {
 		/* VP acquired. complete port configuration */
-		if (atomic_read(&base_vha->loop_state) == LOOP_READY) {
-			qla24xx_configure_vp(vha);
-		} else {
-			set_bit(VP_IDX_ACQUIRED, &vha->vp_flags);
-			set_bit(VP_DPC_NEEDED, &base_vha->dpc_flags);
-		}
-
+		qla24xx_configure_vp(vha);
 		return 0;
 	}
 
@@ -314,6 +304,9 @@ qla2x00_do_dpc_all_vps(scsi_qla_host_t *vha)
 
 	clear_bit(VP_DPC_NEEDED, &vha->dpc_flags);
 
+	if (!(ha->current_topology & ISP_CFG_F))
+		return;
+
 	list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
 		if (vp->vp_idx)
 			ret = qla2x00_do_dpc_vp(vp);
@@ -418,6 +411,11 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 
 	vha->flags.init_done = 1;
 
+	mutex_lock(&ha->vport_lock);
+	set_bit(vha->vp_idx, ha->vp_idx_map);
+	ha->cur_vport_count++;
+	mutex_unlock(&ha->vport_lock);
+
 	return vha;
 
 create_vhost_failed:
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1587e13..9283d00 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1120,8 +1120,7 @@ qla2x00_loop_reset(scsi_qla_host_t *vha)
 	struct fc_port *fcport;
 	struct qla_hw_data *ha = vha->hw;
 
-	if (ha->flags.enable_lip_full_login && !vha->vp_idx &&
-	    !IS_QLA81XX(ha)) {
+	if (ha->flags.enable_lip_full_login && !IS_QLA81XX(ha)) {
 		ret = qla2x00_full_login_lip(vha);
 		if (ret != QLA_SUCCESS) {
 			DEBUG2_3(printk("%s(%ld): failed: "
@@ -1134,7 +1133,7 @@ qla2x00_loop_reset(scsi_qla_host_t *vha)
 		qla2x00_wait_for_loop_ready(vha);
 	}
 
-	if (ha->flags.enable_lip_reset && !vha->vp_idx) {
+	if (ha->flags.enable_lip_reset) {
 		ret = qla2x00_lip_reset(vha);
 		if (ret != QLA_SUCCESS) {
 			DEBUG2_3(printk("%s(%ld): failed: "
@@ -2266,8 +2265,9 @@ qla2x00_mark_all_devices_lost(scsi_qla_host_t *vha, int defer)
 	fc_port_t *fcport;
 
 	list_for_each_entry(fcport, &vha->vp_fcports, list) {
-		if (vha->vp_idx != fcport->vp_idx)
+		if (vha->vp_idx != 0 && vha->vp_idx != fcport->vp_idx)
 			continue;
+
 		/*
 		 * No point in marking the device as lost, if the device is
 		 * already DEAD.
@@ -2275,10 +2275,12 @@ qla2x00_mark_all_devices_lost(scsi_qla_host_t *vha, int defer)
 		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD)
 			continue;
 		if (atomic_read(&fcport->state) == FCS_ONLINE) {
-			atomic_set(&fcport->state, FCS_DEVICE_LOST);
-			qla2x00_schedule_rport_del(vha, fcport, defer);
-		} else
-			atomic_set(&fcport->state, FCS_DEVICE_LOST);
+			if (defer)
+				qla2x00_schedule_rport_del(vha, fcport, defer);
+			else if (vha->vp_idx == fcport->vp_idx)
+				qla2x00_schedule_rport_del(vha, fcport, defer);
+		}
+		atomic_set(&fcport->state, FCS_DEVICE_LOST);
 	}
 }
 
@@ -3106,8 +3108,7 @@ qla2x00_timer(scsi_qla_host_t *vha)
 
 		/* if the loop has been down for 4 minutes, reinit adapter */
 		if (atomic_dec_and_test(&vha->loop_down_timer) != 0) {
-			if (!(vha->device_flags & DFLG_NO_CABLE) &&
-			    !vha->vp_idx) {
+			if (!(vha->device_flags & DFLG_NO_CABLE)) {
 				DEBUG(printk("scsi(%ld): Loop down - "
 				    "aborting ISP.\n",
 				    vha->host_no));
-- 
1.6.2.rc1.30.gd43c

