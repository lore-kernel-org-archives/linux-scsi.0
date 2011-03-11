From: James Smart <james.smart@emulex.com>
Subject: [PATCH 1/6] lpfc 8.3.22: Add new mailbox command and new BSG fix
Date: Fri, 11 Mar 2011 16:05:35 -0500
Message-ID: <1299877550.31589.15.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:23182 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754632Ab1CKVGV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Mar 2011 16:06:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


- Add new Queue Create Mailbox version support
- Make lpfc_bsg_wake_mbox_wait routine check the mailboxes job reference before
  using it.



 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_bsg.c |   18 ++--
 lpfc_hw4.h |  101 ++++++++++++++++++---------
 lpfc_sli.c |  228 +++++++++++++++++++++++++++++++++++++++----------------------
 3 files changed, 229 insertions(+), 118 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2011-02-15 10:03:48.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2011-03-11 12:13:01.000000000 -0500
@@ -2479,16 +2479,18 @@ lpfc_bsg_wake_mbox_wait(struct lpfc_hba 
 
 	from = (uint8_t *)dd_data->context_un.mbox.mb;
 	job = dd_data->context_un.mbox.set_job;
-	size = job->reply_payload.payload_len;
-	job->reply->reply_payload_rcv_len =
-		sg_copy_from_buffer(job->reply_payload.sg_list,
-				job->reply_payload.sg_cnt,
-				from, size);
-	job->reply->result = 0;
+	if (job) {
+		size = job->reply_payload.payload_len;
+		job->reply->reply_payload_rcv_len =
+			sg_copy_from_buffer(job->reply_payload.sg_list,
+					job->reply_payload.sg_cnt,
+					from, size);
+		job->reply->result = 0;
 
+		job->dd_data = NULL;
+		job->job_done(job);
+	}
 	dd_data->context_un.mbox.set_job = NULL;
-	job->dd_data = NULL;
-	job->job_done(job);
 	/* need to hold the lock until we call job done to hold off
 	 * the timeout handler returning to the midlayer while
 	 * we are stillprocessing the job
diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2011-03-09 14:41:22.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2011-03-11 12:13:01.000000000 -0500
@@ -711,21 +711,27 @@ struct lpfc_sli4_cfg_mhdr {
 union lpfc_sli4_cfg_shdr {
 	struct {
 		uint32_t word6;
-#define lpfc_mbox_hdr_opcode_SHIFT		0
-#define lpfc_mbox_hdr_opcode_MASK		0x000000FF
-#define lpfc_mbox_hdr_opcode_WORD		word6
-#define lpfc_mbox_hdr_subsystem_SHIFT		8
-#define lpfc_mbox_hdr_subsystem_MASK		0x000000FF
-#define lpfc_mbox_hdr_subsystem_WORD		word6
-#define lpfc_mbox_hdr_port_number_SHIFT		16
-#define lpfc_mbox_hdr_port_number_MASK		0x000000FF
-#define lpfc_mbox_hdr_port_number_WORD		word6
-#define lpfc_mbox_hdr_domain_SHIFT		24
-#define lpfc_mbox_hdr_domain_MASK		0x000000FF
-#define lpfc_mbox_hdr_domain_WORD		word6
+#define lpfc_mbox_hdr_opcode_SHIFT	0
+#define lpfc_mbox_hdr_opcode_MASK	0x000000FF
+#define lpfc_mbox_hdr_opcode_WORD	word6
+#define lpfc_mbox_hdr_subsystem_SHIFT	8
+#define lpfc_mbox_hdr_subsystem_MASK	0x000000FF
+#define lpfc_mbox_hdr_subsystem_WORD	word6
+#define lpfc_mbox_hdr_port_number_SHIFT	16
+#define lpfc_mbox_hdr_port_number_MASK	0x000000FF
+#define lpfc_mbox_hdr_port_number_WORD	word6
+#define lpfc_mbox_hdr_domain_SHIFT	24
+#define lpfc_mbox_hdr_domain_MASK	0x000000FF
+#define lpfc_mbox_hdr_domain_WORD	word6
 		uint32_t timeout;
 		uint32_t request_length;
-		uint32_t reserved9;
+		uint32_t word9;
+#define lpfc_mbox_hdr_version_SHIFT	0
+#define lpfc_mbox_hdr_version_MASK	0x000000FF
+#define lpfc_mbox_hdr_version_WORD	word9
+#define LPFC_Q_CREATE_VERSION_2	2
+#define LPFC_Q_CREATE_VERSION_1	1
+#define LPFC_Q_CREATE_VERSION_0	0
 	} request;
 	struct {
 		uint32_t word6;
@@ -917,9 +923,12 @@ struct cq_context {
 #define LPFC_CQ_CNT_512		0x1
 #define LPFC_CQ_CNT_1024	0x2
 	uint32_t word1;
-#define lpfc_cq_eq_id_SHIFT		22
+#define lpfc_cq_eq_id_SHIFT		22	/* Version 0 Only */
 #define lpfc_cq_eq_id_MASK		0x000000FF
 #define lpfc_cq_eq_id_WORD		word1
+#define lpfc_cq_eq_id_2_SHIFT		0 	/* Version 2 Only */
+#define lpfc_cq_eq_id_2_MASK		0x0000FFFF
+#define lpfc_cq_eq_id_2_WORD		word1
 	uint32_t reserved0;
 	uint32_t reserved1;
 };
