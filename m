From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 08/22] qla2xxx: Refactor shutdown code so some functionality can be reused.
Date: Wed, 30 Oct 2013 03:38:15 -0400
Message-ID: <1383118709-5569-9-git-send-email-saurav.kashyap@qlogic.com>
References: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [67.231.156.153] ([67.231.156.153]:26016 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752828Ab3J3ILX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Oct 2013 04:11:23 -0400
In-Reply-To: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    4 +-
 drivers/scsi/qla2xxx/qla_gbl.h  |    3 +-
 drivers/scsi/qla2xxx/qla_os.c   |  170 +++++++++++++++++++++------------------
 3 files changed, 96 insertions(+), 81 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 5f174b8..3464782 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -862,7 +862,7 @@ qla2x00_alloc_sysfs_attr(scsi_qla_host_t *vha)
 }
 
 void
-qla2x00_free_sysfs_attr(scsi_qla_host_t *vha)
+qla2x00_free_sysfs_attr(scsi_qla_host_t *vha, bool stop_beacon)
 {
 	struct Scsi_Host *host = vha->host;
 	struct sysfs_entry *iter;
@@ -880,7 +880,7 @@ qla2x00_free_sysfs_attr(scsi_qla_host_t *vha)
 		    iter->attr);
 	}
 
-	if (ha->beacon_blink_led == 1)
+	if (stop_beacon && ha->beacon_blink_led == 1)
 		ha->isp_ops->beacon_off(vha);
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 826df52..df52f73 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -540,10 +540,9 @@ struct fc_function_template;
 extern struct fc_function_template qla2xxx_transport_functions;
 extern struct fc_function_template qla2xxx_transport_vport_functions;
 extern void qla2x00_alloc_sysfs_attr(scsi_qla_host_t *);
-extern void qla2x00_free_sysfs_attr(scsi_qla_host_t *);
+extern void qla2x00_free_sysfs_attr(scsi_qla_host_t *, bool);
 extern void qla2x00_init_host_attr(scsi_qla_host_t *);
 extern void qla2x00_alloc_sysfs_attr(scsi_qla_host_t *);
-extern void qla2x00_free_sysfs_attr(scsi_qla_host_t *);
 extern int qla2x00_loopback_test(scsi_qla_host_t *, struct msg_echo_lb *, uint16_t *);
 extern int qla2x00_echo_test(scsi_qla_host_t *,
 	struct msg_echo_lb *, uint16_t *);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 01392d0..e683008 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2910,22 +2910,6 @@ probe_out:
 }
 
 static void
-qla2x00_stop_dpc_thread(scsi_qla_host_t *vha)
-{
-	struct qla_hw_data *ha = vha->hw;
-	struct task_struct *t = ha->dpc_thread;
-
-	if (ha->dpc_thread == NULL)
-		return;
-	/*
-	 * qla2xxx_wake_dpc checks for ->dpc_thread
-	 * so we need to zero it out.
-	 */
-	ha->dpc_thread = NULL;
-	kthread_stop(t);
-}
-
-static void
 qla2x00_shutdown(struct pci_dev *pdev)
 {
 	scsi_qla_host_t *vha;
@@ -2968,29 +2952,14 @@ qla2x00_shutdown(struct pci_dev *pdev)
 	qla2x00_free_fw_dump(ha);
 }
 
+/* Deletes all the virtual ports for a given ha */
 static void
-qla2x00_remove_one(struct pci_dev *pdev)
+qla2x00_delete_all_vps(struct qla_hw_data *ha, scsi_qla_host_t *base_vha)
 {
-	scsi_qla_host_t *base_vha, *vha;
-	struct qla_hw_data  *ha;
+	struct Scsi_Host *scsi_host;
+	scsi_qla_host_t *vha;
 	unsigned long flags;
 
-	/*
-	 * If the PCI device is disabled that means that probe failed and any
-	 * resources should be have cleaned up on probe exit.
-	 */
-	if (!atomic_read(&pdev->enable_cnt))
-		return;
-
-	base_vha = pci_get_drvdata(pdev);
-	ha = base_vha->hw;
-
-	ha->flags.host_shutting_down = 1;
-
-	set_bit(UNLOADING, &base_vha->dpc_flags);
-	if (IS_QLAFX00(ha))
-		qlafx00_driver_shutdown(base_vha, 20);
-
 	mutex_lock(&ha->vport_lock);
 	while (ha->cur_vport_count) {
 		spin_lock_irqsave(&ha->vport_slock, flags);
@@ -2998,7 +2967,7 @@ qla2x00_remove_one(struct pci_dev *pdev)
 		BUG_ON(base_vha->list.next == &ha->vp_list);
 		/* This assumes first entry in ha->vp_list is always base vha */
 		vha = list_first_entry(&base_vha->list, scsi_qla_host_t, list);
-		scsi_host_get(vha->host);
+		scsi_host = scsi_host_get(vha->host);
 
 		spin_unlock_irqrestore(&ha->vport_slock, flags);
 		mutex_unlock(&ha->vport_lock);
@@ -3009,27 +2978,12 @@ qla2x00_remove_one(struct pci_dev *pdev)
 		mutex_lock(&ha->vport_lock);
 	}
 	mutex_unlock(&ha->vport_lock);
+}
 
