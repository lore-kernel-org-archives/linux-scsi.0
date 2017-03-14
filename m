From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 6/9] be2iscsi: Use num_cons field in Rx CQE
Date: Tue, 14 Mar 2017 13:31:31 +0530
Message-ID: <1489478494-5432-7-git-send-email-jitendra.bhivare@broadcom.com>
References: <1489478494-5432-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:38178 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750942AbdCNICP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Mar 2017 04:02:15 -0400
Received: by mail-wm0-f53.google.com with SMTP id t189so57136723wmt.1
        for <linux-scsi@vger.kernel.org>; Tue, 14 Mar 2017 01:02:14 -0700 (PDT)
In-Reply-To: <1489478494-5432-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

FW runs out of buffer if buffers are not posted back soon.
ASYNC Rx CQE indicates that FW has consumed 8 RQEs.
Use it to post back buffers instead of waiting for buffers
to be processed and freed by driver.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_main.c | 124 ++++++++++++++++------------------------
 drivers/scsi/be2iscsi/be_main.h |   1 +
 2 files changed, 51 insertions(+), 74 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index b76fd26..1cd9c2d 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1467,7 +1467,8 @@ beiscsi_hdl_put_handle(struct hd_async_context *pasync_ctx,
 static struct hd_async_handle *
 beiscsi_hdl_get_handle(struct beiscsi_conn *beiscsi_conn,
 		       struct hd_async_context *pasync_ctx,
-		       struct i_t_dpdu_cqe *pdpdu_cqe)
+		       struct i_t_dpdu_cqe *pdpdu_cqe,
+		       u8 *header)
 {
 	struct beiscsi_hba *phba = beiscsi_conn->phba;
 	struct hd_async_handle *pasync_handle;
@@ -1515,6 +1516,7 @@ beiscsi_hdl_get_handle(struct beiscsi_conn *beiscsi_conn,
 	switch (code) {
 	case UNSOL_HDR_NOTIFY:
 		pasync_handle = pasync_ctx->async_entry[ci].header;
+		*header = 1;
 		break;
 	case UNSOL_DATA_DIGEST_ERROR_NOTIFY:
 		error = 1;
@@ -1547,6 +1549,7 @@ beiscsi_hdl_get_handle(struct beiscsi_conn *beiscsi_conn,
 		/* FW has stale address - attempt continuing by dropping */
 	}
 
+	list_del_init(&pasync_handle->link);
 	/**
 	 * Each CID is associated with unique CRI.
 	 * ASYNC_CRI_FROM_CID mapping and CRI_FROM_CID are totaly different.
@@ -1554,11 +1557,6 @@ beiscsi_hdl_get_handle(struct beiscsi_conn *beiscsi_conn,
 	pasync_handle->cri = BE_GET_ASYNC_CRI_FROM_CID(cid);
 	pasync_handle->is_final = final;
 	pasync_handle->buffer_len = dpl;
-	/* empty the slot */
-	if (pasync_handle->is_header)
-		pasync_ctx->async_entry[ci].header = NULL;
-	else
-		pasync_ctx->async_entry[ci].data = NULL;
 
 	/**
 	 * DEF PDU header and data buffers with errors should be simply
@@ -1708,85 +1706,53 @@ beiscsi_hdl_gather_pdu(struct beiscsi_conn *beiscsi_conn,
 
 static void
 beiscsi_hdq_post_handles(struct beiscsi_hba *phba,
-			 u8 header, u8 ulp_num)
+			 u8 header, u8 ulp_num, u16 nbuf)
 {
-	struct hd_async_handle *pasync_handle, *tmp, **slot;
+	struct hd_async_handle *pasync_handle;
 	struct hd_async_context *pasync_ctx;
 	struct hwi_controller *phwi_ctrlr;
-	struct list_head *hfree_list;
 	struct phys_addr *pasync_sge;
 	u32 ring_id, doorbell = 0;
 	u32 doorbell_offset;
-	u16 prod = 0, cons;
-	u16 index;
+	u16 prod, pi;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
 	pasync_ctx = HWI_GET_ASYNC_PDU_CTX(phwi_ctrlr, ulp_num);
 	if (header) {
-		cons = pasync_ctx->async_header.free_entries;
-		hfree_list = &pasync_ctx->async_header.free_list;
+		pasync_sge = pasync_ctx->async_header.ring_base;
+		pi = pasync_ctx->async_header.pi;
 		ring_id = phwi_ctrlr->default_pdu_hdr[ulp_num].id;
 		doorbell_offset = phwi_ctrlr->default_pdu_hdr[ulp_num].
 					doorbell_offset;
 	} else {
-		cons = pasync_ctx->async_data.free_entries;
-		hfree_list = &pasync_ctx->async_data.free_list;
+		pasync_sge = pasync_ctx->async_data.ring_base;
+		pi = pasync_ctx->async_data.pi;
 		ring_id = phwi_ctrlr->default_pdu_data[ulp_num].id;
 		doorbell_offset = phwi_ctrlr->default_pdu_data[ulp_num].
 					doorbell_offset;
 	}
-	/* number of entries posted must be in multiples of 8 */
-	if (cons % 8)
-		return;
 
-	list_for_each_entry_safe(pasync_handle, tmp, hfree_list, link) {
-		list_del_init(&pasync_handle->link);
-		pasync_handle->is_final = 0;
-		pasync_handle->buffer_len = 0;
-
-		/* handles can be consumed out of order, use index in handle */
-		index = pasync_handle->index;
-		WARN_ON(pasync_handle->is_header != header);
+	for (prod = 0; prod < nbuf; prod++) {
 		if (header)
-			slot = &pasync_ctx->async_entry[index].header;
+			pasync_handle = pasync_ctx->async_entry[pi].header;
 		else
-			slot = &pasync_ctx->async_entry[index].data;
-		/**
-		 * The slot just tracks handle's hold and release, so
-		 * overwriting at the same index won't do any harm but
-		 * needs to be caught.
-		 */
-		if (*slot != NULL) {
-			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_ISCSI,
-				    "BM_%d : async PDU %s slot at %u not empty\n",
-				    header ? "header" : "data", index);
+			pasync_handle = pasync_ctx->async_entry[pi].data;
+		WARN_ON(pasync_handle->is_header != header);
+		WARN_ON(pasync_handle->index != pi);
+		/* setup the ring only once */
+		if (nbuf == pasync_ctx->num_entries) {
+			/* note hi is lo */
+			pasync_sge[pi].hi = pasync_handle->pa.u.a32.address_lo;
+			pasync_sge[pi].lo = pasync_handle->pa.u.a32.address_hi;
 		}
-		/**
-		 * We use same freed index as in completion to post so this
-		 * operation is not required for refills. Its required only
-		 * for ring creation.
-		 */
-		if (header)
-			pasync_sge = pasync_ctx->async_header.ring_base;
-		else
-			pasync_sge = pasync_ctx->async_data.ring_base;
-		pasync_sge += index;
-		/* if its a refill then address is same; hi is lo */
-		WARN_ON(pasync_sge->hi &&
-			pasync_sge->hi != pasync_handle->pa.u.a32.address_lo);
-		WARN_ON(pasync_sge->lo &&
-			pasync_sge->lo != pasync_handle->pa.u.a32.address_hi);
-		pasync_sge->hi = pasync_handle->pa.u.a32.address_lo;
-		pasync_sge->lo = pasync_handle->pa.u.a32.address_hi;
-
-		*slot = pasync_handle;
-		if (++prod == cons)
-			break;
+		if (++pi == pasync_ctx->num_entries)
+			pi = 0;
 	}
+
 	if (header)
-		pasync_ctx->async_header.free_entries -= prod;
+		pasync_ctx->async_header.pi = pi;
 	else
-		pasync_ctx->async_data.free_entries -= prod;
+		pasync_ctx->async_data.pi = pi;
 
 	doorbell |= ring_id & DB_DEF_PDU_RING_ID_MASK;
 	doorbell |= 1 << DB_DEF_PDU_REARM_SHIFT;
@@ -1803,20 +1769,26 @@ beiscsi_hdq_process_compl(struct beiscsi_conn *beiscsi_conn,
 	struct hd_async_handle *pasync_handle = NULL;
 	struct hd_async_context *pasync_ctx;
 	struct hwi_controller *phwi_ctrlr;
+	u8 ulp_num, consumed, header = 0;
 	u16 cid_cri;
-	u8 ulp_num;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
 	cid_cri = BE_GET_CRI_FROM_CID(beiscsi_conn->beiscsi_conn_cid);
 	ulp_num = BEISCSI_GET_ULP_FROM_CRI(phwi_ctrlr, cid_cri);
 	pasync_ctx = HWI_GET_ASYNC_PDU_CTX(phwi_ctrlr, ulp_num);
 	pasync_handle = beiscsi_hdl_get_handle(beiscsi_conn, pasync_ctx,
-					       pdpdu_cqe);
-	if (!pasync_handle)
-		return;
-
-	beiscsi_hdl_gather_pdu(beiscsi_conn, pasync_ctx, pasync_handle);
-	beiscsi_hdq_post_handles(phba, pasync_handle->is_header, ulp_num);
+					       pdpdu_cqe, &header);
+	if (is_chip_be2_be3r(phba))
+		consumed = AMAP_GET_BITS(struct amap_i_t_dpdu_cqe,
+					 num_cons, pdpdu_cqe);
+	else
+		consumed = AMAP_GET_BITS(struct amap_i_t_dpdu_cqe_v2,
+					 num_cons, pdpdu_cqe);
+	if (pasync_handle)
+		beiscsi_hdl_gather_pdu(beiscsi_conn, pasync_ctx, pasync_handle);
+	/* num_cons indicates number of 8 RQEs consumed */
+	if (consumed)
+		beiscsi_hdq_post_handles(phba, header, ulp_num, 8 * consumed);
 }
 
 void beiscsi_process_mcc_cq(struct beiscsi_hba *phba)
@@ -2775,6 +2747,7 @@ static int hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 					    "BM_%d : No Virtual address for ULP : %d\n",
 					    ulp_num);
 
+			pasync_ctx->async_header.pi = 0;
 			pasync_ctx->async_header.buffer_size = p->defpdu_hdr_sz;
 			pasync_ctx->async_header.va_base =
 				mem_descr->mem_array[0].virtual_address;
@@ -2883,6 +2856,7 @@ static int hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 					    ulp_num);
 
 			idx = 0;
+			pasync_ctx->async_data.pi = 0;
 			pasync_ctx->async_data.buffer_size = p->defpdu_data_sz;
 			pasync_ctx->async_data.va_base =
 				mem_descr->mem_array[idx].virtual_address;
@@ -2913,11 +2887,12 @@ static int hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 				list_add_tail(&pasync_header_h->link,
 					      &pasync_ctx->async_header.
 					      free_list);
+				pasync_ctx->async_entry[index].header =
+					pasync_header_h;
 				pasync_header_h++;
 				pasync_ctx->async_header.free_entries++;
 				INIT_LIST_HEAD(&pasync_ctx->async_entry[index].
 						wq.list);
-				pasync_ctx->async_entry[index].header = NULL;
 
 				pasync_data_h->cri = -1;
 				pasync_data_h->is_header = 0;
@@ -2954,9 +2929,10 @@ static int hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 				list_add_tail(&pasync_data_h->link,
 					      &pasync_ctx->async_data.
 					      free_list);
+				pasync_ctx->async_entry[index].data =
+					pasync_data_h;
 				pasync_data_h++;
 				pasync_ctx->async_data.free_entries++;
-				pasync_ctx->async_entry[index].data = NULL;
 			}
 		}
 	}
