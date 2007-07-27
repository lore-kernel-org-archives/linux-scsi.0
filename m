From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 12/24] advansys: remove INQUIRY sniffing
Date: Fri, 27 Jul 2007 07:42:21 -0600
Message-ID: <11855437531175-git-send-email-matthew@wil.cx>
References: <20070727134038.GC21219@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:42008 "EHLO
	mail-07.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933327AbXG0Nmi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 09:42:38 -0400
In-Reply-To: <20070727134038.GC21219@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Use slave_configure() to do all the work that used to be done in
AscInquiryHandling and AdvInquiryHandling.  Split slave_configure into
two functions, one for wide and one for narrow controllers.

Remove some unused definitions, duplicate definitions, unnecessary
declarations, and scsireqq, cap_info and inquiry from struct asc_board.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |  637 ++++++++++++++++-------------------------------
 1 files changed, 211 insertions(+), 426 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index a445c9c..7c59739 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -943,10 +943,6 @@ typedef unsigned char uchar;
 #define ASC_MAX_CDB_LEN     12
 #define ASC_SCSI_RESET_HOLD_TIME_US  60
 
-#define ADV_INQ_CLOCKING_ST_ONLY    0x0
-#define ADV_INQ_CLOCKING_DT_ONLY    0x1
-#define ADV_INQ_CLOCKING_ST_AND_DT  0x3
-
 /*
  * Inquiry SPC-2 SPI Byte 1 EVPD (Enable Vital Product Data)
  * and CmdDt (Command Support Data) field bit definitions.
@@ -965,57 +961,8 @@ typedef unsigned char uchar;
 #define ASC_SRB_TID(x)   ((uchar)((uchar)(x) & (uchar)0x0F))
 #define ASC_SRB_LUN(x)   ((uchar)((uint)(x) >> 13))
 #define PUT_CDB1(x)   ((uchar)((uint)(x) >> 8))
-#define MS_CMD_DONE    0x00
-#define MS_EXTEND      0x01
 #define MS_SDTR_LEN    0x03
-#define MS_SDTR_CODE   0x01
 #define MS_WDTR_LEN    0x02
-#define MS_WDTR_CODE   0x03
-#define MS_MDP_LEN    0x05
-#define MS_MDP_CODE   0x00
-
-/*
- * Inquiry data structure and bitfield macros
- *
- * Only quantities of more than 1 bit are shifted, since the others are
- * just tested for true or false. C bitfields aren't portable between big
- * and little-endian platforms so they are not used.
- */
-
-#define ASC_INQ_DVC_TYPE(inq)       ((inq)->periph & 0x1f)
-#define ASC_INQ_QUALIFIER(inq)      (((inq)->periph & 0xe0) >> 5)
-#define ASC_INQ_DVC_TYPE_MOD(inq)   ((inq)->devtype & 0x7f)
-#define ASC_INQ_REMOVABLE(inq)      ((inq)->devtype & 0x80)
-#define ASC_INQ_ANSI_VER(inq)       ((inq)->ver & 0x07)
-#define ASC_INQ_ECMA_VER(inq)       (((inq)->ver & 0x38) >> 3)
-#define ASC_INQ_ISO_VER(inq)        (((inq)->ver & 0xc0) >> 6)
-#define ASC_INQ_RESPONSE_FMT(inq)   ((inq)->byte3 & 0x0f)
-#define ASC_INQ_TERM_IO(inq)        ((inq)->byte3 & 0x40)
-#define ASC_INQ_ASYNC_NOTIF(inq)    ((inq)->byte3 & 0x80)
-#define ASC_INQ_SOFT_RESET(inq)     ((inq)->flags & 0x01)
-#define ASC_INQ_CMD_QUEUE(inq)      ((inq)->flags & 0x02)
-#define ASC_INQ_LINK_CMD(inq)       ((inq)->flags & 0x08)
-#define ASC_INQ_SYNC(inq)           ((inq)->flags & 0x10)
-#define ASC_INQ_WIDE16(inq)         ((inq)->flags & 0x20)
-#define ASC_INQ_WIDE32(inq)         ((inq)->flags & 0x40)
-#define ASC_INQ_REL_ADDR(inq)       ((inq)->flags & 0x80)
-#define ASC_INQ_INFO_UNIT(inq)      ((inq)->info & 0x01)
-#define ASC_INQ_QUICK_ARB(inq)      ((inq)->info & 0x02)
-#define ASC_INQ_CLOCKING(inq)       (((inq)->info & 0x0c) >> 2)
-
-typedef struct {
-	uchar periph;
-	uchar devtype;
-	uchar ver;
-	uchar byte3;
-	uchar add_len;
-	uchar res1;
-	uchar res2;
-	uchar flags;
-	uchar vendor_id[8];
-	uchar product_id[16];
-	uchar product_rev_level[4];
-} ASC_SCSI_INQUIRY;
 
 #define ASC_SG_LIST_PER_Q   7
 #define QS_FREE        0x00
@@ -1945,9 +1892,7 @@ static void DvcDelayNanoSecond(ASC_DVC_VAR *, ASC_DCNT);
 static void DvcPutScsiQ(PortAddr, ushort, uchar *, int);
 static void DvcGetQinfo(PortAddr, ushort, uchar *, int);
 static ushort AscInitAsc1000Driver(ASC_DVC_VAR *);
