From: James Smart <james.smart@emulex.com>
Subject: [PATCH 12/21] lpfc 8.3.30: Fixed panic with extents and small blocks
Date: Thu, 1 Mar 2012 22:36:54 -0500
Message-ID: <1330659418.18500.39.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:38860 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757511Ab2CBDhF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Mar 2012 22:37:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed system panic when extents enabled with large number of small blocks


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_sli.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2012-03-01 17:33:43.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2012-03-01 17:33:45.000000000 -0500
@@ -13286,7 +13286,7 @@ lpfc_sli4_post_els_sgl_list_ext(struct l
 	LPFC_MBOXQ_t *mbox;
 	uint32_t reqlen, alloclen, index;
 	uint32_t mbox_tmo;
-	uint16_t rsrc_start, rsrc_size, els_xri_cnt;
+	uint16_t rsrc_start, rsrc_size, els_xri_cnt, post_els_xri_cnt;
 	uint16_t xritag_start = 0, lxri = 0;
 	struct lpfc_rsrc_blks *rsrc_blk;
 	int cnt, ttl_cnt, rc = 0;
@@ -13308,6 +13308,7 @@ lpfc_sli4_post_els_sgl_list_ext(struct l
 
 	cnt = 0;
 	ttl_cnt = 0;
+	post_els_xri_cnt = els_xri_cnt;
 	list_for_each_entry(rsrc_blk, &phba->sli4_hba.lpfc_xri_blk_list,
 			    list) {
 		rsrc_start = rsrc_blk->rsrc_start;
@@ -13317,11 +13318,12 @@ lpfc_sli4_post_els_sgl_list_ext(struct l
 				"3014 Working ELS Extent start %d, cnt %d\n",
 				rsrc_start, rsrc_size);
 
-		loop_cnt = min(els_xri_cnt, rsrc_size);
-		if (ttl_cnt + loop_cnt >= els_xri_cnt) {
-			loop_cnt = els_xri_cnt - ttl_cnt;
-			ttl_cnt = els_xri_cnt;
-		}
+		loop_cnt = min(post_els_xri_cnt, rsrc_size);
+		if (loop_cnt < post_els_xri_cnt) {
+			post_els_xri_cnt -= loop_cnt;
+			ttl_cnt += loop_cnt;
+		} else
+			ttl_cnt += post_els_xri_cnt;
 
 		mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 		if (!mbox)



