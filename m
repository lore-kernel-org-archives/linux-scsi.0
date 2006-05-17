From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 08/15] qla2xxx: Drop unused driver cruft.
Date: Wed, 17 May 2006 15:09:22 -0700
Message-ID: <11479037572604-git-send-email-andrew.vasquez@qlogic.com>
References: <20060517220642.GF4126@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:10170 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1751220AbWEQWJX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 May 2006 18:09:23 -0400
In-Reply-To: <20060517220642.GF4126@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

- structure definitions.
- structure members.
- #define's.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

6898e30b9a5aea1ffa7ff291b744c174d182b5e5
 drivers/scsi/qla2xxx/qla_dbg.c      |    1 
 drivers/scsi/qla2xxx/qla_def.h      |  116 -----------------------------------
 drivers/scsi/qla2xxx/qla_gbl.h      |    2 -
 drivers/scsi/qla2xxx/qla_init.c     |   17 -----
 drivers/scsi/qla2xxx/qla_iocb.c     |    2 -
 drivers/scsi/qla2xxx/qla_isr.c      |    5 +-
 drivers/scsi/qla2xxx/qla_os.c       |   30 +--------
 drivers/scsi/qla2xxx/qla_rscn.c     |    1 
 drivers/scsi/qla2xxx/qla_settings.h |    1 
 9 files changed, 5 insertions(+), 170 deletions(-)

