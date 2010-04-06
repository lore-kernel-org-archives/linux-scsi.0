From: James Smart <james.smart@emulex.com>
Subject: [PATCH 1/7] lpfc 8.3.12: Emulex SLI enhancements
Date: Tue, 6 Apr 2010 14:48:51 -0400
Message-ID: <1270579763.19178.21.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:15622 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757428Ab0DFSuD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2010 14:50:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


- Add the new Logical Link speed event support.
- Add RATOV and EDTOV to the REG_VFI mailbox command.

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hw.h   |    1 
 lpfc_hw4.h  |   53 ++++++++++++++++++++++++++-
 lpfc_init.c |   30 +++++++++++++++
 lpfc_mbox.c |    2 +
 lpfc_sli.c  |  116 +++++++++++++++++++++++++++++++++++++++++++++++++++---------
 lpfc_sli.h  |    1 
 lpfc_sli4.h |    4 +-
 7 files changed, 187 insertions(+), 20 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2010-04-06 12:46:53.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2010-04-06 12:56:53.000000000 -0400
@@ -787,6 +787,7 @@ struct mbox_header {
 #define LPFC_MBOX_OPCODE_EQ_DESTROY		0x37
 #define LPFC_MBOX_OPCODE_QUERY_FW_CFG		0x3A
 #define LPFC_MBOX_OPCODE_FUNCTION_RESET		0x3D
+#define LPFC_MBOX_OPCODE_MQ_CREATE_EXT		0x5A
 
 /* FCoE Opcodes */
 #define LPFC_MBOX_OPCODE_FCOE_WQ_CREATE			0x01
@@ -1108,6 +1109,39 @@ struct lpfc_mbx_mq_create {
 	} u;
 };
 
