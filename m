From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v2 07/10] be2iscsi: Remove free_list for ASYNC handles
Date: Thu, 16 Mar 2017 08:54:42 +0530
Message-ID: <1489634685-4975-8-git-send-email-jitendra.bhivare@broadcom.com>
References: <1489634685-4975-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:33233 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751332AbdCPD0B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Mar 2017 23:26:01 -0400
Received: by mail-wm0-f51.google.com with SMTP id v203so1031962wmg.0
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2017 20:25:36 -0700 (PDT)
In-Reply-To: <1489634685-4975-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

With previous patch adding ASYNC Rx buffers to free_list is not required.
Remove all free_list related operations.

Add in_use to track if buffer posted is being processed by driver and
purge all buffers received for connection if found so.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_main.c | 99 +++++++++++++++++------------------------
 drivers/scsi/be2iscsi/be_main.h |  8 +---
 2 files changed, 43 insertions(+), 64 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 1cd9c2d..ee1f1c4 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1453,15 +1453,28 @@ static inline void
 beiscsi_hdl_put_handle(struct hd_async_context *pasync_ctx,
 			 struct hd_async_handle *pasync_handle)
 {
-	if (pasync_handle->is_header) {
-		list_add_tail(&pasync_handle->link,
-				&pasync_ctx->async_header.free_list);
-		pasync_ctx->async_header.free_entries++;
-	} else {
-		list_add_tail(&pasync_handle->link,
-				&pasync_ctx->async_data.free_list);
-		pasync_ctx->async_data.free_entries++;
-	}
+	pasync_handle->is_final = 0;
+	pasync_handle->buffer_len = 0;
+	pasync_handle->in_use = 0;
+	list_del_init(&pasync_handle->link);
+}
+
+static void
+beiscsi_hdl_purge_handles(struct beiscsi_hba *phba,
+			  struct hd_async_context *pasync_ctx,
+			  u16 cri)
+{
+	struct hd_async_handle *pasync_handle, *tmp_handle;
+	struct list_head *plist;
+
+	plist  = &pasync_ctx->async_entry[cri].wq.list;
+	list_for_each_entry_safe(pasync_handle, tmp_handle, plist, link)
+		beiscsi_hdl_put_handle(pasync_ctx, pasync_handle);
+
+	INIT_LIST_HEAD(&pasync_ctx->async_entry[cri].wq.list);
+	pasync_ctx->async_entry[cri].wq.hdr_len = 0;
+	pasync_ctx->async_entry[cri].wq.bytes_received = 0;
+	pasync_ctx->async_entry[cri].wq.bytes_needed = 0;
 }
 
 static struct hd_async_handle *