@@ -929,6 +938,9 @@ struct lpfc_mbx_cq_create {
 	union {
 		struct {
 			uint32_t word0;
+#define lpfc_mbx_cq_create_page_size_SHIFT	16	/* Version 2 Only */
+#define lpfc_mbx_cq_create_page_size_MASK	0x000000FF
+#define lpfc_mbx_cq_create_page_size_WORD	word0
 #define lpfc_mbx_cq_create_num_pages_SHIFT	0
 #define lpfc_mbx_cq_create_num_pages_MASK	0x0000FFFF
 #define lpfc_mbx_cq_create_num_pages_WORD	word0
@@ -969,7 +981,7 @@ struct wq_context {
 struct lpfc_mbx_wq_create {
 	struct mbox_header header;
 	union {
-		struct {
+		struct {	/* Version 0 Request */
 			uint32_t word0;
 #define lpfc_mbx_wq_create_num_pages_SHIFT	0
 #define lpfc_mbx_wq_create_num_pages_MASK	0x0000FFFF
@@ -979,6 +991,23 @@ struct lpfc_mbx_wq_create {
 #define lpfc_mbx_wq_create_cq_id_WORD		word0
 			struct dma_address page[LPFC_MAX_WQ_PAGE];
 		} request;
+		struct {	/* Version 1 Request */
+			uint32_t word0;	/* Word 0 is the same as in v0 */
+			uint32_t word1;
+#define lpfc_mbx_wq_create_page_size_SHIFT	0
+#define lpfc_mbx_wq_create_page_size_MASK	0x000000FF
+#define lpfc_mbx_wq_create_page_size_WORD	word1
+#define lpfc_mbx_wq_create_wqe_size_SHIFT	8
+#define lpfc_mbx_wq_create_wqe_size_MASK	0x0000000F
+#define lpfc_mbx_wq_create_wqe_size_WORD	word1
+#define LPFC_WQ_WQE_SIZE_64	0x5
+#define LPFC_WQ_WQE_SIZE_128	0x6
+#define lpfc_mbx_wq_create_wqe_count_SHIFT	16
+#define lpfc_mbx_wq_create_wqe_count_MASK	0x0000FFFF
+#define lpfc_mbx_wq_create_wqe_count_WORD	word1
+			uint32_t word2;
+			struct dma_address page[LPFC_MAX_WQ_PAGE-1];
+		} request_1;
 		struct {
 			uint32_t word0;
 #define lpfc_mbx_wq_create_q_id_SHIFT	0
@@ -1007,13 +1036,22 @@ struct lpfc_mbx_wq_destroy {
 #define LPFC_DATA_BUF_SIZE 2048
 struct rq_context {
 	uint32_t word0;
-#define lpfc_rq_context_rq_size_SHIFT	16
-#define lpfc_rq_context_rq_size_MASK	0x0000000F
-#define lpfc_rq_context_rq_size_WORD	word0
+#define lpfc_rq_context_rqe_count_SHIFT	16	/* Version 0 Only */
+#define lpfc_rq_context_rqe_count_MASK	0x0000000F
+#define lpfc_rq_context_rqe_count_WORD	word0
 #define LPFC_RQ_RING_SIZE_512		9	/* 512 entries */
 #define LPFC_RQ_RING_SIZE_1024		10	/* 1024 entries */
 #define LPFC_RQ_RING_SIZE_2048		11	/* 2048 entries */
 #define LPFC_RQ_RING_SIZE_4096		12	/* 4096 entries */
+#define lpfc_rq_context_rqe_count_1_SHIFT	16	/* Version 1 Only */
+#define lpfc_rq_context_rqe_count_1_MASK	0x0000FFFF
+#define lpfc_rq_context_rqe_count_1_WORD	word0
+#define lpfc_rq_context_rqe_size_SHIFT	8		/* Version 1 Only */
+#define lpfc_rq_context_rqe_size_MASK	0x0000000F
+#define lpfc_rq_context_rqe_size_WORD	word0
+#define lpfc_rq_context_page_size_SHIFT	0		/* Version 1 Only */
+#define lpfc_rq_context_page_size_MASK	0x000000FF
+#define lpfc_rq_context_page_size_WORD	word0
 	uint32_t reserved1;
 	uint32_t word2;
 #define lpfc_rq_context_cq_id_SHIFT	16
@@ -1022,7 +1060,7 @@ struct rq_context {
 #define lpfc_rq_context_buf_size_SHIFT	0
 #define lpfc_rq_context_buf_size_MASK	0x0000FFFF
 #define lpfc_rq_context_buf_size_WORD	word2
-	uint32_t reserved3;
+	uint32_t buffer_size;				/* Version 1 Only */
 };
 
 struct lpfc_mbx_rq_create {
@@ -1062,16 +1100,16 @@ struct lpfc_mbx_rq_destroy {
 
 struct mq_context {
 	uint32_t word0;
-#define lpfc_mq_context_cq_id_SHIFT	22
+#define lpfc_mq_context_cq_id_SHIFT	22 	/* Version 0 Only */
 #define lpfc_mq_context_cq_id_MASK	0x000003FF
 #define lpfc_mq_context_cq_id_WORD	word0
-#define lpfc_mq_context_count_SHIFT	16
-#define lpfc_mq_context_count_MASK	0x0000000F
-#define lpfc_mq_context_count_WORD	word0
-#define LPFC_MQ_CNT_16		0x5
-#define LPFC_MQ_CNT_32		0x6
-#define LPFC_MQ_CNT_64		0x7
-#define LPFC_MQ_CNT_128		0x8
+#define lpfc_mq_context_ring_size_SHIFT	16
+#define lpfc_mq_context_ring_size_MASK	0x0000000F
+#define lpfc_mq_context_ring_size_WORD	word0
+#define LPFC_MQ_RING_SIZE_16		0x5
+#define LPFC_MQ_RING_SIZE_32		0x6
+#define LPFC_MQ_RING_SIZE_64		0x7
+#define LPFC_MQ_RING_SIZE_128		0x8
 	uint32_t word1;
 #define lpfc_mq_context_valid_SHIFT	31
 #define lpfc_mq_context_valid_MASK	0x00000001
@@ -1105,9 +1143,12 @@ struct lpfc_mbx_mq_create_ext {
 	union {
 		struct {
 			uint32_t word0;
-#define lpfc_mbx_mq_create_ext_num_pages_SHIFT		0
-#define lpfc_mbx_mq_create_ext_num_pages_MASK		0x0000FFFF
-#define lpfc_mbx_mq_create_ext_num_pages_WORD		word0
+#define lpfc_mbx_mq_create_ext_num_pages_SHIFT	0
+#define lpfc_mbx_mq_create_ext_num_pages_MASK	0x0000FFFF
+#define lpfc_mbx_mq_create_ext_num_pages_WORD	word0
+#define lpfc_mbx_mq_create_ext_cq_id_SHIFT	16	/* Version 1 Only */
+#define lpfc_mbx_mq_create_ext_cq_id_MASK	0x0000FFFF
+#define lpfc_mbx_mq_create_ext_cq_id_WORD	word0
 			uint32_t async_evt_bmap;
 #define lpfc_mbx_mq_create_ext_async_evt_link_SHIFT	LPFC_TRAILER_CODE_LINK
 #define lpfc_mbx_mq_create_ext_async_evt_link_MASK	0x00000001
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2011-03-09 14:41:22.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2011-03-11 12:13:01.000000000 -0500
@@ -10403,7 +10403,6 @@ lpfc_cq_create(struct lpfc_hba *phba, st
 	if (!phba->sli4_hba.pc_sli4_params.supported)
 		hw_page_size = SLI4_PAGE_SIZE;
 
-
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mbox)
 		return -ENOMEM;
@@ -10413,11 +10412,22 @@ lpfc_cq_create(struct lpfc_hba *phba, st
 			 LPFC_MBOX_OPCODE_CQ_CREATE,
 			 length, LPFC_SLI4_MBX_EMBED);
 	cq_create = &mbox->u.mqe.un.cq_create;
+	shdr = (union lpfc_sli4_cfg_shdr *) &cq_create->header.cfg_shdr;
 	bf_set(lpfc_mbx_cq_create_num_pages, &cq_create->u.request,
 		    cq->page_count);
 	bf_set(lpfc_cq_context_event, &cq_create->u.request.context, 1);
 	bf_set(lpfc_cq_context_valid, &cq_create->u.request.context, 1);
-	bf_set(lpfc_cq_eq_id, &cq_create->u.request.context, eq->queue_id);
+	bf_set(lpfc_mbox_hdr_version, &shdr->request,
+	       phba->sli4_hba.pc_sli4_params.cqv);
+	if (phba->sli4_hba.pc_sli4_params.cqv == LPFC_Q_CREATE_VERSION_2) {
+		bf_set(lpfc_mbx_cq_create_page_size, &cq_create->u.request,
+		       (PAGE_SIZE/SLI4_PAGE_SIZE));
+		bf_set(lpfc_cq_eq_id_2, &cq_create->u.request.context,
+		       eq->queue_id);
+	} else {
+		bf_set(lpfc_cq_eq_id, &cq_create->u.request.context,
+		       eq->queue_id);
+	}
 	switch (cq->entry_count) {
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
@@ -10449,7 +10459,6 @@ lpfc_cq_create(struct lpfc_hba *phba, st
 	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
 
 	/* The IOCTL status is embedded in the mailbox subheader. */
-	shdr = (union lpfc_sli4_cfg_shdr *) &cq_create->header.cfg_shdr;
 	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
 	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
 	if (shdr_status || shdr_add_status || rc) {
@@ -10515,20 +10524,20 @@ lpfc_mq_create_fb_init(struct lpfc_hba *
 	bf_set(lpfc_mq_context_valid, &mq_create->u.request.context, 1);
 	switch (mq->entry_count) {
 	case 16:
-		bf_set(lpfc_mq_context_count, &mq_create->u.request.context,
-		       LPFC_MQ_CNT_16);
+		bf_set(lpfc_mq_context_ring_size, &mq_create->u.request.context,
+		       LPFC_MQ_RING_SIZE_16);
 		break;
 	case 32:
-		bf_set(lpfc_mq_context_count, &mq_create->u.request.context,
-		       LPFC_MQ_CNT_32);
+		bf_set(lpfc_mq_context_ring_size, &mq_create->u.request.context,
+		       LPFC_MQ_RING_SIZE_32);
 		break;
 	case 64:
-		bf_set(lpfc_mq_context_count, &mq_create->u.request.context,
-		       LPFC_MQ_CNT_64);
+		bf_set(lpfc_mq_context_ring_size, &mq_create->u.request.context,
+		       LPFC_MQ_RING_SIZE_64);
 		break;
 	case 128:
-		bf_set(lpfc_mq_context_count, &mq_create->u.request.context,
-		       LPFC_MQ_CNT_128);
+		bf_set(lpfc_mq_context_ring_size, &mq_create->u.request.context,
+		       LPFC_MQ_RING_SIZE_128);
 		break;
 	}
 	list_for_each_entry(dmabuf, &mq->page_list, list) {
@@ -10586,6 +10595,7 @@ lpfc_mq_create(struct lpfc_hba *phba, st
 			 length, LPFC_SLI4_MBX_EMBED);
 
 	mq_create_ext = &mbox->u.mqe.un.mq_create_ext;
+	shdr = (union lpfc_sli4_cfg_shdr *) &mq_create_ext->header.cfg_shdr;
 	bf_set(lpfc_mbx_mq_create_ext_num_pages,
 	       &mq_create_ext->u.request, mq->page_count);
 	bf_set(lpfc_mbx_mq_create_ext_async_evt_link,
@@ -10598,9 +10608,15 @@ lpfc_mq_create(struct lpfc_hba *phba, st
 	       &mq_create_ext->u.request, 1);
 	bf_set(lpfc_mbx_mq_create_ext_async_evt_sli,
 	       &mq_create_ext->u.request, 1);
-	bf_set(lpfc_mq_context_cq_id,
-	       &mq_create_ext->u.request.context, cq->queue_id);
 	bf_set(lpfc_mq_context_valid, &mq_create_ext->u.request.context, 1);
+	bf_set(lpfc_mbox_hdr_version, &shdr->request,
+	       phba->sli4_hba.pc_sli4_params.mqv);
+	if (phba->sli4_hba.pc_sli4_params.mqv == LPFC_Q_CREATE_VERSION_1)
+		bf_set(lpfc_mbx_mq_create_ext_cq_id, &mq_create_ext->u.request,
+		       cq->queue_id);
+	else
+		bf_set(lpfc_mq_context_cq_id, &mq_create_ext->u.request.context,
+		       cq->queue_id);
 	switch (mq->entry_count) {
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
@@ -10610,20 +10626,24 @@ lpfc_mq_create(struct lpfc_hba *phba, st
 			return -EINVAL;
 		/* otherwise default to smallest count (drop through) */
 	case 16:
-		bf_set(lpfc_mq_context_count, &mq_create_ext->u.request.context,
-		       LPFC_MQ_CNT_16);
+		bf_set(lpfc_mq_context_ring_size,
+		       &mq_create_ext->u.request.context,
+		       LPFC_MQ_RING_SIZE_16);
 		break;
 	case 32:
-		bf_set(lpfc_mq_context_count, &mq_create_ext->u.request.context,
-		       LPFC_MQ_CNT_32);
+		bf_set(lpfc_mq_context_ring_size,
+		       &mq_create_ext->u.request.context,
+		       LPFC_MQ_RING_SIZE_32);
 		break;
 	case 64:
-		bf_set(lpfc_mq_context_count, &mq_create_ext->u.request.context,
-		       LPFC_MQ_CNT_64);
+		bf_set(lpfc_mq_context_ring_size,
+		       &mq_create_ext->u.request.context,
+		       LPFC_MQ_RING_SIZE_64);
 		break;
 	case 128:
-		bf_set(lpfc_mq_context_count, &mq_create_ext->u.request.context,
-		       LPFC_MQ_CNT_128);
+		bf_set(lpfc_mq_context_ring_size,
+		       &mq_create_ext->u.request.context,
+		       LPFC_MQ_RING_SIZE_128);
 		break;
 	}
 	list_for_each_entry(dmabuf, &mq->page_list, list) {
@@ -10634,7 +10654,6 @@ lpfc_mq_create(struct lpfc_hba *phba, st
 					putPaddrHigh(dmabuf->phys);
 	}
 	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
-	shdr = (union lpfc_sli4_cfg_shdr *) &mq_create_ext->header.cfg_shdr;
 	mq->queue_id = bf_get(lpfc_mbx_mq_create_q_id,
 			      &mq_create_ext->u.response);
 	if (rc != MBX_SUCCESS) {
@@ -10711,6 +10730,7 @@ lpfc_wq_create(struct lpfc_hba *phba, st
 	uint32_t shdr_status, shdr_add_status;
 	union lpfc_sli4_cfg_shdr *shdr;
 	uint32_t hw_page_size = phba->sli4_hba.pc_sli4_params.if_page_sz;
+	struct dma_address *page;
 
 	if (!phba->sli4_hba.pc_sli4_params.supported)
 		hw_page_size = SLI4_PAGE_SIZE;
@@ -10724,20 +10744,42 @@ lpfc_wq_create(struct lpfc_hba *phba, st
 			 LPFC_MBOX_OPCODE_FCOE_WQ_CREATE,
 			 length, LPFC_SLI4_MBX_EMBED);
 	wq_create = &mbox->u.mqe.un.wq_create;
+	shdr = (union lpfc_sli4_cfg_shdr *) &wq_create->header.cfg_shdr;
 	bf_set(lpfc_mbx_wq_create_num_pages, &wq_create->u.request,
 		    wq->page_count);
 	bf_set(lpfc_mbx_wq_create_cq_id, &wq_create->u.request,
 		    cq->queue_id);
+	bf_set(lpfc_mbox_hdr_version, &shdr->request,
+	       phba->sli4_hba.pc_sli4_params.wqv);
+	if (phba->sli4_hba.pc_sli4_params.wqv == LPFC_Q_CREATE_VERSION_1) {
+		bf_set(lpfc_mbx_wq_create_wqe_count, &wq_create->u.request_1,
+		       wq->entry_count);
+		switch (wq->entry_size) {
+		default:
+		case 64:
+			bf_set(lpfc_mbx_wq_create_wqe_size,
+			       &wq_create->u.request_1,
+			       LPFC_WQ_WQE_SIZE_64);
+			break;
+		case 128:
+			bf_set(lpfc_mbx_wq_create_wqe_size,
+			       &wq_create->u.request_1,
+			       LPFC_WQ_WQE_SIZE_128);
+			break;
+		}
+		bf_set(lpfc_mbx_wq_create_page_size, &wq_create->u.request_1,
+		       (PAGE_SIZE/SLI4_PAGE_SIZE));
+		page = wq_create->u.request_1.page;
+	} else {
+		page = wq_create->u.request.page;
+	}
 	list_for_each_entry(dmabuf, &wq->page_list, list) {
 		memset(dmabuf->virt, 0, hw_page_size);
-		wq_create->u.request.page[dmabuf->buffer_tag].addr_lo =
-					putPaddrLow(dmabuf->phys);
-		wq_create->u.request.page[dmabuf->buffer_tag].addr_hi =
-					putPaddrHigh(dmabuf->phys);
+		page[dmabuf->buffer_tag].addr_lo = putPaddrLow(dmabuf->phys);
+		page[dmabuf->buffer_tag].addr_hi = putPaddrHigh(dmabuf->phys);
 	}
 	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
 	/* The IOCTL status is embedded in the mailbox subheader. */
-	shdr = (union lpfc_sli4_cfg_shdr *) &wq_create->header.cfg_shdr;
 	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
 	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
 	if (shdr_status || shdr_add_status || rc) {
@@ -10815,37 +10857,51 @@ lpfc_rq_create(struct lpfc_hba *phba, st
 			 LPFC_MBOX_OPCODE_FCOE_RQ_CREATE,
 			 length, LPFC_SLI4_MBX_EMBED);
 	rq_create = &mbox->u.mqe.un.rq_create;
-	switch (hrq->entry_count) {
-	default:
-		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-				"2535 Unsupported RQ count. (%d)\n",
-				hrq->entry_count);
-		if (hrq->entry_count < 512)
-			return -EINVAL;
-		/* otherwise default to smallest count (drop through) */
-	case 512:
-		bf_set(lpfc_rq_context_rq_size, &rq_create->u.request.context,
-		       LPFC_RQ_RING_SIZE_512);
-		break;
-	case 1024:
-		bf_set(lpfc_rq_context_rq_size, &rq_create->u.request.context,
-		       LPFC_RQ_RING_SIZE_1024);
-		break;
-	case 2048:
-		bf_set(lpfc_rq_context_rq_size, &rq_create->u.request.context,
-		       LPFC_RQ_RING_SIZE_2048);
-		break;
-	case 4096:
-		bf_set(lpfc_rq_context_rq_size, &rq_create->u.request.context,
-		       LPFC_RQ_RING_SIZE_4096);
-		break;
+	shdr = (union lpfc_sli4_cfg_shdr *) &rq_create->header.cfg_shdr;
+	bf_set(lpfc_mbox_hdr_version, &shdr->request,
+	       phba->sli4_hba.pc_sli4_params.rqv);
+	if (phba->sli4_hba.pc_sli4_params.rqv == LPFC_Q_CREATE_VERSION_1) {
+		bf_set(lpfc_rq_context_rqe_count_1,
+		       &rq_create->u.request.context,
+		       hrq->entry_count);
+		rq_create->u.request.context.buffer_size = LPFC_HDR_BUF_SIZE;
+	} else {
+		switch (hrq->entry_count) {
+		default:
+			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+					"2535 Unsupported RQ count. (%d)\n",
+					hrq->entry_count);
+			if (hrq->entry_count < 512)
+				return -EINVAL;
+			/* otherwise default to smallest count (drop through) */
+		case 512:
+			bf_set(lpfc_rq_context_rqe_count,
+			       &rq_create->u.request.context,
+			       LPFC_RQ_RING_SIZE_512);
+			break;
+		case 1024:
+			bf_set(lpfc_rq_context_rqe_count,
+			       &rq_create->u.request.context,
+			       LPFC_RQ_RING_SIZE_1024);
+			break;
+		case 2048:
+			bf_set(lpfc_rq_context_rqe_count,
+			       &rq_create->u.request.context,
+			       LPFC_RQ_RING_SIZE_2048);
+			break;
+		case 4096:
+			bf_set(lpfc_rq_context_rqe_count,
+			       &rq_create->u.request.context,
+			       LPFC_RQ_RING_SIZE_4096);
+			break;
+		}
+		bf_set(lpfc_rq_context_buf_size, &rq_create->u.request.context,
+		       LPFC_HDR_BUF_SIZE);
 	}
 	bf_set(lpfc_rq_context_cq_id, &rq_create->u.request.context,
 	       cq->queue_id);
 	bf_set(lpfc_mbx_rq_create_num_pages, &rq_create->u.request,
 	       hrq->page_count);
-	bf_set(lpfc_rq_context_buf_size, &rq_create->u.request.context,
-	       LPFC_HDR_BUF_SIZE);
 	list_for_each_entry(dmabuf, &hrq->page_list, list) {
 		memset(dmabuf->virt, 0, hw_page_size);
 		rq_create->u.request.page[dmabuf->buffer_tag].addr_lo =
@@ -10855,7 +10911,6 @@ lpfc_rq_create(struct lpfc_hba *phba, st
 	}
 	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
 	/* The IOCTL status is embedded in the mailbox subheader. */
-	shdr = (union lpfc_sli4_cfg_shdr *) &rq_create->header.cfg_shdr;
 	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
 	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
 	if (shdr_status || shdr_add_status || rc) {
@@ -10881,37 +10936,50 @@ lpfc_rq_create(struct lpfc_hba *phba, st
 	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_FCOE,
 			 LPFC_MBOX_OPCODE_FCOE_RQ_CREATE,
 			 length, LPFC_SLI4_MBX_EMBED);
-	switch (drq->entry_count) {
-	default:
-		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-				"2536 Unsupported RQ count. (%d)\n",
-				drq->entry_count);
-		if (drq->entry_count < 512)
-			return -EINVAL;
-		/* otherwise default to smallest count (drop through) */
-	case 512:
-		bf_set(lpfc_rq_context_rq_size, &rq_create->u.request.context,
-		       LPFC_RQ_RING_SIZE_512);
-		break;
-	case 1024:
-		bf_set(lpfc_rq_context_rq_size, &rq_create->u.request.context,
-		       LPFC_RQ_RING_SIZE_1024);
-		break;
-	case 2048:
-		bf_set(lpfc_rq_context_rq_size, &rq_create->u.request.context,
-		       LPFC_RQ_RING_SIZE_2048);
-		break;
-	case 4096:
-		bf_set(lpfc_rq_context_rq_size, &rq_create->u.request.context,
-		       LPFC_RQ_RING_SIZE_4096);
-		break;
+	bf_set(lpfc_mbox_hdr_version, &shdr->request,
+	       phba->sli4_hba.pc_sli4_params.rqv);
+	if (phba->sli4_hba.pc_sli4_params.rqv == LPFC_Q_CREATE_VERSION_1) {
+		bf_set(lpfc_rq_context_rqe_count_1,
+		       &rq_create->u.request.context,
+		       hrq->entry_count);
+		rq_create->u.request.context.buffer_size = LPFC_DATA_BUF_SIZE;
+	} else {
+		switch (drq->entry_count) {
+		default:
+			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+					"2536 Unsupported RQ count. (%d)\n",
+					drq->entry_count);
+			if (drq->entry_count < 512)
+				return -EINVAL;
+			/* otherwise default to smallest count (drop through) */
+		case 512:
+			bf_set(lpfc_rq_context_rqe_count,
+			       &rq_create->u.request.context,
+			       LPFC_RQ_RING_SIZE_512);
+			break;
+		case 1024:
+			bf_set(lpfc_rq_context_rqe_count,
+			       &rq_create->u.request.context,
+			       LPFC_RQ_RING_SIZE_1024);
+			break;
+		case 2048:
+			bf_set(lpfc_rq_context_rqe_count,
+			       &rq_create->u.request.context,
+			       LPFC_RQ_RING_SIZE_2048);
+			break;
+		case 4096:
+			bf_set(lpfc_rq_context_rqe_count,
+			       &rq_create->u.request.context,
+			       LPFC_RQ_RING_SIZE_4096);
+			break;
+		}
+		bf_set(lpfc_rq_context_buf_size, &rq_create->u.request.context,
+		       LPFC_DATA_BUF_SIZE);
 	}
 	bf_set(lpfc_rq_context_cq_id, &rq_create->u.request.context,
 	       cq->queue_id);
 	bf_set(lpfc_mbx_rq_create_num_pages, &rq_create->u.request,
 	       drq->page_count);
-	bf_set(lpfc_rq_context_buf_size, &rq_create->u.request.context,
-	       LPFC_DATA_BUF_SIZE);
 	list_for_each_entry(dmabuf, &drq->page_list, list) {
 		rq_create->u.request.page[dmabuf->buffer_tag].addr_lo =
 					putPaddrLow(dmabuf->phys);


