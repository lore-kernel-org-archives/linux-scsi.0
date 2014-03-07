From: Maurizio Lombardi <mlombard@redhat.com>
Subject: [PATCH 2/2] bnx2fc: fix memory leak and potential NULL pointer dereference.
Date: Fri,  7 Mar 2014 15:37:46 +0100
Message-ID: <1394203066-13515-3-git-send-email-mlombard@redhat.com>
References: <1394203066-13515-1-git-send-email-mlombard@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753028AbaCGOiI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Mar 2014 09:38:08 -0500
In-Reply-To: <1394203066-13515-1-git-send-email-mlombard@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: eddie.wai@broadcom.com
Cc: linux-scsi@vger.kernel.org, jbottomley@parallels.com, m.lombardi85@gmail.com

If bnx2fc_allocate_hash_table() for some reasons fails, it is possible that the
hash_tbl_segments or the hash_tbl_pbl pointers are NULL.
In this case bnx2fc_free_hash_table() will panic the system.

this patch also fixes a memory leak, the hash_tbl_segments pointer was never
freed.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/scsi/bnx2fc/bnx2fc_hwi.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index 261af2a..f83bae4 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -1968,21 +1968,27 @@ static void bnx2fc_free_hash_table(struct bnx2fc_hba *hba)
 	int segment_count;
 	u32 *pbl;
 
-	segment_count = hba->hash_tbl_segment_count;
-
-	pbl = hba->hash_tbl_pbl;
-	for (i = 0; i < segment_count; ++i) {
-		dma_addr_t dma_address;
-
-		dma_address = le32_to_cpu(*pbl);
-		++pbl;
-		dma_address += ((u64)le32_to_cpu(*pbl)) << 32;
-		++pbl;
-		dma_free_coherent(&hba->pcidev->dev,
-				  BNX2FC_HASH_TBL_CHUNK_SIZE,
-				  hba->hash_tbl_segments[i],
-				  dma_address);
+	if (hba->hash_tbl_segments) {
+
+		pbl = hba->hash_tbl_pbl;
+		if (pbl) {
+			segment_count = hba->hash_tbl_segment_count;
+			for (i = 0; i < segment_count; ++i) {
+				dma_addr_t dma_address;
+
+				dma_address = le32_to_cpu(*pbl);
+				++pbl;
+				dma_address += ((u64)le32_to_cpu(*pbl)) << 32;
+				++pbl;
+				dma_free_coherent(&hba->pcidev->dev,
+						  BNX2FC_HASH_TBL_CHUNK_SIZE,
+						  hba->hash_tbl_segments[i],
+						  dma_address);
+			}
+		}
 
+		kfree(hba->hash_tbl_segments);
+		hba->hash_tbl_segments = NULL;
 	}
 
 	if (hba->hash_tbl_pbl) {
-- 
Maurizio Lombardi

