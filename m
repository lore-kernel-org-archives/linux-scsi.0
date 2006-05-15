From: Yokota Hiroshi <yokota@netlab.cs.tsukuba.ac.jp>
Subject: [PATCH 3/3] "nsp_cs" and "nsp32" update
Date: Tue, 16 May 2006 03:36:43 +0900 (JST)
Message-ID: <20060516.033643.71089648.yokota@netlab.cs.tsukuba.ac.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pixy-gw.netlab.cs.tsukuba.ac.jp ([130.158.83.98]:42191 "HELO
	pixy.netlab.cs.tsukuba.ac.jp") by vger.kernel.org with SMTP
	id S965138AbWEOSgp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 May 2006 14:36:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


 This is 3rd part of the patch.

diff --git a/drivers/scsi/pcmcia/nsp_cs.h b/drivers/scsi/pcmcia/nsp_cs.h
index b66b140..e275ec9 100644
--- a/drivers/scsi/pcmcia/nsp_cs.h
+++ b/drivers/scsi/pcmcia/nsp_cs.h
@@ -1,6 +1,6 @@
 /*=======================================================/
   Header file for nsp_cs.c
-      By: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
+      By: YOKOTA Hiroshi <yokota (at) netlab (dot) cs (dot) tsukuba (dot) ac (dot) jp>
 
     Ver.1.0 : Cut unused lines.
     Ver 0.1 : Initial version.
@@ -10,7 +10,7 @@
 
 =========================================================*/
 
-/* $Id: nsp_cs.h,v 1.19 2003/08/18 11:09:19 elca Exp $ */
+/* $Id: nsp_cs.h,v 1.45 2006/03/27 18:04:33 elca Exp $ */
 
 #ifndef  __nsp_cs__
 #define  __nsp_cs__
@@ -26,12 +26,17 @@
 /************************************
  * Some useful macros...
  */
-#define BIT(x)      (1L << (x))
+#define BIT(x)  (1UL << (x))
 
 /* SCSI initiator must be ID 7 */
 #define NSP_INITIATOR_ID  7
 
-#define NSP_SELTIMEOUT 200
+#define NSP_SELTIMEOUT_COUNT 200
+#define NSP_RW_TIMEOUT       10000 /* 10sec  */
+#define NSP_ARBIT_TIMEOUT    3000  /*  3sec  */
+#define NSP_SIGNAL_TIMEOUT   10    /* 10msec */
+
+#define EXTENDED_SDTR_LEN 3
 
 /***************************************************************************
  * register definitions
@@ -40,16 +45,24 @@
  * base register
  ========================================================================*/
 #define	IRQCONTROL	0x00  /* R */
-#  define IRQCONTROL_RESELECT_CLEAR     BIT(0)
+#  define IRQCONTROL_RESELECT_CLEAR	BIT(0)
 #  define IRQCONTROL_PHASE_CHANGE_CLEAR BIT(1)
-#  define IRQCONTROL_TIMER_CLEAR        BIT(2)
-#  define IRQCONTROL_FIFO_CLEAR         BIT(3)
-#  define IRQCONTROL_ALLMASK            0xff
-#  define IRQCONTROL_ALLCLEAR           (IRQCONTROL_RESELECT_CLEAR     | \
+#  define IRQCONTROL_TIMER_CLEAR	BIT(2)
+#  define IRQCONTROL_FIFO_CLEAR		BIT(3)
+#  define IRQCONTROL_SCSI_IRQ_MASK	BIT(4)
+#  define IRQCONTROL_EXT_IRQ_MASK	BIT(5)
+#  define IRQCONTROL_TIMER_IRQ_MASK	BIT(6)
+#  define IRQCONTROL_FIFO_IRQ_MASK	BIT(7)
+#  define IRQCONTROL_ALL_MASK		(IRQCONTROL_SCSI_IRQ_MASK  | \
+					 IRQCONTROL_EXT_IRQ_MASK   | \
+					 IRQCONTROL_TIMER_IRQ_MASK | \
+					 IRQCONTROL_FIFO_IRQ_MASK  )
+#  define IRQCONTROL_ALL_CLEAR		(IRQCONTROL_RESELECT_CLEAR     | \
 					 IRQCONTROL_PHASE_CHANGE_CLEAR | \
-					 IRQCONTROL_TIMER_CLEAR        | \
-					 IRQCONTROL_FIFO_CLEAR          )
-#  define IRQCONTROL_IRQDISABLE         0xf0
+					 IRQCONTROL_TIMER_CLEAR	       | \
+					 IRQCONTROL_FIFO_CLEAR	       )
+#  define IRQCONTROL_ALL_CLEAR_AND_MASK	 (IRQCONTROL_ALL_MASK | \
+					  IRQCONTROL_ALL_CLEAR)
 
 #define	IRQSTATUS	0x00  /* W */
 #  define IRQSTATUS_SCSI  BIT(0)
@@ -63,8 +76,8 @@
 
 #define	FIFOSTATUS	0x01 /* R */
 #  define FIFOSTATUS_CHIP_REVISION_MASK 0x0f
-#  define FIFOSTATUS_CHIP_ID_MASK       0x70
-#  define FIFOSTATUS_FULL_EMPTY         BIT(7)
+#  define FIFOSTATUS_CHIP_ID_MASK	0x70
+#  define FIFOSTATUS_FULL_EMPTY		BIT(7)
 
 #define	INDEXREG	0x02 /* R/W */
 #define	DATAREG		0x03 /* R/W */
@@ -88,62 +101,62 @@
 
 #define SCSIIRQMODE	0x15 /* R/W */
 #  define SCSI_PHASE_CHANGE_EI BIT(0)
-#  define RESELECT_EI          BIT(4)
-#  define FIFO_IRQ_EI          BIT(5)
+#  define RESELECT_EI	       BIT(4)
+#  define FIFO_IRQ_EI	       BIT(5)
 #  define SCSI_RESET_IRQ_EI    BIT(6)
 
 #define IRQPHASESENCE	0x16 /* R */
-#  define LATCHED_MSG      BIT(0)
-#  define LATCHED_IO       BIT(1)
-#  define LATCHED_CD       BIT(2)
+#  define LATCHED_MSG	   BIT(0)
+#  define LATCHED_IO	   BIT(1)
+#  define LATCHED_CD	   BIT(2)
 #  define LATCHED_BUS_FREE BIT(3)
 #  define PHASE_CHANGE_IRQ BIT(4)
-#  define RESELECT_IRQ     BIT(5)
-#  define FIFO_IRQ         BIT(6)
+#  define RESELECT_IRQ	   BIT(5)
+#  define FIFO_IRQ	   BIT(6)
 #  define SCSI_RESET_IRQ   BIT(7)
 
 #define TIMERCOUNT	0x17 /* R/W */
 
 #define SCSIBUSCTRL	0x18 /* R/W */
-#  define SCSI_SEL         BIT(0)
-#  define SCSI_RST         BIT(1)
+#  define SCSI_SEL	   BIT(0)
+#  define SCSI_RST	   BIT(1)
 #  define SCSI_DATAOUT_ENB BIT(2)
