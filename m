From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 14/22] advansys: Comment/indentation/macro cleanup
Date: Sun,  9 Sep 2007 08:56:39 -0600
Message-ID: <11893498074045-git-send-email-matthew@wil.cx>
References: <20070909145358.GG6809@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:43085 "EHLO
	mail-06.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757309AbXIIO4t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Sep 2007 10:56:49 -0400
In-Reply-To: <20070909145358.GG6809@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

 - Delete comments relating to the previous structure of the driver.
   I have no intention of honouring them ;-)
 - Reformat comments > 80 columns
 - Remove now-obsolete comments from advansys_interrupt
 - Change adv_get_sglist() from do {} while (1) to for (;;)
 - Return void from AscInitQLinkVar()
 - Take out a level of indentation in adv_get_sglist()
 - Reduce indentation level of AscAsyncFix()
 - Remove unused macros
 - Refactor AscSendScsiQueue slightly

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |  379 +++++++++++++----------------------------------
 1 files changed, 101 insertions(+), 278 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 9c5d37d..e5b26a1 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -76,10 +76,6 @@
 /* Enable driver tracing. */
 /* #define ADVANSYS_DEBUG */
 
-/*
- * --- Asc Library Constants and Macros
- */
-
 #define ASC_LIB_VERSION_MAJOR  1
 #define ASC_LIB_VERSION_MINOR  24
 #define ASC_LIB_SERIAL_NUMBER  123
@@ -118,15 +114,10 @@ typedef unsigned char uchar;
 #define FALSE    (0)
 #endif
 
-#define EOF      (-1)
 #define ERR      (-1)
 #define UW_ERR   (uint)(0xFFFF)
 #define isodd_word(val)   ((((uint)val) & (uint)0x0001) != 0)
 
-#define  ASC_DVCLIB_CALL_DONE     (1)
-#define  ASC_DVCLIB_CALL_FAILED   (0)
-#define  ASC_DVCLIB_CALL_ERROR    (-1)
-
 #define PCI_VENDOR_ID_ASP		0x10cd
 #define PCI_DEVICE_ID_ASP_1200A		0x1100
 #define PCI_DEVICE_ID_ASP_ABP940	0x1200
@@ -164,11 +155,10 @@ typedef unsigned char uchar;
 #define ASC_IS_PCMCIA       (0x0008)
 #define ASC_IS_MCA          (0x0020)
 #define ASC_IS_VL           (0x0040)
-#define ASC_ISA_PNP_PORT_ADDR  (0x279)
-#define ASC_ISA_PNP_PORT_WRITE (ASC_ISA_PNP_PORT_ADDR+0x800)
 #define ASC_IS_WIDESCSI_16  (0x0100)
 #define ASC_IS_WIDESCSI_32  (0x0200)
 #define ASC_IS_BIG_ENDIAN   (0x8000)
+
 #define ASC_CHIP_MIN_VER_VL      (0x01)
 #define ASC_CHIP_MAX_VER_VL      (0x07)
 #define ASC_CHIP_MIN_VER_PCI     (0x09)
@@ -187,16 +177,9 @@ typedef unsigned char uchar;
 #define ASC_CHIP_MAX_VER_EISA (0x47)
 #define ASC_CHIP_VER_EISA_BIT (0x40)
 #define ASC_CHIP_LATEST_VER_EISA   ((ASC_CHIP_MIN_VER_EISA - 1) + 3)
-#define ASC_MAX_LIB_SUPPORTED_ISA_CHIP_VER   0x21
-#define ASC_MAX_LIB_SUPPORTED_PCI_CHIP_VER   0x0A
-#define ASC_MAX_VL_DMA_ADDR     (0x07FFFFFFL)
 #define ASC_MAX_VL_DMA_COUNT    (0x07FFFFFFL)
-#define ASC_MAX_PCI_DMA_ADDR    (0xFFFFFFFFL)
 #define ASC_MAX_PCI_DMA_COUNT   (0xFFFFFFFFL)
-#define ASC_MAX_ISA_DMA_ADDR    (0x00FFFFFFL)
 #define ASC_MAX_ISA_DMA_COUNT   (0x00FFFFFFL)
-#define ASC_MAX_EISA_DMA_ADDR   (0x07FFFFFFL)
-#define ASC_MAX_EISA_DMA_COUNT  (0x07FFFFFFL)
 
 #define ASC_SCSI_ID_BITS  3
 #define ASC_SCSI_TIX_TYPE     uchar
@@ -216,24 +199,6 @@ typedef unsigned char uchar;
 #define ASC_MAX_CDB_LEN     12
 #define ADV_MAX_CDB_LEN     16
 
