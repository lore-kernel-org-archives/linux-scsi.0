From: Yokota Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Subject: [PATCH 6/13] nsp32, nsp_cs driver update
Date: Tue, 22 Feb 2005 16:08:00 +0900 (JST)
Message-ID: <20050222.160800.112558316.yokota@netlab.is.tsukuba.ac.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Received: from pixy-gw.netlab.cs.tsukuba.ac.jp ([130.158.83.98]:48654 "HELO
	pixy.netlab.cs.tsukuba.ac.jp") by vger.kernel.org with SMTP
	id S262224AbVBVHIC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Feb 2005 02:08:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--- linux-2.6.10/drivers/scsi/nsp32.h	2005-02-22 08:23:09.000000000 +0900
+++ linux-2.6.10-nsp/drivers/scsi/nsp32.h	2004-11-16 00:26:54.000000000 +0900
@@ -18,36 +18,46 @@
 
 //#define NSP32_DEBUG 9
 
-/*
+/*-----------------------------------------------------
  * VENDOR/DEVICE ID
  */
+/* vendor */
 #define PCI_VENDOR_ID_IODATA  0x10fc
 #define PCI_VENDOR_ID_WORKBIT 0x1145
 
+/* device */
 #define PCI_DEVICE_ID_NINJASCSI_32BI_CBSC_II   0x0005
 #define PCI_DEVICE_ID_NINJASCSI_32BI_KME       0xf007
 #define PCI_DEVICE_ID_NINJASCSI_32BI_WBT       0x8007
-#define PCI_DEVICE_ID_WORKBIT_STANDARD         0xf010
-#define PCI_DEVICE_ID_WORKBIT_DUALEDGE         0xf011
+
+#define PCI_DEVICE_ID_WORKBIT_STANDARD	       0xf010
+#define PCI_DEVICE_ID_WORKBIT_DUALEDGE	       0xf011
+
 #define PCI_DEVICE_ID_NINJASCSI_32BI_LOGITEC   0xf012
 #define PCI_DEVICE_ID_NINJASCSI_32BIB_LOGITEC  0xf013
+
 #define PCI_DEVICE_ID_NINJASCSI_32UDE_MELCO    0xf015
 #define PCI_DEVICE_ID_NINJASCSI_32UDE_MELCO_II 0x8009
 
-/*
- * MODEL
+#define PCI_DEVICE_ID_NINJASCSI_32PCGA_DVD51   0xf020
+
+/*--------------------------------------------------------
+ * MODEL NAME
+ *
+ * note: Model number and model string must be same order.
  */
 enum {
-	MODEL_IODATA        = 0,
-	MODEL_KME           = 1,
-	MODEL_WORKBIT       = 2,
-	MODEL_LOGITEC       = 3,
+	MODEL_IODATA	    = 0,
+	MODEL_KME	    = 1,
+	MODEL_WORKBIT	    = 2,
+	MODEL_LOGITEC	    = 3,
 	MODEL_PCI_WORKBIT   = 4,
 	MODEL_PCI_LOGITEC   = 5,
-	MODEL_PCI_MELCO     = 6,
+	MODEL_PCI_MELCO	    = 6,
+	MODEL_SONY	    = 7,
 };
 
-static char * nsp32_model[] = {
+static const char * const nsp32_model[] = {
 	"I-O DATA CBSC-II CardBus card",
 	"KME SCSI CardBus card",
 	"Workbit duo SCSI CardBus card",
@@ -55,24 +65,28 @@
 	"Workbit / I-O DATA PCI card",
 	"Logitec PCI card with external ROM",
 	"Melco CardBus/PCI card with external ROM",
+	"Sony PCGA-DVD51 CardBus card",
 };
 
 
-/*
- * SCSI Generic Definitions
+/*-----------------------------------
+ * SCSI generic message definitions
  */
 #define EXTENDED_SDTR_LEN	0x03
 
-/* Little Endian */
+/*----------------------------------------
+ * Some MMIO requires little endian data.
+ */
 typedef u32 u32_le;
 typedef u16 u16_le;
 
-/*
+/*-------------
  * MACRO
  */
-#define BIT(x)      (1UL << (x))
+#define ARRAY_OFFSET(type,num) ((int) (((type *) 0) + (num)))
+#define BIT(x)		       (1UL << (x))
 
-/*
+/*-------------------
  * BASIC Definitions
  */
 #ifndef TRUE
@@ -94,27 +108,27 @@
  */
 #define IRQ_CONTROL 0x00	/* BASE+00, W, W */
 #define IRQ_STATUS  0x00	/* BASE+00, W, R */
-# define IRQSTATUS_LATCHED_MSG      BIT(0)
-# define IRQSTATUS_LATCHED_IO       BIT(1)
-# define IRQSTATUS_LATCHED_CD       BIT(2)
+# define IRQSTATUS_LATCHED_MSG	    BIT(0)
+# define IRQSTATUS_LATCHED_IO	    BIT(1)
+# define IRQSTATUS_LATCHED_CD	    BIT(2)
 # define IRQSTATUS_LATCHED_BUS_FREE BIT(3)
 # define IRQSTATUS_RESELECT_OCCUER  BIT(4)
 # define IRQSTATUS_PHASE_CHANGE_IRQ BIT(5)
 # define IRQSTATUS_SCSIRESET_IRQ    BIT(6)
-# define IRQSTATUS_TIMER_IRQ        BIT(7)
+# define IRQSTATUS_TIMER_IRQ	    BIT(7)
 # define IRQSTATUS_FIFO_SHLD_IRQ    BIT(8)
 # define IRQSTATUS_PCI_IRQ	    BIT(9)
-# define IRQSTATUS_BMCNTERR_IRQ     BIT(10)
-# define IRQSTATUS_AUTOSCSI_IRQ     BIT(11)
-# define PCI_IRQ_MASK               BIT(12)
-# define TIMER_IRQ_MASK             BIT(13)
-# define FIFO_IRQ_MASK              BIT(14)
-# define SCSI_IRQ_MASK              BIT(15)
+# define IRQSTATUS_BMCNTERR_IRQ	    BIT(10)
+# define IRQSTATUS_AUTOSCSI_IRQ	    BIT(11)
+# define PCI_IRQ_MASK		    BIT(12)
+# define TIMER_IRQ_MASK		    BIT(13)
+# define FIFO_IRQ_MASK		    BIT(14)
+# define SCSI_IRQ_MASK		    BIT(15)
 # define IRQ_CONTROL_ALL_IRQ_MASK   (PCI_IRQ_MASK   | \
-                                     TIMER_IRQ_MASK | \
-                                     FIFO_IRQ_MASK  | \
-                                     SCSI_IRQ_MASK  )
-# define IRQSTATUS_ANY_IRQ          (IRQSTATUS_RESELECT_OCCUER	| \
+				     TIMER_IRQ_MASK | \
+				     FIFO_IRQ_MASK  | \
+				     SCSI_IRQ_MASK  )
+# define IRQSTATUS_ANY_IRQ	    (IRQSTATUS_RESELECT_OCCUER	| \
 				     IRQSTATUS_PHASE_CHANGE_IRQ	| \
 				     IRQSTATUS_SCSIRESET_IRQ	| \
 				     IRQSTATUS_TIMER_IRQ	| \
