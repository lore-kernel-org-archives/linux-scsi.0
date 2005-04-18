From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove some dead code in qla2xxx
Date: Mon, 18 Apr 2005 15:03:34 +0200
Message-ID: <20050418130334.GA30034@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:11200 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262078AbVDRNEE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Apr 2005 09:04:04 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org


===== drivers/scsi/qla2xxx/qla_dbg.c 1.12 vs edited =====
--- 1.12/drivers/scsi/qla2xxx/qla_dbg.c	2005-04-13 17:45:53 +02:00
+++ edited/drivers/scsi/qla2xxx/qla_dbg.c	2005-04-18 16:22:48 +02:00
@@ -1063,8 +1063,7 @@
 		return;
 
 	printk("  sp flags=0x%x\n", sp->flags);
-	printk("  r_start=0x%lx, u_start=0x%lx, f_start=0x%lx, state=%d\n",
-	    sp->r_start, sp->u_start, sp->f_start, sp->state);
+	printk("  state=%d\n", sp->state);
 }
 
 #if defined(QL_DEBUG_ROUTINES)
===== drivers/scsi/qla2xxx/qla_def.h 1.30 vs edited =====
--- 1.30/drivers/scsi/qla2xxx/qla_def.h	2005-04-13 17:45:53 +02:00
+++ edited/drivers/scsi/qla2xxx/qla_def.h	2005-04-18 16:35:47 +02:00
@@ -252,31 +252,12 @@
 	/* Request state */
 	uint16_t state;
 
-	/* Timing counts. */
-	unsigned long e_start;		/* Start of extend timeout */
-	unsigned long r_start;		/* Start of request */
-	unsigned long u_start;		/* When sent to RISC */
-	unsigned long f_start;		/* When placed in FO queue*/
-
 	/* Single transfer DMA context */
 	dma_addr_t dma_handle;
 
 	uint32_t request_sense_length;
 	uint8_t *request_sense_ptr;
 
-	int ext_history;
-
-	/* Suspend delay */
-	int delay;
-
-	/* Raw completion info for use by failover ? */
-	uint8_t	fo_retry_cnt;		/* Retry count this request */
-	uint8_t	err_id;			/* error id */
-#define SRB_ERR_PORT	1		/* Request failed -- "port down" */
-#define SRB_ERR_LOOP	2		/* Request failed -- "loop down" */
-#define SRB_ERR_DEVICE	3		/* Request failed -- "device error" */
-#define SRB_ERR_OTHER	4
-
 	/* SRB magic number */
 	uint16_t magic;
 #define SRB_MAGIC       0x10CB
@@ -2082,23 +2063,8 @@
 	uint32_t	current_outstanding_cmd; 
 	srb_t		*status_srb;	/* Status continuation entry. */
 
-	unsigned long	last_irq_cpu;	/* cpu where we got our last irq */
-
 	uint16_t           revision;
 	uint8_t           ports;
-	u_long            actthreads;
-	u_long            ipreq_cnt;
-	u_long            qthreads;
-
-	uint32_t        total_isr_cnt;		/* Interrupt count */
-	uint32_t        total_isp_aborts;	/* controller err cnt */
-	uint32_t        total_lip_cnt;		/* LIP cnt */
-	uint32_t	total_dev_errs;		/* device error cnt */
-	uint32_t	total_ios;		/* IO cnt */
-	uint64_t	total_bytes;		/* xfr byte cnt */
-	uint32_t	total_mbx_timeout;	/* mailbox timeout cnt */
-	uint32_t 	total_loop_resync; 	/* loop resyn cnt */
-	uint32_t	dropped_frame_error_cnt;
 
 	/* ISP configuration data. */
 	uint16_t	loop_id;		/* Host adapter loop id */
@@ -2124,8 +2090,6 @@
 #define P2P_LOOP  3
 
         uint8_t		marker_needed; 
-	uint8_t		sns_retry_cnt;
-	uint8_t		mem_err;
 
 	uint8_t		interrupts_on;
 
@@ -2138,16 +2102,11 @@
 	uint16_t	nvram_base;
 
 	uint16_t	loop_reset_delay;