@@ -1473,11 +1486,12 @@ beiscsi_hdl_get_handle(struct beiscsi_conn *beiscsi_conn,
 	struct beiscsi_hba *phba = beiscsi_conn->phba;
 	struct hd_async_handle *pasync_handle;
 	struct be_bus_address phys_addr;
+	u16 cid, code, ci, cri;
 	u8 final, error = 0;
-	u16 cid, code, ci;
 	u32 dpl;
 
 	cid = beiscsi_conn->beiscsi_conn_cid;
+	cri = BE_GET_ASYNC_CRI_FROM_CID(cid);
 	/**
 	 * This function is invoked to get the right async_handle structure
 	 * from a given DEF PDU CQ entry.
@@ -1525,15 +1539,7 @@ beiscsi_hdl_get_handle(struct beiscsi_conn *beiscsi_conn,
 		break;
 	/* called only for above codes */
 	default:
-		pasync_handle = NULL;
-		break;
-	}
-
-	if (!pasync_handle) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_ISCSI,
-			    "BM_%d : cid %d async PDU handle not found - code %d ci %d addr %llx\n",
-			    cid, code, ci, phys_addr.u.a64.address);
-		return pasync_handle;
+		return NULL;
 	}
 
 	if (pasync_handle->pa.u.a64.address != phys_addr.u.a64.address ||
@@ -1549,44 +1555,33 @@ beiscsi_hdl_get_handle(struct beiscsi_conn *beiscsi_conn,
 		/* FW has stale address - attempt continuing by dropping */
 	}
 
-	list_del_init(&pasync_handle->link);
-	/**
-	 * Each CID is associated with unique CRI.
-	 * ASYNC_CRI_FROM_CID mapping and CRI_FROM_CID are totaly different.
-	 **/
-	pasync_handle->cri = BE_GET_ASYNC_CRI_FROM_CID(cid);
-	pasync_handle->is_final = final;
-	pasync_handle->buffer_len = dpl;
-
 	/**
 	 * DEF PDU header and data buffers with errors should be simply
 	 * dropped as there are no consumers for it.
 	 */
 	if (error) {
 		beiscsi_hdl_put_handle(pasync_ctx, pasync_handle);
-		pasync_handle = NULL;
+		return NULL;
 	}
-	return pasync_handle;
-}
-
-static void
-beiscsi_hdl_purge_handles(struct beiscsi_hba *phba,
-			  struct hd_async_context *pasync_ctx,
-			  u16 cri)
-{
-	struct hd_async_handle *pasync_handle, *tmp_handle;
-	struct list_head *plist;
 
-	plist  = &pasync_ctx->async_entry[cri].wq.list;
-	list_for_each_entry_safe(pasync_handle, tmp_handle, plist, link) {
-		list_del(&pasync_handle->link);
-		beiscsi_hdl_put_handle(pasync_ctx, pasync_handle);
+	if (pasync_handle->in_use || !list_empty(&pasync_handle->link)) {
+		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_ISCSI,
+			    "BM_%d : cid %d async PDU handle in use - code %d ci %d addr %llx\n",
+			    cid, code, ci, phys_addr.u.a64.address);
+		beiscsi_hdl_purge_handles(phba, pasync_ctx, cri);
 	}
 
-	INIT_LIST_HEAD(&pasync_ctx->async_entry[cri].wq.list);
-	pasync_ctx->async_entry[cri].wq.hdr_len = 0;
-	pasync_ctx->async_entry[cri].wq.bytes_received = 0;
-	pasync_ctx->async_entry[cri].wq.bytes_needed = 0;
+	list_del_init(&pasync_handle->link);
+	/**
+	 * Each CID is associated with unique CRI.
+	 * ASYNC_CRI_FROM_CID mapping and CRI_FROM_CID are totaly different.
+	 **/
+	pasync_handle->cri = cri;
+	pasync_handle->is_final = final;
+	pasync_handle->buffer_len = dpl;
+	pasync_handle->in_use = 1;
+
+	return pasync_handle;
 }
 
 static unsigned int
@@ -2795,7 +2790,6 @@ static int hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 
 			pasync_ctx->async_header.handle_base =
 				mem_descr->mem_array[0].virtual_address;
-			INIT_LIST_HEAD(&pasync_ctx->async_header.free_list);
 
 			/* setup data buffer sgls */
 			mem_descr = (struct be_mem_descriptor *)phba->init_mem;
@@ -2829,7 +2823,6 @@ static int hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 
 			pasync_ctx->async_data.handle_base =
 				mem_descr->mem_array[0].virtual_address;
-			INIT_LIST_HEAD(&pasync_ctx->async_data.free_list);
 
 			pasync_header_h =
 				(struct hd_async_handle *)
@@ -2884,13 +2877,9 @@ static int hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 					pasync_ctx->async_header.pa_base.u.a64.
 					address + (p->defpdu_hdr_sz * index);
 
-				list_add_tail(&pasync_header_h->link,
-					      &pasync_ctx->async_header.
-					      free_list);
 				pasync_ctx->async_entry[index].header =
 					pasync_header_h;
 				pasync_header_h++;
-				pasync_ctx->async_header.free_entries++;
 				INIT_LIST_HEAD(&pasync_ctx->async_entry[index].
 						wq.list);
 
@@ -2926,13 +2915,9 @@ static int hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 				num_per_mem++;
 				num_async_data--;
 
-				list_add_tail(&pasync_data_h->link,
-					      &pasync_ctx->async_data.
-					      free_list);
 				pasync_ctx->async_entry[index].data =
 					pasync_data_h;
 				pasync_data_h++;
-				pasync_ctx->async_data.free_entries++;
 			}
 		}
 	}
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index cebacac..9883a85 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -596,6 +596,7 @@ struct hd_async_handle {
 	u16 cri;
 	u8 is_header;
 	u8 is_final;
+	u8 in_use;
 };
 
 #define BEISCSI_ASYNC_HDQ_SIZE(phba, ulp) \
@@ -626,14 +627,7 @@ struct hd_async_buf_context {
 	void *va_base;
 	void *ring_base;
 	struct hd_async_handle *handle_base;
-	u16 free_entries;
 	u32 buffer_size;
-	/**
-	 * Once iSCSI layer finishes processing an async PDU, the
-	 * handles used for the PDU are added to this list.
-	 * They are posted back to FW in groups of 8.
-	 */
-	struct list_head free_list;
 	u16 pi;
 };
 
-- 
2.7.4