@@ -125,33 +139,33 @@
 
 #define TRANSFER_CONTROL	0x02	/* BASE+02, W, W */
 #define TRANSFER_STATUS		0x02	/* BASE+02, W, R */
-# define CB_MMIO_MODE        BIT(0)
-# define CB_IO_MODE          BIT(1)
-# define BM_TEST             BIT(2)
-# define BM_TEST_DIR         BIT(3)
+# define CB_MMIO_MODE	     BIT(0)
+# define CB_IO_MODE	     BIT(1)
+# define BM_TEST	     BIT(2)
+# define BM_TEST_DIR	     BIT(3)
 # define DUAL_EDGE_ENABLE    BIT(4)
 # define NO_TRANSFER_TO_HOST BIT(5)
-# define TRANSFER_GO         BIT(7)
-# define BLIEND_MODE         BIT(8)
-# define BM_START            BIT(9)
+# define TRANSFER_GO	     BIT(7)
+# define BLIEND_MODE	     BIT(8)
+# define BM_START	     BIT(9)
 # define ADVANCED_BM_WRITE   BIT(10)
-# define BM_SINGLE_MODE      BIT(11)
-# define FIFO_TRUE_FULL      BIT(12)
+# define BM_SINGLE_MODE	     BIT(11)
+# define FIFO_TRUE_FULL	     BIT(12)
 # define FIFO_TRUE_EMPTY     BIT(13)
 # define ALL_COUNTER_CLR     BIT(14)