@@ -3734,6 +3710,7 @@ static int hwi_init_port(struct beiscsi_hba *phba)
 	unsigned int def_pdu_ring_sz;
 	struct be_ctrl_info *ctrl = &phba->ctrl;
 	int status, ulp_num;
+	u16 nbufs;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
 	phwi_context = phwi_ctrlr->phwi_ctxt;
@@ -3770,9 +3747,8 @@ static int hwi_init_port(struct beiscsi_hba *phba)
 
 	for (ulp_num = 0; ulp_num < BEISCSI_ULP_COUNT; ulp_num++) {
 		if (test_bit(ulp_num, &phba->fw_config.ulp_supported)) {
-			def_pdu_ring_sz =
-				BEISCSI_ASYNC_HDQ_SIZE(phba, ulp_num) *
-				sizeof(struct phys_addr);
+			nbufs = phwi_context->pasync_ctx[ulp_num]->num_entries;
+			def_pdu_ring_sz = nbufs * sizeof(struct phys_addr);
 
 			status = beiscsi_create_def_hdr(phba, phwi_context,
 							phwi_ctrlr,
@@ -3800,9 +3776,9 @@ static int hwi_init_port(struct beiscsi_hba *phba)
 			 * let EP know about it.
 			 */
 			beiscsi_hdq_post_handles(phba, BEISCSI_DEFQ_HDR,
-						 ulp_num);
+						 ulp_num, nbufs);
 			beiscsi_hdq_post_handles(phba, BEISCSI_DEFQ_DATA,
-						 ulp_num);
+						 ulp_num, nbufs);
 		}
 	}
 
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 216f9b4..cebacac 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -634,6 +634,7 @@ struct hd_async_buf_context {
 	 * They are posted back to FW in groups of 8.
 	 */
 	struct list_head free_list;
+	u16 pi;
 };
 
 /**
-- 
2.7.4
