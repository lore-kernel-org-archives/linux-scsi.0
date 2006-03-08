From: akpm@osdl.org
Subject: [patch 06/28] drivers/scsi/FlashPoint.c: remove unused things
Date: Wed, 08 Mar 2006 00:14:22 -0800
Message-ID: <200603080816.k288GCa4002166@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:22444 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1752097AbWCHIQS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2006 03:16:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, adobriyan@gmail.com


From: Alexey Dobriyan <adobriyan@gmail.com>

* Remove unused #define's
* Remove unused typedefs.
* Remove prototypes for non-existing functions.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/FlashPoint.c |  351 ------------------------------------
 1 files changed, 4 insertions(+), 347 deletions(-)

diff -puN drivers/scsi/FlashPoint.c~drivers-scsi-flashpointc-remove-unused-things drivers/scsi/FlashPoint.c
--- 25/drivers/scsi/FlashPoint.c~drivers-scsi-flashpointc-remove-unused-things	Mon Feb  6 14:49:55 2006
+++ 25-akpm/drivers/scsi/FlashPoint.c	Mon Feb  6 14:49:55 2006
@@ -47,15 +47,10 @@
 #define SccbMgr_isr			FlashPoint_HandleInterrupt
 
 
-#define MAX_CDBLEN  12
 
-#define SCAM_LEV_2	1
 
 #define CRCMASK	0xA001
 
-#define     BL_VENDOR_ID      0x104B
-#define     FP_DEVICE_ID      0x8130
-#define     MM_DEVICE_ID      0x1040
 
 
 #define FAILURE         0xFFFFFFFFL
@@ -65,15 +60,9 @@ typedef unsigned char   UCHAR;
 typedef unsigned short  USHORT;
 typedef unsigned int    UINT;
 typedef unsigned long   ULONG;
-typedef unsigned char * PUCHAR;
-typedef unsigned short* PUSHORT;
-typedef unsigned long * PULONG;
-typedef void *          PVOID;
 
 
-typedef unsigned char           * uchar_ptr;
 typedef unsigned short          * ushort_ptr;
-typedef unsigned long           * ulong_ptr;
 
 
 #define s08bits	char
@@ -84,9 +73,6 @@ typedef unsigned long           * ulong_
 #define u16bits	unsigned s16bits
 #define u32bits	unsigned s32bits
 
-typedef u08bits 	* pu08bits;
-typedef u16bits 	* pu16bits;
-typedef u32bits 	* pu32bits;
 
 
 #define BIT(x)          ((UCHAR)(1<<(x)))    /* single-bit mask in bit position x */
@@ -144,10 +130,6 @@ typedef SCCBMGR_INFO *      PSCCBMGR_INF
 #define HARPOON_FAMILY        0x02
 
 
-#define ISA_BUS_CARD          0x01
-#define EISA_BUS_CARD         0x02
-#define PCI_BUS_CARD          0x03
-#define VESA_BUS_CARD         0x04
 
 /* SCCB struct used for both SCCB and UCB manager compiles! 
  * The UCB Manager treats the SCCB as it's 'native hardware structure' 
@@ -200,14 +182,11 @@ typedef struct _SCCB {
    ULONG   Sccb_SGoffset;
    } SCCB;
 
-#define SCCB_SIZE sizeof(SCCB)
 
 #pragma pack()
 
 
 
-#define SCSI_INITIATOR_COMMAND    0x00
-#define TARGET_MODE_COMMAND       0x01
 #define SCATTER_GATHER_COMMAND    0x02
 #define RESIDUAL_COMMAND          0x03
 #define RESIDUAL_SG_COMMAND       0x04
@@ -216,12 +195,10 @@ typedef struct _SCCB {
 
 #define F_USE_CMD_Q              0x20     /*Inidcates TAGGED command. */
 #define TAG_TYPE_MASK            0xC0     /*Type of tag msg to send. */
-#define TAG_Q_MASK               0xE0
 #define SCCB_DATA_XFER_OUT       0x10     /* Write */
 #define SCCB_DATA_XFER_IN        0x08     /* Read */
 
 
-#define FOURTEEN_BYTES           0x00     /* Request Sense Buffer size */
 #define NO_AUTO_REQUEST_SENSE    0x01     /* No Request Sense Buffer */
 
 
