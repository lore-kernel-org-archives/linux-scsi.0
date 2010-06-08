From: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Subject: [PATCH 1/1] pmcraid: MSI-X support and other changes
Date: Tue, 8 Jun 2010 10:56:34 -0700 (PDT)
Message-ID: <alpine.LNX.1.10.1006081030230.16340@rslab235.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:45363 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755243Ab0FHTbf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2010 15:31:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com
Cc: anil_ravindranath@pmc-sierra.com


pmcraid driver changes:

1. MSI-X interrupt support
2. Driver changes to support new maxRAID controller FW version. The 
changes are mainly done to handle async notification changes done in 
newer controller FW version. 
3. Added state change notifications to notify applications of controller 
states.

pmcraid.c |  886 
++++++++++++++++++++++++++++++++++++++++++++++----------------
pmcraid.h |  305 ++++++++++++---------
 2 files changed, 843 insertions(+), 348 deletions(-)

--- scsi-misc-2.6.orig/drivers/scsi/pmcraid.h	2010-06-04 09:39:37.000000000 -0700
+++ scsi-misc-2.6/drivers/scsi/pmcraid.h	2010-06-04 09:40:50.000000000 -0700
@@ -40,10 +40,12 @@
  * Driver version: version string in major_version.minor_version.patch format
  * Driver date   : date information in "Mon dd yyyy" format
  */
-#define PMCRAID_DRIVER_NAME       	"PMC MaxRAID"
+#define PMCRAID_DRIVER_NAME		"PMC MaxRAID"
 #define PMCRAID_DEVFILE			"pmcsas"
-#define PMCRAID_DRIVER_VERSION    	"1.0.2"
-#define PMCRAID_DRIVER_DATE       	__DATE__
+#define PMCRAID_DRIVER_VERSION		"2.0.2"
+#define PMCRAID_DRIVER_DATE		__DATE__
+
+#define PMCRAID_FW_VERSION_1		0x002
 
 /* Maximum number of adapters supported by current version of the driver */
 #define PMCRAID_MAX_ADAPTERS		1024
@@ -85,17 +87,17 @@
 #define PMCRAID_IOARCB_ALIGNMENT                 32
 #define PMCRAID_IOADL_ALIGNMENT                  16
 #define PMCRAID_IOASA_ALIGNMENT                  4
-#define PMCRAID_NUM_MSIX_VECTORS                 1
+#define PMCRAID_NUM_MSIX_VECTORS                 16
 
 /* various other limits */
-#define PMCRAID_VENDOR_ID_LEN           	 8
-#define PMCRAID_PRODUCT_ID_LEN            	 16
-#define PMCRAID_SERIAL_NUM_LEN          	 8
-#define PMCRAID_LUN_LEN			         8
-#define PMCRAID_MAX_CDB_LEN                      16
-#define PMCRAID_DEVICE_ID_LEN			 8
-#define PMCRAID_SENSE_DATA_LEN			 256
-#define PMCRAID_ADD_CMD_PARAM_LEN		 48
+#define PMCRAID_VENDOR_ID_LEN			8
+#define PMCRAID_PRODUCT_ID_LEN			16
+#define PMCRAID_SERIAL_NUM_LEN			8
+#define PMCRAID_LUN_LEN				8
+#define PMCRAID_MAX_CDB_LEN			16
+#define PMCRAID_DEVICE_ID_LEN			8
+#define PMCRAID_SENSE_DATA_LEN			256
+#define PMCRAID_ADD_CMD_PARAM_LEN		48
 
 #define PMCRAID_MAX_BUS_TO_SCAN                  1
 #define PMCRAID_MAX_NUM_TARGETS_PER_BUS          256
@@ -116,17 +118,10 @@
 #define PMCRAID_VSET_MAX_SECTORS                 512
 #define PMCRAID_MAX_CMD_PER_LUN                  254
 
-/* Number of configuration table entries (resources) */
-#define PMCRAID_MAX_NUM_OF_VSETS                 240
-
-/* Todo : Check max limit for Phase 1 */
-#define PMCRAID_MAX_NUM_OF_PHY_DEVS              256
-
-/* MAX_NUM_OF_DEVS includes 1 FP, 1 Dummy Enclosure device */
-#define PMCRAID_MAX_NUM_OF_DEVS                        \
-    (PMCRAID_MAX_NUM_OF_VSETS + PMCRAID_MAX_NUM_OF_PHY_DEVS + 2)
-
-#define PMCRAID_MAX_RESOURCES                    PMCRAID_MAX_NUM_OF_DEVS
+/* Number of configuration table entries (resources), includes 1 FP,
+ * 1 Enclosure device
+ */
+#define PMCRAID_MAX_RESOURCES                    256
 
 /* Adapter Commands used by driver */
 #define PMCRAID_QUERY_RESOURCE_STATE             0xC2
@@ -177,6 +172,7 @@
 #define PMCRAID_IOASC_SENSE_STATUS(ioasc)        ((ioasc) & 0x000000ff)
 
 #define PMCRAID_IOASC_GOOD_COMPLETION			0x00000000
+#define PMCRAID_IOASC_GC_IOARCB_NOTFOUND		0x005A0000
 #define PMCRAID_IOASC_NR_INIT_CMD_REQUIRED		0x02040200
 #define PMCRAID_IOASC_NR_IOA_RESET_REQUIRED		0x02048000
 #define PMCRAID_IOASC_NR_SYNC_REQUIRED			0x023F0000
@@ -187,12 +183,12 @@
 #define PMCRAID_IOASC_HW_IOA_RESET_REQUIRED		0x04448600
 #define PMCRAID_IOASC_IR_INVALID_RESOURCE_HANDLE        0x05250000
 #define PMCRAID_IOASC_AC_TERMINATED_BY_HOST		0x0B5A0000
-#define PMCRAID_IOASC_UA_BUS_WAS_RESET           	0x06290000
-#define PMCRAID_IOASC_UA_BUS_WAS_RESET_BY_OTHER  	0x06298000
+#define PMCRAID_IOASC_UA_BUS_WAS_RESET			0x06290000
+#define PMCRAID_IOASC_UA_BUS_WAS_RESET_BY_OTHER		0x06298000
 
 /* Driver defined IOASCs */
-#define PMCRAID_IOASC_IOA_WAS_RESET              	0x10000001
-#define PMCRAID_IOASC_PCI_ACCESS_ERROR           	0x10000002
+#define PMCRAID_IOASC_IOA_WAS_RESET			0x10000001
+#define PMCRAID_IOASC_PCI_ACCESS_ERROR			0x10000002
 
 /* Various timeout values (in milliseconds) used. If any of these are chip
  * specific, move them to pmcraid_chip_details structure.
@@ -336,6 +332,13 @@
 	__u8  lun[PMCRAID_LUN_LEN];
 } __attribute__((packed, aligned(4)));
 
+/* extended configuration table sizes are of 64 bytes in size */
+#define PMCRAID_CFGTE_EXT_SIZE	32
+struct pmcraid_config_table_entry_ext {
+	struct pmcraid_config_table_entry cfgte;
+	__u8  cfgte_ext[PMCRAID_CFGTE_EXT_SIZE];
+};
+
 /* resource types (config_table_entry.resource_type values) */
 #define RES_TYPE_AF_DASD     0x00
 #define RES_TYPE_GSCSI       0x01
@@ -376,7 +379,12 @@
 	__u8  reserved1;
 	__u8  flags;
 	__u8  reserved2[11];
-	struct pmcraid_config_table_entry entries[PMCRAID_MAX_RESOURCES];
+	union {
+		struct pmcraid_config_table_entry
+				entries[PMCRAID_MAX_RESOURCES];
+		struct pmcraid_config_table_entry_ext
+				entries_ext[PMCRAID_MAX_RESOURCES];
+	};
 } __attribute__((packed, aligned(4)));
 
 /* config_table.flags value */
@@ -385,7 +393,7 @@
 /*
  * HCAM format
  */
