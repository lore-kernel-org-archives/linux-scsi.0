From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 3/17]  qla2xxx: Add ISP24xx definitions.
Date: Wed,  6 Jul 2005 10:30:26 -0700 (PDT)
Message-ID: <20050706173026.10568.39783.sendpatchset@plap.qlogic.com>
References: <20050706172955.10568.87971.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:46159 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S262405AbVGFRaa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2005 13:30:30 -0400
In-Reply-To: <20050706172955.10568.87971.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Add ISP24xx definitions.

Add requisite structure definitions and #define's for ISP24xx
support.  Also drop volatile modifiers from device_reg_* register
layouts as the members are never really accessed, only their
offsets within the layout are used during reads and writes.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/qla_dbg.c    |    6 
 drivers/scsi/qla2xxx/qla_def.h    |  278 ++++++----
 drivers/scsi/qla2xxx/qla_fw.h     | 1076 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_init.c   |   49 +-
 drivers/scsi/qla2xxx/qla_inline.h |   11 
 drivers/scsi/qla2xxx/qla_iocb.c   |    8 
 drivers/scsi/qla2xxx/qla_isr.c    |   14 
 drivers/scsi/qla2xxx/qla_mbx.c    |    2 
 drivers/scsi/qla2xxx/qla_os.c     |    8 
 drivers/scsi/qla2xxx/qla_rscn.c   |    2 
 drivers/scsi/qla2xxx/qla_sup.c    |   16 -
 11 files changed, 1318 insertions(+), 152 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla_fw.h