-#  define SCSI_ATN         BIT(3)
-#  define SCSI_ACK         BIT(4)
-#  define SCSI_BSY         BIT(5)
-#  define AUTODIRECTION    BIT(6)
-#  define ACKENB           BIT(7)
+#  define SCSI_ATN	   BIT(3)
+#  define SCSI_ACK	   BIT(4)
+#  define SCSI_BSY	   BIT(5)
+#  define AUTODIRECTION	   BIT(6)
+#  define ACKENB	   BIT(7)
 
 #define SCSIBUSMON	0x19 /* R */
 
 #define SETARBIT	0x1A /* W */
-#  define ARBIT_GO         BIT(0)
+#  define ARBIT_GO	   BIT(0)
 #  define ARBIT_FLAG_CLEAR BIT(1)
 
 #define ARBITSTATUS	0x1A /* R */
-/*#  define ARBIT_GO        BIT(0)*/
-#  define ARBIT_WIN        BIT(1)
-#  define ARBIT_FAIL       BIT(2)
-#  define RESELECT_FLAG    BIT(3)
+/*#  define ARBIT_GO	    BIT(0)*/
+#  define ARBIT_WIN	   BIT(1)
+#  define ARBIT_FAIL	   BIT(2)
+#  define RESELECT_FLAG	   BIT(3)
 
 #define PARITYCTRL	0x1B  /* W */
 #define PARITYSTATUS	0x1B  /* R */
 
 #define COMMANDCTRL	0x1C  /* W */
 #  define CLEAR_COMMAND_POINTER BIT(0)
-#  define AUTO_COMMAND_GO       BIT(1)
+#  define AUTO_COMMAND_GO	BIT(1)
 
 #define RESELECTID	0x1C  /* R   */
 #define COMMANDDATA	0x1D  /* R/W */
 
 #define POINTERCLR	0x1E  /*   W */
-#  define POINTER_CLEAR      BIT(0)
+#  define POINTER_CLEAR	     BIT(0)
 #  define ACK_COUNTER_CLEAR  BIT(1)
 #  define REQ_COUNTER_CLEAR  BIT(2)
 #  define HOST_COUNTER_CLEAR BIT(3)
-#  define READ_SOURCE        (BIT(4) | BIT(5))
-#    define ACK_COUNTER        (0)
-#    define REQ_COUNTER        (BIT(4))
+#  define READ_SOURCE	     (BIT(4) | BIT(5))
+#    define ACK_COUNTER	       (0)
+#    define REQ_COUNTER	       (BIT(4))
 #    define HOST_COUNTER       (BIT(5))
 
 #define TRANSFERCOUNT	0x1E  /* R   */
@@ -163,87 +176,87 @@
 #  define SYNCREG_PERIOD_MASK  0xf0
 #  define SYNCREG_PERIOD_SHIFT 4
 
-#define SCSIDATALATCH	0x22 /*   W */
+#define SCSIDATALATCH	0x22 /*	  W */
 #define SCSIDATAIN	0x22 /* R   */
 #define SCSIDATAWITHACK	0x23 /* R/W */
-#define SCAMCONTROL	0x24 /*   W */
+#define SCAMCONTROL	0x24 /*	  W */
 #define SCAMSTATUS	0x24 /* R   */
 #define SCAMDATA	0x25 /* R/W */
 
 #define OTHERCONTROL	0x26 /* R/W */
 #  define TPL_ROM_WRITE_EN BIT(0)
-#  define TPWR_OUT         BIT(1)
-#  define TPWR_SENSE       BIT(2)
-#  define RA8_CONTROL      BIT(3)
+#  define TPWR_OUT	   BIT(1)
+#  define TPWR_SENSE	   BIT(2)
+#  define RA8_CONTROL	   BIT(3)
 
 #define ACKWIDTH	0x27 /* R/W */
-#define CLRTESTPNT	0x28 /*   W */
-#define ACKCNTLD	0x29 /*   W */
-#define REQCNTLD	0x2A /*   W */
-#define HSTCNTLD	0x2B /*   W */
+#define CLRTESTPNT	0x28 /*	  W */
+#define ACKCNTLD	0x29 /*	  W */
+#define REQCNTLD	0x2A /*	  W */
+#define HSTCNTLD	0x2B /*	  W */
 #define CHECKSUM	0x2C /* R/W */
 
 /************************************************************************
  * Input status bit definitions.
  ************************************************************************/
-#define S_MESSAGE	BIT(0)    /* Message line from SCSI bus      */
-#define S_IO		BIT(1)    /* Input/Output line from SCSI bus */
-#define S_CD		BIT(2)    /* Command/Data line from SCSI bus */
-#define S_BUSY		BIT(3)    /* Busy line from SCSI bus         */
-#define S_ACK		BIT(4)    /* Acknowlege line from SCSI bus   */
-#define S_REQUEST	BIT(5)    /* Request line from SCSI bus      */
-#define S_SELECT	BIT(6)	  /*                                 */
-#define S_ATN		BIT(7)	  /*                                 */
+#define S_MESSAGE	BIT(0)	  /* Message line from SCSI bus	     */
+#define S_IO		BIT(1)	  /* Input/Output line from SCSI bus */
+#define S_CD		BIT(2)	  /* Command/Data line from SCSI bus */
+#define S_BUSY		BIT(3)	  /* Busy line from SCSI bus	     */
+#define S_ACK		BIT(4)	  /* Acknowlege line from SCSI bus   */
+#define S_REQUEST	BIT(5)	  /* Request line from SCSI bus	     */
+#define S_SELECT	BIT(6)	  /*				     */
+#define S_ATN		BIT(7)	  /*				     */
 
 /***********************************************************************
  * Useful Bus Monitor status combinations.
  ***********************************************************************/
-#define BUSMON_SEL         S_SELECT
-#define BUSMON_BSY         S_BUSY
-#define BUSMON_REQ         S_REQUEST
-#define BUSMON_IO          S_IO
-#define BUSMON_ACK         S_ACK
-#define BUSMON_BUS_FREE    0
-#define BUSMON_COMMAND     ( S_BUSY | S_CD |                    S_REQUEST )
+#define BUSMON_SEL	   S_SELECT
+#define BUSMON_BSY	   S_BUSY
+#define BUSMON_REQ	   S_REQUEST
+#define BUSMON_IO	   S_IO
+#define BUSMON_ACK	   S_ACK
+#define BUSMON_BUS_FREE	   0
+#define BUSMON_COMMAND	   ( S_BUSY | S_CD |			S_REQUEST )
 #define BUSMON_MESSAGE_IN  ( S_BUSY | S_CD | S_IO | S_MESSAGE | S_REQUEST )
-#define BUSMON_MESSAGE_OUT ( S_BUSY | S_CD |        S_MESSAGE | S_REQUEST )
-#define BUSMON_DATA_IN     ( S_BUSY |        S_IO |             S_REQUEST )
-#define BUSMON_DATA_OUT    ( S_BUSY |                           S_REQUEST )
-#define BUSMON_STATUS      ( S_BUSY | S_CD | S_IO |             S_REQUEST )
-#define BUSMON_SELECT      (                 S_IO |                        S_SELECT )
-#define BUSMON_RESELECT    (                 S_IO |                        S_SELECT )
-#define BUSMON_PHASE_MASK  (          S_CD | S_IO | S_MESSAGE |            S_SELECT )
+#define BUSMON_MESSAGE_OUT ( S_BUSY | S_CD |	    S_MESSAGE | S_REQUEST )
+#define BUSMON_DATA_IN	   ( S_BUSY |	     S_IO |		S_REQUEST )
+#define BUSMON_DATA_OUT	   ( S_BUSY |				S_REQUEST )
+#define BUSMON_STATUS	   ( S_BUSY | S_CD | S_IO |		S_REQUEST )
+#define BUSMON_SELECT	   (		     S_IO |			   S_SELECT )
+#define BUSMON_RESELECT	   (		     S_IO |			   S_SELECT )
+#define BUSMON_PHASE_MASK  (	      S_CD | S_IO | S_MESSAGE |		   S_SELECT )
 
