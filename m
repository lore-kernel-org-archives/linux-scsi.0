From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [3/3]   qla2xxx: remove internal lun discovery...
Date: Fri, 04 Feb 2005 11:27:46 -0800
Message-ID: <1107545266.14183.22.camel@plap.san.rr.com>
References: <1107544908.14183.11.camel@plap.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from avexch02.qlogic.com ([198.70.193.200]:44858 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261806AbVBDT10
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Feb 2005 14:27:26 -0500
In-Reply-To: <1107544908.14183.11.camel@plap.san.rr.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew.Vasquez@qlogic.com

  Remove internal lun discovery routines and support
  structures.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_dbg.c    |    5 
 drivers/scsi/qla2xxx/qla_def.h    |   69 ----
 drivers/scsi/qla2xxx/qla_gbl.h    |    6 
 drivers/scsi/qla2xxx/qla_init.c   |  584 --------------------------------------
 drivers/scsi/qla2xxx/qla_inline.h |   17 -
 drivers/scsi/qla2xxx/qla_iocb.c   |   13 
 drivers/scsi/qla2xxx/qla_isr.c    |   36 --
 drivers/scsi/qla2xxx/qla_mbx.c    |    5 
 drivers/scsi/qla2xxx/qla_os.c     |   98 ------
 9 files changed, 21 insertions(+), 812 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
--- a/drivers/scsi/qla2xxx/qla_dbg.c	2005-02-04 10:27:05 -08:00
+++ b/drivers/scsi/qla2xxx/qla_dbg.c	2005-02-04 10:27:05 -08:00
@@ -1067,11 +1067,6 @@
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
diff -Nru a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h	2005-02-04 10:27:05 -08:00
+++ b/drivers/scsi/qla2xxx/qla_def.h	2005-02-04 10:27:05 -08:00
@@ -253,8 +253,6 @@
 
 	/* Target/LUN queue pointers. */
 	struct os_tgt *tgt_queue;	/* ptr to visible ha's target */
-	struct os_lun *lun_queue;	/* ptr to visible ha's lun */
-	struct fc_lun *fclun;		/* FC LUN context pointer. */
 
 	/* Timing counts. */
 	unsigned long e_start;		/* Start of extend timeout */
@@ -1606,7 +1604,6 @@
  * SCSI Target Queue structure
  */
 typedef struct os_tgt {
-	struct os_lun *olun[MAX_LUNS]; /* LUN context pointer. */
 	struct fc_port *fcport;
 	unsigned long flags;
 	uint8_t port_down_retry_count;
@@ -1626,48 +1623,6 @@
 #define TQF_SUSPENDED		1
 #define TQF_RETRY_CMDS		2
 
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
 
 /*
  * Fibre channel port type.
@@ -1686,8 +1641,6 @@
  */
 typedef struct fc_port {
 	struct list_head list;
-	struct list_head fcluns;
-
 	struct scsi_qla_host *ha;
 	struct scsi_qla_host *vis_ha;	/* only used when suspending lun */
 
@@ -1717,7 +1670,6 @@
 	uint8_t mp_byte;		/* multi-path byte (not used) */
     	uint8_t cur_path;		/* current path id */
 
-	lun_bit_mask_t lun_mask;
 	struct fc_rport *rport;
 } fc_port_t;
 
@@ -1765,25 +1717,6 @@
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
                                                   @@ -2400,8 +2333,6 @@
 #define LOOP_RDY(ha)	(!LOOP_NOT_READY(ha))
 
 #define TGT_Q(ha, t) (ha->otgt[t])
-#define LUN_Q(ha, t, l)	(TGT_Q(ha, t)->olun[l])
-#define GET_LU_Q(ha, t, l) ((TGT_Q(ha,t) != NULL)? TGT_Q(ha, t)->olun[l] : NULL)
 
 #define to_qla_host(x)		((scsi_qla_host_t *) (x)->hostdata)
 
diff -Nru a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
--- a/drivers/scsi/qla2xxx/qla_gbl.h	2005-02-04 10:27:05 -08:00
+++ b/drivers/scsi/qla2xxx/qla_gbl.h	2005-02-04 10:27:05 -08:00
@@ -81,12 +81,6 @@
 
 extern void qla2x00_cmd_timeout(srb_t *);
 
-extern int __qla2x00_suspend_lun(scsi_qla_host_t *, os_lun_t *, int, int, int);
-
-extern void qla2x00_done(scsi_qla_host_t *);
-extern void qla2x00_flush_failover_q(scsi_qla_host_t *, os_lun_t *);
-extern void qla2x00_reset_lun_fo_counts(scsi_qla_host_t *, os_lun_t *);
-
 extern void qla2x00_mark_device_lost(scsi_qla_host_t *, fc_port_t *, int);
 extern void qla2x00_mark_all_devices_lost(scsi_qla_host_t *);
 
diff -Nru a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c	2005-02-04 10:27:05 -08:00
+++ b/drivers/scsi/qla2xxx/qla_init.c	2005-02-04 10:27:05 -08:00
@@ -49,15 +49,6 @@
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
@@ -65,14 +56,9 @@
     uint16_t *);
 static void qla2x00_config_os(scsi_qla_host_t *ha);
 static uint16_t qla2x00_fcport_bind(scsi_qla_host_t *ha, fc_port_t *fcport);
-static os_lun_t * qla2x00_fclun_bind(scsi_qla_host_t *, fc_port_t *,
-    fc_lun_t *);
-static void qla2x00_lun_free(scsi_qla_host_t *, uint16_t, uint16_t);
-
 static int qla2x00_restart_isp(scsi_qla_host_t *);
 static void qla2x00_reset_adapter(scsi_qla_host_t *);
 static os_tgt_t *qla2x00_tgt_alloc(scsi_qla_host_t *, uint16_t);
-static os_lun_t *qla2x00_lun_alloc(scsi_qla_host_t *, uint16_t, uint16_t);
 static void qla2x00_reg_remote_port(scsi_qla_host_t *, fc_port_t *);
 
 /****************************************************************************/
@@ -1574,7 +1560,6 @@
 	fcport->iodesc_idx_sent = IODESC_INVALID_INDEX;
 	atomic_set(&fcport->state, FCS_UNCONFIGURED);
 	fcport->flags = FCF_RLC_SUPPORT;
-	INIT_LIST_HEAD(&fcport->fcluns);
 
 	return (fcport);
 }
