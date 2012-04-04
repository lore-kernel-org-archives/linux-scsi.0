From: michaelc@cs.wisc.edu
Subject: [PATCH 07/17] be2iscsi:Fix double free of MCCQ info memory.
Date: Tue,  3 Apr 2012 23:41:42 -0500
Message-ID: <1333514512-21799-8-git-send-email-michaelc@cs.wisc.edu>
References: <1333514512-21799-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964Ab2DDEmF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Apr 2012 00:42:05 -0400
In-Reply-To: <1333514512-21799-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 In case of MCC_Q creation failed, the MCCQ info memory is freed
 from be_mcc_queues_destroy and be_mcc_queues_create. This caused
 kernel to panic because of double free.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
dd
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_main.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index f761924..7291d6e 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -2908,9 +2908,11 @@ beiscsi_post_pages(struct beiscsi_hba *phba)
 static void be_queue_free(struct beiscsi_hba *phba, struct be_queue_info *q)
 {
 	struct be_dma_mem *mem = &q->dma_mem;
-	if (mem->va)
+	if (mem->va) {
 		pci_free_consistent(phba->pcidev, mem->size,
 			mem->va, mem->dma);
+		mem->va = NULL;
+	}
 }
 
 static int be_queue_alloc(struct beiscsi_hba *phba, struct be_queue_info *q,
-- 
1.7.7.6