-# define FIFOTEST            BIT(15)
+# define FIFOTEST	     BIT(15)
 
 #define INDEX_REG		0x04	/* BASE+04, Byte(R/W), Word(R) */
 
 #define TIMER_SET		0x06	/* BASE+06, W, R/W */
 # define TIMER_CNT_MASK (0xff)
-# define TIMER_STOP     BIT(8)
+# define TIMER_STOP	BIT(8)
 
 #define DATA_REG_LOW		0x08	/* BASE+08, LowW, R/W */
 #define DATA_REG_HI		0x0a	/* BASE+0a, Hi-W, R/W */
 
 #define FIFO_REST_CNT		0x0c	/* BASE+0c, W, R/W */
-# define FIFO_REST_MASK       0x1ff
+# define FIFO_REST_MASK	      0x1ff
 # define FIFO_EMPTY_SHLD_FLAG BIT(14)
 # define FIFO_FULL_SHLD_FLAG  BIT(15)
 
@@ -159,33 +173,33 @@
 # define SREQSMPLRATE_RATE0 BIT(0)
 # define SREQSMPLRATE_RATE1 BIT(1)
 # define SAMPLING_ENABLE    BIT(2)
-#  define SMPL_40M (0)                   /* 40MHz:   0-100ns/period */
-#  define SMPL_20M (SREQSMPLRATE_RATE0)  /* 20MHz: 100-200ns/period */
-#  define SMPL_10M (SREQSMPLRATE_RATE1)  /* 10Mhz: 200-   ns/period */
+#  define SMPL_40M (0)			 /* 40MHz:   0-100ns/period */
+#  define SMPL_20M (SREQSMPLRATE_RATE0)	 /* 20MHz: 100-200ns/period */
+#  define SMPL_10M (SREQSMPLRATE_RATE1)	 /* 10Mhz: 200-	  ns/period */
 
 #define SCSI_BUS_CONTROL	0x10	/* BASE+10, B, R/W */
-# define BUSCTL_SEL         BIT(0)
-# define BUSCTL_RST         BIT(1)
+# define BUSCTL_SEL	    BIT(0)
+# define BUSCTL_RST	    BIT(1)
 # define BUSCTL_DATAOUT_ENB BIT(2)
-# define BUSCTL_ATN         BIT(3)
-# define BUSCTL_ACK         BIT(4)
-# define BUSCTL_BSY         BIT(5)
-# define AUTODIRECTION      BIT(6)
-# define ACKENB             BIT(7)
+# define BUSCTL_ATN	    BIT(3)
+# define BUSCTL_ACK	    BIT(4)
+# define BUSCTL_BSY	    BIT(5)
+# define AUTODIRECTION	    BIT(6)
+# define ACKENB		    BIT(7)
 
 #define CLR_COUNTER		0x12	/* BASE+12, B, W */
 # define ACK_COUNTER_CLR       BIT(0)
 # define SREQ_COUNTER_CLR      BIT(1)
 # define FIFO_HOST_POINTER_CLR BIT(2)
 # define FIFO_REST_COUNT_CLR   BIT(3)
-# define BM_COUNTER_CLR        BIT(4)
-# define SAVED_ACK_CLR         BIT(5)
-# define CLRCOUNTER_ALLMASK    (ACK_COUNTER_CLR       | \
-                                SREQ_COUNTER_CLR      | \
-                                FIFO_HOST_POINTER_CLR | \
-                                FIFO_REST_COUNT_CLR   | \
-                                BM_COUNTER_CLR        | \
-                                SAVED_ACK_CLR         )
+# define BM_COUNTER_CLR	       BIT(4)
+# define SAVED_ACK_CLR	       BIT(5)
+# define CLRCOUNTER_ALLMASK    (ACK_COUNTER_CLR	      | \
+				SREQ_COUNTER_CLR      | \
+				FIFO_HOST_POINTER_CLR | \
+				FIFO_REST_COUNT_CLR   | \
+				BM_COUNTER_CLR	      | \
+				SAVED_ACK_CLR	      )
 
 #define SCSI_BUS_MONITOR	0x12	/* BASE+12, B, R */
 # define BUSMON_MSG BIT(0)