-#define BUSPHASE_SELECT      ( BUSMON_SELECT      & BUSMON_PHASE_MASK )
-#define BUSPHASE_COMMAND     ( BUSMON_COMMAND     & BUSMON_PHASE_MASK )
+#define BUSPHASE_SELECT	     ( BUSMON_SELECT	  & BUSMON_PHASE_MASK )
+#define BUSPHASE_COMMAND     ( BUSMON_COMMAND	  & BUSMON_PHASE_MASK )
 #define BUSPHASE_MESSAGE_IN  ( BUSMON_MESSAGE_IN  & BUSMON_PHASE_MASK )
 #define BUSPHASE_MESSAGE_OUT ( BUSMON_MESSAGE_OUT & BUSMON_PHASE_MASK )
-#define BUSPHASE_DATA_IN     ( BUSMON_DATA_IN     & BUSMON_PHASE_MASK )
-#define BUSPHASE_DATA_OUT    ( BUSMON_DATA_OUT    & BUSMON_PHASE_MASK )
-#define BUSPHASE_STATUS      ( BUSMON_STATUS      & BUSMON_PHASE_MASK )
+#define BUSPHASE_DATA_IN     ( BUSMON_DATA_IN	  & BUSMON_PHASE_MASK )
+#define BUSPHASE_DATA_OUT    ( BUSMON_DATA_OUT	  & BUSMON_PHASE_MASK )
+#define BUSPHASE_STATUS	     ( BUSMON_STATUS	  & BUSMON_PHASE_MASK )
 
 /*====================================================================*/
 
 typedef struct scsi_info_t {
-	dev_link_t             link;
+	dev_link_t	       link;
 	struct Scsi_Host      *host;
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,74))
-	dev_node_t             node;
+	dev_node_t	       node;
 #else
-	int	               ndev;
-	dev_node_t             node[8];
+	int		       ndev;
+	dev_node_t	       node[8];
 	struct bus_operations *bus;
 #endif
