From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 07 of 16] Rename scsi_bidi_sdb_cache
Date: Fri, 25 Apr 2008 19:12:09 -0400
Message-ID: <f37e1616176be729a236.1209165129@sermon.lab.mkp.net>
References: <patchbomb.1209165122@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:44314 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759422AbYDYXR3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2008 19:17:29 -0400
In-Reply-To: <patchbomb.1209165122@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

1 file changed, 13 insertions(+), 13 deletions(-)
drivers/scsi/scsi_lib.c |   26 +++++++++++++-------------


The data integrity changes need to dynamically allocate
scsi_data_buffers too.  Rename scsi_bidi_sdb_cache for clarity.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff -r bfbea544d342 -r f37e1616176b drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	Fri Apr 25 17:39:29 2008 -0400
+++ b/drivers/scsi/scsi_lib.c	Fri Apr 25 17:39:29 2008 -0400
@@ -65,7 +65,7 @@
 };
 #undef SP
 
-static struct kmem_cache *scsi_bidi_sdb_cache;
+static struct kmem_cache *scsi_sdb_cache;
 
 static void scsi_run_queue(struct request_queue *q);
 
@@ -771,7 +771,7 @@
 		struct scsi_data_buffer *bidi_sdb =
 			cmd->request->next_rq->special;
 		scsi_free_sgtable(bidi_sdb);
-		kmem_cache_free(scsi_bidi_sdb_cache, bidi_sdb);
+		kmem_cache_free(scsi_sdb_cache, bidi_sdb);
 		cmd->request->next_rq->special = NULL;
 	}
 }
@@ -1046,7 +1046,7 @@
 
 	if (blk_bidi_rq(cmd->request)) {
 		struct scsi_data_buffer *bidi_sdb = kmem_cache_zalloc(
-			scsi_bidi_sdb_cache, GFP_ATOMIC);
+			scsi_sdb_cache, GFP_ATOMIC);
 		if (!bidi_sdb) {
 			error = BLKPREP_DEFER;
 			goto err_exit;
@@ -1678,11 +1678,11 @@
 		return -ENOMEM;
 	}
 
-	scsi_bidi_sdb_cache = kmem_cache_create("scsi_bidi_sdb",
-					sizeof(struct scsi_data_buffer),
-					0, 0, NULL);
-	if (!scsi_bidi_sdb_cache) {
-		printk(KERN_ERR "SCSI: can't init scsi bidi sdb cache\n");
+	scsi_sdb_cache = kmem_cache_create("scsi_sdb",
+					   sizeof(struct scsi_data_buffer),
+					   0, 0, NULL);
+	if (!scsi_sdb_cache) {
+		printk(KERN_ERR "SCSI: can't init scsi sdb cache\n");
 		goto cleanup_io_context;
 	}
 
@@ -1695,7 +1695,7 @@
 		if (!sgp->slab) {
 			printk(KERN_ERR "SCSI: can't init sg slab %s\n",
 					sgp->name);
-			goto cleanup_bidi_sdb;
+			goto cleanup_sdb;
 		}
 
 		sgp->pool = mempool_create_slab_pool(SG_MEMPOOL_SIZE,
@@ -1703,13 +1703,13 @@
 		if (!sgp->pool) {
 			printk(KERN_ERR "SCSI: can't init sg mempool %s\n",
 					sgp->name);
-			goto cleanup_bidi_sdb;
+			goto cleanup_sdb;
 		}
 	}
 
 	return 0;
 
-cleanup_bidi_sdb:
+cleanup_sdb:
 	for (i = 0; i < SG_MEMPOOL_NR; i++) {
 		struct scsi_host_sg_pool *sgp = scsi_sg_pools + i;
 		if (sgp->pool)
@@ -1717,7 +1717,7 @@
 		if (sgp->slab)
 			kmem_cache_destroy(sgp->slab);
 	}
-	kmem_cache_destroy(scsi_bidi_sdb_cache);
+	kmem_cache_destroy(scsi_sdb_cache);
 cleanup_io_context:
 	kmem_cache_destroy(scsi_io_context_cache);
 
@@ -1729,7 +1729,7 @@
 	int i;
 
 	kmem_cache_destroy(scsi_io_context_cache);
-	kmem_cache_destroy(scsi_bidi_sdb_cache);
+	kmem_cache_destroy(scsi_sdb_cache);
 
 	for (i = 0; i < SG_MEMPOOL_NR; i++) {
 		struct scsi_host_sg_pool *sgp = scsi_sg_pools + i;


