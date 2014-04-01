From: Maurizio Lombardi <mlombard@redhat.com>
Subject: [PATCH 3/3] bnx2fc: fix memory leak in bnx2fc_allocate_hash_table()
Date: Tue,  1 Apr 2014 13:58:22 +0200
Message-ID: <1396353502-30083-4-git-send-email-mlombard@redhat.com>
References: <1396353502-30083-1-git-send-email-mlombard@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbaDAL6k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Apr 2014 07:58:40 -0400
In-Reply-To: <1396353502-30083-1-git-send-email-mlombard@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, m.lombardi85@gmail.com, eddie.wai@broadcom.com

In case of error, the bnx2fc_allocate_hash_table() didn't free
all the memory it allocated.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/scsi/bnx2fc/bnx2fc_hwi.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index f83bae4..512aed3 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -2026,7 +2026,7 @@ static int bnx2fc_allocate_hash_table(struct bnx2fc_hba *hba)
 	dma_segment_array = kzalloc(dma_segment_array_size, GFP_KERNEL);
 	if (!dma_segment_array) {
 		printk(KERN_ERR PFX "hash table pointers (dma) alloc failed\n");
-		return -ENOMEM;
+		goto cleanup_ht;
 	}
 
 	for (i = 0; i < segment_count; ++i) {
@@ -2037,15 +2037,7 @@ static int bnx2fc_allocate_hash_table(struct bnx2fc_hba *hba)
 					   GFP_KERNEL);
 		if (!hba->hash_tbl_segments[i]) {
 			printk(KERN_ERR PFX "hash segment alloc failed\n");
-			while (--i >= 0) {
-				dma_free_coherent(&hba->pcidev->dev,
-						    BNX2FC_HASH_TBL_CHUNK_SIZE,
-						    hba->hash_tbl_segments[i],
-						    dma_segment_array[i]);
-				hba->hash_tbl_segments[i] = NULL;
-			}
-			kfree(dma_segment_array);
-			return -ENOMEM;
+			goto cleanup_dma;
 		}
 		memset(hba->hash_tbl_segments[i], 0,
 		       BNX2FC_HASH_TBL_CHUNK_SIZE);
@@ -2057,8 +2049,7 @@ static int bnx2fc_allocate_hash_table(struct bnx2fc_hba *hba)
 					       GFP_KERNEL);
 	if (!hba->hash_tbl_pbl) {
 		printk(KERN_ERR PFX "hash table pbl alloc failed\n");
-		kfree(dma_segment_array);
-		return -ENOMEM;
+		goto cleanup_dma;
 	}
 	memset(hba->hash_tbl_pbl, 0, PAGE_SIZE);
 
@@ -2083,6 +2074,22 @@ static int bnx2fc_allocate_hash_table(struct bnx2fc_hba *hba)
 	}
 	kfree(dma_segment_array);
 	return 0;
+
+cleanup_dma:
+	for (i = 0; i < segment_count; ++i) {
+		if (hba->hash_tbl_segments[i])
+			dma_free_coherent(&hba->pcidev->dev,
+					    BNX2FC_HASH_TBL_CHUNK_SIZE,
+					    hba->hash_tbl_segments[i],
+					    dma_segment_array[i]);
+	}
+
+	kfree(dma_segment_array);
+
+cleanup_ht:
+	kfree(hba->hash_tbl_segments);
+	hba->hash_tbl_segments = NULL;
+	return -ENOMEM;
 }
 
 /**
-- 
Maurizio Lombardi