@@ -235,9 +212,7 @@ typedef struct _SCCB {
 #define DATA_OUT_ST     7
 #define DATA_IN_ST      8
 #define DISCONNECT_ST   9
-#define STATUS_ST       10
 #define ABORT_ST        11
-#define MESSAGE_ST      12
 
 
 #define F_HOST_XFER_DIR                0x01
@@ -249,7 +224,6 @@ typedef struct _SCCB {
 
 
 #define F_STATUSLOADED                 0x01
-#define F_MSGLOADED                    0x02
 #define F_DEV_SELECTED                 0x04
 
 
@@ -257,56 +231,39 @@ typedef struct _SCCB {
 #define SCCB_DATA_UNDER_RUN         0x0C
 #define SCCB_SELECTION_TIMEOUT      0x11  /* Set SCSI selection timed out */
 #define SCCB_DATA_OVER_RUN          0x12
-#define SCCB_UNEXPECTED_BUS_FREE    0x13  /* Target dropped SCSI BSY */
 #define SCCB_PHASE_SEQUENCE_FAIL    0x14  /* Target bus phase sequence failure */
 
-#define SCCB_INVALID_OP_CODE        0x16  /* SCCB invalid operation code */
-#define SCCB_INVALID_SCCB           0x1A  /* Invalid SCCB - bad parameter */
 #define SCCB_GROSS_FW_ERR           0x27  /* Major problem! */
 #define SCCB_BM_ERR                 0x30  /* BusMaster error. */
 #define SCCB_PARITY_ERR             0x34  /* SCSI parity error */
 
 
 
-#define SCCB_INVALID_DIRECTION      0x18  /* Invalid target direction */
-#define SCCB_DUPLICATE_SCCB         0x19  /* Duplicate SCCB */
-#define SCCB_SCSI_RST               0x35  /* SCSI RESET detected. */
 
 
 #define SCCB_IN_PROCESS            0x00
 #define SCCB_SUCCESS               0x01
 #define SCCB_ABORT                 0x02
-#define SCCB_NOT_FOUND             0x03
 #define SCCB_ERROR                 0x04
-#define SCCB_INVALID               0x05
 
-#define SCCB_SIZE sizeof(SCCB)
 
 
 #define  ORION_FW_REV      3110
 
-#define HARP_REVD    1
 
 
 #define QUEUE_DEPTH     254+1            /*1 for Normal disconnect 32 for Q'ing. */
 
 #define	MAX_MB_CARDS	4					/* Max. no of cards suppoerted on Mother Board */
 
-#define WIDE_SCSI       1
 
 #define MAX_SCSI_TAR    16
 #define MAX_LUN         32
 #define LUN_MASK			0x1f
 
-#if defined(HARP_REVA)
-#define SG_BUF_CNT      15             /*Number of prefetched elements. */
-#else
 #define SG_BUF_CNT      16             /*Number of prefetched elements. */
-#endif
 
 #define SG_ELEMENT_SIZE 8              /*Eight byte per element. */
-#define SG_LOCAL_MASK   0x00000000L
-#define SG_ELEMENT_MASK 0xFFFFFFFFL
 
 
 #define RD_HARPOON(ioport)          OS_InPortByte((u32bits)ioport)
@@ -318,31 +275,25 @@ typedef struct _SCCB {
 
 
 #define  TAR_SYNC_MASK     (BIT(7)+BIT(6))
-#define  SYNC_UNKNOWN      0x00
 #define  SYNC_TRYING               BIT(6)
 #define  SYNC_SUPPORTED    (BIT(7)+BIT(6))
 
 #define  TAR_WIDE_MASK     (BIT(5)+BIT(4))
-#define  WIDE_DISABLED     0x00
 #define  WIDE_ENABLED              BIT(4)
 #define  WIDE_NEGOCIATED   BIT(5)
 
 #define  TAR_TAG_Q_MASK    (BIT(3)+BIT(2))
-#define  TAG_Q_UNKNOWN     0x00
 #define  TAG_Q_TRYING              BIT(2)
 #define  TAG_Q_REJECT      BIT(3)
-#define  TAG_Q_SUPPORTED   (BIT(3)+BIT(2))
 
 #define  TAR_ALLOW_DISC    BIT(0)
 
 
 #define  EE_SYNC_MASK      (BIT(0)+BIT(1))
-#define  EE_SYNC_ASYNC     0x00
 #define  EE_SYNC_5MB       BIT(0)
 #define  EE_SYNC_10MB      BIT(1)
 #define  EE_SYNC_20MB      (BIT(0)+BIT(1))
 
-#define  EE_ALLOW_DISC     BIT(6)
 #define  EE_WIDE_SCSI      BIT(7)
 
 
@@ -418,7 +369,6 @@ typedef struct SCCBcard *PSCCBcard;
 #define  ID_STRING_LENGTH  32
 #define  TYPE_CODE0        0x63           /*Level2 Mstr (bits 7-6),  */
 
-#define  TYPE_CODE1        00             /*No ID yet */
 
 #define  SLV_TYPE_CODE0    0xA3           /*Priority Bit set (bits 7-6),  */
 
@@ -430,16 +380,9 @@ typedef struct SCCBcard *PSCCBcard;
 
 #define  ID_0_7      0x18
 #define  ID_8_F      0x11
-#define  ID_10_17    0x12
-#define  ID_18_1F    0x0B
 #define  MISC_CODE   0x14
 #define  CLR_P_FLAG  0x18
-#define  LOCATE_ON   0x12
-#define  LOCATE_OFF  0x0B
 
-#define  LVL_1_MST   0x00
-#define  LVL_2_MST   0x40
-#define  DOM_LVL_2   0xC0
 
 
 #define  INIT_SELTD  0x01
@@ -455,64 +398,24 @@ typedef struct SCCBscam_info {
    UCHAR    id_string[ID_STRING_LENGTH];
    enum scam_id_st state;
     
-} SCCBSCAM_INFO, *PSCCBSCAM_INFO;
+} SCCBSCAM_INFO;
 
 
-#define  SCSI_TEST_UNIT_READY    0x00
-#define  SCSI_REZERO_UNIT        0x01
 #define  SCSI_REQUEST_SENSE      0x03
-#define  SCSI_FORMAT_UNIT        0x04
-#define  SCSI_REASSIGN           0x07
 #define  SCSI_READ               0x08
 #define  SCSI_WRITE              0x0A
-#define  SCSI_SEEK               0x0B
-#define  SCSI_INQUIRY            0x12
-#define  SCSI_MODE_SELECT        0x15
-#define  SCSI_RESERVE_UNIT       0x16
-#define  SCSI_RELEASE_UNIT       0x17
-#define  SCSI_MODE_SENSE         0x1A
 #define  SCSI_START_STOP_UNIT    0x1B
-#define  SCSI_SEND_DIAGNOSTIC    0x1D
-#define  SCSI_READ_CAPACITY      0x25
 #define  SCSI_READ_EXTENDED      0x28
 #define  SCSI_WRITE_EXTENDED     0x2A
-#define  SCSI_SEEK_EXTENDED      0x2B
 #define  SCSI_WRITE_AND_VERIFY   0x2E
-#define  SCSI_VERIFY             0x2F
-#define  SCSI_READ_DEFECT_DATA   0x37
-#define  SCSI_WRITE_BUFFER       0x3B
-#define  SCSI_READ_BUFFER        0x3C
-#define  SCSI_RECV_DIAGNOSTIC    0x1C
-#define  SCSI_READ_LONG          0x3E
-#define  SCSI_WRITE_LONG         0x3F
-#define  SCSI_LAST_SCSI_CMND     SCSI_WRITE_LONG
-#define  SCSI_INVALID_CMND       0xFF
 
 
 
 #define  SSGOOD                  0x00
 #define  SSCHECK                 0x02
-#define  SSCOND_MET              0x04
-#define  SSBUSY                  0x08
-#define  SSRESERVATION_CONFLICT  0x18
-#define  SSCMD_TERM              0x22
 #define  SSQ_FULL                0x28
 
 
-#define  SKNO_SEN                0x00
-#define  SKRECOV_ERR             0x01
-#define  SKNOT_RDY               0x02
-#define  SKMED_ERR               0x03
-#define  SKHW_ERR                0x04
-#define  SKILL_REQ               0x05
-#define  SKUNIT_ATTN             0x06
-#define  SKDATA_PROTECT          0x07
-#define  SKBLNK_CHK              0x08
-#define  SKCPY_ABORT             0x0A
-#define  SKABORT_CMD             0x0B
-#define  SKEQUAL                 0x0C
-#define  SKVOL_OVF               0x0D
-#define  SKMIS_CMP               0x0E
 
 
 #define  SMCMD_COMP              0x00
@@ -520,7 +423,6 @@ typedef struct SCCBscam_info {
 #define  SMSAVE_DATA_PTR         0x02
 #define  SMREST_DATA_PTR         0x03
 #define  SMDISC                  0x04
-#define  SMINIT_DETEC_ERR        0x05
 #define  SMABORT                 0x06
 #define  SMREJECT                0x07
 #define  SMNO_OP                 0x08
@@ -535,35 +437,22 @@ typedef struct SCCBscam_info {
 
 
 #define  SMSYNC                  0x01
-#define  SM10MBS                 0x19     /* 100ns           */
-#define  SM5MBS                  0x32     /* 200ns           */
-#define  SMOFFSET                0x0F     /* Maxoffset value */
 #define  SMWDTR                  0x03
 #define  SM8BIT                  0x00
 #define  SM16BIT                 0x01
-#define  SM32BIT                 0x02
 #define  SMIGNORWR               0x23     /* Ignore Wide Residue */
 
 
-#define  ARBITRATION_DELAY       0x01     /* 2.4us using a 40Mhz clock */
-#define  BUS_SETTLE_DELAY        0x01     /* 400ns */
-#define  BUS_CLEAR_DELAY         0x01     /* 800ns */
 
 
 
-#define  SPHASE_TO               0x0A  /* 10 second timeout waiting for */
-#define  SCMD_TO                 0x0F  /* Overall command timeout */
 
 
 
 #define  SIX_BYTE_CMD            0x06
-#define  TEN_BYTE_CMD            0x0A
 #define  TWELVE_BYTE_CMD         0x0C
 
 #define  ASYNC                   0x00
-#define  PERI25NS                0x06  /* 25/4ns to next clock for xbow. */
-#define  SYNC10MBS               0x19
-#define  SYNC5MBS                0x32
 #define  MAX_OFFSET              0x0F  /* Maxbyteoffset for Sync Xfers */
 
 
@@ -572,19 +461,11 @@ typedef struct SCCBscam_info {
 #define  EEPROM_CHECK_SUM  0
 #define  FW_SIGNATURE      2
 #define  MODEL_NUMB_0      4
-#define  MODEL_NUMB_1      5
 #define  MODEL_NUMB_2      6
-#define  MODEL_NUMB_3      7
 #define  MODEL_NUMB_4      8
-#define  MODEL_NUMB_5      9
-#define  IO_BASE_ADDR      10
-#define  IRQ_NUMBER        12
-#define  PCI_INT_PIN       13
-#define  BUS_DELAY         14       /*On time in byte 14 off delay in 15 */
 #define  SYSTEM_CONFIG     16
 #define  SCSI_CONFIG       17
 #define  BIOS_CONFIG       18
-#define  SPIN_UP_DELAY     19
 #define  SCAM_CONFIG       20
 #define  ADAPTER_SCSI_ID   24
 
@@ -609,7 +490,6 @@ typedef struct SCCBscam_info {
 
 
 
-   #define  DOM_MASTER     (BIT(0) + BIT(1))
    #define  SCAM_ENABLED   BIT(2)
    #define  SCAM_LEVEL2    BIT(3)
 
@@ -644,16 +524,9 @@ typedef struct SCCBscam_info {
 	/* Sub Vendor ID and Sub Device ID only available in
 		Harpoon Version 2 and higher */
 
-   #define  hp_sub_vendor_id_0   0x04		/* LSB */
-   #define  hp_sub_vendor_id_1   0x05		/* MSB */
    #define  hp_sub_device_id_0   0x06		/* LSB */
-   #define  hp_sub_device_id_1   0x07		/* MSB */
 
 
-   #define  hp_dual_addr_lo      0x08
-   #define  hp_dual_addr_lmi     0x09
-   #define  hp_dual_addr_hmi     0x0A
-   #define  hp_dual_addr_hi      0x0B
 
    #define  hp_semaphore         0x0C
       #define SCCB_MGR_ACTIVE    BIT(0)
@@ -661,9 +534,7 @@ typedef struct SCCBscam_info {
       #define SCCB_MGR_PRESENT   BIT(3)
       #define BIOS_IN_USE        BIT(4)
 
-   #define  hp_user_defined_D    0x0D
 
-   #define  hp_reserved_E        0x0E
 
    #define  hp_sys_ctrl          0x0F
 
@@ -671,95 +542,49 @@ typedef struct SCCBscam_info {
       #define  DRVR_RST          BIT(1)      /*Firmware Reset to 80C15 chip */
       #define  HALT_MACH         BIT(3)      /*Halt State Machine      */
       #define  HARD_ABORT        BIT(4)      /*Hard Abort              */
-      #define  DIAG_MODE         BIT(5)      /*Diagnostic Mode         */
 
-      #define  BM_ABORT_TMOUT    0x50        /*Halt State machine time out */
 
-   #define  hp_sys_cfg           0x10
 
-      #define  DONT_RST_FIFO     BIT(7)      /*Don't reset FIFO      */
 
 
-   #define  hp_host_ctrl0        0x11
 
-      #define  DUAL_ADDR_MODE    BIT(0)   /*Enable 64-bit addresses */
-      #define  IO_MEM_SPACE      BIT(1)   /*I/O Memory Space    */
-      #define  RESOURCE_LOCK     BIT(2)   /*Enable Resource Lock */
-      #define  IGNOR_ACCESS_ERR  BIT(3)   /*Ignore Access Error */
-      #define  HOST_INT_EDGE     BIT(4)   /*Host interrupt level/edge mode sel */
-      #define  SIX_CLOCKS        BIT(5)   /*6 Clocks between Strobe   */
-      #define  DMA_EVEN_PARITY   BIT(6)   /*Enable DMA Enen Parity */
 
-/*
-      #define  BURST_MODE        BIT(0)
-*/
 
-   #define  hp_reserved_12       0x12
 
    #define  hp_host_blk_cnt      0x13
 
-      #define  XFER_BLK1         0x00     /*     0 0 0  1 byte per block*/
-      #define  XFER_BLK2         0x01     /*     0 0 1  2 byte per block*/
-      #define  XFER_BLK4         0x02     /*     0 1 0  4 byte per block*/
-      #define  XFER_BLK8         0x03     /*     0 1 1  8 byte per block*/
-      #define  XFER_BLK16        0x04     /*     1 0 0 16 byte per block*/
-      #define  XFER_BLK32        0x05     /*     1 0 1 32 byte per block*/
       #define  XFER_BLK64        0x06     /*     1 1 0 64 byte per block*/
    
       #define  BM_THRESHOLD      0x40     /* PCI mode can only xfer 16 bytes*/
 
 
-   #define  hp_reserved_14       0x14
-   #define  hp_reserved_15       0x15
-   #define  hp_reserved_16       0x16
 
    #define  hp_int_mask          0x17
 
       #define  INT_CMD_COMPL     BIT(0)   /* DMA command complete   */
       #define  INT_EXT_STATUS    BIT(1)   /* Extended Status Set    */
-      #define  INT_SCSI          BIT(2)   /* Scsi block interrupt   */
-      #define  INT_FIFO_RDY      BIT(4)   /* FIFO data ready        */
 
 
    #define  hp_xfer_cnt_lo       0x18
-   #define  hp_xfer_cnt_mi       0x19
    #define  hp_xfer_cnt_hi       0x1A
    #define  hp_xfer_cmd          0x1B
 
       #define  XFER_HOST_DMA     0x00     /*     0 0 0 Transfer Host -> DMA */
       #define  XFER_DMA_HOST     0x01     /*     0 0 1 Transfer DMA  -> Host */
-      #define  XFER_HOST_MPU     0x02     /*     0 1 0 Transfer Host -> MPU  */
-      #define  XFER_MPU_HOST     0x03     /*     0 1 1 Transfer MPU  -> Host */
-      #define  XFER_DMA_MPU      0x04     /*     1 0 0 Transfer DMA  -> MPU  */
-      #define  XFER_MPU_DMA      0x05     /*     1 0 1 Transfer MPU  -> DMA  */
-      #define  SET_SEMAPHORE     0x06     /*     1 1 0 Set Semaphore         */
-      #define  XFER_NOP          0x07     /*     1 1 1 Transfer NOP          */
-      #define  XFER_MB_MPU       0x06     /*     1 1 0 Transfer MB -> MPU */
-      #define  XFER_MB_DMA       0x07     /*     1 1 1 Transfer MB -> DMA */
 
 
       #define  XFER_HOST_AUTO    0x00     /*     0 0 Auto Transfer Size   */
-      #define  XFER_HOST_8BIT    0x08     /*     0 1 8 BIT Transfer Size  */
-      #define  XFER_HOST_16BIT   0x10     /*     1 0 16 BIT Transfer Size */
-      #define  XFER_HOST_32BIT   0x18     /*     1 1 32 BIT Transfer Size */
 
       #define  XFER_DMA_8BIT     0x20     /*     0 1 8 BIT  Transfer Size */
-      #define  XFER_DMA_16BIT    0x40     /*     1 0 16 BIT Transfer Size */
 
       #define  DISABLE_INT       BIT(7)   /*Do not interrupt at end of cmd. */
 
       #define  HOST_WRT_CMD      ((DISABLE_INT + XFER_HOST_DMA + XFER_HOST_AUTO + XFER_DMA_8BIT))
       #define  HOST_RD_CMD       ((DISABLE_INT + XFER_DMA_HOST + XFER_HOST_AUTO + XFER_DMA_8BIT))
-      #define  WIDE_HOST_WRT_CMD ((DISABLE_INT + XFER_HOST_DMA + XFER_HOST_AUTO + XFER_DMA_16BIT))
-      #define  WIDE_HOST_RD_CMD  ((DISABLE_INT + XFER_DMA_HOST + XFER_HOST_AUTO + XFER_DMA_16BIT))
 
    #define  hp_host_addr_lo      0x1C
-   #define  hp_host_addr_lmi     0x1D
    #define  hp_host_addr_hmi     0x1E
-   #define  hp_host_addr_hi      0x1F
 
-   #define  hp_pio_data          0x20
-   #define  hp_reserved_21       0x21
    #define  hp_ee_ctrl           0x22
 
       #define  EXT_ARB_ACK       BIT(7)
@@ -777,17 +602,8 @@ typedef struct SCCBscam_info {
       #define  EWDS              0x04
       #define  EWDS_ADDR         0x0000
 
-   #define  hp_brdctl            0x23
 
-      #define  DAT_7             BIT(7)
-      #define  DAT_6             BIT(6)
-      #define  DAT_5             BIT(5)
-      #define  BRD_STB           BIT(4)
-      #define  BRD_CS            BIT(3)
-      #define  BRD_WR            BIT(2)
 
-   #define  hp_reserved_24       0x24
-   #define  hp_reserved_25       0x25
 
 
 
@@ -796,70 +612,36 @@ typedef struct SCCBscam_info {
 
       #define  SCSI_TERM_ENA_L   BIT(0)   /*Enable/Disable external terminators */
       #define  FLUSH_XFER_CNTR   BIT(1)   /*Flush transfer counter */
-      #define  BM_XFER_MIN_8     BIT(2)   /*Enable bus master transfer of 9 */
-      #define  BIOS_ENA          BIT(3)   /*Enable BIOS/FLASH Enable */
       #define  FORCE1_XFER       BIT(5)   /*Always xfer one byte in byte mode */
       #define  FAST_SINGLE       BIT(6)   /*?? */
 
       #define  BMCTRL_DEFAULT    (FORCE1_XFER|FAST_SINGLE|SCSI_TERM_ENA_L)
 
-   #define  hp_reserved_27       0x27
 
    #define  hp_sg_addr           0x28
    #define  hp_page_ctrl         0x29
 
       #define  SCATTER_EN        BIT(0)   
       #define  SGRAM_ARAM        BIT(1)   
-      #define  BIOS_SHADOW       BIT(2)   
       #define  G_INT_DISABLE     BIT(3)   /* Enable/Disable all Interrupts */
       #define  NARROW_SCSI_CARD  BIT(4)   /* NARROW/WIDE SCSI config pin */
 
-   #define  hp_reserved_2A       0x2A
-   #define  hp_pci_cmd_cfg       0x2B
 
-      #define  IO_SPACE_ENA      BIT(0)   /*enable I/O space */
-      #define  MEM_SPACE_ENA     BIT(1)   /*enable memory space */
-      #define  BUS_MSTR_ENA      BIT(2)   /*enable bus master operation */
-      #define  MEM_WI_ENA        BIT(4)   /*enable Write and Invalidate */
-      #define  PAR_ERR_RESP      BIT(6)   /*enable parity error responce. */
 
-   #define  hp_reserved_2C       0x2C
 
    #define  hp_pci_stat_cfg      0x2D
 
-      #define  DATA_PARITY_ERR   BIT(0)   
-      #define  REC_TARGET_ABORT  BIT(4)   /*received Target abort */
       #define  REC_MASTER_ABORT  BIT(5)   /*received Master abort */
-      #define  SIG_SYSTEM_ERR    BIT(6)   
-      #define  DETECTED_PAR_ERR  BIT(7)   
 
-   #define  hp_reserved_2E       0x2E
 
-   #define  hp_sys_status        0x2F
 
-      #define  SLV_DATA_RDY      BIT(0)   /*Slave data ready */
-      #define  XFER_CNT_ZERO     BIT(1)   /*Transfer counter = 0 */
-      #define  BM_FIFO_EMPTY     BIT(2)   /*FIFO empty */
-      #define  BM_FIFO_FULL      BIT(3)   /*FIFO full */
-      #define  HOST_OP_DONE      BIT(4)   /*host operation done */
-      #define  DMA_OP_DONE       BIT(5)   /*DMA operation done */
-      #define  SLV_OP_DONE       BIT(6)   /*Slave operation done */
-      #define  PWR_ON_FLAG       BIT(7)   /*Power on flag */
 
-   #define  hp_reserved_30       0x30
 
-   #define  hp_host_status0      0x31
 
-      #define  HOST_TERM         BIT(5)   /*Host Terminal Count */
-      #define  HOST_TRSHLD       BIT(6)   /*Host Threshold      */
-      #define  CONNECTED_2_HOST  BIT(7)   /*Connected to Host   */
 
-   #define  hp_reserved_32       0x32
 
    #define  hp_rev_num           0x33
 
-      #define  REV_A_CONST       0x0E
-      #define  REV_B_CONST       0x0E
 
    #define  hp_stack_data        0x34
    #define  hp_stack_addr        0x35
@@ -869,8 +651,6 @@ typedef struct SCCBscam_info {
       #define  BM_FORCE_OFF      BIT(0)   /*Bus Master is forced to get off */
       #define  PCI_TGT_ABORT     BIT(0)   /*PCI bus master transaction aborted */
       #define  PCI_DEV_TMOUT     BIT(1)   /*PCI Device Time out */
-      #define  FIFO_TC_NOT_ZERO  BIT(2)   /*FIFO or transfer counter not zero */
-      #define  CHIP_RST_OCCUR    BIT(3)   /*Chip reset occurs */
       #define  CMD_ABORTED       BIT(4)   /*Command aborted */
       #define  BM_PARITY_ERR     BIT(5)   /*parity error on data received   */
       #define  PIO_OVERRUN       BIT(6)   /*Slave data overrun */
@@ -880,24 +660,13 @@ typedef struct SCCBscam_info {
 
    #define  hp_int_status        0x37
       
-      #define  BM_CMD_CMPL       BIT(0)   /*Bus Master command complete */
       #define  EXT_STATUS_ON     BIT(1)   /*Extended status is valid */
       #define  SCSI_INTERRUPT    BIT(2)   /*Global indication of a SCSI int. */
-      #define  BM_FIFO_RDY       BIT(4)   
       #define  INT_ASSERTED      BIT(5)   /* */
-      #define  SRAM_BUSY         BIT(6)   /*Scatter/Gather RAM busy */
-      #define  CMD_REG_BUSY      BIT(7)                                       
 
 
    #define  hp_fifo_cnt          0x38
-   #define  hp_curr_host_cnt     0x39
-   #define  hp_reserved_3A       0x3A
-   #define  hp_fifo_in_addr      0x3B
-
-   #define  hp_fifo_out_addr     0x3C
-   #define  hp_reserved_3D       0x3D
-   #define  hp_reserved_3E       0x3E
-   #define  hp_reserved_3F       0x3F
+
 
 
 
@@ -937,9 +706,7 @@ typedef struct SCCBscam_info {
       #define  SCSI_IOBIT        BIT(0)
 
       #define  S_SCSI_PHZ        (BIT(2)+BIT(1)+BIT(0))
-      #define  S_CMD_PH          (BIT(2)              )
       #define  S_MSGO_PH         (BIT(2)+BIT(1)       )
-      #define  S_STAT_PH         (BIT(2)       +BIT(0))
       #define  S_MSGI_PH         (BIT(2)+BIT(1)+BIT(0))
       #define  S_DATAI_PH        (              BIT(0))
       #define  S_DATAO_PH        0x00
@@ -947,7 +714,6 @@ typedef struct SCCBscam_info {
 
    #define  hp_scsictrl_0        0x45
 
-      #define  NO_ARB            BIT(7)
       #define  SEL_TAR           BIT(6)
       #define  ENA_ATN           BIT(4)
       #define  ENA_RESEL         BIT(2)
@@ -969,44 +735,33 @@ typedef struct SCCBscam_info {
 
    #define  hp_scsireset         0x47
 
-      #define  SCSI_TAR          BIT(7)
       #define  SCSI_INI          BIT(6)
       #define  SCAM_EN           BIT(5)
-      #define  ACK_HOLD          BIT(4)
       #define  DMA_RESET         BIT(3)
       #define  HPSCSI_RESET      BIT(2)
       #define  PROG_RESET        BIT(1)
       #define  FIFO_CLR          BIT(0)
 
    #define  hp_xfercnt_0         0x48
-   #define  hp_xfercnt_1         0x49
    #define  hp_xfercnt_2         0x4A
-   #define  hp_xfercnt_3         0x4B
 
    #define  hp_fifodata_0        0x4C
-   #define  hp_fifodata_1        0x4D
    #define  hp_addstat           0x4E
 
       #define  SCAM_TIMER        BIT(7)
-      #define  AUTO_RUNNING      BIT(6)
-      #define  FAST_SYNC         BIT(5)
       #define  SCSI_MODE8        BIT(3)
       #define  SCSI_PAR_ERR      BIT(0)
 
    #define  hp_prgmcnt_0         0x4F
 
-      #define  AUTO_PC_MASK      0x3F
 
    #define  hp_selfid_0          0x50
    #define  hp_selfid_1          0x51
    #define  hp_arb_id            0x52
 
-      #define  ARB_ID            (BIT(3) + BIT(2) + BIT(1) + BIT(0))
 
    #define  hp_select_id         0x53
 
-      #define  RESEL_ID          (BIT(7) + BIT(6) + BIT(5) + BIT(4))
-      #define  SELECT_ID         (BIT(3) + BIT(2) + BIT(1) + BIT(0))
 
    #define  hp_synctarg_base     0x54
    #define  hp_synctarg_12       0x54
@@ -1029,63 +784,38 @@ typedef struct SCCBscam_info {
    #define  hp_synctarg_2        0x62
    #define  hp_synctarg_3        0x63
 
-      #define  RATE_20MB         0x00
-      #define  RATE_10MB         (              BIT(5))
-      #define  RATE_6_6MB        (       BIT(6)       )   
-      #define  RATE_5MB          (       BIT(6)+BIT(5))
-      #define  RATE_4MB          (BIT(7)              )
-      #define  RATE_3_33MB       (BIT(7)       +BIT(5))
-      #define  RATE_2_85MB       (BIT(7)+BIT(6)       )
-      #define  RATE_2_5MB        (BIT(7)+BIT(5)+BIT(6))
-      #define  NEXT_CLK          BIT(5)
-      #define  SLOWEST_SYNC      (BIT(7)+BIT(6)+BIT(5))
       #define  NARROW_SCSI       BIT(4)
-      #define  SYNC_OFFSET       (BIT(3) + BIT(2) + BIT(1) + BIT(0))
-      #define  DEFAULT_ASYNC     0x00
       #define  DEFAULT_OFFSET    0x0F
 
    #define  hp_autostart_0       0x64
    #define  hp_autostart_1       0x65
-   #define  hp_autostart_2       0x66
    #define  hp_autostart_3       0x67
 
 
 
-      #define  DISABLE  0x00
       #define  AUTO_IMMED    BIT(5)
       #define  SELECT   BIT(6)
-      #define  RESELECT (BIT(6)+BIT(5))
-      #define  BUSFREE  BIT(7)
-      #define  XFER_0   (BIT(7)+BIT(5))
       #define  END_DATA (BIT(7)+BIT(6))
-      #define  MSG_PHZ  (BIT(7)+BIT(6)+BIT(5))
 
    #define  hp_gp_reg_0          0x68
    #define  hp_gp_reg_1          0x69
-   #define  hp_gp_reg_2          0x6A
    #define  hp_gp_reg_3          0x6B
 
    #define  hp_seltimeout        0x6C
 
 
-      #define  TO_2ms            0x54      /* 2.0503ms */
       #define  TO_4ms            0x67      /* 3.9959ms */
 
       #define  TO_5ms            0x03      /* 4.9152ms */
       #define  TO_10ms           0x07      /* 11.xxxms */
       #define  TO_250ms          0x99      /* 250.68ms */
       #define  TO_290ms          0xB1      /* 289.99ms */
-      #define  TO_350ms          0xD6      /* 350.62ms */
-      #define  TO_417ms          0xFF      /* 417.79ms */
 
    #define  hp_clkctrl_0         0x6D
 
       #define  PWR_DWN           BIT(6)
       #define  ACTdeassert       BIT(4)
-      #define  ATNonErr          BIT(3)
-      #define  CLK_30MHZ         BIT(1)
       #define  CLK_40MHZ         (BIT(1) + BIT(0))
-      #define  CLK_50MHZ         BIT(2)
 
       #define  CLKCTRL_DEFAULT   (ACTdeassert | CLK_40MHZ)
 
@@ -1095,38 +825,21 @@ typedef struct SCCBscam_info {
    #define  hp_offsetctr         0x70
    #define  hp_xferstat          0x71
 
-      #define  FIFO_FULL         BIT(7)
       #define  FIFO_EMPTY        BIT(6)
-      #define  FIFO_MASK         0x3F   /* Mask for the FIFO count value. */
-      #define  FIFO_LEN          0x20
 
    #define  hp_portctrl_1        0x72
 
-      #define  EVEN_HOST_P       BIT(5)
-      #define  INVT_SCSI         BIT(4)
       #define  CHK_SCSI_P        BIT(3)
       #define  HOST_MODE8        BIT(0)
-      #define  HOST_MODE16       0x00
 
    #define  hp_xfer_pad          0x73
 
       #define  ID_UNLOCK         BIT(3)
-      #define  XFER_PAD          BIT(2)
 
    #define  hp_scsidata_0        0x74
    #define  hp_scsidata_1        0x75
-   #define  hp_timer_0           0x76
-   #define  hp_timer_1           0x77
 
-   #define  hp_reserved_78       0x78
-   #define  hp_reserved_79       0x79
-   #define  hp_reserved_7A       0x7A
-   #define  hp_reserved_7B       0x7B
-
-   #define  hp_reserved_7C       0x7C
-   #define  hp_reserved_7D       0x7D
-   #define  hp_reserved_7E       0x7E
-   #define  hp_reserved_7F       0x7F
+
 
    #define  hp_aramBase          0x80
    #define  BIOS_DATA_OFFSET     0x60
@@ -1135,22 +848,15 @@ typedef struct SCCBscam_info {
 
 
 
-      #define  AUTO_LEN 0x80
-      #define  AR0      0x00
-      #define  AR1      BITW(8)
-      #define  AR2      BITW(9)
       #define  AR3      (BITW(9) + BITW(8))
       #define  SDATA    BITW(10)
 
-      #define  NOP_OP   0x00        /* Nop command */
 
       #define  CRD_OP   BITW(11)     /* Cmp Reg. w/ Data */
 
       #define  CRR_OP   BITW(12)     /* Cmp Reg. w. Reg. */
 
-      #define  CBE_OP   (BITW(14)+BITW(12)+BITW(11)) /* Cmp SCSI cmd class & Branch EQ */
       
-      #define  CBN_OP   (BITW(14)+BITW(13))  /* Cmp SCSI cmd class & Branch NOT EQ */
       
       #define  CPE_OP   (BITW(14)+BITW(11))  /* Cmp SCSI phs & Branch EQ */
 
@@ -1163,7 +869,6 @@ typedef struct SCCBscam_info {
       #define  ASTATUS     (BITW(10)+BITW(8))
       #define  AMSG_OUT    (BITW(10)+BITW(9))
       #define  AMSG_IN     (BITW(10)+BITW(9)+BITW(8))
-      #define  AILLEGAL    (BITW(9)+BITW(8))
 
 
       #define  BRH_OP   BITW(13)   /* Branch */
@@ -1176,17 +881,11 @@ typedef struct SCCBscam_info {
       #define  TCB_OP   (BITW(13)+BITW(11))    /* Test condition & branch */
 
       
-      #define  ATN_SET     BITW(8)
-      #define  ATN_RESET   BITW(9)
-      #define  XFER_CNT    (BITW(9)+BITW(8))
       #define  FIFO_0      BITW(10)
-      #define  FIFO_NOT0   (BITW(10)+BITW(8))
-      #define  T_USE_SYNC0 (BITW(10)+BITW(9))
 
 
       #define  MPM_OP   BITW(15)        /* Match phase and move data */
 
-      #define  MDR_OP   (BITW(12)+BITW(11)) /* Move data to Reg. */
 
       #define  MRR_OP   BITW(14)        /* Move DReg. to Reg. */
 
@@ -1196,34 +895,14 @@ typedef struct SCCBscam_info {
 
       #define  D_AR0    0x00
       #define  D_AR1    BIT(0)
-      #define  D_AR2    BIT(1)
-      #define  D_AR3    (BIT(1) + BIT(0))
-      #define  D_SDATA  BIT(2)
       #define  D_BUCKET (BIT(2) + BIT(1) + BIT(0))
 
 
-      #define  ADR_OP   (BITW(13)+BITW(12)) /* Logical AND Reg. w. Data */
 
-      #define  ADS_OP   (BITW(14)+BITW(13)+BITW(12)) 
 
-      #define  ODR_OP   (BITW(13)+BITW(12)+BITW(11))  
 
-      #define  ODS_OP   (BITW(14)+BITW(13)+BITW(12)+BITW(11))  
 
-      #define  STR_OP   (BITW(15)+BITW(14)) /* Store to A_Reg. */
-
-      #define  AINT_ENA1   0x00
-      #define  AINT_STAT1  BITW(8)
-      #define  ASCSI_SIG   BITW(9)
-      #define  ASCSI_CNTL  (BITW(9)+BITW(8))
-      #define  APORT_CNTL  BITW(10)
-      #define  ARST_CNTL   (BITW(10)+BITW(8))
-      #define  AXFERCNT0   (BITW(10)+BITW(9))
-      #define  AXFERCNT1   (BITW(10)+BITW(9)+BITW(8))
-      #define  AXFERCNT2   BITW(11)
-      #define  AFIFO_DATA  (BITW(11)+BITW(8))
-      #define  ASCSISELID  (BITW(11)+BITW(9))
-      #define  ASCSISYNC0  (BITW(11)+BITW(9)+BITW(8))
+
 
 
       #define  RAT_OP      (BITW(14)+BITW(13)+BITW(11))
@@ -1233,7 +912,6 @@ typedef struct SCCBscam_info {
 
       #define  SSI_ITAR_DISC	(ITAR_DISC >> 8)
       #define  SSI_IDO_STRT	(IDO_STRT >> 8)
-      #define  SSI_IDI_STRT	(IDO_STRT >> 8)
 
       #define  SSI_ICMD_COMP	(ICMD_COMP >> 8)
       #define  SSI_ITICKLE	(ITICKLE >> 8)
@@ -1248,13 +926,11 @@ typedef struct SCCBscam_info {
       #define  CMDPZ 0x04     /*Command phase */
       #define  DINT  0x12     /*Data Out/In interrupt */
       #define  DI    0x13     /*Data Out */
-      #define  MI    0x14     /*Message In */
       #define  DC    0x19     /*Disconnect Message */
       #define  ST    0x1D     /*Status Phase */
       #define  UNKNWN 0x24    /*Unknown bus action */
       #define  CC    0x25     /*Command Completion failure */
       #define  TICK  0x26     /*New target reselected us. */
-      #define  RFAIL 0x27     /*Reselection failed */
       #define  SELCHK 0x28     /*Select & Check SCSI ID latch reg */
 
 
@@ -1268,25 +944,18 @@ typedef struct SCCBscam_info {
 
 
       #define  TAG_STRT          0x00
-      #define  SELECTION_START   0x00
       #define  DISCONNECT_START  0x10/2
       #define  END_DATA_START    0x14/2
-      #define  NONTAG_STRT       0x02/2
       #define  CMD_ONLY_STRT     CMDPZ/2
-      #define  TICKLE_STRT     TICK/2
       #define  SELCHK_STRT     SELCHK/2
 
 
 
 
-#define mEEPROM_CLK_DELAY(port) (RD_HARPOON(port+hp_intstat_1))
 
-#define mWAIT_10MS(port) (RD_HARPOON(port+hp_intstat_1))
 
 
-#define CLR_XFER_CNT(port) (WR_HARPOON(port+hp_xfercnt_0, 0x00))
 
-#define SET_XFER_CNT(port, data) (WR_HARP32(port,hp_xfercnt_0,data))
 
 #define GET_XFER_CNT(port, xfercnt) {RD_HARP32(port,hp_xfercnt_0,xfercnt); xfercnt &= 0xFFFFFF;}
 /* #define GET_XFER_CNT(port, xfercnt) (xfercnt = RD_HARPOON(port+hp_xfercnt_2), \
@@ -1308,11 +977,7 @@ typedef struct SCCBscam_info {
 #define ACCEPT_MSG_ATN(port) {while(RD_HARPOON(port+hp_scsisig) & SCSI_REQ){}\
                           WR_HARPOON(port+hp_scsisig, (S_ILL_PH|SCSI_ATN));}
 
-#define ACCEPT_STAT(port) {while(RD_HARPOON(port+hp_scsisig) & SCSI_REQ){}\
-                          WR_HARPOON(port+hp_scsisig, S_ILL_PH);}
 
-#define ACCEPT_STAT_ATN(port) {while(RD_HARPOON(port+hp_scsisig) & SCSI_REQ){}\
-                          WR_HARPOON(port+hp_scsisig, (S_ILL_PH|SCSI_ATN));}
 
 #define DISABLE_AUTO(port) (WR_HARPOON(port+hp_scsireset, PROG_RESET),\
                         WR_HARPOON(port+hp_scsireset, 0x00))
@@ -1332,7 +997,6 @@ typedef struct SCCBscam_info {
 
 
 
-void  scsiStartAuto(ULONG port);
 static UCHAR FPT_sisyncn(ULONG port, UCHAR p_card, UCHAR syncFlag);
 static void  FPT_ssel(ULONG port, UCHAR p_card);
 static void  FPT_sres(ULONG port, UCHAR p_card, PSCCBcard pCurrCard);
@@ -1405,7 +1069,6 @@ static void  FPT_DiagEEPROM(ULONG p_port
 
 
 
-void  busMstrAbort(ULONG port);
 static void  FPT_dataXferProcessor(ULONG port, PSCCBcard pCurrCard);
 static void  FPT_busMstrSGDataXferStart(ULONG port, PSCCB pCurrSCCB);
 static void  FPT_busMstrDataXferStart(ULONG port, PSCCB pCurrSCCB);
@@ -1446,12 +1109,6 @@ static void  FPT_autoLoadDefaultMap(ULON
 
 
 
-void  OS_start_timer(unsigned long ioport, unsigned long timeout);
-void  OS_stop_timer(unsigned long ioport, unsigned long timeout);
-void  OS_disable_int(unsigned char intvec);
-void  OS_enable_int(unsigned char intvec);
-void  OS_delay(unsigned long count);
-int   OS_VirtToPhys(u32bits CardHandle, u32bits *physaddr, u32bits *virtaddr);
 
 static SCCBMGR_TAR_INFO FPT_sccbMgrTbl[MAX_CARDS][MAX_SCSI_TAR] = { { { 0 } } };
 static SCCBCARD FPT_BL_Card[MAX_CARDS] = { { 0 } };
_