-	uint16_t	minimum_timeout;
 	uint8_t		retry_count;
 	uint8_t		login_timeout;
 	uint16_t	r_a_tov;
 	int		port_down_retry_count;
-	uint8_t		loop_down_timeout;
 	uint8_t		mbx_count;
-	uint16_t	max_probe_luns;
-	uint16_t	max_luns;
-	uint16_t	max_targets;
 	uint16_t	last_loop_id;
 
         uint32_t	login_retry_count; 
@@ -2181,7 +2140,6 @@
 	uint8_t dpc_active;                  /* DPC routine is active */
 
 	/* Timeout timers. */
-	uint8_t         queue_restart_timer;   
 	uint8_t         loop_down_abort_time;    /* port down timer */
 	atomic_t        loop_down_timer;         /* loop down timer */
 	uint8_t         link_down_timeout;       /* link down timeout */
@@ -2230,18 +2188,6 @@
 
 	mbx_cmd_t 	mc;
 
-	uint8_t	*cmdline;
-
-	uint32_t failover_type;
-	uint32_t failback_delay;
-	unsigned long   cfg_flags;
-#define	CFG_ACTIVE	0	/* CFG during a failover, event update, or ioctl */
-#define	CFG_FAILOVER	1	/* CFG during path change */
-
-	uint32_t	binding_type;
-#define BIND_BY_PORT_NAME	0
-#define BIND_BY_PORT_ID		1
-
 	/* Basic firmware related information. */
 	struct qla_board_info	*brd_info;
 	uint16_t	fw_major_version;
@@ -2273,12 +2219,6 @@
 	uint8_t     node_name[WWN_SIZE];
 	uint8_t     nvram_version; 
 	uint32_t    isp_abort_cnt;
-
-	/* Adapter I/O statistics for failover */
-	uint64_t	IosRequested;
-	uint64_t	BytesRequested;
-	uint64_t	IosExecuted;
-	uint64_t	BytesExecuted;
 
 	/* Needed for BEACON */
 	uint16_t	beacon_blink_led;
===== drivers/scsi/qla2xxx/qla_gbl.h 1.19 vs edited =====
--- 1.19/drivers/scsi/qla2xxx/qla_gbl.h	2005-04-13 17:45:53 +02:00
+++ edited/drivers/scsi/qla2xxx/qla_gbl.h	2005-04-18 16:37:20 +02:00
@@ -54,27 +54,13 @@
  */
 extern char qla2x00_version_str[];
 
-extern int num_hosts;
-extern int apiHBAInstance;
-
-extern struct _qla2x00stats qla2x00_stats;
-extern int ql2xretrycount;
 extern int ql2xlogintimeout;
 extern int qlport_down_retry;
-extern int ql2xmaxqdepth;
-extern int displayConfig;
 extern int ql2xplogiabsentdevice;
 extern int ql2xenablezio;
 extern int ql2xintrdelaytimer;
 extern int ql2xloginretrycount;
 
-extern int ConfigRequired;
-
-extern int Bind;
-extern int ql2xsuspendcount;
-#if defined(MODULE)
-extern char *ql2xopts;
-#endif
 extern void qla2x00_sp_compl(scsi_qla_host_t *, srb_t *);
 
 extern char *qla2x00_get_fw_version_str(struct scsi_qla_host *, char *);
===== drivers/scsi/qla2xxx/qla_init.c 1.44 vs edited =====
--- 1.44/drivers/scsi/qla2xxx/qla_init.c	2005-04-13 17:51:11 +02:00
+++ edited/drivers/scsi/qla2xxx/qla_init.c	2005-04-18 16:37:01 +02:00
@@ -85,9 +85,7 @@
 	atomic_set(&ha->loop_down_timer, LOOP_DOWN_TIME);
 	atomic_set(&ha->loop_state, LOOP_DOWN);
 	ha->device_flags = 0;
-	ha->sns_retry_cnt = 0;
 	ha->dpc_flags = 0;
-	ha->failback_delay = 0;
 	ha->flags.management_server_logged_in = 0;
 	ha->marker_needed = 0;
 	ha->mbx_flags = 0;