-	if (IS_QLA8031(ha)) {
-		ql_dbg(ql_dbg_p3p, base_vha, 0xb07e,
-		    "Clearing fcoe driver presence.\n");
-		if (qla83xx_clear_drv_presence(base_vha) != QLA_SUCCESS)
-			ql_dbg(ql_dbg_p3p, base_vha, 0xb079,
-			    "Error while clearing DRV-Presence.\n");
-	}
-
-	qla2x00_abort_all_cmds(base_vha, DID_NO_CONNECT << 16);
-
-	qla2x00_dfs_remove(base_vha);
-
-	qla84xx_put_chip(base_vha);
-
-	/* Disable timer */
-	if (base_vha->timer_active)
-		qla2x00_stop_timer(base_vha);
-
-	base_vha->flags.online = 0;
-
+/* Stops all deferred work threads */
+static void
+qla2x00_destroy_deferred_work(struct qla_hw_data *ha)
+{
 	/* Flush the work queue and remove it */
 	if (ha->wq) {
 		flush_workqueue(ha->wq);
@@ -3063,27 +3017,12 @@ qla2x00_remove_one(struct pci_dev *pdev)
 		ha->dpc_thread = NULL;
 		kthread_stop(t);
 	}
-	qlt_remove_target(ha, base_vha);
-
-	qla2x00_free_sysfs_attr(base_vha);
-
-	fc_remove_host(base_vha->host);
-
-	scsi_remove_host(base_vha->host);
-
-	qla2x00_free_device(base_vha);
-
-	scsi_host_put(base_vha->host);
+}
 
-	if (IS_QLA8044(ha)) {
-		qla8044_idc_lock(ha);
-		qla8044_clear_drv_active(base_vha);
-		qla8044_idc_unlock(ha);
-	}
+static void
+qla2x00_unmap_iobases(struct qla_hw_data *ha)
+{
 	if (IS_QLA82XX(ha)) {
-		qla82xx_idc_lock(ha);
-		qla82xx_clear_drv_active(ha);
-		qla82xx_idc_unlock(ha);
 
 		iounmap((device_reg_t __iomem *)ha->nx_pcibase);
 		if (!ql2xdbwr)
@@ -3101,6 +3040,84 @@ qla2x00_remove_one(struct pci_dev *pdev)
 		if (IS_QLA83XX(ha) && ha->msixbase)
 			iounmap(ha->msixbase);
 	}
+}
+
+static void
+qla2x00_clear_drv_active(scsi_qla_host_t *vha)
+{
+	struct qla_hw_data *ha = vha->hw;
+
+	if (IS_QLA8044(ha)) {
+		qla8044_idc_lock(ha);
+		qla8044_clear_drv_active(vha);
+		qla8044_idc_unlock(ha);
+	} else if (IS_QLA82XX(ha)) {
+		qla82xx_idc_lock(ha);
+		qla82xx_clear_drv_active(ha);
+		qla82xx_idc_unlock(ha);
+	}
+}
+
+static void
+qla2x00_remove_one(struct pci_dev *pdev)
+{
+	scsi_qla_host_t *base_vha;
+	struct qla_hw_data  *ha;
+
+	/*
+	 * If the PCI device is disabled that means that probe failed and any
+	 * resources should be have cleaned up on probe exit.
+	 */
+	if (!atomic_read(&pdev->enable_cnt))
+		return;
+
+	base_vha = pci_get_drvdata(pdev);
+	ha = base_vha->hw;
+
+	set_bit(UNLOADING, &base_vha->dpc_flags);
+
+	if (IS_QLAFX00(ha))
+		qlafx00_driver_shutdown(base_vha, 20);
+
+	qla2x00_delete_all_vps(ha, base_vha);
+
+	if (IS_QLA8031(ha)) {
+		ql_dbg(ql_dbg_p3p, base_vha, 0xb07e,
+		    "Clearing fcoe driver presence.\n");
+		if (qla83xx_clear_drv_presence(base_vha) != QLA_SUCCESS)
+			ql_dbg(ql_dbg_p3p, base_vha, 0xb079,
+			    "Error while clearing DRV-Presence.\n");
+	}
+
+	qla2x00_abort_all_cmds(base_vha, DID_NO_CONNECT << 16);
+
+	qla2x00_dfs_remove(base_vha);
+
+	qla84xx_put_chip(base_vha);
+
+	/* Disable timer */
+	if (base_vha->timer_active)
+		qla2x00_stop_timer(base_vha);
+
+	base_vha->flags.online = 0;
+
+	qla2x00_destroy_deferred_work(ha);
+
+	qlt_remove_target(ha, base_vha);
+
+	qla2x00_free_sysfs_attr(base_vha, true);
+
+	fc_remove_host(base_vha->host);
+
+	scsi_remove_host(base_vha->host);
+
+	qla2x00_free_device(base_vha);
+
+	scsi_host_put(base_vha->host);
+
+	qla2x00_clear_drv_active(base_vha);
+
+	qla2x00_unmap_iobases(ha);
 
 	pci_release_selected_regions(ha->pdev, ha->bars);
 	kfree(ha);
@@ -3123,9 +3140,8 @@ qla2x00_free_device(scsi_qla_host_t *vha)
 	if (vha->timer_active)
 		qla2x00_stop_timer(vha);
 
-	qla2x00_stop_dpc_thread(vha);
-
 	qla25xx_delete_queues(vha);
+
 	if (ha->flags.fce_enabled)
 		qla2x00_disable_fce_trace(vha, NULL, NULL);
 
-- 
1.7.7