-static void AscAsyncFix(ASC_DVC_VAR *, uchar, ASC_SCSI_INQUIRY *);
-static int AscTagQueuingSafe(ASC_SCSI_INQUIRY *);
-static void AscInquiryHandling(ASC_DVC_VAR *, uchar, ASC_SCSI_INQUIRY *);
+static void AscAsyncFix(ASC_DVC_VAR *, struct scsi_device *);
 static int AscExeScsiQueue(ASC_DVC_VAR *, ASC_SCSI_Q *);
 static int AscISR(ASC_DVC_VAR *);
 static uint AscGetNumOfFreeQueue(ASC_DVC_VAR *, uchar, uchar);
@@ -3094,7 +3039,6 @@ static int AdvResetSB(ADV_DVC_VAR *asc_dvc);
  * Internal Adv Library functions.
  */
 static int AdvSendIdleCmd(ADV_DVC_VAR *, ushort, ADV_DCNT);
-static void AdvInquiryHandling(ADV_DVC_VAR *, ADV_SCSI_REQ_Q *);
 static int AdvInitFrom3550EEP(ADV_DVC_VAR *);
 static int AdvInitFrom38C0800EEP(ADV_DVC_VAR *);
 static int AdvInitFrom38C1600EEP(ADV_DVC_VAR *);
@@ -3309,74 +3253,6 @@ static ADVEEP_38C1600_CONFIG Default_38C1600_EEPROM_Config;
           ((ADV_MAX_SG_LIST + (NO_OF_SG_PER_BLOCK - 1))/NO_OF_SG_PER_BLOCK))
 
 /*
- * Inquiry data structure and bitfield macros
- *
- * Using bitfields to access the subchar data isn't portable across
- * endianness, so instead mask and shift. Only quantities of more
- * than 1 bit are shifted, since the others are just tested for true
- * or false.
- */
-
-#define ADV_INQ_DVC_TYPE(inq)       ((inq)->periph & 0x1f)
-#define ADV_INQ_QUALIFIER(inq)      (((inq)->periph & 0xe0) >> 5)
-#define ADV_INQ_DVC_TYPE_MOD(inq)   ((inq)->devtype & 0x7f)
-#define ADV_INQ_REMOVABLE(inq)      ((inq)->devtype & 0x80)
-#define ADV_INQ_ANSI_VER(inq)       ((inq)->ver & 0x07)
-#define ADV_INQ_ECMA_VER(inq)       (((inq)->ver & 0x38) >> 3)
-#define ADV_INQ_ISO_VER(inq)        (((inq)->ver & 0xc0) >> 6)
-#define ADV_INQ_RESPONSE_FMT(inq)   ((inq)->byte3 & 0x0f)
-#define ADV_INQ_TERM_IO(inq)        ((inq)->byte3 & 0x40)
-#define ADV_INQ_ASYNC_NOTIF(inq)    ((inq)->byte3 & 0x80)
-#define ADV_INQ_SOFT_RESET(inq)     ((inq)->flags & 0x01)
-#define ADV_INQ_CMD_QUEUE(inq)      ((inq)->flags & 0x02)
-#define ADV_INQ_LINK_CMD(inq)       ((inq)->flags & 0x08)
-#define ADV_INQ_SYNC(inq)           ((inq)->flags & 0x10)
-#define ADV_INQ_WIDE16(inq)         ((inq)->flags & 0x20)
-#define ADV_INQ_WIDE32(inq)         ((inq)->flags & 0x40)
-#define ADV_INQ_REL_ADDR(inq)       ((inq)->flags & 0x80)
-#define ADV_INQ_INFO_UNIT(inq)      ((inq)->info & 0x01)
-#define ADV_INQ_QUICK_ARB(inq)      ((inq)->info & 0x02)
-#define ADV_INQ_CLOCKING(inq)       (((inq)->info & 0x0c) >> 2)
-
-typedef struct {
-	uchar periph;		/* peripheral device type [0:4] */
-	/* peripheral qualifier [5:7] */
-	uchar devtype;		/* device type modifier (for SCSI I) [0:6] */
-	/* RMB - removable medium bit [7] */
-	uchar ver;		/* ANSI approved version [0:2] */
-	/* ECMA version [3:5] */
-	/* ISO version [6:7] */
-	uchar byte3;		/* response data format [0:3] */
-	/* 0 SCSI 1 */
-	/* 1 CCS */
-	/* 2 SCSI-2 */
-	/* 3-F reserved */
-	/* reserved [4:5] */
-	/* terminate I/O process bit (see 5.6.22) [6] */
-	/* asynch. event notification (processor) [7] */
-	uchar add_len;		/* additional length */
-	uchar res1;		/* reserved */
-	uchar res2;		/* reserved */
-	uchar flags;		/* soft reset implemented [0] */
-	/* command queuing [1] */
-	/* reserved [2] */
-	/* linked command for this logical unit [3] */
-	/* synchronous data transfer [4] */
-	/* wide bus 16 bit data transfer [5] */
-	/* wide bus 32 bit data transfer [6] */
-	/* relative addressing mode [7] */
-	uchar vendor_id[8];	/* vendor identification */
-	uchar product_id[16];	/* product identification */
-	uchar product_rev_level[4];	/* product revision level */
-	uchar vendor_specific[20];	/* vendor specific */
-	uchar info;		/* information unit supported [0] */
-	/* quick arbitrate supported [1] */
-	/* clocking field [2:3] */
-	/* reserved [4:7] */
-	uchar res3;		/* reserved */
-} ADV_SCSI_INQUIRY;		/* 58 bytes */
-
-/*
  * --- Driver Constants and Macros
  */
 