27bc708984e326687ad90e9defb83e5720818de3
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -36,7 +36,7 @@ qla2300_fw_dump(scsi_qla_host_t *ha, int
 	uint16_t	mb0, mb2;
 
 	uint32_t	stat;
-	device_reg_t __iomem *reg = ha->iobase;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	uint16_t __iomem *dmp_reg;
 	unsigned long	flags;
 	struct qla2300_fw_dump	*fw;
@@ -587,7 +587,7 @@ qla2100_fw_dump(scsi_qla_host_t *ha, int
 	uint32_t	cnt, timer;
 	uint16_t	risc_address;
 	uint16_t	mb0, mb2;
-	device_reg_t __iomem *reg = ha->iobase;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	uint16_t __iomem *dmp_reg;
 	unsigned long	flags;
 	struct qla2100_fw_dump	*fw;
@@ -984,7 +984,7 @@ qla_uprintf(char **uiter, char *fmt, ...
 void 
 qla2x00_dump_regs(scsi_qla_host_t *ha) 
 {
-	device_reg_t __iomem *reg = ha->iobase;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	printk("Mailbox registers:\n");
 	printk("scsi(%ld): mbox 0 0x%04x \n",
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -75,9 +75,28 @@
 #define IS_QLA6322(ha)	0
 #endif
 
+#if defined(CONFIG_SCSI_QLA24XX) || defined(CONFIG_SCSI_QLA24XX_MODULE)
+#define IS_QLA2422(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2422)
+#define IS_QLA2432(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2432)
+#else
+#define IS_QLA2422(ha)	0
+#define IS_QLA2432(ha)	0
+#endif
+
+#if defined(CONFIG_SCSI_QLA25XX) || defined(CONFIG_SCSI_QLA25XX_MODULE)
+#define IS_QLA2512(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2512)
+#define IS_QLA2522(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2522)
+#else
+#define IS_QLA2512(ha)	0
+#define IS_QLA2522(ha)	0
+#endif
+
 #define IS_QLA23XX(ha)	(IS_QLA2300(ha) || IS_QLA2312(ha) || IS_QLA2322(ha) || \
     			 IS_QLA6312(ha) || IS_QLA6322(ha))
 
+#define IS_QLA24XX(ha)	(IS_QLA2422(ha) || IS_QLA2432(ha))
+#define IS_QLA25XX(ha)	(IS_QLA2512(ha) || IS_QLA2522(ha))
+
 /*
  * Only non-ISP2[12]00 have extended addressing support in the firmware.
  */
@@ -191,10 +210,18 @@
 #define MANAGEMENT_SERVER	0xfe
 #define BROADCAST		0xff
 
-#define RESERVED_LOOP_ID(x)	((x > LAST_LOCAL_LOOP_ID && \
-				 x < SNS_FIRST_LOOP_ID) || \
-				 x == MANAGEMENT_SERVER || \
-				 x == BROADCAST)
+/*
+ * There is no correspondence between an N-PORT id and an AL_PA.  Therefore the
+ * valid range of an N-PORT id is 0 through 0x7ef.
+ */
+#define NPH_LAST_HANDLE		0x7ef
+#define NPH_SNS			0x7fc		/*  FFFFFC */
+#define NPH_FABRIC_CONTROLLER	0x7fd		/*  FFFFFD */
+#define NPH_F_PORT		0x7fe		/*  FFFFFE */
+#define NPH_IP_BROADCAST	0x7ff		/*  FFFFFF */
+
+#define MAX_CMDSZ	16		/* SCSI maximum CDB size. */
+#include "qla_fw.h"
 
 /*
  * Timeout timer counts in seconds
@@ -211,6 +238,7 @@
 #define REQUEST_ENTRY_CNT_2100		128	/* Number of request entries. */
 #define REQUEST_ENTRY_CNT_2200		2048	/* Number of request entries. */
 #define REQUEST_ENTRY_CNT_2XXX_EXT_MEM	4096	/* Number of request entries. */
+#define REQUEST_ENTRY_CNT_24XX		4096	/* Number of request entries. */
 #define RESPONSE_ENTRY_CNT_2100		64	/* Number of response entries.*/
 #define RESPONSE_ENTRY_CNT_2300		512	/* Number of response entries.*/
 
@@ -279,24 +307,24 @@ typedef struct srb {
 /*
  * ISP I/O Register Set structure definitions.
  */
-typedef volatile struct {
-	volatile uint16_t flash_address; /* Flash BIOS address */
-	volatile uint16_t flash_data;	/* Flash BIOS data */
+struct device_reg_2xxx {
+	uint16_t flash_address; 	/* Flash BIOS address */
+	uint16_t flash_data;		/* Flash BIOS data */
 	uint16_t unused_1[1];		/* Gap */
-	volatile uint16_t ctrl_status;	/* Control/Status */
+	uint16_t ctrl_status;		/* Control/Status */
 #define CSR_FLASH_64K_BANK	BIT_3	/* Flash upper 64K bank select */ 
 #define CSR_FLASH_ENABLE	BIT_1	/* Flash BIOS Read/Write enable */
 #define CSR_ISP_SOFT_RESET	BIT_0	/* ISP soft reset */
 
-	volatile uint16_t ictrl;	/* Interrupt control */
+	uint16_t ictrl;			/* Interrupt control */
 #define ICR_EN_INT		BIT_15	/* ISP enable interrupts. */
 #define ICR_EN_RISC		BIT_3	/* ISP enable RISC interrupts. */
 
-	volatile uint16_t istatus;	/* Interrupt status */
+	uint16_t istatus;		/* Interrupt status */
 #define ISR_RISC_INT		BIT_3	/* RISC interrupt */
 
-	volatile uint16_t semaphore;	/* Semaphore */
-	volatile uint16_t nvram;	/* NVRAM register. */
+	uint16_t semaphore;		/* Semaphore */
+	uint16_t nvram;			/* NVRAM register. */
 #define NVR_DESELECT		0
 #define NVR_BUSY		BIT_15
 #define NVR_WRT_ENABLE		BIT_14	/* Write enable */
@@ -308,78 +336,78 @@ typedef volatile struct {
 
 	union {
 		struct {
-			volatile uint16_t mailbox0;
-			volatile uint16_t mailbox1;
-			volatile uint16_t mailbox2;
-			volatile uint16_t mailbox3;
-			volatile uint16_t mailbox4;
-			volatile uint16_t mailbox5;
-			volatile uint16_t mailbox6;
-			volatile uint16_t mailbox7;
-			uint16_t unused_2[59];		/* Gap */
+			uint16_t mailbox0;
+			uint16_t mailbox1;
+			uint16_t mailbox2;
+			uint16_t mailbox3;
+			uint16_t mailbox4;
+			uint16_t mailbox5;
+			uint16_t mailbox6;
+			uint16_t mailbox7;
+			uint16_t unused_2[59];	/* Gap */
 		} __attribute__((packed)) isp2100;
 		struct {
-							/* Request Queue */
-			volatile uint16_t req_q_in;	/*  In-Pointer */
-			volatile uint16_t req_q_out;	/*  Out-Pointer */
-							/* Response Queue */
-			volatile uint16_t rsp_q_in;	/*  In-Pointer */
-			volatile uint16_t rsp_q_out;	/*  Out-Pointer */
+						/* Request Queue */
+			uint16_t req_q_in;	/*  In-Pointer */
+			uint16_t req_q_out;	/*  Out-Pointer */
+						/* Response Queue */
+			uint16_t rsp_q_in;	/*  In-Pointer */
+			uint16_t rsp_q_out;	/*  Out-Pointer */
 
 						/* RISC to Host Status */
-			volatile uint32_t host_status;	
+			uint32_t host_status;	
 #define HSR_RISC_INT		BIT_15	/* RISC interrupt */
 #define HSR_RISC_PAUSED		BIT_8	/* RISC Paused */
 
 					/* Host to Host Semaphore */
-			volatile uint16_t host_semaphore; 
-			uint16_t unused_3[17];		/* Gap */
-			volatile uint16_t mailbox0;
-			volatile uint16_t mailbox1;
-			volatile uint16_t mailbox2;
-			volatile uint16_t mailbox3;
-			volatile uint16_t mailbox4;
-			volatile uint16_t mailbox5;
-			volatile uint16_t mailbox6;
-			volatile uint16_t mailbox7;
-			volatile uint16_t mailbox8;
-			volatile uint16_t mailbox9;
-			volatile uint16_t mailbox10;
-			volatile uint16_t mailbox11;
-			volatile uint16_t mailbox12;
-			volatile uint16_t mailbox13;
-			volatile uint16_t mailbox14;
-			volatile uint16_t mailbox15;
-			volatile uint16_t mailbox16;
-			volatile uint16_t mailbox17;
-			volatile uint16_t mailbox18;
-			volatile uint16_t mailbox19;
-			volatile uint16_t mailbox20;
-			volatile uint16_t mailbox21;
-			volatile uint16_t mailbox22;
-			volatile uint16_t mailbox23;
-			volatile uint16_t mailbox24;
-			volatile uint16_t mailbox25;
-			volatile uint16_t mailbox26;
-			volatile uint16_t mailbox27;
-			volatile uint16_t mailbox28;
-			volatile uint16_t mailbox29;
-			volatile uint16_t mailbox30;
-			volatile uint16_t mailbox31;
-			volatile uint16_t fb_cmd;
-			uint16_t unused_4[10];		/* Gap */
+			uint16_t host_semaphore; 
+			uint16_t unused_3[17];	/* Gap */
+			uint16_t mailbox0;
+			uint16_t mailbox1;
+			uint16_t mailbox2;
+			uint16_t mailbox3;
+			uint16_t mailbox4;
+			uint16_t mailbox5;
+			uint16_t mailbox6;
+			uint16_t mailbox7;
+			uint16_t mailbox8;
+			uint16_t mailbox9;
+			uint16_t mailbox10;
+			uint16_t mailbox11;
+			uint16_t mailbox12;
+			uint16_t mailbox13;
+			uint16_t mailbox14;
+			uint16_t mailbox15;
+			uint16_t mailbox16;
+			uint16_t mailbox17;
+			uint16_t mailbox18;
+			uint16_t mailbox19;
+			uint16_t mailbox20;
+			uint16_t mailbox21;
+			uint16_t mailbox22;
+			uint16_t mailbox23;
+			uint16_t mailbox24;
+			uint16_t mailbox25;
+			uint16_t mailbox26;
+			uint16_t mailbox27;
+			uint16_t mailbox28;
+			uint16_t mailbox29;
+			uint16_t mailbox30;
+			uint16_t mailbox31;
+			uint16_t fb_cmd;
+			uint16_t unused_4[10];	/* Gap */
 		} __attribute__((packed)) isp2300;
 	} u;
 
-	volatile uint16_t fpm_diag_config;
+	uint16_t fpm_diag_config;
 	uint16_t unused_5[0x6];		/* Gap */
-	volatile uint16_t pcr;		/* Processor Control Register. */
+	uint16_t pcr;			/* Processor Control Register. */
 	uint16_t unused_6[0x5];		/* Gap */
-	volatile uint16_t mctr;		/* Memory Configuration and Timing. */
+	uint16_t mctr;			/* Memory Configuration and Timing. */
 	uint16_t unused_7[0x3];		/* Gap */
-	volatile uint16_t fb_cmd_2100;	/* Unused on 23XX */
+	uint16_t fb_cmd_2100;		/* Unused on 23XX */
 	uint16_t unused_8[0x3];		/* Gap */
-	volatile uint16_t hccr;		/* Host command & control register. */
+	uint16_t hccr;			/* Host command & control register. */
 #define HCCR_HOST_INT		BIT_7	/* Host interrupt bit */
 #define HCCR_RISC_PAUSE		BIT_5	/* Pause mode bit */
 					/* HCCR commands */
@@ -393,8 +421,8 @@ typedef volatile struct {
 #define HCCR_ENABLE_PARITY	0xA000	/* Enable PARITY interrupt */
 
 	uint16_t unused_9[5];		/* Gap */
-	volatile uint16_t gpiod;	/* GPIO Data register. */
-	volatile uint16_t gpioe;	/* GPIO Enable register. */
+	uint16_t gpiod;			/* GPIO Data register. */
+	uint16_t gpioe;			/* GPIO Enable register. */
 #define GPIO_LED_MASK			0x00C0
 #define GPIO_LED_GREEN_OFF_AMBER_OFF	0x0000
 #define GPIO_LED_GREEN_ON_AMBER_OFF	0x0040
@@ -403,25 +431,32 @@ typedef volatile struct {
 
 	union {
 		struct {
-			uint16_t unused_10[8];		/* Gap */
-			volatile uint16_t mailbox8;
-			volatile uint16_t mailbox9;
-			volatile uint16_t mailbox10;
-			volatile uint16_t mailbox11;
-			volatile uint16_t mailbox12;
-			volatile uint16_t mailbox13;
-			volatile uint16_t mailbox14;
-			volatile uint16_t mailbox15;
-			volatile uint16_t mailbox16;
-			volatile uint16_t mailbox17;
-			volatile uint16_t mailbox18;
-			volatile uint16_t mailbox19;
-			volatile uint16_t mailbox20;
-			volatile uint16_t mailbox21;
-			volatile uint16_t mailbox22;
-			volatile uint16_t mailbox23;	/* Also probe reg. */
+			uint16_t unused_10[8];	/* Gap */
+			uint16_t mailbox8;
+			uint16_t mailbox9;
+			uint16_t mailbox10;
+			uint16_t mailbox11;
+			uint16_t mailbox12;
+			uint16_t mailbox13;
+			uint16_t mailbox14;
+			uint16_t mailbox15;
+			uint16_t mailbox16;
+			uint16_t mailbox17;
+			uint16_t mailbox18;
+			uint16_t mailbox19;
+			uint16_t mailbox20;
+			uint16_t mailbox21;
+			uint16_t mailbox22;
+			uint16_t mailbox23;	/* Also probe reg. */
 		} __attribute__((packed)) isp2200;
 	} u_end;
+};
+
+typedef struct {
+	union {
+		struct device_reg_2xxx isp;
+		struct device_reg_24xx isp24;
+	};
 } device_reg_t;
 
 #define ISP_REQ_Q_IN(ha, reg) \
@@ -504,6 +539,8 @@ typedef struct {
 #define MBS_LOOP_ID_USED		0x4008
 #define MBS_ALL_IDS_IN_USE		0x4009
 #define MBS_NOT_LOGGED_IN		0x400A
+#define MBS_LINK_DOWN_ERROR		0x400B
+#define MBS_DIAG_ECHO_TEST_ERROR	0x400C
 
 /*
  * ISP mailbox asynchronous event status codes
@@ -555,7 +592,7 @@ typedef struct {
 #define FO1_CTIO_RETRY			BIT_3
 #define FO1_DISABLE_LIP_F7_SW		BIT_4
 #define FO1_DISABLE_100MS_LOS_WAIT	BIT_5
-#define FO1_DISABLE_GPIO6_7		BIT_6
+#define FO1_DISABLE_GPIO6_7		BIT_6	/* LED bits */
 #define FO1_AE_ON_LOOP_INIT_ERR		BIT_7
 #define FO1_SET_EMPHASIS_SWING		BIT_8
 #define FO1_AE_AUTO_BYPASS		BIT_9
@@ -570,6 +607,15 @@ typedef struct {
 #define FO3_ENABLE_EMERG_IOCB		BIT_0
 #define FO3_AE_RND_ERROR		BIT_1
 
+/* 24XX additional firmware options */
+#define ADD_FO_COUNT			3
+#define ADD_FO1_DISABLE_GPIO_LED_CTRL	BIT_6	/* LED bits */
+#define ADD_FO1_ENABLE_PUREX_IOCB	BIT_10
+
+#define ADD_FO2_ENABLE_SEL_CLS2		BIT_5
+
+#define ADD_FO3_NO_ABT_ON_LINK_DOWN	BIT_14
+
 /*
  * ISP mailbox commands
  */
@@ -638,6 +684,22 @@ typedef struct {
 #define MBC_SEND_LFA_COMMAND		0x7D	/* Send Loop Fabric Address */
 #define MBC_LUN_RESET			0x7E	/* Send LUN reset */
 
+/*
+ * ISP24xx mailbox commands
+ */
+#define MBC_SERDES_PARAMS		0x10	/* Serdes Tx Parameters. */
+#define MBC_GET_IOCB_STATUS		0x12	/* Get IOCB status command. */
+#define MBC_GET_TIMEOUT_PARAMS		0x22	/* Get FW timeouts. */
+#define MBC_GEN_SYSTEM_ERROR		0x2a	/* Generate System Error. */
+#define MBC_SET_TIMEOUT_PARAMS		0x32	/* Set FW timeouts. */
+#define MBC_MID_INITIALIZE_FIRMWARE	0x48	/* MID Initialize firmware. */
+#define MBC_MID_GET_VP_DATABASE		0x49	/* MID Get VP Database. */
+#define MBC_MID_GET_VP_ENTRY		0x4a	/* MID Get VP Entry. */
+#define MBC_HOST_MEMORY_COPY		0x53	/* Host Memory Copy. */
+#define MBC_SEND_RNFT_ELS		0x5e	/* Send RNFT ELS request */
+#define MBC_GET_LINK_PRIV_STATS		0x6d	/* Get link & private data. */
+#define MBC_SET_VENDOR_ID		0x76	/* Set Vendor ID. */
+
 /* Firmware return data sizes */
 #define FCAL_MAP_SIZE	128
 
@@ -867,6 +929,9 @@ typedef struct {
 /*
  * Get Link Status mailbox command return buffer.
  */
+#define GLSO_SEND_RPS	BIT_0
+#define GLSO_USE_DID	BIT_3
+
 typedef struct {
 	uint32_t	link_fail_cnt;
 	uint32_t	loss_sync_cnt;
@@ -1161,7 +1226,6 @@ do {							\
  * ISP queue - command entry structure definition.
  */
 #define COMMAND_TYPE	0x11		/* Command entry */
-#define MAX_CMDSZ	16		/* SCSI maximum CDB size. */
 typedef struct {
 	uint8_t entry_type;		/* Entry type. */
 	uint8_t entry_count;		/* Entry count. */
@@ -1284,11 +1348,16 @@ typedef struct {
 /*
  * Status entry entry status
  */
+#define RF_RQ_DMA_ERROR	BIT_6		/* Request Queue DMA error. */
 #define RF_INV_E_ORDER	BIT_5		/* Invalid entry order. */
 #define RF_INV_E_COUNT	BIT_4		/* Invalid entry count. */
 #define RF_INV_E_PARAM	BIT_3		/* Invalid entry parameter. */
 #define RF_INV_E_TYPE	BIT_2		/* Invalid entry type. */
 #define RF_BUSY		BIT_1		/* Busy */
+#define RF_MASK		(RF_RQ_DMA_ERROR | RF_INV_E_ORDER | RF_INV_E_COUNT | \
+			 RF_INV_E_PARAM | RF_INV_E_TYPE | RF_BUSY)
+#define RF_MASK_24XX	(RF_INV_E_ORDER | RF_INV_E_COUNT | RF_INV_E_PARAM | \
+			 RF_INV_E_TYPE)
 
 /*
  * Status entry SCSI status bit definitions.
@@ -1503,9 +1572,6 @@ typedef struct {
 	port_id_t d_id;
 	uint8_t node_name[WWN_SIZE];
 	uint8_t port_name[WWN_SIZE];
-	uint32_t type;
-#define SW_TYPE_IP	BIT_1
-#define SW_TYPE_SCSI	BIT_0
 } sw_info_t;
 
 /*
@@ -1520,6 +1586,8 @@ typedef struct {
 	union {
 		cmd_a64_entry_t cmd;
 		sts_entry_t rsp;
+		struct cmd_type_7 cmd24;
+		struct sts_entry_24xx rsp24;
 	} p;
 	uint8_t inq[INQ_DATA_SIZE];
 } inq_cmd_rsp_t;
@@ -1555,10 +1623,13 @@ typedef struct {
 	union {
 		cmd_a64_entry_t cmd;
 		sts_entry_t rsp;
+		struct cmd_type_7 cmd24;
+		struct sts_entry_24xx rsp24;
 	} p;
 	rpt_lun_lst_t list;
 } rpt_lun_cmd_rsp_t;
 
+
 /*
  * Fibre channel port type.
  */
@@ -1646,6 +1717,7 @@ typedef struct fc_port {
 #define FCF_FAILOVER_DISABLE	BIT_22
 #define FCF_DSXXX_DEVICE	BIT_23
 #define FCF_AA_EVA_DEVICE	BIT_24
+#define FCF_AA_MSA_DEVICE	BIT_25
 
 /* No loop ID flag. */
 #define FC_NO_LOOP_ID		0x1000
@@ -1917,6 +1989,7 @@ struct qla_board_info {
 
 	char isp_name[8];
 	struct qla_fw_info *fw_info;
+	char *fw_fname;;
 };
 
 /* Return data from MBC_GET_ID_LIST call. */
@@ -1926,6 +1999,7 @@ struct gid_list_info {
 	uint8_t	domain;		
 	uint8_t	loop_id_2100;	/* ISP2100/ISP2200 -- 4 bytes. */
 	uint16_t loop_id;	/* ISP23XX         -- 6 bytes. */
+	uint16_t reserved_1;	/* ISP24XX         -- 8 bytes. */
 };
 #define GID_LIST_SIZE (sizeof(struct gid_list_info) * MAX_FIBRE_DEVICES)
 
@@ -2000,6 +2074,8 @@ typedef struct scsi_qla_host {
 		uint32_t	enable_lip_full_login	:1;
 		uint32_t	enable_target_reset	:1;
 		uint32_t	enable_led_scheme	:1;
+		uint32_t	msi_enabled		:1;
+		uint32_t	msix_enabled		:1;
 	} flags;
 
 	atomic_t	loop_state;
@@ -2036,6 +2112,7 @@ typedef struct scsi_qla_host {
 #define IODESC_PROCESS_NEEDED	22      /* IO descriptor processing needed */
 #define IOCTL_ERROR_RECOVERY	23      
 #define LOOP_RESET_NEEDED	24
+#define BEACON_BLINK_NEEDED	25
 
 	uint32_t	device_flags;
 #define DFLG_LOCAL_DEVICES		BIT_0
@@ -2119,6 +2196,7 @@ typedef struct scsi_qla_host {
 	uint8_t		serial2;
 
 	/* NVRAM configuration data */
+	uint16_t	nvram_size;
 	uint16_t	nvram_base;
 
 	uint16_t	loop_reset_delay;
@@ -2179,7 +2257,8 @@ typedef struct scsi_qla_host {
 	struct dma_pool *s_dma_pool;
 
 	dma_addr_t	init_cb_dma;
-	init_cb_t       *init_cb;
+	init_cb_t	*init_cb;
+	int		init_cb_size;
 
 	dma_addr_t	iodesc_pd_dma;
 	port_database_t *iodesc_pd;
@@ -2220,6 +2299,7 @@ typedef struct scsi_qla_host {
 
 	uint16_t	fw_options[16];		/* slots: 1,2,3,10,11 */
 	uint8_t		fw_seriallink_options[4];
+	uint16_t	fw_seriallink_options24[4];
 
 	/* Firmware dump information. */
 	void		*fw_dump;
@@ -2228,8 +2308,12 @@ typedef struct scsi_qla_host {
 	char		*fw_dump_buffer;
 	int		fw_dump_buffer_len;
 
+	int		fw_dumped;
+	void		*fw_dump24;
+	int		fw_dump24_len;
+
 	uint8_t		host_str[16];
-	uint16_t	pci_attr;
+	uint32_t	pci_attr;
 
 	uint16_t	product_id[4];
 
@@ -2237,8 +2321,8 @@ typedef struct scsi_qla_host {
 #define BINZERO		"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
 	char		*model_desc;
 
-	uint8_t     node_name[WWN_SIZE];
-	uint8_t     nvram_version; 
+	uint8_t		*node_name;
+	uint8_t		*port_name;
 	uint32_t    isp_abort_cnt;
 
 	/* Needed for BEACON */
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
new file mode 100644
--- /dev/null
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -0,0 +1,1076 @@
+
+/********************************************************************************
+*                  QLOGIC LINUX SOFTWARE
+*
+* QLogic ISP2x00 device driver for Linux 2.6.x
+* Copyright (C) 2003-2004 QLogic Corporation
+* (www.qlogic.com)
+*
+* This program is free software; you can redistribute it and/or modify it
+* under the terms of the GNU General Public License as published by the
+* Free Software Foundation; either version 2, or (at your option) any
+* later version.
+*
+* This program is distributed in the hope that it will be useful, but
+* WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+* General Public License for more details.
+**
+******************************************************************************/
+
+#ifndef __QLA_FW_H
+#define __QLA_FW_H
+
+// ISP24xx
+
+#define RISC_SADDRESS		0x100000
+#define MBS_CHECKSUM_ERROR	0x4010
+
+/*
+ * Firmware Options.
+ */
+#define FO1_ENABLE_PUREX	BIT_10
+#define FO1_DISABLE_LED_CTRL	BIT_6
+#define FO2_ENABLE_SEL_CLASS2	BIT_5
+#define FO3_NO_ABTS_ON_LINKDOWN	BIT_14
+
+/*
+ * Port Database structure definition for ISP 24xx.
+ */
+#define PDO_FORCE_ADISC		BIT_1
+#define PDO_FORCE_PLOGI		BIT_0
+
+
+#define	PORT_DATABASE_24XX_SIZE		64
+struct port_database_24xx {
+	uint16_t flags;
+#define PDF_TASK_RETRY_ID	BIT_14
+#define PDF_FC_TAPE		BIT_7
+#define PDF_ACK0_CAPABLE	BIT_6
+#define PDF_FCP2_CONF		BIT_5
+#define PDF_CLASS_2		BIT_4
+#define PDF_HARD_ADDR		BIT_1
+
+	uint8_t current_login_state;
+	uint8_t last_login_state;
+#define PDS_PLOGI_PENDING	0x03
+#define PDS_PLOGI_COMPLETE	0x04
+#define PDS_PRLI_PENDING	0x05
+#define PDS_PRLI_COMPLETE	0x06
+#define PDS_PORT_UNAVAILABLE	0x07
+#define PDS_PRLO_PENDING	0x09
+#define PDS_LOGO_PENDING	0x11
+//FIXME
+#define PDS_PRLI2_PENDING	0x12
+
+	uint8_t hard_address[3];
+	uint8_t reserved_1;
+
+	uint8_t port_id[3];
+	uint8_t sequence_id;
+
+	uint16_t port_timer;
+
+	uint16_t nport_handle;			/* N_PORT handle. */
+
+	uint16_t receive_data_size;
+	uint16_t reserved_2;
+
+	uint8_t prli_svc_param_word_0[2];	/* Big endian */
+						/* Bits 15-0 of word 0 */
+	uint8_t prli_svc_param_word_3[2];	/* Big endian */
+						/* Bits 15-0 of word 3 */
+
+	uint8_t port_name[WWN_SIZE];
+	uint8_t node_name[WWN_SIZE];
+
+	uint8_t reserved_3[24];
+};
+
+struct nvram_24xx {
+	/* NVRAM header. */
+	uint8_t id[4];
+	uint16_t nvram_version;
+	uint16_t reserved_0;
+
+	/* Firmware Initialization Control Block. */
+	uint16_t version;
+	uint16_t reserved_1;
+	uint16_t frame_payload_size;
+	uint16_t execution_throttle;
+	uint16_t exchange_count;
+	uint16_t hard_address;
+
+	uint8_t port_name[WWN_SIZE];
+	uint8_t node_name[WWN_SIZE];
+
+	uint16_t login_retry_count;
+	uint16_t link_down_on_nos;
+	uint16_t interrupt_delay_timer;
+	uint16_t login_timeout;
+
+	uint32_t firmware_options_1;
+	uint32_t firmware_options_2;
+	uint32_t firmware_options_3;
+
+	/* Offset 56. */
+
+	/*
+	 * BIT 0     = Control Enable
+	 * BIT 1-15  =
+	 *
+	 * BIT 0-7   = Reserved
+	 * BIT 8-10  = Output Swing 1G
+	 * BIT 11-13 = Output Emphasis 1G
+	 * BIT 14-15 = Reserved
+	 *
+	 * BIT 0-7   = Reserved
+	 * BIT 8-10  = Output Swing 2G
+	 * BIT 11-13 = Output Emphasis 2G
+	 * BIT 14-15 = Reserved
+	 *
+	 * BIT 0-7   = Reserved
+	 * BIT 8-10  = Output Swing 4G
+	 * BIT 11-13 = Output Emphasis 4G
+	 * BIT 14-15 = Reserved
+	 */
+	uint16_t seriallink_options[4];
+
+	uint16_t reserved_2[16];
+
+	/* Offset 96. */
+	uint16_t reserved_3[16];
+
+	/* PCIe table entries. */
+	uint16_t reserved_4[16];
+
+	/* Offset 160. */
+	uint16_t reserved_5[16];
+
+	/* Offset 192. */
+	uint16_t reserved_6[16];
+
+	/* Offset 224. */
+	uint16_t reserved_7[16];
+
+	/*
+	 * BIT 0  = Enable spinup delay
+	 * BIT 1  = Disable BIOS
+	 * BIT 2  = Enable Memory Map BIOS
+	 * BIT 3  = Enable Selectable Boot
+	 * BIT 4  = Disable RISC code load
+	 * BIT 5  =
+	 * BIT 6  =
+	 * BIT 7  =
+	 *
+	 * BIT 8  =
+	 * BIT 9  =
+	 * BIT 10 = Enable lip full login
+	 * BIT 11 = Enable target reset
+	 * BIT 12 =
+	 * BIT 13 =
+	 * BIT 14 =
+	 * BIT 15 = Enable alternate WWN
+	 *
+	 * BIT 16-31 =
+	 */
+	uint32_t host_p;
+
+	uint8_t alternate_port_name[WWN_SIZE];
+	uint8_t alternate_node_name[WWN_SIZE];
+
+	uint8_t boot_port_name[WWN_SIZE];
+	uint16_t boot_lun_number;
+	uint16_t reserved_8;
+
+	uint8_t alt1_boot_port_name[WWN_SIZE];
+	uint16_t alt1_boot_lun_number;
+	uint16_t reserved_9;
+
+	uint8_t alt2_boot_port_name[WWN_SIZE];
+	uint16_t alt2_boot_lun_number;
+	uint16_t reserved_10;
+
+	uint8_t alt3_boot_port_name[WWN_SIZE];
+	uint16_t alt3_boot_lun_number;
+	uint16_t reserved_11;
+
+	/*
+	 * BIT 0 = Selective Login
+	 * BIT 1 = Alt-Boot Enable
+	 * BIT 2 = Reserved
+	 * BIT 3 = Boot Order List
+	 * BIT 4 = Reserved
+	 * BIT 5 = Selective LUN
+	 * BIT 6 = Reserved
+	 * BIT 7-31 =
+	 */
+	uint32_t efi_parameters;
+
+	uint8_t reset_delay;
+	uint8_t reserved_12;
+	uint16_t reserved_13;
+
+	uint16_t boot_id_number;
+	uint16_t reserved_14;
+
+	uint16_t max_luns_per_target;
+	uint16_t reserved_15;
+
+	uint16_t port_down_retry_count;
+	uint16_t link_down_timeout;
+
+	/* FCode parameters. */
+	uint16_t fcode_parameter;
+
+	uint16_t reserved_16[3];
+
+	/* Offset 352. */
+	uint8_t prev_drv_ver_major;
+	uint8_t prev_drv_ver_submajob;
+	uint8_t prev_drv_ver_minor;
+	uint8_t prev_drv_ver_subminor;
+
+	uint16_t prev_bios_ver_major;
+	uint16_t prev_bios_ver_minor;
+
+	uint16_t prev_efi_ver_major;
+	uint16_t prev_efi_ver_minor;
+
+	uint16_t prev_fw_ver_major;
+	uint8_t prev_fw_ver_minor;
+	uint8_t prev_fw_ver_subminor;
+
+	uint16_t reserved_17[8];
+
+	/* Offset 384. */
+	uint16_t reserved_18[16];
+
+	/* Offset 416. */
+	uint16_t reserved_19[16];
+
+	/* Offset 448. */
+	uint16_t reserved_20[16];
+
+	/* Offset 480. */
+	uint8_t model_name[16];
+
+	uint16_t reserved_21[2];
+
+	/* Offset 500. */
+	/* HW Parameter Block. */
+	uint16_t pcie_table_sig;
+	uint16_t pcie_table_offset;
+
+	uint16_t subsystem_vendor_id;
+	uint16_t subsystem_device_id;
+
+	uint32_t checksum;
+};
+
+/*
+ * ISP Initialization Control Block.
+ * Little endian except where noted.
+ */
+#define	ICB_VERSION 1
+struct init_cb_24xx {
+	uint16_t version;
+	uint16_t reserved_1;
+
+	uint16_t frame_payload_size;
+	uint16_t execution_throttle;
+	uint16_t exchange_count;
+
+	uint16_t hard_address;
+
+	uint8_t port_name[WWN_SIZE];		/* Big endian. */
+	uint8_t node_name[WWN_SIZE];		/* Big endian. */
+
+	uint16_t response_q_inpointer;
+	uint16_t request_q_outpointer;
+
+	uint16_t login_retry_count;
+
+	uint16_t prio_request_q_outpointer;
+
+	uint16_t response_q_length;
+	uint16_t request_q_length;
+
+	uint16_t link_down_timeout;		/* Milliseconds. */
+
+	uint16_t prio_request_q_length;
+
+	uint32_t request_q_address[2];
+	uint32_t response_q_address[2];
+	uint32_t prio_request_q_address[2];
+
+	uint8_t reserved_2[8];
+
+	uint16_t atio_q_inpointer;
+	uint16_t atio_q_length;
+	uint32_t atio_q_address[2];
+
+	uint16_t interrupt_delay_timer;		/* 100us increments. */
+	uint16_t login_timeout;
+
+	/*
+	 * BIT 0  = Enable Hard Loop Id
+	 * BIT 1  = Enable Fairness
+	 * BIT 2  = Enable Full-Duplex
+	 * BIT 3  = Reserved
+	 * BIT 4  = Enable Target Mode
+	 * BIT 5  = Disable Initiator Mode
+	 * BIT 6  = Reserved
+	 * BIT 7  = Reserved
+	 *
+	 * BIT 8  = Reserved
+	 * BIT 9  = Non Participating LIP
+	 * BIT 10 = Descending Loop ID Search
+	 * BIT 11 = Acquire Loop ID in LIPA
+	 * BIT 12 = Reserved
+	 * BIT 13 = Full Login after LIP
+	 * BIT 14 = Node Name Option
+	 * BIT 15-31 = Reserved
+	 */
+	uint32_t firmware_options_1;
+
+	/*
+	 * BIT 0  = Operation Mode bit 0
+	 * BIT 1  = Operation Mode bit 1
+	 * BIT 2  = Operation Mode bit 2
+	 * BIT 3  = Operation Mode bit 3
+	 * BIT 4  = Connection Options bit 0
+	 * BIT 5  = Connection Options bit 1
+	 * BIT 6  = Connection Options bit 2
+	 * BIT 7  = Enable Non part on LIHA failure
+	 *
+	 * BIT 8  = Enable Class 2
+	 * BIT 9  = Enable ACK0
+	 * BIT 10 = Reserved
+	 * BIT 11 = Enable FC-SP Security
+	 * BIT 12 = FC Tape Enable
+	 * BIT 13-31 = Reserved
+	 */
+	uint32_t firmware_options_2;
+
+	/*
+	 * BIT 0  = Reserved
+	 * BIT 1  = Soft ID only
+	 * BIT 2  = Reserved
+	 * BIT 3  = Reserved
+	 * BIT 4  = FCP RSP Payload bit 0
+	 * BIT 5  = FCP RSP Payload bit 1
+	 * BIT 6  = Enable Receive Out-of-Order data frame handling
+	 * BIT 7  = Disable Automatic PLOGI on Local Loop
+	 *
+	 * BIT 8  = Reserved
+	 * BIT 9  = Enable Out-of-Order FCP_XFER_RDY relative offset handling
+	 * BIT 10 = Reserved
+	 * BIT 11 = Reserved
+	 * BIT 12 = Reserved
+	 * BIT 13 = Data Rate bit 0
+	 * BIT 14 = Data Rate bit 1
+	 * BIT 15 = Data Rate bit 2
+	 * BIT 16-31 = Reserved
+	 */
+	uint32_t firmware_options_3;
+
+	uint8_t  reserved_3[24];
+};
+
+/*
+ * ISP queue - command entry structure definition.
+ */
+#define COMMAND_TYPE_6	0x48		/* Command Type 6 entry */
+struct cmd_type_6 {
+	uint8_t entry_type;		/* Entry type. */
+	uint8_t entry_count;		/* Entry count. */
+	uint8_t sys_define;		/* System defined. */
+	uint8_t entry_status;		/* Entry Status. */
+
+	uint32_t handle;		/* System handle. */
+
+	uint16_t nport_handle;		/* N_PORT handle. */
+	uint16_t timeout;		/* Command timeout. */
+
+	uint16_t dseg_count;		/* Data segment count. */
+
+	uint16_t fcp_rsp_dsd_len;	/* FCP_RSP DSD length. */
+
+	uint8_t lun[8];			/* FCP LUN (BE). */
+
+	uint16_t control_flags;		/* Control flags. */
+#define CF_DATA_SEG_DESCR_ENABLE	BIT_2
+#define CF_READ_DATA			BIT_1
+#define CF_WRITE_DATA			BIT_0
+
+	uint16_t fcp_cmnd_dseg_len;		/* Data segment length. */
+	uint32_t fcp_cmnd_dseg_address[2];	/* Data segment address. */
+
+	uint32_t fcp_rsp_dseg_address[2];	/* Data segment address. */
+
+	uint32_t byte_count;		/* Total byte count. */
+
+	uint8_t port_id[3];		/* PortID of destination port. */
+	uint8_t vp_index;
+
+	uint32_t fcp_data_dseg_address[2];	/* Data segment address. */
+	uint16_t fcp_data_dseg_len;		/* Data segment length. */
+	uint16_t reserved_1;			/* MUST be set to 0. */
+};
+
+#define COMMAND_TYPE_7	0x18		/* Command Type 7 entry */
+struct cmd_type_7 {
+	uint8_t entry_type;		/* Entry type. */
+	uint8_t entry_count;		/* Entry count. */
+	uint8_t sys_define;		/* System defined. */
+	uint8_t entry_status;		/* Entry Status. */
+
+	uint32_t handle;		/* System handle. */
+
+	uint16_t nport_handle;		/* N_PORT handle. */
+	uint16_t timeout;		/* Command timeout. */
+#define FW_MAX_TIMEOUT		0x1999
+
+	uint16_t dseg_count;		/* Data segment count. */
+	uint16_t reserved_1;
+
+	uint8_t lun[8];			/* FCP LUN (BE). */
+
+	uint16_t task_mgmt_flags;	/* Task management flags. */
+#define TMF_CLEAR_ACA		BIT_14
+#define TMF_TARGET_RESET	BIT_13
+#define TMF_LUN_RESET		BIT_12
+#define TMF_CLEAR_TASK_SET	BIT_10
+#define TMF_ABORT_TASK_SET	BIT_9
+#define TMF_READ_DATA		BIT_1
+#define TMF_WRITE_DATA		BIT_0
+
+	uint8_t task;
+#define TSK_SIMPLE		0
+#define TSK_HEAD_OF_QUEUE	1
+#define TSK_ORDERED		2
+#define TSK_ACA			4
+#define TSK_UNTAGGED		5
+
+	uint8_t crn;
+
+	uint8_t fcp_cdb[MAX_CMDSZ]; 	/* SCSI command words. */
+	uint32_t byte_count;		/* Total byte count. */
+
+	uint8_t port_id[3];		/* PortID of destination port. */
+	uint8_t vp_index;
+
+	uint32_t dseg_0_address[2];	/* Data segment 0 address. */
+	uint32_t dseg_0_len;		/* Data segment 0 length. */
+};
+
+/*
+ * ISP queue - status entry structure definition.
+ */
+#define	STATUS_TYPE	0x03		/* Status entry. */
+struct sts_entry_24xx {
+	uint8_t entry_type;		/* Entry type. */
+	uint8_t entry_count;		/* Entry count. */
+	uint8_t sys_define;		/* System defined. */
+	uint8_t entry_status;		/* Entry Status. */
+
+	uint32_t handle;		/* System handle. */
+
+	uint16_t comp_status;		/* Completion status. */
+	uint16_t ox_id;			/* OX_ID used by the firmware. */
+
+	uint32_t residual_len;		/* Residual transfer length. */
+
+	uint16_t reserved_1;
+	uint16_t state_flags;		/* State flags. */
+#define SF_TRANSFERRED_DATA	BIT_11
+#define SF_FCP_RSP_DMA		BIT_0
+
+	uint16_t reserved_2;
+	uint16_t scsi_status;		/* SCSI status. */
+#define SS_CONFIRMATION_REQ		BIT_12
+
+	uint32_t rsp_residual_count;	/* FCP RSP residual count. */
+
+	uint32_t sense_len;		/* FCP SENSE length. */
+	uint32_t rsp_data_len;		/* FCP response data length. */
+
+	uint8_t data[28];		/* FCP response/sense information. */
+};
+
+/*
+ * Status entry completion status
+ */
+#define CS_DATA_REASSEMBLY_ERROR 0x11	/* Data Reassembly Error.. */
+#define CS_ABTS_BY_TARGET	0x13	/* Target send ABTS to abort IOCB. */
+#define CS_FW_RESOURCE		0x2C	/* Firmware Resource Unavailable. */
+#define CS_TASK_MGMT_OVERRUN	0x30	/* Task management overrun (8+). */
+#define CS_ABORT_BY_TARGET	0x47	/* Abort By Target. */
+
+/*
+ * ISP queue - marker entry structure definition.
+ */
+#define MARKER_TYPE	0x04		/* Marker entry. */
+struct mrk_entry_24xx {
+	uint8_t entry_type;		/* Entry type. */
+	uint8_t entry_count;		/* Entry count. */
+	uint8_t handle_count;		/* Handle count. */
+	uint8_t entry_status;		/* Entry Status. */
+
+	uint32_t handle;		/* System handle. */
+
+	uint16_t nport_handle;		/* N_PORT handle. */
+
+	uint8_t modifier;		/* Modifier (7-0). */
+#define MK_SYNC_ID_LUN	0		/* Synchronize ID/LUN */
+#define MK_SYNC_ID	1		/* Synchronize ID */
+#define MK_SYNC_ALL	2		/* Synchronize all ID/LUN */
+	uint8_t reserved_1;
+
+	uint8_t reserved_2;
+	uint8_t vp_index;
+
+	uint16_t reserved_3;
+
+	uint8_t lun[8];			/* FCP LUN (BE). */
+	uint8_t reserved_4[40];
+};
+
+/*
+ * ISP queue - CT Pass-Through entry structure definition.
+ */
+#define CT_IOCB_TYPE		0x29	/* CT Pass-Through IOCB entry */
+struct ct_entry_24xx {
+	uint8_t entry_type;		/* Entry type. */
+	uint8_t entry_count;		/* Entry count. */
+	uint8_t sys_define;		/* System Defined. */
+	uint8_t entry_status;		/* Entry Status. */
+
+	uint32_t handle;		/* System handle. */
+
+	uint16_t comp_status;		/* Completion status. */
+
+	uint16_t nport_handle;		/* N_PORT handle. */
+
+	uint16_t cmd_dsd_count;
+
+	uint8_t vp_index;
+	uint8_t reserved_1;
+
+	uint16_t timeout;		/* Command timeout. */
+	uint16_t reserved_2;
+
+	uint16_t rsp_dsd_count;
+
+	uint8_t reserved_3[10];
+
+	uint32_t rsp_byte_count;
+	uint32_t cmd_byte_count;
+
+	uint32_t dseg_0_address[2];	/* Data segment 0 address. */
+	uint32_t dseg_0_len;		/* Data segment 0 length. */
+	uint32_t dseg_1_address[2];	/* Data segment 1 address. */
+	uint32_t dseg_1_len;		/* Data segment 1 length. */
+};
+
+/*
+ * ISP queue - ELS Pass-Through entry structure definition.
+ */
+#define ELS_IOCB_TYPE		0x53	/* ELS Pass-Through IOCB entry */
+struct els_entry_24xx {
+	uint8_t entry_type;		/* Entry type. */
+	uint8_t entry_count;		/* Entry count. */
+	uint8_t sys_define;		/* System Defined. */
+	uint8_t entry_status;		/* Entry Status. */
+
+	uint32_t handle;		/* System handle. */
+
+	uint16_t reserved_1;
+
+	uint16_t nport_handle;		/* N_PORT handle. */
+
+	uint16_t tx_dsd_count;
+
+	uint8_t vp_index;
+	uint8_t sof_type;
+#define EST_SOFI3		(1 << 4)
+#define EST_SOFI2		(3 << 4)
+
+	uint32_t rx_xchg_address[2];	/* Receive exchange address. */
+	uint16_t rx_dsd_count;
+
+	uint8_t opcode;
+	uint8_t reserved_2;
+
+	uint8_t port_id[3];
+	uint8_t reserved_3;
+
+	uint16_t reserved_4;
+
+	uint16_t control_flags;		/* Control flags. */
+#define ECF_PAYLOAD_DESCR_MASK	(BIT_15|BIT_14|BIT_13)
+#define EPD_ELS_COMMAND		(0 << 13)
+#define EPD_ELS_ACC		(1 << 13)
+#define EPD_ELS_RJT		(2 << 13)
+#define EPD_RX_XCHG		(3 << 13)
+#define ECF_CLR_PASSTHRU_PEND	BIT_12
+#define ECF_INCL_FRAME_HDR	BIT_11
+
+	uint32_t rx_byte_count;
+	uint32_t tx_byte_count;
+
+	uint32_t tx_address[2];		/* Data segment 0 address. */
+	uint32_t tx_len;		/* Data segment 0 length. */
+	uint32_t rx_address[2];		/* Data segment 1 address. */
+	uint32_t rx_len;		/* Data segment 1 length. */
+};
+
+/*
+ * ISP queue - Mailbox Command entry structure definition.
+ */
+#define MBX_IOCB_TYPE	0x39
+struct mbx_entry_24xx {
+	uint8_t entry_type;		/* Entry type. */
+	uint8_t entry_count;		/* Entry count. */
+	uint8_t handle_count;		/* Handle count. */
+	uint8_t entry_status;		/* Entry Status. */
+
+	uint32_t handle;		/* System handle. */
+
+	uint16_t mbx[28];
+};
+
+
+#define LOGINOUT_PORT_IOCB_TYPE	0x52	/* Login/Logout Port entry. */
+struct logio_entry_24xx {
+	uint8_t entry_type;		/* Entry type. */
+	uint8_t entry_count;		/* Entry count. */
+	uint8_t sys_define;		/* System defined. */
+	uint8_t entry_status;		/* Entry Status. */
+
+	uint32_t handle;		/* System handle. */
+
+	uint16_t comp_status;		/* Completion status. */
+#define CS_LOGIO_ERROR		0x31	/* Login/Logout IOCB error. */
+
+	uint16_t nport_handle;		/* N_PORT handle. */
+
+	uint16_t control_flags;		/* Control flags. */
+					/* Modifiers. */
+#define LCF_FCP2_OVERRIDE	BIT_9	/* Set/Reset word 3 of PRLI. */
+#define LCF_CLASS_2		BIT_8	/* Enable class 2 during PLOGI. */
+#define LCF_FREE_NPORT		BIT_7	/* Release NPORT handle after LOGO. */
+#define LCF_EXPL_LOGO		BIT_6	/* Perform an explicit LOGO. */
+#define LCF_SKIP_PRLI		BIT_5	/* Skip PRLI after PLOGI. */
+#define LCF_IMPL_LOGO_ALL	BIT_5	/* Implicit LOGO to all ports. */
+#define LCF_COND_PLOGI		BIT_4	/* PLOGI only if not logged-in. */
+#define LCF_IMPL_LOGO		BIT_4	/* Perform an implicit LOGO. */
+#define LCF_IMPL_PRLO		BIT_4	/* Perform an implicit PRLO. */
+					/* Commands. */
+#define LCF_COMMAND_PLOGI	0x00	/* PLOGI. */
+#define LCF_COMMAND_PRLI	0x01	/* PRLI. */
+#define LCF_COMMAND_PDISC	0x02	/* PDISC. */
+#define LCF_COMMAND_ADISC	0x03	/* ADISC. */
+#define LCF_COMMAND_LOGO	0x08	/* LOGO. */
+#define LCF_COMMAND_PRLO	0x09	/* PRLO. */
+#define LCF_COMMAND_TPRLO	0x0A	/* TPRLO. */
+
+	uint8_t vp_index;
+	uint8_t reserved_1;
+
+	uint8_t port_id[3];		/* PortID of destination port. */
+
+	uint8_t rsp_size;		/* Response size in 32bit words. */
+
+	uint32_t io_parameter[11];	/* General I/O parameters. */
+#define LSC_SCODE_NOLINK	0x01
+#define LSC_SCODE_NOIOCB	0x02
+#define LSC_SCODE_NOXCB		0x03
+#define LSC_SCODE_CMD_FAILED	0x04
+#define LSC_SCODE_NOFABRIC	0x05
+#define LSC_SCODE_FW_NOT_READY	0x07
+#define LSC_SCODE_NOT_LOGGED_IN	0x09
+#define LSC_SCODE_NOPCB		0x0A
+
+#define LSC_SCODE_ELS_REJECT	0x18
+#define LSC_SCODE_CMD_PARAM_ERR	0x19
+#define LSC_SCODE_PORTID_USED	0x1A
+#define LSC_SCODE_NPORT_USED	0x1B
+#define LSC_SCODE_NONPORT	0x1C
+#define LSC_SCODE_LOGGED_IN	0x1D
+#define LSC_SCODE_NOFLOGI_ACC	0x1F
+};
+
+#define TSK_MGMT_IOCB_TYPE	0x14
+struct tsk_mgmt_entry {
+	uint8_t entry_type;		/* Entry type. */
+	uint8_t entry_count;		/* Entry count. */
+	uint8_t handle_count;		/* Handle count. */
+	uint8_t entry_status;		/* Entry Status. */
+
+	uint32_t handle;		/* System handle. */
+
+	uint16_t nport_handle;		/* N_PORT handle. */
+
+	uint16_t reserved_1;
+
+	uint16_t delay;			/* Activity delay in seconds. */
+
+	uint16_t timeout;		/* Command timeout. */
+
+	uint8_t lun[8];			/* FCP LUN (BE). */
+
+	uint32_t control_flags;		/* Control Flags. */
+#define TCF_NOTMCMD_TO_TARGET	BIT_31
+#define TCF_LUN_RESET		BIT_4
+#define TCF_ABORT_TASK_SET	BIT_3
+#define TCF_CLEAR_TASK_SET	BIT_2
+#define TCF_TARGET_RESET	BIT_1
+#define TCF_CLEAR_ACA		BIT_0
+
+	uint8_t reserved_2[20];
+
+	uint8_t port_id[3];		/* PortID of destination port. */
+	uint8_t vp_index;
+
+	uint8_t reserved_3[12];
+};
+
+#define ABORT_IOCB_TYPE	0x33
+struct abort_entry_24xx {
+	uint8_t entry_type;		/* Entry type. */
+	uint8_t entry_count;		/* Entry count. */
+	uint8_t handle_count;		/* Handle count. */
+	uint8_t entry_status;		/* Entry Status. */
+
+	uint32_t handle;		/* System handle. */
+
+	uint16_t nport_handle;		/* N_PORT handle. */
+					/* or Completion status. */
+
+	uint16_t options;		/* Options. */
+#define AOF_NO_ABTS		BIT_0	/* Do not send any ABTS. */
+
+	uint32_t handle_to_abort;	/* System handle to abort. */
+
+	uint8_t reserved_1[32];
+
+	uint8_t port_id[3];		/* PortID of destination port. */
+	uint8_t vp_index;
+
+	uint8_t reserved_2[12];
+};
+
+/*
+ * ISP I/O Register Set structure definitions.
+ */
+struct device_reg_24xx {
+	uint32_t flash_addr;		/* Flash/NVRAM BIOS address. */
+#define FARX_DATA_FLAG	BIT_31
+#define FARX_ACCESS_FLASH_CONF	0x7FFD0000
+#define FARX_ACCESS_FLASH_DATA	0x7FF00000
+#define FARX_ACCESS_NVRAM_CONF	0x7FFF0000
+#define FARX_ACCESS_NVRAM_DATA	0x7FFE0000
+
+#define FA_NVRAM_FUNC0_ADDR	0x80
+#define FA_NVRAM_FUNC1_ADDR	0x180
+
+#define FA_NVRAM_VPD_SIZE	0x80
+#define FA_NVRAM_VPD0_ADDR	0x00
+#define FA_NVRAM_VPD1_ADDR	0x100
+					/*
+					 * RISC code begins at offset 512KB
+					 * within flash. Consisting of two
+					 * contiguous RISC code segments.
+					 */
+#define FA_RISC_CODE_ADDR	0x20000
+#define FA_RISC_CODE_SEGMENTS	2
+
+	uint32_t flash_data;		/* Flash/NVRAM BIOS data. */
+
+	uint32_t ctrl_status;		/* Control/Status. */
+#define CSRX_FLASH_ACCESS_ERROR	BIT_18	/* Flash/NVRAM Access Error. */
+#define CSRX_DMA_ACTIVE		BIT_17	/* DMA Active status. */
+#define CSRX_DMA_SHUTDOWN	BIT_16	/* DMA Shutdown control status. */
+#define CSRX_FUNCTION		BIT_15	/* Function number. */
+					/* PCI-X Bus Mode. */
+#define CSRX_PCIX_BUS_MODE_MASK	(BIT_11|BIT_10|BIT_9|BIT_8)
+#define PBM_PCI_33MHZ		(0 << 8)
+#define PBM_PCIX_M1_66MHZ	(1 << 8)
+#define PBM_PCIX_M1_100MHZ	(2 << 8)
+#define PBM_PCIX_M1_133MHZ	(3 << 8)
+#define PBM_PCIX_M2_66MHZ	(5 << 8)
+#define PBM_PCIX_M2_100MHZ	(6 << 8)
+#define PBM_PCIX_M2_133MHZ	(7 << 8)
+#define PBM_PCI_66MHZ		(8 << 8)
+					/* Max Write Burst byte count. */
+#define CSRX_MAX_WRT_BURST_MASK	(BIT_5|BIT_4)
+#define MWB_512_BYTES		(0 << 4)
+#define MWB_1024_BYTES		(1 << 4)
+#define MWB_2048_BYTES		(2 << 4)
+#define MWB_4096_BYTES		(3 << 4)
+
+#define CSRX_64BIT_SLOT		BIT_2	/* PCI 64-Bit Bus Slot. */
+#define CSRX_FLASH_ENABLE	BIT_1	/* Flash BIOS Read/Write enable. */
+#define CSRX_ISP_SOFT_RESET	BIT_0	/* ISP soft reset. */
+
+	uint32_t ictrl;			/* Interrupt control. */
+#define ICRX_EN_RISC_INT	BIT_3	/* Enable RISC interrupts on PCI. */
+
+	uint32_t istatus;		/* Interrupt status. */
+#define ISRX_RISC_INT		BIT_3	/* RISC interrupt. */
+
+	uint32_t unused_1[2];		/* Gap. */
+
+					/* Request Queue. */
+	uint32_t req_q_in;		/*  In-Pointer. */
+	uint32_t req_q_out;		/*  Out-Pointer. */
+					/* Response Queue. */
+	uint32_t rsp_q_in;		/*  In-Pointer. */
+	uint32_t rsp_q_out;		/*  Out-Pointer. */
+					/* Priority Request Queue. */
+	uint32_t preq_q_in;		/*  In-Pointer. */
+	uint32_t preq_q_out;		/*  Out-Pointer. */
+
+	uint32_t unused_2[2];		/* Gap. */
+
+					/* ATIO Queue. */
+	uint32_t atio_q_in;		/*  In-Pointer. */
+	uint32_t atio_q_out;		/*  Out-Pointer. */
+
+	uint32_t host_status;
+#define HSRX_RISC_INT		BIT_15	/* RISC to Host interrupt. */
+#define HSRX_RISC_PAUSED	BIT_8	/* RISC Paused. */
+
+	uint32_t hccr;			/* Host command & control register. */
+					/* HCCR statuses. */
+#define HCCRX_HOST_INT		BIT_6	/* Host to RISC interrupt bit. */
+#define HCCRX_RISC_RESET	BIT_5	/* RISC Reset mode bit. */
+#define HCCRX_RISC_PAUSE	BIT_4	/* RISC Pause mode bit. */
+					/* HCCR commands. */
+					/* NOOP. */
+#define HCCRX_NOOP		0x00000000
+					/* Set RISC Reset. */
+#define HCCRX_SET_RISC_RESET	0x10000000
+					/* Clear RISC Reset. */
+#define HCCRX_CLR_RISC_RESET	0x20000000
+					/* Set RISC Pause. */
+#define HCCRX_SET_RISC_PAUSE	0x30000000
+					/* Releases RISC Pause. */
+#define HCCRX_REL_RISC_PAUSE	0x40000000
+					/* Set HOST to RISC interrupt. */
+#define HCCRX_SET_HOST_INT	0x50000000
+					/* Clear HOST to RISC interrupt. */
+#define HCCRX_CLR_HOST_INT	0x60000000
+					/* Clear RISC to PCI interrupt. */
+#define HCCRX_CLR_RISC_INT	0xA0000000
+
+	uint32_t gpiod;			/* GPIO Data register. */
+					/* LED update mask. */
+#define GPDX_LED_UPDATE_MASK	(BIT_20|BIT_19|BIT_18)
+					/* Data update mask. */
+#define GPDX_DATA_UPDATE_MASK	(BIT_17|BIT_16)
+					/* LED control mask. */
+#define GPDX_LED_COLOR_MASK	(BIT_4|BIT_3|BIT_2)
+					/* LED bit values. Color names as
+					 * referenced in fw spec.
+					 */
+#define GPDX_LED_YELLOW_ON	BIT_2
+#define GPDX_LED_GREEN_ON	BIT_3
+#define GPDX_LED_AMBER_ON	BIT_4
+					/* Data in/out. */
+#define GPDX_DATA_INOUT		(BIT_1|BIT_0)
+
+	uint32_t gpioe;			/* GPIO Enable register. */
+					/* Enable update mask. */
+#define GPEX_ENABLE_UPDATE_MASK	(BIT_17|BIT_16)
+					/* Enable. */
+#define GPEX_ENABLE		(BIT_1|BIT_0)
+
+	uint32_t iobase_addr;		/* I/O Bus Base Address register. */
+
+	uint32_t unused_3[10];		/* Gap. */
+
+	uint16_t mailbox0;
+	uint16_t mailbox1;
+	uint16_t mailbox2;
+	uint16_t mailbox3;
+	uint16_t mailbox4;
+	uint16_t mailbox5;
+	uint16_t mailbox6;
+	uint16_t mailbox7;
+	uint16_t mailbox8;
+	uint16_t mailbox9;
+	uint16_t mailbox10;
+	uint16_t mailbox11;
+	uint16_t mailbox12;
+	uint16_t mailbox13;
+	uint16_t mailbox14;
+	uint16_t mailbox15;
+	uint16_t mailbox16;
+	uint16_t mailbox17;
+	uint16_t mailbox18;
+	uint16_t mailbox19;
+	uint16_t mailbox20;
+	uint16_t mailbox21;
+	uint16_t mailbox22;
+	uint16_t mailbox23;
+	uint16_t mailbox24;
+	uint16_t mailbox25;
+	uint16_t mailbox26;
+	uint16_t mailbox27;
+	uint16_t mailbox28;
+	uint16_t mailbox29;
+	uint16_t mailbox30;
+	uint16_t mailbox31;
+};
+
+/* MID Support ***************************************************************/
+
+#define MAX_MID_VPS	125
+
+struct mid_conf_entry_24xx {
+	uint16_t reserved_1;
+
+	/*
+	 * BIT 0  = Enable Hard Loop Id
+	 * BIT 1  = Acquire Loop ID in LIPA
+	 * BIT 2  = ID not Acquired
+	 * BIT 3  = Enable VP
+	 * BIT 4  = Enable Initiator Mode
+	 * BIT 5  = Disable Target Mode
+	 * BIT 6-7 = Reserved
+	 */
+	uint8_t options;
+
+	uint8_t hard_address;
+
+	uint8_t port_name[WWN_SIZE];
+	uint8_t node_name[WWN_SIZE];
+};
+
+struct mid_init_cb_24xx {
+	struct init_cb_24xx init_cb;
+
+	uint16_t count;
+	uint16_t options;
+
+	struct mid_conf_entry_24xx entries[MAX_MID_VPS];
+};
+
+
+struct mid_db_entry_24xx {
+	uint16_t status;
+#define MDBS_NON_PARTIC		BIT_3
+#define MDBS_ID_ACQUIRED	BIT_1
+#define MDBS_ENABLED		BIT_0
+
+	uint8_t options;
+	uint8_t hard_address;
+
+	uint8_t port_name[WWN_SIZE];
+	uint8_t node_name[WWN_SIZE];
+
+	uint8_t port_id[3];
+	uint8_t reserved_1;
+};
+
+struct mid_db_24xx {
+	struct mid_db_entry_24xx entries[MAX_MID_VPS];
+};
+
+#define VP_CTRL_IOCB_TYPE	0x30	/* Vitual Port Control entry. */
+struct vp_ctrl_entry_24xx {
+	uint8_t entry_type;		/* Entry type. */
+	uint8_t entry_count;		/* Entry count. */
+	uint8_t sys_define;		/* System defined. */
+	uint8_t entry_status;		/* Entry Status. */
+
+	uint32_t handle;		/* System handle. */
+
+	uint16_t vp_idx_failed;
+
+	uint16_t comp_status;		/* Completion status. */
+#define CS_VCE_ACQ_ID_ERROR	0x02	/* Error while acquireing ID. */
+#define CS_VCE_BUSY		0x05	/* Firmware not ready to accept cmd. */
+
+	uint16_t command;
+#define VCE_COMMAND_ENABLE_VPS	0x00	/* Enable VPs. */
+#define VCE_COMMAND_DISABLE_VPS	0x08	/* Disable VPs. */
+#define VCE_COMMAND_DISABLE_VPS_REINIT	0x09 /* Disable VPs and reinit link. */
+#define VCE_COMMAND_DISABLE_VPS_LOGO	0x0a /* Disable VPs and LOGO ports. */
+
+	uint16_t vp_count;
+
+	uint8_t vp_idx_map[16];
+
+	uint8_t reserved_4[32];
+};
+
+#define VP_CONFIG_IOCB_TYPE	0x31	/* Vitual Port Config entry. */
+struct vp_config_entry_24xx {
+	uint8_t entry_type;		/* Entry type. */
+	uint8_t entry_count;		/* Entry count. */
+	uint8_t sys_define;		/* System defined. */
+	uint8_t entry_status;		/* Entry Status. */
+
+	uint32_t handle;		/* System handle. */
+
+	uint16_t reserved_1;
+
+	uint16_t comp_status;		/* Completion status. */
+#define CS_VCT_STS_ERROR	0x01	/* Specified VPs were not disabled. */
+#define CS_VCT_CNT_ERROR	0x02	/* Invalid VP count. */
+#define CS_VCT_ERROR		0x03	/* Unknown error. */
+#define CS_VCT_IDX_ERROR	0x02	/* Invalid VP index. */
+#define CS_VCT_BUSY		0x05	/* Firmware not ready to accept cmd. */
+
+	uint8_t command;
+#define VCT_COMMAND_MOD_VPS	0x00	/* Enable VPs. */
+#define VCT_COMMAND_MOD_ENABLE_VPS 0x08	/* Disable VPs. */
+
+	uint8_t vp_count;
+
+	uint8_t vp_idx1;
+	uint8_t vp_idx2;
+
+	uint8_t options_idx1;
+	uint8_t hard_address_idx1;
+	uint16_t reserved_2;
+	uint8_t port_name_idx1[WWN_SIZE];
+	uint8_t node_name_idx1[WWN_SIZE];
+
+	uint8_t options_idx2;
+	uint8_t hard_address_idx2;
+	uint16_t reserved_3;
+	uint8_t port_name_idx2[WWN_SIZE];
+	uint8_t node_name_idx2[WWN_SIZE];
+
+	uint8_t reserved_4[8];
+};
+
+#define VP_RPT_ID_IOCB_TYPE	0x32	/* Report ID Acquisition entry. */
+struct vp_rpt_id_entry_24xx {
+	uint8_t entry_type;		/* Entry type. */
+	uint8_t entry_count;		/* Entry count. */
+	uint8_t sys_define;		/* System defined. */
+	uint8_t entry_status;		/* Entry Status. */
+
+	uint32_t handle;		/* System handle. */
+
+	uint16_t vp_count;		/* Format 0 -- | VP setup | VP acq |. */
+					/* Format 1 -- | VP count |. */
+	uint16_t vp_idx;		/* Format 0 -- Reserved. */
+					/* Format 1 -- VP status and index. */
+
+	uint8_t port_id[3];
+	uint8_t format;
+
+	uint8_t vp_idx_map[16];
+
+	uint8_t reserved_4[32];
+};
+
+/* END MID Support ***********************************************************/
+#endif
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -195,6 +195,7 @@ qla2100_pci_config(scsi_qla_host_t *ha)
 {
 	uint16_t w, mwi;
 	unsigned long flags;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	qla_printk(KERN_INFO, ha, "Configuring PCI space...\n");
 
@@ -215,7 +216,7 @@ qla2100_pci_config(scsi_qla_host_t *ha)
 
 	/* Get PCI bus information. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	ha->pci_attr = RD_REG_WORD(&ha->iobase->ctrl_status);
+	ha->pci_attr = RD_REG_WORD(&reg->ctrl_status);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return QLA_SUCCESS;
@@ -233,6 +234,7 @@ qla2300_pci_config(scsi_qla_host_t *ha)
 	uint16_t	w, mwi;
 	unsigned long   flags = 0;
 	uint32_t	cnt;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	qla_printk(KERN_INFO, ha, "Configuring PCI space...\n");
 
@@ -259,34 +261,32 @@ qla2300_pci_config(scsi_qla_host_t *ha)
 		spin_lock_irqsave(&ha->hardware_lock, flags);
 
 		/* Pause RISC. */
-		WRT_REG_WORD(&ha->iobase->hccr, HCCR_PAUSE_RISC);
+		WRT_REG_WORD(&reg->hccr, HCCR_PAUSE_RISC);
 		for (cnt = 0; cnt < 30000; cnt++) {
-			if ((RD_REG_WORD(&ha->iobase->hccr) &
-			    HCCR_RISC_PAUSE) != 0)
+			if ((RD_REG_WORD(&reg->hccr) & HCCR_RISC_PAUSE) != 0)
 				break;
 
 			udelay(10);
 		}
 
 		/* Select FPM registers. */
-		WRT_REG_WORD(&ha->iobase->ctrl_status, 0x20);
-		RD_REG_WORD(&ha->iobase->ctrl_status);
+		WRT_REG_WORD(&reg->ctrl_status, 0x20);
+		RD_REG_WORD(&reg->ctrl_status);
 
 		/* Get the fb rev level */
-		ha->fb_rev = RD_FB_CMD_REG(ha, ha->iobase);
+		ha->fb_rev = RD_FB_CMD_REG(ha, reg);
 
 		if (ha->fb_rev == FPM_2300)
 			w &= ~PCI_COMMAND_INVALIDATE;
 
 		/* Deselect FPM registers. */
-		WRT_REG_WORD(&ha->iobase->ctrl_status, 0x0);
-		RD_REG_WORD(&ha->iobase->ctrl_status);
+		WRT_REG_WORD(&reg->ctrl_status, 0x0);
+		RD_REG_WORD(&reg->ctrl_status);
 
 		/* Release RISC module. */
-		WRT_REG_WORD(&ha->iobase->hccr, HCCR_RELEASE_RISC);
+		WRT_REG_WORD(&reg->hccr, HCCR_RELEASE_RISC);
 		for (cnt = 0; cnt < 30000; cnt++) {
-			if ((RD_REG_WORD(&ha->iobase->hccr) &
-			    HCCR_RISC_PAUSE) == 0)
+			if ((RD_REG_WORD(&reg->hccr) & HCCR_RISC_PAUSE) == 0)
 				break;
 
 			udelay(10);
@@ -305,7 +305,7 @@ qla2300_pci_config(scsi_qla_host_t *ha)
 
 	/* Get PCI bus information. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	ha->pci_attr = RD_REG_WORD(&ha->iobase->ctrl_status);
+	ha->pci_attr = RD_REG_WORD(&reg->ctrl_status);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return QLA_SUCCESS;
@@ -352,7 +352,7 @@ void
 qla2x00_reset_chip(scsi_qla_host_t *ha) 
 {
 	unsigned long   flags = 0;
-	device_reg_t __iomem *reg = ha->iobase;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	uint32_t	cnt;
 	unsigned long	mbx_flags = 0;
 	uint16_t	cmd;
@@ -505,7 +505,7 @@ int
 qla2x00_chip_diag(scsi_qla_host_t *ha)
 {
 	int		rval;
-	device_reg_t __iomem *reg = ha->iobase;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	unsigned long	flags = 0;
 	uint16_t	data;
 	uint32_t	cnt;
@@ -889,7 +889,7 @@ qla2x00_update_fw_options(scsi_qla_host_
 void
 qla2x00_config_rings(struct scsi_qla_host *ha)
 {
-	device_reg_t __iomem *reg = ha->iobase;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	/* Setup ring parameters in initialization control block. */
 	ha->init_cb->request_q_outpointer = __constant_cpu_to_le16(0);
@@ -1196,7 +1196,7 @@ qla2x00_nvram_config(scsi_qla_host_t *ha
 	init_cb_t *icb   = ha->init_cb;
 	nvram_t *nv    = (nvram_t *)ha->request_ring;
 	uint16_t  *wptr  = (uint16_t *)ha->request_ring;
-	device_reg_t __iomem *reg = ha->iobase;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	uint8_t  timer_mode;
 
 	rval = QLA_SUCCESS;
@@ -1389,8 +1389,6 @@ qla2x00_nvram_config(scsi_qla_host_t *ha
 	/*
 	 * Set host adapter parameters.
 	 */
-	ha->nvram_version = nv->nvram_version;
-
 	ha->flags.disable_risc_code_load = ((nv->host_p[0] & BIT_4) ? 1 : 0);
 	/* Always load RISC code on non ISP2[12]00 chips. */
 	if (!IS_QLA2100(ha) && !IS_QLA2200(ha))
@@ -1410,7 +1408,8 @@ qla2x00_nvram_config(scsi_qla_host_t *ha
 	ha->serial0 = icb->port_name[5];
 	ha->serial1 = icb->port_name[6];
 	ha->serial2 = icb->port_name[7];
-	memcpy(ha->node_name, icb->node_name, WWN_SIZE);
+	ha->node_name = icb->node_name;
+	ha->port_name = icb->port_name;
 
 	icb->execution_throttle = __constant_cpu_to_le16(0xFFFF);
 
@@ -2158,7 +2157,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_ho
 	loop_id = ha->min_external_loopid;
 
 	for (; loop_id <= ha->last_loop_id; loop_id++) {
-		if (RESERVED_LOOP_ID(loop_id))
+		if (qla2x00_is_reserved_id(ha, loop_id))
 			continue;
 
 		if (atomic_read(&ha->loop_down_timer) ||
@@ -2328,7 +2327,7 @@ qla2x00_find_new_loop_id(scsi_qla_host_t
 		}
 
 		/* Skip reserved loop IDs. */
-		while (RESERVED_LOOP_ID(dev->loop_id)) {
+		while (qla2x00_is_reserved_id(ha, dev->loop_id)) {
 			dev->loop_id++;
 		}
 
@@ -2888,7 +2887,7 @@ static int
 qla2x00_restart_isp(scsi_qla_host_t *ha)
 {
 	uint8_t		status = 0;
-	device_reg_t __iomem *reg = ha->iobase;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	unsigned long	flags = 0;
 	uint32_t wait_time;
 
@@ -2901,8 +2900,6 @@ qla2x00_restart_isp(scsi_qla_host_t *ha)
 				goto done;
 			}
 
-			reg = ha->iobase;
-
 			spin_lock_irqsave(&ha->hardware_lock, flags);
 
 			/* Disable SRAM, Instruction RAM and GP RAM parity. */
@@ -2973,7 +2970,7 @@ void
 qla2x00_reset_adapter(scsi_qla_host_t *ha)
 {
 	unsigned long flags = 0;
-	device_reg_t __iomem *reg = ha->iobase;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	ha->flags.online = 0;
 	ha->isp_ops.disable_intrs(ha);
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -236,3 +236,14 @@ qla2x00_delete_timer_from_cmd(srb_t *sp)
 	}
 }
 
+
+static inline int qla2x00_is_reserved_id(scsi_qla_host_t *, uint16_t);
+static inline int
+qla2x00_is_reserved_id(scsi_qla_host_t *ha, uint16_t loop_id)
+{
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+		return (loop_id > NPH_LAST_HANDLE);
+
+	return ((loop_id > ha->last_loop_id && loop_id < SNS_FIRST_LOOP_ID) ||
+	    loop_id == MANAGEMENT_SERVER || loop_id == BROADCAST);
+};
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -315,13 +315,13 @@ qla2x00_start_scsi(srb_t *sp)
 	uint16_t	cnt;
 	uint16_t	req_cnt;
 	uint16_t	tot_dsds;
-	device_reg_t __iomem *reg;
+	struct device_reg_2xxx __iomem *reg;
 	char		tag[2];
 
 	/* Setup device pointers. */
 	ret = 0;
 	ha = sp->ha;
-	reg = ha->iobase;
+	reg = &ha->iobase->isp;
 	cmd = sp->cmd;
 	/* So we know we haven't pci_map'ed anything yet */
 	tot_dsds = 0;
@@ -521,7 +521,7 @@ qla2x00_marker(scsi_qla_host_t *ha, uint
 static request_t *
 qla2x00_req_pkt(scsi_qla_host_t *ha)
 {
-	device_reg_t __iomem *reg = ha->iobase;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	request_t	*pkt = NULL;
 	uint16_t	cnt;
 	uint32_t	*dword_ptr;
@@ -586,7 +586,7 @@ qla2x00_req_pkt(scsi_qla_host_t *ha)
 void
 qla2x00_isp_cmd(scsi_qla_host_t *ha)
 {
-	device_reg_t __iomem *reg = ha->iobase;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	DEBUG5(printk("%s(): IOCB data:\n", __func__));
 	DEBUG5(qla2x00_dump_buffer(
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -41,7 +41,7 @@ irqreturn_t
 qla2100_intr_handler(int irq, void *dev_id, struct pt_regs *regs)
 {
 	scsi_qla_host_t	*ha;
-	device_reg_t __iomem *reg;
+	struct device_reg_2xxx __iomem *reg;
 	int		status;
 	unsigned long	flags;
 	unsigned long	iter;
@@ -54,7 +54,7 @@ qla2100_intr_handler(int irq, void *dev_
 		return (IRQ_NONE);
 	}
 
-	reg = ha->iobase;
+	reg = &ha->iobase->isp;
 	status = 0;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -118,7 +118,7 @@ irqreturn_t
 qla2300_intr_handler(int irq, void *dev_id, struct pt_regs *regs)
 {
 	scsi_qla_host_t	*ha;
-	device_reg_t __iomem *reg;
+	struct device_reg_2xxx __iomem *reg;
 	int		status;
 	unsigned long	flags;
 	unsigned long	iter;
@@ -133,7 +133,7 @@ qla2300_intr_handler(int irq, void *dev_
 		return (IRQ_NONE);
 	}
 
-	reg = ha->iobase;
+	reg = &ha->iobase->isp;
 	status = 0;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -220,7 +220,7 @@ qla2x00_mbx_completion(scsi_qla_host_t *
 {
 	uint16_t	cnt;
 	uint16_t __iomem *wptr;
-	device_reg_t __iomem *reg = ha->iobase;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	/* Load return mailbox registers. */
 	ha->flags.mbox_int = 1;
@@ -261,7 +261,7 @@ qla2x00_async_event(scsi_qla_host_t *ha,
 	uint16_t	handle_cnt;
 	uint16_t	cnt;
 	uint32_t	handles[5];
-	device_reg_t __iomem *reg = ha->iobase;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	uint32_t	rscn_entry, host_pid;
 	uint8_t		rscn_queue_index;
 
@@ -707,7 +707,7 @@ qla2x00_process_completed_request(struct
 void
 qla2x00_process_response_queue(struct scsi_qla_host *ha)
 {
-	device_reg_t __iomem *reg = ha->iobase;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	sts_entry_t	*pkt;
 	uint16_t        handle_cnt;
 	uint16_t        cnt;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -58,7 +58,7 @@ qla2x00_mailbox_command(scsi_qla_host_t 
 {
 	int		rval;
 	unsigned long    flags = 0;
-	device_reg_t __iomem *reg = ha->iobase;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	struct timer_list	tmp_intr_timer;
 	uint8_t		abort_active = test_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags);
 	uint8_t		io_lock_on = ha->flags.init_done;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1089,7 +1089,7 @@ static void
 qla2x00_enable_intrs(scsi_qla_host_t *ha)
 {
 	unsigned long flags = 0;
-	device_reg_t __iomem *reg = ha->iobase;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	ha->interrupts_on = 1;
@@ -1104,7 +1104,7 @@ static void
 qla2x00_disable_intrs(scsi_qla_host_t *ha)
 {
 	unsigned long flags = 0;
-	device_reg_t __iomem *reg = ha->iobase;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	ha->interrupts_on = 0;
@@ -1120,7 +1120,7 @@ qla2x00_disable_intrs(scsi_qla_host_t *h
 int qla2x00_probe_one(struct pci_dev *pdev, struct qla_board_info *brd_info)
 {
 	int	ret = -ENODEV;
-	device_reg_t __iomem *reg;
+	struct device_reg_2xxx __iomem *reg;
 	struct Scsi_Host *host;
 	scsi_qla_host_t *ha;
 	unsigned long	flags = 0;
@@ -1300,7 +1300,7 @@ int qla2x00_probe_one(struct pci_dev *pd
 	DEBUG2(printk("DEBUG: detect hba %ld at address = %p\n",
 	    ha->host_no, ha));
 
-	reg = ha->iobase;
+	reg = &ha->iobase->isp;
 
 	ha->isp_ops.disable_intrs(ha);
 
diff --git a/drivers/scsi/qla2xxx/qla_rscn.c b/drivers/scsi/qla2xxx/qla_rscn.c
--- a/drivers/scsi/qla2xxx/qla_rscn.c
+++ b/drivers/scsi/qla2xxx/qla_rscn.c
@@ -348,7 +348,7 @@ static inline struct mbx_entry *
 qla2x00_get_mbx_iocb_entry(scsi_qla_host_t *ha, uint32_t handle)
 {
 	uint16_t cnt;
-	device_reg_t __iomem *reg = ha->iobase;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	struct mbx_entry *mbxentry;
 
 	mbxentry = NULL;
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -38,7 +38,7 @@ void
 qla2x00_lock_nvram_access(scsi_qla_host_t *ha)
 {
 	uint16_t data;
-	device_reg_t __iomem *reg = ha->iobase;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	if (!IS_QLA2100(ha) && !IS_QLA2200(ha) && !IS_QLA2300(ha)) {
 		data = RD_REG_WORD(&reg->nvram);
@@ -70,7 +70,7 @@ qla2x00_lock_nvram_access(scsi_qla_host_
 void
 qla2x00_unlock_nvram_access(scsi_qla_host_t *ha)
 {
-	device_reg_t __iomem *reg = ha->iobase;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	if (!IS_QLA2100(ha) && !IS_QLA2200(ha) && !IS_QLA2300(ha)) {
 		WRT_REG_WORD(&reg->u.isp2300.host_semaphore, 0);
@@ -85,11 +85,9 @@ qla2x00_unlock_nvram_access(scsi_qla_hos
 void
 qla2x00_release_nvram_protection(scsi_qla_host_t *ha)
 {
-	device_reg_t __iomem *reg;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	uint32_t word;
 
-	reg = ha->iobase;
-
 	/* Release NVRAM write protection. */
 	if (IS_QLA2322(ha) || IS_QLA6322(ha)) {
 		/* Write enable. */
@@ -161,7 +159,7 @@ qla2x00_write_nvram_word(scsi_qla_host_t
 	int count;
 	uint16_t word;
 	uint32_t nv_cmd;
-	device_reg_t __iomem *reg = ha->iobase;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	qla2x00_nv_write(ha, NVR_DATA_OUT);
 	qla2x00_nv_write(ha, 0);
@@ -223,7 +221,7 @@ static uint16_t
 qla2x00_nvram_request(scsi_qla_host_t *ha, uint32_t nv_cmd)
 {
 	uint8_t		cnt;
-	device_reg_t __iomem *reg = ha->iobase;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	uint16_t	data = 0;
 	uint16_t	reg_data;
 
@@ -265,7 +263,7 @@ qla2x00_nvram_request(scsi_qla_host_t *h
 static void
 qla2x00_nv_deselect(scsi_qla_host_t *ha)
 {
-	device_reg_t __iomem *reg = ha->iobase;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	WRT_REG_WORD(&reg->nvram, NVR_DESELECT);
 	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
@@ -280,7 +278,7 @@ qla2x00_nv_deselect(scsi_qla_host_t *ha)
 static void
 qla2x00_nv_write(scsi_qla_host_t *ha, uint16_t data)
 {
-	device_reg_t __iomem *reg = ha->iobase;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	WRT_REG_WORD(&reg->nvram, data | NVR_SELECT | NVR_WRT_ENABLE);
 	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */

-- 
Andrew Vasquez
