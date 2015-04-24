From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 15/23] advansys: Remove CC_VERY_LONG_SG_LIST
Date: Fri, 24 Apr 2015 13:18:34 +0200
Message-ID: <1429874322-85488-17-git-send-email-hare@suse.de>
References: <1429874322-85488-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58917 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967103AbbDXLSv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Apr 2015 07:18:51 -0400
In-Reply-To: <1429874322-85488-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Ondrey Zary <linux@rainbow-software.org>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Was uncommented in the original driver, and I'm too lazy to
figure out the conversion.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/advansys.c | 243 +-----------------------------------------------
 1 file changed, 5 insertions(+), 238 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index ac9a9da..18f75ea 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -88,15 +88,6 @@ typedef unsigned char uchar;
 #define PCI_DEVICE_ID_38C0800_REV1	0x2500
 #define PCI_DEVICE_ID_38C1600_REV1	0x2700
 
-/*
- * Enable CC_VERY_LONG_SG_LIST to support up to 64K element SG lists.
- * The SRB structure will have to be changed and the ASC_SRB2SCSIQ()
- * macro re-defined to be able to obtain a ASC_SCSI_Q pointer from the
- * SRB structure.
- */
-#define CC_VERY_LONG_SG_LIST 0
-#define ASC_SRB2SCSIQ(srb_ptr)  (srb_ptr)
-
 #define PortAddr                 unsigned int	/* port address size  */
 #define inp(port)                inb(port)
 #define outp(port, byte)         outb((byte), (port))
@@ -3843,20 +3834,6 @@ static ushort AscReadLramWord(PortAddr iop_base, ushort addr)
 	return (word_data);
 }
 
-#if CC_VERY_LONG_SG_LIST
-static u32 AscReadLramDWord(PortAddr iop_base, ushort addr)
-{
-	ushort val_low, val_high;
-	u32 dword_data;
-
-	AscSetChipLramAddr(iop_base, addr);
-	val_low = AscGetChipLramData(iop_base);
-	val_high = AscGetChipLramData(iop_base);
-	dword_data = ((u32) val_high << 16) | (u32) val_low;
-	return (dword_data);
-}
-#endif /* CC_VERY_LONG_SG_LIST */
-
 static void
 AscMemWordSetLram(PortAddr iop_base, ushort s_addr, ushort set_wval, int words)
 {
@@ -6719,163 +6696,6 @@ static void AscIsrChipHalted(ASC_DVC_VAR *asc_dvc)
 		AscWriteLramWord(iop_base, ASCV_HALTCODE_W, 0);
 		return;
 	}
