From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/12] advansys: use standard data types
Date: Wed,  3 Dec 2014 12:45:01 +0100
Message-ID: <1417607105-85455-9-git-send-email-hare@suse.de>
References: <1417607105-85455-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55171 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbaLCLpK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2014 06:45:10 -0500
In-Reply-To: <1417607105-85455-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew@wil.cx>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

No point in defining our own.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/advansys.c | 176 ++++++++++++++++++------------------------------
 1 file changed, 67 insertions(+), 109 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 0d29d0b..364f3f8 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -76,20 +76,6 @@
 /* Enable driver tracing. */
 #undef ADVANSYS_DEBUG
 
-/*
- * Portable Data Types
- *
- * Any instance where a 32-bit long or pointer type is assumed
- * for precision or HW defined structures, the following define
- * types must be used. In Linux the char, short, and int types
- * are all consistent at 8, 16, and 32 bits respectively. Pointers
- * and long types are 64 bits on Alpha and UltraSPARC.
- */
-#define ASC_PADDR __u32		/* Physical/Bus address data type. */
-#define ASC_VADDR __u32		/* Virtual address data type. */
-#define ASC_DCNT  __u32		/* Unsigned Data count type. */
-#define ASC_SDCNT __s32		/* Signed Data count type. */
-
 typedef unsigned char uchar;
 
 #ifndef TRUE
