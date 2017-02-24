From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v3 08/14] qla2xxx: Change scsi host lookup method.
Date: Fri, 24 Feb 2017 13:37:37 -0800
Message-ID: <1487972263-3795-9-git-send-email-himanshu.madhani@cavium.com>
References: <1487972263-3795-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0068.outbound.protection.outlook.com ([104.47.33.68]:59968
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751298AbdBXViR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Feb 2017 16:38:17 -0500
In-Reply-To: <1487972263-3795-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, Bart.VanAssche@sandisk.com, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

From: Quinn Tran <quinn.tran@cavium.com>

For target mode, when new scsi command arrive, driver first performs
a look up of the SCSI Host. The current look up method is based on
the ALPA portion of the NPort ID. For Cisco switch, the ALPA can
not be used as the index. Instead, the new search method is based
on the full value of the Nport_ID via btree lib.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/Kconfig      |  1 +
 drivers/scsi/qla2xxx/qla_def.h    |  2 +
 drivers/scsi/qla2xxx/qla_gbl.h    |  2 +
 drivers/scsi/qla2xxx/qla_init.c   | 14 +++---
 drivers/scsi/qla2xxx/qla_mbx.c    | 28 ++++--------
 drivers/scsi/qla2xxx/qla_os.c     |  1 +
 drivers/scsi/qla2xxx/qla_target.c | 92 +++++++++++++++++++++++++++++++++------
 7 files changed, 100 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/qla2xxx/Kconfig b/drivers/scsi/qla2xxx/Kconfig
index 67c0d5a..de95293 100644
--- a/drivers/scsi/qla2xxx/Kconfig
+++ b/drivers/scsi/qla2xxx/Kconfig
@@ -3,6 +3,7 @@ config SCSI_QLA_FC
 	depends on PCI && SCSI
 	depends on SCSI_FC_ATTRS
 	select FW_LOADER
+	select BTREE
 	---help---
 	This qla2xxx driver supports all QLogic Fibre Channel
 	PCI and PCIe host adapters.
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 5e2f149..f775b6b 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -25,6 +25,7 @@
 #include <linux/firmware.h>
 #include <linux/aer.h>
 #include <linux/mutex.h>
+#include <linux/btree.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
@@ -3301,6 +3302,7 @@ struct qlt_hw_data {
 	spinlock_t sess_lock;
 	int rspq_vector_cpuid;
 	spinlock_t atio_lock ____cacheline_aligned;
+	struct btree_head32 host_map;
 };
 
 #define MAX_QFULL_CMDS_ALLOC	8192
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 3cdeb0e..b5e96b7 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -854,5 +854,7 @@ extern struct fc_port *qlt_find_sess_invalidate_other(scsi_qla_host_t *,
 	uint64_t wwn, port_id_t port_id, uint16_t loop_id, struct fc_port **);
 void qla24xx_delete_sess_fn(struct work_struct *);
 void qlt_unknown_atio_work_fn(struct work_struct *);
+void qlt_update_host_map(struct scsi_qla_host *, port_id_t);
+void qlt_remove_target_resources(struct qla_hw_data *);
 
 #endif /* _QLA_GBL_H */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 5b1108b..c3ab96c 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3341,8 +3341,8 @@ void qla2x00_fcport_event_handler(scsi_qla_host_t *vha, struct event_arg *ea)
 	uint8_t       domain;
 	char		connect_type[22];
 	struct qla_hw_data *ha = vha->hw;
-	unsigned long flags;
 	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
+	port_id_t id;
 
 	/* Get host addresses. */
 	rval = qla2x00_get_adapter_id(vha,
@@ -3420,13 +3420,11 @@ void qla2x00_fcport_event_handler(scsi_qla_host_t *vha, struct event_arg *ea)
 
 	/* Save Host port and loop ID. */
 	/* byte order - Big Endian */
-	vha->d_id.b.domain = domain;
-	vha->d_id.b.area = area;
-	vha->d_id.b.al_pa = al_pa;
-
-	spin_lock_irqsave(&ha->vport_slock, flags);
-	qlt_update_vp_map(vha, SET_AL_PA);
-	spin_unlock_irqrestore(&ha->vport_slock, flags);
+	id.b.domain = domain;
+	id.b.area = area;
+	id.b.al_pa = al_pa;
+	id.b.rsvd_1 = 0;
+	qlt_update_host_map(vha, id);
 
 	if (!vha->flags.init_done)
 		ql_log(ql_log_info, vha, 0x2010,
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 0a01730..a113ab3 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3623,6 +3623,7 @@ struct tsk_mgmt_cmd {
 	scsi_qla_host_t *vp = NULL;
 	unsigned long   flags;
 	int found;
+	port_id_t id;
 
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x10b6,
 	    "Entered %s.\n", __func__);
@@ -3630,6 +3631,11 @@ struct tsk_mgmt_cmd {
 	if (rptid_entry->entry_status != 0)
 		return;
 
+	id.b.domain = rptid_entry->port_id[2];
+	id.b.area   = rptid_entry->port_id[1];
+	id.b.al_pa  = rptid_entry->port_id[0];
+	id.b.rsvd_1 = 0;
+
 	if (rptid_entry->format == 0) {
 		/* loop */
 		ql_dbg(ql_dbg_async, vha, 0x10b7,
@@ -3641,13 +3647,7 @@ struct tsk_mgmt_cmd {
 		    rptid_entry->port_id[2], rptid_entry->port_id[1],
 		    rptid_entry->port_id[0]);
 
-		vha->d_id.b.domain = rptid_entry->port_id[2];
-		vha->d_id.b.area = rptid_entry->port_id[1];
-		vha->d_id.b.al_pa = rptid_entry->port_id[0];
-
-		spin_lock_irqsave(&ha->vport_slock, flags);
-		qlt_update_vp_map(vha, SET_AL_PA);
-		spin_unlock_irqrestore(&ha->vport_slock, flags);
+		qlt_update_host_map(vha, id);
 
 	} else if (rptid_entry->format == 1) {
 		/* fabric */
@@ -3673,12 +3673,7 @@ struct tsk_mgmt_cmd {
 					    WWN_SIZE);
 				}
 
-				vha->d_id.b.domain = rptid_entry->port_id[2];
-				vha->d_id.b.area = rptid_entry->port_id[1];
-				vha->d_id.b.al_pa = rptid_entry->port_id[0];
-				spin_lock_irqsave(&ha->vport_slock, flags);
-				qlt_update_vp_map(vha, SET_AL_PA);
-				spin_unlock_irqrestore(&ha->vport_slock, flags);
+				qlt_update_host_map(vha, id);
 			}
 
 			fc_host_port_name(vha->host) =
@@ -3714,12 +3709,7 @@ struct tsk_mgmt_cmd {
 			if (!found)
 				return;
 
-			vp->d_id.b.domain = rptid_entry->port_id[2];
-			vp->d_id.b.area =  rptid_entry->port_id[1];
-			vp->d_id.b.al_pa = rptid_entry->port_id[0];
-			spin_lock_irqsave(&ha->vport_slock, flags);
-			qlt_update_vp_map(vp, SET_AL_PA);
-			spin_unlock_irqrestore(&ha->vport_slock, flags);
+			qlt_update_host_map(vp, id);
 
 			/*
 			 * Cannot configure here as we are still sitting on the
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 4867589..947f3e2 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3489,6 +3489,7 @@ static void qla2x00_iocb_work_fn(struct work_struct *work)
 	qla2x00_free_sysfs_attr(base_vha, true);
 
 	fc_remove_host(base_vha->host);
+	qlt_remove_target_resources(ha);
 
 	scsi_remove_host(base_vha->host);
 
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 873cbf7..2720b8f6 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -184,21 +184,23 @@ static inline int qlt_issue_marker(struct scsi_qla_host *vha, int vha_locked)
 struct scsi_qla_host *qlt_find_host_by_d_id(struct scsi_qla_host *vha,
 	uint8_t *d_id)
 {
-	struct qla_hw_data *ha = vha->hw;
-	uint8_t vp_idx;
-
-	if ((vha->d_id.b.area != d_id[1]) || (vha->d_id.b.domain != d_id[0]))
-		return NULL;
+	struct scsi_qla_host *host;
+	uint32_t key = 0;
 
-	if (vha->d_id.b.al_pa == d_id[2])
+	if ((vha->d_id.b.area == d_id[1]) && (vha->d_id.b.domain == d_id[0]) &&
+	    (vha->d_id.b.al_pa == d_id[2]))
 		return vha;
 
-	BUG_ON(ha->tgt.tgt_vp_map == NULL);
-	vp_idx = ha->tgt.tgt_vp_map[d_id[2]].idx;
-	if (likely(test_bit(vp_idx, ha->vp_idx_map)))
-		return ha->tgt.tgt_vp_map[vp_idx].vha;
+	key  = (uint32_t)d_id[0] << 16;
+	key |= (uint32_t)d_id[1] <<  8;
+	key |= (uint32_t)d_id[2];
 
-	return NULL;
+	host = btree_lookup32(&vha->hw->tgt.host_map, key);
+	if (!host)
+		ql_dbg(ql_dbg_tgt_mgt, vha, 0xffff,
+			   "Unable to find host %06x\n", key);
+
+	return host;
 }
 
 static inline
@@ -6030,6 +6032,17 @@ int qlt_remove_target(struct qla_hw_data *ha, struct scsi_qla_host *vha)
 	return 0;
 }
 
+void qlt_remove_target_resources(struct qla_hw_data *ha)
+{
+	struct scsi_qla_host *node;
+	u32 key = 0;
+
+	btree_for_each_safe32(&ha->tgt.host_map, key, node)
+		btree_remove32(&ha->tgt.host_map, key);
+
+	btree_destroy32(&ha->tgt.host_map);
+}
+
 static void qlt_lport_dump(struct scsi_qla_host *vha, u64 wwpn,
 	unsigned char *b)
 {
@@ -6683,6 +6696,8 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 void
 qlt_probe_one_stage1(struct scsi_qla_host *base_vha, struct qla_hw_data *ha)
 {
+	int rc;
+
 	if (!QLA_TGT_MODE_ENABLED())
 		return;
 
@@ -6702,6 +6717,13 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 	    qlt_unknown_atio_work_fn);
 
 	qlt_clear_mode(base_vha);
+
+	rc = btree_init32(&ha->tgt.host_map);
+	if (rc)
+		ql_log(ql_log_info, base_vha, 0xffff,
+		    "Unable to initialize ha->host_map btree\n");
+
+	qlt_update_vp_map(base_vha, SET_VP_IDX);
 }
 
 irqreturn_t
@@ -6808,25 +6830,69 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 void
 qlt_update_vp_map(struct scsi_qla_host *vha, int cmd)
 {
+	void *slot;
+	u32 key;
+	int rc;
+
 	if (!QLA_TGT_MODE_ENABLED())
 		return;
 
+	key = vha->d_id.b24;
+
 	switch (cmd) {
 	case SET_VP_IDX:
 		vha->hw->tgt.tgt_vp_map[vha->vp_idx].vha = vha;
 		break;
 	case SET_AL_PA:
-		vha->hw->tgt.tgt_vp_map[vha->d_id.b.al_pa].idx = vha->vp_idx;
+		slot = btree_lookup32(&vha->hw->tgt.host_map, key);
+		if (!slot) {
+			ql_dbg(ql_dbg_tgt_mgt, vha, 0xffff,
+			    "Save vha in host_map %p %06x\n", vha, key);
+			rc = btree_insert32(&vha->hw->tgt.host_map,
+				key, vha, GFP_ATOMIC);
+			if (rc)
+				ql_log(ql_log_info, vha, 0xffff,
+				    "Unable to insert s_id into host_map: %06x\n",
+				    key);
+			return;
+		}
+		ql_dbg(ql_dbg_tgt_mgt, vha, 0xffff,
+			"replace existing vha in host_map %p %06x\n", vha, key);
+		btree_update32(&vha->hw->tgt.host_map, key, vha);
 		break;
 	case RESET_VP_IDX:
 		vha->hw->tgt.tgt_vp_map[vha->vp_idx].vha = NULL;
 		break;
 	case RESET_AL_PA:
-		vha->hw->tgt.tgt_vp_map[vha->d_id.b.al_pa].idx = 0;
+		ql_dbg(ql_dbg_tgt_mgt, vha, 0xffff,
+		   "clear vha in host_map %p %06x\n", vha, key);
+		slot = btree_lookup32(&vha->hw->tgt.host_map, key);
+		if (slot)
+			btree_remove32(&vha->hw->tgt.host_map, key);
+		vha->d_id.b24 = 0;
 		break;
 	}
 }
 
+void qlt_update_host_map(struct scsi_qla_host *vha, port_id_t id)
+{
+	unsigned long flags;
+	struct qla_hw_data *ha = vha->hw;
+
+	if (!vha->d_id.b24) {
+		spin_lock_irqsave(&ha->vport_slock, flags);
+		vha->d_id = id;
+		qlt_update_vp_map(vha, SET_AL_PA);
+		spin_unlock_irqrestore(&ha->vport_slock, flags);
+	} else if (vha->d_id.b24 != id.b24) {
+		spin_lock_irqsave(&ha->vport_slock, flags);
+		qlt_update_vp_map(vha, RESET_AL_PA);
+		vha->d_id = id;
+		qlt_update_vp_map(vha, SET_AL_PA);
+		spin_unlock_irqrestore(&ha->vport_slock, flags);
+	}
+}
+
 static int __init qlt_parse_ini_mode(void)
 {
 	if (strcasecmp(qlini_mode, QLA2XXX_INI_MODE_STR_EXCLUSIVE) == 0)
-- 
1.8.3.1
