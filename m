From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] qla4xxx: use mempool_create_slab_pool
Date: Wed, 25 Jul 2007 09:01:41 +0900
Message-ID: <20070725090141E.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:49772 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757070AbXGYABy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jul 2007 20:01:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: david.somayajulu@qlogic.com
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/qla4xxx/ql4_os.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index e69160a..15ff730 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -576,8 +576,7 @@ static int qla4xxx_mem_alloc(struct scsi_qla_host *ha)
 						   QUEUE_SIZE));
 
 	/* Allocate memory for srb pool. */
-	ha->srb_mempool = mempool_create(SRB_MIN_REQ, mempool_alloc_slab,
-					 mempool_free_slab, srb_cachep);
+	ha->srb_mempool = mempool_create_slab_pool(SRB_MIN_REQ, srb_cachep);
 	if (ha->srb_mempool == NULL) {
 		dev_warn(&ha->pdev->dev,
 			"Memory Allocation failed - SRB Pool.\n");
-- 
1.5.2.4