-#define PMCRAID_HOSTRCB_LDNSIZE 		4056
+#define PMCRAID_HOSTRCB_LDNSIZE			4056
 
 /* Error log notification format */
 struct pmcraid_hostrcb_error {
@@ -416,6 +424,15 @@
 struct pmcraid_hcam_ccn {
 	struct pmcraid_hcam_hdr header;
 	struct pmcraid_config_table_entry cfg_entry;
+	struct pmcraid_config_table_entry cfg_entry_old;
+} __attribute__((packed, aligned(4)));
+
+#define PMCRAID_CCN_EXT_SIZE	3944
+struct pmcraid_hcam_ccn_ext {
+	struct pmcraid_hcam_hdr header;
+	struct pmcraid_config_table_entry_ext cfg_entry;
+	struct pmcraid_config_table_entry_ext cfg_entry_old;
+	__u8   reserved[PMCRAID_CCN_EXT_SIZE];
 } __attribute__((packed, aligned(4)));
 
 struct pmcraid_hcam_ldn {
@@ -431,6 +448,8 @@
 #define NOTIFICATION_TYPE_ENTRY_CHANGED		0x0
 #define NOTIFICATION_TYPE_ENTRY_NEW		0x1
 #define NOTIFICATION_TYPE_ENTRY_DELETED		0x2
+#define NOTIFICATION_TYPE_STATE_CHANGE		0x3
+#define NOTIFICATION_TYPE_ENTRY_STATECHANGED	0x4
 #define NOTIFICATION_TYPE_ERROR_LOG		0x10
 #define NOTIFICATION_TYPE_INFORMATION_LOG	0x11
 
@@ -460,6 +479,7 @@
 	unsigned long  mailbox;
 	unsigned long  global_intr_mask;
 	unsigned long  ioa_host_intr;
+	unsigned long  ioa_host_msix_intr;
 	unsigned long  ioa_host_intr_clr;
 	unsigned long  ioa_host_mask;
 	unsigned long  ioa_host_mask_clr;
@@ -482,6 +502,7 @@
 #define INTRS_IOA_PROCESSOR_ERROR		PMC_BIT32(29)
 #define INTRS_HRRQ_VALID			PMC_BIT32(30)
 #define INTRS_OPERATIONAL_STATUS		PMC_BIT32(0)
+#define INTRS_ALLOW_MSIX_VECTOR0		PMC_BIT32(31)
 
 /* Host to IOA Doorbells */
 #define DOORBELL_RUNTIME_RESET			PMC_BIT32(1)
@@ -489,10 +510,12 @@
 #define DOORBELL_IOA_DEBUG_ALERT		PMC_BIT32(9)
 #define DOORBELL_ENABLE_DESTRUCTIVE_DIAGS	PMC_BIT32(8)
 #define DOORBELL_IOA_START_BIST			PMC_BIT32(23)
+#define DOORBELL_INTR_MODE_MSIX			PMC_BIT32(25)
+#define DOORBELL_INTR_MSIX_CLR			PMC_BIT32(26)
 #define DOORBELL_RESET_IOA			PMC_BIT32(31)
 
 /* Global interrupt mask register value */
-#define GLOBAL_INTERRUPT_MASK			0x4ULL
+#define GLOBAL_INTERRUPT_MASK			0x5ULL
 
 #define PMCRAID_ERROR_INTERRUPTS	(INTRS_IOARCB_TRANSFER_FAILED | \
 					 INTRS_IOA_UNIT_CHECK | \
@@ -503,8 +526,8 @@
 
 #define PMCRAID_PCI_INTERRUPTS		(PMCRAID_ERROR_INTERRUPTS | \
 					 INTRS_HRRQ_VALID | \
-					 INTRS_CRITICAL_OP_IN_PROGRESS |\
-					 INTRS_TRANSITION_TO_OPERATIONAL)
+					 INTRS_TRANSITION_TO_OPERATIONAL |\
+					 INTRS_ALLOW_MSIX_VECTOR0)
 
 /* control_block, associated with each of the commands contains IOARCB, IOADLs
  * memory for IOASA. Additional 3 * 16 bytes are allocated in order to support
@@ -526,17 +549,24 @@
 	struct scatterlist scatterlist[1];
 };
 
+/* page D0 inquiry data of focal point resource */
+struct pmcraid_inquiry_data {
+	__u8	ph_dev_type;
+	__u8	page_code;
+	__u8	reserved1;
+	__u8	add_page_len;
+	__u8	length;
+	__u8	reserved2;
+	__le16	fw_version;
+	__u8	reserved3[16];
+};
+
 /* pmcraid_cmd - LLD representation of SCSI command */
 struct pmcraid_cmd {
 
 	/* Ptr and bus address of DMA.able control block for this command */
 	struct pmcraid_control_block *ioa_cb;
 	dma_addr_t ioa_cb_bus_addr;
-
-	/* sense buffer for REQUEST SENSE command if firmware is not sending
-	 * auto sense data
-	 */
-	dma_addr_t sense_buffer_dma;
 	dma_addr_t dma_handle;
 	u8 *sense_buffer;
 
@@ -556,11 +586,22 @@
 
 	struct pmcraid_sglist *sglist; /* used for passthrough IOCTLs */
 
-	/* scratch used during reset sequence */
+	/* scratch used */
 	union {
+		/* during reset sequence */
 		unsigned long time_left;
 		struct pmcraid_resource_entry *res;
-	} u;
+		int hrrq_index;
+
+		/* used during IO command error handling. Sense buffer
+		 * for REQUEST SENSE command if firmware is not sending
+		 * auto sense data
+		 */
+		struct  {
+			u8 *sense_buffer;
+			dma_addr_t sense_buffer_dma;
+		};
+	};
 };
 
 /*
@@ -568,6 +609,7 @@
  */
 struct pmcraid_interrupts {
 	void __iomem *ioa_host_interrupt_reg;
+	void __iomem *ioa_host_msix_interrupt_reg;
 	void __iomem *ioa_host_interrupt_clr_reg;
 	void __iomem *ioa_host_interrupt_mask_reg;
 	void __iomem *ioa_host_interrupt_mask_clr_reg;
@@ -578,11 +620,12 @@
 
 /* ISR parameters LLD allocates (one for each MSI-X if enabled) vectors */
 struct pmcraid_isr_param {
-	u8 hrrq_id;			/* hrrq entry index */
-	u16 vector;			/* allocated msi-x vector */
 	struct pmcraid_instance *drv_inst;
+	u16 vector;			/* allocated msi-x vector */
+	u8 hrrq_id;			/* hrrq entry index */
 };
 
+
 /* AEN message header sent as part of event data to applications */
 struct pmcraid_aen_msg {
 	u32 hostno;
@@ -591,6 +634,19 @@
 	u8  data[0];
 };
 
+/* Controller state event message type */
+struct pmcraid_state_msg {
+	struct pmcraid_aen_msg msg;
+	u32 ioa_state;
+};
+
+#define PMC_DEVICE_EVENT_RESET_START		0x11000000
+#define PMC_DEVICE_EVENT_RESET_SUCCESS		0x11000001
+#define PMC_DEVICE_EVENT_RESET_FAILED		0x11000002
+#define PMC_DEVICE_EVENT_SHUTDOWN_START		0x11000003
+#define PMC_DEVICE_EVENT_SHUTDOWN_SUCCESS	0x11000004
+#define PMC_DEVICE_EVENT_SHUTDOWN_FAILED	0x11000005
+
 struct pmcraid_hostrcb {
 	struct pmcraid_instance *drv_inst;
 	struct pmcraid_aen_msg *msg;
@@ -628,6 +684,7 @@
 	/* HostRCBs needed for HCAM */
 	struct pmcraid_hostrcb ldn;
 	struct pmcraid_hostrcb ccn;
+	struct pmcraid_state_msg scn;	/* controller state change msg */
 
 
 	/* Bus address of start of HRRQ */
@@ -645,12 +702,15 @@
 	/* Lock for HRRQ access */
 	spinlock_t hrrq_lock[PMCRAID_NUM_MSIX_VECTORS];
 
+	struct pmcraid_inquiry_data *inq_data;
+	dma_addr_t  inq_data_baddr;
+
+	/* size of configuration table entry, varies based on the firmware */
+	u32	config_table_entry_size;
+
 	/* Expected toggle bit at host */
 	u8 host_toggle_bit[PMCRAID_NUM_MSIX_VECTORS];
 
-	/* No of Reset IOA retries . IOA marked dead if threshold exceeds */
-	u8 ioa_reset_attempts;
-#define PMCRAID_RESET_ATTEMPTS 3
 
 	/* Wait Q for  threads to wait for Reset IOA completion */
 	wait_queue_head_t reset_wait_q;
@@ -664,14 +724,22 @@
 	struct Scsi_Host *host;	/* mid layer interface structure handle */
 	struct pci_dev *pdev;	/* PCI device structure handle */
 
+	/* No of Reset IOA retries . IOA marked dead if threshold exceeds */
+	u8 ioa_reset_attempts;
+#define PMCRAID_RESET_ATTEMPTS 3
+
 	u8  current_log_level;	/* default level for logging IOASC errors */
 
 	u8  num_hrrq;		/* Number of interrupt vectors allocated */
+	u8  interrupt_mode;	/* current interrupt mode legacy or msix */
 	dev_t dev;		/* Major-Minor numbers for Char device */
 
 	/* Used as ISR handler argument */
 	struct pmcraid_isr_param hrrq_vector[PMCRAID_NUM_MSIX_VECTORS];
 
+	/* Message id as filled in last fired IOARCB, used to identify HRRQ */
+	atomic_t last_message_id;
+
 	/* configuration table */
 	struct pmcraid_config_table *cfg_table;
 	dma_addr_t cfg_table_bus_addr;
@@ -686,8 +754,14 @@
 
 	struct list_head free_cmd_pool;
 	struct list_head pending_cmd_pool;
-	spinlock_t free_pool_lock;	 	/* free pool lock */
-	spinlock_t pending_pool_lock;	 	/* pending pool lock */
+	spinlock_t free_pool_lock;		/* free pool lock */
+	spinlock_t pending_pool_lock;		/* pending pool lock */
+
+	/* Tasklet to handle deferred processing */
+	struct tasklet_struct isr_tasklet[PMCRAID_NUM_MSIX_VECTORS];
+
+	/* Work-queue (Shared) for deferred reset processing */
+	struct work_struct worker_q;
 
 	/* No of IO commands pending with FW */
 	atomic_t outstanding_cmds;
@@ -695,11 +769,6 @@
 	/* should add/delete resources to mid-layer now ?*/
 	atomic_t expose_resources;
 
-	/* Tasklet to handle deferred processing */
-	struct tasklet_struct isr_tasklet[PMCRAID_NUM_MSIX_VECTORS];
-
-	/* Work-queue (Shared) for deferred reset processing */
-	struct work_struct worker_q;
 
 
 	u32 ioa_state:4;	/* For IOA Reset sequence FSM */
@@ -728,7 +797,10 @@
 /* LLD maintained resource entry structure */
 struct pmcraid_resource_entry {
 	struct list_head queue;	/* link to "to be exposed" resources */
-	struct pmcraid_config_table_entry cfg_entry;
+	union {
+		struct pmcraid_config_table_entry cfg_entry;
+		struct pmcraid_config_table_entry_ext cfg_entry_ext;
+	};
 	struct scsi_device *scsi_dev;	/* Link scsi_device structure */
 	atomic_t read_failures;		/* count of failed READ commands */
 	atomic_t write_failures;	/* count of failed WRITE commands */
@@ -771,73 +843,75 @@
  * statically.
  */
 static struct pmcraid_ioasc_error pmcraid_ioasc_error_table[] = {
-	{0x01180600, IOASC_LOG_LEVEL_MUST,
+	{0x01180600, IOASC_LOG_LEVEL_HARD,
 	 "Recovered Error, soft media error, sector reassignment suggested"},
-	{0x015D0000, IOASC_LOG_LEVEL_MUST,
-	 "Recovered Error, failure prediction threshold exceeded"},
-	{0x015D9200, IOASC_LOG_LEVEL_MUST,
-	 "Recovered Error, soft Cache Card Battery error threshold"},
-	{0x015D9200, IOASC_LOG_LEVEL_MUST,
-	 "Recovered Error, soft Cache Card Battery error threshold"},
-	{0x02048000, IOASC_LOG_LEVEL_MUST,
+	{0x015D0000, IOASC_LOG_LEVEL_HARD,
+	 "Recovered Error, failure prediction thresold exceeded"},
+	{0x015D9200, IOASC_LOG_LEVEL_HARD,
+	 "Recovered Error, soft Cache Card Battery error thresold"},
+	{0x015D9200, IOASC_LOG_LEVEL_HARD,
+	 "Recovered Error, soft Cache Card Battery error thresold"},
+	{0x02048000, IOASC_LOG_LEVEL_HARD,
 	 "Not Ready, IOA Reset Required"},
-	{0x02408500, IOASC_LOG_LEVEL_MUST,
+	{0x02408500, IOASC_LOG_LEVEL_HARD,
 	 "Not Ready, IOA microcode download required"},
-	{0x03110B00, IOASC_LOG_LEVEL_MUST,
+	{0x03110B00, IOASC_LOG_LEVEL_HARD,
 	 "Medium Error, data unreadable, reassignment suggested"},
 	{0x03110C00, IOASC_LOG_LEVEL_MUST,
 	 "Medium Error, data unreadable do not reassign"},
-	{0x03310000, IOASC_LOG_LEVEL_MUST,
+	{0x03310000, IOASC_LOG_LEVEL_HARD,
 	 "Medium Error, media corrupted"},
-	{0x04050000, IOASC_LOG_LEVEL_MUST,
+	{0x04050000, IOASC_LOG_LEVEL_HARD,
 	 "Hardware Error, IOA can't communicate with device"},
 	{0x04080000, IOASC_LOG_LEVEL_MUST,
 	 "Hardware Error, device bus error"},
-	{0x04080000, IOASC_LOG_LEVEL_MUST,
+	{0x04088000, IOASC_LOG_LEVEL_MUST,
 	 "Hardware Error, device bus is not functioning"},
-	{0x04118000, IOASC_LOG_LEVEL_MUST,
+	{0x04118000, IOASC_LOG_LEVEL_HARD,
 	 "Hardware Error, IOA reserved area data check"},
-	{0x04118100, IOASC_LOG_LEVEL_MUST,
+	{0x04118100, IOASC_LOG_LEVEL_HARD,
 	 "Hardware Error, IOA reserved area invalid data pattern"},
-	{0x04118200, IOASC_LOG_LEVEL_MUST,
+	{0x04118200, IOASC_LOG_LEVEL_HARD,
 	 "Hardware Error, IOA reserved area LRC error"},
-	{0x04320000, IOASC_LOG_LEVEL_MUST,
+	{0x04320000, IOASC_LOG_LEVEL_HARD,
 	 "Hardware Error, reassignment space exhausted"},
-	{0x04330000, IOASC_LOG_LEVEL_MUST,
+	{0x04330000, IOASC_LOG_LEVEL_HARD,
 	 "Hardware Error, data transfer underlength error"},
-	{0x04330000, IOASC_LOG_LEVEL_MUST,
+	{0x04330000, IOASC_LOG_LEVEL_HARD,
 	 "Hardware Error, data transfer overlength error"},
 	{0x04418000, IOASC_LOG_LEVEL_MUST,
 	 "Hardware Error, PCI bus error"},
-	{0x04440000, IOASC_LOG_LEVEL_MUST,
+	{0x04440000, IOASC_LOG_LEVEL_HARD,
 	 "Hardware Error, device error"},
-	{0x04448300, IOASC_LOG_LEVEL_MUST,
+	{0x04448200, IOASC_LOG_LEVEL_MUST,
+	 "Hardware Error, IOA error"},
+	{0x04448300, IOASC_LOG_LEVEL_HARD,
 	 "Hardware Error, undefined device response"},
-	{0x04448400, IOASC_LOG_LEVEL_MUST,
+	{0x04448400, IOASC_LOG_LEVEL_HARD,
 	 "Hardware Error, IOA microcode error"},
-	{0x04448600, IOASC_LOG_LEVEL_MUST,
+	{0x04448600, IOASC_LOG_LEVEL_HARD,
 	 "Hardware Error, IOA reset required"},
-	{0x04449200, IOASC_LOG_LEVEL_MUST,
+	{0x04449200, IOASC_LOG_LEVEL_HARD,
 	 "Hardware Error, hard Cache Fearuee Card Battery error"},
-	{0x0444A000, IOASC_LOG_LEVEL_MUST,
+	{0x0444A000, IOASC_LOG_LEVEL_HARD,
 	 "Hardware Error, failed device altered"},
-	{0x0444A200, IOASC_LOG_LEVEL_MUST,
+	{0x0444A200, IOASC_LOG_LEVEL_HARD,
 	 "Hardware Error, data check after reassignment"},
-	{0x0444A300, IOASC_LOG_LEVEL_MUST,
+	{0x0444A300, IOASC_LOG_LEVEL_HARD,
 	 "Hardware Error, LRC error after reassignment"},
-	{0x044A0000, IOASC_LOG_LEVEL_MUST,
+	{0x044A0000, IOASC_LOG_LEVEL_HARD,
 	 "Hardware Error, device bus error (msg/cmd phase)"},
-	{0x04670400, IOASC_LOG_LEVEL_MUST,
+	{0x04670400, IOASC_LOG_LEVEL_HARD,
 	 "Hardware Error, new device can't be used"},
-	{0x04678000, IOASC_LOG_LEVEL_MUST,
+	{0x04678000, IOASC_LOG_LEVEL_HARD,
 	 "Hardware Error, invalid multiadapter configuration"},
-	{0x04678100, IOASC_LOG_LEVEL_MUST,
+	{0x04678100, IOASC_LOG_LEVEL_HARD,
 	 "Hardware Error, incorrect connection between enclosures"},
-	{0x04678200, IOASC_LOG_LEVEL_MUST,
+	{0x04678200, IOASC_LOG_LEVEL_HARD,
 	 "Hardware Error, connections exceed IOA design limits"},
-	{0x04678300, IOASC_LOG_LEVEL_MUST,
+	{0x04678300, IOASC_LOG_LEVEL_HARD,
 	 "Hardware Error, incorrect multipath connection"},
-	{0x04679000, IOASC_LOG_LEVEL_MUST,
+	{0x04679000, IOASC_LOG_LEVEL_HARD,
 	 "Hardware Error, command to LUN failed"},
 	{0x064C8000, IOASC_LOG_LEVEL_HARD,
 	 "Unit Attention, cache exists for missing/failed device"},
@@ -845,15 +919,15 @@
 	 "Unit Attention, incompatible exposed mode device"},
 	{0x06670600, IOASC_LOG_LEVEL_HARD,
 	 "Unit Attention, attachment of logical unit failed"},
-	{0x06678000, IOASC_LOG_LEVEL_MUST,
+	{0x06678000, IOASC_LOG_LEVEL_HARD,
 	 "Unit Attention, cables exceed connective design limit"},
-	{0x06678300, IOASC_LOG_LEVEL_MUST,
+	{0x06678300, IOASC_LOG_LEVEL_HARD,
 	 "Unit Attention, incomplete multipath connection between" \
 	 "IOA and enclosure"},
-	{0x06678400, IOASC_LOG_LEVEL_MUST,
+	{0x06678400, IOASC_LOG_LEVEL_HARD,
 	 "Unit Attention, incomplete multipath connection between" \
 	 "device and enclosure"},
-	{0x06678500, IOASC_LOG_LEVEL_MUST,
+	{0x06678500, IOASC_LOG_LEVEL_HARD,
 	 "Unit Attention, incomplete multipath connection between" \
 	 "IOA and remote IOA"},
 	{0x06678600, IOASC_LOG_LEVEL_HARD,
@@ -863,11 +937,11 @@
 	 "function"},
 	{0x06698200, IOASC_LOG_LEVEL_HARD,
 	 "Unit Attention, corrupt array parity detected on device"},
-	{0x066B0200, IOASC_LOG_LEVEL_MUST,
+	{0x066B0200, IOASC_LOG_LEVEL_HARD,
 	 "Unit Attention, array exposed"},
 	{0x066B8200, IOASC_LOG_LEVEL_HARD,
 	 "Unit Attention, exposed array is still protected"},
-	{0x066B9200, IOASC_LOG_LEVEL_MUST,
+	{0x066B9200, IOASC_LOG_LEVEL_HARD,
 	 "Unit Attention, Multipath redundancy level got worse"},
 	{0x07270000, IOASC_LOG_LEVEL_HARD,
 	 "Data Protect, device is read/write protected by IOA"},
@@ -875,37 +949,37 @@
 	 "Data Protect, IOA doesn't support device attribute"},
 	{0x07278100, IOASC_LOG_LEVEL_HARD,
 	 "Data Protect, NVRAM mirroring prohibited"},
-	{0x07278400, IOASC_LOG_LEVEL_MUST,
+	{0x07278400, IOASC_LOG_LEVEL_HARD,
 	 "Data Protect, array is short 2 or more devices"},
-	{0x07278600, IOASC_LOG_LEVEL_MUST,
+	{0x07278600, IOASC_LOG_LEVEL_HARD,
 	 "Data Protect, exposed array is short a required device"},
-	{0x07278700, IOASC_LOG_LEVEL_MUST,
+	{0x07278700, IOASC_LOG_LEVEL_HARD,
 	 "Data Protect, array members not at required addresses"},
-	{0x07278800, IOASC_LOG_LEVEL_MUST,
+	{0x07278800, IOASC_LOG_LEVEL_HARD,
 	 "Data Protect, exposed mode device resource address conflict"},
-	{0x07278900, IOASC_LOG_LEVEL_MUST,
+	{0x07278900, IOASC_LOG_LEVEL_HARD,
 	 "Data Protect, incorrect resource address of exposed mode device"},
-	{0x07278A00, IOASC_LOG_LEVEL_MUST,
+	{0x07278A00, IOASC_LOG_LEVEL_HARD,
 	 "Data Protect, Array is missing a device and parity is out of sync"},
-	{0x07278B00, IOASC_LOG_LEVEL_MUST,
+	{0x07278B00, IOASC_LOG_LEVEL_HARD,
 	 "Data Protect, maximum number of arrays already exist"},
 	{0x07278C00, IOASC_LOG_LEVEL_HARD,
 	 "Data Protect, cannot locate cache data for device"},
 	{0x07278D00, IOASC_LOG_LEVEL_HARD,
 	 "Data Protect, cache data exits for a changed device"},
-	{0x07279100, IOASC_LOG_LEVEL_MUST,
+	{0x07279100, IOASC_LOG_LEVEL_HARD,
 	 "Data Protect, detection of a device requiring format"},
-	{0x07279200, IOASC_LOG_LEVEL_MUST,
+	{0x07279200, IOASC_LOG_LEVEL_HARD,
 	 "Data Protect, IOA exceeds maximum number of devices"},
-	{0x07279600, IOASC_LOG_LEVEL_MUST,
+	{0x07279600, IOASC_LOG_LEVEL_HARD,
 	 "Data Protect, missing array, volume set is not functional"},
-	{0x07279700, IOASC_LOG_LEVEL_MUST,
+	{0x07279700, IOASC_LOG_LEVEL_HARD,
 	 "Data Protect, single device for a volume set"},
-	{0x07279800, IOASC_LOG_LEVEL_MUST,
+	{0x07279800, IOASC_LOG_LEVEL_HARD,
 	 "Data Protect, missing multiple devices for a volume set"},
 	{0x07279900, IOASC_LOG_LEVEL_HARD,
 	 "Data Protect, maximum number of volument sets already exists"},
-	{0x07279A00, IOASC_LOG_LEVEL_MUST,
+	{0x07279A00, IOASC_LOG_LEVEL_HARD,
 	 "Data Protect, other volume set problem"},
 };
 
@@ -952,27 +1026,6 @@
 
 #define PMCRAID_IOCTL_SIGNATURE      "PMCRAID"
 
-
-/*
- * pmcraid_event_details - defines AEN details that apps can retrieve from LLD
- *
- * .rcb_ccn - complete RCB of CCN
- * .rcb_ldn - complete RCB of CCN
- */
-struct pmcraid_event_details {
-	struct pmcraid_hcam_ccn rcb_ccn;
-	struct pmcraid_hcam_ldn rcb_ldn;
-};
-
-/*
- * pmcraid_driver_ioctl_buffer - structure passed as argument to most of the
- * PMC driver handled ioctls.
- */
-struct pmcraid_driver_ioctl_buffer {
-	struct pmcraid_ioctl_header ioctl_header;
-	struct pmcraid_event_details event_details;
-};
-
 /*
  * pmcraid_passthrough_ioctl_buffer - structure given as argument to
  * passthrough(or firmware handled) IOCTL commands. Note that ioarcb requires
--- scsi-misc-2.6.orig/drivers/scsi/pmcraid.c	2010-06-04 09:39:25.000000000 -0700
+++ scsi-misc-2.6/drivers/scsi/pmcraid.c	2010-06-04 09:40:54.000000000 -0700
@@ -113,6 +113,7 @@
 	 .global_intr_mask = 0x00034,
 	 .ioa_host_intr = 0x0009C,
 	 .ioa_host_intr_clr = 0x000A0,
+	 .ioa_host_msix_intr = 0x7FC40,
 	 .ioa_host_mask = 0x7FC28,
 	 .ioa_host_mask_clr = 0x7FC28,
 	 .host_ioa_intr = 0x00020,
@@ -154,8 +155,12 @@
 	u8 target, bus, lun;
 	unsigned long lock_flags;
 	int rc = -ENXIO;
+	u16 fw_version;
+
 	pinstance = shost_priv(scsi_dev->host);
 
+	fw_version = be16_to_cpu(pinstance->inq_data->fw_version);
+
 	/* Driver exposes VSET and GSCSI resources only; all other device types
 	 * are not exposed. Resource list is synchronized using resource lock
 	 * so any traversal or modifications to the list should be done inside
@@ -166,7 +171,11 @@
 
 		/* do not expose VSETs with order-ids > MAX_VSET_TARGETS */
 		if (RES_IS_VSET(temp->cfg_entry)) {
-			target = temp->cfg_entry.unique_flags1;
+			if (fw_version <= PMCRAID_FW_VERSION_1)
+				target = temp->cfg_entry.unique_flags1;
+			else
+				target = temp->cfg_entry.array_id & 0xFF;
+
 			if (target > PMCRAID_MAX_VSET_TARGETS)
 				continue;
 			bus = PMCRAID_VSET_BUS_ID;
@@ -283,7 +292,7 @@
  * @reason: calling context
  *
  * Return value
- * 	actual depth set
+ *	actual depth set
  */
 static int pmcraid_change_queue_depth(struct scsi_device *scsi_dev, int depth,
 				      int reason)
@@ -305,7 +314,7 @@
  * @tag: type of tags to use
  *
  * Return value:
- * 	actual queue type set
+ *	actual queue type set
  */
 static int pmcraid_change_queue_type(struct scsi_device *scsi_dev, int tag)
 {
@@ -357,6 +366,7 @@
 		 * processed by IOA
 		 */
 		memset(&cmd->ioa_cb->ioarcb.cdb, 0, PMCRAID_MAX_CDB_LEN);
+		ioarcb->hrrq_id = 0;
 		ioarcb->request_flags0 = 0;
 		ioarcb->request_flags1 = 0;
 		ioarcb->cmd_timeout = 0;
@@ -368,13 +378,15 @@
 		ioarcb->add_cmd_param_offset = 0;
 		cmd->ioa_cb->ioasa.ioasc = 0;
 		cmd->ioa_cb->ioasa.residual_data_length = 0;
-		cmd->u.time_left = 0;
+		cmd->time_left = 0;
 	}
 
 	cmd->cmd_done = NULL;
 	cmd->scsi_cmd = NULL;
 	cmd->release = 0;
 	cmd->completion_req = 0;
+	cmd->sense_buffer = 0;
+	cmd->sense_buffer_dma = 0;
 	cmd->dma_handle = 0;
 	init_timer(&cmd->timer);
 }
@@ -449,7 +461,9 @@
  */
 static u32 pmcraid_read_interrupts(struct pmcraid_instance *pinstance)
 {
-	return ioread32(pinstance->int_regs.ioa_host_interrupt_reg);
+	return (pinstance->interrupt_mode) ?
+		ioread32(pinstance->int_regs.ioa_host_msix_interrupt_reg) :
+		ioread32(pinstance->int_regs.ioa_host_interrupt_reg);
 }
 
 /**
@@ -469,10 +483,15 @@
 	u32 gmask = ioread32(pinstance->int_regs.global_interrupt_mask_reg);
 	u32 nmask = gmask | GLOBAL_INTERRUPT_MASK;
 
-	iowrite32(nmask, pinstance->int_regs.global_interrupt_mask_reg);
 	iowrite32(intrs, pinstance->int_regs.ioa_host_interrupt_clr_reg);
-	iowrite32(intrs, pinstance->int_regs.ioa_host_interrupt_mask_reg);
-	ioread32(pinstance->int_regs.ioa_host_interrupt_mask_reg);
+	iowrite32(nmask, pinstance->int_regs.global_interrupt_mask_reg);
+	ioread32(pinstance->int_regs.global_interrupt_mask_reg);
+
+	if (!pinstance->interrupt_mode) {
+		iowrite32(intrs,
+			pinstance->int_regs.ioa_host_interrupt_mask_reg);
+		ioread32(pinstance->int_regs.ioa_host_interrupt_mask_reg);
+	}
 }
 
 /**
@@ -493,8 +512,12 @@
 	u32 nmask = gmask & (~GLOBAL_INTERRUPT_MASK);
 
 	iowrite32(nmask, pinstance->int_regs.global_interrupt_mask_reg);
-	iowrite32(~intrs, pinstance->int_regs.ioa_host_interrupt_mask_reg);
-	ioread32(pinstance->int_regs.ioa_host_interrupt_mask_reg);
+
+	if (!pinstance->interrupt_mode) {
+		iowrite32(~intrs,
+			 pinstance->int_regs.ioa_host_interrupt_mask_reg);
+		ioread32(pinstance->int_regs.ioa_host_interrupt_mask_reg);
+	}
 
 	pmcraid_info("enabled interrupts global mask = %x intr_mask = %x\n",
 		ioread32(pinstance->int_regs.global_interrupt_mask_reg),
@@ -502,6 +525,39 @@
 }
 
 /**
+ * pmcraid_clr_trans_op - clear trans to op interrupt
+ *
+ * @pinstance: pointer to per adapter instance structure
+ *
+ * Return Value
+ *	 None
+ */
+static void pmcraid_clr_trans_op(
+	struct pmcraid_instance *pinstance
+)
+{
+	unsigned long lock_flags;
+
+	if (!pinstance->interrupt_mode) {
+		iowrite32(INTRS_TRANSITION_TO_OPERATIONAL,
+			pinstance->int_regs.ioa_host_interrupt_mask_reg);
+		ioread32(pinstance->int_regs.ioa_host_interrupt_mask_reg);
+		iowrite32(INTRS_TRANSITION_TO_OPERATIONAL,
+			pinstance->int_regs.ioa_host_interrupt_clr_reg);
+		ioread32(pinstance->int_regs.ioa_host_interrupt_clr_reg);
+	}
+
+	if (pinstance->reset_cmd != NULL) {
+		del_timer(&pinstance->reset_cmd->timer);
+		spin_lock_irqsave(
+			pinstance->host->host_lock, lock_flags);
+		pinstance->reset_cmd->cmd_done(pinstance->reset_cmd);
+		spin_unlock_irqrestore(
+			pinstance->host->host_lock, lock_flags);
+	}
+}
+
+/**
  * pmcraid_reset_type - Determine the required reset type
  * @pinstance: pointer to adapter instance structure
  *
@@ -536,7 +592,7 @@
  * pmcraid_bist_done - completion function for PCI BIST
  * @cmd: pointer to reset command
  * Return Value
- * 	none
+ *	none
  */
 
 static void pmcraid_ioa_reset(struct pmcraid_cmd *);
@@ -552,16 +608,16 @@
 
 	/* If PCI config space can't be accessed wait for another two secs */
 	if ((rc != PCIBIOS_SUCCESSFUL || (!(pci_reg & PCI_COMMAND_MEMORY))) &&
-	    cmd->u.time_left > 0) {
+	    cmd->time_left > 0) {
 		pmcraid_info("BIST not complete, waiting another 2 secs\n");
-		cmd->timer.expires = jiffies + cmd->u.time_left;
-		cmd->u.time_left = 0;
+		cmd->timer.expires = jiffies + cmd->time_left;
+		cmd->time_left = 0;
 		cmd->timer.data = (unsigned long)cmd;
 		cmd->timer.function =
 			(void (*)(unsigned long))pmcraid_bist_done;
 		add_timer(&cmd->timer);
 	} else {
-		cmd->u.time_left = 0;
+		cmd->time_left = 0;
 		pmcraid_info("BIST is complete, proceeding with reset\n");
 		spin_lock_irqsave(pinstance->host->host_lock, lock_flags);
 		pmcraid_ioa_reset(cmd);
@@ -585,10 +641,10 @@
 		pinstance->int_regs.host_ioa_interrupt_reg);
 	doorbells = ioread32(pinstance->int_regs.host_ioa_interrupt_reg);
 	intrs = ioread32(pinstance->int_regs.ioa_host_interrupt_reg);
-	pmcraid_info("doorbells after start bist: %x intrs: %x \n",
+	pmcraid_info("doorbells after start bist: %x intrs: %x\n",
 		      doorbells, intrs);
 
-	cmd->u.time_left = msecs_to_jiffies(PMCRAID_BIST_TIMEOUT);
+	cmd->time_left = msecs_to_jiffies(PMCRAID_BIST_TIMEOUT);
 	cmd->timer.data = (unsigned long)cmd;
 	cmd->timer.expires = jiffies + msecs_to_jiffies(PMCRAID_BIST_TIMEOUT);
 	cmd->timer.function = (void (*)(unsigned long))pmcraid_bist_done;
@@ -612,7 +668,7 @@
 	 * some more time to wait, restart the timer
 	 */
 	if (((status & INTRS_CRITICAL_OP_IN_PROGRESS) == 0) ||
-	    cmd->u.time_left <= 0) {
+	    cmd->time_left <= 0) {
 		pmcraid_info("critical op is reset proceeding with reset\n");
 		spin_lock_irqsave(pinstance->host->host_lock, lock_flags);
 		pmcraid_ioa_reset(cmd);
@@ -620,7 +676,7 @@
 	} else {
 		pmcraid_info("critical op is not yet reset waiting again\n");
 		/* restart timer if some more time is available to wait */
-		cmd->u.time_left -= PMCRAID_CHECK_FOR_RESET_TIMEOUT;
+		cmd->time_left -= PMCRAID_CHECK_FOR_RESET_TIMEOUT;
 		cmd->timer.data = (unsigned long)cmd;
 		cmd->timer.expires = jiffies + PMCRAID_CHECK_FOR_RESET_TIMEOUT;
 		cmd->timer.function =
@@ -638,6 +694,7 @@
  *	successfully written to IOA. Returns non-zero in case pci_config_space
  *	is not accessible
  */
+static void pmcraid_notify_ioastate(struct pmcraid_instance *, u32);
 static void pmcraid_reset_alert(struct pmcraid_cmd *cmd)
 {
 	struct pmcraid_instance *pinstance = cmd->drv_inst;
@@ -658,7 +715,7 @@
 		 * OPERATION bit is reset. A timer is started to wait for this
 		 * bit to be reset.
 		 */
-		cmd->u.time_left = PMCRAID_RESET_TIMEOUT;
+		cmd->time_left = PMCRAID_RESET_TIMEOUT;
 		cmd->timer.data = (unsigned long)cmd;
 		cmd->timer.expires = jiffies + PMCRAID_CHECK_FOR_RESET_TIMEOUT;
 		cmd->timer.function =
@@ -693,7 +750,8 @@
 	unsigned long lock_flags;
 
 	dev_info(&pinstance->pdev->dev,
-		"Adapter being reset due to command timeout.\n");
+		"Adapter being reset due to cmd(CDB[0] = %x) timeout\n",
+		cmd->ioa_cb->ioarcb.cdb[0]);
 
 	/* Command timeouts result in hard reset sequence. The command that got
 	 * timed out may be the one used as part of reset sequence. In this
@@ -736,9 +794,14 @@
 		 */
 		if (cmd == pinstance->reset_cmd)
 			cmd->cmd_done = pmcraid_ioa_reset;
-
 	}
 
+	/* Notify apps of important IOA bringup/bringdown sequences */
+	if (pinstance->scn.ioa_state != PMC_DEVICE_EVENT_RESET_START &&
+	    pinstance->scn.ioa_state != PMC_DEVICE_EVENT_SHUTDOWN_START)
+		pmcraid_notify_ioastate(pinstance,
+					PMC_DEVICE_EVENT_RESET_START);
+
 	pinstance->ioa_state = IOA_STATE_IN_RESET_ALERT;
 	scsi_block_requests(pinstance->host);
 	pmcraid_reset_alert(cmd);
@@ -866,7 +929,7 @@
 	/* Add this command block to pending cmd pool. We do this prior to
 	 * writting IOARCB to ioarrin because IOA might complete the command
 	 * by the time we are about to add it to the list. Response handler
-	 * (isr/tasklet) looks for cmb block in the pending pending list.
+	 * (isr/tasklet) looks for cmd block in the pending pending list.
 	 */
 	spin_lock_irqsave(&pinstance->pending_pool_lock, lock_flags);
 	list_add_tail(&cmd->free_list, &pinstance->pending_cmd_pool);
@@ -916,6 +979,23 @@
 }
 
 /**
+ * pmcraid_ioa_shutdown_done - completion function for IOA shutdown command
+ * @cmd: pointer to the command block used for sending IOA shutdown command
+ *
+ * Return value
+ *  None
+ */
+static void pmcraid_ioa_shutdown_done(struct pmcraid_cmd *cmd)
+{
+	struct pmcraid_instance *pinstance = cmd->drv_inst;
+	unsigned long lock_flags;
+
+	spin_lock_irqsave(pinstance->host->host_lock, lock_flags);
+	pmcraid_ioa_reset(cmd);
+	spin_unlock_irqrestore(pinstance->host->host_lock, lock_flags);
+}
+
+/**
  * pmcraid_ioa_shutdown - sends SHUTDOWN command to ioa
  *
  * @cmd: pointer to the command block used as part of reset sequence
@@ -943,30 +1023,112 @@
 	pmcraid_info("firing normal shutdown command (%d) to IOA\n",
 		     le32_to_cpu(cmd->ioa_cb->ioarcb.response_handle));
 
-	pmcraid_send_cmd(cmd, pmcraid_ioa_reset,
+	pmcraid_notify_ioastate(cmd->drv_inst, PMC_DEVICE_EVENT_SHUTDOWN_START);
+
+	pmcraid_send_cmd(cmd, pmcraid_ioa_shutdown_done,
 			 PMCRAID_SHUTDOWN_TIMEOUT,
 			 pmcraid_timeout_handler);
 }
 
 /**
- * pmcraid_identify_hrrq - registers host rrq buffers with IOA
- * @cmd: pointer to command block to be used for identify hrrq
+ * pmcraid_get_fwversion_done - completion function for get_fwversion
+ *
+ * @cmd: pointer to command block used to send INQUIRY command
  *
  * Return Value
- *	 0 in case of success, otherwise non-zero failure code
+ *	none
  */
-
 static void pmcraid_querycfg(struct pmcraid_cmd *);
 
+static void pmcraid_get_fwversion_done(struct pmcraid_cmd *cmd)
+{
+	struct pmcraid_instance *pinstance = cmd->drv_inst;
+	u32 ioasc = le32_to_cpu(cmd->ioa_cb->ioasa.ioasc);
+	unsigned long lock_flags;
+
+	/* configuration table entry size depends on firmware version. If fw
+	 * version is not known, it is not possible to interpret IOA config
+	 * table
+	 */
+	if (ioasc) {
+		pmcraid_err("IOA Inquiry failed with %x\n", ioasc);
+		spin_lock_irqsave(pinstance->host->host_lock, lock_flags);
+		pinstance->ioa_state = IOA_STATE_IN_RESET_ALERT;
+		pmcraid_reset_alert(cmd);
+		spin_unlock_irqrestore(pinstance->host->host_lock, lock_flags);
+	} else  {
+		pmcraid_querycfg(cmd);
+	}
+}
+
+/**
+ * pmcraid_get_fwversion - reads firmware version information
+ *
+ * @cmd: pointer to command block used to send INQUIRY command
+ *
+ * Return Value
+ *	none
+ */
+static void pmcraid_get_fwversion(struct pmcraid_cmd *cmd)
+{
+	struct pmcraid_ioarcb *ioarcb = &cmd->ioa_cb->ioarcb;
+	struct pmcraid_ioadl_desc *ioadl = ioarcb->add_data.u.ioadl;
+	struct pmcraid_instance *pinstance = cmd->drv_inst;
+	u16 data_size = sizeof(struct pmcraid_inquiry_data);
+
+	pmcraid_reinit_cmdblk(cmd);
+	ioarcb->request_type = REQ_TYPE_SCSI;
+	ioarcb->resource_handle = cpu_to_le32(PMCRAID_IOA_RES_HANDLE);
+	ioarcb->cdb[0] = INQUIRY;
+	ioarcb->cdb[1] = 1;
+	ioarcb->cdb[2] = 0xD0;
+	ioarcb->cdb[3] = (data_size >> 8) & 0xFF;
+	ioarcb->cdb[4] = data_size & 0xFF;
+
+	/* Since entire inquiry data it can be part of IOARCB itself
+	 */
+	ioarcb->ioadl_bus_addr = cpu_to_le64((cmd->ioa_cb_bus_addr) +
+					offsetof(struct pmcraid_ioarcb,
+						add_data.u.ioadl[0]));
+	ioarcb->ioadl_length = cpu_to_le32(sizeof(struct pmcraid_ioadl_desc));
+	ioarcb->ioarcb_bus_addr &= ~(0x1FULL);
+
+	ioarcb->request_flags0 |= NO_LINK_DESCS;
+	ioarcb->data_transfer_length = cpu_to_le32(data_size);
+	ioadl = &(ioarcb->add_data.u.ioadl[0]);
+	ioadl->flags = IOADL_FLAGS_LAST_DESC;
+	ioadl->address = cpu_to_le64(pinstance->inq_data_baddr);
+	ioadl->data_len = cpu_to_le32(data_size);
+
+	pmcraid_send_cmd(cmd, pmcraid_get_fwversion_done,
+			 PMCRAID_INTERNAL_TIMEOUT, pmcraid_timeout_handler);
+}
+
+/**
+ * pmcraid_identify_hrrq - registers host rrq buffers with IOA
+ * @cmd: pointer to command block to be used for identify hrrq
+ *
+ * Return Value
+ *	 none
+ */
 static void pmcraid_identify_hrrq(struct pmcraid_cmd *cmd)
 {
 	struct pmcraid_instance *pinstance = cmd->drv_inst;
 	struct pmcraid_ioarcb *ioarcb = &cmd->ioa_cb->ioarcb;
-	int index = 0;
+	int index = cmd->hrrq_index;
 	__be64 hrrq_addr = cpu_to_be64(pinstance->hrrq_start_bus_addr[index]);
 	u32 hrrq_size = cpu_to_be32(sizeof(u32) * PMCRAID_MAX_CMD);
+	void (*done_function)(struct pmcraid_cmd *);
 
 	pmcraid_reinit_cmdblk(cmd);
+	cmd->hrrq_index = index + 1;
+
+	if (cmd->hrrq_index < pinstance->num_hrrq) {
+		done_function = pmcraid_identify_hrrq;
+	} else {
+		cmd->hrrq_index = 0;
+		done_function = pmcraid_get_fwversion;
+	}
 
 	/* Initialize ioarcb */
 	ioarcb->request_type = REQ_TYPE_IOACMD;
@@ -980,8 +1142,8 @@
 	/* IOA expects 64-bit pci address to be written in B.E format
 	 * (i.e cdb[2]=MSByte..cdb[9]=LSB.
 	 */
-	pmcraid_info("HRRQ_IDENTIFY with hrrq:ioarcb => %llx:%llx\n",
-		     hrrq_addr, ioarcb->ioarcb_bus_addr);
+	pmcraid_info("HRRQ_IDENTIFY with hrrq:ioarcb:index => %llx:%llx:%x\n",
+		     hrrq_addr, ioarcb->ioarcb_bus_addr, index);
 
 	memcpy(&(ioarcb->cdb[2]), &hrrq_addr, sizeof(hrrq_addr));
 	memcpy(&(ioarcb->cdb[10]), &hrrq_size, sizeof(hrrq_size));
@@ -990,7 +1152,7 @@
 	 * Note that this gets called even during reset from SCSI mid-layer
 	 * or tasklet
 	 */
-	pmcraid_send_cmd(cmd, pmcraid_querycfg,
+	pmcraid_send_cmd(cmd, done_function,
 			 PMCRAID_INTERNAL_TIMEOUT,
 			 pmcraid_timeout_handler);
 }
@@ -1047,7 +1209,7 @@
 	}
 
 	if (type == PMCRAID_HCAM_CODE_CONFIG_CHANGE) {
-		rcb_size = sizeof(struct pmcraid_hcam_ccn);
+		rcb_size = sizeof(struct pmcraid_hcam_ccn_ext);
 		cmd_done = pmcraid_process_ccn;
 		dma = pinstance->ccn.baddr + PMCRAID_AEN_HDR_SIZE;
 		hcam = &pinstance->ccn;
@@ -1094,7 +1256,7 @@
  * This function will send a Host Controlled Async command to IOA.
  *
  * Return value:
- * 	none
+ *	none
  */
 static void pmcraid_send_hcam(struct pmcraid_instance *pinstance, u8 type)
 {
@@ -1202,18 +1364,25 @@
 /**
  * pmcraid_expose_resource - check if the resource can be exposed to OS
  *
+ * @fw_version: firmware version code
  * @cfgte: pointer to configuration table entry of the resource
  *
  * Return value:
- * 	true if resource can be added to midlayer, false(0) otherwise
+ *	true if resource can be added to midlayer, false(0) otherwise
  */
-static int pmcraid_expose_resource(struct pmcraid_config_table_entry *cfgte)
+static int pmcraid_expose_resource(u16 fw_version,
+				   struct pmcraid_config_table_entry *cfgte)
 {
 	int retval = 0;
 
-	if (cfgte->resource_type == RES_TYPE_VSET)
-		retval = ((cfgte->unique_flags1 & 0x80) == 0);
-	else if (cfgte->resource_type == RES_TYPE_GSCSI)
+	if (cfgte->resource_type == RES_TYPE_VSET) {
+		if (fw_version <= PMCRAID_FW_VERSION_1)
+			retval = ((cfgte->unique_flags1 & 0x80) == 0);
+		else
+			retval = ((cfgte->unique_flags0 & 0x80) == 0 &&
+				  (cfgte->unique_flags1 & 0x80) == 0);
+
+	} else if (cfgte->resource_type == RES_TYPE_GSCSI)
 		retval = (RES_BUS(cfgte->resource_address) !=
 				PMCRAID_VIRTUAL_ENCL_BUS_ID);
 	return retval;
@@ -1246,8 +1415,8 @@
  * pmcraid_netlink_init - registers pmcraid_event_family
  *
  * Return value:
- * 	0 if the pmcraid_event_family is successfully registered
- * 	with netlink generic, non-zero otherwise
+ *	0 if the pmcraid_event_family is successfully registered
+ *	with netlink generic, non-zero otherwise
  */
 static int pmcraid_netlink_init(void)
 {
@@ -1268,7 +1437,7 @@
  * pmcraid_netlink_release - unregisters pmcraid_event_family
  *
  * Return value:
- * 	none
+ *	none
  */
 static void pmcraid_netlink_release(void)
 {
@@ -1283,31 +1452,30 @@
  * Return value:
  *	0 if success, error value in case of any failure.
  */
-static int pmcraid_notify_aen(struct pmcraid_instance *pinstance, u8 type)
+static int pmcraid_notify_aen(
+	struct pmcraid_instance *pinstance,
+	struct pmcraid_aen_msg  *aen_msg,
+	u32    data_size
+)
 {
 	struct sk_buff *skb;
-	struct pmcraid_aen_msg *aen_msg;
 	void *msg_header;
-	int data_size, total_size;
+	u32  total_size, nla_genl_hdr_total_size;
 	int result;
 
-
-	if (type == PMCRAID_HCAM_CODE_LOG_DATA) {
-		aen_msg = pinstance->ldn.msg;
-		data_size = pinstance->ldn.hcam->data_len;
-	} else {
-		aen_msg = pinstance->ccn.msg;
-		data_size = pinstance->ccn.hcam->data_len;
-	}
-
-	data_size += sizeof(struct pmcraid_hcam_hdr);
 	aen_msg->hostno = (pinstance->host->unique_id << 16 |
 			   MINOR(pinstance->cdev.dev));
 	aen_msg->length = data_size;
+
 	data_size += sizeof(*aen_msg);
 
 	total_size = nla_total_size(data_size);
-	skb = genlmsg_new(total_size, GFP_ATOMIC);
+	/* Add GENL_HDR to total_size */
+	nla_genl_hdr_total_size =
+		(total_size + (GENL_HDRLEN +
+		((struct genl_family *)&pmcraid_event_family)->hdrsize)
+		 + NLMSG_HDRLEN);
+	skb = genlmsg_new(nla_genl_hdr_total_size, GFP_ATOMIC);
 
 
 	if (!skb) {
@@ -1329,7 +1497,7 @@
 	result = nla_put(skb, PMCRAID_AEN_ATTR_EVENT, data_size, aen_msg);
 
 	if (result) {
-		pmcraid_err("failed to copy AEN attribute data \n");
+		pmcraid_err("failed to copy AEN attribute data\n");
 		nlmsg_free(skb);
 		return -EINVAL;
 	}
@@ -1350,13 +1518,57 @@
 	 * value.
 	 */
 	if (result)
-		pmcraid_info("failed to send %s event message %x!\n",
-			type == PMCRAID_HCAM_CODE_LOG_DATA ? "LDN" : "CCN",
-			result);
+		pmcraid_info("error (%x) sending aen event message\n", result);
 	return result;
 }
 
 /**
+ * pmcraid_notify_ccn - notifies about CCN event msg to user space
+ * @pinstance: pointer adapter instance structure
+ *
+ * Return value:
+ *	0 if success, error value in case of any failure
+ */
+static int pmcraid_notify_ccn(struct pmcraid_instance *pinstance)
+{
+	return pmcraid_notify_aen(pinstance,
+				pinstance->ccn.msg,
+				pinstance->ccn.hcam->data_len +
+				sizeof(struct pmcraid_hcam_hdr));
+}
+
+/**
+ * pmcraid_notify_ldn - notifies about CCN event msg to user space
+ * @pinstance: pointer adapter instance structure
+ *
+ * Return value:
+ *	0 if success, error value in case of any failure
+ */
+static int pmcraid_notify_ldn(struct pmcraid_instance *pinstance)
+{
+	return pmcraid_notify_aen(pinstance,
+				pinstance->ldn.msg,
+				pinstance->ldn.hcam->data_len +
+				sizeof(struct pmcraid_hcam_hdr));
+}
+
+/**
+ * pmcraid_notify_ioastate - sends IOA state event msg to user space
+ * @pinstance: pointer adapter instance structure
+ * @evt: controller state event to be sent
+ *
+ * Return value:
+ *	0 if success, error value in case of any failure
+ */
+static void pmcraid_notify_ioastate(struct pmcraid_instance *pinstance, u32 evt)
+{
+	pinstance->scn.ioa_state = evt;
+	pmcraid_notify_aen(pinstance,
+			  &pinstance->scn.msg,
+			  sizeof(u32));
+}
+
+/**
  * pmcraid_handle_config_change - Handle a config change from the adapter
  * @pinstance: pointer to per adapter instance structure
  *
@@ -1375,10 +1587,12 @@
 	unsigned long host_lock_flags;
 	u32 new_entry = 1;
 	u32 hidden_entry = 0;
+	u16 fw_version;
 	int rc;
 
 	ccn_hcam = (struct pmcraid_hcam_ccn *)pinstance->ccn.hcam;
 	cfg_entry = &ccn_hcam->cfg_entry;
+	fw_version = be16_to_cpu(pinstance->inq_data->fw_version);
 
 	pmcraid_info
 		("CCN(%x): %x type: %x lost: %x flags: %x res: %x:%x:%x:%x\n",
@@ -1391,7 +1605,10 @@
 		 RES_IS_VSET(*cfg_entry) ? PMCRAID_VSET_BUS_ID :
 		 (RES_IS_GSCSI(*cfg_entry) ? PMCRAID_PHYS_BUS_ID :
 			RES_BUS(cfg_entry->resource_address)),
-		 RES_IS_VSET(*cfg_entry) ? cfg_entry->unique_flags1 :
+		 RES_IS_VSET(*cfg_entry) ?
+			(fw_version <= PMCRAID_FW_VERSION_1 ?
+				cfg_entry->unique_flags1 :
+					cfg_entry->array_id & 0xFF) :
 			RES_TARGET(cfg_entry->resource_address),
 		 RES_LUN(cfg_entry->resource_address));
 
@@ -1415,11 +1632,16 @@
 	 */
 	if (pinstance->ccn.hcam->notification_type ==
 	    NOTIFICATION_TYPE_ENTRY_CHANGED &&
-	    cfg_entry->resource_type == RES_TYPE_VSET &&
-	    cfg_entry->unique_flags1 & 0x80) {
-		hidden_entry = 1;
-	} else if (!pmcraid_expose_resource(cfg_entry))
+	    cfg_entry->resource_type == RES_TYPE_VSET) {
+
+		if (fw_version <= PMCRAID_FW_VERSION_1)
+			hidden_entry = (cfg_entry->unique_flags1 & 0x80) != 0;
+		else
+			hidden_entry = (cfg_entry->unique_flags1 & 0x80) != 0;
+
+	} else if (!pmcraid_expose_resource(fw_version, cfg_entry)) {
 		goto out_notify_apps;
+	}
 
 	spin_lock_irqsave(&pinstance->resource_lock, lock_flags);
 	list_for_each_entry(res, &pinstance->used_res_q, queue) {
@@ -1466,13 +1688,15 @@
 		list_add_tail(&res->queue, &pinstance->used_res_q);
 	}
 
-	memcpy(&res->cfg_entry, cfg_entry,
-		sizeof(struct pmcraid_config_table_entry));
+	memcpy(&res->cfg_entry, cfg_entry, pinstance->config_table_entry_size);
 
 	if (pinstance->ccn.hcam->notification_type ==
 	    NOTIFICATION_TYPE_ENTRY_DELETED || hidden_entry) {
 		if (res->scsi_dev) {
-			res->cfg_entry.unique_flags1 &= 0x7F;
+			if (fw_version <= PMCRAID_FW_VERSION_1)
+				res->cfg_entry.unique_flags1 &= 0x7F;
+			else
+				res->cfg_entry.array_id &= 0xFF;
 			res->change_detected = RES_CHANGE_DEL;
 			res->cfg_entry.resource_handle =
 				PMCRAID_INVALID_RES_HANDLE;
@@ -1491,7 +1715,7 @@
 
 	/* Notify configuration changes to registered applications.*/
 	if (!pmcraid_disable_aen)
-		pmcraid_notify_aen(pinstance, PMCRAID_HCAM_CODE_CONFIG_CHANGE);
+		pmcraid_notify_ccn(pinstance);
 
 	cmd = pmcraid_init_hcam(pinstance, PMCRAID_HCAM_CODE_CONFIG_CHANGE);
 	if (cmd)
@@ -1528,7 +1752,7 @@
 		return;
 
 	/* log the error string */
-	pmcraid_err("cmd [%d] for resource %x failed with %x(%s)\n",
+	pmcraid_err("cmd [%x] for resource %x failed with %x(%s)\n",
 		cmd->ioa_cb->ioarcb.cdb[0],
 		cmd->ioa_cb->ioarcb.resource_handle,
 		le32_to_cpu(ioasc), error_info->error_string);
@@ -1663,7 +1887,7 @@
 	}
 	/* send netlink message for HCAM notification if enabled */
 	if (!pmcraid_disable_aen)
-		pmcraid_notify_aen(pinstance, PMCRAID_HCAM_CODE_LOG_DATA);
+		pmcraid_notify_ldn(pinstance);
 
 	cmd = pmcraid_init_hcam(pinstance, PMCRAID_HCAM_CODE_LOG_DATA);
 	if (cmd)
@@ -1701,10 +1925,13 @@
 	atomic_set(&pinstance->ldn.ignore, 1);
 
 	/* If adapter reset was forced as part of runtime reset sequence,
-	 * start the reset sequence.
+	 * start the reset sequence. Reset will be triggered even in case
+	 * IOA unit_check.
 	 */
-	if (pinstance->force_ioa_reset && !pinstance->ioa_bringdown) {
+	if ((pinstance->force_ioa_reset && !pinstance->ioa_bringdown) ||
+	     pinstance->ioa_unit_check) {
 		pinstance->force_ioa_reset = 0;
+		pinstance->ioa_unit_check = 0;
 		pinstance->ioa_state = IOA_STATE_IN_RESET_ALERT;
 		pmcraid_reset_alert(cmd);
 		return;
@@ -1735,10 +1962,13 @@
 	pmcraid_enable_interrupts(pinstance, PMCRAID_PCI_INTERRUPTS);
 
 	if (intrs & INTRS_TRANSITION_TO_OPERATIONAL) {
-		iowrite32(INTRS_TRANSITION_TO_OPERATIONAL,
-			pinstance->int_regs.ioa_host_interrupt_mask_reg);
-		iowrite32(INTRS_TRANSITION_TO_OPERATIONAL,
-			pinstance->int_regs.ioa_host_interrupt_clr_reg);
+		if (!pinstance->interrupt_mode) {
+			iowrite32(INTRS_TRANSITION_TO_OPERATIONAL,
+				pinstance->int_regs.
+				ioa_host_interrupt_mask_reg);
+			iowrite32(INTRS_TRANSITION_TO_OPERATIONAL,
+				pinstance->int_regs.ioa_host_interrupt_clr_reg);
+		}
 		return 1;
 	} else {
 		return 0;
@@ -1777,8 +2007,19 @@
 	doorbell = DOORBELL_RUNTIME_RESET |
 		   DOORBELL_ENABLE_DESTRUCTIVE_DIAGS;
 
+	/* Since we do RESET_ALERT and Start BIST we have to again write
+	 * MSIX Doorbell to indicate the interrupt mode
+	 */
+	if (pinstance->interrupt_mode) {
+		iowrite32(DOORBELL_INTR_MODE_MSIX,
+			  pinstance->int_regs.host_ioa_interrupt_reg);
+		ioread32(pinstance->int_regs.host_ioa_interrupt_reg);
+	}
+
 	iowrite32(doorbell, pinstance->int_regs.host_ioa_interrupt_reg);
+	ioread32(pinstance->int_regs.host_ioa_interrupt_reg),
 	int_reg = ioread32(pinstance->int_regs.ioa_host_interrupt_reg);
+
 	pmcraid_info("Waiting for IOA to become operational %x:%x\n",
 		     ioread32(pinstance->int_regs.host_ioa_interrupt_reg),
 		     int_reg);
@@ -1854,7 +2095,8 @@
 		} else if (cmd->cmd_done == pmcraid_internal_done ||
 			   cmd->cmd_done == pmcraid_erp_done) {
 			cmd->cmd_done(cmd);
-		} else if (cmd->cmd_done != pmcraid_ioa_reset) {
+		} else if (cmd->cmd_done != pmcraid_ioa_reset &&
+			   cmd->cmd_done != pmcraid_ioa_shutdown_done) {
 			pmcraid_return_cmd(cmd);
 		}
 
@@ -1964,6 +2206,13 @@
 			pinstance->ioa_reset_attempts = 0;
 			pmcraid_err("IOA didn't respond marking it as dead\n");
 			pinstance->ioa_state = IOA_STATE_DEAD;
+
+			if (pinstance->ioa_bringdown)
+				pmcraid_notify_ioastate(pinstance,
+					PMC_DEVICE_EVENT_SHUTDOWN_FAILED);
+			else
+				pmcraid_notify_ioastate(pinstance,
+						PMC_DEVICE_EVENT_RESET_FAILED);
 			reset_complete = 1;
 			break;
 		}
@@ -1971,7 +2220,6 @@
 		/* Once either bist or pci reset is done, restore PCI config
 		 * space. If this fails, proceed with hard reset again
 		 */
-
 		if (pci_restore_state(pinstance->pdev)) {
 			pmcraid_info("config-space error resetting again\n");
 			pinstance->ioa_state = IOA_STATE_IN_RESET_ALERT;
@@ -2002,6 +2250,8 @@
 			pinstance->ioa_shutdown_type = SHUTDOWN_NONE;
 			pinstance->ioa_bringdown = 0;
 			pinstance->ioa_state = IOA_STATE_UNKNOWN;
+			pmcraid_notify_ioastate(pinstance,
+					PMC_DEVICE_EVENT_SHUTDOWN_SUCCESS);
 			reset_complete = 1;
 		} else {
 			/* bring-up IOA, so proceed with soft reset
@@ -2051,6 +2301,8 @@
 		 */
 		if (pinstance->ioa_shutdown_type == SHUTDOWN_NONE &&
 		    pinstance->force_ioa_reset == 0) {
+			pmcraid_notify_ioastate(pinstance,
+						PMC_DEVICE_EVENT_RESET_SUCCESS);
 			reset_complete = 1;
 		} else {
 			if (pinstance->ioa_shutdown_type != SHUTDOWN_NONE)
@@ -2116,6 +2368,8 @@
 		pinstance->ioa_shutdown_type = SHUTDOWN_NONE;
 		pinstance->reset_cmd = cmd;
 		pinstance->force_ioa_reset = 1;
+		pmcraid_notify_ioastate(pinstance,
+					PMC_DEVICE_EVENT_RESET_START);
 		pmcraid_ioa_reset(cmd);
 	}
 }
@@ -2191,7 +2445,7 @@
 		wait_event(pinstance->reset_wait_q,
 			   !pinstance->ioa_reset_in_progress);
 
-		pmcraid_info("reset_reload: reset is complete !! \n");
+		pmcraid_info("reset_reload: reset is complete !!\n");
 		scsi_unblock_requests(pinstance->host);
 		if (pinstance->ioa_state == target_state)
 			reset = 0;
@@ -2225,6 +2479,8 @@
  */
 static int pmcraid_reset_bringup(struct pmcraid_instance *pinstance)
 {
+	pmcraid_notify_ioastate(pinstance, PMC_DEVICE_EVENT_RESET_START);
+
 	return pmcraid_reset_reload(pinstance,
 				    SHUTDOWN_NONE,
 				    IOA_STATE_OPERATIONAL);
@@ -2704,7 +2960,7 @@
 
 	pmcraid_info("command (%d) CDB[0] = %x for %x\n",
 		le32_to_cpu(cancel_cmd->ioa_cb->ioarcb.response_handle) >> 2,
-		cmd->ioa_cb->ioarcb.cdb[0],
+		cancel_cmd->ioa_cb->ioarcb.cdb[0],
 		le32_to_cpu(cancel_cmd->ioa_cb->ioarcb.resource_handle));
 
 	pmcraid_send_cmd(cancel_cmd,
@@ -2729,8 +2985,8 @@
 	u32 ioasc;
 
 	wait_for_completion(&cancel_cmd->wait_for_completion);
-	res = cancel_cmd->u.res;
-	cancel_cmd->u.res = NULL;
+	res = cancel_cmd->res;
+	cancel_cmd->res = NULL;
 	ioasc = le32_to_cpu(cancel_cmd->ioa_cb->ioasa.ioasc);
 
 	/* If the abort task is not timed out we will get a Good completion
@@ -2823,7 +3079,7 @@
 			       host_lock_flags);
 
 	if (cancel_cmd) {
-		cancel_cmd->u.res = cmd->scsi_cmd->device->hostdata;
+		cancel_cmd->res = cmd->scsi_cmd->device->hostdata;
 		rc = pmcraid_abort_complete(cancel_cmd);
 	}
 
@@ -2842,7 +3098,7 @@
  * takes care by locking/unlocking host_lock.
  *
  * Return value
- * 	SUCCESS or FAILED
+ *	SUCCESS or FAILED
  */
 static int pmcraid_eh_device_reset_handler(struct scsi_cmnd *scmd)
 {
@@ -2879,7 +3135,7 @@
  * Initiates adapter reset to bring it up to operational state
  *
  * Return value
- * 	SUCCESS or FAILED
+ *	SUCCESS or FAILED
  */
 static int pmcraid_eh_host_reset_handler(struct scsi_cmnd *scmd)
 {
@@ -2991,7 +3247,7 @@
  * to firmware. This builds ioadl descriptors and sets up ioarcb fields.
  *
  * Return value:
- * 	0 on success or -1 on failure
+ *	0 on success or -1 on failure
  */
 static int pmcraid_build_ioadl(
 	struct pmcraid_instance *pinstance,
@@ -3049,7 +3305,7 @@
  * Free a DMA'able memory previously allocated with pmcraid_alloc_sglist
  *
  * Return value:
- * 	none
+ *	none
  */
 static void pmcraid_free_sglist(struct pmcraid_sglist *sglist)
 {
@@ -3070,7 +3326,7 @@
  * list.
  *
  * Return value
- * 	pointer to sglist / NULL on failure
+ *	pointer to sglist / NULL on failure
  */
 static struct pmcraid_sglist *pmcraid_alloc_sglist(int buflen)
 {
@@ -3224,11 +3480,12 @@
 	struct pmcraid_resource_entry *res;
 	struct pmcraid_ioarcb *ioarcb;
 	struct pmcraid_cmd *cmd;
+	u32 fw_version;
 	int rc = 0;
 
 	pinstance =
 		(struct pmcraid_instance *)scsi_cmd->device->host->hostdata;
-
+	fw_version = be16_to_cpu(pinstance->inq_data->fw_version);
 	scsi_cmd->scsi_done = done;
 	res = scsi_cmd->device->hostdata;
 	scsi_cmd->result = (DID_OK << 16);
@@ -3247,6 +3504,15 @@
 	if (pinstance->ioa_reset_in_progress)
 		return SCSI_MLQUEUE_HOST_BUSY;
 
+	/* Firmware doesn't support SYNCHRONIZE_CACHE command (0x35), complete
+	 * the command here itself with success return
+	 */
+	if (scsi_cmd->cmnd[0] == SYNCHRONIZE_CACHE) {
+		pmcraid_info("SYNC_CACHE(0x35), completing in driver itself\n");
+		scsi_cmd->scsi_done(scsi_cmd);
+		return 0;
+	}
+
 	/* initialize the command and IOARCB to be sent to IOA */
 	cmd = pmcraid_get_free_cmd(pinstance);
 
@@ -3261,6 +3527,13 @@
 	ioarcb->resource_handle = res->cfg_entry.resource_handle;
 	ioarcb->request_type = REQ_TYPE_SCSI;
 
+	/* set hrrq number where the IOA should respond to. Note that all cmds
+	 * generated internally uses hrrq_id 0, exception to this is the cmd
+	 * block of scsi_cmd which is re-used (e.g. cancel/abort), which uses
+	 * hrrq_id assigned here in queuecommand
+	 */
+	ioarcb->hrrq_id = atomic_add_return(1, &(pinstance->last_message_id)) %
+			  pinstance->num_hrrq;
 	cmd->cmd_done = pmcraid_io_done;
 
 	if (RES_IS_GSCSI(res->cfg_entry) || RES_IS_VSET(res->cfg_entry)) {
@@ -3287,7 +3560,9 @@
 		     RES_IS_VSET(res->cfg_entry) ? PMCRAID_VSET_BUS_ID :
 			PMCRAID_PHYS_BUS_ID,
 		     RES_IS_VSET(res->cfg_entry) ?
-			res->cfg_entry.unique_flags1 :
+			(fw_version <= PMCRAID_FW_VERSION_1 ?
+				res->cfg_entry.unique_flags1 :
+					res->cfg_entry.array_id & 0xFF) :
 			RES_TARGET(res->cfg_entry.resource_address),
 		     RES_LUN(res->cfg_entry.resource_address));
 
@@ -3465,6 +3740,7 @@
 	unsigned long request_buffer;
 	unsigned long request_offset;
 	unsigned long lock_flags;
+	u32 ioasc;
 	int request_size;
 	int buffer_size;
 	u8 access, direction;
@@ -3566,6 +3842,14 @@
 			buffer->ioarcb.add_cmd_param_length);
 	}
 
+	/* set hrrq number where the IOA should respond to. Note that all cmds
+	 * generated internally uses hrrq_id 0, exception to this is the cmd
+	 * block of scsi_cmd which is re-used (e.g. cancel/abort), which uses
+	 * hrrq_id assigned here in queuecommand
+	 */
+	ioarcb->hrrq_id = atomic_add_return(1, &(pinstance->last_message_id)) %
+			  pinstance->num_hrrq;
+
 	if (request_size) {
 		rc = pmcraid_build_passthrough_ioadls(cmd,
 						      request_size,
@@ -3606,6 +3890,14 @@
 	_pmcraid_fire_command(cmd);
 	spin_unlock_irqrestore(pinstance->host->host_lock, lock_flags);
 
+	/* NOTE ! Remove the below line once abort_task is implemented
+	 * in firmware. This line disables ioctl command timeout handling logic
+	 * similar to IO command timeout handling, making ioctl commands to wait
+	 * until the command completion regardless of timeout value specified in
+	 * ioarcb
+	 */
+	buffer->ioarcb.cmd_timeout = 0;
+
 	/* If command timeout is specified put caller to wait till that time,
 	 * otherwise it would be blocking wait. If command gets timed out, it
 	 * will be aborted.
@@ -3620,25 +3912,47 @@
 			le32_to_cpu(cmd->ioa_cb->ioarcb.response_handle >> 2),
 			cmd->ioa_cb->ioarcb.cdb[0]);
 
-		rc = -ETIMEDOUT;
 		spin_lock_irqsave(pinstance->host->host_lock, lock_flags);
 		cancel_cmd = pmcraid_abort_cmd(cmd);
 		spin_unlock_irqrestore(pinstance->host->host_lock, lock_flags);
 
 		if (cancel_cmd) {
 			wait_for_completion(&cancel_cmd->wait_for_completion);
+			ioasc = cancel_cmd->ioa_cb->ioasa.ioasc;
 			pmcraid_return_cmd(cancel_cmd);
+
+			/* if abort task couldn't find the command i.e it got
+			 * completed prior to aborting, return good completion.
+			 * if command got aborted succesfully or there was IOA
+			 * reset due to abort task itself getting timedout then
+			 * return -ETIMEDOUT
+			 */
+			if (ioasc == PMCRAID_IOASC_IOA_WAS_RESET ||
+			    PMCRAID_IOASC_SENSE_KEY(ioasc) == 0x00) {
+				if (ioasc != PMCRAID_IOASC_GC_IOARCB_NOTFOUND)
+					rc = -ETIMEDOUT;
+				goto out_handle_response;
+			}
 		}
 
-		goto out_free_sglist;
+		/* no command block for abort task or abort task failed to abort
+		 * the IOARCB, then wait for 150 more seconds and initiate reset
+		 * sequence after timeout
+		 */
+		if (!wait_for_completion_timeout(
+			&cmd->wait_for_completion,
+			msecs_to_jiffies(150 * 1000))) {
+			pmcraid_reset_bringup(cmd->drv_inst);
+			rc = -ETIMEDOUT;
+		}
 	}
 
+out_handle_response:
 	/* If the command failed for any reason, copy entire IOASA buffer and
 	 * return IOCTL success. If copying IOASA to user-buffer fails, return
 	 * EFAULT
 	 */
-	if (le32_to_cpu(cmd->ioa_cb->ioasa.ioasc)) {
-
+	if (PMCRAID_IOASC_SENSE_KEY(le32_to_cpu(cmd->ioa_cb->ioasa.ioasc))) {
 		void *ioasa =
 		    (void *)(arg +
 		    offsetof(struct pmcraid_passthrough_ioctl_buffer, ioasa));
@@ -3651,6 +3965,7 @@
 			rc = -EFAULT;
 		}
 	}
+
 	/* If the data transfer was from device, copy the data onto user
 	 * buffers
 	 */
@@ -3699,7 +4014,7 @@
 	int rc = -ENOSYS;
 
 	if (!access_ok(VERIFY_READ, user_buffer, _IOC_SIZE(cmd))) {
-		pmcraid_err("ioctl_driver: access fault in request buffer \n");
+		pmcraid_err("ioctl_driver: access fault in request buffer\n");
 		return -EFAULT;
 	}
 
@@ -4011,36 +4326,77 @@
 	.proc_name = PMCRAID_DRIVER_NAME
 };
 
-/**
- * pmcraid_isr_common - Common interrupt handler routine
- *
- * @pinstance: pointer to adapter instance
- * @intrs: active interrupts (contents of ioa_host_interrupt register)
- * @hrrq_id: Host RRQ index
+/*
+ * pmcraid_isr_msix - implements MSI-X interrupt handling routine
+ * @irq: interrupt vector number
+ * @dev_id: pointer hrrq_vector
  *
  * Return Value
- *	none
+ *	 IRQ_HANDLED if interrupt is handled or IRQ_NONE if ignored
  */
-static void pmcraid_isr_common(
-	struct pmcraid_instance *pinstance,
-	u32 intrs,
-	int hrrq_id
-)
+
+static irqreturn_t pmcraid_isr_msix(int irq, void *dev_id)
 {
-	u32 intrs_clear =
-		(intrs & INTRS_CRITICAL_OP_IN_PROGRESS) ? intrs
-							: INTRS_HRRQ_VALID;
-	iowrite32(intrs_clear,
-		  pinstance->int_regs.ioa_host_interrupt_clr_reg);
-	intrs = ioread32(pinstance->int_regs.ioa_host_interrupt_reg);
+	struct pmcraid_isr_param *hrrq_vector;
+	struct pmcraid_instance *pinstance;
+	unsigned long lock_flags;
+	u32 intrs_val;
+	int hrrq_id;
+
+	hrrq_vector = (struct pmcraid_isr_param *)dev_id;
+	hrrq_id = hrrq_vector->hrrq_id;
+	pinstance = hrrq_vector->drv_inst;
+
+	if (!hrrq_id) {
+		/* Read the interrupt */
+		intrs_val = pmcraid_read_interrupts(pinstance);
+		if (intrs_val &&
+			((ioread32(pinstance->int_regs.host_ioa_interrupt_reg)
+			& DOORBELL_INTR_MSIX_CLR) == 0)) {
+			/* Any error interrupts including unit_check,
+			 * initiate IOA reset.In case of unit check indicate
+			 * to reset_sequence that IOA unit checked and prepare
+			 * for a dump during reset sequence
+			 */
+			if (intrs_val & PMCRAID_ERROR_INTERRUPTS) {
+				if (intrs_val & INTRS_IOA_UNIT_CHECK)
+					pinstance->ioa_unit_check = 1;
+
+				pmcraid_err("ISR: error interrupts: %x \
+					initiating reset\n", intrs_val);
+				spin_lock_irqsave(pinstance->host->host_lock,
+					lock_flags);
+				pmcraid_initiate_reset(pinstance);
+				spin_unlock_irqrestore(
+					pinstance->host->host_lock,
+					lock_flags);
+			}
+			/* If interrupt was as part of the ioa initialization,
+			 * clear it. Delete the timer and wakeup the
+			 * reset engine to proceed with reset sequence
+			 */
+			if (intrs_val & INTRS_TRANSITION_TO_OPERATIONAL)
+				pmcraid_clr_trans_op(pinstance);
+
+			/* Clear the interrupt register by writing
+			 * to host to ioa doorbell. Once done
+			 * FW will clear the interrupt.
+			 */
+			iowrite32(DOORBELL_INTR_MSIX_CLR,
+				pinstance->int_regs.host_ioa_interrupt_reg);
+			ioread32(pinstance->int_regs.host_ioa_interrupt_reg);
+
 
-	/* hrrq valid bit was set, schedule tasklet to handle the response */
-	if (intrs_clear == INTRS_HRRQ_VALID)
-		tasklet_schedule(&(pinstance->isr_tasklet[hrrq_id]));
+		}
+	}
+
+	tasklet_schedule(&(pinstance->isr_tasklet[hrrq_id]));
+
+	return IRQ_HANDLED;
 }
 
 /**
- * pmcraid_isr  - implements interrupt handling routine
+ * pmcraid_isr  - implements legacy interrupt handling routine
  *
  * @irq: interrupt vector number
  * @dev_id: pointer hrrq_vector
@@ -4052,8 +4408,9 @@
 {
 	struct pmcraid_isr_param *hrrq_vector;
 	struct pmcraid_instance *pinstance;
-	unsigned long lock_flags;
 	u32 intrs;
+	unsigned long lock_flags;
+	int hrrq_id = 0;
 
 	/* In case of legacy interrupt mode where interrupts are shared across
 	 * isrs, it may be possible that the current interrupt is not from IOA
@@ -4062,21 +4419,13 @@
 		printk(KERN_INFO "%s(): NULL host pointer\n", __func__);
 		return IRQ_NONE;
 	}
-
 	hrrq_vector = (struct pmcraid_isr_param *)dev_id;
 	pinstance = hrrq_vector->drv_inst;
 
-	/* Acquire the lock (currently host_lock) while processing interrupts.
-	 * This interval is small as most of the response processing is done by
-	 * tasklet without the lock.
-	 */
-	spin_lock_irqsave(pinstance->host->host_lock, lock_flags);
 	intrs = pmcraid_read_interrupts(pinstance);
 
-	if (unlikely((intrs & PMCRAID_PCI_INTERRUPTS) == 0)) {
-		spin_unlock_irqrestore(pinstance->host->host_lock, lock_flags);
+	if (unlikely((intrs & PMCRAID_PCI_INTERRUPTS) == 0))
 		return IRQ_NONE;
-	}
 
 	/* Any error interrupts including unit_check, initiate IOA reset.
 	 * In case of unit check indicate to reset_sequence that IOA unit
@@ -4091,13 +4440,28 @@
 			  pinstance->int_regs.ioa_host_interrupt_clr_reg);
 		pmcraid_err("ISR: error interrupts: %x initiating reset\n",
 			    intrs);
-		intrs = ioread32(pinstance->int_regs.ioa_host_interrupt_reg);
+		intrs = ioread32(
+				pinstance->int_regs.ioa_host_interrupt_clr_reg);
+		spin_lock_irqsave(pinstance->host->host_lock, lock_flags);
 		pmcraid_initiate_reset(pinstance);
+		spin_unlock_irqrestore(pinstance->host->host_lock, lock_flags);
 	} else {
-		pmcraid_isr_common(pinstance, intrs, hrrq_vector->hrrq_id);
-	}
+		/* If interrupt was as part of the ioa initialization,
+		 * clear. Delete the timer and wakeup the
+		 * reset engine to proceed with reset sequence
+		 */
+		if (intrs & INTRS_TRANSITION_TO_OPERATIONAL) {
+			pmcraid_clr_trans_op(pinstance);
+		} else {
+			iowrite32(intrs,
+				pinstance->int_regs.ioa_host_interrupt_clr_reg);
+			ioread32(
+				pinstance->int_regs.ioa_host_interrupt_clr_reg);
 
-	spin_unlock_irqrestore(pinstance->host->host_lock, lock_flags);
+			tasklet_schedule(
+					&(pinstance->isr_tasklet[hrrq_id]));
+		}
+	}
 
 	return IRQ_HANDLED;
 }
@@ -4120,6 +4484,7 @@
 	struct scsi_device *sdev;
 	unsigned long lock_flags;
 	unsigned long host_lock_flags;
+	u16 fw_version;
 	u8 bus, target, lun;
 
 	pinstance = container_of(workp, struct pmcraid_instance, worker_q);
@@ -4127,6 +4492,8 @@
 	if (!atomic_read(&pinstance->expose_resources))
 		return;
 
+	fw_version = be16_to_cpu(pinstance->inq_data->fw_version);
+
 	spin_lock_irqsave(&pinstance->resource_lock, lock_flags);
 	list_for_each_entry_safe(res, temp, &pinstance->used_res_q, queue) {
 
@@ -4166,12 +4533,16 @@
 
 		if (res->change_detected == RES_CHANGE_ADD) {
 
-			if (!pmcraid_expose_resource(&res->cfg_entry))
+			if (!pmcraid_expose_resource(fw_version,
+						     &res->cfg_entry))
 				continue;
 
 			if (RES_IS_VSET(res->cfg_entry)) {
 				bus = PMCRAID_VSET_BUS_ID;
-				target = res->cfg_entry.unique_flags1;
+				if (fw_version <= PMCRAID_FW_VERSION_1)
+					target = res->cfg_entry.unique_flags1;
+				else
+					target = res->cfg_entry.array_id & 0xFF;
 				lun = PMCRAID_VSET_LUN_ID;
 			} else {
 				bus = PMCRAID_PHYS_BUS_ID;
@@ -4201,7 +4572,7 @@
  * Return Value
  *	None
  */
-void pmcraid_tasklet_function(unsigned long instance)
+static void pmcraid_tasklet_function(unsigned long instance)
 {
 	struct pmcraid_isr_param *hrrq_vector;
 	struct pmcraid_instance *pinstance;
@@ -4210,35 +4581,12 @@
 	unsigned long host_lock_flags;
 	spinlock_t *lockp; /* hrrq buffer lock */
 	int id;
-	u32 intrs;
 	__le32 resp;
 
 	hrrq_vector = (struct pmcraid_isr_param *)instance;
 	pinstance = hrrq_vector->drv_inst;
 	id = hrrq_vector->hrrq_id;
 	lockp = &(pinstance->hrrq_lock[id]);
-	intrs = pmcraid_read_interrupts(pinstance);
-
-	/* If interrupts was as part of the ioa initialization, clear and mask
-	 * it. Delete the timer and wakeup the reset engine to proceed with
-	 * reset sequence
-	 */
-	if (intrs & INTRS_TRANSITION_TO_OPERATIONAL) {
-		iowrite32(INTRS_TRANSITION_TO_OPERATIONAL,
-			pinstance->int_regs.ioa_host_interrupt_mask_reg);
-		iowrite32(INTRS_TRANSITION_TO_OPERATIONAL,
-			pinstance->int_regs.ioa_host_interrupt_clr_reg);
-
-		if (pinstance->reset_cmd != NULL) {
-			del_timer(&pinstance->reset_cmd->timer);
-			spin_lock_irqsave(pinstance->host->host_lock,
-					  host_lock_flags);
-			pinstance->reset_cmd->cmd_done(pinstance->reset_cmd);
-			spin_unlock_irqrestore(pinstance->host->host_lock,
-					       host_lock_flags);
-		}
-		return;
-	}
 
 	/* loop through each of the commands responded by IOA. Each HRRQ buf is
 	 * protected by its own lock. Traversals must be done within this lock
@@ -4256,27 +4604,6 @@
 		int cmd_index = resp >> 2;
 		struct pmcraid_cmd *cmd = NULL;
 
-		if (cmd_index < PMCRAID_MAX_CMD) {
-			cmd = pinstance->cmd_list[cmd_index];
-		} else {
-			/* In case of invalid response handle, initiate IOA
-			 * reset sequence.
-			 */
-			spin_unlock_irqrestore(lockp, hrrq_lock_flags);
-
-			pmcraid_err("Invalid response %d initiating reset\n",
-				    cmd_index);
-
-			spin_lock_irqsave(pinstance->host->host_lock,
-					  host_lock_flags);
-			pmcraid_initiate_reset(pinstance);
-			spin_unlock_irqrestore(pinstance->host->host_lock,
-					       host_lock_flags);
-
-			spin_lock_irqsave(lockp, hrrq_lock_flags);
-			break;
-		}
-
 		if (pinstance->hrrq_curr[id] < pinstance->hrrq_end[id]) {
 			pinstance->hrrq_curr[id]++;
 		} else {
@@ -4284,6 +4611,14 @@
 			pinstance->host_toggle_bit[id] ^= 1u;
 		}
 
+		if (cmd_index >= PMCRAID_MAX_CMD) {
+			/* In case of invalid response handle, log message */
+			pmcraid_err("Invalid response handle %d\n", cmd_index);
+			resp = le32_to_cpu(*(pinstance->hrrq_curr[id]));
+			continue;
+		}
+
+		cmd = pinstance->cmd_list[cmd_index];
 		spin_unlock_irqrestore(lockp, hrrq_lock_flags);
 
 		spin_lock_irqsave(&pinstance->pending_pool_lock,
@@ -4324,7 +4659,16 @@
 static
 void pmcraid_unregister_interrupt_handler(struct pmcraid_instance *pinstance)
 {
-	free_irq(pinstance->pdev->irq, &(pinstance->hrrq_vector[0]));
+	int i;
+
+	for (i = 0; i < pinstance->num_hrrq; i++)
+		free_irq(pinstance->hrrq_vector[i].vector,
+			 &(pinstance->hrrq_vector[i]));
+
+	if (pinstance->interrupt_mode) {
+		pci_disable_msix(pinstance->pdev);
+		pinstance->interrupt_mode = 0;
+	}
 }
 
 /**
@@ -4337,14 +4681,70 @@
 static int
 pmcraid_register_interrupt_handler(struct pmcraid_instance *pinstance)
 {
+	int rc;
 	struct pci_dev *pdev = pinstance->pdev;
 
+	if (pci_find_capability(pdev, PCI_CAP_ID_MSIX)) {
+		int num_hrrq = PMCRAID_NUM_MSIX_VECTORS;
+		struct msix_entry entries[PMCRAID_NUM_MSIX_VECTORS];
+		int i;
+		for (i = 0; i < PMCRAID_NUM_MSIX_VECTORS; i++)
+			entries[i].entry = i;
+
+		rc = pci_enable_msix(pdev, entries, num_hrrq);
+		if (rc < 0)
+			goto pmcraid_isr_legacy;
+
+		/* Check how many MSIX vectors are allocated and register
+		 * msi-x handlers for each of them giving appropriate buffer
+		 */
+		if (rc > 0) {
+			num_hrrq = rc;
+			if (pci_enable_msix(pdev, entries, num_hrrq))
+				goto pmcraid_isr_legacy;
+		}
+
+		for (i = 0; i < num_hrrq; i++) {
+			pinstance->hrrq_vector[i].hrrq_id = i;
+			pinstance->hrrq_vector[i].drv_inst = pinstance;
+			pinstance->hrrq_vector[i].vector = entries[i].vector;
+			rc = request_irq(pinstance->hrrq_vector[i].vector,
+					pmcraid_isr_msix, 0,
+					PMCRAID_DRIVER_NAME,
+					&(pinstance->hrrq_vector[i]));
+
+			if (rc) {
+				int j;
+				for (j = 0; j < i; j++)
+					free_irq(entries[j].vector,
+						 &(pinstance->hrrq_vector[j]));
+				pci_disable_msix(pdev);
+				goto pmcraid_isr_legacy;
+			}
+		}
+
+		pinstance->num_hrrq = num_hrrq;
+		pinstance->interrupt_mode = 1;
+		iowrite32(DOORBELL_INTR_MODE_MSIX,
+			  pinstance->int_regs.host_ioa_interrupt_reg);
+		ioread32(pinstance->int_regs.host_ioa_interrupt_reg);
+		goto pmcraid_isr_out;
+	}
+
+pmcraid_isr_legacy:
+	/* If MSI-X registration failed fallback to legacy mode, where
+	 * only one hrrq entry will be used
+	 */
 	pinstance->hrrq_vector[0].hrrq_id = 0;
 	pinstance->hrrq_vector[0].drv_inst = pinstance;
-	pinstance->hrrq_vector[0].vector = 0;
+	pinstance->hrrq_vector[0].vector = pdev->irq;
 	pinstance->num_hrrq = 1;
-	return request_irq(pdev->irq, pmcraid_isr, IRQF_SHARED,
-			   PMCRAID_DRIVER_NAME, &pinstance->hrrq_vector[0]);
+	rc = 0;
+
+	rc = request_irq(pdev->irq, pmcraid_isr, IRQF_SHARED,
+			 PMCRAID_DRIVER_NAME, &pinstance->hrrq_vector[0]);
+pmcraid_isr_out:
+	return rc;
 }
 
 /**
@@ -4516,12 +4916,11 @@
 static int __devinit
 pmcraid_allocate_host_rrqs(struct pmcraid_instance *pinstance)
 {
-	int i;
-	int buf_count = PMCRAID_MAX_CMD / pinstance->num_hrrq;
+	int i, buffer_size;
 
-	for (i = 0; i < pinstance->num_hrrq; i++) {
-		int buffer_size = HRRQ_ENTRY_SIZE * buf_count;
+	buffer_size = HRRQ_ENTRY_SIZE * PMCRAID_MAX_CMD;
 
+	for (i = 0; i < pinstance->num_hrrq; i++) {
 		pinstance->hrrq_start[i] =
 			pci_alloc_consistent(
 					pinstance->pdev,
@@ -4529,7 +4928,8 @@
 					&(pinstance->hrrq_start_bus_addr[i]));
 
 		if (pinstance->hrrq_start[i] == 0) {
-			pmcraid_err("could not allocate host rrq: %d\n", i);
+			pmcraid_err("pci_alloc failed for hrrq vector : %d\n",
+				    i);
 			pmcraid_release_host_rrqs(pinstance, i);
 			return -ENOMEM;
 		}
@@ -4537,7 +4937,7 @@
 		memset(pinstance->hrrq_start[i], 0, buffer_size);
 		pinstance->hrrq_curr[i] = pinstance->hrrq_start[i];
 		pinstance->hrrq_end[i] =
-			pinstance->hrrq_start[i] + buf_count - 1;
+			pinstance->hrrq_start[i] + PMCRAID_MAX_CMD - 1;
 		pinstance->host_toggle_bit[i] = 1;
 		spin_lock_init(&pinstance->hrrq_lock[i]);
 	}
@@ -4557,7 +4957,7 @@
 	if (pinstance->ccn.msg != NULL) {
 		pci_free_consistent(pinstance->pdev,
 				    PMCRAID_AEN_HDR_SIZE +
-				    sizeof(struct pmcraid_hcam_ccn),
+				    sizeof(struct pmcraid_hcam_ccn_ext),
 				    pinstance->ccn.msg,
 				    pinstance->ccn.baddr);
 
@@ -4591,7 +4991,7 @@
 	pinstance->ccn.msg = pci_alloc_consistent(
 					pinstance->pdev,
 					PMCRAID_AEN_HDR_SIZE +
-					sizeof(struct pmcraid_hcam_ccn),
+					sizeof(struct pmcraid_hcam_ccn_ext),
 					&(pinstance->ccn.baddr));
 
 	pinstance->ldn.msg = pci_alloc_consistent(
@@ -4724,6 +5124,32 @@
 }
 
 /**
+ * pmcraid_release_buffers - release per-adapter buffers allocated
+ *
+ * @pinstance: pointer to adapter soft state
+ *
+ * Return Value
+ *	none
+ */
+static void pmcraid_release_buffers(struct pmcraid_instance *pinstance)
+{
+	pmcraid_release_config_buffers(pinstance);
+	pmcraid_release_control_blocks(pinstance, PMCRAID_MAX_CMD);
+	pmcraid_release_cmd_blocks(pinstance, PMCRAID_MAX_CMD);
+	pmcraid_release_host_rrqs(pinstance, pinstance->num_hrrq);
+
+	if (pinstance->inq_data != NULL) {
+		pci_free_consistent(pinstance->pdev,
+				    sizeof(struct pmcraid_inquiry_data),
+				    pinstance->inq_data,
+				    pinstance->inq_data_baddr);
+
+		pinstance->inq_data = NULL;
+		pinstance->inq_data_baddr = 0;
+	}
+}
+
+/**
  * pmcraid_init_buffers - allocates memory and initializes various structures
  * @pinstance: pointer to per adapter instance structure
  *
@@ -4753,20 +5179,32 @@
 	}
 
 	if (pmcraid_allocate_cmd_blocks(pinstance)) {
-		pmcraid_err("couldn't allocate memory for cmd blocks \n");
+		pmcraid_err("couldn't allocate memory for cmd blocks\n");
 		pmcraid_release_config_buffers(pinstance);
 		pmcraid_release_host_rrqs(pinstance, pinstance->num_hrrq);
 		return -ENOMEM;
 	}
 
 	if (pmcraid_allocate_control_blocks(pinstance)) {
-		pmcraid_err("couldn't allocate memory control blocks \n");
+		pmcraid_err("couldn't allocate memory control blocks\n");
 		pmcraid_release_config_buffers(pinstance);
 		pmcraid_release_cmd_blocks(pinstance, PMCRAID_MAX_CMD);
 		pmcraid_release_host_rrqs(pinstance, pinstance->num_hrrq);
 		return -ENOMEM;
 	}
 
+	/* allocate DMAable memory for page D0 INQUIRY buffer */
+	pinstance->inq_data = pci_alloc_consistent(
+					pinstance->pdev,
+					sizeof(struct pmcraid_inquiry_data),
+					&pinstance->inq_data_baddr);
+
+	if (pinstance->inq_data == NULL) {
+		pmcraid_err("couldn't allocate DMA memory for INQUIRY\n");
+		pmcraid_release_buffers(pinstance);
+		return -ENOMEM;
+	}
+
 	/* Initialize all the command blocks and add them to free pool. No
 	 * need to lock (free_pool_lock) as this is done in initialization
 	 * itself
@@ -4785,7 +5223,7 @@
  * pmcraid_reinit_buffers - resets various buffer pointers
  * @pinstance: pointer to adapter instance
  * Return value
- * 	none
+ *	none
  */
 static void pmcraid_reinit_buffers(struct pmcraid_instance *pinstance)
 {
@@ -4836,6 +5274,8 @@
 			mapped_pci_addr + chip_cfg->ioa_host_intr;
 		pint_regs->ioa_host_interrupt_clr_reg =
 			mapped_pci_addr + chip_cfg->ioa_host_intr_clr;
+		pint_regs->ioa_host_msix_interrupt_reg =
+			mapped_pci_addr + chip_cfg->ioa_host_msix_intr;
 		pint_regs->host_ioa_interrupt_reg =
 			mapped_pci_addr + chip_cfg->host_ioa_intr;
 		pint_regs->host_ioa_interrupt_clr_reg =
@@ -4858,6 +5298,7 @@
 	init_waitqueue_head(&pinstance->reset_wait_q);
 
 	atomic_set(&pinstance->outstanding_cmds, 0);
+	atomic_set(&pinstance->last_message_id, 0);
 	atomic_set(&pinstance->expose_resources, 0);
 
 	INIT_LIST_HEAD(&pinstance->free_res_q);
@@ -4883,23 +5324,6 @@
 }
 
 /**
- * pmcraid_release_buffers - release per-adapter buffers allocated
- *
- * @pinstance: pointer to adapter soft state
- *
- * Return Value
- * 	none
- */
-static void pmcraid_release_buffers(struct pmcraid_instance *pinstance)
-{
-	pmcraid_release_config_buffers(pinstance);
-	pmcraid_release_control_blocks(pinstance, PMCRAID_MAX_CMD);
-	pmcraid_release_cmd_blocks(pinstance, PMCRAID_MAX_CMD);
-	pmcraid_release_host_rrqs(pinstance, pinstance->num_hrrq);
-
-}
-
-/**
  * pmcraid_shutdown - shutdown adapter controller.
  * @pdev: pci device struct
  *
@@ -4958,7 +5382,7 @@
 		pmcraid_release_minor(minor);
 	else
 		device_create(pmcraid_class, NULL, MKDEV(pmcraid_major, minor),
-			      NULL, "pmcsas%u", minor);
+			      NULL, "%s%u", PMCRAID_DEVFILE, minor);
 	return error;
 }
 
@@ -5050,7 +5474,6 @@
 	struct pmcraid_instance *pinstance = pci_get_drvdata(pdev);
 	struct Scsi_Host *host = pinstance->host;
 	int rc;
-	int hrrqs;
 
 	pci_set_power_state(pdev, PCI_D0);
 	pci_enable_wake(pdev, PCI_D0, 0);
@@ -5077,8 +5500,8 @@
 		goto disable_device;
 	}
 
+	pmcraid_disable_interrupts(pinstance, ~0);
 	atomic_set(&pinstance->outstanding_cmds, 0);
-	hrrqs = pinstance->num_hrrq;
 	rc = pmcraid_register_interrupt_handler(pinstance);
 
 	if (rc) {
@@ -5100,7 +5523,7 @@
 	 * state.
 	 */
 	if (pmcraid_reset_bringup(pinstance)) {
-		dev_err(&pdev->dev, "couldn't initialize IOA \n");
+		dev_err(&pdev->dev, "couldn't initialize IOA\n");
 		rc = -ENODEV;
 		goto release_tasklets;
 	}
@@ -5108,6 +5531,7 @@
 	return 0;
 
 release_tasklets:
+	pmcraid_disable_interrupts(pinstance, ~0);
 	pmcraid_kill_tasklets(pinstance);
 	pmcraid_unregister_interrupt_handler(pinstance);
 
@@ -5129,7 +5553,7 @@
 
 /**
  * pmcraid_complete_ioa_reset - Called by either timer or tasklet during
- * 	                        completion of the ioa reset
+ *				completion of the ioa reset
  * @cmd: pointer to reset command block
  */
 static void pmcraid_complete_ioa_reset(struct pmcraid_cmd *cmd)
@@ -5204,11 +5628,14 @@
 	struct pmcraid_config_table_entry *cfgte;
 	unsigned long lock_flags;
 	int found, rc, i;
+	u16 fw_version;
 	LIST_HEAD(old_res);
 
 	if (pinstance->cfg_table->flags & MICROCODE_UPDATE_REQUIRED)
 		pmcraid_err("IOA requires microcode download\n");
 
+	fw_version = be16_to_cpu(pinstance->inq_data->fw_version);
+
 	/* resource list is protected by pinstance->resource_lock.
 	 * init_res_table can be called from probe (user-thread) or runtime
 	 * reset (timer/tasklet)
@@ -5219,9 +5646,14 @@
 		list_move_tail(&res->queue, &old_res);
 
 	for (i = 0; i < pinstance->cfg_table->num_entries; i++) {
-		cfgte = &pinstance->cfg_table->entries[i];
+		if (be16_to_cpu(pinstance->inq_data->fw_version) <=
+						PMCRAID_FW_VERSION_1)
+			cfgte = &pinstance->cfg_table->entries[i];
+		else
+			cfgte = (struct pmcraid_config_table_entry *)
+					&pinstance->cfg_table->entries_ext[i];
 
-		if (!pmcraid_expose_resource(cfgte))
+		if (!pmcraid_expose_resource(fw_version, cfgte))
 			continue;
 
 		found = 0;
@@ -5263,10 +5695,12 @@
 		 */
 		if (found) {
 			memcpy(&res->cfg_entry, cfgte,
-				sizeof(struct pmcraid_config_table_entry));
+					pinstance->config_table_entry_size);
 			pmcraid_info("New res type:%x, vset:%x, addr:%x:\n",
 				 res->cfg_entry.resource_type,
-				 res->cfg_entry.unique_flags1,
+				 (fw_version <= PMCRAID_FW_VERSION_1 ?
+					res->cfg_entry.unique_flags1 :
+						res->cfg_entry.array_id & 0xFF),
 				 le32_to_cpu(res->cfg_entry.resource_address));
 		}
 	}
@@ -5306,6 +5740,14 @@
 	struct pmcraid_instance *pinstance = cmd->drv_inst;
 	int cfg_table_size = cpu_to_be32(sizeof(struct pmcraid_config_table));
 
+	if (be16_to_cpu(pinstance->inq_data->fw_version) <=
+					PMCRAID_FW_VERSION_1)
+		pinstance->config_table_entry_size =
+			sizeof(struct pmcraid_config_table_entry);
+	else
+		pinstance->config_table_entry_size =
+			sizeof(struct pmcraid_config_table_entry_ext);
+
 	ioarcb->request_type = REQ_TYPE_IOACMD;
 	ioarcb->resource_handle = cpu_to_le32(PMCRAID_IOA_RES_HANDLE);
 
@@ -5338,7 +5780,7 @@
 
 
 /**
- * pmcraid_probe - PCI probe entry pointer for PMC MaxRaid controller driver
+ * pmcraid_probe - PCI probe entry pointer for PMC MaxRAID controller driver
  * @pdev: pointer to pci device structure
  * @dev_id: pointer to device ids structure
  *
@@ -5485,7 +5927,7 @@
 	 */
 	pmcraid_info("starting IOA initialization sequence\n");
 	if (pmcraid_reset_bringup(pinstance)) {
-		dev_err(&pdev->dev, "couldn't initialize IOA \n");
+		dev_err(&pdev->dev, "couldn't initialize IOA\n");
 		rc = 1;
 		goto out_release_bufs;
 	}
