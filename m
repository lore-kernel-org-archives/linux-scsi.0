From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] ibmvscsi: convert kmalloc + memset to kcalloc
Date: Fri, 07 Apr 2006 19:10:03 +0900
Message-ID: <20060407191003X.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:52665 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP id S932408AbWDGKKB
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Apr 2006 06:10:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: boutcher@cs.umn.edu
Cc: linux-scsi@vger.kernel.org

Convert kmalloc + memset to kcalloc in ibmvscsi

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---

 drivers/scsi/ibmvscsi/ibmvscsi.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

359289bba3bd58e6650088ff65ff95e9a549efc0
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 0a8ad37..12cb743 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -121,10 +121,9 @@ static int initialize_event_pool(struct 
 
 	pool->size = size;
 	pool->next = 0;
-	pool->events = kmalloc(pool->size * sizeof(*pool->events), GFP_KERNEL);
+	pool->events = kcalloc(pool->size, sizeof(*pool->events), GFP_KERNEL);
 	if (!pool->events)
 		return -ENOMEM;
-	memset(pool->events, 0x00, pool->size * sizeof(*pool->events));
 
 	pool->iu_storage =
 	    dma_alloc_coherent(hostdata->dev,
-- 
1.1.3
