From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 19/37] qla2xxx: Add lock protection around host lookup
Date: Thu, 28 Dec 2017 12:33:27 -0800
Message-ID: <20171228203345.2702-20-himanshu.madhani@cavium.com>
References: <20171228203345.2702-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0089.outbound.protection.outlook.com ([104.47.40.89]:60974
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754886AbdL1UeH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 Dec 2017 15:34:07 -0500
In-Reply-To: <20171228203345.2702-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Host lookup via btree is currently protected by the hardware_lock.
Add hardware_lock when modifying btree to store host pointer.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_init.c   | 3 +++
 drivers/scsi/qla2xxx/qla_mid.c    | 9 +++++----
 drivers/scsi/qla2xxx/qla_target.c | 6 ------
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index f26acb7ce315..4f4d8b2b7b32 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3939,6 +3939,7 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
 	struct qla_hw_data *ha = vha->hw;
 	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 	port_id_t id;
+	unsigned long flags;
 
 	/* Get host addresses. */
 	rval = qla2x00_get_adapter_id(vha,
@@ -4020,7 +4021,9 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
 	id.b.area = area;
 	id.b.al_pa = al_pa;
 	id.b.rsvd_1 = 0;
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 	qlt_update_host_map(vha, id);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	if (!vha->flags.init_done)
 		ql_log(ql_log_info, vha, 0x2010,
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 2570146beae4..bf365f8a9d32 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -50,10 +50,11 @@ qla24xx_allocate_vp_id(scsi_qla_host_t *vha)
 
 	spin_lock_irqsave(&ha->vport_slock, flags);
 	list_add_tail(&vha->list, &ha->vp_list);
+	spin_unlock_irqrestore(&ha->vport_slock, flags);
 
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 	qlt_update_vp_map(vha, SET_VP_IDX);
-
-	spin_unlock_irqrestore(&ha->vport_slock, flags);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	mutex_unlock(&ha->vport_lock);
 	return vp_id;
@@ -158,9 +159,9 @@ qla24xx_disable_vp(scsi_qla_host_t *vha)
 	atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
 
 	/* Remove port id from vp target map */
-	spin_lock_irqsave(&vha->hw->vport_slock, flags);
+	spin_lock_irqsave(&vha->hw->hardware_lock, flags);
 	qlt_update_vp_map(vha, RESET_AL_PA);
-	spin_unlock_irqrestore(&vha->hw->vport_slock, flags);
+	spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
 
 	qla2x00_mark_vp_devices_dead(vha);
 	atomic_set(&vha->vp_state, VP_FAILED);
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index d4ead404100c..5695fc249b73 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -7184,20 +7184,14 @@ qlt_update_vp_map(struct scsi_qla_host *vha, int cmd)
 
 void qlt_update_host_map(struct scsi_qla_host *vha, port_id_t id)
 {
-	unsigned long flags;
-	struct qla_hw_data *ha = vha->hw;
 
 	if (!vha->d_id.b24) {
-		spin_lock_irqsave(&ha->vport_slock, flags);
 		vha->d_id = id;
 		qlt_update_vp_map(vha, SET_AL_PA);
-		spin_unlock_irqrestore(&ha->vport_slock, flags);
 	} else if (vha->d_id.b24 != id.b24) {
-		spin_lock_irqsave(&ha->vport_slock, flags);
 		qlt_update_vp_map(vha, RESET_AL_PA);
 		vha->d_id = id;
 		qlt_update_vp_map(vha, SET_AL_PA);
-		spin_unlock_irqrestore(&ha->vport_slock, flags);
 	}
 }
 
-- 
2.12.0