-/*
- * Inquiry SPC-2 SPI Byte 1 EVPD (Enable Vital Product Data)
- * and CmdDt (Command Support Data) field bit definitions.
- */
-#define ADV_INQ_RTN_VPD_AND_CMDDT           0x3
-#define ADV_INQ_RTN_CMDDT_FOR_OP_CODE       0x2
-#define ADV_INQ_RTN_VPD_FOR_PG_CODE         0x1
-#define ADV_INQ_RTN_STD_INQUIRY_DATA        0x0
-
-#define ASC_SCSIDIR_NOCHK    0x00
-#define ASC_SCSIDIR_T2H      0x08
-#define ASC_SCSIDIR_H2T      0x10
-#define ASC_SCSIDIR_NODATA   0x18
-#define SCSI_ASC_NOMEDIA          0x3A
-#define ASC_SRB_HOST(x)  ((uchar)((uchar)(x) >> 4))
-#define ASC_SRB_TID(x)   ((uchar)((uchar)(x) & (uchar)0x0F))
-#define ASC_SRB_LUN(x)   ((uchar)((uint)(x) >> 13))
-#define PUT_CDB1(x)   ((uchar)((uint)(x) >> 8))
 #define MS_SDTR_LEN    0x03
 #define MS_WDTR_LEN    0x02
 
@@ -417,19 +382,6 @@ typedef struct asc_sg_head {
 	ASC_SG_LIST sg_list[ASC_MAX_SG_LIST];
 } ASC_SG_HEAD;
 