@@ -171,8 +169,6 @@
 
 				if (wait_time == 0)
 					rval = QLA_FUNCTION_FAILED;
-				if (ha->mem_err)
-					restart_risc = 1;
 			} else if (ha->device_flags & DFLG_NO_CABLE)
 				/* If no cable, then all is good. */
 				rval = QLA_SUCCESS;
@@ -1410,13 +1406,8 @@
 	/* Set minimum RATOV to 200 tenths of a second. */
 	ha->r_a_tov = 200;
 
-	ha->minimum_timeout =
-	    (ha->login_timeout * ha->retry_count) + nv->port_down_retry_count;
 	ha->loop_reset_delay = nv->reset_delay;
 
-	/* Will get the value from NVRAM. */
-	ha->loop_down_timeout = LOOP_DOWN_TIMEOUT;
-
 	/* Link Down Timeout = 0:
 	 *
 	 * 	When Port Down timer expires we will start returning
@@ -1429,18 +1420,13 @@
 	 */						
 	if (nv->link_down_timeout == 0) {
 		ha->loop_down_abort_time =
-		    (LOOP_DOWN_TIME - ha->loop_down_timeout);
+		    (LOOP_DOWN_TIME - LOOP_DOWN_TIMEOUT);
 	} else {
 		ha->link_down_timeout =	 nv->link_down_timeout;
 		ha->loop_down_abort_time =
 		    (LOOP_DOWN_TIME - ha->link_down_timeout);
 	} 
 
-	ha->max_luns = MAX_LUNS;
-	ha->max_probe_luns = le16_to_cpu(nv->max_luns_per_target);
-	if (ha->max_probe_luns == 0)
-		ha->max_probe_luns = MIN_LUNS;
-
 	/*
 	 * Need enough time to try and get the port back.
 	 */
@@ -1457,16 +1443,6 @@
 	if (ql2xloginretrycount)
 		ha->login_retry_count = ql2xloginretrycount;
 
-	ha->binding_type = Bind;
-	if (ha->binding_type != BIND_BY_PORT_NAME &&
-	    ha->binding_type != BIND_BY_PORT_ID) {
-		qla_printk(KERN_WARNING, ha,
-		    "Invalid binding type specified (%d), "
-		    "defaulting to BIND_BY_PORT_NAME!!!\n", ha->binding_type);
-
-		ha->binding_type = BIND_BY_PORT_NAME;
-	}
-
 	icb->lun_enables = __constant_cpu_to_le16(0);
 	icb->command_resource_count = 0;
 	icb->immediate_notify_resource_count = 0;
@@ -1578,7 +1554,6 @@
 	 */
 	clear_bit(LOCAL_LOOP_UPDATE, &ha->dpc_flags);
 	clear_bit(RSCN_UPDATE, &ha->dpc_flags);