@@ -294,7 +308,7 @@
 
 #define SCSI_MSG_OUT		0x44	/* BASE+44, DW, R/W */
 # define MSGOUT_COUNT_MASK (BIT(0)|BIT(1))
-# define MV_VALID	    BIT(7)
+# define MSGOUT_VALID	    BIT(7)
 
 #define SEL_TIME_OUT		0x48	/* BASE+48, W, R/W */
 #define SAVED_SACK_CNT		0x4c	/* BASE+4c, DW, R */
@@ -389,23 +403,23 @@
 #define SREQ_EDGH		0x0e	/* BASE+08, IDX+0e, B, W */
 # define SREQ_EDGH_SELECT BIT(0)
 
-#define UP_CNT			0x0f	/* BASE+08, IDX+0f, B, W */
+#define UP_CNT			0x0f	/* BASE+08, IDX+0f, B, W */ /* For hardware testing. Don't use it. */
 # define REQCNT_UP  BIT(0)
 # define ACKCNT_UP  BIT(1)
 # define BMADR_UP   BIT(4)
 # define BMCNT_UP   BIT(5)
 # define SGT_CNT_UP BIT(7)
 
-#define CFG_CMD_STR		0x10	/* BASE+08, IDX+10, W, R */
+#define CFG_CMD_STR		0x10	/* BASE+08, IDX+10, W, R   */
 #define CFG_LATE_CACHE		0x11	/* BASE+08, IDX+11, W, R/W */
-#define CFG_BASE_ADR_1		0x12	/* BASE+08, IDX+12, W, R */
-#define CFG_BASE_ADR_2		0x13	/* BASE+08, IDX+13, W, R */
-#define CFG_INLINE		0x14	/* BASE+08, IDX+14, W, R */
+#define CFG_BASE_ADR_1		0x12	/* BASE+08, IDX+12, W, R   */
+#define CFG_BASE_ADR_2		0x13	/* BASE+08, IDX+13, W, R   */
+#define CFG_INLINE		0x14	/* BASE+08, IDX+14, W, R   */
 
 #define SERIAL_ROM_CTL		0x15	/* BASE+08, IDX+15, B, R */
-# define SCL BIT(0)
-# define ENA BIT(1)
-# define SDA BIT(2)
+# define SROM_CLOCK   BIT(0)			/* eeprom SCL */
+# define SROM_ENABLE  BIT(1)			/* eeprom ENA */
+# define SROM_DATA    BIT(2)			/* eeprom SDA */
 
 #define FIFO_HST_POINTER	0x16	/* BASE+08, IDX+16, B, R/W */
 #define SREQ_DELAY		0x17	/* BASE+08, IDX+17, B, R/W */
@@ -448,17 +462,18 @@
 /************************************************************************
  * structure for DMA/Scatter Gather list
  */
-#define NSP32_SG_SIZE		SG_ALL
+#define NSP32_SG_SIZE	SG_ALL
 
+/* All values must be little endian */
 typedef struct _nsp32_sgtable {
-	/* values must be little endian */
 	u32_le addr; /* transfer address */
-	u32_le len;  /* transfer length. BIT(31) is for SGT_END mark */
-} __attribute__ ((packed)) nsp32_sgtable;
+	u32_le len;  /* transfer length. BIT(31) is for SGTEND mark */
+} __attribute__((packed)) nsp32_sgtable;
 