-#define ASC_MIN_SG_LIST   2
-
-typedef struct asc_min_sg_head {
-	ushort entry_cnt;
-	ushort queue_cnt;
-	ushort entry_to_copy;
-	ushort res;
-	ASC_SG_LIST sg_list[ASC_MIN_SG_LIST];
-} ASC_MIN_SG_HEAD;
-
-#define QCX_SORT        (0x0001)
-#define QCX_COALEASE    (0x0002)
-
 typedef struct asc_scsi_q {
 	ASC_SCSIQ_1 q1;
 	ASC_SCSIQ_2 q2;
@@ -486,34 +438,9 @@ typedef struct asc_risc_sg_list_q {
 	ASC_SG_LIST sg_list[7];
 } ASC_RISC_SG_LIST_Q;
 
-#define ASC_EXE_SCSI_IO_MAX_IDLE_LOOP  0x1000000UL
-#define ASC_EXE_SCSI_IO_MAX_WAIT_LOOP  1024
-#define ASCQ_ERR_NO_ERROR             0
-#define ASCQ_ERR_IO_NOT_FOUND         1
-#define ASCQ_ERR_LOCAL_MEM            2
-#define ASCQ_ERR_CHKSUM               3
-#define ASCQ_ERR_START_CHIP           4
-#define ASCQ_ERR_INT_TARGET_ID        5
-#define ASCQ_ERR_INT_LOCAL_MEM        6
-#define ASCQ_ERR_HALT_RISC            7
-#define ASCQ_ERR_GET_ASPI_ENTRY       8
-#define ASCQ_ERR_CLOSE_ASPI           9
-#define ASCQ_ERR_HOST_INQUIRY         0x0A
-#define ASCQ_ERR_SAVED_SRB_BAD        0x0B
-#define ASCQ_ERR_QCNTL_SG_LIST        0x0C
 #define ASCQ_ERR_Q_STATUS             0x0D
-#define ASCQ_ERR_WR_SCSIQ             0x0E
-#define ASCQ_ERR_PC_ADDR              0x0F
-#define ASCQ_ERR_SYN_OFFSET           0x10
-#define ASCQ_ERR_SYN_XFER_TIME        0x11
-#define ASCQ_ERR_LOCK_DMA             0x12
-#define ASCQ_ERR_UNLOCK_DMA           0x13
-#define ASCQ_ERR_VDS_CHK_INSTALL      0x14
-#define ASCQ_ERR_MICRO_CODE_HALT      0x15
-#define ASCQ_ERR_SET_LRAM_ADDR        0x16
 #define ASCQ_ERR_CUR_QNG              0x17
 #define ASCQ_ERR_SG_Q_LINKS           0x18
-#define ASCQ_ERR_SCSIQ_PTR            0x19
 #define ASCQ_ERR_ISR_RE_ENTRY         0x1A
 #define ASCQ_ERR_CRITICAL_RE_ENTRY    0x1B
 #define ASCQ_ERR_ISR_ON_CRITICAL      0x1C
@@ -529,7 +456,6 @@ typedef struct asc_risc_sg_list_q {
 #define ASC_WARN_CMD_QNG_CONFLICT     0x0010
 #define ASC_WARN_EEPROM_RECOVER       0x0020
 #define ASC_WARN_CFG_MSW_RECOVER      0x0040
-#define ASC_WARN_SET_PCI_CONFIG_SPACE 0x0080
 
 /*
  * Error code values are set in ASC_DVC_VAR  'err_code'.
@@ -549,27 +475,21 @@ typedef struct asc_risc_sg_list_q {
 #define ASC_IERR_SET_SDTR             0x1000
 #define ASC_IERR_RW_LRAM              0x8000
 
-#define ASC_DEF_IRQ_NO  10
 #define ASC_MAX_IRQ_NO  15
 #define ASC_MIN_IRQ_NO  10
-#define ASC_MIN_REMAIN_Q        (0x02)
 #define ASC_DEF_MAX_TOTAL_QNG   (0xF0)
 #define ASC_MIN_TAG_Q_PER_DVC   (0x04)
-#define ASC_DEF_TAG_Q_PER_DVC   (0x04)
-#define ASC_MIN_FREE_Q        ASC_MIN_REMAIN_Q
+#define ASC_MIN_FREE_Q        (0x02)
 #define ASC_MIN_TOTAL_QNG     ((ASC_MAX_SG_QUEUE)+(ASC_MIN_FREE_Q))
 #define ASC_MAX_TOTAL_QNG 240
 #define ASC_MAX_PCI_ULTRA_INRAM_TOTAL_QNG 16
 #define ASC_MAX_PCI_ULTRA_INRAM_TAG_QNG   8
 #define ASC_MAX_PCI_INRAM_TOTAL_QNG  20
 #define ASC_MAX_INRAM_TAG_QNG   16
-#define ASC_IOADR_TABLE_MAX_IX  11
 #define ASC_IOADR_GAP   0x10
-#define ASC_LIB_SCSIQ_WK_SP        256
 #define ASC_MAX_SYN_XFER_NO        16
 #define ASC_SYN_MAX_OFFSET         0x0F
 #define ASC_DEF_SDTR_OFFSET        0x0F
-#define ASC_DEF_SDTR_INDEX         0x00
 #define ASC_SDTR_ULTRA_PCI_10MB_INDEX  0x02
 #define SYN_XFER_NS_0  25
 #define SYN_XFER_NS_1  30
@@ -648,7 +568,6 @@ typedef struct asc_dvc_cfg {
 #define ASC_DEF_DVC_CNTL       0xFFFF
 #define ASC_DEF_CHIP_SCSI_ID   7
 #define ASC_DEF_ISA_DMA_SPEED  4
-#define ASC_INIT_STATE_NULL          0x0000
 #define ASC_INIT_STATE_BEG_GET_CFG   0x0001
 #define ASC_INIT_STATE_END_GET_CFG   0x0002
 #define ASC_INIT_STATE_BEG_SET_CFG   0x0004
@@ -740,12 +659,7 @@ typedef struct asc_cap_info_array {
 #define ASC_EEP_MAX_DVC_ADDR_VL   15
 #define ASC_EEP_DVC_CFG_BEG      32
 #define ASC_EEP_MAX_DVC_ADDR     45
-#define ASC_EEP_DEFINED_WORDS    10
-#define ASC_EEP_MAX_ADDR         63
-#define ASC_EEP_RES_WORDS         0
 #define ASC_EEP_MAX_RETRY        20
-#define ASC_MAX_INIT_BUSY_RETRY   8
-#define ASC_EEP_ISA_PNP_WSIZE    16
 
 /*
  * These macros keep the chip SCSI id and ISA DMA speed
@@ -781,17 +695,11 @@ typedef struct asceep_config {
 	ushort chksum;
 } ASCEEP_CONFIG;
 
-#define ASC_PCI_CFG_LSW_SCSI_PARITY  0x0800
-#define ASC_PCI_CFG_LSW_BURST_MODE   0x0080
-#define ASC_PCI_CFG_LSW_INTR_ABLE    0x0020
-
 #define ASC_EEP_CMD_READ          0x80
 #define ASC_EEP_CMD_WRITE         0x40
 #define ASC_EEP_CMD_WRITE_ABLE    0x30
 #define ASC_EEP_CMD_WRITE_DISABLE 0x00
 #define ASC_OVERRUN_BSIZE  0x00000048UL
-#define ASC_CTRL_BREAK_ONCE        0x0001
-#define ASC_CTRL_BREAK_STAY_IDLE   0x0002
 #define ASCV_MSGOUT_BEG         0x0000
 #define ASCV_MSGOUT_SDTR_PERIOD (ASCV_MSGOUT_BEG+3)
 #define ASCV_MSGOUT_SDTR_OFFSET (ASCV_MSGOUT_BEG+4)
@@ -1105,7 +1013,6 @@ static int AscPutReadySgListQueue(ASC_DVC_VAR *, ASC_SCSI_Q *, uchar);
 static int AscSetChipSynRegAtID(PortAddr, uchar, uchar);
 static int AscSetRunChipSynRegAtID(PortAddr, uchar, uchar);
 static ushort AscInitLram(ASC_DVC_VAR *);
-static ushort AscInitQLinkVar(ASC_DVC_VAR *);
 static int AscSetLibErrorCode(ASC_DVC_VAR *, ushort);
 static int AscIsrChipHalted(ASC_DVC_VAR *);
 static uchar _AscCopyLramScsiDoneQ(PortAddr, ushort,
@@ -1131,10 +1038,6 @@ static void AscEnableIsaDma(uchar);
 #endif /* CONFIG_ISA */
 static const char *advansys_info(struct Scsi_Host *shost);
 
-/*
- * --- Adv Library Constants and Macros
- */
-
 #define ADV_LIB_VERSION_MAJOR  5
 #define ADV_LIB_VERSION_MINOR  14
 
@@ -1515,10 +1418,6 @@ typedef struct adveep_38C1600_config {
  * EEPROM Commands
  */
 #define ASC_EEP_CMD_DONE             0x0200
-#define ASC_EEP_CMD_DONE_ERR         0x0001
-
-/* cfg_word */
-#define EEP_CFG_WORD_BIG_ENDIAN      0x8000
 
 /* bios_ctrl */
 #define BIOS_CTRL_BIOS               0x0001
@@ -1675,8 +1574,6 @@ typedef struct adveep_38C1600_config {
 #define ADV_CHIP_ID_BYTE         0x25
 #define ADV_CHIP_ID_WORD         0x04C1
 
-#define ADV_SC_SCSI_BUS_RESET    0x2000
-
 #define ADV_INTR_ENABLE_HOST_INTR                   0x01
 #define ADV_INTR_ENABLE_SEL_INTR                    0x02
 #define ADV_INTR_ENABLE_DPR_INTR                    0x04
@@ -1716,8 +1613,6 @@ typedef struct adveep_38C1600_config {
 #define ADV_TICKLE_B                        0x02
 #define ADV_TICKLE_C                        0x03
 
-#define ADV_SCSI_CTRL_RSTOUT        0x2000
-
 #define AdvIsIntPending(port) \
     (AdvReadWordRegister(port, IOPW_CTRL_REG) & ADV_CTRL_REG_HOST_INTR)
 
@@ -1870,14 +1765,11 @@ typedef struct adveep_38C1600_config {
  */
 #define INTAB           0x01
 
-/* a_advlib.h */
-
 /*
  * Adv Library Status Definitions
  */
 #define ADV_TRUE        1
 #define ADV_FALSE       0
-#define ADV_NOERROR     1
 #define ADV_SUCCESS     1
 #define ADV_BUSY        0
 #define ADV_ERROR       (-1)
@@ -1888,7 +1780,6 @@ typedef struct adveep_38C1600_config {
 #define ASC_WARN_BUSRESET_ERROR         0x0001	/* SCSI Bus Reset error */
 #define ASC_WARN_EEPROM_CHKSUM          0x0002	/* EEP check sum error */
 #define ASC_WARN_EEPROM_TERMINATION     0x0004	/* EEP termination bad field */
-#define ASC_WARN_SET_PCI_CONFIG_SPACE   0x0080	/* PCI config space set error */
 #define ASC_WARN_ERROR                  0xFFFF	/* ADV_ERROR return */
 
 #define ADV_MAX_TID                     15	/* max. target identifier */
@@ -2206,10 +2097,8 @@ typedef struct adv_scsi_req_q {
 /*
  * Wait loop time out values.
  */
-#define SCSI_WAIT_10_SEC             10UL	/* 10 seconds */
 #define SCSI_WAIT_100_MSEC           100UL	/* 100 milliseconds */
 #define SCSI_US_PER_MSEC             1000	/* microseconds per millisecond */
-#define SCSI_MS_PER_SEC              1000UL	/* milliseconds per second */
 #define SCSI_MAX_RETRY               10	/* retry count */
 
 #define ADV_ASYNC_RDMA_FAILURE          0x01	/* Fatal RDMA failure. */
@@ -2443,10 +2332,6 @@ do { \
          (sizeof(ADV_SG_BLOCK) * \
           ((ADV_MAX_SG_LIST + (NO_OF_SG_PER_BLOCK - 1))/NO_OF_SG_PER_BLOCK))
 
-/*
- * --- Driver Constants and Macros
- */
-
 /* Reference Scsi_Host hostdata */
 #define ASC_BOARDP(host) ((asc_board_t *) &((host)->hostdata))
 
@@ -2792,10 +2677,6 @@ static ASC_SG_HEAD asc_sg_head = { 0 };
 static int asc_dbglvl = 3;
 #endif /* ADVANSYS_DEBUG */
 
-/*
- * --- Driver Function Prototypes
- */
-
 static int advansys_slave_configure(struct scsi_device *);
 static int asc_execute_scsi_cmnd(struct scsi_cmnd *);
 static int asc_build_req(asc_board_t *, struct scsi_cmnd *);
@@ -3359,17 +3240,9 @@ static struct scsi_host_template advansys_template = {
 };
 
 /*
- * --- Miscellaneous Driver Functions
- */
-
-/*
  * First-level interrupt handler.
  *
- * 'dev_id' is a pointer to the interrupting adapter's asc_board_t. Because
- * all boards are currently checked for interrupts on each interrupt, 'dev_id'
- * is not referenced. 'dev_id' could be used to identify an interrupt passed
- * to the AdvanSys driver which is for a device sharing an interrupt with
- * an AdvanSys adapter.
+ * 'dev_id' is a pointer to the interrupting adapter's Scsi_Host.
  */
 static irqreturn_t advansys_interrupt(int irq, void *dev_id)
 {
@@ -3381,9 +3254,6 @@ static irqreturn_t advansys_interrupt(int irq, void *dev_id)
 	ASC_DBG1(2, "advansys_interrupt: boardp 0x%p\n", boardp);
 	spin_lock_irqsave(&boardp->lock, flags);
 	if (ASC_NARROW_BOARD(boardp)) {
-		/*
-		 * Narrow Board
-		 */
 		if (AscIsIntPending(shost->io_port)) {
 			result = IRQ_HANDLED;
 			ASC_STATS(shost, interrupt);
@@ -3391,23 +3261,14 @@ static irqreturn_t advansys_interrupt(int irq, void *dev_id)
 			AscISR(&boardp->dvc_var.asc_dvc_var);
 		}
 	} else {
-		/*
-		 * Wide Board
-		 */
 		ASC_DBG(1, "advansys_interrupt: before AdvISR()\n");
 		if (AdvISR(&boardp->dvc_var.adv_dvc_var)) {
 			result = IRQ_HANDLED;
 			ASC_STATS(shost, interrupt);
 		}
 	}
-
 	spin_unlock_irqrestore(&boardp->lock, flags);
 
-	/*
-	 * If interrupts were enabled on entry, then they
-	 * are now enabled here.
-	 */
-
 	ASC_DBG(1, "advansys_interrupt: end\n");
 	return result;
 }
@@ -4110,7 +3971,7 @@ adv_get_sglist(asc_board_t *boardp, adv_req_t *reqp, struct scsi_cmnd *scp,
 	prev_sg_block = NULL;
 	reqp->sgblkp = NULL;
 
-	do {
+	for (;;) {
 		/*
 		 * Allocate a 'adv_sgblk_t' structure from the board free
 		 * list. One 'adv_sgblk_t' structure holds NO_OF_SG_PER_BLOCK
@@ -4121,8 +3982,8 @@ adv_get_sglist(asc_board_t *boardp, adv_req_t *reqp, struct scsi_cmnd *scp,
 			ASC_STATS(scp->device->host, adv_build_nosg);
 
 			/*
-			 * Allocation failed. Free 'adv_sgblk_t' structures already
-			 * allocated for the request.
+			 * Allocation failed. Free 'adv_sgblk_t' structures
+			 * already allocated for the request.
 			 */
 			while ((sgblkp = reqp->sgblkp) != NULL) {
 				/* Remove 'sgblkp' from the request list. */
@@ -4133,52 +3994,50 @@ adv_get_sglist(asc_board_t *boardp, adv_req_t *reqp, struct scsi_cmnd *scp,
 				boardp->adv_sgblkp = sgblkp;
 			}
 			return ASC_BUSY;
-		} else {
-			/* Complete 'adv_sgblk_t' board allocation. */
-			boardp->adv_sgblkp = sgblkp->next_sgblkp;
-			sgblkp->next_sgblkp = NULL;
+		}
+
+		/* Complete 'adv_sgblk_t' board allocation. */
+		boardp->adv_sgblkp = sgblkp->next_sgblkp;
+		sgblkp->next_sgblkp = NULL;
+
+		/*
+		 * Get 8 byte aligned virtual and physical addresses
+		 * for the allocated ADV_SG_BLOCK structure.
+		 */
+		sg_block = (ADV_SG_BLOCK *)ADV_8BALIGN(&sgblkp->sg_block);
+		sg_block_paddr = virt_to_bus(sg_block);
+
+		/*
+		 * Check if this is the first 'adv_sgblk_t' for the
+		 * request.
+		 */
+		if (reqp->sgblkp == NULL) {
+			/* Request's first scatter-gather block. */
+			reqp->sgblkp = sgblkp;
 
 			/*
-			 * Get 8 byte aligned virtual and physical addresses for
-			 * the allocated ADV_SG_BLOCK structure.
+			 * Set ADV_SCSI_REQ_T ADV_SG_BLOCK virtual and physical
+			 * address pointers.
 			 */
-			sg_block =
-			    (ADV_SG_BLOCK *)ADV_8BALIGN(&sgblkp->sg_block);
-			sg_block_paddr = virt_to_bus(sg_block);
+			scsiqp->sg_list_ptr = sg_block;
+			scsiqp->sg_real_addr = cpu_to_le32(sg_block_paddr);
+		} else {
+			/* Request's second or later scatter-gather block. */
+			sgblkp->next_sgblkp = reqp->sgblkp;
+			reqp->sgblkp = sgblkp;
 
 			/*
-			 * Check if this is the first 'adv_sgblk_t' for the request.
+			 * Point the previous ADV_SG_BLOCK structure to
+			 * the newly allocated ADV_SG_BLOCK structure.
 			 */
-			if (reqp->sgblkp == NULL) {
-				/* Request's first scatter-gather block. */
-				reqp->sgblkp = sgblkp;
-
-				/*
-				 * Set ADV_SCSI_REQ_T ADV_SG_BLOCK virtual and physical
-				 * address pointers.
-				 */
-				scsiqp->sg_list_ptr = sg_block;
-				scsiqp->sg_real_addr =
-				    cpu_to_le32(sg_block_paddr);
-			} else {
-				/* Request's second or later scatter-gather block. */
-				sgblkp->next_sgblkp = reqp->sgblkp;
-				reqp->sgblkp = sgblkp;
-
-				/*
-				 * Point the previous ADV_SG_BLOCK structure to
-				 * the newly allocated ADV_SG_BLOCK structure.
-				 */
-				prev_sg_block->sg_ptr =
-				    cpu_to_le32(sg_block_paddr);
-			}
+			prev_sg_block->sg_ptr = cpu_to_le32(sg_block_paddr);
 		}
 
 		for (i = 0; i < NO_OF_SG_PER_BLOCK; i++) {
 			sg_block->sg_list[i].sg_addr =
-			    cpu_to_le32(sg_dma_address(slp));
+					cpu_to_le32(sg_dma_address(slp));
 			sg_block->sg_list[i].sg_count =
-			    cpu_to_le32(sg_dma_len(slp));
+					cpu_to_le32(sg_dma_len(slp));
 			ASC_STATS_ADD(scp->device->host, sg_xfer,
 				      ASC_CEILING(sg_dma_len(slp), 512));
 
@@ -4192,8 +4051,6 @@ adv_get_sglist(asc_board_t *boardp, adv_req_t *reqp, struct scsi_cmnd *scp,
 		sg_block->sg_cnt = NO_OF_SG_PER_BLOCK;
 		prev_sg_block = sg_block;
 	}
-	while (1);
-	/* NOTREACHED */
 }
 
 /*
@@ -4264,14 +4121,16 @@ static void asc_isr_callback(ASC_DVC_VAR *asc_dvc_varp, ASC_QDONE_INFO *qdonep)
 				ASC_DBG_PRT_SENSE(2, scp->sense_buffer,
 						  sizeof(scp->sense_buffer));
 				/*
-				 * Note: The 'status_byte()' macro used by target drivers
-				 * defined in scsi.h shifts the status byte returned by
-				 * host drivers right by 1 bit. This is why target drivers
-				 * also use right shifted status byte definitions. For
-				 * instance target drivers use CHECK_CONDITION, defined to
-				 * 0x1, instead of the SCSI defined check condition value
-				 * of 0x2. Host drivers are supposed to return the status
-				 * byte as it is defined by SCSI.
+				 * Note: The 'status_byte()' macro used by
+				 * target drivers defined in scsi.h shifts the
+				 * status byte returned by host drivers right
+				 * by 1 bit.  This is why target drivers also
+				 * use right shifted status byte definitions.
+				 * For instance target drivers use
+				 * CHECK_CONDITION, defined to 0x1, instead of
+				 * the SCSI defined check condition value of
+				 * 0x2. Host drivers are supposed to return
+				 * the status byte as it is defined by SCSI.
 				 */
 				scp->result = DRIVER_BYTE(DRIVER_SENSE) |
 				    STATUS_BYTE(qdonep->d3.scsi_stat);
@@ -4411,14 +4270,16 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 				ASC_DBG_PRT_SENSE(2, scp->sense_buffer,
 						  sizeof(scp->sense_buffer));
 				/*
-				 * Note: The 'status_byte()' macro used by target drivers
-				 * defined in scsi.h shifts the status byte returned by
-				 * host drivers right by 1 bit. This is why target drivers
-				 * also use right shifted status byte definitions. For
-				 * instance target drivers use CHECK_CONDITION, defined to
-				 * 0x1, instead of the SCSI defined check condition value
-				 * of 0x2. Host drivers are supposed to return the status
-				 * byte as it is defined by SCSI.
+				 * Note: The 'status_byte()' macro used by
+				 * target drivers defined in scsi.h shifts the
+				 * status byte returned by host drivers right
+				 * by 1 bit.  This is why target drivers also
+				 * use right shifted status byte definitions.
+				 * For instance target drivers use
+				 * CHECK_CONDITION, defined to 0x1, instead of
+				 * the SCSI defined check condition value of
+				 * 0x2. Host drivers are supposed to return
+				 * the status byte as it is defined by SCSI.
 				 */
 				scp->result = DRIVER_BYTE(DRIVER_SENSE) |
 				    STATUS_BYTE(scsiqp->scsi_status);
@@ -5719,10 +5580,6 @@ static int asc_prt_line(char *buf, int buflen, char *fmt, ...)
 #endif /* CONFIG_PROC_FS */
 
 /*
- * --- Functions Required by the Asc Library
- */
-
-/*
  * void
  * DvcPutScsiQ(PortAddr iop_base, ushort s_addr, uchar *outbuf, int words)
  *
@@ -5815,10 +5672,6 @@ AscGetChipBiosAddress(PortAddr iop_base, unsigned short bus_type)
 }
 
 /*
- * --- Functions Required by the Adv Library
- */
-
-/*
  * DvcGetPhyAddr()
  *
  * Return the physical address of 'vaddr' and set '*lenp' to the
@@ -5845,10 +5698,6 @@ DvcGetPhyAddr(ADV_DVC_VAR *asc_dvc, ADV_SCSI_REQ_Q *scsiq,
 	return paddr;
 }
 
-/*
- * --- Tracing and Debugging Functions
- */
-
 #ifdef ADVANSYS_STATS
 #ifdef CONFIG_PROC_FS
 /*
@@ -6322,10 +6171,6 @@ static void asc_prt_hex(char *f, uchar *s, int l)
 }
 #endif /* ADVANSYS_DEBUG */
 
-/*
- * --- Asc Library Functions
- */
-
 static ushort __devinit AscGetEisaChipCfg(PortAddr iop_base)
 {
 	PortAddr eisa_cfg_iop;
@@ -6537,8 +6382,7 @@ static int AscIsrChipHalted(ASC_DVC_VAR *asc_dvc)
 	target_ix = AscReadLramByte(iop_base,
 				    (ushort)(halt_q_addr +
 					     (ushort)ASC_SCSIQ_B_TARGET_IX));
-	q_cntl =
-	    AscReadLramByte(iop_base,
+	q_cntl = AscReadLramByte(iop_base,
 			    (ushort)(halt_q_addr + (ushort)ASC_SCSIQ_B_CNTL));
 	tid_no = ASC_TIX_TO_TID(target_ix);
 	target_id = (uchar)ASC_TID_TO_TARGET_ID(tid_no);
@@ -6562,7 +6406,6 @@ static int AscIsrChipHalted(ASC_DVC_VAR *asc_dvc)
 		AscWriteLramWord(iop_base, ASCV_HALTCODE_W, 0);
 		return (0);
 	} else if (int_halt_code == ASC_HALT_EXTMSG_IN) {
-
 		AscMemWordCopyPtrFromLram(iop_base,
 					  ASCV_MSGIN_BEG,
 					  (uchar *)&ext_msg,
@@ -6793,9 +6636,9 @@ static int AscIsrChipHalted(ASC_DVC_VAR *asc_dvc)
 							 cur_dvc_qng);
 
 					/*
-					 * Set the device queue depth to the number of
-					 * active requests when the QUEUE FULL condition
-					 * was encountered.
+					 * Set the device queue depth to the
+					 * number of active requests when the
+					 * QUEUE FULL condition was encountered.
 					 */
 					boardp->queue_full |= target_id;
 					boardp->queue_full_cnt[tid_no] =
@@ -6821,9 +6664,8 @@ static int AscIsrChipHalted(ASC_DVC_VAR *asc_dvc)
 		int i;
 
 		q_no = AscReadLramByte(iop_base, (ushort)ASCV_REQ_SG_LIST_QP);
-		if (q_no == ASC_QLINK_END) {
-			return (0);
-		}
+		if (q_no == ASC_QLINK_END)
+			return 0;
 
 		q_addr = ASC_QNO_TO_QADDR(q_no);
 
@@ -6875,8 +6717,8 @@ static int AscIsrChipHalted(ASC_DVC_VAR *asc_dvc)
 			sg_entry_cnt = ASC_MAX_SG_LIST - 1;
 
 			/*
-			 * Keep track of remaining number of SG elements that will
-			 * need to be handled on the next interrupt.
+			 * Keep track of remaining number of SG elements that
+			 * will need to be handled on the next interrupt.
 			 */
 			scsiq->remain_sg_entry_cnt -= (ASC_MAX_SG_LIST - 1);
 		} else {
@@ -7723,36 +7565,28 @@ AscSendScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq, uchar n_q_required)
 	sta = 0;
 	free_q_head = (uchar)AscGetVarFreeQHead(iop_base);
 	if (n_q_required > 1) {
-		if ((next_qp = AscAllocMultipleFreeQueue(iop_base,
-							 free_q_head, (uchar)
-							 (n_q_required)))
-		    != (uchar)ASC_QLINK_END) {
+		next_qp = AscAllocMultipleFreeQueue(iop_base, free_q_head,
+						    (uchar)n_q_required);
+		if (next_qp != ASC_QLINK_END) {
 			asc_dvc->last_q_shortage = 0;
 			scsiq->sg_head->queue_cnt = n_q_required - 1;
 			scsiq->q1.q_no = free_q_head;
-			if ((sta = AscPutReadySgListQueue(asc_dvc, scsiq,
-							  free_q_head)) == 1) {
-				AscPutVarFreeQHead(iop_base, next_qp);
-				asc_dvc->cur_total_qng += (uchar)(n_q_required);
-				asc_dvc->cur_dvc_qng[tid_no]++;
-			}
-			return (sta);
+			sta = AscPutReadySgListQueue(asc_dvc, scsiq,
+						     free_q_head);
 		}
 	} else if (n_q_required == 1) {
-		if ((next_qp = AscAllocFreeQueue(iop_base,
-						 free_q_head)) !=
-		    ASC_QLINK_END) {
+		next_qp = AscAllocFreeQueue(iop_base, free_q_head);
+		if (next_qp != ASC_QLINK_END) {
 			scsiq->q1.q_no = free_q_head;
-			if ((sta = AscPutReadyQueue(asc_dvc, scsiq,
-						    free_q_head)) == 1) {
-				AscPutVarFreeQHead(iop_base, next_qp);
-				asc_dvc->cur_total_qng++;
-				asc_dvc->cur_dvc_qng[tid_no]++;
-			}
-			return (sta);
+			sta = AscPutReadyQueue(asc_dvc, scsiq, free_q_head);
 		}
 	}
-	return (sta);
+	if (sta == 1) {
+		AscPutVarFreeQHead(iop_base, next_qp);
+		asc_dvc->cur_total_qng += (uchar)(n_q_required);
+		asc_dvc->cur_dvc_qng[tid_no]++;
+	}
+	return sta;
 }
 
 static int AscSgListToQueue(int sg_list)
@@ -8072,7 +7906,7 @@ static ushort AscInitLram(ASC_DVC_VAR *asc_dvc)
 	return (warn_code);
 }
 
-static ushort AscInitQLinkVar(ASC_DVC_VAR *asc_dvc)
+static void AscInitQLinkVar(ASC_DVC_VAR *asc_dvc)
 {
 	PortAddr iop_base;
 	int i;
@@ -8099,7 +7933,6 @@ static ushort AscInitQLinkVar(ASC_DVC_VAR *asc_dvc)
 	for (i = 0; i < 32; i++, lram_addr += 2) {
 		AscWriteLramWord(iop_base, lram_addr, 0);
 	}
-	return (0);
 }
 
 static int AscSetLibErrorCode(ASC_DVC_VAR *asc_dvc, ushort err_code)
@@ -8396,10 +8229,10 @@ static int AscResetChipAndScsiBus(ASC_DVC_VAR *asc_dvc)
 static ASC_DCNT __devinit AscGetMaxDmaCount(ushort bus_type)
 {
 	if (bus_type & ASC_IS_ISA)
-		return (ASC_MAX_ISA_DMA_COUNT);
+		return ASC_MAX_ISA_DMA_COUNT;
 	else if (bus_type & (ASC_IS_EISA | ASC_IS_VL))
-		return (ASC_MAX_VL_DMA_COUNT);
-	return (ASC_MAX_PCI_DMA_COUNT);
+		return ASC_MAX_VL_DMA_COUNT;
+	return ASC_MAX_PCI_DMA_COUNT;
 }
 
 #ifdef CONFIG_ISA
@@ -9262,26 +9095,22 @@ static void AscAsyncFix(ASC_DVC_VAR *asc_dvc, struct scsi_device *sdev)
 	char type = sdev->type;
 	ASC_SCSI_BIT_ID_TYPE tid_bits = 1 << sdev->id;
 
-	if (asc_dvc->bug_fix_cntl & ASC_BUG_FIX_ASYN_USE_SYN) {
-		if (!(asc_dvc->init_sdtr & tid_bits)) {
-			if ((type == TYPE_ROM) &&
-			    (strncmp(sdev->vendor, "HP ", 3) == 0)) {
-				asc_dvc->pci_fix_asyn_xfer_always |= tid_bits;
-			}
-			asc_dvc->pci_fix_asyn_xfer |= tid_bits;
-			if ((type == TYPE_PROCESSOR) ||
-			    (type == TYPE_SCANNER) || (type == TYPE_ROM) ||
-			    (type == TYPE_TAPE)) {
-				asc_dvc->pci_fix_asyn_xfer &= ~tid_bits;
-			}
+	if (!(asc_dvc->bug_fix_cntl & ASC_BUG_FIX_ASYN_USE_SYN))
+		return;
+	if (asc_dvc->init_sdtr & tid_bits)
+		return;
+
+	if ((type == TYPE_ROM) && (strncmp(sdev->vendor, "HP ", 3) == 0))
+		asc_dvc->pci_fix_asyn_xfer_always |= tid_bits;
+
+	asc_dvc->pci_fix_asyn_xfer |= tid_bits;
+	if ((type == TYPE_PROCESSOR) || (type == TYPE_SCANNER) ||
+	    (type == TYPE_ROM) || (type == TYPE_TAPE))
+		asc_dvc->pci_fix_asyn_xfer &= ~tid_bits;
 
-			if (asc_dvc->pci_fix_asyn_xfer & tid_bits) {
-				AscSetRunChipSynRegAtID(asc_dvc->iop_base,
-					sdev->id,
+	if (asc_dvc->pci_fix_asyn_xfer & tid_bits)
+		AscSetRunChipSynRegAtID(asc_dvc->iop_base, sdev->id,
 					ASYN_SDTR_DATA_FIX_PCI_REV_AB);
-			}
-		}
-	}
 }
 
 static uchar AscReadLramByte(PortAddr iop_base, ushort addr)
@@ -9443,12 +9272,6 @@ AscMemWordSetLram(PortAddr iop_base, ushort s_addr, ushort set_wval, int words)
 	return;
 }
 
-/*
- * --- Adv Library Functions
- */
-
-/* a_mcode.h */
-
 /* Microcode buffer is kept after initialization for error recovery. */
 static unsigned char _adv_asc3550_buf[] = {
 	0x00, 0x00, 0x00, 0xf2, 0x00, 0xf0, 0x00, 0x16, 0x18, 0xe4, 0x00, 0xfc,
@@ -13773,7 +13596,6 @@ AdvSet38C1600EEPConfig(AdvPortAddr iop_base, ADVEEP_38C1600_CONFIG *cfg_buf)
 	return;
 }
 
-/* a_advlib.c */
 /*
  * AdvExeScsiQueue() - Send a request to the RISC microcode program.
  *
@@ -14198,7 +14020,6 @@ AdvSendIdleCmd(ADV_DVC_VAR *asc_dvc,
 	 * Clear the idle command status which is set by the microcode
 	 * to a non-zero value to indicate when the command is completed.
 	 * The non-zero result is one of the IDLE_CMD_STATUS_* values
-	 * defined in a_advlib.h.
 	 */
 	AdvWriteWordLram(iop_base, ASC_MC_IDLE_CMD_STATUS, (ushort)0);
 
@@ -14921,6 +14742,8 @@ static int advansys_release(struct Scsi_Host *shost)
 	return 0;
 }
 
+#define ASC_IOADR_TABLE_MAX_IX  11
+
 static PortAddr _asc_def_iop_base[ASC_IOADR_TABLE_MAX_IX] __devinitdata = {
 	0x100, 0x0110, 0x120, 0x0130, 0x140, 0x0150, 0x0190,
 	0x0210, 0x0230, 0x0250, 0x0330
-- 
1.5.2.4

