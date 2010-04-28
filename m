From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 09/11] qla4xxx: Added support for ISP82XX
Date: Wed, 28 Apr 2010 11:44:31 +0530
Message-ID: <20100428061431.GA11197@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:27881
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1753939Ab0D1GSZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Apr 2010 02:18:25 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Karen Higgins <karen.higgins@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
Signed-off-by: Karen Higgins <karen.higgins@qlogic.com>
---
 drivers/scsi/qla4xxx/Kconfig      |    4 +-
 drivers/scsi/qla4xxx/Makefile     |    2 +-
 drivers/scsi/qla4xxx/ql4_def.h    |  145 ++-
 drivers/scsi/qla4xxx/ql4_fw.h     |  144 +++-
 drivers/scsi/qla4xxx/ql4_glbl.h   |  115 ++-
 drivers/scsi/qla4xxx/ql4_init.c   |  190 ++-
 drivers/scsi/qla4xxx/ql4_inline.h |    2 +-
 drivers/scsi/qla4xxx/ql4_iocb.c   |   73 +-
 drivers/scsi/qla4xxx/ql4_isr.c    |  400 +++++-
 drivers/scsi/qla4xxx/ql4_mbx.c    |  185 ++-
 drivers/scsi/qla4xxx/ql4_nvram.c  |    2 +-
 drivers/scsi/qla4xxx/ql4_nvram.h  |    6 +-
 drivers/scsi/qla4xxx/ql4_nx.c     | 2556 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla4xxx/ql4_nx.h     |  703 ++++++++++
 drivers/scsi/qla4xxx/ql4_os.c     |  693 ++++++++---
 15 files changed, 4831 insertions(+), 389 deletions(-)
 create mode 100644 drivers/scsi/qla4xxx/ql4_nx.c
 create mode 100644 drivers/scsi/qla4xxx/ql4_nx.h

diff --git a/drivers/scsi/qla4xxx/Kconfig b/drivers/scsi/qla4xxx/Kconfig
index 69cbff3..b309851 100644
--- a/drivers/scsi/qla4xxx/Kconfig
+++ b/drivers/scsi/qla4xxx/Kconfig
@@ -3,5 +3,5 @@ config SCSI_QLA_ISCSI
 	depends on PCI && SCSI && NET
 	select SCSI_ISCSI_ATTRS
 	---help---
-	This driver supports the QLogic 40xx (ISP4XXX) iSCSI host
-	adapter family.
+	This driver supports QLogic 40xx (ISP4XXX) as well as
+	8022(ISP80XX) based adapter.
diff --git a/drivers/scsi/qla4xxx/Makefile b/drivers/scsi/qla4xxx/Makefile
index 86ea37b..0339ff0 100644
--- a/drivers/scsi/qla4xxx/Makefile
+++ b/drivers/scsi/qla4xxx/Makefile
@@ -1,5 +1,5 @@
 qla4xxx-y := ql4_os.o ql4_init.o ql4_mbx.o ql4_iocb.o ql4_isr.o \
-		ql4_nvram.o ql4_dbg.o
+		ql4_nx.o ql4_nvram.o ql4_dbg.o
 
 obj-$(CONFIG_SCSI_QLA_ISCSI) += qla4xxx.o
 
diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 4288026..4744cb2 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -33,6 +33,8 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_iscsi.h>
 
+#include "ql4_dbg.h"
+#include "ql4_nx.h"
 
 #ifndef PCI_DEVICE_ID_QLOGIC_ISP4010
 #define PCI_DEVICE_ID_QLOGIC_ISP4010	0x4010
@@ -46,6 +48,10 @@
 #define PCI_DEVICE_ID_QLOGIC_ISP4032	0x4032
 #endif
 
+#ifndef PCI_DEVICE_ID_QLOGIC_ISP8022
+#define PCI_DEVICE_ID_QLOGIC_ISP8022   0x8022
+#endif
+
 #define QLA_SUCCESS			0
 #define QLA_ERROR			1
 