-	ha->mem_err = 0 ;
 
 	/* Determine what we need to do */
 	if (ha->current_topology == ISP_CFG_FL &&
@@ -2707,7 +2682,6 @@
 	rval = QLA_SUCCESS;
 
 	atomic_set(&ha->loop_state, LOOP_UPDATE);
-	qla2x00_stats.loop_resync++;
 	clear_bit(ISP_ABORT_RETRY, &ha->dpc_flags);
 	if (ha->flags.online) {
 		if (!(rval = qla2x00_fw_ready(ha))) {
@@ -2786,9 +2760,6 @@
 	if (ha->flags.online) {
 		ha->flags.online = 0;
 		clear_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
-		qla2x00_stats.ispAbort++;
-		ha->total_isp_aborts++;  /* used by ioctl */
-		ha->sns_retry_cnt = 0;
 
 		qla_printk(KERN_INFO, ha,
 		    "Performing ISP error recovery - ha= %p.\n", ha);
@@ -2810,8 +2781,6 @@
 			sp = ha->outstanding_cmds[cnt];
 			if (sp) {
 				ha->outstanding_cmds[cnt] = NULL;
-				if (ha->actthreads)
-					ha->actthreads--;
 				sp->flags = 0;
 				sp->cmd->result = DID_RESET << 16;
 				sp->cmd->host_scribble = (unsigned char *)NULL;
===== drivers/scsi/qla2xxx/qla_iocb.c 1.18 vs edited =====
--- 1.18/drivers/scsi/qla2xxx/qla_iocb.c	2005-04-15 17:24:01 +02:00
+++ edited/drivers/scsi/qla2xxx/qla_iocb.c	2005-04-18 16:29:02 +02:00
@@ -433,11 +433,8 @@
 	} else
 		ha->request_ring_ptr++;
 
-	ha->actthreads++;
-	ha->total_ios++;
 	sp->flags |= SRB_DMA_VALID;
 	sp->state = SRB_ACTIVE_STATE;
-	sp->u_start = jiffies;
 
 	/* Set chip new ring index. */
 	WRT_REG_WORD(ISP_REQ_Q_IN(ha, reg), ha->req_ring_index);
===== drivers/scsi/qla2xxx/qla_isr.c 1.24 vs edited =====
--- 1.24/drivers/scsi/qla2xxx/qla_isr.c	2005-04-13 17:45:53 +02:00
+++ edited/drivers/scsi/qla2xxx/qla_isr.c	2005-04-18 16:29:18 +02:00
@@ -91,9 +91,6 @@
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-	ha->last_irq_cpu = _smp_processor_id();
-	ha->total_isr_cnt++;
-
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
 		spin_lock_irqsave(&ha->mbx_reg_lock, flags);
@@ -200,9 +197,6 @@
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-	ha->last_irq_cpu = _smp_processor_id();
-	ha->total_isr_cnt++;
-
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
 		spin_lock_irqsave(&ha->mbx_reg_lock, flags);
@@ -417,7 +411,6 @@
 		/* Update AEN queue. */
 		qla2x00_enqueue_aen(ha, MBA_LIP_OCCURRED, NULL);
 
-		ha->total_lip_cnt++;
 		break;
 
 	case MBA_LOOP_UP:		/* Loop Up Event */
@@ -485,7 +478,6 @@
 		/* Update AEN queue. */
 		qla2x00_enqueue_aen(ha, MBA_LIP_RESET, NULL);
 
-		ha->total_lip_cnt++;
 		break;
 
 	case MBA_POINT_TO_POINT:	/* Point-to-Point */
@@ -695,14 +687,11 @@
 		/* Free outstanding command slot. */
 		ha->outstanding_cmds[index] = NULL;
 
-		if (ha->actthreads)
-			ha->actthreads--;
 		CMD_COMPL_STATUS(sp->cmd) = 0L;
 		CMD_SCSI_STATUS(sp->cmd) = 0L;
 
 		/* Save ISP completion status */
 		sp->cmd->result = DID_OK << 16;
-		sp->fo_retry_cnt = 0;
 		qla2x00_sp_compl(ha, sp);
 	} else {
 		DEBUG2(printk("scsi(%ld): Invalid ISP SCSI completion handle\n",
@@ -865,9 +854,6 @@
 		return;
 	}
 
-	if (ha->actthreads)
-		ha->actthreads--;
-
 	comp_status = le16_to_cpu(pkt->comp_status);
 	/* Mask of reserved bits 12-15, before we examine the scsi status */
 	scsi_status = le16_to_cpu(pkt->scsi_status) & SS_MASK;
@@ -1026,7 +1012,6 @@
 				    cp->request_bufflen));
 
 				cp->result = DID_BUS_BUSY << 16;
-				ha->dropped_frame_error_cnt++;
 				break;
 			}
 
@@ -1233,8 +1218,7 @@
 	if (sp) {
 		/* Free outstanding command slot. */
 		ha->outstanding_cmds[pkt->handle] = NULL;
-		if (ha->actthreads)
-			ha->actthreads--;
+
 		/* Bad payload or header */
 		if (pkt->entry_status &
 		    (RF_INV_E_ORDER | RF_INV_E_COUNT |
===== drivers/scsi/qla2xxx/qla_mbx.c 1.17 vs edited =====
--- 1.17/drivers/scsi/qla2xxx/qla_mbx.c	2005-04-13 17:45:53 +02:00
+++ edited/drivers/scsi/qla2xxx/qla_mbx.c	2005-04-18 16:37:09 +02:00
@@ -219,10 +219,8 @@
 		ha->flags.mbox_int = 0;
 		clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
 
-		if (ha->mailbox_out[0] != MBS_COMMAND_COMPLETE) {
-			qla2x00_stats.mboxerr++;
+		if (ha->mailbox_out[0] != MBS_COMMAND_COMPLETE)
 			rval = QLA_FUNCTION_FAILED;
-		}
 
 		/* Load return mailbox registers. */
 		iptr2 = mcp->mb;
@@ -249,8 +247,6 @@
 		qla2x00_dump_regs(ha);
 #endif
 
-		qla2x00_stats.mboxtout++;
-		ha->total_mbx_timeout++;
 		rval = QLA_FUNCTION_TIMEOUT;
 	}
 
===== drivers/scsi/qla2xxx/qla_os.c 1.59 vs edited =====
--- 1.59/drivers/scsi/qla2xxx/qla_os.c	2005-04-13 17:58:47 +02:00
+++ edited/drivers/scsi/qla2xxx/qla_os.c	2005-04-18 16:49:31 +02:00
@@ -36,27 +36,12 @@
 /*
  * SRB allocation cache
  */
-char srb_cachep_name[16];
-kmem_cache_t *srb_cachep;
-
-/*
- * Stats for all adpaters.
- */
-struct _qla2x00stats qla2x00_stats;
+static kmem_cache_t *srb_cachep;
 
 /*
  * Ioctl related information.
  */
-int num_hosts;
-int apiHBAInstance;
-
-/*
- * Module parameter information and variables
- */
-int ql2xmaxqdepth;
-module_param(ql2xmaxqdepth, int, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(ql2xmaxqdepth,
-		"Maximum queue depth to report for target devices.");
+static int num_hosts;
 
 int ql2xlogintimeout = 20;
 module_param(ql2xlogintimeout, int, S_IRUGO|S_IRUSR);
@@ -69,12 +54,6 @@
 		"Maximum number of command retries to a port that returns"
 		"a PORT-DOWN status.");
 
-int ql2xretrycount = 20;
-module_param(ql2xretrycount, int, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(ql2xretrycount,
-		"Maximum number of mid-layer retries allowed for a command.  "
-		"Default value is 20, ");
-
 int ql2xplogiabsentdevice;
 module_param(ql2xplogiabsentdevice, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xplogiabsentdevice,
@@ -95,25 +74,6 @@
 		"ZIO: Waiting time for Firmware before it generates an "
 		"interrupt to the host to notify completion of request.");
 
-int ConfigRequired;
-module_param(ConfigRequired, int, S_IRUGO|S_IRUSR);
-MODULE_PARM_DESC(ConfigRequired,
-		"If 1, then only configured devices passed in through the"
-		"ql2xopts parameter will be presented to the OS");
-
-int Bind = BIND_BY_PORT_NAME;
-module_param(Bind, int, S_IRUGO|S_IRUSR);
-MODULE_PARM_DESC(Bind,
-		"Target persistent binding method: "
-		"0 by Portname (default); 1 by PortID; 2 by Nodename. ");
-
-int ql2xsuspendcount = SUSPEND_COUNT;
-module_param(ql2xsuspendcount, int, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(ql2xsuspendcount,
-		"Number of 6-second suspend iterations to perform while a "
-		"target returns a <NOT READY> status.  Default is 10 "
-		"iterations.");
-
 int ql2xloginretrycount = 0;
 module_param(ql2xloginretrycount, int, S_IRUGO|S_IRUSR);
 MODULE_PARM_DESC(ql2xloginretrycount,
@@ -330,7 +290,6 @@
 	sp->fcport = fcport;
 	sp->cmd = cmd;
 	sp->flags = 0;
-	sp->err_id = 0;
 
 	CMD_SP(cmd) = (void *)sp;
 	cmd->scsi_done = done;
@@ -474,7 +433,6 @@
 
 	while ((!atomic_read(&ha->loop_down_timer) &&
 	    atomic_read(&ha->loop_state) == LOOP_DOWN) ||
-	    test_bit(CFG_ACTIVE, &ha->cfg_flags) ||
 	    atomic_read(&ha->loop_state) != LOOP_READY) {
 		msleep(1000);
 		if (time_after_eq(jiffies, loop_timeout)) {
@@ -1194,34 +1152,24 @@
 
 	spin_lock_init(&ha->hardware_lock);
 
-	/* 4.23 Initialize /proc/scsi/qla2x00 counters */
-	ha->actthreads = 0;
-	ha->qthreads   = 0;
-	ha->total_isr_cnt = 0;
-	ha->total_isp_aborts = 0;
-	ha->total_lip_cnt = 0;
-	ha->total_dev_errs = 0;
-	ha->total_ios = 0;
-	ha->total_bytes = 0;
-
 	ha->prev_topology = 0;
 	ha->ports = MAX_BUSES;
 
 	if (IS_QLA2100(ha)) {
-		ha->max_targets = MAX_TARGETS_2100;
+		host->max_id = MAX_TARGETS_2100;
 		ha->mbx_count = MAILBOX_REGISTER_COUNT_2100;
 		ha->request_q_length = REQUEST_ENTRY_CNT_2100;
 		ha->response_q_length = RESPONSE_ENTRY_CNT_2100;
 		ha->last_loop_id = SNS_LAST_LOOP_ID_2100;
 		host->sg_tablesize = 32;
 	} else if (IS_QLA2200(ha)) {
-		ha->max_targets = MAX_TARGETS_2200;
+		host->max_id = MAX_TARGETS_2200;
 		ha->mbx_count = MAILBOX_REGISTER_COUNT;
 		ha->request_q_length = REQUEST_ENTRY_CNT_2200;
 		ha->response_q_length = RESPONSE_ENTRY_CNT_2100;
 		ha->last_loop_id = SNS_LAST_LOOP_ID_2100;
 	} else /*if (IS_QLA2300(ha))*/ {
-		ha->max_targets = MAX_TARGETS_2200;
+		host->max_id = MAX_TARGETS_2200;
 		ha->mbx_count = MAILBOX_REGISTER_COUNT;
 		ha->request_q_length = REQUEST_ENTRY_CNT_2200;
 		ha->response_q_length = RESPONSE_ENTRY_CNT_2300;
@@ -1265,8 +1213,7 @@
 	host->unique_id = ha->instance;
 	host->max_cmd_len = MAX_CMDSZ;
 	host->max_channel = ha->ports - 1;
-	host->max_id = ha->max_targets;
-	host->max_lun = ha->max_luns;
+	host->max_lun = MAX_LUNS;
 	host->transportt = qla2xxx_transport_template;
 	if (scsi_add_host(host, &pdev->dev))
 		goto probe_alloc_failed;
@@ -2336,8 +2283,7 @@
 qla2x00_module_init(void)
 {
 	/* Allocate cache for SRBs. */
-	sprintf(srb_cachep_name, "qla2xxx_srbs");
-	srb_cachep = kmem_cache_create(srb_cachep_name, sizeof(srb_t), 0,
+	srb_cachep = kmem_cache_create("qla2xxx_srbs", sizeof(srb_t), 0,
 	    SLAB_HWCACHE_ALIGN, NULL, NULL);
 	if (srb_cachep == NULL) {
 		printk(KERN_ERR
@@ -2364,16 +2310,7 @@
 static void __exit
 qla2x00_module_exit(void)
 {
-	/* Free SRBs cache. */
-	if (srb_cachep != NULL) {
-		if (kmem_cache_destroy(srb_cachep) != 0) {
-			printk(KERN_ERR
-			    "qla2xxx: Unable to free SRB cache...Memory pools "
-			    "still active?\n");
-		}
-		srb_cachep = NULL;
-	}
-
+	kmem_cache_destroy(srb_cachep);
 	fc_release_transport(qla2xxx_transport_template);
 }
 