+/* All values must be little endian */
 typedef struct _nsp32_sglun {
-	nsp32_sgtable sgt[NSP32_SG_SIZE+1];	/* SG table */
-} __attribute__ ((packed)) nsp32_sglun;
+	nsp32_sgtable sgt[NSP32_SG_SIZE + 1];	/* SG table */
+} __attribute__((packed)) nsp32_sglun;
 #define NSP32_SG_TABLE_SIZE (sizeof(nsp32_sgtable) * NSP32_SG_SIZE * MAX_TARGET * MAX_LUN)
 
 /* Auto parameter mode memory map.   */
@@ -474,7 +489,7 @@
 	u16_le transfer_control; /* transfer control register         */
 	u32_le sgt_pointer;      /* SG table physical address for DMA */
 	u32_le dummy[2];
-} __attribute__ ((packed)) nsp32_autoparam;  /* must be packed struct */
+} __attribute__((packed)) nsp32_autoparam;  /* must be packed struct */
 
 /*
  * host data structure
@@ -499,13 +514,13 @@
 #define MSGIN03			BIT(1)		/* Auto Msg In 03 Flag  */
 
 typedef struct _nsp32_lunt {
-	struct scsi_cmnd	*SCpnt;	    /* Current Handling struct scsi_cmnd */
-	unsigned long	 save_datp;  /* Save Data Pointer - saved position from initial address */
-	int		 msgin03;	/* auto msg in 03 flag     */
-	unsigned int	 sg_num;	/* Total number of SG entries */
-	int		 cur_entry;	/* Current SG entry number */
-	nsp32_sglun     *sglun;		/* sg table per lun        */
-	dma_addr_t       sglun_paddr;   /* sglun physical address  */
+	struct scsi_cmnd *SCpnt;       /* Current Handling struct scsi_cmnd */
+	unsigned long	  save_datp;   /* Save Data Pointer - saved position from initial address */
+	int		  msgin03;     /* auto msg in 03 flag	     */
+	unsigned int	  sg_num;      /* Total number of SG entries */
+	int		  cur_entry;   /* Current SG entry number    */
+	nsp32_sglun	 *sglun;       /* sg table per lun	     */
+	dma_addr_t	  sglun_paddr; /* sglun physical address     */
 } nsp32_lunt;
 
 
@@ -514,7 +529,7 @@
  */
 #define NSP32_HOST_SCSIID    7  /* SCSI initiator is everytime defined as 7 */
 #define MAX_TARGET	     8
