From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 2/2] handle scsi_init_queue failure properly
Date: Fri, 25 Jan 2008 23:25:14 +0900
Message-ID: <20080125232451D.tomof@acm.org>
References: <20080125232220M.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:55729 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148AbYAYOZX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jan 2008 09:25:23 -0500
In-Reply-To: <20080125232220M.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

scsi_init_queue is expected to clean up allocated things when it
fails.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_lib.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7bfec7e..b12fb31 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1682,7 +1682,7 @@ int __init scsi_init_queue(void)
 					0, 0, NULL);
 	if (!scsi_bidi_sdb_cache) {
 		printk(KERN_ERR "SCSI: can't init scsi bidi sdb cache\n");
-		return -ENOMEM;
+		goto cleanup_io_context;
 	}
 
 	for (i = 0; i < SG_MEMPOOL_NR; i++) {
@@ -1694,6 +1694,7 @@ int __init scsi_init_queue(void)
 		if (!sgp->slab) {
 			printk(KERN_ERR "SCSI: can't init sg slab %s\n",
 					sgp->name);
+			goto cleanup_bidi_sdb;
 		}
 
 		sgp->pool = mempool_create_slab_pool(SG_MEMPOOL_SIZE,
@@ -1701,10 +1702,25 @@ int __init scsi_init_queue(void)
 		if (!sgp->pool) {
 			printk(KERN_ERR "SCSI: can't init sg mempool %s\n",
 					sgp->name);
+			goto cleanup_bidi_sdb;
 		}
 	}
 
 	return 0;
+
+cleanup_bidi_sdb:
+	for (i = 0; i < SG_MEMPOOL_NR; i++) {
+		struct scsi_host_sg_pool *sgp = scsi_sg_pools + i;
+		if (sgp->pool)
+			mempool_destroy(sgp->pool);
+		if (sgp->slab)
+			kmem_cache_destroy(sgp->slab);
+	}
+	kmem_cache_destroy(scsi_bidi_sdb_cache);
+cleanup_io_context:
+	kmem_cache_destroy(scsi_io_context_cache);
+
+	return -ENOMEM;
 }
 
 void scsi_exit_queue(void)
-- 
1.5.3.4