-	int                    stop;
+	int		       stop;
 } scsi_info_t;
 
 
 /* synchronous transfer negotiation data */
 typedef struct _sync_data {
-	unsigned int SyncNegotiation;
+	unsigned int  SyncNegotiation;
 #define SYNC_NOT_YET 0
-#define SYNC_OK      1
-#define SYNC_NG      2
+#define SYNC_OK	     1
+#define SYNC_NG	     2
 
 	unsigned int  SyncPeriod;
 	unsigned int  SyncOffset;
@@ -252,118 +265,135 @@ typedef struct _sync_data {
 } sync_data;
 
 typedef struct _nsp_hw_data {
-	unsigned int  BaseAddress;
-	unsigned int  NumAddress;
-	unsigned int  IrqNumber;
+	unsigned int  BaseAddress; /* I/O base address		    */
+	size_t	      NumAddress;  /* number of allocated I/O ports */
+	int	      IrqNumber;   /* allocated IRQ number	    */
 
-	unsigned long MmioAddress;
+	unsigned long MmioAddress; /* memory mapped I/O address (virtual address) */
 #define NSP_MMIO_OFFSET 0x0800
-	unsigned long MmioLength;
+	unsigned long MmioLength;  /* number of allocated MMIO addresses */
 
 	unsigned char ScsiClockDiv;
+	unsigned char TransferMode; /* Current transfer mode	    */
+	unsigned char ChipRev;
 
-	unsigned char TransferMode;
-
-	int           TimerCount;
-	int           SelectionTimeOut;
-	Scsi_Cmnd    *CurrentSC;
-	//int           CurrnetTarget;
+	int	      TimerCount;
+	int	      SelectionTimeOut;
+	struct scsi_cmnd    *CurrentSC;
+	//int		CurrnetTarget;
 
-	int           FifoCount;
+	int	      FifoCount;
 
 #define MSGBUF_SIZE 20
-	unsigned char MsgBuffer[MSGBUF_SIZE];
-	int MsgLen;
+	unsigned char MsgInBuffer[MSGBUF_SIZE]; /* SCSI message buffer */
+	size_t	      MsgInLen;
+	unsigned char MsgOutBuffer[MSGBUF_SIZE]; /* SCSI message buffer */
+	size_t	      MsgOutLen;
 
 #define N_TARGET 8
 	sync_data     Sync[N_TARGET];
 
-	char nspinfo[110];     /* description */
-	spinlock_t Lock;
-
-	scsi_info_t   *ScsiInfo; /* attach <-> detect glue */
+	char	      nspinfo[110];  /* description string     */
+	spinlock_t    Lock;
 
+	scsi_info_t  *ScsiInfo;	     /* attach <-> detect glue */
 
 #ifdef NSP_DEBUG
-	int CmdId; /* Accepted command serial number.
-		      Used for debugging.             */
+	int CmdId;	/* Accepted command serial number.
+			   Used for debugging.		   */
 #endif
 } nsp_hw_data;
 
 
 /****************************************************************************
- *
+ * functions
  */
 
 /* Card service functions */
-static void        nsp_cs_detach (struct pcmcia_device *p_dev);
-static void        nsp_cs_release(dev_link_t *link);
-static void        nsp_cs_config (dev_link_t *link);
+static int  nsp_cs_attach (struct pcmcia_device *p_dev);
+static void nsp_cs_detach (struct pcmcia_device *p_dev);
+static void nsp_cs_release(dev_link_t *link);
+static void nsp_cs_config (dev_link_t *link);
+static int  nsp_cs_suspend(struct pcmcia_device *dev);
+static int  nsp_cs_resume (struct pcmcia_device *dev);
 
 /* Linux SCSI subsystem specific functions */
-static struct Scsi_Host *nsp_detect     (struct scsi_host_template *sht);
+static struct Scsi_Host *nsp_detect	(struct scsi_host_template *sht);
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-static        int        nsp_detect_old (struct scsi_host_template *sht);
-static        int        nsp_release_old(struct Scsi_Host *shpnt);
+static	      int	 nsp_detect_old (Scsi_Host_Template *sht);
+static	      int	 nsp_release_old(struct Scsi_Host *shpnt);
 #endif
-static const  char      *nsp_info       (struct Scsi_Host *shpnt);
-static        int        nsp_proc_info  (
+static const  char	*nsp_info	(struct Scsi_Host *shpnt);
+static	      int	 nsp_proc_info	(
 #if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
-	                                 struct Scsi_Host *host,
+					 struct Scsi_Host *host,
 #endif
-					 char   *buffer,
+					 char	*buffer,
 					 char  **start,
-					 off_t   offset,
-					 int     length,
+					 off_t	 offset,
+					 int	 length,
 #if !(LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
-					 int     hostno,
+					 int	 hostno,
 #endif
-					 int     inout);
-static        int        nsp_queuecommand(Scsi_Cmnd *SCpnt, void (* done)(Scsi_Cmnd *SCpnt));
+					 int	 inout);
+static	      int	 nsp_queuecommand(struct scsi_cmnd *SCpnt, void (* done)(struct scsi_cmnd *SCpnt));
 
 /* Error handler */
-/*static int nsp_eh_abort       (Scsi_Cmnd *SCpnt);*/
-/*static int nsp_eh_device_reset(Scsi_Cmnd *SCpnt);*/
-static int nsp_eh_bus_reset    (Scsi_Cmnd *SCpnt);
-static int nsp_eh_host_reset   (Scsi_Cmnd *SCpnt);
+/*static int nsp_eh_abort	(struct scsi_cmnd *SCpnt);*/
+/*static int nsp_eh_device_reset(struct scsi_cmnd *SCpnt);*/
+static int nsp_eh_bus_reset    (struct scsi_cmnd *SCpnt);
+static int nsp_eh_host_reset   (struct scsi_cmnd *SCpnt);
 static int nsp_bus_reset       (nsp_hw_data *data);
 
 /* */
-static int  nsphw_init           (nsp_hw_data *data);
-static int  nsphw_start_selection(Scsi_Cmnd *SCpnt);
-static void nsp_start_timer      (Scsi_Cmnd *SCpnt, int time);
-static int  nsp_fifo_count       (Scsi_Cmnd *SCpnt);
-static void nsp_pio_read         (Scsi_Cmnd *SCpnt);
-static void nsp_pio_write        (Scsi_Cmnd *SCpnt);
-static int  nsp_nexus            (Scsi_Cmnd *SCpnt);
-static void nsp_scsi_done        (Scsi_Cmnd *SCpnt);
-static int  nsp_analyze_sdtr     (Scsi_Cmnd *SCpnt);
-static int  nsp_negate_signal    (Scsi_Cmnd *SCpnt, unsigned char mask, char *str);
-static int  nsp_expect_signal    (Scsi_Cmnd *SCpnt, unsigned char current_phase, unsigned char  mask);
-static int  nsp_xfer             (Scsi_Cmnd *SCpnt, int phase);
-static int  nsp_dataphase_bypass (Scsi_Cmnd *SCpnt);
-static int  nsp_reselected       (Scsi_Cmnd *SCpnt);
+static int  nsphw_init		 (	nsp_hw_data *data);
+static int  nsphw_start_selection(	struct scsi_cmnd *SCpnt);
+static void nsp_start_timer	 (const struct scsi_cmnd *SCpnt, int time);
+static int  nsp_fifo_count	 (const struct scsi_cmnd *SCpnt);
+static void nsp_pio_read	 (	struct scsi_cmnd *SCpnt);
+static void nsp_pio_write	 (	struct scsi_cmnd *SCpnt);
+static int  nsp_nexus		 (const struct scsi_cmnd *SCpnt);
+static void nsp_scsi_done	 (	struct scsi_cmnd *SCpnt);
+static int  nsp_analyze_sdtr	 (const struct scsi_cmnd *SCpnt);
+static int  nsp_negate_signal	 (const struct scsi_cmnd *SCpnt, unsigned char mask, char *str);
+static int  nsp_expect_signal	 (const struct scsi_cmnd *SCpnt, unsigned char current_phase, unsigned char mask);
+static int  nsp_xfer		 (const struct scsi_cmnd *SCpnt, int phase);
+static int  nsp_dataphase_bypass (	struct scsi_cmnd *SCpnt);
+static int  nsp_reselected	 (const struct scsi_cmnd *SCpnt);
 static struct Scsi_Host *nsp_detect(struct scsi_host_template *sht);
 
 /* Interrupt handler */
-//static irqreturn_t nspintr(int irq, void *dev_id, struct pt_regs *regs);
+static irqreturn_t nspintr(int irq, void *dev_id, struct pt_regs *regs);
 
 /* Module entry point*/
 static int  __init nsp_cs_init(void);
 static void __exit nsp_cs_exit(void);
 
+/* sysfs attributes */
+static ssize_t nsp_show_version		   (struct class_device *, char *);
+static ssize_t nsp_show_host_no		   (struct class_device *, char *);
+static ssize_t nsp_show_irq		   (struct class_device *, char *);
+static ssize_t nsp_show_io_port		   (struct class_device *, char *);
+static ssize_t nsp_show_mmio_port	   (struct class_device *, char *);
+static ssize_t nsp_show_sg_tablesize	   (struct class_device *, char *);
+static ssize_t nsp_show_burst_transfer_mode(struct class_device *, char *);
+static ssize_t nsp_show_chip_id		   (struct class_device *, char *);
+static ssize_t nsp_show_chip_revision	   (struct class_device *, char *);
+static ssize_t nsp_show_current_sc	   (struct class_device *, char *);
+static ssize_t nsp_show_status		   (struct class_device *, char *);
 
 /* Debug */
 #ifdef NSP_DEBUG
-static void show_command (Scsi_Cmnd *SCpnt);
-static void show_phase   (Scsi_Cmnd *SCpnt);
+static void show_command (const struct scsi_cmnd *SCpnt);
+static void show_phase	 (const struct scsi_cmnd *SCpnt);
 static void show_busphase(unsigned char stat);
-static void show_message (nsp_hw_data *data);
+static void show_message (const nsp_hw_data *data);
 #else
-# define show_command(ptr)   /* */
-# define show_phase(SCpnt)   /* */
-# define show_busphase(stat) /* */
-# define show_message(data)  /* */
+# define show_command(ptr)   do {} while(0)
+# define show_phase(SCpnt)   do {} while(0)
+# define show_busphase(stat) do {} while(0)
+# define show_message(data)  do {} while(0)
+# define nsp_byte_dump(ptr, offset, num) do {} while(0)
 #endif
 
 /*
@@ -371,17 +401,17 @@ static void show_message (nsp_hw_data *d
  */
 enum _scsi_phase {
 	PH_UNDETERMINED ,
-	PH_ARBSTART     ,
-	PH_SELSTART     ,
-	PH_SELECTED     ,
-	PH_COMMAND      ,
-	PH_DATA         ,
-	PH_STATUS       ,
-	PH_MSG_IN       ,
-	PH_MSG_OUT      ,
-	PH_DISCONNECT   ,
-	PH_RESELECT     ,
-	PH_ABORT        ,
+	PH_ARBSTART	,
+	PH_SELSTART	,
+	PH_SELECTED	,
+	PH_COMMAND	,
+	PH_DATA		,
+	PH_STATUS	,
+	PH_MSG_IN	,
+	PH_MSG_OUT	,
+	PH_DISCONNECT	,
+	PH_RESELECT	,
+	PH_ABORT	,
 	PH_RESET
 };
 
@@ -399,71 +429,14 @@ enum _burst_mode {
 
 
 /**************************************************************************
- * SCSI messaage
- */
-#define MSG_COMMAND_COMPLETE 0x00
-#define MSG_EXTENDED         0x01
-#define MSG_ABORT            0x06
-#define MSG_NO_OPERATION     0x08
-#define MSG_BUS_DEVICE_RESET 0x0c
-
-#define MSG_EXT_SDTR         0x01
-
-
-/**************************************************************************
  * Compatibility functions
  */
 
-/* for Kernel 2.4 */
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0))
-#  define scsi_register_host(template)   scsi_register_module(MODULE_SCSI_HA, template)
-#  define scsi_unregister_host(template) scsi_unregister_module(MODULE_SCSI_HA, template)
-#  define scsi_host_put(host)            scsi_unregister(host)
-
-typedef void irqreturn_t;
-#  define IRQ_NONE      /* */
-#  define IRQ_HANDLED   /* */
-#  define IRQ_RETVAL(x) /* */
-
-/* This is ad-hoc version of scsi_host_get_next() */
-static inline struct Scsi_Host *scsi_host_get_next(struct Scsi_Host *host)
-{
-	if (host == NULL) {
-		return scsi_hostlist;
-	} else {
-		return host->next;
-	}
-}
-
-/* This is ad-hoc version of scsi_host_hn_get() */
-static inline struct Scsi_Host *scsi_host_hn_get(unsigned short hostno)
-{
-	struct Scsi_Host *host;
-
-	for (host = scsi_host_get_next(NULL); host != NULL;
-	     host = scsi_host_get_next(host)) {
-		if (host->host_no == hostno) {
-			break;
-		}
-	}
-
-	return host;
-}
-
-static void cs_error(client_handle_t handle, int func, int ret)
-{
-	error_info_t err = { func, ret };
-	pcmcia_report_error(handle, &err);
-}
-
-/* scatter-gather table */
-#  define BUFFER_ADDR (SCpnt->SCp.buffer->address)
-#endif
-
 /* for Kernel 2.6 */
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0))
 /* scatter-gather table */