@@ -86,14 +92,20 @@
 #define BIT_31	0x80000000
 
 /*
+ * Macros to help code, maintain, etc.
+ */
+#define ql4_printk(level, ha, format, arg...) \
+	dev_printk(level , &((ha)->pdev->dev) , format , ## arg)
+
+/*
  * Host adapter default definitions
  ***********************************/
 #define MAX_HBAS		16
 #define MAX_BUSES		1
-#define MAX_TARGETS		(MAX_PRST_DEV_DB_ENTRIES +  MAX_DEV_DB_ENTRIES)
+#define MAX_TARGETS		MAX_DEV_DB_ENTRIES
 #define MAX_LUNS		0xffff
 #define MAX_AEN_ENTRIES		256 /* should be > EXT_DEF_MAX_AEN_QUEUE */
-#define MAX_DDB_ENTRIES		(MAX_PRST_DEV_DB_ENTRIES + MAX_DEV_DB_ENTRIES)
+#define MAX_DDB_ENTRIES		MAX_DEV_DB_ENTRIES
 #define MAX_PDU_ENTRIES		32
 #define INVALID_ENTRY		0xFFFF
 #define MAX_CMDS_TO_RISC	1024
@@ -118,7 +130,7 @@
 #define DRIVER_NAME			"qla4xxx"
 
 #define MAX_LINKED_CMDS_PER_LUN		3
-#define MAX_REQS_SERVICED_PER_INTR	16
+#define MAX_REQS_SERVICED_PER_INTR	1
 
 #define ISCSI_IPADDR_SIZE		4	/* IP address size */
 #define ISCSI_ALIAS_SIZE		32	/* ISCSI Alias name size */
@@ -134,7 +146,7 @@
 #define SOFT_RESET_TOV			30
 #define RESET_INTR_TOV			3
 #define SEMAPHORE_TOV			10
-#define ADAPTER_INIT_TOV		120
+#define ADAPTER_INIT_TOV		30
 #define ADAPTER_RESET_TOV		180
 #define EXTEND_CMD_TOV			60
 #define WAIT_CMD_TOV			30
@@ -184,8 +196,6 @@ struct srb {
 	uint16_t iocb_tov;
 	uint16_t iocb_cnt;	/* Number of used iocbs */
 	uint16_t cc_stat;
-	u_long r_start;		/* Time we recieve a cmd from OS */
-	u_long u_start;		/* Time when we handed the cmd to F/W */
 
 	/* Used for extended sense / status continuation */
 	uint8_t *req_sense_ptr;
@@ -221,7 +231,6 @@ struct ddb_entry {
 	unsigned long dev_scan_wait_to_start_relogin;
 	unsigned long dev_scan_wait_to_complete_relogin;
 
-	uint16_t os_target_id;	/* Target ID */
 	uint16_t fw_ddb_index;	/* DDB firmware index */
 	uint16_t options;
 	uint32_t fw_ddb_device_state; /* F/W Device State  -- see ql4_fw.h */
@@ -245,7 +254,7 @@ struct ddb_entry {
 	atomic_t relogin_timer;	/* Max Time to wait for relogin to complete */
 	atomic_t relogin_retry_count; /* Num of times relogin has been
 				       * retried */
-
+	uint16_t ka_timeout;
 	uint16_t port;
 	uint32_t tpgt;
 	uint8_t ip_addr[IP_ADDR_LEN];
@@ -285,6 +294,68 @@ struct ddb_entry {
 #include "ql4_fw.h"
 #include "ql4_nvram.h"
 
+struct ql82xx_hw_data {
+	/* Offsets for flash/nvram access (set to ~0 if not used). */
+	uint32_t	flash_conf_off;
+	uint32_t	flash_data_off;
+
+	uint32_t	fdt_wrt_disable;
+	uint32_t	fdt_erase_cmd;
+	uint32_t	fdt_block_size;
+	uint32_t	fdt_unprotect_sec_cmd;
+	uint32_t	fdt_protect_sec_cmd;
+
+	uint32_t	flt_region_flt;
+	uint32_t	flt_region_fdt;
+	uint32_t	flt_region_boot;
+	uint32_t	flt_region_bootload;
+	uint32_t	flt_region_fw;
+	uint32_t	reserved;
+};
+
+struct qla82xx_legacy_intr_set {
+	uint32_t	int_vec_bit;
+	uint32_t	tgt_status_reg;
+	uint32_t	tgt_mask_reg;
+	uint32_t	pci_int_reg;
+};
+
+/* MSI-X Support */
+
+#define QLA_MSIX_DEFAULT	0x00
+#define QLA_MSIX_RSP_Q		0x01
+
+#define QLA_MSIX_ENTRIES	2
+#define QLA_MIDX_DEFAULT	0
+#define QLA_MIDX_RSP_Q		1
+
+struct ql4_msix_entry {
+	int have_irq;
+	uint16_t msix_vector;
+	uint16_t msix_entry;
+};
+
+/*
+ * ISP Operations
+ */
+struct isp_operations {
+	int  (*iospace_config) (struct scsi_qla_host *ha);
+	void (*pci_config) (struct scsi_qla_host *);
+	void (*disable_intrs) (struct scsi_qla_host *);
+	void (*enable_intrs) (struct scsi_qla_host *);
+	int  (*start_firmware) (struct scsi_qla_host *);
+	irqreturn_t (*intr_handler) (int , void *);
+	void (*interrupt_service_routine) (struct scsi_qla_host *, uint32_t);
+	int  (*reset_chip) (struct scsi_qla_host *);
+	int  (*reset_firmware) (struct scsi_qla_host *);
+	void  (*queue_iocb) (struct scsi_qla_host *);
+	void  (*complete_iocb) (struct scsi_qla_host *);
+	uint16_t (*rd_shdw_req_q_out) (struct scsi_qla_host *);
+	uint16_t (*rd_shdw_rsp_q_in) (struct scsi_qla_host *);
+	int (*get_sys_info) (struct scsi_qla_host *);
+};
+
+
 /*
  * Linux Host Adapter structure
  */
@@ -296,23 +367,32 @@ struct scsi_qla_host {
 #define AF_INIT_DONE			1 /* 0x00000002 */
 #define AF_MBOX_COMMAND			2 /* 0x00000004 */
 #define AF_MBOX_COMMAND_DONE		3 /* 0x00000008 */
+#define AF_DPC_SCHEDULED		5 /* 0x00000020 */
 #define AF_INTERRUPTS_ON		6 /* 0x00000040 */
 #define AF_GET_CRASH_RECORD		7 /* 0x00000080 */
 #define AF_LINK_UP			8 /* 0x00000100 */
 #define AF_IRQ_ATTACHED			10 /* 0x00000400 */
 #define AF_DISABLE_ACB_COMPLETE		11 /* 0x00000800 */
+#define AF_HBA_GOING_AWAY		12 /* 0x00001000 */
+#define AF_INTx_ENABLED			15 /* 0x00008000 */
+#define AF_MSI_ENABLED			16 /* 0x00010000 */
+#define AF_MSIX_ENABLED			17 /* 0x00020000 */
+#define AF_MBOX_COMMAND_NOPOLL		18 /* 0x00040000 */
 
 	unsigned long dpc_flags;
 
 #define DPC_RESET_HA			1 /* 0x00000002 */
 #define DPC_RETRY_RESET_HA		2 /* 0x00000004 */
 #define DPC_RELOGIN_DEVICE		3 /* 0x00000008 */
-#define DPC_RESET_HA_DESTROY_DDB_LIST	4 /* 0x00000010 */
+#define DPC_RESET_HA_FW_CONTEXT		4 /* 0x00000010 */
 #define DPC_RESET_HA_INTR		5 /* 0x00000020 */
 #define DPC_ISNS_RESTART		7 /* 0x00000080 */
 #define DPC_AEN				9 /* 0x00000200 */
 #define DPC_GET_DHCP_IP_ADDR		15 /* 0x00008000 */
 #define DPC_LINK_CHANGED		18 /* 0x00040000 */
+#define DPC_RESET_ACTIVE		20 /* 0x00040000 */
+#define DPC_HA_UNRECOVERABLE		21 /* 0x00080000 ISP-82xx only*/
+#define DPC_HA_NEED_QUIESCENT		22 /* 0x00100000 ISP-82xx only*/
 
 	struct Scsi_Host *host; /* pointer to host data */
 	uint32_t tot_ddbs;
@@ -375,7 +455,7 @@ struct scsi_qla_host {
 	uint8_t alias[32];
 	uint8_t name_string[256];
 	uint8_t heartbeat_interval;
-	uint8_t rsvd;
+	uint8_t rsvd2;
 
 	/* --- From FlashSysInfo --- */
 	uint8_t my_mac[MAC_ADDR_LEN];
@@ -458,7 +538,7 @@ struct scsi_qla_host {
 	uint8_t ipv4_addr_state;
 	uint16_t ipv4_options;
 
-	uint32_t resvd2;
+	uint32_t rsvd3;
 	uint32_t ipv6_options;
 	uint32_t ipv6_addl_options;
 	uint8_t ipv6_link_local_state;
@@ -469,6 +549,44 @@ struct scsi_qla_host {
 	struct in6_addr ipv6_addr0;
 	struct in6_addr ipv6_addr1;
 	struct in6_addr ipv6_default_router_addr;
+	uint16_t ifcb_size;
+
+	/* qla82xx specific fields */
+	struct device_reg_82xx  __iomem *qla82xx_reg; /* Base I/O address */
+	unsigned long nx_pcibase;       /* Base I/O address */
+	uint8_t *nx_db_rd_ptr;         /* Doorbell read pointer */
+	unsigned long nx_db_wr_ptr;     /* Door bell write pointer */
+	unsigned long first_page_group_start;
+	unsigned long first_page_group_end;
+
+	uint32_t crb_win;
+	uint32_t curr_window;
+	uint32_t ddr_mn_window;
+	unsigned long mn_win_crb;
+	unsigned long ms_win_crb;
+	int qdr_sn_window;
+	rwlock_t hw_lock;
+	uint16_t func_num;
+	int link_width;
+
+	void *rsvd4;
+	struct qla82xx_legacy_intr_set nx_legacy_intr;
+	u32 nx_crb_mask;
+
+	uint8_t revision_id;
+	uint8_t rsvd5[3];
+
+	uint32_t fw_heartbeat_counter;
+
+	struct isp_operations *isp_ops;
+	struct ql82xx_hw_data hw;
+
+	struct ql4_msix_entry msix_entries[QLA_MSIX_ENTRIES];
+
+	uint32_t nx_dev_init_timeout;
+	uint32_t nx_reset_timeout;
+
+	struct completion mbx_intr_comp;
 };
 
 static inline int is_ipv4_enabled(struct scsi_qla_host *ha)
@@ -496,6 +614,11 @@ static inline int is_qla4032(struct scsi_qla_host *ha)
 	return ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP4032;
 }
 
+static inline int is_qla8022(struct scsi_qla_host *ha)
+{
+	return ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP8022;
+}
+
 static inline int adapter_up(struct scsi_qla_host *ha)
 {
 	return (test_bit(AF_ONLINE, &ha->flags) != 0) &&
diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index 855226e..d1a5d76 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -11,7 +11,7 @@
 
 #define MAX_PRST_DEV_DB_ENTRIES		64
 #define MIN_DISC_DEV_DB_ENTRY		MAX_PRST_DEV_DB_ENTRIES
-#define MAX_DEV_DB_ENTRIES 512
+#define MAX_DEV_DB_ENTRIES		512
 
 /*************************************************************************
  *
@@ -37,6 +37,33 @@ struct host_mem_cfg_regs {
 	__le32 rsrvd1[31];	/* 0x84-0xFF */
 };
 
+/*
+ * ISP 82xx I/O Register Set structure definitions.
+ */
+struct device_reg_82xx {
+	__le32 req_q_out;	/* 0x0000 (R): Request Queue out-Pointer. */
+	__le32 reserve1[63];	/* Request Queue out-Pointer. (64 * 4) */
+	__le32 rsp_q_in;	/* 0x0100 (R/W): Response Queue In-Pointer. */
+	__le32 reserve2[63];	/* Response Queue In-Pointer. */
+	__le32 rsp_q_out;	/* 0x0200 (R/W): Response Queue Out-Pointer. */
+	__le32 reserve3[63];	/* Response Queue Out-Pointer. */
+
+	__le32 mailbox_in[8];	/* 0x0300 (R/W): Mail box In registers */
+	__le32 reserve4[24];
+	__le32 hint;		/* 0x0380 (R/W): Host interrupt register */
+#define HINT_MBX_INT_PENDING    BIT_0
+	__le32 reserve5[31];
+	__le32 mailbox_out[8];	/* 0x0400 (R): Mail box Out registers */
+	__le32 reserve6[56];
+
+	__le32 host_status;	/* Offset 0x500 (R): host status */
+#define HSRX_RISC_MB_INT        BIT_0	/* RISC to Host Mailbox interrupt */
+#define HSRX_RISC_IOCB_INT      BIT_1	/* RISC to Host IOCB interrupt */
+
+	__le32 host_int;	/* Offset 0x0504 (R/W): Interrupt status. */
+#define ISRX_82XX_RISC_INT       BIT_0	/* RISC interrupt. */
+};
+
 /*  remote register set (access via PCI memory read/write) */
 struct isp_reg {
 #define MBOX_REG_COUNT 8
@@ -206,6 +233,80 @@ union external_hw_config_reg {
 	uint32_t Asuint32_t;
 };
 
+/* 82XX Support  start */
+/* 82xx Default FLT Addresses */
+#define FA_FLASH_LAYOUT_ADDR_82                0xFC400
+#define FA_FLASH_DESCR_ADDR_82         0xFC000
+#define FA_BOOT_LOAD_ADDR_82           0x04000
+#define FA_BOOT_CODE_ADDR_82           0x20000
+#define FA_RISC_CODE_ADDR_82           0x40000
+#define FA_GOLD_RISC_CODE_ADDR_82      0x80000
+
+/* Flash Description Table ***************************************************/
+struct qla_fdt_layout {
+	uint8_t sig[4];
+	uint16_t version;
+	uint16_t len;
+	uint16_t checksum;
+	uint8_t unused1[2];
+	uint8_t model[16];
+	uint16_t man_id;
+	uint16_t id;
+	uint8_t flags;
+	uint8_t erase_cmd;
+	uint8_t alt_erase_cmd;
+	uint8_t wrt_enable_cmd;
+	uint8_t wrt_enable_bits;
+	uint8_t wrt_sts_reg_cmd;
+	uint8_t unprotect_sec_cmd;
+	uint8_t read_man_id_cmd;
+	uint32_t block_size;
+	uint32_t alt_block_size;
+	uint32_t flash_size;
+	uint32_t wrt_enable_data;
+	uint8_t read_id_addr_len;
+	uint8_t wrt_disable_bits;
+	uint8_t read_dev_id_len;
+	uint8_t chip_erase_cmd;
+	uint16_t read_timeout;
+	uint8_t protect_sec_cmd;
+	uint8_t unused2[65];
+};
+
+/* Flash Layout Table ********************************************************/
+
+struct qla_flt_location {
+	uint8_t sig[4];
+	uint16_t start_lo;
+	uint16_t start_hi;
+	uint8_t version;
+	uint8_t unused[5];
+	uint16_t checksum;
+};
+
+struct qla_flt_header {
+	uint16_t version;
+	uint16_t length;
+	uint16_t checksum;
+	uint16_t unused;
+};
+
+/* 82xx FLT Regions */
+#define FLT_REG_FDT		0x1a
+#define FLT_REG_FLT		0x1c
+#define FLT_REG_BOOTLOAD_82	0x72
+#define FLT_REG_FW_82		0x74
+#define FLT_REG_GOLD_FW_82	0x75
+#define FLT_REG_BOOT_CODE_82	0x78
+
+struct qla_flt_region {
+	uint32_t code;
+	uint32_t size;
+	uint32_t start;
+	uint32_t end;
+};
+
+
 /*************************************************************************
  *
  *		Mailbox Commands Structures and Definitions
@@ -215,6 +316,10 @@ union external_hw_config_reg {
 /*  Mailbox command definitions */
 #define MBOX_CMD_ABOUT_FW			0x0009
 #define MBOX_CMD_PING				0x000B
+#define MBOX_CMD_ENABLE_INTRS			0x0010
+#define INTR_DISABLE				0
+#define INTR_ENABLE				1
+#define MBOX_CMD_STOP_FW			0x0014
 #define MBOX_CMD_ABORT_TASK			0x0015
 #define MBOX_CMD_LUN_RESET			0x0016
 #define MBOX_CMD_TARGET_WARM_RESET		0x0017
@@ -243,6 +348,7 @@ union external_hw_config_reg {
 #define DDB_DS_LOGIN_IN_PROCESS			0x07
 #define MBOX_CMD_GET_FW_STATE			0x0069
 #define MBOX_CMD_GET_INIT_FW_CTRL_BLOCK_DEFAULTS 0x006A
+#define MBOX_CMD_GET_SYS_INFO			0x0078
 #define MBOX_CMD_RESTORE_FACTORY_DEFAULTS	0x0087
 #define MBOX_CMD_SET_ACB			0x0088
 #define MBOX_CMD_GET_ACB			0x0089
@@ -318,6 +424,19 @@ union external_hw_config_reg {
 #define MBOX_ASTS_IPSEC_SYSTEM_FATAL_ERROR	0x8022
 #define MBOX_ASTS_SUBNET_STATE_CHANGE		0x8027
 
+/* ACB Location Defines */
+#define ACB_PRIMARY                     0x00
+#define ACB_SECONDARY                   0x01
+
+/* ACB State Defines */
+#define ACB_STATE_UNCONFIGURED          0x00
+#define ACB_STATE_INVALID               0x01
+#define ACB_STATE_ACQUIRING             0x02
+#define ACB_STATE_TENTATIVE             0x03
+#define ACB_STATE_DEPRICATED            0x04
+#define ACB_STATE_VALID                 0x05
+#define ACB_STATE_DISABLING             0x06
+
 /*************************************************************************/
 
 /* Host Adapter Initialization Control Block (from host) */
@@ -558,6 +677,20 @@ struct flash_sys_info {
 	uint32_t reserved1[39]; /* 170-1ff */
 };	/* 200 */
 
+struct mbx_sys_info {
+	uint8_t board_id_str[16];   /* Keep board ID string first */
+	/* in this structure for GUI. */
+	uint16_t board_id;          /* board ID code */
+	uint16_t phys_port_cnt;     /* number of physical network ports */
+	uint16_t port_num;          /* network port for this PCI function */
+	/* (port 0 is first port) */
+	uint8_t mac_addr[6];        /* MAC address for this PCI function */
+	uint32_t iscsi_pci_func_cnt; /* number of iSCSI PCI functions */
+	uint32_t pci_func;          /* this PCI function */
+	unsigned char serial_number[16];  /* serial number string */
+	uint8_t reserved[16];
+};
+
 struct crash_record {
 	uint16_t fw_major_version;	/* 00 - 01 */
 	uint16_t fw_minor_version;	/* 02 - 03 */
@@ -814,4 +947,13 @@ struct passthru_status {
 	uint8_t res4[16];	/* 30-3F */
 };
 
+/*
+ * ISP queue - response queue entry definition.
+ */
+struct response {
+	uint8_t		data[60];
+	uint32_t	signature;
+#define RESPONSE_PROCESSED	0xDEADDEAD	/* Signature */
+};
+
 #endif /*  _QLA4X_FW_H */
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index c4636f6..cc0f2a0 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -10,31 +10,31 @@
 
 struct iscsi_cls_conn;
 
-void qla4xxx_hw_reset(struct scsi_qla_host *ha);
+int qla4xxx_hw_reset(struct scsi_qla_host *ha);
 int ql4xxx_lock_drvr_wait(struct scsi_qla_host *a);
 int qla4xxx_send_tgts(struct scsi_qla_host *ha, char *ip, uint16_t port);
-int qla4xxx_send_command_to_isp(struct scsi_qla_host *ha, struct srb * srb);
-int qla4xxx_initialize_adapter(struct scsi_qla_host * ha,
-			       uint8_t renew_ddb_list);
+int qla4xxx_send_command_to_isp(struct scsi_qla_host *ha, struct srb *srb);
+int qla4xxx_initialize_adapter(struct scsi_qla_host *ha,
+		uint8_t renew_ddb_list);
 int qla4xxx_soft_reset(struct scsi_qla_host *ha);
-irqreturn_t qla4xxx_intr_handler(int irq, void *dev_id);
 
-void qla4xxx_free_ddb_list(struct scsi_qla_host * ha);
-void qla4xxx_process_aen(struct scsi_qla_host * ha, uint8_t process_aen);
+void qla4xxx_free_ddb_list(struct scsi_qla_host *ha);
+void qla4xxx_free_ddb(struct scsi_qla_host *, struct ddb_entry *);
+void qla4xxx_process_aen(struct scsi_qla_host *ha, uint8_t process_aen);
 
-int qla4xxx_get_dhcp_ip_address(struct scsi_qla_host * ha);
-int qla4xxx_relogin_device(struct scsi_qla_host * ha,
-			   struct ddb_entry * ddb_entry);
+int qla4xxx_get_dhcp_ip_address(struct scsi_qla_host *ha);
+int qla4xxx_relogin_device(struct scsi_qla_host *ha,
+		struct ddb_entry *ddb_entry);
 int qla4xxx_abort_task(struct scsi_qla_host *ha, struct srb *srb);
-int qla4xxx_reset_lun(struct scsi_qla_host * ha, struct ddb_entry * ddb_entry,
-		      int lun);
-int qla4xxx_reset_target(struct scsi_qla_host * ha,
-			 struct ddb_entry * ddb_entry);
+int qla4xxx_reset_lun(struct scsi_qla_host *ha, struct ddb_entry *ddb_entry,
+		int lun);
+int qla4xxx_reset_target(struct scsi_qla_host *ha,
+		struct ddb_entry *ddb_entry);
 int qla4xxx_get_flash(struct scsi_qla_host * ha, dma_addr_t dma_addr,
-		      uint32_t offset, uint32_t len);
-int qla4xxx_get_firmware_status(struct scsi_qla_host * ha);
-int qla4xxx_get_firmware_state(struct scsi_qla_host * ha);
-int qla4xxx_initialize_fw_cb(struct scsi_qla_host * ha);
+		uint32_t offset, uint32_t len);
+int qla4xxx_get_firmware_status(struct scsi_qla_host *ha);
+int qla4xxx_get_firmware_state(struct scsi_qla_host *ha);
+int qla4xxx_initialize_fw_cb(struct scsi_qla_host *ha);
 
 /* FIXME: Goodness!  this really wants a small struct to hold the
  * parameters. On x86 the args will get passed on the stack! */
@@ -54,29 +54,86 @@ int qla4xxx_set_ddb_entry(struct scsi_qla_host * ha, uint16_t fw_ddb_index,
 
 void qla4xxx_mark_device_missing(struct scsi_qla_host *ha,
 				 struct ddb_entry *ddb_entry);
-u16 rd_nvram_word(struct scsi_qla_host * ha, int offset);
-void qla4xxx_get_crash_record(struct scsi_qla_host * ha);
+u16 rd_nvram_word(struct scsi_qla_host *ha, int offset);
+void qla4xxx_get_crash_record(struct scsi_qla_host *ha);
 struct ddb_entry *qla4xxx_alloc_sess(struct scsi_qla_host *ha);
 int qla4xxx_add_sess(struct ddb_entry *);
 void qla4xxx_destroy_sess(struct ddb_entry *ddb_entry);
-int qla4xxx_is_nvram_configuration_valid(struct scsi_qla_host * ha);
+int qla4xxx_is_nvram_configuration_valid(struct scsi_qla_host *ha);
 int qla4xxx_get_fw_version(struct scsi_qla_host * ha);
-void qla4xxx_interrupt_service_routine(struct scsi_qla_host * ha,
-				       uint32_t intr_status);
-int qla4xxx_init_rings(struct scsi_qla_host * ha);
-struct srb * qla4xxx_del_from_active_array(struct scsi_qla_host *ha,
-					uint32_t index);
+void qla4xxx_interrupt_service_routine(struct scsi_qla_host *ha,
+		uint32_t intr_status);
+int qla4xxx_init_rings(struct scsi_qla_host *ha);
 void qla4xxx_srb_compl(struct kref *ref);
-int qla4xxx_reinitialize_ddb_list(struct scsi_qla_host * ha);
+struct srb *qla4xxx_del_from_active_array(struct scsi_qla_host *ha,
+		uint32_t index);
+int qla4xxx_reinitialize_ddb_list(struct scsi_qla_host *ha);
 int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
 		uint32_t state, uint32_t conn_error);
 void qla4xxx_dump_buffer(void *b, uint32_t size);
 int qla4xxx_send_marker_iocb(struct scsi_qla_host *ha,
-	struct ddb_entry *ddb_entry, int lun, uint16_t mrkr_mod);
+		struct ddb_entry *ddb_entry, int lun, uint16_t mrkr_mod);
 int qla4_is_relogin_allowed(struct scsi_qla_host *ha, uint32_t conn_err);
+int qla4xxx_mailbox_command(struct scsi_qla_host *ha, uint8_t inCount,
+		uint8_t outCount, uint32_t *mbx_cmd, uint32_t *mbx_sts);
+
+void qla4xxx_queue_iocb(struct scsi_qla_host *ha);
+void qla4xxx_complete_iocb(struct scsi_qla_host *ha);
+int qla4xxx_get_sys_info(struct scsi_qla_host *ha);
+int qla4xxx_iospace_config(struct scsi_qla_host *ha);
+void qla4xxx_pci_config(struct scsi_qla_host *ha);
+int qla4xxx_start_firmware(struct scsi_qla_host *ha);
+irqreturn_t qla4xxx_intr_handler(int irq, void *dev_id);
+uint16_t qla4xxx_rd_shdw_req_q_out(struct scsi_qla_host *ha);
+uint16_t qla4xxx_rd_shdw_rsp_q_in(struct scsi_qla_host *ha);
+int qla4xxx_request_irqs(struct scsi_qla_host *ha);
+void qla4xxx_free_irqs(struct scsi_qla_host *ha);
+void qla4xxx_process_response_queue(struct scsi_qla_host *ha);
+void qla4xxx_wake_dpc(struct scsi_qla_host *ha);
+
+void qla82xx_pci_config(struct scsi_qla_host *);
+int qla82xx_iospace_config(struct scsi_qla_host *ha);
+int qla82xx_load_risc(struct scsi_qla_host *);
+irqreturn_t qla82xx_intr_handler(int irq, void *dev_id);
+void qla82xx_queue_iocb(struct scsi_qla_host *ha);
+void qla82xx_complete_iocb(struct scsi_qla_host *ha);
+
+int qla82xx_crb_win_lock(struct scsi_qla_host *);
+void qla82xx_crb_win_unlock(struct scsi_qla_host *);
+int qla82xx_pci_get_crb_addr_2M(struct scsi_qla_host *, ulong *);
+void qla82xx_wr_32(struct scsi_qla_host *, ulong, u32);
+int qla82xx_rd_32(struct scsi_qla_host *, ulong);
+int qla82xx_pci_mem_read_2M(struct scsi_qla_host *, u64, void *, int);
+int qla82xx_pci_mem_write_2M(struct scsi_qla_host *ha, u64, void *, int);
+int qla82xx_isp_reset(struct scsi_qla_host *ha);
+void qla82xx_interrupt_service_routine(struct scsi_qla_host *ha,
+		uint32_t intr_status);
+uint16_t qla82xx_rd_shdw_req_q_out(struct scsi_qla_host *ha);
+uint16_t qla82xx_rd_shdw_rsp_q_in(struct scsi_qla_host *ha);
+int qla82xx_get_sys_info(struct scsi_qla_host *ha);
+
+void qla82xx_watchdog(struct scsi_qla_host *ha);
+int qla82xx_stop_firmware(struct scsi_qla_host *ha);
+int qla82xx_get_flash_info(struct scsi_qla_host *ha);
+void qla82xx_enable_intrs(struct scsi_qla_host *ha);
+void qla82xx_disable_intrs(struct scsi_qla_host *ha);
+int qla82xx_enable_msix(struct scsi_qla_host *ha);
+void qla82xx_disable_msix(struct scsi_qla_host *ha);
+irqreturn_t qla82xx_msi_handler(int irq, void *dev_id);
+irqreturn_t qla82xx_default_intr_handler(int irq, void *dev_id);
+irqreturn_t qla82xx_msix_rsp_q(int irq, void *dev_id);
+void qla4xxx_abort_active_cmds(struct scsi_qla_host *ha, int res);
+void qla4xxx_mark_all_devices_missing(struct scsi_qla_host *ha);
+void qla4xxx_dead_adapter_cleanup(struct scsi_qla_host *ha);
+int qla82xx_idc_lock(struct scsi_qla_host *ha);
+void qla82xx_idc_unlock(struct scsi_qla_host *ha);
+int qla82xx_device_state_handler(struct scsi_qla_host *ha);
+void qla82xx_need_qsnt_handler(struct scsi_qla_host *ha);
+void qla82xx_clear_drv_active(struct scsi_qla_host *ha);
 
 extern int ql4xextended_error_logging;
 extern int ql4xdiscoverywait;
 extern int ql4xdontresethba;
-extern int ql4_mod_unload;
+extern int ql4xenablemsix;
+
 #endif /* _QLA4x_GBL_H */
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 5510df8..218408e 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -11,6 +11,10 @@
 #include "ql4_dbg.h"
 #include "ql4_inline.h"
 
+/* Link auto negotiation normally takes roughly 2 secs
+ * if we dont have link in 3 times that period, quit */
+#define QLA4XXX_LINK_UP_DELAY	6
+
 static struct ddb_entry * qla4xxx_alloc_ddb(struct scsi_qla_host *ha,
 					    uint32_t fw_ddb_index);
 
@@ -51,8 +55,8 @@ static void ql4xxx_set_mac_number(struct scsi_qla_host *ha)
  * This routine deallocates and unlinks the specified ddb_entry from the
  * adapter's
  **/
-static void qla4xxx_free_ddb(struct scsi_qla_host *ha,
-			     struct ddb_entry *ddb_entry)
+void qla4xxx_free_ddb(struct scsi_qla_host *ha,
+    struct ddb_entry *ddb_entry)
 {
 	/* Remove device entry from list */
 	list_del_init(&ddb_entry->list);
@@ -85,6 +89,25 @@ void qla4xxx_free_ddb_list(struct scsi_qla_host *ha)
 	}
 }
 
+/*
+ * qla4xxx_init_response_q_entries() - Initializes response queue entries.
+ * @ha: HA context
+ *
+ * Beginning of request ring has initialization control block already built
+ * by nvram config routine.
+ **/
+static void qla4xxx_init_response_q_entries(struct scsi_qla_host *ha)
+{
+	uint16_t cnt;
+	struct response *pkt;
+
+	pkt = (struct response *)ha->response_ptr;
+	for (cnt = 0; cnt < RESPONSE_QUEUE_DEPTH; cnt++) {
+		pkt->signature = RESPONSE_PROCESSED;
+		pkt++;
+	}
+}
+
 /**
  * qla4xxx_init_rings - initialize hw queues
  * @ha: pointer to host adapter structure.
@@ -109,19 +132,27 @@ int qla4xxx_init_rings(struct scsi_qla_host *ha)
 	ha->response_out = 0;
 	ha->response_ptr = &ha->response_ring[ha->response_out];
 
-	/*
-	 * Initialize DMA Shadow registers.  The firmware is really supposed to
-	 * take care of this, but on some uniprocessor systems, the shadow
-	 * registers aren't cleared-- causing the interrupt_handler to think
-	 * there are responses to be processed when there aren't.
-	 */
-	ha->shadow_regs->req_q_out = __constant_cpu_to_le32(0);
-	ha->shadow_regs->rsp_q_in = __constant_cpu_to_le32(0);
-	wmb();
+	if (is_qla8022(ha)) {
+		writel(0, (unsigned long  __iomem *)&ha->qla82xx_reg->req_q_out);
+		writel(0, (unsigned long  __iomem *)&ha->qla82xx_reg->rsp_q_in);
+		writel(0, (unsigned long  __iomem *)&ha->qla82xx_reg->rsp_q_out);
+	} else {
+		/*
+		 * Initialize DMA Shadow registers.  The firmware is really supposed to
+		 * take care of this, but on some uniprocessor systems, the shadow
+		 * registers aren't cleared-- causing the interrupt_handler to think
+		 * there are responses to be processed when there aren't.
+		 */
+		ha->shadow_regs->req_q_out = __constant_cpu_to_le32(0);
+		ha->shadow_regs->rsp_q_in = __constant_cpu_to_le32(0);
+		wmb();
 
-	writel(0, &ha->reg->req_q_in);
-	writel(0, &ha->reg->rsp_q_out);
-	readl(&ha->reg->rsp_q_out);
+		writel(0, &ha->reg->req_q_in);
+		writel(0, &ha->reg->rsp_q_out);
+		readl(&ha->reg->rsp_q_out);
+	}
+
+	qla4xxx_init_response_q_entries(ha);
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
@@ -129,11 +160,11 @@ int qla4xxx_init_rings(struct scsi_qla_host *ha)
 }
 
 /**
- * qla4xxx_validate_mac_address - validate adapter MAC address(es)
+ * qla4xxx_get_sys_info - validate adapter MAC address(es)
  * @ha: pointer to host adapter structure.
  *
  **/
-static int qla4xxx_validate_mac_address(struct scsi_qla_host *ha)
+int qla4xxx_get_sys_info(struct scsi_qla_host *ha)
 {
 	struct flash_sys_info *sys_info;
 	dma_addr_t sys_info_dma;
@@ -168,11 +199,11 @@ static int qla4xxx_validate_mac_address(struct scsi_qla_host *ha)
 
 	status = QLA_SUCCESS;
 
- exit_validate_mac:
+exit_validate_mac:
 	dma_free_coherent(&ha->pdev->dev, sizeof(*sys_info), sys_info,
 			  sys_info_dma);
 
- exit_validate_mac_no_free:
+exit_validate_mac_no_free:
 	return status;
 }
 
@@ -399,6 +430,7 @@ static int qla4xxx_fw_ready(struct scsi_qla_host *ha)
 		DEBUG2(printk("scsi%ld: %s: FW initialized, but "
 			      "auto-discovery still in process\n",
 			       ha->host_no, __func__));
+		ready = 1;
 	}
 
 	return ready;
@@ -453,7 +485,7 @@ static struct ddb_entry* qla4xxx_get_ddb_entry(struct scsi_qla_host *ha,
 		DEBUG2(printk("scsi%ld: %s: failed get_ddb_entry for "
 			      "fw_ddb_index %d\n", ha->host_no, __func__,
 			      fw_ddb_index));
-		return NULL;
+		goto exit_get_ddb_entry;
 	}
 
 	/* Allocate DDB if not already allocated. */
@@ -479,6 +511,7 @@ static struct ddb_entry* qla4xxx_get_ddb_entry(struct scsi_qla_host *ha,
 		ddb_entry = qla4xxx_alloc_ddb(ha, fw_ddb_index);
 	}
 
+exit_get_ddb_entry:
 	/* if not found allocate new ddb */
 	dma_free_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry), fw_ddb_entry,
 			  fw_ddb_entry_dma);
@@ -510,7 +543,7 @@ static int qla4xxx_update_ddb_entry(struct scsi_qla_host *ha,
 	if (ddb_entry == NULL) {
 		DEBUG2(printk("scsi%ld: %s: ddb_entry is NULL\n", ha->host_no,
 			      __func__));
-		goto exit_update_ddb;
+		return status;
 	}
 
 	/* Make sure the dma buffer is valid */
@@ -520,8 +553,7 @@ static int qla4xxx_update_ddb_entry(struct scsi_qla_host *ha,
 	if (fw_ddb_entry == NULL) {
 		DEBUG2(printk("scsi%ld: %s: Unable to allocate dma buffer.\n",
 			      ha->host_no, __func__));
-
-		goto exit_update_ddb;
+		return status;
 	}
 
 	if (qla4xxx_get_fwddb_entry(ha, fw_ddb_index, fw_ddb_entry,
@@ -547,6 +579,9 @@ static int qla4xxx_update_ddb_entry(struct scsi_qla_host *ha,
 	ddb_entry->default_relogin_timeout =
 		le16_to_cpu(fw_ddb_entry->def_timeout);
 	ddb_entry->default_time2wait = le16_to_cpu(fw_ddb_entry->iscsi_def_time2wait);
+	ddb_entry->ka_timeout = le16_to_cpu(fw_ddb_entry->ka_timeout);
+	if (ddb_entry->sess)
+		ddb_entry->sess->recovery_tmo = ddb_entry->ka_timeout;
 
 	/* Update index in case it changed */
 	ddb_entry->fw_ddb_index = fw_ddb_index;
@@ -580,21 +615,19 @@ static int qla4xxx_update_ddb_entry(struct scsi_qla_host *ha,
 			min(sizeof(ddb_entry->link_local_ipv6_addr),
 			sizeof(fw_ddb_entry->link_local_ipv6_addr)));
 
-		DEBUG2(dev_info(&ha->pdev->dev, "%s: DDB[%d] osIdx = %d "
-					"State %04x ConnErr %08x IP %pI6 "
+		DEBUG2(dev_info(&ha->pdev->dev, "%s: DDB[%d] State %04x"
+					" ConnErr %08x IP %pI6 "
 					":%04d \"%s\"\n",
 					__func__, fw_ddb_index,
-					ddb_entry->os_target_id,
 					ddb_entry->fw_ddb_device_state,
 					conn_err, fw_ddb_entry->ip_addr,
 					le16_to_cpu(fw_ddb_entry->port),
 					fw_ddb_entry->iscsi_name));
 	} else
-		DEBUG2(dev_info(&ha->pdev->dev, "%s: DDB[%d] osIdx = %d "
-					"State %04x ConnErr %08x IP %pI4 "
+		DEBUG2(dev_info(&ha->pdev->dev, "%s: DDB[%d] State %04x"
+					" ConnErr %08x IP %pI4 "
 					":%04d \"%s\"\n",
 					__func__, fw_ddb_index,
-					ddb_entry->os_target_id,
 					ddb_entry->fw_ddb_device_state,
 					conn_err, fw_ddb_entry->ip_addr,
 					le16_to_cpu(fw_ddb_entry->port),
@@ -688,7 +721,7 @@ int qla4_is_relogin_allowed(struct scsi_qla_host *ha, uint32_t conn_err)
  **/
 static int qla4xxx_build_ddb_list(struct scsi_qla_host *ha)
 {
-	int status = QLA_SUCCESS;
+	int status = QLA_ERROR;
 	uint32_t fw_ddb_index = 0;
 	uint32_t next_fw_ddb_index = 0;
 	uint32_t ddb_state;
@@ -704,7 +737,7 @@ static int qla4xxx_build_ddb_list(struct scsi_qla_host *ha)
 	if (fw_ddb_entry == NULL) {
 		DEBUG2(dev_info(&ha->pdev->dev, "%s: DMA alloc failed\n",
 				__func__));
-		return QLA_ERROR;
+		return status;
 	}
 
 	dev_info(&ha->pdev->dev, "Initializing DDBs ...\n");
@@ -719,7 +752,7 @@ static int qla4xxx_build_ddb_list(struct scsi_qla_host *ha)
 			DEBUG2(printk("scsi%ld: %s: get_ddb_entry, "
 				      "fw_ddb_index %d failed", ha->host_no,
 				      __func__, fw_ddb_index));
-			return QLA_ERROR;
+			goto exit_build_ddb_list;
 		}
 
 		DEBUG2(printk("scsi%ld: %s: Getting DDB[%d] ddbstate=0x%x, "
@@ -749,7 +782,7 @@ static int qla4xxx_build_ddb_list(struct scsi_qla_host *ha)
 						"get_ddb_entry %d failed\n",
 						ha->host_no,
 						__func__, fw_ddb_index));
-					return QLA_ERROR;
+					goto exit_build_ddb_list;
 				}
 			}
 		}
@@ -769,7 +802,7 @@ static int qla4xxx_build_ddb_list(struct scsi_qla_host *ha)
 			DEBUG2(printk("scsi%ld: %s: Unable to allocate memory "
 				      "for device at fw_ddb_index %d\n",
 				      ha->host_no, __func__, fw_ddb_index));
-			return QLA_ERROR;
+			goto exit_build_ddb_list;
 		}
 		/* Fill in the device structure */
 		if (qla4xxx_update_ddb_entry(ha, ddb_entry, fw_ddb_index) ==
@@ -777,11 +810,10 @@ static int qla4xxx_build_ddb_list(struct scsi_qla_host *ha)
 			ha->fw_ddb_index_map[fw_ddb_index] =
 				(struct ddb_entry *)INVALID_ENTRY;
 
-
 			DEBUG2(printk("scsi%ld: %s: update_ddb_entry failed "
 				      "for fw_ddb_index %d.\n",
 				      ha->host_no, __func__, fw_ddb_index));
-			return QLA_ERROR;
+			goto exit_build_ddb_list;
 		}
 
 next_one:
@@ -791,8 +823,13 @@ next_one:
 			break;
 	}
 
+	status = QLA_SUCCESS;
 	dev_info(&ha->pdev->dev, "DDB list done..\n");
 
+exit_build_ddb_list:
+	dma_free_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry), fw_ddb_entry,
+	    fw_ddb_entry_dma);
+
 	return status;
 }
 
@@ -876,15 +913,22 @@ static int qla4_scan_for_relogin(struct scsi_qla_host *ha,
 static int qla4xxx_devices_ready(struct scsi_qla_host *ha)
 {
 	int error;
-	unsigned long discovery_wtime;
+	unsigned long discovery_wtime = 0;
+	unsigned long link_up_wtime = 0;
 	struct qla4_relog_scan rs;
 
 	discovery_wtime = jiffies + (ql4xdiscoverywait * HZ);
+	link_up_wtime = jiffies + (QLA4XXX_LINK_UP_DELAY * HZ);
 
 	DEBUG(printk("Waiting (%d) for devices ...\n", ql4xdiscoverywait));
 	do {
 		/* poll for AEN. */
 		qla4xxx_get_firmware_state(ha);
+
+		if (!(ha->addl_fw_state & FW_ADDSTATE_LINK_UP) &&
+		    (discovery_wtime > link_up_wtime))
+			break;
+
 		if (test_and_clear_bit(DPC_AEN, &ha->dpc_flags)) {
 			/* Set time-between-relogin timer */
 			qla4xxx_process_aen(ha, RELOGIN_DDB_CHANGED_AENS);
@@ -951,6 +995,9 @@ static int qla4xxx_initialize_ddb_list(struct scsi_qla_host *ha)
 
 	qla4xxx_flush_AENS(ha);
 
+	/* Wait for an AEN */
+	qla4xxx_devices_ready(ha);
+
 	/*
 	 * First perform device discovery for active
 	 * fw ddb indexes and build
@@ -959,9 +1006,6 @@ static int qla4xxx_initialize_ddb_list(struct scsi_qla_host *ha)
 	if ((status = qla4xxx_build_ddb_list(ha)) == QLA_ERROR)
 		return status;
 
-	/* Wait for an AEN */
-	qla4xxx_devices_ready(ha);
-
 	/*
 	 * Targets can come online after the inital discovery, so processing
 	 * the aens here will catch them.
@@ -973,7 +1017,7 @@ static int qla4xxx_initialize_ddb_list(struct scsi_qla_host *ha)
 }
 
 /**
- * qla4xxx_update_ddb_list - update the driver ddb list
+ * qla4xxx_reinitialize_ddb_list - update the driver ddb list
  * @ha: pointer to host adapter structure.
  *
  * This routine obtains device information from the F/W database after
@@ -991,10 +1035,15 @@ int qla4xxx_reinitialize_ddb_list(struct scsi_qla_host *ha)
 		if (ddb_entry->fw_ddb_device_state == DDB_DS_SESSION_ACTIVE) {
 			atomic_set(&ddb_entry->state, DDB_STATE_ONLINE);
 			DEBUG2(printk ("scsi%ld: %s: ddb index [%d] marked "
-				       "ONLINE\n", ha->host_no, __func__,
-				       ddb_entry->fw_ddb_index));
-		} else if (atomic_read(&ddb_entry->state) == DDB_STATE_ONLINE)
+			    "ONLINE\n", ha->host_no, __func__,
+			    ddb_entry->fw_ddb_index));
+			iscsi_unblock_session(ddb_entry->sess);
+		} else if (atomic_read(&ddb_entry->state) == DDB_STATE_ONLINE) {
+			DEBUG2(printk("scsi:%ld: %s: Firmware ddb state is not "
+			    "active marking device missing\n",
+			    ha->host_no, __func__));
 			qla4xxx_mark_device_missing(ha, ddb_entry);
+		}
 	}
 	return status;
 }
@@ -1016,7 +1065,7 @@ int qla4xxx_relogin_device(struct scsi_qla_host *ha,
 			    (uint16_t)RELOGIN_TOV);
 	atomic_set(&ddb_entry->relogin_timer, relogin_timer);
 
-	DEBUG2(printk("scsi%ld: Relogin index [%d]. TOV=%d\n", ha->host_no,
+	DEBUG2(printk("scsi%ld: Relogin ddb [%d]. TOV=%d\n", ha->host_no,
 		      ddb_entry->fw_ddb_index, relogin_timer));
 
 	qla4xxx_set_ddb_entry(ha, ddb_entry->fw_ddb_index, 0);
@@ -1073,7 +1122,16 @@ static int qla4xxx_config_nvram(struct scsi_qla_host *ha)
 	return QLA_SUCCESS;
 }
 
-static void qla4x00_pci_config(struct scsi_qla_host *ha)
+/**
+ * qla82xx_pci_config() - Setup ISP82xx PCI configuration registers.
+ * @ha: HA context
+ */
+void qla82xx_pci_config(struct scsi_qla_host *ha)
+{
+	pci_set_master(ha->pdev);
+}
+
+void qla4xxx_pci_config(struct scsi_qla_host *ha)
 {
 	uint16_t w;
 	int status;
@@ -1204,7 +1262,7 @@ int ql4xxx_lock_drvr_wait(struct scsi_qla_host *a)
  * This routine performs the necessary steps to start the firmware for
  * the QLA4010 adapter.
  **/
-static int qla4xxx_start_firmware(struct scsi_qla_host *ha)
+int qla4xxx_start_firmware(struct scsi_qla_host *ha)
 {
 	unsigned long flags = 0;
 	uint32_t mbox_status;
@@ -1283,7 +1341,8 @@ static int qla4xxx_start_firmware(struct scsi_qla_host *ha)
 	if (soft_reset) {
 		DEBUG(printk("scsi%ld: %s: Issue Soft Reset\n", ha->host_no,
 			     __func__));
-		status = qla4xxx_soft_reset(ha);
+		status = qla4xxx_soft_reset(ha);	/* NOTE: acquires drvr
+							 * lock again, but ok */
 		if (status == QLA_ERROR) {
 			DEBUG(printk("scsi%d: %s: Soft Reset failed!\n",
 				     ha->host_no, __func__));
@@ -1304,7 +1363,6 @@ static int qla4xxx_start_firmware(struct scsi_qla_host *ha)
 
 	ql4xxx_unlock_drvr(ha);
 	if (status == QLA_SUCCESS) {
-		qla4xxx_get_fw_version(ha);
 		if (test_and_clear_bit(AF_GET_CRASH_RECORD, &ha->flags))
 			qla4xxx_get_crash_record(ha);
 	} else {
@@ -1331,18 +1389,22 @@ int qla4xxx_initialize_adapter(struct scsi_qla_host *ha,
 	int status = QLA_ERROR;
 	int8_t ip_address[IP_ADDR_LEN] = {0} ;
 
-	clear_bit(AF_ONLINE, &ha->flags);
+	DEBUG2(dev_info(&ha->pdev->dev, "%s: adapter OFFLINE\n", __func__));
 	ha->eeprom_cmd_data = 0;
 
-	qla4x00_pci_config(ha);
+	dev_info(&ha->pdev->dev, "Configuring PCI space...\n");
+	ha->isp_ops->pci_config(ha);
 
-	qla4xxx_disable_intrs(ha);
+	ha->isp_ops->disable_intrs(ha);
 
 	/* Initialize the Host adapter request/response queues and firmware */
-	if (qla4xxx_start_firmware(ha) == QLA_ERROR)
+	if (ha->isp_ops->start_firmware(ha) == QLA_ERROR)
 		goto exit_init_hba;
 
-	if (qla4xxx_validate_mac_address(ha) == QLA_ERROR)
+	if (qla4xxx_get_fw_version(ha) == QLA_ERROR)
+		goto exit_init_hba;
+
+	if (ha->isp_ops->get_sys_info(ha) == QLA_ERROR)
 		goto exit_init_hba;
 
 	if (qla4xxx_init_local_data(ha) == QLA_ERROR)
@@ -1395,6 +1457,8 @@ int qla4xxx_initialize_adapter(struct scsi_qla_host *ha,
 exit_init_online:
 	set_bit(AF_ONLINE, &ha->flags);
 exit_init_hba:
+	DEBUG2(printk("scsi%ld: initialize adapter: %s\n", ha->host_no,
+	    status == QLA_ERROR ? "FAILED" : "SUCCEDED"));
 	return status;
 }
 
@@ -1485,9 +1549,13 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
 	DEBUG2(printk("scsi%ld: %s DDB - old state= 0x%x, new state=0x%x for "
 		      "index [%d]\n", ha->host_no, __func__,
 		      ddb_entry->fw_ddb_device_state, state, fw_ddb_index));
+
 	if (old_fw_ddb_device_state == state &&
 	    state == DDB_DS_SESSION_ACTIVE) {
-		/* Do nothing, state not changed. */
+		if (atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE) {
+			atomic_set(&ddb_entry->state, DDB_STATE_ONLINE);
+			iscsi_unblock_session(ddb_entry->sess);
+		}
 		return QLA_SUCCESS;
 	}
 
@@ -1543,9 +1611,21 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
 			atomic_set(&ddb_entry->relogin_timer, 0);
 			atomic_set(&ddb_entry->retry_relogin_timer,
 				   ddb_entry->default_time2wait + 4);
+			DEBUG(printk("scsi%ld: %s: ddb[%d] "
+			    "initiate relogin after %d seconds\n",
+			    ha->host_no, __func__,
+			    ddb_entry->fw_ddb_index,
+			    ddb_entry->default_time2wait + 4));
+		} else {
+			DEBUG(printk("scsi%ld: %s:  ddb[%d] "
+			    "relogin not initiated, state=%d, "
+			    "ddb_entry->flags=0x%lx\n",
+			    ha->host_no, __func__,
+			    ddb_entry->fw_ddb_index,
+			    ddb_entry->fw_ddb_device_state,
+			    ddb_entry->flags));
 		}
 	}
-
 	return QLA_SUCCESS;
 }
 
diff --git a/drivers/scsi/qla4xxx/ql4_inline.h b/drivers/scsi/qla4xxx/ql4_inline.h
index 6375eb0..9471ac7 100644
--- a/drivers/scsi/qla4xxx/ql4_inline.h
+++ b/drivers/scsi/qla4xxx/ql4_inline.h
@@ -29,7 +29,7 @@ qla4xxx_lookup_ddb_by_fw_index(struct scsi_qla_host *ha, uint32_t fw_ddb_index)
 		ddb_entry = ha->fw_ddb_index_map[fw_ddb_index];
 	}
 
-	DEBUG3(printk("scsi%d: %s: index [%d], ddb_entry = %p\n",
+	DEBUG3(printk("scsi%d: %s: ddb [%d], ddb_entry = %p\n",
 	    ha->host_no, __func__, fw_ddb_index, ddb_entry));
 
 	return ddb_entry;
diff --git a/drivers/scsi/qla4xxx/ql4_iocb.c b/drivers/scsi/qla4xxx/ql4_iocb.c
index e66f3f2..9be822c 100644
--- a/drivers/scsi/qla4xxx/ql4_iocb.c
+++ b/drivers/scsi/qla4xxx/ql4_iocb.c
@@ -108,8 +108,7 @@ int qla4xxx_send_marker_iocb(struct scsi_qla_host *ha,
 	wmb();
 
 	/* Tell ISP it's got a new I/O request */
-	writel(ha->request_in, &ha->reg->req_q_in);
-	readl(&ha->reg->req_q_in);
+	ha->isp_ops->queue_iocb(ha);
 
 exit_send_marker:
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -194,6 +193,72 @@ static void qla4xxx_build_scsi_iocbs(struct srb *srb,
 }
 
 /**
+ * qla82xx_queue_iocb - Tell ISP it's got new request(s)
+ * @ha: pointer to host adapter structure.
+ *
+ * This routine notifies the ISP that one or more new request
+ * queue entries have been placed on the request queue.
+ **/
+void qla82xx_queue_iocb(struct scsi_qla_host *ha)
+{
+	uint32_t   dbval = 0;
+	unsigned long wtime;
+
+	dbval = 0x14 | (ha->func_num << 5);
+	dbval = dbval | (0 << 8) | (ha->request_in << 16);
+	writel(dbval, (unsigned long __iomem *)ha->nx_db_wr_ptr);
+	wmb();
+
+	wtime = jiffies + (2 * HZ);
+	while (readl(ha->nx_db_rd_ptr) != dbval &&
+	    !time_after_eq(jiffies, wtime)) {
+		writel(dbval, (unsigned long __iomem *)ha->nx_db_wr_ptr);
+		wmb();
+	}
+}
+
+/**
+ * qla82xx_complete_iocb - Tell ISP we're done with response(s)
+ * @ha: pointer to host adapter structure.
+ *
+ * This routine notifies the ISP that one or more response/completion
+ * queue entries have been processed by the driver.
+ * This also clears the interrupt.
+ **/
+void qla82xx_complete_iocb(struct scsi_qla_host *ha)
+{
+	writel(ha->response_out, &ha->qla82xx_reg->rsp_q_out);
+	readl(&ha->qla82xx_reg->rsp_q_out);
+}
+
+/**
+ * qla4xxx_queue_iocb - Tell ISP it's got new request(s)
+ * @ha: pointer to host adapter structure.
+ *
+ * This routine is notifies the ISP that one or more new request
+ * queue entries have been placed on the request queue.
+ **/
+void qla4xxx_queue_iocb(struct scsi_qla_host *ha)
+{
+	writel(ha->request_in, &ha->reg->req_q_in);
+	readl(&ha->reg->req_q_in);
+}
+
+/**
+ * qla4xxx_complete_iocb - Tell ISP we're done with response(s)
+ * @ha: pointer to host adapter structure.
+ *
+ * This routine is notifies the ISP that one or more response/completion
+ * queue entries have been processed by the driver.
+ * This also clears the interrupt.
+ **/
+void qla4xxx_complete_iocb(struct scsi_qla_host *ha)
+{
+	writel(ha->response_out, &ha->reg->rsp_q_out);
+	readl(&ha->reg->rsp_q_out);
+}
+
+/**
  * qla4xxx_send_command_to_isp - issues command to HBA
  * @ha: pointer to host adapter structure.
  * @srb: pointer to SCSI Request Block to be sent to ISP
@@ -310,9 +375,7 @@ int qla4xxx_send_command_to_isp(struct scsi_qla_host *ha, struct srb * srb)
 	srb->iocb_cnt = req_cnt;
 	ha->req_q_count -= req_cnt;
 
-	/* Debug print statements */
-	writel(ha->request_in, &ha->reg->req_q_in);
-	readl(&ha->reg->req_q_in);
+	ha->isp_ops->queue_iocb(ha);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return QLA_SUCCESS;
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 596c303..d894122 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -118,7 +118,6 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 
 	srb = qla4xxx_del_from_active_array(ha, le32_to_cpu(sts_entry->handle));
 	if (!srb) {
-		/* FIXMEdg: Don't we need to reset ISP in this case??? */
 		DEBUG2(printk(KERN_WARNING "scsi%ld: %s: Status Entry invalid "
 			      "handle 0x%x, sp=%p. This cmd may have already "
 			      "been completed.\n", ha->host_no, __func__,
@@ -293,6 +292,10 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 
 	case SCS_DEVICE_LOGGED_OUT:
 	case SCS_DEVICE_UNAVAILABLE:
+		DEBUG2(printk(KERN_INFO "scsi%ld:%d:%d:%d: SCS_DEVICE "
+			      "state: 0x%x\n", ha->host_no,
+			      cmd->device->channel, cmd->device->id,
+			      cmd->device->lun, sts_entry->completionStatus));
 		/*
 		 * Mark device missing so that we won't continue to
 		 * send I/O to this device.  We should get a ddb
@@ -339,16 +342,14 @@ status_entry_exit:
  * This routine process response queue completions in interrupt context.
  * Hardware_lock locked upon entry
  **/
-static void qla4xxx_process_response_queue(struct scsi_qla_host * ha)
+void qla4xxx_process_response_queue(struct scsi_qla_host *ha)
 {
 	uint32_t count = 0;
 	struct srb *srb = NULL;
 	struct status_entry *sts_entry;
 
 	/* Process all responses from response queue */
-	while ((ha->response_in =
-		(uint16_t)le32_to_cpu(ha->shadow_regs->rsp_q_in)) !=
-	       ha->response_out) {
+	while ((ha->response_ptr->signature != RESPONSE_PROCESSED)) {
 		sts_entry = (struct status_entry *) ha->response_ptr;
 		count++;
 
@@ -413,14 +414,14 @@ static void qla4xxx_process_response_queue(struct scsi_qla_host * ha)
 				      sts_entry->hdr.entryType));
 			goto exit_prq_error;
 		}
+		((struct response *)sts_entry)->signature = RESPONSE_PROCESSED;
+		wmb();
 	}
 
 	/*
-	 * Done with responses, update the ISP For QLA4010, this also clears
-	 * the interrupt.
+	 * Tell ISP we're done with response(s). This also clears the interrupt.
 	 */
-	writel(ha->response_out, &ha->reg->rsp_q_out);
-	readl(&ha->reg->rsp_q_out);
+	ha->isp_ops->complete_iocb(ha);
 
 	return;
 
@@ -430,8 +431,7 @@ exit_prq_invalid_handle:
 		      sts_entry->completionStatus));
 
 exit_prq_error:
-	writel(ha->response_out, &ha->reg->rsp_q_out);
-	readl(&ha->reg->rsp_q_out);
+	ha->isp_ops->complete_iocb(ha);
 
 	set_bit(DPC_RESET_HA, &ha->dpc_flags);
 }
@@ -448,7 +448,7 @@ static void qla4xxx_isr_decode_mailbox(struct scsi_qla_host * ha,
 				       uint32_t mbox_status)
 {
 	int i;
-	uint32_t mbox_stat2, mbox_stat3;
+	uint32_t mbox_sts[MBOX_AEN_REG_COUNT];
 
 	if ((mbox_status == MBOX_STS_BUSY) ||
 	    (mbox_status == MBOX_STS_INTERMEDIATE_COMPLETION) ||
@@ -460,27 +460,39 @@ static void qla4xxx_isr_decode_mailbox(struct scsi_qla_host * ha,
 			 * Copy all mailbox registers to a temporary
 			 * location and set mailbox command done flag
 			 */
-			for (i = 1; i < ha->mbox_status_count; i++)
-				ha->mbox_status[i] =
-					readl(&ha->reg->mailbox[i]);
+			for (i = 0; i < ha->mbox_status_count; i++)
+				ha->mbox_status[i] = is_qla8022(ha)
+				    ? readl(&ha->qla82xx_reg->mailbox_out[i])
+				    : readl(&ha->reg->mailbox[i]);
 
 			set_bit(AF_MBOX_COMMAND_DONE, &ha->flags);
+
+			if (test_bit(AF_MBOX_COMMAND_NOPOLL, &ha->flags))
+				complete(&ha->mbx_intr_comp);
 		}
 	} else if (mbox_status >> 12 == MBOX_ASYNC_EVENT_STATUS) {
+
+		for (i = 0; i < MBOX_AEN_REG_COUNT; i++)
+			mbox_sts[i] = is_qla8022(ha)
+				? readl(&ha->qla82xx_reg->mailbox_out[i])
+				: readl(&ha->reg->mailbox[i]);
+
 		/* Immediately process the AENs that don't require much work.
 		 * Only queue the database_changed AENs */
 		if (ha->aen_log.count < MAX_AEN_ENTRIES) {
 			for (i = 0; i < MBOX_AEN_REG_COUNT; i++)
 				ha->aen_log.entry[ha->aen_log.count].mbox_sts[i] =
-					readl(&ha->reg->mailbox[i]);
+				mbox_sts[i];
 			ha->aen_log.count++;
 		}
 		switch (mbox_status) {
 		case MBOX_ASTS_SYSTEM_ERROR:
 			/* Log Mailbox registers */
+			dev_info(&ha->pdev->dev, "%s: System Err\n", __func__);
+
 			if (ql4xdontresethba) {
-				DEBUG2(printk("%s:Dont Reset HBA\n",
-					      __func__));
+				DEBUG2(printk("scsi%ld: %s:Don't Reset HBA\n",
+					      ha->host_no, __func__));
 			} else {
 				set_bit(AF_GET_CRASH_RECORD, &ha->flags);
 				set_bit(DPC_RESET_HA, &ha->dpc_flags);
@@ -502,18 +514,15 @@ static void qla4xxx_isr_decode_mailbox(struct scsi_qla_host * ha,
 			if (test_bit(AF_INIT_DONE, &ha->flags))
 				set_bit(DPC_LINK_CHANGED, &ha->dpc_flags);
 
-			DEBUG2(printk(KERN_INFO "scsi%ld: AEN %04x Adapter"
-					" LINK UP\n", ha->host_no,
-					mbox_status));
+			dev_info(&ha->pdev->dev, "%s: LINK UP\n", __func__);
 			break;
 
 		case MBOX_ASTS_LINK_DOWN:
 			clear_bit(AF_LINK_UP, &ha->flags);
-			set_bit(DPC_LINK_CHANGED, &ha->dpc_flags);
+			if (test_bit(AF_INIT_DONE, &ha->flags))
+				set_bit(DPC_LINK_CHANGED, &ha->dpc_flags);
 
-			DEBUG2(printk(KERN_INFO "scsi%ld: AEN %04x Adapter"
-					" LINK DOWN\n", ha->host_no,
-					mbox_status));
+			dev_info(&ha->pdev->dev, "%s: LINK DOWN\n", __func__);
 			break;
 
 		case MBOX_ASTS_HEARTBEAT:
@@ -539,12 +548,17 @@ static void qla4xxx_isr_decode_mailbox(struct scsi_qla_host * ha,
 			break;
 
 		case MBOX_ASTS_IP_ADDR_STATE_CHANGED:
-			mbox_stat2 = readl(&ha->reg->mailbox[2]);
-			mbox_stat3 = readl(&ha->reg->mailbox[3]);
-
-			if ((mbox_stat3 == 5) && (mbox_stat2 == 3))
+			printk("scsi%ld: AEN %04x, mbox_sts[2]=%04x, "
+				"mbox_sts[3]=%04x\n", ha->host_no, mbox_sts[0],
+				mbox_sts[2], mbox_sts[3]);
+
+			/* mbox_sts[2] = Old ACB state
+			 * mbox_sts[3] = new ACB state */
+			if ((mbox_sts[3] == ACB_STATE_VALID) &&
+			    (mbox_sts[2] == ACB_STATE_TENTATIVE))
 				set_bit(DPC_GET_DHCP_IP_ADDR, &ha->dpc_flags);
-			else if ((mbox_stat3 == 2) && (mbox_stat2 == 5))
+			else if ((mbox_sts[3] == ACB_STATE_ACQUIRING) &&
+			    (mbox_sts[2] == ACB_STATE_VALID))
 				set_bit(DPC_RESET_HA, &ha->dpc_flags);
 			break;
 
@@ -553,9 +567,8 @@ static void qla4xxx_isr_decode_mailbox(struct scsi_qla_host * ha,
 			/* No action */
 			DEBUG2(printk(KERN_INFO "scsi%ld: AEN %04x, "
 				      "mbox_sts[1]=%04x, mbox_sts[2]=%04x\n",
-				      ha->host_no, mbox_status,
-				      readl(&ha->reg->mailbox[1]),
-				      readl(&ha->reg->mailbox[2])));
+				      ha->host_no, mbox_sts[0],
+				      mbox_sts[1], mbox_sts[2]));
 			break;
 
 		case MBOX_ASTS_SELF_TEST_FAILED:
@@ -563,10 +576,8 @@ static void qla4xxx_isr_decode_mailbox(struct scsi_qla_host * ha,
 			/* No action */
 			DEBUG2(printk("scsi%ld: AEN %04x, mbox_sts[1]=%04x, "
 				      "mbox_sts[2]=%04x, mbox_sts[3]=%04x\n",
-				      ha->host_no, mbox_status,
-				      readl(&ha->reg->mailbox[1]),
-				      readl(&ha->reg->mailbox[2]),
-				      readl(&ha->reg->mailbox[3])));
+				      ha->host_no, mbox_sts[0], mbox_sts[1],
+				      mbox_sts[2], mbox_sts[3]));
 			break;
 
 		case MBOX_ASTS_DATABASE_CHANGED:
@@ -577,21 +588,16 @@ static void qla4xxx_isr_decode_mailbox(struct scsi_qla_host * ha,
 				/* decrement available counter */
 				ha->aen_q_count--;
 
-				for (i = 1; i < MBOX_AEN_REG_COUNT; i++)
+				for (i = 0; i < MBOX_AEN_REG_COUNT; i++)
 					ha->aen_q[ha->aen_in].mbox_sts[i] =
-						readl(&ha->reg->mailbox[i]);
-
-				ha->aen_q[ha->aen_in].mbox_sts[0] = mbox_status;
+						mbox_sts[i];
 
 				/* print debug message */
 				DEBUG2(printk("scsi%ld: AEN[%d] %04x queued"
-					      " mb1:0x%x mb2:0x%x mb3:0x%x mb4:0x%x\n",
-					      ha->host_no, ha->aen_in,
-					      mbox_status,
-					      ha->aen_q[ha->aen_in].mbox_sts[1],
-					      ha->aen_q[ha->aen_in].mbox_sts[2],
-					      ha->aen_q[ha->aen_in].mbox_sts[3],
-					      ha->aen_q[ha->aen_in].  mbox_sts[4]));
+				    " mb1:0x%x mb2:0x%x mb3:0x%x mb4:0x%x\n",
+				    ha->host_no, ha->aen_in, mbox_sts[0],
+				    mbox_sts[1], mbox_sts[2],  mbox_sts[3],
+				    mbox_sts[4]));
 				/* advance pointer */
 				ha->aen_in++;
 				if (ha->aen_in == MAX_AEN_ENTRIES)
@@ -603,18 +609,16 @@ static void qla4xxx_isr_decode_mailbox(struct scsi_qla_host * ha,
 				DEBUG2(printk("scsi%ld: %s: aen %04x, queue "
 					      "overflowed!  AEN LOST!!\n",
 					      ha->host_no, __func__,
-					      mbox_status));
+					      mbox_sts[0]));
 
 				DEBUG2(printk("scsi%ld: DUMP AEN QUEUE\n",
 					      ha->host_no));
 
 				for (i = 0; i < MAX_AEN_ENTRIES; i++) {
 					DEBUG2(printk("AEN[%d] %04x %04x %04x "
-						      "%04x\n", i,
-						      ha->aen_q[i].mbox_sts[0],
-						      ha->aen_q[i].mbox_sts[1],
-						      ha->aen_q[i].mbox_sts[2],
-						      ha->aen_q[i].mbox_sts[3]));
+						      "%04x\n", i, mbox_sts[0],
+						      mbox_sts[1], mbox_sts[2],
+						      mbox_sts[3]));
 				}
 			}
 			break;
@@ -622,18 +626,42 @@ static void qla4xxx_isr_decode_mailbox(struct scsi_qla_host * ha,
 		default:
 			DEBUG2(printk(KERN_WARNING
 				      "scsi%ld: AEN %04x UNKNOWN\n",
-				      ha->host_no, mbox_status));
+				      ha->host_no, mbox_sts[0]));
 			break;
 		}
 	} else {
 		DEBUG2(printk("scsi%ld: Unknown mailbox status %08X\n",
-			      ha->host_no, mbox_status));
+			      ha->host_no, mbox_sts[0]));
 
-		ha->mbox_status[0] = mbox_status;
+		ha->mbox_status[0] = mbox_sts[0];
 	}
 }
 
 /**
+ * qla82xx_interrupt_service_routine - isr
+ * @ha: pointer to host adapter structure.
+ *
+ * This is the main interrupt service routine.
+ * hardware_lock locked upon entry. runs in interrupt context.
+ **/
+void qla82xx_interrupt_service_routine(struct scsi_qla_host *ha,
+		uint32_t intr_status)
+{
+	/* Process response queue interrupt. */
+	if (intr_status & HSRX_RISC_IOCB_INT)
+		qla4xxx_process_response_queue(ha);
+
+	/* Process mailbox/asynch event interrupt.*/
+	if (intr_status & HSRX_RISC_MB_INT)
+		qla4xxx_isr_decode_mailbox(ha,
+		    readl(&ha->qla82xx_reg->mailbox_out[0]));
+
+	/* clear the interrupt */
+	writel(0, &ha->qla82xx_reg->host_int);
+	readl(&ha->qla82xx_reg->host_int);
+}
+
+/**
  * qla4xxx_interrupt_service_routine - isr
  * @ha: pointer to host adapter structure.
  *
@@ -660,6 +688,29 @@ void qla4xxx_interrupt_service_routine(struct scsi_qla_host * ha,
 }
 
 /**
+ * qla82xx_spurious_interrupt - processes spurious interrupt
+ * @ha: pointer to host adapter structure.
+ * @reqs_count: .
+ *
+ **/
+static void qla82xx_spurious_interrupt(struct scsi_qla_host *ha,
+		uint8_t reqs_count)
+{
+	if (reqs_count)
+		return;
+
+	DEBUG2(ql4_printk(KERN_INFO, ha, "Spurious Interrupt\n"));
+	if (is_qla8022(ha)) {
+		writel(0, &ha->qla82xx_reg->host_int);
+		if (test_bit(AF_INTx_ENABLED, &ha->flags))
+			qla82xx_wr_32(ha, ha->nx_legacy_intr.tgt_mask_reg,
+					0xfbff);
+	}
+	ha->spurious_int_count++;
+
+}
+
+/**
  * qla4xxx_intr_handler - hardware interrupt handler.
  * @irq: Unused
  * @dev_id: Pointer to host adapter structure
@@ -689,15 +740,14 @@ irqreturn_t qla4xxx_intr_handler(int irq, void *dev_id)
 		/*
 		 * Read interrupt status
 		 */
-		if (le32_to_cpu(ha->shadow_regs->rsp_q_in) !=
+		if (ha->isp_ops->rd_shdw_rsp_q_in(ha) !=
 		    ha->response_out)
 			intr_status = CSR_SCSI_COMPLETION_INTR;
 		else
 			intr_status = readl(&ha->reg->ctrl_status);
 
 		if ((intr_status &
-		     (CSR_SCSI_RESET_INTR|CSR_FATAL_ERROR|INTR_PENDING)) ==
-		    0) {
+		    (CSR_SCSI_RESET_INTR|CSR_FATAL_ERROR|INTR_PENDING)) == 0) {
 			if (reqs_count == 0)
 				ha->spurious_int_count++;
 			break;
@@ -739,22 +789,166 @@ irqreturn_t qla4xxx_intr_handler(int irq, void *dev_id)
 			       &ha->reg->ctrl_status);
 			readl(&ha->reg->ctrl_status);
 
-			if (!ql4_mod_unload)
+			if (!test_bit(AF_HBA_GOING_AWAY, &ha->flags))
 				set_bit(DPC_RESET_HA_INTR, &ha->dpc_flags);
 
 			break;
 		} else if (intr_status & INTR_PENDING) {
-			qla4xxx_interrupt_service_routine(ha, intr_status);
+			ha->isp_ops->interrupt_service_routine(ha, intr_status);
 			ha->total_io_count++;
 			if (++reqs_count == MAX_REQS_SERVICED_PER_INTR)
 				break;
+		}
+	}
+
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * qla82xx_intr_handler - hardware interrupt handler.
+ * @irq: Unused
+ * @dev_id: Pointer to host adapter structure
+ **/
+irqreturn_t qla82xx_intr_handler(int irq, void *dev_id)
+{
+	struct scsi_qla_host *ha = dev_id;
+	uint32_t intr_status;
+	uint32_t status;
+	unsigned long flags = 0;
+	uint8_t reqs_count = 0;
+
+	if (!ha) {
+		DEBUG2(printk(KERN_INFO
+			"qla4xxx: Interrupt with NULL host ptr\n"));
+		return IRQ_NONE;
+	}
+
+	ha->isr_count++;
+	status = qla82xx_rd_32(ha, ISR_INT_VECTOR);
+	if (!(status & ha->nx_legacy_intr.int_vec_bit)) {
+		DEBUG2(ql4_printk(KERN_INFO, ha,
+			"%s legacy Int Vec bit not set\n", __func__));
+		return IRQ_NONE;
+	}
+
+	status = qla82xx_rd_32(ha, ISR_INT_STATE_REG);
+	if (!ISR_IS_LEGACY_INTR_TRIGGERED(status)) {
+		DEBUG2(ql4_printk(KERN_INFO, ha,
+			"%s legacy Int not triggered\n", __func__));
+		return IRQ_NONE;
+	}
+
+	/* clear the interrupt */
+	qla82xx_wr_32(ha, ha->nx_legacy_intr.tgt_status_reg, 0xffffffff);
+
+	/* read twice to ensure write is flushed */
+	qla82xx_rd_32(ha, ISR_INT_VECTOR);
+	qla82xx_rd_32(ha, ISR_INT_VECTOR);
 
-			intr_status = 0;
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	while (1) {
+		if (!(readl(&ha->qla82xx_reg->host_int) & ISRX_82XX_RISC_INT))  {
+			qla82xx_spurious_interrupt(ha, reqs_count);
+			break;
+		}
+		intr_status =  readl(&ha->qla82xx_reg->host_status);
+		if ((intr_status &
+		    (HSRX_RISC_MB_INT | HSRX_RISC_IOCB_INT)) == 0)  {
+			qla82xx_spurious_interrupt(ha, reqs_count);
+			break;
 		}
+
+		ha->isp_ops->interrupt_service_routine(ha, intr_status);
+
+		/* Enable Interrupt */
+		qla82xx_wr_32(ha, ha->nx_legacy_intr.tgt_mask_reg, 0xfbff);
+
+		if (++reqs_count == MAX_REQS_SERVICED_PER_INTR)
+			break;
 	}
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	return IRQ_HANDLED;
+}
+
+irqreturn_t
+qla82xx_msi_handler(int irq, void *dev_id)
+{
+	struct scsi_qla_host *ha;
+
+	ha = (struct scsi_qla_host *) dev_id;
+	if (!ha) {
+		DEBUG2(printk(KERN_INFO
+			"qla4xxx: MSIX: Interrupt with NULL host ptr\n"));
+		return IRQ_NONE;
+	}
+
+	ha->isr_count++;
+	/* clear the interrupt */
+	qla82xx_wr_32(ha, ha->nx_legacy_intr.tgt_status_reg, 0xffffffff);
+
+	/* read twice to ensure write is flushed */
+	qla82xx_rd_32(ha, ISR_INT_VECTOR);
+	qla82xx_rd_32(ha, ISR_INT_VECTOR);
 
+	return qla82xx_default_intr_handler(irq, dev_id);
+}
+
+/**
+ * qla82xx_default_intr_handler - hardware interrupt handler.
+ * @irq: Unused
+ * @dev_id: Pointer to host adapter structure
+ *
+ * This interrupt handler is called directly for MSI-X, and
+ * called indirectly for MSI.
+ **/
+irqreturn_t
+qla82xx_default_intr_handler(int irq, void *dev_id)
+{
+	struct scsi_qla_host *ha = dev_id;
+	unsigned long   flags;
+	uint32_t intr_status;
+	uint8_t reqs_count = 0;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	while (1) {
+		if (!(readl(&ha->qla82xx_reg->host_int) & ISRX_82XX_RISC_INT))  {
+			qla82xx_spurious_interrupt(ha, reqs_count);
+			break;
+		}
+
+		intr_status =  readl(&ha->qla82xx_reg->host_status);
+		if  ((intr_status &
+		     (HSRX_RISC_MB_INT | HSRX_RISC_IOCB_INT)) == 0)  {
+			qla82xx_spurious_interrupt(ha, reqs_count);
+			break;
+		}
+
+		ha->isp_ops->interrupt_service_routine(ha, intr_status);
+
+		if (++reqs_count == MAX_REQS_SERVICED_PER_INTR)
+			break;
+	}
+
+	ha->isr_count++;
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	return IRQ_HANDLED;
+}
+
+irqreturn_t
+qla82xx_msix_rsp_q(int irq, void *dev_id)
+{
+	struct scsi_qla_host *ha = dev_id;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	qla4xxx_process_response_queue(ha);
+	writel(0, &ha->qla82xx_reg->host_int);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	ha->isr_count++;
 	return IRQ_HANDLED;
 }
 
@@ -825,7 +1019,7 @@ void qla4xxx_process_aen(struct scsi_qla_host * ha, uint8_t process_aen)
 					((ddb_entry->default_time2wait +
 					  4) * HZ);
 
-				DEBUG2(printk("scsi%ld: ddb index [%d] initate"
+				DEBUG2(printk("scsi%ld: ddb [%d] initate"
 					      " RELOGIN after %d seconds\n",
 					      ha->host_no,
 					      ddb_entry->fw_ddb_index,
@@ -847,3 +1041,81 @@ void qla4xxx_process_aen(struct scsi_qla_host * ha, uint8_t process_aen)
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 
+int qla4xxx_request_irqs(struct scsi_qla_host *ha)
+{
+	int ret;
+
+	if (!is_qla8022(ha))
+		goto try_intx;
+
+	if (ql4xenablemsix == 2)
+		goto try_msi;
+
+	if (ql4xenablemsix == 0 || ql4xenablemsix != 1)
+		goto try_intx;
+
+	/* Trying MSI-X */
+	ret = qla82xx_enable_msix(ha);
+	if (!ret) {
+		DEBUG2(ql4_printk(KERN_INFO, ha,
+			"MSI-X: Enabled (0x%X).\n", ha->revision_id));
+		goto irq_attached;
+	}
+
+	ql4_printk(KERN_WARNING, ha,
+		"MSI-X: Falling back-to MSI mode -- %d.\n", ret);
+
+try_msi:
+	/* Trying MSI */
+	ret = pci_enable_msi(ha->pdev);
+	if (!ret) {
+		ret = request_irq(ha->pdev->irq, qla82xx_msi_handler,
+				IRQF_DISABLED|IRQF_SHARED, DRIVER_NAME, ha);
+		if (!ret) {
+			DEBUG2(ql4_printk(KERN_INFO, ha, "MSI: Enabled.\n"));
+			set_bit(AF_MSI_ENABLED, &ha->flags);
+			goto irq_attached;
+		} else {
+			ql4_printk(KERN_WARNING, ha,
+				"MSI: Failed to reserve interrupt %d "
+				"already in use.\n", ha->pdev->irq);
+			pci_disable_msi(ha->pdev);
+		}
+	}
+	ql4_printk(KERN_WARNING, ha,
+		"MSI: Falling back-to INTx mode -- %d.\n", ret);
+
+try_intx:
+	/* Trying INTx */
+	ret = request_irq(ha->pdev->irq, ha->isp_ops->intr_handler,
+			IRQF_DISABLED|IRQF_SHARED, DRIVER_NAME, ha);
+	if (!ret) {
+		DEBUG2(ql4_printk(KERN_INFO, ha, "INTx: Enabled.\n"));
+		set_bit(AF_INTx_ENABLED, &ha->flags);
+		goto irq_attached;
+
+	} else {
+		ql4_printk(KERN_WARNING, ha,
+			"INTx: Failed to reserve interrupt %d already in"
+			" use.\n", ha->pdev->irq);
+		return ret;
+	}
+
+irq_attached:
+	set_bit(AF_IRQ_ATTACHED, &ha->flags);
+	ha->host->irq = ha->pdev->irq;
+	dev_info(&ha->pdev->dev, "%s: irq %d attached\n",
+			__func__, ha->pdev->irq);
+	return ret;
+}
+
+void qla4xxx_free_irqs(struct scsi_qla_host *ha)
+{
+	if (test_bit(AF_MSIX_ENABLED, &ha->flags))
+		qla82xx_disable_msix(ha);
+	else if (test_and_clear_bit(AF_MSI_ENABLED, &ha->flags)) {
+		free_irq(ha->pdev->irq, ha);
+		pci_disable_msi(ha->pdev);
+	} else if (test_and_clear_bit(AF_INTx_ENABLED, &ha->flags))
+		free_irq(ha->pdev->irq, ha);
+}
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 75496fb..40a331c 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -19,11 +19,11 @@
  * @mbx_cmd: data pointer for mailbox in registers.
  * @mbx_sts: data pointer for mailbox out registers.
  *
- * This routine sssue mailbox commands and waits for completion.
+ * This routine isssue mailbox commands and waits for completion.
  * If outCount is 0, this routine completes successfully WITHOUT waiting
  * for the mailbox command to complete.
  **/
-static int qla4xxx_mailbox_command(struct scsi_qla_host *ha, uint8_t inCount,
+int qla4xxx_mailbox_command(struct scsi_qla_host *ha, uint8_t inCount,
 				   uint8_t outCount, uint32_t *mbx_cmd,
 				   uint32_t *mbx_sts)
 {
@@ -59,16 +59,34 @@ static int qla4xxx_mailbox_command(struct scsi_qla_host *ha, uint8_t inCount,
 	}
 
 	/* To prevent overwriting mailbox registers for a command that has
-	 * not yet been serviced, check to see if a previously issued
-	 * mailbox command is interrupting.
+	 * not yet been serviced, check to see if an active command
+	 * (AEN, IOCB, etc.) is interrupting, then service it.
 	 * -----------------------------------------------------------------
 	 */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	intr_status = readl(&ha->reg->ctrl_status);
-	if (intr_status & CSR_SCSI_PROCESSOR_INTR) {
-		/* Service existing interrupt */
-		qla4xxx_interrupt_service_routine(ha, intr_status);
-		clear_bit(AF_MBOX_COMMAND_DONE, &ha->flags);
+	if (is_qla8022(ha)) {
+		intr_status = readl(&ha->qla82xx_reg->host_int);
+		if (intr_status & ISRX_82XX_RISC_INT) {
+			/* Service existing interrupt */
+			DEBUG2(printk("scsi%ld: %s: "
+				"servicing existing interrupt\n",
+				ha->host_no, __func__));
+			intr_status = readl(&ha->qla82xx_reg->host_status);
+			ha->isp_ops->interrupt_service_routine(ha, intr_status);
+			clear_bit(AF_MBOX_COMMAND_DONE, &ha->flags);
+			if (test_bit(AF_INTERRUPTS_ON, &ha->flags) &&
+			    test_bit(AF_INTx_ENABLED, &ha->flags))
+				qla82xx_wr_32(ha,
+					ha->nx_legacy_intr.tgt_mask_reg,
+					0xfbff);
+		}
+	} else {
+		intr_status = readl(&ha->reg->ctrl_status);
+		if (intr_status & CSR_SCSI_PROCESSOR_INTR) {
+			/* Service existing interrupt */
+			ha->isp_ops->interrupt_service_routine(ha, intr_status);
+			clear_bit(AF_MBOX_COMMAND_DONE, &ha->flags);
+		}
 	}
 
 	/* Send the mailbox command to the firmware */
@@ -76,15 +94,31 @@ static int qla4xxx_mailbox_command(struct scsi_qla_host *ha, uint8_t inCount,
 	for (i = 0; i < outCount; i++)
 		ha->mbox_status[i] = 0;
 
-	/* Load all mailbox registers, except mailbox 0. */
-	for (i = 1; i < inCount; i++)
-		writel(mbx_cmd[i], &ha->reg->mailbox[i]);
-
-	/* Wakeup firmware  */
-	writel(mbx_cmd[0], &ha->reg->mailbox[0]);
-	readl(&ha->reg->mailbox[0]);
-	writel(set_rmask(CSR_INTR_RISC), &ha->reg->ctrl_status);
-	readl(&ha->reg->ctrl_status);
+	if (is_qla8022(ha)) {
+		/* Load all mailbox registers, except mailbox 0. */
+		#if defined(QL_DEBUG_LEVEL_5)
+		DEBUG5(printk("scsi%ld: %s: Cmd ", ha->host_no, __func__));
+		for (i = 0; i < inCount; i++)
+			DEBUG2(printk("mb%d=%04x ", i, mbx_cmd[i]));
+		DEBUG5(printk("\n"));
+		#endif
+
+		for (i = 1; i < inCount; i++)
+			writel(mbx_cmd[i], &ha->qla82xx_reg->mailbox_in[i]);
+		writel(mbx_cmd[0], &ha->qla82xx_reg->mailbox_in[0]);
+		readl(&ha->qla82xx_reg->mailbox_in[0]);
+		writel(HINT_MBX_INT_PENDING, &ha->qla82xx_reg->hint);
+	} else {
+		/* Load all mailbox registers, except mailbox 0. */
+		for (i = 1; i < inCount; i++)
+			writel(mbx_cmd[i], &ha->reg->mailbox[i]);
+
+		/* Wakeup firmware  */
+		writel(mbx_cmd[0], &ha->reg->mailbox[0]);
+		readl(&ha->reg->mailbox[0]);
+		writel(set_rmask(CSR_INTR_RISC), &ha->reg->ctrl_status);
+		readl(&ha->reg->ctrl_status);
+	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	/* Wait for completion */
@@ -98,26 +132,65 @@ static int qla4xxx_mailbox_command(struct scsi_qla_host *ha, uint8_t inCount,
 		status = QLA_SUCCESS;
 		goto mbox_exit;
 	}
-	/* Wait for command to complete */
-	wait_count = jiffies + MBOX_TOV * HZ;
-	while (test_bit(AF_MBOX_COMMAND_DONE, &ha->flags) == 0) {
-		if (time_after_eq(jiffies, wait_count))
-			break;
-
-		spin_lock_irqsave(&ha->hardware_lock, flags);
-		intr_status = readl(&ha->reg->ctrl_status);
-		if (intr_status & INTR_PENDING) {
+	/*
+	 * Wait for completion: Poll or completion queue
+	 */
+	if (test_bit(AF_IRQ_ATTACHED, &ha->flags) &&
+	    test_bit(AF_INTERRUPTS_ON, &ha->flags) &&
+	    test_bit(AF_ONLINE, &ha->flags) &&
+	    !test_bit(AF_HBA_GOING_AWAY, &ha->flags)) {
+		/* Do not poll for completion. Use completion queue */
+		set_bit(AF_MBOX_COMMAND_NOPOLL, &ha->flags);
+		wait_for_completion_timeout(&ha->mbx_intr_comp, MBOX_TOV * HZ);
+		clear_bit(AF_MBOX_COMMAND_NOPOLL, &ha->flags);
+	} else {
+		/* Poll for command to complete */
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		wait_count = jiffies + MBOX_TOV * HZ;
+		while (test_bit(AF_MBOX_COMMAND_DONE, &ha->flags) == 0) {
+			if (time_after_eq(jiffies, wait_count))
+				break;
+			/* Check for IOCB and MBX Interrpt ?? */
 			/*
 			 * Service the interrupt.
 			 * The ISR will save the mailbox status registers
 			 * to a temporary storage location in the adapter
 			 * structure.
 			 */
-			ha->mbox_status_count = outCount;
-			qla4xxx_interrupt_service_routine(ha, intr_status);
+
+			spin_lock_irqsave(&ha->hardware_lock, flags);
+			if (is_qla8022(ha)) {
+				intr_status = readl(&ha->qla82xx_reg->host_int);
+				if (intr_status & ISRX_82XX_RISC_INT) {
+					ha->mbox_status_count = outCount;
+					intr_status =
+					    readl(&ha->qla82xx_reg->host_status);
+					ha->isp_ops->interrupt_service_routine(ha,
+					    intr_status);
+					if (test_bit(AF_INTERRUPTS_ON, &ha->flags) &&
+					    test_bit(AF_INTx_ENABLED, &ha->flags))
+						qla82xx_wr_32(ha,
+						    ha->nx_legacy_intr.tgt_mask_reg,
+						    0xfbff);
+				}
+			} else {
+				intr_status = readl(&ha->reg->ctrl_status);
+				if (intr_status & INTR_PENDING) {
+					/*
+					 * Service the interrupt.
+					 * The ISR will save the mailbox status
+					 * registers to a temporary storage
+					 * location in the adapter structure.
+					 */
+					ha->mbox_status_count = outCount;
+					ha->isp_ops->interrupt_service_routine(ha,
+							intr_status);
+				}
+			}
+			spin_unlock_irqrestore(&ha->hardware_lock, flags);
+			msleep(10);
 		}
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
-		msleep(10);
+		set_current_state(TASK_RUNNING);
 	}
 
 	/* Check for mailbox timeout. */
@@ -271,7 +344,7 @@ qla4xxx_update_local_ifcb(struct scsi_qla_host *ha,
 		return QLA_ERROR;
 	}
 
-	DEBUG2(qla4xxx_dump_buffer(init_fw_cb, sizeof(struct addr_ctrl_blk)));
+	DEBUG3(qla4xxx_dump_buffer(init_fw_cb, sizeof(struct addr_ctrl_blk)));
 
 	/* Save some info in adapter structure. */
 	ha->acb_version = init_fw_cb->acb_version;
@@ -317,7 +390,7 @@ int qla4xxx_initialize_fw_cb(struct scsi_qla_host * ha)
 	if (init_fw_cb == NULL) {
 		DEBUG2(printk("scsi%ld: %s: Unable to alloc init_cb\n",
 			      ha->host_no, __func__));
-		return 10;
+		return status;
 	}
 	memset(init_fw_cb, 0, sizeof(struct addr_ctrl_blk));
 
@@ -387,6 +460,7 @@ int qla4xxx_get_dhcp_ip_address(struct scsi_qla_host * ha)
 	dma_addr_t init_fw_cb_dma;
 	uint32_t mbox_cmd[MBOX_REG_COUNT];
 	uint32_t mbox_sts[MBOX_REG_COUNT];
+	uint8_t status = QLA_ERROR;
 
 	init_fw_cb = dma_alloc_coherent(&ha->pdev->dev,
 					sizeof(struct addr_ctrl_blk),
@@ -394,7 +468,7 @@ int qla4xxx_get_dhcp_ip_address(struct scsi_qla_host * ha)
 	if (init_fw_cb == NULL) {
 		printk("scsi%ld: %s: Unable to alloc init_cb\n", ha->host_no,
 		       __func__);
-		return 10;
+		return status;
 	}
 
 	/* Get Initialize Firmware Control Block. */
@@ -403,18 +477,18 @@ int qla4xxx_get_dhcp_ip_address(struct scsi_qla_host * ha)
 	    QLA_SUCCESS) {
 		DEBUG2(printk("scsi%ld: %s: Failed to get init_fw_ctrl_blk\n",
 			      ha->host_no, __func__));
-		dma_free_coherent(&ha->pdev->dev,
-				  sizeof(struct addr_ctrl_blk),
-				  init_fw_cb, init_fw_cb_dma);
-		return QLA_ERROR;
+		goto exit_get_dhcp_ip_address;
 	}
 
 	/* Save IP Address. */
 	qla4xxx_update_local_ip(ha, init_fw_cb);
+
+	status = QLA_SUCCESS;
+exit_get_dhcp_ip_address:
 	dma_free_coherent(&ha->pdev->dev, sizeof(struct addr_ctrl_blk),
 				init_fw_cb, init_fw_cb_dma);
 
-	return QLA_SUCCESS;
+	return status;
 }
 
 /**
@@ -442,10 +516,8 @@ int qla4xxx_get_firmware_state(struct scsi_qla_host * ha)
 	ha->firmware_state = mbox_sts[1];
 	ha->board_id = mbox_sts[2];
 	ha->addl_fw_state = mbox_sts[3];
-	DEBUG2(printk("scsi%ld: %s firmware_state=0x%x\n",
-		      ha->host_no, __func__, ha->firmware_state);)
 
-		return QLA_SUCCESS;
+	return QLA_SUCCESS;
 }
 
 /**
@@ -470,6 +542,10 @@ int qla4xxx_get_firmware_status(struct scsi_qla_host * ha)
 			      mbox_sts[0]));
 		return QLA_ERROR;
 	}
+
+	dev_info(&ha->pdev->dev, "%ld firmare IOCBs available (%d).\n",
+	    ha->host_no, mbox_cmd[2]);
+
 	return QLA_SUCCESS;
 }
 
@@ -500,7 +576,7 @@ int qla4xxx_get_fwddb_entry(struct scsi_qla_host *ha,
 
 	/* Make sure the device index is valid */
 	if (fw_ddb_index >= MAX_DDB_ENTRIES) {
-		DEBUG2(printk("scsi%ld: %s: index [%d] out of range.\n",
+		DEBUG2(printk("scsi%ld: %s: ddb [%d] out of range.\n",
 			      ha->host_no, __func__, fw_ddb_index));
 		goto exit_get_fwddb;
 	}
@@ -521,7 +597,7 @@ int qla4xxx_get_fwddb_entry(struct scsi_qla_host *ha,
 		goto exit_get_fwddb;
 	}
 	if (fw_ddb_index != mbox_sts[1]) {
-		DEBUG2(printk("scsi%ld: %s: index mismatch [%d] != [%d].\n",
+		DEBUG2(printk("scsi%ld: %s: ddb mismatch [%d] != [%d].\n",
 			      ha->host_no, __func__, fw_ddb_index,
 			      mbox_sts[1]));
 		goto exit_get_fwddb;
@@ -590,6 +666,7 @@ int qla4xxx_set_ddb_entry(struct scsi_qla_host * ha, uint16_t fw_ddb_index,
 {
 	uint32_t mbox_cmd[MBOX_REG_COUNT];
 	uint32_t mbox_sts[MBOX_REG_COUNT];
+	int status;
 
 	/* Do not wait for completion. The firmware will send us an
 	 * ASTS_DATABASE_CHANGED (0x8014) to notify us of the login status.
@@ -603,7 +680,12 @@ int qla4xxx_set_ddb_entry(struct scsi_qla_host * ha, uint16_t fw_ddb_index,
 	mbox_cmd[3] = MSDW(fw_ddb_entry_dma);
 	mbox_cmd[4] = sizeof(struct dev_db_entry);
 
-	return qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 1, &mbox_cmd[0], &mbox_sts[0]);
+	status = qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 5, &mbox_cmd[0],
+			&mbox_sts[0]);
+	DEBUG2(printk("scsi%ld: %s: status=%d mbx0=0x%x mbx4=0x%x\n",
+		ha->host_no, __func__, status, mbox_sts[0], mbox_sts[4]);)
+
+	return status;
 }
 
 /**
@@ -817,8 +899,8 @@ int qla4xxx_abort_task(struct scsi_qla_host *ha, struct srb *srb)
 /**
  * qla4xxx_reset_lun - issues LUN Reset
  * @ha: Pointer to host adapter structure.
- * @db_entry: Pointer to device database entry
- * @un_entry: Pointer to lun entry structure
+ * @ddb_entry: Pointer to device database entry
+ * @lun: lun number
  *
  * This routine performs a LUN RESET on the specified target/lun.
  * The caller must ensure that the ddb_entry and lun_entry pointers
@@ -832,7 +914,7 @@ int qla4xxx_reset_lun(struct scsi_qla_host * ha, struct ddb_entry * ddb_entry,
 	int status = QLA_SUCCESS;
 
 	DEBUG2(printk("scsi%ld:%d:%d: lun reset issued\n", ha->host_no,
-		      ddb_entry->os_target_id, lun));
+		      ddb_entry->fw_ddb_index, lun));
 
 	/*
 	 * Send lun reset command to ISP, so that the ISP will return all
@@ -872,7 +954,7 @@ int qla4xxx_reset_target(struct scsi_qla_host *ha,
 	int status = QLA_SUCCESS;
 
 	DEBUG2(printk("scsi%ld:%d: target reset issued\n", ha->host_no,
-		      ddb_entry->os_target_id));
+		      ddb_entry->fw_ddb_index));
 
 	/*
 	 * Send target reset command to ISP, so that the ISP will return all
@@ -1009,7 +1091,7 @@ int qla4xxx_send_tgts(struct scsi_qla_host *ha, char *ip, uint16_t port)
 	struct dev_db_entry *fw_ddb_entry;
 	dma_addr_t fw_ddb_entry_dma;
 	uint32_t ddb_index;
-	int ret_val = QLA_SUCCESS;
+	int ret_val = QLA_ERROR;
 
 
 	fw_ddb_entry = dma_alloc_coherent(&ha->pdev->dev,
@@ -1018,8 +1100,7 @@ int qla4xxx_send_tgts(struct scsi_qla_host *ha, char *ip, uint16_t port)
 	if (!fw_ddb_entry) {
 		DEBUG2(printk("scsi%ld: %s: Unable to allocate dma buffer.\n",
 			      ha->host_no, __func__));
-		ret_val = QLA_ERROR;
-		goto qla4xxx_send_tgts_exit;
+		return ret_val;
 	}
 
 	ret_val = qla4xxx_get_default_ddb(ha, fw_ddb_entry_dma);
diff --git a/drivers/scsi/qla4xxx/ql4_nvram.c b/drivers/scsi/qla4xxx/ql4_nvram.c
index 7fe0482..f0d0fbf 100644
--- a/drivers/scsi/qla4xxx/ql4_nvram.c
+++ b/drivers/scsi/qla4xxx/ql4_nvram.c
@@ -149,7 +149,7 @@ static int eeprom_readword(int eepromAddr, u16 * value,
 /* Hardware_lock must be set before calling */
 u16 rd_nvram_word(struct scsi_qla_host * ha, int offset)
 {
-	u16 val;
+	u16 val = 0;
 
 	/* NOTE: NVRAM uses half-word addresses */
 	eeprom_readword(offset, &val, ha);
diff --git a/drivers/scsi/qla4xxx/ql4_nvram.h b/drivers/scsi/qla4xxx/ql4_nvram.h
index b47b4fc..ab7aaeb 100644
--- a/drivers/scsi/qla4xxx/ql4_nvram.h
+++ b/drivers/scsi/qla4xxx/ql4_nvram.h
@@ -19,7 +19,7 @@
 
 #define	 FM93C56A_START	      0x1
 
-// Commands
+/* Commands */
 #define	 FM93C56A_READ	      0x2
 #define	 FM93C56A_WEN	      0x0
 #define	 FM93C56A_WRITE	      0x1
@@ -62,9 +62,9 @@
 #define	 AUBURN_EEPROM_CLK_RISE	    0x1
 #define	 AUBURN_EEPROM_CLK_FALL	    0x0
 
-/* */
+/**/
 /* EEPROM format */
-/* */
+/**/
 struct bios_params {
 	uint16_t SpinUpDelay:1;
 	uint16_t BIOSDisable:1;
diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
new file mode 100644
index 0000000..c3b3e18
--- /dev/null
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -0,0 +1,2556 @@
+/*
+ * QLogic iSCSI HBA Driver
+ * Copyright (c)  2003-2009 QLogic Corporation
+ *
+ * See LICENSE.qla4xxx for copyright and licensing details.
+ */
+#include "ql4_def.h"
+#include "ql4_glbl.h"
+#include <linux/delay.h>
+#include <linux/pci.h>
+
+#define MASK(n)			((1ULL<<(n))-1)
+#define MN_WIN(addr) (((addr & 0x1fc0000) >> 1) | ((addr >> 25) & 0x3ff))
+#define OCM_WIN(addr) (((addr & 0x1ff0000) >> 1) | ((addr >> 25) & 0x3ff))
+#define MS_WIN(addr) (addr & 0x0ffc0000)
+#define QLA82XX_PCI_MN_2M   (0)
+#define QLA82XX_PCI_MS_2M   (0x80000)
+#define QLA82XX_PCI_OCM0_2M (0xc0000)
+#define VALID_OCM_ADDR(addr) (((addr) & 0x3f800) != 0x3f800)
+#define GET_MEM_OFFS_2M(addr) (addr & MASK(18))
+
+/* CRB window related */
+#define CRB_BLK(off)	((off >> 20) & 0x3f)
+#define CRB_SUBBLK(off)	((off >> 16) & 0xf)
+#define CRB_WINDOW_2M	(0x130060)
+#define QLA82XX_PCI_CAMQM_2M_END	(0x04800800UL)
+#define CRB_HI(off)	((qla82xx_crb_hub_agt[CRB_BLK(off)] << 20) | ((off) & 0xf0000))
+#define QLA82XX_PCI_CAMQM_2M_BASE	(0x000ff800UL)
+#define CRB_INDIRECT_2M	(0x1e0000UL)
+
+#ifndef readq
+static u64 readq(void __iomem *reg)
+{
+	return ((u64)readl(reg + 0x4UL) << 32) | (u64)readl(reg);
+}
+
+static void writeq(u64 val, void __iomem *reg)
+{
+	writel(val & 0xffffffff, reg);
+	writel(val >> 32, reg + 0x4UL);
+}
+#endif
+
+static inline void *qla82xx_pci_base_offsetfset(struct scsi_qla_host *ha,
+	unsigned long off)
+{
+	if ((off < ha->first_page_group_end) &&
+	    (off >= ha->first_page_group_start))
+		return (void *)(ha->nx_pcibase + off);
+
+	return NULL;
+}
+
+#define MAX_CRB_XFORM 60
+static unsigned long crb_addr_xform[MAX_CRB_XFORM];
+int qla82xx_crb_table_initialized;
+
+#define qla82xx_crb_addr_transform(name) \
+	(crb_addr_xform[QLA82XX_HW_PX_MAP_CRB_##name] = \
+	 QLA82XX_HW_CRB_HUB_AGT_ADR_##name << 20)
+static void
+qla82xx_crb_addr_transform_setup(void)
+{
+	qla82xx_crb_addr_transform(XDMA);
+	qla82xx_crb_addr_transform(TIMR);
+	qla82xx_crb_addr_transform(SRE);
+	qla82xx_crb_addr_transform(SQN3);
+	qla82xx_crb_addr_transform(SQN2);
+	qla82xx_crb_addr_transform(SQN1);
+	qla82xx_crb_addr_transform(SQN0);
+	qla82xx_crb_addr_transform(SQS3);
+	qla82xx_crb_addr_transform(SQS2);
+	qla82xx_crb_addr_transform(SQS1);
+	qla82xx_crb_addr_transform(SQS0);
+	qla82xx_crb_addr_transform(RPMX7);
+	qla82xx_crb_addr_transform(RPMX6);
+	qla82xx_crb_addr_transform(RPMX5);
+	qla82xx_crb_addr_transform(RPMX4);
+	qla82xx_crb_addr_transform(RPMX3);
+	qla82xx_crb_addr_transform(RPMX2);
+	qla82xx_crb_addr_transform(RPMX1);
+	qla82xx_crb_addr_transform(RPMX0);
+	qla82xx_crb_addr_transform(ROMUSB);
+	qla82xx_crb_addr_transform(SN);
+	qla82xx_crb_addr_transform(QMN);
+	qla82xx_crb_addr_transform(QMS);
+	qla82xx_crb_addr_transform(PGNI);
+	qla82xx_crb_addr_transform(PGND);
+	qla82xx_crb_addr_transform(PGN3);
+	qla82xx_crb_addr_transform(PGN2);
+	qla82xx_crb_addr_transform(PGN1);
+	qla82xx_crb_addr_transform(PGN0);
+	qla82xx_crb_addr_transform(PGSI);
+	qla82xx_crb_addr_transform(PGSD);
+	qla82xx_crb_addr_transform(PGS3);
+	qla82xx_crb_addr_transform(PGS2);
+	qla82xx_crb_addr_transform(PGS1);
+	qla82xx_crb_addr_transform(PGS0);
+	qla82xx_crb_addr_transform(PS);
+	qla82xx_crb_addr_transform(PH);
+	qla82xx_crb_addr_transform(NIU);
+	qla82xx_crb_addr_transform(I2Q);
+	qla82xx_crb_addr_transform(EG);
+	qla82xx_crb_addr_transform(MN);
+	qla82xx_crb_addr_transform(MS);
+	qla82xx_crb_addr_transform(CAS2);
+	qla82xx_crb_addr_transform(CAS1);
+	qla82xx_crb_addr_transform(CAS0);
+	qla82xx_crb_addr_transform(CAM);
+	qla82xx_crb_addr_transform(C2C1);
+	qla82xx_crb_addr_transform(C2C0);
+	qla82xx_crb_addr_transform(SMB);
+	qla82xx_crb_addr_transform(OCM0);
+	qla82xx_crb_addr_transform(I2C0);
+
+	qla82xx_crb_table_initialized = 1;
+}
+
+struct crb_128M_2M_block_map crb_128M_2M_map[64] = {
+	{{{0, 0,         0,         0} } },		/* 0: PCI */
+	{{{1, 0x0100000, 0x0102000, 0x120000},	/* 1: PCIE */
+		{1, 0x0110000, 0x0120000, 0x130000},
+		{1, 0x0120000, 0x0122000, 0x124000},
+		{1, 0x0130000, 0x0132000, 0x126000},
+		{1, 0x0140000, 0x0142000, 0x128000},
+		{1, 0x0150000, 0x0152000, 0x12a000},
+		{1, 0x0160000, 0x0170000, 0x110000},
+		{1, 0x0170000, 0x0172000, 0x12e000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{1, 0x01e0000, 0x01e0800, 0x122000},
+		{0, 0x0000000, 0x0000000, 0x000000} } },
+	{{{1, 0x0200000, 0x0210000, 0x180000} } },/* 2: MN */
+	{{{0, 0,         0,         0} } },	    /* 3: */
+	{{{1, 0x0400000, 0x0401000, 0x169000} } },/* 4: P2NR1 */
+	{{{1, 0x0500000, 0x0510000, 0x140000} } },/* 5: SRE   */
+	{{{1, 0x0600000, 0x0610000, 0x1c0000} } },/* 6: NIU   */
+	{{{1, 0x0700000, 0x0704000, 0x1b8000} } },/* 7: QM    */
+	{{{1, 0x0800000, 0x0802000, 0x170000},  /* 8: SQM0  */
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{1, 0x08f0000, 0x08f2000, 0x172000} } },
+	{{{1, 0x0900000, 0x0902000, 0x174000},	/* 9: SQM1*/
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{1, 0x09f0000, 0x09f2000, 0x176000} } },
+	{{{0, 0x0a00000, 0x0a02000, 0x178000},	/* 10: SQM2*/
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{1, 0x0af0000, 0x0af2000, 0x17a000} } },
+	{{{0, 0x0b00000, 0x0b02000, 0x17c000},	/* 11: SQM3*/
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{1, 0x0bf0000, 0x0bf2000, 0x17e000} } },
+	{{{1, 0x0c00000, 0x0c04000, 0x1d4000} } },/* 12: I2Q */
+	{{{1, 0x0d00000, 0x0d04000, 0x1a4000} } },/* 13: TMR */
+	{{{1, 0x0e00000, 0x0e04000, 0x1a0000} } },/* 14: ROMUSB */
+	{{{1, 0x0f00000, 0x0f01000, 0x164000} } },/* 15: PEG4 */
+	{{{0, 0x1000000, 0x1004000, 0x1a8000} } },/* 16: XDMA */
+	{{{1, 0x1100000, 0x1101000, 0x160000} } },/* 17: PEG0 */
+	{{{1, 0x1200000, 0x1201000, 0x161000} } },/* 18: PEG1 */
+	{{{1, 0x1300000, 0x1301000, 0x162000} } },/* 19: PEG2 */
+	{{{1, 0x1400000, 0x1401000, 0x163000} } },/* 20: PEG3 */
+	{{{1, 0x1500000, 0x1501000, 0x165000} } },/* 21: P2ND */
+	{{{1, 0x1600000, 0x1601000, 0x166000} } },/* 22: P2NI */
+	{{{0, 0,         0,         0} } },	/* 23: */
+	{{{0, 0,         0,         0} } },	/* 24: */
+	{{{0, 0,         0,         0} } },	/* 25: */
+	{{{0, 0,         0,         0} } },	/* 26: */
+	{{{0, 0,         0,         0} } },	/* 27: */
+	{{{0, 0,         0,         0} } },	/* 28: */
+	{{{1, 0x1d00000, 0x1d10000, 0x190000} } },/* 29: MS */
+	{{{1, 0x1e00000, 0x1e01000, 0x16a000} } },/* 30: P2NR2 */
+	{{{1, 0x1f00000, 0x1f10000, 0x150000} } },/* 31: EPG */
+	{{{0} } },				/* 32: PCI */
+	{{{1, 0x2100000, 0x2102000, 0x120000},	/* 33: PCIE */
+		{1, 0x2110000, 0x2120000, 0x130000},
+		{1, 0x2120000, 0x2122000, 0x124000},
+		{1, 0x2130000, 0x2132000, 0x126000},
+		{1, 0x2140000, 0x2142000, 0x128000},
+		{1, 0x2150000, 0x2152000, 0x12a000},
+		{1, 0x2160000, 0x2170000, 0x110000},
+		{1, 0x2170000, 0x2172000, 0x12e000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000},
+		{0, 0x0000000, 0x0000000, 0x000000} } },
+	{{{1, 0x2200000, 0x2204000, 0x1b0000} } },/* 34: CAM */
+	{{{0} } },				/* 35: */
+	{{{0} } },				/* 36: */
+	{{{0} } },				/* 37: */
+	{{{0} } },				/* 38: */
+	{{{0} } },				/* 39: */
+	{{{1, 0x2800000, 0x2804000, 0x1a4000} } },/* 40: TMR */
+	{{{1, 0x2900000, 0x2901000, 0x16b000} } },/* 41: P2NR3 */
+	{{{1, 0x2a00000, 0x2a00400, 0x1ac400} } },/* 42: RPMX1 */
+	{{{1, 0x2b00000, 0x2b00400, 0x1ac800} } },/* 43: RPMX2 */
+	{{{1, 0x2c00000, 0x2c00400, 0x1acc00} } },/* 44: RPMX3 */
+	{{{1, 0x2d00000, 0x2d00400, 0x1ad000} } },/* 45: RPMX4 */
+	{{{1, 0x2e00000, 0x2e00400, 0x1ad400} } },/* 46: RPMX5 */
+	{{{1, 0x2f00000, 0x2f00400, 0x1ad800} } },/* 47: RPMX6 */
+	{{{1, 0x3000000, 0x3000400, 0x1adc00} } },/* 48: RPMX7 */
+	{{{0, 0x3100000, 0x3104000, 0x1a8000} } },/* 49: XDMA */
+	{{{1, 0x3200000, 0x3204000, 0x1d4000} } },/* 50: I2Q */
+	{{{1, 0x3300000, 0x3304000, 0x1a0000} } },/* 51: ROMUSB */
+	{{{0} } },				/* 52: */
+	{{{1, 0x3500000, 0x3500400, 0x1ac000} } },/* 53: RPMX0 */
+	{{{1, 0x3600000, 0x3600400, 0x1ae000} } },/* 54: RPMX8 */
+	{{{1, 0x3700000, 0x3700400, 0x1ae400} } },/* 55: RPMX9 */
+	{{{1, 0x3800000, 0x3804000, 0x1d0000} } },/* 56: OCM0 */
+	{{{1, 0x3900000, 0x3904000, 0x1b4000} } },/* 57: CRYPTO */
+	{{{1, 0x3a00000, 0x3a04000, 0x1d8000} } },/* 58: SMB */
+	{{{0} } },				/* 59: I2C0 */
+	{{{0} } },				/* 60: I2C1 */
+	{{{1, 0x3d00000, 0x3d04000, 0x1dc000} } },/* 61: LPC */
+	{{{1, 0x3e00000, 0x3e01000, 0x167000} } },/* 62: P2NC */
+	{{{1, 0x3f00000, 0x3f01000, 0x168000} } }	/* 63: P2NR0 */
+};
+
+/*
+ * top 12 bits of crb internal address (hub, agent)
+ */
+unsigned qla82xx_crb_hub_agt[64] = {
+	0,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_PS,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_MN,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_MS,
+	0,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_SRE,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_NIU,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_QMN,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_SQN0,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_SQN1,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_SQN2,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_SQN3,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_I2Q,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_TIMR,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_ROMUSB,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_PGN4,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_XDMA,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_PGN0,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_PGN1,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_PGN2,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_PGN3,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_PGND,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_PGNI,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_PGS0,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_PGS1,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_PGS2,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_PGS3,
+	0,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_PGSI,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_SN,
+	0,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_EG,
+	0,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_PS,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_CAM,
+	0,
+	0,
+	0,
+	0,
+	0,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_TIMR,
+	0,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX1,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX2,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX3,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX4,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX5,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX6,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX7,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_XDMA,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_I2Q,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_ROMUSB,
+	0,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX0,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX8,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX9,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_OCM0,
+	0,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_SMB,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_I2C0,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_I2C1,
+	0,
+	QLA82XX_HW_CRB_HUB_AGT_ADR_PGNC,
+	0,
+};
+
+/* Device states */
+char *qdev_state[] = {
+	"Unknown",
+	"Cold",
+	"Initializing",
+	"Ready",
+	"Need Reset",
+	"Need Quiescent",
+	"Failed",
+	"Quiescent",
+};
+
+/*
+ * Set the CRB window based on the offset.
+ * Return 0 if successful; 1 otherwise
+*/
+void qla82xx_pci_change_crbwindow_128M(struct scsi_qla_host *ha, int wndw)
+{
+	WARN_ON(1);
+}
+
+/*
+ * In: 'off' is offset from CRB space in 128M pci map
+ * Out: 'off' is 2M pci map addr
+ * side effect: lock crb window
+ */
+static void
+qla82xx_pci_set_crbwindow_2M(struct scsi_qla_host *ha, ulong *off)
+{
+	u32 win_read;
+
+	ha->crb_win = CRB_HI(*off);
+	writel(ha->crb_win,
+		(void *)(CRB_WINDOW_2M + ha->nx_pcibase));
+
+	/* Read back value to make sure write has gone through before trying
+	* to use it. */
+	win_read = readl((void *)(CRB_WINDOW_2M + ha->nx_pcibase));
+	if (win_read != ha->crb_win) {
+		DEBUG2(ql4_printk(KERN_INFO, ha,
+			"%s: Written crbwin (0x%x) != Read crbwin (0x%x), off=0x%lx\n",
+			__func__, ha->crb_win, win_read, *off));
+	}
+	*off = (*off & MASK(16)) + CRB_INDIRECT_2M + ha->nx_pcibase;
+}
+
+static inline unsigned long
+qla82xx_pci_set_crbwindow(struct scsi_qla_host *ha, u64 off)
+{
+	/*
+	* See if we are currently pointing to the region we want to use next.
+	*/
+	if ((off >= QLA82XX_CRB_PCIX_HOST) && (off < QLA82XX_CRB_DDR_NET)) {
+		/*
+		* No need to change window. PCIX and PCIE regs are in both
+		* windows.
+		*/
+		return off;
+	}
+
+	if ((off >= QLA82XX_CRB_PCIX_HOST) && (off < QLA82XX_CRB_PCIX_HOST2)) {
+		/* We are in first CRB window */
+		if (ha->curr_window != 0)
+			qla82xx_pci_change_crbwindow_128M(ha, 0);
+
+		return off;
+	}
+
+	if ((off > QLA82XX_CRB_PCIX_HOST2) && (off < QLA82XX_CRB_MAX)) {
+		/* We are in second CRB window */
+		off = off - QLA82XX_CRB_PCIX_HOST2 + QLA82XX_CRB_PCIX_HOST;
+
+		if (ha->curr_window != 1) {
+			qla82xx_pci_change_crbwindow_128M(ha, 1);
+			return off;
+		}
+
+		if ((off >= QLA82XX_PCI_DIRECT_CRB) && (off < QLA82XX_PCI_CAMQM_MAX)) {
+			/*
+			* We are in the QM or direct access register region - do
+			* nothing
+			*/
+			return off;
+		}
+	}
+	/* strange address given */
+	dump_stack();
+	ql4_printk(KERN_WARNING, ha,
+		"%s: Warning: %s called with"
+		" an unknown address(%llx)\n", DRIVER_NAME, __func__, off);
+	return off;
+}
+
+void
+qla82xx_wr_32(struct scsi_qla_host *ha, ulong off, u32 data)
+{
+	unsigned long flags = 0;
+	int rv;
+
+	rv = qla82xx_pci_get_crb_addr_2M(ha, &off);
+
+	BUG_ON(rv == -1);
+
+	if (rv == 1) {
+		write_lock_irqsave(&ha->hw_lock, flags);
+		qla82xx_crb_win_lock(ha);
+		qla82xx_pci_set_crbwindow_2M(ha, &off);
+	}
+
+	writel(data, (void __iomem *)off);
+
+	if (rv == 1) {
+		qla82xx_crb_win_unlock(ha);
+		write_unlock_irqrestore(&ha->hw_lock, flags);
+	}
+}
+
+int
+qla82xx_rd_32(struct scsi_qla_host *ha, ulong off)
+{
+	unsigned long flags = 0;
+	int rv;
+	u32 data;
+
+	rv = qla82xx_pci_get_crb_addr_2M(ha, &off);
+
+	BUG_ON(rv == -1);
+
+	if (rv == 1) {
+		write_lock_irqsave(&ha->hw_lock, flags);
+		qla82xx_crb_win_lock(ha);
+		qla82xx_pci_set_crbwindow_2M(ha, &off);
+	}
+	data = readl((void __iomem *)off);
+
+	if (rv == 1) {
+		qla82xx_crb_win_unlock(ha);
+		write_unlock_irqrestore(&ha->hw_lock, flags);
+	}
+	return data;
+}
+
+#define CRB_WIN_LOCK_TIMEOUT 100000000
+
+int qla82xx_crb_win_lock(struct scsi_qla_host *ha)
+{
+	int i;
+	int done = 0, timeout = 0;
+
+	while (!done) {
+		/* acquire semaphore3 from PCI HW block */
+		done = qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM7_LOCK));
+		if (done == 1)
+			break;
+		if (timeout >= CRB_WIN_LOCK_TIMEOUT)
+			return -1;
+
+		timeout++;
+
+		/* Yield CPU */
+		if (!in_interrupt())
+			schedule();
+		else {
+			for (i = 0; i < 20; i++)
+				cpu_relax();    /*This a nop instr on i386*/
+		}
+	}
+	qla82xx_wr_32(ha, QLA82XX_CRB_WIN_LOCK_ID, ha->func_num);
+	return 0;
+}
+
+void qla82xx_crb_win_unlock(struct scsi_qla_host *ha)
+{
+	qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM7_UNLOCK));
+}
+
+#define IDC_LOCK_TIMEOUT 100000000
+
+/**
+ * qla82xx_idc_lock - hw_lock
+ * @ha: pointer to adapter structure
+ *
+ * General purpose lock used to synchronize access to
+ * CRB_DEV_STATE, CRB_DEV_REF_COUNT, etc.
+ **/
+int qla82xx_idc_lock(struct scsi_qla_host *ha)
+{
+	int i;
+	int done = 0, timeout = 0;
+
+	while (!done) {
+		/* acquire semaphore5 from PCI HW block */
+		done = qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM5_LOCK));
+		if (done == 1)
+			break;
+		if (timeout >= IDC_LOCK_TIMEOUT)
+			return -1;
+
+		timeout++;
+
+		/* Yield CPU */
+		if (!in_interrupt())
+			schedule();
+		else {
+			for (i = 0; i < 20; i++)
+				cpu_relax();    /*This a nop instr on i386*/
+		}
+	}
+	return 0;
+}
+
+void qla82xx_idc_unlock(struct scsi_qla_host *ha)
+{
+	qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM5_UNLOCK));
+}
+
+int
+qla82xx_pci_get_crb_addr_2M(struct scsi_qla_host *ha, ulong *off)
+{
+	struct crb_128M_2M_sub_block_map *m;
+
+	if (*off >= QLA82XX_CRB_MAX)
+		return -1;
+
+	if (*off >= QLA82XX_PCI_CAMQM && (*off < QLA82XX_PCI_CAMQM_2M_END)) {
+		*off = (*off - QLA82XX_PCI_CAMQM) + QLA82XX_PCI_CAMQM_2M_BASE + ha->nx_pcibase;
+		return 0;
+	}
+
+	if (*off < QLA82XX_PCI_CRBSPACE)
+		return -1;
+
+	*off -= QLA82XX_PCI_CRBSPACE;
+	/*
+	 * Try direct map
+	 */
+
+	m = &crb_128M_2M_map[CRB_BLK(*off)].sub_block[CRB_SUBBLK(*off)];
+
+	if (m->valid && (m->start_128M <= *off) && (m->end_128M > *off)) {
+		*off = *off + m->start_2M - m->start_128M + ha->nx_pcibase;
+		return 0;
+	}
+
+	/*
+	 * Not in direct map, use crb window
+	 */
+	return 1;
+}
+
+/*  PCI Windowing for DDR regions.  */
+#define QLA82XX_ADDR_IN_RANGE(addr, low, high)            \
+	(((addr) <= (high)) && ((addr) >= (low)))
+
+/*
+* check memory access boundary.
+* used by test agent. support ddr access only for now
+*/
+static unsigned long
+qla82xx_pci_mem_bound_check(struct scsi_qla_host *ha,
+		unsigned long long addr, int size)
+{
+	if (!QLA82XX_ADDR_IN_RANGE(addr, QLA82XX_ADDR_DDR_NET, QLA82XX_ADDR_DDR_NET_MAX) ||
+		!QLA82XX_ADDR_IN_RANGE(addr + size - 1, QLA82XX_ADDR_DDR_NET, QLA82XX_ADDR_DDR_NET_MAX) ||
+		((size != 1) && (size != 2) && (size != 4) && (size != 8))) {
+		return 0;
+	}
+	return 1;
+}
+
+int qla82xx_pci_set_window_warning_count;
+
+unsigned long
+qla82xx_pci_set_window(struct scsi_qla_host *ha, unsigned long long addr)
+{
+	int window;
+	u32 win_read;
+
+	if (QLA82XX_ADDR_IN_RANGE(addr, QLA82XX_ADDR_DDR_NET, QLA82XX_ADDR_DDR_NET_MAX)) {
+		/* DDR network side */
+		window = MN_WIN(addr);
+		ha->ddr_mn_window = window;
+		qla82xx_wr_32(ha, ha->mn_win_crb | QLA82XX_PCI_CRBSPACE, window);
+		win_read = qla82xx_rd_32(ha, ha->mn_win_crb | QLA82XX_PCI_CRBSPACE);
+		if ((win_read << 17) != window) {
+			ql4_printk(KERN_WARNING, ha,
+			"%s: Written MNwin (0x%x) != Read MNwin (0x%x)\n",
+			__func__, window, win_read);
+		}
+		addr = GET_MEM_OFFS_2M(addr) + QLA82XX_PCI_DDR_NET;
+	} else if (QLA82XX_ADDR_IN_RANGE(addr, QLA82XX_ADDR_OCM0, QLA82XX_ADDR_OCM0_MAX)) {
+		unsigned int temp1;
+		if ((addr & 0x00ff800) == 0xff800) {	/* if bits 19:18&17:11 are on */
+		printk("%s: QM access not handled.\n", __func__);
+		addr = -1UL;
+	}
+
+	window = OCM_WIN(addr);
+	ha->ddr_mn_window = window;
+	qla82xx_wr_32(ha, ha->mn_win_crb | QLA82XX_PCI_CRBSPACE, window);
+	win_read = qla82xx_rd_32(ha, ha->mn_win_crb | QLA82XX_PCI_CRBSPACE);
+	temp1 = ((window & 0x1FF) << 7) | ((window & 0x0FFFE0000) >> 17);
+	if (win_read != temp1) {
+		printk("%s: Written OCMwin (0x%x) != Read OCMwin (0x%x)\n",
+		__func__, temp1, win_read);
+	}
+	addr = GET_MEM_OFFS_2M(addr) + QLA82XX_PCI_OCM0_2M;
+
+	} else if (QLA82XX_ADDR_IN_RANGE(addr, QLA82XX_ADDR_QDR_NET, QLA82XX_P3_ADDR_QDR_NET_MAX)) {
+		/* QDR network side */
+		window = MS_WIN(addr);
+		ha->qdr_sn_window = window;
+		qla82xx_wr_32(ha, ha->ms_win_crb | QLA82XX_PCI_CRBSPACE, window);
+		win_read = qla82xx_rd_32(ha, ha->ms_win_crb | QLA82XX_PCI_CRBSPACE);
+		if (win_read != window) {
+			printk("%s: Written MSwin (0x%x) != Read MSwin (0x%x)\n",
+			__func__, window, win_read);
+		}
+		addr = GET_MEM_OFFS_2M(addr) + QLA82XX_PCI_QDR_NET;
+
+	} else {
+	/*
+	* peg gdb frequently accesses memory that doesn't exist,
+	* this limits the chit chat so debugging isn't slowed down.
+	*/
+	if ((qla82xx_pci_set_window_warning_count++ < 8) ||
+	    (qla82xx_pci_set_window_warning_count%64 == 0)) {
+		printk("%s: Warning:%s Unknown address range!\n", __func__,
+		    DRIVER_NAME);
+	}
+	addr = -1UL;
+	}
+	/* printk("New address: 0x%08lx\n",addr); */
+	return addr;
+}
+
+/* check if address is in the same windows as the previous access */
+static int qla82xx_pci_is_same_window(struct scsi_qla_host *ha,
+		unsigned long long addr)
+{
+	int			window;
+	unsigned long long	qdr_max;
+
+	qdr_max = QLA82XX_P3_ADDR_QDR_NET_MAX;
+
+	if (QLA82XX_ADDR_IN_RANGE(addr, QLA82XX_ADDR_DDR_NET, QLA82XX_ADDR_DDR_NET_MAX)) {
+		/* DDR network side */
+		BUG();	/* MN access can not come here */
+	} else if (QLA82XX_ADDR_IN_RANGE(addr, QLA82XX_ADDR_OCM0, QLA82XX_ADDR_OCM0_MAX)) {
+		return 1;
+	} else if (QLA82XX_ADDR_IN_RANGE(addr, QLA82XX_ADDR_OCM1, QLA82XX_ADDR_OCM1_MAX)) {
+		return 1;
+	} else if (QLA82XX_ADDR_IN_RANGE(addr, QLA82XX_ADDR_QDR_NET, qdr_max)) {
+		/* QDR network side */
+		window = ((addr - QLA82XX_ADDR_QDR_NET) >> 22) & 0x3f;
+		if (ha->qdr_sn_window == window)
+			return 1;
+
+	}
+
+	return 0;
+}
+
+static int qla82xx_pci_mem_read_direct(struct scsi_qla_host *ha,
+		u64 off, void *data, int size)
+{
+	unsigned long   flags;
+	void           *addr;
+	int             ret = 0;
+	u64             start;
+	uint8_t         *mem_ptr = NULL;
+	unsigned long   mem_base;
+	unsigned long   mem_page;
+
+	write_lock_irqsave(&ha->hw_lock, flags);
+
+	/*
+	 * If attempting to access unknown address or straddle hw windows,
+	 * do not access.
+	 */
+	start = qla82xx_pci_set_window(ha, off);
+	if ((start == -1UL) ||
+	    (qla82xx_pci_is_same_window(ha, off + size - 1) == 0)) {
+		write_unlock_irqrestore(&ha->hw_lock, flags);
+		printk(KERN_ERR"%s out of bound pci memory access. "
+				"offset is 0x%llx\n", DRIVER_NAME, off);
+		return -1;
+	}
+
+	addr = qla82xx_pci_base_offsetfset(ha, start);
+	if (!addr) {
+		write_unlock_irqrestore(&ha->hw_lock, flags);
+		mem_base = pci_resource_start(ha->pdev, 0);
+		mem_page = start & PAGE_MASK;
+		/* Map two pages whenever user tries to access addresses in two
+		   consecutive pages.
+		 */
+		if (mem_page != ((start + size - 1) & PAGE_MASK))
+			mem_ptr = ioremap(mem_base + mem_page, PAGE_SIZE * 2);
+		else
+			mem_ptr = ioremap(mem_base + mem_page, PAGE_SIZE);
+		if (mem_ptr == 0UL) {
+			*(u8  *)data = 0;
+			return -1;
+		}
+		addr = mem_ptr;
+		addr += start & (PAGE_SIZE - 1);
+		write_lock_irqsave(&ha->hw_lock, flags);
+	}
+
+	switch (size) {
+	case 1:
+		*(u8  *)data = readb(addr);
+		break;
+	case 2:
+		*(u16 *)data = readw(addr);
+		break;
+	case 4:
+		*(u32 *)data = readl(addr);
+		break;
+	case 8:
+		*(u64 *)data = readq(addr);
+		break;
+	default:
+		ret = -1;
+		break;
+	}
+	write_unlock_irqrestore(&ha->hw_lock, flags);
+
+	if (mem_ptr)
+		iounmap(mem_ptr);
+	return ret;
+}
+
+static int
+qla82xx_pci_mem_write_direct(struct scsi_qla_host *ha, u64 off,
+		void *data, int size)
+{
+	unsigned long   flags;
+	void           *addr;
+	int             ret = 0;
+	u64             start;
+	uint8_t         *mem_ptr = NULL;
+	unsigned long   mem_base;
+	unsigned long   mem_page;
+
+	write_lock_irqsave(&ha->hw_lock, flags);
+
+	/*
+	 * If attempting to access unknown address or straddle hw windows,
+	 * do not access.
+	 */
+	start = qla82xx_pci_set_window(ha, off);
+	if ((start == -1UL) ||
+	    (qla82xx_pci_is_same_window(ha, off + size - 1) == 0)) {
+		write_unlock_irqrestore(&ha->hw_lock, flags);
+		printk(KERN_ERR"%s out of bound pci memory access. "
+				"offset is 0x%llx\n", DRIVER_NAME, off);
+		return -1;
+	}
+
+	addr = qla82xx_pci_base_offsetfset(ha, start);
+	if (!addr) {
+		write_unlock_irqrestore(&ha->hw_lock, flags);
+		mem_base = pci_resource_start(ha->pdev, 0);
+		mem_page = start & PAGE_MASK;
+		/* Map two pages whenever user tries to access addresses in two
+		   consecutive pages.
+		 */
+		if (mem_page != ((start + size - 1) & PAGE_MASK))
+			mem_ptr = ioremap(mem_base + mem_page, PAGE_SIZE*2);
+		else
+			mem_ptr = ioremap(mem_base + mem_page, PAGE_SIZE);
+		if (mem_ptr == 0UL)
+			return -1;
+
+		addr = mem_ptr;
+		addr += start & (PAGE_SIZE - 1);
+		write_lock_irqsave(&ha->hw_lock, flags);
+	}
+
+	switch (size) {
+	case 1:
+		writeb(*(u8  *)data, addr);
+		break;
+	case 2:
+		writew(*(u16 *)data, addr);
+		break;
+	case 4:
+		writel(*(u32 *)data, addr);
+		break;
+	case 8:
+		writeq(*(u64 *)data, addr);
+		break;
+	default:
+		ret = -1;
+		break;
+	}
+	write_unlock_irqrestore(&ha->hw_lock, flags);
+	if (mem_ptr)
+		iounmap(mem_ptr);
+	return ret;
+}
+
+int
+qla82xx_rdmem(struct scsi_qla_host *ha, u64 off, void *data, int size)
+{
+	int	i, j = 0, k, start, end, loop, sz[2], off0[2];
+	u32	temp;
+	u64	off8, val, mem_crb, word[2] = {0, 0};
+#define MAX_CTL_CHECK   1000
+
+	/*
+	 * If not MN, go check for MS or invalid.
+	 */
+
+	if (off >= QLA82XX_ADDR_QDR_NET && off <= QLA82XX_P3_ADDR_QDR_NET_MAX) {
+		mem_crb = QLA82XX_CRB_QDR_NET;
+	} else {
+		mem_crb = QLA82XX_CRB_DDR_NET;
+		if (qla82xx_pci_mem_bound_check(ha, off, size) == 0)
+			return qla82xx_pci_mem_read_direct(ha, off, data, size);
+	}
+
+	off8 = off & 0xfffffff8;
+	off0[0] = off & 0x7;
+	off0[1] = 0;
+	sz[0] = (size < (8 - off0[0])) ? size : (8 - off0[0]);
+	sz[1] = size - sz[0];
+	loop = ((off0[0] + size - 1) >> 3) + 1;
+
+	for (i = 0; i < loop; i++) {
+		temp = off8 + (i << 3);
+		qla82xx_wr_32(ha, mem_crb + MIU_TEST_AGT_ADDR_LO,
+				temp);
+		temp = 0;
+		qla82xx_wr_32(ha, mem_crb + MIU_TEST_AGT_ADDR_HI,
+				temp);
+		temp = MIU_TA_CTL_ENABLE;
+		qla82xx_wr_32(ha, mem_crb + MIU_TEST_AGT_CTRL,
+				temp);
+		temp = MIU_TA_CTL_START | MIU_TA_CTL_ENABLE;
+		qla82xx_wr_32(ha, mem_crb + MIU_TEST_AGT_CTRL,
+				temp);
+
+		for (j = 0; j < MAX_CTL_CHECK; j++) {
+			temp = qla82xx_rd_32(ha, mem_crb + MIU_TEST_AGT_CTRL);
+			if ((temp & MIU_TA_CTL_BUSY) == 0)
+				break;
+		}
+
+		if (j >= MAX_CTL_CHECK) {
+			printk("%s: Fail to read through agent\n", DRIVER_NAME);
+			break;
+		}
+
+		start = off0[i] >> 2;
+		end   = (off0[i] + sz[i] - 1) >> 2;
+		for (k = start; k <= end; k++) {
+			temp = qla82xx_rd_32(ha, mem_crb + MIU_TEST_AGT_RDDATA(k));
+			word[i] |= ((u64)temp << (32 * k));
+		}
+	}
+
+
+	if (j >= MAX_CTL_CHECK)
+		return -1;
+
+	if (sz[0] == 8) {
+		val = word[0];
+	} else {
+		val = ((word[0] >> (off0[0] * 8)) & (~(~0ULL << (sz[0] * 8)))) |
+			((word[1] & (~(~0ULL << (sz[1] * 8)))) << (sz[0] * 8));
+	}
+
+	switch (size) {
+	case 1:
+		*(u8  *)data = val;
+		break;
+	case 2:
+		*(u16 *)data = val;
+		break;
+	case 4:
+		*(u32 *)data = val;
+		break;
+	case 8:
+		*(u64 *)data = val;
+		break;
+	}
+	return 0;
+}
+
+int
+qla82xx_wrmem(struct scsi_qla_host *ha, u64 off, void *data, int size)
+{
+	int i, j, ret = 0, loop, sz[2], off0;
+	u32 temp;
+	u64 off8, mem_crb, tmpw, word[2] = {0, 0};
+#define MAX_CTL_CHECK   1000
+
+	/*
+	 * If not MN, go check for MS or invalid.
+	 */
+	if (off >= QLA82XX_ADDR_QDR_NET && off <= QLA82XX_P3_ADDR_QDR_NET_MAX) {
+		mem_crb = QLA82XX_CRB_QDR_NET;
+	} else {
+		mem_crb = QLA82XX_CRB_DDR_NET;
+		if (qla82xx_pci_mem_bound_check(ha, off, size) == 0)
+			return qla82xx_pci_mem_write_direct(ha, off, data, size);
+	}
+
+	off8 = off & 0xfffffff8;
+	off0 = off & 0x7;
+	sz[0] = (size < (8 - off0)) ? size : (8 - off0);
+	sz[1] = size - sz[0];
+	loop = ((off0 + size - 1) >> 3) + 1;
+
+	if ((size != 8) || (off0 != 0))  {
+		for (i = 0; i < loop; i++) {
+			if (qla82xx_rdmem(ha, off8 + (i << 3), &word[i], 8))
+				return -1;
+		}
+	}
+
+	switch (size) {
+	case 1:
+		tmpw = *((u8 *)data);
+		break;
+	case 2:
+		tmpw = *((u16 *)data);
+		break;
+	case 4:
+		tmpw = *((u32 *)data);
+		break;
+	case 8:
+	default:
+		tmpw = *((u64 *)data);
+		break;
+	}
+
+	word[0] &= ~((~(~0ULL << (sz[0] * 8))) << (off0 * 8));
+	word[0] |= tmpw << (off0 * 8);
+
+	if (loop == 2) {
+		word[1] &= ~(~0ULL << (sz[1] * 8));
+		word[1] |= tmpw >> (sz[0] * 8);
+	}
+
+	for (i = 0; i < loop; i++) {
+		temp = off8 + (i << 3);
+		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_ADDR_LO, temp);
+		temp = 0;
+		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_ADDR_HI, temp);
+		temp = word[i] & 0xffffffff;
+		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_WRDATA_LO, temp);
+		temp = (word[i] >> 32) & 0xffffffff;
+		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_WRDATA_HI, temp);
+		temp = MIU_TA_CTL_ENABLE | MIU_TA_CTL_WRITE;
+		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_CTRL, temp);
+		temp = MIU_TA_CTL_START | MIU_TA_CTL_ENABLE | MIU_TA_CTL_WRITE;
+		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_CTRL, temp);
+
+		for (j = 0; j < MAX_CTL_CHECK; j++) {
+			temp = qla82xx_rd_32(ha, mem_crb + MIU_TEST_AGT_CTRL);
+			if ((temp & MIU_TA_CTL_BUSY) == 0)
+				break;
+		}
+
+		if (j >= MAX_CTL_CHECK) {
+			printk("%s: Fail to write through agent\n", DRIVER_NAME);
+			ret = -1;
+			break;
+		}
+	}
+
+	return ret;
+}
+
+
+#define MTU_FUDGE_FACTOR 100
+
+unsigned long
+qla82xx_decode_crb_addr(unsigned long addr)
+{
+	int i;
+	unsigned long base_addr, offset, pci_base;
+
+	if (!qla82xx_crb_table_initialized)
+		qla82xx_crb_addr_transform_setup();
+
+	pci_base = ADDR_ERROR;
+	base_addr = addr & 0xfff00000;
+	offset = addr & 0x000fffff;
+
+	for (i = 0; i < MAX_CRB_XFORM; i++) {
+		if (crb_addr_xform[i] == base_addr) {
+			pci_base = i << 20;
+			break;
+		}
+	}
+	if (pci_base == ADDR_ERROR)
+		return pci_base;
+	else
+		return pci_base + offset;
+}
+
+static long rom_max_timeout = 100;
+static long qla82xx_rom_lock_timeout = 100;
+
+int
+qla82xx_rom_lock(struct scsi_qla_host *ha)
+{
+	int i;
+	int done = 0, timeout = 0;
+
+	while (!done) {
+		/* acquire semaphore2 from PCI HW block */
+
+		done = qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM2_LOCK));
+		if (done == 1)
+			break;
+		if (timeout >= qla82xx_rom_lock_timeout)
+			return -1;
+
+		timeout++;
+
+		/* Yield CPU */
+		if (!in_interrupt())
+			schedule();
+		else {
+			for (i = 0; i < 20; i++)
+				cpu_relax();    /*This a nop instr on i386*/
+		}
+	}
+	qla82xx_wr_32(ha, QLA82XX_ROM_LOCK_ID, ROM_LOCK_DRIVER);
+	return 0;
+}
+
+void
+qla82xx_rom_unlock(struct scsi_qla_host *ha)
+{
+	qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM2_UNLOCK));
+}
+
+int
+qla82xx_wait_rom_done(struct scsi_qla_host *ha)
+{
+	long timeout = 0;
+	long done = 0 ;
+
+	while (done == 0) {
+		done = qla82xx_rd_32(ha, QLA82XX_ROMUSB_GLB_STATUS);
+		done &= 2;
+		timeout++;
+		if (timeout >= rom_max_timeout) {
+			printk("%s: Timeout reached  waiting for rom done",
+					DRIVER_NAME);
+			return -1;
+		}
+	}
+	return 0;
+}
+
+int
+qla82xx_do_rom_fast_read(struct scsi_qla_host *ha, int addr, int *valp)
+{
+	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_ADDRESS, addr);
+	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_DUMMY_BYTE_CNT, 0);
+	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_ABYTE_CNT, 3);
+	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_INSTR_OPCODE, 0xb);
+	if (qla82xx_wait_rom_done(ha)) {
+		printk("%s: Error waiting for rom done\n", DRIVER_NAME);
+		return -1;
+	}
+	/* reset abyte_cnt and dummy_byte_cnt */
+	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_DUMMY_BYTE_CNT, 0);
+	udelay(10);
+	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_ABYTE_CNT, 0);
+
+	*valp = qla82xx_rd_32(ha, QLA82XX_ROMUSB_ROM_RDATA);
+	return 0;
+}
+
+int
+qla82xx_rom_fast_read(struct scsi_qla_host *ha, int addr, int *valp)
+{
+	int ret, loops = 0;
+
+	while ((qla82xx_rom_lock(ha) != 0) && (loops < 50000)) {
+		udelay(100);
+		schedule();
+		loops++;
+	}
+	if (loops >= 50000) {
+		printk("%s: qla82xx_rom_lock failed\n", DRIVER_NAME);
+		return -1;
+	}
+	ret = qla82xx_do_rom_fast_read(ha, addr, valp);
+	qla82xx_rom_unlock(ha);
+	return ret;
+}
+
+/* This routine does CRB initialize sequence
+ *  to put the ISP into operational state
+ */
+int qla82xx_pinit_from_rom(struct scsi_qla_host *ha, int verbose)
+{
+	int addr, val;
+	int i ;
+	struct crb_addr_pair *buf;
+	unsigned long off;
+	unsigned offset, n;
+
+	struct crb_addr_pair {
+		long addr;
+		long data;
+	};
+
+	/* Halt all the indiviual PEGs and other blocks of the ISP */
+	qla82xx_rom_lock(ha);
+	if (test_bit(DPC_RESET_HA, &ha->dpc_flags))
+		/* don't reset CAM block on reset */
+		qla82xx_wr_32(ha, QLA82XX_ROMUSB_GLB_SW_RESET, 0xfeffffff);
+	else
+		qla82xx_wr_32(ha, QLA82XX_ROMUSB_GLB_SW_RESET, 0xffffffff);
+
+	qla82xx_rom_unlock(ha);
+
+	/* Read the signature value from the flash.
+	 * Offset 0: Contain signature (0xcafecafe)
+	 * Offset 4: Offset and number of addr/value pairs
+	 * that present in CRB initialize sequence
+	 */
+	if (qla82xx_rom_fast_read(ha, 0, &n) != 0 || n != 0xcafecafeUL ||
+			qla82xx_rom_fast_read(ha, 4, &n) != 0) {
+		ql4_printk(KERN_WARNING, ha,
+			"[ERROR] Reading crb_init area: n: %08x\n", n);
+		return -1;
+	}
+
+	/* Offset in flash = lower 16 bits
+	 * Number of enteries = upper 16 bits
+	 */
+	offset = n & 0xffffU;
+	n = (n >> 16) & 0xffffU;
+
+	/* number of addr/value pair should not exceed 1024 enteries */
+	if (n  >= 1024) {
+		ql4_printk(KERN_WARNING, ha,
+			"%s: %s:n=0x%x [ERROR] Card flash not initialized.\n",
+			DRIVER_NAME, __func__, n);
+		return -1;
+	}
+
+	ql4_printk(KERN_INFO, ha,
+		"%s: %d CRB init values found in ROM.\n", DRIVER_NAME, n);
+
+	buf = kmalloc(n * sizeof(struct crb_addr_pair), GFP_KERNEL);
+	if (buf == NULL) {
+		ql4_printk(KERN_WARNING, ha,
+			"%s: [ERROR] Unable to malloc memory.\n", DRIVER_NAME);
+		return -1;
+	}
+
+	for (i = 0; i < n; i++) {
+		if (qla82xx_rom_fast_read(ha, 8*i + 4*offset, &val) != 0 ||
+		    qla82xx_rom_fast_read(ha, 8*i + 4*offset + 4, &addr) != 0) {
+			kfree(buf);
+			return -1;
+		}
+
+		buf[i].addr = addr;
+		buf[i].data = val;
+	}
+
+	for (i = 0; i < n; i++) {
+		/* Translate internal CRB initialization
+		 * address to PCI bus address
+		 */
+		off = qla82xx_decode_crb_addr((unsigned long)buf[i].addr) +
+			QLA82XX_PCI_CRBSPACE;
+		/* Not all CRB  addr/value pair to be written,
+		 * some of them are skipped
+		 */
+
+		/* skip if LS bit is set*/
+		if (off & 0x1) {
+			DEBUG2(ql4_printk(KERN_WARNING, ha,
+				"Skip CRB init replay for offset = 0x%lx\n",
+				off));
+			continue;
+		}
+
+		/* skipping cold reboot MAGIC */
+		if (off == QLA82XX_CAM_RAM(0x1fc))
+			continue;
+
+		/* do not reset PCI */
+		if (off == (ROMUSB_GLB + 0xbc))
+			continue;
+
+		/* skip core clock, so that firmware can increase the clock */
+		if (off == (ROMUSB_GLB + 0xc8))
+			continue;
+
+		/* skip the function enable register */
+		if (off == QLA82XX_PCIE_REG(PCIE_SETUP_FUNCTION))
+			continue;
+
+		if (off == QLA82XX_PCIE_REG(PCIE_SETUP_FUNCTION2))
+			continue;
+
+		if ((off & 0x0ff00000) == QLA82XX_CRB_SMB)
+			continue;
+
+		if ((off & 0x0ff00000) == QLA82XX_CRB_DDR_NET)
+			continue;
+
+		if (off == ADDR_ERROR) {
+			ql4_printk(KERN_WARNING, ha,
+				"%s: [ERROR] Unknown addr: 0x%08lx\n",
+				DRIVER_NAME, buf[i].addr);
+			continue;
+		}
+
+		qla82xx_wr_32(ha, off, buf[i].data);
+
+		/* ISP requires much bigger delay to settle down,
+		 * else crb_window returns 0xffffffff
+		 */
+		if (off == QLA82XX_ROMUSB_GLB_SW_RESET)
+			msleep(1000);
+
+		/* ISP requires millisec delay between
+		 * successive CRB register updation
+		 */
+		msleep(1);
+	}
+
+	kfree(buf);
+
+	/* Resetting the data and instruction cache */
+	qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_D+0xec, 0x1e);
+	qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_D+0x4c, 8);
+	qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_I+0x4c, 8);
+
+	/* Clear all protocol processing engines */
+	qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_0+0x8, 0);
+	qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_0+0xc, 0);
+	qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_1+0x8, 0);
+	qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_1+0xc, 0);
+	qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_2+0x8, 0);
+	qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_2+0xc, 0);
+	qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_3+0x8, 0);
+	qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_3+0xc, 0);
+
+	return 0;
+}
+int qla82xx_check_for_bad_spd(struct scsi_qla_host *ha)
+{
+	u32 val = 0;
+	val = qla82xx_rd_32(ha, BOOT_LOADER_DIMM_STATUS) ;
+	val &= QLA82XX_BOOT_LOADER_MN_ISSUE;
+	if (val & QLA82XX_PEG_TUNE_MN_SPD_ZEROED) {
+		printk("Memory DIMM SPD not programmed.  Assumed valid.\n");
+		return 1;
+	} else if (val) {
+		printk("Memory DIMM type incorrect.  Info:%08X.\n", val);
+		return 2;
+	}
+	return 0;
+}
+
+int
+qla82xx_load_from_flash(struct scsi_qla_host *ha, uint32_t image_start)
+{
+	int  i;
+	long size = 0;
+	long flashaddr, memaddr;
+	u64 data;
+	u32 high, low;
+
+	flashaddr = memaddr = ha->hw.flt_region_bootload;
+	size = (image_start - flashaddr)/8;
+
+	DEBUG2(printk("scsi%ld: %s: bootldr=0x%lx, fw_image=0x%x\n",
+		ha->host_no, __func__, flashaddr, image_start));
+
+	for (i = 0; i < size; i++) {
+		if ((qla82xx_rom_fast_read(ha, flashaddr, (int *)&low)) ||
+				(qla82xx_rom_fast_read(ha, flashaddr + 4, (int *)&high))) {
+			return -1;
+		}
+		data = ((u64)high << 32) | low ;
+		qla82xx_pci_mem_write_2M(ha, memaddr, &data, 8);
+		flashaddr += 8;
+		memaddr   += 8;
+
+		if (i%0x1000 == 0)
+			msleep(1);
+
+	}
+
+	udelay(100);
+
+	read_lock(&ha->hw_lock);
+	qla82xx_wr_32(ha, QLA82XX_CRB_PEG_NET_0 + 0x18, 0x1020);
+	qla82xx_wr_32(ha, QLA82XX_ROMUSB_GLB_SW_RESET, 0x80001e);
+	read_unlock(&ha->hw_lock);
+
+	return 0;
+}
+
+int qla82xx_load_fw(struct scsi_qla_host *ha, uint32_t image_start)
+{
+	u32 rst;
+
+	qla82xx_wr_32(ha, CRB_CMDPEG_STATE, 0);
+	if (qla82xx_pinit_from_rom(ha, 0) != QLA_SUCCESS) {
+		printk(KERN_WARNING "%s: Error during CRB Initialization\n",
+				__func__);
+		return QLA_ERROR;
+	}
+
+	udelay(500);
+
+	/* at this point, QM is in reset. This could be a problem if there are
+	 * incoming d* transition queue messages. QM/PCIE could wedge.
+	 * To get around this, QM is brought out of reset.
+	 */
+
+	rst = qla82xx_rd_32(ha, QLA82XX_ROMUSB_GLB_SW_RESET);
+	/* unreset qm */
+	rst &= ~(1 << 28);
+	qla82xx_wr_32(ha, QLA82XX_ROMUSB_GLB_SW_RESET, rst);
+
+	if (qla82xx_load_from_flash(ha, image_start)) {
+		printk("%s: Error trying to load fw from flash!\n", __func__);
+		return QLA_ERROR;
+	}
+
+	return QLA_SUCCESS;
+}
+
+int
+qla82xx_pci_mem_read_2M(struct scsi_qla_host *ha,
+		u64 off, void *data, int size)
+{
+	int i, j = 0, k, start, end, loop, sz[2], off0[2];
+	int	      shift_amount;
+	uint32_t      temp;
+	uint64_t      off8, val, mem_crb, word[2] = {0, 0};
+
+	/*
+	 * If not MN, go check for MS or invalid.
+	 */
+
+	if (off >= QLA82XX_ADDR_QDR_NET && off <= QLA82XX_P3_ADDR_QDR_NET_MAX)
+		mem_crb = QLA82XX_CRB_QDR_NET;
+	else {
+		mem_crb = QLA82XX_CRB_DDR_NET;
+		if (qla82xx_pci_mem_bound_check(ha, off, size) == 0)
+			return qla82xx_pci_mem_read_direct(ha,
+					off, data, size);
+	}
+
+
+	off8 = off & 0xfffffff0;
+	off0[0] = off & 0xf;
+	sz[0] = (size < (16 - off0[0])) ? size : (16 - off0[0]);
+	shift_amount = 4;
+
+	loop = ((off0[0] + size - 1) >> shift_amount) + 1;
+	off0[1] = 0;
+	sz[1] = size - sz[0];
+
+	for (i = 0; i < loop; i++) {
+		temp = off8 + (i << shift_amount);
+		qla82xx_wr_32(ha, mem_crb + MIU_TEST_AGT_ADDR_LO, temp);
+		temp = 0;
+		qla82xx_wr_32(ha, mem_crb + MIU_TEST_AGT_ADDR_HI, temp);
+		temp = MIU_TA_CTL_ENABLE;
+		qla82xx_wr_32(ha, mem_crb + MIU_TEST_AGT_CTRL, temp);
+		temp = MIU_TA_CTL_START | MIU_TA_CTL_ENABLE;
+		qla82xx_wr_32(ha, mem_crb + MIU_TEST_AGT_CTRL, temp);
+
+		for (j = 0; j < MAX_CTL_CHECK; j++) {
+			temp = qla82xx_rd_32(ha, mem_crb + MIU_TEST_AGT_CTRL);
+			if ((temp & MIU_TA_CTL_BUSY) == 0)
+				break;
+		}
+
+		if (j >= MAX_CTL_CHECK) {
+			if (printk_ratelimit())
+				dev_err(&ha->pdev->dev,
+					"failed to read through agent\n");
+			break;
+		}
+
+		start = off0[i] >> 2;
+		end   = (off0[i] + sz[i] - 1) >> 2;
+		for (k = start; k <= end; k++) {
+			temp = qla82xx_rd_32(ha,
+				mem_crb + MIU_TEST_AGT_RDDATA(k));
+			word[i] |= ((uint64_t)temp << (32 * (k & 1)));
+		}
+	}
+
+	if (j >= MAX_CTL_CHECK)
+		return -1;
+
+	if ((off0[0] & 7) == 0) {
+		val = word[0];
+	} else {
+		val = ((word[0] >> (off0[0] * 8)) & (~(~0ULL << (sz[0] * 8)))) |
+		((word[1] & (~(~0ULL << (sz[1] * 8)))) << (sz[0] * 8));
+	}
+
+	switch (size) {
+	case 1:
+		*(uint8_t  *)data = val;
+		break;
+	case 2:
+		*(uint16_t *)data = val;
+		break;
+	case 4:
+		*(uint32_t *)data = val;
+		break;
+	case 8:
+		*(uint64_t *)data = val;
+		break;
+	}
+	return 0;
+}
+
+int
+qla82xx_pci_mem_write_2M(struct scsi_qla_host *ha,
+		u64 off, void *data, int size)
+{
+	int i, j, ret = 0, loop, sz[2], off0;
+	int scale, shift_amount, startword;
+	uint32_t temp;
+	uint64_t off8, mem_crb, tmpw, word[2] = {0, 0};
+
+	/*
+	 * If not MN, go check for MS or invalid.
+	 */
+	if (off >= QLA82XX_ADDR_QDR_NET && off <= QLA82XX_P3_ADDR_QDR_NET_MAX)
+		mem_crb = QLA82XX_CRB_QDR_NET;
+	else {
+		mem_crb = QLA82XX_CRB_DDR_NET;
+		if (qla82xx_pci_mem_bound_check(ha, off, size) == 0)
+			return qla82xx_pci_mem_write_direct(ha,
+					off, data, size);
+	}
+
+	off0 = off & 0x7;
+	sz[0] = (size < (8 - off0)) ? size : (8 - off0);
+	sz[1] = size - sz[0];
+
+	off8 = off & 0xfffffff0;
+	loop = (((off & 0xf) + size - 1) >> 4) + 1;
+	shift_amount = 4;
+	scale = 2;
+	startword = (off & 0xf)/8;
+
+	for (i = 0; i < loop; i++) {
+		if (qla82xx_pci_mem_read_2M(ha, off8 +
+		    (i << shift_amount), &word[i * scale], 8))
+			return -1;
+	}
+
+	switch (size) {
+	case 1:
+		tmpw = *((uint8_t *)data);
+		break;
+	case 2:
+		tmpw = *((uint16_t *)data);
+		break;
+	case 4:
+		tmpw = *((uint32_t *)data);
+		break;
+	case 8:
+	default:
+		tmpw = *((uint64_t *)data);
+		break;
+	}
+
+	if (sz[0] == 8) {
+		word[startword] = tmpw;
+	} else {
+		word[startword] &=
+		    ~((~(~0ULL << (sz[0] * 8))) << (off0 * 8));
+		word[startword] |= tmpw << (off0 * 8);
+	}
+	if (sz[1] != 0) {
+		word[startword+1] &= ~(~0ULL << (sz[1] * 8));
+		word[startword+1] |= tmpw >> (sz[0] * 8);
+	}
+
+	for (i = 0; i < loop; i++) {
+		temp = off8 + (i << shift_amount);
+		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_ADDR_LO, temp);
+		temp = 0;
+		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_ADDR_HI, temp);
+		temp = word[i * scale] & 0xffffffff;
+		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_WRDATA_LO, temp);
+		temp = (word[i * scale] >> 32) & 0xffffffff;
+		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_WRDATA_HI, temp);
+		temp = word[i*scale + 1] & 0xffffffff;
+		qla82xx_wr_32(ha, mem_crb + MIU_TEST_AGT_WRDATA_UPPER_LO, temp);
+		temp = (word[i*scale + 1] >> 32) & 0xffffffff;
+		qla82xx_wr_32(ha, mem_crb + MIU_TEST_AGT_WRDATA_UPPER_HI, temp);
+
+		temp = MIU_TA_CTL_ENABLE | MIU_TA_CTL_WRITE;
+		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_CTRL, temp);
+		temp = MIU_TA_CTL_START | MIU_TA_CTL_ENABLE | MIU_TA_CTL_WRITE;
+		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_CTRL, temp);
+
+		for (j = 0; j < MAX_CTL_CHECK; j++) {
+			temp = qla82xx_rd_32(ha, mem_crb + MIU_TEST_AGT_CTRL);
+			if ((temp & MIU_TA_CTL_BUSY) == 0)
+				break;
+		}
+
+		if (j >= MAX_CTL_CHECK) {
+			if (printk_ratelimit())
+				dev_err(&ha->pdev->dev,
+					"failed to write through agent\n");
+			ret = -1;
+			break;
+		}
+	}
+
+	return ret;
+}
+
+int qla82xx_cmdpeg_ready(struct scsi_qla_host *ha, int pegtune_val)
+{
+	u32 val = 0;
+	int retries = 60;
+
+	if (!pegtune_val) {
+		do {
+			val = qla82xx_rd_32(ha, CRB_CMDPEG_STATE);
+			if ((val == PHAN_INITIALIZE_COMPLETE) ||
+					(val == PHAN_INITIALIZE_ACK))
+				return 0;
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			schedule_timeout(500);
+
+		} while (--retries);
+
+		qla82xx_check_for_bad_spd(ha);
+
+		if (!retries) {
+			pegtune_val = qla82xx_rd_32(ha,
+				QLA82XX_ROMUSB_GLB_PEGTUNE_DONE);
+			printk(KERN_WARNING "%s: init failed, "
+				"pegtune_val = %x\n", __func__, pegtune_val);
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
+static int qla82xx_rcvpeg_ready(struct scsi_qla_host *ha)
+{
+	uint32_t state = 0;
+	int loops = 0, err = 0;
+
+	/* Window 1 call */
+	read_lock(&ha->hw_lock);
+	state = qla82xx_rd_32(ha, CRB_RCVPEG_STATE);
+	read_unlock(&ha->hw_lock);
+
+	while ((state != PHAN_PEG_RCV_INITIALIZED) && (loops < 30000)) {
+		udelay(100);
+		schedule();
+		/* Window 1 call */
+
+		read_lock(&ha->hw_lock);
+		state = qla82xx_rd_32(ha, CRB_RCVPEG_STATE);
+		read_unlock(&ha->hw_lock);
+
+		loops++;
+	}
+
+	if (loops >= 30000) {
+		DEBUG2(ql4_printk(KERN_INFO, ha,
+			"Receive Peg initialization not complete: 0x%x.\n", state));
+		err = -EIO;
+	}
+
+	return err;
+}
+
+static inline void
+qla82xx_set_drv_active(struct scsi_qla_host *ha)
+{
+	uint32_t drv_active;
+
+	drv_active = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_ACTIVE);
+	drv_active |= (1 << (ha->func_num * 4));
+	qla82xx_wr_32(ha, QLA82XX_CRB_DRV_ACTIVE, drv_active);
+}
+
+void
+qla82xx_clear_drv_active(struct scsi_qla_host *ha)
+{
+	uint32_t drv_active;
+
+	drv_active = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_ACTIVE);
+	drv_active &= ~(1 << (ha->func_num * 4));
+	qla82xx_wr_32(ha, QLA82XX_CRB_DRV_ACTIVE, drv_active);
+}
+
+static inline int
+qla82xx_need_reset(struct scsi_qla_host *ha)
+{
+	uint32_t drv_state;
+	int rval;
+
+	drv_state = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_STATE);
+	rval = drv_state & (1 << (ha->func_num * 4));
+	return rval;
+}
+
+static inline void
+qla82xx_set_rst_ready(struct scsi_qla_host *ha)
+{
+	uint32_t drv_state;
+
+	drv_state = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_STATE);
+	drv_state |= (1 << (ha->func_num * 4));
+	qla82xx_wr_32(ha, QLA82XX_CRB_DRV_STATE, drv_state);
+}
+
+static inline void
+qla82xx_clear_rst_ready(struct scsi_qla_host *ha)
+{
+	uint32_t drv_state;
+
+	drv_state = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_STATE);
+	drv_state &= ~(1 << (ha->func_num * 4));
+	qla82xx_wr_32(ha, QLA82XX_CRB_DRV_STATE, drv_state);
+}
+
+static inline void
+qla82xx_set_qsnt_ready(struct scsi_qla_host *ha)
+{
+	uint32_t qsnt_state;
+
+	qsnt_state = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_STATE);
+	qsnt_state |= (2 << (ha->func_num * 4));
+	qla82xx_wr_32(ha, QLA82XX_CRB_DRV_STATE, qsnt_state);
+}
+
+
+static int qla82xx_start_firmware(struct scsi_qla_host *ha, uint32_t image_start)
+{
+	int           pcie_cap;
+	uint16_t      lnk;
+
+	/* scrub dma mask expansion register */
+	qla82xx_wr_32(ha, CRB_DMA_SHIFT, 0x55555555);
+
+	/* Overwrite stale initialization register values */
+	qla82xx_wr_32(ha, CRB_CMDPEG_STATE, 0);
+	qla82xx_wr_32(ha, CRB_RCVPEG_STATE, 0);
+	qla82xx_wr_32(ha, QLA82XX_PEG_HALT_STATUS1, 0);
+	qla82xx_wr_32(ha, QLA82XX_PEG_HALT_STATUS2, 0);
+
+	if (qla82xx_load_fw(ha, image_start) != QLA_SUCCESS) {
+		printk("%s: Error trying to start fw!\n", __func__);
+		return QLA_ERROR;
+	}
+
+	/* Handshake with the card before we register the devices. */
+	if (qla82xx_cmdpeg_ready(ha, 0) != QLA_SUCCESS) {
+		printk("%s: Error during card handshake!\n", __func__);
+		return QLA_ERROR;
+	}
+
+	/* Negotiated Link width */
+	pcie_cap = pci_find_capability(ha->pdev, PCI_CAP_ID_EXP);
+	pci_read_config_word(ha->pdev, pcie_cap + PCI_EXP_LNKSTA, &lnk);
+	ha->link_width = (lnk >> 4) & 0x3f;
+
+	/* Synchronize with Receive peg */
+	return qla82xx_rcvpeg_ready(ha);
+}
+
+static int
+qla82xx_try_start_fw(struct scsi_qla_host *ha)
+{
+	int rval = QLA_ERROR;
+
+	/*
+	 * FW Load priority:
+	 * 1) Operational firmware residing in flash.
+	 * 2) Fail
+	 */
+
+	ql4_printk(KERN_INFO, ha, "FW: Retrieving flash offsets from FLT/FDT ...\n");
+	rval = qla82xx_get_flash_info(ha);
+	if (rval != QLA_SUCCESS)
+		return rval;
+
+	ql4_printk(KERN_INFO, ha, "FW: Attempting to load firmware from flash...\n");
+	rval = qla82xx_start_firmware(ha, ha->hw.flt_region_fw);
+	if (rval == QLA_SUCCESS)
+		return rval;
+
+	ql4_printk(KERN_ERR, ha, "FW: Load firmware from flash FAILED...\n");
+	rval = QLA_ERROR;
+
+	return rval;
+}
+
+/**
+ * qla82xx_device_bootstrap - Initialize device, set DEV_READY, start fw
+ * @ha: pointer to adapter structure
+ *
+ * Note: IDC lock must be held upon entry
+ **/
+static int
+qla82xx_device_bootstrap(struct scsi_qla_host *ha)
+{
+	int rval, i, timeout;
+	uint32_t old_count, count;
+
+	if (qla82xx_need_reset(ha))
+		goto dev_initialize;
+
+	old_count = qla82xx_rd_32(ha, QLA82XX_PEG_ALIVE_COUNTER);
+
+	for (i = 0; i < 10; i++) {
+		timeout = msleep_interruptible(200);
+		if (timeout) {
+			qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE,
+			   QLA82XX_DEV_FAILED);
+			return QLA_ERROR;
+		}
+
+		count = qla82xx_rd_32(ha, QLA82XX_PEG_ALIVE_COUNTER);
+		if (count != old_count)
+			goto dev_ready;
+	}
+
+dev_initialize:
+	/* set to DEV_INITIALIZING */
+	ql4_printk(KERN_INFO, ha, "HW State: INITIALIZING\n");
+	qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE, QLA82XX_DEV_INITIALIZING);
+
+	/* Driver that sets device state to initializating sets IDC version */
+	qla82xx_wr_32(ha, QLA82XX_CRB_DRV_IDC_VERSION, QLA82XX_IDC_VERSION);
+
+	qla82xx_idc_unlock(ha);
+	rval = qla82xx_try_start_fw(ha);
+	qla82xx_idc_lock(ha);
+
+	if (rval != QLA_SUCCESS) {
+		ql4_printk(KERN_INFO, ha, "HW State: FAILED\n");
+		qla82xx_clear_drv_active(ha);
+		qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE, QLA82XX_DEV_FAILED);
+		return rval;
+	}
+
+dev_ready:
+	ql4_printk(KERN_INFO, ha, "HW State: READY\n");
+	qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE, QLA82XX_DEV_READY);
+
+	return QLA_SUCCESS;
+}
+
+/**
+ * qla82xx_need_reset_handler - Code to start reset sequence
+ * @ha: pointer to adapter structure
+ *
+ * Note: IDC lock must be held upon entry
+ **/
+static void
+qla82xx_need_reset_handler(struct scsi_qla_host *ha)
+{
+	uint32_t dev_state, drv_state, drv_active;
+	unsigned long reset_timeout;
+
+	ql4_printk(KERN_INFO, ha,
+		"Performing ISP error recovery\n");
+
+	if (test_and_clear_bit(AF_ONLINE, &ha->flags)) {
+		qla82xx_idc_unlock(ha);
+		ha->isp_ops->disable_intrs(ha);
+		qla82xx_idc_lock(ha);
+	}
+
+	qla82xx_set_rst_ready(ha);
+
+	/* wait for 10 seconds for reset ack from all functions */
+	reset_timeout = jiffies + (ha->nx_reset_timeout * HZ);
+
+	drv_state = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_STATE);
+	drv_active = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_ACTIVE);
+
+	ql4_printk(KERN_INFO, ha,
+		"%s(%ld): drv_state = 0x%x, drv_active = 0x%x\n",
+		__func__, ha->host_no, drv_state, drv_active);
+
+	while (drv_state != drv_active) {
+
+		if (time_after_eq(jiffies, reset_timeout)) {
+			printk("%s: RESET TIMEOUT!\n", DRIVER_NAME);
+			break;
+		}
+
+		qla82xx_idc_unlock(ha);
+		msleep(1000);
+		qla82xx_idc_lock(ha);
+
+		drv_state = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_STATE);
+		drv_active = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_ACTIVE);
+	}
+
+	dev_state = qla82xx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
+	ql4_printk(KERN_INFO, ha, "3:Device state is 0x%x = %s\n", dev_state,
+		dev_state < MAX_STATES ? qdev_state[dev_state] : "Unknown");
+
+	/* Force to DEV_COLD unless someone else is starting a reset */
+	if (dev_state != QLA82XX_DEV_INITIALIZING) {
+		ql4_printk(KERN_INFO, ha, "HW State: COLD/RE-INIT\n");
+		qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE, QLA82XX_DEV_COLD);
+	}
+}
+
+/**
+ * qla82xx_need_qsnt_handler - Code to start qsnt
+ * @ha: pointer to adapter structure
+ **/
+void
+qla82xx_need_qsnt_handler(struct scsi_qla_host *ha)
+{
+	qla82xx_idc_lock(ha);
+	qla82xx_set_qsnt_ready(ha);
+	qla82xx_idc_unlock(ha);
+}
+
+/**
+ * qla82xx_device_state_handler - Adapter state machine
+ * @ha: pointer to host adapter structure.
+ *
+ * Note: IDC lock must be UNLOCKED upon entry
+ **/
+int qla82xx_device_state_handler(struct scsi_qla_host *ha)
+{
+	uint32_t dev_state;
+	int rval = QLA_SUCCESS;
+	unsigned long dev_init_timeout;
+
+	if (!test_bit(AF_INIT_DONE, &ha->flags))
+		qla82xx_set_drv_active(ha);
+
+	dev_state = qla82xx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
+	ql4_printk(KERN_INFO, ha, "1:Device state is 0x%x = %s\n", dev_state,
+		dev_state < MAX_STATES ? qdev_state[dev_state] : "Unknown");
+
+	/* wait for 30 seconds for device to go ready */
+	dev_init_timeout = jiffies + (ha->nx_dev_init_timeout * HZ);
+
+	while (1) {
+		qla82xx_idc_lock(ha);
+
+		if (time_after_eq(jiffies, dev_init_timeout)) {
+			ql4_printk(KERN_WARNING, ha, "Device init failed!\n");
+			qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE,
+				QLA82XX_DEV_FAILED);
+		}
+
+		dev_state = qla82xx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
+		ql4_printk(KERN_INFO, ha,
+		    "2:Device state is 0x%x = %s\n", dev_state,
+		    dev_state < MAX_STATES ? qdev_state[dev_state] : "Unknown");
+
+		/* NOTE: Make sure idc unlocked upon exit of switch statement */
+		switch (dev_state) {
+		case QLA82XX_DEV_READY:
+			qla82xx_idc_unlock(ha);
+			goto exit;
+		case QLA82XX_DEV_COLD:
+			rval = qla82xx_device_bootstrap(ha);
+			qla82xx_idc_unlock(ha);
+			goto exit;
+		case QLA82XX_DEV_INITIALIZING:
+			qla82xx_idc_unlock(ha);
+			msleep(1000);
+			break;
+		case QLA82XX_DEV_NEED_RESET:
+			if (!ql4xdontresethba) {
+				qla82xx_need_reset_handler(ha);
+				/* Update timeout value after need
+				 * reset handler */
+				dev_init_timeout = jiffies +
+					(ha->nx_dev_init_timeout * HZ);
+			}
+			qla82xx_idc_unlock(ha);
+			break;
+		case QLA82XX_DEV_NEED_QUIESCENT:
+			qla82xx_idc_unlock(ha);
+			/* idc locked/unlocked in handler */
+			qla82xx_need_qsnt_handler(ha);
+			qla82xx_idc_lock(ha);
+			/* fall thru needs idc_locked */
+		case QLA82XX_DEV_QUIESCENT:
+			qla82xx_idc_unlock(ha);
+			msleep(1000);
+			break;
+		case QLA82XX_DEV_FAILED:
+			qla82xx_idc_unlock(ha);
+			qla4xxx_dead_adapter_cleanup(ha);
+			rval = QLA_ERROR;
+			goto exit;
+		default:
+			qla82xx_idc_unlock(ha);
+			qla4xxx_dead_adapter_cleanup(ha);
+			rval = QLA_ERROR;
+			goto exit;
+		}
+	}
+exit:
+	return rval;
+}
+
+int qla82xx_load_risc(struct scsi_qla_host *ha)
+{
+	int retval;
+	retval = qla82xx_device_state_handler(ha);
+
+	if (retval == QLA_SUCCESS &&
+	    !test_bit(AF_INIT_DONE, &ha->flags)) {
+		retval = qla4xxx_request_irqs(ha);
+		if (retval != QLA_SUCCESS) {
+			dev_warn(&ha->pdev->dev, "Failed to reserve interrupt"
+				" %d already in use.\n", ha->pdev->irq);
+		} else {
+			set_bit(AF_IRQ_ATTACHED, &ha->flags);
+			ha->host->irq = ha->pdev->irq;
+			dev_info(&ha->pdev->dev, "%s: irq %d attached\n",
+				__func__, ha->pdev->irq);
+		}
+	}
+	return retval;
+}
+
+/* ISR related functions */
+uint32_t qla82xx_isr_int_target_mask_enable[8] = {
+	ISR_INT_TARGET_MASK, ISR_INT_TARGET_MASK_F1,
+	ISR_INT_TARGET_MASK_F2, ISR_INT_TARGET_MASK_F3,
+	ISR_INT_TARGET_MASK_F4, ISR_INT_TARGET_MASK_F5,
+	ISR_INT_TARGET_MASK_F7, ISR_INT_TARGET_MASK_F7
+};
+
+uint32_t qla82xx_isr_int_target_status[8] = {
+	ISR_INT_TARGET_STATUS, ISR_INT_TARGET_STATUS_F1,
+	ISR_INT_TARGET_STATUS_F2, ISR_INT_TARGET_STATUS_F3,
+	ISR_INT_TARGET_STATUS_F4, ISR_INT_TARGET_STATUS_F5,
+	ISR_INT_TARGET_STATUS_F7, ISR_INT_TARGET_STATUS_F7
+};
+
+/*****************************************************************************/
+/* Flash Manipulation Routines                                               */
+/*****************************************************************************/
+
+#define OPTROM_BURST_SIZE       0x1000
+#define OPTROM_BURST_DWORDS     (OPTROM_BURST_SIZE / 4)
+
+#define FARX_DATA_FLAG	BIT_31
+#define FARX_ACCESS_FLASH_CONF	0x7FFD0000
+#define FARX_ACCESS_FLASH_DATA	0x7FF00000
+
+static inline uint32_t
+flash_conf_addr(struct ql82xx_hw_data *hw, uint32_t faddr)
+{
+	return hw->flash_conf_off | faddr;
+}
+
+static inline uint32_t
+flash_data_addr(struct ql82xx_hw_data *hw, uint32_t faddr)
+{
+	return hw->flash_data_off | faddr;
+}
+
+uint32_t *
+qla82xx_read_flash_data(struct scsi_qla_host *ha, uint32_t *dwptr, uint32_t faddr,
+    uint32_t length)
+{
+	uint32_t i;
+	uint32_t val;
+	int loops = 0;
+	while ((qla82xx_rom_lock(ha) != 0) && (loops < 50000)) {
+		udelay(100);
+		cond_resched();
+		loops++;
+	}
+	if (loops >= 50000) {
+		dev_warn(&ha->pdev->dev,
+		    "ROM lock failed\n");
+		return dwptr;
+	}
+
+	/* Dword reads to flash. */
+	for (i = 0; i < length/4; i++, faddr += 4) {
+		if (qla82xx_do_rom_fast_read(ha, faddr, &val)) {
+			dev_warn(&ha->pdev->dev,
+			    "Do ROM fast read failed\n");
+			goto done_read;
+		}
+		dwptr[i] = __constant_cpu_to_le32(val);
+	}
+
+done_read:
+	qla82xx_rom_unlock(ha);
+	return dwptr;
+}
+
+/*
+Address and length are byte address
+*/
+uint8_t *
+qla82xx_read_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
+		uint32_t offset, uint32_t length)
+{
+	scsi_block_requests(ha->host);
+
+	qla82xx_read_flash_data(ha, (uint32_t *)buf, offset, length);
+
+	scsi_unblock_requests(ha->host);
+
+	return buf;
+}
+
+static int
+qla82xx_find_flt_start(struct scsi_qla_host *ha, uint32_t *start)
+{
+	const char *loc, *locations[] = { "DEF", "PCI" };
+
+	/*
+	 * FLT-location structure resides after the last PCI region.
+	 */
+
+	/* Begin with sane defaults. */
+	loc = locations[0];
+	*start = FA_FLASH_LAYOUT_ADDR_82;
+
+	DEBUG2(dev_info(&ha->pdev->dev, "FLTL[%s] = 0x%x.\n", loc, *start));
+	return QLA_SUCCESS;
+}
+
+static void
+qla82xx_get_flt_info(struct scsi_qla_host *ha, uint32_t flt_addr)
+{
+	const char *loc, *locations[] = { "DEF", "FLT" };
+	uint16_t *wptr;
+	uint16_t cnt, chksum;
+	uint32_t start;
+	struct qla_flt_header *flt;
+	struct qla_flt_region *region;
+	struct ql82xx_hw_data *hw = &ha->hw;
+
+	hw->flt_region_flt = flt_addr;
+	wptr = (uint16_t *)ha->request_ring;
+	flt = (struct qla_flt_header *)ha->request_ring;
+	region = (struct qla_flt_region *)&flt[1];
+	qla82xx_read_optrom_data(ha, (uint8_t *)ha->request_ring,
+			flt_addr << 2, OPTROM_BURST_SIZE);
+	if (*wptr == __constant_cpu_to_le16(0xffff))
+		goto no_flash_data;
+	if (flt->version != __constant_cpu_to_le16(1)) {
+		DEBUG2(dev_info(&ha->pdev->dev, "Unsupported FLT detected: "
+			"version=0x%x length=0x%x checksum=0x%x.\n",
+			le16_to_cpu(flt->version), le16_to_cpu(flt->length),
+			le16_to_cpu(flt->checksum)));
+		goto no_flash_data;
+	}
+
+	cnt = (sizeof(struct qla_flt_header) + le16_to_cpu(flt->length)) >> 1;
+	for (chksum = 0; cnt; cnt--)
+		chksum += le16_to_cpu(*wptr++);
+	if (chksum) {
+		DEBUG2(dev_info(&ha->pdev->dev, "Inconsistent FLT detected: "
+			"version=0x%x length=0x%x checksum=0x%x.\n",
+			le16_to_cpu(flt->version), le16_to_cpu(flt->length),
+			chksum));
+		goto no_flash_data;
+	}
+
+	loc = locations[1];
+	cnt = le16_to_cpu(flt->length) / sizeof(struct qla_flt_region);
+	for ( ; cnt; cnt--, region++) {
+		/* Store addresses as DWORD offsets. */
+		start = le32_to_cpu(region->start) >> 2;
+
+		DEBUG3(ql4_printk(KERN_DEBUG, ha, "FLT[%02x]: start=0x%x "
+			"end=0x%x size=0x%x.\n", le32_to_cpu(region->code), start,
+			le32_to_cpu(region->end) >> 2, le32_to_cpu(region->size)));
+
+		switch (le32_to_cpu(region->code) & 0xff) {
+		case FLT_REG_FDT:
+			hw->flt_region_fdt = start;
+			break;
+		case FLT_REG_BOOT_CODE_82:
+			hw->flt_region_boot = start;
+			break;
+		case FLT_REG_FW_82:
+			hw->flt_region_fw = start;
+			break;
+		case FLT_REG_BOOTLOAD_82:
+			hw->flt_region_bootload = start;
+			break;
+		}
+	}
+	goto done;
+
+no_flash_data:
+	/* Use hardcoded defaults. */
+	loc = locations[0];
+
+	hw->flt_region_fdt      = FA_FLASH_DESCR_ADDR_82;
+	hw->flt_region_boot     = FA_BOOT_CODE_ADDR_82;
+	hw->flt_region_bootload = FA_BOOT_LOAD_ADDR_82;
+	hw->flt_region_fw       = FA_RISC_CODE_ADDR_82;
+done:
+	DEBUG2(dev_info(&ha->pdev->dev, "FLT[%s]: flt=0x%x fdt=0x%x boot=0x%x bootload=0x%x "
+			"fw=0x%x\n", loc,
+			hw->flt_region_flt, hw->flt_region_fdt,
+			hw->flt_region_boot, hw->flt_region_bootload,
+			hw->flt_region_fw));
+}
+
+static void
+qla82xx_get_fdt_info(struct scsi_qla_host *ha)
+{
+#define FLASH_BLK_SIZE_4K       0x1000
+#define FLASH_BLK_SIZE_32K      0x8000
+#define FLASH_BLK_SIZE_64K      0x10000
+	const char *loc, *locations[] = { "MID", "FDT" };
+	uint16_t cnt, chksum;
+	uint16_t *wptr;
+	struct qla_fdt_layout *fdt;
+	uint16_t mid, fid;
+	struct ql82xx_hw_data *hw = &ha->hw;
+
+	hw->flash_conf_off   = FARX_ACCESS_FLASH_CONF;
+	hw->flash_data_off   = FARX_ACCESS_FLASH_DATA;
+
+	wptr = (uint16_t *)ha->request_ring;
+	fdt = (struct qla_fdt_layout *)ha->request_ring;
+	qla82xx_read_optrom_data(ha, (uint8_t *)ha->request_ring,
+			hw->flt_region_fdt << 2, OPTROM_BURST_SIZE);
+	if (*wptr == __constant_cpu_to_le16(0xffff))
+		goto no_flash_data;
+	if (fdt->sig[0] != 'Q' || fdt->sig[1] != 'L' || fdt->sig[2] != 'I' ||
+	    fdt->sig[3] != 'D')
+		goto no_flash_data;
+
+	for (cnt = 0, chksum = 0; cnt < sizeof(struct qla_fdt_layout) >> 1;
+			cnt++)
+		chksum += le16_to_cpu(*wptr++);
+	if (chksum) {
+		DEBUG2(dev_info(&ha->pdev->dev, "Inconsistent FDT detected: "
+			"checksum=0x%x id=%c version=0x%x.\n", chksum, fdt->sig[0],
+			le16_to_cpu(fdt->version)));
+		goto no_flash_data;
+	}
+
+	loc = locations[1];
+	mid = le16_to_cpu(fdt->man_id);
+	fid = le16_to_cpu(fdt->id);
+	hw->fdt_wrt_disable = fdt->wrt_disable_bits;
+	hw->fdt_erase_cmd = flash_conf_addr(hw, 0x0300 | fdt->erase_cmd);
+	hw->fdt_block_size = le32_to_cpu(fdt->block_size);
+	if (fdt->unprotect_sec_cmd) {
+		hw->fdt_unprotect_sec_cmd = flash_conf_addr(hw, 0x0300 |
+				fdt->unprotect_sec_cmd);
+		hw->fdt_protect_sec_cmd = fdt->protect_sec_cmd ?
+			flash_conf_addr(hw, 0x0300 | fdt->protect_sec_cmd) :
+			flash_conf_addr(hw, 0x0336);
+	}
+	goto done;
+
+no_flash_data:
+	loc = locations[0];
+	hw->fdt_block_size = FLASH_BLK_SIZE_64K;
+done:
+	DEBUG2(dev_info(&ha->pdev->dev, "FDT[%s]: (0x%x/0x%x) erase=0x%x "
+		"pro=%x upro=%x wrtd=0x%x blk=0x%x.\n", loc, mid, fid,
+		hw->fdt_erase_cmd, hw->fdt_protect_sec_cmd,
+		hw->fdt_unprotect_sec_cmd, hw->fdt_wrt_disable,
+		hw->fdt_block_size));
+}
+
+static void
+qla82xx_get_idc_param(struct scsi_qla_host *ha)
+{
+#define QLA82XX_IDC_PARAM_ADDR      0x003e885c
+	uint32_t *wptr;
+
+	if (!is_qla8022(ha))
+		return;
+	wptr = (uint32_t *)ha->request_ring;
+	qla82xx_read_optrom_data(ha, (uint8_t *)ha->request_ring,
+			QLA82XX_IDC_PARAM_ADDR , 8);
+
+	if (*wptr == __constant_cpu_to_le32(0xffffffff)) {
+		ha->nx_dev_init_timeout = ROM_DEV_INIT_TIMEOUT;
+		ha->nx_reset_timeout = ROM_DRV_RESET_ACK_TIMEOUT;
+	} else {
+		ha->nx_dev_init_timeout = le32_to_cpu(*wptr++);
+		ha->nx_reset_timeout = le32_to_cpu(*wptr);
+	}
+
+	DEBUG2(ql4_printk(KERN_DEBUG, ha,
+		"ha->nx_dev_init_timeout = %d\n", ha->nx_dev_init_timeout));
+	DEBUG2(ql4_printk(KERN_DEBUG, ha,
+		"ha->nx_reset_timeout = %d\n", ha->nx_reset_timeout));
+	return;
+}
+
+int
+qla82xx_get_flash_info(struct scsi_qla_host *ha)
+{
+	int ret;
+	uint32_t flt_addr;
+
+	ret = qla82xx_find_flt_start(ha, &flt_addr);
+	if (ret != QLA_SUCCESS)
+		return ret;
+
+	qla82xx_get_flt_info(ha, flt_addr);
+	qla82xx_get_fdt_info(ha);
+	qla82xx_get_idc_param(ha);
+
+	return QLA_SUCCESS;
+}
+
+/**
+ * qla82xx_stop_firmware - stops firmware on specified adapter instance
+ * @ha: pointer to host adapter structure.
+ *
+ * Remarks:
+ * For iSCSI, throws away all I/O and AENs into bit bucket, so they will
+ * not be available after successful return.  Driver must cleanup potential
+ * outstanding I/O's after calling this funcion.
+ **/
+int
+qla82xx_stop_firmware(struct scsi_qla_host *ha)
+{
+	int status;
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	mbox_cmd[0] = MBOX_CMD_STOP_FW;
+	status = qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 1, &mbox_cmd[0], &mbox_sts[0]);
+
+	DEBUG2(printk("scsi%ld: %s: status = %d\n", ha->host_no, __func__, status));
+	return status;
+}
+
+/**
+ * qla82xx_isp_reset - Resets ISP and aborts all outstanding commands.
+ * @ha: pointer to host adapter structure.
+ **/
+int
+qla82xx_isp_reset(struct scsi_qla_host *ha)
+{
+	int rval;
+	uint32_t dev_state;
+
+	qla82xx_idc_lock(ha);
+	dev_state = qla82xx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
+
+	if (dev_state == QLA82XX_DEV_READY) {
+		ql4_printk(KERN_INFO, ha, "HW State: NEED RESET\n");
+		qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE, QLA82XX_DEV_NEED_RESET);
+	} else
+		ql4_printk(KERN_INFO, ha, "HW State: DEVICE INITIALIZING\n");
+
+	qla82xx_idc_unlock(ha);
+
+	rval = qla82xx_device_state_handler(ha);
+
+	qla82xx_idc_lock(ha);
+	qla82xx_clear_rst_ready(ha);
+	qla82xx_idc_unlock(ha);
+
+	return rval;
+}
+
+/**
+ * qla82xx_get_sys_info - get adapter MAC address(es) and serial number
+ * @ha: pointer to host adapter structure.
+ *
+ **/
+int qla82xx_get_sys_info(struct scsi_qla_host *ha)
+{
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+	struct mbx_sys_info *sys_info;
+	dma_addr_t sys_info_dma;
+	int status = QLA_ERROR;
+
+	sys_info = dma_alloc_coherent(&ha->pdev->dev, sizeof(*sys_info),
+				      &sys_info_dma, GFP_KERNEL);
+	if (sys_info == NULL) {
+		DEBUG2(printk("scsi%ld: %s: Unable to allocate dma buffer.\n",
+			      ha->host_no, __func__));
+		return status;
+	}
+
+	memset(sys_info, 0, sizeof(*sys_info));
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	mbox_cmd[0] = MBOX_CMD_GET_SYS_INFO;
+	mbox_cmd[1] = LSDW(sys_info_dma);
+	mbox_cmd[2] = MSDW(sys_info_dma);
+	mbox_cmd[4] = sizeof(*sys_info);
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 6, &mbox_cmd[0], &mbox_sts[0]) !=
+	    QLA_SUCCESS) {
+		DEBUG2(printk("scsi%ld: %s: GET_SYS_INFO failed\n",
+			ha->host_no, __func__));
+		goto exit_validate_mac82;
+	}
+
+	if (mbox_sts[4] < sizeof(*sys_info)) {
+		DEBUG2(printk("scsi%ld: %s: GET_SYS_INFO data receive error (%x)\n",
+			ha->host_no, __func__, mbox_sts[4]));
+		goto exit_validate_mac82;
+
+	}
+
+	/* Save M.A.C. address & serial_number */
+	memcpy(ha->my_mac, &sys_info->mac_addr[0],
+		min(sizeof(ha->my_mac), sizeof(sys_info->mac_addr)));
+	memcpy(ha->serial_number, &sys_info->serial_number,
+		min(sizeof(ha->serial_number), sizeof(sys_info->serial_number)));
+
+	DEBUG2(printk("scsi%ld: %s: "
+		"mac %02x:%02x:%02x:%02x:%02x:%02x "
+		"serial %s\n", ha->host_no, __func__,
+		ha->my_mac[0], ha->my_mac[1], ha->my_mac[2],
+		ha->my_mac[3], ha->my_mac[4], ha->my_mac[5],
+		ha->serial_number));
+
+	status = QLA_SUCCESS;
+
+exit_validate_mac82:
+	dma_free_coherent(&ha->pdev->dev, sizeof(*sys_info), sys_info,
+			  sys_info_dma);
+	return status;
+}
+
+/* Interrupt handling helpers. */
+
+int
+qla82xx_mbx_intr_enable(struct scsi_qla_host *ha)
+{
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+
+	DEBUG2(ql4_printk(KERN_INFO, ha, "%s\n", __func__));
+
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+	mbox_cmd[0] = MBOX_CMD_ENABLE_INTRS;
+	mbox_cmd[1] = INTR_ENABLE;
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 1, &mbox_cmd[0],
+		&mbox_sts[0]) != QLA_SUCCESS) {
+		DEBUG2(ql4_printk(KERN_INFO, ha,
+			"%s: MBOX_CMD_ENABLE_INTRS failed (0x%04x)\n",
+			__func__, mbox_sts[0]));
+		return QLA_ERROR;
+	}
+
+	return QLA_SUCCESS;
+}
+
+int
+qla82xx_mbx_intr_disable(struct scsi_qla_host *ha)
+{
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+
+	DEBUG2(ql4_printk(KERN_INFO, ha, "%s\n", __func__));
+
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+	mbox_cmd[0] = MBOX_CMD_ENABLE_INTRS;
+	mbox_cmd[1] = INTR_DISABLE;
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 1, &mbox_cmd[0], &mbox_sts[0]) !=
+	    QLA_SUCCESS) {
+		DEBUG2(ql4_printk(KERN_INFO, ha,
+			"%s: MBOX_CMD_ENABLE_INTRS failed (0x%04x)\n",
+			__func__, mbox_sts[0]));
+		return QLA_ERROR;
+	}
+
+	return QLA_SUCCESS;
+}
+
+void
+qla82xx_enable_intrs(struct scsi_qla_host *ha)
+{
+	(void) qla82xx_mbx_intr_enable(ha);
+
+	spin_lock_irq(&ha->hardware_lock);
+	qla82xx_wr_32(ha, ha->nx_legacy_intr.tgt_mask_reg, 0xfbff); /* BIT 10 - reset */
+	spin_unlock_irq(&ha->hardware_lock);
+	set_bit(AF_INTERRUPTS_ON, &ha->flags);
+}
+
+void
+qla82xx_disable_intrs(struct scsi_qla_host *ha)
+{
+	if (test_bit(AF_INTERRUPTS_ON, &ha->flags))
+		(void) qla82xx_mbx_intr_disable(ha);
+
+	spin_lock_irq(&ha->hardware_lock);
+	qla82xx_wr_32(ha, ha->nx_legacy_intr.tgt_mask_reg, 0x0400); /* BIT 10 - set */
+	spin_unlock_irq(&ha->hardware_lock);
+	clear_bit(AF_INTERRUPTS_ON, &ha->flags);
+}
+
+struct ql4_init_msix_entry {
+	uint16_t entry;
+	uint16_t index;
+	const char *name;
+	irq_handler_t handler;
+};
+
+static struct ql4_init_msix_entry qla82xx_msix_entries[QLA_MSIX_ENTRIES] = {
+	{ QLA_MSIX_DEFAULT, QLA_MIDX_DEFAULT,
+		"qla4xxx (default)", (irq_handler_t)qla82xx_default_intr_handler },
+
+	{ QLA_MSIX_RSP_Q, QLA_MIDX_RSP_Q,
+		"qla4xxx (rsp_q)", (irq_handler_t)qla82xx_msix_rsp_q },
+};
+
+void
+qla82xx_disable_msix(struct scsi_qla_host *ha)
+{
+	int i;
+	struct ql4_msix_entry *qentry;
+
+	for (i = 0; i < QLA_MSIX_ENTRIES; i++) {
+		qentry = &ha->msix_entries[qla82xx_msix_entries[i].index];
+		if (qentry->have_irq) {
+			free_irq(qentry->msix_vector, ha);
+			DEBUG2(ql4_printk(KERN_INFO, ha, "%s: %s\n",
+				__func__, qla82xx_msix_entries[i].name));
+		}
+	}
+	pci_disable_msix(ha->pdev);
+	clear_bit(AF_MSIX_ENABLED, &ha->flags);
+}
+
+int
+qla82xx_enable_msix(struct scsi_qla_host *ha)
+{
+	int i, ret;
+	struct msix_entry entries[QLA_MSIX_ENTRIES];
+	struct ql4_msix_entry *qentry;
+
+	for (i = 0; i < QLA_MSIX_ENTRIES; i++)
+		entries[i].entry = qla82xx_msix_entries[i].entry;
+
+	ret = pci_enable_msix(ha->pdev, entries, ARRAY_SIZE(entries));
+	if (ret) {
+		ql4_printk(KERN_WARNING, ha,
+		    "MSI-X: Failed to enable support -- %d/%d\n",
+		    QLA_MSIX_ENTRIES, ret);
+		goto msix_out;
+	}
+	set_bit(AF_MSIX_ENABLED, &ha->flags);
+
+	for (i = 0; i < QLA_MSIX_ENTRIES; i++) {
+		qentry = &ha->msix_entries[qla82xx_msix_entries[i].index];
+		qentry->msix_vector = entries[i].vector;
+		qentry->msix_entry = entries[i].entry;
+		qentry->have_irq = 0;
+		ret = request_irq(qentry->msix_vector,
+			qla82xx_msix_entries[i].handler, 0, qla82xx_msix_entries[i].name, ha);
+		if (ret) {
+			ql4_printk(KERN_WARNING, ha,
+			    "MSI-X: Unable to register handler -- %x/%d.\n",
+			    qla82xx_msix_entries[i].index, ret);
+			qla82xx_disable_msix(ha);
+			goto msix_out;
+		}
+		qentry->have_irq = 1;
+		DEBUG2(ql4_printk(KERN_INFO, ha, "%s: %s\n",
+			__func__, qla82xx_msix_entries[i].name));
+	}
+
+msix_out:
+	return ret;
+}
diff --git a/drivers/scsi/qla4xxx/ql4_nx.h b/drivers/scsi/qla4xxx/ql4_nx.h
new file mode 100644
index 0000000..cc72a8c
--- /dev/null
+++ b/drivers/scsi/qla4xxx/ql4_nx.h
@@ -0,0 +1,703 @@
+/*
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (c)  2003-2008 QLogic Corporation
+ *
+ * See LICENSE.qla2xxx for copyright and licensing details.
+ */
+#ifndef __QLA_NX_H
+#define __QLA_NX_H
+
+/*
+ * Following are the states of the Phantom. Phantom will set them and
+ * Host will read to check if the fields are correct.
+*/
+#define PHAN_INITIALIZE_FAILED		0xffff
+#define PHAN_INITIALIZE_COMPLETE	0xff01
+
+/* Host writes the following to notify that it has done the init-handshake */
+#define PHAN_INITIALIZE_ACK		0xf00f
+#define PHAN_PEG_RCV_INITIALIZED	0xff01
+
+/*CRB_RELATED*/
+#define QLA82XX_CRB_BASE	QLA82XX_CAM_RAM(0x200)
+#define QLA82XX_REG(X)		(QLA82XX_CRB_BASE+(X))
+
+#define CRB_CMDPEG_STATE		QLA82XX_REG(0x50)
+#define CRB_RCVPEG_STATE		QLA82XX_REG(0x13c)
+#define BOOT_LOADER_DIMM_STATUS		QLA82XX_REG(0x54)
+#define CRB_DMA_SHIFT			QLA82XX_REG(0xcc)
+
+#define QLA82XX_HW_H0_CH_HUB_ADR	0x05
+#define QLA82XX_HW_H1_CH_HUB_ADR	0x0E
+#define QLA82XX_HW_H2_CH_HUB_ADR	0x03
+#define QLA82XX_HW_H3_CH_HUB_ADR	0x01
+#define QLA82XX_HW_H4_CH_HUB_ADR	0x06
+#define QLA82XX_HW_H5_CH_HUB_ADR	0x07
+#define QLA82XX_HW_H6_CH_HUB_ADR	0x08
+
+/*  Hub 0 */
+#define QLA82XX_HW_MN_CRB_AGT_ADR	0x15
+#define QLA82XX_HW_MS_CRB_AGT_ADR	0x25
+
+/*  Hub 1 */
+#define QLA82XX_HW_PS_CRB_AGT_ADR	0x73
+#define QLA82XX_HW_QMS_CRB_AGT_ADR	0x00
+#define QLA82XX_HW_RPMX3_CRB_AGT_ADR	0x0b
+#define QLA82XX_HW_SQGS0_CRB_AGT_ADR	0x01
+#define QLA82XX_HW_SQGS1_CRB_AGT_ADR	0x02
+#define QLA82XX_HW_SQGS2_CRB_AGT_ADR	0x03
+#define QLA82XX_HW_SQGS3_CRB_AGT_ADR	0x04
+#define QLA82XX_HW_C2C0_CRB_AGT_ADR	0x58
+#define QLA82XX_HW_C2C1_CRB_AGT_ADR	0x59
+#define QLA82XX_HW_C2C2_CRB_AGT_ADR	0x5a
+#define QLA82XX_HW_RPMX2_CRB_AGT_ADR	0x0a
+#define QLA82XX_HW_RPMX4_CRB_AGT_ADR	0x0c
+#define QLA82XX_HW_RPMX7_CRB_AGT_ADR	0x0f
+#define QLA82XX_HW_RPMX9_CRB_AGT_ADR	0x12
+#define QLA82XX_HW_SMB_CRB_AGT_ADR	0x18
+
+/*  Hub 2 */
+#define QLA82XX_HW_NIU_CRB_AGT_ADR	0x31
+#define QLA82XX_HW_I2C0_CRB_AGT_ADR	0x19
+#define QLA82XX_HW_I2C1_CRB_AGT_ADR	0x29
+
+#define QLA82XX_HW_SN_CRB_AGT_ADR	0x10
+#define QLA82XX_HW_I2Q_CRB_AGT_ADR	0x20
+#define QLA82XX_HW_LPC_CRB_AGT_ADR	0x22
+#define QLA82XX_HW_ROMUSB_CRB_AGT_ADR   0x21
+#define QLA82XX_HW_QM_CRB_AGT_ADR	0x66
+#define QLA82XX_HW_SQG0_CRB_AGT_ADR	0x60
+#define QLA82XX_HW_SQG1_CRB_AGT_ADR	0x61
+#define QLA82XX_HW_SQG2_CRB_AGT_ADR	0x62
+#define QLA82XX_HW_SQG3_CRB_AGT_ADR	0x63
+#define QLA82XX_HW_RPMX1_CRB_AGT_ADR    0x09
+#define QLA82XX_HW_RPMX5_CRB_AGT_ADR    0x0d
+#define QLA82XX_HW_RPMX6_CRB_AGT_ADR    0x0e
+#define QLA82XX_HW_RPMX8_CRB_AGT_ADR    0x11
+
+/*  Hub 3 */
+#define QLA82XX_HW_PH_CRB_AGT_ADR	0x1A
+#define QLA82XX_HW_SRE_CRB_AGT_ADR	0x50
+#define QLA82XX_HW_EG_CRB_AGT_ADR	0x51
+#define QLA82XX_HW_RPMX0_CRB_AGT_ADR	0x08
+
+/*  Hub 4 */
+#define QLA82XX_HW_PEGN0_CRB_AGT_ADR	0x40
+#define QLA82XX_HW_PEGN1_CRB_AGT_ADR	0x41
+#define QLA82XX_HW_PEGN2_CRB_AGT_ADR	0x42
+#define QLA82XX_HW_PEGN3_CRB_AGT_ADR	0x43
+#define QLA82XX_HW_PEGNI_CRB_AGT_ADR	0x44
+#define QLA82XX_HW_PEGND_CRB_AGT_ADR	0x45
+#define QLA82XX_HW_PEGNC_CRB_AGT_ADR	0x46
+#define QLA82XX_HW_PEGR0_CRB_AGT_ADR	0x47
+#define QLA82XX_HW_PEGR1_CRB_AGT_ADR	0x48
+#define QLA82XX_HW_PEGR2_CRB_AGT_ADR	0x49
+#define QLA82XX_HW_PEGR3_CRB_AGT_ADR	0x4a
+#define QLA82XX_HW_PEGN4_CRB_AGT_ADR	0x4b
+
+/*  Hub 5 */
+#define QLA82XX_HW_PEGS0_CRB_AGT_ADR	0x40
+#define QLA82XX_HW_PEGS1_CRB_AGT_ADR	0x41
+#define QLA82XX_HW_PEGS2_CRB_AGT_ADR	0x42
+#define QLA82XX_HW_PEGS3_CRB_AGT_ADR	0x43
+
+#define QLA82XX_HW_PEGSI_CRB_AGT_ADR	0x44
+#define QLA82XX_HW_PEGSD_CRB_AGT_ADR	0x45
+#define QLA82XX_HW_PEGSC_CRB_AGT_ADR	0x46
+
+/*  Hub 6 */
+#define QLA82XX_HW_CAS0_CRB_AGT_ADR	0x46
+#define QLA82XX_HW_CAS1_CRB_AGT_ADR	0x47
+#define QLA82XX_HW_CAS2_CRB_AGT_ADR	0x48
+#define QLA82XX_HW_CAS3_CRB_AGT_ADR	0x49
+#define QLA82XX_HW_NCM_CRB_AGT_ADR	0x16
+#define QLA82XX_HW_TMR_CRB_AGT_ADR	0x17
+#define QLA82XX_HW_XDMA_CRB_AGT_ADR	0x05
+#define QLA82XX_HW_OCM0_CRB_AGT_ADR	0x06
+#define QLA82XX_HW_OCM1_CRB_AGT_ADR	0x07
+
+/*  This field defines PCI/X adr [25:20] of agents on the CRB */
+/*  */
+#define QLA82XX_HW_PX_MAP_CRB_PH	0
+#define QLA82XX_HW_PX_MAP_CRB_PS	1
+#define QLA82XX_HW_PX_MAP_CRB_MN	2
+#define QLA82XX_HW_PX_MAP_CRB_MS	3
+#define QLA82XX_HW_PX_MAP_CRB_SRE	5
+#define QLA82XX_HW_PX_MAP_CRB_NIU	6
+#define QLA82XX_HW_PX_MAP_CRB_QMN	7
+#define QLA82XX_HW_PX_MAP_CRB_SQN0	8
+#define QLA82XX_HW_PX_MAP_CRB_SQN1	9
+#define QLA82XX_HW_PX_MAP_CRB_SQN2	10
+#define QLA82XX_HW_PX_MAP_CRB_SQN3	11
+#define QLA82XX_HW_PX_MAP_CRB_QMS	12
+#define QLA82XX_HW_PX_MAP_CRB_SQS0	13
+#define QLA82XX_HW_PX_MAP_CRB_SQS1	14
+#define QLA82XX_HW_PX_MAP_CRB_SQS2	15
+#define QLA82XX_HW_PX_MAP_CRB_SQS3	16
+#define QLA82XX_HW_PX_MAP_CRB_PGN0	17
+#define QLA82XX_HW_PX_MAP_CRB_PGN1	18
+#define QLA82XX_HW_PX_MAP_CRB_PGN2	19
+#define QLA82XX_HW_PX_MAP_CRB_PGN3	20
+#define QLA82XX_HW_PX_MAP_CRB_PGN4	QLA82XX_HW_PX_MAP_CRB_SQS2
+#define QLA82XX_HW_PX_MAP_CRB_PGND	21
+#define QLA82XX_HW_PX_MAP_CRB_PGNI	22
+#define QLA82XX_HW_PX_MAP_CRB_PGS0	23
+#define QLA82XX_HW_PX_MAP_CRB_PGS1	24
+#define QLA82XX_HW_PX_MAP_CRB_PGS2	25
+#define QLA82XX_HW_PX_MAP_CRB_PGS3	26
+#define QLA82XX_HW_PX_MAP_CRB_PGSD	27
+#define QLA82XX_HW_PX_MAP_CRB_PGSI	28
+#define QLA82XX_HW_PX_MAP_CRB_SN	29
+#define QLA82XX_HW_PX_MAP_CRB_EG	31
+#define QLA82XX_HW_PX_MAP_CRB_PH2	32
+#define QLA82XX_HW_PX_MAP_CRB_PS2	33
+#define QLA82XX_HW_PX_MAP_CRB_CAM	34
+#define QLA82XX_HW_PX_MAP_CRB_CAS0	35
+#define QLA82XX_HW_PX_MAP_CRB_CAS1	36
+#define QLA82XX_HW_PX_MAP_CRB_CAS2	37
+#define QLA82XX_HW_PX_MAP_CRB_C2C0	38
+#define QLA82XX_HW_PX_MAP_CRB_C2C1	39
+#define QLA82XX_HW_PX_MAP_CRB_TIMR	40
+#define QLA82XX_HW_PX_MAP_CRB_RPMX1	42
+#define QLA82XX_HW_PX_MAP_CRB_RPMX2	43
+#define QLA82XX_HW_PX_MAP_CRB_RPMX3	44
+#define QLA82XX_HW_PX_MAP_CRB_RPMX4	45
+#define QLA82XX_HW_PX_MAP_CRB_RPMX5	46
+#define QLA82XX_HW_PX_MAP_CRB_RPMX6	47
+#define QLA82XX_HW_PX_MAP_CRB_RPMX7	48
+#define QLA82XX_HW_PX_MAP_CRB_XDMA	49
+#define QLA82XX_HW_PX_MAP_CRB_I2Q	50
+#define QLA82XX_HW_PX_MAP_CRB_ROMUSB    51
+#define QLA82XX_HW_PX_MAP_CRB_CAS3	52
+#define QLA82XX_HW_PX_MAP_CRB_RPMX0	53
+#define QLA82XX_HW_PX_MAP_CRB_RPMX8	54
+#define QLA82XX_HW_PX_MAP_CRB_RPMX9	55
+#define QLA82XX_HW_PX_MAP_CRB_OCM0	56
+#define QLA82XX_HW_PX_MAP_CRB_OCM1	57
+#define QLA82XX_HW_PX_MAP_CRB_SMB	58
+#define QLA82XX_HW_PX_MAP_CRB_I2C0	59
+#define QLA82XX_HW_PX_MAP_CRB_I2C1	60
+#define QLA82XX_HW_PX_MAP_CRB_LPC	61
+#define QLA82XX_HW_PX_MAP_CRB_PGNC	62
+#define QLA82XX_HW_PX_MAP_CRB_PGR0	63
+#define QLA82XX_HW_PX_MAP_CRB_PGR1	4
+#define QLA82XX_HW_PX_MAP_CRB_PGR2	30
+#define QLA82XX_HW_PX_MAP_CRB_PGR3	41
+
+/*  This field defines CRB adr [31:20] of the agents */
+/*  */
+
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_MN	((QLA82XX_HW_H0_CH_HUB_ADR << 7) | \
+					QLA82XX_HW_MN_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PH	((QLA82XX_HW_H0_CH_HUB_ADR << 7) | \
+					QLA82XX_HW_PH_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_MS	((QLA82XX_HW_H0_CH_HUB_ADR << 7) | \
+					QLA82XX_HW_MS_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PS	((QLA82XX_HW_H1_CH_HUB_ADR << 7) | \
+					QLA82XX_HW_PS_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_SS	((QLA82XX_HW_H1_CH_HUB_ADR << 7) | \
+					QLA82XX_HW_SS_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX3    ((QLA82XX_HW_H1_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_RPMX3_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_QMS	    ((QLA82XX_HW_H1_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_QMS_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_SQS0     ((QLA82XX_HW_H1_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_SQGS0_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_SQS1     ((QLA82XX_HW_H1_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_SQGS1_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_SQS2     ((QLA82XX_HW_H1_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_SQGS2_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_SQS3     ((QLA82XX_HW_H1_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_SQGS3_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_C2C0     ((QLA82XX_HW_H1_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_C2C0_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_C2C1     ((QLA82XX_HW_H1_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_C2C1_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX2    ((QLA82XX_HW_H1_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_RPMX2_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX4    ((QLA82XX_HW_H1_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_RPMX4_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX7    ((QLA82XX_HW_H1_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_RPMX7_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX9    ((QLA82XX_HW_H1_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_RPMX9_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_SMB	    ((QLA82XX_HW_H1_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_SMB_CRB_AGT_ADR)
+
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_NIU      ((QLA82XX_HW_H2_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_NIU_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_I2C0     ((QLA82XX_HW_H2_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_I2C0_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_I2C1     ((QLA82XX_HW_H2_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_I2C1_CRB_AGT_ADR)
+
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_SRE      ((QLA82XX_HW_H3_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_SRE_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_EG       ((QLA82XX_HW_H3_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_EG_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX0    ((QLA82XX_HW_H3_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_RPMX0_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_QMN      ((QLA82XX_HW_H3_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_QM_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_SQN0     ((QLA82XX_HW_H3_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_SQG0_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_SQN1     ((QLA82XX_HW_H3_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_SQG1_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_SQN2     ((QLA82XX_HW_H3_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_SQG2_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_SQN3     ((QLA82XX_HW_H3_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_SQG3_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX1    ((QLA82XX_HW_H3_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_RPMX1_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX5    ((QLA82XX_HW_H3_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_RPMX5_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX6    ((QLA82XX_HW_H3_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_RPMX6_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_RPMX8    ((QLA82XX_HW_H3_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_RPMX8_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_CAS0     ((QLA82XX_HW_H3_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_CAS0_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_CAS1     ((QLA82XX_HW_H3_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_CAS1_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_CAS2     ((QLA82XX_HW_H3_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_CAS2_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_CAS3     ((QLA82XX_HW_H3_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_CAS3_CRB_AGT_ADR)
+
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGNI     ((QLA82XX_HW_H4_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_PEGNI_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGND     ((QLA82XX_HW_H4_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_PEGND_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGN0     ((QLA82XX_HW_H4_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_PEGN0_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGN1     ((QLA82XX_HW_H4_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_PEGN1_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGN2     ((QLA82XX_HW_H4_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_PEGN2_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGN3     ((QLA82XX_HW_H4_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_PEGN3_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGN4     ((QLA82XX_HW_H4_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_PEGN4_CRB_AGT_ADR)
+
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGNC     ((QLA82XX_HW_H4_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_PEGNC_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGR0     ((QLA82XX_HW_H4_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_PEGR0_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGR1     ((QLA82XX_HW_H4_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_PEGR1_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGR2     ((QLA82XX_HW_H4_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_PEGR2_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGR3     ((QLA82XX_HW_H4_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_PEGR3_CRB_AGT_ADR)
+
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGSI     ((QLA82XX_HW_H5_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_PEGSI_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGSD     ((QLA82XX_HW_H5_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_PEGSD_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGS0     ((QLA82XX_HW_H5_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_PEGS0_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGS1     ((QLA82XX_HW_H5_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_PEGS1_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGS2     ((QLA82XX_HW_H5_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_PEGS2_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGS3     ((QLA82XX_HW_H5_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_PEGS3_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_PGSC     ((QLA82XX_HW_H5_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_PEGSC_CRB_AGT_ADR)
+
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_CAM      ((QLA82XX_HW_H6_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_NCM_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_TIMR     ((QLA82XX_HW_H6_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_TMR_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_XDMA     ((QLA82XX_HW_H6_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_XDMA_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_SN       ((QLA82XX_HW_H6_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_SN_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_I2Q      ((QLA82XX_HW_H6_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_I2Q_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_ROMUSB   ((QLA82XX_HW_H6_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_ROMUSB_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_OCM0     ((QLA82XX_HW_H6_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_OCM0_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_OCM1     ((QLA82XX_HW_H6_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_OCM1_CRB_AGT_ADR)
+#define QLA82XX_HW_CRB_HUB_AGT_ADR_LPC      ((QLA82XX_HW_H6_CH_HUB_ADR << 7) | \
+					    QLA82XX_HW_LPC_CRB_AGT_ADR)
+
+#define ROMUSB_GLB	(QLA82XX_CRB_ROMUSB + 0x00000)
+#define QLA82XX_ROMUSB_GLB_PEGTUNE_DONE		(ROMUSB_GLB + 0x005c)
+#define QLA82XX_ROMUSB_GLB_STATUS		(ROMUSB_GLB + 0x0004)
+#define QLA82XX_ROMUSB_GLB_SW_RESET		(ROMUSB_GLB + 0x0008)
+#define QLA82XX_ROMUSB_ROM_ADDRESS		(ROMUSB_ROM + 0x0008)
+#define QLA82XX_ROMUSB_ROM_WDATA		(ROMUSB_ROM + 0x000c)
+#define QLA82XX_ROMUSB_ROM_ABYTE_CNT		(ROMUSB_ROM + 0x0010)
+#define QLA82XX_ROMUSB_ROM_DUMMY_BYTE_CNT	(ROMUSB_ROM + 0x0014)
+#define QLA82XX_ROMUSB_ROM_RDATA		(ROMUSB_ROM + 0x0018)
+
+#define ROMUSB_ROM	(QLA82XX_CRB_ROMUSB + 0x10000)
+#define QLA82XX_ROMUSB_ROM_INSTR_OPCODE	(ROMUSB_ROM + 0x0004)
+#define QLA82XX_ROMUSB_GLB_CAS_RST	(ROMUSB_GLB + 0x0038)
+
+/* Lock IDs for ROM lock */
+#define ROM_LOCK_DRIVER		0x0d417340
+
+#define QLA82XX_PCI_CRB_WINDOWSIZE	0x00100000    /* all are 1MB windows */
+#define QLA82XX_PCI_CRB_WINDOW(A)	(QLA82XX_PCI_CRBSPACE + \
+					(A)*QLA82XX_PCI_CRB_WINDOWSIZE)
+#define QLA82XX_CRB_C2C_0	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_C2C0)
+#define QLA82XX_CRB_C2C_1	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_C2C1)
+#define QLA82XX_CRB_C2C_2	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_C2C2)
+#define QLA82XX_CRB_CAM		QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_CAM)
+#define QLA82XX_CRB_CASPER	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_CAS)
+#define QLA82XX_CRB_CASPER_0	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_CAS0)
+#define QLA82XX_CRB_CASPER_1	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_CAS1)
+#define QLA82XX_CRB_CASPER_2	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_CAS2)
+#define QLA82XX_CRB_DDR_MD	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_MS)
+#define QLA82XX_CRB_DDR_NET	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_MN)
+#define QLA82XX_CRB_EPG		QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_EG)
+#define QLA82XX_CRB_I2Q		QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_I2Q)
+#define QLA82XX_CRB_NIU		QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_NIU)
+/* HACK upon HACK upon HACK (for PCIE builds) */
+#define QLA82XX_CRB_PCIX_HOST	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_PH)
+#define QLA82XX_CRB_PCIX_HOST2	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_PH2)
+#define QLA82XX_CRB_PCIX_MD	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_PS)
+#define QLA82XX_CRB_PCIE	QLA82XX_CRB_PCIX_MD
+/* window 1 pcie slot */
+#define QLA82XX_CRB_PCIE2	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_PS2)
+
+#define QLA82XX_CRB_PEG_MD_0	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_PGS0)
+#define QLA82XX_CRB_PEG_MD_1	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_PGS1)
+#define QLA82XX_CRB_PEG_MD_2	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_PGS2)
+#define QLA82XX_CRB_PEG_MD_3	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_PGS3)
+#define QLA82XX_CRB_PEG_MD_3	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_PGS3)
+#define QLA82XX_CRB_PEG_MD_D	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_PGSD)
+#define QLA82XX_CRB_PEG_MD_I	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_PGSI)
+#define QLA82XX_CRB_PEG_NET_0	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_PGN0)
+#define QLA82XX_CRB_PEG_NET_1	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_PGN1)
+#define QLA82XX_CRB_PEG_NET_2	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_PGN2)
+#define QLA82XX_CRB_PEG_NET_3	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_PGN3)
+#define QLA82XX_CRB_PEG_NET_4	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_PGN4)
+#define QLA82XX_CRB_PEG_NET_D	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_PGND)
+#define QLA82XX_CRB_PEG_NET_I	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_PGNI)
+#define QLA82XX_CRB_PQM_MD	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_QMS)
+#define QLA82XX_CRB_PQM_NET	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_QMN)
+#define QLA82XX_CRB_QDR_MD	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_SS)
+#define QLA82XX_CRB_QDR_NET	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_SN)
+#define QLA82XX_CRB_ROMUSB	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_ROMUSB)
+#define QLA82XX_CRB_RPMX_0	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_RPMX0)
+#define QLA82XX_CRB_RPMX_1	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_RPMX1)
+#define QLA82XX_CRB_RPMX_2	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_RPMX2)
+#define QLA82XX_CRB_RPMX_3	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_RPMX3)
+#define QLA82XX_CRB_RPMX_4	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_RPMX4)
+#define QLA82XX_CRB_RPMX_5	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_RPMX5)
+#define QLA82XX_CRB_RPMX_6	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_RPMX6)
+#define QLA82XX_CRB_RPMX_7	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_RPMX7)
+#define QLA82XX_CRB_SQM_MD_0	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_SQS0)
+#define QLA82XX_CRB_SQM_MD_1	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_SQS1)
+#define QLA82XX_CRB_SQM_MD_2	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_SQS2)
+#define QLA82XX_CRB_SQM_MD_3	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_SQS3)
+#define QLA82XX_CRB_SQM_NET_0	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_SQN0)
+#define QLA82XX_CRB_SQM_NET_1	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_SQN1)
+#define QLA82XX_CRB_SQM_NET_2	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_SQN2)
+#define QLA82XX_CRB_SQM_NET_3	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_SQN3)
+#define QLA82XX_CRB_SRE		QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_SRE)
+#define QLA82XX_CRB_TIMER	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_TIMR)
+#define QLA82XX_CRB_XDMA	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_XDMA)
+#define QLA82XX_CRB_I2C0	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_I2C0)
+#define QLA82XX_CRB_I2C1	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_I2C1)
+#define QLA82XX_CRB_OCM0	QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_OCM0)
+#define QLA82XX_CRB_SMB		QLA82XX_PCI_CRB_WINDOW(QLA82XX_HW_PX_MAP_CRB_SMB)
+
+#define QLA82XX_CRB_MAX		QLA82XX_PCI_CRB_WINDOW(64)
+
+/*
+ * ====================== BASE ADDRESSES ON-CHIP ======================
+ * Base addresses of major components on-chip.
+ * ====================== BASE ADDRESSES ON-CHIP ======================
+ */
+#define QLA82XX_ADDR_DDR_NET		(0x0000000000000000ULL)
+#define QLA82XX_ADDR_DDR_NET_MAX	(0x000000000fffffffULL)
+
+/* Imbus address bit used to indicate a host address. This bit is
+ * eliminated by the pcie bar and bar select before presentation
+ * over pcie. */
+/* host memory via IMBUS */
+#define QLA82XX_P2_ADDR_PCIE	(0x0000000800000000ULL)
+#define QLA82XX_P3_ADDR_PCIE	(0x0000008000000000ULL)
+#define QLA82XX_ADDR_PCIE_MAX	(0x0000000FFFFFFFFFULL)
+#define QLA82XX_ADDR_OCM0	(0x0000000200000000ULL)
+#define QLA82XX_ADDR_OCM0_MAX	(0x00000002000fffffULL)
+#define QLA82XX_ADDR_OCM1	(0x0000000200400000ULL)
+#define QLA82XX_ADDR_OCM1_MAX	(0x00000002004fffffULL)
+#define QLA82XX_ADDR_QDR_NET	(0x0000000300000000ULL)
+
+#define QLA82XX_P2_ADDR_QDR_NET_MAX	(0x00000003001fffffULL)
+#define QLA82XX_P3_ADDR_QDR_NET_MAX	(0x0000000303ffffffULL)
+
+#define QLA82XX_PCI_CRBSPACE		(unsigned long)0x06000000
+#define QLA82XX_PCI_DIRECT_CRB		(unsigned long)0x04400000
+#define QLA82XX_PCI_CAMQM		(unsigned long)0x04800000
+#define QLA82XX_PCI_CAMQM_MAX		(unsigned long)0x04ffffff
+#define QLA82XX_PCI_DDR_NET		(unsigned long)0x00000000
+#define QLA82XX_PCI_QDR_NET		(unsigned long)0x04000000
+#define QLA82XX_PCI_QDR_NET_MAX		(unsigned long)0x043fffff
+
+/*
+ *   Register offsets for MN
+ */
+#define MIU_CONTROL			(0x000)
+#define MIU_TAG				(0x004)
+#define MIU_TEST_AGT_CTRL		(0x090)
+#define MIU_TEST_AGT_ADDR_LO		(0x094)
+#define MIU_TEST_AGT_ADDR_HI		(0x098)
+#define MIU_TEST_AGT_WRDATA_LO		(0x0a0)
+#define MIU_TEST_AGT_WRDATA_HI		(0x0a4)
+#define MIU_TEST_AGT_WRDATA(i)		(0x0a0+(4*(i)))
+#define MIU_TEST_AGT_RDDATA_LO		(0x0a8)
+#define MIU_TEST_AGT_RDDATA_HI		(0x0ac)
+#define MIU_TEST_AGT_RDDATA(i)		(0x0a8+(4*(i)))
+#define MIU_TEST_AGT_ADDR_MASK		0xfffffff8
+#define MIU_TEST_AGT_UPPER_ADDR(off)	(0)
+
+/* MIU_TEST_AGT_CTRL flags. work for SIU as well */
+#define MIU_TA_CTL_START	1
+#define MIU_TA_CTL_ENABLE	2
+#define MIU_TA_CTL_WRITE	4
+#define MIU_TA_CTL_BUSY		8
+
+/*CAM RAM */
+# define QLA82XX_CAM_RAM_BASE	(QLA82XX_CRB_CAM + 0x02000)
+# define QLA82XX_CAM_RAM(reg)	(QLA82XX_CAM_RAM_BASE + (reg))
+
+#define QLA82XX_PEG_TUNE_MN_SPD_ZEROED	0x80000000
+#define QLA82XX_BOOT_LOADER_MN_ISSUE	0xff00ffff
+#define QLA82XX_PORT_MODE_ADDR		(QLA82XX_CAM_RAM(0x24))
+#define QLA82XX_PEG_HALT_STATUS1	(QLA82XX_CAM_RAM(0xa8))
+#define QLA82XX_PEG_HALT_STATUS2	(QLA82XX_CAM_RAM(0xac))
+#define QLA82XX_PEG_ALIVE_COUNTER	(QLA82XX_CAM_RAM(0xb0))
+
+#define HALT_STATUS_UNRECOVERABLE	0x80000000
+#define HALT_STATUS_RECOVERABLE		0x40000000
+
+
+#define QLA82XX_ROM_LOCK_ID		(QLA82XX_CAM_RAM(0x100))
+#define QLA82XX_CRB_WIN_LOCK_ID		(QLA82XX_CAM_RAM(0x124))
+#define QLA82XX_FW_VERSION_MAJOR	(QLA82XX_CAM_RAM(0x150))
+#define QLA82XX_FW_VERSION_MINOR	(QLA82XX_CAM_RAM(0x154))
+#define QLA82XX_FW_VERSION_SUB		(QLA82XX_CAM_RAM(0x158))
+#define QLA82XX_PCIE_REG(reg)		(QLA82XX_CRB_PCIE + (reg))
+
+/* Driver Coexistence Defines */
+#define QLA82XX_CRB_DRV_ACTIVE		(QLA82XX_CAM_RAM(0x138))
+#define QLA82XX_CRB_DEV_STATE		(QLA82XX_CAM_RAM(0x140))
+#define QLA82XX_CRB_DEV_PART_INFO	(QLA82XX_CAM_RAM(0x14c))
+#define QLA82XX_CRB_DRV_IDC_VERSION	(QLA82XX_CAM_RAM(0x174))
+#define QLA82XX_CRB_DRV_STATE		(QLA82XX_CAM_RAM(0x144))
+#define QLA82XX_CRB_DRV_SCRATCH		(QLA82XX_CAM_RAM(0x148))
+#define QLA82XX_CRB_DEV_PART_INFO	(QLA82XX_CAM_RAM(0x14c))
+
+/* Every driver should use these Device State */
+#define QLA82XX_DEV_COLD		1
+#define QLA82XX_DEV_INITIALIZING	2
+#define QLA82XX_DEV_READY		3
+#define QLA82XX_DEV_NEED_RESET		4
+#define QLA82XX_DEV_NEED_QUIESCENT	5
+#define QLA82XX_DEV_FAILED		6
+#define QLA82XX_DEV_QUIESCENT		7
+#define MAX_STATES			8 /* Increment if new state added */
+
+#define QLA82XX_IDC_VERSION		0x1
+#define ROM_DEV_INIT_TIMEOUT 		30
+#define ROM_DRV_RESET_ACK_TIMEOUT 	10
+
+#define PCIE_SETUP_FUNCTION		(0x12040)
+#define PCIE_SETUP_FUNCTION2		(0x12048)
+
+#define QLA82XX_PCIX_PS_REG(reg)	(QLA82XX_CRB_PCIX_MD + (reg))
+#define QLA82XX_PCIX_PS2_REG(reg)	(QLA82XX_CRB_PCIE2 + (reg))
+
+#define PCIE_SEM2_LOCK		(0x1c010)  /* Flash lock   */
+#define PCIE_SEM2_UNLOCK	(0x1c014)  /* Flash unlock */
+#define PCIE_SEM5_LOCK		(0x1c028)  /* Coexistence lock   */
+#define PCIE_SEM5_UNLOCK	(0x1c02c)  /* Coexistence unlock */
+#define PCIE_SEM7_LOCK		(0x1c038)  /* crb win lock */
+#define PCIE_SEM7_UNLOCK	(0x1c03c)  /* crbwin unlock*/
+
+/*
+ * The PCI VendorID and DeviceID for our board.
+ */
+#define QLA82XX_MSIX_TBL_SPACE		8192
+#define QLA82XX_PCI_REG_MSIX_TBL	0x44
+#define QLA82XX_PCI_MSIX_CONTROL	0x40
+
+struct crb_128M_2M_sub_block_map {
+	unsigned valid;
+	unsigned start_128M;
+	unsigned end_128M;
+	unsigned start_2M;
+};
+
+struct crb_128M_2M_block_map {
+	struct crb_128M_2M_sub_block_map sub_block[16];
+};
+
+struct crb_addr_pair {
+	long addr;
+	long data;
+};
+
+#define ADDR_ERROR	((unsigned long) 0xffffffff)
+#define MAX_CTL_CHECK	1000
+
+/***************************************************************************
+ *		PCI related defines.
+ **************************************************************************/
+
+/*
+ * Interrupt related defines.
+ */
+#define PCIX_TARGET_STATUS	(0x10118)
+#define PCIX_TARGET_STATUS_F1	(0x10160)
+#define PCIX_TARGET_STATUS_F2	(0x10164)
+#define PCIX_TARGET_STATUS_F3	(0x10168)
+#define PCIX_TARGET_STATUS_F4	(0x10360)
+#define PCIX_TARGET_STATUS_F5	(0x10364)
+#define PCIX_TARGET_STATUS_F6	(0x10368)
+#define PCIX_TARGET_STATUS_F7	(0x1036c)
+
+#define PCIX_TARGET_MASK	(0x10128)
+#define PCIX_TARGET_MASK_F1	(0x10170)
+#define PCIX_TARGET_MASK_F2	(0x10174)
+#define PCIX_TARGET_MASK_F3	(0x10178)
+#define PCIX_TARGET_MASK_F4	(0x10370)
+#define PCIX_TARGET_MASK_F5	(0x10374)
+#define PCIX_TARGET_MASK_F6	(0x10378)
+#define PCIX_TARGET_MASK_F7	(0x1037c)
+
+/*
+ * Message Signaled Interrupts
+ */
+#define PCIX_MSI_F0		(0x13000)
+#define PCIX_MSI_F1		(0x13004)
+#define PCIX_MSI_F2		(0x13008)
+#define PCIX_MSI_F3		(0x1300c)
+#define PCIX_MSI_F4		(0x13010)
+#define PCIX_MSI_F5		(0x13014)
+#define PCIX_MSI_F6		(0x13018)
+#define PCIX_MSI_F7		(0x1301c)
+#define PCIX_MSI_F(FUNC)	(0x13000 + ((FUNC) * 4))
+
+/*
+ *
+ */
+#define PCIX_INT_VECTOR		(0x10100)
+#define PCIX_INT_MASK		(0x10104)
+
+/*
+ * Interrupt state machine and other bits.
+ */
+#define PCIE_MISCCFG_RC		(0x1206c)
+
+
+#define ISR_INT_TARGET_STATUS		(QLA82XX_PCIX_PS_REG(PCIX_TARGET_STATUS))
+#define ISR_INT_TARGET_STATUS_F1	(QLA82XX_PCIX_PS_REG(PCIX_TARGET_STATUS_F1))
+#define ISR_INT_TARGET_STATUS_F2	(QLA82XX_PCIX_PS_REG(PCIX_TARGET_STATUS_F2))
+#define ISR_INT_TARGET_STATUS_F3	(QLA82XX_PCIX_PS_REG(PCIX_TARGET_STATUS_F3))
+#define ISR_INT_TARGET_STATUS_F4	(QLA82XX_PCIX_PS_REG(PCIX_TARGET_STATUS_F4))
+#define ISR_INT_TARGET_STATUS_F5	(QLA82XX_PCIX_PS_REG(PCIX_TARGET_STATUS_F5))
+#define ISR_INT_TARGET_STATUS_F6	(QLA82XX_PCIX_PS_REG(PCIX_TARGET_STATUS_F6))
+#define ISR_INT_TARGET_STATUS_F7	(QLA82XX_PCIX_PS_REG(PCIX_TARGET_STATUS_F7))
+
+#define ISR_INT_TARGET_MASK		(QLA82XX_PCIX_PS_REG(PCIX_TARGET_MASK))
+#define ISR_INT_TARGET_MASK_F1		(QLA82XX_PCIX_PS_REG(PCIX_TARGET_MASK_F1))
+#define ISR_INT_TARGET_MASK_F2		(QLA82XX_PCIX_PS_REG(PCIX_TARGET_MASK_F2))
+#define ISR_INT_TARGET_MASK_F3		(QLA82XX_PCIX_PS_REG(PCIX_TARGET_MASK_F3))
+#define ISR_INT_TARGET_MASK_F4		(QLA82XX_PCIX_PS_REG(PCIX_TARGET_MASK_F4))
+#define ISR_INT_TARGET_MASK_F5		(QLA82XX_PCIX_PS_REG(PCIX_TARGET_MASK_F5))
+#define ISR_INT_TARGET_MASK_F6		(QLA82XX_PCIX_PS_REG(PCIX_TARGET_MASK_F6))
+#define ISR_INT_TARGET_MASK_F7		(QLA82XX_PCIX_PS_REG(PCIX_TARGET_MASK_F7))
+
+#define ISR_INT_VECTOR			(QLA82XX_PCIX_PS_REG(PCIX_INT_VECTOR))
+#define ISR_INT_MASK			(QLA82XX_PCIX_PS_REG(PCIX_INT_MASK))
+#define ISR_INT_STATE_REG		(QLA82XX_PCIX_PS_REG(PCIE_MISCCFG_RC))
+
+#define	ISR_MSI_INT_TRIGGER(FUNC)	(QLA82XX_PCIX_PS_REG(PCIX_MSI_F(FUNC)))
+
+
+#define	ISR_IS_LEGACY_INTR_IDLE(VAL)		(((VAL) & 0x300) == 0)
+#define	ISR_IS_LEGACY_INTR_TRIGGERED(VAL)	(((VAL) & 0x300) == 0x200)
+
+/*
+ * PCI Interrupt Vector Values.
+ */
+#define	PCIX_INT_VECTOR_BIT_F0	0x0080
+#define	PCIX_INT_VECTOR_BIT_F1	0x0100
+#define	PCIX_INT_VECTOR_BIT_F2	0x0200
+#define	PCIX_INT_VECTOR_BIT_F3	0x0400
+#define	PCIX_INT_VECTOR_BIT_F4	0x0800
+#define	PCIX_INT_VECTOR_BIT_F5	0x1000
+#define	PCIX_INT_VECTOR_BIT_F6	0x2000
+#define	PCIX_INT_VECTOR_BIT_F7	0x4000
+
+/* struct qla82xx_legacy_intr_set defined in ql4_def.h */
+
+#define QLA82XX_LEGACY_INTR_CONFIG                                      \
+{                                                                       \
+	{                                                               \
+		.int_vec_bit    =	PCIX_INT_VECTOR_BIT_F0,         \
+		.tgt_status_reg =	ISR_INT_TARGET_STATUS,          \
+		.tgt_mask_reg   =	ISR_INT_TARGET_MASK,            \
+		.pci_int_reg    =	ISR_MSI_INT_TRIGGER(0) },       \
+									\
+	{								\
+		.int_vec_bit    =	PCIX_INT_VECTOR_BIT_F1,         \
+		.tgt_status_reg =	ISR_INT_TARGET_STATUS_F1,       \
+		.tgt_mask_reg   =	ISR_INT_TARGET_MASK_F1,         \
+		.pci_int_reg    =	ISR_MSI_INT_TRIGGER(1) },       \
+									\
+	{				 				\
+		.int_vec_bit    =	PCIX_INT_VECTOR_BIT_F2,         \
+		.tgt_status_reg =	ISR_INT_TARGET_STATUS_F2,       \
+		.tgt_mask_reg   =	ISR_INT_TARGET_MASK_F2,         \
+		.pci_int_reg    =	ISR_MSI_INT_TRIGGER(2) },       \
+									\
+	{								\
+		.int_vec_bit    =	PCIX_INT_VECTOR_BIT_F3,         \
+		.tgt_status_reg =	ISR_INT_TARGET_STATUS_F3,       \
+		.tgt_mask_reg   =	ISR_INT_TARGET_MASK_F3,         \
+		.pci_int_reg    =	ISR_MSI_INT_TRIGGER(3) },       \
+									\
+	{								\
+		.int_vec_bit    =	PCIX_INT_VECTOR_BIT_F4,         \
+		.tgt_status_reg =	ISR_INT_TARGET_STATUS_F4,       \
+		.tgt_mask_reg   =	ISR_INT_TARGET_MASK_F4,         \
+		.pci_int_reg    =	ISR_MSI_INT_TRIGGER(4) },       \
+									\
+	{								\
+		.int_vec_bit    =	PCIX_INT_VECTOR_BIT_F5,         \
+		.tgt_status_reg =	ISR_INT_TARGET_STATUS_F5,       \
+		.tgt_mask_reg   =	ISR_INT_TARGET_MASK_F5,         \
+		.pci_int_reg    =	ISR_MSI_INT_TRIGGER(5) },       \
+									\
+	{								\
+		.int_vec_bit    =	PCIX_INT_VECTOR_BIT_F6,         \
+		.tgt_status_reg =	ISR_INT_TARGET_STATUS_F6,       \
+		.tgt_mask_reg   =	ISR_INT_TARGET_MASK_F6,         \
+		.pci_int_reg    =	ISR_MSI_INT_TRIGGER(6) },       \
+									\
+	{								\
+		.int_vec_bit    =	PCIX_INT_VECTOR_BIT_F7,         \
+		.tgt_status_reg =	ISR_INT_TARGET_STATUS_F7,       \
+		.tgt_mask_reg   =	ISR_INT_TARGET_MASK_F7,         \
+		.pci_int_reg    =	ISR_MSI_INT_TRIGGER(7) },       \
+}
+
+/* Magic number to let user know flash is programmed */
+#define   QLA82XX_BDINFO_MAGIC 	0x12345678
+#define FW_SIZE_OFFSET		(0x3e840c)
+
+/* QLA82XX additions */
+#define MIU_TEST_AGT_WRDATA_UPPER_LO	(0x0b0)
+#define	MIU_TEST_AGT_WRDATA_UPPER_HI	(0x0b4)
+
+#endif
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 6e72162..0e8d335 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -29,22 +29,29 @@ static struct kmem_cache *srb_cachep;
  * Module parameter information and variables
  */
 int ql4xdiscoverywait = 60;
-module_param(ql4xdiscoverywait, int, S_IRUGO | S_IRUSR);
+module_param(ql4xdiscoverywait, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(ql4xdiscoverywait, "Discovery wait time");
-int ql4xdontresethba = 0;
-module_param(ql4xdontresethba, int, S_IRUGO | S_IRUSR);
-MODULE_PARM_DESC(ql4xdontresethba,
-		 "Dont reset the HBA when the driver gets 0x8002 AEN "
-		 " default it will reset hba :0"
-		 " set to 1 to avoid resetting HBA");
 
 int ql4xextended_error_logging = 0; /* 0 = off, 1 = log errors */
-module_param(ql4xextended_error_logging, int, S_IRUGO | S_IRUSR);
+module_param(ql4xextended_error_logging, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(ql4xextended_error_logging,
 		 "Option to enable extended error logging, "
 		 "Default is 0 - no logging, 1 - debug logging");
 
-int ql4_mod_unload = 0;
+int ql4xdontresethba;
+module_param(ql4xdontresethba, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(ql4xdontresethba,
+		"Don't reset the HBA for driver recovery \n"
+		" 0 - It will reset HBA (Default)\n"
+		" 1 - It will NOT reset HBA");
+
+int ql4xenablemsix = 1;
+module_param(ql4xenablemsix, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(ql4xenablemsix,
+		"Set to enable MSI or MSI-X interrupt mechanism.\n"
+		" 0 = enable INTx interrupt mechanism.\n"
+		" 1 = enable MSI-X interrupt mechanism (Default).\n"
+		" 2 = enable MSI interrupt mechanism.");
 
 #define QL4_DEF_QDEPTH 32
 
@@ -82,6 +89,9 @@ static int qla4xxx_slave_configure(struct scsi_device *device);
 static void qla4xxx_slave_destroy(struct scsi_device *sdev);
 static void qla4xxx_scan_start(struct Scsi_Host *shost);
 
+static struct qla82xx_legacy_intr_set legacy_intr[] =
+    QLA82XX_LEGACY_INTR_CONFIG;
+
 static struct scsi_host_template qla4xxx_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= DRIVER_NAME,
@@ -151,15 +161,12 @@ static void qla4xxx_recovery_timedout(struct iscsi_cls_session *session)
 	if (atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE) {
 		atomic_set(&ddb_entry->state, DDB_STATE_DEAD);
 
-		DEBUG2(printk("scsi%ld: %s: index [%d] port down retry count "
+		DEBUG2(printk("scsi%ld: %s: ddb [%d] port down retry count "
 			      "of (%d) secs exhausted, marking device DEAD.\n",
 			      ha->host_no, __func__, ddb_entry->fw_ddb_index,
 			      ha->port_down_retry_count));
 
-		DEBUG2(printk("scsi%ld: %s: scheduling dpc routine - dpc "
-			      "flags = 0x%lx\n",
-			      ha->host_no, __func__, ha->dpc_flags));
-		queue_work(ha->dpc_thread, &ha->dpc_work);
+		qla4xxx_wake_dpc(ha);
 	}
 }
 
@@ -285,7 +292,7 @@ int qla4xxx_add_sess(struct ddb_entry *ddb_entry)
 {
 	int err;
 
-	ddb_entry->sess->recovery_tmo = ddb_entry->ha->port_down_retry_count;
+	ddb_entry->sess->recovery_tmo = ddb_entry->ka_timeout;
 	err = iscsi_add_session(ddb_entry->sess, ddb_entry->fw_ddb_index);
 	if (err) {
 		DEBUG2(printk(KERN_ERR "Could not add session.\n"));
@@ -361,19 +368,37 @@ static void qla4xxx_stop_timer(struct scsi_qla_host *ha)
  * @ha: Pointer to host adapter structure.
  * @ddb_entry: Pointer to device database entry
  *
- * This routine marks a device missing and resets the relogin retry count.
+ * This routine marks a device missing and close connection.
  **/
 void qla4xxx_mark_device_missing(struct scsi_qla_host *ha,
 				 struct ddb_entry *ddb_entry)
 {
-	atomic_set(&ddb_entry->state, DDB_STATE_MISSING);
-	DEBUG3(printk("scsi%d:%d:%d: index [%d] marked MISSING\n",
-		      ha->host_no, ddb_entry->bus, ddb_entry->target,
-		      ddb_entry->fw_ddb_index));
+	if ((atomic_read(&ddb_entry->state) != DDB_STATE_DEAD)) {
+		atomic_set(&ddb_entry->state, DDB_STATE_MISSING);
+		DEBUG2(printk("scsi%ld: ddb [%d] marked MISSING\n",
+		    ha->host_no, ddb_entry->fw_ddb_index));
+	} else
+		DEBUG2(printk("scsi%ld: ddb [%d] DEAD\n", ha->host_no,
+		    ddb_entry->fw_ddb_index))
+
 	iscsi_block_session(ddb_entry->sess);
 	iscsi_conn_error_event(ddb_entry->conn, ISCSI_ERR_CONN_FAILED);
 }
 
+/**
+ * qla4xxx_mark_all_devices_missing - mark all devices as missing.
+ * @ha: Pointer to host adapter structure.
+ *
+ * This routine marks a device missing and resets the relogin retry count.
+ **/
+void qla4xxx_mark_all_devices_missing(struct scsi_qla_host *ha)
+{
+	struct ddb_entry *ddb_entry, *ddbtemp;
+	list_for_each_entry_safe(ddb_entry, ddbtemp, &ha->ddb_list, list) {
+		qla4xxx_mark_device_missing(ha, ddb_entry);
+	}
+}
+
 static struct srb* qla4xxx_get_new_srb(struct scsi_qla_host *ha,
 				       struct ddb_entry *ddb_entry,
 				       struct scsi_cmnd *cmd,
@@ -462,7 +487,13 @@ static int qla4xxx_queuecommand(struct scsi_cmnd *cmd,
 		return SCSI_MLQUEUE_TARGET_BUSY;
 	}
 
-	if (test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags))
+	if (test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags) ||
+	    test_bit(DPC_RESET_ACTIVE, &ha->dpc_flags) ||
+	    test_bit(DPC_RESET_HA, &ha->dpc_flags) ||
+	    test_bit(DPC_HA_UNRECOVERABLE, &ha->dpc_flags) ||
+	    test_bit(DPC_HA_NEED_QUIESCENT, &ha->dpc_flags) ||
+	    !test_bit(AF_ONLINE, &ha->flags) ||
+	    test_bit(DPC_RESET_HA_FW_CONTEXT, &ha->dpc_flags))
 		goto qc_host_busy;
 
 	spin_unlock_irq(ha->host->host_lock);
@@ -523,7 +554,13 @@ static void qla4xxx_mem_free(struct scsi_qla_host *ha)
 	ha->srb_mempool = NULL;
 
 	/* release io space registers  */
-	if (ha->reg)
+	if (is_qla8022(ha)) {
+		if (ha->nx_pcibase)
+			iounmap((struct device_reg_82xx __iomem *)ha->nx_pcibase);
+
+		if (ha->nx_db_wr_ptr)
+			iounmap((struct device_reg_82xx __iomem *)ha->nx_db_wr_ptr);
+	} else if (ha->reg)
 		iounmap(ha->reg);
 	pci_release_regions(ha->pdev);
 }
@@ -599,6 +636,73 @@ mem_alloc_error_exit:
 }
 
 /**
+ * qla82xx_check_fw_alive  - Check firmware health
+ * @ha: Pointer to host adapter structure.
+ *
+ * Context: Interrupt
+ **/
+static void qla82xx_check_fw_alive(struct scsi_qla_host *ha)
+{
+	uint32_t fw_heartbeat_counter, halt_status;
+
+	fw_heartbeat_counter = qla82xx_rd_32(ha, QLA82XX_PEG_ALIVE_COUNTER);
+
+	if (ha->fw_heartbeat_counter == fw_heartbeat_counter) {
+		ha->seconds_since_last_heartbeat++;
+		/* FW not alive after 2 seconds */
+		if (ha->seconds_since_last_heartbeat == 2) {
+			ha->seconds_since_last_heartbeat = 0;
+			halt_status = qla82xx_rd_32(ha, QLA82XX_PEG_HALT_STATUS1);
+			/* Since we cannot change dev_state in interrupt
+			 * context, set appropriate DPC flag then wakeup
+			 * DPC */
+			if (halt_status & HALT_STATUS_UNRECOVERABLE)
+				set_bit(DPC_HA_UNRECOVERABLE, &ha->dpc_flags);
+			else {
+				printk("scsi%ld: %s: detect abort needed!\n",
+				    ha->host_no, __func__);
+				set_bit(DPC_RESET_HA, &ha->dpc_flags);
+			}
+			qla4xxx_wake_dpc(ha);
+		}
+	}
+	ha->fw_heartbeat_counter = fw_heartbeat_counter;
+}
+
+/**
+ * qla82xx_watchdog - Poll dev state
+ * @ha: Pointer to host adapter structure.
+ *
+ * Context: Interrupt
+ **/
+void qla82xx_watchdog(struct scsi_qla_host *ha)
+{
+	uint32_t dev_state;
+
+	dev_state = qla82xx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
+
+	/* don't poll if reset is going on */
+	if (!test_bit(DPC_RESET_ACTIVE, &ha->dpc_flags)) {
+		if (dev_state == QLA82XX_DEV_NEED_RESET &&
+		    !test_bit(DPC_RESET_HA, &ha->dpc_flags)) {
+			printk("scsi%ld: %s: HW State: NEED RESET!\n",
+			    ha->host_no, __func__);
+			set_bit(DPC_RESET_HA, &ha->dpc_flags);
+			qla4xxx_wake_dpc(ha);
+		} else if (dev_state == QLA82XX_DEV_NEED_QUIESCENT &&
+		    !test_bit(DPC_HA_NEED_QUIESCENT, &ha->dpc_flags)) {
+			printk("scsi%ld: %s: HW State: NEED QUIES!\n",
+			    ha->host_no, __func__);
+			set_bit(DPC_HA_NEED_QUIESCENT, &ha->dpc_flags);
+			qla4xxx_wake_dpc(ha);
+		} else  {
+			/* Check firmware health */
+			qla82xx_check_fw_alive(ha);
+		}
+	}
+}
+
+/**
  * qla4xxx_timer - checks every second for work to do.
  * @ha: Pointer to host adapter structure.
  **/
@@ -607,6 +711,16 @@ static void qla4xxx_timer(struct scsi_qla_host *ha)
 	struct ddb_entry *ddb_entry, *dtemp;
 	int start_dpc = 0;
 
+	if (test_bit(AF_HBA_GOING_AWAY, &ha->flags)) {
+		DEBUG2(ql4_printk(KERN_INFO, ha, "%s exited. HBA GOING AWAY\n",
+		    __func__));
+		return;
+	}
+
+	if (is_qla8022(ha)) {
+		qla82xx_watchdog(ha);
+	}
+
 	/* Search for relogin's to time-out and port down retry. */
 	list_for_each_entry_safe(ddb_entry, dtemp, &ha->ddb_list, list) {
 		/* Count down time between sending relogins */
@@ -623,7 +737,7 @@ static void qla4xxx_timer(struct scsi_qla_host *ha)
 					set_bit(DPC_RELOGIN_DEVICE,
 						&ha->dpc_flags);
 					set_bit(DF_RELOGIN, &ddb_entry->flags);
-					DEBUG2(printk("scsi%ld: %s: index [%d]"
+					DEBUG2(printk("scsi%ld: %s: ddb [%d]"
 						      " login device\n",
 						      ha->host_no, __func__,
 						      ddb_entry->fw_ddb_index));
@@ -646,7 +760,7 @@ static void qla4xxx_timer(struct scsi_qla_host *ha)
 			    DDB_DS_SESSION_FAILED) {
 				/* Reset retry relogin timer */
 				atomic_inc(&ddb_entry->relogin_retry_count);
-				DEBUG2(printk("scsi%ld: index[%d] relogin"
+				DEBUG2(printk("scsi%ld: ddb [%d] relogin"
 					      " timed out-retrying"
 					      " relogin (%d)\n",
 					      ha->host_no,
@@ -655,7 +769,7 @@ static void qla4xxx_timer(struct scsi_qla_host *ha)
 							  relogin_retry_count))
 					);
 				start_dpc++;
-				DEBUG(printk("scsi%ld:%d:%d: index [%d] "
+				DEBUG(printk("scsi%ld:%d:%d: ddb [%d] "
 					     "initate relogin after"
 					     " %d seconds\n",
 					     ha->host_no, ddb_entry->bus,
@@ -670,31 +784,35 @@ static void qla4xxx_timer(struct scsi_qla_host *ha)
 		}
 	}
 
-	/* Check for heartbeat interval. */
-	if (ha->firmware_options & FWOPT_HEARTBEAT_ENABLE &&
-	    ha->heartbeat_interval != 0) {
-		ha->seconds_since_last_heartbeat++;
-		if (ha->seconds_since_last_heartbeat >
-		    ha->heartbeat_interval + 2)
-			set_bit(DPC_RESET_HA, &ha->dpc_flags);
+	if (!is_qla8022(ha)) {
+		/* Check for heartbeat interval. */
+		if (ha->firmware_options & FWOPT_HEARTBEAT_ENABLE &&
+		    ha->heartbeat_interval != 0) {
+			ha->seconds_since_last_heartbeat++;
+			if (ha->seconds_since_last_heartbeat >
+			    ha->heartbeat_interval + 2)
+				set_bit(DPC_RESET_HA, &ha->dpc_flags);
+		}
 	}
 
-
 	/* Wakeup the dpc routine for this adapter, if needed. */
 	if ((start_dpc ||
 	     test_bit(DPC_RESET_HA, &ha->dpc_flags) ||
 	     test_bit(DPC_RETRY_RESET_HA, &ha->dpc_flags) ||
 	     test_bit(DPC_RELOGIN_DEVICE, &ha->dpc_flags) ||
-	     test_bit(DPC_RESET_HA_DESTROY_DDB_LIST, &ha->dpc_flags) ||
+	     test_bit(DPC_RESET_HA_FW_CONTEXT, &ha->dpc_flags) ||
 	     test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags) ||
 	     test_bit(DPC_GET_DHCP_IP_ADDR, &ha->dpc_flags) ||
 	     test_bit(DPC_LINK_CHANGED, &ha->dpc_flags) ||
+	     test_bit(DPC_HA_UNRECOVERABLE, &ha->dpc_flags) ||
+	     test_bit(DPC_HA_NEED_QUIESCENT, &ha->dpc_flags) ||
 	     test_bit(DPC_AEN, &ha->dpc_flags)) &&
+	     !test_bit(AF_DPC_SCHEDULED, &ha->flags) &&
 	     ha->dpc_thread) {
 		DEBUG2(printk("scsi%ld: %s: scheduling dpc routine"
 			      " - dpc flags = 0x%lx\n",
 			      ha->host_no, __func__, ha->dpc_flags));
-		queue_work(ha->dpc_thread, &ha->dpc_work);
+		qla4xxx_wake_dpc(ha);
 	}
 
 	/* Reschedule timer thread to call us back in one second */
@@ -713,16 +831,14 @@ static void qla4xxx_timer(struct scsi_qla_host *ha)
 static int qla4xxx_cmd_wait(struct scsi_qla_host *ha)
 {
 	uint32_t index = 0;
-	int stat = QLA_SUCCESS;
 	unsigned long flags;
 	struct scsi_cmnd *cmd;
-	int wait_cnt = WAIT_CMD_TOV;	/*
-					 * Initialized for 30 seconds as we
-					 * expect all commands to retuned
-					 * ASAP.
-					 */
+	unsigned long wtime = jiffies + (WAIT_CMD_TOV * HZ);
+
+	DEBUG2(ql4_printk(KERN_INFO, ha, "Wait up to %d seconds for cmds to "
+	    "complete\n", WAIT_CMD_TOV));
 
-	while (wait_cnt) {
+	while (!time_after_eq(jiffies, wtime)) {
 		spin_lock_irqsave(&ha->hardware_lock, flags);
 		/* Find a command that hasn't completed. */
 		for (index = 0; index < ha->host->can_queue; index++) {
@@ -733,31 +849,26 @@ static int qla4xxx_cmd_wait(struct scsi_qla_host *ha)
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 		/* If No Commands are pending, wait is complete */
-		if (index == ha->host->can_queue) {
-			break;
-		}
-
-		/* If we timed out on waiting for commands to come back
-		 * return ERROR.
-		 */
-		wait_cnt--;
-		if (wait_cnt == 0)
-			stat = QLA_ERROR;
-		else {
-			msleep(1000);
-		}
-	}			/* End of While (wait_cnt) */
+		if (index == ha->host->can_queue)
+			return QLA_SUCCESS;
 
-	return stat;
+		msleep(1000);
+	}
+	/* If we timed out on waiting for commands to come back
+	 * return ERROR. */
+	return QLA_ERROR;
 }
 
-void qla4xxx_hw_reset(struct scsi_qla_host *ha)
+int qla4xxx_hw_reset(struct scsi_qla_host *ha)
 {
 	uint32_t ctrl_status;
 	unsigned long flags = 0;
 
 	DEBUG2(printk(KERN_ERR "scsi%ld: %s\n", ha->host_no, __func__));
 
+	if (ql4xxx_lock_drvr_wait(ha) != QLA_SUCCESS)
+		return QLA_ERROR;
+
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
 	/*
@@ -773,6 +884,7 @@ void qla4xxx_hw_reset(struct scsi_qla_host *ha)
 	readl(&ha->reg->ctrl_status);
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	return QLA_SUCCESS;
 }
 
 /**
@@ -786,7 +898,8 @@ int qla4xxx_soft_reset(struct scsi_qla_host *ha)
 	int status = QLA_ERROR;
 	uint32_t ctrl_status;
 
-	qla4xxx_hw_reset(ha);
+	if (qla4xxx_hw_reset(ha) != QLA_SUCCESS)
+		return QLA_ERROR;
 
 	/* Wait until the Network Reset Intr bit is cleared */
 	max_wait_time = RESET_INTR_TOV;
@@ -871,7 +984,7 @@ int qla4xxx_soft_reset(struct scsi_qla_host *ha)
 }
 
 /**
- * qla4xxx_flush_active_srbs - returns all outstanding i/o requests to O.S.
+ * qla4xxx_abort_active_cmds - returns all outstanding i/o requests to O.S.
  * @ha: Pointer to host adapter structure.
  *
  * This routine is called just prior to a HARD RESET to return all
@@ -879,7 +992,7 @@ int qla4xxx_soft_reset(struct scsi_qla_host *ha)
  * Caller should make sure that the following locks are released
  * before this calling routine: Hardware lock, and io_request_lock.
  **/
-static void qla4xxx_flush_active_srbs(struct scsi_qla_host *ha)
+void qla4xxx_abort_active_cmds(struct scsi_qla_host *ha, int res)
 {
 	struct srb *srb;
 	int i;
@@ -889,13 +1002,26 @@ static void qla4xxx_flush_active_srbs(struct scsi_qla_host *ha)
 	for (i = 0; i < ha->host->can_queue; i++) {
 		srb = qla4xxx_del_from_active_array(ha, i);
 		if (srb != NULL) {
-			srb->cmd->result = DID_RESET << 16;
+			srb->cmd->result = res;
 			kref_put(&srb->srb_ref, qla4xxx_srb_compl);
 		}
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 
+void qla4xxx_dead_adapter_cleanup(struct scsi_qla_host *ha)
+{
+	clear_bit(AF_ONLINE, &ha->flags);
+
+	/* Disable the board */
+	ql4_printk(KERN_INFO, ha, "Disabling the board\n");
+	set_bit(AF_HBA_GOING_AWAY, &ha->flags);
+
+	qla4xxx_abort_active_cmds(ha, DID_NO_CONNECT << 16);
+	qla4xxx_mark_all_devices_missing(ha);
+	clear_bit(AF_INIT_DONE, &ha->flags);
+}
+
 /**
  * qla4xxx_recover_adapter - recovers adapter after a fatal error
  * @ha: Pointer to host adapter structure.
@@ -904,64 +1030,98 @@ static void qla4xxx_flush_active_srbs(struct scsi_qla_host *ha)
  * renew_ddb_list value can be 0=preserve ddb list, 1=destroy and rebuild
  * ddb list.
  **/
-static int qla4xxx_recover_adapter(struct scsi_qla_host *ha,
-				uint8_t renew_ddb_list)
+static int qla4xxx_recover_adapter(struct scsi_qla_host *ha)
 {
-	int status;
+	int status = QLA_ERROR;
+	uint8_t reset_chip = 0;
 
 	/* Stall incoming I/O until we are done */
+	scsi_block_requests(ha->host);
 	clear_bit(AF_ONLINE, &ha->flags);
 
-	DEBUG2(printk("scsi%ld: %s calling qla4xxx_cmd_wait\n", ha->host_no,
-		      __func__));
+	DEBUG2(dev_info(&ha->pdev->dev, "%s: adapter OFFLINE\n", __func__));
 
-	/* Wait for outstanding commands to complete.
-	 * Stalls the driver for max 30 secs
-	 */
-	status = qla4xxx_cmd_wait(ha);
+	set_bit(DPC_RESET_ACTIVE, &ha->dpc_flags);
 
-	qla4xxx_disable_intrs(ha);
+	if (test_bit(DPC_RESET_HA, &ha->dpc_flags))
+		reset_chip = 1;
 
-	/* Flush any pending ddb changed AENs */
-	qla4xxx_process_aen(ha, FLUSH_DDB_CHANGED_AENS);
+	/* For the DPC_RESET_HA_INTR case (ISP-4xxx specific)
+	 * do not reset adapter, jump to initialize_adapter */
+	if (test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags)) {
+		status = QLA_SUCCESS;
+		goto recover_ha_init_adapter;
+	}
 
-	qla4xxx_flush_active_srbs(ha);
+	/* For the ISP-82xx adapter, issue a stop_firmware if invoked
+	 * from eh_host_reset or ioctl module */
+	if (is_qla8022(ha) && !reset_chip &&
+	    test_bit(DPC_RESET_HA_FW_CONTEXT, &ha->dpc_flags)) {
+
+		DEBUG2(dev_info(&ha->pdev->dev,
+		    "scsi%ld: %s - Performing stop_firmware...\n",
+		    ha->host_no, __func__));
+		status = ha->isp_ops->reset_firmware(ha);
+		if (status == QLA_SUCCESS) {
+			(void) qla4xxx_cmd_wait(ha);
+			ha->isp_ops->disable_intrs(ha);
+			qla4xxx_process_aen(ha, FLUSH_DDB_CHANGED_AENS);
+			qla4xxx_abort_active_cmds(ha, DID_RESET << 16);
+		} else {
 
-	/* Reset the firmware.	If successful, function
-	 * returns with ISP interrupts enabled.
-	 */
-	DEBUG2(printk("scsi%ld: %s - Performing soft reset..\n",
-		      ha->host_no, __func__));
-	if (ql4xxx_lock_drvr_wait(ha) == QLA_SUCCESS)
-		status = qla4xxx_soft_reset(ha);
-	else
-		status = QLA_ERROR;
+			/* If the stop_firmware fails then
+			 * reset the entire chip */
+			reset_chip = 1;
+			clear_bit(DPC_RESET_HA_FW_CONTEXT, &ha->dpc_flags);
+			set_bit(DPC_RESET_HA, &ha->dpc_flags);
+		}
+	}
+
+	/* Issue full chip reset if recovering from a catastrophic error,
+	 * or if stop_firmware fails for ISP-82xx.
+	 * This is the default case for ISP-4xxx */
+	if (!is_qla8022(ha) || reset_chip) {
+		(void) qla4xxx_cmd_wait(ha);
+		qla4xxx_process_aen(ha, FLUSH_DDB_CHANGED_AENS);
+		qla4xxx_abort_active_cmds(ha, DID_RESET << 16);
+		DEBUG2(dev_info(&ha->pdev->dev,
+		    "scsi%ld: %s - Performing chip reset..\n",
+		    ha->host_no, __func__));
+		status = ha->isp_ops->reset_chip(ha);
+	}
 
 	/* Flush any pending ddb changed AENs */
 	qla4xxx_process_aen(ha, FLUSH_DDB_CHANGED_AENS);
 
-	/* Re-initialize firmware. If successful, function returns
-	 * with ISP interrupts enabled */
+recover_ha_init_adapter:
+	/* Upon successful firmware/chip reset, re-initialize the adapter */
 	if (status == QLA_SUCCESS) {
-		DEBUG2(printk("scsi%ld: %s - Initializing adapter..\n",
-			      ha->host_no, __func__));
-
-		/* If successful, AF_ONLINE flag set in
-		 * qla4xxx_initialize_adapter */
-		status = qla4xxx_initialize_adapter(ha, renew_ddb_list);
+		/* For ISP-4xxx, force function 1 to always initialize
+		 * before function 3 to prevent both funcions from
+		 * stepping on top of the other */
+		if (!is_qla8022(ha) && (ha->mac_index == 3))
+			ssleep(6);
+
+		/* NOTE: AF_ONLINE flag set upon successful completion of
+		 *       qla4xxx_initialize_adapter */
+		status = qla4xxx_initialize_adapter(ha, PRESERVE_DDB_LIST);
 	}
 
-	/* Failed adapter initialization?
-	 * Retry reset_ha only if invoked via DPC (DPC_RESET_HA) */
-	if ((test_bit(AF_ONLINE, &ha->flags) == 0) &&
-	    (test_bit(DPC_RESET_HA, &ha->dpc_flags))) {
+	/* Retry failed adapter initialization, if necessary
+	 * Do not retry initialize_adapter for RESET_HA_INTR (ISP-4xxx specific)
+	 * case to prevent ping-pong resets between functions */
+	if (!test_bit(AF_ONLINE, &ha->flags) &&
+	    !test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags)) {
 		/* Adapter initialization failed, see if we can retry
-		 * resetting the ha */
+		 * resetting the ha.
+		 * Since we don't want to block the DPC for too long
+		 * with multiple resets in the same thread,
+		 * utilize DPC to retry */
 		if (!test_bit(DPC_RETRY_RESET_HA, &ha->dpc_flags)) {
 			ha->retry_reset_ha_cnt = MAX_RESET_HA_RETRIES;
 			DEBUG2(printk("scsi%ld: recover adapter - retrying "
-				      "(%d) more times\n", ha->host_no,
-				      ha->retry_reset_ha_cnt));
+			    "(%d) more times\n", ha->host_no,
+			    ha->retry_reset_ha_cnt));
 			set_bit(DPC_RETRY_RESET_HA, &ha->dpc_flags);
 			status = QLA_ERROR;
 		} else {
@@ -969,9 +1129,9 @@ static int qla4xxx_recover_adapter(struct scsi_qla_host *ha,
 				/* Schedule another Reset HA--DPC will retry */
 				ha->retry_reset_ha_cnt--;
 				DEBUG2(printk("scsi%ld: recover adapter - "
-					      "retry remaining %d\n",
-					      ha->host_no,
-					      ha->retry_reset_ha_cnt));
+				    "retry remaining %d\n",
+				    ha->host_no,
+				    ha->retry_reset_ha_cnt));
 				status = QLA_ERROR;
 			}
 
@@ -979,31 +1139,45 @@ static int qla4xxx_recover_adapter(struct scsi_qla_host *ha,
 				/* Recover adapter retries have been exhausted.
 				 * Adapter DEAD */
 				DEBUG2(printk("scsi%ld: recover adapter "
-					      "failed - board disabled\n",
-					      ha->host_no));
-				qla4xxx_flush_active_srbs(ha);
+				    "failed - board disabled\n",
+				    ha->host_no));
+				qla4xxx_dead_adapter_cleanup(ha);
 				clear_bit(DPC_RETRY_RESET_HA, &ha->dpc_flags);
 				clear_bit(DPC_RESET_HA, &ha->dpc_flags);
-				clear_bit(DPC_RESET_HA_DESTROY_DDB_LIST,
-					  &ha->dpc_flags);
+				clear_bit(DPC_RESET_HA_FW_CONTEXT,
+				    &ha->dpc_flags);
 				status = QLA_ERROR;
 			}
 		}
 	} else {
 		clear_bit(DPC_RESET_HA, &ha->dpc_flags);
-		clear_bit(DPC_RESET_HA_DESTROY_DDB_LIST, &ha->dpc_flags);
+		clear_bit(DPC_RESET_HA_FW_CONTEXT, &ha->dpc_flags);
 		clear_bit(DPC_RETRY_RESET_HA, &ha->dpc_flags);
 	}
 
 	ha->adapter_error_count++;
 
-	if (status == QLA_SUCCESS)
-		qla4xxx_enable_intrs(ha);
+	if (test_bit(AF_ONLINE, &ha->flags)) {
+		ha->isp_ops->enable_intrs(ha);
+		scsi_unblock_requests(ha->host);
+	}
+
+	clear_bit(DPC_RESET_ACTIVE, &ha->dpc_flags);
+	DEBUG2(printk("scsi%ld: recover adapter: %s\n", ha->host_no,
+	    status == QLA_ERROR ? "FAILED" : "SUCCEDED"));
 
-	DEBUG2(printk("scsi%ld: recover adapter .. DONE\n", ha->host_no));
 	return status;
 }
 
+void qla4xxx_wake_dpc(struct scsi_qla_host *ha)
+{
+	if (ha->dpc_thread &&
+	    !test_bit(AF_DPC_SCHEDULED, &ha->flags)) {
+		set_bit(AF_DPC_SCHEDULED, &ha->flags);
+		queue_work(ha->dpc_thread, &ha->dpc_work);
+	}
+}
+
 /**
  * qla4xxx_do_dpc - dpc routine
  * @data: in our case pointer to adapter structure
@@ -1023,21 +1197,46 @@ static void qla4xxx_do_dpc(struct work_struct *work)
 	int status = QLA_ERROR;
 
 	DEBUG2(printk("scsi%ld: %s: DPC handler waking up."
-		"flags = 0x%08lx, dpc_flags = 0x%08lx ctrl_stat = 0x%08x\n",
-		ha->host_no, __func__, ha->flags, ha->dpc_flags,
-		readw(&ha->reg->ctrl_status)));
+	    "flags = 0x%08lx, dpc_flags = 0x%08lx\n",
+	    ha->host_no, __func__, ha->flags, ha->dpc_flags))
 
 	/* Initialization not yet finished. Don't do anything yet. */
 	if (!test_bit(AF_INIT_DONE, &ha->flags))
 		return;
 
-	if (adapter_up(ha) ||
-	    test_bit(DPC_RESET_HA, &ha->dpc_flags) ||
+	/* HBA is in the process of being permanently disabled.
+	 * Don't process anything */
+	if (test_bit(AF_HBA_GOING_AWAY, &ha->flags))
+		return;
+
+	if (is_qla8022(ha)) {
+		if (test_bit(DPC_HA_UNRECOVERABLE, &ha->dpc_flags)) {
+			qla82xx_idc_lock(ha);
+			qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE, QLA82XX_DEV_FAILED);
+			qla82xx_idc_unlock(ha);
+			ql4_printk(KERN_INFO, ha, "HW State: FAILED\n");
+			qla82xx_device_state_handler(ha);
+		}
+		if (test_and_clear_bit(DPC_HA_NEED_QUIESCENT, &ha->dpc_flags)) {
+			qla82xx_need_qsnt_handler(ha);
+		}
+	}
+
+	if (!test_bit(DPC_RESET_ACTIVE, &ha->dpc_flags) &&
+	    (test_bit(DPC_RESET_HA, &ha->dpc_flags) ||
 	    test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags) ||
-	    test_bit(DPC_RESET_HA_DESTROY_DDB_LIST, &ha->dpc_flags)) {
-		if (test_bit(DPC_RESET_HA_DESTROY_DDB_LIST, &ha->dpc_flags) ||
-			test_bit(DPC_RESET_HA, &ha->dpc_flags))
-			qla4xxx_recover_adapter(ha, PRESERVE_DDB_LIST);
+	    test_bit(DPC_RESET_HA_FW_CONTEXT, &ha->dpc_flags))) {
+		if (ql4xdontresethba) {
+			DEBUG2(printk("scsi%ld: %s: Don't Reset HBA\n",
+			    ha->host_no, __func__));
+			clear_bit(DPC_RESET_HA, &ha->dpc_flags);
+			clear_bit(DPC_RESET_HA_INTR, &ha->dpc_flags);
+			clear_bit(DPC_RESET_HA_FW_CONTEXT, &ha->dpc_flags);
+			goto dpc_post_reset_ha;
+		}
+		if (test_bit(DPC_RESET_HA_FW_CONTEXT, &ha->dpc_flags) ||
+		    test_bit(DPC_RESET_HA, &ha->dpc_flags))
+			qla4xxx_recover_adapter(ha);
 
 		if (test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags)) {
 			uint8_t wait_time = RESET_INTR_TOV;
@@ -1052,18 +1251,18 @@ static void qla4xxx_do_dpc(struct work_struct *work)
 				DEBUG2(printk("scsi%ld: %s: SR|FSR "
 					      "bit not cleared-- resetting\n",
 					      ha->host_no, __func__));
-			qla4xxx_flush_active_srbs(ha);
+			qla4xxx_abort_active_cmds(ha, DID_RESET << 16);
 			if (ql4xxx_lock_drvr_wait(ha) == QLA_SUCCESS) {
 				qla4xxx_process_aen(ha, FLUSH_DDB_CHANGED_AENS);
-				status = qla4xxx_initialize_adapter(ha,
-						PRESERVE_DDB_LIST);
+				status = qla4xxx_recover_adapter(ha);
 			}
 			clear_bit(DPC_RESET_HA_INTR, &ha->dpc_flags);
 			if (status == QLA_SUCCESS)
-				qla4xxx_enable_intrs(ha);
+				ha->isp_ops->enable_intrs(ha);
 		}
 	}
 
+dpc_post_reset_ha:
 	/* ---- process AEN? --- */
 	if (test_and_clear_bit(DPC_AEN, &ha->dpc_flags))
 		qla4xxx_process_aen(ha, PROCESS_ALL_AENS);
@@ -1103,11 +1302,9 @@ static void qla4xxx_do_dpc(struct work_struct *work)
 							   DDB_STATE_ONLINE);
 						dev_info(&ha->pdev->dev,
 						    "scsi%ld: %s: ddb[%d]"
-						    " os[%d] marked"
-						    " ONLINE\n",
+						    " marked ONLINE\n",
 						    ha->host_no, __func__,
-						    ddb_entry->fw_ddb_index,
-						    ddb_entry->os_target_id);
+						    ddb_entry->fw_ddb_index);
 
 						iscsi_unblock_session(
 						    ddb_entry->sess);
@@ -1143,6 +1340,8 @@ static void qla4xxx_do_dpc(struct work_struct *work)
 			}
 		}
 	}
+
+	clear_bit(AF_DPC_SCHEDULED, &ha->flags);
 }
 
 /**
@@ -1154,30 +1353,100 @@ static void qla4xxx_free_adapter(struct scsi_qla_host *ha)
 
 	if (test_bit(AF_INTERRUPTS_ON, &ha->flags)) {
 		/* Turn-off interrupts on the card. */
-		qla4xxx_disable_intrs(ha);
+		ha->isp_ops->disable_intrs(ha);
 	}
 
+	/* Remove timer thread, if present */
+	if (ha->timer_active)
+		qla4xxx_stop_timer(ha);
+
 	/* Kill the kernel thread for this host */
 	if (ha->dpc_thread)
 		destroy_workqueue(ha->dpc_thread);
 
-	/* Issue Soft Reset to put firmware in unknown state */
-	if (ql4xxx_lock_drvr_wait(ha) == QLA_SUCCESS)
-		qla4xxx_hw_reset(ha);
+	/* Put firmware in known state */
+	ha->isp_ops->reset_firmware(ha);
 
-	/* Remove timer thread, if present */
-	if (ha->timer_active)
-		qla4xxx_stop_timer(ha);
+	if (is_qla8022(ha)) {
+		qla82xx_idc_lock(ha);
+		qla82xx_clear_drv_active(ha);
+		qla82xx_idc_unlock(ha);
+	}
 
 	/* Detach interrupts */
 	if (test_and_clear_bit(AF_IRQ_ATTACHED, &ha->flags))
-		free_irq(ha->pdev->irq, ha);
+		qla4xxx_free_irqs(ha);
 
 	/* free extra memory */
 	qla4xxx_mem_free(ha);
+}
+
+int qla82xx_iospace_config(struct scsi_qla_host *ha)
+{
+	int status = 0;
+	uint8_t revision_id;
+	unsigned long mem_base, mem_len, db_base, db_len;
+	struct pci_dev *pdev = ha->pdev;
+
+	status = pci_request_regions(pdev, DRIVER_NAME);
+	if (status) {
+		printk(KERN_WARNING
+		    "scsi(%ld) Failed to reserve PIO regions (%s) "
+		    "status=%d\n", ha->host_no, pci_name(pdev), status);
+		goto iospace_error_exit;
+	}
+
+	pci_read_config_byte(pdev, PCI_REVISION_ID, &revision_id);
+	DEBUG2(printk(KERN_INFO "%s: revision-id=%d\n",
+	    __func__, revision_id));
+	ha->revision_id = revision_id;
+
+	/* remap phys address */
+	mem_base = pci_resource_start(pdev, 0); /* 0 is for BAR 0 */
+	mem_len = pci_resource_len(pdev, 0);
+	DEBUG2(printk(KERN_INFO "%s: ioremap from %lx a size of %lx\n",
+	    __func__, mem_base, mem_len));
+
+	/* mapping of pcibase pointer */
+	ha->nx_pcibase = (unsigned long)ioremap(mem_base, mem_len);
+	if (!ha->nx_pcibase) {
+		printk(KERN_ERR
+		    "cannot remap MMIO (%s), aborting\n", pci_name(pdev));
+		pci_release_regions(ha->pdev);
+		goto iospace_error_exit;
+	}
+
+	/* Mapping of IO base pointer, door bell read and write pointer */
+
+	/* mapping of IO base pointer */
+	ha->qla82xx_reg =
+	    (struct device_reg_82xx  __iomem *)((uint8_t *)ha->nx_pcibase +
+	    0xbc000 + (ha->pdev->devfn << 11));
+
+	db_base = pci_resource_start(pdev, 4);  /* doorbell is on bar 4 */
+	db_len = pci_resource_len(pdev, 4);
+
+	/* mapping of doorbell write pointer */
+	ha->nx_db_wr_ptr = (unsigned long)ioremap(db_base +
+	    (ha->pdev->devfn << 12), 4);
+	if (!ha->nx_db_wr_ptr) {
+		printk(KERN_ERR
+		    "cannot remap MMIO doorbell-write (%s), aborting\n",
+		    pci_name(pdev));
+		goto iospace_error_exit;
+	}
+	/* mapping of doorbell read pointer */
+	ha->nx_db_rd_ptr = (uint8_t *) ha->nx_pcibase + (512 * 1024) +
+	    (ha->pdev->devfn * 8);
+	if (!ha->nx_db_rd_ptr)
+		printk(KERN_ERR
+		    "cannot remap MMIO doorbell-read (%s), aborting\n",
+		    pci_name(pdev));
 
-	pci_disable_device(ha->pdev);
+	return 0;
 
+iospace_error_exit:
+	return -ENOMEM;
 }
 
 /***
@@ -1187,7 +1456,7 @@ static void qla4xxx_free_adapter(struct scsi_qla_host *ha)
  * This routines maps HBA's registers from the pci address space
  * into the kernel virtual address space for memory mapped i/o.
  **/
-static int qla4xxx_iospace_config(struct scsi_qla_host *ha)
+int qla4xxx_iospace_config(struct scsi_qla_host *ha)
 {
 	unsigned long pio, pio_len, pio_flags;
 	unsigned long mmio, mmio_len, mmio_flags;
@@ -1246,6 +1515,60 @@ iospace_error_exit:
 	return -ENOMEM;
 }
 
+struct isp_operations qla4xxx_isp_ops = {
+	.iospace_config         = qla4xxx_iospace_config,
+	.pci_config             = qla4xxx_pci_config,
+	.disable_intrs          = qla4xxx_disable_intrs,
+	.enable_intrs           = qla4xxx_enable_intrs,
+	.start_firmware         = qla4xxx_start_firmware,
+	.intr_handler           = qla4xxx_intr_handler,
+	.interrupt_service_routine = qla4xxx_interrupt_service_routine,
+	.reset_chip             = qla4xxx_soft_reset,
+	.reset_firmware         = qla4xxx_hw_reset,
+	.queue_iocb             = qla4xxx_queue_iocb,
+	.complete_iocb          = qla4xxx_complete_iocb,
+	.rd_shdw_req_q_out      = qla4xxx_rd_shdw_req_q_out,
+	.rd_shdw_rsp_q_in       = qla4xxx_rd_shdw_rsp_q_in,
+	.get_sys_info           = qla4xxx_get_sys_info,
+};
+
+struct isp_operations qla82xx_isp_ops = {
+	.iospace_config         = qla82xx_iospace_config,
+	.pci_config             = qla82xx_pci_config,
+	.disable_intrs          = qla82xx_disable_intrs,
+	.enable_intrs           = qla82xx_enable_intrs,
+	.start_firmware         = qla82xx_load_risc,
+	.intr_handler           = qla82xx_intr_handler,
+	.interrupt_service_routine = qla82xx_interrupt_service_routine,
+	.reset_chip             = qla82xx_isp_reset,
+	.reset_firmware         = qla82xx_stop_firmware,
+	.queue_iocb             = qla82xx_queue_iocb,
+	.complete_iocb          = qla82xx_complete_iocb,
+	.rd_shdw_req_q_out      = qla82xx_rd_shdw_req_q_out,
+	.rd_shdw_rsp_q_in       = qla82xx_rd_shdw_rsp_q_in,
+	.get_sys_info           = qla82xx_get_sys_info,
+};
+
+uint16_t qla4xxx_rd_shdw_req_q_out(struct scsi_qla_host *ha)
+{
+	return (uint16_t) le32_to_cpu(ha->shadow_regs->req_q_out);
+}
+
+uint16_t qla82xx_rd_shdw_req_q_out(struct scsi_qla_host *ha)
+{
+	return (uint16_t) le32_to_cpu(readl(&ha->qla82xx_reg->req_q_out));
+}
+
+uint16_t qla4xxx_rd_shdw_rsp_q_in(struct scsi_qla_host *ha)
+{
+	return (uint16_t) le32_to_cpu(ha->shadow_regs->rsp_q_in);
+}
+
+uint16_t qla82xx_rd_shdw_rsp_q_in(struct scsi_qla_host *ha)
+{
+	return (uint16_t) le32_to_cpu(readl(&ha->qla82xx_reg->rsp_q_in));
+}
+
 /**
  * qla4xxx_probe_adapter - callback function to probe HBA
  * @pdev: pointer to pci_dev structure
@@ -1263,6 +1586,7 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 	struct scsi_qla_host *ha;
 	uint8_t init_retry_count = 0;
 	char buf[34];
+	struct qla82xx_legacy_intr_set *nx_legacy_intr;
 
 	if (pci_enable_device(pdev))
 		return -1;
@@ -1283,10 +1607,28 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 	ha->host = host;
 	ha->host_no = host->host_no;
 
+	/* Setup Runtime configurable options */
+	if (is_qla8022(ha)) {
+		ha->isp_ops = &qla82xx_isp_ops;
+		rwlock_init(&ha->hw_lock);
+		ha->qdr_sn_window = -1;
+		ha->ddr_mn_window = -1;
+		ha->curr_window = 255;
+		ha->func_num = PCI_FUNC(ha->pdev->devfn);
+		nx_legacy_intr = &legacy_intr[ha->func_num];
+		ha->nx_legacy_intr.int_vec_bit = nx_legacy_intr->int_vec_bit;
+		ha->nx_legacy_intr.tgt_status_reg =
+			nx_legacy_intr->tgt_status_reg;
+		ha->nx_legacy_intr.tgt_mask_reg = nx_legacy_intr->tgt_mask_reg;
+		ha->nx_legacy_intr.pci_int_reg = nx_legacy_intr->pci_int_reg;
+	} else {
+		ha->isp_ops = &qla4xxx_isp_ops;
+	}
+
 	/* Configure PCI I/O space. */
-	ret = qla4xxx_iospace_config(ha);
+	ret = ha->isp_ops->iospace_config(ha);
 	if (ret)
-		goto probe_failed;
+		goto probe_failed_ioconfig;
 
 	dev_info(&ha->pdev->dev, "Found an ISP%04x, irq %d, iobase 0x%p\n",
 		   pdev->device, pdev->irq, ha->reg);
@@ -1298,6 +1640,7 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 	INIT_LIST_HEAD(&ha->free_srb_q);
 
 	mutex_init(&ha->mbox_sem);
+	init_completion(&ha->mbx_intr_comp);
 
 	spin_lock_init(&ha->hardware_lock);
 
@@ -1310,19 +1653,25 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 		goto probe_failed;
 	}
 
+	if (is_qla8022(ha))
+		(void) qla82xx_get_flash_info(ha);
+
 	/*
 	 * Initialize the Host adapter request/response queues and
 	 * firmware
 	 * NOTE: interrupts enabled upon successful completion
 	 */
 	status = qla4xxx_initialize_adapter(ha, REBUILD_DDB_LIST);
-	while (status == QLA_ERROR && init_retry_count++ < MAX_INIT_RETRIES) {
+	while ((!test_bit(AF_ONLINE, &ha->flags)) &&
+	    init_retry_count++ < MAX_INIT_RETRIES) {
 		DEBUG2(printk("scsi: %s: retrying adapter initialization "
-			      "(%d)\n", __func__, init_retry_count));
-		qla4xxx_soft_reset(ha);
+		    "(%d)\n", __func__, init_retry_count));
+		if (ha->isp_ops->reset_chip(ha) == QLA_ERROR)
+			continue;
+
 		status = qla4xxx_initialize_adapter(ha, REBUILD_DDB_LIST);
 	}
-	if (status == QLA_ERROR) {
+	if (!test_bit(AF_ONLINE, &ha->flags)) {
 		dev_warn(&ha->pdev->dev, "Failed to initialize adapter\n");
 
 		ret = -ENODEV;
@@ -1355,18 +1704,20 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 	}
 	INIT_WORK(&ha->dpc_work, qla4xxx_do_dpc);
 
-	ret = request_irq(pdev->irq, qla4xxx_intr_handler,
-			  IRQF_DISABLED | IRQF_SHARED, "qla4xxx", ha);
-	if (ret) {
-		dev_warn(&ha->pdev->dev, "Failed to reserve interrupt %d"
-			" already in use.\n", pdev->irq);
-		goto probe_failed;
+	/* For ISP-82XX, request_irqs is called in qla82xx_load_risc
+	 * (which is called indirectly by qla4xxx_initialize_adapter),
+	 * so that irqs will be registered after crbinit but before
+	 * mbx_intr_enable.
+	 */
+	if (!is_qla8022(ha)) {
+		ret = qla4xxx_request_irqs(ha);
+		if (ret) {
+			dev_warn(&ha->pdev->dev, "Failed to reserve interrupt"
+			    " %d already in use.\n", pdev->irq);
+			goto probe_failed;
+		}
 	}
-	set_bit(AF_IRQ_ATTACHED, &ha->flags);
-	host->irq = pdev->irq;
-	DEBUG(printk("scsi%d: irq %d attached\n", ha->host_no, ha->pdev->irq));
-
-	qla4xxx_enable_intrs(ha);
+	ha->isp_ops->enable_intrs(ha);
 
 	/* Start timer thread. */
 	qla4xxx_start_timer(ha, qla4xxx_timer, 1);
@@ -1390,6 +1741,8 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 
 probe_failed:
 	qla4xxx_free_adapter(ha);
+
+probe_failed_ioconfig:
 	scsi_host_put(ha->host);
 
 probe_disable_device:
@@ -1408,10 +1761,9 @@ static void __devexit qla4xxx_remove_adapter(struct pci_dev *pdev)
 
 	ha = pci_get_drvdata(pdev);
 
-	qla4xxx_disable_intrs(ha);
+	set_bit(AF_HBA_GOING_AWAY, &ha->flags);
 
-	while (test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags))
-		ssleep(1);
+	ha->isp_ops->disable_intrs(ha);
 
 	/* remove devs from iscsi_sessions to scsi_devices */
 	qla4xxx_free_ddb_list(ha);
@@ -1422,6 +1774,7 @@ static void __devexit qla4xxx_remove_adapter(struct pci_dev *pdev)
 
 	scsi_host_put(ha->host);
 
+	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
 }
 
@@ -1768,6 +2121,11 @@ static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd)
 
 	ha = (struct scsi_qla_host *) cmd->device->host->hostdata;
 
+	if (ql4xdontresethba) {
+		DEBUG2(printk("scsi%ld: %s: Don't Reset HBA\n", ha->host_no, __func__));
+		return FAILED;
+	}
+
 	dev_info(&ha->pdev->dev,
 		   "scsi(%ld:%d:%d:%d): HOST RESET ISSUED.\n", ha->host_no,
 		   cmd->device->channel, cmd->device->id, cmd->device->lun);
@@ -1780,11 +2138,14 @@ static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd)
 		return FAILED;
 	}
 
-	/* make sure the dpc thread is stopped while we reset the hba */
-	clear_bit(AF_ONLINE, &ha->flags);
-	flush_workqueue(ha->dpc_thread);
+	if (!test_bit(DPC_RESET_HA, &ha->dpc_flags)) {
+		if (is_qla8022(ha))
+			set_bit(DPC_RESET_HA_FW_CONTEXT, &ha->dpc_flags);
+		else
+			set_bit(DPC_RESET_HA, &ha->dpc_flags);
+	}
 
-	if (qla4xxx_recover_adapter(ha, PRESERVE_DDB_LIST) == QLA_SUCCESS)
+	if (qla4xxx_recover_adapter(ha) == QLA_SUCCESS)
 		return_status = SUCCESS;
 
 	dev_info(&ha->pdev->dev, "HOST RESET %s.\n",
@@ -1793,7 +2154,6 @@ static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd)
 	return return_status;
 }
 
-
 static struct pci_device_id qla4xxx_pci_tbl[] = {
 	{
 		.vendor		= PCI_VENDOR_ID_QLOGIC,
@@ -1813,6 +2173,12 @@ static struct pci_device_id qla4xxx_pci_tbl[] = {
 		.subvendor	= PCI_ANY_ID,
 		.subdevice	= PCI_ANY_ID,
 	},
+	{
+		.vendor         = PCI_VENDOR_ID_QLOGIC,
+		.device         = PCI_DEVICE_ID_QLOGIC_ISP8022,
+		.subvendor      = PCI_ANY_ID,
+		.subdevice      = PCI_ANY_ID,
+	},
 	{0, 0},
 };
 MODULE_DEVICE_TABLE(pci, qla4xxx_pci_tbl);
@@ -1868,7 +2234,6 @@ no_srp_cache:
 
 static void __exit qla4xxx_module_exit(void)
 {
-	ql4_mod_unload = 1;
 	pci_unregister_driver(&qla4xxx_pci_driver);
 	iscsi_unregister_transport(&qla4xxx_iscsi_transport);
 	kmem_cache_destroy(srb_cachep);
-- 
1.7.0.5