@@ -3790,10 +3666,6 @@ typedef struct asc_board {
 	/*
 	 * The following fields are used only for Narrow Boards.
 	 */
-	/* The following three structures must be in DMA-able memory. */
-	ASC_SCSI_REQ_Q scsireqq;
-	ASC_CAP_INFO cap_info;
-	ASC_SCSI_INQUIRY inquiry;
 	uchar sdtr_data[ASC_MAX_TID + 1];	/* SDTR information */
 	/*
 	 * The following fields are used only for Wide Boards.
@@ -3852,8 +3724,6 @@ static PortAddr _asc_def_iop_base[];
 
 /*
  * --- Driver Function Prototypes
- *
- * advansys.h contains function prototypes for functions global to Linux.
  */
 
 static irqreturn_t advansys_interrupt(int, void *);
@@ -4681,38 +4551,203 @@ static irqreturn_t advansys_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static void
+advansys_narrow_slave_configure(struct scsi_device *sdev, ASC_DVC_VAR *asc_dvc)
+{
+	ASC_SCSI_BIT_ID_TYPE tid_bit = 1 << sdev->id;
+	ASC_SCSI_BIT_ID_TYPE orig_use_tagged_qng = asc_dvc->use_tagged_qng;
+
+	if (sdev->lun == 0) {
+		ASC_SCSI_BIT_ID_TYPE orig_init_sdtr = asc_dvc->init_sdtr;
+		if ((asc_dvc->cfg->sdtr_enable & tid_bit) && sdev->sdtr) {
+			asc_dvc->init_sdtr |= tid_bit;
+		} else {
+			asc_dvc->init_sdtr &= ~tid_bit;
+		}
+
+		if (orig_init_sdtr != asc_dvc->init_sdtr)
+			AscAsyncFix(asc_dvc, sdev);
+	}
+
+	if (sdev->tagged_supported) {
+		if (asc_dvc->cfg->cmd_qng_enabled & tid_bit) {
+			if (sdev->lun == 0) {
+				asc_dvc->cfg->can_tagged_qng |= tid_bit;
+				asc_dvc->use_tagged_qng |= tid_bit;
+			}
+			scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG,
+						asc_dvc->max_dvc_qng[sdev->id]);
+		}
+	} else {
+		if (sdev->lun == 0) {
+			asc_dvc->cfg->can_tagged_qng &= ~tid_bit;
+			asc_dvc->use_tagged_qng &= ~tid_bit;
+		}
+		scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
+	}
+
+	if ((sdev->lun == 0) &&
+	    (orig_use_tagged_qng != asc_dvc->use_tagged_qng)) {
+		AscWriteLramByte(asc_dvc->iop_base, ASCV_DISC_ENABLE_B,
+				 asc_dvc->cfg->disc_enable);
+		AscWriteLramByte(asc_dvc->iop_base, ASCV_USE_TAGGED_QNG_B,
+				 asc_dvc->use_tagged_qng);
+		AscWriteLramByte(asc_dvc->iop_base, ASCV_CAN_TAGGED_QNG_B,
+				 asc_dvc->cfg->can_tagged_qng);
+
+		asc_dvc->max_dvc_qng[sdev->id] =
+					asc_dvc->cfg->max_tag_qng[sdev->id];
+		AscWriteLramByte(asc_dvc->iop_base,
+				 (ushort)(ASCV_MAX_DVC_QNG_BEG + sdev->id),
+				 asc_dvc->max_dvc_qng[sdev->id]);
+	}
+}
+
 /*
- * Set the number of commands to queue per device for the
- * specified host adapter.
+ * Wide Transfers
+ *
+ * If the EEPROM enabled WDTR for the device and the device supports wide
+ * bus (16 bit) transfers, then turn on the device's 'wdtr_able' bit and
+ * write the new value to the microcode.
  */
