From: madhu.iyengar@qlogic.com
Subject: [PATCH 1/7] qla2xxx: Fix vport delete issues
Date: Fri,  3 Sep 2010 14:57:00 -0700
Message-ID: <1283551026-3886-2-git-send-email-madhu.iyengar@qlogic.com>
References: <1283551026-3886-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:42962 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1757584Ab0ICWDH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Sep 2010 18:03:07 -0400
In-Reply-To: <1283551026-3886-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: nkmi@yahoo.com

From: Arun Easi <arun.easi@qlogic.com>


Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   23 ++++++---
 drivers/scsi/qla2xxx/qla_dbg.h  |    2 -
 drivers/scsi/qla2xxx/qla_def.h  |   20 ++++++++
 drivers/scsi/qla2xxx/qla_init.c |   94 +++++++++++++++++++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_mbx.c  |    7 ++-
 drivers/scsi/qla2xxx/qla_mid.c  |   67 +++++++++++++++++++++++++---
 drivers/scsi/qla2xxx/qla_os.c   |   30 +++++++++++--
 7 files changed, 207 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 420238c..114bc5a 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1838,26 +1838,33 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 
 	qla24xx_disable_vp(vha);
 
+	vha->flags.delete_progress = 1;
+
 	fc_remove_host(vha->host);
 
 	scsi_remove_host(vha->host);
 
-	qla2x00_free_fcports(vha);
+	if (vha->timer_active) {
+		qla2x00_vp_stop_timer(vha);
+		DEBUG15(printk(KERN_INFO "scsi(%ld): timer for the vport[%d]"
+		" = %p has stopped\n", vha->host_no, vha->vp_idx, vha));
+	}
 
 	qla24xx_deallocate_vp_id(vha);
 
+	/* No pending activities shall be there on the vha now */
+	DEBUG(msleep(random32()%10));  /* Just to see if something falls on
+					* the net we have placed below */
+
+	BUG_ON(atomic_read(&vha->vref_count));
+
+	qla2x00_free_fcports(vha);
+
 	mutex_lock(&ha->vport_lock);
 	ha->cur_vport_count--;
 	clear_bit(vha->vp_idx, ha->vp_idx_map);
 	mutex_unlock(&ha->vport_lock);
 
