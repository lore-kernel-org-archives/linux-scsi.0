From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 23/43] qla2xxx: Add lock protection around host lookup
Date: Tue, 19 Dec 2017 22:56:24 -0800
Message-ID: <20171220065644.21511-24-himanshu.madhani@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0078.outbound.protection.outlook.com ([104.47.32.78]:54675
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932372AbdLTG5S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 01:57:18 -0500
In-Reply-To: <20171220065644.21511-1-himanshu.madhani@cavium.com>
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
index cdcd84278fd0..300cd795dad4 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3977,6 +3977,7 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
 	struct qla_hw_data *ha = vha->hw;
 	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 	port_id_t id;
+	unsigned long flags;
 
 	/* Get host addresses. */
 	rval = qla2x00_get_adapter_id(vha,
@@ -4058,7 +4059,9 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
 	id.b.area = area;
 	id.b.al_pa = al_pa;
 	id.b.rsvd_1 = 0;
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 	qlt_update_host_map(vha, id);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	if (!vha->flags.init_done)
 		ql_log(ql_log_info, vha, 0x2010,
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index a823fa6b7060..12a29eca02e1 100644
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
index 48e0a12dca61..c7c81d5cf69c 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -7206,20 +7206,14 @@ qlt_update_vp_map(struct scsi_qla_host *vha, int cmd)
 
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
