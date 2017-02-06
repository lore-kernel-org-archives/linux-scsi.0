From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 01/18] lpfc: Correct WQ creation for pagesize
Date: Mon, 06 Feb 2017 15:08:50 -0800
Message-ID: <58990202.ppD+DnSRmfoY41ZK%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36058 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751456AbdBFXIz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 18:08:55 -0500
Received: by mail-wm0-f66.google.com with SMTP id r18so25016231wmd.3
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 15:08:55 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org


Correct WQ creation for pagesize

The driver was calculating the adapter command pagesize indicator from
the system pagesize. However, the buffers the driver allocates are only
one size (SLI4_PAGE_SIZE), so no calculation was necessary.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
Note: this patch was not in v1

 drivers/scsi/lpfc/lpfc_hw4.h | 2 ++
 drivers/scsi/lpfc/lpfc_sli.c | 9 +++++----
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 5646699..964a1fd 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -1186,6 +1186,7 @@ struct lpfc_mbx_wq_create {
 #define lpfc_mbx_wq_create_page_size_SHIFT	0
 #define lpfc_mbx_wq_create_page_size_MASK	0x000000FF
 #define lpfc_mbx_wq_create_page_size_WORD	word1
+#define LPFC_WQ_PAGE_SIZE_4096	0x1
 #define lpfc_mbx_wq_create_wqe_size_SHIFT	8
 #define lpfc_mbx_wq_create_wqe_size_MASK	0x0000000F
 #define lpfc_mbx_wq_create_wqe_size_WORD	word1
@@ -1257,6 +1258,7 @@ struct rq_context {
 #define lpfc_rq_context_page_size_SHIFT	0		/* Version 1 Only */
 #define lpfc_rq_context_page_size_MASK	0x000000FF
 #define lpfc_rq_context_page_size_WORD	word0
+#define	LPFC_RQ_PAGE_SIZE_4096	0x1
 	uint32_t reserved1;
 	uint32_t word2;
 #define lpfc_rq_context_cq_id_SHIFT	16
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 3a8470d..dbe9cb1 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -13715,7 +13715,7 @@ lpfc_wq_create(struct lpfc_hba *phba, struct lpfc_queue *wq,
 			       LPFC_WQ_WQE_SIZE_128);
 			bf_set(lpfc_mbx_wq_create_page_size,
 			       &wq_create->u.request_1,
-			       (PAGE_SIZE/SLI4_PAGE_SIZE));
+			       LPFC_WQ_PAGE_SIZE_4096);
 			page = wq_create->u.request_1.page;
 			break;
 		}
@@ -13741,8 +13741,9 @@ lpfc_wq_create(struct lpfc_hba *phba, struct lpfc_queue *wq,
 			       LPFC_WQ_WQE_SIZE_128);
 			break;
 		}
-		bf_set(lpfc_mbx_wq_create_page_size, &wq_create->u.request_1,
-		       (PAGE_SIZE/SLI4_PAGE_SIZE));
+		bf_set(lpfc_mbx_wq_create_page_size,
+		       &wq_create->u.request_1,
+		       LPFC_WQ_PAGE_SIZE_4096);
 		page = wq_create->u.request_1.page;
 		break;
 	default:
@@ -13928,7 +13929,7 @@ lpfc_rq_create(struct lpfc_hba *phba, struct lpfc_queue *hrq,
 		       LPFC_RQE_SIZE_8);
 		bf_set(lpfc_rq_context_page_size,
 		       &rq_create->u.request.context,
-		       (PAGE_SIZE/SLI4_PAGE_SIZE));
+		       LPFC_RQ_PAGE_SIZE_4096);
 	} else {
 		switch (hrq->entry_count) {
 		default:
-- 
2.5.0
