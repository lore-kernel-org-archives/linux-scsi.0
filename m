From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 1/5] qla2xxx: Fix qlt_lport_register base_vha callback race
Date: Thu, 20 Feb 2014 21:03:25 +0000
Message-ID: <1392930209-25065-2-git-send-email-nab@daterainc.com>
References: <1392930209-25065-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1392930209-25065-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Sawan Chandak <sawan.chandak@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch closes a race between qlt_lport_register() and
tcm_qla2xxx callback logic by holding qla_tgt_mutex before
making the callback.

In order for this to work, the qlt_add_target() and
qlt_remove_target() code has been changed to avoid the
accessing qla_tgt_mutex + list_[add,del] for NPIV enabled
ports.

This bug introduced in v3.14-rc1 code with commit 49a47f2.

Cc: Sawan Chandak <sawan.chandak@qlogic.com>
Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/qla2xxx/qla_target.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 2eb97d7..ea3eaef 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -4181,6 +4181,9 @@ int qlt_add_target(struct qla_hw_data *ha, struct scsi_qla_host *base_vha)
 	tgt->datasegs_per_cmd = QLA_TGT_DATASEGS_PER_CMD_24XX;
 	tgt->datasegs_per_cont = QLA_TGT_DATASEGS_PER_CONT_24XX;
 
+	if (base_vha->fc_vport)
+		return 0;
+
 	mutex_lock(&qla_tgt_mutex);
 	list_add_tail(&tgt->tgt_list_entry, &qla_tgt_glist);
 	mutex_unlock(&qla_tgt_mutex);
@@ -4194,6 +4197,10 @@ int qlt_remove_target(struct qla_hw_data *ha, struct scsi_qla_host *vha)
 	if (!vha->vha_tgt.qla_tgt)
 		return 0;
 
+	if (vha->fc_vport) {
+		qlt_release(vha->vha_tgt.qla_tgt);
+		return 0;
+	}
 	mutex_lock(&qla_tgt_mutex);
 	list_del(&vha->vha_tgt.qla_tgt->tgt_list_entry);
 	mutex_unlock(&qla_tgt_mutex);
@@ -4265,6 +4272,12 @@ int qlt_lport_register(void *target_lport_ptr, u64 phys_wwpn,
 			spin_unlock_irqrestore(&ha->hardware_lock, flags);
 			continue;
 		}
+		if (tgt->tgt_stop) {
+			pr_debug("MODE_TARGET in shutdown on qla2xxx(%d)\n",
+				 host->host_no);
+			spin_unlock_irqrestore(&ha->hardware_lock, flags);
+			continue;
+		}
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 		if (!scsi_host_get(host)) {
@@ -4279,12 +4292,11 @@ int qlt_lport_register(void *target_lport_ptr, u64 phys_wwpn,
 			scsi_host_put(host);
 			continue;
 		}
-		mutex_unlock(&qla_tgt_mutex);
-
 		rc = (*callback)(vha, target_lport_ptr, npiv_wwpn, npiv_wwnn);
 		if (rc != 0)
 			scsi_host_put(host);
 
+		mutex_unlock(&qla_tgt_mutex);
 		return rc;
 	}
 	mutex_unlock(&qla_tgt_mutex);
-- 
1.7.10.4