6898e30b9a5aea1ffa7ff291b744c174d182b5e5
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 2d9b12f..e8120fb 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -1995,7 +1995,6 @@ qla2x00_print_scsi_cmd(struct scsi_cmnd 
 		return;
 
 	printk("  sp flags=0x%x\n", sp->flags);
-	printk("  state=%d\n", sp->state);
 }
 
 void
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 4881242..4bd67e9 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -189,22 +189,13 @@ typedef struct srb {
 
 	struct scsi_cmnd *cmd;		/* Linux SCSI command pkt */
 
-	struct timer_list timer;	/* Command timer */
-	atomic_t ref_count;	/* Reference count for this structure */
 	uint16_t flags;
 
-	/* Request state */
-	uint16_t state;
-
 	/* Single transfer DMA context */
 	dma_addr_t dma_handle;
 
 	uint32_t request_sense_length;
 	uint8_t *request_sense_ptr;
-
-	/* SRB magic number */
-	uint16_t magic;
-#define SRB_MAGIC       0x10CB
 } srb_t;
 
 /*
@@ -226,21 +217,6 @@ #define SRB_IOCTL		BIT_10	/* IOCTL comma
 #define SRB_TAPE		BIT_11	/* FCP2 (Tape) command. */
 
 /*
- * SRB state definitions
- */
-#define SRB_FREE_STATE		0	/*   returned back */
-#define SRB_PENDING_STATE	1	/*   queued in LUN Q */
-#define SRB_ACTIVE_STATE	2	/*   in Active Array */
-#define SRB_DONE_STATE		3	/*   queued in Done Queue */
-#define SRB_RETRY_STATE		4	/*   in Retry Queue */
-#define SRB_SUSPENDED_STATE	5	/*   in suspended state */
-#define SRB_NO_QUEUE_STATE	6	/*   is in between states */
-#define SRB_ACTIVE_TIMEOUT_STATE 7	/*   in Active Array but timed out */
-#define SRB_FAILOVER_STATE	8	/*   in Failover Queue */
-#define SRB_SCSI_RETRY_STATE	9	/*   in Scsi Retry Queue */
-
-
-/*
  * ISP I/O Register Set structure definitions.
  */
 struct device_reg_2xxx {
@@ -1516,62 +1492,6 @@ typedef struct {
 } sw_info_t;
 
 /*
- * Inquiry command structure.
- */
-#define INQ_DATA_SIZE	36
-
-/*
- * Inquiry mailbox IOCB packet definition.
- */
-typedef struct {
-	union {
-		cmd_a64_entry_t cmd;
-		sts_entry_t rsp;
-		struct cmd_type_7 cmd24;
-		struct sts_entry_24xx rsp24;
-	} p;
-	uint8_t inq[INQ_DATA_SIZE];
-} inq_cmd_rsp_t;
-
-/*
- * Report LUN command structure.
- */
-#define CHAR_TO_SHORT(a, b)	(uint16_t)((uint8_t)b << 8 | (uint8_t)a)
-
-typedef struct {
-	uint32_t len;
-	uint32_t rsrv;
-} rpt_hdr_t;
-
-typedef struct {
-	struct {
-		uint8_t b : 6;
-		uint8_t address_method : 2;
-	} msb;
-	uint8_t lsb;
-	uint8_t unused[6];
-} rpt_lun_t;
-
-typedef struct {
-	rpt_hdr_t hdr;
-	rpt_lun_t lst[MAX_LUNS];
-} rpt_lun_lst_t;
-
-/*
- * Report Lun mailbox IOCB packet definition.
- */
-typedef struct {
-	union {
-		cmd_a64_entry_t cmd;
-		sts_entry_t rsp;
-		struct cmd_type_7 cmd24;
-		struct sts_entry_24xx rsp24;
-	} p;
-	rpt_lun_lst_t list;
-} rpt_lun_cmd_rsp_t;
-
-
-/*
  * Fibre channel port type.
  */
  typedef enum {
@@ -1589,7 +1509,6 @@ typedef struct {
 typedef struct fc_port {
 	struct list_head list;
 	struct scsi_qla_host *ha;
-	struct scsi_qla_host *vis_ha;	/* only used when suspending lun */
 
 	uint8_t node_name[WWN_SIZE];
 	uint8_t port_name[WWN_SIZE];
@@ -1610,17 +1529,9 @@ typedef struct fc_port {
 	int login_retry;
 	atomic_t port_down_timer;
 
-	uint8_t device_type;
-	uint8_t unused;
-
-	uint8_t mp_byte;		/* multi-path byte (not used) */
-    	uint8_t cur_path;		/* current path id */
-
 	spinlock_t rport_lock;
 	struct fc_rport *rport, *drport;
 	u32 supported_classes;
-	struct work_struct rport_add_work;
-	struct work_struct rport_del_work;
 } fc_port_t;
 
 /*
@@ -2305,9 +2216,6 @@ #define MIN_IOBASE_LEN		0x100
 	uint32_t	current_outstanding_cmd;
 	srb_t		*status_srb;	/* Status continuation entry. */
 
-	uint16_t           revision;
-	uint8_t           ports;
-
 	/* ISP configuration data. */
 	uint16_t	loop_id;		/* Host adapter loop id */
 	uint16_t	fb_rev;
@@ -2397,9 +2305,6 @@ #define P2P_LOOP  3
 	struct gid_list_info *gid_list;
 	int		gid_list_info_size;
 
-	dma_addr_t	rlc_rsp_dma;
-	rpt_lun_cmd_rsp_t *rlc_rsp;
-
 	/* Small DMA pool allocations -- maximum 256 bytes in length. */
 #define DMA_POOL_SIZE	256
 	struct dma_pool *s_dma_pool;
@@ -2505,8 +2410,6 @@ #define LOOP_TRANSITION(ha) \
 	 test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags) || \
 	 atomic_read(&ha->loop_state) == LOOP_DOWN)
 
-#define TGT_Q(ha, t) (ha->otgt[t])
-
 #define to_qla_host(x)		((scsi_qla_host_t *) (x)->hostdata)
 
 #define qla_printk(level, ha, format, arg...) \
@@ -2539,19 +2442,6 @@ #define QLA_BUSY			0x107
 #define QLA_RSCNS_HANDLED		0x108
 #define QLA_ALREADY_REGISTERED		0x109
 
-/*
-* Stat info for all adpaters
-*/
-struct _qla2x00stats  {
-        unsigned long   mboxtout;            /* mailbox timeouts */
-        unsigned long   mboxerr;             /* mailbox errors */
-        unsigned long   ispAbort;            /* ISP aborts */
-        unsigned long   debugNo;
-        unsigned long   loop_resync;
-        unsigned long   outarray_full;
-        unsigned long   retry_q_cnt;
-};
-
 #define NVRAM_DELAY()		udelay(10)
 
 #define INVALID_HANDLE	(MAX_OUTSTANDING_COMMANDS+1)
@@ -2567,12 +2457,6 @@ #include "qla_gbl.h"
 #include "qla_dbg.h"
 #include "qla_inline.h"
 
-/*
-* String arrays
-*/
-#define LINESIZE    256
-#define MAXARGS      26
-
 #define CMD_SP(Cmnd)		((Cmnd)->SCp.ptr)
 #define CMD_COMPL_STATUS(Cmnd)  ((Cmnd)->SCp.this_residual)
 #define CMD_RESID_LEN(Cmnd)	((Cmnd)->SCp.buffers_residual)
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 91e83e2..26d1181 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -70,8 +70,6 @@ extern void qla2x00_sp_compl(scsi_qla_ho
 
 extern char *qla2x00_get_fw_version_str(struct scsi_qla_host *, char *);
 
-extern void qla2x00_cmd_timeout(srb_t *);
-
 extern void qla2x00_mark_device_lost(scsi_qla_host_t *, fc_port_t *, int, int);
 extern void qla2x00_mark_all_devices_lost(scsi_qla_host_t *, int);
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index b1b20f4..7e18b9c 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -194,7 +194,6 @@ qla2100_pci_config(scsi_qla_host_t *ha)
 	mwi = 0;
 	if (pci_set_mwi(ha->pdev))
 		mwi = PCI_COMMAND_INVALIDATE;
-	pci_read_config_word(ha->pdev, PCI_REVISION_ID, &ha->revision);
 
 	pci_read_config_word(ha->pdev, PCI_COMMAND, &w);
 	w |= mwi | (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
@@ -232,7 +231,6 @@ qla2300_pci_config(scsi_qla_host_t *ha)
 	mwi = 0;
 	if (pci_set_mwi(ha->pdev))
 		mwi = PCI_COMMAND_INVALIDATE;
-	pci_read_config_word(ha->pdev, PCI_REVISION_ID, &ha->revision);
 
 	pci_read_config_word(ha->pdev, PCI_COMMAND, &w);
 	w |= mwi | (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
@@ -320,7 +318,6 @@ qla24xx_pci_config(scsi_qla_host_t *ha)
 	mwi = 0;
 	if (pci_set_mwi(ha->pdev))
 		mwi = PCI_COMMAND_INVALIDATE;
-	pci_read_config_word(ha->pdev, PCI_REVISION_ID, &ha->revision);
 
 	pci_read_config_word(ha->pdev, PCI_COMMAND, &w);
 	w |= mwi | (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
@@ -1675,14 +1672,6 @@ #endif
 }
 
 static void
-qla2x00_rport_add(void *data)
-{
-	fc_port_t *fcport = data;
-
-	qla2x00_reg_remote_port(fcport->ha, fcport);
-}
-
-static void
 qla2x00_rport_del(void *data)
 {
 	fc_port_t *fcport = data;
@@ -1724,8 +1713,6 @@ qla2x00_alloc_fcport(scsi_qla_host_t *ha
 	fcport->flags = FCF_RLC_SUPPORT;
 	fcport->supported_classes = FC_COS_UNSPECIFIED;
 	spin_lock_init(&fcport->rport_lock);
-	INIT_WORK(&fcport->rport_add_work, qla2x00_rport_add, fcport);
-	INIT_WORK(&fcport->rport_del_work, qla2x00_rport_del, fcport);
 
 	return (fcport);
 }
@@ -2048,10 +2035,6 @@ qla2x00_update_fcport(scsi_qla_host_t *h
 	    PORT_RETRY_TIME);
 	fcport->flags &= ~FCF_LOGIN_NEEDED;
 
-	if (fcport->port_type == FCT_INITIATOR ||
-	    fcport->port_type == FCT_BROADCAST)
-		fcport->device_type = TYPE_PROCESSOR;
-
 	atomic_set(&fcport->state, FCS_ONLINE);
 
 	if (ha->flags.init_done)
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 8f0f4a2..8c769cf 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -408,7 +408,6 @@ qla2x00_start_scsi(srb_t *sp)
 		ha->request_ring_ptr++;
 
 	sp->flags |= SRB_DMA_VALID;
-	sp->state = SRB_ACTIVE_STATE;
 
 	/* Set chip new ring index. */
 	WRT_REG_WORD(ISP_REQ_Q_IN(ha, reg), ha->req_ring_index);
@@ -838,7 +837,6 @@ qla24xx_start_scsi(srb_t *sp)
 		ha->request_ring_ptr++;
 
 	sp->flags |= SRB_DMA_VALID;
-	sp->state = SRB_ACTIVE_STATE;
 
 	/* Set chip new ring index. */
 	WRT_REG_DWORD(&reg->req_q_in, ha->req_ring_index);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 40325ec..39b5082 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -844,8 +844,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 	cp = sp->cmd;
 	if (cp == NULL) {
 		DEBUG2(printk("scsi(%ld): Command already returned back to OS "
-		    "pkt->handle=%d sp=%p sp->state:%d\n",
-		    ha->host_no, sts->handle, sp, sp->state));
+		    "pkt->handle=%d sp=%p.\n", ha->host_no, sts->handle, sp));
 		qla_printk(KERN_WARNING, ha,
 		    "Command is NULL: already returned to OS (sp=%p)\n", sp);
 
@@ -1189,7 +1188,7 @@ qla2x00_status_cont_entry(scsi_qla_host_
 		cp = sp->cmd;
 		if (cp == NULL) {
 			DEBUG2(printk("%s(): Cmd already returned back to OS "
-			    "sp=%p sp->state:%d\n", __func__, sp, sp->state));
+			    "sp=%p.\n", __func__, sp));
 			qla_printk(KERN_INFO, ha,
 			    "cmd is NULL: already returned to OS (sp=%p)\n",
 			    sp);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 2c608b3..e5cd549 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -340,7 +340,6 @@ qla2x00_get_new_sp(scsi_qla_host_t *ha, 
 	if (!sp)
 		return sp;
 
-	atomic_set(&sp->ref_count, 1);
 	sp->ha = ha;
 	sp->fcport = fcport;
 	sp->cmd = cmd;
@@ -636,9 +635,8 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 		if (sp->cmd != cmd)
 			continue;
 
-		DEBUG2(printk("%s(%ld): aborting sp %p from RISC. pid=%ld "
-		    "sp->state=%x\n", __func__, ha->host_no, sp, serial,
-		    sp->state));
+		DEBUG2(printk("%s(%ld): aborting sp %p from RISC. pid=%ld.\n",
+		    __func__, ha->host_no, sp, serial));
 		DEBUG3(qla2x00_print_scsi_cmd(cmd);)
 
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -1380,7 +1378,6 @@ int qla2x00_probe_one(struct pci_dev *pd
 	spin_lock_init(&ha->hardware_lock);
 
 	ha->prev_topology = 0;
-	ha->ports = MAX_BUSES;
 	ha->init_cb_size = sizeof(init_cb_t);
 	ha->mgmt_svr_loop_id = MANAGEMENT_SERVER;
 	ha->link_data_rate = LDR_UNKNOWN;
@@ -1547,7 +1544,7 @@ #endif
 	host->cmd_per_lun = 3;
 	host->unique_id = ha->instance;
 	host->max_cmd_len = MAX_CMDSZ;
-	host->max_channel = ha->ports - 1;
+	host->max_channel = MAX_BUSES - 1;
 	host->max_lun = MAX_LUNS;
 	host->transportt = qla2xxx_transport_template;
 
@@ -1888,18 +1885,6 @@ qla2x00_mem_alloc(scsi_qla_host_t *ha)
 			continue;
 		}
 
-		ha->rlc_rsp = dma_alloc_coherent(&ha->pdev->dev,
-		    sizeof(rpt_lun_cmd_rsp_t), &ha->rlc_rsp_dma, GFP_KERNEL);
-		if (ha->rlc_rsp == NULL) {
-			qla_printk(KERN_WARNING, ha,
-				"Memory Allocation failed - rlc");
-
-			qla2x00_mem_free(ha);
-			msleep(100);
-
-			continue;
-		}
-
 		snprintf(name, sizeof(name), "qla2xxx_%ld", ha->host_no);
 		ha->s_dma_pool = dma_pool_create(name, &ha->pdev->dev,
 		    DMA_POOL_SIZE, 8, 0);
@@ -2075,11 +2060,6 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
 	if (ha->s_dma_pool)
 		dma_pool_destroy(ha->s_dma_pool);
 
-	if (ha->rlc_rsp)
-		dma_free_coherent(&ha->pdev->dev,
-		    sizeof(rpt_lun_cmd_rsp_t), ha->rlc_rsp,
-		    ha->rlc_rsp_dma);
-
 	if (ha->gid_list)
 		dma_free_coherent(&ha->pdev->dev, GID_LIST_SIZE, ha->gid_list,
 		    ha->gid_list_dma);
@@ -2107,8 +2087,6 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
 
 	ha->s_dma_pool = NULL;
 
-	ha->rlc_rsp = NULL;
-	ha->rlc_rsp_dma = 0;
 	ha->gid_list = NULL;
 	ha->gid_list_dma = 0;
 
@@ -2152,8 +2130,6 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
  *
  * Context:
  *      Kernel context.
- *
- * Note: Sets the ref_count for non Null sp to one.
  */
 static int
 qla2x00_allocate_sp_pool(scsi_qla_host_t *ha)
diff --git a/drivers/scsi/qla2xxx/qla_rscn.c b/drivers/scsi/qla2xxx/qla_rscn.c
index b70bebe..33e287b 100644
--- a/drivers/scsi/qla2xxx/qla_rscn.c
+++ b/drivers/scsi/qla2xxx/qla_rscn.c
@@ -318,7 +318,6 @@ qla2x00_update_login_fcport(scsi_qla_hos
 	fcport->flags &= ~FCF_FAILOVER_NEEDED;
 	fcport->iodesc_idx_sent = IODESC_INVALID_INDEX;
 	atomic_set(&fcport->state, FCS_ONLINE);
-	schedule_work(&fcport->rport_add_work);
 }
 
 
diff --git a/drivers/scsi/qla2xxx/qla_settings.h b/drivers/scsi/qla2xxx/qla_settings.h
index 363205c..249e4d9 100644
--- a/drivers/scsi/qla2xxx/qla_settings.h
+++ b/drivers/scsi/qla2xxx/qla_settings.h
@@ -16,7 +16,6 @@ #define MAX_RETRIES_OF_ISP_ABORT	5
 
 /* Max time to wait for the loop to be in LOOP_READY state */
 #define MAX_LOOP_TIMEOUT	(60 * 5)
-#define EH_ACTIVE		1	/* Error handler active */
 
 /*
  * Some vendor subsystems do not recover properly after a device reset.  Define
-- 
1.3.3.g63df