@@ -1909,8 +1894,11 @@
 	if (fcport->flags & FCF_TAPE_PRESENT) {
 		spin_lock_irqsave(&ha->hardware_lock, flags);
 		for (index = 1; index < MAX_OUTSTANDING_COMMANDS; index++) {
+			fc_port_t *sfcp;
+
 			if ((sp = ha->outstanding_cmds[index]) != 0) {
-				if (sp->fclun->fcport == fcport) {
+				sfcp = sp->tgt_queue->fcport;
+				if (sfcp == fcport) {
 					atomic_set(&fcport->state, FCS_ONLINE);
 					spin_unlock_irqrestore(
 					    &ha->hardware_lock, flags);
@@ -1926,7 +1914,6 @@
 	    fcport->port_type == FCT_BROADCAST) {
 		fcport->device_type = TYPE_PROCESSOR;
 	} else {
-		qla2x00_lun_discovery(ha, fcport);
 	}
 	atomic_set(&fcport->state, FCS_ONLINE);
 	qla2x00_reg_remote_port(ha, fcport);
@@ -1956,412 +1943,6 @@
 		qla_printk(KERN_WARNING, ha,
 		    "Unable to allocate fc remote port!\n");
 }
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
-
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
-
-	return (rval);
-}
-
 
 /*
  * qla2x00_configure_fabric
@@ -3209,7 +2790,6 @@
 	}
 }
 
-
 /*
  * qla2x00_config_os
  *	Setup OS target and LUN structures.
@@ -3224,7 +2804,6 @@
 qla2x00_config_os(scsi_qla_host_t *ha) 
 {
 	fc_port_t	*fcport;
-	fc_lun_t	*fclun;
 	os_tgt_t	*tq;
 	uint16_t	tgt;
 
@@ -3252,11 +2831,6 @@
 		if (qla2x00_fcport_bind(ha, fcport) == MAX_TARGETS) {
 			continue;
 		}
-
-		/* Bind FC LUN to OS LUN number. */
-		list_for_each_entry(fclun, &fcport->fcluns, list) {
-			qla2x00_fclun_bind(ha, fcport, fclun);
-		}
 	}
 }
 