-#  define BUFFER_ADDR ((char *)((unsigned int)(SCpnt->SCp.buffer->page) + SCpnt->SCp.buffer->offset))
+# define SG_ADDRESS(buffer) ((char *) (page_address((buffer)->page) + (buffer)->offset))
+
 #endif
 
 #endif  /*__nsp_cs__*/
diff --git a/drivers/scsi/pcmcia/nsp_debug.c b/drivers/scsi/pcmcia/nsp_debug.c
index 62e5c60..0ab4443 100644
--- a/drivers/scsi/pcmcia/nsp_debug.c
+++ b/drivers/scsi/pcmcia/nsp_debug.c
@@ -1,12 +1,12 @@
 /*========================================================================
     Debug routines for nsp_cs
-      By: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
+      By: YOKOTA Hiroshi <yokota (at) netlab (dot) cs (dot) tsukuba (dot) ac (dot) jp>
 
     This software may be used and distributed according to the terms of
     the GNU General Public License.
 =========================================================================*/
 
-/* $Id: nsp_debug.c,v 1.3 2003/07/26 14:21:09 elca Exp $ */
+/* $Id: nsp_debug.c,v 1.10 2005/10/16 05:50:36 elca Exp $ */
 
 /*
  * Show the command data of a command
@@ -17,10 +17,10 @@ static const char * group_0_commands[] =
 /* 00-03 */ "Test Unit Ready", "Rezero Unit", unknown, "Request Sense",
 /* 04-07 */ "Format Unit", "Read Block Limits", unknown, "Reasssign Blocks",
 /* 08-0d */ "Read (6)", unknown, "Write (6)", "Seek (6)", unknown, unknown,
-/* 0e-12 */ unknown, "Read Reverse", "Write Filemarks", "Space", "Inquiry",  
+/* 0e-12 */ unknown, "Read Reverse", "Write Filemarks", "Space", "Inquiry",
 /* 13-16 */ unknown, "Recover Buffered Data", "Mode Select", "Reserve",
 /* 17-1b */ "Release", "Copy", "Erase", "Mode Sense", "Start/Stop Unit",
-/* 1c-1d */ "Receive Diagnostic", "Send Diagnostic", 
+/* 1c-1d */ "Receive Diagnostic", "Send Diagnostic",
 /* 1e-1f */ "Prevent/Allow Medium Removal", unknown,
 };
 
@@ -30,7 +30,7 @@ static const char *group_1_commands[] = 
 /* 23-28 */ unknown, unknown, "Read Capacity", unknown, unknown, "Read (10)",
 /* 29-2d */ unknown, "Write (10)", "Seek (10)", unknown, unknown,
 /* 2e-31 */ "Write Verify","Verify", "Search High", "Search Equal",
-/* 32-34 */ "Search Low", "Set Limits", "Prefetch or Read Position", 
+/* 32-34 */ "Search Low", "Set Limits", "Prefetch or Read Position",
 /* 35-37 */ "Synchronize Cache","Lock/Unlock Cache", "Read Defect Data",
 /* 38-3c */ "Medium Scan", "Compare","Copy Verify", "Write Buffer", "Read Buffer",
 /* 3d-3f */ "Update Block", "Read Long",  "Write Long",