-	if (vha->timer_active) {
-		qla2x00_vp_stop_timer(vha);
-		DEBUG15(printk ("scsi(%ld): timer for the vport[%d] = %p "
-		    "has stopped\n",
-		    vha->host_no, vha->vp_idx, vha));
-        }
-
 	if (vha->req->id && !ha->flags.cpu_affinity_enabled) {
 		if (qla25xx_delete_req_que(vha, vha->req) != QLA_SUCCESS)
 			qla_printk(KERN_WARNING, ha,
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index 6cfc28a..b74e6b5 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -29,8 +29,6 @@
 /* #define QL_DEBUG_LEVEL_17 */ /* Output EEH trace messages */
 /* #define QL_DEBUG_LEVEL_18 */ /* Output T10 CRC trace messages */
 
-/* #define QL_PRINTK_BUF */ /* Captures printk to buffer */
-
 /*
 * Macros use for debugging the driver.
 */
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 3a432ea..d2a4e15 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2641,6 +2641,7 @@ struct qla_hw_data {
 #define MBX_UPDATE_FLASH_ACTIVE	3
 
 	struct mutex vport_lock;        /* Virtual port synchronization */
+	spinlock_t vport_slock; /* order is hardware_lock, then vport_slock */
 	struct completion mbx_cmd_comp; /* Serialize mbx access */
 	struct completion mbx_intr_comp;  /* Used for completion notification */
 	struct completion dcbx_comp;	/* For set port config notification */
@@ -2828,6 +2829,7 @@ typedef struct scsi_qla_host {
 		uint32_t	management_server_logged_in :1;
 		uint32_t	process_response_queue	:1;
 		uint32_t	difdix_supported:1;
+		uint32_t	delete_progress:1;
 	} flags;
 
 	atomic_t	loop_state;
@@ -2922,6 +2924,8 @@ typedef struct scsi_qla_host {
 	struct req_que *req;
 	int		fw_heartbeat_counter;
 	int		seconds_since_last_heartbeat;
+
+	atomic_t	vref_count;
 } scsi_qla_host_t;
 
 /*
@@ -2932,6 +2936,22 @@ typedef struct scsi_qla_host {
 	 test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags) || \
 	 atomic_read(&ha->loop_state) == LOOP_DOWN)
 
+#define QLA_VHA_MARK_BUSY(__vha, __bail) do {		     \
+	atomic_inc(&__vha->vref_count);			     \
+	mb();						     \
+	if (__vha->flags.delete_progress) {		     \
+		atomic_dec(&__vha->vref_count);		     \
+		__bail = 1;				     \
+	} else {					     \
+		__bail = 0;				     \
+	}						     \
+} while (0)
+
+#define QLA_VHA_MARK_NOT_BUSY(__vha) do {		     \
+	atomic_dec(&__vha->vref_count);			     \
+} while (0)
+
+
 #define qla_printk(level, ha, format, arg...) \
 	dev_printk(level , &((ha)->pdev->dev) , format , ## arg)
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index d863ed2..9c383ba 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -69,21 +69,29 @@ qla2x00_ctx_sp_free(srb_t *sp)
 {
 	struct srb_ctx *ctx = sp->ctx;
 	struct srb_iocb *iocb = ctx->u.iocb_cmd;
+	struct scsi_qla_host *vha = sp->fcport->vha;
 
 	del_timer_sync(&iocb->timer);
 	kfree(iocb);
 	kfree(ctx);
 	mempool_free(sp, sp->fcport->vha->hw->srb_mempool);
+
+	QLA_VHA_MARK_NOT_BUSY(vha);
 }
 
 inline srb_t *
 qla2x00_get_ctx_sp(scsi_qla_host_t *vha, fc_port_t *fcport, size_t size,
     unsigned long tmo)
 {
-	srb_t *sp;
+	srb_t *sp = NULL;
 	struct qla_hw_data *ha = vha->hw;
 	struct srb_ctx *ctx;
 	struct srb_iocb *iocb;
+	uint8_t bail;
+
+	QLA_VHA_MARK_BUSY(vha, bail);
+	if (bail)
+		return NULL;
 
 	sp = mempool_alloc(ha->srb_mempool, GFP_KERNEL);
 	if (!sp)
@@ -116,6 +124,8 @@ qla2x00_get_ctx_sp(scsi_qla_host_t *vha, fc_port_t *fcport, size_t size,
 	iocb->timer.function = qla2x00_ctx_sp_timeout;
 	add_timer(&iocb->timer);
 done:
+	if (!sp)
+		QLA_VHA_MARK_NOT_BUSY(vha);
 	return sp;
 }
 
@@ -1777,11 +1787,15 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 		qla2x00_init_response_q_entries(rsp);
 	}
 
+	spin_lock_irqsave(&ha->vport_slock, flags);
 	/* Clear RSCN queue. */
 	list_for_each_entry(vp, &ha->vp_list, list) {
 		vp->rscn_in_ptr = 0;
 		vp->rscn_out_ptr = 0;
 	}
+
+	spin_unlock_irqrestore(&ha->vport_slock, flags);
+
 	ha->isp_ops->config_rings(vha);
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -3218,12 +3232,17 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
 		/* Bypass virtual ports of the same host. */
 		found = 0;
 		if (ha->num_vhosts) {
+			unsigned long flags;
+
+			spin_lock_irqsave(&ha->vport_slock, flags);
 			list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
 				if (new_fcport->d_id.b24 == vp->d_id.b24) {
 					found = 1;
 					break;
 				}
 			}
+			spin_unlock_irqrestore(&ha->vport_slock, flags);
+
 			if (found)
 				continue;
 		}
@@ -3343,6 +3362,7 @@ qla2x00_find_new_loop_id(scsi_qla_host_t *vha, fc_port_t *dev)
 	struct qla_hw_data *ha = vha->hw;
 	struct scsi_qla_host *vp;
 	struct scsi_qla_host *tvp;
+	unsigned long flags = 0;
 
 	rval = QLA_SUCCESS;
 
@@ -3367,6 +3387,8 @@ qla2x00_find_new_loop_id(scsi_qla_host_t *vha, fc_port_t *dev)
 		/* Check for loop ID being already in use. */
 		found = 0;
 		fcport = NULL;
+
+		spin_lock_irqsave(&ha->vport_slock, flags);
 		list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
 			list_for_each_entry(fcport, &vp->vp_fcports, list) {
 				if (fcport->loop_id == dev->loop_id &&
@@ -3379,6 +3401,7 @@ qla2x00_find_new_loop_id(scsi_qla_host_t *vha, fc_port_t *dev)
 			if (found)
 				break;
 		}
+		spin_unlock_irqrestore(&ha->vport_slock, flags);
 
 		/* If not in use then it is free to use. */
 		if (!found) {
@@ -3791,14 +3814,27 @@ void
 qla2x00_update_fcports(scsi_qla_host_t *base_vha)
 {
 	fc_port_t *fcport;
-	struct scsi_qla_host *tvp, *vha;
+	struct scsi_qla_host *vha;
+	struct qla_hw_data *ha = base_vha->hw;
+	unsigned long flags;
 
+	spin_lock_irqsave(&ha->vport_slock, flags);
 	/* Go with deferred removal of rport references. */
-	list_for_each_entry_safe(vha, tvp, &base_vha->hw->vp_list, list)
-		list_for_each_entry(fcport, &vha->vp_fcports, list)
+	list_for_each_entry(vha, &base_vha->hw->vp_list, list) {
+		atomic_inc(&vha->vref_count);
+		list_for_each_entry(fcport, &vha->vp_fcports, list) {
 			if (fcport && fcport->drport &&
-			    atomic_read(&fcport->state) != FCS_UNCONFIGURED)
+			    atomic_read(&fcport->state) != FCS_UNCONFIGURED) {
+				spin_unlock_irqrestore(&ha->vport_slock, flags);
+
 				qla2x00_rport_del(fcport);
+
+				spin_lock_irqsave(&ha->vport_slock, flags);
+			}
+		}
+		atomic_dec(&vha->vref_count);
+	}
+	spin_unlock_irqrestore(&ha->vport_slock, flags);
 }
 
 void
@@ -3806,7 +3842,7 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
 	struct scsi_qla_host *vp, *base_vha = pci_get_drvdata(ha->pdev);
-	struct scsi_qla_host *tvp;
+	unsigned long flags;
 
 	vha->flags.online = 0;
 	ha->flags.chip_reset_done = 0;
@@ -3824,8 +3860,18 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
 	if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
 		atomic_set(&vha->loop_state, LOOP_DOWN);
 		qla2x00_mark_all_devices_lost(vha, 0);
-		list_for_each_entry_safe(vp, tvp, &base_vha->hw->vp_list, list)
+
+		spin_lock_irqsave(&ha->vport_slock, flags);
+		list_for_each_entry(vp, &base_vha->hw->vp_list, list) {
+			atomic_inc(&vp->vref_count);
+			spin_unlock_irqrestore(&ha->vport_slock, flags);
+
 			qla2x00_mark_all_devices_lost(vp, 0);
+
+			spin_lock_irqsave(&ha->vport_slock, flags);
+			atomic_dec(&vp->vref_count);
+		}
+		spin_unlock_irqrestore(&ha->vport_slock, flags);
 	} else {
 		if (!atomic_read(&vha->loop_down_timer))
 			atomic_set(&vha->loop_down_timer,
@@ -3862,8 +3908,8 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 	uint8_t        status = 0;
 	struct qla_hw_data *ha = vha->hw;
 	struct scsi_qla_host *vp;
-	struct scsi_qla_host *tvp;
 	struct req_que *req = ha->req_q_map[0];
+	unsigned long flags;
 
 	if (vha->flags.online) {
 		qla2x00_abort_isp_cleanup(vha);
@@ -3970,10 +4016,21 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 		DEBUG(printk(KERN_INFO
 				"qla2x00_abort_isp(%ld): succeeded.\n",
 				vha->host_no));
-		list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
-			if (vp->vp_idx)
+
+		spin_lock_irqsave(&ha->vport_slock, flags);
+		list_for_each_entry(vp, &ha->vp_list, list) {
+			if (vp->vp_idx) {
+				atomic_inc(&vp->vref_count);
+				spin_unlock_irqrestore(&ha->vport_slock, flags);
+
 				qla2x00_vp_abort_isp(vp);
+
+				spin_lock_irqsave(&ha->vport_slock, flags);
+				atomic_dec(&vp->vref_count);
+			}
 		}
+		spin_unlock_irqrestore(&ha->vport_slock, flags);
+
 	} else {
 		qla_printk(KERN_INFO, ha,
 			"qla2x00_abort_isp: **** FAILED ****\n");
@@ -5185,7 +5242,7 @@ qla82xx_restart_isp(scsi_qla_host_t *vha)
 	struct req_que *req = ha->req_q_map[0];
 	struct rsp_que *rsp = ha->rsp_q_map[0];
 	struct scsi_qla_host *vp;
-	struct scsi_qla_host *tvp;
+	unsigned long flags;
 
 	status = qla2x00_init_rings(vha);
 	if (!status) {
@@ -5272,10 +5329,21 @@ qla82xx_restart_isp(scsi_qla_host_t *vha)
 		DEBUG(printk(KERN_INFO
 			"qla82xx_restart_isp(%ld): succeeded.\n",
 			vha->host_no));
-		list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
-			if (vp->vp_idx)
+
+		spin_lock_irqsave(&ha->vport_slock, flags);
+		list_for_each_entry(vp, &ha->vp_list, list) {
+			if (vp->vp_idx) {
+				atomic_inc(&vp->vref_count);
+				spin_unlock_irqrestore(&ha->vport_slock, flags);
+
 				qla2x00_vp_abort_isp(vp);
+
+				spin_lock_irqsave(&ha->vport_slock, flags);
+				atomic_dec(&vp->vref_count);
+			}
 		}
+		spin_unlock_irqrestore(&ha->vport_slock, flags);
+
 	} else {
 		qla_printk(KERN_INFO, ha,
 			"qla82xx_restart_isp: **** FAILED ****\n");
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 6009b0c..a595ec8 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2913,7 +2913,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 	uint16_t stat = le16_to_cpu(rptid_entry->vp_idx);
 	struct qla_hw_data *ha = vha->hw;
 	scsi_qla_host_t *vp;
-	scsi_qla_host_t *tvp;
+	unsigned long   flags;
 
 	if (rptid_entry->entry_status != 0)
 		return;
@@ -2945,9 +2945,12 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 			return;
 		}
 
-		list_for_each_entry_safe(vp, tvp, &ha->vp_list, list)
+		spin_lock_irqsave(&ha->vport_slock, flags);
+		list_for_each_entry(vp, &ha->vp_list, list)
 			if (vp_idx == vp->vp_idx)
 				break;
+		spin_unlock_irqrestore(&ha->vport_slock, flags);
+
 		if (!vp)
 			return;
 
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 987c5b0..bc1a745 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -30,6 +30,7 @@ qla24xx_allocate_vp_id(scsi_qla_host_t *vha)
 {
 	uint32_t vp_id;
 	struct qla_hw_data *ha = vha->hw;
+	unsigned long flags;
 
 	/* Find an empty slot and assign an vp_id */
 	mutex_lock(&ha->vport_lock);
@@ -44,7 +45,11 @@ qla24xx_allocate_vp_id(scsi_qla_host_t *vha)
 	set_bit(vp_id, ha->vp_idx_map);
 	ha->num_vhosts++;
 	vha->vp_idx = vp_id;
+
+	spin_lock_irqsave(&ha->vport_slock, flags);
 	list_add_tail(&vha->list, &ha->vp_list);
+	spin_unlock_irqrestore(&ha->vport_slock, flags);
+
 	mutex_unlock(&ha->vport_lock);
 	return vp_id;
 }
@@ -54,12 +59,31 @@ qla24xx_deallocate_vp_id(scsi_qla_host_t *vha)
 {
 	uint16_t vp_id;
 	struct qla_hw_data *ha = vha->hw;
+	unsigned long flags = 0;
 
 	mutex_lock(&ha->vport_lock);
+	/*
+	 * Wait for all pending activities to finish before removing vport from
+	 * the list.
+	 * Lock needs to be held for safe removal from the list (it
+	 * ensures no active vp_list traversal while the vport is removed
+	 * from the queue)
+	 */
+	spin_lock_irqsave(&ha->vport_slock, flags);
+	while (atomic_read(&vha->vref_count)) {
+		spin_unlock_irqrestore(&ha->vport_slock, flags);
+
+		msleep(500);
+
+		spin_lock_irqsave(&ha->vport_slock, flags);
+	}
+	list_del(&vha->list);
+	spin_unlock_irqrestore(&ha->vport_slock, flags);
+
 	vp_id = vha->vp_idx;
 	ha->num_vhosts--;
 	clear_bit(vp_id, ha->vp_idx_map);
-	list_del(&vha->list);
+
 	mutex_unlock(&ha->vport_lock);
 }
 
@@ -68,12 +92,17 @@ qla24xx_find_vhost_by_name(struct qla_hw_data *ha, uint8_t *port_name)
 {
 	scsi_qla_host_t *vha;
 	struct scsi_qla_host *tvha;
+	unsigned long flags;
 
+	spin_lock_irqsave(&ha->vport_slock, flags);
 	/* Locate matching device in database. */
 	list_for_each_entry_safe(vha, tvha, &ha->vp_list, list) {
-		if (!memcmp(port_name, vha->port_name, WWN_SIZE))
+		if (!memcmp(port_name, vha->port_name, WWN_SIZE)) {
+			spin_unlock_irqrestore(&ha->vport_slock, flags);
 			return vha;
+		}
 	}
+	spin_unlock_irqrestore(&ha->vport_slock, flags);
 	return NULL;
 }
 
@@ -93,6 +122,12 @@ qla24xx_find_vhost_by_name(struct qla_hw_data *ha, uint8_t *port_name)
 static void
 qla2x00_mark_vp_devices_dead(scsi_qla_host_t *vha)
 {
+	/*
+	 * !!! NOTE !!!
+	 * This function, if called in contexts other than vp create, disable
+	 * or delete, please make sure this is synchronized with the
+	 * delete thread.
+	 */
 	fc_port_t *fcport;
 
 	list_for_each_entry(fcport, &vha->vp_fcports, list) {
@@ -194,12 +229,17 @@ qla24xx_configure_vp(scsi_qla_host_t *vha)
 void
 qla2x00_alert_all_vps(struct rsp_que *rsp, uint16_t *mb)
 {
-	scsi_qla_host_t *vha, *tvha;
+	scsi_qla_host_t *vha;
 	struct qla_hw_data *ha = rsp->hw;
 	int i = 0;
+	unsigned long flags;
 
-	list_for_each_entry_safe(vha, tvha, &ha->vp_list, list) {
+	spin_lock_irqsave(&ha->vport_slock, flags);
+	list_for_each_entry(vha, &ha->vp_list, list) {
 		if (vha->vp_idx) {
+			atomic_inc(&vha->vref_count);
+			spin_unlock_irqrestore(&ha->vport_slock, flags);
+
 			switch (mb[0]) {
 			case MBA_LIP_OCCURRED:
 			case MBA_LOOP_UP:
@@ -215,9 +255,13 @@ qla2x00_alert_all_vps(struct rsp_que *rsp, uint16_t *mb)
 				qla2x00_async_event(vha, rsp, mb);
 				break;
 			}
+
+			spin_lock_irqsave(&ha->vport_slock, flags);
+			atomic_dec(&vha->vref_count);
 		}
 		i++;
 	}
+	spin_unlock_irqrestore(&ha->vport_slock, flags);
 }
 
 int
@@ -297,7 +341,7 @@ qla2x00_do_dpc_all_vps(scsi_qla_host_t *vha)
 	int ret;
 	struct qla_hw_data *ha = vha->hw;
 	scsi_qla_host_t *vp;
-	struct scsi_qla_host *tvp;
+	unsigned long flags = 0;
 
 	if (vha->vp_idx)
 		return;
@@ -309,10 +353,19 @@ qla2x00_do_dpc_all_vps(scsi_qla_host_t *vha)
 	if (!(ha->current_topology & ISP_CFG_F))
 		return;
 
-	list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
-		if (vp->vp_idx)
+	spin_lock_irqsave(&ha->vport_slock, flags);
+	list_for_each_entry(vp, &ha->vp_list, list) {
+		if (vp->vp_idx) {
+			atomic_inc(&vp->vref_count);
+			spin_unlock_irqrestore(&ha->vport_slock, flags);
+
 			ret = qla2x00_do_dpc_vp(vp);
+
+			spin_lock_irqsave(&ha->vport_slock, flags);
+			atomic_dec(&vp->vref_count);
+		}
 	}
+	spin_unlock_irqrestore(&ha->vport_slock, flags);
 }
 
 int
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8c80b49..1e4bff6 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2341,16 +2341,28 @@ probe_out:
 static void
 qla2x00_remove_one(struct pci_dev *pdev)
 {
-	scsi_qla_host_t *base_vha, *vha, *temp;
+	scsi_qla_host_t *base_vha, *vha;
 	struct qla_hw_data  *ha;
+	unsigned long flags;
 
 	base_vha = pci_get_drvdata(pdev);
 	ha = base_vha->hw;
 
-	list_for_each_entry_safe(vha, temp, &ha->vp_list, list) {
-		if (vha && vha->fc_vport)
+	spin_lock_irqsave(&ha->vport_slock, flags);
+	list_for_each_entry(vha, &ha->vp_list, list) {
+		atomic_inc(&vha->vref_count);
+
+		if (vha && vha->fc_vport) {
+			spin_unlock_irqrestore(&ha->vport_slock, flags);
+
 			fc_vport_terminate(vha->fc_vport);
+
+			spin_lock_irqsave(&ha->vport_slock, flags);
+		}
+
+		atomic_dec(&vha->vref_count);
 	}
+	spin_unlock_irqrestore(&ha->vport_slock, flags);
 
 	set_bit(UNLOADING, &base_vha->dpc_flags);
 
@@ -2975,10 +2987,17 @@ static struct qla_work_evt *
 qla2x00_alloc_work(struct scsi_qla_host *vha, enum qla_work_type type)
 {
 	struct qla_work_evt *e;
+	uint8_t bail;
+
+	QLA_VHA_MARK_BUSY(vha, bail);
+	if (bail)
+		return NULL;
 
 	e = kzalloc(sizeof(struct qla_work_evt), GFP_ATOMIC);
-	if (!e)
+	if (!e) {
+		QLA_VHA_MARK_NOT_BUSY(vha);
 		return NULL;
+	}
 
 	INIT_LIST_HEAD(&e->list);
 	e->type = type;
@@ -3135,6 +3154,9 @@ qla2x00_do_work(struct scsi_qla_host *vha)
 		}
 		if (e->flags & QLA_EVT_FLAG_FREE)
 			kfree(e);
+
+		/* For each work completed decrement vha ref count */
+		QLA_VHA_MARK_NOT_BUSY(vha);
 	}
 }
 
-- 
1.6.0.2

