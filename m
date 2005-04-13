From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [3/5]  qla2xxx: remove lun discovery codes...
Date: Wed, 13 Apr 2005 12:18:42 -0700
Message-ID: <20050413191842.GL9703@plap.qlogic.org>
References: <20050413191548.GI9703@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch02.qlogic.com ([198.70.193.200]:46446 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261218AbVDMTSo
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Apr 2005 15:18:44 -0400
Content-Disposition: inline
In-Reply-To: <20050413191548.GI9703@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

  Remove internal lun discovery routines and support
  structures.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_attr.c   |   51 +-
 drivers/scsi/qla2xxx/qla_dbg.c    |    5 
 drivers/scsi/qla2xxx/qla_def.h    |  103 ----
 drivers/scsi/qla2xxx/qla_gbl.h    |   10 
 drivers/scsi/qla2xxx/qla_init.c   |  864 --------------------------------------
 drivers/scsi/qla2xxx/qla_inline.h |   17 
 drivers/scsi/qla2xxx/qla_iocb.c   |   13 
 drivers/scsi/qla2xxx/qla_isr.c    |   37 -
 drivers/scsi/qla2xxx/qla_mbx.c    |   21 
 drivers/scsi/qla2xxx/qla_os.c     |  282 +-----------
 10 files changed, 103 insertions(+), 1300 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_attr.c	2005-04-13 08:41:21.000000000 -0700
+++ b/drivers/scsi/qla2xxx/qla_attr.c	2005-04-13 08:45:53.000000000 -0700
@@ -227,12 +227,17 @@ qla2x00_get_starget_node_name(struct scs
 {
 	struct Scsi_Host *host = dev_to_shost(starget->dev.parent);
 	scsi_qla_host_t *ha = to_qla_host(host);
-        os_tgt_t *tq = (os_tgt_t *) TGT_Q(ha, starget->id);
+	fc_port_t *fcport;
 	uint64_t node_name = 0;
 
-	if (tq->fcport)
-		node_name = be64_to_cpu(*(uint64_t *)tq->fcport->node_name);
-	fc_starget_node_name(starget) = node_name;
+	list_for_each_entry(fcport, &ha->fcports, list) {
+		if (starget->id == fcport->os_target_id) {
+			node_name = *(uint64_t *)fcport->node_name;
+			break;
+		}
+	}
+
+	fc_starget_node_name(starget) = be64_to_cpu(node_name);
 }
 
 static void
@@ -240,12 +245,17 @@ qla2x00_get_starget_port_name(struct scs
 {
 	struct Scsi_Host *host = dev_to_shost(starget->dev.parent);
 	scsi_qla_host_t *ha = to_qla_host(host);
-        os_tgt_t *tq = (os_tgt_t *) TGT_Q(ha, starget->id);
+	fc_port_t *fcport;
 	uint64_t port_name = 0;
 
-	if (tq->fcport)
-		port_name = be64_to_cpu(*(uint64_t *)tq->fcport->port_name);
-	fc_starget_port_name(starget) = port_name;
+	list_for_each_entry(fcport, &ha->fcports, list) {
+		if (starget->id == fcport->os_target_id) {
+			port_name = *(uint64_t *)fcport->port_name;
+			break;
+		}
+	}
+
+	fc_starget_port_name(starget) = be64_to_cpu(port_name);
 }
 
 static void
@@ -253,20 +263,25 @@ qla2x00_get_starget_port_id(struct scsi_
 {
 	struct Scsi_Host *host = dev_to_shost(starget->dev.parent);
 	scsi_qla_host_t *ha = to_qla_host(host);
-        os_tgt_t *tq = (os_tgt_t *) TGT_Q(ha, starget->id);
-	uint32_t port_id = 0;
+	fc_port_t *fcport;
+	uint32_t port_id = ~0U;
+
+	list_for_each_entry(fcport, &ha->fcports, list) {
+		if (starget->id == fcport->os_target_id) {
+			port_id = fcport->d_id.b.domain << 16 |
+			    fcport->d_id.b.area << 8 | fcport->d_id.b.al_pa;
+			break;
+		}
+	}
 
-	if (tq->fcport)
-		port_id = tq->fcport->d_id.b.domain << 16 |
-		    tq->fcport->d_id.b.area << 8 | tq->fcport->d_id.b.al_pa;
 	fc_starget_port_id(starget) = port_id;
 }
 
 static void
 qla2x00_get_rport_loss_tmo(struct fc_rport *rport)
 {
-	os_tgt_t *tq = rport->dd_data;
-	scsi_qla_host_t *ha = tq->ha;
+	struct Scsi_Host *host = rport_to_shost(rport);
+	scsi_qla_host_t *ha = to_qla_host(host);
 
 	rport->dev_loss_tmo = ha->port_down_retry_count + 5;
 }
@@ -274,8 +289,8 @@ qla2x00_get_rport_loss_tmo(struct fc_rpo
 static void
 qla2x00_set_rport_loss_tmo(struct fc_rport *rport, uint32_t timeout)
 {
-	os_tgt_t *tq = rport->dd_data;
-	scsi_qla_host_t *ha = tq->ha;
+	struct Scsi_Host *host = rport_to_shost(rport);
+	scsi_qla_host_t *ha = to_qla_host(host);
 
 	if (timeout)
 		ha->port_down_retry_count = timeout;
@@ -292,7 +307,7 @@ static struct fc_function_template qla2x
 	.get_host_port_id = qla2x00_get_host_port_id,
 	.show_host_port_id = 1,
 
-	.dd_fcrport_size = sizeof(os_tgt_t *),
+	.dd_fcrport_size = sizeof(struct fc_port *),
 
 	.get_starget_node_name = qla2x00_get_starget_node_name,
 	.show_starget_node_name = 1,
--- a/drivers/scsi/qla2xxx/qla_dbg.c	2005-04-13 08:40:14.000000000 -0700
+++ b/drivers/scsi/qla2xxx/qla_dbg.c	2005-04-13 08:45:53.000000000 -0700
@@ -1065,11 +1065,6 @@ qla2x00_print_scsi_cmd(struct scsi_cmnd 
 	printk("  sp flags=0x%x\n", sp->flags);
 	printk("  r_start=0x%lx, u_start=0x%lx, f_start=0x%lx, state=%d\n",
 	    sp->r_start, sp->u_start, sp->f_start, sp->state);
-
-	printk(" e_start= 0x%lx, ext_history=%d, fo retry=%d, loopid=%x, "
-	    "port path=%d\n", sp->e_start, sp->ext_history, sp->fo_retry_cnt,
-	    sp->lun_queue->fclun->fcport->loop_id,
-	    sp->lun_queue->fclun->fcport->cur_path);
 }
 
 #if defined(QL_DEBUG_ROUTINES)
--- a/drivers/scsi/qla2xxx/qla_def.h	2005-04-13 08:41:21.000000000 -0700
+++ b/drivers/scsi/qla2xxx/qla_def.h	2005-04-13 08:45:53.000000000 -0700
@@ -241,6 +241,7 @@ typedef struct srb {
 	struct list_head list;
 
 	struct scsi_qla_host *ha;	/* HA the SP is queued on */
+	struct fc_port *fcport;
 
 	struct scsi_cmnd *cmd;		/* Linux SCSI command pkt */
 
@@ -251,11 +252,6 @@ typedef struct srb {
 	/* Request state */
 	uint16_t state;
 
-	/* Target/LUN queue pointers. */
-	struct os_tgt *tgt_queue;	/* ptr to visible ha's target */
-	struct os_lun *lun_queue;	/* ptr to visible ha's lun */
-	struct fc_lun *fclun;		/* FC LUN context pointer. */
-
 	/* Timing counts. */
 	unsigned long e_start;		/* Start of extend timeout */
 	unsigned long r_start;		/* Start of request */
@@ -1603,73 +1599,6 @@ typedef struct {
 } rpt_lun_cmd_rsp_t;
 
 /*
- * SCSI Target Queue structure
- */
-typedef struct os_tgt {
-	struct os_lun *olun[MAX_LUNS]; /* LUN context pointer. */
-	struct fc_port *fcport;
-	unsigned long flags;
-	uint8_t port_down_retry_count;
-    	uint32_t down_timer;
-	struct scsi_qla_host *ha;
-
-	/* Persistent binding information */
-	port_id_t d_id;
-	uint8_t node_name[WWN_SIZE];
-	uint8_t port_name[WWN_SIZE];
-} os_tgt_t;
-
-/*
- * SCSI Target Queue flags
- */
-#define TQF_ONLINE		0		/* Device online to OS. */
-#define TQF_SUSPENDED		1
-#define TQF_RETRY_CMDS		2
-
-/*
- * SCSI LUN Queue structure
- */
-typedef struct os_lun {
-	struct fc_lun *fclun;		/* FC LUN context pointer. */
-    	spinlock_t q_lock;		/* Lun Lock */
-
-	unsigned long q_flag;
-#define LUN_MPIO_RESET_CNTS	1	/* Lun */
-#define LUN_MPIO_BUSY		2	/* Lun is changing paths  */
-#define LUN_EXEC_DELAYED	7	/* Lun execution is delayed */
-
-	u_long q_timeout;		/* total command timeouts */
-	atomic_t q_timer;		/* suspend timer */
-	uint32_t q_count;		/* current count */
-	uint32_t q_max;			/* maxmum count lun can be suspended */
-	uint8_t q_state;		/* lun State */
-#define LUN_STATE_READY		1	/* lun is ready for i/o */
-#define LUN_STATE_RUN		2	/* lun has a timer running */
-#define LUN_STATE_WAIT		3	/* lun is suspended */
-#define LUN_STATE_TIMEOUT	4	/* lun has timed out */
-
-	u_long io_cnt;			/* total xfer count since boot */
-	u_long out_cnt;			/* total outstanding IO count */
-	u_long w_cnt;			/* total writes */
-	u_long r_cnt;			/* total reads */
-	u_long avg_time;		/*  */
-} os_lun_t;
-
-
-/* LUN BitMask structure definition, array of 32bit words,
- * 1 bit per lun.  When bit == 1, the lun is masked.
- * Most significant bit of mask[0] is lun 0, bit 24 is lun 7.
- */
-typedef struct lun_bit_mask {
-	/* Must allocate at least enough bits to accomodate all LUNs */
-#if ((MAX_FIBRE_LUNS & 0x7) == 0)
-	uint8_t mask[MAX_FIBRE_LUNS >> 3];
-#else
-	uint8_t mask[(MAX_FIBRE_LUNS + 8) >> 3];
-#endif
-} lun_bit_mask_t;
-
-/*
  * Fibre channel port type.
  */
  typedef enum {
@@ -1686,8 +1615,6 @@ typedef struct lun_bit_mask {
  */
 typedef struct fc_port {
 	struct list_head list;
-	struct list_head fcluns;
-
 	struct scsi_qla_host *ha;
 	struct scsi_qla_host *vis_ha;	/* only used when suspending lun */
 
@@ -1702,8 +1629,7 @@ typedef struct fc_port {
 	atomic_t state;
 	uint32_t flags;
 
-	os_tgt_t *tgt_queue;
-	uint16_t os_target_id;
+	unsigned int os_target_id;
 
 	uint16_t iodesc_idx_sent;
 
@@ -1717,7 +1643,6 @@ typedef struct fc_port {
 	uint8_t mp_byte;		/* multi-path byte (not used) */
     	uint8_t cur_path;		/* current path id */
 
-	lun_bit_mask_t lun_mask;
 	struct fc_rport *rport;
 } fc_port_t;
 
@@ -1765,25 +1690,6 @@ typedef struct fc_port {
 #define FC_NO_LOOP_ID		0x1000
 
 /*
- * Fibre channel LUN structure.
- */
-typedef struct fc_lun {
-        struct list_head list;
-
-	fc_port_t *fcport;
-	fc_port_t *o_fcport;
-	uint16_t lun;
-	atomic_t state;
-	uint8_t device_type;
-
-	uint8_t max_path_retries;
-	uint32_t flags;
-} fc_lun_t;
-
-#define	FLF_VISIBLE_LUN		BIT_0
-#define	FLF_ACTIVE_LUN		BIT_1
-
-/*
  * FC-CT interface
  *
  * NOTE: All structures are big-endian in form.
@@ -2253,9 +2159,6 @@ typedef struct scsi_qla_host {
 	struct io_descriptor	io_descriptors[MAX_IO_DESCRIPTORS];
 	uint16_t		iodesc_signature;
 
-	/* OS target queue pointers. */
-	os_tgt_t		*otgt[MAX_FIBRE_DEVICES];
-
 	/* RSCN queue. */
 	uint32_t rscn_queue[MAX_RSCN_COUNT];
 	uint8_t rscn_in_ptr;
@@ -2400,8 +2303,6 @@ typedef struct scsi_qla_host {
 #define LOOP_RDY(ha)	(!LOOP_NOT_READY(ha))
 
 #define TGT_Q(ha, t) (ha->otgt[t])
-#define LUN_Q(ha, t, l)	(TGT_Q(ha, t)->olun[l])
-#define GET_LU_Q(ha, t, l) ((TGT_Q(ha,t) != NULL)? TGT_Q(ha, t)->olun[l] : NULL)
 
 #define to_qla_host(x)		((scsi_qla_host_t *) (x)->hostdata)
 
--- a/drivers/scsi/qla2xxx/qla_gbl.h	2005-04-13 08:42:33.000000000 -0700
+++ b/drivers/scsi/qla2xxx/qla_gbl.h	2005-04-13 08:45:53.000000000 -0700
@@ -45,8 +45,6 @@ extern void qla2x00_restart_queues(scsi_
 
 extern void qla2x00_rescan_fcports(scsi_qla_host_t *);
 
-extern void qla2x00_tgt_free(scsi_qla_host_t *ha, uint16_t t);
-
 extern int qla2x00_abort_isp(scsi_qla_host_t *);
 
 extern void qla2x00_reg_remote_port(scsi_qla_host_t *, fc_port_t *);
@@ -83,12 +81,6 @@ extern char *qla2x00_get_fw_version_str(
 
 extern void qla2x00_cmd_timeout(srb_t *);
 
-extern int __qla2x00_suspend_lun(scsi_qla_host_t *, os_lun_t *, int, int, int);
-
-extern void qla2x00_done(scsi_qla_host_t *);
-extern void qla2x00_flush_failover_q(scsi_qla_host_t *, os_lun_t *);
-extern void qla2x00_reset_lun_fo_counts(scsi_qla_host_t *, os_lun_t *);
-
 extern void qla2x00_mark_device_lost(scsi_qla_host_t *, fc_port_t *, int);
 extern void qla2x00_mark_all_devices_lost(scsi_qla_host_t *);
 
@@ -149,7 +141,7 @@ qla2x00_abort_target(fc_port_t *fcport);
 #endif
 
 extern int
-qla2x00_target_reset(scsi_qla_host_t *, uint16_t, uint16_t);
+qla2x00_target_reset(scsi_qla_host_t *, struct fc_port *);
 
 extern int
 qla2x00_get_adapter_id(scsi_qla_host_t *, uint16_t *, uint8_t *, uint8_t *,
--- a/drivers/scsi/qla2xxx/qla_init.c	2005-04-13 08:43:25.000000000 -0700
+++ b/drivers/scsi/qla2xxx/qla_init.c	2005-04-13 08:51:11.000000000 -0700
@@ -45,34 +45,17 @@ static int qla2x00_init_rings(scsi_qla_h
 static int qla2x00_fw_ready(scsi_qla_host_t *);
 static int qla2x00_configure_hba(scsi_qla_host_t *);
 static int qla2x00_nvram_config(scsi_qla_host_t *);
-static void qla2x00_init_tgt_map(scsi_qla_host_t *);
 static int qla2x00_configure_loop(scsi_qla_host_t *);
 static int qla2x00_configure_local_loop(scsi_qla_host_t *);
 static void qla2x00_update_fcport(scsi_qla_host_t *, fc_port_t *);
-static void qla2x00_lun_discovery(scsi_qla_host_t *, fc_port_t *);
-static int qla2x00_rpt_lun_discovery(scsi_qla_host_t *, fc_port_t *,
-    inq_cmd_rsp_t *, dma_addr_t);
-static int qla2x00_report_lun(scsi_qla_host_t *, fc_port_t *);
-static fc_lun_t *qla2x00_cfg_lun(scsi_qla_host_t *, fc_port_t *, uint16_t,
-    inq_cmd_rsp_t *, dma_addr_t);
-static fc_lun_t * qla2x00_add_lun(fc_port_t *, uint16_t);
-static int qla2x00_inquiry(scsi_qla_host_t *, fc_port_t *, uint16_t,
-    inq_cmd_rsp_t *, dma_addr_t);
 static int qla2x00_configure_fabric(scsi_qla_host_t *);
 static int qla2x00_find_all_fabric_devs(scsi_qla_host_t *, struct list_head *);
 static int qla2x00_device_resync(scsi_qla_host_t *);
 static int qla2x00_fabric_dev_login(scsi_qla_host_t *, fc_port_t *,
     uint16_t *);
-static void qla2x00_config_os(scsi_qla_host_t *ha);
-static uint16_t qla2x00_fcport_bind(scsi_qla_host_t *ha, fc_port_t *fcport);
-static os_lun_t * qla2x00_fclun_bind(scsi_qla_host_t *, fc_port_t *,
-    fc_lun_t *);
-static void qla2x00_lun_free(scsi_qla_host_t *, uint16_t, uint16_t);
 
 static int qla2x00_restart_isp(scsi_qla_host_t *);
 static void qla2x00_reset_adapter(scsi_qla_host_t *);
-static os_tgt_t *qla2x00_tgt_alloc(scsi_qla_host_t *, uint16_t);
-static os_lun_t *qla2x00_lun_alloc(scsi_qla_host_t *, uint16_t, uint16_t);
 
 /****************************************************************************/
 /*                QLogic ISP2x00 Hardware Support Functions.                */
@@ -120,9 +103,6 @@ qla2x00_initialize_adapter(scsi_qla_host
 
 	qla2x00_reset_chip(ha);
 
-	/* Initialize target map database. */
-	qla2x00_init_tgt_map(ha);
-
 	qla_printk(KERN_INFO, ha, "Configure NVRAM parameters...\n");
 	qla2x00_nvram_config(ha);
 
@@ -1530,25 +1510,6 @@ qla2x00_nvram_config(scsi_qla_host_t *ha
 	return (rval);
 }
 
-/*
-* qla2x00_init_tgt_map
-*      Initializes target map.
-*
-* Input:
-*      ha = adapter block pointer.
-*
-* Output:
-*      TGT_Q initialized
-*/
-static void
-qla2x00_init_tgt_map(scsi_qla_host_t *ha)
-{
-	uint32_t t;
-
-	for (t = 0; t < MAX_TARGETS; t++)
-		TGT_Q(ha, t) = (os_tgt_t *)NULL;
-}
-
 /**
  * qla2x00_alloc_fcport() - Allocate a generic fcport.
  * @ha: HA context
@@ -1573,7 +1534,6 @@ qla2x00_alloc_fcport(scsi_qla_host_t *ha
 	fcport->iodesc_idx_sent = IODESC_INVALID_INDEX;
 	atomic_set(&fcport->state, FCS_UNCONFIGURED);
 	fcport->flags = FCF_RLC_SUPPORT;
-	INIT_LIST_HEAD(&fcport->fcluns);
 
 	return (fcport);
 }
@@ -1663,7 +1623,6 @@ qla2x00_configure_loop(scsi_qla_host_t *
 		    test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags)) {
 			rval = QLA_FUNCTION_FAILED;
 		} else {
-			qla2x00_config_os(ha);
 			atomic_set(&ha->loop_state, LOOP_READY);
 
 			DEBUG(printk("scsi(%ld): LOOP READY\n", ha->host_no));
@@ -1908,8 +1867,11 @@ qla2x00_update_fcport(scsi_qla_host_t *h
 	if (fcport->flags & FCF_TAPE_PRESENT) {
 		spin_lock_irqsave(&ha->hardware_lock, flags);
 		for (index = 1; index < MAX_OUTSTANDING_COMMANDS; index++) {
+			fc_port_t *sfcp;
+
 			if ((sp = ha->outstanding_cmds[index]) != 0) {
-				if (sp->fclun->fcport == fcport) {
+				sfcp = sp->fcport;
+				if (sfcp == fcport) {
 					atomic_set(&fcport->state, FCS_ONLINE);
 					spin_unlock_irqrestore(
 					    &ha->hardware_lock, flags);
@@ -1920,14 +1882,12 @@ qla2x00_update_fcport(scsi_qla_host_t *h
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	}
 
-	/* Do LUN discovery. */
 	if (fcport->port_type == FCT_INITIATOR ||
-	    fcport->port_type == FCT_BROADCAST) {
+	    fcport->port_type == FCT_BROADCAST)
 		fcport->device_type = TYPE_PROCESSOR;
-	} else {
-		qla2x00_lun_discovery(ha, fcport);
-	}
+
 	atomic_set(&fcport->state, FCS_ONLINE);
+
 	if (ha->flags.init_done)
 		qla2x00_reg_remote_port(ha, fcport);
 }
@@ -1936,6 +1896,7 @@ void
 qla2x00_reg_remote_port(scsi_qla_host_t *ha, fc_port_t *fcport)
 {
 	struct fc_rport_identifiers rport_ids;
+	struct fc_rport *rport;
 
 	if (fcport->rport) {
 		fc_remote_port_unblock(fcport->rport);
@@ -1952,418 +1913,17 @@ qla2x00_reg_remote_port(scsi_qla_host_t 
 	if (fcport->port_type == FCT_TARGET)
 		rport_ids.roles |= FC_RPORT_ROLE_FCP_TARGET;
 
-	fcport->rport = fc_remote_port_add(ha->host, 0, &rport_ids);
-	if (!fcport->rport)
+	fcport->rport = rport = fc_remote_port_add(ha->host, 0, &rport_ids);
+	if (!rport)
 		qla_printk(KERN_WARNING, ha,
 		    "Unable to allocate fc remote port!\n");
-}
-/*
- * qla2x00_lun_discovery
- *	Issue SCSI inquiry command for LUN discovery.
- *
- * Input:
- *	ha:		adapter state pointer.
- *	fcport:		FC port structure pointer.
- *
- * Context:
- *	Kernel context.
- */
-static void
-qla2x00_lun_discovery(scsi_qla_host_t *ha, fc_port_t *fcport)
-{
-	inq_cmd_rsp_t	*inq;
-	dma_addr_t	inq_dma;
-	uint16_t	lun;
-
-	inq = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &inq_dma);
-	if (inq == NULL) {
-		qla_printk(KERN_WARNING, ha,
-		    "Memory Allocation failed - INQ\n");
-		return;
-	}
-
-	/* Always add a fc_lun_t structure for lun 0 -- mid-layer requirement */
-	qla2x00_add_lun(fcport, 0);
-
-	/* If report LUN works, exit. */
-	if (qla2x00_rpt_lun_discovery(ha, fcport, inq, inq_dma) !=
-	    QLA_SUCCESS) {
-		for (lun = 0; lun < ha->max_probe_luns; lun++) {
-			/* Configure LUN. */
-			qla2x00_cfg_lun(ha, fcport, lun, inq, inq_dma);
-		}
-	}
-
-	dma_pool_free(ha->s_dma_pool, inq, inq_dma);
-}
-
-/*
- * qla2x00_rpt_lun_discovery
- *	Issue SCSI report LUN command for LUN discovery.
- *
- * Input:
- *	ha:		adapter state pointer.
- *	fcport:		FC port structure pointer.
- *
- * Returns:
- *	qla2x00 local function return status code.
- *
- * Context:
- *	Kernel context.
- */
-static int
-qla2x00_rpt_lun_discovery(scsi_qla_host_t *ha, fc_port_t *fcport,
-    inq_cmd_rsp_t *inq, dma_addr_t inq_dma)
-{
-	int			rval;
-	uint32_t		len, cnt;
-	uint16_t		lun;
-
-	/* Assume a failed status */
-	rval = QLA_FUNCTION_FAILED;
-
-	/* No point in continuing if the device doesn't support RLC */
-	if ((fcport->flags & FCF_RLC_SUPPORT) == 0)
-		return (rval);
-
-	rval = qla2x00_report_lun(ha, fcport);
-	if (rval != QLA_SUCCESS)
-		return (rval);
-
-	/* Configure LUN list. */
-	len = be32_to_cpu(ha->rlc_rsp->list.hdr.len);
-	len /= 8;
-	for (cnt = 0; cnt < len; cnt++) {
-		lun = CHAR_TO_SHORT(ha->rlc_rsp->list.lst[cnt].lsb,
-		    ha->rlc_rsp->list.lst[cnt].msb.b);
-
-		DEBUG3(printk("scsi(%ld): RLC lun = (%d)\n", ha->host_no, lun));
-
-		/* We only support 0 through MAX_LUNS-1 range */
-		if (lun < MAX_LUNS) {
-			qla2x00_cfg_lun(ha, fcport, lun, inq, inq_dma);
-		}
-	}
-	atomic_set(&fcport->state, FCS_ONLINE);
-
-	return (rval);
-}
-
-/*
- * qla2x00_report_lun
- *	Issue SCSI report LUN command.
- *
- * Input:
- *	ha:		adapter state pointer.
- *	fcport:		FC port structure pointer.
- *
- * Returns:
- *	qla2x00 local function return status code.
- *
- * Context:
- *	Kernel context.
- */
-static int
-qla2x00_report_lun(scsi_qla_host_t *ha, fc_port_t *fcport)
-{
-	int rval;
-	uint16_t retries;
-	uint16_t comp_status;
-	uint16_t scsi_status;
-	rpt_lun_cmd_rsp_t *rlc;
-	dma_addr_t rlc_dma;
-
-	rval = QLA_FUNCTION_FAILED;
-	rlc = ha->rlc_rsp;
-	rlc_dma = ha->rlc_rsp_dma;
-
-	for (retries = 3; retries; retries--) {
-		memset(rlc, 0, sizeof(rpt_lun_cmd_rsp_t));
-		rlc->p.cmd.entry_type = COMMAND_A64_TYPE;
-		rlc->p.cmd.entry_count = 1;
-		SET_TARGET_ID(ha, rlc->p.cmd.target, fcport->loop_id);
-		rlc->p.cmd.control_flags =
-		    __constant_cpu_to_le16(CF_READ | CF_SIMPLE_TAG);
-		rlc->p.cmd.scsi_cdb[0] = REPORT_LUNS;
-		rlc->p.cmd.scsi_cdb[8] = MSB(sizeof(rpt_lun_lst_t));
-		rlc->p.cmd.scsi_cdb[9] = LSB(sizeof(rpt_lun_lst_t));
-		rlc->p.cmd.dseg_count = __constant_cpu_to_le16(1);
-		rlc->p.cmd.timeout = __constant_cpu_to_le16(10);
-		rlc->p.cmd.byte_count =
-		    __constant_cpu_to_le32(sizeof(rpt_lun_lst_t));
-		rlc->p.cmd.dseg_0_address[0] = cpu_to_le32(
-		    LSD(rlc_dma + sizeof(sts_entry_t)));
-		rlc->p.cmd.dseg_0_address[1] = cpu_to_le32(
-		    MSD(rlc_dma + sizeof(sts_entry_t)));
-		rlc->p.cmd.dseg_0_length =
-		    __constant_cpu_to_le32(sizeof(rpt_lun_lst_t));
-
-		rval = qla2x00_issue_iocb(ha, rlc, rlc_dma,
-		    sizeof(rpt_lun_cmd_rsp_t));
-
-		comp_status = le16_to_cpu(rlc->p.rsp.comp_status);
-		scsi_status = le16_to_cpu(rlc->p.rsp.scsi_status);
-
-		if (rval != QLA_SUCCESS || comp_status != CS_COMPLETE ||
-		    scsi_status & SS_CHECK_CONDITION) {
-
-			/* Device underrun, treat as OK. */
-			if (rval == QLA_SUCCESS &&
-			    comp_status == CS_DATA_UNDERRUN &&
-			    scsi_status & SS_RESIDUAL_UNDER) {
-
-				rval = QLA_SUCCESS;
-				break;
-			}
-
-			DEBUG(printk("scsi(%ld): RLC failed to issue iocb! "
-			    "fcport=[%04x/%p] rval=%x cs=%x ss=%x\n",
-			    ha->host_no, fcport->loop_id, fcport, rval,
-			    comp_status, scsi_status));
-
-			rval = QLA_FUNCTION_FAILED;
-			if (scsi_status & SS_CHECK_CONDITION) {
-				DEBUG2(printk("scsi(%ld): RLC "
-				    "SS_CHECK_CONDITION Sense Data "
-				    "%02x %02x %02x %02x %02x %02x %02x %02x\n",
-				    ha->host_no,
-				    rlc->p.rsp.req_sense_data[0],
-				    rlc->p.rsp.req_sense_data[1],
-				    rlc->p.rsp.req_sense_data[2],
-				    rlc->p.rsp.req_sense_data[3],
-				    rlc->p.rsp.req_sense_data[4],
-				    rlc->p.rsp.req_sense_data[5],
-				    rlc->p.rsp.req_sense_data[6],
-				    rlc->p.rsp.req_sense_data[7]));
-				if (rlc->p.rsp.req_sense_data[2] ==
-				    ILLEGAL_REQUEST) {
-					fcport->flags &= ~(FCF_RLC_SUPPORT);
-					break;
-				}
-			}
-		} else {
-			break;
-		}
-	}
-
-	return (rval);
-}
-
-/*
- * qla2x00_cfg_lun
- *	Configures LUN into fcport LUN list.
- *
- * Input:
- *	fcport:		FC port structure pointer.
- *	lun:		LUN number.
- *
- * Context:
- *	Kernel context.
- */
-static fc_lun_t *
-qla2x00_cfg_lun(scsi_qla_host_t *ha, fc_port_t *fcport, uint16_t lun,
-    inq_cmd_rsp_t *inq, dma_addr_t inq_dma) 
-{
-	fc_lun_t *fclun;
-	uint8_t	  device_type;
-
-	/* Bypass LUNs that failed. */
-	if (qla2x00_inquiry(ha, fcport, lun, inq, inq_dma) != QLA_SUCCESS) {
-		DEBUG2(printk("scsi(%ld): Failed inquiry - loop id=0x%04x "
-		    "lun=%d\n", ha->host_no, fcport->loop_id, lun));
-
-		return (NULL);
-	}
-	device_type = (inq->inq[0] & 0x1f);
-	switch (device_type) {
-	case TYPE_DISK:
-	case TYPE_PROCESSOR:
-	case TYPE_WORM:
-	case TYPE_ROM:
-	case TYPE_SCANNER:
-	case TYPE_MOD:
-	case TYPE_MEDIUM_CHANGER:
-	case TYPE_ENCLOSURE:
-	case 0x20:
-	case 0x0C:
-		break;
-	case TYPE_TAPE:
-		fcport->flags |= FCF_TAPE_PRESENT;
-		break;
-	default:
-		DEBUG2(printk("scsi(%ld): Unsupported lun type -- "
-		    "loop id=0x%04x lun=%d type=%x\n",
-		    ha->host_no, fcport->loop_id, lun, device_type));
-		return (NULL);
-	}
-
-	fcport->device_type = device_type;
-	fclun = qla2x00_add_lun(fcport, lun);
-
-	if (fclun != NULL) {
-		atomic_set(&fcport->state, FCS_ONLINE);
-	}
-
-	return (fclun);
-}
-
-/*
- * qla2x00_add_lun
- *	Adds LUN to database
- *
- * Input:
- *	fcport:		FC port structure pointer.
- *	lun:		LUN number.
- *
- * Context:
- *	Kernel context.
- */
-static fc_lun_t *
-qla2x00_add_lun(fc_port_t *fcport, uint16_t lun)
-{
-	int		found;
-	fc_lun_t	*fclun;
-
-	if (fcport == NULL) {
-		DEBUG(printk("scsi: Unable to add lun to NULL port\n"));
-		return (NULL);
-	}
-
-	/* Allocate LUN if not already allocated. */
-	found = 0;
-	list_for_each_entry(fclun, &fcport->fcluns, list) {
-		if (fclun->lun == lun) {
-			found++;
-			break;
-		}
-	}
-	if (found)
-		return (NULL);
-
-	fclun = kmalloc(sizeof(fc_lun_t), GFP_ATOMIC);
-	if (fclun == NULL) {
-		printk(KERN_WARNING
-		    "%s(): Memory Allocation failed - FCLUN\n",
-		    __func__);
-		return (NULL);
-	}
-
-	/* Setup LUN structure. */
-	memset(fclun, 0, sizeof(fc_lun_t));
-	fclun->lun = lun;
-	fclun->fcport = fcport;
-	fclun->o_fcport = fcport;
-	fclun->device_type = fcport->device_type;
-	atomic_set(&fcport->state, FCS_UNCONFIGURED);
-
-	list_add_tail(&fclun->list, &fcport->fcluns);
-
-	return (fclun);
-}
-
-/*
- * qla2x00_inquiry
- *	Issue SCSI inquiry command.
- *
- * Input:
- *	ha = adapter block pointer.
- *	fcport = FC port structure pointer.
- *
- * Return:
- *	0  - Success
- *  BIT_0 - error
- *
- * Context:
- *	Kernel context.
- */
-static int
-qla2x00_inquiry(scsi_qla_host_t *ha,
-    fc_port_t *fcport, uint16_t lun, inq_cmd_rsp_t *inq, dma_addr_t inq_dma)
-{
-	int rval;
-	uint16_t retries;
-	uint16_t comp_status;
-	uint16_t scsi_status;
-
-	rval = QLA_FUNCTION_FAILED;
-
-	for (retries = 3; retries; retries--) {
-		memset(inq, 0, sizeof(inq_cmd_rsp_t));
-		inq->p.cmd.entry_type = COMMAND_A64_TYPE;
-		inq->p.cmd.entry_count = 1;
-		inq->p.cmd.lun = cpu_to_le16(lun);
-		SET_TARGET_ID(ha, inq->p.cmd.target, fcport->loop_id);
-		inq->p.cmd.control_flags =
-		    __constant_cpu_to_le16(CF_READ | CF_SIMPLE_TAG);
-		inq->p.cmd.scsi_cdb[0] = INQUIRY;
-		inq->p.cmd.scsi_cdb[4] = INQ_DATA_SIZE;
-		inq->p.cmd.dseg_count = __constant_cpu_to_le16(1);
-		inq->p.cmd.timeout = __constant_cpu_to_le16(10);
-		inq->p.cmd.byte_count =
-		    __constant_cpu_to_le32(INQ_DATA_SIZE);
-		inq->p.cmd.dseg_0_address[0] = cpu_to_le32(
-		    LSD(inq_dma + sizeof(sts_entry_t)));
-		inq->p.cmd.dseg_0_address[1] = cpu_to_le32(
-		    MSD(inq_dma + sizeof(sts_entry_t)));
-		inq->p.cmd.dseg_0_length =
-		    __constant_cpu_to_le32(INQ_DATA_SIZE);
-
-		DEBUG5(printk("scsi(%ld): Lun Inquiry - fcport=[%04x/%p],"
-		    " lun (%d)\n",
-		    ha->host_no, fcport->loop_id, fcport, lun));
-
-		rval = qla2x00_issue_iocb(ha, inq, inq_dma,
-		    sizeof(inq_cmd_rsp_t));
-
-		comp_status = le16_to_cpu(inq->p.rsp.comp_status);
-		scsi_status = le16_to_cpu(inq->p.rsp.scsi_status);
-
-		DEBUG5(printk("scsi(%ld): lun (%d) inquiry - "
-		    "inq[0]= 0x%x, comp status 0x%x, scsi status 0x%x, "
-		    "rval=%d\n",
-		    ha->host_no, lun, inq->inq[0], comp_status, scsi_status,
-		    rval));
-
-		if (rval != QLA_SUCCESS || comp_status != CS_COMPLETE ||
-		    scsi_status & SS_CHECK_CONDITION) {
-
-			DEBUG(printk("scsi(%ld): INQ failed to issue iocb! "
-			    "fcport=[%04x/%p] rval=%x cs=%x ss=%x\n",
-			    ha->host_no, fcport->loop_id, fcport, rval,
-			    comp_status, scsi_status));
 
-			if (rval == QLA_SUCCESS)
-				rval = QLA_FUNCTION_FAILED;
-
-			if (scsi_status & SS_CHECK_CONDITION) {
-				DEBUG2(printk("scsi(%ld): INQ "
-				    "SS_CHECK_CONDITION Sense Data "
-				    "%02x %02x %02x %02x %02x %02x %02x %02x\n",
-				    ha->host_no,
-				    inq->p.rsp.req_sense_data[0],
-				    inq->p.rsp.req_sense_data[1],
-				    inq->p.rsp.req_sense_data[2],
-				    inq->p.rsp.req_sense_data[3],
-				    inq->p.rsp.req_sense_data[4],
-				    inq->p.rsp.req_sense_data[5],
-				    inq->p.rsp.req_sense_data[6],
-				    inq->p.rsp.req_sense_data[7]));
-			}
-
-			/* Device underrun drop LUN. */
-			if (comp_status == CS_DATA_UNDERRUN &&
-			    scsi_status & SS_RESIDUAL_UNDER) {
-				break;
-			}
-		} else {
-			break;
-		}
-	}
+	if (rport->scsi_target_id != -1 && rport->scsi_target_id < MAX_TARGETS)
+		fcport->os_target_id = rport->scsi_target_id;
 
-	return (rval);
+	rport->dd_data = fcport;
 }
 
-
 /*
  * qla2x00_configure_fabric
  *      Setup SNS devices with loop ID's.
@@ -2514,12 +2074,12 @@ qla2x00_configure_fabric(scsi_qla_host_t
 				break;
 			}
 
-			/* Login and update database */
-			qla2x00_fabric_dev_login(ha, fcport, &next_loopid);
-
 			/* Remove device from the new list and add it to DB */
 			list_del(&fcport->list);
 			list_add_tail(&fcport->list, &ha->fcports);
+
+			/* Login and update database */
+			qla2x00_fabric_dev_login(ha, fcport, &next_loopid);
 		}
 	} while (0);
 
@@ -3203,396 +2763,6 @@ qla2x00_rescan_fcports(scsi_qla_host_t *
 		rescan_done = 1;
 	}
 	qla2x00_probe_for_all_luns(ha); 
-
-	/* Update OS target and lun structures if necessary. */
-	if (rescan_done) {
-		qla2x00_config_os(ha);
-	}
-}
-
-
-/*
- * qla2x00_config_os
- *	Setup OS target and LUN structures.
- *
- * Input:
- *	ha = adapter state pointer.
- *
- * Context:
- *	Kernel context.
- */
-static void
-qla2x00_config_os(scsi_qla_host_t *ha) 
-{
-	fc_port_t	*fcport;
-	fc_lun_t	*fclun;
-	os_tgt_t	*tq;
-	uint16_t	tgt;
-
-
-	for (tgt = 0; tgt < MAX_TARGETS; tgt++) {
-		if ((tq = TGT_Q(ha, tgt)) == NULL)
-			continue;
-
-		clear_bit(TQF_ONLINE, &tq->flags);
-	}
-
-	list_for_each_entry(fcport, &ha->fcports, list) {
-		if (atomic_read(&fcport->state) != FCS_ONLINE ||
-		    fcport->port_type == FCT_INITIATOR ||
-		    fcport->port_type == FCT_BROADCAST) {
-			fcport->os_target_id = MAX_TARGETS;
-			continue;
-		}
-
-		if (fcport->flags & FCF_FO_MASKED) {
-			continue;
-		}
-
-		/* Bind FC port to OS target number. */
-		if (qla2x00_fcport_bind(ha, fcport) == MAX_TARGETS) {
-			continue;
-		}
-
-		/* Bind FC LUN to OS LUN number. */
-		list_for_each_entry(fclun, &fcport->fcluns, list) {
-			qla2x00_fclun_bind(ha, fcport, fclun);
-		}
-	}
-}
-
-/*
- * qla2x00_fcport_bind
- *	Locates a target number for FC port.
- *
- * Input:
- *	ha = adapter state pointer.
- *	fcport = FC port structure pointer.
- *
- * Returns:
- *	target number
- *
- * Context:
- *	Kernel context.
- */
-static uint16_t
-qla2x00_fcport_bind(scsi_qla_host_t *ha, fc_port_t *fcport) 
-{
-	int		found;
-	uint16_t	tgt;
-	os_tgt_t	*tq;
-
-	/* Check for persistent binding. */
-	for (tgt = 0; tgt < MAX_TARGETS; tgt++) {
-		if ((tq = TGT_Q(ha, tgt)) == NULL)
-			continue;
-
-		found = 0;
-		switch (ha->binding_type) {
-		case BIND_BY_PORT_ID:
-			if (fcport->d_id.b24 == tq->d_id.b24) {
-				memcpy(tq->node_name, fcport->node_name,
-				    WWN_SIZE);
-				memcpy(tq->port_name, fcport->port_name,
-				    WWN_SIZE);
-				found++;
-			}
-			break;
-		case BIND_BY_PORT_NAME:    
-			if (memcmp(fcport->port_name, tq->port_name,
-			    WWN_SIZE) == 0) {
-				/*
-				 * In case of persistent binding, update the
-				 * WWNN.
-				 */
-				memcpy(tq->node_name, fcport->node_name,
-				    WWN_SIZE);
-				found++;
-			}
-			break;
-		}
-		if (found)
-		    break;	
-	}
-
-	/* TODO: honor the ConfigRequired flag */
-	if (tgt == MAX_TARGETS) {
-		/* Check if targetID 0 available. */
-		tgt = 0;
-
-		if (TGT_Q(ha, tgt) != NULL) {
-			/* Locate first free target for device. */
-			for (tgt = 0; tgt < MAX_TARGETS; tgt++) {
-				if (TGT_Q(ha, tgt) == NULL) {
-					break;
-				}
-			}
-		}
-		if (tgt != MAX_TARGETS) {
-			if ((tq = qla2x00_tgt_alloc(ha, tgt)) != NULL) {
-				memcpy(tq->node_name, fcport->node_name,
-				    WWN_SIZE);
-				memcpy(tq->port_name, fcport->port_name,
-				    WWN_SIZE);
-				tq->d_id.b24 = fcport->d_id.b24;
-			}
-		}
-	}
-
-	/* Reset target numbers incase it changed. */
-	fcport->os_target_id = tgt;
-	if (tgt != MAX_TARGETS && tq != NULL) {
-		DEBUG2(printk("scsi(%ld): Assigning target ID=%02d @ %p to "
-		    "loop id=0x%04x, port state=0x%x, port down retry=%d\n",
-		    ha->host_no, tgt, tq, fcport->loop_id,
-		    atomic_read(&fcport->state),
-		    atomic_read(&fcport->port_down_timer)));
-
-		fcport->tgt_queue = tq;
-		fcport->flags |= FCF_PERSISTENT_BOUND;
-		tq->fcport = fcport;
-		set_bit(TQF_ONLINE, &tq->flags);
-		tq->port_down_retry_count = ha->port_down_retry_count;
-	}
-
-	if (tgt == MAX_TARGETS) {
-		qla_printk(KERN_WARNING, ha,
-		    "Unable to bind fcport, loop_id=%x\n", fcport->loop_id);
-	}
-
-	return (tgt);
-}
-
-/*
- * qla2x00_fclun_bind
- *	Binds all FC device LUNS to OS LUNS.
- *
- * Input:
- *	ha:		adapter state pointer.
- *	fcport:		FC port structure pointer.
- *
- * Returns:
- *	target number
- *
- * Context:
- *	Kernel context.
- */
-static os_lun_t *
-qla2x00_fclun_bind(scsi_qla_host_t *ha, fc_port_t *fcport, fc_lun_t *fclun)
-{
-	os_lun_t	*lq;
-	uint16_t	tgt;
-	uint16_t	lun;
-
-	tgt = fcport->os_target_id;
-	lun = fclun->lun;
-
-	/* Allocate LUNs */
-	if (lun >= MAX_LUNS) {
-		DEBUG2(printk("scsi(%ld): Unable to bind lun, invalid "
-		    "lun=(%x).\n", ha->host_no, lun));
-		return (NULL);
-	}
-
-	/* Always alloc LUN 0 so kernel will scan past LUN 0. */
-	if (lun != 0 && (EXT_IS_LUN_BIT_SET(&(fcport->lun_mask), lun))) {
-		return (NULL);
-	}
-
-	if ((lq = qla2x00_lun_alloc(ha, tgt, lun)) == NULL) {
-		qla_printk(KERN_WARNING, ha,
-		    "Unable to bind fclun, loop_id=%x lun=%x\n",
-		    fcport->loop_id, lun);
-		return (NULL);
-	}
-
-	lq->fclun = fclun;
-
-	return (lq);
-}
-
-/*
- * qla2x00_tgt_alloc
- *	Allocate and pre-initialize target queue.
- *
- * Input:
- *	ha = adapter block pointer.
- *	t = SCSI target number.
- *
- * Returns:
- *	NULL = failure
- *
- * Context:
- *	Kernel context.
- */
-static os_tgt_t *
-qla2x00_tgt_alloc(scsi_qla_host_t *ha, uint16_t tgt) 
-{
-	os_tgt_t	*tq;
-
-	/*
-	 * If SCSI addressing OK, allocate TGT queue and lock.
-	 */
-	if (tgt >= MAX_TARGETS) {
-		DEBUG2(printk("scsi(%ld): Unable to allocate target, invalid "
-		    "target number %d.\n", ha->host_no, tgt));
-		return (NULL);
-	}
-
-	tq = TGT_Q(ha, tgt);
-	if (tq == NULL) {
-		tq = kmalloc(sizeof(os_tgt_t), GFP_ATOMIC);
-		if (tq != NULL) {
-			DEBUG2(printk("scsi(%ld): Alloc Target %d @ %p\n",
-			    ha->host_no, tgt, tq));
-
-			memset(tq, 0, sizeof(os_tgt_t));
-			tq->ha = ha;
-
-			TGT_Q(ha, tgt) = tq;
-		}
-	}
-	if (tq != NULL) {
-		tq->port_down_retry_count = ha->port_down_retry_count;
-	} else {
-		qla_printk(KERN_WARNING, ha,
-		    "Unable to allocate target.\n");
-		ha->mem_err++;
-	}
-
-	return (tq);
-}
-
-/*
- * qla2x00_tgt_free
- *	Frees target and LUN queues.
- *
- * Input:
- *	ha = adapter block pointer.
- *	t = SCSI target number.
- *
- * Context:
- *	Kernel context.
- */
-void
-qla2x00_tgt_free(scsi_qla_host_t *ha, uint16_t tgt) 
-{
-	os_tgt_t	*tq;
-	uint16_t	lun;
-
-	/*
-	 * If SCSI addressing OK, allocate TGT queue and lock.
-	 */
-	if (tgt >= MAX_TARGETS) {
-		DEBUG2(printk("scsi(%ld): Unable to de-allocate target, "
-		    "invalid target number %d.\n", ha->host_no, tgt));
-
-		return;
-	}
-
-	tq = TGT_Q(ha, tgt);
-	if (tq != NULL) {
-		TGT_Q(ha, tgt) = NULL;
-
-		/* Free LUN structures. */
-		for (lun = 0; lun < MAX_LUNS; lun++)
-			qla2x00_lun_free(ha, tgt, lun);
-
-		kfree(tq);
-	}
-
-	return;
-}
-
-/*
- * qla2x00_lun_alloc
- *	Allocate and initialize LUN queue.
- *
- * Input:
- *	ha = adapter block pointer.
- *	t = SCSI target number.
- *	l = LUN number.
- *
- * Returns:
- *	NULL = failure
- *
- * Context:
- *	Kernel context.
- */
-static os_lun_t *
-qla2x00_lun_alloc(scsi_qla_host_t *ha, uint16_t tgt, uint16_t lun) 
-{
-	os_lun_t	*lq;
-
-	/*
-	 * If SCSI addressing OK, allocate LUN queue.
-	 */
-	if (tgt >= MAX_TARGETS || lun >= MAX_LUNS || TGT_Q(ha, tgt) == NULL) {
-		DEBUG2(printk("scsi(%ld): Unable to allocate lun, invalid "
-		    "parameter.\n", ha->host_no));
-
-		return (NULL);
-	}
-
-	lq = LUN_Q(ha, tgt, lun);
-	if (lq == NULL) {
-		lq = kmalloc(sizeof(os_lun_t), GFP_ATOMIC);
-		if (lq != NULL) {
-			DEBUG2(printk("scsi(%ld): Alloc Lun %d @ tgt %d.\n",
-			    ha->host_no, lun, tgt));
-
-			memset(lq, 0, sizeof(os_lun_t));
-			LUN_Q(ha, tgt, lun) = lq;
-
-			/*
-			 * The following lun queue initialization code
-			 * must be duplicated in alloc_ioctl_mem function
-			 * for ioctl_lq.
-			 */
-			lq->q_state = LUN_STATE_READY;
-			spin_lock_init(&lq->q_lock);
-		}
-	}
-
-	if (lq == NULL) {
-		qla_printk(KERN_WARNING, ha, "Unable to allocate lun.\n");
-	}
-
-	return (lq);
-}
-
-/*
- * qla2x00_lun_free
- *	Frees LUN queue.
- *
- * Input:
- *	ha = adapter block pointer.
- *	t = SCSI target number.
- *
- * Context:
- *	Kernel context.
- */
-static void
-qla2x00_lun_free(scsi_qla_host_t *ha, uint16_t tgt, uint16_t lun) 
-{
-	os_lun_t	*lq;
-
-	/*
-	 * If SCSI addressing OK, allocate TGT queue and lock.
-	 */
-	if (tgt >= MAX_TARGETS || lun >= MAX_LUNS) {
-		DEBUG2(printk("scsi(%ld): Unable to deallocate lun, invalid "
-		    "parameter.\n", ha->host_no));
-
-		return;
-	}
-
-	if (TGT_Q(ha, tgt) != NULL && (lq = LUN_Q(ha, tgt, lun)) != NULL) {
-		LUN_Q(ha, tgt, lun) = NULL;
-		kfree(lq);
-	}
-
-	return;
 }
 
 /*
@@ -3642,8 +2812,6 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 				ha->outstanding_cmds[cnt] = NULL;
 				if (ha->actthreads)
 					ha->actthreads--;
-				sp->lun_queue->out_cnt--;
-
 				sp->flags = 0;
 				sp->cmd->result = DID_RESET << 16;
 				sp->cmd->host_scribble = (unsigned char *)NULL;
--- a/drivers/scsi/qla2xxx/qla_inline.h	2005-04-13 08:40:14.000000000 -0700
+++ b/drivers/scsi/qla2xxx/qla_inline.h	2005-04-13 08:45:53.000000000 -0700
@@ -187,23 +187,6 @@ qla2x00_is_wwn_zero(uint8_t *wwn)
 		return (0);
 }
 
-static __inline__ uint8_t
-qla2x00_suspend_lun(scsi_qla_host_t *, os_lun_t *, int, int);
-static __inline__ uint8_t
-qla2x00_delay_lun(scsi_qla_host_t *, os_lun_t *, int);
-
-static __inline__ uint8_t
-qla2x00_suspend_lun(scsi_qla_host_t *ha, os_lun_t *lq, int time, int count)
-{
-	return (__qla2x00_suspend_lun(ha, lq, time, count, 0));
-}
-
-static __inline__ uint8_t
-qla2x00_delay_lun(scsi_qla_host_t *ha, os_lun_t *lq, int time)
-{
-	return (__qla2x00_suspend_lun(ha, lq, time, 1, 1));
-}
-
 static __inline__ void qla2x00_check_fabric_devices(scsi_qla_host_t *);
 /*
  * This routine will wait for fabric devices for
--- a/drivers/scsi/qla2xxx/qla_iocb.c	2005-04-13 08:40:14.000000000 -0700
+++ b/drivers/scsi/qla2xxx/qla_iocb.c	2005-04-13 08:45:53.000000000 -0700
@@ -328,7 +328,6 @@ qla2x00_start_scsi(srb_t *sp)
 	int		ret;
 	unsigned long   flags;
 	scsi_qla_host_t	*ha;
-	fc_lun_t	*fclun;
 	struct scsi_cmnd *cmd;
 	uint32_t	*clr_ptr;
 	uint32_t        index;
@@ -343,8 +342,7 @@ qla2x00_start_scsi(srb_t *sp)
 
 	/* Setup device pointers. */
 	ret = 0;
-	fclun = sp->lun_queue->fclun;
-	ha = fclun->fcport->ha;
+	ha = sp->ha;
 	reg = ha->iobase;
 	cmd = sp->cmd;
 
@@ -411,11 +409,9 @@ qla2x00_start_scsi(srb_t *sp)
 	memset(clr_ptr, 0, REQUEST_ENTRY_SIZE - 8);
 	cmd_pkt->dseg_count = cpu_to_le16(tot_dsds);
 
-	/* Set target ID */
-	SET_TARGET_ID(ha, cmd_pkt->target, fclun->fcport->loop_id);
-
-	/* Set LUN number*/
-	cmd_pkt->lun = cpu_to_le16(fclun->lun);
+	/* Set target ID and LUN number*/
+	SET_TARGET_ID(ha, cmd_pkt->target, sp->fcport->loop_id);
+	cmd_pkt->lun = cpu_to_le16(sp->cmd->device->lun);
 
 	/* Update tagged queuing modifier */
 	cmd_pkt->control_flags = __constant_cpu_to_le16(CF_SIMPLE_TAG);
@@ -453,7 +449,6 @@ qla2x00_start_scsi(srb_t *sp)
 
 	ha->actthreads++;
 	ha->total_ios++;
-	sp->lun_queue->out_cnt++;
 	sp->flags |= SRB_DMA_VALID;
 	sp->state = SRB_ACTIVE_STATE;
 	sp->u_start = jiffies;
--- a/drivers/scsi/qla2xxx/qla_isr.c	2005-04-13 08:40:14.000000000 -0700
+++ b/drivers/scsi/qla2xxx/qla_isr.c	2005-04-13 08:45:53.000000000 -0700
@@ -697,7 +697,6 @@ qla2x00_process_completed_request(struct
 
 		if (ha->actthreads)
 			ha->actthreads--;
-		sp->lun_queue->out_cnt--;
 		CMD_COMPL_STATUS(sp->cmd) = 0L;
 		CMD_SCSI_STATUS(sp->cmd) = 0L;
 
@@ -818,11 +817,8 @@ qla2x00_process_response_queue(struct sc
 static void
 qla2x00_status_entry(scsi_qla_host_t *ha, sts_entry_t *pkt)
 {
-	int		ret;
 	unsigned	b, t, l;
 	srb_t		*sp;
-	os_lun_t	*lq;
-	os_tgt_t	*tq;
 	fc_port_t	*fcport;
 	struct scsi_cmnd *cp;
 	uint16_t	comp_status;
@@ -872,21 +868,6 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 	if (ha->actthreads)
 		ha->actthreads--;
 
-	if (sp->lun_queue == NULL) {
-		DEBUG2(printk("scsi(%ld): Status Entry invalid lun pointer.\n",
-		    ha->host_no));
-		qla_printk(KERN_WARNING, ha,
-		    "Status Entry invalid lun pointer.\n");
-
-		set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
-		if (ha->dpc_wait && !ha->dpc_active) 
-			up(ha->dpc_wait);
-
-		return;
-	}
-
-	sp->lun_queue->out_cnt--;
-
 	comp_status = le16_to_cpu(pkt->comp_status);
 	/* Mask of reserved bits 12-15, before we examine the scsi status */
 	scsi_status = le16_to_cpu(pkt->scsi_status) & SS_MASK;
@@ -901,8 +882,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 	t = cp->device->id;
 	l = cp->device->lun,
 
-	tq = sp->tgt_queue;
-	lq = sp->lun_queue;
+	fcport = sp->fcport;
 
 	/* Check for any FCP transport errors. */
 	if (scsi_status & SS_RESPONSE_INFO_LEN_VALID) {
@@ -1096,7 +1076,6 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 		 * Target with DID_NO_CONNECT ELSE Queue the IOs in the
 		 * retry_queue.
 		 */
-		fcport = sp->fclun->fcport;
 		DEBUG2(printk("scsi(%ld:%d:%d): status_entry: Port Down "
 		    "pid=%ld, compl status=0x%x, port state=0x%x\n",
 		    ha->host_no, t, l, cp->serial_number, comp_status,
@@ -1137,8 +1116,6 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 
 		cp->result = DID_BUS_BUSY << 16;
 
-		fcport = lq->fclun->fcport;
-
 		/* Check to see if logout occurred */
 		if ((le16_to_cpu(pkt->status_flags) & SF_LOGOUT_SENT)) {
 			qla2x00_mark_device_lost(ha, fcport, 1);
@@ -1154,16 +1131,6 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 
 		cp->result = DID_OK << 16 | lscsi_status; 
 
-		/* TODO: ??? */
-		/* Adjust queue depth */
-		ret = scsi_track_queue_full(cp->device,
-		    sp->lun_queue->out_cnt - 1);
-		if (ret) {
-			qla_printk(KERN_INFO, ha,
-			    "scsi(%ld:%d:%d:%d): Queue depth adjusted to %d.\n",
-			    ha->host_no, cp->device->channel, cp->device->id,
-			    cp->device->lun, ret);
-		}
 		break;
 
 	default:
@@ -1268,8 +1235,6 @@ qla2x00_error_entry(scsi_qla_host_t *ha,
 		ha->outstanding_cmds[pkt->handle] = NULL;
 		if (ha->actthreads)
 			ha->actthreads--;
-		sp->lun_queue->out_cnt--;
-
 		/* Bad payload or header */
 		if (pkt->entry_status &
 		    (RF_INV_E_ORDER | RF_INV_E_COUNT |
--- a/drivers/scsi/qla2xxx/qla_mbx.c	2005-04-13 08:40:14.000000000 -0700
+++ b/drivers/scsi/qla2xxx/qla_mbx.c	2005-04-13 08:45:53.000000000 -0700
@@ -858,8 +858,7 @@ qla2x00_abort_command(scsi_qla_host_t *h
 
 	DEBUG11(printk("qla2x00_abort_command(%ld): entered.\n", ha->host_no);)
 
-	fcport = sp->fclun->fcport;
-
+	fcport = sp->fcport;
 	if (atomic_read(&ha->loop_state) == LOOP_DOWN ||
 	    atomic_read(&fcport->state) == FCS_DEVICE_LOST) {
 		return 1;
@@ -884,7 +883,7 @@ qla2x00_abort_command(scsi_qla_host_t *h
 		mcp->mb[1] = fcport->loop_id << 8;
 	mcp->mb[2] = (uint16_t)handle;
 	mcp->mb[3] = (uint16_t)(handle >> 16);
-	mcp->mb[6] = (uint16_t)sp->fclun->lun;
+	mcp->mb[6] = (uint16_t)sp->cmd->device->lun;
 	mcp->out_mb = MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->in_mb = MBX_0;
 	mcp->tov = 30;
@@ -980,30 +979,22 @@ qla2x00_abort_target(fc_port_t *fcport)
  *	Kernel context.
  */
 int
-qla2x00_target_reset(scsi_qla_host_t *ha, uint16_t b, uint16_t t)
+qla2x00_target_reset(scsi_qla_host_t *ha, struct fc_port *fcport)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
-	os_tgt_t *tgt;
 
 	DEBUG11(printk("qla2x00_target_reset(%ld): entered.\n", ha->host_no);)
 
-	tgt = TGT_Q(ha, t);
-	if (tgt->fcport == NULL) {
-		/* no target to abort */
-		return 0;
-	}
-	if (atomic_read(&tgt->fcport->state) != FCS_ONLINE) {
-		/* target not online */
+	if (atomic_read(&fcport->state) != FCS_ONLINE)
 		return 0;
-	}
 
 	mcp->mb[0] = MBC_TARGET_RESET;
 	if (HAS_EXTENDED_IDS(ha))
-		mcp->mb[1] = tgt->fcport->loop_id;
+		mcp->mb[1] = fcport->loop_id;
 	else
-		mcp->mb[1] = tgt->fcport->loop_id << 8;
+		mcp->mb[1] = fcport->loop_id << 8;
 	mcp->mb[2] = ha->loop_reset_delay;
 	mcp->out_mb = MBX_2|MBX_1|MBX_0;
 	mcp->in_mb = MBX_0;
--- a/drivers/scsi/qla2xxx/qla_os.c	2005-04-13 08:44:32.000000000 -0700
+++ b/drivers/scsi/qla2xxx/qla_os.c	2005-04-13 08:51:25.000000000 -0700
@@ -75,11 +75,6 @@ MODULE_PARM_DESC(ql2xretrycount,
 		"Maximum number of mid-layer retries allowed for a command.  "
 		"Default value is 20, ");
 
-int displayConfig;
-module_param(displayConfig, int, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(displayConfig,
-		"If 1 then display the configuration used in /etc/modprobe.conf.");
-
 int ql2xplogiabsentdevice;
 module_param(ql2xplogiabsentdevice, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xplogiabsentdevice,
@@ -119,12 +114,6 @@ MODULE_PARM_DESC(ql2xsuspendcount,
 		"target returns a <NOT READY> status.  Default is 10 "
 		"iterations.");
 
-int ql2xdoinitscan = 1;
-module_param(ql2xdoinitscan, int, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(ql2xdoinitscan,
-		"Signal mid-layer to perform scan after driver load: 0 -- no "
-		"signal sent to mid-layer.");
-
 int ql2xloginretrycount = 0;
 module_param(ql2xloginretrycount, int, S_IRUGO|S_IRUSR);
 MODULE_PARM_DESC(ql2xloginretrycount,
@@ -195,8 +184,6 @@ static struct scsi_host_template qla2x00
 
 static struct scsi_transport_template *qla2xxx_transport_template = NULL;
 
-static void qla2x00_display_fc_names(scsi_qla_host_t *);
-
 /* TODO Convert to inlines
  *
  * Timer routines
@@ -332,14 +319,11 @@ static int
 qla2x00_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 {
 	scsi_qla_host_t *ha = to_qla_host(cmd->device->host);
-	os_tgt_t *tq = (os_tgt_t *) cmd->device->hostdata;
-	fc_port_t *fcport = tq->fcport;
-	os_lun_t *lq;
+	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
 	srb_t *sp;
 	int rval;
 
-	lq = GET_LU_Q(ha, cmd->device->id, cmd->device->lun);
-	if (!fcport || !lq) {
+	if (!fcport) {
 		cmd->result = DID_NO_CONNECT << 16;
 		goto qc_fail_command;
 	}
@@ -361,13 +345,8 @@ qla2x00_queuecommand(struct scsi_cmnd *c
 	}
 
 	sp->ha = ha;
+	sp->fcport = fcport;
 	sp->cmd = cmd;
-	sp->tgt_queue = tq;
-
-	sp->lun_queue = lq;
-	lq->io_cnt++;
-	sp->fclun = lq->fclun;
-
 	sp->flags = 0;
 	sp->err_id = 0;
 
@@ -677,9 +656,7 @@ int
 qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
 {
 	scsi_qla_host_t *ha = to_qla_host(cmd->device->host);
-	os_tgt_t *tq = (os_tgt_t *) cmd->device->hostdata;
-	fc_port_t *fcport = tq->fcport;
-	os_lun_t *lq;
+	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
 	srb_t *sp;
 	int ret;
 	unsigned int id, lun;
@@ -692,8 +669,7 @@ qla2xxx_eh_device_reset(struct scsi_cmnd
 	serial = cmd->serial_number;
 
 	sp = (srb_t *) CMD_SP(cmd);
-	lq = GET_LU_Q(ha, id, lun);
-	if (!sp || !fcport || !lq)
+	if (!sp || !fcport)
 		return ret;
 
 	qla_printk(KERN_INFO, ha,
@@ -826,9 +802,7 @@ int
 qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 {
 	scsi_qla_host_t *ha = to_qla_host(cmd->device->host);
-	os_tgt_t *tq = (os_tgt_t *) cmd->device->hostdata;
-	fc_port_t *fcport = tq->fcport;
-	os_lun_t *lq;
+	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
 	srb_t *sp;
 	int ret;
 	unsigned int id, lun;
@@ -841,8 +815,7 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *c
 	serial = cmd->serial_number;
 
 	sp = (srb_t *) CMD_SP(cmd);
-	lq = GET_LU_Q(ha, id, lun);
-	if (!sp || !fcport || !lq)
+	if (!sp || !fcport)
 		return ret;
 
 	qla_printk(KERN_INFO, ha,
@@ -895,9 +868,7 @@ int
 qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 {
 	scsi_qla_host_t *ha = to_qla_host(cmd->device->host);
-	os_tgt_t *tq = (os_tgt_t *) cmd->device->hostdata;
-	fc_port_t *fcport = tq->fcport;
-	os_lun_t *lq;
+	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
 	srb_t *sp;
 	int ret;
 	unsigned int id, lun;
@@ -910,8 +881,7 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *
 	serial = cmd->serial_number;
 
 	sp = (srb_t *) CMD_SP(cmd);
-	lq = GET_LU_Q(ha, id, lun);
-	if (!sp || !fcport || !lq)
+	if (!sp || !fcport)
 		return ret;
 
 	qla_printk(KERN_INFO, ha,
@@ -969,25 +939,20 @@ static int
 qla2x00_loop_reset(scsi_qla_host_t *ha)
 {
 	int status = QLA_SUCCESS;
-	uint16_t t;
-	os_tgt_t        *tq;
+	struct fc_port *fcport;
 
 	if (ha->flags.enable_lip_reset) {
 		status = qla2x00_lip_reset(ha);
 	}
 
 	if (status == QLA_SUCCESS && ha->flags.enable_target_reset) {
-		for (t = 0; t < MAX_FIBRE_DEVICES; t++) {
-			if ((tq = TGT_Q(ha, t)) == NULL)
-				continue;
-
-			if (tq->fcport == NULL)
+		list_for_each_entry(fcport, &ha->fcports, list) {
+			if (fcport->port_type != FCT_TARGET)
 				continue;
 
-			status = qla2x00_target_reset(ha, 0, t);
-			if (status != QLA_SUCCESS) {
+			status = qla2x00_target_reset(ha, fcport);
+			if (status != QLA_SUCCESS)
 				break;
-			}
 		}
 	}
 
@@ -1041,15 +1006,26 @@ static int
 qla2xxx_slave_alloc(struct scsi_device *sdev)
 {
 	scsi_qla_host_t *ha = to_qla_host(sdev->host);
-	os_tgt_t *tq;
+	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
+	fc_port_t *fcport;
+	int found;
 
-	tq = (os_tgt_t *) TGT_Q(ha, sdev->id);
-	if (!tq)
+	if (!rport)
 		return -ENXIO;
-	if (!tq->fcport)
+
+	found = 0;
+	list_for_each_entry(fcport, &ha->fcports, list) {
+		if (rport->port_name ==
+		    be64_to_cpu(*(uint64_t *)fcport->port_name)) {
+			found++;
+			break;
+		}
+		
+	}
+	if (!found)
 		return -ENXIO;
 
-	sdev->hostdata = tq;
+	sdev->hostdata = fcport;
 
 	return 0;
 }
@@ -1330,6 +1306,7 @@ int qla2x00_probe_one(struct pci_dev *pd
 	}
 
 	qla2x00_init_host_attr(ha);
+
 	/*
 	 * Startup the kernel thread for this host adapter
 	 */
@@ -1406,11 +1383,6 @@ int qla2x00_probe_one(struct pci_dev *pd
 	ha->flags.init_done = 1;
 	num_hosts++;
 
-	/* List the target we have found */
-	if (displayConfig) {
-		qla2x00_display_fc_names(ha);
-	}
-
 	qla_printk(KERN_INFO, ha, "\n"
 	    " QLogic Fibre Channel HBA Driver: %s\n"
 	    "  QLogic %s - %s\n"
@@ -1427,6 +1399,8 @@ int qla2x00_probe_one(struct pci_dev *pd
 	return 0;
 
 probe_failed:
+	fc_remove_host(ha->host);
+
 	scsi_remove_host(host);
 
 probe_alloc_failed:
@@ -1449,6 +1423,8 @@ void qla2x00_remove_one(struct pci_dev *
 
 	qla2x00_free_sysfs_attr(ha);
 
+	fc_remove_host(ha->host);
+
 	scsi_remove_host(ha->host);
 
 	qla2x00_free_device(ha);
@@ -1581,9 +1557,6 @@ qla2x00_proc_info(struct Scsi_Host *shos
 {
 	struct info_str	info;
 	int             retval = -EINVAL;
-	os_lun_t	*up;
-	os_tgt_t	*tq;
-	unsigned int	t, l;
 	uint32_t        tmp_sn;
 	uint32_t	*flags;
 	uint8_t		*loop_state;
@@ -1737,79 +1710,6 @@ qla2x00_proc_info(struct Scsi_Host *shos
 	    ha->init_cb->port_name[6],
 	    ha->init_cb->port_name[7]);
 
-	/* Print out device port names */
-	for (t = 0; t < MAX_FIBRE_DEVICES; t++) {
-		if ((tq = TGT_Q(ha, t)) == NULL)
-			continue;
-
-		copy_info(&info,
-		    "scsi-qla%d-target-%d="
-		    "%02x%02x%02x%02x%02x%02x%02x%02x;\n",
-		    (int)ha->instance, t,
-		    tq->port_name[0], tq->port_name[1],
-		    tq->port_name[2], tq->port_name[3],
-		    tq->port_name[4], tq->port_name[5],
-		    tq->port_name[6], tq->port_name[7]);
-	}
-
-	copy_info(&info, "\nSCSI LUN Information:\n");
-	copy_info(&info,
-	    "(Id:Lun)  * - indicates lun is not registered with the OS.\n");
-
-	/* scan for all equipment stats */
-	for (t = 0; t < MAX_FIBRE_DEVICES; t++) {
-		/* scan all luns */
-		for (l = 0; l < ha->max_luns; l++) {
-			up = (os_lun_t *) GET_LU_Q(ha, t, l);
-
-			if (up == NULL) {
-				continue;
-			}
-			if (up->fclun == NULL) {
-				continue;
-			}
-
-			copy_info(&info,
-			    "(%2d:%2d): Total reqs %ld,",
-			    t,l,up->io_cnt);
-
-			copy_info(&info,
-			    " Pending reqs %ld,",
-			    up->out_cnt);
-
-			if (up->io_cnt < 4) {
-				copy_info(&info,
-				    " flags 0x%x*,",
-				    (int)up->q_flag);
-			} else {
-				copy_info(&info,
-				    " flags 0x%x,",
-				    (int)up->q_flag);
-			}
-
-			copy_info(&info, 
-			    " %ld:%d:%02x %02x",
-			    up->fclun->fcport->ha->instance,
-			    up->fclun->fcport->cur_path,
-			    up->fclun->fcport->loop_id,
-			    up->fclun->device_type);
-
-			copy_info(&info, "\n");
-
-			if (info.pos >= info.offset + info.length) {
-				/* No need to continue */
-				goto profile_stop;
-			}
-		}
-
-		if (info.pos >= info.offset + info.length) {
-			/* No need to continue */
-			break;
-		}
-	}
-
-profile_stop:
-
 	retval = info.pos > info.offset ? info.pos - info.offset : 0;
 
 	DEBUG3(printk(KERN_INFO 
@@ -1820,95 +1720,6 @@ profile_stop:
 }
 
 /*
-* qla2x00_display_fc_names
-*      This routine will the node names of the different devices found
-*      after port inquiry.
-*
-* Input:
-*      cmd = SCSI command structure
-*
-* Returns:
-*      None.
-*/
-static void
-qla2x00_display_fc_names(scsi_qla_host_t *ha) 
-{
-	uint16_t	tgt;
-	os_tgt_t	*tq;
-
-	/* Display the node name for adapter */
-	qla_printk(KERN_INFO, ha,
-	    "scsi-qla%d-adapter-node=%02x%02x%02x%02x%02x%02x%02x%02x\\;\n",
-	    (int)ha->instance,
-	    ha->init_cb->node_name[0],
-	    ha->init_cb->node_name[1],
-	    ha->init_cb->node_name[2],
-	    ha->init_cb->node_name[3],
-	    ha->init_cb->node_name[4],
-	    ha->init_cb->node_name[5],
-	    ha->init_cb->node_name[6],
-	    ha->init_cb->node_name[7]);
-
-	/* display the port name for adapter */
-	qla_printk(KERN_INFO, ha,
-	    "scsi-qla%d-adapter-port=%02x%02x%02x%02x%02x%02x%02x%02x\\;\n",
-	    (int)ha->instance,
-	    ha->init_cb->port_name[0],
-	    ha->init_cb->port_name[1],
-	    ha->init_cb->port_name[2],
-	    ha->init_cb->port_name[3],
-	    ha->init_cb->port_name[4],
-	    ha->init_cb->port_name[5],
-	    ha->init_cb->port_name[6],
-	    ha->init_cb->port_name[7]);
-
-	/* Print out device port names */
-	for (tgt = 0; tgt < MAX_TARGETS; tgt++) {
-		if ((tq = ha->otgt[tgt]) == NULL)
-			continue;
-
-		if (tq->fcport == NULL)
-			continue;
-
-		switch (ha->binding_type) {
-			case BIND_BY_PORT_NAME:
-				qla_printk(KERN_INFO, ha,
-				    "scsi-qla%d-tgt-%d-di-0-port="
-				    "%02x%02x%02x%02x%02x%02x%02x%02x\\;\n",
-				    (int)ha->instance, 
-				    tgt,
-				    tq->port_name[0], 
-				    tq->port_name[1],
-				    tq->port_name[2], 
-				    tq->port_name[3],
-				    tq->port_name[4], 
-				    tq->port_name[5],
-				    tq->port_name[6], 
-				    tq->port_name[7]);
-
-				break;
-
-			case BIND_BY_PORT_ID:
-				qla_printk(KERN_INFO, ha,
-				    "scsi-qla%d-tgt-%d-di-0-pid="
-				    "%02x%02x%02x\\;\n",
-				    (int)ha->instance,
-				    tgt,
-				    tq->d_id.b.domain,
-				    tq->d_id.b.area,
-				    tq->d_id.b.al_pa);
-				break;
-		}
-
-#if VSA
-		qla_printk(KERN_INFO, ha,
-		    "scsi-qla%d-target-%d-vsa=01;\n", (int)ha->instance, tgt);
-#endif
-	}
-}
-
-
-/*
  * qla2x00_mark_device_lost Updates fcport state when device goes offline.
  *
  * Input: ha = adapter block pointer.  fcport = port structure pointer.
@@ -2199,11 +2010,8 @@ qla2x00_mem_alloc(scsi_qla_host_t *ha)
 static void
 qla2x00_mem_free(scsi_qla_host_t *ha)
 {
-	uint32_t	t;
 	struct list_head	*fcpl, *fcptemp;
 	fc_port_t	*fcport;
-	struct list_head	*fcll, *fcltemp;
-	fc_lun_t	*fclun;
 	unsigned long	wtime;/* max wait time if mbx cmd is busy. */
 
 	if (ha == NULL) {
@@ -2212,11 +2020,6 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
 		return;
 	}
 
-	/* Free the target queues */
-	for (t = 0; t < MAX_TARGETS; t++) {
-		qla2x00_tgt_free(ha, t);
-	}
-
 	/* Make sure all other threads are stopped. */
 	wtime = 60 * HZ;
 	while (ha->dpc_wait && wtime) {
@@ -2295,14 +2098,6 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
 	list_for_each_safe(fcpl, fcptemp, &ha->fcports) {
 		fcport = list_entry(fcpl, fc_port_t, list);
 
-		/* fc luns */
-		list_for_each_safe(fcll, fcltemp, &fcport->fcluns) {
-			fclun = list_entry(fcll, fc_lun_t, list);
-
-			list_del_init(&fclun->list);
-			kfree(fclun);
-		}
-
 		/* fc ports */
 		list_del_init(&fcport->list);
 		kfree(fcport);
@@ -2648,6 +2443,7 @@ qla2x00_sp_compl(scsi_qla_host_t *ha, sr
 
 	cmd->scsi_done(cmd);
 }
+
 /**************************************************************************
 *   qla2x00_timer
 *
@@ -2713,11 +2509,13 @@ qla2x00_timer(scsi_qla_host_t *ha)
 			spin_lock_irqsave(&ha->hardware_lock, cpu_flags);
 			for (index = 1; index < MAX_OUTSTANDING_COMMANDS;
 			    index++) {
+				fc_port_t *sfcp;
+
 				sp = ha->outstanding_cmds[index];
 				if (!sp)
 					continue;
-				if (!(sp->fclun->fcport->flags &
-				    FCF_TAPE_PRESENT))
+				sfcp = sp->fcport;
+				if (!(sfcp->flags & FCF_TAPE_PRESENT))
 					continue;
 
 				set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
-- 
Andrew Vasquez
