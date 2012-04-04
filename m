From: michaelc@cs.wisc.edu
Subject: [PATCH 12/17] be2iscsi: Check ASYNC PDU Handle corresponds to HDR/DATA Handle
Date: Tue,  3 Apr 2012 23:41:47 -0500
Message-ID: <1333514512-21799-13-git-send-email-michaelc@cs.wisc.edu>
References: <1333514512-21799-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002Ab2DDEmL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Apr 2012 00:42:11 -0400
In-Reply-To: <1333514512-21799-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 For each ASYNC PDU received there is an HDR and DATA handle for it.
 There will be only 1 HDR ASYNC Handle, but DATA Handle can be more
 than 1 for each ASYNC PDU received. Checking if the ASYNC Handle
 correspongs to HDR or DATA while returning the Handle to the free list.
 hwi_free_async_msg just return the handles to the free list. No return
 values are needed so changing the return type to void.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_main.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 595dea5..9b5fbff 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1471,14 +1471,13 @@ hwi_update_async_writables(struct hwi_async_pdu_context *pasync_ctx,
 	return 0;
 }
 
-static unsigned int hwi_free_async_msg(struct beiscsi_hba *phba,
+static void hwi_free_async_msg(struct beiscsi_hba *phba,
 				       unsigned int cri)
 {
 	struct hwi_controller *phwi_ctrlr;
 	struct hwi_async_pdu_context *pasync_ctx;
 	struct async_pdu_handle *pasync_handle, *tmp_handle;
 	struct list_head *plist;
-	unsigned int i = 0;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
 	pasync_ctx = HWI_GET_ASYNC_PDU_CTX(phwi_ctrlr);
@@ -1488,23 +1487,20 @@ static unsigned int hwi_free_async_msg(struct beiscsi_hba *phba,
 	list_for_each_entry_safe(pasync_handle, tmp_handle, plist, link) {
 		list_del(&pasync_handle->link);
 
-		if (i == 0) {
+		if (pasync_handle->is_header) {
 			list_add_tail(&pasync_handle->link,
 				      &pasync_ctx->async_header.free_list);
 			pasync_ctx->async_header.free_entries++;
-			i++;
 		} else {
 			list_add_tail(&pasync_handle->link,
 				      &pasync_ctx->async_data.free_list);
 			pasync_ctx->async_data.free_entries++;
-			i++;
 		}
 	}
 
 	INIT_LIST_HEAD(&pasync_ctx->async_entry[cri].wait_queue.list);
 	pasync_ctx->async_entry[cri].wait_queue.hdr_received = 0;
 	pasync_ctx->async_entry[cri].wait_queue.bytes_received = 0;
-	return 0;
 }
 
 static struct phys_addr *
-- 
1.7.7.6

