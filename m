From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 21/22] qla2xxx: Improve submission of non critical MB interface.
Date: Tue, 6 Dec 2016 12:30:50 -0800
Message-ID: <1481056251-2310-22-git-send-email-himanshu.madhani@cavium.com>
References: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0067.outbound.protection.outlook.com ([104.47.37.67]:18976
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751254AbcLFVI0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Dec 2016 16:08:26 -0500
In-Reply-To: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

From: Quinn Tran <quinn.tran@cavium.com>

Move Get ID list, stats and Get Port Databasae mailbox commands
out of MB interface which is serialized to IOCB interface
to reduce contention.

Current driver wait for FW to be in the ready state
before processing in coming commands. For loop mode,
certain initiator takes longer for login to complete.
While other initiators already sends commands.

Add processing of Report ID Acquision F2. For Direct
connect and target mode, Rida F2 provides the ALPA/Nport ID
of the local adapter.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h    |  34 +++-
 drivers/scsi/qla2xxx/qla_dfs.c    |  85 +++++++++-
 drivers/scsi/qla2xxx/qla_fw.h     |  18 +++
 drivers/scsi/qla2xxx/qla_gbl.h    |  12 +-
 drivers/scsi/qla2xxx/qla_init.c   | 112 ++++++--------
 drivers/scsi/qla2xxx/qla_isr.c    |  22 ++-
 drivers/scsi/qla2xxx/qla_mbx.c    | 315 +++++++++++++++++++++++++++++++++++---
 drivers/scsi/qla2xxx/qla_os.c     |  95 +++++++++---
 drivers/scsi/qla2xxx/qla_target.c |  53 ++++---
 drivers/scsi/qla2xxx/qla_target.h |   5 +
 10 files changed, 607 insertions(+), 144 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 404acee..de058a1 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -395,11 +395,15 @@ struct srb_iocb {
 			struct completion comp;
 		} abt;
 		struct ct_arg ctarg;
+#define MAX_IOCB_MB_REG 28
+#define SIZEOF_IOCB_MB_REG (MAX_IOCB_MB_REG * sizeof(uint16_t))
 		struct {
-			__le16 in_mb[28]; 	/* fr fw */
-			__le16 out_mb[28];	/* to fw */
+			__le16 in_mb[MAX_IOCB_MB_REG]; 	/* fr fw */
+			__le16 out_mb[MAX_IOCB_MB_REG];	/* to fw */
 			void *out, *in;
 			dma_addr_t out_dma, in_dma;
+			struct completion comp;
+			int rc;
 		} mbx;
 		struct {
 			struct imm_ntfy_from_isp *ntfy;
@@ -2075,7 +2079,7 @@ struct mbx_24xx_entry {
 /*
  * Fibre channel port type.
  */
- typedef enum {
+typedef enum {
 	FCT_UNKNOWN,
 	FCT_RSCN,
 	FCT_SWITCH,
@@ -3217,6 +3221,8 @@ struct qlt_hw_data {
 	uint8_t tgt_node_name[WWN_SIZE];
 
 	struct dentry *dfs_tgt_sess;
+	struct dentry *dfs_tgt_port_database;
+
 	struct list_head q_full_list;
 	uint32_t num_pend_cmds;
 	uint32_t num_qfull_cmds_alloc;
@@ -3235,6 +3241,18 @@ struct qlt_hw_data {
 
 #define LEAK_EXCHG_THRESH_HOLD_PERCENT 75	/* 75 percent */
 
+/*  */
+enum chip_state {
+	QLA_CS_ROM = 0,
+	QLA_FW_OPTIONS,
+	QLA_INIT_FW,
+	QLA_CS_FW_RDY,
+};
+
+#define QLA_EARLY_LINKUP(_ha) \
+	((_ha->flags.n2n_ae || _ha->flags.lip_ae) && \
+	 _ha->flags.fw_started && !_ha->flags.fw_init_done)
+
 /*
  * Qlogic host adapter specific data structure.
 */
@@ -3284,7 +3302,12 @@ struct qla_hw_data {
 		uint32_t	fawwpn_enabled:1;
 		uint32_t	exlogins_enabled:1;
 		uint32_t	exchoffld_enabled:1;
-		/* 35 bits */
+
+		uint32_t	lip_ae:1;
+		uint32_t	n2n_ae:1;
+		uint32_t    fw_started:1;
+		uint32_t    fw_init_done:1;
+
 	} flags;
 
 	/* This spinlock is used to protect "io transactions", you must
@@ -3866,6 +3889,7 @@ struct qla_tgt_counters {
 	struct list_head vp_fcports;	/* list of fcports */
 	struct list_head work_list;
 	spinlock_t work_lock;
+	struct work_struct iocb_work;
 
 	/* Commonly used flags and state information. */
 	struct Scsi_Host *host;
@@ -3885,6 +3909,8 @@ struct qla_tgt_counters {
 		uint32_t	fw_tgt_reported:1;
 		uint32_t	bbcr_enable:1;
 		uint32_t	qpairs_available:1;
+
+		uint32_t    iocb_work_sheduled:1;
 	} flags;
 
 	atomic_t	loop_state;
diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 18cedf7..9fad3a8 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -143,7 +143,6 @@ static ssize_t qla_dfs_irqpoll_write(struct file *file, const char __user *ubuf,
 	return single_open(file, qla2x00_dfs_tgt_sess_show, vha);
 }
 
-
 static const struct file_operations dfs_tgt_sess_ops = {
 	.open		= qla2x00_dfs_tgt_sess_open,
 	.read		= seq_read,
@@ -152,6 +151,77 @@ static ssize_t qla_dfs_irqpoll_write(struct file *file, const char __user *ubuf,
 };
 
 static int
+qla2x00_dfs_tgt_port_database_show(struct seq_file *s, void *unused)
+{
+	scsi_qla_host_t *vha = s->private;
+	struct qla_hw_data *ha = vha->hw;
+	struct gid_list_info *gid_list;
+	dma_addr_t gid_list_dma;
+	fc_port_t fc_port;
+	char *id_iter;
+	int rc, i;
+	uint16_t entries, loop_id;
+	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
+
+	seq_printf(s, "%s\n", vha->host_str);
+	if (tgt) {
+		gid_list = dma_alloc_coherent(&ha->pdev->dev,
+		    qla2x00_gid_list_size(ha),
+		    &gid_list_dma, GFP_KERNEL);
+		if (!gid_list) {
+			ql_dbg(ql_dbg_user, vha, 0x705c,
+			    "DMA allocation failed for %u\n",
+			     qla2x00_gid_list_size(ha));
+			return 0;
+		}
+
+		rc = qla24xx_gidlist_wait(vha, gid_list, gid_list_dma,
+		    &entries);
+		if (rc != QLA_SUCCESS)
+			goto out_free_id_list;
+
+		id_iter = (char *)gid_list;
+
+		seq_printf(s, "Port Name	Port ID 	Loop ID\n");
+
+		for (i = 0; i < entries; i++) {
+			struct gid_list_info *gid =
+			    (struct gid_list_info *)id_iter;
+			loop_id = le16_to_cpu(gid->loop_id);
+			memset(&fc_port, 0, sizeof(fc_port_t));
+
+			fc_port.loop_id = loop_id;
+
+			rc = qla24xx_gpdb_wait(vha, &fc_port, 0);
+			seq_printf(s, "%8phC  %02x%02x%02x  %d\n",
+				fc_port.port_name, fc_port.d_id.b.domain,
+				fc_port.d_id.b.area, fc_port.d_id.b.al_pa,
+				fc_port.loop_id);
+			id_iter += ha->gid_list_info_size;
+		}
+out_free_id_list:
+		dma_free_coherent(&ha->pdev->dev, qla2x00_gid_list_size(ha),
+		    gid_list, gid_list_dma);
+	}
+
+	return 0;
+}
+
+static int
+qla2x00_dfs_tgt_port_database_open(struct inode *inode, struct file *file)
+{
+	scsi_qla_host_t *vha = inode->i_private;
+	return single_open(file, qla2x00_dfs_tgt_port_database_show, vha);
+}
+
+static const struct file_operations dfs_tgt_port_database_ops = {
+	.open		= qla2x00_dfs_tgt_port_database_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int
 qla_dfs_fw_resource_cnt_show(struct seq_file *s, void *unused)
 {
 	struct scsi_qla_host *vha = s->private;
@@ -395,6 +465,14 @@ static ssize_t qla_dfs_irqpoll_write(struct file *file, const char __user *ubuf,
 		goto out;
 	}
 
+	ha->tgt.dfs_tgt_port_database = debugfs_create_file("tgt_port_database",
+	    S_IRUSR,  ha->dfs_dir, vha, &dfs_tgt_port_database_ops);
+	if (!ha->tgt.dfs_tgt_port_database) {
+		ql_log(ql_log_warn, vha, 0xffff,
+		    "Unable to create debugFS tgt_port_database node.\n");
+		goto out;
+	}
+
 	ha->dfs_fce = debugfs_create_file("fce", S_IRUSR, ha->dfs_dir, vha,
 	    &dfs_fce_ops);
 	if (!ha->dfs_fce) {
@@ -452,6 +530,11 @@ static ssize_t qla_dfs_irqpoll_write(struct file *file, const char __user *ubuf,
 		ha->tgt.dfs_tgt_sess = NULL;
 	}
 
+	if (ha->tgt.dfs_tgt_port_database) {
+		debugfs_remove(ha->tgt.dfs_tgt_port_database);
+		ha->tgt.dfs_tgt_port_database = NULL;
+	}
+
 	if (ha->dfs_fw_resource_cnt) {
 		debugfs_remove(ha->dfs_fw_resource_cnt);
 		ha->dfs_fw_resource_cnt = NULL;
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 6f3439c..77a4d45 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1353,6 +1353,24 @@ struct vp_rpt_id_entry_24xx {
 			uint16_t bbcr;
 			uint8_t reserved_5[6];
 		} f1;
+		struct {
+			/* format 2: N2N direct connect */
+			uint8_t vpstat1_subcode;
+			uint8_t flags;
+			uint16_t rsv6;
+			uint8_t rsv2[12];
+
+			uint8_t ls_rjt_vendor;
+			uint8_t ls_rjt_explanation;
+			uint8_t ls_rjt_reason;
+			uint8_t rsv3[5];
+
+			uint8_t port_name[8];
+			uint8_t node_name[8];
+			uint32_t remote_nport_id;
+			uint32_t reserved_5;
+		} f2;
+
 	} u;
 };
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 9489a1c..c713afb 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -107,6 +107,7 @@ int qla24xx_async_notify_ack(scsi_qla_host_t *, fc_port_t *,
 int qla24xx_post_newsess_work(struct scsi_qla_host *, port_id_t *,
     u8 *, void *);
 int qla24xx_fcport_handle_login(struct scsi_qla_host *, fc_port_t *);
+int qla24xx_async_abort_cmd(srb_t *);
 
 /*
  * Global Data in qla_os.c source file.
@@ -200,6 +201,8 @@ extern struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *,
 void qla2x00_handle_login_done_event(struct scsi_qla_host *, fc_port_t *,
 	uint16_t *);
 int qla24xx_post_gnl_work(struct scsi_qla_host *, fc_port_t *);
+void qla2x00_schedule_work(struct scsi_qla_host *);
+
 
 /*
  * Global Functions in qla_mid.c source file.
@@ -375,7 +378,7 @@ extern int qla24xx_build_scsi_crc_2_iocbs(srb_t *,
 
 extern int
 qla24xx_get_isp_stats(scsi_qla_host_t *, struct link_statistics *,
-    dma_addr_t, uint);
+    dma_addr_t, uint16_t);
 
 extern int qla24xx_abort_command(srb_t *);
 extern int qla24xx_async_abort_command(srb_t *);
@@ -479,6 +482,13 @@ extern int qla24xx_set_fcp_prio(scsi_qla_host_t *, uint16_t, uint16_t,
 extern int
 qla26xx_dport_diagnostics(scsi_qla_host_t *, void *, uint, uint);
 
+int qla24xx_send_mb_cmd(struct scsi_qla_host *, mbx_cmd_t *);
+int qla24xx_gpdb_wait(struct scsi_qla_host *, fc_port_t *, u8);
+int qla24xx_gidlist_wait(struct scsi_qla_host *, void *, dma_addr_t,
+    uint16_t *);
+int _qla24xx_parse_gpdb(struct scsi_qla_host *, fc_port_t *,
+	struct port_database_24xx *);
+
 /*
  * Global Function Prototypes in qla_isr.c source file.
  */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 549a7c6..4934ee0 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -100,13 +100,18 @@ static void qla24xx_handle_plogi_done_event(struct scsi_qla_host *,
 	struct srb_iocb *lio = &sp->u.iocb_cmd;
 	struct event_arg ea;
 
-	ql_dbg(ql_dbg_disc, fcport->vha, 0x2071,
-	    "Async-%s timeout - hdl=%x portid=%02x%02x%02x %8phC.\n",
-	    sp->name, sp->handle, fcport->d_id.b.domain, fcport->d_id.b.area,
-		fcport->d_id.b.al_pa, fcport->port_name);
 
-	if (fcport)
+	if (fcport) {
 		fcport->flags &= ~FCF_ASYNC_SENT;
+		ql_dbg(ql_dbg_disc, sp->vha, 0x2071,
+			   "Async-%s timeout - hdl=%x portid=%02x%02x%02x %8phC.\n",
+			   sp->name, sp->handle, fcport->d_id.b.domain, fcport->d_id.b.area,
+			   fcport->d_id.b.al_pa, fcport->port_name);
+	} else {
+		ql_dbg(ql_dbg_disc, sp->vha, 0x2071,
+			   "Async-%s timeout - hdl=%x .\n",
+			   sp->name, sp->handle);
+	}
 
 	switch (sp->type) {
 	case SRB_LOGIN_CMD:
@@ -638,7 +643,6 @@ void qla24xx_async_gpdb_sp_done(void *v, void *s, int res)
 	struct scsi_qla_host *vha = (struct scsi_qla_host *)v;
 	struct srb *sp = (struct srb *)s;
 	struct qla_hw_data *ha = vha->hw;
-	uint64_t zero = 0;
 	struct port_database_24xx *pd;
 	fc_port_t *fcport = sp->fcport;
 	u16 *mb = sp->u.iocb_cmd.u.mbx.in_mb;
@@ -658,49 +662,7 @@ void qla24xx_async_gpdb_sp_done(void *v, void *s, int res)
 
 	pd = (struct port_database_24xx *)sp->u.iocb_cmd.u.mbx.in;
 
-	/* Check for logged in state. */
-	if (pd->current_login_state != PDS_PRLI_COMPLETE &&
-	    pd->last_login_state != PDS_PRLI_COMPLETE) {
-		ql_dbg(ql_dbg_mbx, vha, 0xffff,
-		    "Unable to verify login-state (%x/%x) for "
-		    "loop_id %x.\n", pd->current_login_state,
-		    pd->last_login_state, fcport->loop_id);
-		rval = QLA_FUNCTION_FAILED;
-		goto gpd_error_out;
-	}
-
-	if (fcport->loop_id == FC_NO_LOOP_ID ||
-		(memcmp(fcport->port_name, (uint8_t *)&zero, 8) &&
-		 memcmp(fcport->port_name, pd->port_name, 8))) {
-
-		/* We lost the device mid way. */
-		rval = QLA_NOT_LOGGED_IN;
-		goto gpd_error_out;
-	}
-
-	/* Names are little-endian. */
-	memcpy(fcport->node_name, pd->node_name, WWN_SIZE);
-
-	/* Get port_id of device. */
-	fcport->d_id.b.domain = pd->port_id[0];
-	fcport->d_id.b.area = pd->port_id[1];
-	fcport->d_id.b.al_pa = pd->port_id[2];
-	fcport->d_id.b.rsvd_1 = 0;
-
-	/* If not target must be initiator or unknown type. */
-	if ((pd->prli_svc_param_word_3[0] & BIT_4) == 0)
-		fcport->port_type = FCT_INITIATOR;
-	else
-		fcport->port_type = FCT_TARGET;
-
-	/* Passback COS information. */
-	fcport->supported_classes = (pd->flags & PDF_CLASS_2) ?
-		FC_COS_CLASS2 : FC_COS_CLASS3;
-
-	if (pd->prli_svc_param_word_3[0] & BIT_7) {
-		fcport->flags |= FCF_CONF_COMP_SUPPORTED;
-		fcport->conf_compl_supported = 1;
-	}
+	rval = _qla24xx_parse_gpdb(vha, fcport, pd);
 
 gpd_error_out:
 	memset(&ea, 0, sizeof(ea));
@@ -880,7 +842,6 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 	if (fcport->scan_state != QLA_FCPORT_FOUND)
 		return 0;
 
-
 	ql_dbg(ql_dbg_disc, vha, 0xffff,
 		"%s %8phC DS %d LS %d P %d fl %x confl %p "
 		"rscn %d|%d login %d|%d retry %d lid %d\n",
@@ -973,6 +934,7 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 		qla24xx_post_gpdb_work(vha, fcport, PDO_FORCE_ADISC);
 		break;
 
+	case DSC_LOGIN_PEND:
 	default:
 		break;
 	}
@@ -1093,7 +1055,10 @@ void qla24xx_handle_relogin_event(scsi_qla_host_t *vha,
 		return;
 	}
 
-	qla24xx_fcport_handle_login(vha, fcport);
+	if (fcport->deleted)
+		qla24xx_fcport_handle_login(vha, fcport);
+	else
+		qlt_schedule_sess_for_deletion(fcport, 1);
 }
 
 void qla2x00_fcport_event_handler (scsi_qla_host_t *vha,
@@ -1123,9 +1088,8 @@ void qla2x00_fcport_event_handler (scsi_qla_host_t *vha,
 				rc = qla24xx_post_gpnid_work(vha, &ea->id);
 				if (rc) {
 					ql_log(ql_log_warn, vha, 0xffff,
-						"RSCN GPNID work failed %02x%02x%02x\n",
-						ea->id.b.domain, ea->id.b.area,
-						ea->id.b.al_pa);
+						"RSCN GPNID work failed %#06x\n",
+						ea->id.b24);
 				}
 			} else {
 				ea->fcport = fcport;
@@ -1138,13 +1102,13 @@ void qla2x00_fcport_event_handler (scsi_qla_host_t *vha,
 			if (ea->id.b.rsvd_1 == RSCN_AREA_ADDR) {
 				mask = 0xffff00;
 				ql_log(ql_dbg_async, vha, 0xffff,
-					   "RSCN: Area 0x%06x was affected\n",
-					   ea->id.b24);
+					"RSCN: Area %#06x was affected\n",
+					ea->id.b24);
 			} else {
 				mask = 0xff0000;
 				ql_log(ql_dbg_async, vha, 0xffff,
-					   "RSCN: Domain 0x%06x was affected\n",
-					   ea->id.b24);
+					"RSCN: Domain %#06x was affected\n",
+					ea->id.b24);
 			}
 
 			rid = ea->id.b24 & mask;
@@ -1293,7 +1257,7 @@ void qla2x00_fcport_event_handler (scsi_qla_host_t *vha,
 	complete(&abt->u.abt.comp);
 }
 
-static int
+int
 qla24xx_async_abort_cmd(srb_t *cmd_sp)
 {
 	scsi_qla_host_t *vha = cmd_sp->vha;
@@ -1446,7 +1410,6 @@ void qla2x00_fcport_event_handler (scsi_qla_host_t *vha,
 {
 	if (data[0] == MBS_COMMAND_COMPLETE) {
 		qla2x00_update_fcport(vha, fcport);
-
 		return;
 	}
 
@@ -3255,6 +3218,7 @@ void qla2x00_fcport_event_handler (scsi_qla_host_t *vha,
 	} else {
 		ql_dbg(ql_dbg_init, vha, 0x00d3,
 		    "Init Firmware -- success.\n");
+		ha->flags.fw_started = 1;
 	}
 
 	return (rval);
@@ -4079,6 +4043,7 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 			atomic_set(&vha->loop_state, LOOP_READY);
 			ql_dbg(ql_dbg_disc, vha, 0x2069,
 			    "LOOP READY.\n");
+			ha->flags.fw_init_done = 1;
 
 			/*
 			 * Process any ATIO queue entries that came in
@@ -4881,12 +4846,9 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 {
 	int	rval;
 	struct qla_hw_data *ha = vha->hw;
-	unsigned long flags = 0;
 
 	rval = QLA_SUCCESS;
 
-	spin_lock_irqsave(&ha->vport_slock, flags);
-
 	dev->loop_id = find_first_zero_bit(ha->loop_id_map,
 	    LOOPID_MAP_SIZE);
 	if (dev->loop_id >= LOOPID_MAP_SIZE ||
@@ -4896,8 +4858,6 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 	} else
 		set_bit(dev->loop_id, ha->loop_id_map);
 
-	spin_unlock_irqrestore(&ha->vport_slock, flags);
-
 	if (rval == QLA_SUCCESS)
 		ql_dbg(ql_dbg_disc, dev->vha, 0x2086,
 		    "Assigning new loopid=%x, portid=%x.\n",
@@ -4934,6 +4894,7 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 	uint16_t tmp_loopid;
 	uint16_t mb[MAILBOX_REGISTER_COUNT];
 	struct qla_hw_data *ha = vha->hw;
+	unsigned long flags = 0;
 
 	retry = 0;
 	tmp_loopid = 0;
@@ -5012,7 +4973,9 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 			 * Loop ID already used, try next loop ID.
 			 */
 			fcport->loop_id++;
+			spin_lock_irqsave(&ha->vport_slock, flags);
 			rval = qla2x00_find_new_loop_id(vha, fcport);
+			spin_unlock_irqrestore(&ha->vport_slock, flags);
 			if (rval != QLA_SUCCESS) {
 				/* Ran out of loop IDs to use */
 				break;
@@ -5583,6 +5546,12 @@ int qla2x00_perform_loop_resync(scsi_qla_host_t *ha)
 	if (!(IS_P3P_TYPE(ha)))
 		ha->isp_ops->reset_chip(vha);
 
+	ha->flags.n2n_ae = 0;
+	ha->flags.lip_ae = 0;
+	ha->current_topology = 0;
+	ha->flags.fw_started = 0;
+	ha->flags.fw_init_done = 0;
+
 	ha->chip_reset++;
 
 	atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
@@ -6214,6 +6183,10 @@ static void qla24xx_nvram_wwn_from_ofw(scsi_qla_host_t *vha,
 		vha->flags.process_response_queue = 1;
 	}
 
+	/* enable RIDA Format2 */
+	if (qla_tgt_mode_enabled(vha) || qla_dual_mode_enabled(vha))
+		icb->firmware_options_3 |= BIT_0;
+
 	if (rval) {
 		ql_log(ql_log_warn, vha, 0x0070,
 		    "NVRAM configuration failed.\n");
@@ -6860,6 +6833,8 @@ uint8_t qla27xx_find_valid_image(struct scsi_qla_host *vha)
 		return;
 	if (!ha->fw_major_version)
 		return;
+	if (!ha->flags.fw_started)
+		return;
 
 	ret = qla2x00_stop_firmware(vha);
 	for (retries = 5; ret != QLA_SUCCESS && ret != QLA_FUNCTION_TIMEOUT &&
@@ -6873,6 +6848,9 @@ uint8_t qla27xx_find_valid_image(struct scsi_qla_host *vha)
 		    "Attempting retry of stop-firmware command.\n");
 		ret = qla2x00_stop_firmware(vha);
 	}
+
+	ha->flags.fw_started = 0;
+	ha->flags.fw_init_done = 0;
 }
 
 int
@@ -7266,6 +7244,10 @@ uint8_t qla27xx_find_valid_image(struct scsi_qla_host *vha)
 		vha->flags.process_response_queue = 1;
 	}
 
+	/* enable RIDA Format2 */
+	if (qla_tgt_mode_enabled(vha) || qla_dual_mode_enabled(vha))
+		icb->firmware_options_3 |= BIT_0;
+
 	if (rval) {
 		ql_log(ql_log_warn, vha, 0x0076,
 		    "NVRAM configuration failed.\n");
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index c02033b..d854173 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -132,8 +132,9 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 			schedule_work(&vha->hw->board_disable);
 		}
 		return true;
-	} else
-		return false;
+	}
+
+	return false;
 }
 
 bool
@@ -712,6 +713,8 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 		    "mbx7=%xh.\n", mb[1], mb[2], mb[3], mbx);
 
 		ha->isp_ops->fw_dump(vha, 1);
+		ha->flags.fw_init_done = 0;
+		ha->flags.fw_started = 0;
 
 		if (IS_FWI2_CAPABLE(ha)) {
 			if (mb[1] == 0 && mb[2] == 0) {
@@ -765,6 +768,9 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 		break;
 
 	case MBA_LIP_OCCURRED:		/* Loop Initialization Procedure */
+		ha->flags.lip_ae = 1;
+		ha->flags.n2n_ae = 0;
+
 		ql_dbg(ql_dbg_async, vha, 0x5009,
 		    "LIP occurred (%x).\n", mb[1]);
 
@@ -796,11 +802,16 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 		    "LOOP UP detected (%s Gbps).\n",
 		    qla2x00_get_link_speed_str(ha, ha->link_data_rate));
 
+
 		vha->flags.management_server_logged_in = 0;
 		qla2x00_post_aen_work(vha, FCH_EVT_LINKUP, ha->link_data_rate);
 		break;
 
 	case MBA_LOOP_DOWN:		/* Loop Down Event */
+		ha->flags.n2n_ae=0;
+		ha->flags.lip_ae=0;
+		ha->current_topology = 0;
+
 		mbx = (IS_QLA81XX(ha) || IS_QLA8031(ha))
 			? RD_REG_WORD(&reg24->mailbox4) : 0;
 		mbx = (IS_P3P_TYPE(ha)) ? RD_REG_WORD(&reg82->mailbox_out[4])
@@ -870,6 +881,9 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 
 	/* case MBA_DCBX_COMPLETE: */
 	case MBA_POINT_TO_POINT:	/* Point-to-Point */
+		ha->flags.lip_ae = 0;
+		ha->flags.n2n_ae = 1;
+
 		if (IS_QLA2100(ha))
 			break;
 
@@ -1790,7 +1804,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 
 	vha = pci_get_drvdata(ha->pdev);
 
-	if (!vha->flags.online)
+	if (!ha->flags.fw_started)
 		return;
 
 	while (rsp->ring_ptr->signature != RESPONSE_PROCESSED) {
@@ -2705,7 +2719,7 @@ struct scsi_dif_tuple {
 		return;
 
 	abt = &sp->u.iocb_cmd;
-	abt->u.abt.comp_status = le32_to_cpu(pkt->nport_handle);
+	abt->u.abt.comp_status = le16_to_cpu(pkt->nport_handle);
 	sp->done(sp->vha, sp, 0);
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 3caaf06..b78bc95 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -18,6 +18,30 @@ struct mbx_cmd_info_t {
 	int			status;
 };
 
+struct mb_cmd_name {
+	uint16_t cmd;
+	char *str;
+} mb_str[] = {
+	{0xffff, "unknown"},
+	{MBC_GET_PORT_DATABASE, "GPDB"},
+	{MBC_GET_ID_LIST, "GIDList"},
+	{MBC_GET_LINK_PRIV_STATS, "Stats"},
+};
+
+static
+char  *mb_to_str(uint16_t cmd)
+{
+	int i;
+	struct mb_cmd_name *e;
+
+	for (i = 0; i < ARRAY_SIZE(mb_str); i++) {
+		e = mb_str + i;
+		if (cmd == e->cmd)
+			return e->str;
+	}
+	return mb_str[0].str; /* unknown */
+}
+
 struct rom_cmd {
 	uint16_t cmd;
 } rom_cmds[] = {
@@ -2863,7 +2887,7 @@ static int is_rom_cmd(uint16_t cmd)
 
 int
 qla24xx_get_isp_stats(scsi_qla_host_t *vha, struct link_statistics *stats,
-    dma_addr_t stats_dma, uint options)
+    dma_addr_t stats_dma, uint16_t options)
 {
 	int rval;
 	mbx_cmd_t mc;
@@ -2873,19 +2897,17 @@ static int is_rom_cmd(uint16_t cmd)
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1088,
 	    "Entered %s.\n", __func__);
 
-	mcp->mb[0] = MBC_GET_LINK_PRIV_STATS;
-	mcp->mb[2] = MSW(stats_dma);
-	mcp->mb[3] = LSW(stats_dma);
-	mcp->mb[6] = MSW(MSD(stats_dma));
-	mcp->mb[7] = LSW(MSD(stats_dma));
-	mcp->mb[8] = sizeof(struct link_statistics) / 4;
-	mcp->mb[9] = vha->vp_idx;
-	mcp->mb[10] = options;
-	mcp->out_mb = MBX_10|MBX_9|MBX_8|MBX_7|MBX_6|MBX_3|MBX_2|MBX_0;
-	mcp->in_mb = MBX_2|MBX_1|MBX_0;
-	mcp->tov = MBX_TOV_SECONDS;
-	mcp->flags = IOCTL_CMD;
-	rval = qla2x00_mailbox_command(vha, mcp);
+	memset(&mc, 0, sizeof(mc));
+	mc.mb[0] = MBC_GET_LINK_PRIV_STATS;
+	mc.mb[2] = MSW(stats_dma);
+	mc.mb[3] = LSW(stats_dma);
+	mc.mb[6] = MSW(MSD(stats_dma));
+	mc.mb[7] = LSW(MSD(stats_dma));
+	mc.mb[8] = sizeof(struct link_statistics) / 4;
+	mc.mb[9] = cpu_to_le16(vha->vp_idx);
+	mc.mb[10] = cpu_to_le16(options);
+
+	rval = qla24xx_send_mb_cmd(vha, &mc);
 
 	if (rval == QLA_SUCCESS) {
 		if (mcp->mb[0] != MBS_COMMAND_COMPLETE) {
@@ -3657,11 +3679,11 @@ struct tsk_mgmt_cmd {
 
 	if (rptid_entry->format == 0) {
 		/* loop */
-		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x10b7,
-		    "Format 0 : Number of VPs setup %d, number of "
+		ql_dbg(ql_dbg_async, vha, 0x10b7,
+		    "RIDA Format 0 : Number of VPs setup %d, number of "
 		    "VPs acquired %d.\n",
 			rptid_entry->vp_setup,rptid_entry->vp_acquired);
-		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x10b8,
+		ql_dbg(ql_dbg_async, vha, 0x10b8,
 		    "Primary port id %02x%02x%02x.\n",
 		    rptid_entry->port_id[2], rptid_entry->port_id[1],
 		    rptid_entry->port_id[0]);
@@ -3676,8 +3698,8 @@ struct tsk_mgmt_cmd {
 
 	} else if (rptid_entry->format == 1) {
 		/* fabric */
-		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x10b9,
-		    "Format 1: VP[%d] enabled - status %d - with "
+		ql_dbg(ql_dbg_async, vha, 0x10b9,
+		    "RIDA Format 1: VP[%d] enabled - status %d - with "
 		    "port id %02x%02x%02x.\n", rptid_entry->vp_idx,
 			rptid_entry->vp_status,
 		    rptid_entry->port_id[2], rptid_entry->port_id[1],
@@ -3713,7 +3735,7 @@ struct tsk_mgmt_cmd {
 
 			fc_host_port_name(vha->host) =
 			    wwn_to_u64(vha->port_name);
-			ql_dbg(ql_dbg_mbx, vha, 0x1018,
+			ql_dbg(ql_dbg_async, vha, 0x1018,
 			    "FA-WWN portname %016llx (%x)\n",
 				fc_host_port_name(vha->host), rptid_entry->vp_status);
 			set_bit(REGISTER_FC4_NEEDED, &vha->dpc_flags);
@@ -3758,6 +3780,24 @@ struct tsk_mgmt_cmd {
 
 		set_bit(VP_DPC_NEEDED, &vha->dpc_flags);
 		qla2xxx_wake_dpc(vha);
+	} else if (rptid_entry->format == 2) {
+		ql_dbg(ql_dbg_async, vha, 0xffff,
+		    "RIDA: format 2/N2N Primary port id %02x%02x%02x.\n",
+		    rptid_entry->port_id[2], rptid_entry->port_id[1],
+			rptid_entry->port_id[0]);
+
+		ql_dbg(ql_dbg_async, vha, 0xffff,
+		    "N2N: Remote WWPN %8phC.\n",
+			rptid_entry->u.f2.port_name);
+
+		/* N2N.  direct connect */
+		vha->d_id.b.domain = rptid_entry->port_id[2];
+		vha->d_id.b.area = rptid_entry->port_id[1];
+		vha->d_id.b.al_pa = rptid_entry->port_id[0];
+
+		spin_lock_irqsave(&ha->vport_slock, flags);
+		qlt_update_vp_map(vha, SET_AL_PA);
+		spin_unlock_irqrestore(&ha->vport_slock, flags);
 	}
 }
 
@@ -5856,3 +5896,238 @@ struct cs84xx_mgmt_cmd {
 
 	return rval;
 }
+
+void qla2x00_async_mb_sp_done(void *v, void *s, int res)
+{
+	struct srb *sp = s;
+	sp->u.iocb_cmd.u.mbx.rc = res;
+	complete(&sp->u.iocb_cmd.u.mbx.comp);
+	/* don't free sp here. Let the caller do the free */
+}
+
+/* This mailbox uses the iocb interface to send MB command.
+ * This allows non-critial (non chip setup) command to go out in parrallel.
+ */
+int qla24xx_send_mb_cmd(struct scsi_qla_host *vha, mbx_cmd_t *mcp)
+{
+	int rval = QLA_FUNCTION_FAILED;
+	srb_t *sp;
+	struct srb_iocb *c;
+	char *name;
+
+	if (!vha->hw->flags.fw_started)
+		goto done;
+
+	sp = qla2x00_get_sp(vha, NULL, GFP_KERNEL);
+	if (!sp)
+		goto done;
+
+
+	sp->type = SRB_MB_IOCB;
+	sp->name = mb_to_str(mcp->mb[0]);
+	name = sp->name;
+
+	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha)+2);
+
+	memcpy(sp->u.iocb_cmd.u.mbx.out_mb,
+		   mcp->mb, SIZEOF_IOCB_MB_REG);
+
+	c = &sp->u.iocb_cmd;
+	c->timeout = qla2x00_async_iocb_timeout;
+	init_completion(&c->u.mbx.comp);
+
+	sp->done = qla2x00_async_mb_sp_done;
+
+	rval = qla2x00_start_sp(sp);
+	if (rval != QLA_SUCCESS) {
+		ql_dbg(ql_dbg_mbx, vha, 0xffff,
+			   "%s: %s Failed submission. %x.\n",
+			   __func__, sp->name, rval);
+		goto done_free_sp;
+	}
+
+	ql_dbg(ql_dbg_mbx, vha, 0xffff,
+		"MB:%s hndl %x submitted\n",
+		sp->name, sp->handle);
+
+	wait_for_completion(&c->u.mbx.comp);
+
+	memcpy(mcp->mb, sp->u.iocb_cmd.u.mbx.in_mb,
+		   SIZEOF_IOCB_MB_REG);
+	rval = c->u.mbx.rc;
+	switch (rval) {
+	case QLA_FUNCTION_TIMEOUT:
+		ql_dbg(ql_dbg_mbx, vha, 0xffff,
+			"%s: %s Timeout. %x.\n",
+			__func__, name, rval);
+		break;
+	case  QLA_SUCCESS:
+		ql_dbg(ql_dbg_mbx, vha, 0xffff,
+			"%s: %s done.\n",
+			__func__, sp->name);
+		sp->free(sp->vha, sp);
+		break;
+
+	default:
+		ql_dbg(ql_dbg_mbx, vha, 0xffff,
+			"%s: %s Failed. %x.\n",
+			__func__,sp->name, rval);
+		sp->free(sp->vha, sp);
+		break;
+	}
+
+	return rval;
+
+done_free_sp:
+	sp->free(sp->vha, sp);
+done:
+	return rval;
+
+}
+
+
+/* qla24xx_gpdb_wait
+ * NOTE:don't call this routine from DPC thread
+ */
+int qla24xx_gpdb_wait(struct scsi_qla_host *vha, fc_port_t *fcport, u8 opt)
+{
+	int rval = QLA_FUNCTION_FAILED;
+	dma_addr_t pd_dma;
+	struct port_database_24xx *pd;
+	struct qla_hw_data *ha = vha->hw;
+	mbx_cmd_t mc;
+
+	if (!vha->hw->flags.fw_started)
+		goto done;
+
+	pd = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &pd_dma);
+	if (pd  == NULL) {
+		ql_log(ql_log_warn, vha, 0xffff,
+			"Failed to allocate port database structure.\n");
+		goto done_free_sp;
+	}
+	memset(pd, 0, max(PORT_DATABASE_SIZE, PORT_DATABASE_24XX_SIZE));
+
+	memset(&mc, 0, sizeof(mc));
+	mc.mb[0] = MBC_GET_PORT_DATABASE;
+	mc.mb[1] = cpu_to_le16(fcport->loop_id);
+	mc.mb[2] = MSW(pd_dma);
+	mc.mb[3] = LSW(pd_dma);
+	mc.mb[6] = MSW(MSD(pd_dma));
+	mc.mb[7] = LSW(MSD(pd_dma));
+	mc.mb[9] = cpu_to_le16(vha->vp_idx);
+	mc.mb[10] = cpu_to_le16((uint16_t)opt);
+
+
+	rval = qla24xx_send_mb_cmd(vha, &mc);
+	if (rval != QLA_SUCCESS) {
+		ql_dbg(ql_dbg_mbx, vha, 0xffff,
+		    "%s: %8phC fail\n",
+		    __func__, fcport->port_name);
+		goto done_free_sp;
+	}
+
+	rval = _qla24xx_parse_gpdb(vha,fcport, pd);
+
+	ql_dbg(ql_dbg_mbx, vha, 0xffff,
+		"%s: %8phC done\n",
+		   __func__, fcport->port_name);
+
+done_free_sp:
+	if (pd)
+		dma_pool_free(ha->s_dma_pool, pd, pd_dma);
+
+done:
+	return rval;
+}
+
+
+int
+_qla24xx_parse_gpdb(struct scsi_qla_host *vha, fc_port_t *fcport,
+	struct port_database_24xx *pd)
+{
+	int rval = QLA_SUCCESS;
+	uint64_t zero = 0;
+
+	/* Check for logged in state. */
+	if (pd->current_login_state != PDS_PRLI_COMPLETE &&
+		pd->last_login_state != PDS_PRLI_COMPLETE) {
+		ql_dbg(ql_dbg_mbx, vha, 0xffff,
+			   "Unable to verify login-state (%x/%x) for "
+			   "loop_id %x.\n", pd->current_login_state,
+			   pd->last_login_state, fcport->loop_id);
+		rval = QLA_FUNCTION_FAILED;
+		goto gpd_error_out;
+	}
+
+	if (fcport->loop_id == FC_NO_LOOP_ID ||
+		(memcmp(fcport->port_name, (uint8_t *)&zero, 8) &&
+		 memcmp(fcport->port_name, pd->port_name, 8))) {
+
+		/* We lost the device mid way. */
+		rval = QLA_NOT_LOGGED_IN;
+		goto gpd_error_out;
+	}
+
+	/* Names are little-endian. */
+	memcpy(fcport->node_name, pd->node_name, WWN_SIZE);
+	memcpy(fcport->port_name, pd->port_name, WWN_SIZE);
+
+	/* Get port_id of device. */
+	fcport->d_id.b.domain = pd->port_id[0];
+	fcport->d_id.b.area = pd->port_id[1];
+	fcport->d_id.b.al_pa = pd->port_id[2];
+	fcport->d_id.b.rsvd_1 = 0;
+
+	/* If not target must be initiator or unknown type. */
+	if ((pd->prli_svc_param_word_3[0] & BIT_4) == 0)
+		fcport->port_type = FCT_INITIATOR;
+	else
+		fcport->port_type = FCT_TARGET;
+
+	/* Passback COS information. */
+	fcport->supported_classes = (pd->flags & PDF_CLASS_2) ?
+		FC_COS_CLASS2 : FC_COS_CLASS3;
+
+	if (pd->prli_svc_param_word_3[0] & BIT_7) {
+		fcport->flags |= FCF_CONF_COMP_SUPPORTED;
+		fcport->conf_compl_supported = 1;
+	}
+
+gpd_error_out:
+	return rval;
+}
+
+/* qla24xx_gidlist__wait
+ * NOTE: don't call this routine from DPC thread.
+ */
+int qla24xx_gidlist_wait(struct scsi_qla_host *vha,
+	void *id_list, dma_addr_t id_list_dma, uint16_t *entries)
+{
+	int rval = QLA_FUNCTION_FAILED;
+	mbx_cmd_t mc;
+
+	if (!vha->hw->flags.fw_started)
+		goto done;
+
+	memset(&mc, 0, sizeof(mc));
+	mc.mb[0] = MBC_GET_ID_LIST;
+	mc.mb[2] = MSW(id_list_dma);
+	mc.mb[3] = LSW(id_list_dma);
+	mc.mb[6] = MSW(MSD(id_list_dma));
+	mc.mb[7] = LSW(MSD(id_list_dma));
+	mc.mb[8] = 0;
+	mc.mb[9] = cpu_to_le16(vha->vp_idx);
+
+	rval = qla24xx_send_mb_cmd(vha, &mc);
+	if (rval != QLA_SUCCESS) {
+		ql_dbg(ql_dbg_mbx, vha, 0xffff,
+			"%s:  fail\n", __func__);
+	} else {
+		*entries = mc.mb[1];
+		ql_dbg(ql_dbg_mbx, vha, 0xffff,
+			"%s:  done\n", __func__);
+	}
+done:
+	return rval;
+}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3e089c3..06a3b86 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4365,7 +4365,11 @@ struct qla_work_evt *
 	spin_lock_irqsave(&vha->work_lock, flags);
 	list_add_tail(&e->list, &vha->work_list);
 	spin_unlock_irqrestore(&vha->work_lock, flags);
-	qla2xxx_wake_dpc(vha);
+
+	if (QLA_EARLY_LINKUP(vha->hw))
+		qla2x00_schedule_work(vha);
+	else
+		qla2xxx_wake_dpc(vha);
 
 	return QLA_SUCCESS;
 }
@@ -4645,6 +4649,49 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
 	}
 }
 
+
+static void qla2x00_iocb_work_fn(struct work_struct *work)
+{
+	struct scsi_qla_host *vha = container_of(work,
+		struct scsi_qla_host, iocb_work);
+	unsigned long flags;
+	int cnt = 0;
+
+	while (!list_empty(&vha->work_list)) {
+		qla2x00_do_work(vha);
+		cnt++;
+		if (cnt > 10)
+			break;
+	}
+
+	spin_lock_irqsave(&vha->work_lock, flags);
+	vha->flags.iocb_work_sheduled = 0;
+	spin_unlock_irqrestore(&vha->work_lock, flags);
+}
+
+void qla2x00_schedule_work(struct scsi_qla_host *vha)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&vha->work_lock, flags);
+	if (vha->flags.iocb_work_sheduled) {
+		spin_unlock_irqrestore(&vha->work_lock, flags);
+		return;
+	} else {
+		vha->flags.iocb_work_sheduled = 1;
+	}
+	spin_unlock_irqrestore(&vha->work_lock, flags);
+
+
+	/* we're in the middle of bringing up the adapter.
+	 * the scheduled work need to go out now.
+	 */
+	INIT_WORK(&vha->iocb_work,
+		(void (*)(struct work_struct *))qla2x00_iocb_work_fn);
+
+	schedule_work(&vha->iocb_work);
+}
+
 /* Relogins all the fcports of a vport
  * Context: dpc thread
  */
@@ -4655,10 +4702,10 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
 	struct event_arg ea;
 
 	list_for_each_entry(fcport, &vha->vp_fcports, list) {
-	/*
-	 * If the port is not ONLINE then try to login
-	 * to it if we haven't run out of retries.
-	 */
+		/*
+		 * If the port is not ONLINE then try to login
+		 * to it if we haven't run out of retries.
+		 */
 		if (atomic_read(&fcport->state) != FCS_ONLINE &&
 		    fcport->login_retry && !(fcport->flags & FCF_ASYNC_SENT)) {
 			fcport->login_retry--;
@@ -4673,31 +4720,29 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
 				qla2x00_fcport_event_handler(vha, &ea);
 
 			} else {
-				status = qla2x00_local_device_login(vha,
-								fcport);
+				status = qla2x00_local_device_login(vha, fcport);
 
-			if (status == QLA_SUCCESS) {
-				fcport->old_loop_id = fcport->loop_id;
+				if (status == QLA_SUCCESS) {
+					fcport->old_loop_id = fcport->loop_id;
 
-				ql_dbg(ql_dbg_disc, vha, 0x2003,
-				    "Port login OK: logged in ID 0x%x.\n",
-				    fcport->loop_id);
+					ql_dbg(ql_dbg_disc, vha, 0x2003,
+					    "Port login OK: logged in ID 0x%x.\n",
+					    fcport->loop_id);
 
-				qla2x00_update_fcport(vha, fcport);
+					qla2x00_update_fcport(vha, fcport);
 
-			} else if (status == 1) {
-				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
-				/* retry the login again */
-				ql_dbg(ql_dbg_disc, vha, 0x2007,
-				    "Retrying %d login again loop_id 0x%x.\n",
-				    fcport->login_retry, fcport->loop_id);
-			} else {
-				fcport->login_retry = 0;
-			}
-
-			if (fcport->login_retry == 0 && status != QLA_SUCCESS)
-				qla2x00_clear_loop_id(fcport);
+				} else if (status == 1) {
+					set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
+					/* retry the login again */
+					ql_dbg(ql_dbg_disc, vha, 0x2007,
+					    "Retrying %d login again loop_id 0x%x.\n",
+					    fcport->login_retry, fcport->loop_id);
+				} else {
+					fcport->login_retry = 0;
+				}
 
+				if (fcport->login_retry == 0 && status != QLA_SUCCESS)
+					qla2x00_clear_loop_id(fcport);
 			}
 		}
 		if (test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags))
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 521b114..6f01c66 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -637,6 +637,7 @@ int qla24xx_async_notify_ack(scsi_qla_host_t *vha, fc_port_t *fcport,
 	case SRB_NACK_PRLI:
 		fcport->fw_login_state = DSC_LS_PRLI_PEND;
 		c = "PRLI";
+		fcport->deleted = 0;
 		break;
 	case SRB_NACK_LOGO:
 		fcport->fw_login_state = DSC_LS_LOGO_PEND;
@@ -1249,7 +1250,7 @@ static int qla24xx_get_loop_id(struct scsi_qla_host *vha, const uint8_t *s_id,
 	}
 
 	/* Get list of logged in devices */
-	rc = qla2x00_get_id_list(vha, gid_list, gid_list_dma, &entries);
+	rc = qla24xx_gidlist_wait(vha, gid_list, gid_list_dma, &entries);
 	if (rc != QLA_SUCCESS) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf045,
 		    "qla_target(%d): get_id_list() failed: %x\n",
@@ -1543,7 +1544,7 @@ static void qlt_send_notify_ack(struct scsi_qla_host *vha,
 	request_t *pkt;
 	struct nack_to_isp *nack;
 
-	if (qla2x00_reset_active(vha))
+	if (!ha->flags.fw_started)
 		return;
 
 	ql_dbg(ql_dbg_tgt, vha, 0xe004, "Sending NOTIFY_ACK (ha=%p)\n", ha);
@@ -2052,8 +2053,8 @@ void qlt_send_resp_ctio(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
 	    cpu_to_le16(SS_RESPONSE_INFO_LEN_VALID | scsi_status);
 	ctio->u.status1.response_len = __constant_cpu_to_le16(18);
 
-	ctio->u.status1.residual = get_unaligned((uint32_t *)
-		&atio->u.isp24.fcp_cmnd.add_cdb[0]);
+	ctio->u.status1.residual = cpu_to_le32(GET_DL_FR_ATIO(atio));
+
 	if (ctio->u.status1.residual != 0)
 		ctio->u.status1.scsi_status |= __constant_cpu_to_le16(SS_RESIDUAL_UNDER);
 
@@ -3128,7 +3129,8 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 	else
 		vha->tgt_counters.core_qla_que_buf++;
 
-	if (!vha->flags.online || cmd->reset_count != ha->chip_reset) {
+	if (!ha->flags.fw_started ||
+		cmd->reset_count != ha->chip_reset) {
 		/*
 		 * Either the port is not online or this request was from
 		 * previous life, just abort the processing.
@@ -3273,7 +3275,8 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
-	if (!vha->flags.online || (cmd->reset_count != ha->chip_reset) ||
+	if (!ha->flags.fw_started ||
+		(cmd->reset_count != ha->chip_reset) ||
 	    (cmd->sess && cmd->sess->deleted)) {
 		/*
 		 * Either the port is not online or this request was from
@@ -3502,7 +3505,7 @@ static int __qlt_send_term_imm_notif(struct scsi_qla_host *vha,
 	ql_dbg(ql_dbg_tgt_tmr, vha, 0xe01c,
 	    "Sending TERM ELS CTIO (ha=%p)\n", ha);
 
-	pkt = (request_t *)qla2x00_alloc_iocbs_ready(vha, NULL);
+	pkt = (request_t *)qla2x00_alloc_iocbs(vha, NULL);
 	if (pkt == NULL) {
 		ql_dbg(ql_dbg_tgt, vha, 0xe080,
 		    "qla_target(%d): %s failed: unable to allocate "
@@ -3624,12 +3627,6 @@ static int __qlt_send_term_exchange(struct scsi_qla_host *vha,
 	temp = be16_to_cpu(atio->u.isp24.fcp_hdr.ox_id);
 	ctio24->u.status1.ox_id = cpu_to_le16(temp);
 
-	/* Most likely, it isn't needed */
-	ctio24->u.status1.residual = get_unaligned((uint32_t *)
-	    &atio->u.isp24.fcp_cmnd.add_cdb[0]);
-	if (ctio24->u.status1.residual != 0)
-		ctio24->u.status1.scsi_status |= SS_RESIDUAL_UNDER;
-
 	/* Memory Barrier */
 	wmb();
 	qla2x00_start_iocbs(vha, vha->req);
@@ -4210,10 +4207,7 @@ static void __qlt_do_work(struct qla_tgt_cmd *cmd)
 	else
 		data_dir = DMA_NONE;
 
-
-	data_length = be32_to_cpu(get_unaligned((uint32_t *)
-	    &atio->u.isp24.fcp_cmnd.add_cdb[
-	    atio->u.isp24.fcp_cmnd.add_cdb_len]));
+	data_length = GET_DL_FR_ATIO(atio);
 
 	ret = ha->tgt.tgt_ops->handle_cmd(vha, cmd, cdb, data_length,
 		atio->u.isp24.fcp_cmnd.task_attr, data_dir, bidi);
@@ -4864,7 +4858,8 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 		}
 
 		if (sess != NULL) {
-			if (sess->fw_login_state == DSC_LS_PLOGI_PEND) {
+			if ((sess->fw_login_state != DSC_LS_PLOGI_PEND) &&
+				(sess->fw_login_state != DSC_LS_PLOGI_COMP)) {
 				/*
 				 * Impatient initiator sent PRLI before last
 				 * PLOGI could finish. Will force him to re-try,
@@ -4903,9 +4898,19 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 
 		/* Make session global (not used in fabric mode) */
 		if (ha->current_topology != ISP_CFG_F) {
-			set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
-			set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
-			qla2xxx_wake_dpc(vha);
+			if (sess) {
+				ql_dbg(ql_dbg_disc, vha, 0xffff,
+					   "%s %d %8phC post nack\n",
+					   __func__, __LINE__, sess->port_name);
+
+				qla24xx_post_nack_work(vha, sess, iocb,
+					SRB_NACK_PRLI);
+				res = 0;
+			} else {
+				set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
+				set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
+				qla2xxx_wake_dpc(vha);
+			}
 		} else {
 			if (sess) {
 				ql_dbg(ql_dbg_disc, vha, 0xffff,
@@ -5825,7 +5830,7 @@ static void qlt_24xx_atio_pkt(struct scsi_qla_host *vha,
 	unsigned long flags;
 
 	if (unlikely(tgt == NULL)) {
-		ql_dbg(ql_dbg_io, vha, 0x3064,
+		ql_dbg(ql_dbg_tgt, vha, 0x3064,
 		    "ATIO pkt, but no tgt (ha %p)", ha);
 		return;
 	}
@@ -6257,7 +6262,7 @@ static fc_port_t *qlt_get_port_database(struct scsi_qla_host *vha,
 
 	fcport->loop_id = loop_id;
 
-	rc = qla2x00_get_port_database(vha, fcport, 0);
+	rc = qla24xx_gpdb_wait(vha, fcport, 0);
 	if (rc != QLA_SUCCESS) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf070,
 		    "qla_target(%d): Failed to retrieve fcport "
@@ -6959,7 +6964,7 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 	struct atio_from_isp *pkt;
 	int cnt, i;
 
-	if (!vha->flags.online)
+	if (!ha->flags.fw_started)
 		return;
 
 	while (ha->tgt.atio_ring_ptr->signature != ATIO_PROCESSED) {
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 507b8d9..b57067d 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -436,6 +436,11 @@ struct atio_from_isp {
 	} u;
 } __packed;
 
+
+#define GET_DL_FR_ATIO(_atio)  \
+	(be32_to_cpu(get_unaligned((uint32_t *)	\
+&_atio->u.isp24.fcp_cmnd.add_cdb[_atio->u.isp24.fcp_cmnd.add_cdb_len*4])))
+
 #define CTIO_TYPE7 0x12 /* Continue target I/O entry (for 24xx) */
 
 /*
-- 
1.8.3.1