-#define MAX_LUN		     8	/* XXX: In SPI3, max number of LUN is 64. */
+#define MAX_LUN		     8	/* XXX: In SPI3, max number of LUN is 64.   */
 
 
 typedef struct _nsp32_sync_table {
@@ -530,8 +545,9 @@
  * structure for target device static data
  */
 /* flag for nsp32_target.sync_flag */
-#define SDTR_INITIATOR	  BIT(0)    /* sending SDTR from initiator        */
-#define SDTR_TARGET	  BIT(1)    /* sending SDTR from target           */
+#define SDTR_NONE	  0	    /* initial state			  */
+#define SDTR_INITIATOR	  BIT(0)    /* sending SDTR from initiator	  */
+#define SDTR_TARGET	  BIT(1)    /* sending SDTR from target		  */
 #define SDTR_DONE	  BIT(2)    /* exchanging SDTR has been processed */
 
 /* syncronous period value for nsp32_target.config_max */
@@ -539,83 +555,87 @@
 #define FAST10M			0x19
 #define ULTRA20M		0x0c
 
-/* flag for nsp32_target.{sync_offset}, period */
+/* flag for nsp32_target.{sync_offset, period} */
 #define ASYNC_OFFSET		0	/* asynchronous transfer           */
-#define SYNC_OFFSET		0xf	/* synchronous transfer max offset */
+#define MAX_OFFSET		0xf	/* synchronous transfer max offset */
 
 /* syncreg:
   bit:07 06 05 04 03 02 01 00
       ---PERIOD-- ---OFFSET--   */
-#define TO_SYNCREG(period, offset) (((period) & 0x0f) << 4 | ((offset) & 0x0f))
+#define TO_SYNCREG(period, offset) ((((period) & 0x0f) << 4) | (((offset) & 0x0f)))
 
+/* each SCSI target status */
 typedef struct _nsp32_target {
-	unsigned char	syncreg;	/* value for SYNCREG   */
-	unsigned char	ackwidth;	/* value for ACKWIDTH  */
-	unsigned char   period;         /* sync period (0-255) */
-	unsigned char	offset;		/* sync offset (0-15)  */
-	int		sync_flag;	/* SDTR_*, 0           */
-	int		limit_entry;	/* max speed limit entry designated
-					   by EEPROM configuration */
-	unsigned char   sample_reg;     /* SREQ hazard killer register */
+	unsigned char  syncreg;	    /* value for SYNCREG   */
+	unsigned char  ackwidth;    /* value for ACKWIDTH  */
+	unsigned char  period;	    /* sync period (0-255) */
+	unsigned char  offset;	    /* sync offset (0-15)  */
+	int	       sync_flag;   /* SDTR_*, 0	   */
+	int	       limit_entry; /* max speed limit entry designated
+				       by EEPROM configuration */
+	unsigned char  sample_reg;  /* SREQ hazard killer register */
 } nsp32_target;
 
 typedef struct _nsp32_hw_data {
-	int           IrqNumber;
-	int           BaseAddress;
-	int           NumAddress;
-	void __iomem *MmioAddress;
+	unsigned int   IrqNumber;
+	unsigned int   BaseAddress;
+	size_t	       NumAddress;
+	void __iomem * MmioAddress;
 #define NSP32_MMIO_OFFSET 0x0800
-	unsigned long MmioLength;
+	unsigned long  MmioLength;
 
 	struct scsi_cmnd *CurrentSC;
 
-	struct pci_dev             *Pci;
+	struct pci_dev		   *Pci;
 	const struct pci_device_id *pci_devid;
-	struct Scsi_Host           *Host;
-	spinlock_t                  Lock;
+	struct Scsi_Host	   *Host;
+	spinlock_t		    Lock;
 
-	char info_str[100];
+	char info_str[100];		/* description string		   */
 
 	/* allocated memory region */
-	nsp32_sglun      *sg_list;	/* sglist virtuxal address         */
-	dma_addr_t	  sg_paddr;     /* physical address of hw_sg_table */
-	nsp32_autoparam  *autoparam;	/* auto parameter transfer region  */
+	nsp32_sglun	 *sg_list;	/* sglist virtuxal address	   */
+	dma_addr_t	  sg_paddr;	/* physical address of hw_sg_table */
+	nsp32_autoparam	 *autoparam;	/* auto parameter transfer region  */
 	dma_addr_t	  auto_paddr;	/* physical address of autoparam   */
-	int 		  cur_entry;	/* current sgt entry               */
+	int		  cur_entry;	/* current sgt entry		   */
 
-	/* target/LUN */
-	nsp32_lunt       *cur_lunt;	/* Current connected LUN table */
-	nsp32_lunt        lunt[MAX_TARGET][MAX_LUN];  /* All LUN table */
-
-	nsp32_target     *cur_target;	/* Current connected SCSI ID    */
-	nsp32_target	  target[MAX_TARGET];	     /* SCSI ID */
-	int		  cur_id;	/* Current connected target ID  */
+	/* targetID / LUN */
+	nsp32_lunt	 *cur_lunt;	/* Current connected LUN table */
+	nsp32_lunt	  lunt[MAX_TARGET][MAX_LUN];  /* All LUN table */
+
+	nsp32_target	 *cur_target;	/* Current connected target	*/
+	nsp32_target	  target[MAX_TARGET]; /* hold target statuses	*/
+	int		  cur_id;	/* Current connected target ID	*/
 	int		  cur_lun;	/* Current connected target LUN */
 
 	/* behavior setting parameters */
-	int		  trans_method;	/* transfer method flag            */
-	int		  resettime;	/* Reset time                      */
-	int 		  clock;       	/* clock dividing flag             */
-	nsp32_sync_table *synct;	/* sync_table determined by clock  */
+	int		  trans_method;	/* transfer method flag		   */
+	int		  resettime;	/* Reset time			   */
+	int		  clock;	/* clock dividing flag		   */
+	const nsp32_sync_table *synct;	/* sync_table determined by clock  */
 	int		  syncnum;	/* the max number of synct element */
 
 	/* message buffer */
 	unsigned char msgoutbuf[MSGOUTBUF_MAX]; /* msgout buffer    */
-	char	      msgout_len;		/* msgoutbuf length */
-	unsigned char msginbuf [MSGINBUF_MAX];	/* megin buffer     */
-	char	      msgin_len;		/* msginbuf length  */
+	size_t	      msgout_len;		/* msgoutbuf length */
+	unsigned char msginbuf [MSGINBUF_MAX];	/* megin buffer	    */
+	size_t	      msgin_len;		/* msginbuf length  */
 
+#if ((defined CONFIG_PM) && (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,10)))
+	u32	      PciState[16];	/* save PCI state to this area */
+#endif
 } nsp32_hw_data;
 
-/*
+/*--------------------
  * TIME definition
  */
-#define RESET_HOLD_TIME		10000	/* reset time in us (SCSI-2 says the
-					   minimum is 25us) */
-#define SEL_TIMEOUT_TIME	10000	/* 250ms defined in SCSI specification
-					   (25.6us/1unit) */
-#define ARBIT_TIMEOUT_TIME	100	/* 100us */
-#define REQSACK_TIMEOUT_TIME	10000	/* max wait time for REQ/SACK assertion
+#define RESET_HOLD_TIME		100	/* reset time in us (SCSI-2 says the
+					   minimum is 25us) */ /* 100ms */
+#define SEL_TIMEOUT_TIME	20000	/* 250ms defined in SCSI specification
+					   (25.6us/1unit) */ /* 512ms */
+#define ARBIT_TIMEOUT_COUNT	100	/* 100us? */
+#define REQSACK_TIMEOUT_COUNT	10000	/* max wait time for REQ/SACK assertion
 					   or negation, 10000us == 10ms */
 
 /**************************************************************************
@@ -624,18 +644,14 @@
 
 /* for Kernel 2.4 */
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0))
-# define scsi_register_host(template) 	scsi_register_module(MODULE_SCSI_HA, template)
+# define scsi_register_host(template)	scsi_register_module(MODULE_SCSI_HA, template)
 # define scsi_unregister_host(template) scsi_unregister_module(MODULE_SCSI_HA, template)