@@ -38,8 +38,8 @@ static const char *group_1_commands[] = 
 
 
 static const char *group_2_commands[] = {
-/* 40-41 */ "Change Definition", "Write Same", 
-/* 42-48 */ "Read Sub-Ch(cd)", "Read TOC", "Read Header(cd)", "Play Audio(cd)", unknown, "Play Audio MSF(cd)", "Play Audio Track/Index(cd)", 
+/* 40-41 */ "Change Definition", "Write Same",
+/* 42-48 */ "Read Sub-Ch(cd)", "Read TOC", "Read Header(cd)", "Play Audio(cd)", unknown, "Play Audio MSF(cd)", "Play Audio Track/Index(cd)",
 /* 49-4f */ "Play Track Relative(10)(cd)", unknown, "Pause/Resume(cd)", "Log Select", "Log Sense", unknown, unknown,
 /* 50-55 */ unknown, unknown, unknown, unknown, unknown, "Mode Select (10)",
 /* 56-5b */ unknown, unknown, unknown, unknown, "Mode Sense (10)", unknown,
@@ -53,9 +53,9 @@ static const char *group_2_commands[] = 
 #define NOTEXT_GROUP    2
 
 static const char **commands[] = {
-    group_0_commands, group_1_commands, group_2_commands, 
-    (const char **) RESERVED_GROUP, (const char **) RESERVED_GROUP, 
-    (const char **) NOTEXT_GROUP, (const char **) VENDOR_GROUP, 
+    group_0_commands, group_1_commands, group_2_commands,
+    (const char **) RESERVED_GROUP, (const char **) RESERVED_GROUP,
+    (const char **) NOTEXT_GROUP, (const char **) VENDOR_GROUP,
     (const char **) VENDOR_GROUP
 };
 
@@ -68,13 +68,13 @@ static void print_opcodek(unsigned char 
 
 	switch ((unsigned long) table) {
 	case RESERVED_GROUP:
-		printk("%s[%02x] ", reserved, opcode); 
+		printk("%s[%02x] ", reserved, opcode);
 		break;
 	case NOTEXT_GROUP:
-		printk("%s(notext)[%02x] ", unknown, opcode); 
+		printk("%s(notext)[%02x] ", unknown, opcode);
 		break;
 	case VENDOR_GROUP:
-		printk("%s[%02x] ", vendor, opcode); 
+		printk("%s[%02x] ", vendor, opcode);
 		break;
 	default:
 		if (table[opcode & 0x1f] != unknown)
@@ -85,23 +85,23 @@ static void print_opcodek(unsigned char 
 	}
 }
 
-static void print_commandk (unsigned char *command)
+static void print_commandk (const unsigned char *command)
 {
-	int i, s;
+	int i, size;
 	printk(KERN_DEBUG);
 	print_opcodek(command[0]);
-	/*printk(KERN_DEBUG "%s ", __FUNCTION__);*/
+	/*printk(KERN_DEBUG __FUNCTION__ " ");*/
 	if ((command[0] >> 5) == 6 ||
 	    (command[0] >> 5) == 7 ) {
-		s = 12; /* vender specific */
+		size = 12; /* vender specific */
 	} else {
-		s = COMMAND_SIZE(command[0]);
+		size = COMMAND_SIZE(command[0]);
 	}
-	for ( i = 1; i < s; ++i) {
+	for ( i = 1; i < size; ++i) {
 		printk("%02x ", command[i]);
 	}
 
-	switch (s) {
+	switch (size) {
 	case 6:
 		printk("LBA=%d len=%d",
 		       (((unsigned int)command[1] & 0x0f) << 16) |
@@ -138,12 +138,12 @@ static void print_commandk (unsigned cha
 	printk("\n");
 }
 
-static void show_command(Scsi_Cmnd *SCpnt)
+static void show_command(const struct scsi_cmnd *SCpnt)
 {
 	print_commandk(SCpnt->cmnd);
 }
 
-static void show_phase(Scsi_Cmnd *SCpnt)
+static void show_phase(const struct scsi_cmnd *SCpnt)
 {
 	int i = SCpnt->SCp.phase;
 
@@ -201,13 +201,72 @@ static void show_busphase(unsigned char 
 	}
 }
 
-static void show_message(nsp_hw_data *data)
+static void show_message(const nsp_hw_data *data)
 {
 	int i;
 
-	printk(KERN_DEBUG "msg:");
-	for(i=0; i < data->MsgLen; i++) {
-		printk(" %02x", data->MsgBuffer[i]);
+	switch (data->CurrentSC->SCp.phase) {
+	case PH_MSG_IN:
+		printk(KERN_DEBUG "msgi:");
+
+		for(i=0; i < data->MsgInLen; i++) {
+			printk(" %02x", data->MsgInBuffer[i]);
+		}
+		break;
+	case PH_MSG_OUT:
+		printk(KERN_DEBUG "msgo:");
+
+		for(i=0; i < data->MsgOutLen; i++) {
+			printk(" %02x", data->MsgOutBuffer[i]);
+		}
+		break;
+	default:
+		printk("???\n");
+		return;
+		break;
+	}
+
+
+	printk("\n");
+}
+
+/*
+ * Byte dumper
+ *
+ * ptr:    start address
+ * offset: offset value for address section
+ * size:   dump size in byte
+ */
+static void nsp_byte_dump(const void *ptr, int offset, int size)
+{
+	const unsigned char *tmp = ptr;
+	int pos;
+
+	if (size == 0) {
+		return;
+	}
+
+	pos = 0;
+	while(pos < size) {
+		/* address */
+		if (pos % 16 == 0) {
+			printk(/*KERN_DEBUG*/ "%08x:", pos + offset);
+		}
+
+		/* half separator */
+		if (pos % 16 == 8) {
+			printk(" -");
+		}
+
+		printk(" %02x", tmp[pos]);
+
+		/* Don't print "\n" at last line.
+		   Because we can get one more "\n". */
+		if ((pos % 16 == 15) && (pos + 1 != size)) {
+			printk("\n");
+		}
+
+		pos ++;
 	}
 	printk("\n");
 }
diff --git a/drivers/scsi/pcmcia/nsp_io.h b/drivers/scsi/pcmcia/nsp_io.h
index 3b8746f..650f767 100644
--- a/drivers/scsi/pcmcia/nsp_io.h
+++ b/drivers/scsi/pcmcia/nsp_io.h
@@ -1,40 +1,39 @@
-/*
+/***********************************************************************
   NinjaSCSI I/O funtions 
-      By: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
+      By: YOKOTA Hiroshi <yokota (at) netlab (dot) is (dot) tsukuba (dot) ac (dot) jp>
  
   This software may be used and distributed according to the terms of
   the GNU General Public License.
+************************************************************************/
 
-  */
-
-/* $Id: nsp_io.h,v 1.3 2003/08/04 21:15:26 elca Exp $ */
+/* $Id: nsp_io.h,v 1.5 2004/07/26 15:24:21 elca Exp $ */
 
 #ifndef __NSP_IO_H__
 #define __NSP_IO_H__
 
-static inline          void nsp_write(unsigned int base,
+inline static          void nsp_write(unsigned int base,
 				      unsigned int index,
 				      unsigned char val);
-static inline unsigned char nsp_read(unsigned int base,
+inline static unsigned char nsp_read(unsigned int base,
 				     unsigned int index);
-static inline          void nsp_index_write(unsigned int BaseAddr,
+inline static          void nsp_index_write(unsigned int BaseAddr,
 					    unsigned int Register,
 					    unsigned char Value);
-static inline unsigned char nsp_index_read(unsigned int BaseAddr,
+inline static unsigned char nsp_index_read(unsigned int BaseAddr,
 					   unsigned int Register);
 
 /*******************************************************************
  * Basic IO
  */
 
-static inline void nsp_write(unsigned int  base,
+inline static void nsp_write(unsigned int  base,
 			     unsigned int  index,
 			     unsigned char val)
 {
 	outb(val, (base + index));
 }
 
-static inline unsigned char nsp_read(unsigned int base,
+inline static unsigned char nsp_read(unsigned int base,
 				     unsigned int index)
 {
 	return inb(base + index);
@@ -44,14 +43,14 @@ static inline unsigned char nsp_read(uns
 /**********************************************************************
  * Indexed IO
  */
-static inline unsigned char nsp_index_read(unsigned int BaseAddr,
+inline static unsigned char nsp_index_read(unsigned int BaseAddr,
 					   unsigned int Register)
 {
 	outb(Register, BaseAddr + INDEXREG);
 	return inb(BaseAddr + DATAREG);
 }
 
-static inline void nsp_index_write(unsigned int  BaseAddr,
+inline static void nsp_index_write(unsigned int  BaseAddr,
 				   unsigned int  Register,
 				   unsigned char Value)
 {
@@ -64,7 +63,7 @@ static inline void nsp_index_write(unsig
  */
 
 /* read 8 bit FIFO */
-static inline void nsp_multi_read_1(unsigned int   BaseAddr,
+inline static void nsp_multi_read_1(unsigned int   BaseAddr,
 				    unsigned int   Register,
 				    void          *buf,
 				    unsigned long  count)
@@ -72,7 +71,7 @@ static inline void nsp_multi_read_1(unsi
 	insb(BaseAddr + Register, buf, count);
 }
 
-static inline void nsp_fifo8_read(unsigned int   base,
+inline static void nsp_fifo8_read(unsigned int   base,
 				  void          *buf,
 				  unsigned long  count)
 {
@@ -83,7 +82,7 @@ static inline void nsp_fifo8_read(unsign
 /*--------------------------------------------------------------*/
 
 /* read 16 bit FIFO */
-static inline void nsp_multi_read_2(unsigned int   BaseAddr,
+inline static void nsp_multi_read_2(unsigned int   BaseAddr,
 				    unsigned int   Register,
 				    void          *buf,
 				    unsigned long  count)
@@ -91,7 +90,7 @@ static inline void nsp_multi_read_2(unsi
 	insw(BaseAddr + Register, buf, count);
 }
 
-static inline void nsp_fifo16_read(unsigned int   base,
+inline static void nsp_fifo16_read(unsigned int   base,
 				   void          *buf,
 				   unsigned long  count)
 {
@@ -102,7 +101,7 @@ static inline void nsp_fifo16_read(unsig
 /*--------------------------------------------------------------*/
 
 /* read 32bit FIFO */
-static inline void nsp_multi_read_4(unsigned int   BaseAddr,
+inline static void nsp_multi_read_4(unsigned int   BaseAddr,
 				    unsigned int   Register,
 				    void          *buf,
 				    unsigned long  count)
@@ -110,7 +109,7 @@ static inline void nsp_multi_read_4(unsi
 	insl(BaseAddr + Register, buf, count);
 }
 
-static inline void nsp_fifo32_read(unsigned int   base,
+inline static void nsp_fifo32_read(unsigned int   base,
 				   void          *buf,
 				   unsigned long  count)
 {
@@ -121,7 +120,7 @@ static inline void nsp_fifo32_read(unsig
 /*----------------------------------------------------------*/
 
 /* write 8bit FIFO */
-static inline void nsp_multi_write_1(unsigned int   BaseAddr,
+inline static void nsp_multi_write_1(unsigned int   BaseAddr,
 				     unsigned int   Register,
 				     void          *buf,
 				     unsigned long  count)
@@ -129,7 +128,7 @@ static inline void nsp_multi_write_1(uns
 	outsb(BaseAddr + Register, buf, count);
 }
 
-static inline void nsp_fifo8_write(unsigned int   base,
+inline static void nsp_fifo8_write(unsigned int   base,
 				   void          *buf,
 				   unsigned long  count)
 {
@@ -139,7 +138,7 @@ static inline void nsp_fifo8_write(unsig
 /*---------------------------------------------------------*/
 
 /* write 16bit FIFO */
-static inline void nsp_multi_write_2(unsigned int   BaseAddr,
+inline static void nsp_multi_write_2(unsigned int   BaseAddr,
 				     unsigned int   Register,
 				     void          *buf,
 				     unsigned long  count)
@@ -147,7 +146,7 @@ static inline void nsp_multi_write_2(uns
 	outsw(BaseAddr + Register, buf, count);
 }
 
-static inline void nsp_fifo16_write(unsigned int   base,
+inline static void nsp_fifo16_write(unsigned int   base,
 				    void          *buf,
 				    unsigned long  count)
 {
@@ -157,7 +156,7 @@ static inline void nsp_fifo16_write(unsi
 /*---------------------------------------------------------*/
 
 /* write 32bit FIFO */
-static inline void nsp_multi_write_4(unsigned int   BaseAddr,
+inline static void nsp_multi_write_4(unsigned int   BaseAddr,
 				     unsigned int   Register,
 				     void          *buf,
 				     unsigned long  count)
@@ -165,7 +164,7 @@ static inline void nsp_multi_write_4(uns
 	outsl(BaseAddr + Register, buf, count);
 }
 
-static inline void nsp_fifo32_write(unsigned int   base,
+inline static void nsp_fifo32_write(unsigned int   base,
 				    void          *buf,
 				    unsigned long  count)
 {
@@ -175,7 +174,7 @@ static inline void nsp_fifo32_write(unsi
 
 /*====================================================================*/
 
-static inline void nsp_mmio_write(unsigned long base,
+inline static void nsp_mmio_write(unsigned long base,
 				  unsigned int  index,
 				  unsigned char val)
 {
@@ -184,7 +183,7 @@ static inline void nsp_mmio_write(unsign
 	writeb(val, ptr);
 }
 
-static inline unsigned char nsp_mmio_read(unsigned long base,
+inline static unsigned char nsp_mmio_read(unsigned long base,
 					  unsigned int  index)
 {
 	unsigned char *ptr = (unsigned char *)(base + NSP_MMIO_OFFSET + index);
@@ -194,7 +193,7 @@ static inline unsigned char nsp_mmio_rea
 
 /*-----------*/
 
-static inline unsigned char nsp_mmio_index_read(unsigned long base,
+inline static unsigned char nsp_mmio_index_read(unsigned long base,
 						unsigned int  reg)
 {
 	unsigned char *index_ptr = (unsigned char *)(base + NSP_MMIO_OFFSET + INDEXREG);
@@ -204,7 +203,7 @@ static inline unsigned char nsp_mmio_ind
 	return readb(data_ptr);
 }
 
-static inline void nsp_mmio_index_write(unsigned long base,
+inline static void nsp_mmio_index_write(unsigned long base,
 					unsigned int  reg,
 					unsigned char val)
 {
@@ -216,7 +215,7 @@ static inline void nsp_mmio_index_write(
 }
 
 /* read 32bit FIFO */
-static inline void nsp_mmio_multi_read_4(unsigned long  base,
+inline static void nsp_mmio_multi_read_4(unsigned long  base,
 					 unsigned int   Register,
 					 void          *buf,
 					 unsigned long  count)
@@ -234,7 +233,7 @@ static inline void nsp_mmio_multi_read_4
 	}
 }
 
-static inline void nsp_mmio_fifo32_read(unsigned int   base,
+inline static void nsp_mmio_fifo32_read(unsigned int   base,
 					void          *buf,
 					unsigned long  count)
 {
@@ -242,7 +241,7 @@ static inline void nsp_mmio_fifo32_read(
 	nsp_mmio_multi_read_4(base, FIFODATA, buf, count);
 }
 
-static inline void nsp_mmio_multi_write_4(unsigned long  base,
+inline static void nsp_mmio_multi_write_4(unsigned long  base,
 					  unsigned int   Register,
 					  void          *buf,
 					  unsigned long  count)
@@ -260,7 +259,7 @@ static inline void nsp_mmio_multi_write_
 	}
 }
 
-static inline void nsp_mmio_fifo32_write(unsigned int   base,
+inline static void nsp_mmio_fifo32_write(unsigned int   base,
 					 void          *buf,
 					 unsigned long  count)
 {
diff --git a/drivers/scsi/pcmcia/nsp_message.c b/drivers/scsi/pcmcia/nsp_message.c
index d705773..8d073d9 100644
--- a/drivers/scsi/pcmcia/nsp_message.c
+++ b/drivers/scsi/pcmcia/nsp_message.c
@@ -1,31 +1,138 @@
 /*==========================================================================
   NinjaSCSI-3 message handler
-      By: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
+      By: YOKOTA Hiroshi <yokota<at>netlab.cs.tsukuba.ac.jp>
 
    This software may be used and distributed according to the terms of
    the GNU General Public License.
  */
 
-/* $Id: nsp_message.c,v 1.6 2003/07/26 14:21:09 elca Exp $ */
+/* $Id: nsp_message.c,v 1.14 2005/10/16 05:50:36 elca Exp $ */
 
-static void nsp_message_in(Scsi_Cmnd *SCpnt)
+
+/*
+ * IDENTIFY Message
+ */
+static void nsp_build_identify(const Scsi_Cmnd *SCpnt)
+{
+	nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
+	int	     pos  = data->MsgOutLen;
+
+	data->MsgOutBuffer[pos] = IDENTIFY(TRUE, SCpnt->device->lun); pos++;
+	data->MsgOutLen = pos;
+}
+
+/*
+ * SDTR Message Routine
+ */
+static void nsp_build_sdtr(const Scsi_Cmnd *SCpnt,
+				  unsigned char period,
+				  unsigned char offset)
+{
+	nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
+	int	     pos  = data->MsgOutLen;
+
+	data->MsgOutBuffer[pos] = EXTENDED_MESSAGE;  pos++;
+	data->MsgOutBuffer[pos] = EXTENDED_SDTR_LEN; pos++;
+	data->MsgOutBuffer[pos] = EXTENDED_SDTR;     pos++;
+	data->MsgOutBuffer[pos] = period;	     pos++;
+	data->MsgOutBuffer[pos] = offset;	     pos++;
+
+	data->MsgOutLen = pos;
+}
+
+/*
+ * No Operation Message
+ */
+static void nsp_build_nop(const Scsi_Cmnd *SCpnt)
 {
-	unsigned int  base = SCpnt->device->host->io_port;
+	nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
+	int	     pos  = data->MsgOutLen;
+
+	/*
+	if (pos != 0) {
+		nsp_msg(KERN_WARNING,
+			"Some messages are already contained!");
+		return;
+	}
+	*/
+
+	data->MsgOutBuffer[pos] = NOP; pos++;
+	data->MsgOutLen = pos;
+}
+
+
+/*
+ * transfer SCSI message
+ */
+static int nsp_xfer(const Scsi_Cmnd *SCpnt, int phase)
+{
+	const unsigned int base = SCpnt->device->host->io_port;
+	nsp_hw_data   *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
+	unsigned char *buf;
+	int	       ptr, ret;
+	size_t	       len;
+
+	//nsp_dbg(NSP_DEBUG_DATA_IO, "in");
+
+	if (phase & BUSMON_IO ||
+	    SCpnt->SCp.phase != PH_MSG_OUT) {
+		nsp_msg(KERN_DEBUG, "xfer: read");
+		ret = 0;
+		goto err;
+	} else {
+		len = min(sizeof(data->MsgOutBuffer), data->MsgOutLen);
+		buf = data->MsgOutBuffer;
+	}
+
+	for (ptr = 0; len > 0; len--, ptr++) {
+		int sig;
+
+		sig = nsp_expect_signal(SCpnt, phase, BUSMON_REQ);
+		if (sig <= 0) {
+			nsp_msg(KERN_DEBUG, "xfer quit");
+			ret = 0;
+			goto out;
+		}
+
+		/* if last byte, negate ATN */
+		if (len == 1 && SCpnt->SCp.phase == PH_MSG_OUT) {
+			nsp_index_write(base, SCSIBUSCTRL, AUTODIRECTION | ACKENB);
+			ndelay(90); /* 90ns */
+		}
+
+		/* write message */
+		nsp_dbg(NSP_DEBUG_DATA_IO, "write msg");
+		nsp_index_write(base, SCSIDATAWITHACK, buf[ptr]);
+
+		nsp_negate_signal(SCpnt, BUSMON_ACK, "xfer<ack>");
+	}
+	ret = 1;
+
+ out:
+	data->MsgOutLen = len;
+
+ err:
+	return ret;
+}
+
+static void nsp_message_in(const Scsi_Cmnd *SCpnt)
+{
+	const unsigned int base = SCpnt->device->host->io_port;
 	nsp_hw_data  *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
-	unsigned char data_reg, control_reg;
-	int           ret, len;
+	int	      sig = 1;
+	size_t	      len = 0;
 
 	/*
 	 * XXX: NSP QUIRK
 	 * NSP invoke interrupts only in the case of scsi phase changes,
-	 * therefore we should poll the scsi phase here to catch 
+	 * therefore we should poll the scsi phase here to catch
 	 * the next "msg in" if exists (no scsi phase changes).
 	 */
-	ret = 16;
-	len = 0;
 
 	nsp_dbg(NSP_DEBUG_MSGINOCCUR, "msgin loop");
 	do {
+		unsigned char data_reg, control_reg;
+
 		/* read data */
 		data_reg = nsp_index_read(base, SCSIDATAIN);
 
@@ -35,7 +142,7 @@ static void nsp_message_in(Scsi_Cmnd *SC
 		nsp_index_write(base, SCSIBUSCTRL, control_reg);
 		nsp_negate_signal(SCpnt, BUSMON_REQ, "msgin<REQ>");
 
-		data->MsgBuffer[len] = data_reg; len++;
+		data->MsgInBuffer[len] = data_reg; len++;
 
 		/* deassert ACK */
 		control_reg =  nsp_index_read(base, SCSIBUSCTRL);
@@ -43,36 +150,41 @@ static void nsp_message_in(Scsi_Cmnd *SC
 		nsp_index_write(base, SCSIBUSCTRL, control_reg);
 
 		/* catch a next signal */
-		ret = nsp_expect_signal(SCpnt, BUSPHASE_MESSAGE_IN, BUSMON_REQ);
-	} while (ret > 0 && MSGBUF_SIZE > len);
-
-	data->MsgLen = len;
+		sig = nsp_expect_signal(SCpnt, BUSPHASE_MESSAGE_IN, BUSMON_REQ);
+	} while (sig > 0 && sizeof(data->MsgInBuffer) > len);
 
+	data->MsgInLen = len;
 }
 
-static void nsp_message_out(Scsi_Cmnd *SCpnt)
+static void nsp_message_out(const Scsi_Cmnd *SCpnt)
 {
-	nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
-	int ret = 1;
-	int len = data->MsgLen;
+	const nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
+	int sig = 1;
+	int tmp;
 
 	/*
 	 * XXX: NSP QUIRK
 	 * NSP invoke interrupts only in the case of scsi phase changes,
-	 * therefore we should poll the scsi phase here to catch 
+	 * therefore we should poll the scsi phase here to catch
 	 * the next "msg out" if exists (no scsi phase changes).
 	 */
 
+	if (data->MsgOutLen <= 0) {
+		nsp_dbg(NSP_DEBUG_MSGOUTOCCUR, "add nop");
+		nsp_build_nop(SCpnt);
+	}
+
 	nsp_dbg(NSP_DEBUG_MSGOUTOCCUR, "msgout loop");
 	do {
-		if (nsp_xfer(SCpnt, BUSPHASE_MESSAGE_OUT)) {
-			nsp_msg(KERN_DEBUG, "msgout: xfer short");
+		tmp = nsp_xfer(SCpnt, BUSPHASE_MESSAGE_OUT);
+
+		if (tmp == 0) {
+			nsp_msg(KERN_DEBUG, "msgout: xfer short, tmp=%d, len=%d", tmp, data->MsgOutLen);
 		}
 
 		/* catch a next signal */
-		ret = nsp_expect_signal(SCpnt, BUSPHASE_MESSAGE_OUT, BUSMON_REQ);
-	} while (ret > 0 && len-- > 0);
-
+		sig = nsp_expect_signal(SCpnt, BUSPHASE_MESSAGE_OUT, BUSMON_REQ);
+	} while (sig > 0 && data->MsgOutLen > 0);
 }
 
 /* end */
-- 
1.2.6

