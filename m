From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 15/17] advansys: Make sdtr_period_tbl a pointer
Date: Sun, 16 Sep 2007 09:37:46 -0600
Message-ID: <11899570694046-git-send-email-matthew@wil.cx>
References: <1189867145.3339.3.camel@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:53161 "EHLO
	mail-02.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbXIPPhj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Sep 2007 11:37:39 -0400
In-Reply-To: <1189867145.3339.3.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

It's somewhat neater to make this a pointer to one of two tables
than initialising an array in the driver.  Also delete the unused
AscSynIndexToPeriod and rename host_init_sdtr_index to min_sdtr_index

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |   90 +++++++++++++----------------------------------
 1 files changed, 25 insertions(+), 65 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 798545d..899151a 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -481,34 +481,22 @@ typedef struct asc_risc_sg_list_q {
 #define ASC_MAX_PCI_INRAM_TOTAL_QNG  20
 #define ASC_MAX_INRAM_TAG_QNG   16
 #define ASC_IOADR_GAP   0x10
-#define ASC_MAX_SYN_XFER_NO        16
 #define ASC_SYN_MAX_OFFSET         0x0F
 #define ASC_DEF_SDTR_OFFSET        0x0F
 #define ASC_SDTR_ULTRA_PCI_10MB_INDEX  0x02
-#define SYN_XFER_NS_0  25
-#define SYN_XFER_NS_1  30
-#define SYN_XFER_NS_2  35
-#define SYN_XFER_NS_3  40
-#define SYN_XFER_NS_4  50
-#define SYN_XFER_NS_5  60
-#define SYN_XFER_NS_6  70
-#define SYN_XFER_NS_7  85
-#define SYN_ULTRA_XFER_NS_0    12
-#define SYN_ULTRA_XFER_NS_1    19
-#define SYN_ULTRA_XFER_NS_2    25
-#define SYN_ULTRA_XFER_NS_3    32
-#define SYN_ULTRA_XFER_NS_4    38
-#define SYN_ULTRA_XFER_NS_5    44
-#define SYN_ULTRA_XFER_NS_6    50
-#define SYN_ULTRA_XFER_NS_7    57
-#define SYN_ULTRA_XFER_NS_8    63
-#define SYN_ULTRA_XFER_NS_9    69
-#define SYN_ULTRA_XFER_NS_10   75
-#define SYN_ULTRA_XFER_NS_11   82
-#define SYN_ULTRA_XFER_NS_12   88
-#define SYN_ULTRA_XFER_NS_13   94
-#define SYN_ULTRA_XFER_NS_14  100
-#define SYN_ULTRA_XFER_NS_15  107
+#define ASYN_SDTR_DATA_FIX_PCI_REV_AB 0x41
+
+/* The narrow chip only supports a limited selection of transfer rates.
+ * These are encoded in the range 0..7 or 0..15 depending whether the chip
+ * is Ultra-capable or not.  These tables let us convert from one to the other.
+ */
+static const unsigned char asc_syn_xfer_period[8] = {
+	25, 30, 35, 40, 50, 60, 70, 85
+};
+
+static const unsigned char asc_syn_ultra_xfer_period[16] = {
+	12, 19, 25, 32, 38, 44, 50, 57, 63, 69, 75, 82, 88, 94, 100, 107
+};
 
 typedef struct ext_msg {
 	uchar msg_type;
@@ -572,7 +560,6 @@ typedef struct asc_dvc_cfg {
 #define ASC_INIT_STATE_WITHOUT_EEP   0x8000
 #define ASC_BUG_FIX_IF_NOT_DWB       0x0001
 #define ASC_BUG_FIX_ASYN_USE_SYN     0x0002
-#define ASYN_SDTR_DATA_FIX_PCI_REV_AB 0x41
 #define ASC_MIN_TAGGED_CMD  7
 #define ASC_MAX_SCSI_RESET_WAIT      30
 
@@ -602,7 +589,7 @@ typedef struct asc_dvc_var {
 	uchar max_dvc_qng[ASC_MAX_TID + 1];
 	ASC_SCSI_Q *scsiq_busy_head[ASC_MAX_TID + 1];
 	ASC_SCSI_Q *scsiq_busy_tail[ASC_MAX_TID + 1];
-	uchar sdtr_period_tbl[ASC_MAX_SYN_XFER_NO];
+	const uchar *sdtr_period_tbl;
 	ASC_DVC_CFG *cfg;
 	ASC_SCSI_BIT_ID_TYPE pci_fix_asyn_xfer_always;
 	char redo_scam;
@@ -611,8 +598,8 @@ typedef struct asc_dvc_var {
 	ASC_DCNT max_dma_count;
 	ASC_SCSI_BIT_ID_TYPE no_scam;
 	ASC_SCSI_BIT_ID_TYPE pci_fix_asyn_xfer;
+	uchar min_sdtr_index;
 	uchar max_sdtr_index;
-	uchar host_init_sdtr_index;
 	struct asc_board *drv_ptr;
 	ASC_DCNT uc_break;
 } ASC_DVC_VAR;
@@ -896,7 +883,6 @@ typedef struct asc_mc_saved {
 #define AscGetMCodeSDTRDoneAtID(port, id)        AscReadLramByte((port), (ushort)((ushort)ASCV_SDTR_DONE_BEG+(ushort)id))
 #define AscPutMCodeInitSDTRAtID(port, id, data)  AscWriteLramByte((port), (ushort)((ushort)ASCV_SDTR_DATA_BEG+(ushort)id), data)
 #define AscGetMCodeInitSDTRAtID(port, id)        AscReadLramByte((port), (ushort)((ushort)ASCV_SDTR_DATA_BEG+(ushort)id))
-#define AscSynIndexToPeriod(index)        (uchar)(asc_dvc->sdtr_period_tbl[ (index) ])
 #define AscGetChipSignatureByte(port)     (uchar)inp((port)+IOP_SIG_BYTE)
 #define AscGetChipSignatureWord(port)     (ushort)inpw((port)+IOP_SIG_WORD)
 #define AscGetChipVerNo(port)             (uchar)inp((port)+IOP_VERSION)
@@ -8556,14 +8542,14 @@ static void AscAckInterrupt(PortAddr iop_base)
 
 static uchar AscGetSynPeriodIndex(ASC_DVC_VAR *asc_dvc, uchar syn_time)
 {
-	uchar *period_table;
+	const uchar *period_table;
 	int max_index;
 	int min_index;
 	int i;
 
 	period_table = asc_dvc->sdtr_period_tbl;
 	max_index = (int)asc_dvc->max_sdtr_index;
-	min_index = (int)asc_dvc->host_init_sdtr_index;
+	min_index = (int)asc_dvc->min_sdtr_index;
 	if ((syn_time <= period_table[max_index])) {
 		for (i = min_index; i < (max_index - 1); i++) {
 			if (syn_time <= period_table[i]) {
@@ -8612,9 +8598,8 @@ AscCalSDTRData(ASC_DVC_VAR *asc_dvc, uchar sdtr_period, uchar syn_offset)
 	uchar sdtr_period_ix;
 
 	sdtr_period_ix = AscGetSynPeriodIndex(asc_dvc, sdtr_period);
-	if (sdtr_period_ix > asc_dvc->max_sdtr_index) {
+	if (sdtr_period_ix > asc_dvc->max_sdtr_index)
 		return 0xFF;
-	}
 	byte = (sdtr_period_ix << 4) | (syn_offset & ASC_SYN_MAX_OFFSET);
 	return byte;
 }
@@ -8725,15 +8710,14 @@ static int AscIsrChipHalted(ASC_DVC_VAR *asc_dvc)
 				ext_msg.req_ack_offset = ASC_SYN_MAX_OFFSET;
 			}
 			if ((ext_msg.xfer_period <
-			     asc_dvc->sdtr_period_tbl[asc_dvc->
-						      host_init_sdtr_index])
+			     asc_dvc->sdtr_period_tbl[asc_dvc->min_sdtr_index])
 			    || (ext_msg.xfer_period >
 				asc_dvc->sdtr_period_tbl[asc_dvc->
 							 max_sdtr_index])) {
 				sdtr_accept = FALSE;
 				ext_msg.xfer_period =
 				    asc_dvc->sdtr_period_tbl[asc_dvc->
-							     host_init_sdtr_index];
+							     min_sdtr_index];
 			}
 			if (sdtr_accept) {
 				sdtr_data =
@@ -8757,7 +8741,6 @@ static int AscIsrChipHalted(ASC_DVC_VAR *asc_dvc)
 				AscSetChipSDTR(iop_base, asyn_sdtr, tid_no);
 			} else {
 				if (sdtr_accept && (q_cntl & QC_MSG_OUT)) {
-
 					q_cntl &= ~QC_MSG_OUT;
 					asc_dvc->sdtr_done |= target_id;
 					asc_dvc->init_sdtr |= target_id;
@@ -8772,7 +8755,6 @@ static int AscIsrChipHalted(ASC_DVC_VAR *asc_dvc)
 						       tid_no);
 					boardp->sdtr_data[tid_no] = sdtr_data;
 				} else {
-
 					q_cntl |= QC_MSG_OUT;
 					AscMsgOutSDTR(asc_dvc,
 						      ext_msg.xfer_period,
@@ -11407,7 +11389,7 @@ static ushort __devinit AscInitAscDvcVar(ASC_DVC_VAR *asc_dvc)
 	asc_dvc->queue_full_or_busy = 0;
 	asc_dvc->redo_scam = 0;
 	asc_dvc->res2 = 0;
-	asc_dvc->host_init_sdtr_index = 0;
+	asc_dvc->min_sdtr_index = 0;
 	asc_dvc->cfg->can_tagged_qng = 0;
 	asc_dvc->cfg->cmd_qng_enabled = 0;
 	asc_dvc->dvc_cntl = ASC_DEF_DVC_CNTL;
@@ -11421,34 +11403,12 @@ static ushort __devinit AscInitAscDvcVar(ASC_DVC_VAR *asc_dvc)
 	asc_dvc->cfg->chip_scsi_id = ASC_DEF_CHIP_SCSI_ID;
 	chip_version = AscGetChipVersion(iop_base, asc_dvc->bus_type);
 	asc_dvc->cfg->chip_version = chip_version;
-	asc_dvc->sdtr_period_tbl[0] = SYN_XFER_NS_0;
-	asc_dvc->sdtr_period_tbl[1] = SYN_XFER_NS_1;
-	asc_dvc->sdtr_period_tbl[2] = SYN_XFER_NS_2;
-	asc_dvc->sdtr_period_tbl[3] = SYN_XFER_NS_3;
-	asc_dvc->sdtr_period_tbl[4] = SYN_XFER_NS_4;
-	asc_dvc->sdtr_period_tbl[5] = SYN_XFER_NS_5;
-	asc_dvc->sdtr_period_tbl[6] = SYN_XFER_NS_6;
-	asc_dvc->sdtr_period_tbl[7] = SYN_XFER_NS_7;
+	asc_dvc->sdtr_period_tbl = asc_syn_xfer_period;
 	asc_dvc->max_sdtr_index = 7;
 	if ((asc_dvc->bus_type & ASC_IS_PCI) &&
 	    (chip_version >= ASC_CHIP_VER_PCI_ULTRA_3150)) {
 		asc_dvc->bus_type = ASC_IS_PCI_ULTRA;
-		asc_dvc->sdtr_period_tbl[0] = SYN_ULTRA_XFER_NS_0;
-		asc_dvc->sdtr_period_tbl[1] = SYN_ULTRA_XFER_NS_1;
-		asc_dvc->sdtr_period_tbl[2] = SYN_ULTRA_XFER_NS_2;
-		asc_dvc->sdtr_period_tbl[3] = SYN_ULTRA_XFER_NS_3;
-		asc_dvc->sdtr_period_tbl[4] = SYN_ULTRA_XFER_NS_4;
-		asc_dvc->sdtr_period_tbl[5] = SYN_ULTRA_XFER_NS_5;
-		asc_dvc->sdtr_period_tbl[6] = SYN_ULTRA_XFER_NS_6;
-		asc_dvc->sdtr_period_tbl[7] = SYN_ULTRA_XFER_NS_7;
-		asc_dvc->sdtr_period_tbl[8] = SYN_ULTRA_XFER_NS_8;
-		asc_dvc->sdtr_period_tbl[9] = SYN_ULTRA_XFER_NS_9;
-		asc_dvc->sdtr_period_tbl[10] = SYN_ULTRA_XFER_NS_10;
-		asc_dvc->sdtr_period_tbl[11] = SYN_ULTRA_XFER_NS_11;
-		asc_dvc->sdtr_period_tbl[12] = SYN_ULTRA_XFER_NS_12;
-		asc_dvc->sdtr_period_tbl[13] = SYN_ULTRA_XFER_NS_13;
-		asc_dvc->sdtr_period_tbl[14] = SYN_ULTRA_XFER_NS_14;
-		asc_dvc->sdtr_period_tbl[15] = SYN_ULTRA_XFER_NS_15;
+		asc_dvc->sdtr_period_tbl = asc_syn_ultra_xfer_period;
 		asc_dvc->max_sdtr_index = 15;
 		if (chip_version == ASC_CHIP_VER_PCI_ULTRA_3150) {
 			AscSetExtraControl(iop_base,
@@ -11889,7 +11849,7 @@ static ushort __devinit AscInitFromEEP(ASC_DVC_VAR *asc_dvc)
 	asc_dvc->cfg->chip_scsi_id = ASC_EEP_GET_CHIP_ID(eep_config);
 	if (((asc_dvc->bus_type & ASC_IS_PCI_ULTRA) == ASC_IS_PCI_ULTRA) &&
 	    !(asc_dvc->dvc_cntl & ASC_CNTL_SDTR_ENABLE_ULTRA)) {
-		asc_dvc->host_init_sdtr_index = ASC_SDTR_ULTRA_PCI_10MB_INDEX;
+		asc_dvc->min_sdtr_index = ASC_SDTR_ULTRA_PCI_10MB_INDEX;
 	}
 
 	for (i = 0; i <= ASC_MAX_TID; i++) {
@@ -11897,7 +11857,7 @@ static ushort __devinit AscInitFromEEP(ASC_DVC_VAR *asc_dvc)
 		asc_dvc->cfg->max_tag_qng[i] = eep_config->max_tag_qng;
 		asc_dvc->cfg->sdtr_period_offset[i] =
 		    (uchar)(ASC_DEF_SDTR_OFFSET |
-			    (asc_dvc->host_init_sdtr_index << 4));
+			    (asc_dvc->min_sdtr_index << 4));
 	}
 	eep_config->cfg_msw = AscGetChipCfgMsw(iop_base);
 	if (write_eep) {
-- 
1.5.2.4

