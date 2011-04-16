From: James Smart <james.smart@emulex.com>
Subject: [PATCH 4/5] lpfc 8.3.23: BSG additions and fixes
Date: Sat, 16 Apr 2011 11:03:43 -0400
Message-ID: <1302966237.6245.29.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:15979 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755798Ab1DPPE3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Apr 2011 11:04:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

BSG additions and fixes

- Fixed the mixed declarations and codes which violate ISO C90
   (declarations in subsections that assign at declaration)
- Add BSG data transfer size protection in mailbox command pass-through path
- Invoke BSG job_done while holding spinlock to fix deadlock
- Added support for checking SLI_CONFIG subcommands
- Fixed bug in BSG mailbox size check to non-embedded external buffer


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_bsg.c |   59 +++++++++++++++------------
 lpfc_bsg.h |  130 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 164 insertions(+), 25 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2011-04-16 08:29:50.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2011-04-16 09:38:41.000000000 -0400
@@ -2426,6 +2426,7 @@ lpfc_bsg_wake_mbox_wait(struct lpfc_hba 
 {
 	struct bsg_job_data *dd_data;
 	struct fc_bsg_job *job;
+	struct lpfc_mbx_nembed_cmd *nembed_sge;
 	uint32_t size;
 	unsigned long flags;
 	uint8_t *to;
@@ -2469,9 +2470,8 @@ lpfc_bsg_wake_mbox_wait(struct lpfc_hba 
 			memcpy(to, from, size);
 		} else if ((phba->sli_rev == LPFC_SLI_REV4) &&
 			(pmboxq->u.mb.mbxCommand == MBX_SLI4_CONFIG)) {
-			struct lpfc_mbx_nembed_cmd *nembed_sge =
-				(struct lpfc_mbx_nembed_cmd *)
-				&pmboxq->u.mb.un.varWords[0];
+			nembed_sge = (struct lpfc_mbx_nembed_cmd *)
+					&pmboxq->u.mb.un.varWords[0];
 
 			from = (uint8_t *)dd_data->context_un.mbox.dmp->dma.
 						virt;
@@ -2496,16 +2496,18 @@ lpfc_bsg_wake_mbox_wait(struct lpfc_hba 
 					job->reply_payload.sg_cnt,
 					from, size);
 		job->reply->result = 0;
-
+		/* need to hold the lock until we set job->dd_data to NULL
+		 * to hold off the timeout handler returning to the mid-layer
+		 * while we are still processing the job.
+		 */
 		job->dd_data = NULL;
+		dd_data->context_un.mbox.set_job = NULL;
+		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 		job->job_done(job);
+	} else {
+		dd_data->context_un.mbox.set_job = NULL;
+		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 	}
-	dd_data->context_un.mbox.set_job = NULL;
-	/* need to hold the lock until we call job done to hold off
-	 * the timeout handler returning to the midlayer while
-	 * we are stillprocessing the job
-	 */
-	spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 
 	kfree(dd_data->context_un.mbox.mb);
 	mempool_free(dd_data->context_un.mbox.pmboxq, phba->mbox_mem_pool);
@@ -2644,6 +2646,11 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phb
 	struct ulp_bde64 *rxbpl = NULL;
 	struct dfc_mbox_req *mbox_req = (struct dfc_mbox_req *)
 		job->request->rqst_data.h_vendor.vendor_cmd;
+	struct READ_EVENT_LOG_VAR *rdEventLog;
+	uint32_t transmit_length, receive_length, mode;
+	struct lpfc_mbx_nembed_cmd *nembed_sge;
+	struct mbox_header *header;
+	struct ulp_bde64 *bde;
 	uint8_t *ext = NULL;
 	int rc = 0;
 	uint8_t *from;
@@ -2651,9 +2658,16 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phb
 	/* in case no data is transferred */
 	job->reply->reply_payload_rcv_len = 0;
 
+	/* sanity check to protect driver */
+	if (job->reply_payload.payload_len > BSG_MBOX_SIZE ||
+	    job->request_payload.payload_len > BSG_MBOX_SIZE) {
+		rc = -ERANGE;
+		goto job_done;
+	}
+
 	/* check if requested extended data lengths are valid */
-	if ((mbox_req->inExtWLen > MAILBOX_EXT_SIZE) ||
-		(mbox_req->outExtWLen > MAILBOX_EXT_SIZE)) {
+	if ((mbox_req->inExtWLen > BSG_MBOX_SIZE/sizeof(uint32_t)) ||
+	    (mbox_req->outExtWLen > BSG_MBOX_SIZE/sizeof(uint32_t))) {
 		rc = -ERANGE;
 		goto job_done;
 	}
@@ -2744,8 +2758,8 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phb
 	 * use ours
 	 */
 	if (pmb->mbxCommand == MBX_RUN_BIU_DIAG64) {
-		uint32_t transmit_length = pmb->un.varWords[1];
-		uint32_t receive_length = pmb->un.varWords[4];
+		transmit_length = pmb->un.varWords[1];
+		receive_length = pmb->un.varWords[4];
 		/* transmit length cannot be greater than receive length or
 		 * mailbox extension size
 		 */
@@ -2795,10 +2809,9 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phb
 		from += sizeof(MAILBOX_t);
 		memcpy((uint8_t *)dmp->dma.virt, from, transmit_length);
 	} else if (pmb->mbxCommand == MBX_READ_EVENT_LOG) {
-		struct READ_EVENT_LOG_VAR *rdEventLog =
-			&pmb->un.varRdEventLog ;
-		uint32_t receive_length = rdEventLog->rcv_bde64.tus.f.bdeSize;
-		uint32_t mode =	 bf_get(lpfc_event_log, rdEventLog);
+		rdEventLog = &pmb->un.varRdEventLog;
+		receive_length = rdEventLog->rcv_bde64.tus.f.bdeSize;
+		mode = bf_get(lpfc_event_log, rdEventLog);
 
 		/* receive length cannot be greater than mailbox
 		 * extension size
@@ -2843,7 +2856,7 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phb
 			/* rebuild the command for sli4 using our own buffers
 			* like we do for biu diags
 			*/
-			uint32_t receive_length = pmb->un.varWords[2];
+			receive_length = pmb->un.varWords[2];
 			/* receive length cannot be greater than mailbox
 			 * extension size
 			 */
@@ -2879,8 +2892,7 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phb
 			pmb->un.varWords[4] = putPaddrHigh(dmp->dma.phys);
 		} else if ((pmb->mbxCommand == MBX_UPDATE_CFG) &&
 			pmb->un.varUpdateCfg.co) {
-			struct ulp_bde64 *bde =
-				(struct ulp_bde64 *)&pmb->un.varWords[4];
+			bde = (struct ulp_bde64 *)&pmb->un.varWords[4];
 
 			/* bde size cannot be greater than mailbox ext size */
 			if (bde->tus.f.bdeSize > MAILBOX_EXT_SIZE) {
@@ -2921,10 +2933,6 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phb
 			memcpy((uint8_t *)dmp->dma.virt, from,
 				bde->tus.f.bdeSize);
 		} else if (pmb->mbxCommand == MBX_SLI4_CONFIG) {
-			struct lpfc_mbx_nembed_cmd *nembed_sge;
-			struct mbox_header *header;
-			uint32_t receive_length;
-
 			/* rebuild the command for sli4 using our own buffers
 			* like we do for biu diags
 			*/
@@ -3386,6 +3394,7 @@ no_dd_data:
 	job->dd_data = NULL;
 	return rc;
 }
+
 /**
  * lpfc_bsg_hst_vendor - process a vendor-specific fc_bsg_job
  * @job: fc_bsg_job to handle
diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.h b/drivers/scsi/lpfc/lpfc_bsg.h
--- a/drivers/scsi/lpfc/lpfc_bsg.h	2010-08-04 10:31:45.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_bsg.h	2011-04-16 09:38:41.000000000 -0400
@@ -109,3 +109,133 @@ struct menlo_response {
 	uint32_t xri; /* return the xri of the iocb exchange */
 };
 
+/*
+ * macros and data structures for handling sli-config mailbox command
+ * pass-through support, this header file is shared between user and
+ * kernel spaces, note the set of macros are duplicates from lpfc_hw4.h,
+ * with macro names prefixed with bsg_, as the macros defined in
+ * lpfc_hw4.h are not accessible from user space.
+ */
+
+/* Macros to deal with bit fields. Each bit field must have 3 #defines
+ * associated with it (_SHIFT, _MASK, and _WORD).
+ * EG. For a bit field that is in the 7th bit of the "field4" field of a
+ * structure and is 2 bits in size the following #defines must exist:
+ *      struct temp {
+ *              uint32_t        field1;
+ *              uint32_t        field2;
+ *              uint32_t        field3;
+ *              uint32_t        field4;
+ *      #define example_bit_field_SHIFT         7
+ *      #define example_bit_field_MASK          0x03
+ *      #define example_bit_field_WORD          field4
+ *              uint32_t        field5;
+ *      };
+ * Then the macros below may be used to get or set the value of that field.
+ * EG. To get the value of the bit field from the above example:
+ *      struct temp t1;
+ *      value = bsg_bf_get(example_bit_field, &t1);
+ * And then to set that bit field:
+ *      bsg_bf_set(example_bit_field, &t1, 2);
+ * Or clear that bit field:
+ *      bsg_bf_set(example_bit_field, &t1, 0);
+ */
+#define bsg_bf_get_le32(name, ptr) \
+	((le32_to_cpu((ptr)->name##_WORD) >> name##_SHIFT) & name##_MASK)
+#define bsg_bf_get(name, ptr) \
+	(((ptr)->name##_WORD >> name##_SHIFT) & name##_MASK)
+#define bsg_bf_set_le32(name, ptr, value) \
+	((ptr)->name##_WORD = cpu_to_le32(((((value) & \
+	name##_MASK) << name##_SHIFT) | (le32_to_cpu((ptr)->name##_WORD) & \
+	~(name##_MASK << name##_SHIFT)))))
+#define bsg_bf_set(name, ptr, value) \
+	((ptr)->name##_WORD = ((((value) & name##_MASK) << name##_SHIFT) | \
+	((ptr)->name##_WORD & ~(name##_MASK << name##_SHIFT))))
+
+/*
+ * The sli_config structure specified here is based on the following
+ * restriction:
+ *
+ * -- SLI_CONFIG EMB=0, carrying MSEs, will carry subcommands without
+ *    carrying HBD.
+ * -- SLI_CONFIG EMB=1, not carrying MSE, will carry subcommands with or
+ *    without carrying HBDs.
+ */
+
+struct lpfc_sli_config_mse {
+	uint32_t pa_lo;
+	uint32_t pa_hi;
+	uint32_t buf_len;
+#define lpfc_mbox_sli_config_mse_len_SHIFT	0
+#define lpfc_mbox_sli_config_mse_len_MASK	0xffffff
+#define lpfc_mbox_sli_config_mse_len_WORD	buf_len
+};
+
+struct lpfc_sli_config_subcmd_hbd {
+	uint32_t buf_len;
+#define lpfc_mbox_sli_config_ecmn_hbd_len_SHIFT	0
+#define lpfc_mbox_sli_config_ecmn_hbd_len_MASK	0xffffff
+#define lpfc_mbox_sli_config_ecmn_hbd_len_WORD	buf_len
+	uint32_t pa_lo;
+	uint32_t pa_hi;
+};
+
+struct lpfc_sli_config_hdr {
+	uint32_t word1;
+#define lpfc_mbox_hdr_emb_SHIFT		0
+#define lpfc_mbox_hdr_emb_MASK		0x00000001
+#define lpfc_mbox_hdr_emb_WORD		word1
+#define lpfc_mbox_hdr_mse_cnt_SHIFT	3
+#define lpfc_mbox_hdr_mse_cnt_MASK	0x0000001f
+#define lpfc_mbox_hdr_mse_cnt_WORD	word1
+	uint32_t payload_length;
+	uint32_t tag_lo;
+	uint32_t tag_hi;
+	uint32_t reserved5;
+};
+
+struct lpfc_sli_config_generic {
+	struct lpfc_sli_config_hdr	sli_config_hdr;
+#define LPFC_MBX_SLI_CONFIG_MAX_MSE     19
+	struct lpfc_sli_config_mse	mse[LPFC_MBX_SLI_CONFIG_MAX_MSE];
+};
+
+struct lpfc_sli_config_subcmnd {
+	struct lpfc_sli_config_hdr	sli_config_hdr;
+	uint32_t word6;
+#define lpfc_subcmnd_opcode_SHIFT	0
+#define lpfc_subcmnd_opcode_MASK	0xff
+#define lpfc_subcmnd_opcode_WORD	word6
+#define lpfc_subcmnd_subsys_SHIFT	8
+#define lpfc_subcmnd_subsys_MASK	0xff
+#define lpfc_subcmnd_subsys_WORD	word6
+	uint32_t timeout;
+	uint32_t request_length;
+	uint32_t word9;
+#define lpfc_subcmnd_version_SHIFT	0
+#define lpfc_subcmnd_version_MASK	0xff
+#define lpfc_subcmnd_version_WORD	word9
+	uint32_t word10;
+#define lpfc_subcmnd_ask_rd_len_SHIFT	0
+#define lpfc_subcmnd_ask_rd_len_MASK	0xffffff
+#define lpfc_subcmnd_ask_rd_len_WORD	word10
+	uint32_t rd_offset;
+	uint32_t obj_name[26];
+	uint32_t hbd_count;
+#define LPFC_MBX_SLI_CONFIG_MAX_HBD	10
+	struct lpfc_sli_config_subcmd_hbd   hbd[LPFC_MBX_SLI_CONFIG_MAX_HBD];
+};
+
+struct lpfc_sli_config_mbox {
+	uint32_t word0;
+#define lpfc_mqe_status_SHIFT		16
+#define lpfc_mqe_status_MASK		0x0000FFFF
+#define lpfc_mqe_status_WORD		word0
+#define lpfc_mqe_command_SHIFT		8
+#define lpfc_mqe_command_MASK		0x000000FF
+#define lpfc_mqe_command_WORD		word0
+	union {
+		struct lpfc_sli_config_generic	sli_config_generic;
+		struct lpfc_sli_config_subcmnd	sli_config_subcmnd;
+	} un;
+};