-static int advansys_slave_configure(struct scsi_device *device)
+static void
+advansys_wide_enable_wdtr(AdvPortAddr iop_base, unsigned short tidmask)
 {
-	asc_board_t *boardp;
+	unsigned short cfg_word;
+	AdvReadWordLram(iop_base, ASC_MC_WDTR_ABLE, cfg_word);
+	if ((cfg_word & tidmask) != 0)
+		return;
+
+	cfg_word |= tidmask;
+	AdvWriteWordLram(iop_base, ASC_MC_WDTR_ABLE, cfg_word);
 
-	boardp = ASC_BOARDP(device->host);
-	boardp->flags |= ASC_SELECT_QUEUE_DEPTHS;
 	/*
-	 * Save a pointer to the device and set its initial/maximum
-	 * queue depth.  Only save the pointer for a lun0 dev though.
+	 * Clear the microcode SDTR and WDTR negotiation done indicators for
+	 * the target to cause it to negotiate with the new setting set above.
+	 * WDTR when accepted causes the target to enter asynchronous mode, so
+	 * SDTR must be negotiated.
 	 */
-	if (device->lun == 0)
-		boardp->device[device->id] = device;
-	if (device->tagged_supported) {
-		if (ASC_NARROW_BOARD(boardp)) {
-			scsi_adjust_queue_depth(device, MSG_ORDERED_TAG,
-						boardp->dvc_var.asc_dvc_var.
-						max_dvc_qng[device->id]);
-		} else {
-			scsi_adjust_queue_depth(device, MSG_ORDERED_TAG,
-						boardp->dvc_var.adv_dvc_var.
-						max_dvc_qng);
+	AdvReadWordLram(iop_base, ASC_MC_SDTR_DONE, cfg_word);
+	cfg_word &= ~tidmask;
+	AdvWriteWordLram(iop_base, ASC_MC_SDTR_DONE, cfg_word);
+	AdvReadWordLram(iop_base, ASC_MC_WDTR_DONE, cfg_word);
+	cfg_word &= ~tidmask;
+	AdvWriteWordLram(iop_base, ASC_MC_WDTR_DONE, cfg_word);
+}
+
+/*
+ * Synchronous Transfers
+ *
+ * If the EEPROM enabled SDTR for the device and the device
+ * supports synchronous transfers, then turn on the device's
+ * 'sdtr_able' bit. Write the new value to the microcode.
+ */
+static void
+advansys_wide_enable_sdtr(AdvPortAddr iop_base, unsigned short tidmask)
+{
+	unsigned short cfg_word;
+	AdvReadWordLram(iop_base, ASC_MC_SDTR_ABLE, cfg_word);
+	if ((cfg_word & tidmask) != 0)
+		return;
+
+	cfg_word |= tidmask;
+	AdvWriteWordLram(iop_base, ASC_MC_SDTR_ABLE, cfg_word);
+
+	/*
+	 * Clear the microcode "SDTR negotiation" done indicator for the
+	 * target to cause it to negotiate with the new setting set above.
+	 */
+	AdvReadWordLram(iop_base, ASC_MC_SDTR_DONE, cfg_word);
+	cfg_word &= ~tidmask;
+	AdvWriteWordLram(iop_base, ASC_MC_SDTR_DONE, cfg_word);
+}
+
+/*
+ * PPR (Parallel Protocol Request) Capable
+ *
+ * If the device supports DT mode, then it must be PPR capable.
+ * The PPR message will be used in place of the SDTR and WDTR
+ * messages to negotiate synchronous speed and offset, transfer
+ * width, and protocol options.
+ */
+static void advansys_wide_enable_ppr(ADV_DVC_VAR *adv_dvc,
+				AdvPortAddr iop_base, unsigned short tidmask)
+{
+	AdvReadWordLram(iop_base, ASC_MC_PPR_ABLE, adv_dvc->ppr_able);
+	adv_dvc->ppr_able |= tidmask;
+	AdvWriteWordLram(iop_base, ASC_MC_PPR_ABLE, adv_dvc->ppr_able);
+}
+
+static void
+advansys_wide_slave_configure(struct scsi_device *sdev, ADV_DVC_VAR *adv_dvc)
+{
+	AdvPortAddr iop_base = adv_dvc->iop_base;
+	unsigned short tidmask = 1 << sdev->id;
+
+	if (sdev->lun == 0) {
+		/*
+		 * Handle WDTR, SDTR, and Tag Queuing. If the feature
+		 * is enabled in the EEPROM and the device supports the
+		 * feature, then enable it in the microcode.
+		 */
+
+		if ((adv_dvc->wdtr_able & tidmask) && sdev->wdtr)
+			advansys_wide_enable_wdtr(iop_base, tidmask);
+		if ((adv_dvc->sdtr_able & tidmask) && sdev->sdtr)
+			advansys_wide_enable_sdtr(iop_base, tidmask);
+		if (adv_dvc->chip_type == ADV_CHIP_ASC38C1600 && sdev->ppr)
+			advansys_wide_enable_ppr(adv_dvc, iop_base, tidmask);
+
+		/*
+		 * Tag Queuing is disabled for the BIOS which runs in polled
+		 * mode and would see no benefit from Tag Queuing. Also by
+		 * disabling Tag Queuing in the BIOS devices with Tag Queuing
+		 * bugs will at least work with the BIOS.
+		 */
+		if ((adv_dvc->tagqng_able & tidmask) &&
+		    sdev->tagged_supported) {
+			unsigned short cfg_word;
+			AdvReadWordLram(iop_base, ASC_MC_TAGQNG_ABLE, cfg_word);
+			cfg_word |= tidmask;
+			AdvWriteWordLram(iop_base, ASC_MC_TAGQNG_ABLE,
+					 cfg_word);
+			AdvWriteByteLram(iop_base,
+					 ASC_MC_NUMBER_OF_MAX_CMD + sdev->id,
+					 adv_dvc->max_dvc_qng);
 		}
+	}
+
+	if ((adv_dvc->tagqng_able & tidmask) && sdev->tagged_supported) {
+		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG,
+					adv_dvc->max_dvc_qng);
 	} else {
-		scsi_adjust_queue_depth(device, 0, device->host->cmd_per_lun);
+		scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
 	}
-	ASC_DBG4(1,
-		 "advansys_slave_configure: device 0x%lx, boardp 0x%lx, id %d, depth %d\n",
-		 (ulong)device, (ulong)boardp, device->id, device->queue_depth);
+}
+
+/*
+ * Set the number of commands to queue per device for the
+ * specified host adapter.
+ */
+static int advansys_slave_configure(struct scsi_device *sdev)
+{
+	asc_board_t *boardp = ASC_BOARDP(sdev->host);
+	boardp->flags |= ASC_SELECT_QUEUE_DEPTHS;
+
+	/*
+	 * Save a pointer to the sdev and set its initial/maximum
+	 * queue depth.  Only save the pointer for a lun0 dev though.
+	 */
+	if (sdev->lun == 0)
+		boardp->device[sdev->id] = sdev;
+
+	if (ASC_NARROW_BOARD(boardp))
+		advansys_narrow_slave_configure(sdev,
+						&boardp->dvc_var.asc_dvc_var);
+	else
+		advansys_wide_slave_configure(sdev,
+						&boardp->dvc_var.adv_dvc_var);
+
 	return 0;
 }
 
@@ -5482,21 +5517,10 @@ static void asc_isr_callback(ASC_DVC_VAR *asc_dvc_varp, ASC_QDONE_INFO *qdonep)
 		scp->result = 0;
 
 		/*
-		 * If an INQUIRY command completed successfully, then call
-		 * the AscInquiryHandling() function to set-up the device.
-		 */
-		if (scp->cmnd[0] == INQUIRY && scp->device->lun == 0 &&
-		    (scp->request_bufflen - qdonep->remain_bytes) >= 8) {
-			AscInquiryHandling(asc_dvc_varp, scp->device->id & 0x7,
-					   (ASC_SCSI_INQUIRY *)scp->
-					   request_buffer);
-		}
-
-		/*
 		 * Check for an underrun condition.
 		 *
 		 * If there was no error and an underrun condition, then
-		 * then return the number of underrun bytes.
+		 * return the number of underrun bytes.
 		 */
 		if (scp->request_bufflen != 0 && qdonep->remain_bytes != 0 &&
 		    qdonep->remain_bytes <= scp->request_bufflen) {
@@ -8389,8 +8413,8 @@ static int AscIsrChipHalted(ASC_DVC_VAR *asc_dvc)
 					  (uchar *)&ext_msg,
 					  sizeof(EXT_MSG) >> 1);
 
-		if (ext_msg.msg_type == MS_EXTEND &&
-		    ext_msg.msg_req == MS_SDTR_CODE &&
+		if (ext_msg.msg_type == EXTENDED_MESSAGE &&
+		    ext_msg.msg_req == EXTENDED_SDTR &&
 		    ext_msg.msg_len == MS_SDTR_LEN) {
 			sdtr_accept = TRUE;
 			if ((ext_msg.req_ack_offset > ASC_SYN_MAX_OFFSET)) {
@@ -8472,8 +8496,8 @@ static int AscIsrChipHalted(ASC_DVC_VAR *asc_dvc)
 					 q_cntl);
 			AscWriteLramWord(iop_base, ASCV_HALTCODE_W, 0);
 			return (0);
-		} else if (ext_msg.msg_type == MS_EXTEND &&
-			   ext_msg.msg_req == MS_WDTR_CODE &&
+		} else if (ext_msg.msg_type == EXTENDED_MESSAGE &&
+			   ext_msg.msg_req == EXTENDED_WDTR &&
 			   ext_msg.msg_len == MS_WDTR_LEN) {
 
 			ext_msg.wdtr_width = 0;
@@ -8566,9 +8590,9 @@ static int AscIsrChipHalted(ASC_DVC_VAR *asc_dvc)
 					  (uchar *)&out_msg,
 					  sizeof(EXT_MSG) >> 1);
 
-		if ((out_msg.msg_type == MS_EXTEND) &&
+		if ((out_msg.msg_type == EXTENDED_MESSAGE) &&
 		    (out_msg.msg_len == MS_SDTR_LEN) &&
-		    (out_msg.msg_req == MS_SDTR_CODE)) {
+		    (out_msg.msg_req == EXTENDED_SDTR)) {
 
 			asc_dvc->init_sdtr &= ~target_id;
 			asc_dvc->sdtr_done &= ~target_id;
@@ -10061,9 +10085,9 @@ AscMsgOutSDTR(ASC_DVC_VAR *asc_dvc, uchar sdtr_period, uchar sdtr_offset)
 	PortAddr iop_base;
 
 	iop_base = asc_dvc->iop_base;
-	sdtr_buf.msg_type = MS_EXTEND;
+	sdtr_buf.msg_type = EXTENDED_MESSAGE;
 	sdtr_buf.msg_len = MS_SDTR_LEN;
-	sdtr_buf.msg_req = MS_SDTR_CODE;
+	sdtr_buf.msg_req = EXTENDED_SDTR;
 	sdtr_buf.xfer_period = sdtr_period;
 	sdtr_offset &= ASC_SYN_MAX_OFFSET;
 	sdtr_buf.req_ack_offset = sdtr_offset;
@@ -11145,91 +11169,31 @@ AscSetEEPConfig(PortAddr iop_base, ASCEEP_CONFIG *cfg_buf, ushort bus_type)
 	return (n_error);
 }
 
-static void
-AscAsyncFix(ASC_DVC_VAR *asc_dvc, uchar tid_no, ASC_SCSI_INQUIRY *inq)
+static void AscAsyncFix(ASC_DVC_VAR *asc_dvc, struct scsi_device *sdev)
 {
-	uchar dvc_type;
-	ASC_SCSI_BIT_ID_TYPE tid_bits;
-
-	dvc_type = ASC_INQ_DVC_TYPE(inq);
-	tid_bits = ASC_TIX_TO_TARGET_ID(tid_no);
+	char type = sdev->type;
+	ASC_SCSI_BIT_ID_TYPE tid_bits = 1 << sdev->id;
 
 	if (asc_dvc->bug_fix_cntl & ASC_BUG_FIX_ASYN_USE_SYN) {
 		if (!(asc_dvc->init_sdtr & tid_bits)) {
-			if ((dvc_type == TYPE_ROM) &&
-			    (strncmp(inq->vendor_id, "HP ", 3) == 0)) {
+			if ((type == TYPE_ROM) &&
+			    (strncmp(sdev->vendor, "HP ", 3) == 0)) {
 				asc_dvc->pci_fix_asyn_xfer_always |= tid_bits;
 			}
 			asc_dvc->pci_fix_asyn_xfer |= tid_bits;
-			if ((dvc_type == TYPE_PROCESSOR) ||
-			    (dvc_type == TYPE_SCANNER) ||
-			    (dvc_type == TYPE_ROM) || (dvc_type == TYPE_TAPE)) {
+			if ((type == TYPE_PROCESSOR) ||
+			    (type == TYPE_SCANNER) || (type == TYPE_ROM) ||
+			    (type == TYPE_TAPE)) {
 				asc_dvc->pci_fix_asyn_xfer &= ~tid_bits;
 			}
 
 			if (asc_dvc->pci_fix_asyn_xfer & tid_bits) {
 				AscSetRunChipSynRegAtID(asc_dvc->iop_base,
-							tid_no,
-							ASYN_SDTR_DATA_FIX_PCI_REV_AB);
+					sdev->id,
+					ASYN_SDTR_DATA_FIX_PCI_REV_AB);
 			}
 		}
 	}
-	return;
-}
-
-static int AscTagQueuingSafe(ASC_SCSI_INQUIRY *inq)
-{
-	if ((inq->add_len >= 32) &&
-	    (strncmp(inq->vendor_id, "QUANTUM XP34301", 15) == 0) &&
-	    (strncmp(inq->product_rev_level, "1071", 4) == 0)) {
-		return 0;
-	}
-	return 1;
-}
-
-static void
-AscInquiryHandling(ASC_DVC_VAR *asc_dvc, uchar tid_no, ASC_SCSI_INQUIRY *inq)
-{
-	ASC_SCSI_BIT_ID_TYPE tid_bit = ASC_TIX_TO_TARGET_ID(tid_no);
-	ASC_SCSI_BIT_ID_TYPE orig_init_sdtr, orig_use_tagged_qng;
-
-	orig_init_sdtr = asc_dvc->init_sdtr;
-	orig_use_tagged_qng = asc_dvc->use_tagged_qng;
-
-	asc_dvc->init_sdtr &= ~tid_bit;
-	asc_dvc->cfg->can_tagged_qng &= ~tid_bit;
-	asc_dvc->use_tagged_qng &= ~tid_bit;
-
-	if (ASC_INQ_RESPONSE_FMT(inq) >= 2 || ASC_INQ_ANSI_VER(inq) >= 2) {
-		if ((asc_dvc->cfg->sdtr_enable & tid_bit) && ASC_INQ_SYNC(inq)) {
-			asc_dvc->init_sdtr |= tid_bit;
-		}
-		if ((asc_dvc->cfg->cmd_qng_enabled & tid_bit) &&
-		    ASC_INQ_CMD_QUEUE(inq)) {
-			if (AscTagQueuingSafe(inq)) {
-				asc_dvc->use_tagged_qng |= tid_bit;
-				asc_dvc->cfg->can_tagged_qng |= tid_bit;
-			}
-		}
-	}
-	if (orig_use_tagged_qng != asc_dvc->use_tagged_qng) {
-		AscWriteLramByte(asc_dvc->iop_base, ASCV_DISC_ENABLE_B,
-				 asc_dvc->cfg->disc_enable);
-		AscWriteLramByte(asc_dvc->iop_base, ASCV_USE_TAGGED_QNG_B,
-				 asc_dvc->use_tagged_qng);
-		AscWriteLramByte(asc_dvc->iop_base, ASCV_CAN_TAGGED_QNG_B,
-				 asc_dvc->cfg->can_tagged_qng);
-
-		asc_dvc->max_dvc_qng[tid_no] =
-		    asc_dvc->cfg->max_tag_qng[tid_no];
-		AscWriteLramByte(asc_dvc->iop_base,
-				 (ushort)(ASCV_MAX_DVC_QNG_BEG + tid_no),
-				 asc_dvc->max_dvc_qng[tid_no]);
-	}
-	if (orig_init_sdtr != asc_dvc->init_sdtr) {
-		AscAsyncFix(asc_dvc, tid_no, inq);
-	}
-	return;
 }
 
 static uchar AscReadLramByte(PortAddr iop_base, ushort addr)
@@ -14158,7 +14122,7 @@ static int AdvInitAsc3550Driver(ADV_DVC_VAR *asc_dvc)
 
 	/*
 	 * Microcode operating variables for WDTR, SDTR, and command tag
-	 * queuing will be set in AdvInquiryHandling() based on what a
+	 * queuing will be set in slave_configure() based on what a
 	 * device reports it is capable of in Inquiry byte 7.
 	 *
 	 * If SCSI Bus Resets have been disabled, then directly set
@@ -14809,7 +14773,7 @@ static int AdvInitAsc38C0800Driver(ADV_DVC_VAR *asc_dvc)
 
 	/*
 	 * Microcode operating variables for WDTR, SDTR, and command tag
-	 * queuing will be set in AdvInquiryHandling() based on what a
+	 * queuing will be set in slave_configure() based on what a
 	 * device reports it is capable of in Inquiry byte 7.
 	 *
 	 * If SCSI Bus Resets have been disabled, then directly set
@@ -15429,7 +15393,7 @@ static int AdvInitAsc38C1600Driver(ADV_DVC_VAR *asc_dvc)
 
 	/*
 	 * Microcode operating variables for WDTR, SDTR, and command tag
-	 * queuing will be set in AdvInquiryHandling() based on what a
+	 * queuing will be set in slave_configure() based on what a
 	 * device reports it is capable of in Inquiry byte 7.
 	 *
 	 * If SCSI Bus Resets have been disabled, then directly set
@@ -17113,23 +17077,6 @@ static int AdvISR(ADV_DVC_VAR *asc_dvc)
 		scsiq->cntl = 0;
 
 		/*
-		 * If the command that completed was a SCSI INQUIRY and
-		 * LUN 0 was sent the command, then process the INQUIRY
-		 * command information for the device.
-		 *
-		 * Note: If data returned were either VPD or CmdDt data,
-		 * don't process the INQUIRY command information for
-		 * the device, otherwise may erroneously set *_able bits.
-		 */
-		if (scsiq->done_status == QD_NO_ERROR &&
-		    scsiq->cdb[0] == INQUIRY &&
-		    scsiq->target_lun == 0 &&
-		    (scsiq->cdb[1] & ADV_INQ_RTN_VPD_AND_CMDDT)
-		    == ADV_INQ_RTN_STD_INQUIRY_DATA) {
-			AdvInquiryHandling(asc_dvc, scsiq);
-		}
-
-		/*
 		 * Notify the driver of the completed request by passing
 		 * the ADV_SCSI_REQ_Q pointer to its callback function.
 		 */
@@ -17234,168 +17181,6 @@ AdvSendIdleCmd(ADV_DVC_VAR *asc_dvc,
 	return ADV_ERROR;
 }
 
-/*
- * Inquiry Information Byte 7 Handling
- *
- * Handle SCSI Inquiry Command information for a device by setting
- * microcode operating variables that affect WDTR, SDTR, and Tag
- * Queuing.
- */
-static void AdvInquiryHandling(ADV_DVC_VAR *asc_dvc, ADV_SCSI_REQ_Q *scsiq)
-{
-	AdvPortAddr iop_base;
-	uchar tid;
-	ADV_SCSI_INQUIRY *inq;
-	ushort tidmask;
-	ushort cfg_word;
-
-	/*
-	 * AdvInquiryHandling() requires up to INQUIRY information Byte 7
-	 * to be available.
-	 *
-	 * If less than 8 bytes of INQUIRY information were requested or less
-	 * than 8 bytes were transferred, then return. cdb[4] is the request
-	 * length and the ADV_SCSI_REQ_Q 'data_cnt' field is set by the
-	 * microcode to the transfer residual count.
-	 */
-
-	if (scsiq->cdb[4] < 8 ||
-	    (scsiq->cdb[4] - le32_to_cpu(scsiq->data_cnt)) < 8) {
-		return;
-	}
-
-	iop_base = asc_dvc->iop_base;
-	tid = scsiq->target_id;
-
-	inq = (ADV_SCSI_INQUIRY *) scsiq->vdata_addr;
-
-	/*
-	 * WDTR, SDTR, and Tag Queuing cannot be enabled for old devices.
-	 */
-	if (ADV_INQ_RESPONSE_FMT(inq) < 2 && ADV_INQ_ANSI_VER(inq) < 2) {
-		return;
-	} else {
-		/*
-		 * INQUIRY Byte 7 Handling
-		 *
-		 * Use a device's INQUIRY byte 7 to determine whether it
-		 * supports WDTR, SDTR, and Tag Queuing. If the feature
-		 * is enabled in the EEPROM and the device supports the
-		 * feature, then enable it in the microcode.
-		 */
-
-		tidmask = ADV_TID_TO_TIDMASK(tid);
-
-		/*
-		 * Wide Transfers
-		 *
-		 * If the EEPROM enabled WDTR for the device and the device
-		 * supports wide bus (16 bit) transfers, then turn on the
-		 * device's 'wdtr_able' bit and write the new value to the
-		 * microcode.
-		 */
-		if ((asc_dvc->wdtr_able & tidmask) && ADV_INQ_WIDE16(inq)) {
-			AdvReadWordLram(iop_base, ASC_MC_WDTR_ABLE, cfg_word);
-			if ((cfg_word & tidmask) == 0) {
-				cfg_word |= tidmask;
-				AdvWriteWordLram(iop_base, ASC_MC_WDTR_ABLE,
-						 cfg_word);
-
-				/*
-				 * Clear the microcode "SDTR negotiation" and "WDTR
-				 * negotiation" done indicators for the target to cause
-				 * it to negotiate with the new setting set above.
-				 * WDTR when accepted causes the target to enter
-				 * asynchronous mode, so SDTR must be negotiated.
-				 */
-				AdvReadWordLram(iop_base, ASC_MC_SDTR_DONE,
-						cfg_word);
-				cfg_word &= ~tidmask;
-				AdvWriteWordLram(iop_base, ASC_MC_SDTR_DONE,
-						 cfg_word);
-				AdvReadWordLram(iop_base, ASC_MC_WDTR_DONE,
-						cfg_word);
-				cfg_word &= ~tidmask;
-				AdvWriteWordLram(iop_base, ASC_MC_WDTR_DONE,
-						 cfg_word);
-			}
-		}
-
-		/*
-		 * Synchronous Transfers
-		 *
-		 * If the EEPROM enabled SDTR for the device and the device
-		 * supports synchronous transfers, then turn on the device's
-		 * 'sdtr_able' bit. Write the new value to the microcode.
-		 */
-		if ((asc_dvc->sdtr_able & tidmask) && ADV_INQ_SYNC(inq)) {
-			AdvReadWordLram(iop_base, ASC_MC_SDTR_ABLE, cfg_word);
-			if ((cfg_word & tidmask) == 0) {
-				cfg_word |= tidmask;
-				AdvWriteWordLram(iop_base, ASC_MC_SDTR_ABLE,
-						 cfg_word);
-
-				/*
-				 * Clear the microcode "SDTR negotiation" done indicator
-				 * for the target to cause it to negotiate with the new
-				 * setting set above.
-				 */
-				AdvReadWordLram(iop_base, ASC_MC_SDTR_DONE,
-						cfg_word);
-				cfg_word &= ~tidmask;
-				AdvWriteWordLram(iop_base, ASC_MC_SDTR_DONE,
-						 cfg_word);
-			}
-		}
-		/*
-		 * If the Inquiry data included enough space for the SPI-3
-		 * Clocking field, then check if DT mode is supported.
-		 */
-		if (asc_dvc->chip_type == ADV_CHIP_ASC38C1600 &&
-		    (scsiq->cdb[4] >= 57 ||
-		     (scsiq->cdb[4] - le32_to_cpu(scsiq->data_cnt)) >= 57)) {
-			/*
-			 * PPR (Parallel Protocol Request) Capable
-			 *
-			 * If the device supports DT mode, then it must be PPR capable.
-			 * The PPR message will be used in place of the SDTR and WDTR
-			 * messages to negotiate synchronous speed and offset, transfer
-			 * width, and protocol options.
-			 */
-			if (ADV_INQ_CLOCKING(inq) & ADV_INQ_CLOCKING_DT_ONLY) {
-				AdvReadWordLram(iop_base, ASC_MC_PPR_ABLE,
-						asc_dvc->ppr_able);
-				asc_dvc->ppr_able |= tidmask;
-				AdvWriteWordLram(iop_base, ASC_MC_PPR_ABLE,
-						 asc_dvc->ppr_able);
-			}
-		}
-
-		/*
-		 * If the EEPROM enabled Tag Queuing for the device and the
-		 * device supports Tag Queueing, then turn on the device's
-		 * 'tagqng_enable' bit in the microcode and set the microcode
-		 * maximum command count to the ADV_DVC_VAR 'max_dvc_qng'
-		 * value.
-		 *
-		 * Tag Queuing is disabled for the BIOS which runs in polled
-		 * mode and would see no benefit from Tag Queuing. Also by
-		 * disabling Tag Queuing in the BIOS devices with Tag Queuing
-		 * bugs will at least work with the BIOS.
-		 */
-		if ((asc_dvc->tagqng_able & tidmask) && ADV_INQ_CMD_QUEUE(inq)) {
-			AdvReadWordLram(iop_base, ASC_MC_TAGQNG_ABLE, cfg_word);
-			cfg_word |= tidmask;
-			AdvWriteWordLram(iop_base, ASC_MC_TAGQNG_ABLE,
-					 cfg_word);
-
-			AdvWriteByteLram(iop_base,
-					 ASC_MC_NUMBER_OF_MAX_CMD + tid,
-					 asc_dvc->max_dvc_qng);
-		}
-	}
-}
-
 static int __devinit
 advansys_wide_init_chip(asc_board_t *boardp, ADV_DVC_VAR *adv_dvc_varp)
 {
-- 
1.4.4.4