+struct lpfc_mbx_mq_create_ext {
+	struct mbox_header header;
+	union {
+		struct {
+			uint32_t word0;
+#define lpfc_mbx_mq_create_ext_num_pages_SHIFT		0
+#define lpfc_mbx_mq_create_ext_num_pages_MASK		0x0000FFFF
+#define lpfc_mbx_mq_create_ext_num_pages_WORD		word0
+			uint32_t async_evt_bmap;
+#define lpfc_mbx_mq_create_ext_async_evt_link_SHIFT	LPFC_TRAILER_CODE_LINK
+#define lpfc_mbx_mq_create_ext_async_evt_link_MASK	0x00000001
+#define lpfc_mbx_mq_create_ext_async_evt_link_WORD	async_evt_bmap
+#define lpfc_mbx_mq_create_ext_async_evt_fcfste_SHIFT	LPFC_TRAILER_CODE_FCOE
+#define lpfc_mbx_mq_create_ext_async_evt_fcfste_MASK	0x00000001
+#define lpfc_mbx_mq_create_ext_async_evt_fcfste_WORD	async_evt_bmap
+#define lpfc_mbx_mq_create_ext_async_evt_group5_SHIFT	LPFC_TRAILER_CODE_GRP5
+#define lpfc_mbx_mq_create_ext_async_evt_group5_MASK	0x00000001
+#define lpfc_mbx_mq_create_ext_async_evt_group5_WORD	async_evt_bmap
+			struct mq_context context;
+			struct dma_address page[LPFC_MAX_MQ_PAGE];
+		} request;
+		struct {
+			uint32_t word0;
+#define lpfc_mbx_mq_create_q_id_SHIFT	0
+#define lpfc_mbx_mq_create_q_id_MASK	0x0000FFFF
+#define lpfc_mbx_mq_create_q_id_WORD	word0
+		} response;
+	} u;
+#define LPFC_ASYNC_EVENT_LINK_STATE	0x2
+#define LPFC_ASYNC_EVENT_FCF_STATE	0x4
+#define LPFC_ASYNC_EVENT_GROUP5		0x20
+};
+
 struct lpfc_mbx_mq_destroy {
 	struct mbox_header header;
 	union {
@@ -1434,8 +1468,8 @@ struct lpfc_mbx_reg_vfi {
 #define lpfc_reg_vfi_fcfi_WORD		word2
 	uint32_t wwn[2];
 	struct ulp_bde64 bde;
-	uint32_t word8_rsvd;
-	uint32_t word9_rsvd;
+	uint32_t e_d_tov;
+	uint32_t r_a_tov;
 	uint32_t word10;
 #define lpfc_reg_vfi_nport_id_SHIFT		0
 #define lpfc_reg_vfi_nport_id_MASK		0x00FFFFFF
@@ -2048,6 +2082,7 @@ struct lpfc_mqe {
 		struct lpfc_mbx_reg_fcfi reg_fcfi;
 		struct lpfc_mbx_unreg_fcfi unreg_fcfi;
 		struct lpfc_mbx_mq_create mq_create;
+		struct lpfc_mbx_mq_create_ext mq_create_ext;
 		struct lpfc_mbx_eq_create eq_create;
 		struct lpfc_mbx_cq_create cq_create;
 		struct lpfc_mbx_wq_create wq_create;
@@ -2106,6 +2141,7 @@ struct lpfc_mcqe {
 #define LPFC_TRAILER_CODE_LINK	0x1
 #define LPFC_TRAILER_CODE_FCOE	0x2
 #define LPFC_TRAILER_CODE_DCBX	0x3
+#define LPFC_TRAILER_CODE_GRP5	0x5
 };
 
 struct lpfc_acqe_link {
@@ -2175,6 +2211,19 @@ struct lpfc_acqe_dcbx {
 	uint32_t trailer;
 };
 
+struct lpfc_acqe_grp5 {
+	uint32_t word0;
+#define lpfc_acqe_grp5_pport_SHIFT	0
+#define lpfc_acqe_grp5_pport_MASK	0x000000FF
+#define lpfc_acqe_grp5_pport_WORD	word0
+	uint32_t word1;
+#define lpfc_acqe_grp5_llink_spd_SHIFT	16
+#define lpfc_acqe_grp5_llink_spd_MASK	0x0000FFFF
+#define lpfc_acqe_grp5_llink_spd_WORD	word1
+	uint32_t event_tag;
+	uint32_t trailer;
+};
+
 /*
  * Define the bootstrap mailbox (bmbx) region used to communicate
  * mailbox command between the host and port. The mailbox consists
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2010-04-06 12:46:53.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2010-04-06 12:56:53.000000000 -0400
@@ -1500,6 +1500,7 @@ typedef struct {		/* FireFly BIU registe
 #define MBXERR_BAD_RCV_LENGTH       14
 #define MBXERR_DMA_ERROR            15
 #define MBXERR_ERROR                16
+#define MBXERR_UNKNOWN_CMD          18
 #define MBXERR_LINK_DOWN            0x33
 #define MBX_NOT_FINISHED           255
 
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-04-06 12:46:53.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-04-06 12:56:53.000000000 -0400
@@ -3525,6 +3525,32 @@ lpfc_sli4_async_dcbx_evt(struct lpfc_hba
 }
 
 /**
+ * lpfc_sli4_async_grp5_evt - Process the asynchronous group5 event
+ * @phba: pointer to lpfc hba data structure.
+ * @acqe_link: pointer to the async grp5 completion queue entry.
+ *
+ * This routine is to handle the SLI4 asynchronous grp5 event. A grp5 event
+ * is an asynchronous notified of a logical link speed change.  The Port
+ * reports the logical link speed in units of 10Mbps.
+ **/
+static void
+lpfc_sli4_async_grp5_evt(struct lpfc_hba *phba,
+			 struct lpfc_acqe_grp5 *acqe_grp5)
+{
+	uint16_t prev_ll_spd;
+
+	phba->fc_eventTag = acqe_grp5->event_tag;
+	phba->fcoe_eventtag = acqe_grp5->event_tag;
+	prev_ll_spd = phba->sli4_hba.link_state.logical_speed;
+	phba->sli4_hba.link_state.logical_speed =
+		(bf_get(lpfc_acqe_grp5_llink_spd, acqe_grp5));
+	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+			"2789 GRP5 Async Event: Updating logical link speed "
+			"from %dMbps to %dMbps\n", (prev_ll_spd * 10),
+			(phba->sli4_hba.link_state.logical_speed*10));
+}
+
+/**
  * lpfc_sli4_async_event_proc - Process all the pending asynchronous event
  * @phba: pointer to lpfc hba data structure.
  *
@@ -3560,6 +3586,10 @@ void lpfc_sli4_async_event_proc(struct l
 			lpfc_sli4_async_dcbx_evt(phba,
 						 &cq_event->cqe.acqe_dcbx);
 			break;
+		case LPFC_TRAILER_CODE_GRP5:
+			lpfc_sli4_async_grp5_evt(phba,
+						 &cq_event->cqe.acqe_grp5);
+			break;
 		default:
 			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 					"1804 Invalid asynchrous event code: "
diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2010-04-06 12:46:53.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2010-04-06 12:56:53.000000000 -0400
@@ -1898,6 +1898,8 @@ lpfc_reg_vfi(struct lpfcMboxq *mbox, str
 	memcpy(reg_vfi->wwn, &vport->fc_portname, sizeof(struct lpfc_name));
 	reg_vfi->wwn[0] = cpu_to_le32(reg_vfi->wwn[0]);
 	reg_vfi->wwn[1] = cpu_to_le32(reg_vfi->wwn[1]);
+	reg_vfi->e_d_tov = vport->phba->fc_edtov;
+	reg_vfi->r_a_tov = vport->phba->fc_ratov;
 	reg_vfi->bde.addrHigh = putPaddrHigh(phys);
 	reg_vfi->bde.addrLow = putPaddrLow(phys);
 	reg_vfi->bde.tus.f.bdeSize = sizeof(vport->fc_sparam);
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2010-04-06 12:46:53.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2010-04-06 12:56:53.000000000 -0400
@@ -493,8 +493,8 @@ void lpfc_sli4_queue_free(struct lpfc_qu
 uint32_t lpfc_eq_create(struct lpfc_hba *, struct lpfc_queue *, uint16_t);
 uint32_t lpfc_cq_create(struct lpfc_hba *, struct lpfc_queue *,
 			struct lpfc_queue *, uint32_t, uint32_t);
-uint32_t lpfc_mq_create(struct lpfc_hba *, struct lpfc_queue *,
-			struct lpfc_queue *, uint32_t);
+int32_t lpfc_mq_create(struct lpfc_hba *, struct lpfc_queue *,
+		       struct lpfc_queue *, uint32_t);
 uint32_t lpfc_wq_create(struct lpfc_hba *, struct lpfc_queue *,
 			struct lpfc_queue *, uint32_t);
 uint32_t lpfc_rq_create(struct lpfc_hba *, struct lpfc_queue *,
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2010-04-06 12:46:53.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2010-04-06 12:56:53.000000000 -0400
@@ -9833,9 +9833,70 @@ out:
 }
 
 /**
+ * lpfc_mq_create_fb_init - Send MCC_CREATE without async events registration
+ * @phba: HBA structure that indicates port to create a queue on.
+ * @mq: The queue structure to use to create the mailbox queue.
+ * @mbox: An allocated pointer to type LPFC_MBOXQ_t
+ * @cq: The completion queue to associate with this cq.
+ *
+ * This function provides failback (fb) functionality when the
+ * mq_create_ext fails on older FW generations.  It's purpose is identical
+ * to mq_create_ext otherwise.
+ *
+ * This routine cannot fail as all attributes were previously accessed and
+ * initialized in mq_create_ext.
+ **/
+static void
+lpfc_mq_create_fb_init(struct lpfc_hba *phba, struct lpfc_queue *mq,
+		       LPFC_MBOXQ_t *mbox, struct lpfc_queue *cq)
+{
+	struct lpfc_mbx_mq_create *mq_create;
+	struct lpfc_dmabuf *dmabuf;
+	int length;
+
+	length = (sizeof(struct lpfc_mbx_mq_create) -
+		  sizeof(struct lpfc_sli4_cfg_mhdr));
+	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_COMMON,
+			 LPFC_MBOX_OPCODE_MQ_CREATE,
+			 length, LPFC_SLI4_MBX_EMBED);
+	mq_create = &mbox->u.mqe.un.mq_create;
+	bf_set(lpfc_mbx_mq_create_num_pages, &mq_create->u.request,
+	       mq->page_count);
+	bf_set(lpfc_mq_context_cq_id, &mq_create->u.request.context,
+	       cq->queue_id);
+	bf_set(lpfc_mq_context_valid, &mq_create->u.request.context, 1);
+	switch (mq->entry_count) {
+	case 16:
+		bf_set(lpfc_mq_context_count, &mq_create->u.request.context,
+		       LPFC_MQ_CNT_16);
+		break;
+	case 32:
+		bf_set(lpfc_mq_context_count, &mq_create->u.request.context,
+		       LPFC_MQ_CNT_32);
+		break;
+	case 64:
+		bf_set(lpfc_mq_context_count, &mq_create->u.request.context,
+		       LPFC_MQ_CNT_64);
+		break;
+	case 128:
+		bf_set(lpfc_mq_context_count, &mq_create->u.request.context,
+		       LPFC_MQ_CNT_128);
+		break;
+	}
+	list_for_each_entry(dmabuf, &mq->page_list, list) {
+		mq_create->u.request.page[dmabuf->buffer_tag].addr_lo =
+			putPaddrLow(dmabuf->phys);
+		mq_create->u.request.page[dmabuf->buffer_tag].addr_hi =
+			putPaddrHigh(dmabuf->phys);
+	}
+}
+
+/**
  * lpfc_mq_create - Create a mailbox Queue on the HBA
  * @phba: HBA structure that indicates port to create a queue on.
  * @mq: The queue structure to use to create the mailbox queue.
+ * @cq: The completion queue to associate with this cq.
+ * @subtype: The queue's subtype.
  *
  * This function creates a mailbox queue, as detailed in @mq, on a port,
  * described by @phba by sending a MQ_CREATE mailbox command to the HBA.
@@ -9851,31 +9912,40 @@ out:
  * memory this function will return ENOMEM. If the queue create mailbox command
  * fails this function will return ENXIO.
  **/
-uint32_t
+int32_t
 lpfc_mq_create(struct lpfc_hba *phba, struct lpfc_queue *mq,
 	       struct lpfc_queue *cq, uint32_t subtype)
 {
 	struct lpfc_mbx_mq_create *mq_create;
+	struct lpfc_mbx_mq_create_ext *mq_create_ext;
 	struct lpfc_dmabuf *dmabuf;
 	LPFC_MBOXQ_t *mbox;
 	int rc, length, status = 0;
 	uint32_t shdr_status, shdr_add_status;
 	union lpfc_sli4_cfg_shdr *shdr;
 
+
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mbox)
 		return -ENOMEM;
-	length = (sizeof(struct lpfc_mbx_mq_create) -
+	length = (sizeof(struct lpfc_mbx_mq_create_ext) -
 		  sizeof(struct lpfc_sli4_cfg_mhdr));
 	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_COMMON,
-			 LPFC_MBOX_OPCODE_MQ_CREATE,
+			 LPFC_MBOX_OPCODE_MQ_CREATE_EXT,
 			 length, LPFC_SLI4_MBX_EMBED);
-	mq_create = &mbox->u.mqe.un.mq_create;
-	bf_set(lpfc_mbx_mq_create_num_pages, &mq_create->u.request,
+
+	mq_create_ext = &mbox->u.mqe.un.mq_create_ext;
+	bf_set(lpfc_mbx_mq_create_ext_num_pages, &mq_create_ext->u.request,
 		    mq->page_count);
-	bf_set(lpfc_mq_context_cq_id, &mq_create->u.request.context,
-		    cq->queue_id);
-	bf_set(lpfc_mq_context_valid, &mq_create->u.request.context, 1);
+	bf_set(lpfc_mbx_mq_create_ext_async_evt_link, &mq_create_ext->u.request,
+	       1);
+	bf_set(lpfc_mbx_mq_create_ext_async_evt_fcfste,
+	       &mq_create_ext->u.request, 1);
+	bf_set(lpfc_mbx_mq_create_ext_async_evt_group5,
+	       &mq_create_ext->u.request, 1);
+	bf_set(lpfc_mq_context_cq_id, &mq_create_ext->u.request.context,
+	       cq->queue_id);
+	bf_set(lpfc_mq_context_valid, &mq_create_ext->u.request.context, 1);
 	switch (mq->entry_count) {
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
@@ -9885,31 +9955,46 @@ lpfc_mq_create(struct lpfc_hba *phba, st
 			return -EINVAL;
 		/* otherwise default to smallest count (drop through) */
 	case 16:
-		bf_set(lpfc_mq_context_count, &mq_create->u.request.context,
+		bf_set(lpfc_mq_context_count, &mq_create_ext->u.request.context,
 		       LPFC_MQ_CNT_16);
 		break;
 	case 32:
-		bf_set(lpfc_mq_context_count, &mq_create->u.request.context,
+		bf_set(lpfc_mq_context_count, &mq_create_ext->u.request.context,
 		       LPFC_MQ_CNT_32);
 		break;
 	case 64:
-		bf_set(lpfc_mq_context_count, &mq_create->u.request.context,
+		bf_set(lpfc_mq_context_count, &mq_create_ext->u.request.context,
 		       LPFC_MQ_CNT_64);
 		break;
 	case 128:
-		bf_set(lpfc_mq_context_count, &mq_create->u.request.context,
+		bf_set(lpfc_mq_context_count, &mq_create_ext->u.request.context,
 		       LPFC_MQ_CNT_128);
 		break;
 	}
 	list_for_each_entry(dmabuf, &mq->page_list, list) {
-		mq_create->u.request.page[dmabuf->buffer_tag].addr_lo =
+		mq_create_ext->u.request.page[dmabuf->buffer_tag].addr_lo =
 					putPaddrLow(dmabuf->phys);
-		mq_create->u.request.page[dmabuf->buffer_tag].addr_hi =
+		mq_create_ext->u.request.page[dmabuf->buffer_tag].addr_hi =
 					putPaddrHigh(dmabuf->phys);
 	}
 	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
+	shdr = (union lpfc_sli4_cfg_shdr *) &mq_create_ext->header.cfg_shdr;
+	mq->queue_id = bf_get(lpfc_mbx_mq_create_q_id,
+			      &mq_create_ext->u.response);
+	if (rc != MBX_SUCCESS) {
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"2795 MQ_CREATE_EXT failed with "
+				"status x%x. Failback to MQ_CREATE.\n",
+				rc);
+		lpfc_mq_create_fb_init(phba, mq, mbox, cq);
+		mq_create = &mbox->u.mqe.un.mq_create;
+		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
+		shdr = (union lpfc_sli4_cfg_shdr *) &mq_create->header.cfg_shdr;
+		mq->queue_id = bf_get(lpfc_mbx_mq_create_q_id,
+				      &mq_create->u.response);
+	}
+
 	/* The IOCTL status is embedded in the mailbox subheader. */
-	shdr = (union lpfc_sli4_cfg_shdr *) &mq_create->header.cfg_shdr;
 	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
 	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
 	if (shdr_status || shdr_add_status || rc) {
@@ -9920,7 +10005,6 @@ lpfc_mq_create(struct lpfc_hba *phba, st
 		status = -ENXIO;
 		goto out;
 	}
-	mq->queue_id = bf_get(lpfc_mbx_mq_create_q_id, &mq_create->u.response);
 	if (mq->queue_id == 0xFFFF) {
 		status = -ENXIO;
 		goto out;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
--- a/drivers/scsi/lpfc/lpfc_sli.h	2010-04-06 12:46:53.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.h	2010-04-06 12:56:53.000000000 -0400
@@ -36,6 +36,7 @@ struct lpfc_cq_event {
 		struct lpfc_acqe_link		acqe_link;
 		struct lpfc_acqe_fcoe		acqe_fcoe;
 		struct lpfc_acqe_dcbx		acqe_dcbx;
+		struct lpfc_acqe_grp5		acqe_grp5;
 		struct lpfc_rcqe		rcqe_cmpl;
 		struct sli4_wcqe_xri_aborted	wcqe_axri;
 		struct lpfc_wcqe_complete	wcqe_cmpl;