@@ -3363,54 +2937,6 @@
 }
 
 /*
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
  * qla2x00_tgt_alloc
  *	Allocate and pre-initialize target queue.
  *
@@ -3477,8 +3003,6 @@
 qla2x00_tgt_free(scsi_qla_host_t *ha, uint16_t tgt) 
 {
 	os_tgt_t	*tq;
-	uint16_t	lun;
-
 	/*
 	 * If SCSI addressing OK, allocate TGT queue and lock.
                                                                    	 */
@@ -3492,106 +3016,8 @@
 	tq = TGT_Q(ha, tgt);
 	if (tq != NULL) {
 		TGT_Q(ha, tgt) = NULL;
                                                                       -
-		/* Free LUN structures. */
-		for (lun = 0; lun < MAX_LUNS; lun++)
-			qla2x00_lun_free(ha, tgt, lun);
-
 		kfree(tq);
 	}
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
@@ -3641,8 +3067,6 @@
 				ha->outstanding_cmds[cnt] = NULL;
 				if (ha->actthreads)
 					ha->actthreads--;
-				sp->lun_queue->out_cnt--;
-
 				sp->flags = 0;
 				sp->cmd->result = DID_RESET << 16;
 				sp->cmd->host_scribble = (unsigned char *)NULL;
diff -Nru a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
--- a/drivers/scsi/qla2xxx/qla_inline.h	2005-02-04 10:27:05 -08:00
+++ b/drivers/scsi/qla2xxx/qla_inline.h	2005-02-04 10:27:05 -08:00
@@ -187,23 +187,6 @@
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
diff -Nru a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
--- a/drivers/scsi/qla2xxx/qla_iocb.c	2005-02-04 10:27:05 -08:00
+++ b/drivers/scsi/qla2xxx/qla_iocb.c	2005-02-04 10:27:05 -08:00
@@ -328,7 +328,6 @@
 	int		ret;
 	unsigned long   flags;
 	scsi_qla_host_t	*ha;
-	fc_lun_t	*fclun;
 	struct scsi_cmnd *cmd;
 	uint32_t	*clr_ptr;
 	uint32_t        index;
@@ -343,8 +342,7 @@
 
 	/* Setup device pointers. */
 	ret = 0;
-	fclun = sp->lun_queue->fclun;
-	ha = fclun->fcport->ha;
+	ha = sp->ha;
 	reg = ha->iobase;
 	cmd = sp->cmd;
 
@@ -411,11 +409,9 @@
 	memset(clr_ptr, 0, REQUEST_ENTRY_SIZE - 8);
 	cmd_pkt->dseg_count = cpu_to_le16(tot_dsds);
 
-	/* Set target ID */
-	SET_TARGET_ID(ha, cmd_pkt->target, fclun->fcport->loop_id);
-
-	/* Set LUN number*/
-	cmd_pkt->lun = cpu_to_le16(fclun->lun);
+	/* Set target ID and LUN number*/
+	SET_TARGET_ID(ha, cmd_pkt->target, sp->tgt_queue->fcport->loop_id);
+	cmd_pkt->lun = cpu_to_le16(sp->cmd->device->lun);
 
 	/* Update tagged queuing modifier */
 	cmd_pkt->control_flags = __constant_cpu_to_le16(CF_SIMPLE_TAG);
@@ -453,7 +449,6 @@
 
 	ha->actthreads++;
 	ha->total_ios++;
-	sp->lun_queue->out_cnt++;
 	sp->flags |= SRB_DMA_VALID;
 	sp->state = SRB_ACTIVE_STATE;
 	sp->u_start = jiffies;
