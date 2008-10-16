From: Anirban Chakraborty <anirban@qlogic.com>
Subject: [PATCH 1/5] qla2xxx: Code Refactoring
Date: Wed, 15 Oct 2008 22:44:53 -0700 (PDT)
Message-ID: <alpine.OSX.1.00.0810152228100.24642@ac-mac.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:41949 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbYJPF7l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Oct 2008 01:59:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, James.Smart@emulex.com, linux-scsi@vger.kernel.org
Cc: linux-driver@qlogic.com

Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h     |  525 +++++++++++++++++++-----------------
 drivers/scsi/qla2xxx/qla_gbl.h     |   13 +-
 drivers/scsi/qla2xxx/qla_inline.h  |   27 +--
 drivers/scsi/qla2xxx/qla_version.h |    4 +-
 4 files changed, 299 insertions(+), 270 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 83c8192..6dc45f0 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -185,7 +185,7 @@
  * SCSI Request Block
  */
 typedef struct srb {
-	struct scsi_qla_host *ha;	/* HA the SP is queued on */
+	struct scsi_qla_host *vha;	/* HA the SP is queued on */
 	struct fc_port *fcport;
 
 	struct scsi_cmnd *cmd;		/* Linux SCSI command pkt */
@@ -1524,7 +1524,7 @@ typedef struct {
  */
 typedef struct fc_port {
 	struct list_head list;
-	struct scsi_qla_host *ha;
+	struct scsi_qla_host *vha;
 
 	uint8_t node_name[WWN_SIZE];
 	uint8_t port_name[WWN_SIZE];
@@ -1550,7 +1550,6 @@ typedef struct fc_port {
 	unsigned long last_queue_full;
 	unsigned long last_ramp_up;
 
-	struct list_head vp_fcport;
 	uint16_t vp_idx;
 } fc_port_t;
 
@@ -2037,6 +2036,8 @@ typedef struct vport_params {
 #define VP_RET_CODE_NO_MEM		5
 #define VP_RET_CODE_NOT_FOUND		6
 
+struct qla_hw_data;
+
 /*
  * ISP operations
  */
@@ -2055,8 +2056,8 @@ struct isp_operations {
 	char * (*fw_version_str) (struct scsi_qla_host *, char *);
 
 	irq_handler_t intr_handler;
-	void (*enable_intrs) (struct scsi_qla_host *);
-	void (*disable_intrs) (struct scsi_qla_host *);
+	void (*enable_intrs) (struct qla_hw_data *);
+	void (*disable_intrs) (struct qla_hw_data *);
 
 	int (*abort_command) (struct scsi_qla_host *, srb_t *);
 	int (*target_reset) (struct fc_port *, unsigned int);
@@ -2089,6 +2090,7 @@ struct isp_operations {
 		uint32_t);
 
 	int (*get_flash_version) (struct scsi_qla_host *, void *);
+	int (*start_scsi) (srb_t *);
 };
 
 /* MSI-X Support *************************************************************/
@@ -2160,208 +2162,108 @@ struct qla_statistics {
 	uint64_t output_bytes;
 };
 
-/*
- * Linux Host Adapter structure
- */
-typedef struct scsi_qla_host {
-	struct list_head list;
+/* Response queue data structure */
+struct rsp_que {
+	dma_addr_t  dma;
+	response_t *ring;
+	response_t *ring_ptr;
+	uint16_t  ring_index;
+	uint16_t  out_ptr;
+	uint16_t  length;
+	uint16_t  options;
+	uint16_t  msix_vector;
+	uint16_t  rid;
+	struct qla_hw_data *hw;
+};
 
-	/* Commonly used flags and state information. */
-	struct Scsi_Host *host;
-	struct pci_dev	*pdev;
+/* Request queue data structure */
+struct req_que {
+	dma_addr_t  dma;
+	request_t *ring;
+	request_t *ring_ptr;
+	uint16_t  ring_index;
+	uint16_t  in_ptr;
+	uint16_t  cnt;
+	uint16_t  length;
+	uint16_t  options;
+	uint16_t  rid;
+	uint16_t  qos;
+	uint16_t  vp_idx;
+	struct rsp_que *asso_que;
+	/* Outstandings ISP commands. */
+	srb_t *outstanding_cmds[MAX_OUTSTANDING_COMMANDS];
+	uint32_t current_outstanding_cmd;
+	int max_q_depth;
+};
 
-	unsigned long	host_no;
+/*
+ * Qlogic host adapter specific data structure.
+*/
+struct qla_hw_data {
+	struct pci_dev  *pdev;
+	/* SRB cache. */
+#define SRB_MIN_REQ     128
+	mempool_t       *srb_mempool;
 
 	volatile struct {
-		uint32_t	init_done		:1;
-		uint32_t	online			:1;
 		uint32_t	mbox_int		:1;
 		uint32_t	mbox_busy		:1;
-		uint32_t	rscn_queue_overflow	:1;
-		uint32_t	reset_active		:1;
-
-		uint32_t	management_server_logged_in :1;
-                uint32_t	process_response_queue	:1;
 
 		uint32_t	disable_risc_code_load	:1;
 		uint32_t	enable_64bit_addressing	:1;
 		uint32_t	enable_lip_reset	:1;
-		uint32_t	enable_lip_full_login	:1;
 		uint32_t	enable_target_reset	:1;
+		uint32_t	enable_lip_full_login	:1;
 		uint32_t	enable_led_scheme	:1;
 		uint32_t	inta_enabled		:1;
 		uint32_t	msi_enabled		:1;
 		uint32_t	msix_enabled		:1;
 		uint32_t	disable_serdes		:1;
 		uint32_t	gpsc_supported		:1;
-		uint32_t        vsan_enabled            :1;
+		uint32_t	vsan_enabled		:1;
 		uint32_t	npiv_supported		:1;
 		uint32_t	fce_enabled		:1;
-		uint32_t	hw_event_marker_found	:1;
+		uint32_t	hw_event_marker_found:1;
 	} flags;
 
-	atomic_t	loop_state;
-#define LOOP_TIMEOUT	1
-#define LOOP_DOWN	2
-#define LOOP_UP		3
-#define LOOP_UPDATE	4
-#define LOOP_READY	5
-#define LOOP_DEAD	6
-
-	unsigned long   dpc_flags;
-#define	RESET_MARKER_NEEDED	0	/* Send marker to ISP. */
-#define	RESET_ACTIVE		1
-#define	ISP_ABORT_NEEDED	2	/* Initiate ISP abort. */
-#define	ABORT_ISP_ACTIVE	3	/* ISP abort in progress. */
-#define	LOOP_RESYNC_NEEDED	4	/* Device Resync needed. */
-#define	LOOP_RESYNC_ACTIVE	5
-#define LOCAL_LOOP_UPDATE       6	/* Perform a local loop update. */
-#define RSCN_UPDATE             7	/* Perform an RSCN update. */
-#define MAILBOX_RETRY           8
-#define ISP_RESET_NEEDED        9	/* Initiate a ISP reset. */
-#define FAILOVER_EVENT_NEEDED   10
-#define FAILOVER_EVENT		11
-#define FAILOVER_NEEDED   	12
-#define SCSI_RESTART_NEEDED	13	/* Processes SCSI retry queue. */
-#define PORT_RESTART_NEEDED	14	/* Processes Retry queue. */
-#define RESTART_QUEUES_NEEDED	15	/* Restarts the Lun queue. */
-#define ABORT_QUEUES_NEEDED	16
-#define RELOGIN_NEEDED	        17
-#define LOGIN_RETRY_NEEDED	18	/* Initiate required fabric logins. */
-#define REGISTER_FC4_NEEDED	19	/* SNS FC4 registration required. */
-#define ISP_ABORT_RETRY         20      /* ISP aborted. */
-#define FCPORT_RESCAN_NEEDED	21      /* IO descriptor processing needed */
-#define IODESC_PROCESS_NEEDED	22      /* IO descriptor processing needed */
-#define IOCTL_ERROR_RECOVERY	23
-#define LOOP_RESET_NEEDED	24
-#define BEACON_BLINK_NEEDED	25
-#define REGISTER_FDMI_NEEDED	26
-#define FCPORT_UPDATE_NEEDED	27
-#define VP_DPC_NEEDED		28	/* wake up for VP dpc handling */
-#define UNLOADING		29
-#define NPIV_CONFIG_NEEDED	30
-
-	uint32_t	device_flags;
-#define DFLG_LOCAL_DEVICES		BIT_0
-#define DFLG_RETRY_LOCAL_DEVICES	BIT_1
-#define DFLG_FABRIC_DEVICES		BIT_2
-#define	SWITCH_FOUND			BIT_3
-#define	DFLG_NO_CABLE			BIT_4
-
-#define PCI_DEVICE_ID_QLOGIC_ISP2532	0x2532
-#define PCI_DEVICE_ID_QLOGIC_ISP8432	0x8432
-	uint32_t	device_type;
-#define DT_ISP2100			BIT_0
-#define DT_ISP2200			BIT_1
-#define DT_ISP2300			BIT_2
-#define DT_ISP2312			BIT_3
-#define DT_ISP2322			BIT_4
-#define DT_ISP6312			BIT_5
-#define DT_ISP6322			BIT_6
-#define DT_ISP2422			BIT_7
-#define DT_ISP2432			BIT_8
-#define DT_ISP5422			BIT_9
-#define DT_ISP5432			BIT_10
-#define DT_ISP2532			BIT_11
-#define DT_ISP8432			BIT_12
-#define DT_ISP_LAST			(DT_ISP8432 << 1)
-
-#define DT_IIDMA			BIT_26
-#define DT_FWI2				BIT_27
-#define DT_ZIO_SUPPORTED		BIT_28
-#define DT_OEM_001			BIT_29
-#define DT_ISP2200A			BIT_30
-#define DT_EXTENDED_IDS			BIT_31
-
-#define DT_MASK(ha)	((ha)->device_type & (DT_ISP_LAST - 1))
-#define IS_QLA2100(ha)	(DT_MASK(ha) & DT_ISP2100)
-#define IS_QLA2200(ha)	(DT_MASK(ha) & DT_ISP2200)
-#define IS_QLA2300(ha)	(DT_MASK(ha) & DT_ISP2300)
-#define IS_QLA2312(ha)	(DT_MASK(ha) & DT_ISP2312)
-#define IS_QLA2322(ha)	(DT_MASK(ha) & DT_ISP2322)
-#define IS_QLA6312(ha)	(DT_MASK(ha) & DT_ISP6312)
-#define IS_QLA6322(ha)	(DT_MASK(ha) & DT_ISP6322)
-#define IS_QLA2422(ha)	(DT_MASK(ha) & DT_ISP2422)
-#define IS_QLA2432(ha)	(DT_MASK(ha) & DT_ISP2432)
-#define IS_QLA5422(ha)	(DT_MASK(ha) & DT_ISP5422)
-#define IS_QLA5432(ha)	(DT_MASK(ha) & DT_ISP5432)
-#define IS_QLA2532(ha)	(DT_MASK(ha) & DT_ISP2532)
-#define IS_QLA8432(ha)	(DT_MASK(ha) & DT_ISP8432)
-
-#define IS_QLA23XX(ha)	(IS_QLA2300(ha) || IS_QLA2312(ha) || IS_QLA2322(ha) || \
-    			 IS_QLA6312(ha) || IS_QLA6322(ha))
-#define IS_QLA24XX(ha)	(IS_QLA2422(ha) || IS_QLA2432(ha))
-#define IS_QLA54XX(ha)	(IS_QLA5422(ha) || IS_QLA5432(ha))
-#define IS_QLA25XX(ha)	(IS_QLA2532(ha))
-#define IS_QLA84XX(ha)	(IS_QLA8432(ha))
-#define IS_QLA24XX_TYPE(ha)	(IS_QLA24XX(ha) || IS_QLA54XX(ha) || \
-			IS_QLA84XX(ha))
-
-#define IS_IIDMA_CAPABLE(ha)	((ha)->device_type & DT_IIDMA)
-#define IS_FWI2_CAPABLE(ha)	((ha)->device_type & DT_FWI2)
-#define IS_ZIO_SUPPORTED(ha)	((ha)->device_type & DT_ZIO_SUPPORTED)
-#define IS_OEM_001(ha)		((ha)->device_type & DT_OEM_001)
-#define HAS_EXTENDED_IDS(ha)	((ha)->device_type & DT_EXTENDED_IDS)
-
-	/* SRB cache. */
-#define SRB_MIN_REQ	128
-	mempool_t	*srb_mempool;
-
 	/* This spinlock is used to protect "io transactions", you must
-	 * acquire it before doing any IO to the card, eg with RD_REG*() and
-	 * WRT_REG*() for the duration of your entire commandtransaction.
-	 *
-	 * This spinlock is of lower priority than the io request lock.
-	 */
-
-	spinlock_t		hardware_lock ____cacheline_aligned;
+	* acquire it before doing any IO to the card, eg with RD_REG*() and
+	* WRT_REG*() for the duration of your entire commandtransaction.
+	*
+	* This spinlock is of lower priority than the io request lock.
+	*/
 
+	spinlock_t	hardware_lock ____cacheline_aligned;
 	int		bars;
 	int		mem_only;
-	device_reg_t __iomem *iobase;		/* Base I/O address */
+	device_reg_t __iomem *iobase;           /* Base I/O address */
 	resource_size_t pio_address;
-#define MIN_IOBASE_LEN		0x100
-
-	/* ISP ring lock, rings, and indexes */
-	dma_addr_t	request_dma;        /* Physical address. */
-	request_t       *request_ring;      /* Base virtual address */
-	request_t       *request_ring_ptr;  /* Current address. */
-	uint16_t        req_ring_index;     /* Current index. */
-	uint16_t        req_q_cnt;          /* Number of available entries. */
-	uint16_t	request_q_length;
-
-	dma_addr_t	response_dma;       /* Physical address. */
-	response_t      *response_ring;     /* Base virtual address */
-	response_t      *response_ring_ptr; /* Current address. */
-	uint16_t        rsp_ring_index;     /* Current index. */
-	uint16_t	response_q_length;
 
-	struct isp_operations *isp_ops;
+#define MIN_IOBASE_LEN          0x100
+	struct req_que *req;
+	struct rsp_que *rsp;
 
-	/* Outstandings ISP commands. */
-	srb_t		*outstanding_cmds[MAX_OUTSTANDING_COMMANDS];
-	uint32_t	current_outstanding_cmd;
-	srb_t		*status_srb;	/* Status continuation entry. */
+	uint16_t        switch_cap;
+#define FLOGI_SEQ_DEL           BIT_8
+#define FLOGI_MID_SUPPORT       BIT_10
+#define FLOGI_VSAN_SUPPORT      BIT_12
+#define FLOGI_SP_SUPPORT        BIT_13
+	/* Timeout timers. */
+	uint8_t 	loop_down_abort_time;    /* port down timer */
+	atomic_t	loop_down_timer;         /* loop down timer */
+	uint8_t		link_down_timeout;       /* link down timeout */
+	uint16_t	max_loop_id;
 
-	/* ISP configuration data. */
-	uint16_t	loop_id;		/* Host adapter loop id */
-	uint16_t	switch_cap;
-#define FLOGI_SEQ_DEL		BIT_8
-#define FLOGI_MID_SUPPORT	BIT_10
-#define FLOGI_VSAN_SUPPORT	BIT_12
-#define FLOGI_SP_SUPPORT	BIT_13
 	uint16_t	fb_rev;
-
-	port_id_t	d_id;			/* Host adapter port id */
 	uint16_t	max_public_loop_ids;
-	uint16_t	min_external_loopid;	/* First external loop Id */
+	uint16_t	min_external_loopid;    /* First external loop Id */
 
 #define PORT_SPEED_UNKNOWN 0xFFFF
-#define PORT_SPEED_1GB	0x00
-#define PORT_SPEED_2GB	0x01
-#define PORT_SPEED_4GB	0x03
-#define PORT_SPEED_8GB	0x04
-	uint16_t	link_data_rate;		/* F/W operating speed */
+#define PORT_SPEED_1GB  0x00
+#define PORT_SPEED_2GB  0x01
+#define PORT_SPEED_4GB  0x03
+#define PORT_SPEED_8GB  0x04
+	uint16_t	link_data_rate;         /* F/W operating speed */
 
 	uint8_t		current_topology;
 	uint8_t		prev_topology;
@@ -2370,15 +2272,69 @@ typedef struct scsi_qla_host {
 #define ISP_CFG_FL	4
 #define ISP_CFG_F	8
 
-	uint8_t		operating_mode;		/* F/W operating mode */
+	uint8_t		operating_mode;         /* F/W operating mode */
 #define LOOP      0
 #define P2P       1
 #define LOOP_P2P  2
 #define P2P_LOOP  3
-
-        uint8_t		marker_needed;
-
 	uint8_t		interrupts_on;
+	uint32_t	isp_abort_cnt;
+
+#define PCI_DEVICE_ID_QLOGIC_ISP2532    0x2532
+#define PCI_DEVICE_ID_QLOGIC_ISP8432    0x8432
+	uint32_t	device_type;
+#define DT_ISP2100                      BIT_0
+#define DT_ISP2200                      BIT_1
+#define DT_ISP2300                      BIT_2
+#define DT_ISP2312                      BIT_3
+#define DT_ISP2322                      BIT_4
+#define DT_ISP6312                      BIT_5
+#define DT_ISP6322                      BIT_6
+#define DT_ISP2422                      BIT_7
+#define DT_ISP2432                      BIT_8
+#define DT_ISP5422                      BIT_9
+#define DT_ISP5432                      BIT_10
+#define DT_ISP2532                      BIT_11
+#define DT_ISP8432                      BIT_12
+#define DT_ISP_LAST                     (DT_ISP8432 << 1)
+
+#define DT_IIDMA                        BIT_26
+#define DT_FWI2                         BIT_27
+#define DT_ZIO_SUPPORTED                BIT_28
+#define DT_OEM_001                      BIT_29
+#define DT_ISP2200A                     BIT_30
+#define DT_EXTENDED_IDS                 BIT_31
+#define DT_MASK(ha)     ((ha)->device_type & (DT_ISP_LAST - 1))
+#define IS_QLA2100(ha)  (DT_MASK(ha) & DT_ISP2100)
+#define IS_QLA2200(ha)  (DT_MASK(ha) & DT_ISP2200)
+#define IS_QLA2300(ha)  (DT_MASK(ha) & DT_ISP2300)
+#define IS_QLA2312(ha)  (DT_MASK(ha) & DT_ISP2312)
+#define IS_QLA2322(ha)  (DT_MASK(ha) & DT_ISP2322)
+#define IS_QLA6312(ha)  (DT_MASK(ha) & DT_ISP6312)
+#define IS_QLA6322(ha)  (DT_MASK(ha) & DT_ISP6322)
+#define IS_QLA2422(ha)  (DT_MASK(ha) & DT_ISP2422)
+#define IS_QLA2432(ha)  (DT_MASK(ha) & DT_ISP2432)
+#define IS_QLA5422(ha)  (DT_MASK(ha) & DT_ISP5422)
+#define IS_QLA5432(ha)  (DT_MASK(ha) & DT_ISP5432)
+#define IS_QLA2532(ha)  (DT_MASK(ha) & DT_ISP2532)
+#define IS_QLA8432(ha)  (DT_MASK(ha) & DT_ISP8432)
+
+#define IS_QLA23XX(ha)  (IS_QLA2300(ha) || IS_QLA2312(ha) || IS_QLA2322(ha) || \
+			IS_QLA6312(ha) || IS_QLA6322(ha))
+#define IS_QLA24XX(ha)  (IS_QLA2422(ha) || IS_QLA2432(ha))
+#define IS_QLA54XX(ha)  (IS_QLA5422(ha) || IS_QLA5432(ha))
+#define IS_QLA25XX(ha)  (IS_QLA2532(ha))
+#define IS_QLA84XX(ha)  (IS_QLA8432(ha))
+#define IS_QLA24XX_TYPE(ha)     (IS_QLA24XX(ha) || IS_QLA54XX(ha) || \
+				IS_QLA84XX(ha))
+#define IS_QLA2XXX_MIDTYPE(ha)	(IS_QLA24XX(ha) || IS_QLA84XX(ha) || \
+				IS_QLA25XX(ha))
+
+#define IS_IIDMA_CAPABLE(ha)    ((ha)->device_type & DT_IIDMA)
+#define IS_FWI2_CAPABLE(ha)     ((ha)->device_type & DT_FWI2)
+#define IS_ZIO_SUPPORTED(ha)    ((ha)->device_type & DT_ZIO_SUPPORTED)
+#define IS_OEM_001(ha)          ((ha)->device_type & DT_OEM_001)
+#define HAS_EXTENDED_IDS(ha)    ((ha)->device_type & DT_EXTENDED_IDS)
 
 	/* HBA serial number */
 	uint8_t		serial0;
@@ -2386,8 +2342,8 @@ typedef struct scsi_qla_host {
 	uint8_t		serial2;
 
 	/* NVRAM configuration data */
-#define MAX_NVRAM_SIZE	4096
-#define VPD_OFFSET	MAX_NVRAM_SIZE / 2
+#define MAX_NVRAM_SIZE  4096
+#define VPD_OFFSET      MAX_NVRAM_SIZE / 2
 	uint16_t	nvram_size;
 	uint16_t	nvram_base;
 	void		*nvram;
@@ -2401,22 +2357,8 @@ typedef struct scsi_qla_host {
 	uint16_t	r_a_tov;
 	int		port_down_retry_count;
 	uint8_t		mbx_count;
-	uint16_t	last_loop_id;
-	uint16_t	mgmt_svr_loop_id;
-
-        uint32_t	login_retry_count;
-	int		max_q_depth;
-
-	struct list_head	work_list;
-
-	/* Fibre Channel Device List. */
-	struct list_head	fcports;
-
-	/* RSCN queue. */
-	uint32_t rscn_queue[MAX_RSCN_COUNT];
-	uint8_t rscn_in_ptr;
-	uint8_t rscn_out_ptr;
 
+	uint32_t	login_retry_count;
 	/* SNS command interfaces. */
 	ms_iocb_entry_t		*ms_iocb;
 	dma_addr_t		ms_iocb_dma;
@@ -2426,28 +2368,20 @@ typedef struct scsi_qla_host {
 	struct sns_cmd_pkt	*sns_cmd;
 	dma_addr_t		sns_cmd_dma;
 
-#define SFP_DEV_SIZE	256
-#define SFP_BLOCK_SIZE	64
-	void			*sfp_data;
-	dma_addr_t		sfp_data_dma;
+#define SFP_DEV_SIZE    256
+#define SFP_BLOCK_SIZE  64
+	void		*sfp_data;
+	dma_addr_t	sfp_data_dma;
 
 	struct task_struct	*dpc_thread;
 	uint8_t dpc_active;                  /* DPC routine is active */
 
-	/* Timeout timers. */
-	uint8_t         loop_down_abort_time;    /* port down timer */
-	atomic_t        loop_down_timer;         /* loop down timer */
-	uint8_t         link_down_timeout;       /* link down timeout */
-
-	uint32_t        timer_active;
-	struct timer_list        timer;
-
 	dma_addr_t	gid_list_dma;
 	struct gid_list_info *gid_list;
 	int		gid_list_info_size;
 
 	/* Small DMA pool allocations -- maximum 256 bytes in length. */
-#define DMA_POOL_SIZE	256
+#define DMA_POOL_SIZE   256
 	struct dma_pool *s_dma_pool;
 
 	dma_addr_t	init_cb_dma;
@@ -2459,17 +2393,17 @@ typedef struct scsi_qla_host {
 
 	mbx_cmd_t	*mcp;
 	unsigned long	mbx_cmd_flags;
-#define MBX_INTERRUPT	1
-#define MBX_INTR_WAIT	2
+#define MBX_INTERRUPT		1
+#define MBX_INTR_WAIT		2
 #define MBX_UPDATE_FLASH_ACTIVE	3
 
-	struct mutex vport_lock;	/* Virtual port synchronization */
-	struct completion mbx_cmd_comp;	/* Serialize mbx access */
+	struct mutex vport_lock;        /* Virtual port synchronization */
+	struct completion mbx_cmd_comp; /* Serialize mbx access */
 	struct completion mbx_intr_comp;  /* Used for completion notification */
 
 	uint32_t	mbx_flags;
 #define  MBX_IN_PROGRESS	BIT_0
-#define  MBX_BUSY		BIT_1	/* Got the Access */
+#define  MBX_BUSY		BIT_1   /* Got the Access */
 #define  MBX_SLEEPING_ON_SEM	BIT_2
 #define  MBX_POLLING_FOR_COMP	BIT_3
 #define  MBX_COMPLETED		BIT_4
@@ -2488,7 +2422,7 @@ typedef struct scsi_qla_host {
 #define RISC_START_ADDRESS_2300 0x800
 #define RISC_START_ADDRESS_2400 0x100000
 
-	uint16_t	fw_options[16];		/* slots: 1,2,3,10,11 */
+	uint16_t	fw_options[16];         /* slots: 1,2,3,10,11 */
 	uint8_t		fw_seriallink_options[4];
 	uint16_t	fw_seriallink_options24[4];
 
@@ -2509,10 +2443,10 @@ typedef struct scsi_qla_host {
 	uint64_t	fce_wr, fce_rd;
 	struct mutex	fce_mutex;
 
+	uint32_t	hw_event_start;
 	uint32_t	hw_event_ptr;
 	uint32_t	hw_event_pause_errors;
 
-	uint8_t		host_str[16];
 	uint32_t	pci_attr;
 	uint16_t	chip_revision;
 
@@ -2523,11 +2457,6 @@ typedef struct scsi_qla_host {
 	char		model_desc[80];
 	uint8_t		adapter_id[16+1];
 
-	uint8_t		*node_name;
-	uint8_t		*port_name;
-	uint8_t		fabric_node_name[WWN_SIZE];
-	uint32_t    isp_abort_cnt;
-
 	/* Option ROM information. */
 	char		*optrom_buffer;
 	uint32_t	optrom_size;
@@ -2538,13 +2467,13 @@ typedef struct scsi_qla_host {
 	uint32_t	optrom_region_start;
 	uint32_t	optrom_region_size;
 
-        /* PCI expansion ROM image information. */
+/* PCI expansion ROM image information. */
 #define ROM_CODE_TYPE_BIOS	0
 #define ROM_CODE_TYPE_FCODE	1
 #define ROM_CODE_TYPE_EFI	3
-	uint8_t		bios_revision[2];
-	uint8_t		efi_revision[2];
-	uint8_t		fcode_revision[16];
+	uint8_t 	bios_revision[2];
+	uint8_t 	efi_revision[2];
+	uint8_t 	fcode_revision[16];
 	uint32_t	fw_revision[4];
 
 	uint16_t	fdt_odd_index;
@@ -2554,39 +2483,145 @@ typedef struct scsi_qla_host {
 	uint32_t	fdt_unprotect_sec_cmd;
 	uint32_t	fdt_protect_sec_cmd;
 
-	uint32_t	flt_region_flt;
-	uint32_t	flt_region_fdt;
-	uint32_t	flt_region_boot;
-	uint32_t	flt_region_fw;
-	uint32_t	flt_region_vpd_nvram;
-	uint32_t	flt_region_hw_event;
-	uint32_t	flt_region_npiv_conf;
+	uint32_t        flt_region_flt;
+	uint32_t        flt_region_fdt;
+	uint32_t        flt_region_boot;
+	uint32_t        flt_region_fw;
+	uint32_t        flt_region_vpd_nvram;
+	uint32_t        flt_region_hw_event;
+	uint32_t        flt_region_npiv_conf;
 
 	/* Needed for BEACON */
-	uint16_t	beacon_blink_led;
-	uint8_t		beacon_color_state;
+	uint16_t        beacon_blink_led;
+	uint8_t         beacon_color_state;
 #define QLA_LED_GRN_ON		0x01
 #define QLA_LED_YLW_ON		0x02
 #define QLA_LED_ABR_ON		0x04
 #define QLA_LED_ALL_ON		0x07	/* yellow, green, amber. */
 					/* ISP2322: red, green, amber. */
-
-	uint16_t	zio_mode;
-	uint16_t	zio_timer;
+	uint16_t        zio_mode;
+	uint16_t        zio_timer;
 	struct fc_host_statistics fc_host_stat;
 
 	struct qla_msix_entry msix_entries[QLA_MSIX_ENTRIES];
 
-	struct list_head	vp_list;	/* list of VP */
+	struct list_head        vp_list;        /* list of VP */
+	unsigned long   vp_idx_map[(MAX_MULTI_ID_FABRIC / 8) /
+			sizeof(unsigned long)];
+	uint16_t        num_vhosts;     /* number of vports created */
+	uint16_t        num_vsans;      /* number of vsan created */
+	uint16_t        max_npiv_vports;        /* 63 or 125 per topoloty */
+	int             cur_vport_count;
+
+	struct qla_chip_state_84xx *cs84xx;
+	struct qla_statistics qla_stats;
+	struct isp_operations *isp_ops;
+};
+
+/*
+ * Qlogic scsi host structure
+ */
+typedef struct scsi_qla_host {
+	struct list_head list;
+	struct list_head vp_fcports;	/* list of fcports */
+	struct list_head work_list;
+
+	/* Commonly used flags and state information. */
+	struct Scsi_Host *host;
+	unsigned long	host_no;
+	uint8_t		host_str[16];
+
+	volatile struct {
+		uint32_t	init_done		:1;
+		uint32_t	online			:1;
+		uint32_t	rscn_queue_overflow	:1;
+		uint32_t	reset_active		:1;
+
+		uint32_t	management_server_logged_in :1;
+		uint32_t	process_response_queue	:1;
+	} flags;
+
+	atomic_t	loop_state;
+#define LOOP_TIMEOUT	1
+#define LOOP_DOWN	2
+#define LOOP_UP		3
+#define LOOP_UPDATE	4
+#define LOOP_READY	5
+#define LOOP_DEAD	6
+
+	unsigned long   dpc_flags;
+#define RESET_MARKER_NEEDED	0	/* Send marker to ISP. */
+#define RESET_ACTIVE		1
+#define ISP_ABORT_NEEDED	2	/* Initiate ISP abort. */
+#define ABORT_ISP_ACTIVE	3	/* ISP abort in progress. */
+#define LOOP_RESYNC_NEEDED	4	/* Device Resync needed. */
+#define LOOP_RESYNC_ACTIVE	5
+#define LOCAL_LOOP_UPDATE	6	/* Perform a local loop update. */
+#define RSCN_UPDATE		7	/* Perform an RSCN update. */
+#define MAILBOX_RETRY		8
+#define ISP_RESET_NEEDED	9	/* Initiate a ISP reset. */
+#define FAILOVER_EVENT_NEEDED	10
+#define FAILOVER_EVENT		11
+#define FAILOVER_NEEDED		12
+#define SCSI_RESTART_NEEDED	13	/* Processes SCSI retry queue. */
+#define PORT_RESTART_NEEDED	14	/* Processes Retry queue. */
+#define RESTART_QUEUES_NEEDED	15	/* Restarts the Lun queue. */
+#define ABORT_QUEUES_NEEDED	16
+#define RELOGIN_NEEDED		17
+#define LOGIN_RETRY_NEEDED	18	/* Initiate required fabric logins. */
+#define REGISTER_FC4_NEEDED	19	/* SNS FC4 registration required. */
+#define ISP_ABORT_RETRY		20	/* ISP aborted. */
+#define FCPORT_RESCAN_NEEDED	21	/* IO descriptor processing needed */
+#define IODESC_PROCESS_NEEDED	22	/* IO descriptor processing needed */
+#define IOCTL_ERROR_RECOVERY	23
+#define LOOP_RESET_NEEDED	24
+#define BEACON_BLINK_NEEDED	25
+#define REGISTER_FDMI_NEEDED	26
+#define FCPORT_UPDATE_NEEDED	27
+#define VP_DPC_NEEDED		28	/* wake up for VP dpc handling */
+#define UNLOADING		29
+#define NPIV_CONFIG_NEEDED	30
+
+	uint32_t	device_flags;
+#define DFLG_LOCAL_DEVICES		BIT_0
+#define DFLG_RETRY_LOCAL_DEVICES	BIT_1
+#define DFLG_FABRIC_DEVICES		BIT_2
+#define SWITCH_FOUND			BIT_3
+#define DFLG_NO_CABLE			BIT_4
+
+	srb_t		*status_srb;	/* Status continuation entry. */
+
+	/* ISP configuration data. */
+	uint16_t	loop_id;		/* Host adapter loop id */
+
+	port_id_t	d_id;			/* Host adapter port id */
+	uint8_t		marker_needed;
+	uint16_t	mgmt_svr_loop_id;
+
+
+
+	/* RSCN queue. */
+	uint32_t rscn_queue[MAX_RSCN_COUNT];
+	uint8_t rscn_in_ptr;
+	uint8_t rscn_out_ptr;
+
+	/* Timeout timers. */
+	uint8_t         loop_down_abort_time;    /* port down timer */
+	atomic_t        loop_down_timer;         /* loop down timer */
+	uint8_t         link_down_timeout;       /* link down timeout */
+
+	uint32_t        timer_active;
+	struct timer_list        timer;
+
+	uint8_t		node_name[WWN_SIZE];
+	uint8_t		port_name[WWN_SIZE];
+	uint8_t		fabric_node_name[WWN_SIZE];
+	uint32_t   	vp_abort_cnt;
+
 	struct fc_vport	*fc_vport;	/* holds fc_vport * for each vport */
-	unsigned long	vp_idx_map[(MAX_MULTI_ID_FABRIC / 8) / sizeof(unsigned long)];
-	uint16_t        num_vhosts;	/* number of vports created */
-	uint16_t        num_vsans;	/* number of vsan created */
 	uint16_t        vp_idx;		/* vport ID */
 
-	struct scsi_qla_host	*parent;	/* holds pport */
 	unsigned long		vp_flags;
-	struct list_head	vp_fcports;	/* list of fcports */
 #define VP_IDX_ACQUIRED		0	/* bit no 0 */
 #define VP_CREATE_NEEDED	1
 #define VP_BIND_NEEDED		2
@@ -2605,11 +2640,7 @@ typedef struct scsi_qla_host {
 #define VP_ERR_FAB_NORESOURCES	3
 #define VP_ERR_FAB_LOGOUT	4
 #define VP_ERR_ADAP_NORESOURCES	5
-	uint16_t	max_npiv_vports;	/* 63 or 125 per topoloty */
-	int		cur_vport_count;
-
-	struct qla_chip_state_84xx *cs84xx;
-	struct qla_statistics qla_stats;
+	struct qla_hw_data *hw;
 } scsi_qla_host_t;
 
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 753dbe6..c0cc686 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -72,7 +72,10 @@ extern int qla2x00_post_hwe_work(struct scsi_qla_host *, uint16_t , uint16_t,
     uint16_t, uint16_t);
 
 extern void qla2x00_abort_fcport_cmds(fc_port_t *);
-
+extern struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *,
+	struct qla_hw_data *);
+extern void qla2x00_free_host(struct scsi_qla_host *);
+extern void qla2x00_relogin(struct scsi_qla_host *);
 /*
  * Global Functions in qla_mid.c source file.
  */
@@ -105,10 +108,10 @@ extern struct fw_blob *qla2x00_request_firmware(scsi_qla_host_t *);
 
 extern int qla2x00_wait_for_hba_online(scsi_qla_host_t *);
 
-extern void qla2xxx_wake_dpc(scsi_qla_host_t *);
-extern void qla2x00_alert_all_vps(scsi_qla_host_t *, uint16_t *);
+extern void qla2xxx_wake_dpc(struct scsi_qla_host *);
+extern void qla2x00_alert_all_vps(struct qla_hw_data *, uint16_t *);
 extern void qla2x00_async_event(scsi_qla_host_t *, uint16_t *);
-extern void qla2x00_vp_abort_isp(scsi_qla_host_t *);
+extern int  qla2x00_vp_abort_isp(scsi_qla_host_t *);
 
 /*
  * Global Function Prototypes in qla_iocb.c source file.
@@ -267,7 +270,7 @@ extern irqreturn_t qla24xx_intr_handler(int, void *);
 extern void qla2x00_process_response_queue(struct scsi_qla_host *);
 extern void qla24xx_process_response_queue(struct scsi_qla_host *);
 
-extern int qla2x00_request_irqs(scsi_qla_host_t *);
+extern int qla2x00_request_irqs(struct qla_hw_data *);
 extern void qla2x00_free_irqs(scsi_qla_host_t *);
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index e90afad..8ce3547 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -32,21 +32,15 @@ qla2x00_debounce_register(volatile uint16_t __iomem *addr)
 }
 
 static inline void
-qla2x00_poll(scsi_qla_host_t *ha)
+qla2x00_poll(struct rsp_que *rsp)
 {
 	unsigned long flags;
-
+	struct qla_hw_data *ha = rsp->hw;
 	local_irq_save(flags);
-	ha->isp_ops->intr_handler(0, ha);
+	ha->isp_ops->intr_handler(0, rsp);
 	local_irq_restore(flags);
 }
 
-static __inline__ scsi_qla_host_t *
-to_qla_parent(scsi_qla_host_t *ha)
-{
-	return ha->parent ? ha->parent : ha;
-}
-
 /**
  * qla2x00_issue_marker() - Issue a Marker IOCB if necessary.
  * @ha: HA context
@@ -55,20 +49,20 @@ to_qla_parent(scsi_qla_host_t *ha)
  * Returns non-zero if a failure occurred, else zero.
  */
 static inline int
-qla2x00_issue_marker(scsi_qla_host_t *ha, int ha_locked)
+qla2x00_issue_marker(scsi_qla_host_t *vha, int ha_locked)
 {
 	/* Send marker if required */
-	if (ha->marker_needed != 0) {
+	if (vha->marker_needed != 0) {
 		if (ha_locked) {
-			if (__qla2x00_marker(ha, 0, 0, MK_SYNC_ALL) !=
+			if (__qla2x00_marker(vha, 0, 0, MK_SYNC_ALL) !=
 			    QLA_SUCCESS)
 				return (QLA_FUNCTION_FAILED);
 		} else {
-			if (qla2x00_marker(ha, 0, 0, MK_SYNC_ALL) !=
+			if (qla2x00_marker(vha, 0, 0, MK_SYNC_ALL) !=
 			    QLA_SUCCESS)
 				return (QLA_FUNCTION_FAILED);
 		}
-		ha->marker_needed = 0;
+		vha->marker_needed = 0;
 	}
 	return (QLA_SUCCESS);
 }
@@ -87,11 +81,12 @@ host_to_fcp_swap(uint8_t *fcp, uint32_t bsize)
 }
 
 static inline int
-qla2x00_is_reserved_id(scsi_qla_host_t *ha, uint16_t loop_id)
+qla2x00_is_reserved_id(scsi_qla_host_t *vha, uint16_t loop_id)
 {
+	struct qla_hw_data *ha = vha->hw;
 	if (IS_FWI2_CAPABLE(ha))
 		return (loop_id > NPH_LAST_HANDLE);
 
-	return ((loop_id > ha->last_loop_id && loop_id < SNS_FIRST_LOOP_ID) ||
+	return ((loop_id > ha->max_loop_id && loop_id < SNS_FIRST_LOOP_ID) ||
 	    loop_id == MANAGEMENT_SERVER || loop_id == BROADCAST);
 };
diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index be5e299..c0d7088 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,9 +7,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.02.01-k8"
+#define QLA2XXX_VERSION      "8.02.02-k1-14"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	2
-#define QLA_DRIVER_PATCH_VER	1
+#define QLA_DRIVER_PATCH_VER	2
 #define QLA_DRIVER_BETA_VER	0
