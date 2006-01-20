From: andrew.vasquez@qlogic.com
Subject: [PATCH 1/3] qla2xxx: Correct synchronization issues during rport addition/deletion.
Date: Fri, 20 Jan 2006 14:53:13 -0800
Message-ID: <11377975934045-git-send-email-andrew.vasquez@qlogic.com>
References: <20060120210857.GH3159@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:17329 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S932263AbWATWxP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jan 2006 17:53:15 -0500
In-Reply-To: <20060120210857.GH3159@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, mdr@sgi.com
Cc: andrew.vasquez@qlogic.com

The driver can typically detect port-loss during an
interrupt context (i.e. via interrogation of a status IOCB's
completion status [CS_PORT_LOGGED_OUT].  Due to the calling
requirements of the fc_rport APIs, the driver would defer
removal of the device to the default workqueue.  If the
work-item was preceded by an event which caused the port to
obtain visibility (relogin successful, target re-logged into
the topology), deferred removal could inadvertently drop the
rport.  The code also no longer defers removal via the
default workqueue, instead opting for use of the driver's
own DPC thread.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_def.h  |    4 ++-
 drivers/scsi/qla2xxx/qla_gbl.h  |    5 ++--
 drivers/scsi/qla2xxx/qla_init.c |   54 +++++++++++++++++++++++++++------------
 drivers/scsi/qla2xxx/qla_isr.c  |   16 ++++++------
 drivers/scsi/qla2xxx/qla_os.c   |   46 ++++++++++++++++++++++++++++-----
 5 files changed, 91 insertions(+), 34 deletions(-)

76891b08d2a84acb2315a1da9df1733141eb82c2
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 79d8a91..bad066e 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1680,7 +1680,8 @@ typedef struct fc_port {
 	uint8_t mp_byte;		/* multi-path byte (not used) */
     	uint8_t cur_path;		/* current path id */
 
-	struct fc_rport *rport;
+	spinlock_t rport_lock;
+	struct fc_rport *rport, *drport;
 	u32 supported_classes;
 	struct work_struct rport_add_work;
 	struct work_struct rport_del_work;
@@ -2270,6 +2271,7 @@ typedef struct scsi_qla_host {
 #define LOOP_RESET_NEEDED	24
 #define BEACON_BLINK_NEEDED	25
 #define REGISTER_FDMI_NEEDED	26
+#define FCPORT_UPDATE_NEEDED	27
 
 	uint32_t	device_flags;
 #define DFLG_LOCAL_DEVICES		BIT_0
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 32be4c1..0c1ec14 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -47,6 +47,7 @@ extern int qla2x00_local_device_login(sc
 extern void qla2x00_restart_queues(scsi_qla_host_t *, uint8_t);
 
 extern void qla2x00_rescan_fcports(scsi_qla_host_t *);
+extern void qla2x00_update_fcports(scsi_qla_host_t *);
 
 extern int qla2x00_abort_isp(scsi_qla_host_t *);
 
@@ -70,8 +71,8 @@ extern char *qla2x00_get_fw_version_str(
 
 extern void qla2x00_cmd_timeout(srb_t *);
 
-extern void qla2x00_mark_device_lost(scsi_qla_host_t *, fc_port_t *, int);
-extern void qla2x00_mark_all_devices_lost(scsi_qla_host_t *);
+extern void qla2x00_mark_device_lost(scsi_qla_host_t *, fc_port_t *, int, int);
+extern void qla2x00_mark_all_devices_lost(scsi_qla_host_t *, int);
 
 extern void qla2x00_blink_led(scsi_qla_host_t *);
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index a91fea6..4c7caec 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1688,10 +1688,16 @@ static void
 qla2x00_rport_del(void *data)
 {
 	fc_port_t *fcport = data;
+	struct fc_rport *rport;
+	unsigned long flags;
+
+	spin_lock_irqsave(&fcport->rport_lock, flags);
+	rport = fcport->drport;
+	fcport->drport = NULL;
+	spin_unlock_irqrestore(&fcport->rport_lock, flags);
+	if (rport)
+		fc_remote_port_delete(rport);
 
-	if (fcport->rport)
-		fc_remote_port_delete(fcport->rport);
-	fcport->rport = NULL;
 }
 
 /**
@@ -1719,6 +1725,7 @@ qla2x00_alloc_fcport(scsi_qla_host_t *ha
 	atomic_set(&fcport->state, FCS_UNCONFIGURED);
 	fcport->flags = FCF_RLC_SUPPORT;
 	fcport->supported_classes = FC_COS_UNSPECIFIED;
+	spin_lock_init(&fcport->rport_lock);
 	INIT_WORK(&fcport->rport_add_work, qla2x00_rport_add, fcport);
 	INIT_WORK(&fcport->rport_del_work, qla2x00_rport_del, fcport);
 
@@ -2008,7 +2015,7 @@ qla2x00_probe_for_all_luns(scsi_qla_host
 {
 	fc_port_t	*fcport;
 
-	qla2x00_mark_all_devices_lost(ha);
+	qla2x00_mark_all_devices_lost(ha, 0);
  	list_for_each_entry(fcport, &ha->fcports, list) {
 		if (fcport->port_type != FCT_TARGET)
 			continue;
@@ -2084,24 +2091,29 @@ qla2x00_reg_remote_port(scsi_qla_host_t 
 {
 	struct fc_rport_identifiers rport_ids;
 	struct fc_rport *rport;
+	unsigned long flags;
 
-	if (fcport->rport) {
-		fc_remote_port_delete(fcport->rport);
-		fcport->rport = NULL;
-	}
+	if (fcport->drport)
+		qla2x00_rport_del(fcport);
+	if (fcport->rport)
+		return;
 
 	rport_ids.node_name = wwn_to_u64(fcport->node_name);
 	rport_ids.port_name = wwn_to_u64(fcport->port_name);
 	rport_ids.port_id = fcport->d_id.b.domain << 16 |
 	    fcport->d_id.b.area << 8 | fcport->d_id.b.al_pa;
 	rport_ids.roles = FC_RPORT_ROLE_UNKNOWN;
-	fcport->rport = rport = fc_remote_port_add(ha->host, 0, &rport_ids);
+	rport = fc_remote_port_add(ha->host, 0, &rport_ids);
 	if (!rport) {
 		qla_printk(KERN_WARNING, ha,
 		    "Unable to allocate fc remote port!\n");
 		return;
 	}
+	spin_lock_irqsave(&fcport->rport_lock, flags);
+	fcport->rport = rport;
 	*((fc_port_t **)rport->dd_data) = fcport;
+	spin_unlock_irqrestore(&fcport->rport_lock, flags);
+
 	rport->supported_classes = fcport->supported_classes;
 
 	rport_ids.roles = FC_RPORT_ROLE_UNKNOWN;
@@ -2217,12 +2229,11 @@ qla2x00_configure_fabric(scsi_qla_host_t
 
 			if (atomic_read(&fcport->state) == FCS_DEVICE_LOST) {
 				qla2x00_mark_device_lost(ha, fcport,
-				    ql2xplogiabsentdevice);
+				    ql2xplogiabsentdevice, 0);
 				if (fcport->loop_id != FC_NO_LOOP_ID &&
 				    (fcport->flags & FCF_TAPE_PRESENT) == 0 &&
 				    fcport->port_type != FCT_INITIATOR &&
 				    fcport->port_type != FCT_BROADCAST) {
-
 					ha->isp_ops.fabric_logout(ha,
 					    fcport->loop_id,
 					    fcport->d_id.b.domain,
@@ -2694,7 +2705,8 @@ qla2x00_device_resync(scsi_qla_host_t *h
 			if (atomic_read(&fcport->state) == FCS_ONLINE) {
 				if (format != 3 ||
 				    fcport->port_type != FCT_INITIATOR) {
-					qla2x00_mark_device_lost(ha, fcport, 0);
+					qla2x00_mark_device_lost(ha, fcport,
+					    0, 0);
 				}
 			}
 			fcport->flags &= ~FCF_FARP_DONE;
@@ -2741,8 +2753,7 @@ qla2x00_fabric_dev_login(scsi_qla_host_t
 			ha->isp_ops.fabric_logout(ha, fcport->loop_id,
 			    fcport->d_id.b.domain, fcport->d_id.b.area,
 			    fcport->d_id.b.al_pa);
-			qla2x00_mark_device_lost(ha, fcport, 1);
-
+			qla2x00_mark_device_lost(ha, fcport, 1, 0);
 		} else {
 			qla2x00_update_fcport(ha, fcport);
 		}
@@ -2855,7 +2866,7 @@ qla2x00_fabric_login(scsi_qla_host_t *ha
 			ha->isp_ops.fabric_logout(ha, fcport->loop_id,
 			    fcport->d_id.b.domain, fcport->d_id.b.area,
 			    fcport->d_id.b.al_pa);
-			qla2x00_mark_device_lost(ha, fcport, 1);
+			qla2x00_mark_device_lost(ha, fcport, 1, 0);
 
 			rval = 1;
 			break;
@@ -2990,6 +3001,17 @@ qla2x00_rescan_fcports(scsi_qla_host_t *
 	qla2x00_probe_for_all_luns(ha);
 }
 
+void
+qla2x00_update_fcports(scsi_qla_host_t *ha)
+{
+	fc_port_t *fcport;
+
+	/* Go with deferred removal of rport references. */
+	list_for_each_entry(fcport, &ha->fcports, list)
+		if (fcport->drport)
+			qla2x00_rport_del(fcport);
+}
+
 /*
 *  qla2x00_abort_isp
 *      Resets ISP and aborts all outstanding commands.
@@ -3019,7 +3041,7 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 		atomic_set(&ha->loop_down_timer, LOOP_DOWN_TIME);
 		if (atomic_read(&ha->loop_state) != LOOP_DOWN) {
 			atomic_set(&ha->loop_state, LOOP_DOWN);
-			qla2x00_mark_all_devices_lost(ha);
+			qla2x00_mark_all_devices_lost(ha, 0);
 		} else {
 			if (!atomic_read(&ha->loop_down_timer))
 				atomic_set(&ha->loop_down_timer,
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index f63af08..71a46fc 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -389,7 +389,7 @@ qla2x00_async_event(scsi_qla_host_t *ha,
 		if (atomic_read(&ha->loop_state) != LOOP_DOWN) {
 			atomic_set(&ha->loop_state, LOOP_DOWN);
 			atomic_set(&ha->loop_down_timer, LOOP_DOWN_TIME);
-			qla2x00_mark_all_devices_lost(ha);
+			qla2x00_mark_all_devices_lost(ha, 1);
 		}
 
 		set_bit(REGISTER_FC4_NEEDED, &ha->dpc_flags);
@@ -432,7 +432,7 @@ qla2x00_async_event(scsi_qla_host_t *ha,
 			atomic_set(&ha->loop_state, LOOP_DOWN);
 			atomic_set(&ha->loop_down_timer, LOOP_DOWN_TIME);
 			ha->device_flags |= DFLG_NO_CABLE;
-			qla2x00_mark_all_devices_lost(ha);
+			qla2x00_mark_all_devices_lost(ha, 1);
 		}
 
 		ha->flags.management_server_logged_in = 0;
@@ -453,7 +453,7 @@ qla2x00_async_event(scsi_qla_host_t *ha,
 		if (atomic_read(&ha->loop_state) != LOOP_DOWN) {
 			atomic_set(&ha->loop_state, LOOP_DOWN);
 			atomic_set(&ha->loop_down_timer, LOOP_DOWN_TIME);
-			qla2x00_mark_all_devices_lost(ha);
+			qla2x00_mark_all_devices_lost(ha, 1);
 		}
 
 		set_bit(RESET_MARKER_NEEDED, &ha->dpc_flags);
@@ -482,7 +482,7 @@ qla2x00_async_event(scsi_qla_host_t *ha,
 			if (!atomic_read(&ha->loop_down_timer))
 				atomic_set(&ha->loop_down_timer,
 				    LOOP_DOWN_TIME);
-			qla2x00_mark_all_devices_lost(ha);
+			qla2x00_mark_all_devices_lost(ha, 1);
 		}
 
 		if (!(test_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags))) {
@@ -506,7 +506,7 @@ qla2x00_async_event(scsi_qla_host_t *ha,
 			if (!atomic_read(&ha->loop_down_timer))
 				atomic_set(&ha->loop_down_timer,
 				    LOOP_DOWN_TIME);
-			qla2x00_mark_all_devices_lost(ha);
+			qla2x00_mark_all_devices_lost(ha, 1);
 		}
 
 		set_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags);
@@ -580,7 +580,7 @@ qla2x00_async_event(scsi_qla_host_t *ha,
 		 */
 		atomic_set(&ha->loop_state, LOOP_UP);
 
-		qla2x00_mark_all_devices_lost(ha);
+		qla2x00_mark_all_devices_lost(ha, 1);
 
 		ha->flags.rscn_queue_overflow = 1;
 
@@ -1091,7 +1091,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 
 		cp->result = DID_BUS_BUSY << 16;
 		if (atomic_read(&fcport->state) == FCS_ONLINE) {
-			qla2x00_mark_device_lost(ha, fcport, 1);
+			qla2x00_mark_device_lost(ha, fcport, 1, 1);
 		}
 		break;
 
@@ -1135,7 +1135,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 
 		/* Check to see if logout occurred. */
 		if ((le16_to_cpu(sts->status_flags) & SF_LOGOUT_SENT))
-			qla2x00_mark_device_lost(ha, fcport, 1);
+			qla2x00_mark_device_lost(ha, fcport, 1, 1);
 		break;
 
 	case CS_QUEUE_FULL:
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 4916847..089e0f5 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -756,7 +756,7 @@ qla2xxx_eh_device_reset(struct scsi_cmnd
 		if (ret == SUCCESS) {
 			if (fcport->flags & FC_FABRIC_DEVICE) {
 				ha->isp_ops.fabric_logout(ha, fcport->loop_id);
-				qla2x00_mark_device_lost(ha, fcport);
+				qla2x00_mark_device_lost(ha, fcport, 0, 0);
 			}
 		}
 #endif
@@ -1642,6 +1642,31 @@ qla2x00_free_device(scsi_qla_host_t *ha)
 	pci_disable_device(ha->pdev);
 }
 
+static inline void
+qla2x00_schedule_rport_del(struct scsi_qla_host *ha, fc_port_t *fcport,
+    int defer)
+{
+	unsigned long flags;
+	struct fc_rport *rport;
+
+	if (!fcport->rport)
+		return;
+
+	rport = fcport->rport;
+	if (defer) {
+		spin_lock_irqsave(&fcport->rport_lock, flags);
+		fcport->drport = rport;
+		fcport->rport = NULL;
+		spin_unlock_irqrestore(&fcport->rport_lock, flags);
+		set_bit(FCPORT_UPDATE_NEEDED, &ha->dpc_flags);
+	} else {
+		spin_lock_irqsave(&fcport->rport_lock, flags);
+		fcport->rport = NULL;
+		spin_unlock_irqrestore(&fcport->rport_lock, flags);
+		fc_remote_port_delete(rport);
+	}
+}
+
 /*
  * qla2x00_mark_device_lost Updates fcport state when device goes offline.
  *
@@ -1652,10 +1677,10 @@ qla2x00_free_device(scsi_qla_host_t *ha)
  * Context:
  */
 void qla2x00_mark_device_lost(scsi_qla_host_t *ha, fc_port_t *fcport,
-    int do_login)
+    int do_login, int defer)
 {
-	if (atomic_read(&fcport->state) == FCS_ONLINE && fcport->rport)
-		schedule_work(&fcport->rport_del_work);
+	if (atomic_read(&fcport->state) == FCS_ONLINE)
+		qla2x00_schedule_rport_del(ha, fcport, defer);
 
 	/*
 	 * We may need to retry the login, so don't change the state of the
@@ -1702,7 +1727,7 @@ void qla2x00_mark_device_lost(scsi_qla_h
  * Context:
  */
 void
-qla2x00_mark_all_devices_lost(scsi_qla_host_t *ha)
+qla2x00_mark_all_devices_lost(scsi_qla_host_t *ha, int defer)
 {
 	fc_port_t *fcport;
 
@@ -1716,10 +1741,13 @@ qla2x00_mark_all_devices_lost(scsi_qla_h
 		 */
 		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD)
 			continue;
-		if (atomic_read(&fcport->state) == FCS_ONLINE && fcport->rport)
-			schedule_work(&fcport->rport_del_work);
+		if (atomic_read(&fcport->state) == FCS_ONLINE)
+			qla2x00_schedule_rport_del(ha, fcport, defer);
 		atomic_set(&fcport->state, FCS_DEVICE_LOST);
 	}
+
+	if (defer && ha->dpc_wait && !ha->dpc_active)
+		up(ha->dpc_wait);
 }
 
 /*
@@ -2161,6 +2189,9 @@ qla2x00_do_dpc(void *data)
 			    ha->host_no));
 		}
 
+		if (test_and_clear_bit(FCPORT_UPDATE_NEEDED, &ha->dpc_flags))
+			qla2x00_update_fcports(ha);
+
 		if (test_and_clear_bit(LOOP_RESET_NEEDED, &ha->dpc_flags)) {
 			DEBUG(printk("scsi(%ld): dpc: sched loop_reset()\n",
 			    ha->host_no));
@@ -2469,6 +2500,7 @@ qla2x00_timer(scsi_qla_host_t *ha)
 	if ((test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags) ||
 	    test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags) ||
 	    test_bit(LOOP_RESET_NEEDED, &ha->dpc_flags) ||
+	    test_bit(FCPORT_UPDATE_NEEDED, &ha->dpc_flags) ||
 	    start_dpc ||
 	    test_bit(LOGIN_RETRY_NEEDED, &ha->dpc_flags) ||
 	    test_bit(RESET_MARKER_NEEDED, &ha->dpc_flags) ||
-- 
1.1.4.ge755