@@ -307,8 +293,8 @@ typedef struct asc_scsiq_1 {
 	uchar sg_queue_cnt;
 	uchar target_id;
 	uchar target_lun;
-	ASC_PADDR data_addr;
-	ASC_DCNT data_cnt;
+	__le32 data_addr;
+	__le32 data_cnt;
 	__le32 sense_addr;
 	uchar sense_len;
 	uchar extra_bytes;
@@ -338,8 +324,8 @@ typedef struct asc_scsiq_4 {
 	uchar y_res;
 	ushort x_req_count;
 	ushort x_reconnect_rtn;
-	ASC_PADDR x_saved_data_addr;
-	ASC_DCNT x_saved_data_cnt;
+	__le32 x_saved_data_addr;
+	__le32 x_saved_data_cnt;
 } ASC_SCSIQ_4;
 
 typedef struct asc_q_done_info {
@@ -351,12 +337,12 @@ typedef struct asc_q_done_info {
 	uchar sense_len;
 	uchar extra_bytes;
 	uchar res;
-	ASC_DCNT remain_bytes;
+	u32 remain_bytes;
 } ASC_QDONE_INFO;
 
 typedef struct asc_sg_list {
-	ASC_PADDR addr;
-	ASC_DCNT bytes;
+	__le32 addr;
+	__le32 bytes;
 } ASC_SG_LIST;
 
 typedef struct asc_sg_head {
@@ -586,13 +572,13 @@ typedef struct asc_dvc_var {
 	char redo_scam;
 	ushort res2;
 	uchar dos_int13_table[ASC_MAX_TID + 1];
-	ASC_DCNT max_dma_count;
+	unsigned int max_dma_count;
 	ASC_SCSI_BIT_ID_TYPE no_scam;
 	ASC_SCSI_BIT_ID_TYPE pci_fix_asyn_xfer;
 	uchar min_sdtr_index;
 	uchar max_sdtr_index;
 	struct asc_board *drv_ptr;
-	ASC_DCNT uc_break;
+	unsigned int uc_break;
 } ASC_DVC_VAR;
 
 typedef struct asc_dvc_inq_info {
@@ -600,8 +586,8 @@ typedef struct asc_dvc_inq_info {
 } ASC_DVC_INQ_INFO;
 
 typedef struct asc_cap_info {
-	ASC_DCNT lba;
-	ASC_DCNT blk_size;
+	u32 lba;
+	u32 blk_size;
 } ASC_CAP_INFO;
 
 typedef struct asc_cap_info_array {
@@ -928,20 +914,6 @@ typedef struct asc_mc_saved {
 #define AscWriteChipDvcID(port, data)     outp((port)+IOP_REG_ID, data)
 
 /*
- * Portable Data Types
- *
- * Any instance where a 32-bit long or pointer type is assumed
- * for precision or HW defined structures, the following define
- * types must be used. In Linux the char, short, and int types
- * are all consistent at 8, 16, and 32 bits respectively. Pointers
- * and long types are 64 bits on Alpha and UltraSPARC.
- */
-#define ADV_PADDR __u32		/* Physical address data type. */
-#define ADV_VADDR __u32		/* Virtual address data type. */
-#define ADV_DCNT  __u32		/* Unsigned Data count type. */
-#define ADV_SDCNT __s32		/* Signed Data count type. */
-
-/*
  * These macros are used to convert a virtual address to a
  * 32-bit value. This currently can be used on Linux Alpha
  * which uses 64-bit virtual address but a 32-bit bus address.
@@ -949,7 +921,6 @@ typedef struct asc_mc_saved {
  * will give us time to change the HW and FW to handle 64-bit
  * addresses.
  */
-#define ADV_VADDR_TO_U32   virt_to_bus
 #define ADV_U32_TO_VADDR   bus_to_virt
 
 #define AdvPortAddr  void __iomem *	/* Virtual memory address size */
@@ -1843,8 +1814,8 @@ typedef struct adv_scsi_req_q {
 	uchar target_cmd;
 	uchar target_id;	/* Device target identifier. */
 	uchar target_lun;	/* Device target logical unit number. */
-	ADV_PADDR data_addr;	/* Data buffer physical address. */
-	ADV_DCNT data_cnt;	/* Data count. Ucode sets to residual. */
+	__le32 data_addr;	/* Data buffer physical address. */
+	__le32 data_cnt;	/* Data count. Ucode sets to residual. */
 	__le32 sense_addr;
 	__le32 carr_pa;
 	uchar mflag;
@@ -1856,7 +1827,7 @@ typedef struct adv_scsi_req_q {
 	uchar host_status;	/* Ucode host status. */
 	uchar sg_working_ix;
 	uchar cdb[12];		/* SCSI CDB bytes 0-11. */
-	ADV_PADDR sg_real_addr;	/* SG list physical address. */
+	__le32 sg_real_addr;	/* SG list physical address. */
 	__le32 scsiq_rptr;
 	uchar cdb16[4];		/* SCSI CDB bytes 12-15. */
 	__le32 scsiq_ptr;
@@ -2078,8 +2049,7 @@ do { \
  *      ADV_FALSE(0) - Queue was not found on the active queue list.
  */
 #define AdvAbortQueue(asc_dvc, srb_tag) \
-        AdvSendIdleCmd((asc_dvc), (ushort) IDLE_CMD_ABORT, \
-                       (ADV_DCNT) (srb_tag))
+     AdvSendIdleCmd((asc_dvc), (ushort) IDLE_CMD_ABORT, (srb_tag))
 
 /*
  * Send a Bus Device Reset Message to the specified target ID.
@@ -2093,8 +2063,7 @@ do { \
  *                     are not purged.
  */
 #define AdvResetDevice(asc_dvc, target_id) \
-        AdvSendIdleCmd((asc_dvc), (ushort) IDLE_CMD_DEVICE_RESET, \
-                    (ADV_DCNT) (target_id))
+     AdvSendIdleCmd((asc_dvc), (ushort) IDLE_CMD_DEVICE_RESET, (target_id))
 
 /*
  * SCSI Wide Type definition.
@@ -2151,8 +2120,6 @@ do { \
 #define QHSTA_M_SGBACKUP_ERROR      0x47	/* Scatter-Gather backup error */
 
 /* Return the address that is aligned at the next doubleword >= to 'addr'. */
-#define ADV_8BALIGN(addr)      (((ulong) (addr) + 0x7) & ~0x7)
-#define ADV_16BALIGN(addr)     (((ulong) (addr) + 0xF) & ~0xF)
 #define ADV_32BALIGN(addr)     (((ulong) (addr) + 0x1F) & ~0x1F)
 
 /*
@@ -2313,24 +2280,24 @@ do { \
 /* Per board statistics structure */
 struct asc_stats {
 	/* Driver Entrypoint Statistics */
-	ADV_DCNT queuecommand;	/* # calls to advansys_queuecommand() */
-	ADV_DCNT reset;		/* # calls to advansys_eh_bus_reset() */
-	ADV_DCNT biosparam;	/* # calls to advansys_biosparam() */
-	ADV_DCNT interrupt;	/* # advansys_interrupt() calls */
-	ADV_DCNT callback;	/* # calls to asc/adv_isr_callback() */
-	ADV_DCNT done;		/* # calls to request's scsi_done function */
-	ADV_DCNT build_error;	/* # asc/adv_build_req() ASC_ERROR returns. */
-	ADV_DCNT adv_build_noreq;	/* # adv_build_req() adv_req_t alloc. fail. */
-	ADV_DCNT adv_build_nosg;	/* # adv_build_req() adv_sgblk_t alloc. fail. */
+	unsigned int queuecommand;	/* # calls to advansys_queuecommand() */
+	unsigned int reset;		/* # calls to advansys_eh_bus_reset() */
+	unsigned int biosparam;	/* # calls to advansys_biosparam() */
+	unsigned int interrupt;	/* # advansys_interrupt() calls */
+	unsigned int callback;	/* # calls to asc/adv_isr_callback() */
+	unsigned int done;		/* # calls to request's scsi_done function */
+	unsigned int build_error;	/* # asc/adv_build_req() ASC_ERROR returns. */
+	unsigned int adv_build_noreq;	/* # adv_build_req() adv_req_t alloc. fail. */
+	unsigned int adv_build_nosg;	/* # adv_build_req() adv_sgblk_t alloc. fail. */
 	/* AscExeScsiQueue()/AdvExeScsiQueue() Statistics */
-	ADV_DCNT exe_noerror;	/* # ASC_NOERROR returns. */
-	ADV_DCNT exe_busy;	/* # ASC_BUSY returns. */
-	ADV_DCNT exe_error;	/* # ASC_ERROR returns. */
-	ADV_DCNT exe_unknown;	/* # unknown returns. */
+	unsigned int exe_noerror;	/* # ASC_NOERROR returns. */
+	unsigned int exe_busy;	/* # ASC_BUSY returns. */
+	unsigned int exe_error;	/* # ASC_ERROR returns. */
+	unsigned int exe_unknown;	/* # unknown returns. */
 	/* Data Transfer Statistics */
-	ADV_DCNT xfer_cnt;	/* # I/O requests received */
-	ADV_DCNT xfer_elem;	/* # scatter-gather elements */
-	ADV_DCNT xfer_sect;	/* # 512-byte blocks */
+	unsigned int xfer_cnt;	/* # I/O requests received */
+	unsigned int xfer_elem;	/* # scatter-gather elements */
+	unsigned int xfer_sect;	/* # 512-byte blocks */
 };
 #endif /* ADVANSYS_STATS */
 
@@ -3914,15 +3881,15 @@ static ushort AscReadLramWord(PortAddr iop_base, ushort addr)
 }
 
 #if CC_VERY_LONG_SG_LIST
-static ASC_DCNT AscReadLramDWord(PortAddr iop_base, ushort addr)
+static u32 AscReadLramDWord(PortAddr iop_base, ushort addr)
 {
 	ushort val_low, val_high;
-	ASC_DCNT dword_data;
+	u32 dword_data;
 
 	AscSetChipLramAddr(iop_base, addr);
 	val_low = AscGetChipLramData(iop_base);
 	val_high = AscGetChipLramData(iop_base);
-	dword_data = ((ASC_DCNT) val_high << 16) | (ASC_DCNT) val_low;
+	dword_data = ((u32) val_high << 16) | (u32) val_low;
 	return (dword_data);
 }
 #endif /* CC_VERY_LONG_SG_LIST */
@@ -4028,12 +3995,11 @@ AscMemWordCopyPtrFromLram(PortAddr iop_base,
 	}
 }
 
-static ASC_DCNT AscMemSumLramWord(PortAddr iop_base, ushort s_addr, int words)
+static u32 AscMemSumLramWord(PortAddr iop_base, ushort s_addr, int words)
 {
-	ASC_DCNT sum;
+	u32 sum = 0;
 	int i;
 
-	sum = 0L;
 	for (i = 0; i < words; i++, s_addr += 2) {
 		sum += AscReadLramWord(iop_base, s_addr);
 	}
@@ -4090,11 +4056,11 @@ static ushort AscInitLram(ASC_DVC_VAR *asc_dvc)
 	return warn_code;
 }
 
-static ASC_DCNT
+static u32
 AscLoadMicroCode(PortAddr iop_base, ushort s_addr,
 		 const uchar *mcode_buf, ushort mcode_size)
 {
-	ASC_DCNT chksum;
+	u32 chksum;
 	ushort mcode_word_size;
 	ushort mcode_chksum;
 
@@ -4151,8 +4117,8 @@ static ushort AscInitMicroCodeVar(ASC_DVC_VAR *asc_dvc)
 	int i;
 	ushort warn_code;
 	PortAddr iop_base;
-	ASC_PADDR phy_addr;
-	ASC_DCNT phy_size;
+	__le32 phy_addr;
+	__le32 phy_size;
 	struct asc_board *board = asc_dvc_to_board(asc_dvc);
 
 	iop_base = asc_dvc->iop_base;
@@ -4296,7 +4262,7 @@ static int AdvLoadMicrocode(AdvPortAddr iop_base, const unsigned char *buf,
 			    int size, int memsize, int chksum)
 {
 	int i, j, end, len = 0;
-	ADV_DCNT sum;
+	u32 sum;
 
 	AdvWriteWordRegister(iop_base, IOPW_RAM_ADDR, 0);
 
@@ -4426,10 +4392,9 @@ static adv_req_t * adv_get_reqp(struct adv_dvc_var *adv_dvc, u32 offset)
  */
 static int
 AdvSendIdleCmd(ADV_DVC_VAR *asc_dvc,
-	       ushort idle_cmd, ADV_DCNT idle_cmd_parameter)
+	       ushort idle_cmd, u32 idle_cmd_parameter)
 {
-	int result;
-	ADV_DCNT i, j;
+	int result, i, j;
 	AdvPortAddr iop_base;
 
 	iop_base = asc_dvc->iop_base;
@@ -6094,7 +6059,7 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 	adv_req_t *reqp;
 	adv_sgblk_t *sgblkp;
 	struct scsi_cmnd *scp;
-	ADV_DCNT resid_cnt;
+	u32 resid_cnt;
 	dma_addr_t sense_addr;
 
 	ASC_DBG(1, "adv_dvc_varp 0x%p, scsiqp 0x%p\n",
@@ -6264,7 +6229,7 @@ static int AdvISR(ADV_DVC_VAR *asc_dvc)
 	uchar int_stat;
 	ushort target_bit;
 	ADV_CARR_T *free_carrp;
-	ADV_VADDR irq_next_vpa;
+	__le32 irq_next_vpa;
 	ADV_SCSI_REQ_Q *scsiq;
 	adv_req_t *reqp;
 
@@ -6998,7 +6963,7 @@ DvcGetQinfo(PortAddr iop_base, ushort s_addr, uchar *inbuf, int words)
 static uchar
 _AscCopyLramScsiDoneQ(PortAddr iop_base,
 		      ushort q_addr,
-		      ASC_QDONE_INFO *scsiq, ASC_DCNT max_dma_count)
+		      ASC_QDONE_INFO *scsiq, unsigned int max_dma_count)
 {
 	ushort _val;
 	uchar sg_queue_cnt;
@@ -7025,10 +6990,10 @@ _AscCopyLramScsiDoneQ(PortAddr iop_base,
 	/*
 	 * Read high word of remain bytes from alternate location.
 	 */
-	scsiq->remain_bytes = (((ADV_DCNT)AscReadLramWord(iop_base,
-							  (ushort)(q_addr +
-								   (ushort)
-								   ASC_SCSIQ_W_ALT_DC1)))
+	scsiq->remain_bytes = (((u32)AscReadLramWord(iop_base,
+						     (ushort)(q_addr +
+							      (ushort)
+							      ASC_SCSIQ_W_ALT_DC1)))
 			       << 16);
 	/*
 	 * Read low word of remain bytes from original location.
@@ -7255,8 +7220,7 @@ static int AscIsrQDone(ASC_DVC_VAR *asc_dvc)
 		} else if (scsiq->q_status == QS_DONE) {
 			false_overrun = FALSE;
 			if (scsiq->extra_bytes != 0) {
-				scsiq->remain_bytes +=
-				    (ADV_DCNT)scsiq->extra_bytes;
+				scsiq->remain_bytes += scsiq->extra_bytes;
 			}
 			if (scsiq->d3.done_stat == QD_WITH_ERROR) {
 				if (scsiq->d3.host_stat ==
@@ -8301,8 +8265,8 @@ AscPutReadySgListQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq, uchar q_no)
 	int i;
 	ASC_SG_HEAD *sg_head;
 	ASC_SG_LIST_Q scsi_sg_q;
-	ASC_DCNT saved_data_addr;
-	ASC_DCNT saved_data_cnt;
+	__le32 saved_data_addr;
+	__le32 saved_data_cnt;
 	PortAddr iop_base;
 	ushort sg_list_dwords;
 	ushort sg_index;
@@ -8314,8 +8278,8 @@ AscPutReadySgListQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq, uchar q_no)
 	sg_head = scsiq->sg_head;
 	saved_data_addr = scsiq->q1.data_addr;
 	saved_data_cnt = scsiq->q1.data_cnt;
-	scsiq->q1.data_addr = (ASC_PADDR) sg_head->sg_list[0].addr;
-	scsiq->q1.data_cnt = (ASC_DCNT) sg_head->sg_list[0].bytes;
+	scsiq->q1.data_addr = sg_head->sg_list[0].addr;
+	scsiq->q1.data_cnt = sg_head->sg_list[0].bytes;
 #if CC_VERY_LONG_SG_LIST
 	/*
 	 * If sg_head->entry_cnt is greater than ASC_MAX_SG_LIST
@@ -8495,7 +8459,7 @@ static int AscExeScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq)
 	int n_q_required;
 	int disable_syn_offset_one_fix;
 	int i;
-	ASC_PADDR addr;
+	u32 addr;
 	ushort sg_entry_cnt = 0;
 	ushort sg_entry_cnt_minus_one = 0;
 	uchar target_ix;
@@ -8505,7 +8469,7 @@ static int AscExeScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq)
 	uchar scsi_cmd;
 	uchar disable_cmd;
 	ASC_SG_HEAD *sg_head;
-	ASC_DCNT data_cnt;
+	unsigned long data_cnt;
 
 	iop_base = asc_dvc->iop_base;
 	sg_head = scsiq->sg_head;
@@ -8551,10 +8515,8 @@ static int AscExeScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq)
 		}
 #endif /* !CC_VERY_LONG_SG_LIST */
 		if (sg_entry_cnt == 1) {
-			scsiq->q1.data_addr =
-			    (ADV_PADDR)sg_head->sg_list[0].addr;
-			scsiq->q1.data_cnt =
-			    (ADV_DCNT)sg_head->sg_list[0].bytes;
+			scsiq->q1.data_addr = sg_head->sg_list[0].addr;
+			scsiq->q1.data_cnt = sg_head->sg_list[0].bytes;
 			scsiq->q1.cntl &= ~(QC_SG_HEAD | QC_SG_SWAP_QUEUE);
 		}
 		sg_entry_cnt_minus_one = sg_entry_cnt - 1;
@@ -8566,9 +8528,8 @@ static int AscExeScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq)
 		if (scsiq->q1.cntl & QC_SG_HEAD) {
 			data_cnt = 0;
 			for (i = 0; i < sg_entry_cnt; i++) {
-				data_cnt +=
-				    (ADV_DCNT)le32_to_cpu(sg_head->sg_list[i].
-							  bytes);
+				data_cnt += le32_to_cpu(sg_head->sg_list[i].
+							bytes);
 			}
 		} else {
 			data_cnt = le32_to_cpu(scsiq->q1.data_cnt);
@@ -8605,12 +8566,11 @@ static int AscExeScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq)
 			if (asc_dvc->bug_fix_cntl & ASC_BUG_FIX_IF_NOT_DWB) {
 				if ((scsi_cmd == READ_6) ||
 				    (scsi_cmd == READ_10)) {
-					addr =
-					    (ADV_PADDR)le32_to_cpu(sg_head->
+					addr = le32_to_cpu(sg_head->
 								   sg_list
 								   [sg_entry_cnt_minus_one].
 								   addr) +
-					    (ADV_DCNT)le32_to_cpu(sg_head->
+						le32_to_cpu(sg_head->
 								  sg_list
 								  [sg_entry_cnt_minus_one].
 								  bytes);
@@ -8631,8 +8591,7 @@ static int AscExeScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq)
 								sg_list
 								[sg_entry_cnt_minus_one].
 								bytes);
-						data_cnt -=
-						    (ASC_DCNT) extra_bytes;
+						data_cnt -= extra_bytes;
 						sg_head->
 						    sg_list
 						    [sg_entry_cnt_minus_one].
@@ -8687,8 +8646,7 @@ static int AscExeScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq)
 						    == 0) {
 							scsiq->q2.tag_code |=
 							    ASC_TAG_FLAG_EXTRA_BYTES;
-							data_cnt -= (ASC_DCNT)
-							    extra_bytes;
+							data_cnt -= extra_bytes;
 							scsiq->q1.data_cnt =
 							    cpu_to_le32
 							    (data_cnt);
@@ -9051,7 +9009,7 @@ static int AscStopQueueExe(PortAddr iop_base)
 	return (0);
 }
 
-static ASC_DCNT AscGetMaxDmaCount(ushort bus_type)
+static unsigned int AscGetMaxDmaCount(ushort bus_type)
 {
 	if (bus_type & ASC_IS_ISA)
 		return ASC_MAX_ISA_DMA_COUNT;
-- 
1.8.5.2