-# define scsi_host_put(host)            scsi_unregister(host)
-# define pci_name(pci_dev)              ((pci_dev)->slot_name)
+# define scsi_host_put(host)		scsi_unregister(host)
+# define pci_name(pci_dev)		((pci_dev)->slot_name)
 
-typedef void irqreturn_t;
-# define IRQ_NONE      /* */
-# define IRQ_HANDLED   /* */
-# define IRQ_RETVAL(x) /* */
 
 /* This is ad-hoc version of scsi_host_get_next() */
-static inline struct Scsi_Host *scsi_host_get_next(struct Scsi_Host *host)
+inline static struct Scsi_Host *scsi_host_get_next(const struct Scsi_Host *host)
 {
 	if (host == NULL) {
 		return scsi_hostlist;
@@ -645,7 +661,7 @@
 }
 
 /* This is ad-hoc version of scsi_host_hn_get() */
-static inline struct Scsi_Host *scsi_host_hn_get(unsigned short hostno)
+inline static struct Scsi_Host *scsi_host_hn_get(const unsigned short hostno)
 {
 	struct Scsi_Host *host;
 
@@ -658,6 +674,27 @@
 
 	return host;
 }
+
+/* host spin lock */
+# define HOST_LOCK (&io_request_lock)
+
+/* module parameter API */
+# define module_param(a,b,c) /* */
+#endif
+
+/* for Kernel 2.6 */
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0))
+/* host spin lock */
+# define HOST_LOCK (data->Host->host_lock)
+
+#endif
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,10))
+# define nsp_pci_save_state(pci,buf)    pci_save_state(pci,buf)
+# define nsp_pci_restore_state(pci,buf) pci_restore_state(pci,buf)
+#else
+# define nsp_pci_save_state(pci,buf)    pci_save_state(pci)
+# define nsp_pci_restore_state(pci,buf) pci_restore_state(pci)
 #endif
 
 #endif /* _NSP32_H */