-#if CC_VERY_LONG_SG_LIST
-	else if (int_halt_code == ASC_HALT_HOST_COPY_SG_LIST_TO_RISC) {
-		uchar q_no;
-		ushort q_addr;
-		uchar sg_wk_q_no;
-		uchar first_sg_wk_q_no;
-		ASC_SCSI_Q *scsiq;	/* Ptr to driver request. */
-		ASC_SG_HEAD *sg_head;	/* Ptr to driver SG request. */
-		ASC_SG_LIST_Q scsi_sg_q;	/* Structure written to queue. */
-		ushort sg_list_dwords;
-		ushort sg_entry_cnt;
-		uchar next_qp;
-		int i;
-
-		q_no = AscReadLramByte(iop_base, (ushort)ASCV_REQ_SG_LIST_QP);
-		if (q_no == ASC_QLINK_END)
-			return 0;
-
-		q_addr = ASC_QNO_TO_QADDR(q_no);
-
-		/*
-		 * Convert the request's SRB pointer to a host ASC_SCSI_Q
-		 * structure pointer using a macro provided by the driver.
-		 * The ASC_SCSI_Q pointer provides a pointer to the
-		 * host ASC_SG_HEAD structure.
-		 */
-		/* Read request's SRB pointer. */
-		scsiq = (ASC_SCSI_Q *)
-		    ASC_SRB2SCSIQ(ASC_U32_TO_VADDR(AscReadLramDWord(iop_base,
-								    (ushort)
-								    (q_addr +
-								     ASC_SCSIQ_D_SRBPTR))));
-
-		/*
-		 * Get request's first and working SG queue.
-		 */
-		sg_wk_q_no = AscReadLramByte(iop_base,
-					     (ushort)(q_addr +
-						      ASC_SCSIQ_B_SG_WK_QP));
-
-		first_sg_wk_q_no = AscReadLramByte(iop_base,
-						   (ushort)(q_addr +
-							    ASC_SCSIQ_B_FIRST_SG_WK_QP));
-
-		/*
-		 * Reset request's working SG queue back to the
-		 * first SG queue.
-		 */
-		AscWriteLramByte(iop_base,
-				 (ushort)(q_addr +
-					  (ushort)ASC_SCSIQ_B_SG_WK_QP),
-				 first_sg_wk_q_no);
-
-		sg_head = scsiq->sg_head;
-
-		/*
-		 * Set sg_entry_cnt to the number of SG elements
-		 * that will be completed on this interrupt.
-		 *
-		 * Note: The allocated SG queues contain ASC_MAX_SG_LIST - 1
-		 * SG elements. The data_cnt and data_addr fields which
-		 * add 1 to the SG element capacity are not used when
-		 * restarting SG handling after a halt.
-		 */
-		if (scsiq->remain_sg_entry_cnt > (ASC_MAX_SG_LIST - 1)) {
-			sg_entry_cnt = ASC_MAX_SG_LIST - 1;
-
-			/*
-			 * Keep track of remaining number of SG elements that
-			 * will need to be handled on the next interrupt.
-			 */
-			scsiq->remain_sg_entry_cnt -= (ASC_MAX_SG_LIST - 1);
-		} else {
-			sg_entry_cnt = scsiq->remain_sg_entry_cnt;
-			scsiq->remain_sg_entry_cnt = 0;
-		}
-
-		/*
-		 * Copy SG elements into the list of allocated SG queues.
-		 *
-		 * Last index completed is saved in scsiq->next_sg_index.
-		 */
-		next_qp = first_sg_wk_q_no;
-		q_addr = ASC_QNO_TO_QADDR(next_qp);
-		scsi_sg_q.sg_head_qp = q_no;
-		scsi_sg_q.cntl = QCSG_SG_XFER_LIST;
-		for (i = 0; i < sg_head->queue_cnt; i++) {
-			scsi_sg_q.seq_no = i + 1;
-			if (sg_entry_cnt > ASC_SG_LIST_PER_Q) {
-				sg_list_dwords = (uchar)(ASC_SG_LIST_PER_Q * 2);
-				sg_entry_cnt -= ASC_SG_LIST_PER_Q;
-				/*
-				 * After very first SG queue RISC FW uses next
-				 * SG queue first element then checks sg_list_cnt
-				 * against zero and then decrements, so set
-				 * sg_list_cnt 1 less than number of SG elements
-				 * in each SG queue.
-				 */
-				scsi_sg_q.sg_list_cnt = ASC_SG_LIST_PER_Q - 1;
-				scsi_sg_q.sg_cur_list_cnt =
-				    ASC_SG_LIST_PER_Q - 1;
-			} else {
-				/*
-				 * This is the last SG queue in the list of
-				 * allocated SG queues. If there are more
-				 * SG elements than will fit in the allocated
-				 * queues, then set the QCSG_SG_XFER_MORE flag.
-				 */
-				if (scsiq->remain_sg_entry_cnt != 0) {
-					scsi_sg_q.cntl |= QCSG_SG_XFER_MORE;
-				} else {
-					scsi_sg_q.cntl |= QCSG_SG_XFER_END;
-				}
-				/* equals sg_entry_cnt * 2 */
-				sg_list_dwords = sg_entry_cnt << 1;
-				scsi_sg_q.sg_list_cnt = sg_entry_cnt - 1;
-				scsi_sg_q.sg_cur_list_cnt = sg_entry_cnt - 1;
-				sg_entry_cnt = 0;
-			}
-
-			scsi_sg_q.q_no = next_qp;
-			AscMemWordCopyPtrToLram(iop_base,
-						q_addr + ASC_SCSIQ_SGHD_CPY_BEG,
-						(uchar *)&scsi_sg_q,
-						sizeof(ASC_SG_LIST_Q) >> 1);
-
-			AscMemDWordCopyPtrToLram(iop_base,
-						 q_addr + ASC_SGQ_LIST_BEG,
-						 (uchar *)&sg_head->
-						 sg_list[scsiq->next_sg_index],
-						 sg_list_dwords);
-
-			scsiq->next_sg_index += ASC_SG_LIST_PER_Q;
-
-			/*
-			 * If the just completed SG queue contained the
-			 * last SG element, then no more SG queues need
-			 * to be written.
-			 */
-			if (scsi_sg_q.cntl & QCSG_SG_XFER_END) {
-				break;
-			}
-
-			next_qp = AscReadLramByte(iop_base,
-						  (ushort)(q_addr +
-							   ASC_SCSIQ_B_FWD));
-			q_addr = ASC_QNO_TO_QADDR(next_qp);
-		}
-
-		/*
-		 * Clear the halt condition so the RISC will be restarted
-		 * after the return.
-		 */
-		AscWriteLramWord(iop_base, ASCV_HALTCODE_W, 0);
-		return;
-	}
-#endif /* CC_VERY_LONG_SG_LIST */
 	return;
 }
 
@@ -8221,40 +8041,13 @@ AscPutReadySgListQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq, uchar q_no)
 	saved_data_cnt = scsiq->q1.data_cnt;
 	scsiq->q1.data_addr = cpu_to_le32(sg_head->sg_list[0].addr);
 	scsiq->q1.data_cnt = cpu_to_le32(sg_head->sg_list[0].bytes);