diff -Nru a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
--- a/drivers/scsi/qla2xxx/qla_isr.c	2005-02-04 10:27:05 -08:00
+++ b/drivers/scsi/qla2xxx/qla_isr.c	2005-02-04 10:27:05 -08:00
@@ -697,7 +697,6 @@
 
 		if (ha->actthreads)
 			ha->actthreads--;
-		sp->lun_queue->out_cnt--;
 		CMD_COMPL_STATUS(sp->cmd) = 0L;
 		CMD_SCSI_STATUS(sp->cmd) = 0L;
 
@@ -818,10 +817,8 @@
 static void
 qla2x00_status_entry(scsi_qla_host_t *ha, sts_entry_t *pkt)
 {
-	int		ret;
 	unsigned	b, t, l;
 	srb_t		*sp;
-	os_lun_t	*lq;
 	os_tgt_t	*tq;
 	fc_port_t	*fcport;
 	struct scsi_cmnd *cp;
@@ -872,21 +869,6 @@
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
@@ -902,7 +884,6 @@
 	l = cp->device->lun,
 
 	tq = sp->tgt_queue;
-	lq = sp->lun_queue;
 
 	/* Check for any FCP transport errors. */
 	if (scsi_status & SS_RESPONSE_INFO_LEN_VALID) {
@@ -1096,7 +1077,7 @@
 		 * Target with DID_NO_CONNECT ELSE Queue the IOs in the
 		 * retry_queue.
 		 */
-		fcport = sp->fclun->fcport;
+		fcport = tq->fcport;
 		DEBUG2(printk("scsi(%ld:%d:%d): status_entry: Port Down "
 		    "pid=%ld, compl status=0x%x, port state=0x%x\n",
 		    ha->host_no, t, l, cp->serial_number, comp_status,
@@ -1137,8 +1118,7 @@
 
 		cp->result = DID_BUS_BUSY << 16;
 
-		fcport = lq->fclun->fcport;
-
+		fcport = tq->fcport;
 		/* Check to see if logout occurred */
 		if ((le16_to_cpu(pkt->status_flags) & SF_LOGOUT_SENT)) {
 			qla2x00_mark_device_lost(ha, fcport, 1);
@@ -1154,16 +1134,6 @@
 
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
@@ -1268,8 +1238,6 @@
 		ha->outstanding_cmds[pkt->handle] = NULL;
 		if (ha->actthreads)
 			ha->actthreads--;
-		sp->lun_queue->out_cnt--;
-
 		/* Bad payload or header */
 		if (pkt->entry_status &
 		    (RF_INV_E_ORDER | RF_INV_E_COUNT |
diff -Nru a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
--- a/drivers/scsi/qla2xxx/qla_mbx.c	2005-02-04 10:27:05 -08:00
+++ b/drivers/scsi/qla2xxx/qla_mbx.c	2005-02-04 10:27:05 -08:00
@@ -858,8 +858,7 @@
 
 	DEBUG11(printk("qla2x00_abort_command(%ld): entered.\n", ha->host_no);)
 
-	fcport = sp->fclun->fcport;
-
+	fcport = sp->tgt_queue->fcport;
 	if (atomic_read(&ha->loop_state) == LOOP_DOWN ||
 	    atomic_read(&fcport->state) == FCS_DEVICE_LOST) {
 		return 1;
@@ -884,7 +883,7 @@
 		mcp->mb[1] = fcport->loop_id << 8;
 	mcp->mb[2] = (uint16_t)handle;
 	mcp->mb[3] = (uint16_t)(handle >> 16);
-	mcp->mb[6] = (uint16_t)sp->fclun->lun;
+	mcp->mb[6] = (uint16_t)sp->cmd->device->lun;
 	mcp->out_mb = MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->in_mb = MBX_0;
 	mcp->tov = 30;
diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	2005-02-04 10:27:05 -08:00
+++ b/drivers/scsi/qla2xxx/qla_os.c	2005-02-04 10:27:05 -08:00
@@ -334,12 +334,10 @@
 	scsi_qla_host_t *ha = to_qla_host(cmd->device->host);
 	os_tgt_t *tq = (os_tgt_t *) cmd->device->hostdata;
 	fc_port_t *fcport = tq->fcport;
-	os_lun_t *lq;
 	srb_t *sp;
 	int rval;
 
-	lq = GET_LU_Q(ha, cmd->device->id, cmd->device->lun);
-	if (!fcport || !lq) {
+	if (!fcport) {
 		cmd->result = DID_NO_CONNECT << 16;
 		goto qc_fail_command;
 	}
@@ -363,11 +361,6 @@
 	sp->ha = ha;
 	sp->cmd = cmd;
 	sp->tgt_queue = tq;
-
-	sp->lun_queue = lq;
-	lq->io_cnt++;
-	sp->fclun = lq->fclun;
-
 	sp->flags = 0;
 	sp->err_id = 0;
 
@@ -681,7 +674,6 @@
 	scsi_qla_host_t *ha = to_qla_host(cmd->device->host);
 	os_tgt_t *tq = (os_tgt_t *) cmd->device->hostdata;
 	fc_port_t *fcport = tq->fcport;
-	os_lun_t *lq;
 	srb_t *sp;
 	int ret;
 	unsigned int id, lun;
@@ -694,8 +686,7 @@
 	serial = cmd->serial_number;
 
 	sp = (srb_t *) CMD_SP(cmd);
-	lq = GET_LU_Q(ha, id, lun);
-	if (!sp || !fcport || !lq)
+	if (!sp || !fcport)
 		return ret;
 
 	qla_printk(KERN_INFO, ha,
@@ -830,7 +821,6 @@
 	scsi_qla_host_t *ha = to_qla_host(cmd->device->host);
 	os_tgt_t *tq = (os_tgt_t *) cmd->device->hostdata;
 	fc_port_t *fcport = tq->fcport;
-	os_lun_t *lq;
 	srb_t *sp;
 	int ret;
 	unsigned int id, lun;
@@ -843,8 +833,7 @@
 	serial = cmd->serial_number;
 
 	sp = (srb_t *) CMD_SP(cmd);
-	lq = GET_LU_Q(ha, id, lun);
-	if (!sp || !fcport || !lq)
+	if (!sp || !fcport)
 		return ret;
 
 	qla_printk(KERN_INFO, ha,
@@ -899,7 +888,6 @@
 	scsi_qla_host_t *ha = to_qla_host(cmd->device->host);
 	os_tgt_t *tq = (os_tgt_t *) cmd->device->hostdata;
 	fc_port_t *fcport = tq->fcport;
-	os_lun_t *lq;
 	srb_t *sp;
 	int ret;
 	unsigned int id, lun;
@@ -912,8 +900,7 @@
 	serial = cmd->serial_number;
 
 	sp = (srb_t *) CMD_SP(cmd);
-	lq = GET_LU_Q(ha, id, lun);
-	if (!sp || !fcport || !lq)
+	if (!sp || !fcport)
 		return ret;
 
 	qla_printk(KERN_INFO, ha,
@@ -1583,9 +1570,8 @@
 {
 	struct info_str	info;
 	int             retval = -EINVAL;
-	os_lun_t	*up;
 	os_tgt_t	*tq;
-	unsigned int	t, l;
+	unsigned int	t;
 	uint32_t        tmp_sn;
 	uint32_t	*flags;
 	uint8_t		*loop_state;
@@ -1754,64 +1740,6 @@
 		    tq->port_name[6], tq->port_name[7]);
 	}
 
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
@@ -2204,8 +2132,6 @@
 	uint32_t	t;
 	struct list_head	*fcpl, *fcptemp;
 	fc_port_t	*fcport;
-	struct list_head	*fcll, *fcltemp;
-	fc_lun_t	*fclun;
 	unsigned long	wtime;/* max wait time if mbx cmd is busy. */
 
 	if (ha == NULL) {
@@ -2297,14 +2223,6 @@
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
@@ -2715,11 +2633,13 @@
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
+				sfcp = sp->tgt_queue->fcport;
+				if (!(sfcp->flags & FCF_TAPE_PRESENT))
 					continue;
 
 				set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);