-#if CC_VERY_LONG_SG_LIST
 	/*
-	 * If sg_head->entry_cnt is greater than ASC_MAX_SG_LIST
-	 * then not all SG elements will fit in the allocated queues.
-	 * The rest of the SG elements will be copied when the RISC
-	 * completes the SG elements that fit and halts.
+	 * Set sg_entry_cnt to be the number of SG elements that
+	 * will fit in the allocated SG queues. It is minus 1, because
+	 * the first SG element is handled above.
 	 */
-	if (sg_head->entry_cnt > ASC_MAX_SG_LIST) {
-		/*
-		 * Set sg_entry_cnt to be the number of SG elements that
-		 * will fit in the allocated SG queues. It is minus 1, because
-		 * the first SG element is handled above. ASC_MAX_SG_LIST is
-		 * already inflated by 1 to account for this. For example it
-		 * may be 50 which is 1 + 7 queues * 7 SG elements.
-		 */
-		sg_entry_cnt = ASC_MAX_SG_LIST - 1;
+	sg_entry_cnt = sg_head->entry_cnt - 1;
 
-		/*
-		 * Keep track of remaining number of SG elements that will
-		 * need to be handled from a_isr.c.
-		 */
-		scsiq->remain_sg_entry_cnt =
-		    sg_head->entry_cnt - ASC_MAX_SG_LIST;
-	} else {
-#endif /* CC_VERY_LONG_SG_LIST */
-		/*
-		 * Set sg_entry_cnt to be the number of SG elements that
-		 * will fit in the allocated SG queues. It is minus 1, because
-		 * the first SG element is handled above.
-		 */
-		sg_entry_cnt = sg_head->entry_cnt - 1;
-#if CC_VERY_LONG_SG_LIST
-	}
-#endif /* CC_VERY_LONG_SG_LIST */
 	if (sg_entry_cnt != 0) {
 		scsiq->q1.cntl |= QC_SG_HEAD;
 		q_addr = ASC_QNO_TO_QADDR(q_no);
@@ -8279,21 +8072,7 @@ AscPutReadySgListQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq, uchar q_no)
 					    ASC_SG_LIST_PER_Q - 1;
 				}
 			} else {
-#if CC_VERY_LONG_SG_LIST
-				/*
-				 * This is the last SG queue in the list of
-				 * allocated SG queues. If there are more
-				 * SG elements than will fit in the allocated
-				 * queues, then set the QCSG_SG_XFER_MORE flag.
-				 */
-				if (sg_head->entry_cnt > ASC_MAX_SG_LIST) {
-					scsi_sg_q.cntl |= QCSG_SG_XFER_MORE;
-				} else {
-#endif /* CC_VERY_LONG_SG_LIST */
-					scsi_sg_q.cntl |= QCSG_SG_XFER_END;
-#if CC_VERY_LONG_SG_LIST
-				}
-#endif /* CC_VERY_LONG_SG_LIST */
+				scsi_sg_q.cntl |= QCSG_SG_XFER_END;
 				sg_list_dwords = sg_entry_cnt << 1;
 				if (i == 0) {
 					scsi_sg_q.sg_list_cnt = sg_entry_cnt;
@@ -8449,12 +8228,10 @@ static int AscExeScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq)
 			asc_dvc->in_critical_cnt--;
 			return ASC_ERROR;
 		}
-#if !CC_VERY_LONG_SG_LIST
 		if (sg_entry_cnt > ASC_MAX_SG_LIST) {
 			asc_dvc->in_critical_cnt--;
 			return ASC_ERROR;
 		}
-#endif /* !CC_VERY_LONG_SG_LIST */
 		if (sg_entry_cnt == 1) {
 			scsiq->q1.data_addr = cpu_to_le32(sg_head->sg_list[0].addr);
 			scsiq->q1.data_cnt = cpu_to_le32(sg_head->sg_list[0].bytes);
@@ -8543,16 +8320,6 @@ static int AscExeScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq)
 			}
 		}
 		sg_head->entry_to_copy = sg_head->entry_cnt;
-#if CC_VERY_LONG_SG_LIST
-		/*
-		 * Set the sg_entry_cnt to the maximum possible. The rest of
-		 * the SG elements will be copied when the RISC completes the
-		 * SG elements that fit and halts.
-		 */
-		if (sg_entry_cnt > ASC_MAX_SG_LIST) {
-			sg_entry_cnt = ASC_MAX_SG_LIST;
-		}
-#endif /* CC_VERY_LONG_SG_LIST */
 		n_q_required = AscSgListToQueue(sg_entry_cnt);
 		if ((AscGetNumOfFreeQueue(asc_dvc, target_ix, n_q_required) >=
 		     (uint) n_q_required)
-- 
1.8.5.2

